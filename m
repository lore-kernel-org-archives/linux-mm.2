Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BFA06CF6BE4
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 06:39:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3532F6B0093; Wed,  7 Jan 2026 01:39:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 334626B0095; Wed,  7 Jan 2026 01:39:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2599F6B0096; Wed,  7 Jan 2026 01:39:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 158B16B0093
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 01:39:38 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AAF0A1A0189
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 06:39:37 +0000 (UTC)
X-FDA: 84304216794.02.F39AF88
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 462CD20002
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 06:39:36 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nm3LVa0u;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of alexs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=alexs@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767767976; a=rsa-sha256;
	cv=none;
	b=qc2PoBh4AXFjnXqvF8twM83K0QZO1HKNmYCkKx/GSmgiOy0doM5Rjdrom+qjnuzgvdm75a
	cirNTNISQkOKoDHPE0BfQPKAVDycNwtEIetVB8cLgwZZ/66jPZ0xAsSill1GiBH+7MDNud
	cmOuIGc5xklVKLrZmcTYw1FD0LVAcT0=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nm3LVa0u;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of alexs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=alexs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767767976;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=oYBYngLQ5Y8vqjyxBumKrVYBb7J8jHFulXzZfom90M4=;
	b=ZAfWHp4QzuDpjK2QG7stH/AFj5tTXetXsEYTEz+QAnwc7TACwOmUbAvpgBm9AVJQlpypUe
	G6n7AybsvRBbZj1ucYZTNu+dG7K1ycmdaMqwXLm76Los9OIIwuz1jxmlWT/v3Sx67tcAId
	8HScVfDDmZX4TiCwDaBcEGMkCR2f/ho=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5A62F60007;
	Wed,  7 Jan 2026 06:39:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BDB3C4CEF7;
	Wed,  7 Jan 2026 06:39:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767767975;
	bh=r4bEK9BemNQRBh64Y6NaLRszQJcBw/t/jTWMXTw/H/c=;
	h=From:To:Cc:Subject:Date:From;
	b=nm3LVa0uxqUMX+/bH+uyM4Fc8+MpY8DLnc21LCeiWEHrY38jUfBbujI0jGMGQ7Lt3
	 lTovokU+kR30/S6Fqu46y5IEDkdkCLE7kBxjpAOUjBVbJBqY8oG2GiImtoWXcdHvFn
	 D6IrAwrP+t48kcm1zwUTeXrdgQY/AMThcSq2wNA05n6or4E7Q01Eos/jgVzavlVJ9l
	 OKYjfN9zxBvC35R91Qolhhapf2VS8UsksCNq4IC+Wo2B/vzPRti9kZ/70xGslfZm4k
	 4OMYaRA7JEQng5zWEpKLLl9kRGPS/1PcM1ljWEQ99c6hVAaAi5sJbyY2DpWQrs1r5D
	 o92EjFQopQjlg==
From: alexs@kernel.org
To: Arnd Bergmann <arnd@arndb.de>,
	linux-arch@vger.kernel.org (open list:GENERIC INCLUDE/ASM HEADER FILES),
	linux-kernel@vger.kernel.org (open list)
Cc: linux-kernel@vger.kernel.org,
	Alex Shi <alexs@kernel.org>,
	linux-arch@vger.kernel.org,
	linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] mm/pgtable: remove unddefined __HAVE_ARCH_P4D_ALLOC_ONE/__HAVE_ARCH_P4D_FREE
Date: Wed,  7 Jan 2026 14:39:10 +0800
Message-ID: <20260107063911.15299-1-alexs@kernel.org>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 462CD20002
X-Stat-Signature: ai6b5isr3o7i85xcbdua5ykhxnxof8of
X-Rspam-User: 
X-HE-Tag: 1767767976-772137
X-HE-Meta: U2FsdGVkX199b2wbZ02p0CD6lVdcXWUTj8dX+hseSkYNwr8ahz14EOttHfTiuIvO6bJSpZcC5RvtXqApNZuA/sp73VPr2m5l/uVQqXOsjlLidJEU1f8D5JpU/eB0XsrSxLuhjcIxW9oJrLMMCrrGwdrowLk+KK2nCqChC8aQgG96su1iG02VHR2SE4zhQEZ1EfwhV7Hms2TXFX8MnXhCKFukiRDsI0StWvLeTiqzHFQq+QarZF2gIU1jTfHx3N6XqlhLGRdLhDOgKZuS9Mjtl7cQn/y8MUj05XasV9ugelXvhmMLDLxXrue/DvqD6CesH8KjDG6yvk8/5D0jnGXbY8rSAA5yMhyTaiC6EeK0dVO3xklxJoZG7IdRb5vGYBZBo4nVkvy07nbP/C5QY8UCn14N5BqbD+ophuh+A8tfpcXd0D9JSqDR0RzMRsc2sNK/0sIu9hiFxZpB3VsMq5zXjPNFZxNRDNcCn/IoAjmyiobFIKSM9X1T83WlVlV46+S6syAsvNaRpSdg6JAwOfg3zXGYArFEnCiUzoMhd9eL2mBGNSLspuonq0TTjhdlyfcHQHmrbdb+Ox3QQXunmPsLF2fgRtnz/8ElFfkJoilW8qGbZhvfMtwgyZEbjX8E2xlK3zbbe6jJpPYAWjZNb1A/EjOVh3n4flCAVOXCgSe2Wbcs2zNztfx7YLC4S0dtwswaKC5cyZXbqweZk2tPHI1Dqpbkz3zi/qgQ9djRBkpY3EbGaNe2vO+FgqwnJvrKmM+RilFNLVQ7UfTY8eO0SfN27ubuQ3j1TbEOpUlP9dsGsGjT0vYML33BeSV4vdJEiUUjhV8YtziuONvPvsD2hWKj4s5IJY7dnOFbpQY6bjHPV5t0zQZppqxeMpsjR10QDMz8yl/D+GjfrVSPJytmd3t9Rj2Hxf1cpolst2xqh0nLPMxDiRsWJn3jRg1/iUazgFS3fUnpNJcezAsFklTlp5f
 jlu2w6Z1
 J6U/mAScRZ+qxDbT7Q11iwLoIPdj5W9cKrLIGIrz3U7fvJ/EW1aUDtsbQkh3GMN7emJOiRX8KDhq9kJNFWDNw5k5/cT9XwSIsYPWiFuGN/kRFX3Fr64s3aiQ+zhngx81gymigZdFENzTD/A2bwUTuho7b579kPRHzn58mB3E9E2EfSEJllx6e4R3yVhfeWSWpX7hXb0vu8bgpYq+D0IaPNRHOUbHaRuOOX6wg8Oim2i4LC3RSUJbd82rr0mqVZuihYB8cJ9cVX6BPnlp0jpLKq8RBMjMZB5WcElLy4l6Lw3ILuzVuehSm8G3dDq1rraHYedWIohi7WO2nln/PR4e5Pu8UzpUAs2QdGfUbyk8yA1XfQ14k2+UTZQ3PpO85JdZwv9Tdwq1ZV3enwJQrS2CBGm0AGFgJD0PPoqtUJ+0QH5v/qu8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Alex Shi <alexs@kernel.org>

No any archs has ever define __HAVE_ARCH_P4D_ALLOC_ONE/__HAVE_ARCH_P4D_FREE
So let's remove them.

Signed-off-by: Alex Shi <alexs@kernel.org>
Cc: linux-arch@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 include/asm-generic/pgalloc.h | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/include/asm-generic/pgalloc.h b/include/asm-generic/pgalloc.h
index 5fb31e0fe15f..11bafe764599 100644
--- a/include/asm-generic/pgalloc.h
+++ b/include/asm-generic/pgalloc.h
@@ -246,13 +246,11 @@ static inline p4d_t *__p4d_alloc_one_noprof(struct mm_struct *mm, unsigned long
 }
 #define __p4d_alloc_one(...)	alloc_hooks(__p4d_alloc_one_noprof(__VA_ARGS__))
 
-#ifndef __HAVE_ARCH_P4D_ALLOC_ONE
 static inline p4d_t *p4d_alloc_one_noprof(struct mm_struct *mm, unsigned long addr)
 {
 	return __p4d_alloc_one_noprof(mm, addr);
 }
 #define p4d_alloc_one(...)	alloc_hooks(p4d_alloc_one_noprof(__VA_ARGS__))
-#endif
 
 static inline void __p4d_free(struct mm_struct *mm, p4d_t *p4d)
 {
@@ -262,13 +260,11 @@ static inline void __p4d_free(struct mm_struct *mm, p4d_t *p4d)
 	pagetable_dtor_free(ptdesc);
 }
 
-#ifndef __HAVE_ARCH_P4D_FREE
 static inline void p4d_free(struct mm_struct *mm, p4d_t *p4d)
 {
 	if (!mm_p4d_folded(mm))
 		__p4d_free(mm, p4d);
 }
-#endif
 
 #endif /* CONFIG_PGTABLE_LEVELS > 4 */
 
-- 
2.43.0


