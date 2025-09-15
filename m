Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7DA78CAC597
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 23:11:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D09798E000E; Mon, 15 Sep 2025 19:11:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB96C8E0001; Mon, 15 Sep 2025 19:11:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA88A8E000E; Mon, 15 Sep 2025 19:11:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A63F48E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 19:11:10 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6B05211AD3E
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 23:11:10 +0000 (UTC)
X-FDA: 83893032300.21.AD55660
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf26.hostedemail.com (Postfix) with ESMTP id 8E652140006
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 23:11:08 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=oatDdQyx;
	spf=pass (imf26.hostedemail.com: domain of kaleshsingh@google.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=kaleshsingh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757977868;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XsKsrMGZGN6//cTNQ+8/HyCAfqvHtLWhWR4uwDDiSCM=;
	b=Yykdby/oQYUBbWgQsMCTcwm+EyhQTOeDJeir05AWfuRc4e3DhcpotxxIdBb3ymiZ+1Ev7E
	8MGXNb7tPk9i1rR2PdvSU7V9tuZjoaxV9AK6LzahWFqLYhJNpdTVDc/xQDdDUd8FbgeewP
	R5666AsiMZH44ZRsl1yNIDfGteeq4Hs=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=oatDdQyx;
	spf=pass (imf26.hostedemail.com: domain of kaleshsingh@google.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=kaleshsingh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757977868; a=rsa-sha256;
	cv=none;
	b=CYSXspVxijuS/MDM/cVAVNfRxbWt9BkGO30jVHEnNkjJAEF+BrLiZQF3GPwSibbTpW7kPX
	gdM3SzNR3tyL/u1Q5PHK+HIdwAvLZP20S06hmOO/MFZMH3VjGNefZ8eyP/4DiKrERx2/34
	eio4xlAxYCRFlZMMxgfqUxvbGVqB74M=
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-267c90c426dso35845ad.1
        for <linux-mm@kvack.org>; Mon, 15 Sep 2025 16:11:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757977867; x=1758582667; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XsKsrMGZGN6//cTNQ+8/HyCAfqvHtLWhWR4uwDDiSCM=;
        b=oatDdQyxu3HC+1LBk7THY0/nQueozX00czMukLuDBotBPGeHCncQox4h9piKpGhMnw
         OacpzsMc2yzqkb1I9ks6Rz1O6qrzYPxSuOWUbwUGaTPZn93b5O1BqeKnCAJtoNaBMZG7
         ESxqi+EY5Qh6TkXTmfwRDwrAj9SdbYW+pkt2okuCo3wlz3vB22vaZISa5DUg5SAqoZD8
         MHfpRtuEBKfJRiIN2CZ/x3TpOJ5jl+jVfIngh7D46vZml1GOX2ZQCYiw1zl3pfgsd2UX
         UJvYCoNV0/wIChJ5QUn+rwJy0uCqjP/AIYRQnHJ4gOYn9ttub/mdHdALKV6VxJPmtF6/
         UdNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757977867; x=1758582667;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XsKsrMGZGN6//cTNQ+8/HyCAfqvHtLWhWR4uwDDiSCM=;
        b=NgFO4DCzkXpzw1d4xfsVV6czDt1nOzkaiBW5YIr9/YIqblPji0gTpcNIjqfrbQowKG
         tbwGIRR88Wv8ngNa96+ztQ7YWN5u3m8r0wHE6itByrG58hgeclrC1YV5sNw2YTiviwTb
         xb7QioK0k+ZsqyU2kZFTL5mfHLCPbescDg6P/IJX70Z2m47TSglNRRcB6ctY/6goJ31O
         HGabu5p+3ogeaaeMxOtBR67D1v+tQ7Tus6l04P2ihMIpCsdtg53DVzm4fOoJsZA8mMmZ
         0a09dnw+27HN/B8una9zhomBUk3zC7Ycp4xiiU3zgCFMr7zgjH585CbLikg2mXBLt0vQ
         cqyw==
X-Forwarded-Encrypted: i=1; AJvYcCX875HiyBi3lJNo/5Mtn7o1RnDbwir6hkkyC7V7CN2xLzTxsktqpW3aagphOcMjHurD61BhCcsO9w==@kvack.org
X-Gm-Message-State: AOJu0Yybv8LPbGUUNeknxGnj6c/+flm2Ks/tf6kolKeZvnZIIqDE4pnA
	MbzkL3haEnLklB5+ifZMEGnlkSAUXB+VLnLCJyjIZIvAZoQapflzVPpxAcBydySOwN71VvmEu/X
	CJaHLkvWBpi2Okuncr2EsyoO26MfiZlmoHboJvyzB
X-Gm-Gg: ASbGncu6EVaC8rAQK4lkrp0ch04YTYtuXdYMc7cUmJ1cn269mg3siGbc6kjexSuiNot
	Q/FUnGrOZRm6bpnd/NmyYvhyylk7UBoWUrbDRLBTWNui402rxrBdL3KQ0+vP+2n/iwBVuQSj6GV
	cYQW5e1nzX/iKfV5Fr89ao7VwKsalDFcQ8THC5ycEnBw1AUfJz9cd9NgUlrEyHxmkaUal2sOgTj
	8UF0O/qEhp3zB5YiZ+/4FBnjgnLeYt2XZAoWGdxxzPkp9HhNKhL3EE=
X-Google-Smtp-Source: AGHT+IEkitpGEz8BMKWmLGPZ3W85vqrSP9MG29lIbMnJb9upndiATYfQPV08S+weYTCqY9YvT87o5wWIohG6pp/8rq4=
X-Received: by 2002:a17:903:181:b0:246:a8ac:1a36 with SMTP id
 d9443c01a7336-267c1903062mr2169965ad.2.1757977867063; Mon, 15 Sep 2025
 16:11:07 -0700 (PDT)
MIME-Version: 1.0
References: <20250915163838.631445-1-kaleshsingh@google.com> <20250915153401.61cbd5120871ee7a4e5b9cae@linux-foundation.org>
In-Reply-To: <20250915153401.61cbd5120871ee7a4e5b9cae@linux-foundation.org>
From: Kalesh Singh <kaleshsingh@google.com>
Date: Mon, 15 Sep 2025 16:10:55 -0700
X-Gm-Features: Ac12FXwVYGcBZT9d6NPCct-EK04uGWSzFyRbMpRKe55ZXQp9Zltcw49n-TJl9YM
Message-ID: <CAC_TJvd=zwhRZcXTvDPfuzdjYV7j_jvZKZ--eKDRTsE+LBmASA@mail.gmail.com>
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
X-Rspamd-Queue-Id: 8E652140006
X-Stat-Signature: qy3x1du7ohrn7sioxfrpxrkkc1fx587d
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1757977868-651589
X-HE-Meta: U2FsdGVkX1+QKtE6RlW3tvw0IrzlTfY8v4dlDYANG3l86S8Ze8Pq8P1MaScTW+l3UkKjKOrhRu8tBJa1mAykERUyvs5sUXcHa0bCdZr6kST5YPSlI7gUzl1rjya1RYVX2VmX/BQhygoeLocXrTJ83D4g65SGCVQhj6aWZt759ZnNoK0mh1365ax7ocBUH/sQvPD+aBWUTh55Xaw8+jPg6Y9cSzitg+b44kusb1SCUX5AfnGn+DAQM9C7oIUJLyJHRAy8q2w/FFVeXupAfuf50X2IL64G1f+hOLLWSAWICiKqCrMJ3ORmC84nZSYJrO5lLKWrdT2vLBspuMxSrqq3vCgZtB7D3nyAF3Hry9GtasojEnaMH4uqp8gklRThZEvpXSTnmJWxNTk39f+QxZVUvzSvFVeXoQx4DT2GdC5PPwx8RFYbaU/c9INrtdFhuwse5VUh/LxS+iT8Xan4t3HgVbqbO1QUYTzF867648SYBNNKs37/KLU/rdPLK9XT9F8meXzwPgTJQ9fdjVZPRyVXvV5IEvCJ+sxuP6vt2aO8Ka04Ivl5m7wtZUbaivORsK33JPphs5neS0eNP3UPLvstjXX23sifQ81ITpHCHekNOemRZTKTA8fU37YFA2SToloGbcIYUhGqhTfHjGtSHJR7Drank/KlqEXkDAzad3z1OFixsLNJaFsl7F5U0hlOp8qXejpx5+4bEkcCtzPAlteM4ttWXkrT1CCFV+g5Ol7mFle4dvJG2T2eup/j0hLUMbfX/u/hBbXAHUtQk2Jpq/J9DxrKJWLLLs4DyM8D1VkzcJksaTuU5HoZaNZiuT2aAuhLr7ymDpn0hmbP8LzJROA+FMdd5Ope/yxxl5GBGb3QvcXX6EIa9Y2VG6oPLoZi4U3lY93yXiY4krFr7QjG92Y0l5AlUxUKfp/8dWTQDBYfUfQQ5bi3UR8QVop+Or4dH3CAT6Q4qqnZ4LH4d3LGwox
 NX9V/cBn
 Xp4Y/OWuk4LPP9ZB9AvENC/7ULzpxklOndzb+Q3Z7FcRbEnZ1i/KIBbBElOWcpl+O8qZ4Ci52/Zrvm10NTiStGKQkgtPQ3loBQD9p/rdpt0KAfUX8YMCxB9AsVl+rOlGUrCBRxaQZyPIc+4jKExUeARzUPMQfKXxn1ROIwNCkDys4AQsUQx8Lr2gfYNzYZLs3ffEafrVB6x4EhDcgW/iELBd1Q+SmgEjW6Hp2gXbuQxVPXFpACDmFjGT1NMfCo1mR/hqBWYNEu96eJdGivizQoQSn4U1HaWDCE5KK9KmPxLapKdE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 15, 2025 at 3:34=E2=80=AFPM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
> On Mon, 15 Sep 2025 09:36:31 -0700 Kalesh Singh <kaleshsingh@google.com> =
wrote:
>
> > Hi all,
> >
> > This is v2 to the VMA count patch I previously posted at:
> >
> > https://lore.kernel.org/r/20250903232437.1454293-1-kaleshsingh@google.c=
om/
> >
> >
> > I've split it into multiple patches to address the feedback.
> >
> > The main changes in v2 are:
> >
> > - Use a capacity-based check for VMA count limit, per Lorenzo.
> > - Rename map_count to vma_count, per David.
> > - Add assertions for exceeding the limit, per Pedro.
> > - Add tests for max_vma_count, per Liam.
> > - Emit a trace event for failure due to insufficient capacity for
> >   observability
> >
> > Tested on x86_64 and arm64:
> >
> > - Build test:
> >     - allyesconfig for rename
> >
> > - Selftests:
> >       cd tools/testing/selftests/mm && \
> >           make && \
> >           ./run_vmtests.sh -t max_vma_count
> >
> >        (With trace_max_vma_count_exceeded enabled)
> >
> > - vma tests:
> >       cd tools/testing/vma && \
> >           make && \
> >         ./vma
>
> fwiw, there's nothing in the above which is usable in a [0/N] overview.
>
> While useful, the "what changed since the previous version" info isn't
> a suitable thing to carry in the permanent kernel record - it's
> short-term treansient stuff, not helpful to someone who is looking at
> the patchset in 2029.
>
> Similarly, the "how it was tested" material is also useful, but it
> becomes irrelevant as soon as the code hits linux-next and mainline.

Hi Andrew,

Thanks for the feedback. Do you mean the cover letter was not needed
in this case or that it lacked enough context?

>
>
> Anyhow, this -rc cycle has been quite the firehose in MM and I'm
> feeling a need to slow things down for additional stabilization and so
> people hopefully get additional bandwidth to digest the material we've
> added this far.  So I think I'll just cherrypick [1/7] for now.  A
> great flood of positive review activity would probably make me revisit
> that ;)
>

I understand, yes 1/7 is all we need for now, since it prevents an
unrecoverable situation where we get over the limit and cannot recover
as munmap() will then always fail.

Thanks,
Kalesh

