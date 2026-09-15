Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D783FC88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 21:23:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 667766B0095; Tue, 15 Sep 2026 17:23:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 619706B0096; Tue, 15 Sep 2026 17:23:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4DEEE6B0098; Tue, 15 Sep 2026 17:23:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0CF3E6B0095
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 17:23:19 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4AE311C217B
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 21:23:18 +0000 (UTC)
X-FDA: 85217272476.01.860397C
Received: from mail-pj2-f0.google.com (mail-pj2-f0.google.com [74.125.227.128])
	by imf27.hostedemail.com (Postfix) with ESMTP id 5592640006
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 21:23:16 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YSc6Uzer;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.227.128 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YSc6Uzer;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.227.128 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789507396;
	b=rrn5/PEizZDbMgRbRIUu5I4DA+zUeKgDG7GtIBoIMOMAFpDoATC1/9nEtinojzzB/SDxPT
	efktfvZtsF7v7g8ZXj0lj4DN6fUQ7HiHIwlvNcnFHglq3+UH7IE52nMpQD6F6y28odaRhQ
	GD5CWMTIJZ4jbq4k6bXsK67PBM36buU=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789507396;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ggXSmmaqXxJmZmyEEnELS4VnH3S1nhVp5LDpJiqFJcg=;
	b=VeZCwJbF+bIRYYGL9+G46pO4iKhtohA+VA5U8trm6XF4OVWAaumSrChmrVrGXWcO+/mNJV
	+w7x/L4XyIUyNIjAKqxigkTkAA657M6P4Djdlo16i8xYzU0LdMoDaIhh9T3Eu44W6ygrAX
	SNqBTBcySlFAzO3bxxcYWZjOZT9lSsY=
Received: by mail-pj2-f0.google.com with SMTP id 98e67ed59e1d1-39e0e245eadso365781a91.0
        for <linux-mm@kvack.org>; Tue, 15 Sep 2026 14:23:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789507395; cv=none;
        d=google.com; s=arc-20260327;
        b=iW9jeec6ynT3UFJ27f0Cvx6afM7FW6g8QrZlGrwP4MaC9dS4W66o7fulCs5ux+orfu
         b3LPtmwGHtUFTgrpffjJRsx4QwlqPZtiOA0SanDp3lHgU8fob4W2QK73R5bL4qYAR9le
         fYkHART11hNfh6lU6Mo6e2UBI5PxKLoA/c2ofi3xz0XceyeT849fUCvTUxxyW8N19XG0
         5+B0Zz22i9xVdiawSQ808I2JLYNsl2aFXBt1wqhTM+KkErhpeTn5t7pTKdTOhiTE3MOr
         9Udxki97Dv0zW1EOcIWgvn3uPQ2E0WOf1iRX380uFRYQCwQzYHmWVtalT0hA455LYh6B
         Eeww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ggXSmmaqXxJmZmyEEnELS4VnH3S1nhVp5LDpJiqFJcg=;
        fh=S/k0WpJUzvybyJpRx9q680uQCrxieHZ/1yLT7ip1ukc=;
        b=Mn/wZObWJaZ8xc3v4PnfX40iMTu0JiVC8XPdWc6SQ/4k0UTVvvxmV23G80SU/D3aYG
         /jrkfcvEW2ZmFKwLGRwjs5KXtHTtquPnC7SZctQI2E4zoVOzfad45ujQcFC+9MReClCl
         iHq12aztD/hdqjS2wxZWjqzmeMzWavAE6BQ61ln7RTqHFns6KyaHWGxWdGFyCWHTiplW
         onkGp3NH1d20b3AT4r4+VRkCtA7SAFwY7k+UqlmKthet6QAZJdrwjDdhUcYqrXPG0SOo
         haaj0lGneuAgxg7BB7wg4Q8sLAFcJz7ZxH9eksIhrcPReW+PlrJMYAo+Ka8oHobQE8Ae
         4LNQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789507395; x=1790112195; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ggXSmmaqXxJmZmyEEnELS4VnH3S1nhVp5LDpJiqFJcg=;
        b=YSc6UzerarNmGRv24pzEDkUIrVFIjQ0r3fJiKnJHHj74Swkg6WgymIv79R22VD7qb4
         3ID3aU23eV7NKv3Ju9ojd1WnqwdA0MB5fZ3RVHjY9zrMAgKv+1SkA8VlukNfiKuazOYY
         /ssYdbafGPSL8VpdLXCXikwPcKmrI1llOi0q2KspXYbHDhY3UK96xgzWFBzywfqsFml/
         9V37aXwHWOookAJOi7G2Ws1kIgE7QQ7rYiCfaLw5HFtOIS+Gvl3dqrZN7JkaHkZDvS0H
         3OlAlpM+J1q0lPAr9N9cHDo/HHf0E6HMBUUfLHRlzwWdQSb1HmsxfFI90s/5o4EZlDfS
         ORaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789507395; x=1790112195;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ggXSmmaqXxJmZmyEEnELS4VnH3S1nhVp5LDpJiqFJcg=;
        b=RPXHTwkCfm3Ko7gafnMsqJ4CcBfJcIoM1hWadBTiR6YXC9fw5NKlKUVzH+GBIIIREt
         acdKcsxd9w1emEfL+mkzW58DNuEsIUt2Miu8zsQlYwHRu+9kUA9hl75AduAXHewoJQ06
         R+4R95uyly+56NxWRcSc35/mOnCFaYCMrxXjNV9sN0idzgCro2jO7b6IAV7FRepVldOU
         x6ZkNNWB5EJlk7N4MkTIy9lHLhvCWzw1FxEeOayzqtP+wi/jN/76+pKlFlgkjGGxSD1Q
         /dzGVCioyBMCNskD5uVR0xRvljjLwtMYQ/aKFeL15XIC+S9Cqj4UhxwhoKU24ZON4Tt+
         neWA==
X-Forwarded-Encrypted: i=1; AKwUvByaxpAnyZbetgwNExH4183ar1IQ6ayXrIAqPN1Cd1PeFkP/sDXmG+phZhf9xszSHBDghmn/VZj9Xw==@kvack.org
X-Gm-Message-State: AFuF++mabp+AfPMk7zZpRZ6/Z2fU1+y+R13L+15dTbNnP3yMeW6liV6F
	TEvKWr8vlW4nxBEF6+fxYcpYym/1aUuxZt3JaS1YxtrXERCOcsCzEpZfEqaZOd2HgcWUrj4L1km
	z16Rux1eF1uZOruVrCapwSst9wYt7AQ==
X-Gm-Gg: AYBFou0/2ySskeTwz9tp1TFGvADxvjldgfLvSIaZ/l9ERm5IXgqjc/4b1Q4juEFEH4t
	Kt7sOXq/UsrQvsChJ5W8w4PTV5AfG+fjYYZrgYCB31DoN4MQHexkkE6NS1yF5V+6CbDKQ2LMFdt
	oeiTA7DXbMptiu3d2GjHdn1vJINOiiYK9yaxuXlu+lKF5c+G0F3J1g5dfd3DMZAPtsM3GacxUUA
	UOM0N6StUVDHIAFIwypsI7QsrYF5Rn954TN+gXZelvM/VM5dBCUWwoxypbWRvPBnLKMwNhpafYk
	+krp8PjIkqRqAvLCITqB0P/OeHgENK9msnqNelnrlbvTq7mlTSO+TfxSvcQpj0TzGW4z
X-Received: by 2002:a17:90b:4a4f:b0:398:e86b:ce14 with SMTP id
 98e67ed59e1d1-39e1e4d045cmr332125a91.20.1789507394586; Tue, 15 Sep 2026
 14:23:14 -0700 (PDT)
MIME-Version: 1.0
References: <20260910171623.6638-1-ravis.opensrc@gmail.com> <20260912013802.145542-1-sj@kernel.org>
In-Reply-To: <20260912013802.145542-1-sj@kernel.org>
From: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
Date: Tue, 15 Sep 2026 14:23:02 -0700
X-Gm-Features: AcwNN1UWpnG1ASQHTQ5ufzTIe4rJL-EJ8cBe-1duGGeZFeYkxlcPh6wvbE3YUbM
Message-ID: <CALa+Y17GK7TQHA5FyoMdnOFM1Y38g7P9qc-nMgP-dO4zfRj8Ug@mail.gmail.com>
Subject: Re: [RFC PATCH v2 0/9] mm/damon: hardware-sampled access reports
To: SJ Park <sj@kernel.org>
Cc: akinobu.mita@gmail.com, damon@lists.linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	akpm@linux-foundation.org, corbet@lwn.net, bijan311@gmail.com, 
	ajayjoshi@micron.com, honggyu.kim@sk.com, yunjeong.mun@sk.com, 
	rientjes@google.com, weixugc@google.com, jic23@kernel.org, gourry@gourry.net
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 5592640006
X-Stat-Signature: afh6k435e19ctjsaizpbqx6gpx1twok9
X-Rspamd-Server: rspam01
X-HE-Tag: 1789507396-668411
X-HE-Meta: U2FsdGVkX1/ybjxBCzLKevbhtZGSS60s4DsUz7TuRvJQrXyi4q1fEQprcXF73s3Qa6wF5Hhi1hfg8aJhFTOgu2TxpBc5cGFJ9nn6skYUh7JmPnbpJVIrrH1qpyD/bBrtBEq6ktkh/uOibK7ICepSqfUT8vW1iYemqApdN3XHag9fIXSGM3HS6IwQV2Pk8vPZfmSdX62cxfaqOe6SXBW6S3yClsRlw+zl7QuD9JuO6HbdBQKCbhCMBCvWmHkd7XcXn+NbHE1jne6YsCyBWD2MjIKyFSB4Tm758dk24mVyRFWRXUXs3Z7dVt/UDhyjVIrjIrJJip00roP350a07ioLmE1urh2MCKB/oBdN0jR05N2gZVtiOanTdXmXZpsr4GV8cCccGLSYSQSXPlkbRM4qU6kWa0uS0ncJQfGM0z11lLRPBXoI24KOPqRo8/ma5UkBkMvpk4V8hWsinjmlHDSRhh16yxYka5VoGmp8YvSI3hpBfY3pbT7OirnY5LEea00rtr45pWv8nRe2XGIMhssDyQ7VC5hg7hgvqsawmh8AyCIk8lgpNuvQj9qd4g4iQt/QftGctVpaCiO9cNcNqUAl8Fmvxj+C5fJCYe6ALj3LiV7P8Aof7j6wSxJoyzYkxQ1JP95oT7SnWngKws0gOdMytiY4vK4DAUM7Hd/dg4cykcL4uHCVdonWqsNVgfRrqE/xHl745F5+MLsBF6/D++0fuj9YVsBGCHG+V3vzReoQEgozccqwvMrINcJiv+8lbLzXchWLJjVMpio/K9FOqceclsx4FQjC6gaklD9GZUdxE28XVmyYwyPiRwXEpV78z8IBh1vTGYWRkDbtICBLPXj9DuukL6hTVbmQbL7+V2njtmB0tvOirYUFaIVi245ozRotRGSedSdeeu6PCQwCEUwJRugP/w7/2ZWmZZXE7+p6EM5Cdp/w3l5ciSM7swlPZ+TfYiL/TOXqXE+lCxabiaY
 OfaStv9U
 qQiDwuHH7rvEicq2ddEFU9njU/VtY0QZ/CXozDRlFVcFlL/7pnCntXN16DJiWDXYOO5YSH9JDtX0uHGNOLCnCJEMgcCOG+Pa6D1ieeKoNITUC2O0KHHxi0fvNgc9w63Z2bu1w2IJhdPb2CkHK+7a9QMJOYact5rtCeEYrCHWrqkhLz3CZzuDiJmgjbrqRr6oumyDTlZUfkjaHHUMtqEfLzzcwQHu/8BwSKfMrrqsXLMFM0b2EgAaNy8Y5iZddHmq7XEpNq7poMtmEhYtUiehtsDlzWBKdVQqLGqzSaKY5kz5nIsdeCY4XBfzNT1wzDM8yvq1GsptX653xaXT7jyEcHtspks2DP2q38FyuxS5RyK2j+aZ07uedCZ6Ef3JKvnoeOkuyoBGNrLzYS+83v1OegAewd3iVaoaF7r6MW0BDu/4aQ/gBj7nBoNt8l3P32MOPjk0HSHK90ItTMDriy/DsdAWEh32Ll5NHATMdaQLjiJCurZHsBliMuMMsZz+vwrUWDQtIoN35LY2tcgcTPrr+Y2IWYaLT3ZZ3HwSuK3k2KcOJ1lgErl7jaNnZs/2Apdp/My+gxloyL0gxiChIE9ziP3V/6fpETB0yJVDjz1ONCeUebLQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 11, 2026 at 6:38=E2=80=AFPM SJ Park <sj@kernel.org> wrote:
>
> Hello Ravi,
>
> On Thu, 10 Sep 2026 10:16:14 -0700 Ravi Jonnalagadda <ravis.opensrc@gmail=
.com> wrote:
>
> > This series lets DAMON take its access information from a hardware samp=
ler
> > instead of from a page-table scan, and lets a scheme's score be weighte=
d by what
> > that sampler reported.
> >
> > The change from v1 [1] is that it is now built on the data attribute pr=
obe
> > infrastructure that has since landed in mm-new: a PMU is expressed as o=
ne more
> > probe on a context, with its own weight and probe hits, rather than as =
a
> > mechanism of its own beside the ops set.  The rest of this posting is t=
he same
> > substrate reworked onto that, plus two consumers.
> >
> > This is not a merge request.  The series is based on damon/next at the
> > base-commit below, which moves, so the tree it was built and tested fro=
m is also
> > on
> >
> >   https://github.com/ravis-opensrc/linux/tree/damon/perf-rfc-v2-09-06-2=
6
> >
> > It is posted for design feedback, on the substrate and on where it belo=
ngs in
> > the roadmap for extending DAMON beyond the pte-accessed bit [2].  That =
roadmap's
> > second milestone, now open, is a first data attribute monitored through
> > `damon_report_access()`, and that is what a sampling PMU is here.  So t=
his
> > series keeps that function and its callers and replaces its body: the r=
eporting
> > path a hardware sampler needs cannot take a mutex, and the drain has to=
 reach a
> > virtual-address context as well as a physical one.  The shape of the ri=
ng, the
> > drain and the sysfs surface are what is most useful to review.
>
> First of all, thank you very much for sharing this great series.
>

Thanks SJ for the detailed review and the milestone 2 / phase 3 clarificati=
ons.

> I think the high level direction, especially utilizing data attributes
> infrastructure and interface is good and aligned with our beyond-page tab=
le
> accessed-bit plan.
>

Good to hear.

> Nevertheless, this version is highly ambitious, optimized and big.  We wi=
ll
> land only essential parts in milestone 2.  The goal of milestone 2 is onl=
y
> essential functionality.  We will further extend its functionality and op=
timize
> its performance, in multiple and parallel steps, in the phase for the
> milestone 3 (or, simply phase 3).
>
> I understand that's also what you are aligned with.  And you had to post =
this
> big series mainly because we just started milestone 2, and therefore you =
have
> nothing to really base on.
>
> Let me further provide some comments including what looks especially big =
and
> optimized to me, and how those could be split into small pieces.
>

Very much aligned. The comments below help a lot in identifying what
is essential
for milestone 2 and what can wait for phase 3.  v3 will be scoped according=
ly.

> >
> > ## Why a unified perf-event substrate
> >
> > DAMON derives its access information from the PTE Accessed bit.  A samp=
ling PMU
> > carries what that bit cannot: which addresses the hardware went to, and=
 how
> > often it went there.  Many machines already have such a unit, and more =
than one
> > kind of it, so what this series is after is letting DAMON's regions be =
tuned
> > from whichever perf-based hardware source a machine offers rather than =
from the
> > Accessed bit alone.  A sampler does not arrive on a kdamond's terms, th=
ough: it
> > delivers an address when the hardware decides to, in NMI context, with =
no
> > relation to the sampling interval and no mm to walk.
> >
> > The alternative is a backend per PMU vendor, each owning its own config=
uration,
> > sysfs knobs and lifecycle.  The perf-event direction [3] avoids that: l=
et DAMON
> > register kernel-counter perf events and consume samples from any sampli=
ng PMU the
> > perf core already knows about.  This series follows it, adding one subs=
trate below
> > the ops sets rather than an ops set per PMU -- a report ring that any i=
n-kernel
> > access source can push into, and a drain that folds those reports into =
region
> > probe hits on the aggregation boundary the kdamond already has.
>
> This perfectly aligns with the plan.  We will use perf event abstraction =
for
> AMD IBS-like h/w features based access monitoring primitives.
>
> > What running it
> > across vendors needed on top of that direction is:
> >
> >   - per-CPU lockless rings between the NMI sample handler and the kdamo=
nd drain,
>
> I understand we need to make it lockless.  I wonder if we have to make it
> per-CPU.  I understand it will be better in terms of performance, especia=
lly on
> machines having many CPUs.  That said, this feels like somewhat we can di=
scuss
> in phase 3.  And it would deserve to have sufficient discussions and
> performance evaluations.

The per-CPU structure is not a performance optimization we can defer -- it
is required by the calling context.  A perf-event overflow handler runs in
NMI context, which cannot take a mutex or any sleeping lock.
damon_report_access() takes a mutex, so it cannot be called from there.
Per-CPU SPSC rings are the correct primitive for a lockless producer (NMI
overflow handler) to consumer (kdamond drain) handoff, not an optional
improvement over a simpler shared ring. I am planning to retain per-CPU
rings for v3 because of this reason.

>
> >   - a ring partitioned by probe class, so the page-fault primitive and =
a PMU can
> >     populate one context without either seeing the other's reports,
>
> This also feels like something that we can discuss later in phase 3.
>
> Particularly, page-fault primitive is out of the scope of milestone 2.  T=
he
> path forward and the timeline for it are quite unclear as of now.  It req=
uires
> alignments with other subsystems that would be challenging and taking tim=
e.  I
> have a very rough plan to try it again with read-write protection, though=
.  I
> think it might be safer to just keep it out of the scope of your project =
for
> now.

Understood.  I included the page-fault source in v2 because the December
2025 RFC [1] that introduced damon_report_access() had it as the primary
consumer, and I wanted to carry forward that ability.  Since it is out of
scope for milestone 2, I will drop it from v3.

Patches 1, 2, and 3 will be dropped from the v3 submission since they are
all tied to the page fault path.

>
> >   - per-CPU events that follow CPU hotplug, armed when the kdamond star=
ts and
> >     disarmed and drained when it stops,
> >   - a per-PMU owner, so two contexts cannot claim the same PMU type,
> >   - whichever address a PMU does report carried on the report and match=
ed
> >     against the context's own address space, so one source serves a pad=
dr or a
> >     vaddr context without a backend per address space.
>
> These all soudns making sense to me.  Nonetheless, I think we can scope
> milestone 2 to support only physical address and defer these things to th=
e
> phase 3.
>

Got it. Will scope v3 to PA only. so included results for v3 would be based=
 on
AMD IBS testing.

> >
> > This is tested with PEBS on Intel and IBS on AMD, both configured as `p=
erf_event`
> > attributes on a probe and using the perf core's event plumbing rather t=
han
> > per-vendor MSR code.  A third source has already been written against t=
he same
> > ring: Kunwu Chan's ARM SPE backend [5], which reaches it through an AUX=
 buffer
> > drained in process context instead of an overflow callback, and which t=
he
> > roadmap [2] places in its third milestone.
>
> Awesome, appreciate your huge effort on this!
>
> >
> > The partitioning is what lets promotion and demotion run in one context=
.  A
> > sampler says which regions are hot; it says nothing about which are col=
d, because
> > a sampler that reports nothing about a page cannot distinguish untouche=
d from
> > unsampled.
>
> I'm not really sure.  I think absence of samples for an address range can=
 also
> mean the address range is cold?  Actually the page table accessed bit bas=
ed
> monitoring also use a sort of sampling, so I don't show real distinction.
>
> Maybe you're right, but I think this deserves sufficient discussions and
> testing that we could defer to the phase 3.
>
> > Region age is what a demotion scheme matches on, and age comes from
> > the page-fault primitive.
>
> We would have age in perf event based mode, too.  Isn't it?
>

You are right.  Region age accumulates whenever nr_accesses stays at zero
across aggregation boundaries, and that holds whether the zero comes from a
PTE scan or from an empty perf-event drain.

I was initially concerned that a sparse sampling PMU might not cover every
cold region in every aggregation window, leaving silence that could be
mistaken for cold,
whereas page faults provide higher spatial coverage for confirming
first-access.  Having both together was intended as a defence against that =
gap.

Based on your observation I retested this on hardware.  On AMD Turin
the cold demotion scheme found and demoted the idle working set
correctly using only the hardware-sampled IBS signal -- nr_accesses aged to=
 zero
for regions that genuinely had no traffic, and the scheme acted on age as
expected.  The combined design may still be worth exploring later when
page fault
is considered to be reintroduced in phase 3.

> > With the ring partitioned by class both are live at
> > once: the probe supplies hotness, the primitive supplies age, and two s=
chemes
> > over the same regions can move memory in both directions under one kdam=
ond.
>
> Unless the needs are clearly confirmed, I'd prefer having single class fo=
r
> simplicity.
>

With the page fault primitive out of scope there is no case for two ring
classes.  I will prepare v3 with a single class.

> >
> > The two classes are not symmetric, and the asymmetry is in where a repo=
rt comes
> > from rather than in what it carries.  A page fault has no monitoring co=
ntext at
> > report time, so a per-context ring is not expressible for it: those rep=
orts go to
> > one global set of per-CPU rings, drained by the single context whose pa=
ge-fault
> > primitive is enabled.  A PMU overflow handler does carry the context th=
at armed
> > the event, so those reports go to that context's own per-CPU rings and =
each
> > context drains only what it owns.  Both classes share the ring layout a=
nd the
> > producer side, so the barrier pairing cannot drift between them.
> >
> > ```
> >   page-fault report                    PMU sample, NMI context
> >   no ctx at report time                handler carries the owning ctx
> >           |                                     |
> >           v                                     v
> >   +----------------------------+       +----------------------------+
> >   | one global per-CPU ring    |       | per-CPU rings per context  |
> >   | set, shared by every ctx   |       | that armed a perf event    |
> >   +----------------------------+       +----------------------------+
> >   | drained by the one ctx     |       | each ctx drains only the   |
> >   | with the pf primitive on   |       | rings it owns              |
> >   +----------------------------+       +----------------------------+
> >           |                                     |
> >           +------------------+------------------+
> >                              |
> >                  drain on the aggregation boundary,
> >                  each report matched to a region
> >                              |
> >              +---------------+---------------+
> >              |                               |
> >         region age                    region probe hits
> >         demotion scheme               promotion scheme
> > ```
>
> Again, I'd suggest to simply ignore page-fault report for now.
>
> >
> > That is the property this series exists to enable, and three things fol=
low from
> > it:
> >
> >   - One measurement drives both directions, at whichever scope the mode=
 gives.
> >     Bandwidth comes from resctrl MBM, which is where the discussion on =
a
> >     platform-independent bandwidth signal for tiering has pointed [6]: =
a
> >     virtual-address context reads a monitoring group created for the pr=
ocesses
> >     it monitors, and a physical-address context reads the root monitori=
ng
> >     group, so the same controller is scoped to a set of processes or to=
 the
> >     whole machine without changing what it does.  Reading it there also=
 means a
> >     bandwidth allocation reserved for an application bounds what the co=
ntroller
> >     optimises within.  It spreads the hot set across nodes in the ratio=
 that
> >     maximises achieved bandwidth when bandwidth is what the workload is=
 short of,
> >     and it demotes cold pages off the near node in the same context at =
the same
> >     time -- either proactively under a fixed quota or only once DRAM is=
 under
> >     memory pressure.  Neither direction is configured as a target ratio=
; the
> >     proportion or weight the controller writes bounds how much memory m=
oves while
> >     the score decides which pages move, and a hardware sample makes tha=
t score
> >     proportional to the traffic a region generates rather than one bit =
per page
> >     per scan.  Earlier work on bandwidth-driven interleaving [4] measur=
ed the same
> >     effect from userspace.
> >
> >   - Bandwidth and capacity are expanded at once rather than one being c=
hosen.
> >     Static weighted interleaving expands bandwidth, but it is a placeme=
nt rule
> >     rather than a decision about any particular page, so cold pages kee=
p their
> >     share of DRAM.  NUMA balancing expands usable DRAM by promoting wha=
tever is
> >     hot, but it does so without reference to what the far node can deli=
ver, so it
> >     keeps promoting after the near node has stopped being the better pl=
ace to
> >     read from.  Here the hot set's distribution comes from a bandwidth
> >     measurement and the cold set is demoted on region age, in one conte=
xt, so the
> >     far node's bandwidth is used and DRAM is not held by memory nothing=
 is
> >     touching.  The decision itself is a quota goal the kernel already c=
arries:
> >     `node_eligible_mem_bp` [8] bounds how much of a node a scheme may f=
ill, so
> >     what the controller supplies is the bandwidth measurement, not the
> >     placement.
> >
> >   - When bandwidth is not the constraint it reverts to latency-first ti=
ering on
> >     its own.  The search starts with everything on the near node and mo=
ves memory
> >     outward only when the measurement improves, so on a workload that d=
oes not
> >     saturate that node no step outward improves anything: the hot set s=
tays in
> >     DRAM for the lower access latency and cold pages keep being demoted=
.  The
> >     same configuration covers both cases, with nothing to switch on and=
 no ratio
> >     to revise.
>
> Sounds very interesting.
>
> >
> > ## What the series adds
> >
> >   1. `mm/damon/vaddr: support page fault access check primitive` -- imp=
lements
> >      the page-fault primitive for a virtual address space context; it w=
as
> >      available for physical addresses only.  The marker whose fault rep=
orts the
> >      access is installed through the target mm and the vma of the sampl=
ing
> >      address directly, and prepare_access_checks() dispatches on the en=
abled
> >      primitive as the physical address space one does.
>
> As I mentioned above, I'd suggest to keep page fault primitive out of the=
 scope
> for now.

Will do.

>
> >
> >   2. `mm/damon/core: read the CPU number with preemption disabled` -- t=
he report
> >      path runs in fault context, which is preemptible.  Read the CPU nu=
mber with
> >      preemption disabled and keep it disabled across the report, so the=
 recorded
> >      CPU stays consistent with the per-CPU ring the report is queued to=
.
>
> Sounds good and will be needed for milestone 2, too.  I will reuse or ref=
erence
> this in my milestone 2 implemenation.  This will be very helpful, thank y=
ou for
> sharing.

Glad this is helpful.

>
> >
> >   3. `mm/damon/paddr: lock the folio for the page fault primitive rmap =
walk` --
> >      take the folio lock unconditionally around the walk, as the other =
reverse
> >      mapping walks in DAMON do, so every mapping type reaches it locked=
, and
> >      release the reference the lookup took on each exit path.
>
> Again, let's keep page fault-based monitoring out of the scope for now.
>

Understood. Will do.

> >
> >   4. `mm/damon: add damos_node_eligible_mem_bp tracepoint` -- a per-tic=
k
> >      tracepoint over the node-eligible-memory quota goal evaluation, ex=
posing
> >      the goal's target and current values, so the loop a bandwidth-driv=
en
> >      controller steers is visible to a tracer.
>
> This seems doesn't need to wait anything.  If this turned out to be helpf=
ul,
> please feel free to separately send patches for this.
>

Yes. It is quite useful to track goal convergence. Will send a single patch
targeting mm-new.

> >
> >   5. `mm/damon/core: add per-probe-class report rings and unified drain=
` -- the
> >      substrate.  Per-CPU SPSC rings an NMI-context source can publish i=
nto,
> >      partitioned by probe index into a global page-fault ring and a per=
-context
> >      perf ring, plus the kdamond-side drain that matches each report to=
 a region
> >      by binary search over a per-target snapshot and credits it to that=
 region's
> >      probe hits on the aggregation boundary.  The address space of the =
target
> >      selects which address of a report is matched, and pid targets are =
filtered
> >      by thread group id.
>
> Sounds like good optimizations that we can discuss with tests in the phas=
e 3.

Ring will remain single class for milestone 2 as page fault stays out of sc=
ope.

>
> >
> >   6. `mm/damon: add perf-event overflow handler feeding the report ring=
` -- an
> >      ops-agnostic perf-event source whose overflow handler turns a PMU =
sample
> >      into a report, setting each address field the PMU reported as vali=
d.  A PMU
> >      that reports a virtual address only can therefore drive a virtual-=
address
> >      context, one that reports a physical address a physical-address co=
ntext, and
> >      the same source serves either without a backend per address space.=
  Per-CPU
> >      events are armed and released through cpuhp callbacks, and a per-P=
MU owner
> >      keeps two contexts from claiming the same PMU type.
>
> This should be what also essential for milestone 2.  I will reuse or refe=
rence
> this in my milestone 2 implemenation.  This will be very helpful, thank y=
ou for
> sharing.
>
> Nonetheless, virtual-address context considered parts may be skipped in
> milestone 2.  We can discuss such things in the phase 3.
>

Got it.

> >
> >   7. `mm/damon/ops-common: use probe-weighted score when probe weights =
are set`
> >      -- lets a scheme's frequency subscore come from the probe hits, we=
ighted per
> >      probe class, so what the sampler reported reaches the tiering deci=
sion.
> >      With no weights set the subscore comes from the access rate as bef=
ore.
>
> I'm working on adding more attributes-only mode (probe weights are set) s=
upport
> to DAMOS.  Hopefully we can converge on this.  This is not a part of our
> planned milestone 2, but I will keep doing this in parallel, so hopefully=
 full
> DAMOS support for attributes-only mode will be done around end of milesto=
ne 2.
> Let's keep discussion on the works.
>

Sure. will track changes around this on damon/next and lore postings.

> >
> >   8. `mm/damon: add perf_event prep for PMU-driven hotness probes` -- t=
he sysfs
> >      surface and the event lifecycle: a perf_event prep action carrying=
 the PMU
> >      type, the event config and the sample attributes per probe, with p=
er-CPU or
> >      single-instance arming depending on how many counters the PMU need=
s.
> >      Arming is deferred on a context built for a commit, so a weight-on=
ly commit
> >      leaves the running event untouched.
>
> This is also what would be essential for milestone 2.  I will reuse or re=
ference
> this in my milestone 2 implemenation.  This will be very helpful, thank y=
ou for
> sharing.
>

Good to know. :-)

> >
> >   9. `mm/damon/tests/drain-kunit: kunit for report rings and unified dr=
ain` --
> >      unit tests for the rings and the drain: inject and drain, overflow=
 on wrap,
> >      producer routing by probe index, ring partitioning, pf-ring owners=
hip,
> >      thread-group filtering, the address space match, and both primitiv=
es live
> >      on one context.
>
> Testing is always important and nice.  Thank you for doing this.
>

Thank you.  The kunit coverage will be updated for the simplified v3 scope.

> >
> > Patches 1-4 apply standalone on damon/next and are useful without the r=
est;
> > 5-8 are the substrate and its first two consumers, and 9 covers them.  =
If the
> > first four read right, they need not wait on the rest of this series --=
 happy
> > to repost them on their own for damon/next if that is easier to take.  =
Two of
> > them, 2 and 3, correct code that is already in mm-new rather than addin=
g
> > anything new, so they could instead go as a small fixes series carrying
> > Fixes: tags; guidance on which of the two routes is preferred is welcom=
e.
> >
> > ## Userspace setup model
> >
> > The runs were driven by an `auto_tier` subcommand added to damo on the =
branch
> > below, which reads achieved bandwidth from resctrl MBM and searches for=
 the hot
> > set's distribution that maximises it, while the demotion scheme runs al=
ongside
> > it in the same context.  That tooling is not part of this posting; it i=
s on
> >
> >   https://github.com/ravis-opensrc/damo/tree/damo/auto-tier-bw-2026-09-=
08
> >
> >   - `--bw_source resctrl` is the option this adds: the controller reads=
 achieved
> >     bandwidth from an MBM monitoring group and searches, rather than be=
ing given
> >     a distribution to install.
> >   - Everything else -- intervals, schemes, filters, the probe's `perf_e=
vent`
> >     attributes -- is what the generator writes from the command line sh=
own: 5 ms
> >     sampling, 100 ms aggregation, a 1 s ops update.
> >   - Both configurations select proactive demotion, so they demote conti=
nuously
> >     rather than waiting for pressure, and both were left closed loop th=
roughout.
> >   - The search is the algorithm described in [4].
> >
> > ### Configuration A: AMD IBS Op, paddr ops, system-wide
> >
> > ```
> > $ sudo mount -t resctrl resctrl /sys/fs/resctrl
> > $ sudo python3 tools/damon_tier_gen.py --hotness ibs \
> >         --near_node 0 --far_node 4 \
> >         --cold_demote --cold_demote_mode proactive \
> >         -o tier.yaml
> > $ sudo damo auto_tier tier.yaml --bw_source resctrl --verbose
> > ```
> >
> >   - Scope is the machine, not a process set.  The distribution is steer=
ed
> >     through `node_eligible_mem_bp` quota goals over each node's own phy=
sical
> >     ranges, which the generator reads from `/proc/iomem`.
> >   - AMD Turin, DRAM on node 0 and a CXL node.  IBS Op at a `sample_peri=
od` of
> >     262144 with `sample_phys_addr` set, which is what a physical-addres=
s context
> >     needs from the sample.
> >   - Workload is a hot-and-cold mix so both schemes have something to ac=
t on:
> >     `multiload` drives the bandwidth-hungry hot set, and a second proce=
ss
> >     allocates on the near node, touches it once and goes idle, leaving =
pages
> >     that age out for the demotion scheme to find.
> >
> > ### Configuration B: Intel PEBS L3-miss, vaddr ops, per-PID
> >
> > ```
> > $ sudo mount -t resctrl resctrl /sys/fs/resctrl
> > $ sudo python3 tools/damon_tier_gen.py --hotness pebs \
> >         --pid $HOT_PID --pid $COLD_PID \
> >         --near_node 0 --far_node 1 \
> >         --cold_demote --cold_demote_mode proactive \
> >         --min_nr_regions 1000 --max_nr_regions 20000 \
> >         -o tier.yaml
> > $ sudo damo auto_tier tier.yaml --bw_source resctrl --verbose
> > ```
> >
> >   - Scope is the processes the monitoring group names and nothing else.=
  The
> >     distribution is steered through the hot scheme's `DamosDest` weight=
s [9].
> >   - Intel Granite Rapids, DRAM on node 0 and CXL on node 1.  PEBS L3-mi=
ss at
> >     `sample_freq` 5003 with `precise_ip` 2.
> >   - Same workload shape.
> >
> > ## What the runs show
> >
> > Per-node reference, each figure measured by binding the same workload t=
o one
> > node:
> >
> > ```
> >   Granite Rapids, 64 threads x 8 GiB
> >     node 0   1.0 TB DRAM      DRAM only   269,885 MB/s
> >     node 1   2.0 TB CXL       CXL only    249,903 MB/s
> >
> >   Turin, 32 threads x 4 GiB
> >     node 0   386 GB DRAM      DRAM only   113,596 MB/s
> >     node 4   1.0 TB CXL       CXL only     33,253 MB/s
> > ```
> >
> >   - The two machines differ in the way that matters: on the Turin the f=
ar node
> >     is 3.4x slower than the near one, on the Granite Rapids the two are=
 within
> >     8%.
> >   - Each configuration gets one graph, the climb: the run itself, one m=
ark per
> >     decision taken from the bandwidth just measured, with the share it =
moved to
> >     under each mark.  The settled line below it is the median over the =
samples
> >     the run went on to hold at that share.
> >
> > ### Configuration B, virtual-address mode
> >
> > ```
> >    MB/s                                                       climb
> >    460k |                                                          *
> >    440k |                                                      *
> >    420k |                                                  *
> >    400k |
> >    380k |                                             *
> >    360k |                                       *
> >    340k |                             *    *
> >    320k |                        *
> >    300k |              *    *
> >    280k |          *
> >    260k | *   *
> >          --------+------------+--------------+---------------+---------=
---+--
> >                  1            4              7              10         =
  13
> >                  92           80             68              56        =
   44
> >                      decision index, near-node share (%)
> >
> >    settled        share 44, 430,547 MB/s held
> > ```
> >
> >   - Thirteen decisions to settle at 44%, no target given: about 60% mor=
e than
> >     the better of the two nodes on its own, and the share does not chan=
ge again
> >     over the 81 samples that follow.
> >   - Cold demotion runs over the same interval, in the same context, act=
uated by
> >     the same kdamond: 34 regions totalling 15.4 GiB applied, and the id=
le
> >     process ends with 4,099,980 pages -- 15.6 GiB -- on the CXL node ha=
ving
> >     started on DRAM.
> >   - The promotion scheme's applied byte count is flat across the demoti=
on ramp,
> >     291.1 GiB before against 291.3 GiB after, so the recovered capacity=
 is the
> >     demotion scheme's.
> >
> > ### Configuration A, physical-address mode
> >
> > ```
> >    MB/s                                                   climb
> >    136k |
> >    134k |                                        *     *
> >    132k |                            *     *
> >    130k |                      *
> >    128k |
> >    126k |                *
> >    124k |
> >    122k |          *
> >    120k |
> >    118k |    *
> >         +----+-----+-----+-----+-----+-----+-----+-----+--
> >              1     2     3     4     5     6     7     8
> >              92    88    84    80    76    78    80    78
> >           decision index, near-node share (%)
> >
> >    settled        share 78, 134,107 MB/s held
> > ```
> >
> >   - Eight decisions to settle at 78, from a start with almost everythin=
g on the
> >     near node: the same algorithm reaches the optimum share on its own =
from the
> >     bandwidth reading alone, and cold pages are demoted to the far node=
 while it
> >     does so.
> >   - A distribution beats either end because both nodes supply at once: =
at the
> >     settled share the near node is supplying 104,618 MB/s against the 1=
13,596 it
> >     reaches with the whole working set bound to it, so the further 37,6=
69 MB/s
> >     arriving over CXL is bandwidth it could not have supplied at any sh=
are.
> >   - The idle process ends with 2,863,156 pages -- 10.9 GiB -- on the CX=
L node,
> >     out of the 32 GiB it allocated on DRAM and stopped touching.  Resid=
ency is
> >     the attributable figure in this mode rather than a per-scheme appli=
ed count,
> >     because the schemes share physical ranges.
> >
> > ### What the runs are meant to establish
> >
> > Not the settled share and not the absolute bandwidth; those are propert=
ies of
> > these machines and these workloads.  What reproduces is:
> >
> >   - A controller reading achieved bandwidth converges unattended, from =
a
> >     configuration naming no target, to a distribution that beats either=
 node on
> >     its own, and holds it once found.
> >   - A demotion scheme recovers near-node capacity in the same context w=
hile that
> >     happens.
> >   - One code path does both, steering `node_eligible_mem_bp` over physi=
cal
> >     ranges system-wide on one machine and `DamosDest` weights over a na=
med
> >     process group on the other.
>
> Nice testing and measurement, thank you for sharing!  I'm happy the futur=
e
> DAMON could help this!
>
> >
> > ## Beyond a CPU PMU
> >
> > Nothing above is specific to PEBS or IBS.  A source qualifies if it can=
 report
> > an accessed address to the ring, which is the only thing the substrate =
asks of
> > it.  A CXL device's Hotness Monitoring Unit, whose r3.2 perf driver has=
 been
> > posted [7] exposing its hotlist through an AUX buffer, or a custom moni=
toring
> > unit on an accelerator or a memory expander, reports exactly that, and =
a
> > backend delivering those reports through a perf event reaches the same =
drain,
> > the same probe hits and the same schemes already in the tree.  Such a u=
nit sees
> > the traffic that reaches its own device rather than a system-wide view,=
 so what
> > it contributes is the hot set resident on that device: the tiering logi=
c can
> > promote those pages to DRAM without the host having to detect that hotn=
ess
> > itself, and without depending on what produced the reports.  That posti=
ng names
> > driving tiering from such a unit as the intent and the in-kernel step a=
s future
> > work, and consuming it as a DAMON access-check primitive was raised the=
re as
> > one way to get it; a backend on this substrate is that path.
>
> That makes sense to me.  Thank you for sharing this nice survey and theor=
ies!

Thank you.  Looking forward to seeing DAMON grow to support these use cases=
.

Summary of what v3 will contain (5 patches, former patches 5-9 of v2):
  - paddr-only, single ring class, no page fault primitive
  - per-CPU rings retained (required by NMI calling context, not an
    optimization)
  - perf-event overflow handler (paddr path, vaddr parts deferred to phase =
3)
  - sysfs/lifecycle surface
  - probe-weighted score
  - kunit tests updated for the simplified scope

Separate send targeting mm-new:
  - tracepoint (former patch 4)

Thanks,
Ravi

[1] RFC PATCH v3 00/37: mm/damon: introduce
per-CPUs/threads/write/read monitoring
    https://lore.kernel.org/damon/20251208062943.68824-1-sj@kernel.org/

>
> >
> > [1] v1 of this series
> >     https://lore.kernel.org/damon/20260529165640.820-1-ravis.opensrc@gm=
ail.com/
> > [2] Roadmap for extending DAMON beyond pte-accessed bit
> >     https://lore.kernel.org/damon/20260525225208.1179-1-sj@kernel.org/
> > [3] mm/damon: introduce perf event based access check
> >     https://lore.kernel.org/damon/20260423004211.7037-1-akinobu.mita@gm=
ail.com/
> > [4] B. Tabatabai, R. Jonnalagadda et al., "Bandwidth Speaks, We Listen:
> >     Dynamic Interleaving for Tiered Memory", ISMM 2026.
> >     https://dl.acm.org/doi/10.1145/3814942.3816137
> > [5] mm/damon/perf: add ARM SPE AUX backend
> >     https://lore.kernel.org/damon/20260816142222.689624-1-kunwu.chan@li=
nux.dev/
> > [6] A platform-independent subsystem for bandwidth information, and res=
ctrl
> >     as that source
> >     https://lore.kernel.org/linux-mm/d952a84f-332e-8f7a-4816-2c1cbd8f5b=
00@google.com/
> > [7] CXL Hotness Monitoring Unit perf driver
> >     https://lore.kernel.org/linux-mm/20241121101845.1815660-1-Jonathan.=
Cameron@huawei.com/
> > [8] mm/damon: add node_eligible_mem_bp goal metric, merged for v7.2
> >     https://lore.kernel.org/linux-mm/20260428030520.701-1-ravis.opensrc=
@gmail.com/
> > [9] mm/damon/vaddr: allow interleaving in migrate_{hot,cold} actions, m=
erged
> >     for v6.17
> >     https://lore.kernel.org/linux-mm/20250709005952.17776-1-bijan311@gm=
ail.com/
> >
> > Ravi Jonnalagadda (9):
> >   mm/damon/vaddr: support page fault access check primitive
> >   mm/damon/core: read the CPU number with preemption disabled
> >   mm/damon/paddr: lock the folio for the page fault primitive rmap walk
> >   mm/damon: add damos_node_eligible_mem_bp tracepoint
> >   mm/damon/core: add per-probe-class report rings and unified drain
> >   mm/damon: add perf-event overflow handler feeding the report ring
> >   mm/damon/ops-common: use probe-weighted score when probe weights are
> >     set
> >   mm/damon: add perf_event prep for PMU-driven hotness probes
> >   mm/damon/tests/drain-kunit: kunit for report rings and unified drain
>
> As this series is for high level discussion, and the code will significan=
tly
> changed after rebasing on milestone 2 output, I wouldn't go deep into eac=
h line
> of the code for now.  Feel free to let me know if you want.
>
> >
> >  include/linux/damon.h        |  136 ++++-
> >  include/trace/events/damon.h |   32 +
> >  mm/damon/Kconfig             |   18 +
> >  mm/damon/Makefile            |    1 +
> >  mm/damon/core.c              |  995 +++++++++++++++++++++++++++----
> >  mm/damon/ops-common.c        |   21 +-
> >  mm/damon/paddr.c             |   37 +-
> >  mm/damon/perf_source.c       |  489 +++++++++++++++
> >  mm/damon/perf_source.h       |   54 ++
> >  mm/damon/sysfs.c             |  266 ++++++++-
> >  mm/damon/tests/.kunitconfig  |    4 +
> >  mm/damon/tests/core-kunit.h  |    2 +-
> >  mm/damon/tests/drain-kunit.h | 1091 ++++++++++++++++++++++++++++++++++
> >  mm/damon/tests/perf-kunit.h  |  133 +++++
> >  mm/damon/vaddr.c             |   83 ++-
> >  15 files changed, 3220 insertions(+), 142 deletions(-)
> >  create mode 100644 mm/damon/perf_source.c
> >  create mode 100644 mm/damon/perf_source.h
> >  create mode 100644 mm/damon/tests/drain-kunit.h
> >  create mode 100644 mm/damon/tests/perf-kunit.h
> >
> >
> > base-commit: e1f34dce183a96fc93bf9a42dcdc0ec0bf82a3d2
> > --
> > 2.43.0
> >
> >
>
>
> Thanks,
> SJ

