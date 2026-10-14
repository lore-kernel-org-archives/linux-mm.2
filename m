Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C162CC6B1D
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 12:35:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0CEB06B008C; Wed, 14 Oct 2026 08:35:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A5766B0092; Wed, 14 Oct 2026 08:35:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFD2C6B0095; Wed, 14 Oct 2026 08:35:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C17636B008C
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 08:35:15 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 454B6A0554
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 12:35:15 +0000 (UTC)
X-FDA: 85321176990.24.636E13C
Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	by imf06.hostedemail.com (Postfix) with ESMTP id 68BE218000D
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 12:35:13 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=DnjAVCAY;
	spf=pass (imf06.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.47 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791981313;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QmQpU9PI8un7KuCGa3rKdlGVWqm4zvZIc3vocEo9k9Q=;
	b=8BsxppIOsplVEn2y4lRcR45ZS0XDL+JVQy76ib0ZkIiEyF1dsLjksF8Uqayx1WZSZKt3px
	dyK6vFjLumOV3/AnRSatDtjCDL1GwDmSREUb23WpcqDfQIMMlRX3ATQw9bbdTbn92eJ7bl
	HTmxUQTEnU1eOwK37krHkynm4U60ylg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791981313;
	b=iHgXRd4sXNEqwK+Cx2cp96hXdeUAmsAL5ZbAZH4zC2iVcmUHc9odf60qHo1EDM4mVPcz7u
	+6gpDnmrt9Pl71A43y9BHh7o8oWYoAX6U7QP98RuPhF29rnpl5j2LMVS74joxIXLPuWwT1
	Hp/ccPG/1GF6R37Rkvdpj+h+BbR1mV4=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=DnjAVCAY;
	spf=pass (imf06.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.47 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-91bb5795792so2200096d6.2
        for <linux-mm@kvack.org>; Wed, 14 Oct 2026 05:35:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1791981312; x=1792586112; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=QmQpU9PI8un7KuCGa3rKdlGVWqm4zvZIc3vocEo9k9Q=;
        b=DnjAVCAYNq4Ni+Ijsv8DNS3fOXcYvVi73Z+icTTBe1SYUf7aitotJhabCjEhnSTRLN
         sG8qCwDdUwk47A4KX3O3Tda0SepdXKrfgoKIX1S8dtrvAF6ic7RE6BS6/gDdoJp93oVm
         7Pt2kjKoSe45G2IQZEhqarNBjvyHMr/f/edj0ctAZFXwinfsRdpHHITpYO7tsaAni9dJ
         fFqmlIKbiBkQV8q2odSUXgu2VFHkFMcbzET7WHJxtrkI32Gbe+Yd3FjoN5rqYTD/8ldb
         uIloOPymL8avyK0ST0wCxSZ44m9/jdhF+KK1weS3l4jXUMGobllp6zHRK1EJvxBHCRPt
         QSkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791981312; x=1792586112;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QmQpU9PI8un7KuCGa3rKdlGVWqm4zvZIc3vocEo9k9Q=;
        b=If+FslXQiAbozEnC4kF4RbI2lyluBb+w+5rDjjgjjmkb88yO8RZQZ5IanMMKk8ZMbu
         vtlDdUZhmOVwYkYn5KsT2ZwQnRpjHcfdFYSHJeh0DolMsEDSrOdG+tkLdsLQBZ1N/HjF
         NzBSkyyKLYItHYk8RZ4vA0ibhujQErNqjVSiGSpdmOHoPGXkGxTboHOuD6b8KLuTC7nN
         ZDLaull18/wPr2qi0KKdJxfGCwU1177h+75o8GSYYqwy43VP20xFBSu2Tz5vZVsSiXM0
         kA3UctoL1UP+JwkbHAaUb+IgO45PajfyfPRIYJmQ8gyqp9LmTrPIlYEdN1VpApT0GMkG
         0jSg==
X-Forwarded-Encrypted: i=1; AKwUvBwO7HsKqMV5R+YZ+Gjrk84oqtC/Jf+thX0qRzCoedfar7WcQ2Ypenf8+pjYUj6N6IKfOgg3amEeDQ==@kvack.org
X-Gm-Message-State: AFq9FYLkEIAgUIAJr3xeJs7uTW5dH2tpYCrHDHM1jA9tW2VNWagsdJSB
	zwPrRwnib/L0Sk3T9LiUgoCvqLsaz+ysif87jck/VS6stV0qlYpB7YzIWxJBorWrFfI=
X-Gm-Gg: AYBFou3ar0K9viUOO6a6RoeXAsSwJg9zrZLILcJvUqGnwDMBD/A8P0P7I3ZlUyep7xJ
	ymbwNvEl554hVxj+zNZXXeahENewFBHT+88sSL4XAogy9tHY5ckkcoEW2Os/69MBDfnHUkyoKSk
	h40OwpUC4OCT4YHoI1+2awvVyrB65ImilL635otMnPGvE4JD0lTeBz+hAETI/JxPcrVMhqIWDUd
	KtYeGMETxlLC7ljNRH9qEDO4WW1aNWJ6PK/LXcNKaMvGfTpzioJ7yLsRy8S+ZVNeibI1SWO6L54
	eWZS8tuqv7C0sVfu/lozhBHj98NYKVhFSWpHsAjyUKtwLUEwaEZA/LcWjapicGObHWYSc6Yo2bw
	sbiuigmikf7S8K87W+2syANFCkrQgQpPLZyCZdrjEHh60Ud0hcdCEMk+p5Yk3HEjTdMKbboXnca
	kaAMMoeHrWQ2Ynqeggcf3I7gS4t3a39NcVL8FkmQKsgnlCo9B6bix6zIbHnY4uUoXsxdN4GG7gG
	ycjGrYU0UHVWDsR4g+wtQiwWIqFTuM8jVu8CIDNKS9psmNBwQwS21aU
X-Received: by 2002:a05:620a:d95:b0:93e:e376:9b1d with SMTP id af79cd13be357-93ee376b37cmr1452850885a.9.1791981312473;
        Wed, 14 Oct 2026 05:35:12 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93ef502608bsm483806485a.25.2026.10.14.05.35.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 05:35:12 -0700 (PDT)
Date: Wed, 14 Oct 2026 08:35:09 -0400
From: Gregory Price <gourry@gourry.net>
To: Yafang Shao <laoar.shao@gmail.com>
Cc: ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org, 
	eddyz87@gmail.com, memxor@gmail.com, mingo@redhat.com, peterz@infradead.org, 
	juri.lelli@redhat.com, vincent.guittot@linaro.org, akpm@linux-foundation.org, 
	david@kernel.org, tj@kernel.org, hannes@cmpxchg.org, mkoutny@suse.com, 
	shakeel.butt@linux.dev, roman.gushchin@linux.dev, yu.c.chen@intel.com, 
	zhao1.liu@intel.com, bpf@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 0/3] BPF-based per-cgroup NUMA balancing mode
 selection
Message-ID: <as92ra-Ko2c7OdRS@gourry-fedora-PF4VCD3F>
References: <20261012120438.52849-1-laoar.shao@gmail.com>
 <as5RFhW1Ch8ta5nZ@gourry-fedora-PF4VCD3F>
 <CALOAHbCOTSOPTzoSqKoBJZ56o0pfW_dGQ7ZM_e1jT9N16z3VPQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALOAHbCOTSOPTzoSqKoBJZ56o0pfW_dGQ7ZM_e1jT9N16z3VPQ@mail.gmail.com>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 68BE218000D
X-Rspam-User: 
X-Stat-Signature: oj6o5npf1bokub7haksrgi36kbmjdscc
X-HE-Tag: 1791981313-843220
X-HE-Meta: U2FsdGVkX1+erWi46PlCtwjeGQzgqEj4zSF+AHxMUkPriUIgXHNwfLumfaKvIN9sVI4n3SDeGn2d7pib560hFh9S0at0uadDOlLjfa0XrSypYVWuJ/w8UmQ6i4teEHRqaB2XPdgiQrD/diB0owOKhn2g0WFFHCDtGprO17sMDVCcJcGcFOxQrww3isug0n7YnPxWLn+mz7gcKQiYfyonnZTmK45BGUvxfsMvGxrOq/c/D7EiZTHu/cdpPcomK14IWPeu2JSARoFWnpwEnElGB8ZgLZr7lfY8TBQHdONzSmAQm2u6Gs83mjBvEzczowKpXc3V/cZGRN7Re+zFm39tUkdm2waDZG0wuF6DoQ7E5GoWJ164vqAvJEjW15QLR4wq3PlMApNaLU6bZqNe0E4/J4VM8FuKXwzzp3UkZm7iSMz89FxKZu0wy+lUOfyCO5mc0xF3POq/pHl4wQNXiOP0FvleEB6NOrVW+hDCQl/0iTahbiFL4g8F5f1l3fL/sze5WmJ9SVmu/Ptv9iwjgXqY2cef8tuRasT9KlIRH5RNjjE0Oqk/UuhPCotbDPH3RyUzHjVZm79mk5etp60K1R2ER3soUZ18s7U/FYJUExf6KqmEucPvCBSgO2CM2itQzf3Oh+bpEp0+49IXjQdfdT2xWsFBd4oQ7ncg0SQAINPqbOw74axJxcu9DyFpoJG3WsCG+heSGo4us27t/l8uTLMbUJ8sVRRhtw2vlctt37cNEf370oZYAJDfv0mzcFYnZfdOYSDBbmu9lGxcw4saXq0fgXyBl+frpqXkILtSFQicv/qkcIdS/N9p/RCXSbS8ZmlWwn+FUPxDafPa4QsH/EPqLm5N3G6NGCvnAkzyuiNIzvhKdEicRyGVSvJWBvsdTEU74KJojn5azYr5uUgL66mXveqaqMUTtv5r7euoIapz2KReO3zIC6ndUNPK7sNuQPptYy9loBvq/GYIeWm8mDs
 ZzlUFygQ
 xWTqbS6JAg6BQoLCeipIJtoscya2eDOv9DLCiWI7U2b4Rgd6hOb8LbYS5fAqo41jrKQxOXF1Jp6MjxHMXAHAYbEQBQgZnt5npmecm+6dpocn4L8KroHOPbFb0R9Xv76AcTXfvjOEPk6bvdfAd8aq/50lKbnxnn7dnmdu5b0evNZOB6QACBwXTpmgYrKrYvRB/GgoByyCVc+4mj0GdfNco9Rg9YGHrNmDV0BKX5QENdVgRIvwGryM9MpWJxkQe9SANcmeuONBnER3OPUQYh4dmhHNzbNWqQ6cdEvaJDRU7+NLB6hVgACz7GL4hv1DdBrunoy13LRIz9slRQnhHxy0iEdR4HKYEyp6YC22xiY78OFviDc4UZu10h8QfAe/7X18Kglk5PBiWmOefBXp0GeKPuFucFw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 14, 2026 at 11:08:40AM +0800, Yafang Shao wrote:
> >
> > I also concur with Tejun that ops seems like overkill for this feature,
> > this seems like something that can already be managed.
> 
> Tejun also suggested starting with a smaller kfunc rather than the
> heavyweight struct_ops, in a separate mailing list thread. I agree
> that this would be a good starting point.
> 
> >
> > For example, why not add a new numa balancing mode bit that says
> > "enabled but only for explicitly opted in tasks" and then ignore the
> > global default mempolicy, e.g.:
> >
> >   if (numab_mode & NUMA_BALANCING_OPT_IN &&
> >       mpol != default &&
> >       mpol.flags & MPOL_F_NUMA_BALANCING)
> >       /* do balancing */
> 
> Another option would be to add a cgroup::numab_mode field (without
> exposing a cgroupfs interface file for now) to implement per-cgroup
> numab mode. I will think it over, considering both your suggestion and
> Tejun's.
> 

I don't have a strong feeling either way, if Tejun thinks a kfunc is
acceptable here then that's probably preferable to any new UAPI changes
until the value is proven.

Thank you for the consideration,
~Gregory

