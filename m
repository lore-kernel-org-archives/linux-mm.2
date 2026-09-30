Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 456C9CA5FCB
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 15:28:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D65E6B008C; Wed, 30 Sep 2026 11:28:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 487576B0092; Wed, 30 Sep 2026 11:28:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 376CB6B0093; Wed, 30 Sep 2026 11:28:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 088386B008C
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 11:28:48 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7BD3B140113
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 15:28:47 +0000 (UTC)
X-FDA: 85270811094.05.34F8441
Received: from mail-dy2-f41.google.com (mail-dy2-f41.google.com [74.125.229.41])
	by imf22.hostedemail.com (Postfix) with ESMTP id 32C05C0003
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 15:28:45 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="eY/N3vFm";
	spf=pass (imf22.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.229.41 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790782125;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cc+9rKSOSGawoxpJ2ipg52Wvw6p1Y1gNn8hY21fAsGA=;
	b=4AR9bsRbg1Jfqu7KUz3RYUv2dfHjSjfIMyGqFTa7FPoVyUAQsjw7IdWey7jZx/nB4gZ1Qa
	/UHm203HrJuG52kT4DC4p107c+FDn2OVkH44RWMTsHmTa1nhLADpd1ZBnKnOSY152Wnlrb
	JpkmMoD06Ex1wbVKK25opiEeiEIIcb0=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="eY/N3vFm";
	spf=pass (imf22.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.229.41 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790782125;
	b=opfwGsGnZOsgtC7bgaTVc5K9U3P8PORMpzUdYeP3dQcZlKRl97Hft229gBFu1QeBvNXYAy
	15JgMznQJhcuLHguCr4tjdL1NQjThPfCu7sYuRvp9b3in1r5YMxjo4uEH/q5liMVGfYocP
	YSfk1q1E532UEI09pwUfzbMHz533o88=
Received: by mail-dy2-f41.google.com with SMTP id 5a478bee46e88-34c0b552ccfso888369eec.3
        for <linux-mm@kvack.org>; Wed, 30 Sep 2026 08:28:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1790782124; x=1791386924; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cc+9rKSOSGawoxpJ2ipg52Wvw6p1Y1gNn8hY21fAsGA=;
        b=eY/N3vFmqFmhpHogZhppbftxBBlxICIdzVCFX1Gycld2DV4qqDloLrvhAWv2TDoT6S
         3LRbLsbU5EV1D/2yd/hvpGXmRzDgRhFqsGMNvwRWBPAaDs2uxZVcrEVod+2wCLhMlWJX
         GJCaBl+VWvMThr+DMH0uupaMdV4SdFpj4z09N2UsCDieUS0ty4Xwwq6+oRkUZpS74ulR
         HUCNBIJL1+0igLt6GazWPQMT82jrErYMuSZ1uuWMQEeYzRZH8+9xamGyrqreu5vN0arx
         iGBJOMxd9rsVJRpD1iwGIgUmZai6QX1JVHDxLC++l7Y1chddHnWlQCeo87i/GwqnABhG
         O6aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790782124; x=1791386924;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=cc+9rKSOSGawoxpJ2ipg52Wvw6p1Y1gNn8hY21fAsGA=;
        b=MXmAQ8CoMWPDGwGxv6SzH9cFM9FWvKZU9rmEeL/KWWkRkz5cMpJqwoXfuPNgf8HEh8
         k30OwFgmD1AtHi3rQy3zE750BvJpcz3bTFhuAVlDg6fywmv8m3J5bFnT7buK0G59Sy+m
         NjRueyCWN73ROl7UH9GUjgMdztwJtO0GFnfXrlo7h9wNha0usDE8qe2t2YO76qaVz2xk
         75fK6lRPTIxQl3UN2aK71ryVg1RUaO7tSJHoPRxaJMYnfkmsfzkUD6kY1/3FOsYUGAfD
         xBVE5hllSDkeN8vSkLzvVsfMyQelD/0WItplnDKHnbZNhrUjpnyyI2rc3IgWFcgJ4tv7
         9YvA==
X-Gm-Message-State: AFq9FYJtpUwRZyUQqQD/tfgww8J0jM1S7Ry4bCpw7j0kj1ju1UITVFoF
	k8Cb37EGwEJcYOF9rhzHZVim+tE4Ox13ps3BNKrNnSsyvGyWP6UcuqMIp7Fo0WzSHlA=
X-Gm-Gg: AYBFou0No6/y102U2hvb6rdXV2l/MPLDdoxweLuqenQpdalDugw1txD1uVUAWrDP21f
	5wqjZl+51V4U052Gew2WVKUfehUdrebUSqal/VxKfuOxknvZnxUUjarK92bHU2BZc0QZ24mzDvV
	VceNFyOnvbifvOUwnhuAI21wNoSFL+gwb/HT5sLB8KpUt2B41QWggIVL87MVf+J6lPERa6zns7B
	8vvvMYsWhw3bvaJTu0EY05tUybBmALkw8cWLOCQeaYDSBJ7db7bvucH+HA9jfZk3kiuUdEY9Kfv
	EhWSvel+E2fd0rfAvy2C0sNdHPUWN374UZ7ij5lOSCnbH4Lt/21h6g5GeSagfahB3bU756mVGsH
	l98ZdPIR1BOjSGAqpR8m5tkyl6BMw2mmB3C3YU9v4pc15xUIQWCoHaHhHZ1dBqd1kMuE/aVYMMU
	UBZO78aSjk1rp9cIlozqnkByKlJkqRw1QAAoPqMgqxrIT4NJ7IXgYHnWHya+fb3jZS5l8IJ+4n6
	R32RLYpaxWmwYtA3sE=
X-Received: by 2002:a05:7301:fc04:b0:339:85bf:dd89 with SMTP id 5a478bee46e88-34cdd2a42a2mr2004450eec.35.1790782123219;
        Wed, 30 Sep 2026 08:28:43 -0700 (PDT)
Received: from G6L4RL2QG9 ([139.177.225.238])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-34cf5b3ea3csm5750493eec.23.2026.09.30.08.28.35
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 30 Sep 2026 08:28:42 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Jonathan Corbet <corbet@lwn.net>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-doc@vger.kernel.org,
	Muchun Song <muchun.song@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Muchun Song <songmuchun@bytedance.com>,
	Lance Yang <lance.yang@linux.dev>
Subject: [PATCH] fixup! powerpc/mm: switch device DAX to shared tail vmemmap pages
Date: Wed, 30 Sep 2026 23:28:26 +0800
Message-ID: <20260930152826.76084-1-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260930140627.57431-10-songmuchun@bytedance.com>
References: <20260930140627.57431-10-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 32C05C0003
X-Stat-Signature: gr5qq68reft3xduxi6bgo4zk63wfrrwd
X-HE-Tag: 1790782125-622547
X-HE-Meta: U2FsdGVkX18BXuZcCfgNMJ7N9mWBLvGv0WLO9lrR92VnNBGfXgY+SK7zLlZNugFYJXEBujzJxVeYn9/2Qpzqw5VZ9bszK4MW2Celx2dw0fwzUUSWhJnt3FaWGdUTx2/vHI095WH/ja2sbAYc+8mUzFhMxt6yey/GFSZMvT+/B8X37bXAS2SmWhZagAcxu+RyG77ID41MY970CpwXipcIQygJ9iHVLTtHpPwZwx8nIAMeYaHybc6hYVgOZIHbt0061zzgBz7Aesl+ZdlrVbP1KJqawSchPk7WIenQRoXwgdrTS1y/FT5wuAjuD6hJmPOazY43/Nb6NpTAjQAC5etAbw6p/g9cCVAUymDdwfobO6iyU5mC/R8BPqL2F6cnD9rjIbPbrQLHumNPBUW3BVyfv74bycF9F1ToSKfUZbHWLEQjqznzKrLluW/Cjn0/tLiMckslRB+GHwsMlzUdfBEYUa6+Y6zNolJRs/bWmj1EJfblFCp9ugj5XMF5lWaGUjWI9oqXddk6P/Sc/aPrjGZKz4ST9AWNKE61a+de3KCBoCc1yf5Xj4+ma93pGCpjAtN1g+c1t30t47irTbY0V+DEr9hFzwpWVtfNvuOA2XekLMHEQXoTMZTM9nVdQbykVgbFaiXCundDtfPmErW59wev6z5kn6rJHWtNNsDCzngUFEd6Da/bE073FfpVLd+4DX71S3biI4/yppYiGM0CxD/3U/xPfGsgvIW9AO6nn0HxDCP1HSwWWj70wJvTzK7irUmZb6tvaiNL3UkVB1v5k5hWCYdourNGlFOBeTd94HaeUGDQAt7VXnmML/8qW+8QgZg1p6gGovv9zHCASldpzwM9A5SxVmTohumnMPCiK90j/bqTHSTYjjqlVJnCKWSY/m5yIym+ljMlIxYL/3i0PtZ7q5SatxjUrox4lp4Rayae9GjU/CR6sUPTUGJO8lnfvBcBmgtFM9uZiiDTnV3f4eF
 sn2zpvhD
 jg13EDtFtXh1qGwjCD3lynYQDY1i/bE35k1CZbO7UZcb8wwlHfh3tsDcufTPdx0Ur1QEVkvIdzqraxSZe9sERgBqw/ZfrRWsdcr45nIdYNCc/QYQhNAljh+KL2jivgNNbyMVT1ECTaFKmOxFy2B7zudzhNFauPYVTKZcyXFRCKWPmu/UHlpuDZB/g9NrBLcGgq+JH6XjLWEzWD//+rzXsSSWoiS2pg0EtkjPPKuZBHYwO7GfvDibhKeriYdEPpFlG+GAB/IZ3AmBx5MdV3x75cr4hu5Sv8/bzM0KmChfkNyjLw7z5pt2rnz7HPp90aHfjrhBzj9wgY6xeyFYynFukraneF1hlqsailyTPeyoeMc7wgEDxdKT/1V4PSOvYm9ECXtvUTh80Wo90wvIBXm+Uf/AewWlvJ5J+sFlpFsvMEpIu4ag=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The PowerPC radix path takes one reference for every PTE that maps the
shared tail page. Unlike the generic path, get_page() lets the counter
continue after it becomes non-positive and eventually cycle to zero.

Use try_get_page() so vmemmap population fails before the shared page
reference count can cycle, matching the generic implementation.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 arch/powerpc/mm/book3s64/radix_pgtable.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/mm/book3s64/radix_pgtable.c b/arch/powerpc/mm/book3s64/radix_pgtable.c
index 9ca28e4a610a..a3332f32ffb2 100644
--- a/arch/powerpc/mm/book3s64/radix_pgtable.c
+++ b/arch/powerpc/mm/book3s64/radix_pgtable.c
@@ -1042,13 +1042,17 @@ static pte_t * __meminit radix__vmemmap_pte_populate(pmd_t *pmdp, unsigned long
 			/*
 			 * When a PTE/PMD entry is freed from the init_mm
 			 * there's a free_pages() call to this page allocated
-			 * above. Thus this get_page() is paired with the
+			 * above. Thus this try_get_page() is paired with the
 			 * put_page_testzero() on the freeing path.
 			 * This can only called by certain ZONE_DEVICE path,
 			 * and through vmemmap_populate_compound_pages() when
 			 * slab is available.
+			 *
+			 * Use try_get_page() to prevent the shared page refcount
+			 * from overflowing.
 			 */
-			get_page(reuse);
+			if (!try_get_page(reuse))
+				return NULL;
 			p = page_to_virt(reuse);
 			pr_debug("Tail page reuse vmemmap mapping\n");
 		}
-- 
2.54.0


