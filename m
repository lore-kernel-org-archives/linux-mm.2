Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09A8AD73EB8
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 04:41:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6CF5E6B0005; Thu, 29 Jan 2026 23:41:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 67CC76B0089; Thu, 29 Jan 2026 23:41:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57F2E6B008A; Thu, 29 Jan 2026 23:41:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 443356B0005
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 23:41:15 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BD66BC1E7E
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 04:41:14 +0000 (UTC)
X-FDA: 84387380868.25.3C8D0EF
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	by imf13.hostedemail.com (Postfix) with ESMTP id C232220004
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 04:41:12 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Oc1YHuRP;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769748073;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=poUS4vM9rHYGHWvOUpUh/Id1h6SEo5+dkcFnRx9fiFc=;
	b=5z+zwQ5sRHdiYwdxhlHUjWSG46iyQjgADmt5T5POg3M78hnNZNPf0MOTmF7WIqoC+yz2FO
	msVAYoy+jRiTQw0aTH7oCr1pP7zfnxKNMIZMPoDyazANnMFdbPxlaNW++qoqszD3rNijmB
	+JweTBp99LpzWuAl0C62WwuwJ6ZWA+Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769748073; a=rsa-sha256;
	cv=none;
	b=Rjo1NIbO7R74YHMU6SkQDL1yuQe1+BehyxBp1YPvxpSHTQZvCjVSZZxTvYnQ/VDkQfd81U
	0e3PfsFVyJjR0Q5cZ+IEEK56moHu2iJuDVBs40zONmvrroYyLiFJ8/HVDoj6pbE4aZzXdI
	kdZRCFzoDquAxMIFNj2nakuOfGoKo5g=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Oc1YHuRP;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
X-Forwarded-Encrypted: i=1; AJvYcCUGvClhJ7D12pNZPf7U3XViJaSVZTQw6L6d4A7Qk5adg61vBFTrd3TND6SnnqkOXTkH/gEgq/PnBg==@kvack.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769748066;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=poUS4vM9rHYGHWvOUpUh/Id1h6SEo5+dkcFnRx9fiFc=;
	b=Oc1YHuRPF7b520kK7B12u7I5Uc7I7FZzctLyVdx08SyzzqAhZUG2eMYtBbyw5XAwm3W6Gk
	K1PuRwdxW3ClvSsdLnR7bJgIZXKpayXB1UYcsrNTaYgazM+MUFt7cXr3RyV+ZAy+CBf6QO
	wyt9hzDcz/U1lf8rlmTRwaKkoLOr7vo=
X-Gm-Message-State: AOJu0Yz7BqPvDhEVzxAdBjJsjlOT05NI2G1fKmmIoyEprlqr0iCcof2Q
	dzpf4uJWx1VzKWC8wJNFbivbzdWvBUXY9DeNVY+y/ByJUDkb0STp8EijyfSYkGcAokaME0GRSNS
	Mg1qDsdA3dUEMcQmLvMIcG0b4ufb/VjE=
X-Received: by 2002:a05:6102:2920:b0:5f5:2e63:f571 with SMTP id
 ada2fe7eead31-5f8e24e04f3mr566640137.19.1769748062182; Thu, 29 Jan 2026
 20:41:02 -0800 (PST)
MIME-Version: 1.0
References: <20260129215340.3742283-1-andrii@kernel.org>
In-Reply-To: <20260129215340.3742283-1-andrii@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
Date: Thu, 29 Jan 2026 20:40:51 -0800
X-Gmail-Original-Message-ID: <CAGj-7pXkzS1sioE9t_wXZK=w0O-FDK3k4n6oEsruhnc1X_0=rQ@mail.gmail.com>
X-Gm-Features: AZwV_Qg5dfk2ht8JupIDFXTqsdxMg36LioUN_5yZDOZCUGFX3Rv7JHpElpOR8RI
Message-ID: <CAGj-7pXkzS1sioE9t_wXZK=w0O-FDK3k4n6oEsruhnc1X_0=rQ@mail.gmail.com>
Subject: Re: [PATCH v2 mm-stable] procfs: avoid fetching build ID while
 holding VMA lock
To: Andrii Nakryiko <andrii@kernel.org>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, bpf@vger.kernel.org, surenb@google.com, 
	syzbot+4e70c8e0a2017b432f7a@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: C232220004
X-Stat-Signature: y4as8hk9qqaqrhzb7pu6faruk4zpcr7p
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1769748072-721716
X-HE-Meta: U2FsdGVkX1+gIVPE8Gdlgy1Q4XQe39wxJ4RvGYfet7PKd/Pp3Zqe2UhjxtpOj+HaJ4m6Nrs/lGGSviuvOfqCaDEz4xBQjUdaxYEempe1wQqwHbLYyghshBaGvheI2g5MuaRA7pX9+v892+/oGVl99mRDNKBpysk0+8UL6E61fA80KeRLq1mL47q0EHO0J9cKJvmNtG6IhFguZuVRVAsWFiKupDGckZhoQ70HKzThSQ7D4LQcDKy0uAOt4IJ4dODT83wonyh+0kEJ05eF7lxYyZLTo+oPKpXThfZYkIc1JormpL6A5W/g4/YC0PjrwSTKlZfRgRdvEThU4jRsufuS3wsdWGGQhZ6c/YYXll0ynG1S3eKhFFIu+b+K4n66e/I5Cj0wtmAVcUmHxILrffyn6bJ1ELZ+qtlFphflhFo2dHuGV0sSFxYZ6UO2n3EingCLM9vQdUIWTo7dcfTP3cN4kJ5xeDd/VsEUn1jdcTUVQ3GMm+EwsnkB3DI/WkTdXUPPcES5O9X4O7YqCol51K+NCyj3vGEF7jCBmFVLBI8LYVqI0MJOjfiadbhldslL+g9N1r9bHoeBTH+frPqBvDMTBnQZ8y+P3JPXFuQNxbpIu8ckJrbeoowK9wO4/J99kCHbiLbi/MIXaiZKkQuWXqsc8u5cfelzsza4aSm8T2y4VLvoH2b9PXxZtONUIkEv1PqXy3v90V6h6IZAvcY428NUSHEGjwD0N+3h7I7skfs7aM7Z+eS/jUAPlL0ZgvIHTiy3egjskXSd3zfDod4YU3eu8lMtdhdQM0n0NKDlBBQ+1IalunGBQlW1Hw2S01pELR1zvgPaq0+FTKF6i6WjV0yq6NpCdOmRC3VwC4V7gQNwWAmxOLGMc+LlmfjKcIWsWUpxjXywtUepglr8QdqH1LD754e5IBuBdl95/v4Z4y+ljgF7e3JKCwAfWLjj1SAW//dBQELbKlBayurU1HynRgM
 Md/QIQDK
 DSjK0ek//TXXm35JUMSSAthj4pdUDPsC1LF2Sm0J8FFZ/9EdESPmeDzLfrpFk8VSDvxrNW82ohkCEm/Q0vfkCv039gKYpK84WEzWYzL7YkDJ4EKKtfY4dl2RyZF3MtZAmTDe8cnvY7X5uWsGGCkdIVE/fybstID6yN2FbEWg9G6KZ8UQRipXw59SHJ6folETFHNFkJCSC401M8IIz6A419KGNccxUf6Qzxqe1Qoqz5jre2uBWBJxgisjPz9QAZeBwdPKWv04REgwpME8XGELAA/Tso3nNxKqFeicLRwutEAiBEUtBEZw0sP35UxZXf13eZuJEdyLGilpcy3H3czM+eCONUjnPIpfZTd6Sppc7UeXkAbRdxoenVstInw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 29, 2026 at 1:53=E2=80=AFPM Andrii Nakryiko <andrii@kernel.org>=
 wrote:
>
> Fix PROCMAP_QUERY to fetch optional build ID only after dropping mmap_loc=
k or
> per-VMA lock, whichever was used to lock VMA under question, to avoid dea=
dlock
> reported by syzbot:
>
>  -> #1 (&mm->mmap_lock){++++}-{4:4}:
>         __might_fault+0xed/0x170
>         _copy_to_iter+0x118/0x1720
>         copy_page_to_iter+0x12d/0x1e0
>         filemap_read+0x720/0x10a0
>         blkdev_read_iter+0x2b5/0x4e0
>         vfs_read+0x7f4/0xae0
>         ksys_read+0x12a/0x250
>         do_syscall_64+0xcb/0xf80
>         entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
>  -> #0 (&sb->s_type->i_mutex_key#8){++++}-{4:4}:
>         __lock_acquire+0x1509/0x26d0
>         lock_acquire+0x185/0x340
>         down_read+0x98/0x490
>         blkdev_read_iter+0x2a7/0x4e0
>         __kernel_read+0x39a/0xa90
>         freader_fetch+0x1d5/0xa80
>         __build_id_parse.isra.0+0xea/0x6a0
>         do_procmap_query+0xd75/0x1050
>         procfs_procmap_ioctl+0x7a/0xb0
>         __x64_sys_ioctl+0x18e/0x210
>         do_syscall_64+0xcb/0xf80
>         entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
>  other info that might help us debug this:
>
>   Possible unsafe locking scenario:
>
>         CPU0                    CPU1
>         ----                    ----
>    rlock(&mm->mmap_lock);
>                                 lock(&sb->s_type->i_mutex_key#8);
>                                 lock(&mm->mmap_lock);
>    rlock(&sb->s_type->i_mutex_key#8);
>
>   *** DEADLOCK ***
>
> To make this safe, we need to grab file refcount while VMA is still locke=
d, but
> other than that everything is pretty straightforward. Internal build_id_p=
arse()
> API assumes VMA is passed, but it only needs the underlying file referenc=
e, so
> just add another variant build_id_parse_file() that expects file passed
> directly.
>
> Fixes: ed5d583a88a9 ("fs/procfs: implement efficient VMA querying API for=
 /proc/<pid>/maps")
> Reported-by: syzbot+4e70c8e0a2017b432f7a@syzkaller.appspotmail.com
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Tested-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>

Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>

