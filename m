Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D23F6CA5FE3
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 00:21:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ABE186B00A2; Fri,  2 Oct 2026 20:21:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F9126B00A4; Fri,  2 Oct 2026 20:21:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 899706B00A5; Fri,  2 Oct 2026 20:21:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 623266B00A2
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 20:21:43 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DFDB0C08A4
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 00:21:42 +0000 (UTC)
X-FDA: 85279411644.19.5BF9A1D
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by imf28.hostedemail.com (Postfix) with ESMTP id 366DBC0007
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 00:21:41 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=YQ0iOxiC;
	spf=pass (imf28.hostedemail.com: domain of 3k0rAagoKCIYt3ry4qr3yxqyyqvo.mywvsx47-wwu5kmu.y1q@flex--jthoughton.bounces.google.com designates 209.85.214.199 as permitted sender) smtp.mailfrom=3k0rAagoKCIYt3ry4qr3yxqyyqvo.mywvsx47-wwu5kmu.y1q@flex--jthoughton.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790986901;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+0LSbObtLQixt10mRMgsu561+yH+1K8mdQenqKY5U4A=;
	b=ghEM2eIQzscCEysiDgidw4L5ncqeselnRe2WrzxwUgxIxwlKtkNcuTYywH3EcoqNLuB1V5
	+IehEfHoMZP+9B9O/lI3/2OA0QCbq+wXCH/M6XQyo8PDvVRiFJEvkBvcP8hgQ8+8gVkNIg
	g7N7mkbqEpZNv5UXvVkN7ZEPd4aQ4mw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790986901;
	b=K/gpfg0LEcCyYteQCED/onewpkDdBX82raUYcn1lAhAIdHmMiYfU3X5nlK7KbnKcVr99hP
	CjYVqD2IAiLL1ZLGpe4872kxuOTp8AQBMZQF3mY10UPHFrHaj5FJwL3R95lJ2IYfAVCJgb
	+9ysR08KIpgPEEXMiQF8oIv8HgWoKKs=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=YQ0iOxiC;
	spf=pass (imf28.hostedemail.com: domain of 3k0rAagoKCIYt3ry4qr3yxqyyqvo.mywvsx47-wwu5kmu.y1q@flex--jthoughton.bounces.google.com designates 209.85.214.199 as permitted sender) smtp.mailfrom=3k0rAagoKCIYt3ry4qr3yxqyyqvo.mywvsx47-wwu5kmu.y1q@flex--jthoughton.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2df375fb9b2so7165ad.2
        for <linux-mm@kvack.org>; Fri, 02 Oct 2026 17:21:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790986900; x=1791591700; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+0LSbObtLQixt10mRMgsu561+yH+1K8mdQenqKY5U4A=;
        b=YQ0iOxiCkLCKsAU1SGLW8kNgSOlGmS40a7hSTtFKoi2MIFqriWZnVLwonKSgCag2zo
         u8suMuHdfBCvCw1KJN7uU66eiTImCfVgYzltyX7hG6dGh1qPNcuaOYo1IaglfIIoVrOU
         eWz/6LtwVSQ8HYE7zeEYBXmVMywKc9Pqiqk+X3zPC18/t+2rTRxBnqimXdlg9U/PP2fX
         B2tPZKq/4ItoWrZNIGLd5x6K1cUe/Bb9/LJ6sCnSVvF9ixS7NW/sH1ud3oaSdImFSiM1
         vKxWV8Oa1jDklyWUDQHAHHciCuxpZ1L9Wc5/jMxH3I0B6XnSGdP6XoVpJKdmoecqKFuw
         jMGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790986900; x=1791591700;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+0LSbObtLQixt10mRMgsu561+yH+1K8mdQenqKY5U4A=;
        b=TjfL8SWKLyOa9vr35QY0LXM+DrE6i4gHhCLzDUp9YLbNW0ETu7Ug9LFmuJhKvqwMQJ
         3NT7hw5cCYPgfSZsuZnKL2lZILxPCrxjVDKQ7OHrvPJJo2jme/Dw4m082gVOXDvfxDL4
         ikP5oPMjbDYMkxOUQdWPCyq8GVNa09zq6MTFtruVJ5lLUmRj8QIGZlicR+7u8xI883ux
         gT/33UFLh0mJ9xl79T2X2v7G6w+434OrsDVdzevR2ZQVrsF6Xvxp8nhHMdIxRVWu4Jr/
         bvhJtb/Pncn2ktFYbLwr1v6DYMPjhtMKmAbvnHhau0US/SmrTUTPjVJjxYiHpVbky4Pz
         nzLg==
X-Forwarded-Encrypted: i=1; AKwUvByz1lBrmTxLIlaEqUtjHtGnHW6ONmdSojibH/6O03mN+6n50EEQqNBsHqOdD+59yMDC8UYqCQAQzw==@kvack.org
X-Gm-Message-State: AFq9FYIB/fBSLUb59GgrdWus77to6R6dCa/m2EDRtk8ocRjIFMPM0k+H
	3OJ2dQKVoutn/aMIgYaCuHG7SAx/Mn5uM7pwxUwERG2S9NEzeyLOJudZ68Go0Jrh8UtmSxa0BGk
	O9LqECASKdKo+04lkJHRCiw==
X-Received: from plev16.prod.google.com ([2002:a17:903:31d0:b0:2e2:c8c0:e8e2])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:e88c:b0:2df:ad58:cf54 with SMTP id d9443c01a7336-2e49b60b6c4mr40943675ad.34.1790986899505;
 Fri, 02 Oct 2026 17:21:39 -0700 (PDT)
Date: Sat,  3 Oct 2026 00:21:09 +0000
In-Reply-To: <20261003002123.505555-1-jthoughton@google.com>
Mime-Version: 1.0
References: <20261003002123.505555-1-jthoughton@google.com>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20261003002123.505555-7-jthoughton@google.com>
Subject: [PATCH v2 06/20] hugetlb_vmemmap: Allow architectures to dynamically
 disallow HVO
From: James Houghton <jthoughton@google.com>
To: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Andrew Morton <akpm@linux-foundation.org>
Cc: Nikos Nikoleris <nikos.nikoleris@arm.com>, Linu Cherian <linu.cherian@arm.com>, 
	Mark Rutland <mark.rutland@arm.com>, David Hildenbrand <david@kernel.org>, 
	Ryan Roberts <ryan.roberts@arm.com>, Nanyong Sun <sunnanyong@huawei.com>, 
	Yu Zhao <yuzhao@google.com>, Frank van der Linden <fvdl@google.com>, 
	David Rientjes <rientjes@google.com>, James Houghton <jthoughton@google.com>, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 366DBC0007
X-Stat-Signature: 7eixpeb64yxb6gk13y6hfe34waxqwozi
X-Rspam-User: 
X-HE-Tag: 1790986901-32311
X-HE-Meta: U2FsdGVkX18mwTIcBN0FOBA0yDZZyyyB9fFqX+1sAQT4x9lMZ2kvo3pUZJXq00pUPW7/pWwSFb4CA2aA2qns6cEyYWc65pS+5iCZpxlmdID+Jm2icUjZB+35jC/o/KEnrna4cn+7MRCEE4rxT1bchQZyHOWM9GSWvkzQ1R643DR6X3ALAVHtgmm2k1eWBpeUuT7Vp0NxpIEpqD+dliR+UBsLZNP8er9kWwt45pRHhH4wIjJEpdsSVB2Zl8/2V7tnkWrpetzcgMeYpvn2lzC02AgI12rjm/CDLw02zE5w1gx7sU0UT5IQyVeBLgNw4lGVpzBky0+WDju90b4D+89Zv8wWiHb8B++ftbYlD5ODBROW7bN04GgqKIJ1eRza8pRQJnY2lVASkzwHtWeh9DxMJuYJODyuhY+bOT6OELQthul3uTpwbLhvJLdpZx9W1UoiiufE6Y/+NqG/u5r0u9ahMCHBX8jHPgMtaQVbqyvUh6gSjgZx0HerBhKpcY9lx/PuXRzaLpLopKcdV0Fky6USCHMrR8v+BYHSMXFimq8Kd71H3sAbSRJAmNherp/Hl1pBWpyGkoT8VIxJCmxDza58ALmr72Q6IrDxhlVe8mVJa93Uud/Jef2WyJA82Pe/TgH/ygQW/oPl+ccHECfxNOGxN+D0KuNcNq0iLMdCQT+ZlOZuNuIkBdmvSlUX8fm8nekAIQuMzqxUxR6PjWJpcq3ED8hfOFw8dr+3otmi3EzkeEurbzLq89C/jM5t64iysJ9mow9qnzQDF0s/pm/jJRvARH6jvrJ3YnsBpxGMhja6r3saoDsPP24ur91Uux+cK6YZvgOBowvPlH29K9Ipk+NRzFrrNO1+tueJTAnyzVXgAXD3fMxFbxMtAJ8gz5InvY+Ex4MhySAovvtu+k2K+EbZvRa4ouzZO7510lG4k18tVesgTmcN968ieEj2Q7CfpCh1KQ3xCTRYzQLEw4l/uEb
 HfCJblk+
 FP1ct384wgEAqQFCDsAza75p6y1sP3PHeZAOm3jr7I/69+eBL2c5q6nkNKnzypigcdYlp+JpWlKDT7YNK4uOG8687zi3CHE1zQ5EnEX8MIPS05n5nw0+bpUcA8ywRRUnGnGZR7Fg+nByg6x1Mgh+2alobJ97XwHpSzpeRRhm/1NcnRxCq/RQGDbvXMZXbG9ojE5vsvi5J9AGjiU3tNsy1Z3YmiQBM6JwVgW5JGuy4MoF/zAWiIty6q4B0FJIcYqm6yb47UX4fXyq8XsgyuEbZwZWvQRuo1JVMcpV2ZwvkS6aWqZXIVVF8gSZiehy4Bezpw2TnPLigCaZIl5zh0R5/he3548rTyFzO+J2q6l0XQqf/swKYP1IED1kCCe9ril0o3LWyttdLNU6Zpnd6bqkOiMmB9ikcFj6yHETvCKqODZQ1vpny98RNqK1P6qbnUlmskBpSGqupmijyUFiIAQAnI2aYTqNKo6Q4I8q4buUA+r46AjU9YJ7kQzw+7FEEqb6fuUEo/yLBBqGYFQ6emUWoTI2KHsQMWQm2eVPQw2qA5P24Uw2BCtzf/Hi84ZHaZCpha/wybdRkj/XBufYKwZ9+swhTZBLLvPX8BaI10sC+E5pJlEbzubYUASFugGEqg5Zu4CBj/eyvUXqk/YK5izJJWYvXtQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For arm64, only some platforms support HVO. Add an arch hook to prevent
HVO from taking affect if the architecture lacks support.

It may be the case that arch_supports_hugetlb_vmemmap_optimization()
returns false at first but eventually returns true. This is the case on
arm64. When this happens, bootmem hugepages won't be immediately HVOed,
but they will be optimized in prep_and_add_bootmem_folios().

Signed-off-by: James Houghton <jthoughton@google.com>
---
 include/asm-generic/hugetlb.h |  7 +++++++
 mm/hugetlb_vmemmap.c          | 12 ++++++++++++
 2 files changed, 19 insertions(+)

diff --git a/include/asm-generic/hugetlb.h b/include/asm-generic/hugetlb.h
index 635c41cc3479..8d24075d53d4 100644
--- a/include/asm-generic/hugetlb.h
+++ b/include/asm-generic/hugetlb.h
@@ -128,4 +128,11 @@ static inline bool gigantic_page_runtime_supported(void)
 }
 #endif /* __HAVE_ARCH_GIGANTIC_PAGE_RUNTIME_SUPPORTED */
 
+#ifndef __HAVE_ARCH_HVO_SUPPORTED
+static inline bool arch_hugetlb_vmemmap_optimization_supported(void)
+{
+	return IS_ENABLED(CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP);
+}
+#endif /* __HAVE_ARCH_HVO_SUPPORTED */
+
 #endif /* _ASM_GENERIC_HUGETLB_H */
diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index 3fdb1e4ce1a1..8596a462fee6 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -16,6 +16,7 @@
 #include <linux/pagewalk.h>
 #include <linux/pgalloc.h>
 #include <linux/vmemmap-optimization.h>
+#include <linux/hugetlb.h>
 
 #include <asm/tlbflush.h>
 #include "hugetlb_vmemmap.h"
@@ -529,6 +530,9 @@ static bool vmemmap_should_optimize_folio(const struct hstate *h, struct folio *
 	if (!READ_ONCE(vmemmap_optimize_enabled))
 		return false;
 
+	if (!arch_hugetlb_vmemmap_optimization_supported())
+		return false;
+
 	if (!hugetlb_vmemmap_optimizable(h))
 		return false;
 
@@ -731,6 +735,14 @@ void __init hugetlb_vmemmap_optimize_bootmem_page(unsigned long pfn, unsigned in
 	if (!READ_ONCE(vmemmap_optimize_enabled))
 		return;
 
+	/*
+	 * Architectures may return false here but true by the time
+	 * hugetlb_init() is called. In this case, although the folios will
+	 * not be pre-HVOed, they will be optimized in hugetlb_init().
+	 */
+	if (!arch_hugetlb_vmemmap_optimization_supported())
+		return;
+
 	section_set_compound_order_range(pfn, 1UL << order, order);
 }
 
-- 
2.56.0.rc1.315.gc6ed9934b7-goog


