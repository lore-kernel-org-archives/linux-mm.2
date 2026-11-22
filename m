Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91B9B60A261C
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 18:45:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=n5cr2gsW
Received: by kanga.kvack.org (Postfix)
	id BBAF56B05B9; Sun, 22 Nov 2026 13:45:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B6BB36B05BA; Sun, 22 Nov 2026 13:45:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A34616B05BB; Sun, 22 Nov 2026 13:45:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6A2D56B05B9
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 13:45:08 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E43FF1C413E
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 18:45:07 +0000 (UTC)
X-FDA: 85463632254.07.3F92FF9
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	by imf01.hostedemail.com (Postfix) with ESMTP id 33C864000A
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 18:45:06 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=n5cr2gsW;
	spf=pass (imf01.hostedemail.com: domain of 3MDgDawoKCA0w6u17tu610t11tyr.p1zyv07A-zzx8npx.14t@flex--jthoughton.bounces.google.com designates 209.85.214.200 as permitted sender) smtp.mailfrom=3MDgDawoKCA0w6u17tu610t11tyr.p1zyv07A-zzx8npx.14t@flex--jthoughton.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795373106;
	b=k06dds1ZkCE+EpF3WnaJTataJt8FIWBTi3p3PVAFBpH4xO3s4JNuIQweQUZrd5Mr4aTZmR
	DgotxXXBCbEM4bYM1ZwZ701vVs7UZ5upqu+VNgFfzt3+yUJoZW30jOmjJ08m4dcBFgIOSS
	4pX17nBqd0HRz3+AsNPuYE5gxeSXBoY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795373106;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mkVu1BZEh13paTDpck3U+A16xbW48tKn8diy4BeXyyI=;
	b=Fr+1UzKnt7QVCgsj1mYtuInWXf0Kw8oXPZ69Rcos1Cq5dk0p6ArsEiOYwaW2k9JZGGAT+o
	i9ps51OZiJbivc5DSPdF/RsVBW8lMjbo0+NzPH4oSD0JOuuQjcH93ATgQmNICSYWTs3Hal
	QlDC9wSwgMCMTZkKzsIIK6gRCUQPN08=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=n5cr2gsW;
	spf=pass (imf01.hostedemail.com: domain of 3MDgDawoKCA0w6u17tu610t11tyr.p1zyv07A-zzx8npx.14t@flex--jthoughton.bounces.google.com designates 209.85.214.200 as permitted sender) smtp.mailfrom=3MDgDawoKCA0w6u17tu610t11tyr.p1zyv07A-zzx8npx.14t@flex--jthoughton.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2f053f95aadso18895845ad.2
        for <linux-mm@kvack.org>; Sun, 22 Nov 2026 10:45:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795373105; x=1795977905; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mkVu1BZEh13paTDpck3U+A16xbW48tKn8diy4BeXyyI=;
        b=n5cr2gsW6/HUndXpcmPtOBWYhYJ9oSnHhEP7CtJcBGHhhV+IUXc7CL/vE9d9/iCprq
         VdRMcIQwxQsoodeMMeWC9OZ1KUKnsCkF6HmUyb2Wi+nhM5uvRmj2IbO3LjKNJ99dmMlX
         uzbQSOT8k0gtf4Jjw+/2rAWrlMaBPkER2jj6aVzNznxoCM0178/7+RxZe3JL3wvrmeui
         18m4SyF61YHv1sw30/wK/M3hZlPp64VMUbXSnApkiaLWRoBxvGfOGuNfbs+jBPl7ZnV5
         wTX9K7kcCwT5v/d9l5ZD1H5RpoGWrI2RNWaw4xRsOHPrrVzn05QoLloakw8JHA0UWWbS
         V5xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795373105; x=1795977905;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mkVu1BZEh13paTDpck3U+A16xbW48tKn8diy4BeXyyI=;
        b=k2cKNtsUSebGpxRnfTD6y5Mv6uT2rG0Kn7BfBclDV9qGx/xkJm3SwWpoAkLsLt4qNz
         ByY0AQqV9YW5YuiPJI07r2ejZGm+tqahBsjsAKHeWa/eCZHifs+eNB1Cpz8zZzY3ADb7
         BDfYzdGXCEJ5sqSO5nl29GgiQxsIWFpXJGtIGFQJxOuY6qqXPi3XzV8jxCDLQ/xmBAAt
         YjFrertE9UQ3mk3tVrBY3MK2PuVg6UeArwbTYgDJ6TIu0N9zP2fX4U6d/hO0ccj+bnrt
         3tj2pLgOaNa9KNf9eAjTZ5HZTSE9255yFcN6t6X445erTNS4dIH6TWg9gXFZS9gGUnpq
         kH2w==
X-Forwarded-Encrypted: i=1; AL+hErEbNZx+zWy4xJPsIOe9ls2EIvsU3wo6bE6Z8rN6ObI2h/i1/VjegGVpQm0Qrt/BtvJMpoYKJ7RMZQ==@kvack.org
X-Gm-Message-State: APuU4Z/TQNigrArAiExgWAAH/J313tLzJSAonzdP31EuktNzUbiRz3xq
	STQJe6bEI45slfWF+hL/TuaFWr84ntW0Eeqiz21d+vNCArwi3QvPfRz3CKBhZpofFltbBQZLJ35
	jBuH5YBm8x3thtGoZDD73ew==
X-Received: from plbz4.prod.google.com ([2002:a17:902:ee04:b0:2ef:d472:e87e])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:e80b:b0:2ed:ef1:f78 with SMTP id d9443c01a7336-2f03f11824amr92864975ad.21.1795373104623;
 Sun, 22 Nov 2026 10:45:04 -0800 (PST)
Date: Sun, 22 Nov 2026 18:44:39 +0000
In-Reply-To: <20261122184453.2668189-1-jthoughton@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261122184453.2668189-1-jthoughton@google.com>
X-Mailer: git-send-email 2.56.1.809.ga0b61035b5-goog
Message-ID: <20261122184453.2668189-6-jthoughton@google.com>
Subject: [PATCH v3 05/19] hugetlb_vmemmap: Allow architectures to dynamically
 disallow HVO
From: James Houghton <jthoughton@google.com>
To: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Andrew Morton <akpm@linux-foundation.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>, Nikos Nikoleris <nikos.nikoleris@arm.com>, 
	Linu Cherian <linu.cherian@arm.com>, Mark Rutland <mark.rutland@arm.com>, 
	David Hildenbrand <david@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>, 
	Nanyong Sun <sunnanyong@huawei.com>, Yu Zhao <yuzhao@google.com>, 
	Frank van der Linden <fvdl@google.com>, David Rientjes <rientjes@google.com>, 
	James Houghton <jthoughton@google.com>, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User:
X-Rspamd-Queue-Id: 33C864000A
X-Stat-Signature: rn1mky3opiwismuicpypjgtchmqd4joo
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795373106-68463
X-HE-Meta: U2FsdGVkX18BQM0JzFcigbyC2Y7MxkCFakxHocVgt/6OaYZhybTXdB7ExzJO+w3r+AUGjjE+hc2dHQG7M8mXdUO670nWruaH0EkT6b9ad4DRbOW8cZLqN04PNYq3MIAuYfeJBvsBOBXNKRfCyZrHnI5UymwPPicM60V2yg0SgkYt690zV4vtQc6pafmSGiiFfcPAoEtZdqxEOEOKMalmBIIujRAx7OfRm+3JdFPGYh+qH0FewaBt047X8GPMSYpex24iwEC4/uZIkQ8zD90Pz8pVlzoyegQhn+aPIxsturBcXZB7Bmj480rt7oFDCZlhWX7NjrFAyqMGX3zYle0vmiVrZC25xZyA0ISjq7PaHWGl59awy9vVEBiVSlDiO59urclTckBNYYW35WvVMDnJj3doKejSiLLY+J1vImY2nUka1P4cZ6lcXuf7U4C0uVx7jHTumxoD8JI9/rKy3vjh0Qt3R88QrrrS1fNlBJ0VPghDtuuTqExCfBgzlZ/VyvqJ7tKnF+bTSPmPQhUNigxv7UjXgNYo8ET7lMTLoby0annYS3E922CJrAyxsIGUyQ0cjBBP2r/TrDh8kWUuE/pRH2Q24pDhM2YnGA+Avga1cYnSkHaisrj+MxfaY4F3w39alcIMKBfSYpe0G419CB7L2GoSjXYDW7Rnc7u4P5fsppATuMR6+vNcO4Cc33HN6lE5bJBvK3XaGAREnlrR66R6YJY+U0sqCNfSNNrXIzFnfelhY7rhODSOYW8N4YKzgaZPsKxMrANNexeQqbn8/Zs18lktaoBemtWLtJ5JOw2OeYVGM4S5spplEz46uXIFjir/oaE/cqo+hg03l5uW3QAJJAlIXz5sX8Pf/ir8VlE9E5J1JL5DK+FVT8aFtuPTFNflJh+HNzIiNUAoUWuWiRUwmaEz+TJ1WRz0eyuDw4IPru1X76/VM2TL5n/spk7wh2W82AxAiorlT9NyUW6bj4R
 iUHrilmT
 SkgS1R0PRKxh7xyQVn+SZQdi6+EjKYkxAV+ZIBLcqCsMiQG7wCXqvHLvbQfNyT7U+PHspJK154WhYbaflkyNLT9x40lrGLssarySv89VPenaXHvknTi6HKfmIhNiJXvpE61WAQrWjl8t5pEH873CIYNz1+3RamojtUdAaTos6BxRDhbzipEhnNpzpoerWnU4agpWXNHG2Rlx4KfCrJw3KzzNm2R4gi6+qYfXfDNqkWOCDvQsUoxdBiXallb2fKOznXSEdaba+Lfd1maPBAxHn3kDPNp9aL72jP30+Shg5O6FcbLC2vFv3Y5guEsmHz+cGe1xXYpeth9+u/keRJWIjMIIzU47pEQ0POjPZgUaffX5wixOzoeeOP045xXx0jMBf+RGuB0y2I7abbQc23dFSw/MiULNPLcQLq/GUkNnPJuVtZ/x1BoTfDcXdl8AIwx4L3Rh61MHo7OlgTyk9ZgXmIcttJYSsxXkniEj/tLuqYjCa1259TFUIRVDk34+0PGfBRQyLM7dPWfDX9qCOYwJ3tHyvrS53Fw/esIo4KcG3tNC4ftYEM7vZooA5AIAtyyrrb7vpEhFzVpR5pFvbiP2ORDE9o2b9qoTPxFrUTRPVnCEgP4ghrwq61eH9AgX/1JPqQhSvk0lugJnhCaOGUIh0daQaqgTl3txylzwu137Z5oA3UIXjkmI7HPy3qmJxjqE3nqDt1Oz6R55ULt48tJ6/9nC5FORvK5ESb+4TaDrxFo45/JcOMY6QrdKEA4aZQy3mDYg9H6O7++xxvCzqgnIDVz17PtKxbOSrQ9DWgVH6S89XWpozo0opQ1JidFdOodcngp0qfzk2k/kAJU8T9BOJeQjQktxAYi/6OXVp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

For arm64, only some platforms support HVO. Add an arch hook,
arch_support_vmemmap_remap(), to prevent HVO from taking effect if the
architecture lacks support. The hook is not HugeTLB-specific, so it can
also be used by other users of in-place vmemmap remapping (e.g. FS-DAX).

Check it in hugetlb_vmemmap_optimizable_size(), so that hstates are not
reported or treated as optimizable (e.g. by report_hugepages() and the
HugeTLB allocation and freeing paths) when the architecture does not
support HVO.

It may be the case that arch_support_vmemmap_remap() returns false at
first but eventually returns true. This is the case on arm64, where
support depends on a system-wide CPU capability that is not yet known
when bootmem hugepages are allocated. Such architectures cannot pre-HVO
bootmem hugepages, so they must disable the section-based vmemmap
optimization in their vmemmap population path with
section_vmemmap_optimization_disable(). Their bootmem hugepages are then
optimized when they are gathered instead.

Signed-off-by: James Houghton <jthoughton@google.com>
---
 include/linux/pgtable.h | 15 +++++++++++++++
 mm/hugetlb_vmemmap.h    |  2 ++
 2 files changed, 17 insertions(+)

diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index ab33df268955..8cf44120e2ed 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -480,6 +480,21 @@ static inline int try_update_vmemmap_pte(unsigned long addr, pte_t *ptep,
 }
 #endif
 
+#ifndef arch_support_vmemmap_remap
+/*
+ * arch_support_vmemmap_remap - Whether in-use vmemmap mappings may be remapped.
+ *
+ * Vmemmap optimizations, such as the HugeTLB vmemmap optimization (HVO),
+ * remap vmemmap page table entries while they are in use. Architectures that
+ * can only do this on some systems may override this hook. It may return false
+ * early during boot and true later, once system-wide features are known.
+ */
+static inline bool arch_support_vmemmap_remap(void)
+{
+	return IS_ENABLED(CONFIG_VMEMMAP_OPTIMIZATION);
+}
+#endif
+
 #ifndef __HAVE_ARCH_PTEP_SET_ACCESS_FLAGS
 extern int ptep_set_access_flags(struct vm_area_struct *vma,
 				 unsigned long address, pte_t *ptep,
diff --git a/mm/hugetlb_vmemmap.h b/mm/hugetlb_vmemmap.h
index 8b28063d78cc..440477288d19 100644
--- a/mm/hugetlb_vmemmap.h
+++ b/mm/hugetlb_vmemmap.h
@@ -48,6 +48,8 @@ static inline unsigned int hugetlb_vmemmap_optimizable_size(const struct hstate
 
 	if (!is_power_of_2(sizeof(struct page)))
 		return 0;
+	if (!arch_support_vmemmap_remap())
+		return 0;
 	return size > 0 ? size : 0;
 }
 #else
-- 
2.56.1.809.ga0b61035b5-goog


