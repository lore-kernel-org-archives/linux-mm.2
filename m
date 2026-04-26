Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2DED9FF8850
	for <linux-mm@archiver.kernel.org>; Sun, 26 Apr 2026 21:47:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9756B6B00A1; Sun, 26 Apr 2026 17:47:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 926F86B00A3; Sun, 26 Apr 2026 17:47:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 816176B00A4; Sun, 26 Apr 2026 17:47:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6B9576B00A1
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 17:47:55 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1E49314055F
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 21:47:55 +0000 (UTC)
X-FDA: 84702044910.04.95FB9ED
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf23.hostedemail.com (Postfix) with ESMTP id CD431140002
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 21:47:52 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=a3uh4aj4;
	spf=pass (imf23.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777240072;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ri4XPy9sNyekDQ8kcO16tmq8sU4MreY6RcvDvpK2Y+0=;
	b=kJxs9iniI06XX0Of2Ih+WfGeJH2yLteGw4xKzfsJ3G6SrNntyutoV2powd3E3HfzLLnz+f
	igi/haqne0KX67b3UA0af6p2dVU8/a0GXXtkQ+DeFaFu+HJcj7JwpVhCjkRGuU9Me8/woA
	Ohr7JoaBImYyWKgsb9kHXU+B2e9cGfA=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=a3uh4aj4;
	spf=pass (imf23.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777240072; a=rsa-sha256;
	cv=none;
	b=G8r/8dyllMpyLdhliD6IPo1SkPXooxNaUT3pYcpYl3TUz6QTGyeK8eKdU2kw6NHefMPA77
	OMfxrFkz9ldgzgye9YW5WDg2OkJ3+4wZDVHYp8/A9JuRWICOVNloYi5CFPD3uJlWVg9C5T
	VzUhtmhmo/3DAPq/+OGTT/gPedc2fqI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777240072;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Ri4XPy9sNyekDQ8kcO16tmq8sU4MreY6RcvDvpK2Y+0=;
	b=a3uh4aj4se+XzHVAbNm8N+S2YrIKEnIYTfxYeZlnWCN1fO10EfrNyQLu5zYNSZwiOEu6tk
	4ruTktYQLL5IwVa/nwM5o1AysDkGfB8Df5KatynyW7BeRLIUQXQpz9CYL26qsHl3Z0m8jl
	INQpuh+V0I9hz+gn1O1L8XE+gNL6vvo=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-578-2lga2_8WPVe4ECSdiRnrMg-1; Sun, 26 Apr 2026 17:47:50 -0400
X-MC-Unique: 2lga2_8WPVe4ECSdiRnrMg-1
X-Mimecast-MFC-AGG-ID: 2lga2_8WPVe4ECSdiRnrMg_1777240070
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-440d0c4401aso6888459f8f.0
        for <linux-mm@kvack.org>; Sun, 26 Apr 2026 14:47:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777240069; x=1777844869;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ri4XPy9sNyekDQ8kcO16tmq8sU4MreY6RcvDvpK2Y+0=;
        b=gaaG7W8XECG3BwSYhW2l/EfyYTvyLsTpvon0yCbqfDCIhr5RrsBoMycfYzd6DKp3Vm
         JIzh0v+F3wtF2olAyIotTSWvat2/k1jtrSfGwh77qiv+yVDs3E0AS4z4rDROogl7Yp23
         2DXYdN13FNuYWfHjQ74yfQ+bUpzXlEpklNs3ekb8AWkfV4mW3Z5nIkKeVPTtB4DcmG/A
         T1p+ckgMlplFslBudXItKzXhJHjPakEtPfQnGRtcLHa8OJN2X0ouaUDFR8pEGkJn1oGL
         yESL30UePPqaF5xCzSV8Q6rjdhNxdf6yNZgEeiR38ZdYOfDwjZqizNwxlb1tBZ4CD6KB
         90FQ==
X-Forwarded-Encrypted: i=1; AFNElJ9+x8XP0ZsHziSqsTjnAEvYMpGY1y4KD87/DPRh0agNbNESvzc1AJ5KUOQpCL5956Tbsr2tCtG2ow==@kvack.org
X-Gm-Message-State: AOJu0Yw8bhm86sbWGeY1y4sIrkgcaWVeQxcfsN4yqrTGA8IQLgfcGITR
	qbivyJEuiYlZ8Y1yLT6Nxte2DMvSvOMKpkqr4ipgXi4IoGbLTQvWmRlUcbL3Z08CHu4uUgd7x2u
	p1ObxEWtAwXH8Po/r6zzrV92C+Sr5Wy24SvaoZzycHbRRy7nx//xw
X-Gm-Gg: AeBDiesDV5XA0MzOHms5UGeoap5gI5Rmy+3Kf9ViE0OZeRoSxsYaBjM4yKtVV0YWhxy
	JbweJRYIL14+PZOSNbfoXC1HMiIRmawlCshFue9hQ5pl28R2kSKVn4PUAL3h9GPAXYFw6eZoKEb
	V0jCL8pGAdtNwUOHzJe/QELiZKxJkYeLSTPCXurf69xgGojOb4XbVgc1yu3zpSs9UmjSZOrPJOV
	0vQCO2VL6njTrsBkb9CfkGrojgx2xiafL2DoGd09nwysW0XAtYBZxjmi0uhVUthxW2FFcU79O/u
	jtvM1IzES9OWyBXANdaMHwGGuc5MVoxYcWYt3UdCx+zUvgENX0Lq1IguEKbYRGlQ5Yex48WMoF1
	YA7/0FGUKUS0z1oI6AXG/JH1ypQI65dRZMi3/eIckpIY7auYsH6opV9Mw
X-Received: by 2002:a05:600c:4714:b0:48a:5574:3a5b with SMTP id 5b1f17b1804b1-48a55743d05mr350691835e9.27.1777240069563;
        Sun, 26 Apr 2026 14:47:49 -0700 (PDT)
X-Received: by 2002:a05:600c:4714:b0:48a:5574:3a5b with SMTP id 5b1f17b1804b1-48a55743d05mr350691515e9.27.1777240069081;
        Sun, 26 Apr 2026 14:47:49 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-47-179.inter.net.il. [80.230.47.179])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488fc10019bsm765744485e9.4.2026.04.26.14.47.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Apr 2026 14:47:48 -0700 (PDT)
Date: Sun, 26 Apr 2026 17:47:46 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Brendan Jackman <jackmanb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Jason Wang <jasowang@redhat.com>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Gregory Price <gourry@gourry.net>, linux-mm@kvack.org,
	virtualization@lists.linux.dev,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>
Subject: [PATCH RFC v4 05/22] mm: page_alloc: move prep_compound_page before
 post_alloc_hook
Message-ID: <9c4c4cacb2cd5d1fd32219ab00f27e70600c3900.1777223007.git.mst@redhat.com>
References: <cover.1777223007.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1777223007.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: M8GI68z0BvXTs-E0AulxKX-Bube1LhDXi3MxCCHPqXk_1777240070
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: CD431140002
X-Stat-Signature: t9xaez4gob9dq5wx5yzd6ybcdfknb7ob
X-HE-Tag: 1777240072-937297
X-HE-Meta: U2FsdGVkX19WZYCM1rhn7woH7hJzl79z9/QcXLsmWa759j5nPRRWMRV6xFKCiePpI6aS0/TH25pad6di4QvXN4d8QYFwQiA9JrtC9aVRHF4YaF/9mbMU09SMRStNl3+e1azOj4rIeD8Tol3zPUTSy174iEtga2wFtFbYAaXrr1xHverkdMr/fhV83+dfGO7SarYWMVlA5cRCw1kMAbS9DenafQQeo3ClmTjaqj/LF9L1bIcBNZxw4UA5IIADaer1UZs000bzV2UMbA472Z6F6kDWU7Gk8aX7FBSUlk3KruhzYhw8pPMRefJ0gyN/j4zBF+La+ahb9dH+j8WDtB95H8YupBbclB27/yDbUkqs3oKcwCy99lse5IfcmiorQfK9eD/XVATTnVy0GGh7ydoJ9InHtUJhoh20WqYOCrRDBVD9vW5crAKDY0DltCVRp92hkCI/VUe46mQH+8r8JhBhN6KNgbvCoAIV7h/x0BKNOFF6Wf+n4IgXFp7Wsx3E54gysT1JIWHVsZUTuJ+HgQbdi5c4fv4JDqT80HTIxP13FfVi7anyWBmvl/N/qalvzKySG0ynb8WRcCQYQxypFjZrpHovmh8R+mUwGKUDV1bh9rXaQumAdIOGUKn78V9E3dhB1t34tMg1SdS+mS1XBMl3YnvZgnfCzQsVT5gU+RBrOSHAfEmQoayb9r+LveQ23q9Ckm0k+RQIFAi5F0mRMQUCxZnYHdxg06yDA/Q9BQyFpfiHYKY3IAZ2XUg+oEVkBv6Echv9rQ7YcHCaMDYDzhmFftd5NI+zdcybIvSzBwIWO2Ra09ZJunyikaEEiHgIt0fNhjrB7uM5LPaV+A5sSWXbFzECTxdbLgDNVrtUxmwVwVA6Tgxhx7UQW80uD6dpgRY5jfiIAZvrU6QeXrQFfhIVlb/tw3X25DK5IVci4TnSu8tlwBm6TBLU/z20L037vxgSXHquflTTpYmsoqgLPfx
 9Lz8Ow8n
 CBprEpUqXJaUVejE0GdsT4G9vH6iWQupnx6mL84+HU2Fb+LFYr69LIoOF3/edJ9XcuFSngDPlfPfGGiYpUlWsSXuAmsu3PjOv3tCcgeqhP5mtwbCFx8HnDYgYkK8a8JGojfgaZtlpicqX+SawhB5UkoE9gJXNTaIJAaQ3MoQ7O3fec+S1CgIcfXZ7adtkp7/2DaEBYY2HKwTlKP0iWh5J6BsrbdMcX48+7zEwVJ1B+dpJPOkzVPcAhFR0zQWGb+sK5QLqo12VT0UU2y91m8Ndq5fI9hP/mj1/2l4tqyXjptSAajrtphVNOn1y6bOTe0z48MPyLDlW4NHPpDdVr7P6Zkzi/XiqzP5bEsqpyTjtq6TCCzmulEumMmQUQQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Move prep_compound_page() before post_alloc_hook() in prep_new_page().

The next patch adds a folio_zero_user() call to post_alloc_hook(),
which uses folio_nr_pages() to determine how many pages to zero.
Without compound metadata set up first, folio_nr_pages() returns 1
for higher-order allocations, so only the first page would be zeroed.

All other operations in post_alloc_hook() (arch_alloc_page, KASAN,
debug, page owner, etc.) use raw page pointers with explicit order
counts and are unaffected by this reordering.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
Assisted-by: cursor-agent:GPT-5.4-xhigh
---
 mm/page_alloc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index c19eaf76607c..04c03c56abec 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1895,11 +1895,11 @@ static void prep_new_page(struct page *page, unsigned int order, gfp_t gfp_flags
 							unsigned int alloc_flags,
 							unsigned long user_addr)
 {
-	post_alloc_hook(page, order, gfp_flags, user_addr);
-
 	if (order && (gfp_flags & __GFP_COMP))
 		prep_compound_page(page, order);
 
+	post_alloc_hook(page, order, gfp_flags, user_addr);
+
 	/*
 	 * page is set pfmemalloc when ALLOC_NO_WATERMARKS was necessary to
 	 * allocate the page. The expectation is that the caller is taking
-- 
MST


