Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94243606A331
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 12:05:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EIiHA/jn
Received: by kanga.kvack.org (Postfix)
	id 7EC946B05BC; Mon,  9 Nov 2026 07:05:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 775086B05BD; Mon,  9 Nov 2026 07:05:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 68B296B05BE; Mon,  9 Nov 2026 07:05:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4736A6B05BC
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 07:05:27 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8904CA0692
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 12:05:26 +0000 (UTC)
X-FDA: 85415450652.01.0E31886
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id E1D0F40003
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 12:05:24 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="EIiHA/jn";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of jszhang@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jszhang@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794225925;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RuOhAvZnPjP1XPHFbitmFrHHdHIPhu/o1Rlh2k3boNo=;
	b=aPjNbmXA03ftD0lZHklULP7KylyFCPG8Vw0o1XCI3HcChcmSpftrkdB0aQDhS0g8sZJEpC
	imYhDuIfy7e0SZ9ZQ0LN0hb3JPeiZYQJ+mY0fnzWUza4Fpt2C3deeJyjTOoaNPZB7dJJYX
	YU9xMxjB5fkzTS7YsfHhdoGpvo1oTbU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794225925;
	b=a+CIzudDLaTHt95SnS7MEdEHWP47VMD3Ye2AGCMJuK5uRULO4InqgzwmXyMEtX+MTw6D5e
	uLLSh5VxepEEkL4r+viI9rBs/pwzQCbPwvadR1RQ0lbRAzcHtoBhdgxj4FuIiC8ZcV+8KA
	X+sB6zqMc1IOaTwkZ6WUNzNJiUH8Itk=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="EIiHA/jn";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of jszhang@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jszhang@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8168A63193;
	Mon,  9 Nov 2026 12:05:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9429B1F0089F;
	Mon,  9 Nov 2026 12:05:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794225924;
	bh=RuOhAvZnPjP1XPHFbitmFrHHdHIPhu/o1Rlh2k3boNo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EIiHA/jnHvo+Q4fpvT8AJOyb2hpOJY7Xo9vMny81pnTTP4xxoyuWC2gRSKz4nw+f7
	 vZuiWM6/9cL7w6O9dQjHrrvVLyWmsheXkoPwm9iiXuOETC0zQurR5JjE2S4z8ASP7e
	 rjU5+0PyNPxmONuxlmN+MbIrdWuSerwdAud1UIbuzvyn8mb50OOM8MPqN5eFkS+yrH
	 BPd+uz+qRkC3tHmfgoyj3amIn3bnNLznREzxXgOyE8HLPQwMrXaT7Cc8kEpaLoTAY4
	 z52qrphTGlnFIfOo54i5BRzjhKJFuLwz3foLVPpES4nlVrKmWlx/Naki/dR4qzP/ys
	 c5V6fWR8imoJw==
From: Jisheng Zhang <jszhang@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Alexander Potapenko <glider@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Tejun Heo <tj@kernel.org>,
	Dennis Zhou <dennis@kernel.org>,
	Christoph Lameter <cl@gentwo.org>
Cc: linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	kasan-dev@googlegroups.com,
	linux-mm@kvack.org
Subject: [PATCH v2 3/6] kasan: Always inline kasan_hw_tags_enabled()
Date: Mon,  9 Nov 2026 19:44:56 +0800
Message-ID: <20261109114500.20298-4-jszhang@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261109114500.20298-1-jszhang@kernel.org>
References: <20261109114500.20298-1-jszhang@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: huhmtch193dhfijghu8otrkqm5kmxobq
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E1D0F40003
X-HE-Tag: 1794225924-937559
X-HE-Meta: U2FsdGVkX1+6A5MqPo6f+ip/bbmX84KL3rgITb6qAEJe690ZPmRNqtpxNqIqLj8xeLExypZ+nxhay+ufTeyzM3D5vJ3c7ElFEvkpgKyQTd0s4OfvNaKYiy/7gR8x4oQ74auAR/RKr8foJ1lrm0K7XogaH/NpSBOGS+1bILLZfG6rmmrmAhi8RWfgskx2G7cz1mhRSurEHLOJFGK7+LJlYtqwPMH0nD+/+rTZTJjQIT+2TjzW2lh4jTRFiFP7biJ5ZGhetAn7LAr0lyexHke0Rzh/JcoGSckFys0fm/NCZoR8Po1rQMi8lFXhRhnN6F0kw4Abd6Qj3lAHYW+clmbQ95tkC6G8p2M36mXjwX9BE+5dednuPDax9vmA76XIxIDYYUKcbcplIptPWcwJzUzmuSkW/M9wRsnAfglBBmcGhSTlqRtp0d9XeRMsVeQLZDlO3n1jzYBZd4RHV8lt93C9uiqwTIojkDOMyE8g3IVJhNRllkzsv6Z8iXOQx/kdQ54d+7Sr2fWqAPZFssyORicmzSi3G4NPJPhkJrXwxIOxB4t7NCWVQWEWV3VDRfXIyrhHf1x4rsfnLF6tqy3RPkdT2319fU6ZHIyPTSGL5V2Y9SE1sZEAL4A4vVRJYmNm3266CRwCA++Y6n5iAtAKxJPs5dghtCT8EBPUPC6Abqyq9zMTnE48s5Duv108GMnu9uYeUPFLzaRmUFqzsU2TkUvNvFyyw84uYlXC8LYliG+bNYRJiUxp+2iFu3y8jCDJK874k0WywLRx8P36TNb8si/fAMZ/c8+Q4/EEHJcgDbLeCvOA293mkBWDys6c6uFl9HGt8nbqqoo7wnnhv/A/UkUn97VOBl7Dt8aczsl7cAtHtz6lB7dL95wn1OZLId5MBnsxUOcXiKFIp7w5B77coOdY54AtNpZ7oR1yNVeATJgqOrFfVVHo/BVo29ehylaPV3B6YgWA2iCUbZ0XTdka+5i
 6d/Nd+dj
 KIGJJHY1JEPeJGMnGUVUYqi70xd3XBc/5kaclhX3XTNGrZUDo4Z2OelYS+CD/SrBAI0qGxP6BNO51831c8mRA8z6lHvoagPO5XEg2QiR2oNobMC1EVTvDqsPUAxoYp96bFfJOyo0cfzOuE+9s51rzfIFk0DVuIYF2EXJfAOdPcjHMKzhVexLmyRdU7fmbd+uH+HosHD597AKuSzBvzyBX9jj62NVi5DMo3YV20bBW12Py8KLh3FcTKgf1rKhPmSeYN0bAFznRCtx/XWUF9h3Ruf4CIqXtW9c8PgRaItvmgwJATTaG+xUgwHseHZYuWO6i3EI9jT2YGdAIJES5Sr1Zw/EaeiYGoF4Oz1S9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The arm64 MTE entry and exit helpers call kasan_hw_tags_enabled()
from noinstr code. Although kasan_enabled() is __always_inline, its
wrapper kasan_hw_tags_enabled() uses plain inline.

With CONFIG_KASAN_HW_TAGS=y and CONFIG_CC_OPTIMIZE_FOR_SIZE=y, GCC
emits kasan_hw_tags_enabled() in .text and calls it from .noinstr.text.

Mark both definitions __always_inline so the runtime check inherits
its callers' instrumentation restrictions.

Verified that the out-of-line symbol and calls disappear from the
arm64 entry-common.o object after rebuilding.

Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
Assisted-by: LLM
---
 include/linux/kasan-enabled.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/kasan-enabled.h b/include/linux/kasan-enabled.h
index 9eca967d8526..14a9e9fd6c6b 100644
--- a/include/linux/kasan-enabled.h
+++ b/include/linux/kasan-enabled.h
@@ -35,12 +35,12 @@ static inline void kasan_enable(void) {}
 #endif /* CONFIG_ARCH_DEFER_KASAN || CONFIG_KASAN_HW_TAGS */
 
 #ifdef CONFIG_KASAN_HW_TAGS
-static inline bool kasan_hw_tags_enabled(void)
+static __always_inline bool kasan_hw_tags_enabled(void)
 {
 	return kasan_enabled();
 }
 #else
-static inline bool kasan_hw_tags_enabled(void)
+static __always_inline bool kasan_hw_tags_enabled(void)
 {
 	return false;
 }
-- 
2.55.0


