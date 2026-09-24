Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 402A6C98318
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 16:12:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 003FC6B008A; Thu, 24 Sep 2026 12:12:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ECF686B008C; Thu, 24 Sep 2026 12:12:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D72B56B0092; Thu, 24 Sep 2026 12:12:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ABB066B008A
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 12:12:57 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5F0AF160432
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 16:12:56 +0000 (UTC)
X-FDA: 85249149552.30.076FC82
Received: from mta1.migadu.com (out-94.mta1.migadu.com [95.215.58.94])
	by imf25.hostedemail.com (Postfix) with ESMTP id DE51CA000C
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 16:12:53 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vvuyppw0;
	spf=pass (imf25.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.94 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790266374;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t9KOuD1e2N9vK51vFGoG009Qk6qgMITkvgNwXFVPFeY=;
	b=DqkrtQXqvfNcelT8JQuJPtwhdVx/bunZNo8fGpShexUNWyyqyX78xb3ETDf8ya2g5ulxjq
	+UrCKmGR4pmvIrKDyUCOm9ymFIrBKdE+Vp7XwOY+4ER6nH4X0tlFfcXK/Wv5fruk216EcH
	hre9eVrylbOdstCfZrZLteBk1YwhM90=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790266374;
	b=xy4112BaOpBUd6NQjGL0mkudY/567lYv13C/HAhoPgdaUc8aXDn+F9WQu9BV0Xrz4V7XZu
	OnKjF47SNcUuTP/+/G8ce8ttADltg9Pn4mnxrmszVSTXXJb1EoiPe9F92IIsA/6/jWEmBZ
	GpzMhNI68Tz0TvTF0shQLnW9kaRmUKY=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vvuyppw0;
	spf=pass (imf25.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.94 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=1ohFjSCIUwpH5qBdu4MdlkXa39XLJc1SPyL+HjcbYJw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790266371; v=1; x=1790871171;
 b=vvuyppw0Z2r0+Rq8/SGGRepA0ks9dB6StSfiBceiUGvawrL0E1Nx+BW222xWQ8Vod/E2OhdO
 AOIufS4fmNtDB3O272S9QoLdcic7AVc5A79YYpO/y3+9CPY85/o1HdtLeFcqev0J0xJjlG2fpJG
 efzA09dt6K09VdcF+TImFDJo=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 87c44c435beead6e;
	Thu, 24 Sep 2026 16:12:51 +0000
X-Mizu-Trace-ID: 87c44c435beead6e
X-Migadu-Flow: FLOW_OUT
Message-ID: <0f5d22fd-24f2-4235-92f5-3dc065e0f153@linux.dev>
Date: Thu, 24 Sep 2026 17:12:46 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RESEND v7 10/29] mm: make PMD migration-entry splitting explicit
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, chrisl@kernel.org,
 kasong@tencent.com, ljs@kernel.org, ziy@nvidia.com, linux-mm@kvack.org
Cc: ying.huang@linux.alibaba.com, Baoquan He <baoquan.he@linux.dev>,
 willy@infradead.org, youngjun.park@lge.com, hannes@cmpxchg.org,
 riel@surriel.com, shakeel.butt@linux.dev, alex@ghiti.fr, kas@kernel.org,
 baohua@kernel.org, dev.jain@arm.com, baolin.wang@linux.alibaba.com,
 Nico Pache <nico.pache@linux.dev>, "Liam R. Howlett" <liam@infradead.org>,
 ryan.roberts@arm.com, Vlastimil Babka <vbabka@kernel.org>,
 lance.yang@linux.dev, linux-kernel@vger.kernel.org, nphamcs@gmail.com,
 shikemeng@huaweicloud.com, yosry@kernel.org, qi.zheng@linux.dev,
 luizcap@redhat.com, kernel-team@meta.com
References: <20260914122950.3283997-1-usama.arif@linux.dev>
 <20260914122950.3283997-11-usama.arif@linux.dev>
 <a8ff997a-2d09-44f4-85c3-322927f75d1d@kernel.org>
Content-Language: en-US
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <a8ff997a-2d09-44f4-85c3-322927f75d1d@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: 1u8zibrr8prbt6z1r54x8saf1aopw3yx
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: DE51CA000C
X-HE-Tag: 1790266373-799465
X-HE-Meta: U2FsdGVkX18fEncV2PXv2QSCMYUWyJn7OiQDJDeY/JJBNPWx3qfimljvfWCRt3LpNw8deWtb3dDdl3TTK1bjMCkbm4jGlzao1Km8yWLcWsokX/D8/kOwQ4pv+kbKqiXY4R7+tHyHBP3vtqGwoH8ulidrD9886miqFg3BrqMKobN8UCnJuW5IBsza3GCWB2wvC+Y0h8oNDgq3FLbrQzKHKVZMQ96R6wxa4i4e8qyRu1bwVU5/cmIo4lk7b4o0POnso0KrljrbF1gQ1TS7rdQ1Tg+ygLYJ+SJb/IKX+OzoqrhgiqoTBVIh8EOsQtrhQ8anBqB+YvS0U7l7V/r7vlTuu0Ja9ISsOxlse2LOTYTvi+mSuCGHUvb5qyuQRsMa4LbUXV2F02g6xw/mz+EswDLoyXgrPv3GzAGwWopY+5yjuOejs63W04ZJy3m8d9sopaAiuum620KSwhYPo7a2RljGtIoguZtPbbHQuVF7/wBs1yie580mxW0W+6o6nPH7xnlOuh/4ih9DZXy+s+EOIAOoIPo9MOB723kR87KmStL1eFQaX4VQ8Osq/FcPJcRJelVSy/RhOgVwSVwIPvbDt5indj++NaOmqWc4cX2VEQJrtFOiXLYBK4tOYNSlOU+lyceTzmjGg/MIENUsNPTbKq+7hYjyX49+U+B5hvRARsw5qP9Y9vgVhOFj2OxUQsn5XbCdfyciq14MiArDc7HiSPO4L3+gXt5V4pkVeQ6hHIGaAEBg3qabkDDtpxgjARWausmQMdIwNrQ6u1v4D1/CsYaHON/u3Qpo0YZW162BmhBfNAQlUcfB3PJDcRJ3fTHX4+RPARiuA/XJTKKG8KzC3WNM5FpvPh9MusOmBecRkCXDIxCteBlxTpBCFdXMJUNcdt2Jy1pUUCRb65R5dcLff/68Ua9qj+gKjNUr8bsO3GWxcFfM1KQQOXBtWUSeFxcV/oGlpMW/AwOampWT3/O6OLq
 P+LpkjdX
 QiwhVfuoci1PhmGXRyRdbCweUCb/y9U4uK6stBk8+OTL0p7I3jefUGP8TRW8U5z8xlOhRQ18xnBtLkgYTn0UFmjLRpVahb3gNa3XwmWPa451qYRmoaxRbpfpowJNgMuMjn9JcHU0iUMlKFKiKfR342x9QrMcXf1jWBriYf48TUprTPMdqpfPrPzU99pHfFngU3hETSYI1PQ8XwyVj4PLawZv7MJiU/WbE1ZItFoCkuenVOJccifd51JaeQ377Ae9TVAgUw4hWubMAY3KZ/etDxorhgg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 23/09/2026 12:04, David Hildenbrand (Arm) wrote:
> Having another look ...
> 
> 
>> +
>> +/*
>> + * Split a present PMD into PTE migration entries, for the rmap migration
>> + * walker.  
> 
> I assume pmd_is_device_private_entry() is also allowed?
> 
> "present or device-private PMDs"
> 

Yes, ack.

> 
>> Like split_huge_pmd_locked(), the caller must hold the PMD lock and
>> + * must already be inside an mmu_notifier invalidate range.
>> + */
>> +void split_pmd_to_migration_entries(struct vm_area_struct *vma,
>> +				    unsigned long address, pmd_t *pmd)
>> +{
>> +	VM_WARN_ON_ONCE(!IS_ALIGNED(address, HPAGE_PMD_SIZE));
>> +	if (pmd_trans_huge(*pmd) || pmd_is_valid_softleaf(*pmd))
> 
> pmd_is_valid_softleaf() would include migration entries and swap entries?
> 
> I'd assume that try_to_migrate_one() will never call us with something that is
> not a present or device-private PMD?
> 
> Shouldn't we instead just
> 
> 
> VM_WARN_ON_ONCE(!pmd_present(*pmd) && !pmd_is_device_private_entry(*pmd));
> __split_huge_pmd_locked(vma, pmd, address, true);
> 
> And not offer some weird fallback where we silently don't split?


Yes, that sounds much better. The function right now is:


/**
 * split_pmd_to_migration_entries() - Split a present or device private PMD into
 * PTE migration entries.
 * @vma: The VMA containing the PMD.
 * @address: The PMD-aligned address the PMD maps.
 * @pmd: A pointer to the leaf PMD entry.
 *
 * For the rmap migration walker, which only ever hands back those two entry
 * types.  Like split_huge_pmd_locked(), the caller must hold the PMD lock and
 * must already be inside an mmu_notifier invalidate range.
 */
void split_pmd_to_migration_entries(struct vm_area_struct *vma,
		unsigned long address, pmd_t *pmd)
{
	VM_WARN_ON_ONCE(!IS_ALIGNED(address, HPAGE_PMD_SIZE));
	VM_WARN_ON_ONCE(!pmd_present(*pmd) &&
			!pmd_is_device_private_entry(*pmd));
	__split_huge_pmd_locked(vma, pmd, address, true);
}

> 
>> +		__split_huge_pmd_locked(vma, pmd, address, true);
>>  }
> 


