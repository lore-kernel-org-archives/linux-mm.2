Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50121606A883
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 18:57:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=readmodwrite-com.20260707.gappssmtp.com header.i=@readmodwrite-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=FwWih9Be
Received: by kanga.kvack.org (Postfix)
	id 691146B05D9; Fri, 13 Nov 2026 13:57:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 668656B05DA; Fri, 13 Nov 2026 13:57:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E27D6B05DB; Fri, 13 Nov 2026 13:57:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2DBE86B05D9
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 13:57:18 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 28B93160186
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 18:57:17 +0000 (UTC)
X-FDA: 85431003714.15.0E40F06
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	by imf16.hostedemail.com (Postfix) with ESMTP id 46A9318000E
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 18:57:15 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=readmodwrite-com.20260707.gappssmtp.com header.s=20260707 header.b=FwWih9Be;
	dmarc=none;
	spf=none (imf16.hostedemail.com: domain of matt@readmodwrite.com has no SPF policy when checking 209.85.221.49) smtp.mailfrom=matt@readmodwrite.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794596235;
	b=6MEUOqPQSvn+srGp2yHQLO7AN67LkktAfk45ntF3dzF+5zCEjMsUThm+mHpGQWDqW9wWKM
	43u1VRwhTUPg6iYqvBdF5NzGxdyjmlceG+jiVD9QT68CpnoTNQ66D3fdU1N8sRotdySbFQ
	ODgLLYJplTppNDWoGBqPQzx33VnwlfY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794596235;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ONhjpTFPtQ0dZVvMCyXrWyUMz7z7tu2awXqAUU0j9nA=;
	b=SZ8bMH87gQjPgGBO9TBz2Rp5+WRgvfRocsIOMLDWwtmPdJ3OjELR7y96Rx6qLJHvvgaGvE
	xSo0syDWMxkCbtgpPRU4zIJquzQA3qGbKuFy13HJH2QCVsQO1K1u7yThYuCP4zRIs8X9Tc
	wb+GDW93mAg2yXwSw47ZbKELHBKKl8s=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=readmodwrite-com.20260707.gappssmtp.com header.s=20260707 header.b=FwWih9Be;
	dmarc=none;
	spf=none (imf16.hostedemail.com: domain of matt@readmodwrite.com has no SPF policy when checking 209.85.221.49) smtp.mailfrom=matt@readmodwrite.com
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-492f0a1b685so1236631f8f.0
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 10:57:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=readmodwrite-com.20260707.gappssmtp.com; s=20260707; t=1794596234; x=1795201034; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ONhjpTFPtQ0dZVvMCyXrWyUMz7z7tu2awXqAUU0j9nA=;
        b=FwWih9BeTOZNZYQkWU2PSbi12UEQPia/GbDqBAtNrzgSvAOJCK95tkljnGnmaRv4Kc
         g8nLA7uqYymDRl/7ocbLYkdbNd6igJg86mQCLBHay9GVejxkd/cQ5sNxuYQOArnReVYl
         ZPhigO4rfnk+A1P4DQCDkK7pjkiB12BhLSahf3mWrHxITDYfkCSs9ni2mPisHlpSmbWh
         bConQkkikEukwxaZTioa/btM39oM0QRr/K+IVVMADwdNkSLpNweyyw/5oZf+R5M4LgMa
         +rCJ5M/bK0dY6R/oEIeYmVLl8Xz7Sh+L+cxGwH8iPEaXvzSZQeC2wY9hW21vQy9cuhPq
         n0JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794596234; x=1795201034;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ONhjpTFPtQ0dZVvMCyXrWyUMz7z7tu2awXqAUU0j9nA=;
        b=1TfP4icmE1+LoAsxQQcSWzcQ3VBD0kXD+UkiJmpbYp68hPt0p85QtRqUpiTT4Iggi4
         //C/Izu4ORm0RIqMewj7fzCjKK526k1sFOMgA2lo/CvVhFkybD0gjf5JqVehaiHo8PAx
         CWZQhfDQQQaCUBbTwUUwHE27ozdQPm8a34iH2ngJjxnVbsGEiDr5w5S13FU9PzZ5QRnC
         K+vbttGb1M0/8N36P4TDFMnlDcxzXbiApgVcaau71D2DvonxDTco23eXW7PGEG+bEWwb
         xDRqKXp1wNKB+sFEoNcjC10Slxx+2buG734Ayc+eiYPl/QM/R0Vv//l/EEZgyo/rpiV8
         kGgg==
X-Forwarded-Encrypted: i=1; AL+hErGsskMGZoSI9xBrQWtnbDqwtfoFywqJWshme1wH1TQ5n3NrNc5p/HwqpWZzhwwML+tZBI/Ya7svgA==@kvack.org
X-Gm-Message-State: APuU4Z/I+ZPTilNjgC1+8BAoscwJtusddtjVzX0WIJfmAAV0U/6NeIB7
	MkvAMFG8gx7wwgiVtvrKKLabiWRzXsfR3CNCUsDigbsmE82XYM8J9AQh8qTDaBDfX6c=
X-Gm-Gg: AYBFou2/VaUYdV//n1K2Ojw5M21kVvyqEFeaQe8clGdjoT7YqSxldsb4SdmYATz+fiD
	4zn6Ww3M6s40kQwvyKyHxY7NVz1Kq+yab/OxlMz5qRo3ZR09P+C1pBHnQlXRMZY/TgEtFvAFi96
	+0Oj8MkYg3No5rDcQA5/q9an/8VfM07CQD/r1kg2ThHBDn9X02Baa5DGgjS2O9YMDmMVNpkeWg1
	csbWKhGl0nLxTje3+6eKWDUsVF3hAJ2vEIDfd0hQgyvBfRRFWwIJTZs/0CagdFQYNmspRSb+ZaV
	vsmIQyxHiVRvpTUY0xXfMQhoGtLSufvs66S+QLA3rFU88mLPJi2nfQYlszx4Yuvn9NFG1ey2WBy
	Nvkt0C1giH/Xig59TrW8dovFh0ks/6PT9KZotdzZl2YSZDfHyuNMAb9dyVxqntjlKEWB9clgWu0
	Sg+8HPxDyIYbGyDIJb8kTxMZn/1/4spXpE4BfQSkv5uKDAp9ryZI6tdRBo2gAbX2N6BoXIicecm
	8NM+WcQmzcuFXl2xKma1Zooa/dTG5LX+XptVg6AMzuw8U93c0C4lqdMgVeWsObSX3oA2jd23aDb
	+MbLva+q4zENToSwPYGx74+vK0zdow==
X-Received: by 2002:a05:6000:4b0b:b0:48e:20f9:8d75 with SMTP id ffacd0b85a97d-49c72c9c398mr7102565f8f.48.1794596233904;
        Fri, 13 Nov 2026 10:57:13 -0800 (PST)
Received: from matt-Precision-5490.. ([2a09:bac6:37a8:ec8::179:1b])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49c5f5972a7sm6417589f8f.21.2026.11.13.10.57.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 10:57:13 -0800 (PST)
From: Matt Fleming <matt@readmodwrite.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Oscar Salvador <osalvador@suse.de>,
	Vlastimil Babka <vbabka@kernel.org>,
	Caleb Kan <ckan@cloudflare.com>,
	Caleb Kan <calebkan1106@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kasan-dev@googlegroups.com,
	kernel-team@cloudflare.com,
	Matt Fleming <mfleming@cloudflare.com>
Subject: [PATCH v3 05/10] drm/locking: print deadlock backtraces with stack_depot_snprint()
Date: Fri, 13 Nov 2026 18:56:57 +0000
Message-ID: <20261113185702.1332171-6-matt@readmodwrite.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261113185702.1332171-1-matt@readmodwrite.com>
References: <20261113185702.1332171-1-matt@readmodwrite.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 46A9318000E
X-Rspamd-Server: rspam12
X-Stat-Signature: 9dwgasr3ommur97d7dpxqdux5j1xga7r
X-Rspam-User:
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794596235-179246
X-HE-Meta: U2FsdGVkX185xMB7L1rwWoVgwItnzyBizN8jfbyy2I1D6M+KKvfF17kIWDen5P72n4sUaPkLECNRWvX0Tc4Ubwo/3EwMvLouphZBaYZJ3ldd5DRRSnYmNV0EnHDSj66YRetqeTdU5APjO/wZ0xfzlYZD9mlMY7J+lCF/7Jq9y5VH3MHqu4yaURFAO+JebvhQwEn5kPFPWB9JcDIaQfBkWDAP2herp1aZbXfqrLKENexO6MC0ft/BRUmkTUMD0GsUAJBcpDdAxh/mXqJVkr+4LYZxqT8TRgzIhVgZ0pIRgImVivlGtH2LxUkcsCILKCblv0ZUppwFGTka2t9/W9lIwR2UPonCYOvh/kBZiHjGDlq8VVbD9mMboRataVLMJfTWIZCF9IOfIJj2BqTBhh4/zWhxP75i5bnRgPi6EA47JciN/NVAm2jcYTfiLslkFsrZpqrRbEemSFZr6haFPjQSQ411kWNyXvqa2wWcq7QvL0sPhviS5ZAb87FLgNAcdoTNgpVjd600P0i+J8+77pBIF6n303O6FrqGSa/QF6vNmi2+mwYXcmVSUnerTrq1zIrMs0JC3D3JjCVIbe918bmumF7P9u0NRzL3XcBmTr9sDbFLZ+K3TNynSzlZPlT8bsgz1vm3Ihxn9xQFVZFc3ESOgaMNsjET9+/UmFHSjxYcPFdxuLI6h11IUlFW2X6tG/+rgENGj4/BClxez7JjG6BGFmXuZlPdtM4abX3z1Oid+fncUbxSx7DdqdQH/brM6L1DAhamhz+EyjFhk7yDXd3CIu80KoH/CrUZFH7YtAKFm2Smk5IKzh04LKM5suqCraQpMfCv/HdKavzyOCsRE0Ze4mI7XzYstbvIR/1jKpfG0F9JC7MLzHL96M2rC3bEW2Q5s2s96tCW9tWxROYmSNZz1pJ8tMQIMnub/V8+TWSlD3Ed3DI0obbkCeasJIFXkpU58wicSHfxPJXjMNU2T3Q
 YWEpj0mq
 CaH5F1SZmN+WNf6u1YxEzmYT7bFMXUxukJW4kCw0IIXf2obuTSke6RtHPQbxlNFoUcxw0exxYnxmj7Dk4spKx5Lnf5y8Y3M9QzQCR82cVyziDAH2eGR77iP+Ppz+IcnwjJEgWXF0LcwOjOXqh/hhPEeQ8PNy5HKdoMybDCbFeMh+cXUwfy9FuztP0+nEYd3PFcg8GZDASp0ZXCIptOI3NujMR92cGMys3hL0VqwuVJLMDuxBaVHbOOeaaD7lATdRwb83fxo1sjvPEld/PKEPW/atAKYnVh8kaxknYKcZizrhA1BOXHr7ongH8b/Ws97y4NR3tfWQA1saaf5NLDl2rTtfD7HKF5S50rDFlmjlq3euQ4raUCt3kqJ2cygqPKTZnMJ/bM063NcWdpVpEeW6Samf6Jf+XlH5e9FsKNsJDJaFNL9SMlWXFmJ5l8I4ur7J+pLUaBSJNhMXOFfpC4b0qUnpfEUbTydwG8GJUNFqNnu8tF4FENX/XQW2VN826em3NYWs3UWYqHml/vKyhpvyRv6WYHbjczKoy8XXtmD01wVchCTJ/oEkhACD5h7XKEbsplQo2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Caleb Kan <ckan@cloudflare.com>

When a modeset lock acquisition returns -EDEADLK, DRM saves the call chain
and prints it if the caller later attempts another lock or drops its locks
without first calling drm_modeset_backoff(). This diagnostic currently
fetches the saved stack through stack_depot_fetch().

Later patches compress the frames of persistent stack depot records and
remove stack_depot_fetch(), which cannot return a pointer to them.
Use stack_depot_snprint() to format the stack. Keep the PAGE_SIZE
buffer and leave the warning text, existing indentation, and backtrace
unchanged.

Signed-off-by: Caleb Kan <ckan@cloudflare.com>
[mfleming: reworded for compressed frames]
Signed-off-by: Matt Fleming <mfleming@cloudflare.com>
---
 drivers/gpu/drm/drm_modeset_lock.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/drm_modeset_lock.c b/drivers/gpu/drm/drm_modeset_lock.c
index e14814c30d8c..f48b02379b71 100644
--- a/drivers/gpu/drm/drm_modeset_lock.c
+++ b/drivers/gpu/drm/drm_modeset_lock.c
@@ -94,16 +94,13 @@ static noinline depot_stack_handle_t __drm_stack_depot_save(void)
 static void __drm_stack_depot_print(depot_stack_handle_t stack_depot)
 {
 	struct drm_printer p = drm_dbg_printer(NULL, DRM_UT_KMS, "drm_modeset_lock");
-	unsigned long *entries;
-	unsigned int nr_entries;
 	char *buf;
 
 	buf = kmalloc(PAGE_SIZE, GFP_NOWAIT | __GFP_NOWARN);
 	if (!buf)
 		return;
 
-	nr_entries = stack_depot_fetch(stack_depot, &entries);
-	stack_trace_snprint(buf, PAGE_SIZE, entries, nr_entries, 2);
+	stack_depot_snprint(stack_depot, buf, PAGE_SIZE, 2);
 
 	drm_printf(&p, "attempting to lock a contended lock without backoff:\n%s", buf);
 
-- 
2.43.0


