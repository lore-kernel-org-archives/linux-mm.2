Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62FE3C982C4
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 12:13:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B8A86B00A0; Tue, 15 Sep 2026 08:13:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 689286B00A1; Tue, 15 Sep 2026 08:13:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C7046B00A2; Tue, 15 Sep 2026 08:13:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 32F616B00A0
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 08:13:14 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7E26B1A0397
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 12:13:13 +0000 (UTC)
X-FDA: 85215886266.07.C2BE07D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id E13D540012
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 12:13:11 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mxoLtCbZ;
	spf=pass (imf07.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789474391;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rcP1Zt+r+c8i7P9HMLnfG+KSwnTlxlPDfufoMKFt0yM=;
	b=xlW9XW8mzXmjulFEF4rP6YhrIGJHeba6VodaLRYaPOOcg4V+igSgnxkhNu3y0znIoeEjWR
	njszLF3ID4VfF8alwfQNw/1L4uylQaOvOqgxbA0l2WcEUdn+KfmNwlDPamXCVLpWrL2emm
	ZsJ/BItufL8cwo6YSnvKodUFX7e+kJM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789474391;
	b=T/t/oS9uduo6eVBeHdtdOhuJZY2115CH1oRtMmDeMEBBvHBEF9+CIhWEWVlz8v13jioNwM
	w9mHBmi4/oZ2t+mmnvTLnnHfWOvUbVve4yTIXvM39FUyiERpL2vVER0TIjGoZ+Q2u3pDWg
	6/TsucdgxsA3TpkwhoTh1xTVmTLJ4Io=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mxoLtCbZ;
	spf=pass (imf07.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 86C3F60261;
	Tue, 15 Sep 2026 12:13:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CCF61F000FF;
	Tue, 15 Sep 2026 12:13:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789474391;
	bh=rcP1Zt+r+c8i7P9HMLnfG+KSwnTlxlPDfufoMKFt0yM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=mxoLtCbZ5g8NJT38V2nXx3kQMXq8zz7wa261boot03y/1mmOb8uEpnb4HgvVzXqbE
	 Lc+BLr2MEwB+7zjlCcD9Q9qeYqKVACCOsKFW9yMVpHmTXMqtHVkiNOOQlElz6DH2cL
	 qfBphOZ3delbUDrFqm1dV52+sHB7JppWyVGvQVAhcP+Vcr7mTyrRaVGoKVuRlWxgrA
	 a0ZQjTcB9Fxaqpd6c2a/Z1vb/mAmnfz0/bCd8zDO3h3sznLEIo6QHFgrENGMHDk9qf
	 flDXJ4YX6mmlM4kAG/dg8PRmGwgcbH40eS5i4n9wiRd9k9l8mEd5AlXPVBescbcVDo
	 rqQ5leD9k9+dQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC POC 36/50] nitro_enclaves: install the enclave
 descriptor when the ioctl returns
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>, "Linus Torvalds" <torvalds@linux-foundation.org>
Cc: linux-hexagon@vger.kernel.org, io-uring@vger.kernel.org, linux-hyperv@vger.kernel.org, dri-devel@lists.freedesktop.org,
 =?utf-8?b?Q2hyaXN0aWFuIEJyYXVuZXIgKEFtdXRhYmxlKQ==?= <brauner@kernel.org>, "Oleg
 Nesterov" <oleg@redhat.com>, linux-fsdevel@vger.kernel.org, linux-openrisc@vger.kernel.org, "Jens
 Axboe" <axboe@kernel.dk>, linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org, "David
 Airlie" <airlied@redhat.com>, "Jann Horn" <jannh@google.com>, linux-gpio@vger.kernel.org, sparclinux@vger.kernel.org, "Jan
 Kara" <jack@suse.cz>, "Eugenio Perez" <eperezma@redhat.com>, linux-alpha@vger.kernel.org, "Peter
 Zijlstra" <peterz@infradead.org>, linux-sh@vger.kernel.org, linux-parisc@vger.kernel.org, kexec@lists.infradead.org, linux-mm@kvack.org, "Ingo
 Molnar" <mingo@redhat.com>, linux-um@lists.infradead.org, "Michael S.
 Tsirkin" <mst@redhat.com>, "Alexander Viro" <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org, linux-csky@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, bpf@vger.kernel.org, linux-arm-msm@vger.kernel.org, virtualization@lists.linux.dev, linux-m68k@lists.linux-m68k.org, linux-snps-arc@lists.infradead.org
In-Reply-To: <20260915-work-fd-reserve-unify-folded-v1-36-4d5217d6b246@kernel.org>
References: <20260915-work-fd-reserve-unify-folded-v1-0-4d5217d6b246@kernel.org>
 <20260915-work-fd-reserve-unify-folded-v1-36-4d5217d6b246@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 15 Sep 2026 12:13:09 +0000
Message-Id: <20260915121309.7CCF61F000FF@smtp.kernel.org>
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 1sqfqudkfkx9jzggw3cb7t77jyzuuk6z
X-Rspamd-Queue-Id: E13D540012
X-HE-Tag: 1789474391-431994
X-HE-Meta: U2FsdGVkX19g2l/E3aBHl3T+hAg6nwzgfJZ4FkarQG4rOjFrllFP8IC6I0yxvqUKQj3L3v7ZYxIvm2E+EnGbIkLnkqU/3qsTudO6YtNwo7bOG0YyMowzzbtmNUur9bQtuBl4SOMR485grvw1/o6fwokx6sIiDaDWEha2A5vh5dBykngkf39FZOYmBHcwU1j8+U84VXkfhlw/iX/A70jZi/XIbHcXdoClQ/9V9AndoQil8y0jolLX3S6LoSqcbz1+BtVykGreMNooAQ1w+c5ukbiAL3WBaMczsSz0AEySzE+F5vw4jguMHWASEPGB4BFDsQTRx2TLjyu/Atb7myl8ZMVGJCyzTSPevxNiSiw5p0GNR0Zr9qjHlwH/QozNWmdcC3qE5YPmbcF2LSd/phqAz9UcB+Ps4EbOg43e3ZXgA0GgWZcctIf4aiVJhZ7ve1RNFGRCowavoZ0LxfRPTCjWstPlWPHtE0AHeXSSWEddcde9x4JtOKh35WvqXbbEhsYhfIUvJLPGNm535hVrTdQ7wZje2vJf5fW4e118AydjHN4VKx+rf5O8VAavhzqcQEfEDfg8j4dQxnJKC/bT3RiACTLuYNGyEwIPZkI1t96W5WFAaAWAzMGGSafNk0rni5CYGq6UuT4Ky7hVO1rUvNbSWIyrENg1Yosx3nRUKvtLmOXU43Za8oadDh+msGKeinlqIddUZ17b+8srJmQHeRFTyWOfgqbxHc37V46RaJN5TAanAccuuLAJuWNLRbMoiMHZbvWQ1HYFWalWnzXMUwY7xO14G/9BjivjITZOw0OOuV+U2+HMuHVWaydY296ls05F9u/OlK4pYIT2Zugu0d+mubyV8alXmylVtQP7TWatIZFy4MNiL5ne2odwUHzMEKYXlJ5/dftCfkkW2+IyvvffMmOHSHyYPe8S7uSBC54170/S5Vz61y2VuyE3KoQYMIulYMjlgbmUKamZNamRfhH
 m2TIoBxq
 6OBXgHPkDc5Zhj5wsXyGQ1zvuYKAz1AguP170Qjy3UH6E/QFPHwvWpIJBDo2NYzg2h/vJDyveWi9rE4KC8KhVPaq3UKb59NlM8qFOju4tR+lIeLt9PW6wBKdFi67oGhNTHu/hXl26zblPNHT8wfK4+RMle/QUpOaagg+m76iObgetWc3MZgoGgXTe0RJ1ql/MMiRmO2nBRBPXug2LGKwHoI6ZwwDF9f8kULGYGwJYRwHvlLQyyx2DXM/Lxc6x9QTHBE/hCYQHte1xhdCB7rhN0KgGE0Oe3yGtOgv737iwXx0aWCZdFHS+CXb39GxJ5MALKWfAEwqtXBKk7XUlCOMpXGmEm51HVtO5qtdH7r0gGdBrAAIPI8VQYkSYKj/4c0nx8uDBCB7QFoWTn6c7rO9S87CP7xsK680Z4Ih+S12Zb7l/txD/ZBEklF8yriTyQiXXnYYNOgtFWseMk4HASYg3vrlT2C/Z7yRM4V7g9PUOXfz0HKkDdjw1/Kc8jAzpS5zOyfzZGOB7phCTki9HyPc1bO4IChXlbBN9jK9jNkI2KkmiRJeFNBPS33t1eOFUqqNXlnIhbvwtFIpSEACw51pzV50kVSBe+KyDgVvRL469O/DSEvN/I6PUOASnoHPW9nTBfdL+ZqWHC8sU3nLVECUPnkxdaXigJBIBkCLGPPlf9VKoULiW8P/sEMzP3FuXsK7CHbzeYHnCfgVqdfp6qbSlbfEEZ+id/5ChcABIYeBMRS77usCjPWHTgGXhRA==
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
serve-unify-folded-v1-0-4d5217d6b246@kernel.org?part=3D36


