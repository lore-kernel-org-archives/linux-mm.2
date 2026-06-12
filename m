Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C55A3CD8CA8
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 18:15:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 105196B008C; Fri, 12 Jun 2026 14:15:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DC486B0095; Fri, 12 Jun 2026 14:15:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F35116B0099; Fri, 12 Jun 2026 14:15:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E10AC6B008C
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 14:15:21 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 929721C2702
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 18:15:21 +0000 (UTC)
X-FDA: 84872062842.26.A7B9450
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id AF38D4000B
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 18:15:19 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bnIqoz7q;
	spf=pass (imf12.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781288119;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E+A3vWRlzyJq18Mba78WFP87hbq4qTdszzF1tMKBnlk=;
	b=XK9P4Ibr7EGeW+pPBFybMSkXSIZeSVKwseyalUyrxF3wIA23iNF0cgTER/xrZh9hyzZaxl
	28BhpObRAjH4pR1PgFi2tjDG6MjETNJ/Zpp//5hy2+wDiHdIi/md2QLBMFZV+H23ZscCYc
	vLbG9ByOhlXtWz8Hj35H6d9RKFfpGws=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bnIqoz7q;
	spf=pass (imf12.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781288119;
	b=KSTRAOtm5npcjs+c5UxXJhwTUuWIz+K34ueURG1sjPyQN574D42BlQsbuuHnVw0Vr+FW5x
	n4C/A59/yaaPLPTOHdp3Zb7HSgLzKKlwHXOD/xzPYziveWFu6o1YuN3X2CClvul+961Zdq
	87giNuX0F8X5IWFfTqrProg/jmKfXEg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 31540601E3
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 18:15:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD08D1F00A3E
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 18:15:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781288118;
	bh=E+A3vWRlzyJq18Mba78WFP87hbq4qTdszzF1tMKBnlk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=bnIqoz7qSh+S2RyIs62F6DLF33AEzbM7iksZd0fYVYh1eAQxcb9vrPsSTrwVuC2ts
	 4dPaNpDdxYVmwFqA9kH1VDKS1/xgpUkFL01o5n+4kDpjsk/ErdiBMIOmW45Ajx8c27
	 pMGUNGqMF0Wb12Q6hEE78u15QHno7yqfHcKK+MqQTMn/PZyMjd/qQz5nEprpyiI0Zs
	 vVq+Hgq/GfllTxiOw1V/jL0MeYV4Hux3fAguIa7E6Y5v9SjDQBM+wUUqRfWFJnytd2
	 0PHpLi8E5yTZ2yTRgbfEwJomykQzwE8HZQBzT0A0p9sFQd7ERZMSxrcuxZJtYlio+D
	 1499XhXFIUT3A==
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-bef1e6423e7so147926166b.1
        for <linux-mm@kvack.org>; Fri, 12 Jun 2026 11:15:18 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ/6AFN8m8C/wRKYrD1zNJ77fJxHtkYwEG7pRldBHj7vF26T94WE8Ldhugl35B0cq91+Uxo0g4r1XA==@kvack.org
X-Gm-Message-State: AOJu0YxG39RIo2mpI+1LrNJ1s4Ole+XPbIUZS77FjRLKwsf8c+Ct+ycd
	/Ta7Aaa2CPz8ravsT9Kxf75Z6/NqPe93wvw7Lq9camW8SWMUNNFEs+7u4ZG578Xkan+MN+tjlsb
	pG91/ccliT5Vffg7fHfGLH2ouFT3skN4=
X-Received: by 2002:a17:907:1c9f:b0:bee:426:87ec with SMTP id
 a640c23a62f3a-bfe2a21eb9dmr188658966b.23.1781288117842; Fri, 12 Jun 2026
 11:15:17 -0700 (PDT)
MIME-Version: 1.0
References: <9898f83d-fae9-e284-6b85-c7f4089840a0@gmail.com>
 <CAO9r8zPBH6-0SQ6-_ZOhTQeyu=rz4F=ugikCrU-JR_skm6fEWA@mail.gmail.com>
 <a60eedb6-f3fd-4092-b726-04a17a695ace@gmail.com> <CAKEwX=MQ3xXBAY-2H8vA+XSX5GHNBubJ2GCYAXGD+Hra++ZM7A@mail.gmail.com>
 <90730fa7-62e7-d5f4-b638-23b22a8509f2@gmail.com> <CAKEwX=PF9hfERC_QMq+rjkSc-BsJyawMgTe+EhwR_86HiQKm=Q@mail.gmail.com>
 <CAO9r8zN6VVZz7dpjNrh8n7wbLkqcrsROPm70MQQxO49HJSmMFw@mail.gmail.com>
 <CAKEwX=MCFbsh9ndBtR0-bGRr_=v-6bBwTo=muzd9ZSD-LAK1nQ@mail.gmail.com>
 <1c25650e-bf98-2863-d505-9b94c385668b@gmail.com> <airypNnKrJJ54k_0@google.com>
 <aiw2JB1lZV9xuNSp@linux.dev>
In-Reply-To: <aiw2JB1lZV9xuNSp@linux.dev>
From: Yosry Ahmed <yosry@kernel.org>
Date: Fri, 12 Jun 2026 11:15:06 -0700
X-Gmail-Original-Message-ID: <CAO9r8zM=CMtUfV0RX3YyztqMNcw=s8M3WX6Q0epR5YHUvwTTKw@mail.gmail.com>
X-Gm-Features: AVVi8CfJgDpyGNP17lGySuExRPvTjQWDl5oLaxVnqf7oZO77PjDMo_CwkVZjPng
Message-ID: <CAO9r8zM=CMtUfV0RX3YyztqMNcw=s8M3WX6Q0epR5YHUvwTTKw@mail.gmail.com>
Subject: Re: [PATCH v3 1/4] mm/zswap: Make shrink_worker writeback cursor per-memcg
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Hao Jia <jiahao.kernel@gmail.com>, Nhat Pham <nphamcs@gmail.com>, 
	akpm@linux-foundation.org, tj@kernel.org, hannes@cmpxchg.org, 
	mhocko@kernel.org, mkoutny@suse.com, chengming.zhou@linux.dev, 
	muchun.song@linux.dev, roman.gushchin@linux.dev, cgroups@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	Hao Jia <jiahao1@lixiang.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: AF38D4000B
X-Stat-Signature: wb3xb4bfst13g4waki17ee7g4yp5h1eg
X-Rspam-User: 
X-HE-Tag: 1781288119-130072
X-HE-Meta: U2FsdGVkX19+JVPYJcM0VONkA/BPseh18cNCv4v7t/FwOJY6+H1qEmXkFwPhgVJ3seb/RhtwzJIxwR+xEqy6po9RXU6ElB28eXWwJeLBdkSPrX8UJYcVTBKVTerYFhLLyo2vGZId7PvEOVpLIlcrnjfdxxSbna7Xr/y4/A0gJ6UytGaZgcQSnQBGphIbC3NUBc+z4KFG4AdfTA2jkzyBa71glPJ+lo+PQWr5PrallEKp3Zq0x7iy7utQFjqy1Qcu5wnu9TADuIcCpmOi3/ZWMT7+8U98Ya6gy0ueP10MLBdSHZvZQWQHMC6T9bpimFD9sTzeztjkJKp0E3vF9l4RTYkgFB5mgWA1cAQgRubZLAQx1KlKvObxRZGwiSp12SDw9bpqiU/kk6CDCPBMUZOJt/UQTHlzxebEO8o9bG9NnySMWSqz6cnOJ9Rg5KRdPMyUviEPTKYSuO+9mnKEAXtyVdA3J6uUBs3ba5FpAzvqIVi5BIexLLuoDQ+7vQQlQvFXnBYUegb7rTLju4SER7shwJzryno90EnOf77I6fwuGq3/Gt/bOj3fyJnnw5naC9fvCfHT0qngOp0e6IXNBSKWClS4fVUxlobODLOeep+Xcv7bkPrlln4yZNwa0WkNjeLrhxUoYJww0VQaGdciLbN7b7Z5KJMXjJAhsdCvSeN/DUiFzR3N0vtQzplTPaY/raZZgimX4UQZJo+RjaPLayoRTjpx9PAiWyL9ICM+CI7ByYvwR+FpIl90SRHn2RhxKgguHCvIeDCNbvENkHDOLTwdqdho5qgTZU692iewzphV+gq/6vhsSXN2ZEH3axc/4ortFgqTl8D1VsBsMnuO6MHr561vK6HJxb/KwJrCY2M+tiKu6fJyh9QzFz0xN0uOuQ7c+RG3skUEAO6DjkeHRKVdsY1ByvH5VNK8M/zjlqfBdS1/wCbkYFwkIyyxbNkJ1mpJSm5GUDdwJ8aPpOD7TGW
 fqrpDxdc
 3Lcr7TIshS5x/e5QWh+vi4rl7+Z5U5RGr066dOVWBElokjswcS93mUP8kCP7lmWxwnSWZ1aTxN0Z3NJh54PhTC2FRzmhMGySH3zgqpRh4N4POzoEunC6TX2mlHDHy/65/scdFOKSOJUtzkO1azRKAmyDNBtknKbIbsfWzCGGsCejJQsFDbjjVqlFh58ChZm3NoxszuonzQyv6G5ZWJ9xHmSp6B+o5YWR+61IrSD4aopX7wdD/TDYOGNWT/iFAzxVO3IZK/8Yd21h21GKGh41mAHkFgBQGQehOFr2VE9w6jg4WCumb6u782VS9BrV2tKPNBTnwJ100zIPlD70L09TpEbfs9JCmHG5ABeBn8HZ1q63k4ISc4ZQlRc/bycq64+zDSy8ZJTBsZdoLU9J0ZOAPPWVEd+fMFRUK+gBsc3+K/w4DtmA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 12, 2026 at 9:40=E2=80=AFAM Shakeel Butt <shakeel.butt@linux.de=
v> wrote:
>
> On Thu, Jun 11, 2026 at 05:39:16PM +0000, Yosry Ahmed wrote:
> > On Tue, Jun 09, 2026 at 11:18:26AM +0800, Hao Jia wrote:
> > >
> > >
> > > On 2026/6/9 02:01, Nhat Pham wrote:
> > > > On Mon, Jun 8, 2026 at 9:48=E2=80=AFAM Yosry Ahmed <yosry@kernel.or=
g> wrote:
> > > > >
> > > > > > But OTOH, this does seem like a recipe for inefficient reclaim.=
 We
> > > > > > might exhaust hotter memory of a cgroup while sparing colder me=
mory of
> > > > > > another cgroup... But maybe if they're all cold anyway, then wh=
o
> > > > > > cares, and eventually you'll get to the cold stuff of other chi=
ld?
> > > > >
> > > > > Forgot to respond to this part, the unfairness is limited to the =
batch
> > > > > size per-invocation, so it should be fine as long as you don't di=
vide
> > > > > the amount over 100 iterations for some reason. Also yes, all mem=
ory
> > > > > in zswap is cold, the relative coldness is not that important (e.=
g.
> > > > > compared to relative coldness during reclaim).
> > > >
> > > > Ok then yeah, I think we should shelve per-memcg cursor for the nex=
t
> > > > version. Down the line, if we have more data that unfairness is an
> > > > issue, we can always fix it. One step at a time :)
> > >
> > > Thanks a lot to Yosry, Nhat, and Shakeel for the great suggestions!
> > >
> > > Let me summarize what I plan to do in the next version to make sure w=
e are
> > > on the same page:
> > >
> > >  - Drop the per-memcg cursor and keep the root cgroup cursor
> > > (zswap_next_shrink) logic intact.
> > >  - Stick to using the zswap_writeback_only key, and change the proact=
ive
> > > writeback size to use the compressed size.
> > >  - Consolidate and reuse the logic between shrink_worker() and
> > > shrink_memcg(). Enable batch writeback in the shrink_worker() path, w=
hile
> > > keeping the writeback behavior in the zswap_store() path unchanged.
> > >
> > > Please let me know if I missed or misunderstood anything. Thanks agai=
n for
> > > clearing things up!
> >
> > Sorry for the late response, yes I think this makes sense. However, I
> > have some comment about how this interacts with swap tiering, let me
> > reply to the other thread.
> >
>
> I think the swap tiers interaction will be figured out over next cycle. H=
owever
> Hao can/should continue to push and we may decide to let it in orthogonal=
 to
> swap tiers.

Yeah I think there are a lot of changes we discussed outside of the
memcg interface, so maybe keep the interface as-is for now, work on a
new version with the other changes, and we can finalize the interface
at the end?

