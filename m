Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80789C83F1A
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 18:27:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 182DE6B0088; Tue, 22 Jul 2025 14:27:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1329E6B009F; Tue, 22 Jul 2025 14:27:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 020D86B00A0; Tue, 22 Jul 2025 14:27:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E59536B0088
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 14:27:54 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6E610112C9F
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 18:27:54 +0000 (UTC)
X-FDA: 83692734468.24.B238826
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf19.hostedemail.com (Postfix) with ESMTP id 87A271A0005
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 18:27:52 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=tSy7+Q7z;
	spf=pass (imf19.hostedemail.com: domain of kuniyu@google.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=kuniyu@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753208872;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JJ06jcp3N8mk84kkZkPxLydB4nlpZWRtwPoY10l8wjU=;
	b=ghXn1tyrM/CBNs2Mt2EZedn5UqRMqM7shh3iHpUDd2IjTg8puVZdLaroo+OD2Z++le5e3S
	dNXsVQ6c4Lo15d9EF/vyv8N+9/q05o+Fw80ClP75OTEJQuTj3d7jQlFh3F37CoD5NgrCb9
	tk3B4Cuo6/SwGrXoOLAWz4y7uSfCzrw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753208872; a=rsa-sha256;
	cv=none;
	b=po5kH8qiO0+WgdNZQaWqSq5/9dIvcTIlEaghEloLbqs72X/Gd8bRkOC9zKziURPye77zWY
	Nvf4CEUvSUq2z4BLJlq3wwcprv6SrrqAWhoBPgrlxNqjt9bl8+3hYfVgISn3YHM5d4rYNy
	ppZ3GtANColUkRLx+355DPZe3exXY4I=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=tSy7+Q7z;
	spf=pass (imf19.hostedemail.com: domain of kuniyu@google.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=kuniyu@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-234c5b57557so52184215ad.3
        for <linux-mm@kvack.org>; Tue, 22 Jul 2025 11:27:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753208871; x=1753813671; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JJ06jcp3N8mk84kkZkPxLydB4nlpZWRtwPoY10l8wjU=;
        b=tSy7+Q7zobWWjrjzU+LovyCX9YZjJYMfY9Hh4ozpMXD5GVCsqfLlEzTRpCFLx62ogj
         PF4UhcTLEZZnjB6s4G30LYCY74pKm1JoM5mnIC/ypsv7HlHsmC72mKiZGp7QxYXiwxE7
         J6XmKVHwY6FGILoUwo0dk4R6fOC2t/D/4iZYA+0f+xbJUVc1wHYGlKav9UiZH58AFchU
         6LQh4gLY/5jEHvzgg0HePZV7SO+IrVLlLhbR2QSOS9YUFTBAhFseo1G3ncg0NAWETeWa
         pgUHbQFOUfOCYkB5SOdagwfaC6Gt3Un1iG8DmZ6NroE6Hxgaqyrn+04ACqnNqZryIcS7
         6vuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753208871; x=1753813671;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JJ06jcp3N8mk84kkZkPxLydB4nlpZWRtwPoY10l8wjU=;
        b=AYbQaNcCyV278q6Vw1wKWy1l52Upr2USLSSQU7qJljf0M5d3krqEoAx7S4+jU3oekl
         puhKY7JEo3q2Jh4w4J8+fKt+0qtjObKwkVC5aYWxJUnk4UqIIezoa60x3IFbY1WSM5Zh
         Dp5SdWPvJooxKZOMmV4mPfIO7yR02wAwrC7tDXl0ELmOZsUYDdTxRibHSuhVfJKukKzH
         lwsmE3/aiEljyii7TdVyobO41hVw2rsZy2ZIiVvQXdmO4Ea+fBbHD5b8U2v2EMdWE6c0
         +Hj4vy4kYHxECVwaslmRYVXZKGXkyr/PkFcJFSDNZA+R8+I0w1P9PVZqaNEwui4h9gXx
         xSNw==
X-Forwarded-Encrypted: i=1; AJvYcCWPRpxF7PgW+5RST24XosVUzBptazpdQ952iPhrLT03eu9UayB3d2En9doXj10fBtdzOs9fnpyY3g==@kvack.org
X-Gm-Message-State: AOJu0YxHmQF0pbx9Bj2OvSmpYtLC8Tk6oXWgZ3aE7RdoBl1AD/sgC9VI
	XXIMiZ7D5TUGbUrkS10s8jO5tXDYwdWVKU23Ps/e32MHqmtkflOoC02xH+B307rZgEWGeSylxmv
	gNL2Bv9OqkHfACf12NWcv1lKYIrCkJe32qVteK8ej
X-Gm-Gg: ASbGncuqjFy8V7RCTbroeNOBHEYtrUAwnLtM0ogjh/xe+fuHGaNT0yS4+9SXF2BQEh3
	J+1hmtB3cDXTdtVMI6IuNxZu6mdfXwZyE4B+PPaSN9sflRo/1wka1pNwvs9s0Mhm94ZsAz3u1td
	+7/zoOmkcwkKGotxR1XONddr76BDUs9XIiRy9CRa6GS1aJQRxIJq/lMERhPz6cWxvcGQGvM+40H
	fo2dAi36kU41I0taacRnWflL8KHPxFtif3O2Q==
X-Google-Smtp-Source: AGHT+IEsDSi8OkW3pGhx0kurDkEYKeTjeHF2pizFwIotQyNcJvMlToKfbMqC1EaLyBr5Mr/rFszOK4D2GukeMpu05bg=
X-Received: by 2002:a17:902:ebcb:b0:235:7c6:ebd2 with SMTP id
 d9443c01a7336-23e25730056mr376366275ad.31.1753208871268; Tue, 22 Jul 2025
 11:27:51 -0700 (PDT)
MIME-Version: 1.0
References: <20250722071146.48616-1-daniel.sedlak@cdn77.com>
 <ni4axiks6hvap3ixl6i23q7grjbki3akeea2xxzhdlkmrj5hpb@qt3vtmiayvpz> <telhuoj5bj5eskhicysxkblc4vr6qlcq3vx7pgi6p34g4zfwxw@6vm2r2hg3my4>
In-Reply-To: <telhuoj5bj5eskhicysxkblc4vr6qlcq3vx7pgi6p34g4zfwxw@6vm2r2hg3my4>
From: Kuniyuki Iwashima <kuniyu@google.com>
Date: Tue, 22 Jul 2025 11:27:39 -0700
X-Gm-Features: Ac12FXxLpxDEFMJ1OteDYmd2L-tyFGpDS0pkCtWi7bSCC4GD2tBgGIdi0vnLq7g
Message-ID: <CAAVpQUBwS3DFs9BENNNgkKFcMtc7tjZBA0PZ-EZ0WY+dCw8hrA@mail.gmail.com>
Subject: Re: [PATCH v3] memcg: expose socket memory pressure in a cgroup
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Daniel Sedlak <daniel.sedlak@cdn77.com>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Simon Horman <horms@kernel.org>, Jonathan Corbet <corbet@lwn.net>, Neal Cardwell <ncardwell@google.com>, 
	David Ahern <dsahern@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, linux-mm@kvack.org, netdev@vger.kernel.org, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	cgroups@vger.kernel.org, Matyas Hurtik <matyas.hurtik@cdn77.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 87A271A0005
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: 1p7iwn357ixd7b3o3s5r1ir33iaw1pxo
X-HE-Tag: 1753208872-400193
X-HE-Meta: U2FsdGVkX1+ZxY6AM8CydHcuNeU24yVYA2RQv8Y27rIY4NcYIsU0dTZwGR9uSitpJqXJYLMkxIL4rrHQ1JbMfMqUkzknaeDtzwrNaqNJxFY42Glw/JgTMHtsdtGdi1YnmGX+vE30K08WrB0e/9cL27buF0T/ZA2C3txOLvP/RspiOeuAGs0lHyYnXLI6LgcKekW5VJidVXDUnGohcyUVkJV51Zbi6Nq3vwXP1PK1ERYevDS9cv0eDmqG+gNA6DJCYTkhIOuWiLy9+bOyoxZYbE6RGI9kA1FY5GXLF2SOnlf275PI6Wj8svzsFO/oklKkabTrg925cde1AAHXbNAOBQIGeHo4kUApHaoax6pSY0TrYUutC8DKGCs1ysnTOM42xoQJC1msWxN8GCMComtEid2tQY2QcMkvmUb1BI2DjGm0Ru+eCYoF398dDMycfBU8VLi9oVvVwH78rDA+sfNWiAxUjkAdLjEZu/3ZDqLMVcdPObmNcURoKe/iPRBgpi6Df5XXkSfRAs37B2zjJByF1ozn4Jsc4/jFYUvl2UEJ/9L35wlwqOg38u/MJ7gVgFCBn5pVKs+mfLEpupUM6BA137vKUmgDH1dFGbSavV1b9qdY5vMCVUxo4VIJtyyV7fxN1spsxUoTlhFaUQul/QhN6H/CHsD8IdYP2o4GlLYH165yLPXMsRZLBGZI+KL4TFFOJDGZLZ9LqjO1R8R2gQXu5yJSdDH19Vt3/gOywvg3LqjJzLx00BmPMkk6qauVYpyMgW0S0RA7NStOamhK9XJqIorYRrNQAZPNUU0fRZZA76823FPe8K+QprUDnruhrN5us0WRuq1p4Xyg/uDaFA7X70mZtp75wzrIIpe8ecsE0Quw7xXg4Zo1JDE+pzkOq6CiadVEtKOhlFJgR117laQ6bifH3Xy1nd8D8KEV+CGX0mY5CGGw43sjGg9d/kD9r/pAtzLHOsS6nPtIUDNkgcO
 M/+qzMxQ
 Ttl7QEMWig73j6G63Hp9ek3eTkgwxNgxSel9rSJNNha9/cz3h9A01qSLxDE64ck65brvgiFw+suQKgjFGxb44HKgD3SI5g/IjixF9/sXv2RY6D9BWnp5IBG3VWxpQcd9Fui2/oLaGD1EJvubLum0aB8ntAU9hWYnrAOzJZyrNIiMpVS10eFLmRRVJHFsUay8ymLVi6/aTLCwCaeHfqhC20xv6ln/0xdMW/Gn9QeDJPPIcZLNXFtLT11hCClkgjmBZ8dENM0FXDKXNb4jokSYKGgYse1oVmd4W/bB6ftIKPUYr3S0ovkRMi5xKTi/zA6CoCb5U
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 22, 2025 at 10:50=E2=80=AFAM Shakeel Butt <shakeel.butt@linux.d=
ev> wrote:
>
> On Tue, Jul 22, 2025 at 10:57:31AM +0200, Michal Koutn=C3=BD wrote:
> > Hello Daniel.
> >
> > On Tue, Jul 22, 2025 at 09:11:46AM +0200, Daniel Sedlak <daniel.sedlak@=
cdn77.com> wrote:
> > >   /sys/fs/cgroup/**/<cgroup name>/memory.net.socket_pressure
> > >
> > > The output value is an integer matching the internal semantics of the
> > > struct mem_cgroup for socket_pressure. It is a periodic re-arm clock,
> > > representing the end of the said socket memory pressure, and once the
> > > clock is re-armed it is set to jiffies + HZ.
> >
> > I don't find it ideal to expose this value in its raw form that is
> > rather an implementation detail.
> >
> > IIUC, the information is possibly valid only during one jiffy interval.
> > How would be the userspace consuming this?
> >
> > I'd consider exposing this as a cummulative counter in memory.stat for
> > simplicity (or possibly cummulative time spent in the pressure
> > condition).
> >
> > Shakeel, how useful is this vmpressure per-cgroup tracking nowadays? I
> > thought it's kind of legacy.
>
>
> Yes vmpressure is legacy and we should not expose raw underlying number
> to the userspace. How about just 0 or 1 and use
> mem_cgroup_under_socket_pressure() underlying? In future if we change
> the underlying implementation, the output of this interface should be
> consistent.

But this is available only for 1 second, and it will not be useful
except for live debugging ?

