Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7FCCCAC59B
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 20:08:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2957A8E0006; Tue, 16 Sep 2025 16:08:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26CF28E0001; Tue, 16 Sep 2025 16:08:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 182238E0006; Tue, 16 Sep 2025 16:08:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 08A478E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 16:08:45 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A1EAE119969
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 20:08:44 +0000 (UTC)
X-FDA: 83896201368.19.882512B
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf24.hostedemail.com (Postfix) with ESMTP id ADBF3180011
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 20:08:42 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=qiY9WNsY;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf24.hostedemail.com: domain of kaleshsingh@google.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=kaleshsingh@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758053322; a=rsa-sha256;
	cv=none;
	b=0+pECoieIezN93G9YMYmnMxwLt+YA/DraScBSONXPypqlKOlxiscw9lN0NdKt0yTsdjO0Z
	gaaVBT5X3gREEAWqwF8m8Y0Nka8rRAaM+jBgkqAwHRjjGRaUJL2IIIv39mDqv6AdrncE9b
	IDGW78wI3/3wjXZ2xm0FUwUTSwyOY7s=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=qiY9WNsY;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf24.hostedemail.com: domain of kaleshsingh@google.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=kaleshsingh@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758053322;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x9Lkzd2qHU0WJpoFh7WhpO5uCyrQhSbia0bX3ioP2o8=;
	b=QP8SuoTKbYGl3LjiJ2DAFLORv9Smy6wU4+bT0pUeJTVNrfdld3frQ6gtkIVyOOf0CAX1Pd
	0Ps7RXZ0IW1LcsWc8hEWwiaCCxdsiFG4KH9CLGeI2Qnz7TBYs/gN+fvkxxpcg8dDJIZdbS
	vGnhfrHK42lGpNXyRgrof1yfy0J++xo=
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2637b6e9149so14585ad.1
        for <linux-mm@kvack.org>; Tue, 16 Sep 2025 13:08:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758053321; x=1758658121; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=x9Lkzd2qHU0WJpoFh7WhpO5uCyrQhSbia0bX3ioP2o8=;
        b=qiY9WNsYHkYhNXx7LETKXjNO9TFlY6iagmpft8Nl8lF3jTKPCyySGH94ujKHqeeU/w
         ypAosEWFUURurwU8nq3Y3PMcbQuoz/jpJEXEVRWgoZ/06L5vcRA2H2/iMALDpxF8YlNk
         7kLcHpBV6UOxxTx3m3v9pYcSK7FgD/ZtDCEGchEN6T9HbYcjXCaf+vS/wispIfeX8a6d
         ap0Bp2V/aVxb4kJ2Kc8fRpq2n7A9Fq0lrnCR9pjarD+zoKY3jmmxW/r0UeXe930+BVuK
         Ee0qyvw5DvekQ1z0oK00wDrqWuZ+I0h3VJCuuJuyDYoZX6UV46dEEoKoLCOzPblCPYPj
         93QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758053321; x=1758658121;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=x9Lkzd2qHU0WJpoFh7WhpO5uCyrQhSbia0bX3ioP2o8=;
        b=Jp7u44cl+zVgs64OtzO/RdWwNY+dy7GcowPTPsCrPXITBVO8gcMRNg12juhmgIQxz7
         zKhnaY9UCV6CD5EzdSFKkGNISpq2OnKBiy332gZjs921XxIFzgxezE+NWNxjkZ64307Z
         xedr7ByJyFfGaTABEoQAKuhyxMEXieHPaogy2fTav4P+DruplEYHRHhU5p7zg/bXWeLT
         oOfXf6U6LM3WQ0MqEz1uNvQdSavN7Ubi3mP25j1bLlqKtPxODT5kKfNfEBTwQqOOnhsn
         VdpeTeKeeklMjS0mTZFrIYGjrks8v9l4UQ3Ds9O44g7c10sLaZWCdUu3Z31vFxVIsYUi
         u8Cw==
X-Forwarded-Encrypted: i=1; AJvYcCUALCR2t90PRermM6YHb5rqmevcyx48qs/R0JPRyLmFjHXLD+oYUgAURXVQlPNhWhcC9UtEdMp4oQ==@kvack.org
X-Gm-Message-State: AOJu0YymBCYqyFkFbQpc6fAIYl49dP9EHWmx0BmBABl55kiQ3aCxTLPD
	k6nxnX/rr6Y/yKSfHpYX1aRcZDRzcPozZMad4TmLEZuLWATOSJKI60pIyfw6t2zQN26T1OZeW5R
	JWM56qXiw9VwNEP/o8YsZu5dSlX+SMODA9q98g8DB
X-Gm-Gg: ASbGncvJ4pVAA2vdgAjhrH+1dJtz1IOBboDo6Z4ElDzIl7qL0p2T3tXpWHHPX2rYSZM
	X7EON5T2ercTek3QLUGxObWovzfdytpYN4/vS7zEHSv3NqZrwrvP14I3MkedyDF/0DH6tc9lrFm
	qKGk6ChhOU9cU2poGV4lHE5mN0037To/inZRD8f6DXSdrsdkQ0Z+0a+Va7JvKv/QsA3KQRPnz+m
	FWN27beD6N93T8xtk68I0B9FrEJ8WP9cZasIWCSy8OhP6rpbns=
X-Google-Smtp-Source: AGHT+IHB+zIC9M5csK1y9pYvqYGZ9e1a8g5vFs0VSlYor4LBlSAEw+sh6AmBy5K67UD64uBbR+RJ2cXCghc/d1plz/M=
X-Received: by 2002:a17:902:d2c9:b0:266:b8a2:f605 with SMTP id
 d9443c01a7336-26808a2fc00mr122185ad.3.1758053321270; Tue, 16 Sep 2025
 13:08:41 -0700 (PDT)
MIME-Version: 1.0
References: <20250915163838.631445-1-kaleshsingh@google.com>
 <20250915163838.631445-8-kaleshsingh@google.com> <20250915194158.472edea5@gandalf.local.home>
 <CAC_TJvconNNKPboAbsfXFBboiRCYgE2AN23ask1gdaj9=wuHAQ@mail.gmail.com>
 <20250916115220.4a90c745@batman.local.home> <CAC_TJvdkVPcw+aKEjUOmTjwYfe8BevR51X_JPOo69hWSQ1MGcw@mail.gmail.com>
 <20250916134833.281e7f8b@gandalf.local.home> <CAC_TJvc6aqjBRZ05wyGb49AU+-aKpSph=ZSk3fdV2xraXi-_nQ@mail.gmail.com>
 <20250916140245.5894a2aa@gandalf.local.home> <CAC_TJvfAQDiL9PydWnKE6TDMcCzw0xrsLMZVZLe6eO0R1LODhA@mail.gmail.com>
 <20250916145146.046f56a8@batman.local.home>
In-Reply-To: <20250916145146.046f56a8@batman.local.home>
From: Kalesh Singh <kaleshsingh@google.com>
Date: Tue, 16 Sep 2025 13:08:29 -0700
X-Gm-Features: AS18NWCVdunjcrUP7tBqVqoMShUmOYlO_Ndh14lC0p7nbWIxXHPwlnQ10YTDEow
Message-ID: <CAC_TJvc2MwQHvY_ry=a4CGA_zEw2TE8R_K520Eizjt83At0N_Q@mail.gmail.com>
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
X-Rspamd-Queue-Id: ADBF3180011
X-Stat-Signature: icqc6zxz4qmorapgm3h4nopmf175hkbm
X-Rspam-User: 
X-HE-Tag: 1758053322-511723
X-HE-Meta: U2FsdGVkX1+VnDjsS6xwlSUnbLw12SX1fZS2Z/3ItH7SNV/PVAsdhCsY2KQxACA869dYglzvf22nsbsI67vjot/MQ6BnYvvKpXKyJnKNzPUpmXrq6qhSeGq8eU0hBtejN3IGjI4tPGmxjShjmZHp4QC9vqQU7nW2xUr0XGh5UOOlpoNUfMdcbv2IZxE8DMM8eM35iNbOYEj+ceQtLJy8sRFG0eyGdgVUfFKW4y49Wq0TT57pOb2CxWvREX4m1mvJn++CbeNLJ0a6uP0ya8UxIk/gd0UZ0HAZoLy3E5VaX0/QWBlHQC/6GgurpS92yvlrTmcwv2csihNX+G3W9sXJdUvXjT3KYHBx7qGwv9KKKE4RfUMGcUCyYZK1LgG2W+ShKILgAszO0kY6Izz1ZcA0Y4x3SYa2wEBTwnAUo7z6D0JQpzOYleJSdY1l643J7MHLzOUA9U7TFC8qkD5oQfoQRc1+JP18LIQy8h4CKPZJV/w7aH6x+8RqJppyk+TGI2FLHBmVA0doPGe9+mw4pXMMopjaijnE+PtNVBJzKCwmzTca5vk2zDHuXg7FOdtlMNIPgdWboGSUwrpnFHNuAH7Vn6p8DLAFsGyKYxHLcA80WWy68XwN2qgHq4GwT4Rcpd+LEceUxV2La475vQg0hC35WeX8PxFVorxEuPJuRsblu2o5StLiQ/TPRKBbWwL0iriVrW0CnIcA/pG5FDrJRyAw6Fe6NsFFMf161CRuWpJ14QRhZk7Gqw8NTy4hrxdpQz2ipwynnw0j7UQxzeSW23UTOTzCsKres/0E7w9+gZ/fDKjsTTGnx0Xn8rpgz4DkdYxQMTDfJXBpvlAzA0AyIqDCWCOlmKBIceq5fQb4adyd+r+yVqeDRncAe7e7smyP/tl+HiWLPiSgJ5t5ZiojGsqy1iboAeovBMGRb4Ne3qYvvUQib52v8S1mW9B71BPrSl7+Y7PcGG36jb0hyh64Yb0
 z3POO1RV
 zagdx1IUNjYKSQGUWPnRpR2F/nqNjl/Ky8ihX2oQPgJey72fsFONH7UZ48nTAJlQiAdvpUV180PXZ9vWxD2HAJ8i951Dt3n9+/4Sa/aK7Hu4kpj/c8qhCTq6HLHOLndq6fcwfVtw+6SD+BhAG7Z7SFXD65UsemvBIX1FNjy3JsZYR4FDbppn0Ey2nexf6HPctwwx+RuLgzHAxbggl+KUGbGNiwaQaHfxg+KTh5zh6wGL3rZ+ELK/DyZqg3+ZYUnDF1xMH/C/oQVJfwv3qwikv6DDwOUO+EPnrPuo4LvSmpVBvu52wBiZdBRUranKJltbsuGU8
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 16, 2025 at 11:51=E2=80=AFAM Steven Rostedt <rostedt@goodmis.or=
g> wrote:
>
> On Tue, 16 Sep 2025 11:23:03 -0700
> Kalesh Singh <kaleshsingh@google.com> wrote:
>
> > > When it comes to tracing, you already lost. If it goes into the ring =
buffer
> > > it's a raw pointer. BPF doesn't use the output of the trace event, so=
 you
> > > are exposing nothing from that. It uses the proto directly.
> >
> > My understanding is that the BPF tracepoint type uses the trace event
> > fields from TP_STRUCT__entry(); whereas the raw tracepoint type has
> > access to the proto arguments. Please CMIW: Isn't what we'd be adding
> > to the trace buffer is the hashed mm_id value?
>
> Ah, right. Can't the BPF infrastructure protect against it?
>
> >
> > >
> > > Heck, if you enable function tracing, you are exposing every function
> > > address it traces via the raw data output.
> >
> > Right, security doesn't allow compiling CONFIG_FUNCTION_TRACER  in
> > Android production kernels.
>
> Does it block all the other trace events that share pointers?
>
> Like nmi handler tracepoints, x86_fpu tracepoints, page_fault kernel
> tracepoint, tasklet tracepoints, cpu hot plug tracepoints, timer
> tracepoints, work queue tracepoints, ipi tracepoints, scheduling
> tracepoints, locking tracepoints, rcu tracepoints, dma tracepoints,
> module tracepoints, xdp tracepoints, filemap tracepoints, page map
> tracepoints, vmscan tracepoints, percpu tracepoints, kmem_cache
> tracepoints, mmap lock tracepoints, file lock tracepoints, and many
> more! (I got tired of looking them up).

Hi Steve,

I see your point :)  I'll use the raw pointer and handle not exposing
it from the BPF side.

Thanks for discussing.

--Kalesh

>
> Again, are you really protecting anything if this one trace point
> hashes the pointer? Most other tracepoints expose this. If BPF can
> access a tracepoint entry struct, it can access the raw address and
> break KASLR.

Thanks,
Kalesh
>
> -- Steve

