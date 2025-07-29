Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7A81C87FC9
	for <linux-mm@archiver.kernel.org>; Tue, 29 Jul 2025 13:53:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3257B6B009D; Tue, 29 Jul 2025 09:53:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2FD206B009E; Tue, 29 Jul 2025 09:53:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C4946B009F; Tue, 29 Jul 2025 09:53:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0DAC56B009D
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 09:53:38 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A776780720
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 13:53:37 +0000 (UTC)
X-FDA: 83717444874.20.FCA43DB
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	by imf15.hostedemail.com (Postfix) with ESMTP id BE934A000A
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 13:53:35 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jOv3FNUy;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of pyyjason@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=pyyjason@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753797215; a=rsa-sha256;
	cv=none;
	b=XafRyOhpqLaw/foxcxYMImX72klyEFWpB8ntHLsb1wJktR3/wY46ChphiOWwZ2fsKP33oR
	6oCUuegzcGJfxtD5IdbrJAW/VAIIlkdqUtizjblyl36aNS1LdSd/H2QYPF2XlGzCtabX/4
	p6GOph7/CZk+cIxs0aEuXSldbc4bruE=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jOv3FNUy;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of pyyjason@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=pyyjason@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753797215;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BX7fJLinetNknJ65ovuFB91/gF2qnwRLS3nsv9fgSbo=;
	b=o+3YUrrxnt/Fhc01BC1w2cCdcM9XjXlOBvFcWAIEFj1v4VcIbbHBRI49TQ597vFK71mVfy
	Wv6o7V0bCTf4xjJT0LFgM5mEuhHmgoq/0FpgRQORdYIacZKk1p/GLYmQ6+gRssEtXHXh90
	rAG/EvV31SqL8NTIOf901C1LyjpDUfg=
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-45610582d07so36381205e9.0
        for <linux-mm@kvack.org>; Tue, 29 Jul 2025 06:53:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753797214; x=1754402014; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BX7fJLinetNknJ65ovuFB91/gF2qnwRLS3nsv9fgSbo=;
        b=jOv3FNUy8UlHZGywTAPwmFRanf7Dg/aqtRanPoXj+ur5im5wRDAeG6AY+59phnVvlJ
         4xCBOTdvjiasEs7WlMz5hfNJaMolXj9ZzXcggKKeso2rdwPUD4gHKYgETzLeUJHUN3wf
         OCORrpTs8JSoi8UxsDCVZv8s3v2yt6hBXtoLR0xepmbUBgYmjTbdEDU0ODriH9L0pYo1
         e7VPEMm6lRqIB+JkJSeNuK+IMYM52l5JQd4eES5YBzhuM0vXiI1IbUKSk29/NRK9+r/3
         6igsdThZhko/nhLApxYT33fxhOdisjM4n83J7TcSxe0OoYcPtuXYrxuSdjTOCyqurJ8e
         60OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753797214; x=1754402014;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BX7fJLinetNknJ65ovuFB91/gF2qnwRLS3nsv9fgSbo=;
        b=vyqXU1ezbyxw+z3sKiMlXTWZDq9MPRA4VVUKuW1oQmbVdZjJOE+JfKT4qUsrfkOFN/
         wmMcq6VyYC7F0Y270kT7t83PTGW7j7OoeBmNdDzAAXGvlzOze0vYABNKXAMrBhSUPjG8
         BY4UvB9Qk3KFKJ62CztNQn8wcStN2PvUKswVJcel5HC9Oonr9HTQEfl8sNpwPDC4XGAJ
         dj7/NqWru5Jqri6eCeUWlcgf9HOzmRj0AQtvUsPIiCxwKNXzSXb9HmFheQ+7ieLgPUy1
         vNWJeyEzoQ+86iqKjAQzANrMCsN8DDMktZOgkXr74o0hYTx0c5lxX6BxkLacbPDdvToA
         PVVw==
X-Forwarded-Encrypted: i=1; AJvYcCWIFOsTewPkZ7ECGDsEOd/VRg793s578iKxVWFCL6SV07Jd+TkljClbjT/3BENKg5L05bTnhUGqEA==@kvack.org
X-Gm-Message-State: AOJu0YxQ215siXi7Ps25LQ+tp/IuBeJLnqJouX9WiCzuGCvOGim+LtCw
	cBoOfNC49LGXZdnHsyTUWDb0DdLCYH6gKZk8a5ygDc7Dsi2uFDZ7BXnO
X-Gm-Gg: ASbGncsSVoJDaVKapfI7QXmQaO6MOvES37YqjVpyYp8aUsMI4QfRJKKuvyYtCW2So/b
	YHta1+x8H/u1uqePeZUaiVv/1Rirb/YUZqh83Oj7iy4dMXHE/cD122a0LUqCc7MwAMicCdqNzFk
	zZN6Di43bpV+nnQB46rUp4sfxE3LQP7ouuIZv5R7MiOPwQrfQqzdcURfbzto9TKYBP5tvenHIYd
	DPCBR2tuQJfRDhlOBfiuyhAjr53JYYme7CnvO/1HuUC54Y/et7CN4KiGrgJSOKce7b9KJ2SNE58
	HMN/oclilvKYOasxTJFK2Te/bYpWt9QbkEL5rkMsNWYG4nQ6lHEs2RkxBS52ZFJV2II3EwMBtZ2
	NA44eKtjLCBLKRSY=
X-Google-Smtp-Source: AGHT+IHiE+mOd2kK/xVH8sQHnsd++XnU+kJq3zliaNuGl67gbnun1ianmf1AcZJq+E+PA+1qbb5MuA==
X-Received: by 2002:a05:600c:3f09:b0:456:1a69:94fd with SMTP id 5b1f17b1804b1-458855d3dbemr84280485e9.0.1753797214014;
        Tue, 29 Jul 2025 06:53:34 -0700 (PDT)
Received: from localhost ([2a03:2880:31ff:53::])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4588e5e6232sm26786655e9.32.2025.07.29.06.53.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Jul 2025 06:53:33 -0700 (PDT)
From: Yueyang Pan <pyyjason@gmail.com>
To: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Usama Arif <usamaarif642@gmail.com>
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	PanJason <pyyjason@gmail.com>
Subject: [PATCH v1 1/2] mm/damon: Move invalid folio and has filter to ops-common
Date: Tue, 29 Jul 2025 06:53:29 -0700
Message-ID: <2e143ff5789954b2c3c5b97b12569bc324cff087.1753794408.git.pyyjason@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1753794408.git.pyyjason@gmail.com>
References: <cover.1753794408.git.pyyjason@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: BE934A000A
X-Stat-Signature: assgpggappsc83wbgsrkeqcn8b6dp9ra
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1753797215-644163
X-HE-Meta: U2FsdGVkX1/SYvCvc4j7QtICb/qw111yk0T/GoLGrXoEm88/LOiXQ1KSlPjtWIc6L+9WyaiC558/Wobhx3U6uJ0ijBgj/tgM4qUczyUiJAJU4hgMyqVGg2+ucKG77JwgjIJTdlHsL+683mb1hjNTPI9vyEx267jLhPoO1iV16Vl5iWs7yVERLSpp1eluTxhuJbm5QhVmnlxbelzYwpUD9GMHqw026hgBs0Wrg1+rwHzyeQ5qt+A3z8eUv6BDpdIc2InaXkwbO5WwZfVE/IckSRLVULALCLvfYd30rVxgvBiirzQB26Vm92yE7dyQa3o5TsFr4RM7XATBi4t/h1b21iJLphvwwzfkxGMX1Ya/1qkfQ0GYq5196mSzQx/SFazTDs82Wyo/Nd6ZCuQEmVOQj5PWV0BYu1Z2IIMFLdxV2DLhWG3Nun259lTfNYFJlqI4vINeiIZdfvPsolyv8HsBRRjSC8uECCbIAjntS4ERhambq1S72yw93J5pMrPA97raRr6aFbO1eGfaqtq6DOai02DnDPyM71VNMaQd79lJ959bxmGzAwWIDm52eEasvKOf0fvJanyGH1w3EYHC7e4ixr+TpjFsXC5dHmLAJGeTn/C1YbIvDxnZSmvUz06r5VgN5/mUij1r9hKQ1eQTfIuBqhbKF6McpqrtDsOf8NE63HmDGDn5in31kw9cPEv9C4IA4cyN4piGifAbEAqK9homWJI4R876ppXynBNA2QaJjiPnPg+ux6nJvbzAeLDeehAgiJ05cG7M5TgBIPnhRJn1ZNAKAXDSUcE6rVFYMl6GssCoUrN8CGX9u6Ztx9o89HTsUA82TNUyqNlD5tjPtIctzevLkoSMo67Ez1+Zb5uJB9CqF1NJjkvd/9JbKA35J7eF8Fj8fVUCfB4IuOWId43Dtkjvm836CLnVEFnImSq7TN7AF9O4HRG6Qc8hpnAFMO8fV5NuGCabBUof/Nnyc8X
 A0ce/tzt
 Tk0JlGpLUQbDOevFBoOOpEn/fEC3u2/TxnojIisSGdqvXCPqQKtFgeduWalrXAX0jLfCxy+tpB3lFyopMC+pP1agC2RhedF1Lf+FJCUH/rQCoxidGMcgg6NNWA6RfByOywTiJ1KMvGiVzT3R1GfnUe3N3O+BiohZM7oUz84TxNnvkNY0LhHoGdd1dRXvvWOWiJDqHr+eoRUlfm7OtNx50kdRiwoEacLbaHrjcvgKsPk2lzljxVFjOxKysjrS2OMjSA2W/AtGnf3vsTMNvwOJGpm/z7ROiNlon1igC5mFMLh6L9RmaiRBu3H7q3Kwhm0XqQQg1Qxrh8fC6PI39oP8r9v/Js+DdIMH19lRIVtcPouCZiIVdBczw1OxiyyS4E4PDv0EJqFMPa7MR+c6r9j2YL1+5kjKqw6Ekl9dOilDWIUdst1ghbKxUUecXj3hjGI6qPyjqr+DWo7eL57GwD3/1hU+El9XB0bAPsQ2T
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: PanJason <pyyjason@gmail.com>

This patch moves the damon_pa_invalid_damos_folio and
damon_pa_scheme_has_filter to ops-common. renaming them
to damon_invalid_damos_folio and damon_scheme_has_filter.
Doing so allows us to reuse their logic in the vaddr version
of DAMOS_STAT
---
 mm/damon/ops-common.c | 19 +++++++++++++++++++
 mm/damon/ops-common.h |  3 +++
 mm/damon/paddr.c      | 29 +++++------------------------
 3 files changed, 27 insertions(+), 24 deletions(-)

diff --git a/mm/damon/ops-common.c b/mm/damon/ops-common.c
index 99321ff5cb92..7d3b48cc0f86 100644
--- a/mm/damon/ops-common.c
+++ b/mm/damon/ops-common.c
@@ -412,3 +412,22 @@ unsigned long damon_migrate_pages(struct list_head *folio_list, int target_nid)
 
 	return nr_migrated;
 }
+
+bool damon_scheme_has_filter(struct damos *s)
+{
+	struct damos_filter *f;
+	damos_for_each_ops_filter(f, s)
+		return true;
+	return false;
+}
+
+bool damon_invalid_damos_folio(struct folio *folio, struct damos *s)
+{
+	if (!folio)
+		return true;
+	if (folio == s->last_applied) {
+		folio_put(folio);
+		return true;
+	}
+	return false;
+}
diff --git a/mm/damon/ops-common.h b/mm/damon/ops-common.h
index 61ad54aaf256..4e905477fdce 100644
--- a/mm/damon/ops-common.h
+++ b/mm/damon/ops-common.h
@@ -21,3 +21,6 @@ int damon_hot_score(struct damon_ctx *c, struct damon_region *r,
 
 bool damos_folio_filter_match(struct damos_filter *filter, struct folio *folio);
 unsigned long damon_migrate_pages(struct list_head *folio_list, int target_nid);
+
+bool damon_scheme_has_filter(struct damos *s);
+bool damon_invalid_damos_folio(struct folio *folio, struct damos *s);
diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index 53a55c5114fb..a8b7048e871e 100644
--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -114,16 +114,6 @@ static bool damos_pa_filter_out(struct damos *scheme, struct folio *folio)
 	return scheme->ops_filters_default_reject;
 }
 
-static bool damon_pa_invalid_damos_folio(struct folio *folio, struct damos *s)
-{
-	if (!folio)
-		return true;
-	if (folio == s->last_applied) {
-		folio_put(folio);
-		return true;
-	}
-	return false;
-}
 
 static unsigned long damon_pa_pageout(struct damon_region *r, struct damos *s,
 		unsigned long *sz_filter_passed)
@@ -152,7 +142,7 @@ static unsigned long damon_pa_pageout(struct damon_region *r, struct damos *s,
 	addr = r->ar.start;
 	while (addr < r->ar.end) {
 		folio = damon_get_folio(PHYS_PFN(addr));
-		if (damon_pa_invalid_damos_folio(folio, s)) {
+		if (damon_invalid_damos_folio(folio, s)) {
 			addr += PAGE_SIZE;
 			continue;
 		}
@@ -192,7 +182,7 @@ static inline unsigned long damon_pa_mark_accessed_or_deactivate(
 	addr = r->ar.start;
 	while (addr < r->ar.end) {
 		folio = damon_get_folio(PHYS_PFN(addr));
-		if (damon_pa_invalid_damos_folio(folio, s)) {
+		if (damon_invalid_damos_folio(folio, s)) {
 			addr += PAGE_SIZE;
 			continue;
 		}
@@ -239,7 +229,7 @@ static unsigned long damon_pa_migrate(struct damon_region *r, struct damos *s,
 	addr = r->ar.start;
 	while (addr < r->ar.end) {
 		folio = damon_get_folio(PHYS_PFN(addr));
-		if (damon_pa_invalid_damos_folio(folio, s)) {
+		if (damon_invalid_damos_folio(folio, s)) {
 			addr += PAGE_SIZE;
 			continue;
 		}
@@ -262,28 +252,19 @@ static unsigned long damon_pa_migrate(struct damon_region *r, struct damos *s,
 	return applied * PAGE_SIZE;
 }
 
-static bool damon_pa_scheme_has_filter(struct damos *s)
-{
-	struct damos_filter *f;
-
-	damos_for_each_ops_filter(f, s)
-		return true;
-	return false;
-}
-
 static unsigned long damon_pa_stat(struct damon_region *r, struct damos *s,
 		unsigned long *sz_filter_passed)
 {
 	unsigned long addr;
 	struct folio *folio;
 
-	if (!damon_pa_scheme_has_filter(s))
+	if (!damon_scheme_has_filter(s))
 		return 0;
 
 	addr = r->ar.start;
 	while (addr < r->ar.end) {
 		folio = damon_get_folio(PHYS_PFN(addr));
-		if (damon_pa_invalid_damos_folio(folio, s)) {
+		if (damon_invalid_damos_folio(folio, s)) {
 			addr += PAGE_SIZE;
 			continue;
 		}
-- 
2.47.3


