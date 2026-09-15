Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E522C88E53
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 11:54:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 556E96B00B6; Tue, 15 Sep 2026 07:54:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 508F66B00B8; Tue, 15 Sep 2026 07:54:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 446146B00B9; Tue, 15 Sep 2026 07:54:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1E1246B00B6
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 07:54:12 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A1672A537A
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:54:11 +0000 (UTC)
X-FDA: 85215838302.24.9A4E87F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 013D940003
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:54:09 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dEjnjHjN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789473250;
	b=xWYf82O+7jVUmhdsdltUpjnAFXRHTVCB2mdynGYppiu3u4YeuCFZU6ckzZitm0+CDOG8M/
	KH2XjQkwk6eIt2mVwR6d1tlZHT+YOeAh57fFlkgnDvqal18IGjxqcto6lioSm36MDNyy5G
	QEQx4pgJaobMhuLCrzOVVUbB//gwjvk=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dEjnjHjN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789473250;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rEaooNHHSzMvHYDvwYrru6UOPRcxabqKjG95OLRLlN8=;
	b=oPRz9xVxt/i7rAT1m29+u1EnkjC7HXhy2y6VYx4q3zS0qkNi1I1F4cz4Dbzx0w3uZjQ6q6
	90siK6U1InPYR5GUMd1lck02J2BjppDbWRL6gdL5ZDz97LRrCJfc4c8aS9C6yEFswS6yPd
	z/kc8vXU5NVrRvnIbTatosxsKNgvhZI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4552C43CEC;
	Tue, 15 Sep 2026 11:54:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E8371F000FF;
	Tue, 15 Sep 2026 11:54:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789473249;
	bh=rEaooNHHSzMvHYDvwYrru6UOPRcxabqKjG95OLRLlN8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=dEjnjHjNvNIuSaPYTHfj4KVcRdWnf0KMr5ngwYgP13UVEN4ixsOjP/LGTY00a1F7i
	 SrECUFxW1WISw+Sb9e943yH6GxglJXZz6/98X328DvWbvebyYY0VweNP2I8cG1QByw
	 Gji9eMFm2AAVp7PkwCHxT4RdIR9rAmD6kZzVeYGbasnMh8yVep7bz3ac2gDe5wmKNa
	 E60wDWY0t8sIf7wr0+2mcu/fK44J9sYDVuZZ9raSVBw8fhzXy625/hIuVibz2cM1G1
	 heryhbL45TCscgniXJxfFQxgFi5MNZtk5vPFvLwJbiB9YO/wiDhzcHs+qEgelm4u1w
	 O3GQp5W8DIzZw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC POC 19/50] file: require the syscall exit hook from
 every architecture
Reply-To: sashiko-reviews@lists.linux.dev
To: "Linus Torvalds" <torvalds@linux-foundation.org>, "Christian Brauner" <brauner@kernel.org>
Cc: linux-gpio@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>, "Oleg
 Nesterov" <oleg@redhat.com>, linux-sh@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-alpha@vger.kernel.org, linux-fsdevel@vger.kernel.org, sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, "Alexander
 Viro" <viro@zeniv.linux.org.uk>, virtualization@lists.linux.dev, linux-um@lists.infradead.org, linux-mm@kvack.org, linux-snps-arc@lists.infradead.org, "David
 Airlie" <airlied@redhat.com>, linux-arm-kernel@lists.infradead.org, "Peter
 Zijlstra" <peterz@infradead.org>, linux-csky@vger.kernel.org, linux-hyperv@vger.kernel.org, "Ingo
 Molnar" <mingo@redhat.com>, "Jan Kara" <jack@suse.cz>, linux-m68k@lists.linux-m68k.org, linux-parisc@vger.kernel.org, linux-hexagon@vger.kernel.org, "Jens
 Axboe" <axboe@kernel.dk>, linux-arm-msm@vger.kernel.org, =?utf-8?b?Q2hy?=
 =?utf-8?b?aXN0aWFuIEJyYXVuZXIgKEFtdXRhYmxlKQ==?= <brauner@kernel.org>, kexec@lists.infradead.org, linux-openrisc@vger.kernel.org, bpf@vger.kernel.org, "Jann
 Horn" <jannh@google.com>, linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, "Eugenio
 Perez" <eperezma@redhat.com>, io-uring@vger.kernel.org
In-Reply-To: <20260915-work-fd-reserve-unify-folded-v1-19-4d5217d6b246@kernel.org>
References: <20260915-work-fd-reserve-unify-folded-v1-0-4d5217d6b246@kernel.org>
 <20260915-work-fd-reserve-unify-folded-v1-19-4d5217d6b246@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 15 Sep 2026 11:54:06 +0000
Message-Id: <20260915115407.5E8371F000FF@smtp.kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 013D940003
X-Stat-Signature: ub8dy386owbqf3x9jpytxtu8hkwo3ewg
X-HE-Tag: 1789473249-177207
X-HE-Meta: U2FsdGVkX19m+/U7Dcu2ZjdpwIFBNMbJE0eW5U/6HRqnsgGA55g9+unOnEWZ0iTWcosO9bNmm1hytHdJBicL0PQ7csZlVEQ+g04jZ8/tvlPCWbsiJb3s/zrM+1j7fV0Hsfap0zildwYdgcJppqjICpv/itFPKD1PulDX4hoa5Nz93rPj+zGN1TK0NRrW2eZQsPeHLA90wHFjROsdiIRFCkHiYEs5DRlF0z/t+OcIXc7+3o94qLU6s46QUTQW8O94omQSgewSoezNVRRqafYISYvyMi6zGqQgHgrkxuDvnSkWkY3ht8NnMPJWLknUU5Ipwm142ooVOZKuJ719UjUpFgLnFoKQDFjxv/Y9j+A9KcDWD5AdMjW0Y+xE2/eS0eRsyZvvm0kGqY8W7w+jSrkyD260aR5WZzUpLvPCf9NfTphrq/+sCdy2LVJTFXLBDJ9XSo6woYwZNuNpGI/lD4gWBpXOMW0UopaKPqdWAEPrQCTbjN/IYpEADApWrLam0X367Heu1+WA57GDKOkjWRmA0Q5OgQRNE8/u9dSA4GoCGrJb0zpuHLob0W1OA1xz1QVhW6s372FrTdU3Ib33g+JvKknsDNTrC9g9Usk6x87JWryr435cGd6CFJg71l/hEqfVppWGP2FuwvQdVsiYX3Y3fuR8gQQ7yWvrdl1H/+YhZ5gQ6Vd+oC3lW3nSHVkhZ7bDLcAKcU2VbNdMkaPTMOkBm2MQQrUhTpy2HQYYzdXjrLI2qNUVSNg2aABNUrKo9rVAZ59Vxy9Ry8A0xw8U4Q6SHPuI6qa34QT1u9YDHrO9SGC2P96ONw43nR4Ee/M8EXJ/7hu5NXXE40cV5b6z4Vx5NB6lVAnuMdh/wPe8K3O0nmK3Oi41gF8/GQdP9hu8g/AUCX6wCLZtO/co7JncbCQPpIcf730MUIlxF0YkLja6VPCJ/eLTPuHdhsq45jn5QHZVqfDsXA1lssZY6WQ9X8U
 z+McxmvP
 eUZkNaO9nASGEALGL+Zrf9B/kLlzS/kzWdDthTP4y80aLOVvMp/YUVMpFuSYV95TB5f/Dbo9uZfbvKK6c65cjrEvALxiU6zvgAJ78Qt4yG16XdhHGqnSexLy+2xcDjQDbbUIBmNfsa2YWgsbxA6yhb7r69n9OTYqgskmSJ12MV2tJxY0Ut2sHziS5L2R3xzqKTGW0+PLB8CNS3Ic67fJn3D+ocfGEr00TLIPJ3L9JCslaAiLhzX/nUJo0n4KC2MxarnUDR0kr8djIfTf6HakPF0mAklqHY0oVPP4JQcBgm0ECEI2EHcYgmb9PIdKXtx3v2ysqomY0csKBKkrwKDf7aRI9W1GQ480ZRdFhIpAzF2QVDUIoDC44I21IpiSIBzOuVNsu7Zb4BLN/FuZrPOeKKh/3WbzrNfKwed62zy0+YbX+XqQqbL8Nfb/A+yrOKKAG1tfGSMg7LU0NS7L8Y+yLXjnKjQ6W5PFh6aoJTko6PB5fjbAMlJVGhJwtfkLrObNeA6CSb1DSFWC3wa6v3sSi3YTjZ6Mo2kty8CBgrnlM8u06QXhuJZGz145nmaAWwuFmW5tZ0MO87iQSmZzZxOhzTI6DPur044LBhXtR7NhpySSqp+pNRsnYjaTHabU3skmfedAhRCUxC9AtKcW/sxaVULDxa9CIdPE1mqTZqiBn0eRQVDA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Every architecture now either uses the generic entry code or provides
> TIF_FD_SLOTS. The fallback that deferred without ever committing
> can go. Make it a build error instead. A new architecture can't grow
> fd_prepare() callers without the syscall exit hook.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260915-work-fd-re=
serve-unify-folded-v1-0-4d5217d6b246@kernel.org?part=3D19


