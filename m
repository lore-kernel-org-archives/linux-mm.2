Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76AEFCA101F
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 15:11:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D23296B00C1; Fri, 12 Sep 2025 11:11:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFA4C6B00C3; Fri, 12 Sep 2025 11:11:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C37A56B00C4; Fri, 12 Sep 2025 11:11:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B17086B00C1
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 11:11:19 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7415613BDA3
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 15:11:19 +0000 (UTC)
X-FDA: 83880936678.08.E403BB5
Received: from mail-yb1-f171.google.com (mail-yb1-f171.google.com [209.85.219.171])
	by imf15.hostedemail.com (Postfix) with ESMTP id 7C99AA001B
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 15:11:17 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=JWd9VAn+;
	spf=pass (imf15.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.219.171 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757689877;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CNs2h9oqVJ2U55pyNU2xzrbkzs9MTq1sjEL+cOU6gkc=;
	b=usJJJgpvFJ0B3dRY3ywxXGH+Ev+CbG8poey64XJ/nxt8O4qR7oGB4YlNYhlZljwOmjkSgk
	bzT3scwLMbXWW5c4+plgHnxoUE9fCWcliH7W4IGbF74l72qcjb7d//G2kfj+rmUkk24QI8
	wVbwJ+59WZc8LYkjXklH8PWxCCPk+xQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757689877; a=rsa-sha256;
	cv=none;
	b=WiKipbzUvJZc8QR1C73lFqHQTRi12BLAHafv8xqZR/8JsQTWGEjan8QFCIzETz2xYQZOnd
	Ek6rAs6UkZyWL6g3ImhawsboJdQNBfMtksRscVJDJN+zAxGK+e00SnTJuHWcJw2Z17gvL5
	yo5cOo5syeVDarou3gOqAhaV8mrAAJg=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=JWd9VAn+;
	spf=pass (imf15.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.219.171 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
Received: by mail-yb1-f171.google.com with SMTP id 3f1490d57ef6-ea3e0b4a98aso494862276.1
        for <linux-mm@kvack.org>; Fri, 12 Sep 2025 08:11:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1757689876; x=1758294676; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CNs2h9oqVJ2U55pyNU2xzrbkzs9MTq1sjEL+cOU6gkc=;
        b=JWd9VAn+ik61/wvjYZl5rPkHXMD4gdLItsFbW8Mnk0aarL9riR6+PYj1zVXjlaCmrk
         oZ+rF2C8i8p1WK13DOVdSGes5RVLZPbTaeutXYFpRIxYnf6HIpLWp0eRi2XaxI/23OUK
         UqHqhZ4O0xJZHj6Ww8EI0X8X2WstGsC71ANdgRFONZvokSznUQeH7B60KCOuNNLwqbrj
         6BApENMkwBvPqy7PH2fHdfkbyy4FXXf8uEKYiajF1QlOC66HPJccugRfN+sD669oZdFc
         1P9xNjSyuVUMSL5BvGN9PDiM1OUYL3XAvTMZa7tYvQFHpMcMHhHBTkBWjY2a9FHGhohQ
         h9qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757689876; x=1758294676;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CNs2h9oqVJ2U55pyNU2xzrbkzs9MTq1sjEL+cOU6gkc=;
        b=qRZP6BQL/Gs6mt0vsoNoVz+rajptz715aDvZ3TbH0w/XI+0wDeweRaR6nUUDAhbJeH
         F+jU+oZv8hz3mO0ls2RKZD06MCEmfDbeRkdauA1HPMx+c1Op8iyOJJ0tMwOlFgotp34F
         YeGxHF840pvJO/B/ygM2DS9Qs/PYfjiw1fNdFMQPgb3hIeIeg2VPksIxBj7iGxebe92w
         fgIoZbM81Vlbtg42YPSHasduwuUBFRoAjbrDSblc5X36cCn8U7LQ6c9RSLC8OU86Mxnw
         uz3z5y10D8o2Ff5hLGkjLOa85JxX8oWK8iPQZcmTmUWQlVHYkUE/Ek1BTgB3ES9Khuvo
         kDbw==
X-Forwarded-Encrypted: i=1; AJvYcCUIaoY4lnpBoheXDCPPcybjMp8O8Vi/dAzAeah5XV3X00V9bqIRWl3MURKKlyH3+hrS7dDVvwxaeA==@kvack.org
X-Gm-Message-State: AOJu0YwYIiM3f44VCG0RAQ7JBb7gd4z7svGSW+FX4ex4F++pCcocs0Ll
	RkmLY08rla77WJOXIjU5zydf/3Vz07wTRT9/VlcQT6Ztn70Q6gBGoiQrRUkhzZLGN5I=
X-Gm-Gg: ASbGncsi1dHNkF/xKCHSXzYZxmTdBubSyVKiriaeMyDHNOjHG46IrhqE+0QuqToQh+m
	jz3KBhaSMG+GOZpYVxKkWNNFa9nzh8h/6gWYHfW2uh32V8bL3QZlLw/2SkAodnn4hrNnBW2VmLd
	UdlC+e9EVSiogQ3ub9Rh3mei0t1gO8oE3Pa8pdmRMbivPQonsUjn0H3l0NVK6n66kpsWu96O0zv
	SAEDmnDLrAn4A20P1/A+bhg+nTsZEP8UimOItd4mwS33lCvxgCcTcoYA+Hge/TdmwGF3APC4igI
	nNFTQw0gTa36JoMkn9tQvW6dbF+L2djxgL0J5rIifVpNTW570pqqte28KWYpRmzSmgO4ijLwbmI
	6fpJz3JdX8O3JFT20zK3Rp44gBzGuEGoDfA==
X-Google-Smtp-Source: AGHT+IEpiP8vlE6JAkelU9ryV0aqgK+NNUoCmR9E9pT/XsbUls6aw+6SDhLPMx2e7d1wIx+kCxhExw==
X-Received: by 2002:a05:690c:4a0a:b0:71c:1754:2696 with SMTP id 00721157ae682-730659ba7ecmr33141997b3.36.1757689872581;
        Fri, 12 Sep 2025 08:11:12 -0700 (PDT)
Received: from eugen-station.. ([145.224.119.89])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-624841586c1sm1302244d50.6.2025.09.12.08.11.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Sep 2025 08:11:12 -0700 (PDT)
From: Eugen Hristev <eugen.hristev@linaro.org>
To: linux-arm-msm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	tglx@linutronix.de,
	andersson@kernel.org,
	pmladek@suse.com,
	rdunlap@infradead.org,
	corbet@lwn.net,
	david@redhat.com,
	mhocko@suse.com
Cc: tudor.ambarus@linaro.org,
	mukesh.ojha@oss.qualcomm.com,
	linux-arm-kernel@lists.infradead.org,
	linux-hardening@vger.kernel.org,
	jonechou@google.com,
	rostedt@goodmis.org,
	linux-doc@vger.kernel.org,
	devicetree@vger.kernel.org,
	Eugen Hristev <eugen.hristev@linaro.org>
Subject: [RFC][PATCH v3 16/16] dt-bindings: Add Google Kinfo
Date: Fri, 12 Sep 2025 18:08:55 +0300
Message-ID: <20250912150855.2901211-17-eugen.hristev@linaro.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250912150855.2901211-1-eugen.hristev@linaro.org>
References: <20250912150855.2901211-1-eugen.hristev@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7C99AA001B
X-Stat-Signature: 4xiwowiz47sqdxsm3huaudunezecmz7w
X-Rspam-User: 
X-HE-Tag: 1757689877-506348
X-HE-Meta: U2FsdGVkX1+sv2BHFp6SeIVVcIciXH45fz8D5yArOiuE1/ZuQug35C4nLNfPJMSpyfit+KJPPjJHFmFRwNLtDs+Y+Ht3+A1qzTD+0H7nZK4TCzSo7QqayZPLHrqkjHpi0j5pZHRNATWye1eL/T1Bv7ttlFEuvVWGMTJCbGn7b1CmAy/UuRZZNU7uCz1BHLOKdSwcKEYZ+PILFJXoB0Ok0aTM5leA4Iwl8LEB4B+YmUQQmgMrhny2U5XPgAkPRCU4pM6RUWBoDYtPiIx1MVv14on9u1h/lC0oWiphKYiYtjSb4YgtWtVtC7CCD/By9OO/oBLU+U5Y6LoOTtOU4i3NDqEaFILlnYJrAx7XnVypD/HgTC53iKL0r9+W9ZkrkhR28dov3hqgmUfRIezoUaA7p5kWlrTa+MSPjf+HTe2kJlrU2eCc9zkbt0O1Op3x27XbFw7Crj000jDz8RwfQWzhege3QtVu3tvAj4cXy4Dca64jbDqDxU9Iw3da+mtHsGNzost09A7yCAJMMy62f6hnPe0f/bNTT+iqBJUAiWn2AAUzPDUXecOuLCMpWxz6Ee3GNMuuE3banhLMok+QeenI5/VZmGxsoVFLpVnAHuGbwbZO4dyYvH0ST5M9JTOfe7SIkbrjDre9BF6ICF/zF0furN5aMhEFFnSP9KCDPoF4NAURdcRQdFP+xhfbg+w7Mqy5ZzbUNopj+zNgU13DBZs5QZ8CxOXADIxmH2mu3d4kzdVs5Yft9EpCBqrBut8IuJkEs4Pym2DfsJKVPQCBkwY1hPG+5GDz2HxfvUbynOwWkn2QT4bWy3SbM9AU8mfefGmNM1v+a+GvDb07nQwRJ00QSVn4T8lB6bt9CnoUCiyPP2/8kHV0eEEXwbvUjjCjLM+ucs/evWOftM2haokC02PLIkX3khGUYFejHmzT2j/s8cw64Uj/UqJAXpCs/4MrZoNfywyFN2CRlJcrKm4vqHQ
 onixxbSR
 8EeSv6hTn4qckGp3f+iokPamU5cMiKCN59LFhWlhcAebVmq5x10XqENUgxuGc6vWG2457jFMzYyR8nCbRSksKin3q0D/11mPufli3Lsd6NftsI49jvF6Tc3R0lyHxyNiGkk///sxmoiJKL442DmOsYHRi/La1glnBEqPeFBoVsDWreU98HnNe56F9oiaA3EG15vnOwRoy2vkfKCw+hdBJp/2pGJOYIL1FvlGZ+wV5n9oUxvU77Lsm8G7ueyrGu1PiHNidNmJuy/69Tx4YAlnphxdblqO4C7tSVmEk5K5MK4GAvXbej2/fhf02dEU1vNhmpifBFtTGOwOmZKhBQnqdZIpXA81d/KHKUHWu9mHKqKtaXkD+m53BFC434QW/cvufPflN
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add documentation for Google Kinfo kmemdump backend driver.

Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
---
 .../bindings/misc/google,kinfo.yaml           | 36 +++++++++++++++++++
 MAINTAINERS                                   |  1 +
 2 files changed, 37 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/misc/google,kinfo.yaml

diff --git a/Documentation/devicetree/bindings/misc/google,kinfo.yaml b/Documentation/devicetree/bindings/misc/google,kinfo.yaml
new file mode 100644
index 000000000000..b1e4fac43586
--- /dev/null
+++ b/Documentation/devicetree/bindings/misc/google,kinfo.yaml
@@ -0,0 +1,36 @@
+# SPDX-License-Identifier: GPL-2.0 OR BSD-2-Clause
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/misc/google,kinfo.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Google Pixel Kinfo debug driver
+
+maintainers:
+  - Eugen Hristev <eugen.hristev@linaro.org>
+
+description:
+  The Google Pixel Kinfo debug driver uses a supplied reserved memory area
+  to save debugging information on the running kernel.
+
+properties:
+  compatible:
+    items:
+      - const: google,kinfo
+
+  memory-region:
+    maxItems: 1
+    description: Reference to the reserved-memory for the data
+
+required:
+  - compatible
+  - memory-region
+
+additionalProperties: true
+
+examples:
+  - |
+    debug-kinfo {
+        compatible = "google,debug-kinfo";
+        memory-region = <&debug_kinfo_reserved>;
+    };
diff --git a/MAINTAINERS b/MAINTAINERS
index 65d9e5db46a9..6a846c51db04 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13821,6 +13821,7 @@ F:	mm/kmemdump/kmemdump_coreimage.c
 KMEMDUMP KINFO BACKEND DRIVER
 M:	Eugen Hristev <eugen.hristev@linaro.org>
 S:	Maintained
+F:	Documentation/devicetree/bindings/misc/google,kinfo.yaml
 F:	mm/kmemdump/kinfo.c
 
 KMEMDUMP QCOM MINIDUMP BACKEND DRIVER
-- 
2.43.0


