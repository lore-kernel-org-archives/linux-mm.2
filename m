Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8E65C61DD6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 01:10:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D7ECB6B008C; Tue,  1 Sep 2026 21:10:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D294F6B0092; Tue,  1 Sep 2026 21:10:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C182F6B0095; Tue,  1 Sep 2026 21:10:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 852786B008C
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 21:10:34 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CF97F1605C8
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 01:10:33 +0000 (UTC)
X-FDA: 85167041946.24.50975EA
Received: from canpmsgout10.his.huawei.com (canpmsgout10.his.huawei.com [113.46.200.225])
	by imf19.hostedemail.com (Postfix) with ESMTP id 80B2F1A0007
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 01:10:30 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=gxQtifHk;
	spf=pass (imf19.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.225 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788311432;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ueZfUdbICpbFc4QJdF1KNCrnQsrHgevLIv0afVFUmZM=;
	b=lcXirgucmPvs+CuErNbff2909r2Ek5Is9hzbDZ60DFsNBK6o3+FpJ7o0DPmjrnr35EbMju
	SklzUEK4vXeUhtrXSJ6i7QmjDJLom+YbTUfLxfEBeXSbGi1H0dXda2KNzMMB04BVL9nsUm
	P/qmPuTI2GVdxvChqq96VT0jOij+L7Y=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788311432;
	b=X9YBS+AFi+EQouEptfBQ87kSIta4XtMzmJOOPEhVZyaQDnh8RZ6Z94KRqWLjM0bb3ejaC0
	W/SpjBcIaHDq4XTmS4rUp37Lr707nTpWExBEqTvkEfoh1n50oEDLcNCic5rXuxZ5J/LxEh
	ei2r/vig3IE+OIMI0pumlSknq4DYEEY=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=gxQtifHk;
	spf=pass (imf19.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.225 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=ueZfUdbICpbFc4QJdF1KNCrnQsrHgevLIv0afVFUmZM=;
	b=gxQtifHkaLPw22BF6n0KMEk10IuxeqmsMYYop/hUPqKEf8knsZeKMkjksoN1EG/Q1sd/O9Di/
	MWC9d9+IV55CGBmQmL79IAHmaox4lGW98FrA6ZXZh/7XOquukuCJCl9vL3nrYSwO4ytzpow/EiG
	bZELp1KK04KMfSbcfFS8Feg=
Received: from mail.maildlp.com (unknown [172.19.163.163])
	by canpmsgout10.his.huawei.com (SkyGuard) with ESMTPS id 4hZPWl0vM1z1K96m;
	Wed,  2 Sep 2026 08:59:31 +0800 (CST)
Received: from dggpemf500011.china.huawei.com (unknown [7.185.36.131])
	by mail.maildlp.com (Postfix) with ESMTPS id 13A854048B;
	Wed,  2 Sep 2026 09:10:21 +0800 (CST)
Received: from [10.67.109.254] (10.67.109.254) by
 dggpemf500011.china.huawei.com (7.185.36.131) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 2 Sep 2026 09:10:18 +0800
Message-ID: <bf0e158e-4bd0-4495-a9e2-983556e4041b@huawei.com>
Date: Wed, 2 Sep 2026 09:10:16 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 01/17] kexec: Record allocated CMA pages to fix release
 size mismatch
To: Mike Rapoport <rppt@kernel.org>
CC: <catalin.marinas@arm.com>, <will@kernel.org>, <mark.rutland@arm.com>,
	<chenhuacai@kernel.org>, <kernel@xen0n.name>, <maddy@linux.ibm.com>,
	<mpe@ellerman.id.au>, <npiggin@gmail.com>, <chleroy@kernel.org>,
	<tglx@kernel.org>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <hpa@zytor.com>, <akpm@linux-foundation.org>,
	<baoquan.he@linux.dev>, <pasha.tatashin@soleen.com>, <pratyush@kernel.org>,
	<ruirui.yang@linux.dev>, <kees@kernel.org>, <thuth@redhat.com>,
	<gshan@redhat.com>, <jic23@kernel.org>, <james.morse@arm.com>,
	<ardb@kernel.org>, <leitao@debian.org>, <yeoreum.yun@arm.com>,
	<sourabhjain@linux.ibm.com>, <coxu@redhat.com>, <tangyouling@kylinos.cn>,
	<hbathini@linux.ibm.com>, <adityag@linux.ibm.com>,
	<ionut.nechita@windriver.com>, <liaoyuanhong@vivo.com>, <seanjc@google.com>,
	<fuqiang.wang@easystack.cn>, <makb@juniper.net>, <piliu@redhat.com>,
	<ebiggers@kernel.org>, <jbouron@amazon.com>, <mclapinski@google.com>,
	<me@linux.beauty>, <graf@amazon.com>, <bgwin@google.com>, <robh@kernel.org>,
	<takahiro.akashi@linaro.org>, <palmer@rivosinc.com>, <x86@kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<loongarch@lists.linux.dev>, <linuxppc-dev@lists.ozlabs.org>,
	<kexec@lists.infradead.org>, <linux-fsdevel@vger.kernel.org>,
	<linux-mm@kvack.org>
References: <20260826092541.3905933-1-ruanjinjie@huawei.com>
 <20260826092541.3905933-2-ruanjinjie@huawei.com>
 <178829364020.3691424.12323275610442178748.b4-review@b4>
From: Jinjie Ruan <ruanjinjie@huawei.com>
In-Reply-To: <178829364020.3691424.12323275610442178748.b4-review@b4>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.109.254]
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 dggpemf500011.china.huawei.com (7.185.36.131)
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 80B2F1A0007
X-Stat-Signature: 9nr7yaf3mjcc51ssuhi3eb5bs9mbrkqw
X-HE-Tag: 1788311430-321839
X-HE-Meta: U2FsdGVkX1/KTEN40au6b+UmXMAbDBkvW7oEdk7T+HYT6i81ME0p2qTVU8ZfNzHpYJWrmHmwlNhJj4R1Qd6aYogaAMe/daAi7AVRyLc1vLwmO0HZVxbY6Dd6jNHv2MOPx21N3sdTDSVRjEHrkRsyzq1Aj3+ZkZ6XrPwgt5LKQe502sopVoYYogUyuPj4I2E29HXP58a7fqaRMHBmR7kDvijEgnhXd/7nCuCrvkGn+3YPGecO93Kvdu9cj5M4TDGHW6j7W48pnd/nmagKoqxHzTI2PFetfhnogNjOohRHFF31CsIiQ3+Q7bkvLU0KWcjt2TbU1x/X7a94IXMd7+maG5yB3/s+w9FI/bOHGLvRqU33IYtLkulwGIPnMntZ5aaRF9wsN7DphMHe4IYeaFo1LR6ogGck4DMC1sQ6d5NzoqEOkzZ/rB439ppMHWLbSSXQ76FNe4cr33/9FN0YDhRcPfvw7ulDQZILbltSKbTg5L7sRRGdgN6vZGMsoXg66xQ6E8JQeuX6yXFjAuWqsqeV0U78//2Xj1g7vGPOMqpkzeoNcjgou8alK5owyl83oYRyQ51O6qIPiikD+2fq2pYrGFe9jQ10M21kW4hcT0PW+lZ8O9dycfTxfd+gmvvzjduwYvLmJb9L3NfEE5vKX+jBmDNsCM0OqVpqxaxVltLM8meFxEX5wm/H0VOI9CpXWofPz5dyzDetWc3MAzQBRhqkjj/x01lBx6g6jsbFnxhLWDdt1Uui/rmQcRi22L7Z+vvrIxOxWReljxhjMrk2UhtbvL9gFz1tHttxRopDJ+kzN+/gUv4mhbOz5p5S7Yud22OyMmv1l/20BplM35DEXF5i4EuqfphmXqeijyfevR3MNb8+2EUkKViW0RpTPH3g4KJtn/N+90tNGuwJW/yVHi1/APLm+xfuDOyVrf68n29gVuplOYcCR6+WzhH1y3REoCGoBQwDrCIlTbXQ8oX1REr
 r6vN1HdU
 a18H46VG4yYS/QV8Jih1KVt9tcdY7BhONyJpFCrTWkyu1Crpfs2Li+w2pnwBSioif7mYx4ttCkyFOfHTPHaQMMPvsx/zVquk27Y/eRG2mi6xFysK0owQO8CtrkhvM2d+NP7arO66TjJWGdjnKygfmFPK7gZ31ILxqXq4ommCA4hNzUBiW1utpm4xHYl9S8rerjZkI91N7b0Ut+IdY3/ZBJChUvmV4xEmQhwynKwHZPGPmSjk5E2dnlyBymPJ0XH6lXrb07degAbey/gwo+/jzzjqjSJz9CEcHw2Odz0uFycHwI/M5ZLzGOLmMk+MJuxtB042NC0IZ0xuHo6RMhQZaBAs1fmekxsbsGNLSY2D7R37Urj+J1NwzIydybnVa/Arq2VcNXzbN4OPrtPRqRcpCzhuIRtM81VyBBXwZrRphQWOelGekVSnggAnTy00rJs3U5PyeH0Ncg8oVDVQ8rAyNU3o2hECEbxkjX8GrGbtD1a/vGNyO0CNMe/UbjSmUvrxenVnGtahiksTPjMYA0ZXTVT+YNK2KqmnF5wN7IJgB2wTBg0PmygHDef4g4YscLo3kdQxoceIl/V19It/fR6ecj/H3v78dGdiwaxqeA7/euaBCvh9+o+sJzaO7nnN2cCVF5NSlhbc32Px0Ma34Ck4vRZSo0hNVyS9r8YpWE0yEmBXo6KVd6fHcSyUnqf1QAX/bJitJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2026/9/2 4:14, Mike Rapoport 写道:
> Hi,
> 
>> The CMA pages allocated for a kexec segment are released using the
>> segment's memsz to calculate the number of pages. However, some
>> architecture loaders modify the segment's memsz after allocation
>> (e.g. arm64 subtracts text_offset), causing the release function to
>> free fewer pages than were originally allocated, leaking the remaining
>> CMA pages.
>>
>> Add a per-segment `segment_cma_pages` array to store the number of
>> pages actually allocated from CMA. Populate it during
>> kexec_add_buffer() using the aligned memsz, and use it in
>> kimage_free_cma() to accurately release all allocated pages.
>>
>> This avoids relying on the potentially modified segment->memsz and
>> prevents silent CMA memory leaks.
>>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Cc: Baoquan He <baoquan.he@linux.dev>
>> Cc: Mike Rapoport <rppt@kernel.org>
>> Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
>> Cc: Pratyush Yadav <pratyush@kernel.org>
>> Cc: Brian Mak <makb@juniper.net>
>> Cc: Pingfan Liu <piliu@redhat.com>
>> Cc: Sourabh Jain <sourabhjain@linux.ibm.com>
>> Cc: Justinien Bouron <jbouron@amazon.com>
>> Cc: Li Chen <me@linux.beauty>
>> Cc: stable@vger.kernel.org
>> Link: https://sashiko.dev/#/patchset/20260729031235.2840255-1-ruanjinjie%40huawei.com
>> Fixes: 07d24902977e ("kexec: enable CMA based contiguous allocation")
>> Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
>>
>> diff --git a/include/linux/kexec.h b/include/linux/kexec.h
>> index 0af8ae4fdd087..83c296c0eb6cc 100644
>> --- a/include/linux/kexec.h
>> +++ b/include/linux/kexec.h
>> @@ -349,6 +349,7 @@ struct kimage {
>>  	unsigned long nr_segments;
>>  	struct kexec_segment segment[KEXEC_SEGMENT_MAX];
>>  	struct page *segment_cma[KEXEC_SEGMENT_MAX];
>> +	unsigned int segment_cma_pages[KEXEC_SEGMENT_MAX];
> 
> Can we universally use unsigned long for number of pages?

Hi Mike,

unsigned int is used here because the second parameter of
arch_kexec_pre_free_pages is unsigned int.

static inline void arch_kexec_pre_free_pages(void *vaddr, unsigned int
pages) { }

> 
>>  
>>  	struct list_head control_pages;
>>  	struct list_head dest_pages;
>> diff --git a/kernel/kexec_core.c b/kernel/kexec_core.c
>> index dc770b9a6d053..611b15bb1369e 100644
>> --- a/kernel/kexec_core.c
>> +++ b/kernel/kexec_core.c
>> @@ -560,7 +560,7 @@ static void kimage_free_cma(struct kimage *image)
>>  
>>  	for (i = 0; i < image->nr_segments; i++) {
>>  		struct page *cma = image->segment_cma[i];
>> -		u32 nr_pages = image->segment[i].memsz >> PAGE_SHIFT;
>> +		unsigned int nr_pages = image->segment_cma_pages[i];
>>  
>>  		if (!cma)
>>  			continue;
>> @@ -568,6 +568,7 @@ static void kimage_free_cma(struct kimage *image)
>>  		arch_kexec_pre_free_pages(page_address(cma), nr_pages);
>>  		dma_release_from_contiguous(NULL, cma, nr_pages);
>>  		image->segment_cma[i] = NULL;
>> +		image->segment_cma_pages[i] = 0;
>>  	}
>>  
>>  }
>> diff --git a/kernel/kexec_file.c b/kernel/kexec_file.c
>> index 59fb9d71e9d86..bfae3fee7f2f9 100644
>> --- a/kernel/kexec_file.c
>> +++ b/kernel/kexec_file.c
>> @@ -670,7 +670,7 @@ static int kexec_walk_resources(struct kexec_buf *kbuf,
>>  
>>  static int kexec_alloc_contig(struct kexec_buf *kbuf)
>>  {
>> -	size_t nr_pages = kbuf->memsz >> PAGE_SHIFT;
>> +	size_t nr_pages = PFN_DOWN(kbuf->memsz);
>>  	unsigned long mem;
>>  	struct page *p;
>>  
>> @@ -756,6 +756,8 @@ int kexec_locate_mem_hole(struct kexec_buf *kbuf)
>>   */
>>  int kexec_add_buffer(struct kexec_buf *kbuf)
>>  {
>> +	unsigned long nr_segments = kbuf->image->nr_segments;
>> +	size_t nr_pages;
>>  	struct kexec_segment *ksegment;
>>  	int ret;
>>  
>> @@ -763,7 +765,7 @@ int kexec_add_buffer(struct kexec_buf *kbuf)
>>  	if (!kbuf->image->file_mode)
>>  		return -EINVAL;
>>  
>> -	if (kbuf->image->nr_segments >= KEXEC_SEGMENT_MAX)
>> +	if (nr_segments >= KEXEC_SEGMENT_MAX)
>>  		return -EINVAL;
>>  
>>  	/*
>> @@ -789,12 +791,18 @@ int kexec_add_buffer(struct kexec_buf *kbuf)
>>  		return ret;
>>  
>>  	/* Found a suitable memory range */
>> -	ksegment = &kbuf->image->segment[kbuf->image->nr_segments];
>> +	ksegment = &kbuf->image->segment[nr_segments];
>>  	ksegment->kbuf = kbuf->buffer;
>>  	ksegment->bufsz = kbuf->bufsz;
>>  	ksegment->mem = kbuf->mem;
>>  	ksegment->memsz = kbuf->memsz;
>> -	kbuf->image->segment_cma[kbuf->image->nr_segments] = kbuf->cma;
>> +	kbuf->image->segment_cma[nr_segments] = kbuf->cma;
>> +	if (kbuf->cma) {
>> +		nr_pages = (unsigned int)(PFN_DOWN(kbuf->memsz));
>> +		kbuf->image->segment_cma_pages[nr_segments] = nr_pages;
> 		kbuf->image->segment_cma_pages[nr_segments] = nr_pages;
>> +	} else {
>> +		kbuf->image->segment_cma_pages[nr_segments] = 0;
>> +	}
> 
> I suggest to rename nr_pages to nr_cma_pages, initialize it to 0 at
> declaration time and make this

I agree with this.

> 
> 	if (kbuf->cma)
> 		nr_cma_pages = PFN_DOWN(kbuf->memsz);
> 	kbuf->image->segment_cma_pages[nr_segments] = nr_cma_pages;
> 


