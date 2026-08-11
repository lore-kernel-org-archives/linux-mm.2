Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31C96C5B572
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 14:12:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D3E16B007B; Tue, 11 Aug 2026 10:12:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A9F76B008A; Tue, 11 Aug 2026 10:12:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BF7E6B0099; Tue, 11 Aug 2026 10:12:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 08EA86B007B
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 10:12:47 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8681CA27B8
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 14:12:47 +0000 (UTC)
X-FDA: 85089179574.05.D0F4F1E
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	by imf24.hostedemail.com (Postfix) with ESMTP id C9342180011
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 14:12:45 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=DWDUS76Q;
	spf=pass (imf24.hostedemail.com: domain of kmehltretter@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786457565;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=gUKReELtva+IRTqgyN0Xulu2tCFMOBx3NrOCV78F8dM=;
	b=AnBqKijCCdGlrtMRFnBaBCg4i2hSnvd5jxpNAsqPiLIVkDKckMrvE+pQiZRXV4AA5FRGvZ
	Yv6oHjs4GOLv2YgcG6U2wUuopr7xjqpNlYU6cyEp0kdpNtLnZ2JFpMp6SeQGC5rdEiufy+
	8NPfJUSFqVW+M4k68KzYrtgw+I/U1JA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786457565;
	b=pGFPNyNaQQWyqUd/Wt98xdKyt/nHIjm7mW7O20PQgKHg5kzehwac7LXWLk6z2f+pu++3wS
	EJJv5V5FQUTmMhaTIUnrax+KDt/wjaS6/rcAnr7k0zt0Cuo8HoKVTGRIW8dM19cB/ymXRy
	plhrDF4GOMD9MC42o4U6t6t36esfDu0=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=DWDUS76Q;
	spf=pass (imf24.hostedemail.com: domain of kmehltretter@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-49553515a8bso49712735e9.1
        for <linux-mm@kvack.org>; Tue, 11 Aug 2026 07:12:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786457564; x=1787062364; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=gUKReELtva+IRTqgyN0Xulu2tCFMOBx3NrOCV78F8dM=;
        b=DWDUS76QHGqUX6cW3BGsxFGSxrxQsg3iAciuhyLZ43o9aQ0dXTXpgWcZYm0BOKTHVi
         3YeULtQhlVUuruyP+EPatUBPiEYb3bR7H2qVhQ7no0KY8uHDnswxL3RQ38Hdc5ihkVUA
         hNO2792BO2HtCdXteNbpguptzmqCi4NV1C/4QF3Qj/hbJYz1OdVzL13Uj4hj2gMITZ5l
         lEwsOosDso41YXWWQZjRKjn3ylLUUvIf5JNIVVXDvLBpYoqxiYZiq4rNfjvjSjhGSSFW
         j13ENqqXw8XnSISS7F/3Ekf4QX53rZFfp987VWIsfHlJBY5u5+MHgQijoXBRZENdyCGQ
         rV0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786457564; x=1787062364;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gUKReELtva+IRTqgyN0Xulu2tCFMOBx3NrOCV78F8dM=;
        b=cOq79CecNmVae5nu5dSdKZub1dt7fDwctOvjn+5NSdSYELoQvX2vL4CXo6KWDoFM2M
         Ly+DA1gwJGt4cn57I2rcIVzVHHPbDzi11kKHWD2gVvmOn5giK0YH50HxkXeVq0+2OKH4
         lHR3lBIuIHovFQTF6d95udAWlkFW5o83Zu8HX3oNLnObRkBLsRh04zA5pYMczaOpBRDX
         mF7fgi5YPorGfDa5KZ7Z91NBtO/2zUgy1PpDHvAiuVagg8AZVggV8EO4BYoqP7wSWCxn
         DpYPYhHGukDG9Q8ySgWcpbCleGvpE2jZiDG1Qwi90wcnTsi8fd4IVGp1AHGNQJU+xQe0
         pFDw==
X-Forwarded-Encrypted: i=1; AHgh+RpVPUPA7mI/Cxbp2OLljsk+2goRU8ccbfZBAo6jP7ivUKA2yMNbhsXfwgbUDzhhucgAdlFavvILyQ==@kvack.org
X-Gm-Message-State: AOJu0YxX+JMVcJUmJr24Kqxi0Ap23GCvHH48vS1MczA1Xvyw+8dFxKsR
	kwUg7dS3MwzygzRJR3kOTFXoG8gYTEiNDvQ+2NWV8B/k9iCqViPhw/ua
X-Gm-Gg: AR+sD13dnbJpU2pY7/aLrfeQnt4AOXQYr8Q6lkOv4ADDg4Af9aHvaAWwNuy03AIE384
	ZJLg3DoIOkEWGiq9lZrcr1stD221pFZ6ODNo+crpvwc5qWvKpLgke67gKIfbWs9MvBLyVa3vrGv
	7Owmcg8sRczDYy5URF2ux+u2cBUpoMLpwpLHOQXUShvEi1fJuHdJ2hB32sl5nmjY6mSVNSNKOtC
	p3pxeA9ggTNp3ZTARMxlDm2NVSd5p8CGfgIe9+PugvxkqVpVT2r95OEI+YsWHdrcS/4EEM/s9DV
	QJ5nUm6DKhKTN99oXGxanPIlrrmCM8G6Dlgs6CA0VLDrRkkQ1tWZkchfiZMwNmI0mt5VtzS73uL
	GATbBIEeos7YGw95UlD8TmxN6P6AVQ+evhJRN4yEfYMepS0gO946xqraPgB26G9JvWQ1tYF8wwZ
	CjGipR/T9TWEhB37uLFgG670Va/Ogugc4er0kP2V5WRBZp9XBX8OXOAWHopFPtZrNpAg365jEfS
	T8fU8bP25ggbs+tGHfkxIKzm3YDpqjOMi0ymMy5VVidoURqdbsxev+72+dXywjjcVpTjRcOG60S
	alMd+Uy7zvzQptByac54wNFmgbrQtxoOaIbw/cRk+eAEK9JWciJdaQuZGNJxgaXlXOsZ
X-Received: by 2002:a05:600c:8b4c:b0:499:593c:3384 with SMTP id 5b1f17b1804b1-49978434835mr57851385e9.6.1786457563927;
        Tue, 11 Aug 2026 07:12:43 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a02-3100-a133-e401-bc8e-d36c-2d08-c5e0.310.pool.telefonica.de. [2a02:3100:a133:e401:bc8e:d36c:2d08:c5e0])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4814a5be29fsm4464099f8f.12.2026.08.11.07.12.42
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 11 Aug 2026 07:12:43 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Vlastimil Babka <vbabka@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	linux-hardening@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev
Subject: [PATCH v2 0/3] slab: ZERO_SIZE_PTR alignment and exact matching
Date: Tue, 11 Aug 2026 16:12:37 +0200
Message-Id: <20260811141240.62519-1-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C9342180011
X-Stat-Signature: kkrghew3e5o6t1oudqkfwhoiaunex81z
X-HE-Tag: 1786457565-988942
X-HE-Meta: U2FsdGVkX1+QX/erVUuLY5jO26g7Uk6PUfaK7DLLFgFxweRtodGMCQBCuCJjmcfkwDREHNIWq893ABJROsdbHRvylrcKZYS/kOerI/fqVuWkUCBUYbhnGy+iJyDo9fP/VCQ+ZHbKuj949JvCIZrHeXlGeu8XBjwwiSRdiw74/zIHFlbjvQzdWfWLLNabIbbccSNSdX9EnUaoL31ijX8zOWlp5gZNe/BBYeIytOiItSRdD7oWjt9zstxCuLnHieWMz2guerhtEQf57jqKHQUM9/zNBafQ4S7y+Ny9Q6eEQRD1UyBYH9uaUcehZsv0wV6yfFHX3s0EUB7805S7WrNdO1bpl0YWNVF35/qNslguTgGd9JMUNegELyOQuPWqQWJI5WRQz1pGMRqK5iQd9o4wA1Mxz8pVBogyuxLucLnkAyuqmyvIiWL07Zfb2VS1sh3DSX5dYuuwXXL1UCku6tH5Rbhcv8WfmUuhP5UMRNXGxoheJkHWBdlPRXTBkvMPtE7IKlvW/W22YQSJVNz+5950FBtHwP+zk9X8KrFfXyQsHEKpnrDHTLPjxdvHqN2nbMznpLLiNqDkW94jaqfZQY8Tme+rxQClMpT8CtG4BhfGvUjNRqCKV3Kl1hliDmaPlcHMQdltArYa2PfhR4lPRD0Px4oSZ7n4mK1ZSLG6CKjs87DPuy9Rd805XPZoOvW7to6pvrER/onDMMOf8XpdXSWR2kTmQQLdECSqQUr1+WoGZS/9no40ElYAXgUmCLVaDMz5NEHBbpllmd7+3k9ObMSaKbOMgGGrAFl3GCRETWjHIgwmwIHQ+fLP8oCIWjFXw4byXXwLCexbJpC8Ed/5AjQ8+wblfME6wTY/kt8Qs3OD/vi2xCAFlaHd9iNQHcMa2IqF9qKeu60Egc4yVrcnYSPA3ae5vk+vWwFhDAQN/ikMHR+OAP8DDSbwSEEE3nlz4tHQN3jWxjHFX80nGnvnodt
 0Ymo/YJo
 K1lVxvg/rkKaHa4IPeu7VGhrYL2O1h/zdQzA0CMn1/BlDGVbPxXOzM/YxMuUrLIy4S2150eafHCbx2Nub6aeCPuAj0aELo3k2Pfc/GQhprqz20lKB8eoQrZFR3DkgNSEo3qGCSlwgo3KyUpNBWi+UyHuoKZd56NXKmgcWUc35Kzvu0fZnyj/fMVBXpBMSfhJD0ESf1dCtQKnzDXhZ2pIujirXtu+HzxT9yLqsFoHTNkscMAAWD38cLGh3tXi5QiItxC01WMcf8jOc7tHRf0iWLg4UDT799hSIUKzh5LifBhNwKo159hZm3x80JNCCTlHpjqy5kcXdO+T4r/kTcqMojyvSStKpowwcoQenjqWb6k19JuP0JAwQeJwJ7MQjW1b9kDPtS+g9LH0VKgWlZ+aROtM5QB9G/Sg2dw1V0NnMbccH0CJAanBKoCEhZ6uFJ+/cVbVHeyFBmin+g7g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The kmalloc entry points promise ARCH_KMALLOC_MINALIGN alignment but
return (void *)16 for zero-size requests. Patch 1 aligns the sentinel
to that promise. Patch 2 makes ZERO_OR_NULL_PTR() match only NULL and
the sentinel, so increasing the sentinel does not widen the set it
matches. Patch 3 adds KUnit coverage.

In hardened usercopy, patch 2 changes check_bogus_address() so nonzero
addresses below ZERO_SIZE_PTR no longer cause its null-address abort.

v1 -> v2:

  - express the poison-pointer bound as 0x100 instead of 128 (Catalin)
  - make ZERO_OR_NULL_PTR() use exact matches
  - add KUnit coverage

Tested on bcc44b6785f21 with the series applied:

  - GCC 15.2 QEMU boots on ten configurations spanning sentinel values
    16, 32, 64 and 128, all passing the zero-size allocation selftest
  - the x86_64 test also passes with GCC 8.1, the minimum supported
    compiler
  - the new KUnit test passes on UML
  - Clang UBSAN_ALIGNMENT is clean on armv5 and the generated code
    retains the exact sentinel comparison
  - Clang builds the macro for 21 targets at -O2 and -Os, with single
    evaluation confirmed in the generated IR
  - patch 2 changes vmlinux text by -2 bytes on x86_64 and -72 bytes
    on armv5, and arm64 gains 44 symbol bytes

v1: https://lore.kernel.org/r/20260808105622.62026-1-kmehltretter@gmail.com
RFC: https://lore.kernel.org/r/20260712120728.96628-1-kmehltretter@gmail.com

Karl Mehltretter (3):
  slab: align ZERO_SIZE_PTR to ARCH_KMALLOC_MINALIGN
  slab: check for ZERO_SIZE_PTR by exact match
  slab: test zero-size allocations in slub_kunit

 include/linux/slab.h   | 20 +++++++++++++++++---
 lib/tests/slub_kunit.c | 43 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 60 insertions(+), 3 deletions(-)


base-commit: bcc44b6785f216eb939226ade6e3910baa30516b
--
2.53.0


