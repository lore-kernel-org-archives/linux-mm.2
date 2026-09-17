Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 949C5C88E72
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 16:57:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3006C6B009B; Thu, 17 Sep 2026 12:57:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D7E06B009D; Thu, 17 Sep 2026 12:57:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1EEC46B009F; Thu, 17 Sep 2026 12:57:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DB2EC6B009B
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 12:57:40 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 41ED0A59B1
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 16:57:40 +0000 (UTC)
X-FDA: 85223860680.02.33424BD
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	by imf31.hostedemail.com (Postfix) with ESMTP id 3F86820007
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 16:57:38 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=qDgVshHa;
	spf=pass (imf31.hostedemail.com: domain of surenb@google.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789664258;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2P1jqMeXt2U4DYONaAJvtCjY2qdlqYJMUv9Wm8If7S4=;
	b=ONnkWMMh3VIooyxdDI/BP9dgbspqt8JmGx8gd20SYmxQre9N2bEl3NQBZRv5phKgm1PF8e
	1CBR3fTcIKmdzdHQMFZZ4XyDuBIknoKPZ2zCyI/VB3aX2CEd59DBiS8+OtBkxIRysnL50e
	YjsXEmMA+gIc+5VtVjXY296ZVlfqens=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789664258;
	b=RTZwKw4PWdNPneafpNz4RRQvPI3jiU3Gz8GqkEwfT2w3UK0g1XMaKeSlVhhQzctgCVpOF7
	FsNZLYHnEwnURBzkyM1ffhusCNmePxcYXRIJzRxLY0fuP7H7XlZBQBDm71RdH+1jT3zOC8
	ZiyHvKanSDFWhA8bRsz5WkgcKRnO+D8=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=qDgVshHa;
	spf=pass (imf31.hostedemail.com: domain of surenb@google.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-6a5f95a879cso183a12.0
        for <linux-mm@kvack.org>; Thu, 17 Sep 2026 09:57:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789664257; cv=none;
        d=google.com; s=arc-20260327;
        b=WGMSjZCjBUvzUHpUieS5OQ8Cz1q5PwhwdJ2li5euforfj5GnnCwM6I+D0Rva6Vo73l
         yDaDc4KtQTThV6QVR7l6wz2TgDkCVia/OqVyBHP7L6e/yZuwWxWsEMBNWO0IR5Z5W3Hj
         4/rEmuae6ADii8bfAebjrEpOL2uBndNXXeDQhSC3S6tuFF9jYWaQlNd1fUxrMYwdJxNm
         EX/2kvvuWhMP3hUvk1OH+6LDdUuNaFxxeV6dKLzNO0hFgVpHn4vH9+ZXN8rcVQwOL9Ks
         runvjEsyaMHCEnjXLB7vnv8VmTxGnub6J9CPU31y2Qqe3oWSMDjqrgRJ+r3Na7GemwFn
         b1dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=2P1jqMeXt2U4DYONaAJvtCjY2qdlqYJMUv9Wm8If7S4=;
        fh=udtXQ2GdOHsgRoc/8Hskr5lWy2EYJ5/4EEjXO2VISv8=;
        b=UHeihd4dSEyyZ/c/DtLaT9OErzLor2G6niwDCnDjEWp5+LcbzzucpvTS0tPJ7YCFPW
         yiUnprEBBBmMwFaK9S9BDd7ZhpuTkoGGB5bcj5ivMc0FNwZ+RK39dOq/itsPoRWgCgBW
         rtWnmcub+hpRcnnw5Z5G3fh/oLJYswTXb5PfkYO/ChDm2W56Koq5C2zlLraVUbPOdvCi
         cqFccvmi4tIFYrqwfWdKafs20h3M5WJ6mldqi4oXgwsPnHwASWR7e7nF8o++ZlANLfJH
         8wE7pgHoxHZt6wn64V5vFPVcCiV5frtqpFhILQDC4JM92BN7M0RO5k7C30qaMjXrzdMn
         LYXg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789664257; x=1790269057; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=2P1jqMeXt2U4DYONaAJvtCjY2qdlqYJMUv9Wm8If7S4=;
        b=qDgVshHaQyNcbGSMWbnlVKxw//VoVZLioIabGXR5+3B5mt/Chflx/z2c/xllgUIMiQ
         4FQHDOVYjWpcvCaOeSKYyRu41TszsXPF1fPfasjLnEi+gEmDHZM+FNlQu6sIjbi1SrYm
         Bkbe4iMNiXp8E3TC527xPKeTn0IBSDmFX3vc6oGx4rytt4pX2y60r7R7JEvDN3iOBKyF
         fITIaysBV+VcU14bDaS/fIGlK6+8M/VTcyFbsv81io0x1um1NIHvj6wbD8yZgd/xVSkF
         aFVFqq6VCqZSJ+CBR0c0VmBh8rZoVebISY2+mmVxSiD1YjMLtO1QsB3opxRSx6yHu4rm
         OBuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789664257; x=1790269057;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2P1jqMeXt2U4DYONaAJvtCjY2qdlqYJMUv9Wm8If7S4=;
        b=YDWtTs0vTAhkPF7iaodjGQ7sqbeyJbeEZFAjvFhKCIJQn8epyXgo8kNyi2OF6j3gWB
         YbtQ8NFz1FVIBID5DfBXU8NzTP2U7R3ouOKmxqgDC+IlVa1PGGSFOoKBfOnZhAi7blVH
         5nw0L2EJFO0tHhOEbiuK0yHK3AKtfoyR8O61QdLidN+vUq0d1swWT19iURjvoKhzAeOh
         J0/IR2criU1uMEz/alOCpuDaMqOGx73jUEs5NVOqLR+MbzV3EKZJQRB7P2Bn9hXdLIhG
         6IapjfBQ6dC2ChNg2UnOtV4psW4AgFoCeWVGPdivQe/a1+Am/Ydir77NAhRSmcp/byL5
         ePZw==
X-Forwarded-Encrypted: i=1; AKwUvBy7eX5diz84xkjrxJl2qgaJea+SDAfYrEfH3wWKt+avAOWy95nkikuBZGUsVlpPG47/MWgqlpLfbw==@kvack.org
X-Gm-Message-State: AFuF++ntPl9RHVxxroJIfY9l+YxAtTFWu20jaEl5NNn3Lz+PqA2Kvsp2
	cKWglQFtk5ns+5mH7LD+NkNdo2hTCm3991YHOoFwBShaFKKcltXXVeX206iScHwHTpRuax59qgx
	JLHNNbS/Achq49zj8OLmUmRTL3UUDsLtU3gJ5hAewvHSyyE0RT0dWmI0g
X-Gm-Gg: AYBFou1SKiYIK7UVYH7khcHlgGUFGKyCHtunbXwJ4HaKQLHqcFyrXzkj7DLqW0sx1LY
	DzXbLfV+0D8ta3w4oM4v4WuSWUXeG4Ha3Oyd2Lf02z9MzTQe/CPILHK5PUZD8DaJkSAEUCAPONw
	3DXgIoWfLCUmjxfguN2xXMnfUikMDlt3jfLOQutSoWX79Bqc18FhgJVX6cBtpCa3xyOa+xRMCLh
	GyIHlX4b0NA8eSxxrkz76qYjcOUDrtl7F+0sLNGowo2ApqZxxLjmp/hSTluje/KHdLmj6BNjk4K
	cO5Ahv3JPUQqdPGIPOE5jvzaHu6rc62xt3uuSUC+pUxlvvOdebdRarCpwlpxfFHzP/LFOwjFvEN
	3Gi0bD8YQDBs=
X-Received: by 2002:a05:6402:c151:b0:6a9:ce23:5f4 with SMTP id
 4fb4d7f45d1cf-6aa48510e82mr21938a12.5.1789664256309; Thu, 17 Sep 2026
 09:57:36 -0700 (PDT)
MIME-Version: 1.0
References: <202609171758.049ApqPm-lkp@intel.com> <20260917092237.5ba48bf16e8406e3753eacaf@linux-foundation.org>
In-Reply-To: <20260917092237.5ba48bf16e8406e3753eacaf@linux-foundation.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 17 Sep 2026 09:57:21 -0700
X-Gm-Features: AcwNN1U_1b5b73_yN2I2uC_S9n8-m7i3yxOik92aYxPTqmmXK_UGvDhMK1qoGRY
Message-ID: <CAJuCfpG+iqRwjHtH-ZjEpMxWaXkNDTurFjGQbgL4P3RK-3k5SQ@mail.gmail.com>
Subject: Re: [akpm-mm:mm-new] BUILD REGRESSION 892f5b3b07e5b07f2f29c87750ff94fa58dcab73
To: Andrew Morton <akpm@linux-foundation.org>
Cc: kernel test robot <lkp@intel.com>, David Hildenbrand <david@kernel.org>, 
	Linux Memory Management List <linux-mm@kvack.org>, mm-commits@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 65mbgpii4w7em46gyh3sdcrau8mkmhz6
X-Rspam-User: 
X-Rspamd-Queue-Id: 3F86820007
X-Rspamd-Server: rspam03
X-HE-Tag: 1789664258-303817
X-HE-Meta: U2FsdGVkX18LxAldQG5Oyc0Oma4FghHS0fIXAF6ICGmrwJpfrIA8UgteSwBkeygo9rSWOxr8MBcRu9JykS9cIfe8jA+bZVC7ZQFsow7In0YEUDYxGsljPTGjGyM6TM6UO43ScEMvgDmgl0nUfXEbyFLGhU+6wbYAFp+2CRK6rUAsV9Qg9KANxTJhCjfiLR5saf2lVS/1lbe3rzC1Or/2lXsQhsTybtNcdax67QNL8sco8WQvD+uyDwR3SzfuYJy7pDyTg27F6qU/GY2NBsC6ryJ0PJUlLkWKOMG9zlR1QNTJ0pIaopfLAN/grG0G8g3NE7kYbTpM+UNCayEy8aVXDvCsYHK0I/dEQ8DH2YDWG/py+FdIOck6k1vqKwjotpTyoi4fqmiICCxL1ZgEAfRVEWJpKLkfQ/6mxjFCGWHzymV4qgKL7NBGJVuytg9uSWGerJ5Q8dNEY/MuVLdeer46u3VFmIuAU1pfpT3FAm6vyRh4eBwjOiEu9ieZ1JiLGqXK/bJBOAMT4cDQtRA0BCDFnUmIyU+8vYf7l2W7Y/tZFgftkONpRSG1DHookBKNdTRWC6IqHj0zEM/hsOf249kdCzqDIT/zqGXesqPUYSHziEGuC6MsZnWBEVyQMayhdwTDgRQfvmn8h3EMDKhYs8w+XWOqChXiOp/HHe1p8k6whMQL/zF0KNu25PRh2a2W2VmfTG9IGEfPH4kmzAE2T+CYRU7JT8LcMIfRSUoswtha3WyhBjBZrDiFYOC0r2g54jZxry3gAbK0mxgdlkayjJLBn1RxSuBQ7zxUKxNb7RgoaOsgdfXW1YkXXNnovt6ekhtoIDFrqZCI5cwyG0w93SQj2DRYiMpfpIfIX8xW222VavVqeDAX3p94KzBOIE8uedlhb7NgVtakDMxMNmxBve1i9voxjFfgWxlMqqXOIPtPyd6sR8br53LgAGlAccGziiGITAXKT5CvQXEpHGZGXRe
 iB/+73Dc
 ensTc6y0eCBIg2WPmcL0A2NzuwpLLddnvnpA+GS5/Y7ucWA7kdAAJskht0/mbZrFCeI1if39Ai830U7EgUK/5cXK+PctJCREFR2N37a3A5mtiXgZ7U5xTpAVZAvK2mFlexsmNbV7+sE7SgU+TEG3KfW8hBmKtGelZ/DPPpLjtxUW4mkcoDk/RcLxjwTAgzrYx/m065DEWy4zPoPMsXzv2tsKBqodnDOLBJA2fLpTl7dVZqE4SANRvMA1VQahR7rnT5kMlliuX8AuX5r131TiX32uuUL2PlVr5PkMVTeoSJxy2blJogTUfZBOyGjqUzcA/vtQGs9tAcDVh4twgRZ508sgkyFKOxvoD1dqF5GM2hxGoOcPgrPju0Jr/5XhtLF34m2bLO+qwc6rrRjyokY5RXqyn5A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 17, 2026 at 9:22=E2=80=AFAM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
> On Thu, 17 Sep 2026 18:00:02 +0800 kernel test robot <lkp@intel.com> wrot=
e:
>
> > tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.gi=
t mm-new
> > branch HEAD: 892f5b3b07e5b07f2f29c87750ff94fa58dcab73  mm/swap, PM: hib=
ernate: atomically replace hibernation pin
> >
> > Error/Warning (recently discovered and may have been fixed):
> >
> >     https://lore.kernel.org/oe-kbuild-all/202609171159.oaB1OaSG-lkp@int=
el.com
> >
> >     fs/proc/task_mmu.c:3448:3: error: call to undeclared function 'drop=
_rcu'; ISO C99 and later do not support implicit function declarations [-Wi=
mplicit-function-declaration]
> >     fs/proc/task_mmu.c:3450:3: error: call to undeclared function 'reac=
quire_rcu'; ISO C99 and later do not support implicit function declarations=
 [-Wimplicit-function-declaration]
>
> argh, we already fixed this five times.
>
> Confirmed with x86_64 and
> https://download.01.org/0day-ci/archive/20260917/202609171159.oaB1OaSG-lk=
p@intel.com/config
>
> Suren, I'll drop the series.  Please check this (and the 'lock_ctx_mm'
> defined but not used failure) when preparing the planned respin

Yep, I was planning to send the fixed series today anyway. Thanks!

>
>

