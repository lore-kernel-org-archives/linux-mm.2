Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9B80606C654
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 09:16:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=V0JuNsqt
Received: by kanga.kvack.org (Postfix)
	id D6E716B05BF; Tue, 10 Nov 2026 04:16:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1CCE6B05C0; Tue, 10 Nov 2026 04:16:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C334D6B05C1; Tue, 10 Nov 2026 04:16:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 90E1E6B05BF
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 04:16:48 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 156421C3F1F
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:16:48 +0000 (UTC)
X-FDA: 85418654496.04.F7211AE
Received: from canpmsgout10.his.huawei.com (canpmsgout10.his.huawei.com [113.46.200.225])
	by imf29.hostedemail.com (Postfix) with ESMTP id 77A6A12000D
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:16:43 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=V0JuNsqt;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf29.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.225 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794302205;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BvvMubdD0ab9qXTzvi78Wzx6n/mu2aOjNES6c6xFfUo=;
	b=MXn1QCjHXVvOIv56T90zRbRN3RA9irLVpWQCiTSws4cWEN1er0854RuHQoZaLLYjtkJUGj
	8TTyrs+SpnRBnbx+Mwb6Hexm6n+AreIL9Qs9ecXkzwx76NdV+UUIARCqUhpiygB6RpFThl
	N7Jh3+1c+7FgWcVY9wG5K66gt7Q79M0=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=V0JuNsqt;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf29.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.225 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794302205;
	b=YH9fL6qJwW9b8niRYcuYlYiGz3NFPX32ub2nLRFnUnHyoFdHrQ0ePmS/NpWA5100CqbArL
	Un8317o8HDaMT/cEkYK/SuTTn+GEbwARsUWfBl1zmflmrrYSTVkbpiJlZs5tAl6KSjfyYH
	XP2JCSosc33fsZR+djmJPUCwhwELCaI=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=BvvMubdD0ab9qXTzvi78Wzx6n/mu2aOjNES6c6xFfUo=;
	b=V0JuNsqtcvHvWZar8RQGhcZaYErUdAWqJ1nV312WRgaycNnJ1zsFEq4gL5SRY2frvA0hfpC1l
	+o01tk/z0saf3sDH7onJDGrLuaaZUu7YfpRbV38fFrR23kuY4Ztb4i1hCOOJLP9hHD2sNLbaSku
	cALfpikEjxvECDHlXpMIiVM=
Received: from mail.maildlp.com (unknown [172.19.163.127])
	by canpmsgout10.his.huawei.com (SkyGuard) with ESMTPS id 4jP1HL05wvz1K96b;
	Tue, 10 Nov 2026 17:16:30 +0800 (CST)
Received: from kwepemk300003.china.huawei.com (unknown [7.202.195.93])
	by mail.maildlp.com (Postfix) with ESMTPS id A668140561;
	Tue, 10 Nov 2026 17:16:38 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 kwepemk300003.china.huawei.com (7.202.195.93) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Tue, 10 Nov 2026 17:16:37 +0800
Message-ID: <3a66ba8f-96dd-4215-8c4d-0cc3c286375a@huawei.com>
Date: Tue, 10 Nov 2026 17:16:36 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 13/20] arm64: Support hugetlb vmemmap optimization
To: Muchun Song <muchun.song@linux.dev>, James Houghton
	<jthoughton@google.com>
CC: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
	Oscar Salvador <osalvador@suse.de>, Andrew Morton
	<akpm@linux-foundation.org>, Nikos Nikoleris <nikos.nikoleris@arm.com>, Linu
 Cherian <linu.cherian@arm.com>, Mark Rutland <mark.rutland@arm.com>, David
 Hildenbrand <david@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>, Nanyong
 Sun <sunnanyong@huawei.com>, Yu Zhao <yuzhao@google.com>, Frank van der
 Linden <fvdl@google.com>, David Rientjes <rientjes@google.com>,
	<linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<linux-mm@kvack.org>
References: <20261003002123.505555-1-jthoughton@google.com>
 <20261003002123.505555-14-jthoughton@google.com>
 <CAF9824D-CDC5-48E6-A1F6-840CB299EADB@linux.dev>
Content-Language: en-US
From: Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <CAF9824D-CDC5-48E6-A1F6-840CB299EADB@linux.dev>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemk300003.china.huawei.com (7.202.195.93)
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 77A6A12000D
X-Stat-Signature: 9y6d3ca6a9pcntfn4ztxsq7apfqg4e49
X-Rspam-User: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1794302203-689112
X-HE-Meta: U2FsdGVkX18baBeZYUij2WLxOssuLeYBCcXs5ubHzIHC4c2NFRODHNq7XXq4LIJm6MlbQPmhHcQJzH7yvPYt6lEEeXGN5fKTKxQ0TkGl5Z47loqGHJGZjWHZYI/z+U9ACJHtKUqCWXqZHmkXtSj8oeqnmHe8LU1qsXWWU9iMugDFlw5aAcgmx+mDyPUiqzPdwzO4+ZMQIM/Eb6NRSH1ZmVRry8Bm1GLu8Tsh79i7f/sJVPMyj0ioiJdHNetfA+SVx7TflwdNxWMqp1oWkNH8vyHGWyN8m6qDc/mMsQCHuU6IjprCPXHd4/CyPuFyD081xFAUcnlgfBZQgUGr2Jiuolv80fpLMcQ7TZO4Fd6bdx9Zs00b5+Rz8ckPmOurSXOo+R7w24eAV4yg6D6g2r0oTLBsi7EDvpp2S9KAP8qjWaH2agTG8f3ns7YN9cPAz2z4U5pRjdpXbO9Jso5/yg/S6fbWxUwhVebbEQcALa/ulgQbxXoNU2oksrT/T9yY9oLBXCYAh+O0+k3c5+U5kSuCgoQ0wC+OaB4zICpAXLr/EXGuFp3WIHCvJQ+q/UjiVrJdwlJp9e5HZAn7p3658GSGa3IKZ3HMRgWrfK6mNp/nlPEkEMW+PH9pkjVAzfrCwS4Y3q6A0emQ8xIU+1rVumv2Ci23Jl7qEhgwqrw6+TuQBk7tFJVrmzmQUI/zMPh3hN6U0b4MjP7wv4usqYTEAO/7HL4w4CYar7y+69l2SnMkoQEQDhNcSexGwJEljg+JE5aiXNm5zAKBAAIRKm6/SR6+TSZmtHTQoGK2guyAYFgolrkXmIIo7fRU4qiv9Soig4o+7cCYoYhM1L38u9pq2TEkji4FEIGkXeElCooUe2nGiJFFBOaXKmoV+ceiBCqC4lX/o/C6n2COQqZtsfRRdS5XSmY0bXjev9Pe22hmYgrg7oYIihtFaSEnjYhICDu6ovZSENkajhsaUOZyJLbJJNa
 07Jr3nQl
 cZugdaALi16e4hNkWWknbyQiZWDi1gNdxYuD9xMD0jkLYnoQdsLtFK8iVGdbGMvkSmzRN0XIiO15idgfsTNyRW24U7mdZ3TwuNv33vq+wZa1/rc9vF0CD8z+6jHD6hEZCue9QdmujNREaqQ9k9kShdlErBFGglCwgmjWiPOrd1DjDooRFJvi2ZrKc5yKoPOBRCl632TsWIvvcv+XS5ag/DabSGX7SbZElw+axSgnOXz2hD38ZuREdb06hNv6w4MygqHKL7WFWpgyVgBB6m5aYo+ZYieIWAHlEtoy6q290pPPHILy09v8LTlEzQ6W70xHBBHweI0PO3LXSIu+dUfGQfiiaGQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/7/2026 2:45 PM, Muchun Song wrote:
> 
> 
>> On Oct 3, 2026, at 08:21, James Houghton <jthoughton@google.com> wrote:
>>
>> Support HVO if HW AF and BBML3 are supported. These are the required
>> features for the vmemmap to be modified in place.
>>
>> On arm64 systems that do not have the required hardware features to
>> support HVO, the HVO sysctl will not appear, and any attempts to enable
>> HVO (either via the command line or via
>> CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP_DEFAULT_ON=y) will have no effect.
>>
>> Signed-off-by: James Houghton <jthoughton@google.com>
>> ---
>> arch/arm64/Kconfig               | 2 ++
>> arch/arm64/include/asm/hugetlb.h | 7 +++++++
>> mm/hugetlb_vmemmap.c             | 4 ++++
>> 3 files changed, 13 insertions(+)
>>
>> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
>> index b51d23a62c92..e4c87487bc7f 100644
>> --- a/arch/arm64/Kconfig
>> +++ b/arch/arm64/Kconfig
>> @@ -92,7 +92,9 @@ config ARM64
>> 	select ARCH_WANT_DEFAULT_TOPDOWN_MMAP_LAYOUT
>> 	select ARCH_WANT_FRAME_POINTERS
>> 	select ARCH_WANT_HUGE_PMD_SHARE if ARM64_4K_PAGES || (ARM64_16K_PAGES && !ARM64_VA_BITS_36)
>> +	select ARCH_WANT_HUGETLB_VMEMMAP_RO_AFTER_INIT
>> 	select ARCH_WANT_LD_ORPHAN_WARN
>> +	select ARCH_WANT_OPTIMIZE_HUGETLB_VMEMMAP if ARM64_HW_AFDBM
> 
> Because vmemmap optimization depends on compound_info_has_mask(), before
> enabling HVO on arm64, its vmemmap start address needs to be aligned to
> MAX_FOLIO_VMEMMAP_ALIGN. Therefore, a prerequisite patch is required.
> 

Agreed, we tried to enable ARCH_WANT_OPTIMIZE_DAX_VMEMMAP[1] on ARM64.
If the alignment is not performed, a warning will be triggered with
DEBUG_VM, see sparse_init(). The same issue applies to 
ARCH_WANT_OPTIMIZE_HUGETLB_VMEMMAP.


[1] enable ARCH_WANT_OPTIMIZE_DAX_VMEMMAP
diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 1075bc661833..649244e55c4b 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -94,6 +94,7 @@ config ARM64
         select ARCH_WANT_FRAME_POINTERS
         select ARCH_WANT_HUGE_PMD_SHARE if ARM64_4K_PAGES || 
(ARM64_16K_PAGES && !ARM64_VA_BITS_36)
         select ARCH_WANT_LD_ORPHAN_WARN
+       select ARCH_WANT_OPTIMIZE_DAX_VMEMMAP
         select ARCH_WANTS_EXECMEM_LATE
         select ARCH_WANTS_NO_INSTR
         select ARCH_WANTS_THP_SWAP if ARM64_4K_PAGES
diff --git a/arch/arm64/mm/init.c b/arch/arm64/mm/init.c
index 4e7682dfe366..6808529873a9 100644
--- a/arch/arm64/mm/init.c
+++ b/arch/arm64/mm/init.c
@@ -91,11 +91,9 @@ phys_addr_t __ro_after_init arm64_dma_phys_limit;
   * has a direct correspondence, and needs to appear sufficiently aligned
   * in the virtual address space.
   */
-#if ARM64_MEMSTART_SHIFT < SECTION_SIZE_BITS
-#define ARM64_MEMSTART_ALIGN   (1UL << SECTION_SIZE_BITS)
-#else
-#define ARM64_MEMSTART_ALIGN   (1UL << ARM64_MEMSTART_SHIFT)
-#endif
+#define ARM64_MEMSTART_ALIGN                                          \
+       max_t(u64, 1UL << max(SECTION_SIZE_BITS, ARM64_MEMSTART_SHIFT),	\
+               PFN_PHYS(MAX_FOLIO_VMEMMAP_ALIGN / sizeof(struct page)))


