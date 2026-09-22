Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F263EC98302
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 08:54:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C89DC6B00A0; Tue, 22 Sep 2026 04:54:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C611E6B00A1; Tue, 22 Sep 2026 04:54:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B77D96B00A5; Tue, 22 Sep 2026 04:54:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 970DD6B00A0
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 04:54:13 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 19295A5C9B
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 08:54:13 +0000 (UTC)
X-FDA: 85240786386.01.DE3376C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 8F220A0004
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 08:54:11 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eZBhPXfe;
	spf=pass (imf15.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790067251;
	b=xhaDHTyHjxALyXdo3E6AN5IeLleWKRxtpX5bsJbpUqZIZB7BhbqBkpAkL/hQ/j0Z7O/wxZ
	yxU8r6LGTfxorVUfuDhfoKPLAM10mBPvJZSDDMpUwS+JcDZcdJbT4AiwtyYSdHvm8yEfcB
	32wymC8RGBRIyQmfzIZuNT/nFcUw+Kg=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eZBhPXfe;
	spf=pass (imf15.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790067251;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YLzEa2NgKc01BCihyFFvuyxmNzf4DGeagOdMFCmVpEw=;
	b=a8nkAg4+AWIGEirjuYpYM5RFIoLdTObtLgXzOFKozMuGKgOf1iEOBScm8SvjzYmAq2Wk53
	JfPwhOu9bluU7WZZf9fQ3PqUcDeJe3P5X1WGlXiiPuEGbiTto7E0dec1w1Ok5BTstRMvUH
	V0rzSoc3zLgMDhS8l+TYKDjIDVlPxdk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1AA1260DDA;
	Tue, 22 Sep 2026 08:54:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18A301F000FF;
	Tue, 22 Sep 2026 08:54:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790067250;
	bh=YLzEa2NgKc01BCihyFFvuyxmNzf4DGeagOdMFCmVpEw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=eZBhPXfeygiiU2f/pWtXEIFzdO1vnHyv9utcEzx5sCi5XdKNrN9kNs6QgfMYMO2cl
	 JHdWSJG6JobZ2aIXM0UrxDOm/Nhuzxt9hTmfLApAHw2EqHRBVimWQRaS9tAfMLmfD6
	 A28ePCpBvIfXoIdtIPyuQ1qyX5YDEPfFQzjLOLakzjCh9L9y9ITyD/W6GuRURRZhn3
	 HG3zRcy7T1ZQr4VDjrCo+Vw8XsWqteTMKv/qE9J+UYlygb4nz3aKGuC3N0t5mEbeA7
	 DD7oe4nIcp45NiurQv8bVw4Z4TwyviX22YWABtkICBG7pYIyGUvp/BPbFddhgrwRa8
	 cftqB5tqV8T7Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v7 6/9] of: reserved_mem: add dumpable flag to opt-in
 vmcore
Reply-To: sashiko-reviews@lists.linux.dev
To: robh@kernel.org, baoquan.he@linux.dev, rppt@kernel.org, "Wandun Chen" <chenwandun1@gmail.com>, m.szyprowski@samsung.com
Cc: mingo@redhat.com, saravanak@kernel.org, pjw@kernel.org, linux-riscv@lists.infradead.org, pasha.tatashin@soleen.com, kernel@xen0n.name, iommu@lists.linux.dev, ruirui.yang@linux.dev, tglx@kernel.org, devicetree@vger.kernel.org, palmer@dabbelt.com, aou@eecs.berkeley.edu, catalin.marinas@arm.com, dave.hansen@linux.intel.com, loongarch@lists.linux.dev, robin.murphy@arm.com, linux-kernel@vger.kernel.org, bp@alien8.de, pratyush@kernel.org, alex@ghiti.fr, chenhuacai@kernel.org, linux-arm-kernel@lists.infradead.org, hpa@zytor.com, linux-mm@kvack.org, kexec@lists.infradead.org, mark.rutland@arm.com, x86@kernel.org, akpm@linux-foundation.org, conor+dt@kernel.org, will@kernel.org
In-Reply-To: <20260922084256.1515554-7-chenwandun1@gmail.com>
References: <20260922084256.1515554-1-chenwandun1@gmail.com>
 <20260922084256.1515554-7-chenwandun1@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 22 Sep 2026 08:54:08 +0000
Message-Id: <20260922085409.18A301F000FF@smtp.kernel.org>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 8F220A0004
X-Rspam-User: 
X-Stat-Signature: a71t3ixhqip397op5ekzpnjar6ddzp9y
X-HE-Tag: 1790067251-799991
X-HE-Meta: U2FsdGVkX19jkKs4OvyPFtaLIgkVce+1kZ07LdiwqxGAXcUnDu7wc1J/3ooJ8BJgyi05v76ZfK/oCfugoMsKXzeHqZ9EUXPkPhiP8w13eeRBOP9PHR8HwUB6yPbO01XHzlGf9tJvgJ6Ln4/zN5UoLt7Z5j+TzeQju4/9IdhfTTl0SLNGLuaeHvgjh2DoNDUJwABiV9rJ9/igKk9JVUcQI5SPblDoGLFQXDEOxsQ3KiKTOKmED7vvXCZTeMI9SAQdgMK4GX15hf56MZO/RdIjL018NdYg0z5rrdKqhyipT25m7TBDxNdl6o1MEVzBAcssXqe5W23+vw3ErC89eCWHPdoRR0VO/g3RqJfb1uYPuZE1rnwvZm0UOvzhgPTkbMZWmZGZZGl+1ZYitt83b3K+tAvvWsK+3eZoauB0k7niaBC+95ly63Ct4UowWiwHoORmGweC5H3uiJAbu0FJTTmZm5l9/Co43i5iRSb1ub9Es0yrFAxp/oNa2n0V7EsfmWNNzDqypBOVQmTCbKeIug/YTlTKBa2Yxpwy49TBSq+0giOmCmrEfu83yuzFUSQEgbEikg7hd3HzbPUdbmZFfrO+KbTgVPJ2hOV3S5u43FupwSQwzGy4MPjA4ZXpHiksS6nkoY7q+Wi9Lm/N/ICBKVVdCU7TjURq1ZKeD9VZj1wnHrAGvvgVUpD4k0XMT1pI0nH/8CRl9Y4gYaARIBHbhonpOwQ3+rDyrIx6dFw10Nrybhc5q4lncr1W34T0KmjkHOC+CCk75A1l9s0uEDi5ta6Ft0xityCgoshbRXblgS5FY+nB6LdZx0LbwLaK0Dbm3P7PpbWMFrCHKCq29NED4VshwJ/PNHdyAZmoSiklTSKD39OT0p3ovXqguBgrz6kKvoX/8MR8dLKa5M9QiKfyOQp3eKm8LGgkHX5oVACaP1IUyUb1Z6J4TmjdEyyymkOGl6rLawyaagoCD5oGokaCsP+
 vUjZF5WM
 GUxhFb9I4/ljBhEqVE0RpNr2cSzrnx6fOJU76OB/K7SH0STFsrKv9wkBS1yZgqP3wV0cJdjPi6hkxrc/eeV4EN6ww8vFIyTqXT5pEKEd7jtaY4OB4h8qq2GKXfpQSTdugrPjY4Dvo7s5FyWI8FNpiWFiRJUuJq0aXpDaP7LK0JUrQxXXEzACOm5ZZ0BeQg4kdFBvGIl4CniYG5HoXW8IowWDq+P673x7Wt6ad5GP0YfIVHFv1VKiQsbEO9jt3KQIMWnaqgSnrjBEwcMZs2rLPzH7tqy+Zv4JNeM2+aOUaHYEbi9wNTQOZiArJ43qgNao4i9EsnV0nqwapUlJvRzAkR6/awXC/32X0sYoWsXMr9lT30BQau7acwvJ0iZNPIuo6jQOYetmg6gmXumPvtVZKhYd4j3vIigCFsRqaO/pYeEc0InqzX8/nSzedTeATHEqLfopf/sb6PtHuiq6gGEg2rJvalptdepOkFBAvhmQ+uKrDQk+hT8AHMRlcumYXpCpINB5rJ401xP3337dZRHDtwBAWSvvOF+5Qc3czgjjocEMhOf3aijDmgpnVkgiGHmf9zQbD+OoJzaq5lzQ0lNpiP5yp50gUPou/1p+ARJIYFV/fmi6ZSfOvWLkDnUkfDJAvFSCmFA/ATsrahdCrQsK6/VoJPohS8RJpHvsInU+gLgPT+4jnpNu7yyEclbEYkg6isU8Qkt7fxOV95QBoJHEz9od0Z/KyeFkL5bP9vfY8wJD5T+2ML+YGcyT5n1FpQSLGFaAW5yfSeKPwwoeV6wdAoVO88bB8TXRGt+bw95LohV+IF5hCZcU/vXr8g0oukX9VCff7PfTXhtEwUhg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> From: Wandun Chen <chenwandun@lixiang.com>
>=20
> Add a 'dumpable' flag to struct reserved_mem to decide whether a
> reserved area should be included in the kdump vmcore. Non-dumpable
> regions are later marked MEMBLOCK_NODUMP;the filtering itself happens
> in memblock, keeping the arch kdump code independent of the DT API.
>=20
> Most reserved regions are owned by devices and do not contain data
> useful for kernel crash analysis, so dumpable default to false.
> Reusable CMA regions are different: their pages are handed back to the
> buddy allocator and may contain key data for crash analysis, so set
> dumpable to true in rmem_cma_setup().
>=20
> The dumpable flag is also used to check /memreserve/ entries for overlap
> with other dumpable regions.
>=20
> Suggested-by: Rob Herring <robh@kernel.org>
> Signed-off-by: Wandun Chen <chenwandun@lixiang.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260922084256.1515=
554-1-chenwandun1@gmail.com?part=3D6


