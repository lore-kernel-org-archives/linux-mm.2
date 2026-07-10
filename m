Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E5FAC43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 01:51:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A17F6B0005; Thu,  9 Jul 2026 21:51:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 052B96B0088; Thu,  9 Jul 2026 21:51:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E85036B008A; Thu,  9 Jul 2026 21:51:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C3C3B6B0005
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 21:51:08 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1F5C21C87DC
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 01:51:08 +0000 (UTC)
X-FDA: 84971189016.04.7E259A7
Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	by imf02.hostedemail.com (Postfix) with ESMTP id 120E180002
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 01:51:05 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=D9qPAxIH;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf02.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.170 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783648266;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E8GxFNbQsVrb+BIXdmdxnEvt/Qb6Rl8NGz4M/Bm/cIA=;
	b=lny6eGRGEY+ThWriEtAJ6p2X28mJkEKp2J4pwMZQr339F4BtIMF+yXzJtJiTqABV5YTT9A
	02YnAnrGm/EPeMs/AkfGGxXZp2qkT5DwTMFNVhOpN2wVM3FpZ1mOhU609xUPQpBf0Vu05K
	uChio3ZhJYBZ1vZYEmEp2iI7lvsRrww=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=D9qPAxIH;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf02.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.170 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783648266;
	b=w/TOsowSIUxBuGQLDKf3dx12WrJ1KhCvdM3Pv/MhQfMXRyXyZcvcuH+6qGtvJ6+0+sh8HM
	cc115h6m9F90y27vtDRivUg0crOxz+G7pWhA7TGy45HGauANbZ5zvL98lOnSyDAiNwcfSM
	Lfiie4oZJEaV2/7ctONEA3F9DOzJk+w=
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-92e65e18969so29623985a.1
        for <linux-mm@kvack.org>; Thu, 09 Jul 2026 18:51:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1783648265; x=1784253065; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=E8GxFNbQsVrb+BIXdmdxnEvt/Qb6Rl8NGz4M/Bm/cIA=;
        b=D9qPAxIHJDyZH3zqusHY2FxkBSOkrIpKpIoe/Ikpp7TTHGRKejsRR9x2yFw4G4Us/t
         iOxk/qI889rJA5YbIHnJqymSdi0FBc6TggPxcljFE9y5mgd04HIJj984ig4RgajA2nUH
         bGFr6pK1weeS2hh853XTE/ss9jZ11MPCABHQ3RWQqNDbGnTeI1cBDB0TvKGAnCTNLYaK
         85WMB6ywt72b5Rz5Dk9W3i4SvxwPViY/r0V281H0OfFsPnAAeH9Zf8HCj4CpusdZNrnc
         +lOGjKxIrcVuiaChPNQyafHaQJUwKNx35TxAW6j1KXxOSjPmb9i5hXplRStRa+2YMQrm
         A/fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783648265; x=1784253065;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=E8GxFNbQsVrb+BIXdmdxnEvt/Qb6Rl8NGz4M/Bm/cIA=;
        b=ANRfqkllSGxpMhI6Jo4YusW/KQewFXmEV4Q8yIW/p8QmMd5QXZYLNAAooKrA+5umsj
         ifNLZt/ORhYqb5iCUBHFsbFsMqE9YQryLHpIC9DM92+YCyFdoqwm6YA4/CRhawdVg2kA
         SDANIBoaGAhcOKnBfQmnITLEpn1YJ8NJ+Gv0OuGhJu2W8r483I4CZcaHfQBJytY3HLGx
         DVwrnEnh7bU7mj1lbN4DniidPkqlHa/6rveVLS9OG1hKNoSDFU9RZ6vgPhpf6gora3CM
         SCpboPmQNMWgwE7KnQ9WpXjibIObe6L0ni0tqtjZsOzaWtRSUI2Z4+WyScJm6k6NxMuz
         bwKw==
X-Forwarded-Encrypted: i=1; AHgh+RoTeUZL+qCFFs5bn6RIcj5K9zZvUOZbhAVsEpRVzIR2kd0LCHCYAT8YGfslYHxrtRDc9jLv3Hantw==@kvack.org
X-Gm-Message-State: AOJu0YzF68ZJzyKRsVDSJLNTBrKBm3wOON+dEP4BpvEhZyiITd+Ox45A
	x/WWPWigp7mwfp9lg4GmRDY6j9q71c08zNlBgHDhyvBUIZ1STp8NoC21GzXkwAx51LI=
X-Gm-Gg: AfdE7cn/21+xlrXXRpH+B0EhOH7ZbEk7vVfde1eZwLPVnQ12NsVmY8IS5mqqvzbMZQS
	GR/IiaUt+x4topSlz2HmLpc84gs4/lRvqPZerI/ZnAl13bKfXZF8yrE+TqtJtaPhwosE7qykKG+
	04+lQALfT8Vqh8q1I95UNXPACspI1CDNc2I16OYHaS0ydACwFE4JRe+9IzygQQHP42zEX6tqHLm
	N8+cfOtOTgQVJGZc+pvF8eM7YQwnBkeMOQEliY2NFJqQdScM8ZwcOJBcC8nQRF+fLOovqoPo+tt
	GZ71UuhTN8trFCBGbQ3sSkbz4T24Cew3s/iuwlAB4T6fgnHht9/e9O8JOkUAU9YlqLTkmUtdm8k
	PmFDXGKDMhkSAQ/rEKhlX21aawsBHx9n1HouZDQnXsdzl+lVO0uokRyH3C2fSeQACpVD+YARr4p
	pcjvL4kPhERI8/hZg24y98oA==
X-Received: by 2002:a05:620a:260e:b0:92e:bb71:4e8a with SMTP id af79cd13be357-92ee54af9a0mr182240085a.9.1783648265006;
        Thu, 09 Jul 2026 18:51:05 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-92ee5cf7ab2sm81055985a.30.2026.07.09.18.51.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2026 18:51:03 -0700 (PDT)
Date: Thu, 9 Jul 2026 21:51:01 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: Harry Yoo <harry@kernel.org>, Usama Arif <usama.arif@linux.dev>,
	akpm@linux-foundation.org, david@kernel.org, kasong@tencent.com,
	shakeel.butt@linux.dev, baohua@kernel.org, axelrasmussen@google.com,
	yuanchu@google.com, weixugc@google.com, muchun.song@linux.dev,
	peiyang_he@smail.nju.edu.cn, mhocko@kernel.org,
	roman.gushchin@linux.dev, ljs@kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Qi Zheng <zhengqi.arch@bytedance.com>,
	stable@vger.kernel.org
Subject: Re: [PATCH v4] mm: mglru: fix stale batch updates after memcg
 reparenting
Message-ID: <alBQBRWDrVoh9P-a@cmpxchg.org>
References: <20260701145736.3785016-1-usama.arif@linux.dev>
 <2fb5ce53-666b-4b0a-a4ad-2b3a28c54768@kernel.org>
 <akU5VdOBkLGInh_t@cmpxchg.org>
 <cbba6349-55a1-416d-a686-d03ff72cc211@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cbba6349-55a1-416d-a686-d03ff72cc211@linux.dev>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 120E180002
X-Stat-Signature: mtxf44ft44i6upwpq339yossoxiizyz6
X-Rspam-User: 
X-HE-Tag: 1783648265-65884
X-HE-Meta: U2FsdGVkX1+Eki8mJRbv127IUkmu6BsKyUrVODMzPcxfzF6KEuuV5iNJyjmGrx3j9Enl+3vp6/wL6HNCarN4MHpPFW/QOl8Ydprd2lG+0uXFdgaUUCOjg2br1BT/JqyJeAVRJX6R7h71ALcSmdvTlFHPQiwe6ofgS8nOBoaj6GVJsDh5SM8HXIkKBmwUPa2tsmC+WcPoPTONIrh1gtsot844kuoyjirpjmFe7VRaIk/eihxzmVtNELDxUrNUIoDaUEKsr/APfkRsTTB1r4dvAVNvy4bFmaI985ty+7V7VkIPSizuu9UUBQyh3gXybhSsgoi9ZBzxn8PE5CMZ7AemE/g6kFHEb3QY5jKqxt5yvuUvjlZLAjYnFZL7RhqHw7jWNGq72Jn2L+an8Swxo+pQsJCoe0bG6ibJQrZerE5X67Zgq7US1SI36sZqI5r70I2lZEWObeAKUk45Jz6FdZRfPBA2RSfBPs/AvZoWd6OuydI9mjZ43m1ctq+5agq4FXHRquThzVyTyhLHk4c0qHFQKvKrXBAXB6rBZvLZF+kL0hyL4uWHtbmSMqIyspCx0Z8cbxiNlpJWTgkbrO3fzcnVPVifFxiMii54DrJLhl8K2uwwmWHaUsyXEHePCSRHhSiL2e05ChHBGnx6bRijDuxhmI2Gy0zczBvQ7n0jiOkpkM58L+B10XF4OK+GtUPKcgXd5gceSBvPZLOQNnhTUvMKPzHZMiJvHTU7mV2ZX67Oxghvckqqn/xYDwxMlwhANFJFQrT86lL/gLDS/m45A9HHZt/fDT8Y8g6hmOwWGtCowTMo5RcAx74aZY+H7Q31WJGYTqEISn6yV4T8AV9dGGlU/Mq77sxWxu43ZiGEKCwFFrFa0oZmapkNlcxvd0hgSHitYRqG8i8tsyrv+0otWgISaeuNcNyTsgFAzc6cTdAeIRsv1DXHXmnWoCZmxlPu+XriqMCIYrHtdU2MmKItsEx
 LYW1mBoQ
 DI+ViOEc2PU50PkD2xPTOxRWKQQrBIMjuUMaLueXnBQiCKLIFGTf8sGnOz0rw3PGnRdV2XNGwNkYMWTsUg0fqTIQGihjNe0E2MmqCsAjx/gWxwIqf9AKHLewgWqwfoHYcUJjmnPhSFC5e3TY4PvfoWk+CD9SPUqjtGOAaw+/k5B/uhwP7M4LKw08Vp70BJA/T9ExoDaOEE2AWeNhHCegZrFmHQwO581NWHD3wU61Ez0KNQlOM0s7X06WUmphySTo8TOMpAapxbrsGnC5QexUdrAJnQn/Wj5etrpM56tSxy9zgErecInL8+tDQI3ZGbAh59/3tB5WBDOMIQS6ruvc2EcPzIVLVjhsLCt+5dLKhVVensGqXem6G3+G7SZ6xX0x4xXE6o/tt0HezohFr5/UNVrwK7o0vg9X4hnnK3xvW8HDvCeCKLl9lc9GHP+umbbRzRBoV7oaLkGnHjsA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 02, 2026 at 09:38:41AM +0800, Qi Zheng wrote:
> 
> 
> On 7/1/26 11:59 PM, Johannes Weiner wrote:
> > On Thu, Jul 02, 2026 at 12:36:42AM +0900, Harry Yoo wrote:
> >>
> >>
> >> On 7/1/26 11:57 PM, Usama Arif wrote:
> >>> On Wed,  1 Jul 2026 15:52:51 +0800 Qi Zheng <qi.zheng@linux.dev> wrote:
> >>>
> >>>> From: Qi Zheng <zhengqi.arch@bytedance.com>
> >>>>
> >>>> The mglru page table walker batches per-generation size deltas in
> >>>> walk->nr_pages while walking page tables without holding the lruvec lock.
> >>>> The reset_batch_size() later folds those deltas into walk->lruvec under
> >>>> the lruvec lock.
> >>>>
> >>>> The page table walker can run concurrently with the memcg reparenting path
> >>>> as follows:
> >>>>
> >>>> CPU0                           CPU1
> >>>> ====                           ====
> >>>>
> >>>> walk_mm
> >>>> --> walk_page_range
> >>>>      --> update_batch_size
> >>>>          --> walk->nr_pages += delta
> >>>>
> >>>>                                mem_cgroup_css_offline
> >>>>                                --> memcg_reparent_objcgs
> >>>>                                    --> lock lruvec
> >>>>                                        lru_gen_reparent_memcg
> >>>>                                        --> reparent child folios to parent
> >>>>                                        unlock lruvec
> >>>>
> >>>>      lock lruvec
> >>>>      reset_batch_size
> >>>>      --> child lrugen->nr_pages += delta
> >>>>
> >>>> This will trigger the following warning in lru_gen_exit_memcg():
> >>>>
> >>>> 	VM_WARN_ON_ONCE(memchr_inv(lruvec->lrugen.nr_pages, 0,
> >>>> 				   sizeof(lruvec->lrugen.nr_pages)));
> >>>>
> >>>> And the user-visible impact of underestimated nr_pages in MGLRU was
> >>>> premature OOMs because MGLRU does not try to reclaim memory when nr_pages
> >>>> reaches zero, but there are still more pages.
> >>>>
> >>>> To fix it, make reset_batch_size() check CSS_DYING under RCU before
> >>>> flushing the pending batch. A non-dying memcg keeps the original lruvec
> >>>> stable against RCU-delayed offlining; a dying memcg redirects the deltas
> >>>> to the first non-dying ancestor.
> >>>>
> >>>> Reported-by: Peiyang He <peiyang_he@smail.nju.edu.cn>
> >>>> Closes: https://lore.kernel.org/all/5A9E929D82717101+12fcf643-efb8-4b9a-a53a-1e28cc894f0b@smail.nju.edu.cn
> >>>> Fixes: f304652609ea ("mm: vmscan: prepare for reparenting MGLRU folios")
> >>>> Cc: <stable@vger.kernel.org>
> >>>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> >>>> Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>
> >>>> ---
> >>>> Changes in v4:
> >>>>   - re-implement lock_batch_lruvec() in a simpler way
> >>>>     (suggested by Johannes and Harry)
> >>>>   - collect Reviewed-by
> >>>>   - rebase onto the next-20260630
> >>>>
> >>>> Changes in v3:
> >>>>   - re-implement lock_batch_lruvec() by checking CSS_DYING under the RCU lock
> >>>>     (suggested by Harry)
> >>>>   - update the commit message (suggested by Harry)
> >>>>   - temporarily drop the previous Reviewed-by tags
> >>>>     (since the sync method has changed)
> >>>>   - rebase onto the next-20260624
> >>>>
> >>>> Changes in v2:
> >>>>   - update the commit message (pointed by Barry)
> >>>>   - collect Reviewed-by
> >>>>
> >>>>   mm/vmscan.c | 41 ++++++++++++++++++++++++++++++++++-------
> >>>>   1 file changed, 34 insertions(+), 7 deletions(-)
> >>>>
> >>>> diff --git a/mm/vmscan.c b/mm/vmscan.c
> >>>> index 35c3bb15ae96..ca1e2a870d51 100644
> >>>> --- a/mm/vmscan.c
> >>>> +++ b/mm/vmscan.c
> >>>> @@ -3262,10 +3262,40 @@ static void update_batch_size(struct lru_gen_mm_walk *walk, struct folio *folio,
> >>>>   	walk->nr_pages[new_gen][type][zone] += delta;
> >>>>   }
> >>>>   
> >>>> +#ifdef CONFIG_MEMCG
> >>>> +static struct lruvec *lock_batch_lruvec(struct lruvec *lruvec)
> >>>> +{
> >>>> +	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
> >>>> +	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
> >>>> +
> >>>> +	rcu_read_lock();
> >>>> +
> >>>> +	/*
> >>>> +	 * The memcg can be NULL when the memory controller is disabled.
> >>>> +	 * Otherwise, the caller keeps the memcg owning @lruvec alive.
> >>>> +	 */
> >>>> +	while (unlikely(memcg && css_is_dying(&memcg->css))) {
> >>>> +		memcg = parent_mem_cgroup(memcg);
> >>>> +		lruvec = mem_cgroup_lruvec(memcg, pgdat);
> >>>> +	}
> >>>> +
> >>>> +	spin_lock_irq(&lruvec->lru_lock);
> >>>
> >>> Do we need an rcu_read_unlock() here?
> >>
> >> lruvec_unlock_irq() does that.
> > 
> > Yeah, that tripped me up too. And it makes me think Shakeel was right
> > after all: this should live next to the other lruvec_lock() primitives.
> > 
> > Sure, MGLRU is the only user, but it's still much easier to understand
> > this if the code sits next to the rest of the API (and the unlock!).
> > 
> > lruvec_live_lock_irq()?
> 
> But lruvec_lock_irq() grabs the rcu lock too. :(

Yes, but it's self-explanatory if you put it with those definitions:

static inline void lruvec_lock_irq(struct lruvec *lruvec)
{
        rcu_read_lock();
        spin_lock_irq(&lruvec->lru_lock);
}

static struct lruvec *lruvec_live_lock_irq(struct lruvec *lruvec)
{
	struct mem_cgroup *memcg = lruvec_memcg(lruvec);

	rcu_read_lock();
	while (unlikely(memcg && css_is_dying(&memcg->css))) {
		memcg = parent_mem_cgroup(memcg);
		lruvec = mem_cgroup_lruvec(memcg, lruvec_pgdat(lruvec));
	}
	spin_lock_irq(&lruvec->lru_lock);
}

static inline void lruvec_unlock_irq(struct lruvec *lruvec)
{
        spin_unlock_irq(&lruvec->lru_lock);
        rcu_read_unlock();
}

etc.

