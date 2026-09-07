Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2FE66C79F9E
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 01:21:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 52FEB6B0093; Sun,  6 Sep 2026 21:21:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 504D76B0098; Sun,  6 Sep 2026 21:21:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 417C76B0093; Sun,  6 Sep 2026 21:21:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 19C516B0095
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 21:21:04 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 955511403C6
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 01:21:03 +0000 (UTC)
X-FDA: 85185212406.26.7E7F17E
Received: from out-zbxj-a90.jellyfish.systems (out-zbxj-a90.jellyfish.systems [198.54.127.90])
	by imf08.hostedemail.com (Postfix) with ESMTP id AAB67160002
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 01:21:01 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=tychen.cc header.s=spacemail header.b=DTKK35OQ;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of hi@tychen.cc designates 198.54.127.90 as permitted sender) smtp.mailfrom=hi@tychen.cc
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788744062;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WeYc57y9dpWFhwnMjk7xB4VJwaE3zD67JULtkUrpWOg=;
	b=2gt9uDQ2z34UDKAStbKK5VBvzFmY4mumSIi070gTLgwwRYJGh111i7tJsSVRKeZ+w9K6Fv
	WCqe7MOBNIQb8+71YQeKp26Fk2gGpEb93jS5w0q4LjyVrwCGUx5bEtcD7PEZ8gkTXEwMXA
	dM5erTCRLVxXAAkv1GpKTVdxMzlC0K8=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=tychen.cc header.s=spacemail header.b=DTKK35OQ;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of hi@tychen.cc designates 198.54.127.90 as permitted sender) smtp.mailfrom=hi@tychen.cc
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788744062;
	b=UTRkPvG4zNr6berLiOVor8RbUfPn2Wh4/pUXbupPYzz2e6qhvwZ0gIvi3rYwJbLcB7l5l+
	8c8dLAMRwrz59jCx8a4wpE4c3M8wxfMUVhu+rS57MboamVm5sEpIWTOe7ymHWt82m2vAAh
	rzVEbjUUydaT2AEh2GuZ4WDm5kgDB4E=
Received: from 192.168.5.3 (unknown [69.5.53.41])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.spacemail.com (Postfix) with ESMTPSA id 4hdTlp3qYJz6tm9;
	Mon, 07 Sep 2026 01:20:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tychen.cc;
	s=spacemail; t=1788744041;
	bh=WeYc57y9dpWFhwnMjk7xB4VJwaE3zD67JULtkUrpWOg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DTKK35OQ5Om9kOlvj84tQvC33bc6umR21uym8RF8lQOtFSDb9/ZD3RtjKnh0Wa0Zb
	 4/+UmvVm3Hr5Vuy16wRnHwKBjli+Ls5Wc8QV/lVw//t1LoRAJ07YhW4qQMRNplkLhA
	 q1PEeX5GxGjruVfj5LeMmHBQxtwHcqxO+TFW3Wkt7/TRG6sWRJWeE8fJZiR8TDcBt/
	 YrVgWnwIN4tp2I34bobuIR2vWODDDmNcHn3SvBURS77IvJrxTMffbPpBtI6y4sPGmL
	 JpOfoEHAQ/gwu1wqGePM8fLSSPRzkGfE1Sg3uYEFLHJ7hfaVFBdhzkRGKK8u2NAf+L
	 KKnim+e4k7G8w==
From: Tianyi Chen <hi@tychen.cc>
To: rppt@kernel.org
Cc: Tianyi Chen <hi@tychen.cc>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] memblock tests: model the low allocation limit within dummy memory
Date: Mon,  7 Sep 2026 09:20:32 +0800
Message-ID: <178874362959.1415955.9346611507889046159.memblock-v2-1@tychen.cc>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <178874362959.1415955.18132997964995947947.memblock-v2-0@tychen.cc>
References: <20260906144011.848898-1-hi@tychen.cc> <178874362959.1415955.18132997964995947947.memblock-v2-0@tychen.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Envelope-From: hi@tychen.cc
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: AAB67160002
X-Stat-Signature: 9sf1b8p8885g7b36zkfedec7b3j8ex3e
X-Rspam-User: 
X-HE-Tag: 1788744061-682799
X-HE-Meta: U2FsdGVkX1/KMk6eZ+dDDMxnbJXGrew8wPqn3m3/JxLdFLNUBoJifhUeykWdkgbEFuebRYETFzbcDjk3hPeSBTuhb8AiHsx2aVqcpCNZRbQLdLRiLtVuJPPlIuVgOJGqmkKNq3Jw0uJdaYIpxGs39TWuHVqekxXNcJ7nuxN0Asz52u+gXyWncixQ1zWIBVV745zKoKfk4EeqYemw0EXXa2TeW/m9X+OBHd8dFiVDbXyKm351sHdRCBEIZzTM+vZS2odU3LUBVa/Bpx7ISDJYO5M7ibDV19am9qsGkQ5tn72b7r4rFvDS3h0g31Pkb3uAgUDDLQPFnhQjx9nDSsbDpI5KLmSOE2yOu4y/5c+y+lPpMn8T15qcgH7S9pnSjjKBhhruRdgdCEphcRMdFqzirsHLb+4IwGXmYJ6oelwBj0yoDoTEwcjx06vWnv5lg2U2hkATmih7/31gd5Ho5ebqjq6VxwkkhjcIv6n3Ghuvnl8m0Gal53wF21q1k7d0cAuozbU1K7yUm3aOCjG+SqmkH6/iI+BI8vT98CrUMR9qOsZzrvPnXE/+iSMIiNg0EbxQc45M54sm+SKtAoQEMcyKeJRMDn9eX+ZgHMT1qIYCmnkrWHXApJZ1g68TMrAex6c/L2UfwGOG8E16ZGDsbvorfAE4nFf+dPZ4ZiJ8B/o+RGXBFRRvIgdP1Nq+/gt+B+j2Thxg6oZGIUYXo+O3ckz9Y+xv3oH5Ya0+tsuD+AlD3oq9hlTrg+vVof5A2Wq0/fD0scRPkQtzBbJYcRKzsPxevFK0HCfuerFoKOvZ38ZjPPLqyCjYDLVMykTOe6Efn6YXAMjlKFD03MDG6fdJb7HqwmiI3qr3s9ghq3bIgUJRtucibYvSjAhlcUMJXGnapT5BrX2+5HymDhm9Ya4HTpE4OMTyGuWwFQJTOmik2/0GeG4BiUPa7ZyxRVv4ido+vTCkiBXATCtbyTF6Dl/D/lj
 oJtJT/Ue
 hlFOETJqsbfpzWUn/mJX08GEb89c8xLh7jJjLEFYDpCRhY7fKpvwJSM5OR2FtEvNEs2h2840aunj7Zg9y7707qCaqiXxR+mVcBilBRMP03riAH6OnwaV8agtmIzsqjmANmxbdyEZuIwBX9zFuSBVslHZlaY6jCYaAf6uBSI1VaVBKWfRvYTSF149OsLO2bs+bbk/r+vfzS2G3PudebHG9JXYIRXyOMeDSB2zKc57jDR3onZILXrKkGutSlNT3LkynknlsZJT8qGfApBreIuwmPOadGTBUYX24zVkIZl4EyZQGXFUtp1cvm/m0MlMHkXSeEIhfpWfcYj7JxGs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The simulator represents physical addresses using the address of its
allocated buffer. That buffer can lie above the default
ARCH_LOW_ADDRESS_LIMIT, preventing meaningful memblock_alloc_low()
tests.

Use the architecture override in asm/dma.h to place the limit halfway
through the MEM_SIZE region registered by setup_memblock(). This leaves
registered memory on both sides of the limit. PHYS_MEM_SIZE describes
the larger backing allocation, rather than the registered region.
Resolve the limit after allocating the buffer. The production allocator
is unchanged.

Assisted-by: Codex:GPT-6
Signed-off-by: Tianyi Chen <hi@tychen.cc>
---
 tools/testing/memblock/asm/dma.h      | 6 ++++++
 tools/testing/memblock/tests/common.c | 6 ++++++
 2 files changed, 12 insertions(+)

diff --git a/tools/testing/memblock/asm/dma.h b/tools/testing/memblock/asm/dma.h
index 13ff8e5d22e..6607408dcf2 100644
--- a/tools/testing/memblock/asm/dma.h
+++ b/tools/testing/memblock/asm/dma.h
@@ -2,4 +2,10 @@
 #ifndef _TOOLS_DMA_H
 #define _TOOLS_DMA_H
 
+#include <linux/types.h>
+
+phys_addr_t dummy_physical_memory_low_limit(void);
+
+#define ARCH_LOW_ADDRESS_LIMIT dummy_physical_memory_low_limit()
+
 #endif
diff --git a/tools/testing/memblock/tests/common.c b/tools/testing/memblock/tests/common.c
index 3250c8e5124..17b95af216b 100644
--- a/tools/testing/memblock/tests/common.c
+++ b/tools/testing/memblock/tests/common.c
@@ -118,6 +118,12 @@ phys_addr_t dummy_physical_memory_base(void)
 	return (phys_addr_t)memory_block.base;
 }
 
+phys_addr_t dummy_physical_memory_low_limit(void)
+{
+	/* Split the MEM_SIZE region registered by setup_memblock(), not the buffer. */
+	return dummy_physical_memory_base() + MEM_SIZE / 2;
+}
+
 static void usage(const char *prog)
 {
 	BUILD_BUG_ON(ARRAY_SIZE(help_opts) != ARRAY_SIZE(long_opts) - 1);
-- 
2.55.0


