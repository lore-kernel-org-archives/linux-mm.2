Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4C0CE68165
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 10:50:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 27FD76B0005; Tue, 17 Feb 2026 05:50:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2030E6B008C; Tue, 17 Feb 2026 05:50:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0DBF36B0092; Tue, 17 Feb 2026 05:50:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id ED2766B0005
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 05:50:18 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 96A7C5E35C
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 10:50:18 +0000 (UTC)
X-FDA: 84453629316.07.B3F0B2F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 9088A1A000F
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 10:50:16 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NpbmehtU;
	spf=pass (imf19.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771325416;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=vMrXt5ITW6vFN90V899hDJkDN8ZnK3IxgY+KaapmyOE=;
	b=HFYrBzQHwUT4Lwf8lhBpV4h2I1PLRZfEDrYsRnv1BLceWpPvfROoQaPUpFe+BPSqjtThD5
	afG6VLSubk1fKKzB3440c9hmfRIy8IkKzW3AjU1qUewixBqNH9pSJc7B5U0FtXZtt3EJ8g
	gGEroJ35A9OQ8KlqpdgTfwZEMpasb7Q=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NpbmehtU;
	spf=pass (imf19.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771325416; a=rsa-sha256;
	cv=none;
	b=I1Z5VnHhBKnW8X1VGetEmIm2TttEdnP0S8TjOBiIvweDG1sYKgFZ5raTSj0XBpY8PdoYCb
	dzgGoclpNKjmMhraXXh+8BRN6qywHTPOQJxLudNTKxmcP/zTo1HWHHmg6EIi0jy9DYa6dm
	zbQosZOnBSE4Vlu0hBm627oQZ18FF9o=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9431943F96;
	Tue, 17 Feb 2026 10:50:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFD78C4AF0B;
	Tue, 17 Feb 2026 10:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771325415;
	bh=RrFGvE/E+r3nDli9pSyZ0W1is+dG3zskCpfHLCnPiFY=;
	h=From:To:Cc:Subject:Date:From;
	b=NpbmehtUS5Mxrwk9DiPWIknJsvzZZAo5fmW5FHMYYLh4vbrfLiu2x98/no38fJlME
	 LczK7X/9Yn+H7YvHhJkYkPdC7Tjx5/Rd5bA6Kr7Px96cGil+5IVL+pkMMwmHGcF6+M
	 E46HNoLkPiyAIs9Uy3sdXiUj+0P7l3zDsFGuBrjEVO4xrOoMVHdtTjLephqGVv1h+M
	 28nM0dQeHRsJrzSOM0e2c4RoDV2eoEuM3xyfBBEQDzeke6rOwpPbbHnDvH2JyaaWer
	 /fulF9N3lQv/Abg84pdseMqxoWMiab0xH76aBrWRKGuz3d+dKTuWHNM1dkB1J1XGDN
	 d3Ut+oiZ6IDVQ==
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfauth.phl.internal (Postfix) with ESMTP id F1996F4006A;
	Tue, 17 Feb 2026 05:50:13 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Tue, 17 Feb 2026 05:50:13 -0500
X-ME-Sender: <xms:5UeUaQjfLHGWfnMCzLadRcl7NV6Lgh2VQG4R2MraIMnx6pdRcws2wA>
    <xme:5UeUaVtyhhmvUshU5ZeHgez7QJqf_hbml6T7NUKuqm3bZVqZRCiqXxYyLOoGWV6pq
    yjeRDAlidgTMiXOb2BMZJ97iM9Pe61Yq5UZWGBR3iDceCoDi8Nerbs>
X-ME-Received: <xmr:5UeUab9VznicnhaiR2CDxh5TMnkKzn1pSduDkc3vRFw9eMtphToAuIfDeQvR6w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvudelheeiucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhephffvvefufffkofgggfestdekredtredttdenucfhrhhomhepfdfmihhrhihlucfu
    hhhuthhsvghmrghuucdlofgvthgrmddfuceokhgrsheskhgvrhhnvghlrdhorhhgqeenuc
    ggtffrrghtthgvrhhnpeetieekffduudfgheektddvgeetieefteefudefheekffeiteff
    ffelieeiueevhfenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfh
    hrohhmpehkihhrihhllhdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqudei
    udduiedvieehhedqvdekgeeggeejvdekqdhkrghspeepkhgvrhhnvghlrdhorhhgsehshh
    huthgvmhhovhdrnhgrmhgvpdhnsggprhgtphhtthhopedufedpmhhouggvpehsmhhtphho
    uhhtpdhrtghpthhtoheprghruggssehkvghrnhgvlhdrohhrghdprhgtphhtthhopehtgh
    hlgieskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepmhhinhhgohesrhgvughhrghtrdgt
    ohhmpdhrtghpthhtohepsghpsegrlhhivghnkedruggvpdhrtghpthhtohepuggrvhgvrd
    hhrghnshgvnheslhhinhhugidrihhnthgvlhdrtghomhdprhgtphhtthhopehthhhomhgr
    shdrlhgvnhgurggtkhihsegrmhgurdgtohhmpdhrtghpthhtohepgiekieeskhgvrhhnvg
    hlrdhorhhgpdhrtghpthhtoheplhhinhhugidqvghfihesvhhgvghrrdhkvghrnhgvlhdr
    ohhrghdprhgtphhtthhopehlihhnuhigqdhmmheskhhvrggtkhdrohhrgh
X-ME-Proxy: <xmx:5UeUabYPvhx6m3e7QpQGHKeG-2Zo7ILfFuifgy0PNHx7bc8ZUVqQMA>
    <xmx:5UeUaRqCSRY-oYkoR1w3ScSdzVxW6yTt71RAkNrmaHUicw9eVW6_pw>
    <xmx:5UeUaY0IqDT33IclvFQiSBKLpZgs6k86D1xRhkSPybANyKggwigJrw>
    <xmx:5UeUaRnaoKqbzD5t46BTcOVYQz2zGUJy01zmaTugMEJ9ILF1AlcjhQ>
    <xmx:5UeUacaRmYXL-qGnbWneWlL7Ro6UxG2SMzA2vJOWubUW4SpUvNj2CFIW>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 17 Feb 2026 05:50:13 -0500 (EST)
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
	Mike Rapoport <rppt@kernel.org>,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: [PATCHv2 0/2] efi: Fix alignenment issues in unaccepted memory code
Date: Tue, 17 Feb 2026 10:49:55 +0000
Message-ID: <20260217104957.249340-1-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 1by3tqiszokga8yudfm9qqc14t9ug3nd
X-Rspamd-Queue-Id: 9088A1A000F
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1771325416-904251
X-HE-Meta: U2FsdGVkX1/qcL5XRQBdqoG6iKQKRnASAwcRBUIUU2yj3God17erWpqmPsqh9Dyu5ETrkZ2ew/FIRFxmlV0MghZ6FHiErjOiu/x24SNlfosW9uSD14N5o4He+wMc/gV48GbWbnSFlirUgeuW/jdBuTc/VBkexXXGGw5SNuRcz/1RY5cjadTIbKkGufwh659t/FvMPX4boke8Gjuw2rTQUaMbPF4MSlbhR1sIveOfeddI8+TufJjvXGssx8RVDi9yfN2TcHLJWHNJ6VvBJx40n3EskdESCkYvGrGw716FpU8xowWlkOqqM05tYullJ89zxULztnVkT+eGoK4fLRUAlyhthT2esCNC6CgSXQoQPRHJ+oXqprjEHuAHaTJotGvn6FR6U7rsN8Mw+L9Lv2eb9kR4Sg9gmqQhZa+6pqjz/eRK85mengPaJOSFsOEx4j8uUOUwGbslDjmAbThTsfytKUhry2WZrRtkL0Ysf706/qHJ9r8m87RvdOvzbwUGrLKUJVsOGNghmutBI2OMNsVvm00BQ/NwPR3gqMSzb9gpBb/SCRNjyaCDLM/hlG+Mz8W/RylwFV3QNKY59j4jEjnjjlh5ZbODiHKVe05FiAKnDlVzV5ibBMfcBcoZGYP1mTAsL8bBZ2Th74L4qAfj3tYGb+mBoh7lhszenqYNiT4rdaPtAznAGVSdZIdu7RUu4RapkqpoiYgZLVPo4/ffLfoCnysjO1GcVovgWrFsbqR+3f9ZP6rcQCHiGsEbkwd5MFDUMk88CTQtG8/dd5OoDvKNmtczWJStKowCM2vtdaIukyFEE4+3mAKjfT3zW+6f0K7RLREBv2TYFriJdvE2L3pPT6JWYOZliZP4JoFAm2BupOUDF5GhvRqt86EVPEjmhymNVtkhc/r8CKpnM9nDQsiqgooKBURVTDjKG0KwVXZbs2Reh47S0qIel1m5gUnob0b3oXCt8+TPQV1pyyXq+nS
 WGCr2UBx
 RHyX81W8WY2/qkmgJ4zwc0vhvko17CVIFmQa6ChccD27Hn+PvQAVsc3I+7A7HYhaBnY4xoRLW4DlIjegNwAtMkEJ/m2MSByQ5WZLpisZnbwkv9QX9bRKH+z/enJxrRurXaaFl9jPX96Kt6AyBh9QGQIFlW0KCZTLGXycBG+Gu+4Mo9SlHcFQg1jvTKqAmp7IDXDzNgp8MOXLl5mcG6PqeX/XKvdy2njKhvy9IXxBoXVSlMU8=
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

v2:
 - Fix 'end' calculation in the second patch (Tom)

Kiryl Shutsemau (Meta) (2):
  efi: Fix reservation of unaccepted memory table
  efi: Align unaccepted memory range to page boundary

 drivers/firmware/efi/efi.c               |  8 ++++----
 drivers/firmware/efi/unaccepted_memory.c | 10 ++++++++--
 2 files changed, 12 insertions(+), 6 deletions(-)

-- 
2.51.2


