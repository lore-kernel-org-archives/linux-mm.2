Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F05AC88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 12:05:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 40BA56B0095; Tue, 15 Sep 2026 08:05:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E3276B0096; Tue, 15 Sep 2026 08:05:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D2BA6B00A0; Tue, 15 Sep 2026 08:05:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 102376B0095
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 08:05:32 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 94140C03F8
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 12:05:31 +0000 (UTC)
X-FDA: 85215866862.18.CA82F6D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 0F8B6120006
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 12:05:29 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="FDJd/hPe";
	spf=pass (imf29.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789473930;
	b=ZnYDfSNSY+yCnnzTA1wIZQjIrNlpBqcBp4hf0EzhEaU69pbCJqLmr+D93xQ04F7TqrpQep
	cSCPZ7NG+4E5CJY+Jfn+eWaBRL1prZrBCm2DBb47Paolb6W28eP1XNYvY7OTW27+dJICJY
	Nq/UTKG8lJNpSDKgm1joEkSZ46fxId8=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="FDJd/hPe";
	spf=pass (imf29.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789473930;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6NXKxiOzguyQnoEQO9LxNWTE3iRxMjdJkj6A9mUtc1A=;
	b=xMQW+DZIfOlp+Wb3YrhV2ni1akRl1AqkNvklOeyopnekQF4QzsjdNTaXLzpLe/YwFcCiOA
	3MSy54uSawLSxjQbNn82jwrukgoBS39j3c+PkZ+4mWgOhTKEHqb/q72vkpECP197qTMGBM
	iqQ98Eus3iT+2YFyZpaZjHENeW+1+NU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A62D4602BA;
	Tue, 15 Sep 2026 12:05:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97A631F00893;
	Tue, 15 Sep 2026 12:05:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789473929;
	bh=6NXKxiOzguyQnoEQO9LxNWTE3iRxMjdJkj6A9mUtc1A=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=FDJd/hPeWG0FQGFbVQjHL1xaPx+T4d5yH5y0Mqbs4pp43o2C3upF/W55cT90yNZY4
	 v0CafCNhn1kfUl9h7/L0G5/2wNT5neqTqXK1mtIHm20rdFzMa6a0JXvgrTKQDa2K0W
	 EpyGSa4pPf3XBWtOTiJWh7acs1xFeKBBUrITujioesXQ0DN26+ocUVIuUJXjh9lEiD
	 QW0DJtvJfkNM/dUEI+lhs0qoSh0U77pi23KqFNoxn/b6iLktEYEx4XGqLkDOAMdead
	 IPztuAKWtncrXXjrtf8THfsOVlqs6SliB8QXWO1MitwNOfsiyqey3a0R1jD39UUoJy
	 wXnPZLwUqx0VQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC POC 26/50] dma-buf: stop unwinding sync file
 descriptors by hand
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>, "Linus Torvalds" <torvalds@linux-foundation.org>
Cc: "Oleg Nesterov" <oleg@redhat.com>, linux-hexagon@vger.kernel.org, virtualization@lists.linux.dev, bpf@vger.kernel.org, linux-sh@vger.kernel.org, linux-gpio@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-csky@vger.kernel.org, kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org, dri-devel@lists.freedesktop.org, "Jan
 Kara" <jack@suse.cz>, "Eugenio Perez" <eperezma@redhat.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-alpha@vger.kernel.org, "Jens
 Axboe" <axboe@kernel.dk>, linux-um@lists.infradead.org, "David Airlie" <airlied@redhat.com>, linux-snps-arc@lists.infradead.org, linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org,
 =?utf-8?b?Q2hyaXN0aWFuIEJyYXVuZXIgKEFtdXRhYmxlKQ==?= <brauner@kernel.org>, linux-openrisc@vger.kernel.org, linux-hyperv@vger.kernel.org, linux-m68k@lists.linux-m68k.org, sparclinux@vger.kernel.org, "Ingo
 Molnar" <mingo@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, "Jann
 Horn" <jannh@google.com>, linux-arm-msm@vger.kernel.org, "Peter Zijlstra" <peterz@infradead.org>, kexec@lists.infradead.org, io-uring@vger.kernel.org, "Alexander
 Viro" <viro@zeniv.linux.org.uk>, linux-arm-kernel@lists.infradead.org
In-Reply-To: <20260915-work-fd-reserve-unify-folded-v1-26-4d5217d6b246@kernel.org>
References: <20260915-work-fd-reserve-unify-folded-v1-0-4d5217d6b246@kernel.org>
 <20260915-work-fd-reserve-unify-folded-v1-26-4d5217d6b246@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 15 Sep 2026 12:05:27 +0000
Message-Id: <20260915120527.97A631F00893@smtp.kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0F8B6120006
X-Stat-Signature: 8gszh3qfijkjhtqc9trr89ptg9zert9r
X-HE-Tag: 1789473929-181033
X-HE-Meta: U2FsdGVkX1960oybmwrizoPxw8vRKA6DPWAhWKQ05Pto8Bixnvsgkl1X9z6gB4q+GWTX9gnC1bsd81VAeuYGZ5lkHD+X1drI1l6np1NAJBPrawaeisAn+fkldsN/HrYtwCpPpH9fOpgH3eXh26k2M5aauS7L3lU9ebsw9LOLvpxCeJUaxGLa6gmCnl8jPF4hxzT+IJ83FQHXOjBsPkFCjydnDG4rhOPYvu6crx52dh6md/8WKVhb00hc/Vf96ygywLmGudjTBHI4DwNP0gCB4/P0bKH35tYPPZ3W/qgr7/KO35WFvJi8S4doI2yVGvIh1biD7dJbpW7D/R/Y1cl4HoShvvtWb7CkW2P8gn9iSgDzy9U1w7At+0TMCJHGvBO8s7bn6bsoAJuTcizDTkmeStqlQ6A/A5smH5V9HysQBQrZIDi1Uo153zbUM3QL3ScTMVqPxsPLiTbKo1rzckc+pF1ji3FGeCQrIgaUKmC/I3tj/YlyQxf+kZ7CefNXcP4tygi4JWrmjUkSVxHOJQ+6kw+WwaxmBDQjTWPXouLdRZrm6rcntPd2wrnZfYn9JAW5yugjW1AeI5F2YNsSip8RI5AMYE3N3/M4dVnqUQV97m0sC2oUUf0ojG3/A0b4XMrSNM6S0vcD7KqJNOVpNHfVHo+d7nLHAusYe4xK4AiH8Letk/evWGDdrhfG6RoWyDKhiQvFbAT2uqCo4ObsQXe8JjtRvLZKbPfuprbccLunEoulFgYsv/RFe8xj9/z40Q/cpHdcYIAYjL+Z3DKduYBt6AOLYi7P91vAQMhzkjFr/+/yYO3GWD52vziek6cQ2biplyaK+b4YK6VamGxtQFlepk4zkUOeIPlmI0wjKwSyMTYJwyfueu2jBjajIp7XJEb13mzJtKW0FysXeLrB7mBCU0IxblZK3+mGEIiJiY6aE190p/sHpmq1l5gCOwQaLJSbpRlFZyy++0mQb8cyx/w
 7FV3nzVU
 Dbn4eySoAj7qKa6Zm2ps8a4dTNA//voHPqsTvbrBNpHeSrq8A8w0/7hD4Aa6hqlP+UBbnLEtf+FnryQ0q6JzQ60wGIyW6a2D3uKby6eYdQOrVDjqgAB1YhvxzxAA2zNGZIJCH9Xv9HObxDrG4c8qdbBhl71wiztH2C/wnlJ1K1+kHQtDc33jo3LSeC+FrfBzgh9U/6USdgsLtu2z2xp34nQA/DOq/HQECULonhhzem8OsE9uo+xSzf0WRlgg1RC7QeYFZVV8PYFyqOjK+omxXYB2gZ1fcpEUBf3dfTRMzTZoqiJx1t34/h2dEbG0FwUMWdfqyLCRpCLxE416HqGZvRvaXzZfYeVBNnpvmDuwYbMCHWfRXvgKrZKwH1rxRg7yFhhCI/8KDDKfpZP8jqbLdfcjhNClylaAWWlSyO01CRBnTProgUn2oNDjOrlMFr1WyUJrW2jqLLXd+1f/bFDZIQWul043w0omTumHIdaPfxETZ5eCOQwCqe53kqp4vnFwyh+3hzV1di5YOaoMeZTf3HxW8WMcFwLt3bUWepNAh/HQSnhMlKeMwR9tbi8dTlTQ/EyMqUS3tRjbHRyUdro5b/PqQTggOglhffVhbIM4RXA34tUKi+wqBjbqCofBfUf4kj5yeyvCDCUm7Nu8UZ1a0dTizSj03McwlmdWench8H1pPkCWOcFIVsGy0BN3+qm/EM3O0
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
serve-unify-folded-v1-0-4d5217d6b246@kernel.org?part=3D26


