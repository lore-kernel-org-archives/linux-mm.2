Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15043D43363
	for <linux-mm@archiver.kernel.org>; Fri, 12 Dec 2025 07:09:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 16CF46B0005; Fri, 12 Dec 2025 02:09:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11E506B0006; Fri, 12 Dec 2025 02:09:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 033B96B0007; Fri, 12 Dec 2025 02:09:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E61366B0005
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 02:09:31 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7D22313B05E
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 07:09:31 +0000 (UTC)
X-FDA: 84209943342.14.9E45A27
Received: from out203-205-221-233.mail.qq.com (out203-205-221-233.mail.qq.com [203.205.221.233])
	by imf04.hostedemail.com (Postfix) with ESMTP id 9B0E740006
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 07:09:28 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=r2VaPkgp;
	spf=pass (imf04.hostedemail.com: domain of 815559068@qq.com designates 203.205.221.233 as permitted sender) smtp.mailfrom=815559068@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765523369;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=IXNkv6VDsX+5RxmtyeI90QUmoZKQ3Q77u5K0IV6GAqY=;
	b=OnmnWt/UyMdIuzjlA6S3WXjyKXTMbcJ1VsWtEpeQQHrAMAU5Bl8Nx3BdgeZ3Fvp8Oy63jA
	BxQWNwJJEe1YmFFom2as4dwl4yOlnsEYTcSusWu13Lufo58oh67/gzEPAXUTxu40hPMa7l
	7KdKnQYGkR2fhKpQ8thRX0++AE7cBRU=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=r2VaPkgp;
	spf=pass (imf04.hostedemail.com: domain of 815559068@qq.com designates 203.205.221.233 as permitted sender) smtp.mailfrom=815559068@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765523369; a=rsa-sha256;
	cv=none;
	b=x0sLcpNluCXnocPsLefOwTcBHYVRd++G335ywfSIGd+pW+PwCLQiSVo/jraqCSmLJzH2NI
	H/m3fNrwQWnSrcHOGurwyS5FS4TK//wczTcTnxfpL7WDMPYTooo5FkDwLq2sFy7sy81Dnd
	FQpGpjaZfU7ZrlOmclP+tHA5qF9VRlk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1765523364; bh=IXNkv6VDsX+5RxmtyeI90QUmoZKQ3Q77u5K0IV6GAqY=;
	h=From:To:Cc:Subject:Date;
	b=r2VaPkgpSpUD9wthSVKnlmNYzS7oXowkmLbknut0mv/E8lCsod5yv4XjdoyES7Yqm
	 3xhaAjbQMugX9HUcruaU4oUbec3mYfjpUKfZ/6+vfKgUT2izBx4QCw4PNKcvEprFHl
	 p1vGL8u46bNTaLv/ntDdidL1VmsCvYQzFCBBtcBM=
Received: from compass-pc.sustech.edu.cn ([116.7.234.240])
	by newxmesmtplogicsvrszc43-0.qq.com (NewEsmtp) with SMTP
	id 2560E84B; Fri, 12 Dec 2025 15:09:22 +0800
X-QQ-mid: xmsmtpt1765523362t466ehdmn
Message-ID: <tencent_DAB2E2BC61A449B6AC4FA9798C4D75BED705@qq.com>
X-QQ-XMAILINFO: NnYhxYSyuBnLxXPBpZ5nZNUa9x5wz+dRk4u0AaFol8ukPFP689jVoMyjEm2vvJ
	 V6mx1LEYOQiDURQXLw1Bkj70LKG6zwchaMcO+4p0OIZ12PxCUyAYY34YAR3Z8B8EK+seJ9abwnpg
	 5AGOeL3gayd4w/wokklye+RtSXV0WV2akmYxfUCpLFKLkDyIIUgO68VdzFQF+AGDr7a/ye3bz5NI
	 vU3Arw4OxLInPi6H7TiqxE3gijqw02Ml8MOo/9w+wlKsQRqtNqyY8DLQgFuzIF569aDrpLgYTwuP
	 PDZ7N9AQ3n8uqAeCeL1Dh77DoFpxhdHbwwoOjYIjtL3NSm0lZ68Gk8xR4rBnTvtF9XRVEOfwzguV
	 i0dEzugQMhjQHQxqUbMN24c96ozxlrHngXehRGGpFkIw3yYGcQ3yiLF2+q/XLpEGwHLujRQ8bpvw
	 otVCe3eYnMkhavpY9I0XvsG7d4vabfz1Yz0QM0en/pdTSsYx2YmUA8VM0vnK0opa2FpShEIrxEQ8
	 Gj8+PJiEB1OSiEPRTvr3j1BB9nzjlDdKs8emy58aEn0xnWmGSA43LgnMgl5ffCAuewm5tQzl2WAN
	 dA+uWkWrm+jdrpjJhj43QKstExbyShJ/MBlgWO1faHItv507AWyJecobAlVYglLPdU17fBqmto8T
	 0avQU2IE0BM4x/V5Mt6DYlWTL6BazcC6Hx5DFnvT9DlnJ9TG+1/Zhgh3alkZSaab7xCv9L/biGsJ
	 On5sUiH7+zh3nZe36HGLRKH7t+bFwjv02qEZJ5chLEnROeqHEIhGUIlFYttDCwAJDRq6PkwOtCZQ
	 kSxpSZkdrL3KYnyG14EXYtFxQBobUTsXRaHO3N3sD8mtRO7htinOn4sIiW8patb1cgJt11yFZdAq
	 iutExiRISz9gfWsq0SfbTcIV/l07VTin7vZbeQiYo+p4jLM/I0H6ynLpOPOhRbUZAS4zST1FqWpa
	 PtAe5Qt0ER4u7lTCNwjjK1QQhWL/PqbC4hWcF2NIqq/sPxcGA9nDO0TJNhT4Q3OITewGvE77wb2i
	 890X8j3uZz/8rDy4ACnerPq/6U5BU=
X-QQ-XMRINFO: OWPUhxQsoeAVDbp3OJHYyFg=
From: Yankai Xu <815559068@qq.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	akpm@linux-foundation.org,
	Yankai Xu <815559068@qq.com>
Subject: [PATCH v2] mm/gfp: cast GFP_ZONE_TABLE entries to long to avoid shift overflow
Date: Fri, 12 Dec 2025 15:09:16 +0800
X-OQ-MSGID: <20251212070916.1352555-1-815559068@qq.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9B0E740006
X-Stat-Signature: mq4tuypnufkey7e4ibm6oz9chzisp7zu
X-HE-Tag: 1765523368-309958
X-HE-Meta: U2FsdGVkX1+ovUR1eAmSupC58pqW5Rs9/AOafdADhnwxnM6N7nOlrsOkGHbKygisslkdiUuHDt/N3DK1qt+AvM+r2j/285y99giprKlFqDpeH02jlIG0qYzk1ozSESdf45kh7mgtFFy+X2uszrB8gIInSLc4Zc1mCEJ4hG0caElDoyb997BdKQMsrrItlmlAitsvCao5o6SBkowGapgEFNWE943vUkb+m49ceuXGagY4TemDBxgUiQeN08Fp1QqWgBBa4Yj1rOt5UkQQPeYZMc3ngDpHVicYjw2M8QvNgJJLrA17BJitR7HSdZRhtTmb3tlyRtzST20MAeFm2sy1cEEM2VYpOpLwQHqaqHGAOlz13BFA79ChNAato6OfTZEMgJCbh9zfPxhM8IYLRykdQA0sREhWqvX9V5Gj9zYBUS2JWTx2aBN1Wz/EX6zozIBHlReBAfq5uZPL7Ed+LtKoFK2yRLW6wdnWHxPL20vGc1hFBxDk9hx7oZAfSobeBLgdDtf9Qg7uJWZaKTZFwQb2R2vrPZPDFismgpVQ3fXT71MwKYkNY+CPszKIbEe3yMSpn5ASHZkr19V6xwvULfWcdQFwPzPNZ3W7GnUjwatKIiqHkOpHnJmufQRzWODBD0zZgH4a38q13Nqajh6rN8WGllMQ7YQ6Fs4hVHamwAOg//bkxzebUBovHXuk9LL7TF+coyeddOPEumZtBF8+BneGExMdNOmDUKYSaz8hN+sJOQ8dDJUehrGwXas7X6nuX/JGwur90TeluWG4fKzeiLCRZrncgWpq7O5a9mQS12q8zPEd9LzKkZJaHg7LNAZTxaTD2AUqYzh7NpoJIN0z2Zr5/VYd72F2zLCLW6dpe4bZcpQb/jOWv0qU4nu7kr7eR7/KjsUIegiWwMVG8+IktS12wwDgfEAgoQIXOqSmWVbu2oTqUcPl6u3BRF34cOgN/BQzp9YH9gyqOsd3QElQYyV
 +oiMb8AF
 YF7yEXIsbaS3LR1f3y9XH3FCefSKCZa3RnO+SOwfmyOcnKvgmIbe7B17iMAU8lRdz0IBqdruCaHVYv+wNMkphdUtHN6AW1OVEFNgFVf0Iy/H0a1Qf9Lx6ZVAlL7xppuFE0FuNJYpLrxK/ZzQ3aE3VdglX7ePMoR+az2fAQhPkINhtXqRBjvKtld6oSS59su1wcA6vKGFVhPc2G4WanaxRb8Hcec/cEiq0KAqNEGHkVsdQMmYEubnmHSpbAWURGs4HesZPzEotyPk1M1xLuAeBMNkdpYw0DCySijOxb6GxNgYUaJ4bcjN9WqGxU6+qC3diIOo7wfAAWJ/P2W1JOurAX+38jDG7aec3B3jrAbzrUrpvDeb3/CmZ7u9eW7vGThWzWOjC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When a new zone is added to enum zone_type in mmzone.h, the existing
GFP_ZONE_TABLE macro causes a compile-time shift overflow:

  CC      arch/x86/kernel/asm-offsets.s
  In file included from ./include/linux/slab.h:16,
                   from ./include/linux/crypto.h:18,
                   from arch/x86/kernel/asm-offsets.c:9:
  ./include/linux/gfp.h: In function ‘gfp_zone’:
  ./include/linux/gfp.h:132:27: error: left shift count >= width of type [-Werror=shift-count-overflow]
    132 |         | (OPT_ZONE_DMA32 << (___GFP_MOVABLE | ___GFP_DMA32) * GFP_ZONES_SHIFT)\
        |                           ^~
  ./include/linux/gfp.h:157:14: note: in expansion of macro ‘GFP_ZONE_TABLE’
    157 |         z = (GFP_ZONE_TABLE >> (bit * GFP_ZONES_SHIFT)) &
        |

This can be reproduced by adding a new zone:

@@ -868,6 +868,7 @@ enum zone_type {
 #ifdef CONFIG_ZONE_DEVICE
        ZONE_DEVICE,
 #endif
+       ZONE_FOO,
        __MAX_NR_ZONES

 };

This happens because the left-hand side operands of the shifts inside GFP_ZONE_TABLE are enum zone_type, which is of type int. The shift is logically valid because it has been checked by 16 * GFP_ZONES_SHIFT > BITS_PER_LONG previously.

Fixed this by casting each value in GFP_ZONE_TABLE to type long.

Signed-off-by: Yankai Xu <815559068@qq.com>
---
v2:
  - Added compiler warning messages and reproduce steps
---
 include/linux/gfp.h | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index b155929af..e694f3103 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -122,14 +122,14 @@ static inline bool gfpflags_allow_spinning(const gfp_t gfp_flags)
 #endif

 #define GFP_ZONE_TABLE ( \
-	(ZONE_NORMAL << 0 * GFP_ZONES_SHIFT)				       \
-	| (OPT_ZONE_DMA << ___GFP_DMA * GFP_ZONES_SHIFT)		       \
-	| (OPT_ZONE_HIGHMEM << ___GFP_HIGHMEM * GFP_ZONES_SHIFT)	       \
-	| (OPT_ZONE_DMA32 << ___GFP_DMA32 * GFP_ZONES_SHIFT)		       \
-	| (ZONE_NORMAL << ___GFP_MOVABLE * GFP_ZONES_SHIFT)		       \
-	| (OPT_ZONE_DMA << (___GFP_MOVABLE | ___GFP_DMA) * GFP_ZONES_SHIFT)    \
-	| (ZONE_MOVABLE << (___GFP_MOVABLE | ___GFP_HIGHMEM) * GFP_ZONES_SHIFT)\
-	| (OPT_ZONE_DMA32 << (___GFP_MOVABLE | ___GFP_DMA32) * GFP_ZONES_SHIFT)\
+	((long)ZONE_NORMAL << 0 * GFP_ZONES_SHIFT)				     \
+	| ((long)OPT_ZONE_DMA << ___GFP_DMA * GFP_ZONES_SHIFT)			     \
+	| ((long)OPT_ZONE_HIGHMEM << ___GFP_HIGHMEM * GFP_ZONES_SHIFT)		     \
+	| ((long)OPT_ZONE_DMA32 << ___GFP_DMA32 * GFP_ZONES_SHIFT)		     \
+	| ((long)ZONE_NORMAL << ___GFP_MOVABLE * GFP_ZONES_SHIFT)		     \
+	| ((long)OPT_ZONE_DMA << (___GFP_MOVABLE | ___GFP_DMA) * GFP_ZONES_SHIFT)    \
+	| ((long)ZONE_MOVABLE << (___GFP_MOVABLE | ___GFP_HIGHMEM) * GFP_ZONES_SHIFT)\
+	| ((long)OPT_ZONE_DMA32 << (___GFP_MOVABLE | ___GFP_DMA32) * GFP_ZONES_SHIFT)\
 )

 /*
--
2.43.0


