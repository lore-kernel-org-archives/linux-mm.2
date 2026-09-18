Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD503C982D9
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 10:16:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B0F406B009B; Fri, 18 Sep 2026 06:16:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE67E6B009D; Fri, 18 Sep 2026 06:16:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9FC406B009E; Fri, 18 Sep 2026 06:16:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 79BAB6B009B
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 06:16:48 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5BDD51405F0
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 10:16:47 +0000 (UTC)
X-FDA: 85226479254.21.BC2A9A7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id C4BBE1A0002
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 10:16:45 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=kernel.org header.s=k20260515 header.b=Qh+Pxjuh;
	spf=pass (imf19.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789726605;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UDxOdOM4SxQI/SRvITcvClpR4kJ1LyTAVJnnNy5mOjQ=;
	b=Rny/dJbUJitv7qGCk6tpORJ3JmlxTEcZX79b2riT3RfhRIc2JXSh5cYA4hSyrN6ezXKr+B
	K4zOoshEQPTSCWrxEvOERF4rQwXR2+J9C2R2Bl4NpeKI2cSE2bach3NPIQ4eRttEJK5xCQ
	ek9k1OD9Bzmex+EB1lR5xEXgLzWVPDM=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=kernel.org header.s=k20260515 header.b=Qh+Pxjuh;
	spf=pass (imf19.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789726605;
	b=NG7+hWdkHe/mUJikYCKBfEMWbXd2PUng8q8t9KCjKzfKoN0zAxw+U0P/rQqWvxV/VQQD6q
	EgqdCM2Y3zHAJ7f7hPe93A2P7fDkkUZ7xwldl+YIuId7SyyT1I+/kf/9qCpB7yZZvqe5T5
	uhe1bojqnEBOf8zRHa68dClphD9/aAk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6584A60A5F;
	Fri, 18 Sep 2026 10:16:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D27101F00898;
	Fri, 18 Sep 2026 10:16:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789726605;
	bh=UDxOdOM4SxQI/SRvITcvClpR4kJ1LyTAVJnnNy5mOjQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Qh+PxjuhUYtQuTeeOL6D5uiL1736me4lgCC18Dyr540KpX1gn7g2viekAqDkINVeW
	 V16ZuYKknpyPGGG3APdOEwuMAA9Mi2X01p1YlM68ibSO/A8gHWKdpYguVle1KPxGUW
	 SwSHBlhTwmXypnGgRbnUrfbCkHZj8vLURNJsaxUScCCy2zq0L8WhG7YW/LanxlaQ30
	 Y9ixgrAUskPcxu43UTAsVmm1yKlQoJ86LJsqXWxWO2wBCStypE1LKZLL4qmNA3jhPT
	 N93ecpuLle22qWqJDfk1PgsNhWBnUkKlE/ktYVKnz6zp5EwRIw2pWOt96ZTKfbwF6+
	 Dj/abVCxxaFWA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 02/17] kexec: Record allocated CMA pages to fix
 release size mismatch
Reply-To: sashiko-reviews@lists.linux.dev
To: gregkh@linuxfoundation.org, dakr@kernel.org, maddy@linux.ibm.com,
	mingo@redhat.com, bp@alien8.de, ruanjinjie@huawei.com,
	ardb@kernel.org, robh@kernel.org, vishal.l.verma@intel.com,
	me@linux.beauty, kas@kernel.org, bgwin@google.com,
	linux-kernel@vger.kernel.org, chleroy@kernel.org,
	baoquan.he@linux.dev, rppt@kernel.org, will@kernel.org,
	rafael@kernel.org, lizhengyu3@huawei.com, hpa@zytor.com,
	yeoreum.yun@arm.com, tangyouling@kylinos.cn, graf@amazon.com,
	eric.devolder@oracle.com, sshegde@linux.ibm.com, kernel@xen0n.name,
	loongarch@lists.linux.dev, gshan@redhat.com, thuth@redhat.com,
	linux-mm@kvack.org, sourabhjain@linux.ibm.com,
	hbathini@linux.ibm.com, ritesh.list@gmail.com, mark.rutland@arm.com,
	adityag@linux.ibm.com, guodongtai@kylinos.cn,
	catalin.marinas@arm.com, maqianga@uniontech.com, seanjc@google.com,
	kees@kernel.org, dave.hansen@linux.intel.com, ruirui.yang@linux.dev,
	x86@kernel.org, palmer@rivosinc.com, piliu@redhat.com,
	pratyush@kernel.org, james.morse@arm.com, tglx@kerne.kvack.org,
	l.org@kvack.org, jbouron@amazon.com, zhangtianyang@loongson.cn,
	driver-core@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	chao.gao@intel.com, "Jinjie  Ruan" <ruanjinjie@huawei.com>,
	liukexin@kylinos.cn, linux-fsdevel@vger.kernel.org, blum@kernel.org,
	npiggin@gmail.com, leitao@debian.org, mpe@ellerman.id.au,
	linuxppc-dev@lists.ozlabs.org, pasha.tatashin@soleen.com,
	mclapinski@google.com, chenhuacai@kernel.org, coxu@redhat.com,
	takahiro.akashi@linaro.org, akpm@linux-foundation.org
Cc: kexec@lists.infradead.org
In-Reply-To: <20260918100442.3841135-3-ruanjinjie@huawei.com>
References: <20260918100442.3841135-1-ruanjinjie@huawei.com>
 <20260918100442.3841135-3-ruanjinjie@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 18 Sep 2026 10:16:41 +0000
Message-Id: <20260918101641.D27101F00898@smtp.kernel.org>
X-Rspam-User: 
X-Stat-Signature: 5ia11u1wbxncmkywq1eudwmuuuxm4zpb
X-Rspamd-Queue-Id: C4BBE1A0002
X-Rspamd-Server: rspam07
X-HE-Tag: 1789726605-549427
X-HE-Meta: U2FsdGVkX1+OwW2V2u1irKYfncuquf3uy/3edz01WnxPFNAfhImlNoHJMv6RJSfBhcK4+NkFwvZNqGgGlQi+DNX6lGtz6mLPak37IIe00gTiKIcyqGnlVh5A16VMsDkUdUjOU1SSvx44xpBw/ktFWdWoCp296rvRQZiUyCunttbG+s5UsuNIPSaer2F0ntdeqSOY6DBvm1bcBhbzSF0sRiSZN5vZc6OPhyohtXJKYK3G9goi0BMFZHcRNLgKxV3XBr7qI7T9NdgeHGbv+Pk/k6XL0LWyCBrYwMhHY0te54hJ2NPr73weFJznn3kw36Yf4sgSJcZSL99hxqSvAE9rJ8NSsf7ZP+Zu7ddSWq5ccVpyXtqx0L5VpRQB4NQLyaL9gt6lKvU5CkXKlKclVB1Sd7be/eIWPgUu0lrYBLuLolO9OmN1e+b/1tB8JSELUfOmRsj+cpCkB/cA3LhtteK1AGkvw5h2HmjhR3hUku8aZey7qbgpaU1QaoGH37Kr+RNZzc5/xgIpeAbUcuDwCykkRcbPnX2HVj2u8DXYGrrIgDZXYGmSnYvAlChK/vuWKWT//I+NM2fcpdDXrBdU7UOOk5MPws/HwJwimgEJuz/kfKppC3LdbGitkyaYNSOLRpDDNC+1d5tzxoJaBQnKceIiXwpTiaj7D1r3poLBnUT3SVEP2+WbAnn3BGjlAm1tUz7SbxHKe5WoTL6LMBrGSDjl516ACek4DiuvvimS5EI0gC6gnQyzO4pYet8Um6zg3jFCtGHM5MPX3DDzsJLYEBL1b3RwU9eW97RkP8Bmeuiqu3yHJlsuL2k9G+4gn5FjuezrJBkf8/kGiwlxUx4xL1Rxj7/5vGva0hln/DrgkDQxoLvmkW89+x/DUwa2CPlhtaZNWYR4Y9B9RMRwIA0aKcl8CiuBqZkLBvoDwxOFdCnCOtCnl7YqzZkZT9NmcBXuYlLkqL9Mze79jQv9gRsEL6N
 aHX0tH7c
 TR3YC/U65OyieKvfPeu1iPSVZUHQx4yQN3H08TJWIaI0QnpuWGBTsIGhsjPYXccdQNAFoFEI4RNY0lupeeeFFr6M9dFeHlb1RfGOA1hnho5kOsa7NenEBenNy2VmXKBYnwjiwh6Fl01vKnu+vNcQxtUKrHpw4StVkVFy+Rnu+eIUigoyegT9kbJbdsGwU6cJThmeij5ZVSQHNvgP+uZMt5sokVHMdwLX3mELoruyYEF3V72Y1gryRgel6bZtKAYgXCo4F1GziysZ/qLCJRuHAxFvdsyW1MtN3akJgpLpkxtj1K/k74tc2W/1Et/rYc3Fopy8MdF+mGGK7EyV8AA7SrbUi34GgwosIvnk4Rq5yIMe0e9GNBKZnzZZd61fWUgmo4Y40bVl2lSX16LVeJFGoTmamhlIMaq7Lv39NIklS1Y+ZamEt0T5fW981N7rTrRK6qUrXONxok0qVLewrXcjHZ3n9iW6L1mj4/Nz7bkK+LrrvLKEE4ZuikNYgXYJOaJZfh44nosNMZocVWvVefWCE0wMGfdh9RwDIBeqOZ7AcOaP+zhfZ0WOSWEN1FaO34U9svFDkavrImRNyqFtsgtK/dRwB4UeBB4PhElj4/BipSh8zGiRNqIDJj1EmwIn8zvgudTG8fqld/5GQXmuROzsQQGL7fltzIQKE3+wC+kw7wNM5lY6FD+9UeX2DTro0iBzJzswSMcinUm4IDpQvDnbpjysY1dnigJAvuS+VKCTVFbPGV4eT4exyIUNT3+hGCEILJ/3axQ/AwGmj+hRy4RXenRWs4m2DOcRNVAR1C/SNnQejKFwnd+/PhKQ9bqZwZYc83ykdZlBry1bVcViT/j30WrU/7xWjLIa02uBcem8xg25Oga3ZzeqZLMs3vwHqWhlxiRTuAw5dXFHpdAqEAML1XdHiaXvQFMtpTjCJlBWlXmYaixm2Iz3Sp7MfvcP2ybx0vmJy4bt/XNNSu6CQoVIyZVQ8EW2I
 u/EFk0pj
 +vk6lw8XntzLvLgEpQmndg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> The CMA pages allocated for a kexec segment are released using the
> segment's memsz to calculate the number of pages. However, some
> architecture loaders modify the segment's memsz after allocation
> (e.g. arm64 subtracts text_offset), causing the release function to
> free fewer pages than were originally allocated, leaking the remaining
> CMA pages.
>=20
> Add a per-segment `segment_cma_pages` array to store the number of
> pages actually allocated from CMA. Populate it during
> kexec_add_buffer() using the aligned memsz, and use it in
> kimage_free_cma() to accurately release all allocated pages.
>=20
> This avoids relying on the potentially modified segment->memsz and
> prevents silent CMA memory leaks.
>=20
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Baoquan He <baoquan.he@linux.dev>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
> Cc: Pratyush Yadav <pratyush@kernel.org>
> Cc: Brian Mak <makb@juniper.net>
> Cc: Pingfan Liu <piliu@redhat.com>
> Cc: Sourabh Jain <sourabhjain@linux.ibm.com>
> Cc: Justinien Bouron <jbouron@amazon.com>
> Cc: Li Chen <me@linux.beauty>
> Cc: stable@vger.kernel.org
> Link: https://sashiko.dev/#/patchset/20260729031235.2840255-1-ruanjinjie%=
40huawei.com
> Fixes: 07d24902977e ("kexec: enable CMA based contiguous allocation")
> Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260918100442.3841=
135-1-ruanjinjie@huawei.com?part=3D2


