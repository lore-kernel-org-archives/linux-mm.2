Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27C91C982C4
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 12:09:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2188B6B0098; Tue, 15 Sep 2026 08:09:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C86E6B009D; Tue, 15 Sep 2026 08:09:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 093356B009E; Tue, 15 Sep 2026 08:09:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D663F6B0098
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 08:09:36 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6B59AA03C8
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 12:09:36 +0000 (UTC)
X-FDA: 85215877152.07.0DD24BF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id B5DFD14000D
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 12:09:34 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jH8MeFUt;
	spf=pass (imf23.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789474174;
	b=npNjP3IKL0XhqS2Pebzu5dgv+lKgvpPLVBaAsV3rdQRm0nBbZ2jHnjXnW9EtMFDqGezKXO
	lvjkIis+3TKW5V0U4dYBhp10+elouCT7hGlCASEqee9ejuHUzyGRuoqUiX+RXzAUQxJp5V
	FgfC+QFm2gu9/HNQxaKdXrLV2cvb+rs=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jH8MeFUt;
	spf=pass (imf23.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789474174;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UYzMflbMuPv9H/GLK1g6J9E5AwtdI+O/+Pdc0wsdGlQ=;
	b=oxAP2lgZAKT+l6zULzbPNL1y/E6DJjMCotHo1839tmCOEVAhz6jGIchzKkHD4aeIcCeOtT
	r2PRkeGPqhPxi9kr0oLjLEo69NubfYWo9PQWeSi4oeVWpjiFZSupLyNuWsUGsjzXSvZUqY
	NLJUJ2tTJuE90TEdNmAhWG5tBwzMUOE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E3EE84096B;
	Tue, 15 Sep 2026 12:09:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ED881F000FF;
	Tue, 15 Sep 2026 12:09:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789474173;
	bh=UYzMflbMuPv9H/GLK1g6J9E5AwtdI+O/+Pdc0wsdGlQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jH8MeFUt+Ca90GijJLK5hVAYB41iBAVkHXhYxlgSQZsl+pyWmTzGkAYZ9RXqYBDbG
	 rKZCB6pYmFyP5M1bk4Irpshq50uz2b5QkCnTtwMupHWy+yvoXlLhHmQpzBrkPJbweM
	 DOJFaJK8kjjNY5ZP2iw190s62x+TzNavmrmqQj5YP/0STVvoLNJYJafDKfgf5ojLUP
	 LuZmhYwmQV123gJgzbNrAwrP+hPwOyQBF3mK6DppyLtpzOvR8DpMm18peMtTYKiuPd
	 RpvHgbF2jJw+E059MS7iRdmviODCKeE/Aiqyn0EbGm/VrErx286rEzup2WusNoTIC3
	 +JC3oUetgOKKg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC POC 33/50] io_uring/zcrx: install the exported
 descriptor when the request returns
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>, "Linus Torvalds" <torvalds@linux-foundation.org>
Cc: =?utf-8?b?Q2hyaXN0aWFuIEJyYXVuZXIgKEFtdXRhYmxlKQ==?= <brauner@kernel.org>, "Ingo
 Molnar" <mingo@redhat.com>, "Peter Zijlstra" <peterz@infradead.org>, sparclinux@vger.kernel.org, linux-sh@vger.kernel.org, kvm@vger.kernel.org, linux-m68k@lists.linux-m68k.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, io-uring@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-parisc@vger.kernel.org, "Oleg
 Nesterov" <oleg@redhat.com>, linux-hyperv@vger.kernel.org, virtualization@lists.linux.dev, linux-hexagon@vger.kernel.org, linux-openrisc@vger.kernel.org, "Michael
 S. Tsirkin" <mst@redhat.com>, linux-gpio@vger.kernel.org, "Eugenio Perez" <eperezma@redhat.com>, linux-csky@vger.kernel.org, "Jann
 Horn" <jannh@google.com>, linux-um@lists.infradead.org, "Jens Axboe" <axboe@kernel.dk>, linux-kernel@vger.kernel.org, bpf@vger.kernel.org, kexec@lists.infradead.org, linux-arm-msm@vger.kernel.org, "Jan
 Kara" <jack@suse.cz>, linux-mips@vger.kernel.org, "Alexander Viro" <viro@zeniv.linux.org.uk>, linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org, "David
 Airlie" <airlied@redhat.com>, linux-snps-arc@lists.infradead.org, linux-alpha@vger.kernel.org
In-Reply-To: <20260915-work-fd-reserve-unify-folded-v1-33-4d5217d6b246@kernel.org>
References: <20260915-work-fd-reserve-unify-folded-v1-0-4d5217d6b246@kernel.org>
 <20260915-work-fd-reserve-unify-folded-v1-33-4d5217d6b246@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 15 Sep 2026 12:09:31 +0000
Message-Id: <20260915120932.0ED881F000FF@smtp.kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B5DFD14000D
X-Stat-Signature: rmq6mf9z4yi5cdemuie5bwe86x9ihoff
X-HE-Tag: 1789474174-508016
X-HE-Meta: U2FsdGVkX1/NtBMiCGNTWJPh7mzA3O628NzYgSxKnzt9fP+hab55771/9s5kgPbR0Gq/sO5cyMNfXuc3O3c4ZStXe7XO/r3yD+2vDq9FWJsqV3H0LzH7U64OX1l5hEgldlxw+Vlz0114F2MxI4TKQqe7Q+q5RFbZG9iCH/M6nJ0FPnp4Jk60KZgX3PZkxAuY+r2jVIZtjavDpuF8qqSmuVcdS5s3+WSf7hZr7e6qFhXmWhdC0vjhNl/pOrSpqFWpvjrTGAA1RwLy0Lazl+uNuCZAeaQZwYRvDfeM/Uh2w98lJwiyGgYa0qdegYlCPdl3imTiD5zLFLIZ1qU+wCitJyf5JdTpSzt0LrUyxf2pQR65NBtfxtuLQgZuXKAOniT7keaqXsG3b/9mnAw5CjE7e9jxxFDl79tHRM2/GHNVy8GVgyg0wEbEQGHUWdIsDjl/sa1XksQyshy0Mz7Ma52FYdRflf8NZx45Rr4caEfPVcPR22uaP5uBOknsDpPA4I/tKxYfMEq28Uxd033QCekW4NKXiF1fIHF6RDlw008kNn1s8Esu6c23djFZiQI0jiPhujy5HGIVCbjCKir0Wa5+nsyunFAKvq5SK56svJmPskJp9fY927/igLVvkvgwmw9iahya0tAbP5M6VnUHtl88p5j8ip0uGO5WpVDmENhcRBuZUTY9PTCiLWF///YWbtue8tlFyEp9UHynOfclpUnnWKTaIrRGvWQg/eLvo7j2WPXcU05pedgnQ2/7HsVjagJ3j2Ti665O5rmHHnbZKhqkJPy6XfF0txL7S39a4WdAW0WqqPoUSSrLa0HrSp6ywfIERF9/1IeOb++irgTWBGkHfhvrzscXj0GX5Q4mnNfzG0NTZnxW+WIVfS2dXg5XBghrnZ6IG0SOu2OtpvbeMCKz2AGGfEQaE/lKtNAmqHzhdBDqMvUIBXLgSvRFvtq/C7drvcTj8scScVvATcWG3tH
 JLyI8r+x
 YdXMjG+ot8QGu1paRudKxjZbl0lSdfrCdFEmr79BHvgPNpudU1lwkR8E8XTGSrOGpn6n549/zil8+BDjWPyUfu05nEOkuCvTRHzb1zdguWVp8wEHKu1z4FvjTGtVi0suMWdZe2qYR+W8EdOBKLrfaS7ezU2/Qy9axGWj7tvzRhI22sNLvLVZBulBYJCI62MTZaxglit/e2qHeoSslb6OyDo3toBzzjgjB+jw5oTK55vaDLBq4kw+Y4DleTgegEdcf5abJfR7P3QlNiGUrkuGP6HpyJA0xxxp+u/W6SSyd+aWcLqTREQuzg/Y3Nei/Q9AdrHJERHVwyFeHwYbmcMXwCVaPPcJLPscLRKV94wn+DirmPD1/UJRuvHrmZNyNWzN0uNQV3QfWKtA9/oGQuB5Dn9RbnYU44H1Hxhedq1zUpW9W5lpLXMMpytD2Va0Dd9Blez2RLWjzsZ33X8TpMm4cDyNtDu8e60mcbrDWaJ64YrixOj1P7kUHQwshZdfmUDYglCIv6O8ZYmD/6IZxm9Q+z8ELp3vyGtfcJyUckc8vo2sAeGjJlxx2firWTAZvxATCa3sPqV0weQ2Pvu8xd7fNeWM3upcr8V0DMK/cXWXVy/Yqg9dMfwXRIeM3XR64IEAYUvjqg5QScFW2mRQH6+l0yVawm6TC1MkwHuWGIEmAv6LSrOy6B//QwjGexE9fgnVb+hYzEL9BgCa/KxbFyzomFEzFBsYUTnWFAjswrTJFO4vthoUYtWrOuaMBpg==
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
serve-unify-folded-v1-0-4d5217d6b246@kernel.org?part=3D33


