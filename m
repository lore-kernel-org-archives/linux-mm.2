Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D7CE606A31E
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 13:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JA7NLGEP
Received: by kanga.kvack.org (Postfix)
	id 1FC9A6B05DD; Tue, 27 Oct 2026 09:03:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7EC3B6B05E4; Tue, 27 Oct 2026 09:03:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B43C6B05DD; Tue, 27 Oct 2026 09:03:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 45D5A6B05DA
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 09:03:26 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D72AA809D3
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 13:03:25 +0000 (UTC)
X-FDA: 85368422370.05.4FDE50B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 20B3612000A
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 13:03:23 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JA7NLGEP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793106204;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=t5YD1CKiKbr6Pf0qRp9WaGW0F54tRXdLeXUoAa+sxj4=;
	b=77+QHxrAcE1zNr7w2BXMxty25vt9JSVg3BGgVpSPxYu0sSWvwpxXuG8F5NZ8pQBUhY3otd
	rNEolK+SKBet5PF0K7a7TfsQcEpR0OxKwHAiUOPtQ/6ywUs08fbRMvZb7M/XwMkcCciqih
	uscYaF63u/jV4AwG9lIi+fULBBAaPhs=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JA7NLGEP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793106204;
	b=T+/6fsKx3Cparpo5zw6WOyAt5rtdsmDn4vsFLdQ+DTw4zQMsKW0+8bBsbfB+aGfM5nSIu+
	2JKMHTMLSAsBOE8gfW7KpSXTVI3M9X9t9HyuOznXOVHWjkNNFcqw5jvvQKHlCWFTWtrz0r
	GRxEomVNak1wIrHGwzj2tySPfHBCgcw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9A9B86020A;
	Tue, 27 Oct 2026 13:03:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB8011F01828;
	Tue, 27 Oct 2026 13:03:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793106203;
	bh=t5YD1CKiKbr6Pf0qRp9WaGW0F54tRXdLeXUoAa+sxj4=;
	h=From:Subject:Date:To:Cc;
	b=JA7NLGEPb73/TDX+Rr3pDCzZUPQ446M72ieleEMNbazZuQrDmRORGK9BQr0+y8N1c
	 UCBfIpKxuesqa9OWl2N01BJkETCu7ivET/CUnnABvu72nKlR9XqwN9UXMptg5Fblfs
	 Ds6igJhnlPLAoRNcDiACJm5nH3ABXcHaROM//H3sWLWuaFJIfmTWua2eHxhVs02hl2
	 vPNuqSimqjP4J6bS6KUVaVoD2LcQfhnqd/xQeF8FVYrd2DjwR6a3qxuoLlkLi4uyQb
	 DEQLtJpsm5yLdfgpM1vsLcLstQg+XPrdxYF24ZXPXmhVMCQQAp89YRwu9TaR3zl6d/
	 uRM6MkUkqqnnA==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: [PATCH v2 00/14] mm/shmem: various (urgent?) fixes
Date: Tue, 27 Oct 2026 14:03:05 +0100
Message-Id: <20261027-fixes_shmem-v2-0-86a00952acb9@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAmh4GoC/1WNzQ6CMBCEX4Xs2ZrtEop64j0MMfwsUBUwXWw0h
 He3YDx4/DIz38wg7CwLnKIZHHsrdhwC0C6CqiuGlpWtAwMhGY2UqMa+WC7S9dwrSg+U6mOpY2Q
 Ii4fjLQ6Dc/5leZZXrqZVsTY6K9Po3tud12vvZzZ/Zq8VqhRjQlMnTYFVdmM38H0/uhbyZVk+t
 h6fIrkAAAA=
X-Change-ID: 20261025-fixes_shmem-2782719b130e
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
 Chris Mason <mason@kernel.org>, stable@vger.kernel.org, 
 Pedro Falcato <pfalcato@suse.de>, "Kiryl Shutsemau (Meta)" <kas@kernel.org>, 
 Josef Bacik <josef@toxicpanda.com>, 
 Eva Kurchatova <eva.kurchatova@virtuozzo.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2549; i=david@kernel.org;
 h=from:subject:message-id; bh=Th8n0dNxPQMqEHGOvKfn/qjZ96i4KNkcKlIYIhHT2vA=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLIeLOTr3NXY4bFHeWrPkVaDoxWLTA44XyyadGaCyOSZX
 fbqdm7vOkpZGMQ4GGTFFFmCgu8bvHy5rrbajY8ZZg4rE8gQBi5OAZiIdAbDf0ep2lkrtZ6IPYr4
 HT8lu3BLYG9uVDfjI+EVF3XfZfS232D4K7PMqn/TOZ4nlupLb8UKvzt0YWLcmojFN7+2L2Qwuby
 vhQkA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Queue-Id: 20B3612000A
X-Rspam-User: 
X-Stat-Signature: 3srtq65krrwzr5phse8aamng7mtcd8yz
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793106203-746530
X-HE-Meta: U2FsdGVkX1+Vpn1GtVTVZvcMwQ9X9JeJrWmcQFztBP5a20McencyLaFawGT7+kpAQMLUzooKBS5Laum/Fv0RbZ8T5SAseEWwlICsY1RA6n7GZlj10z4PpRvXEJ3tGLxw/KzlkQWNtxbLORypxhUgXt76e/rzT8cSTHj90XDXWeLJ7pSDkcDBl6gGVM8M/1EBFXdzM6eh13g16e8qHgXIDnWGdjPOvvyVAEfltqgdnbwtD3IoZ5sqgGgk0hxS6FQGKTX/yG2IFi5ss+6r7dQ/12EEMOVKZ+Xu/u9vSTI5Ge3ID2Sk4jW94z/Hq4HYic6A33dzLJe6ZI3uHlC7UXtZD2lXtt2hjTISwSD0gUc3dTmu0a9R8RfD/yiX6UBKJi/VLLNTQfipP1UXDKK9TmkbFeRUGRW/hVgD6bsPiFv6JYIttDSTjMCUI/OPgfS5WRHBtkYqM6Kp64qjvmKbMq/rLJt8FWHfeVYdC4jYH/Rs0k44UHdlvF77L7zDWfDJXYkT5EL169s6glTrYgWDhW2JkJHWzvDHaxXm/cq+7cUvZK2QGByYV0+V2nOyi4MQAhpTJ++YWh7YQMfkeUr6ZdGp/nuXR6sYLFA10Zptd8i+md6n7tpUJVKCgFPrDB827Gx9O7XH3CBd25AFiP/2k4Qa+SVJFzDlo0w4F/MpLdBGYbx/0qOk0IgsKDeF4gPS8HASL6nLAL4IwNO0ARy6ISu301GxadSfga4gjA/NQSoB0xDXYO22VqUvPoNCz0cNmLF02gWpn22ESazHndCEC1Fqu9CW2MCNjo/YatAp4BA1ruoV7iZuxogmgzOChGNZuXGhw7Ky1zMgBqUxSv4nX0X0wS2EJtnHovlb1REXU60D8qQ3e5fZN8Ga6EI1RLNzNEXrlwCwemyP7q4DAhcbjpnBS46nEjfSFyhAPQv7C9ZUViNHkn/gq4S84cF8HMgE7g8XvAf0f6fi3RhBYvQA3GH
 O5xx46Q4
 akBKmIp+6xS5tejACxWP6h8H6GM1dvRaeVaY6ehDwrt1buZVRi753xY5kXm9TTmsLU21nIR4h4iJepAvbgYR3fv4B9/5Hu8yFFtiXuhKW0ufdjWp6nQMwP/Alh/AHDW2pEcfY0epFvYSAHCAc/OXaaVtA8GD72TPuZI2eu7uVoX0zXcmv5FkZATfRtWc9rXK329o5QcmwMecfxdX6QW7uMasZzeKkJc12Tm/vVOSBZ/yL2xHkoDvSzR/TfFhfjxjnUbYfS/JVVr5TnAsKNNolrsA8W3jQH/9WwApBgSM2UvK5J6wiemiTP6hKxoXSN+yHyHE7WVpXK1em08Qgvazpc4rleiTXvS8WWgxESbIjx+UGEMP1qtdkbFaXqsVJ2ylhjxZibG2fcHG/gWNb1Xf9Tt9rjH6Sx4Pyw84R97ZVazPlhNiPt6WdStG3jF3ClLg11YjD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi,

see v1 for details. TL;DR various fixes.

I now rebased on top of mm-stable (thanks Zi!) and retested with
Gregory's tests (thanks!). Thanks everyone for the fast review!

When sending this upstream there will be one conflict with the following
upstream commit:

	737362c7012a ("fs: port ->set_acl() to pass const mnt_idmap")

Which should get resolved through something like

diff --git a/mm/shmem.c b/mm/shmem.c
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@
-static int shmem_set_acl(struct mnt_idmap *idmap, struct dentry *dentry,
+static int shmem_set_acl(const struct mnt_idmap *idmap, struct dentry *dentry,
 		struct posix_acl *acl, int type)

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
Changes in v2:
- Rebased on mm-stable
 - Fixup shmem_set_acl() compilation issue after rebase
 - Dropped: "mm/shmem: avoid moving the truncation start backwards"
 - Fixed up: "mm/shmem: stop retrying folios that cannot be split"
- In "hugetlbfs: enforce F_SEAL_EXEC in setattr", check for S_ISREG
- Smaller patch description fixups
- Picked up tags
- Link to v1: https://patch.msgid.link/20261026-fixes_shmem-v1-0-703206d5fa0c@kernel.org

---

Chris Mason (4):
      mm/mempolicy: charge shared policy nodes
      mm/shmem: honour F_SEAL_EXEC when an ACL is set
      mm/shmem: stop retrying folios that cannot be split
      mm/shmem: preserve data in clean folios when splitting fails

David Hildenbrand (Arm) (7):
      mm/shmem: discard whole new large folios on fallocate rollback
      mm/shmem: rescan after nonuniform folio splitting
      mm/shmem: fix truncate hang in large swap entry
      mm/shmem: preserve allocation errors when swapping in large entries
      mm/shmem: fix truncate loop after boundary swapin failure
      mm/shmem: fix accounting of swapin-error markers
      mm/shmem: fix truncation of files containing only swapin-error markers

Eva Kurchatova (1):
      hugetlbfs: enforce F_SEAL_EXEC in setattr

Josef Bacik (2):
      tmpfs: keep the quota soft limits of an unused id
      tmpfs: preserve explicitly disabled quota limits

 fs/hugetlbfs/inode.c  |   8 +++
 include/linux/memfd.h |   9 ++++
 mm/mempolicy.c        |   4 +-
 mm/shmem.c            | 132 ++++++++++++++++++++++++++++++++------------------
 mm/shmem_quota.c      |  28 ++++++-----
 5 files changed, 119 insertions(+), 62 deletions(-)

---

base-commit: 183895979c441e52dbd651b388553b09eaa35cfa

change-id: 20261025-fixes_shmem-2782719b130e

--

Cheers,

David


