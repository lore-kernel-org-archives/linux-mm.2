Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE94D606A32E
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 08:49:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=t5n8sfbn
Received: by kanga.kvack.org (Postfix)
	id D05606B02BB; Thu, 22 Oct 2026 04:49:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB6396B02BD; Thu, 22 Oct 2026 04:49:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA5316B02BF; Thu, 22 Oct 2026 04:49:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 983F96B02BB
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 04:49:12 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8C82D1207A7
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 08:49:11 +0000 (UTC)
X-FDA: 85349637702.06.119050D
Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	by imf31.hostedemail.com (Postfix) with ESMTP id D7A7420003
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 08:49:07 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=t5n8sfbn;
	spf=pass (imf31.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792658949;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+7S227f8gWHbiIqoS7NBrqLEaJEM3lqiWRRqdw3VbHY=;
	b=AVQVdY7H5UN3ZjpDdFgGyRXGAChGCFh966I9fQRzCEl1XBMv0lSP96S7GhF8hoeU6r1DPe
	Jzhm/3hso36vvBb+omqWigWiXaj+3dqeQXMDR6YdOuvgXjXp7Auy1HL3pn0bQb0dzofbZg
	CRy0TesoeTaNvLaSdcNmtq/RG1nl/fU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792658949;
	b=c3cu8wKBoYmOrKBCpPFePkpWMmKq+wuSfsTgwZKf7HWgeH/mO37N2h9ouewBjbtAAuXXV6
	PO458rui2etZSlHEzGw7LHCf4R2RjEXx/Ql5Nf+TCBlkRsz2Z18NwgbWDi6fxLZtL4q/KF
	qZ5Vq9pf49X5U5KM4dytqF3TWymXASA=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=t5n8sfbn;
	spf=pass (imf31.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1792658944; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=+7S227f8gWHbiIqoS7NBrqLEaJEM3lqiWRRqdw3VbHY=;
	b=t5n8sfbnYpxPd6mfTE62BtOe3x9xMAcXD+8Z+F44xJYBSKtkPaqwOjv5GXMDX18PzZobew/CE6Y5BWaBD2xARmPKdX8NF0UHuy30fsqvx+CUdf7bHSJNuWYApFa/5dQFEksUC2oRieHgC0xHPpDkuQoi2qvd+/vZGZHjB9hW328=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R701e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=17;SR=0;TI=SMTPD_---0XDImod8_1792658941;
Received: from 30.74.144.160(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XDImod8_1792658941 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 22 Oct 2026 16:49:02 +0800
Message-ID: <0cbd219d-f69d-4f72-aec5-43e1f2d978de@linux.alibaba.com>
Date: Thu, 22 Oct 2026 16:49:01 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2] mm: vmscan: avoid anon scanning for GFP_NOIO with
 low swapcache in MGLRU
To: Barry Song <baohua@kernel.org>
Cc: Xiang Liu <liuxiang.277@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>,
 Michal Hocko <mhocko@kernel.org>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 Kairui Song <kasong@tencent.com>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Baoquan He <baoquan.he@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Bo Zhang <zhangbo56@xiaomi.com>
References: <179248830836.1744016.8424217811286616919.noio-mglru-rfc-v2@bytedance.com>
 <7f4daafd-a3c5-4ccc-80bd-05a7ac09e4ab@linux.alibaba.com>
 <CAGsJ_4wV8A5snz-XE+5ht931=07SvCs_k4xvUCE1yphKyQd8tw@mail.gmail.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <CAGsJ_4wV8A5snz-XE+5ht931=07SvCs_k4xvUCE1yphKyQd8tw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D7A7420003
X-Stat-Signature: xzchbcufg1mkb9o7jcfdj3aczofwfr9q
X-Rspam-User: 
X-Spam-Status: No, score=-19.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1792658947-187747
X-HE-Meta: U2FsdGVkX19wjdXWgPLwwpNymux0oqajP3Bk3X8o8IePxIIpXQEZg5SpNXKl7fYLbDYpOyGtruSBdmxKlvRvt+13m0bC2nJcjX0UbFI2woqJcEnStgWsz17mBWKTu9xQzwD7PcAAKT1FZUPnpB1kuRQWT4UQxYjXT6yFD4i3xpwIMeRavMbHl11cU5ZkMaedp15Q23t6EH6BxPFMADhb6xMVDmVjBMoUCyfz4oKxXx9oQDxJ5yYymQgGnG+N6s5fkNFO4L0hSzeHtXDQf+02XefI3OMN3aFZ886/cfeuwQQxkD9M8818t97BsmS9UUQoYeLbnZBo4BljAoG1WFH8H4roIG4S2EWb7M4gYkAELXmPQpyXjlLp2tySLb4Q4gT0A5r/CsSJJiBgvQPKFFFTxtke7LCvVsmIHMcJIwzH3zDwHKyRFfTruB9n0rPlXIPDeHj8mpTiv4Qve4CYKSx9RTjvCWWdeUL5GVEb4yQEIQ9MVJhS+9QVYG7lg2iSb4naBmjzNhI5XCUVaPLI9Vt7/OeFs7QPaNbxsuL8I0YNjjhzygvH8g2WvY027kIfV+ekZrx6F3h/XOc9Jd5mptAVoHKBC4wZ53ktpcVPyij/cOfE5rRN+lkGl0Z6YLveSDZaR+G6Td8Jl007jnBpCjLkpQ/k3bq2jtU9SzZnnqqTDAF2NAi9GQ71kvKagLDGxINpWGZc11aSLKXHN9agB9BrnDju5w4pdMZ3XKKYceGUXQhQ9KGQ0bRVjMQAvRyqI+Pj8BiAnLcji5tjKSaV5CgZsObCa/PiqS3YEOfS4+Qjm8Zv/Wd3abU39Tcv9uHGjtKQRXRw+iLTBaOVXGA6N60dx7cXGxZ32e4CPEBtqJz5hQHYGO7dZ5IOp6uClMKH9XJDO+6cZJzAxuoFCqtHGIMNXtCHVMsAW37kAeoWeRNEftnlSHSPC8kC64MuGZroVyQmTFDMMECS4CCAaNI+j9h
 /eQDJsVs
 gq+4BbCEsMK6kSFSq3OdABFUhlASi8jRz5ar4AAYehPRx8MiQWsUlaFKVxIIhOfdmxerc+J5/5QjfrD89ep8wL5TorO5Ze7vDoxd7mdxnkoImnwaMAPQY3vzzM1YqdjhClhX3YMafZJZ7wKAsfTb3mRmnWndLhC+U5gXmwjV1dt4Fjv9BiVoc6uPEnNawev6+lBJ/yegj1vXIPSXAZ+2IMaWnxG0nhxJxzeV+Xkq/Ks/cA00I670o/jbyzBRJIdoKz0+0ROZeBZAgVxoidIVQcclimfpNJiyuX1tYFPfvAWjOv/AvS3JDTBbrYFskMlKwyeu6T3So2r+Omzde7mA3l3VkSHXRLrEUTSGOP7Y5GT6tnuZDTr2KFmVozg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 10/22/26 5:55 AM, Barry Song wrote:
> On Wed, Oct 21, 2026 at 3:28 PM Baolin Wang
> <baolin.wang@linux.alibaba.com> wrote:
> [...]
> 
>>>    static bool lruvec_is_sizable(struct lruvec *lruvec, struct scan_control *sc)
>>>    {
>>>        unsigned long total;
>>>        int swappiness = get_swappiness(lruvec, sc);
>>>        struct mem_cgroup *memcg = lruvec_memcg(lruvec);
>>>
>>> +     swappiness = get_scan_swappiness(lruvec, sc, swappiness);
>>> +
>>>        total = lruvec_evictable_size(lruvec, swappiness);
>>>
>>>        /* whether the size is big enough to be helpful */
>>> @@ -5249,9 +5265,10 @@ static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
>>>        bool need_rotate = false, should_age = false;
>>>        long nr_batch, nr_to_scan;
>>>        int swappiness = get_swappiness(lruvec, sc);
>>> +     int scan_swappiness = get_scan_swappiness(lruvec, sc, swappiness);
>>
>> IMO, 'swappiness' and 'scan_swappiness' are really confusing. Why move
>> this logic into get_swappiness()? In get_swappiness(), we already have
>> some similar logic to adjust swappiness when there is no available swap
>> space.
>>
> 
> Yes. It is very confusing. we can't do that in get_swappiness() as otherwise,
> we will get cold/hot inversion due to GFP_NOIO. for a real swappiness=0,
> we allow cold/hot inversion for anon, but for GFP_NOIO, this is not the
> case.

But can_reclaim_anon_pages() doesn't only handle the GFP_NOIO case, it 
also covers the swap space limitation scenario. The latter is what 
concerns me more.

If we're only talking about the GFP_NOIO case, I'd agree with your 
concern. However, we could introduce a helper to force anon aging and 
add comments explaining why we need this. That would look more 
maintainable than 2 confusing swappiness variables, no?

Just my 2 cents.

Something like below (untested):

diff --git a/mm/vmscan.c b/mm/vmscan.c
index daa7e37c2236..7c1d26e6b9d7 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2890,7 +2890,7 @@ static int get_swappiness(struct lruvec *lruvec, 
struct scan_control *sc)
         if (swappiness == SWAPPINESS_ANON_ONLY)
                 return swappiness;

-       if (!sc->may_swap)
+       if (!sc->may_swap || !(sc->gfp_mask & __GFP_IO))
                 return 0;

         if (!can_demote(pgdat->node_id, sc, memcg) &&
@@ -4049,7 +4049,7 @@ static inline void flush_lru_batch(struct 
list_head *head, struct list_head **ba
         *batch_end = NULL;
  }

-static bool inc_min_seq(struct lruvec *lruvec, int type, int swappiness)
+static bool inc_min_seq(struct lruvec *lruvec, int type, int 
swappiness, bool force_anon_aging)
  {
         int zone;
         int remaining = MAX_LRU_BATCH;
@@ -4063,7 +4063,7 @@ static bool inc_min_seq(struct lruvec *lruvec, int 
type, int swappiness)
                 goto done;

         /* For anon type, skip the check if swappiness is zero (file 
only) */
-       if (!type && !swappiness)
+       if (!type && !swappiness && !force_anon_aging)
                 goto done;

         VM_WARN_ON_ONCE(get_nr_gens(lruvec, type) != MAX_NR_GENS);
@@ -4183,7 +4183,20 @@ static void try_to_inc_min_seq(struct lruvec 
*lruvec, int swappiness)
         }
  }

-static bool inc_max_seq(struct lruvec *lruvec, unsigned long seq, int 
swappiness)
+static bool is_force_anon_aging(struct scan_control *sc, struct lruvec 
*lruvec,
+               int swappiness)
+{
+       if (swappiness || (sc->gfp_mask & __GFP_IO))
+               return false;
+
+       /*
+        * Explain why we neeed to force increase anon min seq.
+        * xxxxxx
+        */
+       return swappiness != sc_swappiness(sc, lruvec_memcg(lruvec));
+}
+
+static bool inc_max_seq(struct lruvec *lruvec, unsigned long seq, int 
swappiness, bool force_anon_aging)
  {
         bool success;
         int prev, next;
@@ -4205,7 +4218,7 @@ static bool inc_max_seq(struct lruvec *lruvec, 
unsigned long seq, int swappiness
                 if (get_nr_gens(lruvec, type) != MAX_NR_GENS)
                         continue;

-               if (inc_min_seq(lruvec, type, swappiness))
+               if (inc_min_seq(lruvec, type, swappiness, force_anon_aging))
                         continue;

                 lruvec_unlock_irq(lruvec);
@@ -4249,7 +4262,7 @@ static bool inc_max_seq(struct lruvec *lruvec, 
unsigned long seq, int swappiness
  }

  static bool try_to_inc_max_seq(struct lruvec *lruvec, unsigned long seq,
-                              int swappiness, bool force_scan)
+                              int swappiness, bool force_scan, bool 
force_anon_aging)
  {
         bool success;
         struct lru_gen_mm_walk *walk;
@@ -4260,7 +4273,7 @@ static bool try_to_inc_max_seq(struct lruvec 
*lruvec, unsigned long seq,
         VM_WARN_ON_ONCE(seq > READ_ONCE(lrugen->max_seq));

         if (!mm_state)
-               return inc_max_seq(lruvec, seq, swappiness);
+               return inc_max_seq(lruvec, seq, swappiness, 
force_anon_aging);

         /* see the comment in iterate_mm_list() */
         if (seq <= READ_ONCE(mm_state->seq))
@@ -4295,7 +4308,7 @@ static bool try_to_inc_max_seq(struct lruvec 
*lruvec, unsigned long seq,
         } while (mm);
  done:
         if (success) {
-               success = inc_max_seq(lruvec, seq, swappiness);
+               success = inc_max_seq(lruvec, seq, swappiness, 
force_anon_aging);
                 WARN_ON_ONCE(!success);
         }

@@ -5262,7 +5275,9 @@ static bool try_to_shrink_lruvec(struct lruvec 
*lruvec, struct scan_control *sc)
                 }

                 if (should_run_aging(lruvec, max_seq, sc, swappiness)) {
-                       if (try_to_inc_max_seq(lruvec, max_seq, 
swappiness, false))
+                       bool force_anon_aging = is_force_anon_aging(sc, 
lruvec, swappiness);
+
+                       if (try_to_inc_max_seq(lruvec, max_seq, 
swappiness, false, force_anon_aging))
                                 need_rotate = true;
                         should_age = true;
                 }

