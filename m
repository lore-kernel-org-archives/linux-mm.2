Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96472CCFA13
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 10:00:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDA0A8E0007; Mon, 10 Nov 2025 05:00:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB1A08E0002; Mon, 10 Nov 2025 05:00:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA07E8E0007; Mon, 10 Nov 2025 05:00:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B25BF8E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 05:00:27 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 44B50140CCE
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 10:00:27 +0000 (UTC)
X-FDA: 84094252494.13.AEF0EE1
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf05.hostedemail.com (Postfix) with ESMTP id C335C100002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 10:00:24 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=01ClbPZE;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=3Dx3gwgS;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=yfJRo7UP;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=7oGurzhB;
	spf=pass (imf05.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762768825;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w/BxzBnNXdonPq9Y2zaHgBKsc6ngF/ZxixFOXiRQSKo=;
	b=MKCle72rZv5bC89qnqblzy+LP7F+HII4Oky5qZLxsN5XsNCcQyoCGHvy48fGydeqO98RD4
	G+eDyhQP0WRE3WKgKh75I7DlJI3N+1BUwrCt1B7RHT97P2pDznJ9O4SJPyHW7fjYS2DVUu
	1ZCl/mwKwNatCzewApJeR+xfNa8ii64=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=01ClbPZE;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=3Dx3gwgS;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=yfJRo7UP;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=7oGurzhB;
	spf=pass (imf05.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762768825; a=rsa-sha256;
	cv=none;
	b=ccW/Jgkcy9zbEpq5X3oGTMb8otLQha/Lz8BuJ0O0laFUdW8hIs08ve/9XuvroPtLO+D+YV
	ALaYTByCB4A8i2nkMCtfe/28J1zKsuKh9muaTSnXO1+IbnFXJlpf3N8BryPX8CyD+intEy
	ZFw4rSdG/6US0ZHuN/S5Msfuqgmzang=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D917F21FD3;
	Mon, 10 Nov 2025 10:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762768823; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=w/BxzBnNXdonPq9Y2zaHgBKsc6ngF/ZxixFOXiRQSKo=;
	b=01ClbPZEEaxy3wZZLi+/XxDAzr9ERLYxEqIPHHG1P1IfNbwDw8pTZEdwre7d07UuooCVZW
	lglKjLBhNrBp44IfF9288dpUM82muFDyz4yxsuOBnB6p5+uYF6PSFZ+EvfUyeHBhM3R3HN
	BrV8s8vQhRWIiK2o4fLY6Hsm070qHDk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762768823;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=w/BxzBnNXdonPq9Y2zaHgBKsc6ngF/ZxixFOXiRQSKo=;
	b=3Dx3gwgSnNNnNO7xj1B5hovmWrE11K8uvmJVtIzoYzmuzzrfmq1fW0AFdLrBpMSUSJhS2D
	4FC99zHgSlhtTKCQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762768822; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=w/BxzBnNXdonPq9Y2zaHgBKsc6ngF/ZxixFOXiRQSKo=;
	b=yfJRo7UPgLDczWsyOb5u2S5P5rbSYNqPxCoZmCsfouyx9opWZ3/Fe7rZ5ZjkhGp0eiAsOr
	tItWPqIXvnLA272hctKvBrB2HmKoOvpz3EMutfzAXzAnA7CRcdOTxlpBZsB2HTYeKDjGm2
	hjkNXXNjXR8cq1NlbCc5XYJwNjporFk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762768822;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=w/BxzBnNXdonPq9Y2zaHgBKsc6ngF/ZxixFOXiRQSKo=;
	b=7oGurzhBOwCAEPvpUb4Vxelu4c21TIi6sz+7BWCz8wiSYjgfnkf8JhKEeFgbqbItX1OKtL
	S9Jjze6YpUxxLhAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A818D1432C;
	Mon, 10 Nov 2025 10:00:22 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id P5q0KLa3EWmBCAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 10 Nov 2025 10:00:22 +0000
Message-ID: <461d3a9e-f3e2-4c2f-ac9b-2b842ce115fd@suse.cz>
Date: Mon, 10 Nov 2025 11:00:22 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/2] mm/ksm: fix flag-dropping behavior in ksm_madvise
Content-Language: en-US
From: Vlastimil Babka <vbabka@suse.cz>
To: Jakub Acs <acsjakub@amazon.de>, linux-mm@kvack.org,
 Hugh Dickins <hughd@google.com>, Jann Horn <jannh@google.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Dave Hansen <dave.hansen@linux.intel.com>
Cc: akpm@linux-foundation.org, david@redhat.com, xu.xin16@zte.com.cn,
 chengming.zhou@linux.dev, peterx@redhat.com, axelrasmussen@google.com,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20251001090353.57523-1-acsjakub@amazon.de>
 <20251001090353.57523-2-acsjakub@amazon.de>
 <13c7242e-3a40-469b-9e99-8a65a21449bb@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <13c7242e-3a40-469b-9e99-8a65a21449bb@suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C335C100002
X-Stat-Signature: z9oasepn4qpopa76tp56bttn1u7nbqb3
X-Rspam-User: 
X-HE-Tag: 1762768824-440360
X-HE-Meta: U2FsdGVkX18T49mhj0wl68df30I8c5eR+m6OR5pXf/yOXtSbTaZ8OvDhHm8CujHq0+DimHxAEO9AqSvxh2k/SS7i3U13YvRhQYlQhad4Tw4rsAGkm/BqoIDJsx37wkqhcYTpA0vSQAiCL4DE1F/a6YP9EiGLVQsLkGlaGYIo1xEz1rk+6OUZqiMXER1tOCa/MxUqbnlN5aotC98LK4dENzCCdv3L08wuDZfErb9dpdDEPgf7upr0bB+Fx104GmBPvsgX4rGPWGi5wzpfS4CQs1Vv6fOMTmkFMJydKjZ1/Y/nMX2Tn5m3wEaCWEraCJENZdf/Rc01Ao2LFFcP5Eddtu89uwpC+NogY5Bl+icwwCOkZqh1JXSFwGhhmneIG9FGc45j/hYHjH7ryH8N8QbWv343YQUGRNwKHdY0aThmF6vVcFgJFzxyCKAnpjMtst3QpBkmRKlEEpw1bc1BIPeVMB0topSxGvkAP37Bt21+4ncZ4xaLRX0T11q8E4i8GvN6x/zq1MzJEfRpf58ESNX/jSd3C1/eLxZbaAegd870vta00JVizbHc9YqxsFZB6k7B4z3uek7opsjZG2PNlNpNoirh5dPkoky7ZmTGHz29Anr8YzQHYFPWwpruAtoMWM5js76k/93smYHlrVeLV+oxeazpM+h8Zn/7R4swccYRsHNvgpp+TPO6d8ch0Id5mLN7a58fPYFSh2XpH5h/Sn2fvnYeEPAwre38vhgwnms5Ai016c29DRHU0KX7GcPaL/eoj132Zz1C2NL0oR1nAx0Vwe8V3RTXO5QhwuFycwGF/Q0UcLo2H4QC+3zbk9g9jDRY34M/zZ+EJ5HkdAOgw4qa6U5GguTr8jQs692aWPjgepXmmmYcpZ7L/WpPlKfE0IJ+opzBYJ6nCx9zFNdNlJ4Z3jANGcAZQSKT/lfYF+jIBmD/6H/IkA8A+tWiA5getmmtHDOT2WssbJnWgMhk866
 gmJhr7OD
 +m8jSC+k/YvVvpu/jx6itfDAO6ReiJub4cWeYpofYJ7odSV7gFlbIg+Zt3CXfnNGCBlN1P+0NL88eCpae/WJSPhXAB1rJOvY69Hdt6ehB2mD/v4LI693RofLlrclEaRmka784dYoCUwytEgYhV1+xLa5JQIesvwaJAQxJ2lIQTvWKLvqXhLvNYphi+10pFcBbr3MHQRDo1E6IHAokrsTc75XL50D/7vwt2mTf5sfHJRNxI4DsKzhs+pWDAerf0hV/jWMubWTiOWtZxpurWco50144TQbB6Iv3xcJ17Afp5ReX6cyNJ7MnGji809tL691moI9U6N9PZWRx+EM/2sfFdd76IGjoVbPZ56e7wrQqClkG2LUTRXP//GZjsC3x0X6I0Y2bt6MoKurZ7V2jW06sgO8coCh8FYwN4WUETtkaNY9cA4lTvDIjKexw/coYhfh4hW1P7nJHgNAlOMT/G9i6pOxueR+rFgcvQG4fuQUA3rMIUCUqi0Jwlx5axqaltOlD0qE1ssmZyoCbXiZUpANbZJJzdnVNuMoipCmOSRmz+MxgcDBEgo5ykJZquCdvxYdV+4H7DTEtXuV2fWrbEBJmuFD5CvFFeLfpNgjPO+/lMWrimffcdY/IcTYmPF4CT6XPotNN
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/6/25 11:39, Vlastimil Babka wrote:
> On 10/1/25 11:03, Jakub Acs wrote:
>> syzkaller discovered the following crash: (kernel BUG)
>> 
>> [   44.607039] ------------[ cut here ]------------
>> [   44.607422] kernel BUG at mm/userfaultfd.c:2067!
>> [   44.608148] Oops: invalid opcode: 0000 [#1] SMP DEBUG_PAGEALLOC KASAN NOPTI
>> [   44.608814] CPU: 1 UID: 0 PID: 2475 Comm: reproducer Not tainted 6.16.0-rc6 #1 PREEMPT(none)
>> [   44.609635] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.3-0-ga6ed6b701f0a-prebuilt.qemu.org 04/01/2014
>> [   44.610695] RIP: 0010:userfaultfd_release_all+0x3a8/0x460
>> 
>> <snip other registers, drop unreliable trace>
>> 
>> [   44.617726] Call Trace:
>> [   44.617926]  <TASK>
>> [   44.619284]  userfaultfd_release+0xef/0x1b0
>> [   44.620976]  __fput+0x3f9/0xb60
>> [   44.621240]  fput_close_sync+0x110/0x210
>> [   44.622222]  __x64_sys_close+0x8f/0x120
>> [   44.622530]  do_syscall_64+0x5b/0x2f0
>> [   44.622840]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
>> [   44.623244] RIP: 0033:0x7f365bb3f227
>> 
>> Kernel panics because it detects UFFD inconsistency during
>> userfaultfd_release_all(). Specifically, a VMA which has a valid pointer
>> to vma->vm_userfaultfd_ctx, but no UFFD flags in vma->vm_flags.
>> 
>> The inconsistency is caused in ksm_madvise(): when user calls madvise()
>> with MADV_UNMEARGEABLE on a VMA that is registered for UFFD in MINOR
>> mode, it accidentally clears all flags stored in the upper 32 bits of
>> vma->vm_flags.
>> 
>> Assuming x86_64 kernel build, unsigned long is 64-bit and unsigned int
>> and int are 32-bit wide. This setup causes the following mishap during
>> the &= ~VM_MERGEABLE assignment.
>> 
>> VM_MERGEABLE is a 32-bit constant of type unsigned int, 0x8000'0000.
>> After ~ is applied, it becomes 0x7fff'ffff unsigned int, which is then
>> promoted to unsigned long before the & operation. This promotion fills
>> upper 32 bits with leading 0s, as we're doing unsigned conversion (and
>> even for a signed conversion, this wouldn't help as the leading bit is
>> 0). & operation thus ends up AND-ing vm_flags with 0x0000'0000'7fff'ffff
>> instead of intended 0xffff'ffff'7fff'ffff and hence accidentally clears
>> the upper 32-bits of its value.
>> 
>> Fix it by changing `VM_MERGEABLE` constant to unsigned long, using the
>> BIT() macro.
>> 
>> Note: other VM_* flags are not affected:
>> This only happens to the VM_MERGEABLE flag, as the other VM_* flags are
>> all constants of type int and after ~ operation, they end up with
>> leading 1 and are thus converted to unsigned long with leading 1s.
>> 
>> Note 2:
>> After commit 31defc3b01d9 ("userfaultfd: remove (VM_)BUG_ON()s"), this is
>> no longer a kernel BUG, but a WARNING at the same place:
>> 
>> [   45.595973] WARNING: CPU: 1 PID: 2474 at mm/userfaultfd.c:2067
>> 
>> but the root-cause (flag-drop) remains the same.
>> 
>> Fixes: 7677f7fd8be76 ("userfaultfd: add minor fault registration mode")
> 
> Late to the party, but it seems to me the correct Fixes: should be
> f8af4da3b4c1 ("ksm: the mm interface to ksm")
> which introduced the flag and the buggy clearing code, no?

Clarification: flags with bits >31 did not exist at the time of f8af4da3b4c1
as they were only introduced later with 63c17fb8e5a4 ("mm/core,
x86/mm/pkeys: Store protection bits in high VMA flags") (v4.6) so that would
have been the most precise Fixes: commit. Sorry, Hugh :)

But that doesn't affect the stable backports efforts where the oldest LTS is
5.4 anyway.

> Commit 7677f7fd8be76 is just one that notices it, right? But there are other
> flags in >32 bit area, including pkeys etc. Sounds rather dangerous if they
> can be cleared using a madvise.
> 
> So we can't amend the Fixes: now but maybe could advise stable to backport
> for even older versions than based on 7677f7fd8be76 ?
> 
>> Signed-off-by: Jakub Acs <acsjakub@amazon.de>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Cc: David Hildenbrand <david@redhat.com>
>> Cc: Xu Xin <xu.xin16@zte.com.cn>
>> Cc: Chengming Zhou <chengming.zhou@linux.dev>
>> Cc: Peter Xu <peterx@redhat.com>
>> Cc: Axel Rasmussen <axelrasmussen@google.com>
>> Cc: linux-mm@kvack.org
>> Cc: linux-kernel@vger.kernel.org
>> Cc: stable@vger.kernel.org
>> ---
>>  include/linux/mm.h | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>> 
>> diff --git a/include/linux/mm.h b/include/linux/mm.h
>> index 1ae97a0b8ec7..c6794d0e24eb 100644
>> --- a/include/linux/mm.h
>> +++ b/include/linux/mm.h
>> @@ -296,7 +296,7 @@ extern unsigned int kobjsize(const void *objp);
>>  #define VM_MIXEDMAP	0x10000000	/* Can contain "struct page" and pure PFN pages */
>>  #define VM_HUGEPAGE	0x20000000	/* MADV_HUGEPAGE marked this vma */
>>  #define VM_NOHUGEPAGE	0x40000000	/* MADV_NOHUGEPAGE marked this vma */
>> -#define VM_MERGEABLE	0x80000000	/* KSM may merge identical pages */
>> +#define VM_MERGEABLE	BIT(31)		/* KSM may merge identical pages */
>>  
>>  #ifdef CONFIG_ARCH_USES_HIGH_VMA_FLAGS
>>  #define VM_HIGH_ARCH_BIT_0	32	/* bit only usable on 64-bit architectures */
> 


