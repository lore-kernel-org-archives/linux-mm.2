Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5190C61DC4
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 13:57:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6513C6B008A; Thu, 27 Aug 2026 09:57:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 601C16B0095; Thu, 27 Aug 2026 09:57:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F06F6B0096; Thu, 27 Aug 2026 09:57:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2ED2A6B008A
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 09:57:09 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9C3AE80459
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 13:57:08 +0000 (UTC)
X-FDA: 85147200936.18.B53A286
Received: from shrimp.cherry.relay.mailchannels.net (shrimp.cherry.relay.mailchannels.net [23.83.223.164])
	by imf17.hostedemail.com (Postfix) with ESMTP id 3F72240003
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 13:57:05 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=stgolabs.net header.s=dreamhost header.b="gu/mdLwI";
	dmarc=none;
	spf=softfail (imf17.hostedemail.com: 23.83.223.164 is neither permitted nor denied by domain of dave@stgolabs.net) smtp.mailfrom=dave@stgolabs.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787839025;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g36eCBdW6YCkN4JZFF2wStGV66A2T43tQBEQe1vgjdY=;
	b=xecDxGL3mV+FAUAmi+CNXqYwSazf9cYQ3c+Hfp8OlNmbVN6nYCt38+CqCG+oxIklsdgR9q
	Rtlqa6d8DDcjw5aD5yvKkG7pW37Ana3/LKHqiRVrhHnlDFrOa6pt41W/fUSN6oCNvI3Cyn
	AJmjV1hYrSY4nDtdoks0kO0fTxPQaNo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787839025;
	b=Uo90mNIAZY0JJkXFq4eeJ6BPBenBBym9hNonVKdI4FXgc8l8RMtzbaxMP+JE7Zbjvk3Xlv
	9eabJ0+GpR91K/YS324jf0qobCp/UECoGQzaUvVsmcW2i3udeN3i5cIMW0YIEYI7JQZFcB
	C7XWwjksc23c4yxEVAAMCBG/6Vn+0nE=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=stgolabs.net header.s=dreamhost header.b="gu/mdLwI";
	dmarc=none;
	spf=softfail (imf17.hostedemail.com: 23.83.223.164 is neither permitted nor denied by domain of dave@stgolabs.net) smtp.mailfrom=dave@stgolabs.net
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id DB16F3E2967;
	Thu, 27 Aug 2026 13:57:03 +0000 (UTC)
Received: from pdx1-sub0-mail-a230.dreamhost.com (100-97-3-207.trex-nlb.outbound.svc.cluster.local [100.97.3.207])
	(Authenticated sender: dreamhost)
	by relay.mailchannels.net (Postfix) with ESMTPA id 1933E3E2174;
	Thu, 27 Aug 2026 13:57:03 +0000 (UTC)
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|dave@stgolabs.net
X-MailChannels-Auth-Id: dreamhost
X-Harbor-Abortive: 02c2864649e2b1f8_1787839023524_1077040877
X-MC-Loop-Signature: 1787839023524:2677987914
X-MC-Ingress-Time: 1787839023523
Received: from pdx1-sub0-mail-a230.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.97.3.207 (trex/8.0.2);
	Thu, 27 Aug 2026 13:57:03 +0000
Received: from offworld (unknown [76.167.199.67])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: dave@stgolabs.net)
	by pdx1-sub0-mail-a230.dreamhost.com (Postfix) with ESMTPSA id 4hW33f0MMMz2s;
	Thu, 27 Aug 2026 06:57:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=stgolabs.net;
	s=dreamhost; t=1787839022;
	bh=g36eCBdW6YCkN4JZFF2wStGV66A2T43tQBEQe1vgjdY=;
	h=Date:From:To:Cc:Subject:Content-Type;
	b=gu/mdLwIWZQKYn0UqzVHRTWVnMaO6MymBwcRO6Q6zsoi+91xjPwDbIvxl0Z3ZyrQp
	 p/nNV9CTUnoXaEJqXWfz+RXBG8TVpjtOzx++KJylPpdoH/mXMxrn+X1jMQGgwoYCsf
	 otts37bWHliDW8PvT6sgj7BY91plGfDmgsXDeKm9H1tDy5Ve8GIpiDRoZ0yh8zIasr
	 h06XYLsCsR8CK3L5LFXEi6OmJmOjQLDSM/ml3XlkPlyzR4vh7uNk7jCga49p8tkBTp
	 WJFkCdUGgLp4jWNkPrWAf2HzCAKitzM1voHGPwcWDyFNdMSgKS87VY+QA06xHjUjml
	 MLNmKDhAoMtKQ==
Date: Thu, 27 Aug 2026 06:56:59 -0700
From: Davidlohr Bueso <dave@stgolabs.net>
To: Ridong Chen <ridong.chen@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@kernel.org>, Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Ridong Chen <chenridong@xiaomi.com>
Subject: Re: [PATCH] mm/vmscan: drop the combined limit gate in
 __node_reclaim()
Message-ID: <20260827135659.f735ms26jimuedq5@offworld>
References: <20260826124409.35569-1-ridong.chen@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20260826124409.35569-1-ridong.chen@linux.dev>
User-Agent: NeoMutt/20220429
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3F72240003
X-Stat-Signature: xr3xxmkhkzxtrwhmihst5sg3hhrnep1i
X-Rspam-User: 
X-HE-Tag: 1787839025-726565
X-HE-Meta: U2FsdGVkX18sE07z8BrIVj6cIfsy4XdknGaZcfYNzNiEX9I0qJboktvc70VfuvX7Fw1uLqMxtkkwQZvhYwnsR7QTUjt5UvX9odrELJRtfUABme9qSZq10VQjXCKdzoLni2ri0Uz5KiNar+i7B49/EOBhAwe/oUQI6hf1grqMtN6QK4OFbVpzN780d3aZxqjYewlYnskAFyxgU6QFG4kcurbg84WUY+yK4gIFfb8KwaB4UOvleojMCNjOJwojkk1v8KwH1bCIAHq19OLpg8qPPsu0jCMUFD62IcVUKjN4wUSycsm5501b57WI4fh9w248wN8k0DnRqy3DJwyORx5oisROpjs5NAEOPhukbzB4UAUP1L3CvqzwA0Eonf5tji157GGfJ2s2M1VKjdoL20dvaMyoZw+TGe/zbGD0w2Cukpc3XMmI+gW3cgu+qZAl2XLeSrCTJ6eHFI+lUt2eFPJHvky7SoHTPTQkpdw92ZoCoeLEgNAA6HVUsiReI5vxozswA6fvTTP+cLW2rpoai2szVMWr2wzvk5uWyw/iabGRf7GMofuSMyJLcyzhojj67k88HN/jnMgt309q9wKxl49GPwTC6Bgd4U999IvnY7E2pIAGv4OVMqyVNmO8U3YZeMYDeDLsSU/sG+TWeWuQ0wnk9dQbY74CjCk1S9RP9nZkGF0bq9/6To4V/ElLjiaN31AsQtdQO3O9nGPbtvdShvh+pCIIqpRRcMixYXMFah8irdhO6n8BpWrMZvl3pT9SocKPzwEN5gj7XEHvKhWjm9NNR/OlQ6XuUBHQNaqXCQzeUTjHE5ClfdEaWD8X+H3OtX9VaUWJp1jepG8ApBs4dPSVmldDt6Z+RDttRqjuDBuHSnrhFT8bMtQAuSQIJxzNGLG3qJ6rbRmzD7mq675p0MlPSAEz6GxXB/ITB/WVJEzDze7bJ0J83go+MqBzjPwXZLCwJy5gJnXRNwP6fydVZzf
 6Do4vxoI
 DRQMR7NFjjA4JP8UzNlWdlXfUsccz5dGdiLfvwOkbT1NG8m4COx0apdQEe2a9Us659fNqfxJk8XF0Kc1vZ6bVkag8fEQJqy24Tc4fRmo5ecwPV7bUMPFwAMqeAyU2hXPiXxYhNQz8RmfAVd/R5E0pT78xKRiqTAL2pfVeIenP20iHbe7zT13Usv2mFp0SyNCS2UpIdsIwn7IzOq4AjBx+uezmOsskfsk67zAEeBamhB7uBxsa3xndPYX+cJZHYA9aGl2zthuudhfWPD2NzKR7gkV7I4IM0sPQxmbwg0fuCOH0VfMzp8o9Zg5EEHHn0hBlioXZtCVQMdjRuD7ia7XL4vWf8Vn+1Yqkf0eVn8nFyWN1v0S65+YFAr8DpaYPV1hmyQHIBmoXG3Gq+knifXk2ersJ/8PVd3HiZG6jkpJlQK8eA5f6E7uclrooKx9ScxnbTEyWYv56f7nQtGkBgKLFDhf3Fkc3Eq27BhC+9WbpR2o8MbsHqtR4s7Nn/DKhR6QhFA3lLSfCdvzsWkc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 26 Aug 2026, Ridong Chen wrote:

>From: Ridong Chen <chenridong@xiaomi.com>
>
>__node_reclaim() is called from two paths: node_reclaim() and
>user_proactive_reclaim().
>
>node_reclaim() already bails out early unless node_pagecache_reclaimable()
>is over pgdat->min_unmapped_pages or the reclaimable slab is over
>pgdat->min_slab_pages.  The identical check inside __node_reclaim() that
>guards the shrink_node() loop is therefore redundant for this path.
>
>user_proactive_reclaim() is proactive reclaim driven by userspace and
>should not be gated by the per-node min_unmapped_pages / min_slab_pages
>limits at all [1].  With the gate in place, a proactive request is silently
>turned into a no-op whenever the node happens to sit below both
>thresholds.
>
>Drop the gate in __node_reclaim() and always run the shrink_node() loop.
>The node_reclaim() path is unchanged, since its caller has already applied
>the same test; the proactive path is no longer wrongly gated.
>
>[1] https://sashiko.dev/#/patchset/20260723045718.2052070-1-ridong.chen@linux.dev
>Fixes: b980077899ea ("mm: introduce per-node proactive reclaim interface")
>Assisted-by: Claude:claude-opus-4-8
>Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
>Acked-by: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: Davidlohr Bueso <dave@stgolabs.net>

>---
> mm/vmscan.c | 13 +++----------
> 1 file changed, 3 insertions(+), 10 deletions(-)
>
>diff --git a/mm/vmscan.c b/mm/vmscan.c
>index f11491ee9ed5..6dff207ad8c6 100644
>--- a/mm/vmscan.c
>+++ b/mm/vmscan.c
>@@ -7851,16 +7851,9 @@ static unsigned long __node_reclaim(struct pglist_data *pgdat,
>	noreclaim_flag = memalloc_noreclaim_save();
>	set_task_reclaim_state(p, &sc->reclaim_state);
>
>-	if (node_pagecache_reclaimable(pgdat) > pgdat->min_unmapped_pages ||
>-	    node_page_state_pages(pgdat, NR_SLAB_RECLAIMABLE_B) > pgdat->min_slab_pages) {
>-		/*
>-		 * Free memory by calling shrink node with increasing
>-		 * priorities until we have enough memory freed.
>-		 */
>-		do {
>-			shrink_node(pgdat, sc);
>-		} while (sc->nr_reclaimed < nr_pages && --sc->priority >= 0);
>-	}
>+	do {
>+		shrink_node(pgdat, sc);
>+	} while (sc->nr_reclaimed < nr_pages && --sc->priority >= 0);
>
>	set_task_reclaim_state(p, NULL);
>	memalloc_noreclaim_restore(noreclaim_flag);
>--
>2.34.1
>

