Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDD9460A2607
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 11:08:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=c2oGCKHk
Received: by kanga.kvack.org (Postfix)
	id E644B6B05B5; Wed, 11 Nov 2026 06:08:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E15366B05B6; Wed, 11 Nov 2026 06:08:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D52166B05B7; Wed, 11 Nov 2026 06:08:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A88316B05B5
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 06:08:30 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 434171C2C2F
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 11:08:30 +0000 (UTC)
X-FDA: 85422564780.11.7BE7497
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com [209.85.128.69])
	by imf30.hostedemail.com (Postfix) with ESMTP id 8F9CC80008
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 11:08:28 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=c2oGCKHk;
	spf=pass (imf30.hostedemail.com: domain of 3q0z0agoKCHQnVgffWXgjlYggYdW.Ugedafmp-eecnSUc.gjY@flex--vdonnefort.bounces.google.com designates 209.85.128.69 as permitted sender) smtp.mailfrom=3q0z0agoKCHQnVgffWXgjlYggYdW.Ugedafmp-eecnSUc.gjY@flex--vdonnefort.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794395308;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VViZS2bb3pZ4FEd6v4FhPEGdFU0OwPB+qGWSqpoqEsA=;
	b=nII4SugjJhCzDaekMEEgOMc7JH8X+B5osvp6/lVINutE4WZFo4h4rJBv+3W/Z7NBic3aFx
	P70vvj1fj5fjCItSVr5I116poX3xVklaoBJYof42nRcbSQohlaO/u+ILwB5CW5XgdGYlTJ
	hHOnPe7PYS4rO5OrMY/EEv39PRuzr8s=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=c2oGCKHk;
	spf=pass (imf30.hostedemail.com: domain of 3q0z0agoKCHQnVgffWXgjlYggYdW.Ugedafmp-eecnSUc.gjY@flex--vdonnefort.bounces.google.com designates 209.85.128.69 as permitted sender) smtp.mailfrom=3q0z0agoKCHQnVgffWXgjlYggYdW.Ugedafmp-eecnSUc.gjY@flex--vdonnefort.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794395308;
	b=wck9li/2u4tZeK5U8h3DAjhJEuyLSk3aI0JZdbbVctOLzUe49SDP6QFVnWbkDL6CdNbvA/
	VvySlTZA/hpcdtrY6jSKcKPyLUiUfz8ktA80AqpuaW7z07dU3vrunheIj3wPGXp4Vf0ezo
	DRL9WZjQbKmCjId7JXUoDkpA0RhyYr0=
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4a20fd059ddso22107245e9.0
        for <linux-mm@kvack.org>; Wed, 11 Nov 2026 03:08:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794395307; x=1795000107; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VViZS2bb3pZ4FEd6v4FhPEGdFU0OwPB+qGWSqpoqEsA=;
        b=c2oGCKHkzbRQHmSA2LZQmNhNXnbuSJ+Dxx9EKfyijtSVkew3S/uevT/DpQIFj7fe24
         kWfQu5dtO75f2aWlHJAa+R54pHF6FTykkuSO+P4TadXXiL43OCHwV9oFhH35nmW99kkZ
         2yRfUlDRyUe3LpQN5gliqllUErXjwUTZkLYijnkDE8GOYOyKyAaFDpycSXeiIMfbmpQ+
         3YNWxzyo+B8I1e6yhok1AjOYT9Naq1kh3N8gEZS4TYhGX6U0BKuuZca5dV61voN2IDT2
         emwgvk1fjKx2aIdTrDA51w7OBF9342c/LcCWiVX/0gWtSLWshq+rCP2SvDAY02JnNzSS
         N0Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794395307; x=1795000107;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VViZS2bb3pZ4FEd6v4FhPEGdFU0OwPB+qGWSqpoqEsA=;
        b=uzj821lb55pBi/2fyDF2EWLX/zb4kBiGVekrzQB4RfaqG1YWlwE6atDG2Qkv9SQX9J
         hDK+8KGwWHA6wDyv4xu2xlwLapuvEscjrRjFxKBd6V/6ywterK+2k6K33EGitrk2CwH+
         0dwD7J0s/FwaXcEV1fSwZiNdTSfdB/7pheEIAvRmgWg63P8gMl6pXRCg8Xsp6dicTNEq
         tys6tdLcS7rOOibtAK+I0JDmsJi55my6xvVqX/uT3KRpWYgLR/rlcJ0mgyTV30lkang7
         kD3m7XAFZxdRrkkQLEZpKHc4YGZBKrIk6TAEFV6yfOE0BdjEvlg8tUt+/j+rwPWjRdqJ
         PW6g==
X-Forwarded-Encrypted: i=1; AL+hErEYLehsOtab4Wy9e2cprgsrUTGW8dXf7q++JYGSpucEsRUXuNs3faLyU/z71jnx44LS+uiLV0pbdw==@kvack.org
X-Gm-Message-State: APuU4Z9bUcNjVyL5MX5h8UDUVIXYTtnUgUK6wx2qG+CXzLdSLZXxa83m
	Ahq02Tb89JTMP5mlxbtN22ZU/AUmTbXwt0Z8iHLdiqQyCrFUfiRl6FTIFcpq+eLM3ecY1uCwyjw
	UicEvqBlTnWUCoyFTFfez/w==
X-Received: from wmgb22.prod.google.com ([2002:a05:600c:1516:b0:4b8:b187:f0cd])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3b83:b0:4a1:f377:5c6c with SMTP id 5b1f17b1804b1-4ba0935dbfcmr39556605e9.10.1794395307014;
 Wed, 11 Nov 2026 03:08:27 -0800 (PST)
Date: Wed, 11 Nov 2026 11:07:34 +0000
In-Reply-To: <20261111110738.872947-1-vdonnefort@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261111110738.872947-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.56.0.542.g3ef89b7020-goog
Message-ID: <20261111110738.872947-5-vdonnefort@google.com>
Subject: [PATCH v3 4/8] dt-bindings: reserved-memory: Add lendable-dma-pool
From: Vincent Donnefort <vdonnefort@google.com>
To: catalin.marinas@arm.com, will@kernel.org, rppt@kernel.org, 
	akpm@linux-foundation.org, m.szyprowski@samsung.com, jenswi@kernel.org, 
	robh@kernel.org, krzk+dt@kernel.org, conor+dt@kernel.org
Cc: mark.rutland@arm.com, robin.murphy@arm.com, hch@lst.de, 
	ryan.roberts@arm.com, sumit.garg@kernel.org, sudeep.holla@kernel.org, 
	ardb@kernel.org, thierry.reding@kernel.org, david@kernel.org, 
	danielmentz@google.com, linux-arm-kernel@lists.infradead.org, 
	linux-mm@kvack.org, iommu@lists.linux.dev, op-tee@lists.trustedfirmware.org, 
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: nui3636w5iqiwstg3u3siap6ps5bpbar
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 8F9CC80008
X-HE-Tag: 1794395308-94364
X-HE-Meta: U2FsdGVkX1+BC3XvMgO+RtMwWBSFHylC2OqxILkrXsRPnsVnssL+GoMhXBzMec8jcSWSPsJ9agtoCRPqbXAh5Da/VgWKp2AT94xP2Yp7ViFDglixzPbvLSqT6uyZzsfhToo/dqiSRiS2LA5w8KCoZjVKyE0/m1nArJ/XVv1Ehza5Q2C3MDc1nxRyMfX1z9NgmD1vmz0eNKW1f+H0RE6oJIx3Knmy0vH/vd1V+T32qK/mwJzCIsOUdqpYRHbDtRPO0otEZJOYiRc+e49kz5VURWJfjBhnW7G+ndQ4y6GGVWeITaayuKop71kkTxDKhllZLgIu1rx/gCvAgkdy/4UlYRqS1yELaObx05btgF/szuf6A40LLCVsiI5wqUCkV6HXJXjgbct+4mA4j+ClQM/J2gHPY8aP2T8kcPwodn+bfoGxNy0s6ksfGIYaeD3UkI0iaBgylLIHA0BEQ9sRdVk4UJkORjmKpi5yqDM0bdWNOZRtjcjBiOWQN4Bs7zZe11l2ovofWhkLqgVOwx0aKJdppNR50+c1LvYVqwp05w8IhEpXXUuiG6W0yD2ioqHar7nRU1l8d58NOdo/Q275gzXQHRUtl0GYNAOHmg9GD1IOOIH+PN6wv/C7g0ZXdpMhOAZrgl/73Qve0H29oJyT7rHSbrfAlASLWkCFC9VIDY5diL1fxvibEWK9Ok+8gxpSxzOJNLZqe0L9+7mMD1P2rDQfV5erjMJn2nt1vcSyeoXsX9ISs+yYKGw0Dsz9JDZWIJnRkPwzVYw9K8BRUOaWLdeFvjCd+ucqe7EmxT9OzjNJcJNF/qmrZM7rZxjOW03W13scaKJTrmp51S0lgFTosmGBKxFLnJWLpzzHHX2sJ49pLLbJMI89SfbFyyHQsLBKzhjQU5dmcxjMYQT8SDNgrT/ydiHv6/9CTadfp+Wmk02FCKPIgO5v1HTvdMfFsvIuN9ARqQt+KyedaUXkOw2jKgq
 b7VVSYiA
 eBIpxfrz3npHy8CfIeRTRNZzw44pEjyRyWHjYrjXkGZicISXkMhxf55tyProRHKBqRS6+CoWSWIC/erEOln8n3/XjjndOQLpxWejeFpvnauM08OIU3JCaey+3pyZdQGPEbL9ZOe781yKVy2Yn4ObZWxkOYVKPxNIqHd6Rvi/NaCBSjUpFcb5HL+T1KW88d83JkwICh+LusrvezOx8w0oyYJ58wxb+z1I3qmjoRrHUcO6jMwH01ATMsFnYUBbDmBEIVjOr7Kezeex+rJez1BZ/WZcqjfutG6NQWf5qJGqp9pGnw3DUxqC6tHD1tHfVXpBEkDNWAW+IcbJeZyUMzHBa7lwgOhvTMltx1P7EuycFoFq8L+EiVmAOFl4NqpGcoe1iCUDEU3MX9hseNXvo8Oi8PEo9Bswi4pENK3RR7uj2hWIs1mXtVfPLBwGwkInQqBCKAtHE7ppysSd/3t3zmkzcftURe/VBf5bMLTVirIMUnDwCZ2DqOEdTiSJz73QH1L8hVA3KYmqXPbXoPZLTpioMzX5S0dr7QOahBZxVyp3yPyTJf7UUrwGSlen+y7F45exblRonC51BIK4F+gvsxPI6RL6dAk2t/OfIJj/B2VNOKIlhaxsOE/USCURsQVAWl0Yvl9ELmgTWe4pDoVpHBexr5JFr0/EqUUHVAYa/5W/sb9u1XjroSCSSU+Aj66SidNeACc4dAF7Gxdql/PshGO1L+8qGi3yEx1bgQKSmtRVN0L2yIDo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Add bindings for the "lendable-dma-pool" reserved-memory CMA pool, used
to dynamically unmap pages from the kernel direct map before lending
them to a secure world.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
---
 .../reserved-memory/lendable-dma-pool.yaml    | 58 +++++++++++++++++++
 1 file changed, 58 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/reserved-memory/lendable-dma-pool.yaml

diff --git a/Documentation/devicetree/bindings/reserved-memory/lendable-dma-pool.yaml b/Documentation/devicetree/bindings/reserved-memory/lendable-dma-pool.yaml
new file mode 100644
index 000000000000..0b924d941b4d
--- /dev/null
+++ b/Documentation/devicetree/bindings/reserved-memory/lendable-dma-pool.yaml
@@ -0,0 +1,58 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/reserved-memory/lendable-dma-pool.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: /reserved-memory Lendable DMA Pool
+
+maintainers:
+  - Vincent Donnefort <vdonnefort@google.com>
+
+description: |
+  This indicates a region of memory meant to be used as a pool of DMA buffers
+  that can be dynamically unmapped from the kernel direct map (e.g. before
+  lending to a secure world such as via Arm FF-A).
+
+  On architectures where the direct map cannot be arbitrarily modified at
+  runtime (such as arm64 without BBML3 or without rodata=full), the operating
+  system ensures this pool is mapped using last-level (PTE) page table entries.
+
+  The reusable property must be set, and no-map must not be set.
+
+allOf:
+  - $ref: reserved-memory.yaml
+
+properties:
+  compatible:
+    const: lendable-dma-pool
+
+  linux,cma-default:
+    type: boolean
+    description: >
+      If this property is present, then Linux will use the region for
+      the default pool of the contiguous memory allocator.
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
+    reserved-memory {
+        #address-cells = <1>;
+        #size-cells = <1>;
+        ranges;
+
+        linux,cma {
+            compatible = "lendable-dma-pool";
+            reusable;
+            size = <0x4000000>;
+            alignment = <0x200000>;
+            linux,cma-default;
+        };
+    };
-- 
2.56.0.542.g3ef89b7020-goog


