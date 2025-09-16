Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0F1BCAC592
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 17:37:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 22D5E8E0006; Tue, 16 Sep 2025 13:37:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DD9F8E0001; Tue, 16 Sep 2025 13:37:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A50B8E0006; Tue, 16 Sep 2025 13:37:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id DEFE98E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 13:37:13 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8A7251DD9EC
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 17:37:13 +0000 (UTC)
X-FDA: 83895819546.10.830EBB0
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf25.hostedemail.com (Postfix) with ESMTP id A23CBA0008
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 17:37:11 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=t9CClTeG;
	spf=pass (imf25.hostedemail.com: domain of kaleshsingh@google.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=kaleshsingh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758044231;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hA74VvTmfLQYH/wAbK7AqscvwtHz9UXBzDQdDDhZ8Jk=;
	b=f/GaIewSIU9Eq3UdOcy0nscc2H6U6wzga5n+/M2Za7EdpIl2O9L5rrvYwM4wNPPqNcLMRu
	qJ5yosD2ML7Fk4/QH8pUz5ETBimX0QZJ//D/kwHzl7UU1NmvvWUy68eSSCb5TXnryPNI8n
	z/mgX69f30HR5NxuTFy5Wq4UD/7y5gE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758044231; a=rsa-sha256;
	cv=none;
	b=AO4TWY3xiZYs+26gYn1wMYgOz1AWIr7nYIhh52wDxWtUfDqS6mdhzA4MDD3yPM5H8QBYPV
	3BOoWro8GGwmclU32MASsGlxV1KHpMcQPiCr+lyg6mQzzvNYBpDeQR09gANfO2dE7IXvhj
	oMYRBpnYcAlLeonaL1txTb6A0rcdI8w=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=t9CClTeG;
	spf=pass (imf25.hostedemail.com: domain of kaleshsingh@google.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=kaleshsingh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-267c90c426dso15705ad.1
        for <linux-mm@kvack.org>; Tue, 16 Sep 2025 10:37:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758044230; x=1758649030; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hA74VvTmfLQYH/wAbK7AqscvwtHz9UXBzDQdDDhZ8Jk=;
        b=t9CClTeG8EAssIpvLOL00pg4y9H81wJ+HSAb7Cnitd/sxnI8Rm5A/N/f0UJN8fT8rf
         QgDDm8lcN9BQwTeRsGxlMp0+4Vvg0JW7+B3AWHhKfjj9Y7eStq7Wc176Hb6u2Vi3y0lH
         nYG/wU//Y2cJoBFy1v/VcxcfXME8XBrI3R3njxaF0sh5KOY7QVvR4FWM1+b/HlBU4tOA
         V98zs4S3HOPt+B7PVbdzFaJR0MeP3cJx4RSpJYT7mew+B6YEh3KwmJlhbsx5BFyTFP1R
         68XZrxefEDPb8AkOmbF8M6QNngeW20OFVdwCMbSv5/5DEf109uTOIicyxRLCw007IFMz
         7Qhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758044230; x=1758649030;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hA74VvTmfLQYH/wAbK7AqscvwtHz9UXBzDQdDDhZ8Jk=;
        b=REvOcx/8Y+9RsJGqz2nCa+MHzvOoYzRVJ8kbUwiJqsDXjekOq0tBeWqlqMC+DWkZN1
         1s8e632N8GMFUYhf9BHOfPhqCyaPkQFLmrzxRsMjtTo/oIza2rjaVpwaXIT3eT26zdpj
         Ycw2RlIq9DdFwijtnZMhRoEyr+qBGN2c1WvozsN6lKtfw2E3YidSaKTHKNBHFlzlc8SQ
         26AmEquxfFKxXot/6hjXa0Zd5OC3YLZfBEo5ymLgzVvXF+QGwGQB4LPXcjf8m0b1y3ia
         RO7jLHkR276NONHFnoBZN97OanEbhRz7vMc18ehVEDjNlJW1UO1VhnfQcWmuQNrTdMEf
         g4hg==
X-Forwarded-Encrypted: i=1; AJvYcCWHlepu2zuX/bQyDMlFXBGIV6N5JSdyIbfqeoVEZYN6QM4wXj2FJaqSFJB3SoxZfB4iMesZ7JuTdw==@kvack.org
X-Gm-Message-State: AOJu0YzSCmTpapcAJTzsiI4A2DtJhH27mkvGsS4Q5EjBk9lrBruSCNjE
	wys3QkZaVIQAI/QsrB5tKx0JEYILy9HgY4PsPcKygfmPj/XRILJsGV32Xy8CXSOaIGQrw9L6BNA
	HfWgfgcpV0mc5FRP61IIpL+TQmaXlh0V7vUeC1yQW
X-Gm-Gg: ASbGncvBKWT6OPI8HnYiwOkYroX1DNpWCg+dBykSfLgUB17Gdakyq6ycMW31x1a8KRM
	fyn7cVgD/quM+FpWjT4khc/if+ZeriibQK3oxQPribBaCFB9ILmmT4mGLxTheXQl0YlijxPB5AB
	fyvH7Gj/Ggm8fgH4H9d8iIEDt9aX+0Al+cZhRMVEKS9QHKLpIwQd1m8KmjI3vBEXTYNLlDCgET4
	QqWdcGhEMK2RNRx4b3QGHnv1hR4+m+aQLPgFdDyNAqxOsIdbJOqf7k=
X-Google-Smtp-Source: AGHT+IEX8t5jebkJIlwMxZnNynAqrdl33amj/WSy/bikpKDzclCAMtzRK9J6Z6CrGhjF/ewhMpAMvfCa6gHuq1eekRA=
X-Received: by 2002:a17:902:e5cb:b0:248:7b22:dfb4 with SMTP id
 d9443c01a7336-26801092aefmr164555ad.16.1758044228996; Tue, 16 Sep 2025
 10:37:08 -0700 (PDT)
MIME-Version: 1.0
References: <20250915163838.631445-1-kaleshsingh@google.com>
 <20250915163838.631445-8-kaleshsingh@google.com> <20250915194158.472edea5@gandalf.local.home>
 <CAC_TJvconNNKPboAbsfXFBboiRCYgE2AN23ask1gdaj9=wuHAQ@mail.gmail.com> <20250916115220.4a90c745@batman.local.home>
In-Reply-To: <20250916115220.4a90c745@batman.local.home>
From: Kalesh Singh <kaleshsingh@google.com>
Date: Tue, 16 Sep 2025 10:36:57 -0700
X-Gm-Features: AS18NWA2d_yigeV8O2eyFGhdEoQ1sMbWT_8VJ2GS10eRsMmT9vFpF8pvM3GYncQ
Message-ID: <CAC_TJvdkVPcw+aKEjUOmTjwYfe8BevR51X_JPOo69hWSQ1MGcw@mail.gmail.com>
Subject: Re: [PATCH v2 7/7] mm/tracing: introduce max_vma_count_exceeded trace event
To: Steven Rostedt <rostedt@goodmis.org>
Cc: akpm@linux-foundation.org, minchan@kernel.org, lorenzo.stoakes@oracle.com, 
	david@redhat.com, Liam.Howlett@oracle.com, rppt@kernel.org, pfalcato@suse.de, 
	kernel-team@android.com, android-mm@google.com, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Kees Cook <kees@kernel.org>, Vlastimil Babka <vbabka@suse.cz>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Ingo Molnar <mingo@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, 
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Valentin Schneider <vschneid@redhat.com>, Jann Horn <jannh@google.com>, Shuah Khan <shuah@kernel.org>, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: ykra1cn1f9p8fkqzxdhjt79xuojhwbjt
X-Rspam-User: 
X-Rspamd-Queue-Id: A23CBA0008
X-Rspamd-Server: rspam10
X-HE-Tag: 1758044231-131873
X-HE-Meta: U2FsdGVkX1+lQqk69bey4FQ5A9mALMK386r65tw4FI1CG1Rl9rhELE7z+njMntHA2WgYjAaDj6lG9BoICQ/eNW4SsJ0wRLW7Z3KXzdYfPwwfvcefMdfzkWYolj+FGfJEJeMIvxZNAGJEcHtETpl07TbGCQjXHb6dQ+VwvxpLYnzA9SfiCnRAee1ySfSPEkaas3vZu1qyF1Nl0eTRlyMoKuDTFBrZvTXdhAONDBVakc5xmQWiCiorcuq+xSIW0Do+RJwLSzQYWMVLy/4Hx4v6MiGtMqkPmoqR90HSHueNKbK5R/q3+fiXbwFan2xtIOHh98hkO4faDKFONmNBDc16Zhue+WeBey74qtEE+EpdRWLUE0HmCYfb4loJCHYfVWUhDoEcA5qV8ZFkZtTqq1MLfsAkVxUGNhkpd8oi5McOkqv0xrgDsAha4gge348DpehxA+kmRuK4n4i2EXD5NfdhAh2NuKa40z1qdKX3LgI6VhTx+khicHHgpC7gkHWaebi4M1xXRDlX3mduNTvWUsYmatjYFze6tF6xfoqXCaEHxeIVCIxqlMu1OOunE57C1gIsaYQiolnECgpbBSUF/tggjJXwmR8mLZORlrf2F5ZFqf38YZKPLJqCYwTQaBfqVQDp4gOKpwpb2MXQINulD/RYkcfVj1CAtERLMPL3pctmS3x+cxPrzm0yQEq6aKigbCBieTJU4TTSI+mTsOAN3Qk6XTnwNKzI5v46E+KGsm22ak5BmrgXGOBCHo1YMfr8bWJuaPoDIJ61297FF7K+Yu92cYpeVnV8EWIc0x1wqgervIo9CPRCqqMbqb8WIdiY/7++JM5u6GmFLnlYWxNOS4m5k53X/K/ImeIXkG515K7nWuZMsOUu5QEibuYZZr0UOfEmgqQeYBZ1B3LD4KAHT4yqRfBfGnD32yoBqeA57M9B3BHQ9vLSt12/Z8S1FPqXehyRgcg1FIZBg1VtmngN40n
 0Fi0u3v0
 u24QFgvD1quKyfsDvkZxeC05VirxkdS4NCvBj75cO/qTYzEoEteHnbo4AqfkU9nW5+OrL87NtxgzBf4ZZInyfHGCMtzJAHvQfyf+mdH5INuohXqFfhKtsP/E0X6K3IfQlbV7IVyWBilIrF1tUSRrmcBn2Mgqol9Zt48hyZ+d4/5PiysVHI7dRNwlwTlsO9+b/H65pFaWHXppNu2IuoNE7BtTjzl6c/hHaamz3/NK2x9nnb6xQewGtQyTEHkT8dHU6XCzVVfCu6nIpnnDAI35c/KQG3dhV3fDrA+2us2h0/0UWr44KmGcEedL5sLV5uuKwDP87w3vhj8QFuTyPWCtAJvsFjJuizrm2v/6Y
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 16, 2025 at 8:52=E2=80=AFAM Steven Rostedt <rostedt@goodmis.org=
> wrote:
>
> On Mon, 15 Sep 2025 18:19:53 -0700
> Kalesh Singh <kaleshsingh@google.com> wrote:
>
>
> > Hi Steve,
> >
> > Thanks for the comments and suggestion you are right we can use bpf to
> > get the comm. There is nothing special about this trace event.  I will
> > drop comm in the next revision.
> >
> > The reason I did the task_struct parameter (current): I believe there
> > is a limitation that we must  specify at least 1 parameter to the
> > TRACE_EVENT()  PROTO and ARGS macros.
>
> OK, then this is another issue. We don't want tracepoint "markers".
> Each tracepoint can take up to 5K in memory due to the code it
> generates and the meta data to control it.
>
> For something like that, we highly recommend dynamic probes (fprobes,
> kprobes, etc).
>
> The only purpose of a static tracepoint is to get data within a
> function that is too difficult to get via a probe. It should never be
> used as a trigger where its purpose is "we hit this path".

Hi Steve,

I completely agree with the principle that static tracepoints
shouldn't be used as markers if a dynamic probe will suffice. The
intent here is to avoid introducing overhead in the common case to
avoid regressing mmap, munmap, and other syscall latencies; while
still providing observability for the max vma_count exceeded failure
condition.

The original centralized check (before previous review rounds) was
indeed in a dedicated function, exceeds_max_map_count(), where a
kprobe/fprobe could have been easily attached without impacting the
common path. This was changed due to previous review feedback to the
capacity based vma_count_remaining() which necessitated the check to
be done externally by the callers:

https://lore.kernel.org/r/20250903232437.1454293-1-kaleshsingh@google.com/

Would you be ok with something like:

trace_max_vma_count_exceeded(mm);

TP_STRUCT__entry(
__field(unsigned int, mm_id)
__field(unsigned int vma_count)
)

mm_id would be the hash of the mm_struct ptr similar to rss_stat and
the vma_count is the current vma count (some syscalls have different
requirements on the capacity remaining: mremap requires 6 available
slots, other syscalls require 1).

Thanks,
Kalesh

>
> -- Steve

