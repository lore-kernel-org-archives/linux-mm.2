Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D1FC606A319
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 23:34:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=g7QSiiX5
Received: by kanga.kvack.org (Postfix)
	id 9E2456B0261; Wed, 21 Oct 2026 19:34:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9915F6B026E; Wed, 21 Oct 2026 19:34:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A9296B0270; Wed, 21 Oct 2026 19:34:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 69F6C6B0261
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 19:34:58 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CC05F404EE
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 23:34:57 +0000 (UTC)
X-FDA: 85348241034.29.0794C43
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 328A240009
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 23:34:56 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=g7QSiiX5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of kaloz@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kaloz@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792625696;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=s5GCFuOcmjehv03gf2ljnWIxHgzVxKtBI4zuJ/1eB5M=;
	b=kgO+MtJ5bUHwkPo3VqQ3pfGgE70KTXVj5VxsAUZBwQVW7fH4fhN/USksw7h3GXkrQ3s0mu
	20LdwawyiP9WNjPYepoALD5nkEwkXfKmCCp8XBpyrU66PmnIRR5hL+a0CJTEwmVe8xkq5C
	9Ux7C+14i4C91g4Inw67KHtpV1+wZrI=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=g7QSiiX5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of kaloz@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kaloz@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792625696;
	b=TABLZyTS8IA+FYvo6ZLHnqPfkUCgaTpRaTSp4ZuGfUnSZjS991Dv/dSqsyZeDNiGpHqBLx
	hQiTzjYDkqZ3mvWnK8YEdERwy50mbwFyLy3y6Ij7PIZZghJDgbcxWtRr/Ew7wZDS2uLZ+S
	ZLHreCyztGSW/13/uN7EzwW952REssA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 19E8E4059F;
	Wed, 21 Oct 2026 23:34:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E49211F000C1;
	Wed, 21 Oct 2026 23:34:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792625695;
	bh=s5GCFuOcmjehv03gf2ljnWIxHgzVxKtBI4zuJ/1eB5M=;
	h=From:To:Cc:Subject:Date;
	b=g7QSiiX5u84k62YLZ3c1x3+ueZUgWrw+FaS8iLWpFy0ypur0rpeshW6hISOU3LpYX
	 q3LMdDTnMxORG/nxYgtnD0CXjNK8MnxAqtqbWxg2MKfUZuBonSM6Qr4rQFgK80bn3W
	 ZXOfZwioE33FPbSA7dgVdF4F/+gOyhGEXfpso+uOr/gnugw3cI15IifZZ6Xa0rI84d
	 Z8/oljAK0C56CAxKlujvNRho9+H+tS3+1hH9PqcAKAl4t0ex3rl2ORUxbxj+EdygHm
	 g12QQU5IEvMSlmKsEbOwIj5paUUVN/lUxzNfgfeoO+vCq9caYtyD8jyXZwdrmX0MCd
	 vCT6K/814OCtQ==
From: Imre Kaloz <kaloz@kernel.org>
To: "David S. Miller" <davem@davemloft.net>,
	Andreas Larsson <andreas@gaisler.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	"Mike Rapoport (IBM)" <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	sparclinux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v3 0/4] sparc64: D-cache alias flushing fixes
Date: Thu, 22 Oct 2026 01:33:36 +0200
Message-ID: <cover.1792609488.git.kaloz@kernel.org>
X-Mailer: git-send-email 2.47.3
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 328A240009
X-Stat-Signature: ihhrp314wkpy9tky6gjwd3hc9qrkgodw
X-Spam-Status: No, score=-14.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792625696-872793
X-HE-Meta: U2FsdGVkX18zEKZD+sVBfkyRFq7dVJpVL/ssW8afF7LXkEOuoRm5EQzaYsbJFXTvDZfoelidgN+2NY8vV2by67RgUGZxeAfYCRy4kGy3sAAxA8ZmXaaiuunb5bKmp5BjgRXFG9OnQQciwWICKHVNipjgAIkHxSuW2LSosRZlHrIhl4Q9RYOv/rCZAmvpYpwUaGRmAxLKnwvhnyfoj4dGc6Il7/5sP6g+DD5z6uPBDrQ6xZxcq3lgrXLt044Jp5/AUL3MuzEkIfgga+fkUKo/8Nwr4hHKmMlfCknZw1dE6Wc7U6M8CUy3cZMT/re8MTLILlg70DA5BV1OOUqc6i9eyHGB4eLame5rVZh+MUx/m+UW0Z9F9MdcfF5jmeDkUO5ZKbQ6bXaWt8UAUGEHwP5df2GVAI8DTgXdCl+NH71V+ndS1XjoBM6N//4I0se+dtzpcOS7iFuBMd8/zx98a6K57ydToQvFhgQGJEdoi+TD8ZfAPz4wtyzPEvbTf/pkvAK7/J6oOFJlNB7JuJh57793mll2wIIIzRDaWr+WEbF1QiwE8oxNegacv3xDAh2XGh6pO4gIbDoy1Qn4loPwBbJIu+haJhYziZSJzB3I1MUo/tBCGMcWKTPg0oyONfxPTzjTLqAmBSXU6WZZymzbTOrKx3kCmOw9LfLxUOzxxywasTfiNCEX9p67ieaWp/iAVhXXjBbRTxWXq4PvutinFZQn0C2D9BkQaIxya5wtzWhvT129+O84U294P5h6qXfsYaxeRJySBuy3b8UreCM39Vf3SI9JuO8VRRaE4FJAN3WQlP/KXaX3Riw+0KZqc5kvJuT5/WRkAImWKW32CNJLWB9kSo+5QVxAKkdNoF3gKS++xZxsiaiqCnF8RgCGfTWie++XaiGT0kPZImNuSceRUs0kcwP573wY59k2yO67Ynk9/VOFR27vXSsEB+a6xdIGpo2HCXqp+lz+AhSZEBF9C+m
 8+5X44RB
 TeFLfBD1sVU7lmJtzt/ASbpR8TkiRNMsi0pT6eSrf9h4gOAgVPrVnSE4x3ytBPT/xiKCmWaU946OAuU1kw0yn7qAiSr8PQ6a5urrI5/0T5LTRsQ91alloysQErWxMUn2tdAsiU0+pefXIW8l/OihQ0PAXaZsYsWgMmdFFY1urFD+9CR2Qp5bolNXalhyY/G1sclQe8RWy+z2+UmF2KdgBVsUdTRixF80+hRY4m5GtyOPdQ2Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

These fix D-cache alias flushing on sparc64 CPUs with a virtually
indexed L1 D-cache (Spitfire and Cheetah).

1/4 makes xcall_deliver() bail out before it touches the trap block
when there is no other CPU to call, so an early cross call, before
init_IRQ() sets up the mondo blocks, can't end up writing to physical
address 0.

2/4 flushes only the page a PTE maps instead of its whole folio, which
removes about a million redundant page flushes from a colour-changing
mremap() of a large folio (7.3 s on a Sun Fire V240).

3/4 implements flush_cache_vmap() and flush_cache_vunmap(), which have
been no-ops. Stale vmalloc lines corrupt BPF programs and module data
on UltraSPARC III.

4/4 passes the number of PTEs to move_pte(), as Andreas suggested. It
touches mm/mremap.c and include/linux/pgtable.h, so it needs an ack
from the mm folks.

1-3 don't depend on 4 and can go in on their own. 2 and 3 are for
stable (3 needs 2), 1 and 4 aren't. The series is on top of the sparc
for-next branch.

Changes in v3:
- new 1/4 and 4/4, following Andreas' review
- 2/4: reworded the message and the move_pte() comment, marked the
  UP #endif
- 3/4: reworded the message, dropped the Suggested-by (I have no
  email address for nsafran1217, the Link credits them), noted the
  stable dependency on 2/4
- picked up Stian's and Adrian's Tested-by tags

v2: https://lore.kernel.org/r/20260928132102.1707-1-kaloz@kernel.org

Imre Kaloz (4):
  sparc64: skip the trap block in xcall_deliver() when there is no
    target
  sparc64: flush only the aliased page, not its whole folio
  sparc64: flush vmalloc ranges from the D-cache on map and unmap
  mm: pass the number of PTEs to move_pte()

 arch/sparc/include/asm/cacheflush_64.h |  9 ++--
 arch/sparc/include/asm/pgtable_64.h    | 14 ++++--
 arch/sparc/kernel/smp_64.c             | 51 +++++++++++++++-----
 arch/sparc/mm/init_64.c                | 65 ++++++++++++++++++++++++++
 arch/sparc/mm/tlb.c                    |  2 +-
 arch/sparc/mm/ultra.S                  | 25 ++++++++++
 include/linux/pgtable.h                |  2 +-
 mm/mremap.c                            |  2 +-
 8 files changed, 148 insertions(+), 22 deletions(-)


base-commit: 2bc58762a3d74e42de129d717ae3ba10ecf0ab96
-- 
2.47.3


