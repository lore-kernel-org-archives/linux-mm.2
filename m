Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D80DCD6E68
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 05:53:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B70246B008C; Thu,  4 Jun 2026 01:53:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B47956B0092; Thu,  4 Jun 2026 01:53:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A84F46B0093; Thu,  4 Jun 2026 01:53:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 996C36B008C
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 01:53:34 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 46C7B1C1CA2
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 05:53:34 +0000 (UTC)
X-FDA: 84841163148.26.3FB6198
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf07.hostedemail.com (Postfix) with ESMTP id 71B7040002
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 05:53:32 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=MSn4AOul;
	spf=pass (imf07.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780552412;
	b=cLxaSXTTPr8v/kYRvbcfvsDabQR4yeLst0+UZNTMGMy1YfnvRZQIuPAK1wNnRFatk9a9nL
	XKQjSkPRAh5SYlaJ0mjskyhEUrzjnOLAdSotkD3uH5eY/8+UAfWNCaRFr4S7QV7EjxqWQ8
	MjPNoaeoCFHpC+UMPf7zBsZgfx0ChUc=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=MSn4AOul;
	spf=pass (imf07.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780552412;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=442DefUoGf8kF5AaejP8Bj6Wub13cuDeUByj4L/5ksc=;
	b=aqDOPH5+Yvp/od5HgtgJV/8hbqBELlpgZGXH+XeJH8ucrQwU6JqrozyChrCI8Xi7FwzYg8
	N32d3yJnwIS3Aj7o7yqAfVz9Hw4qYWnzqcFP5xT4sVnEswTU6/9aI+G/X6Aj6U8GEjTAFh
	khFMpFj55Y9/q3XbJAxNkOnRzcwjojs=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8B4C53161;
	Wed,  3 Jun 2026 22:53:26 -0700 (PDT)
Received: from cesw-amp-gbt-1s-m12830-01.blr.arm.com (cesw-amp-gbt-1s-m12830-01.blr.arm.com [10.164.195.31])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 690073F632;
	Wed,  3 Jun 2026 22:53:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1780552411; bh=fr1ZIAKStZBd1psxptXiTd8a10xNZESCVeJoWx72PSo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MSn4AOuln+fZ2CVLJ6oX5bcQMRbDlPvZYZoMQ4eHlTUvTMK5Np1lmbcTk7jobKzHN
	 8ZftqXvWi5eO40qEL1SBCbcQqQZp8q8oAIv94LeQHM8Tev4qI9i3B0EsWM57JtrJmA
	 QKoxqVtIl2Z5nGJo+44H7uVSc+cVItHrU+DAlwn0=
From: Dev Jain <dev.jain@arm.com>
To: akpm@linux-foundation.org,
	liam@infradead.org,
	ljs@kernel.org,
	jgg@ziepe.ca,
	leon@kernel.org,
	david@kernel.org,
	shuah@kernel.org
Cc: Dev Jain <dev.jain@arm.com>,
	vbabka@kernel.org,
	jannh@google.com,
	pfalcato@suse.de,
	balbirs@nvidia.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	linux-kselftest@vger.kernel.org,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com,
	usama.arif@linux.dev,
	stable@vger.kernel.org,
	Oscar Salvador <osalvador@kernel.org>
Subject: [PATCH v3 1/2] fs/proc/task_mmu: do not warn on seeing non-migration pmd entry
Date: Thu,  4 Jun 2026 05:53:05 +0000
Message-ID: <20260604055308.1947679-2-dev.jain@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260604055308.1947679-1-dev.jain@arm.com>
References: <20260604055308.1947679-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 71B7040002
X-Stat-Signature: bja7g7n88yt35uxit7peyar7s5fftfaw
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1780552412-10100
X-HE-Meta: U2FsdGVkX1/FPX5f1N2xeKz9VlOrDyQDi0G690D48zWiguLkM93zDxMRMnJP8XmDszvB520ZpyrZS8xvbPw6jsisORB/oG/pAU3Z4XSwBK3QMjLrH8Vc/Lx+ksLPHZiZ+Xc+8wrfz+fwqE9ZDqI1EZly1dTFfSOuV700GpdYDhhnWeJjw/QOPHwkoAOUcdZIqj1Hjlh7q17bF4DYOQoBeKqpNsRS6rMsYi3WwdDGMrsNGBTVFu9I8GmoqxQ4gsWJTojPn7NzBIb383ZwmsDAZHVsm7Lze5sUq9vVH+b5olkUscI86GtVW1yzJzTE15p3SvhlLuSEa9nwbYdCkmW+LiM/NJCkeMa/lXBal7Iut/ihRXLu1wjylAhjkmW+476y7Bpbk8GkAiS6cfd8qq/qGdxvPREpwopXAxNHFxOAoYAiyiT0F7KIfsraSGkq9No8qB3Op5ek6CPttF1HjNfxZU3Gu7cimZBfkQThJd/rFmyeD7I+J6yj57JtXGfpYVo+cH07A0W/f8+CA7LAB2bwtYXp4NE+Ty5urM4G4r7ni6+UKpxmgGDVNK0YV7eZ/E/G43VvKRhsKds3lYcGVOgICUFwNkUT+kM+Uq0t8GWRyhDy00nXDbBQ8imwWBEAJs66ClapFuuGjjxFWZbaF4N2Adgk0QK95tfOt/nO7Ctf4zxCliP9FzFCNGr4J8V1wyhCoB5qq9to+YBkMfOk0C0AZ6ZuU99H4sBo0hbkahC/KDsQAUbzsnFq9U66jI6CAexYjrh+CZybMOUSJPUK9L7WD1VwCIcF0jsJ1q3YjK0rNZawxLBBfCJDDyCwsS3deGHN11vqEihg3pzhkRtYPsbGkqHsXsbIyj6nRB/LkctJ1JsOOPpJ9R0K/ZTiDNtgtjXIMHTh51A9BAbUjXl2BTQ0Qv4z7gra29GNl+8+jxaF4/9pvHGdFY4U8pUClYrXSuzCo9vqxUvvRCY1gz1jAT+
 F0m/R8Fq
 CO+Sx3+l2U4QKVhYrg3srv0EvBxh3BfA+HkQr4RwoSXQITUIiJIcGIiSJfrFHBfKTF/swEBz6RjJ1dONtMY4KipzHBaPjWrHwRT5hD7riGFUSxWofu4QMnA/UWrkPAvgIuLfVY7gSN8KBuuFUVdtb0vjc5wtu2lqubFZ4eEEPnRm3S1Xe2LuId8QXmmhHl1OiJHo0xDXXVFoIdZxWScy6iS/2mp25ohXrOjT+J6gdnAaFGeEdYJV8h0Ok4muHrTitPdMb6/hYj7HONloYDosL/rDDqif9Zf51uY57kaJ2iOMHwvwuh65JVWnSV65MqFyo3kizHg+EoCVwfU1hu546BpcXNA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

pagemap_pmd_range_thp() warns if a non-present PMD is not a migration
entry. This became false once device-private entries at the PMD level were
added.

Therefore, remove the stale migration-only assertion.

Fixes: a30b48bf1b24 ("mm/migrate_device: implement THP migration of zone device pages")
Cc: stable@vger.kernel.org
Reviewed-by: Balbir Singh <balbirs@nvidia.com>
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Tested-by: Lorenzo Stoakes <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Oscar Salvador (SUSE) <osalvador@kernel.org>
Signed-off-by: Dev Jain <dev.jain@arm.com>
---
 fs/proc/task_mmu.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 1e3a15bf46f4e..58938e62154d9 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -2129,7 +2129,6 @@ static int pagemap_pmd_range_thp(pmd_t *pmdp, unsigned long addr,
 			flags |= PM_SOFT_DIRTY;
 		if (pmd_swp_uffd_wp(pmd))
 			flags |= PM_UFFD_WP;
-		VM_WARN_ON_ONCE(!pmd_is_migration_entry(pmd));
 		page = softleaf_to_page(entry);
 	}
 
-- 
2.43.0


