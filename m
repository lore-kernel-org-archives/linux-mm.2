Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D53F0606AA47
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 15:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=gP1Tdcf1
Received: by kanga.kvack.org (Postfix)
	id 3E13A6B05C8; Tue, 10 Nov 2026 10:05:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 36C8F6B05CC; Tue, 10 Nov 2026 10:05:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2830C6B05CD; Tue, 10 Nov 2026 10:05:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EC5B56B05C8
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 10:05:10 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E47CE40932
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 15:05:09 +0000 (UTC)
X-FDA: 85419532338.06.F3A455E
Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	by imf26.hostedemail.com (Postfix) with ESMTP id 0C0CE140003
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 15:05:07 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=gP1Tdcf1;
	spf=pass (imf26.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.41 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794323108;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b9ZjhJYgeBT8nslEyZrG/np7JkCr0xptEAmrRjaWc2Y=;
	b=DeHZZQq6qqvMIpoQvSpA1xOmWTQVh/znreLtYLLRM06a3S61UnFQ1kj1iLbreJtSpqCcjq
	uLLGX8P+XtOAqOW9Kx7kHSUyC8DWm1vynqFNoTALHeHoCJoaFrKnsliv/L2/8I5SQHYf9j
	ver6MBigLJkLZK2aPkF3rOGtWjBsmKA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794323108;
	b=dYbajc/nzbML58qZMoE3D8OTZeD1OgDsPzLlD29gxsx2gPIPlRry6yU+H2BaNh7ful3XWc
	60zI1daPuyf5lg4tHVwoyp1ZyLYQIIrageSNHQloqCw9FgVw1xL9NtYwkN1VZNKop0BR3G
	lpedsFG7ulZakDUrgB34hPLt4k6HvW0=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=gP1Tdcf1;
	spf=pass (imf26.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.41 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-91eed03da8bso17122916d6.2
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 07:05:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1794323107; x=1794927907; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=b9ZjhJYgeBT8nslEyZrG/np7JkCr0xptEAmrRjaWc2Y=;
        b=gP1Tdcf1DRJgA+LljAKDT5zJhkHeYZcr57/WIHUeBGtCllRM6mELOLbRoq4derfa/5
         pnBaX58VgbwEo36FCHMwo9ASiMqS9pyQj6nGi4msBk0MB2oTFThoLyKa9tbX8tpWNHfk
         E0Qo6iOSprS4jA4RWZ2KXC0fI4+H52nEMSiUjU18HEYuJmAL2Z4dpq05Zj1vNBXUnzas
         Z2mTt+ytJVb78Hc/k2/ICTyXr5sBClomef7M+woiwZ1p7B2emBvQCRjvFHF1AYAq+rtZ
         9Qh7HmkDJwpD7QuSD4HUPv1AM84zUoFIMFMNR3exXssizpGtgcPABy158mtjCu+GNNw+
         iBoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794323107; x=1794927907;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=b9ZjhJYgeBT8nslEyZrG/np7JkCr0xptEAmrRjaWc2Y=;
        b=NwsQwuIFsnXCBazUj5ofM4hlLiEF5n+kZQMSGasah+ZXsoD9TyI971CFRix306IH7q
         dvMr5K+SRrXNWtopKmtFw3S/DXLT5GQvwhi6TiMoo/mlufZquIyN1GVScJZfvnzkgFKn
         NCmivEftT5hu96OVH4zxhZyY2HU8VMvA2GFCZ0Nc3Va01bQzm0MrzX4Az99vaMYu5IxJ
         e+I/2dCmRCwEcEw4/jQT4H+buWwmUG7ZrFTl2saH+DM0//iOaINSwPpbHKGkyMu9Iu82
         nCGXZ29P5EO3Zxm7Empi32hU0gQwsivMn2y6f/LR5hZOxae3lLz4q715eWvblfAYWc3M
         o6bg==
X-Gm-Message-State: APuU4Z+T7/2b5Jzw+PhtLawHOsBH8Q6/2JztrRmJdHsRYdKu/V51PleF
	r58WlmQtcg11g+m9VxgDZ62V/6wtZYM+bHQ1ez91qmoO2MDMCAJyp3vUJuB+KiJgenNC4a1M9qU
	+XCde
X-Gm-Gg: AYBFou0ZB7MD2aLcKb8tBKsJmb5oJ5ZEWvuB2zKlSCjOHUar6xN1zS79J5zUdhyANp6
	bVBPF1kd4ez5lAo9QkTpNpxsR885pgYUSLHc6AAPj4U3+JoEXeMhLCgIn/ECUjKW2vKiAMoalyK
	rOmowToY7V+U/Azfe/Vs0q9x+owBQDN+UzJfiOQdGEgW+yrz5Mb3S+R/Ygrk+51wys3URYkgLYi
	csaO9RAOg8cDuKNZ8ZrBL56W92TBfYPc4eI3PnOdASRUQrVD4BH9aifOBdsxRs0dTbo6ZxGpNGK
	YZojgmZFMdgDPOQRKGJiET3Ohc1FPuFzOOWtdEQWq1wCic8TXVq9UXttpQzAVdwpEOxfGR9xYjy
	ZpAK+9qWyEmXyiq44+wcT59zUzgJnlbspsCHy+lVsy41iIfZ5YcLLKYLaPolknUUu3wpzC2bBXx
	wvHOBx+TNMlOSjzLUMufN5npPBW3A6MWwT3qEwzAinUVu5NUHBq//Q8UpSIXb6xo20B6lUhpvKt
	I+zQEvJ/3O9XwNHfGbNLlpoE/VEe8kN/cZTxOb8YqDiGx5BwdUkLup0Sxeaz8Q5P4vSI+3YY7Fr
	MJrWfddtQJIDwa+hnbwhUyV6QJFiRxFA5Ww77A0Pok5pvoFVz20+WBwGyVZFcYO3BMN0E1X3S3g
	5R6WvXDIymTHWFIk=
X-Received: by 2002:a05:6214:f2b:b0:91e:8ee1:9307 with SMTP id 6a1803df08f44-91eef5e807bmr47437096d6.1.1794323106997;
        Tue, 10 Nov 2026 07:05:06 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-71-191-145-202.washdc.fios.verizon.net. [71.191.145.202])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91ef031c7dasm22902406d6.1.2026.11.10.07.05.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2026 07:05:06 -0800 (PST)
From: "Gregory Price (Meta)" <gourry@gourry.net>
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
	peterz@infradead.org,
	juri.lelli@redhat.com,
	vincent.guittot@linaro.org,
	dietmar.eggemann@arm.com,
	rostedt@goodmis.org,
	bsegall@google.com,
	mgorman@techsingularity.net,
	mingo@kernel.org,
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
	osalvador@suse.de,
	raghavendra.kt@amd.com
Subject: [PATCH v5 6/7] mm: use BIT() for change_protection() flags
Date: Tue, 10 Nov 2026 10:04:45 -0500
Message-ID: <20261110150446.2452975-7-gourry@gourry.net>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261110150446.2452975-1-gourry@gourry.net>
References: <20261110150446.2452975-1-gourry@gourry.net>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0C0CE140003
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 5m8yrxbzq688wept51fkupddhc7ysd4p
X-Rspam-User: 
X-HE-Tag: 1794323107-137135
X-HE-Meta: U2FsdGVkX18eDIqBnbA18gw+KSSSZw9sB8yqqvmryiJWHREUeak5BV1HdFhwYTRy7yKczonBjjWxzgTrFDuv/orU9VtBWegU5/cmkM6rNPekBbNpHleZbhJvdLbnLa/cOmnHh45/g+CBXnUfRrA2DS1KnyxcjLZqfCaCB9luBLLaoRAqvxG+eTYgJSCyl7+mqP5ph/Q4b4XBM8Tdme3u+2QCPl+aCwR9Yc7e5k1M8Fk0wRiv7uqa+hAfvR6D4iZ3zVCRKAGbjVpJuQimhxmgUsMsrOMl+DTstflSo9o1b7N16gnuHOvPqIhkbPjq6Ueqb+hkFMgB4oLJVsSPNDfH2N72hwpBFpHQTT+7RRqEVdZmFkA2ea/5pTG2bluqEjkAurxG1rMQ64WoJ/A9En31mSU69Vyi5UmbBAcICtktHzCZYZYgvnLqDTyb4gPyPpegwhkVXrcUSdUC/nnn4LsBRHnPkbwmg3qQ3DiOs66pufY1JehHOr6P7uQ/MlVTThsK5WsF0icRbezYUCDDTZycLSlNbcerlxYDjqKxXPNyhAzsRti3DBZ4nkZP9mSVBCr1KOC8/P3wERkuIDsPkSKI4AAM0CeepE9GS/58uiUMkH9WNoYPbAHXIAGnITyG4DuoyvGpt4Y8sJ36SsMPnh5C+7ROP04kRn70rrwku3d8hN0pPpGXim142DANKdV58By9JjxuhMNKZqiwJ+p18VSJ5ELQloQglEvNL6SCtWL2pGu8e/QWLGKPp4HfaVPN5BJ0mktPnOsAQCySnjxGVwCzhNkV51oaWtD9tyz3Wu3vtPUixjAoBeeUm+lwlych1aUVQDTwZPEXhlM0oueHIiEKNqjIpk8khIUv/L2QXCVE/Mk0XyJDgKVW5BIl0UBSaXxsGQcVR62Kj6QaQ9asoC4Vd0W9txn9SAUyKEbLnRNN7x2a2fu6XCoQTQ2op2fgErrf6N/WBXNATtmIQ8Mmgnh
 OIucP/6M
 Oeqrz9z+wzECN8R8SKqsDMVANsEjyxkhoLB0nsQksbQ+Y6/PsY7n8SbAihgRVW+hv2YwXHLfFclaweDAvKChdWvRBqWhrHt0LTuIE2dB/Sm33uDqCWLjvVltrYmLy3d2FNEXbhAXFO2UuzQ3musv8Q2gmtG6SodwptW0Oo2m/0Fd5z5Wm7rdsF8P3rOmRoTW+mxWp3esLnUGtIbezOxBW/Dn56ydvnHw5X+bwZABxk04eBuYQ5eJTZSIpdCVUJNl5TNE7syqt41YIrbDaJEOGPChV9tyOwG5kdWjpjtp+BvVX5SdqKf6VfoVc6NP2SVjJq0APegKYzUdHUpmxdb09WmXqguq/0XCmL1e1ayJqoiCh1oBa6GoleP7lxZ9CmuU0m5l1kXg1PCNZGcmymdekx79zCXUVKIJpeVAf+64ezPqhTPnRSPiialk/Lc3S6lFHLT0F
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The MM_CP_* flags are individual bits expressed as open-coded shifts.
Use BIT() consistently for the complete block.

No functional change intended.

Suggested-by: David Hildenbrand <david@kernel.org>
Link: https://lore.kernel.org/r/9b5e1573-6fd8-48a5-a274-a6e7ff83d2fe@kernel.org
Assisted-by: LLM
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 include/linux/mm.h | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 55817dea7307f..da22750faddbd 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3572,21 +3572,21 @@ int get_cmdline(struct task_struct *task, char *buffer, int buflen);
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
2.53.0-Meta


