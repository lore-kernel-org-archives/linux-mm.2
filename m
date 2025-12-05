Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4896D374B9
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 23:17:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5BBBA6B00B3; Fri,  5 Dec 2025 18:17:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 592D06B00B6; Fri,  5 Dec 2025 18:17:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4AF736B00B3; Fri,  5 Dec 2025 18:17:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3255B6B00B3
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 18:17:53 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E73A216034C
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 23:17:52 +0000 (UTC)
X-FDA: 84186981984.07.F758426
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	by imf26.hostedemail.com (Postfix) with ESMTP id 4BCAF140002
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 23:17:50 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=Mct+QkEM;
	spf=pass (imf26.hostedemail.com: domain of mfo@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=mfo@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764976671;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=goR+WqcbB55j9ZAy/tMbooRHEqLXnxJL/84hfNlIvBI=;
	b=ce5xANb+NKWVydoj8Onz6tlgm+kfKaFgcK64l049dhtqN5CISSo4eNoMipzswHnaHA2m5G
	nRnp1wR3YIK9frqwhekFU1f5fFCPRwgT1W0BsP7kTfMFABmkCvzez2WpDJ8aoXHTf62qhH
	5XP2hyn/+IMI7HveOtNvtqxx5tCYIvE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764976671; a=rsa-sha256;
	cv=none;
	b=aemgSQ4lBYEkqqVOgW+kGLq4izjttqkifD6j+cR4QOju7NVtTU0ishMN1ceUfOu7BXsC7E
	ZlXzY5YCRPaK58aj503iDx7rYttpS5WQlpq6o0Ut2zsbS7iesOHJzoBso2hSgrR71rW4eT
	JK56k4/ZEsPY6w8+a1HcVLYoJ+Z/bjs=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=Mct+QkEM;
	spf=pass (imf26.hostedemail.com: domain of mfo@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=mfo@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=goR+WqcbB55j9ZAy/tMbooRHEqLXnxJL/84hfNlIvBI=; b=Mct+QkEMlaca0HtaZSx95oFN1Z
	yvNsIXWNEtGq0Ov1m72JaqurgvEV9AqdX54sLUzE1SbV/uK8d8wLOJ/oEpgDsm4XkPJ5BzKbog56W
	d5/ufYWCE6PfDfJMo6lIXK0UkrU3tk03rZlWpbcdu0VvL+JKDCYM7Ee8tnPIQ462P8q/eidpKhEQ7
	GzNkfpVz0X6RsU/4FiIzaQNOy67RGrY2/9LsKHwmr1ps/klgNB8tQWC6uQxulMGstuVJIZxGsgQXh
	7lsgB8ESnjNldrE1WXLEVQRFyEoAcK4TikSvZTDo4SpyS6nDf4wSPtqC0cwUn/8ICWKIF4ROIwYcV
	GpTH2new==;
Received: from 186-249-144-101.shared.desktop.com.br ([186.249.144.101] helo=t470)
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1vRf3X-009H1j-6m; Sat, 06 Dec 2025 00:17:43 +0100
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
Subject: [PATCH RFC 4/9] mm/page_owner: add 'xarray swap_page_owners' and helpers
Date: Fri,  5 Dec 2025 20:17:16 -0300
Message-ID: <20251205231721.104505-5-mfo@igalia.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251205231721.104505-1-mfo@igalia.com>
References: <20251205231721.104505-1-mfo@igalia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 4BCAF140002
X-Stat-Signature: 9tfmcokp8ingp1763mi7fc6ntcwspkox
X-Rspam-User: 
X-HE-Tag: 1764976670-581701
X-HE-Meta: U2FsdGVkX18ae3SIY4uNoH07VyrD92xL61pSrXxxGSLcFP9MD8Os6S5o5+WzHtE2or5sZBuMLZOYo/qGpT9jiLssv8IZpyDekCgoaBCvztoHRaIRh2c4m8JOLh/PB9z/yyhAi0/CQdtOAGA/1nzu/SdkKjMyhTVlilvR6vamESAX33Mn+me8VkeoK5zwW3tcxe3YRgCQTxK+qbsc7rvtz6Q/KwYNIuvkQZTc25eyS4Y+Gr+LzZIaa9UhijEi9dLopYDsLSRO6wKfUSaJhHEiTPcjic8AFF4t06Qs72Yc9m21JuYCl7ntRB1jQJhLgzP7EIim0wE0pDqZB1Uu70skPhph+ltgU411KfvfL1aC2bPFsiFnIPpT87i/md5NdLUEycbOMFZDGs4X2jeN712I6trM4d+T7ItgRldt7HkiRkKAVhwKBqamW4NkezZAITFmoweBd8GNgnSVdGwvQHqb/qZnnG5QQFE3LXI98C/kLYLBp2lgByOZlu/QZ0+edI2Awcg+KHvi/aFnDdOy5xqvYGKorA9Mtplmiu0DREekQ3Yv4OTC38Sv+YnOGGyjdNLxColsm8ONkugmOWz1Je+nFZFmi+tYX9nBVk3dwlji4tEZm0xViEXRgGvYBxSGpzwWawet7kew9I3widDTn0lBJs9iUsFZqc9yudn0z0/8oywwtjUj9msAipsolXsC89XsJ3EXAHjRyX9kHQcSX5x+wKBMmXl8qjrAWyUzlJoU/a1SOwR3Bxkj3C1AA6vn9qrRL2ate1rIkH5ulvc/TnM0WRO0mSVy+275ntEXohW3CGcEEt/Qwke716J1GW0SOubZh0SJNv0ieIaqXahTHZGQyZS52fGg44GsD8FKTFD78SbYY1BtQuE7ionMpyr67w4IOBrwJ7Imnj2z36+uEfMxZ8zTrHV4RgnlDT9PElmxOthmxe0NT6YEy45QFN0kmGeOiwFVFhkpE/XPeC2tqg8
 6qitU17Q
 /Q4X6CZ31aaxvK5MICJ1WYPC/3opYTzeMmAr7us3ZYrPAkcyLVk1hYvmfsuJTt51d3jrOF0ba4cuQiodGHerQm+ND/D6hRUpxlEodQ4yKQvgcdMUmW/TNKCmD5787sFUPQhSrVo0cv7pSdGXUJxq3G156b9KnOfT6Hr0oCRFekUjW1ZacmoJcw4B2rKJybApNYP2HI+bPCH754HSZ6zw1a8O/EwkddbnTsppnCPvNRmPPaE/rray9vvPzIOdrabviP4QCmDOMHkmFi26gOzAtH3mojcKy+51kx5yyIf2NOxxM6Kffa3LoGEBfLlZqqDO+X14P
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add 'xarray swap_page_owners' to index 'struct swap_page_owner' objects
by key 'swp_entry_t', and helpers to store, load, and erase.

This is used to track the allocation stack trace of pages in swap space.

Signed-off-by: Mauricio Faria de Oliveira <mfo@igalia.com>
---
 mm/page_owner.c | 45 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/mm/page_owner.c b/mm/page_owner.c
index 19ccbda1c2a4..5cd7de1f8023 100644
--- a/mm/page_owner.c
+++ b/mm/page_owner.c
@@ -68,6 +68,7 @@ struct swap_page_owner {
 	pid_t pid;
 	pid_t tgid;
 };
+static DEFINE_XARRAY(swap_page_owners);
 #endif
 
 static depot_stack_handle_t dummy_handle;
@@ -461,6 +462,50 @@ static void free_swap_page_owner(void *spo)
 	kfree(spo);
 }
 
+static int store_swap_page_owner(struct swap_page_owner *spo, swp_entry_t entry)
+{
+	/* lookup the swap entry.val from the page */
+	void *ret = xa_store(&swap_page_owners, entry.val, spo, GFP_KERNEL);
+
+	if (WARN(xa_is_err(ret),
+	    "page_owner: swap: swp_entry not stored (%lu)\n", entry.val)) {
+		free_swap_page_owner(spo);
+		return xa_err(ret);
+	} else if (ret) {
+		/* Entry is being replaced, free the old entry */
+		free_swap_page_owner(ret);
+	}
+
+	return 0;
+}
+
+static void *load_swap_page_owner(swp_entry_t entry)
+{
+	void *spo = xa_load(&swap_page_owners, entry.val);
+
+	if (WARN(!spo,
+	    "page_owner: swap: swp_entry not loaded (%lu)\n", entry.val))
+		return NULL;
+
+	return spo;
+}
+
+static void erase_swap_page_owner(swp_entry_t entry, bool lock)
+{
+	void *spo;
+
+	if (lock)
+		spo = xa_erase(&swap_page_owners, entry.val);
+	else
+		spo = __xa_erase(&swap_page_owners, entry.val);
+
+	if (WARN(!spo,
+	    "page_owner: swap: swp_entry not erased (%lu)\n", entry.val))
+		return;
+
+	free_swap_page_owner(spo);
+}
+
 static void copy_to_swap_page_owner(struct swap_page_owner *spo,
 				    struct page_owner *page_owner)
 {
-- 
2.51.0


