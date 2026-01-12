Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 194C3D2502E
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 00:49:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 67AC66B0089; Sun, 11 Jan 2026 19:49:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 62EAA6B008A; Sun, 11 Jan 2026 19:49:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4EB0B6B008C; Sun, 11 Jan 2026 19:49:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3F4EF6B0089
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 19:49:32 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 050271413B0
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 00:49:31 +0000 (UTC)
X-FDA: 84321478584.01.552EEA1
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	by imf01.hostedemail.com (Postfix) with ESMTP id 2DCA64000D
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 00:49:29 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=sdEW51wC;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf01.hostedemail.com: domain of 3GEVkaQgKCIUsrjzr7jwpxxpun.lxvurw36-vvt4jlt.x0p@flex--jiaqiyan.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3GEVkaQgKCIUsrjzr7jwpxxpun.lxvurw36-vvt4jlt.x0p@flex--jiaqiyan.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768178970; a=rsa-sha256;
	cv=none;
	b=xY6BeSctEfzeJohdeoehA+ptKxuW+afabvLJTaN7Ec27zcpUWaYs9opp/X9Lqrniml5FTr
	G3XyXXh+RuCL6JibMv8LADzXcnIpGPYuvSqHJkHkvenQLbJVYwqQbpEuorEgvaYytyM2dg
	1f3X/kAbUFaCUqyY+MnTkIJ6Jh912Z0=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=sdEW51wC;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf01.hostedemail.com: domain of 3GEVkaQgKCIUsrjzr7jwpxxpun.lxvurw36-vvt4jlt.x0p@flex--jiaqiyan.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3GEVkaQgKCIUsrjzr7jwpxxpun.lxvurw36-vvt4jlt.x0p@flex--jiaqiyan.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768178970;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gjAce3C3Y1QIKd40PiLPufwi5ToI+2zeU/k8z/0R9VU=;
	b=CQXIXNP93LmLoWUJOe80MUBi55XKDdjR4KnyI3ykiW4eQz12W+PGFcsH+svH2h9oNQ9a/O
	ozOUbUQh6Enrl389+TNIbuDYiHLlvs5LI1Sxp1qDi1kuHko3l6hMpwYrrfHtQoqZjvXKfi
	EhWZYZV146ynneaeC63LTkf5aI4Gsvs=
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-34c314af2d4so4851872a91.3
        for <linux-mm@kvack.org>; Sun, 11 Jan 2026 16:49:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768178969; x=1768783769; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=gjAce3C3Y1QIKd40PiLPufwi5ToI+2zeU/k8z/0R9VU=;
        b=sdEW51wC71bPQ4Vl/q3SULn3D24DSvH/UONcC4/fBjzokb9Iso06LHVGkRtzPcyOnX
         M0gHvccqtCHWXJ2M8kfc1uMYhVEL91vPPRDmQYBi2t3JzAdVIcpinSCvJugBrCoD3Gr5
         R80L7SYd2QBNzCL6WMM/qYWLFc11GzgO6LJTe9rRDmcJ2YSqXbapLwmO3o3RVE3tyHl1
         iTnZPNStudMOpFEp/rcvy9AO8ElslaBGKnUwxo6SAd6YCIKP2CnSOYGir9SElj+5Opvg
         QI3JmfQ4UIqXX4sW3aUPX740/p02QxhkNaXa90R6evvz8ZSKLAomCNeumA6xEe2VrwSw
         8y2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768178969; x=1768783769;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gjAce3C3Y1QIKd40PiLPufwi5ToI+2zeU/k8z/0R9VU=;
        b=ROr6++1PxZVSIUn04r/lY152ueDm1U8xX7P1wLViJxqPjpW2AwbUUMCA/NcRGjV6w7
         4eJw6JSI9VBewHu0nDGoDafbDgWDcjdDRB9fij8w2PbGhRx606flLDw2jl91KTpCE0Vk
         Tpar+ekMPRIQACALkjmeK10Asin5VzU/7qZxJwwvbRXkzttHdiVfBbjahbpNB2P9LvZR
         AMzSqtR+7gIu8CHCMr9xJZQRXrZi9Vntzn6YZ8bPPLHVQn333YnVldlmZrxjL7+cjaB6
         ZtwcSZHiDkB3SEU8lNUt/lGPaenTWvq9lLRpymg6WBt+93W75Nm2KxASZZ3p3Jaj2CFc
         yVKw==
X-Forwarded-Encrypted: i=1; AJvYcCV2lu6Mj9Gb/mLKgSKmKH9MtIZzOlVRvnroY0h3ScWh7Py4eTTNva53VcRQIb6sMndNLMMk/Qk+RA==@kvack.org
X-Gm-Message-State: AOJu0YzjS0h6OKAcXu0E6K1Zf7L3od7Nxgh4aiSm9tMyps0ON0wLINS/
	GKiF4BAJQ6sHY+wgiOK7q9I3D74apY5BUAtUedgefs3nXHHwY2iKU3ZC2lKTXZafuzuBhJ6RICT
	hB/SRIqm01OorGw==
X-Google-Smtp-Source: AGHT+IGRsYmD0Owt99yy0ghEM70oDPPy8Wm8X//vCefVX5nk+u6cdO2UbDFZj27GMxMpcJ/JK+UWe9vqv3woFg==
X-Received: from pjbgk1.prod.google.com ([2002:a17:90b:1181:b0:327:50fa:eff9])
 (user=jiaqiyan job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:2642:b0:340:d578:f2a2 with SMTP id 98e67ed59e1d1-34f68c335e4mr15145403a91.6.1768178968964;
 Sun, 11 Jan 2026 16:49:28 -0800 (PST)
Date: Mon, 12 Jan 2026 00:49:21 +0000
In-Reply-To: <20260112004923.888429-1-jiaqiyan@google.com>
Mime-Version: 1.0
References: <20260112004923.888429-1-jiaqiyan@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260112004923.888429-2-jiaqiyan@google.com>
Subject: [PATCH v3 1/3] mm/memory-failure: set has_hwpoisoned flags on HugeTLB folio
From: Jiaqi Yan <jiaqiyan@google.com>
To: jackmanb@google.com, hannes@cmpxchg.org, linmiaohe@huawei.com, 
	ziy@nvidia.com, harry.yoo@oracle.com, willy@infradead.org
Cc: nao.horiguchi@gmail.com, david@redhat.com, lorenzo.stoakes@oracle.com, 
	william.roche@oracle.com, tony.luck@intel.com, wangkefeng.wang@huawei.com, 
	jane.chu@oracle.com, akpm@linux-foundation.org, osalvador@suse.de, 
	muchun.song@linux.dev, rientjes@google.com, duenwen@google.com, 
	jthoughton@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, Jiaqi Yan <jiaqiyan@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 2DCA64000D
X-Rspamd-Server: rspam06
X-Stat-Signature: hfz818gxgz39zqh1dj1zg7qfw16qpgr8
X-Rspam-User: 
X-HE-Tag: 1768178969-179444
X-HE-Meta: U2FsdGVkX1/ms6b/LxAHGNsgEwY4LUaejtpQM2ktrvTNcaWTb/kfcuNEBXjeRnih7F4/Vom/vF+ggbYTuM3EQyyZ4hxUi1jffW5qXDLrDWbQh3PMCF4Gt/Weq7ZjXuXlkNvrxwGcPU4biIb9zCNQdJn4ABZvWjJcWQVfzpW+UDGp+fkBZ4Y1of7PJ+3Ro4CsI8nkkusd3Jotz5IHSeCaeF5DaCOLjfqyGtf0se3bK1GN8JXM9QjrYzFwg4U7PPHG8rkvJNtzATNseq30iwj63AJtHeUvVjiX2HioKoeKHJmLA2LFkEjju9cS3a4r4LhJYBaja7loGFMxJmCVW0EKkxz3kLb+xdu/i2GksGAEZPaHTN75vQO1pzvev3chYb18Xiuf8ZSq5HrOFvvuwmpNnXphKVQRhfvu5KJnVtMtQfTOw3RkPhSvAKCN7jJQagvlCStDgECuz2CgAg4qa7+1+JVHF+9zEwxPi0E0nHdOpUkCzQw0Oq6qc+oBe1mP7cWBckWvDZ+Zcs+7hVA87nST8l9wDJ65qHWPJbeCYmyHpSVhDJrEMdA2udWaffvlt1ru13dew1yQ0QiDOpr1jpXf8Keo/kZiNIxgceRHvWw5+XqWaK8vgkfWz851TDHYdsiejQYeVnAISpQrPYXkTauU9je27tWrex7dxHv0hjPN0XW4DlRMHk1VSd+wlRvEVYCpLJMuMwAp2UMmG6/cIAxrtAqpd3S4w1x1/hQjPBKkC9GlrTCwEGP30qotx21hN1LV+zZ2fBsbGgzmCS1JSpmNg9YiqfjZr3kWMbCE8oNvvu/vKT9H7ob+R4OkaW916lIXpjNVGiVlLUQiX8bnII8GgeuCX/79k1usnDH4VWLmHgFo9CW5xF1ExRO9KyZZoV0d5Pp5bHBLVkNwZNp2/RFK1Z79kliQKa6bfdTnpTagRr3a+BSTG6GI8sSnh1tvuJVePgc0RsApe+cQ9zrRhgO
 F/L2nYwU
 dIC/D2u3DXzHqUE6y+kJADArB6LVd/WdoicQkr42nAov5bazALt+ofab8UOgMriSwMH7Sa45TvVkSJ01qaVZq3d2aaX7l5eYf54uBLHg51+tzitu/HM7Jx0zO+q+SzzE9SfQL9NPnGhi1LOM3Dn7yGhSz65vpurp3WlRdMGkbUwuDoZGBCemuK8HloPXhYL8ee3TwRxhsuZhuKhekkEeGhhlEq6bopZ4uy7jqLEXnZ7/c/8VT3vQkuh55b3vjjweGIqSQhz4Q9qEzj21AFB/DxRsCsw5Lf1cpaLLw9q07kBV8oTCYLKFloD6llgXgc0xZCvgmly/pgN0eZEHh2OHE7G4vzvnvVI/rn9iS0xP2tj74viP5AXlTfbcVT/F1RciJjPIG9eOCcbKi+SZji3qji7/eBkHanLjwlXazbqf6+/NrEVbJx2xfdS2PAL4/XVwNjsAIIGoXNyU9HVbZHyxSZKS7I9kq6U52J1wT7oaiVZXsbnnzSiYNnyRCh38fA5acjGvsWUFXNdSZEOWXNZPJ+X9k4e143k6vS/DRsQvx2a7Y30sHMaHjaVE2SnexZSAnvdQfGsLfR9436nXbOUJLDbVKbElg2jT73BRNvn8Sy65NzSQygALhJPWYmmjzBzxdzNWKzCyizRBbgKX23swLGwvGKDYc29WBAniPZYsomNwiO8g=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When a free HWPoison HugeTLB folio is dissolved, it becomes
non-HugeTLB and is released to buddy allocator as a high-order
folio.

Set has_hwpoisoned flags on the high-order folio so that buddy
allocator can tell that it contains certain HWPoison page(s).
This is a prepare change for buddy allocator to handle only the
high-order HWPoison folio differently.

This cannot be done with hwpoison flag because users cannot tell
from the case that the page with hwpoison is hardware corrupted.

Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
---
 include/linux/page-flags.h | 2 +-
 mm/memory-failure.c        | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index f7a0e4af0c734..d13835e265952 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -904,7 +904,7 @@ static inline int PageTransCompound(const struct page *page)
 TESTPAGEFLAG_FALSE(TransCompound, transcompound)
 #endif
 
-#if defined(CONFIG_MEMORY_FAILURE) && defined(CONFIG_TRANSPARENT_HUGEPAGE)
+#if defined(CONFIG_MEMORY_FAILURE) && (defined(CONFIG_TRANSPARENT_HUGEPAGE) || defined(CONFIG_HUGETLB_PAGE))
 /*
  * PageHasHWPoisoned indicates that at least one subpage is hwpoisoned in the
  * compound page.
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index fbc5a01260c89..d204de6c9792a 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1952,6 +1952,7 @@ void folio_clear_hugetlb_hwpoison(struct folio *folio)
 	if (folio_test_hugetlb_vmemmap_optimized(folio))
 		return;
 	folio_clear_hwpoison(folio);
+	folio_set_has_hwpoisoned(folio);
 	folio_free_raw_hwp(folio, true);
 }
 
-- 
2.52.0.457.g6b5491de43-goog


