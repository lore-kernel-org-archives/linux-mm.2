Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7DA5606A337
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 21:19:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IsJAJPnI
Received: by kanga.kvack.org (Postfix)
	id DBA966B05BA; Tue, 17 Nov 2026 16:19:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D924A6B05BB; Tue, 17 Nov 2026 16:19:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA8736B05BC; Tue, 17 Nov 2026 16:19:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A3F406B05BA
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 16:19:24 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 439421604CF
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 21:19:24 +0000 (UTC)
X-FDA: 85445877048.11.CD5F6FB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 89A4E160002
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 21:19:22 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IsJAJPnI;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794950362;
	b=szFqpn0GFKBYpZ7mPOSYHt1rm43fg87L5atjG2SjFTHyMKsJefbTpSlEgFzB5r3LrAssVS
	A1x3d+OhPUBR6K0/OuQUxNuKy+4QKuZvhVlku2KWJA3VtgJRSFIw0/hqCVo+4ZKroEsGlE
	kCgPXLo3HirEs0mnFFY6oL6XCdYXoAg=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IsJAJPnI;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794950362;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2JIz144DjIendGJlmjAvjpQnCBmdwULUaJLtAI0rNec=;
	b=2itbVVVdwLMBXRPFKroKFLdwrME7Oih/XbJ/zlgI1b9XGX1dU7UQY4lTJi60tN+D7L0mHo
	ax9jvPZjZOYNivLyplTi4mmRiGPXiU+G7EV2HCkED3tHzgOPi7IKxJApgPHis80EbevnN9
	JkVFbdpti9+kEqKX6Oyyk7LGs7e2vLY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EA163618C6;
	Tue, 17 Nov 2026 21:19:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87E561F000C4;
	Tue, 17 Nov 2026 21:19:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794950360;
	bh=2JIz144DjIendGJlmjAvjpQnCBmdwULUaJLtAI0rNec=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=IsJAJPnINh0BCJlAWxcYhk+Sm4Cd0CcpuNcVTUOZFHEyOCXCiSo2JvnVMfjWoNnRr
	 fSWR38slwarmoKNFzmYRFTSH2zEPSJDX//bPcCI56b4fxyGp/YSMXTduJJZNl3ycsV
	 7DwAmEJJWkkv7uRuLyZJ0clMEiHPCseNPZP/McRJgblqCC/3jGTHdUubiEqUrIrJiC
	 ey6QIT0Z2a1rboQoU9uUmp+JA8CXcAAhx4resiv82uhsWuzTenqFwarvVLwmxwc4Rr
	 F8qUmy5Vxm3yRgUpk9FaSOut0e9gjRWjWkChx/KeSHS2kRVpfmfcFJ+eAKluWBOV1d
	 USXL1bHKCVp+Q==
Message-ID: <c254a38b-d5e5-40d0-8d70-c6baa850cf2a@kernel.org>
Date: Tue, 17 Nov 2026 22:19:12 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm: use memory barriers for non PMD-sized folios to
 sync
To: Baolin Wang <baolin.wang@linux.alibaba.com>, akpm@linux-foundation.org,
 ljs@kernel.org
Cc: riel@surriel.com, liam@infradead.org, vbabka@kernel.org,
 harry@kernel.org, jannh@google.com, lance.yang@linux.dev, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <6274e62645b9f176dd10d7a79e86b900a39cec5f.1794898535.git.baolin.wang@linux.alibaba.com>
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
In-Reply-To: <6274e62645b9f176dd10d7a79e86b900a39cec5f.1794898535.git.baolin.wang@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 5cy5fswmwpcfgxpibqdh8x6k6tbtkr1t
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 89A4E160002
X-HE-Tag: 1794950362-830169
X-HE-Meta: U2FsdGVkX19IzOQnqPw1MZNGq+InmCioDgKDuykZl6qQ8en1Z5D+gBN5Y7W/2vux2g/zKGORVnk/rbT6qoI9p99D6a/W+bxmw/u8JYzkJr+6VBW7bvlf2z910Cb56YAhcN78Zhz/H18AWmpQsVehM/V8CoPQpoftBMoz9RZGU5SXbFuKl+RShk7zuMoWjldHMMWGaba1Kk1AH4/BNn1ZfHGr4MXkz/mUQxaorTzBBGUGSOceln83bW2KQFwh8V4FEX3JoIv3/q3hootHA0Hq34POM3VJv2J7SWcReHCiUAheSbuR7Mv2/3X9kOqiGOzbaxfbpz6k3zEFIeMMwFHfQtyZRL+MGDjdbiwFbpg0XmjqA6vjMh12t8llanjvAeeoVr/KlGljQDPXn3Ya6PussLVhDpbO2J0fVG5vPl24G5a7uow2QvB8FMBNg4DkW2c0bCswdJZJWWYIZrbqQOV9LORu7V5iKjwhSXlIEzNELASEcFKbFSOMUEdnMsCvnBf966WkH/qETdMVfEiaexnqhY8jX/I51NMq+6TFBT7WVxZFi4JMZXCFuReL+9/WS3DUdCbFYWp1QQn1jNzyzZuM8O/kNfzb6OvsThpV2Wx9nLZI3d84zYMntJR7sZg4PwZuGN7w912cjf1Q1T9VJ95yvJpgPsMT0OUuDxWuA9b9/zkkiYhFA4tk+K+VUHm6PpfD3meSbLmObC5UpCLqKebETIGwuZMHQ3/agO8k+7Wgq4yeJ60SlP32SC3soqMzgRE65STY8Gf7/iIt697pPyUFtwVWhH8IV4V7PZ5tXFjS5rgBjBN66uRYgwgFJM2ZtsO7/I2xlzzQOvGd70mZHh/muLIYfsjkgEKLsdvKzNvAM/eyT8MtpFixtFbycv8cM5ysT/rizsu4Q+ZogRuSCMcup/RfUqoON/CbZv/fN7DW6BmkkXJv06XtopvvcqrSCNN318tNFypyP4NQftuoIEV
 TUxiq8t5
 rsJgScTVgVYutwOJMkGvSNXSbex74Y5IGZ4iXMKTQnmEW7XBiU/ConLaOBuU1m+YNv0Eb3CmeJ/BApIH0OqC9N2WCf9cVrv1yhFO+2r5PQy1/gGMn1hT2jkh03/dip0+yMkOg4s6siBjuv6QCWqjhoRkJlOo1ZdW+vcklblnJukJt4R0ydKNTT8yLHefozWMhrK6nNInG4c9Huo3cDRpEy8KXct4ZvIdFYEayROA+qZqMt3EbWakgbl69OsylBEX2C8+C
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/17/26 08:00, Baolin Wang wrote:
> Commit 243cf1f67b36 ("mm: memory: fix truncation removing mapped folios")
> uses PMD lock via sync_with_folio_pmd_zap() to synchronize when a cleared
> PMD is found while unmapping a folio.
> 
> However, for non PMD-sized folios, the only PMD clear that can race with
> this unmap is PTE table reclaim, which clears the PMD only after the rmaps
> for the table have been removed. This is plain message passing, and taking
> the PMD lock is more than needed, like I did in the previous patch[1].
> 
> Without barriers, the walker can observe the cleared PMD but a stale
> mapcount on weakly ordered architectures:
> 
> CPU 0 (unmap folio)                 CPU 1 (MADV_DONTNEED, full PMD)
> ================================    ================================
> folio_lock()
>                                     lock(ptl)
>                                     clear PTEs
>                                     remove rmaps   /* W mapcount */
> [mapcount load satisfied early,
>  folio still mapped]
>                                     pmd_clear()    /* W pmd */
>                                     unlock(ptl)
> pmdp_get_lockless() -> none         /* R pmd */
> skip the PMD
> folio_mapped() -> true              /* R mapcount, stale */
> unmapping assumed to have failed
> 
> Pairing an smp_wmb() before the PMD clear with an smp_rmb() after the
> PMD read forbids this outcome:
> 
> CPU 0 (unmap folio)                 CPU 1 (MADV_DONTNEED, full PMD)
> ================================    ================================
>                                     remove rmaps   /* W mapcount */
>                                     smp_wmb()
>                                     pmd_clear()    /* W pmd */
> pmdp_get_lockless() -> none         /* R pmd */
> smp_rmb()
> folio_mapped()                      /* R mapcount */
> 
> If R pmd observes W pmd, R mapcount must observe W mapcount, so
> folio_mapped() no longer reports the removed mappings.
> 
> Pass a 'folio' parameter to sync_with_folio_pmd_zap(), allowing us to
> skip those pfn walkers: pfn_mkclean_range and mapping_wrprotect_range,
> which don't need synchronization.
> 
> Similarly, skip sync for page_mapped_in_vma() since the subsequent
> operations don't check the folio's mapcount.

Do we have any way to measure the benefit of this? I think we'll need that to
convince reviewers (like Lorenzo :) )

-- 
Cheers,

David

