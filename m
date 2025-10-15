Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 570ECCCD18E
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 06:48:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B571A8E0008; Wed, 15 Oct 2025 02:48:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB9F68E0002; Wed, 15 Oct 2025 02:48:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A8A58E0008; Wed, 15 Oct 2025 02:48:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 832008E0002
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 02:48:08 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 22F7D11B2D9
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 06:48:08 +0000 (UTC)
X-FDA: 83999419056.19.A6FCFF3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id A56744000A
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 06:48:06 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=H0wHAfwA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760510886;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=xTUv6OGNrRahJgEqlg+1EXPF3auigpZ8UpzsEr/ykpc=;
	b=a2LMIiaNTU14BxuhRTm34VOV7/DOJqTkzkeGCUObAe2vTGLbGbBLTXjuEeHSHmXFro2gMa
	baaqG1arCPnJmN1n7T0XfL2HxVmBsu3J5N0BTRyoQ/FVGG7HiSmodWYF+6JEMefExts4Vu
	sxb/teRRFY5zqZBi5j2wqM9GwXq3Wek=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760510886; a=rsa-sha256;
	cv=none;
	b=VbPgqJ2l2K4tsYapz89NtKuTfY9u5bkR8wAZ5uawd+4xfCvgnPXzdgW7GnLW7IQ/98wHoX
	lKdiuNm/DbkUS/ZOWebpf2k+vVEQ4XCRGLNYkh4b6d8DiSow5hDZ23CgXPrig4+hSInufF
	nAxkG1rMR165rB325SW19fkOxIi1nYw=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=H0wHAfwA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id DDA596298B;
	Wed, 15 Oct 2025 06:48:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 969C8C4CEF8;
	Wed, 15 Oct 2025 06:48:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760510885;
	bh=KsS5xOABSmfYlcnL3VQZQMNjTjI7cwu4YVwYjCn92OA=;
	h=From:To:Cc:Subject:Date:From;
	b=H0wHAfwAl2ndFvoBLhKGlFMfpkrM0jMYEW5g6hug4b7UZJbAHauYJRwrfPcY5jOFJ
	 /DJ3t2/dzM513Acoa8EuBLs+FuWhRHliZhdkVDs4wPnL7YT+RztWqHA2E44RCkciHV
	 fs5T6YQ5K60utS5sKl/KT/TANSZXTjt4GSKKHh5N49NtIMKCm4J8GESHv+OtJxoppn
	 iK62a9DQbOT4djJb3Jt/wvP/vlxRGkMOXuUyH/+DBgYoU7A1eRRr9GKB5Uw/RvQaBo
	 h9/jbmb4iLWjVUolQ3zmcoPMI5+xRCgvKtr2CLjm8JxRpt/DTiYTQ+9jb18aewwMWi
	 a3bvG+mV0ceMw==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Guo Ren <guoren@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	linux-csky@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH] csky/mm: fix build errors cause by folio flags changes
Date: Wed, 15 Oct 2025 09:47:59 +0300
Message-ID: <20251015064759.2993842-1-rppt@kernel.org>
X-Mailer: git-send-email 2.50.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: A56744000A
X-Rspamd-Server: rspam02
X-Stat-Signature: it966p8iz3mgx373wbpnrfwck1ffsqc8
X-HE-Tag: 1760510886-614234
X-HE-Meta: U2FsdGVkX197FE8kZ4qRSsDtGcloAzNWu7BriJqeYAxa0d/hDSYDFF1eonUDr0Gp0hs21XvkulLSf16ODXlunmrnxx+DyjEO2YmPhKes3zuiZyeO0rAcxngqg0aEpmJcwTVt1/0W62H12KfqArBgQHQq71GgTHPTgbW1aQtGsm2Se2AfHtu7lWy8uO0fuX8SBqJ1BPU2pJRTYJ1LYru+iEnEHsjWV3XtsG70TnAXiIN87hMQ1ukEqThl3is4qEKJ60MjEG33MdntqVWpQzDvNw+AV3v0OMycpTa5x+RGOOkMY6Lp8k63FTBomlMk2ezCH/VAKi6BjDOheQAoQVeS8SQdQK2riZcreBxy0RcxDTu6jW4LVs61peyUr7ObMti0qX6uO6QTszfxiqmlqZZDpd3eWfcF1jx7nGfJfJbwA61Q+s+AYRlP15IN4cu+OEeKtN55M3Hm+aU4GfZEdSQSCoW36N+AKxrpNeQvsmZGVYlNdvEZ6vCsDtGLBEeZ+D2LLi1YRagrtvXmfsVI2J/6/EVaYAzQm8vLqHIn9ieoXTWL9z0Vj3tXXJV8eedo/UooHs65aSaVpUUQ+lslq79JqPoWFAMBu6D1loOjp9oYSSo0gubct2qcYFB27qDKXfxKkrrzbHDZJx2qdHGJC+DONlBI3cRzzbCiGqGlyQdP3wRZND0R4tLlIS4RNCLEqHCJVmkzUV/+Mo2xDtI8DWscCvVuCReT6isTr3c6cWImv5zesYWTSodSaCGQpO5INalX54bt7Z7TIU+WXRHdGQIBi7IOUdEYdoa4/LvHbsCNhRIMSPyylBi5Xngur3UJc0JWqAQJXTVmLXk4x5iQGFLI7rRfvHti55xSgdlVQca+NHq62kpLg8m7+OLW6EN+srS1XhZ5lSq7HvRhZzLdXykDiDA1sdXklboEYd+WhO5nptfxKzKtuCSYIPlwwJPxC/esv81T7Lv1mg++l4tDm3Y
 mO6kLGRe
 7GkszBTlxVd5F6lJ2mhQRhnmItiZioc24YVqR+OVQCoQe5Nky7PAXuD6GT3ZDB7Qw2Ibb1+l/6D5/kkINh9cpHM7/Yg1vmWDpe888i0XSbyG6F6FAPVGFGI4mK8nV+qOGOmRs/WNp8dmpGN1IoDgG97eWLpJfp/zFA+eIn5/Etqph7Ni9Gb0PwUpWRuxZ0EakUwYWcQmf+bScymP2pzBQ48T1lL/uyNTDTHzsbofWqAoIh14=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

Kernel compilation on csky fails because csky was not updated during
conversion of folio flags to memdesc_flags_t:

arch/csky/abiv2/inc/abi/cacheflush.h: In function 'flush_dcache_folio':
arch/csky/abiv2/inc/abi/cacheflush.h:23:39: error: passing argument 2 of 'const_test_bit' from incompatible pointer type [-Werror=incompatible-pointer-types]
   23 |         if (test_bit(PG_dcache_clean, &folio->flags))
      |                                       ^~~~~~~~~~~~~
      |                                       |
      |                                       memdesc_flags_t *
include/linux/bitops.h:47:24: note: in definition of macro 'bitop'
   47 |          const##op(nr, addr) : op(nr, addr))
      |                        ^~~~
arch/csky/abiv2/inc/abi/cacheflush.h:23:13: note: in expansion of macro 'test_bit'
   23 |         if (test_bit(PG_dcache_clean, &folio->flags))
      |             ^~~~~~~~

Update references of folio->flags in arch/csky.

Fixes: 53fbef56e07d ("mm: introduce memdesc_flags_t")
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 arch/csky/abiv2/cacheflush.c         | 2 +-
 arch/csky/abiv2/inc/abi/cacheflush.h | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/csky/abiv2/cacheflush.c b/arch/csky/abiv2/cacheflush.c
index 876028b1083f..064b0f0f95ca 100644
--- a/arch/csky/abiv2/cacheflush.c
+++ b/arch/csky/abiv2/cacheflush.c
@@ -21,7 +21,7 @@ void update_mmu_cache_range(struct vm_fault *vmf, struct vm_area_struct *vma,
 
 	folio = page_folio(pfn_to_page(pfn));
 
-	if (test_and_set_bit(PG_dcache_clean, &folio->flags))
+	if (test_and_set_bit(PG_dcache_clean, &folio->flags.f))
 		return;
 
 	icache_inv_range(address, address + nr*PAGE_SIZE);
diff --git a/arch/csky/abiv2/inc/abi/cacheflush.h b/arch/csky/abiv2/inc/abi/cacheflush.h
index 6513ac5d2578..da51a0f02391 100644
--- a/arch/csky/abiv2/inc/abi/cacheflush.h
+++ b/arch/csky/abiv2/inc/abi/cacheflush.h
@@ -20,8 +20,8 @@
 
 static inline void flush_dcache_folio(struct folio *folio)
 {
-	if (test_bit(PG_dcache_clean, &folio->flags))
-		clear_bit(PG_dcache_clean, &folio->flags);
+	if (test_bit(PG_dcache_clean, &folio->flags.f))
+		clear_bit(PG_dcache_clean, &folio->flags.f);
 }
 #define flush_dcache_folio flush_dcache_folio
 

base-commit: 3a8660878839faadb4f1a6dd72c3179c1df56787
-- 
2.50.1


