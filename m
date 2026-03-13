Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83957105F796
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 10:47:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C4136B0005; Fri, 13 Mar 2026 06:47:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 99BCA6B0088; Fri, 13 Mar 2026 06:47:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A76C6B0089; Fri, 13 Mar 2026 06:47:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 771D76B0005
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 06:47:00 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0D7AE8C7AB
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 10:47:00 +0000 (UTC)
X-FDA: 84540712200.18.8A92352
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	by imf27.hostedemail.com (Postfix) with ESMTP id 38B1140003
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 10:46:58 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BVDd7MlF;
	spf=pass (imf27.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773398818;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oMlGBf2OWloMdso6OZPAQ/moNlC+lzmEsASkl2aA/OA=;
	b=Wd0AeI+T0G2jehTh3OWAnIiPBzSl/hnZZx59fpnPL2RAHMoIGrvbrUKQQMw65Dd6UYoIVr
	Vgu/SpX17x2l1nnIZADdO+VD5e3fnZs4v0LfFNwVVt+2ph/MhkId4t/LZyMrM6wdgHOTgN
	Gt9nTpFFiIQOasR53NzY/uwZ8BacBrk=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BVDd7MlF;
	spf=pass (imf27.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773398818; a=rsa-sha256;
	cv=none;
	b=cRP6IYogVR04ihUSgQ44Rkh1q4DkXTXzhEbVdct7Ch66E+UHo8xH+SBXBbw/JWjcxKJ/qy
	43laP3NoIPYziwG2GIx9cOaxl6A1dIHv8FyHte64mx/FJhE95zZrPtOK5cNviyenX4fOGA
	kcKvLxKn40Rtj0PSlQxIrjYcqMYRSl4=
Message-ID: <1405ca44-a629-4152-9c87-4e63954bfed4@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773398816;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oMlGBf2OWloMdso6OZPAQ/moNlC+lzmEsASkl2aA/OA=;
	b=BVDd7MlFKbVeADMnMFdEl3yGl2aDtjqZ/P5JEg4n+z0M7IuHFIrtNIpU9+z0xI+X+KY3FU
	uMkhJc6cCvm4GGMkPNFQI+YE8+gAc9rSJMsWtmXldC8X4vXPdzHFdq3FpFwetl3QM/qQ6z
	YOa9nsuCyOAXPgydKfcWMXifGUUInMs=
Date: Fri, 13 Mar 2026 13:46:47 +0300
MIME-Version: 1.0
Subject: Re: [PATCH v4 0/2] binfmt_elf: Align eligible read-only PT_LOAD
 segments to PMD_SIZE for THP
Content-Language: en-GB
To: Baolin Wang <baolin.wang@linux.alibaba.com>, WANG Rui <r@hev.cc>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Andrew Morton <akpm@linux-foundation.org>, Barry Song <baohua@kernel.org>,
 Christian Brauner <brauner@kernel.org>, David Hildenbrand
 <david@kernel.org>, Dev Jain <dev.jain@arm.com>, Jan Kara <jack@suse.cz>,
 Kees Cook <kees@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Matthew Wilcox <willy@infradead.org>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Zi Yan <ziy@nvidia.com>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260310031138.509730-1-r@hev.cc>
 <349671d5-f5aa-48a2-9bba-00aef167b836@linux.alibaba.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <349671d5-f5aa-48a2-9bba-00aef167b836@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 38B1140003
X-Rspamd-Server: rspam07
X-Stat-Signature: 1d7kngir3i55d576era8358c5kmqt5i8
X-Rspam-User: 
X-HE-Tag: 1773398818-178627
X-HE-Meta: U2FsdGVkX18OKtoKg9Kol3wUfs0F8dPI8HRfFJ2m0kTeeMhom+BcHIHU6160x9sOTAag+CA1vdkEvKmBAICBN+JGL/Rb3SvakTzCfjAzYSYsmIndaUrJN8PxtXrylA13X2qB1slq1fUNQocau5wVchKdLGH86g6ikvP2ocu2q7wpQYga7/h1CvTL40ku7yg6icDpwp246VYLOE7++vQh439SsC0fOfds5Q/HJJ9lDwH4yJP9DQXQi9BQOciQpZ/YVLxqY8wYxCAx2EkOsRC1T/OV1t2EPSfrTzBLa7dvfgFQ1i2TYSz/Hk6cV16wMSnGsSL9gMGttc+WJIiN6xW5xtEilyzki1yUobnUafsbzd61epRSovAZX0qJaHJ1zrnQ9aeO02l68OlDWkomZyWYZqBxrex9qDzPA1TiHi3dqu3JOdKmx3EHolPCkj2XTfmJGJCXNYrMYNLEz9WNoHzAuJXmZNGfbwzLJQlRQJvrCmcDoI3lXn32ZIUIWz/eWGyIXF33HtQJPvKFFDdpGo4O2lvLt1+qNxheBkZeLA3U1nylHFEtm3Et3vyYF/XD1qlgGRLTFOLU9QkXYWAc0m2WTJRLktB+GRlh+WCyXn9BpEDhGjUmG02ymneYC53I1PebcgKbqYZurgRORRu5G4San9cz3cNpaKGsfEVJcuEFJ2eqnSPUKFZUrJUKnXLMzNuGCaXFlBnrBGqXsMguEH2d47SAvLstkP/89hNWW4lfO4UD90W7y3qvb2JC3zWF1OgeCp62ttEKfc3k+xDDD7Gh/ABtGyxNJJBLkHSmwOOBYfbD1azYuFXck726QDxzY3nmeJIZ6ts5Noe+OlZNG9tQg866IrmAkcftahQc39qm+23HdV+Np5RqMqalfkPum84G1assQHlpuvwfDA0rhh/nlGZk912emKB2s2sOXBpbhkcQAgwWsrNIJwq03Eh4Q+eUGhBwPBDq6ZcicdMNNjE
 A4XKJYVe
 yNF3txPZqs/YYg9NH/YJ+HlpX7JpqQGjm6YbXlJEeVsgbdUu5u/eNGCLeSO7s1bOV4zgw4Yqvb0vjekhBl/nd0vKEJvkcVx+kLoS9pMom0xY0NdiHzlkRCJykFgyA8PUE6zYXMXaPzPXA7NFoc4leK3Fh9KtqolbtrilsmzD9/6DB3EldVMZ5ZnE6sDh09Lv+85dVzyD/M/L3QRIpIrlUhzSGSQdTYdRYqBW956blKXoisKrbX/qZzGVDBfIrV5WQ7J7YSA09Gryo+WfK06hYL/szMKWyoVOcKAsE9MjouAe9+pEwMmc7xzzuzQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 13/03/2026 11:41, Baolin Wang wrote:
> CC Usama
> 
> On 3/10/26 11:11 AM, WANG Rui wrote:
>> Changes since [v3]:
>> * Fixed compilation failure under !CONFIG_TRANSPARENT_HUGEPAGE.
>> * No functional changes otherwise.
>>
>> Changes since [v2]:
>> * Renamed align_to_pmd() to should_align_to_pmd().
>> * Added benchmark results to the commit message.
>>
>> Changes since [v1]:
>> * Dropped the Kconfig option CONFIG_ELF_RO_LOAD_THP_ALIGNMENT.
>> * Moved the alignment logic into a helper align_to_pmd() for clarity.
>> * Improved the comment explaining why we skip the optimization
>>    when PMD_SIZE > 32MB.
>>
>> When Transparent Huge Pages (THP) are enabled in "always" mode,
>> file-backed read-only mappings can be backed by PMD-sized huge pages
>> if they meet the alignment and size requirements.
>>
>> For ELF executables loaded by the kernel ELF binary loader, PT_LOAD
>> segments are normally aligned according to p_align, which is often
>> only page-sized. As a result, large read-only segments that are
>> otherwise eligible may fail to be mapped using PMD-sized THP.
>>
>> A segment is considered eligible if:
>>
>> * THP is in "always" mode,
>> * it is not writable,
>> * both p_vaddr and p_offset are PMD-aligned,
>> * its file size is at least PMD_SIZE, and
>> * its existing p_align is smaller than PMD_SIZE.
>>
>> To avoid excessive address space padding on systems with very large
>> PMD_SIZE values, this optimization is applied only when PMD_SIZE <= 32MB,
>> since requiring larger alignments would be unreasonable, especially on
>> 32-bit systems with a much more limited virtual address space.
>>
>> This increases the likelihood that large text segments of ELF
>> executables are backed by PMD-sized THP, reducing TLB pressure and
>> improving performance for large binaries.
>>
>> This only affects ELF executables loaded directly by the kernel
>> binary loader. Shared libraries loaded by user space (e.g. via the
>> dynamic linker) are not affected.
> 
> Usama posted a similar patchset[1], and I think using exec_folio_order() for exec-segment alignment is reasonable. In your case, you can override exec_folio_order() to return a PMD‑sized order.
> 
> [1] https://lore.kernel.org/all/20260310145406.3073394-1-usama.arif@linux.dev/
> 

Thanks for the CC Baolin! Happy to see someone else noticed the same issue!

Yeah I agree, I think piggybacking off exec_folio_order() as done in 1 should be
the right appproach.

I also think there is maybe a bug in do_sync_mmap_readahead that needs to be fixed
when it comes to mmap_miss counter [2].


[1] https://lore.kernel.org/all/20260310145406.3073394-1-usama.arif@linux.dev/
[2] https://lore.kernel.org/all/20260310145406.3073394-3-usama.arif@linux.dev/

>> Benchmark
>>
>> Machine: AMD Ryzen 9 7950X (x86_64)
>> Binutils: 2.46
>> GCC: 15.2.1 (built with -z,noseparate-code + --enable-host-pie)
>>
>> Workload: building Linux v7.0-rc1 vmlinux with x86_64_defconfig.
>>
>>                  Without patch        With patch
>> instructions    8,246,133,611,932    8,246,025,137,750
>> cpu-cycles      8,001,028,142,928    7,565,925,107,502
>> itlb-misses     3,672,158,331        26,821,242
>> time elapsed    64.66 s              61.97 s
>>
>> Instructions are basically unchanged. iTLB misses drop from ~3.67B to
>> ~26M (~99.27% reduction), which results in about a ~5.44% reduction in
>> cycles and ~4.18% shorter wall time for this workload.
>>
>> [v3]: https://lore.kernel.org/linux-fsdevel/20260310013958.103636-1-r@hev.cc
>> [v2]: https://lore.kernel.org/linux-fsdevel/20260304114727.384416-1-r@hev.cc
>> [v1]: https://lore.kernel.org/linux-fsdevel/20260302155046.286650-1-r@hev.cc
>>
>> WANG Rui (2):
>>    huge_mm: add stubs for THP-disabled configs
>>    binfmt_elf: Align eligible read-only PT_LOAD segments to PMD_SIZE for
>>      THP
>>
>>   fs/binfmt_elf.c         | 29 +++++++++++++++++++++++++++++
>>   include/linux/huge_mm.h | 10 ++++++++++
>>   2 files changed, 39 insertions(+)
>>
> 


