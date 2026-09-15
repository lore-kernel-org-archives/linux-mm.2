Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A92F7C88E7F
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 11:48:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9DFEE6B00B1; Tue, 15 Sep 2026 07:48:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 990BD6B00B2; Tue, 15 Sep 2026 07:48:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 880EE6B00B7; Tue, 15 Sep 2026 07:48:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5C6846B00B1
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 07:48:15 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E259B1203B3
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:48:14 +0000 (UTC)
X-FDA: 85215823308.09.9BCE2AD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 4795140007
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:48:13 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XT+DfR2f;
	spf=pass (imf11.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789472893;
	b=c+A1LIqjPrUk0JsaTEOuZY3zllxbhlCGpxaySEKLun8A7WqBo0v/0YE1sES2CW7siwbgMl
	VW4UDOh8yNCjd4pYhjxfQL3oV+JtJkksu09iyTKTu8jM/uzmkigwIyxDOoTJIJU0xQSfUN
	mHKFbvjsaIqofntc4BAY7oWUXEGyMbs=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XT+DfR2f;
	spf=pass (imf11.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789472893;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+hCyRfdYxaDHjUjrbC2f1l+hk2nsMICX165AMlBJOFw=;
	b=yFLEcME/zuwYSH7e2Va8Tz2GQ8s0i8L5vVT79p3fb2+i6eXsDChQuegdkVYYUUnmBcrnTv
	LOHUaLkqwRJJmk3j1ffn7xTLI7ZzPRENuncHK3+dWbZ119yfNwBI7GaKewmc53rq8xkp4/
	c5dcxQS6/4ZCr6jPVJBVbjWyHKtpAAI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7623741342;
	Tue, 15 Sep 2026 11:48:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 973821F000FF;
	Tue, 15 Sep 2026 11:48:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789472892;
	bh=+hCyRfdYxaDHjUjrbC2f1l+hk2nsMICX165AMlBJOFw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=XT+DfR2fI9lSDVHTRxc8fxOJ84VdAucgEp1D7Rsg22J1SRRtMEiE19TvXZrbO4lIZ
	 TxJ/l2gehvn5l2kdO5dHi1/HiNiTrodHb341ROtDKEQB4TK5qE077C+sr6m2ZRGq1A
	 YhT5vOmSLIZn+aB2D2xVS3UmQD+O73OuHKWdb/9Q6SJtudR7Vr4EWHcVJIUSGq4wWb
	 EwguAAzu7/EG5DnE1SXHjXkeQUDSQ1mouWrUTfOdgFhzkd3ZU0wbFF/c3Yr6mjzm+T
	 iHVYaDYddqfXs43IVkcTAt+29bmm0zSxlyvXzfaYtnXgwc/VcrMwi/snt2mFoFeFgS
	 xEBfPHquaOhWw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC POC 06/50] arm64: commit fds on syscall exit
Reply-To: sashiko-reviews@lists.linux.dev
To: "Linus Torvalds" <torvalds@linux-foundation.org>, "Christian Brauner" <brauner@kernel.org>
Cc: "David Airlie" <airlied@redhat.com>, linux-parisc@vger.kernel.org, virtualization@lists.linux.dev, linux-mips@vger.kernel.org, "Oleg
 Nesterov" <oleg@redhat.com>, dri-devel@lists.freedesktop.org, "Jens Axboe" <axboe@kernel.dk>, linux-um@lists.infradead.org,
 =?utf-8?b?Q2hyaXN0aWFuIEJyYXVuZXIgKEFtdXRhYmxlKQ==?= <brauner@kernel.org>, "Eugenio
 Perez" <eperezma@redhat.com>, linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org, "Alexander
 Viro" <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, sparclinux@vger.kernel.org, linux-csky@vger.kernel.org, linux-sh@vger.kernel.org, "Peter
 Zijlstra" <peterz@infradead.org>, linux-snps-arc@lists.infradead.org, kexec@lists.infradead.org, "Ingo
 Molnar" <mingo@redhat.com>, io-uring@vger.kernel.org, kvm@vger.kernel.org, linux-hexagon@vger.kernel.org, bpf@vger.kernel.org, "Michael
 S. Tsirkin" <mst@redhat.com>, linuxppc-dev@lists.ozlabs.org, linux-m68k@lists.linux-m68k.org, linux-alpha@vger.kernel.org, linux-mm@kvack.org, linux-gpio@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-openrisc@vger.kernel.org, "Jann
 Horn" <jannh@google.com>, "Jan Kara" <jack@suse.cz>
In-Reply-To: <20260915-work-fd-reserve-unify-folded-v1-6-4d5217d6b246@kernel.org>
References: <20260915-work-fd-reserve-unify-folded-v1-0-4d5217d6b246@kernel.org>
 <20260915-work-fd-reserve-unify-folded-v1-6-4d5217d6b246@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 15 Sep 2026 11:48:10 +0000
Message-Id: <20260915114810.973821F000FF@smtp.kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4795140007
X-Stat-Signature: z3itgxsoi8ze1ed4zxo6gs6144hpm3jj
X-HE-Tag: 1789472893-351285
X-HE-Meta: U2FsdGVkX1/9VOvSVDvUYkQ5VV6Gq5gwTyyKFvL1a8OCVDEGD/R4bFouRPj0vCdTvKo0klmmSp7+dsdG+Sec5EwFC2aGXYnu3yW+9Vf3N4AxW5ArgVhXzQyrlHNOdPUgqnDKfDrxwxusLwMKipiQIhRgTbUBhJm0s1zZb31d6wqzX0lfYvo/TemwLC2G/IRWDqTS8Bh0KleJIs9Huw7e+01kURbMe71wuvthbFzFiBorXXoluDirF7Icw7+4R03uaHLmf+gHc+/JjCi/y3yNNl06qKD23rvkNE8deHpUDRz0NUlGF5faPgB9VDLU649DsFIhpLO/yDio9hTINmgytcd5T2QodvAUFsJeoRUy5mskjXU6pmrQd4lXHQ7ekjhk/vABbHedX3vbh9k3tiqGvAwE8CAu/robgUBDRIHYGyldMzoAU+2PVeygN9Nj0rvRXqR9FNCkILZorCo4ww4jT11VPgaDtZ7ddodH6nz0g2auHAEXoPOnOa+daAdVD7hDgTYmw3Ar1jk8FFtehGLvW8gr6fxoti3vJeRfazSN9wZPUYQujFDK/SLQU2CSQ8G07k36pnijbsK2oJcxBEMaR4eh9Oxw5cS+DnJkxOQeK/jgibemhZyirCCklKsoD1BlgNgWlI3wP80Q1Ksw1oLPdXmDz+Hr1MCuhjeRahejRQfNN8B7+JvOGcuVAeLdVmYRdifUVTvbhtP1HuQUYx81Z3YWQYk6yrWmItd7/A0MArXsKZi7Bc+CqnSx466yR8IwImWoecXz7jnj983IjHsM5Jj538mQ9tmryqeIdvtMepFN8bqfmCGE24PoWyRF8ruP+vA+z8jLEMV+2Hz7qbRtwhXuhKmYUjJ0iID7XlVoX0lKXszEnMaDRSdtWBTzuq9AyX4nrtYOvI7hkBkbUIDrrkhzPzocbhjlnqAGJUWICh8MUlrUf9PbHSWmffK+pWhqmzEOl1yVAJ6zFMjt8yp
 Jd7mox3k
 E24ZhQ9fv3sURTKhTqa5iNtF/wqwX58AhcaqdW+8t4+yF237f/KJQip1z9fCh8ARadexe0Vzp4m0rdl0Oeb/QzI+hJ8vbGyzAo/jXURmKA6iugvsFpq/xLigJ7uL/Qvl0GGSUVN8lt9HsMG0XmZ7Tz5vL10Os+wYFrYjInZ2fVo6UvY4v+eIbIYMzBJn/Q5jychmsR8e8SlRLfrBm80ozWlTHQCvSUJ9oemp+pZ3bZP/lbX1Du/edAKZCl54rGVWJXrBPAbZAWI4XSmyRFoOxXhoPA1Gc5ZDas2CkgQC81SYihTtNhry0ngsfz6rB9k61x8eJfVJtA+51HI+Hg3GIlB8uGM/u4rMv0CyES/ybGWDtlwKnFEFJL/CBVKW5HezbvpLsJVhnRFZTIcWrcrgjIdqp2kOioQcKStrthGgQKY65HOprp/z1WxyQIi5cAvJ4wWtnz2RI1/Cn72eWvpBA3CwA9/x3GEE8Lw4LwRgw5zHoqXmPPGornvuSQmUB4wmEee+E6DGSoPao4UyZ0Dt5GpfojtT9F0M4Hw9SXpO6jVZIoZr3txSaMZYERXyay3muGOWRLu8Tpn//7nTBrD7+wwMmBEDJyjDLXE4Xku9Py2KHSkFtoFrUQueXi9hPTJBIOCVNcMShFK3KdHulxrsDPP40fkRdo+4cX1MxyEgLHvs9znw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Add TIF_FD_SLOTS to the syscall work bits. el0_svc_common() rereads
> the flags after the system call and takes the trace exit for any of
> them. So a task that reserved descriptors ends up in
> syscall_trace_exit() which commits them before audit and the ptrace exit
> stop.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260915-work-fd-re=
serve-unify-folded-v1-0-4d5217d6b246@kernel.org?part=3D6


