Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67336FD377E
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 18:19:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9ED7B6B0088; Wed, 25 Feb 2026 13:19:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C5776B0089; Wed, 25 Feb 2026 13:19:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89A0D6B008A; Wed, 25 Feb 2026 13:19:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 77B856B0088
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 13:19:28 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E651F13B88A
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 18:19:27 +0000 (UTC)
X-FDA: 84483791574.28.9B83341
Received: from mail-dl1-f67.google.com (mail-dl1-f67.google.com [74.125.82.67])
	by imf23.hostedemail.com (Postfix) with ESMTP id D364A140012
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 18:19:25 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=S6o7JSFw;
	spf=pass (imf23.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.82.67 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772043565;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fpua/5AqL7IvJ5rCFhonR5njdxMsCjSPzuEjD4KqeMY=;
	b=MhAy9/8bjslJHvE/R1d3LHwwpsZbMaOhVIfqKKAnzFWU5Dt653nFZmtGUZfSHLJKQcmZtB
	o++wCP5RIcRfDzMq5Lx5cd+b+meA5HnzJwA2jKB3AUFOG4Ynm4MNO5vYN9HyUwgtwvOKYz
	LYzA3khteDhyZypGjjU+thv8vG7Hppk=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=S6o7JSFw;
	spf=pass (imf23.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.82.67 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772043565; a=rsa-sha256;
	cv=pass;
	b=vMkUa+nzyNgtZQuctZI44SE42xixkd6to/tYuQYSgf9E0TZ/5ypuA/mUaiysJtXLej3xqW
	vyzjT64RqojiQMkb3atqJiGs23rjLvNIyKClf/cre7zBCm/Tt83f2NFk6h5hmzmryMgcO1
	WUjpfUzPUz7BPv0Bgx+ljIdqQcoV9Tc=
Received: by mail-dl1-f67.google.com with SMTP id a92af1059eb24-1270adc5121so8483845c88.0
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 10:19:25 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772043564; cv=none;
        d=google.com; s=arc-20240605;
        b=IW2T4pGHZRxY3Y2CWVZR7sxyyZio5b6NpW0YvX8eO4ruPZuPBGvBtvGeI3i9CzEkBc
         bvAdKRgnDe5cfBE+5zhO7+YkG9jrun3+4Qk5Ou3/OFm+PDhmQq8132SRUS63DmKfdTHt
         dc6ExIkkgPCxzQwYefRCuy/swfkKw6nzrYUDwYmmJYheg07MT5hcHRjB/7fAAQTKqFpG
         KwK4G8qlTJhPD+4FCo+uLAWf8fYieEM7FSMmGcPU2BOqExrhILbAwIyq3ZzllZdhM50Y
         iO3J6YGD3qSQGmbJsyFwLWRM9+UW+EXV1wUcYvNciRR/t9lXxMtdxUDTZVhii/NHsyav
         Ikjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=fpua/5AqL7IvJ5rCFhonR5njdxMsCjSPzuEjD4KqeMY=;
        fh=Q2LgqFw2k8Zk+q4vErnTFEGG1eYGvKfi8HPAN3+gU8k=;
        b=hy8HYcLXaMWfg88YPwVlMdnR548EuVcrO78JYBBy9ZsZAC40+vFD9BjBme9myNGMfD
         icQBDpQE3W2DrVL/0q3RaTL093ev+uXeLHKAPNybhDaE70tvIWspqAopQtT+0aDnv2Yl
         5VAfkJ1hJ4NPVxFzo/4stUpTOSq2x39dE+g2wVhzliMfV0Y/5CwAkmoSMQHtEtehJUxb
         Gy53y69uNCOk3kerVGqF7S4arsjLSyXfaz/TCjr6riFeCS7qnAZjhLVnJbrWnk53tfho
         JIX0fdzDAW6UUx3hI8uxm5ESm9yWNzQiXONzDrWgLfA53DXueWxH5Jen+z2WoAMXoNuk
         mqTg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772043564; x=1772648364; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fpua/5AqL7IvJ5rCFhonR5njdxMsCjSPzuEjD4KqeMY=;
        b=S6o7JSFwZpLLL4mxCV3XqjWf80zNBET0PAmuFmBkDiz/AXeNtG3RUOY9jetArBHcok
         t1BuQQHbvF/d5IGAbVJPhPZDCERdIclJzo6w+P9Y5B5yJigKSag3qssokk064XxTmJEX
         BVknTfYR82jPMjJBo06zsC+FjbwZttTha5AUB6ykQJ84inxt39Pem4cfXXC1CK6HfEg7
         tt5jfV1QN58GMiWkqgPB4/LKdjZF2fpbQ7qK3b3gJ0naiyD3K+Ci4Ezox3sSCfvR7+Xw
         n6UUTEabuTyhtSVVbZZUIHqGoQzeeGiTSl3eTqAKa7xZ4/aSR8FPMkJt315Q4K9SiEd6
         fygg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772043564; x=1772648364;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=fpua/5AqL7IvJ5rCFhonR5njdxMsCjSPzuEjD4KqeMY=;
        b=dXmgdaKvRvM8OxbDiBQAVjN8RzOpmw7WRfG3UmyBoSxdIGM/W9qQefe0Kz8hMgKp6A
         yoqUe87bMF4AJPkkbRcn13g/JIE6JZtWIhdoZboTOq/czKrIiji6gOW/0oe3Zaohkkht
         KA/ZBrhI5Br/AhLfOKdd+GP93iXH4H0caNEkookQMf9V9KYHWP5IhWVu9dGOolAzAiTZ
         vIZPpG/3a40exQ7qJD9rKiPuCyI5wbe95fNymBGmI/D9BlWNUg3I4X0O4IqOsP9znuJM
         V8VfUZM2wxtVwcfcYSznooDhwTCs62jmAlsMfQS7ovbvQDtyShtdWH/EmIgW+Nmqi5Df
         g2qQ==
X-Forwarded-Encrypted: i=1; AJvYcCWhFNHWwQd+vyftuZTDF0eVMLpLJVeGA7Ey9FpRsPXdWvVC7IN2FZ92SFgpcsxL4eD9QOHaX7qJVg==@kvack.org
X-Gm-Message-State: AOJu0Yx8W9Kwy0hsnqylyc5r1tFcl+1RAhy+FiYUo5lCCBUd7C+NSVTF
	kaqQXeTHfoRgeaXArVKoMqL6kiUUzN2VWUX6dYIXJ8mp/IPu/gSHa63ITpxp0pfchirO7DJTDup
	YMNpzmfpuL6TLPSKIbsolUSO4pD0DEw==
X-Gm-Gg: ATEYQzwKC3Uv2sLX/Hcn+lAAAE+YMavxnLlzdnRxE8xC83qkxoZtu7+kl38zlhHZM4R
	fK5e7pebWOvKgJbZLzA4WHb2xTPfgQQgxaIBIrdcM0+ss32jvkG1x7QInp0AEUc0fRVxQ09PEb2
	3cuT7FyatzjJc/fdKGQV0PFr7NBeE7ulzg56gpXBhd1uGYv301XwzxdftoQifjDr6cq1HY/dCjO
	ePdEHgixyXCCSKJ1dVr3SYF3Efc3n5fl4bRlumue+reFYpAzhsAsiK4d0fHnpKBTqSWy8N5Udms
	VZ9lyyg=
X-Received: by 2002:a05:7022:50c:b0:119:e56b:98a7 with SMTP id
 a92af1059eb24-1276acfb898mr8110234c88.14.1772043564405; Wed, 25 Feb 2026
 10:19:24 -0800 (PST)
MIME-Version: 1.0
References: <20260223123232.12851-1-ravis.opensrc@gmail.com> <20260224053633.58448-1-sj@kernel.org>
In-Reply-To: <20260224053633.58448-1-sj@kernel.org>
From: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
Date: Wed, 25 Feb 2026 10:19:11 -0800
X-Gm-Features: AaiRm53hBf4jh574PmxytdQQ-YYkGigD5nOoFyBC9KFKd9UXuxLJxrvhLrRMxwQ
Message-ID: <CALa+Y17HPOxpLF41+Jn-fHqu7s4YUzgsFKdhD9MsN=wCop_kRw@mail.gmail.com>
Subject: Re: [RFC PATCH v3 0/4] mm/damon: Introduce node_eligible_mem_bp and
 node_ineligible_mem_bp Quota Goal Metrics
To: SeongJae Park <sj@kernel.org>
Cc: damon@lists.linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, akpm@linux-foundation.org, corbet@lwn.net, 
	bijan311@gmail.com, ajayjoshi@micron.com, honggyu.kim@sk.com, 
	yunjeong.mun@sk.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D364A140012
X-Stat-Signature: wi758tft6ma4sb9nxqogxodwd7niduep
X-HE-Tag: 1772043565-456761
X-HE-Meta: U2FsdGVkX19K3lURgkgn/vDtvTpL13snicCvlYndWxGlMOXUjq3EH4V+Xyl6vST5kE7knwmMFSoS1GqklRV0kRITi3dUizH3lgtAfMyEqYtI0Cuqjz/c9nOrsOAVpCy1ma7RATQ5sYf30V68FILSNpkFYnTwaQ/bYXbEJ05z3HYQgW9M0z3nZWETPiDxKeaVAVob9NbOsN8IeKSIO4FzXy9uhaiCdmHj6cJ8jhK1U0SySVpPNAr6ss9u1fJknsRItjHR8UMurFtXzAuH39ADLevGrnsyLg/pULdndsrJzNA/+1uazKFM/7EiPK0HCY9K2riqLHqG0iy4DvAo35hM3bDPBXc102lN1+pWtIE/TY/XTy/4P8Ca1N11Q01lqWFVHHHiTPc2SqItzmvTW6WWnevoUG/cllruGBwJdceAa2URMIWlPO9o++N8MkFbHWFhOIiejLfMuiom6uWx6hwQhFNQC5WPi4e5Zu+FfiR8rAdADHrJCOQlgXGO94DkAZ3VI74nXNK2yrP0f79Yjor2sdZ5+jW7zkfQ2cNCwbTXtmbeRqms1PxoDOI02ly6kmQKs6rwVP/sjuT58CxFtq5FF2uPugQWmk8258mn/GrGLtyR3KXzJBOlDgwJ7Tu/7yrR1cBTWsZBRpvzY8dkTOI3ymIZu0myL8sNYh+no8FQlZAc2Ia9jkmNm5fraCC0IdD+By56fee2OOxnWxFKOTu951mB4N0zNYCsLTz6rmYz0ADgwe/bR9PTm+mowYCMoWqLZ68d+/QW3giJRnWemnMrsBSldJL+uNtdO+hVDATcnAQ+uVib3zsysPEGajrvm6uuYxipFocId/yrGevZp7vV/Z0p71RxhnQFqT4hBpNJLwb/PHlG5oTtgmiZrCK8t2d330mUPOFEvwYFwkJuOlRcyrtVC1pK+6dZDFtHEzT+Q/Hspdh1weBAjjF68GnQ5zUFQLiUYOdi+s8uQTQ+XCm
 +TEAOl9v
 GiLzO/0UtVwtjuP4KVPkaZyvX3UuRW7CmGrmYx+iuZ/1Wl/jNq+gcji3cQ8aXXJppBKvRtMvMO+vUJJ6/04FKSLbmIWSXJBkC4fPLf6NaXMei9k2I8S7xhO3fjpO/Chb0CFyu36x+/k9NAHQhT7rWlwYNtDV3NeAE/zP+HMxaLT8yWdd1rB241v5eDYFQ5SuK+dc39FSyWKl7ZlG55+G1Yep2xt0X84PtMm0JckfCRQlisA3FtAo8Ue54auSRXxV0VjViRfNhMccLXCpj2euttXKdb7YlIfgEgpvjOqCDdch3v+H5N8d8+M4YXeCuB+uZupOb0CFaKoMpwBZ6cnXyjOdQdhyR4gqnqkNS1fHbEjQEhFR0B0aVb1Ksk3rE7mzpAzMZPsl05Tm/J8dpcYwhYN1eWCeiEdbkbOH1TQa6b0jmG2r+fHzcGB5XuA2PJdK7Pja7Rx0UF3L3+seTaqZKsr1m48Lm4u5gJjIgjDZxn3pBnZZZrAN4zaaA4kDjOsfnOu1/sRfruzezZwz5JEzbxTpBahJH6hHvwpNIieSoqlfMLTx7N/olXaqZakJ6NZQdLGgp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 23, 2026 at 9:36=E2=80=AFPM SeongJae Park <sj@kernel.org> wrote=
:
>
> Hello Ravi,
>
> On Mon, 23 Feb 2026 12:32:28 +0000 Ravi Jonnalagadda <ravis.opensrc@gmail=
.com> wrote:
>
> > MIME-Version: 1.0
> > Content-Type: text/plain; charset=3DUTF-8
> > Content-Transfer-Encoding: 8bit
> >
> > This series introduces two new DAMON quota goal metrics for controlling
> > memory migration in heterogeneous memory systems (e.g., DRAM and CXL
> > memory tiering) using physical address (PA) mode monitoring.
>
> Thank you for keep working on and sharing this :)

Thank you for the detailed review!

>
> >
> > v2: https://lore.kernel.org/linux-mm/20260129215814.1618-1-ravis.opensr=
c@gmail.com/
> >
> > Changes since v2:
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >
> > - Split single metric into two complementary metrics:
> >   * node_eligible_mem_bp: hot memory present ON the specified node
> >   * node_ineligible_mem_bp: hot memory NOT on the specified node.
> >   This enables both PUSH and PULL schemes to work together.
>
> This perfectly aligns with the direction we agreed on the previous discus=
sion.
> Sounds good and reasonable to me.

Great, glad the approach makes sense.

>
> >
> > - Added PA-mode detection lag compensation cache (see dedicated section
> >   below for design details).
>
> I'm not very sure if this is really needed, though.  I'll leave comment o=
n the
> dedicated section below.

Understood. I consciously separated the cache implementation (patch 4)
from the core metrics (patch 3) because the cache is ONE possible approach =
to
handle detection lag - not necessarily THE approach. My goal was to share
what was needed to achieve equilibrium with my synthetic benchmark
workload (multiload),
while making it clear that the cache mechanism could be dropped or
replaced with alternatives.

>
> >
> > - Added fix for esz=3D0 quota bypass that allowed unlimited migration w=
hen
> >   goal was achieved.
> >
> > - Added fix for goal_tuner sysfs setting being ignored due to
> >   damon_new_scheme() always defaulting to CONSIST.
>
> Thank you for finding and fixing these issues in my previously shared RFC=
 patch
> series!  I left a few comments to the patches.  In short, the second fix =
looks
> good and I will add that to the next revision of my RFC patch series, if =
you
> don't mind.  For the first fix, I'd like to take more time on thinking mo=
re
> cleaner solution.

Sounds good. Please go ahead and incorporate the goal_tuner fix into
your series.
Happy to test whatever approach you come up with for the esz=3D0 issue.

>
> >
> > - Rebased on SJ's damon/next branch which includes the TEMPORAL goal
> >   tuner required for these metrics.
>
> Thank you for clarifying this!  This kind of context is very helpful at
> revidewing patches.
>
> >
> > Background and Motivation
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
> >
> > In heterogeneous memory systems, controlling hot memory distribution
> > across NUMA nodes is essential for performance optimization. This serie=
s
> > enables system wide hot page distribution with target-state goals like
> > "maintain 30% of hot memory on CXL" using PA-mode DAMON schemes.
> >
> > Two-Scheme Setup for Hot Page Distribution
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >
> > For maintaining 30% of hot memory on CXL (node 1):
> >
> >     PUSH scheme (DRAM->CXL): migrate_hot from node 0 -> node 1
> >       goal: node_eligible_mem_bp, nid=3D1, target=3D3000
> >       Activates when node 1 has less than 30% hot memory
> >
> >     PULL scheme (CXL->DRAM): migrate_hot from node 1 -> node 0
> >       goal: node_ineligible_mem_bp, nid=3D1, target=3D7000
> >       Activates when node 1 has more than 30% hot memory
> >
> > Both schemes use the TEMPORAL goal tuner which sets esz to maximum when
> > under goal and zero when achieved. Together they converge to equilibriu=
m
> > at the target distribution.
>
> When this kind of complementary setup is being used, in my opinion, CONSI=
ST
> tuner might be better, especially when the access pattern is dynamic.  Bu=
t it
> is up to user's choice.
>

That's a fair point. I chose TEMPORAL because I wanted to move the required
amount of pages as quickly as possible to reach equilibrium.
For my multiload benchmark with uniformly hot memory, this seemed like the
most direct approach to test the metrics.

> >
> > What These Metrics Do
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >
> > node_eligible_mem_bp measures:
> >     effective_hot_bytes_on_node / total_hot_bytes * 10000
> >
> > node_ineligible_mem_bp measures:
> >     (total_hot_bytes - effective_hot_bytes_on_node) / total_hot_bytes *=
 10000
> >
> > The metrics are complementary: eligible_bp + ineligible_bp =3D 10000 bp=
.
>
> All make sense to me, so far.
>
> >
> > PA-Mode Detection Lag and Cache Design
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >
> > In PA-mode, when pages are migrated:
> > 1. Source node detection drops immediately (pages are gone)
> > 2. Target node detection increases slowly (new addresses need sampling)
>
> I agree.  And this is not what I clearly expected during the previous
> discussion.  Thank you for sharing this issue.

I'm glad this observation is useful. It was something I discovered during
testing that wasn't obvious until I looked at the trace data closely.

>
> >
> > This asymmetry causes temporary underestimation of hot memory on the
> > target node. Without compensation, the system keeps migrating even afte=
r
> > reaching the goal.
>
> But, is this really significant?  I believe people may use complementary
> auto-tune setup especially when they expect dynamic access pattern.  In t=
he
> case, even if we can perfectly compensate this kind of gap, some of oscil=
lation
> will happen.  You also mentioned "eventual convergence" could be acceptab=
le.
>

This is a valid point. Real-world workloads with mixed hot/cold memory and
dynamic access patterns might behave differently from my synthetic benchmar=
k
where all memory is uniformly hot. The uniform-hot case is essentially a
worst-case scenario that forces continuous oscillation regardless of
detection lag compensation.

For my multiload workload without patch 4, there was significant unnecessar=
y
page movement due to the detection lag. However, as you note, that may be a=
n
artifact of the synthetic benchmark + TEMPORAL tuner combination rather tha=
n
a fundamental problem that affects all use cases.

> >
> > The cache addresses this by remembering how much was recently migrated.
> > When calculating effective hot memory:
> > - Source node: reduce detected amount by recent migrations out
> > - Target node: boost detected amount by recent migrations in
> >
> > The cache uses a rolling window to track migrations over time, and
> > expires after a configurable timeout (default 10s) when no migration
> > activity occurs. It also detects when its baseline becomes stale due
> > to new hot memory appearing in the workload.
>
> I will leave more comments to the patch implementing this.  But this seem=
s too
> much at the current stage, unless there are clear test results showing it=
s
> needs.  I'd recommend proceeding without this, and later revisit if the p=
roblem
> becomes clearly significant.

I agree. Let's drop patch 4 for now and focus on getting the core
metrics merged.
The cache mechanism can be revisited later if real-world usage shows
it's needed.

>
> >
> > Dependencies
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >
> > This series is based on SJ's damon/next branch which includes:
> >
> > - mm/damon/core: introduce damos_quota_goal_tuner [1]
> > - mm/damon/core: set quota-score histogram with core filters [2]
> > - mm/damon: always respect min_nr_regions from the beginning [3]
> > - mm/damon/core: disallow non-power of two min_region_sz [4]
> >
> > [1] https://lore.kernel.org/linux-mm/20260212062314.69961-1-sj@kernel.o=
rg/
> > [2] https://lore.kernel.org/linux-mm/20260131194145.66286-1-sj@kernel.o=
rg/
> > [3] https://lore.kernel.org/linux-mm/20260217000400.69056-1-sj@kernel.o=
rg/
> > [4] https://lore.kernel.org/linux-mm/20260214214124.87689-1-sj@kernel.o=
rg/
> >
> > Patch Organization
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >
> > 1. mm/damon/sysfs: set goal_tuner after scheme creation
> >     - Fixes goal_tuner initialization order in sysfs scheme creation
> >
> > 2. mm/damon: fix esz=3D0 quota bypass allowing unlimited migration
> >     - Ensures esz=3D0 stops migration rather than bypassing quota entir=
ely
> >
> > 3. mm/damon: add node_eligible_mem_bp and node_ineligible_mem_bp goal m=
etrics
> >     - Adds the two complementary metrics for hot memory distribution co=
ntrol
> >
> > 4. mm/damon: add PA-mode cache for eligible memory detection lag
> >     - Implements rolling window cache to compensate for PA-mode detecti=
on lag
> >     - Adds configurable cache timeout via sysfs
> >
> > Testing Status
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >
> > Functionally tested on a two-node heterogeneous memory system (DRAM + C=
XL)
> > with PUSH+PULL scheme configuration.
>
> Glad to hear the functionality is tested.  Looking forward to the next re=
sults!
>
> >
> > This is an RFC and feedback on the design is appreciated.
>
> I'm yet to further reply to the fourth patch, but I hope my comments be w=
orthy
> :)
>

Very much so! Your feedback has been invaluable in shaping this work. :-)

I'm currently on a break and will be back after March 10th. Once I return,
I'll send the updated patch 3 and share test results with CONSIST
tuner.

Thanks again for the thorough review!

Ravi
>
> Thanks,
> SJ
>
> [...]

