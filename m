Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9BACAE6BF3C
	for <linux-mm@archiver.kernel.org>; Sat, 31 Jan 2026 00:15:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 14F1D6B008A; Fri, 30 Jan 2026 19:15:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 12D276B0092; Fri, 30 Jan 2026 19:15:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E54206B008A; Fri, 30 Jan 2026 19:15:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D3FAA6B008A
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 19:15:50 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9C7A31B1B9A
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 00:15:50 +0000 (UTC)
X-FDA: 84390340860.21.B2137D1
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	by imf03.hostedemail.com (Postfix) with ESMTP id 8793420009
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 00:15:48 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=dFXP9uZV;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf03.hostedemail.com: domain of 3s0l9aQsKCI4su2w93wGB5yy66y3w.u64305CF-442Dsu2.69y@flex--ackerleytng.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3s0l9aQsKCI4su2w93wGB5yy66y3w.u64305CF-442Dsu2.69y@flex--ackerleytng.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769818548; a=rsa-sha256;
	cv=none;
	b=VjNpE+0vRPW1Is57pENU8MUdR8g+rWURp5t0BCBMfjt3rYayLqrixH82cPvU9YopanFeSt
	sIpdpwGCLcjSshlM3MoHy25mpQVUKKTZfnf7c2tRJpD3QFfr3w+2NzfC4e2ePVMcsgeMod
	uLtGq7HsRTZSvrccx4neT874dlwKIzs=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=dFXP9uZV;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf03.hostedemail.com: domain of 3s0l9aQsKCI4su2w93wGB5yy66y3w.u64305CF-442Dsu2.69y@flex--ackerleytng.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3s0l9aQsKCI4su2w93wGB5yy66y3w.u64305CF-442Dsu2.69y@flex--ackerleytng.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769818548;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JBT3eXirMhITfHBhMfm7jmk9GgDGwvmhXO+L7+fYBQE=;
	b=beRR/9sAnDMn5wO/MXdfaiyrs0gQEo+4kd0YBKPps5AMP8onkzYkQO0hbnq0yjmUs7oSKG
	xSN6QJrVNhHJ6XF0qnUu1KmA7ZYUfBUY0OHt/aMDOB+w14C2KmDYerUIYib8+1U4SsPW3f
	9TVROmXFrnDJr9taLTGqgU8HuR3QTrI=
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-c56848e6f45so1796342a12.2
        for <linux-mm@kvack.org>; Fri, 30 Jan 2026 16:15:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769818547; x=1770423347; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=JBT3eXirMhITfHBhMfm7jmk9GgDGwvmhXO+L7+fYBQE=;
        b=dFXP9uZV2M9Iv407sKTNakkoX6sdFPJlTY1DAN8JaUysL+EEUDBc1TROfBNWd0Fruk
         1uqvkFOgtBHIPJlayXk2zjaNmDDoWWTKnfx+zbnOKU0CIO0BsIJZCAVF0J7bSq4w9IdL
         PKfFDM2vb1RQg+LiltFcYRRh+BB3u2xwPncxdmS+0eMLUV+VDP+ZmDJtDlFKE2K8Hczr
         q7FxlMrK+zqTtTjQGcRpnIeusXIN6K1usUtYx2bo7iNLz/B9gQRQdq0p6NvKJLVimyTC
         YO5aXWRRQqkrJZ2BV4+ccmBI/0LHCDAFYgc+bEW+0RcPQkGifP7/xcrnO6oHDEmslFv6
         kujQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769818547; x=1770423347;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JBT3eXirMhITfHBhMfm7jmk9GgDGwvmhXO+L7+fYBQE=;
        b=LQOpBOl8f9+e5V4N66ZjmnkDkk6EXIABga55NbGLsGblYZyKokz+weDCN7VBP9xA2W
         197OZvvBVeYOwKdzdt2I8tnyTOt+RN00BzA1TnB4aAQTJ3TYrrzhXNe5AHhIh//rukFW
         FUSge8ds5w6g6cPFSWJhiNyB2k02J+acbs6cKywe0av2qK8D5NRhTgWK4aqfkH2yGBMW
         zZU18ZwiNmK6Ix6rp2crxHUW1XRqcRxQBG8Puc6U3+eRgapUUc5ncAg4KtRp8/NP/C3v
         v7WpDPSZxR4MbNYmzlTbxL7eZVFAOzMNlpzC9uYu0K631Macmvsj2AUSB2pBRBlKaDiP
         uEgg==
X-Forwarded-Encrypted: i=1; AJvYcCUtfm2i+wI5/rRF2Zf447lLQvIsVUZCqTycQWZPWf4hCRqGmQiGQt7iynHuFuo+r3Ghd8HIeop5SA==@kvack.org
X-Gm-Message-State: AOJu0Ywqehn5ouwUbkuyZK5IiGJXA14KLKuZSy6ZQB7YY9EuZI7IlYzc
	KRf+kzvZRBJHYXf8WW5B9aTlaRvb/FkA3ax9M6SNudbUnEw1wioDanCHPnqjqzxYtO3bQW1v3g1
	PbawXu9YSnktsALHRddTY+hXoDw==
X-Received: from plgx11.prod.google.com ([2002:a17:902:ec8b:b0:2a8:7205:a979])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:244b:b0:38d:f745:4d43 with SMTP id adf61e73a8af0-392e01329b9mr4952220637.57.1769818547428;
 Fri, 30 Jan 2026 16:15:47 -0800 (PST)
Date: Fri, 30 Jan 2026 16:15:37 -0800
In-Reply-To: <cover.1769818406.git.ackerleytng@google.com>
Mime-Version: 1.0
References: <cover.1769818406.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.53.0.rc1.225.gd81095ad13-goog
Message-ID: <720e32d8e185d5c82659bbdede05e87b3318c413.1769818406.git.ackerleytng@google.com>
Subject: [RFC PATCH v1 1/2] XArray tests: Fix check_split tests to store correctly
From: Ackerley Tng <ackerleytng@google.com>
To: willy@infradead.org, akpm@linux-foundation.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Cc: david@redhat.com, michael.roth@amd.com, dev.jain@arm.com, 
	vannapurve@google.com, Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 8793420009
X-Stat-Signature: 64ortdz9p17hrwf7cmd4em8iak4rpd5o
X-HE-Tag: 1769818548-847343
X-HE-Meta: U2FsdGVkX1+PAHQ507xltdUJTHqozOSQbCecyWIL/aTkk+1GYpKH20F2tMB7W+OoTJLrNaG/+Ys1Doste7Lhpb2pjajtU6OnLL3dKtm7MKf2JKwnA4Ya3oY4I5d2FqsaqamdDQtII1nHWDKi/Vhs43zSy5/qnsYP4N4vc3gi1oHasnUKbuYDET19vtHH1PVASka9dME04Tq895EkyYbQpF8PPCsXJVi6WOA8xxruf6lht2Exlo1NiqwXwHr0e+MOd6BkXyQDgtG+Pz+gVwn2c9qvcbL/HecPS9umpOgGO7MEM/az/SUZ/v+v99hI/gB/U8QeNWMeLRhFIm+M3WIOWKg02J7bx9w38sXGY8lF9/kOYQGKoT94VkEKJXyO/v2bGfZRi+bwfXPCP1iR5dB+tbai0xylB8JpYYNQf87w/sO7BmFEi3oeHACB034WaY+uLTkcN3+ma44uNLgBDfoIG2WLjMdeUJximeylu6Ec5+sFzwcBqajvV+7vYOgbpt5jmXyKOWHKgTalacb4ow3zWLRrrmsUFvF8L5MZRcc4VKpPigXJFbK7MxEDWpN62JsANyvNee2E7UFuBnFeHccuUcTk2O2CtIRrf842+lx7avYUoZVKmY4IxwAENdbkMhe4nVKy8BMlwwfZ1V087sRNtNH4xxharZoz+5cEqfyaRl4CnZl2d0tso8r41yjmg2cdSiYu3Mu1CxTApvs+CN336zb6vizcXGOObChAjBg2eADdP2opH7NEEqoy5P783/ZLH5MDr0tjMkPbX+ENOxpzE1DmRDN5y1ESIDHIz4+3pWNJQSrZ/8BbtR5NQlisGV452C8gna2x7968K+FVguYJBibJPMkt8ikwTI1ZnxuuEfd0ZCJC5BZIp7dtLNX1N2kLdXtpKxIxFJHLLb0FvggeUAR7yLqEmJTTJDt2XVCGK2k/35iLstbHx1SWNBDWRPcp8oazq40OFYRP5KIw+Ft
 VLaA2phm
 mwRWAZFh/9Eg4lhl3oqUQn93hXW0U7CsT/l0jsHCfp7YUUIt/DvlQMdSyLTE59lG0HbqhBOc+NtBpDSpwBcdm8UXiDsxYZW3Zm0YVVaUxOtHBU5Js3QR4aeoSsA8jZCjKd6x7tlrPeL5U1cmlCM2D1Nq1ffJ32zeiWicBLe/oMFsHNIA7uSqdKLVW/85cyFeLb+uxbaW/nVzcmz5vzR/km8vAivMr1awt+iuC1Pw6YZ0m3WxQAx8BLF510niL3AXQ9g4SkoqBZo9ZLXx9bznqzX9lNQyd7hFi8fN/JwADx2EyX4RcmdpCxlkjXbxTr9/p8fb7g3kPI5p+lejCLHTwsSX2+KK/5gwElxKSanQUuaKW+kSttQpDfuA7SLNtUc0ShcVoO1xLQhhFZqBp6cIH3CoiFZF6wTrecG0MHKE+ONwlBIBdF3h0Td42aNF+Ti3ixzu+TeczZyGN4E0cl9YbkjrMDako8lnKpqeGRZG8PqB1kgLSMyKOHG0sTxyjrd00Vqr64gzxxFIZ55Eouq3yo5YG/Md+b2BHCBqxJfl4oPaWZQK+jScnrnLvY6tBOP4knEl8vsyi7TV0f+NsGExPmE8pIfq1ewnr1Kt8ywTdTBiriH8w558tyBgVVhlwFoINEcMWtrrD8jZAeLfktabOs5mL24Kk7mbQCAqCnApufLYzKjPDSO/pmYcYSWT6SA8Zp6cwnCXSluceH86YaVQItNj8Iw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

__xa_store() does not set up xas->xa_sibs, and when it calls xas_store(),
xas_store() stops prematurely and does not update node->nr_values to count
all values and siblings. Hence, when working with multi-index XArrays,
__xa_store() cannot be used.

Fix tests by calling xas_store() directly with xas->xa_sibs correctly set
up.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 lib/test_xarray.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/lib/test_xarray.c b/lib/test_xarray.c
index 5ca0aefee9aa..e71e8ff76900 100644
--- a/lib/test_xarray.c
+++ b/lib/test_xarray.c
@@ -1846,8 +1846,14 @@ static void check_split_1(struct xarray *xa, unsigned long index,
 	xas_split_alloc(&xas, xa, order, GFP_KERNEL);
 	xas_lock(&xas);
 	xas_split(&xas, xa, order);
-	for (i = 0; i < (1 << order); i += (1 << new_order))
-		__xa_store(xa, index + i, xa_mk_index(index + i), 0);
+	for (i = 0; i < (1 << order); i += (1 << new_order)) {
+		xas_set_order(&xas, index + i, new_order);
+		/*
+		 * Don't worry about -ENOMEM, xas_split_alloc() and
+		 * xas_split() ensures that all nodes are allocated.
+		 */
+		xas_store(&xas, xa_mk_index(index + i));
+	}
 	xas_unlock(&xas);
 
 	for (i = 0; i < (1 << order); i++) {
@@ -1893,8 +1899,14 @@ static void check_split_2(struct xarray *xa, unsigned long index,
 		xas_unlock(&xas);
 		goto out;
 	}
-	for (i = 0; i < (1 << order); i += (1 << new_order))
-		__xa_store(xa, index + i, xa_mk_index(index + i), 0);
+	for (i = 0; i < (1 << order); i += (1 << new_order)) {
+		xas_set_order(&xas, index + i, new_order);
+		/*
+		 * Don't worry about -ENOMEM, xas_split_alloc() and
+		 * xas_split() ensures that all nodes are allocated.
+		 */
+		xas_store(&xas, xa_mk_index(index + i));
+	}
 	xas_unlock(&xas);
 
 	for (i = 0; i < (1 << order); i++) {
-- 
2.53.0.rc1.225.gd81095ad13-goog


