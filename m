Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1BD72C531D0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 21:20:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 09EDB6B007B; Mon, 27 Jul 2026 17:20:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04FC36B0088; Mon, 27 Jul 2026 17:20:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E82196B0093; Mon, 27 Jul 2026 17:20:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BDA006B007B
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 17:20:19 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 40737801FB
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 21:20:19 +0000 (UTC)
X-FDA: 85035824958.20.2BB80DA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 4094AC0006
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 21:20:17 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=kOXwJZDH;
	spf=pass (imf10.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785187217;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Zr0LcY8Wrvcz0NRi9l1OH5CTy6dwjY/bTTOCZ5ZkNi8=;
	b=Kp9QYGQCEU03WAGiRJbNsjUt8WMFWbvkDzN5hA3AsOo85MdsJi5qjPe43Ib3Q/Ku+Hc8Wq
	1D+dymQc9i6x5+8ZwQLbjKoCB5xw+J33uACtZVvYED69mM+o3YA01ChIzeK8SgLOTS9OwG
	I3OFoGRIxt+ub3IEEcxCkErZtDOTUFA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785187217;
	b=Xd9pEW/XHyWxwJeVsCO1GM7UqBYQqyNYEoNS3JMVBi22mpVNviqxY4UC5yPpfAq5PuD0Am
	OuY1M8PSidZxzjdmKkFFtzpGE8xSUXLW0b2ed/rFELYM5uCBJcP4CJpptZE4u1lwAihix2
	RDqqH6RsP5QAbosm3cRCm0eROzjIMSE=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=kOXwJZDH;
	spf=pass (imf10.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 725A7600FC;
	Mon, 27 Jul 2026 21:20:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01D641F000E9;
	Mon, 27 Jul 2026 21:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785187216;
	bh=Zr0LcY8Wrvcz0NRi9l1OH5CTy6dwjY/bTTOCZ5ZkNi8=;
	h=Date:From:To:Cc:Subject;
	b=kOXwJZDHpeKCBXoQqTNDM1r20dL3Ie/xAi1lR3M/niMqTEGyGXszjBcXWek3iAk46
	 HqNBWWl9cMPWYD6f7se7GQqBR/dG9DGqIEdOR9nY6buujtYpv9OWHjLfbtg1jOICkq
	 R4Hvsa1bJHsHLnOs1tNgsQ/0oaxXUO6X0K+vGrjU=
Date: Mon, 27 Jul 2026 14:20:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [GIT PULL] hotfixes for 7.2-rc6
Message-Id: <20260727142015.3795e489e504bf62b793bb55@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4094AC0006
X-Stat-Signature: egt1je61u8z1t8qubdd7cn3x8ui3bq59
X-Rspam-User: 
X-HE-Tag: 1785187217-559375
X-HE-Meta: U2FsdGVkX1/huQtuMw/NObaf1XNPSA9o4huCduZwQr7k9bhB7Iavw7ACa5ieo34vVqkssf2RopwNl5yIst4gpxUvMUD29x+49WdC4eLpaiQWCrQPRaVk1taFhCfzT0RmoolqwtpQNu0GqVNBW3XBgnVmlkIc0JJZ0YmjUKgJL416YbD9AXr6/9eJnVJ356RanlnCFzzThDUoHpbsneTPdPAM67oLOeBnL6+UX+OlVQKsiBW7B1VES2NGktG7PIjNUQhNayxPRf4CJ0zSjc/tOBOWELoF1h/t9WYe9KmUF79UW73d9jJwGZYH1WPfENYgnJf8HCe9dknVnreup8cNmB+WfrppFE30snX4bGdKzgjaj2LXQuho5VSzQGKgdDAlveIE9abmGsxmSmQDU2mFF/nLA0ldspbTSuHgoOdEZovEvTeKWttgMhm8WukEX/kXygmQ3Xwne+c19Ku/QUEMqLhZqUgi6bcmPlnZdvxt76RQoudm3TbH25Q6Xg824Os8wgv05p4RB7SLzrf8ZSmQKNhbOdKnrCUd4XtvVBwLhWmZoMu7R62Rtk2zzRYzNz3KxdBdE14shIp9JDkG/sdI7+2Y6HlHpTcZ3MXou/g6tRoXjBxz8RUOFwK+MS2taolZJzfT/L0yV4BwlYDBWvJWUlqBcqSYjvV5OUNzOjuyi7MFfB7jwHphoF34vuOOKiXOg47VUDcehp9NX49LQHhfjsKWaw1EQSpYrQCBG0VQvXE0PZ41rK3OJIHIONOcAzdiGTY8ymqjkQ6fcAy+W2Cs6sKxF3WzgrLFwpQlwzxTRUc3FVWM1Oc7mzF7cFQQC2lwuHeGckZrXeH9nmflP/VfueFducMFvNAyrQ/qKhDaFODRe4krFJXr0HeOmcZwvVQUCFTwdceHqtMGb6T0YUCym1k7sfTC+O7agY3W6M1TxJaXbPxr/AR3BlB0tt0E5nmV1ehMW7k7rq+elE3W+JC
 XpgXpL5r
 iWkU1i+fGAyHM1ixwUjqfa1FsSxQyYNieJZKhm8k905dLHVT278Agtnhmy/XElUjZUC2O4eNGBUnKzkeTlgj1zuiRbhLYc8wM9CfTWM1LaXAACh7cvorNycn6WE7492Bl0VqF6RnAsFdUKsTllMfpY0lLYnnacZMm7OTQsPUgd+hEkJUDewEqWFpRzFaVWZkI/SOuAM5f6m1RdQ/4j/yjwk8TTfm6xab5C4nQJfUQQTnfhZCek7U1Z513YQZld/t327NFG1sDjk+IHXiQ7X4upeSKtQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Linus, please merge this batch of hotfixes, thanks.


The following changes since commit b95f03f04d475aa6719d15a636ddf32222d55657:

  Merge tag 'mm-hotfixes-stable-2026-07-20-11-37' of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm (2026-07-20 13:04:47 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-07-27-14-18

for you to fetch changes up to 40de8160ca7f67d14619ee0351ce5d68fc4a237a:

  fs/proc/task_mmu: fix PAGEMAP_SCAN written state for PMD holes (2026-07-20 17:41:29 -0700)

----------------------------------------------------------------
13 hotfixes.  All are cc:stable.  11 are for MM.  All are singletons -
please see the changelogs for details.

----------------------------------------------------------------
Aboorva Devarajan (1):
      mm/util: don't read __page_2 for order-1 folios in snapshot_page()

Gregory Price (1):
      mm/vmstat: fold stranded per-cpu node stats when a node comes online

Jori Koolstra (1):
      selftest: fix headers in fclog.c

Joseph Qi (1):
      ocfs2: fix boundary check in ocfs2_check_dir_entry() to use buffer offset

Kefeng Wang (1):
      mm: migrate_device: fix pte_pfn/pte_dirty called on non-present PTE

Kiryl Shutsemau (Meta) (3):
      fs/proc/task_mmu: fix PAGEMAP_SCAN written state for unpopulated ptes
      mm/hugetlb: fix swap entry corruption when clearing uffd-wp at fork()
      fs/proc/task_mmu: fix PAGEMAP_SCAN written state for PMD holes

Qi Zheng (1):
      mm: mglru: fix stale batch updates after memcg reparenting

Stanislav Kinsburskii (1):
      lib: test_hmm: use device devt for coherent device range selection

Usama Arif (1):
      userfaultfd: wait on source PMD during UFFDIO_MOVE

Xiangfeng Cai (1):
      mm/hugetlb: fix list corruption in allocate_file_region_entries()

Zi Yan (1):
      mm/percpu-km: fix bitmap overflow and accounting in pcpu_create_chunk()

 fs/ocfs2/dir.c                              |  5 +--
 fs/proc/task_mmu.c                          | 34 +++++++++++++++---
 include/linux/memcontrol.h                  | 25 +++++++++++++
 lib/test_hmm.c                              |  2 +-
 mm/huge_memory.c                            |  2 +-
 mm/hugetlb.c                                | 12 ++++---
 mm/migrate_device.c                         |  5 +--
 mm/mm_init.c                                | 15 +++++---
 mm/percpu-km.c                              |  2 +-
 mm/util.c                                   |  2 +-
 mm/vmscan.c                                 | 11 +++---
 tools/testing/selftests/filesystems/fclog.c |  4 +--
 tools/testing/selftests/mm/pagemap_ioctl.c  | 56 ++++++++++++++++++++++++++++-
 13 files changed, 144 insertions(+), 31 deletions(-)


