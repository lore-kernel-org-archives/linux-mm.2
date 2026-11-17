Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6661606A331
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 20:54:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amacapital-net.20260707.gappssmtp.com header.i=@amacapital-net.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=MstwXBXm
Received: by kanga.kvack.org (Postfix)
	id D148A6B00EF; Tue, 17 Nov 2026 15:54:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9F2E6B05B0; Tue, 17 Nov 2026 15:54:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B3FEA6B05B1; Tue, 17 Nov 2026 15:54:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 71CB76B00EF
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 15:54:06 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 70B561C3BF7
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 20:54:04 +0000 (UTC)
X-FDA: 85445813208.24.0B1758C
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	by imf11.hostedemail.com (Postfix) with ESMTP id 626D24000A
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 20:54:02 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=amacapital-net.20260707.gappssmtp.com header.s=20260707 header.b=MstwXBXm;
	spf=pass (imf11.hostedemail.com: domain of luto@amacapital.net designates 209.85.167.54 as permitted sender) smtp.mailfrom=luto@amacapital.net;
	dmarc=none;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794948842;
	b=lM27P0U3oKrgYjdUsH37/M1C+TltFHWMUE4yC4jJHjPH0Huq2Yujh68eo2TbmPEyGJ4xYY
	IWFsNYHLQ1wR6IvK0+gf8IrmFLDEbqisFs6oC3WRaCMvCByTcIobHkyCOyFfmWwb0SYISD
	AuIlRmXNQCzMOBQyHyJi29sbsDOAFlE=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=amacapital-net.20260707.gappssmtp.com header.s=20260707 header.b=MstwXBXm;
	spf=pass (imf11.hostedemail.com: domain of luto@amacapital.net designates 209.85.167.54 as permitted sender) smtp.mailfrom=luto@amacapital.net;
	dmarc=none;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794948842;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lxMCjoGZWG4QAWp+HpCFavF1sxg7OOCbkVFjQuSNzhA=;
	b=PyocPaixiOrWxsRsgVBIRhvf4KXaQQKeHtQ4FonJ39nSeyc1rs2X0xptXpL+RmSgaN0zoj
	tlUzfLbtOs8dgWKxL/hIIh+L0ZsReg6B/L53jJNutRFLH95QwH+0xXxbEGVdYYZ9oaGowg
	BfdRJCI9YIxVXLzo/bTWzO6mNo9/snU=
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-5be4fea434bso1244831e87.1
        for <linux-mm@kvack.org>; Tue, 17 Nov 2026 12:54:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794948840; cv=none;
        d=google.com; s=arc-20260327;
        b=HBqRFAKgIBFv5vNg52O9vo9tXlJEzSC+HwFjXp19i0FcFsgYd9D5qNL+JCvmY8sxqo
         YeluM8Ur86i/UTqSs22gGIM8Ti4pp/rBDclnu45axRO/LSOAYr8hqZpUlrkRmK9didR+
         Estf0bw1t05vGTu6NkMSpOu8XpiwdEskYuj2c/RzkwDWpITwQkH5aVFW8LjryCPhuMFY
         o+9TK9yfyDoWeJB20RJCkmvX7PxPtOxVS7d3jG1cN4dx1VGVhjZL798J7u+KiBHF0p3r
         746n0J3Jdt4Smx0uRPnug2CAYhHhIagnqpga0E9shyK4K8IvrlE0kCwK/2Ozb8qB9G7A
         7G2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=lxMCjoGZWG4QAWp+HpCFavF1sxg7OOCbkVFjQuSNzhA=;
        fh=XVGXXlJqPtToUxCc8cycXiBjlsRI+UsoFtR9TccTjWw=;
        b=iKC5PcLDjdIbDVB9D/6e9zis/PSkmCDYCqnDJhqxZbMuapVLAXg58stf28QCdFvXR8
         5FEp+mzF9d1ApBSbbTWRFfsmDYIak3TAHLGZK1u5FMeC0rPcZwMVEFhIekqMUJAoSlQo
         2SjyXVaQXl9pCfMsWBNXRxZ1LxKisI87kJO2oG9Ej2HnXTh8WNPWCCZnBzxV2Mybp6Q9
         mZ4WEtlE7/j2o87UWkCa8uo2y7NHx8sC8WFoUU5GY3Lg9VtbqASoW6mnQzlPgSxj23fq
         8W5BUsMcZw8LPI8bXBYBx8o3rSQiDok+GJbQLSA4rmZxVtwGDaDxQRjBawe3dh35wEUR
         m/Wg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20260707.gappssmtp.com; s=20260707; t=1794948840; x=1795553640; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=lxMCjoGZWG4QAWp+HpCFavF1sxg7OOCbkVFjQuSNzhA=;
        b=MstwXBXmVF5iGJzccuUfdIa0/9YGwBFOunq0FkDI0E2yZNQ0wkYhX4ML7B8snsVdeN
         frCF5BW+Z/LW7YB1YDr9z7pyxNArJ0Gow0e+JN4NVaWGmJ/wVNxXSFF8OE04ifb5nfSb
         6D4itYsjxyuCc9OD1tfbiyU3SvbHmJBExh9h7536ZeF67ObgmT2DUJFU1BYJTZ0Um61a
         tVC0uFQ0cu+N4xNbDCmVgZ0bYakLc0eO5aWipiFm6YCYPZhVxr2U6KU4YCHeDMKddVBq
         Y6HVZr2hlnrmlhjxQi1PWjROyglrZx20UYd+RTFfbZvrHyhLk1WBUZkiefZoZxrloPbh
         13Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794948840; x=1795553640;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lxMCjoGZWG4QAWp+HpCFavF1sxg7OOCbkVFjQuSNzhA=;
        b=VLNkkcHljsCWxrCdxbCUUbkMxyc1GqgRyFkshC9Ax0L8zJHDCaV5qoLIXejyByDV9/
         PIp9QpYTABY70MQS2vU/gGGq3fUS34PPPkqrRrlhqbcKEePmoB6TEDIqPY7S3jX0cEO8
         1xhP+tpaBdIpbhdiIEzWAVzBhQxJvCT8QCaLr0qNH8gkPaisVZ2d1hhqMACQSlpvuBJo
         DUj495eD3s9fhlzh+5fcZxZOwsJn9NK0U65sbD5ZMd5R3hY83jo0PMBt6xrtoJyJiK2y
         OwuwFV2XsqV3bCLWi0dPoyHCxQZLvQXUTr9WuhrxJCm+Ec5XGsja3yb8+vsw2Z13dK+M
         Wi+Q==
X-Forwarded-Encrypted: i=1; AL+hErFTde4fQWbyHyyaHqYDOeARZzFyB7wZO3MSFwnErGo46ZArWifeuBEp55roVuebAD4VjJk4brADAQ==@kvack.org
X-Gm-Message-State: APuU4Z8l8nDTmyeLTj96CzTjHlYm2IAzqPNe+9CtHu8XPg3dKuaCqQJd
	ELAgQ49VInmZj3Q7o1mN5mC+HYaNqcdYRPFyOftf7Z0SvDxLqeIa8QE6OeyO21+vfnB60F3GXPn
	E9fYOT6AfZzFPErYplZ7bSD8DFasbv9L4kski0B0y
X-Gm-Gg: AYBFou0LHR267gfHaggA2VxqDY+WhPsoahUw37ogJUFqp3LR3hxgIESUeT6I09t6geO
	DA73kGuzjv90W1ZKt367l/niIX2Y1IU/+Fh2Sm+aMOza/lAxGQqv1LL2M5SaUcPAwxfWl5S5VuF
	b6I5NCqYqbahHRgyYOtxrnIW8niYNghnboZS9xFhoaMf8FnABdSm70ML2TorNpoaarEnSQNibgN
	FiC5+BYRtATV6Wk4udZlIZTMx77BQ6oE9xS7yvG6faZ7+rs7G5bbjNQe+cpKBP3aqe0LJCC8x1f
	QmsF6B9EgI03O/54IsTSo6AhTY2ke2pDdfens39K0UzD6trIaQVFKXmzY/sUYjZ/JIx4E7kDfre
	WnjLE7JvjNy06U2DAGorTIRiwVJcVayeFwA==
X-Received: by 2002:a05:6512:224e:b0:5bf:b96b:89f4 with SMTP id
 2adb3069b0e04-5c1a0f1b8e2mr1319677e87.19.1794948840370; Tue, 17 Nov 2026
 12:54:00 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261117050841.3289652-1-jarkko@kernel.org> <20261117050841.3289652-8-jarkko@kernel.org>
 <CALCETrWtbUFQGDOCHkxAN9O4i29ixfL5KKF1Cqw2-CjxKwC6gQ@mail.gmail.com> <avyzFnKQrNOid25y@kernel.org>
In-Reply-To: <avyzFnKQrNOid25y@kernel.org>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 17 Nov 2026 12:53:48 -0800
X-Gm-Features: Aa3M54qx88-je4c1jdCxPXUBmX_p3qTxglmaltFgKplV78kiTxOHsj4XFF6xQaI
Message-ID: <CALCETrWHxjrQvRC66d1fvkZw1e8_+38BdzmjSYHmqRjXZnD8nw@mail.gmail.com>
Subject: Re: [RFC PATCH 07/13] rootns: Add rootns_enter() system call
To: Jarkko Sakkinen <jarkko@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-security-module@vger.kernel.org, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, 
	Ben Segall <bsegall@google.com>, Christian Brauner <brauner@kernel.org>, 
	David Hildenbrand <david@kernel.org>, David Howells <dhowells@redhat.com>, 
	Davidlohr Bueso <dave@stgolabs.net>, Dietmar Eggemann <dietmar.eggemann@arm.com>, 
	Ingo Molnar <mingo@redhat.com>, Jan Kara <jack@suse.cz>, Jonathan Corbet <corbet@lwn.net>, 
	Juri Lelli <juri.lelli@redhat.com>, Kees Cook <kees@kernel.org>, 
	K Prateek Nayak <kprateek.nayak@amd.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Manfred Spraul <manfred@colorfullife.com>, Mel Gorman <mgorman@suse.de>, 
	Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>, Neal Gompa <neal@gompa.dev>, 
	Paul Moore <paul@paul-moore.com>, Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, 
	Peter Zijlstra <peterz@infradead.org>, Randy Dunlap <rdunlap@infradead.org>, 
	Serge Hallyn <sergeh@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Suren Baghdasaryan <surenb@google.com>, 
	Valentin Schneider <vschneid@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, 
	Vlastimil Babka <vbabka@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 626D24000A
X-Stat-Signature: g1krd8sc454cnnb96uppmk6nb6crmjk5
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1794948842-322761
X-HE-Meta: U2FsdGVkX18tm1Ie4C/vq9HQUM0ACjj53Sv/xZ0oa89BQ4qAJSd13X4Dv0yVXBQ2PZYhG9jEQ1wmSjSaRuaLOfeT082yByXA8Np20AmgZk/5+bQHx4jImqOSj0/E2ZSWQff4ncWvBC2sp8Q17vRjKzI0nK1oqnA92qKmb5qB1Vph1/+vgxN5+LfKvJ7XhBC1DArJB9Jw97IEeZUK+k+UsQ0Fl+Hb+CVx4mzhMkvJGG/81N1obfI3fB/fb+3okpuUSlkIKup7E9m77NH7hTI5/OZ6tCp2qnPgIyKejAFCfBmXhebCJBlG5kcg4upZENezHrZh3/oHivwSVVsyysEaIm9T+/x0WMCg84pY5JNmA5jXXBRzOhcOYbutOJmrm2xwMZipsh7YqfxU8Ntw7XrRQ0XKM/8BhEF8tMvHG0B3KEY8mhZDogPIiAl5JXM6rDBRo6EW4WnW2l9fOxjUcRiAGnG/kxLhuCcWq2kXjmvVKa+/965u+76AAZd0DThW7u2Cim3YDWHR3GcSRyJzMHdkwWMmxwjXcp8Peow1o2D5/1a83rlOTLXbeza7MCganrKNz5vIuIJqSTh6J+V1YWHhCj5Df6Q6osFFRqYrI3fouACSgnRkHFMfNQ8M1+3GXM0eiWuXtpYm1nlTJBoH/+OAoKka1DhxOo0+N5G2XGbruB9bIgSFnZCQO763VjFS2aM6qG8oZbI9q98MZAs2qyE69yT6Sh4j2cA7ph9NI9wXq+/f7SfkDvzP5CHAHpCdC0JQPiVeDU3iheD7ww2EqJOu6HfehPfVyVpq6A5fMoQft/R2dA4s3IGenKMhlYtNbT6LHfRI/GOO5MoCFeDYkadpvLhJ/3IZ6DPbV2ufL6Zm9rv5jn6RmdS08mAskepALuNqx1/973ZRzE8ZOPhoIqwI4YT2nel31/ain1cROH+Go5DxqvTinoceGKMZ0qnRexWDPh0wOdVqKs7qOoIiyb+
 B4qbONE1
 ROo2XUPIGWTwapNDgxwX9DHBl+uFgt3qCJiM5BTjaCfSfK9S3OIqoEn+GSY8Tj6nZ5OIqRVrp7/A05AcSY/o+o90e7zoD2nRYzKTaupY0PPFzZrtr1GcCihc52BymlIqyDl6JCGWi8+i7tNp88XxR+/DNUhIynJha+1NZPmaMC/kFtCIG4DweErITrYms8lwujTQhC98CDr6tfY8PnkySaaBNNqsdwFccr7+oZT4LQWBrjhqHmCwpd6Tf9j2t0UU9jAvX1QOwZZOExVW3ZQ7B2BZP5y9Y69N5DK++d9hO2OBhbSk9Z/a6JS3I0mc2hrfwLIOzNqTIJZ5i+VauOEHBY0w681Zcuj1ujL7hm9fz+AlyKnFcklDmJpGnp3Pzmu69P7ZZJ4vMq7lXdno=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 17, 2026 at 12:03=E2=80=AFPM Jarkko Sakkinen <jarkko@kernel.org=
> wrote:
>
> On Tue, Nov 17, 2026 at 09:42:26AM -0800, Andy Lutomirski wrote:
> > On Mon, Nov 16, 2026 at 9:09=E2=80=AFPM Jarkko Sakkinen <jarkko@kernel.=
org> wrote:
> > >
> > > Multithreaded userspace daemons cannot call setns(CLONE_NEWUSER) or
> > > safely mutate process-wide filesystem state in place before spawning =
a
> > > child into a target namespace set.
> > >
> > > Add the rootns_enter() system call to fork a child process directly i=
nto
> > > a rootns whose root mount has been installed. Transition the rootns f=
rom
> > > ROOTNS_READY through ROOTNS_FORKING to ROOTNS_RUNNING for the first
> > > process so it becomes PID 1, serialize concurrent entrants on waitq
> > > until bootstrap resolves, and admit subsequent callers into the runni=
ng
> > > PID namespace until teardown begins.
> > >
> > > Require CAP_SYS_ADMIN in the target user namespace, forbid credential=
 or
> > > PR_SET_NO_NEW_PRIVS privilege escalation
> >
> > Why are you disallowing this if no_new_privs?
>
> For no any good reason at all apparently: no_new_privs is inherited by
> the child and only restricts privilege gain across execve(), whereas
> user_namespace transitions are allowed under it.
>
> So yeah, it's a spurious check, and thus I'll drop it.
>
> > This isn't necessarily a showstopper, but fork() is really quite slow
> > in many cases.  It would be nice to have a more spawn-like API
> > available.  I assume it's possible to open a file in the target's
> > mountns by some sane API even without entering that mountns, as a side
> > effect of how the fsopen / move_mount mechanism works.
>
>
> If the caller retains the O_PATH fd returned by fsmount() for "/", it is
> able to open files inside the target mount tree via openat2(...,
> RESOLVE_IN_ROOT) w/o entering the mount namespace, and pass the
> resulting fd to execveat().
>
> For avoiding full fork(), there are (at least) two options:
>
> 1. A rootns flag in clone3() (e.g., CLONE_INTO_ROOTNS) and a rootns fd
>    in struct clone_args (disallowing incompatible CLONE_NEW*, CLONE_FS,
>    CLONE_THREAD, ...), and callers can pair it with CLONE_VM | CLONE_VFOR=
K.
> 2. A flags parameter in rootns_enter() (e.g., ROOTNS_ENTER_VFORK), which
>    would map directly to CLONE_VM | CLONE_VFORK.

There's also been some work on using a pidfd-like object to build and
spawn a subprocess.  Supporting that would make sense, but I don't
know to what extent these projects should block each other.

--=20
Andy Lutomirski
AMA Capital Management, LLC

