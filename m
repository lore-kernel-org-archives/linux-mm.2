Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7420EE68165
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 10:50:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C5596B0092; Tue, 17 Feb 2026 05:50:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 845146B0093; Tue, 17 Feb 2026 05:50:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 69CA96B0095; Tue, 17 Feb 2026 05:50:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 473336B0092
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 05:50:22 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 07B3C1C34A
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 10:50:22 +0000 (UTC)
X-FDA: 84453629484.23.B739773
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id EE6E5140006
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 10:50:19 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="tbjV/W9X";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771325420;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eX4AEU0R/ld0ALK7gbKHMtCsRA030G7Lwq/gfoDH6t0=;
	b=00v9QsBdC2GhtnzEbrbC/VhG6Qa3hMbupA8U6EPPf4sA0NIcFkWX2JE+eBH9ABT+CZ9Jcq
	lsG58Znua5YrOOn1iXlDXDhjcA26VKdLWQGR6o1+MXfD+hZXIJG69MVv5SUCAcGp6fTLhj
	4yzvUTq/K5SlFMCgquXd+waZeW/rcpE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771325420; a=rsa-sha256;
	cv=none;
	b=A8m2mjDk3WJfMH09wvc+uE5wvoT6jWKG1e3Kug9CqoDtjIKKg0tssd7c0305ry1t9u5hVf
	sUOAqPvlfDHKlYEKmGNU5XECsxjorN3u2KpKdb9PigAsH69/26G5baiRe0png6Gsv6B3Lg
	GzCXcWrii4pcAtcsI4mm+gCF6FfXOrg=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="tbjV/W9X";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 27DC34444B;
	Tue, 17 Feb 2026 10:50:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DFA3C4AF0B;
	Tue, 17 Feb 2026 10:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771325419;
	bh=xE/869Bo+esNtn+UnIQSf4BQa1m8IjcPxSsG7/pPAWw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tbjV/W9XJxSiC75k/8A1lJn0OwBb771o6lywyOsF4sHJULJ7gQiIst6onqtmWMQb2
	 IaCAKopQ9Ktyk7vz/hTqSfkUtMx6FAgU4gab8z1BTX0Adjx3tzuDzruFvjSQu/uXJ+
	 Tkhde+mprxQ4SebqbMxy1m3oQYYApOkHBlUbcOwQUiPfRY3R/vBE/JAHaHB5A26UmA
	 BNbRyGoOe1gFEOFVTytNJ5tyWg4k6iffxMThca7oaTzZ7hqbWnbRfTtM/TMsw8WyJl
	 zRi39IaleaRISYNnSIG0ALgj22Y3TV+o4ITYlcmeohNeq5uKmElOmwK/EaHeDKG5zH
	 KnqdKCOfAa1tQ==
Received: from phl-compute-12.internal (phl-compute-12.internal [10.202.2.52])
	by mailfauth.phl.internal (Postfix) with ESMTP id B7660F4006B;
	Tue, 17 Feb 2026 05:50:17 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-12.internal (MEProxy); Tue, 17 Feb 2026 05:50:17 -0500
X-ME-Sender: <xms:6UeUabPidlUiMyY1cNH-JU7E_1F0RXxZHbv6oqE0w0PaSOg-ID57Pw>
    <xme:6UeUaSqk-Xcw9EHLXx7Mk8ud9ieI00AwsJbAD12ifnzk-Jir61JopRwOQIcPYt9sS
    sfcOu7v3BVYW03-7w_BtgvVBN7G1E4OR-ACLvyX2lBLOuzgvFiaxsg>
X-ME-Received: <xmr:6UeUaeKEbptCJgReUjtrSsgMmDGVAKTWweL3NJEavdOzdf17mmYGAvY7WMPd_A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvudelheeiucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhephffvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepfdfmihhrhihl
    ucfuhhhuthhsvghmrghuucdlofgvthgrmddfuceokhgrsheskhgvrhhnvghlrdhorhhgqe
    enucggtffrrghtthgvrhhnpefhudejfedvgeekffefvdekheekkeeuveeftdelheegteel
    gfefveevueekhfdtteenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehkihhrihhllhdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidq
    udeiudduiedvieehhedqvdekgeeggeejvdekqdhkrghspeepkhgvrhhnvghlrdhorhhgse
    hshhhuthgvmhhovhdrnhgrmhgvpdhnsggprhgtphhtthhopedufedpmhhouggvpehsmhht
    phhouhhtpdhrtghpthhtoheprghruggssehkvghrnhgvlhdrohhrghdprhgtphhtthhope
    htghhlgieskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepmhhinhhgohesrhgvughhrght
    rdgtohhmpdhrtghpthhtohepsghpsegrlhhivghnkedruggvpdhrtghpthhtohepuggrvh
    gvrdhhrghnshgvnheslhhinhhugidrihhnthgvlhdrtghomhdprhgtphhtthhopehthhho
    mhgrshdrlhgvnhgurggtkhihsegrmhgurdgtohhmpdhrtghpthhtohepgiekieeskhgvrh
    hnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqvghfihesvhhgvghrrdhkvghrnhgv
    lhdrohhrghdprhgtphhtthhopehlihhnuhigqdhmmheskhhvrggtkhdrohhrgh
X-ME-Proxy: <xmx:6UeUaZ2Tj5N02RAshMwc6S3L3SQaDN9Y_iZErKl908KPJVg6quFT_g>
    <xmx:6UeUaXU19NSGbL8hBkfr3Nueg4cx4OSsvam_FWAH7pAl5iv0Dd_1ng>
    <xmx:6UeUaUwoXgJVvPyboC-wkzaN_MqFR-YbLhT_UBruB-DBsnUv_079gQ>
    <xmx:6UeUaWz4xcdhgrtttCgYi9XkKp_8JCEzKzJtjfrmJS0pAG18a3aVag>
    <xmx:6UeUaR0NKjZjRdksqhBwUwO1kHYtzdQaIAAFsyca4XHhXOye20BcHuxp>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 17 Feb 2026 05:50:17 -0500 (EST)
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
Subject: [PATCHv2 2/2] efi: Align unaccepted memory range to page boundary
Date: Tue, 17 Feb 2026 10:49:57 +0000
Message-ID: <20260217104957.249340-3-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260217104957.249340-1-kas@kernel.org>
References: <20260217104957.249340-1-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: EE6E5140006
X-Stat-Signature: ey9fcay5w4cq1hebnmmckjgfwed8nais
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1771325419-484647
X-HE-Meta: U2FsdGVkX18jzKsIxHzoR61td1xIJnL4kh3cNC4QW1nDeyDVLa0GZM/1lXHmzFOmrJ/Wm4cznIwv20bgd0BMTcJUSUKOnBgxdPOLC1QSXonUwon/RPy5dFVrbtibirWKtqjn48wqERIpDbelx7yHqASYTBur1ZrUSV0n8+BCaRintbJWYi4MR+MX2Db1azE4LAda0tCW6hnUQocpA/X0lfimJKm96aAQchw09Cf6weFM6G66k9gPuRMlmjUfqove/FznaQLlBSZz0je6n8lpBg9lTa3tjw4lWY5at3TFJPkHUYiULFcb7t1h685Jr7mZH/YhihtKej7Mmuisgs02HqwxP6l0irLC0sKAcahsMS/LjaD7sOutFP6MebdYRZdGwOIQ8JSkk76bgvr+CjYhznWzqlcg16WKRaWuPBZNBv378uOuNsI8xSDFKh214LcFz1tAh0m3j5L23SzyGiRvDMNNFTWCe1b6UbhYTXXgGE7fAYT+Q8QmMgkRlOWhc/GiVppUK5t7v8TodBXNwwi03y2jKZ1x9hOvzzY4mysXi7RU+iISnbqexFTGLkEWy+2NpaaE5xkYxDNtujM8d0isr2rNynl/IC0ppbNkvh2wGxtOu3C+ShBUcLjZ8QA6lQ1QPTu8cB7iIW0pvyioM5EUbrXOZjXLxL6gc1aN2MVOu5gQingfiDGV4aElQkixiLOUJQL7XjBWkOonamPkGdf0Q8fTBJUak5YiXDpNRvgAJMve6jj692pT4o9UVwZI48MOTZzmBrHL9cBm0GZ3zIHG/0pbB1w/JTHHW0goULo/F9RoweFKSZ6e2a/b5QK6YFWHO7bA6AVhQRb4674TX3cg0U4ZGwXYYukr8A9sRRoIfLelr3EBNBoawDh2fHx3qGaV0NIP/hVtdT8aVyhh9o2JWDgezxk9TNHXiUs4xv7v4DzqPfgCClvybI9Qz6XHRJRy8zxqX5W/AvdohHr3Gyb
 PewpzwbM
 wDmVbzxesihms2vreJeHhbqIOAGhDCk6nYebuLdrahflgNx98mpZrQYP+FCdxa9dbZMG/DJvT8FcQUplFGdIPATy20PwNNqItEL+Y8wn9G/MZaawxqqitVcAo1K8lKSIBZr8UnH2QCE95agL5yyBtckhX4aj6ACtCdTNVuV+Mt2XFtKXi5pU4isivuwUlHB6t5EB+U7QzIdTiUAl4RvK1Kf86BQTzQ/YJbhEpaNMxRZZi3mtBEBHdhrvupLvEmVEMg3MeX6J7OCrUrzA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The accept_memory() and range_contains_unaccepted_memory() functions
employ a "guard page" logic to prevent crashes with load_unaligned_zeropad().
This logic extends the range to be accepted (or checked) by one unit_size
if the end of the range is aligned to a unit_size boundary.

However, if the caller passes a range that is not page-aligned, the
'end' of the range might not be numerically aligned to unit_size, even
if it covers the last page of a unit. This causes the "if (!(end % unit_size))"
check to fail, skipping the necessary extension and leaving the next
unit unaccepted, which can lead to a kernel panic when accessed by
load_unaligned_zeropad().

Align the start address down and the size up to the nearest page
boundary before performing the unit_size alignment check. This ensures
that the guard unit is correctly added when the range effectively ends
on a unit boundary.

Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 drivers/firmware/efi/unaccepted_memory.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/efi/unaccepted_memory.c b/drivers/firmware/efi/unaccepted_memory.c
index c2c067eff634..4a8ec8d6a571 100644
--- a/drivers/firmware/efi/unaccepted_memory.c
+++ b/drivers/firmware/efi/unaccepted_memory.c
@@ -35,14 +35,17 @@ void accept_memory(phys_addr_t start, unsigned long size)
 	struct efi_unaccepted_memory *unaccepted;
 	unsigned long range_start, range_end;
 	struct accept_range range, *entry;
-	phys_addr_t end = start + size;
 	unsigned long flags;
+	phys_addr_t end;
 	u64 unit_size;
 
 	unaccepted = efi_get_unaccepted_table();
 	if (!unaccepted)
 		return;
 
+	end = PAGE_ALIGN(start + size);
+	start = PAGE_ALIGN_DOWN(start);
+
 	unit_size = unaccepted->unit_size;
 
 	/*
@@ -160,15 +163,18 @@ void accept_memory(phys_addr_t start, unsigned long size)
 bool range_contains_unaccepted_memory(phys_addr_t start, unsigned long size)
 {
 	struct efi_unaccepted_memory *unaccepted;
-	phys_addr_t end = start + size;
 	unsigned long flags;
 	bool ret = false;
+	phys_addr_t end;
 	u64 unit_size;
 
 	unaccepted = efi_get_unaccepted_table();
 	if (!unaccepted)
 		return false;
 
+	end = PAGE_ALIGN(start + size);
+	start = PAGE_ALIGN_DOWN(start);
+
 	unit_size = unaccepted->unit_size;
 
 	/*
-- 
2.51.2


