Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 463D660A3820
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 13:05:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Kp9s8TDt
Received: by kanga.kvack.org (Postfix)
	id 532D66B0735; Tue, 27 Oct 2026 09:05:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50A396B0737; Tue, 27 Oct 2026 09:05:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 447596B0738; Tue, 27 Oct 2026 09:05:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1C3C16B0735
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 09:05:17 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9C389C09E5
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 13:05:16 +0000 (UTC)
X-FDA: 85368427032.07.92A76D3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id BE4A61C0004
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 13:05:14 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Kp9s8TDt;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793106314;
	b=aieI3leK4WczrgswTfeMQRbs9xYjYTYDIT5uObT5Wrq8zY3g6cT+9ic5v/40knrFyC8+h6
	kvmJFkKcCV64BGRf9FHGj2UsKAwL9Ho3qrYscMgzCpRlGRPrkPiqrFrdMvyBmopCwoGggS
	uFbNwePTI6ALTzfLjG/JJA5zjMqMxl0=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Kp9s8TDt;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793106314;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UKWfg6nXMEPTxXujUYzfp00rWiuxfD1JI+7Tq1SH2b8=;
	b=TDDMtgKDyRUsVa9zHWsSEXkrfxFSLe+E+4VSofihfWzF28DIba0x9tQQVQWsWUWW3Hpn3P
	hVSAaQxD3H+qdV3mNs2HRHjxmq0NjQ45H15Ot6vVdMW0Dz6cBZAQKmtuliMFhuItqtfiHy
	QPa9BbqE8ipag9zv0lEtSFuKchKXiDA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 20BB643A69;
	Tue, 27 Oct 2026 13:05:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EB9E1F01825;
	Tue, 27 Oct 2026 13:05:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793106314;
	bh=UKWfg6nXMEPTxXujUYzfp00rWiuxfD1JI+7Tq1SH2b8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Kp9s8TDta9bR85RsgT6BZ+ZVbkIwImQjtt+GAaCwxk6heK7vDx653LYrsHkwhXSUM
	 4eyDrjRmVpk0METZ4Np8f4rqJ9dx8e5+fNkunjb7do92JUh5oOa0Bh7KMHmOEPtSzG
	 19InT/xTJdtBLOmOs0BdyIY44HXIdGZCTeXIMnSbgGFDBJ/6cZl2ZfdGpNF0kPuKTG
	 hNpwOZj3KGf453gc1NBIevm7pIfxW9qBNQ+B8xnTKsfcHo700lKsM2Cw7Q9uV75Chw
	 2dYhIBo2Jxz9IIePMFzS5yYnzzlqKPEl1hmSB9MFnfQtuMRyPtkMuxkw6hqQeCJ66I
	 GPqm4S9a76eCw==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Tue, 27 Oct 2026 14:03:19 +0100
Subject: [PATCH v2 14/14] mm/shmem: fix truncation of files containing only
 swapin-error markers
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261027-fixes_shmem-v2-14-86a00952acb9@kernel.org>
References: <20261027-fixes_shmem-v2-0-86a00952acb9@kernel.org>
In-Reply-To: <20261027-fixes_shmem-v2-0-86a00952acb9@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Gregory Price <gourry@gourry.net>, Zi Yan <ziy@nvidia.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, 
 Vladimir Davydov <vdavydov.dev@gmail.com>, Michal Hocko <mhocko@suse.com>, 
 Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Lukas Czerner <lczerner@redhat.com>, Carlos Maiolino <cmaiolino@redhat.com>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 Daniel Verkamp <dverkamp@chromium.org>, Jeff Xu <jeffxu@google.com>, 
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 David Stevens <stevensd@chromium.org>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 William Kucharski <william.kucharski@oracle.com>, 
 Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
 Nhat Pham <nphamcs@gmail.com>, Miaohe Lin <linmiaohe@huawei.com>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 "David Hildenbrand (Arm)" <david@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1547; i=david@kernel.org;
 h=from:subject:message-id; bh=i3hN4RE7liAW06y2OgRE+JIRMBR8d+B3ALKw3Lw9zRQ=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLIeLBSKP814sdEoLk21M/PRD6GVt9LFl3/Sibj4n3HZS
 fvS3A8rOkpZGMQ4GGTFFFmCgu8bvHy5rrbajY8ZZg4rE8gQBi5OAZjIhacM/z0L5r8L6+j0YpNR
 j6n8mtGpeDq8me9LevOHw392aT2yu83wvyrAf3fGP/n5wa8/6dmeKeruEbjtEct88lbS735FbZd
 bLAA=
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Stat-Signature: ju4739getgnmwtqsi5wib7eow9fksh3p
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: BE4A61C0004
X-Rspam-User: 
X-HE-Tag: 1793106314-783292
X-HE-Meta: U2FsdGVkX19CUlTm1yw4IeOODR5lxp4KnNPDtSk+IYLgB52K5HyO/4Q8zhoZZ8PsycG6KX9TU+5KtRUlwcTFMfjASkWXZxZYsmfCfuhcHRSqdrq8GLYGJ7YD82RI+9kwwFFMIYD67n1a74Gp7MjR+atoEvVc4vYs4MflxDqE4I8ewUmgt7MAmY4Z1g8ccmTgoOf12K9OukRs+CMBlIWi+KN/eAbzsUitaQy1UsmsgMjzggvJa2N2gA/4Yq4/8aIY4OXcjARiBli/6+FVdZ4pB++0nvrXpo+FrWt63Pn+T59GdP85Lb6CwKmPP78A282846BoSTyMEQc+XIj6wrP4gcEpyGc+3KuGd6Fge90leltCXkdJM5C6Tkh39KIZU0Im6esJO8bLjinAdPR8cg79l86v4i1sSG95t9nVaBWdsPaEfEHu6MYfH3aJD77cARwwaUMds0zX9iwUGtthbnz0LP1pkvD6v2lQ31LnCIQzmGYpvPR3h2ebtgcOtnGHBcAtzAcIlOJs8ozrAXNfXqAEI23nlSoPPMcPU4SLuqhkitsadDmw2xY2jV9nCV1MbeYY/YmWXDFfxg3hNHt2VRJ0yFVMbYdG52Ln5YECq8ejNPZ0vKXC1crFpgeT3+5z4nT8CVUQm0S5vwbGW6IGNjpKkC8ryNNp5G52s/uUXVPbMy5nNmIlS1aoAriErTp2V7uM1XjifMKUBdarR/Bt3S/LAwHZjT3enySeXlFJ8Rnkzd45ToM78IyOIa+MGKPupKSzh1bdFxROKZNjicrQQH6ldHrLJX0/l19AJUGQBDI6FHSPVX7hfjKTH4Yg/LePW0iORJ/wcMteATZjDoh0B29dKLuiwU84WCCqkH11ccBtIY86/x2akO6EMpFEBLMh2mNg9UVdFjKT6yePZNSGJrLr0SCFcPwXHNJ0sHKk/exSPmFmMNk+iU25mn2DYs4GlmiorWKEbDcN799evcB+yCm
 JWlJjehO
 mStIE0FHFe64h4HxM4V7N90ZgwnHYePYM+IpTdbVxknNaDy/I+JCP9xsIuxpL0kltQ/0LCv/lgSmLvSVw5pRmVuK3s30qVyScbCnpwRJEZz1lkEvpSAVYYDiwZ9RFqJ8KfM0uE0x9MQT1e9ucTgC/YvM0xlJ1y+WR6Nr4aqWMImD7ytPx4IKqeEkKca16smZpPDI81yqwDBzMtynTaIxeUyWbxIjfYYv4RNJcFffPZKiIXr71+NkE2I3iZSnqb6tuyQKj6Zgsd1kguz6mZ3fIgwFRpBnX65rIsYx4b2k5dNGBx01zk26EMPuwdhuk4EKGMCvtGJ8+wd2dN41s2Mov5pSGPDTrbrQFhGRC8qaqYDlRbR8rFv6gck14YC7ZZgfPcuhf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

It might not be very common, but we can end up with shmem files that are
composed only of swapin-error/poison markers.

Such markers are not counted in info->alloced. Consequently,
shmem_setattr() can skip shmem_truncate_range(), leaving the markers
behind.

Truncating the file to zero and growing it again will result in reads
failing with -EIO instead of returning zeroes.

Check whether the mapping contains entries, in addition to
info->alloced, before skipping the truncation. Keep the info->alloced
check so that shmem_recalc_inode(), called at the end of
shmem_undo_range(), can fix up accounting after reclaim has emptied the
mapping.

Fixes: 6cec2b95dadf ("mm/shmem: fix infinite loop when swap in shmem error at swapoff time")
Cc: stable@vger.kernel.org
Tested-by: Gregory Price (Meta) <gourry@gourry.net>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/shmem.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 2800dbdf031c1..3c42b4f253b5e 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1591,7 +1591,8 @@ static int shmem_setattr(struct mnt_idmap *idmap,
 			if (oldsize > holebegin)
 				unmap_mapping_range(inode->i_mapping,
 							holebegin, 0, 1);
-			if (info->alloced)
+			/* Swapin-error markers are not counted in alloced. */
+			if (info->alloced || !mapping_empty(inode->i_mapping))
 				shmem_truncate_range(inode,
 							newsize, (loff_t)-1);
 			/* unmap again to remove racily COWed private pages */

-- 
2.43.0


