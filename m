Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27938606A324
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 01:00:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BgGv8lJO
Received: by kanga.kvack.org (Postfix)
	id E34CC6B05BF; Mon,  2 Nov 2026 20:00:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE4FA6B05C0; Mon,  2 Nov 2026 20:00:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D21E36B05C1; Mon,  2 Nov 2026 20:00:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AA88A6B05BF
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 20:00:50 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 299B51C2A4A
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 01:00:50 +0000 (UTC)
X-FDA: 85392003060.08.12EDE70
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 528591C0005
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 01:00:48 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BgGv8lJO;
	spf=pass (imf20.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793667648;
	b=vXnD0hjyUlhbw5p9GyRmP87r5ICKghDUK4GEoWyxcB5prPvi8PtgsH40rUqcXhyP5CRYbh
	gvMmhaEGZaISjPvcciRUia449rChjG6P6n7n5nbgWAG26S1TBqGkOdYwkmSYUY91mA9GbY
	bqIPT6C4ih7l3DVkdFKssYxTb1XUqig=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BgGv8lJO;
	spf=pass (imf20.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793667648;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4HQ3Qgd7i2dVNUMZQt7YfeVDy1gbBVil90g1I4doNFE=;
	b=QXZZHlvN8QZFrgElDCCQNmfzApPc06G+9Z4WgCoxW+eP4uilX7LLuHXmL084TLBh6WSHs1
	nUNChi2tPu6lkez+XoR5e9TjMo5wQz+d27j4eD34y0flvihrh7EPzHiyqO1J4o9n/GkMWs
	cAO3i2qoTnfgVaj0HLC4J7Nscti32iY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D603A605F0
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 01:00:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DCF31F00A1C
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 01:00:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793667647;
	bh=4HQ3Qgd7i2dVNUMZQt7YfeVDy1gbBVil90g1I4doNFE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=BgGv8lJOHVEgop2gWiFbPShFWku0TCjm6MwzTYsrxTPTGPDILDl6x5fU6Q1UWKT2e
	 MQNOpygshQ0/ofvQ10Q3ccG8DqHWbje392YnCG1S2tnxMi4Qgo9vaUQ0HSJQwxuM8J
	 y0xc1HUsR9GiC4fAohVrc7jYr2h1hf00pZMGkMwuYMMHLCt+Xph6T+SGT7l5HfBv7w
	 cm9UFAAqtTlUWYTt2GeUfwqpNZfNMfIiRfm4dwTsjyoqjBWPjFPz1ARLIBqrD4VGn0
	 N0c4T5/GkF4pzmYOmcEubV/bs6fvsOa2gFk8mi7KeO4USRlFk5UTNJ8gCZPkVH5QxO
	 mzDoMkXY1sn6g==
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-c4ced671398so51805766b.3
        for <linux-mm@kvack.org>; Mon, 02 Nov 2026 17:00:47 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvBzM5jtJKUtmkjOOybxTTtNAgspq3MOIF0N3NEhL4nQ8BK4ENk7Z3fkPrKnyjng5UwJgrPtv91xojQ==@kvack.org
X-Gm-Message-State: APuU4Z9fVmcjuNSuCGzFIo67a5OCa+lHv8dUoALvmeZNpmZIqc/bBnPy
	CjY5oMXP9xfiXL4vVNV+A0DclYyTSvq0dV4eRWsLrSdMDhHqrjiZKMN4KZCbqNpnv36cv9vwIoP
	uc3XGYnmPRMcSsqV7BSZPteTSsWWTpRc=
X-Received: by 2002:a17:907:7fa5:b0:c40:eb1a:4c8b with SMTP id
 a640c23a62f3a-c4ca7a6d245mr897957366b.29.1793667646429; Mon, 02 Nov 2026
 17:00:46 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261102225030.2743129-1-joannelkoong@gmail.com>
 <20261102225030.2743129-3-joannelkoong@gmail.com> <CAO9r8zP87zRuoFqeKFcAJoCrOG8M+7HCtX6hvxwdLzuHUXD0Gw@mail.gmail.com>
 <CAJnrk1bv-P_TQztAGiHYdfg=5hbj4GREML2M0Uxp5oC1R9J-Mw@mail.gmail.com>
In-Reply-To: <CAJnrk1bv-P_TQztAGiHYdfg=5hbj4GREML2M0Uxp5oC1R9J-Mw@mail.gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Mon, 2 Nov 2026 17:00:35 -0800
X-Gmail-Original-Message-ID: <CAO9r8zMvofnW-6OsiasiocOBqoRbZuD71dp3RQE5746YGzamNA@mail.gmail.com>
X-Gm-Features: AclHuK-Nd_GMyDmaw4iY6A-BMZy3XZnuaOJfkxR3X8uJTpecvIovrO_sqKDwyjY
Message-ID: <CAO9r8zMvofnW-6OsiasiocOBqoRbZuD71dp3RQE5746YGzamNA@mail.gmail.com>
Subject: Re: [PATCH v1 2/3] mm: memcg: read root lruvec LRU stats from the
 node counters
To: Joanne Koong <joannelkoong@gmail.com>
Cc: akpm@linux-foundation.org, shakeel.butt@linux.dev, hannes@cmpxchg.org, 
	mhocko@kernel.org, roman.gushchin@linux.dev, muchun.song@linux.dev, 
	nphamcs@gmail.com, chengming.zhou@linux.dev, sj@kernel.org, david@kernel.org, 
	ljs@kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	damon@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: osjcmcnbjgg8izzgkqqedaioce17f8cg
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 528591C0005
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793667648-479698
X-HE-Meta: U2FsdGVkX19xE4JQ6kYZPyXtLSYsPF/NrRNl2RL1qEcTm9f3bvSB0T9CP/xiIlp4uoX6PaOgZHKK0ARgXYCQV/bEwCrvcXqeM8LJQsLERwVwJzV1bIatGcp+tV1FvhvoYEbL8gtWVk/ZouyMIuLLjVvIgDc0ntc5nPdrZxm1m6iTeDLMXP/1E8kNJznKfrWXBBvtNjyjWbJzwTUewSq0KdjBjmJgrIKCcJmKbv9drbvb8wP6mS2rjY/boviX+9oZKt+nN/rRixa0GFOXOZ2Z2ZFhVd5v/a92EY5w5GIpg1b66VGucqC38pAlgh0Nn8AUSyvWlUHB3lIsvivs2ucmSyPq6TLjOg3PgOZBVKzk9CLKqMRVadkW3t1BwLnMo2n6HAN2HpLbiyByGnRayu0QYWzq4wDs1bX84R6dco+4xq4dRD2PVuFWjpNm4fvMHguFC+mdPTrfrCveqsNpI7KMu5JZt3QP7EtBkBF6bIDjlnnrFzmUE9C4ZXW6NaqkWQ0jbR5k/V8VHGkwfj5G9TZhyPlGFT6rA+MkwWG2zmpmE+vodzQQ9LsdhpT6AQBeDLMLo7rqSN1sy5IUymtMCXcrj1TL+DvFnxum+dD7UZ/fe8ebRYRFFDJBCSZIvrgL5IrDOIyPCJqUSDhh/2lxLNeXVQXXhCaUBg/TER/BrH4p+my8ziYxeQAS09sAMF/L293eQ23nfAQCfCHpij70/yvL/XHB2pcCVOt8MvVD00MnTu61QsT31fetj5w3WlQ2jVBhT0Zspv/i72S3xzeuCOMpz+r4hL68ycHCVHFmbTQ956v59KTXxb3sHYXzEhtkMA28V9IGHjkcM8oCzzb4MWa8zaB1pKSNExNQcPhpcCa1blFrxH7XRzesYvTdTrb7+iOnVUfJvlp7glFw8JD0myM9EfduDfd5XL3W4QhW+ndwdRZ8p/EAc7VqU31xOp/KF5AiZmuzWs0ypSHwmkfL04a
 1nSAwLQL
 U9zmdlytH9NUYO4nOkGfffdCY1S3sx3aTrVTOn7zq0Uv5c81TWGQEwQIOq1JKhvjFe9NZi8RcY/5PrrufQ0r1GTvJTNEysPLHCC6y9oRMI0Zid7Q+iO588e3i7QSiayHC4bqX8pEYs8ulg5m6Pi630K3PqMD7kmze/aNC5vT+bfb/RXu6tJffRmtVH380meONuIwsKoUkbSOQp5XOe2Q8k1xg7GQmk9DVZyuEBrCe8J7OpbdbtxxqrrywFU8BsPFyxOT54mQyDG7DtU/RTKra0wf6Nwm5Bh5PHedexJjUPoFy0l0gF80FVwNT5LuD+RbOTBKQFNntC72bdsE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 2, 2026 at 4:34=E2=80=AFPM Joanne Koong <joannelkoong@gmail.com=
> wrote:
>
> On Mon, Nov 2, 2026 at 3:29=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> wro=
te:
> >
> > > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > > index ac6c43ea8c5a..938843346571 100644
> > > --- a/mm/memcontrol.c
> > > +++ b/mm/memcontrol.c
> > > @@ -587,6 +587,50 @@ unsigned long lruvec_page_state_local(const stru=
ct lruvec *lruvec,
> > >         return x;
> > >  }
> > >
> > > +static bool lruvec_is_root(const struct lruvec *lruvec)
> > > +{
> > > +       return !mem_cgroup_disabled() && mem_cgroup_is_root(lruvec_me=
mcg(lruvec));
> > > +}
> > > +
> > > +/**
> > > + * lruvec_lru_page_state - read an LRU stat of an lruvec
> > > + * @lruvec: the LRU vector to read from
> > > + * @idx: the node_stat_item to read
> > > + *
> > > + * Like lruvec_page_state(), but for the root memcg the node counter=
 is read
> > > + * instead. For stats that only track memory charged to a memcg (LRU=
 sizes,
> > > + * workingset, rotation and reclaim writeback counts), the root memc=
g's
> > > + * hierarchical value equals the node counter. The root memcg can ju=
st read the
> > > + * node counter directly instead of going through rstat, which requi=
res
> > > + * flushing. Flushing the root memcg flushes every cgroup in the sys=
tem.
> > > + *
> > > + * Use lruvec_page_state() for other stats (eg slab).
> > > + */
> > > +unsigned long lruvec_lru_page_state(const struct lruvec *lruvec,
> > > +                                   enum node_stat_item idx)
> > > +{
> > > +       if (lruvec_is_root(lruvec))
> > > +               return node_page_state(lruvec_pgdat(lruvec), idx);
> > > +
> > > +       return lruvec_page_state(lruvec, idx);
> > > +}
> > > +
> > > +/**
> > > + * lruvec_lru_page_state_monotonic - lruvec_lru_page_state() for del=
ta sampling
> > > + * @lruvec: the LRU vector to read from
> > > + * @idx: the node_stat_item to read
> > > + *
> > > + * See lruvec_page_state_monotonic() and lruvec_lru_page_state().
> > > + */
> > > +unsigned long lruvec_lru_page_state_monotonic(const struct lruvec *l=
ruvec,
> > > +                                             enum node_stat_item idx=
)
> > > +{
> > > +       if (lruvec_is_root(lruvec))
> > > +               return node_page_state_monotonic(lruvec_pgdat(lruvec)=
, idx);
> > > +
> > > +       return lruvec_page_state_monotonic(lruvec, idx);
> > > +}
> >
> > Why not do this directly in lruvec_page_state() and
> > lruvec_page_state_monotonic()? They already fallback to node stats if
> > memcg is disabled, why not do the same for the root? Are there cases
> > where the node stats are not the right thing to do?
>
> Hi Yosry,
>
> Thanks for taking a look at this series! I don't think we're able to
> do this directly in lruvec_page_state()/lruvec_page_state_monotonic()
> because I think there's still some places where the node stat and the
> root memcg stat are not guaranteed to be equal.
>
> The stat I was looking at last week was slab's NR_SLAB_RECLAIMABLE_B
> and NR_SLAB_UNRECLAIMABLE_B where for those, the node counter value
> can contain memory/stats that wasn't actually charged to any memcg,
> which I think means for these cases, the node counter values can be
> larger than what reading the root memcg rstat value would give. The
> functions I was looking at were account_slab() and
> memcg_slab_post_alloc_hook() where the logic adds every new slab page
> to the node counter but the memcg stats only get updated if specific
> criteria are met (eg the cache had SLAB_ACCOUNT set or the allocation
> had the __GFP_ACCOUNT gfp flag set and the allocation was not from a
> root memcg).

If it's only the slab stats, it probably makes sense to special case
those instead of the rest of the readers, right? It would be nice if
the default behavior is reading the node stats that doesn't require a
flush.

