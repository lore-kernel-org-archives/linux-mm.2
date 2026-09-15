Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B00EC982C3
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 12:11:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 54FE76B0088; Tue, 15 Sep 2026 08:11:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 526726B0092; Tue, 15 Sep 2026 08:11:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 43DA76B0095; Tue, 15 Sep 2026 08:11:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 23DAB6B0088
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 08:11:26 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A061B803CF
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 12:11:25 +0000 (UTC)
X-FDA: 85215881730.08.77618B8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 0C575C0009
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 12:11:23 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JM7MUu1K;
	spf=pass (imf10.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789474284;
	b=k+3prx0VbuMr/8LXfvnTpuo37P6sevq57bm0T7qd8JyBm491heb8/TMRGubdofct3gYhXu
	UipuKLH0Ykf1U/kt7GMEbxJ7/TDuBeq7TN3FkRZJ/b52B0tICO2Xd74U9yo81KBT+/9Qv9
	hfyBzq/2PPNv/PvH/pObZIiJ2OZmu5I=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JM7MUu1K;
	spf=pass (imf10.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789474284;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pymhjA3IHUvfc7ZhMmvcj6PWvzmH+JOQJc7von1cOC0=;
	b=JvJYD1BUinuQn5+a13bBjcI33YYnuwnhKOOln1csWAe352k+YsVKrs1au3wIfo3FJFpZjm
	m83t323BdU88SOddbl9w1lC4CSy91HYwOJbCiN6MUcJozkMsbZMD1HpF7y1M5WYTJAob2J
	a5m9My/StsG41wqkmi/on4LVdVjlJHU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7B5A9600D1;
	Tue, 15 Sep 2026 12:11:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62DCB1F000FF;
	Tue, 15 Sep 2026 12:11:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789474283;
	bh=pymhjA3IHUvfc7ZhMmvcj6PWvzmH+JOQJc7von1cOC0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=JM7MUu1K3sK0BfbZuufGSUMTjcYng5dpse/wo3EWLf21O2gUgw322DSgVB01AFTtW
	 t52UvxD3bLuUqeuFrp1OK6t6wHAM7ouPbrca6pE9eJrANghgkKMIS9n0Gf/wy0wloB
	 LbU8P8uOHsEx8fNW9Woaznh5JHxhxpBoxXgSLs2p/Y+nXpZgm4aiuBP11/FKE+6Agh
	 dOG9FMxrGVQ/eMMAs/LGH2WwzJPb1jSL8PT90CSvhiLFlxbJWRZR7M9jUUHoxVSb0a
	 49DnQM0TYsO0aM6hSLHh3aoQiYMzGZw+8DgpMeFwYhEfOeLW9W3pCge4KeYSBScMZG
	 GXoCvsjJhnAaQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC POC 21/50] io_uring: commit fds per request
Reply-To: sashiko-reviews@lists.linux.dev
To: "Linus Torvalds" <torvalds@linux-foundation.org>, "Christian Brauner" <brauner@kernel.org>
Cc: bpf@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>, "Jens Axboe" <axboe@kernel.dk>, linux-m68k@lists.linux-m68k.org, linux-gpio@vger.kernel.org, linux-arm-msm@vger.kernel.org, "David
 Airlie" <airlied@redhat.com>, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, "Oleg
 Nesterov" <oleg@redhat.com>, =?utf-8?b?Q2hyaXN0aWFuIEJyYXVuZXIgKEFtdXRh?=
 =?utf-8?b?YmxlKQ==?= <brauner@kernel.org>, sparclinux@vger.kernel.org, linux-parisc@vger.kernel.org, io-uring@vger.kernel.org, "Peter
 Zijlstra" <peterz@infradead.org>, linux-mm@kvack.org, "Alexander Viro" <viro@zeniv.linux.org.uk>, linux-sh@vger.kernel.org, "Jann
 Horn" <jannh@google.com>, linux-snps-arc@lists.infradead.org, dri-devel@lists.freedesktop.org, linux-fsdevel@vger.kernel.org, linux-mips@vger.kernel.org, linux-um@lists.infradead.org, linux-kernel@vger.kernel.org, linux-alpha@vger.kernel.org, "Jan
 Kara" <jack@suse.cz>, linux-hyperv@vger.kernel.org, linux-hexagon@vger.kernel.org, "Ingo
 Molnar" <mingo@redhat.com>, linux-openrisc@vger.kernel.org, "Eugenio Perez" <eperezma@redhat.com>, kexec@lists.infradead.org, linux-csky@vger.kernel.org, virtualization@lists.linux.dev
In-Reply-To: <20260915-work-fd-reserve-unify-folded-v1-21-4d5217d6b246@kernel.org>
References: <20260915-work-fd-reserve-unify-folded-v1-0-4d5217d6b246@kernel.org>
 <20260915-work-fd-reserve-unify-folded-v1-21-4d5217d6b246@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 15 Sep 2026 12:11:20 +0000
Message-Id: <20260915121121.62DCB1F000FF@smtp.kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0C575C0009
X-Stat-Signature: grgpmb793ptejmw6ckkautojk178oz9o
X-HE-Tag: 1789474283-252847
X-HE-Meta: U2FsdGVkX18+qSIRbwo83ZTJYsgkDa81beKQQ2qv7YwJixi3QfATXTdja1mjrhGNQ9BWiIdgRf7YK+F+OrYuRz+f7beoL1xxA4Sf3AnOb43UWXKfbhCalpxfU7t6+vg/iKSD4ynCFHsPAskNSqhMmwauV9sThjArj1GsTUQ1Z2mP/Isld32/mSqcjkbpB23Px1SGInz01fNWGXACexDp98zY3hPstJny6+EQXzUl3I001MWuFHFB0Wtr2o/9TwzJ4cVQmHjMmnFMjQUlk6640OSPVnVtL3X3F+uvo+UmwHsLy9O6ZYJO5iK4tQibrBFblt5ijucofqKXW+v5fxCZ6HD41crMwztkhVFc7OHUAlA3548xXmBCzXWeCkcYjHKC289DgYk0hhxzq1YUN0UIzYeUvdFNTx8OpMgRf0XsBRM6KEupFni69OohKlSkiVXg7f9YV2VHf1a5V/eUFMH5dvsRp/9jo2NTRUcIEqntyceNTyWw/80uiVr5s3tYMrzIurMnVQUW1tdhdQIYzR3LpGiW/iWbNLfb+f16t3oOoVxkiuTGWRS8HMB4OWCT32Z7xyC7MGWDvXJEE0wf377v1gs2ws5+Vx+QXytTqiAeQvzPWUcbpIsctHy/SiGBYv+GCEbHLmVYr1vwRCL/xLFR41ONpHbD4/O3V96DcFfO7YQlHm2cJYg/ngzumoKBbErnUBAXoy26S8uWbLrUwHZVyAz6xVa/xxxfl9i6LQmsBW4jS301lIipP4HmRYF0cAnwwRfFzvAxmZhAAYqvGPcE/NdQEYVMCc4gHWMG36iXi5GrR8tl5t3ZEMNONxQZwHcgqCSaOkU1PUHsGFXWWkatRjFASNwIH6gcHNn6E5he+n23QLjueHCp+C6eCSfPFb2A6oaZ76PZScWdfc32NzWBZnRRRbl0VOKzeVxmBu5rxwK0uQrlTc0GZkevLnnKJM9wD4CsXJMSeRRC5htN+GP
 a7l+P9KK
 ebp987pRN9GtI1ICaTQvUIVfnNfKkeAYU9q0DaOG0hw//8V9SoUBXFQQD09GhAiHMYMbBYg+DYmRfksJdrhcb1zugF3DmP2TL/y0HsqPAFyhB4bDedAURbGIhmHrWNvRLRmREUMsx6+/xeo5WOGx7UpiWo9AAQUqZYMk+/Ofeio7sibdCD3d81pQnvBJD4yqghmq7vNrhnH3Hz4WgRg1SbaJkGiTiMr5TNVHPd6IOBxlrlYIHSCVTCX5IyescOILXLJiqBWT1uahPBgEJNUThVna15hK0qHN1hYfZlHkBUlAj7oTj+4ljDyrau3W01NxvLfVo1QAP7iE4aYUwoj6ZMCxb3rSzE7qZNI2dWy6wdYcTMaW3etyBxqdDTh8idtCw83NdyPF3oOYFeiVCm08Jt2BLxrYx/ol+/qDVfG5HMPqfR9PZ9kkDfEygpIBTPXzDolIFtFDrEWvDkY2AKYNccuBpLY2yVrFSfNtOqrfs8yjMcMnlCfqgCsntU9xZ1WweaqcHvc9FNulxCvNZPuPIL0wHIacB4HmQbI31yU163kuoYFxJkiXyPSslemQsti2aKkG+n3moa0mfPlCk5OYfJEbUPcqg2BdQuCaA85tYfIRFLxvoMXxADDWuc688cwB182YWVnBLerVxQtRaEYrY3EGG8S9hNjPlzaTux6op0k6xMz8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> io_uring requests don't complete on syscall exit of the task that
> submitted them. They complete:
>=20
> - inline from io_uring_enter()
> - from task_work on any return to userspace
> - from io-wq workers and from the SQPOLL thread
>=20
> The CQEs are visible to other threads before any syscall returns. So
> commit the reserved descriptors before the completion is posted. Commit
> them after ->issue() based on the request's result and before every CQE
> they post.
>=20
> Nothing reachable from io_uring reserves yet. Once SCM_RIGHTS is
> converted this keeps IORING_OP_RECVMSG working from io-wq workers and
> the SQPOLL thread.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260915-work-fd-re=
serve-unify-folded-v1-0-4d5217d6b246@kernel.org?part=3D21


