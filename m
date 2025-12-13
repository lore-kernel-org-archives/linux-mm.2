Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E17AED59F5F
	for <linux-mm@archiver.kernel.org>; Sat, 13 Dec 2025 00:31:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F9506B0005; Fri, 12 Dec 2025 19:31:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0AAA46B0007; Fri, 12 Dec 2025 19:31:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EDB2C6B0008; Fri, 12 Dec 2025 19:31:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D94866B0005
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 19:31:37 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6B597135464
	for <linux-mm@kvack.org>; Sat, 13 Dec 2025 00:31:37 +0000 (UTC)
X-FDA: 84212569434.18.928335D
Received: from mail-yw1-f174.google.com (mail-yw1-f174.google.com [209.85.128.174])
	by imf02.hostedemail.com (Postfix) with ESMTP id 84C3080006
	for <linux-mm@kvack.org>; Sat, 13 Dec 2025 00:31:35 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="H/Xg8609";
	spf=pass (imf02.hostedemail.com: domain of rgbi3307@gmail.com designates 209.85.128.174 as permitted sender) smtp.mailfrom=rgbi3307@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765585895; a=rsa-sha256;
	cv=none;
	b=eyIOiaWEd6p/zh9lJEKw0zRerJ3B6VKX6k0LmRmyrEI1Aoxz2kou2XNtPqISim3lF7p8Yq
	DT97JL5w9t52bAIDxND1HpwduipEy/sks0LZaYsnjY0etO2O0K4oBiKSlapIxvCAGPqMbV
	bjLckWn4tjeJkLpfT02uZUW/nLzUBVo=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="H/Xg8609";
	spf=pass (imf02.hostedemail.com: domain of rgbi3307@gmail.com designates 209.85.128.174 as permitted sender) smtp.mailfrom=rgbi3307@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765585895;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UEcwbKwfTOFD0jwPGTk2/X+40kQERA+omCUm1l1+tM8=;
	b=bzSl5XRnD7FSzJZX7xt3VqD88A0/lhGrhawRmcfh2DMoDdP9FQQ/dgWM6b85MvI/o0m95W
	S/sOwMFyWS/jbGYW8kHw7G0xYlRj9XB1wOvWuFF6JoqZyf23l2aYkXicRgR7pNzBmxIRVP
	LLNv1NKlYhmAN92b+ec8D4MZMdwoans=
Received: by mail-yw1-f174.google.com with SMTP id 00721157ae682-787da30c50fso18422837b3.3
        for <linux-mm@kvack.org>; Fri, 12 Dec 2025 16:31:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765585894; x=1766190694; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UEcwbKwfTOFD0jwPGTk2/X+40kQERA+omCUm1l1+tM8=;
        b=H/Xg8609yhIuTrujv8/+Ue/4T3c6+k+0v7qJqDAldJftTZXL3NJvGldERqKBkXkbzE
         +0vYIJzCf2ScbFx+RldRAZhrWnK6sXkkClGYleO+5x+mqK4fxQhxID6vuKBe6PVS4qvB
         +dQujhs5knCnsRYexK3CEmC8k+QW8GFfV2lcOvRYKS5ySdVZTMjXNoqu5KW4u5ABeBvv
         hpEMK8ohLjeUH3/r6nd8J57LEOMph/vrrX+vxUf0ooE0AD8hO9Kqz/ccLCzduY9R3apt
         /3Ae9BbW0xV39nDhTeLI9TiniBKczdleg3u9RljM90bIZr1KOW80rwagxiFsmdVEKJpD
         CWZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765585894; x=1766190694;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=UEcwbKwfTOFD0jwPGTk2/X+40kQERA+omCUm1l1+tM8=;
        b=VcUgc77B/skcsqzWXUICN+xnntb2dVRtimj1IhDAlr5INEmXnefIQHVJITweGEXIYs
         e5A7YhYrSISfFNwoN78nYSyH3wBMVf3nokhgvIDwN7cVpeDF3JdszSvvF3o4qGsCOLdP
         zf3d5V8YnCwsaGS6MR1ofsrDPk2TvuGYaRoc+K/12gBOOIg1vcgO9jv1mWO3rGqBvGCK
         DJ9ei1/mp3srNAR2XjBx3h6CyKLRygn6G/XNFeBytE7w2rxZhZ896rEm3beQxfZw+Lz5
         +AQdu5cJC17k3hs5QBQVF0xnzlN1FtFaWCEaNVRu83n3MtfzsX7M0PS1PcfVG0MsgdJ5
         311w==
X-Forwarded-Encrypted: i=1; AJvYcCXZsx6GOSHT0tWWuU7w1JyxBE12mmIRgbrhpiZ3//o8rGbp9Sx/7+t6E/BzPH7HnSe2JEsS2WSehQ==@kvack.org
X-Gm-Message-State: AOJu0Yzun5PHsNPTw0uEdDFmY6Hc9iZzifhL4bdhn+2+EzkCv+1kGwyx
	z6dp2sS+C+EDKYfRP2G39qEtfNXA3uqF2+RbHmowtQBc7dAeMJ7pSsBgK6/XLbk3q1OBDMD/bcO
	zwrqZeNGOTlGy6uw2htFo9wOrvavJAdY=
X-Gm-Gg: AY/fxX5meSsGsOjcdpSEXo1hB26XLWRurjx+Hr4wZ4MHKFjnpEbfsMRQORfhwb/Aj60
	Bn1fkgi3JYzLhzyo1DASsvS176nM6gCvj7Gnxpau7b4tuxlE4vowVYhf3kzdZsmHpEH+aMn6izM
	CCKf33pnLIPifyyYOVO/GnvGNKLW3F3OsoF+sj5fpB+dZFC/Pno17SwzKejYtyBEEksLlk62DJ4
	aQ0Oc65cwCJ6YXdijXNMX0LuxaDNJ9UJfxdX9C6mmEnQ9uf4Py6D/RLbg827KtnMwWFscHR
X-Google-Smtp-Source: AGHT+IEQZtU4xsWlPhjZ7QJTAV/tes6u89ouYxUdq4/62OSm+FOWxb8I8THQC5Se0CroX3JY/me34F5OxoNdNpC1NX8=
X-Received: by 2002:a05:690c:3505:b0:78a:722f:a7c9 with SMTP id
 00721157ae682-78e66df1f36mr66786637b3.47.1765585894226; Fri, 12 Dec 2025
 16:31:34 -0800 (PST)
MIME-Version: 1.0
References: <CAHOvCC6B1q+1TLEw5WAQM+E_L2tQQArgq=Hy5JZ35m4_H7s_5Q@mail.gmail.com>
 <20251212224721.49478-1-sj@kernel.org>
In-Reply-To: <20251212224721.49478-1-sj@kernel.org>
From: JaeJoon Jung <rgbi3307@gmail.com>
Date: Sat, 13 Dec 2025 09:31:22 +0900
X-Gm-Features: AQt7F2pfvDTP5FkaJvoXFOYDXn_3neT_rIxfDPvx0spF759PQGoNThkIDh55lTk
Message-ID: <CAHOvCC4jUGpyezSNMChyOCio-vTA=kK3CYS3O1CzEXxEiMjPyg@mail.gmail.com>
Subject: Re: [RFC PATCH v3 04/37] mm/damon/core: implement damon_report_page_fault()
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, damon@lists.linux.dev, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 84C3080006
X-Rspamd-Server: rspam04
X-Stat-Signature: q6ff93pwmz9xiuuxoafi5993nz94y9t5
X-HE-Tag: 1765585895-298745
X-HE-Meta: U2FsdGVkX18bx1tBSzh6bppznkFdBl0GRAob79yOoZt9wMSc4Zue5vjlCwpt3JPK4GZ1+7hIQAkca/D2BeIo1MiGgj0E+tTnBgRC8imhx6tv2DKml6ObFAtkzCw/97r9xFPkRkecNfvwbfmRwhnK7LLK6AfKL6mxh5m7v6Bpd5YNu474jI7WMpLCa9TUf/YjTiMLH2a6xFA0rBLQGy3MK+Nd1306Xi89T5gzQ3qVBDOD+GqxmxMkbsdsyu80kjaN9x4FV8+wOfUvKcCbb43k+Q3dJymQJFjFNkPtXp0KCdIR/HwHb8vP3JCLVAps8RwdORxy8mjE7gnODHKtFlkMuOC/xy3uL98C02a8FT9ZV0fqzfIfkv05SvJPdwztlfTAKWdpaTyoYCVT0hMW0kM5ERgCgruDsEnqqr52GP3Vq9/FGAbJCUjacskMDsdHLaewafCp/IY0L7r63w2IUoJZK+T3HE1ZUr9JMLcs6z0QYCVy7cW0HDsX1lT8Gz+mqzkmxDpUGmFCgPTWdgm44wcVRkmi5LV9bkd2zL9hiCgjgFTVVJgAG/SgFLP7Pri9hDCWx5fgcVlSML8Lv8b/+HVcCtueIt8/1B6cfQ2VpkNGF3fJrYCbPlrgvVdPYKhnRY+ClxIrUep+pW8dw9DmwcoGJymbZrx7XzQMzIsViOzvUO6yxMfsOHoNTYxuk9VALB1PFRkCpE8hYWq0PJurRLhgCV0QhydpfTZrJ5VBjLWums2ocUIdk7oPNoW0FfTYWDbdQWiWBzAomD53U0IVyslnGkHxanruoBXpZKR9rNBTJWaOOr5S+ppcA6aIXVABc3cLPxbZb3i7cbsTLpesYG0ao6qQCdYb5TpRW4g2yQoFINYoIU3HBfdUG+tbTGrTPFBjm/COAdz18wFvuJZgEJb1Ckpa1kqJz9RAWvzpBGBiV0S4hRssx5bB69kKfpb+2U7tFy6Yb5i1AkNdQ0bZf53
 tVZlvWIU
 J1kTFXp9MDueWNCyJOM8BFGM0vlg3epuGZmtNiY4hjtQHBkbuKVVCIp6wbSkMqRN7Lhx/V+01wc2nteSe5YMfFCkUeaNOhiBMM9Gv9FCDu+10H0Zgf39Kdjnm7VI+/NX54NNat6jChtRWhQwAVH26+dALcV/olDFDV6DHaInk7LjHbgd8xd6/Mtlojdhpyzz3Lqi6atVJ4RRAqNmDF8VeuCIqcfd715dbJeG9wsqcDDFgZ9a4nN5Pc6UQFfECHKHH/0zbKUqCxmbL5yggUQEg+H5VPoc1Um9F0fWSL0EzFn5ho4Tgb0AzO5SB8H8y7Lnmcg0jbJ+sxCP7YgFFkbXDfK53fbEiypqflPbFn3CCfkA8mMNhU6a6F+xO+m30UMAhaLZ+FqAQ9HM0WTgcaFv4uJR+m0aA2KdamOh4rFXkDMjckriYJU22ZAY2XSuMkniQgU4dIggycpoJW9s=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 13 Dec 2025 at 07:47, SeongJae Park <sj@kernel.org> wrote:
>
> On Fri, 12 Dec 2025 21:46:03 +0900 JaeJoon Jung <rgbi3307@gmail.com> wrot=
e:
>
> > On Mon, 8 Dec 2025 at 15:33, SeongJae Park <sj@kernel.org> wrote:
> > >
> > > Implement a DAMON core API for reporting page fault events to DAMON. =
 It
> > > is a wrapper of damon_report_access().
> > >
> > > This is a temporal hack.  In future versions that will have no RFC ta=
g,
> > > only damon_report_access() may be used.
> >
> > It's a minor, but git am throws an error when applying the [RFC PATCH v=
3 04/37]
> > patch file.
>
> Interesting.  I can do 'git am' this patch without error on mm-new branch=
.  Are
> you using something other than mm-new as your baseline?
>
> > I am testing it by modifying it as follows.
> > damon_report_access() is
> > called by damon_report_page_fault(), so they depend on each other.
> >
> > #ifdef CONFIG_MMU
> > void damon_report_access(struct damon_access_report *report);
> > void damon_report_page_fault(struct vm_fault *vmf, bool huge_pmd);
> > #else
> > static inline void damon_report_access(struct damon_access_report *repo=
rt)
> > {
> > }
> > static inline void damon_report_page_fault(struct vm_fault *vmf, bool h=
uge_pmd)
> > {
> > }
> > #endif
>
> Seems this is not for fixing a 'git am' error but build error...?  Can yo=
u
> share what error exactly you are seeing?

You have been deploying RFC PATCH v1, v2, and v3 starting from 2025-06-29.
I am currently working with the latest version v6.18.1 (as of 2025-12-13).

$ head Makefile
# SPDX-License-Identifier: GPL-2.0
VERSION =3D 6
PATCHLEVEL =3D 18
SUBLEVEL =3D 1
EXTRAVERSION =3D
NAME =3D Baby Opossum Posse

When applying RFC PATCH v1, v2, v3 with the above version, errors occur
in several places in 'git am' as follows.

-------- [RFC PATCH v1] -------------------------------------------------

$ git am '[RFC PATCH 1/6]'
Applying: mm/damon/core: introduce damon_report_access()

$ git am '[RFC PATCH 2/6]'
Applying: mm/damon/core: add eliglble_report() ops callback

$ git am '[RFC PATCH 3/6]'
Applying: mm/damon/core: check received access reports

$ git am '[RFC PATCH 4/6]'
Applying: mm/damon/vaddr: impleement eligible_report() callback
error: patch failed: mm/damon/vaddr.c:610
error: mm/damon/vaddr.c: patch does not apply
Patch failed at 0001 mm/damon/vaddr: impleement eligible_report() callback
hint: Use 'git am --show-current-patch=3Ddiff' to see the failed patch
When you have resolved this problem, run "git am --continue".
If you prefer to skip this patch, run "git am --skip" instead.
To restore the original branch and stop patching, run "git am --abort".

$ git am --abort

$ git am '[RFC PATCH 5/6]'
Applying: mm/damon: add node_id to damon_access_report

$ git am '[RFC PATCH 6/6]'
Applying: mm/damon: add write field to damon_access_report

-------- [RFC PATCH v2] -------------------------------------------------

$ git am '[RFC v2 1/7]'
Applying: mm/damon/core: introduce damon_report_access()
error: patch failed: include/linux/damon.h:104
error: include/linux/damon.h: patch does not apply
error: patch failed: mm/damon/core.c:24
error: mm/damon/core.c: patch does not apply
Patch failed at 0001 mm/damon/core: introduce damon_report_access()
hint: Use 'git am --show-current-patch=3Ddiff' to see the failed patch
When you have resolved this problem, run "git am --continue".
If you prefer to skip this patch, run "git am --skip" instead.
To restore the original branch and stop patching, run "git am --abort".

$ git am --abort

$ git am '[RFC v2 2/7]'
Applying: mm/damon/core: add eligible_report() ops callback
error: patch failed: include/linux/damon.h:590
error: include/linux/damon.h: patch does not apply
Patch failed at 0001 mm/damon/core: add eligible_report() ops callback
hint: Use 'git am --show-current-patch=3Ddiff' to see the failed patch
When you have resolved this problem, run "git am --continue".
If you prefer to skip this patch, run "git am --skip" instead.
To restore the original branch and stop patching, run "git am --abort".

$ git am --abort

$ git am '[RFC v2 3/7]'
Applying: mm/damon/vaddr: implement eligible_report()

$ git am '[RFC v2 4/7]'
Applying: mm/damon/core: read received access reports
error: patch failed: mm/damon/core.c:2560
error: mm/damon/core.c: patch does not apply
Patch failed at 0001 mm/damon/core: read received access reports
hint: Use 'git am --show-current-patch=3Ddiff' to see the failed patch
When you have resolved this problem, run "git am --continue".
If you prefer to skip this patch, run "git am --skip" instead.
To restore the original branch and stop patching, run "git am --abort".

$ git am --abort

$ git am '[RFC v2 5/7]'
Applying: mm/memory: implement MM_CP_DAMON

$ git am '[RFC v2 6/7]'
Applying: mm/damon: implement paddr_fault operations set

$ git am '[RFC v2 7/7]'
Applying: mm/damon/sysfs: support paddr_fault

-------- [RFC PATCH v3] -------------------------------------------------

$ git am '[RFC v3 01/37]'
Applying: mm/damon/core: implement damon_report_access()
error: patch failed: include/linux/damon.h:110
error: include/linux/damon.h: patch does not apply
error: patch failed: mm/damon/core.c:20
error: mm/damon/core.c: patch does not apply
Patch failed at 0001 mm/damon/core: implement damon_report_access()
hint: Use 'git am --show-current-patch=3Ddiff' to see the failed patch
When you have resolved this problem, run "git am --continue".
If you prefer to skip this patch, run "git am --skip" instead.
To restore the original branch and stop patching, run "git am --abort".

$ git am --abort

$ git am '[RFC v3 02/37]'
Applying: mm/damon: define struct damon_sample_control

$ git am '[RFC v3 03/37]'
Applying: mm/damon/core: commit damon_sample_control
error: patch failed: mm/damon/core.c:1278
error: mm/damon/core.c: patch does not apply
Patch failed at 0001 mm/damon/core: commit damon_sample_control
hint: Use 'git am --show-current-patch=3Ddiff' to see the failed patch
When you have resolved this problem, run "git am --continue".
If you prefer to skip this patch, run "git am --skip" instead.
To restore the original branch and stop patching, run "git am --abort".

$ git am --abort

$ git am '[RFC v3 04/37]'
Applying: mm/damon/core: implement damon_report_page_fault()
error: patch failed: include/linux/damon.h:1017
error: include/linux/damon.h: patch does not apply
Patch failed at 0001 mm/damon/core: implement damon_report_page_fault()
hint: Use 'git am --show-current-patch=3Ddiff' to see the failed patch
When you have resolved this problem, run "git am --continue".
If you prefer to skip this patch, run "git am --skip" instead.
To restore the original branch and stop patching, run "git am --abort".

$ git am --abort

$ git am '[RFC v3 05/37]'
Applying: mm/{mprotect,memory}: (no upstream-aimed hack) implement MM_CP_DA=
MON
error: patch failed: include/linux/mm.h:2848
error: include/linux/mm.h: patch does not apply
error: patch failed: mm/memory.c:78
error: mm/memory.c: patch does not apply
error: patch failed: mm/mprotect.c:651
error: mm/mprotect.c: patch does not apply
Patch failed at 0001 mm/{mprotect,memory}: (no upstream-aimed hack)
implement MM_CP_DAMON
hint: Use 'git am --show-current-patch=3Ddiff' to see the failed patch
When you have resolved this problem, run "git am --continue".
If you prefer to skip this patch, run "git am --skip" instead.
To restore the original branch and stop patching, run "git am --abort".

$ git am --abort

$ git am '[RFC v3 06/37]'
Applying: mm/damon/paddr: support page fault access check primitive
error: patch failed: mm/damon/paddr.c:14
error: mm/damon/paddr.c: patch does not apply
Patch failed at 0001 mm/damon/paddr: support page fault access check primit=
ive
hint: Use 'git am --show-current-patch=3Ddiff' to see the failed patch
When you have resolved this problem, run "git am --continue".
If you prefer to skip this patch, run "git am --skip" instead.
To restore the original branch and stop patching, run "git am --abort".

$ git am --abort

$ git am '[RFC v3 07/37]'
Applying: mm/damon/core: apply access reports to high level snapshot
error: patch failed: mm/damon/core.c:2745
error: mm/damon/core.c: patch does not apply
Patch failed at 0001 mm/damon/core: apply access reports to high level snap=
shot
hint: Use 'git am --show-current-patch=3Ddiff' to see the failed patch
When you have resolved this problem, run "git am --continue".
If you prefer to skip this patch, run "git am --skip" instead.
To restore the original branch and stop patching, run "git am --abort".

$ git am --abort

$ git am '[RFC v3 08/37]'
Applying: mm/damon/sysfs: implement monitoring_attrs/sample/ dir

$ git am '[RFC v3 09/37]'
Applying: mm/damon/sysfs: implement sample/primitives/ dir

$ git am '[RFC v3 10/37]'
Applying: mm/damon/sysfs: connect primitives directory with core

$ git am '[RFC v3 11/37]'
Applying: Docs/mm/damon/design: document page fault sampling primitive

$ git am '[RFC v3 12/37]'
Applying: Docs/admin-guide/mm/damon/usage: document sample primitives dir
error: patch failed: Documentation/admin-guide/mm/damon/usage.rst:65
error: Documentation/admin-guide/mm/damon/usage.rst: patch does not apply
Patch failed at 0001 Docs/admin-guide/mm/damon/usage: document sample
primitives dir
hint: Use 'git am --show-current-patch=3Ddiff' to see the failed patch
When you have resolved this problem, run "git am --continue".
If you prefer to skip this patch, run "git am --skip" instead.
To restore the original branch and stop patching, run "git am --abort".

$ git am --abort

$ git am '[RFC v3 13/37]'
Applying: mm/damon: extend damon_access_report for origin CPU reporting
error: patch failed: include/linux/damon.h:115
error: include/linux/damon.h: patch does not apply
Patch failed at 0001 mm/damon: extend damon_access_report for origin
CPU reporting
hint: Use 'git am --show-current-patch=3Ddiff' to see the failed patch
When you have resolved this problem, run "git am --continue".
If you prefer to skip this patch, run "git am --skip" instead.
To restore the original branch and stop patching, run "git am --abort".

$ git am --abort

$ git am '[RFC v3 14/37]'
Applying: mm/damon/core: report access origin cpu of page faults
error: patch failed: mm/damon/core.c:1585
error: mm/damon/core.c: patch does not apply
Patch failed at 0001 mm/damon/core: report access origin cpu of page faults
hint: Use 'git am --show-current-patch=3Ddiff' to see the failed patch
When you have resolved this problem, run "git am --continue".
If you prefer to skip this patch, run "git am --skip" instead.
To restore the original branch and stop patching, run "git am --abort".

$ git am --abort

$ git am '[RFC v3 15/37]'
Applying: mm/damon: implement sample filter data structure for
cpus-only monitoring

$ git am '[RFC v3 16/37]'
Applying: mm/damon/core: implement damon_sample_filter manipulations
error: patch failed: mm/damon/core.c:561
error: mm/damon/core.c: patch does not apply
Patch failed at 0001 mm/damon/core: implement damon_sample_filter manipulat=
ions
hint: Use 'git am --show-current-patch=3Ddiff' to see the failed patch
When you have resolved this problem, run "git am --continue".
If you prefer to skip this patch, run "git am --skip" instead.
To restore the original branch and stop patching, run "git am --abort".

$ git am --abort

$ git am '[RFC v3 17/37]'
Applying: mm/damon/core: commit damon_sample_filters
error: patch failed: mm/damon/core.c:573
error: mm/damon/core.c: patch does not apply
Patch failed at 0001 mm/damon/core: commit damon_sample_filters
hint: Use 'git am --show-current-patch=3Ddiff' to see the failed patch
When you have resolved this problem, run "git am --continue".
If you prefer to skip this patch, run "git am --skip" instead.
To restore the original branch and stop patching, run "git am --abort".

$ git am --abort

$ git am '[RFC v3 18/37]'
Applying: mm/damon/core: apply sample filter to access reports
error: patch failed: mm/damon/core.c:586
error: mm/damon/core.c: patch does not apply
Patch failed at 0001 mm/damon/core: apply sample filter to access reports
hint: Use 'git am --show-current-patch=3Ddiff' to see the failed patch
When you have resolved this problem, run "git am --continue".
If you prefer to skip this patch, run "git am --skip" instead.
To restore the original branch and stop patching, run "git am --abort".

$ git am --abort

$ git am '[RFC v3 19/37]'
Applying: mm/damon/sysfs: implement sample/filters/ directory

$ git am '[RFC v3 20/37]'
Applying: mm/damon/sysfs: implement sample filter directory

$ git am '[RFC v3 21/37]'
Applying: mm/damon/sysfs: implement type, matching, allow files under
sample filter dir

$ git am '[RFC v3 22/37]'
Applying: mm/damon/sysfs: implement cpumask file under sample filter dir

$ git am '[RFC v3 23/37]'
Applying: mm/damon/sysfs: connect sample filters with core layer

$ git am '[RFC v3 24/37]'
Applying: Docs/mm/damon/design: document sample filters

$ git am '[RFC v3 25/37]'
Applying: Docs/admin-guide/mm/damon/usage: document sample filters dir
error: patch failed: Documentation/admin-guide/mm/damon/usage.rst:66
error: Documentation/admin-guide/mm/damon/usage.rst: patch does not apply
Patch failed at 0001 Docs/admin-guide/mm/damon/usage: document sample
filters dir
hint: Use 'git am --show-current-patch=3Ddiff' to see the failed patch
When you have resolved this problem, run "git am --continue".
If you prefer to skip this patch, run "git am --skip" instead.
To restore the original branch and stop patching, run "git am --abort".

$ git am --abort

$ git am '[RFC v3 26/37]'
Applying: mm/damon: extend damon_access_report for access-origin thread inf=
o
error: patch failed: include/linux/damon.h:116
error: include/linux/damon.h: patch does not apply
Patch failed at 0001 mm/damon: extend damon_access_report for
access-origin thread info
hint: Use 'git am --show-current-patch=3Ddiff' to see the failed patch
When you have resolved this problem, run "git am --continue".
If you prefer to skip this patch, run "git am --skip" instead.
To restore the original branch and stop patching, run "git am --abort".

$ git am --abort

$ git am '[RFC v3 27/37]'
Applying: mm/damon/core: report access-generated thread id of the fault eve=
nt
error: patch failed: mm/damon/core.c:1712
error: mm/damon/core.c: patch does not apply
Patch failed at 0001 mm/damon/core: report access-generated thread id
of the fault event
hint: Use 'git am --show-current-patch=3Ddiff' to see the failed patch
When you have resolved this problem, run "git am --continue".
If you prefer to skip this patch, run "git am --skip" instead.
To restore the original branch and stop patching, run "git am --abort".

$ git am --abort

$ git am '[RFC v3 28/37]'
Applying: mm/damon: extend damon_sample_filter for threads

$ git am '[RFC v3 29/37]'
Applying: mm/damon/core: support threads type sample filter
error: patch failed: mm/damon/core.c:570
error: mm/damon/core.c: patch does not apply
Patch failed at 0001 mm/damon/core: support threads type sample filter
hint: Use 'git am --show-current-patch=3Ddiff' to see the failed patch
When you have resolved this problem, run "git am --continue".
If you prefer to skip this patch, run "git am --skip" instead.
To restore the original branch and stop patching, run "git am --abort".

$ git am --abort

$ git am '[RFC v3 30/37]'
Applying: mm/damon/sysfs: support thread based access sample filtering

$ git am '[RFC v3 31/37]'
Applying: Docs/mm/damon/design: document threads type sample filter

$ git am '[RFC v3 32/37]'
Applying: Docs/admin-guide/mm/damon/usage: document tids_arr file
error: patch failed: Documentation/admin-guide/mm/damon/usage.rst:67
error: Documentation/admin-guide/mm/damon/usage.rst: patch does not apply
Patch failed at 0001 Docs/admin-guide/mm/damon/usage: document tids_arr fil=
e
hint: Use 'git am --show-current-patch=3Ddiff' to see the failed patch
When you have resolved this problem, run "git am --continue".
If you prefer to skip this patch, run "git am --skip" instead.
To restore the original branch and stop patching, run "git am --abort".

$ git am --abort

$ git am '[RFC v3 33/37]'
Applying: mm/damon: support reporting write access
error: patch failed: include/linux/damon.h:117
error: include/linux/damon.h: patch does not apply
Patch failed at 0001 mm/damon: support reporting write access
hint: Use 'git am --show-current-patch=3Ddiff' to see the failed patch
When you have resolved this problem, run "git am --continue".
If you prefer to skip this patch, run "git am --skip" instead.
To restore the original branch and stop patching, run "git am --abort".

$ git am --abort

$ git am '[RFC v3 34/37]'
Applying: mm/damon/core: report whether the page fault was for writing
error: patch failed: mm/damon/core.c:1732
error: mm/damon/core.c: patch does not apply
Patch failed at 0001 mm/damon/core: report whether the page fault was
for writing
hint: Use 'git am --show-current-patch=3Ddiff' to see the failed patch
When you have resolved this problem, run "git am --continue".
If you prefer to skip this patch, run "git am --skip" instead.
To restore the original branch and stop patching, run "git am --abort".

$ git am --abort

$ git am '[RFC v3 35/37]'
Applying: mm/damon/core: support write access sample filter
error: patch failed: mm/damon/core.c:1336
error: mm/damon/core.c: patch does not apply
Patch failed at 0001 mm/damon/core: support write access sample filter
hint: Use 'git am --show-current-patch=3Ddiff' to see the failed patch
When you have resolved this problem, run "git am --continue".
If you prefer to skip this patch, run "git am --skip" instead.
To restore the original branch and stop patching, run "git am --abort".

$ git am --abort

$ git am '[RFC v3 36/37]'
Applying: mm/damon/sysfs: support write-type access sample filter

$ git am '[RFC v3 37/37]'
Applying: Docs/mm/damon/design: document write access sample filter type

If I build the kernel with the above status, I get compilation errors
as follows.

/home/arm64/projects/kernel/linux-stable/mm/damon/sysfs.c:758:25:
error: =E2=80=98DAMON_FILTER_TYPE_WRITE=E2=80=99 undeclared here (not in a =
function);
did you mean =E2=80=98DAMOS_FILTER_TYPE_TARGET=E2=80=99?
  758 |                 .type =3D DAMON_FILTER_TYPE_WRITE,
      |                         ^~~~~~~~~~~~~~~~~~~~~~~
      |                         DAMOS_FILTER_TYPE_TARGET
/home/arm64/projects/kernel/linux-stable/mm/damon/sysfs.c: In function
=E2=80=98damon_sysfs_set_sample_filters=E2=80=99:
/home/arm64/projects/kernel/linux-stable/mm/damon/sysfs.c:2014:26:
error: implicit declaration of function =E2=80=98damon_new_sample_filter=E2=
=80=99; did
you mean =E2=80=98damos_new_filter=E2=80=99? [-Werror=3Dimplicit-function-d=
eclaration]
 2014 |                 filter =3D damon_new_sample_filter(
      |                          ^~~~~~~~~~~~~~~~~~~~~~~
      |                          damos_new_filter
/home/arm64/projects/kernel/linux-stable/mm/damon/sysfs.c:2014:24:
warning: assignment to =E2=80=98struct damon_sample_filter *=E2=80=99 from =
=E2=80=98int=E2=80=99 makes
pointer from integer without a cast [-Wint-conversion]
 2014 |                 filter =3D damon_new_sample_filter(
      |                        ^
/home/arm64/projects/kernel/linux-stable/mm/damon/sysfs.c:2027:33:
error: implicit declaration of function =E2=80=98damon_free_sample_filter=
=E2=80=99;
did you mean =E2=80=98damon_sysfs_set_sample_filters=E2=80=99?
[-Werror=3Dimplicit-function-declaration]
 2027 |                                 damon_free_sample_filter(filter);
      |                                 ^~~~~~~~~~~~~~~~~~~~~~~~
      |                                 damon_sysfs_set_sample_filters
/home/arm64/projects/kernel/linux-stable/mm/damon/sysfs.c:2032:17:
error: implicit declaration of function =E2=80=98damon_add_sample_filter=E2=
=80=99; did
you mean =E2=80=98damos_add_filter=E2=80=99? [-Werror=3Dimplicit-function-d=
eclaration]
 2032 |                 damon_add_sample_filter(control, filter);
      |                 ^~~~~~~~~~~~~~~~~~~~~~~
      |                 damos_add_filter
cc1: some warnings being treated as errors
make[5]: *** [/home/arm64/projects/kernel/linux-stable/scripts/Makefile.bui=
ld:287:
mm/damon/sysfs.o] Error 1
make[4]: *** [/home/arm64/projects/kernel/linux-stable/scripts/Makefile.bui=
ld:556:
mm/damon] Error 2
make[3]: *** [/home/arm64/projects/kernel/linux-stable/scripts/Makefile.bui=
ld:556:
mm] Error 2
make[3]: *** Waiting for unfinished jobs....
  CC      kernel/time/timekeeping_debug.o

I am analyzing the source code while I am correcting the errors.

Thanks,
JaeJoon

>
>
> Thanks,
> SJ
>
> [...]

