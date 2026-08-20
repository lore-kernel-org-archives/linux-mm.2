Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A110C5DF8B
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 04:21:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A42166B0098; Thu, 20 Aug 2026 00:21:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A1A0F6B009B; Thu, 20 Aug 2026 00:21:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 930C26B009D; Thu, 20 Aug 2026 00:21:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6FFC26B0098
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 00:21:49 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F1424A02DE
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 04:21:48 +0000 (UTC)
X-FDA: 85120349496.25.F9B8B52
Received: from out203-205-221-209.mail.qq.com (out203-205-221-209.mail.qq.com [203.205.221.209])
	by imf02.hostedemail.com (Postfix) with ESMTP id 1702E80006
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 04:21:45 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=D1Qsy4cB;
	spf=pass (imf02.hostedemail.com: domain of eadavis@qq.com designates 203.205.221.209 as permitted sender) smtp.mailfrom=eadavis@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787199707;
	b=SGRIUab67GWtvkkqzfx0RCTzS2VWcapm3uUl9rphRIqmA2bN1kAE7hDy6q103DSEw/ZT2f
	Yg/bYZV2o2QQpT223QSnFRU34yzHNgK9e6lru67q6hNe4t4EJE+XuRNDjV/a8+PMH0EUMX
	0HIz9DyQE3cPNzPfjFbc2Syi6+jIyJA=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=D1Qsy4cB;
	spf=pass (imf02.hostedemail.com: domain of eadavis@qq.com designates 203.205.221.209 as permitted sender) smtp.mailfrom=eadavis@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787199707;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OXRmnuz5ZMfJwMTMAGg3K+NGWRx+85asi7BTWGREPBA=;
	b=ktzYwak2qSXK/vJ63VK1dSlNrHEPKrZfH4w2+RhYm7Dkk5NVpvB6dS0pPtj4U8vuhSe8q9
	1fNJbYf5aa6vi6adOsEC9jUyqrePdIJo2W24JmxxsvPDvCpd7IGhKD3GckVO428DY8qJm6
	Xxw2Z9xM0vEi+ucDt/KZu0uWLX26Tmw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1787199702; bh=OXRmnuz5ZMfJwMTMAGg3K+NGWRx+85asi7BTWGREPBA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D1Qsy4cBkICvuSN0iGMs9086upS5U3XtNy5Q36vvU1Ftq73QbhaeIhN3S9DYOPt1b
	 MFkj+B4lhfVlChfgHLeiohTTwXQWeDYMU6v7wa4mzbvPxzUxt0qX6wFj7N0czltdUb
	 K2jop2MLBXPvXgBp/ddp1J/4foLgkm2ZWgwG8PCU=
Received: from lxu-ped-host.. ([111.198.231.89])
	by newxmesmtplogicsvrszc50-0.qq.com (NewEsmtp) with SMTP
	id 56603215; Thu, 20 Aug 2026 12:21:38 +0800
X-QQ-mid: xmsmtpt1787199698t5wm9axdy
Message-ID: <tencent_D69518E8F6ED56CE0479766DD82CC56EF00A@qq.com>
X-QQ-XMAILINFO: OVFdYp27KdlJ+U3yi7+TQIx+TTklNSKs7GKtNTXxTWC3i/vcI1IjR3MIm6ywSJ
	 Tb6dXO9jMLfX2bpQAU4jnavDKAq7oZ4qQDxSjDD7xpR10SkHJbOUsuNmA151uD/FEj3L5L22+tdP
	 AtqVasGWVmJUol+/ySSLTdx+qI1AoPijMEPVbWeNSqh2j5RD/ZiESgF1EAbNjZFQFQF2Ujr9afFj
	 nAYBK1sdmWxFGzUznAoR8W4skNqh72ElKhbK1cUw80N4JeJDleq3avnpB2wwKpJT62/ZP2H1n+c2
	 JyeqV4FfdN1trgxhIcqeiRWuhr0VSrxU6gm0QeFSRY2+D/ENhPQChCNcrX5svWy/tEHU1hfeL/ZQ
	 8MA9zHWql28CXiqlBwwyl37yVc/JbyjoSr3rVjgKxjFIj4zbBj08C8QDov1wmOY0csLgXds3NBcx
	 DcWbs0u1qP9F0KTLwQBcAW2Cxfi3hOLOXI0kzecBA7POI05azWXm7qq7fzXclUqr3gXlFrQBEQrG
	 nLcwFpvNkm59nIObbjkuFDhEgHiqSP4YZP1BlLli6dd/QblUdGjcQqfNDwFXiNWmTiOdqolnCzdV
	 gW7y2GLN+ofuQ93Uf60lTfF1e6xxR+/HdGuYtMcI9tWaS2nUDfYDm5hb1X6KIUA9rK9KOyX3DL/+
	 ueNkfZSG7k25rRYA/zoHAWhEMCpI/6KAlpBVrU5dTDmYOHwf6FuRkOuonejXfB09UV4+oeSnn9kf
	 H5f/CnlZgOIsNA1SYoXMRBCmrw0ub4qZQsffB64J4aV1NiUPE83Ox0SOo79oAan0yhHGUWkQeG4f
	 +ObXrDqKeFubqUDTo/ZwxMA6iu17kbZkXiKHEo7lu4vCIDDx4sMyC4pDo5GGU7gZLTb5qOn0Zk6R
	 BYhPmM7h4soiD6YOzB2aCBP2toVFGyMrx9Dy/jTjF/3RR3W6y3bHIPV1oEAHC4Bz5wOKulUvRU5R
	 FR4zcqHQDRYruMFl3honc/q3QaCqNjQZpxc+FEeUyasrWzOw1cBDw54/6fSvU+cBNmK4qUbhbAxl
	 tJEZ56/T7HyQsM2mQ7F9aDS8kbiOwXXlgMrbE+cWxxbP2hNdF+iNBawZHKhFNUWeyv3esfgvlmYO
	 rWk8l4
X-QQ-XMRINFO: Mp0Kj//9VHAxzExpfF+O8yhSrljjwrznVg==
From: Edward Adam Davis <eadavis@qq.com>
To: syzbot+9d20c3ad7d29227de28d@syzkaller.appspotmail.com
Cc: agruenba@redhat.com,
	swhiteho@redhat.com,
	akpm@linux-foundation.org,
	apopple@nvidia.com,
	byungchul@sk.com,
	david@kernel.org,
	gfs2@lists.linux.dev,
	gourry@gourry.net,
	joshua.hahnjy@gmail.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	matthew.brost@intel.com,
	rakie.kim@sk.com,
	syzkaller-bugs@googlegroups.com,
	ying.huang@linux.alibaba.com,
	ziy@nvidia.com
Subject: [PATCH] gfs2: valid the length of rgrp header
Date: Thu, 20 Aug 2026 12:21:38 +0800
X-OQ-MSGID: <20260820042137.518834-2-eadavis@qq.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <6a863306.ae6ddae5.3da009.0013.GAE@google.com>
References: <6a863306.ae6ddae5.3da009.0013.GAE@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 1702E80006
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: pe63bd7bq9yqffhfyah5knj6ogypno3j
X-HE-Tag: 1787199705-710289
X-HE-Meta: U2FsdGVkX1/yHEKELmm9p3qNJQenD3MPvKo2QGM/4wAYjDnrmAbrgDkWLEHzKz5JbYkpi9CpIpxa1fEsvm6+5wonvpii1sHQuHnH9VmHKryfi7Zix4QQWQMHHWrxkXG7PsR6TVkhzFi3UBa3U/YwLcRs89Voqk1oa+Li8noQ0Mwk4d6PVcMTTVjtNq8Dxz69OG5rlL1RVs/xJd4ovLes9qIwwLiUWoP5tFHLkA7DIouYc2BlhVPv+hZa4dyDaazJ7iuqoqsNW9e0/K+KuJtkZi+lkAR6EpLZPYJlLYU8rMkaV6qPbyFeHosUlvJeVn4olumIItsfTYlpd3tfnnSeyGdylSs5j8Psth1YaHCJmXMPn/zm2ZeRB+JHoPSbqp5KdQrXWY9XujuYl5m360EIV+A26iWqRsIkX7twFcT1z/1ZngdlwLmcQ4iupURISSXy6zb+M7aLxjEOFG5XarX3O41Eun0dOTaheRH0shVzF01yjZqhck7MwvvaEeATe6TwIhBVxnDfGeOESF7CvMt+FTOn0VWZjKevAiSUrB4vmH1hluaCTuFTLGeR3uOCveqjoyy43LDYSeOwHBP8qviq4yPi5hXqRNhxLrTYC0VQam61vd6IQj02rIh/ToOfZniHTuuwo1Q+Xq5xQLljYkD+pDng5LmY58crQaS2uO0AorP5EqhDv/A8xxfVtvvkQHc/PwffB0sDbRcJQVN3yuJYKuxi3nRdVaWk0LtmhCxQPOlflZ5MDZS8cXgjrXmcorljI18SKZzhO8lksel1Bva+v6YK0jn4Yuvcu0ST1/0oTXe5XwuqiSmK/pWFvy8GhcWZ/c+o7+NbtOkOdRTwx/y6iG1vDkXAJUyMhpHDPmAEMmshDu3asvOLX4pFFkaB3i27UmGRH8GTL75rZb3m9BimSDeJuy0ZRFYvztgICIMXT8NrzuPBD/FZuQ58EWtqrqCnjPr4CcXyFEDLxx+/ACB
 iJ4zd7kz
 GbXQDpS6hvCfBB2rABsvGV2FAr3v2+LcP2h+3hSZs21IkGXE7kPJJOuRQK9dngJ6vkdzswAqtVldKt48VymywAbB40APfpOev0xSsEGQAaLE3XId7Ga6Emb5oeco7TvNvMZbsYQi+8DPI4VOVqHrStsRL/8mUm3FRwcjCZg11WqNFJNKAjT9tyS5rb/p5c3TvL/pMkT4O5yBCNG2q/NgMvonLX/Z9S4g/BAROvwInY03JZUgVeM5FKUkl0iQtJmptbpJRPsVGUUiXWAsAGChSsca6tYFNSNsix5PCREGqLLy6EqQjSlAlxZdDGHNwoS6UqCjImqSTNWI0i0+IS+M7OM4OagyX10MxCwgb0NJsmeDASZUNftJjSFv+0vj/n0WEZCH+9Jee3FgQsYCP++zUx9Rr7CLLguI7jDzcq4n2VJ2knX+RnWldoLTLDHmEGBSIt6n5gYPiEbyIdy/jx9ThI6F9s7G9DcK9ePH/i77/w2FOwdg31lTTx8ahi4knsU/3PqiiSP5G392YYpU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When mounting a deliberately corrupted filesystem image, an excessively
large rgrp header length is used in a call to kzalloc_objs() within
compute_bitstructs(), and the memory allocator cannot handle such a large
allocation request. This triggers [1].

Add a check for the rgrp header length to avoid [1].

[1]
WARNING: mm/page_alloc.c:5280 at __alloc_frozen_pages_noprof+0x2427/0x2dc0 mm/page_alloc.c:5280, CPU#1: syz-executor256/5629
Call Trace:
 alloc_pages_mpol+0x1fb/0x540 mm/mempolicy.c:2490
 ___kmalloc_large_node+0xe5/0x120 mm/slub.c:5274
 __kmalloc_large_node_noprof+0x1c/0x70 mm/slub.c:5305
 __do_kmalloc_node mm/slub.c:5322 [inline]
 __kmalloc_noprof+0x5a1/0x820 mm/slub.c:5359
 _kmalloc_noprof include/linux/slab.h:992 [inline]
 _kzalloc_noprof include/linux/slab.h:1309 [inline]
 compute_bitstructs fs/gfs2/rgrp.c:766 [inline]
 read_rindex_entry+0x4a1/0x1250 fs/gfs2/rgrp.c:931
 gfs2_ri_update+0x6f/0x3b0 fs/gfs2/rgrp.c:1001
 gfs2_rindex_update+0x40b/0x480 fs/gfs2/rgrp.c:1051
 init_inodes+0x1f78/0x2790 fs/gfs2/ops_fstype.c:872
 gfs2_fill_super+0x1d3d/0x2cf0 fs/gfs2/ops_fstype.c:1250
 get_tree_bdev_flags+0x38c/0x620 fs/super.c:1640
 gfs2_get_tree+0x4e/0x280 fs/gfs2/ops_fstype.c:1332
 vfs_get_tree+0x92/0x320 fs/super.c:1700
 fc_mount fs/namespace.c:1198 [inline]

Fixes: bb8d8a6f54c1 ("[GFS2] Fix sign problem in quota/statfs and cleanup _host structures")
Reported-by: syzbot+9d20c3ad7d29227de28d@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=9d20c3ad7d29227de28d
Tested-by: syzbot+9d20c3ad7d29227de28d@syzkaller.appspotmail.com
Signed-off-by: Edward Adam Davis <eadavis@qq.com>
---
 fs/gfs2/rgrp.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index 5988a165a830..53d097ce668e 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -899,6 +899,7 @@ static int read_rindex_entry(struct gfs2_inode *ip)
 	struct gfs2_rindex buf;
 	int error;
 	struct gfs2_rgrpd *rgd;
+	size_t size;
 
 	if (pos >= i_size_read(&ip->i_inode))
 		return 1;
@@ -917,6 +918,13 @@ static int read_rindex_entry(struct gfs2_inode *ip)
 	rgd->rd_sbd = sdp;
 	rgd->rd_addr = be64_to_cpu(buf.ri_addr);
 	rgd->rd_length = be32_to_cpu(buf.ri_length);
+
+	size = rgd->rd_length * sizeof(struct gfs2_bitmap);
+	if (get_order(size) > MAX_PAGE_ORDER) {
+		error = -EINVAL;
+		goto fail;
+	}
+
 	rgd->rd_data0 = be64_to_cpu(buf.ri_data0);
 	rgd->rd_data = be32_to_cpu(buf.ri_data);
 	rgd->rd_bitbytes = be32_to_cpu(buf.ri_bitbytes);
-- 
2.43.0


