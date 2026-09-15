Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3C54C88E7B
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 12:21:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D530E6B00AF; Tue, 15 Sep 2026 08:21:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D287B6B00B0; Tue, 15 Sep 2026 08:21:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C3E756B00B1; Tue, 15 Sep 2026 08:21:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A17416B00AF
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 08:21:04 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3147D1403FE
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 12:21:04 +0000 (UTC)
X-FDA: 85215906048.30.79151AD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 8FBE0100006
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 12:21:02 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="A/LXiHVz";
	spf=pass (imf14.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789474862;
	b=FVnOD2EDroS8XxdHoAUnWv8lxQTUOSHHLHmDykd5tljoxJ753DdXzQnBr10c7ftzuCmQHa
	CVjw5xdlb7csV49K1jfaOpgNMreCzUnobMmFtkcUzKkZclSf2woQ5Us8/Nt0Yv3ZXfOwBE
	OI8IIUL5MYKHiIU7v2rpDziOdl5Iu38=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="A/LXiHVz";
	spf=pass (imf14.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789474862;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vonrQofTMqh1TZ5f0j9SBLxkepNFIrQaGLKCiSWoy/A=;
	b=Od4i3Q6GlfxnuCmF6n/y4mov8lxPPXNeaEuAcG03nq+wyQeUEDjuNI9IJmUEHE2+Q2bri+
	sq0r4RPX3Pc2pK2hQqrd33aN9Frq9JyWagT1S/4HuxFRK6LKAor4o3NxvG0rWtMYMQxHjE
	Oa01LHMKueFj0S8yRQrbSxXHn1jlsVc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B3D32414DE;
	Tue, 15 Sep 2026 12:21:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDCFD1F00893;
	Tue, 15 Sep 2026 12:20:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789474861;
	bh=vonrQofTMqh1TZ5f0j9SBLxkepNFIrQaGLKCiSWoy/A=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=A/LXiHVzihnaMdFTMhS3rVKx/wDAkjfj2gDEj8DTAYNjfOe6DG+9Ca/cCtFyPhPE8
	 y77qZBSfSC9sS4k/RUcIcuvRnjcCwtLvS7YSZE1xN5GAlkblWsWACrRhYCN5wIFKor
	 zT8EpjnA5d63Lul165thqtWkMhkC99tbZwqRFOqKxO0tRQPj3pAlGire6kQh45O8b2
	 eS2NZ8W+DwDtB+jiWr5CwIe6sK7rjGmOKgcSbUdZiQO/XTHrxK9zTNOllt/wu/a1To
	 v55MzO0WPliGPDb7kJyu1DDpQ4ZeGJMNQLBjGR50wccFbjBl7QsDZheHlcTEqD3nHg
	 F55P5vgYAJ68w==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC POC 48/50] misc: fastrpc: install the dma-buf
 descriptor when the ioctl returns
Reply-To: sashiko-reviews@lists.linux.dev
To: "Linus Torvalds" <torvalds@linux-foundation.org>, "Christian Brauner" <brauner@kernel.org>
Cc: =?utf-8?b?Q2hyaXN0aWFuIEJyYXVuZXIgKEFtdXRhYmxlKQ==?= <brauner@kernel.org>, sparclinux@vger.kernel.org, linux-csky@vger.kernel.org, linux-sh@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org, "Oleg
 Nesterov" <oleg@redhat.com>, linux-alpha@vger.kernel.org, io-uring@vger.kernel.org, bpf@vger.kernel.org, "Peter
 Zijlstra" <peterz@infradead.org>, linux-um@lists.infradead.org, linux-snps-arc@lists.infradead.org, kvm@vger.kernel.org, dri-devel@lists.freedesktop.org, "Michael
 S. Tsirkin" <mst@redhat.com>, "Jan Kara" <jack@suse.cz>, linux-hexagon@vger.kernel.org, "Jens
 Axboe" <axboe@kernel.dk>, "Eugenio Perez" <eperezma@redhat.com>, "Ingo
 Molnar" <mingo@redhat.com>, linux-mm@kvack.org, linux-gpio@vger.kernel.org, linux-mips@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-openrisc@vger.kernel.org, kexec@lists.infradead.org, linux-arm-kernel@lists.infradead.org, linux-parisc@vger.kernel.org, linux-m68k@lists.linux-m68k.org, virtualization@lists.linux.dev, "Jann
 Horn" <jannh@google.com>, "Alexander Viro" <viro@zeniv.linux.org.uk>, "David
 Airlie" <airlied@redhat.com>, linux-fsdevel@vger.kernel.org
In-Reply-To: <20260915-work-fd-reserve-unify-folded-v1-48-4d5217d6b246@kernel.org>
References: <20260915-work-fd-reserve-unify-folded-v1-0-4d5217d6b246@kernel.org>
 <20260915-work-fd-reserve-unify-folded-v1-48-4d5217d6b246@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 15 Sep 2026 12:20:59 +0000
Message-Id: <20260915122059.CDCFD1F00893@smtp.kernel.org>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 8FBE0100006
X-Stat-Signature: o65wfqygiha74k8u7ky9y9wz5n73jfj1
X-Rspam-User: 
X-HE-Tag: 1789474862-991708
X-HE-Meta: U2FsdGVkX1+4Ws2KXVknNjAkk/uo3E4zdct5fpVp0DePrdbdlje6n11CRVD1flPPqGuQ15n4DYy0pfk4gRpXM2UohNGIxm/vXJLkXzGKQLEOG7yVi8RzJsn4aluRXp0SjYykDpngK3fz0Qf9ApoF9m2JC9FXv0meXli/zXgeEyCLQV/rPWh4LEVZ/7mti0Jv7FqQGiYr0r5tGK2YAlSW+SI6E1NwTimIW52r6vkTtMUa82oqsiu/eep0kVzSYlFEmwN3zlUDHdCzA8VUP8hXWvJlzg9xq8ppNJbz52ThQ2AC/4kf9elPsPOQqSHUdUWApUJlfZdEgxGMlBqeWGhwI2UDT/z4Dm/b2zNzom5Hbe0azlJm0Y9T4mTKoWOpMI9r1FAktY1ufABq2zt2Rovixe0sMQSpxRNzdOgZXwk2UPseD3zi2NxUgXcnZS4PP5X9pRtrDD3AeoOg/SdE0bSEzDz0r0D8rVLMYZDAXzw2cy8BQOzeI2X2+NIqdKbGcH3TBEhj9IhXIhSfw5zgaQaKcwUdLI7KCb1VvWD8wTh88j7tfNGK2vUewNJZRlp0NJE3G67wHJC3zOJKkJLO/ljOXC2KfVlzu3Mvxzj0gErTn15y6yyOlDXuDZhWTQGWCTkJCIElj2NwXzsIopDsyABGMg9pFo7k4uW3lrwoXQgqHqHVItSNjxj3uTGjpr9GvxktydupGvLVPZQDuZIow+qghQmUoEggt6tobyvOkXipVM2HM5RhfO0Hdgt4EF+WJ7DwNhkAcZNfNIlsqh+n9Ez9bTQMrOorS49bIpbebckKi7yIzGefyHh7ilJxH/OBk7mu+p4zQtSmhvPQYl4wjGpcUqmyPcrpYLL8XoQfSordXUuxfawiX0mf07GL/RLTFNw9NrW9wB69lJDoYp2UItdSCBnNpj9mIPgQtneG+eNHU9ADunTdViLU6v03Q/maPZJXp1GAWKTX+5wKMbIjdnc
 Jh750AkQ
 87N4SMPVPYsCzVmApfwKZChiBgRHZ6fGWeruz7lBrPvqkXkXq42B/0uBW5vONVo7du9e9Dcu83Hz/6sj/DzbVAGcFJDdIjyZQnjLy3UVz1/gyPjXLp/BIVK679727IVn1ig1P+MmvitRsiI4NxiNkTAsTCQAQcURDQotlRzfNVWcNzkDkIcmAmxW9NTiT3H/+kSIzK/PxK7RtKyUT++MT7lsUGprhJg8zLjD/iyBD8h6GxbOXNRQsLd/prUQrsJwAoieE2zHq2wfp26qAKtgZn+BC13BrJtJqoMvHeBQ0x6CQmle8uJQiji7HNu8FKfbjyU9SMokcvRPcEo7qx68tUH47uNZ2z77eHm1KQDNdqujC3i49XV7kFbjifq9CzUN2ZUeB0WPoJdIslSkTC4oUVoiouBSe7n/dloDrmJ+SU074lOxzl9N579DEt/Cc9WjTktPvPXsMIjJXYkCRBMJlIIeFN+1Zs47QS4fjcSi3SEqHCHKaGd+5sMnwrOtPAZOVbgXbrE4IcAhncNIRPC6Ar/PXGf4gKlXeGRaFtYj9r8RKGlZ9cqvZ3VB7Ept1zUqzji7EHNhQQU16dxMEioNOdJiExa9P2+DTK0hOuOe4jS3W91KSKQHups1L6e7osXmZEYZaL2GxOl+xy7FgfzeToTObpA3XFURYkzZDWlcGr4pjHffZHH2eWNvMbPmtgf/oT24h
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Rely on the fd exit path machinery.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260915-work-fd-re=
serve-unify-folded-v1-0-4d5217d6b246@kernel.org?part=3D48


