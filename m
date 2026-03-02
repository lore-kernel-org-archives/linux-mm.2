Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 117E5C624C6
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 09:20:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7994F6B008A; Mon,  2 Mar 2026 04:20:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76CC06B008C; Mon,  2 Mar 2026 04:20:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 648B76B0092; Mon,  2 Mar 2026 04:20:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 530486B008A
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 04:20:41 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EC2DE1B8FEF
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 09:20:40 +0000 (UTC)
X-FDA: 84500577840.22.DBE46B9
Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	by imf28.hostedemail.com (Postfix) with ESMTP id 047BBC0008
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 09:20:38 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ammq5Sp+;
	spf=pass (imf28.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.45 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772443239;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GiCw4FGUa/8Hmzx26mUdlsi/XCK3ybAO25PQJmYflYM=;
	b=U4G3Qfg2ISO3n6IM23h+i6RkTECBfL5hj6+ThL78eNlb1Hx1f1To/L8KKLZ0GTNvPeXBAk
	UO8bptfxNVKwuvHfLAWtPd26xAJKkX10c5QUTS6D68iJDRoK+9PHOMDYW6AGGdCSSuXL+N
	JmEcCRx8rU68hXoRdtOEJQ6Euz0O0C8=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ammq5Sp+;
	spf=pass (imf28.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.45 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772443239; a=rsa-sha256;
	cv=pass;
	b=U9C6lYifVmCR2osyBLRWKp6TmJM93SrTDCfoeHo2/aERFPgFCKYZaXtTOGqHQahV8TMB+O
	EKMVhyYCAnKi3ZBF4IuP/eO3BjbJmyr+hjzvHfEBS0LqGO+TE7a0pssCiwuU24e8PV4zSl
	NXPOAyOkyIa9bCV5ZtlnoW25lWX8Z1M=
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-899a5cb04f9so53979566d6.2
        for <linux-mm@kvack.org>; Mon, 02 Mar 2026 01:20:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772443238; cv=none;
        d=google.com; s=arc-20240605;
        b=Y5OkRLNi0bGiSDHVVP9TBHA7Jb44/0jTKn0IGYOE2/ga+DmWmRzZeMDSeQrXPnu2Au
         QcrOtX/EZsarRKnMmEC+6PcUDf1scD8x2xL1zxyoQWycsCbT5CLtOHtwDJEO9+f0me3Z
         qUbG+QAiwkNeB16ISdRrDF9OscSAvOz0VyOV4F45IqIIs9YN1ceF04sQ3NY6oKUTotlv
         YaRGytUJPEk/CN2ZcJ7tWizE+YPxRkANtHRWnpDMqhk0Jdn+AWH0MD6nzB3O+Vn2mplb
         H1FdMUu+1LDG6Ub2351I91ESa/d4S7Z+ph5PnYfSYEZ9dYrq8sdxSEU+5oPlq5WBgQKm
         FRqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=GiCw4FGUa/8Hmzx26mUdlsi/XCK3ybAO25PQJmYflYM=;
        fh=4SX5Rwy3D9wutJoyHYkX1HU1bw0m5NaZXG4c6s7gdjo=;
        b=bfbdHb9nhgEYbbc94XaEnVyBuVvgYhO5L2hizC4LqIDn43e63/5N6RkVSIcmUer6vn
         DlENAMB85ihZ+49zqTKNdioesVQe1IeSdsUUzht4dKZ/6nLSre+TD7xYPhvbYI54OAr2
         Yun8HGTSIzCk50vjeRiQbtktkk9YOSmWGrDXwuHEuQlzcf9PcgDB2xbJH8U8gmqveqqc
         HsxBB8gBF1zD9gavxHQJ5okFJt3sZxO+OteLukaCTVl8kvECqfsX6r3ktT1d/pyYpklm
         Mf25siSwvZF3weBqZWVf1lw0gMY7htBE3LA60ysvCrCebK6+44AAb0pGErIF7CiLDC7l
         aI+w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772443238; x=1773048038; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GiCw4FGUa/8Hmzx26mUdlsi/XCK3ybAO25PQJmYflYM=;
        b=ammq5Sp+ZEYzD/zurRVipqjBsgI6lV/nsr2OdrVwPfzvAYXnUGtPuLRWArzLqXj/k8
         SsOnafo7XP7X2xSIisvzf8Can/wVzDA2Mc1F6eN+FqcJP+wdUdK78RkKbUNCsp8nrN+W
         0HLKW+lfDyA/rLDglAZnPFrFruIZofNcNaSCR55ol6oMvCdZGLCr/EWYE8AXbtXxTQ4a
         iZ0gz0rpDMO1HSZB+07ORrMbgZGwM53o6/Px+gm1Sl3blPBY8L//OMxXh/fptBBPM2sE
         hhLsSjt9yV09TEujrdVevefzhRj4+3k2wGmGsQ1tRyJXNsbhudluLB3RSZu6na1dy4J4
         ma1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772443238; x=1773048038;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=GiCw4FGUa/8Hmzx26mUdlsi/XCK3ybAO25PQJmYflYM=;
        b=RAVmC8UB+IXpOl0R5yXrx7HazUChlz3syfJYr8FpwCPrXZt97GznMCEYuWcBFaGh2Q
         pcE03Rg0EeWjz3joiOoHh+wr94UvrmjoOYHimpYgVkBlZThQ3byfd6N7e1L+1SUJcm8b
         kbR7QqSMMduy3NDYPgnj7081MmXUPnkJt+fbCGntzd7QhUw/GRPOsWoDoI0IMS68hIbI
         +WHXZBT6GqZPlWwhS+/ojz+NcUYAGqJgnFghrOvbCT3HCyZ8g2bkaXWo2YY9K7a4KYre
         FwqHwbm+JNoSUgN9CgAeVzWT3iYH/uqOOeFIl39ut+B4svaoEeKgZQ5mKNGAMA72VSI7
         ZZwQ==
X-Forwarded-Encrypted: i=1; AJvYcCX4vSVZeGcTI5UXziBlYlOZ9y7vr3a+gUkgTVpi6Eb0emWRS/2aA8zFRpCZNLwnY3u0K9TBEWUs2A==@kvack.org
X-Gm-Message-State: AOJu0Yx9/le43t04iZYerz/wwhqISyeE1WyNAQa3XcOTKyfGAW1+qGTV
	KMhW40y7u3Q1f2CGfjsAiL20/RD1zvEY3NTUS1NwnEKdkzuh5S1PvdhORkqOEgIC6rQKQ+zMPsV
	IOctetnC+opvQqFp/i4b1dHmvZ286HO2pqgu+
X-Gm-Gg: ATEYQzyVySuevrlg7n4vrkckAPSWCa5W680hDFbpY28jKYcOxZ5Vp+4CGjppkFVkY/F
	Fbm6gR4AN6prbk6GNOw9WG/NG11JiBG0KkozcztQfIBwiE10DrKsLtwV9VmgmIYjo7o5i4eEw5C
	fBXWmWheBJ9YM2pU7XltKF+FEhsGq2Y+edwvJzYB/qilcoTY7CqcxblLeithWgbNUa69GBSHnkP
	yZwYy8AvXGVIG6v3zCVnMeLrkH/Jd0ycfWstJxC+HEKMKrB7HyzEJ1sx6leIo+PSKjZ15K02qbT
	RCXKwg==
X-Received: by 2002:ad4:4ead:0:b0:896:17e6:b3da with SMTP id
 6a1803df08f44-899d1dba572mr161938926d6.26.1772443237653; Mon, 02 Mar 2026
 01:20:37 -0800 (PST)
MIME-Version: 1.0
References: <20260228161008.707-1-lenohou@gmail.com> <20260228212837.59661-1-21cnbao@gmail.com>
 <CALOAHbBKr5ni=Ap2ASq2hx041WAghd+CzqbXGBSFPExBMJzcUg@mail.gmail.com>
 <CAGsJ_4xA3tApXCs2S-sZh2qA9RK_1masQ7nb1NYyCHXwnP9FAQ@mail.gmail.com>
 <CALOAHbBRBot0EXmzPNb2zpgC2GV5NfnzAZuosTb-iygjaw3U=w@mail.gmail.com>
 <CAMgjq7Bqb0M4bjCeaxjAgaB-Kj_kWKVjMMNdG7528w+uTwGnjg@mail.gmail.com> <CALOAHbCma=SW4nu_GPv_pbuuXv1V5JPB-9cA3z1TeemWqU68tg@mail.gmail.com>
In-Reply-To: <CALOAHbCma=SW4nu_GPv_pbuuXv1V5JPB-9cA3z1TeemWqU68tg@mail.gmail.com>
From: Barry Song <21cnbao@gmail.com>
Date: Mon, 2 Mar 2026 17:20:26 +0800
X-Gm-Features: AaiRm53EwSlOrJ39kMTcQ7vlqDDZhejzjkgVLqGrdUbyur608OtW6oRMkxEML0o
Message-ID: <CAGsJ_4yAkaqqzSu7SS=_fgZ_AQCqtbv8LmuPGCb7SiFpGk4csg@mail.gmail.com>
Subject: Re: [PATCH] mm/mglru: fix cgroup OOM during MGLRU state switching
To: Yafang Shao <laoar.shao@gmail.com>
Cc: Kairui Song <ryncsn@gmail.com>, lenohou@gmail.com, akpm@linux-foundation.org, 
	axelrasmussen@google.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	weixugc@google.com, wjl.linux@gmail.com, yuanchu@google.com, 
	yuzhao@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 047BBC0008
X-Rspamd-Server: rspam08
X-Stat-Signature: 48tm74c89ey6drbsptz1gohk4cdgtuj5
X-HE-Tag: 1772443238-781274
X-HE-Meta: U2FsdGVkX1+mNC5qBEKvgyMZNC88ts86nIZ4lNweZ0kuvjYcPFZA9sOZnysoYOMq1LPSkgGxTF1eL+DRvEvHigbm2r8ABNHpyX5jrImQFoFbChd63pOK7BZAYro7SeXcn+4dBfCC+Od9cNKZQRQ5u9GHz40zE5A+/0EzXzAY5F2ISyPvsRhgRPqYAIbw3Bn4TsLfTfuQWG9q1dvkBJNjbG476nhKM7Peg6EeBONtitBc3j8FJe9ZgqWLjV+6P2iSzhSd9c5L/sIvZU7+ixKbxq+jD7FoeWvNnf640Bi/BZS0/mWAHAQbll6q53A54tNX6a2wcLI7oiX8yF0Z6n/40/rZmxuWlGSDHRYqB+aT4qJzMVmOcZGU6wmZwC8bbHWyvTGvLjwUFfZNOICa/nwYaewUWg3EeQcf2LfxhUoCyshfAogVl12rHwGx/867i5yis/tt9E1dqfQJkKvFKbl3SoGXHUh8FMoVaEzfbGaBUBTefOcMSrg1l/C5I/hm5AyZXcnkwzQ3vDhFW1DK8cfPJvZQE+TO4Ko+DiJa3Z224WGVigG9iV5R/M5Obiu3Rwe6p47jynkWOvKX75iYct38ySWvSJVDDg2LHo7+Cg9rc40KDadmreSaX5j023w9pttOQpYxsbNtDEKWNixgWuBSfUbSUwf4XMwE31UF5roNyuPpgnd35CsqDaYBduhtfC4Fb9j5x1+QgGiy3eCMwBpC3LYAPmxqnMXq90Y5T6/8CHg8+iUeUNunGjKEItHQoWE5Lx5DOxPbPEE4/46XRBjLaJytUtgR6TFwXr1xjS5XzvWCcexEEM5gv89gc/MD11wzGDAxRu0K5ykCNBj5uK+paWOgJ0x1p+cLXeP0yl/TrQK4O8jB1831JcJGKvMVGbZcm4m5QxX0Kw9eK3IIt3Lf83sBorEV3kpHShplbVzeW0lz7b8in2DYTer7ZxEDYQ6/VsWfBZM6bpk4Pgu2fEn
 zh6HPSbT
 uC/th18GsY+e3Cn/4ytpl9WdS/8dwMh313ZInGhlch5gDJRSh0t48m31AIA0ANRE7ZhdcWFCyw6RVkzY7AZU3br8XEA1lk98/ij8B5FDeKSOIcZIEZ62DHKN4eRwbpNkIfGFN1tdTiCfgW6WB+ezOCKJdVD51vjm9THb5SQ6z3Rn8lnsiwFFNyEVuaK4oNlrGXq+WwU8fsljfrvRWltwTNWdYsZ9saIrv5K/xLvBQNZIM/+K9e85t+qkIMqFfUvAVPBrsWg+WZqqflA+Kz1n1I3mZp4kxJnsrJQJ0MmPQvKZWyW+tNoRSbhoxSMqtAkCVAyDI9te60p284lmiWt7M34kn63ndYk/ivyzMyz5RAdYTHeXB2JG6Thwa541oAs5DrCBny3pbwta2cgIGpkfX2VsFvsc+wrHreELX2MUTc8hW3T1wS+xb3oZCb7HXdAFEk0Lv9VeXJn2O3SX+1nz3D19iwaqbc+EA4xdwDvzN6yvi7aA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 2, 2026 at 4:25=E2=80=AFPM Yafang Shao <laoar.shao@gmail.com> w=
rote:
>
> On Mon, Mar 2, 2026 at 4:00=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wro=
te:
> >
> > On Mon, Mar 2, 2026 at 3:43=E2=80=AFPM Yafang Shao <laoar.shao@gmail.co=
m> wrote:
> > >
> > > On Mon, Mar 2, 2026 at 2:58=E2=80=AFPM Barry Song <21cnbao@gmail.com>=
 wrote:
> > > >
> > > > I assume latency is not a concern for a very rare
> > > > MGLRU on/off case. Do you require the switch to happen
> > > > with zero latency?
> > > > My main concern is the correctness of the code.
> > > >
> > > > Now the proposed patch is:
> > > >
> > > > +       bool lrugen_enabled =3D smp_load_acquire(&lruvec->lrugen.en=
abled);
> > > > +       bool lru_draining =3D smp_load_acquire(&lruvec->lrugen.drai=
ning);
> > > >
> > > > Then choose MGLRU or active/inactive LRU based on
> > > > those values.
> > > >
> > > > However, nothing prevents those values from changing
> > > > after they are read. Even within the shrink path,
> > > > they can still change.
> >
> > Hi all,
> >
> > > If these values are changed during reclaim, the currently running
> > > reclaimer will continue to operate with the old settings, while any
> > > new reclaimer processes will adopt the new values. This approach
> > > should prevent any immediate issues, but the primary risk of this
> > > lockless method is the potential for a user to rapidly toggle the
> > > MGLRU feature, particularly during an intermediate state.
> > >
> > > >
> > > > So I think we need an rwsem or something similar here =E2=80=94
> > > > a read lock for shrink and a write lock for on/off. The
> > > > write lock should happen very rarely.
> > >
> > > We can introduce a lock-based mechanism in v2.
> >
> > I hope we don't need a lock here. Currently there is only a static
> > key, this patch is already adding more branches, a lock will make
> > things more complex and the shrinking path is quite performance
> > sensitive.
> >
> > > >
> > > > To be honest, the on/off toggle is quite odd. If possible,
> > > > I=E2=80=99d prefer not to switch MGLRU or active/inactive
> > > > dynamically. Once it=E2=80=99s set up during system boot, it
> > > > should remain unchanged.
> > >
> > > While it is well-suited for Android environments, it is not viable fo=
r
> > > Kubernetes production servers, where rebooting is highly disruptive.
> > > This limitation is precisely why we need to introduce dynamic toggles=
.
> >
> > I agree with Barry, the switch isn't supposed to be a knob to be
> > turned on/off frequently. And I think in the long term we should just
> > identify the workloads where MGLRU doesn't work well, and fix MGLRU.
>
> The challenge we're currently facing is that we don't yet know which
> workloads would benefit from it ;)
> We do want to enable mglru on our production servers, but first we
> need to address the risk of OOM during the switch=E2=80=94that's exactly =
why
> we're proposing this patch.

Nobody objects to your intention to fix it. I=E2=80=99m curious: to what
extent do we want to fix it? Do we aim to merely reduce the probability
of OOM and other mistakes, or do we want a complete fix that makes
the dynamic on/off fully safe?

Currently, many places appear fragile, mainly because
`lru_gen_enabled()` checks a global variable that doesn=E2=80=99t accuratel=
y
reflect where folios are during switching. A full fix might require
guarding the shrinking path against the switching path to prevent
simultaneous execution, which would add unnecessary complexity for a
rarely used "feature".

If our goal is only to reduce the probability of mistakes, I feel your
current patch may be fine, even though some race conditions
remain in principle.

Thanks
Barry

