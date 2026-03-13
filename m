Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7404107BCDF
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 19:48:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E84EC6B0088; Fri, 13 Mar 2026 15:48:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E32696B0089; Fri, 13 Mar 2026 15:48:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3E456B008A; Fri, 13 Mar 2026 15:48:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C35036B0088
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 15:48:00 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6C8EF13A511
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 19:48:00 +0000 (UTC)
X-FDA: 84542075520.06.BB98330
Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	by imf15.hostedemail.com (Postfix) with ESMTP id 4FE59A000D
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 19:47:58 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gQGLqbED;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773431278;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SPdzeDgO7p2Ex3q8WAh+g8zvKcfA3PAYlObdmzAMKhU=;
	b=SzDcLNX343Qvv+brGXk5681SsHfrtC2R7A8IzkbkcFwQDzxkjNP3NrZLeo/5F3fVVfb/EE
	oi0/ZNuNeD50n1BeFepyG3TXCwy54D57BNgkswQnuAnxGZFp8e37zdXMAZJXd3neeRaueN
	mcBZ/oYI0V9pD3FN2ulyVQKuANVHOAU=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gQGLqbED;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773431278; a=rsa-sha256;
	cv=none;
	b=F760DL4ZZaXcnwyb6rAj/sCNKCRwHSZUA4OPfVgOxMXTWJ95avxcPFHSkMWb39u2nBJLeF
	Y+clAaVClKEmgUF7Jl3qU5BGNtRXj3vJInHWP+VRYzQqHjpe4wLKYpfgt0rQVPDpZr2fTA
	UtKX7SxuWn4oOt9EIEmZy1CKPyggCnM=
Message-ID: <d3f60289-3ea1-43ce-9271-58c8b79bf7a0@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773431275;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SPdzeDgO7p2Ex3q8WAh+g8zvKcfA3PAYlObdmzAMKhU=;
	b=gQGLqbEDWJ7Lau535C9J/+AdIU5R9AQT9hlrQ/P5sl5PpuB6Ny6SsRf5h17NM8uO1B+GGK
	tKWI8OZvAwF9tGrhepb9MZFTYi216KhN5QFZDJ4eWxrTq8RaNRAJeDBFEVTwTqZooR3cQn
	5DU8VkkJGblgc2j5LiBsX1aoo2H2YdA=
Date: Fri, 13 Mar 2026 22:47:36 +0300
MIME-Version: 1.0
Subject: Re: [PATCH 3/4] elf: align ET_DYN base to exec folio order for
 contpte mapping
Content-Language: en-GB
To: WANG Rui <r@hev.cc>
Cc: Liam.Howlett@oracle.com, ajd@linux.ibm.com, akpm@linux-foundation.org,
 anshuman.khandual@arm.com, apopple@nvidia.com, baohua@kernel.org,
 baolin.wang@linux.alibaba.com, brauner@kernel.org, catalin.marinas@arm.com,
 david@kernel.org, dev.jain@arm.com, hannes@cmpxchg.org, jack@suse.cz,
 kas@kernel.org, kees@kernel.org, kernel-team@meta.com,
 kevin.brodsky@arm.com, lance.yang@linux.dev,
 linux-arm-kernel@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 lorenzo.stoakes@oracle.com, npache@redhat.com, rmclure@linux.ibm.com,
 ryan.roberts@arm.com, shakeel.butt@linux.dev, viro@zeniv.linux.org.uk,
 will@kernel.org, willy@infradead.org, ziy@nvidia.com
References: <20260310145406.3073394-4-usama.arif@linux.dev>
 <20260313144213.95686-1-r@hev.cc>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <20260313144213.95686-1-r@hev.cc>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4FE59A000D
X-Stat-Signature: pdm9eph1gddw7fmbnxdm4m5eqk3s14ii
X-Rspam-User: 
X-HE-Tag: 1773431278-52404
X-HE-Meta: U2FsdGVkX1/bJpuAxTVr1tEwX0M6aX8rfQ+FPNa407lOLlJCbAtpwodPNs+hQGaw2KaI0lj8g0MyWrM/miYQe2OxSUuUixR5uaC4ebcNn1BEOQaBOObpVYYsAb8yBUKn2qK3zpmkK1FLAfYdVJNwHFD2YpSxrtD05zkNsmWeH7+bGA1gCAgCfvB+sF79kgxTKl+l2qgUWbBoQuvMOsuID8rjjtlG39YILWi1wDWjlrwTNIDGQwDY+GIJOTaiNeq9E5+pnUEhg+Fvb4kVsCn/v6133ymy5Gvnzp/7O13c6Cn4DYKewTE4radYi20+RrmoxPcWjLS7rrLLBPTpuiEsJF3nZflysu6DEmx56IaVQW25AxmPzypap0fv5TAQL8MO/kiYYhw1Jy5CbhQyRyBgWHqO3+oHcaXqEevrAg4xtPKq41wvFrRWPkxgG4T8cbYbcBDe6p9dibTrs0G2HS9ZUdapWZx2pVmmox/66yoHZWZ9KumHCGFW0PB2qU3c4S4afkh9g03f9DTGdPZ0Bz+ym+KE1j92cjLE84ZQj7LFNL5T72DcQb3UH3WNMVFy8C3twsaM/UGF0UEhJHjv4FdNhrtI0LS4HNjpesLqYdV3jDXWde21jRalEwRnfPU0q9+nsaYJfods2B1xKURkLayteRoYasNNs4d+Zevwoih0Pju962fZrXtJ2IRElk0wmYymqfIqJqk9o2lX8wAXOzonNsW5VMDD0mNxiitIam4S8YE7i82iMj+eheeHtMeu+A5AnN49yuyrR8UE40otYhr9IJAh4qXnblejL+dSBTIvw9Bs1g3j0GSMLKVEWk9z0SPm0cuYl1X3IxPJkWAO0B8J+3Y2joB/5crFkqxjbC6gzRM9lFfcVD+vQiP3WnlXS/WOBT+reN60Kil7YGKonUoIWRhJ8uZuXud428RAxcsjuaI0hvgCFH1IQWYEuvueybz6qAI0WbamBiaABEfUpR9
 RnrlL3Q6
 2k0kaEaDhasW7yHQRYeDDK2AH3LLnUTg5DXgyDr3JyHCL4zHgr7GnNomkGW8SCtYu7oj8poUG57S947vKRmjwlj/XX6rJYB035S7UEbzoYt9YYmJKtKKQhNzDI0WEgTsR+VAmrJoa1sxLpL52rGrt2FO3GTpczNuINp34Lp+iHEd8JJjnKwMyZJIFqGqXE5izE2OgGXVQTfN6vdvKy9FxdeY1n8GonDUOxBad1+hhgtSxsdioczqSWxh0iP3xrmSaxPDvuXLFzOcOJIYHElUzpbvU0aF7M621OdPyOy8HCDPT8DRaQtpk8Fhyx7c783mdwjlVptpmiZZ7SAyCNBxTRe0EZQKGSU6C3HdB779cSQjK7nl1kbs3qg32Wup5xtyU+1Dp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 13/03/2026 17:42, WANG Rui wrote:
> Hi Usama,
> 

Hello!

> Glad to see you're pushing on this, I'm also following it. I first noticed this when rustc's perf regressed after a binutils upgrade. I'm trying to make ld.so to aware THP and adjust PT_LOAD alignment to increase the chances of shared libraries being mapped by THP [1]. As you're probably seen, I'm doing something similar in the kernel to improve it for executables [2].

For us it came about because we use 64K page size on ARM, and none of the
text sections were getting hugified (because PMD size is 512M). I went with
exec_folio_order() = cont-pte size (2M) for 16K and 64K as we can get both page
fault benefit (which might not be that important) and iTLB coverage (due to
cont-pte).
x86 already faults in at 2M (HPAGE_PMD_ORDER) due to force_thp_readahead path in
do_sync_mmap_readahead() so the memory pressure introduced in ARM won't be worse
than what already exists in x86.

> 
>> +			if (exec_folio_order())
>> +				alignment = max(alignment,
>> +					(unsigned long)PAGE_SIZE << exec_folio_order());
> 
> I’m curious, does it make sense to add some constraints here, like only increasing p_align when the segment length, virtual address, and file offset are all huge-aligned, as I did in my patch? This has come up several times in the glibc review, where increasing alignment was noted to reduce ASLR entropy.
> 

Yes I think this makes sense!

Although maybe we should check all segments with PT_LOAD. So maybe something
like below over this series?

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 2d2b3e9fd474f..a0e83b541a7d8 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -1116,10 +1116,30 @@ static int load_elf_binary(struct linux_binprm *bprm)
                         * the hardware cannot coalesce PTEs (e.g. arm64
                         * contpte) even though the physical memory and
                         * file offset are correctly aligned.
+                        *
+                        * Only increase alignment when at least one
+                        * PT_LOAD segment is large enough to contain a
+                        * full folio and has its file offset and virtual
+                        * address folio-aligned. This avoids reducing
+                        * ASLR entropy for small binaries that cannot
+                        * benefit from contpte mapping.
                         */
-                       if (exec_folio_order())
-                               alignment = max(alignment,
-                                       (unsigned long)PAGE_SIZE << exec_folio_order());
+                       if (exec_folio_order()) {
+                               unsigned long folio_sz = PAGE_SIZE << exec_folio_order();
+
+                               for (i = 0; i < elf_ex->e_phnum; i++) {
+                                       if (elf_phdata[i].p_type != PT_LOAD)
+                                               continue;
+                                       if (elf_phdata[i].p_filesz < folio_sz)
+                                               continue;
+                                       if (!IS_ALIGNED(elf_phdata[i].p_vaddr, folio_sz))
+                                               continue;
+                                       if (!IS_ALIGNED(elf_phdata[i].p_offset, folio_sz))
+                                               continue;
+                                       alignment = max(alignment, folio_sz);
+                                       break;
+                               }
+                       }
 
                        /**
                         * DOC: PIE handling

> [1] https://sourceware.org/pipermail/libc-alpha/2026-March/175776.html
> [2] https://lore.kernel.org/linux-fsdevel/20260313005211.882831-1-r@hev.cc
> 
> Thanks,
> Rui


