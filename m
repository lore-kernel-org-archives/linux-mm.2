Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78BD41099B56
	for <linux-mm@archiver.kernel.org>; Sat, 21 Mar 2026 00:52:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C3AE6B00C2; Fri, 20 Mar 2026 20:52:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7743C6B00D1; Fri, 20 Mar 2026 20:52:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 663036B00D3; Fri, 20 Mar 2026 20:52:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5357A6B00C2
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 20:52:57 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D7DB458C4C
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 00:52:56 +0000 (UTC)
X-FDA: 84568245552.22.5FFE156
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	by imf24.hostedemail.com (Postfix) with ESMTP id 48844180003
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 00:52:55 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="XC8sam4/";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774054375;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=G+5RzbziaymrrS+M4u37AJD7hgEjc3lgDwyej9fgC8U=;
	b=FfMyVT47wYwS58Urvxs/qCFGFl7Z1Oe5nZSDWZ/qntW3YpL9b7Hc/jvo7MA51I7hFChynu
	fwzH9sKAnGkUBdPi82zlUbDDW5akHz1FOeXt3KZCPODrPDTXe+izvVQ++VUCa7Lna8Rg9w
	2MsgfECC3nxDlNMGEi0GsY6AUE21XXY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774054375; a=rsa-sha256;
	cv=none;
	b=wvx0Z4EOOq77fqOvfZRATV9+kIMcNTHBNaM3mQZeiYg/o15j/r8v91SHRvBqcXctCk9MdW
	hdwm8W1PF+iylpzktlly+JXu05lfF52dUr6lamrZ/8AaHIc9EGon7PkziIgsWi3fnHmlju
	SldvupX62J2R+9wXlpn2BbfzOzKyPag=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="XC8sam4/";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2b062069f80so8443295ad.0
        for <linux-mm@kvack.org>; Fri, 20 Mar 2026 17:52:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1774054374; x=1774659174; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=G+5RzbziaymrrS+M4u37AJD7hgEjc3lgDwyej9fgC8U=;
        b=XC8sam4/6GRdgh/X/2RDQDMiJeST979EHs4mjNyrJnl99XTHMEgFxStW/CQyoYcQy3
         3n64u528GMrXs9OtgXpqscQArEQGmyppOv1IRV8yXnnIjTB8mP7hWm4ARAwZfT+cFhNJ
         PcNn1zTTITF91y0Us/mgS2x04NP/leev54wNbWisVv15AUxpvTjr3Zfy7V6h97fphpPf
         6J0b7mf9U9VGERu/c/WWUUuSXo56MGLxLD9Smd0dGmy9DcZCEw99gXNgFrK9FLYhSM3r
         XmjR7VFG0AuYvJxGiMchu4Gn29Q70QzDixJoxPAmL+SBCfd13eB0FMxDsLIM8XDBd9C7
         OOfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774054374; x=1774659174;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G+5RzbziaymrrS+M4u37AJD7hgEjc3lgDwyej9fgC8U=;
        b=S4HU1S/21pcFpoDDJ/M/xwYLNMV00x3JiPU2WKFL8kMz13qymyT8jzqHkF9DpMiP89
         IHsT+rFgmwt576pZdFQwiVcpKlcBOOFD3JVZNchKidAToLGUxolemAvd64vDglplIEP2
         BaIAzxtckoi4+c0dqoeAfy2MUhjRxdY5BOTKu544OLYa/u7HVBMHElCvIvB5gS4/5kSM
         gbxpJY8dkf74Ls+WZ9MF7taFPnwgiO/9mRb7uoVl5HBvv59FZB9SsHlmlt3We/nuTizA
         x5lSkPBvXXS35oBbYWfr8eKjiMWXPXj8u7v0wp/W713h7knG7lde7QKQ2o8mJ6Ti7BjP
         3qNQ==
X-Forwarded-Encrypted: i=1; AJvYcCV9GdMY1tSSSWV6cb3IjT+M1dw6NYH+OAyRgzc8dnKtT+9/wQrZcU4QwmVSoFmeKHDeA9Z3MwGCkw==@kvack.org
X-Gm-Message-State: AOJu0YxEyeX/Nz5hJ4AP/asqxR3EnZ4rgrVn7n22er9hzfqMxAIPolkC
	vmm8xPLfMembrm0yXzR2t/tro7Q90knvgsEzOXfH4WCiv00eOH0mo6f+mx+VnQ==
X-Gm-Gg: ATEYQzyPXTB3bu2Om4hCVgrMLIVFhNiQ+CansE8RqZWdfRWSGhlW0I9O4qtVOMNO4eV
	xFEUGFexD9B/lKxmgp/1+ijZobaf0YXE7fLJ5VlPY3PSIRDXJNcs9SAgjs2Rgixj4qQWWwFtOqO
	yYRKuj90Hjb4UGHKqNden4aKqdRSO0R59+CXgWqWapD4j9bEJ9bz8OP8QkBZPH6VHvWj7aY7ddc
	8VdmsnyIl4Y4XsYGUvr9sa+qRmeefFe5xx4MWTYXXo65zohH5oBnxIO9mD4FKaCdIbo9TwqHfBO
	vuSL/zxBYSsq7QRRLdapHvaEwgnNTGvr3CxweIDfkEs/TX6S4iI9xDzE5REcNK4GYEsLWzJpkD2
	dneK6hgjy6ZPxE1J7XCfU4hbCOpN2qQTPfAIGi4OxDgZS+2ZFYYxoPEcv6Xz/Bu5jTkZcjeD7WW
	ElhmX39yjyak0X7U90h7xXlzAzSx/BvyeYyi9/DgGFxbdSJSVwXrQ=
X-Received: by 2002:a17:903:acb:b0:2ae:6012:3168 with SMTP id d9443c01a7336-2b0827a7710mr40513555ad.32.1774054374011;
        Fri, 20 Mar 2026 17:52:54 -0700 (PDT)
Received: from celestia.taila51cc2.ts.net ([2402:1980:898b:301c:d085:a35:99e7:ffec])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b08353e94asm34872915ad.25.2026.03.20.17.52.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Mar 2026 17:52:53 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: sj@kernel.org
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	Liew Rui Yan <aethernet65535@gmail.com>
Subject: [PATCH v3] mm/damon/ops-common: optimize damon_hot_score() using ilog2()
Date: Sat, 21 Mar 2026 08:52:48 +0800
Message-ID: <20260321005248.6114-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 48844180003
X-Stat-Signature: 1xb6i5qee5aeswjxfofmr5kntc1chjur
X-Rspam-User: 
X-HE-Tag: 1774054375-831628
X-HE-Meta: U2FsdGVkX18OinX53j7EvMoY3aOQ1YQr1vZGjl8JrAVmI2MVmitLyIr7q5KVhbJaZ01Y99srAj56W1hHIiTcyBnbQ0gAA5ov7V4aE60IDsirTIfAB/TbTIBI1t7rPz93l9a8/3JER/2lnLpCLyepRLO2aYtcf8tKatRIm9ovg3q0k3ZFlzjkxD/DUhg6685sRLFx51ey0beDnixEeZVNHMBm4078ozFR4tgRa98wu02P76yicdf5LC+KOE46V1pJCeUb+T/3UUh21i5GDvsBglJT1f+qeS1buL34Ge2Sq0qB2I+z2xP8x9o3WV60apvtXvdN7xiQQ2exaZuCILXHjW4MXAFiVYbQNzWthdZy2/zXLkVfv9Dj0BdYIvc45zmScvUZXp89gPQfG+wR98T8i5pqa22gwL6nu7Y5N/Vo7/03m3zsiHKr4fLjeyQ7UUpBFbGnpIkd97aLz3aoMqdcm+PCxQ+lLE2aZ6u5uN3EZ2UjYc6bUjH0TwhNyWSlyT588cCOg1WDX/Tjf/vxjPJymiqK53PNnsq2EeNeyTLMf0ORZ9HqZFau4m2vETGCTfoxleReyLYwU/6rbiwjucUtJl1Vb/xFHmrQrnQehjK409q/j2saBZwMcFNmiXGi5bFBlwbwB8sqh1bRqOzs9G7B3Y8/3rt8XUthwVRmPo5Y8taAQiM8ssg7MjOjSGX0/kfVxquc5pjLFGnT3yD8F5gCLBpjA2HO8VBnqqW8MlXgJn4RsEynYGYUvkBUiJbBbtQDNOgwbweYMiYxdepq1xFW1LaILzBEzogAyCVPAn/1IVwl3LbZBaRzd7gFUDS9jz47HOjj/15uOxB5Mk4Fazq2sM1rOdJAN6O2A4aWAJ/+JRXhd6p7Fic3emIUaER3DWgnOrd56eY0E7dNqhTX23U66h8d9KI3SQnRoSmYWokuD4o+5d2uVcJFYmJxvFv/JkGrs+DJP9I/ANaE1ysyaNb
 3E8hQMmV
 asN8Ayv/lbrlnNuoxky3WgSLsY49aYzSntuSdFjij6Pdob1fynDtgmJMq/Vqaw6S8n4AMkG4XI7eKXYjqwL7At9KufxbSqU+8UhIh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The current implementation of damon_hot_score() uses a manual for-loop
to calculate the value of 'age_in_log'. This can be efficiently replaced
by ilog2(), which is semantically more appropriate for calculating the
logarithmic value of age.

In a simulated-kernel-module performance test with 10,000,000 iterations,
this optimization showed a significant reduction in latency (average
latency reduced from ~12ns to ~1ns).

Test results from the simulated-kernel-module:
- ilog2:
    DAMON Perf Test: Starting 10000000 iterations
    =============================================
     Total Iterations : 10000000
     Average Latency  : 1 ns
     P95 Latency      : 41 ns
     P99 Latency      : 41 ns
    ---------------------------------------------
     Range (ns)      | Count        | Percent
    ---------------------------------------------
     0-19            | 0            |      0%
     20-39           | 2625000      |     26%
     40-59           | 7374000      |     73%
     60-79           | 0            |      0%
     80-99           | 0            |      0%
     100+            | 1000         |      0%
    =============================================

- for-loop:
    DAMON Perf Test: Starting 10000000 iterations
    =============================================
     Total Iterations : 10000000
     Average Latency  : 12 ns
     P95 Latency      : 51 ns
     P99 Latency      : 60 ns
    ---------------------------------------------
     Range (ns)      | Count        | Percent
    ---------------------------------------------
     0-19            | 0            |      0%
     20-39           | 0            |      0%
     40-59           | 9862000      |     98%
     60-79           | 135000       |      1%
     80-99           | 1000         |      0%
     100+            | 2000         |      0%
    =============================================

Full raw benchmark results can be found at [1].

[1] https://github.com/aethernet65535/damon-hot-score-fls-optimize/tree/master/result-raw

Signed-off-by: Liew Rui Yan <aethernet65535@gmail.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
---
Changes from v2:
- Send as a new thread instead of a reply to previous version.
- Add SeongJae Park's Reviewed-by tag.
- Link to v2: https://lore.kernel.org/20260320192020.33004-1-aethernet65535@gmail.com

Changes from v1:
- Replace fls() with ilog2() per SeongJae Park's suggestion for better
  semantic clarity.
- Move performance benchmark results into the commit message and add 
  comparison between for-loop and ilog2.
- Link to v1: https://lore.kernel.org/20260320072431.248235-1-aethernet65535@gmail.com/

 mm/damon/ops-common.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/mm/damon/ops-common.c b/mm/damon/ops-common.c
index a218d9922234..ac604fb7b409 100644
--- a/mm/damon/ops-common.c
+++ b/mm/damon/ops-common.c
@@ -117,9 +117,12 @@ int damon_hot_score(struct damon_ctx *c, struct damon_region *r,
 		damon_max_nr_accesses(&c->attrs);
 
 	age_in_sec = (unsigned long)r->age * c->attrs.aggr_interval / 1000000;
-	for (age_in_log = 0; age_in_log < DAMON_MAX_AGE_IN_LOG && age_in_sec;
-			age_in_log++, age_in_sec >>= 1)
-		;
+	if (age_in_sec)
+		age_in_log = min_t(int, ilog2(age_in_sec) + 1,
+				DAMON_MAX_AGE_IN_LOG);
+	else
+		age_in_log = 0;
+
 
 	/* If frequency is 0, higher age means it's colder */
 	if (freq_subscore == 0)
-- 
2.53.0


