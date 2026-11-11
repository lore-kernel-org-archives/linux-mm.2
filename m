Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 842F8606A331
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 18:15:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PfBrjCyC
Received: by kanga.kvack.org (Postfix)
	id 8D4016B05C5; Wed, 11 Nov 2026 13:15:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 883CE6B05C6; Wed, 11 Nov 2026 13:15:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 772BA6B05C7; Wed, 11 Nov 2026 13:15:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 420EC6B05C5
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 13:15:31 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CF82C1A03E9
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 18:15:30 +0000 (UTC)
X-FDA: 85423640820.22.38C74C2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 00CCA100006
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 18:15:28 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PfBrjCyC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794420929;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/og5Uhf95J9kveBkAm0grQ3O8w2sq19wcFkN9LBdY1Y=;
	b=OdWAqlV1WcaB7Ww3WEROSz6pC4xHdh6sRhP7ia/n+2J3y+nJijPzOLCXP0aQDS4ViGFJSg
	nu719ZOL20MWIfHNm3Sts6NU06mcVAjhks9YRjkenQDn2SPYE5OkfuDA2zwmzoOn0e3grj
	dTARBw8Cqz2ykKrT4/Oc8TOATjGfox0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794420929;
	b=vT+9woOQaYFVZqWRnNL0qtAapMPqShHX0bDLN8AQ4odjyIIrhvRYkXAsKkoN1Wn0RrE9IF
	XSagE5IGqSP2vdNnqUgyM1JW3o90kmLk23U3TzMjzEwxuTBsQ0BXBeLbcy+cgk7CV/Dari
	5dRQINNE4e7KVib2BFN+yQcN7rR1wSc=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PfBrjCyC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 48B6D4369C;
	Wed, 11 Nov 2026 18:15:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7123A1F00A06;
	Wed, 11 Nov 2026 18:15:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794420928;
	bh=/og5Uhf95J9kveBkAm0grQ3O8w2sq19wcFkN9LBdY1Y=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=PfBrjCyCEH4wXB5O/qCXaz4drr/LxPt30HG6A9qGicPPmSwUDubQFA2D5zBSLO2jq
	 oZi8G2hRwvOpkhyIt4F/cX2r5HbwH5ITk7ZWHxB9LrXWR6w9QYZGsSGdIW+UQTt9rL
	 EOQ+S63htwEV/veE+Moi8ecIDP6WHQvXlRFrLvw2q+8uzfVq+m5lj94H5oc1JXAiIR
	 yioz/2yhUIwbp2FcscmdFPS9D/EfDfC+z1691Ycaj0vXo4zju1ADuLpLgny38G5sEy
	 dp5pAOYctwKt/HKvlfEXhEo1cLie8WihfnUcjkKUa/tyMX5xonS6Uc9NPCt/8I0gCb
	 wF61DPm2msXew==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Wed, 11 Nov 2026 18:13:22 +0000
Subject: [PATCH 08/13] mm/migrate_device: fix ksmd oops on a migrated KSM
 page
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261111-mason-migrate-et-al-fixes-v1-8-3d2454362e8d@kernel.org>
References: <20261111-mason-migrate-et-al-fixes-v1-0-3d2454362e8d@kernel.org>
In-Reply-To: <20261111-mason-migrate-et-al-fixes-v1-0-3d2454362e8d@kernel.org>
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
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=1396; i=ljs@kernel.org;
 h=from:subject:message-id; bh=a2nM5nYZYqHBeImIwabwKtGvLlr/iYuSs+KhVwYHkrQ=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLK+bMjW/fH5seTsZY377rZ/cdzgfHf1r9Pnjh6YE9Gwf
 FFC5tyH9zpKWRjEuBhkxRRZnn8R3x8kEjav84K/G8wcViaQIQxcnAIwkehAhv+Vytnz/JS1RGX7
 7suXrb/xL/Lx7Jg1QZx3zB6LNPC61K1iZHin25NzzX2imY4Ic4sGs/rs/osaatdEllQu3xE74Z/
 qR34A
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Stat-Signature: 5mkw4a9zqgcbn7kk15zeuy8nibsm9r7j
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 00CCA100006
X-HE-Tag: 1794420928-221829
X-HE-Meta: U2FsdGVkX19IwwZwbiESG2UpqG/BE9/KbBazclBH4btyOjstqZeWXJqDZej25DeZZTxAvjw6dIuTEauSEVft1UYZWUbcQ4fLybmeT24zvYvPhzCBz8/lC6ocMq9jDtAGZQ2NaGKgeS3XFldPtjR9YIiLQwLGAT370JEQ6RxaK8uSbhMhXCRvTp79MWyYT9mf5d6LWt9Ws0Y0w92oEtajzNrO3Ak88RhIj0Bt8GGLDginhRJnSrwSA8SvdJKw3v5ZHWxiKyDp0hKLvySGj47R0fTjLCCQCavxRnIr3d1XEwLOCMztOUfSYr9SxbmHBKJvoCYdCNkXf0XB8Y7g64LW/o93xrYKmtY9ggBw16Mc0C0fwTTW/r6q86OvzqWcLx4fyn71dajGbeAVvoU6uRmq0P3dPDThoF6Q+rQsIbX3eZFFLF0k42oB33K8d+iufDJKHVZtOCJhisX4jmP64Qvs3u3DG+mCmF9A4PmeR1EwkVZdrP3RD++2tna84k0PJi4Z4NCFECbc4yNPrp2pi1NfBeVAj1Boww3kkKFQklw7r7Hc0PcvnPit8QeJtUijgmiJ5webOcHVZ3QN3NB2pZNBm5+bl0Ewz0/hGAddX2tBxA/AMgLVTJ1uK6YSai95Qn2SXDtIzvEUjAHBqM17SyEBJz/Nn75mb3kLKHE82St9ZF2BpM4wC4sGl42D4C5q+HByttskL2McdScb/DvtK/L4lGx5+O66x2KFADtm/ws8Zvp1SlmKE24MtvFtQEKp9jJ+cqHtd6MkYxYVFY3llftCNMpJbzp1rnyBrAiYan5+j8bZzwSRqMJxTc6e30VzkuTejVuNwsYeS1EBwPMzhbfAUXLIdJJHoAD2cZ5GxGNunqqyVVYRGswZHgpKwkj3SiHxM8nhhd6dpLu2UvH5xTObJYTX0uJ3DUxuLla4w2yjaJxvpPdfHuKN9K/JbUdWH6KH6o+tkqURkHuSwN4WYZM
 1/YMzXn2
 roII/yPl1GvkHiWQd1BUD1f3w9/e00ws0SHpfNXqQbSJMff4Rb1vPpvN0YmKDWc60Zh/ffEj68QTBqESMMrLXJyD/weFrMNaPeL17FnLZYrDGg58T30384D3s8MMNItPOtyWU/lCm0nqLb1Dui7ozBdomqo9zxNhx8MHCK0070zY9EKGBLo5ggWuk5vIP0zcWeUCMV56tR6XzWRUugSwGw6XvYxFiyGRMtVfqyh7AedbmzOEjm0XM1dM6mKuNfnlWuNxZHL5cW/S+omu55lkZ34i3Y89EuNiHW1MRqzlQyIinoGnS1D1njT5qLfR5H+n28EqY5QY1gTYewGJyrR+li4vT6t8pnr1lWJZbkYPid0UiidircKpKy/hqYZEyxtotBB3ycBTjSXK+SJ+ZUck190+svQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Chris Mason <mason@kernel.org>

After a KSM page is migrated to device private memory, ksmd can oops,
and KSM then stops until reboot. A process that maps the page can also
loop in page faults when it next accesses the page.

The problem arises because KSM doesn't know not to try to look at device
private memory that does not exist in the direct map.

Disallow this from happening by explicitly testing for this scenario in
__migrate_device_pages().

Fixes: a5430dda8a3a ("mm/migrate: support un-addressable ZONE_DEVICE page in migration")
Cc: <stable@vger.kernel.org>
Signed-off-by: Chris Mason <mason@kernel.org>
[ ljs: tweak commit message, comment ]
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/migrate_device.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index 45e571dbfb4c..7ebd02ec303b 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -1205,6 +1205,15 @@ static void __migrate_device_pages(unsigned long *src_pfns,
 		}
 
 
+		/*
+		 * KSM doesn't know not to try to read device private pages, so
+		 * disallow the combination.
+		 */
+		if (folio_is_device_private(newfolio) && folio_test_ksm(folio)) {
+			src_pfns[i] &= ~MIGRATE_PFN_MIGRATE;
+			goto next;
+		}
+
 		if (folio_is_device_private(newfolio) ||
 		    folio_is_device_coherent(newfolio)) {
 			if (mapping) {

-- 
2.56.0


