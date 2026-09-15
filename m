Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A0C9C88E53
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 11:50:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8AC696B00AB; Tue, 15 Sep 2026 07:50:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 85D936B00B5; Tue, 15 Sep 2026 07:50:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 753696B00B6; Tue, 15 Sep 2026 07:50:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 570216B00AB
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 07:50:28 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 91F8CA03CA
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:50:27 +0000 (UTC)
X-FDA: 85215828894.17.86567AD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 01ED71C0004
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:50:25 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=K53ZeQCF;
	spf=pass (imf21.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789473026;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+t+FFRs/FSCskcUDJ5SBPkwP/MmkDDT89W6QZ8CQfY0=;
	b=2P+8Bskgm/bYBn4EpADg6jXgngybmhXfw5n0rZyxg6w2WcZSqL63jWJvqCEOUy6/nrTBFi
	6m46rTTR6smE8z0XErwWnKv2zYFeMYMU5EPybWMRT++GjiAHVSNTcPndtd9SmDS9Yyt72e
	Vr5ipCdlybgk5CG5XFEiR8VoHjSC+2U=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789473026;
	b=wS+aQiQaF96qC1gdABcyW3JAd927E7lY4HVtdGZ0wxNk5wW9E2XQxNpvohZL9J2SDZsBJF
	5Bc4DJlgb73CeWI3g5f5vI/uMbrd7YgtlI2cVdrmJNJjX32wvFBsOGvewedua43q/T4CRR
	8grLjcWvP76NF8D9GIjvLffbEW5t7Ak=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=K53ZeQCF;
	spf=pass (imf21.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4C0B741256;
	Tue, 15 Sep 2026 11:50:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF7B31F000FF;
	Tue, 15 Sep 2026 11:50:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789473025;
	bh=+t+FFRs/FSCskcUDJ5SBPkwP/MmkDDT89W6QZ8CQfY0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=K53ZeQCFgiRlmkmUKqyt03ueVesYZEQr8ZHRmEnHJr7bteBPMY+FhF3KYLtuCparh
	 nKgFz0/6jbq1bui4jC+jYX4ySwDgwyBFWSGcoZrPkCnnSxGxTvfC6BSUPgQq6hQvNN
	 +1Spfhekga2XDw3G/J02TP4WSUtA8F4az2wYUgLljPdaWE7BVEbc0aUoQxQBuF0+j7
	 SIyPhVaxFVjk05zS3THf3p+jtDoLWiEkH1QK9B2j4QqMORMMx/IRGI5cyQTCspKNmd
	 5UGZ+jgOkWGk3ahuQaW3stL2pre2KPKFH28rNWpoqvzsKrFKXAxDwAFKyj9oMjB17X
	 ecSlXehy4baoQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC POC 03/50] alpha: commit fds on syscall exit
Reply-To: sashiko-reviews@lists.linux.dev
To: "Linus Torvalds" <torvalds@linux-foundation.org>, "Christian Brauner" <brauner@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org, "Jens Axboe" <axboe@kernel.dk>, linux-mips@vger.kernel.org, linux-openrisc@vger.kernel.org, kvm@vger.kernel.org, sparclinux@vger.kernel.org, linux-hyperv@vger.kernel.org, "David
 Airlie" <airlied@redhat.com>, linux-mm@kvack.org, bpf@vger.kernel.org, "Ingo
 Molnar" <mingo@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, linux-hexagon@vger.kernel.org, linux-parisc@vger.kernel.org, "Jan
 Kara" <jack@suse.cz>, linux-csky@vger.kernel.org, "Oleg Nesterov" <oleg@redhat.com>, linux-snps-arc@lists.infradead.org, linux-m68k@lists.linux-m68k.org, dri-devel@lists.freedesktop.org, "Eugenio
 Perez" <eperezma@redhat.com>, linux-sh@vger.kernel.org, =?utf-8?b?Q2hy?=
 =?utf-8?b?aXN0aWFuIEJyYXVuZXIgKEFtdXRhYmxlKQ==?= <brauner@kernel.org>, io-uring@vger.kernel.org, "Peter
 Zijlstra" <peterz@infradead.org>, "Alexander Viro" <viro@zeniv.linux.org.uk>, linux-arm-kernel@lists.infradead.org, linux-um@lists.infradead.org, linux-fsdevel@vger.kernel.org, linux-gpio@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, "Jann
 Horn" <jannh@google.com>, virtualization@lists.linux.dev, linux-alpha@vger.kernel.org, kexec@lists.infradead.org
In-Reply-To: <20260915-work-fd-reserve-unify-folded-v1-3-4d5217d6b246@kernel.org>
References: <20260915-work-fd-reserve-unify-folded-v1-0-4d5217d6b246@kernel.org>
 <20260915-work-fd-reserve-unify-folded-v1-3-4d5217d6b246@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 15 Sep 2026 11:50:23 +0000
Message-Id: <20260915115023.DF7B31F000FF@smtp.kernel.org>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 01ED71C0004
X-Stat-Signature: ic6gganmuje8zir9p5xaz8dpxz48ihza
X-Rspam-User: 
X-HE-Tag: 1789473025-650054
X-HE-Meta: U2FsdGVkX1+Qm+7vyAVpRfpqv2O2fIC6wb42lhfO4XPvpuNseYXiCKWSU0JIRVZElxyb/v+xzUE66kFV9EqxBXj0/21sIhgjmjj9Jedgdh4dSg0Puvjag5pW5aMt60Bhqw2Vaax16jeYKCXCbaQ4WjC3kOKpGPCP81NpxpvMkUPwV5WCYJGlEUVLjQJAl5ZLoR52aV3DvEVK7Y91Ab3XWivLFTxHNJDCfSJxwjUS46jphqFnk0zCB/o878v/PqTTpn1BbTe0Fj4SM3Hj+XpG3MlprMDGCQfdZCdvZvu5pT7k3lh1aU54V3xhWW6hSFgkTJIOOAwfP5gYZRwoHIwM8XZ4M1A+xx9+xuwcJ4OuQhxkLAi/Pz1CeNZlaZ69DroWHZyaQwW9yuyo0t0FDsTI2Cr2f816/vuILcYKbQ4MVh4T4qhO7URNaeR4VkIiA5mqYPqRYZ/DbmbnNv9zgNf75TMoX2PBfCzsCkFVSWyug0EuoD8LDZNS8qYEqkGo02hybUSnX+KozJlUOkxAhM0gEUkZE0EdGEopJqMnN03LOZZsBpLgEOkI8/9OLBznr9HnvQx0ELHgfn1sbV0U5jYFM6lXBzhiikKNAXt1QxDq+ygxcbCDaF1SK6lh4rVR1l4x7v/vstZhVHSXqo3b728PP0E2iwZMrXt5DdAsJ9twA+e7C4VJQfPqu8a8sM1c08CLV2l4z7c3cCuXW51idMENUVR6/UJS7MR4zySSgpMgszj6dtYyJfozMKlsUT8iiWuJ98p2/4MizbT0uXucy4TnvFUegsTH6uZ0tYq2ZQoTmsvxxUeyjFpLKT2Yw6TOzFoGgEP86srgLK9PhHrxmJRQg9jq1Gyd8KC/FLXi2SZDRaDtwiFcdIMkkPN1GdcDGpsqlxiu2Lh3jPM+ZW2gTch+5zOiuITbNbxoqIcBp+2s3rNi2fOiHM0tdxtJZMpnOoO7fEAb5BdXFr9qktjIHvI
 NAtMUrhp
 44/JPVivaMN2g6hLkfG7kTsnJB/jzvi4SkmzYuLCsFhgyJmj3SSpXnP8LEzdI9pPxX4vc0H/mdKeV2yasyJw7a06iyoN8hG+pv5CEglORO17c36U8NGVCPSkUMik1ZpD+00XN3i1DuTcLbGD/Ei+HPIZ5Lrt3JYv8GTAi/MCSvNrUbxkivT2Cg3UyJH7uHBse2qfYFnQzcVz1o/5c/f5JPLWd8Sew2+B1UMXCohbJ8+eohFImsarf1wjvVrnaxF81XR6O9yiphjySUjIKwocU4H3sv7xUSSkgEvNz/f+QLC8j8GO/Qypo8KQ9gPgg+prw8AVZu1vA4+jJR9TjuY00lNzGv3Pv23dDsVzrfgu0/5NSuNiAbR8hXgS05YtsbCddullVpZMnO+dKVvvW5s4nF05sizEtH1O4cbPLoXeZE3YTcviROBDTVPbh1dKXfe6kWaOSiOpOSByJ/vXQBvtfVQaMaxzudiCwX3Zk+v2r+2sds9XUBSfoCxdSbHtTIzvmPv6DXU7ki2y4dD3XIBkgBHERTzf8QtdqtqOa/ET/5kWcvThaZ3QX/JN+blOiUtFnbvl4+QHjyaK5xym6F+XKxug2/Hht2T0NQXNaEcZGmNSCLAxCr7PZx5tpXZauH6hvltgp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Add TIF_FD_SLOTS and test it once the untraced system call has stored
> its result. A task that reserved descriptors calls syscall_trace_leave()
> and joins ret_from_sys_call with the flag gone.
>=20
> We mirror the traced error path where the switch stack is set up and the
> return address and the syscall restart state are placed in callee-saved
> registers.
>=20
> Btw, let's remove alpha... It's a pain.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260915-work-fd-re=
serve-unify-folded-v1-0-4d5217d6b246@kernel.org?part=3D3


