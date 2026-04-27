Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19BB8FF8861
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 08:09:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 574046B008A; Mon, 27 Apr 2026 04:09:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 524AA6B008C; Mon, 27 Apr 2026 04:09:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4139F6B0092; Mon, 27 Apr 2026 04:09:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 264AB6B008A
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 04:09:34 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id ABEB0C2771
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 08:09:33 +0000 (UTC)
X-FDA: 84703611426.04.A886291
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id E824112000B
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 08:09:31 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XkpUerlV;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777277372;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Kmoy73u0uStLgoruINHH/bU1eL69EwePf0rdpoDB7w8=;
	b=dl7HJeqJuVRIXxp437duYW/vCgDiUeX1b4NTVN/OMJ2VWq7twEs4iiVsw9oHA+46WG3cS2
	u5XzzQXJGUOiTvxegXj95E4X4rJ+SHMaz8+iSs44pvX4IKp7VWNkOfuCbIhUgMHA0v5vYs
	ihaELOVzSoDR0s1h48pEEPPpuwIQrp8=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XkpUerlV;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777277372; a=rsa-sha256;
	cv=none;
	b=dj2ov8z2yIYwO5c31Glx3+h/muzKzdOmEVQTX70cqtG24jMH3x5AWr4/tRKnTBedgL7uB4
	NVPtF2vdgmEdCGEOg7d1Y7wgLNfsm+/RskL+Rrpf0KmGYaalVcetj7Qb622A3qr6Hzlrj1
	tyvjRHtGQhX5vuNK8p702SLzH7W3Uao=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2109660138;
	Mon, 27 Apr 2026 08:09:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63CF0C19425;
	Mon, 27 Apr 2026 08:09:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777277370;
	bh=kRukMC/nBn5kPtlcUcvyAVLhX7CPVEop6ghweOP3duk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=XkpUerlV4eRM6Jk87wXmtf8Hki6R+35kDxOyOYnpPZmylUx6Ah4qphEeISe+4DeAf
	 udXyPDjagy3m4OLxsYcsLPT6OgPwU4oKhSdcSlClRUoqFCsO0YzRSUyKUcfvPCjblq
	 x90ZppEXTd9LQVEiQjEQFTXI++364P2t3WgD8KC+zZbES6mjN5pklAd4+jAhdZu4lH
	 S8BHfenwE1w3JgSSsVoKFno+7qH8Df7NVoKFOL4HA+cSUF3h2IZwKkE+QJ2Tr88Lkl
	 G3BNnMiMiy2pWa9hae+aCnKVvHR2zFbMl+aR5ZxILdWcHRmne9T48Kmo8g2Zqy/SrM
	 4WSSQpYLKGixA==
Message-ID: <4a339042-0b63-46a0-8400-e3854cc979e8@kernel.org>
Date: Mon, 27 Apr 2026 10:09:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [BUG] KASAN: user-memory-access in free_pgtables
To: Huang Forrest <Forrest021@outlook.com>,
 "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>,
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>
References: <BL0PR03MB4212D07B8FFF03DF6EA45F9E84282@BL0PR03MB4212.namprd03.prod.outlook.com>
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
In-Reply-To: <BL0PR03MB4212D07B8FFF03DF6EA45F9E84282@BL0PR03MB4212.namprd03.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E824112000B
X-Stat-Signature: e4dny66byhapcja54hfngxa3hrpsxrwh
X-HE-Tag: 1777277371-79899
X-HE-Meta: U2FsdGVkX18O+Ww5Vla83VsiFE6U6cer+nCKfB3cQ3JJlNIy5LnyBLZ7mcgBAAfxDvy7EUXk0SRQTwrSiPquJ1lnK3Jb9SGH/o61DAnkvMbirKpDVhMWA6N1QBX6yfglGUai2UH337NmiwbbgvcIe4Q2lDb7gaLOaZYS/wZRzzYRDmSy7QiNrL5asDpVT1xAeB+tHq+gBucbJB92nY9COfRIcQYXL5pCmxSzln21bdKged3JqOZuLzN0CCun6LrCIqglDzBNb8Ti/0QldUQuM+R/ODW4ZSHSR2JByXqPEI1cEoZyXH2O73UvtQVKrj1RwMD3vQTRKpehwPjErYXY/JbDwq7LNRAYKRxsbcLDOClTUGtvs4oEV+Pl4FRf4r7HGB5r5n8bqZcWUzJ9OBRb1meozjBg3hnyd/AN7ax8J9wmfrUcY3yrceg+1LFHxnLFRZXoYEmRn9Z1AohSVh8+q9SMWJ1n0PF0cueEwoownBL++LII+CXdRT4kgIxYP5Pic7quBdj41bKP3bUS8RsUhxgxVX5QaVURneH/3Jx/KJdyGnN8J0UjZB2MBOsSYX9VySZmWo8APck7LAufBdEYcUMmAsYChuTKF1mXg4Vmc7Q9Oayp8euRwNQ+6mAg4So5TGxx2j9WN1TdciTmg4Fqlgsybzijr8ZRpTep2HMUHGAo5/jhcITTstcqURuPFcXEYuB1FQaFdUZYJr5cqMhhWPw3d4lyej9Y0Gu4aAmixuR6LT1TXdwSKqDo3P03J3BxrELti567k3ASJxbwn/cxkRVX9G6UBmyT8sTNK1djfRzaaqnF1ubj5FmH5IFQvuHGXN+oznKo3KsFAejy2ntCX75khEgtfpLhrWDD8Tl+N6OjhUmPiuEeToRgW2zGBAOjjYPjISr7UMeUzP54YFy7iBQtF0Pwh1NGV0wMOlMd3WbB9cHNgPhF2Eec1lVvIXjhvIMbWnA+/B0kNOX8MQ1
 GN+1Uoq6
 XY0MYXoT/uL9eHDTAuKCGDfV2pVX9/gWsWJvo2ekrhOnwMofS7RlUMppidhD1/ldpenoIOHad0nvlibEAxW8VqLdUlusRw6wqARE0gjs8Fujr1yTDNZTjq62w2SaL7Nydsv3nWaAoJNuKJOFrCu0MY6RnWO8Vg1xExz+rEBqGWZSHy8a6OCzuNV4fsTf2xh+nkiR8jKv2nVpSrmGEC0UZnR5OcB1f+8XuUcPdr7evgGQ8eFW5+n+Q27DQ5BzqtzpJkP7NFilhUSxMfKLG+TjGKJKRjBrAEQ0Dk4UPF2NcdBEPJ5obCVz0NzbznQr17AngsthnKL1UH/NsEd7YoW58JW4vApeGPAgjgZEC5zzxCdpqO7iiBK3POCC9luo7DFMKruwbp70/VPQwRhvogXRsbfslh+maqaBIWfDO3Z9iQruYGg8dhBdGKhBhwUXXWLfQwCy/fA4W8C1EeC4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/25/26 11:50, Huang Forrest wrote:
> Hello,

CCing swap folks. Did any of the bigger swap reworks go into v7.0 that could
cause this?

It could also just be a corrupted PTE I guess.

> 
> I found the following issue with syzkaller on:
> 
> HEAD commit:    7aaa8047eafd (HEAD -> master, tag: v7.0-rc6, origin/master, origin/HEAD) Linux 7.0-rc6.
> git tree:  https://github.com/torvalds/linux.git master
> console output: N/A (local fuzzing run did not capture full serial console; only report0/log0 saved)
> kernel config:  https://gist.githubusercontent.com/Forest-kernel/354e7c56522ab60f29c8b96e7429e2e3/raw/97bb1e7d6f9406da5bd07e999c3634f250a5db0c/config.txt
> dashboard link: N/A for local dashboard
> compiler: gcc (Ubuntu 12.3.0-1ubuntu1~22.04) 12.3.0
> userspace arch: x86_64
> 
> 
> I don't have any reproducer for this issue yet.
> 
> Suspected root cause:
> The first report message is "get_swap_device: Bad swap file entry", immediately followed by a WARN in swap_put_entries_direct() (mm/swapfile.c:1909).
> 
> I suspect that the root cause falls in these two possibilities:
> 1. The bad swap entry may itself be just a symptom: a prior unnoticed memory corruption like a UAF could have corrupted a swap entry/PTE/VMA field, which then surfaces as the WARNING occurs.
> 2. Alternatively, the swap entry issue itself might be the real trigger: a logic bug could let an invalid entry reach swap accounting , corrupting swap metadata and then leading to more serious secondary faults like user-memory-access.
> 
> The following full report also in https://gist.github.com/Forest-kernel/725ce788c4374d8e4945e5a13c67362e
> 
> ==================================================================
> get_swap_device: Bad swap file entry 80162affc3fffff
> BUG: KASAN: user-memory-access in instrument_atomic_read include/linux/instrumented.h:82 [inline]
> BUG: KASAN: user-memory-access in atomic_long_read include/linux/atomic/atomic-instrumented.h:3188 [inline]
> BUG: KASAN: user-memory-access in rwsem_assert_held_write_nolockdep include/linux/rwsem.h:87 [inline]
> BUG: KASAN: user-memory-access in rwsem_assert_held_write include/linux/rwsem.h:223 [inline]
> BUG: KASAN: user-memory-access in mmap_assert_write_locked include/linux/mmap_lock.h:76 [inline]
> BUG: KASAN: user-memory-access in __vma_raw_mm_seqnum include/linux/mmap_lock.h:272 [inline]
> BUG: KASAN: user-memory-access in __is_vma_write_locked include/linux/mmap_lock.h:288 [inline]
> BUG: KASAN: user-memory-access in vma_start_write include/linux/mmap_lock.h:300 [inline]
> BUG: KASAN: user-memory-access in free_pgtables+0x53e/0xcd0 mm/memory.c:413
> Oops: general protection fault, probably for non-canonical address 0xdffffc000000000b: 0000 [#1] SMP KASAN NOPTI
> KASAN: null-ptr-deref in range [0x0000000000000058-0x000000000000005f]
> CPU: 0 UID: 0 PID: 5123 Comm: syz-executor Not tainted 7.0.0-rc6 #1 PREEMPT(lazy)
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/2014
> RIP: 0010:pick_next_entity kernel/sched/fair.c:5547 [inline]
> RIP: 0010:pick_task_fair+0x89/0x1e0 kernel/sched/fair.c:8966
> Code: c0 0f 84 0c 01 00 00 4d 89 ee eb 6b 4c 89 f7 be 01 00 00 00 e8 c8 14 fe ff 48 8d 78 59 48 89 fa 48 89 f9 48 c1 ea 03 83 e1 07 <42> 0f b6 14 3a 38 ca 7f 08 84 d2 0f 85 ed 00 00 00 80 78 59 00 0f
> RSP: 0018:ffff888110adf330 EFLAGS: 00010002
> RAX: 0000000000000000 RBX: ffff88811b035800 RCX: 0000000000000001
> ------------[ cut here ]------------
> WARNING: mm/swapfile.c:1909 at swap_put_entries_direct+0x1be/0x2c0 mm/swapfile.c:1909, CPU#2: syz-executor/3650
> Modules linked in:
> CPU: 2 UID: 0 PID: 3650 Comm: syz-executor Not tainted 7.0.0-rc6 #1 PREEMPT(lazy)
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/2014
> RIP: 0010:swap_put_entries_direct+0x1be/0x2c0 mm/swapfile.c:1909
> Code: 48 8b 44 24 58 65 48 2b 05 c7 e0 9c 05 0f 85 db 00 00 00 48 83 c4 60 5b 5d 41 5c 41 5d 41 5e e9 68 9c ef 02 e8 93 21 cc ff 90 <0f> 0b 90 eb b9 e8 88 21 cc ff 49 8d 6c 24 08 48 b8 00 00 00 00 00
> RSP: 0018:ffff88810bd0f768 EFLAGS: 00010293
> RAX: 0000000000000000 RBX: 000162affc3fffff RCX: ffffffffaae42f5d
> RDX: ffff888113315640 RSI: 0000000000000000 RDI: 0000000000000001
> RBP: 000162affc400000 R08: 0000000000000001 R09: ffffed10217a1e92
> R10: 0000000000000000 R11: 706177735f746567 R12: 0000000000000000
> R13: 1ffff110217a1eed R14: dffffc0000000000 R15: ffff888117002000
> FS:  0000000000000000(0000) GS:ffff88816a88f000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007ffffffff000 CR3: 00000001014b7000 CR4: 0000000000350ef0
> Call Trace:
>  <TASK>
>  zap_nonpresent_ptes mm/memory.c:1764 [inline]
>  do_zap_pte_range mm/memory.c:1831 [inline]
>  zap_pte_range mm/memory.c:1929 [inline]
>  zap_pmd_range mm/memory.c:2021 [inline]
>  zap_pud_range mm/memory.c:2049 [inline]
>  zap_p4d_range mm/memory.c:2070 [inline]
>  unmap_page_range+0x1645/0x3f40 mm/memory.c:2091
>  unmap_single_vma+0x153/0x240 mm/memory.c:2133
>  unmap_vmas+0x248/0x530 mm/memory.c:2171
>  exit_mmap+0x1ee/0x800 mm/mmap.c:1302
>  __mmput kernel/fork.c:1175 [inline]
>  mmput+0x6c/0x320 kernel/fork.c:1198
>  exit_mm kernel/exit.c:581 [inline]
>  do_exit+0x7c1/0x28e0 kernel/exit.c:964
> Read of size 8 at addr 0000000100000190 by task syz.2.164/6127
> 
> CPU: 5 UID: 0 PID: 6127 Comm: syz.2.164 Not tainted 7.0.0-rc6 #1 PREEMPT(lazy)
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/2014
> Call Trace:
>  <TASK>
>  __dump_stack lib/dump_stack.c:94 [inline]
>  dump_stack_lvl+0xab/0xe0 lib/dump_stack.c:120
>  kasan_report+0xce/0x100 mm/kasan/report.c:595
>  check_region_inline mm/kasan/generic.c:194 [inline]
>  kasan_check_range+0x100/0x1b0 mm/kasan/generic.c:200
>  instrument_atomic_read include/linux/instrumented.h:82 [inline]
>  atomic_long_read include/linux/atomic/atomic-instrumented.h:3188 [inline]
>  rwsem_assert_held_write_nolockdep include/linux/rwsem.h:87 [inline]
>  rwsem_assert_held_write include/linux/rwsem.h:223 [inline]
>  mmap_assert_write_locked include/linux/mmap_lock.h:76 [inline]
>  __vma_raw_mm_seqnum include/linux/mmap_lock.h:272 [inline]
>  __is_vma_write_locked include/linux/mmap_lock.h:288 [inline]
>  vma_start_write include/linux/mmap_lock.h:300 [inline]
>  free_pgtables+0x53e/0xcd0 mm/memory.c:413
>  exit_mmap+0x362/0x800 mm/mmap.c:1314
>  __mmput kernel/fork.c:1175 [inline]
>  mmput+0x6c/0x320 kernel/fork.c:1198
>  exit_mm kernel/exit.c:581 [inline]
>  do_exit+0x7c1/0x28e0 kernel/exit.c:964
>  do_group_exit+0xc7/0x280 kernel/exit.c:1118
>  get_signal+0x20d2/0x2150 kernel/signal.c:3034
>  arch_do_signal_or_restart+0x8f/0x7a0 arch/x86/kernel/signal.c:337
>  __exit_to_user_mode_loop kernel/entry/common.c:64 [inline]
>  exit_to_user_mode_loop+0x6b/0x4c0 kernel/entry/common.c:98
>  __exit_to_user_mode_prepare include/linux/irq-entry-common.h:226 [inline]
>  syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:256 [inline]
>  syscall_exit_to_user_mode include/linux/entry-common.h:325 [inline]
>  do_syscall_64+0x46d/0x580 arch/x86/entry/syscall_64.c:100
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f38134f777d
> Code: Unable to access opcode bytes at 0x7f38134f7753.
> RSP: 002b:00007f3811f36fa8 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
> RAX: fffffffffffffe00 RBX: 00007f3813785fa0 RCX: 00007f38134f777d
> RDX: 000000000000004e RSI: 00002000000000c0 RDI: 000000000000000c
> RBP: 00007f3813594d74 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f3813786038 R14: 00007f3813785fa0 R15: 00007f3811f17000
>  </TASK>
> ==================================================================
> RDX: 000000000000000b RSI: 0000000000000001 RDI: 0000000000000059
> RBP: ffffed1023606b12 R08: 0000000000000001 R09: ffffed102215be92
> R10: 0000000000000000 R11: 0000000000000000 R12: ffff88811b035890
> R13: ffff88811b035880 R14: ffff8881173a4000 R15: dffffc0000000000
> FS:  0000000000000000(0000) GS:ffff88816a80f000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007ffd98c09c10 CR3: 00000000ace72000 CR4: 0000000000350ef0
> Call Trace:
>  <TASK>
>  pick_next_task_fair+0x98/0x1c60 kernel/sched/fair.c:8990
>  __do_sys_exit kernel/exit.c:1085 [inline]
>  __se_sys_exit kernel/exit.c:1083 [inline]
>  __x64_sys_exit+0x42/0x50 kernel/exit.c:1083
>  x64_sys_call+0x154f/0x1760 arch/x86/include/generated/asm/syscalls_64.h:61
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xfc/0x580 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fd94161777d
> Code: Unable to access opcode bytes at 0x7fd941617753.
>  __pick_next_task kernel/sched/core.c:5929 [inline]
>  pick_next_task kernel/sched/core.c:6468 [inline]
>  __schedule+0x7ce/0x3ee0 kernel/sched/core.c:6852
> RSP: 002b:00007fff7d837098 EFLAGS: 00000246
>  ORIG_RAX: 000000000000003c
> RAX: ffffffffffffffda RBX: 000000000000000b RCX: 00007fd94161777d
> RDX: 00007fd94165859a RSI: 00007fff7d8370c0 RDI: 000000000000000b
>  preempt_schedule_irq+0x49/0x80 kernel/sched/core.c:7238
> RBP: 0000000000000000 R08: 00007fd9423e5000 R09: 0000000000007228
>  irqentry_exit+0xc1/0x660 kernel/entry/common.c:239
> R10: 0000000000000053 R11: 0000000000000246 R12: 0000000000000000
>  asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:697
> R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
> RIP: 0010:__rcu_read_unlock+0x88/0xf0 kernel/rcu/tree_plugin.h:435
>  </TASK>
> Code: fc ff df 48 89 fa 48 c1 ea 03 83 eb 01 0f b6 14 02 48 89 f8 83 e0 07 83 c0 03 38 d0 7c 04 84 d2 75 62 41 89 9c 24 3c 04 00 00 <85> db 75 37 48 8d bd 40 04 00 00 48 b8 00 00 00 00 00 fc ff df 48
> ---[ end trace 0000000000000000 ]---
> RSP: 0018:ffff888110adf6e0 EFLAGS: 00000246
> RAX: 0000000000000007 RBX: 0000000000000000 RCX: ffff888110ae0001
> RDX: 0000000000000000 RSI: ffff888110adfdb0 RDI: ffff888100ec26bc
> RBP: ffff888100ec2280 R08: 0000000000000001 R09: ffff888110adf7b0
> R10: ffff888110adf770 R11: 0000000000009963 R12: ffff888100ec2280
> R13: ffff888110adf770 R14: ffff888110adfde0 R15: ffff888110adfdd8
>  rcu_read_unlock include/linux/rcupdate.h:883 [inline]
>  class_rcu_destructor include/linux/rcupdate.h:1193 [inline]
>  unwind_next_frame+0x39d/0x2400 arch/x86/kernel/unwind_orc.c:495
>  arch_stack_walk+0x94/0x100 arch/x86/kernel/stacktrace.c:25
>  stack_trace_save+0x8e/0xc0 kernel/stacktrace.c:122
>  kasan_save_stack+0x33/0x60 mm/kasan/common.c:57
>  kasan_save_track+0x17/0x60 mm/kasan/common.c:78
>  poison_kmalloc_redzone mm/kasan/common.c:398 [inline]
>  __kasan_kmalloc+0x8f/0xa0 mm/kasan/common.c:415
>  kmalloc_noprof include/linux/slab.h:950 [inline]
>  slab_free_hook mm/slub.c:2637 [inline]
>  slab_free mm/slub.c:6165 [inline]
>  kmem_cache_free+0x245/0x3d0 mm/slub.c:6295
>  tear_down_vmas+0x182/0x3a0 mm/mmap.c:1264
>  exit_mmap+0x37f/0x800 mm/mmap.c:1322
>  __mmput kernel/fork.c:1175 [inline]
>  mmput+0x6c/0x320 kernel/fork.c:1198
>  exit_mm kernel/exit.c:581 [inline]
>  do_exit+0x7c1/0x28e0 kernel/exit.c:964
>  do_group_exit+0xc7/0x280 kernel/exit.c:1118
>  __do_sys_exit_group kernel/exit.c:1129 [inline]
>  __se_sys_exit_group kernel/exit.c:1127 [inline]
>  __x64_sys_exit_group+0x3e/0x50 kernel/exit.c:1127
>  x64_sys_call+0x16cd/0x1760 arch/x86/include/generated/asm/syscalls_64.h:232
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xfc/0x580 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fb99736777d
> Code: Unable to access opcode bytes at 0x7fb997367753.
> RSP: 002b:00007ffd98c095f8 EFLAGS: 00000206 ORIG_RAX: 00000000000000e7
> RAX: ffffffffffffffda RBX: 000000000000000b RCX: 00007fb99736777d
> RDX: 00007fb9973a859a RSI: 0000000000000000 RDI: 000000000000000b
> RBP: 00007ffd98c09bfc R08: 0000000000000000 R09: 000000000000000b
> R10: 000000000000000e R11: 0000000000000206 R12: 0000000000000000
> R13: 0000000000007221 R14: 0000000000000000 R15: 00000000000071f9
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> Oops: general protection fault, probably for non-canonical address 0xe1d646401ffff12b: 0000 [#2] SMP KASAN NOPTI
> RIP: 0010:pick_next_entity kernel/sched/fair.c:5547 [inline]
> RIP: 0010:pick_task_fair+0x89/0x1e0 kernel/sched/fair.c:8966
> KASAN: maybe wild-memory-access in range [0x0eb25200ffff8958-0x0eb25200ffff895f]
> Code: c0 0f 84 0c 01 00 00 4d 89 ee eb 6b 4c 89 f7 be 01 00 00 00 e8 c8 14 fe ff 48 8d 78 59 48 89 fa 48 89 f9 48 c1 ea 03 83 e1 07 <42> 0f b6 14 3a 38 ca 7f 08 84 d2 0f 85 ed 00 00 00 80 78 59 00 0f
> CPU: 1 UID: 0 PID: 3489 Comm: syz-executor Tainted: G    B D W           7.0.0-rc6 #1 PREEMPT(lazy)
> RSP: 0018:ffff888110adf330 EFLAGS: 00010002
> Tainted: [B]=BAD_PAGE, [D]=DIE, [W]=WARN
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/2014
> RAX: 0000000000000000 RBX: ffff88811b035800 RCX: 0000000000000001
> RIP: 0010:cpuacct_account_field+0x8c/0x110 kernel/sched/cpuacct.c:357
> RDX: 000000000000000b RSI: 0000000000000001 RDI: 0000000000000059
> Code: fb 00 bb cf ae 74 5b 48 bd 00 00 00 00 00 fc ff df 48 63 f6 4c 8d 24 f5 00 00 00 00 48 8d bb d8 00 00 00 48 89 f8 48 c1 e8 03 <80> 3c 28 00 75 41 48 8b 83 d8 00 00 00 48 8d bb b8 00 00 00 4c 01
> RBP: ffffed1023606b12 R08: 0000000000000001 R09: ffffed102215be92
> RSP: 0018:ffff88811b048c88 EFLAGS: 00010016
> R10: 0000000000000000 R11: 0000000000000000 R12: ffff88811b035890
> 
> R13: ffff88811b035880 R14: ffff8881173a4000 R15: dffffc0000000000
> RAX: 01d64a401ffff12b RBX: 0eb25200ffff8881 RCX: 0000000000010000
> FS:  0000000000000000(0000) GS:ffff88816a80f000(0000) knlGS:0000000000000000
> RDX: 1ffff11022e6cb02 RSI: 0000000000000002 RDI: 0eb25200ffff8959
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> RBP: dffffc0000000000 R08: 0000000000000000 R09: ffffed102360919a
> CR2: 00007ffd98c09c10 CR3: 00000000ace72000 CR4: 0000000000350ef0
> R10: 0000000000015a2a R11: ffff88811b048ff8 R12: 0000000000000010
> note: syz-executor[5123] exited with irqs disabled
> R13: 00000000000f4240 R14: ffff888104356500 R15: 0000000000000000
> FS:  0000000000000000(0000) GS:ffff88816a84f000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007ffffffff000 CR3: 0000000104120000 CR4: 0000000000350ef0
> Call Trace:
>  <IRQ>
>  cgroup_account_cputime_field include/linux/cgroup.h:755 [inline]
>  task_group_account_field kernel/sched/cputime.c:115 [inline]
>  account_system_index_time+0x113/0x1f0 kernel/sched/cputime.c:178
>  update_process_times+0x82/0x1f0 kernel/time/timer.c:2472
>  tick_sched_handle kernel/time/tick-sched.c:298 [inline]
>  tick_nohz_handler+0x5a1/0x710 kernel/time/tick-sched.c:319
>  __run_hrtimer kernel/time/hrtimer.c:1785 [inline]
>  __hrtimer_run_queues+0x411/0x8a0 kernel/time/hrtimer.c:1849
>  hrtimer_interrupt+0x2f4/0x7c0 kernel/time/hrtimer.c:1911
>  local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1045 [inline]
>  __sysvec_apic_timer_interrupt+0x88/0x2d0 arch/x86/kernel/apic/apic.c:1062
>  instr_sysvec_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1056 [inline]
>  sysvec_apic_timer_interrupt+0x67/0x80 arch/x86/kernel/apic/apic.c:1056
>  </IRQ>
>  <TASK>
>  asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:697
> RIP: 0010:get_current arch/x86/include/asm/current.h:25 [inline]
> RIP: 0010:__sanitizer_cov_trace_pc+0x8/0x80 kernel/kcov.c:216
> Code: 00 e9 6c ff ff ff 4d 01 d7 4d 89 39 e9 ef fd ff ff 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e fa 48 8b 0c 24 <65> 48 8b 15 18 bf d0 05 65 8b 05 29 bf d0 05 a9 00 01 ff 00 74 1d
> RSP: 0018:ffff8881031477f0 EFLAGS: 00000216
> RAX: ffff888100c74680 RBX: 0000000000001000 RCX: ffffffffaad67b73
> RDX: ffff88810150d640 RSI: 0000000000000000 RDI: 0000000000000001
> RBP: 0000000000000000 R08: 0000000000000000 R09: fffff94000040026
> R10: 0000000000000000 R11: ffffea00042a5400 R12: ffffea0000200100
> R13: 00007f8f51ecf000 R14: dffffc0000000000 R15: ffffea0000200130
>  zap_pte_range mm/memory.c:1938 [inline]
>  zap_pmd_range mm/memory.c:2021 [inline]
>  zap_pud_range mm/memory.c:2049 [inline]
>  zap_p4d_range mm/memory.c:2070 [inline]
>  unmap_page_range+0xe53/0x3f40 mm/memory.c:2091
>  unmap_single_vma+0x153/0x240 mm/memory.c:2133
>  unmap_vmas+0x248/0x530 mm/memory.c:2171
>  exit_mmap+0x1ee/0x800 mm/mmap.c:1302
>  __mmput kernel/fork.c:1175 [inline]
>  mmput+0x6c/0x320 kernel/fork.c:1198
>  exit_mm kernel/exit.c:581 [inline]
>  do_exit+0x7c1/0x28e0 kernel/exit.c:964
>  __do_sys_exit kernel/exit.c:1085 [inline]
>  __se_sys_exit kernel/exit.c:1083 [inline]
>  __x64_sys_exit+0x42/0x50 kernel/exit.c:1083
>  x64_sys_call+0x154f/0x1760 arch/x86/include/generated/asm/syscalls_64.h:61
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xfc/0x580 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f8f52c8777d
> Code: Unable to access opcode bytes at 0x7f8f52c87753.
> RSP: 002b:00007ffdf12940d8 EFLAGS: 00000246 ORIG_RAX: 000000000000003c
> RAX: ffffffffffffffda RBX: 000000000000000b RCX: 00007f8f52c8777d
> RDX: 00007f8f52cc859a RSI: 00007ffdf1294100 RDI: 000000000000000b
> RBP: 00007ffdf1294740 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000049 R11: 0000000000000246 R12: 0000000000000000
> R13: 0000000000000065 R14: 0000000000000000 R15: 0000000000000001
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> Oops: stack segment: 0000 [#3] SMP KASAN NOPTI
> RIP: 0010:pick_next_entity kernel/sched/fair.c:5547 [inline]
> RIP: 0010:pick_task_fair+0x89/0x1e0 kernel/sched/fair.c:8966
> CPU: 3 UID: 0 PID: 3120 Comm: syz-executor Tainted: G    B D W           7.0.0-rc6 #1 PREEMPT(lazy)
> Code: c0 0f 84 0c 01 00 00 4d 89 ee eb 6b 4c 89 f7 be 01 00 00 00 e8 c8 14 fe ff 48 8d 78 59 48 89 fa 48 89 f9 48 c1 ea 03 83 e1 07 <42> 0f b6 14 3a 38 ca 7f 08 84 d2 0f 85 ed 00 00 00 80 78 59 00 0f
> Tainted: [B]=BAD_PAGE, [D]=DIE, [W]=WARN
> RSP: 0018:ffff888110adf330 EFLAGS: 00010002
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/2014
> 
> RIP: 0010:find_stack lib/stackdepot.c:610 [inline]
> RIP: 0010:stack_depot_save_flags+0x164/0x7f0 lib/stackdepot.c:676
> RAX: 0000000000000000 RBX: ffff88811b035800 RCX: 0000000000000001
> Code: e1 04 48 03 0d 75 8f f0 04 65 ff 05 06 35 e4 04 48 8b 29 48 39 e9 75 12 e9 96 00 00 00 48 8b 6d 00 48 39 e9 0f 84 6c 01 00 00 <39> 5d 10 75 ee 44 3b 7d 14 75 e8 31 c0 48 8b 54 c5 20 49 39 54 c5
> RDX: 000000000000000b RSI: 0000000000000001 RDI: 0000000000000059
> RSP: 0000:ffff888114a279a8 EFLAGS: 00010096
> RBP: ffffed1023606b12 R08: 0000000000000001 R09: ffffed102215be92
> 
> RAX: 00000000b8c9dc9e RBX: 00000000b8c9dc9e RCX: ffff88811a3dc9e0
> R10: 0000000000000000 R11: 0000000000000000 R12: ffff88811b035890
> RDX: ffffffffaa4012a6 RSI: 0000000000000003 RDI: 0000000099bcd7db
> R13: ffff88811b035880 R14: ffff8881173a4000 R15: dffffc0000000000
> RBP: 075200d30000000c R08: ffffffffaf8a3284 R09: ffff888114a27900
> FS:  0000000000000000(0000) GS:ffff88816a84f000(0000) knlGS:0000000000000000
> R10: 00000000b2322418 R11: 000000002c30fd98 R12: 0000000000000001
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> R13: ffff888114a27a00 R14: 000000000000000c R15: 000000000000000c
> CR2: 00007ffffffff000 CR3: 0000000104120000 CR4: 0000000000350ef0
> FS:  000055555b109500(0000) GS:ffff88816a8cf000(0000) knlGS:0000000000000000
> ----------------
> Code disassembly (best guess):
>    0: c0 0f 84                rorb   $0x84,(%rdi)
>    3: 0c 01                   or     $0x1,%al
>    5: 00 00                   add    %al,(%rax)
>    7: 4d 89 ee                mov    %r13,%r14
>    a: eb 6b                   jmp    0x77
>    c: 4c 89 f7                mov    %r14,%rdi
>    f: be 01 00 00 00          mov    $0x1,%esi
>   14: e8 c8 14 fe ff          call   0xfffe14e1
>   19: 48 8d 78 59             lea    0x59(%rax),%rdi
>   1d: 48 89 fa                mov    %rdi,%rdx
>   20: 48 89 f9                mov    %rdi,%rcx
>   23: 48 c1 ea 03             shr    $0x3,%rdx
>   27: 83 e1 07                and    $0x7,%ecx
> * 2a: 42 0f b6 14 3a          movzbl (%rdx,%r15,1),%edx <-- trapping instruction
>   2f: 38 ca                   cmp    %cl,%dl
>   31: 7f 08                   jg     0x3b
>   33: 84 d2                   test   %dl,%dl
>   35: 0f 85 ed 00 00 00       jne    0x128
>   3b: 80 78 59 00             cmpb   $0x0,0x59(%rax)
>   3f: 0f                      .byte 0xf
> 
> 
> Oops: general protection fault, probably for non-canonical address 0xdffffc000000000b: 0000 [#1] SMP KASAN NOPTI
> KASAN: null-ptr-deref in range [0x0000000000000058-0x000000000000005f]
> CPU: 0 UID: 0 PID: 5123 Comm: syz-executor Not tainted 7.0.0-rc6 #1 PREEMPT(lazy)
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/2014
> RIP: 0010:pick_task_fair+0x89/0x1e0
> Code: c0 0f 84 0c 01 00 00 4d 89 ee eb 6b 4c 89 f7 be 01 00 00 00 e8 c8 14 fe ff 48 8d 78 59 48 89 fa 48 89 f9 48 c1 ea 03 83 e1 07 <42> 0f b6 14 3a 38 ca 7f 08 84 d2 0f 85 ed 00 00 00 80 78 59 00 0f
> RSP: 0018:ffff888110adf330 EFLAGS: 00010002
> RAX: 0000000000000000 RBX: ffff88811b035800 RCX: 0000000000000001
> ------------[ cut here ]------------
> WARNING: mm/swapfile.c:1909 at swap_put_entries_direct+0x1be/0x2c0, CPU#2: syz-executor/3650
> Modules linked in:
> CPU: 2 UID: 0 PID: 3650 Comm: syz-executor Not tainted 7.0.0-rc6 #1 PREEMPT(lazy)
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/2014
> RIP: 0010:swap_put_entries_direct+0x1be/0x2c0
> Code: 48 8b 44 24 58 65 48 2b 05 c7 e0 9c 05 0f 85 db 00 00 00 48 83 c4 60 5b 5d 41 5c 41 5d 41 5e e9 68 9c ef 02 e8 93 21 cc ff 90 <0f> 0b 90 eb b9 e8 88 21 cc ff 49 8d 6c 24 08 48 b8 00 00 00 00 00
> RSP: 0018:ffff88810bd0f768 EFLAGS: 00010293
> RAX: 0000000000000000 RBX: 000162affc3fffff RCX: ffffffffaae42f5d
> RDX: ffff888113315640 RSI: 0000000000000000 RDI: 0000000000000001
> RBP: 000162affc400000 R08: 0000000000000001 R09: ffffed10217a1e92
> R10: 0000000000000000 R11: 706177735f746567 R12: 0000000000000000
> R13: 1ffff110217a1eed R14: dffffc0000000000 R15: ffff888117002000
> FS:  0000000000000000(0000) GS:ffff88816a88f000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007ffffffff000 CR3: 00000001014b7000 CR4: 0000000000350ef0
> Call Trace:
>  <TASK>
>  unmap_page_range+0x1645/0x3f40
>  unmap_single_vma+0x153/0x240
>  unmap_vmas+0x248/0x530
>  exit_mmap+0x1ee/0x800
>  mmput+0x6c/0x320
>  do_exit+0x7c1/0x28e0
> Read of size 8 at addr 0000000100000190 by task syz.2.164/6127
> 
> CPU: 5 UID: 0 PID: 6127 Comm: syz.2.164 Not tainted 7.0.0-rc6 #1 PREEMPT(lazy)
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xab/0xe0
>  kasan_report+0xce/0x100
>  kasan_check_range+0x100/0x1b0
>  free_pgtables+0x53e/0xcd0
>  exit_mmap+0x362/0x800
>  mmput+0x6c/0x320
>  do_exit+0x7c1/0x28e0
>  do_group_exit+0xc7/0x280
>  get_signal+0x20d2/0x2150
>  arch_do_signal_or_restart+0x8f/0x7a0
>  exit_to_user_mode_loop+0x6b/0x4c0
>  do_syscall_64+0x46d/0x580
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f38134f777d
> Code: Unable to access opcode bytes at 0x7f38134f7753.
> RSP: 002b:00007f3811f36fa8 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
> RAX: fffffffffffffe00 RBX: 00007f3813785fa0 RCX: 00007f38134f777d
> RDX: 000000000000004e RSI: 00002000000000c0 RDI: 000000000000000c
> RBP: 00007f3813594d74 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f3813786038 R14: 00007f3813785fa0 R15: 00007f3811f17000
>  </TASK>
> ==================================================================
> RDX: 000000000000000b RSI: 0000000000000001 RDI: 0000000000000059
> RBP: ffffed1023606b12 R08: 0000000000000001 R09: ffffed102215be92
> R10: 0000000000000000 R11: 0000000000000000 R12: ffff88811b035890
> R13: ffff88811b035880 R14: ffff8881173a4000 R15: dffffc0000000000
> FS:  0000000000000000(0000) GS:ffff88816a80f000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007ffd98c09c10 CR3: 00000000ace72000 CR4: 0000000000350ef0
> Call Trace:
>  <TASK>
>  pick_next_task_fair+0x98/0x1c60
>  __x64_sys_exit+0x42/0x50
>  x64_sys_call+0x154f/0x1760
>  do_syscall_64+0xfc/0x580
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fd94161777d
> Code: Unable to access opcode bytes at 0x7fd941617753.
>  __schedule+0x7ce/0x3ee0
> RSP: 002b:00007fff7d837098 EFLAGS: 00000246
>  ORIG_RAX: 000000000000003c
> RAX: ffffffffffffffda RBX: 000000000000000b RCX: 00007fd94161777d
> RDX: 00007fd94165859a RSI: 00007fff7d8370c0 RDI: 000000000000000b
>  preempt_schedule_irq+0x49/0x80
> RBP: 0000000000000000 R08: 00007fd9423e5000 R09: 0000000000007228
>  irqentry_exit+0xc1/0x660
> R10: 0000000000000053 R11: 0000000000000246 R12: 0000000000000000
>  asm_sysvec_apic_timer_interrupt+0x1a/0x20
> R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
> RIP: 0010:__rcu_read_unlock+0x88/0xf0
>  </TASK>
> Code: fc ff df 48 89 fa 48 c1 ea 03 83 eb 01 0f b6 14 02 48 89 f8 83 e0 07 83 c0 03 38 d0 7c 04 84 d2 75 62 41 89 9c 24 3c 04 00 00 <85> db 75 37 48 8d bd 40 04 00 00 48 b8 00 00 00 00 00 fc ff df 48
> ---[ end trace 0000000000000000 ]---
> RSP: 0018:ffff888110adf6e0 EFLAGS: 00000246
> RAX: 0000000000000007 RBX: 0000000000000000 RCX: ffff888110ae0001
> RDX: 0000000000000000 RSI: ffff888110adfdb0 RDI: ffff888100ec26bc
> RBP: ffff888100ec2280 R08: 0000000000000001 R09: ffff888110adf7b0
> R10: ffff888110adf770 R11: 0000000000009963 R12: ffff888100ec2280
> R13: ffff888110adf770 R14: ffff888110adfde0 R15: ffff888110adfdd8
>  unwind_next_frame+0x39d/0x2400
>  arch_stack_walk+0x94/0x100
>  stack_trace_save+0x8e/0xc0
>  kasan_save_stack+0x33/0x60
>  kasan_save_track+0x17/0x60
>  __kasan_kmalloc+0x8f/0xa0
>  kmem_cache_free+0x245/0x3d0
>  tear_down_vmas+0x182/0x3a0
>  exit_mmap+0x37f/0x800
>  mmput+0x6c/0x320
>  do_exit+0x7c1/0x28e0
>  do_group_exit+0xc7/0x280
>  __x64_sys_exit_group+0x3e/0x50
>  x64_sys_call+0x16cd/0x1760
>  do_syscall_64+0xfc/0x580
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fb99736777d
> Code: Unable to access opcode bytes at 0x7fb997367753.
> RSP: 002b:00007ffd98c095f8 EFLAGS: 00000206 ORIG_RAX: 00000000000000e7
> RAX: ffffffffffffffda RBX: 000000000000000b RCX: 00007fb99736777d
> RDX: 00007fb9973a859a RSI: 0000000000000000 RDI: 000000000000000b
> RBP: 00007ffd98c09bfc R08: 0000000000000000 R09: 000000000000000b
> R10: 000000000000000e R11: 0000000000000206 R12: 0000000000000000
> R13: 0000000000007221 R14: 0000000000000000 R15: 00000000000071f9
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> Oops: general protection fault, probably for non-canonical address 0xe1d646401ffff12b: 0000 [#2] SMP KASAN NOPTI
> RIP: 0010:pick_task_fair+0x89/0x1e0
> KASAN: maybe wild-memory-access in range [0x0eb25200ffff8958-0x0eb25200ffff895f]
> Code: c0 0f 84 0c 01 00 00 4d 89 ee eb 6b 4c 89 f7 be 01 00 00 00 e8 c8 14 fe ff 48 8d 78 59 48 89 fa 48 89 f9 48 c1 ea 03 83 e1 07 <42> 0f b6 14 3a 38 ca 7f 08 84 d2 0f 85 ed 00 00 00 80 78 59 00 0f
> CPU: 1 UID: 0 PID: 3489 Comm: syz-executor Tainted: G    B D W           7.0.0-rc6 #1 PREEMPT(lazy)
> RSP: 0018:ffff888110adf330 EFLAGS: 00010002
> Tainted: [B]=BAD_PAGE, [D]=DIE, [W]=WARN
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/2014
> RAX: 0000000000000000 RBX: ffff88811b035800 RCX: 0000000000000001
> RIP: 0010:cpuacct_account_field+0x8c/0x110
> RDX: 000000000000000b RSI: 0000000000000001 RDI: 0000000000000059
> Code: fb 00 bb cf ae 74 5b 48 bd 00 00 00 00 00 fc ff df 48 63 f6 4c 8d 24 f5 00 00 00 00 48 8d bb d8 00 00 00 48 89 f8 48 c1 e8 03 <80> 3c 28 00 75 41 48 8b 83 d8 00 00 00 48 8d bb b8 00 00 00 4c 01
> RBP: ffffed1023606b12 R08: 0000000000000001 R09: ffffed102215be92
> RSP: 0018:ffff88811b048c88 EFLAGS: 00010016
> R10: 0000000000000000 R11: 0000000000000000 R12: ffff88811b035890
> 
> R13: ffff88811b035880 R14: ffff8881173a4000 R15: dffffc0000000000
> RAX: 01d64a401ffff12b RBX: 0eb25200ffff8881 RCX: 0000000000010000
> FS:  0000000000000000(0000) GS:ffff88816a80f000(0000) knlGS:0000000000000000
> RDX: 1ffff11022e6cb02 RSI: 0000000000000002 RDI: 0eb25200ffff8959
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> RBP: dffffc0000000000 R08: 0000000000000000 R09: ffffed102360919a
> CR2: 00007ffd98c09c10 CR3: 00000000ace72000 CR4: 0000000000350ef0
> R10: 0000000000015a2a R11: ffff88811b048ff8 R12: 0000000000000010
> note: syz-executor[5123] exited with irqs disabled
> R13: 00000000000f4240 R14: ffff888104356500 R15: 0000000000000000
> FS:  0000000000000000(0000) GS:ffff88816a84f000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007ffffffff000 CR3: 0000000104120000 CR4: 0000000000350ef0
> Call Trace:
>  <IRQ>
>  account_system_index_time+0x113/0x1f0
>  update_process_times+0x82/0x1f0
>  tick_nohz_handler+0x5a1/0x710
>  __hrtimer_run_queues+0x411/0x8a0
>  hrtimer_interrupt+0x2f4/0x7c0
>  __sysvec_apic_timer_interrupt+0x88/0x2d0
>  sysvec_apic_timer_interrupt+0x67/0x80
>  </IRQ>
>  <TASK>
>  asm_sysvec_apic_timer_interrupt+0x1a/0x20
> RIP: 0010:__sanitizer_cov_trace_pc+0x8/0x80
> Code: 00 e9 6c ff ff ff 4d 01 d7 4d 89 39 e9 ef fd ff ff 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e fa 48 8b 0c 24 <65> 48 8b 15 18 bf d0 05 65 8b 05 29 bf d0 05 a9 00 01 ff 00 74 1d
> RSP: 0018:ffff8881031477f0 EFLAGS: 00000216
> RAX: ffff888100c74680 RBX: 0000000000001000 RCX: ffffffffaad67b73
> RDX: ffff88810150d640 RSI: 0000000000000000 RDI: 0000000000000001
> RBP: 0000000000000000 R08: 0000000000000000 R09: fffff94000040026
> R10: 0000000000000000 R11: ffffea00042a5400 R12: ffffea0000200100
> R13: 00007f8f51ecf000 R14: dffffc0000000000 R15: ffffea0000200130
>  unmap_page_range+0xe53/0x3f40
>  unmap_single_vma+0x153/0x240
>  unmap_vmas+0x248/0x530
>  exit_mmap+0x1ee/0x800
>  mmput+0x6c/0x320
>  do_exit+0x7c1/0x28e0
>  __x64_sys_exit+0x42/0x50
>  x64_sys_call+0x154f/0x1760
>  do_syscall_64+0xfc/0x580
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f8f52c8777d
> Code: Unable to access opcode bytes at 0x7f8f52c87753.
> RSP: 002b:00007ffdf12940d8 EFLAGS: 00000246 ORIG_RAX: 000000000000003c
> RAX: ffffffffffffffda RBX: 000000000000000b RCX: 00007f8f52c8777d
> RDX: 00007f8f52cc859a RSI: 00007ffdf1294100 RDI: 000000000000000b
> RBP: 00007ffdf1294740 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000049 R11: 0000000000000246 R12: 0000000000000000
> R13: 0000000000000065 R14: 0000000000000000 R15: 0000000000000001
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> Oops: stack segment: 0000 [#3] SMP KASAN NOPTI
> RIP: 0010:pick_task_fair+0x89/0x1e0
> CPU: 3 UID: 0 PID: 3120 Comm: syz-executor Tainted: G    B D W           7.0.0-rc6 #1 PREEMPT(lazy)
> Code: c0 0f 84 0c 01 00 00 4d 89 ee eb 6b 4c 89 f7 be 01 00 00 00 e8 c8 14 fe ff 48 8d 78 59 48 89 fa 48 89 f9 48 c1 ea 03 83 e1 07 <42> 0f b6 14 3a 38 ca 7f 08 84 d2 0f 85 ed 00 00 00 80 78 59 00 0f
> Tainted: [B]=BAD_PAGE, [D]=DIE, [W]=WARN
> RSP: 0018:ffff888110adf330 EFLAGS: 00010002
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/2014
> 
> RIP: 0010:stack_depot_save_flags+0x164/0x7f0
> RAX: 0000000000000000 RBX: ffff88811b035800 RCX: 0000000000000001
> Code: e1 04 48 03 0d 75 8f f0 04 65 ff 05 06 35 e4 04 48 8b 29 48 39 e9 75 12 e9 96 00 00 00 48 8b 6d 00 48 39 e9 0f 84 6c 01 00 00 <39> 5d 10 75 ee 44 3b 7d 14 75 e8 31 c0 48 8b 54 c5 20 49 39 54 c5
> RDX: 000000000000000b RSI: 0000000000000001 RDI: 0000000000000059
> RSP: 0000:ffff888114a279a8 EFLAGS: 00010096
> RBP: ffffed1023606b12 R08: 0000000000000001 R09: ffffed102215be92
> 
> RAX: 00000000b8c9dc9e RBX: 00000000b8c9dc9e RCX: ffff88811a3dc9e0
> R10: 0000000000000000 R11: 0000000000000000 R12: ffff88811b035890
> RDX: ffffffffaa4012a6 RSI: 0000000000000003 RDI: 0000000099bcd7db
> R13: ffff88811b035880 R14: ffff8881173a4000 R15: dffffc0000000000
> RBP: 075200d30000000c R08: ffffffffaf8a3284 R09: ffff888114a27900
> FS:  0000000000000000(0000) GS:ffff88816a84f000(0000) knlGS:0000000000000000
> R10: 00000000b2322418 R11: 000000002c30fd98 R12: 0000000000000001
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> R13: ffff888114a27a00 R14: 000000000000000c R15: 000000000000000c
> CR2: 00007ffffffff000 CR3: 0000000104120000 CR4: 0000000000350ef0
> FS:  000055555b109500(0000) GS:ffff88816a8cf000(0000) knlGS:0000000000000000
> 
> 
> RIP: 0010:pick_task_fair+0x89/0x1e0
> Code: c0 0f 84 0c 01 00 00 4d 89 ee eb 6b 4c 89 f7 be 01 00 00 00 e8 c8 14 fe ff 48 8d 78 59 48 89 fa 48 89 f9 48 c1 ea 03 83 e1 07 <42> 0f b6 14 3a 38 ca 7f 08 84 d2 0f 85 ed 00 00 00 80 78 59 00 0f
> RSP: 0018:ffff888110adf330 EFLAGS: 00010002
> RAX: 0000000000000000 RBX: ffff88811b035800 RCX: 0000000000000001
> ------------[ cut here ]------------
> WARNING: mm/swapfile.c:1909 at swap_put_entries_direct+0x1be/0x2c0, CPU#2: syz-executor/3650
> Modules linked in:
> CPU: 2 UID: 0 PID: 3650 Comm: syz-executor Not tainted 7.0.0-rc6 #1 PREEMPT(lazy)
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/2014
> RIP: 0010:swap_put_entries_direct+0x1be/0x2c0
> Code: 48 8b 44 24 58 65 48 2b 05 c7 e0 9c 05 0f 85 db 00 00 00 48 83 c4 60 5b 5d 41 5c 41 5d 41 5e e9 68 9c ef 02 e8 93 21 cc ff 90 <0f> 0b 90 eb b9 e8 88 21 cc ff 49 8d 6c 24 08 48 b8 00 00 00 00 00
> RSP: 0018:ffff88810bd0f768 EFLAGS: 00010293
> RAX: 0000000000000000 RBX: 000162affc3fffff RCX: ffffffffaae42f5d
> RDX: ffff888113315640 RSI: 0000000000000000 RDI: 0000000000000001
> RBP: 000162affc400000 R08: 0000000000000001 R09: ffffed10217a1e92
> R10: 0000000000000000 R11: 706177735f746567 R12: 0000000000000000
> R13: 1ffff110217a1eed R14: dffffc0000000000 R15: ffff888117002000
> FS:  0000000000000000(0000) GS:ffff88816a88f000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007ffffffff000 CR3: 00000001014b7000 CR4: 0000000000350ef0
> Call Trace:
>  <TASK>
>  unmap_page_range+0x1645/0x3f40
>  unmap_single_vma+0x153/0x240
>  unmap_vmas+0x248/0x530
>  exit_mmap+0x1ee/0x800
>  mmput+0x6c/0x320
>  do_exit+0x7c1/0x28e0
> Read of size 8 at addr 0000000100000190 by task syz.2.164/6127
> 
> CPU: 5 UID: 0 PID: 6127 Comm: syz.2.164 Not tainted 7.0.0-rc6 #1 PREEMPT(lazy)
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xab/0xe0
>  kasan_report+0xce/0x100
>  kasan_check_range+0x100/0x1b0
>  free_pgtables+0x53e/0xcd0
>  exit_mmap+0x362/0x800
>  mmput+0x6c/0x320
>  do_exit+0x7c1/0x28e0
>  do_group_exit+0xc7/0x280
>  get_signal+0x20d2/0x2150
>  arch_do_signal_or_restart+0x8f/0x7a0
>  exit_to_user_mode_loop+0x6b/0x4c0
>  do_syscall_64+0x46d/0x580
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f38134f777d
> Code: Unable to access opcode bytes at 0x7f38134f7753.
> RSP: 002b:00007f3811f36fa8 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
> RAX: fffffffffffffe00 RBX: 00007f3813785fa0 RCX: 00007f38134f777d
> RDX: 000000000000004e RSI: 00002000000000c0 RDI: 000000000000000c
> RBP: 00007f3813594d74 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f3813786038 R14: 00007f3813785fa0 R15: 00007f3811f17000
>  </TASK>
> ==================================================================
> RDX: 000000000000000b RSI: 0000000000000001 RDI: 0000000000000059
> RBP: ffffed1023606b12 R08: 0000000000000001 R09: ffffed102215be92
> R10: 0000000000000000 R11: 0000000000000000 R12: ffff88811b035890
> R13: ffff88811b035880 R14: ffff8881173a4000 R15: dffffc0000000000
> FS:  0000000000000000(0000) GS:ffff88816a80f000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007ffd98c09c10 CR3: 00000000ace72000 CR4: 0000000000350ef0
> Call Trace:
>  <TASK>
>  pick_next_task_fair+0x98/0x1c60
>  __x64_sys_exit+0x42/0x50
>  x64_sys_call+0x154f/0x1760
>  do_syscall_64+0xfc/0x580
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fd94161777d
> Code: Unable to access opcode bytes at 0x7fd941617753.
>  __schedule+0x7ce/0x3ee0
> RSP: 002b:00007fff7d837098 EFLAGS: 00000246
>  ORIG_RAX: 000000000000003c
> RAX: ffffffffffffffda RBX: 000000000000000b RCX: 00007fd94161777d
> RDX: 00007fd94165859a RSI: 00007fff7d8370c0 RDI: 000000000000000b
>  preempt_schedule_irq+0x49/0x80
> RBP: 0000000000000000 R08: 00007fd9423e5000 R09: 0000000000007228
>  irqentry_exit+0xc1/0x660
> R10: 0000000000000053 R11: 0000000000000246 R12: 0000000000000000
>  asm_sysvec_apic_timer_interrupt+0x1a/0x20
> R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
> RIP: 0010:__rcu_read_unlock+0x88/0xf0
>  </TASK>
> Code: fc ff df 48 89 fa 48 c1 ea 03 83 eb 01 0f b6 14 02 48 89 f8 83 e0 07 83 c0 03 38 d0 7c 04 84 d2 75 62 41 89 9c 24 3c 04 00 00 <85> db 75 37 48 8d bd 40 04 00 00 48 b8 00 00 00 00 00 fc ff df 48
> ---[ end trace 0000000000000000 ]---
> RSP: 0018:ffff888110adf6e0 EFLAGS: 00000246
> RAX: 0000000000000007 RBX: 0000000000000000 RCX: ffff888110ae0001
> RDX: 0000000000000000 RSI: ffff888110adfdb0 RDI: ffff888100ec26bc
> RBP: ffff888100ec2280 R08: 0000000000000001 R09: ffff888110adf7b0
> R10: ffff888110adf770 R11: 0000000000009963 R12: ffff888100ec2280
> R13: ffff888110adf770 R14: ffff888110adfde0 R15: ffff888110adfdd8
>  unwind_next_frame+0x39d/0x2400
>  arch_stack_walk+0x94/0x100
>  stack_trace_save+0x8e/0xc0
>  kasan_save_stack+0x33/0x60
>  kasan_save_track+0x17/0x60
>  __kasan_kmalloc+0x8f/0xa0
>  kmem_cache_free+0x245/0x3d0
>  tear_down_vmas+0x182/0x3a0
>  exit_mmap+0x37f/0x800
>  mmput+0x6c/0x320
>  do_exit+0x7c1/0x28e0
>  do_group_exit+0xc7/0x280
>  __x64_sys_exit_group+0x3e/0x50
>  x64_sys_call+0x16cd/0x1760
>  do_syscall_64+0xfc/0x580
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fb99736777d
> Code: Unable to access opcode bytes at 0x7fb997367753.
> RSP: 002b:00007ffd98c095f8 EFLAGS: 00000206 ORIG_RAX: 00000000000000e7
> RAX: ffffffffffffffda RBX: 000000000000000b RCX: 00007fb99736777d
> RDX: 00007fb9973a859a RSI: 0000000000000000 RDI: 000000000000000b
> RBP: 00007ffd98c09bfc R08: 0000000000000000 R09: 000000000000000b
> R10: 000000000000000e R11: 0000000000000206 R12: 0000000000000000
> R13: 0000000000007221 R14: 0000000000000000 R15: 00000000000071f9
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> Oops: general protection fault, probably for non-canonical address 0xe1d646401ffff12b: 0000 [#2] SMP KASAN NOPTI
> RIP: 0010:pick_task_fair+0x89/0x1e0
> KASAN: maybe wild-memory-access in range [0x0eb25200ffff8958-0x0eb25200ffff895f]
> Code: c0 0f 84 0c 01 00 00 4d 89 ee eb 6b 4c 89 f7 be 01 00 00 00 e8 c8 14 fe ff 48 8d 78 59 48 89 fa 48 89 f9 48 c1 ea 03 83 e1 07 <42> 0f b6 14 3a 38 ca 7f 08 84 d2 0f 85 ed 00 00 00 80 78 59 00 0f
> CPU: 1 UID: 0 PID: 3489 Comm: syz-executor Tainted: G    B D W           7.0.0-rc6 #1 PREEMPT(lazy)
> RSP: 0018:ffff888110adf330 EFLAGS: 00010002
> Tainted: [B]=BAD_PAGE, [D]=DIE, [W]=WARN
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/2014
> RAX: 0000000000000000 RBX: ffff88811b035800 RCX: 0000000000000001
> RIP: 0010:cpuacct_account_field+0x8c/0x110
> RDX: 000000000000000b RSI: 0000000000000001 RDI: 0000000000000059
> Code: fb 00 bb cf ae 74 5b 48 bd 00 00 00 00 00 fc ff df 48 63 f6 4c 8d 24 f5 00 00 00 00 48 8d bb d8 00 00 00 48 89 f8 48 c1 e8 03 <80> 3c 28 00 75 41 48 8b 83 d8 00 00 00 48 8d bb b8 00 00 00 4c 01
> RBP: ffffed1023606b12 R08: 0000000000000001 R09: ffffed102215be92
> RSP: 0018:ffff88811b048c88 EFLAGS: 00010016
> R10: 0000000000000000 R11: 0000000000000000 R12: ffff88811b035890
> 
> R13: ffff88811b035880 R14: ffff8881173a4000 R15: dffffc0000000000
> RAX: 01d64a401ffff12b RBX: 0eb25200ffff8881 RCX: 0000000000010000
> FS:  0000000000000000(0000) GS:ffff88816a80f000(0000) knlGS:0000000000000000
> RDX: 1ffff11022e6cb02 RSI: 0000000000000002 RDI: 0eb25200ffff8959
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> RBP: dffffc0000000000 R08: 0000000000000000 R09: ffffed102360919a
> CR2: 00007ffd98c09c10 CR3: 00000000ace72000 CR4: 0000000000350ef0
> R10: 0000000000015a2a R11: ffff88811b048ff8 R12: 0000000000000010
> note: syz-executor[5123] exited with irqs disabled
> R13: 00000000000f4240 R14: ffff888104356500 R15: 0000000000000000
> FS:  0000000000000000(0000) GS:ffff88816a84f000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007ffffffff000 CR3: 0000000104120000 CR4: 0000000000350ef0
> Call Trace:
>  <IRQ>
>  account_system_index_time+0x113/0x1f0
>  update_process_times+0x82/0x1f0
>  tick_nohz_handler+0x5a1/0x710
>  __hrtimer_run_queues+0x411/0x8a0
>  hrtimer_interrupt+0x2f4/0x7c0
>  __sysvec_apic_timer_interrupt+0x88/0x2d0
>  sysvec_apic_timer_interrupt+0x67/0x80
>  </IRQ>
>  <TASK>
>  asm_sysvec_apic_timer_interrupt+0x1a/0x20
> RIP: 0010:__sanitizer_cov_trace_pc+0x8/0x80
> Code: 00 e9 6c ff ff ff 4d 01 d7 4d 89 39 e9 ef fd ff ff 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e fa 48 8b 0c 24 <65> 48 8b 15 18 bf d0 05 65 8b 05 29 bf d0 05 a9 00 01 ff 00 74 1d
> RSP: 0018:ffff8881031477f0 EFLAGS: 00000216
> RAX: ffff888100c74680 RBX: 0000000000001000 RCX: ffffffffaad67b73
> RDX: ffff88810150d640 RSI: 0000000000000000 RDI: 0000000000000001
> RBP: 0000000000000000 R08: 0000000000000000 R09: fffff94000040026
> R10: 0000000000000000 R11: ffffea00042a5400 R12: ffffea0000200100
> R13: 00007f8f51ecf000 R14: dffffc0000000000 R15: ffffea0000200130
>  unmap_page_range+0xe53/0x3f40
>  unmap_single_vma+0x153/0x240
>  unmap_vmas+0x248/0x530
>  exit_mmap+0x1ee/0x800
>  mmput+0x6c/0x320
>  do_exit+0x7c1/0x28e0
>  __x64_sys_exit+0x42/0x50
>  x64_sys_call+0x154f/0x1760
>  do_syscall_64+0xfc/0x580
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f8f52c8777d
> Code: Unable to access opcode bytes at 0x7f8f52c87753.
> RSP: 002b:00007ffdf12940d8 EFLAGS: 00000246 ORIG_RAX: 000000000000003c
> RAX: ffffffffffffffda RBX: 000000000000000b RCX: 00007f8f52c8777d
> RDX: 00007f8f52cc859a RSI: 00007ffdf1294100 RDI: 000000000000000b
> RBP: 00007ffdf1294740 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000049 R11: 0000000000000246 R12: 0000000000000000
> R13: 0000000000000065 R14: 0000000000000000 R15: 0000000000000001
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> Oops: stack segment: 0000 [#3] SMP KASAN NOPTI
> RIP: 0010:pick_task_fair+0x89/0x1e0
> CPU: 3 UID: 0 PID: 3120 Comm: syz-executor Tainted: G    B D W           7.0.0-rc6 #1 PREEMPT(lazy)
> Code: c0 0f 84 0c 01 00 00 4d 89 ee eb 6b 4c 89 f7 be 01 00 00 00 e8 c8 14 fe ff 48 8d 78 59 48 89 fa 48 89 f9 48 c1 ea 03 83 e1 07 <42> 0f b6 14 3a 38 ca 7f 08 84 d2 0f 85 ed 00 00 00 80 78 59 00 0f
> Tainted: [B]=BAD_PAGE, [D]=DIE, [W]=WARN
> RSP: 0018:ffff888110adf330 EFLAGS: 00010002
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/2014
> 
> RIP: 0010:stack_depot_save_flags+0x164/0x7f0
> RAX: 0000000000000000 RBX: ffff88811b035800 RCX: 0000000000000001
> Code: e1 04 48 03 0d 75 8f f0 04 65 ff 05 06 35 e4 04 48 8b 29 48 39 e9 75 12 e9 96 00 00 00 48 8b 6d 00 48 39 e9 0f 84 6c 01 00 00 <39> 5d 10 75 ee 44 3b 7d 14 75 e8 31 c0 48 8b 54 c5 20 49 39 54 c5
> RDX: 000000000000000b RSI: 0000000000000001 RDI: 0000000000000059
> RSP: 0000:ffff888114a279a8 EFLAGS: 00010096
> RBP: ffffed1023606b12 R08: 0000000000000001 R09: ffffed102215be92
> 
> RAX: 00000000b8c9dc9e RBX: 00000000b8c9dc9e RCX: ffff88811a3dc9e0
> R10: 0000000000000000 R11: 0000000000000000 R12: ffff88811b035890
> RDX: ffffffffaa4012a6 RSI: 0000000000000003 RDI: 0000000099bcd7db
> R13: ffff88811b035880 R14: ffff8881173a4000 R15: dffffc0000000000
> RBP: 075200d30000000c R08: ffffffffaf8a3284 R09: ffff888114a27900
> FS:  0000000000000000(0000) GS:ffff88816a84f000(0000) knlGS:0000000000000000
> R10: 00000000b2322418 R11: 000000002c30fd98 R12: 0000000000000001
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> R13: ffff888114a27a00 R14: 000000000000000c R15: 000000000000000c
> CR2: 00007ffffffff000 CR3: 0000000104120000 CR4: 0000000000350ef0
> FS:  000055555b109500(0000) GS:ffff88816a8cf000(0000) knlGS:0000000000000000
> 
> 
> R10: 000000000000000e R11: 0000000000000206 R12: 0000000000000000
> R13: 0000000000007221 R14: 0000000000000000 R15: 00000000000071f9
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> Oops: general protection fault, probably for non-canonical address 0xe1d646401ffff12b: 0000 [#2] SMP KASAN NOPTI
> RIP: 0010:pick_task_fair+0x89/0x1e0
> KASAN: maybe wild-memory-access in range [0x0eb25200ffff8958-0x0eb25200ffff895f]
> Code: c0 0f 84 0c 01 00 00 4d 89 ee eb 6b 4c 89 f7 be 01 00 00 00 e8 c8 14 fe ff 48 8d 78 59 48 89 fa 48 89 f9 48 c1 ea 03 83 e1 07 <42> 0f b6 14 3a 38 ca 7f 08 84 d2 0f 85 ed 00 00 00 80 78 59 00 0f
> CPU: 1 UID: 0 PID: 3489 Comm: syz-executor Tainted: G    B D W           7.0.0-rc6 #1 PREEMPT(lazy)
> RSP: 0018:ffff888110adf330 EFLAGS: 00010002
> Tainted: [B]=BAD_PAGE, [D]=DIE, [W]=WARN
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/2014
> RAX: 0000000000000000 RBX: ffff88811b035800 RCX: 0000000000000001
> RIP: 0010:cpuacct_account_field+0x8c/0x110
> RDX: 000000000000000b RSI: 0000000000000001 RDI: 0000000000000059
> Code: fb 00 bb cf ae 74 5b 48 bd 00 00 00 00 00 fc ff df 48 63 f6 4c 8d 24 f5 00 00 00 00 48 8d bb d8 00 00 00 48 89 f8 48 c1 e8 03 <80> 3c 28 00 75 41 48 8b 83 d8 00 00 00 48 8d bb b8 00 00 00 4c 01
> RBP: ffffed1023606b12 R08: 0000000000000001 R09: ffffed102215be92
> RSP: 0018:ffff88811b048c88 EFLAGS: 00010016
> R10: 0000000000000000 R11: 0000000000000000 R12: ffff88811b035890
> 
> R13: ffff88811b035880 R14: ffff8881173a4000 R15: dffffc0000000000
> RAX: 01d64a401ffff12b RBX: 0eb25200ffff8881 RCX: 0000000000010000
> FS:  0000000000000000(0000) GS:ffff88816a80f000(0000) knlGS:0000000000000000
> RDX: 1ffff11022e6cb02 RSI: 0000000000000002 RDI: 0eb25200ffff8959
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> RBP: dffffc0000000000 R08: 0000000000000000 R09: ffffed102360919a
> CR2: 00007ffd98c09c10 CR3: 00000000ace72000 CR4: 0000000000350ef0
> R10: 0000000000015a2a R11: ffff88811b048ff8 R12: 0000000000000010
> note: syz-executor[5123] exited with irqs disabled
> R13: 00000000000f4240 R14: ffff888104356500 R15: 0000000000000000
> FS:  0000000000000000(0000) GS:ffff88816a84f000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007ffffffff000 CR3: 0000000104120000 CR4: 0000000000350ef0
> Call Trace:
>  <IRQ>
>  account_system_index_time+0x113/0x1f0
>  update_process_times+0x82/0x1f0
>  tick_nohz_handler+0x5a1/0x710
>  __hrtimer_run_queues+0x411/0x8a0
>  hrtimer_interrupt+0x2f4/0x7c0
>  __sysvec_apic_timer_interrupt+0x88/0x2d0
>  sysvec_apic_timer_interrupt+0x67/0x80
>  </IRQ>
>  <TASK>
>  asm_sysvec_apic_timer_interrupt+0x1a/0x20
> RIP: 0010:__sanitizer_cov_trace_pc+0x8/0x80
> Code: 00 e9 6c ff ff ff 4d 01 d7 4d 89 39 e9 ef fd ff ff 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e fa 48 8b 0c 24 <65> 48 8b 15 18 bf d0 05 65 8b 05 29 bf d0 05 a9 00 01 ff 00 74 1d
> RSP: 0018:ffff8881031477f0 EFLAGS: 00000216
> RAX: ffff888100c74680 RBX: 0000000000001000 RCX: ffffffffaad67b73
> RDX: ffff88810150d640 RSI: 0000000000000000 RDI: 0000000000000001
> RBP: 0000000000000000 R08: 0000000000000000 R09: fffff94000040026
> R10: 0000000000000000 R11: ffffea00042a5400 R12: ffffea0000200100
> R13: 00007f8f51ecf000 R14: dffffc0000000000 R15: ffffea0000200130
>  unmap_page_range+0xe53/0x3f40
>  unmap_single_vma+0x153/0x240
>  unmap_vmas+0x248/0x530
>  exit_mmap+0x1ee/0x800
>  mmput+0x6c/0x320
>  do_exit+0x7c1/0x28e0
>  __x64_sys_exit+0x42/0x50
>  x64_sys_call+0x154f/0x1760
>  do_syscall_64+0xfc/0x580
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f8f52c8777d
> Code: Unable to access opcode bytes at 0x7f8f52c87753.
> RSP: 002b:00007ffdf12940d8 EFLAGS: 00000246 ORIG_RAX: 000000000000003c
> RAX: ffffffffffffffda RBX: 000000000000000b RCX: 00007f8f52c8777d
> RDX: 00007f8f52cc859a RSI: 00007ffdf1294100 RDI: 000000000000000b
> RBP: 00007ffdf1294740 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000049 R11: 0000000000000246 R12: 0000000000000000
> R13: 0000000000000065 R14: 0000000000000000 R15: 0000000000000001
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> Oops: stack segment: 0000 [#3] SMP KASAN NOPTI
> RIP: 0010:pick_task_fair+0x89/0x1e0
> CPU: 3 UID: 0 PID: 3120 Comm: syz-executor Tainted: G    B D W           7.0.0-rc6 #1 PREEMPT(lazy)
> Code: c0 0f 84 0c 01 00 00 4d 89 ee eb 6b 4c 89 f7 be 01 00 00 00 e8 c8 14 fe ff 48 8d 78 59 48 89 fa 48 89 f9 48 c1 ea 03 83 e1 07 <42> 0f b6 14 3a 38 ca 7f 08 84 d2 0f 85 ed 00 00 00 80 78 59 00 0f
> Tainted: [B]=BAD_PAGE, [D]=DIE, [W]=WARN
> RSP: 0018:ffff888110adf330 EFLAGS: 00010002
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/2014
> 
> RIP: 0010:stack_depot_save_flags+0x164/0x7f0
> RAX: 0000000000000000 RBX: ffff88811b035800 RCX: 0000000000000001
> Code: e1 04 48 03 0d 75 8f f0 04 65 ff 05 06 35 e4 04 48 8b 29 48 39 e9 75 12 e9 96 00 00 00 48 8b 6d 00 48 39 e9 0f 84 6c 01 00 00 <39> 5d 10 75 ee 44 3b 7d 14 75 e8 31 c0 48 8b 54 c5 20 49 39 54 c5
> RDX: 000000000000000b RSI: 0000000000000001 RDI: 0000000000000059
> RSP: 0000:ffff888114a279a8 EFLAGS: 00010096
> RBP: ffffed1023606b12 R08: 0000000000000001 R09: ffffed102215be92
> 
> RAX: 00000000b8c9dc9e RBX: 00000000b8c9dc9e RCX: ffff88811a3dc9e0
> R10: 0000000000000000 R11: 0000000000000000 R12: ffff88811b035890
> RDX: ffffffffaa4012a6 RSI: 0000000000000003 RDI: 0000000099bcd7db
> R13: ffff88811b035880 R14: ffff8881173a4000 R15: dffffc0000000000
> RBP: 075200d30000000c R08: ffffffffaf8a3284 R09: ffff888114a27900
> FS:  0000000000000000(0000) GS:ffff88816a84f000(0000) knlGS:0000000000000000
> R10: 00000000b2322418 R11: 000000002c30fd98 R12: 0000000000000001
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> R13: ffff888114a27a00 R14: 000000000000000c R15: 000000000000000c
> CR2: 00007ffffffff000 CR3: 0000000104120000 CR4: 0000000000350ef0
> FS:  000055555b109500(0000) GS:ffff88816a8cf000(0000) knlGS:0000000000000000
> 
> 
> Thanks,
> Forrest021
> 


-- 
Cheers,

David

