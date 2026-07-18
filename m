Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1868C4451B
	for <linux-mm@archiver.kernel.org>; Sat, 18 Jul 2026 01:28:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 88D366B00A7; Fri, 17 Jul 2026 21:28:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 83E1D6B00AB; Fri, 17 Jul 2026 21:28:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 753FC6B011B; Fri, 17 Jul 2026 21:28:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 41F736B00A7
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 21:28:20 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AA8851402C2
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 01:28:19 +0000 (UTC)
X-FDA: 85000161918.26.07703E0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id C8593A0005
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 01:28:17 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IuuuKNHd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784338097;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2f5ZC7wkqIcBsou0hQoWM0u7Okid0V2TGkFRJo/KT/I=;
	b=VM/jDLTAB3RHXL71iddgTcisw+Eno/v8FT+NJsnsC5y2Byi4sAFg6GgA9zG3SjyqX8AHtl
	cfs0Bk7YJev0QVakWWTxRwUgkp9gUKSwXZ0/LgsgkVp3atNA3PmsuFp1/V41ckcqY5PQhD
	wJQUm658M/Mz0gHTgqM9vKAYBhLP41Y=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IuuuKNHd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784338097;
	b=LvDaPvOxn9qO6T8cfw0VpxqpHB4n+q8bnaSywnHlhd9pv8zMXo2GksDLr1X6b/7P1MELp9
	47xvz1jrDlODfPbhN88FpYoooLe9PR/73Cp7rmAfenC2vTW9n/ZSUR+B8pnzk4r80WbtD4
	smfrLBRlNybG+14Iywl8XZ1tTw8nSYU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 07EFA45061
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 01:28:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4E1F1F00A3D
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 01:28:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784338096;
	bh=2f5ZC7wkqIcBsou0hQoWM0u7Okid0V2TGkFRJo/KT/I=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=IuuuKNHdML+K81nPVVvf7awSkBgHaAJbm84qcEb7NiiilCrrwnbk67uk/gyvU+vxB
	 AiET0vEocZkohsKEna/JTEOKZRzThk+zARZBWp/bt7L59LwTC5u/9lRy49t4TMOm0A
	 3+iAxnPDdsUjVa7/oRBFE10qSE1UiMBuMSoJ5eIWFe7I37FmfJqbMQAE8ADUFOPloH
	 WzY1wLocmsv7KAb5QHE4/bSNfkS+L0sVC9F6GK4Iyj2OSIS9Q2xp1BKMmDf8w61yNH
	 6ikzna2M0HR0vu3KAd5XxE3zZMrAgZy29frwpCQRyxVJnMJWMiSV6/eHU7SoT84onH
	 oLTw3liuI7fTQ==
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-c16794450aeso448280166b.2
        for <linux-mm@kvack.org>; Fri, 17 Jul 2026 18:28:16 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RqdllQot9he2yZkeA81tcU+M9y3kGGl14C5sEk9VqtkWBj3L/9e/8jWUlsCuFThWWWFTBkuC30g+Q==@kvack.org
X-Gm-Message-State: AOJu0YyI0IGQ7bHi7wYlUuO7yoGfiUKPlMQC+Ikq1FNa344S402pvzkA
	xVPeaOD0feS+I73yKDeHcZEvic7cJN+3BkWZMdesA/D6ctvTC+ih5Rwbrh6kGcisZAapnsf6OTB
	BRrKDoJyt2OMEWVEA/+5mwFyf6QeMKtA=
X-Received: by 2002:a17:907:7b82:b0:c16:5f28:4575 with SMTP id
 a640c23a62f3a-c16b4766327mr215549666b.31.1784338095758; Fri, 17 Jul 2026
 18:28:15 -0700 (PDT)
MIME-Version: 1.0
References: <20260717085151.22822-1-jiahao.kernel@gmail.com> <20260717181839.c94d0335ccef0084707d3d85@linux-foundation.org>
In-Reply-To: <20260717181839.c94d0335ccef0084707d3d85@linux-foundation.org>
From: Yosry Ahmed <yosry@kernel.org>
Date: Fri, 17 Jul 2026 18:28:04 -0700
X-Gmail-Original-Message-ID: <CAO9r8zOrXqsEaCEJUUAxbAhhN_OQb8ejogeUa6k8hX_JV8hxxw@mail.gmail.com>
X-Gm-Features: AUfX_mwqUoHjaL258a9ZUOa4FhW0ym2bwIwrlW369zxtsJv7jS3V44hb-9YhN5Q
Message-ID: <CAO9r8zOrXqsEaCEJUUAxbAhhN_OQb8ejogeUa6k8hX_JV8hxxw@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] mm/zswap: Fixes and improves the zswap global shrinker
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Hao Jia <jiahao.kernel@gmail.com>, tj@kernel.org, hannes@cmpxchg.org, 
	shakeel.butt@linux.dev, mhocko@kernel.org, mkoutny@suse.com, 
	nphamcs@gmail.com, chengming.zhou@linux.dev, muchun.song@linux.dev, 
	roman.gushchin@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, Hao Jia <jiahao1@lixiang.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: eqkt4yzo5ebgboihe1afzhpqotsd8jgk
X-Rspamd-Queue-Id: C8593A0005
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1784338097-34293
X-HE-Meta: U2FsdGVkX1+U4RW1eMDnUfxBHFU4U2T4R+K3LcA8kUjP3bvgCsk5nP5rPc3u+Z95IGFzzuW0RrsZtC0k6yhAWRGLQtOY7PN3afoOqnKy6ecZmCZy6Ir/iS88MwL5cRck0skKRar3oVo9l05JkyoA0gyWzx43aLQnF4m0+AXkMYV97BQWE8qY7GnmZV90QnkP2OZOjTcf/8yJDzFqoEReJTOKmpRIy0tjnPsFSzDP9v08ANL2Lm2qGBMa+qLLBFfutB3ltP1JFVoh5hUbaiQ4BkhFxfXBh+H/qddra/7+NgTSQ44otOiNseQSDLBmSTT9ESpnH4uRh2XDCTiKT6RUWfBWnws2+voJIzGFv7Sfzd6sPsU8eoJPr7mkrg1un9TmD2fs02sXFm9+dWqDKfcxAbLKDGfxcTq5+Y/HN2PQJYxaHwm0v2i+MDrQUdwXvMVNi3q+oMCjDhCH2Oke8Y7gP6DBFNKi3Rcg3uJhJGVYBtAehXfbPBNYrsCubdnnuUEN5/CFscQ0g/nxxFHS8VQr8KoLotH9svD9G2fapFzXryMs5YKY1BrJQahkF1aZgjjwqzMxnMBEuGI9EzIOCbqNTo6EhVR9zBqYK2DBLp+RJFAGgvdkxfmHuJ9huj5bAcgiXYSNMHdLDcAyjtSJ41umblliIfqIGnF4qAHgbphEYngtca0c4B+LCpSZshsbxKVhtqoFn69FCVjn2BNrI0aIOH6ADk3KQ8r5yzqWeDn39eLiCzzPlBWvT80bSKrYJUOK8m+1gtvpfJA3+6HJQnMtiRarqPwGF2phyR6x0CmYZzL0FrpZ+edwCnd4ALhlGbsawtaConomLzbH1gsmDMu+o0iO+afHCf8fv8yiasXCyORP5qvjkl+CntVvsV8JWMCaB+vjz5rBpCr6ROKepAxHylREA1R7opF4l5FAkC0C8m7ohKvUdalW/Ch1nibfWo0LBsuaAiAyE8N6HVfj47J
 O8pIYTaQ
 Pr9mmT7YrbOnYahX2QUgEx8m2RKNLxUocipXPs4hg1gwQQGGHzCPYxPrP3qDtS7tmQrptj3l2HHTEy3Hi7KJbuiYH47JdVair8zZfV3F8drYI5jm1MeRno04LkfRzxuOfBA2BJYNh5p+zSBKbxrQ5sjWZ8Ab9kI4958CfslWxTRhIMQSciFKRRwDRkzcL0CXPQWt0Lj+i6ER65Ue0dh8HGxIER7krRzjemvGmMuoITggLES6o+ZF4F/l2cs30LNEbDrjM636Zh+ZpU6fJXY5X913U4CgnetY5rmjMXt3OSGGEjLwguQTkakN1CfOhCXyky2LHmFbmxFeeo7402JVu8TwxeXuvzK67GHdVc1oGLU3wxdZz+CntCjIPmyBP8RBvr3B928U5zvVUNk4KCahX22ffonhdRkqQUSc9IvAGfGnwiacc5KrZHlnETUqBuJMPQ9vA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 17, 2026 at 6:18=E2=80=AFPM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
> On Fri, 17 Jul 2026 16:51:49 +0800 Hao Jia <jiahao.kernel@gmail.com> wrot=
e:
>
> > This series fixes and improves the zswap global shrinker (shrink_worker=
()):
> > Patch 1: Fix missing global shrinker when memory cgroup is disabled.
> > Patch 2: Extend shrink_memcg() to support batch writeback and update it=
s
> >          return value semantics, thereby improving the writeback effici=
ency
> >          in the shrink_worker() path.
>
> Thanks.
>
> [1/2] is a cc:stable fix so it isn't really appropriate to combine this
> with [2/2] which doesn't fix any bugs.  Because the two patches may
> take different paths into mainline, with different timings.  But that's
> OK, I can deal with the splitup if needed.

Thank you!

>
> The [1/2] changelog lacks a description of how the flaw impacts users.
> Please describe this fully and maintain that info within the
> changelogging.  This info helps -stable maintainers and others
> understand why we're proposing a backport and helps myself and others
> with timing decisions.

The first line in the changelog should be sufficient imo: "Zswap
writeback on hitting the pool limit is broken when memory cgroup is
disabled"

