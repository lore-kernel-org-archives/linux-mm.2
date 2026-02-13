Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 195BAEDF173
	for <linux-mm@archiver.kernel.org>; Fri, 13 Feb 2026 15:48:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 96DAA6B008C; Fri, 13 Feb 2026 10:48:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CF9B6B0092; Fri, 13 Feb 2026 10:48:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F8E16B0093; Fri, 13 Feb 2026 10:48:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6D1F46B008C
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 10:48:48 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 29C651A05B6
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 15:48:48 +0000 (UTC)
X-FDA: 84439866336.12.455DA20
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 2CDF41C0015
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 15:48:46 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WHbMe4ts;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770997726;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jvJ6Y/u/AMUx5/QEUUInUj2GiyAAbWsDBfvKS29BJ/g=;
	b=0845vSpAdeYP1BKR8vZ6xPb75ZrGtrGiNm8XrhHuZCmkMVjE9EWYpuF+9ncP23FDyVOHd8
	6jO9vnZ6LUQ5Jjo8P5OVDty7NMRtk+ZnPfeWfugehVjV5kX5pEoZgfh2rTywKclHis97EY
	lDjp1lSlxIkvLIq6LtLrIgGFhPY0aT4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770997726; a=rsa-sha256;
	cv=none;
	b=3P/HepHdERKzzb1IHuMIQ8QPFvBEGj9PEaJhEqGwgtvPmiaUbUJng5Ni8fAWA1jqlLK8BR
	5Yk5Aotxbp+ZhkoeE6cirqcUN0tUKflrQlj2Z2FsuPotUH9IIsfVTfBA18ILPzb+YRBlPM
	WpVdBFJBi8M+pjTWpZ5doSHsvpCiBpg=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WHbMe4ts;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 814FA6132B;
	Fri, 13 Feb 2026 15:48:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4B99C4AF09;
	Fri, 13 Feb 2026 15:48:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770997725;
	bh=7dPdpuhsrQod7cEGqKBOY+A3ayeNPxUOOxb86J+eqNA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WHbMe4tsgtS4AB8kNPkasw4v4lIQx2jJiY4rmeA074j6L8cF3+MZQ4D51RAcKGB43
	 4YTjW61e3GFaBQOzYm2xXqtQtpaurWHtziQp8VyBgYcMVGPABU7oY2rzUqLCu5ER07
	 Wa4ClhCwTpRiKNhrBmIOljHVeeCDPYCVvS/A9R+afBGRyhi1v/uyBmk2U82Nc9o9Fs
	 qrQvn3KlaU3mV+SLsBL0JkV56mdYzxgg6U8rILsBe+kUuZUESqy3yEuO1K1DvvqsXD
	 xlo9CpXhJsSOMjPpoHROtxuMG06ANGKtIOFhqK2yD9B2cQ06Ss3tgvIjk665+gZ3Rj
	 QP1w4MCwP+xFQ==
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfauth.phl.internal (Postfix) with ESMTP id 0C048F40069;
	Fri, 13 Feb 2026 10:48:44 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Fri, 13 Feb 2026 10:48:44 -0500
X-ME-Sender: <xms:20ePaRD4uHyBGkiPL0qlsL6WMm7clUVmDtpsRsplfW3OkwCsgKMnxA>
    <xme:20ePaXrQXgPrvB8_K3K2MT-KZugxXkMKggwOZ68tPOAwupc5DPl7zCv1ho7j4sCTu
    qsF_f9Fl4jjd769PKiznHfJoqEy_5wUOoUTMoXooTPZeP-3l25z5gYa>
X-ME-Received: <xmr:20ePacFtvWRWxsg15SbkfBnRGEcQgJjx-x1bdXUN-jYVPmudXx-W-AcdENewQA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvtdekieehucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhephffvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepfdfmihhrhihl
    ucfuhhhuthhsvghmrghuucdlofgvthgrmddfuceokhgrsheskhgvrhhnvghlrdhorhhgqe
    enucggtffrrghtthgvrhhnpefhudejfedvgeekffefvdekheekkeeuveeftdelheegteel
    gfefveevueekhfdtteenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehkihhrihhllhdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidq
    udeiudduiedvieehhedqvdekgeeggeejvdekqdhkrghspeepkhgvrhhnvghlrdhorhhgse
    hshhhuthgvmhhovhdrnhgrmhgvpdhnsggprhgtphhtthhopeduvddpmhhouggvpehsmhht
    phhouhhtpdhrtghpthhtoheprghruggssehkvghrnhgvlhdrohhrghdprhgtphhtthhope
    htghhlgieskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepmhhinhhgohesrhgvughhrght
    rdgtohhmpdhrtghpthhtohepsghpsegrlhhivghnkedruggvpdhrtghpthhtohepuggrvh
    gvrdhhrghnshgvnheslhhinhhugidrihhnthgvlhdrtghomhdprhgtphhtthhopehthhho
    mhgrshdrlhgvnhgurggtkhihsegrmhgurdgtohhmpdhrtghpthhtohepgiekieeskhgvrh
    hnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqvghfihesvhhgvghrrdhkvghrnhgv
    lhdrohhrghdprhgtphhtthhopehlihhnuhigqdhmmheskhhvrggtkhdrohhrgh
X-ME-Proxy: <xmx:3EePabufmfNv_zp39Weztfa3bg7vuToWgipf5ea4MOv4OWsder9ZUg>
    <xmx:3EePaSYmP6UlC7zglG4UoTZj4fRZYmOpd8FVyHvrhi8Mgm0sWFkP_Q>
    <xmx:3EePab4Bn5zc80_9mVKVvuAtvWVhqfeDSXXbzdLBxxPbvZJRam2O9g>
    <xmx:3EePaa98VoPFVzIQtw7DD7Ni_3XoLhpaUH8_tIxY9KLpcJbunBMzbw>
    <xmx:3EePaXac1mDMoNmUjKBgv3loiYU4PqbmRbjnF7nLh8WdPuACzjOQ8W9C>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 13 Feb 2026 10:48:43 -0500 (EST)
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
Subject: [PATCH 2/2] efi: Align unaccepted memory range to page boundary
Date: Fri, 13 Feb 2026 15:48:38 +0000
Message-ID: <20260213154838.46567-3-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260213154838.46567-1-kas@kernel.org>
References: <20260213154838.46567-1-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 2CDF41C0015
X-Stat-Signature: 7fwujzjg9n4w15oja8ci7hkx57mk97q5
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1770997726-116288
X-HE-Meta: U2FsdGVkX1/LhbEcfyb7pRzH6xN878vIWsb4icOxdpQnRpeJEuZb+uRc6Y9SyM9vg2XjpW8nRTw3tKl5K7765nd+PVlaj9H46BqvxXeMaazwIsVZjC60jGMwHQL94H3vaTn+TyXiSqhrPEv6KF0IiTENwJDblNek2SBC7/c8RvMhkxaBiSkby25B3+UzIFH4TtiAAIM5cI1pjLfc0+TtybhOElyHf0hGNKPSeKwjxjpTen1z4wAgL8PTp7HG5XN80a+B++WyrAAw582/yD7FSoe6ay0DHLUwY15mb1qh73xvII3jMS8odtlSfjO5ezslLUppcMBMouZWWPx+XYeR7YSjgng0KogRBov114LN/oNnymXWSJf81EopJUCLRoajW4hrDCSwawlPrcxKVi5+OOREele+CE5SjAH4ZpvLmf9M89chc42DbnNL3rrOcglqg6qAR/+zQYNkxip7NZOS0vUkMJTr7S853GmVFCs1coWWmsBV1Ws+5ZoN8h37GgJlp9uu2QirKcJ41hsGS0X5ixji0xhc2/uKWa61hUdWzerNSbyRpU5nrsL3+B0bqW+Wf5j9PEO7/r1JWXMXgAA+3+6uU492DetwZERrdvQ56DAoztCoxDTQVn9V31Xns9ySMOrb7b14rUQRs5Xli/pir4akAEsU2SR7zpxQPukULVwkfHbd0FJMJ4/XQJL+iQTIEqNTVrbQvd3XFTRSNBzEt5VqymHBD/J7I+XH7AFiLNLA143FAZOpVClAdgMFO6CHhie3oR9zy1brvODZzQYQvhaxR+7tn3UCR5puBgd5VGMmMLGCwDxx2kXsh4rqZEg9EYf2VJfhB1yKiUCqvG3vjPzaxi9Ki0RKiHQG/cy3IvL41pii0B+yu0ObemJdAuX6lNL/Fd4TYNB7cHrwD+uzD1mlR4rSoVMEAXNTVFVmmhZi5ADvazJOqyq0ODhaxbezU4j7gU7dDPWRXWUCsHQ
 cTuhuuYI
 oEPc/pgzvh1eQS+uNnifYgUXUczp52SNdWSIlp/vYXtTKfwBcMeXwUbujedP8tb5v9OxQ7lC3uxtqsPOvZUVEQHV0yP0NCcl3xSIDWZ/ZBIUqJfvJYLgsxpV+RVMye+t3SfUHqQ+Wd0b27docFi5UpPWmIYZonlUr/RwLxmOamzRFjxJ5cu0ooTZ+m7fvx87LXESXJJ0vzdYics3z1Ax1f5+qShob/Q9IdOqkr+KsLPnFtf/k30exfOTgCyDPm/KBBY/y
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
 drivers/firmware/efi/unaccepted_memory.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/efi/unaccepted_memory.c b/drivers/firmware/efi/unaccepted_memory.c
index c2c067eff634..9ddf3dedd514 100644
--- a/drivers/firmware/efi/unaccepted_memory.c
+++ b/drivers/firmware/efi/unaccepted_memory.c
@@ -35,14 +35,18 @@ void accept_memory(phys_addr_t start, unsigned long size)
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
 
+	start = PAGE_ALIGN_DOWN(start);
+	size = PAGE_ALIGN(size);
+	end = start + size;
+
 	unit_size = unaccepted->unit_size;
 
 	/*
@@ -160,15 +164,19 @@ void accept_memory(phys_addr_t start, unsigned long size)
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
 
+	start = PAGE_ALIGN_DOWN(start);
+	size = PAGE_ALIGN(size);
+	end = start + size;
+
 	unit_size = unaccepted->unit_size;
 
 	/*
-- 
2.51.2


