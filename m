Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F0F2EDF173
	for <linux-mm@archiver.kernel.org>; Fri, 13 Feb 2026 15:48:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C433A6B0088; Fri, 13 Feb 2026 10:48:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BED066B008A; Fri, 13 Feb 2026 10:48:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF2EF6B008C; Fri, 13 Feb 2026 10:48:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A00706B0088
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 10:48:45 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3E399591AB
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 15:48:45 +0000 (UTC)
X-FDA: 84439866210.25.B359B3F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 28874C000C
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 15:48:42 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=B9vTnF6F;
	spf=pass (imf28.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770997723;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Vhc1GOZDAe3ZTuRUEnNWGeADhovRBQM7gF/TBlLDJA8=;
	b=5wuIeKTgVSvw4gmfXBkTJEk9eTQ17YSgpI/gvf/CNh8cqWubJzAZxJWkE/Vd6FG7VSxlz2
	iH08n77G4WYiQcxU5a6yT6HNst5UFAgPsiJi8uz+15KcrwOQnGa858b6FwjkkkNmwt4uCu
	p1idl3QokK2DtBIibL3ApsQVm8IQyEw=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=B9vTnF6F;
	spf=pass (imf28.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770997723; a=rsa-sha256;
	cv=none;
	b=zba/jZMTG3jHMy3hl3J745vSOGmjTfchcFKJmNrVGePGdEGSbf716JtV17291m58G+t4TT
	CimxmGGtbKwSf2KElIGi0Vlt38QPrXHV6TpuiEUciZlbXhawwLo4Vhf8BqzHtNolZBsY2i
	K1/x6zGYbdxz0qkjnwCaybjaHOQ+C+A=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 27500400A7;
	Fri, 13 Feb 2026 15:48:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFB05C19424;
	Fri, 13 Feb 2026 15:48:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770997722;
	bh=KwYTy/KER0mm+nMwgJa21Fhpvad7CAER+z8MsqYWKgs=;
	h=From:To:Cc:Subject:Date:From;
	b=B9vTnF6FaSCyUscgOrG289uLgSL/FAJ5yiCLue58AxvbtjIbJ1rNZXPBy8q29UuwX
	 TnXc4W6y23jKXAN6kHKo4s9y1FncZtY0wLyfN+GV7QpDHU7tUNBQLQ4/LiVOsKCCUO
	 baEyhUCxhPgmqAMCnWs87x/dBbnj9Vmd1w6WChMz/2x0CfoKrwQhKyOJP3k9yDgrfS
	 wvk7jaHs/fzPwGmOZNj8vLOzrBVHCaHbkX27Lxy66JvPutaOTVJRP6wZ6i/E2CTTpF
	 p9YjNEFO/e9vuQ+nbqzPGA475H1LpHmjyW7Og7SoDa94qpb3qFzJOwZTXycuA37LGB
	 T0WXFoq8rtveg==
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfauth.phl.internal (Postfix) with ESMTP id E6FFAF4006A;
	Fri, 13 Feb 2026 10:48:40 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Fri, 13 Feb 2026 10:48:40 -0500
X-ME-Sender: <xms:2EePaVZ1HzW-6_WabKbFZ8XYv-QV44Rp0a0cUprXtSBpsT_xVmrX5Q>
    <xme:2EePaUgLF8z4oU_w8785Qb-joNz68g12MJfLy-RTjaMynXTnMIjgwlInlmp9XwxFd
    lqnrmaV6MMUKSOAkqlYrkd3AcHDjB1yv5F0Yiy9NTYg-ZMAArenQW8>
X-ME-Received: <xmr:2EePaXeL6zl1gKjQMAPnPSkLGh0pLG7QdastRgrj7C-FF5RTx1H0cOiKR9-fjg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvtdekieehucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhephffvvefufffkofgggfestdekredtredttdenucfhrhhomhepfdfmihhrhihlucfu
    hhhuthhsvghmrghuucdlofgvthgrmddfuceokhgrsheskhgvrhhnvghlrdhorhhgqeenuc
    ggtffrrghtthgvrhhnpeetieekffduudfgheektddvgeetieefteefudefheekffeiteff
    ffelieeiueevhfenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfh
    hrohhmpehkihhrihhllhdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqudei
    udduiedvieehhedqvdekgeeggeejvdekqdhkrghspeepkhgvrhhnvghlrdhorhhgsehshh
    huthgvmhhovhdrnhgrmhgvpdhnsggprhgtphhtthhopeduvddpmhhouggvpehsmhhtphho
    uhhtpdhrtghpthhtoheprghruggssehkvghrnhgvlhdrohhrghdprhgtphhtthhopehtgh
    hlgieskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepmhhinhhgohesrhgvughhrghtrdgt
    ohhmpdhrtghpthhtohepsghpsegrlhhivghnkedruggvpdhrtghpthhtohepuggrvhgvrd
    hhrghnshgvnheslhhinhhugidrihhnthgvlhdrtghomhdprhgtphhtthhopehthhhomhgr
    shdrlhgvnhgurggtkhihsegrmhgurdgtohhmpdhrtghpthhtohepgiekieeskhgvrhhnvg
    hlrdhorhhgpdhrtghpthhtoheplhhinhhugidqvghfihesvhhgvghrrdhkvghrnhgvlhdr
    ohhrghdprhgtphhtthhopehlihhnuhigqdhmmheskhhvrggtkhdrohhrgh
X-ME-Proxy: <xmx:2EePaTnKtV7zM8w4j6y1oqot6AhCwsNfCp6rOHdtBPgXMjSTRf7jVw>
    <xmx:2EePacxxkv6diwEtz1mT9xxVOmBJ7skD3wwlfNaS3vBrou06s8bSOg>
    <xmx:2EePaWxbFSz_t59i6ufq2nZX2Rn-s5QUlYcBFN_ftfMZ3AKzS-Z0Xw>
    <xmx:2EePacX_tH2SUKoXCdxQuTOxF_eMqR9_PCNJvVE0DHmGXxXHGMq7yQ>
    <xmx:2EePadQwItHf1mHrlooEFgoPBNkgOpzDx-BuZ3qwni-13pItpsjrTLTA>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 13 Feb 2026 10:48:40 -0500 (EST)
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
To: Ard Biesheuvel <ardb@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Tom Lendacky <thomas.lendacky@amd.com>
Cc: x86@kernel.org,
	linux-efi@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Moritz Sanft <ms@edgeless.systems>,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: [PATCH 0/2] efi: Fix alignenment issues in unaccepted memory code
Date: Fri, 13 Feb 2026 15:48:36 +0000
Message-ID: <20260213154838.46567-1-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: sz6fis7ybmuouwn46tuua4ahoaa6joym
X-Rspamd-Queue-Id: 28874C000C
X-Rspam-User: 
X-HE-Tag: 1770997722-946602
X-HE-Meta: U2FsdGVkX18FU28SZgmQb2SQSMO/MtFIGTjMWAEKNGmTHWS7i4qGJv9E9Qp6Kqk3JFOsrEApAo7SOwgisefPpTImX2qY5SIroAHfWpsjeeUGRur3v4sDop1yxfRhZz7zEIKRxCB+hkur901Fi8CIUgMkq8uR0vncfu3eLuFdf2ArpJbZEfWUC8lxa13FLVHuGeVjJZcNyR4xEpdpRT/JzxNSW+uAwh6kcyP+mXgT3k4uJ69w4zaBfqYl4eXNeDO8eXTsmXRuanyKug/OClEbM3+UUkIcNURruUX8B0ZSFpOtz7ChsV3GN9abu88a0b2FsCabv8KesyLqKTIs0xKQpDa45dT1unozvC8ODLuEurgMbXTkZk9yoDqV2YiMC94VUK8cb2LD4nxHqeS98ycuupojVYwfCv2Ys7EK9z4qsdTQWimWxFXxAW9+nWRRV6j20rjrjbyicxjWDWyzfDyWUdUJlZgFGqgOME5tm4LiIj3UFkUroeoC+4srMqKDFG98bO3OeWHlKp7MeiB+tKQwt7A6sg1VJ5Bi6k6nd9WBx5uvVyviUpvBjxRwZtmWJxaUfMawcTn98O9NjTrlnJfckArX82zRrwQy+4sN1odAYcAzuT5pUACL9kZc48DkMYGBq6DDTG98kKwO3xxatDPZC74Gr2DsDx+TTveA+c7roRXb63O+nno5ZEGJqjKqlcuGlFo4BCFr9NAh+9aQ/eV0KIUdEZcMpJ7DiWYlNSbEqFB+z76qmLy9r2CNrLUG5g4HgE5AVPEw+96S+4M8T2zzQT32kapab/ZLgTyNJSBmP3MUNtxu9ScxMYkQU2vAKGo/7rEIlzpBHpyaUzR/4OuK97UdSBDY8C6vA49UuxRH1R8gdgMN4AvXfHSsYeYnfUrohqQru+RUzxUz/po/Oympcw12baoEyQpImtAFenz6psSOQ9ej0AEdME2R7h+lhYL2qImUZFyRBJazH3M7QtY
 AUcELM13
 4bvIPxiqvnioZp/GO/8Wtg6yr2d44ij3y7b3raly9UutYrCSPHV2xjYLppD17X9F8eWw6L6h3izdFC7RM1dncXC6/RwlkE4/ADT8DJrG7rBoZ6u51qsraelFwgdxaQVGO4ufm3ro48V6FwBW1gG6X8pjO9MSvCHDeqiNFl2TskBIneZoaabC1gP1cjnBAVzVQlxBj6fWaoWpYFOwSHR3gbogwS9PDmlcyRlLw9AnS82cdQ7E=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series addresses two issues related to unaligned physical addresses
and sizes when handling EFI unaccepted memory. These issues were
identified as potential sources of kernel panics in Intel TDX
environments due to incomplete memory reservation or missing "guard page"
extensions.

The first patch fixes the reservation of the unaccepted memory table
itself in efi_config_parse_tables(). It ensures the entire page range
covering the table is reserved even if the table doesn't start on a
page boundary.

The second patch ensures that memory acceptance requests in
accept_memory() and range_contains_unaccepted_memory() are page-aligned
before performing the unit_size alignment check. This prevents skipping
the necessary "guard page" extension for unaligned ranges, which is
required to avoid crashes with load_unaligned_zeropad().

Kiryl Shutsemau (Meta) (2):
  efi: Fix reservation of unaccepted memory table
  efi: Align unaccepted memory range to page boundary

 drivers/firmware/efi/efi.c               |  8 ++++----
 drivers/firmware/efi/unaccepted_memory.c | 12 ++++++++++--
 2 files changed, 14 insertions(+), 6 deletions(-)

-- 
2.51.2

