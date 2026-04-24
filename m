Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B65AFDEE5E
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 02:34:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BBCF46B0005; Thu, 23 Apr 2026 22:34:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B6E4C6B008A; Thu, 23 Apr 2026 22:34:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A86046B008C; Thu, 23 Apr 2026 22:34:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8C9E56B0005
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 22:34:08 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3F751140614
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 02:34:08 +0000 (UTC)
X-FDA: 84691879776.23.326D7E5
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	by imf11.hostedemail.com (Postfix) with ESMTP id 85A3A4000D
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 02:34:05 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=GKdfG653;
	spf=pass (imf11.hostedemail.com: domain of arjan@linux.intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=arjan@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776998045; a=rsa-sha256;
	cv=none;
	b=eaCobRKlWtbA6IhpTBcv6T7ORjMvHsUUu+DHfV7vwGa4LnmubEBbp1F2s3pddo9pEL3eQ4
	1y3A0D0xqHIvb1Gi68Y+QuLPjYz3T0t+upNDUvv12XfPBnQMLAoQNhQMPW9mfz+fJlr5eh
	26HmoCEmhHzvy1RGw1EpoPiHMzrwpGM=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=GKdfG653;
	spf=pass (imf11.hostedemail.com: domain of arjan@linux.intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=arjan@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776998045;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1gZ4WlZOXpH12TKaCvBUkbFeP1/+AZ4e/89y4g+vNzI=;
	b=MsSQTdRMJDul80Fe+wu8P26otvdd3BicsNxgwvcfMR6S/KAF7pmadbObWO1gu+h2bHgN6L
	ei7Bk42hmMpKKaXFaWyqmsc6oCCnKSayy328pxNRB/eqw2g13pH2JyDN8fwCuYqQPXqt+R
	qIxtvrsZzpfDsQqOjRjY5XStbWGBRZ4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1776998046; x=1808534046;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4HoO+TiilUqYRofvchVhUVPT6xynrltiaL0pHQnn1jM=;
  b=GKdfG653plZ8XF0DmgPnsmBfJn6pHuOUYWeseuIeq5RKiMPK+O1h0LkM
   Fg3fhsrTwIwaYhdrxEGByup7tHozSIHDlGT0K7m3vgmlAOa4va4oipIgk
   1O+ZXPHCRuvXSgudsOqZX4A6xDQd6cEYUIZRldTIVROvuPW+SeJRnusmJ
   YKZXFT+vgNS1VJ1jNLJT+kVc0L2EsQLdx8hgSighdF+aeuaHl6k2gAics
   Of2whkGhFqIWJuAdNrq5spcuD+g+raePnUbLUqVoScv0mBSM9ZKliTMNe
   +uaejKgbaJMtOklDR77PJMlBUcYXJuLs4bihScfASkyYBR1FkqCBwVHlV
   A==;
X-CSE-ConnectionGUID: Vr5Ocp4gRZSYf6c0n2qAyQ==
X-CSE-MsgGUID: 2qAUqEVkQ/qjJlfIUtnTsw==
X-IronPort-AV: E=McAfee;i="6800,10657,11765"; a="77679011"
X-IronPort-AV: E=Sophos;i="6.23,195,1770624000"; 
   d="scan'208";a="77679011"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2026 19:34:04 -0700
X-CSE-ConnectionGUID: o2pY462DT224npT3EHrYug==
X-CSE-MsgGUID: 82L8oYUUTb2cM947U5T3Tg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,195,1770624000"; 
   d="scan'208";a="237822173"
Received: from arjan-box.jf.intel.com ([10.88.27.153])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2026 19:34:04 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
To: linux-mm@kvack.org
Cc: syzbot+9722a25de70a85ff48a1@syzkaller.appspotmail.com,
	akpm@linux-foundation.org,
	baolin.wang@linux.alibaba.com,
	hughd@google.com,
	linux-kernel@vger.kernel.org,
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [mm?] BUG: sleeping function called from invalid context in shmem_undo_range
Date: Thu, 23 Apr 2026 19:34:54 -0700
Message-ID: <20260424023524.322251-1-arjan@linux.intel.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <69eab803.a00a0220.17a17.004b.GAE@google.com>
References: <69eab803.a00a0220.17a17.004b.GAE@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 85A3A4000D
X-Stat-Signature: yfc1omn3gwz1w6yodz17yrcsqupgkym9
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1776998045-542714
X-HE-Meta: U2FsdGVkX1+EeLkkMvBFz4/SpBR+8fEmFKZEO7IEUWWJxvgX3UZVbO9pPrLdRQ1tQhq8KxiyynH7CLZEJl/EfzjMwcEw+1JitAPvYkBEcnflpP0hsDHA/SlMB0hwF9tLQe7ha2BiWzcOwpdxJTJCju+bTeipVEl76XBwPwC3RV5VDyKBiEEIzwLYsIQkzIjwLNA+6ASFIj3BHt2H6FDIc44wIXYH/bEFMHVu1vtcYspA9m6/35cSLcPVXK9a2Z3s9hp77E+xFBEj3dd1SgsHvLJgTDWoDM8sBv+lRMqSHJH8iFen5nJthn+OeXyXEvkgKPA9R4A+7I93HjrShftByRluQPkuViuA4ziQbmshlCYSGjlJCJhbyaAIC13ORdQuGpddzVIe+3Dc6kqlXcbythHG46+xQM0oRpDFhQ7XccAiFjHrMZkUA3Zoffo2jJsQF0mOm8ygXGA+lgqCMS0abmzykSQ9PXepOiGo3ZmSfxlbMDKsmj/nvEiXRo2ZRDHf4V9EQiN3Rq+1PuEpuLLZz2J6i/SsMA1CMcHlDsZs7EsCoOtPLYYvDf6N5xat7jlRuclTeawOuCfpHulZ9nonyhP3XmkMpPX8mGtjdtAs455/VyOB6lTWMQvgvmKgGSyhxqw/rEnuSxSA9M0nKJ8rGd1WAeTCSK4anYZyMFmzN7hnmacuDbllxYfoU+cok3jlCoSMVBWz7Rr3NYTAnXds+ZQdanAhA4yO5erNbD4a48SFLUE7s5/OkFJzAKg5kAQSsQ8orr+2yGd8J9GxO68O3yLc+2OQEQAdLHFVxJ0nHh4p88BXVFKrzeb8zymo2BOKKqQVJrAQB/3JU8b7vGXE2cJABz9XB74K1TstWyp8bws5drH7TSpsOEjQv5Z0njE29PdzWjD+DIsUYCVDqE4rznbdwkR5xo1ew4u2OvfodOT1naeL8DpFYxrfozc7NU7lVnp6exnBx//5HyNwhIS
 plGFfPQV
 uwuVDJUWDdy+tbRAzzmX4kKaEQnGFhecLxS1CIMcgmpZZ8oA26BN7pHRohgZFJXbzrq1tG4+BqvLxEhOX2/EnkaHxPRcS3QlcgqAFxKiDrw4uA46vS8evYU4cbCKgLTsPh+Xi8T921vOQjXP5J+pLE9IfLNvDOJvAZtzhEijXnelOwaoQZtLqRzWYvLP/B2a6MZSrgQlJNHIQA3XF5Z2/nxJhfeQ4ek4LJ2wKqhCO7QueIcjNhnHpb9uFYslZlQiv30+ECiY2fNhm2HjMRTcX3/u8tAtfVa9qOgAceHrda5BrUfV03Ye5mj0CxIR1UhhnkOVEqpl3piCiOboR/yMj4CR801FbY+EuGRM+BUWvBC4BI3tJ6a/7WGLfZncwRTk72VbnHa14vxjYquhtNgw5YIZLMUIBfkrqC0D/CxvcgSnri2DN2+PWiiH4wdzTxUqxbxSf5qF/T7a3BOTNUnCtCxIduImU36guZ7X0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This email is created by automation to help kernel developers
deal with a large volume of AI generated bug reports by decoding
oopses into more actionable information.


Decoded Backtrace

shmem_undo_range (mm/shmem.c:1108-1151) -- crash site
------------------------------------------------------
1108 static void shmem_undo_range(struct inode *inode, loff_t lstart,
1109                               uoff_t lend, bool unfalloc)
1110 {
1111     struct address_space *mapping = inode->i_mapping;
1112     struct shmem_inode_info *info = SHMEM_I(inode);
1113     pgoff_t start = (lstart + PAGE_SIZE - 1) >> PAGE_SHIFT;
1114     pgoff_t end = (lend + 1) >> PAGE_SHIFT;
1115     struct folio_batch fbatch;
1116     pgoff_t indices[FOLIO_BATCH_SIZE];
1117     struct folio *folio;
1118     bool same_folio;
1119     long nr_swaps_freed = 0;
1120     pgoff_t index;
1121     int i;
...
1129     folio_batch_init(&fbatch);
1130     index = start;
1131     while (index < end && find_lock_entries(mapping, &index,
1132             end - 1, &fbatch, indices)) {
1133         for (i = 0; i < folio_batch_count(&fbatch); i++) {
1134             folio = fbatch.folios[i];
1135             if (xa_is_value(folio)) {
...
1143             }
1144             if (!unfalloc || !folio_test_uptodate(folio))
1145                 truncate_inode_folio(mapping, folio);
1146             folio_unlock(folio);
1147         }
1148         folio_batch_remove_exceptionals(&fbatch);
1149         folio_batch_release(&fbatch);
1150         cond_resched();   /* <-- BUG fires here; RCU nest depth=1 */
1151     }

filename_unlinkat (fs/namei.c:5526-5587) -- top-level caller
-------------------------------------------------------------
5526 int filename_unlinkat(int dfd, struct filename *name)
5527 {
...
5545     error = mnt_want_write(path.mnt);  /* lock #0 (sb_writers) */
5546     if (error)
5547         goto exit_path_put;
5548 retry_deleg:
5549     dentry = start_dirop(path.dentry, &last, lookup_flags);
...
5563     inode = dentry->d_inode;
5564     ihold(inode);
5565     error = security_path_unlink(&path, dentry);
5566     if (error)
5567         goto exit_end_dirop;
5568     error = vfs_unlink(mnt_idmap(path.mnt), path.dentry->d_inode,
5569                        dentry, &delegated_inode);
5570 exit_end_dirop:
5571     end_dirop(dentry);
5572     iput(inode);   /* triggers shmem_evict_inode -> shmem_undo_range */
...
5579     mnt_drop_write(path.mnt);
...
5587 }


Tentative Analysis

The crash is triggered by running rm(1) on a tmpfs/shmem file. The call
chain is:

  sys_unlink -> filename_unlinkat -> iput -> iput_final -> evict
    -> shmem_evict_inode -> shmem_truncate_range -> shmem_undo_range
    -> cond_resched()   <-- BUG fires here

At crash time, two locks are held (in acquisition order):

  #0 sb_writers#5  --  acquired at filename_unlinkat+0x1ad
                       (fs/namei.c:5545 -- mnt_want_write)
  #1 rcu_read_lock --  acquired at rcu_lock_acquire.constprop.0
                       (include/linux/rcupdate.h:300)

Lock #1 (rcu_read_lock) was acquired AFTER mnt_want_write (lock #0 is
always recorded first in the lockdep list) and before the iput() call
at line 5572.  That window contains start_dirop(), security_path_unlink()
and vfs_unlink() (which calls fsnotify_unlink() and d_delete_notify() on
the success path).

On a PREEMPT(full) kernel, rcu_read_lock() increments
current->rcu_read_lock_nesting instead of disabling preemption.
cond_resched() -> __cond_resched() -> __might_resched() checks that
counter, finds it is 1 (not 0), and fires the BUG.

The same leaked rcu_read_lock persists all the way back to userspace
("lock held when returning to user space!"), and a timer interrupt
firing during the syscall produces a third warning:
"Voluntary context switch within RCU read-side critical section!"

All three messages are symptoms of a single rcu_read_lock() call that
is never matched by an rcu_read_unlock() somewhere between
mnt_want_write and iput in filename_unlinkat.


Potential Solution

Find the rcu_read_lock() call that is missing its matching
rcu_read_unlock() in the vfs_unlink() / fsnotify_unlink() /
d_delete_notify() code path.  Adding a WARN_ON(rcu_read_lock_held())
to iput() (alongside the existing might_sleep() check) should produce
a backtrace pointing at the exact acquisition site on the next
reproduction.


More information

Oops-Analysis: http://oops.fenrus.org/reports/lkml/69eab803.a00a0220.17a17.004b.GAE_google.com/report.html
Assisted-by: GitHub Copilot:claude-sonnet-4.6 linux-kernel-oops-x86.

