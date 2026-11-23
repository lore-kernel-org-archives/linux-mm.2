Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E8E7606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 16:33:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=avWOfd39
Received: by kanga.kvack.org (Postfix)
	id 574B76B05C9; Mon, 23 Nov 2026 11:33:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 508026B05CA; Mon, 23 Nov 2026 11:33:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C64E6B05CB; Mon, 23 Nov 2026 11:33:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1622B6B05C9
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 11:33:30 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8AA6D140956
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 16:33:29 +0000 (UTC)
X-FDA: 85466929338.18.78F1448
Received: from mta0.migadu.com (out-242.mta0.migadu.com [91.218.175.242])
	by imf01.hostedemail.com (Postfix) with ESMTP id 9F31C40007
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 16:33:27 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=avWOfd39;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf01.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.242 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795451607;
	b=U3Ho4w4J9pyZY1ilHmQndmethuPM4a5Sk7HXNaAEheOXhvjC/uH928J1YLCmCJcxgATOSK
	ZmEFnGSMfLOVtPMVWpzwHTKzwbYKytHL3t5Q8pZZRYXnkVCdZ86OcFV/EpwF0x7atWgxwi
	vAJEbykOxhXNOPlwth4wz1MVCah/BZ0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795451607;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G976aLSquKCcdH7Ogl2LQAUo5cChr1sJGUGr2ohKZsw=;
	b=ywQVBdt0FsB3ZR+aViOcBdAmVaI61g48Xs96n2pvsVOPztuAWa/0JD/UycYGvqBizfKZ4w
	MZbRLcReQdcNeKE/Q0R8MXJng7rK0puJH5U9eciAwPIN8Dj2SdFfh7tJQyHx55V9h5q1kt
	+iKrRsq7Kud9jwn24Qp1HZ9nUR4TQgM=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=avWOfd39;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf01.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.242 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=E4KTVYZa4EaH7tbY0q+Km6luC5aM7T4+GRj8B16qzEE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795451606; v=1; x=1796056406;
 b=avWOfd39qP9lzharrqkv8HwVHT/fQxcsZsUkIKNgCDSrmwm7bUJYTrFsRtyf8LqRVdD8N5od
 2upxCkL/O2fcaTLz7z578VWz+qkyzwWf3TbOhGPmi1z7dCDWKtnzXLwmHY7BhBF2P3p9fU8y6dP
 LRYs1q72llpk0k6iEA1/9ZTI=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id a33978e7f9751d3e;
	Mon, 23 Nov 2026 16:33:26 +0000
X-Mizu-Trace-ID: a33978e7f9751d3e
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	apopple@nvidia.com,
	byungchul@sk.com,
	david@kernel.org,
	gourry@gourry.net,
	jannh@google.com,
	joshua.hahnjy@gmail.com,
	liam@infradead.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	matthew.brost@intel.com,
	mhocko@suse.com,
	pfalcato@suse.de,
	rppt@kernel.org,
	surenb@google.com,
	vbabka@kernel.org,
	ying.huang@linux.alibaba.com,
	ziy@nvidia.com,
	kas@kernel.org,
	hannes@cmpxchg.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	kernel-team@meta.com,
	baolin.wang@linux.alibaba.com,
	Nico Pache <nico.pache@linux.dev>,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev
Cc: Usama Arif <usama.arif@linux.dev>,
	stable@vger.kernel.org
Subject: [PATCH v3 5/5] fs/proc/task_mmu: account device-private PMDs as present in smaps
Date: Mon, 23 Nov 2026 08:32:11 -0800
Message-ID: <20261123163301.1568240-6-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.1
In-Reply-To: <20261123163301.1568240-1-usama.arif@linux.dev>
References: <20261123163301.1568240-1-usama.arif@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspam-User:
X-Rspamd-Queue-Id: 9F31C40007
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 1uwyg4666p8qkcq9fcau1zzrxfaafics
X-HE-Tag: 1795451607-435891
X-HE-Meta: U2FsdGVkX18HkcfEJrOvnGJy6Mt0CfiJoi4UqNxzINlBb6DuDfIa/gGLk0cLj98vTxKZVP6r+AibwyBnEuJQI8Cu+nk6VBOAvrNNyg5Ri8AJ0N4e8nGRmCAtZLbgk2BdptSeL1rNYrUb8Me2QDurm3m0LL9eo18RhfpJ8aHz7gLSXTlQiRnzg6uQIyPQtXx6HVx+vsXMF9nh4A+p1r7MdDFQaXqotMnKcnRTUFduOMFlHhTZNBSt7ySpOyT+wZYaXCAtjJ+HsW9PA3BCwJv1Ne/YF5B6IwUk5uwTbWmdC8EffmW4soA5pJ6VRq1x8nYA24l0j/InuNZCAg4uyPZX5R10bI57ulsdwcy4m9/SD7zSnW0sIVH5ArvLycFASpp+iCbJKdABql7I613urqQtsILQmDEVvV1pYZzWCHL19o8mIVAnky/Qy1T6VWTSJ5bTA9CJJZ+s0dF2Z4OGpLBe1WpMtviwfTQQ9eTOgSaGwQibEmN4WQqOV9JKOSMunjITpM+XQOg2BhcJapyUun7pqfNDePLz7iA3Hxz8CgdtudSWt+U1Y6Sm+ra76Av3TGkHguVvx6LK0LMVFtnaWk8Qqa8ib3id3s8aZZDfJbfnWY4n7eM+rysM4vV8aH2nXQ4PBPx7usI66lzLexW7GHj0Hpj26qvb/OvfArNC3Ibh3eRCXU1eSUY9ObcdbQp2pmZ1ul+mxwU8ykDn3ozQNbTPvJgzRQAEqoMmtypHjftA/EgD1LYgMvkPI0JmqcpxfrxWAtHVxwS0u4J3+SoDK95atfHayb2TiYtivltjLBHjQIIzrhWbMJO6nGdD2znr6Ds6aItyMtENBGUvNs4D81JmMaca49Iw78aMsw7cI8YQWq7ZWgCMvPX330Thn6y71/w/hxKPNPMtyeSoeOdFNt99FHjvZIO9dsx25FIDzVsVDlceFJN6uVIQhQzT0i6DGtgEPwx2cbm/pirFj4orNEU
 DP+dgF7E
 LH617yxhBZHjU6OpID0EsKF7CDqhCDhoyFm15x8vMKzvQcPRAK/jf9JVnswRQNxr8KlQHim722OlTNRPVGbEJmIT2Fh1mgOw7LmprJWEQIKYQct8DR2Pd3/KoAzdRBC2kzHWuOaOkBTKI5kTlVJdTxdivUYOYIazbEtk3NPHog6Tj0kh1tHzrpOWWssCsfC7Zyofk+VpybEuaLyhrz9mMLgchOEMcWPzFy1c1q2CpHbYqmt7ujdfH8N4iZPG7/tAiz3nodeU9TdO6SF7AbYojfhF6yGz+sLCPsq5E+HETkQrtLqzed7SPGKKPHehhkGtPJgAKQTJAIjxXWB9V0R8StdQxJEVvT3ePHjN4zO2lpr1Z8F9CCiuiEznZAvqVyfoXcJVmHPf+bIMx9fEMJvmruY4APbwX/Prtx7qJbmTXiQ03nYjuxyL8peXNZh20b/Sz1tKSkYSaODp8wD3YDh98EjVzhRUL2tbV+rR61nfS5iiuMeogM7yKZXF2k91ZCCCrmIw2kg4H0J5FWOVukLOTof/PctQLwnmba3VveGA14yI+hhMv/OpG+N6JaOP+EtE4Oaas9deJtXptouhWv9HXvAIAalMI9MsuFEvM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Device-private PMDs represent mapped pages, but smaps_pmd_entry()
passes present=false to smaps_account(). That treats them like migration
entries: mapcounts are ignored, PSS is charged in full, and exclusive
mappings are accounted as shared.

Match smaps_pte_entry() and mark device-private PMDs as present so
smaps_account() uses mapcounts for PSS and private/shared accounting.

Fixes: a30b48bf1b24 ("mm/migrate_device: implement THP migration of zone device pages")
Cc: stable@vger.kernel.org
Signed-off-by: Usama Arif <usama.arif@linux.dev>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 fs/proc/task_mmu.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 34aaf80cd46cc2..fd32840a8cd7c3 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -1034,8 +1034,11 @@ static void smaps_pmd_entry(pmd_t *pmd, unsigned long addr,
 	} else if (unlikely(thp_migration_supported())) {
 		const softleaf_t entry = softleaf_from_pmd(pmdval);
 
-		if (softleaf_has_pfn(entry))
+		if (softleaf_has_pfn(entry)) {
+			if (softleaf_is_device_private(entry))
+				present = true;
 			page = softleaf_to_page(entry);
+		}
 	}
 	if (IS_ERR_OR_NULL(page))
 		return;
-- 
2.53.1-Meta


