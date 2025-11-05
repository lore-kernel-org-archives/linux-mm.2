Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 364E8CCF9F8
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 06:08:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 68E998E0009; Wed,  5 Nov 2025 01:08:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63F418E0002; Wed,  5 Nov 2025 01:08:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 52E548E0009; Wed,  5 Nov 2025 01:08:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3E7F18E0002
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 01:08:27 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CFC2E1DF37F
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 06:08:26 +0000 (UTC)
X-FDA: 84075523812.29.3B680F7
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	by imf13.hostedemail.com (Postfix) with ESMTP id D04ED20005
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 06:08:24 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=shopee.com header.s=shopee.com header.b=EBq9KbBN;
	dmarc=pass (policy=reject) header.from=shopee.com;
	spf=pass (imf13.hostedemail.com: domain of leon.huangfu@shopee.com designates 209.85.167.48 as permitted sender) smtp.mailfrom=leon.huangfu@shopee.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762322905;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ko+h2HHqIfyVkiIdgqbGuzIvxFEpCvepvxTD0kgHwio=;
	b=nmbcVFVn3Y/+x/gS4mZyNc+AaRWbmvnmqlsYP7UuwRFSiZ37eH4B9O0tSoxQOF9m5mv6S7
	hGPIwDatUvIEQ8Y0NlfED4Agd0475s3RKwIYNPbImmmyFOm3OC6VTNeHtJPDZRYhjS/XUm
	fHNDsjJPBa5yEVFVYlNj2sSt3UTnQoo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762322905; a=rsa-sha256;
	cv=none;
	b=J+jUbvS319Z1qXNM30wxf2B5GT3NwEeMdMnYrU9uVodJ28tFIyGpzhiKV8cx4YIoBRxiW+
	qYpPPiEglDbljS7rzeoehTG53R0l46orgFqSFFggc5OuZ3Cddd26WunQPdngKRBzZhpy+p
	ouzjobCJ/HJtYqxSRI9vpZIr+KEPcNg=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=shopee.com header.s=shopee.com header.b=EBq9KbBN;
	dmarc=pass (policy=reject) header.from=shopee.com;
	spf=pass (imf13.hostedemail.com: domain of leon.huangfu@shopee.com designates 209.85.167.48 as permitted sender) smtp.mailfrom=leon.huangfu@shopee.com
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-59445ee9738so10343e87.3
        for <linux-mm@kvack.org>; Tue, 04 Nov 2025 22:08:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shopee.com; s=shopee.com; t=1762322903; x=1762927703; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ko+h2HHqIfyVkiIdgqbGuzIvxFEpCvepvxTD0kgHwio=;
        b=EBq9KbBNQPlBT+7w79LcUf30Crn45gA7ThKtY/uAnmUJ0jy8pgW/AYqabm4fbVGzKs
         ZFqA1n02HWYONjUaKZIGZ5CHKd3mLp62GRMO4PGBwdO+qEtDURpMcL03oCkr/F4AGK4m
         ytJOi356ZivSJG9Mw+xZzOFV4550Bi2MEQpr4BMCk38Vo8o+EsZMjmIglVdN888o1pX7
         +NgX6RiVOXVZMRyrAKuInyyWKqBi61RECtxdzFF1plX3jS9zScYkJJA6HxhwW70jjt60
         jirZoGDVYY9urBdbbuVHLZypBKYv4bENNFT1els5tg1/DgDRdMiMGdA7kE3eiydjptal
         xURQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762322903; x=1762927703;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ko+h2HHqIfyVkiIdgqbGuzIvxFEpCvepvxTD0kgHwio=;
        b=ZROmra0Xb4zOwgMLJVlLfTDavTQNph6AO+hLNrv3Wm9cYrtPKtkaI+Hf8+wPITEzOv
         b3RLiIPMdtQccizUh/7jG15FEgDQt4WWn+/HLje2asEM/uKvmLBbFhmAa5F+0J5PvA0N
         pCvWVJEPm0L6k46J/052Z1EkMnKFLc5HlO5JktbfDHpmr7AFGKWbysR7KyS6H1OvqOL4
         Na3y1oC7ehd8q4AIlBmWxRjw5D24wEiV7yWUs4pOw9UjJ+8/cyYmi+Fp6ECw6/H5uMvw
         SNfNtC37cVW0TF+XshQPBOpRYbaAmFIYi1PTgGkwrMm28p+FjQsASBESFudaTFllhWkm
         t13A==
X-Gm-Message-State: AOJu0YxGcDqLHOf6aH7X73EOGm+RknxF/5oebRhaHWVZJcK0eY7wjcWA
	ZwS1jmtmh4efn+/ZgVULOSOplPXRjL8Wi/MlQNb1qEaM6DMgTjTqhVmpkEOPghkutTd9olz1dwt
	REUOLkPu9ObCFZrzQMvyRJEW3jEtboKlmPYp/c55EJW5xi1PRxzFySEWXIQ==
X-Gm-Gg: ASbGnctrZ8MYGQ92YgPf4kpKqXVZMPnr1yTguG6Q8capLRL/Lqh5+GiA4A2cDbiptCE
	L1KlhB8OZN2pCCBwZz5pn1pXUKbKn0FF01/4not5V6uRvukXARujAxSg6G0wwjb+aLnCSGSyjAD
	yc0yCoaWv8ZL5EPe9TKM9YJ2pfuLCwfUCYZtW1v5hZF9AiAUwEiEYzESqBZNXb7crMo4IJAmnt1
	XHwgYG/A57rFe3IeSxx0MJd6hAhlv7wWcIgH3YWklrytuXlI0Ww5azj3q8=
X-Google-Smtp-Source: AGHT+IGhzBDN0J2xo0zgTrF8hoLMoPjH/0yoSaTiCKabdffwkstVhE2JzObLLjxmM0V2ZK+kJ0pjRcykFQushFkcK04=
X-Received: by 2002:a17:907:94d2:b0:b71:ee24:8a3d with SMTP id
 a640c23a62f3a-b7265154e9bmr164396666b.12.1762322529791; Tue, 04 Nov 2025
 22:02:09 -0800 (PST)
MIME-Version: 1.0
References: <20251104031908.77313-1-leon.huangfu@shopee.com> <aQnFn6vPQ5D6STGw@tiehlicka>
In-Reply-To: <aQnFn6vPQ5D6STGw@tiehlicka>
From: Leon Huang Fu <leon.huangfu@shopee.com>
Date: Wed, 5 Nov 2025 14:01:33 +0800
X-Gm-Features: AWmQ_bkS8mFduVj_GZzMUe3ULkR8btNSr45nec1ttI4iNP0pSA8_ELWgHC8BzUM
Message-ID: <CAPV86rrt0YT-npNSBJ_eHvAYdr_j1qkN7H+J4QLN8zsfi5TJ4w@mail.gmail.com>
Subject: Re: [PATCH mm-new] mm/memcontrol: Introduce sysctl vm.memcg_stats_flush_threshold
To: Michal Hocko <mhocko@suse.com>
Cc: linux-mm@kvack.org, hannes@cmpxchg.org, roman.gushchin@linux.dev, 
	shakeel.butt@linux.dev, muchun.song@linux.dev, akpm@linux-foundation.org, 
	joel.granados@kernel.org, jack@suse.cz, laoar.shao@gmail.com, 
	mclapinski@google.com, kyle.meyer@hpe.com, corbet@lwn.net, 
	lance.yang@linux.dev, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: tw4nfmsudd636yqsxgfa8hg5syg4a1ka
X-Rspam-User: 
X-Rspamd-Queue-Id: D04ED20005
X-Rspamd-Server: rspam10
X-HE-Tag: 1762322904-477565
X-HE-Meta: U2FsdGVkX18U5qSSSaPIgnAsUL9R3BtKiSxvwnSsOi1OpsG5/mOXtSonKOLEnYxQZysXc2TgdvTi90tek9ajuhwkSEKCDLQMUJLD13wmnHYynp1Be+bY83IBUoPEjFQg7HBWTcUAXGrVbc5SfdX6IAHNZk0eRLcircfYVfOdlHBxnzBWqoUeGGPDh3plX+OYtZWnZkP2BYZ4De4RmEnMeUfdXni4ig8QJkjG6EOaFcNtscyfoCHp1WudIF7Xc3DBP9l+jogGCbDaz345ZR2+xubQq+wroAl7o9hr2kMYyWxExxqP7OoJoLxJ2dECcXMZm6ZYFxcdPhXhLNpl0OGPXYKcwCwQrTsjApPkUJFINFiqAJX17Rigf+1QJKIzvqf0cNsW14gbKJBGWPyvOigHc+ypuRG9FDKgRrxp474yZtnSpa/1wcHG6YaUDzy3/fzL+p38lxqbM3l3uYXszrcN+K70P3/vKcCx87FCZCrCetlXnAjcFD44JfmzLn6QBfHJlaXzzJRbDjFXBayvNsKwDuvIzYIeRkugVHJe/NULb1Ow+KbTplPFUWpJmxGGX+B4zz6434NEen/qGrHoMTIw3ZqN4QtkomXZKiDFmx+Xzot9FtkTgCTgPA3S/fPOU1RgyrfKe3okC6/JEvp3fT57whwiuj94yWyTejmXNmOv50xe4KnTsbxCOjoylQkS2QsSwVPx9EG9f2xR9WlTJDdQWSMUp82mhtZznfO2eFgpUcpLpVV0PQzEA618A6vz4zAePEAdJPtRP3F0NDEs4V2jFoDe/IdPygeZhUBHXYKQG60yYBJ40MzXl6Ke+X6Y0/+ZAdmb+2Rmd4uIZDw7ayCky4xlxs6Mg6VaRTEf8tEzUK/tgGdU+FLq3jCnVkmF6jl3KE+AecPXcqQ0h0gzlDbDeMXFKZBPFXh1sVVI12lxRkP4KMGht4qHu1OHr9nrocKArQa+RhStgTA9xNFkr8H
 q3/I3gku
 thJqgnfOiJRvENy81lc+ptU6q03UJcfZlq5HPgnt9zKRQIf9MQ+0XEGmTQp0D2Mq9N5IhRMNnTIaShIS013qGo/K7HKB7hUbVIYzr5kFeUh/KB48lDaN8dfgRoT3SMPkJzWmGuFKJl+9LFxTLhNF8LPNjLWMy2mcPoi1vjgzcQxsnFX2z8J+4jZRVtUwEWZY0Rg731DGLN/jDvLWGAY3FQMg/P4dIrlYalIAFsJmIXUlFmi6E6vEjtxCXr8gxP80SZ0jNakH4kVNVXwvTgl/bMN6h1NH0cO68ap0KHYNsgwY/GgJOevkyLBsYZfv/3SlgUj7ZX+owEgGkptYcnHcPIwUzV2sRj5DKxMog+9PZXA4iVkBVrz1QDOUL5lwrmPgbtw+hhjV0mBUdwvjUkkL1iCw1sQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 4, 2025 at 5:21=E2=80=AFPM Michal Hocko <mhocko@suse.com> wrote=
:
>
> On Tue 04-11-25 11:19:08, Leon Huang Fu wrote:
> > The current implementation uses a flush threshold calculated as
> > MEMCG_CHARGE_BATCH * num_online_cpus() for determining when to
> > aggregate per-CPU memory cgroup statistics. On systems with high core
> > counts, this threshold can become very large (e.g., 64 * 256 =3D 16,384
> > on a 256-core system), leading to stale statistics when userspace reads
> > memory.stat files.
> >
> > This is particularly problematic for monitoring and management tools
> > that rely on reasonably fresh statistics, as they may observe data that
> > is thousands of updates out of date.
> >
> > Introduce a new sysctl, vm.memcg_stats_flush_threshold, that allows
> > administrators to override the flush threshold specifically for
> > userspace reads of memory.stat. When set to 0 (default), the behavior
> > remains unchanged, using the automatic calculation. When set to a
> > non-zero value, userspace reads will use the custom threshold for more
> > frequent flushing.
>
> How are admins supposed to know how to tune this? Wouldn't it make more
> sense to allow explicit flushing on write to the file? That would allow
> admins to implement their preferred accuracy tuning by writing to the fil=
e
> when the precision is required.

Thank you for the feedback. Let me clarify the use case and design rational=
e.

The threshold approach is intended for scenarios where administrators want =
to
improve accuracy for existing monitoring tools on high core-count systems. =
On
such systems, the default threshold (MEMCG_CHARGE_BATCH * num_cpus) can rea=
ch
16K+ updates, causing monitoring dashboards to display stale data.

Regarding tunability: while the exact threshold value requires some
understanding, the principle is straightforward - lower values mean fresher
stats but higher overhead. Administrators can start conservatively (e.g.,
1/4 of the default: num_cpus * 16) and adjust based on observed overhead.

Your suggestion about allowing writes to memory.stat to trigger explicit
flushing is interesting. Comparing the two approaches:

- Threshold (this patch):
  - Administrator sets once system-wide via sysctl
  - Affects all memory.stat reads automatically
  - Tradeoff: harder to tune, always-on overhead

- Write-to-flush (your suggestion):
  - Tools write to memory.stat before reading: echo 1 > memory.stat
  - Per-cgroup, on-demand control
  - Tradeoff: requires tool modifications, but more precise control

Actually, your approach may be more elegant - tools pay the flush cost only
when they need accuracy, rather than imposing a system-wide policy. The
write-to-flush pattern is also more discoverable and self-documenting.

Let me try your approach in the next revision.

Thanks,
Leon

>
> --
> Michal Hocko
> SUSE Labs

