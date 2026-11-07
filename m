Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F4AC606A332
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 20:18:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MZTnlbIG
Received: by kanga.kvack.org (Postfix)
	id 75D0B6B05B0; Sat,  7 Nov 2026 15:18:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 70DBB6B05B1; Sat,  7 Nov 2026 15:18:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 624086B05B3; Sat,  7 Nov 2026 15:18:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 43A3D6B05B0
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 15:18:37 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B9131120255
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 20:18:36 +0000 (UTC)
X-FDA: 85409435832.11.18486F9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 2338980008
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 20:18:35 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MZTnlbIG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794082715;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0QctvfANf8m71klIHep/iiL0jBDeYa3bUuHZCrSLd+U=;
	b=ybRQGo7dMe/z+PEH5f11Q5d7dGfOEKQEiIGNOmT3UNKrZl4gY+zNXv3eFQgLRJ6E8f1lk2
	jPocOxAq62YGErtnnq2/roS7NpJbJZSr1gdiLm5efKop+KdTugDFyvcyReNeI+pUKZxIVQ
	g38QG7ls9MH7vQcq07NGOfS6V18Orxw=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MZTnlbIG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794082715;
	b=Xjcr8PcvwsF8HO1OdCFACOftrF8xIhTj7ec1/gnUWLOFJeI5YX62/C+VDIcd3utWn2hYaT
	Hi3ExAtJzOU5tMInHaD6HIgZC9R/HZ71wvZR6LslV8ARk0YV2rI1M2mggufPYnky947E/b
	Qj8iI5njOrziXgOw4SnS1utuiu+L60M=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A989F61189;
	Sat,  7 Nov 2026 20:18:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 287EB1F0089F;
	Sat,  7 Nov 2026 20:18:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794082714;
	bh=0QctvfANf8m71klIHep/iiL0jBDeYa3bUuHZCrSLd+U=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=MZTnlbIGEU8Tx9q1gI7QEoRw7flNo9r6oLAYyy08vDomrC10Petl80l0htRdYK1ba
	 UeA3yQ+Ux1LOtDmRaEGO2Ra42g24KnLL8Hd6Y6J4s85s92APX9M9twQXG7K5ghMGHD
	 l1qbPgeU+qp4A/Jx/ZPoNVDk9IHn97T/vzjZk70/63U8WlBSIq1dSIcFaAnM9tO2e0
	 PQ/+UTN1pv2DIUT9jXWNgkRuT/Wg9ESXcj/muPVJ8TcqIo/sAGbCi1H/+dmnOIqIbk
	 B7hstRTfxJCK5xx9rI92QMB7lOLFOPRjhjdTvGMidWnlC5XaqhTwwYc9CbBBSM485P
	 YXTuoy9jRXj5g==
Message-ID: <sashiko-outbox-203262@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH 6.18.y 1/5] mm/damon/core: skip applying scheme if
 region split for quota fails
Reply-To: sashiko-reviews@lists.linux.dev
To: "SJ Park" <sj@kernel.org>
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Usama Arif" <usamaarif642@gmail.com>, damon@lists.linux.dev, linux-mm@kvack.org
In-Reply-To: <20261107201001.206120-2-sj@kernel.org>
References: <20261107201001.206120-1-sj@kernel.org>
 <20261107201001.206120-2-sj@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 07 Nov 2026 20:18:33 +0000
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2338980008
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: gey178g3inyrgpc36wkbk99nsuh11tcf
X-HE-Tag: 1794082715-538106
X-HE-Meta: U2FsdGVkX18jcXL2JLOz7QD+5XLy/DbjDLh9813T+Cg/e/ZMuw6NBd7cBOKzdpbcdEzC8Vsota40WQSwlkb/7Z9g2krAxa3dmuu+yelblNTS8pWwpHTgWxNLkMr1dJWSJq4VBGSJLUr251+00SB4tnio8oLORJwgqgMc7Hv4v+h3ql9SBZvtRcERmiOx4CCjiKMEvajY7YOsRg631HNzEftechy88GrVuJ7X+IUEj+T2jvpfSu0B8OgRm40J4NgvLwxkone+9GCV/wUKZZ+EVEv+CDHH/6B2SX87ulE67gsoSwkFcTk3Ve1iqze3cDJlgW5nsQM11s4xuNHfR6HLEoVz6Mg8KTsMAqIBDphTbtxXvch7Ox1d/NkP3mnNqh8iCJ866lmV9uxJvZMm+rb7emMERCP/ax2wT/GW1/mAv+nzZqbizaDqKw0BI7BOt+XPEbcOC6qXcMAY613LecEhbB/aIVSZzY1ro5AB6CmKGXbZnMujTF3+eJAd4+jWTPESDaYZUacN2nwy3IKFDY1lZIHh/J/UhDBNI1SUIXHwecagvKbCe3VoFv/K0XdsAdgVvk1SK5ruQABsBdOVMGSqFmy59UVoxBSf2q8dHJgpK4mYRBVBW+48O67qSdNu8UQtLy+f2p73i4y1f0/MZc+sz7Jz5R2vfC2Z9OMN93puCsurEO13VTrfRFftZZuSTgApVzD/sLFhWxk+NUfKzvXYW6avd+DgD+pjBvSA7TVBam298JYs1MyipyBL0V3WTgVx+/wkwFR6B7aHbyi7yg/4iCR7WlvZ7tL7oryvpyTRzaE9s39QaX/yUoZirx0SV0qf0/O3slGJ31U5cPX6w/JEDWyUMBx3ACgdmlGrZy/OHPgk+gVfTQWme7RElHPm2BBD72ELG0eOai0sOwZ+CHaa0S5tKqcu2uKtpK8hlnoMZxWC0pQh6+OIdTMAMnGXsaCxAMyvU8CRNZEO9mNaCGl
 W6j7vaYo
 PISLoKTqaEpl/g3stSi/dhuS37+6KHuV31IrNvhK2nsb/R7t1SwZTe7Sk23IC/5GGfpw0rLJuCy/jVzjfnWTuMNkgfHQZuZfOCDglb+Q1xTBl8kiIG2e5oAj2Ie6nC3sl4d8y4i6vNXrWp4Rt5jAdYqKPkFD23N5x637WzxI/50CCEZSL+Mng1AJaq1CydMJPGih7vIfPzAWCfq+lS6LlMUDsRco2WTubZUvnKWvQJdCfRenD2cXqw4JGB3/r2C2OYOC2pVm7PC10CmTINSBl5a4bkbROGGCajxXEzQbBZk+pcQcgTubtzKMZt5R+r+GQ6R36AIE3kcsy7X/FXjVUopdXSxIiz+/71xhn6h94oKc/EoFHNbHAIChUDuGEWZKxkYe2NFct/65qlktUm8VsFWwisyAjbfGHFMw7PXzhw+PCH2fa2xkYNBPr3lw6RQCMEELrFbcoPr28ppHTS0/hZoNoGXOu9FDFhVaZbpAAqShmwkfytWDqnZwe1BnBzCTugvbJXLrOcwPwG7/kk5DHRCqdPO7z0lwcw5yrH1tc0NOhUzUNqz/g2Sj+EuPMf8in1SwoApAxC1Y7lyYt5FK4OIYzkA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Low] mm/damon: damos_apply_scheme() inflates stats on region split
  failure
--

commit dd2b638af6fec217ed7123ab31fe119102f17f78
Author: SJ Park <sj@kernel.org>

mm/damon/core: skip applying scheme if region split for quota fails

This commit updates damon_split_region_at() to return an error code on
allocation failure and skips applying the DAMOS scheme in
damos_apply_scheme() when splitting a region to fit within the size quota
fails.

Link: https://lore.kernel.org/20260901131850.98037-1-sj@kernel.org
Link: https://lore.kernel.org/20260901131850.98037-2-sj@kernel.org
Link: https://lore.kernel.org/20260718171523.87547-1-sj@kernel.org [1]

> diff --git a/mm/damon/core.c b/mm/damon/core.c
> index 8fa788b0d709c..4c536a9b958e4 100644
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c
[ ... ]
> @@ -2000,7 +2000,8 @@ static void damos_apply_scheme(struct damon_ctx *c,=
 struct damon_target *t,
>  					c->min_sz_region);
>  			if (!sz)
>  				goto update_stat;
> -			damon_split_region_at(t, r, sz);
> +			if (damon_split_region_at(t, r, sz))
> +				goto update_stat;
>  		}
>  		if (damos_filter_out(c, t, r, s))
>  			return;

[Severity: Low]
Does jumping to update_stat when damon_split_region_at() fails inflate
s->stat.nr_tried and s->stat.sz_tried?

At this point sz holds the non-zero aligned quota remainder, so
damos_update_stat() increments s->stat.nr_tried and adds sz to
s->stat.sz_tried even though damos_filter_out() and c->ops.apply_scheme()
were skipped.  Because quota->charged_sz is not updated on this failure
path, subsequent oversized matching regions in the walk will repeatedly add
sz to s->stat.sz_tried while allocation keeps failing.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261107201001.2061=
20-1-sj@kernel.org?part=3D1

