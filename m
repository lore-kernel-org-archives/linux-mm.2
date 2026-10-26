Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B374A606A336
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 22:56:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=ifj7iHNS
Received: by kanga.kvack.org (Postfix)
	id BC1746B05B6; Mon, 26 Oct 2026 18:56:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B72BC6B05B7; Mon, 26 Oct 2026 18:56:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A39896B05B8; Mon, 26 Oct 2026 18:56:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 671C16B05B6
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 18:56:35 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D704B14089D
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 22:56:34 +0000 (UTC)
X-FDA: 85366288308.24.F6F0B0B
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	by imf19.hostedemail.com (Postfix) with ESMTP id E2CE41A000A
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 22:56:32 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ifj7iHNS;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf19.hostedemail.com: domain of jthoughton@google.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=jthoughton@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793055392;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qh7+bL2tt7/pVu5eSjikO++61ieI9Cj5ZNr8SJkHxX4=;
	b=lMdGnN3qwELkGeA/Hy5TO1283g1XcD0//kVVadXDD4qHv6BPRqnejoeacXeKtVHgQxXt6X
	BjtP9Fuve553TpxHSxU8i1lN9h7MJ2Q3lV6LGHwFm9ey0BTUCp31s5gk3vsaM1uo55XJz0
	Xn5CuO1AnRSG3S7mrmUhyBdnQfms1F8=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ifj7iHNS;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf19.hostedemail.com: domain of jthoughton@google.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=jthoughton@google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793055392;
	b=S2xz7l90b5YYbETQPddYDq443AroZ4zq31/7PKtECzbml6JDqmbaysdB4A6+wZt54367/l
	kIUnd0tUsH2J9bACXvb323v2lo6wsrp4eM9qZpe0FlOgkoGDmRZjtr+NWozfZZy8oSK/WE
	BrJ4mMiMKjeRJLyu7VMh9y8O6qzG24U=
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-c4550d8ab15so454327666b.2
        for <linux-mm@kvack.org>; Mon, 26 Oct 2026 15:56:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793055391; cv=none;
        d=google.com; s=arc-20260327;
        b=P12Qod4f1b1xYAO/xUaUtnvxPkjnoqxQQICt41jZpvO8K1AdIE6ZgBf7NbebAaAUf3
         D+S+/d/+LoCktQbnMg4ojP3UaEx4YP3rWWW5xrCbImaUf0IHKlvPudyDJ6UqgOQAJQdn
         LYENn8FoyAM1QhNxBmJTctwod2yOs0NfFAsxPT6s5lg/Qc5Ecwf3KTM3+bJgIgpARRt3
         ii88Sxo2tMlC7s7CFwgryF4F/pOvNJYXHcT6fA98IntWa9WBATzzNcESNm+TZm7ZVf62
         1TQCnWN6ciay9PitU7seFVKLd1pucS97GIyTXXxqOXJxrXKJmO+WSwQkiCev2CKquU2A
         xKJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=qh7+bL2tt7/pVu5eSjikO++61ieI9Cj5ZNr8SJkHxX4=;
        fh=+ljMVeykY4tISXistx9psKAq7bm0tKd2SGuId96oItU=;
        b=PmzdZID83t9iHLR2MyUuMUahzm5KjGgW8JPPOizYBEATOaZIDfgmjXqkM+awFuNFSq
         uVzHQ9WTy7s+70GZ4JFGPytsk39ThQcJCzgwYYDjNR8r7CvOjCM9OD5QSbSP99dm7F6e
         0oRktEVXyh6r3+91hh0rUsO8QsHVr6g09komliFEMC+PlTLbE++bxYYNrqeDLV/zZaV6
         2LgwjE/IAzO1rbbshdIAj4E2mON9alaTHXuRcPYgVZ1W2sNxm7LYm8a85887Ft2euuih
         9PRoyIIQvt9IgAvBSyCWN56mtQ9Mktjc4JnHVbMFJN6hqrw0t+1ZrCNs9vB2V1LOtVGv
         ewpA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1793055391; x=1793660191; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=qh7+bL2tt7/pVu5eSjikO++61ieI9Cj5ZNr8SJkHxX4=;
        b=ifj7iHNSGNWxZMisNVjHqVVwDr4GGSN44NgG8kR3fvQaOm9/ctWw/DYnuCEi3goM1b
         wW1ZeMsDI6eBkFXcYkBaLjyb4qIX8DDOI7rwS9d4a9oz2cN/PbCwk9W/KgtwBNTyZNgn
         TrqdCGlFgLxVC1oQac9gnIMOiQjz+qnWZJjdwT0ZBCC8Nyr+Mz3Ca/almo5sq9wontuX
         92qw9RmLMcZJSCENBHAdzJO/CyNhkwxFkM8I7BNnedafiHXnKIUi4sLaF/xEQVcWKrPI
         3kWa/FPej8eVO9fdmKq8oDEPZWoenIIqlELOaY7zGvy+5erF5GzBAkqEiyOhhe+qDNRX
         ysew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793055391; x=1793660191;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qh7+bL2tt7/pVu5eSjikO++61ieI9Cj5ZNr8SJkHxX4=;
        b=O3WPUTDuSgUCNx7XRwHgPdyR3mMLkRxwsFeOLiPwpc3/LEk9vzohgL+LbfsinTyTzf
         K+syhxnlWabhh0HTDYeUq5k2M1fjNEvWYTU2tY6AvLuKcJiZ7fANr1wr7RgoTqFJgMx0
         rOCadgOCef0y4z5MyZLzQGbjr+7/kIibhXFGEuwCFzm3gidtB06kWXElpzAsdKik9sSI
         4OTR/ejaeHGFHPmJwE3xxvYfO7ZDLEWqS+/gZIms7V6LWGfDY50GmGSQnxmZFGY7uczf
         PJCNOn1IAZYhKmq+l1TD5ekZsVWpsgGz3q2LYsKJVVzpm2Nq6rwnRkyQQ1WTB073O4CI
         aFaw==
X-Forwarded-Encrypted: i=1; AKwUvBx7VgnFnr+w5r4tpLs0n99guYRm1DDe0LbLB1vi1win5xRUXf32Mdi4N/GPqvRjUtmVedAuZgBj2w==@kvack.org
X-Gm-Message-State: AFq9FYI3aiN6Q1T+yY7OF+v5VQroGkhFaSOaowIYYlFLedR6JZaha/hy
	PIOB6iGSpVmEg9pg+ovNi42GHrG1afAfvYwGogQsI7HWLRwmAM1GvT5EzoCk2kyKZDFwiffAb9m
	vQQqOiYBqj1pDV6wLBfL9raMYYaa2anQNhFiBCwln
X-Gm-Gg: AYBFou15vbMYEKIuUiNnMdF0R92TLEOx+8uqg/ifNCe33nRnS5WOnD09sN3mi7MTed4
	iKkQfAj+WS6XmCuOSmbVlkZrfxV2zD6gVVOjONNWegtE4zMQQM1N+O0kOBFDuT5upSJ9+ntf5cV
	kCzI7JmQNGXSZYRepLIfVp/fYdE8SOWAeXaYuP45xJyxNZq/cRWN8nvrTfsjIA4WMdUHNjgLmCG
	3FBmw9winaaEXOCZulzxONVxdFB/M+xyqlDpznWKt1keAs0oTesmJcZjhonIv5JFxZUYxFHKRKx
	Puw7M0OT9wYFIckY0SarXvAdKP+LwXzeqsG07cuQsudMw56fVII/sJIS8QCQMHteklZ7jCcHgLs
	YPFIpmsb9/PzjgxPJzLpn09qS2rNi77acbXvrswmOD+xM3vBTXZ4m3IY8RYoBzYOqKLXp2yfpO+
	vpWqzwvKp6wRWujVQxDB20EtgeXUQlF9hmeP/EsMitT4qe9IH3YI2+Ws5q0ZdD/KS5HZU3ySFNj
	o+qZxme
X-Received: by 2002:a17:906:9c8a:b0:c2e:7da8:f54f with SMTP id
 a640c23a62f3a-c46bde874d7mr911731866b.38.1793055390933; Mon, 26 Oct 2026
 15:56:30 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261026215226.3713941-5-jthoughton@google.com> <bce97570ea9665a2f83216d4dfd7ab7ce17d54aa777f761c3d12db430ba21bb9@mail.kernel.org>
In-Reply-To: <bce97570ea9665a2f83216d4dfd7ab7ce17d54aa777f761c3d12db430ba21bb9@mail.kernel.org>
From: James Houghton <jthoughton@google.com>
Date: Mon, 26 Oct 2026 15:55:53 -0700
X-Gm-Features: AclHuK_4pEIR4EnpfJkK690R4CHqdS4wt-7zneGKcf5MW03i114xuH5q5kcZiJk
Message-ID: <CADrL8HXeYRC8w7F7e_6ZXK6MHd6FRepN_zD632j0JPjNUDrLZw@mail.gmail.com>
Subject: Re: [RFC PATCH 04/10] stacktrace: Don't unwind the user stack without
 an mm
To: bot+bpf-ci@kernel.org
Cc: akpm@linux-foundation.org, viro@zeniv.linux.org.uk, tglx@kernel.org, 
	peterz@infradead.org, kees@kernel.org, arnd@arndb.de, david@kernel.org, 
	ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, 
	surenb@google.com, mhocko@suse.com, seanjc@google.com, pbonzini@redhat.com, 
	jmattson@google.com, axboe@kernel.dk, asml.silence@gmail.com, 
	James.Bottomley@hansenpartnership.com, mkp@kernel.org, dsterba@suse.com, 
	mason@kernel.org, ast@kernel.org, daniel@iogearbox.net, 
	john.fastabend@gmail.com, jpoimboe@kernel.org, rostedt@goodmis.org, 
	mhiramat@kernel.org, mathieu.desnoyers@efficios.com, mingo@redhat.com, 
	acme@kernel.org, namhyung@kernel.org, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, kvm@vger.kernel.org, io-uring@vger.kernel.org, 
	linux-scsi@vger.kernel.org, linux-btrfs@vger.kernel.org, bpf@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	linux-kernel@vger.kernel.org, andrii@kernel.org, martin.lau@kernel.org, 
	eddyz87@gmail.com, yonghong.song@linux.dev, ihor.solodrai@linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: E2CE41A000A
X-Stat-Signature: jqdys4m3z6sbk6y6qs57id8734w1zor5
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-18.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793055392-384905
X-HE-Meta: U2FsdGVkX1//WIJeeKjmbew8i1eLIlcgFJYUvv2h9Cvh9/RvPISbdenyU7Czau65akk1fg09fR7V0tjr+3ibSSfk0ritat5GCqeEn7yehGrV98gCRt4trZh9cLmn8FeoOgOFkfMQueEuKDR5v4PubmA15MIMxZW0T1mEBkpi31GD7nyCIJO+2Bc4+Aba1VsDS5bt201imopJIeoEOwNRhO5v42ybZzuuDiwj/wP3Bdwh6inkEwbbBClimhZwnSUvlZpWvzs6jCrpECHKbOC8glYGuWbr8WO9Rrxfwe8Rhv4v6NGtgh0iQYAyFu5MMgoMvGpehYI4fI88Bds5xE6Mm3DE2t+gKGjErfcoe9v0GZdLt4vAgj4AWHLj5sgQu39xEmVCxb6S2TbQeiF7d36bXR3VCHO9BgOmgE9VPLgWj3RotNeuNdPXLA6yVLiyZ9OUU60THXrhK+mrVV3AwNYpqjZ1sRqwWpGOyyKDkRocTHpfT5kh/0FMgc+UXBCn6T589vBL8HF3v7L3UACrYCY8ctq53qOlMQMG8pLW6fRQIiAYNJyi/wqookriPgMwA2eig+bmOZBpXZvBR1K1tMNp35W24cmci1L1cF2gSNXhLXcBGx1cz+sPl+rCMhx4xuUTV98w85vN4AjiaWay6tvLQgDodTeNRlF2bc+V2q50+C7jzAHEo5zYjCjBZdEvOndyFRZE92g74wfgEKhQ5M0Oe9LrRj27AGfG/j/aPRdztCXc1if68zquaTJcdwiwMblO2wDKbzBJYGQ7IF8TyACevoeQ82cjarIwIR0QovHHfbitUTyvMIjcUvc4tQFO24ZHf90yn7Ae41zW6W3BCGSLowKF79yMvRq/mabOx4oLn86p+GjJqPZpYbrnlCbRj2JfkK9Tw8fSaeBglAP9B0QCtyMWNKuEI6vgseKWubNI5NhgjgMjNjrvzaNJgunYdmuunaaZIeymweAarW+wLVe
 sjN9a3Zt
 ywhyE2rOp/OUO+lEPT95JJUQYjY6V6l5FAlnwpGSq/G5sR7cr7rKhra9XOdU3jlKLMzCL2IA8NBZw8xZmKn8ZY9J5Ph2IiUnlUyAbdlQsq4Cze1zfFZmOs7vdfUVexsyiRf4rrlhWR5Tbr+S2ypdQgDOCpNem0q2TmnlVia7HAcutZCfaE5usGRXvg78JNPJeptT/SyDDpZUSPnd2JLxmpyTQJ+6T/KwwsdwA5iu9F3ZKo40TbIPw4lCv1q2yGWytB5RMc+R7l6i+bFk2+brCZT/0WGDW+bMh48s3Ckr+rgJ7kUgnLGqdHWUh0lENzi5u8UbI5HMsZdo+RJI8cqSn1DO6fAkl17JxpxrQU1yYjG+yByxtFc6QUj1hz6HTtq8oG+AtjcAbdsz9Scwt3X8nprTupg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Oct 26, 2026 at 3:30=E2=80=AFPM <bot+bpf-ci@kernel.org> wrote:
>
> > stacktrace: Don't unwind the user stack without an mm
>
> TL;DR: Commit message only: the Fixes: tag may point at the wrong commit;
> 7e8e6816c649, which dropped the !current->mm check, looks like the real
> culprit rather than 214d8ca6ee85.
>
> > stacktrace: Don't unwind the user stack without an mm
> >
> > stack_trace_save_user() only refuses to unwind the user stack of tasks
> > with PF_KTHREAD set. That doesn't cover all tasks without an mm:
> >  - A user task that has already gone through exit_mm(), e.g. when an
> >    event fires from exit_files(), exit_task_work() or the final context
> >    switch in do_exit().
> >  - PID 1 before it execs init, and usermode helper children before they
> >    exec, which are created with user_mode_thread() and don't have
> >    PF_KTHREAD set. E.g. booting with trace_options=3Duserstacktrace and
> >    an event enabled with trace_event=3D unwinds PID 1's "user stack"
> >    during initcalls.
> > With the ftrace userstacktrace option enabled, the architecture
> > unwinders then read the user stack without an mm. That access does not
> > reliably fail: the user half of the address space belongs to whatever
> > mm happens to be lazily loaded, if any, so the unwinder may read
> > another task's memory.
> > Use is_user_task() instead, which also checks current->mm, as perf
> > already does for the same reason since commit 76ed27608f7d ("perf:
> > sched: Fix perf crash with new is_user_task() helper"). This also stops
> > unwinding the user stack of PF_USER_WORKER threads, which never run in
> > user space, matching perf.
> > Fixes: 214d8ca6ee85 ("stacktrace: Provide common infrastructure")
> > Signed-off-by: James Houghton <jthoughton@google.com>
>
> Is the Fixes: tag pointing at the right commit?
>
> When 214d8ca6ee85 added the ARCH_STACKWALK version of
> stack_trace_save_user(), it guarded the unwind with:
>
>         /* Trace user stack if not a kernel thread */
>         if (!current->mm)
>                 return 0;
>
> That check already covers both cases described above (a task past exit_mm=
(),
> and PID 1 or usermode helpers before exec, which have mm =3D=3D NULL).
>
> The check was replaced by commit 7e8e6816c649 ("stacktrace: Use PF_KTHREA=
D to
> check for kernel threads"), which switched it to:
>
>         if (current->flags & PF_KTHREAD)
>                 return 0;
>
> That dropped the no-mm protection, which looks like what this patch resto=
res
> via is_user_task().
>
> Should this be:
>
>   Fixes: 7e8e6816c649 ("stacktrace: Use PF_KTHREAD to check for kernel th=
reads")

Thank you, yes that appears to be correct. Updated in v2.

