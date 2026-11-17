Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E66D1606A32F
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 09:08:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UpgXaNR5
Received: by kanga.kvack.org (Postfix)
	id 18C5D6B00EF; Tue, 17 Nov 2026 04:08:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 163DA6B05B0; Tue, 17 Nov 2026 04:08:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0799B6B05B1; Tue, 17 Nov 2026 04:08:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D769A6B00EF
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 04:08:23 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6BDB6803B5
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 09:08:23 +0000 (UTC)
X-FDA: 85444034886.06.BC6E5C8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 9EDCD20004
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 09:08:21 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UpgXaNR5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794906501;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DKa7Qj9UXI35IZM1aRSbpTHNKHEyy/5XO6y8cuSvrWQ=;
	b=TO5quwDg+fcR5AAfn/eIguW60qpIaUmRSZqdjdJYHnwWFx3CMn6J2me3sWu11I7Mr96rtI
	gOU3ELaMV8Um4/CmoIDXnMKcuAaao5Mzcm/bfUI6Csa81XS3+7R9Npxo5/X1VvmmQYU0Y4
	IcByrLvIx4YqMllG1qJGdj9DFtJhgLA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UpgXaNR5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794906501;
	b=t2e1CbDIaLp7M11Q+4BVURulPQkT9QEgAOKiOnpgHgEORySAOphdLA2l/uL7Ej+gLSa2IV
	r/7OrRKwkqxSK6HhUzNo5qAB3ASarBMPD5HUmbRo0RSTWgivg5VXCs1usBb3YX6j29Ksde
	7InEAMV5cSNAsN1GdEB63gNd64UsQeA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 10A9E4370C;
	Tue, 17 Nov 2026 09:08:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64AAC1F000C8;
	Tue, 17 Nov 2026 09:08:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794906499;
	bh=DKa7Qj9UXI35IZM1aRSbpTHNKHEyy/5XO6y8cuSvrWQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=UpgXaNR5DTBuS3TrgJddBYnul2zvtcSTxVz2O7WqwK8N/NaZNBgcALFIa59Oh74vc
	 /UmoeR7UKdI7oIPhm5fQr4Q+q+WdmZF85n8ln9maPP1rvx6Dg2yYU0aEJuOFAVXt6o
	 bv/b/I1ffP2JnsNtl+Wn9kWfDEfAJ9dayZBlQcYqs/S6mFymA9KRiLC5eo//3jEbyR
	 oQr4Ttn40o6/Lq8SdXt8KOe4misshJlT4YQeafzrG69V1xEav6EJKDN8oRuq43CaaG
	 gN6wjJa01ljyre7M9HzzlQ/iqr/lwLMlULPVY4V29/wVzbwrmZunRBVcriFYOnVmNf
	 uN3NcE5+13ELQ==
Message-ID: <4649c13d-eeda-4580-8c78-67e6d3392a09@kernel.org>
Date: Tue, 17 Nov 2026 10:08:13 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm: synchronize with PTE table reclaim for all folio
 sizes
To: Andrew Morton <akpm@linux-foundation.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: ljs@kernel.org, riel@surriel.com, liam@infradead.org, vbabka@kernel.org,
 harry@kernel.org, jannh@google.com, lance.yang@linux.dev,
 qi.zheng@linux.dev, baohua@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <71980310d9bf1bf9733ea0e4b772635e1b2bc5c5.1794886401.git.baolin.wang@linux.alibaba.com>
 <20261116202726.b6690f9038557df945f8b007@linux-foundation.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261116202726.b6690f9038557df945f8b007@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 9EDCD20004
X-Stat-Signature: goowmkwr6ahwsfmreetada51knqp8mfa
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1794906501-281081
X-HE-Meta: U2FsdGVkX19nnKY2Cq+dLb6L1peI+GvohXdI5yK11kpAJdJNQK9fIQeXRRXNIDmJucoTVfpYc/ROXnQKQcp1u23dpnVNkxLoOTMAGKLzkMtIazhH6DbTEpVOFcCWc1t8RLpnwtdZ+qH53zrEV4Wd9/eITAMDtL3jJ9eoHvbzSdCNZ4Zhcntst7aRt88ksQzCr7gzVXvLl0pdiuf3i0C/GG5v9GqebQaj5NTAtt6lfj4V34BwIgpPfzjNJpFIOThw2vP9yVuIdT++gM9z8UFD7HWyphHo+KPGfOlwOfkacuKUYnWfuHkQVy4bHlJBCKcGW2gddbP+0EReKpnsg4ZcJ69dcZdYGxy7qwoPm5PoSHyt4oqYgQuYIFrPaltopaDyM2qsRFB8hfhq1GcldC9B6XZpNwxFx5npdvIVDCDM3ImXfTZya5C8ZNUW7aurJ+GSN4+17nDU5obJAPAf3g8o7EEk54CzzI60HWzwB+UYfmGuUkMAG/b6CoygbZaqtLo5/+XKaRP53rp9x60O059elPZ8Ih0flsKdXcXfolAy5OoorcNkLA643ALigneW/rBUoMFRX6BDWzQvMq9T+fU4c1HxbicCKxqXmra0NSQdxocpJkvcpQ2xExdOzZhrAgZNN+oi+DyrZeZOL1YYhptkJ2CsM4zQiwbGmxPF/gudjZVgDtHdT+0LTcjzclqjp0MKjnn5Z69B3PYzKc1+MlIhLe+r/s/DReVseggX064k7n1GhRtytV3cf53Rf7NuVNOmfl465ywzjMRM9VcrEr34MRX4XODhzt80gXIUsKAdLzDBObhnUcR/ZVs2ccz3x9ZHe5xejN/D66kWGKdZ93Kv3GFsJL53bffSiLudDEr5FSJiw9sXdfYnscGqqZB5E5sbDsy5InkOuLFY1LjJ2EAnrm6WEixgv+6iWU0ruPNATxEA6pYdXkL7uu2SoPZalVP73SYNbifBGPq6U028G1p
 HR1JodGF
 ZddFrAB9gRZENWj3SNc6R9cImi1AEOD9psYR9hIg1QgcsREWJ5lnVnQnF0nkCE4MlAcZuNR8dX90MQybYzdLhnRl3BhzgPrQ4s1Vt1WVEaVU05sJ3fUkHJvdKLB5wY6m/Bv3oE2vNd9yeblzxzYZDOSyu6ICMA4HV1DQ7rcDMDK1Ew6Z1hceL3PWbtM4dLgg/BPdFdmBC/ojzM1zZIscZbMINR5i1vettHoltrhUBkoi7C6dpp57AccMxOcSETChTkqaw3PmGmekjW8mazVkXW0kc9DBGCbWxMVwH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/17/26 05:27, Andrew Morton wrote:
> On Tue, 17 Nov 2026 11:40:22 +0800 Baolin Wang <baolin.wang@linux.alibaba.com> wrote:
> 
>> Similar to commit 243cf1f67b36 ("mm: memory: fix truncation removing mapped
>> folios"), the '!pmd_present()' check in page_vma_mapped_walk() can also race
>> with concurrent page table reclamation via zap_empty_pte_table().
>>
>> page_vma_mapped_walk() is used by many functions including try_to_unmap(),
>> try_to_migrate(), folio_mkclean(), pfn_mkclean_range(), remove_migration_ptes(),
>> page_mapped_in_vma(), and mapping_wrprotect_range(). Except for try_to_unmap()
>> and try_to_migrate(), the other callers do not perform post-walk accounting
>> checks, so the race has no observable impact on them.
>>
>> For migration, the race can cause unnecessary retries. For reclaim via
>> try_to_unmap(), the race can cause failure to reclaim a folio that is in
>> fact already unmapped (as shown below), which may cause cold/hot inversion
>> (e.g., in MGLRU) and increase refaults. In extreme cases, failing to
>> reclaim unmapped large folios could even cause OOM in theory.
> 
> Thanks, I've updated mm-hotfixes-unstable to this version.

Please drop it.

I'll take care of it.

It would be good to delay picking stuff that I will pick once ready.

-- 
Cheers,

David

