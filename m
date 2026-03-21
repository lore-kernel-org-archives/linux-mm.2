Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A10B109446B
	for <linux-mm@archiver.kernel.org>; Sat, 21 Mar 2026 11:33:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C9946B00A8; Sat, 21 Mar 2026 07:33:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A0916B00AA; Sat, 21 Mar 2026 07:33:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DD476B00AB; Sat, 21 Mar 2026 07:33:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 702336B00A8
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 07:33:01 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DBE991B81B0
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 11:33:00 +0000 (UTC)
X-FDA: 84569858520.26.0D25DBC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id DBFED4000C
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 11:32:58 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RCK0Tutn;
	spf=pass (imf01.hostedemail.com: domain of rafael@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rafael@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774092779;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rMAOEEsQNN6cjg/M8hERxuexIWdXvh6STRGG5p8tqNw=;
	b=LCexfdHAuDTXBxnJJVF/sTi5xGbuVi7VpXl7NsK37Ytlnmp5LG+ZvTy42BYqo7hCLZe7e8
	K8bhrVoGeJ+OPBmOn7d8zTOO/K/b5vbLEIFYSLlvnsX4CQ2QElmjCn5j84y4/7zZ4yfs9L
	AZasCS46Ox2A7BuN1tFHQUzydHFc3TM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774092779; a=rsa-sha256;
	cv=none;
	b=6aI9VrVcwpVrrKHwYY2XTJrxrUNKLOCYvo6hYVK1Y6kqKn3ucoifSAEV881HEuc7mOxT+V
	9RO5SP/EQw1IZAOxib1tfRSvCo99AiqB9d+WWiSpEZsXy7GfyD+V2kVjonKjDMylbFAcVW
	JWc3mORVvOOry3TKObCM5wyyO8j1bk4=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RCK0Tutn;
	spf=pass (imf01.hostedemail.com: domain of rafael@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rafael@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id AD6344446B
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 11:32:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E4E1C2BCB8
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 11:32:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774092777;
	bh=KAM88FjdiVIi8VSewrRhuQcMYwar3Jb0jVu/scAesWk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=RCK0TutnkpyNYAkgwcCuwMpJgOfQ3gPoRlwe/X12p2GD1x2ZTdF9FvNCXX1pPxbxe
	 MMRnLxouUzn9wHZJd02V9aScmnT9zjrcuoKEZj6aB8EpLspc+5+PuyFucNUCS0/oTD
	 KOdZkKY7awb65aqnPpGSCqqQLyq8F7lpeWsG0MerxI2l4jGh2sMyI8TbwVEqw61ENR
	 AJ/Uy8gt99dWyzFXY9AmpY+0tbnZ6FELjcHSEEcH/KwsbcuyrzcqQnkrD0kO8F8KP7
	 2o7S4OMcALYCSNZF8BEzyvb1aVOUXeq+IznS0qoxoreOTK4lMPntvZwdAasFxJ3GVa
	 nabYQx7IwPk0w==
Received: by mail-oa1-f42.google.com with SMTP id 586e51a60fabf-404254ffe8aso1866735fac.0
        for <linux-mm@kvack.org>; Sat, 21 Mar 2026 04:32:57 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVH+4NZ8764wBqVLVHFQx2XY2q1l8a5DrpjwSBdSyzy1SW2jgugdL9VAQinRU5+FzAkkZvVxT3LpA==@kvack.org
X-Gm-Message-State: AOJu0YwQiiOe52OeMfn3fo5y4dpJcZtp/VfWKACG7uRVXc1PVXTNyhrS
	we0ji+P7OYXRxESCArGhn3QNCR0rgt3hSaN3Ixk5J0gHPP7e9QrFDW6YkywFXxVHB55tYupf6Z5
	Und40Kr1OfpnyaSPAgFf9Y5rJ3BvBhGs=
X-Received: by 2002:a05:6870:3b88:b0:3e8:926e:bf9f with SMTP id
 586e51a60fabf-41c105fc248mr3773776fac.13.1774092776566; Sat, 21 Mar 2026
 04:32:56 -0700 (PDT)
MIME-Version: 1.0
References: <20260320170313.163386-1-youngjun.park@lge.com>
 <20260320170313.163386-4-youngjun.park@lge.com> <CAJZ5v0gHTPCkVySAuPBkPoV=SwmBRG_c-TtPbz0CNsUUPEkY8w@mail.gmail.com>
 <ab53krr0y981Qyk8@yjaykim-PowerEdge-T330>
In-Reply-To: <ab53krr0y981Qyk8@yjaykim-PowerEdge-T330>
From: "Rafael J. Wysocki" <rafael@kernel.org>
Date: Sat, 21 Mar 2026 12:32:44 +0100
X-Gmail-Original-Message-ID: <CAJZ5v0gVbQQdpyWb72qDcsAoj7vg2v=pXOjdMuWzKHJsdJcHNw@mail.gmail.com>
X-Gm-Features: AaiRm53bzs5VbehqkGDb-NN8rRSI02pjR5TR3QpNVYJGELTNnMRcKAWlWJyMnWI
Message-ID: <CAJZ5v0gVbQQdpyWb72qDcsAoj7vg2v=pXOjdMuWzKHJsdJcHNw@mail.gmail.com>
Subject: Re: [PATCH v6 3/3] PM: hibernate: fix spurious GFP mask WARNING in
 uswsusp path
To: YoungJun Park <youngjun.park@lge.com>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>, akpm@linux-foundation.org, chrisl@kernel.org, 
	kasong@tencent.com, pavel@kernel.org, shikemeng@huaweicloud.com, 
	nphamcs@gmail.com, bhe@redhat.com, baohua@kernel.org, usama.arif@linux.dev, 
	linux-pm@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: DBFED4000C
X-Stat-Signature: hb3q69u1mzgkch88bxa831pue7uc9sk9
X-HE-Tag: 1774092778-31234
X-HE-Meta: U2FsdGVkX18j0qWaYmtG3RaU3oPyX/egBf52bUrAw5fGPRrQMfv9LmC+BTvttz1DbP8HpFd2d/bP8dYtDWjLapuHU5Y+eDUmBEZnM/8De8JgU1df1aa+YgnhRdiU1y5IwhZfk52rCifgaXnh4ntwjG8pcnHOWpHyQgCE2RXqSZuc71wP9cyZy/FIEqa6qcUCF4twCJs6Z5jOrypWG6sD/Sc55sh1q19OPIGO05YQgDDE6q6HzZOJkkHrbmifDuHjBKRXAshWI5N1F+Xt1soGrRlbEH1menNtKn0byGRdtMfxury1u8aQXihZbEVx5sGKQ1gxWs/wXQV4xmQazO3A+mY3Mrwpb0Iw9p/L8FGKEIprFnpsvWe4eErMIr51IZeqgDQoW7qevnz7z8HpWHgHaO0mHYRMilOXN0CB/R0yaL5xJLEUfLpeHvYcae6HPRr++gSwO1SWApQ5nE6Kd9r7FcQz8tk4t94gxLW7qXkvJAMyk/tZLe6ytHLH5Cg5NTRZ3JV5mKUlQHGO/owWs7vPMC+zDWtW/Ir0pyre/Sp2Ak86Z/wZ3BmLdWGTGF8zJuVrcBvs3oKR06JzM6YAD+Rtt3ZuPhuIB9cNJSy0JcTZYenNRBTVByUDl7I5joUu0TRP5e3xugXtpRpM14mBBYuRHi8MAUHHorfFa3xPq7fi/vCratclU9Euma99BJpoS58LdGgdht8h8VTO4mMd4HyCeAct52uwodPexG26+5GO3WnIRzpesDxkYr1XzO2pe8klCbXk3W5Aru2pT/M9svCeIs/qOdVzZd/1WeM/ioCW5gKP2IeHi0o9uNH8QI9lKJcz0IlSn5Q/oj5YDeyRuRQZPw5D3n0Rw8YxD8fCbYUW/5VA70aBnVF2pZjFShByhoNpY0n1Lws3L1nnWHTD2pYE5HuwsZ+R4WtlYMMtz2JPEWynOhkPFULOeQMM94pGwe7TgxCG3fEjK9V1PpdwSm2
 5gXVLwgu
 ccuQ58i5J0wcVZv4LqwHJBcU9EzI6Eqb8FfB1GUkoBcTmPu+a5PHAhEz7YSEzRv7YFchEU63HAmbA7FnMr9S7GjmXpMqDoUyLDr3gnpG5iv/A4SGELalUbToI13EEQ784KBABdoStM/zkiYOwxikHPl0MnFKGDpDF0fska0VoWtuLBBCuOHB2YuawMBsCq1z4AaMcQCK2Zy/CNBp9c6kWY5bx/KQFHDL1lEq183MZnEosBdfgazEqpvSGgcO11HSd15UI21CqXzswgBc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Mar 21, 2026 at 11:48=E2=80=AFAM YoungJun Park <youngjun.park@lge.c=
om> wrote:
>
> On Fri, Mar 20, 2026 at 07:20:24PM +0100, Rafael J. Wysocki wrote:
> >...
>
> Hi Rafael,
>
> Thanks for the review. Sorry for the back and forth on this one.
> I'm preparing to send the uswsusp GFP mask fix separately as you
> requested (with _nowarn rename and lockdep_assert_held).
>
> Before sending, I wanted to check on the approach. I originally
> found this WARNING while testing uswsusp and thought it was a
> localized issue. But AI review has kept uncovering more cases =E2=80=94
> first SNAPSHOT_FREEZE + snapshot_release(), and now
> dpm_resume_end() when dpm_prepare() fails.

dpm_resume_end() should not be called after a failing dpm_prepare().

Which code path is that?

> More callers than I expected use this defensive restore pattern.
>
> So I'd like your thoughts on the approach:
>
> 1. Introduce pm_restore_gfp_mask_nowarn() and update each caller.
>
> 2. Remove the WARN_ON from pm_restore_gfp_mask() itself, restoring
>    the pre-stacking no-op behavior.
>
> I'm leaning towards option 2. Defensive restores are an established
> pattern in multiple paths, and warning against a legitimate no-op
> seems counterproductive =E2=80=94 we'd just be playing whack-a-mole with
> _nowarn conversions as more callers turn up.
>
> What do you think?

Using the _nowarn() wariant would help to annotate code paths where
omitting the warning is legitimate.

