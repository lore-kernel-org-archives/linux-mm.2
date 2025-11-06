Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60EF0CCFA13
	for <linux-mm@archiver.kernel.org>; Thu,  6 Nov 2025 20:33:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C02C28E0005; Thu,  6 Nov 2025 15:33:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BDA748E0002; Thu,  6 Nov 2025 15:33:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF06F8E0005; Thu,  6 Nov 2025 15:33:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A05258E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 15:33:46 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2C4EC160260
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 20:33:46 +0000 (UTC)
X-FDA: 84081333252.06.0467194
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf13.hostedemail.com (Postfix) with ESMTP id 5B6082000C
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 20:33:44 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="WtxK/fPw";
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf13.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762461224; a=rsa-sha256;
	cv=none;
	b=BCZ1qZMp34HTtQlg6GUIUZMW4NL/L3CGnJy5v3jTXL1C41IruPhGJaqeoDnfYaV4nXV3OD
	UVx17zN3AhKnKvTAAcyuP1OjZyQL7XGoXd+VC0uaixTyGuIWVG3IuKEfJL70LRgDEQLMwL
	8iRszkMZxcccnobC6P0Djey3avcJ6p4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="WtxK/fPw";
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf13.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762461224;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Wo07XL0+qnCecp6ihEJiFp/vOu/447s0Za/pjvt44nY=;
	b=3WVXD+KG6/qgiuFm2SH8byJ1/v4r54+8XSSFmU2ECBh424s5dA3PIAjgNyArvTG/k5yBN6
	gzSN2nHWAUpL/AJTiY1N8q3XYX6kc9C9ON+/GnLGEeqg31Ut5rpwJXn3QhxZa/PjwtxqtZ
	lAkbcVFVeGgFN7jcBr9TFGuAIOu9Geo=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=Wo07XL0+qnCecp6ihEJiFp/vOu/447s0Za/pjvt44nY=; b=WtxK/fPwd+kjhz9Nxx4/WYP1ie
	r/937eA1dMjfZ+wlnJmnvdaTzde2QtRbUDBgCTWUqMSB9UIR+lonfS/bcHGCO57PRlqwWCFTxo1kS
	UJWY76SPr55sl0EOEOM89Hj91cWy37Jtk20+dxGhdIdZtfUs4HB7x/Zmd15XtRSz4VmWBiEjGkozY
	49DI0NnDZ64ezl5KJA/SwJLDvbFZzSLJQ0WASeZ3/GGJiXkNt2xrOeeBvZPjlM2Di8PWtovgndp3y
	qcY/gtpgZO//S6+EsU8kZcuw8zFRS3fzIstO0NNdfbjY6U9gZKpuTYEZxNDvY8ezUoqCJCBMLtmky
	LxJ9t9lw==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vH6fu-00000009uVa-3f1u;
	Thu, 06 Nov 2025 20:33:42 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	linux-mm@kvack.org
Subject: [PATCH] mm: Constify __dump_folio() arguments
Date: Thu,  6 Nov 2025 20:33:39 +0000
Message-ID: <20251106203341.2362005-1-willy@infradead.org>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5B6082000C
X-Stat-Signature: aiz6ztutydaadn98mtkwkhie1xt8wdq5
X-HE-Tag: 1762461224-459838
X-HE-Meta: U2FsdGVkX1+xDsUt9MKwLZh4GRxn9IT6PV108yhwAF90NTp4z+FZWGW7yUiHNA1qPefJjMpiDaCHPE5YTM0RVBYYXPo8UZegeB+8xramnigpYPEgGB5oRGSs82aXUh0akWhFC+aRIYfTUG8kbY0tBF6JMIYjHQwQTawpbsCzjjkjEfyrRHLUjLjYnt9iVhbcGQ+hNZZFJrxskHLuSYc2C2JaHzrhLBW7QnPiYYwIfpVv8jhyJjjUC6yXIf6qrXhO7Ab9GmDIkhH28FwsZ6k5oIRu9cmhNCRyl+1u8JEx6Nak0XoXzux5OA+S4DGUH3OVDuW37huvkl1PY1GtiFvRN1oz2JJwTw/8dVd/+8tM2Om/JgepQYHCuho5rSTsxmPwFesMxiLh0f+GhkC+Gon7K1n1qKcyQrNpEHvwX/zaWAKHPAAVusVu6JrbM+1mVuFF2Pgi+P5XMKWUxrUvMzgSGkAVvNXqoz7B6nQzQSjIovitQbojGn+eBNtsiD3FU7ieBA998B4PvxtRxKLfZqhxp2A/YXyctUaSREj3gxCKvSjSMUdHIlEH+70JSbMWGeFZtbfzx0v8RhBadmWAqL5jUi0gwvRYXAz+j3VpExERIa2cvIUfjtbmlyRyD2c9DCWTqgn6EGvLlCMwED1HDOIuOIETIbYVplx3lByHJxBDzHA/3wUKAy/Gh9DOonTERpDaVbSEyoMR/6ff9p3GrBX8Yc9ostZLWGrPFeWMZLNaqe6F0SGNOWGeB6UMR1XlvMnbT6oLaJUPjAs7lMV1Yhs5rMFnIpq80V53lnYX0sQ3mTgz4FHmqYN4dfflIF4B9egfssIP3uf+aoA+6X7HesNoLrnnZ6BhPxVK6VSpf3xFJfDjFWj9saDsl/N3ETj0hcgFXMEqtuJVtjq/fGBqJ3DVGtyJxpCUGG7wN/WdTfkADdqcSPyg3cGfhyX6r/fDgv5RG6sVDCzV459KzH3Y8tO
 k60VVDlo
 JCXu8iOE2o/EVEJyPJwHooR3VX8vGeZ8FUhRw0p8QwBrA5io49XSnbn3XeLenLTfzeWz6NUzrqsaF3uBVfTU7B3INdAlLX4CfP2k6aREXKtNtOI0Ib8uknC/875K0ycVDVErcDJkCN4/XMqvGfupDFz8jWKKkLcoq6CTiiBEc+RGM9tY3uZwYCdEWSD9SqtdoQV78R3ucIc3D2l7qSey0CHE4N6uPvXLJolO2M/+iXGRFL1IxM1tVDZDmgRjfPdm46BMor5/vCNDubj+o097w+eSYm9lKCMlCpROqDfw9EShlrYiVp/b7x33lJw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

These arguments aren't modified by the function; mark them as const to
help the compiler.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 mm/debug.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/debug.c b/mm/debug.c
index 64ddb0c4b4be..81f03e185d29 100644
--- a/mm/debug.c
+++ b/mm/debug.c
@@ -67,7 +67,7 @@ static const char *page_type_name(unsigned int page_type)
 	return page_type_names[i];
 }
 
-static void __dump_folio(struct folio *folio, struct page *page,
+static void __dump_folio(const struct folio *folio, struct page *page,
 		unsigned long pfn, unsigned long idx)
 {
 	struct address_space *mapping = folio_mapping(folio);
-- 
2.47.2


