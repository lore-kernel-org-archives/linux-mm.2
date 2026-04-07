Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC46DFB5179
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 06:07:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 699F86B0088; Tue,  7 Apr 2026 02:07:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64AE66B0089; Tue,  7 Apr 2026 02:07:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 560AA6B008A; Tue,  7 Apr 2026 02:07:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 46E9E6B0088
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 02:07:52 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 69F051B8736
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 06:07:51 +0000 (UTC)
X-FDA: 84630728742.18.03BCC71
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	by imf14.hostedemail.com (Postfix) with ESMTP id 1B5B4100007
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 06:07:47 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=iuSRKzlJ;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf14.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775542069; a=rsa-sha256;
	cv=none;
	b=ixuAUJhJWMBI3sWhWIi/C0cc2EfK6axW5R3EfhANmbEFkHMk0ynzNPVpoYuo/MTPjdsA7R
	yA6cvsuzjbQ+P/4WChygNSYJhJMkwRx0tXxBeVaHGNhI2ANGdDaKhid3eEOk12yIW9Sz8k
	o859yqF/zYu2k1i1xlxhVPAOV1nAKRc=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=iuSRKzlJ;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf14.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775542069;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=dr/WlAAYQOkNiis0A0/5gkZYDAwsfw4TSX3WTt3umOI=;
	b=lFUB/iSFSSjWaMqIxyRC7cyzjkVRONSfcrg3aJmkyLWicKPI531Mb92u4tRVnhJ8/PzJ7S
	i7xn48sU+gjmWYbhVXSJVyVqHNuYCb0HujoZfh1yx/MyHS5dPn2VdTNmDGZEpZEpkxai+L
	ntIp7pc0KcyzCXcPqLmx7A8y1esVaAk=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1775542061; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=dr/WlAAYQOkNiis0A0/5gkZYDAwsfw4TSX3WTt3umOI=;
	b=iuSRKzlJ4zJmG1bXdL15c1yEPx1tLYJu+yRtSNqqMumiXBJMvIYPw7/sM5CjvKVCOffv8onsPuYegSAsQ+SvxDhN1z16j28BeWqzJydFWtjSIgKbosHY3368y2CzHEDReA5nEXOktj/6PuR1kJwoK0ymqVk7oAAI7UnAo3KXfaA=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R471e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0X0apgMa_1775542059;
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X0apgMa_1775542059 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 07 Apr 2026 14:07:40 +0800
From: Baolin Wang <baolin.wang@linux.alibaba.com>
To: akpm@linux-foundation.org,
	hughd@google.com
Cc: willy@infradead.org,
	ziy@nvidia.com,
	david@kernel.org,
	ljs@kernel.org,
	lance.yang@linux.dev,
	baolin.wang@linux.alibaba.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] mm: shmem: don't set large-order range for internal anonymous shmem mapping
Date: Tue,  7 Apr 2026 14:07:27 +0800
Message-ID: <cd5c563db32507c9c090a0ae8287e1851cb0a5d3.1775541661.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 1B5B4100007
X-Stat-Signature: ad7wkadrosbxg96rctpytag3scua3zr8
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1775542067-283643
X-HE-Meta: U2FsdGVkX1/lAJWE22RYxw6MubQexfK62k1HfnFGY6Sx69CdKNSqI/wZck0/+l+zipBDrSu+GIom6aH6F8A2LOUeo4AoC4xx3BVeEGFPLSIzch22Z0MYwBHuOTfhJDg4AfBqwFEbmVW9P6lWmtWtI4P9O1ykGpYcluJi5H81cHC8JQ8M2Hg0gxx5sDCZET8OqBHZ9dzDfR10kRVLy83w1I7Ddem5y5vSINkCoxl5XmZtxBLPhP1D/dIQDwk0wwnceufLlaW8wdYpi4/jfqoD6I6tWKoOpXZGbfi61+0LO6TlUGDKX17J6PzPmPnmQ+7xRpFqc7HFTvl1KmmxmF3ZbfnyUxsWcH6vNCAgn6vlmdeb+eBm9lgVOET1TaYpIjkrNas3Lfl/PO/egZvyF+sV+epGkVZ08hQNE1I8CwxfeAIZpQmAutr8XguXdMDZbP5ugWhuO1nGbntGjQDeWCOklsu2bg2v0UKFpKnZ6r8uyh/vL9cqh3OeQkI00o+l2e+hHtHsosi+qigJaakZ6Z8dqPb6fTHUkVEZcBA8Gv1VplcMdpL8Qv4eNIFU0bODdE+cdyMBJ8B5TSa35XKgRD3mYlDL7K+VuGs5lJaNsYl68eRbd+66uYa4PNsQBZQns9+0gZELYO9gcyKSLYW4bgHPUFcj/cUZ+rLJVg2/lGLeeTsbJBxchnf1htTLb794j6ZyxHgDqIiJ81I49s+P25LACd2cKuPyCOf7D93C7is2R+7buGwZpumOE6fq2ecgXQcLIZk8bVHNIbxst2p8JPQ/ETd1XiGaCacbfF5DmSqXN3CKG2/kHv1O//7zVbGd3Wsd9dmc+VhdI+C8G0Z4r2WsRf9OvbperKO1W16hWAs0dVJLlPqV4DW3jfTAE52H7mMB8kpT8tjSxG9XM2o8hW34eaKq1HI5OF3ZUQyNN/4vycMuWAokvvPsDrlp0unfipQxGgmFgmAhZtTS+/YS8SS
 yycL0kZc
 HepNtBu/5+E77QkYfceLGRIR/2Djfvl8KTjC/ErjXtVgjNAV5iJi7W64sjN+pbTE1KD/bc9X084a5kTrEO5s6+dzyY/C4456Kkku2uyn8Gbd1XBgD653kfcWtUIwTxYEV677v8FEea12yk4vQyviZdPNWVPqFufIyHF8zqNANUzaaDR1ZHQutqkECMUNGO9+4tqREyVWeHPgF0dH79vBZp3UWFNMmWVxDTEj+r1x9TFoqgfl6AsFeAJXgu3G+DG1cu6wiwzIaA3CH2mdS+XOq7eTIsg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Anonymous shmem large order allocations are dynamically controlled via the
global THP sysfs knob (/sys/kernel/mm/transparent_hugepage/shmem_enabled)
and the per-size mTHP knobs (/sys/kernel/mm/transparent_hugepage/hugepages-<size>kB/shmem_enabled).

Therefore, anonymous shmem uses shmem_allowable_huge_orders() to check
which large orders are allowed, rather than relying on mapping_max_folio_order().
Moreover, mapping_max_folio_order() is intended to control large order
allocations only for tmpfs mounts. Clarify this by not setting a large-order
range for internal anonymous shmem mappings, to avoid confusion, as discussed
in the previous thread[1].

[1] https://lore.kernel.org/all/ec927492-4577-4192-8fad-85eb1bb43121@linux.alibaba.com/
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
 mm/shmem.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 4ecefe02881d..a60fe067969c 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -3088,8 +3088,17 @@ static struct inode *__shmem_get_inode(struct mnt_idmap *idmap,
 	if (sbinfo->noswap)
 		mapping_set_unevictable(inode->i_mapping);
 
-	/* Don't consider 'deny' for emergencies and 'force' for testing */
-	if (sbinfo->huge)
+	/*
+	 * Only set the large order range for tmpfs mounts. The large order
+	 * selection for the internal anonymous shmem mount is configured
+	 * dynamically via the 'shmem_enabled' interfaces, so there is no
+	 * need to set a large order range for the internal anonymous shmem
+	 * mapping.
+	 *
+	 * Note: Don't consider 'deny' for emergencies and 'force' for
+	 * testing.
+	 */
+	if (sbinfo->huge && !(sb->s_flags & SB_KERNMOUNT))
 		mapping_set_large_folios(inode->i_mapping);
 
 	switch (mode & S_IFMT) {
-- 
2.47.3


