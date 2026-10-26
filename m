Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9AD5A606A32C
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 09:41:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=L78BWvfM
Received: by kanga.kvack.org (Postfix)
	id A46616B05B4; Mon, 26 Oct 2026 05:41:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F7246B05B5; Mon, 26 Oct 2026 05:41:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9339D6B05B6; Mon, 26 Oct 2026 05:41:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6D20E6B05B4
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 05:41:07 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E8ADA1C3F73
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 09:41:06 +0000 (UTC)
X-FDA: 85364283732.21.01EF8B0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 103F6160008
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 09:41:04 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=L78BWvfM;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793007665;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Vn7d8HcL6l9EfFDO02stSAeg32JgseybYZFulW1VvWw=;
	b=KOoPw9v4KDz1XS59SP6D+1AI3a0OYxR3F8NcuJZ2H+5iR4BUxGx1nooPOa//OLqEzr61m9
	e8x3lScs11/Id7tvBR9cXMU4mTzvr8qX/OeOB3Z/qZAn7l3mPnjzH+sUAuZq4c1/2b8Drn
	ZsWoFbGcj1FrlqSMnEw73jHPz+cJbsk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793007665;
	b=2X9IL1m47JPJnS911TKNMwH6+WBRhgnC0j7yFJJLRp+E1V+FkTv3kBBmSwB/oKkbdH74Pa
	uQzpsCA4QGPkR6KjIbWY0Llq9gqGmp6oWHDNUnF+/066td+35Uo1MN4B+Cgju0nRYkgkJo
	WcW3NPtAqMGmcmdonQ6W6i3C6qjeAr8=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=L78BWvfM;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 61F38402DA;
	Mon, 26 Oct 2026 09:41:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B07401F01825;
	Mon, 26 Oct 2026 09:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793007664;
	bh=Vn7d8HcL6l9EfFDO02stSAeg32JgseybYZFulW1VvWw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=L78BWvfMcfWtf0OGq/x/m6dTt93g6YYB+jj+3oULkWdXypbX6F88y3ydkZqibKWC3
	 HQcNulIH3pHBCli1bK1KmBfB6Sb3Cz4BOnXacrpBsZsWzAu0KM+5j5ourum8Co2dzO
	 bkWndL2aLeBjHqyk/eFBIrNwB4JGJGNp4Znzv10v1iH5V/uCcPn8JeJiLRX5JP5Hwb
	 jJq42G9SQSfUZcF707QRmY66JjR/DePfYA5+ndNvUFRmnlolR5DW8S5iC7jXSuS++D
	 QYGbD6EcosZg5c12OCu6Gd+L/LnoKEXN2+Qcye5fT+Dl6SqfvZIFbVbu+ZTmhu4Z5o
	 JqLWvHX7rGwvQ==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Mon, 26 Oct 2026 10:40:35 +0100
Subject: [PATCH 02/16] tmpfs: keep the quota soft limits of an unused id
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261026-fixes_shmem-v1-2-703206d5fa0c@kernel.org>
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
 Josef Bacik <josef@toxicpanda.com>, stable@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1590; i=david@kernel.org;
 h=from:subject:message-id; bh=M7xAc6hQ4qkVX+uGz6S8AcR/OPyms3MLaUujNvMuOQ4=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLLuK4itD9/NJCctMSMq1PFQ8MYL6ZMTzm1OuKXbkHUiw
 u6whtCvjlIWBjEOBlkxRZag4PsGL1+uq61242OGmcPKBDKEgYtTACbSnMLwz+hcdrZtbZ5s4ozJ
 PEGXDFWPRgV9C/9+iVdsV0CN8oqdbQz/bBrmt29bdiEyzaVc9r5MmtOPhmdPKxZZb1QK03iwVJW
 NCwA=
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 103F6160008
X-Stat-Signature: pr1erktpejc3caga37tfbpjg8z7oo7rt
X-Rspam-User: 
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793007664-964709
X-HE-Meta: U2FsdGVkX1987kovOhZZXZCkLQ19wu85kX921DcmgKMqpT24Qmw6sAjKbHOQIZSuXmLNbZqBAWGkmh1JRcETP0RfS7PlOaMaKpNXKYgspDCXOXiSAcg8NCuMh9p7G5+ftriM1T29rUJRojYzIBXLM1vLGTmSQsozdMyzFSZJl8LXJYHJzIcImS6LbpI6F6sAOM8FQhdzPKmdDwrh2/VHnxa26YFMVfaWwGiYhlfSQl6ohf/O0KizyMx8ZcxdkfgoLX/YLiE7kZaUPkuxphOWAW2ZL0B65Fb4TcR9WQ7YBDGQvmXaBwPNqKIIZPFeLHbaMdOOuN9e2DG9yK4mIWhfB3LcHaMGIX9JV9It7dIgVF21/z8lBv1m8Uvnbd4j/AMcYUuIwLeF9NhvIOR4gP57ViM4CuqNtHoJgPWG8Zmsi2gQb8jaYNll+fEPFy6ifoKkVOZZaHuQTDwKRzceU5oHtUUce/Hy84TRCy8y9NHmDPzHQ9NtmdnVj11/bTGItRyfbAbzCPAK+Ew3PwoW59SIbXFDlem35CQx6X8DB7Bqt2/7ZlPSgEgmDC0Pv+jKhtQhp9VXBP8nTCVVwYD/Mcj8bcRVYrM4TesJwBb9lfetvJf+lIZoCjwbd5bnuXFuxgiAXNS8jq9WrIz4a9E0f2g7mtGZ//Folxw8q4Yz+wwqEbCYJLlMJzZL/Lfj3+rFXfDP3SrmJHMcTRj8+3uQe7U0TbfsGuAD7RLj/KNdyM74IcTr5TEhMvLXVT4DgaRoQjbwJ6mkkuOLrJl06BUXxFs6vygqidjcd4qdwJKx6I0lyxIZUPeH4V3wY6klMnKBgn5679fK6YF8aDfVc4FSZAdQC4Ka+hu8ww7gReIHjfuyzdWMSvMzAQVoP2Dz8Vrp9YW9+nu8SSSnPRD7yP41TxMoVK0TEJRE31+8RIsBG5Kbh5xLRQ9Nmio2DfSbrpVPWCTaP4OpTA4gg+blKzZzZe6
 OKFBn4rX
 hv2sm4qvfQnHGsfRkiIi3QeWVimupallw+Zmy4njAOXBz3o94bVfdRTZGIHaEzzzpLGB/EOsg85nMeqqPAZUlBlZ11u6derZyK/JpYDG+Y/7++rXJAZFiyjOZo4K/AP0Pd9WiReSDZg2MjGZmqc9AKhVsiU0j05n3+TevmjrZ/cmMbj7pPr4MhKXIrpP+PRq0MUZ9EGx/cEFqU0Z+ipa/JSsl7/lzwRlB6BpeVkCSKWw3iPdUjo++3+V/wg9rDNdRPjfzHWBBgrEraF252ebCvXcv3DA4e+ZAwDM5QXGHmUtysaQrYsPYS4O4SrbnqusUok6uvfeHeyCpUExPId0BMDRkjSQdN9PHmVWWdPIQZKXfFBW5IXTm1LgD7Q7AzQcRgtQeZYyMsKcw2WFXkI+GU6G8jmhrR4TqcTYR
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
[ david: slightly adjusted description ]
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/shmem_quota.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/shmem_quota.c b/mm/shmem_quota.c
index a3fa4bd93e753..43d3b4fd6cb1b 100644
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


