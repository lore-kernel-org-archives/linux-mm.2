Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 253B7C982C7
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 12:18:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2EC7B6B00AB; Tue, 15 Sep 2026 08:18:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C3396B00AC; Tue, 15 Sep 2026 08:18:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 200C56B00AD; Tue, 15 Sep 2026 08:18:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F02A66B00AB
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 08:18:36 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 60F3A40327
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 12:18:36 +0000 (UTC)
X-FDA: 85215899832.24.0D3BC90
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id BDD171A0006
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 12:18:34 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=al7xG3Qx;
	spf=pass (imf19.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789474714;
	b=0LS7GmUMefyH6ewj+I+IVzcw6UxlAhFbxYTrHxQDwGM6/lOKT9+ha1W6dO27T1I3WvvgoF
	SKMmXUN3/QItYha2txeJ7B4S1WkeJMGWWYUJlbKaltXwJTO0CM/bsidYrXNqc9HQJvfh2k
	AyWl+YSzUd98jZFli6ZJMBD1FKg1R0s=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=al7xG3Qx;
	spf=pass (imf19.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789474714;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3Nr8gcCwi6DEWSLP9EN8/l4h5yq3GfGsy2oDZDwQTVw=;
	b=WLFk39bIiIOaewwqScTgcm5036imcSp3EI602GA6fLJ4HLrLnykkT03MATgbMfEV+pEr8s
	mIwgVEE/V0DxImkQe9a4qYsrg4SBaBOdiI4ugEsQwhqf/DW9pFprCvPihYvqot5zE02dbh
	DX4cWRfBuzt47iDyDPjxW3DKvR7gv78=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 24A0A41B11;
	Tue, 15 Sep 2026 12:18:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6100B1F00893;
	Tue, 15 Sep 2026 12:18:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789474714;
	bh=3Nr8gcCwi6DEWSLP9EN8/l4h5yq3GfGsy2oDZDwQTVw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=al7xG3QxpordB8FaZac1xk6QWAEGzphwDCGfy40ckeGGdeDP1tbwhbJklTqx5QQFT
	 ODvPZmGs3Rku3J2uQB3ChHYQAriES6YPKKW/TWgpaSESxWFOwioknFfQIhOZdlb/lh
	 RLkOhFE53P9jFChtaD6A2+vi4SogD6zm9+SM0eAaXOgGkYYLJJfSgO/RrU1jMf018L
	 IsZndXI06LzsoDnaEX00kNg9+CSe+xR/UDoSJpVb9b2SoGOi1j19PuVJIg9jG4HZNR
	 dl5cjIQ8g0S9+wNIlluWxOi9Rk+9A+i9qr4Dl8RqrHyi07ZG8WPpqBJZWgaHICrgtm
	 ZwEgDuMch+DXg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC POC 47/50] iio: buffer: install the buffer
 descriptor when the ioctl returns
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>, "Linus Torvalds" <torvalds@linux-foundation.org>
Cc: "David Airlie" <airlied@redhat.com>, virtualization@lists.linux.dev, dri-devel@lists.freedesktop.org, linux-openrisc@vger.kernel.org, linux-arm-msm@vger.kernel.org, sparclinux@vger.kernel.org, linux-mips@vger.kernel.org, "Jann
 Horn" <jannh@google.com>, linux-hexagon@vger.kernel.org, bpf@vger.kernel.org, linux-gpio@vger.kernel.org, linux-m68k@lists.linux-m68k.org, linux-hyperv@vger.kernel.org, kexec@lists.infradead.org, "Eugenio
 Perez" <eperezma@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, linuxppc-dev@lists.ozlabs.org, linux-alpha@vger.kernel.org, linux-parisc@vger.kernel.org, linux-sh@vger.kernel.org, io-uring@vger.kernel.org, "Peter
 Zijlstra" <peterz@infradead.org>, "Alexander Viro" <viro@zeniv.linux.org.uk>,
 =?utf-8?b?Q2hyaXN0aWFuIEJyYXVuZXIgKEFtdXRhYmxlKQ==?= <brauner@kernel.org>, linux-arm-kernel@lists.infradead.org, linux-snps-arc@lists.infradead.org, linux-um@lists.infradead.org, kvm@vger.kernel.org, "Ingo
 Molnar" <mingo@redhat.com>, linux-kernel@vger.kernel.org, "Jan Kara" <jack@suse.cz>, linux-csky@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, "Oleg
 Nesterov" <oleg@redhat.com>, "Jens Axboe" <axboe@kernel.dk>
In-Reply-To: <20260915-work-fd-reserve-unify-folded-v1-47-4d5217d6b246@kernel.org>
References: <20260915-work-fd-reserve-unify-folded-v1-0-4d5217d6b246@kernel.org>
 <20260915-work-fd-reserve-unify-folded-v1-47-4d5217d6b246@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 15 Sep 2026 12:18:30 +0000
Message-Id: <20260915121831.6100B1F00893@smtp.kernel.org>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: BDD171A0006
X-Rspam-User: 
X-Stat-Signature: fsadgoq3ue3rmbrpp41peafd4wr3tk7c
X-HE-Tag: 1789474714-517788
X-HE-Meta: U2FsdGVkX1/VUQ9i1Jl0w0fHHv3cwTuT1yD2PHDOezeoWjhxP7MZLYD4Hpwh6AHKighAD7nXKXGKC8RM2ssfkO7hPIGa3etyQux4RRSiO3i104Et7TOQcLRRk8QNdoO8s0sUtO4pCDe/nV0RJ1sqGR04iW9OR37wPeC83y9kKr82QlP+vH1G4K7Si0ZXfxPxGA3I64WWQ8jAZ7tQE532Cke1Xsl4XlO2aeY00BNEDVX6nIQTuKv8Zb9zFmtffp4l9MByBfXUCplHLDYb5iJTbiHrH5ZpZlIo1iesRNDRz970FCt/bx+LJQnsbQR1HtxTE6WLh/n8bI5jfjn8r/8ybhjgA4Mdl5MMkPic0p64+J7F/DHv1NFqeDArCggQgQOxvUCy/LDnVVGAM1S1MEhOOknsI8pC5jXbuA2vHRVSsOPyahYBAhHox0wuMfSChLx5VZum1ShL/PWPe2W1A7a/NLx36hkPJCxPrEg96ShTH9+K2eNfn4qLivYA9sUlyR9WkmWxvKgM8UNCx/uYt9DFW1LxX734kiR1Nl9wJ4Q1aVialjbHoO9xkfWAkBnl3KvJAxQiAoFZ6dg876IONUDuuLB4RRSLN6iHYIYIyyvI9fIOfrzu3DBB5btPnbgiyqmBEBcnbMOeqMk3WWaqml7cOi4yz8BNFE+C3zJc9DV52QhoGQjdqcmpArvl6xLeN97ESCF0ePERTlwP3V+ZyzkJBbWmTc0/33/UQcxVi5RQYv8C5Bs3l4OyW/DyYqXsrbD6hXLv9w5uWDzyahXxRd0Ue+PMHI5bXp+pW6QBPaWQPGCBHBvPYhvMdStyZSzReYm+MhICE/iYwjPQL2J5VZeJ92q4uMWSnQZRXpwObVT4MVa7bVDBQOQZz/iMF0nh4JSX8G5sW6Lwuf2jS4zQrR1hNxGJAJ1Qs06ygMqez5XYDWEBVaZiENIPlrHoVMM4IJu7TnBrWEnZp9TQQIBJrvP
 xflYP1YT
 xX53+tDo+5Ze6YTUTVUzn5RdyvGBbS85hWT/wmCCfaFae029SjS37MJxVxIsD1h5spVFyUQml2ap+TuRLmSX8dq770n0dg+JYkVWJqvA2LoyY9jnSNLPMao5xfP3WXXKq+1/sxVeT7QeSqQ+CJ1/lCw+2NfQocWa5CffxYKW1GN3ad2wNsX30EALwmCQp+VKD/iw87Wrdt6V4WZ6Cvpd9aGnIXzjI32LarT38UUz1NVQCVJgnWDMLnbJiQ4HXXpNmi/lablraYWzoS3HXo3ir8q7NIuPFcKVYdpXNviy1L/3OvTa0hDuBbITZZojLmmfqowMTQKUOu/RVhDkCYQ5hyQ2dkcby9HWx0LOwgzjEHc+dutsEXZ4qn00EqJd2xf6KA2uGC9T9Jknz2L8SjO0laIIOS3WINNuJ1oZLJooLaQ7eFFnPdQne3c7a+nIFvt2+cjVASmNXqYOdj+fhxsK6VGOvQAwbC5xjNbBXBnXxwgKRu/nd9a2vWvVRfCVANOkNm8389JxoF5i3/PMo7Fj+NRDsqQjrRsJ7EbdTD2ZY7ocY6qTxECmb9/KcTNHhzgFvwHsfEnHkv60cnn5rnClRF0Lt9iaXu/s4ILi+pmQI0a+YdipF+z1nYYADPgp+n4XM+GD8JuWLFaiy0i14Wi/JB9uA4kHBpY4ChJld+HcS/RPeinLfLo6i5WJM5GJwfosuDC+J
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
serve-unify-folded-v1-0-4d5217d6b246@kernel.org?part=3D47


