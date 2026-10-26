Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99900606A33E
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 09:41:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=K4LABUZ1
Received: by kanga.kvack.org (Postfix)
	id 05C456B05BF; Mon, 26 Oct 2026 05:41:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F27A56B05C0; Mon, 26 Oct 2026 05:41:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E3E1A6B05C1; Mon, 26 Oct 2026 05:41:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B00756B05BF
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 05:41:28 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2DF2E140670
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 09:41:28 +0000 (UTC)
X-FDA: 85364284656.08.375CF0D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 6E19840008
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 09:41:26 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=K4LABUZ1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793007686;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YaZhyWbI3ktAmMGrrtBIt8obKZUr9PxAavcai11wXso=;
	b=XO3hkfQ40rAIGzLbjHcrqJjiK7RsSsCb1PdXZcYhxEK3NMj1SV5hB+mc2YsmXOW6QXXqU+
	xLOERipijSIqIdK1TkxJzr5Qmn91MO8WzVfL4ZCtVJHzuUzMszvHTvg0smxMNZuDRpaNlM
	tKHXDEBYQuM5z7SHuIbdJByPP1pQWII=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=K4LABUZ1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793007686;
	b=6VqMajfkDnbr9W6ErvYPjhgnB7iKeISN/JF4+z2ePLBFOgeM8xTNwc4QWcSZ0W1tD9gCr1
	oJZx7gOTNnU1s2xBKG8byCKPeQr430bKSDlW/97g/UIwP3FhGkYeQciOeHL59eNS1m7QAF
	httrgpaCTTD1b5bV8djrlj2HMlqNwFg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 085CF60A6B;
	Mon, 26 Oct 2026 09:41:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FFE71F031E0;
	Mon, 26 Oct 2026 09:41:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793007685;
	bh=YaZhyWbI3ktAmMGrrtBIt8obKZUr9PxAavcai11wXso=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=K4LABUZ1R6fm6pCLxTBXBqb+67n74mLwr2RL9z5T6vK6VjiKMgh7M5qkz9U0+120U
	 /HqYX6PCk8d8PFzthXLiGQ4SL+5/d2wDDHlK8aHPJp+EwrQh53Km1bZU3VPBi+OABg
	 edn9Sa1cv44sN4jdWmJCwvOkDNlKtcg418bSppAzFKIbhoNm0o2Xsw/tk/BKvdYhLN
	 x7mWsogUFJTuzG10z7zYI61SVsd3djnuqMz8lNQGLU28xunGln+PTNhykQeEmH+ofO
	 0rmtbZM+E6+G2AG2c0jokbLE83qRiVzTxQw1HIX2dK1jQsQOiAVvBDYLCsDMfaioqV
	 LydIXbZHtRUQg==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Mon, 26 Oct 2026 10:40:38 +0100
Subject: [PATCH 05/16] hugetlbfs: enforce F_SEAL_EXEC in setattr
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261026-fixes_shmem-v1-5-703206d5fa0c@kernel.org>
References: <20261026-fixes_shmem-v1-0-703206d5fa0c@kernel.org>
In-Reply-To: <20261026-fixes_shmem-v1-0-703206d5fa0c@kernel.org>
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
 "David Hildenbrand (Arm)" <david@kernel.org>, 
 Eva Kurchatova <eva.kurchatova@virtuozzo.com>, stable@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1654; i=david@kernel.org;
 h=from:subject:message-id; bh=mQC3JDF7WRonbAYulIb7hDyzHoAE2NMEfNgcNDI1FcU=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLLuK4jlaPp9e/3q27LwB28awq4dSticITuhinubqKDih
 A3aASWJHaUsDGIcDLJiiixBwfcNXr5cV1vtxscMM4eVCWQIAxenAEyk8CvDb7bwhxIXfvk5MlxX
 SKrZIeu0wNDiStznj+ejYtze/Xy0sofhf21rR3XZkYvpOsF7GC/NtmRY+ubWtkX+G1q5NOV9Z+Y
 v5wIA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Queue-Id: 6E19840008
X-Stat-Signature: heighcskfrpw1k5bkh13mqi1obwhhuyt
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793007686-117520
X-HE-Meta: U2FsdGVkX19cBYV4RZGCYHUP5EvZbvyjVuuLYZuyNUeuNV62J1oHiI8dEKK9osFwwSzTM6ZqoycBKpaNyxiqOkoqZoIIrFP4KcgB7sG6ALVD+zQtsDfVqgM+2TPhT6fVzd/sQwTAyZUq1f+JT7MeXD8nRztUT91GcigkpoAPtKKnGVKx4sc5ZNQyO1zDyvU05sXi87C61Cg1s50YKAWR/v6NHo/2dyyzKYTz/TXzvuQcQ4GMZgSrx6ljT9XoTGsiGhdS3OL8f1rUFzeOua4HAGphtvVdDqB44MOtZu36TAKg762nvpVRYfUCCPmO2AQk1k0wgwD16kkJx7wxdF1ZY9FC2SAkDL83kDT12Do00Brqp0UkjFzjULryHv/zdzUJsvn3RmPcpxGYlAIdFz4hMywChkv+KO4lpnwikil7IBd8sHOPC9VkC10d7FU/UC4LDdO9Q/bobeUQtoLRgX+5jB/quOe0XMADPGp7VAggujMu/dqMlGasTWaGuZWgL2F8tH2mC2BZkFU55WdQw404qskQw3pN8bjwTw3md+52Zwu7s0cTJA7G2F51bayf+YeF9p9Ou1IS945I4x5Z8wjtnvW4oZHpDNPARwGCodeuGuT4Fy7fk7OxBul9eA4AGJ6kMg4fO9ArSZujBhT77vkSnO8S4VSgSLPZKlN3UbdZPFsfR7VVkddI252ugToAFPDrOkHTfe2N3pfTgNt8qdrSS2ccbHta4oWrRIzMJYVrHPWKHbWav6i8rdk06I4gNtD3Xl6zFZV9EpTFio+a6RhQLj9g9+JubhyvUu1iH0T7PJmLRbgkX64S9iJwdTsM6uMTGlanojgUSpphxu4EQqzIjE1P1ra7bmDpHabQqtysg/k06RBPojZ0ySx/h6L8B9NJnYb7dEvYjKwct2/EuHm9T6nSwixvx4XcJgkDbASax7Zg0VsvdXMOCAM39QpzdrWq3B6Ae7g5QiYpWxOfO31
 fojFQKtw
 fUWnripGVzQGCaRBlI/CDdo2hdkmwcggCoqH41efk7ZbMy0AFJ0j9mX+o/vc8rGzi2zvgl094ymCn25AbtuPRcYfPMvOhMb5253PeECLZpyWt0bu9t8V+iQCPSa0GhjcJF6rPLqvKCabu081C54FQyWHmAY3cVdxMJ7FVHnkcAv1Hlw/HA+8rlBQ76cAr9B0AvG6UfA9YGDfemhDaxct8Ly/ZElMdf35G6oYGy+xoRmppKu9YyQXQF0G2LGeUl3BU17jcYO4PyVCJDmuNQDJXHjXZ9nFk4szSPqns58glpkItVNkkBgZiWK/X7HFosphs54ZT9LwhMCZjNhSDnaj8W2i5k07EA5f5WC+tIAECCewMggLtKcv/qFf94U1Q71F0jWgoYYHO3UC1htT+UnHJLFTlOZZ5o2nDPIgBzKUPAa39OchBQpSHKlwTo4QzVuJT+DU4HPm5EcZXclvqcCsoQe5C5TH9yeOGLSYPCqFae5S1/pp5zNKBAp3kvT34dQaFm/2H
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Eva Kurchatova <eva.kurchatova@virtuozzo.com>

F_SEAL_EXEC is enforced by shmem_setattr(), but hugetlbfs_setattr() does
not check it. As a result, fchmod() can change the execute bits of a
sealed hugetlbfs memfd.

Use memfd_check_seals_mode() in hugetlbfs_setattr() to reject changes
to execute bits when F_SEAL_EXEC is set.

This also fixes the memfd_test hugetlbfs SEAL-EXEC subtest, where
fchmod() incorrectly succeeded after applying F_SEAL_EXEC.

LLM assistance was used to reuse the helper and revise the description.

Fixes: 6fd7353829ca ("mm/memfd: add F_SEAL_EXEC")
Cc: stable@vger.kernel.org
Signed-off-by: Eva Kurchatova <eva.kurchatova@virtuozzo.com>
Link: https://patch.msgid.link/20260629180247.2343229-1-eva.kurchatova@virtuozzo.com
[ david: use common helper; fixup Fixes: ]
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 fs/hugetlbfs/inode.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 6656807ce4377..7f5c3962b5d56 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -28,6 +28,7 @@
 #include <linux/folio_batch.h>
 #include <linux/fs_parser.h>
 #include <linux/mman.h>
+#include <linux/memfd.h>
 #include <linux/slab.h>
 #include <linux/dnotify.h>
 #include <linux/statfs.h>
@@ -841,6 +842,13 @@ static int hugetlbfs_setattr(const struct mnt_idmap *idmap,
 	if (error)
 		return error;
 
+	if (ia_valid & ATTR_MODE) {
+		error = memfd_check_seals_mode(info->seals, inode->i_mode,
+					       attr->ia_mode);
+		if (error)
+			return error;
+	}
+
 	trace_hugetlbfs_setattr(inode, dentry, attr);
 
 	if (ia_valid & ATTR_SIZE) {

-- 
2.43.0


