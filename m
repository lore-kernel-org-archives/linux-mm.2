Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2E71CD5BD2
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 01:58:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 20B586B0005; Tue, 26 May 2026 21:58:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BC696B008A; Tue, 26 May 2026 21:58:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D1626B008C; Tue, 26 May 2026 21:58:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EFFC16B0005
	for <linux-mm@kvack.org>; Tue, 26 May 2026 21:58:49 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9CF5A8EB08
	for <linux-mm@kvack.org>; Wed, 27 May 2026 01:58:49 +0000 (UTC)
X-FDA: 84811541178.26.F1EC2FF
Received: from lgeamrelo07.lge.com (lgeamrelo07.lge.com [156.147.51.103])
	by imf26.hostedemail.com (Postfix) with ESMTP id 5740814000A
	for <linux-mm@kvack.org>; Wed, 27 May 2026 01:58:45 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=none;
	spf=pass (imf26.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779847128;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PxnNJ5TOMw0EpBMu3jHrhSWVTFuS8LXlLaNrMBVZLbw=;
	b=MsOlREmGIitytyyqgHIFA6JctYdWAS6yPgBnOWfK8njqAThNUAHKxPyhJwccASW7X5pbPD
	k2jcHtOQg7un0BFXLMnGGl6MeaaaHvpPoyOXo2KEbTZpkbfseXzxlrbpKlgQiMhAyZRhPe
	46Yg8F2K2lQbMNiEwrInBcqaTLEOkUM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779847128; a=rsa-sha256;
	cv=none;
	b=7IunAs0107qH0tbcj+JT9tqmElAZVyiOx75eU+QrSb/55rCGDhyK8snLLwdAPaFqOLoAbp
	AuUG6U+4cfiVYqybqpK9Ey4tKnh+rgjncWzhECSsSlu0g959bjxn8jh/QIPbbApl/RbJPP
	WIyjqdIINFehzQr9z6QGUn3VHKWmZxA=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=none;
	spf=pass (imf26.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.103 with ESMTP; 27 May 2026 10:58:42 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Wed, 27 May 2026 10:58:42 +0900
From: YoungJun Park <youngjun.park@lge.com>
To: Baoquan He <baoquan.he@linux.dev>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, linux-mm@kvack.org,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
	kasong@tencent.com, hannes@cmpxchg.org, mhocko@kernel.org,
	roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, shikemeng@huaweicloud.com, nphamcs@gmail.com,
	bhe@redhat.com, baohua@kernel.org, gunho.lee@lge.com,
	taejoon.song@lge.com, hyungjun.cho@lge.com, mkoutny@suse.com,
	baver.bae@lge.com, matia.kim@lge.com
Subject: Re: [PATCH v6 3/4] mm: memcontrol: add interfaces for swap tier
 selection
Message-ID: <ahZP0hj1/O9U1pTm@yjaykim-PowerEdge-T330>
References: <20260421055323.940344-1-youngjun.park@lge.com>
 <20260421055323.940344-4-youngjun.park@lge.com>
 <ahW9UQH93jBT_VaD@MiWiFi-R3L-srv>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ahW9UQH93jBT_VaD@MiWiFi-R3L-srv>
X-Rspamd-Server: rspam11
X-Stat-Signature: nr94i5h9o5or346giyqi5yfwxgz8gsyw
X-Rspamd-Queue-Id: 5740814000A
X-Rspam-User: 
X-HE-Tag: 1779847125-292405
X-HE-Meta: U2FsdGVkX1/kegQHW1lSn/t7RR57LPxwM1U32T5kEoVg0Ey5UiVRIpbGgTFLitu+1c9iBgSEllFAvyhq8GRbbqKVqiw8iSRzIPhp+QeBDs50NmIU2s90QZV+s9bDdrAIJEK+CDGvQFQ0IdI7ZjtfVTm8Deg3QkbB9KiAI0+s/63Py1I97c6ZKnYkciAf2WDIq3XiEBG57QG5yBrrzE2qgZ92gw6Ofiavu0ECsxTUY5W2gTb96OHcElErt0bt9XbrWOQmABdwShH/D5/xtNzS2S/MoeQRyTSAweCA+kvcgXGq/9LyHdf9gDa0w1P1JkrNpSen+VL0G8zUWtLSAuNO9h0zB6UNFxp+GPbrrCt/XDQBsoInBtAQuOHqz8kB9Tpkkfi0z1U9MV8r+WjzLTK5OS83RcDvVedEBydqtKrl7eY/G2up6rBYA9j0uUj3a5+Z8EHq1Xn3f55gswD6fXJEhMmjVbc5LVKTluM+1OTjAIPObZpeifqzitWWUtV85WeQStsNpEjMAgRC1JJvrPiTdA3ApuFldOY7aErFPXdDIciNRpUPR1vlYrtxk5HBAh8NcNGrecnuguLfD8D7q4HsOa1pI18pKlH/J48F8VSh4c92r0VqyBjS1CqNxnPM433Xev/aHJvr1/K7oOetuvrfSWeSnLYVeZ/indqLPi143yDJHW1etWlNtHEskVBELOMPNxLC6AlK/8Qc10dAKrWAV0ADpImBqzJTYolPArFP8OpIMhTKZa0ztWJJj0qrJPKgwso/F3sXOvS31tIZXQy/mb8Uy7s8sOeCwbm2aor2n3OJrLuXYxK4B/Bkv3F15im7LLWtCc+ra4diKQrqA+wstXNujChOKIHfH+zOfu8HkqVgcljJ2AAUOvZLnfNBa7AXcC52u2U5YorWfGFXtNwJn2kxQTMaMRUusGerHdfZb3/71JNsVxpYUu3FrPxjY+6h4G+MEcE+9fYs2tDzZwq
 dkmBHP3k
 eM+S0D4p6CEdEhIpdYQ1UM0ACWKs+8+nx5mwmZXZVScF9tgic3bCbWU7YkZLhk79OILtbkAnkFlm5EF5bsg+j8jaoKzArQ9tobJISaKTcM8A1SrxXiicd1GfUMnpg7oju5APF/YmyT0pE6DOVy8JmrXeyN9bcPzlocEIK/T4rqtZ4SflbOArLobbO3lSwh2MvJeIOukNgZZ5BlUsDF0G2KPXepg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 26, 2026 at 11:33:37PM +0800, Baoquan He wrote:
> On 04/21/26 at 02:53pm, Youngjun Park wrote:
> ...snip...
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index c3d98ab41f1f..0f67572e5e3e 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -68,6 +68,7 @@
> >  #include <net/ip.h>
> >  #include "slab.h"
> >  #include "memcontrol-v1.h"
> > +#include "swap_tier.h"
> >  
> >  #include <linux/uaccess.h>
> >  
> > @@ -4130,6 +4131,8 @@ static int mem_cgroup_css_online(struct cgroup_subsys_state *css)
> >  	refcount_set(&memcg->id.ref, 1);
> >  	css_get(css);
> >  
> > +	swap_tiers_memcg_inherit_mask(memcg);
> > +
> >  	/*
> >  	 * Ensure mem_cgroup_from_private_id() works once we're fully online.
> >  	 *
> > @@ -5667,6 +5670,88 @@ static int swap_events_show(struct seq_file *m, void *v)
> >  	return 0;
> >  }
> >  
> > +static int swap_tier_show(struct seq_file *m, void *v)
> > +{
> > +	struct mem_cgroup *memcg = mem_cgroup_from_seq(m);
> > +
> > +	swap_tiers_mask_show(m, READ_ONCE(memcg->tier_mask));
> > +	return 0;
> > +}
> > +
> > +static ssize_t swap_tier_write(struct kernfs_open_file *of,
> > +				char *buf, size_t nbytes, loff_t off)
> > +{
> > +	struct mem_cgroup *memcg = mem_cgroup_from_css(of_css(of));
> > +	char *pos, *token;
> > +	int ret = 0;
> > +	int original_mask = 0;
> > +
> > +	pos = strstrip(buf);
> > +
> > +	spin_lock(&swap_tier_lock);
> > +	if (!*pos) {
> > +		WRITE_ONCE(memcg->tier_mask, TIER_ALL_MASK);
> > +		goto sync;
> > +	}
> > +
> > +	original_mask = memcg->tier_mask;
> > +
> > +	while ((token = strsep(&pos, " \t\n")) != NULL) {
> > +		int mask;
> > +
> > +		if (!*token)
> > +			continue;
> > +
> > +		if (token[0] != '-' && token[0] != '+') {
> > +			ret = -EINVAL;
> > +			goto err;
> > +		}
> > +
> > +		mask = swap_tiers_mask_lookup(token+1);
> > +		if (!mask) {
> > +			ret = -EINVAL;
> > +			goto err;
> > +		}
> > +
> > +		/*
> > +		 * if child already set, cannot add that tiers for hierarch mismatching.
> > +		 * parent compatible, child must respect parent selected swap device.
> > +		 */
> 
> This paragraph of code comment sounds a little unnatural. We are writing
> it into memcg, the child memcg is handled in
> swap_tiers_memcg_sync_mask(), isn't it? I don't get the 2nd sentence.
> Could you help explain?

Thanks for the review.

I think this sentence is not appropriate.
Maybe I forgot to remove this line after modifying the code many times.

This sentence is not correct.

I explain one by one for clarification.

"if child already set, cannot add that tiers for hierarch mismatching."

mask can be changed (can change the tier_mask). 
But the effective one (effective_mask) is recomputed with parent's effective_mask.

"parent compatible, child must respect parent selected swap device"

effective_mask must be restricted, which means child effective_mask
must be subset of parent's effective_mask.

