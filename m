Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22BC0C88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 12:15:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3819F6B009F; Tue, 15 Sep 2026 08:15:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 358666B00A1; Tue, 15 Sep 2026 08:15:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 26EFA6B00A2; Tue, 15 Sep 2026 08:15:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0566E6B009F
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 08:14:59 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 94F7B1603BE
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 12:14:59 +0000 (UTC)
X-FDA: 85215890718.26.1C71E27
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 04A2B20009
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 12:14:57 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SQ3aDU0Q;
	spf=pass (imf13.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789474498;
	b=PjfgVo2KyTlz67A34iGqULRnGosZsUp9KbaxAxHmbnqGf4xNCOHie0VJ15WgrP87o60FuR
	HjlSAg69lxofUdDag0g7XP7O4E1DYXrdEI62VyCOb8MGCEVf4IxLxTd4L92N2R08PiYeer
	FmxBUhZK/SAgF6xD4LI0gFIP+plT1K4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SQ3aDU0Q;
	spf=pass (imf13.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789474498;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ejtHf7OrVCONiSGbsU0Szkqhw/V3NKRKJBvDExa4qrI=;
	b=KZE936/534n2tMdOevXcBMDp8ATML3Y2hEoxdbf0IntiIlgID0dOxIuwkadyyHiVK0mSuz
	UFKq7YR+dKuIQfuFarcUAAIjI0DLdpUYv+R0NO6GJqSu1yFIl85xBPDZNRIOtLOBKQCRGK
	+H5gnUKYMKsywYmWp47x5RWZnhJA090=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 57C3740450;
	Tue, 15 Sep 2026 12:14:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 398E91F000FF;
	Tue, 15 Sep 2026 12:14:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789474497;
	bh=ejtHf7OrVCONiSGbsU0Szkqhw/V3NKRKJBvDExa4qrI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=SQ3aDU0Q8GsPtoMGWFzUtgXPVhQk5j3tT2hP5/IYPK7pNnGp/W35LdJkurCxq/UDj
	 jXECYSMyRfHDZKzN98Ln98DAG1rH6aAR4ISmzyGlU1rsDvw5Q93DNzrkBW2qSN7IRC
	 YJr9cCfLCK65yz/lnkKU0h/88SazD0WGxzlXFRwUnZmmA1pIC11CPHPte6Jw/NVEZ8
	 jp0yJWYB7+6Cgap52rqfdYHOC0u+j0XckjkUTQa+uZ9aKsrGomUpcl6BdIHpYiyzm/
	 Rqj2wKLDgmWRUAKCkxgoX9x9LTH43+wakiVHy5v4VFxVPQvMYbRVfHWWmjs+K15B5a
	 6EBFBzK+SsdcQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC POC 34/50] sctp: install the peeloff descriptor when
 the syscall returns
Reply-To: sashiko-reviews@lists.linux.dev
To: "Linus Torvalds" <torvalds@linux-foundation.org>, "Christian Brauner" <brauner@kernel.org>
Cc: "Peter Zijlstra" <peterz@infradead.org>, linuxppc-dev@lists.ozlabs.org, "Eugenio
 Perez" <eperezma@redhat.com>, io-uring@vger.kernel.org, linux-mm@kvack.org, linux-snps-arc@lists.infradead.org, linux-hexagon@vger.kernel.org, "Alexander
 Viro" <viro@zeniv.linux.org.uk>, bpf@vger.kernel.org, linux-parisc@vger.kernel.org, virtualization@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
 =?utf-8?b?Q2hyaXN0aWFuIEJyYXVuZXIgKEFtdXRhYmxlKQ==?= <brauner@kernel.org>, kexec@lists.infradead.org, linux-arm-msm@vger.kernel.org, "Ingo
 Molnar" <mingo@redhat.com>, "Jann Horn" <jannh@google.com>, dri-devel@lists.freedesktop.org, linux-fsdevel@vger.kernel.org, "Jan
 Kara" <jack@suse.cz>, linux-sh@vger.kernel.org, linux-mips@vger.kernel.org, linux-alpha@vger.kernel.org, linux-openrisc@vger.kernel.org, "Oleg
 Nesterov" <oleg@redhat.com>, "Jens Axboe" <axboe@kernel.dk>, "Michael S.
 Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org, linux-um@lists.infradead.org, kvm@vger.kernel.org, linux-hyperv@vger.kernel.org, linux-m68k@lists.linux-m68k.org, "David
 Airlie" <airlied@redhat.com>, sparclinux@vger.kernel.org, linux-gpio@vger.kernel.org, linux-csky@vger.kernel.org
In-Reply-To: <20260915-work-fd-reserve-unify-folded-v1-34-4d5217d6b246@kernel.org>
References: <20260915-work-fd-reserve-unify-folded-v1-0-4d5217d6b246@kernel.org>
 <20260915-work-fd-reserve-unify-folded-v1-34-4d5217d6b246@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 15 Sep 2026 12:14:54 +0000
Message-Id: <20260915121455.398E91F000FF@smtp.kernel.org>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 04A2B20009
X-Rspam-User: 
X-Stat-Signature: zibi4wwnsk1zocge8xz6756cgjyaaizh
X-HE-Tag: 1789474497-907991
X-HE-Meta: U2FsdGVkX18tNyNCrdeuY6RDvOSEi8tX/+DPznBW1X0Xke4PHjP2mDkaBKy7rM438e7unHb3VFpnwmlZyO/yMZkJkxvwX9HYBsYCDuMK89Ze4jYVhgmj63OqDBASgHx3W4kSQZiAv/IcNZyGIXRraeUm+Fv4izUHVTXy60z/JEmQLgZir8icKmu1tFcnl01b41zf8xCMN5duKzcseemZgbTf8UCwInYwbQ8WqCi4bZ50fQZ9cWCROX6SW27xI+41SK3pt4WXKgaFQvjALEIoBatS79cHvGV4Q3SSKJei3EeJYf4q1jYfXXIb9s+hRydNPJ6UKumj3AgoO98KJ/KRFCAfW9tfZEdCfKwR4L0Suff5MkeCNf9tWEgBCYRqs/ZuQFZh+7ccm+j39vKdhbYDDpRC/FXtlnwOXKsMCyyELsKh5JsDvKcEHeyLCA+uta3g4kp7tgoblhGNMOho8qe13SByVGPoUN9JriODKvRgxEdB7G4WEz3eU7E+u9DYfiXXCucf8Z9ulWZ8G7rIWTeNrVm/N5WMEiU+97seAjbLhUAx7OlqMIU412/LIoLvNIhezNNBJOSqtAoxcoDTPwIBfuMuWlrCi1DZCzbF7Lpc6m5OofafsNyXfw2IHwRS1ivC5VEwkKVXpxFvbTgny1zEFVTNqDYWCAx6KXoYBLwmzgrtfstSof5zyZsmQuHfOrthEBOr5cCejTbM6ikp5wAgl0JRglM9zUrYJVP2Ymo5zM2Zuah5ii/Ufrb8mBt7CcJ3pd4ILxfIuprh/QBHYBv0Tv6ac81iRL8pQ4R3ucamyaVJZ63ERRrViYQnhvHzXryajPrI7P1u6zlBS+Wk+3ySo7+ORxkj8qQrX28dy870ADs6Mk06MLXJwcMMalVKt2D3DUmA6qMvecVwvZSR0nR1h76lm0OiouTXyhYSQoO5y6WKxh83RZzSU+2DqXhH4jzeNzPBkBNX/M3b0RCsgma
 DFwlCpRc
 IeqEUPJTFOT8Z1YQIeDheunKvkkd+1/6NAt1Nfsmf1h6NvijLO5QITA5c/vAqI+z5/BVff3MffigOJ14H04559/H6EmceHJg1bPMxefu2nf19X8sU8DrGZSoU2ff0IGzlJO6h3e3nfjTQhKmNCXdIzUN/L7Y3WBj09ZTlOuHVjr0b5/izLo0o/+C8NbUIF+BXP/bqkfJI2Iz/Yeg/NWmBdbEeOa2HBdAcyQGZm4TEcDa2T8pQBx84asa/hhoElrhETlvEcW3h4kpfp/ZyFEZPBahjAD8oyrtBz4QrcQbzV75NvAZwAXTYD7aeeqNYKriTSCDfnzy/XNPQOII0Boju5j28YynjEJ7ckbj47x4TOJpZpQ3qacT3dBDediIes1pZhFtz2MPVa3IHpL38lvr9e4Ffx9/RfpjleAgYI8ta8oFpfvFNO5PGlEKcrrovoqRxId9UxWP5lFjEkXsT3OJe6ul1JVFxirFR/yIduGS1mCwKylE+dyec8M7mEgABc3iAYGQmGxbtDXMdXA52tVOshwF90TQ42CGZ3sdYkUz+moHl+0S4w1MJkmMZODPZmwMqPPMgs/UnK384j/Ca777dlIYhiUcExNllMTxLM7/i4WWItv/R9dwLZiy/XZ+bw/gyeaNV08yLqTj4vPCxuMe6KHbnIsPV3aTNhKG2ISBpRx6PO5wNoqLugZLyl+FnCeNsx8Jq
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
serve-unify-folded-v1-0-4d5217d6b246@kernel.org?part=3D34


