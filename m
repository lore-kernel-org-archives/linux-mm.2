Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00EF560A2604
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 03:46:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=2212171451 header.b=D2qMxH3s
Received: by kanga.kvack.org (Postfix)
	id 097596B0863; Wed, 21 Oct 2026 23:46:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 047C36B0864; Wed, 21 Oct 2026 23:46:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA1926B0865; Wed, 21 Oct 2026 23:46:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C8D156B0863
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 23:46:45 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 38140A03FA
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 03:46:45 +0000 (UTC)
X-FDA: 85348875570.19.13B11C2
Received: from va-1-113.ptr.blmpb.com (va-1-113.ptr.blmpb.com [209.127.230.113])
	by imf04.hostedemail.com (Postfix) with ESMTP id CB42940002
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 03:46:42 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=D2qMxH3s;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf04.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.113 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792640803;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=ak9Yt3ZKqjQZ+ffqqFAUaAH76ucdHQO20qi5tefMZ84=;
	b=nQTC2NuG1dXEHdk5XXOhrWvrUjXmB6ZszpRbwjjOY/YcY032HjSBpsygskqwCkaZyKbFlC
	JiPLuLFI75wZWQtPYab6KEr+nbG+1n66MjgXhHg9tuyydAat6+i+ayljcSazX5a+efYmMx
	NgdQTiL55lV3gZfPgKFxkg9p1+PEzQs=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=D2qMxH3s;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf04.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.113 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792640803;
	b=oXyoOUg8a8lrij7CK8fj3IqMaa0WbPZBj7azfqucaspmNpb3yBI7GzbURVFtv9rdT1suIR
	DF4rySHeLxOaD9KXChVGDEVdEDaWMV5U9UYD/5YM773q7PeOPjpyCDOFNxp/MPKiBVI7fz
	zUObpVTCBAp+k6R42HRFb4OegE0SK5I=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1792640795; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=ak9Yt3ZKqjQZ+ffqqFAUaAH76ucdHQO20qi5tefMZ84=;
 b=D2qMxH3s9DocpSbe58hyFFdh81bRwzcYf3nwLrBeRwIYco6J/lFiRUxWjgab1+Sxvp/Hv7
 Ipl+McGOLBZtJs/1a35bqzzfZde4BhB4zRyT0nmNPaH7QLBGuXqUX34BosLj3gzvs/jnj1
 VHvDbVIj7qfZZJODn7KeNPmC/Wwx0AHuuMubW9sDpDK+eO1Cmi4r6mBfiQTTuUenq0w0rN
 54Ir+pnKA9EHhIp5FfhyrPQeR/fmOdYojJNr7Yl4cXYU3ezMpaUdc5HkDh6fIBVKiexPNC
 vks/okIhI9roBR4H0coMywoHxZPPUSbrYQ2Di8n8JPXltSZPT5HhxIRrUBR1DA==
To: <akpm@linux-foundation.org>, <david@kernel.org>, <muchun.song@linux.dev>, 
	<osalvador@suse.de>, <peterx@redhat.com>, <rppt@kernel.org>, 
	<azpijr@gmail.com>
Subject: [PATCH v3 0/3] mm/hugetlb: fix mremap bugs
Cc: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, 
	"Li Zhe" <lizhe.67@bytedance.com>
From: "Li Zhe" <lizhe.67@bytedance.com>
Date: Thu, 22 Oct 2026 11:45:40 +0800
X-Mailer: git-send-email 2.45.2
Message-Id: <20261022034543.51226-1-lizhe.67@bytedance.com>
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
Content-Transfer-Encoding: 7bit
X-Lms-Return-Path: <lba+26ad9871a+85365c+kvack.org+lizhe.67@bytedance.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: CB42940002
X-Stat-Signature: 8kcrs8i4btdf7zw9acm5eeawbi69583w
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792640802-709366
X-HE-Meta: U2FsdGVkX19PLJrnpqGtC3ukMHK+lH2CqKYDHJor4xHpvLpmRAnggFozGsXGHiZlGs1oXvmsVBMAXUxgxQnyA9lPGDWc422VkgES+DLSFd+plFUtEBWX9BtLt8gmmtlCwNh8pewwZt5MrCwEKozmDCbZGubAR/SDbaxi6MIwwivw4Cx7rfVv4Su3HkjTuFXj1dAdLzFDxjgzEu6z4e4N15vagtp+hGJTqqSjc8shG7WNzu9Hj6jGqME1JFvhcgiDyEFzGcYPU9o8LZCMoaezDJA9QmmS3lXQ2cLUtrv/ARSkGUnQ+1l1CeZ/9wv3dN8JTPQb6T4u+u0bl3kFrYh+hlmNhKPvh8C+f3OWDs+/wIgN5UmgK3SnmE3nctzljNpnL+MAWTcp7plBqJpsHuWPsASGL+g3FFXJfgPkuoNGa2y6M3dtolQwtzXy2GXYYR33kPz4iR6aoIuEbOx1WPCUaaQzZgMISHUCF9w7kVOGTZBbzrw79PF4BDaGltu83Q/2MvIaQyVFo/fiUKNkJ4G2huG3G8GbByYmFR3Nyktua+qI7SXv+Wa12JwPQ0OJs0FzFFuDpCEtpkb7/x47wBgzq5gzjplHoPm//OcN2E/eARnTb4kuP8nfRZzxtB3pPUFaHRi9wFOH35W43d9zPU6Rm+U+M1m1pGf0Jpmj/iakN//EVewshRCHcUmP5LCsU0iqIi3blMgHOGTduuocn0Ot0BmEB4DWlupdxi2V/2eAxKsxG5UROTrDcK/EFh2m+Y3jnOLtxyT1uya/wiuy5HZrohg1jirOMek0VkdmYqFmVTnBWIS1WvITkH6s0jc7liJtOflANtFR6mk8Roe4YwCuJy9VAaTXjG85Tlo82wIUXsthTs+NpEqqgXGikIJ8GTUeOG/bpoVzs7mUOOrnSFqn65GAzCzLaIDmOzlTU4Tl4tYBFY8gRb0nBfI/3NMT1DygGTNOCr18D0yQrZN0/7B
 vm3Kv/Yd
 NRRfVOXuUZabG9Zr83ZyPokv4gELGIDkJoQIQq7QMC9nwVzlS7iQ3J7oY8RBEKC+lfm+xR0bdL6W2JvR1DbDfrlCRW8ezQwlm/r+fthHfbym//pma9qQRgPjPgMQPSIsuvldRYledjJl6r9jgoXpmTSj1DV/j4S4VXgpiEHavpdJYZWbboMqxmdNFwtzk+owIoa0V6wi9dtBOxdqtE/hVrnTEdqJtEbUVbFkWaqA5OTDWjfeJSmO9bgYGenQiRd8ne22HswePQ/5YBjTja2xT03Agug==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

This series fixes a few hugetlb mremap bugs.

Patch 1 fixes the return type of move_hugetlb_page_tables(), so large
hugetlb moves cannot be truncated when reported back to the generic
mremap code.

Patch 2 disables hugetlb PMD sharing for UFFD missing mode, so
UFFDIO_POISON markers cannot become visible through shared PMD page
tables.

Patch 3 fixes the recursive i_mmap_rwsem deadlock in the hugetlb mremap
path by avoiding the destination PMD sharing allocation path while the
mapping lock is already held for write.

David Hildenbrand (Arm) (1):
  mm/hugetlb: disable PMD sharing for UFFD missing mode

Li Zhe (2):
  mm/hugetlb: fix mremap move length truncation
  mm/hugetlb: fix mremap deadlock when PMD sharing is possible

 include/linux/hugetlb.h       | 15 ++++------
 include/linux/userfaultfd_k.h | 16 ++--------
 mm/hugetlb.c                  | 55 ++++++++++++++++++++++++++---------
 3 files changed, 50 insertions(+), 36 deletions(-)

---
v2: https://lore.kernel.org/all/20261019113034.97690-1-lizhe.67@bytedance.com/
v1: https://lore.kernel.org/all/20260930064308.58159-1-lizhe.67@bytedance.com/

Changes since v2:

- Add Cc: stable@vger.kernel.org to patch 1, as suggested by David.
- Use double-tab indentation for move_hugetlb_page_tables(), as
  suggested by David.
- Disable hugetlb PMD sharing based on the userfaultfd context instead
  of checking individual UFFD mode flags, as suggested by Mike.

-- 
2.20.1

