Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 013BD606A320
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 09:56:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=F6MS+iEP
Received: by kanga.kvack.org (Postfix)
	id 2540E6B05C5; Wed, 28 Oct 2026 05:56:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 22B966B05C6; Wed, 28 Oct 2026 05:56:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1692C6B05C7; Wed, 28 Oct 2026 05:56:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ED4646B05C5
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 05:56:05 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7BA50160C36
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 09:56:05 +0000 (UTC)
X-FDA: 85371579090.12.D6F7709
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id AB25B40005
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 09:56:03 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=F6MS+iEP;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793181363;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CIildARgeqLV5Iv54/CNVDjST3eNjwaUwngHh+RJ76o=;
	b=4auJEQbVsvORycHh5m845RfzfyrHouCSsuJE/UNQIXz8HbkJSFaXm7y97FxIcxxizONljR
	4LvGauThooYlauchf5WUWWiHKyA5L7MfM+q/zUuHENUDYzI7MtOyfDLFYhnaY2gGWv9ysg
	nf2KF9EQ2Ui2nTJOGDH+FfpSMPwHWgk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793181363;
	b=LV4wd2S6oiB8OK+ItFhFqmtRNePQ/uHk/JdtOeY4r0J93Td1NEg6eKpJaXs2ZxEWSClnC1
	iOecp/j54R6aLx6/R2aTFBed25W/SIbFw3B0Z2QLmtBv+5qDz1juLruZFyvjOUfEB0Ke9N
	gH3a/cqnRsiRHO+T75kqF5Qrw6JrtRw=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=F6MS+iEP;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0FDA640998;
	Wed, 28 Oct 2026 09:56:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 942CD1F031E3;
	Wed, 28 Oct 2026 09:55:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793181362;
	bh=CIildARgeqLV5Iv54/CNVDjST3eNjwaUwngHh+RJ76o=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=F6MS+iEPGzqzyPG0YiNnFEMzL6u752n2vzQwod3dzSAmRc5ClKGMqr9yZV8DPqiB0
	 JoFD7GHfazp0A3rgJNb+arC4AeZRJQlWLj6yteINTFj1vZN0ay6MvS6EjSiUaTVFQQ
	 b4DeWwOQvlt1CKYiV/RxfNrVLQ3us7A22tinlr2SdT9PXAxo3Lj/w5uyzIW54pN2I+
	 GTk3CHoavcX+xynwZJOqLN+ZO2NSrZLjU/b8QWVtsivdustYcf7938EQI3P1gfy2Q2
	 ExlUq0+IsbrWmifup4zHJhumVWuFenw642l8B9RvJOLlYNq2zm10Tj4avBNFGY2wkK
	 4NIQ/Vr5cN4Gw==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Wed, 28 Oct 2026 10:55:03 +0100
Subject: [PATCH v3 05/15] hugetlbfs: enforce F_SEAL_EXEC in setattr
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261028-fixes_shmem-v3-5-4ce3baf2db4b@kernel.org>
References: <20261028-fixes_shmem-v3-0-4ce3baf2db4b@kernel.org>
In-Reply-To: <20261028-fixes_shmem-v3-0-4ce3baf2db4b@kernel.org>
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
 Eva Kurchatova <eva.kurchatova@virtuozzo.com>, stable@vger.kernel.org, 
 Pedro Falcato <pfalcato@suse.de>, "Kiryl Shutsemau (Meta)" <kas@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1864; i=david@kernel.org;
 h=from:subject:message-id; bh=VibnqfVc/i5QlUy5RzJlhfYS1+yzH9kwQCXwNrw3dIY=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLIeHmucd4+v+mna+4UPgk6VZzh6iwQ17WBewDLBcgHL8
 3CDk9OFO0pZGMQ4GGTFFFmCgu8bvHy5rrbajY8ZZg4rE8gQBi5OAZgIuxTDP4OXWuqTNi7d5eOW
 z5Y4i33Tx7+O8ouedXp4Hr8pW8ndOofhf0K6usbcP6Gf3vg3dRdVeyckiuzwU6s4entx1PM/L7o
 +8QAA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: AB25B40005
X-Stat-Signature: 4g1eh1tgz64xjtbbfg1hz16adsyrmd3p
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793181363-296953
X-HE-Meta: U2FsdGVkX18SpF8gr0LQc0fjf6wXZ5QVw8yjfKN/iZ4tzUuEMe9UAVGgnQTJ8ID6hSiDX39SuXH9ySInNKADgZyURGxnmK3LsYCYpTwDfH/rAHLGN30K06k75kB0bVrxrDoOS1lpCFa3YZWGRwWAKY3nX9WHak06Sq9S0uFOQdwY/Z1Q5tX9Fdo+SgivqrU5txhB7oS2SDDOxJgImZv9BU8rZzI/HLkvehrSCZlDZyrx48LPaTMaaoXtH+UhWf6FfsaFMFd0r32K+0Brg7X1+NTDRRwrUlQkaGDRay7Ab4LVjwLh6Mo2Gv2pbTBccV9rWLGAUytsb2wRcY53M8HH7xcdnf2wP3NYl0a8P/TsrCLNCAR7J9IZqYB1RRdbrz3Bmrqw2+gm8u6b4ubsaEzlN7/KdeFHgctTWacPsjnG511Eh7rJlAYwhDwvcxjrwXVNUt8iD7sou+zm3f6+6ViZtXK215yuE7bSopGOVfodXM9sGzTB78hh6sZTPkRtTnb8v9BRQdHEHmdK3r6zUt5YmrscuTz42R8EbaM0CovpThs5q/5zHhx7SLShsx+KEgNpoK1x0o76IgpMB6CFitlfHBQdxsMkoK9uFZkxfcsMhSjBOq9DEL5iZfiF9b5wIw5yIkQQ2QnInfyhfSMPtp+hULMvyjF8MtuvMvhxOtEf4h2XRFuw9zLTszDxeIRplTbWZewkjf12PwBwyQCXSVeDMX2H0R+IIuBF4vDvZJgO6xAFCbx46+aFVakCtupLTazNFBL0DK/+kMWkvE5HM4teaQJYbYW7K8CboVv/AYxMS18x5Emsj1D7Yw9+lWk11Rr3TZBhkUa/TZ72WqqXTdrtqOR7B9bo9wqz/ZFG0HhH/6IcGfII66OowYwO7qukbaKlIFeNbEiQLds0zGglklVK66lMBAQnGSyXsHvdpyQ+1rtJxqJ1c9FTj70juvHNqdX8cZ7iVcCwKv9qBfKSTLK
 wDYMhdMf
 QHKUZ/G/sKSzw3I5HSoZKI4B2KFmcSlE2artzKMXDbN9SAACauroO042og/oh6FsnUTxdYuPjmIxCuuqakQ1v17ASMtz/YP44qRGfTQcs6+xyBSEv6FuxoRbYsQnGdeYeLHla3kkz0Qixn6KW5sp/ZXkfWtuiL9P0H943Fdqq1/HBZj3HSsmOz+mCRfqxUoySVtYABiF7HxF5edxLKprqFctDOjno1j7T3h2Lyhv7/Z/eMJNaThwebpmnus5K6/moDuoStqZ5zcTlsuF6LmSjrPW/9j1bU1GgBrs4+pDQOrt3g8NCRO/n3DJPcua14sekDhB1BN9L7Ri6cbBjjoYCj3BnKMKVS3sOCwqF2ZGcHnrCadk5RwJKOOGvPL6LQ2U2md+wQc6E012221f/c2dVUmR4zbK1uhENowt3U3R4j7OcICu924wkEQO/w+5qmJMMcYqSRs+L1Ont9Qoz0UFZt/pKMje0/yfG3Sw4btgIigrbjDixGKRQHOpurGFPPxgE48fI/IEw5h7GfEYoa5Jr5+32Y4jqR+kg1L2Xm99U2+qb49R0dM8cOI46f8/bI1ZDadQafhCmz56OdVvAEYP4FrQHuw==
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

Fixes: 6fd7353829ca ("mm/memfd: add F_SEAL_EXEC")
Cc: stable@vger.kernel.org
Signed-off-by: Eva Kurchatova <eva.kurchatova@virtuozzo.com>
Link: https://patch.msgid.link/20260629180247.2343229-1-eva.kurchatova@virtuozzo.com
Acked-by: Pedro Falcato <pfalcato@suse.de>
Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Tested-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
[ david: use common helper; fixup Fixes:; check only regular files ]
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 fs/hugetlbfs/inode.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 01c4d6f44ebe..02e0a65d596d 100644
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
@@ -840,6 +841,13 @@ static int hugetlbfs_setattr(const struct mnt_idmap *idmap,
 	if (error)
 		return error;
 
+	if (S_ISREG(inode->i_mode) && (ia_valid & ATTR_MODE)) {
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


