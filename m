Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25E801061B15
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 16:54:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 608BF6B0095; Mon, 30 Mar 2026 12:54:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E0936B0096; Mon, 30 Mar 2026 12:54:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F67B6B0098; Mon, 30 Mar 2026 12:54:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3CEA46B0095
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 12:54:33 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DE247C2122
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 16:54:32 +0000 (UTC)
X-FDA: 84603327984.16.CE30E02
Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	by imf05.hostedemail.com (Postfix) with ESMTP id 02C7E100005
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 16:54:30 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=gHAslx0m;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf05.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.178 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774889671; a=rsa-sha256;
	cv=none;
	b=RFgl6llFwWf4QUPbErRuVnVzxaVLj6lGSBpQhHkWUzR8YF+o/9zyIXYLGD9eEY0GaMBDKn
	aieMkDsmFJGUi9Gu9NeQlb8wECKGg2Lgw32kA9zwehh1NwA8mYZviYvpT0OdzJx0t87/Pg
	7xa43JqZ3ln83WEponk/W1HIzERqUNk=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=gHAslx0m;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf05.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.178 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774889671;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VZuPwKTNPVQjiFtLvrGtZ65+9un4Hd00GfhyViH1PA0=;
	b=KCneHj45AKp3gBmAw0/hpUoGew+kwM+DccZl9AHo9vXr64XAIhQL4YxJxBxr8IpEoiA4xi
	Z/zCBKkS4/o6PiLTI7YV9zfnRg52jnjmvWAma9B2+aBzXbK7NtHT7QbBVFzZJdunxjh4eD
	UT89PHT6jgLEM+3yHZ03FzwyB/wWD8s=
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-8cd8c6e365eso524817485a.0
        for <linux-mm@kvack.org>; Mon, 30 Mar 2026 09:54:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1774889670; x=1775494470; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=VZuPwKTNPVQjiFtLvrGtZ65+9un4Hd00GfhyViH1PA0=;
        b=gHAslx0mZogvahgys3WIb01DkFzpNqce+6syOPS86AvLRGCEyGbJ78nLgHxZ3O2gWv
         54rmwexTVgygZLpXrn8w6bmJ4sijOG7xhAQMLBbaBB67AW0+uW02KxcVaR2/nJX70oRB
         Cypz3/TUh0hebJNhYsQs2LWiQhTvjI+g7FQEYqVH33piaethgNn1xl80lnPOZXhjDl/W
         0OVtck2oeeMxmqPsAuYKwwDK2qu2pY5qxFqmlGRD02pK//fQ0XM+diEPiJ+rywrlq+qj
         UTqvidI4aOBIUwNLFXP3PlYKVcZUj8IFB3LwLhjCmaK8IKauHEqvc13ZHRFkMl6/ivxE
         AyYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774889670; x=1775494470;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VZuPwKTNPVQjiFtLvrGtZ65+9un4Hd00GfhyViH1PA0=;
        b=OL2ZeaVZbnJ9aApXYOfNOnDYqdHCxQe4MKTXTuIS6I4CcH+eKqavI1evhzXbWIIGmQ
         gZP1xVqQr8SGfWXYg+OVF9dJyxub+2j3hWOx1oxd8yiWay0YjhjvDo3tTgDAZpqTFaol
         n4cecOk0NjAW+Ex6kdaMegKC5nikBt8h5PY2hcJJSurR84GwDWllZr7mmAh10uHTC28x
         cwd+SF5RKzwz6kq5EbeQuOsB0XP7p73cVzeXErA+0qSiPz4BykmzwJ9UETqeOvw6/Ngi
         z1BwFv8tq0ExujOmcbvPccX7VMGhus9cViU/AW2iT4fNZazSsj1IklqG9FKqEgYWRWiN
         JhVA==
X-Forwarded-Encrypted: i=1; AJvYcCX4kaYPrG3iKNLy/eiqzYbxpbnbda5ykccjI77914pk3jTjCh1qCDe2sdZ/JZfqpgnyac6X5jmoGQ==@kvack.org
X-Gm-Message-State: AOJu0YwC1qGGVgbvkmbv9NaG05Ubo2Q3io7csJpmfSQ5BHci6Pa/mCLf
	L/0rNlzUM0VSj7C9OsmV9rkIcUEAPyKnxql7BmJtqUrtt0MxtOpolCAkXmdKYwy0eVo=
X-Gm-Gg: ATEYQzwfRO+m9CU9KSxFvIIDZMRj6aQWP6u5lCcBbDIP7me/gjjV1iREiomX/IF3OPX
	mWHH4uVJwuTNDVZBmMLBh60q7jPLZ9b+AdOLLmOueC2oVaXK4SZTTwdDp/yzXoc4ZYxidI2JPpI
	oAy/YuisM+F8wIvPfC+1z0IpMy1xujuS2CdIustaXurpINNxaNT7jSuU27cCzruSsK3w/PvFDjR
	XEwaUd+3+rgocybESQBFuSHdZLJewnEhnWSqnKXcUz9YsP6lTPhk6STvZ6BAGDXYpD9cdJEP8FJ
	xPD+TC967vDk3G1thpIV3KJSbUhCOvAIf/eApXpiyDvADDBFmbCuSMwjLqvcHk9jTusRlqV32zZ
	fe3qutJL5r5hLzpR0/UpglLi0BJkIW1VZ9rFTisKeWpsd+HwUkJuBE/yYsPNwKNSKPtUly610oC
	8hGD/F0ix8YH+U0Q1DV6vpGg==
X-Received: by 2002:a05:620a:45a2:b0:8c6:db3a:3735 with SMTP id af79cd13be357-8d01c617239mr1742558885a.5.1774889669945;
        Mon, 30 Mar 2026 09:54:29 -0700 (PDT)
Received: from localhost ([2603:7000:c00:3a00:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8d028041f8esm659456985a.31.2026.03.30.09.54.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2026 09:54:29 -0700 (PDT)
Date: Mon, 30 Mar 2026 12:54:28 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Yosry Ahmed <yosry.ahmed@linux.dev>, Zi Yan <ziy@nvidia.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 6/7] mm: list_lru: introduce
 folio_memcg_list_lru_alloc()
Message-ID: <acqqxEDgfNOIqBIL@cmpxchg.org>
References: <20260318200352.1039011-1-hannes@cmpxchg.org>
 <20260318200352.1039011-7-hannes@cmpxchg.org>
 <58ea360a-54e1-468e-99b5-57b716026088@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <58ea360a-54e1-468e-99b5-57b716026088@lucifer.local>
X-Stat-Signature: i89yfq15zfmxumx5fzfnkenwbqstkyoi
X-Rspamd-Queue-Id: 02C7E100005
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774889670-77317
X-HE-Meta: U2FsdGVkX1/OsxxX4ZcL9y9FXMBIaiRZuUwFvm/DWfCCh1xrpt+qkXDboxIhBUXqcJ2Tdw8dSNUNjFZNd2hpgZhdD8ChLGbG9UlfQJyGTmP8j5/qvq5USOJKYrplMMUVBGHDqCxgUR53dDBe79Gb1qk3Jscj9zAynJ59XcYW0ElkKuNnBUG14+IESW4VtycM9/PSiBoMZ8MQJWMGISD+bjMJ4+8huK5DDSVVlOJ3oZb5QvatQQ3aR7bUU5TjCX1Dumj/qU6qZ+zTuf3KmnRlwqqlYshUmoAmtz6v8J/nEKjKbrezsiGoihFJE0r9dgqqRwquFN4Ru5rlDXXDM1EyEv8gKNDJUchKFwE+OGmyDbXm48s/hF/OANiLMS3w1oe5tr4TIDR9pE4ttRXCxmgGadZ58Xxn7NGrHR+O/9z4aG2kS2/PeUIrdpVTG8z4veZ3Rzs/h11DDnxFiHWd4f9JOeoMSTIpzcApCqG3/OsUSdg0Kp6Fy4q5hTeRA4wYyHlugeZulDzbEEfD/69yvSCX8ipyaycXY8qJVGhNpwqOy3bcJjDadCdaw6xbrUZaI3Cj9NlWw1pHO1ZXde0Ep3uz4CZ79za4XmuPc9gHn8lY1Nb4T8Aw5GcG7fcTj/zxuT4WCTmI5hTDuQbKlzNeqYpLtd0L1yr76e8P96YHGR4x02/6FK0jeMuPHvCIjpaOmq9/EQdxH4xPFgtUpNfZlxNeToUCvFKXcfWmq6dViYrO7LinJK6qX+qW1+DLp5TR5c2LdEPfd8tqXDC0qvMgr288GzTObp2ctbmVCPApr54MDGPSTfJ4/5w3OxaEWFxDPoSzRmGf2/aQZWX4tSZyQUbfhBhwq6cdQNwjciwK2tStCa+VvkbMGWHhcqLyGOfScVzTDIQLFb5fQDjcyEG1gRodIbK690k6rnJSaAQ6xocF+cjVJ8R6p2KYY//Jb9MyzC0/zh21UX5PTs1YJTGhGLX
 povwLoII
 khkGbmZr6hTSgyUZuX5+Yqalrvqs4CK4E4i3T1b1GU7Uk27fCQxR1YkFgRNCo58u4KptrPPmbI46YGG7dGj0AXNEdUUM8iIZGsYqCEP9z6XyzkfxtML+wS6ed3Dlnygonm9DM3d2ijIdiv9RDNy3ho8MjOUvKvCzfksbUIMA6q2qj07TvUZdHmo2TYVohdFvQS4X2WI+ZNoCz6m9auiC7HShGzoZpFRx1rWF+aask90DCckXQhldcetSKCtTFk3nNlSegsJHHuZgcQl+Zg7aV63F7Jh2RbQ422S0/x8oeUyETd+m/B7pT/xjgP6hd7KpuBksEYkSOZE/4crdgXkSfAM5GWDnsjPUVHMqdCLdGGrbUFWQP7XzziDBq16MNBQ+OwWfIvgyzKJY+0p0k/MrmdEjzPYv+ax/v0Mobbi/dbjKfglKVNJFlWgmTB+FMQkjWiFHIwkntPsRN75H8rYHYYNG3vSsKTIYJHhcArJ3haBsQgQd4x9xcGBVnjw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 24, 2026 at 12:01:55PM +0000, Lorenzo Stoakes (Oracle) wrote:
> On Wed, Mar 18, 2026 at 03:53:24PM -0400, Johannes Weiner wrote:
> > memcg_list_lru_alloc() is called every time an object that may end up
> > on the list_lru is created. It needs to quickly check if the list_lru
> > heads for the memcg already exist, and allocate them when they don't.
> >
> > Doing this with folio objects is tricky: folio_memcg() is not stable
> > and requires either RCU protection or pinning the cgroup. But it's
> > desirable to make the existence check lightweight under RCU, and only
> > pin the memcg when we need to allocate list_lru heads and may block.
> >
> > In preparation for switching the THP shrinker to list_lru, add a
> > helper function for allocating list_lru heads coming from a folio.
> >
> > Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
> > Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> 
> Logic LGTM, but would be nice to have some kdoc. With that addressed, feel free
> to add:
> 
> Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

Thanks!

> >  include/linux/list_lru.h | 12 ++++++++++++
> >  mm/list_lru.c            | 39 ++++++++++++++++++++++++++++++++++-----
> >  2 files changed, 46 insertions(+), 5 deletions(-)
> >
> > diff --git a/include/linux/list_lru.h b/include/linux/list_lru.h
> > index 4afc02deb44d..4bd29b61c59a 100644
> > --- a/include/linux/list_lru.h
> > +++ b/include/linux/list_lru.h
> > @@ -81,6 +81,18 @@ static inline int list_lru_init_memcg_key(struct list_lru *lru, struct shrinker
> >
> >  int memcg_list_lru_alloc(struct mem_cgroup *memcg, struct list_lru *lru,
> >  			 gfp_t gfp);
> > +
> > +#ifdef CONFIG_MEMCG
> > +int folio_memcg_list_lru_alloc(struct folio *folio, struct list_lru *lru,
> > +			       gfp_t gfp);
> 
> Could we have a kdoc comment for this? Thanks!

And one kdoc comment.

Your total will be 8.75, you can pull up to the next window, sir.

