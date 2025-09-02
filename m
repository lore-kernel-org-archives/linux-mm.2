Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA1A4CA1005
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 15:46:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0BF4A8E0027; Tue,  2 Sep 2025 11:46:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0706E8E0002; Tue,  2 Sep 2025 11:46:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7A2A8E0027; Tue,  2 Sep 2025 11:46:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D17A38E0002
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 11:46:51 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7FB2616026C
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 15:46:51 +0000 (UTC)
X-FDA: 83844738222.17.E271CF5
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	by imf17.hostedemail.com (Postfix) with ESMTP id 96CBF40009
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 15:46:49 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gtZxL25x;
	spf=pass (imf17.hostedemail.com: domain of thierry.reding@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=thierry.reding@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756828009;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h4LUm3xzftHp/xE2ENw2BOhVhXc1ZcghNq/wiRAVNUo=;
	b=FIxPD9KjuIUXt1UOvzVZVMR92lgxAa2p8K9Bp1LHqWAyZ2KOziLtlOt+/j28p97fLKD7v5
	nznmYCJLzReuXFgVm6msRNdZKEosHY1PL2T2x60L6o+Qv+exJyEdXJl6yGPIpYGgH4Diki
	18T44QfxPonhDjdD41XyJFqBRi+nFlg=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gtZxL25x;
	spf=pass (imf17.hostedemail.com: domain of thierry.reding@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=thierry.reding@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756828009; a=rsa-sha256;
	cv=none;
	b=iPBGW3y1T58lb2SfgL9KokSYpISO/VJ2nqQsg7Ewrdf3a/WrNXpMy94OD5Xysd73DZyPkY
	CFLeqELeqGoHaifmKiKSQoaMFV0gWqMLXZ8Nj7d/ARfKE40MgxYq2zqI8IcLzGfRkHpSXs
	TpQXgXIwYdBZ+e++BlM4FImLoS7/whU=
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-45b883aa3c9so17970165e9.2
        for <linux-mm@kvack.org>; Tue, 02 Sep 2025 08:46:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756828008; x=1757432808; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h4LUm3xzftHp/xE2ENw2BOhVhXc1ZcghNq/wiRAVNUo=;
        b=gtZxL25xzvw/t0WnVmi3exuczhHtlcotLgqMPa9Lkytyxc0FUGfSQPzZTxiu6SVmo0
         wzHsX6EvmO1D/y2iQIIhWSNxXu8nHkpbHtSv391jys4tz55RrlNak35A4TsBUeeAVAOk
         JdTHdtUvWIyBPITqq5veChcncJsOaN8OvluQ8YDw2bmowsFavrvLgWpgVLzsnWFo8erJ
         cmb5DY8w9lPFyDjB2kH3/zV/WTibpOGT5bH/GjYSeEizWD06o3O2hfEIaL/zSPoTTQQS
         Xzgs1uMJQCq9Ls5N+LPL/t2G/ZY9c9nnvWCP47pFBcKOzTiLo7u4M0b43dXZRTfb6Cp+
         8BHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756828008; x=1757432808;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=h4LUm3xzftHp/xE2ENw2BOhVhXc1ZcghNq/wiRAVNUo=;
        b=m2p0R727nX24Ogl26oYW2XxwiukPfW4AG5e8MgeYJKaO3x1hh+DfRjc89k4XjRJE24
         3bsMB+v2+1E6SWIq2/oIr3RCJMr+db6UniboTK/GZVHsF9uN+25XvbzkpDPW1W0xRy6c
         pf14YBzxQmWioufmEBsgmBgiXnN7OmPdWE3evTnw6nUE0J6jb1YXOHarWeFMovtqGCxk
         McilclHW4q0NEFTsTr7gdIf+XalRpzq9H9Sk8xpOLVuSGWqnk0HeDU2LWjHdoKE2h5Wj
         qdheEbMXz9TupYP3CH2mkqpAMhaHrLogcsrqYjC/eIENQLKlWGFdUBuFFiIrB/AOesZV
         H95w==
X-Forwarded-Encrypted: i=1; AJvYcCWaUNdTUDnjYbYjuaw+uvZPg7fJA0Ot7KCLw+7rPVfSCM4sRndzefJXmsXjupB1gOEweD9Jgn4ThQ==@kvack.org
X-Gm-Message-State: AOJu0YwhEB4tBnCg1qypfhuMpoBTlluAJZGoRPiHeO2e6zqcdKpOkRYG
	r6FMcm3f7Tq0Swjf/SDcyIwZc0463T5NFGhxtFJmGsogmemHoImX+iVS
X-Gm-Gg: ASbGncuXj3gNkRtptnfsDrz+OtjR9gvHS9ljCPH/EFVtUcPrOZl5M0LbLKu2zyyjwpd
	EGkvsWsaZZX9DTDNY52rBdKE688mfXQKoHRXMJJPTlUOHLhDISjodt6xrPWSBtTJZcwilHkFAcq
	FoEHjj6vy9bRZrAwgaUWStuYTeFiAXCCqMNeB+94YMz6H9JOev/LC091zgLzqFtDYKhIJdEDA5b
	uP8n1az/Vi0Sq8z5wjjIc8GRK+0SnlztLwNaf5F7oqjHCwwJheU2kFOB0DJ3Nj7COxaCw4grZtA
	b1aXLano2aHfoq5xYXgrteRHyASh9VaqVwTP57IZ/ObDq1i3l5nM112BhipOgvyp6s2Lzjdmwl5
	f1DsT9kv4rixSxg8QPjcjcF2J0DWnZEMNTB3aXEzWT8iMmSrrv9r/wnTU/oGozqdxD+KyaYES+Q
	7E08sB7FbABVF+cw==
X-Google-Smtp-Source: AGHT+IH1ceyRh0TFSkY7cElx5alHVXNEHIyhpSLS5qn4WT0MeK4fu88w2CD9wveL/P6+3CQyGvCJWA==
X-Received: by 2002:a05:600c:1f94:b0:45b:772b:12b9 with SMTP id 5b1f17b1804b1-45b855336dcmr103786195e9.15.1756828007780;
        Tue, 02 Sep 2025 08:46:47 -0700 (PDT)
Received: from localhost (p200300e41f1c4d00f22f74fffe1f3a53.dip0.t-ipconnect.de. [2003:e4:1f1c:4d00:f22f:74ff:fe1f:3a53])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-45b7e898b99sm202121435e9.19.2025.09.02.08.46.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Sep 2025 08:46:43 -0700 (PDT)
From: Thierry Reding <thierry.reding@gmail.com>
To: Thierry Reding <thierry.reding@gmail.com>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Sumit Semwal <sumit.semwal@linaro.org>
Cc: Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Benjamin Gaignard <benjamin.gaignard@collabora.com>,
	Brian Starkey <Brian.Starkey@arm.com>,
	John Stultz <jstultz@google.com>,
	"T.J. Mercier" <tjmercier@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Mike Rapoport <rppt@kernel.org>,
	dri-devel@lists.freedesktop.org,
	devicetree@vger.kernel.org,
	linux-tegra@vger.kernel.org,
	linaro-mm-sig@lists.linaro.org,
	linux-mm@kvack.org
Subject: [PATCH 2/9] dt-bindings: display: tegra: Document memory regions
Date: Tue,  2 Sep 2025 17:46:22 +0200
Message-ID: <20250902154630.4032984-3-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250902154630.4032984-1-thierry.reding@gmail.com>
References: <20250902154630.4032984-1-thierry.reding@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: mh3o9j13d5i7uz4uhniqicxasjyjbd5z
X-Rspam-User: 
X-Rspamd-Queue-Id: 96CBF40009
X-Rspamd-Server: rspam01
X-HE-Tag: 1756828009-6800
X-HE-Meta: U2FsdGVkX18Fz6GacDY3oAEInOHbqM1gOc05vAXs2vS+o+MCfenIMrQRRWN/7dZ9grKdzBpaQo4HsHJsGUC09Qzoa0yHjdXQipWjOKDP56Ec87YIcr8P740DFiHwj+qxj8s/Hvr7fNkgenZaWcTZpBOiz/LuDmP9b0sZe3VCrsMA7EBQMZZ+9dohxB26y0TThMDVe0CFO2bHOgQC6sUcRXDB6GZdBAvVm6EHB1qGq1iwNI+1IsFwCRxovfOJ1873fqhKcnLzBKP0t7JcozmjhyLKVk6qqtbpu5jDnvsRZJ2TBFeR/oRdh03ErHhFCkePqVbFr6NCPv7KqrK0E4LvVfRkhOvXx0nG+7SBVuc92XADlKaPOzP5y92Zuab5/6u3lNWX/Xl6Icx/nXlyRakFqSrTy1HJ/X7b20Lk5Eb4I/UupJA5oARjpUPT7+SR6WclB3FGrFQv6qjcelYiVXPQWJEUww2Q97puenktCA+IJpcuuz84i4l1o0hJd+/heVlFW+XBkeHwxyzPyeMBnz6Op3VOd9xXgLNHES8n4WkPuQfz+YPglfm4d2R7CGqEtfzOb1KoWc4pEB+e8jNS6S+E1dkqJMxdVbCxep4vGBrSK9wL0Hy0nWkr+6zR0QwWyKjWGbEdxDtIuE2FfXF8RlJdDfaCoJ1ut5skkxXolRygaA9Q/pDzVX4XNoiKO+8oIVOv74G1/ojNxLKGj/JDV08A39gp5THw4JSByOpbXrKmiMcItYKBSDQIwnznSO3CZn73OposhrlA4sOM6SQUGXlmZu6juIF8DtFWAiFXhLdsEQJNuk1+gfinKPsaigBiCOgf/Y+vtJkg1AHBX+fdBNT7esWTM3ZAPIMO8m2XNVt6/i7fDt5NpX+/Jt+Nio8l9iUzf7ayMvaZvOUP+H+TsHz7KhkwAcBOmtTWa5dKYtO3qL/wT/3d8mlFfd1Y28VnBUk/udxvYHj2nHNv1HfhsWu
 JMj5B8OE
 5um6ktGc6BrfHTSgo1SApa4S9QzjD+NrAbuTx8BycimPpFnc74ppyj208qhhH7/iP+bX2Nd3rzPGK+g7uV8E/lhaIs73qGDZN0R7LSOqMEOUy12jJHy2mAjwlA7tmin1BQEXsp8F590/oRLl612TpnVPVHE2rQP9Fumst3ASmIZxQaUb/YPsozalegpa5PsA9VYvfSpyNautYqtBpEUITBxR9U9aG4jq8x2K1HrEmFpTWxTgaohJOCHAS1kAQVKQYk3t0h4u6aOK1PaFTUwEXoy+e/T/agLSl8hoSV0mOM3OszCA0x2WELQaenqtNabtAV1K1AzWXgaPnMO6SI1OuU7CdNwao1AQaoQCwGpG+gRuxIY35H5mVFXjRep6rLVQpl1La24ByPORD4GhauckNQE5OjB52WWlSzlq4arH8I6VSLEwyTlLbjFAQUDnKlSI2UGjw1Bwo4eRh3NCZkvU+OJUjOHoQ4f6m6p1CTlOtpYkZJirxl0Bjg/Pl2/pe7PKA64ASq3zeDvS5RPa1HO7Hs/eQjnuv+LfvSimPJWY3y5dWs5zTiE2SobHoHpP7fSXEDW2d
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Thierry Reding <treding@nvidia.com>

Add the memory-region and memory-region-names properties to the bindings
for the display controllers and the host1x engine found on various Tegra
generations. These memory regions are used to access firmware-provided
framebuffer memory as well as the video protection region.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 .../bindings/display/tegra/nvidia,tegra186-dc.yaml     | 10 ++++++++++
 .../bindings/display/tegra/nvidia,tegra20-dc.yaml      | 10 +++++++++-
 .../bindings/display/tegra/nvidia,tegra20-host1x.yaml  |  7 +++++++
 3 files changed, 26 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/display/tegra/nvidia,tegra186-dc.yaml b/Documentation/devicetree/bindings/display/tegra/nvidia,tegra186-dc.yaml
index ce4589466a18..881bfbf4764d 100644
--- a/Documentation/devicetree/bindings/display/tegra/nvidia,tegra186-dc.yaml
+++ b/Documentation/devicetree/bindings/display/tegra/nvidia,tegra186-dc.yaml
@@ -57,6 +57,16 @@ properties:
       - const: dma-mem # read-0
       - const: read-1
 
+  memory-region:
+    minItems: 1
+    maxItems: 2
+
+  memory-region-names:
+    items:
+      enum: [ framebuffer, protected ]
+    minItems: 1
+    maxItems: 2
+
   nvidia,outputs:
     description: A list of phandles of outputs that this display
       controller can drive.
diff --git a/Documentation/devicetree/bindings/display/tegra/nvidia,tegra20-dc.yaml b/Documentation/devicetree/bindings/display/tegra/nvidia,tegra20-dc.yaml
index 69be95afd562..a012644eeb7d 100644
--- a/Documentation/devicetree/bindings/display/tegra/nvidia,tegra20-dc.yaml
+++ b/Documentation/devicetree/bindings/display/tegra/nvidia,tegra20-dc.yaml
@@ -65,7 +65,15 @@ properties:
     items:
       - description: phandle to the core power domain
 
-  memory-region: true
+  memory-region:
+    minItems: 1
+    maxItems: 2
+
+  memory-region-names:
+    items:
+      enum: [ framebuffer, protected ]
+    minItems: 1
+    maxitems: 2
 
   nvidia,head:
     $ref: /schemas/types.yaml#/definitions/uint32
diff --git a/Documentation/devicetree/bindings/display/tegra/nvidia,tegra20-host1x.yaml b/Documentation/devicetree/bindings/display/tegra/nvidia,tegra20-host1x.yaml
index 3563378a01af..f45be30835a8 100644
--- a/Documentation/devicetree/bindings/display/tegra/nvidia,tegra20-host1x.yaml
+++ b/Documentation/devicetree/bindings/display/tegra/nvidia,tegra20-host1x.yaml
@@ -96,6 +96,13 @@ properties:
     items:
       - description: phandle to the HEG or core power domain
 
+  memory-region:
+    maxItems: 1
+
+  memory-region-names:
+    items:
+      - const: protected
+
 required:
   - compatible
   - interrupts
-- 
2.50.0


