Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4052AFB518D
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 03:40:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 51DDD6B0088; Mon,  6 Apr 2026 23:40:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CEB16B0089; Mon,  6 Apr 2026 23:40:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E4D76B008A; Mon,  6 Apr 2026 23:40:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2C6F46B0088
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 23:40:11 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BD65913B3EA
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 03:40:10 +0000 (UTC)
X-FDA: 84630356580.17.C4472F3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 062544000A
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 03:40:08 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=QrOAana3;
	spf=pass (imf27.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=QrOAana3;
	spf=pass (imf27.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775533209; a=rsa-sha256;
	cv=none;
	b=7gc0+h2Rrz1LAcDx6rA14bZWbEHtJaQMIXYeZ+WtIPXemSpdVt1cw7wpOcQjkvayQ/C1CY
	VAXL2RBd+z5Cu4qKG8NdQI5SnY+yMq/DG18sfqYs7xO4WtZPpIj0vMcwA5XfEWsBI9IIrm
	wxS+5OLVxKpf0MKCyG9oAZ8OGTcDl9c=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775533209;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=zQwR5eH32N6ZlHumvoWHoO13lj0NyPCKeuZ1Gm4o4h0=;
	b=IJA4qKmjkYCLiJBB55qwIR3xaynMaf4WqJkZ9SCO+nZZkffD8zLAkqBGJyFcFaat1z5xem
	DJ5SvP9/OAKlyb4iE1OISKqyeaglg5aM9oLp4QwH+Udpbpby3UEVf4XJc9Uv8CF8LVBBPI
	LWhXO0iAG41LNUx8KQrhz7FXQw2/2SE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CC19643716;
	Tue,  7 Apr 2026 03:40:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B9F7C116C6;
	Tue,  7 Apr 2026 03:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775533207;
	bh=shTerlkN7e+DreHUemklMoHDvYCzvsR93XdO9+oDo9U=;
	h=Date:From:To:Cc:Subject:From;
	b=QrOAana3JSLgWYEfqxH92/RCsysvuQ8v6+2JXXsG0Q2rQlbYuTj6GAqs8ibcaU3J8
	 mnnatmWxkgovPtlUk4unsFYkDUY71Ct0wyd+mz2tNpyGkREADZYcSjLZYxaLCsK7lD
	 CMLyWkLNyEFtrQJPtyNI/DJyBP2J/D8oq2omEnIw=
Date: Mon, 6 Apr 2026 20:40:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 mm-commits@vger.kernel.org
Subject: [GIT PULL] hotfixes against 7.0-rc7
Message-Id: <20260406204005.a7bd01cfb84ce72be88c9c4f@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 062544000A
X-Stat-Signature: iwrr1ps8hjguo4u8adx1jw43h1b5mptr
X-Rspam-User: 
X-HE-Tag: 1775533208-382561
X-HE-Meta: U2FsdGVkX1/pM6wuU/MDUBFltdcJfn/ndF3el2kmacdIyuidiPvV+CdotHHyDX8pLJ4wwKIPe/h0ZrzaCengv4GVCjHUfPKeqZEsH3r7IEXJCMY6VTLmd4Z6w+o870oTv8rsUrbjsgmKTsmlgAJSYfmG9OGbGpJl4mLHUV5f6xw8gGVdB2FJomzjGtKXiZK4pyEUgAIes8hkE1Vs+xvUJINSUhHqb6kWNbl1OYu5IWpSwpcQ0ggVAvVWgRCQK7et9A6mbx2iqBmmnO5lUNCOO5Gwk/YMcKUpePCDsYg9BuVtgy5nBRRDL/vpHgrDiZRLowYzOsr5Pen/uukmW6OhEhyVIR4v8GBiuk4w29o/qm5mZjXmuinLsltHwZpIigOcaJImjxFx4GVJDmJJWdY1xfQhhb9pZHW17T915STB319s90coLUMuXTzL++zSWHZo9xGEJsKTVpiMa5X6b8PbkkFuF96tFkYpNNTlMfyigNyydkSntZFssQocOtmhcYUbiwzeVqZpFPcSdZ8f6QSO6t3YGRpIr+EoorjP3R+9Fwttz/JXfjeZ5PkWVS7FiOKmL4Zz6g80sjUt2yKAgMUQXlkdjCvqH2HCv+fMSO4slGoWRveL1aFda5qsuhIHuUE2gkeNgXQ6TGo7qSTcc6+1mUybucmuNa/ixuZGjAhPQfKf8nceNsSt8p3tASL4lfoz28dyolMz6NMnCdvwmtkmZzKFlttY/RT4WI6hxPMs1utI+KPhilbIQ5OKP3jcXOEy0ih8pHBOrBfHvBOCFiiuBBoT2PcgEPuGqp93Abuobbm7QueyEcspYMNO3lgybmSINvifE5gb/OOHgibNCgISB8yF3Rizd46safrz3IfdAl7o8W0dK/GUmjBS/7k7AAag1kG1uWam509WZZrW7OFf53Da4Gn+rFjKQgHP6pJTeXyd62wSeFIP/AjB8eeq8QZbEeQfq4fNIKPkY5OenfP
 yIYv3RHg
 8X0h8JnaSzfSEMs0FhiFC/j1iSuTxYQpgK8ljb587OfFRlxcMMzbflnQydqZ9fOtRPjMa8pYLXet4s7x2HC8pmO6vUmWasxG9Vjlwz8wEIRmlGFZNm5M+pASHXz73O3Sf4v0RCDQ0YvyPFiAEHIVdkBHbhyQlLaxwmjx/SGZAtm4sL4MMlr0bvoZ99aAlRy4TQn2G849Fb5Kv/QaPw4ahdz83fCHN1xzwTnCun9VpzfXqdUQ848ZAGGu3M59Y6tqpDppw06Y0kk10yS5bvMkfO/JQhw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Linus, please merge this batch of hotfixes, thanks.


The following changes since commit 2697dd8ae721db4f6a53d4f4cbd438212a80f8dc:

  mm/mseal: update VMA end correctly on merge (2026-03-27 20:48:38 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-04-06-15-27

for you to fetch changes up to 7bc5da4842bed3252d26e742213741a4d0ac1b14:

  ocfs2: fix out-of-bounds write in ocfs2_write_end_inline (2026-04-06 11:13:43 -0700)

----------------------------------------------------------------
8 hotfixes.  All are cc:stable and 7 are for MM.

All are singletons - please see the changelogs for details.

----------------------------------------------------------------
Baolin Wang (1):
      mm: filemap: fix nr_pages calculation overflow in filemap_map_pages()

Hao Li (1):
      mm/memory_hotplug: maintain N_NORMAL_MEMORY during hotplug

Joanne Koong (1):
      mm: reinstate unconditional writeback start in balance_dirty_pages()

Joseph Qi (1):
      ocfs2: fix out-of-bounds write in ocfs2_write_end_inline

Leo Timmins (1):
      liveupdate: propagate file deserialization failures

Sechang Lim (1):
      mm/vma: fix memory leak in __mmap_region()

SeongJae Park (2):
      mm/damon/sysfs: dealloc repeat_call_control if damon_call() fails
      mm/damon/stat: deallocate damon_call() failure leaking damon_ctx

 fs/ocfs2/inode.c                | 10 ++++++++++
 kernel/liveupdate/luo_session.c |  9 +++++++--
 mm/damon/stat.c                 |  7 +++++++
 mm/damon/sysfs.c                |  3 ++-
 mm/filemap.c                    | 11 ++++++++---
 mm/memory_hotplug.c             | 20 ++++++++++++++++++++
 mm/page-writeback.c             | 21 +++++++++++++++++++++
 mm/vma.c                        |  7 +++++++
 8 files changed, 82 insertions(+), 6 deletions(-)


