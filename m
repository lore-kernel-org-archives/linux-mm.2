Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 063D4D1F9AE
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 10:29:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 471786B0005; Thu,  4 Dec 2025 05:29:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 449866B0006; Thu,  4 Dec 2025 05:29:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 386186B0029; Thu,  4 Dec 2025 05:29:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 29CC66B0005
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 05:29:14 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C8F358ADDD
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 10:29:13 +0000 (UTC)
X-FDA: 84181416186.15.DC42FB1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 3454010000B
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 10:29:12 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hnXmuWgL;
	spf=pass (imf05.hostedemail.com: domain of arnd@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=arnd@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764844152;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=HD0fJNADI/Yv/yEQkDMP1E7lq4lFkbKe4pu4Whoy45A=;
	b=IBXdUpjheIR9Ws0Jv4VXUy1pCDVaLTulGUpgUOYdIXii65jQVF5nbeyiJIFQfXVD5GCjq6
	uvejp42rvUlxZ+D5vgqUbK7cVDyiTJ7aBzXQP6Qy+TK3/i9miU+PGWJ+NjmUCoCqjGjNue
	NjrmNI8k4G8+PagRZTLhbf8h1+ewrCU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764844152; a=rsa-sha256;
	cv=none;
	b=RVdnJbBqQbjJP0u7Jaqb/HwGkr6OGHaCkcrWAdGlt29vxzGsROnhU+70gr7tkufqkSAJQm
	8W/g+tskf5mYi+mOQhHp+O+QnZUJV+8T5nRyR0CEiPkAuIIqsE04oOs5sPRUVOz6TLzkEj
	sXja6hZ1cOB71tvIiy6xHd3CS6rhxTk=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hnXmuWgL;
	spf=pass (imf05.hostedemail.com: domain of arnd@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=arnd@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2BC8F41852;
	Thu,  4 Dec 2025 10:29:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04B90C4CEFB;
	Thu,  4 Dec 2025 10:29:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764844151;
	bh=nBfm1dfOD97fqzYEFk9S6US8GrxwEUH38I9rnFIfWew=;
	h=From:To:Cc:Subject:Date:From;
	b=hnXmuWgLvLI96wwkQMf2nhQH/KyDNSfMqK8aydg0RnUBFZt4jsTrtTM8fr2LlrG7Q
	 rv6uQ1TJDt1dX76FCOAq1mmhPvqwP1k2dfIk/tinVFV17VINhxasY4mH7emsTlQVZ+
	 Od8GQ2bHBNT8qxjyMn4NDnI11d17oLPt702zByRi/iCyhFcDpqme3Ot0BZGiDHzqD7
	 5XKxocPi3Ge/z6eyzEz76lYnKpWra6NCfd3VARUMwMFE5gxoEMwoimgffid72WUziG
	 +RsCojDPd6c2UNyLXPn/U+BIB9kZJM9ny95urBvLssJaKV2uXI1M/dqTvWOBJBhCd6
	 8S5EEcE5yBKpA==
From: Arnd Bergmann <arnd@kernel.org>
To: Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Pratyush Yadav <pratyush@kernel.org>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Kairui Song <kasong@tencent.com>,
	David Hildenbrand <david@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Guo Weikang <guoweikang.kernel@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] [v2] mm: shmem: avoid build warning for CONFIG_SHMEM=n
Date: Thu,  4 Dec 2025 11:28:59 +0100
Message-Id: <20251204102905.1048000-1-arnd@kernel.org>
X-Mailer: git-send-email 2.39.5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3454010000B
X-Stat-Signature: nk5m4xib5fe79iwce45ydmwy1d449bxa
X-Rspam-User: 
X-HE-Tag: 1764844152-639927
X-HE-Meta: U2FsdGVkX1+caPg6dhyn7FuniiiCdoU2vUrhtFm/f9LQM2RkkTt6eaN8AcyTBtMgtIM8LsNnfmlFMRY2/O42TaVUWWBCgATpjz3IpqFkilRDiiuaD/kGOCVfbHtMMD7eBMX6b44sBvzBAi1QBG73u59BvmhxKazxSjejddG82W4Dt9nrM6gIM4mHJDsQRg6BRcis7FtECF1FyZAOmT0bWhvPpU7PbyOqemSby0QEH7LstCj2Car+x2nstxQhtHdvhPIk0SbeZl5p2Y4ogJ1EknJD8WgVdo9ViAs6wBbDPVtqdF1WGu6udjS9mU0O0Q8A6kkuI8xu9jEF3rrrmjKzk8eM7GuQGm0C+mai41WHJpICznbxtxEg/JuTqUq53LQaOvaMp2cpaCDJ0wkByCfr4j+siOh15vC9N+6DvWrJ0Gh4k43dTc66d1+ezOMmDHHKMIB0sQQhK33ELBdCYBohIA/uxPtgVK4DE7LPpJ8XPvUR2voL6tpJE9OPq0g1T0Hmy+0QQP5tt5x+F8Dac47rVIsx/uCTHi9qmboVmVjlc8B5mXPpxXxHWCjgwDRLP+X0EnvzupR+McrelNd4ZOY4/r8X7HUnF4pWSrb7LmvQHqRP8LvS0QKAjjD2o40TUsXhlLIhY7rXBJMbK4x4/Kcco8OUCVS73OAIvMvBMa+gQ0BRNBNkOLcsdf9V83QRwEax9+qi0nfnO+yebwtHGqK+jeTzBvzo9S3vpby7pVhmZnV3FfCk727sbgSMXrf9ecf6AhSfuJrh4+Ug76DF6tY8zqkQfAvF77hHTIzfT4PQ/zr08mynqw8rujBfGXeX49R8fjTYxXg7ZqKp3QdwatAqq/bvspB3Fu/dCbnAiiWZkcv3sn/NQK8WO896uJWS7OECTRkzwDq+tO8TJedJMFv+2nOzdtSsFNaNZ1ta8lWKTCPizy/T/9fwcuzCNYibyeDoApa1emRatgZH93cth2h
 CtqwDx56
 eFCCwii7U0rrROehgabXyCM7APkKwfORvekGILM8FEbNgU4aBTL3BdiOL3a6L5F7XeHHiET25OBFhwdZeCupcevqwHlTZpv958yvGUwYlsHEbbidJHxuoY8n4RhucjjzRzqOFx3EwYpA/aWv0YbKUj+FY73Vtj0ghL+pjJ7ONP/x5/kFYiiriOT+FeokBC+7jMvEZS/EbCM2svJb7/zIZq6u+homHDWE9lMOi4lgAFx4w9JNdw1smEfwelwtidxL0dGC5FKzoSS0rJdk7O5HP/hVBMEobdW4omOIMn/EG3ej46iayFzxI3fQgupAGCNCsOVXIKic60LBtFKApKCzyMjdTi9c/X9WEQMRCTFBuGaxQqfY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Arnd Bergmann <arnd@arndb.de>

The newly added 'flags' variable is unused and causes a warning if
CONFIG_SHMEM is disabled, since the shmem_acct_size() macro it is passed
into does nothing:

mm/shmem.c: In function '__shmem_file_setup':
mm/shmem.c:5816:23: error: unused variable 'flags' [-Werror=unused-variable]
 5816 |         unsigned long flags = (vm_flags & VM_NORESERVE) ? SHMEM_F_NORESERVE : 0;
      |                       ^~~~~

Replace the two macros with equivalent inline functions tto get the
argument checking.

Fixes: 6ff1610ced56 ("mm: shmem: use SHMEM_F_* flags instead of VM_* flags")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
v2: make shmem_unacct_size() inline as well.
---
 mm/shmem.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 3f194c9842a8..b329b5302c48 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -5794,8 +5794,15 @@ EXPORT_SYMBOL_GPL(shmem_truncate_range);
 #define shmem_vm_ops				generic_file_vm_ops
 #define shmem_anon_vm_ops			generic_file_vm_ops
 #define shmem_file_operations			ramfs_file_operations
-#define shmem_acct_size(flags, size)		0
-#define shmem_unacct_size(flags, size)		do {} while (0)
+
+static inline int shmem_acct_size(unsigned long flags, loff_t size)
+{
+	return 0;
+}
+
+static inline void shmem_unacct_size(unsigned long flags, loff_t size)
+{
+}
 
 static inline struct inode *shmem_get_inode(struct mnt_idmap *idmap,
 				struct super_block *sb, struct inode *dir,
-- 
2.39.5


