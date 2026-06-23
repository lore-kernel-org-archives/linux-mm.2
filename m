Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 724A8CD98F2
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 18:10:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F7E46B008A; Tue, 23 Jun 2026 14:10:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A8F46B0093; Tue, 23 Jun 2026 14:10:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0BFA36B0095; Tue, 23 Jun 2026 14:10:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DBFF06B008A
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 14:10:55 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 605A71A05EC
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 18:10:55 +0000 (UTC)
X-FDA: 84911968470.06.84BD08F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id C0F611C0003
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 18:10:45 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782238245;
	b=gTC5gh8kc62QBYgssqz0xpSlkAfSnXWTd9KEYLG3cb5Z3+pczLkmsE6j7bXzkBLCxSOrs9
	lx1dk9nSnqQz8O1AfThTX/FB/VH0kQk7ASmc2K9zMmV/6neVaPCKf5SIJVZx1XULVvXmXU
	jy1cEEC4WlSa6p4uXwuCTPyj+pzJ6fI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782238245;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tq05N2NyBqQ5JGKENo2Kp7YwhqEkQubdotmf3YJrnZA=;
	b=jJah0ISbEzAZeS3y8SXCUsR9fHmowRzids+Ew5YFwVzDtPlfe6socjQT0ZsmjGIW13ymFY
	p59NKs2usaXVLDhvq3DdwgqMRGfKm2SYzkwXvrH899EJAd/8vlBv8Cq5u3w3pSonms1dc7
	twvy7v36BzhtAfLPx8AUTeZFwUIxTaI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=X1nRv515;
	spf=pass (imf18.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B09B243EED
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 18:10:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93D631F00ACF
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 18:10:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782238244;
	bh=tq05N2NyBqQ5JGKENo2Kp7YwhqEkQubdotmf3YJrnZA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=X1nRv515Stl6t4+NoB6Qix0fteA6CssGL7EH+pwMSccY3Ak5P6yAKM3Rb1l7XfVdy
	 v+rjOF+lidhUlZzT/l/FcWlaf5yW+kdLDq2udjVAy7ShamhhQi8M+hnKRKc26pU2J6
	 POo+qIaI234y7ErtLkXgInDdKbOMmMjHb4yqEnu7fuo6SYwct2Zt9egfwfKQ24+0pS
	 kfZ8LOVHfXwTpumpK6tm0tr6F+CxnSzaFL6C7cPG/O25/MAm49C2grq0mitD8CL6Xh
	 denrmS3s46mguFUWhQ6E9jlCirsGKXLiGX9co3tIUNMYuVIzJDNON+/IpaB4oYMaUL
	 +X16byTeHjz0A==
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-c0c5d170ad4so14476966b.3
        for <linux-mm@kvack.org>; Tue, 23 Jun 2026 11:10:44 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ9onQDsbqh1ospmOO0NCac2gzZslqurKxQuwkYfGQ9GzVzfU0lzNU4266M0TDRlJLbPW/HiXAKykQ==@kvack.org
X-Gm-Message-State: AOJu0Yw+wsYStmJBylpZKNTVvHFJNV9jQ1JcwkIWE62MLkAEcGIyIjYP
	Y4++sReS6JqtcEyQV+dBSBd//0M9v7etES/UWmCr+Mi9g7+1F07KX7jnuhctSB9Ts8if48uXnFb
	J+YB7a9f4GyEaGOkQ7E2gZNt2LR/bwgc=
X-Received: by 2002:a17:906:9f8a:b0:c0e:4007:8d94 with SMTP id
 a640c23a62f3a-c108ecfa2b1mr236060766b.43.1782238243526; Tue, 23 Jun 2026
 11:10:43 -0700 (PDT)
MIME-Version: 1.0
References: <ajnIasdb6j6yDUdy@google.com> <20260623004018.1864121-1-joshua.hahnjy@gmail.com>
In-Reply-To: <20260623004018.1864121-1-joshua.hahnjy@gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Tue, 23 Jun 2026 11:10:32 -0700
X-Gmail-Original-Message-ID: <CAO9r8zOQQwDxmHGsRw_9k2eu6r=HU_HiXxbB4cbpwhc1GGgHOw@mail.gmail.com>
X-Gm-Features: AVVi8CeHkJg-OCEUnLamzkS0g71Y0U9F0-dgswBYdQt5v8lrD2Rr2s34MhEXIG4
Message-ID: <CAO9r8zOQQwDxmHGsRw_9k2eu6r=HU_HiXxbB4cbpwhc1GGgHOw@mail.gmail.com>
Subject: Re: [PATCH v9 3/6] mm: memcontrol: add interface for swap tier selection
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Youngjun Park <her0gyugyu@gmail.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	akpm@linux-foundation.org, chrisl@kernel.org, youngjun.park@lge.com, 
	linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kasong@tencent.com, hannes@cmpxchg.org, mhocko@kernel.org, 
	roman.gushchin@linux.dev, muchun.song@linux.dev, shikemeng@huaweicloud.com, 
	nphamcs@gmail.com, baoquan.he@linux.dev, baohua@kernel.org, gunho.lee@lge.com, 
	taejoon.song@lge.com, hyungjun.cho@lge.com, mkoutny@suse.com, 
	baver.bae@lge.com, matia.kim@lge.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-HE-Tag: 1782238245-967680
X-HE-Meta: U2FsdGVkX19bY28IVgqHzS7v38ywCYlfiig/kxid5EzvwjojIIsUL9XuriC0nC/bQYzJcXOeMMBqwKflJUdwVrQmldAjUnMHo0JlXI+mK5Px9B4qzjmN9Oazh9xyyFNEUtj+RtVDS4WYo3CxSfvkdvG1mteaxk/V01C9BxxYGn75snKbdUjMWGZGtE5LRj7aVSmZnu9bsuwsJZ/nd2BJsyhLlavRdil9dMtgnTBeMe+SSjBjEQDmeoDysDa3RuGDHFpuCJEW8exN35ri0nBCrXFk7Tnvh+Pj2zUBQ6+f40+ByaVN7SU8IuiZaGqD9aWFXc+YrO//YGN0K83LZd8SgU5IHRYFUlrruqXu7UojSrnRpMbe16rt9wXWM5xgMl7P6UxPtCC+AHZrfNHlnHOLUi+a+C7k9VnJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 22, 2026 at 5:40=E2=80=AFPM Joshua Hahn <joshua.hahnjy@gmail.co=
m> wrote:
>
> On Mon, 22 Jun 2026 23:46:31 +0000 Yosry Ahmed <yosry@kernel.org> wrote:
>
> > > > > If that is the case, I think auto-scaling makes sense but can be =
a bit
> > > > > tricky, since there is no universal tiered ratio; each workload w=
ill
> > > > > have different tiers it can swap to, so they will all have to cal=
culate
> > > > > their own ratios. Tiered memory limits escapes this difficulty si=
nce we
> > > > > assume all memory can be placed on all tiers, so we have a system=
-wide
> > > > > ratio : -)
> > > >
> > > > Hmm I don't follow. It's also possible (maybe not initially) that a
> > > > memcg cannot use specific memory tiers, right? I am not sure what t=
he
> > > > difference is.
> > >
> > > You're right, I was speaking more to the current state of memory tier=
s.
> > > The majority of the feedack I received was that we already have too
> > > many memcg knobs, so I just opted to make tiered memcg limits a
> > > cgroup mount, with no ability for individual memcgs to tune their
> > > limits or opt-in/out.
> >
> > Right, I think this is similar to the approach taken here. We have a
> > single interface for per-tier limits. The main difference is that we're
> > allowing 0/max values to disable/enable different swap tiers per-memcg,
> > as there's a use case for that.
> >
> > Seems like for memory tiering there's no use case for that yet.
>
> Yes, I would agree with that.
>
> > > What do you think Yosry? Would it make sense for us to be able to
> > > tune these values? Personally I think it makes sense but just wanted =
to
> > > make the basic features merged before I went to push for making those
> > > knobs tunable.
> >
> > Right now we're not proposing to allow tuning swap tier limits either,
> > just enable or disable a tier. My main question is about the default
> > values.
> >
> > IIUC, for memory tiering, if you set memory.max, then the limits for
> > tiers are auto-scaled. I think it makes sense to do the same for swap
> > tiers for cosnsitency. Or am I wrong about the memory tiering limits
> > behavior?
>
> No, you're right about that. Sorry for steering the thread to my
> series ; -)
>
> To get back to the question of how the auto-tuning should work, the
> main question is to which ratio we scale the swap limits to.
> Do we set the swap limits proportional to how much swap is present
> in the system, or how much swap is available to the cgroup?
>
> So if we have 3 swap tiers A, B, C, with 50G, 30G, and 20G capacity
> respectively, how much should a cgroup with swap.max =3D 10G have if
> it is limited to tiers A and B?
>
> This is what I was getting at earlier when I said we have to calculate
> different ratios for different cgroups, based on what tiers they have
> access to.

That's a good question. I think the case that is particularly
interesting is whether or not the limits of other tiers should change
when another tier is disabled/enabled.

So basically in your example, assuming everything starts as "max",
when swap.max is set to 10G, the autoscaled limits would be: (tier A,
5G), (tier B, 3G), (tier C, 2G). Now the question becomes, if
userspace sets the limit of tier C to 0, should the limits for tiers A
and B change?

On one hand, it's simpler to just keep the autoscaled limits unchanged
in this case. However, this means that the effective swap limit is now
8G, which is not great :/

The alternative is to recalculate all the limits when one of them
changes, in which case the limits of A and B would change to 6.25G and
3.75G. But I don't know if this will work well if we allow custom
limits. What happens if the limit of tier C is written as 1 (or 4096)
instead of 0? It's effectively the same scenario, but the tier is
technically allowed.

The more I think about it, the more I realize it may be best to drop
the autoscaling thing. I imagine memory tiering might run into similar
issues too :/

