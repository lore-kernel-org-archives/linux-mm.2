Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C430CA5FA2
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 13:14:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0BE106B0098; Mon, 28 Sep 2026 09:14:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 06F496B0099; Mon, 28 Sep 2026 09:14:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E79066B009B; Mon, 28 Sep 2026 09:14:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BDB496B0098
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 09:14:28 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4A024A45B5
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 13:14:28 +0000 (UTC)
X-FDA: 85263215016.26.4DC7664
Received: from mail-wr2-f17.google.com (mail-wr2-f17.google.com [74.125.225.81])
	by imf09.hostedemail.com (Postfix) with ESMTP id 45B8814000B
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 13:14:26 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="Kz4/9595";
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf09.hostedemail.com: domain of nphamcs@gmail.com designates 74.125.225.81 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790601266;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vND3fTgxqxSE2NFt08zJwdsstzk03d+XxBDIXeJX5tM=;
	b=qkphubrydf4nQ6ZfkBk+hokXlo3L2Ix9NNkzq8AXm5i9nTKW4JrRO8sReIwdH8WnJA74bD
	D6a8CUZxAN6K6H8gEeeE6Pvd2WbUMotMf62U7sVEr29B7OhhCxFgWqyr0/z1AAmct1cbQH
	X9TVbucuviQ4KnSbBYOS92o+8vSviNI=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="Kz4/9595";
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf09.hostedemail.com: domain of nphamcs@gmail.com designates 74.125.225.81 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790601266;
	b=MKJdaIR8iD4HtC+dqiehrw67G4xIjASzN6CKeeYXgj9OLtsc7ZjFifyCavLRk9bBuVOurB
	PhpmgiS+K4vqaPYrOMBOVE5k0ZvnVmB4aCVTbMQiceM4tTRZXW2WAi5bhKLpJdvIgVoYcr
	6fPwL9EnzoTf48GMfS3gdbS6WSGEkss=
Received: by mail-wr2-f17.google.com with SMTP id ffacd0b85a97d-4887d06c669so2325218f8f.3
        for <linux-mm@kvack.org>; Mon, 28 Sep 2026 06:14:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790601265; cv=none;
        d=google.com; s=arc-20260327;
        b=L8irKxAAIJjxGRPrla6np/Zz8gqIVZKSSpCYgDllrhT4y58hNnbkMjo00yZrNywZGT
         Z2OVyEXCpPeRPQyQLaQnW2JTd1yqckHGtM+IK4vx+wzi/imGwT8Xz5k6uN+rmkCWSlnB
         tPjfk13/QM4q48AJDJ9+krOqrBGcQR6AZFGknV1A3AkSTq8DnAy0Njv4XPDv98R8D0vl
         YLoCaUKts1/I3MC+TY7eocEKwjfD41Al88xjSsIFpNytrhrcvrI4wDlXMFBUt2V6pP1v
         owDta5bh2yulAUTWssmc9YWKDr4qv0qoFY9tA6NR3i8Njl/nQqGhOeUhlE+Pzbwj2VBs
         HoYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=vND3fTgxqxSE2NFt08zJwdsstzk03d+XxBDIXeJX5tM=;
        fh=CCs0c7g0tp2VsqRjywq+9aLfL1Y0FaS2M3uxie0znfg=;
        b=MNvityX/trVBzpOwgL6v7445RnKPTQk9ugTh5AXIxj/BI4lvcPPEUMO62nY/wA3iAJ
         7P5cq5Is2FUau0qGdix2DoKUJTrEoCvrgxkCWHQcEOsEdKQcdgQRlLvlkyvlzvV8o9u+
         N1ot2abrvHPbOx9kyJpvBdhnmkFaCRikiukcAPAnuM6MwrL6/Hom5EDE0LzrCYfHy3AY
         X4jUOYGxfnDmZD28P7/t0H/4KGYwERz5coqy2ZSI9EC/brKbw8m6V7XRNC0m6tYvkfNa
         lder4en9FzRdva72YgjsEtF6UXom+z0n9IYgg3apcc1BUDPOIIiXX0PgGBdS+856yXHv
         AB8w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790601265; x=1791206065; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=vND3fTgxqxSE2NFt08zJwdsstzk03d+XxBDIXeJX5tM=;
        b=Kz4/95953Z9fz2eeMuixbYY3BZS8isxfQg8GK3V8e1dTpk7XvHlx2YQ20hMEX8B1nN
         4qHBNpERchjVGldcSncrzzupoYZH7KpCdaBphPTcvp5qAPp9TKytDVr7To+ur7n702/f
         ioNDHvlmYE7Del8tZMu9MwuTeKiD0dMOgxt7O/LPuQXk1NX4UjhR/oq8/uDnoBeNu7aN
         JADSJH9/WK4kLnVTKpb/UN9DrshZFupXsvlFNbVHFlpA4npMsy6FvIIcQ+gOJI6j6QeZ
         XZt/SQ46x5RNbiMd0nrJjC502gyTtHY8r0AYMoWnZRGeQiDjY4vfPG31NgF6IY1redaM
         VpKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790601265; x=1791206065;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vND3fTgxqxSE2NFt08zJwdsstzk03d+XxBDIXeJX5tM=;
        b=JCeSke2p4V+HBQ10HP8jBozXQORofJyJLYaEw45q9YKY2daj15wTIOwOFuwit8ChMw
         kCfzDfuCXzRWiJHQjnTYi9OtuRZghc3Dm4BuTgcD7woy5pgGrDIQslwo8vEzLXF0Tjmb
         1aNS4jqHy6g5BVPxNnnqMc7qOQhB2q5kCgNmgGlwiEN/zeJyct047nkZ75vfy5HJ/g+b
         EKI8sKCucwQjvIg0dFRVcbXf0KJaFcShSRnHIqozoiSP/GuvpdZGRXYg+vBrtacyf4jM
         QwForUZopoxURzK03yZkSRl2s3Sx9+0DqlHtIIc9kGBR108xghnufRf32LSaI0EJ2H4C
         Xu/w==
X-Forwarded-Encrypted: i=1; AKwUvBysegLj1CTVXIiSuA2QgqJcMyPtIApIENeH3WjSLmWBaoUSfLPTtVZecVXOeolxixPn3Zd75HbODw==@kvack.org
X-Gm-Message-State: AFq9FYJuee8NTfxOq7H/z5FklNRBsjSqGcJl0PvfPMJTus+j0j5K+Nlq
	ytqSTxcFdwfmNClhCl72jKhiumg4VsbxbTAuirZfDEcEq/545TqLXg0OszPJ+7HNRxWfXqKqVQT
	ESpAuiVSuTnKHiQSLdg77Bz2Alio+ZgU=
X-Gm-Gg: AYBFou0qjl9MPIlYDZJJoqAbzRVpq1rKZiAoGM4acC2A4BvvuslJps7fVlWX3r1zHzM
	fs1sitOeskoSmWTklQSPsNA58/mPnieqlvJNrUytOe6oRXmI7++ZgElj9KHTSzU9KA8t3Oqog4I
	i+eDzb/Y/FXShXuwj14c5M5OPMmKOCmPXuzgeiZhBOuQmsH8Rk9srbxyIVYa8+87KaP/FVv4duz
	Rj0t+fQZ7q/4JZh6ZgtdiaHMc4LVvxwPk3435RaMfYZScbjru0JL+CQUmEyKq32hHOJCr+Ro4S+
	6UaqRzUU0ncL85gKCz/XCqRT3ZdZtXHLcQN3TXxVkWBXbgMKUGHbSX2McAAgHc2isGVr8ovgk2i
	b83e+9qa9S/5fMaUk8H3pZIWnmmQ1
X-Received: by 2002:a05:6000:4545:b0:488:7f5f:7caf with SMTP id
 ffacd0b85a97d-4887f5f7e22mr10175659f8f.23.1790601264546; Mon, 28 Sep 2026
 06:14:24 -0700 (PDT)
MIME-Version: 1.0
References: <20260918180241.3424851-1-nphamcs@gmail.com> <20260918180241.3424851-2-nphamcs@gmail.com>
 <CACePvbVaDNspMDSw_qAcapKAzXj3JGV-KMYmow7aePa0POHpSg@mail.gmail.com>
 <CAKEwX=OP3Gb9sVOvch+p4j7quzgy-rUY=UTZau5ztMj7heJJoA@mail.gmail.com>
 <CACePvbVQsHXt4=+qfKz-KTar9CG+3OiAfLd1EZgnRE-1gyoKOQ@mail.gmail.com>
 <CAKEwX=M8pJUYhmADfvdk+09O53EROyDRC+_b05vtimQE5VN=qQ@mail.gmail.com> <CACePvbWTZgbL7U-hrgV=V0egHZ13EqMCOsUbnKTcLvqnv85zUA@mail.gmail.com>
In-Reply-To: <CACePvbWTZgbL7U-hrgV=V0egHZ13EqMCOsUbnKTcLvqnv85zUA@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Mon, 28 Sep 2026 14:14:09 +0100
X-Gm-Features: AclHuK-P2g4Mc8ezdcRMnTDUO5s7E9DvQD4Qr_QNwMbU-IG7-Wm7IdyixU-UHR4
Message-ID: <CAKEwX=M1tc5fLSgxbq9S9TU1AKJWtRZA0AwGQZgNXJ_76hThFg@mail.gmail.com>
Subject: Re: [PATCH v5 01/11] mm, swap: add virtual swap device infrastructure
To: Chris Li <chrisl@kernel.org>
Cc: akpm@linux-foundation.org, kasong@tencent.com, hannes@cmpxchg.org, 
	mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev, 
	yosry@kernel.org, david@kernel.org, muchun.song@linux.dev, 
	shikemeng@huaweicloud.com, baoquan.he@linux.dev, baohua@kernel.org, 
	youngjun.park@lge.com, chengming.zhou@linux.dev, ljs@kernel.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	qi.zheng@linux.dev, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, riel@surriel.com, gourry@gourry.net, 
	haowenchao22@gmail.com, corbet@lwn.net, hughd@google.com, 
	baolin.wang@linux.alibaba.com, tj@kernel.org, mkoutny@suse.com, 
	skhan@linuxfoundation.org, kunwu.chan@linux.dev, kernel-team@meta.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 45B8814000B
X-Stat-Signature: n5jt9hw5gj1ubzse9y81ya9pmnbdjo51
X-Rspam-User: 
X-HE-Tag: 1790601266-426047
X-HE-Meta: U2FsdGVkX1+lhjFowjWAiwna7jAdgl5TI+kh014yZQ6a0AwwDmcSgqb8/exHbMu8WRWnN79IrcZue5yeP2ec7ORbUG9KUk+94bI1rCdPrDRPuPOURFH2P0H2EpE/d0DGmMUKEHb56ndcHMAkSp3+luG4lJNUAfzBEAWSJ8Pne5QKQCWRT9s8D4bcrKBTHdLbe5VD5et4NLY1Zn0FeAqKkH8TN/SFwKAni7zCybF5n/Sqh3UliQwpTX7RmMQf+mfgCGoCDltqxbKVQNIrfm4ay+1CFHH+svfTNN5gzQ7hpwks4ldSt8CjOCxMrU3PKzYeK0usTSPtp1egg+J0kquzDUzKfcRBtLMrKV8e7QUjV56xy0YlgGemzRx8oGJ+/jiPRtEecGBU4uAoAqgdkpVtMNRI3eWazW4dhoYfArP7Uvkj4KiJ0qGBh3xHh7aVu1ASxGt/wBgEpg0NRHIdW9Uwh0GHTAwooe8R7HnaHcAspHDj+BLXq/wwo+Vp+WWWvGTxwwdp+jK0n9OetcqGSDXppehXyhI65zeDfy02b+nIpbJjizSBRfkYapJlDWiTtCUMJPQqqsmnKRb4X0lmDvZNzOpgIAV43P1/PxEy4mgGK9oEi1usszHHBMiKUssCqOusDlEkz86agJIBFbtSkwLwXa0FKCzvM6WxcqlpvfDT54ccUysS+iUhktmOHaNitmfihaEQaCSPbLbhMInyp3qP2x3awq0VkkD7cL+XDZdkGS2liaG541jKpcZPwlHy72yQr56fQcuzz4Slvf7pjj5gn5sMgNFbv2vc1GFEN8fKe6VHZCulYx80hLa1BS8oN686Zuwp0TEaoKsbwbOcM3OG0ibqpN3hKF5S7zh6HHNkuvncJRQJYyKbk05bE4rHiSe9gh+wR9HoHgsRPsS6ZZaEp0C/TRbmnkCESTYVUuh8rYqhKjaHpaOTtJDb+MCuHFpqByVe7yyzTgTZCdW8D1n
 uG3CrGd3
 y9BGH7cJueVataApf8dEnGZvFOsqli4y2YjEdd8yqZgZsr0CswEeRSMM2pSionC6fYpkpGTWXfVgCjYjXTQap10fTWFrOEuSa9HxVc2fSk+Knvt88572QECfesDhdqu/xoVCeFFAPdZn77C/pEPox5ZEGnxjiG64BZjywnLoqni9hy9I5RpiOAfFIniWK6MlL/Cb4zuxroqybE2Tu557ukOWycF7R2kQR/w/FxZdxt/IfzPKpI6anq4SYAvBPPIOFFYgPBQAxhg7UD43b6l40dTRUCclpmtACxWK7JJBoBCKvip150BDWqiZx3S6EwLQM925DCiNt6y7TCE5fegbzjMYxrJL+jYBzo130r6A9JJYVViFNSIhqrnQd4Cku+Mqwm2MmIk85AUJaiFJ/oO6EdnWNomKNOSwhn6+Z1AaAnx3ToiBjMiB6U9wEuOP7AOfGHpX8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Sep 26, 2026 at 8:02=E2=80=AFPM Chris Li <chrisl@kernel.org> wrote:
>
> On Fri, Sep 25, 2026 at 8:04=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wro=
te:
> >
> > On Thu, Sep 24, 2026 at 5:44=E2=80=AFPM Chris Li <chrisl@kernel.org> wr=
ote:
> > >
> > > On Thu, Sep 24, 2026 at 6:20=E2=80=AFAM Nhat Pham <nphamcs@gmail.com>=
 wrote:
> > > >
> > > > On Wed, Sep 23, 2026 at 2:18=E2=80=AFAM Chris Li <chrisl@kernel.org=
> wrote:
> > > > >
> > > > >
> > > > > There are too many swap_is_vswap() in this series. It fragments t=
he
> > > > > code path, making things harder to reason about. Esepcially aroun=
d
> > > > > locks. I count 22 in this patch alone.
> > > > >
> > > > > I consider this the biggest drawback of this series. This
> > > > > fragmentation of the code path.
> > > >
> > > > This will mirror my response at [1], but I'm responding here for th=
e
> > > > record and for your convenience.
> > >
> > > Thank you. Really appriciate that.
> > >
> > > > It is needed because vswap *is* a special device, with its own
> > > > requirements. If you don't special case-it, you'd get undesirable
> > > > behaviors.
> > >
> > > Ack, that is why I am against making it a special device. That is the
> > > whole idea behind xswap. It is just normal swap device implemented vi=
a
> > > swap_ops just like ext4 is a file system implemnet on top of VFS.
> > >
> > > > Let's take Baoquan's patch series as an example.  It treats the xsw=
ap
> > > > device as just another swap device, without any special considerati=
on
> > > > for it. Which creates several problem:
> > >
> > > That is a careful design choice. Keep in mind that design choice
> > > usually has pros and cons.
> > >
> > > I will follow your feedback here.
> > >
> > > > 1. At allocation time, cgroups that disable zswap might get an xswa=
p
> > > > slot, because you don't do any check that the device you allocating
> > > > the swap slots for is xswap. At swap_writeout() time, it is *stuck*=
 -
> > > > we already do the unmapping step, so we cannot reclaim the page.
> > > >
> > > > Ironically a physical swapfile backend could have bailed us out her=
e,
> > > > but it's not in that patch series yet :)
> > >
> > > I am not sure I follow. Are you referring to the uncompressible pages
> > > that xswap would have to reject?
> > >
> > > One way to address that is for xswap to just bite the bullet and stor=
e
> > > the uncompressible pages within xswap. That way it will stay out of
> > > the reclaim LRU. Zswap also stores some uncompressible pages. The las=
t
> > > time I checked, it was unfortunately not able to serve my case but
> > > perfect for yours.
> >
> > Not even that. Say you have two kind of workloads in the same host:
> > workload enables disk swap but disable zswap (zswap.max =3D 0), and
> > workload that wants zswap. Let's even ignore writeback for now.
> >
> > You add 2 "swap devices" to the system: xswap and NVME swapfile.
> >
> > At swap allocation time, xswap patch series does not check carefully
> > which swap device is being used, so you might get an xswap slot for
> > the cgroup that disables zswap. You're stuck at swap_writeout() time.
> > You can't undo it anymore, and you don't even support the physical
> > swapfile backend to fallback.
>
> The xswap is to be used with the swap.tiers. So at the swap.tiers it
> selects xswap or SSD swap. Will that solve your problem?

I mean, we're having that problem right now, no? :)


>
> >
> >
> > >
> > > > Vswap both has swapfile backend, AND allows you to bypass it if the
> > > > cgroup disables zswap. Both involves a bit of swap_is_vswap() check=
,
> > > > but I think it's worth it :)
> > >
> > > If xswap needs the lower tier it can allocate for one. I don't think
> > > xswap should need to have swap_is_xswap() there. Also xswap does not
> > > have all the baggage of zswap.writeback enable interface.
> >
> > But that's my point. As of now, it does not. Unless you merge the
> > other RFC series, which brings it to roughly the same size as what I'm
> > doing here.
>
> It is cleaner because it avoids the dual personality issue. It also
> paves the way to enable writingback from one swap tier to another.
> That is heading to the right directions.  The vswap writeback only
> serves zswap, not others.

Writing back from one swap tier to another doesn't exist right now. I
have not even seen a coherent design to support writeback among swap
tiers. You're just delivering pie-in-the-sky.

The RFC you mentioned is not writeback between tiers. If you think it
does, then maybe you should read it again, It's from a very specific
swap device (xswap, with zswap backend), to a swapfile. Here is what
it does: add an array to store indirection (physical swap entry) to
clusters, and update that array when we need to do backend transfer.

Does that ring a bell? That's because it's the exact same mechanism as
vswap (without proper attribution - not even Suggested-by). If
anything, it's actually a bit less coherent, because you can set xswap
to be lower priority than physical swapfile.

Vswap does not have that, because vswap is not an ordinary swap
device. It's implementing the concept of virtualization (the "V" in
VFS, if you want to make that analogy), made optional to reduce
overhead when indirection is not needed. That gives you all the
machinery you need for backend transfer: a centralized virtualized
layer, where you can update the backend, without having to go and
chase down all the external references - no PTE walk needed.

>
> The biggest hurdle is the user API. One of Johannes's biggest
> objections is that it lacks writeback support and perhaps more. Now
> the writeback RFC is available. Let's re-evaluate what is possible.
> The swap.tier series has been out for a year now.

See above. But transferring between tier is still not a solved problem.

>
> If it is the same but does not have the 33 swap_is_vswap() fragmented
> dual personality issue, I see that is a reason to choose that path
> instead. What do you say?

The problem is the interface and the charging question. We have put
out our objections to it, and so far we have not been satisfied with
the defence.

>
> >
> > > >
> > > > Maybe instead of just grepping for swap_is_vswap() and throw your h=
and
> > > > at the complexity, read the code and try to understand why it's
> > > > necessary first, then propose simplifications if you have good idea=
s
> > > > in minds.
> > >
> > > Yes, I already read your code I decide that most of the
> > > swap_is_vswap() should not be needed if taking a proper swap_ops
> > > approach. I wanted to offer you the chance to work closely with me to
> > > achieve that, but you did not follow that suggestion.
> > >
> > > Quote from my old email:
> > > https://lore.kernel.org/all/CACePvbX+3tO91BmRwaLqf3Xia32GCemt3W8tayEr=
G81BYLgrzA@mail.gmail.com/
> > >
> > > "I am happy to spend some time working with you to discuss the generi=
c
> > > adopted version of vswap, if you are open to it. Or if you don't want
> > > to waste time on it. I can have someone else or myself come up with
> > > the generic adopted version of vswap for you to review, which I prefe=
r
> > > less."
> > >
> > > Anyway, Baoquan's xswap writeback patch series is out. I suggest
> > > following and improving that series instead.
> > >
> > > > > This is questionable. A vswap device does not go through swap on.
> > > > >
> > > > > This changes the behavior where swap devices always go through sw=
ap on/off.
> > > > >
> > > > > I wish the swap device went through swap on to be able to start s=
wapping.
> > > > >
> > >
> > > >
> > > > What usecase would necessitate the need for swapon/swapoff interfac=
e?
> > > > Other than just trying to shoehorn it to an existing interface?
> > >
> > > I like universal interfaces. Your vswap will break the /etc/fstab. Th=
e
> > > current suggestion for xswap using sysfs will break that as well.
> > > I would like to keep the /etc/fstab interface working, including
> > > support for UUIDs for swap devices, etc.
> >
> > "Universal interfaces" is not a use case. None of the thing you list
> > out here is a use case. It's an interface, but you have not
> > constructed a single use case to justify all of that.
>
> We don't have to go throgh the universal interface to resolve the 33
> swap_is_vswap(). It seems there is an alternative now. We can take the
> xswap route to eventually solve all your problems.
> >
> > > I am very concerned that vswap will start kicking in without me
> > > explicitly enabling it. That changes the previous user-visible
> > > behavior. It breaks my mental model. Please take this feedback
> > > seriously.
> >
> > I mean, there's a knob for it. How can it start kicking in without
> > your enablement?
>
> Please correct me if I am wrong; here is my understanding from you:
>
> vswap is off by default because of that knob. You turn it on and it
> starts zswap.
> Two questions here:
> 1) Is your knob compatible with the existing /etc/fstab where people
> use it to enable swap devices, including with UUIDs, etc.?

If they don't turn it on, their code works as is. Their existing
/etc/fstab exhibits no behavioral change.

What you're asking is us *enrolling* in that same interface. And my
question is what does that interface give us? I already pointed out
multiple ways where that interface's generality shoots the user in the
foot.

> 2) When you enable the knob, do some unit test and disable the knob
> again. Does the vswap go through the same path as swap off so no usage
> of vswap exists on the system?

It's a boottime parameter.

Why would you care about swapoff? What use case does it serve?

>
> That is the existing use case I have in mind.

You're describing an interface, again. It's still not a use case.

I can promise that it won't break /etc/fstab if vswap is off. - if it
does then it's a bug and I can fix it.

>
> Code maintainability is also a consideration when choosing which
> technical solutions to move forward with, when there are alternatives
> to provide solutions to the same problem.

I already pointed out how xswap's design *creates* problem, including
userspace problem. You just handwaved it away with "let the users
shoot themselves in the foot". I disagree with that philosophy.

