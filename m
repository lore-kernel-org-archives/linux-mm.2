Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01BC3CA6007
	for <linux-mm@archiver.kernel.org>; Thu,  8 Oct 2026 04:52:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD6FD6B008A; Thu,  8 Oct 2026 00:52:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A885E6B008C; Thu,  8 Oct 2026 00:52:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99DD26B0092; Thu,  8 Oct 2026 00:52:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 742F86B008A
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 00:52:46 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 765DDC0470
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 04:52:44 +0000 (UTC)
X-FDA: 85298238648.03.06029E9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id CA0031C0003
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 04:52:42 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=fVPs4xde;
	spf=pass (imf20.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791435163;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Lz6NwmBv4G2rCkGI87SBT6ZAwtyKhNjtPQCSipSuiTw=;
	b=N8h/019I5D67bMp/6xn7RvkIU5hjZqzRa6BPfmKgOPIf3jSzaEWP8/9WATZeN4ZJZXRBCH
	FlSFzDMjSfnN7SG8m+AiOI06ieZQyXKXM0n8c70Mxd3HasZipGGXlw8kSThsZmc9xTH0lY
	Qz4QT9ufbvGzflzMBgtVZEJmvl40tpE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791435163;
	b=wWngk1c426j+72tYthrtjvPiH5hs20ER8ZL2FU6ZHBXxD0l4YrlIdkeI3qL5J15QEMrmnU
	fVzr3yhAtMoAhFGL8SFES/+aIgihCQNBGpOBYb6XK8uJVq6WJMySpi9LpB0ZSt9Mf8hhHH
	MservPPrwiGgrru+4CpZuO9lC48wE44=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=fVPs4xde;
	spf=pass (imf20.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EB9D46025A;
	Thu,  8 Oct 2026 04:52:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6493F1F000FF;
	Thu,  8 Oct 2026 04:52:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791435161;
	bh=Lz6NwmBv4G2rCkGI87SBT6ZAwtyKhNjtPQCSipSuiTw=;
	h=Date:From:To:Cc:Subject;
	b=fVPs4xdevullPh5Bb4mHpoS2UTtAnakdFgtts7y4Aa+qXZfI7+cTOGXA0Jjqm00ei
	 Ggo74/zddKHZHaLT+3dd9QkNSDl8PdEiXZLUfZh2NBvT46yvYyQqgR6wUNDDTIPSAG
	 gd4Y8m56fE7hhlxG9FTUWy4XkWzchZ7x1OYmUInI=
Date: Wed, 7 Oct 2026 21:52:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 mm-commits@vger.kernel.org
Subject: [GIT PULL]  MM hotfixes for 7.3-rc7
Message-Id: <20261007215240.377006c9206afa07f769e92f@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: CA0031C0003
X-Stat-Signature: kz8euzqu7xkrispbwi7ubgtd6azjxgqj
X-HE-Tag: 1791435162-794955
X-HE-Meta: U2FsdGVkX1/Vm0Ic/z6tZRQwRGbWsMY3cofwj+Wt6d2Bouqd/WEOaAY/vZRUBqX2ni29z9CkPghM7Uxats9wnscIQFgf9HFi/DALHxQmEyaA5HUcFTYDPmIuCV6z6DIAtr1CFyOVzqM1uQoKL+opl8+X6f0SZ03ojSMRSvkd05phoSRC3/5eT//R3V/ainzLLDTB4Q5LT9u9VPtD1721BaaR78sJI+0k3J2DAZssa7zN6tW8CvodhRoVgZUW/LZeSECkK3TQgEYj18LR8mblwok/duNEnSmMb5ozOhUGyTtYu4tO2Q6VBZSkoFLVYJDq0hQjFRQShsPdX3etG1o6lRRUuvhuo3krvLZDDzcfRHAaTxxZhppQ5bL2vvtjUlFOziMySNHpDh/FZ4jS61Z4M3b4nqoYw3Xqjxr1Wkv+0m8iCrKTzPRTLhMKMu6WSXo6HPU+0+CNIx2SWIT2EEydHXJOWX6Yd/3q0xLMLlISoBjyqRRzFAGKNeMBI/nwo7LuWn2ncwG3RRMViYRySURSY+wE80KFxbg918Nt0n1dTfs3JsalEBkRSEeAI/4jG5icOlch47fBs3FBTq2Ad8b6iLJ2aJWB0FVLIw260B+uQXH/z+EMmIWsq9HRaYW9NgzAxXE72v9qG7fgGEW5U2kmqfjQtOF9ByCY3Yb6TCf296R4AoMBMEW768RW6UwEHR4XrqtilEC5G/tB8VdXeinp7Pz/rAIHa/Z80iHRGeI7tRl6TLYxsN13+xn4on2L4lh2KxjtrICuCECh/0Bf5H9+ki2/2dIZ9B11XD1iGj8VfBrA+3Jvkln7vfTB/77Vfn8V5vp7NksbMgk1C5KHcSosE2iqsvgTV4kQS2XhwHqIrvwcJQgY7yLxgLbtR0ctl6Wxq++I4pbunlQMI6yoL0WYoSS03pu2Xja0hMHslV3JfhFvr3mlBCJM0BpUI80YPdrDYNd0VDJpzwSkKZdDJmL
 k/tsa0Gg
 CAkv68h+GHhPyYYsJiotm6htDXuriwzrDvMqkN5lElB8HUu0xNAvlz/MJZeGpgAAQzHAwj8hJg4EQctYxvSZvqxdxxAbDMzOYloQwj+8XXp0l4+QmypJ0x74VnBRgPm0Zzy5c4KxVp26QuYufy/paUOCWdJcnj4vJJtUk3M05a7jtTnSdgNMRXq6K+kKL7tgUtDSAK5eEsv7H187QuYqcMx4O+dNhiYKrUITjLK6PC0OzXV0K3gRMD4ndyVnT7TQNOs9cuc1SmRMuAJ2i11FPEwV/QMxKxlCaq0u4QPO62vN+imjzQk+1hmOb7a27ktoNrhjOEZlEQHsAFbA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Linus, please merge this batch of hotfixes, thanks.


The following changes since commit ff47652a4b66c067c765a7ad464d930b5a9367cc:

  Merge tag 'cifs-fixes-7.3-rc6' of https://git.manguebit.org/linux (2026-10-02 14:04:11 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-10-07-21-48

for you to fetch changes up to 80ce29104123be4d61b5912dae543c70af0fcb75:

  mailmap: update entry for Andy Yan (2026-10-06 16:44:19 -0700)

----------------------------------------------------------------
7 hotfixes.  4 are cc:stable.

- Update .mailmap entries for Andy Yan and John Garry.

- Fix read-only MAP_SHARED /dev/zero mappings so they retain shared-file
  semantics instead of being treated as anonymous memory, also avoiding a
  CONFIG_DEBUG_VM assertion.

- Fix 32-bit build warnings in the hugetlb-mmap selftest caused by using the
  wrong printf format for size_t values.

- Fix a boot-time crash when early function tracing causes CPA to free kernel
  page tables before the workqueues used for deferred freeing are available.

- Fix two MREMAP_DONTUNMAP locked_vm accounting leaks: one caused by an
  mlock-on-fault VMA self-merging, and one caused by partially remapping a
  locked VMA.

----------------------------------------------------------------
Andy Yan (1):
      mailmap: update entry for Andy Yan

Carlos Llamas (1):
      selftests/mm: cleanup -Wformat issues in hugetlb-mmap

John Garry (1):
      mailmap: update addresses for John Garry

Lorenzo Stoakes (ARM) (3):
      mm/mremap: fix locked_vm leak from MREMAP_DONTUNMAP self-merge
      mm/mremap: fix locked_vm leak by splitting VMA for MREMAP_DONTUNMAP
      drivers/char/mem: mmap readonly MAP_SHARED-/dev/zero correctly

Mikhail Gavrilov (1):
      mm: don't schedule deferred kernel page table freeing while booting

 .mailmap                                  |  4 +-
 drivers/char/mem.c                        |  2 +-
 mm/mremap.c                               | 70 +++++++++++++++++++++++--------
 mm/pgtable-generic.c                      | 20 ++++++++-
 mm/vma.c                                  | 21 ++++++++--
 mm/vma.h                                  |  7 +++-
 tools/testing/selftests/mm/hugetlb-mmap.c |  4 +-
 tools/testing/vma/tests/vma.c             | 10 ++---
 8 files changed, 106 insertions(+), 32 deletions(-)


