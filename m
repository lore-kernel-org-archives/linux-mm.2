Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A661A10A62CC
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 13:17:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CDBAF6B0088; Thu, 26 Mar 2026 09:17:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB3256B0089; Thu, 26 Mar 2026 09:17:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC9B66B008C; Thu, 26 Mar 2026 09:17:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id ACD076B0088
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 09:17:58 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7A667E130A
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 13:17:58 +0000 (UTC)
X-FDA: 84588267036.22.E74E68D
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	by imf13.hostedemail.com (Postfix) with ESMTP id 3C60B20003
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 13:17:55 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PTJfoFFQ;
	spf=pass (imf13.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PTJfoFFQ;
	spf=pass (imf13.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774531076; a=rsa-sha256;
	cv=pass;
	b=eU5bFzjBTreZ1QO2s6BhkbjtPH6vs2WEujgaqo2CGTJvR3O5Z5FNvqHET3uwbf+tUGOo2q
	rhN844Y13Q6YMnQWhTKpDjIxnyvbbfbtAepbHEbJB7XQpMmLCR6rRYhMrL93aV2xeiaTuy
	zuN0fcPQp4syMYPnYfnNlkct/ABKG5U=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774531076;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E9GTDCVwMeGBsczVO/cCzPw62IVDmrrWhei3TdiGhZ0=;
	b=E607ENbg1rAV15ArrCWSlSlvPuACCtHqZ4z0u0WMzatq4h3LEfBL5px9sHESfME8SviMu9
	ubsV/pzpVRQJXG6K5vVinX+TCtJg2Po4MthWIcTfw6+XYqgt5PIH+yO/TwrC3sdmZfLu69
	V8NBE3BInnePNjxfiIqb5rCqcOXvOQ8=
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-65c4152313fso1216275a12.1
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 06:17:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774531074; cv=none;
        d=google.com; s=arc-20240605;
        b=krPBSH1G2dLTw7fbjCEqrDs1nExLuUBmk07hgWEdn1vnfeHBZDzFUV4V3f9J3y5n5M
         lMNNIS9DU5C2PM1DFuBs84Kh7nl+PFrQoWHSXQeWetTuCnJIdsRPTb4K/AFtTCu3HRuF
         fDjgrszvDlvyrTZWuOhRzJNSMLr94LSq9bxOotdEfWYLgIDpHLA5jhuc4YjYQjmkkO1s
         8X9Bhfv9XxcEmRZgncFdPkXXiLWssIoIhx2SS0ISocwSMJ1vwzAw2V0LXnIxkFPXhrX2
         ly3Um4qOMv4M7aBS9b1nw1PFrcRzGEdw1+2eYE3z5SHPf+5VCiQ1h3HyWuF3SkEuYntj
         FVrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=E9GTDCVwMeGBsczVO/cCzPw62IVDmrrWhei3TdiGhZ0=;
        fh=zTeXhQJGriUxixvh4jZqRtEy5+sgKZURMhZnJ6aLoak=;
        b=V7HON3WLuLFxUZGKotnjlrWJOzSY6mm0uPQuIuvkWHQU359BP8kqTUkQdOhDLPQVTE
         MlpleKGhPiVFrPyHH2Ta4ujFKPEBHdXC0gjoEXQB6gpVAa9rJg5oD+cULVgc32N4B4JT
         ucb0mOa4alB20yU4iOHUuVHBpgRrdijpnMKoGXyhmBzEwLu0dw/UtDheph0SfdSy1XxZ
         tgwDPDZ2Gn8FqjYQQxCOE3ex3cHRpv9YOZZKH2258J7sM1e7NUu3Pl5zhxCYz2wNdtt9
         MlFBqX0cxH4Stf72fEktULmTpW02E8AtmQmx/IXJlSScXEGQWAZbbrAT74CKQFnhdJC/
         ireA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774531074; x=1775135874; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E9GTDCVwMeGBsczVO/cCzPw62IVDmrrWhei3TdiGhZ0=;
        b=PTJfoFFQk4FjN1oa47DlKl5U4ZctDXfzp1wpqsTjk2rW/RIYze4CLLooQC/eAdpN6D
         UBdqxIyMv8H1xFhREs7gjU2CSM1PXS/RZoQ/CtHeXvYDoIOiiawg9xJWHseWw6Jnzs+x
         YYO18/nMY655A4fUP+B8MqqojBhPQW//w/3qGkipA5TQvP8FuKxVBmtPL62Q1PLaGllT
         7T2XivVxoC9eTUOB2C9XdYiVAek29kSWyYyIkSrxq3JmDW/k1D8F9xLPhCjihX4C0OoA
         uCAUN9Ebb64N7uKDa/fmHVk1iMwxyPwz8Xp2L1ZVa/zplSh8JoRSRpyaddbBr4AGu9WX
         9pVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774531074; x=1775135874;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=E9GTDCVwMeGBsczVO/cCzPw62IVDmrrWhei3TdiGhZ0=;
        b=DMKPWNsx4wBJ/yUevD4FufcRwhEGyn91JSDjkLFJ26oX70kepmTRkcNks5+HA2jXpi
         Oq7wQa9ckCz/iuc1003WKbToqtDTc6eB5zc8RVWfA6BXDW/PIgWPlUfU2b69A8qwn84V
         DImzO0/GChPf/HJNPGKvOXGucwrtJacVhyo4Z8o3lYCpV3Z6yWyOwmx/9dg2+Ea1kltC
         H8MoKfcgi95KePlLG16tYVSLIhlcDmYH1Lr86fEpob96o9Ht1c1mB3JN0L3+gNDvsRtp
         Ur4Lw0DGWja2+MIHRIwwTlOAKST480YEToGB9HqDVEplOLPe9T41E0IMzedHgIYACnGs
         g3xA==
X-Forwarded-Encrypted: i=1; AJvYcCXKPP6m0RrTi1491UiJk9gp/tnOj5zzyx1R3DDskwIfkPj87GSCBZAVpTNoW8b9l5zc6LbXNEuK4g==@kvack.org
X-Gm-Message-State: AOJu0Yy+wbM3eeiC8htdPJ3bslvRUlHHePa4Br846aIU/1f//34LwbVA
	Nr5oMAOi+7OErkX3WLLRiwONjUlGsgNY94gX/r+IKMaDMElqtk3/slet8eWst+iaPA6LzgFqXbA
	apqIDTj2tiQ+ewU+JyHNOMZSqbXtau1Y=
X-Gm-Gg: ATEYQzyxqjFsI8Jdj0bdRPOv6qymcC5OCM60Rqd1K+vp0ilBhrrPecunfO8/UKEJVjN
	lzA1T49SPxnwu/ACtBnKYrUOUhBEP6/mBoUVuYGQdsJWConSBDWKuZkoHUxmNxVYIf7zLH/V09P
	A911B+QLjBugc8mpxc4FF2RXf6kxRmoGw7a0nW+708JP5XIb0bFoxaDBh+3WvxBsdnBXViIkGMk
	k/6ELUlM62Mu75zNEmHPPq8wahi5owcx4nLYeDq9h437bzoG6nvXNsHgsi9tqv9MkBlybpwzsLc
	yxqt03Bwh7h7srICjpbSi8/3HJK28E+YoAfYqavk
X-Received: by 2002:a05:6402:2116:b0:667:7fcb:3a2c with SMTP id
 4fb4d7f45d1cf-66a826b30b2mr5290589a12.24.1774531074263; Thu, 26 Mar 2026
 06:17:54 -0700 (PDT)
MIME-Version: 1.0
References: <20260325210637.3704220-1-shakeel.butt@linux.dev>
 <20260325190547.abb7309fb63473b57b7a90a0@linux-foundation.org>
 <CAMgjq7A01C+wyHxytZfVFVvaJ+gUNqkKvYN61_Peo911YaBHOw@mail.gmail.com> <f617acf0-6bb6-4ea0-85c2-d6f377a2a574@lucifer.local>
In-Reply-To: <f617acf0-6bb6-4ea0-85c2-d6f377a2a574@lucifer.local>
From: Kairui Song <ryncsn@gmail.com>
Date: Thu, 26 Mar 2026 21:17:17 +0800
X-Gm-Features: AQROBzAswvzSo_XDIOMliFjGAdPtY_-lxSRrG10NjtiUJ7upcypDaYx0cmhdW7U
Message-ID: <CAMgjq7BfuYsxhhf-XqKH4B622NGP-9bmriSP2eMiygH9ZJMANw@mail.gmail.com>
Subject: Re: [LSF/MM/BPF TOPIC] Towards Unified and Extensible Memory Reclaim (reclaim_ext)
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	lsf-pc@lists.linux-foundation.org, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
	Qi Zheng <zhengqi.arch@bytedance.com>, Chen Ridong <chenridong@huaweicloud.com>, 
	Emil Tsalapatis <emil@etsalapatis.com>, Alexei Starovoitov <ast@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Matthew Wilcox <willy@infradead.org>, Nhat Pham <nphamcs@gmail.com>, 
	Gregory Price <gourry@gourry.net>, Barry Song <21cnbao@gmail.com>, 
	David Stevens <stevensd@google.com>, Vernon Yang <vernon2gm@gmail.com>, 
	David Rientjes <rientjes@google.com>, Kalesh Singh <kaleshsingh@google.com>, 
	wangzicheng <wangzicheng@honor.com>, "T . J . Mercier" <tjmercier@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Suren Baghdasaryan <surenb@google.com>, 
	Meta kernel team <kernel-team@meta.com>, bpf@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 3C60B20003
X-Stat-Signature: y48u6sa9jmrnihfnmb5kbuysiggtpx5x
X-Rspam-User: 
X-HE-Tag: 1774531075-953281
X-HE-Meta: U2FsdGVkX18xzLRM7cqR1IpLFCsYmwefMcGeEgFeIXo+tpAHIcyR4HJyxnXa4pYbspzNA2W81RkIHFLRlIdPe6HPcrxAe7M5Yxg5rkbaxtrzvU7WlQ0AyyIpOJfUj3D1UE5f6QI56sT/v56oqCO0vvuSe8PyPQub0BHPH8MglIbRg4xlnffSuTrHM3OFhH7hFM8tzJLuafIFDAnBFb4/9vtGthCt51KOIs/52BtR7Qh1j91HF95P3u30eIMA1tn5gdidsoXE5sH55f7WB3ORn3WXGpJVlfTvrH7VfYO05Q8FxvVOQIw6YyvxJKPKcjHcBGEboyfDw2NHJqm6wGRxQroUEj1MaYV3O7glK1wb3FNwmTnnmNugiFrAXdqZoDqxAueulCNYVqXDrcEoEq3rAm9Ah/RkD2iuBL0aeZ9DQu8XUU0PmsavnV1BKvoYMc2AsylUQbvtxlN2F+BlzJJ+hR+cZqT5eMllIGefJcQ6NZMck0/SSksEMTt3Wk0HwRgzeyn7YknfD7vEWs5NZWj0IoQ+wIBR/hQcFvu3zwWXnTDyLZPA0CTbFomQqVFHKohjVjns20/upHsJ2E/cLSVCk/ZYHbR9JPuU39YS7KR0Q4KppbWdJUJKxYmTsFHeAOBCD1Y4X2GvQuXB0JdM4xl6ZdRMT0ux6la1YLSPni795i4dA4nN4QJ+5eo+uZy9OYBDXJvNCpW1O8ODiY2L5LWedCFbrBfWVBqKmZoYssYIkWiid0ebPFE5FiayH3aPlqCKeApzCFWnw/OdP/04ApLKP8KSNEC7cUMCUlhkTBYrxV6/z8oP5zzMeWVR6Mstv8TBbSgo6uao0EJvc8vP3Wd+mLYpNVQB9GE/63WU/U5peo0lNB44+LMaUDKQdrkFvIeG/0DC0+GHYxyNcswzzZTNFOdYRHlNxxDygD6zqU/QHbNXqYCGzqUaygdnnev58cVNrRQstXcTi7g2qwj9zO0
 XtzN8iny
 KdrCceAwqpjZgiW2seYebJm9/g94wtYrSMfEtI7vs6GmFES9pgUyJrN5vtD+bZYRry97FFPiGtzGAtGGc+KiGx4XSsDKmT8kw+/lUZVnRrF1eG3/e/02+2sdm/b5QxDHlcUrB2o8qyvXyAgOSua1J8zjPtdEz0jYUb9yaWyqqWob7oD4VH0/G04jCCJAPvuvAftpAMG4g1C2nJ+UuRlG64TUM5JLI/44TrFkQcRqrTofY0dVow1ZpLiXLseBsjMVm6m8lvXScR2i3l+9ge+rcvTGA9WF9Qd/3TuSDg2Of31yNW3EsIyhitoRivznMr21q8MOF2ZT/fC7aMu6XXxHsuhkm75+8RlaOzoeVmqnMpyLasX/NdVMbDC2IAHkCEdLfVh/2xS0kMyIqie6gV6BfMEYt537CBBqKLgbyNGjs6EmSNFSKAoQQpCVTojG4dxN9dEv2gQ6rOAd4lDb8MqX6xIB9ygVD7ar3SAxTESmLgV+cCIgfgZ8mH0kZndNmFDmRL3ooodiAuHWtESa8yELIG2eGyQeexZtEspGr4EBO3We5GuQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 26, 2026 at 8:31=E2=80=AFPM Lorenzo Stoakes (Oracle) <ljs@kerne=
l.org> wrote:
>
> +cc Gregory
>
> On Thu, Mar 26, 2026 at 08:06:13PM +0800, Kairui Song wrote:
> > On Thu, Mar 26, 2026 at 10:05=E2=80=AFAM Andrew Morton
> > <akpm@linux-foundation.org> wrote:
> > >
> > > On Wed, 25 Mar 2026 14:06:37 -0700 Shakeel Butt <shakeel.butt@linux.d=
ev> wrote:
> > >
> > > > We should unify both algorithms into a single code path.
> > >
> > > I'm here to ask the questions which others fear will sound dumb.
> > >
> > > Is it indeed the plan to maintain both implementations?  I thought th=
e
> > > long-term ambition was to knock MGLRU into shape and to drop the lega=
cy LRU?
> >
> > I personally also agree on that, so far I'm not aware of any major
> > issues with MGLRU except some corner cases that are not hard to fix.
> > Once these are done, I don't see the need for more complexity.
>
> Well... :)
>
> What about the issues Gregory raised here?
>
> https://lore.kernel.org/linux-mm/aaXM7xNSJaJBsety@gourry-fedora-PF4VCD3F/

Hi,

Thanks for linking Gregory's mail.

I'm not quite sure I fully get what the concern is, I'll try to
address the main points I see. Regarding the bi-modal distributions,
it's very workload-dependent, and the reclamation still performs well
with that distributions. So I think that's not really a problem?

The heuristics are a bit confusing and intertwined (gen number as
flags for atomic update and avoid LRU lock, tight coupling with
generational aging, etc.), decoupling them cleanly without hurting
performance is tricky, and the current approach has worked
dramatically well. Cleanup the code structure might be helpful?

Many distros have been running MGLRU by default for years now and the
feedback (plus our own production experience) has been very positive.
There are indeed some known rough edges, under-protected file cache,
ineffective swappiness, flag usage, etc. some of which I listed here
[1]. I believe they're all fixable, and once addressed MGLRU should be
a solid base.

Right, I realized after re-reading that some of these really are not
really easy to fix or improve... sorry for my earlier reply, guess I'm
too sleepy today and not thinking clearly :P, my apologies.

[1] https://lore.kernel.org/linux-mm/CAMgjq7BoekNjg-Ra3C8M7=3D8=3D75su38w=
=3DHD782T5E_cxyeCeH_g@mail.gmail.com/

