Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55184C61DD3
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 00:48:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 346BD6B0092; Thu,  3 Sep 2026 20:48:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D0FA6B0095; Thu,  3 Sep 2026 20:48:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E6CF6B0096; Thu,  3 Sep 2026 20:48:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EA9616B0092
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 20:48:50 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7B60AC0709
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 00:48:50 +0000 (UTC)
X-FDA: 85174244820.27.9FE5714
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id DEE9580003
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 00:48:48 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=av8liggb;
	spf=pass (imf30.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788482928;
	b=geCnlBiOtfqsYFaeb+1rACF/FI1x7C8ISeY0D0HysMPhVpwzPcNjE7+QiLCfiHwjR08HNc
	aBkhc8NOMmw72DesHC2FI+1nuBbpqYAEnn1GO0uVPrPM794vrNeZJDjMIynkKoXeiWJHJe
	/JAQfJcCe26rOQKxVk+QZSzWQMpZolY=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=av8liggb;
	spf=pass (imf30.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788482928;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=fZiJnm472/wWBjeAyig4dXl/rRisSJv+rJypmqNg45g=;
	b=8eBrOgNarTar27RE6y9dz8W45IPWSR8N3ae/SG9/Thyz6YlZXqqrXcnQBS9OYUiIwfRNiG
	LxuRtdlJUJz8CtWsewuZAxX40KkVnzl0u4V+WxAVSrv1n3oKhe96XxsrYS69zaVnRaZUsM
	dEdvN29wzbUr00ejf18sN9ugrlDo6lE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 40C126057A;
	Fri,  4 Sep 2026 00:48:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C81D11F000E9;
	Fri,  4 Sep 2026 00:48:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788482928;
	bh=fZiJnm472/wWBjeAyig4dXl/rRisSJv+rJypmqNg45g=;
	h=Date:From:To:Cc:Subject;
	b=av8liggbntRqzftSpXrzTrkaUzYy6Vz8VFx+yEzAnncDQhHkX69PGCq6Kcbkx57k6
	 X7ekPLlCqHJWeBUN/c+OG1GBixVgh49MxLwYUEdSQVN93k9msX+Zow607ykTBVr5ej
	 FUnhH8PKf4l05O3+eYaZKva0N6AjnyjomiNb4Izw=
Date: Thu, 3 Sep 2026 17:48:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 mm-commits@vger.kernel.org
Subject: [GIT PULL] hotfixes for 7.3-rc2
Message-Id: <20260903174847.a7f81bd5400d48cc8d0feaf9@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: DEE9580003
X-Stat-Signature: 5m4ix3dmxfhcje6mhq3hbmatpfqx9ue8
X-HE-Tag: 1788482928-224628
X-HE-Meta: U2FsdGVkX18bWP3zko0S5osJzbAVsLlJtMyMrDFmLWjJbnQ5tj77K97Kkpt0ATXu6f7NtOHJSyFx9S5/4lSFgXSe1DEilCow5nAfDrH22HBofKhKdhds9gtqQGdonMRG1muMZKxlGOtR0QK0YG81IOyjDlJ3LHDDrTLRfLtdzzSrRUZWNInKu16rjGxZRJ+T40o+61qObPDSPxHwodMw+5Sr3Di3xNU6yUTttOeEIlo009+7aDeOxKGQ+snLJP3GJT2RK3NPA0FldVK7gW9sRAZl/XDr/EXZzSLMAu+/DRnojvidShr1rY21eKTryCzJptlJRZzkutUQGsswvWoh5HcXAaCaKj/364B9Ra8ur8InDT+yLele4EqAKa0a82f7s2V9xXhAud77AH5PzsZ7YYCW9G/tjBb8BhLOJQ/ftU0p3VyIDskRIzBo1GlYViZV05MxNMRBqlMccxLKrVtZ3BEinUVahEtca/tVyp0jc3dPDyRqjnFE/7lfwglEQdeBF7kBqE1yv5n5hTMjWU6DcHyytbiMj8oVNV2aWHxcklR7bQG7MPv9Os/YNKJbPNaivrafTEKq97KlRnic9N76FXvLiuoQJfVhBVJVVD5V82HnT9/YeH4easFaRnTw8ypcO2hIclbXoUZBM3h+INYMRdf9klHujAEIEEzRtrsF8vSIeEsBdGN6SuQ72bBLi7IFn8UneEDcmuoaR0FEujO72nwMnAuV8hn3xFY3/5LB6znrAY03LPhTlN+oHH+GExZ7tAPYh5La2XaAWVrsQzgZOy4JJ+gW+8ongfccxtoA0kwfbyFXW3GNeII2gfVjIvUsv0sboAfDmS/Ud/MF9pMYA+3U1PwLBfqwQwI7x5Fnci12uQUIKAv72hPOtxQH5tEzCzi2VNm7bHEz7ttsS2QRGpP4Beexwsu0bfxAt6E3M4+KJ+kXgVCQxkzreOsy60n+wOPiKO4SA3OYCBk6w0F
 6XJcs+Lm
 gl2iFqliFWYMqKxK4YuSjpaOfZq2Y+qpNgH/hx8OVgQHKNbXggFPtbOJPceLxw4JXDKfUHVvUm5N6UCGY1Dbhn0gYrMlBdCCHf5l/cgZsyySbV2YwuXkwHPE3J2y7viJwLlcjG7x4wo9r4LdW6yk5+pGIOJ+Ohual60xOJTlgwRgt4h0obAvV39qLU61bxmlyERY8GGQOHq44f4ii62avVMHQ1FZq+b1krXsDRaO5Ts7VuX5BUaSLEjUngG3iJ/b7HxXfO59cV0qyEhT8AR/1Yg6yXQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Linus, please merge this batch of hotfixes.

There are no fixes (yet) for all the stuff we added in the most recent
merge window.  Hopefully a good sign.

Thanks.


The following changes since commit 786262be6048deab760f68c8acc2c85607165894:

  Merge tag 'edac_updates_for_v7.3_rc2' of git://git.kernel.org/pub/scm/linux/kernel/git/ras/ras (2026-08-31 20:10:39 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-09-03-17-45

for you to fetch changes up to 97d34aa65c29cca85e3e9050f4c936389b38a054:

  mm/secretmem: properly account locked pages (2026-09-03 10:56:10 -0700)

----------------------------------------------------------------
18 hotfixes.  13 are cc:stable.  15 are for MM.

All are singletons - please see the changelogs for details.

----------------------------------------------------------------
Baolin Wang (1):
      mm: fix incorrect vm_flags usage when checking allowable orders for tmpfs

Bryan Lim (1):
      userfaultfd: reset err to be 0 when move_pages_ptes succeeded

Eric Dumazet (2):
      mm/mempolicy: fix sleeping allocation in alloc_pages_bulk_weighted_interleave()
      Revert "once: don't use a work queue to reset sleepable static key"

Geert Uytterhoeven (1):
      MAINTAINERS: cover all of RAID

Hui Su (1):
      mm/migrate_device: avoid out-of-bounds writes for compound folios

Kiryl Shutsemau (Meta) (1):
      MAINTAINERS: add Kiryl as a THP reviewer

Lance Yang (1):
      MAINTAINERS: add Lance Yang as a hung task detector co-maintainer

Longlong Xia (1):
      mm/hugetlb: keep max_huge_pages when dissolving surplus folios

Lorenzo Stoakes (ARM) (3):
      MAINTAINERS: remove Lorenzo as THP co-maintainer
      mm/mremap: reset unfaulted VMA page offset for MREMAP_DONTUNMAP
      mm/secretmem: properly account locked pages

Narek Jilavyan (1):
      mm/hugetlb_cgroup: call page_counter_set_max() outside VM_BUG_ON()

Shakeel Butt (1):
      memcg: make the v1 soft limit knob inert

Sourav Panda (1):
      mm/hugetlb_cma: fix null nodemask dereference in hugetlb_cma_alloc_frozen_folio

Thorsten Blum (1):
      MAINTAINERS: mailmap: update entries for Thorsten Blum

Usama Arif (1):
      mm/huge_memory: transfer the pmd dirty bit to the folio on zap

Wupeng Ma (1):
      mm/hugetlb: fix missing migratable flag on same-node hugetlb migration

 .mailmap                                       |   3 +-
 Documentation/admin-guide/cgroup-v1/memory.rst |  49 ++---------
 MAINTAINERS                                    |  10 +--
 include/linux/sched/user.h                     |   3 +-
 lib/once.c                                     |   2 +-
 mm/huge_memory.c                               |   2 +
 mm/hugetlb.c                                   |  20 +++--
 mm/hugetlb_cgroup.c                            |   7 +-
 mm/hugetlb_cma.c                               |  21 ++++-
 mm/khugepaged.c                                |   6 --
 mm/madvise.c                                   |   8 ++
 mm/memcontrol-v1.c                             |  43 +++++----
 mm/mempolicy.c                                 |   2 +-
 mm/migrate_device.c                            |  18 ++++
 mm/mremap.c                                    |  22 +++--
 mm/secretmem.c                                 | 116 +++++++++++++++++++++++--
 mm/userfaultfd.c                               |   4 +-
 tools/testing/selftests/mm/memfd_secret.c      |  30 +------
 18 files changed, 233 insertions(+), 133 deletions(-)


