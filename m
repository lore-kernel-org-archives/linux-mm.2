Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C34DBC55ABA
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 17:16:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E4496B007B; Wed,  5 Aug 2026 13:16:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 895AE6B0088; Wed,  5 Aug 2026 13:16:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 784956B008A; Wed,  5 Aug 2026 13:16:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 42BD96B007B
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 13:16:23 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C2BF6120529
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 17:16:22 +0000 (UTC)
X-FDA: 85067869404.26.6241CB7
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf17.hostedemail.com (Postfix) with ESMTP id CF83040018
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 17:16:20 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="wdxh/YeO";
	spf=pass (imf17.hostedemail.com: domain of abhishekbapat@google.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=abhishekbapat@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785950180;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r9SCbSFmlln4mD1lHCQMDvgYJ+Z3fNWnSwT6acniy4g=;
	b=6fqBBvqn7rwHjazLhO+pj3BdECEmSva2VSwxlMHcjDB8kqXskcCE7b1QL6yXuC/EWi2TCw
	Z3jbrdBgeWCttUSX0SSrjR1L01O6w5YdaZfp0CpoDhptY22MVAI1AL6TH9QQyqfsookjE5
	R6N0DVN9e6aZmAlBqgvPh7hIi0iNfkQ=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785950180;
	b=UuIxuoAnZVqCqZJnS1U5kpWcV792oN2O4zGcFvtKiXkih+D+oQ650cFrLNP+ePp18aAGKu
	YsHVWQ3ubGhpuFh7gVypTL8GuOV/S9Wk9xhi4YdnPrqEKJmlotWj7hr0EoE/loMq8rZpOe
	8VMu+mnO3j+AhZZYDE/kWTcaFolwwEw=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="wdxh/YeO";
	spf=pass (imf17.hostedemail.com: domain of abhishekbapat@google.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=abhishekbapat@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2ccdf36f63dso4855ad.0
        for <linux-mm@kvack.org>; Wed, 05 Aug 2026 10:16:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785950180; cv=none;
        d=google.com; s=arc-20260327;
        b=qN9/XtxZlKR56qh3veINIgQePD7kIhBo5Av2cXpfOPECk1desJ4KdfvnFyNEAjqafu
         ISNxGEPiTvqly6N22TdxZVOVd7Ak8wIC/7Wqt7tv3TRC4JYiNYHFyiKF36C5Z4jgtfUO
         jg6kygXZiblkJ8tvDdLRKu/sVNLeWj93gCU7fsTVMTyBQYk2JoAqwQasDCZprV9+ojP6
         +dH7ymt0gUmbSFjZmRYPtzjyZHEsxf92DfDrMCcun8Xtt4vCpqG/PoRa1McOddvU2IK8
         NaUidQLbPON/FyLN2ni/5rbK7UGHYjyKOQze8MEE5vh6seSrNvhc4MiRdt15fc/9I8Y5
         AkZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=r9SCbSFmlln4mD1lHCQMDvgYJ+Z3fNWnSwT6acniy4g=;
        fh=FFrpgxLaduJvLt5K2bPUlOCPoN+XZanHyLublv2Jrzk=;
        b=gCZcC/2ajiU7G6cBu6vuPzxCg4+/zLgtkT2kktb5P7N5YVAxMD4Q2/qf1sMb/U5JhZ
         JuDqdIoI4CN3h4REFx6WElglxjE4VBsIRJtEYIgfVydTUOLCzLjy5AaVH3Vi5n9FfqLV
         36bIqlgMKJedTAj19pbrS2NFl8kvSu3IM3W2UCbK/m52XTevqqWuh3idFh/zxQmRca5x
         jhpr7tofs8UOFlF0HfXCzqxC5afCzs6EISKTo3xs4sjglij7RBmClJuWhxd/kPHTRtFS
         /CDuUxkd+NyGyUl5krSvDUkIcS3fhn+M+sStat8YZpD29J/Da4MPC+WhYtzTcBduCXGf
         6qzg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785950180; x=1786554980; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=r9SCbSFmlln4mD1lHCQMDvgYJ+Z3fNWnSwT6acniy4g=;
        b=wdxh/YeOm4TTMeaIpJ5+NNAzi7wEPKh6Nkyg4SYJQ84GWmJyc8jymYT9aNCKhX+0b3
         Q+L301LsNMCxthPBEDbtnkA2fRP3XDXDHYZ06GpXNZL/ylDty/dgnOvXsAFP3Hj59tVZ
         z5i7EaYgaj5XP1INIiRNe0TNRapV55hrwjfdqU+6CI/xCPhe9sTqMNU6JZLrkjBUykW7
         DDgRM54X+nhV9xMppGJZf3CbUw2tLdXCoM9OCt3BzrHAlvnBjJ6CNCSljZsgqJB9+uP/
         YLpA0fhGeQ44wmqU6qe+PMzGXm2H8fAtuuHLqfQr2hZul3r0Y4kmW5cOdQH1/pHzCIRD
         b4XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785950180; x=1786554980;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=r9SCbSFmlln4mD1lHCQMDvgYJ+Z3fNWnSwT6acniy4g=;
        b=n9YMXOwn9zQWIxcYCv6ZJ776wW7ahwDufGnkPb1+kgp3fsugTlqQ4NBoBft6/jW5NE
         ZX1jWtxs3NbH0oJ8wEkx9SNRXtg6JRqBaujZ0xucZIx0d7tCnjskQAPD/rKWZyfp1Cj0
         G4MyIniyvDs8GV5R1oj41f0QFWJMK1gop/OwhEh7cwCiumeuxXhe/epDR5jBuSErs+kw
         RugQmRnL4Q/b2Z7n+BCV0awBAXtDDkY54Puq1j31l6zy6ZBih/jjYfGySKp/vmlGjfbq
         hDuVgY0TZTF2y95IRv37OrFHeHddAj/3dVMJ2/fU0R6RVt2i5G9T/2vBMhq7v5dByVwz
         jcCw==
X-Forwarded-Encrypted: i=1; AHgh+Rqm/TspIQXPvGpEU15G/BCj+zCwIddAQ6DyKPap4UBwvQVL5s+6iHOMyDDQFmHVAhB79WZXjs2waQ==@kvack.org
X-Gm-Message-State: AOJu0YzpQXO/O0RpTVGwTnbidsrdDRhslj8NhzQw4ueUTudBevwts4Ac
	jez+PiFq2Szypy6uRELjqrPLzZRdGY/HghmetE71GcXdcks/vXzxS3dFO2YP2Z2sOT+QMgMGnN7
	DwJf8+nsphpnNRoZshLkXXe1ePhM5XZ3jMasRrZax
X-Gm-Gg: AR+sD109YvBG9+lm6TuW70/k/NjZTTRWcHAhxOnzH49ZbHSPgIKjRUoo+0Jpp7r2e/b
	5o2kefLPSpyQYvkTY6NqMyFGe1OcXYGoKwtoVAibssyRkz1odc0Y2rCVpC9zs1eWKAt4xolLLUr
	9Zv7rpGEtbpg1OR0rJVKHVaqm12FMC4CRX/5Qzhfyku/EtmmEBQc78UBCMrcSa3Y6kM6NbYEdyT
	+SUIfCXowCjctxGXJqGQrvLkHC3iBGfEczhUkHxdBuOP+KUO3R/c6Dy0dkz3uMfsUwjqMRFsqsA
	hzQEIz3MLJyrJXs/13c9WrUtuZqZJavdQyM+Ti7U9iUKbNXkDdjqzE1Iyo5iYHdkgI6yT3TD6gs
	=
X-Received: by 2002:a17:902:f1d3:b0:2bf:3579:cdaa with SMTP id
 d9443c01a7336-2d0f2c1f504mr91875ad.10.1785950178959; Wed, 05 Aug 2026
 10:16:18 -0700 (PDT)
MIME-Version: 1.0
References: <d779f2cf4105448e0fb04eeab82acb20dd05d6ed.1785873902.git.abhishekbapat@google.com>
 <CAJuCfpGCHFhAwCkd8JX7fd1fee0JkJbS_SO8Q00ZM9dgi2TDjA@mail.gmail.com>
In-Reply-To: <CAJuCfpGCHFhAwCkd8JX7fd1fee0JkJbS_SO8Q00ZM9dgi2TDjA@mail.gmail.com>
From: Abhishek Bapat <abhishekbapat@google.com>
Date: Wed, 5 Aug 2026 10:16:07 -0700
X-Gm-Features: AUfX_my1QO_daePjeeS3gPa63cZwhf2KFvEyf9cdu44SELC8hZRCFsI2vBA5Pe0
Message-ID: <CAL41Mv6xvTXXoUCrHoqwHo6svTpGHUX4EyGEiU4X+5iU9jMzhQ@mail.gmail.com>
Subject: Re: [PATCH v4] alloc_tag: expose boot-time compression configuration
To: Suren Baghdasaryan <surenb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hao Ge <hao.ge@linux.dev>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: CF83040018
X-Stat-Signature: yzai43a99crxp497d1mkeumnzjarrtm7
X-Rspam-User: 
X-HE-Tag: 1785950180-7599
X-HE-Meta: U2FsdGVkX19L+N6ZwhbnuTlKt7ii6/UQDfAMSo3NqKqtHCCP8Xs3is2Z0nBWG3ugwKe7ZzgZkez2kHCqg1SVAJafijcBdpYzyTjaWLVFKPrWzQJ2oJ6Q/DknVqwdGamF8koaKMp/zDn8o88he3ZoY9wmRdiV7aiM2JBOg4vONKZwbmUexx2+tH3/LWMLdYB15eHUqUqFy49cuc9HzYjFvJsceYLG6UBxLUDKRELxUhMOD9xzI1LhYqzvU0MFzrZ66MuEgDIBJbjHi2/DrtLlHen6E9ynXrvRwXRxpOb6GjK/3Xg+MRcYWTeI4geR46P/JIS9gJQEakVSNoeTUQVW1l/qO+UXDVO581DUlFb7jVYNOR5kk/r++rB959oU4+fS3yn44Bn9mjNS0CeMNcSg8qSQZcgyyzmBzc+rtxUviaBybu63+dS2jfL82aQuGJ+Xe0COwf97cHY+UuOLC1IHBPLXMyJilE+8krtJxJxdzm9XYv38W2uYUrAHJXp01+U8o/ylrpnBAi2Xn529plIZM570ZSDzrm0XQ7K+rY3IR+0o7MFb5gbesvP7QCoohRiZnOPfkio1EsgbxQkFe4a7ewQ9Mz+osbHCqn/02WnBSpTjQvwySW230NIfzukrQvw/k9dMgBBfKRxx36CBEChkTTqQQDWB1Nr+UdtxQ04imDOrJ/iKzSE4g14YxfYyqafc757XefI28e7uGgSchiBZpjcIqRFDCK+d/8aDTonTLNFcA3c46aopUJbR7aaiQLgS98xcChzQPWRgYtSNVRNEFBYiHaICgm9UZ3l+UujZD8YWD5yIk7PETIJzLmJH0A7fEY3ZCpAOA1Fg9r251qY8Rggfz5oT0L4ebyMNtlx6QmtX6HQ+YSP39/djXWDGCbehw/D30QEuzUTRH7d3qoMgj7X7+Fnb3H33YhMOX1ttoJYXG+aTseGN1DTBQ6aZ+XflWgBRs+lFqnEaKMfDATx
 Ys8UGe2d
 w/Xsjtz7fj7H6BMvDzZRZNW4h74dpg7ktSg+xZdQkfJJ3iZEoHBnN8bizB1C28SpDzefKbl35v85P0mk01Q1q7tr1I4L8rK/rYKxruuWNNlSlf2oRY49a1LRWiTXdsGNbrQrDhh5kZzIDBsKkTIgauqcWDtXCWnfFK6BLJmNpiicpsLwgdIdzUxVv7cyI1foSHBlytB5GAWPgWYWKQYPtV/G2N8s4ptm44GhDc2QMxoqhgxiK877QzvCS0GL03HAFHNq7a6ZED49TaEKfgUKYR7TtDl7rxyaZCpcNH9uarrNwkZ++SXqfq+qK1HsGQVpgesMvIiwY0X/3Mdqj01nOZQMN7QcNX3vhGIPH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 4, 2026 at 1:34=E2=80=AFPM Suren Baghdasaryan <surenb@google.co=
m> wrote:
>
> On Tue, Aug 4, 2026 at 1:06=E2=80=AFPM Abhishek Bapat <abhishekbapat@goog=
le.com> wrote:
> >
> > Currently, userspace has limited visibility into the exact active
> > runtime state of memory allocation profiling and its page extension
> > compression ('sysctl.vm.mem_profiling=3D{0|1|never}[,compressed]').
> >
> > While reading the sysctl provides basic on/off status, it is currently
> > impossible for userspace to natively determine whether page-tag
> > compression was successfully enabled without scraping dmesg boot logs.
> >
> > Resolve this ambiguity by exposing the active compression state by
> > adding a new read-only sysctl `vm.mem_profiling_compressed` to output t=
he
> > state.
>
> I guess you missed my first comment at
> https://lore.kernel.org/all/CAJuCfpGA7F80yW1=3DbSXsZre4=3DTx=3DpeqNbkWvKF=
0up8xJdSvrgA@mail.gmail.com/.
> Anyway, that's not super critical but would be nice to fix.
>
> >
> > Signed-off-by: Abhishek Bapat <abhishekbapat@google.com>
> > ---
> > v4 change:
> > - Documentation and commit message refactor.
> >
> > v3 change:
> > - Added documentation about the behaviour details of the new sysctl.
> >
> > v2 change:
> > - Moved from displaying the state in /proc/allocinfo to a new read-only
> > sysctl.
> >
> >  Documentation/mm/allocation-profiling.rst | 11 +++++++++++
> >  mm/alloc_tag.c                            |  6 ++++++
> >  2 files changed, 17 insertions(+)
> >
> > diff --git a/Documentation/mm/allocation-profiling.rst b/Documentation/=
mm/allocation-profiling.rst
> > index c3a28467955f..f28358af927a 100644
> > --- a/Documentation/mm/allocation-profiling.rst
> > +++ b/Documentation/mm/allocation-profiling.rst
> > @@ -43,6 +43,17 @@ sysctl:
> >    warnings produced by allocations made while profiling is disabled an=
d freed
> >    when it's enabled.
> >
> > +  /proc/sys/vm/mem_profiling_compressed
> > +
> > +  1: Page alloc tag compression is enabled.
> > +
> > +  0: Page alloc tag compression is disabled.
> > +
> > +  This reflects a static boot-time configuration of how page allocatio=
n tags are
> > +  stored (in page flags when compression is enabled and in page_ext wh=
en disabled).
> > +  Toggling `mem_profiling` at runtime does not change the state of
> > +  `mem_profiling_compressed`.
>
> I'm not a documentation expert but Google tells me: single backticks
> (`) act as interpreted text for semantic cross-references or links,
> while double backticks (``) act as inline literals for raw code
> formatting. I think double backticks would be more appropriate here.
> You should also CC linux-doc@vger.kernel.org to get their input.
>

My bad I missed that comment, I'll send out a new version with the
recommended changes. Thanks!

> > +
> >  Runtime info:
> >    /proc/allocinfo
> >
> > diff --git a/mm/alloc_tag.c b/mm/alloc_tag.c
> > index 52aece27b00e..877068241f06 100644
> > --- a/mm/alloc_tag.c
> > +++ b/mm/alloc_tag.c
> > @@ -1303,6 +1303,12 @@ static const struct ctl_table memory_allocation_=
profiling_sysctls[] =3D {
> >                 .mode           =3D 0644,
> >                 .proc_handler   =3D proc_mem_profiling_handler,
> >         },
> > +       {
> > +               .procname       =3D "mem_profiling_compressed",
> > +               .data           =3D &mem_profiling_compressed,
> > +               .mode           =3D 0444,
> > +               .proc_handler   =3D proc_do_static_key,
> > +       },
> >  };
> >
> >  static void __init sysctl_init(void)
> >
> > base-commit: 486855239e38a91d3eae26618ccb7845c1764625
> > --
> > 2.55.0.508.g3f0d502094-goog
> >

