Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 429DACAC597
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 01:23:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F0B68E000A; Mon, 15 Sep 2025 21:23:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C8868E0001; Mon, 15 Sep 2025 21:23:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DEEB8E000A; Mon, 15 Sep 2025 21:23:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7BB9C8E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 21:23:25 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0FA19C055F
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 01:23:25 +0000 (UTC)
X-FDA: 83893365570.11.13AEAEF
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf28.hostedemail.com (Postfix) with ESMTP id 31CD2C0005
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 01:23:22 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=bmPP6Mrq;
	spf=pass (imf28.hostedemail.com: domain of kaleshsingh@google.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=kaleshsingh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757985803;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FjrtyNvBONcUNbfRSx61Tjsk25VZay7l9mmVDCH4H9g=;
	b=VlgUQwY+iFNYaA1AagiyVpyoGaZ6vs4qsYVDYYPSnxQDX2tl+rylqZQAtY0E5Nz8Pxw1qk
	gz+BD2FZ/881xYZM/SuSdOHTPzL1epCxPfAOSGiawft0TFwVJDxYSjPDrBINzq8GUx4pbP
	Lffr9nBVt8FMAPBcqp239/hCxn/5hNQ=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=bmPP6Mrq;
	spf=pass (imf28.hostedemail.com: domain of kaleshsingh@google.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=kaleshsingh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757985803; a=rsa-sha256;
	cv=none;
	b=oHiiLi4+5DfrSb/DPTlwtlIeicg3QwFkbzICtDxcAyGDKdCp1Kn6vH2NhFVtFKzNBggd+u
	ycRaYiY0Nvrh7ZKzzJKNkcrlNPJcTTv3h7JUXl9y2nl7RSVHjh0eRk9g97xJd6cmQEPCz6
	pf2kKRBR3xG6xPWrtkrn/4jsD/bHJVA=
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2637b6e9149so59645ad.1
        for <linux-mm@kvack.org>; Mon, 15 Sep 2025 18:23:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757985802; x=1758590602; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FjrtyNvBONcUNbfRSx61Tjsk25VZay7l9mmVDCH4H9g=;
        b=bmPP6MrqLmoWQaIPdptHPyQTECCyHYQc6gwgS8RAYig4xjSsGEOZ26iMvT+KhAJ8EQ
         0y26tSJ+khgnLZYNv8KsvzqXgRMZ4gcnNnehccZpE2ryRsxLISZmDusAvXPGA2NprcNm
         qixcZtmdQqgrZjm6vQqg5rMQ4/aFOUR76wr90rvoSv51w7KGGMizEQHOoTp1+9Q0eTBK
         XVpbSs2o7H3t5rNDyfSJqr5yn4wF6+6e02gPX7GinW4TqQjjyRkpjUK6PChsfP5+vYG3
         U9eU0i9JrtFGhq8f2I8JyUIW9N99EjUQL66fHfBCghBu/3WRYGbUtsx9w5MLeGhwsaVV
         +gsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757985802; x=1758590602;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FjrtyNvBONcUNbfRSx61Tjsk25VZay7l9mmVDCH4H9g=;
        b=P49Xfwhn9+cdh77pzYYzqRUFtdsddkxFVbK3WWil26fI2yXle/s04O5ZS3NMvmtcns
         Ktm4m7BmUGsdR0ToiuIcqzG61LqM5KH2Ak/fFza8nIL4DWug5YntnLgcpuWA3u1+BJ1M
         h95q3cpKatJExV/30bfD4J248TiddzwManIPf1jzeFEqTIlEf38MH5rpA0CQORotrzXk
         jxXJMZTXkTBPNSPFNXFIlka/I/y6CXqhAv3h7SGjyhvy/TPyBiYrJU5tDpz6P2R5DJ36
         2AyKL3vI1uRs0NfwcU31mvysLzz7fFjC8R23vd5XZTgNMupdBM2qRqAXwrkiObaWBevL
         bupA==
X-Forwarded-Encrypted: i=1; AJvYcCXKN9Gt+VohhCZ5NIIdvnwhOkKVseoiccKSDxd/K1Hd0U+WCZByGDfBNOjyuol/zzcJsKElpxIldQ==@kvack.org
X-Gm-Message-State: AOJu0Yy55sohDWThflou37/DcJwd9WwktxhrfLz4FgZtSW+8Lrl1044D
	B7OHJ6nmozziiEkNSvA1+a3kRjZs34y/ymfrk9xPASHIF4lnK/mrjhPKsN1xtp9qdmz2MxHaJLx
	cQBJdtDCBTTOZfuaQnQ/vSPL3kKUy76Lu5eVgEJaY
X-Gm-Gg: ASbGncuRTYPxoIUzXTmioqM2T1ZovrIArV+IdbvDfz8sXxv2FkOdSpHMwaN2m8XnsAj
	1PoDmhFFNHDn4Dqj8NKK5obinIUI8dsc92zhwf7Z+aI+dTHwr3/usWJUkIw6ffnfViN3qlK2KHd
	Jj4gZUXL8rJBhdo5m//EkGOBsMd2fdaP2YgQjCIizB0a2ZM3oVfrKjzV3oXqpYSyVAfYQY2cq+u
	D23ab8oGaMBZUY9qZmqe2Nnz3vPkWC+kdMQvK4ZNE1B
X-Google-Smtp-Source: AGHT+IF9+835PR8promdp069Tski48d465PNsDSz2RlGOWqnfbXegmXvA9IiYNUJE4/C+ZSOfFmqDmuCCV/FlktNcas=
X-Received: by 2002:a17:902:f547:b0:246:1f3e:4973 with SMTP id
 d9443c01a7336-267c1a5d5dfmr2675725ad.6.1757985801735; Mon, 15 Sep 2025
 18:23:21 -0700 (PDT)
MIME-Version: 1.0
References: <20250915163838.631445-1-kaleshsingh@google.com>
 <20250915153401.61cbd5120871ee7a4e5b9cae@linux-foundation.org>
 <CAC_TJvd=zwhRZcXTvDPfuzdjYV7j_jvZKZ--eKDRTsE+LBmASA@mail.gmail.com> <20250915170550.f24bfb96514835154e8d1633@linux-foundation.org>
In-Reply-To: <20250915170550.f24bfb96514835154e8d1633@linux-foundation.org>
From: Kalesh Singh <kaleshsingh@google.com>
Date: Mon, 15 Sep 2025 18:23:09 -0700
X-Gm-Features: Ac12FXwhWVu02OL4G53WutcplFT1I0VgCrjVK0f-v6OHM6tMSRuAEDbNEvAgPPY
Message-ID: <CAC_TJvef-jLQm_H2kd9FX9WprMThZv8MvgxAuJeceG-qpRwryA@mail.gmail.com>
Subject: Re: [PATCH v2 0/7] vma count: fixes, test and improvements
To: Andrew Morton <akpm@linux-foundation.org>
Cc: minchan@kernel.org, lorenzo.stoakes@oracle.com, david@redhat.com, 
	Liam.Howlett@oracle.com, rppt@kernel.org, pfalcato@suse.de, 
	kernel-team@android.com, android-mm@google.com, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Kees Cook <kees@kernel.org>, Vlastimil Babka <vbabka@suse.cz>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
	Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, 
	Dietmar Eggemann <dietmar.eggemann@arm.com>, Ben Segall <bsegall@google.com>, 
	Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>, Jann Horn <jannh@google.com>, 
	Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 31CD2C0005
X-Stat-Signature: mbfp5orcqby33nc8n44p5o4yyb6jwith
X-HE-Tag: 1757985802-874444
X-HE-Meta: U2FsdGVkX19aqepWNBrwcn086tVhR8XVEnoW3UVkvIP6ee/4Jtu/hC6svi9m8ALXLZEgURm09hnWAs8ywVpgqVbQaoeryhUqVHrDDe9XzNkpGr7hCEsKQu4Ctcf/aTAYcXIKbUnjCo22TDdMb0ctDdECb1vr69Hm+OijLS7KvvQQRoy1Ed42XhVzWBRlJbhWHtYowpOmDaWfY10qWGEWw5x4k+Kwt5NJrbMwTFXJdb3cnOzQ6ZU8wDZ/8Ip+LPJurHkzulr3BjsvuQJukeNo8L6xDKYLt18h/RwZGUqrUA06/HEOB2S1TqOjyRJVvbzKmsSzSmeeCKd3YKLChVKJotLMDwsrDTfKPnTrplwNF+CkvjDKvRepaPEqMayrXjEaHAnvadp/mHqs3n7SOi8HeYIIlmJ0t/4GEQRaKiZjRE1PM+z6ljz4NeTPVpkGXtoavqu8IlX56pBpFI96QgblcSIRUYtr0zbo3T6PfaHt5TlAcO9im7rTQsktoQS3zBXql9Ib08LKRqTC7tgbin5rrOtxMlsHrg6dqy/tonaz56ZPYVCOHrp7LG0qAyIXTtJhr0K9R65P9uGr648ILVsE7c76MolRPnbshBtnng5P59c1HFHEGLS2vn/jU18EdqqqaG/ypgvVFc1qZqMNUbLyVqeM664lOMNNZCEagO9hjHg9QB34T4ISs07Iiilr8CcNJrdx1/KNwsORuelwhts+s0lXObgFdU+HMag7L7jd1zS5QpgqKQUAuHhLieZE/lTCDHVmEG7bE6CoD3BNO4Vfc4kHEhoXHrRp9aypo8oFw2d3J6hdsTHlt1pC5GpR6X/D0hk9Brk34GfPi+9DTZlzPYAXl52iHexUiNJLDdrEtgBJ3KAAs1DbgUU1gV5PFuf7KfWko5MEYnKvLqCDT67kuSve7DExFx3hr7rxDKfPnyx0qlkonsiGtEexhCuIrL9b4VZVM4OmmuRGIu6KJ4E
 AWU6wCXq
 8RGfYMaHvVEB7tiCWQ/TZ4SQodEUxVe6nZszLr1SNSPD78b8j26RvJzaJOIfOUt7Jk9Skjf97niyyuXqs36x3K6QwoBDAu04KsAOuAZRn9dFYpcg3W9owdd5eD9vZuT/V697jP0ERGdtJUb3MRvajfGXgqQzxeYe4xY7dXpNLvp9eZfupvikIM2sVoAUNZOkClDFeAJgtXDwjDKgsDUPjsihKKxwKzjHj3KJgyiS0GqGdK9xegmf2N4y376hMoT8QKWg1gcnUOuXnbQ82jxgJbfUoEw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 15, 2025 at 5:05=E2=80=AFPM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
> On Mon, 15 Sep 2025 16:10:55 -0700 Kalesh Singh <kaleshsingh@google.com> =
wrote:
>
> > > fwiw, there's nothing in the above which is usable in a [0/N] overvie=
w.
> > >
> > > While useful, the "what changed since the previous version" info isn'=
t
> > > a suitable thing to carry in the permanent kernel record - it's
> > > short-term treansient stuff, not helpful to someone who is looking at
> > > the patchset in 2029.
> > >
> > > Similarly, the "how it was tested" material is also useful, but it
> > > becomes irrelevant as soon as the code hits linux-next and mainline.
> >
> > Hi Andrew,
> >
> > Thanks for the feedback. Do you mean the cover letter was not needed
> > in this case or that it lacked enough context?
>
> The latter.  As I've split up the series, please put together some
> words to describe the remaining 6 patches if/when resending.

Hi Andrew,

Thanks for clarifying. I'll make sure to fix that when resending.

--Kalesh

>
> Thanks.

