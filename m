Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9AA95CD6E4A
	for <linux-mm@archiver.kernel.org>; Sat, 30 May 2026 08:54:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E144E6B0088; Sat, 30 May 2026 04:54:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DEC3A6B008A; Sat, 30 May 2026 04:54:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D29F46B0092; Sat, 30 May 2026 04:54:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C31C06B0088
	for <linux-mm@kvack.org>; Sat, 30 May 2026 04:54:38 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6E30E1C0438
	for <linux-mm@kvack.org>; Sat, 30 May 2026 08:54:38 +0000 (UTC)
X-FDA: 84823475436.21.8E73E28
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf27.hostedemail.com (Postfix) with ESMTP id C20604000A
	for <linux-mm@kvack.org>; Sat, 30 May 2026 08:54:36 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Yx5bwhs8;
	spf=pass (imf27.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780131276; a=rsa-sha256;
	cv=none;
	b=qHIpYh3g7w7Th2NfWiEWEDsagFbLDEqyrOfpxC8sc41vrb8kBdQ9aXJOhLKV5UvZlimXba
	zzXvHwj9l7gjKjDxOx3tT1iPnw3kI5rZaeYn2lntEv5sFyHLtYPT/aYSrAYA/g/ZIQtNJ8
	jv9L3goGC3esVSmDb/QcDFDAKtp/R20=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Yx5bwhs8;
	spf=pass (imf27.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780131276;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qCKJZ6BfNlUbK6kGnJ8atOpPiLpA02h0L8X/d0ZsLCA=;
	b=KJwXZrOyquC0cUVztOcdmfAm2BNZQitwhxNnhpq9yahAyNLAVtzn4QR0rkagSwtw8EivYp
	GM2ixkLrHSJCOK8487vvzwvUJtCegi0ffRXafWUmxIHHAlhHRtT/At7yto+gbL6oOGDRhs
	a1uaNtN/GDhPINVaKFCL1N/sjE70Ffw=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 90C393515;
	Sat, 30 May 2026 01:54:30 -0700 (PDT)
Received: from cesw-amp-gbt-1s-m12830-01.blr.arm.com (cesw-amp-gbt-1s-m12830-01.blr.arm.com [10.164.195.31])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id D82313F632;
	Sat, 30 May 2026 01:54:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1780131275; bh=Ak9G3LTYza/gCy6/RFFf4a29T76eDF8ntJacgmiggGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yx5bwhs8LeClLHtnd2KjyEtflEV4UCKNY1KLqTIVI/VHD2zmhNBQws0EmMy3+WBNB
	 RrwSVqyNK6yixYPKWJxweGMVpyLn80RLYlqSs3KxYBFOgoW6Py1NmRdlgSimr8fX/A
	 HoxuImJ3uvdr0xRxe/Uu8zZ1uf9ERKn/vV573SjA=
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
	usama.arif@linux.dev,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com,
	stable@vger.kernel.org
Subject: [PATCH v2 1/2] fs/proc/task_mmu: do not warn on seeing non-migration pmd entry
Date: Sat, 30 May 2026 08:54:11 +0000
Message-ID: <20260530085413.1270139-2-dev.jain@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260530085413.1270139-1-dev.jain@arm.com>
References: <20260530085413.1270139-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: C20604000A
X-Rspamd-Server: rspam03
X-Stat-Signature: yxyxk1b19knjss86guqmowhh5h76sbfr
X-HE-Tag: 1780131276-91750
X-HE-Meta: U2FsdGVkX18DG++pOAZWaWtVhL7+KGo69F1fPI0cUHNCOIg5395F4YDFTIkH9WOKXlhVB2YSReYaC1GX7d2PCYiuIvCLoNARqBGTkRoHwt3uYNYhPX3p52orH85DjAnOBfbyorskRukTll2oJ1yh9dAiF7zpo90Zu4zkp/13Ca+aCD7mBn09Zl3HEcRnbQG0kame/I/l/IMGBmV04/AUaDPmGvofOV8Zt/DK2ohx1bgVIU65shEiHUjJ3TzCLvjErgHGXLV4ujT/b6W8DsdVTDQ6z8Wrqye+51J0lYKJqOxnDcnNE/ZIocQOO1OX2vBZPxtKgL2W6/c5sVMf6jumRS1zHIdrFJN0VDDRD0SgnMsS8Lteol7UHa03BcPwI/60S1R1XH/8dTH1PQPrrV5sJbQAQbf7i8hO/3VJikm13nGFobQfUA/hiZuXKZ7DDqSLp7j6nhKrHFpm3ep/vKhlma3AOm3V36+p7kaVeg+ttxZsxFfvVLkdUg38n/Jx7tyq/SWx8T8qNnZh5Rfs6J2GBC643jcxsmX0u5wgyd+g9akPcDQgxHL9g3Ss2SAq2ridFhycnuk1uFRpxaYnwYbByvqOptE8Q1UU5OLkTZgwOBnlrskhkVG0i1T6AeUi0m095uM1lpB5EemcWDOzQn7svAa3ZYV6ZB/r3xHidGFbNuNXEzXXigHbNPuMsbviPYXsS7LHpJcMzb0DgP4/16YCBerb+s1PrAlp9ZR+b0zHrRcPoEq4au/X6tpEPh/sPEYX6P1fC1k0V3SWXw2Z+Gg4fHTrhzkG6Z3KI5cNH10r5lwWbWahrbna0v4LIkO0PL0aoHcdj80HpnDe8sTHUAKXNmAjmblvqOLcZ9gabCYFSisDiAc4uT/LPOz1Imac+WbpN3YNx5p90ihqd3Bh8AAINAjDSpeHU+4aKSKDd4j1E3d9NAoW25eoyTrkNXqcAdxbBHEt3cJm2OHa2UMWIBk
 qcQBarYs
 im1Y5DvF+Kb1gimYB7hzaKhJpmAZzkcHQgyfD0j4SN+KfJduIqBEUbRV1PZ9b0MHWCkBElmCsWvAVpBStxKgcb2G9K1lynqaFUoGc1htx5PGS+fn+r/8X9aL2eun9jDe9KwE5q0EPnP8gqHA94P60Gy2msKggvv5V7pI/xQSYmI5XxKa7uBXOxuD0XshIR6SuWuHrLzYIThU4rw/mOBqbFV0dTDOxTMpzUR8SjcXMGe3nnDj8kuWU5sdh5omYCuGHuk2wobDhEsdc7+JBfz5QYlKh2CEfPUwUe4BizucRAqG87J/DTBUdtaMccA==
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


