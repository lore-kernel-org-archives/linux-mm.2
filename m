Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70762606A323
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 09:56:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZZTpr8PM
Received: by kanga.kvack.org (Postfix)
	id 9A74D6B05C8; Wed, 28 Oct 2026 05:56:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 97F286B05C9; Wed, 28 Oct 2026 05:56:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8BBEE6B05CA; Wed, 28 Oct 2026 05:56:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 71FA16B05C8
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 05:56:22 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6BFEB120C35
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 09:56:21 +0000 (UTC)
X-FDA: 85371579762.19.C044590
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id A6977C0005
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 09:56:19 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZZTpr8PM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793181379;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dWtfJQ4qPr8yDXmK0xlGw+FpfOgHiCBUnwlQop7LS/s=;
	b=3eyp/FA7jipA0nIkBpq2AzGI/MMDzarUXQnKiu3jbwJYDgnNXOcnnVDih/wlEufFkRejCs
	TDXSMxF6rSjjG5rMv1hToQuP5/2LeOmSFrPvW4Hig3inbgWtB+G8qKrzTDpghbSKlPZomC
	TU5RS3DzE00l7g1UFJowRUcX8oMlPGA=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZZTpr8PM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793181379;
	b=KNFaVs3h7LVXem1pUB+GAJeOrv4WV+UX6+Pk6XQ8zVPxk9HBkW74LGk77kj8nfHlSyEFE6
	p6b27h93IWgB7lt15fav7H4WlyIv3VG5yxKaI9EyZuYVJWzj99JK4nIrKyVDIvfBnjV+oQ
	zeVPK58SVYV71L+9+lbWGEQP9hdF0Uk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 354FA600C8;
	Wed, 28 Oct 2026 09:56:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60D8C1F031E2;
	Wed, 28 Oct 2026 09:56:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793181378;
	bh=dWtfJQ4qPr8yDXmK0xlGw+FpfOgHiCBUnwlQop7LS/s=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=ZZTpr8PMhWqbEpAM0ku9pNlwYuzx+2+eSealmEstdVbOX7fJ6wmSpifND9VwMTDNz
	 4gY1pWMsiid+4FLtRFjfJiGN5OwrklKjzCPSReprPTmXK/muvX8+LcXpIYHB11k/bK
	 tW+tkYFBxkmrE5csNluPd3UdXcCnklseapQ2VoZzITeVGhdkM3dwxBYhALNkHSHI+z
	 LYKHhp4Uzy4VPO6KlF9lCCMQizp5qA9QIeJQwhkb1j8araZ5hDOvOC/uH8ygtI8vhG
	 Ru3UzIURxpe100XTcZF80VI8iucM6tmqhFU3cY85/qrK65XJFD8TdWJSy8IwOEFR6e
	 sWIlZj8iylrzw==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Wed, 28 Oct 2026 10:55:05 +0100
Subject: [PATCH v3 07/15] mm/shmem: stop retrying folios that cannot be
 split
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261028-fixes_shmem-v3-7-4ce3baf2db4b@kernel.org>
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
 Chris Mason <mason@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1791; i=david@kernel.org;
 h=from:subject:message-id; bh=NbZDdS3d0PrLLZ1hQxxWa9fDydv0db7qoW/5IxmDaFY=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLIeHmty1P3QYlqws/Ow6MbbPx7KJdZ8EP+4jKvJbUfw+
 rP75t091FHKwiDGwSArpsgSFHzf4OXLdbXVbnzMMHNYmUCGMHBxCsBEyvkZGRrFRT7Yz4+9euZn
 xPkvPn5TF4QW3r0347rFvqm3L6tO3T6B4Z/V399f3lvF3+aonbBwUu33b8/qA7P/dqw+9jpSuVR
 IzoIBAA==
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Queue-Id: A6977C0005
X-Stat-Signature: opdxoxo8nydimwehfmh6j94tz4qc4yhd
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793181379-506964
X-HE-Meta: U2FsdGVkX1/XILO45Iua7xx1u0hJQUeCNDH3iTxgienRWhGANPBGNMQMQJtnwj8NJT7sVkYeKvRh6QIE2EGfRFClo1AmnOvFS83thHhBI0gdwVtzpXh7hBAFu58k2s/9lfOIh7Xzf/P07+hgp8EnArlZhELSLVVInw12lbkchTrlN41bRn0lpNC7tWk59DOsSx8ztsCtbK2YFa8ze2j6Wyxjm5ZLWt6en44ft4EfOm9WyzrtXBDqhFMv1p89wvt3wkfYeuGm7g7ituoSaypgq6CGGlpyXv7yD5qv2pNecZ8ySdFMH+plSeuKQSG8d7ULi1bTwOmdHbdiQkrNTMCTWzUNI0ERmluMPZ91+WmmyRJNLhiO8wjjKfrVoej0BQg0H+QOBMxLrF+asHYAOcYWBHg8ECuJegrHuby5moYe8xjUi+xt5KPdBzLyEcBy0vsVlmIcMqop4jyMcfSa1d7pE0oENOyqprOpvtS5AYnDYpZDqFgBLRlAO1qu63LMWAPiFKoXgJKRWWR6u6/v48cpv1DrjoMI75S1J1juW5ffNYwuHV1taAPecDLEuuO4bHBXQu+hYmD6b1M+nHiaPK1qIEFK006C3S8dygGJhiog4O0e204BIVWIlm1FsPlW1sh2liC2m3zT2iUPYIxrahMxfoBMlsCl136PRkssLp979TUm0YsVxE/SD7N1ATCAXE3e7jMb1f0I7pdEOTtwLIvBYbb0suBFZlLVfQ31h04YQOiMz4hvaL9ezEN/CHRoGD4kk9XhHfK6j99MJor8N3ldOm47DAILvN6ZNbiXvuOVnCM0OFktgY3fFI/So64SgKgrPIOsaALGU/40dTUo94Bq/Mj7XpJxxe/Wn6VyyeFPAw2Fp94NtgNv+BJSQP9OnsySOwT9eIjoNF17y59q2BMREmS21mH22IB3gl0CMfRzlzI7VlGQDhrAhJIb3qzaRtgqjHjIUsMgZzC8yRw1/mN
 At4YQJCm
 LEx3UpoRqvcfaEf10dB0R1yaUYXVyT/Qp8b8W7jkNODnyJSb0fIdgMaBU6Z0IohdQEui27pVdbTn7TXqN+5h6lGHTv7xci2qfj/LGRv/UMFpofu/Vq7k0CybJbUsTD0muIHvstec7be54ceJEFC7k8+a7YlTc8lM6bUusNWDwsxptCyU1NUI5LZj/nz+rvD2qX+vASONHNOtiUNne3pAaI/B27sHCGy/ouW/BEpRRawPssWLTH/1IpVmvn/JyqGcGOB8857RaaiUso3GSzD5prQV3l2W0RCG/9lJYi69sBatk9pM332qVqnyxl/Y4Pc+pBmxwlO9Eh8Fzfi/InogTCjAbGnqEHgBBdd1ayhd61gZMiB2vfr2afDkfQxLwsYIv1SMhaMAmmPAUS833rAgAqsDIqg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Chris Mason <mason@kernel.org>

A fault or collapse can insert a large folio crossing EOF after
shmem_undo_range() has handled the boundary folios. If splitting that
folio fails, truncate_inode_partial_folio() retains it when it is dirty.
The final scan then repeatedly finds it because it restarts from an
unchanged start.

Truncation keeps the inode lock and ignores fatal signals while looping.
A concurrent unlink() can then block other directory operations while
holding the directory lock and waiting for the file's lock.

Advance start past the retained folio, whose truncated part has already
been zeroed. Do not move start backwards if the failed split has shrunk
the folio.

Fix generated by an LLM and sent by Chris Mason in private.

Fixes: 55ac8bbe358b ("mm/shmem: fix race in shmem_undo_range w/THP")
Cc: stable@vger.kernel.org
Signed-off-by: Chris Mason <mason@kernel.org>
Tested-by: Gregory Price (Meta) <gourry@gourry.net>
[ david: split fixes, simplify descriptions, adjust comments ]
Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/shmem.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/mm/shmem.c b/mm/shmem.c
index eddd5870be07..50d526edc2d4 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1481,6 +1481,15 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, uoff_t lend,
 						index = start;
 						break;
 					}
+				} else if (folio->mapping) {
+					/*
+					 * Splitting failed, but the part in the
+					 * range is already zeroed. The folio
+					 * was not dropped, so skip it when
+					 * restarting the scan to avoid retrying
+					 * it forever.
+					 */
+					start = max(start, folio_next_index(folio));
 				}
 			}
 			folio_unlock(folio);

-- 
2.43.0


