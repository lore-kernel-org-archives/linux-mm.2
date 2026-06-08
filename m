Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0FC54CD8C9D
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 12:50:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 50A666B008C; Mon,  8 Jun 2026 08:50:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E1866B0092; Mon,  8 Jun 2026 08:50:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F7F66B0093; Mon,  8 Jun 2026 08:50:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2F2236B008C
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 08:50:33 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C925F1C1244
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 12:50:32 +0000 (UTC)
X-FDA: 84856729104.25.8607F96
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	by imf08.hostedemail.com (Postfix) with ESMTP id CD469160012
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 12:50:30 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=aNQMYQvz;
	spf=pass (imf08.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780923030;
	b=SikGpQcPFld9zAO7rZ8mTos/JS+Le+Scgx6sBAfHSsECTMNLn63rk25Y5khHNIgxSF1cKM
	DhSFMtvrr0lXpVRnkcyMLovedxM+4ogDw08kE6l38ilPJCAKvgcBBR7ibx4xksAR9heGaZ
	uWUQY6VOFKsnsHjXsfiuW57M0GlE2XY=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=aNQMYQvz;
	spf=pass (imf08.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780923030;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DiIdK82JBJK4ZmshrTXuh1DETm09pI5fnq4TS+v0gOw=;
	b=i88zX8U4Uda/4xXw/5uyHkgTqST4hdHzZEj//YCyHBzoYw3M2UfqTcW2pzUEOaCIwOKPj0
	N5HD+z73dZAoYHkldvk9VQr0XiiriBevWoYIGzxMondGawBdlRCwT6mqBqVPhVFjGkqadX
	uu70LIrms4puLnZhucvgNHXrDc134i0=
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-36d5b11201aso2698608a91.2
        for <linux-mm@kvack.org>; Mon, 08 Jun 2026 05:50:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780923030; x=1781527830; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DiIdK82JBJK4ZmshrTXuh1DETm09pI5fnq4TS+v0gOw=;
        b=aNQMYQvzPO8rF5APMdij4nij8r83x7JgFOFR1uALe1W144PcIJjSq7GrIx6VvXL70p
         nUCt8BfXlACezBdZLZpAmCG5tU298F1+gyAuyLZtwKbzHbphRlLkTbLiv+qwbToiLoDk
         RPGFc03MnFSYMJMmkbFC7RenGJvwVBzZoagDVhB9e4g1QOgt6msMf9NePYy8yIZ5WFUQ
         RqPrxhl195k5QbIvRKvSsoQUpLRQu5iK+XZQSwytUO7Ri4AtA9M04SxkxWYvuAq/WokY
         Og9SColntgsDoPMu4E3mdlRpoaoujs059JAOyWlZILDd8nArBlXpY/urZKNx36Ri4XKe
         u9EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780923030; x=1781527830;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DiIdK82JBJK4ZmshrTXuh1DETm09pI5fnq4TS+v0gOw=;
        b=qB3zTPrYO0qZcL4lMdvfFbrnP7q89w0q/ClylHVeC4LdUUQqRZEAKs0HkQlfRfm1yu
         jKUelVvYclV1RA+rMM5V6IgJntTZ/5vidLX+BUaWlhiDb4ZCJKW43AwIBV/cmyLsiUkO
         eWvH8x6R7t1kKJZxXYV73TWN+iLmntULqt7QCjIO2cV6p+psDY/ZEEFe/jFAAB1xCqwC
         XYRfyh67egZ+/sKgcYbutV4+gE3WdFOb4fbZDPNpf3a914bHDUMKSdX+Yrf360nZreA9
         GtiDRTzx8RbFvJl6i0pYagqQ2jp++9vrlvVqkETphFiArNkNIVBQ66jLaGhBIJ6ExFDb
         STqA==
X-Forwarded-Encrypted: i=1; AFNElJ8+kmRXj/PQHCIq35+180dXu+oyU8YlKs5SlHsvVbbezH04ljuvS/fnLClc8M7crLXC52HDNOH5ew==@kvack.org
X-Gm-Message-State: AOJu0YwbLkhncZlF8AOha6kc1jPttWcDov57u4ellKlm0PGkVU62Q6AF
	Oz/RXRUATBZllIJOddlawwDm0poZScyzVfLxxM9mZSt4Milv1MnowVDv
X-Gm-Gg: Acq92OGlkCj/Ywake98DvNA4kllJ/pKSAC6OPXz76bk/eZztY/QItwdZOQcN/JxStVT
	u34MBKns56YKmJrcNlVRrbiuwRDbRALuoyDfFx/X8mQDqAAa2pFzGh+nC2rMp8G7Qi4VQA9L5jz
	PuL8Lxz8pYkKz0iTMZjE6qY/kmPUx9rYE/cuttn4KzaTh9+3NqgS0O/pVxxGtl3Vz75+jzITlJE
	Q8T1OgX2yToXiirM0OL6mB8UPaEQxh2jiejzC2HdDvKgaO/xFmF8/97u5c3xLNKCZrNKUWyLdW9
	RzEhz+5tQEudQCUICrWEuuiGuOjK5GgEA2NxhEM1ogGC6pJl69PdeGsSxSDGW1aK2CDWqbELtqD
	3Atesj52z9T3i7aHdtat1In66h6M8vRE9ju+HHjPtAs1eAxr54wckBotBMZbQXNAFqBpHdNw/W/
	cE3WPb0Ogkq9QES9lUxsjgK+XZXMQcwn9os1bdDTkaaqrcrDNwGPjtzQ==
X-Received: by 2002:a17:90b:5345:b0:35c:30a8:330 with SMTP id 98e67ed59e1d1-370ebff342fmr15636109a91.0.1780923029551;
        Mon, 08 Jun 2026 05:50:29 -0700 (PDT)
Received: from [10.125.192.72] ([210.184.73.204])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c1663981basm179520225ad.67.2026.06.08.05.50.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Jun 2026 05:50:29 -0700 (PDT)
Message-ID: <90730fa7-62e7-d5f4-b638-23b22a8509f2@gmail.com>
Date: Mon, 8 Jun 2026 20:50:19 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.0
Subject: Re: [PATCH v3 1/4] mm/zswap: Make shrink_worker writeback cursor
 per-memcg
To: Nhat Pham <nphamcs@gmail.com>
Cc: Yosry Ahmed <yosry@kernel.org>, akpm@linux-foundation.org, tj@kernel.org,
 hannes@cmpxchg.org, shakeel.butt@linux.dev, mhocko@kernel.org,
 mkoutny@suse.com, chengming.zhou@linux.dev, muchun.song@linux.dev,
 roman.gushchin@linux.dev, cgroups@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 Hao Jia <jiahao1@lixiang.com>
References: <20260526114601.67041-1-jiahao.kernel@gmail.com>
 <20260526114601.67041-2-jiahao.kernel@gmail.com>
 <aho7nepN5jZtKmef@google.com>
 <8c0e60e1-5713-69f0-a687-088c87e75764@gmail.com>
 <ah4ZZGl7GYJf54Wz@google.com>
 <ff344c9f-51da-8b3a-e7a9-c4a7f4702ef8@gmail.com>
 <ah9i3uhh3PFiS0Uk@google.com>
 <c7870fe2-3588-79db-cbfb-bd6a2b78f594@gmail.com>
 <aiBpibRNi0BcM1Zu@google.com>
 <9898f83d-fae9-e284-6b85-c7f4089840a0@gmail.com>
 <CAO9r8zPBH6-0SQ6-_ZOhTQeyu=rz4F=ugikCrU-JR_skm6fEWA@mail.gmail.com>
 <a60eedb6-f3fd-4092-b726-04a17a695ace@gmail.com>
 <CAKEwX=MQ3xXBAY-2H8vA+XSX5GHNBubJ2GCYAXGD+Hra++ZM7A@mail.gmail.com>
From: Hao Jia <jiahao.kernel@gmail.com>
In-Reply-To: <CAKEwX=MQ3xXBAY-2H8vA+XSX5GHNBubJ2GCYAXGD+Hra++ZM7A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: CD469160012
X-Rspam-User: 
X-Stat-Signature: 1jjhmcgorcrpjdr9pkhmww4es1pgjsrd
X-HE-Tag: 1780923030-102169
X-HE-Meta: U2FsdGVkX1/Br/t/FmriNhBcXfoLcBcKD9BwXp1AXrY5xXWCbCIGncEbJ73dargu+1lwjTgKdwJmazqGRE3mw3ZvaeiGFp1Fi6rkkpEJtQ4sIYcRTeWYWzUeUeCgZOLDMgGfXvFDReqDV/FPH9e58Rh1u5QbaxY4Jx+Ab11Z7TW5z997bDtzFdC1s5zgPJDHqJc60ob7iJeKEa4/BLkDI5X799ajgeyjNcAYCKZdmIx6sF32yfNy/dR+iHZwooW4/ZdIgzD9s73u6HQuEQsT+ZahVp20V2P0yvlrp+l439uwIWU1iB29bV2ACQydQj52GvMB/qImdbdywU6ivHxsTOGtGW1havgMea2uBzwy0Xu0JYD/cYV1hXj7CDeGhZJJN4VSBwRGjiT9iiNpffFjaj+ICfiR0JmUbD2CEHWiqW8vCOMXb4yOEjUcYfXbA9H6hG5JZZS73eAJmlbwTQsmZvJCmKX0DfJ8SkQW+BVSCbT02xd3G6Dih2KCFMtjSz0ZINXyV5zbzudIqCwx2V759YdD/b9/e/iQsRICDiEZ7mj6dBnmt7TAE7LmStub7+dIPKylz+Wi1BIFWq0sM2GfMpe/a6iZseS5wZb3f0KVs7oZ3K+UXxt4GkoBdztYfPW2LrDKUv1Cb93IO6W8hAnEKHFLrsxJI8PV0sP0HS9ehTgc0JAkKvAVnQNto7S2nUt7KNJc0kg2YVbw+2peqcRYFzCqVFPEpsLPAHdqusbRt9885kEJrScNIPzqNmsrJszOcqbbC/E96n7r7j46LdvuEGZgyEjPbA72O0g4WnxLeYj25aEEW8uG59j9z7yVLtx+/G7x8UEcLDPwg3dQJ88Ctt0BYTPrdclW81Zemk12giFf4ErcSbXHhNR5RiFak3jbVxLFeUQwkFp7F5n50JNHLfxEigcsu8Vh9Tfu4Vnnp9H5Ity8Dk4ULbjDMUrksyGbye7yvcMd/tIsL5XAVnW
 7pWbuG88
 O74AxeDKCyxHEum85mfxyABkBfl3K0CFYwcKf2ZCmUSC0MM1yY8kP7nG1JiVlP47xsCAfYbAgx3r8w0yaKShXgV7A6zF/pxlaKQvdaHTKsaAni+E3FmMZ7yoIV/9PxsABgUc+/Hocq2rYtp5+7GKUKpnipQkCMEAlICLrJioHYjkZCnsf+tJj1RDBtSqBqLuUCJFEemtLwZBIVwo/EckJLIrBa8eB774UEE24lE/aqz0qS6X7/yHtwQA7dbYHRcb1retG28EXzSWHkRa3nh+POJyrLTQeZt+wZ3KJxiYsbGKDL8a7FmoAlTgfpwVM59OXa7VSKnqgKyPpJ0mdOsBLmYY6+AUlulc9LPHrdy9JtovUCshGlTb1REdFl+W8m1eFC9u8mfAXDUPjenIyasQ1KFT4IU/o9CUqqjc3uP8Mi2h0dOm7aFUhV2ww0v67iQsaYVruPh1dd/PIobpzM4G7vgiXAMDuP8DAG1m00kUhJfZS4ydZwhnYWDakXdQy/nUnQHeCavGyiwCqr5XgiMkQPbEqNmCUkq+/LmSCukmTTj9zzhPJd48KUz/3llEmlEEwTUotsXT+KukdVuJgjGoAbVFk5sJobkkUET0PjSZqxSpqEw4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/6/5 01:23, Nhat Pham wrote:
> On Thu, Jun 4, 2026 at 6:06 AM Hao Jia <jiahao.kernel@gmail.com> wrote:
>>
>>
>>
>> On 2026/6/4 13:34, Yosry Ahmed wrote:
>>>>>> For instance, suppose a parent memcg has two children, memcg1 and memcg2,
>>>>>> each with 200MB of zswap (100MB inactive). Triggering proactive writeback on
>>>>>> the parent memcg will exhaust memcg1's inactive zswap pages. After that,
>>>>>> even though memcg2 still has plenty of inactive zswap pages, it will
>>>>>> continue to write back memcg1's active zswap pages. Writing back active
>>>>>> zswap pages causes the user-space agent to prematurely abort the writeback
>>>>>> because it detects that certain memcg metrics have exceeded predefined
>>>>>> thresholds.
>>>>>
>>>>> This will only happen if the reclaim size is smaller than the batch
>>>>> size, right? Otherwise the kernel should reclaim more or less equally
>>>>> from both memcgs?
>>>>>
>>>>
>>>> I gave it some thought. Not using a cursor could lead to unfairness
>>>> issues with certain writeback sizes:
>>>>
>>>>     - If the writeback size is an odd multiple of WB_BATCH (e.g.,
>>>> triggering a writeback of 3 * WB_BATCH), with 2 child cgroups, the
>>>> writeback ratio might end up being 2:1.
>>>>     - If a memcg has 5 child cgroups and a writeback of 2 * WB_BATCH is
>>>> triggered, it might repeatedly write back from only the first 2 child
>>>> cgroups.
>>>>
>>>> Although setting a smaller WB_BATCH might mitigate this unfairness, it
>>>> could hurt writeback efficiency. Let's just use per-memcg cursors to
>>>> completely fix these corner cases.
>>>
>>> Exactly, the batch size should be small enough that any unfairness is
>>> not a problem. I would honestly just do batching without a per-memcg
>>> cursor, unless we have numbers to prove that the efficiency is
>>> affected when we use a small batch size. Let's only introduce
>>> complexity when needed please.
> 
> I'm impartial towards the complexity of per-memcg cursor. I don't
> think it's that big of a deal, but only if it's warranted.
> 
> Hao, if you're convinced that doing small batch is not efficient,
> could you run some experiments to show the improvement bigger batchign
> and fairness? Maybe implement a small batch, no-memcg cursor first.
> Then implement a patch on top of it to add per-memcg cursor, and show
> how much performance win we can get from that patch on top of the
> patch series?
> 

Thanks for the suggestion!

I ran some tests and found that neither the per-memcg cursor nor 
different batch sizes have a significant impact on proactive writeback 
performance. However, exactly as we suspected, without the per-memcg 
cursor, the writeback distribution among child memcgs is highly unfair.

Test Setup:

   zswap config: 18G capacity, LZ4 compression.
   cgroup hierarchy: 1 parent test memcg with 10 child memcgs.
   Allocation: Allocated 1600MB of anonymous pages in each child memcg. 
To ensure compressibility, the first half of each page was filled with 
random data and the second half with zeros.
   Force to zswap: Ran echo "1600M" > memory.reclaim on each child memcg 
to squeeze all their memory into zswap.
   Trigger writeback: Ran echo "<size> zswap_writeback_only" > 
memory.reclaim on the parent cgroup 200 times, with a 2-second interval 
between each run.
   Metric: Monitored the zswpwb_proactive metric in memory.stat to 
observe the writeback volume.
   **Note**: The size here refers to the uncompressed memory size. Also, 
since the second-chance algorithm would cause many writebacks to fall 
short of the target size, I **bypassed** it during these tests to avoid 
interference.

Without cursor (size: 1M, batch: 32)
   child        wb_pages        wb_MB     share%
   child0           6368        24.88      12.50
   child1           6368        24.88      12.50
   child2           6368        24.88      12.50
   child3           6368        24.88      12.50
   child4           6368        24.88      12.50
   child5           6368        24.88      12.50
   child6           6368        24.88      12.50
   child7           6368        24.88      12.50
   child8              0         0.00       0.00
   child9              0         0.00       0.00
Without cursor (size: 1M, batch: 128)
   child        wb_pages        wb_MB     share%
   child0          25472        99.50      50.00
   child1          25472        99.50      50.00
   child2              0         0.00       0.00
   child3              0         0.00       0.00
   child4              0         0.00       0.00
   child5              0         0.00       0.00
   child6              0         0.00       0.00
   child7              0         0.00       0.00
   child8              0         0.00       0.00
   child9              0         0.00       0.00
Without cursor (size: 6M, batch: 128)
   child        wb_pages        wb_MB     share%
   child0          51200       200.00      16.67
   child1          51200       200.00      16.67
   child2          25600       100.00       8.33
   child3          25600       100.00       8.33
   child4          25600       100.00       8.33
   child5          25600       100.00       8.33
   child6          25600       100.00       8.33
   child7          25600       100.00       8.33
   child8          25600       100.00       8.33
   child9          25600       100.00       8.33


With cursor (size: 1M, batch: 32)
   child        wb_pages        wb_MB     share%
   child0           5120        20.00      10.00
   child1           5120        20.00      10.00
   child2           5120        20.00      10.00
   child3           5120        20.00      10.00
   child4           5120        20.00      10.00
   child5           5120        20.00      10.00
   child6           5120        20.00      10.00
   child7           5120        20.00      10.00
   child8           5120        20.00      10.00
   child9           5120        20.00      10.00
With cursor (size: 1M, batch: 128)
   child        wb_pages        wb_MB     share%
   child0           5120        20.00      10.00
   child1           5120        20.00      10.00
   child2           5120        20.00      10.00
   child3           5120        20.00      10.00
   child4           5120        20.00      10.00
   child5           5120        20.00      10.00
   child6           5120        20.00      10.00
   child7           5120        20.00      10.00
   child8           5120        20.00      10.00
   child9           5120        20.00      10.00

Thakns,
Hao

