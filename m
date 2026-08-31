Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B161FC61DFD
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 08:56:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BDF736B0088; Mon, 31 Aug 2026 04:56:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB6EB6B0092; Mon, 31 Aug 2026 04:56:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA8396B0095; Mon, 31 Aug 2026 04:56:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 792356B0088
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 04:56:50 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 049501C1F10
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 08:56:49 +0000 (UTC)
X-FDA: 85160959380.06.541F2F3
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	by imf27.hostedemail.com (Postfix) with ESMTP id 0EB9A40002
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 08:56:47 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=cOIjTbbE;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf27.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788166608;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HLgX1bHF///geDnj0BJGtTg8YhTYEnQT5ferZZbVKSA=;
	b=Y/opUuAX3dyRfUkJPeTaRiscQ0gyRlyFN180x6Y7DkF7eD79u2zy6ZjmZib06n2rvDoxZp
	BL3vllxWhizPfhl8bKMoljjJ5vpdCkM0IbxAcPWHvEbrBD74UuYx/PhXKi8dcAXPQejvEk
	KcxzhFS67PlkH/3ZrykAg9CjcYkhGbk=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=cOIjTbbE;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf27.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788166608;
	b=Z4WOMEnKSwYJXKiT+caQWuIY9pMtt1zpLk23Ru1ub6jr7XwnDbyGrEA5kK3DAtngSESnPN
	fMlTsHEe5rVsjDWXn7Zje7IzCD8bGqzumzVrIK8bYviCf/TrGZ7RNllF8NhWOCCod157tY
	OKq10Gyj0Rzw0RRoqN6rurDuESfEnug=
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-482e4998d28so2203837f8f.2
        for <linux-mm@kvack.org>; Mon, 31 Aug 2026 01:56:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1788166606; x=1788771406; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=HLgX1bHF///geDnj0BJGtTg8YhTYEnQT5ferZZbVKSA=;
        b=cOIjTbbElX9ZkhbOAoOgfEEdQ41DOGf70zKVQKn97V9lbelklRJZ8OMZEhSn0eBIwB
         yXCAxS07BnYozL9e8rou53jecvLJGf+soXbCHrmgbn0hiunEdmhND3/3PqX4Kp2JAUe1
         L+bPWpc9XcFomb8u0+7dcnCFRVOR1viGSi0FUE2GAI4TbQjrSGd0aG+HdJcK/GkRMj5c
         lSsk4MaGK9PHnZI1K6QuWHEoXw2QWCzC3D11aoXQBK+Csy/p8AESn30nhye09/PGxa0t
         ct3ncDRGvBUqv3tLImIbi8shh7FkEt4bFUcB65Q+RTJ20s3reTvdY4+0dMm6XBhcOjFr
         PL4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788166606; x=1788771406;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HLgX1bHF///geDnj0BJGtTg8YhTYEnQT5ferZZbVKSA=;
        b=GSippOqTO8HkVXe9B97NoKcEOsVu2wmDi0r2t4S+q2T3cFFndlVXlSgaUOigLCPzn2
         idiJXpsWqCR0nBEQ/Di/O06JrVi9smHl0G/Xf7ieSGsr6UbOj3rzRc7lKBPHs3oHghu+
         1ITaYkjj28fJPh/KAUluCloSuNL6cWLkoCa+4SPKj49Nt6gpQJZC+jBJergUYf8jgZlf
         ZvwbzYsP0Us5mxRj4WYvG7OG1J7AnfDyqwNbwczuYhVhVmsD+M4QnVl3OBww+BX9B4CS
         QT1V3Ce9gymVnMwUnTwTQq5Yb6Agd02aa15VtlB/FBp5Svpa8vFKGUemdF8vuZC9MCz5
         HsHQ==
X-Forwarded-Encrypted: i=1; AKwUvBxyh/nHPBrIsQ6yh35Ewdk3qfqPdUX/DG1dUHQIDksOpI8qCh1TKpPX6F7l5UL3EjCz8rp8pRa3ZQ==@kvack.org
X-Gm-Message-State: AFuF++m3UPSUd43PFYJCoObJZ/cEPPGY1yIw62dolB6cV+sukXwzoiHV
	/uTT258qxcudVv2xy2C0quhduBYSWdeDsYf00MSnw3NI09Dx+2LaxYeYb+kfRhFJGDU=
X-Gm-Gg: AYBFou1S3LFh4cNrM3Et7malCFbRvg0KTXWbquzAlezkADhVfTqfYJjfFL94Rtv7zDU
	CufI30z4TTp0TjqUyP7yUuT4LMnVXLt1vRE/ZCZvdsXfmtCBMi9KRHG+TpwAtHVS5UvKUjE861u
	9u2YCeUbAqqhPGFD6EoDti8vq4u45ue4Fxd0/Qbm3wT2xXbXewWrq1E6FbkdrDGoc5j83TqxYJs
	khqz2zKoqfVEyR2pU9i6/H7CDLBXpPmTG1yoq1qQXfUAsnHOwLvGi+XxbKHXkaEDS9TeeGWuMYw
	55Zwkmas9Er/MnDeWp66fyWhz0Nfi7J7b+CFwGXiChSV/GZ43zdLeUQYM5dYS+fqwRNBZQpU/rE
	3flTjUlOXrg2dA51d5oeH/1xaZXbw0h0ikl+f3CIMCFiIWhUjhKG4vZTKzgcV2u6LP9qcmwdQxt
	+k4UEOXMLKjwQepRC36zqPD6P7tWHNC36Dwo/ZFypQ4poIYpSR4hjEiPNcwPGtmAbzQLGE5u0yc
	A==
X-Received: by 2002:a05:6000:4911:b0:483:9f9d:59dd with SMTP id ffacd0b85a97d-4839f9d6235mr29857682f8f.19.1788166606171;
        Mon, 31 Aug 2026 01:56:46 -0700 (PDT)
Received: from localhost (109-81-17-247.rct.o2.cz. [109.81.17.247])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-482fbab3fdbsm18886146f8f.6.2026.08.31.01.56.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Aug 2026 01:56:45 -0700 (PDT)
Date: Mon, 31 Aug 2026 10:56:45 +0200
From: Michal Hocko <mhocko@suse.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Rik van Riel <riel@surriel.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Muchun Song <muchun.song@linux.dev>, Qi Zheng <qi.zheng@linux.dev>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Sashiko <sashiko-bot@kernel.org>
Subject: Re: [PATCH] memcg: clear FLUSHING_CACHED_CHARGE on cpu offline
Message-ID: <apVBzfx9PX7fbxdR@tiehlicka>
References: <20260828192419.3057939-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260828192419.3057939-1-shakeel.butt@linux.dev>
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 88a4e7w8mugr46ai3ek9yctyjb8er3sx
X-Rspamd-Queue-Id: 0EB9A40002
X-HE-Tag: 1788166607-569768
X-HE-Meta: U2FsdGVkX1/3FqBm4XgM6sl3pJ4x47RgBOIGkj1zUCba6MTEaUSnvoKDrmh1veBBMil2kybMWIa/Rl4nY/4LgREr4BWnUZX784k3D7aRrPLRouCtwVsHhEEwjTeRB6+gutwT9ulmsMoYGk4NhK5Y3aGi4JvcQWx68aPM5R9oyC6B+ptPQiDsvqBnc9neEJVU8eBCzCSD5V8yyZn6+kw2QxXlkW649nkjzqKdZn6PEHFOXQsYiWo0nLTQuAGBWd/WO28vx7phVdc23dE/L5vwwV4URTAi8ZEd9U/aUeFbaTa4KLqY7g9vV34+T2Usn3KJxUp6+PhzzeV7eg2Yk8dP8M8+QS+bwTZxAZEjCcNxOU0zrezSQw63CA0Y9aHmxO3hmD+rpyJ1zUS4dHfPlhv8OTY9EO8knOMvRiBz3nLSUmogdWHN7PeE4YlElhGzTWzDLRGlcAmEoieQI3tuLw1wjR79/drUASrRZK6es24ChTQe4LxVwCugwmcrJ+wzs3O9AiY3liuLZ28Doja/IoX70o8SQugr/PFMuZTnCk64hx/QnW0vStzdWgQyb4wn2xqbAuHR0SHPiejt07LiPsXA7pZB6uJpqZ/za9neSqwC5JIk99iZ8OXem+Mu4+gWXJzaoHiulrd4kMQiT5OGikPTkfbeHrcLc+0rOECr4KGjLS3AhvlN3Ojf+2aDWIudj+s5FdcobEbJV+PNNnEOKNHSaezFDXhMbv/YSJ2EVXmtzTRhgKzDm5JWgcKqEewYsU4MWCg7IziySi7ONW+HdmnAxvETKEpWY/rrhffcFTL+42thWfMyEMRL8KIAGh3gigjKR2zJ4ERFVU7N/AVvrVOXqZpcr02zKvOfbvoCTC54AV9ZaesojHiE9fF0iqMWXIR9r+IQC4t7I39Q1pDmwIqdvL7qkiNE8AyYq/BODSNQlP4Gy4wA5rvjc7Gz9auKuZVPQHO/1J6VkWsJuHPhGIQ
 kQvmc2/5
 1OX3zDmUzcGujRotpkIju8KcRvPSjV/5RD0ZNi3EMwoHVmvTOB1l+fzA4CCfmXjtHPjAkaO6tJJNT8WNWiJDzWMSxLYqjPBhdKyFbeCFPynfYNBkTwYc6viFUjRjtXUh0SsOA+MrHtllf+Rs+UDyba0zG8nyrv92c+p7tdrj0brH1FyxE/X1RysxhESK9Bgs/a1nGntoGFtll1lBluBG+KOpOhIAFxJCY91dsgx5IlbWiNe03UUCzlTlytuQ+a46pPEtFxxw8o3VmsMd8P6MxjPBS6Epw45PO7ze9Tfu02mg57qoqINUZvwLzRCkSF82Nevi6gvZ38CFJNoFqqkpDMIizIpDBoqa+PvP1k2sW1BdVXtKm4fjU2Fs/0SmaKfQMQC/TjU7KI9nEY7QjT0XwvM3PF/5hnwyqQLrlkhr8+4301yYZZQ3Aete+L2wNl93QkZTca+k9FtExBMpl3AdpL6hMAL87ahW4YNaDIOVGlmZ+hbkEYWr6al7OCkUM4LtjChsjGSHhAjjlkK3bnu2InCxaIphiPdLfdcxz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri 28-08-26 12:24:19, Shakeel Butt wrote:
> Sashiko [1] reported that memcg_hotplug_cpu_dead() drains the stocks
> of the CPU which went away but leaves FLUSHING_CACHED_CHARGE alone.
> 
> The flag can be set at that point: drain_all_stock() may have claimed
> the stock and queued the drain work shortly before the CPU went down.
> workqueue_offline_cpu() unbinds the per-cpu workers, so such a pending
> work item is executed by an unbound worker on some other CPU, where
> drain_local_memcg_stock() operates on this_cpu_ptr() and thus drains
> and clears the flag of that other CPU instead.  Nothing clears the flag
> of the dead CPU, so drain_all_stock() would skip its stock forever once
> the CPU comes back online.
> 
> Clear the flag of both stocks after draining them.
> 
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Link: https://sashiko.dev/#/patchset/20260828135036.7d44361f%40fangorn [1]

I suspect this goes all the way down to
Fixes: 26fe61684449 ("memcg: fix percpu cached charge draining frequency")

Acked-by: Michal Hocko <mhocko@suse.com>

Btw. is there any good reason why we are not clearing the bit directly
in drain_obj_stock resp. drain_stock_fully. Doing so would simplify the
code flow and prevent from bugs like this one.

> ---
>  mm/memcontrol.c | 16 ++++++++++++++--
>  1 file changed, 14 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index e082aa68fa5c..872115c6b0f2 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2378,9 +2378,21 @@ void drain_all_stock(struct mem_cgroup *root_memcg)
>  
>  static int memcg_hotplug_cpu_dead(unsigned int cpu)
>  {
> +	struct memcg_stock_pcp *memcg_st = &per_cpu(memcg_stock, cpu);
> +	struct obj_stock_pcp *obj_st = &per_cpu(obj_stock, cpu);
> +
>  	/* no need for the local lock */
> -	drain_obj_stock(&per_cpu(obj_stock, cpu));
> -	drain_stock_fully(&per_cpu(memcg_stock, cpu));
> +	drain_obj_stock(obj_st);
> +	drain_stock_fully(memcg_st);
> +
> +	/*
> +	 * A drain work queued before the CPU went away is executed by an
> +	 * unbound worker on some other CPU and clears that CPU's flag, so
> +	 * clear the flags here to make these stocks drainable again once
> +	 * the CPU comes back online.
> +	 */
> +	clear_bit(FLUSHING_CACHED_CHARGE, &memcg_st->flags);
> +	clear_bit(FLUSHING_CACHED_CHARGE, &obj_st->flags);
>  
>  	return 0;
>  }
> -- 
> 2.53.0-Meta

-- 
Michal Hocko
SUSE Labs

