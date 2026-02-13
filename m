Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1BA2EDF176
	for <linux-mm@archiver.kernel.org>; Fri, 13 Feb 2026 15:48:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 660016B008A; Fri, 13 Feb 2026 10:48:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 654A66B008C; Fri, 13 Feb 2026 10:48:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 50F856B0092; Fri, 13 Feb 2026 10:48:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 39C9B6B008A
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 10:48:47 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D10921B4460
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 15:48:46 +0000 (UTC)
X-FDA: 84439866252.16.B7ED7C2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id C303810000D
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 15:48:44 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=A5i2uuQp;
	spf=pass (imf05.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770997724;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5cIubqWXAWqWrjv70JhXlBfZF3xiSYZoyLcIcS9cAUM=;
	b=MRBaZNbQdZ0iJ83bpthymK9ZwuuqxaR0Ceq3p4YRkkDuHm8PSTCK+2cZMJ+UYHPFIXFilg
	5+Q+o25tnokMC+VM2QISBqML2JTN8ataA840T/YoeETMkb7RmBTR5+d6pZF/t6rxwFAox/
	vpZF0zIEWL2w8Su0Or6IzUF2MGXR7cs=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=A5i2uuQp;
	spf=pass (imf05.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770997724; a=rsa-sha256;
	cv=none;
	b=1WOm1oyPLVI3K5UN/m1GjnWrC+vDLStSIzZYoDqJ9p8tf5p/bFwQUpouxA7qpCOROkqXLL
	y5opbdNBy9pksk+HRZNBXfudplgIP1WiYUS1Ab1JZ6vXgO/+yeaErIvrHnOZdzDn1xtmlE
	wyjbCiM/OZOUrFVXotzO13f6auzKyrY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D32014453F;
	Fri, 13 Feb 2026 15:48:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58029C16AAE;
	Fri, 13 Feb 2026 15:48:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770997723;
	bh=PTJFDGkeSN26ugvAI4aRe+dHGTbs5yOXGvLemsc0sMk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A5i2uuQpF4s1RFOexFyOdlWT+dXE1qKCpXkjUA0xr/6UY1MoU+yVgL9QvHoHDM8IH
	 rC431ghZqIHGKIL6pVXQ+0+4eQmd2glx1lLIlywGoD2re53AX+ch0/uyhKc2EIq8cf
	 6SNYfTseYYlyvuflEn8V/8GJSV21MAskpD0706/8XWrDujqh6ISUuxFNC4HB+vPxmL
	 eIxtXbi10RQLYhZBOS7c7uR4tW+2NPD5wU36IkEkyVpVUNJ51GTeqUeMrwnJePnZId
	 d2zLfhxtUd6qY4o9kcgFL3UQEbttabvpBsumzZxNnE0vESnBZEuZdKh0g+gs21p00f
	 HPFAulJJy8OvA==
Received: from phl-compute-08.internal (phl-compute-08.internal [10.202.2.48])
	by mailfauth.phl.internal (Postfix) with ESMTP id 84B87F40069;
	Fri, 13 Feb 2026 10:48:42 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-08.internal (MEProxy); Fri, 13 Feb 2026 10:48:42 -0500
X-ME-Sender: <xms:2kePaWqFpbN29LIl7FP6YKDHBORsC6aKz4tHMK99Lt8a6F7Ifp29mg>
    <xme:2kePaczbDUhypKCGMrRP9feRVW6Kuz6m_ZhplOXm2iRaIayUwPE0q2zr5c_ykeJV2
    mA1mckTp1Q9UcMVG7xCn1iOh6m91Ssk46PoJsHfJDrT_mpze86dmjI>
X-ME-Received: <xmr:2kePaavrCHPag5L-dfR_0UMCJj-KN-zv2neFD3aT1shwPafSHSj1YVbdjfMH3g>
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
X-ME-Proxy: <xmx:2kePaV14ltygcAKdm1e1YpJBJV3SBvdjryEHx_Ly7h2T4puje4izog>
    <xmx:2kePaSDv4DSW6qXpLIs366VIKTgAw5Uauj3brHhUPo2iQRODkr84ag>
    <xmx:2kePaTAwijGEDJJ7mRym84UrlopQ_3-TneWyZ9ls_JALYhLEIGPDDA>
    <xmx:2kePaTmvS-THGJTVbPJSrT4dWmOQyLUDJ2vsgwmJMRSpY4fcyC4tiQ>
    <xmx:2kePaTgd3TdN6tDELwo6EHKoRo7Q64H4mWOh5RUIWu7fX9FJW8Qg_5nW>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 13 Feb 2026 10:48:42 -0500 (EST)
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
Subject: [PATCH 1/2] efi: Fix reservation of unaccepted memory table
Date: Fri, 13 Feb 2026 15:48:37 +0000
Message-ID: <20260213154838.46567-2-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260213154838.46567-1-kas@kernel.org>
References: <20260213154838.46567-1-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 3h9pkf9mdrtck5x4su9kzz4mab4fm4pd
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C303810000D
X-HE-Tag: 1770997724-685483
X-HE-Meta: U2FsdGVkX1+fKedAhzDtBFOkRAqNFF5NMLazIZ5cOEcEB1FGIJ++9p2g4pKNw46OcL0xU8cXfG74Ps9MgjVn4gjSHfzFqvfGhDdz6X1mAttNiM4SxQIEO7fuLfVL7iGzwfGovTdOT8Ft7ndULV0PWqksDFSabgFqGOHyop0VoxxZIznt839YKqj42k0KfA+BCVjyY9m5gyfn5DtzlVRKUAUYdOzwbjFTVd6gBN/8EfzZeiop+IwfDjUVQxYnSIHoXVKno1tH2yE0ND3B/8k1NcnmtT2IqaYyEBrFteO38mddOWRpIAulfyy3jHTtJYK2gMgeRquv0Oh07Hx2Y6pxzg9uVtFRHnSV/D/O2YhfEe4+NIvsGeeUrm2WyQwQLaDwOl03waJW0hXfK7XShsky+w2YYYSSoF+RpwB3hLjE7aSPS7rzzSY3iQzC35ubgLis+1WgU+KHUMtYNesO11ziVscqq87q5CbM05h2sZEYD0ZTyG2pR/gEu5IHh+w0n3YXdCT2KHebkROyIN+zY9PHziI63l8uOrWV3eUZUXXOQTeSi6sixh4osBw6omZxoBHUIdrRqmfbs3yoBOuRTIHWD/134nzCmEg1xgLB8j6mbI2QE1AK6bbtobg/b0ynlkw5kDvKFvSDnZPTEE7iqaG645HSw/q71H84+uRXpdhMMgcO7wd5ab+Fc4eYJR7TijRtxmznwJwe/keEEm3qvNBA4UcN23NtAaybF1k4B8PNL36VSr7mqCp7Ku7YrJb/Y/EADgqc0fLmt18SB/HgrroUYCX15byvB/8OgMf6gr8gFaOm+GBgQX7vUhI0ZAF68VIYAnxBnHjHKwY1bCb0ZNzYgbio3voAlaRakU+4NPMyJceam6yYOwQxAjDaF6QYLMYVPRv96IFSh4dhXPPIZyBrGHiSHxgZey0Car87GucKkLNJUVZ+ZqpfvzJUVQYQ/PMioZG0t2m5kMqgPRtNFIF
 sUwEryKH
 agGn+kjZWGLBTvD5gbbJCgdhvEtynb7VbRr7VNOz2tO5gWQIIGJnhGMAgs+PJ9ydPy234FkcOcUASu4aa6jJlDE6MZSpSbMUYQ8/y7Gx4FNw/RjmSii2SukxFQFLSw5OvXdrRsG7GNhF7Z4JXOI0Sxg9WUFArfl8VNJj++Pd3nBy3meBQOyDRzNViYdOHf5wqaL0DOhKsfcV1Mm1JKmTnydiyFeeCnYVzf8CITwv3QcNVYVvBm7/L5KFaFba/x4HfHr2P
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


