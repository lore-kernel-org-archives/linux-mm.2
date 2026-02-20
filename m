Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4542C54FD2
	for <linux-mm@archiver.kernel.org>; Fri, 20 Feb 2026 13:38:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF4AA6B0088; Fri, 20 Feb 2026 08:38:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA2776B0089; Fri, 20 Feb 2026 08:38:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9ADE26B008A; Fri, 20 Feb 2026 08:38:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 81D646B0088
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 08:38:05 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1CFE61401D5
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 13:38:05 +0000 (UTC)
X-FDA: 84464938530.25.1E1B29F
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf22.hostedemail.com (Postfix) with ESMTP id C500BC0008
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 13:38:02 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=bebBlfny;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=oehI10I4;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=bebBlfny;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=oehI10I4;
	spf=pass (imf22.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771594683;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9+zHk49QRpaemzTykSCmPBW0EJr/6JSBQQF1JLI85QQ=;
	b=T6qIYekjWwxK1btk4F6XNkjYqfcznqlBDINF4+KvUgnG4ETQqOXkq+YdkaDH5iKTOZQpnT
	Ma2SsVXvFGAbdnyW5+YhSQuuH8IPcOwG2bstIGTh7qAT5VUYwRRLY607Sz4fArIoJimq4G
	mrXToT9/gx54H8UgwencAbZeaM4RNgA=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=bebBlfny;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=oehI10I4;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=bebBlfny;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=oehI10I4;
	spf=pass (imf22.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771594683; a=rsa-sha256;
	cv=none;
	b=sONYXaqlf4CmLP3K1wVtz1q8HYSqCKNA9/j13TELcQO9NHWfvg3DzJ9UOwoINKp3tN5ei1
	rvztht1/AldZ9h582i1ALTppIyr5DM9iH6piVl7TwAb9PFjZcmbNa0T4WXyJuqSuzBOXjS
	F+P9c5D5fTe8e3Dkl+H9N1uhyXlbtMQ=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 2E07E3E6F4;
	Fri, 20 Feb 2026 13:38:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1771594681; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9+zHk49QRpaemzTykSCmPBW0EJr/6JSBQQF1JLI85QQ=;
	b=bebBlfnyt3CpkfFyphEaoYIFLBwm8Z7WeNEpRosnT9XQZZHF4dIeapFcryfea6N/LpIGeK
	f+lacNf2HVovA652mlUoyFMp7O3g8qUf88Wb6vvRKyOLegF8O9nW++ddShuCGj8nzoFjI/
	tWKnFxLUpvBvLwEe4Ot1IkRdPaI5e/k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1771594681;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9+zHk49QRpaemzTykSCmPBW0EJr/6JSBQQF1JLI85QQ=;
	b=oehI10I4eziQ7+nz5CKZjR+/4s1wYN6FgZIHdhtYXCKOw5guMgxV/8y6CJ+faNCCbD0w2x
	IshZP26M9qIjvkCQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1771594681; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9+zHk49QRpaemzTykSCmPBW0EJr/6JSBQQF1JLI85QQ=;
	b=bebBlfnyt3CpkfFyphEaoYIFLBwm8Z7WeNEpRosnT9XQZZHF4dIeapFcryfea6N/LpIGeK
	f+lacNf2HVovA652mlUoyFMp7O3g8qUf88Wb6vvRKyOLegF8O9nW++ddShuCGj8nzoFjI/
	tWKnFxLUpvBvLwEe4Ot1IkRdPaI5e/k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1771594681;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9+zHk49QRpaemzTykSCmPBW0EJr/6JSBQQF1JLI85QQ=;
	b=oehI10I4eziQ7+nz5CKZjR+/4s1wYN6FgZIHdhtYXCKOw5guMgxV/8y6CJ+faNCCbD0w2x
	IshZP26M9qIjvkCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DC2833EA65;
	Fri, 20 Feb 2026 13:37:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id +EZsMrdjmGkkawAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Fri, 20 Feb 2026 13:37:59 +0000
Date: Fri, 20 Feb 2026 13:37:58 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: Dev Jain <dev.jain@arm.com>
Cc: lsf-pc@lists.linux-foundation.org, ryan.roberts@arm.com, 
	catalin.marinas@arm.com, will@kernel.org, ardb@kernel.org, willy@infradead.org, 
	hughd@google.com, baolin.wang@linux.alibaba.com, akpm@linux-foundation.org, 
	david@kernel.org, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, 
	vbabka@suse.cz, rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [LSF/MM/BPF TOPIC] Per-process page size
Message-ID: <yfe2xbb6qwthg3cf4yr7zszpw5o3mx2v4bv32iwnm7yzxqjsvl@et22s2nuwzzk>
References: <20260217145026.3880286-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260217145026.3880286-1-dev.jain@arm.com>
X-Rspamd-Action: no action
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C500BC0008
X-Stat-Signature: xnbggmsxom96pqfiaybdjyqmme55fa7m
X-Rspam-User: 
X-HE-Tag: 1771594682-760302
X-HE-Meta: U2FsdGVkX1+pDNWaxePKDimnzMS8KVdT5i63xmO68lVElYuNf0tYj++8V2nF+jKtFBuYcXS2jIvkRiY752Cm/0nfq3dGpCKR9uJGjZLuPX0iDMX+sUhbScAYVXLqRlzVEtaG7imrlKz82Mc7evPt860GL1l4KWubYKl0CthlR/QEDMaOD0e98BazU871qU8p+WgaTXBa7hCxm1eWqeqjZ9o1q1uk0KpRNPS1GUqe/5SLQURPkgh+ZVxcRoWw53vH1SXN5vzkJUvn3Aohpy3hfCdvHlgiQuPsBxWpMNEPvDpkjzuml7WzoCmirzCI+/wabihF3i/Bus6U+fkD4UVBxp+0CKffOdnTzZYk0p2WA5y+m7ZJlh1BMoUGc9x8fUb5psGQDW2eLy1VPN2UunxiS2Iunt+ZMG3HyBcszFbhhCCeLtTVZCvHJyW+ixcQvZy8M/2lHE6SXD6fuepxR59iY2+mnyc7pFzyKKYjzxVxDUNYn+3agPy5UbZZBImK/opkvg8feS3AGea3/48zatliYKZzRw+rm22g5ih7lJRwULbAqm2f2CTuvIO+6x3lzTz+PPzT+gZdcJycYjbhoaKqdgNpuOfeiw8jb5WOyZDUlMRYcbT0N/dOFHR5QbtYVOrRbPJ4Ln/RaKkQqo8LZIauZWoXQykQ/cFSVuIdeCu4d5yn4whdSmYEUNO7AM4FrBcbQIH6NnG3Kzh491U4rdP8vizA+lLPD6yyWnsumFbOMO++FkrP0z47w9/2MYHFpE8JkWq5vKkVeIUtExuIUOjJaQyRNe3CzAb0D3ORk8RkMeqOP3Y6T+6byeswN9qdaoGeP0DX456K7kgnP8nwBis+sIhVjWJC/gMO6JDGDmVPeBLVwhsDClJYxi295zUezIXfNmR9ml8wm0NvThXOBknnH91lF9uFCMsexHoXY10/q/KLEpMr0ajvre6nmnyIiYdCLSn1d+qPOeyltz+brsf
 8VemSqT0
 UMuRabM+MErhGbqSjLR0TCoCDz7vLVsumD9JITlsx8PT2gAn3gUURuPzFNl0TBouSkmBY3Fi6Hez7J6NTysicODkrC8617VhMn2XsSgROmPqfJd8n8EJhOcRbTEjjG+AxIAsBJ6GYRIFyDRTRXQfSNTgV5ErHnTqUWcISvZjlo3tMEebfYNUH8qGbtYHck4sTIQ9ge1f1YrZBZFicL9eAdwe3NIn+sv8DPGcCyVQI9ZCp/Wm8vRY0vS49JYsA5sDDvI1H43gQpV+K4S7p0Tcl2sZ4+f+MJUlSjrRqGvjL5YlaooxkcmNFwJCAKF3jd1DjuLxB+aBk8CXTvQA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 17, 2026 at 08:20:26PM +0530, Dev Jain wrote:
> Hi everyone,
> 
> We propose per-process page size on arm64. Although the proposal is for
> arm64, perhaps the concept can be extended to other arches, thus the
> generic topic name.
> 
> -------------
> INTRODUCTION
> -------------
> While mTHP has brought the performance of many workloads running on an arm64 4K
> kernel closer to that of the performance on an arm64 64K kernel, a performance
> gap still remains. This is attributed to a combination of greater number of
> pgtable levels, less reach within the walk cache and higher data cache footprint
> for pgtable memory. At the same time, 64K is not suitable for general
> purpose environments due to it's significantly higher memory footprint.

Could this perhaps be because of larger-page-size kernels being able to use
mTHP (and THP) more aggressively? It would be interesting to compare arm64
"4K" vs "4K with mTHP" vs "4K with _only_ mTHP" vs "64K" vs "64K with mTHP".

> 
> To solve this, we have been experimenting with a concept called "per-process
> page size". This breaks the historic assumption of a single page size for the
> entire system: a process will now operate on a page size ABI that is greater
> than or equal to the kernel's page size. This is enabled by a key architectural
> feature on Arm: the separation of user and kernel page tables.
> 
> This can also lead to a future of a single kernel image instead of 4K, 16K
> and 64K images.
> 
> --------------
> CURRENT DESIGN
> --------------
> The design is based on one core idea; most of the kernel continues to believe
> there is only one page size in use across the whole system. That page size is
> the size selected at compile-time, as is done today. But every process (more
> accurately mm_struct) has a page size ABI which is one of the 3 page sizes
> (4K, 16K or 64K) as long as that page size is greater than or equal to the
> kernel page size (kernel page size is the macro PAGE_SIZE).
> 
> Pagesize selection
> ------------------
> A process' selected page size ABI comes into force at execve() time and
> remains fixed until the process exits or until the next execve(). Any forked
> processes inherit the page size of their parent.
> The personality() mechanism already exists for similar cases, so we propose
> to extend it to enable specifying the required page size.
> 
> There are 3 layers to the design. The first two are not arch-dependent,
> and makes Linux support a per-process pagesize ABI. The last layer is
> arch-specific.
> 
> 1. ABI adapter
> --------------
> A translation layer is added at the syscall boundary to convert between the
> process page size and the kernel page size. This effectively means enforcing
> alignment requirements for addresses passed to syscalls and ensuring that
> quantities passed as “number of pages” are interpreted relative to the process
> page size and not the kernel page size. In this way the process has the illusion
> that it is working in units of its page size, but the kernel is working in
> units of the kernel page size.
> 
> 2. Generic Linux MM enlightenment
> ---------------------------------
> We enlighten the Linux MM code to always hand out memory in the granularity
> of process pages. Most of this work is greatly simplified because of the
> existing mTHP allocation paths, and the ongoing support for large folios
> across different areas of the kernel. The process order will be used as the
> hard minimum mTHP order to allocate.
> 
> File memory
> -----------
> For a growing list of compliant file systems, large folios can already be
> stored in the page cache. There is even a mechanism, introduced to support
> filesystems with block sizes larger than the system page size, to set a
> hard-minimum size for folios on a per-address-space basis. This mechanism
> will be reused and extended to service the per-process page size requirements.
> 
> One key reason that the 64K kernel currently consumes considerably more memory
> than the 4K kernel is that Linux systems often have lots of small
> configuration files which each require a page in the page cache. But these
> small files are (likely) only used by certain processes. So, we prefer to
> continue to cache those using a 4K page.
> Therefore, if a process with a larger page size maps a file whose pagecache
> contains smaller folios, we drop them and re-read the range with a folio
> order at least that of the process order.
> 
> 3. Translation from Linux pagetable to native pagetable
> -------------------------------------------------------
> Assume the case of a kernel pagesize of 4K and app pagesize of 64K.
> Now that enlightenment is done, it is guaranteed that every single mapping
> in the 4K pagetable (which we call the Linux pagetable) is of granularity
> at least 64K. In the arm64 MM code, we maintain a "native" pagetable per
> mm_struct, which is based off a 64K geometry. Because of the guarantee
> aforementioned, any pagetable operation on the Linux pagetable
> (set_ptes, clear_flush_ptes, modify_prot_start_ptes, etc) is going to happen
> at a granularity of at least 16 PTEs - therefore we can translate this
> operation to modify a single PTE entry in the native pagetable.
> Given that enlightenment may miss corner cases, we insert a warning in the
> architecture code - on being presented with an operation not translatable
> into a native operation, we fallback to the Linux pagetable, thus losing
> the benefits borne out of the pagetable geometry but keeping
> the emulation intact.

I don't understand. What exactly are you trying to do here? Maintain 2
different paging structures, one for core mm and the other for the arch? As
done in architectures with no radix tree paging structures?

If so, that's wildly inefficient, unless you're willing to go into reclaimable
page tables on the arm64 side. And that brings extra problems and extra fun :)

-- 
Pedro

