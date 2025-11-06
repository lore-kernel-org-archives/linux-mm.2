Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93EF4CCF9F8
	for <linux-mm@archiver.kernel.org>; Thu,  6 Nov 2025 16:33:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DAFEC8E000A; Thu,  6 Nov 2025 11:33:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D60908E0002; Thu,  6 Nov 2025 11:33:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9D708E000A; Thu,  6 Nov 2025 11:33:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B821E8E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 11:33:05 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6754DB6880
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 16:33:05 +0000 (UTC)
X-FDA: 84080726730.26.F26F7BC
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf16.hostedemail.com (Postfix) with ESMTP id 48C53180004
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 16:33:03 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=none;
	spf=pass (imf16.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762446783;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xqzFyXto1l3AzE6Sh9Cs9YWVTO7Qq3e84BWa3rwMaSk=;
	b=7XI/hvHskSzYy0VwhbtKzrBZEV4hmsWjtgii50IA2MBxwc3vgaLIVL/QmJgKnuOjlx4kz7
	8nKBvD9Zh+OJnHmqpFYWkjJr5PwXtvf2xxnhef9gzq6NLpKPU8GGsQcpKpBzbWHBQkHA/o
	+zhBJOU4OZENdpxv9rcE439A7xGE6eQ=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	spf=pass (imf16.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762446783; a=rsa-sha256;
	cv=none;
	b=oI6C2VZozKIODh+Y9kObWOWHloryl3JFsZoioLCkCZenGKl3lxGrUmJ6SKE4dmaaP7uH4f
	MBVKb0ZH1nfw8KgARAcydyBm4PwKlxSflLSdRlNXpgJewrHXdJC5icn9YWfxk/hPdBWqee
	/6x2Bva2yvwlWYMYQzQhshmQqvg2kOQ=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 903721516;
	Thu,  6 Nov 2025 08:32:54 -0800 (PST)
Received: from [10.1.30.195] (XHFQ2J9959.cambridge.arm.com [10.1.30.195])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C8FFD3F66E;
	Thu,  6 Nov 2025 08:32:59 -0800 (PST)
Message-ID: <8bc796e2-f652-4c12-a347-7b778ae7f899@arm.com>
Date: Thu, 6 Nov 2025 16:32:58 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: madvise(MADV_COLLAPSE) fails with EINVAL on dirty file-backed
 text pages
Content-Language: en-GB
To: "Garg, Shivank" <shivankg@amd.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Vlastimil Babka <vbabka@suse.cz>,
 Jann Horn <jannh@google.com>, zokeefe@google.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <4e26fe5e-7374-467c-a333-9dd48f85d7cc@amd.com>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <4e26fe5e-7374-467c-a333-9dd48f85d7cc@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 48C53180004
X-Stat-Signature: owgqqg3qxohwfpq79dpmhhtomf9zkoyh
X-Rspam-User: 
X-HE-Tag: 1762446783-634565
X-HE-Meta: U2FsdGVkX1+xi9CSo4AgcuL+vWRyFljjq1ZL44npW0p35Amm/CUgCQwzU4F/fIRNkGlxqZsAvtoHd0JrjQI/dzFVd2plFnflpIg1wdR+iK37apayZNGQYP58x3MsEbEck2ewE4ZuUnqhBT2pM9KThEWQqHgx6VM2Wp1JteB3E8a4FR2eYeGQfQ29szpBnZE9NIvBFf+2xiVJ09EJVt/FiLXGhSpYd7CMnH2r134RMhcfjBEMJnOapOjVbUssqRj3C5RFizWnSrsDVnqc/qOo1YFJCKeOFhqo0n3w+19M4zwLcy5/vVB669WzYkr5/AITi4HA0WNldOWyJcq8fEOl5TCWR68dxcCehPQ62YDJC/hQ8a5SX8M7qbeROTrbRZWUknvILBKee/HserbrpJLe/jHS+/qeH4xJAjg+XMK+MK4/asbrDg77nMZlpkV/F5l/0UTaB1vfydgPClRKKFKJYcNECjD63isU1xGvLgkOYgHHxbQUim6DqHopePP3SVLZOOScQFKkKRmv/7mp+adZpc631e5ir17C3nRoCCOIjMnST4j9nt8KMNE7HSHf1UUG8HnIgxJCLeKAtFkgaDK46cY0Jx7YwTj7Jq9tRqXgPl2/4EbPzxjrmacP03j6aX9blxRZAyN6p0Gydgc/sE32JwGApVF5tyT6QrAQC1ci5X2ojS6NykFLbLLNCR1N3liv4/BdWKyv15Fij/4G0C22BI25cVHU/JiWdrV95TnE0Tn4RJFpcKe8M7At/GvSep5ahGfrhPYORG3xFDrFhdcJX1KhxCOEoBmZTzuBQf8C2/7ixf4UOXjI7gMGD2L24Hpw7PlDvKYfVHxzhDE4RAh8Eo32uo7jsZ0jygWoZHOp6QoOk7djVzQWJ6zAhyJOkNJSZzfaeGGFD+qLNXUf0oIpbh30kStn9tj/xvypXTKMEvqhdaFdGMzEV/VSpALCHMFBg+LMzrv6jGBEmWZGEre
 +4BSFDFm
 4hTTwEeo9vkQSne+tf17YNKeD7yVKjbjHAxVTyTYhVYQCdfz4bKh96OJCMl/fVO5Ogb4eqV8lAZGUcABwfimzFdjO8e1Cgf5cUXDBzKiZzPXabPRDqOKBvqh2TijrabVeei8J1qAqiJ4pMZF77RrnFwQRQUmq1TBYUS/OVuR+oxMko9hGdcKrpBI6xC2IFOT6uIJP
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 06/11/2025 12:16, Garg, Shivank wrote:
> Hi All,
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
>     /*
>      * khugepaged only works on read-only fd,
>      * so this page is dirty because it hasn't
>      * been flushed since first write. There
>      * won't be new dirty pages.
>      *
>      * Trigger async flush here and hope the
>      * writeback is done when khugepaged
>      * revisits this page.
>      */
>     xas_unlock_irq(&xas);
>     filemap_flush(mapping);
>     result = SCAN_FAIL;
>     goto xa_unlocked;
> }
> 
> Why the text pages are dirty?

This is the real question to to answer, I think...

What architecture are you running on?


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

On arm64 at least, I wouldn't expect the text to be modified. Relocations should
be handled in data. But given you have private dirty pages here, they must have
been cow'ed and are therefore anonymous? In which case, where is writeback
actually going?

> 
> Reproduction using XFS/EXT4:
> 
> 1. Compile a test binary with madvise(MADV_COLLAPSE), ensuring the load TEXT segment is
>    2MB-aligned and sized to a multiple of 2MB. 
>   Type           Offset   VirtAddr           PhysAddr           FileSiz  MemSiz   Flg Align
> LOAD           0x400000 0x0000000000400000 0x0000000000400000 0x1000000 0x1000000 R E 0x200000
> 
> 2. Create and mount the XFS/EXT4 fs:
>    dd if=/dev/zero of=/tmp/xfs-test.img bs=1M count=1024
>    losetup -f --show /tmp/xfs-test.img  # output: /dev/loop0
>    mkfs.xfs -f /dev/loop0
>    mkdir -p /mnt/xfs-mnt
>    mount /dev/loop0 /mnt/xfs-mnt
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
>    rather than a transient condition that could succeed on retry.
> 
> 2. Non-Transparent Handling: Users are unaware they need to flush dirty pages manually. Current
>    madvise_collapse assumes the caller is khugepaged (as per code snippet comment) which will revisit
>    the page. However, when called via madvise(MADV_COLLAPSE), the userspace program typically don't
>    retry, making the async flush ineffective. Should we differentiate between madvise and khugepaged
>    behavior for MADV_COLLAPSE?
> 
> Would appreciate thoughts on the best approach to address this issue.
> 
> Thanks,
> Shivank


