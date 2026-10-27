Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C5AE606A326
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 13:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jkCBEq2X
Received: by kanga.kvack.org (Postfix)
	id 7A0096B0717; Tue, 27 Oct 2026 09:03:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7509A6B0719; Tue, 27 Oct 2026 09:03:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 667516B071A; Tue, 27 Oct 2026 09:03:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 44D206B0717
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 09:03:42 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 52504160A36
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 13:03:41 +0000 (UTC)
X-FDA: 85368423042.14.53568A9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 4CA4F2000E
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 13:03:40 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jkCBEq2X;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793106219;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HmxLnNloqDnX2mGRaG7UB60Xgda7GnOgxeIVM3cnCiI=;
	b=kKGyt8ZemjcPk4mw9nTasYE8JYY6lDIVh7y+BuXQXhs1r3lgL45R/IvSN786TjGEYEj7m2
	JlP3Z8RzxZzBZiTFBdzpCXEKw8fdsnBBJzLiEdwrUeHAtO3pVfoWjMmxNfEp/XYDP8RHFl
	NR1JDRzUBqg4xbzJDh9VlvpeDeFk+Zo=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jkCBEq2X;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793106219;
	b=ffzlcggPbAIRVfpFh3aY3zlBG1tvoCC8Pc3IGriMoDR+JDWNgOBqbr3q5eUC4rHtF4jF/r
	nC7s4tkrRlwWoj5DDqzHzPMkFobe85aBIGyGB7wC1ZqddWz3nUuD0CjnhiCPq9jUAlf3Z8
	4EgvFd7MjmDxQ6S5YPb5YkFTrjsQk4s=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2E6606022E;
	Tue, 27 Oct 2026 13:03:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1D4B1F01825;
	Tue, 27 Oct 2026 13:03:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793106218;
	bh=HmxLnNloqDnX2mGRaG7UB60Xgda7GnOgxeIVM3cnCiI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=jkCBEq2XthyXjppB6FBZsDBb4g+JSV14/RdizzEMI5plk0gIcKULthmFx0xGUXtt9
	 W3TLuDN8wSjmTf/3igeQrdB01tryX2n/9PpiAB/MjPzt2WHI1TmBki18TanYBxzft8
	 x1w2jkCDONXBiws5DDA4GjVSiezHe3kb4H+Nv5ZUd5LH4xy/v56p2gXCLrecf6OkJc
	 QFb7akhDXTu5+qRVuZGhp6bQR1CVzjK5n+jAtW5hVloS7SilC+nGh/PpmPdYwqCKDd
	 YDrKe/RZMsi2XuSBq3L/5ofNkWa+Fp0/VVGgbkVayTGg5l++oO43MVm6nq79jqkKBU
	 HRlChtleeBSZA==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Tue, 27 Oct 2026 14:03:07 +0100
Subject: [PATCH v2 02/14] tmpfs: keep the quota soft limits of an unused id
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261027-fixes_shmem-v2-2-86a00952acb9@kernel.org>
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
 "David Hildenbrand (Arm)" <david@kernel.org>, 
 Josef Bacik <josef@toxicpanda.com>, stable@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1681; i=david@kernel.org;
 h=from:subject:message-id; bh=JOA/wkBohGWebURbwXTYcThfkfGV/E7mEcVBQ7p5Pw0=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLIeLBRg8NoZ9G7p573SIdMul1omC2pmCF3SaLvT/+vaq
 ZY7b7+ZdpSyMIhxMMiKKbIEBd83ePlyXW21Gx8zzBxWJrAhXJwCcJPXMTIcXiO30NJwnoHrFvmp
 Sr2Lg31dbHxZ9VZcTw/vDjQP9N3CyHD9Tvn/3c1F5rcCxddrntBX3tLsdJSz4kTKh9IfGQs7ZJg A
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Queue-Id: 4CA4F2000E
X-Stat-Signature: gwauom33thkkzwjh43quwkd7r5i1uhjr
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793106220-987897
X-HE-Meta: U2FsdGVkX18EQXSkmuD7nCf/VgIbu158jkzQVI1gSXaOWkGRLS56pr39vbnUMiqXRkotNTAy49nssW+sTAF3I0+SnWKUnf/HGBjJBk/8FbdR+yJ6IfNB3uVe9VPH+KSNI8F8yHKNXNyH/LOw7H1TfW8CK0jbLssVhlycEK2z4CpFykvE2/Ci/ceQW8qbVcIpHyGJOLCT6UiqwYTEXgFQ/avoInRZ0NYEzkOwLEbGepzOvoZtoKy1+MjyKXhDt85z5z8rWfr+I5dyk1Y0iz/gwiHYGTyj5MitUWX+MhQq/H4NHGM1J5CMMFFGhDWMiCe35iu9gBhXrdHboRVacsTOZXmRGyz1N88r0YeewlCC69tNvvhqWCgZGAA7n5R6p+LbT/ZLhYXClZaZpxUsiFZClzSr8cPOkzL3bpjcW2y666GapaftP/kLWbeXDwRiAPTYejk49btrl6IAftVhX2WAfe8TqjDj7cje4R/yMdq65/p58kiL4t6hfmz6jMkVVTlIWM76hm8CN2lMGHTvaXyaOwpz60vT16KPW7zoCUQL2WXbXr8BiQNqineAMDPAFvvQ/SFVThHKme5N/b7vs7feXvpdE3skRw78HqWuIbK7TRp8oww9Pnbw+OgUwd/dKMy5+xeIm594BlEeYTrwqv5MfBLPdD0KEyVN/CQal0tmXnPSP8kbq8EqTK/D3U7TwLRzKfBGM5LAnDtvUMMe4q/hv6N6+xZoRKB+8MXS6f9hC/KZisP6douy81dnTBa+igHUNSmEesakYrOTT9GhXq9XvPi6a4ZvCSP9RRZavAkOcswEPAHG2BzUX30P86wq1j2yFQyI8DP9dkHoYxf7ODygf9AyJpsTRU0Gca37MZNLwLPiiIHQ6u1MCbYTcsFZSQijxOhmE7auoVgkd1YBNVfcq7OlFFdqrdt48wvseJaMCUFyrP8rqPF2L/UynrYbp1Bh6yizipEpTrJa3L8ZSc8
 sLIyzG1L
 z3WzLwiOXZWIaiEI8W9/RWg85+zIpwS71uE1tjX5WI+LnL3WVCafw4jP5DJ3ibB1mqfhTfJ7mYC/QtyfznsOKplhZYhh77VNAudkZJydoxJku2TJCvvRcJh8gcKaUd6tRuC/V4jlKH0ZQdlF0lNCd1QBPQwsnJfD2zFjt3KU7lXTW6pdfnPazmikbq6uh5iZgpsiyJbHbPuOU6lEfoHGvQyWHeoNAqYe20HFv4Kcj3h67yn+myswY3i/VVfPDuCJ9cQkKTJBv9j60ac/b/s/vS8WqLEdTgqgfJvGN6quN19VxHkeQqu7OTYHeNI9HfCQePqFV2NBefItaYFz7+uzhM9mggpnpeFBHvxzTCNklSjcTg6k3ISZSOXtVClfGXrDy3re+lJSpgvUnMYW/3zW9nL6fea5Hmfc0lWooV/JUd8mTOwBD6OzwnCRvKsRg68TGdOEGOA4H4/0fl/7rYT/I8bjrSg==
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
index d0b92d6da50f5..a83392f75e56b 100644
--- a/mm/shmem_quota.c
+++ b/mm/shmem_quota.c
@@ -251,6 +251,8 @@ static bool shmem_is_empty_dquot(struct dquot *dquot)
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


