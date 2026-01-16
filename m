Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A5BDD47CC3
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 10:12:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E16F66B0089; Fri, 16 Jan 2026 05:12:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DCD796B008A; Fri, 16 Jan 2026 05:12:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D21806B008C; Fri, 16 Jan 2026 05:12:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C3B6B6B0089
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 05:12:52 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 73F69BA432
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 10:12:52 +0000 (UTC)
X-FDA: 84337413384.07.6F06480
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	by imf05.hostedemail.com (Postfix) with ESMTP id 9A989100003
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 10:12:49 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=r9GKOMiU;
	spf=pass (imf05.hostedemail.com: domain of kundan.kumar@samsung.com designates 203.254.224.25 as permitted sender) smtp.mailfrom=kundan.kumar@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768558370;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=io11MxPXJQPqxLL7iBBOqNZeozDs1uZ30NCX7CyvzRU=;
	b=l6Obgc+Btnde+frNhHADc156T4pELDT1Cl1TMpzULzvO73+1vaE4B2BanLJMz9ie1bgoty
	Sn45XvUW9WIydtv2BvGMsoZsyVj+6psijFHwNhMRO8RjYntGHa10C0dqazFxwRTqjiNLrf
	JeR9nmL5uTLDGCPPaGLjXF/DH02pfCo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768558370; a=rsa-sha256;
	cv=none;
	b=PkEV5fxdvmh/PaH7YMaHkTFViAJ+G6ZBW+3PbsX1/RjO+2KYdca26BNj1FuJfYA27s7UO8
	29Gwfzuui8wNvw+/12uYoisZIc0fqxtLnV56PysZ/s9s74okONTpzRUZCcRE9nnDZXfXWu
	9uzGdKgEYOtXFSKXGwAddBrWzp02S7w=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=r9GKOMiU;
	spf=pass (imf05.hostedemail.com: domain of kundan.kumar@samsung.com designates 203.254.224.25 as permitted sender) smtp.mailfrom=kundan.kumar@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20260116101244epoutp02de4dbbdd70612d31394dcdf4329abbe7~LLnZalmvQ0393703937epoutp02-
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 10:12:44 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20260116101244epoutp02de4dbbdd70612d31394dcdf4329abbe7~LLnZalmvQ0393703937epoutp02-
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1768558364;
	bh=io11MxPXJQPqxLL7iBBOqNZeozDs1uZ30NCX7CyvzRU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r9GKOMiUp4gMUSjo7I+MJWiU0PhbHZnnLMKxCxJhCqoR/3U1cti+BkpWZy/3J9SWN
	 7+PvkOulg75I3vTEXzE/h/nue9r9zLCTZ38LL1hlC53ixcqhzGmyi8MnBGv5SC7RBS
	 VtUnaMHRDH4Co1HU/U8C5ko703Vxc3Z3ofr+U1/w=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPS id
	20260116101243epcas5p47d3397b5b858e03c77f31f6d97ac320b~LLnYhgzZO1433714337epcas5p4H;
	Fri, 16 Jan 2026 10:12:43 +0000 (GMT)
Received: from epcas5p4.samsung.com (unknown [182.195.38.86]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4dswdk4KvQz6B9m7; Fri, 16 Jan
	2026 10:12:42 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20260116101241epcas5p330f9c335a096aaaefda4b7d3c38d6038~LLnWulmW_3171431714epcas5p3C;
	Fri, 16 Jan 2026 10:12:41 +0000 (GMT)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20260116101236epsmtip2df6f615c786d09af2b4885187f14ddda~LLnSEDhFj0634506345epsmtip29;
	Fri, 16 Jan 2026 10:12:36 +0000 (GMT)
From: Kundan Kumar <kundan.kumar@samsung.com>
To: viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz,
	willy@infradead.org, mcgrof@kernel.org, clm@meta.com, david@fromorbit.com,
	amir73il@gmail.com, axboe@kernel.dk, hch@lst.de, ritesh.list@gmail.com,
	djwong@kernel.org, dave@stgolabs.net, cem@kernel.org, wangyufei@vivo.com
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-xfs@vger.kernel.org, gost.dev@samsung.com, kundan.kumar@samsung.com,
	anuj20.g@samsung.com, vishak.g@samsung.com, joshi.k@samsung.com
Subject: [PATCH v3 1/6] iomap: add write ops hook to attach metadata to
 folios
Date: Fri, 16 Jan 2026 15:38:13 +0530
Message-Id: <20260116100818.7576-2-kundan.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260116100818.7576-1-kundan.kumar@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260116101241epcas5p330f9c335a096aaaefda4b7d3c38d6038
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260116101241epcas5p330f9c335a096aaaefda4b7d3c38d6038
References: <20260116100818.7576-1-kundan.kumar@samsung.com>
	<CGME20260116101241epcas5p330f9c335a096aaaefda4b7d3c38d6038@epcas5p3.samsung.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9A989100003
X-Rspam-User: 
X-Stat-Signature: s8ceq3gt8h9rmq6fioznbgyg4xueauxf
X-HE-Tag: 1768558369-979668
X-HE-Meta: U2FsdGVkX18SwPIjG/pc0bL2VbcJXXIIdLcTa1E7G3cZIwo6rEeyDlv+zsN7t+yCfBmifHH+crbX4I2xDXPNS+s+1vwRIzwHNb2wINr1zoc43xnHZKUHYAhdBP6f3JsLyQCTPUOMrSWfdGOAUh5UNC6tMoZJvC7sUfDkRx7UsWx8BP0YAuBi8U5KRamXdtPgqDl05ByNKMGNomi/UzzNjGKDBYjBCI3D3QG2oF3y04Bfsna7ZiT5yk3LTG1olnBFnvZaDhO2Chh9pWnp7mD8atxHR6oLF+kD5fyWGd39o0QCZExbu4fG9/Zd1AG76QwaVqYiOZ5zLbrCBvwzBt9Zr7Jh+bVtgHg1qfWIsljp2T0hf1Gkwh2ParNsPpwVnqd+grLJMQAhYFNGttHypklsewsiYYDfuKsbWm3ivUa/f1EnkUjxyRb/yU7hxOXxsnsbo8B6b2nVXUt4S7fzavgqsLnCQuUdnKlAPZ+2Q864+OhG3Q57KRbDVipu1b/vk9QOH6YSEpdzljRW2D/nOueg5Nn2M43pMlGg++cE0XSS1qXejsfiqgyxCto+OZ5sbn+E00EhFxZw6fwASmQ6OtYAsKQh5Y+sTabs7bWDGEoPEOe+/vzhomD2z+bO3g1H49BvellLume8idfrMl9cGBN2TdBdZKGQTdtpq3H6uqJ+1Ssn95iJgCpT4XdlulsuJcSCzo6j4GDWu5DlUPiP72+R82MSM2r7LONTOfOoTOjNnNT0HsrNLyJ0GN/g0jUoyH+9UtPXZsZlYOENE+x2M/QB4lq7BQbmjvkGG4vFOB/Ete1dAoziodSrHmOhUkDSEGnbV3N6FOANftTdDYKJuzmUGn7tS0yPBx6tKFPbmUNQJ+LglhUV0g7Ha7w8T/XQAXIFrbVohxr1Q4jQhH5CdVuWIsPn2jKUYFm9KrHAOnW+rmwYWdweV1KGJ3oT17DcH+XTNIrD6QoJc01HGw2yADP
 /1Q+iUZG
 u1U2sS9hdoxJqoeuaS8i9T6FniSnk7WMl2GzMGdee7CVGhtRZmzuZBTbI+VsuQkHz/hybugOjmVJ0x7qpRHSnRJuOIFuFT8JJXutAW+PfJ25k6Pl6GViivGb2RA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add an optional iomap_attach_folio callback to struct iomap_write_ops.
Filesystems may use this hook to tag folios during write-begin without
changing iomap core behavior.

Signed-off-by: Kundan Kumar <kundan.kumar@samsung.com>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 fs/iomap/buffered-io.c | 3 +++
 include/linux/iomap.h  | 3 +++
 2 files changed, 6 insertions(+)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 8b847a1e27f1..701f2e9cd010 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -699,6 +699,9 @@ static int __iomap_write_begin(const struct iomap_iter *iter,
 	size_t from = offset_in_folio(folio, pos), to = from + len;
 	size_t poff, plen;
 
+	if (write_ops && write_ops->tag_folio)
+		write_ops->tag_folio(&iter->iomap, folio, pos, len);
+
 	/*
 	 * If the write or zeroing completely overlaps the current folio, then
 	 * entire folio will be dirtied so there is no need for
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 73dceabc21c8..14ef88f8ee84 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -176,6 +176,9 @@ struct iomap_write_ops {
 	 */
 	int (*read_folio_range)(const struct iomap_iter *iter,
 			struct folio *folio, loff_t pos, size_t len);
+
+	void (*tag_folio)(const struct iomap *iomap,
+			struct folio *folio,  loff_t pos, size_t len);
 };
 
 /*
-- 
2.25.1


