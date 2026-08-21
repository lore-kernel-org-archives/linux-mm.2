Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 011BAC5DF7D
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 19:27:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1791F6B00A4; Fri, 21 Aug 2026 15:26:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 12B276B00A5; Fri, 21 Aug 2026 15:26:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE67A6B00A6; Fri, 21 Aug 2026 15:26:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C35836B00A4
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 15:26:55 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 65FA3A01E8
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 19:26:55 +0000 (UTC)
X-FDA: 85126259190.07.50A47D7
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf03.hostedemail.com (Postfix) with ESMTP id D1A4620009
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 19:26:53 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=Nlo7RAsv;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf03.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787340413;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HuCMNZFX29nK0huvkCpXKIwQOO+TOzQ1a8HPZnuSBHE=;
	b=S7O+iSs51hyv2egqQ1raGvQOBCNqRyE8W726Ujix9PfGoSH5s1r+U9E6V6GjPfR39i+ttO
	TkkFU+Or1CKdpqefuqIXbTC0eDbV6IlT83wHq7T8p0hDrCJogeSG/4sLNZo/MKVOJt02aK
	gmTCFZTCSr9hRRb7Tkt7hGgDMkDnt14=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=Nlo7RAsv;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf03.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787340413;
	b=UyB9Mu6Griz7sEX6gkNFQwYlU6e9U6999k2a2++u+djJKQjypMuAxSPpgJl9ae7Bukwkeq
	DAzJfBAAWTHGvmnjRRRis5zwuxu13R+W0dBPJZdlfiiwW49txxil0oofll915vJ0+2yAwW
	0By9gN8pF9XOBdxLlxaFXHKRTqeuR64=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=HuCMNZFX29nK0huvkCpXKIwQOO+TOzQ1a8HPZnuSBHE=; b=Nlo7RAsvW5ogeTKJalkhOFmKuB
	ax+0nGH4da5jAqa2xbz7XC2xHJ37nXGZINH9wOLcfo1VyP6PugLCkoD4Sij3tKpgHd9dArPZDNs3O
	QKqzR12bwjSGrzc/uT0cpz0ia5p9CRp1nWZ3b6anlMMnZXkSJuBt9az4aFB8o/z9jHgfHUlYtqjeA
	UBnbYE/mV2CG1yWAigrkIcc9fB6gNubXSyAzATrz5+7JgB8IPNCibXL8DD958MIxGAOe/ikjKwPXr
	Yn8eaWu3VPvx9ob6OEi/mOzL7hIzTnCyIM3gaBRX4+u0lHH6X8RcTJy9/aVtKGVvfXpbMY2M7IxBt
	Fyywh4eA==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wxUtA-0000000E0kA-3G8m;
	Fri, 21 Aug 2026 19:26:52 +0000
From: "Liam R. Howlett (Oracle)" <liam@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	maple-tree@lists.infradead.org,
	"Liam R. Howlett (Oracle)" <liam@infradead.org>
Subject: [PATCH v3 08/19] maple_tree: Use prefetched value in mas_wr_store_type()
Date: Fri, 21 Aug 2026 15:26:16 -0400
Message-ID: <20260821192627.4085470-9-liam@infradead.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260821192627.4085470-1-liam@infradead.org>
References: <20260821192627.4085470-1-liam@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: kojjsxi1twgu67wxooofkqaamjgfkxo3
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D1A4620009
X-HE-Tag: 1787340413-833062
X-HE-Meta: U2FsdGVkX19sPOqeO8iOQ0S5T8zXYZGlykrqHee97IBU8hf6futV8iwMOEWLWNr005Sm0X6xnO4X9DU5t5xm7dU4YzlF0fQDSY7B0x85rDczv1tW8gmV9dj0j9ZTezNPloRxaIhij0qn1MrtS7N8BsagAQuf/l80fXYGcPdhtTvuh7boGbEwzgbbCcy9/2smTft9VX3ZD5Wjws907QpxgANFA+yeHPTmEAWbxeGYLLrKMeoPB4QnCa6zwvD0TneC0iMBbU/R5iS5HA2FCpNaFkSioKzBVcLuKZOcaKNHHADUJD2ZIEGzdxy7QW6yukWDhQkspUP/GM5KRm5pRz/ssWI1Q5q4XM7ue+E2ViqOFRnrwnkT7S4WeJOMbe6l/ngjlfeHaFG5Nq3OyxedPJI6ght2KtQjCDq6NgpQ+IiAi64kahqdb4AZtwa2KrIzqkA4WQY+rrBZqPLipWCe8hNgByG1rnA4etMsohrT8Faq0qXAges3FE2Bf/BEcKrY+dUuEHsfP8MLLcW6jmU3lTPRgY9T9azPVhPnaK2o4BbC2nUYnYKuVzXUKdrWhdLjfjYZ9YYXk9VJ3PZUB5AIiGLyUa1+CT+e/xkhHZPCrAo8p0SeTlglqaPPe2O4MKgDHkI4n36CQoqRDXurvmjvBBumA3gPLCYn3Sw5CV73DCjdnxFlc0Cv0Uchw9SB919QaGD81NR1vESCiKjfyKVy4RkQYdyZLwCtwA/SLTtW8/szhBZgzG8pIVkwmXUcXFQzB6BJXUZdW5Q8mreSeE/FbTN3+SdhLynTctQ0ylCE+ESny7bAeAM1SX2sxfqM7F73ARzSrWwY1uvyAq4EQSoeqXxCsENlho/P+b0xdEkGvuTKLgaJYwjSpeT2HgLUYPSEYojIOI0xB/Upyj62y8HOpucPmWaURZo/S2H/28vYMY8s6iQETp4yyAiSmNJBy/46l+YZsuhkB9YtDRWIWPuvk8k
 pomJo8II
 oJ/DCrJQ0X/4FMMsyelv8AO7KSYsx9TE+idIwgFgPkyPoBya7lmuY8xcuBNTxqxhzqe6Tf9dgCqxgWsO0mQRLbuBmdusHAVunW1rnowavQU60EGgFHV+YBH5fpWLq9cZkPC64DgWOpF5b41N4QK0lq4uOIKNO6xl00fBFs0EFiS1U5ANqnbw4becCF+f2pG/CkdT8WeYxAtVRmNQFDEHoO6HIhBE4/t4IPl7nwYqAsM3RfPjkMhN/c7oEisAHFN6Ri4ZMydWrVYyEL83Iy2U8R/KJuRej3t6+HZ6qFtbgYkdGBGHxj7N5dI7QQgh/6HMleTDryiTc6pow1PJdh+4whVMTbQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The slot contents exist in wr_mas->content, which has less overhead than
reading the slot again.

Signed-off-by: Liam R. Howlett (Oracle) <liam@infradead.org>
---
 lib/maple_tree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index baaaa128594c2..d5fa85bc7aab0 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -3280,7 +3280,7 @@ static inline void mas_wr_slot_store(struct ma_wr_state *wr_mas)
 	void __rcu **slots = wr_mas->slots;
 	bool gap = false;
 
-	gap |= !mt_slot_locked(mas->tree, slots, offset);
+	gap |= !wr_mas->content;
 	gap |= !mt_slot_locked(mas->tree, slots, offset + 1);
 
 	if (wr_mas->offset_end - offset == 1) {
-- 
2.47.3


