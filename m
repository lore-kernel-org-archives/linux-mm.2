Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F30EC982C3
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 12:09:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B3E346B0096; Tue, 15 Sep 2026 08:09:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC7B96B0098; Tue, 15 Sep 2026 08:09:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B6196B009D; Tue, 15 Sep 2026 08:09:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 78CEE6B0096
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 08:09:09 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C4D85803CF
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 12:09:08 +0000 (UTC)
X-FDA: 85215875976.03.A22F10D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 358C6140007
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 12:09:07 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=N8RCCHlV;
	spf=pass (imf09.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789474147;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1io9HoRsGAc1uikZZU6WOsyCYXG2ohuKM/nD/zRqcpk=;
	b=d1zXabOEA2g5XE8XAU9TK8Gk4xbAz/IFQ4ZbOkDzHDdn4IZ3BpeYzgZOQwqEWcmEnlWOQz
	pqrIjV3Az1bhgmKYcf+dM0m/5ny4H0tYBTrvNpYSr6ESDZ4zcMcN8FMJqU1dQdJV48MGJb
	cdWSqjpz98Ks9oP3mezH8IR5Usu5bNM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789474147;
	b=RPZ0VuFj5p2MFKnTEbU+WpGH2uxxD08J9BZH+u2AsrePguci7mqQ5vu3qIvO+1AEa1co2F
	4ujzjknlmSrkW5rB53ty957p8YcGOj6GtuG4jmHSdDO8ZrKhD8zfYdm8z90u5zLDrAyzph
	bhIlnlhVwNBEabHTsF1gLWKJrXxO4Tw=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=N8RCCHlV;
	spf=pass (imf09.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AB47260261;
	Tue, 15 Sep 2026 12:09:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95C511F000FF;
	Tue, 15 Sep 2026 12:09:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789474146;
	bh=1io9HoRsGAc1uikZZU6WOsyCYXG2ohuKM/nD/zRqcpk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=N8RCCHlVffAYpevobrB+HSSxJIDFQlpru+XuUbTtHjJ+eV1oIVuSwd7MGNhXxoQvE
	 0qXqjr2rait3fVxBCZ9NQmO10kK0KaPG6zwH9T5vPB8yCS66JjHDMs4as+k8T2Fk4v
	 e4FlPeCJiND/Nr5uQ9QzHHTvsCip6NFVrnbNCMKMQ1YJSo+H5BqiKdvJCfjdetXK15
	 IA8lwnZJYwWVEQfsXuIfAhEX4i1LbTqySG8jJzvB5s5qUpYo7CHSb+i+lKJf2KL3TS
	 6U9uLcqyT7Zv3ZiC4C+YKYpQCQ/wJlBcsNSQOQuLTJt3AVMsq3rQldu3icesMHZkog
	 thX6VB3gqrvHQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC POC 30/50] drm/vmwgfx: install the out-fence
 descriptor when the ioctl returns
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>, "Linus Torvalds" <torvalds@linux-foundation.org>
Cc: "Eugenio Perez" <eperezma@redhat.com>, dri-devel@lists.freedesktop.org, bpf@vger.kernel.org, "Jann
 Horn" <jannh@google.com>, linux-m68k@lists.linux-m68k.org, kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-parisc@vger.kernel.org, "Jan
 Kara" <jack@suse.cz>, sparclinux@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-hexagon@vger.kernel.org, linux-arm-msm@vger.kernel.org, "Peter
 Zijlstra" <peterz@infradead.org>, linux-alpha@vger.kernel.org, linux-gpio@vger.kernel.org, "Michael
 S. Tsirkin" <mst@redhat.com>, "Oleg Nesterov" <oleg@redhat.com>, linux-snps-arc@lists.infradead.org, "Alexander
 Viro" <viro@zeniv.linux.org.uk>, linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, linux-um@lists.infradead.org, "David
 Airlie" <airlied@redhat.com>, "Jens Axboe" <axboe@kernel.dk>, linux-hyperv@vger.kernel.org, linux-mips@vger.kernel.org, linux-openrisc@vger.kernel.org, virtualization@lists.linux.dev, linux-csky@vger.kernel.org, io-uring@vger.kernel.org,
 =?utf-8?b?Q2hyaXN0aWFuIEJyYXVuZXIgKEFtdXRhYmxlKQ==?= <brauner@kernel.org>, "Ingo
 Molnar" <mingo@redhat.com>, linux-sh@vger.kernel.org, kexec@lists.infradead.org
In-Reply-To: <20260915-work-fd-reserve-unify-folded-v1-30-4d5217d6b246@kernel.org>
References: <20260915-work-fd-reserve-unify-folded-v1-0-4d5217d6b246@kernel.org>
 <20260915-work-fd-reserve-unify-folded-v1-30-4d5217d6b246@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 15 Sep 2026 12:09:04 +0000
Message-Id: <20260915120904.95C511F000FF@smtp.kernel.org>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 358C6140007
X-Stat-Signature: zzhjdew3ezhuh4t51eamcfxspzzgf4i4
X-Rspam-User: 
X-HE-Tag: 1789474147-33333
X-HE-Meta: U2FsdGVkX19+ZdE5/01/fN7ZQaMjlugVZP2/0WhRebwuOyc9SZ0ru4Sop5XvsFGeh6yHKNoh+QHbT1pLWySKyZ2Yg2d9oCH8GO/d2jY31WE9JPoLKq2lIOw3yMjnIb5TgYf3ZsxK5/SSsgUek9GtuvhK0RNyQ/h2xom/CRA6HAC8ppNnk73Av1hnsykexqHxyQD1kxWupuA2idltyPwqjUdOYaxIF2NE0kSUEaNs9C0qVd6BsrMDukHCqCBWAEGsJwU1kbwdt2AmaOtBttpHqf3LkwuGIqwI9dXxYSGJlF+zrNAo8103j58gDEzz5uS8R6I8DqBBkikKiLyFmw5iWgNjAE6QLflrJ+8LlVqE2j+kxSISwNrNJM9Msjl2RgWz40oNX0qGi9fVyBrLRa38jchZwKURUqsV2sP5H48Bg2a8GhKITD7ly/zZlO77GpGkLYWGy+k7bljuydzNH1qtbbE8rd3aTbx9m6SwoH6Pj9EtE3VH0Z8Gz2PjbsiBuO4ToVgnBGt5a8u2UFpjB5AZoez3lAhCyRBuQDEdogDEo/70c01NU0ziPy3m3lK5qTJjx8r6BWUpJi1zN4lvXRMCaf/R2qhAlGanYBYP7j42o6fWzoIwqGvbElrhQKW5hwsn5ga3jCWliFcwEJAgfeADIT1uTvAqXdLEDNbALviJ6W+q44dQ0hIod9hL+adH/2Iijiqd5lYRUOeQYIJUsJuNC4cDRayY7lWs1b1JNUAhpEPLp0ndv0HqyrK1KPFYqakkiI7myviPUdtS7sIB1pAS5+6WOvzpIvaqzQtTVOtyWcHO8Z8m1WOVVGEdETnDQ3C6r3Ug6j1v+HduOe/BUzjcCawP1Yvem4sin2h9XBkukPOlvZJGTfibjddhPT0cDXBrCqmqA4L8bhakUDwGyj79sGNBTyn3QEz7LIWD1+17TUt0uGsDK89EN95grv0ICL9VHwaA4OuXpNPHPB7+eqz
 exlrgCkj
 Jhm9zGfvunUrlVGmZotK632SHKT+1BPnqqLHhfMbC9IzgDqP7KbyZ6qxVteaG7IV9Yh247cjQKZbYhSgvROuDHhrsLPCzvV2xPs2jf4YboruxuDnQD8J4MSSdJFWRLnGJLEadDbID3PTsqnLua5iy/U8bqI++dy4J/+sbE4iv10NXMv+XK5d6mwAKjX5WWuDisbd/hUNfy0yAg4UnfmUr9NRCDeixSz+/HTcwLUO9/9HuP3psrhSDWs257+ccmIaZ9YDIGKBmGBNyLq0anQlyDphJTlz2orvYj855h06oVmUZwNtWcxyn/6XQV3V1TGlbg18sSvtOnd8C1rZDvrM+bgMwQ8X1pzoGoaYsypw0w1aHsrflZ0L12RcCq88D5LyXCgvp7hLP++QmqqdkdCWC32ceEBa4X5QBDiMY8tVKkKrxTC55B80Z2P6VpOwmF/boVtxaWfs2yNo2+Oyk6D0M4tnpLpOLlvYg0DGaRkLQW+yQth77pwRSkzWn+fjO8r41xMoZz5jXznG1kv6bjGv1X7mxS1MADCjNdClo5w8I2PckzLiseU14YjRIf/CXZx63Xf6/TzlVbFXvx68HajuoCidHPyK60vIK04C6j8w2dYOuWrN7o4Wwv5FHNQYOAeh5bEmiHbcuZhuTOVLXrtCYha9ksEGIeqmbyrDvVQgh5N6srhfg5r4Ev1/Tmicu+bOML7W0
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
serve-unify-folded-v1-0-4d5217d6b246@kernel.org?part=3D30


