Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20847CAC592
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 17:58:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 58FFA8E0006; Tue, 16 Sep 2025 13:57:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 567A98E0001; Tue, 16 Sep 2025 13:57:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A4548E0006; Tue, 16 Sep 2025 13:57:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 399338E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 13:57:59 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D774BC029B
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 17:57:58 +0000 (UTC)
X-FDA: 83895871836.09.8DD8FD0
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf07.hostedemail.com (Postfix) with ESMTP id 1319A4000F
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 17:57:56 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=3DJezvI0;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf07.hostedemail.com: domain of kaleshsingh@google.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=kaleshsingh@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758045477; a=rsa-sha256;
	cv=none;
	b=SG2PW0qnIfS4cuT6v1amdOeiYYePp+aVXsfXcJBFirIWcZeFz5BPN3mlDbyaSlSys3pjbz
	/kjFa/Rxt3SOG/qk2ZcE3lrkotcwYlwSy4pzS6UtSXsKILSM6BfVVI755o1hBUc/41uLlv
	bmP+MI06eFD0ECJH510KMoarZgIQpUI=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=3DJezvI0;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf07.hostedemail.com: domain of kaleshsingh@google.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=kaleshsingh@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758045477;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zTIsny0j4ESzYhGc69c5iIOG8DDTi7Xyon66+klf/yQ=;
	b=QAUWLx65keomPxstqT/nAt6DRm5Kdzukq35jhDJEA2QUfmmecO45TlRFNOygv+YZEqLRFl
	+Dzi0m4OU9Iuq51a6OnilMkFx7J+6kon5vl/a5smjCTtcpZGLoMRMomYiDxTFAKe/VYZ0G
	VORP9PIiBQZEdQgvPn3zvuA9paXooVA=
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-265f460ae7bso19575ad.0
        for <linux-mm@kvack.org>; Tue, 16 Sep 2025 10:57:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758045476; x=1758650276; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zTIsny0j4ESzYhGc69c5iIOG8DDTi7Xyon66+klf/yQ=;
        b=3DJezvI0V8ZrF+bfHRoilUu2m9aaGKdwzbTgMfNliDEvnT6KGHreGBHbVYpzwJH07u
         DUucZdVDYjYInyftTQXHZJBQHb44n7ZX4K4ArqlEGJQ2t/dIcJjKRAyGEm2dHe576Wlq
         5SUmMpJh2fOrTpyXEP4hz45HlwxoFPKqXghpW6pYZntk7xbp0texCrYiuLge9fQ8Avng
         /0+yBGaznw71YuPiVCNwzASei8XttXdztKYnOiVi/SeYIVfk3QD2TGDjmZxYiNUDoI5e
         9Qji4PVT6S2rVNPiZb/F23K1+vgsLA0XGk5AaIXZSBQr7kmodoJZLUntpszY+2M2cIEh
         bmIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758045476; x=1758650276;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zTIsny0j4ESzYhGc69c5iIOG8DDTi7Xyon66+klf/yQ=;
        b=UZLLgwkA4oV9KfP9z1GrPt4tSyC+qvQV/6MXsBSPXzJz0Ts+oh6kDtX3yNcre3XgR0
         Sqskxa8KxiAe5XPb2IbDRZ0z+noMJo/AsSYVrLZEPoL6RA8LbofLP16n34W7nh5T/yG2
         Ou9HenSMbZpv4EYTppDK/FG/ZPwR7KFoYQoYtKOCJ0K0+0BcL3tGGctikn6/r3DE84QX
         K51neXYcDNco2r18NMh+KHOIJFLIzH5EtxbJ+5ePLhn03IbJZn+clYeU5L5shISNvC7G
         f0AOAKD/yl6gF+F5jJlOq7/93G0MuEhnEVY0dUyrE/ImMu8sX7KZjX0C+YfuvFSd9j+q
         tykQ==
X-Forwarded-Encrypted: i=1; AJvYcCW46GpVjvmqccSW+q6wrypVCaJ3TuV5xA1+sXsiepiSori1viCWj2+y2xSi2mqgLQkl3cV/nxFlJg==@kvack.org
X-Gm-Message-State: AOJu0YyjLpxZSKI0ON9BXu3wip/In4XBU4F2h7gifXSM3nsJyQGL6hfG
	PeOj0g7p3XqnqwgO8zzz+VRlNuMJm7LgUYN/saph2QHMfjUSlOePyKQYpN5LijrVFIwdilcGoGO
	A0t1+R7rCrt27ZNEbxqaz+tVAgudr0Hn9enHx5+fu
X-Gm-Gg: ASbGncv4gNPtcUZT0cys0xMlrFPzjzLI7OiCtZAy7QIHbsZ9KRLVV1tPU/PH/3aSud8
	JS3pU89MugIpYvQBbk0DiJcH15PLXqN2uHiYgIkdOQBCdI3qtw4fFsK+qwuXnCu48XE9thGmar7
	3c0yJYZL4HeGF5Bq35KYr70M33tVHYjS4dfwD3LJMIIttT1xi/1AKVt+ju1RMv56o2kdEKKi6b7
	J+badE/wRmhscM7lDyjVzc2x9VqTmKQDdJnCJWcNRF2vV9u3XscT/wvbtP3d0hmRA==
X-Google-Smtp-Source: AGHT+IHGbR0nw70VyQc9zW85E2AhlbNJIVkFU9yxJMWLzRlBiKSa4wpgGT7Ne4ww3kizHSnL1IWHtB6HnScEencWC14=
X-Received: by 2002:a17:902:e751:b0:231:f6bc:5c84 with SMTP id
 d9443c01a7336-26800f6615emr380685ad.8.1758045475525; Tue, 16 Sep 2025
 10:57:55 -0700 (PDT)
MIME-Version: 1.0
References: <20250915163838.631445-1-kaleshsingh@google.com>
 <20250915163838.631445-8-kaleshsingh@google.com> <20250915194158.472edea5@gandalf.local.home>
 <CAC_TJvconNNKPboAbsfXFBboiRCYgE2AN23ask1gdaj9=wuHAQ@mail.gmail.com>
 <20250916115220.4a90c745@batman.local.home> <CAC_TJvdkVPcw+aKEjUOmTjwYfe8BevR51X_JPOo69hWSQ1MGcw@mail.gmail.com>
 <20250916134833.281e7f8b@gandalf.local.home>
In-Reply-To: <20250916134833.281e7f8b@gandalf.local.home>
From: Kalesh Singh <kaleshsingh@google.com>
Date: Tue, 16 Sep 2025 10:57:43 -0700
X-Gm-Features: AS18NWDROcLW9crQ0p334hZw_COODCH3F9NCEGYQeh0xi3klCf483KDt2XFW7i8
Message-ID: <CAC_TJvc6aqjBRZ05wyGb49AU+-aKpSph=ZSk3fdV2xraXi-_nQ@mail.gmail.com>
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
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1319A4000F
X-Stat-Signature: 3qnigt8cenqp11efagds1ng47o5maj3c
X-Rspam-User: 
X-HE-Tag: 1758045476-8809
X-HE-Meta: U2FsdGVkX1+LwxwEMKGGRkV2MRSiatCDXY5jLPRzIXluHXJThWf1QorlN2bwvE8lLQ0rByzDknD8wnIjgfCQkTyoIC3tmtc/OOptfPGbyHiGwo1eou3OxGusIgg8zZX5QjKUeeoJ0ajy1jcumUGQnUSpUokayyfYiW+3phJSn/Txg/jSH2VlyrF9rX5oBrWFMiRSucRYJrwXHQ3kJ/zb+9bFctvkIBAvrawz3fYgFI9mEzb7FltPurAruLJ7C6GfrjWTWSk5DBsRTapESGtEFE1ep0Xt8B687WQFAUlqtVFl+wZKE4GwlFWmhXCeIlG8Rvpxl+0ThORchuuk46k8FPUsqoaVQSMiWU7SkDv15dNLEQ+136vJPsWBxRxZz0rgiERnU7PAmZWdE7nwPUMGhxFYRKw0UQQk7RoAF9E03/nn/jkIgatG5BojYGJHPMpYFnM2xvCtDCao5jESh+alV3sgS1r8jgzfWdsBrqXUD1sCYjmbPlZ2EE0GG4Ggp+N2N40D0hZ68Y4YGDfdyN0vWvAFEwX2TTiI7pue2d29Y9Sc6mmwW4hh+GvUj/0p+lSOOthY9CJu8KVIGNhnd/Gsc/wEoN39a4U0qTvw12TGL3rz2FqwMEhdb88zVcVuqKAgtZulK7XyddZsOzlhRW8+zz9L/UEFXDPBi8nH4HzX9t6KKDLaCIw4tMCrrA/MNvXcTJFNnKx93C0s8ZuiicLp+9vYsEqLYHlVIRhU+0K5dIzqNorQkNY3MiWyVKV2q9y+sIQ1EYnDjgP7JONHunt/LrKsb/yWqj0BaQQeqy/TdRsDxxAmKMS9yZe8OE4rDUwh6xYiPPuP4XWfIbwVtlNri/rK51s/R63U0Uh80ivVUFLhZO5bHOzN35HUqDeQ5B9wSbedDhRjTYn9Kn7O+kGiX90EyMQ2jfbXAGYpR2613QA8U31QFaNcYAgM989da7eH3bFzyKGiMzs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 16, 2025 at 10:47=E2=80=AFAM Steven Rostedt <rostedt@goodmis.or=
g> wrote:
>
> On Tue, 16 Sep 2025 10:36:57 -0700
> Kalesh Singh <kaleshsingh@google.com> wrote:
>
> > I completely agree with the principle that static tracepoints
> > shouldn't be used as markers if a dynamic probe will suffice. The
> > intent here is to avoid introducing overhead in the common case to
> > avoid regressing mmap, munmap, and other syscall latencies; while
> > still providing observability for the max vma_count exceeded failure
> > condition.
> >
> > The original centralized check (before previous review rounds) was
> > indeed in a dedicated function, exceeds_max_map_count(), where a
> > kprobe/fprobe could have been easily attached without impacting the
> > common path. This was changed due to previous review feedback to the
> > capacity based vma_count_remaining() which necessitated the check to
> > be done externally by the callers:
> >
> > https://lore.kernel.org/r/20250903232437.1454293-1-kaleshsingh@google.c=
om/
> >
> > Would you be ok with something like:
> >
> > trace_max_vma_count_exceeded(mm);
> >
> > TP_STRUCT__entry(
> > __field(unsigned int, mm_id)
> > __field(unsigned int vma_count)
> > )
> >
> > mm_id would be the hash of the mm_struct ptr similar to rss_stat and
> > the vma_count is the current vma count (some syscalls have different
> > requirements on the capacity remaining: mremap requires 6 available
> > slots, other syscalls require 1).
> >
>
> BTW, why the hash of the mm pointer and not the pointer itself? We save
> pointers in lots of places, and if it is the pointer, you could use an
> eprobe to attache to the trace event to dereference its fields.

In Android we try to avoid exposing raw kernel pointers to userspace
for security reasons: raising /proc/sys/kernel/kptr_restrict to 2
immediately after symbols are resolved for necessary telemetry tooling
during early boot. I believe this is also why rss_stat uses the hash
and not the raw pointer.

Thanks,
Kalesh

>
> -- Steve
>
> To unsubscribe from this group and stop receiving emails from it, send an=
 email to kernel-team+unsubscribe@android.com.
>

