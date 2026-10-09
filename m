Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3FCA1CA6019
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 14:25:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F3486B009D; Fri,  9 Oct 2026 10:25:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A3D36B009E; Fri,  9 Oct 2026 10:25:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E1AD6B009F; Fri,  9 Oct 2026 10:25:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0A35A6B009D
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 10:25:14 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8F15D1C3ABA
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 14:25:13 +0000 (UTC)
X-FDA: 85303310106.14.AF3BB49
Received: from mail-106113.protonmail.ch (mail-106113.protonmail.ch [79.135.106.113])
	by imf07.hostedemail.com (Postfix) with ESMTP id 8EBD74000A
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 14:25:11 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=karaolidis.com header.s=protonmail3 header.b=fi35R3+t;
	spf=pass (imf07.hostedemail.com: domain of nick@karaolidis.com designates 79.135.106.113 as permitted sender) smtp.mailfrom=nick@karaolidis.com;
	dmarc=pass (policy=quarantine) header.from=karaolidis.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791555912;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=0ry/qEt4RcAqTFIzYK3t8eJQNo0m/0+YmGFQ1p2ujng=;
	b=6lmkhGufzFoLC5m+NSXuzAGZTwf9A6VgDBvb2Txl4t4w0QPXM3nbZk+JT7TkU3zPqq5Q+/
	lC4VrReF1yn6xl20snE0C4KB7DCMkvRBLhplckrWa2aEYPPUsh8FCJfHc/rb3BDrt6SoyP
	FG7EFX2JOlw3+UxVo7QkSNkhQSy8BpU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=karaolidis.com header.s=protonmail3 header.b=fi35R3+t;
	spf=pass (imf07.hostedemail.com: domain of nick@karaolidis.com designates 79.135.106.113 as permitted sender) smtp.mailfrom=nick@karaolidis.com;
	dmarc=pass (policy=quarantine) header.from=karaolidis.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791555912;
	b=X09cpyN3bNUdMf/Dj5idWYlYl4MEQkSYCxuGhaEMv0amAWBxcUfVr533EssEDMS0m9lBHx
	kd684sQxI/SXHX0DPjJEBt7i+SFjcuaEnouaPiqhtkpd0h1mHqho/km9fY3ZTJx95YMlUU
	vHYwRaOJjL1otf08gh4R11f8J6vLru0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=karaolidis.com;
	s=protonmail3; t=1791555909; x=1791815109;
	bh=0ry/qEt4RcAqTFIzYK3t8eJQNo0m/0+YmGFQ1p2ujng=;
	h=From:To:Cc:Subject:Date:Message-ID:From:To:Cc:Date:Subject:
	 Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=fi35R3+teJ1yCUX4Dbv3ad1OWvzyqTT73ihrUmXQewn40TRhfezIhW1OhzCpipLj3
	 5KtC6dNbbLpoiTLtPCehZp09NBIPvhoRPAaL+tpOEL9W0IEsD6Vjqjes/Mv/CrWkAh
	 znMUR1iSjqwKCJxzreVY75b9DXAZqXbrWwHNLF8ztgVG7hyhExCIwsMQszmePZ3J5h
	 eiWdwa1xtDc6yIJGVmLn3w0N8hXewm/qLKjU9JSjY/JvseZtzYX+q2rT3lJb7ZtEES
	 vhfwlxJqcwKZmPDP3akkWGilZW2ketrY7frK+Sr3+8pWn6fwAl6y76LGWJquW26wB+
	 FSoyhUpCStcBg==
X-Pm-Submission-Id: 4j1Tf961fLz2SdVd
From: Nikolaos Karaolidis <nick@karaolidis.com>
To: Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Jan Kara <jack@suse.cz>,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Mateusz Guzik <mjguzik@gmail.com>,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Nikolaos Karaolidis <nick@karaolidis.com>,
	stable@vger.kernel.org
Subject: [PATCH] fs: don't lose inodes that another LRU walker is isolating
Date: Fri,  9 Oct 2026 14:24:31 +0000
Message-ID: <20261009142431.713875-1-nick@karaolidis.com>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 8EBD74000A
X-Rspam-User: 
X-Stat-Signature: jqqup6nyb4exudms4hyk4yqdqcm3qdj3
X-HE-Tag: 1791555911-560422
X-HE-Meta: U2FsdGVkX1+RmtN7JF12haOHUYbhNcGBOQ0huVvmuEgE6D6mPuiFv4TktUtsrLWxOG1tsjXCN2TYB4x99z7WliDEMIyKZdMwrYvgmQdJdr62M8bJB9RahrZ0jVS8W2oJfP/Y5DJqScYadKmCmies9mVl3WU3scWMB09Qp/qmns3rQA/RZcVZ3/0LoX0dULlKorN6mmKFW2L2aLtMEijc8DvvkG2qM7WXcFsMTlAD5+AuP3oOk8eUCSrW7UGd+N1hjgVvxlOtWZOKL3j8Kc/lpsDsjUpcPQ2bZivfOay6tJblvYhogy60y8z3dLyhLZa8enM3RAdlq3+3+j/Mdji/834y1OgN4OKLvnqSiBNFdrg4ogLpuV5Z8UvjfXUjqG6tJEmIo0ard7S6wW5dBMd5xOWH+zaEWnEXTU5LDpm9Em2zowsDceMAKtJBUB5taNeYvD/QmgdKumeziUDeNSeEAFBbLefS4npWRkirBma74I1+fnUmjuUTLU1YrHUieyQWiw4eewfbYs0dliFXfjl4ILq6o9BftkgRZ66zKQXKnd8PO9rMyL8k/o1jC9wGy4nwDzG201fg06HmIIAVj01V+nwIv1YMqTy3/FznrPhoabx8wEvtzHRtdmvb+vPWneYY+LuWpMFOq3JaesXRwAinnfvuFoFt3k5RitNJQKacu8LZPUeWuQ5gkS/IDZkIOuI6zby64eVhcBuwB4wjmDmnrgTwE3gzTX8yMM/9BH/ujnwJsF5nl+qVpRcGkKUtnAOmHOv3vdCCpwJ5bV3XvnIjZvi9eRpx9wcLFw+CJKCwIziWwG/K/puPTVaZqKue4xYFY47aGh38lq1BU2FufG/4j4W8M53YkpFYw8Z+RIHqBSZ69ZSHMW9B4B4Psq4vRxP6czaP3vhkA4U2CwPsFnFRabUB/8FE86/OnHaMTkrmJCve7SzNpgUmYIZtRfSY6On3QopZTdGRSxzHx+SbhnV
 Kcwm1jO7
 okjhc25MHfO+iyNrCCLV966ua/9f0cN/Ng2kJ4HlOMT04xVnXQvuB5vtOFP6Z59UCXDXKfap6L+kBZCtHO/1mQnA4k9acLqJLkmy94cR44gWxR1TaujFP1lQoD/c9UJ5ouml14A02T0ExeFx0bPGGrdPAV6wB3lJ6fLJz2OscAoDEh00tTEtCOIkGgqrrKk+TYqv5+UicwvtMf5pBxDMAx/wUFA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When inode_lru_isolate() finds an unused inode that still has page
cache, it sets I_LRU_ISOLATING, drops i_lock and the list_lru lock,
invalidates the page cache, clears the flag again and returns
LRU_RETRY so that the restarted walk can free the inode.

Another walker of the same list can reach the inode in that window.
It sees a non-zero i_state and takes the inode off the LRU, as it
would an inode that is in use. Page cache deletion requeues the inode
once the mapping is shrinkable, so this is harmless if it happens
before the last deletion. If it happens after, nothing puts the inode
back: it stays in memory, unused, clean and without page cache, out
of reach of the shrinker and of drop_caches, until it is looked up
again or the filesystem is unmounted.

Before commit 2a0629834cd8 ("vfs: Don't evict inode under the inode
lru traversing context") the pin was an i_count reference, and the
final iput() put the inode back on the LRU.

Skip inodes that are being isolated and leave them to the walker that
pinned them, which restarts its walk once it has unpinned them.

The window is reached by any unused inode with page cache on
CONFIG_HIGHMEM kernels, and otherwise by inodes whose page cache is a
single shadow entry at index 0. On an i386 HIGHMEM guest, eight
concurrent "echo 2 > /proc/sys/vm/drop_caches" over 2000 freshly read
one-page ext4 files leave roughly 400 of the inodes off the LRU per
round; on x86_64, with the files' pages first evicted through
memory.reclaim, 3 to 4 per round. With this patch, none in either case.

Fixes: 2a0629834cd8 ("vfs: Don't evict inode under the inode lru traversing context")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Nikolaos Karaolidis <nick@karaolidis.com>
---

Found while working on reclaim of inodes pinned by page cache in
ZONE_MOVABLE.

Tested on master af32da41b032 (v7.3-rc6-232) in QEMU/KVM with a small
stress program: mount an ext4 image, read 2000 one-page files, run 8
concurrent "echo 2 > /proc/sys/vm/drop_caches", drop caches again
single-threaded (2, then 1, then 2), and count the filesystem's inodes
still in memory via how many the umount frees:

  i386 HIGHMEM:      ~390 of 2000 lost per round without the patch
                     (3 runs x 20 rounds), 0 with it
  x86_64, pages evicted through memory.reclaim first (single shadow
  entry left):       ~4 per round without, 0 with
  x86_64 with KASAN, PROVE_LOCKING, DEBUG_VM, DEBUG_LIST:
                     6109 lost in 50 rounds without, 0 with, no splats

The reproducer is a single C file run as init; I can post it if useful.

I went with skipping the inode rather than requeueing it on unpin
(which would be closer to what the final iput() did before
2a0629834cd8) because it avoids the remove/re-add and leaves the inode
where the pinning walker finds it again. Happy to switch if preferred.

Jan, this applies cleanly before or after "fs: Basic infrastructure for
offloading inode reclaim" (v2 3/5); happy to rebase onto that series if
you'd rather take it there.

For stable: 6.18 and older need inode->i_state instead of
inode_state_read(). I have only tested master.

An LLM was used to check the analysis against the code, write the
reproducer and draft the changelog; I have reviewed all of it.

 fs/inode.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/inode.c b/fs/inode.c
index a9d37be390a1..74dfc379b377 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -942,6 +942,12 @@ static enum lru_status inode_lru_isolate(struct list_head *item,
 	if (!spin_trylock(&inode->i_lock))
 		return LRU_SKIP;

+	/* Another walker is dropping its page cache, leave it to that one */
+	if (inode_state_read(inode) & I_LRU_ISOLATING) {
+		spin_unlock(&inode->i_lock);
+		return LRU_SKIP;
+	}
+
 	/*
 	 * Inodes can get referenced, redirtied, or repopulated while
 	 * they're already on the LRU, and this can make them

base-commit: af32da41b0327b9c6a37856ba82b6760d6c8d10e
--
2.55.0

