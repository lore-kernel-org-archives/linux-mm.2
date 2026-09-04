Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F5AEC79F87
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 22:06:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DAE396B008A; Fri,  4 Sep 2026 18:06:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D862A6B008C; Fri,  4 Sep 2026 18:06:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4E326B0092; Fri,  4 Sep 2026 18:06:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9DD5A6B008A
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 18:06:02 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1A1D6A4031
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 22:06:02 +0000 (UTC)
X-FDA: 85177463364.16.BB8BD6F
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
	by imf16.hostedemail.com (Postfix) with ESMTP id 5C3E2180005
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 22:06:00 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=vmmpQPmD;
	spf=pass (imf16.hostedemail.com: domain of 3xkCbaggKCBE91yrDr0rx55x2v.t532z4BE-331Crt1.58x@flex--skhawaja.bounces.google.com designates 209.85.215.198 as permitted sender) smtp.mailfrom=3xkCbaggKCBE91yrDr0rx55x2v.t532z4BE-331Crt1.58x@flex--skhawaja.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788559560;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gFPQMsmC48q+wz7mUdVX+fcsDqeGsLw2XrmLniTg61k=;
	b=MBvnv5EWTNmm35Iaf6OpWyS0iMAdfk94JLFx1IhqxTI84VSKqy3/4isH8neZ7KartsOm+3
	GXIVwJcutXdbssplGutKZASlriXzSbG1atd47vVvA3S7ks2brdDAorLPs1zCnrf9Y6MFWO
	qPy5iUsYuLU5F1f0bn/Q/lwZOyonGF8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788559560;
	b=0qM8etPxX98Qe4yqcFdF6YYhWGQG74pVfCMTYXngeR+V3Nfc31NgVC8glY9tX7QUDvDEG4
	GwuNsePHaeTYkeRAdr9ZQ0zD/cp9Q6T7HzkXD/nbcwF2Hc3t0VlQVPKJKMaYOGl251AEUl
	9qx2FJ7YuRAJhDiruaEYsYGiUMTOyX8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=vmmpQPmD;
	spf=pass (imf16.hostedemail.com: domain of 3xkCbaggKCBE91yrDr0rx55x2v.t532z4BE-331Crt1.58x@flex--skhawaja.bounces.google.com designates 209.85.215.198 as permitted sender) smtp.mailfrom=3xkCbaggKCBE91yrDr0rx55x2v.t532z4BE-331Crt1.58x@flex--skhawaja.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-cc39363cc88so1584987a12.0
        for <linux-mm@kvack.org>; Fri, 04 Sep 2026 15:06:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788559559; x=1789164359; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gFPQMsmC48q+wz7mUdVX+fcsDqeGsLw2XrmLniTg61k=;
        b=vmmpQPmDwwgrhOK3Y26sCBsT9ZeiFF7dvlfg1Sr/dgrBs5wepAxClrk+8J0Ad6ezOW
         pnkJcWl7IzfS2OhNyj7SqJlfyfBD6ZsUvIubzH/+ELC6JG2kIkApfkorL8UnpJ5IkiUu
         aAh5WF6R4KJKow3aVHqUHTBKotUsVrMyaQveCp6WJhU6AzahA/iuxkqVZVdRNtAc2AzE
         nMWNiFh1pi4j9rhy+/4dpn7tfPSfXAu3BHsZGuCa31VVTg+OV6gFBJPfi0Dsbe3sU4uN
         GasY+qRyyoyCFPIVdvgq2aUGRkB8ts70VaBc1VlVT8qolV0kUVl6aYP0VqbJdzlJaHwt
         1RAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788559559; x=1789164359;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gFPQMsmC48q+wz7mUdVX+fcsDqeGsLw2XrmLniTg61k=;
        b=AWGh4iiic0Mpetwzkz1hxxJtAwHkaUC0lOu37Ctoh+0p+uW3wVb+o9dUhsBD5bLhOY
         qz5A/FrA7M+CSLI4jvKA9u67NvGpUZFMC1wHv2Q2LMn/kWLfH8fwDA46yh1un31/UAFn
         2y/Go/u0l/NPAYyH0oxJI/C1nTkgKEeoMC32p76TH1WnbGpuGWuSK/sRx92kRF52+nMd
         IKlGNZ6353bk1+eSrV58cD9qIJ8pYRaa/by/uJ6wDLav/ZHkLCmxJhSg5yd7SqFFi+Ip
         Rga94D1GiIXV/uT1f+8jXsaD9pNLpkrXmH0+d1sBq98DsGpATlzrHlGyqohnsrWdK+8F
         Uopg==
X-Forwarded-Encrypted: i=1; AKwUvBxvWbFWYyYlLXUBVtb0dEXgcLzOHRvxlIy14oMCyxmw+DzsBMWcIZ9q1fZrnsinBmd23hXaNdfdYw==@kvack.org
X-Gm-Message-State: AFuF++mHKOCp0+0RTXej5nCACHrJKwMtCFKQiFvEiuLRSteSwDYF4vUy
	Tlv9jfm2niDScg6LAKHZjn9h/IThOaqH7fbuYz7h/Jybuy1hfl3zlaeG9LWaOO2mxYQgi09BG7x
	L71GsbKyM5mJZvg==
X-Received: from pfbhm10.prod.google.com ([2002:a05:6a00:670a:b0:859:a043:9ede])
 (user=skhawaja job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:13a2:b0:858:6307:5f7d with SMTP id d2e1a72fcca58-86166dbb899mr12027017b3a.8.1788559558716;
 Fri, 04 Sep 2026 15:05:58 -0700 (PDT)
Date: Fri,  4 Sep 2026 22:05:54 +0000
In-Reply-To: <20260904220555.589752-1-skhawaja@google.com>
Mime-Version: 1.0
References: <20260904220555.589752-1-skhawaja@google.com>
X-Mailer: git-send-email 2.55.0.1003.g10538fe699-goog
Message-ID: <20260904220555.589752-2-skhawaja@google.com>
Subject: [PATCH 1/1] liveupdate: luo_file: Add documentation for dependencies
From: Samiullah Khawaja <skhawaja@google.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>, Mike Rapoport <rppt@kernel.org>, 
	Pratyush Yadav <pratyush@kernel.org>, Alexander Graf <graf@amazon.com>
Cc: Samiullah Khawaja <skhawaja@google.com>, David Matlack <dmatlack@google.com>, tarunsahu@google.com, 
	open list <linux-kernel@vger.kernel.org>, 
	"open list:KEXEC HANDOVER (KHO)" <kexec@lists.infradead.org>, 
	"open list:KEXEC HANDOVER (KHO)" <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 5C3E2180005
X-Stat-Signature: 7fi91xo93aerfeje88xhh6uab78t5y5k
X-HE-Tag: 1788559560-453589
X-HE-Meta: U2FsdGVkX19HfY6Tz2kB5lQOx1pl4Hw4bFehxi+DJZQI8dYXCS5Y2RUo/O0QTTrXR2PRxVxZ1wsBPYsqikhbPgu/6O7//JIEZf3FvtttBsUVZ4fk5yii7eilg5qd6ZIfneBMi89oBnhbFybd8bKEx0sImgHaA7xUbWUn32q18z/PlGbkkp6tMJ8JKrxcUHbpg5sD47zoEAxSu6PQxRmnJVJ2PriirRLRmxshgkv7T5HVGhhYwORRFjjaiKBIYUdIaN+y+EfeGZF61JVJFdGCf0Sw20Eo7+bcYr2+pdqGr0/u+xmJTujUjsT6C46bE5SCqxLSwziUpL9VBhpGcsfJNkTgdB2ORrR6eNHdkClett/m2rok4dO079pYvkB6tWrTv9Hi0vcYObUBwqsvinow0jOXS+1cj5tmyeJxAWnQ3eWApdwFQUA1Hxm3tglk3g2gY+lB1i+pnysBuavNENUeoyX8WFQWpPx5xWiIWb1UGWzPHzufL3WTgVdw+no/fe9REbAFx4vcuDecfH+o0ywng7LkOJGxSUwMKq2uLPb3Kg9QRBk3L51Fd6qOWEtbYhLKjLCfyYjJyB+P593+kPsTg/4nUzymRg2GzwbmZfuWQvxkudy0SICEZ1DDU8Zjc8j5PQc1geIAMR7/x48vM1M8uhtttmSQkB/6x7UxqHUiC9UHnjwNnV9rIhu1IQ50qSn2vHAYOpuFwKNPSTkjayyY5bQZqK3pkwj/XLjrlLVxbT3e5lw8XRRU/UPaElFu2D3mX9e9F9ewKzRTecre6Jhd2Ox/KBNwlMr4maKUPPFcAGxWfynS7nTLFuQXUe0AsC0ruZZ+t16fTvY9qOrXXxFRoLCVt64uzE3teYPRRJfZo/96hE/DCVut/nkPgw6SxGr44cKsqvDT/Y5DBDuLMLrOT8qMwXtcmimrubl4BpMgjlhvhrSI9+gPINgarqyz/mHKeoftNkal/dVZhdtYBOL
 5f79aqtc
 Y0x9/OsBfOqKC0e3FFXj5abqehCKotrozdR4lt5F5fTB6b0mfC70Avv3APk9iCAf/2FW7s/041X4Hm26IpcXa05yRqECVkYX1++AKaLnZWiAmpcBSOPnxjtUeVSPBzQwO3MPJNhJcSMvQyh2mnSuoa1awdjnij6ae8RwHFvqOlydnozWfanS7kK3mfHK/E38pOVjnJPnXUXX8BT4Gq6LORsE0MWwwNchjKLvhtyjhBV28jrBDx0I9v8napEXgFBMEHTzJvq8IpnGpZAwNuGuPKFrPgVFxNDIpRuMJny6xLdg/uMHRAjdMFWtohgoFAH8+tSioVavmhYof8vZJWDPg2rwoniU6V0OoEyJSAMWWcXed2qKScy3/w1o/cNZGk1e4RwshYsJ9PLOG80uD4O1RALugSJTy/K9DWUJ+JqekLwosrYRimg4ZN0CjVtNjUcMaTZgKa3t21+cyKl/g55W4m52pEnYeGRDjwcF5hUySlK7ion8cFvNUyxewHJn86RFirf37zBF5XcL2sFJfVwkcLSJzvmD4IpuRO4Dbt4u5BzOlxkklSuigQ2cKk2vCuXMg/3GHb/IK4xDrbq3Mtts/d2FY9dMm3Ye1l+ZMV9HnKEgh4OTjexrVMuGwcA+nW8nfI3G9BUR0pQJo7Pw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add documentation for dependencies between FDs preserved by File
Handlers. This supplements the previously added
liveupdate_get_token_outgoing() and liveupdate_get_file_incoming()
internal APIs to allow File Handlers to resolve dependencies.

Signed-off-by: Samiullah Khawaja <skhawaja@google.com>
---
 kernel/liveupdate/luo_file.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
index dbae0715220b..0a4994377c98 100644
--- a/kernel/liveupdate/luo_file.c
+++ b/kernel/liveupdate/luo_file.c
@@ -91,6 +91,21 @@
  *    again later. If the issue cannot be resolved, these resources will be held
  *    by LUO until the next live update cycle, at which point they will be
  *    discarded.
+ *
+ * Dependencies:
+ *
+ * Preserved files may have dependencies on other files that also need to be
+ * preserved during a live update. A file handler can resolve these dependencies
+ * by querying the token of the dependency. That token can then be serialized
+ * and used to fetch the dependency during the retrieve() callback in the next
+ * kernel.
+ *
+ * Some of these dependencies can be resolved late during File Handler freeze()
+ * callback, but some of these might need resolution during File Handler
+ * preserve() callback based on the constraints such as immutability and
+ * performance. This introduces an order of preservation. Note that the order of
+ * preservation of dependencies can be safely relaxed later, but it cannot be
+ * enforced later.
  */
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
-- 
2.55.0.1003.g10538fe699-goog


