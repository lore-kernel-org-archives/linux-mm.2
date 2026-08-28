Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1C1EC61DB9
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 00:51:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B43C86B0096; Thu, 27 Aug 2026 20:51:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B1B456B0098; Thu, 27 Aug 2026 20:51:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E35E6B0099; Thu, 27 Aug 2026 20:51:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 751316B0096
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 20:51:29 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 10C74A338D
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 00:51:29 +0000 (UTC)
X-FDA: 85148849898.20.73F5C39
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf01.hostedemail.com (Postfix) with ESMTP id 166F240005
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 00:51:26 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=iKDmevxI;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787878287;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qU4cMApGQ1ZW0Ii9xuVCvK7JsWk6E/GnsI5UAJcS9yg=;
	b=Fq8PFBI3dw4qXU3kP02377KE8oyJBo3QooA+WzFPQVPhRg32scuitTtvDSV+ycNG+zkFly
	84D1lt5P4Pq+6wMpJq9ffW5kyqAruac3BKOKPK/hyZTVmJKJMTapY9B4bzM0WncWTqzZPu
	uBTbx+dxnD9Q7sFi925CUxWbGWj327E=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787878287;
	b=ASMxnhpFm0+KB3rpQ1kzchlkuM8+GcHc/kLj0rYBfGWDNqgsEaoS4Kyoq+nNGp75Bw9kAj
	bSvAxFvxR2hJ3x+wrDtLfwhVjw5tFb/Wy/MwVFZE/VUrZyW7aINyNa1BSiKFmlvbPOxdFA
	nF1psAdWyDm+ztNjHqNp3S3c/+BiWSU=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=iKDmevxI;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-49b9320423cso2023425e9.0
        for <linux-mm@kvack.org>; Thu, 27 Aug 2026 17:51:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787878285; cv=none;
        d=google.com; s=arc-20260327;
        b=XVvMGYpMgayNS+1dpwZXRqx7KGJPiiOTKc7UAotOG1k4PjIigk4+tkXsdh8g620nZn
         93ZFBBelmVNBrWkaSp5EC4GY6JpLXH5NAG8kVhY2340wJfdlTNrW/fBqNffpiZGF0Ldz
         ++i37QXpQnUqAHe5SK1tZqvUIiUkySqbX8V7QD01VkXBnnao8FWpuu1BKVTG2emTrblM
         Md9voTM2LNnFCQSvZHEgTTFsIOXb+VNd1j8SYPyn13BetPgeSd0R2NcE8Fy/fdAnCoEP
         F5iRKnwfZ0A6DYFTfgZ+7Q12c7Fwy7IBZ/RvA5dgNYirKyeDoNB+z1hs0Re3BpaHEtF4
         VRCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=qU4cMApGQ1ZW0Ii9xuVCvK7JsWk6E/GnsI5UAJcS9yg=;
        fh=h3kY2iZe4NwoQtVi2NDwDsdD24cpGuOmvmvUfDyYTSg=;
        b=hbbDFzVGvXV3KI5G8fW/TV0Fp94BMCWqYNF2CDZcS8O0ZdzzTrpnbQyYO2bcz+lGj8
         s4uGlGCemCU2NkJa3gq9j93kX4BZioUmgNPULADe842+SsY/g2WS/VYCIRZisGdmiqn5
         wJS8LFxQAFkokUcuqlIjinHb0Sj2Elv7zr4wkc9uZNNirtHBGUjryGLaCEhNfqIVcYM9
         6WabMsXAhdcFXcRVfC8t8Zdwx2TF5uxkKDLqydS3H8ehwcW/2arTFFtb6HHCU0mMBRcr
         4yUIegTT6VB7I2VNWcti1DZo0WCMbXyQlZBoE36mHXzKO9cVexD1rBFmKmAKjD17Bi8e
         aHLg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787878285; x=1788483085; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=qU4cMApGQ1ZW0Ii9xuVCvK7JsWk6E/GnsI5UAJcS9yg=;
        b=iKDmevxIjLzTEMZCHa6tr0nYWg9koFOU9DGCybrDVdembIH4hPR4+BO9dE08v7q4Dp
         HEh+rR40/1UW0SiCm1vvZzBIu8Lir+ts/KqPt1Od/OovnPtW5f+wil34zVYQCKcsnuYT
         43gq2zxrqhdPEpxwLdsRQ8S8D4XHqEe5BwcJNrQbNkYGnaPy3JFkP6xc1i88Faawj4ax
         LlmTgqaBQy55H880Y2B83a27ygjcQMJauMiHyNYYFFWXZGkrUFe0eibkHLEnVfmP69Xu
         924S3kHADqQyQr4xvr1RnKFCINcrom910jWLXlYvVZuJZchObMK9Mz+FApbNFQgXIaEe
         MaSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787878285; x=1788483085;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qU4cMApGQ1ZW0Ii9xuVCvK7JsWk6E/GnsI5UAJcS9yg=;
        b=F7fzme2bdMa5y2xUq1E4UzKnDFqSLy8QA1HhHvG8iyQYSlocnKgamPOpEK+ldrBME+
         4xK2/44Sjz/OnnEQrdNTvLQkqgVtJWGlfNe5cI4RhcQMqy+5TkoJvZGRjhPt7F5amPzA
         eVf9P3mgLolojAoa42jMEP7z0FdjRDts+7qKS/5ojWbI5+/0VrL9IfrXE8qXd32BbjWd
         F+TKCuTLxwXoJ3dsG5pK9/9q/vALlXJLvZ4WGbkav5xoq1nzW52wqVoQV2JpVjudhD3h
         tJLUF2hpeT+KwEq2xTrUH+oOlPy4BhP1Vz5Z3wFs3QVrqZ/c+slNHQu788/ROaLSd0MJ
         0iLg==
X-Forwarded-Encrypted: i=1; AHgh+RqJr43sp8X8fgj0HqjIRNlnON2XFWXc/F63MnAQwy2Q7A5Ju4KVX8d0cQ0CdsCXFsCqsh0ClHcUjg==@kvack.org
X-Gm-Message-State: AFuF++lUAZyI5Pnh1WXMhQ89/WtZpkCgachInP167xi6RlM5m7/A9SKL
	/3RGMc7xR2qqbSvwsbEn5KRKfvO7W/VQzMbJnNaCPEbTcuqqhulyBS+WccWwyYWeQr92SDVS+pK
	eqWGtWhSH4YYgIJX0GciDMtHobtA4SFg=
X-Gm-Gg: AR+sD11P4Dhw6MxCepiCVw/MCfrEmm3MMR/n3rJMMvdU++ZSVN2hWT4Nn2tp6R1rqef
	lZf1A95wfJIy3MPWp/2PhjMMnlUg1v3uSB1bkl8oOVVNVYEKPucI1EMi4crlMJ+je9Bx0Vng7uX
	CiVm7p0SBTqjUESnZp+uhyz+WLpSpuo4BcqMLop+gORofwiJsHnnPk6R0kb6asAtaTIibku0t3t
	uToVhswasp2lfxpXGMIDjFq/LxVsYNPXQG8t0s6Gg9eTNZZSeqJWzwg3xs5zpfQ7KKVtv5v9mzP
	gvuvJNFWoNWOdU72g+vw7nA6VOAYbXNsYUoB3tq5slwjKyQbRC7ujvmnuQ0KW2+/5enOExy/Ppx
	4g/660+rX9gv6f1aaZ30LRDVBEyKzX5FM05QtQg==
X-Received: by 2002:a05:600c:4594:b0:49b:4d64:bbc4 with SMTP id
 5b1f17b1804b1-49b91c2f990mr34163415e9.8.1787878285359; Thu, 27 Aug 2026
 17:51:25 -0700 (PDT)
MIME-Version: 1.0
References: <CAJnrk1bk66ZhRAS7mojSnD5RBfFS+0ChAPymE3ObRWr0C_udWg@mail.gmail.com>
 <CAO9r8zPpe6fWOSXtRUjFB8WNMroeBqvLT+2QtAU4E27AtLUXMQ@mail.gmail.com>
 <CAJnrk1YifN22mA5PFRVrh3m_ygxax6x4_8nraG2hPqCzyzBj7A@mail.gmail.com>
 <anpsLy_pCanocgS1@google.com> <CAJnrk1b5asARJ_g176DsoNCvf+iFqzPbOtVveeuPxTPZDmnuKw@mail.gmail.com>
 <CAO9r8zOeh1fFsY5CG1C8CDCJH25eiioY-otRv6Krn1=S21PeaA@mail.gmail.com>
In-Reply-To: <CAO9r8zOeh1fFsY5CG1C8CDCJH25eiioY-otRv6Krn1=S21PeaA@mail.gmail.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Thu, 27 Aug 2026 17:51:12 -0700
X-Gm-Features: AcwNN1U84_r1ZsaRjTsQYeTnIouvwcCd5NXWhuiWrqoKKgqvoIXZeqezPE43G0Y
Message-ID: <CAJnrk1YO5E6ETxn9RmM-LWRQSRxwF9iEakAPz6veMPjaKMAEOQ@mail.gmail.com>
Subject: Re: memcg stats flushing (WAS "Re: [PATCH] fuse: disable default bdi strictlimiting")
To: Yosry Ahmed <yosry@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, Tejun Heo <tj@kernel.org>, Jan Kara <jack@suse.cz>, 
	Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, kernel-team@meta.com, 
	fuse-devel <fuse-devel@lists.linux.dev>, Jingbo Xu <jefflexu@linux.alibaba.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	linux-mm <linux-mm@kvack.org>, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Jesper Dangaard Brouer <hawk@kernel.org>, Yunzhao Li <yunzhao@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 166F240005
X-Stat-Signature: emk8xwossepsdu5ctaw4sgnq7k34kan5
X-Rspam-User: 
X-HE-Tag: 1787878286-126246
X-HE-Meta: U2FsdGVkX1/4cc/+krQmMuEKnvC8ZiP0pEjfIaQUUGwmTRYOTI5xAmvGh9jKE671pwItg6+WL0znGGeGCOwvSp8aFYMk6byTDtwDxmBAMMHdW6iIn8YXHcbJhtBP24ehsLyn6qHLdieL/UpFCC89HQy1LrG6lxMgYJr21ITlyWQehVnnj0hUqnSWqtwOSaa9Us72JMooAXsZcK2ufap8BdMsgDFGKjjzUOLRFVw39Wun+JkHHyDytvewQwMLfIAyuvn7YXiQtT9PEmh9UYKRUHrb3IOT5H0NefIuShjtJSl8HLET6kOySvkQd8BYSwNXH5aJZRRU5uL5N8S7zG78IhRB5F7n2dw+Z1Riis67HBYf2l+XxGU4zKvV7WBB/G7YdWqrwm+CiJx5iB6jniZ1G/X3F6Zw4URPFulmX3Mujqw9l23qOKiaaF74NM9vTViLGhwFp32xd7MoTUZYjHeRjL67fuklcTqsOCNyTtlnhI/1kLo51PZCXn8EvrbR0vlY7Ut2KSNyC+oa2JWIIIwphYIPgy/eAMUzY70tnyagtrcU4H4UCaLXfnpjk4Le5p0WgFKjWycLwF+jGf1MJbrC4knLq8V8/D/W7Rf5cFyFwzv1yYlC2vasynwhsdz/EdC6s6rLQLyMOAIc0LtZH1l5gX5bcYbhnekXzEkVpOILpGcyv/7ZK5OfJK5t1NsRX4igWXi+nfeIXfxW0bf2uFfMzIaQms2oY0zbdbsa3b7gaBAPPYHt5UwhirWf5xspec5KlEhtURZK9cEXLf/XyuXyHClcurUeQ9b5tabDpEWqcWx9QJVdTeCv44mppq/TLW2DYZ/UzJzLloVAn3zi95AcNT/SifUSUGAGbG3rBdQOKOdoaDm8T1BjYprm4HcH8VcYrmSWm98m7s5JysDgBoZJ/0z2XJ5ipzaUBZej0pXQ75KJtLU04x5AtZcs8uU3Rb5Ilo6dvWDKc6WnfiURuJg
 p6I/pVYv
 njNKL1fKpAIgBJmdx9kn6oNkFIOpc2zLAK8I0rne+Ans/ufye6GlWVd/FwyrwcLFrFi8u24NEUQKpD1F7YpXTH1Dv+lxPRx9ZKSp6Yypb3QCldoPeG1Is3nb9DVzFsj/hSVDCXjwlpFmp/vcUgSCUlguurj9KqoFPDbdDzZ82CrlNbaFNHpL7SNsgAx/NqwrgrFApuT/17i0HpnS1QIvoBL8HgB9JuwfQzNFd3KPEw/HmXERUOYTpP1Gcu0fabtRMrT8UlUugWeMyk29Pf6sl0BdCLhmr0N0qwJj1V2Pw9+Ca6Pa18Sc5wQlkNzmoC5tVvlpCDijO4bvzxH0xeV6ukur2FwJlpQnym/My2fGVxJZO2SDqHGXjWCPzObzLJCWP1DUlpt3vtjotrQR772EvaZLyOQg6wyEyJbaA4rzRVUlCpm/UV+PqHUjVaNUVUiu5Uugmp5K9jWAhpi8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 26, 2026 at 11:31=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> wro=
te:
>
> On Wed, Aug 26, 2026 at 5:29=E2=80=AFPM Joanne Koong <joannelkoong@gmail.=
com> wrote:
> >
> > On Mon, Aug 10, 2026 at 5:48=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> =
wrote:
> > >
> > > On Mon, Aug 10, 2026 at 09:49:31AM -0700, Joanne Koong wrote:
> > > > On Thu, Aug 6, 2026 at 2:31=E2=80=AFPM Yosry Ahmed <yosry@kernel.or=
g> wrote:
> > > >
> > > > For updating the stat on each parent and having the flush path only
> > > > accumulate CPU counters, I think this means we would have to
> > > > unconditionally walk the ancestors + update its counters on every
> > > > update, as we wouldn't be able to early break if the flushable
> > > > threshold was already exceeded. I don't think we could replace the
> > > > stats_update update, as it seems like readers still need some way o=
f
> > > > knowing when to flush. It seems like this could be a nontrivial
> > > > performance hit, but maybe it's a non-factor in reality. If you thi=
nk
> > > > this would be useful to get benchmark numbers on, I can run some
> > > > experiments on this too.
> > >
> > > I think we need to experiment with how much work we can shift around
> > > between the update and reader sides.
> > >
> > > Right now, on the update side, we call __css_rstat_updated(), which
> > > iterates the parents and puts them on the per-CPU rstat tree, then we
> > > iterate the parents again in memcg_rstat_updated() and:
> > > - Check if flushing threshold is already met.
> > > - Update per-CPU counter for stats_updates.
> > > - If per-CPU update exceeds (another) threshold, we update an atomic =
for
> > >   stats_updates.
> > >
> > > The flush side checks the flushing threshold and does an rstat flush,
> > > which will walk the update trees on all CPUs and iterates all child
> > > cgroups on it. Pretty expensive when the threshold is met.
> > >
> > > I think we discussed two different options:
> > >
> > > (a) On stats updates, iterate the parents and update the per-CPU
> > > counters of the stat directly.
> > >
> > > In this case, we can't keep using rstat, as we would still need to ad=
d
> > > the cgroup and all its ancestors to the update tree anyway and the fl=
ush
> > > cost will remain similar. So on the flush path we'll need to iterate =
all
> > > CPUs and add the counters. We can explore if use a cpumask can help
> > > here, but perhaps not since we'll need to update it atomically on all
> > > stat updates.
> > >
> > > I imagine that if we do this we'll drop the stats_updates optimizatio=
n
> > > to avoid adding more cost to the update side. We'll be replacing pare=
nt
> > > stats_updates modification with parent stat counter modification. But
> > > maybe it's feasible to keep both to limit the cost of flusing.
> > >
> > > This only works if the cost of iterate the CPUs on the flush side end=
s
> > > up being cheaper than the current flush. I imagine the average cost w=
ill
> > > be higher but the cost should be much more consistent vs the current
> > > flush, so the tail should be better.
> > >
> > > (b) On stats updates, iterate the parents and update the per-CPU
> > > counters of the stat directly AND update a global atomic if the per-C=
PU
> > > counter exceeds a threshold. I think updates may get too expensive as=
 we
> > > may need to update multiple atomics, especially when updating the roo=
t
> > > counter as it will be contended by all cgroups.
> > >
> > > The flush side becomes an atomic read, so should be very cheap, and w=
e
> > > can drop other heuristics and optimizations.
> > >
> > > ---
> > >
> > > I think ultimately we need to experiment with these approachs (and
> > > perhaps others) to check what actually works in practice. You'll
> > > probably want some benchmarks or synthetic tests with many cgroups to
> > > exercise the worst case scenarios.
> > >
> >
> > These are the results I'm seeing from the benchmarks. I'm comparing
> > non-ratelimited rstat vs (a) vs (b). I'm comparing non-ratelimited
> > rstat instead of ratelimited rstat, because ratelimited rstat relies
> > on the 2s flusher and doesn't incur any additional flushing when
> > called.
> >
> > ~On the update side~
> > ns per update (measured by having a kthread pinned to each CPU and all
> > threads updating the same cgroup for a 200ms window, run on 80 CPUs,
> > computed as total CPU time / # updates)
> > depth      rstat      (a)         (b)
> >     1        22.34       32.49      60.10
> >     8        22.46       47.12      140.72
> >     16      22.49       70.96      206.39
> >     32      22.51       139.16    305.40
>
> There goes my dream if an rstat-free world :')
>
> I am very surprised though that you care about hierarchies this deep.
> I don't think we have anything close to even 8 at Google, and in all
> my previous testing I usually test up to 4 or 5 levels. I suspect at

At Meta, we often see depths 8 to 16.

> that level the difference might be acceptable. But aren't other
> operations also really expensive at that depth? I imagine the charging
> path is really slow if it has to do atomic updates for 32 parents. Is

I agree. This aligns with what I saw when running the page counter
approach for zwap on depth 32. For the writeback path though, the
dirtying / writeback folio lifecycle is just stat updates. There's a
charge, but that happens only once, when the folio enters the page
cache.

> the update path really a problem given everything else?
>
> Given the constant cost of rstat updates, it also seems like
> memcg_vmstats_needs_flush() is mostly evaluating to true and skipping
> the parent walk. I wonder how much this remains true in practice, I
> think Shakeel mentioned that it does help in production.

I think for the writeback path, this is probably often encountered in
practice, since the threshold is 64 * nr_cpus and any sustained write
would cross that quickly. It would matter most with order-0 folios
since there's 4 updates incurred per folio independent of folio size.

>
> >
> > (a) and (b) perform worse on higher memcg depths, whereas rstat is
> > unaffected by depth level, which makes sense given that (a) and (b)
> > can't break early if the flushable threshold has already been
> > exceeded.
> >
> > ~On the flush side~
> > ns per flush call (measured at leaf of memcg chain, ie best scenario
> > for rstat, # CPUs on the system is 80)
> >   rstat                      10165.60 ns   (min 9924)
> >     (a)                       734.10 ns
> >     (b)                        4.79 ns
> >
> > (a) is around 14x cheaper than an rstat flush, which I think is
> > because the rstat flush goes through every stat, even ones that are
> > not directly relevant.
>
> I think that's only part of the story. rstat iterates all children
> cgroups as well. I think reading multiple contiguous stats may
> actually be really cheap since they are likely in the same cacheline.

In that benchmark, the flush cost was measured at the leaf of the
memcg chain, so I don't think there were any children to iterate here.
Maybe some of it is attributed to the rstat locking? I'm not too sure.

>
> >
> > Using some napkin math, I think the breakeven point for (a) is around:
> >                       updates per read
> > depth 1             ~900
> > depth 8             ~380
> > depth 32           ~80
> >
> > eg for depth 1:  (10165.60 - 734.10) / (32.49 -  22.34)
> >
> > This is assuming one read per flush, which is what (a) and (b) would
> > necessarily have to pay, whereas rstat only needs to flush when the #
> > of stats updates exceeds the MEMCG_CHARGE_BATCH * nr_cpus threshold,
> > so the updates per read numbers above are in reality lower.
> >
> > Running a fio write job and using tracepoints to count # of stat
> > updates, # of reads of those stats, and how many of those reads flush,
> > I'm seeing:
> >                      updates/s              reads/s
> > flushes/s         updates per read
> > bs=3D1M            643                           119                 45
> >                        5
> > bs=3D4k            156,415                     123                 58
> >                      1267
> >
> > For larger folio sizes, (a) is cheaper for writeback (since there are
> > 4 update events *per folio* in the dirtying/writeback lifecycle) but
> > for smaller folio sizes (eg order 0 folios), (a) is worse, as a lot
> > more updates are incurred, and the performance is worse the deeper the
> > memcg is nested.
>
> Hmm interesting analysis, but I actually think a more interesting one
> is the effect of the update latency in respective update paths. For
> example, in the zswap_store() case you analyzed earlier, it ends up
> being in the noise. I would check what the hottest update paths are
> (probably networking?) and check what the update paths are, to check
> if they are really sensitive to the increased update cost. It could be
> the case that at least stats that are used by in-kernel flushers do
> not really care about the extra update cost.

Extrapolating a bit from the synthetic benchmarks, at depth 8, I think
the extra overhead incurred on an update comes out to roughly around
25ns, and at depth 16, around 48ns. I haven't looked at the networking
path, but the lru path (__update_lru_size()) looks concerning, as it
would have that extra overhead while holding the lru lock, which "is
already a heavy contention point on memory-heavy workloads" [1]. As I
understand it, reclaim, compaction, and the page cache path all
serialize on that lock.

If we were to move all the callers off rstat, I think this also would
unfortunately make the walk more expensive. As I understand it, each
stat would be a per-cpu counter which would be added to the
memcg_vmstats_percpu struct, and that would have to spill onto
multiple cachelines. Or maybe I'm missing something here and there
would be a better way to do it.

>
> >
> >
> > I also ran some experiments with Jan's suggestion of scaling the flush
> > threshold to the memcg's limit rather than to the number of cpus. It
> > helps the overshoot we saw and slightly outperforms doing a plain
> > non-ratelimited flush (100% of dirty limit vs 101% on a 1G memcg, 103%
> > vs 107% on a 256M memcg) but led to ~2.4x more flushes.
> >
> > The initial reason we switched to the ratelimited version of the flush
> > was because flushing was expensive, but I'm not sure if flushing is as
> > expensive as it used to be. Testing the non-ratelimited version, the
> > flushes account for about 0.9% of the system CPU the write path
> > already spends, and I didn't see any throughput difference between the
> > two (249-252 MB/s either way), on a 32G memcg. With the
> > non-ratelimited version, it's also not a flush per read - it's still
> > "ratelimited" by number of updates that have elapsed since the last
> > flush (only flushing if stats_updates >=3D MEMCG_CHARGE_BATCH * nr_cpus=
)
> > which means concurrent writers writing back at the same time will
> > "share" flushes rather than triggering their own.
>
> Yup, this is exactly what I mean. This is a good analysis for the cost
> of the flush: how much it matters end-to-end. Even though the full
> flush is 14x more expensive according to your numbers, it seems like
> it ultimately doesn't affect performance much. I would do the same for
> the update paths, see if the extra cost really matters. WDYT?

imo ideally it would be great to minimize any overhead we can where if
we don't need the precision for a certain stat, then it would be
preferable to not incur any extra overhead for it on updates if the
overhead saved on reads doesn't justify it. In the grand scheme of
things though, I think in most cases, the extra overhead/latency isn't
really discernible except at high depths and except for the lock
contention issue mentioned above.

I don't really have an issue with rstat for cases like writeback where
we're not doing a lot of reads compared to updates, but I think we do
need to get rid of the rstat rate-limiting, as it seems so arbitrary
to rely on two seconds for stats being updated. Bounding it by time
and not stats_updates feels wrong. Even in the cases where precision
doesn't matter, it seems better to give those callers a higher stats
updates threshold depending on how much error they can tolerate, than
to rely on a blanket 2 seconds.

>
> >
> > In light of the above, imo it seems to make the most sense to just do
> > the plain non-ratelimited flush for mem_cgroup_wb_stats() and make the
> > flushing magnitude bound again, wh ich also aligns with what the
> > global non-memcg domain does. The question is whether the extra flush
> > cost is acceptable, but the numbers above make me think it is.
>
> If we can eat the cost of the flush here that's great, but I think we
> can't say the same for the vmscan and zswap paths (at least)? :/

I haven't tried out the vmscan repro or run any benchmarks on that
path, but the logic in vmscan seems weird to me, as it will always
conclude that there were no refaults whenever reclaim scans faster
than the refaults counter advances (which I think would be most of the
time under memory pressure). I'm thinking maybe we could do something
similar to what Usama did in [1] where we fold the refault delta into
a per-lruvec accumulator and let it decay. I'm planning to look more
into this and will follow up then.

For the zswap path, it's still a bit unclear to me whether exactness
is necessary or whether the 64 * nr_cpus error tolerance is
acceptable. If that error tolerance is acceptable, I think it makes
sense to use the non-ratelimited version of rstat with no forced
flushing, given that reads are supposed to be rare since rarely
anybody (from what I understand) in practice sets zswap.max. Quick
benchmarks at depth=3D4 with zswap.max set at every level, 20 workers on
80 cpus:  rstat forced =3D ~7,600 stores/s, rstat unforced =3D ~300k
stores/s, and hierarchical per-cpu counters =3D ~440k stores/s. The
hierarchical per-cpu counters outperforms rstat unforced on the stores
given that it removes the flush, but we already see massive
improvements from using rstat unforced over rstat forced.

Thanks,
Joanne

[1] https://lore.kernel.org/linux-mm/20260727162550.2032-4-usama.arif@linux=
.dev/

>
> >
> > Thanks,
> > Joanne

