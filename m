Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06FE2C61DB6
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 09:06:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 20C936B0088; Tue, 25 Aug 2026 05:06:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BD316B0092; Tue, 25 Aug 2026 05:06:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D3A76B0095; Tue, 25 Aug 2026 05:06:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E0F516B0088
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 05:06:46 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2ABF2A36CB
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 09:06:46 +0000 (UTC)
X-FDA: 85139211612.08.BB8EF4F
Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	by imf28.hostedemail.com (Postfix) with ESMTP id 340ADC0007
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 09:06:42 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=q0bICao7;
	spf=pass (imf28.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.98 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787648804;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6GiVTcUoBcFpdAwmhaGD/yA7QuBQ8y/b4/H/dtTDhjQ=;
	b=L2hH4M/FOKX80io9JV6oANbmheb8tiSo92QYSnunx265kspOhwAYjYYpN+WyLLjDosNftZ
	6aHN72M0kRT0KmEjgJP4FlqpdKCD6qcxZDVqdkFUx9MLH4gbji2RhuPcw5tnTRbXh2CX9w
	GjKFVh9rq+bw7FPEbFx53dAbqFg4LJw=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=q0bICao7;
	spf=pass (imf28.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.98 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787648804;
	b=7PTsJMuJNsSmGjsF1HtoVnKUhuQWsb3hxQZK1Vt4hCCjOjp3jHzvZboMxTBuKKxYUsVgKJ
	MdTjAmMvpy+2KYwlETrXsvy1y9bHR8j3wiJCP8S9xtnmeeYb5czIy1j/0wm1yCwv+xvUf7
	edgf8r7jidKEgUjfJjntBAfiW3C+tWY=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1787648799; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=6GiVTcUoBcFpdAwmhaGD/yA7QuBQ8y/b4/H/dtTDhjQ=;
	b=q0bICao7cIUSDPn91uJ7oOZFr+YVIjinTKKKEhZkmsYQ0/D5vpSg1zRwx9w5LogzQY/lUQjWtqr2mU8EfmGkhDscPZN8QS3yPtf5NKE50NoYG2Xv94ZZO+gF3fu8BSjmbp6dqke24txXHxRFA/msRxuLvnnMi/UOoHiOrJrcSRc=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=20;SR=0;TI=SMTPD_---0X9dMVJl_1787648796;
Received: from 30.74.144.118(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X9dMVJl_1787648796 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 25 Aug 2026 17:06:37 +0800
Message-ID: <56b8e283-f849-4fd7-9c2a-64b604176a82@linux.alibaba.com>
Date: Tue, 25 Aug 2026 17:06:36 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/3] mm/mglru: clean up isolate_folios and scan_folios for
 readability and clarity
To: Kairui Song <ryncsn@gmail.com>
Cc: "Barry Song (Xiaomi)" <baohua@kernel.org>, akpm@linux-foundation.org,
 linux-mm@kvack.org, axelrasmussen@google.com, baoquan.he@linux.dev,
 chenridong@xiaomi.com, david@kernel.org, hannes@cmpxchg.org,
 lianux.mm@gmail.com, linux-kernel@vger.kernel.org, ljs@kernel.org,
 lyugaofei@xiaomi.com, mhocko@kernel.org, qi.zheng@linux.dev,
 shakeel.butt@linux.dev, stevensd@chromium.org, wangzicheng@honor.com,
 weixugc@google.com, yuanchu@google.com
References: <20260820045603.68809-1-baohua@kernel.org>
 <7e897a4e-2075-485a-8cc5-5bb928fba437@linux.alibaba.com>
 <CAMgjq7DFpKU=QdT4QNAREL8oLg-OAxM6zMcYkCECBVg=U5ECsg@mail.gmail.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <CAMgjq7DFpKU=QdT4QNAREL8oLg-OAxM6zMcYkCECBVg=U5ECsg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 340ADC0007
X-Stat-Signature: tpz5d6oyfurq4banrhxry86ghy6hw11g
X-Rspam-User: 
X-HE-Tag: 1787648802-365118
X-HE-Meta: U2FsdGVkX19+WTweT1R/r8kGS6DT1zVngKlIIxLa/dr4AkysqlNLzBMD5eX/1fOnCbYxj5IOHn2UnZ+YFIlOjvml6gaiuUc8JO4+7BSdLwk8FweQC8hNy8rHp8lpfF5j7sS6eBClkGKTPIzVOCf2y+8Nv0EgapQm2GTf9LICAfh268iT9B1cXi1h5ee8k5FhLxbs/w07ZYPYFD83rfCjwwdFB7qZDE8suplxydzezLZEEs/lj+w/qKJ/OApx664w2XXbbvX2hIxEikfwkPKUd44BoDfTj9Neu27zYhibDWvSL6b+TLtrgf0AfCVMMSBIyWGitUg8Uyldgpqe53T00jm1CCEyYnYtMkAx1e3L0aixpGIgTs6jAQ0ssf1pe3e4MrMQtHB5QXGWIg1+Xp7fkKxscw+US8RsjCKCMp/G6fp6yE2Vsiuq7nZojD3+lWaQwBcGL9aSwJNuSzQ9YV77N8/QdyWlqHZhnloJchh7UwPDC9oYPxfaAUEOAsPHO4E8xmiBvMLBZUvCeCjMjw+ppQnTjpiUpulGbscY2U8+/IqFqYAQs3FcMVoDO118UezpA6Zv4tJGN8onl3tRIi7Yl97pjAiFNLpIi5Pppc6xrFxFfnHX/eeDsV2VOgGqtzgMto26W85vw8ihp2N8SLvAp+JS0Z0aEoS06FAjlzT2f9DcZ7kbL4llUH8UySXYnGcXIOpp9ptPl0Y2Je1pm2AsKjMBqBREKFy4YuombILOJdTWSkJsUAROrKl3xdvhkRwWUoBahwT18ge5BVSKw8tC1CkVeCQT7DKAkCVBQhmN0sEzDQ9yMqm4kQFGRP/AphN7uWJlJvm+pHiLv0uid3MqvYywcqTwpudw7urJx/TjaKjnugChHezsWq3q6RzsxC2bZhlLEzyT9eLokmjYDelh/jRO/iFC0wYGvkfvucIFI5zyKXTnXukjJXunG/KUiognSkU896jyL53710dWC70
 dE51HzmB
 fnY7n6o+9o9DyCDcaX2ittdVlqcYnxZ7MXEfBrxShLKI+SHa2ZetgLZwBOjmOTSXUqouvd04sBhEumPkmcdogXJRuJPyojsx/FLxhyKx6cqkdW3iySbiZ7LCVZ/++Q3gfk6cysiLO42gwHrlsXSii3ktnN2FpJhiwbt6OQx2Mqyl+0PD7x+l9YLtiT8qEkpYGTgFKRhCwiJ7WxtOW2JxS8r88l3vqHrZY0lHWhQa1mPRUcOpKnHPHjD1P5hGZKFQh8v1o5GZyNmDyH2IGYnTrTjSg47baDLs9vj5fjZx/TJULgGW/KWGE2dzS1tMSDT8P3cJH8yV9GK4GYQ8w85KbStORSVvw3gSVcIZTz3/LIeKuTYrRniTMS3dcQc8mZw+XMYwkDcRh2/sjNji96amG/5klXoiKVROo/wK7V6AyKLWlkXzr3iclqjCxpaXjxsqTjE7gTUQC68700fsHrQdTaL2HIFru6VW1Fac9nmbziJwMofM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/24/26 7:05 PM, Kairui Song wrote:
> On Mon, Aug 24, 2026 at 3:25 PM Baolin Wang
> <baolin.wang@linux.alibaba.com> wrote:
>> On 8/20/26 12:56 PM, Barry Song (Xiaomi) wrote:
>>> This is a cleanup series split out from the MGLRU swappiness series [1],
>>> with the cleanup changes separated to make them easier to review.
>>>
>>> Right now, isolate_folios() is quite difficult to follow:
>>>
>>> 1. It uses for_each_evictable_type(i, swappiness) to iterate over the
>>> types, but i is not actually used as the type within the loop body.
>>>
>>> 2. It uses scanned == 0 to detect whether the current reclaim type is
>>> exhausted, but this is not an accurate indication.
>>>
>>> 3. It has an internal retry when no folios can be isolated after scanning
>>> some folios, but the retry is implemented in a way nobody can understand.
>>>
>>> This patchset makes these behaviors explicit and much easier to follow.
>>>
>>> Run kernel builds for several rounds in a 1 GB memcg and take the
>>> average build time. The patchset shows almost no performance impact,
>>> with a very small improvement that could simply be noise:
>>
>> Just FYI:
>>
>> I tested this patchset with a 3G memcg limit and a 10G zram device,
>> running 'make -j32' to build kernel on my 32-core Arm machines, and got
>> some performance improvement for ths sys time:
>>          w/o patch       w/patch
>> sys     1845s           1570s
>>
> 
> Hi Baoliln
> 
> That's a very interesting result, can you share a bit more info about
> it? e.g. vmstat? I'm curious how this happens.

Sure.

> I suspect patch 2 or 3 changes the swappiness / reclaim / aging type
> selection behavior, or maybe it reduced the reclaim amount?

I gathered the memcg stats as shown below.

It looks like the direct reason for the performance improvement is an 
obvious reduction in anon refaults, which is what this patch aims to 
achieve I think. That is to say, we should respect the type chosen by 
the PID for reclaim, and try to exhaust that type before falling back to 
another.

Before this series:
workingset_refault_anon 59706846
workingset_refault_file 9229283
workingset_activate_anon 15108561
workingset_activate_file 365660
workingset_restore_anon 15108561
workingset_restore_file 1018493
workingset_nodereclaim 0
pgsteal_kswapd 0
pgsteal_direct 92589340
pgsteal_khugepaged 549
pgsteal_proactive 0
pgscan_kswapd 0
pgscan_direct 456629355
pgscan_khugepaged 549

After this series:
workingset_refault_anon 41277086
workingset_refault_file 9131522
workingset_activate_anon 12924656
workingset_activate_file 345901
workingset_restore_anon 12924656
workingset_restore_file 1005959
workingset_nodereclaim 0
pgsteal_kswapd 0
pgsteal_direct 71723800
pgsteal_khugepaged 4013
pgsteal_proactive 0
pgscan_kswapd 0
pgscan_direct 342179445
pgscan_khugepaged 9311

