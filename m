Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 883FFC88E6E
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 08:24:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A045B6B0088; Mon, 14 Sep 2026 04:24:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B3FF6B0093; Mon, 14 Sep 2026 04:24:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8CA6D6B0095; Mon, 14 Sep 2026 04:24:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5A8946B0088
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 04:24:40 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B2FA81A1250
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 08:24:39 +0000 (UTC)
X-FDA: 85211681478.04.33F937D
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	by imf13.hostedemail.com (Postfix) with ESMTP id A207820008
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 08:24:36 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Aetva3ez;
	spf=pass (imf13.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789374278;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RGqO+hBo0WhYu93b9+VGZ0mjT1O3ougoY7v9LOHt4m4=;
	b=WeACHXoNW62qv/6qqybDsGVqw8ZaEuwoJgEdivL0qIIeKYVFd59KlE91ssz+SPq0v9EC7U
	fhLx40bKtPCQR60DiYy7MK7zGZLP9NclQYgqXojESf14GMCTlyUHKkK51JzJEfUCtn67J5
	cSSI/5XxnBazBFJruy3xurEmcXF5ZGc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789374278;
	b=w5fPG4rFU0h/bJ+rkJ06lZgbjRRTpbxA5SDi3oYL2pl+2bpjxRGAj6eX3tgYA3vBtkvlPG
	u2aWKsWktQgz99mf3Tw8UD1JdkmENT2JDG56W0quyiubXb2wAwdsgu9yTkM7ZzRQnXPD+n
	lkTR/68vCv1LGxiaL8syWRApsmoBq04=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Aetva3ez;
	spf=pass (imf13.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1789374273; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=RGqO+hBo0WhYu93b9+VGZ0mjT1O3ougoY7v9LOHt4m4=;
	b=Aetva3ezkkks7mbACr8mpS4VY8Z91Au8clXnRQk7tW6myyfcZ1ELyzWhTqUFzJDSPsBQVo4CsAlimuBDDbXvkUDsLq6OAHoryhdP9ENZZH8tjoySuMDRYbyaGKSoVPggYArwDwnv+zmKjtUg9Y0dn21l8XYVOUT63ukkz+WJN3M=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=16;SR=0;TI=SMTPD_---0XAtcNCT_1789374271;
Received: from 30.74.144.134(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XAtcNCT_1789374271 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 14 Sep 2026 16:24:31 +0800
Message-ID: <b5263014-23b7-4e8c-9bd9-18198409d0f1@linux.alibaba.com>
Date: Mon, 14 Sep 2026 16:24:30 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-new v2] mm: mglru: clear the reference counter for
 rejected folios
To: Kairui Song <ryncsn@gmail.com>
Cc: akpm@linux-foundation.org, qi.zheng@linux.dev, shakeel.butt@linux.dev,
 baohua@kernel.org, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, hannes@cmpxchg.org, david@kernel.org, mhocko@kernel.org,
 ljs@kernel.org, ridong.chen@linux.dev, baoquan.he@linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <9214e36bf738fcfba86acc8cea85dff4010f66b0.1788918714.git.baolin.wang@linux.alibaba.com>
 <CAMgjq7DdF_fi_MserE_P_AbKR23mrqPLZ-VD71eXH6iv1ncdzQ@mail.gmail.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <CAMgjq7DdF_fi_MserE_P_AbKR23mrqPLZ-VD71eXH6iv1ncdzQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 5etriggjhfg9y9yptk54hug6k1zzieee
X-Rspamd-Queue-Id: A207820008
X-HE-Tag: 1789374276-290511
X-HE-Meta: U2FsdGVkX19OvtTQl2KtGVxJEY81IsYDYbiThTgjuByOlxLm3EpSPUJSLsmi/AH+ethjyh/+JDkWAN+AlftvvHEhPpe7eA+9Cc/SnOHEZ2yUFKWSsgPfilpsmL/bhlGZxPe77FiqnUdyz71S7v/8n0ymsqhpmVq2WwwfDe+wKbULD6zhaocimNF5svLfCLeH5S+1fIFPi2ylxkObFCsdAbDDG1MXljqtbqHZxt9GdZ8i1l9/cBs6ZP5HfZ1YkeiHJY8dcfa1Hb87SdcWXrssPKGEX1jGqDipxh1VDbwKf/qI76k/3W4w8TFIoe0+NdEvIwntc0eDMe/qwNwGGhbPb7/TGC2qPvat/hqL7TWCPhwGrSadqArzAbXfXJJ4W7ol0nhiO2DqHtaNpZu6v80fGCAQx13bo7XdIsak6d5qKsi+1LjyNfYz062+DRZgbgW7fG+EJPPMwhcPb70HoL6VGi4pj+1MeV4BT2+Z+iKAwZUsf1KyTYSOgGYpoE5Vo3LL8ipgVMyjE7LyZx2+rOhI2XkMFqyQ2fgUGyvOEdg6dhKLLDoJudR4FKiNnlR+My3fVbn7eMst9T9Ad53zsg9fhtqng/uZwJu7QcjLHaQd5xbnK54Y+nHk/KL6PyuTPIipwpLRG2f/NdiR68HMMVAsN0PTnDihfJ9hUZpyz0K3cD0CRoL4fUzyyHdZ9z0abylCvCfOWkNvlY099ua6aGrhuGR8dsrU3gIvVWWM2ymfgAGmj2U/SpmU1/JKRsGpDsOpzz5khx4yJ5QDD4rjyZuQ6rkMrKPAxnJvltrWTm8o/r1ISdxW/Xg2XpAC7UDgeYPtm4j6XqEyt3LosYg77gecAYA30fYIZSEV+hg5HL8JkAPflea+3QzAoNxLlSrgmixQdSolTHqA76Dz89XxvkM9wo1dghtBArfqBjsyiI6ZEGs9t0iXWRxNhmJ7ZfhRG1XPxm1o8/pFd8v+d5x1ypP
 bCs/cQKf
 iHGsTyJrORm/Bne8kmKJatKeDcpKZLkDhw79Ue6dVMJUfi8/mbGDJIipvVk8gVwjDxoG3rdFhknqOD/ZhIsfBrCrOyP0l4RT1kioyPEsKZwichi6duglt+C0FZ1bsmOstxifZU6D5jCgHqJ9Gfu5msSMoQEod04W/ALm8TpMi1wZlplsPnmOAAedwfjM5dqtS/euhToGUHI/82RtzZ3Hd+lYhB+QM7KZw/k2ssp4/bR+lVdj2zO64nXCExy53bjaGodWhB1evdDCLI6dMdKr1CaodBfMizOs9Sza0o8X3Hs7LWjV8TqyzpjSKgGtYaF6sNk6lEGlnhhRSdQvdCKB+NriyEoUfmnD1mGGTjjJNyWW8disHbl7Y+4mOuQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/14/26 4:09 PM, Kairui Song wrote:
> On Wed, Sep 9, 2026 at 9:57 AM Baolin Wang
> <baolin.wang@linux.alibaba.com> wrote:
>>
>> As per the comment on LRU_REFS_FLAGS, when accessed folios are promoted to
>> a new generation, LRU_REFS_FLAGS should be cleared so that the reference
>> counter can start over.
>>
>> For folios rejected by shrink_folio_list(), we clear LRU_REFS_FLAGS and
>> set the PG_active flag when lru_gen_folio_seq() would place them in the
>> oldest generation. That's fine.
>>
>> But for rejected folios where lru_gen_folio_seq() returns a generation
>> other than the oldest one (which can be treated as a promotion), we do
>> not clear LRU_REFS_FLAGS. This can violate the promotion mechanism. And
>> this means the rejected folio enters the new generation with stale, inflated
>> tier bits, which can inflate reference counts and distort eviction
>> statistics for these rejected folios.
>>
>> Fix this by clearing LRU_REFS_FLAGS for rejected folios. Of course, I need
>> to evaluate the impact of the changes, which mainly falls into 3 cases:
>> 1. When lru_gen_folio_seq() returns the oldest generation for rejected folios,
>> there are no logic changes, and they will be put back into the 2nd youngest
>> generation.
>> 2. For rejected folios with PG_active set by shrink_folio_list(), we only
>> clear the LRU_REFS_FLAGS and do not change the generation.
>> 3. For rejected folios with PG_referenced set, the original code would put
>> them back into the 2nd oldest generation. After this patch, we will put them
>> back into the 2nd youngest generation.
>>
>> I think case 3 is also reasonable, before commmit 6cbdd9726fb5 ("mm/mglru:
>> use folio_mark_accessed to replace folio_set_active"), a rejected referenced
>> folio was also put back to the 2nd youngest gen. Meanwhile, I didn't see
>> any noticeable performance impact on my 32-core Arm machine when running
>> 'make -j32' to build the kernel inside a 3G-limited memcg with either zram
>> or NVMe swap.
>>
>> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>> ---
>> Changes from v1:
>>   - Update the commit message.
>>   - Clear LRU_REFS_FLAGS earlier.
>> ---
>>   mm/vmscan.c | 7 ++++---
>>   1 file changed, 4 insertions(+), 3 deletions(-)
>>
>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>> index 40d3f1b48a74..1557679aadb1 100644
>> --- a/mm/vmscan.c
>> +++ b/mm/vmscan.c
>> @@ -5020,11 +5020,12 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>>                          continue;
>>                  }
>>
>> +               /* See the comments on LRU_REFS_FLAGS */
>> +               folio_set_lru_refs(folio, 0);
>> +
> 
> Will it be better to mention that we never add the folio to the oldest
> gen (since `folio_set_active` below prevents that) so this is
> effectively promotes the folio by at least one generation? Maybe can
> be combined with the comment below.

OK. How about the following comments?

diff --git a/mm/vmscan.c b/mm/vmscan.c
index c2eb8fa9d5e5..a1ead7c61054 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -5071,10 +5071,13 @@ static int evict_folios(unsigned long 
nr_to_scan, struct lruvec *lruvec,
                         continue;
                 }

-               /* See the comments on LRU_REFS_FLAGS */
+               /*
+                * See the comments on LRU_REFS_FLAGS.
+                *
+                * The rejected folios are never added to the oldest 
generation,
+                * so this effectively promotes them by at least one 
generation.
+                */
                 folio_set_lru_refs(folio, 0);
-
-               /* don't add rejected folios to the oldest generation */
                 if (lru_gen_folio_seq(lruvec, folio, false) == 
min_seq[type])
                         folio_set_active(folio);
         }

> 
>>                  /* don't add rejected folios to the oldest generation */
>> -               if (lru_gen_folio_seq(lruvec, folio, false) == min_seq[type]) {
>> -                       folio_set_lru_refs(folio, 0);
>> +               if (lru_gen_folio_seq(lruvec, folio, false) == min_seq[type])
>>                          folio_set_active(folio);
>> -               }
>>          }
>>
>>          move_folios_to_lru(&list);
>> --
>> 2.47.3
> 
> I tested this, and also tested with MGLRU-FG on top (the posted
> version is on top of this):
> https://lore.kernel.org/linux-mm/20260911-mglru-fg-v2-4-f26e5cb26da7@tencent.com/
> 
> Both cases looked good with no performance regression observed from
> this patch with a few quick tests. It also has no conflict with
> further changes. Nothing surprising was observed, so:

Great. Thanks for testing.

> Reviewed-by: Kairui Song <kasong@tencent.com>

