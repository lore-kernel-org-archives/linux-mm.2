Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E4F4C982EE
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 19:21:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 520F36B00BD; Mon, 21 Sep 2026 15:21:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D0E86B00BF; Mon, 21 Sep 2026 15:21:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 398676B00C1; Mon, 21 Sep 2026 15:21:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 11FC16B00BD
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 15:21:05 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8D629120282
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 19:21:04 +0000 (UTC)
X-FDA: 85238737248.04.7F79E5F
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf20.hostedemail.com (Postfix) with ESMTP id 9FB201C000A
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 19:21:02 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="kXW5dH/E";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf20.hostedemail.com: domain of jannh@google.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=jannh@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="kXW5dH/E";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf20.hostedemail.com: domain of jannh@google.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=jannh@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790018462;
	b=B5p4iAYGCpAFQSFIDjeggCuxJ6iIwIgo1sr1Hiz/6q648UZB+OiGRYu94mvSmWtDZazzbA
	cCAIH1KE9NPUE35OX0qdkLZSPDKC267snbrB1z+5x/rCdCq71M1pQfH0BvsJjdvE1dT/Gz
	LKnOy3JOQaQC7UOkZ7iwHuDfSmtWDr8=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790018462;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MEszMFKCmw9FeOOlcidO7gC0SHQCAcCefilt7YkTj2g=;
	b=x2jAg47AafQoaWfW7ZF5qN7sezndXDzoSaUtOzonIvUDJg2kGjGEqWxmnoIZiSD4b8Y6CP
	f165c58vF57rhnG2GcyQMlqjTfZv0NYgcGYb+O72RPpjV6W+SqRzKgqDgUxL7AEgVKDEin
	Yrx4nNVBM0rHwSeTyUPpypB0ofouIHk=
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2db33db4de9so505ad.0
        for <linux-mm@kvack.org>; Mon, 21 Sep 2026 12:21:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790018461; cv=none;
        d=google.com; s=arc-20260327;
        b=hTEzFGNxtu4ZnDoLS37TJj4GHOkSUe2odfXl15TObqG6pFLswJGRaBUExFc1J5C2ec
         vuMZCM847l+XTIBoa1JF/qDtxcEOq3iIStgKuQzOog+eHzDLd3HJ1XzBzCqHAnaq0q5g
         4fZ6FESi/cwMqkmfhOUcj8K08BAu4Yk8mgPeF8j+Gt2v8hSpS++FVBKnAqWiSER6lBlQ
         0/XKD3BOXz9ZlUIMmi/yzH+To0G/ZStMSEk40uURvEmh6DAAiLRY6bSkBT97WvihBbxf
         8mGbB0GikFK0GEgEcywNVZso1xpKSgUoB7/tMYB1vwFJoTdtfsUjZW3FSfC3zSiubdy0
         Lo0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=MEszMFKCmw9FeOOlcidO7gC0SHQCAcCefilt7YkTj2g=;
        fh=unZTq5aQl+63AfsolZton/IRt372dkD19nDQiqbIQlc=;
        b=Gv18tMFSkdyc23wP3fLv6mMQ/tnrub+qmybMLGfvEsVlFrUQIJlVUw7Ffi92NW0BbB
         VzE0o+/AOemU8/sfIx6e6BAWILqWE6k1H0Ka8bOSWe4c8lrSGGyKcVLruUpTiUTG8BTV
         Uw62oUCfwedvPiO9+BjGwe4wA3v4G30aPL8QTW8FC9wX0bVqNuwqZttM4FwSBFJksDuW
         Z0cnq69BQxwj1D10Thq1Y4Jk2K86axZ2olqH++woHnSdAuCo/va2iTEgArYj6g12AHYk
         fhCGu0eLMoaUSqkpe3g8SOCicxDNpQjWJgxW2VhQIan5/imjBRqPE3qk/a7fYsdNvfDd
         BJWg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790018461; x=1790623261; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=MEszMFKCmw9FeOOlcidO7gC0SHQCAcCefilt7YkTj2g=;
        b=kXW5dH/EzqpQ8hFsTFyxOCkj93f6zuAGL1E7Lls3KBPatG0QpbeQWt+6hamu1lY223
         ThaPBPL2DjYKqTdt0fHUbahtX9LbJUoHWlLoymSyKLPDakNPUzVynpWTBlWv3fSD9lL/
         IfSQoaZOKzhVyte62jsq9HINO4CBeD+BM9kptC/01ZFgzKqOMWdAzx9CRAueevMFfB6Q
         WO5GxQYKZ1y+tW7TYoDGaQvODqfjUxF8mgBJ3D6f5wWDLKiV9Eg7xWl4nFJm1gBtGhJd
         Fruzi0MVYJX1/Bxz/LUy1vW1N/0TFFprLYImPGwUsDpBjxQz3nPLNnejv5T9xHarz7Cs
         xFAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790018461; x=1790623261;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=MEszMFKCmw9FeOOlcidO7gC0SHQCAcCefilt7YkTj2g=;
        b=lECz6Vfm4ocUeHQUTsbbnhHeARcEqKjlfWv/j6D5oCe6U+WHPQYU4+uCHnjJF+cOLN
         o0NWGOvL4RtV+uoER6RitUA1xICLaGuOUvot/34MQUssDTU4ppKw/e+LdzcoBCljmqAc
         5zHIAlDODein0vv06NKqTY4vhi0XpLeJI9uwKpBSPTH+eV2k3vh4xj0rcrN6u+DuZFzW
         yUPJZX9Vmv61KfFtaX9XWKCSiO4+B69jXVo79FOx2Dqp2/ls5AIVwQlUEy9m/iJRakqy
         gDrr5DV1fV4o/v79ZlUXfK6l+PEv/7a8M4Nq76LdC97Yvxs+dcaosxxS1Ql0CylaoUso
         xozg==
X-Forwarded-Encrypted: i=1; AKwUvBxrrCU9tcoDR0FEr93ytH0NIftQlEsXYOUR46jxEqHPDQcWwBz9R4a0rYnJdUaZ4oNZ0WJjpSTHsg==@kvack.org
X-Gm-Message-State: AFuF++kGzaalaolKQTyFVrnKGhzhgq79RTf6LDb8yyxqfQQ1g9kjsbUZ
	+eqVvfdNnORQX81Kg0ZYUSp9rUOCIHaI3LS4KvnXTjPcpoVc2YYvWO8y3n4WwG3s8diBRuhp8N0
	ntqBieACXPbjZPhnbrlFS1Hjmr3wJRmGrFjk2GuF/
X-Gm-Gg: AYBFou0a6Sr+60/W40guEnGLn143q56B5GNA5hr2kgEC456eAWSsoUAgr1tuNz3ujVK
	S/wz0netHfBWtIbbcduq1zOj6eHaN16p+6cFMGMA4D/LaCgnInqyim4HcbHuAI4+rkKCtJnjZ9y
	g2Tq8P0an3H5gdEZjUrllECtKMcURnzJjEMvVufEwS1ox7exkY6CfL4LjZLsli7jlXFn3ajmxp5
	IjFhePpGeSRcSocCwKrJPnqu3iLg4Zeb4QXTJx8tjDJWdf4Sa6keNXrgFgWcbwhQMcriBBfp8z7
	Ew3Ko59p/VKJ/fz3/FyumZi/XzRvHqpk3+MwSjWBaNzlaF3tK4S4gL3RWuYBsAiU2AV/EUjftmm
	OeaCZITZ/fV2mZ60Tt7+v06VWmRHspakIROmD700eujlCzSRcejE=
X-Received: by 2002:a17:903:4b4b:b0:2c9:bd54:cf with SMTP id
 d9443c01a7336-2df5a44e80emr2158055ad.4.1790018460814; Mon, 21 Sep 2026
 12:21:00 -0700 (PDT)
MIME-Version: 1.0
References: <20260831-pidfd-get-paths-v2-0-c59ea6a21b72@black-desk.cn> <20260831-pidfd-get-paths-v2-1-c59ea6a21b72@black-desk.cn>
In-Reply-To: <20260831-pidfd-get-paths-v2-1-c59ea6a21b72@black-desk.cn>
From: Jann Horn <jannh@google.com>
Date: Mon, 21 Sep 2026 21:20:24 +0200
X-Gm-Features: AcwNN1U76ul6KsowgCeLOYWUNK5UYTHsLK5_fZAtm1s6K_0yYBp22XKyN_fzxbs
Message-ID: <CAG48ez3vJrbt+qYh5b-PYxmr2txcg3DAKDRwmBwVzNhRB+8Ueg@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] fs: Introduce task path helpers
To: me@black-desk.cn
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
	Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, 
	Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Valentin Schneider <vschneid@redhat.com>, K Prateek Nayak <kprateek.nayak@amd.com>, 
	Kees Cook <kees@kernel.org>, John Johansen <john.johansen@canonical.com>, 
	Georgia Garcia <georgia.garcia@canonical.com>, Paul Moore <paul@paul-moore.com>, 
	James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, apparmor@lists.ubuntu.com, 
	linux-security-module@vger.kernel.org, linux-api@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 9FB201C000A
X-Stat-Signature: ytosksk9r3xyi84hafmsqewhtxntymt4
X-Rspamd-Server: rspam01
X-HE-Tag: 1790018462-717678
X-HE-Meta: U2FsdGVkX18gMRxTICW/weA3T/8uo/4vWM2Fc8CiaZwfsky183tehK7OI9aVX8DJCRZWYUgYA+0tgCf7MyEHfvt0gBH6Q9BwCOoiqayEgs9EGDrlzVT9CfMWf+LU6qRTYOnCp7auRdWfFky6VIxI9ycnbwVxgzHevFQp1sQC0IL/awN2yHnLir66/x0hT1PUmOIb8rjEiVrAJOZxJZqZtBSh+sSXuxhMpWbj+KmykO/r6buw/7V9kBrUNKZCHjFflng0CiIu7OQkhwD3hyGFWX2ha+rgOTOxwbV8AUbgvoZ+LqBbZOkFlHmW7BLAWy+yiZcQkfcv+FUtGT9vlUUY+n0hE5RIiCPimxSNTSjp4JgppJs+wC5wBXU5VXff2SBxVtlgNVOFh3t92W0VhzptrbYp6wopKSEIUtRKg5WrvJL6ES66LF/PxeEsaCuR0FTxrN1DqA4L0UPEqyxU6OrAisjkdQBs5CixjJthu61+VQI3MON9uk7d6vCHQ2yyoC+v0cN00JAl2p1jN1lqDa1JrTiNt553LCwdMHyErslkVY8gl1HFHAXMVLjX+N3aXYSUIkpQFmXMTYkbFobWuYIF2mmFV0FC0BFF04ZU3ZNqpg69F9G8bKdFUGIGRQZGl32cxF2/6d9V7GEZ/aoHSemBTSmjSDdFjqVDMdGcajUVw8fVYOUKvXc1bpj7/r6q0E97xguhKE53/ygNwvuGrh/tfZkFBKtpspMVYRO4fFq7H73YLdvyXC0KDUTDTM9rQLKD/Ilgbt59MJrXHL8n/80sBMGHL/mQLJrCeXj1FYVTtLc3qWEDdHv2j3o3KQ46WwghMnuz7TlZwrNaQw5UiS2rnc8K8kgzRUhtFNcnx2O3eNYGDJeXqKlmc/U3NE5k3ktK/zIBVsgmMuOtKWUZpXUDwDZeW3uHi3NXM7bbiaOtOrEIg8qH6NtwiLw2mBzYqoKgGvU8Qjb5D1qeopQ5qzS
 KFelTGIQ
 QOeP5wvSTmJ6bGFx0LDAfvQk6HaLsiwncVC78Dx2eBxFovWCzhpSirRKo20K9ayg9urD1M0f9wFxiPaunjD1Mww50NaSMNaC6NUjK25r0AFQPljchFegjVghO584+0hXqvL6PeYsvzgZ83jRBN/+dxrAx6PyswtVTRf59He46wotrdMss48fQGvCq7Zi+/B2NZpCKwDtKhVsv6MS2Tjqn+Y4gZgGlpSV5c4r+qM2pY3sAvDnYD7bQ64r9QnqTFztg3+HGKzMUVSQoUB0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 31, 2026 at 4:59=E2=80=AFAM Chen Linxuan via B4 Relay
<devnull+me.black-desk.cn@kernel.org> wrote:
> Introduce helpers that acquire a referenced struct path for a task's
> executable, root, and working directory. Reuse them for procfs task
> links and AppArmor executable-path handling instead of duplicating file
> and path reference handling at each call site.
[...]
> +/**
> + * get_task_exe_path - acquire a reference to the task's executable path
> + * @task: The task.
> + * @exe_path: The task's executable path.
> + *
> + * Returns 0 if the task has an executable path, or -ENOENT if it does n=
ot.
> + * The caller must release the path through path_put() on success.
> + */
> +int get_task_exe_path(struct task_struct *task, struct path *exe_path)
> +{
> +       struct file *exe_file =3D get_task_exe_file(task);
> +
> +       if (!exe_file)
> +               return -ENOENT;
> +
> +       *exe_path =3D exe_file->f_path;
> +       path_get(exe_path);
> +       fput(exe_file);
> +       return 0;
> +}
[...]
>  static const char *get_current_exe_path(char *buffer, int buffer_size)
>  {
> -       struct file *exe_file;
> -       struct path p;
> +       struct path p __free(path_put) =3D {};
>         const char *path_str;
>
> -       exe_file =3D get_task_exe_file(current);
> -       if (!exe_file)
> +       if (get_task_exe_path(current, &p))
>                 return ERR_PTR(-ENOENT);

This assumes that when get_task_exe_path() fails, it doesn't set
members of the path argument to non-NULL values. That should be noted
in a comment above get_task_exe_path().

