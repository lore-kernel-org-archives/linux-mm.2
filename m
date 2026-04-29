Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7C83CCFA13
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 20:01:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 23E796B0005; Wed, 29 Apr 2026 16:01:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C9DD6B0088; Wed, 29 Apr 2026 16:01:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 068C96B008A; Wed, 29 Apr 2026 16:01:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E0B536B0005
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 16:01:39 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6852B140198
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 20:01:39 +0000 (UTC)
X-FDA: 84712663518.27.F97984C
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	by imf22.hostedemail.com (Postfix) with ESMTP id 62C5EC0012
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 20:01:37 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="EBpSnO/O";
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf22.hostedemail.com: domain of surenb@google.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777492897; a=rsa-sha256;
	cv=pass;
	b=rI6ccg7ZGO2zyzwjvYzx8ZNBrbdIWk5xA+J9YFQV2tY3olC0k52GuBxQuR6D5xNJEyBYS+
	jng1HM4kGnAPQuyLM2DKcFGcgEmp7TMy1PMW72gQLMcve6r9A70ZtljqDOC0GoYL2GUv3t
	cGX2xoQJcK36HV2YSoj/5RcTNrPkwsE=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="EBpSnO/O";
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf22.hostedemail.com: domain of surenb@google.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777492897;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VrOQ5IvMm/7ol/RYFa/eoVS5wWzM8D3GvmLp87Y+8Zs=;
	b=scyOsHhf7Bb1Ee65teE5V4Y++/ih0E9ZvhlUyM92+d7JnSI1+m4AuzpY/9XGHaCotvM+gL
	SIn8HMbPhl/REcDufApj1LPU26bm5PmKtTImJVsQiNJZKZMKmMW7owlKiKY8dnH1WD/fY9
	2trU4PEtqbHxeOrDSE7uPm0CiZWckEY=
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-50d836552daso125101cf.0
        for <linux-mm@kvack.org>; Wed, 29 Apr 2026 13:01:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777492896; cv=none;
        d=google.com; s=arc-20240605;
        b=Ee5aL6ESJvtyEUoDagbLTjaMbxhNEmc0QLoPxRq/6VcYJYX9i2f9wxgDG3LjZ6vKDV
         CmesbOotS0y1rnrzmBXFan3WSiAbW3KdWkHmoakqDKsfUAGrIDj6Rni0feag+BM7PU28
         Uk5IZtmnGT5GWRFW56ZadwXewkblIQCPbLv+Uf4sHa7TAXVyIXlIVNQ7TSFljo/wAbLP
         GT0XB6qW1pwLEam21EqpbzWZzIdLbA7MNwGWSdHw1iJ/tbGwmiwuLr21X4gDm8Aygt1Q
         6WF5op+tyX0/+1L+rJf808XrIyqA0dGOkfRDWnW3wW/oxFMIjOx15VspuQbQWs98VNzH
         Fv+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=VrOQ5IvMm/7ol/RYFa/eoVS5wWzM8D3GvmLp87Y+8Zs=;
        fh=o+AaJMeiniSxjY2o+Pbs8i8n+0q2OzJ+hlqjZb01RLc=;
        b=IJCuo4wFjTjpTTreETiTBL2FopG8PQHNC8hoiEVFimyjQ2jxeEGINqwZ5RMmtX7BgM
         AzSCcBQZnronfyrMPV3thFixJM7YdKD5yEzMq7+u1Oi0813qvJQchlyzrT1C23EjYYyK
         PP1nD4jFZ9DJ6SHHNncWvE7W1JApSwqirgImE0mL5WljQSOpIMS1FGTax6CZLmlEQiYs
         iTmGTILUF8fb2emjZigNQnln2E4lFcgqCb4dZFtHrtkRpj9Rzi7u43XuP12UaShBNfcQ
         vp3tfSmWqRqQ2NR/h0CFA9ygUAHb5TuXy0veLTGYB+j2M1irG49czzxhBEOn1G/eCu8j
         JJRg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777492896; x=1778097696; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VrOQ5IvMm/7ol/RYFa/eoVS5wWzM8D3GvmLp87Y+8Zs=;
        b=EBpSnO/O25pysvQ9yQiRJz1VZ4+qzjuEOfa/ykZDBmReSqkRs/ZCBboM/d/M+9JOaK
         Dmf/FtkuM1yyMDBxGUZoHR9Qh92tRU9nZwjOfc1HgyD42Bj1H2ag9jVIM5jAVfEKVxsp
         JXFXFUUlqYbsAHVoDgcJgSPq9HwZwOWk1mYo05Awas9EVV/GZVhR6p7YCeRgbDObBGNl
         fVASvImkpudvRA5P9iIrfe7bhIX3X1LU3JhwQYcT0xQmOI4SNXapbO5ADNvcxGUl6Z1v
         H5/l30GB2v9Rpj/loA6y+kB7dmMwykWW79LVeYygj0TXx4N4QTZp9i3kXUXrKd5FCNvw
         px6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777492896; x=1778097696;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=VrOQ5IvMm/7ol/RYFa/eoVS5wWzM8D3GvmLp87Y+8Zs=;
        b=Y8/J776VCMNTmEEsJi0q2iAbO++9xBEC9sKFLIWym7qV/ZcPdsUvoUjoS8RAI6nh6j
         tWglPccSYQw1U0/cyuiipWVcGEzes3bEc3pqZyuA+A5Da0D5XX8ckHWWg6VoeOgYx8/5
         VHj2wCRiGow5RlC5cm8tNRwpHvXmdKEzgP9qeTSSUL8rdwhQrNRDMkGzZRKD+KVgqXtW
         Ss2bU0MmvARwKUtysi4gwHPJVuRA4h8ZQf5tl8aG7kwlzwnH1AzRA2pebEDGzVB3iJVH
         DMoArOnbtZkjzmv64RBUI/FvGKiUCaJeQQc/ZmzYx7auqvxDovG1zCeX42gwYfjyUnSr
         VIjA==
X-Forwarded-Encrypted: i=1; AFNElJ/YD1f+xv2zjKFZhbS7jV9Yt7Z1B8hGKWLkq6VClCy/u7l9p9L9DIV0f9J8uHkLALgxD1L7fcq1/Q==@kvack.org
X-Gm-Message-State: AOJu0YzfWLcIUDIYZqpq+hZLiUqZU1JdqABlz5N5zsUKJPJH1WCM2PR0
	PhVaWRLZlxistqnev5RG3JRLLSOatHRVCYTlf7Zl0ZEBgcIDy0sk1NAm4aQGzTcct053hjsinaK
	tqt7tLDaKnIy/9bWIQa78llFBU+Kw9suXUgdSICcTMW7feygsopJn9UkE
X-Gm-Gg: AeBDiet9P7/C0tPTzs1riSCW5BS4vRV5dbYxt9DhdMrednUWfdK4Xvxeq30PszARpli
	zSrHEg3h1lONMA/LEiNULcgr06eD0EFX7ibbMb4w8K8dVnSyljT+HdA6s5S8oy8QpiCRseZAiCq
	xfXFtvzMwE+ECTjcK8kIGbBjL7Wg1B462vL1ReX0iVOdV2zImTzxo+wxMMcDv424qYPRz9iBv9h
	dpZDOkQPUrz3TN8gcCBQ4qTRaRLdew5Tg+3Z3fy1fi4YGNpVrXsznc9hIbGX+lNmfZlnfpQypV9
	+vUeB6nDq5DqVoTX+l+7nrDI10A3QHN9wIDXPNEtwlYZamQg4jKSnK7ymdM=
X-Received: by 2002:a05:622a:8c14:b0:50e:5eba:cadd with SMTP id
 d75a77b69052e-51027e357d9mr3118471cf.2.1777492895598; Wed, 29 Apr 2026
 13:01:35 -0700 (PDT)
MIME-Version: 1.0
References: <20260421230239.172582-1-minchan@kernel.org> <20260421230239.172582-4-minchan@kernel.org>
 <aesiYAumkLCyedf0@tiehlicka> <aevzbx_Pk5Cu5exa@google.com>
 <ae8KD_Tq0t7RvUy1@tiehlicka> <ae_dRZ95dCDTTxaQ@google.com>
 <afBbRUaGnE8WZIkY@tiehlicka> <afE2xchFRh2xARBn@google.com> <afHAi0E11D5sg_9y@tiehlicka>
In-Reply-To: <afHAi0E11D5sg_9y@tiehlicka>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 29 Apr 2026 13:01:21 -0700
X-Gm-Features: AVHnY4LMZ-82kW3kGAJM8IvAKr1aRLzXrcRnIEAnRwPkwO2cxXsJngduRgWjvXs
Message-ID: <CAJuCfpFxtbSXKabKd0G1i4WXWs2M4c4aDs4xTA0BNJB2e0P7Lw@mail.gmail.com>
Subject: Re: [PATCH v1 3/3] mm: process_mrelease: introduce
 PROCESS_MRELEASE_REAP_KILL flag
To: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan@kernel.org>, akpm@linux-foundation.org, hca@linux.ibm.com, 
	linux-s390@vger.kernel.org, david@kernel.org, brauner@kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, timmurray@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 8d4m1xy51acx3gwbj1ehkw581dsxm5h7
X-Rspam-User: 
X-Rspamd-Queue-Id: 62C5EC0012
X-Rspamd-Server: rspam07
X-HE-Tag: 1777492897-950332
X-HE-Meta: U2FsdGVkX1+1YVovXw7ymtxAXbRhN2RJIbMOaCsrxgf7koEk/wqmYRm9rmL+Q87MjrvLqS9G0Mk+35JgVL/HA3hArsD1NFLL2axN52qSopSRHDnv8ayEKK66+QgFiG/7D/VQ2DFirbRpYePoX09rsCHiCHKerjxUxzwwiVPosbEaz5KmKrWYmqeXI5f0lVF8U9908P+3tOy8s9Nj2QNKqzrFIMtMsz3w3/uFlt6hZMoAGPdKKLKR0nBTqlxqDT24hWv3hKHo8SDuJEQgBQRydahrJoGEJLtbi41ngQztX+TiQmT9qy1PRcxlc4GQWKY50nPNI3bk10SUVMAGFB2iF4Q+ntNR7h3fcBO1hYeQoq9FHtmFbfOsx/qB/qQzsmvNaGWZKydEkO4NvHzLkgpnmaSjLJS9jYtykRzj6h5jrnMYYP9fIIn/uZ+H5LrnRx9bGHcI2cSZRnUrQjHAuaB9FLDiGvf1Z64nyRyWWK1NKycHbourNT+hgbRi7loWBQq74IhNJXawdHlB2ZEmKIDND93Y0Iancortdyfr2YsAWZqPgFI3BFXZB+SGaYr//ZCmHIJ5LWLeXsIXnVaSMdET5hQhumPypRFquaHcy5gBqamg8Dr9/FClGNQ1LGicXGs22QyXq9tcfwvUy1q8qBkoD0Dz5HgDfX2LRnAiA2Aa0ZgUnIaVBfEZ9d5KijtWyfuUkmH3Euyrfehk1Ynmn7Hhj+Lx1ZVE+/E/ZSMm6XnJiLT3wcHvvVxH4n5MBRgyc5BBVyhyMCV6MbnKgf76S9B4szN6NASAMwkJG4rhwPgdWbRnxiZyuCUOrkmGFFa+1KVZymSOntLPg9Dpsu973t3SAMXRG4HoEH7Wf+uWrbZfFpy3WqSIYKEkNaGao15Se1fFKvJw+IYcVsqvwg8LgU1jRzkdT/lY8PLeIMd0JyM4pdMayiqKeC55TZpkcXTqeueQXbjxA8phWwmvQ0AnI/b
 C72hcmkC
 93Q+fGrFFdFyUfxlCavxShPrnTILh8LAiI9mMe/HMqf9m1sz4GprDOv53CRWD4w2udGxuFHuR3XzVFhC1+9tzblsccqSrHz5dTGbj8NQvqcHSuzB8B2RZz8vtATo9SA2O8BNd7XPpv7Bn2Au30QB+xgnGpUf0PYqiSENQksJpzvRLVom/i0Ts14ThiLwUTV6NgAIgB7iipJ+aN7kMGEiZR357dhL1bINU8jfAZJR9IjIv+jVq9nQ+Z6mBiOveJOW3skIei5knxl1hAPEVzrYGWi+CrBR0ofwsDXeJzQ/Djjo27L2USUK7UP0Q/A7IRNN/eRdOFhUwcDD5U8ZsnCBIsUWXwuXx6CrVnujsiPQZDM+Ew0sWh90evtIolCBLoC0T/+mXowSouWQ5A8lo0WDf1yI4nPnSlaC5m/Y1sPpSZp2dKWE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 29, 2026 at 1:25=E2=80=AFAM Michal Hocko <mhocko@suse.com> wrot=
e:
>
> On Tue 28-04-26 15:37:57, Minchan Kim wrote:
> [...]
> > >From be4bd22a100ed6be2d1d2599ddb9da04043143eb Mon Sep 17 00:00:00 2001
> > From: Minchan Kim <minchan@kernel.org>
> > Date: Fri, 24 Apr 2026 14:27:08 -0700
> > Subject: [PATCH] mm: process_mrelease: introduce PROCESS_MRELEASE_REAP_=
KILL
> >  flag
> >
> > Currently, process_mrelease() requires userspace to send a SIGKILL sign=
al
> > prior to invocation. This separation introduces a scheduling race windo=
w
> > where the victim task may receive the signal and enter the exit path
> > before the reaper can invoke process_mrelease().
> >
> > When the victim enters the exit path (do_exit -> exit_mm), it clears it=
s
> > task->mm immediately. This causes process_mrelease() to fail with -ESRC=
H,
> > leaving the actual address space teardown (exit_mmap) to be deferred un=
til
> > the mm's reference count drops to zero. In the field (e.g., Android),
> > arbitrary reference counts (reading /proc/<pid>/cmdline, or various oth=
er
> > remote VM accesses) frequently delay this teardown indefinitely,
> > defeating the purpose of expedited reclamation.
> >
> > In Android's LMKD scenarios, this delay keeps memory pressure high, for=
cing
> > the system to unnecessarily kill additional innocent background apps be=
fore
> > the memory from the first victim is recovered.
> >
> > This patch introduces the PROCESS_MRELEASE_REAP_KILL UAPI flag to suppo=
rt
> > an integrated auto-kill mode. When specified, process_mrelease() direct=
ly
> > injects a SIGKILL into the target task after finding its mm.
> >
> > To solve the race condition, we grab the mm reference via mmgrab() befo=
re
> > sending the SIGKILL. If the user passed PROCESS_MRELEASE_REAP_KILL, we =
assume
> > it will free its memory and proceed with reaping, making the logic as s=
imple
> > as reap =3D reap_kill || task_will_free_mem(p).
> >
> > To handle shared address spaces safely in the auto-kill mode, we bail o=
ut
> > immediately if the mm is marked with MMF_MULTIPROCESS when
> > PROCESS_MRELEASE_REAP_KILL is specified. This protects existing users o=
f
> > process_mrelease() from behavior changes while preventing unsafe reapin=
g of
> > shared memory.
>
> Please explain why this is a different behavior from the global oom
> killer and how do you intend to deal with those mm shared process
> groups. I am not saying this is a wrong behavior but it will be hard to
> change once in place.
>
> > Fundamentally, this allows process_mrelease() to trigger targeted memor=
y
> > reclaim (via oom_reaper infrastructure) quickly, even if the victim is
> > not yet in the exit path, while reusing existing race handling between
> > reaper and exit_mmap.
> >
> > Signed-off-by: Minchan Kim <minchan@kernel.org>
>
> Other than the above looks ok to me.

Implementation looks good to me. After addressing Michal's comment
please split this patch from the series and feel free to add:

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

>
> --
> Michal Hocko
> SUSE Labs

