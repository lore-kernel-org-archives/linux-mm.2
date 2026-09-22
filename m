Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83438C98302
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 08:57:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 848686B00B4; Tue, 22 Sep 2026 04:57:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8201C6B00B5; Tue, 22 Sep 2026 04:57:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 75D466B00B6; Tue, 22 Sep 2026 04:57:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5A39D6B00B4
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 04:57:02 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DBC6C160406
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 08:57:01 +0000 (UTC)
X-FDA: 85240793442.03.079A5EE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 5830C40003
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 08:57:00 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MNL3Xnb6;
	spf=pass (imf12.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790067420;
	b=49IxuiTMiaisBXwDHYOr8jMwFwfgh0CjEQykXSuBOCikZwiVucptpzPNSitzDlAKHPjQhD
	BkABqZ+/nUi6gzKxFSX4axsX9Dipy2/iPocBMOiLc+FutsBco+bbDr0UucH33kKstm5ohj
	4Pjf09ltugKi2DaOQ2uWN9S2qCNTVn8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MNL3Xnb6;
	spf=pass (imf12.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790067420;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mB6ArwwQWi63lnnyZnmc+lp1xXlr6Q+TPr+ON6lhHYw=;
	b=To2nGUazMGu9fUvt1DXwLUxwVGGVKhgPBXQHmdFG2jOefLOsnBFnP1M9Zx8/MsVdtPBjXz
	Ozmg8lvFoGbClfP/HTNj5ZIMuacCfB2SUAfgCy/13KwpFOGpdMCEeUO2sfSO5FV/CmnMl3
	G7DJQKoIJo6aDsOWUh6VTHIWmup1DrM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EE3FF60200;
	Tue, 22 Sep 2026 08:56:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D2B61F000FF;
	Tue, 22 Sep 2026 08:56:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790067419;
	bh=mB6ArwwQWi63lnnyZnmc+lp1xXlr6Q+TPr+ON6lhHYw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=MNL3Xnb6CWnvvGBDK0J3Mn0L4qOeZ5nvv4L3x8jvkBkxrp+xGTSpgMrYwk4JgC2qV
	 9snp/rxfK9DTTpliyaHgkmJRoQKO6yZng3MZ6TCOmCZ58SkJbHD1AciwzYV1jmDP9T
	 weoFRPO5s+q4kbuS/2JkjIJQyufgbbc2Rqghndy+dE0HSygszhyyhX8NNsmW9OjjAj
	 q+tsmsriKvocNa9XHt90euPbTjKxci4T0s7RA5tQyjpgnP73fjR4Hujl2c4Pj+FV14
	 8I9/nRiLjvKtECSEKKdVfBZYG4utyvcEnX34gjuFlutbaLSf/Zs2/9fYZO95zimVOh
	 hT83kc73npLCw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v7 4/9] crash_core: replace for_each_mem_range() with
 for_each_mem_region()
Reply-To: sashiko-reviews@lists.linux.dev
To: robh@kernel.org, "Wandun Chen" <chenwandun1@gmail.com>, rppt@kernel.org, baoquan.he@linux.dev, m.szyprowski@samsung.com
Cc: linux-kernel@vger.kernel.org, ruirui.yang@linux.dev, loongarch@lists.linux.dev, tglx@kernel.org, mingo@redhat.com, saravanak@kernel.org, iommu@lists.linux.dev, pratyush@kernel.org, conor+dt@kernel.org, dave.hansen@linux.intel.com, chenhuacai@kernel.org, aou@eecs.berkeley.edu, pjw@kernel.org, linux-arm-kernel@lists.infradead.org, pasha.tatashin@soleen.com, x86@kernel.org, akpm@linux-foundation.org, linux-riscv@lists.infradead.org, kexec@lists.infradead.org, hpa@zytor.com, palmer@dabbelt.com, alex@ghiti.fr, mark.rutland@arm.com, will@kernel.org, kernel@xen0n.name, catalin.marinas@arm.com, bp@alien8.de, robin.murphy@arm.com, linux-mm@kvack.org, devicetree@vger.kernel.org
In-Reply-To: <20260922084256.1515554-5-chenwandun1@gmail.com>
References: <20260922084256.1515554-1-chenwandun1@gmail.com>
 <20260922084256.1515554-5-chenwandun1@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 22 Sep 2026 08:56:58 +0000
Message-Id: <20260922085658.6D2B61F000FF@smtp.kernel.org>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 5830C40003
X-Rspam-User: 
X-Stat-Signature: wcznmpq1ikmt7jrs3ty9wgmh7a5tt1wj
X-HE-Tag: 1790067420-778131
X-HE-Meta: U2FsdGVkX1++ePAucdXtpS3/1icwfwK7IuBSGF4WJijzZkCwCii4CbFs4ojCphDeeoQuxyBGGEvrWNC7nFGsbczxnXSgQVT20eJyI5R3uKvGJe/oYHhL6XxTQauR9LwYjvXMVBO1vZ9m7Z0ktx0AaZBjaa/RnORGc9O7zjd2ZqrPlHKllq1zDvM8mLtq1Hh3fqwpWjdQIcrXXlSrHSRmiVZYWn812RU/5U+/m2MSKIOExUPJGz5LrpQo8LkB1P7QDM1xidXXilw1i93z5XUPep00kkCWGXXk2GY8jzDIx6TdLuVY3mrCrCdUufTBIQfD70qibS8m8gwH19rEUr2w8Q3rtEpo+29Fmvya6xZghNe32gaDNyoLz1FSJoHI4L8AOoB1ozPRqZtDwMGADJ2FssZ/Yevcu4nfNOafrAozY/6HF/BCnfK9AAGqQw1IRtFRX5bR7CtgJMf5GdSuJhCl565DldNCQPMRmcV6Y1mH/ywCV05SyUrTQw1zOK554a/kOmMyZhzNdxuq46AVJcq1RqLMp9Bz3YfCLy/zDoocP4Dj98mJ3aNOAs18UkFeTiiX8Hceu/Mpl+886WQS9Pi5rNijXSxl2zk7iN3eJ5SKyU4WrShGVZ+N0Gu5r+cVLmCID8VtJ4D2wtsp6EhlNQjenJZ3RI/zPv2+9dlIy8Xdkh0AATLb2ljFtIic4SAkUciEUWM/UR4ALItoRq9ZiimqpotlRabubLP392ZU9JppxlabWGjbOx7b2Hr9QTqrskVx2pTyvqTBf7HU6IS23D3PisyjW96XnvIBUJAh0yu001deGy/Ug3pQsSLhLokZAiv66YuVn+PpBGjrHDbi8UhtXZxZujZbDXkaALlyZdP25iyiqaZ9AaHWKDOZKo3ivg41E5cQyeq2/SomY54odl4UXjy+mtIbElszzgZA/NZaIZTLP7u821Ajsyw/ywKrVizHllUnSXbt9FSvsLVeaEQ
 uy1Ncl87
 3wcYkxfQEFwQQlURwDPWLT6vP5htCnvwu7p4YcsuIK1uqWXUGmkF2lzD5TTRIkm5P8kLIxDC8Kw/O7z22Xk8y/vucSzjp+vGfnISxbMDYHoBKiIP5Cq9mnq4gpjl1vLIi+/2g7nNe72ieQJixq/pKf2NpFQ6At3XnrBSC0fTJSYD8YNJU0X47nFsS68Sc5LfFmSL6ulHt+C+ZF5Q+5RtB+PFdItW3VAgaPYTJ6W18Nz3noZlmK1DUrIXXvOUPAnl8aI9Y3FnDvK96pZTTMUHYiZWNBZ7TbeLUYi68o1tO7Po17WQoRKZOUBSlnyagT7SDcdSS3KnglJVijWVXxsX5iJgEYkp6ssMZ02OlwINwNPkTkJzrutMYLswyjJZXT1PNbyrueyzfjraQsdiz3d5AIJPjjxfa8YCGfu1Jyfwq9+Ctdg5ZFdkVBlmWLd3VFe6fNMeTkjTBRJlBIa7edNPCL8pS89ulLSBC3PTQc2vqPm5u5/GD1YHdccb9G/SIYeRWL8IUMShqt0dik9femeyB1GvpfLWv0CzcWi9lak1FNvT9W2X9GfRabECZkC4hJw3XFXhkVamx6FwtHGEfyulhNno0GP3oCOsphFDlY/q7gYpuOq5hNMxZBsQKt6M3F6X3h2lpIlKdxT+NQ/TYC66VO5FE+GHugfsG0+3BrfFJJl8lIrG+1jI6NimeUqQNdxl5TuFfL5UjDqgtfSjZznMVxHgIj4Pm4p6iC7fHlu01YE6hhD0Qh6nNDAFeH06Ooy4LYIXGRF2/6CPOGuzcz//gGNvXJkDXQPjUfwyfGeCCjxr7svY4ClRKHyVO2g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> From: Wandun Chen <chenwandun@lixiang.com>
>=20
> for_each_mem_range() skips MEMBLOCK_NOMAP regions implicitly. Switch the
> weak defaults to for_each_mem_region(), which exposes struct
> memblock_region and per-region flags, and filter NOMAP regions explicitly
> via the new crash_should_skip_region() helper. This prepares for a
> subsequent patch to extend the skip filter.
>=20
> No functional change.
>=20
> Signed-off-by: Wandun Chen <chenwandun@lixiang.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260922084256.1515=
554-1-chenwandun1@gmail.com?part=3D4


