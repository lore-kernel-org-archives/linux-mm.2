Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46718C5DF97
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 13:51:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 184B56B0088; Wed, 26 Aug 2026 09:51:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 135EF6B008A; Wed, 26 Aug 2026 09:51:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 04BF96B008C; Wed, 26 Aug 2026 09:51:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D723D6B0088
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:51:41 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DF8C6A00C1
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 13:51:40 +0000 (UTC)
X-FDA: 85143558360.07.6F16336
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	by imf13.hostedemail.com (Postfix) with ESMTP id ECE122000C
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 13:51:38 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=aDkluJrp;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf13.hostedemail.com: domain of mhocko@suse.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787752299;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AbPejUodpTpH54o/OlTk5uSnDzYs9pRHjviJEkIAHGI=;
	b=GoWQckWemRE0e0LbWUTTmanag2b7dwjuddrxLGatnVis//7M2E64dRryDTjxOrTwSgHVOH
	XBG6s3tQs2lcG+n7/0ITcuiYYVb1LC7rzYDy01ZXFLcJxGnXPowclGAoTOdIEnN/q+65Gc
	uUIVJlLY/L5WX64M+j4Aln7e1HK1IMc=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=aDkluJrp;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf13.hostedemail.com: domain of mhocko@suse.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787752299;
	b=c339QdQzagtacEhONMRiSqWx3TUzGNIFsvdSPvkeYFFrT5WEj/eZeZLcr4RHAK2ez1n7EZ
	vexueHxXcsZGiNxjIzDKOhS4m92JtRRuUV8br+jXwrfMPwaAtHiYpNDviMoCIWXhznduB1
	Q8hFjUEsT09WKYC5/c+jijP5a5kGawg=
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-69c108fee7fso1604377a12.3
        for <linux-mm@kvack.org>; Wed, 26 Aug 2026 06:51:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1787752297; x=1788357097; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=AbPejUodpTpH54o/OlTk5uSnDzYs9pRHjviJEkIAHGI=;
        b=aDkluJrpMMbbHhLPFIB+TQlq3VoBejDtDdycKN67TzBs7OpXauZKxwNTpTE8ZrfOjk
         KwltRMuoxabxqRWC+T2g6CPn552qDq21KA1BFEvWgoMkOqZd9nOR472RPXibHxLh1Srq
         d4zLa+KfCbTzyy57kmVa3qvZLH84CFUNhT7hnRbkUH8Xpl0vsImU5rKQx0/T8xNe/7QT
         zByuYaIrlQLr4ESMSl/nGRshYpKNRl9oPWkh4PSfktYNyTGpvSrYo+YysNWdmI2lqPch
         TrL+FPnq5BaXerojOJA4W6S8nX3zTz3ZxQbFnn2J3bG7TFidpzYLhWypTpskdzEpw4/C
         fRLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787752297; x=1788357097;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=AbPejUodpTpH54o/OlTk5uSnDzYs9pRHjviJEkIAHGI=;
        b=f6M7hHP/oA1bZ/3V+tACzidagC4os+YfA56bU8yNjO66j7R3XTKVd0DhpyRRQyCfho
         R+TzxF/iEaXEL2pafJd/1gj6IxSqJLTHr4oGYEsr7agxEei7JnwMla48upaE0wav7YTM
         5rFIBh0X64WwrebgSWl7CIT44mZn/b5+hMT9cTjfrkmX4fdsDBAhxChLdWUcTdH2/3kz
         PUHg3Qxp6S38GSH0A9zKRc27Iwhmcjw0UAL1PdMowZlArPzGoBTtslHIouYCDHXZOAQ1
         UCuD9nRzVPeqRX1R8t4sbH0n9ee31EUyjx5KpNswiZYdedzj+S0O31cdbzAGHGaThLEX
         0/SA==
X-Forwarded-Encrypted: i=1; AHgh+Ro06CAOMYlRSEhuIcDMHgFP6fdo/tkWASy050oSonYcXrS4c2o6JEJ5/eRa4bxSszFBDYgEXzs9OQ==@kvack.org
X-Gm-Message-State: AFuF++kVQA12ztgX4u52VlqXowpPMQbKVt/bzIyxrteFCdVeOQbA2YNQ
	GHe4CoHYIM3etEwNis7Pn7gKTmGDhKv/2U5goynMR9WR3q5ix7wNodjCS26momP1R7Q=
X-Gm-Gg: AR+sD11TpG+dVkEF4DTFCbrs1u4sYhMmET30p+g994MnMD4+u2+LgswZrb5GmcIx8LO
	NW+6Gg8GAkm3Fjq1Yuq0Uhc5/AmZt+WoGrWlNN5pniBDFDzvKDTH+fZS3Xy1CiPPUJq7SzSRUmg
	itXBPfakGu3E6qRiQ19UuR5OPodQV/TtpOIc9fcfj4w79P1LAg8Cudpl5vwDyAt1rrffXeOkFAu
	WmdDTep+87Obg8IAk6NHbH920d/2DEcxHMFj43t8kkukQ8HNl36f7BLlRc2EoVtOQWJcHOomz7E
	t+KuJX/CzFEM1A6cykiJoLuKVh1D/8/KYBMVuo5HC4MharHenqf1yIHNXbHEVCXlQ6Mh/WWwEXN
	nQazkxcIeWPv8iBofVhTwioMfUlyK1XvNpskLneVBgHrPETfhEKx0uSIFw+1Rzq0dijq3NTaJbF
	7iIQ29ePeD4OCgHtLz+Z5zNJtep7z4gAmNF1RPSygddFtXqkHDNc25UQTgBlcDraHOK9Q5wlt2
X-Received: by 2002:a05:6402:2108:b0:6a1:fd14:8832 with SMTP id 4fb4d7f45d1cf-6a5df64107fmr9294664a12.12.1787752297409;
        Wed, 26 Aug 2026 06:51:37 -0700 (PDT)
Received: from localhost (109-81-80-32.rct.o2.cz. [109.81.80.32])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6a5de8d1c80sm3494104a12.10.2026.08.26.06.51.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Aug 2026 06:51:36 -0700 (PDT)
Date: Wed, 26 Aug 2026 15:51:35 +0200
From: Michal Hocko <mhocko@suse.com>
To: Ridong Chen <ridong.chen@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@kernel.org>, Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Ridong Chen <chenridong@xiaomi.com>
Subject: Re: [PATCH] mm/vmscan: drop the combined limit gate in
 __node_reclaim()
Message-ID: <ao7vZ8EBHgU_CRpQ@tiehlicka>
References: <20260826124409.35569-1-ridong.chen@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260826124409.35569-1-ridong.chen@linux.dev>
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: famudkqop8j8jcwn5amt7qx69krcn1qx
X-Rspamd-Queue-Id: ECE122000C
X-HE-Tag: 1787752298-100801
X-HE-Meta: U2FsdGVkX18//Ga+Z8011c1+9qU+gtf+nt4Mk5ibvZ6UB4hvXqH0xZGQU2ov2Wi+rgBzI1yCB+u7pvO8VV/ypuC2vNzc1QLsDvzMKQWZJDd1oiWap7ghXalZXW6WzDXu6Bq55+jY6RXtaaX7CqOgR16tuu6dYQX/61kD99wRKQtAXBVKNHz+1z2c68ftC1YJP+fyvLNOUJIO2vagVUq67NXr/fSTFvcn2R5vB0ftI91ewj6l+qdxnlIsNxbdX2vCky/qLavvtuP9dHJxS8nuHQqWpeMI8PPPtsG/zVtG5N7d45rIiDb1z7pgXUFcE9yK47hY2mnzBTt7kOeFkUKy+Wj0ETqh5Mrq+0iyC7lvA1eCQzdHXDV1V1Sxhzwfrcy4JW/wwxG46vQ/24AiAdRg9nKfb6c/mmUcd+aApERPIDh3ZKgwbQ2gl64R/QRJ2QHW0j+SHTHix64GrarBeD3R6lhYwmaQpIqRxaq5SwW1JNvJ5kPmGbStoMxaHf6QNAK+OLqhWn4xgEAfVhlLaBwmcWZ7xEAJSKsXvcN/eUIxL62yrRB9wDrVBNkRvJGU0aqAYKgLcTcqLQf5z9zOG2DP+k3xmBPcP1ttAGT5a2Jp0yh1D+p8iop1kEkq9W4m+H3CtOAMZH/MqwaMocAl1OWG9fMf3G1L3BiyL+fUM/Psq0ZZntxqTgWkBCIvHqzZmb9H7BJsOnBWfj2MOl7NADpT5eacqM8eYbONqYOEwLtXEQTI1arAZuNptWIHEzFOk66i87P66sga0Vsxn6fH3X4rhYygSV0ieLrKlhqLGROOuymi7v1tXqrlO0LIWdbaNHToCj5kSpiyh+lTV5x5h2qNPcaElQSgaPfmfbGjNSNm/5k4jXOiBsf2UBJyOzGSdYO2NgLwYVFjkm4PDJGMW996mA3//vB9kAlM6K9ksuaQ621O6t8XcWi1MXbvi0G45lSBKVby+Oosd1REojxIscN
 /ydI79Sc
 MS8ScZObTJi+h2fe3zYt9H7gJQ5wFmxbvAHJjoKSVfmh5m+RQuhvpF8bnjyaQE8KwE9dg/AxLlcNSVC3GyHH2EbBZ1yoWnxjhlgLon+9gSlHJqSgXjPbphRlpCp3/mHRYm/48sl02QILhbVFK1UfLfUYWis8wpo/jcBTIdt6rmHJVVxd3qUtCNFlT/oKHW4hFAnxtNivZLMhQ1laW0QN7p8Hnz9Onr18ablcacUj46ZoBKt9hrFn/36VjsJBaFXeTMIjQlCHJKDbU/LLWUuLElP935/xEbGkMHq+FTagOQfK538sB58Zdomr85BSniXoWTaCA5YNC3IqQobG+n7IxvLwcd0CYDw6aiFR7//nDp3sQhhnvDuxJMeaS8KCN5etwYriFVWeirIjsYBUAyA6D69t08wO3aG0U5Y2ny/LHt6TfmN2irTaVwa/GnPClFudjM0NqHl3gdY9zGe2i3Myhwyl6oHV+9WDYzoiMEjk/b/tusBEve6PQClzvxINAYWipPU/piNftZLj6Tb++hG00slywN9hBx4I1yw4PTpsJO2GkqeIjXsyQhBRhry0zGbU6XWS0XPLCB28IwYIDaF3Ezg+heJNelMAbCdUa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed 26-08-26 20:44:09, Ridong Chen wrote:
> From: Ridong Chen <chenridong@xiaomi.com>
> 
> __node_reclaim() is called from two paths: node_reclaim() and
> user_proactive_reclaim().
> 
> node_reclaim() already bails out early unless node_pagecache_reclaimable()
> is over pgdat->min_unmapped_pages or the reclaimable slab is over
> pgdat->min_slab_pages.  The identical check inside __node_reclaim() that
> guards the shrink_node() loop is therefore redundant for this path.
> 
> user_proactive_reclaim() is proactive reclaim driven by userspace and
> should not be gated by the per-node min_unmapped_pages / min_slab_pages
> limits at all [1].  With the gate in place, a proactive request is silently
> turned into a no-op whenever the node happens to sit below both
> thresholds.
> 
> Drop the gate in __node_reclaim() and always run the shrink_node() loop.
> The node_reclaim() path is unchanged, since its caller has already applied
> the same test; the proactive path is no longer wrongly gated.
> 
> [1] https://sashiko.dev/#/patchset/20260723045718.2052070-1-ridong.chen@linux.dev
> Fixes: b980077899ea ("mm: introduce per-node proactive reclaim interface")
> Assisted-by: Claude:claude-opus-4-8
> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: Michal Hocko <mhocko@suse.com>
Thanks!

> ---
>  mm/vmscan.c | 13 +++----------
>  1 file changed, 3 insertions(+), 10 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index f11491ee9ed5..6dff207ad8c6 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -7851,16 +7851,9 @@ static unsigned long __node_reclaim(struct pglist_data *pgdat,
>  	noreclaim_flag = memalloc_noreclaim_save();
>  	set_task_reclaim_state(p, &sc->reclaim_state);
>  
> -	if (node_pagecache_reclaimable(pgdat) > pgdat->min_unmapped_pages ||
> -	    node_page_state_pages(pgdat, NR_SLAB_RECLAIMABLE_B) > pgdat->min_slab_pages) {
> -		/*
> -		 * Free memory by calling shrink node with increasing
> -		 * priorities until we have enough memory freed.
> -		 */
> -		do {
> -			shrink_node(pgdat, sc);
> -		} while (sc->nr_reclaimed < nr_pages && --sc->priority >= 0);
> -	}
> +	do {
> +		shrink_node(pgdat, sc);
> +	} while (sc->nr_reclaimed < nr_pages && --sc->priority >= 0);
>  
>  	set_task_reclaim_state(p, NULL);
>  	memalloc_noreclaim_restore(noreclaim_flag);
> -- 
> 2.34.1

-- 
Michal Hocko
SUSE Labs

