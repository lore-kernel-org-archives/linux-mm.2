Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 514A9C98302
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 08:59:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 519E26B0095; Tue, 22 Sep 2026 04:59:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F21B6B009D; Tue, 22 Sep 2026 04:59:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BA0D6B00A4; Tue, 22 Sep 2026 04:59:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1DB3B6B0095
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 04:59:56 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8A95CC0403
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 08:59:55 +0000 (UTC)
X-FDA: 85240800750.26.CE08AF7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id F1330160004
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 08:59:53 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=izvJYf3w;
	spf=pass (imf08.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790067594;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+cpSLdx5G86GAiYEa1KiKUdyGr9Hwx+hUdwakbZPe5c=;
	b=Vbn1SFPmd26f2GO1goNbnIxIl9tSUU2eCO4+/AH5CtyWCPMaO5ek/8g8cq8o5PszFehBDI
	OLssik6tGzC19OqTcmE7k147lwzq6uQJCRHLUiZiGt0UO9R5PgQyk0Ecs+Ao7V8/jihhkb
	6BgXbUfSvAauNCWkmp7tEcAeSZu0uTA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790067594;
	b=P3NtJe2Tf6AXqX5Q1+6DTC36Y/KGkM/ayXsiN8KLaVixz4i+vprvmFqeiq6X2kAeiJNGjc
	KVSrhazXUHde+RwnVkAyswOnNQ7IUGInseUUqTdG9ssnXtGcylXUpwJ5U/klwmvjSmk8Jr
	hSFDNkM7nBkvowcxnajz0KTOApSdPVc=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=izvJYf3w;
	spf=pass (imf08.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 729CE60200;
	Tue, 22 Sep 2026 08:59:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAB051F000FF;
	Tue, 22 Sep 2026 08:59:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790067593;
	bh=+cpSLdx5G86GAiYEa1KiKUdyGr9Hwx+hUdwakbZPe5c=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=izvJYf3wx7OMx8dtyK2bPgV4goHzPpSwGkfqbgOp88Z2f384iep3os6cqHBe6ioCo
	 IipTl+Y06tX741Ho3LXMdE8qTZBy6i3kW/AG2fyAak47hFXgIbhMztEc/AjEfWJ3gO
	 tR/TutUOUAWlWalvbKQpWlAlEN8YL3e5y5N7pjthg/ab5xsU3bbMXVoOIgsjkQruj1
	 OyekninqCRr4y32dIPdT5Bd+44BDIJNM8eGAdEaSR4P5Xn3uC66ReBLFcE1ilJjyVa
	 Vp4PDuJDDdxPnmrmh8vGIIpx5tDJkTvYEYN2OU5Kmw3iEXQ1oXLsmHDVUD/8g0E2hX
	 zd2wbQtt6yspg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v7 1/9] riscv: build crash_mem ranges from memblock
 instead of resource tree
Reply-To: sashiko-reviews@lists.linux.dev
To: robh@kernel.org, rppt@kernel.org, "Wandun Chen" <chenwandun1@gmail.com>, baoquan.he@linux.dev, m.szyprowski@samsung.com
Cc: pasha.tatashin@soleen.com, aou@eecs.berkeley.edu, linux-mm@kvack.org, conor+dt@kernel.org, mark.rutland@arm.com, dave.hansen@linux.intel.com, devicetree@vger.kernel.org, bp@alien8.de, catalin.marinas@arm.com, mingo@redhat.com, ruirui.yang@linux.dev, iommu@lists.linux.dev, kexec@lists.infradead.org, saravanak@kernel.org, pjw@kernel.org, linux-kernel@vger.kernel.org, hpa@zytor.com, alex@ghiti.fr, chenhuacai@kernel.org, x86@kernel.org, akpm@linux-foundation.org, robin.murphy@arm.com, loongarch@lists.linux.dev, linux-arm-kernel@lists.infradead.org, linux-riscv@lists.infradead.org, kernel@xen0n.name, will@kernel.org, palmer@dabbelt.com, pratyush@kernel.org, tglx@kernel.org
In-Reply-To: <20260922084256.1515554-2-chenwandun1@gmail.com>
References: <20260922084256.1515554-1-chenwandun1@gmail.com>
 <20260922084256.1515554-2-chenwandun1@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 22 Sep 2026 08:59:51 +0000
Message-Id: <20260922085951.DAB051F000FF@smtp.kernel.org>
X-Stat-Signature: h3wxz9xunnoew35x88t9u4b6j4rb4ofm
X-Rspam-User: 
X-Rspamd-Queue-Id: F1330160004
X-Rspamd-Server: rspam03
X-HE-Tag: 1790067593-965370
X-HE-Meta: U2FsdGVkX1+VgOmzcqwMUCgnfWEYUhxouL+5RY5Cnn/AQfW1h757tePcgkAWsYQbrPD3gOWt2c2QGCnC+GfF5csWV3WYbQ/2VJNOEb98qTWNlmSBZ51ZjauCw5XT6gX1L1/RLqObr/8UsdEhUNqy02hWFCxFKWdrrNq2me4ohIY+2MM8BbmOiUgi8LDSSYBC8/xqxRvxnrk9LLgWY0aLHexcm3dsZZ7WrjVnXuodshyiwAwi7v2RxKpteMowjtPP8EcNkCN4KUfdxoq5Pi0GIHHQcJ/u2wQffkd0gS3CCEbU40Uy7ZAPvfBB9P3Tx6AAKea4pEr5aZ7uvPPT/hHPHK5FuvnDsrf27vsDyvoeOoxFIfVrOjPAQXtpbnu2GoVW9bXJK1P+Q5/saS3sL1QNJgWGAeM7pGOlEgA2p6z/gk10reCSY4bbaAr31CICCSWXblw6H0IbjuKwXY37/+VydbkTYpTi6T0XWfYPVQWHdjBNXUG9azkoSaOtTv6VKW2y1iuFNtxKa3k0pR+DoxNJmZPA/w/PrbxUas8f/j2PcXeczog9x36+Ys+zEapBXvwLQT1ZzxJITE+E+yGFSnGoEbQgd/JYVHM23340+flH+DQf05ojB1pgAGeR1Ffw3YkLRdAADK86oZ35swValZt+tksLGi/MI2Q8uuGrJJ90+Q9ThUONJLct7B2ZmyEf+Qh3LVl+R6g4jOsF/yEyQ/f8+ZfQF4IWUYuvuGYe/ph/fp6fCyoAtB5SlCQFQFJrIY2rR7i2zfFUkdnydNloCjbi7lR/0kCrHcMSpDT6VMGan2OBAz61hgUDG99DgCKFP2Q+2BSVFAxDngFVuYBkpxbbFomS14fAxjgrri37Htq4xypsfHAZ+bVIFKu94+zsStsYw36Q8J/xODKoIZoyHC0G98tBQ+rWvT21xnwwKlZb345gZ9jAjYBunTYyPpTb7Ij29J72FnX/lFiC8vwuEoJ
 tJI9JWXU
 /x8hFa/K+I4YJ7q+jPpPJzw6rOBKrNQwe7BiUPNUkdAB31DUGrkZMie0+UojS9O8M5T8UhQ4Z6KVueEHt5ICmmnA7HTR/Ti/+Z9CROeK1tv7XHO/Z68Ud8Xe0N2y6M8+XD75b55bk3KNCsmSTX2cgsO4MD6X9FOopCp2Mizx4zTasSvgD1BQi6FDf7l1fzgt5ouysI6N8wYhtLGxQEs6W1I0yted0B9IkAprd0TE8du7ZB54n0g7BN5YItYS6eZFQDRR4lbNm4gF7NhZzu1aYfAIRNfz++pFv0Ec2ljYAVYbonp/WtX2Ilsx/eNovuteZSbj/eAq4FmJlG1PkQQH5uUusysSmUvwiilLmrtMxqCtCsm8aLw9VQwc7Jau6WKKMHl3fIPmuhqgSu7VL+VsPky70q5FHtuNUZAVo/kDkS7OyPhXuhTrcesBFh8l1mHI79KzyJ6E+74GFLSHZ6rZfG928JO8RevSnDJjlsAapBCDpcMAjLSJ9NJBWxWc+JUygnI7qJI0YWLjrG1nR7ddFRmkrF+mIDSfu8qcqhDptT9Z4ZRNQIV2OAcLUhf2TeaMo6dAXx5aqCppXwtfkmHOh6FHawI2xr8YJeu2G8tmifhYANOYKiCfk7T7QAgQ9xoI1NTY4wPgVH0HstE58wIqnmGdBOfhXUfdx9yqImYu/9I9Nr6+DoFGFShNJ7GEbB9Hvk3AW2j6ZQEVgRuhPhDE2NRDAsOOvZJrR2jAnfzs8A8EoB0vSX8xqqe1hZziq3IwIMsiommOVbrUx9mIKsDF6liYiOGNJLlvcYbItZPwNCpa95DKR1Zw0D3fd6w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> From: Wandun Chen <chenwandun@lixiang.com>
>=20
> Replace walk_system_ram_res() with for_each_mem_range(). A later patch
> introduces MEMBLOCK_NODUMP in memblock, the reserved-memory regions
> marked with MEMBLOCK_NODUMP can be excluded from the vmcore by walking
> memblock.
>=20
> for_each_mem_range() iterates memblock.memory, which is freed after
> init unless ARCH_KEEP_MEMBLOCK is selected. riscv needs ARCH_KEEP_MEMBLOCK
> to filter reserved memory from the vmcore, so extend its condition
> (ACPI || KEXEC) with CRASH_DUMP. arm64 and loongarch already select
> ARCH_KEEP_MEMBLOCK unconditionally.
>=20
> Signed-off-by: Wandun Chen <chenwandun@lixiang.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260922084256.1515=
554-1-chenwandun1@gmail.com?part=3D1


