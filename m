Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DEE9AE68169
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 10:50:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E7B26B008C; Tue, 17 Feb 2026 05:50:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 43D1F6B0092; Tue, 17 Feb 2026 05:50:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2EB956B0093; Tue, 17 Feb 2026 05:50:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 18FF36B008C
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 05:50:20 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C515F1B5AA7
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 10:50:19 +0000 (UTC)
X-FDA: 84453629358.27.06A6FB6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id E07BF10000D
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 10:50:17 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IfKh9WZ7;
	spf=pass (imf05.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771325418;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5cIubqWXAWqWrjv70JhXlBfZF3xiSYZoyLcIcS9cAUM=;
	b=K2l9ACKR+Z/nf4f7PSnTK1VCt/7K/X4VeU73d6JkWEzfn4KdhS0Wknrb/KvZQb2Fg2QD75
	q+B1THTT605DoFlGpdw0q9OH5aeC1riUqCpkV6J3IdVtMtS7YRZMB1rVN/dRsGa+hvuc4H
	fIvP7Hh6CQ6w7KJ0vJRKBkRabycoEoY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IfKh9WZ7;
	spf=pass (imf05.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771325418; a=rsa-sha256;
	cv=none;
	b=OcXRurkLPORcKcIW6DZyxa2LxTIMni59E0KKvkiBv3gt5xbS71SVsl8c9AkqbLjOnNelgg
	IsjZ98eZsmoROSUaHzLfVHXa5BVQS6rU3CZ7VKHlxI26Duqgg4N8hq8fmkaW4Stja3rFYm
	VFwSIgd7F8Qq8Pjk9ewBFCRYwJisMj0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id F2A8344280;
	Tue, 17 Feb 2026 10:50:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80280C19424;
	Tue, 17 Feb 2026 10:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771325416;
	bh=PTJFDGkeSN26ugvAI4aRe+dHGTbs5yOXGvLemsc0sMk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IfKh9WZ7rrdPHsMVJ8riwZwM6xKqp0tAAW1QxfpxaBVHwRnrQ8j6K0VMrZHUj28zm
	 NFW6ntHDBQ224IVEeKCS5Mz1szVhs8TuOD+2gbf1W3HnI+pHzEwlQiQwFmYCmPIHwa
	 +5d1CPmMbwc92MsdlaGwB5rUWNWBY4kQrQEwz4827MilsauUufQuD9ADJ3QKPp6wIf
	 DBGlEyVr557YXLyQMljywb30TtNFh8gLPF7B00FL4x4ZB1FMA1k5xnFRGtCprJ5Pgl
	 qQJ6P1Inp7tscdSnIEbSlA2cpukkyoH1Sqm3j4sOuS2MeRWPLawGY/Bh89GgQ3ONK1
	 KaMeOW4bnUlVg==
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfauth.phl.internal (Postfix) with ESMTP id 95F71F4006A;
	Tue, 17 Feb 2026 05:50:15 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-03.internal (MEProxy); Tue, 17 Feb 2026 05:50:15 -0500
X-ME-Sender: <xms:50eUaTN-zJ2YoI9BsyfJ4KYVmkSmz7tQUmD8Q-A6dV6BZfTaIAkscQ>
    <xme:50eUaarZIYivTMVJy86fSRFsdeWQScruLEmIMbbUSAUt8UpIgAomhwwoTYWIGV5qX
    6b49YpzCnYu9Wpkk7zrDgl1sov2GStBwD0OqxMedg4CgIKytQrgl-g>
X-ME-Received: <xmr:50eUaWJMnu4uyx4NZfAoCyEjMgtP5oVNzjkyXTITJ0--XARlGEAnrmSfjPqCiA>
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
X-ME-Proxy: <xmx:50eUaR2FJNb3T37kQdwKG2HA4HE8kgK1ICVdlzN-lAxnZO24sHMRXw>
    <xmx:50eUafUIWKE6cryVX8K9-x29frRCRUar7SbRcFKEMGgdMgQWK5iqIQ>
    <xmx:50eUacw15LLWqSRq6K-ISZd42D9oVnuAjDMuzv6K5MZmftXvvih4aw>
    <xmx:50eUaey3-tJWgcKOJzlgQSnwvGWKdJmoFnkM9qqakzhOYh_AFCMqOg>
    <xmx:50eUaZ2WrOkUxRxjhasi7LnUhuyFrhllG0C81CZZgA_z4AljCjr9be2o>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 17 Feb 2026 05:50:15 -0500 (EST)
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
Subject: [PATCHv2 1/2] efi: Fix reservation of unaccepted memory table
Date: Tue, 17 Feb 2026 10:49:56 +0000
Message-ID: <20260217104957.249340-2-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260217104957.249340-1-kas@kernel.org>
References: <20260217104957.249340-1-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: E07BF10000D
X-Rspamd-Server: rspam07
X-Stat-Signature: b8axorxe3ohuuc4kgqyjsgonuk4ucpfy
X-HE-Tag: 1771325417-349809
X-HE-Meta: U2FsdGVkX1+n7EJwMwFzfrtY/qVK4o3SCZ6Y2wg/ihX/4cAbGc5+odzBEdCM/zW2FGIZ2CrGd3dpvW1KugpzZBRRjJysLdvNsgUtnhFqPSpKuXZ9N1MH8g8sED8Ibm6QSf3eRTc8R+UrG1f0H3SjIZcO9gMjQGK6ptMBR45JQhi3KOoKROQOSOx7p/iFIp0P5v/0Rhj1fp3VjMlfZ3UNwEvqVXRos04qFfWeujIegT905Rge6p6Nyzb3feT2BVwodq7Wh3k3D0jlilTd8A5JShVdF/ZNqXsvioaw8Q9i3smEl0hDJMUm4fQY47dM7DoiYtfh4M8AzuDG9hWP7aCViGwll8+A7iZoATl/plg9rVLgKGd/rvDRnCGZg9fA0M+gbBgMfGMaYSloH5py29UaZg2yAeoVz9nQJRi/a8vaeg5Yisll1Ozf3Kowb6xJrCb7ZlBJ5q1AGNvkjQc4Lg28ZUCg2hrmsG6+bc8njQE7va90p+KhDVEnNr5zsLE7Abp+D5GL3TWoxUf+oGMqFoQWaI+5NxI4WsalESNcH88zO41HvSa0prqvcJ9MRQrL11KYeBxiWTHfjNj5jS+4eTh7PpDDbBz3raqcEZw8A5SFaLr56Pb80FhsvDsj0AMmg2gpY+MwjTXnpnXnj8saGNpHitKkU1gEHwLp7sHZS4umIm4TLYBK7CWCblRGDhdjyl0hPwWW4DN6jS1Wd205sJbkfYAu6WPKc1Gvfhdn6yLCytpfeP2HPqS9uO4X4RffvkCfxDnMfonascaq3S0ZfOKokPWi0HTViA4R5nlAjGMu1c2SQv0rEg8ULnai8hAr2foN39QZXFCf1vF9p4pie5yRlfJRqOzdmvhjj2MHSCi6FZAOvzh7qC7ygWXuh0TwxrPC8dWzLDik2YPuOwYLjjguMB4lKXcOMfsAy3smQgjO6JBpRUg00kjdWg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The reserve_unaccepted() function incorrectly calculates the size of the
memblock reservation for the unaccepted memory table. It aligns the
size of the table, but fails to account for cases where the table's
starting physical address (efi.unaccepted) is not page-aligned.

If the table starts at an offset within a page and its end crosses into
a subsequent page that the aligned size does not cover, the end of the
table will not be reserved. This can lead to the table being overwritten
or inaccessible, causing a kernel panic in accept_memory().

This issue was observed when starting Intel TDX VMs with specific memory
sizes (e.g., > 64GB).

Fix this by calculating the end address first (including the unaligned
start) and then aligning it up, ensuring the entire range is covered
by the reservation.

Fixes: 8dbe33956d96 ("efi/unaccepted: Make sure unaccepted table is mapped")
Reported-by: Moritz Sanft <ms@edgeless.systems>
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 drivers/firmware/efi/efi.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 111e87a618e5..56e9d73412fa 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -692,13 +692,13 @@ static __init int match_config_table(const efi_guid_t *guid,
 
 static __init void reserve_unaccepted(struct efi_unaccepted_memory *unaccepted)
 {
-	phys_addr_t start, size;
+	phys_addr_t start, end;
 
 	start = PAGE_ALIGN_DOWN(efi.unaccepted);
-	size = PAGE_ALIGN(sizeof(*unaccepted) + unaccepted->size);
+	end = PAGE_ALIGN(efi.unaccepted + sizeof(*unaccepted) + unaccepted->size);
 
-	memblock_add(start, size);
-	memblock_reserve(start, size);
+	memblock_add(start, end - start);
+	memblock_reserve(start, end - start);
 }
 
 int __init efi_config_parse_tables(const efi_config_table_t *config_tables,
-- 
2.51.2


