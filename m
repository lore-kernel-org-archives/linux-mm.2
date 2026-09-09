Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F7CFC79FAD
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 10:09:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D7F76B009E; Wed,  9 Sep 2026 06:09:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 888A16B00A1; Wed,  9 Sep 2026 06:09:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 79F796B00A2; Wed,  9 Sep 2026 06:09:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 528C86B009E
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 06:09:06 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9BB4C120148
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 10:09:05 +0000 (UTC)
X-FDA: 85193800650.29.F823617
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	by imf18.hostedemail.com (Postfix) with ESMTP id C2E481C0002
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 10:09:03 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JzKBxWSd;
	spf=pass (imf18.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788948543;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Cspt3kRXGk/I1h0yuaYP6XGwO6IhBwUrx4BknaruqsY=;
	b=UUzpjtBRoIPOCBmJQaAiuO5CwzTPoHd0D7oYZeUE3qtx7VUtynpuilCW+sFCGdGWy8UtRr
	Bu0j52n5Xaw0DAaGBq5YkejYaCgIruCuCUz4mmAIvfJhITw3SFNPhqJjE2VsAzNPOG18/u
	S7E64ZCii4LtB9BoPMZnXfROxiD1sn0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788948543;
	b=GnSOyh1I1WWsxt/S4wwbPkZC7OkM9Buo/ErEoWAa1lcSHr61P5PeAvj40AjK9zKa9q6qVk
	vw5sgrlxNoGJvqNv3r0uYnhn0JEs2dJQyIUNjutwhRiQ2Jk9NcBTtJCwlMDGmFLw9oqBHS
	tQxut3mDdHnFjRR5YvXoRicSuTjMFZk=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JzKBxWSd;
	spf=pass (imf18.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-851cbd64814so2910480b3a.1
        for <linux-mm@kvack.org>; Wed, 09 Sep 2026 03:09:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788948542; x=1789553342; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Cspt3kRXGk/I1h0yuaYP6XGwO6IhBwUrx4BknaruqsY=;
        b=JzKBxWSd7Vejqk39qpvYiYgczm8ct8d3qZF8K0ffk+fJNhEro1wtkMVZdYsRHRvks7
         vmPg5LmV3Nkij718yuQlquGY/ByKkRCatE07pnSC4Hyp1bJw3kPGF7SDC9bPMfFV3UrS
         xeu6MmK5pFQ4+DfbwKDNr2ML2I94RQPNf9sL4hBJawQkBfYeqK/lQAwpIKVbLRKwLJP5
         GVa6UD+EcZtgd/exyE82skQbiSDtMXZVSeE9dxYatUVfQk1HtwBjRduzyc6o87RPQRTY
         3NrjSUrEYPWvAQk/hf6KOc/fyG4Rq4tRIBDgw8z8//cqZWrgu3pd7J+0bgmrjuX+wiUz
         RL4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788948542; x=1789553342;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Cspt3kRXGk/I1h0yuaYP6XGwO6IhBwUrx4BknaruqsY=;
        b=PQUFwAlMPb7MlB2bloMQeI+U191gB3fQ5Arz0pRT4qtDa+/LOo5CQYLHp+45Nxq4AK
         q+Od6Nc56Hk5MXvTJqO5KU9Ctb10UkJhKyArVE/wrS1bVI59iiWbvVaVwUEFOVTlDGxI
         Vc8rJI721avR3YoqRKiTOmL39309mqWfxFtvcAauBs/vwyFPknuo8k3xjip5iqWb3XBq
         mmEtWBQuZChRxTzV/JFY/CgA8vfVpi91TeuWsLgOXBhTOzpB/PqoKBW0wx2kFisCoyhe
         Gn+N/9B3Rgn77efb1CEV5eoRPZsThajbRG5nFknWO2C7yvCo/OlF7030PXmzoms6VpzL
         OyrA==
X-Forwarded-Encrypted: i=1; AKwUvByUUZRfmzf7ktael1Z7yRVFFxrFlWnh9rRlC2Ln1ZvGcJ+iEd9++qM4WDyUcT2wvArYyGtGwPp7Tw==@kvack.org
X-Gm-Message-State: AFuF++m4qsUODOqoL8B8wDzBy34JUjpcrrWHpZwCCrwYhlZqIt56oFJU
	KRyCMyAlwuZGDrkpp8v/bEfR0Eantwkt0fNE4ZRjX9zwKPfwe8fl8Pbx
X-Gm-Gg: AYBFou0F+T6HrWopSNY9saOVn7ZeNkhoNpHIuEjswlSV/CffKEcMTh76KalzyJA06Z3
	OjhqJ0M53gmkQiLjm04QcBHMHkzfBcCp54/LwvKeFtUdax4CmaHVKy7ETtBVusomSLRevwvy1eP
	Cdu5CoBqwvLyeYZ6kEGUXsT34xfYIXcW/vN9yawvsKzX03Z1lUID+mxOyE0vJdwychTfIgwAajB
	O0S9+GZzONko8Cl3t8J+pZVSQVah6Q0Pe2eXPqSQMCqhlPbRtrVLMvWEIG/uEIuzl7rQrp4Ft2q
	g4PKusCGap9zsgBAlLPPWlIoqozo/rnfEz4niZk+2fpJRbYDDTzsbnlK2FaMaNv08pjuAIkUNix
	/kEO3Nwl6Xu11UQsscqcr+TLVXTIOhB6UaGAGzQLICeqwzjJCj3scptukooJHsNwygyhSCRMDIb
	NwvS+Wp1D8/Osb+NIs3yQWK5EpZRVC15hI2kaUnGVY16D71Tgp1CH5JCHvGJ3bEPdonqA5z1lpr
	O3nNwmidnD9FeU=
X-Received: by 2002:a05:6a00:2d91:b0:846:8b22:4933 with SMTP id d2e1a72fcca58-8616bd5c57amr45991902b3a.17.1788948542332;
        Wed, 09 Sep 2026 03:09:02 -0700 (PDT)
Received: from celestia ([2402:1980:885b:4183:b098:c1b9:7033:be8a])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-86152c2a52asm6745792b3a.30.2026.09.09.03.08.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2026 03:09:01 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: sj@kernel.org
Cc: aethernet65535@gmail.com,
	akpm@linux-foundation.org,
	corbet@lwn.net,
	damon@lists.linux.dev,
	david@kernel.org,
	liam@infradead.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	mhocko@suse.com,
	rdunlap@infradead.org,
	rppt@kernel.org,
	skhan@linuxfoundation.org,
	surenb@google.com,
	vbabka@kernel.org
Subject: Re: [RFC PATCH] Docs/mm/damon/design: clarify when qt_exceeds increases
Date: Wed,  9 Sep 2026 18:07:33 +0800
Message-ID: <20260909100913.30568-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909003800.112569-1-sj@kernel.org>
References: <20260909003800.112569-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C2E481C0002
X-Stat-Signature: jmemjwa6b4bz4n81qi9zrqgef3ddx7ky
X-Rspam-User: 
X-HE-Tag: 1788948543-294883
X-HE-Meta: U2FsdGVkX1/Gaiw6g5nJPGjSJUDxH+lmlFUulCK+Vxs4u5dtu/vcOK12g03OHV7Zf2uqwSbTICGp9sPV2pI1zgY+QBoiopGkdHj296Ji6MyOQoQFbOZ/hgxeBHl/2VouD0Ez6tIkHXdmorNohgf4lzgTs/5iJ17pDnLG/P6WrOK0XBab/ENbwNsaxD8tf5MZ+Rz7q1nw3Lc7gsumtauLeuT5qRdkpcgzjewnzEiOQbSpFnv+8rkTgZaa+7EtXVpOX35bRoT4R7jaOfHTNQOp+tFXAzPb7nciIUZZO1QAsB91+Ox01neGI16vm8QpqDHmAten2EX6mlKPVDRANcS+mabh/+kW0HX/yNF8qOZQ7sIL79pdX1GR6F1OxVQBbXh/sutBmJptO9R8ppDvDfynPC6ffQhl8s433UCd4h9B0Zbs2LdD3U/s3BbA5IWj+JYfOQ9I6Py9LlSclkGE+YVpoh19o/yHbsEM8Ll6IvHgvLAXwCGekMTlH6ffEQAF68HAZp0nxPThMDYWKZtX6x0JkLbXdQJNUA86BL4PuUedml7UJDa+eEjnp9SNUzfRagBjEvR5aDZji3daEZbCjE9p3LAMzHcZFErpbyf4qhhDr4xJnUGXppvnXaHmxEJnuRvgMmyb9GA9x1QPDBUN5ps2ynO4Ba4xtFO6FprRxf+3F2H5aVOqhvQEJclT02GUDLyftwIJ35RfTeQkC/nugUiODCQc94/jnOxSOtPWIro7Xi89xaHkd6zrcOB5gQqqWfBQjeNkoVbn5YhQ2upJ2U3s3FPhcEJtSwwCMbRMdbo+X7iWdrYL/iFV7sWo4rzgdWNY1cH066eMssR0tDlbvsjGAse+UfRk7w7zXHiGfagvTAtZ+/W1uIKU2HhmHyoXD8W7XOLezOHGu6t4N3wJBUxCot72EvtP+u+6WMh7WVuW5l7la+OR+9ntwqdm7Opq9r9PyW7SkLNSi0hpU4wUk+u
 PBlrjlBk
 xNi5uXZyWpGkWkgsz9O45Q4OauQTb6CaVBmftHgJ6pUsXzOczP0oEmeiYVTReQmaZMm4TnBKnqXZl86uYzn3b52QUiuEqMA8xJCenEjAj8F/JQEesa7vPE6NYUCGobdGR81LCKkqv/qRjtgCF503NKegFh7w7/Q56sgwZCifYuo7V8pKT4qpPUugT/ScM7D6pAi/LXG8OZFbXAF2PP2oLVV6gEwcfnOCrczc3tcA0jiOAHaQ1q/MPsp8GeMVG/Ez2DlvHw5TZuNpackUrYYgKNOpX4cpoaTigY47kOBDPZlUc72gCBO2ffb2BRZNVXOD40S1YB77PwKwwcwp7d5F1b80BZcD4mxtijQuSWZqoC9XwFSkW8bfFXyhDDCptGH0XHeMtYKs6omGhX+Tez/2iEFreWBlgjhQ6cT/XqT6mwBlQWMNSIqETl5k6XQs+Mn4tej4Av6e3ipjThQLaRKI09TeRgFbVQeBwkPBH+iCDiUkj5sZ0t9duJi4J0IODeDiz5FOzWBshmG+BBV4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 08 Sep 2026 17:38:00 -0700 SJ Park <sj@kernel.org> wrote:

> Hi Liew,
> 
> On Wed,  9 Sep 2026 01:50:23 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:
> 
> > qt_exceeds counts how many times the quota of a scheme has exceeded.
> > 
> > The value can confuse users when the effective size quota is zero,
> > because a zero effective size quota does not always mean the quotas are
> > unset.
> > 
> > If the quotas are unset, that is, both ms and bytes are zero and no
> > quota goal is set, qt_exceeds never increases.  But if the user uses
> > the temporal auto-tuning algorithm, the effective size quota becomes
> > zero once the goal is [over-]achieved.  In that case the quotas are
> > still set, so qt_exceeds keeps increasing once per quota reset
> > interval while the goal stays achieved.
> > 
> > Clarify this on the design document.
> 
> Thank you for keep working on this with patience.
> 
> > 
> > Signed-off-by: Liew Rui Yan <aethernet65535@gmail.com>
> > ---
> > 
> > By the way, I found a thing in the design document that confused me.
> > 
> >     temporal: More straightforward algorithm. Tries to achieve the goal
> >     as fast as possible, using maximum allowed quota, but only for a
> >     temporal short time. ---> When the quota is under-achieved, this
> >     algorithm keeps tuning quota to a maximum allowed one. Once the
> >     quota is [over]-achieved <---, this sets the quota zero. Useful for
> >     deterministic control required environments.
> > 
> > I'm not sure if "goal" was accidentally written as "quota" here.  Would
> > this be better?
> > 
> >     When the goal is under-achieved, this algorithm keeps tuning quota
> >     to a maximum allowed one. Once the goal is [over-]achieved, [...]
> 
> Good eyes!  Yes, seems it was only mistakenly written in the way.  Please feel
> free to send a separate patch or include it into the next version of this
> patch, whatever better for you.

I will send a separate patch.

> 
> > 
> > ---
> >  Documentation/mm/damon/design.rst | 10 ++++++++++
> >  1 file changed, 10 insertions(+)
> > 
> > diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
> > index d036340dae8a..e083b74d618b 100644
> > --- a/Documentation/mm/damon/design.rst
> > +++ b/Documentation/mm/damon/design.rst
> > @@ -863,6 +863,16 @@ scheme's execution.
> >    completely tried to be applied.
> >  - ``max_nr_snapshots``: Upper limit of ``nr_snapshots``.
> >  
> > +``qt_exceeds`` is increased for schemes with set quotas when the quota is found
> > +full at a quota reset interval boundary.  While the quotas are unset,
> > +``qt_exceeds`` never increased.  However, a zero effective size quota does not
> > +always mean the quotas are unset, if the ``temporal`` :ref:`auto-tuning
> > +algorithm <damon_design_damos_quotas_auto_tuning>` is used, the effective size
> > +quota is set to zero once the goal is [over-]achieved.  Since a set quota of
> > +zero effective size is always considered full, ``qt_exceeds`` keeps being
> > +increased once per quota reset interval in that case, until the goal is
> > +under-achieved again.
> > +
> >  "A scheme is tried to be applied to a region" means DAMOS core logic determined
> >  the region is eligible to apply the scheme's :ref:`action
> >  <damon_design_damos_action>`.  The :ref:`access pattern
> 
> I think the clarification is better to be added to the 'temporal' quota tuner,
> since this happens only when it is used.  Maybe the clarification could also be
> shorter.  For example,
> 
> '''
> --- a/Documentation/mm/damon/design.rst
> +++ b/Documentation/mm/damon/design.rst
> @@ -775,7 +775,9 @@ There are two such tuning algorithms that users can select as they need.
>    fast as possible, using maximum allowed quota, but only for a temporal short
>    time.  When the quota is under-achieved, this algorithm keeps tuning quota to
>    a maximum allowed one.  Once the quota is [over]-achieved, this sets the
> -  quota zero.  Useful for deterministic control required environments.
> +  quota zero.  Useful for deterministic control required environments.  Note
> +  that the zero quota is a valid quota, and therefore ``qt_exceeds`` :ref:`stat
> +  <damon_design_damos_stat>` will keep increasing in the case.
> 
>  The goal can be specified with five parameters, namely ``target_metric``,
>  ``target_value``, ``current_value``, ``nid`` and ``path``.  The auto-tuning
> '''
> 
> What do you think, Liew?

I agree that would be better.  Although users might look up the
definition of qt_exceeds first, they are also likely to navigate
directly to the temporal section.

I will clarify at the temporal section in the next revision.

Best regards,
Rui Yan

