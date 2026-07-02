Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46AACC43602
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 01:11:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 049C96B0189; Thu,  2 Jul 2026 21:11:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F3D1E6B018B; Thu,  2 Jul 2026 21:11:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E52816B018A; Thu,  2 Jul 2026 21:11:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B26ED6B0188
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 21:11:19 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 89A991C0E00
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 15:45:05 +0000 (UTC)
X-FDA: 84944260170.04.6329A33
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id D3D6620008
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 15:45:03 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jfxx93mI;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783007103;
	b=CbpHkqVobBieTrIVpSGZNAH99VN5H+e1GBkXgjjjtjugmHxyrHR4mAXGuoCwM4cu4rJflY
	WtCQE1rqRstqG8zHou71mRtvb9TpPiRXhUsJ/qH9Bw7bSm3jETnkUVat6nWnILSeudRB8w
	t5SOmczhsLW1aDbhuZT8YdPtCaSB4R4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783007103;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=59qEucnyS37/pT7/a7uWPu4mSZu2iXHdYUdedzUuCWw=;
	b=yw5BmIZKdV+0wHJJkpR2KR8Yh5iKyABM339zNRvYXS9JDOr6sCjy9YOF4/SegTfpqAYQv/
	BlDfP73WxH8H5sBK6mIvQE79dn1K3xDej5pP38+kVYuN3Tyse8SAqb5ZV8tiO0g6HtICZJ
	geQ1weRUS6jdCHPC4qqHYqNL5Oxnc4I=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jfxx93mI;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 422B7601ED;
	Thu,  2 Jul 2026 15:45:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96E0E1F000E9;
	Thu,  2 Jul 2026 15:44:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783007103;
	bh=59qEucnyS37/pT7/a7uWPu4mSZu2iXHdYUdedzUuCWw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=jfxx93mI0WsTjXM2lMZUbF2ST+JdPutWFbARMvB51yaDLU9YGWXmV9QMfDby1IEQy
	 IzZj6IdNYraKUtE9BsLegmT+cQOSrhTMUINWE8Om4Qp48PzK+YM3NsWg1kB6ibut1H
	 MicgLWR8xf4GpI/6j30u/A+EqC38wAWC59qzH0ufvDz/NUVqaxZ8jXkJzBTpT64FYd
	 OQ6h6FSB29/P+QTA5/gxQ5RTVIRuIsBQ5Ap4QoA0vlOkVSnDX+sgH5lEsgEuzfvTuB
	 iLsG+LQWrclkBwcgnIMQuXEhRhqvbpSs4rsDRyYrGY07IixObcgXBv1Kga1H/3uUtL
	 aZUTo5wGNSyWg==
Message-ID: <210eb5d7-2b74-441e-87c6-f51f484cbde3@kernel.org>
Date: Thu, 2 Jul 2026 17:44:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 5/6] mm/page_vma_mapped: use huge_ptep_get() for
 hugetlb
To: Dev Jain <dev.jain@arm.com>, muchun.song@linux.dev, osalvador@suse.de,
 akpm@linux-foundation.org, ljs@kernel.org, liam@infradead.org
Cc: riel@surriel.com, vbabka@kernel.org, harry@kernel.org, jannh@google.com,
 lance.yang@linux.dev, kas@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, rcampbell@nvidia.com, apopple@nvidia.com,
 ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com,
 rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net,
 ying.huang@linux.alibaba.com, j-nomura@ce.jp.nec.com,
 nao.horiguchi@gmail.com, ak@linux.intel.com, mel@csn.ul.ie,
 pfalcato@suse.de, jpoimboe@kernel.org, dave.hansen@intel.com,
 tglx@kernel.org, catalin.marinas@arm.com, will@kernel.org,
 linux-arm-kernel@lists.infradead.org, ryan.roberts@arm.com,
 anshuman.khandual@arm.com, stable@vger.kernel.org
References: <20260702051341.126509-1-dev.jain@arm.com>
 <20260702051341.126509-6-dev.jain@arm.com>
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
In-Reply-To: <20260702051341.126509-6-dev.jain@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D3D6620008
X-Stat-Signature: 8sxmoax4kiqsc5g9cfszjojwtni9sfsn
X-HE-Tag: 1783007103-998249
X-HE-Meta: U2FsdGVkX19l6V4Bn5kK6oZOTTt0dYVzGuivK1KH7cCJkBvAL6YxlS0fTkLoHWnepL4edWo2M9fpp9IFKbswe9HjWWvGz3z1ppRkRB5V183sKf7po4pAPFw6nMSOnPj3fs51Pz10sbsTxlFfaheVqUiMOHJrrDsajDjvzH3NWthOtO3aOuBpCBtF4F4QmqJlXY+k/OLJI6PD4l0M7e0TSOg+DnUhY6AYb04al/sRZMfqZm6iecmo6NN8MKPDFk4e0dndGw8Hj02oWK+0pcSW/HWms9zI+K8YYPLIt/W6td6UjoW0zuG3qcMHqDmMjFLdGkndANpSZbZdoepkwRYEsx/XlYSaYlpRcqTMqjU8LasAxJYvJpG3tGnFczaAmC/eyn86fAOmNJDcAz0g8FU9CeifcdlwTCwD2kpCUtkDJXHCBlBu23nT+/kDhANTC45tIeXOuSDM8RSlpxe+CpM9aHFcgUA8W0YCewPohG95xU4DKqw/Vzff1Q4xU+PNUZSJu55TAqJmBCQ3/Lgb6wPFnP/+fzSPSxz18I6FIhpI3MsHUSTkphJl9IYj0+wKfU+du5jS4/dGJcDAXkMQVWsfz1iPhSeCX95LwLXRF2ZA2AvhnS1ALAgHOLGdXq7eUT0/2/zB/oJNxmZstM4/FAHf0gHGOuSyeOftMiS6VId8rJUIzzADrMFxb2pL+1QReRBkoxaUOqTErDLBgJFsEIQ8/cbcoP+7tSd2D0Rk5s4tgNMgXPj8mSEvLQgtNXZpjPOoYL678QONNlisWOoT/3T2dR7lQB76uQDnVyDPOA0fQNYiVNsOt6b4FN4gps5i/YIjiXuBBrmcJp/6X82Ca3eSnYVh+GwTyCtE2rElYPs52xOAdvGfaWKnnFiiPQSZ2zr8je/csWycKdRxI0gMADxY+V2SUwsKmJssQpsYjyndwteJQUGHsTH4OPNl9gnZMIygrX4saRhKE83ODh/nxr9
 74h9xw+p
 SQ8OYkEyNFfWAVSnjV9zYJua9vzeg6zy8hFkt+B6PYphe+sUpV+OGOjhWmzskUi7ND2R/4w65oM1aZ8s+OqTSpLGJKsecZIxW/AuVo+hPkTH0G9jksxLDxoBidWBSk+kxVh/1Y8rRCJth5lXOE+VQqR6Lnsy4W76tgGirzOUaXbv2HewiwzyBrVU4F50ZRkF+p2YTjv+NPjiDSpxL7VDf0WfO0voSOEpzUTGYKbV9JF4yyNuKhcw+wB7e8hFLjaVqlDuv9ifo66m/S2UmJ9rytCi8asOnqxQ+IVJNQRqHTrwpfmX/oeIhO6+zTcZGD8FeWc6Dkt5Drk4f2g3JwJBIJ+4USJG9OBjCNgHUnakFDbLxCfz9oBBGi1JMm+v/zY9Ca4+eqLSxgDtRjNll4gG4CReBndxBAKpUOzMHM78lGbLpKZ56u4Ix5Ge1AhrqfI69exI4RTIGuXA37J7yEaWESkBw9A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/2/26 07:13, Dev Jain wrote:
> check_pte() is the final validation step in page_vma_mapped_walk().
> It reads pvmw->pte with ptep_get() to decide whether the entry maps
> the PFN range being walked. For hugetlb VMAs, that pointer refers
> to a hugetlb entry.
> 
> On arches which provide their own huge_ptep_get() to dereference a huge
> pte pointer, accessing via ptep_get() would cause pte_pfn(),
> pte_present() etc to misbehave.
> 
> It is not clear whether this has a trivially visible effect to userspace.
> 
> Use huge_ptep_get() to dereference a huge pte pointer.
> 
> Fixes: ace71a19cec5 ("mm: introduce page_vma_mapped_walk()")
> Cc: stable@vger.kernel.org
> Signed-off-by: Dev Jain <dev.jain@arm.com>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

