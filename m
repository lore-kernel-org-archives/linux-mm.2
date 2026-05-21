Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4080CD5BA4
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 11:17:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D23C86B0092; Thu, 21 May 2026 07:17:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD4BB6B0093; Thu, 21 May 2026 07:17:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BEA6A6B0095; Thu, 21 May 2026 07:17:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B2D9B6B0092
	for <linux-mm@kvack.org>; Thu, 21 May 2026 07:17:04 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 64D931C046A
	for <linux-mm@kvack.org>; Thu, 21 May 2026 11:17:04 +0000 (UTC)
X-FDA: 84791175168.01.F33043D
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	by imf10.hostedemail.com (Postfix) with ESMTP id 5BBB4C0003
	for <linux-mm@kvack.org>; Thu, 21 May 2026 11:17:02 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="h5n/IZ6K";
	spf=pass (imf10.hostedemail.com: domain of jannh@google.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=jannh@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779362222;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4MHMbUpyjFKbGRU+m3K2+cE/UIYqNo0bIi0jdbfulhU=;
	b=drYCq84BAYXEQ9i+W3lv8pIuFffqjrDGNVjpcofjzW6fPtWN4rwXjTpV+p2xm3LClDiBHJ
	e/0pUi2LqpNjQiGSJkNrKVWTDA0mcjVE6CveKC+cvXtwOMPSkR9n5hiWHYuKFwrwnbj0LE
	WPJ0uOIuUbHeQjPN59Z7IaRFaODIrWo=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="h5n/IZ6K";
	spf=pass (imf10.hostedemail.com: domain of jannh@google.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=jannh@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779362222; a=rsa-sha256;
	cv=pass;
	b=iIvq2JnVUX5pop+pu0hN148ZEADq83fEFcs8JYsNHX5ZoMwUk5KjcBvziG5TUxU0DSqQyF
	zh/ZWGgS9iwZmCGjzua78pabA27kXP+6mn2yvv/1CZa7NtQI54OXnR333zq/gLabgAIyt0
	xrLpVpeTuHQdfhULIZ2JzKjJFwxu4XA=
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-67bf769704eso9a12.0
        for <linux-mm@kvack.org>; Thu, 21 May 2026 04:17:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779362221; cv=none;
        d=google.com; s=arc-20240605;
        b=Hi6wRef/C08M3ML1ZrKSTCSoAnKLL0AXvUQ3iXvkomc5ZJjKzoBZnGRlF8A5bPxY7Z
         tFwemLGCrEbq+hRCiw+dJQcjg2V4SD4uZfvBb8+N4XaU1s5jwv0Mx865R8rTr1kvuYya
         o0cIUZwNeOJ98jQc5OVzbrmQF4e+kGCr4aAyC6wgP50Hoq4cwEwu5Nq8oc9gXf1lkyAS
         Ovkg+6nxyLThdtTmjZSs11n0TKkGL6IP2yzltKl8GIBJtzwAgJEFG8s54EPim82aR5wq
         6CzbaFy2RtOlvgpLO8VM2U2dCp5k61kJc5y/jZcJjwWhidQ8WzjZw8kCAcNqS82XWeBH
         rHjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=4MHMbUpyjFKbGRU+m3K2+cE/UIYqNo0bIi0jdbfulhU=;
        fh=ZyffSwJFbpnNNj1MpIU+VmkJnDKA3fMOiS6tmNmvrKM=;
        b=ILxvSXkO3hh1AbkfsXtT65KUXP3sXK68KfP/cZsGKropnLvEqueAzgzUZPqK7ACbrW
         iUDiMW4PzDwEQ1JCAbUKqL7RG+cv/lfHdZHDOeq/pPIZpSrT/6FPOw4QW09Fz1tjoKLN
         WrIIYqahRrSVqWD0ZvdHNlWjLYyAv31eGjBMKc7bKfg1x+Mkya/bEYxaQczHm92B8PSE
         bOwMhU6H+UaJnCDRgBK5YLQEjoCtkwiexX5lPAT0Z2l3lAcrWWUkgbnB83cq6qoz/PWj
         SPwlXCE7k1ErZSY9hXxR/nHCaQwhOMgRyWsluuDsDCXeOZB/aMz5YAI5VGe8q2ol8Wm1
         DUTQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779362221; x=1779967021; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4MHMbUpyjFKbGRU+m3K2+cE/UIYqNo0bIi0jdbfulhU=;
        b=h5n/IZ6KkUFRzVeknFiOI/9f/wB8p73qwW50IFq5sK25ie3oioJkl0+BmX3xH+WMj9
         +oWpSXOx6Qzj3RDYQ34WWHhpTpBjjsvJSGPK4eFA6ZI2qQvWdA/wHp/gOCh6EzFNqwMq
         TFjA9mx+JtTJ79sGjGGfsRJbr2XG6Kru4NsO0Z9uFNDZOeUwKSjqShh40fHkOQyVgs/5
         Re6OGlTRyx9+5EXsSZ135j2TXXvQfGkPvexK/HCQ5Ahr3Xjn0T09itzn0qw4kzlO2wq2
         J0ouwXqeAavIoFQe3rkqoF8IiYT2SrcYcSM2Zn92rpOp0DSHFyvFYCcywtwmWPS5V5Rp
         Hbmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779362221; x=1779967021;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=4MHMbUpyjFKbGRU+m3K2+cE/UIYqNo0bIi0jdbfulhU=;
        b=c+AF885HfoHmp39lH6AcPnJQ47gJMXmlOWmJ9NmdY69j98ejYrM436tXi8p1oU2Zwq
         GmsiUaLuF4JVTaxhA4ifBc5LikLxQ03kaF9Yt7LFThJ8fS3HXJ7nhyXnJ2kNHDsCj2Kb
         CZ0cOvJaZN504mLyz9RHq2MQ+bYIMMsQlamI88NImVRoIOZFaxu+HI7CAujJjW/T+Z8n
         Y/vS0mbUKSzkYQiTwGBQ12CURixoertxzTqGOYXeiKyJtM3f2Y2NH06vlw2lL1UBOM3g
         PGwMU58PF1eibcUGjdY/nhYMKWnWJ4WtzN1kPIDCZnjQjv525HcMg8Jhjg03OoJctUc+
         +dqA==
X-Forwarded-Encrypted: i=1; AFNElJ8Pdz/VZe1fKplV/A0FiQIm2loNjRwyavGmv7yJADYpcwVdGIByWaa25USUWKdhhj0BpNF+acdnTw==@kvack.org
X-Gm-Message-State: AOJu0Yzem7QLvYP1L94a6qp2B1XVpn7JPeOpDbBjszHL/zguNuGH/UxR
	mftD/2MqQCgxpwWBpPdZXkmBXeR/W9tCbxV53pz3Wr7QFW1M9Ke0G77W/+aGIDv5mvHnoPRGXsb
	esWConIxjNRpXqV6vsoYCFMKwwG+maMxRoSfCMDPL
X-Gm-Gg: Acq92OE74FjV6OHM8SNyMgHog7KsLcjuCTvZ3Dp+lqWZX+68a+uPgTaCtIoqMsQ4zHu
	TDEpKDZcx2PIP8Unaz/dzhEbZz3A8JpoT603RvrE9/aqa9KTMA7vdCA92o0pgZTiWYHh/2ifBvg
	wWzQai1CtI3dquM8pAgEa0eKjdGEbeA/r5osf+nECnDZNhkvdjvljXrD52N15/Nr1eijDeBydLf
	BYYA8SWNNfOV2DaT29Uxj6Xl9Gu52/qQAecDE15K/DSF7dm3AG66g9/c2Of8yo+EAznEGmDQ4DZ
	z3HYQZXaeLqOTskQEGSkErGN5ijfxHk2M1Ht48fS7FzaowZih0SKLxPXtBo=
X-Received: by 2002:a05:6402:4249:10b0:678:a5c3:4d12 with SMTP id
 4fb4d7f45d1cf-6882db230f5mr41122a12.3.1779362220197; Thu, 21 May 2026
 04:17:00 -0700 (PDT)
MIME-Version: 1.0
References: <20260520-work-task_exec_state-v3-0-69f895bc1385@kernel.org> <20260520-work-task_exec_state-v3-4-69f895bc1385@kernel.org>
In-Reply-To: <20260520-work-task_exec_state-v3-4-69f895bc1385@kernel.org>
From: Jann Horn <jannh@google.com>
Date: Thu, 21 May 2026 13:16:23 +0200
X-Gm-Features: AVHnY4K0NinRABXZDH4CnorNiuamLxpNgFx_Xa_c3C3I9OzHlyeC6YES-RDrIR0
Message-ID: <CAG48ez3Fd=4hoc=zt77paKxjpSnuf2ESVho6WSH47M1t3Cg5GA@mail.gmail.com>
Subject: Re: [PATCH RFC v3 4/4] exec_state: relocate dumpable information
To: "Christian Brauner (Amutable)" <brauner@kernel.org>
Cc: Linus Torvalds <torvalds@linuxfoundation.org>, Oleg Nesterov <oleg@redhat.com>, 
	"David Hildenbrand (Arm)" <david@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Qualys Security Advisory <qsa@qualys.com>, Kees Cook <kees@kernel.org>, Minchan Kim <minchan@kernel.org>, 
	linux-mm@kvack.org, Suren Baghdasaryan <surenb@google.com>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Michal Hocko <mhocko@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5BBB4C0003
X-Stat-Signature: hm33a3x53hdmhf5rgadycjwzrfpughro
X-HE-Tag: 1779362222-758303
X-HE-Meta: U2FsdGVkX18LSpgJym3BZ40YBabYD8olj9jtPYOfN6ZWaRj+mO0yok/z/YRgnCZRTGtbQGy+gihAlis8c6+Xo6DLhuok0JmpDyXUKLHBuzgfxouKlGrwSlN3+CQv/8tqvR7USaWIgZSC9s2F7S33HeA6tfZkriug+LtQwfacjWAyYmUGbDoeLhF+hWQiviqGgfHWchNfTEb/4q91rz9tf6L0/XYuS9gY7NdSiSGqlosmTgcafLpal7UtWM9qg1hQnOqn+1cCdeksk4sfKmJcZM68JYybEZf9jX1LKnVbJ7Yxs2NxnW/0mL7Qmv0tXUZKhUJaiZENb/M4Y6YjvSoloOpcaX+/C6pc4Tv8aM6PUOQtiIlgy/dU4H9bsQh7H8uuP1cEnG+sm0pLkmlsWQs9YIy33e75YgV2WYGjdnF5CPO2vdLILVV9XrmP95SUnzlwXejUyLl2tttqoU/apMRCtMwwLYB/XBdAB0T0UKRZWcSCsA8gdfGjHkxd5VhYto/DKNiGsq28rj7SNcK5xyKCOF5I7DgdbYgOMeKtcGXNSYAnRGKcoRl15F6oIQr2h2OczvHTSUsTr1Ofe+0DgaAymdnVrx3jkPM0elYIUPVMafE9bUzbTOo4sogCzy1nYlrGqc/jDBa1M8uPWCFgnrSRSEsKtzBVeGHI9LhSkpBoIxPOx5oI1JeC9GAs23aTYyiXlXncbHg3HnibIiNeSuQM+qMjAjSsn9RNeisbAiYQKMa/6gxgSG1Ww/ck7WmkBlbnyftNiDR4r9Ngz8SIJww5XOosTU3BfnM1HulFxjXyi/4TKJcQAMtNhJQTxf/JTPrm7chJ0WXSBD+TOi0drJgR4EB6LunhibjMJ5KmFEjCSL6DrmF9WoPnIossfEHWsyQNPAW9N+h7l6gQcZD4i7bP27i2r4vQvwtggEzuZh6zCvuGqdu4MQdCRFNt9oPdBkw9/la7zX+Mspy2437dOvZ
 1gSzi2fw
 6JYAoxCI3mvd0LlML5hv9LudOry1N2C4omQRIJAxTgKbv0EqK8InlPSnOKfWEz/6WqLgGxk90tmwYh9wrrvzhB/tjdhFOGIOaod7le4I9XWgFPUHkIWq2xnZMYPyl9GwBGKNGCIAXqrNIRVm2NddZBzk6tntUfZehmS+IBpNQQ1uRljZM4ecf+1Zbtcm7fQDszdntRyHoqxtNPyTtcNSPlMJV5zHjf3vCEigpDU/w8b93dyqF4HaCLeLSHnONJNO3NrNbi89luQTe6bqZaj3mGkEKEJbnSvlotyhAg+ROkNKeNBDdDgiKcEk0vQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 20, 2026 at 11:49=E2=80=AFPM Christian Brauner (Amutable)
<brauner@kernel.org> wrote:
> @@ -2090,6 +2106,9 @@ __latent_entropy struct task_struct *copy_process(
>         p =3D dup_task_struct(current, node);
>         if (!p)
>                 goto fork_out;
> +       retval =3D copy_exec_state(clone_flags, p);
> +       if (retval)
> +               goto bad_fork_free;

AFAICS for state like this that is torn down in free_task(), normally
dup_task_struct() NULLs out pointers that require refcounting, and
then copy_process() initializes them properly, so that in
copy_process() we can bail out in the middle and have the task_struct
in a sufficiently clean state to go through more or less the normal
free_task() path.

In particular, I'm thinking of the handling of tsk->seccomp.filter -
dup_task_struct() sets `tsk->seccomp.filter =3D NULL`, and later
copy_process() calls copy_seccomp().

With your implementation, the error handling would break if anyone
tried to add another bailout between dup_task_struct() and
copy_exec_state().

(Sidenote: Ugh, the way dup_task_struct() just copies the entire
task_struct is so ugly...)

>         p->flags &=3D ~PF_KTHREAD;
>         if (args->kthread)
>                 p->flags |=3D PF_KTHREAD;

