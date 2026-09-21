Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3723C982EE
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 11:01:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E1A76B00B5; Mon, 21 Sep 2026 07:01:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B8766B00F1; Mon, 21 Sep 2026 07:01:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3CE8B6B010D; Mon, 21 Sep 2026 07:01:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1AB626B00B5
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 07:01:08 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8C68814013B
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 11:01:07 +0000 (UTC)
X-FDA: 85237477374.23.228CB8A
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
	by imf31.hostedemail.com (Postfix) with ESMTP id DC4D020009
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 11:01:05 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=YWnB4QjG;
	spf=pass (imf31.hostedemail.com: domain of 3cA6xagoKCK0iQbaaRSbegTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--vdonnefort.bounces.google.com designates 209.85.128.71 as permitted sender) smtp.mailfrom=3cA6xagoKCK0iQbaaRSbegTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--vdonnefort.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789988465;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dcGk9G8S000WArAMLwdOiTGHKXUA8vP6GMN4jNzx1Ic=;
	b=H2/I6oyMZ5DCJ4x+IqCE8MyxX0hAB3OoxxBOymkrUaSNbLt/QDrUHtX24Bipzidy3/4DXD
	9dbu/gzEaT9SW8M0JR8ZvVeASeMxLjmDgS2dApYsz32pf3QFnotoMxbq4LxFhsRYb/tdKv
	632ZCuYW4Ey7h1egPnQ+q0cHV1zmH1U=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=YWnB4QjG;
	spf=pass (imf31.hostedemail.com: domain of 3cA6xagoKCK0iQbaaRSbegTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--vdonnefort.bounces.google.com designates 209.85.128.71 as permitted sender) smtp.mailfrom=3cA6xagoKCK0iQbaaRSbegTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--vdonnefort.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789988465;
	b=aRfDOG6+uoPMdyg5NFS3A4r12rCvVaDZ25rdeniPadblBIpdvsXjpu1MZ5K2B0GdGYa7Ew
	wyVs658V9zJkM1ebzYmQK6KfUYgJy4HV05mGcXtEWqk/Xom6A4ZJ1XzHTtALq8akAgA+PJ
	FbrZ5ilWvdeaP7pDspnQKRt2MxvTi9s=
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4994d67d0e3so22026555e9.2
        for <linux-mm@kvack.org>; Mon, 21 Sep 2026 04:01:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789988464; x=1790593264; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dcGk9G8S000WArAMLwdOiTGHKXUA8vP6GMN4jNzx1Ic=;
        b=YWnB4QjGTfjDt1W5L8v/FaYJgnKGwiE9KDopuMEakfvBHnjOjBVtnN5r2bd669FCZ/
         wWAYgTjkouOHL02QALHtOhNrV+tYyQ8cDva+Wu2j3IQT9lzebJK042dcFuNRc7NXklG7
         CYhNZzCLTfAUUIiBw4huTxtkP3NXxKgsXfp9jLiERZaJ7w0w0+7PInOrOe2cl/p+0aAE
         GvhNc6uPq/wECVc/2AQgcivPCFFwEneVxqEWd7qXZW8ne8LZBeLCq3ND1k5O6AAvM0BH
         0N85R6NyHcK7z/I1itQv+Zv06pl4CqNqjYH9d2JdIrbtDu4Sipn1UJc0ngRyxSNSqL4s
         S7yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789988464; x=1790593264;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dcGk9G8S000WArAMLwdOiTGHKXUA8vP6GMN4jNzx1Ic=;
        b=HsmJhII0REjGh/cwfrpKDi0hjAracpqdEYtGzOqzmck1Cj6qTH3+/Yw5PUGNNn6Mlv
         z3a7GlAoTYcj434C1bBGUvJ4lf5KWaEwKuWqPPqzbSMjh2DFAgn7fc0W3t+T8DR5kF6A
         HivdrVk5a/IMSxD9ShesHjaa9I6dwIta7nv9KCAo7JdrudErP8fRz/MYAh9TCt8ccrqr
         zJ4f7vXMo1q2wTpnXHZAZWNt77hzxtmma7fsSBgTkcTtDeo8A0N/qDz5HJ343X6WO7F8
         4bMvo77EXR4f00p7fTo34b5Lihp2a/lZuOIhH0UgE1H7uioZJAXz4xwh+asknAqDFFkq
         dUJg==
X-Forwarded-Encrypted: i=1; AKwUvByNXnywb516I6j65DMHRc3YqdxFvycD8S3M2fHxxbWyR6Y1C/G3S1JSlLnhPV8YHDWW9lVxlaH8YQ==@kvack.org
X-Gm-Message-State: AFuF++nh6H42luS9kNZ9gKS6qb/oIddd645qjWLxyeI3AG6JNDejf/TP
	fEhESD36+X+katfZ8oW4MA1efIdBw1+Iuh1+V4WJ5exOYKD2rZhdx5TtXKirtLm/1sfymnc94wp
	nUM8OixpIfr1srnASq6V8zw==
X-Received: from wmph41.prod.google.com ([2002:a05:600c:49a9:b0:49e:78cc:d29])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3b82:b0:49f:ce72:dfe7 with SMTP id 5b1f17b1804b1-49fce72e040mr109082755e9.35.1789988464458;
 Mon, 21 Sep 2026 04:01:04 -0700 (PDT)
Date: Mon, 21 Sep 2026 12:00:49 +0100
In-Reply-To: <20260921110050.3977591-1-vdonnefort@google.com>
Mime-Version: 1.0
References: <20260921110050.3977591-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
Message-ID: <20260921110050.3977591-8-vdonnefort@google.com>
Subject: [PATCH v2 7/8] dt-bindings: reserved-memory: Add Arm FF-A lend pool
From: Vincent Donnefort <vdonnefort@google.com>
To: catalin.marinas@arm.com, will@kernel.org, rppt@kernel.org, 
	akpm@linux-foundation.org, sudeep.holla@kernel.org, jenswi@kernel.org, 
	robh@kernel.org
Cc: mark.rutland@arm.com, sumit.garg@kernel.org, ardb@kernel.org, 
	thierry.reding@kernel.org, david@kernel.org, danielmentz@google.com, 
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org, 
	op-tee@lists.trustedfirmware.org, devicetree@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Stat-Signature: j5qr4rbsauxjhr6t6fknkkyikj8qtcaq
X-Rspamd-Queue-Id: DC4D020009
X-Rspamd-Server: rspam07
X-HE-Tag: 1789988465-690485
X-HE-Meta: U2FsdGVkX1/NvJblzQJLh2GuPhi6SyyEyeoqFjjopwpLVDHnL2j0Jop7jEiHweCLsyOI1v17jVHr1le9FSkLoNVzFHXarx+cKyRmCEJEegNNS5YAgecArFSxj5bX+II1RvCMr4YAF7TRHE9JdgnscescgXaDOkHQGtHUHbOo77N5GhfcS5H3yi6MhgbxG4EQGFSGL87Eunt6Fl1EFc447DJbtApdm+qBXaheUuTGqcg+/8+37W4IjxhGzjKqux3ROW4DADuFdPIKvOKygn2+BejUgzpFjhF83XxDN8x2oWyfHAT4rfuC/K7CPgFyvFiguZH744ihaMKklvS9+iatR1Z3uQyw9R1FDQNUS09R6Ql+D+czhqTfMq3H5TS9bvyUpiOIU9yaSgUz7eYqceLw65hz4003sjZyzjJPMSowowCckkfPEgaMC62mRSE/UPTJSlvp53YotuXAplZ/MY+gQnvcFQmYLFDa/62PtvaxUwD5D+a9vedtX+cIEH5Kb9XDgf565mUkKk92JfiY/YRvdvKtr/CRtOSJXBiTayjJxr6bMaT+oq4d06AvlgbzdJm6YDbeh7Pszr7QbOKnY5qE0m0w1eSzLyTJuShzZT0G4TRawsL7d2Q6L0LWqZzVKgHZMyMPWnbVIqzsYs7UIRbmpWEfOwYMCTD3e3f4Y47koxb/44FWQtLi1uLvuW4b+o42vIOwdoVpKFB2j6Yn3z74hho3bRKVNyaDxZdcC6FeRAIT9CFFvdgb3aFKCkpUXeZSr9OMZiBvKXcsP8DXsC1ClQxlBoz+wQGUzmP5eGhDwtQi4/PCE3X0cjk3KU31tQN8OPSoK/qKbxcTkDHL+DiNxkOKrcLmcP5b0tKL7gZ0YJzA/OQd00iBiS0LgchwoqO1Ytaa3bT4RzakecPZzZQw4zPNjGCIiYYlB4OQHYuMFzy/HkfqT5DmMVzUJVb2jJ4LnRotPreEhHNzmwb9nrt
 aPdatL+o
 f4kEyvn6lBhlntJvaL813bqvcoKEByFUA6r4Cz8Ruq4H5/V/qioXjo7/0J8PGceV8Xm7n05lzSwwCUr+QZnrnA+Q53TnitM2nk+Fb0sLrGvw4WYD/HA7915fyp3hK+RzYJDvlFViokIsXpMac0VnZUrU4MV+k/et58Qjhw3CzCLGU2wGAwdLaEjBwiHICGsJksoWlgzHxkthLBo8Iu8DKLLiMT42P5vT+SyXfntY8gjVSBD3Sef4Re+7Y6790D5u19meXcT7KbZgsPoe2dmaqVobkwXFqDdoAcQMLWFuCXFIKeLIzSiBUzKXY98GxTicP33T4U8V5X2gNfM4tOVWJIUmZZTp2hJ+7eGFMl3JJCcaS6KbHuRnKVnX8PH6mB8Vd8bPyJYaKsb+HI2WcxgpKjYDs9a6qrezPBg6W72udqh0XpN/3GdmgulGcT87jr5aOtG51j2odZn6zZLBFAseGAYVtYpfF/Ato8+acdU96QRQVIC5BM4wcPSPBcVlROk+mKYmG0GxuV8Vk1NwpbfzdYfdynU24yPuU12dFstHkSsjrllcJkrDSPsqlf0tSUvaftlqZ89kL+NeMcRxf0fim8hYnTO/Q2jUgMizrbv1VCeuGkQ/0IxjbQGlRIW1ngBxoJNdryIcGSQ4XpXwJ5X2HHE9Pwktz1D5DWgZK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add bindings for the "arm,ffa-lend-pool" reserved-memory CMA pool.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
---
 .../reserved-memory/arm,ffa-lend-pool.yaml    | 55 +++++++++++++++++++
 1 file changed, 55 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/reserved-memory/arm,ffa-lend-pool.yaml

diff --git a/Documentation/devicetree/bindings/reserved-memory/arm,ffa-lend-pool.yaml b/Documentation/devicetree/bindings/reserved-memory/arm,ffa-lend-pool.yaml
new file mode 100644
index 000000000000..c02d36e1e418
--- /dev/null
+++ b/Documentation/devicetree/bindings/reserved-memory/arm,ffa-lend-pool.yaml
@@ -0,0 +1,55 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/reserved-memory/arm,ffa-lend-pool.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Arm FF-A Memory Lend Pool
+
+maintainers:
+  - Vincent Donnefort <vdonnefort@google.com>
+
+description: |
+  When memory is lent to the Secure world via FF-A, CPU speculative accesses
+  from Non-Secure to the lent pages can still occur as long as it retains a
+  cacheable mapping to it.
+
+  Ideally, lent memory would be "no-map", but that would mean giving up MiBs of
+  useful memory. Instead, "arm,ffa-lend-pool" defines a reserved-memory CMA pool
+  to manage unmapping pages prior to lending and restoring them when reclaimed.
+
+allOf:
+  - $ref: reserved-memory.yaml
+
+properties:
+  compatible:
+    const: arm,ffa-lend-pool
+
+  no-map: false
+
+required:
+  - compatible
+  - reusable
+
+unevaluatedProperties: false
+
+examples:
+  - |
+    / {
+        compatible = "foo";
+        model = "foo";
+        #address-cells = <2>;
+        #size-cells = <2>;
+
+        reserved-memory {
+            #address-cells = <2>;
+            #size-cells = <2>;
+            ranges;
+
+            ffa_lend: ffa-lend-pool {
+                compatible = "arm,ffa-lend-pool";
+                reusable;
+                size = <0x0 0x4000000>;
+            };
+        };
+    };
-- 
2.55.0.1082.g2b9226bbc0-goog


