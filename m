Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A73B8CA5FA1
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 03:06:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2BE9F6B0088; Mon, 28 Sep 2026 23:06:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2211F6B008A; Mon, 28 Sep 2026 23:06:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C38A6B008C; Mon, 28 Sep 2026 23:06:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D6B426B0088
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 23:06:30 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C0E6F14038F
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 03:06:28 +0000 (UTC)
X-FDA: 85265311656.05.38F4F6D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id ECFF340004
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 03:06:26 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=L2rAEdkt;
	dmarc=none;
	spf=pass (imf27.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790651187;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=vho3LeinpQ8o3z/UPtMq0kZEbhfMraCkRYDhONPdHpQ=;
	b=pFynJlXnIuDVY6G7lgHkRvk8iOI8nbnDWd17mJmvxtoEap1llsXt02Gw3JGZ/YUlaqb+3i
	0v8R5GqeCBP7Jpotc+IxPTgJZXVPqATsorYQf3axxzQZ+UNgRR/m6aXRDkEfwXSMotiBaM
	4LWFUTlDa1QDlypOzwxx+XyLqgtOW9U=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=L2rAEdkt;
	dmarc=none;
	spf=pass (imf27.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790651187;
	b=fm8OlJLN6MldGGkjngGdJSnyQGpWiqAx268y9nE0W2XFM03KpwdL++8IM2jqKPCIeua+ap
	LT0Y6Ttk7iPmZph74s/E+iRxBcaZbbbCAXINblV8t50MzLlRSM1VpalSH3SZniRM39yceJ
	Ed4cjVSNSbenROzCpi5TTvv501iRoD0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1A0A64191C;
	Tue, 29 Sep 2026 03:06:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CACDC1F000FF;
	Tue, 29 Sep 2026 03:06:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790651186;
	bh=vho3LeinpQ8o3z/UPtMq0kZEbhfMraCkRYDhONPdHpQ=;
	h=Date:From:To:Cc:Subject;
	b=L2rAEdktaXL0AWvbQEN0EGjFbbmwS+ulZ+3coToiPlGMatEiKAOYsG3/GuS8cu1t5
	 Sc0QTrbpo3T7AMryC4X1EUnSWosCTkZZnyeTEigTWNkxhxEpSZgVdZQomVgV9FJ1fG
	 J9uR7SO4cP6I/RyY+nTNbATn2hKRysN+g2I6wMX0=
Date: Mon, 28 Sep 2026 20:06:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [GIT PULL] MM hotfixes for 7.3-rc5
Message-Id: <20260928200625.8d739583d545932f905e36b7@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: owy3nd18dzosxj4btm9ozmcgtxyfiy15
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: ECFF340004
X-HE-Tag: 1790651186-991885
X-HE-Meta: U2FsdGVkX19fhQaaV7NrJuXXr7XpYAsNrB7WAUigVpuP9w9SjXizWWFzq3GvaZ98KiVr4etEh2bZhYCBbvorTFTFrR5PBYvK4usg8+ScTSJUJdGqI3B0LV4hJJ0fzlu5wG155fTLPq2AiOfR2Nj2/0eknxUPKhDFQhVv0SdJaZLAaSRAvLM23ulcuWej7FTIVNJ22MOkZvFV3lFU44PYhEEyJp5+NArxL7+ipO29Z5oAjyx6cTOa5JVh1cuuMnodIyGSY9zCXgI2StesDfvg7Ymz5QAIDRgA0fGAEQrv+tM8b14CxbMpjk/zmkkZCe6aIr3eI15XJbIrrW/9ZNHzpMZsO816tANbQ/YgJ8NQpWvwflvCNyQs3oZ4hflEfv49PnFsWLbXek9A/kcMgD6EHHJKmedmswXYv7siCURS5su7S5NZjQUag+8UnvhcEGzFBW6YgBpxKV+mOFUs/wr9IqLX6VKjFtirI3eDf1mx5pVXQsT9A4duX2Y3V+yvL79xnsFltvY6zbAgr7mGekKGYEFXsVc4t6ZgnP7qXE9oaDt4I9mSx8gMvnWVzGnaHxhIX+L1F6WpDsGEGuiRg/L7C+xbVQVqaPCYkPcVWA7UieavZ9h/s3H0BaVcJcq+1NYqqCKixw+73/F57IpfhMX3j2fT0C7VRYspWIw8tubX1wc+nDksw6kAC3VobTiiFcHtfDXxrOEvgfPy4ALLb259hq80eKMa6PEXrqiVmFh02MFcwD9RlE8RSAcopvSNjur4BLFLV5qY0LSVCdfSfD6NJe3ZAQqI4ed6ph1bkftrZUX7GwiIB+rv8bqtb14Vl1UqTkOJP+4kobH/9p1XSOq49DTREzwk5W1ToKVBWPI07gDDfuXe9njaeuTQfJRF35Z41C3ANEZ5zKLGo5JTQeWE9imj/bc9AoXuKXcysYhJfJ0e+86xltOZIoLXsp6dOcX/VNF6b9v5SMz6aUS3yrb
 WY1CgSMW
 Rc+ghhIy9SpSLjHJzMDr0jGY+Ko7MjHqBMpQaSb6ICry/IZKOnFIkIr9AiKz49hUFICgtZlotQjKtfvn4jX+zzeNwYx4HTnKKq8fAg4C3ixI0lauR7oYeZPLY7F6f0sgn0LmxM1gH29rIdAl8n8FihNn3sef2Az1yG8PZKOpO+RaM2R/suXiiMfcBAj+Rl5dPqegltszjORsuwASdDfit2rISZ5ZSb8kYt+xCTVcmGSg48C/vjrh2Eg53g5jazJzxB5KNiOWHghtq24ZDPcaZcBcj+w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Linus, please merge this batch of MM[*] hotfixes.

There are 10 patches, 5 of which are cc:stable.

[*] almost.  Another ocfs2 patch snuck through.

Thanks.


The following changes since commit fe2ec83746e501645709761605c2464a44fd2929:

  Merge tag 'hid-for-linus-2026092202' of git://git.kernel.org/pub/scm/linux/kernel/git/hid/hid (2026-09-22 10:30:17 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-09-27-19-12

for you to fetch changes up to 976d5e0ddac885b0219252f004f6c561c344df9d:

  mm/vma: predicate setting mmap_prepare VMA fields on new vma alloc (2026-09-26 13:55:11 -0700)

----------------------------------------------------------------
10 hotfixes.  5 are cc:stable.

- Fix module loading incorrectly returning success after alloc_tag codetag
  setup failed.

- Restore MADV_COLLAPSE semantics for shmem so forced collapse ignores the
  shmem THP/mTHP sysfs settings.

- Make alloc_tag UAPI structure padding explicit.

- Fix DAMON schemes unexpectedly stopping after quotas are disabled through
  the online parameter update interface.

- Fix a false SW_TAGS KASAN invalid-access report when freeing vmapped task
  stacks.

- Split the MEMORY MANAGEMENT - MEMORY POLICY AND MIGRATION MAINTAINERS
  entry into separate MIGRATION and NUMA PLACEMENT entries.

- Move memory tiering maintenance under NUMA PLACEMENT.

- Add Gregory Price as a NUMA PLACEMENT co-maintainer.

- Add Heming Zhao as an ocfs2 reviewer.

- Fix mmap_prepare() state being copied onto a merged VMA rather than only
  onto a newly allocated VMA.

----------------------------------------------------------------
Andrey Ryabinin (1):
      kasan: unpoison task stack below watermark only in generic mode

Arnd Bergmann (1):
      alloc_tag: avoid implicit padding in uapi

Baolin Wang (1):
      mm: shmem: ignore sysfs configs for shmem forced collapse

David Hildenbrand (Arm) (3):
      MAINTAINERS: split up MEMORY MANAGEMENT - MEMORY POLICY AND MIGRATION
      MAINTAINERS: move memory tiering under MEMORY MANAGEMENT - NUMA PLACEMENT
      MAINTAINERS: make Gregory a co-maintainer of MEMORY MANAGEMENT - NUMA PLACEMENT

Hao Ge (1):
      module: fix lost error code from codetag_load_module()

Joseph Qi (1):
      MAINTAINERS: add Heming Zhao as ocfs2 reviewer

Lorenzo Stoakes (ARM) (1):
      mm/vma: predicate setting mmap_prepare VMA fields on new vma alloc

SJ Park (1):
      mm/damon/core: don't skip damos_adjust_quota() while esz is not zero

 MAINTAINERS                    | 69 +++++++++++++++++++++++++-----------------
 include/uapi/linux/alloc_tag.h |  1 +
 kernel/module/main.c           |  8 +++--
 mm/damon/core.c                |  2 +-
 mm/kasan/common.c              | 13 +++++++-
 mm/shmem.c                     |  7 +++--
 mm/vma.c                       |  4 +--
 7 files changed, 68 insertions(+), 36 deletions(-)


