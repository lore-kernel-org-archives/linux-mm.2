Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8725606A33A
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 21:46:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hU8D9s6j
Received: by kanga.kvack.org (Postfix)
	id A38966B05C7; Fri, 13 Nov 2026 16:46:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0F4A6B05C9; Fri, 13 Nov 2026 16:46:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92C4D6B05CA; Fri, 13 Nov 2026 16:46:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 63D666B05C7
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 16:46:53 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 84F531C2784
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 21:46:52 +0000 (UTC)
X-FDA: 85431431064.29.2C595A7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id BC09C140007
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 21:46:50 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hU8D9s6j;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794606410;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SbhSMWJZhoke2qAl0UjjAwvOzQBu4RiiX5KWSyo8Ios=;
	b=WAC67qR2aSdZzyu1G00GnULy9NMUF/W0fLj7d/Vf2b3qoyVhUvmmmk2nN9WrzZN5x971fy
	7u+Unss/M8KWG4TivCtXCEsd20Vi6OrovGWQb1v4yZYNqMQa3jokUwiH0hCYrZaxAcaBGv
	ZnR/JjVsMzt+tFShqK6zg49NxvVQMB4=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hU8D9s6j;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794606410;
	b=akyinSyXixtHtwXnkiqkoFogUM+lzP+Nebjzal0wNkOY1zZl4UCkxJnrn/v+QPcBcw2978
	CSTBrYO1p5oWCitD9K01kDQUsWq1iRw/Ws+w6ezU4VDRmqVm/MpQ6YoGgxxVb/w+VxdJq6
	JU2+/DdJ+1032KgJaRC8PfBOKwKiI8A=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5B6BD634F8;
	Fri, 13 Nov 2026 21:46:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A20511F000C7;
	Fri, 13 Nov 2026 21:46:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794606410;
	bh=SbhSMWJZhoke2qAl0UjjAwvOzQBu4RiiX5KWSyo8Ios=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=hU8D9s6joQEtJUegFkkfvSvT2iHHsk8iGzhEVv/uUzwH0PWF1GXbVRGwT4bHxvrfn
	 2EZcYgGgzpl8nEakZMp2ukOZuBhscxUIKsBNmlylUAMN4zuHbEKxOtMIyY9uSkF3Sq
	 +Ej6ej6y+vU3SBRKADrtJgUejWo4lRa4QkqfhHi1GffmudNcx3vkK4swiTwZxZLEYE
	 1wUR1VOSl9R38mrkzmCSOrdHetR+zQ1eXRJH8U36PauhLGeMWgnv2UYVqE79iEnSFr
	 WP5M3yisa3L1br9ED2b+ibn17z430NFhzGSE5k7bC4vKyU2xfkay79I6BxX4AKR50C
	 iWuLW73rJ9YDA==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Fri, 13 Nov 2026 21:45:25 +0000
Subject: [PATCH v2 07/13] mm/migrate_device: look up fault folio after a
 split
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261113-mason-migrate-et-al-fixes-v2-7-50a2ed382b61@kernel.org>
References: <20261113-mason-migrate-et-al-fixes-v2-0-50a2ed382b61@kernel.org>
In-Reply-To: <20261113-mason-migrate-et-al-fixes-v2-0-50a2ed382b61@kernel.org>
To: David Hildenbrand <david@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, David Rientjes <rientjes@google.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Nhat Pham <nphamcs@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, 
 Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, Usama Arif <usama.arif@linux.dev>, 
 Kairui Song <kasong@tencent.com>, Balbir Singh <balbirs@nvidia.com>, 
 =?utf-8?q?J=C3=A9r=C3=B4me_Glisse?= <jglisse@redhat.com>, 
 Kiryl Shutsemau <kas@kernel.org>, Yu-cheng Yu <yu-cheng.yu@intel.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, Dennis Zhou <dennis@kernel.org>, 
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>, 
 Peng Fan <peng.fan@nxp.com>, Josef Bacik <jbacik@fb.com>, 
 Chris Mason <mason@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, "Borislav Petkov (AMD)" <bp@alien8.de>, 
 Mark Brown <broonie@kernel.org>, 
 "Dennis Zhou (Facebook)" <dennisszhou@gmail.com>, 
 Rick Edgecombe <rick.p.edgecombe@intel.com>, 
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, 
 Josef Bacik <josef@toxicpanda.com>, stable@vger.kernel.org
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=1695; i=ljs@kernel.org;
 h=from:subject:message-id; bh=aaALv9FtajCSrXDaml0a4kDLKsK9tSim3Q9wP7uXhCw=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLK+t/x8F1Tw/u3iVyvYXMvz/ZR1VY7MO7cw5/PtKw+8P
 m7c+0LMpKOUhUGMi0FWTJHl+Rfx/UEiYfM6L/i7wcxhZQIZwsDFKQATyZRk+CtYFmrVcoe3YOfd
 6OoH2YbLy7OzC3qdDjtsmn6gyLJUrI7hn55t+VeLKJ3+pANvMyYWqd8yijPct0XJ/lrK3MM606S
 XswMA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: BC09C140007
X-Stat-Signature: riaw7k1eczkr6au44y83buyye9dnmau8
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794606410-105543
X-HE-Meta: U2FsdGVkX1+p5MEGOGLmcvcycGxfZGeTabRHeEXHXVyP7qNKgEcUGJcYZ7WwfdI6F/VFfLscN195W01JPhH3kAwsmoHm+fZxCUoAxeb8+/yPQNhSgk13mu+zPF10+pKHK2dUfuyT2YTlHTuklh2TGyFgPBrwyIHJTzhJxnTpPJpElLxpGeoI+4t7icdNtC5VUr3eUuK472uVZ0196wRTxKO7Wi9+xIc6Z/b4zcq60lOiqw+CPg4t2Vcn73m52LYGYEWXM9FbhyTvfskVbEOCDf3rNE3mu0W02pgkxmPPJ/hU7/39xKCTG4mzgP1YGo6LPRm7GndmHzmIERWoKKK0CwY531OhzErFqLKJN+NNu4MjDbf2AFe0iAfEkMwvFOYNT4JXYz9vp0bOC+zWtwHQDMEr/KcO1a/fWPbsG7HnxdNdhyfuDWNhhji41p7Gtz7AWjU3rTCOTq/R9uKQ69jB8ZX0cuB93XwEzZfSahK9zEaSCAxHWNAvLcRSWGPZmyk/D/PPI50AVPUAjH0yMWFPt52zB0uKfXeqGMbZj7cplSAsn2/Fby9816J5pP50vduw203Wh6OTxLEix+2lVzCOKn6FOpMGqsX1QXXXn/OQEuMAMAfJEDnGJu4iWt3xrt+94m/z9KR/OaZuGtXb6BavVC/afrdUcWJIe37GMnZenewNpiYn1v/JjMpaa6h+eWDV9NfssMqfr7eh6Uiuowevp/fvwqZD792c69U5deMPBN0DLIGR1DP7UapoJv0eAlHjXsi+qb2RzDFeTqMHAc8ngU545LNNPja/t57eWllJgpMjokmjVHxETu8996VLrB4SnTA+sUKoc2wFVE1ZPjV7KzGfNR0MlzKuFH80Rzzyew5EPqZhFmTkdl9QUxSlFRSmKQl483/K8FfUAHcqdoIxZCJK+B+vp1LLw5IuOksWzaU25Tom9ljUTUwFRRcyCVHpHd12enXeEtXgzlGsz6l
 fS45Dw+F
 329YSsquI03nBjC9T/r4ChA5OSLeb092n8hhYjWk1s3g9AJVVeAUhxUJfh6+UgRYRz6lL8oq87+yG0ZDNyVce2F42hu0iovqZA+aq2E2ZwEn79WTRi5dh9EcekmhScpSjhIyguwahnICu6sUfUzDZdORb4q51RgTF7koAfICRpOWRoAGNYSGODSX7EPnVMMUVx2NOkzdhbAX7VROHkevpVw//2XfTWsRyc77qPxtcOw7NrkSG1IojQkOz/wJn5811RAVj7MysThg4vKWT2hEuViHSIoWHKMEaGvT8ktkKnUmyuytwHPuOLY1mwixmx3eFLmLSbyXSBGgjAy+TB49+/QXAsDa7qHUD/xGX63X0p5WRkw3DOGU9Y8MaJXzrJq+ewMCfZO4XjRT1QlR3NhOkwz/+Ws1tywVs5nxTlyBJiS9qA2e43/A3icRW61kz3Ld2stW6euamnOz/BONDi0dQSDxb6zioQpxYoqsh4CoOudOcjM4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Josef Bacik <josef@toxicpanda.com>

migrate_vma_collect_pmd() looks up the folio of migrate->fault_page once,
when it is entered, at which point the folio is locked.

The fault folio is assumed not to change after this, however if
migrate_vma_split_folio() splits a PTE-mapped large folio which contains
the fault page, the fault page ends up in a different folio.

Resolve the issue by looking up fault_folio again after each restart of the
walk.

Fixes: 022a12deda53 ("mm/migrate_device: handle partially mapped folios during collection")
Cc: stable@vger.kernel.org
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
[ ljs: pared down commit message ]
Tested-by: Gregory Price (Meta) <gourry@gourry.net>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/migrate_device.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index ae795fdf36f4..45e571dbfb4c 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -233,11 +233,14 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
 	struct mm_struct *mm = vma->vm_mm;
 	unsigned long addr = start, unmapped = 0;
 	spinlock_t *ptl;
-	struct folio *fault_folio = migrate->fault_page ?
-		page_folio(migrate->fault_page) : NULL;
+	struct folio *fault_folio;
 	pte_t *ptep;
 
 again:
+	/* The fault page is in another folio once its folio has been split */
+	fault_folio = migrate->fault_page ?
+		page_folio(migrate->fault_page) : NULL;
+
 	/* [start, addr) is collected if we get here after splitting a folio */
 	if (pmd_trans_huge(*pmdp) || !pmd_present(*pmdp)) {
 		int ret = migrate_vma_collect_huge_pmd(pmdp, addr, end, walk, fault_folio);

-- 
2.56.0


