Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DEA1D606A31D
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 09:55:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EcxSRQ+S
Received: by kanga.kvack.org (Postfix)
	id 0A5016B05C0; Wed, 28 Oct 2026 05:55:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07D056B05C1; Wed, 28 Oct 2026 05:55:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFD586B05C2; Wed, 28 Oct 2026 05:55:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D2A096B05C0
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 05:55:42 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C3BDC40C04
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 09:55:41 +0000 (UTC)
X-FDA: 85371578082.13.57804EA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 1BBA6C0003
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 09:55:39 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EcxSRQ+S;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793181340;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iFruHrmEhVBLTXCl3oLRpr9O0/5ImLksM0FEP8VsCEw=;
	b=sjb0EUO/zXNaJ0OcuyNVaVBIhu1B5z038WLLQa6jiX29AEtawvjhJOzjYCGWgMe12aEppb
	lcpHqwQb7noXSXrs8TlfUSfqOpYpkI+MOF6qTBliNv2oKgUOGrAVY+PE+I4OTjRpgkOqo3
	Q0skjr0/mRK/ordnA6nnqAwvWu6YJpk=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EcxSRQ+S;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793181340;
	b=jA4f1MuvIjODEDQqqWQuBZU8nIuS7kOLKg4BE3kAAe4WQLBb46x4kGtjgnzM3slDLYRQNa
	PUTgfUUy/0PFW6q3H9+PU+aeWOFlakzFcaeTGBiN6LN6jFjPGf0czZQ9QdCK0l1AaDuvUk
	xEHaQYLYqCZ+1lNQokkSq0M8lVplt3E=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AA71B600DA;
	Wed, 28 Oct 2026 09:55:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FB7F1F031E6;
	Wed, 28 Oct 2026 09:55:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793181339;
	bh=iFruHrmEhVBLTXCl3oLRpr9O0/5ImLksM0FEP8VsCEw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=EcxSRQ+S4EvQkFspKgsUF+px6uVgYDy3gHZ/JCJEHNrQKXxzPgUaTV8HMkFYRbC6X
	 rTS3cM0AU7fDNL4FRPn0EQx3KWZcmDtbOrgSKrl8f9X+Tf0cvm0CbusuSL4gcU9ukq
	 /NySs5jiBxVb67AqI4wLbGv2b31t+5unCb9qdRwrT1R0kC6Sb9qqqVAyXTB/IlkiDN
	 kHD5dYJQFZBYIhYwPSD0PySHZLljQCwPSnTc7VQVDM96sMfxycOrYcJFLCVvELk+Fk
	 zGx6NuWTi8B5+YGYledzPvPoZMZYv8+B8R7GeyjIJt/UVoxXS3anSqhrNsIPhDfr+h
	 Hbx6vjtkQcYdA==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Wed, 28 Oct 2026 10:55:00 +0100
Subject: [PATCH v3 02/15] tmpfs: keep the quota soft limits of an unused id
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261028-fixes_shmem-v3-2-4ce3baf2db4b@kernel.org>
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
 Josef Bacik <josef@toxicpanda.com>, stable@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1679; i=david@kernel.org;
 h=from:subject:message-id; bh=wp8CLVQ6JeR410CRw2MdFOBtKKDTEioNL4JmHUhVmWE=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLIeHmssMAri1PNmkeNgXfU5P6E2d5V6Fe/8nTEWQrVhu
 UIdNtwdpSwMYhwMsmKKLEHB9w1evlxXW+3Gxwwzh5UJZAgDF6cATERzOiPDYb/ImTc3/W0/sL+x
 qjtju9k7wWsVHxh/vVix/uj6oC0aVQz/LBqP3O3xYn0+p/K3/bLzassYP7zY/3Abv3DxC7UekZ2
 /WQA=
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1BBA6C0003
X-Stat-Signature: 15skd1sbpp8idwrbcydg7u6ibj8zrhte
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793181339-27153
X-HE-Meta: U2FsdGVkX195RpqoWxz0ez+KFiacJ3OwbjIzNjuq9Uzqi/QdxXuk+EVh4A2nsWPqy++TssLRvdg8SD/6byu4QnM0rpuRxdVHEGb/mSy+mCftfVH9+yhnwS1F2OCUNcYNpIOZT87Qoxv4Yh/WFMv0W16wrGXu4sOoZr9sVpxQ/is1I1foCFtVzXxJMUvYjodiM/P9iNcjZxW+kf5RFkofOboLWkV9SQudZtUX4dVKwCAUL8iQbipmnsu2HYoB4ipOTgdPuA2H341EiuJk2cdeQDJWlEurJVg/RXeMsSiuT9YqQwQNTa8IIyQ9SM8MQjo1SvPzYeKSsJsi7zFtu6lINBdLmwk5S7yu39FlKSTfMm/OgrMUqiKqNGN6bopmkM9KhiH0y/59ni0MuxKHx8K0AHQBXeo/1vc16NwrkJQZzCCuz1jnrF/K0Rf/aIlNmlDOmxQZg99btjDj3b51i/obcu0TfMrE6GPUN+AZ70LEohXrvshJirfMsyvWd+c6JER0Q2dHSgpgKJsXlyiEmDTvvZ0u5FUG/7Oi/SaZvCVmf3WD00P3fj0e24GIWeIbpFqKnDQaE8vK4PVEujG9Ioq4mgr6uI8wOZzADj2ndLxtojciEmZxVPDVfMkvIS/Z4/nKMlL1cnYgEG0mDuU5tIj8aisKw6BkuQaXO3gPCpJLEFQEnFwLP+5K5O/kbRz54/q1B50xo2kj+OLJCiPaba2mtJyDnuHgR2YOpPc/FneVn4OtYNUYRCgSj4PCRCkkVE9xuN5OpdSe33qAyZ9YlcP3IKLXNJfWvUYpBySGqucGHzkebOtveqFMYhRDi471ktwvCJjtovhzwAB9R9gl+jzo85DXXZkVJ2Q4H38r9dWFTx8TYTmGUObmXpZLe/m9pK4ueS5mmwrhblZ6O3s8n3w2w2f4C0H37azBVnEyt78NwG2nlAZEKrqz4h3VRl6o3pAYDgLb2BH+k2ppE1pSJsc
 13vQtIeu
 VZiQ75AOa6+/fsYvIEEs3YiGZxCVxyGjZjwxRykEFi1G9omx47bh2JJnyJ3oh3Lf0zcUDFzwzIr4GU0y3PCfEvJmTyDE6CklsgiXhJT6z+9BkUDhiMqV/9IviWYdsBFtE/00Hir3WUFiCuIXK5Ulqt/QZQr992XpphuzuzeUcL4V070lR31PjMaKdK6MQdJ1vaCB+ERW04v/ZpyG5Agn/cELkcA0hFZ8UhRA3VbmrxLiLUM+bmylt/OeHz9DrJxqSUVOuzYY7BQi6Og4Lvhit6oQzE6rpSVmlBYlLTBnU1L/odQFxJvXL0drtDlBQYtaeM4OilVPh26U6Jxb+h4V51nLqPeHdMMeOfXReoR6JTpgVMJVKseKZavQ3o4annPX52Q5/k/iSWpGCIQzyhX9y9S5CVcO/AVXuZc9Gnp/pjRcJuLsrqX23Jo5v9bHUm4GqBF6xtjzCYIjC2Hrg8oPUefS6RA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Josef Bacik <josef@toxicpanda.com>

When the last reference to a dquot goes away, shmem_release_dquot()
stores its limits in the rb tree of the mount, unless
shmem_is_empty_dquot() says that there is nothing worth storing. That
function looks at the usage and at the two hard limits only.

So if the administrator sets nothing but soft limits for an id that owns
no file yet, the entry is thrown away as soon as the dquot that
Q_SETQUOTA used is released, and the id never gets to see a limit.

To fix it, compare the soft limits as well: an entry can be empty only if
both soft limits are zero as well, which is exactly what
shmem_acquire_dquot() sets for a new entry.

Fix generated by an LLM and sent by Josef Bacik in private.

Fixes: de4c0e7ca8b5 ("shmem: Add default quota limit mount options")
Cc: stable@vger.kernel.org
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Tested-by: Gregory Price (Meta) <gourry@gourry.net>
[ david: slightly adjusted description ]
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/shmem_quota.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/shmem_quota.c b/mm/shmem_quota.c
index a3fa4bd93e75..43d3b4fd6cb1 100644
--- a/mm/shmem_quota.c
+++ b/mm/shmem_quota.c
@@ -256,6 +256,8 @@ static bool shmem_is_empty_dquot(struct dquot *dquot)
 	if (test_bit(DQ_FAKE_B, &dquot->dq_flags) ||
 		(dquot->dq_dqb.dqb_curspace == 0 &&
 		 dquot->dq_dqb.dqb_curinodes == 0 &&
+		 dquot->dq_dqb.dqb_bsoftlimit == 0 &&
+		 dquot->dq_dqb.dqb_isoftlimit == 0 &&
 		 dquot->dq_dqb.dqb_bhardlimit == bhardlimit &&
 		 dquot->dq_dqb.dqb_ihardlimit == ihardlimit))
 		return true;

-- 
2.43.0


