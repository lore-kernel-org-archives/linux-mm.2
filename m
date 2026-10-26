Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97901606A31D
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 02:56:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=qjtg23Kq
Received: by kanga.kvack.org (Postfix)
	id 720806B05B4; Sun, 25 Oct 2026 22:56:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A9ED6B05B5; Sun, 25 Oct 2026 22:56:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E75A6B05B6; Sun, 25 Oct 2026 22:56:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 337F96B05B4
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 22:56:17 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 987D61A05DA
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 02:56:11 +0000 (UTC)
X-FDA: 85363263342.21.9ADDB0F
Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	by imf28.hostedemail.com (Postfix) with ESMTP id D9488C0002
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 02:56:08 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=qjtg23Kq;
	spf=pass (imf28.hostedemail.com: domain of xiangzao@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=xiangzao@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792983370;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Iy8CvcCXZdt7wKCpczgHps2OAcckKLpjCVLtI0G4qWM=;
	b=cO71treuoXs1IM20ywpS2l7cmLJipbDeSjEnP2db09sEmajt7Ik9N1A2nNpDbfTfer0X+V
	89mUXDcRcJlYKj4YJPyxOS7OXp8BoU3W035Ncd4IFCXVsTZSqff0EIsNmHIgGPDfgt/7Eg
	dFJ2BJCGqcFNtPvr9Ot46M7HEwG2/Ks=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792983370;
	b=latsuKnyjQXGiuEz8JN9UvopkqGWSXj7gNlRwn5NlwchogLoi4FkzmWEuWVISwjdet3bKX
	GGY8VyF6rPl3aQOLmGTcSF4Mo+5jKHQynh8TVKjEueWQ30hr0F2YFm2UqnwTr/eBUNUlW9
	L6oDMz8EPaWDRycvrTXgucKT7x0oTaI=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=qjtg23Kq;
	spf=pass (imf28.hostedemail.com: domain of xiangzao@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=xiangzao@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1792983365; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=Iy8CvcCXZdt7wKCpczgHps2OAcckKLpjCVLtI0G4qWM=;
	b=qjtg23KqXvbHNxhDOmWGfWXcMHxuDmwjqmNEglUhFxZH960W5g2ZwyhQZq/04bb71wly8qV4XxT41AoQLgcv0jZaAgNjEJ0S4ttnPvso0ewvfu8L6o3CXCEiEhJyfFpMEJa2hzN7HmQooGCIKFIRMsXwK9wsDfj8l1YwLlEtGGs=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=xiangzao@linux.alibaba.com;NM=1;PH=DS;RN=16;SR=0;TI=SMTPD_---0XDRaMdK_1792983352;
Received: from banye.tbsite.net(mailfrom:xiangzao@linux.alibaba.com fp:SMTPD_---0XDRaMdK_1792983352 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 26 Oct 2026 10:56:03 +0800
From: Yuanhe Shu <xiangzao@linux.alibaba.com>
To: akpm@linux-foundation.org
Cc: david@kernel.org,
	"Huang, Ying" <ying.huang@linux.alibaba.com>,
	Kaitao Cheng <kaitao.cheng@linux.dev>,
	vbabka@kernel.org,
	linmiaohe@huawei.com,
	nao.horiguchi@gmail.com,
	ziy@nvidia.com,
	wangkefeng.wang@huawei.com,
	tujinjiang@huawei.com,
	mgorman@techsingularity.net,
	chengkaitao@kylinos.cn,
	muchun.song@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	xiangzao@linux.alibaba.com
Subject: [PATCH v2 0/2] mm: don't migrate folios containing hwpoisoned pages
Date: Mon, 26 Oct 2026 10:55:50 +0800
Message-ID: <20261026025552.1427901-1-xiangzao@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D9488C0002
X-Stat-Signature: o43hudwb9jjsdu15jsq38uqb7isgfmg1
X-Rspam-User: 
X-Spam-Status: No, score=-21.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1792983368-144649
X-HE-Meta: U2FsdGVkX1+AE5vufrE1CElipM7UmyX7qtHr3u2uMqoaXGAz6gI866IR4p1s/Zrv3m34uE/btEMS0rB44xXzCdT4VcUdaoYKZZO1H/IBKrnCC9R1jw3hlAqKRVXEbANfSbzKURk5j46qmCqOQug3Aeu/HfkChe7DwD88sV65CXrkZNqNooM7OTxw9TOdRBuJMi8fWmQIKUAx4HpTBBvqQuGazycvfUgHE5tsCkZitj2f3I/Ar3zYhC9c/G0fuiTvcH9I9Y9qzk8AIHGFU6Am2/oUG73Ba+hOXclvokJNUUOpv5a3wLJ8WFON/lpWy9r8gUEj+JUu9w6VuRXgNXWEWydWEuhzkWa8rb8WA6+Q/HKRif8wspd71G7bIhIUA8d8Kkk73JQw7c/qCJMnA8KR4IHb7zUD+ANnPnxY+saEMJ6oYByHIUEbgQYjNqT05ohUpXKIWoqfhTRhEL0hxoZy0ne+tIXNOvsR/lPLP0WjGtIdxF0ewtf+m8F7qIHGVUYuoXgIwwJ4HixOChvhD9XLDnkQM4CNNfXkv699W2LamBqFuS3Y449T8Kkft+0V7Rnl1H+la6rG6EG0CBhFOSF6omco3S/98x6vgMszrFcoMIi0PyA7yP3gIeXjArss/sA6MLZcunBgLE/BLZnpIH4vx8M+0GjwGsuLP531E2B94X2WFzcGm4ARmGQdcu0UNJsZlavBM7aGRjQrbsK3Wit+Y2FcQATMc9N0ZJ6c+Y0g8iR0LKPHfla4xjbeHFri1CCzAmwjf4V5dgcSuM+nCyfkTMliE9W/eLv5JDModGtxKhB8ZmvMSbWeQEM9E/WB3smZYCAY3knE/iySbHVBt9uylDiXFmTY628EwRjtcSHLT9pWO42pzuve4DX+bPHP91mGIsLggyARkiw82HCICgKlmySbz9fzGWRF4keuVwEzqWtIQVx+oAw9f7juFyRa+9oOnfVIERA887fYYeu4Sli
 QwMU2pHv
 yH49o/oGphS56xqwyavG8matqyOYTJxd/HIgg0SjJCYhRqrtwyHfPPv1N+7ALLvTD7t6ZGIygaVSddKj9UsvceJ8rAxUQwMPeg4mw2sxWL0xvjx2mne4aJm1WFajQW3nVRy6f/1VuYj9t0MZmvSwgmICezy9b6sO5+jwmX+Leq31T+E02SyXdL/g9yCCQ0+9mgzkOciS6UfDAlYP9BRKqto4kEWYgrlY2Ucf2AVTa8I5tpj3LjfJ6rS5+76SQoEcCD23toE38mPEGHCQqJLy7+BpOWDX2N59APKZmhSkAvb2bHdumTYi3NjbUcbmrlku7GwAOkiskgxlwRaX0kCBckIlYfQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

v2 of this series.  No changes to the approach; the two deltas are a
wording correction promised in the v1 discussion and a third check
suggested by Kaitao Cheng.

memory_failure() can end up abandoning a folio while PG_hwpoison is
already set on it.  Two ways to get there:

  1. Race: any isolator (compaction, NUMA balancing, move_pages(),
     mbind(), CMA, long-term GUP) clears PG_lru from under
     memory_failure(), which then fails the HWPoisonHandlable()
     check, exhausts the get_any_page() retries and bails out with
     MF_IGNORED - without holding any reference, but with the flag
     set.

  2. No race at all: the THP-split-failure path
     (kill_procs_now() + MF_MSG_UNSPLIT_THP) leaves a large folio
     on the LRU with a PG_hwpoisoned subpage by design.

In both cases the migrator still holds the folio on its migration
list and migrates it like any other: the corrupted data is copied
into a fresh folio with no poison marker, and no hwpoison PTE entry
is installed on the way back, so the userspace mapping is silently
redirected to the corrupted copy - no SIGBUS is ever delivered.

This was reproduced on v7.3-rc4-75-g62f4c998b297 (the base of
this series): an order-0 stress workload (madvise(MADV_HWPOISON)
racing move_pages()) left the poison flag set on 8426 abandoned
folios in a 180-second run; 698 of them were subsequently
migrated, and in every case the address then served the copied
corrupted data with no SIGBUS.  With patch 2, 0 of 9711 were
propagated.

The compaction-side guard is needed regardless of how the race in
memory_failure() itself might be addressed: the steady state
(split failure leaves the folio on the LRU with the flag already
set) is not a race at all.  Deterministically validated 16/16
poisoned mTHP folios migrated unpatched vs 0/16 with patch 1,
with clean controls migrating 16/16 in both runs.

The checks compose with, not replace, copy_mc: folio_mc_copy()
still catches real-DRAM corruption during the copy on archs that
implement it, and the flag checks refuse software-injected poison
on all archs before and after the copy.  Extending the
!ARCH_HAS_COPY_MC fallbacks of copy_mc_user_highpage() and
copy_mc_highpage() with the same flag check - which would also
cover their non-migration callers - was proposed by Huang, Ying
and welcomed by David in the v1 discussion; that is posted as a
separate patch right after this series.

Changes since v1:

- Patch 1: the isolation check's claim is narrowed to folios that
  are already flagged when compaction sees them ("avoids the
  migration of a folio that is already flagged"); a poison landing
  after isolation is patch 2's business, as David pointed out.

- Patch 2: a third check after the copy, before the mapping is
  transferred, suggested by Kaitao Cheng.  It closes the copy
  window itself, which the debugfs corrupt-pfn injector can hit
  since it has no GUP or PTE ordering constraint.  In the v1
  racing workload the pre-copy checks already propagated 0 of
  9711, so the new check is measured-neutral there.

- Both patches carry Assisted-by: LLM, as promised in the v1
  discussion.

Yuanhe Shu (2):
  mm/compaction: skip folios containing hwpoisoned pages
  mm/migrate: refuse to migrate folios containing hwpoisoned pages

 mm/compaction.c |  8 ++++++++
 mm/migrate.c    | 49 ++++++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 55 insertions(+), 2 deletions(-)

base-commit: 62f4c998b297cf233997a2b4cd6fc2d2df0319c9
-- 
2.43.7

