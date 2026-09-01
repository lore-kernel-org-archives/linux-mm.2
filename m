Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 723E5C624D0
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 18:12:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 77FA86B00A2; Tue,  1 Sep 2026 14:12:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 730DA6B00A3; Tue,  1 Sep 2026 14:12:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 620EE6B00A4; Tue,  1 Sep 2026 14:12:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3A3FC6B00A2
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 14:12:06 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BAA75A0505
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 18:12:05 +0000 (UTC)
X-FDA: 85165987410.30.28ACEF0
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	by imf30.hostedemail.com (Postfix) with ESMTP id D5DBE80011
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 18:12:03 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="ND/iOWU9";
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf30.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788286323;
	b=FIfQrCDrwQT/3F+3tesWc0RwqDqXHybDGZBTYoOf3VFei4Wfi0aRFAlJdLS49QZoc9z320
	gmamezJuiFYx3ldUkX3qIEOlBV01y6dGdMlf8ovUou5mXMTd1UshSAj4P+M1N7cuYbeIXw
	HTEmfCnDpgFdc/wmVJvbkZYtEmJRit8=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="ND/iOWU9";
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf30.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788286323;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OYDHwPtRS/urJTrcJcJyVU92g7dRNXopeu0W3B+ow1I=;
	b=CmKu3chd4g80p/qvD63m60a5jRWBKS+7sh/W/a0WRWSDKMjeTNCHnyirO3GL38qm12WjE+
	uLJnanh1w5WD9oh9TUkNj/qlTH6zEpS2kEtLiduhKX59icBuMyg4Xdw/lmuRyuXxvrqE3X
	q60rcLNK7iDr0gImlpyEkA61yGzo0oY=
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-c1670dad7a8so9601866b.3
        for <linux-mm@kvack.org>; Tue, 01 Sep 2026 11:12:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788286322; cv=none;
        d=google.com; s=arc-20260327;
        b=e+b3DdV7kc+9gaELWtK03XtGp1iX/vRN/qvFCErgP4RMtvLgGQ+zRcQQ4M9Rm8rn0W
         UTLZavj/wp3bT7h/8reKACb4vhuXvPRYFSyt3TVGceOuZp58As5ch5KfDXCqSpzM8Nf1
         bgf7RpJ1BZqawdVB5H5OQRNO6gtGkPrMqQ4kR3qKQfrGA2x+LxwAwvHyYUdk+CPmKrip
         VRU7JINgey6zZk4v01Xy65KUDYCxOBmPXTbiWx8PZayvbQPB4xLcPvzHwbvCca6Tf3JY
         ZDL6/s9sxgUMQch3Y+n4eCFg4AP+xcZSqMs537GJ/1RXP6YnlWMq6q4cgAC2GOVBS9xk
         wdUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=OYDHwPtRS/urJTrcJcJyVU92g7dRNXopeu0W3B+ow1I=;
        fh=9OtubVzT62RuDK+UzaUPHULs4CVlPa6sMix+QhbQvNk=;
        b=Pa2dAZXwCE8Xy5hsuChFtZW8V6e5Kq3nK071FEwvy8zAKc2oc9R95oDy/fmaWNrvWk
         m5xQLreVDlt5JygNCizah85OZObb9LO+lg+/cb5h8AalzHILIRID1bjXptjR872uhSRL
         jRftw9/lUAb41qc6pVDoiyO3QR5Wv3QmfpBHzWyz9jtwRVtvb4tl9jaLjN0iOUfCmmPR
         B/ES9ZMDS0K+V+qxSmQ+iBPEZsrWL4VrrzClvVYRU79UlA7uksr9PrD2YaiZPwOJL7u4
         jskdsFGvVuZxW5xmWvRkdbSU4yVpWpR24z6c3uz6FtFCL903QC0ycvOSS3i33+QPPRBD
         jHog==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788286322; x=1788891122; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=OYDHwPtRS/urJTrcJcJyVU92g7dRNXopeu0W3B+ow1I=;
        b=ND/iOWU9JJ4fVzg9bH5JZvdNuH3rzNQ8P0tzZJzFH9W7YMNVUwy8Qrk70twH5r8pMF
         02acQ5zpTxPVXdTH1bWlcrCUgQpLT8DoLI3ZT0TnXUXSPVf5C+q7xTG79pfY3zWi1WaE
         HBmOeBl1N4bjKIhj0aU+Im2j5zXeJRduSTXldfUq77eFwP+7eLpXljeDncqyeh/RRYp2
         IFI4tYtF+tZVnr56ltJw1SirnFWPgBWpbLu/4UahtCrjtCURc6psYaNxMwZpJclJfyNM
         aTbAf0wqAlbndV9Yg2iAl3aGBMjv1CdSoLEppxOPMxjmGtc7Ok/Pwvo3oK+NpCJF2niP
         qBrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788286322; x=1788891122;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OYDHwPtRS/urJTrcJcJyVU92g7dRNXopeu0W3B+ow1I=;
        b=dOEQX5K82j6e5Bio3aWEJoQCliJxc/+YHHQZHqpxG6DqpXl76eaSB0hpYyMEPDWY/m
         47zZ6IFbVPiJHRgCRLaGHH4+pEqaTaOmrCiX/MlKZ/SnPDn8S6QlPabfu627UnrZlK8I
         2Gi5Oa4smHQIX8ZK3aP488xJMipcKyb+3zr/jcnnJx8ZUCJQhdquo6Io27HMXlwRPC0P
         vyty0EeUQPbOR5v1BgETzL0POJUFkhCYcN8C3xfEk3faFGGL+eZQ/GhXeekRsLjn6gbf
         ha1AknysFX2mJE135yWrdMlB1btYZY4PaROKp6aidvkm3XH44/9dsdr1aK5GqCho3Pa0
         Vzxg==
X-Gm-Message-State: AFuF++nAntMqvfjUiI7waS+Z+a5yLacael9DMtk508vQUv3jA+C3Nitj
	q/lOvK4w5Muv9QG1PzPz/BNUvyd8P0goNVO2DOy0irjeB9J7jZRgfHH650AUgNBFffba+Z7YqeB
	xpQcPI9q2oeq7xtxs+STsrLqTkvtNTL4=
X-Gm-Gg: AR+sD10WIDaK5QBYg8065ksynYJv1OndWe+k435dshYaicYiuEfrRYcoGO4b5wU78gZ
	pmgNi/ZhP4FfL8Xc1nLhM+rjgBd4D7ekStfs1bhsAP+MMPtub9T9UE96DrDPJLymR7VTn9evC6M
	jmrns9Y8TSUMJXGIyAzBjd4cFqEdgWjxN02k5POsbjPwjI+4JjFVZduVyWJ0XAJLmOZIRvT0RjL
	LF4PsVwBTc/YplLHFBt53L1eL3OCmMPi+AynMwl7irvBVzBi9hPufbkKLT5KwZF5MaXjW+af6wR
	puNagdaFaNMTrAmNsWTj6zPWta4sRtQGqS6acwhicbw9pfAdo8ugzyu1u5C8pwTGmCuuUP7WSik
	u
X-Received: by 2002:a17:907:c714:b0:c24:d6f0:2071 with SMTP id
 a640c23a62f3a-c255742f97emr2437697666b.12.1788286321995; Tue, 01 Sep 2026
 11:12:01 -0700 (PDT)
MIME-Version: 1.0
References: <20260831-mglru-flags-cleanup-v4-0-2d15dde0d7ee@tencent.com>
 <20260831-mglru-flags-cleanup-v4-1-2d15dde0d7ee@tencent.com>
 <apZVe8UHZ1CNo4r1@linux.dev> <CAMgjq7D6V4eTZJ1Q1Xf2J6yTCq=JjvzT-W-HHX6EnMfzm3BK1g@mail.gmail.com>
 <apcJgcFLHKZfI40m@linux.dev>
In-Reply-To: <apcJgcFLHKZfI40m@linux.dev>
From: Kairui Song <ryncsn@gmail.com>
Date: Wed, 2 Sep 2026 02:11:24 +0800
X-Gm-Features: AcwNN1XLuero4S-u0uv2ETgMcz4JXom2ZmkXeiEroEYDvMkv4dB11HBSW6z7Bos
Message-ID: <CAMgjq7C=k_nzwiM_MTcjVjWMTGf=s8oRaUBY00dCvLbP4EiHnQ@mail.gmail.com>
Subject: Re: [PATCH v4 1/6] mm/memcontrol: make lru_zone_size atomic and
 simplify sanity check
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Chris Li <chrisl@kernel.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Ridong Chen <ridong.chen@linux.dev>, Lian Wang <lianux.mm@gmail.com>, Yu Zhao <yuzhao@google.com>, 
	Zi Yan <ziy@nvidia.com>, Qi Zheng <qi.zheng@linux.dev>, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: b3jxumoah5gp173peas7w13b36oti69c
X-Rspamd-Queue-Id: D5DBE80011
X-Rspamd-Server: rspam06
X-HE-Tag: 1788286323-759647
X-HE-Meta: U2FsdGVkX1+avF2yC/Lct86FejiQi/Xf/vraGFrC6d1ltu40BP7g68VoH7nIhy137MjdA2eAqjo3dXtcjwhX6ZHkQBMvgNiltwvOQnNuknXWPOZNIJU1c8n3KmXSHqjPRd3FYbrTrgJWmElCGmFJMIaogGCg1+jrhrEfA5fMW9h8h7Cu4xrJeyYzP+nGdTXnU5XkvtBQTTAd9hbLQzVe9Qt732Wg+9nPsd3h/KRUG3qAft3vlX/5LMCVs+81lEw+A5W1c5SY7smrHyGyTMevs1yOLo8Pgj37gMAExfB79guNT76dx0tC4eJuWc6tSq1KeqFBPp5pwvD0Kzkks4aT5wKx5P89nLL1JkW8u8lLeXksyHDsFyouCoG23Pug54Rm8pXYyaAvAQDDqVf5RnDTRDG0GGyi3z97fb38qB9iKYZ5L8ichFZhGa3P8/s1jZLqj/ktC7UDYmhNOfN44hUVnEqfzk0e5Z+eBUC/697/CUFDadNTmbBseIKkqUpQ5JgdAIBQsx8tHodAXFiEdoOX9CiuGDBnOG3fmsvr/EkhFP1LouGvuN/3tfjd8OTKYVFn4SfdjD9TKsLZLdbLvUZEbPYAm0X9bt1qkreUZhnNTJJUC1RLl1B1mbWviMwcfZqycFXiciBKW+SRthXc6eUkUJ3CWN2Cxhpm3fOyma4pHGiZHbUx8Qgm6bMInXOnrpuX3aP5DKcCFKkI2tCCZ3L7isFY9upbxZsJEbHqsRj2PAO+UMuxqZI3Md4uChfO2dswCrAFuLEfb5TirMptcpfH7jT9jTSns3c0T7nuRmAH+Mo0SKc1uIiioVqj+iJ0xiPNYw/BAFepeJH29MMB+MM/R1ApS6mxr5ehWW3FxdrQ/jxwJcYg+grWQZi4WkWBiD5/R+v1ykMzSv5HGGqnUJ1AMULJH2ZqVOVjTxbLvnSuZEX12MESFZorEsdZxIqkoEHIfQ1DY4zVeXFkYFOtzRO
 bSkLeJvG
 XK1wUC9jkc+r6nsaPxr4ePo1ItMIRrJguWtCcoSSS6siKKOuRNyELxc46HRMAL7oBTAXY07ZtKfEEV8IHIGI/+p59ilf7dpWWtUEhhwF22Gyi/bM9PI636IVFI+hV4TBdXnSFmcToaavLOJ2JLTVp4PV5HBAZ1aBUtvYD/ePB4pW2L5ya1urEMqeWOcPztDh+GAnp7brMwW3PaIWQzPOl40PN7KqtjVfDaf5sEY1K3TYIA3nx3cfeG4/T/iJSUA+cON7ls50MTKcZPdKZWW3hX99uItNB/n3IfBJZ91d+pQrbhCSMcU+Fq45IikD2MnPn5jxx+jeiyWQvwkiy+k8XBDcqudqf4SWIx48VChSySgjPdR9sa9P5XDbfumNADN5FjGy6FIAcUSLhjqCxWD4GdTw5c17w1HNLeQbBYbpg63Nm+ExIMfA2Rv+mgEuc99zNpjfgYWRaO5GWG8STEpWWXv6G9lOusdRkFx/bgMR97t51qRTNJQbHB+nDj0MilgNHudDq3iZ9vybq71P7g+TYN7uGScHkj4M8L2fFDNMzuss+13I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 2, 2026 at 1:37=E2=80=AFAM Shakeel Butt <shakeel.butt@linux.dev=
> wrote:
>
> On Tue, Sep 01, 2026 at 01:20:33PM +0800, Kairui Song wrote:
> > On Tue, Sep 1, 2026 at 12:38=E2=80=AFPM Shakeel Butt <shakeel.butt@linu=
x.dev> wrote:
> > >
> > > On Mon, Aug 31, 2026 at 02:43:31AM +0800, Kairui Song via B4 Relay wr=
ote:
> > > > From: Kairui Song <kasong@tencent.com>
> > > >
> > > > commit ca707239e8a7 ("mm: update_lru_size warn and reset bad lru_si=
ze")
> > > > introduced a sanity check to catch memcg counter underflow, which w=
as
> > > > more of a workaround for another bug: lru_zone_size is unsigned, so
> > > > underflow wraps it around and returns an enormously large number, t=
hen
> > > > the memcg shrinker loops almost forever as the calculated number of
> > > > folios to shrink is huge. That commit also checked if a zero value
> > > > matches the empty LRU list, so we have to hold the LRU lock, and
> > > > handle the positive and negative deltas separately.
> > > >
> > > > But later commit b4536f0c829c ("mm, memcg: fix the active list agin=
g
> > > > for lowmem requests when memcg is enabled") already removed the LRU
> > > > emptiness check, so handling the deltas separately is no longer
> > > > needed. And if we just turn it into an atomic long, underflow isn't=
 a
> > > > big issue either,
> > >
> > > Why atomic long and not just long?
> >
> > Long is fine too; I was just trying to be defensive. The original
> > check was a defensive design for leaks or races, and atomic long is
> > more immune to race conditions. See below for the other conditions.
>
> Unless we really need it, let's stay with "long" for now. As you mentione=
d below
> this is busy/hot path, no need to add overhead of atomic here.

OK, no problem.

> >
> > So checking it in the reader side is much lighter and cleaner code-wise=
.
>
> So, one motivation is cleaner code?

Right that's one of the motivition.

>
> >
> > Checking in the reader side also tolerates deferred accounting false
> > positives: if a folio is added to / removed from LRU but have the
> > accounting happens later, that's fine, but might cause a temporary
> > underflow (there shouldn't be such usage right now, but cleanly the
> > oldest commit I mentioned is trying to catch something). It should
> > just proceed without performing extra operations on the counter or
> > raising a warning on the updater side.
> >
> > The underflow won't affect anything besides the two readers mentioned
> > above (reclaimer and reparenting).
> >
> > Besides, I don't think warning on the writer side will help catch the
> > real leak either, it just adds overhead to a busy path. The folio
> > triggering the underflow is very unlikely to be the one leaking the
> > count. And if that leak is actually caused by a race, the atomic long
> > change should cure it.
>
> I think you are going and looking too much into the history of this warni=
ng. I
> think you just need to explain that the current warning in the update sid=
e
> already can't always catch the actual leak and is costly. Moving to read =
side
> make the code cleaner and warnings will be at the location where the cons=
umers
> we care about are going to consume it. Also add couple of sentences on be=
havior
> difference it will have i.e. warning on flipping into negative vs we will
> continue to operate even in negative but only warn on negative consumptio=
n.
>
> Another question: why is this patch part of this series? Just some orthog=
onal
> cleanups or are they related?
>

These were all part of the MGLRU-FG prerequisite, so I sent them
together. I can split it out.

