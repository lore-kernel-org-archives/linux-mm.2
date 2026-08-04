Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA69AC55184
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 18:24:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C49CA6B00D7; Tue,  4 Aug 2026 14:24:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C219A6B00D8; Tue,  4 Aug 2026 14:24:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B11056B00D9; Tue,  4 Aug 2026 14:24:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8DF016B00D7
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 14:24:21 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 951C6A028D
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 18:24:19 +0000 (UTC)
X-FDA: 85064411838.01.E889CCA
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by imf29.hostedemail.com (Postfix) with ESMTP id 00D1A120004
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 18:24:17 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=tCxG12rF;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf29.hostedemail.com: domain of 3UC5yag0KCM8vw23D2z5wvAvE19916z.x97638FI-775Gvx5.9C1@flex--abhishekbapat.bounces.google.com designates 209.85.214.198 as permitted sender) smtp.mailfrom=3UC5yag0KCM8vw23D2z5wvAvE19916z.x97638FI-775Gvx5.9C1@flex--abhishekbapat.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785867858;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=wLVFLwy4jLfqkID0RW7WBF3ACnY+VhQRvkXSUAqMI9I=;
	b=zfOFdqXk0jEMKnG1iUSGEJss+PSRiwzf+Ko34/Gq7wljQyEsfeG4qFmuZkvma77KUFeDyg
	FezQqYgwKfMM7bF716btiD4q7ew/7xP/ySMOSarbetb6yW7iIdzTBduCa4ryNxADUBm8JS
	IVGzeSqxoKACiObXQDpH0bFVZIZ94+Q=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=tCxG12rF;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf29.hostedemail.com: domain of 3UC5yag0KCM8vw23D2z5wvAvE19916z.x97638FI-775Gvx5.9C1@flex--abhishekbapat.bounces.google.com designates 209.85.214.198 as permitted sender) smtp.mailfrom=3UC5yag0KCM8vw23D2z5wvAvE19916z.x97638FI-775Gvx5.9C1@flex--abhishekbapat.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785867858;
	b=1wAQ/298uim9dZL3FZKC/fIYfoiFCYQAwYWVSMNGyOmxzXr71RABO08M54rFevIkEnbisl
	SFaqUZLEzkmJbh+RdM0ZhkQ+9tVgoloGZnsoV/1Huf6aOwl1KSGPAiX0vYylfMymOZkvUO
	UZtytWmU5P3nIpRrQXeEssy2GTsSAEs=
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2d04908139bso2353265ad.2
        for <linux-mm@kvack.org>; Tue, 04 Aug 2026 11:24:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785867857; x=1786472657; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=wLVFLwy4jLfqkID0RW7WBF3ACnY+VhQRvkXSUAqMI9I=;
        b=tCxG12rFr7fFpBT1ObZGBcfaCQCoBpNNXzjWAsZnvi0eXKZijxfxFWZKPCATwSGp7t
         LQB6v9NrFhq7hXDrpymWcr94rjS8NpMOj91wkZruvCy/9wvXaoNyNYHKUncXJNjjsJ+s
         AwsgyRBZbMxmgeBjupVJRp/1D5PYQvarPDNPFVCTYgwE6wzYZCj9OiDRK9WTKg8Kvxs7
         szUAdR8u4yo4SktY/ssSN4mL21WxNYJQXtpnJsJnPy27ONCEsVEjGMqgqDY5gxNxkcI5
         BRR25Wvj9wCB/zO9pyqeAFusfDPR+A2NjytJxArtKqPLxslYsr0O+5DVNXZQywi+3lTn
         AJ5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785867857; x=1786472657;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wLVFLwy4jLfqkID0RW7WBF3ACnY+VhQRvkXSUAqMI9I=;
        b=i0yPhSJuzHB/nAGnS+uyq98B0FDvwtK09PTlTCwjT7dt1OSq9U5ZNnTLhTDOl82ZIG
         LtgI6a1QKLTGp9T+TnHqC+WsfWBp0iUdKtSVQmjhNxqzHM/OATC2NAeORSPvus68uY3D
         6M3mF0A+ocx9eTVl51v2MMf2OOspruN6HO+dmJ4PS3MDUSvgJTxyFFla4xcHWTiXB2zj
         LsIaLwLtZg2+xYAmMbK69Nwa8cFOQS6T0+e1YnYOGm1+sOoTjCJwu2p7oDON4vMNR7oT
         kUrhzrAIZVtjhKautZaGb1VgAJmdOWLgNsM+oPygFs8rbhkcMnRlEydYj8Jn5P7Jw9vW
         M7cQ==
X-Forwarded-Encrypted: i=1; AHgh+RoJ5X8uBd7UsmJoQ/G3S1kpMBQj/vKtPOSHwlMCuQWhSr8Go0kxoFvtwxTYD2k5SoTUc5Yy0+LuVA==@kvack.org
X-Gm-Message-State: AOJu0Yz4YU9iJ8KYvVQF5N2Ne0kxP6aGwFkIxWU9n2dPu1luWoM3eYKG
	M6jRiQyNimsxAHNeCzW1fUiUg9wjq9vkTjGi6se23YNixPqeHVMgbJzrNSfvKZuMGjOU6jLf06O
	LGcMoLSRdZySw2CYEBVGLg+2KP50Rp3LfEA==
X-Received: from plbj20.prod.google.com ([2002:a17:903:4654:b0:2cb:6ca0:1248])
 (user=abhishekbapat job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:2288:b0:2cf:9cf2:3533 with SMTP id d9443c01a7336-2d0ca99124emr5989425ad.18.1785867856521;
 Tue, 04 Aug 2026 11:24:16 -0700 (PDT)
Date: Tue,  4 Aug 2026 18:24:14 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.508.g3f0d502094-goog
Message-ID: <e4e49ec4a5960292aeeb9e196526c18dc95228a2.1785867739.git.abhishekbapat@google.com>
Subject: [PATCH] alloc_tag: add ioctl to /proc/allocinfo -fix
From: Abhishek Bapat <abhishekbapat@google.com>
To: Suren Baghdasaryan <surenb@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Hao Ge <hao.ge@linux.dev>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Abhishek Bapat <abhishekbapat@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Stat-Signature: 5waxwk5kfgfptnibzst1sazf4xf11sru
X-Rspamd-Queue-Id: 00D1A120004
X-HE-Tag: 1785867857-616575
X-HE-Meta: U2FsdGVkX1/iKEa8de9UQrYQGcpkkBir4xUCHlBJJaITlics/2TlUrcIR73LAXhFvYjen227fud8m/5A6523D84CWpxPdV4Yz2YCJQsDgnyR/SUpjI3gBRrSLgKBcJ2tITvvvPsNk6HggwREUsnoGXU9Ng6a5IuA8zp/JvS+1qL/pqA+EqrOM4V3OBQixJ7tXKbIkx1vlu09797ZTtzI72h6s4plOkhboB8ukQRsxDHG2FCdCjOQQR5vYGR6PRTDR56utX5ilkZABvdeTskodeEVHJ4cLXPzUk2biBGolM4AWOUxQvuCaj2awuIgVApbPpbPcCPh7FLOqYhttKouPHccFZ7g3x0SGrJ/Pt8OY+il9VdyxnVl6Hr+WtjfE/8Stn44fV8FSeei1KkYA+MlBYBq8pdvUcSHrvRACaDffGz/sBFGqooE0a+0CpT74tJs4BvpTI2Xh9NCRUv7yWeqxPOxQ1F3pbxBuopRTlFIJ9wCOug4uwMy0jYb4q1d5vfDveUnp9GGv8eXsLj4LSSK1TH8epWlA+x6H7D9tGAK8NIvEmnGlnOaFPcdIpHJMbAYRKzME3i8RqKjn3zgk0tbQTV+ABbad7KkJrfH/1y7BW+umA54YioOzeubwzGZHl36EYnLD2Ey0tmD+0tZQV2mifbWLk/fPD3vT8Kiw9LudzQMXRuzjdlh/WQRvKASbqei2SM7iTtlNLziUnXXBp3VbO19D3wkv6pfn75Zj2NH7R3TFJbrXayxSUqb3MndUsu5kgLVzhPjuHDz8akkzuesgOVAzTwP44pS8Fk7w1xEcEf/B00ejunXP02j3L0j1yJESrrOG7Tsqul0wgnQZCAsrjVr5gPrQ5YRSoVMbXFeupt1KXR/xBN85yCyVxidgbnMCocGDK6PSziLM9xZ6iMZmSu7IdkQM2XKVwY0WjxbTHYIJQz2+8fZZeOky5p48fIJH4yZu29kvciW+rHuPPZ
 XBo41P2T
 JyZzbCRn3D7a6sFD1mcBk3mABsOGX8gjhz5DfwNkX8/WeaQBHh3oLZq0o7BVIkEklFBjCYSUc0WK9echLoOGeZM3F97pEGXu7fPlI2ndLNa80ZXq9GPihXo0irayyRL2vEdexMLJ57sVw5ck3lfHFLrIeA//d1GcRrOp9QMBvAfGmLF35wyVWwUpwkVStN03agiKdq5AbepBsmdGniViSygMYjC24CRuKoZZaxABkUT4BxgMv4G1cnUpXdKflE8jtR5/6/WlhjJB9kkZco5C8aDdjVCxBmyE+AzisZLmRuxL5w0+/hFVGBh8zxzYNxWirmQUCv7ZCmk9XqYl5wSowhPhhgvFVfZnp16eGVviVV+QFiWCvVg6WqMRndAR3qT0GsQ0imgC83GCE2ZfWa5CVmDxUpnCwTPMjdkiHTxOUd20Wo3wbNd+FW1cXM6J/CF93BsoK8rvPMliFddiWTGi4UEZHQ50tjtKtD4QWgoY3OxZNb+iTtG3rzYeknyoe+QeX5tJZ0+J3hrGTd++SPeNwh+5PqXEt0A6VsXbbw1AjwJemKdSPHU3Fg1y+dOrR2mqhq4XqPa7YZT34GwQN8vCmz9NSIUTNpGeJ2qiChe+OGkPUIbGkv98O8o3gfd/hmfcIG9Rh/tV6PWhko0v9PD+CFUQe7MvjxUYsNRmLX02nvE/FJugBOr1AokEt8h/ZBg52a6447Gxg+oCDhQZj6nWAhAZ18Vms4tXfree6QYGRCaQxIGA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Move the `inaccurate` filtering criteria from `struct allocinfo_tag` to
`struct allocinfo_filter`. Also fix a typo in the selftest added to
validate the introduced feature.

This is a fixup patch to resolve a pending comment left by sashiko on
the patch series starting with Commit bc3da70ba4d9 ("alloc_tag: add ioctl
to /proc/allocinfo").

Note, sashiko also left a valid comment on the selftest about the sscanf
in the test skipping loaded modules, however, it was a deliberate design
choice. The modules were kept out of the test baseline on purpose as
dunamic module loading/unloading can trigger content_id mismatches
(which can cause flakiness). Since the IOCTL logic itself function
regardless of whether the codetag is in vmlinux or a loadable module,
stocking to stable built-in targets keeps the tests robust.

Fixes: b011dfc9f8d6 ("alloc_tag: add accuracy based filtering to ioctl")
Fixes: 359316c50445 ("kselftest: alloc_tag: add kselftest for ioctl interface")
Closes: https://sashiko.dev/#/patchset/cover.1783532853.git.abhishekbapat@google.com
Signed-off-by: Abhishek Bapat <abhishekbapat@google.com>
---
 include/uapi/linux/alloc_tag.h                           | 4 ++--
 mm/alloc_tag.c                                           | 2 +-
 tools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/uapi/linux/alloc_tag.h b/include/uapi/linux/alloc_tag.h
index 270f693b1822..e3ad94444864 100644
--- a/include/uapi/linux/alloc_tag.h
+++ b/include/uapi/linux/alloc_tag.h
@@ -31,8 +31,6 @@ struct allocinfo_tag {
 	char function[ALLOCINFO_STR_SIZE];
 	char filename[ALLOCINFO_STR_SIZE];
 	__u64 lineno;
-	/* filter criteria only; see allocinfo_counter.accurate for actual accuracy */
-	__u64 inaccurate;
 };
 
 /* The alignment ensures 32-bit compatible interfaces are not broken */
@@ -74,6 +72,8 @@ struct allocinfo_filter {
 	struct allocinfo_tag fields;
 	__u64 min_size;
 	__u64 max_size;
+	/* filter criteria only; see allocinfo_counter.accurate for actual accuracy */
+	__u64 inaccurate;
 };
 
 struct allocinfo_get_at {
diff --git a/mm/alloc_tag.c b/mm/alloc_tag.c
index 52aece27b00e..84c5c3783ca4 100644
--- a/mm/alloc_tag.c
+++ b/mm/alloc_tag.c
@@ -291,7 +291,7 @@ static bool matches_filter(struct codetag *ct, struct allocinfo_filter *filter,
 
 	if (filter->mask & ALLOCINFO_FILTER_MASK_INACCURATE) {
 		inaccurate = !!(ct->flags & CODETAG_FLAG_INACCURATE);
-		if (inaccurate != !!(filter->fields.inaccurate))
+		if (inaccurate != !!(filter->inaccurate))
 			return false;
 	}
 
diff --git a/tools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c b/tools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c
index 7d94abb785a1..74fd64b2370c 100644
--- a/tools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c
+++ b/tools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0-only
 
 /* kselftest for allocinfo ioctl
- * allocinfo ioctl retrives allocinfo data through ioctl
+ * allocinfo ioctl retrieves allocinfo data through ioctl
  * Copyright (C) 2026 Google, Inc.
  */
 

base-commit: 486855239e38a91d3eae26618ccb7845c1764625
-- 
2.55.0.508.g3f0d502094-goog


