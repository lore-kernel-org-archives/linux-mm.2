Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6EEAC61DD6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 21:52:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 68B296B0092; Wed,  2 Sep 2026 17:52:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6633D6B0095; Wed,  2 Sep 2026 17:52:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 52DB26B0096; Wed,  2 Sep 2026 17:52:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1C6A06B0092
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 17:52:40 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0F0041203AC
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 21:52:38 +0000 (UTC)
X-FDA: 85170171996.03.21DA9BB
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	by imf10.hostedemail.com (Postfix) with ESMTP id 42BD8C0004
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 21:52:36 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="SgsBt/rD";
	spf=pass (imf10.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.169 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788385956;
	b=Fsv0JN5OHBGlew7tBSaLteDjeKZIhNjJHz1YTcJjmz5pQw37WuzsxIhEROd5VwlQRQmP5B
	OcLGrw1ZbJSOaT5KII3GFy+UiXYbCF20+jgjyhth93iwf/jj2pByEQl8mUbLsIBZuPD78S
	EJlDOFOvRz77D2Dtu96oaelnwZ07af8=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="SgsBt/rD";
	spf=pass (imf10.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.169 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788385956;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OuqexuqBOZ7GFjlPmCKhvMHJIKht+V+CHEZiUpwBp2k=;
	b=k3syW/qzYWesKiy3yHsBazyHq783f7zHSDOb4rRRQtGs138oa4HBy0SX9xkwk7Uhc2Wu8G
	3aIljMmtBfw3qFF8pMPw+4mMgKZ73MlRkzjSriZOJuSfBMbTQa4RSbp2FOVMpR2+1D20Hf
	eJWaTvLnfa+9YWKTpoxF1HWh+Pii8yc=
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-530420edf1bso6878961cf.1
        for <linux-mm@kvack.org>; Wed, 02 Sep 2026 14:52:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1788385955; x=1788990755; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=OuqexuqBOZ7GFjlPmCKhvMHJIKht+V+CHEZiUpwBp2k=;
        b=SgsBt/rDHgCMB84AK0FAXa3kjHreR6g9QXUbkq7fdLjRW09rGD9tRG9NFDm03qlR/a
         ufCX51EcnFC1LtbW+tIxQnVZOFYjnh2/SD/UjM5j+z+oiEi9Fol624eXkNEttERTyw9r
         UFSDwYSBtOYoRf1ZriJ+cUQECr/Y0Cenk71rLITR8H8WGIapHpUAXUxr/jlvf4qLxXCG
         M/i/UUIENKgzNnVZ+pJxMWlbo0tjlSZg9IC5mKsN5upGoDeW+TYFjWZOO6lCu3FI4P5N
         EEu8nO2jMclShxMmUI7AfXdzmH5dgWS1cNeO7P8EXY+19vxNZ8XgE/MEds4GEzQSmaKw
         lYFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788385955; x=1788990755;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OuqexuqBOZ7GFjlPmCKhvMHJIKht+V+CHEZiUpwBp2k=;
        b=eYsdexI9QT4vR0CQ2kX7kqm8vpPgD7xyZwsStF3Kw+Lz0V3m7T4nfVEGDgcrKjSURi
         xr3T2fd3VS0QuQr/Dk3ZR9H94VNwcRBUbueRP7k+jP/RYtIiPCBwe3xWROlMyxsjLV8W
         3p1hnWwLfJ5GM7JtifAdqI278fBYGwjvfVi6X1GAD85mXAKZPDWEr5Lwjnuqy92nEj9m
         0Zq1o9+7kGQpLLYMlNXhbSJBTM3AwwDzW0QO5JSO3o0fmW6GWx8P+K9VORPWGd0DP0pW
         cnQ+4qp9xrAfVPhUZDYH+f6GETm2pZ2XfajhFo5GQXuHivVdMytOUI9K85zHFPcm51Em
         ad6A==
X-Forwarded-Encrypted: i=1; AKwUvBw7BOGn0CDZdPJe2YnhieAdaX9EaukdgUlaM3ESsniZ/4XFrQNHKpnovboCYqoZs4OOx6gz9GDI+Q==@kvack.org
X-Gm-Message-State: AFuF++kn3K8cBVKSmKhXIc9fJTzDLiQ8TYjHu6wbtUYzW6MINivG1ucG
	Hp0QoZG0depGsron+JFcQ+DMbWKNzFakcz1l3wC0L077g9r7+2eKTN5qpu3jcvCVKV8=
X-Gm-Gg: AYBFou3DnidscL/Pcx7a/BaR3QK4HLL90Z4kV/uEgIebLB6jrzEMOlDjbWnCs0IBVj9
	KO8IgL9ps5kvTVKlldlTHxAIaJjOxbgReEU5kTUT5Xi1+3WoGPyqQHc8AAFmi6OXA74mH4PX2h+
	qXI6aRntHcRgriccQFLFc1Jfvlpwv1gIO+U/KJXhmNNHWGTn5Hs+eVaDg55SiZ4ekiD0VSpLo2J
	+pYKe+iUuotE6kW3adB4gF8f8g/LvFawIiCyxxg1p0I4D4zmwEAO3zBkjop3jO0lRr/84V/CbYl
	rovALWHLUN9oBr6SnkhFX10BarpylobIyzrJw4gIQLWehP6HfmQbm9AeBb3IWlIfF9r8dj5WvaB
	lRL3SQ6ssSAnNpYjjZHCe5bvMjr7Q7QHwuq70MdS4TPL46WLX3rs/WeHlBwBFAo9QSVZg1oJR7+
	K1qNsM2UjhUCvEph4NJ0s/QP39szpdKMcDtrcN2yVslMaJ8LPrPSgjipqLcNZtdzTpLcTAF+gCY
	Tke7yqbonby3oz3SageOz/Sf4Ma1fBhqazQ4f3QRMO+
X-Received: by 2002:a05:622a:190b:b0:530:42e4:effe with SMTP id d75a77b69052e-53042e4f1b6mr31250901cf.43.1788385955400;
        Wed, 02 Sep 2026 14:52:35 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-53032ff584esm28409111cf.1.2026.09.02.14.52.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2026 14:52:34 -0700 (PDT)
Date: Wed, 2 Sep 2026 17:52:33 -0400
From: Gregory Price <gourry@gourry.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Liu Jing <liujing@cmss.chinamobile.com>, david@kernel.org, 
	ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com, 
	rakie.kim@sk.com, byungchul@sk.com, ying.huang@linux.alibaba.com, 
	apopple@nvidia.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mempolicy: fix div-by-zero in
 alloc_pages_bulk_weighted_interleave
Message-ID: <apiZFrc_ShBRZimV@gourry-fedora-PF4VCD3F>
References: <20260902090412.16445-1-liujing@cmss.chinamobile.com>
 <apgqvt8iIt-a6j2Q@gourry-fedora-PF4VCD3F>
 <20260902144039.2824b7589e87dd185c92d67a@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260902144039.2824b7589e87dd185c92d67a@linux-foundation.org>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 42BD8C0004
X-Stat-Signature: ipg6oopx1mnisyr8rcyi85adua1d5kfd
X-HE-Tag: 1788385956-657208
X-HE-Meta: U2FsdGVkX1857s82MICMij2gd8Qjgr2vOG58fdMKwaszwD8xBXDDl7mSrIEQeuuWum/zm1Tc4s5+mFweZPJby4Yp1Jw3hiCms9NTSxG7F/tQmAnAiPQkqm7T63Xwg9CXUUtzNBlAK7IVPyw74Pqr2a6cLLcZhg7sz24ZRMNkeVF6qPKjX0fz5h9ZOI1a4RLLvzLmuHHzHKw/XqV2W+fUcYBVtZbmE/finODZh3K1Y0e6Y8j5frIQ3WMzAvSTwlW/WaHtMOVd4oMrP1IEdktPqZEKPlIM6VNnIEw7vXXda1kDxcCzRUN/NR8Jkf1XtYpbFl1eqohCu2PzmUdWhHAKN5D6NPf349r71Gs6vWeX1GxKokPal2FIjtifOPDsHFOU/4cVJE5ENbTBUQ+8mpJZl8jiPJPFuY9oRGLaQTw4il/AlK2PU4UgSYDlY5f2lalGRMv5Icry/8yI2uRTQkRO8r4vVwNkOw988S52ZX82EzhS/GK/6vkI8f9aVNaozgeNVdP6h3eK7aJ3ANeBugUm5JLX5a07xXufQmjfa+D7BUmPHKL7ylWDEij9pUUyFJ2Iqk7W32L5qHsdFr5Pco2bPWhUy/ginQDD4dUSCpEltHm9eIXAIFD5PlL0Bo6ZXbEZZ5QTJ6IuC+c1giBX1LdkBEsZpAlRYIGYDhtO2hl+ksMsBPHS/AsJTxRdv4pmJoWJ5Oe1vzESojiuDSNeUFfSKOrdiqzIxAuJvzUj2RlHXUpOX1YhAJiy5OR/kuQr047jMBR382Vxj6vrYyVAIlCJhQvL4VWANt6jEeF+ddKnGKV4TFNG0kwQ3LA7fpaRhcMo5cXCFCGOuO5anrSP/pFjzkeb/RqXLN9pnAWWFDDwOM8kCJKjA3IdU7/7xjPG1KcJhv1yCaSt5xmQUZvcbgWuL+Tuddi4wunYKmT1gAt/SvusXuAwYV4YzNgp0HMWApVw0P/fJ/b53nmNKG0mZLe
 l7ZLYq40
 RpPF6kFlKNBeAFJlZYCmAXjYuaqn8aNzPo094HYVsv9eydxtU3mj1KUTYL5siJytKkETuPwxQvCEk9Lv+EBi8xDMc9XkdNrqd5Z2/GyVL3CQJogogUINDhVwX6qPQARmzqBd90mG3FHerUa7AeKYA1Zb28IglcQFHOD9wHp4YNnYWUET1cHKe+vXAcdOyWxv9bZKS779MkTfLOtcKaQvHiJXJSJW2Y4IAW0dl/wFDoj9+4Y0oW770R/U8Tl1zxvuicasSGXmX43uXYG7vH+AXX+R1V66n4bdtq2lnTJEU34q4753qEUMTrm+k0xhFHVINCMqg6bviV5GQAEiQpfnzOKbyuqVjccVTRDssKS3UzzZibCv/6H2YsyyozIVe9alU3olMCnMLKi7hXKoqsmq5iNzfk+18J9wGpey2r8QFAlXmqlpN/tEi+1ky60S44IrHZF0nfk5BBZwCYIkf4lZDzmZR0GQReJA6oeoZmL8N0CeomQ8esRYhchrfIM2pNW1sKsTW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 02, 2026 at 02:40:39PM -0700, Andrew Morton wrote:
> On Wed, 2 Sep 2026 09:57:35 -0400 Gregory Price <gourry@gourry.net> wrote:
> 
> > On Wed, Sep 02, 2026 at 05:04:12PM +0800, Liu Jing wrote:
> > > In alloc_pages_bulk_weighted_interleave(), if the iw_table contains
> > > all-zero weights for every node in the policy nodemask, weight_total
> > > sums to zero. The subsequent "rem_pages / weight_total" and
> > > "rem_pages % weight_total" trigger a divide-by-zero panic.
> > > 
> > 
> > weights can't be zero and we just fixed the rebind race
> 
> So if the caller passes in me->weight==0 then we consider that caller
> to be buggy.
> 

basically weights cannot be 0 by construction:

What:           /sys/kernel/mm/mempolicy/weighted_interleave/nodeN
...
                The minimum weight for a node is always 1.

What:           /sys/kernel/mm/mempolicy/weighted_interleave/auto
...
                If they were not previously set or are onlined with missing
		bandwidth data, the weights will use a default weight of 1.


int mempolicy_set_node_perf(unsigned int node, struct access_coordinate *coords)
{       
...
        new_wi_state->mode_auto = true;
        for (i = 0; i < nr_node_ids; i++)
                new_wi_state->iw_table[i] = 1;


static ssize_t node_store(struct kobject *kobj, struct kobj_attribute *attr,
                          const char *buf, size_t count)
{
...
                for (i = 0; i < nr_node_ids; i++)
                        new_wi_state->iw_table[i] = 1;


static ssize_t weighted_interleave_auto_store(struct kobject *kobj,
                struct kobj_attribute *attr, const char *buf, size_t count)
{
...
        for (i = 0; i < nr_node_ids; i++)
                new_wi_state->iw_table[i] = 1;


we default all weights to 1 and never let calculation drop below 1 for
exactly this div/0 reason.

The div/0 risk came solely from the torn nodemask read issue.

~Gregory

