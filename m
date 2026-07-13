Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8AF51C44501
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 20:49:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 408C06B0088; Mon, 13 Jul 2026 16:49:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 392E76B008A; Mon, 13 Jul 2026 16:49:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2CF936B008C; Mon, 13 Jul 2026 16:49:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E28C16B0088
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 16:49:43 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 60DBA160165
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 20:49:43 +0000 (UTC)
X-FDA: 84984944646.15.24679D7
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	by imf27.hostedemail.com (Postfix) with ESMTP id AE3F240005
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 20:49:41 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Dr4eHyQY;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf27.hostedemail.com: domain of 3ZE9VagUKCLEgiRReXffXcV.TfdcZelo-ddbmRTb.fiX@flex--praan.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=3ZE9VagUKCLEgiRReXffXcV.TfdcZelo-ddbmRTb.fiX@flex--praan.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783975781;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hg67XY3VqVr1xT4YbJfB+2ZOPF2cG732AuNnOCY2r7I=;
	b=JqWZN2iH93QPR1SZry3E61MyJAAcUOkkk+lWzLhK0as3lojDr7PjiWFe8glOreVUil4zmF
	xnZAOaai/KUqkvDdo1z71B1eZkflZVmFiYaykR/sdKQUahRzNVkklnBgQWn4lrlo15W6J9
	/5a+6kjubnM2978FBOSybVRGwmmTdnM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Dr4eHyQY;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf27.hostedemail.com: domain of 3ZE9VagUKCLEgiRReXffXcV.TfdcZelo-ddbmRTb.fiX@flex--praan.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=3ZE9VagUKCLEgiRReXffXcV.TfdcZelo-ddbmRTb.fiX@flex--praan.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783975781;
	b=nLzX54Z86gPInb2MvVwZuVimbhR4miPraALK3DH/hHHZHp+qhFamYB2ji9D7RBzg0tqrfe
	Apa/lkSuPcTwY/RZ7qKzUi/G657czmWyYuxkqBPjdr5yOC6q1XxpnmwHQhOlqiXlXNsdJ2
	vDr7Oj/il15CIQ38xvCzfJjiO4kJfgY=
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-8484739a9cbso307542b3a.0
        for <linux-mm@kvack.org>; Mon, 13 Jul 2026 13:49:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783975781; x=1784580581; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hg67XY3VqVr1xT4YbJfB+2ZOPF2cG732AuNnOCY2r7I=;
        b=Dr4eHyQYPQJBEAb1oYnb9ddADV8nbRoQ3/jlc6NkM25/y4tvx1Xqvl/46sde5nP9P6
         jhdbeRO//PmBcmhdGzcQSrJdRoNFU1R+7wHUJRoJnrjxRBPCrPPtGvWzcTOtzrcP/oPS
         Nthdehut4eVbrhGee1ImBjDOW7kKE0GFH5X+O0XGI9tseo0QA7EsWEwMPl+O3Z3ztByh
         NIikh8AWpASFYGm8TWHzHXms+sOKZDJTPdt6u84q3l/nR94n19MFId19KJEjEWQtrT2V
         9W5puZu7YQxF2EAEReoMyT6qJCv90cx0u3LusII2vknyWwpo0lHhV3EYX5k5vC1mxaEX
         febw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783975781; x=1784580581;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hg67XY3VqVr1xT4YbJfB+2ZOPF2cG732AuNnOCY2r7I=;
        b=ivWwNBZ9u8/kgOUEDCp/8sv9KX9tDsBQOdgUXg9Px1+upmdeKoTCPNADnmlRI8XlN3
         JShl1Q4+teu0qUQ6aQ1Sk1XIZVr9atgZ0TwA1z8CCyiD+o9irKtAeWQMbkaT7hCiPcbz
         N32BYQfOZJqXvpy0yL49O6jWH/i6dM0VQkI95/3OLCqk8hfA92czlo0JROslVXNYRClk
         08dp+OblhOJXWoXGVb2Cj5mUdZhpew40bK9CZx7iKhMo25fQNgdJhp9jY/wUusM0QAP6
         TRfmh3CeQRTH1u6MJhbWVZqLbSwotnIa+fzlv2/zKatXnO6EEUbNplTP4+jj6bP4KlJ0
         sq0A==
X-Forwarded-Encrypted: i=1; AHgh+RrU9m3SR7kTQtz2uSsRs7sjUPmODmBQOY0tbmebRr90Sw2bemh3SIWWZuEB+NZYfYkLL/tFKnh7zw==@kvack.org
X-Gm-Message-State: AOJu0Yyze0qMDdqAp9GfGB596e58Q1BcjErwG0/hH15tj118GvzZeqKl
	Ptm1wy55Pb9ISl1Tj59iRK7vqtSwW97t/Y2DxUrpeNwX6U8+G3PzTYYbCxCLauHdL82INZwe6a7
	QoQ==
X-Received: from pgl36.prod.google.com ([2002:a63:b24:0:b0:c89:2504:2df5])
 (user=praan job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:6f01:b0:3b3:ccd0:cf62
 with SMTP id adf61e73a8af0-3c0f0c11140mr14952998637.36.1783975780428; Mon, 13
 Jul 2026 13:49:40 -0700 (PDT)
Date: Mon, 13 Jul 2026 20:49:34 +0000
In-Reply-To: <20260713204935.3069000-1-praan@google.com>
Mime-Version: 1.0
References: <20260713204935.3069000-1-praan@google.com>
X-Mailer: git-send-email 2.55.0.141.g00534a21ce-goog
Message-ID: <20260713204935.3069000-2-praan@google.com>
Subject: [RFC PATCH v2 1/2] kho: Introduce a helper to init unsplit pages
From: Pranjal Shrivastava <praan@google.com>
To: Mike Rapoport <rppt@kernel.org>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pratyush Yadav <pratyush@kernel.org>
Cc: Alexander Graf <graf@amazon.com>, Samiullah Khawaja <skhawaja@google.com>, 
	David Matlack <dmatlack@google.com>, kexec@lists.infradead.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Pranjal Shrivastava <praan@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: e7b6eesgi35qixjoxzgkk4otapx9roa1
X-Rspamd-Queue-Id: AE3F240005
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783975781-81801
X-HE-Meta: U2FsdGVkX19OEB+g6ROebITUeOauwpgynv1I+UwrX8rvLaUQEW6dU2Pj5PnxzIUo9paD9BKVxGKBsyakGaqGnFtJjshSL+gyxYq4TBgNc5LeZ+DMr31uxfqBUOpVTcUyPRa2dPSqDJb04WzOhq2sQRiZ3R3gdKff1Ix796E6k68sGrKymqowGzek7BTVQM5gCEU1xeAFLC3Oeaxpt4efyqmgvH0BFJAx8V0NsEtfyxNKTponM54okVbSaJarexfvj5pPxMLah+xU5LJtbFTHWThRXcNiOGHwkkztQ7ekXF7x1QkKklKO/E2B/Ph79xpzw+k8Awrqu6E7xULzp45aqMefySIN2lqstq8cK1n52AaSnAyD3djyhF1RCqAoQemEnZ3IbM/9irWzJ0aGPbYmAjRr4Is97wu1zMquMkwj0uknECT4MsqQAlFMLZKzJCA2X3tI8sbrxp2Zd0gXYYDPfIwgM69P2X3TSTKQNHxcyPR0GjKOJTktNzOAKY4EO2py6pojrNXX3tUkBE7JbDESLKdIMUXj/+XklvJJGI5p9PpN5z6q3jnBovDkC286lxSDabiJeos01zKiaGGjG+Qa3jLAWNYQzdgFmgIDEC4ce090FqBqVl/r1XYvn/tvGsTqyK7b70Qy7zouvd5i+IE8H+Iw+IfFh1F6ZLg5goB8i1bjHqAPF4wTKGLWIMrn2bRXCSmvBjDBKuiDmHOl3o4SQWzddzWW8wu8fBphWOqmE4CApTtgeRC/mrgB6tbI8fKSKiGn+ThO+39P2jbpVH8GNhsolfcJdoYD8aXNNQzQAxoeWHK+4K0tsO3ighVk4wZmuRglpPPef8Ih5gE0cbtMPf+a2QWz6k7+Cgfr0lMCq9kcMcpEfZUmizD9Fi33wYMekYnlE96hU6tCJHtS54eq5ABBYv+GZyMR011BwRXSat2fz4q3xzMYJ8/ihXTtFcST14doRcqL9uflfDbfQKs
 r3oC6e+P
 zCfUt3JZdP4J/c3IzwPNEovQsyj/sABv53uBxi9AxjaXXbaFPP7JicDkfMdti8gPSRptAAWvNKTahmaJu6WcVv2+Y1jjMcUaqh7U97D9ZnOghAMg+0BJqB8w6kn4FPcpT7pwGRR8nPKEQAflaqmgtfqxxCvsGCAGEWii9Afj8mYiUaP803sfTCRRfoLAqSM3r2FrC03SmBEIspwWOvuf6hdKHI5ntMj2nI7SyoHxvb3elmit7YzZyUFtJfP1Mk7DFfizNEHVviNDj8N7UuFfhmzNG4TSodSAAYdFsDA4mvbFmtIwU/b9YUqCCMDlV4QzJZ2bhKzoXG/n7EJAGldwutS5MANiyiTyEyAWFK51UAS501JKPmwiBwb174c/kdxf2+bkWIzO2EcoaL2PLK8uql0t955Tm9e6cHHjGHiS14zAPaAHJ/cUKfoAvmL9Udeie3HdNGghm/mmfKEGyNjkNLFfy+ejVTyFwzsu4U9+rzgxjdTHOZJBPFArMj7QvX1ibLGC3cCFwFIbUCXyeJAIRY6e0LyWdsHH7j7G1OQkXkMNsu6UhBf52ZLSbmhZzcWtchUkg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The current KHO restoration logic assumes all multi-page blocks are
split into independent 4KB pages. Break out a helper to prepare for
supporting high-order non-compound pages.

Extract kho_init_unsplit_pages() to handle the refcount pattern
where only the head page is refcounted. Use the helper for folio
restoration that requires a similar refcount logic.

Signed-off-by: Pranjal Shrivastava <praan@google.com>
---
 kernel/liveupdate/kexec_handover.c | 29 +++++++++++++++++++----------
 1 file changed, 19 insertions(+), 10 deletions(-)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 4834a809985a..07f6f453cd69 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -357,6 +357,24 @@ int kho_radix_walk_tree(struct kho_radix_tree *tree,
 }
 EXPORT_SYMBOL_GPL(kho_radix_walk_tree);
 
+/* For physically contiguous pages. */
+static void kho_init_unsplit_pages(struct page *page, unsigned int order)
+{
+	unsigned long nr_pages = (1UL << order);
+
+	/* Head page gets refcount of 1. */
+	set_page_count(page, 1);
+	/* Clear head page's codetag to avoid accounting mismatch. */
+	clear_page_tag_ref(page);
+
+	/* For high-order blocks, tail pages get a page count of zero. */
+	for (unsigned long i = 1; i < nr_pages; i++) {
+		set_page_count(page + i, 0);
+		/* Clear each page's codetag to avoid accounting mismatch. */
+		clear_page_tag_ref(page + i);
+	}
+}
+
 /* For physically contiguous 0-order pages. */
 static void kho_init_pages(struct page *page, unsigned long nr_pages)
 {
@@ -369,16 +387,7 @@ static void kho_init_pages(struct page *page, unsigned long nr_pages)
 
 static void kho_init_folio(struct page *page, unsigned int order)
 {
-	unsigned long nr_pages = (1 << order);
-
-	/* Head page gets refcount of 1. */
-	set_page_count(page, 1);
-	/* Clear head page's codetag to avoid accounting mismatch. */
-	clear_page_tag_ref(page);
-
-	/* For higher order folios, tail pages get a page count of zero. */
-	for (unsigned long i = 1; i < nr_pages; i++)
-		set_page_count(page + i, 0);
+	kho_init_unsplit_pages(page, order);
 
 	if (order > 0)
 		prep_compound_page(page, order);
-- 
2.55.0.141.g00534a21ce-goog


