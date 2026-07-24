Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84297C531CC
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 02:21:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 652FB6B0092; Thu, 23 Jul 2026 22:21:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 603F06B0098; Thu, 23 Jul 2026 22:21:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 519666B0099; Thu, 23 Jul 2026 22:21:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2B85E6B0092
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 22:21:03 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AC8C74026C
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 02:21:02 +0000 (UTC)
X-FDA: 85022067564.30.C52180A
Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	by imf08.hostedemail.com (Postfix) with ESMTP id 00F20160004
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 02:20:59 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="MF/5NYKf";
	spf=pass (imf08.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784859661;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p3F27zBrceeZbGaaILb47jwwDwAQwrNTSWn2X4PwsM0=;
	b=8SkFJhfrcvM/1eP5v0ACmZMvx8COnJt1Flf+MnSgmH1p86YTQMZzdIX88Vb/829/PjRFMj
	vrwSYIMCv5cv28Ce98WyF1saSNJP+3af6T42Tq8h+g3hSbpYQi3VWjRSfzTNM2GYQGbBL5
	qrvM/JmuBgO2OWcs2DtZHhPQklmGL5M=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="MF/5NYKf";
	spf=pass (imf08.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784859661;
	b=SLPz0P5qqG0LyA5q4xj9cVNPpjkEiZp13TobkO5barK0gUwRryRuyARh48vEIJJEufn64K
	M3OFXBnf998iGw4Emv1IZzMszJvpERDrZzVYKMeBHFjDqRNNSuux65X27JJ8JLZAwZheu+
	Uxa+dEihSvEN12zwSR7Ahv648s79F94=
Message-ID: <5b26565b-300a-498e-afb3-e5ee1d7fe84b@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784859658;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=p3F27zBrceeZbGaaILb47jwwDwAQwrNTSWn2X4PwsM0=;
	b=MF/5NYKfUFVC4TwZgMWGbDo3Xx1CUS/Z+8ZSw3ZSegNIJ/W0PAFnzElyNINp3EfbSW8A2V
	g+9gIXC/pmcMI0l/Vk3vsqpOW70OPx9hC5c/spOwDjKsWLbtvdd2RUh2FVLJCM4ys3nqrc
	O2yhdJkpdQdXyrHGvNSAMH598aQOjio=
Date: Fri, 24 Jul 2026 10:20:40 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v3 4/4] mm/mglru: fix anon-only reclaim evicting file
 pages when swappiness=max
To: Barry Song <baohua@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>,
 Michal Hocko <mhocko@kernel.org>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 Kairui Song <kasong@tencent.com>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Zhongkun He <hezhongkun.hzk@bytedance.com>,
 Muchun Song <muchun.song@linux.dev>, Davidlohr Bueso <dave@stgolabs.net>,
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Ridong Chen <chenridong@xiaomi.com>
References: <20260723045718.2052070-1-ridong.chen@linux.dev>
 <20260723045718.2052070-5-ridong.chen@linux.dev>
 <CAGsJ_4wtcP87bTPmm+aQ3pxn4eLW7KqU-0DJhBF639Muc2xzjg@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <CAGsJ_4wtcP87bTPmm+aQ3pxn4eLW7KqU-0DJhBF639Muc2xzjg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 00F20160004
X-Rspamd-Server: rspam01
X-Stat-Signature: ri7epoccmwq9pgs1kgnarczjb668dkxz
X-HE-Tag: 1784859659-796908
X-HE-Meta: U2FsdGVkX1+SEWlj6Y6jW7EIZuCzjvI+XM8adDkZty8Y9LB6qUKQsk+AUcCBjPBfKDFLmW9YKp4l+8zvaP24viKKDnmJhnypLMXaWz5ZT+F5DOHaDF5Kn+xISHOpRH/gH9JkRQnNbOaUmWee+BesAq0U5EYRkYoSCanh4kZFW1HG2ruVg0/N14Ym9F91AXkKNnjjCM79uODVzJhDIaQo+6+omBnijTuyiB6RGn5/BkUXDHd8ZIqXMnIva3lxRuPDe9u4xqAteAjGFr22TXJUFhkRwh6fcGX0JRrQesinobb60o9E0+w9qm1opPylJ/FS2XNQ45CXpYMZ3up+FygcR06cQCgO/v1w3qRemw2BqZrfBBWqba8LDd6Tvg+aGXqV4Q97phhyV2xjQVOWrN7ac3AsI0RgugLDsRLGIJj+o06P6gspI/ExldNz+1y2LiKF4kqZoUg62wBUIiDmTEgc/phQTXi/Xr1lYvJBc3pCyc74I/V7wLb5eYb8iBMwazE5MdyXOKaSPIB8MSwx20xChPzIIk3GeA3oTyas6rGOJZS7Oqio0CYSDkRyXEideVhIQhQm+2JBCQjT/n2LkjLap4xtWSSHK5ZFo/x1iIRkf4kcQaubNmOe2BX+y3xvWdLKXCxaI0N/rb/b2ZDtD7U7BnE//aRa7y+kWfH2eS98MKzei63bDlLhRX2tOPhtTrlbMOE7GZVZFcGSPrY9DgYq4uv17Ok01UaXOGPLY0bhOvNd4+QbaYth4Vubf/RYoOnfqGhl78RMz4q89lz1O3dUJAWZqF8B0ZXEceKoNEzS3rRwBci4aOrfvii7lQwBxXt8hCk8BfmLok+Vs+aFd1lsOLphLVgewiAZPnQPQFz+T8bWpCYPdf1PSRNuN6n5YN+G4Jtqe+l4dp5ToBpux926S+D4NX0dJXN8UUX85WMtiV/kpw4E0RWbhY43HFVbWSSX12L5poax9kkCUNVOK1/
 xai1qboz
 BuI5v07WVQPVaVG4VI9jgLEsorOOUCE95+QeiJWgfSW7FSiQQdzwm48Gfd+nQOjcsc5baznfYGJOLdWZER6S6m2yRU0PkJyfEfF9dDUO2G1wibdvZd51pHb+v1ZUVr3DA3rC4AA9Uqqhcx/yqzExnfDTM60GrbFh086Fn2+vzQKesnx+YVTC9ChRdOO9ZCcUuc6LFofnvUNuirsijLWqsZv0Unx6v+LFn5sV10+A+6un04EA2m+aFXoxfjHwsgYoNrexi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 7/23/2026 4:57 PM, Barry Song wrote:
> On Thu, Jul 23, 2026 at 12:58 PM Ridong <ridong.chen@linux.dev> wrote:
>>
>> From: Ridong Chen <chenridong@xiaomi.com>
>>
>> The previous patch fixed this issue for the traditional LRU. The same
>> problem exists in MGLRU [1]: when swappiness=max (SWAPPINESS_ANON_ONLY)
>> is set, reclaim is expected to evict anonymous pages exclusively, but
>> file pages can still be reclaimed when anonymous pages cannot be
>> reclaimed (e.g. no swap and no demotion target).
>>
>> With SWAPPINESS_ANON_ONLY, get_type_to_scan() always returns
>> LRU_GEN_ANON and for_each_evictable_type() only iterates the anon type.
>> But if get_nr_to_scan() does not bail out, evict_folios() still runs and
>> isolate_folios() falls back to scanning file pages in the !scanned case:
>>
>>    shrink_one
>>      try_to_shrink_lruvec
>>        get_swappiness   // returns SWAPPINESS_ANON_ONLY for swappiness=max
>>        get_nr_to_scan
>>        evict_folios
>>          isolate_folios // falls back to file type when !scanned
>>
> 
> I am not convinced this is correct. Although we do have `type = !type`,
> when `swappiness == 201`, `for_each_evictable_type()` stops iterating
> after trying a single type, so there is no opportunity to fall back.
> 
> #define for_each_evictable_type(type, swappiness)                       \
>          for ((type) = min_type(swappiness); (type) <=
> max_type(swappiness); (type)++)
> 

You're right. In my initial version, the intention was to bail out early and 
avoid unnecessary work.

I recall that during your review of Kairui's series, you sent a patch that used 
a fallback mechanism with type = !type. I was thinking that this could become an 
issue if we call isolate_folios() when swappiness is set to max.

> So I'm really curious what's happening here.
> 
> static int isolate_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>                            struct scan_control *sc, int swappiness,
>                            struct list_head *list, int *isolated,
>                            int *isolate_type, int *isolate_scanned)
> {
>          int i;
>          int total_scanned = 0;
>          int type = get_type_to_scan(lruvec, swappiness);
> 
>          for_each_evictable_type(i, swappiness) {
>                  int scanned;
>                  int tier = get_tier_idx(lruvec, type);
> 
>                  scanned = scan_folios(nr_to_scan, lruvec, sc,
>                                        type, tier, list, isolated);
> 
>                  ...
>                  if (!scanned)
>                          type = !type;
>          }
> 
>          return total_scanned;
> }
> 
> since both min and max types are anon:
> #define min_type(swappiness) (!(swappiness))
> #define max_type(swappiness) ((swappiness) < SWAPPINESS_ANON_ONLY)
> 
> I guess the real problem only occurs when `may_swap` is false?
I added some trace logs to verify this behavior. If we don't make 
get_nr_to_scan() return 0 when swappiness=max, it won't fall back to scanning 
file pages, but it will still perform useless scanning that yields no reclaim.

Log:
   # echo "64M swappiness=max" > memory.reclaim
   [   78.914972] vmscan: in isolate_folios swappness 201
   [   78.916841] vmscan: call scan_folios type 0
   [   78.918311] vmscan: fall back 1  <-  can't call scan_folios, loop ends.
   [   78.919479] vmscan: out isolate_folios total_scanned 0
   [...]

   # cat memory.stat | grep proactive
   pgdemote_proactive 0
   pgsteal_proactive 0
   pgscan_proactive 1808

I will update the commit message to clarify that get_nr_to_scan() returns 0 to 
avoid this useless work.

-- 
Best regards
Ridong


