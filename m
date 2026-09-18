Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7410CC982DA
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 13:54:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 861DA6B0093; Fri, 18 Sep 2026 09:54:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8382F6B009B; Fri, 18 Sep 2026 09:54:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 700A36B009F; Fri, 18 Sep 2026 09:54:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 54C5F6B0093
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 09:54:43 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BEE9914067E
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 13:54:42 +0000 (UTC)
X-FDA: 85227028404.15.D7077A5
Received: from mail-qk2-f13.google.com (mail-qk2-f13.google.com [74.125.230.205])
	by imf30.hostedemail.com (Postfix) with ESMTP id DDB2E80002
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 13:54:40 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=EgPalo3T;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.205 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789739681;
	b=NXDveCK5w+VPftdXO8Q+Nw/WotjFGrvXwnRbcWvwAROlGVaRKWOdgmR0phvK8iQ8Gq/ul9
	noHTsOHqVyMr2I6sAzwVweZ28xPJFbvJZ4Fw323NbE0aIF1QExe3DUCg8hsQ0Yhg0FB1RC
	RnuV8X7qryZbPPCo4GaKiQ2Xo5PuqAk=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=EgPalo3T;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.205 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789739681;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JQrKgT91q1ivpfGUE5/zHrleZU+aU6ToiCAfQUtBMlw=;
	b=G0uP5JfLWwHjutgIeovOlaz3y4PFW+Y5BGj0U5Z8DWZ9MTTyHPV2CmXUU/94eevfxjDn3R
	X9JETzeIvAHRXmvrYyAUrxVUnyKMRJwtB/vdpDtrmOXjVPfPGBamIHTdY6j9mS7StpBuDQ
	phKqDvQvqmjy5gpy44n3boT3DUGZp5Q=
Received: by mail-qk2-f13.google.com with SMTP id af79cd13be357-939109f067cso81282785a.3
        for <linux-mm@kvack.org>; Fri, 18 Sep 2026 06:54:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1789739680; x=1790344480; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=JQrKgT91q1ivpfGUE5/zHrleZU+aU6ToiCAfQUtBMlw=;
        b=EgPalo3THTW5Yj6Hhv+INXPeA7OeJsIGs12wi+tqHN4IPV5wxoDq2xaciIpWpYKJgh
         WabcMoImYjNH8HIwMgFkXrLxk9LdhUsGyris85NbjGW34KGfkFhJOTPiXkbJiiZN5niQ
         bNL9jGIie3o9S+VClsTTdwq+2E0vxkzcxfB2VbV4VvYE4zmzdfU6jThnHa8k59YNRoNf
         MD5FqMg4jEeVGRiR58Lx15MbIShEsP/eQe0kEntxVF+8iH+fnz6VScyFdOdd2naMciqp
         oys+KX+2repK/0X83j5hB8JJ+sl+5TZBMrRYib24xguLKcRbU25aDaIGUoJMZUONN89V
         cRuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789739680; x=1790344480;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JQrKgT91q1ivpfGUE5/zHrleZU+aU6ToiCAfQUtBMlw=;
        b=jaDQJ0hyySt0+Cr2WGdo+5IooSfdx8g1Jb/omiK1uXZ82qk4EesJMIH5+WLFggJPJk
         kgYD9AYUR9f/ZFXmQj5VUoCBrAmjOAjmXobANBw6LNfqoIPum58qUh117EYdmL8bue0z
         SJG0F0G/GgGhDp3QPUOfgSDlnT/aHgDhjvuZhD6SCUV6sloRQMZ9aGw1k/whSeR5f+o6
         BIs6nNTsUKEtr+AgDf7MvSE0Y6kcbH0Y74IMhEAgyDWS038rSeubTZ4X5HTV8Jv0cmb4
         BONloMxyZ/cI6yxWTLS898fouijo7r3R/ljk/6G16EHF011GvFaBJxiaGV7suOp1aQvP
         BLkg==
X-Gm-Message-State: AFuF++kk7/66xWunk8u6l2yJDosPM35Mhnk2YtVxc9tR9PQFhLd28T+K
	VPzLPsf/3Tv+5vWTYTID8cOZlacuUaNJ+Bhn3Mpj6ihsSV05CBvDFTyA5YNqppRFR1BpXl1VSHp
	Kpc/p
X-Gm-Gg: AYBFou24lPckRAdfm5GdULdQrT7JBMx/PEllIXhD5seozUWqUNB0/Imw/9sInTKy60o
	UHUuKWR6lNBdKoZ9+7oHODTXm4RPBqnr1EG74Ut6KPb83cSOwQ46jDR9mSPugOf9NYYRFfMsjp6
	uSHBOiN0Q1VHOVPcCBTOHS0MOPwePP8EcE7JVlBnjWwoD3+vXCYO6oN6tw0LgPR8o/bweemMYU0
	x0xvgSZV0D2JngLEmEKKKUawYOqpXrUBUK8iJ9eEwi0imL4oBpLEzqHY59r1xonC1dvGlrivcB/
	Jq8IdO1cFFIzPfYjhz9NrOMpWtTLe5R5AeVQdYHd5yjaCnT7PUoWK+qDAA1aOUwLo03dVLGaObz
	25cx+YEjri+kpD+9Dd7euWKdn6s3syRYEtx1ZiKx4ZX/tTZajW5n18F/yamd/jxluhEgZlwFrJM
	LvqAN2P5sbK3MJ7/HSltj72EB+FTDSz5zE1AyA3Cq6Saq9tyBUPNZdlF6BNS9V0ioUDIluRAs2I
	ImU1rLGWZQQvF0U6aR0fQKnOhEiRaq16TGOWlUHWKXQCvr4tOjATgI=
X-Received: by 2002:a05:620a:2806:b0:93b:d79f:d949 with SMTP id af79cd13be357-93bdca2c16bmr338384985a.62.1789739679965;
        Fri, 18 Sep 2026 06:54:39 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93be0ea6560sm145221785a.24.2026.09.18.06.54.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2026 06:54:39 -0700 (PDT)
Date: Fri, 18 Sep 2026 09:54:37 -0400
From: Gregory Price <gourry@gourry.net>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
	akpm@linux-foundation.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, mingo@redhat.com, 
	peterz@infradead.org, juri.lelli@redhat.com, vincent.guittot@linaro.org, 
	dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de, 
	vschneid@redhat.com, kprateek.nayak@amd.com, ziy@nvidia.com, 
	baolin.wang@linux.alibaba.com, nico.pache@linux.dev, ryan.roberts@arm.com, dev.jain@arm.com, 
	baohua@kernel.org, lance.yang@linux.dev, usama.arif@linux.dev, kas@kernel.org, 
	matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com, 
	ying.huang@linux.alibaba.com, apopple@nvidia.com, jannh@google.com, pfalcato@suse.de, 
	osalvador@suse.de, hannes@cmpxchg.org, raghavendra.kt@amd.com, 
	stable@vger.kernel.org
Subject: Re: [PATCH v2 2/4] mm: allow shared folios to be promoted to a fast
 tier
Message-ID: <aq1A90ltg9Qn6pWZ@gourry-fedora-PF4VCD3F>
References: <20260911001826.2109390-1-gourry@gourry.net>
 <20260911001826.2109390-3-gourry@gourry.net>
 <41b46756-ed02-439c-ab72-e32a84fc7f17@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <41b46756-ed02-439c-ab72-e32a84fc7f17@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: DDB2E80002
X-Stat-Signature: qhbfbfipcy3f9eq3ea8itx5drsmxcqrn
X-HE-Tag: 1789739680-670064
X-HE-Meta: U2FsdGVkX1934HQ5l7Hv7Q5Tb++kOohQMyKMb9lbAHdEzXTvO2bLr4z/Vdsloi43gqy8bpNcmjDXuqUb71uqF59snpLEj5ETune/pYNqYcwzogNI9ggZsBdQl1KDEPJbD0KAnnoOFoJbge8Hlmai2nclfIGfydar0NNDusnBm5be8rIuPFakiS6/HsmuBhvvNrH4QYMJYxcqei62RI4bmRcjyhXKA8oKOUGh9qCdb2nuEoIJ+SF0rnCRF/dGf1z1Sz/V9GaxMpeqCK4o1sYHDM62o5SINicx8DEAqluKKVpqQ1POkhPw1dyJnqsJ1rm8d3qreXeK7/rmmsQr/NSaN3QRbXLmgK3Hxi/BtcJybeK5JPfX9CuYXMKufSdAqJitMDSlJcshSq4JY04tS35Vy2xwGyla+ShrUKrZ5wm+ZJlTln7lSd1zyxCPT8WNkX7hrXO4Q9vYMhX2EICbiMoFQ2ObE5ItzvFarv2Qy1NdrijIBGhYE2AO6I4ggehNteZgR3hVvpIlfEy1l8ZnKnqxIIiBh6AlZ+0ro03zefGa4OJOlJ1AK4VsfQ61JlBOtTtHXHHa3Fw4vnSkgJgmCwnnnS3HE9uFtOYvzOQeHeLE1kNI2b0tECAobppSuuqz+KoxdgR0CNSI+qFs6kOUXERFAGCG/KqoF5ycmue2mmR67dymqUNG1m37NxgJDJ6qmH+DoPtmoeMADXq1vPZCzqqNefHJBX3moJZWdymF2kzFHWT8PJVLS6uIpzPURHGzbe0NEkQgAGi02ccTbHBzYvHt3N/YXngj7Cydw2KLlfUvOnLNGhu66nU6UosEYOWogvh2XJLD2a8d/5KOa/ImThmjfQyjY6MQXk3s9RG1A4rstRu2RcTGEg6+K9+/NDahNS0vI1Sq4TmHtTfwhwu2W/ZGTZTKwmHYw/2cA379OnSscoooHo8CYeTX3X5gnkrUu3qSzmRyNkDZec367ubkqrh
 GTg5J9R8
 PzHqRUzOLs1hqja4QSGpy6t3KS4YNh7K4Qvirf9u/0snVxBuVOPHCz/VsLT31O9y67sdG5kNA6aXmMZPtgeCwlksgiiBG1kTkvkhjU0M7gz7p54pzvOT6Z+uorpQ5ygLMoBvl5Pb1WanJI33zXzY94lN2RVifg6dmhLWV/Q0AMQxMijs92I3KzHyqdty1S08DoDhcJjr4wHNaOuXhaU6byhzRyhl/HOOZet0kImSVjFvfbN4jYbgG/CAGNJk7ETnh5+lAvtKpAJtr4RdHaWTJNxQvHS5i4Nv7vdIJzMJZhL0z06LlCkPueLxgq1qgXFH7yjyvMpnRK3x3HGvs/htwOW/WPDskj6TeY/NGP37/ryOXOlon41D+ODTfT/7aOO7XBhPg+OjeD1Qs7JFdhXhqfdlxhiELvRGSlA1GQy3rg9MRUcTH+/DagtM5o0QQWF5qqN22omS/lxuYjZE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 18, 2026 at 02:53:40PM +0200, David Hildenbrand (Arm) wrote:
> On 9/11/26 02:18, Gregory Price wrote:
> > From: "Gregory Price (Meta)" <gourry@gourry.net>
> > 
> > NUMA balancing rejects shared copy-on-write folios and executable
> > file folios mapped by multiple processes to avoid placement bouncing.
> > These checks also block promotion from slow memory.
> 
> Right. How to we know the direction of promotion vs. demotion, though?
>

numa balancing never demotes.  It either:

1) moves between sockets (nodes w/ N_CPU) (NORMAL)
 or
2) moves from !top_tier to top_tier (TIERING)

Demotion is only enacted in reclaim / vmscan, and has no coupling with
numa balancing.

> > +	if (vma_is_cow_mapping(vma) && folio_maybe_mapped_shared(folio) &&
> > +	    !folio_use_access_time(folio))
> 
> 
> While I understand a "!node_is_toptier(node)" to say "this is a slow tier", I am
> clueless about the folio_use_access_time() check.
> 
> Confusing.
> 

agree, and agree with Zi's request to rename.  I can add that to the end
of the series as well if you like (avoid backport headaches).

~Gregory

