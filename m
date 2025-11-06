Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 827C0CCFA05
	for <linux-mm@archiver.kernel.org>; Thu,  6 Nov 2025 10:39:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF48E8E0009; Thu,  6 Nov 2025 05:39:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCCDF8E0002; Thu,  6 Nov 2025 05:39:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE2148E0009; Thu,  6 Nov 2025 05:39:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 98B9D8E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 05:39:34 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 422FD160614
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 10:39:34 +0000 (UTC)
X-FDA: 84079835868.29.681B937
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf25.hostedemail.com (Postfix) with ESMTP id B4A41A0003
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 10:39:31 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=fGUAu15u;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=yGWAfYfM;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=fGUAu15u;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=yGWAfYfM;
	spf=pass (imf25.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762425572;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LUC894EkN1Ri8Isz8oVgyo60pIndnmnfMDWBoq1SCQk=;
	b=h9YQ6sL+qnsejPPArPYG+uRMH9Y1uZX96v53EUwIGpyUc7XlPlpg/1P0K80lJFkb4rZ0LP
	B7JiMnQ+aEwj23NqCoAIuhf8xcI03aL1vMx9Nr02OfGM0o3osb7FxQxvlYLHIRx9WSNxt8
	PhhrFFlY+RCeIJzcFOokZ+84zMUWmtI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762425572; a=rsa-sha256;
	cv=none;
	b=boouVMEexuKdPd8HX0WujcwISlIh4ChiR91vbMqRCQ6xmxfEKKDhbjHoClZ0HrTdEuZ73y
	Od2mGdYYkST/2Exh1Ea5H0SPUS/U1/x7eQcaEWKhgpIpKtL9iByapfFWeIS5cj4XwwegQe
	Po0dZzH/+JO80IUuYMq0D2R+ozn+KeU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=fGUAu15u;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=yGWAfYfM;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=fGUAu15u;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=yGWAfYfM;
	spf=pass (imf25.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 8A48A211D0;
	Thu,  6 Nov 2025 10:39:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762425569; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LUC894EkN1Ri8Isz8oVgyo60pIndnmnfMDWBoq1SCQk=;
	b=fGUAu15uukdcYPvh1QKp+k56esnXoryL6xnIi5ODC6JToaAfcaF9vYJeuYfHn4kXuJI2nv
	UHVoPzZhRgqu8T+IdbjbP3PGxvK+aLqiBQgrkAVnyR8sXrE2T9E6zPeA+zDRdyrmX1WWiv
	ME3qg7zXFhXaN3ImX1c6orASo5qj15E=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762425569;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LUC894EkN1Ri8Isz8oVgyo60pIndnmnfMDWBoq1SCQk=;
	b=yGWAfYfMI92bWPSsIXCYdU4IRWi5rLaW5zOC6GadK9cXmb1ZfnC+wuU2cNBPUDV/39oksx
	BF4ohMLXDOywqvDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762425569; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LUC894EkN1Ri8Isz8oVgyo60pIndnmnfMDWBoq1SCQk=;
	b=fGUAu15uukdcYPvh1QKp+k56esnXoryL6xnIi5ODC6JToaAfcaF9vYJeuYfHn4kXuJI2nv
	UHVoPzZhRgqu8T+IdbjbP3PGxvK+aLqiBQgrkAVnyR8sXrE2T9E6zPeA+zDRdyrmX1WWiv
	ME3qg7zXFhXaN3ImX1c6orASo5qj15E=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762425569;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LUC894EkN1Ri8Isz8oVgyo60pIndnmnfMDWBoq1SCQk=;
	b=yGWAfYfMI92bWPSsIXCYdU4IRWi5rLaW5zOC6GadK9cXmb1ZfnC+wuU2cNBPUDV/39oksx
	BF4ohMLXDOywqvDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6B3FF13A31;
	Thu,  6 Nov 2025 10:39:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id WXyXGeF6DGmTXAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Thu, 06 Nov 2025 10:39:29 +0000
Message-ID: <13c7242e-3a40-469b-9e99-8a65a21449bb@suse.cz>
Date: Thu, 6 Nov 2025 11:39:28 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/2] mm/ksm: fix flag-dropping behavior in ksm_madvise
Content-Language: en-US
To: Jakub Acs <acsjakub@amazon.de>, linux-mm@kvack.org,
 Hugh Dickins <hughd@google.com>, Jann Horn <jannh@google.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: akpm@linux-foundation.org, david@redhat.com, xu.xin16@zte.com.cn,
 chengming.zhou@linux.dev, peterx@redhat.com, axelrasmussen@google.com,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20251001090353.57523-1-acsjakub@amazon.de>
 <20251001090353.57523-2-acsjakub@amazon.de>
From: Vlastimil Babka <vbabka@suse.cz>
In-Reply-To: <20251001090353.57523-2-acsjakub@amazon.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: B4A41A0003
X-Stat-Signature: 7yo6jznrrrsu4ukj65osdxoqemuu7dct
X-HE-Tag: 1762425571-732423
X-HE-Meta: U2FsdGVkX1/pZhOQkJg5ratQrS1ZMKbn/Uno5oz/lr+CEZj7Gv+q8xIFgGrC/1iOOHRCZ+kt5P9BQT7tdv5Uk3tbXIWmLeibZOzGx2DKC4GOzbMQedOiHoFnQppl6aKP289edwWcQ+RPEYPwzN/oCBi6FhDV6W8/faOsDVr3VrpQKv86CQOmsTe69tEcEI5V8KA5++pSv+dIL9cJAFwSlE0/xe1rPO1DCaZewiIR9qB4CwkG+7I8fV9y6C/L7tWgbw3nobmnDlaZIxnQli5l7bNSl6oMA5ga7a+SaSQfjco5Qre/rJLA2q/0VeScSYEfn3PlxkARNC1QMBCCPHGB63OTJDp8d03rhcVzhDu1XD0eTSfHilXQSjKhoTPAIvSAbYZP63Q4OtqcUmuORDBoi8WkTfDB3n7Xf0Z5hJhs56D+lQGYSNM/QqnS7XvX18gEfa44f1Xi2cHbuDBcnyT4TbC1BZ3vnjz/wKepmwvbKKXVQRZCp3onSew4Ck+KSFbwjhhcOCnGnLMnqPcTZEd/hk0UU6Egj0HcJw2Yuh24qMeZP2+Lrho41o0eAkhlDDyytUNo1wh6VmamFPU/S2M3B3Da5Gh8Wrh2c4WYrTo9EEENcexlmXZuSnG9CEzm7jsvKbHPQ/otknh+w9NTHvThXvzIEOwxxFHXVbmB0fBtBG9MV8sGBMyh0ZntxBIVcILwXgbjEQGYF5bpVrmIUaSliBGuApmVd0y75PT2/6C/on4NFZnQ0q+CmVQoo2mr1KeeboTD8r9l+6WueabFRC0AinYx7Ah1068DE7Ng/8a67B8nXWqj/DDYLdL87S+re+sqvST7QwXLSL97DoJOcN+GC5SPunNPoRyfUuzfuCb1A5Ig2AsIqQ58NWqQJwqh8L/CC/x4q1BFCrEzKWhWkRkWv5D/dCV3uDACpmAFNl3hyMG7KS2IxL0T4j6FgJh+xofUQLiwu5eiVHN6D7pNfAB
 7mIqiDb6
 zw0rqkNjAG9TwuGUeI9jKvRpGpVcUZUbI6WyASEIiGoqFfCs55C/kP624F/1oYJjKt32ZopRrk6DMOhEnldHntmdrBgX4z/sGcRHkJOmHNWx6N/E0ErTU78E8W8ERreOfPoW/F0gRRkL3tvoa/RrDmykKlAyhnKV70LoNrMdqZcJ3Th3JWyu4SS03t6Nz0UyaYR7XflUxJacRtIyPYDeI8lCJ89AwGoWllWc+JbKqzAQoykRpWC24+v/cARsDJ7OLEl1/EYlaU5bfKNNC41cyIOv1g6j6bUFKeg7Ez81qZShkaMKPQcXT9BNQ+h7NeJT9g1xMSTDfMrGty0uoW+owTl9eFiMoMIXrOd5cf1etKKClI/7Y9dmQlLuibHfJJtEuhRyDi50QjDgB2wBXcWRGFewNtyUfz4FNlzQFLkaVVINZrcwrmU27DaPs9akDy92FOsbAs42+u0mYo9umDt8i9NG99lpGA1RiHbjmyuMZV/VSFc3VqihtDiBxM2y6RF0EJXkVGXdeJxpY5nAQ2q9M8JXkwfFfs2yxEC1a24R/v9Ru1zH4hHfnyqLk58Ef3sJ1AxGPor908nyZ4FyRYST1o3byBdM5/B4a7/+F
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/1/25 11:03, Jakub Acs wrote:
> syzkaller discovered the following crash: (kernel BUG)
> 
> [   44.607039] ------------[ cut here ]------------
> [   44.607422] kernel BUG at mm/userfaultfd.c:2067!
> [   44.608148] Oops: invalid opcode: 0000 [#1] SMP DEBUG_PAGEALLOC KASAN NOPTI
> [   44.608814] CPU: 1 UID: 0 PID: 2475 Comm: reproducer Not tainted 6.16.0-rc6 #1 PREEMPT(none)
> [   44.609635] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.3-0-ga6ed6b701f0a-prebuilt.qemu.org 04/01/2014
> [   44.610695] RIP: 0010:userfaultfd_release_all+0x3a8/0x460
> 
> <snip other registers, drop unreliable trace>
> 
> [   44.617726] Call Trace:
> [   44.617926]  <TASK>
> [   44.619284]  userfaultfd_release+0xef/0x1b0
> [   44.620976]  __fput+0x3f9/0xb60
> [   44.621240]  fput_close_sync+0x110/0x210
> [   44.622222]  __x64_sys_close+0x8f/0x120
> [   44.622530]  do_syscall_64+0x5b/0x2f0
> [   44.622840]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
> [   44.623244] RIP: 0033:0x7f365bb3f227
> 
> Kernel panics because it detects UFFD inconsistency during
> userfaultfd_release_all(). Specifically, a VMA which has a valid pointer
> to vma->vm_userfaultfd_ctx, but no UFFD flags in vma->vm_flags.
> 
> The inconsistency is caused in ksm_madvise(): when user calls madvise()
> with MADV_UNMEARGEABLE on a VMA that is registered for UFFD in MINOR
> mode, it accidentally clears all flags stored in the upper 32 bits of
> vma->vm_flags.
> 
> Assuming x86_64 kernel build, unsigned long is 64-bit and unsigned int
> and int are 32-bit wide. This setup causes the following mishap during
> the &= ~VM_MERGEABLE assignment.
> 
> VM_MERGEABLE is a 32-bit constant of type unsigned int, 0x8000'0000.
> After ~ is applied, it becomes 0x7fff'ffff unsigned int, which is then
> promoted to unsigned long before the & operation. This promotion fills
> upper 32 bits with leading 0s, as we're doing unsigned conversion (and
> even for a signed conversion, this wouldn't help as the leading bit is
> 0). & operation thus ends up AND-ing vm_flags with 0x0000'0000'7fff'ffff
> instead of intended 0xffff'ffff'7fff'ffff and hence accidentally clears
> the upper 32-bits of its value.
> 
> Fix it by changing `VM_MERGEABLE` constant to unsigned long, using the
> BIT() macro.
> 
> Note: other VM_* flags are not affected:
> This only happens to the VM_MERGEABLE flag, as the other VM_* flags are
> all constants of type int and after ~ operation, they end up with
> leading 1 and are thus converted to unsigned long with leading 1s.
> 
> Note 2:
> After commit 31defc3b01d9 ("userfaultfd: remove (VM_)BUG_ON()s"), this is
> no longer a kernel BUG, but a WARNING at the same place:
> 
> [   45.595973] WARNING: CPU: 1 PID: 2474 at mm/userfaultfd.c:2067
> 
> but the root-cause (flag-drop) remains the same.
> 
> Fixes: 7677f7fd8be76 ("userfaultfd: add minor fault registration mode")

Late to the party, but it seems to me the correct Fixes: should be
f8af4da3b4c1 ("ksm: the mm interface to ksm")
which introduced the flag and the buggy clearing code, no?

Commit 7677f7fd8be76 is just one that notices it, right? But there are other
flags in >32 bit area, including pkeys etc. Sounds rather dangerous if they
can be cleared using a madvise.

So we can't amend the Fixes: now but maybe could advise stable to backport
for even older versions than based on 7677f7fd8be76 ?

> Signed-off-by: Jakub Acs <acsjakub@amazon.de>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Xu Xin <xu.xin16@zte.com.cn>
> Cc: Chengming Zhou <chengming.zhou@linux.dev>
> Cc: Peter Xu <peterx@redhat.com>
> Cc: Axel Rasmussen <axelrasmussen@google.com>
> Cc: linux-mm@kvack.org
> Cc: linux-kernel@vger.kernel.org
> Cc: stable@vger.kernel.org
> ---
>  include/linux/mm.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 1ae97a0b8ec7..c6794d0e24eb 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -296,7 +296,7 @@ extern unsigned int kobjsize(const void *objp);
>  #define VM_MIXEDMAP	0x10000000	/* Can contain "struct page" and pure PFN pages */
>  #define VM_HUGEPAGE	0x20000000	/* MADV_HUGEPAGE marked this vma */
>  #define VM_NOHUGEPAGE	0x40000000	/* MADV_NOHUGEPAGE marked this vma */
> -#define VM_MERGEABLE	0x80000000	/* KSM may merge identical pages */
> +#define VM_MERGEABLE	BIT(31)		/* KSM may merge identical pages */
>  
>  #ifdef CONFIG_ARCH_USES_HIGH_VMA_FLAGS
>  #define VM_HIGH_ARCH_BIT_0	32	/* bit only usable on 64-bit architectures */


