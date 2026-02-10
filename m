Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44BD0E94619
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 04:52:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5240A6B0088; Mon,  9 Feb 2026 23:52:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D1B66B0089; Mon,  9 Feb 2026 23:52:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B3906B008A; Mon,  9 Feb 2026 23:52:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2A2146B0088
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 23:52:50 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B404216037B
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 04:52:49 +0000 (UTC)
X-FDA: 84427326858.23.ED09F96
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	by imf24.hostedemail.com (Postfix) with ESMTP id A728E18000D
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 04:52:47 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=zytor.com header.s=2026012301 header.b=U3YJJY9V;
	dmarc=pass (policy=none) header.from=zytor.com;
	spf=pass (imf24.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770699168; a=rsa-sha256;
	cv=none;
	b=c6U/i/lS/n7Q7e/dPjjCVNwburwBZ4vv6iLgOJWU9dQ0elHNLafnFBuOzkDuTubzE817mc
	Ao1AlxZa2sTUuhyWteo+NrGyrb3XjGw86q8/aI90dBklcul32c/GQEg6UC6l7t0xJ442rc
	59wQCAHXBR9gzQt+fOxA7ts8wSo08wc=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=zytor.com header.s=2026012301 header.b=U3YJJY9V;
	dmarc=pass (policy=none) header.from=zytor.com;
	spf=pass (imf24.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770699168;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g6Bj9LqRZNb1Yp1MwzoKZ+DxFnZS60EAUBqk+I/vrKA=;
	b=oWwudgQq70AtGGr0NDgD4rS+D3qMsUveETp3CZfe5bwyNul9hsUi7+yKAwOXk42gUCLVVB
	YRsrHqLWyGp76SQZULkaz3/35OAu1spo7+92nBEvVqYo5Ioj08cbukfj0nv7e3D4xQA5hH
	wnhE12LqW1kJEV6XqVx0fk54V/9cMCg=
Received: from [172.27.2.41] (c-76-133-66-138.hsd1.ca.comcast.net [76.133.66.138])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 61A4psgr3160871
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Mon, 9 Feb 2026 20:52:05 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 61A4psgr3160871
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2026012301; t=1770699127;
	bh=g6Bj9LqRZNb1Yp1MwzoKZ+DxFnZS60EAUBqk+I/vrKA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=U3YJJY9VPXOQ8GoHouAoNKsb/wnuYIFZ5qXGKGfKdPBr7nLC+uNK+/acw+eMXOysa
	 GHXgPIfej78y8lFjARzluEBFtc8yihuq6sJvIHwss9+wY7BHgTlV7gXydNMQ2R5nrw
	 pPvxe1a+abPE5I7+W/ey+zW6IjRJ2Km9kE+hySRH+LoyTesdmy4Nfw3deVicsVnepZ
	 XvLtSXstteO46AYNEk8SXCcdIAhyKFQdO+gOnVfJ2q/A+SnA60IZ0XN60wwQI/CoED
	 PNHvXpkE3sTrUZ5B8kjdNuYwUxKhaMLmk2VaLeJdLWhh5yAShx2aRteOzQ0xfipOda
	 0cBLpjgso0O+A==
Message-ID: <e31817cb-c102-485c-8844-d81c39eac442@zytor.com>
Date: Mon, 9 Feb 2026 20:51:45 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4.1 06/10] x86/entry/vdso32: remove open-coded DWARF in
 sigreturn.S
To: Xi Ruoyao <xry111@xry111.site>, Jens Remus <jremus@linux.ibm.com>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        =?UTF-8?Q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
        Xin Li <xin@zytor.com>, Andrew Cooper <andrew.cooper3@citrix.com>,
        Andy Lutomirski <luto@kernel.org>, Ard Biesheuvel <ardb@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Brian Gerst <brgerst@gmail.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>, James Morse <james.morse@arm.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>, Kees Cook <kees@kernel.org>,
        Nam Cao <namcao@linutronix.de>, Oleg Nesterov <oleg@redhat.com>,
        Perry Yuan <perry.yuan@amd.com>, Thomas Gleixner <tglx@linutronix.de>,
        Thomas Huth <thuth@redhat.com>, Uros Bizjak <ubizjak@gmail.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-sgx@vger.kernel.org, x86@kernel.org,
        Indu Bhagat <indu.bhagat@oracle.com>,
        Claudiu Zissulescu-Ianculescu <claudiu.zissulescu-ianculescu@oracle.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>
References: <vdso-cleanup-patch-4.1@zytor.com>
 <20260106211856.560186-6-hpa@zytor.com>
 <223707e2-3231-4037-bd1f-490ddf6aeeb6@linux.ibm.com>
 <B4C09939-9216-457E-8C93-052521FFE96F@zytor.com>
 <f3412cc3e8f66d1853cc9d572c0f2fab076872b1.camel@xry111.site>
Content-Language: en-US, sv-SE
From: "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <f3412cc3e8f66d1853cc9d572c0f2fab076872b1.camel@xry111.site>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: A728E18000D
X-Stat-Signature: hci6ie7ewqy9xk1qjnrtuzcdecetxnxt
X-HE-Tag: 1770699167-823307
X-HE-Meta: U2FsdGVkX1/zdhEuVfoY1YuR/8ByATJ6+rvaKyRKXPSttySJ9QDTbez3qA3b8anNVdj9UuftuD7DyYEhssQGjUMtcNtPqUFuxIZHsMqoghte0m+qBj1o7jqmkEyObvPvz24sz2C0hrwXHfiuL+fl+0pFvlUEAssWn//N1RJ4zLvRPAXZETTkL2vTQqVkrMtGqTJm0d3p2oVlM9crPN6GOd7VpvuQsO2hW28kVwYTpLQZv3n4VsuS8DLwva8UzUlbgO3py1HaeG1ARr0aZu+7DMxpNQP9FWe7cc977Cl+/ZssHupkM8N13p2nnObshdD67GKciFKwyEOuYnBG7/TY8qpAIVHEyPgPWhUBG3vulGuwmqDo/I9/rQilIUTaGGBr4xPRlTj7chl1RV7zVQpvoZN+zb6unYbzbQt+CNK1qu8+aiK5xibRg55HDqP4grVBOylKmL3dhVsAIOEO+TIfPDswlbrdQRLzQ1xI9B5fM6sSB+TesrPV889Xkon2HXezMxjFDYg0vniIHbjEcBzpWoquOTPmmcSlYiZGZGQXuYxNJ5oQvDu0MlcuY8XCg5LK9J4M7YPCENC9jiiEozvJGuLAYJD60Sl2VzAszzlvaoJYOWEkjGh6rhkjBtgwzXad3HB30uZzsdRss+oLGBl6XZjBrYoW5TpSvMOGo4FPB83q1PdcfsHuocI8lmE5AhmUbO89Hv+JgcCDlSu023yVvxsQQsuiWVONKkbbpKFOuGY4s5xts3wFMIKsEwZzveoDVGqvIGe4f5ax+QRYvoEDlsM9X94CGaDAI9WxG7hJSsBMbMyo2+dY9xfoKoEQf9vuzIdRa00e+qusCtk+H8zH6Hzp1Dnpab9+Ly1bBKmwu6qRWaKlz//H/TnIM8haPeoNdlyhcraKea32C38RIK5qp9KHdzaaIwDk/GYjdeFO/akwRKA/8Sny8RKgNFoy+dka0mHMfmPGioCXzttCPon
 dUP5Vqmc
 VXtcvUnFAV23PWAD5U3JYS8wLWBgQlgnhmS6pO3rXThpt32U=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-02-09 19:11, Xi Ruoyao wrote:
> On Mon, 2026-02-02 at 19:57 -0800, H. Peter Anvin wrote:
>> That hack dates back from before the signal frame extension. It is no
>> longer necessary.
> 
> Unfortunately at least it seems libgcc unwinder does not handle the
> signal frame extension properly.  The code reads:
> 
>   fde = _Unwind_Find_FDE (context->ra + _Unwind_IsSignalFrame (context) - 1, 
>                           &context->bases);
>   if (fde == NULL)
>     {    
> #ifdef MD_FALLBACK_FRAME_STATE_FOR
>       /* Couldn't find frame unwind info for this function.  Try a
>          target-specific fallback mechanism.  This will necessarily
>          not provide a personality routine or LSDA.  */
>       return MD_FALLBACK_FRAME_STATE_FOR (context, fs); 
> #else
>       return _URC_END_OF_STACK;
> #endif
>     }    
> 
>   fs->pc = context->bases.func;
> 
>   cie = get_cie (fde);
>   insn = extract_cie_info (cie, context, fs); 
> 
> Thus, it indeed attempts to avoid subtracting 1 for a signal frame, but
> ... _Unwind_IsSignalFrame (context) actually extracts a flag in context
> which will only be raised up by extract_cie_info.
> 
> Or am I missing something here?
> 

Well, it looks like this might be a non-manifest bug on x86 *IN THIS CASE*,
because the fallback handler looks explicitly for the byte sequences:

	popl %eax
	movl $__NR_ia32_sigreturn, %eax
	int $0x80

	movl $__NR_ia32_rt_sigreturn, %eax
	int $0x80

	movq $__NR_x64_rt_sigreturn, %rax	/* !!!! */
	syscall

... so the vdso patchset is still OK.

Hard-coding a reliance on movq in the 64-bit sequence some serious brain damage...

Could you file a gcc bug on this?

	-hpa


