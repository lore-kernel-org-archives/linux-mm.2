Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27DBDC87FDA
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 08:26:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD8056B0095; Mon,  4 Aug 2025 04:26:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AAF906B0096; Mon,  4 Aug 2025 04:26:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9ECC76B0098; Mon,  4 Aug 2025 04:26:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8DFE46B0095
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 04:26:33 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 331C2C1016
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 08:26:33 +0000 (UTC)
X-FDA: 83738393466.26.B0B34CD
Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	by imf04.hostedemail.com (Postfix) with ESMTP id 458E740011
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 08:26:30 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=FG+WIZbd;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf04.hostedemail.com: domain of zhengqi.arch@bytedance.com designates 209.85.219.47 as permitted sender) smtp.mailfrom=zhengqi.arch@bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754295991; a=rsa-sha256;
	cv=none;
	b=TULDkwnukeGnSCoeaPS6VsXgbU4Ck1/KDm1zh/Mu7hqiaF8Kbh7Q6ee1EFY7GWa5jZmM/c
	ez6IEAlhdwcTm7v1kdsCVUatXgdWTkyE2yE3arnjI9Vwa3zhb6knhYFwurGN9VTMjwUQXf
	YX0LS/Dv4uqm1ZwABi2yL9TYY2khLHc=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=FG+WIZbd;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf04.hostedemail.com: domain of zhengqi.arch@bytedance.com designates 209.85.219.47 as permitted sender) smtp.mailfrom=zhengqi.arch@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754295991;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m2RyP9At/8cShb7Or89FoHpjZvuniUFsB7aTWcP0pvY=;
	b=DrjwMBZlriMGo9h8M5pZuYspw1QVrxtkNr1yOIgzUasOSr1xqE3/EcRtxSbzf5yqLKFtLG
	aolpU02xW99TYh0OiqyL5jcHeFiFtGSSaMcG+Si25qtaGZbnPcPMklOCDxYsJS13c8wRp9
	pxUqkfr29Dnf9sZ8NKdYxG7BRM8L+sc=
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-70736b2ea12so15349906d6.1
        for <linux-mm@kvack.org>; Mon, 04 Aug 2025 01:26:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1754295989; x=1754900789; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m2RyP9At/8cShb7Or89FoHpjZvuniUFsB7aTWcP0pvY=;
        b=FG+WIZbdb6h56Whok2zbJYYnbt3EvNDfLs+8y6VG80t4lbUZwHpJM96e0bRX3bNmTS
         lYz9r5p+Q5hOG/thvl9U1q6Pe19ceBMZkHxmniF2KVCGqhVy24gc12cIdJWUNIBv0UH5
         dur+zGWxcpHvWwsFifCiZvxsJm+mF/JoKFm2Re4wBO4G0ZeLS2LC/3cn7zzuSLIAIbO6
         aGv9s7s02Xls9iDvgjfs5j1CjTX7ZVeFee/t3UeL5J/ZIj4ZJqAheisN1fdsQ4QyKRaj
         dAPl4nSO1iyACoOQWyPYXRSt72wwE7L59L/lyWEtRrv9pKtIpiOl2Jq/N8b6t9jlGS9j
         r7ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754295989; x=1754900789;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=m2RyP9At/8cShb7Or89FoHpjZvuniUFsB7aTWcP0pvY=;
        b=GjFouGeiUGpFkaJ8nuHyqUf7bI4Pkubbml2RW6WXc1KXaPgthx8gNoPAyVUst+wfEx
         flIr+G97tO0Ahgv4gCF1wrX7RgXGvlWbpQyEuGbbsHcgELF83xEq7TsWYfML0hHu7gu7
         M7WJKuEGwHbObdO/XfTOY4PY6T/RFvh8KTAGVaxq5g73vunS7oPKnIZUCy9yGgFjcNyk
         ROJ9rdWIHg0k6lrPZBFBzMIEs7mhGRmhsL1wXU9OPJP7D5gw908tZ1fBP6XpzVMEqedo
         Slcm5AybYXEjfMXg2XzglNRDvO+hLalzd02FThuyEtgUdnc5dyZ1pxYrEK0UhhT4VA72
         0PSQ==
X-Forwarded-Encrypted: i=1; AJvYcCVliGzgev2OTGr6HvEMXoLqBWjPD+OOnFOwMoaDOClyDabpy/T+UiAL1Eez7reM4hrw1Fo17j5mnw==@kvack.org
X-Gm-Message-State: AOJu0YxDjkuOvJFRJ3H9Z3f81aBVK7U6Ke6NphLHYkEP1ZrsJcFoPq1C
	CR3t2An+ui/ioLWAwagliHClJ2ea3PTeFaTR70lXWSQPqZdcar36rNheRU/Wgank/co=
X-Gm-Gg: ASbGncuFXoqTXligB+oAvouWkcT2w1GvsOMeQrPpn/xiSYhzqIFcWIo83f1eI3ccUGH
	WWP80xMFTb4FkAp5veGjgS+LDAesiH7Wetuo4lgnLYaFQ69Xrs8SdFXw4CEdWYXPzazkIOu2xmA
	oLtcE3YltJB53sMQQSsnvJ6TiNO4NvOTByctrQRYQYmhk2Vsis3rbFoxicGreQ9QbBNp1rioxFT
	f9dcBJvtIFVvzsNQM4Y6QmquS2EXYPlp7f+2NC8kfqKGhUhuoxi9hwu/ALRCzdODsBBFIbLJxar
	Z9pNSLDLy8620wS9oYvIxDr1J9oiY+QJ2wVibyN7OFKvLCofMchTjse49lkAHSqTBzt9f4GC16s
	jAcgCazfKbrVkzNXuTUZeBHXbI1j1+c6UPNfQZR4Y5yzvjVc=
X-Google-Smtp-Source: AGHT+IGaNMXElcAJh0JfCTL7zEVzpv0E94UnfVK1i/Gfn/pvcITIZCAEwwbjfZEzPrFoBpsNBSwL8w==
X-Received: by 2002:ad4:5749:0:b0:709:205a:d90c with SMTP id 6a1803df08f44-70935f0e681mr124688606d6.3.1754295989130;
        Mon, 04 Aug 2025 01:26:29 -0700 (PDT)
Received: from [10.68.122.90] ([203.208.167.150])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-7077cdf4831sm55138656d6.75.2025.08.04.01.26.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Aug 2025 01:26:28 -0700 (PDT)
Message-ID: <4fa8f492-c7ef-451c-8dc7-38b031c8a092@bytedance.com>
Date: Mon, 4 Aug 2025 16:26:19 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] mm: use per_vma lock for MADV_DONTNEED
To: David Hildenbrand <david@redhat.com>, "Lai, Yi"
 <yi1.lai@linux.intel.com>, Barry Song <21cnbao@gmail.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Barry Song <v-songbaohua@oppo.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
 Suren Baghdasaryan <surenb@google.com>, Lokesh Gidra
 <lokeshgidra@google.com>, Tangquan Zheng <zhengtangquan@oppo.com>,
 yi1.lai@intel.com
References: <20250607220150.2980-1-21cnbao@gmail.com>
 <aJAFrYfyzGpbm+0m@ly-workstation>
 <1d1d97f9-2a67-4920-850e-accf4c82440e@redhat.com>
From: Qi Zheng <zhengqi.arch@bytedance.com>
In-Reply-To: <1d1d97f9-2a67-4920-850e-accf4c82440e@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 458E740011
X-Stat-Signature: ik3rybwbum9hgiaypszxnhik4dqjg6p5
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1754295990-832194
X-HE-Meta: U2FsdGVkX1+rynDrwcVirf1rTkz/IOtoeVukds+n/muPGfRdoypefwXeuC2Q4ZiOgmgPCbDa2joPYpW3m+SG2gyzgnWvFtYQu+WJPE+wQIK4sqXBXgFQLCSfHGKdjFttEtqnRymPTcnNjJuPHHgfCnBTHMY5Au97fkiHMZm/fINWX34RMNs+H/DzYI+hAe602p8KztSgKfNvdbB5ll2BzaZ979/IshdjBfcrYIseA0YNBgZwxGg7uGmfhqcky/DWnA9MQROorVz5vA5BFUsZSYFasHBBmHZvqKc43jhP/MmBUozXMmqmec0n3sJ78N96oRlbtCg66M9WNAYUhMk13fyPkviOg0YLPMfoQxymMrw1kd5lcvTSdOQ/bLupnwvwWfdVaMVU/KTIy4NT6yS8b4MuLsWJlAtwDNmXxjBQs/lCJEeLPgKST3pNNRxyIPEtLLsCsyiLdjx+asz3SOswnpyE78X9XXV42UIugJaLtE0w63T+XBEk/OJrYfkjKZ6+eHNGKdh923k9KpoAD9sujycL3lY5HQ2Blgoyp2MG2Vusbx/BZIQPvguPvEew8VoxKONhHVG8xSOHxN1rjw1ujVRfRoPxowyRSRkEktCZ9XG9lS3xiggJnc8g9SZ+2UTkxb8MMMzUnOoAQjc1OkfSCx+n49LqxpXi0XEuUx8Btg5EQUXTyeMypZ9gicJp+73FVwkPQoGaA9FQu9lV9aI/m2Kv1ZCZsvtViV5/kg1Rk7AFzcSuyCm/4FLvmhQKCYrgxg5GZ3TY8hJFQSm4o7SD0+YyW9SfhHz+jj3DUBbc/Kkr3jv4x/g1UXcf0uYLS5qjNQ+4OnMDPSbe2NDJFxFXXVm33hAYvTO/+Ag0984syVeUsqt9XGHcahX0aAvHwP6c6oFuTPwf2cbkl8BJdgoMJ9hZfwzoInuTXShpx3eRR4LanvB4vuxKrrpFE6ZnzARskWF7U6S9fKiHlZHr2ZU
 dHmczyqk
 u/pti11MYqQxHRWw9Pz+ENipTcrYmTP2ErV8ROh4fki5DZf0IO9sJTykbW1I1+2nl3+jqNU4xuvzgEEFBJ87twRkXYcgw5o1e73cZYluwyB7++2ao4XOava4+z+BPVmM5v5tQIXZFtF8EuK76Sy6FykcDTyedaK2vyIJq3LSb1uZUtCWJbHZkdtm3dsWrymNidHHVeJpmQ4AVxeqi8kP56YOaCqO+We1wlzWIkOgNVVuiDH+YDJdRKCUyhTlVFGWjpHY5eNOe3iE+oPh80lxrfrwQGiHGEL4TCS45LaF2wRoEXEJqNFbxp3hrC8IrrSLX1i20tnl6rvhUZk7ByKh5ucRVGad1A4Ehxak+rvHOQOJ3M83WDB0x+BpPEkIRkxeXPv+ZPyHCNH+ZFBFM020dfcR6Cg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/4/25 3:57 PM, David Hildenbrand wrote:
> On 04.08.25 02:58, Lai, Yi wrote:
>> Hi Barry Song,
>>
>> Greetings!
>>
>> I used Syzkaller and found that there is general protection fault in 
>> __pte_offset_map_lock in linux-next next-20250801.
>>
>> After bisection and the first bad commit is:
>> "
>> a6fde7add78d mm: use per_vma lock for MADV_DONTNEED
>> "
>>
>> All detailed into can be found at:
>> https://github.com/laifryiee/syzkaller_logs/tree/ 
>> main/250803_193026___pte_offset_map_lock
>> Syzkaller repro code:
>> https://github.com/laifryiee/syzkaller_logs/tree/ 
>> main/250803_193026___pte_offset_map_lock/repro.c
>> Syzkaller repro syscall steps:
>> https://github.com/laifryiee/syzkaller_logs/tree/ 
>> main/250803_193026___pte_offset_map_lock/repro.prog
>> Syzkaller report:
>> https://github.com/laifryiee/syzkaller_logs/tree/ 
>> main/250803_193026___pte_offset_map_lock/repro.report
>> Kconfig(make olddefconfig):
>> https://github.com/laifryiee/syzkaller_logs/tree/ 
>> main/250803_193026___pte_offset_map_lock/kconfig_origin
>> Bisect info:
>> https://github.com/laifryiee/syzkaller_logs/tree/ 
>> main/250803_193026___pte_offset_map_lock/bisect_info.log
>> bzImage:
>> https://github.com/laifryiee/syzkaller_logs/raw/refs/heads/ 
>> main/250803_193026___pte_offset_map_lock/bzImage_next-20250801
>> Issue dmesg:
>> https://github.com/laifryiee/syzkaller_logs/blob/ 
>> main/250803_193026___pte_offset_map_lock/next-20250801_dmesg.log
> 
> Skimming over the reproducer, we seem to have racing MADV_DONTNEED and 
> MADV_COLLAPSE on the same anon area, but the problem only shows up once 
> we tear down that MM.
> 
> If I would have to guess, I'd assume it's related to PT_RECLAIM 
> reclaiming empty page tables during MADV_DONTNEED -- but the kconfig 
> does not indicate that CONFIG_PT_RECLAIM was set.

On the x86_64, if PT_RECLAIM is not manually disabled, PT_RECLAIM should
be enabled; but since __pte_offset_map_lock() holds the RCU lock, there
should be no problem even if PT_RECLAIM frees the PTE page (via RCU).
Anyway, I will also find time to reproduce the problem locally and then
look into this issue.

Thanks.

> 


