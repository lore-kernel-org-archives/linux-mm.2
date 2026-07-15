Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CCB55C44501
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 17:23:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 80AAB6B0088; Wed, 15 Jul 2026 13:23:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A4926B008A; Wed, 15 Jul 2026 13:23:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BCCC6B008C; Wed, 15 Jul 2026 13:23:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 352646B0088
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 13:23:00 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A8A65801B7
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 17:22:59 +0000 (UTC)
X-FDA: 84991681278.08.8EB67D9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id B6E1F4000D
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 17:22:57 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XIgtcyhT;
	spf=pass (imf17.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784136177;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fPNZtKv0G0JaCpItLnUH7W8J8CLF9ZlgP6GTiszUw9w=;
	b=M152+Zl+GIWcs50blePrjhatVxcMHj1sMMci762UhzJ7vknhlQ3B0Q8orMNlLEVOgffOTg
	EoASCh/ez7o5unZo2qevGbPDfvJ9u/mCro3TEr/GroB6R897+q/QL5OwWjS82ZJZvuroua
	mA9+oERuuHcsqZ0vzBmadPe22TaRulQ=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XIgtcyhT;
	spf=pass (imf17.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784136177;
	b=QLaIZ6RafzPBYG7HKDKIxexqWNkO4Gzkkvy7ULU9NRo8jkOahbvQnqGKDVmXEbGg+8ltfA
	sZFoUBEZ2evoIYaJvslK1SYQWrFbpHPBhFR+6gGLnjPGMkh5EVaBx79kZIzGJZbGQfOoC4
	dkaGI+W/LyuQfHDPBmWsbPyG0FlPPFA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E7858438DF
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 17:22:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CABD81F00ADB
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 17:22:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784136176;
	bh=fPNZtKv0G0JaCpItLnUH7W8J8CLF9ZlgP6GTiszUw9w=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=XIgtcyhTtCfLYmrEGTmDrQTJzTR990zzImckQ7iG69FnN0aqvINA62sZKic1ZAFCk
	 QgK72rr4+6ZdC/Trsr/+f+pXq6shpE0rT2IYBr7nX4HcGrabL/0oNvupYi+oR5dkAD
	 JPqeBLW6dMKQQvKzsvshRvAnppRu08AA3yOEx8nyPq75LuMXYaxlFsJlxTHHvOx8+w
	 +IGRjA8Lm2Au8XfAiAwaa5hQxMLPt16P5HR8JdJ+wytOwOmGLYfIUUbOFvJdoFo7xX
	 fm35d81PXT/JKGsmhSO4I9AMGzzu5JcZoWnCSQQpe8s+kwr77Yw4/HFzMXg0obYQiH
	 +ptMVpLLlwvFQ==
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-81ec29f1d07so21998707b3.1
        for <linux-mm@kvack.org>; Wed, 15 Jul 2026 10:22:56 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rp4PE1B24RGYAbzdlK9bmGBxTi+axH6e2c7TZZ7eBsiFTtkS82zSkTCeQLp+8MOquWPneXmELfLHw==@kvack.org
X-Gm-Message-State: AOJu0Yzc+28raQMvFXHgD/F9SjybF6hdFPV/g3kKZqyXZfk6wbXMQCKY
	RAfAgANuWbxv/AIEVsJ+NvHeyhaec+lNtUlprEcoR4ERmOqDQvgB2EExS0s9rd3cbdAeGqrJYQm
	i6AhsXgdI2GTAhlEEScX0TPXyBBYbla/Ps5Nv9YI7PQ==
X-Received: by 2002:a05:690c:c91:b0:81e:8985:4046 with SMTP id
 00721157ae682-81ebb299076mr70998317b3.53.1784136176139; Wed, 15 Jul 2026
 10:22:56 -0700 (PDT)
MIME-Version: 1.0
References: <20260713025644.170839-1-youngjun.park@lge.com>
 <CAO9r8zNJfhirbzvJzDWRaBQOM7XZcf_Jk0Bz=Y4dB4QK4W-MwQ@mail.gmail.com>
 <alUK8DWRy4LPxTpY@yjaykim-PowerEdge-T330> <CAO9r8zPvWKgQ8+ABxSnVnC452-enyMqCjBTA4pfNDVxsoJr25g@mail.gmail.com>
 <alUQ0ksPP00PVwew@yjaykim-PowerEdge-T330> <alae-LIRwEFUjgs1@linux.dev>
 <CAO9r8zNfp-T19cYyZxKHBY-FnmQ_9=fbP4JYPPFgYtUCo5fZyg@mail.gmail.com> <alawYov0c7a0Q6_l@linux.dev>
In-Reply-To: <alawYov0c7a0Q6_l@linux.dev>
From: Chris Li <chrisl@kernel.org>
Date: Wed, 15 Jul 2026 10:22:44 -0700
X-Gmail-Original-Message-ID: <CACePvbW6FKB8z3K=i7OjxvMT+SV8Dnpmd_8-pzB6tH0GBQv7pA@mail.gmail.com>
X-Gm-Features: AUfX_mzEFEZ8gnhhoTyYsBdUcS0O3teHPgTkExn2p-PbqOit0XXG1fqEfQT6aWI
Message-ID: <CACePvbW6FKB8z3K=i7OjxvMT+SV8Dnpmd_8-pzB6tH0GBQv7pA@mail.gmail.com>
Subject: Re: [PATCH v10 0/6] mm/swap, memcg: Introduce swap tiers for cgroup
 based swap control
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Yosry Ahmed <yosry@kernel.org>, Youngjun Park <youngjun.park@lge.com>, akpm@linux-foundation.org, 
	linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kasong@tencent.com, hannes@cmpxchg.org, mhocko@kernel.org, 
	roman.gushchin@linux.dev, muchun.song@linux.dev, shikemeng@huaweicloud.com, 
	baoquan.he@linux.dev, baohua@kernel.org, joshua.hahnjy@gmail.com, 
	gunho.lee@lge.com, taejoon.song@lge.com, hyungjun.cho@lge.com, 
	baver.bae@lge.com, her0gyugyu@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B6E1F4000D
X-Stat-Signature: fhgwwd3ggyz91afgp61hpjgewfighxpb
X-HE-Tag: 1784136177-734506
X-HE-Meta: U2FsdGVkX19PkOMvatzQA9Wd5k+E8CpSfh3oopp+WewjlgvAvpQ+bqQeWUGZjctrc3A+ab/jKZMthVw27BnSmztBMZfw2iupiPToCfyn41RxV+GA04XX7FMesIKksj0mR6qfugvKW+zb87+h62lT+WHTVUKlv0LgH5MTjcKcRD6F6hBMoJSNW3VSGtzyhrU6ebZbt3bXPu9HUHuA7m9r9IrEUOGF4ozpkaTk+OlQmFbjHbVzmEuMadNdovK+TbK1O45HE5rwBKJoxP+tGNWIRQll0CYeOCWz0TlQ9JH+ubyzsMdYXsjM6GiRqjeRrYK5k+Scc6usWLt5aVUrfXsLeAYCYW+xg5OVIZx4gyFbneM5I6ERalCTjrHd57xzDuSZk1LxhcPdnD1NV0YOrKBnfw88hvNgE5ElOE0HByCMpqfbU8pI5JUqUOACmNY/KS0j9vMRsFd/m8tNWTQ8Wq+mKbTxE9mBzmQKutRFoANGELjjda2g5GuPhy4UbLw4jbSsQ0R+ujJE98wjrm/GCg55brVv1qnSh4hLY2u/nAOQ07XIhnMb0RxijrPdJRTvG9HoohO3+F41VT0Yi8oV15ep4XlOcvAVzUlEYfeL2bL5rv/nQPJy4DSlXfXBEj5RVNAdGlkL03i5tY4LyE5CoVDVeHHGyFGQYVO2heVHDHNAKZ7UpteyLOWmvXwZzLj40WPKPcNciXhbbGc2DxFg1SM8dJYCiTYMeFirMfjjneiTN771M9sAZ7c2NxEG4PbZOVteFU3RT2IHuVN1hxLgaUOSVdgcnj6ftBnwEZ2QWjtdhEkI70RpHo39iiWydwsd2RiHftS5QmGxykqf7qlPM776SdwhpWXuroWBRUsOh/3IGqCh5kTP/B9rNx8lwMSZPXgBXnLVfqqfhSKH0SJ76DCjYrJVupyjyDcWNBEAljwsZVzdRvRBJR2IrWUfElU/2SQirtCuhpA7xbW3m/hhdof
 gvJHQ9ls
 elAM5RuufiHzHPvOVEabBZpdhYb7oFf3FAvy58DUd5moJdnm4zRk2s0AeOwS1nQIH+NrGugkUDgaffwkNi06f9UeCZjoUhFDmfBzrOBjYqsOSCBE8NPnBw4Asn6yYNlQqGH8w/d0BeucQa3a7quFAIrIS2B7+6qvjyKm7xNyixWw3LDYuW5uN6rqxjXRb+KvYMaZ3zVLdAxE1IUmUjN5m4kYp4XWESiaOM5q5b7gcFweuxHp5j3uy2fjoyaIibt1SHf6wpJpXoLXQ2Lxs2xghygeGMrWISHJLcp8ybFjK+1nddlMQlfGHl32ZxEy4KV/LK2Nh8f3HCXyZO3iSVl5rBkvn1UYPQqYMPFzchtJgnXZUt3k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 14, 2026 at 3:26=E2=80=AFPM Shakeel Butt <shakeel.butt@linux.de=
v> wrote:
>
> On Tue, Jul 14, 2026 at 01:52:14PM -0700, Yosry Ahmed wrote:
> [...]
> > >
> > > Yosry, what is needed to enable zswap as a swap tier? What will be th=
e minimum
> > > requirements for that?
> >
> > From zswap's perspective, we just need to skip zswap is zswap as a
> > tier is disallowed. Could just be a check in zswap_store() similar to
> > the check if zswap is enabled. I am assuming that if a swap tier is
> > disabled, nothing happens to the existing swapped out pages in this
> > tier, but new pages do not get swapped out to it. This is the same
> > behavior that happens if zswap is disabled at runtime.
> >
> > From the tiering perspective, we need to accept "zswap" as a possible
> > tier, or maybe creating it as a tier by default if zswap is configured
> > would be better to avoid handling the case where the user doesn't
> > create a tier for zswap.
>
> Default tier if zswap is configured makes sense. Should zswap be treated =
as
> having 32767 (or maybe 32768) as priority as it sits infront of all swap
> devices today? Also whichever swap tier has priority range containing 327=
67,
> will have zswap in it.

You shouldn't need to hard code that priority for zswap. Zswap, if you
make it a tier, it is a special case. It is different than other swap
tier devices because when you search for a swap slot, you don't need
to search zswap as a swap device now. So the priority of the swap
device does not even come into play. Internally, zswap is already
hardcoded to perform before the underlying swap device. It is not an
order you can change in any way.

So we don't need that priority number. Just reserve a special name for zswa=
p.

> > We also need to disallow zswap being the only
> > tier as that combination cannot work without vswap.
>
> Do we need to do anything explicitly for this? I am assuming in a kernel =
with
> swap tier support, there always exist a swap tier if there is even a sing=
le swap
> device configured i.e. a tier with the full priority range.

There is no need to do anything special now. The current zswap is bind
to the underlying swap device. That is unless we use vswap/Xswap/ghost
swapfile.

> >
> > I think this should be enough to support "zswap" as a tier and allow
> > disabling/enabling zswap per-memcg (or globally?) through tiering.
> >
> > In the future, if/when swap demotion is added, we need to figure out
> > how that would work with zswap. For example, if pages should go to
> > swap device A then swap device B, then an entry in zswap using a swap
> > slot in device B should not skip device A and be written back directly
> > to B. vswap would naturally give us a solution for this problem.
>
> This seems reasonable to me. Punting demotion/writeback to future.

Agree as well

Chris

>
> Youngjun, what do you think? Is this reasonable amount of additional work=
 or do
> you envision some complexity here?
>
> >
> > > If that is not too much, we can make that part of this series.
> >
> > Yeah I think it's better if we agree on the design and zswap support
> > before landing partial support.

