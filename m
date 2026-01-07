Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38502D0D143
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 16:48:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 592266B0095; Wed,  7 Jan 2026 11:48:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 528626B0096; Wed,  7 Jan 2026 11:48:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3AC516B0098; Wed,  7 Jan 2026 11:48:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2E64E6B0095
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 11:48:57 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 95F63B8B9F
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 16:48:56 +0000 (UTC)
X-FDA: 84305752272.07.FF56FE6
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf23.hostedemail.com (Postfix) with ESMTP id 008A114000F
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 16:48:54 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=none;
	spf=pass (imf23.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767804535; a=rsa-sha256;
	cv=none;
	b=ZA54g7nq1wkschZ1XC3J7o1W0hiM25NtIgtBo8cgFrHwD0dM7NW5Ov1zN32QxV4BnOhhUW
	UD8LsJc1L0n9kYa7v9Ph5KpVVNrh5jUZm+uf5XTfdJdrFJC+mhE5pXEwqa2OFMK21/6ViE
	EKZEoxkp02w3qxKWKnTb1g0O9rFIZmg=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	spf=pass (imf23.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767804535;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zvnLNIhU2mTgJAxt/cnwNlpPmBju7gEOXSLQfV9wycU=;
	b=bfZZVK7wANamDXjaX0VtVfaL+WBWxyCriP4JEBnzS4yiCn6p1HlondEJDjhKWdM0fSxjjF
	AHHlLGI5MXXKJQsiUOXzGlBDaFjXLZrACE+UnFKrGOXteOXfuPv781nvi8DBAGjvzoR+PP
	7kxZGiFz0aOdtHRKGNATLFrD40/IPig=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5ACAA1655;
	Wed,  7 Jan 2026 08:48:47 -0800 (PST)
Received: from e123572-lin.arm.com (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B8E433F5A1;
	Wed,  7 Jan 2026 08:48:52 -0800 (PST)
From: Kevin Brodsky <kevin.brodsky@arm.com>
To: linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Mark Brown <broonie@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Shuah Khan <shuah@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Yunsheng Lin <linyunsheng@huawei.com>
Subject: [PATCH v2 2/8] selftests/mm: remove flaky header check
Date: Wed,  7 Jan 2026 16:48:36 +0000
Message-ID: <20260107164842.3289559-3-kevin.brodsky@arm.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260107164842.3289559-1-kevin.brodsky@arm.com>
References: <20260107164842.3289559-1-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 008A114000F
X-Stat-Signature: 3eindqdsm9y4ofuiiy3pkozr4z8t9tft
X-Rspam-User: 
X-HE-Tag: 1767804534-264157
X-HE-Meta: U2FsdGVkX18XRtAunbXpqGI4aJN9i5fpE4dZxgP7GoSfl1eZr9bhTff95TvMBcr8m/3amL37r07D/VvVDlSJS51tgRy6SsJI6CsA6t4VknRityd7m3st4TOIA0yAEWEfY4l0MXcZ+JWJgnuSGB+pn4BuF5e5f8OQP1OcK+c587dMZ8UP2KnAdLxYtT71tFJTimk/00CIOtz/zLGC2OcGVTvG0YzTPMF5J0U0zzOQLIyNIFfaDRgW5i9Hc3tFnApg7p6osstNbKGi1T31CIuv6QZnBPHzXzRAK2pa+miipmRr5M0tgqajex4g2msTDYp4Xefh3MXKZ7S1DatXU9GYZ4MI/fApjNQE7x3ryHOZGP+SabRdYkYITLL+s+0ADXPgASfbsuD8Fwt2/i/biBesz5p5gsIkcHFuI3K6OOHt6EzS2mNXjw2pDf06H5BwCzqC0he0PGBpQ/h2FpiPD3lsnkF1JispayB14/NzcNe31iiFuOi7vv60svWyZ3L8APgbHrjVRgIDpJG2WxJDiIpcJvWNdx2ueyWYKwwCha0TZU4UZz/3iuoxo23ZwDqhuuB+mCPc6EfSCp77j/66S14jZXM/SZuQSFP7bDwlETp3GJ7recRrFMvnb4KYEaq1DJI8/hvpvomxbr7hJcovM6bfi6v3cs+K3zSy9mOoEP1kI3B7wLkB6UtLg68bTbaSHuNn6wJcqTC11dQNUrLRwSGDaaLFqkE0E8JXnFkDXiKf5vw49YVrII2dMMXaGQPAtOaNEQkLA40VWiDtFxdgt12/udHAis47ezMfYO7y92SLwIfhfJeOyAf6YOfS2KcN7M4K8Z3IHZdbnxuKCT3qKT/Gx/fjKgEB9QyeXZOXkFfV0nz7bNwlXhCUUx+QpQzDGcCKjKfE33Olkp8t46iWtKUuIUL+YNSFTQgy9ICbinL7q5hbZ/0hQ6lK5IDAdY3ck9oXIFCU5f9L5YdcNlHU2HC
 CP9fvqQX
 OC80m8fu7y+rlcZzZ0u3RSfq79819eMT4VLuiwfLxlHuxlroxHTrniV0VflGKmJs2qySVGAu6F+ovTlMANkwln3PbD0lV30l214rlre2Y9inFQLgrtDyMWQChlvE1bASRqlLSRxawFdjSrB0Mg4/XBvuTqFMOoToS+ZDZsE5FBSUcmniWAFfFhwXWha0fykg+7K4Sk8aLC4ppWYRuAb7scOxngp+4HlOaY/S4
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 96ed62ea0298 ("mm: page_frag: fix a compile error when kernel
is not compiled") introduced a check to avoid attempting to build
the page_frag module if <linux/page_frag_cache.h> is missing.

Unfortunately this check only works if KDIR points to
/lib/modules/... or an in-tree kernel build. It always fails if KDIR
points to an out-of-tree build (i.e. when the kernel was built with
O=... make) because only generated headers are present under
$KDIR/include/ in that case.

A recent commit switched KDIR to default to the kernel's build
directory, so that check is no longer justified.

Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Yunsheng Lin <linyunsheng@huawei.com>
Reviewed-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 tools/testing/selftests/mm/Makefile | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile
index bb93101e339e..4e5c8a330a0c 100644
--- a/tools/testing/selftests/mm/Makefile
+++ b/tools/testing/selftests/mm/Makefile
@@ -46,12 +46,8 @@ CFLAGS += -U_FORTIFY_SOURCE
 
 KDIR ?= $(if $(O),$(O),$(realpath ../../../..))
 ifneq (,$(wildcard $(KDIR)/Module.symvers))
-ifneq (,$(wildcard $(KDIR)/include/linux/page_frag_cache.h))
 TEST_GEN_MODS_DIR := page_frag
 else
-PAGE_FRAG_WARNING = "missing page_frag_cache.h, please use a newer kernel"
-endif
-else
 PAGE_FRAG_WARNING = "missing Module.symvers, please have the kernel built first"
 endif
 
-- 
2.51.2


