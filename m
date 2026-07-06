Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77952C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 06:53:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5721A6B00EC; Mon,  6 Jul 2026 02:53:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 549816B00F4; Mon,  6 Jul 2026 02:53:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 45EEC6B00FA; Mon,  6 Jul 2026 02:53:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 19E506B00EC
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 02:53:43 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 655C9A02DD
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 06:53:42 +0000 (UTC)
X-FDA: 84957436284.10.5823675
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id A4034140002
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 06:53:40 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=atJNIUBD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783320820;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r599ktiKbulgE6viGKOYXX1IIDFeRM72i/7JTqGw39Q=;
	b=uBlw6N2AEQqEv6KEryLg0G/pwsRYgmDI0msfmzlo4coZuOxEqnDzwYntG4VxSioPdymM1W
	MVA3Ef4UNVyX2gvPTj/2nU2y81opNDVCf7mEPhIrQMNLb3zU2EuSpVA/EdKCGXhN7+Ru0W
	Rq5+5aQFvjnF7axxDsHIbhRlhPY+aVI=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=atJNIUBD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783320820;
	b=cgbh9AUn9PHgEC12itOht6UUEaPcnoBMtM4KHFtB0mQYoay+9ST6wmvTfVKKGZoBIJM8hN
	CminUBn8CnXkX3QA9gKXuHxN/PBsns+9k7L1pNDFEXNk+oyMd0GNPaxxtUIGbqOk7TotrF
	3QkuZ8EFTER1M6VWFd9VmlTQkrkXa5Y=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2255661832;
	Mon,  6 Jul 2026 06:53:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06E7F1F000E9;
	Mon,  6 Jul 2026 06:53:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783320819;
	bh=r599ktiKbulgE6viGKOYXX1IIDFeRM72i/7JTqGw39Q=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=atJNIUBDok2nCDX2dEaLw3k7nTp6IPtCLm2Xswl5lz4p6HjaWtmIFddfoYcbIFy9c
	 13csMEzZOATX0JU4evaBvmIG04nWSL7bWMm7rp3ZS+MsD3NEpoe0vOCRtwBkR8Sf2B
	 oZhQlPTpeR2mpkUKarnydz45Q8+LY5WY4pumBBr2dvZ8YHfx8VvFKwHZw81Dw8XytN
	 EbzPyI/hjxlEm3lDq8C7Oj498c/xUC1EIuees31yzm7BuOerMvVC38bvDRXsSfbvz5
	 Y6TUfB8fESlL63LkwaEM5FKaTep2B8rVRsybRGlsx3eNftn6SBIPE/Z6Q5gudGIn3/
	 vq0T2LkTYzs1A==
Message-ID: <35b46b88-6f8a-4eb6-bef3-58389784f750@kernel.org>
Date: Mon, 6 Jul 2026 08:53:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 2/3] ksm: Optimize rmap_walk_ksm by passing a suitable
 page index
To: xu.xin16@zte.com.cn, akpm@linux-foundation.org
Cc: chengming.zhou@linux.dev, hughd@google.com, wang.yaxin@zte.com.cn,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, ljs@kernel.org
References: <20260703162510242nxmjbcLy5ccp1dbZSK3EU@zte.com.cn>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260703162510242nxmjbcLy5ccp1dbZSK3EU@zte.com.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: htfrgapyq4s78j81ypwpetbkxec6dcno
X-Rspamd-Queue-Id: A4034140002
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783320820-62353
X-HE-Meta: U2FsdGVkX19mZUeM47MXCDHYZaAR76LbQt5FMkLb8S3mHsO5amTQtCO/2Zh4U7fiAxmDRBZwSzlgjEEiTbAA+dv7iGuJFFWYEWEc1R2X73THQKFrVdfqAvAkwHEbW96LxVfDTlL5wFgM6URBIrF6h32kslpDDPedqC3zcUwxkRcfou03Yr6mkB6KyMc9wZXM546A9dWVpk/pNDDUkaerZ6F7KnLEnha3aeuAWNKd7V9q1jslc0TpcbzIYPe729F0Q/LW4doYMkyn6lw/owZQ3NpR14e2UlAfZKcARnSNdSi6eClC5ozUPNMKKYOuokQAMjieYoN/TWBzK6G1cq5mWA6bjwbJAkeCcoCA+kUQMOH9PJuEGetPmjTWGjQM1IwBzz4WMx2RRrSLBXoWBS2uniuo1qysn94G839vOrfomMcIXAI3HD4QwyjYqON2URhnr9GKYUmo1pYyMcb2y2nFlYZoJlwUMm1h+7ZK4G5Ar5S6/whkgvOUmtpZV5/je527J/u0ZTaiOpJrk6rZBHdZTKazIP1EKBTYGnd4PljmCNVnY6Mo9sR7El92qKoV5zElOzrCZRYmTutsO2sL5Totiqn/c7ufKG0QRMjScvl09p7egO4mGeoLvxSviDD0PkcoFUlX2cKe9shaygjdee7DSyaCywoIvZHIY1yxzLZAbH8fHkzP5abEyKYdn6+mJH00bX7awitYs3DLJvCOiO665Gg/phkdaexoYyeB2IHcT3fMT1GT8mFZD1RwYxGUgeN1d/y/BSxINgqWstwqv/pHv2m1nyQfu9eyUSvybr3D2Z+fDa02mPRzKxDVgAiNbs8jGUfpyG67vRjkhDBXxWOYGdbLKWYxf1pJnie3xwfJLiqncwKazN/falzGfnzi7aMjSsZpq8SbJrYthnQ90HgZi9u1NzZFIMW5eY6noiDn0nFkYz2U4Kv7T1LA3v0pK8xU8rgUs67Xv8nzK203wH+
 3wnBanmZ
 FBUUwpb4Oy6vXOGR1GQCc/ZXKW18vePbTUcAP5qWWqWNC1EuzjLrjWhyPy1m7+OU9O8rkYkZBFXVL6f35DUVlXPQYNZ0yUeORIfDhCvOP8cPS/6rCPs3LMCUHreIUammP2D+rJraZcJZNi8M4H9Mhevd//jX9u1lfIYXgrKZg3iTiZb0XZPKCmXirpTRJxHrRSwmWOYaPwt4lKWuzVzTriDBX6HeFSgGpTG/UBzRrDMSe9kMd/BmnG6xQruNibiC1kdM1IPbNnil8lu6xOSyRJla9U+d89dd/L55dZIy0VvA9dKxi7gWJ7n8ICiAmTzLyECNDYVKJxN2SxwMUYp52vFrHKUoOHDVtcOhF6JdETyk6NzRuSs7uWYNMrl70UqLSTMgY+9REtYZG7UQhHlzjoeDmdhaI7sPcri7m
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/3/26 10:25, xu.xin16@zte.com.cn wrote:
> From: xu xin <xu.xin16@zte.com.cn>
> 
> User impact / Why this matters to Linux users
> =============================================
> When a system runs with KSM enabled and memory becomes tight, KSM pages
> may be swapped out or migrated. The kernel then performs a reverse map
> walk by rmap_walk_ksm to locate all page table entries that reference
> these pages. If A large number of unrelated VMAs can attach to a single
> anon_vma related with this KSM page, then rmap_walk might be severe
> performance bottleneck.  In our embedded test environment, we observed
> ~20,000 VMAs sharing one anon_vma without any fork – purely from VMA
> splits， which cause 200~700ms duration of rmap_walk_ksm.
> 
> When one of those VMAs mapped a KSM page, then this KSM page's rmapping
> will become bottleneck with hold its anon_vma lock for a long time. The
> anon_vma lock is not only used by KSM; it is a core lock protecting the
> VMA interval tree and is acquired by many critical memory operations:
> 
>   • Page faults: do_anonymous_page(), do_wp_page() (during COW)
>   • Memory reclaim: try_to_unmap()
>   • Page migration & compaction: migrate_pages(), compact_zone()
>   • mlock / munlock: mlock_fixup()
>   • Process exit: exit_mmap() (tearing down VMAs)
>   • Cgroup memory accounting: mem_cgroup_move_charge()
> 
> If one thread holds the anon_vma lock for hundreds of milliseconds
> because of an inefficient KSM rmap walk, any other thread that
> tries to acquire the same lock (e.g., an application taking a page
> fault, kswapd reclaiming pages, or a migration thread) will block.
> This leads to stalled application threads, increased latency
> spikes, and in extreme cases container timeouts or watchdog
> triggers.
> 
> This patch reduces the worst-case anon_vma lock hold time during
> ksm_rmap_walk from >500 ms to <1 ms, thereby almost eliminating
> this source of lock contention and improving system responsiveness
> under memory pressure.
> 
> Real-world examples:
> ====================
>  - JVM / Go runtime: These use mmap for heap regions and later call
> mprotect(PROT_NONE) for garbage collection barriers or guard pages,
> splitting the original VMA into thousands of small pieces over time.
> 
>  - Database engines (MySQL, PostgreSQL): Large shared memory buffers
> or anonymous mappings are managed with madvise(MADV_DONTNEED) to
> release specific pages, which also splits VMAs.
> 
> Root Cause
> ==========
> Through local debugging trace analysis, we found that most of the
> latency of rmap_walk_ksm occurs within anon_vma_interval_tree_foreach,
> leading to an excessively long hold time on the anon_vma lock (even
> reaching 500ms or more), which in turn causes upper-layer applications
> (waiting for the anon_vma lock) to be blocked for extended periods.
> 
> Further investigation revealed that 99.9% of iterations inside the
> anon_vma_interval_tree_foreach loop are skipped due to the first check
> "if (addr < vma->vm_start || addr >= vma->vm_end)), indicating that a
> large number of loop iterations are ineffective. This inefficiency
> arises because the start page index and the end page index parameters
> passed to anon_vma_interval_tree_foreach span the entire address space
> from 0 to ULONG_MAX, resulting in very poor loop efficiency.
> 
> Solution
> ========
> We cannot rely solely on anon_vma to locate all PTEs mapping this page
> but also need to have the original page's linear_page_index. Since the
> implementation of anon_vma_interval_tree_foreach — it essentially
> iterates to find a suitable VMA such that the provided page index
> falls within the candidate's vm_pgoff range.
> 
> vm_pgoff <= original linear page offset <= (vm_pgoff + vma_pages(v) - 1)
> 
> Fortunately, an earlier commit introduced the linear_page_index to struct
> ksm_rmap_item, allowing for optimizing the RMAP walk.
> 
> Test results
> ============
> A rmap testbench can be obtained with two Out-Of-Tree patches at [1][2].
> After applying the OOT patches and building rmap_benchmark from:
> tools/testing/rmap/rmap_benchmark.c, we can start the performance test.
> 
> The testing result in QEMU is shown as follows:
> 
> KSM rmapping	Maximum duration		Average duration
> 
> Before:		705.12 ms (705119858 ns)	532.04 ms (532041586 ns)
> After:		1.67 ms (1665917 ns)		1.44 ms (1443784 ns)
> 
> The benchmark numbers are realistic, since we observed ~20,000 VMAs
> sharing one anon_vma on a production system running a Java application
> with KSM enabled. The lock hold time before the patch was measured at
> 228 ms (max) during rmap walks triggered by memory compaction and page
> migration. The benchmark reproduces that VMA count and lock‑hold
> behavior in a controlled environment.
> 
> [1] https://lore.kernel.org/all/202605301703094695zmVgcSC27BNR0rH0N8_x@zte.com.cn
> [2] https://lore.kernel.org/all/20260530170404509QpJmBtpSjn3uQHeVKA2iA@zte.com.cn/
> 
> Co-developed-by: Wang Yaxin <wang.yaxin@zte.com.cn>
> Signed-off-by: Wang Yaxin <wang.yaxin@zte.com.cn>
> Signed-off-by: xu xin <xu.xin16@zte.com.cn>

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

