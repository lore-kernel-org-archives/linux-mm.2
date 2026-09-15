Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A11AC982C4
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 11:57:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B8E56B008C; Tue, 15 Sep 2026 07:57:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 896BD6B009F; Tue, 15 Sep 2026 07:57:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A5B76B00A3; Tue, 15 Sep 2026 07:57:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5CCB36B008C
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 07:57:29 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 79F26403DB
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:57:28 +0000 (UTC)
X-FDA: 85215846576.11.3E14951
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id DBF1D100002
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:57:26 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Vtnl/09N";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789473446;
	b=Lnkj8eT1+we+YqX4TyVgBDhrKpZhBHy0lx+6WbUMS8GPUDa9Os3/LY9STMmazZ3UFjyBU5
	cOxUby1CAwkhn01DqWSzqaIbhHbSkK4SBUHuMFBWEovcEMXq223lXtj6laf1pIYUajXqKK
	gNmxgry30WcfiJm5Gtd9e+0+2Q6RP7E=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Vtnl/09N";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789473446;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=foNXNPfm0YOXYb4+jKYd4+lAF9aF6NFtBcoJMDQD3PE=;
	b=pXXc7jDdxqm3OfttG44PLgLbLgj3ImGDD9tGPI+SSsP0HN7kZMFlk6icclXBbgWZ5iaUW5
	mada1Hb/QsMGJLceQBd8nsIEn8Fd92ua0CPFSabs7ygvpIn3sJytdv9d7KvKGC7XNwMH3Q
	jDGspdoVPMAmuOhWUS9jzNrezuJCf0I=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 09E4041ADC;
	Tue, 15 Sep 2026 11:57:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A2291F000FF;
	Tue, 15 Sep 2026 11:57:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789473445;
	bh=foNXNPfm0YOXYb4+jKYd4+lAF9aF6NFtBcoJMDQD3PE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Vtnl/09NTEmqyW1tNPT+8T8JuOyDJguLBv2ERQfv5mV8sUbXuBe9nfRUxjy6D04/B
	 Hcm4AIGNtGqTcc2GGlKlSglke2u/FXcZ76lL25z2/NeeHWPcqygtSbbzmeVVztVUgW
	 hoS+iCHyLKT95UZw6JB3PNuoK4/zapEViq1/QVJmftEtEMsjVlV/1Wdd/5mzRfse5N
	 Hf4nzWabASK5Nn3pr5jvJ/Gt8VwGXr0IJhqiu3SrFCMh0A7gLPSMGtW3IAoUbAv4fC
	 i4vkJOaZ592ko8M1p7dcC3BjyfLFGQY4bZoyHYD9fIuFfPgwESBHAG9TF4alz32jll
	 rFcSGLJmW5YeQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC POC 16/50] sparc: commit fds on syscall exit
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>, "Linus Torvalds" <torvalds@linux-foundation.org>
Cc: linux-csky@vger.kernel.org, linux-snps-arc@lists.infradead.org, "Alexander
 Viro" <viro@zeniv.linux.org.uk>, "Jens Axboe" <axboe@kernel.dk>, io-uring@vger.kernel.org, "Jan
 Kara" <jack@suse.cz>, "Ingo Molnar" <mingo@redhat.com>, virtualization@lists.linux.dev, linux-parisc@vger.kernel.org, linux-um@lists.infradead.org, "David
 Airlie" <airlied@redhat.com>, linux-alpha@vger.kernel.org, linux-gpio@vger.kernel.org, linux-mips@vger.kernel.org,
 =?utf-8?b?Q2hyaXN0aWFuIEJyYXVuZXIgKEFtdXRhYmxlKQ==?= <brauner@kernel.org>, "Oleg
 Nesterov" <oleg@redhat.com>, linuxppc-dev@lists.ozlabs.org, linux-hexagon@vger.kernel.org, linux-arm-kernel@lists.infradead.org, "Michael
 S. Tsirkin" <mst@redhat.com>, dri-devel@lists.freedesktop.org, kvm@vger.kernel.org, linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org, "Jann
 Horn" <jannh@google.com>, bpf@vger.kernel.org, linux-arm-msm@vger.kernel.org, "Eugenio
 Perez" <eperezma@redhat.com>, linux-openrisc@vger.kernel.org, linux-m68k@lists.linux-m68k.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, "Peter
 Zijlstra" <peterz@infradead.org>, kexec@lists.infradead.org, sparclinux@vger.kernel.org, linux-hyperv@vger.kernel.org
In-Reply-To: <20260915-work-fd-reserve-unify-folded-v1-16-4d5217d6b246@kernel.org>
References: <20260915-work-fd-reserve-unify-folded-v1-0-4d5217d6b246@kernel.org>
 <20260915-work-fd-reserve-unify-folded-v1-16-4d5217d6b246@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 15 Sep 2026 11:57:23 +0000
Message-Id: <20260915115724.2A2291F000FF@smtp.kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: DBF1D100002
X-Stat-Signature: q88p59dtpramfxnijfzyk9u7zhne83zz
X-HE-Tag: 1789473446-807915
X-HE-Meta: U2FsdGVkX1+MIXq4ij1waoBEIhdZ5G9QsCWygUA497ShkFhB02cOUowzYNTx4m/NTVDTICZNyYJNeff72o0wr4/e95UtN+LwlKnMpOQ27yZJE/3twBuTtIsK219sh9gWi8WMeIQzoFDahG4Z6k03APiaLYtUFqnrrKv9iwb3wVtfIu+PxCI+plSPVyAVaxI8bCsH0KZvNcXtWI2Rf38slAoGjZK6A8Ggf2ksLr4CLCncVBsbjk0h1sm4yI/UgExe8w+PLhGjeRckJFdpFfGGVRKTb62uJyKFXJHmWhBVZ87H1a/7yhDNP3SeU3scoHWK8Ut/ZoNTpElHS6q9R+Joj2D4o0pX/ZLwnSj64EU0R6sBRZwRoYmussgfzNumbaNU4r3iZgK+/Yei9hqeghg+DR97We7egEu1Q/5CXL8OsF4XW03mmL73Uot8ssFaRhEPilKAzV3kKHjwSkc2iSOo9o2gVTm9Rjn/CtpmqvBdykRIrGP/EtkAkoF+sm6XYweBbM4pCwKmiMzj+05w7m3M2C3JYN9fCB6BUNlwVNCT+/AMKRBGBsuZP1apKrvEgl8nMTUK5JeaI8CNK2UTXSzyDfbIwvmEruDZxlG0p6FO6J05GTbrPk3YTh8uevW/OO2a0jUIvByXrYxF33soJG1u8yOA7BqFTsDwwGaziPXuvfiA4Th2K/MQPld04JQQO0AVeTyozcyroSBUmpH4GIu2FNEOl7DpfyRMBgvAFcOhzcS/xpEKmQqD6aWTKLLRQEt+tauXUEN8bhUriZkfQ/FJrj0K3wedb/rzVYlSb157ykhYaGbU3y0nfxJ1tvUhZvp3MgB40weAYnkwDejk1EslKvwgix9wHOABeTc8w7kf9tM5YGyTlQAoSbMDpx7ekVls5f3F36jtENLnDdaVrl+oP9JPH5O1hYE6aSBsERjT+pKcN5VFJ9KDqpVTe2cbS55e+V7jCP4Mq3yMoJm/ApE
 Qp3LyxQI
 tL3jN7yDr3l8vIV/UFToq3rDwfdA01XuEl3CTWgWaQaOxNvJaljil6hX8MNnkPsGFn02T9VF4drqzx0Kvd24B345zD1KAEvhaU7DH/UAd8t3tP/jYdmktqZF0PfQWFUqWkNXkJEq1LgoNveyuT3LXuPQ2Cceyif2xZfGmVV3jPlAZhvz2vT2LlM2a4tEdmmvQ/H4CCHCosIZdfvi7hUAM29oD/79fJMz5VPVeyAl+z5JflDN2v5+PuV8aeWxNXPjnonagH1ALOiOVE/Sy/0QDeYhQ6rMLGrCywNo3IPXevMbgT6MS1pR3nFX94NoGsAO1k2W5iD2tTRnN8/nQhM8OWZiKn9ZUHkjE2DrF4yYJg5hKHAMzhr41soV/cnpvpFbD+x8LMjfopqJuduR2c0cu8F2WZPY2N4KGhfxWHmWnAJLU17YoM5Dxrg14mqDmaDZIW4/bi3HxwkCY/AAM5dmef1A+ly2GLs7lxdIBUCrwT/OcELfDlK44vjREnKzTSRi0E4G9TEFCXCrwJlAOyb2yqCOWawjoLMzXAdPF4k70lAGODojwl9vJVJPmrZQaIDg4KOhImWRy9nkKIjisrlD2M5TMH7d6IwGlsWNJpFkKIGw8cxZmEDsa/U1QMtXBgqvaWiVKMjAMXxHxnnjDJV7cjEOtA+/zvlgguThehqrj2RfKvRg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Add TIF_FD_SLOTS and test it together with the other syscall exit
> work on the way out of a system call. A task that reserved
> descriptors calls syscall_trace() on sparc32 and syscall_trace_leave()
> on sparc64.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260915-work-fd-re=
serve-unify-folded-v1-0-4d5217d6b246@kernel.org?part=3D16


