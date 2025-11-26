Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3488BD11196
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 19:54:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 671E26B00A6; Wed, 26 Nov 2025 14:54:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6226E6B00A7; Wed, 26 Nov 2025 14:54:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5385E6B00A9; Wed, 26 Nov 2025 14:54:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 400A66B00A6
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 14:54:01 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 19D035AF6D
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 19:54:00 +0000 (UTC)
X-FDA: 84153809040.08.689E21B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 6461910000B
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 19:53:58 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=olRQMdm2;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764186838; a=rsa-sha256;
	cv=none;
	b=yaMw+Ak7KkHSYe6krga2TaHMvgp8xLQjRWCRI5bx0FfZ0cAHzoo3wmH8gWSQ0ng0rucOhe
	8HQNfxUUkfu8J5hQmjcRIPdu5g+oU8fTjaWnNXr28bcuwdath379CnndbkeNNsmXFp8WuP
	L4uBnDI4UYyzIxhAr0cXbBjcrSXTfVQ=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=olRQMdm2;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764186838;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=JhMb16M5zlfiQsw9TwsYXk/Eyb2tP+GT7XJg2OWwCfQ=;
	b=yJFBo1f5zG85/VSY5T9c3jZb21oTgOHusg3JjB2gk0iQP0nKN/1JuH1XmDIKK0+F5y6P5K
	YHhfTA/O2JEib/mDYiTwh/E2Ylg+cT8jeFAyJLeL4PCxhd1s64eWpvaaxtjCJzOY+MbIBG
	H+uoQ4mUQ9o0F6JKR9gGFUjI6a1xWrY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3EA2944288;
	Wed, 26 Nov 2025 19:53:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00DD0C4CEF7;
	Wed, 26 Nov 2025 19:53:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764186837;
	bh=3LaAVXMxsOTt80DxyOV5M4+5WlNyCCt3WikFqOq5sas=;
	h=Date:From:To:Cc:Subject:From;
	b=olRQMdm2y345wispcDvyoctvilgGJJidnxRVpmvFqCAdqo7/+rEKlv0GNwTVxT6DM
	 NG/lega+nQmIVeG084gmbkXYkP5Vs5lMOgHWdQsPnxDpBJqLtajuMQmbP8uBd6WDD5
	 B2ysfLI17b2mfMg7Xqz+Jk5qWZJ2wsG6RNoRFn1I=
Date: Wed, 26 Nov 2025 11:53:56 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [GIT PULL] hotfixes against 6.18-rc7
Message-Id: <20251126115356.e5fb496a181886475567ed74@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 6461910000B
X-Stat-Signature: w9iug1gcfs3p9d3byghrgdeug8ms1t1k
X-Rspam-User: 
X-HE-Tag: 1764186838-111987
X-HE-Meta: U2FsdGVkX1+aT75Y1pF7BdfLkpE4SR6oHtSUebhKTz5hKTupG1VFE7StwKyXIqgHqkmlcb/dpAPj1Be61fK+x6oGeTaeTH7qlWSSDDFtVVryCyj+YuZBRHfv9COUXmuB3x5gNN/xQ0CfrX/bXvbGuINrJ4kCI0fIvv5gUFQuVXx1Ge9lgkD2loq0CrGb6apoZkJkwc+K2N1k9JiZdLCVleWD+PPoCls8ei1UomCpGFivD/PLY/zAe1VTHmdjVrpcD1MV4gBAQ2qAGO6BIuQ6HNxbYZ0McTIevl7BUnRVTbegOA3tPCmwAtOCtUEvkrfaXjFLRc2S2fjJY9n2pPcBu/MjWh49dKb+b3rzREpqRIpqqg7g4ZMIUkLmfU/VwU8dQobS9RcnuxSiqLM1yvLrMH48dfnCZ0pXxZY8w7YnQmgcF+hvUHFMMvBB/P6kAVz2nkLkLoA2Tt4OxNlVObotbHoRrgzrLVR+jFY5AYPTvnWaRNsD5ciH6cqhVPwmIDsOR6LG9/+zby+07MhRf3x/BjawRmoNjmbboWSBMvxQcz5sbU/Iuom8rgUfpHzfBf0KjpW4BBBuaTNWRKCxRpMdCcdKW2lgQT2G9FnFhEfNfuZF/Kd+flQsyQhJnvVx+cbldFipIItQdUK/M3csfGNAUoYGj9Yzr1hEhLvYZye0+XFExvR+6WsrYSgLfkRz85PE3hfF1XRfVb0TxlLus3OlxdpddMH0EAL+hJy2hwitzo87kQ+fgk8SYPjEF521Mxu4vizz1L1yFpp63uSiTdesFOn41dEsSRpbJ5H9jaHBnZs+ZvikMXxRBEnMXNahmCDttMPSL2A72hgm+3xWAJil2HgdxRzwJptaeNRNo/OVjm4BHHG7NTU2Fodq+VG+iqH1OkiFLWIWQ3YGkE4cRue7/YxBZwo19MSmJeRgfn4u3/0LsMKEzLRirq0rYhTmT8eF/6SrtGDN9amnfZM5uNT
 mtEdk7z3
 +N8E2HVlitYC4dZLFCx+SkH2gwoLMQZBcK2zbeO384+aMlUiM9DXjstilsGQK/0wLH6CIfrbs7Q3jTcoZMqgOc+Cz9TMJRXu59xp9XNooInXnt5F46c6Tqw1OvLeke6wkFJxU8pmVjqf2V0UMINjZOj7QgfZL+dWAp8au0fx1cILkWqBH1l4LF0IAxSznshsaI/4QAZu6g/52KFS9mVZXj1jbDqzavABfuV6PCqCwnt/t0jbBabS9uvenTRjP2w4Lg3OByC7GyeDxP7RdVcrQjmPUAw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Linus, please merge this batch of hotfixes, thanks.


The following changes since commit 1c2a936edd71e133f2806e68324ec81a4eb07588:

  mm, swap: fix potential UAF issue for VMA readahead (2025-11-15 10:52:02 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2025-11-26-11-51

for you to fetch changes up to 7c9580f44f90f7a4c11fc7831efe323ebe446091:

  mm/filemap: fix logic around SIGBUS in filemap_map_pages() (2025-11-24 14:25:18 -0800)

----------------------------------------------------------------
8 hotfixes.  4 are cc:stable, 7 are against mm/.

All are singletons - please see the respective changelogs for details.

----------------------------------------------------------------
Carlos Llamas (1):
      selftests/mm: fix division-by-zero in uffd-unit-tests

Deepanshu Kartikey (1):
      mm/memfd: fix information leak in hugetlb folios

Kiryl Shutsemau (1):
      mm/filemap: fix logic around SIGBUS in filemap_map_pages()

Liam R. Howlett (1):
      mm/mmap_lock: reset maple state on lock_vma_under_rcu() retry

Pratyush Yadav (1):
      MAINTAINERS: add test_kho to KHO's entry

Sam Protsenko (1):
      mailmap: add entry for Sam Protsenko

Wei Yang (1):
      mm/huge_memory: fix NULL pointer deference when splitting folio

Youngjun Park (1):
      mm: swap: remove duplicate nr_swap_pages decrement in get_swap_page_of_type()

 .mailmap                                     |  2 ++
 MAINTAINERS                                  |  1 +
 mm/filemap.c                                 | 27 ++++++++++++++-------------
 mm/huge_memory.c                             | 22 ++++++++++------------
 mm/memfd.c                                   | 27 +++++++++++++++++++++++++++
 mm/mmap_lock.c                               |  1 +
 mm/swapfile.c                                |  4 +---
 tools/testing/selftests/mm/uffd-unit-tests.c | 15 +++++++--------
 8 files changed, 63 insertions(+), 36 deletions(-)


