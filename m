Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C71B4C88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 11:50:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA34E6B0098; Tue, 15 Sep 2026 07:50:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C55606B00AB; Tue, 15 Sep 2026 07:50:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B4A716B00B5; Tue, 15 Sep 2026 07:50:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8AB716B0098
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 07:50:11 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5AC7A1603A9
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:50:10 +0000 (UTC)
X-FDA: 85215828180.09.DAC5326
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id B09C61A000C
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:50:08 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FZyLQujg;
	spf=pass (imf19.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789473008;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Wvy04NbJid/rHT9Oo2y6und5H0C/2sS7C4rNvZsUJ+M=;
	b=6ywgMBiKEdTNiLG/O29/Xb7fY6S9ShuyckWXklbXfFZ62bvbVzoh2wMhG20s+wKaP3hssf
	t2/WSQnRHEk9UNKwwayJxCBw6QJoznigpVejOrmj9AnbXY/HK2vtp+h/eOZG6x2eXgt9lZ
	rjkpy3x01wUYGIRdALqoWQl1eiAAvYg=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FZyLQujg;
	spf=pass (imf19.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789473008;
	b=dUEpsmQazxdl662dHSpUB7I5r91Hy5OQ5OaivWHKtPno7u5g60fsxoiKW8sy+1kvZ9Otw4
	qJdDZvru/txeR/kYTzw+eumIK99A3Q9TRoE5Xpk6W7gB12Fxj74E4l8a8SLBxE/GUf9lzO
	/J5qFMTBwJW9h81gduP1AowkCUAL3CQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D088C414F1;
	Tue, 15 Sep 2026 11:50:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA52D1F00898;
	Tue, 15 Sep 2026 11:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789473007;
	bh=Wvy04NbJid/rHT9Oo2y6und5H0C/2sS7C4rNvZsUJ+M=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=FZyLQujgrSLTLItt0atdLygYtPLJy07BtTpqJEj8tK4rCFepTR6WTdgjVU1CUaviY
	 /2kxpiaHyjwEq8od5PpCP63amvdhTsJyZVoAXJVFzklNTY1gegcdWYDDoR+/XePScz
	 MHrJT4NoUt8HIfXHRaVC5PMjCIQJVPlEkfbh8gaQY1dgXLLaPf3I5PVcxiOdPbdNhp
	 egKHXLxlo+8hU8IJMPwEDm1igMoQNQ50LWjgaSmTwzy6Kkr1xxWZeZvflO3a23mVwB
	 kOkyNkCaEN1wr6HpAzVJp/5fzNLTwrIjdFvuyd/aBdf6hTcIxBdJ3Y3aTJX6C30ppL
	 nzwCXruPvLzow==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC POC 09/50] m68k: commit fds on syscall exit
Reply-To: sashiko-reviews@lists.linux.dev
To: "Linus Torvalds" <torvalds@linux-foundation.org>, "Christian Brauner" <brauner@kernel.org>
Cc: kexec@lists.infradead.org, linux-openrisc@vger.kernel.org, io-uring@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mips@vger.kernel.org, "Eugenio
 Perez" <eperezma@redhat.com>, linux-mm@kvack.org, linux-sh@vger.kernel.org, "Jann
 Horn" <jannh@google.com>, virtualization@lists.linux.dev, linux-kernel@vger.kernel.org, "David
 Airlie" <airlied@redhat.com>, bpf@vger.kernel.org, linux-hyperv@vger.kernel.org, kvm@vger.kernel.org, sparclinux@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org, linux-hexagon@vger.kernel.org, linux-gpio@vger.kernel.org, linux-m68k@lists.linux-m68k.org, linux-alpha@vger.kernel.org, "Ingo
 Molnar" <mingo@redhat.com>, linux-um@lists.infradead.org, "Michael S.
 Tsirkin" <mst@redhat.com>, linux-parisc@vger.kernel.org, "Peter Zijlstra" <peterz@infradead.org>, "Jan
 Kara" <jack@suse.cz>, dri-devel@lists.freedesktop.org, =?utf-8?b?Q2hy?=
 =?utf-8?b?aXN0aWFuIEJyYXVuZXIgKEFtdXRhYmxlKQ==?= <brauner@kernel.org>, linux-snps-arc@lists.infradead.org, linux-csky@vger.kernel.org, "Jens
 Axboe" <axboe@kernel.dk>, "Oleg Nesterov" <oleg@redhat.com>, linux-fsdevel@vger.kernel.org, "Alexander
 Viro" <viro@zeniv.linux.org.uk>
In-Reply-To: <20260915-work-fd-reserve-unify-folded-v1-9-4d5217d6b246@kernel.org>
References: <20260915-work-fd-reserve-unify-folded-v1-0-4d5217d6b246@kernel.org>
 <20260915-work-fd-reserve-unify-folded-v1-9-4d5217d6b246@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 15 Sep 2026 11:50:04 +0000
Message-Id: <20260915115004.CA52D1F00898@smtp.kernel.org>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B09C61A000C
X-Stat-Signature: qozqyofwid3f5kgp6aoom718xhbp9qrw
X-Rspam-User: 
X-HE-Tag: 1789473008-281841
X-HE-Meta: U2FsdGVkX1/7OarIytIKsj0HWhXZYFsu+8Wb6MvPJDnrulzZxgTTtTQBiUuPHpz+h64y7mezRo4kkW4vpy7UYrSzY0QGlkNLiVLwFi0iGsmAkzV7IoPvmz8DZbhp6HnlyCHxR/Ekc3065+k/mguv8u7IsKWSduD4PFOwiVQ7Yhmq83l4M4Ap/Ossy+AArIku77lXH0fAxdpe2mOmeps+emhOhiDiWl3nZ8waRxjfjO7AGeDC3ly4kiwlkfJ28xlA4P1zqrhhns8g/U9aTzEVnfemAuPCYZnBxNWWnsg8pKAt3VEXwyr1o+0XUi5BOjZj/bamL67DKZMNahJqJ8ojX39FFvA/bjZz4rj6nwusLqmoLNe0v01fL3dCK7+jx4dM3NecsycJqgekjfKTgyB/418QFjZnSLRzjYDo+ZjfZolnhWNQLozcWMJIwn7HFpKNOWfACB09S80lcr4LgrfSBaBdTexRxaUSt15gAN8HvfIXPMFJL32m1VP9RJQHhfiKPOuW5T/Zm1jBg1cyQ1vi42ao/YKKrnHl7clmdLbOmkOHjFYa/phFzqo1oTQu3RtiG7VOn+W8WlO+V64mN4qIALDRIZUBAbGTSMZs+RBRkYgsekLS2suL2mPKiiXNUsu0wwyb1enhRh5Vdmo9+1m/Nr5WbZvhHAa2t76jWNoeU8RIJVvX+ykf/xZPY6QfMSD6y1yYWfHRjE6eArqcYmnhTYjWKzv64975Fq3P/avIPn+Wh9iQn12kB2hd5x6/c8RQGWPmkdWPdys4D4s1s+TLsl69bVis9zDh31QUAri1QdepGrQP/DB9YhWhDnR2texZ2+zQgcQ7WACTqtjkJi6wAcTWkxioP7ZMikaFoiBV1jSUCyfUom1y024Yhnc3HqaIH2aOqxd1was4tN7qxEGrcgDHQXXyLzo41iZCxfv4fQak7oXY7tgWJVqs+C6zai++n15f/42vkpZyo8PXrFo
 K9aQlH5q
 ABya+tJ+LJk2UoJjQIrNetRnOAYn/bqxX4IpGA2H4N4B428tFHXLI4Ks/5K05V7ELAevS4tYBshyx1fBe5f7fp/y8JTAfXHPK+/jEsGj/w4AppuoIgF+0gWU6roBuF79PMPoS3oGO2ybHmYO3olksyjLl1YVrE/g6ElwkvPkhiVOnmCgtSBirK3fTQUjnmV5itED3e6en2he/Yfor0ueyPOgdFvTumB6WeHBHHX7m55DqspbV6cY/OyNDdJh5RRt7Kbb8g2qK2409UCrspR5kw3j4Xz1zYYIu+UgsVP+5ckmf+aRNGiR1RInS2i/h8uaju8zXJMSwy42Gla5GC7u4hJGnF9C5DIKf5nsU4KPIB8lTH4AlQ5OlBFAGijBxjlC3gceKgO5ZdtPaWAjit9k2AIIDH4Db95GFOLiwtQdebE4vduj3HrHTvmD3s/IM2aXZqiBMWQ18RQSHeDvo6TiwGzXlpDdeVmBzDcXe5x4Y8CDdKvkVkmRNiW1AGETQsZB9Otk3jqH541zuDVmyzvtSbAVDjisQtV+tWQLoU5lCWQ8OC4tu4w4TkVYhsRX3UzKygsq+vXtnoPlATevuyj2DeeUky4lyHtQuEDEmF3hvMbEN1qZE7vuClp/WmR8P6S0b16Tdp1PBW0DAjrKIvO/JZHIEa5o6XIUKI2sQxWQb8GOuyWv1gsCjkDzQYFX5x1XTzthcVv3ogjkWt1ZTfXu6OcU+3w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] m68k: single-step SIGTRAP lost on fd-allocating syscalls
--

commit 731b1387fc76d92d165ee1f28de694e3d228627b
Author: Christian Brauner <brauner@kernel.org>

m68k: commit fds on syscall exit

Add TIF_FD_SLOTS and test it on the untraced return from a system
call in all three entry paths. A task that reserved descriptors calls
syscall_trace_leave(), which commits them before the ptrace exit stop.

[ ... ]

> diff --git a/arch/m68k/kernel/entry.S b/arch/m68k/kernel/entry.S
> index 338b474910f74..9e4471f681652 100644
> --- a/arch/m68k/kernel/entry.S
> +++ b/arch/m68k/kernel/entry.S
> @@ -229,6 +229,8 @@ ret_from_syscall:
>  syscall_exit_work:
>  	btst	#5,%sp@(PT_OFF_SR)	| check if returning to kernel
>  	bnes	1b			| if so, skip resched, signals
> +	btst	#4,%a1@(TINFO_FLAGS+2)	| TIF_FD_SLOTS: commit descriptors
> +	jne	do_trace_exit

[Severity: High]
Does this new branch cause delayed trace (single-step) SIGTRAPs to be lost?=
=20

If a process is being single-stepped (TIF_DELAYED_TRACE is set) and execute=
s a=20
syscall that allocates file descriptors (TIF_FD_SLOTS is set), this=20
unconditionally branches to do_trace_exit.=20

Looking at do_trace_exit, it executes syscall_trace_leave() and then direct=
ly
jumps to the exception return path, bypassing the jmi do_delayed_trace logi=
c=20
completely.=20

This means single-stepping over a system call like open() could fail to=20
deliver the expected SIGTRAP, which might break debugger functionality.

>  	lslw	#1,%d0
>  	jcs	do_trace_exit
>  	jmi	do_delayed_trace

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260915-work-fd-re=
serve-unify-folded-v1-0-4d5217d6b246@kernel.org?part=3D9

