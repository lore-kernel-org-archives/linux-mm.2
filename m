Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C743CD4F3E
	for <linux-mm@archiver.kernel.org>; Sun, 16 Nov 2025 18:43:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 460DB8E001F; Sun, 16 Nov 2025 13:43:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4113E8E0002; Sun, 16 Nov 2025 13:43:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3268D8E001F; Sun, 16 Nov 2025 13:43:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1A6178E0002
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 13:43:18 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8B8295C261
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 18:43:17 +0000 (UTC)
X-FDA: 84117342834.11.0E4EE2F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id F34B7160006
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 18:43:15 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=SaYb1Xl9;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763318596; a=rsa-sha256;
	cv=none;
	b=Av7gkFaBZWn2tdbexyq3JKDKwtJ5fdcWzGF4DNoHi8MERYSz68BrqZFgltomE1yoBwZHb+
	FcNimOWhI5ata+fEy+uyS9urMEaq95UmjO0FDEdRD/5vUaW8Z8OmX8DRxyf6l7SbMOUuda
	WHJA/CLMvxpKUG+VeQ3GqdGDFCT1SuA=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=SaYb1Xl9;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763318596;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=U/fdNCSWbO1nrgWtt1Wum/s3UbE8a9K1BuG2erxkY1M=;
	b=Go8JTDq4X4qi5Q4Dz8Nio9Kjaab+shL+jsRaUhBWuha8F5iYNwFhUPmwiATxklFWnNuemX
	SZV74eCtbgAY26hLf76xBlr7FetYOvQbblCdl7Sp3yaB7uXfYYSPybzHvadt+VysHvHq+6
	peXKTHvRUrHyx7bEIaLHBIsP8GTS+So=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6726160008;
	Sun, 16 Nov 2025 18:43:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01BD1C116B1;
	Sun, 16 Nov 2025 18:43:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763318595;
	bh=mlz8XZ5Zk1VrLETXio4E2rnvuua3hukDKbQJ9q2Ss9Y=;
	h=Date:From:To:Cc:Subject:From;
	b=SaYb1Xl9buvWv1y1g+OBuDNjTe5Hd7EZ/z82xsMK6QYsoAmART/6uGP+vx+ypof9d
	 W7/rxllPP0cBmb3b+RjU1Xx07yRVR6YmdyDTIAQL3IMrVoph+WeYzX68FrwTDrKkG3
	 2dRLst8ZLraOkpx8lNrEysEZeGLUdQVOe0JlCNHg=
Date: Sun, 16 Nov 2025 10:43:14 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [GIT PULL] more hotfixes for 6.18-rc6
Message-Id: <20251116104314.af398baa1fafa06daee19ce3@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: F34B7160006
X-Stat-Signature: bagbxu4n7x9pzih97bambjzchp9kpj65
X-HE-Tag: 1763318595-370697
X-HE-Meta: U2FsdGVkX1+GUEgOQoab37v8Be7UcYS6mZTjzP3K9pvU7zx+SHNG+e6gT78+mytzKl/OOOruwACx6JIL0SKjMLDBzq0FI809nj68YASxuCe5lSMgYiu2ZJVLVO6BqsMCSucAnu0/NynWsrVZ+YnNL/KwAJf+K53MdXA0FOl3KF+8ZCMVmbo1par/kdFiSdGnE0g1tpTZKaR6xish0thJOC/StOW4hvESdZ8cEXrY/JYea47+SADxLDUs5wflIFiQ+HhMfKdQLT54qi+qmVeLYonOiSpjrBfcYmAEuFX+EZYu3ODXgEzDR0qJnfWYw7BSka2Kkvj38AyilJJfT4H98Hi3SpfqU95dTJqhNsuEbP8B/l66lQoB6lOzib/Zt/AhDtWZ5fdSaTngm/Nk/y0fetGJ5P7/Q8Fu/d5IN8W2aj0b13NPjfEzmyLAtbyBEbA+4KyinSNzzODHDu92gjX+N7dJ5ldfBkl7xSV8gqpA5/ssZqDzwJXzrhe3S73ayY4jdfjgnBPqmsfUKN44YIgyg1Ax2bHEZ5jGmWJzSIgFbmroBO6GNBXemjejQqhXVPOjC8P1+yAqSLaRAkzs2Boj75KS3EBNIB6FvqtPmapx1bHDDi0lOsYF41JICcFhX05hv93BbQhjgzh+7ESC25NpvvLTr8kVY88yYvyTmyrxYVRvfLFls1Lsg+W7J5t0kIdeQyIosyAxfWiDmYFX/w3f++HWhEMmCE56RYisZ3pcaqxW/bMJ7X6lBD1t04qVtD541Rh8V7V6D98eG7DNKzy8To05ePpaAId09aYX5qda5Iela45Pcoq1ftCjohahZtRKVGpTkGG5tAl5TGIN6hTTeeGHJE0P3k0LzCx0OARdwxW3S0VRGCg/jesWdPwQSgCp0xohMrDrqG3WztpqX65FiAom4mACm8RUVjve2ps8bmWV3t5Uq7ONxgMxBHjo3C0Z5/TS3B1zFma8DowhB7T
 Xv1Ktnzz
 HhzqyUZ1JLHTJmezjkf4FI6KWw5lgv7kggmvEtMmHspHepFgqA9si4JbRQpm6cM8tVR1baUQLRpK/Cub0tmOcbqRRJkTxHWAOUBt8VM80W+HMRPkThUEGAwPQ/2KcbMMk0l8pDPfiXw5YMQSViP1DQhRuqDex0OMHNdzjH5RxPQVZaI/uTlUJqvLi3cS012uvpQmQjT73AiAgw91kOg8oV64qY0/WXnHvcvm/Je0ZN0U3KaItaauas8gNFal1WAdcNdHpur+xXMVzZWg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Linus, please merge this small batch of hotfixes for this -rc cyele,
thanks.


The following changes since commit b05addf6f0596edb1f82ab4059438c7ef2d2686d:

  kho: warn and exit when unpreserved page wasn't preserved (2025-11-09 21:19:47 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2025-11-16-10-40

for you to fetch changes up to 1c2a936edd71e133f2806e68324ec81a4eb07588:

  mm, swap: fix potential UAF issue for VMA readahead (2025-11-15 10:52:02 -0800)

----------------------------------------------------------------
7 hotfixes.  5 are cc:stable, 4 are against mm/.

All are singletons - please see the respective changelogs for details.

----------------------------------------------------------------
Ankit Khushwaha (1):
      selftests/user_events: fix type cast for write_index packed member in perf_test

David Hildenbrand (Red Hat) (2):
      mm: fix MAX_FOLIO_ORDER on powerpc configs with hugetlb
      MAINTAINERS: update David Hildenbrand's email address

Kairui Song (1):
      mm, swap: fix potential UAF issue for VMA readahead

Pasha Tatashin (1):
      lib/test_kho: check if KHO is enabled

Sourabh Jain (1):
      crash: fix crashkernel resource shrink

Zi Yan (1):
      mm/huge_memory: fix folio split check for anon folios in swapcache

 .mailmap                                        |  1 +
 MAINTAINERS                                     | 28 ++++++++++++-------------
 arch/powerpc/Kconfig                            |  1 +
 arch/powerpc/platforms/Kconfig.cputype          |  1 -
 include/linux/mm.h                              | 13 +++++++++---
 kernel/crash_core.c                             |  2 +-
 lib/test_kho.c                                  |  3 +++
 mm/Kconfig                                      |  7 +++++++
 mm/huge_memory.c                                |  6 ++++--
 mm/swap_state.c                                 | 13 ++++++++++++
 tools/testing/selftests/user_events/perf_test.c |  2 +-
 11 files changed, 55 insertions(+), 22 deletions(-)


