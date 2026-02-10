Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F0C0EF0702
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 04:54:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 017DE6B0005; Mon,  9 Feb 2026 23:54:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F3AB06B0088; Mon,  9 Feb 2026 23:54:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E3D176B0089; Mon,  9 Feb 2026 23:54:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D315A6B0005
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 23:54:22 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8E45216037F
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 04:54:22 +0000 (UTC)
X-FDA: 84427330764.03.FEF66F5
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	by imf26.hostedemail.com (Postfix) with ESMTP id 9E4B0140006
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 04:54:20 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=zytor.com header.s=2026012301 header.b=yNvTN0pe;
	spf=pass (imf26.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com;
	dmarc=pass (policy=none) header.from=zytor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770699260;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2bNWrVed5hiVY9k9jymxZoTWwuaSvQ8Ymeerd9cVzBw=;
	b=C8LyYOBaG73TSRznVcud++5fapFuIYaTqvAzCzWJQ8gh8oNvuiO+kEPfnvYQmvaYFa4tU4
	MezRl0nYdjMSy3GtFCiG3YfEuXaTBZgZrmqoQyAQiH/ZDhMuiIa3pe0zEbYjnl63Qys389
	F/lg9P9XXOFZWrqGBbLbWa3YUKwjGuw=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=zytor.com header.s=2026012301 header.b=yNvTN0pe;
	spf=pass (imf26.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com;
	dmarc=pass (policy=none) header.from=zytor.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770699260; a=rsa-sha256;
	cv=none;
	b=ZDPWuqj8DUcHHJVUQY+XVvs61DpOjyHNsnZivnRw4GTtxvlHDVtvadnI9HtQn0gSM5izsR
	Xrl2anG7zSrH4OIta8tbsLij3wQIxjSh4Uwjohj+yIiF6AQugtXKyw0q7zwWUP0vdrP5Yz
	JFzyQ1t84iHpqI5orY9fY9amjPmUfzo=
Received: from [172.27.2.41] (c-76-133-66-138.hsd1.ca.comcast.net [76.133.66.138])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 61A4rgZ73161123
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Mon, 9 Feb 2026 20:53:46 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 61A4rgZ73161123
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2026012301; t=1770699228;
	bh=2bNWrVed5hiVY9k9jymxZoTWwuaSvQ8Ymeerd9cVzBw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=yNvTN0pe26bHPATpWFRmwqoqklz5c582dxuNgT4A/bKgN5pLU0jFAk575K6BAd7+z
	 xjLjpkuwenalssCyfl3PszY8fLDEayQ8hcTTGn+tB/8kkpANRtL2yyfT0pzKn3Qk/Q
	 Oybo3fCBQomkN8XJpiXZRSKFK69skiMIqwSuGPXoIZBFmoMQHX2YBhcbdwfnuv5ORE
	 +eNmfFqsmXqBFZyJkX9HByk17dT4BABUHjI8Yrf6HqPH7iGhASa66yiYG7MiA0BZy2
	 9/8VepqAkbm9byqAFURrIdCJTM2jyWhYHNcFYVz15MkRx4dBdpBG5B3zZ/dEbXygw6
	 ZpOAU1e3xBIBw==
Message-ID: <bbd9ee1e-d604-43d6-9cb5-77e2972807ef@zytor.com>
Date: Mon, 9 Feb 2026 20:53:37 -0800
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
 <29D95765-BD93-451D-8FD8-54250ADE1DEB@zytor.com>
 <0ee773dea213f6efbdac03009ee80f350b17c949.camel@xry111.site>
Content-Language: en-US, sv-SE
From: "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <0ee773dea213f6efbdac03009ee80f350b17c949.camel@xry111.site>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9E4B0140006
X-Stat-Signature: 44ofghb66waid8o5ktf9h6qi6datzwms
X-Rspam-User: 
X-HE-Tag: 1770699260-970720
X-HE-Meta: U2FsdGVkX1/KGb8Bo8cX/4bk07XkytAKyIERNEadqcjqzvbwxUQ55OOu4YBD9tyjiF0ocb0dPvRLhOyB68auuaTs42vAqpfBaVhKz9wy7NR469jdxouL8i9Dx25/APh5MF8CLXumheebTMu0TqzBv69htKfLRTzH2/Zhd6TmK4XNZOmV80qlyLAZVFdqlHPmbijCzO2meQAXreQhTNA5/jw47gc7EmX0m+pQW2Yps/Epy769FWT3Q8+81XRY1W2z2mjoKQi1KWbY+BX8dnHJt0xNdnFJW8+efjQHVQ76Xv5ylFdFl3ZxeGr5MzjLAo4P6u7vCbFLYSBZ+X2VH5Os6UklrZGPt7yPNf34Ok3KjZppMEhklBIWjfDRtb2DzMhq1f83oT2Dku0H+wKg6p1FRNyXuBMzGlPlK2XPCW3+BcCpVCLazv2uprMl3tVtcLh8YgvAICGFpHrPS5FVPhz44JvUdhcVKipEtOLrO+5JeHphgmkFFHB+KCsaUyxRtTPKEjaKjQyrfL9TxOQWTVFI5Ui82WpwJih8hXjvYjBwwVvpOK0GlPJ7B3CMPIbqE/uIW+M3kkJG1QlLhCUlbl3ZYppketxjkF6ZbuXodWUJRkBhcw+IOaS4v5PLA46NQ4gqzMwZ0nDVQNUmuLtA+HyPBh+Qo5A9KPIKFk77XyaYqPD9G8bwcAm9LdyTnPqSNOD519764SmBAjGSZq1zhfTz1qwdQWhCvlSxMJ5J2V89XPxHJwBInaq48lUDVZMerx62rtUOhMt6FvsiLaHTRimGqnNTSLvtgWYL6xqMqtDV+DITeQT1mDRAO2lt3KIK4hc+6tjcAsabssS9hl4svT9dCEkeYZvW//iJR0O8LCV6VyR4BHAGUn97WOPoqqtdAwnH8BgYgjxZT8BYEW/jo/9gPHzgn96CrD0bcy2/R2bSGNgu0twVg/TFgYjhUcGUSjWGciz9ZtDArNDRxuzBXa3
 jCzg1IrX
 7SWPb9FqSQOttvk/b4LLudj2GhnGgfpfDJo3J866GfiIEPYeRe3c+MFK/TTdwUte0P3n/OPMT9sPA3o8y7cK/w6Yht2HMRQ8Xp5LeWaCl9AK97jsRGItnKaoFIY6H0yiI4RZqUhWgOScJinls1c7GDRQepoq47hyXV6Np/5HWYztKoHqsr0U9jIpfB24fiBKoEwZiTIwL6AesIL4eAOnb/21T4PWObUjDBDiFbKa0l0qoIiLXvU5jarefs1I5LKLVeZEIIrhnqApWuoL7D/diWeXEe9mFiRN3mVhQNt/68YtDPS2GhOcP4+HFv3YkVRVfLZOjwZ6O9EGGCKwN0oNrPwy6Rg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-02-09 20:45, Xi Ruoyao wrote:
>>
>> Oh, good grief...
>>
>> How does this possibly work on non-x86 platforms?
> 
> On ARM64 the vdso does not have eh_frame_hdr at all, on LoongArch
> eh_frame_hdr is empty (note that an ampty en_frame_hdr is actually buggy
> and I'm trying to fix it), so _Unwind_Find_FDE returns NULL and libgcc
> falls back to MD_FALLBACK_FRAME_STATE_FOR, which handles the sigreturn
> trampoline using some machine-dependant logic.
> 
> On RISC-V things are more theatrical: the sigreturn trampoline happens
> to be at the beginning of the vdso .text section, so after subtracting 1
> from the PC, the result is out of the .text section and so not in any
> FDE.  Thus _Unwind_Find_FDE returns NULL and libgcc again falls back to
> MD_FALLBACK_FRAME_STATE_FOR.
> 
> If the RISC-V sigreturn trampoline was not the first in .text,
> subtracting 1 would cause the PC to be in the FDE of the previous
> function and then _Unwind_Find_FDE would return that FDE, then RISC-V
> would have some big trouble.
> 
> I've not taken a serious look at other architectures yet.
> 

In other words, it is broken on pretty much all architectures and it ends up
using the hacky fallbacks on every single platform...

	-hpa


