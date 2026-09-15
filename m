Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E44EC982C3
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 12:04:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3BC326B0098; Tue, 15 Sep 2026 08:04:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3934D6B009B; Tue, 15 Sep 2026 08:04:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D1B06B009F; Tue, 15 Sep 2026 08:04:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 11D4F6B0098
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 08:04:40 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 90766C0405
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 12:04:39 +0000 (UTC)
X-FDA: 85215864678.16.CEF8FFA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id DEC6BC0010
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 12:04:37 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cuq2lBlL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789473877;
	b=msidO41VNoTkog/cn5W2TQovmrfh9hvrEEb9D5H3h0WCdOmLEroQZV620u+czk4nVla4eU
	MMPkYc30r22AytpzbBB3lycRFyT3oo2ynipS+tnYgfhs2O3Nc5BbH2SafcQd25nIwuf84t
	Ou1FGRp8RIxt9zWFftHE8sEjAxd7vX0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cuq2lBlL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789473877;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J5fP9X9CyVcuvKEYfpMseQ+In05Wp0Z5tRJ1lE5PSRA=;
	b=3CO2Q3YXUTamtsFUL09FmyXgPfvtviYYbhNp8SjKog06HoKK6JBOh5QhJ9Xavak/SX4JTE
	yGZID9N390P2oyIthwUW7Mqd03FXJ/+FQi0sWB4rDy6jEfcyJ5sZwCxraki+mhigdYA/oC
	/LMsreKO8BvZbPEQeAjWLam02ajFO+g=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B3B4360261;
	Tue, 15 Sep 2026 12:04:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28E9A1F000FF;
	Tue, 15 Sep 2026 12:04:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789473876;
	bh=J5fP9X9CyVcuvKEYfpMseQ+In05Wp0Z5tRJ1lE5PSRA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=cuq2lBlLoUw0Y72t9bFSWoR4MpMhbFj50xeEgbG3mMkdmknSMptpwSK3xFErl6Es+
	 ul9rPuaoVaEF1rSc09McY1HCQ8/KvrsXmDJngtm2g8pGOkK8SksKn5c2XZu2qd6neC
	 /n8PpaNv6M0cIf41/P5ePeN8jF4tTMI4A5SgldO4z9TVfn+pUHuseWjwq3FPjMZVL+
	 /A1Dp6mNtF0UCTI50gLLUPpKDrqKyRhLmvgM/WajGKJ4JWHsivD3qdtc0trmEiG9AU
	 uvPQ8IW2ncEh1yY23HCpFM+zP/B5XadcfTF+40CtiH7dhqHPX0XUxaPv0A3g/x9nid
	 zNRhKlOBXH0Kg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC POC 28/50] drm/msm: install the out-fence descriptor
 when the ioctl returns
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>, "Linus Torvalds" <torvalds@linux-foundation.org>
Cc: kexec@lists.infradead.org, io-uring@vger.kernel.org, "Peter Zijlstra" <peterz@infradead.org>, "Jan
 Kara" <jack@suse.cz>, linux-hexagon@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>, virtualization@lists.linux.dev, linux-mm@kvack.org, linux-csky@vger.kernel.org, linux-um@lists.infradead.org, "Ingo
 Molnar" <mingo@redhat.com>, linux-gpio@vger.kernel.org, "Oleg Nesterov" <oleg@redhat.com>, linux-arm-msm@vger.kernel.org, "Jann
 Horn" <jannh@google.com>, dri-devel@lists.freedesktop.org, linuxppc-dev@lists.ozlabs.org, bpf@vger.kernel.org, linux-hyperv@vger.kernel.org, "Alexander
 Viro" <viro@zeniv.linux.org.uk>, linux-alpha@vger.kernel.org, linux-mips@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-parisc@vger.kernel.org, kvm@vger.kernel.org, "David
 Airlie" <airlied@redhat.com>, linux-m68k@lists.linux-m68k.org, linux-sh@vger.kernel.org, sparclinux@vger.kernel.org, linux-fsdevel@vger.kernel.org, "Eugenio
 Perez" <eperezma@redhat.com>, "Jens Axboe" <axboe@kernel.dk>, linux-snps-arc@lists.infradead.org, linux-openrisc@vger.kernel.org, linux-kernel@vger.kernel.org,
 =?utf-8?b?Q2hyaXN0aWFuIEJyYXVuZXIgKEFtdXRhYmxlKQ==?= <brauner@kernel.org>
In-Reply-To: <20260915-work-fd-reserve-unify-folded-v1-28-4d5217d6b246@kernel.org>
References: <20260915-work-fd-reserve-unify-folded-v1-0-4d5217d6b246@kernel.org>
 <20260915-work-fd-reserve-unify-folded-v1-28-4d5217d6b246@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 15 Sep 2026 12:04:34 +0000
Message-Id: <20260915120435.28E9A1F000FF@smtp.kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: DEC6BC0010
X-Stat-Signature: brgu8736cprkamr5n6saie3pzikcfipj
X-HE-Tag: 1789473877-451825
X-HE-Meta: U2FsdGVkX1/Rg7GZO32nk9WDVuLA18GA08VhytwLm7XtTO2rEAgXR0dk8/EUUvZScvQM7hNJbvOz08vMs+f52TKgnJTA2H5k4Ed5ecdv/CHnsKa0rtwWhZ8AfvHJ4jyPP/K/Y0fsBXAo/RPAI9SwZNU4JVepviYlqLNNAsVrnG5RcxfDbDkhZwxL+t0oCMXuPvTOgbMc25hJShs/ZgNig+TJTh4k7PadpAs31Cv19ypUKzdH4nQoWD8pEBaL/V/Hlp6Cj5u/UAnArm8Yw57Zhe9ThhwAe8TcPzi7nqjKh44MKgbOZG+T+R9TUql/jCm8GOi8y5Z/yGSIERL9yrIckXEfyH6uhcVhoatvrxDkSXfoHDsOQFQWnmV8zigFx/1GAA9tlv6kRXv8P43W4efklfjiH0Iik2E6uU34KoAAILQk7Ftx9mzn+ilkc7jNZFivu31QUbXcFjn0JkG3M0Fam1j4bSfUZzmsmgjqysL0dEPFCVL7OALn5MqH9BPtj0LSxOPBrNbCFhCKCciViUeqdXUOEWjSrZowbubxow7ne2vuxOcwbUFK/9ua3hReQSf682vdGtl9qm2RzQ8gs2FCmmojBVEpmDcd1LafNpyYX5fCkziJsh+6V38UewoFRSlXihQihKyQhxjXTBQIIC05Fn/lKFJzvJQ1tgnQ9oHpgPc9NGbN7GDh3a5NR3PztIEYJnVETKK8Z4b8ddYspGux/LOwAhVF+hhNaB44Jf1/Bqm+fAJ6DSFzHQG83VKxyABJTZJwF/zhPxLBp9uCuyKYZi2AIjj3knxtjcMGu1LvueHsIjIQpADu6+QZzHyfEmv9KbdSTIntsYXKuBFT5DYsM7tNNV4iqy9oiYV7vO4SvH9axGbnnKAk+2KqYIgHefdy3GKPiexICx6GnVQEv3uNipno2w2+fC7yI/r161g3sl1wYcZmYXIhVZO/K227NFnbONi+6Cwb7YgwZN+Ukmf
 20hUap+f
 aHvfvto0gDynW2Y5/NoiH+V9fBmO/KNsJsH3MmRHE0HSPYc/fRGol5FQlWIr0aQ5IVUKMXDOraf230gxnSzV8glS3uJDXQG+1lod4JfYMigxRknBFfM0PavwnJl5YVTS8nhZf53Y8iv2KNKC4RWv4N6tt3GpquAShVKL3iQ+OZQqhzPvFaye5a6FrXRI34QvyK61s3vZl3HUbb7ZYp7ZyYKBljemrkuh7XylNqpzQwZRq3mON++HbeaFNSvoUOq7GErFWWSXnNSzT2FqDWzbuTiZfDKAIfOUyiVJfJKPUqjkVRuaBXMi2TuG9Zrai8Z6leffPZH2tXDE5cmg7u8i1YCY34aknWBCCL1HUjquo2pWrXjQnpF+xXFE855udf90W1yU6s7oLiFFUbZ5aiPWetBuzwWfQ7eEG0kOnrJ5eKbhIAIJ5bLLxnREgCHoP2RAGQLN63AHGiw8wnOwgQiUbH9W2RzarOY8vKNynAyG2wkTkDQ4D7lDKjN4gqh2NATRolGruFnt0tQx59hRRAYcI+2iCe/rE9amoVurH49o5sNRfCqJpgc+L9vFXse+eYeVEk/VCdtWX/0fPoJ3ic2hgmML6fTLj/cnbb/g3nbV5soHU5zXlW2TpgMqjunBHOagQWg9awGRuDHbT4WTnkU+MKK3YLvT46xMkjbiJHq/ZZZzpKB1/q16QK7xRb2/D/MD+YYSg
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
serve-unify-folded-v1-0-4d5217d6b246@kernel.org?part=3D28


