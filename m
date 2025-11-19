Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E0F1CF3941
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 15:46:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 730416B00D3; Wed, 19 Nov 2025 10:46:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E11D6B00D5; Wed, 19 Nov 2025 10:46:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A6D56B00D3; Wed, 19 Nov 2025 10:46:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 35C3F6B00D3
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 10:46:04 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0B8E4160544
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 15:46:04 +0000 (UTC)
X-FDA: 84127782648.07.25A8C79
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	by imf18.hostedemail.com (Postfix) with ESMTP id 18EC41C0005
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 15:46:01 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=zcznNvRj;
	dmarc=pass (policy=none) header.from=linaro.org;
	spf=pass (imf18.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.221.47 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763567162; a=rsa-sha256;
	cv=none;
	b=FhQ6rSYgs/RNVwecQ2QRuyUbCORhwhmlMdAFrIlkfuzRRJZ56LELxXg6CqOxTSe/WR6/44
	ePWQDpJsPqBhUmz7QrPYOGC7IARizSjjPA4GcSFzLC1/Ip4ZTXTlt8A0vpbeMG9vlZl9BY
	EdpTuZUZbmLUSMyMgvxtRPDfHfE5NlQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=zcznNvRj;
	dmarc=pass (policy=none) header.from=linaro.org;
	spf=pass (imf18.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.221.47 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763567162;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=plmpXAswm1LBomkuKtBG6pEMvq3kPgWo3F0t41OaVKo=;
	b=Wq1WpdzOiXUGoO1X2CCuZh7vUZOdWW9CDeM4Nytw+lmvx33l03WN3CIbrs+z/k702TaYlr
	ibw49BM/ednUfaUZ3Dg8Vro89QMFOTLHcJf+iquxFQbAzVPI618bUbnmZTvCc/PtG0Stwe
	q3juDwopzLEwFhcG3J7Bta0kl+avIdc=
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-42b2a0c18caso3706663f8f.1
        for <linux-mm@kvack.org>; Wed, 19 Nov 2025 07:46:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1763567160; x=1764171960; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=plmpXAswm1LBomkuKtBG6pEMvq3kPgWo3F0t41OaVKo=;
        b=zcznNvRjNFuRXYTyLV9J+Lc6fQVhtCc6/hkMGkZeXXgKEZPTgH3VirQ0ZSMDQ+VJa2
         CdG6g+mTg0ugb70RpSxA/+xRrDiRjjxu0AR0N8imEX8rnp4aAWBgTUTX6Hwhz55ZtVIy
         xJSSDnJIsa78MFWV2LiBOevS/t5FKduLXbHQrEJPFJz08JyLr6n6cdNVuCgcGQMp27T1
         62MqSyU6lTckjA7kP5ChlR6AGzpzqqL4Jp/RxB8GtwOWyOKt+DVL/JSHtCgT0P73xdvR
         HKpesOOsAURYIi+CF/XSMC5Yq4n3FzxSPtoxHvq6pdr6CbYmTnlHjvBVSbHI2pqQmcgV
         Dm/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763567160; x=1764171960;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=plmpXAswm1LBomkuKtBG6pEMvq3kPgWo3F0t41OaVKo=;
        b=oBw+xmK2nYPSXNGp06tamfHC8i9Zh5cn2zGxJZEkQPEqu2LRkKLkIIvBnv5q2qLuhp
         JgPnyruLAUIy1tszOicgrXZ1fS7gbXdPE+ctW8WeF+hV8yYRXCEHqjoJBAntyCO0NqvX
         VknzstZkojjTF9WFI0KnZIe1e88IlbJA+PjcVrTySg0/mKRxh7IH0it9fQ9mAFsS/heG
         qZR43a+ik6PZzCYXBkmbB2EslsC/+rczHnzTVe0YjMBMXrP9MejWcfvZsAOSv0yNqT0d
         3ofjH1N7VOIgg3xcJal2xNEBWSOPmUqvEMjiMO84CQsrRbXFoRPB0Wq510yVCpO8GttI
         sWLQ==
X-Forwarded-Encrypted: i=1; AJvYcCXi9Rw05ZPE5buXmRradhd7jUKIs574PkJ2/BkiZjXoxABmpkd+gLl00/1Z5TWkJ9nfApa1KQ37vA==@kvack.org
X-Gm-Message-State: AOJu0Yzwb3V/0cYhkXfqKfaA9IhJCaFwnz0bdOB57Jb9lHFXhftpyv4C
	YNHXwfgU3cQIi5Wy/sQhgOxlB0usqf5pKdb0lgXULPM6C07lZYNl7MxOaOWcv2U/Zwk=
X-Gm-Gg: ASbGnctOnZVBudITn9ltLCHphxcuPhl3UChDfRVxtj/eRIv1eV6zYImGC+iO4jo5AGm
	TQPAekoRnxEcEoTQgKjGhWS39G6m3/G+3sy+pc5iRVRFbJrcI1g/o0vKUWVg4KQTJnbza8jNP5H
	QUVQfbC2Tu1hUYle0VGD7U9e3olO2OZWzM4GuEuytPmwN5agUsgvRLa6LXJuF/T+/Ftus/SSNQw
	kUPCZGdX0QWQnOr2k0aSBKLALgtBUgbyiHaUUYiG1RMURcX+FooEv46q9oy++s5IkWaGkZg7gG/
	VrRpk71KFBsGFWMsfeQ12GAi95IuelBSNXC1+sNF7xKjATo0mcVQbjQZQ6T04fZCxwi4iWgFfRX
	08Qd7jo48q+lQDS6xigp3g+h4wd8BvjswU/QZu0EzHp6BxYZ+hQUBWuudp9+b9aMz7DOGV8PKH5
	YaT/xE5LK17O3EDsePh/mLTiWhir4c1i57E3uSfTAe
X-Google-Smtp-Source: AGHT+IE/UWqNyS6htQwPVCsFX9f3Bqg52uzu0v0K2d2YIVRMOF1vqDQaElTCpee5ClbOZybd51PSbw==
X-Received: by 2002:a5d:5d0e:0:b0:428:5673:11e0 with SMTP id ffacd0b85a97d-42b595a4ffbmr19851079f8f.40.1763567160526;
        Wed, 19 Nov 2025 07:46:00 -0800 (PST)
Received: from eugen-station.. ([82.76.24.202])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42b53dea1c9sm38765632f8f.0.2025.11.19.07.45.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Nov 2025 07:46:00 -0800 (PST)
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
	linux-remoteproc@vger.kernel.org,
	linux-arch@vger.kernel.org,
	tony.luck@intel.com,
	kees@kernel.org,
	Eugen Hristev <eugen.hristev@linaro.org>
Subject: [PATCH 25/26] dt-bindings: reserved-memory: Add Google Kinfo Pixel reserved memory
Date: Wed, 19 Nov 2025 17:44:26 +0200
Message-ID: <20251119154427.1033475-26-eugen.hristev@linaro.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251119154427.1033475-1-eugen.hristev@linaro.org>
References: <20251119154427.1033475-1-eugen.hristev@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 18EC41C0005
X-Stat-Signature: rwhpz65d67byshof6hjxmik3ht9gr4gg
X-HE-Tag: 1763567161-14954
X-HE-Meta: U2FsdGVkX18NizcxPsGerTMnRYecM1nskbMbB2s60CjY1p332JFA6jtCL4mTkTD7mzbrgNR58CfAOhTEnYzA4mFSfJoZ/YqR7hBPGKP9lz/p0hRJwop1NpklxECMMZaLlXRlh+0AJq8toYShtrKXxq64pjR0q5/ATwqsNiFZEveWMGqFIBfq3EXM5NhzmlT6wLrDWP7SDdxTMclRtbQ6Q95cenRAG78iJudAlXM8AiKUMZyeS1gsujIXVxnqMgpHYoCCOB9wCnWP/Eid8/zyd+M426FKp5Ja9BxF3a0zW3kmuYUDb5PTtSxq//zaWSygVa2r37wBfG7AsjdYVtv6D45WYc3Cc8Kyrw8kjLlx6M10Se6UoDbCk2aLQmY2pOEBPPnrJQBZXBuC/XR1WphPpV+sjYf1W2/qpttf4CYoIQm93TLdqO1hs8lvwsYVTAofG438DKt88dRQLGWjMPaI1gXFfR+9I9E4uya3RrYHB/akj/oCDaYiyDnXjbVt+viBUUs5DyaII6CMA5KUSiJy03YzX5EeXuQ4yK60MdBmzd5GmEihISIlxeLl54YZ2ViVbwWC5NQjgH91wK7j6nXyQubU2HoGZ+BhTuB6dslJMRQgStr+yijS/PdvBzVpMwSFsFC/h1r6HcMMemn7I+RpW1okiObZwYjSZdDbZK7uzUehP1KWGDZN3XLzriCUkL2P3iEcQXQYfzujBJBqED87h9ywJYWqRycphbHHdXJlY51bgA8GNm7MByJjlOKAqKrUfrI/Ki7+zF4YlfH5uatmpaMYzKK8A1vb5e66i1qT6CYhwuPyO1w0OgRq30V4ssvPAD4sGiBgDARtQW6dE6RlR5qDSZ02YJB16KNnxUo3YwPYyzh30cRw/Gv5rP/B5fUScVVejaDDw+sMn9MoKx630UkaZtiR+BBJVHA242fmg7+pysEb3112VO4TX5B6jQ0ALAfy7pkZVRadx79DpBR
 dadEbgfv
 icWiHMCvkLlSS9yeYuI1IAbbK2vgFg9r07amQkQB+5FK0TzwoIDB62YiK9Y2M+TgpSfvnD0zjv1RCQuXPbCB5/LW3lUYrJ6Fo3JhjiUDPYp5jQ3fBdwgy0aru96PzIgztGA6nN191U8NoPK/KDyCs4kHc/A6gJ8IQPDsYHtZYXuEfM28xchliS8+BobVCDdLhk6a8u1wCV+jvU5f/wTdXiVxkimA9a+8MqPtrmQsHSKFADbN8xLLldJGVABwGCZ8m2izR+emCjIZOZNUUrhDOtS7/wVPQV2htahLMl9EO790Qi6lP7Cc8kcmGs6oYbeo+yQFaDte7/skBcgbDqae884l0gqShi+g0L8jXPgUX8qfjF9ZMLMfKCmtZbyXZK4RfQuzA5jRvcPAWPIVwcB4+ciSQqx/enWusvViY1NN50kewUzxDbccJx2Htb6y2CHbO0bSMn2tCpSw160GXO0fPeY6+9/kyrQr8/z3rw6Zh2fBYq/GNPldRZa1zqw2pRQWh9TIJ65AYfgrvNAFAft4MwLr738Xjrfvkb8Z7EPzaxtNIheIKbsqJoRWwkA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add documentation for Google Kinfo Pixel reserved memory area.

Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
---
 .../reserved-memory/google,kinfo.yaml         | 49 +++++++++++++++++++
 MAINTAINERS                                   |  5 ++
 2 files changed, 54 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/reserved-memory/google,kinfo.yaml

diff --git a/Documentation/devicetree/bindings/reserved-memory/google,kinfo.yaml b/Documentation/devicetree/bindings/reserved-memory/google,kinfo.yaml
new file mode 100644
index 000000000000..12d0b2815c02
--- /dev/null
+++ b/Documentation/devicetree/bindings/reserved-memory/google,kinfo.yaml
@@ -0,0 +1,49 @@
+# SPDX-License-Identifier: GPL-2.0 OR BSD-2-Clause
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/reserved-memory/google,kinfo.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Google Pixel Kinfo reserved memory
+
+maintainers:
+  - Eugen Hristev <eugen.hristev@linaro.org>
+
+description:
+  This binding describes the Google Pixel Kinfo reserved memory, a region
+  of reserved-memory used to store data for firmware/bootloader on the Pixel
+  platform. The data stored is debugging information on the running kernel.
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
+    reserved-memory {
+      #address-cells = <1>;
+      #size-cells = <1>;
+      ranges;
+
+      kinfo_region: smem@fa00000 {
+          reg = <0xfa00000 0x1000>;
+          no-map;
+      };
+    };
+
+    debug-kinfo {
+        compatible = "google,debug-kinfo";
+
+        memory-region = <&kinfo_region>;
+    };
diff --git a/MAINTAINERS b/MAINTAINERS
index 2cb2cc427c90..8034940d0b1e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16164,6 +16164,11 @@ F:	Documentation/dev-tools/meminspect.rst
 F:	include/linux/meminspect.h
 F:	kernel/meminspect/*
 
+MEMINSPECT KINFO DRIVER
+M:	Eugen Hristev <eugen.hristev@linaro.org>
+S:	Maintained
+F:	Documentation/devicetree/bindings/misc/google,kinfo.yaml
+
 MEMBLOCK AND MEMORY MANAGEMENT INITIALIZATION
 M:	Mike Rapoport <rppt@kernel.org>
 L:	linux-mm@kvack.org
-- 
2.43.0


