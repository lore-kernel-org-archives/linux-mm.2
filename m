Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA639C87FD2
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 08:42:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C3726B013B; Mon, 11 Aug 2025 04:42:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 874286B013C; Mon, 11 Aug 2025 04:42:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78A226B013D; Mon, 11 Aug 2025 04:42:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 655386B013B
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 04:42:04 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 18FDD137C5E
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 08:42:04 +0000 (UTC)
X-FDA: 83763834168.03.66909B3
Received: from mout-p-201.mailbox.org (mout-p-201.mailbox.org [80.241.56.171])
	by imf21.hostedemail.com (Postfix) with ESMTP id 2DA7D1C000B
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 08:42:01 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=pankajraghav.com header.s=MBO0001 header.b=nr+YHUy3;
	spf=pass (imf21.hostedemail.com: domain of kernel@pankajraghav.com designates 80.241.56.171 as permitted sender) smtp.mailfrom=kernel@pankajraghav.com;
	dmarc=pass (policy=quarantine) header.from=pankajraghav.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754901722;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lNDD6Lspe3zTqDVuRc5jRvkT84xxqlND6jbD75Q1wQI=;
	b=nYmOtgiz0PLQ9gN2RBwjec2ZmGHex4IGAUM0FBHwG8H8mYId4b37DHNIRSL60CQYS88+lM
	vJ1HSEodzOw46C7Gu4/gxJL+IN1TfaM0Da588cxZjGioP3Bf/UZtlx3yUN36XUhxrwkUDI
	tYWRePYhP7i/YAWq+LVjGOOLtejaQvg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754901722; a=rsa-sha256;
	cv=none;
	b=qTfJgCBFia2yN91df7xclrPevpDRCSSS2bynGqErkLkY9mmJB6yP/tydOSaS05+S+J8ykK
	c7KJORa9BoLhOnVxylTn05AIQj1ZQ5ECkCEjhbt4NkMV5k/Le92mrKg8OepJDo7PxAmMwR
	IACATQjl9OdiimvYgubCabjLg+/bsdU=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=pankajraghav.com header.s=MBO0001 header.b=nr+YHUy3;
	spf=pass (imf21.hostedemail.com: domain of kernel@pankajraghav.com designates 80.241.56.171 as permitted sender) smtp.mailfrom=kernel@pankajraghav.com;
	dmarc=pass (policy=quarantine) header.from=pankajraghav.com
Received: from smtp202.mailbox.org (smtp202.mailbox.org [10.196.197.202])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-201.mailbox.org (Postfix) with ESMTPS id 4c0p5y5hW9z9sjB;
	Mon, 11 Aug 2025 10:41:58 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pankajraghav.com;
	s=MBO0001; t=1754901718;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lNDD6Lspe3zTqDVuRc5jRvkT84xxqlND6jbD75Q1wQI=;
	b=nr+YHUy3VNa5UF3vHJkP5BW1tlHs1G6/RJqZE5SHfi04AKfWRTb9oILzOZsUHsZ5+0k0Jv
	0s1E6s82NN8QJbiGysYQfWFbHNz6fkqkUKUvSqVJyRr3dsHf+OMrNkyp0D7mW/FMrX/1Ih
	1lF1MLnFgo5ga7itElQovT9JB97FwiZSm9iznkImuUMOQypcXRhf6kd+DQYAhWH0Ww+IsH
	4VuYetK4pDDxa5NxTwsjSlzdi/nQg1AW5ORranbsVgruJv97UdPjY5DuK7cS/X2ryns0GU
	zXhQSDuNtW68crvPN3RsvrwSI66vs0C76ZSIO0zhHlB0bk5+oqw8Au3tmkY/Dw==
From: "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>
To: Suren Baghdasaryan <surenb@google.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Zi Yan <ziy@nvidia.com>,
	Mike Rapoport <rppt@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Michal Hocko <mhocko@suse.com>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Nico Pache <npache@redhat.com>,
	Dev Jain <dev.jain@arm.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	willy@infradead.org,
	Ritesh Harjani <ritesh.list@gmail.com>,
	linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	"Darrick J . Wong" <djwong@kernel.org>,
	mcgrof@kernel.org,
	gost.dev@samsung.com,
	kernel@pankajraghav.com,
	hch@lst.de,
	Pankaj Raghav <p.raghav@samsung.com>
Subject: [PATCH v3 4/5] mm: add largest_zero_folio() routine
Date: Mon, 11 Aug 2025 10:41:12 +0200
Message-ID: <20250811084113.647267-5-kernel@pankajraghav.com>
In-Reply-To: <20250811084113.647267-1-kernel@pankajraghav.com>
References: <20250811084113.647267-1-kernel@pankajraghav.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 2DA7D1C000B
X-Stat-Signature: qoeu9huazecdsb7rrpsg7b9or1mcy6sm
X-Rspam-User: 
X-HE-Tag: 1754901721-45103
X-HE-Meta: U2FsdGVkX19ec7oHFUM2xT8f4XTbUh0aaDOhUkDjiT2thiGd9bYec6VjVvYQcij4YRBIJqPERZklszEiLrlEDVwhVl3x2u9Pj4MUCRfXJPZ9Y5fkldbE00ehTVfwZ47vUr7N9WM3z+kd6O6kioWygJr/zssUHnxJbSsKeRCbqxXZgFttay4sg+QSE8xEh8olDydDNWk5Kv7ZuQgL7rjFcd1/tmRsipECDTiv/fhDVklzETeVE+Bf/vbe0+hICwh3PhA+17+we0nixqLq4ba6r/LG8UpkJFpWQOkSgkTr1IJ12DQglRCMUhAad3RR52U8zYObCFirRM+9JHzy4h2LEL160fxXRhJNwjR2k6J5Y94c2HfZpZ6RSK3tTjp0KWexk9OQEstiOCgZsMeakdGQS4N4O90ng+2dirjNff9Drxn1MEcu8zzYViB4Cb+cBhm1BT8CYzK5/4irl0hyd9lt55kOVm+KzA5dBzMIwUtBRzVLCkCGjzbekY2L1zp8KwmRikDKuTFbu7r94Kg8DsdfBCR3LE9qWrIiC0nTQBpHFabH+fKya8dUr5yo4STkHD0MrO1B6XR1wUJdfbmOWIuJiI936zEv+T2CTVuzoOy8IetpF7ezf3o5U+Rc8t0/uontMHf16GM4FL64RLTyC1BR+m9Y7VY2csBXxFC4myLsyw5Ac16y6PDrK2AG67Udeu7cmPJsyO+jtEDmM2Kgv7EiJPUQOEfN6+TL4EK35MyMA9Q+k+l7v+Yk9x2bagBfrFBX903DJ+wmPvvK8rCZ8e6VzGwSLK463lCOFTnQ6UjyO7fRITNZoR9lqDdpK9ftzwlU27X54LGWIlqQ29pqOf5InIqMuxUhvlzUAn7tWZprLbfkn3loCr+XrTAPw1sfQeoaBjlXC3qEBZyQgZpZxlfCXoK2nYePIaHEIwnsnFMD03W6t8XDeh2YUiMKw1U8/LxQFbqU1cIk6KNOjio+Nkt
 sJDkyVz6
 /CwIDPdPo8RIJTbuK+DdcNwJYwMO3QrLVWSDAb+Tsq4y+CFAUiXadCfgIS6UWw7VanUYlnshHU0HcQ00e+s0Lp+uRUFFEJEzoXutTvMm66EFXj8hPTl1tdBoj5+sFiOnR/dp1hfHVScria0pNQOCwT8p2LrLwKex2G4ux3XK9axTJmHY1NPBiQ/KRo3jAbr+3rBast3e80Og/xd1A81n1BKEbMnFHcpgq4z/LP8IF468Hra/vT1I+fUjV/IPzAlvOz797SEDewCEB6iceXx3io5UEQmukTaDcrtCm6xi/XY4OENLUmGsfS02e7oiPG15hCUVEi2KX7rVmUfnxv9wpFOKZ57kNQUkSyjttjUFZLDHwDlvqvc5mTsjp+XsfiACxmxrLEcDxFzUDGykTSjZCverRnVa9C41jo953JoDQ0qX05wfHyPpFK9XTFUDYHS1Qm3/levMkkxj5ndvRAZRt1uVgxTItd0TOdP5FjZxP8zKELpQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Pankaj Raghav <p.raghav@samsung.com>

The callers of mm_get_huge_zero_folio() have access to a mm struct and
the lifetime of the huge_zero_folio is tied to the lifetime of the mm
struct.

largest_zero_folio() will give access to huge_zero_folio when
PERSISTENT_HUGE_ZERO_FOLIO config option is enabled for callers that do not
want to tie the lifetime to a mm struct. This is very useful for
filesystem and block layers where the request completions can be async
and there is no guarantee on the mm struct lifetime.

This function will return a ZERO_PAGE folio if PERSISTENT_HUGE_ZERO_FOLIO
is disabled or if we failed to allocate a huge_zero_folio during early
init.

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Co-developed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
---
 include/linux/huge_mm.h | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index bd547857c6c1..14d424830fa8 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -714,4 +714,26 @@ static inline int split_folio_to_order(struct folio *folio, int new_order)
 	return split_folio_to_list_to_order(folio, NULL, new_order);
 }
 
+/**
+ * largest_zero_folio - Get the largest zero size folio available
+ *
+ * This function shall be used when mm_get_huge_zero_folio() cannot be
+ * used as there is no appropriate mm lifetime to tie the huge zero folio
+ * from the caller.
+ *
+ * Deduce the size of the folio with folio_size instead of assuming the
+ * folio size.
+ *
+ * Return: pointer to PMD sized zero folio if CONFIG_PERSISTENT_HUGE_ZERO_FOLIO
+ * is enabled or a single page sized zero folio
+ */
+static inline struct folio *largest_zero_folio(void)
+{
+	struct folio *folio = get_persistent_huge_zero_folio();
+
+	if (folio)
+		return folio;
+
+	return page_folio(ZERO_PAGE(0));
+}
 #endif /* _LINUX_HUGE_MM_H */
-- 
2.49.0


