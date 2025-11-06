Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22426CCFA05
	for <linux-mm@archiver.kernel.org>; Thu,  6 Nov 2025 12:55:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5879B8E000B; Thu,  6 Nov 2025 07:55:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55F378E0002; Thu,  6 Nov 2025 07:55:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49CB08E000B; Thu,  6 Nov 2025 07:55:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3906E8E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 07:55:50 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EA152160700
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 12:55:49 +0000 (UTC)
X-FDA: 84080179218.27.E56F146
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	by imf13.hostedemail.com (Postfix) with ESMTP id C0A652000F
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 12:55:47 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Y35TJK/e";
	spf=pass (imf13.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762433748;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KIYRTh/lQ2wLhS2uIrTPJ7pte4vFCmXgbOw/IFvqqpY=;
	b=DFVrkcv3j7jwgFviBC8nrOnVJarMo6MYql2RIfVupQX9GvCc36JqKxEBfxGDI+qVPQympP
	xBMZ8xNB8XY60KcEnPHBCHNV3yFRwVmvdaNf1K58rYdI2vTHGZM/NFYXOw0yDwAfXznqzU
	ThstvmOr+LvHbV7EU8Se7KIKeg4fE3A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762433748; a=rsa-sha256;
	cv=none;
	b=vdgCdg/aU1ErcvClOUpdtz+OiLY0+GBVDhg5h8b5JwLRwk8B22NMUrClcCddWXbSRdy5ze
	TpGWKKuUgN4w5zi9ttfW0JydgEDFpK7Cym5IhOOYxjBxj46MWNficSkRIG1g54Hjnmw2uo
	q3qKhWf4l1hownoKr9e1IoLRUBzE7ew=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Y35TJK/e";
	spf=pass (imf13.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <1783f8fc-6b9b-422e-999e-2a6f58d90807@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762433745;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KIYRTh/lQ2wLhS2uIrTPJ7pte4vFCmXgbOw/IFvqqpY=;
	b=Y35TJK/eQ7WBITsWcOlG8qdbMu1yAerex0mNgY9AG2cmFFsR2cYJ6Z3yhmqju/bMhCUo7r
	LbYRNHDpUehRg7zl4T+shR4fHbuYdr+bApB7XZmc8cI6fpwPY5uIurbsnkvFMC9Qbx3tt6
	IxT8gpK9Qt/06OyU+orECwteIAdfhS0=
Date: Thu, 6 Nov 2025 20:55:33 +0800
MIME-Version: 1.0
Subject: Re: madvise(MADV_COLLAPSE) fails with EINVAL on dirty file-backed
 text pages
Content-Language: en-US
To: "Garg, Shivank" <shivankg@amd.com>
Cc: linux-mm@kvack.org, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 linux-kernel@vger.kernel.org, Zi Yan <ziy@nvidia.com>,
 Dev Jain <dev.jain@arm.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Jann Horn <jannh@google.com>, David Hildenbrand <david@redhat.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Barry Song <baohua@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, zokeefe@google.com,
 Vlastimil Babka <vbabka@suse.cz>
References: <4e26fe5e-7374-467c-a333-9dd48f85d7cc@amd.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <4e26fe5e-7374-467c-a333-9dd48f85d7cc@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C0A652000F
X-Stat-Signature: qsudgduui517ejcunbee9np7f6tp59p6
X-Rspam-User: 
X-HE-Tag: 1762433747-668506
X-HE-Meta: U2FsdGVkX18e+G2bycMtUdqwE9rvbySUQaXA0x9qPOCVP7I5Lc2ucuDTQlf4K4HE2n4B19/Q0VczMvstW2DMd1/lXgQGAnH4zmDNNR6nCwh+jbC5cmck3IwBHD311euDgYxwr1T34W3fTHXoDyjWKDwhQrEsH3HTyKEPuodygxF1FbANYYvZ4Jqe5H8hbFObXxceR55IfzVz6dZ0vLLH36cv448qY+UIO9jc7d6gElVq9kxPbmemeWjanWfGPOoiF84RmAsFPadPvzCEmZjXjX2p1IBUzSnO+CDMk8S6fxikJA9G1xD3AcGU69ZEh5W+O3PlTZaEBllJex/6vg/JpaJPzjGeF9E+4cCnp+ZnPZzVRW7jZDemz3D/3PmeqFyirJZ16D3fqtpsCQ0/mv93ctFlfUdGFnHo/2SIgUdiqlL4JA9j+A6WNciHvnz+OOC70IwsgtXNlpplYld1Ess/hxrSLlobn21xadiYRP7vvGRJY/0GEGf8oOG3AbgskHWBW3wqlpuToiDZ5VYSkzqFbBncs8pkivS2FjpV9645XOaWYAhr87qPfQyiIC2QXQCNGiKxRx5zWBOcY7I3l8+cYLUori4X3U/phMkWTZQ9cQotE/pQtB8qNH4InqKqo2uEV2RTcWt+F3nBPWj+Yq2zzHJAVbEmSA6M4rBDWWjEuPb61Ya3P1hviJ5gtYkPkXnFr3GrbNtSLSc1XbTX9K7bFCM8UOaXY+B8AahY1J48uFMHbrTEw2rFiVZw2OWKFJS25E9HUpy5MZt3ExbZBkJXQ8K4UrGkwX8YS/z6XCrgsnQB70V+yFjZapc7A44P6q2ZriSE8R2DwYzH9T+kSX5gxksEgJCgRhi5G2VBnCkfUFuf2NQ1Y0BMdGQGwv4VRo6PlV9wgCljNzznw1+sKE3ByOC6UWq0JxCCP7oq3tkQ6UKMYsQrebIna20nFEqxBWGyqUr1DSDQvr1BZsIuCcN
 ois4MGJT
 TRKWKIlGRzmyclHldxQf2KZ81pXx6sCoC4kVA7qsBT/n70zavxESJtPBMoMn787NOu7d6I+MgrP4Mflmxx/oiy5zwbuEmBYPiGwYYhbIWpOjAembdgXcLJw9wni7laaChYbL2DJbU2Jb74wyc3T1dmShnYkbnVaFHcnpss1/pssjo6vWAdr23yiriVs6naH0t4+Nu7Cm7UOUVPSYBrwY0tKfOwZTdjKDXj9kySBXl7CHq3/6xKEXoCu46VodtugHvwZC5
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/11/6 20:16, Garg, Shivank wrote:
> Hi All,

Hi Shivank,

Good catch and a really clear analysis - thanks!
> 
> I've been investigating an issue with madvise(MADV_COLLAPSE) for TEXT pages
> when CONFIG_READ_ONLY_THP_FOR_FS=y is enabled, and would like to discuss the
> current behavior and improvements.
> 
> Problem:
> When attempting to collapse read-only file-backed TEXT sections into THPs
> using madvise(MADV_COLLAPSE), the operation fails with EINVAL if the pages
> are marked dirty.
> madvise(aligned_start, aligned_size, MADV_COLLAPSE) -> returns -1 and errno = -22
> 
> Subsequent calls to madvise(MADV_COLLAPSE) succeed because the first madvise
> attempt triggers filemap_flush() which initiates async writeback of the dirty folios.
> 
> Root Cause:
> The failure occurs in mm/khugepaged.c:collapse_file():
> } else if (folio_test_dirty(folio)) {
>      /*
>       * khugepaged only works on read-only fd,
>       * so this page is dirty because it hasn't
>       * been flushed since first write. There
>       * won't be new dirty pages.
>       *
>       * Trigger async flush here and hope the
>       * writeback is done when khugepaged
>       * revisits this page.
>       */
>      xas_unlock_irq(&xas);
>      filemap_flush(mapping);
>      result = SCAN_FAIL;
>      goto xa_unlocked;
> }
> 
> Why the text pages are dirty?
> It initially seemed unusual for a read-only text section to be marked as dirty, but
> this was actually confirmed by /proc/pid/smaps.
> 
> 55bc90200000-55bc91200000 r-xp 00400000 07:00 133                        /mnt/xfs-mnt/large_binary_thp
> Size:              16384 kB
> KernelPageSize:        4 kB
> MMUPageSize:           4 kB
> Rss:                 256 kB
> Pss:                 256 kB
> Pss_Dirty:           256 kB
> Shared_Clean:          0 kB
> Shared_Dirty:          0 kB
> Private_Clean:         0 kB
> Private_Dirty:       256 kB
> 
> /proc/pid/smaps (before calling MADV_COLLAPSE) showing Private_Dirty pages in r-xp mappings.
> This may be due to dynamic linker and relocations that occurred during program loading.
> 
> Reproduction using XFS/EXT4:
> 
> 1. Compile a test binary with madvise(MADV_COLLAPSE), ensuring the load TEXT segment is
>     2MB-aligned and sized to a multiple of 2MB.
>    Type           Offset   VirtAddr           PhysAddr           FileSiz  MemSiz   Flg Align
> LOAD           0x400000 0x0000000000400000 0x0000000000400000 0x1000000 0x1000000 R E 0x200000
> 
> 2. Create and mount the XFS/EXT4 fs:
>     dd if=/dev/zero of=/tmp/xfs-test.img bs=1M count=1024
>     losetup -f --show /tmp/xfs-test.img  # output: /dev/loop0
>     mkfs.xfs -f /dev/loop0
>     mkdir -p /mnt/xfs-mnt
>     mount /dev/loop0 /mnt/xfs-mnt
> 3. Copy the binaries to /mnt/xfs-mnt and execute.
> 4. Returns -EINVAL on first run, then run successfully on subsequent run. (100% reproducible)
> 5. To reproduce again; reboot/kexec and repeat from step 2.
> 
> Workaround:
> 1. Manually flush dirty pages before calling madvise(MADV_COLLAPSE):
> 	int fd = open("/proc/self/exe", O_RDONLY);
> 	if (fd >= 0) {
> 		fsync(fd);
> 		close(fd);
> 	}
> 	// Now madvise(MADV_COLLAPSE) succeeds
> 2. Alternatively, retrying madvise_collapse on EINVAL failure also work.
> 
> Problems with Current Behavior:
> 1. Confusing Error Code: The syscall returns EINVAL which typically indicates invalid arguments
>     rather than a transient condition that could succeed on retry.
> 
> 2. Non-Transparent Handling: Users are unaware they need to flush dirty pages manually. Current
>     madvise_collapse assumes the caller is khugepaged (as per code snippet comment) which will revisit
>     the page. However, when called via madvise(MADV_COLLAPSE), the userspace program typically don't
>     retry, making the async flush ineffective. Should we differentiate between madvise and khugepaged
>     behavior for MADV_COLLAPSE?
> 
> Would appreciate thoughts on the best approach to address this issue.

Just throwing out a couple of ideas ...

We could just switch the return code to EAGAIN in the MADV_COLLAPSE 
path. At least that
gives the right hint that retrying is an option ;)

Or, what if we just handle it inside the syscall? When we hit a dirty 
page, we wait for
the writeback to finish and then try again right away. The call might be 
a little slower,
but MADV_COLLAPSE is best effort, right? That seems worth the trouble ...

Cheers,
Lance

