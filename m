Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BDD00C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 14:43:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED3336B00F0; Mon, 29 Jun 2026 10:43:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EAADE6B00F1; Mon, 29 Jun 2026 10:43:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC1346B00F3; Mon, 29 Jun 2026 10:43:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B8A436B00F0
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 10:43:07 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3A6C712016C
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 14:43:02 +0000 (UTC)
X-FDA: 84933217404.06.247332C
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf06.hostedemail.com (Postfix) with ESMTP id AF9C618000F
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 14:43:00 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=dz7G9Qlz;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf06.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782744180;
	b=Sx1nwSaMLU7rHr/ARL4yFCfO+gUvvtQ+aOCtL0g1+NQi3Ji0EP6uvmKah9nGVWXxUeLRYl
	4vNt9TiaHSJmDHXB8qbqRV8BTPdacKWC0tc8QecPEzL2hlgm0LM/6uRbTkIw0QBGyY1m73
	3/SJjkaI8wmed3NMK/56lImzjBdeiqs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782744180;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d19P2mU7bCvxpx2bi3qQUglg6+PsjCRE3aXSYueMTuY=;
	b=7WYmTp5CTgKaDLXxq2J/9nEjB7v5fbrveG2cdnSKTTyddxEATKYiVER/VfwPP+kANAEiOc
	k5SR5HwgkSMMl8N9cNsEg8dIwdfQ7V0Q0om3DleRUUww/6d6b4L70SsVWA+KuUiRQBuXYO
	DwnUVfKt/hXBZJZlMtYGRwWpGGshFxg=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=dz7G9Qlz;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf06.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=d19P2mU7bCvxpx2bi3qQUglg6+PsjCRE3aXSYueMTuY=; b=dz7G9QlzNFoIsID6LD4Pjo+m6C
	dNDudqJ0G39SpD2jut6j+hjFwpsCa83gRzruCo0UgOzwNooak6+UH9vzFeI8VQqwDOmNBpqJqfCHi
	UkN560Nn4wL8/lHi22vQAw3Pdq/SPB3K6t0Vtbjcfz88+E8vkI4iNq3IQbByuJV3WKwlzbilB6eE5
	5vNZH4txLo4Ajs43ou0b5PjtMl4As1qWleffRk1HkLz9euOnw2TOqEjaQSX2ZEcpX/MbXKwdqjxzh
	gAgrFUbp0JDMGbC5o9qYdCy03uiaFlDPfKOEvpLgNpMcR/GB05wlfr51VG4koncxzG2vorjrKYzdM
	6NTKw2rw==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1weDCN-0000000Euhz-2zoo;
	Mon, 29 Jun 2026 14:42:59 +0000
From: "Liam R. Howlett (Oracle)" <liam@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	maple-tree@lists.infradead.org,
	"Liam R. Howlett (Oracle)" <liam@infradead.org>
Subject: [PATCH 17/18] maple_tree: Fix argument name in header
Date: Mon, 29 Jun 2026 10:41:44 -0400
Message-ID: <20260629144145.1572283-18-liam@infradead.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260629144145.1572283-1-liam@infradead.org>
References: <20260629144145.1572283-1-liam@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: AF9C618000F
X-Rspam-User: 
X-Stat-Signature: h8xuedq7ykyc56wef4r77rmnopu331ma
X-HE-Tag: 1782744180-144152
X-HE-Meta: U2FsdGVkX196tUEjpbjLupHa3MLSF1C70Ucg32Ep96p/0ubKS5Uk8iKhEqRmoITemPYCs43JdIqde91O3LNDYsWSjR8PzXkjkQQNbw9s3SmanD9ghGzdPvKQvspKn32V7Qt3GeZulJ5xrs/zqrotslM9kb0SkRM4TTi5/GopzmhxgJyJ0yNq6sj83cWuuywx8FMXIUMxFzTkEBydAiioBoO4iMH9TM2KNOyhdJI9S/muHKPLsKPLHgAlULn+U7Ke1awuPiYQ2Tx9KQJoAm6iaH/TEIR4Bekw1APc5oSMjy66jxAdXPZT/6EjOYsKE25D0Q7VtPx59bckSeg9RaqoN4wMdFcVSZAY+XzNvsu/MfIK71132va+bJF8ZnXTE7sAeRZIc6vBrI0W7HTZmaGKs9WnHhJ0TBLkVD+zCCncmLeWy45hkyPHeLoc6qPIxYzZh6dOJGaku3h1ibBZwNKzZS8+6srMSsbXTqAfC7V337heYeU7awGi7oOrg6akUZD+DL0zQubPoWCQuq+XUcuk1ZPooqcvgeQYdBCPbR93E2On39RhCyolyBYIFukT1Zv76h/odl1BjGGacLaFAvRudb2m4Pk4rqJBx3WcoVe+TC+pGuAwf/O6NYv8UH/waq5rBBZbj/QK+if14geNv5A3Q2yeRXfaFIMw37BxSdcEY1IyXe2BTpXpgvVjvDKRPl6y8Jicz3zOMi7UaeKQgoF20gqxDEHZdgkcae0mZa7rn2i1UPUKuQ+o6R4FUclIW7A9Krg+hcM2qvfTk9nloZAePCFoc6W9J6Qp93bSV27ZljeMTOqaJJfh6ve8YF82bNDcqkYuqAX8+cygtTpjoWTNORVARswN1PelTHtw5gH27hHArLC7za82NMT8Q1yRPL53kgHL5vHCOg53N0Mukok/+VKeCO1r+eA+buXUeTKFq75VsTbvvgMZ8xHHSHaNESnH6xxZtA4S8OqBhJe+c2S
 sdSF7KVa
 0HZTuXOfR45E+WRFcHWbN6yUjwK/MzweWIoSx0Kqu/oKb7VWn639KRWQrcq7CVuSGCHP9JXEsmyaVyBdOYD8i40opmtWyICn3RW8EsV/gVndGPsMA9YEpviO+7QRcgQ1ZKIBZO902ZXk/ic7VJxcRC4u0z+x2SrqMF9NLAqEfmBcZpAN8hRAVWe88anO5J5xenKbha5NoDwIHpt22mfCqnrFg0BNsx2z51c7f31hAL9aiuVde3OdwdklbUU/esvQr5pDXjF9VoJ/alCzQQV1xw4B9/BjdrVU3b1eNef1Pqs2329BvAdSBpQJ8Dah/p0YcD+VNZ/NICkTMjiTAqZh/r4DGWA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The mas_prev_range() function takes a min and not a max.

Fixes: 6b9e93e010204 ("maple_tree: add mas_prev_range() and mas_find_range_rev interface")
Signed-off-by: Liam R. Howlett (Oracle) <liam@infradead.org>
---
 include/linux/maple_tree.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/maple_tree.h b/include/linux/maple_tree.h
index 346eae48cf15e..5e0bd2857d941 100644
--- a/include/linux/maple_tree.h
+++ b/include/linux/maple_tree.h
@@ -576,7 +576,7 @@ void maple_tree_init(void);
 void mas_destroy(struct ma_state *mas);
 
 void *mas_prev(struct ma_state *mas, unsigned long min);
-void *mas_prev_range(struct ma_state *mas, unsigned long max);
+void *mas_prev_range(struct ma_state *mas, unsigned long min);
 void *mas_next(struct ma_state *mas, unsigned long max);
 void *mas_next_range(struct ma_state *mas, unsigned long max);
 
-- 
2.47.3


