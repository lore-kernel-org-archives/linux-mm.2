Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5AA27606A31B
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 19:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=S/1z4d1T
Received: by kanga.kvack.org (Postfix)
	id 654976B05BA; Tue,  3 Nov 2026 14:33:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6250E6B05BB; Tue,  3 Nov 2026 14:33:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 539F26B05BC; Tue,  3 Nov 2026 14:33:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1C3376B05BA
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 14:33:46 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 969C91C33D0
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 19:33:45 +0000 (UTC)
X-FDA: 85394807610.27.988AE3A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id A07561C0002
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 19:33:43 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="S/1z4d1T";
	spf=pass (imf18.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793734423;
	b=Ip6yGK44+eQI12FBD9mQVbkJOyIrcEpei6htv06wz4d666QUAR+mKwFwDIoLJmR5U1yyq4
	B/UgYuw3+NQyBpe48JpkNPx/jUxBrWX8WgU2n7QHHOENj75Dx0Cd7GfruEW/W02k9RuBeR
	10QLkwOApCs+fmVKZ/2mKShJVVRTZjA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="S/1z4d1T";
	spf=pass (imf18.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793734423;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jRv7FYipiH4DqQ5+rCUwDRkUzjzUXk5k5BQEMlfi6u8=;
	b=xr3yr9GahYrwo+J/A5NJVY1DGZU+dGc7I/7CpVlgjPe0Z3wVyLT0koew53wuwrwWo0GkFt
	5Of8wEAMY0tO8Sc2icxWbE08XuqixOIpXbdP5Gha8Z6gFD8tfRcSi64KZPUPygpdzfvl7D
	uf6bgKm1rrfvxJ8K9rQd/na3klzH+t4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B3F6F43C8F
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 19:33:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98FA71F00A1C
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 19:33:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793734422;
	bh=jRv7FYipiH4DqQ5+rCUwDRkUzjzUXk5k5BQEMlfi6u8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=S/1z4d1TPZ9AcH+itxhMJEsw7wWjDKsp1RhfAa1ULOi2R9gDWetOGvR2jk6/GEyRH
	 fuBBzNAg2iz//ldqgURus9EkJ0S2wOSPk0v+MwwZnjCNcs8S+agrd7Fu6LnDbE2oAk
	 pnEJNU9iKM9pUUSZcfrn2KxDeuzKOnexULXxOpZmOARDFmwKWqpSTtId4OnAo2oYed
	 ZEijnUNo6yvORH37NXVEgJXnHTGb1KR23roqIh6FVzZyYpYX258TBIoVbBn1QL3pmz
	 v4HecQOsrQPtceEMqj1L7Pv3n5hqbO0+g7Cfn/V9N1qSlxfc0qIxtLQKOVnBjVgwBC
	 nl6sR03rPZKUg==
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-c4cac7a7d3cso579950166b.3
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 11:33:42 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvBwF4VvssdeFeK4jCG8XdU+vKS9Ic7q00mN3HOp62J5Avf2jHik70Kr/ZUaozC2+Kk8w80bsbEuu0A==@kvack.org
X-Gm-Message-State: APuU4Z/PGfOHnacBH6tXyxMFvCSIRN2FPXJySdxfRVhR6+E8km01KJc1
	Mxy7YmuEwNyUFVlLpmiVGkQ33nmZu6/aNC7kH/7iFBaiO6Q/demu0e6KBVgnAZwzh2qzLF30eta
	PqH503n0NmxM7seiVkJR3xCkullXckTk=
X-Received: by 2002:a17:907:2d25:b0:c2d:c739:30e1 with SMTP id
 a640c23a62f3a-c4ca7a9fa75mr1143730166b.32.1793734421515; Tue, 03 Nov 2026
 11:33:41 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261102225030.2743129-1-joannelkoong@gmail.com>
 <20261102225030.2743129-3-joannelkoong@gmail.com> <CAO9r8zP87zRuoFqeKFcAJoCrOG8M+7HCtX6hvxwdLzuHUXD0Gw@mail.gmail.com>
 <CAJnrk1bv-P_TQztAGiHYdfg=5hbj4GREML2M0Uxp5oC1R9J-Mw@mail.gmail.com>
 <CAO9r8zMvofnW-6OsiasiocOBqoRbZuD71dp3RQE5746YGzamNA@mail.gmail.com> <CAJnrk1ZAz2ro0-8CC7n8mEjpuRQ64=v0rABtygaw5e2Aohq3=w@mail.gmail.com>
In-Reply-To: <CAJnrk1ZAz2ro0-8CC7n8mEjpuRQ64=v0rABtygaw5e2Aohq3=w@mail.gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Tue, 3 Nov 2026 11:33:29 -0800
X-Gmail-Original-Message-ID: <CAO9r8zOa52hMRTXFQVnSWJPmijm+D-97AeZDH-MMK_-rGiSwMA@mail.gmail.com>
X-Gm-Features: AclHuK9sBnbDrZh0YD95eyRdj4qiL2VNLTMVMO8HPo8s0hHhnjt9YDtLQC8vHkU
Message-ID: <CAO9r8zOa52hMRTXFQVnSWJPmijm+D-97AeZDH-MMK_-rGiSwMA@mail.gmail.com>
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
X-Stat-Signature: rc3qehphfaezdqyy1tahjmd7mgmjm55g
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A07561C0002
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793734423-134240
X-HE-Meta: U2FsdGVkX1+00gVSTex1bzsLXxUQuc8rRbjaC9GfeZ1g4aDgMbL2/kb2dYUKjEcodDn4yAUk+ODw5ZJemS+OquTIUKYlZ1t3LvnnclybB513Fds6pVdu8+n4V080V8iBP8An79ZsKmaB7JedcXQ2jiiU8vPeOcpK9w/iT4gK6qcZtO44iXZjwAoZh5HfPPI8av8DksF+YOwExDratMCzEO4W+XmGtbDi5ikLSxBGeCjs0WYRQr/Oe3Rurkrd7J94b+ER8Em72VGBt+1Gv7QoApruE/NpgJ3agJ+oAhZrlpfUMvveySWEhkqFAUW9KZoxV3sJaeOeGXshpUhumq8S+CCP5p8F013Nag8wju3Vhzm6fMfVvPZcyoVPR/ZEUBVG2PJVzD/64CNitE2Gm5reJTo/wIa0PS56xd8yXN1iIGlEj0eY222Zd/TF9Dm2AZcS8Gnjq/+ClODfTWca4ci78Q2nUSrEQ/3pmoNoiRSheWdXartgOzYdDkyKjuRA6tQp1XoMmEQMdQ0fj9udIDOCHcv1qycpglpg1qjaqSgE4CTHQKJzZXT7xhjef1Kyg/3LcT1xYoNKxuI17rqwlL3NRMpUb9HHU8NV/vT7R9p9dslqmC9ripcfxHLdiY74T7xGgaZTe73pwiTTtZSLbFzv8+Ds3SC0uLxdLMCOh0HIyWPEgfTV7vpVlQnKM0KRzk2J57lCiiCdaapkGbUCd5Ub/bECwSYNABN8va7IbG+uD0No7PaRykHBNho83TmDrJAosNv2d+CKQayFZKZpGd8UAEfIQHfvcN385YI2YDTUJ/5ogj2iKGgVV75+ReYYJSUU+I48X/CWRofHC4SfbfHa30niPqPXcUDPJCayZvldGFtKs1sGsA1B7bC4j5bl6yo5gEovbpghokoeC0jrAJB4ja86ZqzvK97vadWvCAMX5M21JdSBRwaourzM1i4CoGfdoAuZlC/JnlZTGJhtHps
 +saUv9s/
 /K04PEqMSAAmhruYv44ac5WczKRW357ZY4ztG7P2tuziBBCLtK/74yziY2/2Cw/JjNNrs5+SHqye28YrCnYNFbdLRwm3loFybrN8fpGGx89jLZkI3xNW+Clh1XM4jLWPYmKhkwm/Wm35YOsUOomqfLE5k3LSEQOGrstdtbstIFcHs8H4Z1sUkbTtZPZNVPoJo/HooNMe2iyDoSRYv1Iu3Yd0hmuWr1nmoC/WhMV1ciChOYcUu7wO40dA7N3RBe9LIEegIuI5rhsbdNErnOfPzLyrglrQqrvskYwFRXCtKaPJfvcdyuip32DM8xu7eaj3V3oRsu9rn3EFPO0o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 3, 2026 at 11:28=E2=80=AFAM Joanne Koong <joannelkoong@gmail.co=
m> wrote:
>
> On Mon, Nov 2, 2026 at 5:00=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> wro=
te:
> >
> > On Mon, Nov 2, 2026 at 4:34=E2=80=AFPM Joanne Koong <joannelkoong@gmail=
.com> wrote:
> > >
> > > On Mon, Nov 2, 2026 at 3:29=E2=80=AFPM Yosry Ahmed <yosry@kernel.org>=
 wrote:
> > > >
> > > > > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > > > > index ac6c43ea8c5a..938843346571 100644
> > > > > --- a/mm/memcontrol.c
> > > > > +++ b/mm/memcontrol.c
> > > > > @@ -587,6 +587,50 @@ unsigned long lruvec_page_state_local(const =
struct lruvec *lruvec,
> > > > >         return x;
> > > > >  }
> > > > >
> > > > > +static bool lruvec_is_root(const struct lruvec *lruvec)
> > > > > +{
> > > > > +       return !mem_cgroup_disabled() && mem_cgroup_is_root(lruve=
c_memcg(lruvec));
> > > > > +}
> > > > > +
> > > > > +/**
> > > > > + * lruvec_lru_page_state - read an LRU stat of an lruvec
> > > > > + * @lruvec: the LRU vector to read from
> > > > > + * @idx: the node_stat_item to read
> > > > > + *
> > > > > + * Like lruvec_page_state(), but for the root memcg the node cou=
nter is read
> > > > > + * instead. For stats that only track memory charged to a memcg =
(LRU sizes,
> > > > > + * workingset, rotation and reclaim writeback counts), the root =
memcg's
> > > > > + * hierarchical value equals the node counter. The root memcg ca=
n just read the
> > > > > + * node counter directly instead of going through rstat, which r=
equires
> > > > > + * flushing. Flushing the root memcg flushes every cgroup in the=
 system.
> > > > > + *
> > > > > + * Use lruvec_page_state() for other stats (eg slab).
> > > > > + */
> > > > > +unsigned long lruvec_lru_page_state(const struct lruvec *lruvec,
> > > > > +                                   enum node_stat_item idx)
> > > > > +{
> > > > > +       if (lruvec_is_root(lruvec))
> > > > > +               return node_page_state(lruvec_pgdat(lruvec), idx)=
;
> > > > > +
> > > > > +       return lruvec_page_state(lruvec, idx);
> > > > > +}
> > > > > +
> > > > > +/**
> > > > > + * lruvec_lru_page_state_monotonic - lruvec_lru_page_state() for=
 delta sampling
> > > > > + * @lruvec: the LRU vector to read from
> > > > > + * @idx: the node_stat_item to read
> > > > > + *
> > > > > + * See lruvec_page_state_monotonic() and lruvec_lru_page_state()=
.
> > > > > + */
> > > > > +unsigned long lruvec_lru_page_state_monotonic(const struct lruve=
c *lruvec,
> > > > > +                                             enum node_stat_item=
 idx)
> > > > > +{
> > > > > +       if (lruvec_is_root(lruvec))
> > > > > +               return node_page_state_monotonic(lruvec_pgdat(lru=
vec), idx);
> > > > > +
> > > > > +       return lruvec_page_state_monotonic(lruvec, idx);
> > > > > +}
> > > >
> > > > Why not do this directly in lruvec_page_state() and
> > > > lruvec_page_state_monotonic()? They already fallback to node stats =
if
> > > > memcg is disabled, why not do the same for the root? Are there case=
s
> > > > where the node stats are not the right thing to do?
> > >
> > > Hi Yosry,
> > >
> > > Thanks for taking a look at this series! I don't think we're able to
> > > do this directly in lruvec_page_state()/lruvec_page_state_monotonic()
> > > because I think there's still some places where the node stat and the
> > > root memcg stat are not guaranteed to be equal.
> > >
> > > The stat I was looking at last week was slab's NR_SLAB_RECLAIMABLE_B
> > > and NR_SLAB_UNRECLAIMABLE_B where for those, the node counter value
> > > can contain memory/stats that wasn't actually charged to any memcg,
> > > which I think means for these cases, the node counter values can be
> > > larger than what reading the root memcg rstat value would give. The
> > > functions I was looking at were account_slab() and
> > > memcg_slab_post_alloc_hook() where the logic adds every new slab page
> > > to the node counter but the memcg stats only get updated if specific
> > > criteria are met (eg the cache had SLAB_ACCOUNT set or the allocation
> > > had the __GFP_ACCOUNT gfp flag set and the allocation was not from a
> > > root memcg).
> >
> > If it's only the slab stats, it probably makes sense to special case
> > those instead of the rest of the readers, right? It would be nice if
> > the default behavior is reading the node stats that doesn't require a
> > flush.
>
> If we were to special case it, it would need to exclude more than a
> couple, I think. I asked a LLM and it says NR_KERNEL_STACK_KB,
> NR_PAGETABLE, NR_SECONDARY_PAGETABLE, NR_VMALLOC, NR_HUGETLB,
> WORKINGSET_NODERECLAIM would also need to be excluded.

Interesting. So for all these stats, root memcg stats (from
memory.stat) is not the same as the node stat? They all draw a
distinction between "accounted to root" vs "not accounted"? I wonder
if this is intentional for all of them.

> We could add
> this special casing in, but we would need to make sure any new stat
> that gets added in the future that belongs on the exclusion list gets
> put on it. If it's missed, the failure would be silent whereas with a
> separate helper, callers have to explicitly opt in. I'm happy to go
> either way though, so if there's one way you prefer, I'm happy to do
> that for v2.

I think we probably want to first understand if these stats are
supposed to be different between the root memcg stats and the node
stats first. Personally, I think the default should be the majority
behavior, which I think is that node stats and root memcg stats are
the same, so I am leaning toward explicit opt-out. Let's also see what
memcg folks think.

