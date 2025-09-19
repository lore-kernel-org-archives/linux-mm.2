Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2A02CA1013
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 05:43:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D74028003A; Fri, 19 Sep 2025 01:43:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4864A28000F; Fri, 19 Sep 2025 01:43:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39CDF28003A; Fri, 19 Sep 2025 01:43:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 290E628000F
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 01:43:04 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D4C7159736
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 05:43:03 +0000 (UTC)
X-FDA: 83904906246.13.5D1DB68
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	by imf05.hostedemail.com (Postfix) with ESMTP id A3E39100005
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 05:43:01 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=jyG5ydIX;
	spf=none (imf05.hostedemail.com: domain of baolu.lu@linux.intel.com has no SPF policy when checking 192.198.163.13) smtp.mailfrom=baolu.lu@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758260581;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rmv1DtnUwb06MWtIdjR5kp7dRgrn2e05y3KdJBfiyM0=;
	b=ek1s+rj37qh+L38gye33loqqj/TNZfacgYLhYngu/PWF5zpYN3krPJIuoNfH8ykLsYF/Ng
	7ylLFXP82BpUsR9m+6CIU+ZLmw4g4vYOwy8eqRoZqS4+QPlZLJ5gTTJmpKkQAMY9iHSE1P
	QvFFwl4UYzOAmM5pYzCnT0mSw8RjyrI=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=jyG5ydIX;
	spf=none (imf05.hostedemail.com: domain of baolu.lu@linux.intel.com has no SPF policy when checking 192.198.163.13) smtp.mailfrom=baolu.lu@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758260581; a=rsa-sha256;
	cv=none;
	b=aJEMo7pjEYGEXkJiKuFysUHxVGVlb9yJv6o4Rvq8dhgp2AmycLIxjkQNibTwUJNb4umhhe
	gQBHOv1lYeq9gKzyNzmVO+hiW+0BbfFyI6eg2kYCQhEqL6x79JyaK7gAbANW+xQGZ9p/Bg
	upyX6X/rG5bcrT+4S+taizk40RE7CkM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758260582; x=1789796582;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=nrilrx2mPA3TWSSuztVQs7qAYj2QPgzZaCIBERNxtEw=;
  b=jyG5ydIXexyg+wkl/hak0AY4KnHY9hoOfNs31I7PHvfvVJtq43ou+Icp
   OX1gFUUWXG0+v2iZbekUc6R8oVbr9PX22kWi77F0dpwBbxawNziwt92Qr
   Thsvyfg0MHpPVNA2JgbkpFNTS5D0na79wj88dzaO7bRUxCFEB+kFiE7uU
   oQMAscFT16pCyBypVidW5CriL4uEhr2DyVexcPo+852BfRtXWCyCzfwqq
   mhak8SUEA0MixuzK/AIXf2pZ5NOhbf6W/Ek/ojUUUvEj197Hi3raqJlI9
   6sQTgsreuUMnRKKslwaghLSQ9LISksruSYDoParoCi5shMIowGtudfd8O
   Q==;
X-CSE-ConnectionGUID: BpxsdRqzRYGdH5TivsgWbQ==
X-CSE-MsgGUID: FGUrPuUuREmm66csLxfgWg==
X-IronPort-AV: E=McAfee;i="6800,10657,11557"; a="63235813"
X-IronPort-AV: E=Sophos;i="6.18,277,1751266800"; 
   d="scan'208";a="63235813"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2025 22:43:01 -0700
X-CSE-ConnectionGUID: 8Qvwh1+/T8iwkFdtVSsN2A==
X-CSE-MsgGUID: wx26YAthRpau1H2H4cvuHA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,277,1751266800"; 
   d="scan'208";a="180858706"
Received: from allen-box.sh.intel.com ([10.239.159.52])
  by orviesa005.jf.intel.com with ESMTP; 18 Sep 2025 22:42:55 -0700
From: Lu Baolu <baolu.lu@linux.intel.com>
To: Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Jann Horn <jannh@google.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@intel.com>,
	Alistair Popple <apopple@nvidia.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Andy Lutomirski <luto@kernel.org>,
	Yi Lai <yi1.lai@intel.com>
Cc: iommu@lists.linux.dev,
	security@kernel.org,
	x86@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Lu Baolu <baolu.lu@linux.intel.com>
Subject: [PATCH v5 5/8] x86/mm: Use pagetable_free()
Date: Fri, 19 Sep 2025 13:40:03 +0800
Message-ID: <20250919054007.472493-6-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250919054007.472493-1-baolu.lu@linux.intel.com>
References: <20250919054007.472493-1-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A3E39100005
X-Rspamd-Server: rspam05
X-Stat-Signature: o49mtnnipnxsxz4cze3kf1oizjrg4j9o
X-Rspam-User: 
X-HE-Tag: 1758260581-605118
X-HE-Meta: U2FsdGVkX1+pMn/qzzn9RUyfpwUl8OjOZaRe+MqNENZJLwhlJi9wIUbt5d+NPPOdnasXrMu4HCjC++3I6UmI8fJNxh/VBDywDeKiCQgqBEa2VuplI3xpnj3DsMPNgMoLxRrtRGVyyZQz/GGKbiCsjkHl6tDhBUeN8A3Y3IH0BXc8q2yYucCRpizqt6ztU6TeCa4SbirkrI2bfYcq1dxuox3wtnUsVJ2hDm8oZ4HmQWhc772OZuGFnFqYq1mvgjbc1AEDun7pd9Y017t80a1tWugQXKabXJJ/d+t6Qt9susiANe6RrI8IW6kBdAr7uxJK2RY81BhQmS59Epk4nPX3QKhuO2ZxA5OEKYvbBetEXH187Yk6vPI6/1yOQEtqjRqM7ioThHUHEsJKdAOL+HC9cPWncRnlM/o6NkV0nD8k8jMrymKlJXWohpIwnxC4Xreave7EHLkzDoyIM9GZs2aSN0W70i1ZoHAM85CZWN2nb0ju28JUWiqZQFdPMqEyr1EABY4UpAIlTEhACckVXJSjkQWLmmdKA8bj6izOZzP49vKw81jSVjhvz0ZKoKwzbc+8Xwpqhkw98BVoZeX1Xvw2wRhQ/4mR0f0kvXST2HXYoOQ3aWJOQSDoWOSNngxyngfgh6W4wGYHUL1ss2bKXqkjTJaERAmgKGAsA3LKqxMF5gk2TXYxiB84TzWucHyKmnDVT8E8LEBLvrqrpJ2bGSGSveLF1SzZuWO0oj9f0FGdIcG7J4ajQGZQqnxYtflGmHTfR2iNz10gep24vf2YpwYVv1nBvETGvFzI1E+rNsIH41ir2i1aGNJKBqTjiGNSirXvcHv1fLl/JVJxSJfZExU+IVsM740TNxyenTmWoPzS/7XNtkIOICdU3G/Omu7WVFPKK2AYVUj3GAs35BM4Y9mDvgPdU1FJEo5mnUj94X24OuQs8/OYtpmyuQZ9T1et7uPCElYk8I9UWfQt2ZwHy19
 Sx6Z4C1g
 9Edd50AUp974I/xT6uoFJDkSDwYBXPUo07pgEPvqFDYh84dRrE23L+SETh7PFz9ZPgp6j+coBFiX1KTl0KBVywIkGqs+D8MSbP+wzHYnI+/5a1rTlr1xHuUX+S/mtjApCj3C7Y5A98//xY55DiCrad6ZE4LTGCqj8yQ3N3krLEiklsJd7H28BfrAC0GyNUyITlIuBAiOHDx2XrtenFqNr/R5f6Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The kernel's memory management subsystem provides a dedicated interface,
pagetable_free(), for freeing page table pages. Updates two call sites to
use pagetable_free() instead of the lower-level __free_page() or
free_pages(). This improves code consistency and clarity, and ensures the
correct freeing mechanism is used.

Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
---
 arch/x86/mm/init_64.c        | 2 +-
 arch/x86/mm/pat/set_memory.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index b9426fce5f3e..3d9a5e4ccaa4 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -1031,7 +1031,7 @@ static void __meminit free_pagetable(struct page *page, int order)
 		free_reserved_pages(page, nr_pages);
 #endif
 	} else {
-		free_pages((unsigned long)page_address(page), order);
+		pagetable_free(page_ptdesc(page));
 	}
 }
 
diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index 8834c76f91c9..8b78a8855024 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -438,7 +438,7 @@ static void cpa_collapse_large_pages(struct cpa_data *cpa)
 
 	list_for_each_entry_safe(ptdesc, tmp, &pgtables, pt_list) {
 		list_del(&ptdesc->pt_list);
-		__free_page(ptdesc_page(ptdesc));
+		pagetable_free(ptdesc);
 	}
 }
 
-- 
2.43.0


