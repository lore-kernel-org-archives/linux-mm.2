Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45EA6CAC5BB
	for <linux-mm@archiver.kernel.org>; Sun, 28 Sep 2025 05:46:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A6098E0003; Sun, 28 Sep 2025 01:46:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 655678E0001; Sun, 28 Sep 2025 01:46:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 56AC08E0003; Sun, 28 Sep 2025 01:46:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3FA558E0001
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 01:46:16 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D8D1A5BC1F
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 05:46:15 +0000 (UTC)
X-FDA: 83937573510.29.CB6895B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 3A3AF4000A
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 05:46:14 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=WDbfj2zt;
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759038374;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=G2VW10Nkm+tMOpRHphUloTZs01Qk9bI/UgJB5+clMeU=;
	b=3UZtJX8pdUCF7hpkQxCjB0aw7BGQe8FgAwokzeP20nk4EBPJ4IsuM6bl94RQDSk5bkxQF6
	LJdx1QF46VfnAFpk0ElQ+J8dyWZBT1kE25x5FEEZu42w9EANmvi6ckf4JUuvGhsVbNvNS8
	boz5V49mXxeUWBN8lcenPiKmjwbadKI=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=WDbfj2zt;
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759038374; a=rsa-sha256;
	cv=none;
	b=0QdyxqObB+xnDgQn23Sb29ozay05opL/TyyXZ+U18l6U3OvPQCzUHRS2Iya85EIQsMipZi
	+FQUlpUOtXW4EnT9DwpCS2ej6FlGlV0GzQ/4ONuWCQ7Ja/dkYcVTQSp1gA9BXLSzZBtscs
	K+rfyLZa9/AKFwjedaNJ9EJyDl0vaPM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 48242620F5;
	Sun, 28 Sep 2025 05:46:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B263AC4CEF0;
	Sun, 28 Sep 2025 05:46:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1759038372;
	bh=Yrgs1IXkVh2mOgB8ie3jgcyYGEi6ekHFtSCD0+MwkqY=;
	h=Date:From:To:Cc:Subject:From;
	b=WDbfj2ztOtV4NlsL9ez32BiVdOiKXt86eXAyZo2D2zRM3aRbIICte+x8e85O2xARf
	 JYP4PB/Vc9Zy4myie62kILbRd+wv6tObTAoVukB31exS8w5krIgiqYnpSo5AMyaKCJ
	 7DMHPUQR4u0fLTcgk9HRsZvY9eoI5xw0bnHNukzg=
Date: Sat, 27 Sep 2025 22:46:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [GIT PULL] hotfixes for 6.17
Message-Id: <20250927224612.fffdf688aa7be4206a4a3ff1@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 3A3AF4000A
X-Rspamd-Server: rspam05
X-Stat-Signature: 7q9dtfcrsf9ujzwpqpgqy8ppc9zik9ft
X-Rspam-User: 
X-HE-Tag: 1759038374-864825
X-HE-Meta: U2FsdGVkX18tKNxkL77PQW5Z0s3X5nvWmUMnNsCHxqq7zvbwa0VVp2s3DOHS/GOJwnFk1EI1DIgW/piEMIRtkm63dK05EmZns1hVYMtNJU2cpoLijB670bxDIkZlLLT+q9/XS+6K49MGqE6MKcpjbz6hYLw5VGai2o2guIREAUMG8bnWm/nj8jouWqKDLZRBBJ1ihJ3SKzniK77lZrG0oLLWmNGJZjDzrL+CcacPlZ9Bc/jXn0opYCOBMWjG8VkPQ/tueOrb6rFHfqsbv9G8TAHrEebsHUT676GjUGFLhDPEAc9j6XobqIicv2vlC3ezeioN816PHR39h/3cBvq5xpDl9v+ScWdPAr/9LalL4RXyg6+NqDuHcKYkZjpLyqtZc9/kwDK5lrvTPbAD5M5aPiPOtnz1kbQdV/L70M2HCd8kCNDDl8TDn76KupBjF5NBXAcHd2tYzkvlWYNZb/yg83NBQq3JU1E6KZVaBa8XdfQYw2XKTxJaDKJhWZVbGGxf1oIDPrwbZYWqHo5PwTtqTQwEUTCfCS6wQx5RTeatub3iH+q5r2jN/RKyQK+MzrOr2VnIGJpGq/HLz4G6s1YQhpnm5a5gr64w6/fVxLs+WthYLnahApIS3sba08Eu6x+62NVfZ8OrTYDAgWbkx6f0W6ojEVXbwlYAFcjmPU180P6t24MwcR+WwXplL3GDj0aZFsL09SjK1wecLRNhaphqJ5FumZVzVaiRyXGnfFSZyizOpxYHl8Ph7BDm9vieD5EuNz6D1AkPRwqUtqoyXuiwBocsVO/ObFTL97PCJJ1I45FHRGITTVnTbbaT2wQ0M7VbQYI7n1LxaAU4HmdehHUZrpZxAKoegG1iCjnKFLugQ5sfP9HZZj2CcExduRh0rMChqrzaBAYdnsGEiKP1hKYab+8yAelr8WbBkb11m9R3sykJpXiji35+8tWrB1S+HeoQdU1jTHdZ7JfXINGI6Vo
 fNCgnJlP
 ZxQ9idJOjtLov+8M7M1RXOo8YHNN8RHgCpBtYiRtHfoqmxayIHWxcvuMYupsi8YXz8LZHI1HDFnTyaV1Ua5uZFuKuIGxYFsxTfkKm4EWzR19npEpHFULfrZPRbaEBHyEytGBp1A2Hjrog9HhevSMt9MwSlF80dFNWMnPDDl3zzRrnNXeo21mEx9jvQF2zhNUXIt158x1lu3gL9nKZArju0k9ddEzxFn2IUqL232aIjxaQMsyWBRwgrgim/0g14e70+w8MuKDyCylrurE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Linus, please merge this batch of hotfixes.

It's rather late in proceedings, sorry.  The world wouldn't end if you
held this off for 6.18-rc1.

Thanks.


The following changes since commit ce4be9e4307c5a60701ff6e0cafa74caffdc54ce:

  zram: fix slot write race condition (2025-09-15 20:01:45 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-st=
able-2025-09-27-22-35

for you to fetch changes up to 7e89979f6695fb56e8739b7d19614256e637131d:

  include/linux/pgtable.h: convert arch_enter_lazy_mmu_mode() and friends t=
o static inlines (2025-09-25 16:10:35 -0700)

----------------------------------------------------------------
7 hotfixes.  4 are cc:stable and the remainder address post-6.16 issues or
aren't considered necessary for -stable kernels.  6 of these fixes are for
MM.

All singletons, please see the changelogs for details.

----------------------------------------------------------------
Akinobu Mita (1):
      mm/damon/sysfs: do not ignore callback's return value in damon_sysfs_=
damon_call()

Andrew Morton (1):
      include/linux/pgtable.h: convert arch_enter_lazy_mmu_mode() and frien=
ds to static inlines

Bence Cs=F3k=E1s (1):
      mailmap: add entry for Bence Cs=F3k=E1s

Eric Biggers (1):
      kmsan: fix out-of-bounds access to shadow memory

Jakub Acs (1):
      fs/proc/task_mmu: check p->vec_buf for NULL

Jane Chu (1):
      mm/hugetlb: fix copy_hugetlb_page_range() to use ->pt_share_count

Jinjiang Tu (1):
      mm/hugetlb: fix folio is still mapped when deleted

 .mailmap                 |  1 +
 fs/hugetlbfs/inode.c     | 10 ++++++----
 fs/proc/task_mmu.c       |  3 +++
 include/linux/mm_types.h |  5 +++++
 include/linux/pgtable.h  |  6 +++---
 mm/damon/sysfs.c         |  4 +++-
 mm/hugetlb.c             | 15 +++++----------
 mm/kmsan/core.c          | 10 +++++++---
 mm/kmsan/kmsan_test.c    | 16 ++++++++++++++++
 9 files changed, 49 insertions(+), 21 deletions(-)


