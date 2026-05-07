Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43F1CCD37AA
	for <linux-mm@archiver.kernel.org>; Thu,  7 May 2026 22:23:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC27B6B00DB; Thu,  7 May 2026 18:23:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A73076B00DD; Thu,  7 May 2026 18:23:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 988C86B00DE; Thu,  7 May 2026 18:23:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 86C7E6B00DB
	for <linux-mm@kvack.org>; Thu,  7 May 2026 18:23:39 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4DE1C4065C
	for <linux-mm@kvack.org>; Thu,  7 May 2026 22:23:39 +0000 (UTC)
X-FDA: 84742051758.16.8D14DEA
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id D5A9D40007
	for <linux-mm@kvack.org>; Thu,  7 May 2026 22:23:36 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="NSyNMR0/";
	spf=pass (imf04.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778192617;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vW+jGDNFEDzTL0ZYP8xjaWjT8cnTW8x9jCORFRBulSw=;
	b=uoPjNFrXLaU6tkMwonC1qVL37X4hAz1WfN9IrrlXLekvD16ul7HMk8QWBXkx9mFFtSxJs7
	flgKDfMRyHhDMwHvuNA7WZiW0kxsoJl4XSIebMPi1xUT2rYfEdtFvwgBfa74OmtQshidHp
	qjjW3Q5aUUjZYfG2HssFaYwZbM3Crwo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778192617; a=rsa-sha256;
	cv=none;
	b=vsBMParlytXAVD17Dp/VzEyGIvVsSvVV+M7x4Vf45mrkwzuPuJ4BWGy0qShqmEz5ks+IvF
	0Q29NuUNw5i+ma2FfbVQSzublapY/X8ytMlWe6Dyc7o5fhCS4DfpMUiLrslMflBP/b0M8N
	gvrJv6cth0N/sOhYvjF9I3WIyI2JPfA=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="NSyNMR0/";
	spf=pass (imf04.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778192616;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vW+jGDNFEDzTL0ZYP8xjaWjT8cnTW8x9jCORFRBulSw=;
	b=NSyNMR0/cqixeoU/8cCc/YSlgnNFqGrepU/DztoDuP+3p+1Roe2j39p+rbtnStOlXAVcth
	au+zIrgwWJRRyEI+/Yk2Y3yS33AVGjViSklb8KKzfmfhbn8ZvTfmjs7ES2KVTR3/hzjsmt
	sDB9wQkSp7+rdOxILl5DnrsxRUFhh1E=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-278-GvBvQyGINJCTcukChLJz7g-1; Thu, 07 May 2026 18:23:34 -0400
X-MC-Unique: GvBvQyGINJCTcukChLJz7g-1
X-Mimecast-MFC-AGG-ID: GvBvQyGINJCTcukChLJz7g_1778192612
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-44696b11265so1391354f8f.0
        for <linux-mm@kvack.org>; Thu, 07 May 2026 15:23:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778192612; x=1778797412;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vW+jGDNFEDzTL0ZYP8xjaWjT8cnTW8x9jCORFRBulSw=;
        b=IgItYByoY/Hp2eHpGViB1HMwfHf25qcU4BRyYozehcB5YLEM7bmr9FoDp2Luyf6EjF
         VOtOT0H2RPtHoffokaBflalmSb+W6Ft2dKtC9obUFBjJXBOuiiDmXgVlN44xCpKkEpSu
         9zXOkUSehqFEglrRmNTtUlXmy48eHNhgsNb0fpFCkJvd7PHptxQldFU8zCxLAEdj/Sw5
         u2RF/hTLK9FrHf7ct6B1oOF3Rdq6r/zYP2FfrG5OaYQ/XDey+4cceT5z8DymxQwzMi72
         XgDX+ereKqw5JcKR2hpUnmdTNkRZHynRq1l/ohg29LcR1rVzNcAnTlXnq2lgHh8Wvg03
         i5Zw==
X-Forwarded-Encrypted: i=1; AFNElJ/XPnPsQqGtksEPxW4MlDdhEFI/j/a3WTBsHJ01yfkQRcYsGOnm60fqYSfMSNgTxhRu0KdEJYLHAA==@kvack.org
X-Gm-Message-State: AOJu0YzMB4DKNwEyycOm3oM4hb/Ysy67M7x5MjjceBpiFrUSKENux2dw
	oE7VRdvEXanIlBqx5sKHen9L0I4I78y4qRhZJTRdrdwALRdlivokarZ4ShLOmw1Mw3BzOEHHsBn
	4dWAmrLS3Pd7P9E8z0bBzV7aimpZ7UBKgLH/A9Qc/0+V9GYDGrn7I
X-Gm-Gg: AeBDieu6IFeL1nH/KgRCd1S0Zj4pQabJHtOC5+Oz4P1qetQ9nrXK/7DdBBOv6FGly+z
	XCBkBO0sHT1NgUSqWRuEqti/zaJAxIGy3dXZNj8+SnsRKi5pwM/DVzRQbjOQxJhD3UXJOqVvmT6
	CJvx+Wk1FjdxlvWc0YTaB+FCxZsa/prwtf/VvaFq7or5q8bU5d1x8Vc5iWhANljOozXugjt9KWU
	VJyxjX1wRETeREceXtH1wB7B/BoHW9UlkZgvXUVz1QyFuLSgFEJgM28hfjGVf50cCA0R9xZHuij
	ZCi5SClWtuC7SqgNmX51gZwgAuOeuWsPb/a2FJJodDjBiHS7YA/7bKd1ygIM8IuxLa3LYWoUvC7
	pSZ1ASP44vgsBtjGw+j2QYaun+7eUXtciq7ZdA+tf
X-Received: by 2002:a05:600c:3e05:b0:488:9ed3:1492 with SMTP id 5b1f17b1804b1-48e51f2a997mr175518385e9.10.1778192611907;
        Thu, 07 May 2026 15:23:31 -0700 (PDT)
X-Received: by 2002:a05:600c:3e05:b0:488:9ed3:1492 with SMTP id 5b1f17b1804b1-48e51f2a997mr175518165e9.10.1778192611407;
        Thu, 07 May 2026 15:23:31 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-48-7.inter.net.il. [80.230.48.7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48e65d1367bsm3470575e9.31.2026.05.07.15.23.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 May 2026 15:23:31 -0700 (PDT)
Date: Thu, 7 May 2026 18:23:29 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org
Subject: [PATCH v5 22/28] mm: page_alloc: propagate PG_zeroed in
 split_large_buddy
Message-ID: <b12478e664ffffc8b7466d771bd77275af83cf3f.1778192416.git.mst@redhat.com>
References: <cover.1778192416.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1778192416.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: V3OJDxTUMdheevlkD9mSMmrIgIM4SNi3sWpLHtPsU_k_1778192612
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D5A9D40007
X-Rspam-User: 
X-Stat-Signature: k8bhw3urc8k5effepqw6cdit63s1cpo6
X-HE-Tag: 1778192616-982074
X-HE-Meta: U2FsdGVkX19s8oezGfuh6YT1CRK5lVo73/TgYiLe1/sEW9PKFJIqis1VRUozIK7Kpya93Fjt5WLjKMfdHjRAgmSYM0NKtUt0xmM8ZFKv8y+JzIH5Z8Wr4di2jvs7hGFov95Hnp3PAkwu/CTlawXHNrtJ+g5CFqNhWY3QL1svxIGZdC6yx4Qs7Y7eHXfhuBLkHPZgyg3zi2stDKFo5ckvRr9f8L1eFUAtGqHz/0RQUF8KLdtic/TuhRVNag5+fYQzVHRng6ohE17/Ebn4ODYIf8LgYKgla/8ir4DZTVlMv5aqQeQ6HIUCmg0GhEsZmyV1PkMVJCga9vq5hUigiBWnGdfMuzZBftzwFNP5ZbjHTv9EP6FwKcU1CCOncc2HJFq32OsgwJeYQuOHkJLFtFHM1GGtnZOxH/gGVwS8UhoYf9HFcSUXlD/8jtgdGm6ImWLldTzwvUpvmNQhd8LM+kYgGmomFODsMIY3YmW0ab+y0vZ2GPtUbUKKY1eudlaBYVvCA0txPpR3yEbfZ1gHiA9AM4du4AP/E6/xnMqpANTYUSv1cOvLjY/dnYVi+EYLp0v/lUGsifaFGOpcWmDyiHqTs3cBB8fEDeo2/resFBRhJjVsTEp3VgeEa3OdU08PqdfVOoQlFYSl4ATl21G+foqJSV7MPmlhiRsCJJ3nx9v8GOQC5qBwbCeL57wBnHNPQySoBdcNng4FO7zJ5e6MfZEvlrzMqniPHx71sr3yr8ASK/ierA0JTYuTDzYyu151L6aSH+vd6Qwh1fBwiPts/y6ukK1smKRSnM9ks3VovnpDztEpd4NMWnp704SmfDDNqfTlDr8b65cZhcBqb6WcIa4eVWmS8Z6nwoQLBFWrrJwaj28Z7l4qjXY1pJkwi5a523Ck9EisAIi2MdqwaRz63aFW7aeBFK0Cg2shwIotOnjO2joihLjD3uvlo0RNn4b3l2ezKFXaYdFanSSbYHfQp3K
 kPHEOoei
 /SlRecBPkP0hrZkCNPGFyXelKZwR+NMkSlLveYu64SxfrJ24mq/eAcl8p77caFPxgKpn6hMVArdTj8U7Ku15bDAkDiZ+RoKhrmJQ+cOZKk3WGhJAH2V9KbnTvcsH89+iPraymeb+EnR0u/NYbdRrVUwPgIJrh6BwVJdtzty5jcnyBiBEp/G+KNqTlHf002RQDa/2VvVEg+Fz3C9Gw019iPW9JeuA3CiY4xBHlcrJKiWzc+CaWOyoarwFSq/Ejur0SGbJvAolkqfs+aBpZ2+8PzD4eu+DzkD+g8Pna/5bIEHA59psZ7/VzD5MyBSdTTJo7CLCZ66yXeO4CP9MWA3oAz5AdpuRL+sZq+CrpHqS3aKA2HFjUUvBZ3+1rLg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When a large zeroed page is freed with order > pageblock_order,
split_large_buddy splits it into pageblock-sized pieces. Propagate
PG_zeroed from the head page to each sub-block head so the zeroed
hint is not lost.

The propagation reads PageZeroed from the head page (set by
__free_pages_ok before calling free_one_page) rather than from
FPI_ZEROED, to avoid incorrectly marking deferred pages that
share the same code path but may not be zeroed.

For order-0 frees this is a single-iteration no-op (the head
already has the flag). For higher-order frees it ensures all
sub-block heads inherit the zeroed hint.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
---
 mm/page_alloc.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 5c6ab949855a..954d86655f77 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1554,6 +1554,7 @@ static void split_large_buddy(struct zone *zone, struct page *page,
 			      unsigned long pfn, int order, fpi_t fpi)
 {
 	unsigned long end = pfn + (1 << order);
+	bool zeroed = PageZeroed(page);
 
 	VM_WARN_ON_ONCE(!IS_ALIGNED(pfn, 1 << order));
 	/* Caller removed page from freelist, buddy info cleared! */
@@ -1565,6 +1566,8 @@ static void split_large_buddy(struct zone *zone, struct page *page,
 	do {
 		int mt = get_pfnblock_migratetype(page, pfn);
 
+		if (zeroed)
+			__SetPageZeroed(page);
 		__free_one_page(page, pfn, zone, order, mt, fpi);
 		pfn += 1 << order;
 		if (pfn == end)
@@ -1624,8 +1627,11 @@ static void __free_pages_ok(struct page *page, unsigned int order,
 	unsigned long pfn = page_to_pfn(page);
 	struct zone *zone = page_zone(page);
 
-	if (__free_pages_prepare(page, order, fpi_flags))
+	if (__free_pages_prepare(page, order, fpi_flags)) {
+		if (fpi_flags & FPI_ZEROED)
+			__SetPageZeroed(page);
 		free_one_page(zone, page, pfn, order, fpi_flags);
+	}
 }
 
 void __meminit __free_pages_core(struct page *page, unsigned int order,
-- 
MST


