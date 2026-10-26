Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 224CF60A2605
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 11:30:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=R6xjyQPW
Received: by kanga.kvack.org (Postfix)
	id 20C386B05B5; Mon, 26 Oct 2026 07:30:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E41D6B05B6; Mon, 26 Oct 2026 07:30:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0FAC76B05B8; Mon, 26 Oct 2026 07:30:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D6D8C6B05B5
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 07:30:08 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6031B406E2
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 11:30:08 +0000 (UTC)
X-FDA: 85364558496.16.3E15C1A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 9BDD2140003
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 11:30:06 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=R6xjyQPW;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793014206;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iClfX9ozOF/woLXVn0LlRbJhaticE1zUNij0OSGeYsI=;
	b=AQLhZnLSo4Ea7/1EAXMTUwHZILGChMeXeNt/l0o+2hxoFar1iBaslGeUydcyN5yeMbEUeu
	jZRUJNi5BoRmjs/A72XzEc1cYDEvdhm9vJRpiIecBi36/noCK8W3sXXEBiZ5Y2RBgOaTrj
	NvrubD6cpQgqPOIErWyWhoPMRbZVRd0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=R6xjyQPW;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793014206;
	b=CEMdp3nWkVK23CuA3ay1W8DBK28m0Xd6tF2Id2/XdCyWNajYQTWgPmHceu9pF+mpjQQqbm
	d3JvVUdZsIoDBbhWTenHkqX5GFOrJZsxiKm29AdOJm4+rmnwopSlPStPskruNJoq5AcvoZ
	CjuGES9sy0aM7cPQifMQyxb6kOBdtGI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 071E3601EF;
	Mon, 26 Oct 2026 11:30:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B78D1F01828;
	Mon, 26 Oct 2026 11:30:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793014205;
	bh=iClfX9ozOF/woLXVn0LlRbJhaticE1zUNij0OSGeYsI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=R6xjyQPWBjiuYXew3w3sfn4+CzEysPk0vzqWiQIv5pJt56ssZjMobDW3D8wF8ogVT
	 1RxFwlq31/AyZhuFaanPLtGT3usurakSt1TmWR2b2uWPnfEFzNVmyLaLABttLcHgGp
	 mFXEbIi4s5hnW8k7Uiy8CaoWdgJNNy84TMHQzQQnF9wDWqY+IV6KUQPGPbZ/jVbR88
	 QYBSJBzA9d+OXYu8pQaJFEFlLRmR0J/deJoxsjji9/iBkkpQPYPBZrvbQt70I1fxH2
	 +ya3dLzgrd25M7uGgv72s/e1cqEyeX1yx2p455bfR1Ng/B5ksE/aG7gUUG/z1AKh25
	 Fmb2plckH6erQ==
Message-ID: <ea4128b9-6c82-4594-b34e-77fbe4404858@kernel.org>
Date: Mon, 26 Oct 2026 12:20:40 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] mm: memory: fix truncation removing mapped folios
To: Baolin Wang <baolin.wang@linux.alibaba.com>, akpm@linux-foundation.org
Cc: ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, qi.zheng@linux.dev, jack@suse.cz,
 pfalcato@suse.de, ayushr@modal.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <4cc521a118564b4145edf0324066ab532fb41181.1792979870.git.baolin.wang@linux.alibaba.com>
 <c3dd24e7-68e4-47f9-a9d2-067c5534a4c4@kernel.org>
 <8779b778-c124-49ff-8072-2c995394ed8e@linux.alibaba.com>
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
In-Reply-To: <8779b778-c124-49ff-8072-2c995394ed8e@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9BDD2140003
X-Stat-Signature: au3w3jy5q6egjdyzxqix47socytbbeur
X-Rspam-User: 
X-Spam-Status: No, score=-17.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793014206-9108
X-HE-Meta: U2FsdGVkX1/kCaE7A4F70DwqdS1Sno3NE3g1knC8HQ6LwKSKiqU2jhtDNCyJUZgjJUFig/UgeRYViRRP2COpWNg6JRU6VCbCvEFBmCg6vke9RPFxCLMEkNm8udhSCYgeD71Z+rOjlZg6ZbNLgMEbmrBNXvzESBt+oyPIFW49ZVoGADgjL+30Oq2x9RfUUOJMbvKUEsja/+A/42+6ZFhZCf/moWZ2nERQ3n5VJR6U38h6pcQ7yXgthx/G4IhUM8dIWt2RVVNvSoAt9jOHUGpZMHtc2IQK8+o9AE8jQ5xq3p1V5Yxxkrl1/lBuUUBzfC6Y3gJKEMjpMAXy0EombqfayqjH+fDRpuRGc14/ZU8pNh4IKVDF8rQ45rsz8thDLT+SR0poQ98+G1rO5L3KjH+HSzSN38CLEa3gq5jbZhX3H+giGw9wFY9UBWhnbQ4MiK6hk+zzALCRflvmh1Ni6fKsSWpMaGU9+oEUEtAZrhDsl3pmSCksJ8WlIcGCuF7DMP3MAhzvDdgveZfvUolumGkbdcFzA3CKKMuGpkYVGHGvw9AGukdxvo8Nqoq6TnHlTr0Or8uVrylvL879G3Ip111RFDudALie2HK+f/Cp/kIXmAZe3aXTkm1bsDWdp9U9ZFbT9Ays+6NMpHG7dfseKu2T9yx+GsiJnUTvbPPf6n3BSoHLIWJ3Bem9llA1jSgdUUxU6AxEy0qajsQNoVnqWYli4oHZ9zpwGIqttnnchCkJ7a5HT1CZGmomRgKQ3qqwfvyxGO4UFWywc7W+C6qG7WYDE48wS6aNEwOGtjpMx6JzGl4mjau41KWfAWiC7mmgzSCux6Y3E9/2cL+XvAdK/+aRwqeuc11ulS3p0Bea/LYPoLYSaca5/qNAPIQEoiXhILCTFqRXF8RqBTS/K2LqDHHi7c1djHdyiJmtKkgw58HPcAF/YUkwGwMIC5Ys+RKCvJKq3op36z6v422XAEAIEDV
 HYHQx4lA
 WYLomXPkCnaDvUZJjPQ29M77Yho/R4OCKu+89W6/JN38bB9uodEnhcycHytuXeITAVo+OPm2TnMI+5NdctPlMBmYqSGfaormPpetTNblNr4n4iASABJjtZ/6+WveIqg5hUIMaI3e/QMT3buOdRXF6zhWkk30JhCZ8oHiGx5/7yAKcGOnxCMqNKs6ZlTPogMmyAtWp9krD+Q1W0lBIxUT5BucC/KnB9tc/k2xyzsNM8mvxwGo41dBGSNzkRlNw3FutR9AlkAP8AsHn7MuCl6THNZYxnim8wCV2yp+zjYmTKTO7OLPFVFrJgcQmfcOngR2GxSFh1XiPGJKZ2ATQmGEx7Cu0X5PlAxV0AxU1167/KoLtPXWmwDLtkEnn1fUfkC3EBTQb86FMNOy7Au8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/26/26 12:02, Baolin Wang wrote:
> 
> 
> On 10/26/26 6:00 PM, David Hildenbrand (Arm) wrote:
>> On 10/26/26 03:05, Baolin Wang wrote:
>>> Ayush reported an issue that shmem/tmpfs folios are still mapped when
>>> truncating them on production:
>>> "
>>> BUG: Bad page cache in process ...  pfn:...
>>> page dumped because: still mapped when deleted
>>> "
>>>
>>> I reproduced the issue with Ayush's reproducer [1] with the latest mm-unstable
>>> branch, and I got the following crash info. From the dump message, we can
>>> see that truncate_inode_folio() is really trying to remove mapped folios,
>>> which is incorrect.
>>>
>>> "
>>> [  189.171977] page: refcount:3 mapcount:1 mapping:00000000fe168ee1
>>> index:0x3880 pfn:0x191647
>>> [  189.171995] memcg:ffff0000cc073d40
>>> [  189.171997] aops:shmem_aops ino:3c01 dentry name(?):"memfd:runsc-memory"
>>> [  189.172006] flags: 0x17fffef0002022d(locked|referenced|uptodate|lru|
>>> workingset|swapbacked|node=0|zone=2|lastcpupid=0x3ffff)
>>> .......
>>> [  189.172017] page dumped because: VM_BUG_ON_FOLIO(folio_mapped(folio))
>>> [  189.172026] ------------[ cut here ]------------
>>> [  189.172027] kernel BUG at mm/filemap.c:155!
>>> [  189.172057] Internal error: Oops - BUG: 00000000f2000800 [#1]  SMP
>>> .......
>>> [  189.177721] CPU: 3 UID: 0 PID: 5521 Comm: repro Kdump: loaded Tainted:
>>> 7.3.0-rc4+ #277 PREEMPT(lazy)
>>> .......
>>> [  189.183986] Call trace:
>>> [  189.184124]  filemap_unaccount_folio+0xf0/0x1e8 (P)
>>> [  189.184391]  __filemap_remove_folio+0x34/0x160
>>> [  189.184633]  filemap_remove_folio+0x4c/0xb0
>>> [  189.184859]  truncate_inode_folio+0x34/0x58
>>> [  189.185087]  shmem_undo_range+0x220/0x658
>>> [  189.185308]  shmem_fallocate+0x2f0/0x470
>>> [  189.185527]  vfs_fallocate+0x128/0x328
>>> ......
>>> [  189.187078]  el0t_64_sync+0x184/0x188
>>> "
>>>
>>> After analysis, I believe the race exists between truncation and MADV_DONTNEED,
>>> and shmem's ->map_pages() merely makes the issue easier to reproduce. Since
>>> MADV_DONTNEED synchronously releases the pagetable page before calling
>>> tlb_flush_rmaps(), this could cause another thread's truncation to skip
>>> zap_pte_range() (due to pmd is none) but still observe the folio's mapcount
>>> as non-zero. A possible race scenario is as follows:
>>>
>>> CPU 0                           CPU 1
>>> shmem_fallocate                 madvise_dontneed_single_vma
>>>    unmap_mapping_range            .......
>>>    ......
>>>    (filemap_map_pages() remap folios)
>>>                   zap_pte_range
>>>    truncate_inode_folio            zap_empty_pte_table(pmd clear)
>>>      unmap_mapping_folio
>>>      ......
>>>        zap_pmd_range (saw pmd none, skip)
>>>
>>>    filemap_remove_folio
>>>      BUG_ON(folio_mapped)
>>>                                      tlb_flush_rmaps(remove rmaps)
>>>
>>> To fix this issue, we should move the pmd clear operation (via
>>> zap_empty_pte_table())
>>> to after tlb_flush_rmaps() and use sync_with_folio_pmd_zap() to sync with
>>> concurrent zapping, so that when we find a pmd_none() while unmapping a folio
>>> without holding the PTL, the folio's mappings are guaranteed to have been
>>> removed via tlb_flush_rmaps().
>>>
>>> [1] https://lore.kernel.org/all/20260925065013.3682431-1-ayushr@modal.com/
>>> Reported-by: Ayush Ranjan <ayushr@modal.com>
>>> Closes: https://lore.kernel.org/all/20260924061708.1645968-1-ayushr@modal.com/
>>> Fixes: 6375e95f381e ("mm: pgtable: reclaim empty PTE page in
>>> madvise(MADV_DONTNEED)")
>>> Acked-by: Qi Zheng <qi.zheng@linux.dev>
>>> Reviewed-by: Pedro Falcato <pfalcato@suse.de>
>>> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
>>> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>>> ---
>>> Changes from v3:
>>>   - Collect review tags from Qi, Pedro and Lorenzo. Thanks.
>>>   - Update the related comments per Lorenzo.
>>> Changes from v2:
>>>   - Use use sync_with_folio_pmd_zap() to sync with concurrent zapping (Per
>>> David).
>>> Changes from v1:
>>>   - Add an smp_rmb() to pair with the smp_wmb() (Per Lorenzo and Pedro).
>>> ---
>>>   mm/internal.h | 10 ++++++----
>>>   mm/memory.c   | 28 +++++++++++++++-------------
>>>   2 files changed, 21 insertions(+), 17 deletions(-)
>>>
>>> diff --git a/mm/internal.h b/mm/internal.h
>>> index b1b0f29d2216..ffb8eaec90e3 100644
>>> --- a/mm/internal.h
>>> +++ b/mm/internal.h
>>> @@ -584,14 +584,16 @@ void free_pgtables(struct mmu_gather *tlb, struct
>>> unmap_desc *desc);
>>>   void pmd_install(struct mm_struct *mm, pmd_t *pmd, pgtable_t *pte);
>>>     /**
>>> - * sync_with_folio_pmd_zap - sync with concurrent zapping of a folio PMD
>>> + * sync_with_folio_pmd_zap - sync with concurrent zapping of folios
>>>    * @mm: The mm_struct.
>>>    * @pmdp: Pointer to the pmd that was found to be pmd_none().
>>>    *
>>>    * When we find a pmd_none() while unmapping a folio without holding the PTL,
>>> - * zap_huge_pmd() may have cleared the PMD but not yet modified the folio to
>>> - * indicate that it's unmapped. Skipping the PMD without synchronization could
>>> - * make folio unmapping code assume that unmapping failed.
>>> + * zap_huge_pmd() may have cleared the PMD but not yet updated the folio
>>> + * mapcount, and zap_empty_pte_table() clears the PMD only after the rmaps
>>> + * for the table have been removed, but nothing orders the pmd_none() read
>>> + * against later mapcount reads. Skipping the PMD without synchronization
>>> + * could make folio unmapping code assume that unmapping failed.
>>>    *
>>>    * Wait for concurrent zapping to complete by grabbing the PTL.
>>>    */
>>> diff --git a/mm/memory.c b/mm/memory.c
>>> index e911e63ba1ed..6a93b7fa48b2 100644
>>> --- a/mm/memory.c
>>> +++ b/mm/memory.c
>>> @@ -2036,6 +2036,15 @@ static unsigned long zap_pte_range(struct mmu_gather
>>> *tlb,
>>>           }
>>>       } while (pte += nr, addr += PAGE_SIZE * nr, addr != end);
>>>   +    add_mm_rss_vec(mm, rss);
>>> +    lazy_mmu_mode_disable();
>>> +
>>> +    /* Do the actual TLB flush before dropping ptl */
>>> +    if (force_flush) {
>>> +        tlb_flush_mmu_tlbonly(tlb);
>>> +        tlb_flush_rmaps(tlb, vma);
>>> +    }
>>> +
>>>       /*
>>>        * Fast path: try to hold the pmd lock and unmap the PTE page.
>>>        *
>>> @@ -2043,18 +2052,12 @@ static unsigned long zap_pte_range(struct mmu_gather
>>> *tlb,
>>>        * to hold the pmd lock failed, then we need to recheck all pte entries
>>>        * to ensure they are still none, thereby preventing the pte entries
>>>        * from being repopulated by another thread.
>>> +     *
>>> +     * Clear the PMD after the rmaps for the table have been removed, in case
>>> +     * an incorrect mapcount is observed after unmapping the folio.
>>>        */
>>>       if (can_reclaim_pt && direct_reclaim && addr == end)
>>>           direct_reclaim = zap_empty_pte_table(mm, pmd, ptl, &pmdval);
>>> -
>>> -    add_mm_rss_vec(mm, rss);
>>> -    lazy_mmu_mode_disable();
>>> -
>>> -    /* Do the actual TLB flush before dropping ptl */
>>> -    if (force_flush) {
>>> -        tlb_flush_mmu_tlbonly(tlb);
>>> -        tlb_flush_rmaps(tlb, vma);
>>> -    }
>>>       pte_unmap_unlock(start_pte, ptl);
>>>         /*
>>> @@ -2102,12 +2105,11 @@ static inline unsigned long zap_pmd_range(struct
>>> mmu_gather *tlb,
>>>                   continue;
>>>               }
>>>               /* fall through */
>>> -        } else if (details && details->single_folio &&
>>> -               folio_test_pmd_mappable(details->single_folio) &&
>>> -               next - addr == HPAGE_PMD_SIZE && pmd_none(*pmd)) {
>>> -            sync_with_folio_pmd_zap(tlb->mm, pmd);
>>>           }
>>> +
>>>           if (pmd_none(*pmd)) {
>>> +            if (details && details->single_folio)
>>> +                sync_with_folio_pmd_zap(tlb->mm, pmd);
>>>               addr = next;
>>>               continue;
>>>          
>> Sorry if I sound annoyed, but why don't you keep the
>>
>> } else if (pmd_none(*pmd)) {
>>
>> above as I suggested?
>>
>> Because we fancy unnecessary PMD table lock cycles?
> 
> Ah, sorry, I misunderstood what you meant before [1]. Yes, this is still correct
> and looks good to me.
> 
> [1] https://lore.kernel.org/all/179c26ed-1764-4e5b-
> a7ee-047ddabbfea1@linux.alibaba.com/
> 
> Do you want me to respin a new version or just apply the following diff?
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index 6a93b7fa48b2..d9c54549b85b 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -2105,9 +2105,7 @@ static inline unsigned long zap_pmd_range(struct
> mmu_gather *tlb,
>                                 continue;
>                         }
>                         /* fall through */
> -               }
> -
> -               if (pmd_none(*pmd)) {
> +               } else if (pmd_none(*pmd)) {
>                         if (details && details->single_folio)
>                                 sync_with_folio_pmd_zap(tlb->mm, pmd);
>                         addr = next;

That's not the correct fixup I think.

Please send a new version with the correct one ;)

-- 
Cheers,

David

