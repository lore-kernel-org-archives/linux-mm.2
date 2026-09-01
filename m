Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E303C624D0
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 18:08:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B24C6B00A1; Tue,  1 Sep 2026 14:08:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88A756B00A2; Tue,  1 Sep 2026 14:08:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 79FC16B00A3; Tue,  1 Sep 2026 14:08:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EDA996B00A1
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 14:08:41 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 874E41604D3
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 18:08:41 +0000 (UTC)
X-FDA: 85165978842.20.349D391
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	by imf03.hostedemail.com (Postfix) with ESMTP id 8696820003
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 18:08:39 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=aOUO6OSl;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf03.hostedemail.com: domain of stevensd@google.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=stevensd@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788286119;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X8FXyGo/raPRkoKPVRflMF35yNw57qYqgXG+3mdOgbE=;
	b=bNV4vuP2fxdZoPFzEctoBCBSMGy+/QVweMR+d5jD0sd6gGB5l+364P2222xAF5Yp5BrKwx
	vn6mneLZWYAyrbsilaWEktE50OKAK9ff6g3ojilUCFg+qfyjjtv6aBx1AowtOUDFpYV9gd
	CszvlyweKweuTwlMS+6sF7zkAbkJFo0=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788286119;
	b=FK8rQzEA5UEOi9cQwVk7mKuzsNd4E0gI/gYl7LTsJLoDrn5SjHe2ElR8/3YFXtf+V3oixd
	xNSsucuv7fZ9KDIU3T3vVTQiSHyQBGY7dUzzic+y6yCDcPEa0FlfBFG+ITj+3gJ4KHH/2G
	nRboGuYrHinN31Ci6TRTC9z9IQI7LK0=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=aOUO6OSl;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf03.hostedemail.com: domain of stevensd@google.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=stevensd@google.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-49ccf12bed0so5085e9.1
        for <linux-mm@kvack.org>; Tue, 01 Sep 2026 11:08:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788286118; cv=none;
        d=google.com; s=arc-20260327;
        b=c/VdjlUECLK7B9yIiiXGbymA5VYyyuQCLB8GpxFgn1/EoyyJAxKAusYy6O3+eg447j
         W38OrlfHE0E3PN51z03/dxSDwAXzS4jSDck0xDke8HzFZacmSLhVUSU002wBsJKq4sD/
         XP83d8JUBcDpizAhmE1tFyhwbkCPD/ka409hDleBUSxlJJSoc96Zqc+ndasakkpVXLrn
         IRirGlfj71f1aq116ecrMi3rKYJcobM7MJ3r3/sJcsyhtcsmPK0DotGMo5c1JWrFNFSS
         cbRZl1llI1cMvnAc0ljkCDRUlboyw0W4p1d8uK6bV3RBt3atQHJ89mktPuPRtIKZ98h/
         TPCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=X8FXyGo/raPRkoKPVRflMF35yNw57qYqgXG+3mdOgbE=;
        fh=zWNWOPUfUKlJWw6bKDGzA9sPqPgipab43WukAXc7DE4=;
        b=pEbS9i/ozOktGGIFlPZvxO3KrUADtgU2fd4vj4M9YHdiSjzXrJcYfvSrpp5P9NTS1i
         a1TUptwyjlAglj1ZNy07MUcZhKlguw6luG1p5Bva3bLRYUbp9o1cV5wVu83st6Sof93h
         NxwTM1Inro+155zqXWRSJLtYzlYCPo9+gl2TiE8ptM4FJZ4JQgpqzbHm0NurHonDgfxp
         2SORmc2aKAE8n8aGyodFDg1BZL6/AemXCE5Z08Hbzvhd5kcioECOPr0oO/jthW0W3onV
         DFrF3bGyrn7n02qfk7BCmRiuFFw6w7cVHQS7ZYhxuuzLmOXF/O19B7z9nldvGHVvAQ5Z
         dqCw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788286118; x=1788890918; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=X8FXyGo/raPRkoKPVRflMF35yNw57qYqgXG+3mdOgbE=;
        b=aOUO6OSlZk76Pxz2rG5jn/j3NWNXVzhrTQ6dQFHB2619WBT8308rh0RicqLHCANduP
         R+ck7PoRTO1e2tfvuLoi7SsTqsblnOrRlf2WaTXC5Bp0RNwZmVRI1EodnkuYz+zqKnof
         rL2jQqo7v31p3WncBskEmJjEXO+ihxFiqlOy+C7xjs6wDYsSxKQjbzPKGayeEBOn/g3E
         +IRbcsFFIAuV3BLzgM94BuYvORbnUJks+LrICU9BAq77mthEQReTIK4pIyWooHgTOgdF
         d79rXChooUIB6PrYq/JWtQ3Cn2k2CAz0S7XW++0Qo2E3WPHfjs2G9wNHVrOG7vyQr5on
         hd/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788286118; x=1788890918;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=X8FXyGo/raPRkoKPVRflMF35yNw57qYqgXG+3mdOgbE=;
        b=N73MLQvmTwTWR5Lp7h2hmKScRL4IcFr2vsKYjCkNmw9X2eyKukPcR0rKx5AvrPTbJ1
         ktYkKw6ceJifdAiYbdxKcTnhUUu3I/FHvIGEe6CiaIcXnZ7uIsVw6lANL2lm7OdvifMI
         sqiwbWN/QVeNc+a8FcsH3irxddaraPUOyyWaSyGnsdIhOEdSKxxdxS5k/JJtSN8EUupy
         oXLctBBcb8i6KxWgtqRZPUGS/XKWinr3quayXl4bZszRLCC4MRTpMcTf5AFaOpYOF7xE
         0WrkhA9FxtAKBX7BvLboCVU1x9dRatdU6tQ0/2/KtC9p4JBpRGww/Z+KPEdymnHCPvMJ
         eiSw==
X-Forwarded-Encrypted: i=1; AHgh+RpvpsxRDrr7kenBL/5NYgZf6vEL9QMXdv/wVyd5vQfdwz/BSR5u9K9PF2qMpFNPxV4zcmuXQPnFFA==@kvack.org
X-Gm-Message-State: AFuF++lADljhS35hqEYvauFiFicfnG2ZfIs9Qzddk17TQqoGpO0ZfP5I
	MKHfEtIIfqHofouWz1YaiLmG/BcxGF8kz3vyg1bthQ5oEO4dnOVbrMJQfQmJG2qS7vZtYBVvUMo
	ebavXbFg1GeIgG+pQP6Fp32IRKQ/aohfy1McqXyYg
X-Gm-Gg: AR+sD11uKtaJuexQPDL4CYpv9dCngkyujVPA5d+seoNY6IZNcd24NrcKz6aHUCxz8go
	wbP361Mwrpue8P4MdMvcVDLe4T05+52rSzP/B5WpvTsKBvKg12d8M5t1rqOD2kikxswv9HtT9nQ
	e3XwEWTU59gz2ctex0d5JJJ0dJmkTqcum1WweAAoqem+v6XBA5/R6Jk4UCLjazOQ+Dgq3W21WwK
	PvpicN6fvL5u+mn3eveorXBl7qs6A9RwibF/7pTTyv4Uxrtkkg3QcO1FUHMoqUKp3dHJ7pRJeiT
	auXhuU7eIJW4um7rVpwq7MUvELecVvoH8/9F4BfgScKGYE5HG0Dari/HX3Awmo+4A8HfLYvO66Z
	TuMbHyR4/y/ALG+FHxO/LU6xmNn/JqPX3+wGAcHQ9FnQ=
X-Received: by 2002:a05:600c:c8:b0:49c:e41a:4c70 with SMTP id
 5b1f17b1804b1-49ce47aad23mr50035e9.6.1788286117650; Tue, 01 Sep 2026 11:08:37
 -0700 (PDT)
MIME-Version: 1.0
References: <20260831234339.280376-1-stevensd@google.com> <apYXCL_GJs9Ovu0v@linux.dev>
 <CAOiLmNEV8b3TW_Q7+h5mYrZ1Nw73XcPFPUsapeYObLYajq_PJw@mail.gmail.com> <apaKRS7TYhlGRRW3@tiehlicka>
In-Reply-To: <apaKRS7TYhlGRRW3@tiehlicka>
From: David Stevens <stevensd@google.com>
Date: Tue, 1 Sep 2026 11:08:25 -0700
X-Gm-Features: AcwNN1UXbwoF_SLVJgTUIv4PDetr6v3cnkw3nV8p3K9PhP-UrCNprRfCd1ZzSOk
Message-ID: <CAOiLmNF6Qfc1M83fYFH030J7UKR=t8zKoW2pGbzeFakBnH9Ycg@mail.gmail.com>
Subject: Re: [PATCH] memcg: Don't call schedule_work when no spinning is allowed
To: Michal Hocko <mhocko@suse.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8696820003
X-Stat-Signature: r16eetosk44w64q4s9upuka3d1x8u6o1
X-Rspam-User: 
X-HE-Tag: 1788286119-770950
X-HE-Meta: U2FsdGVkX1+lfCSfT7wCTsbac7EKeG6DuxJQzYSHEr4DWuTY3mO70f+G6Y/xOG/EB3sWf/tcqVDE6aZfP3nSISXEdtqBCjK9sz3PcLKMTbMdovJioW54eB5VCEMqSuNPqnYU1QrRAt6iTbO7XnKpA3Gex8P5SZJBEkQHjOS2j19S8BJ6KeoDeMUEv/rt+61bA1V3l/Kb62mQ1JbqUO8F4UZkeqT+7+P8qNJlsOPq/pNmyHPEK2viy/feRJskuQzJ3IKBWINqusLrlkZy08BOkGvBNdgL2FZ9SHCSxrTZhlEscs2WHV91Q9jaoLvOAa4M7RK1BkOEljUSvo7cAP46NPvGLNpkQyauzVYQkY81koyPa0Tigj97XxM8oxor+LVLV7Q3TNaBKzhFEUwMrAEg2StQKa2tdJlLSXOaqk3zjOeT2cCYJOiALw6UqOvBP6Gn+k3HMmVQzJtkKQ2lOKdot/xAFC9Ri5xX1Ifho7HFpr4mKPCB3kP3lUcRZ0BY0ZJQ+3F7XLM/8YXwisJ58m3dpQPl8yb8NycRVXOmxBFA1xcnkb+N7MKu1Qf76AjuF/n5TzPmTzZMLZUn5vfIQEX9wcl/SquziijUAef4VptQ1YvNX63y3D+oED4FiRSPWNuoPRzzKmXaxjFHehpiXI69nMEEQxTNtgeQGnoOfe/xQRPoTLJ2rmIYr4nsZ81cTyFTxRqkL8MvnBcaVm9Kj+UrOGyvYHUzTUMLg0B9+9cuyq8ko/D5EdjWlYoi0aR/aBlyGjsRuP8hJE18PNPNt45qS2g4Y7bs6b7pv8ylATzwkvDD9ASsGbjP/3f4lVVVf0k87gf16s34QgbSq+/fE1029lTtKjWnYaGmBmHMj+IEVaYmC+DD6kimtsIm1/i0xvdZEqNaOvIaEHC1F20JZOAonIeFCDUmxO18phw6wmgg3MIUruey53knRs9NrNPx+MdB+KcHpdSqF3MfMdq/Skx
 qkaYXYMA
 t32jqQjMtgVC7oWA9o2IdIGTpH2q/Z76OPmvdcyhdHH3NJLk3ROopO0n4GgXf/Oy44MhLqd9ZiRG6+ji7w2NEKulnbuaUjvVC0twD8AJ1uoqOR6E2wRE5xDo2Kvkyt+k2X9kDGcwtGuZwZLeNDTXX3dfQIY36kxcz7k3WWA5PGWBXdnFkqCszzQLKeYcihZoMJqYCSN5yBKvdNhy7YCi/itJ4Pau5nsyHR9tM8mIVBwLfKG/bbVh35HKz1ZongS8xqOdNf8dgzlbqM1IdtWKw2i9utjtl/9zMGW58izcdOI7hekXye+tCKqO2n+ww0rRT51YzLcXnqGFaeyJIHEphJCRtWd6I+S0BKSfxn6MxJ2X/mig=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 1, 2026 at 1:18=E2=80=AFAM Michal Hocko <mhocko@suse.com> wrote=
:
>
> On Mon 31-08-26 18:04:57, David Stevens wrote:
> > On Mon, Aug 31, 2026 at 5:10=E2=80=AFPM Shakeel Butt <shakeel.butt@linu=
x.dev> wrote:
> > >
> > > On Mon, Aug 31, 2026 at 04:43:39PM -0700, David Stevens wrote:
> > > > Memcg charging can be done from any context, but calling schedule_w=
ork()
> > > > isn't safe from an NMI. If memory.high is breached from a context w=
here
> > > > spinning isn't allowed, use irq_work to schedule the reclaim work.
> > > >
> > > > Fixes: 3ac4638a734a ("memcg: make memcg_rstat_updated nmi safe")
> > > > Signed-off-by: David Stevens <stevensd@google.com>
> > >
> > > Did you hit this issue or just code inspection? I assume this is the
> > > done_restock code path.
> >
> > I just found this via code inspection. I spent a little bit trying to
> > trigger it for real, but the only way I managed was by writing a hacky
> > driver absuing alloc_pages_nolock().
>
> Then this is not really a fix but rather a new feature.

I spent a bit longer looking, and this can be hit via bpf_arena_alloc_pages=
().

-David

