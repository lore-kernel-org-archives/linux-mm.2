Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C0B1C43458
	for <linux-mm@archiver.kernel.org>; Sun,  5 Jul 2026 20:58:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A4856B00B0; Sun,  5 Jul 2026 16:58:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 555336B00B1; Sun,  5 Jul 2026 16:58:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46B646B00B2; Sun,  5 Jul 2026 16:58:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 069B46B00B1
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 16:58:03 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6083B1201E8
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 20:58:03 +0000 (UTC)
X-FDA: 84955935246.14.935A840
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id D182E160003
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 20:58:01 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gTMI8lp6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783285081;
	b=5SehDCO176ZQuSXSTNbA47DOKnr8YLS/RlOpLQor6KOBAkiwM64PSWIBki46/5SO0B1hue
	D1LR2/CV4h6AZjRHXcGbSXYSFVmopsCHErgVAuhR/dJze/6e3kjzmDg/ZsqcMNjpOew76z
	aADh5zjLl7c/BhBTR2Bx7ZaoLOBhSS8=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gTMI8lp6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783285081;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KtGhb2uuQghnzvwRekFMe5vHCrkMdKOrMY5ghfXYhj4=;
	b=m1bKIHpn5gq3EGIsnIOQbkVKW9nA/x5SxY1EveBK7wEX5NvLHXmlestf5wxfgd9Qe9C/po
	D6yDusBSft0W2Mz5YrtON19eOL2JLIGeJpjkZHygiXr1c3NyFS5KDbBDwKs0bN/TdovAFd
	DHU8ayZYfW4MeY4kNzoKaf2BRldUQ38=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 648F543C57;
	Sun,  5 Jul 2026 20:58:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8EBB1F000E9;
	Sun,  5 Jul 2026 20:58:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783285081;
	bh=KtGhb2uuQghnzvwRekFMe5vHCrkMdKOrMY5ghfXYhj4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gTMI8lp6qATBOVzhhoeE1r8uORiBxuX8LinFw2RoVESlZwD2Cdg2pNSXqElTaOXvC
	 ZKOsV4icBCeUUaEpYlKbkEHAt9kRboadz1Gg1gwV9q29aiS3bB0B192nnnii7v05ru
	 NCUGnJg/Ocwpz2QEzhRBThu6ldXWPFsLPn92Dwyi9udCOLwgnEG0TZZeTxkxk4LV5e
	 UFOm3Ukxt1ugPLyEAYrPeKDQEZMoHSKDBQri5xq3BIyzN2FcptiMT/q0lyQHL2atVy
	 KHrRUS4FIDKeRih0/LZmHQ6Jii9S3cRoinpTgJED/7p0IS6UI3IWpsShcpuKfQQ1BL
	 S+xCDs2A2CN1g==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 16/16] Docs/ABI/damon: document probe weight file
Date: Sun,  5 Jul 2026 13:57:38 -0700
Message-ID: <20260705205743.98656-17-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260705205743.98656-1-sj@kernel.org>
References: <20260705205743.98656-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D182E160003
X-Rspam-User: 
X-Stat-Signature: j9to5t135xrc1uj71pjqpjukuqzr5cyq
X-Rspamd-Server: rspam03
X-HE-Tag: 1783285081-835759
X-HE-Meta: U2FsdGVkX18qa9gTt3rIzNl/Ry1GCwPaoHCRTTJnX9UBNkZBwSAvU7MH759yPXfJas1F/CN9kOU7QNCwTaz6xNqujRm1RJIFteUw91UsUxLW0UuHEr5wf6P5Sp47eMdOfpNJa58IPNoFR0rc7Q9MuVs3URbTFl7yFD/FFxUx4f6eZ+emrgHanCDo0puA4tylHod7ybACsipMhypiVzqqvudUidha/1e2vkGizvreMyVWN4RAq2tGfDpCgel8ZppZ//LeFlLzrNMjdmAViIhRKZx9/Nw9eA2P1yYmm4FoMScu60zhwxcwPJe/aeVzMLWDFqVEUe/O9VrwEm6WLQvf2fL8h6t04ULuQXr878R70xquZj+qFl5Sz0oBNmAY0xSqqOfr+vTj+PHbhTxgIMfCilBX/1Yoi1Z3XajRmxrHmlMSrHzrcn5Xro0i8WqpGLb1YlqFSBSdFbYxDf49kk+Q+0hdf18wsT2906LHacEGyNDCiKyyJCPSyoxbS9fFswKcQsAnH+Lk8yQWVzj6b2FseJMN5ZP5VQgUGNtL2BT8/wKgfKCMMcgEN8ePOyQzFTNPO2rdZkmIuoFk4/0E04fXS2YSr/2A9O8C/BsTrkWec5jTD996L4ClNTw7JeiDHSxmpk/am1RAfIj1Ak9rS6yf5/jnWEMcbpA4/TyA6zJgvCWE9MBh1g+yIF1VtvCRMnrkancJCBm4Oem4v+8211Jwfjvf3Odto5sNamNlf8XleXYKCdiydw3ENfUeJXTNiS+dKtAknoF1u6kheFbCi8s8ok4Q0ognCXVtOvegAyqu9m55a6BjS5dbGjw3y93fikToQZ9Jhm4Id5wgU8ZbMIxoWrrAQbjyanTGjUqYy6P+8P99RcR15fQVAM97vnAFBu/mwPztU9QKgL0A3Jjh/b5+SoDNz31CkwIy54H4gw5q3HLhmyd9B1nRLwoi/vr3xTi+rxgNoKdYY5zkfVGOapY
 Zm0vlblP
 AqHjSPP44WEDD+Xkilxca2FlyZmPLs4ukpo8eDjrhyoo2aR9jWh4tzW6Q3UULNHZf97Y1rwVR5LcpZu8d5ff3yKPfoTC/msQtDQPDe/5S8H7gXgFwzWWZKN/t8nPjTTiNh5y2Tkg0fU5Sy0hJytZKEOGMwxykKnKjMWZJcYCexfRqo8AskcN3W2DAGrCF2UpgVhCy9Hjsohx/cvEABpFQ5c+NW1+598Wthq8g7wkoBwbcunI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON ABI document for the newly added probe weight sysfs file.

Signed-off-by: SJ Park <sj@kernel.org>
---
 Documentation/ABI/testing/sysfs-kernel-mm-damon | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-kernel-mm-damon b/Documentation/ABI/testing/sysfs-kernel-mm-damon
index dd6b5bd76e119..907a504fb64c5 100644
--- a/Documentation/ABI/testing/sysfs-kernel-mm-damon
+++ b/Documentation/ABI/testing/sysfs-kernel-mm-damon
@@ -164,6 +164,12 @@ Description:	Writing a number 'N' to this file creates the number of
 		directories for each DAMON probe named '0' to 'N-1' under the
 		probes/ directory.
 
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/probes/<P>/weight
+Date:		Jul 2026
+Contact:	SJ Park <sj@kernel.org>
+Description:	Writing to and reading from this file sets and gets the
+		per-probe attribute weight.
+
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/probes/<P>/filters/nr_filters
 Date:		May 2026
 Contact:	SJ Park <sj@kernel.org>
-- 
2.47.3

