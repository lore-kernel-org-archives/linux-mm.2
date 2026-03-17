Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 510F6F33809
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 07:52:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 475046B0005; Tue, 17 Mar 2026 03:52:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F7B76B0088; Tue, 17 Mar 2026 03:52:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BF9E6B0089; Tue, 17 Mar 2026 03:52:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 10CC56B0005
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 03:52:11 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8352459592
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 07:52:10 +0000 (UTC)
X-FDA: 84554786820.21.C92D8DE
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	by imf21.hostedemail.com (Postfix) with ESMTP id 240D81C000A
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 07:52:07 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=U6riK6Ms;
	spf=pass (imf21.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773733928;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n/b20VSj/vonhlO+5Zs+LrVl9EfSXfCxpUpB194z2Ns=;
	b=W3xxulXZc76iXBp+PGctLSoDNmgpfc5UEl4QS5FW5uJP2XPC7Vc29bnb/tt1kT5u3wva6P
	OZpPhB3KljojFoDtVa93ljBKBRp5n+jR2dLecpVS74/VwtH7PH27i4iem1MzG/IbwOuFi3
	WKfHNFdMLgHUHajc6DPd7Y37uKd7KVE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773733928; a=rsa-sha256;
	cv=none;
	b=VWLZYImom+9o6+NMH1HqpdY5t3Ymwtqr22a6tj5TOVC3lT1PZgHAzzvQyWaom2SmxivTRc
	mnlk5Qljqgkgky2HGT+8Ow8c+CPWf93L5zX5i0PznQIrEEmob4FMrr4W8HvT6v3rSdrrmo
	G1kJrjYFYH2liXEdyVQuK5Q8kUIbkPw=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=U6riK6Ms;
	spf=pass (imf21.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-482f454be5bso4586195e9.0
        for <linux-mm@kvack.org>; Tue, 17 Mar 2026 00:52:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1773733926; x=1774338726; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=n/b20VSj/vonhlO+5Zs+LrVl9EfSXfCxpUpB194z2Ns=;
        b=U6riK6MsDTgWYDFLb8Pgj25SMpHxPb4XV/ZamY4sQOSrQKk8KMaZP5e10px0wImQiP
         D1PgB6wrVOd5LD93nqkOAElEvt279zXSId8H7NFfYledgRPKlQbTDQSImmvzNpa4bbsu
         n+XVih+fsPtg9DBg/pT5uois/e1VCt/zyrQUp6d/1FfVPRJCTm6KSKIkAFqWdJhl3COX
         xd18ePxUwKSmTlXc+svm8WIt6XXdkOapI9/YKjOvC00Z57IP/5p52ykWWkoHQHvOGhOw
         l/rZu4A2mIEC49BnN9ZpNcgZ7y87MUb5Al7cTvVc6lBOxtwObiHJpmbVyEHJ6ykEUpDa
         tD2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773733926; x=1774338726;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=n/b20VSj/vonhlO+5Zs+LrVl9EfSXfCxpUpB194z2Ns=;
        b=G8q9+zgj9Pv3ReIBmf/iYoO7FmoIJevQwyxJ2fdQojBep/JeHbX3S6wRzw6P9qlLFm
         LBnURNTBc4AHzHn8FjVt6rVWG1NFci/A3SfEcxgy1JYr37hTARTL6lihY6qKKmwy6EID
         zLhAAI/GxuMZc8Nb4asMJazIkixbIyonAKX6ZyOH5BpdLI0rEnoPYyg00jiVycrtpKBC
         wmlR0RIL4xjo+DlmWksziNaHskewxNT98R6efq9R+VtkbyWQWMtl4KtM/qEuDqFavOs7
         KYZulCv87iI8vmu0JpqQtclgNr4hgOqNc9yywAmkvNvOO3CXwvA1CbXEcEFL719sfkSB
         dsZg==
X-Forwarded-Encrypted: i=1; AJvYcCVZ0kEBoKax/3VtyVJHcs9XvtQEX3Ven3I6FUt8cV/VlwQ1rRHDD87HamhrVLKa7vrdw08SavdP6Q==@kvack.org
X-Gm-Message-State: AOJu0YwVOvLQ9SPurmWzU5MgeBQxTCVZflpd5RZ3v6PiK1jUvoPIXTRY
	kNvdP9Bma7PNY8pQvHQ84UVV4X4wWLKADX4TEu/w0iv9cJyd9q/6xAcwNjz8kRZBhuQ=
X-Gm-Gg: ATEYQzwXLR/ygsJG+vOqZmhwgKci9SdRdu7TKgsvilfLjMPjgtp92J+dgjfLVANCW+a
	0AzbKFx7sQui/h1kzVpiJjh1JjTof5udKQCmNnycSAjPutHc+V3YfZQSK8xEdJW++dQk4qzbO6F
	CH2baG9I2FIpX3v3npoqYbgumZF3+Mc1FvhfbprKC6AzhCswaQulVaPwyo7mmj1LB8dy6dPkmwJ
	ADGSSy/Gqpr1UmaT3e0qcOzd+CCkX4Exqb3G/F6+oPgvg17odf+61NSMJ1bn2liSbEvHwLqKHa0
	KaQE3DYxIRBfBD+VfDV5KF6lPQvSD3fmGx3YKkZz1y3yJFo7Bzi3FOr0cPF79iC33Kh5Sa4bMgW
	peiDzjW1zvizkaLwU6hSsv+Hr7cyiRHsnwCL03nBiNhBttc1eH2IYefY9g215yK8sTmut+BH0Pe
	k0gVXTEI6lk1ETE8TYotMtJTYp2mvSth2kuqag
X-Received: by 2002:a05:600c:3b08:b0:483:6d9e:e4f5 with SMTP id 5b1f17b1804b1-4856eab4fccmr35026255e9.5.1773733926431;
        Tue, 17 Mar 2026 00:52:06 -0700 (PDT)
Received: from localhost (109-81-21-195.rct.o2.cz. [109.81.21.195])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48556415294sm117998945e9.6.2026.03.17.00.52.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Mar 2026 00:52:05 -0700 (PDT)
Date: Tue, 17 Mar 2026 08:52:03 +0100
From: Michal Hocko <mhocko@suse.com>
To: "T.J. Mercier" <tjmercier@google.com>
Cc: "zhaoyang.huang" <zhaoyang.huang@unisoc.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Yu Zhao <yuzhao@google.com>, Rik van Riel <riel@surriel.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Zhaoyang Huang <huangzhaoyang@gmail.com>, steve.kang@unisoc.com
Subject: Re: [PATCH] mm: remove '!root_reclaim' checking in
 should_abort_scan()
Message-ID: <abkII-1MZ0kTjV2-@tiehlicka>
References: <20260212032111.408865-1-zhaoyang.huang@unisoc.com>
 <abhh3lKb6med1LSp@tiehlicka>
 <CABdmKX3NUZCq7kq5PGWOUs1Wmu+aT+EfeMpcRxD8PxiRe2si0w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABdmKX3NUZCq7kq5PGWOUs1Wmu+aT+EfeMpcRxD8PxiRe2si0w@mail.gmail.com>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 240D81C000A
X-Stat-Signature: t6wowzpawbg1dxd6gg7h7qnpxmabrg6z
X-Rspam-User: 
X-HE-Tag: 1773733927-840026
X-HE-Meta: U2FsdGVkX18z+40fphCDKvHhCYV363Z33QSr/JxpjDdyBDIEN5xwuzx1QGzVefJqTWWIvOzqvR5BpCm6p55cC5enX4ZSk7oVqR/SxgqwzB1VUfxQaMTHIeJXOinpr7LFiN6z0iZ8mavzAd5PGQsEJAOVY8sPDkczhrgha5LO5nTgyV+0Zf2IPcStz20biaOwj+CIOrdWsJ9akyJauuyH30F9aipL7UuSSEBdmM/E8+0c02ZZKwJirnpqnneLId8eTAoFdveOmToVzEHA0yOmK+LqKyD8OJBdsLv6rO3sY6aqzdiw8e7LBVdssp8MuItN9geGpCQY5ELL2g2bEmU6L9XFod+AM8XDCWQMOaEFwxAP7OL13S7ZiHTD7tsfp8NwWQ8Z6GlncljCeH6X8MV9b/ortHFgxTCb0uijUnV6Ar9g1ssgtgskOJqURhTn5JKSbcdHCBJLkeEMltxlzk36QCRqIR31S1dgVM1/ao8MYLC52RoCHzMYZdbexUhwo5cVRKn4lJMiTkdrfJfJB/ySlJjZU0SQ5JyV73b7GCmmOWJJXL+pL/1d1vbzO84IC2+ooUo6P96nNnRxTqEUt6DZyIWx5eW0+0Ev9XEAuMt025kbe+/MWHXsOJZDcWTNjUOqlId0SrHtCyfiEsSU4p3xSX3L8Pgr+SF+rtAOYDhg73WSg5xT3LCwxMg6T+62OqSk60M35sVhX8fvSaN0lCrjxgC/gE4OCANrOqrX7t+G3qgZogm8Fg2ZBnxNCbVQtiqAJ1Ui2QFLmtT1ZodROG8FPJ6sH3xzXpmWCBN40LmsAOj03Lb+rUWJMADDsTSV88Vk8zoks3t9tkLsuJX5yoV31gghKLKOugTLZiWRMvnFr+uOAooVYwBVyfJtwfvtwrWbiTHa4DD5yI1WhxYpzZoBmGEWzn2OSQ8QSBVzA4MrkmnVEbEx1ozlVAjaGdVj5mKWKtyRG9UmS+pAIKnI2zy
 G/FiJirf
 qzzJc9HBUps052ysNV9OdphJnqp1ZrWK+1Trv5nCS2GK5UDKXekLGvxtwGIBCVPQllSovSTT5yYLsSRF1l2KRGHVgE0vUsHK3hR5BCY7mGCyUEuy0y6WgNxdyDS2ewEniqcIF90pauwY1cJqdajdqiJEaCBOVq51cYpVu73X9AOUPR9fNuNmJqRn0bqLOpfgCvvLVbwsNCN5YpOh29D8FA4jfWVNX65kU3wDovJvaCmxHwJevoMSYwWvtoh3uFc65X4FXtmgT0qsLB72kPP0Y5nv8uxpFsM5WhMKWSufcIqhRi75jkh11QFiKBEmxbLRs4RBejHDfXBSTgWiIlAWfBeh/u+duM/6oLX5DbMxGG0wpv87oUJxRl9YBAG5xLua6JxWI4ZGVotIoWjAhXZC9Rc2Fmmpc0EEGvubsSu2oaGoiJNEU8vhvABsJzMGEv/83VB9IzBNDcuVWVArEFZdF8N1ERXwmEbeXVr4ndGVmR1bd/M+gP6KSBKsEORXCeF9JHafHYspwBnY5GhGKDo909YpovDZU252JIl5Dvt2T3hGj42OaLsMETlvY68i+30kaDiyBuqj7+8Gf/JUDYNepU30WHDI5JfWou2dw0rvT82K5asXTIfD4lkbfE8p4BojoyMBG/d1cnAEK9kLoT0DzrycX6OXfrm4HR6s2hEVdQu2GH+HvLESJ+5CqiJGNmfr/6gnq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 16-03-26 14:09:52, T.J. Mercier wrote:
> On Mon, Mar 16, 2026 at 1:02 PM Michal Hocko <mhocko@suse.com> wrote:
> >
> > On Thu 12-02-26 11:21:11, zhaoyang.huang wrote:
> > > From: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
> > >
> > > Nowadays, ANDROID system replaces madivse with memory.reclaim to implement
> > > user space memory management which desires to reclaim a certain amount of
> > > memcg's memory. However, oversized reclaiming and high latency are observed
> > > as there is no limitation over nr_reclaimed inside try_to_shrink_lruvec
> > > when MGLRU enabled. Besides, this could also affect all none root_reclaim
> > > such as reclaim_high etc.
> > > Since the commit 'b82b530740b9' ("mm: vmscan: restore incremental cgroup
> > > iteration") introduces sc->memcg_full_walk to limit the walk range of
> > > mem_cgroup_iter and keep the fairness among the descendants of one memcg.
> > > This commit would like to make single memcg's scanning more precised by
> > > removing the criteria of 'if (!root_reclaim)' inside
> > > should_abort_scan().
> >
> > This changelog, similar to its previous version is lacking details on
> > what exactly is going on. How much over-reclaim are we talking about
> > here? Is this MGLRU specific?
> 
> Hi Michal,
> 
> This came from https://lore.kernel.org/all/20260210054312.303129-1-zhaoyang.huang@unisoc.com/
> 
> Zhaoyang would have to provide numbers, but yes this is MGLRU specific.
> 
> > Why doesn't our standard over-reclaim
> > protection work?
> 
> "there is no limitation over nr_reclaimed inside try_to_shrink_lruvec"
> This means that for proactive reclaim the check for sc->nr_reclaimed
> >= sc->nr_to_reclaim is skipped, because the !root_reclaim(sc)
> condition is hit first. So we never abort based on the value of
> sc->nr_reclaimed, which can lead to overreclaim.
> 
> For try_to_free_mem_cgroup_pages -> shrink_node_memcgs ->
> shrink_lruvec -> lru_gen_shrink_lruvec -> try_to_shrink_lruvec, the
> !root_reclaim(sc) check was there for reclaim fairness, which was
> necessary before commit 'b82b530740b9' ("mm: vmscan: restore
> incremental cgroup iteration") because the fairness depended on
> attempted proportional reclaim from every memcg under the target
> memcg. However after commit 'b82b530740b9' there is no longer a need
> to visit every memcg to ensure fairness, horray. The problem is for
> large lruvecs, the lack of a check against sc->nr_to_reclaim inside
> try_to_shrink_lruvec (caused by the continued presence of the
> !root_reclaim(sc) check) can cause overreclaim. The non-MGLRU
> implementation in shrink_lruvec already checks nr_reclaimed against
> nr_to_reclaim.

OK, this describes the underlying problem much better. It should go into
the changelog. Including an explanation why MGLRU cannot follow the
traditional reclaim bail out logic.

Thanks!
-- 
Michal Hocko
SUSE Labs

