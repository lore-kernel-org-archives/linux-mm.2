Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05813606A32A
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 08:09:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=hTS8LHsT
Received: by kanga.kvack.org (Postfix)
	id A91DC6B00EF; Wed, 18 Nov 2026 03:09:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A1BE36B05B0; Wed, 18 Nov 2026 03:09:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8BF846B05B1; Wed, 18 Nov 2026 03:09:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5CEC26B00EF
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 03:09:52 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A09E81C3EE6
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 08:09:50 +0000 (UTC)
X-FDA: 85447516140.06.54CFE6B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id D04FCA0002
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 08:09:48 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=hTS8LHsT;
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794989389;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=QipqgoqPgTxh51C4kAuqqPqEujawJyN1RMmo3KXcqys=;
	b=ugBDgSFYt5ipPfUNRHcQ164KFcQuXkZtBjWyKswMcIgpet3Z7I61NEmY8AWVs8jriZCB1B
	6UkJmycER0ul1ttlLx7pSxlCN8gsQCuqD0ZqHs0SaxRUcCYGKnnwfD7kMsQOKsuds9AcqA
	8mfWgS8Uf8kVOPLUAq5XUnecoo+IJ9A=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794989389;
	b=EqeSEA/jX3k53P/wEwK5J2KOGUD3v3M5q+5vSmL3A+AOyhu4fZZuyn1DSy648VpkSPswWH
	BGdcMJsentXunJek9PqZ73DoPMZwSJ50DEGKRFWXcQcQCnl9tqO/VBBSldPUZUre0n4KBl
	LlMsH5wP7REEW3t8y67TuSCFnDFncpo=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=hTS8LHsT;
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E834744E34;
	Wed, 18 Nov 2026 08:09:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE5931F000C4;
	Wed, 18 Nov 2026 08:09:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794989387;
	bh=QipqgoqPgTxh51C4kAuqqPqEujawJyN1RMmo3KXcqys=;
	h=Date:From:To:Cc:Subject;
	b=hTS8LHsT5U8Bg/RQ4lC/sEXSUuwOs5pwESF+JPBmwJW6CiRipQ1JHwVCaLvA+26P9
	 iFknGko/Qb+w0+oBrQJSWNGurXHWZzGSs2f96RfcHQpjvNhJvp+kzY3F/iX2ehZsUw
	 afyyP1e5qCk1OWcFXNGJM1OUoMWrqnciQ05kbqxo=
Date: Wed, 18 Nov 2026 00:09:47 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 mm-commits@vger.kernel.org
Subject: [GIT PULL] Non-mm hotfixes for 7.4.rc4
Message-Id: <20261118000947.a86e7241c67d295c40eb8b71@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D04FCA0002
X-Spam-Status: No, score=-20.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: i47mu6ht6twcj3uryk6cw7i89zykdx53
X-Rspam-User: 
X-HE-Tag: 1794989388-15177
X-HE-Meta: U2FsdGVkX1/B7HWu7cPrIjeyw/SMW6ZAuhfI1vUdai+Uph5rdBlSwCAR3+FKvmh3CFOpM619dUJjPqVV5QI3Rg5NaHrGG20HSSCFuDW31kEIvPHgMGR0MR4ohJDFN5hCB9Mdf6EBkVtSrwGaEDUqiC9+kqDrp4LPDDZAOrKz3c9NtumyV/3MRTdSv3Nt5LK9ly+GsCzIJrGsNsltygJMz8RnFH0wsTpuYySkkvvDbxQdYOw2t0xxwuctnCyZ9h9QtEG6K6SUKnCX/hucm9XQckV8PTUm7OanITYXmtZrCdRlwQzFbBZVvpzEOA72Ze6qMzNbNQQUDMbMP4tvHvGlFcu7uds660RCU8PDIDFbcFscp/NHQp8vHkvJ6lDxUybMkslTBJ9K9KT5cQB3PdoSd7J76xfwotZ9gRtrp9ad6eoC1K1Cw7/SGfuNZ/+X2XZla8P2J/ZPqUHZTvDkS5pKMZAwQaY7Rc4G3KFhLqH+aEEpNvWcEUWprlHfcpx+wr6+5EammC92MaJENXOp5kibcepsZnQbO4xsat6tba/PtjzIl0vNDeVqhb8/qAWuEEvT7hHkF31/S/xDchedk/R/bNra2wSZBCduLY2MRCrSPjzNgi59l0YX2zIxojf5Vg5sETEiTscCS2OOiZZ9ZVYR6OBHyyXAJeVLHwYXVPfTbnK0ji9yFhuoY4q82GjbtR0VGQ3XC23T93TNWrHQz8rrmhMnQBwBks+VqFzYVZHbX4lEG/JWxvypRWHmVUxhqNtd1klWlaldpYx262VFafJCkP3yPNwu8uTSFVdLNHUjGWEERsfIDf8G/SH25Ofn8MOt97GzoHRgKno5vMtgTUB8KJ98RG82Xnee6cxjqRzVy8/G5KC7iHUxlZ4XNg3A7+lPgz2SWTVypaBUcWrf3da1tti2LOOrmi3aW6pcBXVVmIhtR9vHIYdktjTKaCcGvuBAEkLvCEssnvCy6NyOR/y
 9IlPIdA6
 Vy2SaiFFdzAXn69kv5d17LJjNlv778Zzz60J58KIKFrcq9IktxTPAX36cH0mQP+D2H2bw19+WoFRXrZYEDmFF6lGa8cldQ2LAZKMm2HKTABJgpXdOdSu+syNZbQdh3bMav2gQdY96Q2onxdI3gr4+9X6v8IAP7+Pb0kaiGYB5Pcd7Fo6V6nP4zlUd7qOhmSviJtkoCKb1MKns8UIjBeXAXCkim5SvdvBOXtwlVfNA6rC7ZYwikaYbUNN/zP9S6g8sM6WoE9g0bAj3l+RalRbrdOIN6g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


Linus, please merge this batch of other-than-MM hotfixes for the
current -rc cycle, thanks,



The following changes since commit fa4ad798f6f681031775266044ba1b0cf3c670bd:

  Merge tag 'for-7.4-rc1-tag' of git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux (2026-11-07 13:52:02 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-nonmm-hotfixes-stable-2026-11-18-00-06

for you to fetch changes up to a001666afbf9d2a6096fea95686549b9b1c9d968:

  MAINTAINERS: DRM DRIVERS AND MISC GPU PATCHES (2026-11-17 21:40:05 -0800)

----------------------------------------------------------------
mm.git review status for linus..mm-nonmm-hotfixes-stable

Everything:

Total patches:       20
Fixes: tags:         5
cc:stable patches:   5
Reviews/patch:       0.65
Reviewed rate:       45%

Summary of patch series in this merge:

- "get_maintainer: stop sending every patch to LKML" (Konstantin
  Ryabitsev):

  Make THE REST a fallback when no usable subsystem list matches and
  update the submission guide. This avoids routine copies to LKML
  while retaining a mailing list for otherwise unmatched patches.

Summary of the 18 singletons in this merge:

On local OCFS2 mounts, a failed shared mmap write fault now delivers
SIGBUS instead of hitting BUG_ON(). Journal shutdown is serialized
with inode cleanup, and checkpoint waiters no longer use a queue
embedded in the journal being freed.

Queued dlmfs lock work now keeps the superblock active through its final
iput(), avoiding a use-after-free during unmount. The OCFS2
locking_state debugfs iterator follows its live cursor instead of list
links copied from a lock resource which may have been freed during a
read-only remount.

Fault-injection boot parameters no longer call code which allocates
memory and schedules work before slab and workqueues are initialized,
fixing a boot failure.

----------------------------------------------------------------
Alex Elder (1):
      mailmap: add an alias for Alex Elder

Andrea Cervesato (1):
      MAINTAINERS: update Andrea Cervesato's email for LTP

Beat M. Liechti (1):
      mailmap: add entry for Beat M. Liechti

Bradley Morgan (1):
      mailmap: update email address for Bradley Morgan

Cen Zhang (3):
      ocfs2: serialize inode journal access with shutdown
      ocfs2/dlmfs: keep the superblock alive during lock work
      ocfs2: advance locking_state through the live cursor

Guodong Xu (1):
      mailmap: update entry for Guodong Xu

Joe Perches (1):
      MAINTAINERS: DRM DRIVERS AND MISC GPU PATCHES

Konstantin Ryabitsev (2):
      get_maintainer: only use THE REST as a fallback
      docs: submitting-patches: make LKML a list of last resort again

Luiz Capitulino (Red Hat) (1):
      mailmap: add entries for Luiz Capitulino

Miaoqing Pan (1):
      mailmap: add entries for Miaoqing Pan

Mika Westerberg (1):
      mailmap: update Mika Westerberg's email address

Naman Jain (1):
      mailmap: update email address for Naman Jain

Ridong Chen (1):
      mailmap: add entries for Ridong Chen

Sai Teja Aluvala (1):
      mailmap: update email address for Sai Teja Aluvala

Sang-Heon Jeon (1):
      fault-inject: fix boot failure with fault injection boot parameters

Wang Yibo (1):
      mailmap: add Wang Yibo's work email address

Zhiyuan Zhang (1):
      ocfs2: fix kernel BUG in ocfs2_page_mkwrite() when write_end fails

 .mailmap                                     | 24 +++++++++++++---
 Documentation/process/submitting-patches.rst |  9 ++++--
 MAINTAINERS                                  |  4 +--
 fs/ocfs2/dlmfs/userdlm.c                     | 12 ++++++--
 fs/ocfs2/dlmglue.c                           | 19 ++++++++++--
 fs/ocfs2/inode.c                             | 17 +++++------
 fs/ocfs2/journal.c                           | 30 +++++++++++++------
 fs/ocfs2/journal.h                           | 17 +++++------
 fs/ocfs2/mmap.c                              | 12 +++++++-
 fs/ocfs2/ocfs2.h                             |  1 +
 fs/ocfs2/super.c                             |  1 +
 lib/fault-inject.c                           |  8 +++++-
 scripts/get_maintainer.pl                    | 43 ++++++++++++++++++++++++++++
 13 files changed, 157 insertions(+), 40 deletions(-)


