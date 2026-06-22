Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3CD6CDB46F
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 21:23:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D2B2B6B0093; Mon, 22 Jun 2026 17:23:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDBAD6B0095; Mon, 22 Jun 2026 17:23:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF2606B0096; Mon, 22 Jun 2026 17:23:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 976F96B0093
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 17:23:56 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CE6CC1A02E7
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 21:23:55 +0000 (UTC)
X-FDA: 84908826030.21.8C4A056
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id D841F2000A
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 21:23:53 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XRnatCR7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782163434;
	b=zYkN6G8ctTrjC3VuP0V9iujLLuJ+wmyos2WdlqEW8FuGJ5JfQa6sedxpxZwhW2QnN0+apR
	uBD69N983lBmApHl/AonNJHYbrajV+f2lQBL3A/wn24QNbArLMLvO9SMCigachKjzLq2Tt
	Vf3tAlAqTQ0IbwG0RzBN0i8OX6zm9+Y=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782163434;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nBwt9+knVk0gxEW6tWKS6tT3TGyu7KUQndTvmvb0IRk=;
	b=BJVKEkc5DcmzJWBS0mGw2SIoWzJRwdVvLU4F2onP8qMo11y0F/5f120bvQ7YyAKDuYZP2a
	TzRgKxGYNGPN7ZKJLBtHcnBGSytUt7gED8V44ElMcGgCe+vVYppNKKjPgyyJzhW7OIEa/e
	FTrzROCjyk2iSUEaOCTTg6LiimrsDXk=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XRnatCR7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BCEE64456D
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 21:23:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C5FB1F01562
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 21:23:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782163432;
	bh=nBwt9+knVk0gxEW6tWKS6tT3TGyu7KUQndTvmvb0IRk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=XRnatCR7g5cHdjsDdRYyhckULl9uxrOillWQcSI3Kzne+LlWnEhLA5hUIlrvPGi/j
	 qNorXog60LQZrrDm5c7bLsxFUk5Ozz20GC1V2gZagx9/rZ+fUFOu9NKcY7fDfaU1hX
	 fM3UDDLfNi1tfbLdIFq8FU/ecvcW4cKLCHZT2G69SH/TtCqsSgMztC5jH8n0z0yHlR
	 6pFBWST+vBugWpRlOEauFXF1V9YitftUu37xKXAGiCwIrHaGjD9DpANC/n7MBLy8BN
	 Znt5OS1QdD/79bCGD3KJ4EIARRRBoevjx0A951BR/UEiQ+dbswIDe8muksIB1HIZja
	 m3CEAObSrXbhg==
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-69775980397so4646057a12.2
        for <linux-mm@kvack.org>; Mon, 22 Jun 2026 14:23:52 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ9lJMCbJmAX1g8rMN5EgYV7UkVzFfIotO90IP/1pxQ+5I7AGZoTeOrPVzlKnlF9+kfLlB6xEQolEQ==@kvack.org
X-Gm-Message-State: AOJu0YxRv5U/4kaTcTKozRt1tFSco/YfEf2MZ99OSrQAJVhNXUg7vI8b
	g2MO0AeangGHXMZtIGELF1zn5SuWaLf0aky8dbPrpou5Kv+CtAH9krKxFJ6Qyx9xzG49fpAuMjX
	28wJvm2I0+ebqk85oq2BmnTYzoKoj3Tk=
X-Received: by 2002:a17:906:ee89:b0:be2:cd33:2142 with SMTP id
 a640c23a62f3a-c097af68d12mr851744566b.15.1782163431536; Mon, 22 Jun 2026
 14:23:51 -0700 (PDT)
MIME-Version: 1.0
References: <20260620181635.299364-1-youngjun.park@lge.com>
In-Reply-To: <20260620181635.299364-1-youngjun.park@lge.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Mon, 22 Jun 2026 14:23:40 -0700
X-Gmail-Original-Message-ID: <CAO9r8zOy99szvC4W0+SUv4b3P2UxppJuBeZDV3HZzQuHUc1P1g@mail.gmail.com>
X-Gm-Features: AVVi8Cc8noq3J4ynSRL6iWoOzgSvAT7nf-W2GfIbJXmFcMZ6lpr21cn4bL6kHZA
Message-ID: <CAO9r8zOy99szvC4W0+SUv4b3P2UxppJuBeZDV3HZzQuHUc1P1g@mail.gmail.com>
Subject: Re: [PATCH v9 0/6] mm/swap, memcg: Introduce swap tiers for cgroup
 based swap control
To: Youngjun Park <her0gyugyu@gmail.com>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, youngjun.park@lge.com, 
	linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kasong@tencent.com, hannes@cmpxchg.org, mhocko@kernel.org, 
	roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev, 
	shikemeng@huaweicloud.com, nphamcs@gmail.com, baoquan.he@linux.dev, 
	baohua@kernel.org, gunho.lee@lge.com, taejoon.song@lge.com, 
	hyungjun.cho@lge.com, mkoutny@suse.com, baver.bae@lge.com, matia.kim@lge.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D841F2000A
X-Stat-Signature: gfq3nyyodi6z1uhns6r64jyxgjjmxwic
X-HE-Tag: 1782163433-358311
X-HE-Meta: U2FsdGVkX19pQijY4kIpxGRfr8gj8EgLDk3AK8Samvl5mfJ5Kn4gF0whIm11ExyeaDwPgivaR70V3XM74ZPPqoo60bSiZtOe9LpdASo8ecTHktyZJFTvQSYld1o2f1DKwiw94RKp1qH1KQDbYk8hQPOqV+hdWaU/efpzvCLpwEttiftEL6yr/ldrWDUuxMgBUWp8e4b5man4QHsrwaydAjn3xhDdJoe2zI23T9wk6snpPdOb7rJ1pbTeyRph+lU+FL4VPKGP1col8RPYtH+JnYGPJcACyannFcyYJkCIoqHs0GYLyyywpYg7V+BKolCRPFsCYKkfJpH89K+tRTigc+eY3NiiNqgb5nYdlXP3BDIgMDiN8sulFaEHOpzSszMUInNvIM+jy0CwBXLZiE02Knvt9b17Zi8bpuGvV5pY2MeQ5Gn30DMtpB3J8yiK/vDFhpOjgVGlo7uGqJb4+T0Pgn9bgQqZNYKpPVpZUa8S34pdBORS+HGCrIFIgyvXkFgmE04Mvk9wyy1dcYt/PxyxH5YG920tzCmdI74nnDvgaZwUHFjwMPg6lv/g0YB2RZFLsPVjoRiJrPIE5igbyIs5U66aCgWqtm2rrtDUJs2l6m1JvbjcZ2gYvUvdLzykpOZO5RKSwXUvBxhu0rEp3769eaDMOUDzp4OGaPnN0z+//En+XyYblE9zMKP04OpFj/x9C7sixl4RSUOHx2+a/Hv/oySjLIKSyLvJUfwCcXZBphz6cDQrIWM93DpTU9bnEbFKWU9u8VU6/rJbP8NSsI9WnUnaU5PiWQPv76EHridKr24X/90oDpj9b3jEiJbs88XT9b1Qwnx2sAbsOk0iwu/IHY90CRZiI6bxeiqYJgswYCmCq9IMVeopT2mmqcrJ7eXzMy7vRFBnWfKNEET+l6K9eoMtc/FQ6EEy63HGJhEvfmhRHfZ0HcKR9U9nOv7S8QYM2s/9J4RgY7EOj3Vp8Ba
 Sd4KEQP6
 6vg0uEsmfbFT0vjjGiJKWiXD9zKR0HlOXE5HzxvBdGbwS6e5J80sp0l27irPCKmK887QQCr/U3Fbk8o9PHkhRodDO4KYwdgvKic8UeoPsGN6nwhW2oBRpVeghit58/RFJp9oygElnp/JSfShk+vtfVEDjObfs8VSfnSrgSbn36BXB9eUnHcpoWe7X+7uHsUCzs4HO77rhlg7pU5ECmNf58sDoDWAxvvt/JpAM2o4IcgW/J/pZcnzaZzd41BUpMO27IywKYgeG/zEQXAI5YmN5bmndSw0ysnifhj6OMS/djfjbWy0nh4zbX1qiSA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jun 20, 2026 at 11:16=E2=80=AFAM Youngjun Park <her0gyugyu@gmail.co=
m> wrote:
>
> This is the v9 series of the swap tier patchset.
>
> The main change in this version is the addition of selftests for the tier
> interfaces, requested by Nhat; see the changelog below for the other chan=
ges.
> I designed the test cases and wrote the selftests with some AI assistance=
.
>
> For context, the bulk of the series is unchanged since v8, with great tha=
nks
> to Shakeel Butt and Yosry for the reviews and discussions [1] that shaped=
 it.
> The main change in v8 was the interface change to use memory.swap.tiers.m=
ax
> with '0' (disable) and 'max' (enable) values. This mechanism was suggeste=
d
> by Shakeel and Yosry.
>
> This change allows for future extensions to control swap between tiers an=
d
> aligns better with existing memcg interfaces. It is confined to patch #3'=
s
> user-facing interface; internally, patch #3 still uses the existing mask
> processing method, which is implementation-efficient.
>
> We also discussed tier extensions. Thanks to Yosry, Nhat and Shakeel for =
their
> valuable feedback.
>
> Here is a brief summary of our tentative conclusions. Please correct me
> if anything is misrepresented (details in references):
>
> * Zswap tiering [2]:
>   Tiering applies only to the vswap + zswap combo. Zswap itself will
>   not be tiered, as the current architecture requires a physical device
>   for zswap allocation.

I thought we agreed that zswap should be a tier, so that proactive
zswap writeback can be implemented as proactive swap demotion?

The only restriction we talked about is that zswap cannot be the only
allowed tier as long as vswap isn't supported. We can lift the
restriction when vswap support is added.

