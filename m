Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71EBACA5FB1
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 11:22:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F5666B0098; Wed, 30 Sep 2026 07:22:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CC706B0099; Wed, 30 Sep 2026 07:22:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66D8A6B009B; Wed, 30 Sep 2026 07:22:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 38D976B0098
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 07:22:25 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A7D884077B
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 11:22:24 +0000 (UTC)
X-FDA: 85270190208.19.F3151BD
Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	by imf22.hostedemail.com (Postfix) with ESMTP id DD2B7C0003
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 11:22:22 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=j5UhW9XJ;
	dmarc=none;
	spf=pass (imf22.hostedemail.com: domain of gourry@gourry.net designates 74.125.225.141 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790767342;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PDIeJ2sMTLX9NIM+Zd+dtevwaUNh5Mn6tm+wOwUi9Q8=;
	b=HBSL5QA9hIZkaMiSlCVA4+RfnaojPxUfZQGg9Ejv8921QtHTvmEwREw/KlaxTQfWa1zb02
	ztuUgbhE7yfd5jY6vdRo6KaCUXvynXtgjK9GQ88siWVqIaGmkCBx2oYUPs4VmCBAH4ylE8
	iXLvpQLHh4agcZZZznSy4rbMOX79X0E=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=j5UhW9XJ;
	dmarc=none;
	spf=pass (imf22.hostedemail.com: domain of gourry@gourry.net designates 74.125.225.141 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790767342;
	b=Iq09HM0H4kAMDrrey2tVLoVVol+AlYaR18N+LxtUbnMmAdIHqTW7FqxTsrbQzS0weoLpdv
	hZ5ijD/DAoh73Ju5enfcm+daFs0BmwKC8lU85aYroWgY8BxEwTMC798zsUUFCwsvRHZRaj
	w85DVqTdcLY+LL3tH1ZmyZzLasi3Kbg=
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-49b912d3920so39114175e9.1
        for <linux-mm@kvack.org>; Wed, 30 Sep 2026 04:22:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1790767341; x=1791372141; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PDIeJ2sMTLX9NIM+Zd+dtevwaUNh5Mn6tm+wOwUi9Q8=;
        b=j5UhW9XJPX6I7MXLX8IfZ+Vm2Y3FxNvzExfUWUhPOhbFfBXMgOH6Y7md9/bjeKSh3J
         LWREh8DekUX8i0XnDbExUzCed+R7oHfsu940q782KzduoPgRHVibLIs0gUIz0pagpbND
         xzl/RL/Uy7yqgLb2vPbv0DZpl2p5KoEyK4Mnn8AAtxGRBUUn1EjKQGYW4NhrmVTW0Hj8
         FoiaKsbaJomv01j6tJmpFdsmZWhVALrwssS4swe+L3FPgBSYAsMhzzM4DAmZL1wUEJVx
         BtlQq4uKL1X23n05PKctjmt94+1TOE2rABuyG1XQd5zLK9tP7FbeyV707OVhRaWJ4reU
         UJmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790767342; x=1791372142;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=PDIeJ2sMTLX9NIM+Zd+dtevwaUNh5Mn6tm+wOwUi9Q8=;
        b=JgL4+ARoUntVpoY92eJkRmlSaEMHnLjZpKCSFCmkiE9FQOf8fmDSUavf6LWRxw19op
         q/vlCcvkBvhPvFKtA+VpgpWr6lMZ5v6LDZ/tL+xan36iLAcEqEBBDFqkEmcibV0c+xrT
         W/gAXLCqJ2Od9zBg8XRwxT4D3dHvFr/WKnNVmmudyQl4Q1Wgl3IO/J5dYL5Lkh2qCzBg
         M7mCLmwQnqH2ljX76V4IQwIqE+/q5zXV/H8CG1iFohCWNrXNUaEn9X1UZ1cXWlruKGVZ
         t5y4im6sr/ZpNFwWLZhAWCQFwfGltqe7zJCYpQoF2RVVJ5OQCDuHufdXfkq0STCWFo8O
         K9Ug==
X-Gm-Message-State: AFuF++kO1TTUh7AZn54Wmr3sOqqQ7NsZuLtJmFmZ6mzDwCkOR0wQ3Yju
	oWojH6+LmZrrzI1ndlZT2uZSl9OoxHx3yyL2dv2bH0D9a4SttVQtYpB0IPJgfvAQljddjjN8N5/
	6xZcpRDUIFA==
X-Gm-Gg: AYBFou15jpj+kWunpHyDeIQWLm3ssASMdi37qH83KGyWY9omQo0QDYijzM8vZojl0Se
	pvA6AV/eJX+//Eoj5xi6iGMScnBdy60O+/SXde73FaxiI9nUw02T4YyPyQ76JvrwZTYlObPXcri
	YwuZ1yy91sYBcCD56rdZZYSFdIvkfI0m2cZdMEGd7jmYXBvNszx+fBQ7+ljOgTFIT04UJA8Frtf
	GcWexDXSdKLJNbhSPHrt5/JspVNKgaLGcgC3Bb9O9l1aWikUPgRjg3sXkeFye0nzYDJpMsc55kY
	mUipJ4XUE6CxGKbbu6MxGfKGjyW7bi0ucLyXKPSgAU2IyvXFSkpGCKZk30sLudV3QwRFxAEPDLp
	xPVkeMzzHxk+2LOp9AEP2vJri3rItIg9mVN5I3WdcQk3IwxBU0ZjalvSk3RhqvIPV3KqPWruiT0
	g5za2rxjogxuVsoN6lj5w+qjwjJrZvyBMx2juwihbgbUg0mFkn6IVRkILokkxspoFNLIIYbIpe6
	f6xkmxDlc0SILXB
X-Received: by 2002:a05:600c:4714:b0:49f:fe88:e7d1 with SMTP id 5b1f17b1804b1-4a01affe8bdmr20455645e9.15.1790767341528;
        Wed, 30 Sep 2026 04:22:21 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.thefacebook.com ([2620:10d:c092:500::6:13b8])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a019740c34sm34097095e9.9.2026.09.30.04.22.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Sep 2026 04:22:20 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	mingo@redhat.com,
	peterz@infradead.org,
	juri.lelli@redhat.com,
	vincent.guittot@linaro.org,
	dietmar.eggemann@arm.com,
	rostedt@goodmis.org,
	bsegall@google.com,
	mgorman@suse.de,
	vschneid@redhat.com,
	kprateek.nayak@amd.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	kas@kernel.org,
	gourry@gourry.net,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	ying.huang@linux.alibaba.com,
	matthew.brost@intel.com,
	byungchul@sk.com,
	apopple@nvidia.com,
	jannh@google.com,
	pfalcato@suse.de,
	hannes@cmpxchg.org,
	shy828301@gmail.com,
	osalvador@suse.de,
	raghavendra.kt@amd.com
Subject: [PATCH v4 6/7] mm: use BIT() for change_protection() flags
Date: Wed, 30 Sep 2026 07:22:05 -0400
Message-ID: <20260930112206.205083-7-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930112206.205083-1-gourry@gourry.net>
References: <20260930112206.205083-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: msxrb6na4yatcqq6cu6jr6cy6zbtdb9c
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: DD2B7C0003
X-HE-Tag: 1790767342-301189
X-HE-Meta: U2FsdGVkX1+L6crLq2RyoMkS/MMsGKYUAq01kw9lgAb/EG6o8HRtslc4ec4lF2dJ7IrzrhffU5BGnM2PErdWQ8hI9WKk2AlOeg3GjUcRrNzjPjm1EMwQh5U17Tfz1/IZNy0YExUpJTvw5R0wxPrZNNiQWaqFO44ux7uBkwesCgbH1Oxf0W0ay4Mlx9OrZCuj6/9/c3oOsLGIqH3U+AUJjOP3YN2XbMtDgu5T8cAoxRKrQ/vyElBuZUuB/T7VWuum9659ZDEdX5YncwsZD5KP+nD0VY1Tu8x9nHRuSFgve7LhSx0xlz2q7FEhJ9hY3/YyvyaK2ANZ0j0tTPHV73YBfO0Fp84EmjruhMxIR64LEunhmI/ui0NqUffSjI8lUm1rUhvwlxjq3kEgmHzfiQXgd+qknDmvZn7SjXJRIDYFxrKw5pqzcoIoESAa+zZjSGJGsaxVwZtkj41mUeSoJqn2jBZ5eCWW8wLrqyA8PGNouGDq/9BAO6tbC55ntP5LUZ0lj0rJADYJ2BkscyGwAxc1I820hmHa7nHXHMzrcKfFIQOq+HOpe5waIjf71GgYcjdxNVsC25D313coRTgqoIQDMohVZbhfS0l0WUmgr0rqaplTTAeRugJ5ecPOO7U1ySp5736ch30wKQuedj0BRuj/TLsY8GaltmGHHD1aDtz3nrVws6EaTlf6IcmShoeR0NFjwz5S+ok7CUwp3yZcg8j8zFrQ4y1RqMXBs+RCzGp+3tHiYSgeT2O+eDdbpf0qut1gMtUVCPnM/i0x9hwoSluFULW3nYvaRNVO1gt0lYeCW5f8JfAkgh51vKI0/aIJL7s5pDMLxyWOPIeO3sfKWC+x5uuf9Jl0eNh24I4gE83Ag2RDdpx9aUbtQRObsbuhv31fr8Gu88po8NJmBRuN7CLKsw0gLpvomb35gp6PW6m0/g0aUYcLELG9Lx6mEcDjYNUAqma7RbW0nJjh993/o1l
 PHC02fhQ
 9DZinLw+/mgvNICT8HS3mvutJUhmXWCUTe9yr6RUiFwaZ54tzie+nRKvXdjb8efprf5xbpN7HRgSG2juwoU8W9bh4FUc8a2JdbmFXSIugydlxLC5KEmM/Ly2cBTENszkWqnQy1GzUXPPGoXsaVxRD5viUfsdxG4nh/nMGjCrzeP0M0tiMNlE3kZjzmbw/fpyzSK5Ucr70HYzrgr4Yy/eU0iUaxjjJyEO2m+5O3nRu/EBw/2ZrQ0vP/+46TiWfBfXr5QvX+ewIntd0W03qld10k3Nq8kgJ2JEESTc2lz1R/2gDZHGoC2kBEG/T+y22XMVRM0RKNJpQ73vB69EQB0xJi2C0BWH8kc43HkL1kVLGZwTaVJkOItC2zjXWgguPVES0+gZ4Zz8dMsmBSWYzbAG0lnOKfnhz7PFWaZUsIn2oQWAMYL1SZFwEXFmn+dSqivnZ85rqqlAMJPyz5Z0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Gregory Price (Meta)" <gourry@gourry.net>

The MM_CP_* flags are individual bits expressed as open-coded shifts.
Use BIT() consistently for the complete block.

No functional change intended.

Suggested-by: David Hildenbrand <david@kernel.org>
Link: https://lore.kernel.org/r/9b5e1573-6fd8-48a5-a274-a6e7ff83d2fe@kernel.org
Assisted-by: LLM
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
---
 include/linux/mm.h | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 69107e877fd1..b68fb9041777 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3597,21 +3597,21 @@ int get_cmdline(struct task_struct *task, char *buffer, int buflen);
  * because something (e.g., COW, uffd-wp) blocks that from happening for all
  * PTEs automatically in a writable mapping.
  */
-#define  MM_CP_TRY_CHANGE_WRITABLE	   (1UL << 0)
+#define  MM_CP_TRY_CHANGE_WRITABLE	   BIT(0)
 /* Whether this protection change is for NUMA hints */
-#define  MM_CP_PROT_NUMA                   (1UL << 1)
+#define  MM_CP_PROT_NUMA                   BIT(1)
 /* Whether this change is for write protecting */
-#define  MM_CP_UFFD_WP                     (1UL << 2) /* do wp */
-#define  MM_CP_UFFD_WP_RESOLVE             (1UL << 3) /* Resolve wp */
+#define  MM_CP_UFFD_WP                     BIT(2) /* do wp */
+#define  MM_CP_UFFD_WP_RESOLVE             BIT(3) /* Resolve wp */
 #define  MM_CP_UFFD_WP_ALL                 (MM_CP_UFFD_WP | \
 					    MM_CP_UFFD_WP_RESOLVE)
 /* Whether this change is for uffd RWP */
-#define  MM_CP_UFFD_RWP                    (1UL << 4) /* do rwp */
-#define  MM_CP_UFFD_RWP_RESOLVE            (1UL << 5) /* resolve rwp */
+#define  MM_CP_UFFD_RWP                    BIT(4) /* do rwp */
+#define  MM_CP_UFFD_RWP_RESOLVE            BIT(5) /* resolve rwp */
 #define  MM_CP_UFFD_RWP_ALL                (MM_CP_UFFD_RWP | \
 					    MM_CP_UFFD_RWP_RESOLVE)
 /* Whether a MM_CP_PROT_NUMA change is for promotion only */
-#define  MM_CP_PROT_NUMA_PROMO_ONLY        (1UL << 6)
+#define  MM_CP_PROT_NUMA_PROMO_ONLY        BIT(6)
 
 bool can_change_pte_writable(struct vm_area_struct *vma, unsigned long addr,
 			     pte_t pte);
-- 
2.55.0


