Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E740FC53200
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 05:59:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B008B6B008C; Wed, 29 Jul 2026 01:59:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8A7C6B0092; Wed, 29 Jul 2026 01:59:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 951F56B0093; Wed, 29 Jul 2026 01:59:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6D5696B008C
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 01:59:40 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0B672A0573
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 05:59:40 +0000 (UTC)
X-FDA: 85040762520.26.EEB8D09
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	by imf23.hostedemail.com (Postfix) with ESMTP id B75E5140004
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 05:59:37 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=c0uZa9Ju;
	spf=pass (imf23.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785304778;
	b=TgEwyIYo199klvV97H+YD+ihgbY6TVNiz/pZYEuDfCM/7oEYIYpcVZTypO7jjJK47X1Vqo
	J2o5UjjSlZHbpkJ5cRrUV4QtjjRbBvYiRWdxPnI3UO2/gLgUw8J5ZdvKmzoor8Vka+4eLk
	a3eYgyFszDHprovlkMyswURJIo0KGIY=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=c0uZa9Ju;
	spf=pass (imf23.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785304778;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nh9P/FxHkvTjdaHZyx9SWlPOELOUresg7sNd6fW5k+o=;
	b=YlwQlRbF8FR4Uepb/PyPYi52q6clOR5daPc/GRYgJarXe/bLqF9oyxvZml7AsIBYSw6saB
	IF88eIVDPP8ptzP79iYT0s03WqQTLVEO31lURNvFiqT0I8iZlkI6NSNpgd1R7IZm1XKgU3
	FwPEwXGmNcgY2XhVgPSFyMF2oXWfrgY=
Message-ID: <93f5a87d-bf82-4b56-a778-a39d03ba4e3c@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785304775;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nh9P/FxHkvTjdaHZyx9SWlPOELOUresg7sNd6fW5k+o=;
	b=c0uZa9JuXoZhW8DQ4+rotcSAIpNKliQLTVni8KYRqiL1Y0tLO6LMxjF9sLzGGzXhvwGtJ+
	D+lxDHAvMO63pTpKgNVmO+6aH+YtYnvBRcQsD7+Yz1XDAm/lYbXZuRHOjnxLAiejiZzxRl
	y1YA5EinoFzuYnZRELCWGwhZlssRqxM=
Date: Wed, 29 Jul 2026 13:59:18 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v2 2/2] mm: shmem: make unused huge shrinker memcg aware
To: Baolin Wang <baolin.wang@linux.alibaba.com>, hughd@google.com,
 akpm@linux-foundation.org, usama.arif@linux.dev,
 Qi Zheng <zhengqi.arch@bytedance.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <cover.1784621804.git.zhengqi.arch@bytedance.com>
 <889581093179462979dbfb5458620fcca531787b.1784621804.git.zhengqi.arch@bytedance.com>
 <313c4dc7-9d03-40da-b6a0-170a774010b3@linux.alibaba.com>
 <a0b029b7-6ab8-4886-a26e-e52cec31a8e1@linux.dev>
 <c169c4ec-adc8-4991-a690-ed5bfb4796a0@linux.alibaba.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <c169c4ec-adc8-4991-a690-ed5bfb4796a0@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B75E5140004
X-Stat-Signature: gyj9hhtceukb8eahziiqrp4wrizqoz7j
X-Rspam-User: 
X-HE-Tag: 1785304777-752277
X-HE-Meta: U2FsdGVkX183pnfdqfpoKOgvDExaA/o/HqePR+ClAab8t3r+YEcw2oUVULlT0CkMOtTMSKnh27UFRbYFvmLWMK2ZoAoSiXW5PNTCEQ6C7upS7LlM4NKc8JmXcuUmbpSVjbjamAfZLAg3JEitlvHQ7BMGyN8gUn2inhQdVslWtcWwNH5mCEFJ9F7oxj8Etuc86oY4m3OUbW/JKdUcyxt5oH+co3KMAoZdrxNP4dOF8enO5kV9XAUm9xsDqQR8inmePVKryOBw7m7xZ4iWHhMLIF4BEtDglrShQnh5a/wncNI/Dhsk/OlzsdbdaH+TaFXIIZg4DXDvl9CwxXMb/95lGiG7l/qwZLZyMJ6+jY3F0VFhaGD3vSkDJWHlOsmVtWNI2rgSOBgbDT2ZHjK8TZF8ObTF7plPTeTnpxcprpkm9DSiw8qmKB7h24isGmXKwFGCy5KSq+D73Ycvpx8Y27exjRacBLvgRtYDutkC9djLiep9zvLBTbWsmAzHC0zel7eu+WoSoTDCh2EoirLJ974IMV4J4VGmsmYzLrN1w/v0pdEMOL+ovzYSN/GQlR0jXqaITYRgyYUfUIJKe7TJUY9t30TAYPgg/RqkGXtA0THvioAQSLQNvQWtijCjYZSZwe65Q7RMNZqgCd78RWuFi8bc6DrXH98rXKvheaJ3yJBUtSDkUPfTRVd/m8Qk6AbpPNNgjBTf9l2iXgsDTvB1k1mv+JB7KGKIGOah4X/5YsOSjl64NQivhmp3E+fj5APIOLmEEPCB+XMdJDBnYNmvilHcLpxTBy8040IXBDJmR9gn08f9JAhobQDTftxgoANsLKji1Lq0c50rdfzBk+WQHJghYClVRmRuH5EByCwWHxCzzw0qMQ7oqcaO58vCT28CqtZvqgdorO1wjnwizYaRREaOjjz3xWARuqDSHwfejj8WPz/Ho40QLQqlPvKxmhDpib2P4Bh9xhI0b0fHzonvBMV
 0z0+yD9N
 exCdZheXBOEIlMjEmocHc1YAQo4y2EU7tMXTnmtl3fkaWgQcd4Tvem8XSNCzPt3Sb8ZXcDQrz/cpHu8/xWC32ENK2+CYO3C3/MsmXiO7TljIsUl3ZSRrTvyO7K009UYhd/sz8Yka2C5Ky1FpOBQl4MnNCT5l/7IqF2SylSI56W9r2eTx4cO6dqYJN584B2WIrUQyhXOblyl+M6GgIQwKFKLC7BFs/M/0nRhRxP9giWo5VxOY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Baolin,

On 7/29/26 11:29 AM, Baolin Wang wrote:
>>>> @@ -2532,28 +2727,6 @@ static int shmem_get_folio_gfp(struct inode 
>>>> *inode, pgoff_t index,
>>>>   alloced:
>>>>       alloced = true;
>>>> -    if (folio_test_large(folio) &&
>>>> -        DIV_ROUND_UP(i_size_read(inode), PAGE_SIZE) <
>>>> -                    folio_next_index(folio)) {
>>>> -        struct shmem_sb_info *sbinfo = SHMEM_SB(inode->i_sb);
>>>> -        struct shmem_inode_info *info = SHMEM_I(inode);
>>>> -        /*
>>>> -         * Part of the large folio is beyond i_size: subject
>>>> -         * to shrink under memory pressure.
>>>> -         */
>>>> -        spin_lock(&sbinfo->shrinklist_lock);
>>>> -        /*
>>>> -         * _careful to defend against unlocked access to
>>>> -         * ->shrink_list in shmem_unused_huge_shrink()
>>>> -         */
>>>> -        if (list_empty_careful(&info->shrinklist)) {
>>>> -            list_add_tail(&info->shrinklist,
>>>> -                      &sbinfo->shrinklist);
>>>> -            sbinfo->shrinklist_len++;
>>>> -        }
>>>> -        spin_unlock(&sbinfo->shrinklist_lock);
>>>> -    }
>>>
>>> Why move this additional logic down?
>>
>> Because under the following condition:
>>
>>          if (sgp <= SGP_CACHE &&
>>          ((loff_t)index << PAGE_SHIFT) >= i_size_read(inode)) {
>>          error = -EINVAL;
>>          goto unlock;
>>      }
>>
>> we will jump to unlock and remove the folio from page cache.
>>
>> With the new memcg-aware design, shmem_unused_huge_add() takes a memcg
>> reference. If the folio is then removed by the error path, the inode
>> sits on the shrinker list holding a stale memcg reference and pointing
>> at an i_size that no longer matches the folio.
>>
>> So we should ensure the inode is only queued when the folio is fully set
>> up and about to be returned successfully.
> 
> Right. But I think this deserves a separate preparation patch with above 
> explanation, moving the original shrinklist addition logic to after all 
> checks are completed.

Agree, will split this into a separate preparation patch.

Thanks,
Qi



