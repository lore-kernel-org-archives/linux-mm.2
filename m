Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7184DFAD3E7
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 01:41:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A061D6B0005; Wed, 22 Apr 2026 21:41:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B6DA6B008A; Wed, 22 Apr 2026 21:41:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8CD366B008C; Wed, 22 Apr 2026 21:41:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7BB7C6B0005
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 21:41:57 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0A1771201A4
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 01:41:57 +0000 (UTC)
X-FDA: 84688119474.19.263FC0D
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3554E4000C
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 01:41:53 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=x3u89gX7;
	spf=pass (imf12.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776908515;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=eS2Rq2WCDekRzqG5jZeEs1T3Qy5ZrrxcUaInoP4NY9c=;
	b=FEzC0ot+4RCmCG2C9seSJ/5giJUfQrL5Lnx2XpQFEvHmg81A5SZLgUd3Df8bOYL730hJcf
	OhXtwIw4L2M3urviYZvIvVV28dsEQqfICSco4Gssf10u4qXPh1T2T1bQ3kSpVhYcUBYhOy
	Qt6Lu9gnVAI8uVNvphMcuu1NFSBKrY0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776908515; a=rsa-sha256;
	cv=none;
	b=DXVjK6pQm1nnIUA7wYKIiR5e686FGjaTuJDySzZ7HkTxxSgecAwt2Zs/K6qjtCLSCQ8eAQ
	F0NL98xq02xmzIoBTDrRvyAuBp1jfBAOp5+tNu5Tp7yH+p/KN8jyulZtUZU0lDl+V5SMkX
	7o087+L/jnyHTpVtth/HvsLLZPIxxgY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=x3u89gX7;
	spf=pass (imf12.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1776908510; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=eS2Rq2WCDekRzqG5jZeEs1T3Qy5ZrrxcUaInoP4NY9c=;
	b=x3u89gX7ViMAiyllB4Tmg0A9OUDhmt+YsXCnAl/05D9bOJnBJgajNQzfLIgYacczP8laqXTP9OfsGPO0laZla5gJ09g8GT4p27ZfW/h8iM99jE/t282FAT4b5nOgb04AuPx+ZpqB95fNDs/8DKslkj27W2zm2mvO516jGFlb3sI=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0X1Y3E5F_1776908509;
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X1Y3E5F_1776908509 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 23 Apr 2026 09:41:49 +0800
From: Baolin Wang <baolin.wang@linux.alibaba.com>
To: akpm@linux-foundation.org,
	hughd@google.com
Cc: willy@infradead.org,
	ziy@nvidia.com,
	david@kernel.org,
	ljs@kernel.org,
	lance.yang@linux.dev,
	wangkefeng.wang@huawei.com,
	baolin.wang@linux.alibaba.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] Revert "tmpfs: don't enable large folios if not supported"
Date: Thu, 23 Apr 2026 09:41:42 +0800
Message-ID: <b2c7deee259a94b0d00a7c320d8d24d2c421f761.1776908112.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: kzudu8sye5qeh98z8ys469st8dawrx6q
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 3554E4000C
X-Rspam-User: 
X-HE-Tag: 1776908513-603551
X-HE-Meta: U2FsdGVkX1+cJpuBAnQJRPZgeiA3Zpjzp2+d2aLp3h4JHX6fJAqlElM9+nOTuucTCx6H64WI4B/KNaiChFMM/dIuOFEs6wZFkoasCBEnBzguTB1FWLciLZn3rZVnGDZuzVYodm/+3VGUoIq8HsARyvUNjTmzm3h6wyi2nX4Tv9PKmNwfP8s0/XL08Dvg2ErJOjmZ1N0DOkN2mJ1lBpxcz+zOO1nBlTvIdfgieczged/tg4nIR2kPAFCdNziUYNHERjIvuWjQ5TIKqliEjfkkwp7DEH5hvKXmQNilWOFQVD3dEfUGXPXAzu3fCQKFe3T9nSuRbK4O0K0xgUIaWfeK5Dt9MY6pZq/NtJeGgmN97q8YaSUeP0yX/IleGEdsIgxGQKmaSGPhRRTmkEZ4/QT+uBeZn8NHND9PfFh8w5WZI/GYPfELmB2q8nmwpTNbjfxb86TGIrt9DC4bWspOCr5mkAwu8iy7GWzAqjMta6z/n+sJy8uLAfYocXhGsPZiSIRmBWwHMjEFfGq0jSbi/CaxJ09bev7BkhqowpQsCOJw48Q4fuIadtcANCBQcaCtwK3kis0xv8NL0xtGhPBpIxcVUHhf7PYw8KAnOTQqI1HNNCh1Xf9otmDeDq7lHkHxw6swPVZdoJmENR4y6lrEz0b0DF5UAlWyTfLRkaUmcWcisSLK1ymVLgxolNnPDXKHGcsfri7a0UJDFCCOaE4+7CHBG6ra/YV4pDFJpEmEPUF/nBTS00kBMmL05DaFgJ+rw0PWPbdM8Vt0mmehgFvNBgVC9xMHVHgaupjxf1oOjOe8UOYlSQlR+/YfzasHq3BRHrb98rCZTUIxbJ2pCNt0ARPJzJBRLVvNIrBzjb84TkbwUqM6QJxudgvmZrg1nt2D0doLHS+UpxHOMBeqGhkBtMD9xeu4q9RBtemtmm8XOreL6LTcGbeIXFx0dAIJgZXKBNnIelK6eh3dTTMROiyNQY2
 opL0Rc69
 fAY++9iz2OkQ+9PU8gD7AcC6jRXYyOEo/7aEyZTPkjWbgl1KiRYs2XeF8ZrUodZRz8d+OEpfW5J26ImyCTOdYFYYIYr/V313fayFQGJPW7XSH+14ikYYQj1bauoU6hwPhZXTuq/mu1XUjU2mzPDhKd15aTvqn0qHVEkQ1OB3K+43MY5uizSgxgBmpIcOOmeKt8WDJTVe280z5xOxSzfRUp78vKi7UMaRPe5J7WGdvjzyZfUSBPXRqjYsygmJ9JKcyvFm7i4a63jT5EMvDCi6JoOqmmA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This reverts commit 5a90c155defa684f3a21f68c3f8e40c056e6114c.

Currently, when shmem mounts are initialized, they only use 'sbinfo->huge' to
determine whether the shmem mount supports large folios. However, for anonymous
shmem, whether it supports large folios can be dynamically configured via sysfs
interfaces, so setting or not setting mapping_set_large_folios() during initialization
cannot accurately reflect whether anonymous shmem actually supports large folios,
which has already caused some confusion[1].

Moreover, for tmpfs mounts, relying on 'sbinfo->huge' cannot keep the mapping_set_large_folios()
setting consistent across all mappings in the entire tmpfs mount. In other words,
under the same tmpfs mount, after remount, we might end up with some mappings
supporting large folios (calling mapping_set_large_folios()) while others don't.

After some investigation, I found that the write performance regression addressed
by commit 5a90c155defa has already been fixed by the following commit 665575cff098b
("filemap: move prefaulting out of hot write path"). See the following test data:

Base:
dd if=/dev/zero of=/mnt/tmpfs/test bs=400K count=10485 (3.2 GB/s)
dd if=/dev/zero of=/mnt/tmpfs/test bs=800K count=5242 (3.2 GB/s)
dd if=/dev/zero of=/mnt/tmpfs/test bs=1600K count=2621 (3.1 GB/s)
dd if=/dev/zero of=/mnt/tmpfs/test bs=2200K count=1906 (3.0 GB/s )
dd if=/dev/zero of=/mnt/tmpfs/test bs=3000K count=1398 (3.0 GB/s)
dd if=/dev/zero of=/mnt/tmpfs/test bs=4500K count=932 (3.1 GB/s)

Base + revert 5a90c155defa:
dd if=/dev/zero of=/mnt/tmpfs/test bs=400K count=10485 (3.3 GB/s)
dd if=/dev/zero of=/mnt/tmpfs/test bs=800K count=5242 (3.3 GB/s)
dd if=/dev/zero of=/mnt/tmpfs/test bs=1600K count=2621 (3.2 GB/s)
dd if=/dev/zero of=/mnt/tmpfs/test bs=2200K count=1906 (3.1 GB/s)
dd if=/dev/zero of=/mnt/tmpfs/testbs=3000K count=1398 (3.0 GB/s)
dd if=/dev/zero of=/mnt/tmpfs/test bs=4500K count=932 (3.1 GB/s)

The data is basically consistent with minor fluctuation noise. So we can now
safely revert commit 5a90c155defa to set mapping_set_large_folios() for all
shmem mounts unconditionally.

[1] https://lore.kernel.org/all/ec927492-4577-4192-8fad-85eb1bb43121@linux.alibaba.com/
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
Note: for more investigation and test data, see:
https://lore.kernel.org/all/116df9f9-4db7-40d4-a4a4-30a87c0feffa@linux.alibaba.com/
Thanks Kefeng for confirming the performance issue.
---
 mm/shmem.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 4ecefe02881d..dafbea53b22d 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -3087,10 +3087,7 @@ static struct inode *__shmem_get_inode(struct mnt_idmap *idmap,
 	cache_no_acl(inode);
 	if (sbinfo->noswap)
 		mapping_set_unevictable(inode->i_mapping);
-
-	/* Don't consider 'deny' for emergencies and 'force' for testing */
-	if (sbinfo->huge)
-		mapping_set_large_folios(inode->i_mapping);
+	mapping_set_large_folios(inode->i_mapping);
 
 	switch (mode & S_IFMT) {
 	default:
-- 
2.47.3


