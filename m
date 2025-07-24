Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFBBEC83F1A
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 13:56:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8DEE06B02C4; Thu, 24 Jul 2025 09:56:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B8106B02C6; Thu, 24 Jul 2025 09:56:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A5D76B02C7; Thu, 24 Jul 2025 09:56:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6B2716B02C4
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 09:56:27 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F04EF160334
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 13:56:26 +0000 (UTC)
X-FDA: 83699307972.20.C8CCB3E
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	by imf21.hostedemail.com (Postfix) with ESMTP id E49CA1C0003
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 13:56:24 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=ISOdgl88;
	spf=pass (imf21.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.128.41 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753365385;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E5bTh+3Vvg3yCOBzS0gI9x4Skq8JpHTqDTkP6m6Co9I=;
	b=j30mkmNgzL3CAVVf/aM9T4ejzy2MQTu1zYY7B3LeZigPRyeDJ8NYcoIc7poKDEnQ8sJj5e
	jk1K614zcA/Lh/f6tBMeGckt6XnZV2yBwD//7qZwPHnY46953TTmwiGTDagqDeuKgcF5B3
	WhNJ1DPFqwnlyvjr1wdwnh5SimHuBkM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753365385; a=rsa-sha256;
	cv=none;
	b=VzVMF4uUxIeqCJMpU8HLD42oKpn0MkQBMDjNnQtAOVPkmcRxIvVLmUJ3nT9VZZ4CmeIIW6
	aHH8hfYFZD9zxGFI21K9pGokJ+vtJx3Sc1FnJcpCdP8MrIltkySQewQa9PRat7jBBfqBL6
	HhgxFO6tQUTsv31wpxXQ8jJxd1Uqz3w=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=ISOdgl88;
	spf=pass (imf21.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.128.41 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-454f428038eso9176175e9.2
        for <linux-mm@kvack.org>; Thu, 24 Jul 2025 06:56:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1753365383; x=1753970183; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E5bTh+3Vvg3yCOBzS0gI9x4Skq8JpHTqDTkP6m6Co9I=;
        b=ISOdgl88gXsrFFMtoHtuXh9KTWXQZ/emcchVscx+75jVpAlf9htY8XBQOSmSf4Tdkv
         VwCssj0JdXX8bFBfCbKN84reMjzg8KC0MaDQzI8OSwyYuWPBqC5ugqXY3B7Kks5veWn/
         0LpMPvPJJ22L/dXOv8yKApZ+15nWAZxjH/eW11VPSHGEPwC16Cnf/bi/PizUjg9nyjgE
         PT1XBY2hQCb7D4ibXWOs1rgmhF+V1GjiokwTN/qiafSQAMLpIT5AXPu246QoNHZxTEv1
         eA14gq5qUPpRTqijAoRT8v4nPo4DnmMP5Po8k1ycEnvb25KmZHl02SO8yAugo4Fbtk2j
         DuNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753365383; x=1753970183;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=E5bTh+3Vvg3yCOBzS0gI9x4Skq8JpHTqDTkP6m6Co9I=;
        b=HG23jpZbyOMQYOuKIAjQXxVk+wxTHEoeRw83kZ9q0qerY7mY2CXGeg+n0fmLSvp8/P
         nDEIIyznJCS/HEHmIk9vOgVPfcjZFWBKEbsGSE5zLYFnH++E6uDb5m8hCM8LyKecw8t3
         LtyQMIicVEcBoJTYHpXAv/zrDOImk9GQ+vxyXeNQ4AswPNOIEr9jfSaTq2ph5YF+DZLn
         8YKwbE5+4sTsb+krbrd72VcBJJgQMRmskyQEPKsFnSH2KJ7oI5T3wATj+2utLwQH1H7v
         INVBnqJ6QLLbCBTrEbfJzMaz65u8ZOQbHrXheio28zZs1IKYyN/qlVTOqVCbD5e0YrMw
         A6dA==
X-Forwarded-Encrypted: i=1; AJvYcCVwRi5dtVX1lTdYuuth6h1UQ5URrGPZzLV0hRDCSNYqXaBE937k6zCTE7R+GeYK8A37J42nCTRG+A==@kvack.org
X-Gm-Message-State: AOJu0YzlV3yns6i44DZRN8l3/PGx8N93CmEg6wbihyv3izf/dgSCcqmo
	Hl/JB0WFhSRXGUjV+dCa4p/qZW+BR+V7HGoTzGSZvO0hRiBDqoiiNQ8rfOJhVVT9dGc=
X-Gm-Gg: ASbGncvvK1OIU7W3vTS4AeNx0UWORTX2tfIPsNOlQEVzuM/jvUh/Hy2Zw3tGyy/f0LJ
	bHlFwgfpLGSn8yuaFEGnX+aU6kEgjv84N3wmd1B3Rju5BosEQ1XMAOnAW65ikqBN7PN23sE/3Mx
	6UyMlWKQo2zOkNrSb4+4q18p/ZvDraJ4Cwh9e+tv6XpOrEbzfRJSTfEeKwlCgol/a0V38ki6EZY
	S8mm7alV0TMoxFsvikvClHfWNLCnzYKhvBemkDel8lIoNm6WXopoJFEC+S37N5Iqd48WVbBdhei
	2NBbMUXBE5PHGpqtNbSkQ1SDgP/YSmTZuTqn+8z54NIg3PAfc0/ThiAP9Ml2JjiGAc85nt3SnsV
	ftZwKECXGZEOVKjnvWSb0cOk4iDuICD1a28JLmlIlYFfxpojxX3haJq89YqQE3H9rrw3D6TyQP7
	zyRAQE6ZgVV51T
X-Google-Smtp-Source: AGHT+IEIzq0FBEBm3LdZcFOEY9/KwPes9i1IaDCT4onRneKKA+Xc4u6PgwWHdq2thr0dEpYstk90ZQ==
X-Received: by 2002:a05:600c:4586:b0:450:d4a6:799d with SMTP id 5b1f17b1804b1-4586a8ce621mr55841895e9.7.1753365383404;
        Thu, 24 Jul 2025 06:56:23 -0700 (PDT)
Received: from eugen-station.. (cpc148880-bexl9-2-0-cust354.2-3.cable.virginm.net. [82.11.253.99])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4587054e37dsm20889375e9.14.2025.07.24.06.56.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jul 2025 06:56:23 -0700 (PDT)
From: Eugen Hristev <eugen.hristev@linaro.org>
To: linux-kernel@vger.kernel.org,
	linux-arm-msm@vger.kernel.org,
	linux-arch@vger.kernel.org,
	linux-mm@kvack.org,
	tglx@linutronix.de,
	andersson@kernel.org,
	pmladek@suse.com
Cc: linux-arm-kernel@lists.infradead.org,
	linux-hardening@vger.kernel.org,
	eugen.hristev@linaro.org,
	corbet@lwn.net,
	mojha@qti.qualcomm.com,
	rostedt@goodmis.org,
	jonechou@google.com,
	tudor.ambarus@linaro.org
Subject: [RFC][PATCH v2 02/29] Documentation: add kmemdump
Date: Thu, 24 Jul 2025 16:54:45 +0300
Message-ID: <20250724135512.518487-3-eugen.hristev@linaro.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250724135512.518487-1-eugen.hristev@linaro.org>
References: <20250724135512.518487-1-eugen.hristev@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E49CA1C0003
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: cm8prugo5eu6un1cb153hi9f9tfq1hp3
X-HE-Tag: 1753365384-530076
X-HE-Meta: U2FsdGVkX190/s6W7WEppMvxd45IK6s2nqepL/YvWKLz5/XzrbdGDAzluiowaC/sXqR+eGONX8eJdo2NeOv2N4MFGySpWZSzIav/poMtdbZr99w6xsDjHSN7A1T8LPr77nVvOPEZ54qRJalZbgHhjkmD8O2fh6AjEz0gcneRp34v9ZD2sx8UzAGZyPpmyknUKljiGoO6nMQ0/b42Dq1A8Vze2dCTgrmMopSUi2iE6jyC42HY7EobLeMdzJqwspfQrByyeD9bm84liom4paXxviSkT2nFAWU0NbM2pj5sPzQfXsiSGl9yQ45LEi02hYVs24NdPTbPRlX+QVoIpO8ZSPiKA6XspXWzhLf5VGcAL71A2MHytZw9iXPXBzim6ADlyrTbRHLLR3iuI7fYzu2vK0nnAwK35RqNs6zlT/3zJqg/Vkcen4g1iIs1idQke7rbwn7CqyqgoI5b6LEzeOZ3AWWWIwfC6HDIdc+MQgAoonbzQ0ZvVYRwR8BnS64zuB7EdYOYcoInEHkKgo7KdNib5XaG0cfrNOAVTHq57zaW1F2oVNFaA4dPssi3nP9eE0gI2iX5ZAIsctriuuPKKnmhmGBODuxUQJTaHEXXHk7K/Qb0v/O5DWC4quygjBQVbM2UV3xitwHTayr/95CG7LCPDWA0Fo8fstlT0WN2JdjUDDVIksOd5JntiLzA6tEYk6jsG6B/mKbm/DMmg468pSOSHBTkkyllK7ZiYTSv3iOoIPl32Exj8ImWsXxkMuipDgDhgTCD4eyNobWnIfx/X2XvX/I+UUNi0bfZWCahi2H7NzvtWmkMzDUSggnRZ/GmvxyWbUJs022uJ+bUhKTGXhrWLFpBdIBxTtGgQ+wDY/VmQ2G1DiCDsmoCWoLdnOXbc00bGL2FBhLbLD2mK9bGAalTTY0JO18Nv9boX1dUhbGnnQsybD+2CPx2BLuiR82MrIM9/4nH7fesq3DFcWNsZjk
 Qr9ShkKI
 Kl3lKAXwHmN5Pn6LAezcSdXkjXc1UmDY2VxssRZaSf4b/Hsiv4zDModE1FjikNxRLGQFfiE/T/+qOroBNH4tV//9QJfUa5g0/Soqg9G/YDxS6JyhvvCcuixTv2t1Ip6hZT6it9W+/FqrVAvoPlieB7r01K9SomrlvZ6CCTChBGZzAkVpPe3iZqwHI3nzKGJnMpE3oNX1c5YV2kl4azk2/QsA0Rlvmy7EGP6LtetTGOwu8BQYkU0JqQCL3VF6SqquqBHnRHCUm4tRdCOGzVmBBAAM+/cQNVkXg5i6+cRujcOWxLwQMCWtbnI2Ku3ogeIQCR+/cSwaeme+UnDk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Document the new kmemdump kernel feature.

Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
---
 Documentation/debug/index.rst    | 17 ++++++
 Documentation/debug/kmemdump.rst | 98 ++++++++++++++++++++++++++++++++
 MAINTAINERS                      |  1 +
 3 files changed, 116 insertions(+)
 create mode 100644 Documentation/debug/index.rst
 create mode 100644 Documentation/debug/kmemdump.rst

diff --git a/Documentation/debug/index.rst b/Documentation/debug/index.rst
new file mode 100644
index 000000000000..9a9365c62f02
--- /dev/null
+++ b/Documentation/debug/index.rst
@@ -0,0 +1,17 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+===
+kmemdump
+===
+
+.. toctree::
+   :maxdepth: 1
+
+   kmemdump
+
+.. only::  subproject and html
+
+   Indices
+   =======
+
+   * :ref:`genindex`
diff --git a/Documentation/debug/kmemdump.rst b/Documentation/debug/kmemdump.rst
new file mode 100644
index 000000000000..3301abcaed7e
--- /dev/null
+++ b/Documentation/debug/kmemdump.rst
@@ -0,0 +1,98 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+==========================
+kmemdump
+==========================
+
+This document provides information about the kmemdump feature.
+
+Overview
+========
+
+kmemdump is a mechanism that allows any driver or producer to register a
+chunk of memory into kmemdump, to be used at a later time for a specific
+purpose like debugging or memory dumping.
+
+kmemdump allows a backend to be connected, this backend interfaces a
+specific hardware that can debug or dump the memory registered into
+kmemdump.
+
+kmemdump Internals
+=============
+
+API
+----
+
+A memory region is being registered with a call to `kmemdump_register` which
+takes as parameters the ID of the region, a pointer to the virtual memory
+start address and the size. If successful, this call returns an unique ID for
+the allocated zone (either the requested ID or an allocated ID).
+IDs are predefined in the kmemdump header. A second registration with the
+same ID is not allowed, the caller needs to deregister first.
+A dedicated NO_ID is defined, which has kmemdump allocate a new unique ID
+for the request and return it. This case is useful with multiple dynamic
+loop allocations where ID is not significant.
+
+The region would be registered with a call to `kmemdump_unregister` which
+takes the id as a parameter.
+
+For dynamically allocated memory, kmemdump defines a variety of wrappers
+on top of allocation functions which are given as parameters.
+This makes the dynamic allocation easy to use without additional calls
+to registration functions. However kmemdump still exposes the register API
+for cases where it may be needed (e.g. size is not exactly known at allocation
+time).
+
+For static variables, a variety of annotation macros are provided. These
+macros will create an annotation struct inside a separate section.
+
+
+Backend
+-------
+
+Backend is represented by a `struct kmemdump_backend` which has to be filled
+in by the backend driver. Further, this struct is being passed to kmemdump
+with a `backend_register` call. `backend_unregister` will remove the backend
+from kmemdump.
+
+Once a backend is being registered, all previously registered regions are
+being sent to the backend for registration.
+
+When the backend is being removed, all regions are being first deregistered
+from the backend.
+
+kmemdump will request the backend to register a region with `register_region`
+call, and deregister a region with `unregister_region` call. These two
+functions are mandatory to be provided by a backend at registration time.
+
+Data structures
+---------------
+
+`struct kmemdump_backend` represents the kmemdump backend and it has two
+function pointers, one called `register_region` and the other
+`unregister_region`.
+There is a default backend that does a no-op that is initially registered
+and is registered back if the current working backend is being removed.
+
+The regions are being stored in a simple fixed size array. It avoids
+memory allocation overhead. This is not performance critical nor does
+allocating a few hundred entries create a memory consumption problem.
+
+The static variables registered into kmemdump are being annotated into
+a dedicated `.kemdump` memory section. This is then walked by kmemdump
+at a later time and each variable is registered.
+
+kmemdump Initialization
+------------------
+
+After system boots, kmemdump will be ready to accept region registration
+from producer drivers. Even if the backend may not be registered yet,
+there is a default no-op backend that is registered. At any time the backend
+can be changed with a real backend in which case all regions are being
+registered to the new backend.
+
+backend functionality
+-----------------
+
+kmemdump backend can keep it's own list of regions and use the specific
+hardware available to dump the memory regions or use them for debugging.
diff --git a/MAINTAINERS b/MAINTAINERS
index 7e8da575025c..ef0ffdfaf3de 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13620,6 +13620,7 @@ F:	drivers/iio/accel/kionix-kx022a*
 KMEMDUMP
 M:	Eugen Hristev <eugen.hristev@linaro.org>
 S:	Maintained
+F:	Documentation/debug/kmemdump.rst
 F:	drivers/debug/kmemdump.c
 F:	include/linux/kmemdump.h
 
-- 
2.43.0


