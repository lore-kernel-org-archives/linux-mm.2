Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE93CCA1013
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 15:55:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C4868E0153; Thu, 18 Sep 2025 11:55:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 476048E00F6; Thu, 18 Sep 2025 11:55:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 363F98E0153; Thu, 18 Sep 2025 11:55:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 204D68E00F6
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 11:55:26 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C3518B6FE2
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 15:55:25 +0000 (UTC)
X-FDA: 83902820610.03.E1A0E0D
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf09.hostedemail.com (Postfix) with ESMTP id C0812140006
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 15:55:23 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="Z90epSs/";
	spf=pass (imf09.hostedemail.com: domain of kaleshsingh@google.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=kaleshsingh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758210923;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fB56UEO0mNP2hRYBRO1UDnRhREYhvCPXWZ0EMOooGbY=;
	b=u9Aw3MuI9ZGsHUuxMCHEbr7sf/wKTq/M42YLanTuoz/ScIKZHzSt580iPfiRhwChobACeh
	XqjIODUoyS+LiAOhXeWJkdNTECaJgUen33EREoVfdknZ9xd3uEbm8K4a0mKD07us4wLdFG
	oAPVkZIzws/j1zF52pwDesyeBreee2Y=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758210923; a=rsa-sha256;
	cv=none;
	b=Dmu/aB1+otOMZmrpl0TqwXgn/4TTViNB6teLqX1mrfehFSWK11ENEBpttXXAuSdt6sjONq
	rjIHdUuhKkN5R7od67iRHItpTnKPdaKFz0AbM3Rsm/LcrJnWJ5A2L318kryZlETLPk/CU5
	bfQzchNiWYk9SlaJpE2+YgPGVV3MlmQ=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="Z90epSs/";
	spf=pass (imf09.hostedemail.com: domain of kaleshsingh@google.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=kaleshsingh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2699ed6d473so141175ad.0
        for <linux-mm@kvack.org>; Thu, 18 Sep 2025 08:55:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758210923; x=1758815723; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fB56UEO0mNP2hRYBRO1UDnRhREYhvCPXWZ0EMOooGbY=;
        b=Z90epSs/ulpCcMbt3nv0BOhFa7Op+BMAoVMVE4swozkY2bJhbSMfhMhU5OfXWD4QCR
         M8Yo1P1ta4jazr0Ojh6rcSl/68U22gZQPVt650gkVOQKFOOugiJiFjpoVxtbr6W6iL2+
         0qlsx7Mju1MB9T8dZiWLxml0HFtL8p3VL7hqUB3BDUi4hvt92j7idAKeljw+kb+tOEQk
         xD93nMI9xExCfCNZeUJVl1S2bth5ZzATPN37NZc8YuMeDWvkeeFEhFO7r1tD1DKe91yt
         ScEnPxJE5nqQlU4VKlSeYSh3jM/6vNkl2nA9b2/IpqIIYBF5zi6oVGzvL0xYTX/VLTah
         11Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758210923; x=1758815723;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fB56UEO0mNP2hRYBRO1UDnRhREYhvCPXWZ0EMOooGbY=;
        b=vXY3DlGleC3kFumJ/AUtoRbm6bmraOKMbULA4FbpdUsJ34pIOk38ZhK7E7RYYwHU5p
         boOtWeMVG4M0jaw1otE9hYnXTWi42QCh0LX6IbsPqaAN7ZVfLsbZNHvq2qmybWsBHMRL
         ePUhpHD3UtQe7JPKWbP9Qakax4fkXX0fPqWk829quRkhbD7uVg+elAj26rnGch670sg2
         tj70hrJlW56VG3A+RTfbyEu1LfMkG28yUax0wdXbF04IiwDOH+heRPtitzjNXXy/LB8A
         HJjpYGjhgLrrLd0W/j3ZnZh8XyEAI+wbGz46irDCzVBqIj12ywTxLTVMinE88vKEUj/3
         91Og==
X-Forwarded-Encrypted: i=1; AJvYcCXSMl050IHsT/S6TskhY8i94TmzUo5ztuXiStfRtixKtPK1zX3qtUJu37CWB98+DKSxolcBWJCzhg==@kvack.org
X-Gm-Message-State: AOJu0YzH51SQ4MpQup/J4dpTM/iVXNMgCgM/e6J/Vywg9fNaTGLzURZE
	1ic4aXrV7hLooJ98C5hqMUOQNNahZDe0J2H6TXjHoWgFlc2jqR1jVcJaXpFG/ShaR17+qHQzjpf
	jX1UsRrEwJozl4nY/e1feg1WXpwSPCGiHcAzxxyMh
X-Gm-Gg: ASbGncvuPlZkYfn2/LnU35hkUa4O4+xMYMglTe9khAnjXClnPcVr3aDNL8Qi9XojUzZ
	d/sNAcMkZThMEckewY2jZbNZ0Nt1Dx1KYgrw0xCxaBRtC1HoAIJdYxpLXvB2bbxlZwYZVRnKWR1
	VxEU481Tm9QtZYAAGI6g/onNWKVb/kMa9g/tKc1uHqL3ouHCpCrlWwMa6Rbgv3NWbE6nWvb4pfl
	ea0FSdL9h4gpnMJ2TBNJMELM1QYwa0csrdjVirLfYe323EYsv5DtEfunzCh5MI=
X-Google-Smtp-Source: AGHT+IHtle2Bol/8iJ1CI7SONgmRyw+7KDNF3rjHCoT0hB77tatWLPJOO/VLwsIgvGtPKBGy3m8lRqkiHkO7GeZDCgQ=
X-Received: by 2002:a17:902:ea06:b0:265:cb5f:3a66 with SMTP id
 d9443c01a7336-26808aeb835mr11034625ad.13.1758210922376; Thu, 18 Sep 2025
 08:55:22 -0700 (PDT)
MIME-Version: 1.0
References: <20250915163838.631445-1-kaleshsingh@google.com>
 <20250915163838.631445-8-kaleshsingh@google.com> <385df771-961c-4fc1-971c-81314c231f5d@lucifer.local>
 <53ade9bf-5cdb-49b6-b8c9-1f653c861bde@lucifer.local>
In-Reply-To: <53ade9bf-5cdb-49b6-b8c9-1f653c861bde@lucifer.local>
From: Kalesh Singh <kaleshsingh@google.com>
Date: Thu, 18 Sep 2025 08:55:10 -0700
X-Gm-Features: AS18NWDy23QFicFxq7eonAAZapCtI7hAuF1vOI9oXz3unSnA7mgzsm9MtU96rN4
Message-ID: <CAC_TJvdRf3xJg7FgTzAxa-ZrHkGA0G3dEDVWWWttg3ri2B-FNw@mail.gmail.com>
Subject: Re: [PATCH v2 7/7] mm/tracing: introduce max_vma_count_exceeded trace event
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: akpm@linux-foundation.org, minchan@kernel.org, david@redhat.com, 
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
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C0812140006
X-Stat-Signature: 4fp5wrhsinfh8z7ojjx7sk4p3yep6fz6
X-Rspam-User: 
X-HE-Tag: 1758210923-449201
X-HE-Meta: U2FsdGVkX19n1+n8h7EWD4cADxm+fZM3r2dcAz+1pSH0EKygFd3k24jP2dX4GbdIN/Z3b9sb0Z4z6d1I42cj/1+zsyjKQN6NumFS/XRgvuU11k3O31bYBiwmzcCo+e3W+7rNGLy1ITcOeksgj8lZ5y8yEshtHErPtYRkI+KklrL+MKH4zOAgetTymm8qs8ccWFvpnELokmreg61O2fO56JPRCMU6AtxE+cxlpBq7XEQbwysz6626IH6AQFbyVt7ug6o9o6+wvIOPuFdMeXoNFtFesNiTN+hfTVsdQvKfE5LVky1c+E5rPHhWHzBRQ6xkXnuro75TxkhxFlld0hAHI2reIX+pHS0VXr1EcVuAG43Oqx3ZfOXu/+fAfykuEDQZBWSWK9WSYy1/iBK04ijoGRaCOHcm/PBAnKaDJnfKydPRmlvbN5Qcxg9Lr3r3H44ty/ITwU8pzzy5vyAYEcW3AZafSwr3FV+J6lupxs15CdrGiyvPVkzdtESMxw51zRQMakshqQBsyWpHZz/sAi2l32UTIkbAtQQr+6iLTft8M/O4ee4dq8pKZt9xsM6Fyuc17noAfc2T9wabgFQvtNQN8Ikn+uGHkeoCRQ5FKC7Vdmgt/aKUF4Wtxk5+OjJBfehuHEXcGeykU8mPwV8a1DGn6ZgbvF0TRZueFRcA6h5Vfdh3ZHz9/1LIaoN761GzG/95Th6SKhuSvYGiYKXxCaGuUQ6hexx7ZBvDBTMkvGlKYFQ+VbnhrdTECZHOyqynkCSup/g+HCzCu7HZD5XASJn3XT99jRokuK8XvAfGXpSxRJ1ZqWxhuLpTsp3OdrzSAlXzwlNx8B6JkztMFFGHqLcoF5Lyb4XBFda4gjq4myM7vAvDOWsONbuRUbwoZEtIsGwv0cp+6QTrBh51wC5bBEy7AWKbnrAQ4TMm76M8BGqgSAVtxdMJrpS397eAs9qiFldDT10aNkM3FTgy5eitIZ4
 BtxV+EF2
 fsQoWKhM3Y2PQ/wYTwmZVCygrtbQZcShbXpet7N0XHOGYJQBHLFcY9plTJ3nO0gxS9ucg4in/EJWbfY/BzI2wLCDmJnqsotYSBXQy49N7tA9X0jjxYPpiO72xiXHrftU3scrCocD3mcZ6DUhvGsQybAtFUYBQF3F/Xngk/xa87t2eaOqfLnTsu36E/Q8A0ynjWQnKZyZ3tlOCkgzXwHrYvUInPkpcqROXxInMurnmRqiz1Uon9uFkqCU3Ip9/BFcTMbt5l1Ivvann2pEg1uIbbswejOM9R5jXxPCnVrnHct+t/uVIJpIQ1lpA/rptcRDH1iws1xVgez+bY1I8Tsmx2Q8UtCJHlbkFn4NfnEsydbCOvckuxgS277Hm2WON9rOzYBJCvxDRQcLuSg9plv8h/ihpsqZO2aoq2Ta+Ur6KFtceOFs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 18, 2025 at 6:52=E2=80=AFAM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
>
> On Thu, Sep 18, 2025 at 02:42:16PM +0100, Lorenzo Stoakes wrote:
> > On Mon, Sep 15, 2025 at 09:36:38AM -0700, Kalesh Singh wrote:
> > > Needed observability on in field devices can be collected with minima=
l
> > > overhead and can be toggled on and off. Event driven telemetry can be
> > > done with tracepoint BPF programs.
> > >
> > > The process comm is provided for aggregation across devices and tgid =
is
> > > to enable per-process aggregation per device.
> > >
> > > This allows for observing the distribution of such problems in the
> > > field, to deduce if there are legitimate bugs or if a bump to the lim=
it is
> > > warranted.
> >
> > It's not really a bug though is it? It's somebody running out of resour=
ces.
> >
> > I'm not sure how useful this is really. But I'm open to being convinced=
!
> >
> > I also wonder if this is better as a statistic? You'd figure out it was=
 a
> > problem that way too right?
> >
> > >
> > > Cc: Andrew Morton <akpm@linux-foundation.org>
> > > Cc: David Hildenbrand <david@redhat.com>
> > > Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> > > Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> > > Cc: Mike Rapoport <rppt@kernel.org>
> > > Cc: Minchan Kim <minchan@kernel.org>
> > > Cc: Pedro Falcato <pfalcato@suse.de>
> > > Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
> >
> > This breaks the VMA tests, please make sure to always check them:
> >
> > cc -I../shared -I. -I../../include -I../../arch/x86/include -I../../../=
lib -g -Og -Wall -D_LGPL_SOURCE -fsanitize=3Daddress -fsanitize=3Dundefined=
    -c -o vma.o vma.c
> > In file included from vma.c:33:
> > ../../../mm/vma.c:10:10: fatal error: trace/events/vma.h: No such file =
or directory
> >    10 | #include <trace/events/vma.h>
> >       |          ^~~~~~~~~~~~~~~~~~~~
> > compilation terminated.
> > make: *** [<builtin>: vma.o] Error 1
>
> Trivial build fix:
>
> ----8<----
> From fe4c30abbd302ccc628ec92381ac10cea31c6d85 Mon Sep 17 00:00:00 2001
> From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Date: Thu, 18 Sep 2025 14:47:10 +0100
> Subject: [PATCH] fix
>
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> ---
>  mm/vma.c                         | 2 --
>  mm/vma_internal.h                | 2 ++
>  tools/testing/vma/vma_internal.h | 4 ++++
>  3 files changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/mm/vma.c b/mm/vma.c
> index 26046b28cdda..a11d29a2ddc0 100644
> --- a/mm/vma.c
> +++ b/mm/vma.c
> @@ -7,8 +7,6 @@
>  #include "vma_internal.h"
>  #include "vma.h"
>
> -#include <trace/events/vma.h>
> -
>  struct mmap_state {
>         struct mm_struct *mm;
>         struct vma_iterator *vmi;
> diff --git a/mm/vma_internal.h b/mm/vma_internal.h
> index 2f05735ff190..2f5ba679f43d 100644
> --- a/mm/vma_internal.h
> +++ b/mm/vma_internal.h
> @@ -47,6 +47,8 @@
>  #include <linux/uprobes.h>
>  #include <linux/userfaultfd_k.h>
>
> +#include <trace/events/vma.h>
> +
>  #include <asm/current.h>
>  #include <asm/tlb.h>
>
> diff --git a/tools/testing/vma/vma_internal.h b/tools/testing/vma/vma_int=
ernal.h
> index 07f4108c5e4c..c08c91861b9a 100644
> --- a/tools/testing/vma/vma_internal.h
> +++ b/tools/testing/vma/vma_internal.h
> @@ -1661,4 +1661,8 @@ static inline void vma_count_dec(struct mm_struct *=
mm)
>         vma_count_sub(mm, 1);
>  }
>
> +static void trace_max_vma_count_exceeded(struct task_struct *task)
> +{
> +}
> +
>  #endif /* __MM_VMA_INTERNAL_H */

I made a point to build and run your tests, seems I forgot to actually
test it with this last patch.

Thanks for the fix.

--Kalesh

> --
> 2.51.0

