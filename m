Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 338BD606A31A
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 10:44:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oWRfNUw7
Received: by kanga.kvack.org (Postfix)
	id 40DAA6B05B9; Thu, 29 Oct 2026 06:44:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3BDB06B05BA; Thu, 29 Oct 2026 06:44:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 286246B05BB; Thu, 29 Oct 2026 06:44:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 02D656B05B9
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 06:44:10 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EF9FC140353
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 10:44:08 +0000 (UTC)
X-FDA: 85375328976.03.47226CD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 40A1320006
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 10:44:07 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oWRfNUw7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793270647;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iFruHrmEhVBLTXCl3oLRpr9O0/5ImLksM0FEP8VsCEw=;
	b=M6sN0Ad6bRNZ3FTvOWzgpnLD2kuqQgKs1ZgHzyz2EVMU9cqaM84y1W0+kvkEtzU6plrM1o
	fcTbyVHIF/uCMQn4rKMrAjt7Iyo2qkUTqwVKoNr8+J1h/4lTKmnQeANJ8213+1qj5bV5/c
	z/L/XlvQbc2HNS0ZEex+/5751Ya5tTc=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oWRfNUw7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793270647;
	b=0RRaNtK0CsVbF571sGuOf9oycaqfm4S1LykkBtCljRrrV7DdveeG4DVB7en2y4vbOqO6C+
	qKl/coYMDUF6AaKMWXVC2Sftf8jylvCualpqc4LvG1k2YlQGYg6b5Nk9faR6ZEPWenrgxd
	2FHrmUgJyzxDha+2af9QfkMILQ1vFec=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C807F600D1;
	Thu, 29 Oct 2026 10:44:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 336441F01825;
	Thu, 29 Oct 2026 10:43:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793270646;
	bh=iFruHrmEhVBLTXCl3oLRpr9O0/5ImLksM0FEP8VsCEw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=oWRfNUw7J3fuboDVR9GKUxEKeGf61ab8Su2tCZVTh8nqxmWDvUZv+DHuac5BjlLdZ
	 UnRHcn4/lFb7nWex0onGp1u9klh8LilMEY2roLmvMP9Vk5iDaYxX9jAkzjDDfV3Jxu
	 vfJT9lBl2rbl+LdK0H/6bRHKmTxqRAR9I1MhjOY4QnDQAa3HagNBew7GhwfIK2hqnA
	 YueHKK6OHmyw0OrlYKOm/U1I4Go09MKWoYTB20xwJM0JcrFvgHLpOclMDw2UxBDF8Z
	 3anBl6FAp8ZsTPip+HSk5kM1F7sN+ijZVa0Qe8a+7dmN/c0IpgliLHfQeAy2DNNFYD
	 bEeXVZ6B7TdwA==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Thu, 29 Oct 2026 11:43:23 +0100
Subject: [PATCH v4 02/15] tmpfs: keep the quota soft limits of an unused id
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261029-fixes_shmem-v4-2-392fc715d8f6@kernel.org>
References: <20261029-fixes_shmem-v4-0-392fc715d8f6@kernel.org>
In-Reply-To: <20261029-fixes_shmem-v4-0-392fc715d8f6@kernel.org>
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
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLIeK4cdiBc85HNTrGyeG9vcE3s3Kmza+aVraci8Db9UG
 V21L4bf6ChlYRDjYJAVU2QJCr5v8PLlutpqNz5mmDmsTCBDGLg4BWAi3v0Mv5jMOPqUtAK3GvaF
 xtUH3i6q1iz9mLhWYic7x/IXt+OY5zEyHM9e/Ot5yN/QhNyLHg5u+TYaSQpzdnL2751o7/5y3de
 LXAA=
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 40A1320006
X-Stat-Signature: h1oywioy6dfdb7nuj3feuypqxb95gj6k
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793270647-432852
X-HE-Meta: U2FsdGVkX19vLO9KAIiT39daUMsI474hVmkRWio5NBVH+IxWrSIJjWTSPR4L+f+14KghjQX57uz8VNPvKS+GfWMA8LWhmrauUPde9HkPDoUwAsyDOOb7N1EoL77k6RNFdDE5AYpn8WtsdM93eKm6JbSQKdYwYK6cS5lvTBViaPf8GowEE/0QQcgXAQuqzuTmxT5vJ0kBdkRtukdT08ZBKfq0Zi5H0K7qWom50vEIzDZFeh4fpJVcPwUWTW0eBcBaoVji/pJTp8d6EfV1dMRXcqlDD3XL9Zd4bg9gnOOOnLG025QmVR6nDHoO+zBdQI7E4rSmcwDo+UN9y0p37kjBZpgKTJbF1Hcp12ZPU21BurkJeuIOE+bsjdsUtmzKFTBj/yvCUdbxuviBa7h7W6yb26PJTekRlL11LWERvsIUskuQaYJcSwqejTtdlmye6obBMjhOYnt+GE6Y6C+oMFKM7cGFIfNmxwDDTpuFro5MTF5AH3z9lEfiU6xUs9nyyQo3U0CW+mX0o8HN3W4F8SLdyEusQWBNrKcxQJU2wDFZgzjQP51Yl1X6oNWqmc/iW9oMPwrf6Ox5vkxqh9VkOtGx1e8DfdYOJHwvsdEfdGbKzFy3DKvKgEPf7lO5oX0NRIkb/17SgNP7CdtFccD/Gt8AU9S2YPvj8gfUGYg2tCkBvJOE1EscqYNQZ1QB34CZPA38q1uhDBZ5NOzvWAGyAwNOLh+wY0Y+3sHmAjShqZh6To70nwSfLR0f+49cy26qw+YFocITRYWcwBooIlcVHX+Ke9Py341cR15HIagmPaYIQjFLja++QjOlwefkB6s2E+Jeipyz6Yh7Epb3TEerV18r/ksVxVB+brC3zg+89oWFit1Hn1DzsuCkSnmQjVQxvVFxeSRsOogW85/K1fJoOrFlytIM/48pHyqsm4JvQhFGKGXVmf031iishUZcCQalPNWXnz+oZiRQGnMR8/7Hh8h
 tZuNsq/0
 fUSrM9zzjpER8NaGybnE7oxnLCvLw/vROojzUg0GWCH3O5Vzgu4hTEu+9Xw5B8Tthddxqw/58wWFOU5Rp9xCrb8UkjQvmranWLj86rytrD+rf4OACwj/cuIT4eKg8phB45IewZ3LVXTBqMozmZfj8PX4mAAJWpLGMeroOQltImkI2NnLxduNYhHYEOza2238aiFOtqubIsBG6x66QT5sEpWxeDzIfFbP7Ir9RhhrNAK+EdGbJlNrKW8rh4wCEn53AwMAj2l/wYc/I3j9M//A7omwgYZZn3pdJUQJCYEOhyWRFFtieS9kSvxNbTjpneLb4I1VDwXL4S8kZD+da0wh6AtHwmTWfYyeSMDpasxV+IDpB5YripqbhA93mm7K4kqMn6U5kszR2w/1aIpkP2A2x6G7u1eywFKzYQHxpY7sdtr0O+73esTeB0a2FZu9QeXYhDlbkr7/DSult/YvbbW74rNFccg==
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


