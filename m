Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9DACACA1005
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 15:46:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 098D28E0026; Tue,  2 Sep 2025 11:46:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 048568E0002; Tue,  2 Sep 2025 11:46:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E53318E0026; Tue,  2 Sep 2025 11:46:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D04E58E0002
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 11:46:46 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9648A84DD9
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 15:46:46 +0000 (UTC)
X-FDA: 83844738012.03.92DC62B
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	by imf26.hostedemail.com (Postfix) with ESMTP id 944B5140011
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 15:46:44 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="fNkZS8/+";
	spf=pass (imf26.hostedemail.com: domain of thierry.reding@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=thierry.reding@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756828004;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9qDZYWOWH5Nm8yxbrqXFYbkGArZ8+SY8u8XQGrfbmV8=;
	b=ZVj6I6y1xdZH1VZE10pxsjpCsAZNDovxDJJFRMD7zVGpUdpGmaYg589adJIUHX0aOexKxe
	f5DV+vWyuGifurBACIF2cWvaPW4vZMgpprGssKwgZA298zrUdonEJojjYrqM+n4L0EsYQV
	nmYOjdaOCNwm+3SL7i6ORSOjyKNqOn0=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="fNkZS8/+";
	spf=pass (imf26.hostedemail.com: domain of thierry.reding@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=thierry.reding@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756828004; a=rsa-sha256;
	cv=none;
	b=e2nZy62w/BD59wZTJ5sJPtDtLA8UXovF3BBu1/2TuSREW+dihW2y+pj+E1hYZT+iK3COxQ
	xSu7MtLzCXSrj8cKdovREuyM6mrUcoP++hDl2qDCxDtmSNfaULZYEktpFsS8bOrEqZ8DWY
	fR8lf1FVuL8tTqK0fmUx+UQu0yLAR34=
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-45b82a21e6bso26800885e9.2
        for <linux-mm@kvack.org>; Tue, 02 Sep 2025 08:46:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756828003; x=1757432803; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9qDZYWOWH5Nm8yxbrqXFYbkGArZ8+SY8u8XQGrfbmV8=;
        b=fNkZS8/+avzcJcwPcY9cP5AH/r+iFrhHCihfJ8CZ7hvL4hPM+7vyZ6ccYJPfQnKHP0
         fYLCxGmeUeIY2sNuJXb0gDh7vyjdUTu8c3x1WQYwOu+kTOV2ve/N8otUGtMbwroMSYWE
         qCdweWjsOPt+poSLxzL5vGo5p3Mn3rB1f/DT7v/CMlrzYUL2elrIbiL/wfRQHs//bNyO
         lejICo1UOQDErO1hIfdtmcXqhsTKhVp2iWoPxHWeTfcn+kIYQZShxbD6Gkwfn7n5xmsV
         SExWLutlR7sJQ/Tj01c+NbsF63RaXrQqk//1gAGT1cRX1pKRov2fL7XkkL+RN9YT35BC
         cnZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756828003; x=1757432803;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9qDZYWOWH5Nm8yxbrqXFYbkGArZ8+SY8u8XQGrfbmV8=;
        b=HlKJJgk6c3YNEKdjuv5ZrSpSiwKN8WwRC+vi8qQMCiMpS3xbvUl21xrZSJM2bQD842
         +afnzvoSZ1M+ZuvruIVpIxof8A4l6TRkhGenlOJV/jnCxT7S5d43rP4IXc6g6upM5otM
         Gk1dARJcm1JCXM+InOK+lr8WoT7CnABmjAWzM3tFp8jmcBH9TBVMPOyWGlaM5LD7/GM0
         4roF/lkhWGplG662ruKE7o3bOUCe58OvZBy/l8DWAbQ4P4MLy+5jNNdQz3nIndRv7uh1
         t6v4ET1UQFfsXjnoXcyt0Aw+Ui8zrUwUSjICuNrZo74vEFeJD2mWlqKqNGu9XLAvO2lc
         cCig==
X-Forwarded-Encrypted: i=1; AJvYcCXKXwqr8F9wuUvJpiRS+AdR4m+ML39wq2Hx0iIKT6f5+oUPyFXyogqDt4RzMnnoz15L3olbiPZEvw==@kvack.org
X-Gm-Message-State: AOJu0Yw0/vcwyrncTHw31tjRIR3svj/M8QKSJtvQm2eBfrCr2GA6CiV8
	NRkTSWv2e+x+rqwboPoLxvmGW5iaHMEgQPUShxoG425W8vrUJTKU9jga
X-Gm-Gg: ASbGncuow0f+2zwX2VTa+0y/tLxchrRdbc0gVkWA/mvQ5R9mYobd+gVTUpS/jJal/h+
	JhAnNcTJamm9ANYbIno8pfg9wXsmt/q7PPRvs4K1XktmYuQgCtxbqUhDSwMX+5p4z2jh6kYuP93
	EGHa1yRl3iBnREpkHJWrY2vAebRfEGVSW/9jKxNMoefCXmE6AowtxoaM2HLGsjmPojHjI2WLunY
	jAlYiFuRgTWG39FccTIdKs2xtdEMj3hTLdwT4zrwMvwhhXRIxU/BrQeiX91OzkIhjZom5xlLjX0
	2vekU0FS8gsObQGNfR3JSi1uOrXcJt9kopqx6fRzvF84C2xTn8PfJ20BuzqzxBnoz7ELAllE67A
	izcZ3kOP5ZUdsu3nWI9M0f37IFJWW7Phz9jLPmS2VkeAkB88YF7XUNmnJDqb5CH2iWTOJR1GzIM
	XWVxJVXnqXNq2lmg==
X-Google-Smtp-Source: AGHT+IFcgEUq9qD0GZO46TpNwavpzh+hTQklCsGnRUm93f3x88gh4dc9vHpbCmQtmoM4+DhaY2NGrQ==
X-Received: by 2002:a05:6000:290b:b0:3c7:df1d:3d9 with SMTP id ffacd0b85a97d-3d1dfa19a4dmr10655884f8f.39.1756828002702;
        Tue, 02 Sep 2025 08:46:42 -0700 (PDT)
Received: from localhost (p200300e41f1c4d00f22f74fffe1f3a53.dip0.t-ipconnect.de. [2003:e4:1f1c:4d00:f22f:74ff:fe1f:3a53])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3d85f80d8casm6829077f8f.54.2025.09.02.08.46.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Sep 2025 08:46:38 -0700 (PDT)
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
Subject: [PATCH 1/9] dt-bindings: reserved-memory: Document Tegra VPR
Date: Tue,  2 Sep 2025 17:46:21 +0200
Message-ID: <20250902154630.4032984-2-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250902154630.4032984-1-thierry.reding@gmail.com>
References: <20250902154630.4032984-1-thierry.reding@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: duidq351cf1pth4bynsdenxkzcbtyh9j
X-Rspam-User: 
X-Rspamd-Queue-Id: 944B5140011
X-Rspamd-Server: rspam01
X-HE-Tag: 1756828004-688964
X-HE-Meta: U2FsdGVkX1+y5pB6e9yHXVSJaeLsp8dv6Nncg9KItl7euPKgbGzXxCJi+yFC/q4pv7EEeUc0KuV5QpvqxTHjN3kkIqM5Lr+OVtFi1kqG9SxLNwmv/1PvAmGY9WPUqT26OUMnulyNXn28u95Cp78CZwenLUSJlrf/mywtBxa8esfSxgkcCzq4cdTeYwOgaMUe31qp+XTYd4xTpovLSERjB09sIqOckB7vbBDpP5/pQwVkmDLMakXu5H4C3UqMvEWaDVhk53uWZ7aRiXObMWE4X3VJevz0wZ2Zj5PlJaVcwPuI9mpYe7a2/4oBIPekJiSWm5XaVnvVFLBcyjFyamK6xPL1aG0OLueYR/4JKnbCeeJaJRIe30/8GQq7lIJN87ljbXtLB7R9MTXyLq9hJ+SaUDrmvCD7dSLOlmg3TyXwt1xc3Q+bVkfW+RVAQRkA0CrL5hUNVkazGZCex8V+e9tS9kZOP4Xcg/2DZgXLge7QrTPaT6S3sBTkSPzH84TQ9bSG3hEKuvh5lt6Hr999xdT1uIFoAr4xcGLhJco6M3kyloDFUun30quov2n6R4r7ZDcbfyIEzUwkLwW5GFQHfg/v1lj8CMCfNtOwMEtbBsGbI5KPdGBI2hiZqlQvj+yIhFyNnywjTZtZwyBALFWhH7F542Htsu7PdxCH2GIuShoM6gmZ0mMrLWeuo5536HJIk5MEHRCJKQyeqD97yIXj9O36FNS+hUYYSh8SoOtUBN2oGszPiCNgAZo602nPB9pTXKNm1XaHCKUNcvdp+LEp8/D15r8Q4VxXw7AritSIEnzYhzQw21oETRWeOPkDzKk6vpjQ2qj3iyarEL7/zFCTftkvrDEpeowdWvsLapUpqfSKzZEpPJpCOlO7QsWWJkNQq+tiKWkzgTt+LgYUcO7tTSRM5E6Bmm+nm1xKYfdWiRFhUvdjyh3SpX7ViDpYRgeTkFa4ACKgMZFtLwJlelTDRcD
 f07zxoUS
 tFzYwBJqJa00Un0MUoiIxprshmw0cWa9Ua+eW68gSNfikw/30M5gWrPEnCc4w3YyP79nPcHXTtgqUzf3ph9o1pPbtEfvIhqOBwmUHrHhBCsMFhsyvBkNDiatZ2v64/QqL5vluglPZSwTdMzfc+Vc0syDWnGK2ZGGma3oSyPwkfD08VIcWTWpFiNUZM/ZtRblww7NGYJhpUx4P1E9ixYHlpNXiPTCftIAOUEeocvv5YgXxuqhT+c1IaOBJcSpSJy0iBlPvkgkwZJlM+3vbKGHL1rDFyfHaNCzo2KYE9EGkKXieH7Ii/ZImSeJ+OITuz9sFZ+BfvYTYcwGx9YzkkXmWSoNDqiV3GYlxyoOVJQN9ACnQzda/LP+vUdXloiLaDg0Q/btvoo6NFksTptVx25dNNVf5dRJLJ3oMev5uBAwerRTpI1rCmfpwIksVf4q3GqT87P/WJzZTl/k8NNYzkVlAgcwiBwrWGYrhH88rvBCTvLOCkR3Ty7vFcXPyHikfeifVM1aOW7m7YjnbEYj/GnUKjlTEQzAIEc0kd8nZ8Ov0uf7ij0Zfd9DLapoF3kDy282ukMviAHTfc0KUUhs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Thierry Reding <treding@nvidia.com>

The Video Protection Region (VPR) found on NVIDIA Tegra chips is a
region of memory that is protected from CPU accesses. It is used to
decode and play back DRM protected content.

It is a standard reserved memory region that can exist in two forms:
static VPR where the base address and size are fixed (uses the "reg"
property to describe the memory) and a resizable VPR where only the
size is known upfront and the OS can allocate it wherever it can be
accomodated.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 .../nvidia,tegra-video-protection-region.yaml | 55 +++++++++++++++++++
 1 file changed, 55 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/reserved-memory/nvidia,tegra-video-protection-region.yaml

diff --git a/Documentation/devicetree/bindings/reserved-memory/nvidia,tegra-video-protection-region.yaml b/Documentation/devicetree/bindings/reserved-memory/nvidia,tegra-video-protection-region.yaml
new file mode 100644
index 000000000000..c13292a791bb
--- /dev/null
+++ b/Documentation/devicetree/bindings/reserved-memory/nvidia,tegra-video-protection-region.yaml
@@ -0,0 +1,55 @@
+# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/reserved-memory/nvidia,tegra-video-protection-region.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: NVIDIA Tegra Video Protection Region (VPR)
+
+maintainers:
+  - Thierry Reding <thierry.reding@gmail.com>
+  - Jon Hunter <jonathanh@nvidia.com>
+
+description: |
+  NVIDIA Tegra chips have long supported a mechanism to protect a single,
+  contiguous memory region from non-secure memory accesses. Typically this
+  region is used for decoding and playback of DRM protected content. Various
+  devices, such as the display controller and multimedia engines (video
+  decoder) can access this region in a secure way. Access from the CPU is
+  generally forbidden.
+
+  Two variants exist for VPR: one is fixed in both the base address and size,
+  while the other is resizable. Fixed VPR can be described by just a "reg"
+  property specifying the base address and size, whereas the resizable VPR
+  is defined by a size/alignment pair of properties. For resizable VPR the
+  memory is reusable by the rest of the system when it's unused for VPR and
+  therefore the "reusable" property must be specified along with it. For a
+  fixed VPR, the memory is permanently protected, and therefore it's not
+  reusable and must also be marked as "no-map" to prevent any (including
+  speculative) accesses to it.
+
+allOf:
+  - $ref: reserved-memory.yaml
+
+properties:
+  compatible:
+    const: nvidia,tegra-video-protection-region
+
+dependencies:
+  size: [alignment, reusable]
+  alignment: [size, reusable]
+  reusable: [alignment, size]
+
+  reg: [no-map]
+  no-map: [reg]
+
+unevaluatedProperties: false
+
+oneOf:
+  - required:
+      - compatible
+      - reg
+
+  - required:
+      - compatible
+      - size
-- 
2.50.0


