Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FC11606A31B
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 09:40:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jblt39Dj
Received: by kanga.kvack.org (Postfix)
	id A93F96B05B1; Mon, 26 Oct 2026 05:40:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A44206B05B2; Mon, 26 Oct 2026 05:40:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 933606B05B3; Mon, 26 Oct 2026 05:40:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 665F96B05B1
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 05:40:52 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E1A98120743
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 09:40:51 +0000 (UTC)
X-FDA: 85364283102.19.24EAE2E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 172F1180003
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 09:40:49 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jblt39Dj;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793007650;
	b=LhsM7KwKYlwF8tQF6t8hknWF1SsElWmv8m7awmzJGYNqMUF8wYQJaa4U9ef6ThfUcojp6/
	55CF1kaJgOjprg1JtpOivtVJV8r0+/Efo+oojUOF8gk73Rzm6yTeSvvtgkdz+msOO+heco
	oCnreKCARfv7iYYFWsh4AxBjhpgr4CU=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jblt39Dj;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793007650;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=2BjP65a0dju6snpvx5OIcMNe63lU1CrZcjwyc0/9yUs=;
	b=j+VeN5CNWRKCOMZxjizqgIU2G3PHofWQPShq9efVKZfXHJ2JabTtkd1E0JD2RUdTk1vNRr
	d4DMTbo+ND9FwoRfde/lbtyOBmrPriv1LsDX2BvVYPIMfhQd8EW8JujFbZ5fPrQoSMXhdF
	aXLLDdGAMJayHhmc4Ts8VqqACzOowpc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 109ED43E10;
	Mon, 26 Oct 2026 09:40:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A99C81F01828;
	Mon, 26 Oct 2026 09:40:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793007648;
	bh=2BjP65a0dju6snpvx5OIcMNe63lU1CrZcjwyc0/9yUs=;
	h=From:Subject:Date:To:Cc;
	b=jblt39DjKjWhCyE2330ECduwS0UxtYU/7n9ZMoQmM00C7NoVq1UENPRqHevUYt394
	 LMhihUwoEFZQiPQznsRmxR/ZCZe2iKHd4ia6ANaY/JzIUavv4BwjpVgX/hSQmf1VGS
	 nXuL337J8he9sx6J8mvdIoFUMT8vLD4EtTHhcXmrOsWvRdybiF8EnWEbU9G7JOSGcm
	 BNBX4DEqPchaadGDXYfPqy70QHZQtR7kBnO3Ae5AHRxKf9wj2ZEd8zaYkkCxxBV9K3
	 flr1fdXYV7b96+jtpKxju3u9cDO2dkuU1Uj5um/QwS4KZLBQdMksmaRx5+uxaqUaxG
	 UaOwvCbUKAysw==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: [PATCH 00/16] mm/shmem: various (urgent?) fixes
Date: Mon, 26 Oct 2026 10:40:33 +0100
Message-Id: <20261026-fixes_shmem-v1-0-703206d5fa0c@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIABEg32oC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIzNDAyNT3bTMitTi+OKM3NRcXSNzCyNzQ8skQ2ODVCWgjoKiVLA0UEN0LIR
 fXJqUlZpcAjJCqbYWAE47UcJvAAAA
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
 Josef Bacik <josef@toxicpanda.com>, 
 Eva Kurchatova <eva.kurchatova@virtuozzo.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4200; i=david@kernel.org;
 h=from:subject:message-id; bh=2I+jzvosTRnUx4luk06Osx1EmmShNw/DPI/mK6ve0MU=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLLuK4jmnRLcK1cVtXb5V8EzQTxlJ/L9P6wuWS3hyV/Hu
 aXo3U7FjlIWBjEOBlkxRZag4PsGL1+uq61242OGmcPKBDKEgYtTACZSOpfhF/OLQzsbA1cu19rJ
 vPWr+6Yo0fOpkX5TzvTny84UFboT5MvwP069749jdd3s5VsCZ+1xOPbi4ObXVydLrhdRF/erL1m
 dzg0A
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspam-User: 
X-Rspamd-Queue-Id: 172F1180003
X-Stat-Signature: 55dzreyimheq65k1mdwhx5wpwif48xxx
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793007649-177934
X-HE-Meta: U2FsdGVkX18jPPN5qQ/0ArBYuJ3ghYNAo+ArEcnjHY2Chuv3HrZPA9SaACOAwMKjPgB7/oJU5FUqvhsjj9U0o/eLOG8u+J5qxdqWHchgYIPx0+X4aCxFaQB0Umz8XjOEOAGXeJe8TveMOdq5hZuZSOdthHMb98aZnk9GwcaGeeFoLbjsuHPurSkNAmkAKRXPjwpM6+D2hZlqIpYIx5PdQ6EBpgmmOBiWGrsIGZ+Ik5HrytRb/QvpLnoJUAwBTgop8zwFb8bSwGyHD6yG9PzbpCHBeJXnBKUYnoVoQ7GX5qOVnD3CRD7Ju8Q6ap6siclgaYUPJc9aR3HhfeUb8eVj0WTuYUVjxpFNgu0ZbWlsO8mX6w/Poagz/qoFXHtJd2wU8GhSSKimGR44EZy8CtpJWlzxmznPc7btf/FsLV56wXhPCvcUnxeJA0wo8i8ZsxMUtrp+sLubHdeG3IPw1yb1BxTbKbDxWoFwbVLpRsWbCLbjmHujCUKnaryWhtj+xoYwev8PuG9B4JKLBxhSRJmgyHw5LjlyS4ekT5v9o/yql/eafRma2XuZur7FueC8ZdAaBPGlblTcnMuBelnhEqWDViOJLYW+UISC5TxLoHY3IVh6dlAylC8L1XaiEc174iQK7XsjxUIvAMX/NiMjbXkEt7Ru757GQXcBb7OrJNXNEuTIG5/pjldFXMK1h7KDm3/08xGCGMwU+oOdTaItqA/9R0/F4L8JT6dWJojBwc5JeqJInW8HUFkYX3SM2aCz1sp1jYXigk/BdFOjIzuJTVzW/yzgxQo7SvshqptkkU1ArYQQ+akMnV+EOHG6PseVYGzhH9sJ2x21ZJP+KNWYQSVOjvhosIrDbDG1Rziq6b5Q6lrLLB/S3drMVJXcZRMHV9q2RZIa0tkTuroRV9UFxwbcznTCOvEFt04YfURR0Zn96Vw6aCUPUEzueJs+Unxff7nSNTk6uC+6z2BgoN1qyAc
 +qFuhH3S
 Ya/DFWj5PrEMtZG7KkIzZbtSGh0Ow/DvvZTdaRZIse6iRBhABgmFXrEAFD80ZewcVJPpCFIyFtkHJCnJVvPnKrUV20ZkMWWgGAsp/yPmHJ3DOTjXJZ1U4KS5JnRMd+e5bWrnC2bLXQDGUf8bPWRbXWxE+sz/8aqdnAzNz3cpkvdVmxM2QnM4/yceS2khDOQFOXYzhoGGt8ltP44DpRZxe/jDKKJesQBGNA6jYGclokvdbVbZo5iUR/QekRe4z7a8sBEn/lXO/3dBgqrBuDStQ+2iRawa6nfTndnj5gelRBH1IqzqAicsRL4ZAAHW5WzJPlfsvNxoTIrX0Scf2nveeGvgOfMTvbHPw7bbq5/PVEn+0ozc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi,

the fixing fun continues.

This is a handful of fixes for shmem/tmpfs. I sneaked in a related
hugetlb fix that stalled upstream.

Some of the stuff is more urgent (patch #1, F_SEAL_EXEC, truncation
hangs), others are less urgent but still rather unpleasant.

The majority are fixes from Anthropic that I cleaned up or reworked.
While doing that, I found a bunch of other issues and tried to fix them
somewhat cleanly.

In general, shmem + swap handling is a nightmare. shmem_undo_range() is
such utter garbage it makes me want to cry. I mean, really, WTF did we
end up creating there. Does any expert here have time to clean that up and
make it *actually* maintainable.

The following things are still broken in shmem_undo_range():

(1) Truncate/punch of a single page of a large swap-error marker

We don't split. Consequently, read access afterwards will still fail
instead of returning 0s.

I have a fix to try to split (which can fail), but I don't consider it
that urgent, really. So I'm not including it. Might send it later
separately.

Truncate/punch of a partial page can obviously never do the right thing,
as we cannot poison parts of pages ...

(2) Truncate/punch whole pages within part of a large swap entry

We try to read the entry, but if we are out of memory that might fail.
Consequently, we will not free up swap space and a re-read will not give
us 0s but the previous content.

AI proposed a nasty NOFAIL patch which has too many nasty side effects
IMHO (allowing users to force-read pages and retain them afterwards even
though memory.max would disallow it). This needs a proper thought. Likely,
support for splitting large swap entries (and large folios in the
swapcache, which I recall is under development  by Kairui). But splitting
can fail ...

(3) Truncate/punch of a part of a base-page swap entry

We obviously have to read the page in, in order to 0-out the parts to
discard. That might obviously fail.

Maybe we should install swapin-error markers if swapping during
truncate/punchhole fails, to at least tell user space on later access
that something went wrong? We might affect unrelated data, outside the
requested range, though. Anyhow, these are long standing issues and
I don't consider them urgent.

They need a proper solution.

I did my best trying to test these fixes. I was able to reproduce some
of the things (including unkillable truncation hangs), and the fixes seemed
to help.

But again, shmem_undo_range() is just an absolute mess.

Please prioritize review of these fixes, I want to get fixes for the
issues in a timely manner upstream.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
Chris Mason (5):
      mm/mempolicy: charge shared policy nodes
      mm/shmem: honour F_SEAL_EXEC when an ACL is set
      mm/shmem: avoid moving the truncation start backwards
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

Josef Bacik (3):
      tmpfs: keep the quota soft limits of an unused id
      tmpfs: preserve explicitly disabled quota limits
      mm/shmem: hold off eviction in shmem_writeout()

 fs/hugetlbfs/inode.c  |   8 +++
 include/linux/memfd.h |   9 +++
 mm/mempolicy.c        |   4 +-
 mm/shmem.c            | 170 +++++++++++++++++++++++++++++++++++---------------
 mm/shmem_quota.c      |  28 +++++----
 5 files changed, 154 insertions(+), 65 deletions(-)

---

base-commit: 21a7f44fd0765fcc5194130b28767786eba1d1e7

change-id: 20261025-fixes_shmem-2782719b130e

--

Cheers,

David


