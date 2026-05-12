Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17BC5CD4F35
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 11:44:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 324816B0088; Tue, 12 May 2026 07:44:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D5A76B008A; Tue, 12 May 2026 07:44:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C46C6B008C; Tue, 12 May 2026 07:44:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 09F436B0088
	for <linux-mm@kvack.org>; Tue, 12 May 2026 07:44:05 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3629F40447
	for <linux-mm@kvack.org>; Tue, 12 May 2026 11:44:04 +0000 (UTC)
X-FDA: 84758584008.28.6AD5B4F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 4EBE1A0002
	for <linux-mm@kvack.org>; Tue, 12 May 2026 11:44:02 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=m+1IZa7R;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778586242;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nn7VPtIsRtdRIew4Dgh4cBQx6Sy5ky9DqPFrkHvuB2g=;
	b=yw29TXqu2pwYrrMVpqwcgFJxLfVm6/g1BxcLA1XndTj3LkzRTCEyua6lRtv4d7M4fJklGT
	qGEu7HebmdFiSLvfEgAZ/O+MO+rblKnHeOUPeZ4/SzRwP4YrsBWq2D0C/ZoKlAySl5kns/
	DYanViFiDbupZTVBjVaESpr1RqS8GFg=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=m+1IZa7R;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778586242; a=rsa-sha256;
	cv=none;
	b=2GV07j3CjAJzaz7+yFky7j5S61F02EOv0GCKLAuc66afRlRscjQm7BbbsgzZfW7pCv9s2S
	ys8jzIlgfwG5y3mpSdnDXK49Ij8nuqbAKphUpMl/OrBQtdVhEoaGG5Nwj0OtoERBP6F/XV
	NVSfWrcy5+32kJpcE84wK43GBI3yKAw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2271141913;
	Tue, 12 May 2026 11:44:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CBF0C2BCB0;
	Tue, 12 May 2026 11:43:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778586241;
	bh=H+ti7zY/i4rnciLzAJI+9KovwD+hoVGMIVTnLhNKeX8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=m+1IZa7Rz8qrTSMnetT0o7flalUm6rwu31zjfmm1CRbRgqFCWMfUVmNAVBgYfwYYN
	 Oto9ybQ+WxwnaTDUS8PSL3MCKBvNMW9dSqPlqK1ezYX6jCwFdlzHliB46QlG3OhSA4
	 7tNO5yw5uRZVhR3YMiDOy6uu/P5oX3gRGEZdQt2Bdeprx2s+mlExiSR4RY6JNZjyGY
	 ByERcfRQRWYkZ3U15YvVWWYh1sl7STMcJ69dNWsuX1LLzJPVrtZJs2s+zqLwIrz+kd
	 WIsQQ7HQjmh7RzVi6TyUSDyXzPd4JV+c1zuZXuODBrhOBN5NWo/nl1cVfHkhOyqBzf
	 G+TPwEgcAur/g==
Message-ID: <4a9c4170-c6b7-424c-969c-19240f07e46b@kernel.org>
Date: Tue, 12 May 2026 13:43:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 2/5] mm: Add helper to convert HMM pfn to migrate pfn
To: mpenttil@redhat.com, linux-mm@kvack.org
Cc: dri-devel@lists.freedesktop.org, intel-xe@lists.freedesktop.org,
 linux-kernel@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>,
 Leon Romanovsky <leonro@nvidia.com>, Alistair Popple <apopple@nvidia.com>,
 Balbir Singh <balbirs@nvidia.com>, Zi Yan <ziy@nvidia.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
References: <20260505184421.2324798-1-mpenttil@redhat.com>
 <20260505184421.2324798-3-mpenttil@redhat.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 xsFNBFXLn5EBEAC+zYvAFJxCBY9Tr1xZgcESmxVNI/0ffzE/ZQOiHJl6mGkmA1R7/uUpiCjJ
 dBrn+lhhOYjjNefFQou6478faXE6o2AhmebqT4KiQoUQFV4R7y1KMEKoSyy8hQaK1umALTdL
 QZLQMzNE74ap+GDK0wnacPQFpcG1AE9RMq3aeErY5tujekBS32jfC/7AnH7I0v1v1TbbK3Gp
 XNeiN4QroO+5qaSr0ID2sz5jtBLRb15RMre27E1ImpaIv2Jw8NJgW0k/D1RyKCwaTsgRdwuK
 Kx/Y91XuSBdz0uOyU/S8kM1+ag0wvsGlpBVxRR/xw/E8M7TEwuCZQArqqTCmkG6HGcXFT0V9
 PXFNNgV5jXMQRwU0O/ztJIQqsE5LsUomE//bLwzj9IVsaQpKDqW6TAPjcdBDPLHvriq7kGjt
 WhVhdl0qEYB8lkBEU7V2Yb+SYhmhpDrti9Fq1EsmhiHSkxJcGREoMK/63r9WLZYI3+4W2rAc
 UucZa4OT27U5ZISjNg3Ev0rxU5UH2/pT4wJCfxwocmqaRr6UYmrtZmND89X0KigoFD/XSeVv
 jwBRNjPAubK9/k5NoRrYqztM9W6sJqrH8+UWZ1Idd/DdmogJh0gNC0+N42Za9yBRURfIdKSb
 B3JfpUqcWwE7vUaYrHG1nw54pLUoPG6sAA7Mehl3nd4pZUALHwARAQABzS5EYXZpZCBIaWxk
 ZW5icmFuZCAoQ3VycmVudCkgPGRhdmlkQGtlcm5lbC5vcmc+wsGQBBMBCAA6AhsDBQkmWAik
 AgsJBBUKCQgCFgICHgUCF4AWIQQb2cqtc1xMOkYN/MpN3hD3AP+DWgUCaYJt/AIZAQAKCRBN
 3hD3AP+DWriiD/9BLGEKG+N8L2AXhikJg6YmXom9ytRwPqDgpHpVg2xdhopoWdMRXjzOrIKD
 g4LSnFaKneQD0hZhoArEeamG5tyo32xoRsPwkbpIzL0OKSZ8G6mVbFGpjmyDLQCAxteXCLXz
 ZI0VbsuJKelYnKcXWOIndOrNRvE5eoOfTt2XfBnAapxMYY2IsV+qaUXlO63GgfIOg8RBaj7x
 3NxkI3rV0SHhI4GU9K6jCvGghxeS1QX6L/XI9mfAYaIwGy5B68kF26piAVYv/QZDEVIpo3t7
 /fjSpxKT8plJH6rhhR0epy8dWRHk3qT5tk2P85twasdloWtkMZ7FsCJRKWscm1BLpsDn6EQ4
 jeMHECiY9kGKKi8dQpv3FRyo2QApZ49NNDbwcR0ZndK0XFo15iH708H5Qja/8TuXCwnPWAcJ
 DQoNIDFyaxe26Rx3ZwUkRALa3iPcVjE0//TrQ4KnFf+lMBSrS33xDDBfevW9+Dk6IISmDH1R
 HFq2jpkN+FX/PE8eVhV68B2DsAPZ5rUwyCKUXPTJ/irrCCmAAb5Jpv11S7hUSpqtM/6oVESC
 3z/7CzrVtRODzLtNgV4r5EI+wAv/3PgJLlMwgJM90Fb3CB2IgbxhjvmB1WNdvXACVydx55V7
 LPPKodSTF29rlnQAf9HLgCphuuSrrPn5VQDaYZl4N/7zc2wcWM7BTQRVy5+RARAA59fefSDR
 9nMGCb9LbMX+TFAoIQo/wgP5XPyzLYakO+94GrgfZjfhdaxPXMsl2+o8jhp/hlIzG56taNdt
 VZtPp3ih1AgbR8rHgXw1xwOpuAd5lE1qNd54ndHuADO9a9A0vPimIes78Hi1/yy+ZEEvRkHk
 /kDa6F3AtTc1m4rbbOk2fiKzzsE9YXweFjQvl9p+AMw6qd/iC4lUk9g0+FQXNdRs+o4o6Qvy
 iOQJfGQ4UcBuOy1IrkJrd8qq5jet1fcM2j4QvsW8CLDWZS1L7kZ5gT5EycMKxUWb8LuRjxzZ
 3QY1aQH2kkzn6acigU3HLtgFyV1gBNV44ehjgvJpRY2cC8VhanTx0dZ9mj1YKIky5N+C0f21
 zvntBqcxV0+3p8MrxRRcgEtDZNav+xAoT3G0W4SahAaUTWXpsZoOecwtxi74CyneQNPTDjNg
 azHmvpdBVEfj7k3p4dmJp5i0U66Onmf6mMFpArvBRSMOKU9DlAzMi4IvhiNWjKVaIE2Se9BY
 FdKVAJaZq85P2y20ZBd08ILnKcj7XKZkLU5FkoA0udEBvQ0f9QLNyyy3DZMCQWcwRuj1m73D
 sq8DEFBdZ5eEkj1dCyx+t/ga6x2rHyc8Sl86oK1tvAkwBNsfKou3v+jP/l14a7DGBvrmlYjO
 59o3t6inu6H7pt7OL6u6BQj7DoMAEQEAAcLBfAQYAQgAJgIbDBYhBBvZyq1zXEw6Rg38yk3e
 EPcA/4NaBQJonNqrBQkmWAihAAoJEE3eEPcA/4NaKtMQALAJ8PzprBEXbXcEXwDKQu+P/vts
 IfUb1UNMfMV76BicGa5NCZnJNQASDP/+bFg6O3gx5NbhHHPeaWz/VxlOmYHokHodOvtL0WCC
 8A5PEP8tOk6029Z+J+xUcMrJClNVFpzVvOpb1lCbhjwAV465Hy+NUSbbUiRxdzNQtLtgZzOV
 Zw7jxUCs4UUZLQTCuBpFgb15bBxYZ/BL9MbzxPxvfUQIPbnzQMcqtpUs21CMK2PdfCh5c4gS
 sDci6D5/ZIBw94UQWmGpM/O1ilGXde2ZzzGYl64glmccD8e87OnEgKnH3FbnJnT4iJchtSvx
 yJNi1+t0+qDti4m88+/9IuPqCKb6Stl+s2dnLtJNrjXBGJtsQG/sRpqsJz5x1/2nPJSRMsx9
 5YfqbdrJSOFXDzZ8/r82HgQEtUvlSXNaXCa95ez0UkOG7+bDm2b3s0XahBQeLVCH0mw3RAQg
 r7xDAYKIrAwfHHmMTnBQDPJwVqxJjVNr7yBic4yfzVWGCGNE4DnOW0vcIeoyhy9vnIa3w1uZ
 3iyY2Nsd7JxfKu1PRhCGwXzRw5TlfEsoRI7V9A8isUCoqE2Dzh3FvYHVeX4Us+bRL/oqareJ
 CIFqgYMyvHj7Q06kTKmauOe4Nf0l0qEkIuIzfoLJ3qr5UyXc2hLtWyT9Ir+lYlX9efqh7mOY
 qIws/H2t
In-Reply-To: <20260505184421.2324798-3-mpenttil@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: edtgg5fincz33ctx55t867qcwfhunm9b
X-Rspamd-Queue-Id: 4EBE1A0002
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778586242-300755
X-HE-Meta: U2FsdGVkX184iv+JfHYWXWS0SMTATq9VAzTNuq7yIb+jsW34V73Jq0vr+puiYJ+TOxjjnguwXO29iQ4H/OhE1oTGc+NizLgTyb7uofgyWiqkD2xe+HtdRyAMYE8K4Qy1ysfY/3lFg1qW8uh5mAmHQqrRqgliQLuFnqaTz7TvdBGNxEaFRtL/+i+ujSJRIi0qdFeybVs0ShFKsh8qT7DLg3kKkdG+5By3+2AJ3T0FuK+8eYD0p/1vDIl5y+tv6JfaWUl7OeVXw+q4ViMT6AD26AqGwdhBz+6O5EUb4T6N1LDUpI7JwbS+jbIGiNePAP5im2s2f1TJXeYxTR/7mCCe4OW0RzFu/EpazGKM3xkNpq7w6pRZuNLOAPJXMhaCm7+YRTits3O4o2P4B5gybgxXU3GtKM+DxgKHFS3TfLPI1Iz98YvsLZg0O/5f3GOGj0Bkv4pF0wf0SqSZbqvAyaD1L43bhZTesgNmqUUerl/m+ll3MC6xWAxaHHZdKVkWGHpaLEpmvM74x+nvCpuSFq4xLRFjuz9hX2bjGB+RiV+/287F1QC8fMwYtBUyfrNIJOAYpOCNN4eEVsLRHV6JL/jOgQU0gQF7aAvqtTRlIaBQKT4Ug3vCPxK4u8KSbDwyx895C9um2xIo3ZNeGKgJVPCB6pu+F91jKvSK7a+sBz4yy3/Sr0+qc5psJwZZkzPVVh4LpCEY+d4bU1eoEE5lSpg7O+2NEoiyStvgt60t7741+CZxJL5EK8CjjM3I8d8sGH9MAfy3aBc1H1QUB8ts0IzMnIHYISAAgkmCf1Jf8QRVrJ35xdY0+N9fZdYwmNi6kJ1vLOi86CxMg52hHPKLN/HfZNda7DJBKIibrw+TaTTL2WArmw2nplOVEidCUQ+JuQPRSg/wLwdWs/GDW69OEDAikdZ8M3RjFX9Lcvn7GYKVUqnUSBmtdXl++yHM/5YNniEGP/NlxIz3pKQlGtnUXhW
 e3TVgIlF
 fuZbGz8BxRREu/ZY8voobUHL2rzfG1baB1KWoT545dp2vb4gmkOcoRnUvFCf+CrgGXaKeZYqtSYiij/fRyXTkOSympEE2tjDoltiBzxmPMO4rXRuH09DT/qcfi4maJxQDBrBn+asRKcXw0CiWhcgG5f9g8fUx8vXIBKKPvd5yvG+X5So/hBDAghBihEuE78PLXRKX/vurdGVCe67d+0d/p5gcVQkuLa1ozn7vb9+dNktI0tIFlL59B2sn6iVPgvGaCCCW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


> +
> +/**
> + * migrate_hmm_range_setup() - prepare to migrate a range of memory
> + * @range: contains pointer to struct migrate_vma to be set up.
> + *
> + * When collecting has been done with hmm_range_fault(), this
> + * should be called next, and completes range->migrate by
> + * populating migrate->src[] and migrate->dst[]
> + * using range->hmm_pfns[].
> + * Also, migrate->cpages and migrate->npages get initialized.
> + * After migrate_hmm_range_setup(), range->migrate is good
> + * for the rest of the migrate_vma_* flow.
> + */
> +void migrate_hmm_range_setup(struct hmm_range *range)
> +{
> +	struct migrate_vma *migrate = range->migrate;
> +
> +	if (!migrate)
> +		return;
> +
> +	migrate->npages = (migrate->end - migrate->start) >> PAGE_SHIFT;
> +	migrate->cpages = 0;
> +
> +	for (unsigned long i = 0; i < migrate->npages; i++) {
> +		unsigned long pfn = range->hmm_pfns[i];
> +
> +		/*
> +		 * We are only interested in entries to be
> +		 * migrated.
> +		 */
> +		if (!(pfn & HMM_PFN_MIGRATE)) {
> +			migrate->src[i] = 0;
> +			migrate->dst[i] = 0;
> +			continue;
> +		}
> +
> +		migrate->cpages++;
> +
> +		/* HMM_PFN_MIGRATE without HMM_PFN_VALID denotes the special zero page */
> +		if (pfn & (HMM_PFN_VALID))

No need for ()

> +			migrate->src[i] = migrate_pfn(page_to_pfn(hmm_pfn_to_page(pfn)))

Is there no easier way to avoid going through a page?

I guess you really just want "migrate_pfn(pfn & ~HMM_PFN_FLAGS)".

Maybe add a hmm_pfn_to_pfn() helper that does the "pfn & ~HMM_PFN_FLAGS" ?

> +				| MIGRATE_PFN_MIGRATE;

We (MM folks) usually put the | onto the previous line to then properly indent
the second line

migrate->src[i] = migrate_pfn(page_to_pfn(hmm_pfn_to_page(pfn))) |
		  MIGRATE_PFN_MIGRATE;

> +		else
> +			migrate->src[i] = MIGRATE_PFN_MIGRATE;

It might be cleaner to just set migrate->src[i] = 0; here and to unconditionally

	migrate->src[i] |= MIGRATE_PFN_MIGRATE;

So you don't have the MIGRATE_PFN_MIGRATE on two paths.

> +
> +		migrate->src[i] |= (pfn & HMM_PFN_WRITE) ? MIGRATE_PFN_WRITE : 0;
> +		migrate->src[i] |= (pfn & HMM_PFN_COMPOUND) ? MIGRATE_PFN_COMPOUND : 0;
> +		migrate->dst[i] = 0;
> +	}
> +
> +	if (migrate->cpages)
> +		migrate_vma_unmap(migrate);

Can you remind me why we do this here, in the setup() phase? The function doc
does not really describe that.

-- 
Cheers,

David

