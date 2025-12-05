Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2372FD374B9
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 23:17:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1EB2B6B00B1; Fri,  5 Dec 2025 18:17:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C21C6B00B2; Fri,  5 Dec 2025 18:17:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D7F86B00B3; Fri,  5 Dec 2025 18:17:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F16F86B00B1
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 18:17:44 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B32881A0234
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 23:17:44 +0000 (UTC)
X-FDA: 84186981648.16.E29DDA6
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	by imf11.hostedemail.com (Postfix) with ESMTP id 1570D4000D
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 23:17:41 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=hfF1JjKI;
	spf=pass (imf11.hostedemail.com: domain of mfo@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=mfo@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764976662;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tyEwemb7ChIFBMVkjszwjx9ZHzXx/zdKDJEwXVAG4Hc=;
	b=zjMYDGX//3xCKwiD/dgjqvNU8NgSD8iHx4pCdUN9TEFmlQPPpMNAi3P9MRj4FPXhUKDyQO
	U1TOxLMXzoJZlF0iTapGCWWD3trOzbyOpqxIAoQUGk/AxvD+sz15CDTcn2vkKpRSaVkG0t
	MjsW+LCjKXalu34uCfVc54Pd24UWcJE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764976662; a=rsa-sha256;
	cv=none;
	b=m6vyGtXWCt1wyOzoGdLcuvg3QLpZfPx6rxWH6T/1+oufMwPFmHL02bBbxnounpacFiNT07
	75dUJYFQOAB+/EBZ5BoJu79TMHbwGwWf1r1oiVC7FCNp5IcXW+C0d5gZp3PqywsVIvRRiq
	I73OA+MRhKYtb7y8cxsMNFv0rpiQJL4=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=hfF1JjKI;
	spf=pass (imf11.hostedemail.com: domain of mfo@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=mfo@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=tyEwemb7ChIFBMVkjszwjx9ZHzXx/zdKDJEwXVAG4Hc=; b=hfF1JjKIt+5N7QC9PdF0ma/KNM
	XUkV005Wzyo6znqnayCw/CPcZDrqmb8NtxxkYJV6XP0pYvj+AuWCkvErSnXKdfzgZJQtRV2sA6c6n
	b7V55udzFShRG+QW37aovTaGk6DWJthQp2OjpV/xOx3Bj+wZ7Q0pZwT6TdlwbHj3x2yfYlW8bw2ny
	2oDCsajU0T/9fOkjtd/AKX0+G0x264dK2/zlK/2FKIdnvVV5xXNOw7iLX7LFwg4hu4Kj/osFwHXvU
	zl1B1CvZVSDAJ/HoG11lx83WBhcAmzLry3VZgPermw4Rcm/uaZgFH2DEIjKcFIzreDO3m5GOJ2NJT
	2LtlGqeQ==;
Received: from 186-249-144-101.shared.desktop.com.br ([186.249.144.101] helo=t470)
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1vRf3L-009H1j-0c; Sat, 06 Dec 2025 00:17:31 +0100
From: Mauricio Faria de Oliveira <mfo@igalia.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Oscar Salvador <osalvador@suse.de>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-dev@igalia.com
Subject: [PATCH RFC 1/9] mm: add config option SWAP_PAGE_OWNER
Date: Fri,  5 Dec 2025 20:17:13 -0300
Message-ID: <20251205231721.104505-2-mfo@igalia.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251205231721.104505-1-mfo@igalia.com>
References: <20251205231721.104505-1-mfo@igalia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 1570D4000D
X-Stat-Signature: 7j7akbu8z1p4k9yoq6tn3aowtjw8jsku
X-Rspam-User: 
X-HE-Tag: 1764976661-452070
X-HE-Meta: U2FsdGVkX190CduuF96BnFCAKQnWnWJQKHPdQMzC/M/7dcnj1SG6nHFN7t1wA+wYU/DmtHT5agjXZM0FsCeOqmZDxJp/idsxaao77RqNPUpqs3UDTLRi/lgvdNpkOgCNPcOIIphSutQMujW1+1CGzHnFWLYsFHsMQft+B+q5llPDdlSOhqJ/y3rc+WpMawWoOdgR5b9uOuea1sTMuvtY7dupcGMjagflZTnyytMyLMLg5ft1/1nXOY23DhDHew2D6l51QIxL6Pu64mav9vhSzoy8ix79RZfMrCJ7DAbCT0VYoxC+HKbz9nCZbvc8L2PkRJeaC5Dlxa+ZXOB7jUdD07IroFrL91sfn677bGoQjPpYPO/4ERuCFjpkNuDiHyziu5eUrGh6kbgFBlX7xFC50Xh0J0r0nSsCR5sGLr9x0sYwOYHxDi7/8gC+/oC6jYmE3a7QZhO4ShbgpIvXkYScFCZ8MT9iflzIlYKt4+T7A321aYs42xNsc4h1Ukk9tIswiOpFFr70Ovoae9DrRV5ukZJ78AxkcT8KgOABT3l59MDtVVTpvFhZPbFcX8JRwjlrzpHzek88v1p58xNWQkUEvxT9X5Z+o6jOWWVdIWefLxkUL/A3TEVg4tTtRAr+DjYskYX+5s8v5C+xWiDoPEQIUsazz4Ksj/9u7/VEQ57J7N+20KHRqzG+obmcdj3KVaHoVzD8SC4gatI+npTHc6J37nFS3+k+0qUhg/NKpDMfbeZcCzAo5d2GgCtWFHEXCbQMOpeBRuM7oZ9YUnHm2TNE35bwhuJ2eTq+h4Yd7BgPEKLPuozRvKFWER+XxGaPdW0uEX4vteQ7yePe6G7NVDjydkKmWnmkSAte6O19TWTU2GQpEsoeFP6UGkUXFfulLWLKcFpLuspfDDGDpgl/7BO1S4ZqOqYqOc3pgMfobTbQ+xWg0BMIx6e718gMDYsTqpCRaOXLdQoIKSVfXFoO0Tk
 utSAbRpV
 Iu/mJpKVV21jz4mek+FOAtXORmFPmMRCwIwvqT3mKCtFR4lV8J4h536BlQDCB91iBpqBKQ5s29HiSQO5vPAiA/99wu8vr6xlW7G4V+tHGBCxwkMNsRz5R84HKqGk+cYUW5CxXUcVi75ynzScy7lJxX+3gOplxbwhszamIXnKdpbMlwiW63mgvPfpUOpg5AuOEDIqzoYqD7FlZJaOUXwbieXERFTL03drx8vuNnQV8umr8zoOWnaSUKLw4kZBhyqobbWDiA3xC56D7+7dJwmQXTUEEDfdwFK2IUDFf3Jz01pU1NkMzZy7/3iVDZ+RJQaajvG+Z
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add config option for page_owner support for pages in swap space.

Signed-off-by: Mauricio Faria de Oliveira <mfo@igalia.com>
---
 mm/Kconfig.debug | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/mm/Kconfig.debug b/mm/Kconfig.debug
index 7638d75b27db..60bc0b6c3d69 100644
--- a/mm/Kconfig.debug
+++ b/mm/Kconfig.debug
@@ -119,6 +119,15 @@ config PAGE_OWNER
 
 	  If unsure, say N.
 
+config SWAP_PAGE_OWNER
+	bool "Track page owner in swap space (EXPERIMENTAL)"
+	depends on PAGE_OWNER
+	help
+	  This also keeps track of what call chain is the owner of a page
+	  in swap space, maintaining the initial call chain over swap-out
+	  and swap-in (otherwise lost at swap-out and reset at swap-in).
+	  You should pass the "page_owner=on,swap" parameter to enable it.
+
 config PAGE_TABLE_CHECK
 	bool "Check for invalid mappings in user page tables"
 	depends on ARCH_SUPPORTS_PAGE_TABLE_CHECK
-- 
2.51.0


