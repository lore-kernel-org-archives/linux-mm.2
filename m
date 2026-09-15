Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB4DBC88E53
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 12:01:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D7B666B00A4; Tue, 15 Sep 2026 08:01:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D547F6B00A5; Tue, 15 Sep 2026 08:01:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C6AD36B00A7; Tue, 15 Sep 2026 08:01:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AA2CF6B00A4
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 08:01:57 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 515CDA5469
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 12:01:57 +0000 (UTC)
X-FDA: 85215857874.06.310865C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 8D91A80008
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 12:01:55 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=l52++faI;
	spf=pass (imf30.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789473715;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yaVzdP8lM5NkwsIfqLJMk1LB9QIq/dT8qJrlL2t7nR0=;
	b=M8MzOl1khWioSjN6zvimU1M5fal1GDMaluPUhzYUwBfBxvNcDAILdT4uKLtTHXG5jUFRDG
	gCDxUvYjIQy23zucpVfEwFXtD61ZBxxV2cv3LhOubHQksHOeT2tz7jbojcgOhNYfPzBHxN
	VXRpBDno1kC87MZk4xrJOmt9UifCjo8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789473715;
	b=2tB8HpRmc/A4Gk0VMwrc8Y7iMUxC2nxEhqHCGMnk9j4XphYnCIzduQvYIrtPg2Zzf42kjv
	OzvYAfjJ/5dOcILStvrQdskwPp/qeThLxEs+vOKyrHJ3PwbmHhhxunAimQMCItdJ9UzvZE
	JLw96qCSg1ufiSypSqUns7w+FGrtgkE=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=l52++faI;
	spf=pass (imf30.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B04684040D;
	Tue, 15 Sep 2026 12:01:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C79231F000FF;
	Tue, 15 Sep 2026 12:01:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789473714;
	bh=yaVzdP8lM5NkwsIfqLJMk1LB9QIq/dT8qJrlL2t7nR0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=l52++faImdy1ik2llOoUzxFM8W+OJ2XgjjuOa2l8s+lX7brqaeHpAYmZ4NzMpai4G
	 ug3NGNC5p0QWw1N5SrcuH1JNzc0OyB6fZWD/NF1d6szX9grpxtdkUDi4tpXooy6x+p
	 JBH3hHZryEmAGb6mrRF6PVK9CJEilmARd5Me/4O9iSahRnJEixJ4iyWa0Fy2QMNHa/
	 679PRfPUgFWQNItfWZewH2Q2HBpXsprj9rAD8pmB/m3WtcE/OlAB27TA7JatQQXEIi
	 yV560hB9vQUixGJJc7XE9I7TKlEm3Q7gGxUx/GBKXr8HLMxp8z5pfujIabo5IiT+sh
	 wkx7+O51PlMkA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC POC 24/50] file: make FD_ADD() a standalone
 immediate install
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>, "Linus Torvalds" <torvalds@linux-foundation.org>
Cc: linux-m68k@lists.linux-m68k.org, linux-arm-msm@vger.kernel.org, linux-um@lists.infradead.org, "Jens
 Axboe" <axboe@kernel.dk>, =?utf-8?b?Q2hyaXN0aWFuIEJyYXVuZXIgKEFtdXRhYmxl?=
 =?utf-8?b?KQ==?= <brauner@kernel.org>, dri-devel@lists.freedesktop.org, "Michael
 S. Tsirkin" <mst@redhat.com>, sparclinux@vger.kernel.org, "Jann Horn" <jannh@google.com>, "Jan
 Kara" <jack@suse.cz>, "Ingo Molnar" <mingo@redhat.com>, linux-arm-kernel@lists.infradead.org, linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-mips@vger.kernel.org, "Alexander
 Viro" <viro@zeniv.linux.org.uk>, linux-hyperv@vger.kernel.org, linux-snps-arc@lists.infradead.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-csky@vger.kernel.org, io-uring@vger.kernel.org, "Eugenio
 Perez" <eperezma@redhat.com>, "David Airlie" <airlied@redhat.com>, "Peter
 Zijlstra" <peterz@infradead.org>, "Oleg Nesterov" <oleg@redhat.com>, linux-openrisc@vger.kernel.org, linux-gpio@vger.kernel.org, linux-hexagon@vger.kernel.org, linux-alpha@vger.kernel.org, linux-sh@vger.kernel.org, kvm@vger.kernel.org, bpf@vger.kernel.org, virtualization@lists.linux.dev, kexec@lists.infradead.org
In-Reply-To: <20260915-work-fd-reserve-unify-folded-v1-24-4d5217d6b246@kernel.org>
References: <20260915-work-fd-reserve-unify-folded-v1-0-4d5217d6b246@kernel.org>
 <20260915-work-fd-reserve-unify-folded-v1-24-4d5217d6b246@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 15 Sep 2026 12:01:52 +0000
Message-Id: <20260915120152.C79231F000FF@smtp.kernel.org>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8D91A80008
X-Stat-Signature: bzxyggakkbxxkgdaa1s4e5dtropo637f
X-Rspam-User: 
X-HE-Tag: 1789473715-791262
X-HE-Meta: U2FsdGVkX1+/TFeZcskB8KTtGqVLUPhrevt53rSNLF2klwv4XHTeWhkWIJeiVQiTcsidupA074sTf58UkY7j3skcjo7ZJgdbNyU5kG4dewjwAOz6DyVuzn9OeBZ0Cj2TaMpdGAxfJD5nk4wwHNQ3vqb2+WCyS3WIDSatBNTNy8ExPDS+/d7P6ocKzk5NmBapwgN1xt1O/Gj0bJt/TEX7QJpU6lkNQctBWKh2bgUN1Wx5GFb1NznPOJS0vwOScGfKoRMNQSb51Pjy23Wr1pLNSm1gtGWS5B5FNkSUFtbJmzuNjD/T20xXtzA00C6OsBGR7mUMNJzKpAfGEvjGA/XLvOALp5ZjEr6eh7QUTk+yTL+cKStHvr6E75v799AZuSo9NwG8z0E0bAcwe87JKDY3w4zwUI/VGIz5UTjBpDTcpGppNHCqCGrPGGmOzhtH215a5wCzsW/sdaHJPJquNdBuGDq5RN+d7WBgCZRDn87FqEW48bPMMIvmOrMpnjYMnQy7AKLjBHeYZuy116HV4cKnTzVmrALnSVRoNNfwmeR3hiIbGokqmZMIhL1/7H6J947Tiogz0CtzreS/rIa1K5HEju9tJ3ojoAj81rsXKomrDmpFdbHcCF4SI7eABQS+rojxLtaMkTlxbZnvxxo2P59oz5xj4U7blPRuWkpLGgIcvMrCPEDJk+ETi3KzMi7xJS2Jnek+3EGVr8DI9jjhTFbo5VUqTCMp75TDxIv1dYiKhwVJ/IuIeKs4L91jBVGuCIXj9ZIcqEI4MFqhES7vS3fLVs8uM4fjbrtiHbkGIlWCZWTfVRKilAYw2Q8LFDgyqy2sDtorZPWHT7JFvb+eu2+y6yqd8ZqNEOSKT7PwLf955BRQ2LasaVcp7IM2F1eW/POOsscF5z1IUhyLkpLwaPHg+lIrbzSgLT92jfrOEALqTfx0Fxmj9aD1Kkj6dHJN7M+S6DGavLBDQ/nxPnpcnry
 OqNk00lY
 H7VSrxOPiZ4Y435YN4vAYZU9qPajuljKYjILs2I92Q5h8FgIsNsizJI84iaxdIfvkLitQspWu3Hq2J3uQXkEMZo4WYl4uMR9tmHd0etSXSeTgnChYp84OqRKtutPxgX0CyQLYoL3X+Ca8qMsihdxzCz2Am7MLHLr8PFq9VvEv6YaBr410Mhp0WIpq9PrgQdXlyk7gj5HgyvkwwQl9ytJwH4c5zm/TuTFEHYi9oP1sm5NXn9/3MeqsTGjrBtgzTdHpOP72kFPwbbil8Lx53bKuOToC1MR6/QCjSQ6GZluutAOzz5xPooQH3TsOdqJoxfDRtRBLDKVEzFZs1H8B6nfDA6XLduTw8Ksva/23faaFO83AszagqmW3IpP+J1gh2s8/tlGsmzt+fHIKKD5E0WeQ0MXPRIlC1RBTjJlz1ArZ/23VtupiKXK4UlUTwbVtDqBRFGr0k1cZwt1PNHgoY182rlfNwlaqpjv0bvRctWEUnf/zFQoYyvsF3qnxaBck+ct3V3NOJJWL86hVw1xf7u3lkGPvnpo97k0AXGKVvi7DcRvqS7wC5FmoeO85QKAsRtbhFOvzn/o9zzJBBpoqaYJQv+JZ6MGHfImP9MW2aX5zKnxFZari7lY1xEutZrbnRZ92/N9Q4kPd6BQZaBakh4/cc6WmjBVmbu8xM/wMQWG2T79RgdiRhQCE+f80fA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> FD_ADD() was built on FD_PREPARE() + fd_publish(). Give it its own small
> macro that allocates the descriptor so it stays an immediate one-shot
> for the hot descriptor-is-the-result paths (open, socket, accept, memfd
> etc.).
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260915-work-fd-re=
serve-unify-folded-v1-0-4d5217d6b246@kernel.org?part=3D24


