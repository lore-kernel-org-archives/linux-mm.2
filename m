Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B5A3C531CA
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 04:50:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA6ED6B00AC; Thu, 23 Jul 2026 00:50:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B577D6B00AD; Thu, 23 Jul 2026 00:50:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6CDB6B00AE; Thu, 23 Jul 2026 00:50:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7C1186B00AC
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 00:50:15 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CC22D1C07E9
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 04:50:14 +0000 (UTC)
X-FDA: 85018814748.05.1AE4547
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 106BD100008
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 04:50:12 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784782213;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FMjWTfMQm24IrOQcAUu4P0m7ZHBvO4nfE0gC8fr+FUw=;
	b=DZhUOJoDR5PzO/s7xQzgvfC8is5dmdYUze/LAHoKR9bkr4rPchBxQd9E3KqHMRGeOES67m
	4OVXd/6qM1YMN95vjPgnfPvHlPB9vKESxv9yZrybBAbJmxrFYb8kqeMKzrt0uMTJiPn1mS
	rSBaZiJ6xCONee3I0TKt2rEgda3sMA4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784782213;
	b=r/lPfOutOvHBAVyw2pptBjf1XB0Ghqxht3KVO2PZ3/JWRohcxpkjmlzzmavFkasRiWJchI
	4TDlec67qVct3S2H//RRJSr3Thgme71sbKTVUeuveupASH3tK69+YUMHArzqq6g8xGmtey
	x6HAdtam2gXtd1aKMSDqjf5v/GLk6o0=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 82E37600AD
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 04:50:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F7191F000E9
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 04:50:12 +0000 (UTC)
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-c12614b81c9so37931566b.3
        for <linux-mm@kvack.org>; Wed, 22 Jul 2026 21:50:12 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RpqnSAmvSChDgjudQTRKpt0THFg+9YmO9Us3CGSbqHUH16UMAV8qMgYPK4ihJwjbyMQysxi1QKl7g==@kvack.org
X-Gm-Message-State: AOJu0YyuF+Yp3Omff8Na18WomabYn4Nzmrq2Jblsaw4YkqQ+V6C0tRHh
	gugJbeBe6ukwM7J5VnIvNKajk7AnMY6YR5Kl87EUTKcU8H6PiBhZ/5id+iCckZkHV8KaMN/azaa
	eAnqt5TDZzzdmw9cKDE7HxX8oQgBGrxI=
X-Received: by 2002:a17:907:748:b0:c19:482d:a9ff with SMTP id
 a640c23a62f3a-c1c5092c602mr54121866b.49.1784782210562; Wed, 22 Jul 2026
 21:50:10 -0700 (PDT)
MIME-Version: 1.0
References: <20260717085151.22822-1-jiahao.kernel@gmail.com>
 <20260717181839.c94d0335ccef0084707d3d85@linux-foundation.org>
 <CAO9r8zOrXqsEaCEJUUAxbAhhN_OQb8ejogeUa6k8hX_JV8hxxw@mail.gmail.com>
 <20260717214031.8b22e9a37ea3b0c564b466f0@linux-foundation.org>
 <7dbde343-fbbf-6a1d-1785-ebf9f5a04f6b@gmail.com> <0a96b7ec-0d8d-2abd-afaa-739c562bc985@gmail.com>
In-Reply-To: <0a96b7ec-0d8d-2abd-afaa-739c562bc985@gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Wed, 22 Jul 2026 21:49:58 -0700
X-Gmail-Original-Message-ID: <CAO9r8zO6AsdZZWoYibAj6urMxgM3eq4bg9JDhr443UZONPF_6Q@mail.gmail.com>
X-Gm-Features: AUfX_mzaNnM1ixKt0yQEanzxGLlbxq_UPtI0c8jx7a9Gq-UbW7nlyF7XYuZm9aU
Message-ID: <CAO9r8zO6AsdZZWoYibAj6urMxgM3eq4bg9JDhr443UZONPF_6Q@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] mm/zswap: Fixes and improves the zswap global shrinker
To: Hao Jia <jiahao.kernel@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, nphamcs@gmail.com, tj@kernel.org, 
	hannes@cmpxchg.org, shakeel.butt@linux.dev, mhocko@kernel.org, 
	mkoutny@suse.com, chengming.zhou@linux.dev, muchun.song@linux.dev, 
	roman.gushchin@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, Hao Jia <jiahao1@lixiang.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: c7rguj7trzdtjwjwhbssdcwt5mtq654h
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 106BD100008
X-HE-Tag: 1784782212-876439
X-HE-Meta: U2FsdGVkX18umYFIyAdgukDMNLYcQvcC0nT+0X+Xx0cJspE2CMy2qg2YZxUbSQmTKkcXsU0Qtl1xLzNp9M/d9fdXI0WPeddPEHh53GUbgbOjTiyHJQr3s3YIZrOr4hF0b0AqNKd+uhiKvdn9kbw/ntaEXG/Vwg3aASka7bEiXRg0Fnq15xnxsW0KkolCupZ3ZfRuqDip9PzrLIRfn7SB3Jtmd7aFe6OwcNhaE6FUcsgqJnLe9Lljvxuqg7J++AArYD2fer9ofCpS5pByy7pJBELx9Sbl6IF8387z7KvyJlZ0FQ5rl4jFOf3ResOjt+MbCuzE9V+POvm0Yyy9q1QZKkeRJQRJqK7S8N+bSqd747lHz7iWLBYyc+oArVTOYZk9ecEeRozbmb17tqsLtGlIQhwE4Tuw6J2Y3a+CLg2hLqHRsSR+Gr9fjBRqF5iH3JjFCVEfvP+uItBAS7vmZl3xoPoYU8r8qI6NdCrr6mI4Mi1k4qs7xP9XzZlxQvmG74TBEKq0QlWlNFBazEAjYZZh6Tnmm1ymQvhFJ3+AzX+enB6CMmoqdv6f2hMNDP4CpxgdIFpm3+5olMFJhwL4w4uq1F+7gdO1SrOuuVqSWkQF0pV/2HUl9UbgoTH8nnWJSU54ew3p9QulKedP/uyjnjyXLek+JVoOPr+vbK2R0eq2+TrKFVz31LzvUck1t+1swegDHJ2bVUchRsXvBSgIa35OwhKSn4SPKTsUa5lgn2X6jVZN5UdBYO/HGG0fO49H4sM0H+I5ja+M3wyHnTA6hFs/QppBLwyChH2RsUL6YJge2qsinhDA6Xg4SFPA9ItC7Lmf+qmyTm2dHAAJlCwRgpwBXNNjE52JYNIIf2C7iHoOy68p7V6yZW29PCTZ0ua0SUDCH3Hwp4X5YzhcjTINuKCHF4miP5gczm0Xkd5GZGw381/nyqnBQYAeHn3PsDddBMK4aBGXBsZD7Ch7kFFKlKj
 xEcU3543
 IV05FFgP9erlUHcM/i03e9F7yibNUNYYTFoJSpZezfqtFswOLPtjNN/UfB1ryltfNaRurKm078UULVzXn+A/NfXBkwig+9WZsv0Fn08lOa0DOvmzOg1JAwVBTWry2PVB+swKgfFWQnbg6YSJROz7LFXYZbsRORuvSqK9XrxpV8sDpUs7lbsIjyLWJDe8AIb6WpNYEQIuqOsxnIFxxfC3CFebtkcZK3AcgwWCKUgjvttHjpfnZPO7pm/vbDgkNeHydV6xpRNhF7i29UhA+WkKMVfsPFCAOWiQeF4l0kv3RrMxxoV4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 22, 2026 at 6:21=E2=80=AFPM Hao Jia <jiahao.kernel@gmail.com> w=
rote:
>
>
>
> On 2026/7/20 09:26, Hao Jia wrote:
> >
> >
> > On 2026/7/18 12:40, Andrew Morton wrote:
> >> On Fri, 17 Jul 2026 18:28:04 -0700 Yosry Ahmed <yosry@kernel.org> wrot=
e:
> >>
> >>>>
> >>>> The [1/2] changelog lacks a description of how the flaw impacts user=
s.
> >>>> Please describe this fully and maintain that info within the
> >>>> changelogging.  This info helps -stable maintainers and others
> >>>> understand why we're proposing a backport and helps myself and other=
s
> >>>> with timing decisions.
> >>>
> >>> The first line in the changelog should be sufficient imo: "Zswap
> >>> writeback on hitting the pool limit is broken when memory cgroup is
> >>> disabled"
> >>
> >> "broken"?  Perhaps this means "fails to occur".
> >>
> >> But what is the userspace-visible impact?  IOW, why are we proposing a
> >> backport?
> >>
> >
> > Perhaps the first paragraph of the commit1 message could be modified as
> > follows? I have added a description of the issues that occur without
> > this patch.
> >
>
> Hi Andrew, Yosry, and Nhat,
> Any thoughts on this change?

I would front load the user impact in the first paragraph:

Zswap writeback when the global pool limit is hit fails when memory
cgroups are disabled. The pool remains full until it is organically
drained by swapins or memory freeing, leading to zswap store failures
and pages bypassing getting written directly to the backing swap device,
causing LRU inversion (hotter pages with higher fault latency).

...

