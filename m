Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CFD3EC43602
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 00:51:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F86D6B009D; Mon,  6 Jul 2026 20:51:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A60F6B009E; Mon,  6 Jul 2026 20:51:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5985A6B009F; Mon,  6 Jul 2026 20:51:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 232D06B009D
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 20:51:25 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 73E3C8CE77
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 00:51:24 +0000 (UTC)
X-FDA: 84960152088.01.8A6F251
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 44EF44000A
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 00:51:22 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=P3vnLQIW;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783385482;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=8uOJumz4s0qki0r71srSZl6Uj8heGPfbTOJSjApvouk=;
	b=5oyehNsTUsocw7ExDIojh+JnmYGEpkbhyAPNbC73wE1bhyoOio+JnUSkM1D3WTMNGNEmW3
	87+dtHJL8JcXUKRqB1MnONbn2jqgP279PyIMy5lExWxmd/wbxS5ov6lK3SI8DhK/uSMV7x
	jkKAOVMMqMdKdnN61h9COgivc0MviL8=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=P3vnLQIW;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783385482;
	b=xjfx7ltz7rWxwlJ1HXkF35RDKgV6dv1uVl9n4y28urj4E+00t/+MQRfDd5ookyCaZp/7un
	Ru6BhP9326m3wzFoWglpSRfYGDPGeu4GEaeraw5uuRq0zKwx0wB3tp9M0yIOUZ0u4PSwaA
	8Oh3w4Sl3gQ05sBJVSp7Ar8fUk10lAo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0FB0640BCF;
	Tue,  7 Jul 2026 00:51:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA9ED1F000E9;
	Tue,  7 Jul 2026 00:51:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783385480;
	bh=8uOJumz4s0qki0r71srSZl6Uj8heGPfbTOJSjApvouk=;
	h=Date:From:To:Cc:Subject;
	b=P3vnLQIWwam8IAG2S03dhCCtK72bBTkslQRQn7osCFj6SM/HzrbIBrYKukNIiFEqG
	 Vw3ksOcc0k6Hg47K+1519inXpofFXBTgEA2HcdxgaTsD+WW+5MNLVrLzXulgat8Dm9
	 SGijZv4IYlC+0fMUTDItRlEx1CDnd6I+RnHmx0AM=
Date: Mon, 6 Jul 2026 17:51:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [GIT PULL] hotfixes for 7.2-rc3
Message-Id: <20260706175120.2411eb28603d28ac0424a573@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 44EF44000A
X-Stat-Signature: 4dagadttk8ckiaxdf8hr5d5qexwy17cb
X-HE-Tag: 1783385482-50821
X-HE-Meta: U2FsdGVkX18I0Z98sJTx/Xm+iBb16WhrGbD8B4CEhQISXVUgyJ3KfKaaFy8G7UDlzCD+TTqCaQs3Q8JNAHIj4aYt0uPxmyBGYW4JHUZS9D3I2IUqdqofeEQiWktMf7uuOXSpmfbRJWq78Wd5YAshg5o5XNRVK2H6MyEZiubgqonbh1lwZuddvz5os74nrRt+H9jsbB0jGTCBUYcxmF43WGlotyMmn4c9fSOrtI1McrD1Tvb7bi9BmltnMqytjLvtuj8G//BEqeuBP1Sg6fQyqIfKibHrbgFNXMAaTWtNJXfwrFD1xpWadc2MFa4bR2BO3/d0Kl0IaX8RCD2RM2qGwqpmkZf+rCx5wvCaJXmw/r7YH6UTQ2+QuKTSTZXftqNSn9wmsFnjtWJzrBtVsqOAJNPbgONNi0rx6Ao3D6LbXTGTiCtufASJo0PcBOc8tMWZERikzLThj7JjvJGmmnTgWxH81f5qC3ayjKkm+N0uLmB9BdrUc/A8PFDBs53SYmcaknABt6dPn3ydKz1RV/ScmSwTvpCxNCtlsdXmSwr+epHSKx9cDGAluthrTKeQu1xsJdQpwSflx2RhUpFBez4l4leG5SP0Yy/4tSOwwCjAsWO10hP0b/Drf6lSNvvgMcLCe7UOl4Rm8blsBP8CtLBCO/OtT/XoKEbA9blpcLIfPGCA2Lp68TlZ+kMriygk42yNMc4oH0klonq955s/mLRU781YR1htNuPE+EYxh4qjdHfPxideJXGlhyo042nJCSp4qDCOhHsZ+fhT0y63pjIU6fImmaykcqFZGoMoYFOBri/bbfVpkIEwth54F7PPilBixx2fPG6v19tV9X7lDqidxUGtRsuqKgqjF+CsSfsQpPHzy0Hhh0Tca8mQW9BbV80R//KpHa4fEbMTB3csy7thfbBWpBqdHvAHb3G4YUvYbT27jpfwAO9Kog5VGIMxB5B/3EXATFR5WbXR6jXYmjK
 Ezy8DYM/
 3PhvTYOfaoYkpyz5rMVqeKKXehKKV2R4M4xIfdDWDcb7H8/QJtlDAr921tYcE3zFDr4ZGuxcmMTAjYUnuYKjiBpLZaw9RvKytFKoDLGQbNbqm7GBrv4akea278XpDxaVBww1lyLVM6ArSAffd/1cXGD1pUeI1SxuMg8Bz2UVpvfUIAFVHKQooN3vN6ihAxpL02cgEaAg3fant7wMdS4wOc0IBkCzP2mFj4rhFP7TbeFmEBvTjD6svDvG4G4zuI9UzVvOLrcFSREQxO+fxNqzsO4igYw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Linus, please merge this batch of MM and non-MM hotfixes, thanks.



The following changes since commit dc59e4fea9d83f03bad6bddf3fa2e52491777482:

  Linux 7.2-rc1 (2026-06-28 12:01:31 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-07-06-17-49

for you to fetch changes up to 039892c35f9d8f5ea00d7c2ed1c25224f28b11d7:

  tools/include: include stdint.h for SIZE_MAX in overflow.h (2026-07-01 19:02:56 -0700)

----------------------------------------------------------------
20 hotfixes.  17 are for MM.  12 are cc:stable and the remaining 8
address post-7.1 issues or aren't considered suitable for backporting.

A two patch series from SJ addresses a couple of quite old DAMON issues.
A two patch series from Yichong Chen fixes tools/virtio build issues.  The
remaining patches are singletons.

----------------------------------------------------------------
Jan Kara (1):
      mm: a second pagecache maintainer

Jinjiang Tu (1):
      fs/proc: fix KPF_KSM reported for all anonymous pages

Ketan (1):
      mm: page_ext: add count limit to page_ext_iter_next to prevent invalid PFN access

Lorenzo Stoakes (1):
      MAINTAINERS: add Lance as an rmap reviewer

Pedro Falcato (1):
      mm: do file ownership checks with the proper mount idmap

Qi Zheng (2):
      mm: shrinker: fix shrinker_info teardown race with expansion
      mm: shrinker: fix NULL pointer dereference in debugfs

Radu Rendec (1):
      mailmap: add entries for Radu Rendec

SJ Park (2):
      mm/damon: add a kernel-doc comment for damon_ctx->probes
      mm/damon: add a kernel-doc comment for damon_ctx->rnd_state

Sarthak Sharma (1):
      selftests/mm: fix ksft_process_madv.sh test category

SeongJae Park (3):
      mm/damon/sysfs-schemes: fix dir put orders in access_pattern_add_dirs()
      mm/damon/sysfs-schemes: put stats for scheme_add_dirs() internal error
      mm/damon/ops-common: handle extreme intervals in damon_hot_score()

Yichong Chen (2):
      tools/virtio: add missing compat definitions for vhost_net_test
      tools/include: include stdint.h for SIZE_MAX in overflow.h

Zenghui Yu (3):
      selftests/mm: pagemap_ioctl: use the correct page size for transact_test()
      selftests/mm: hmm-tests: include linux/mman.h to access MADV_COLLAPSE
      samples/damon/mtier: fail early if address range parameters are invalid

Zi Yan (1):
      mm/compaction: handle free_pages_prepare() properly in compaction_free()

 .mailmap                                        |  4 ++
 MAINTAINERS                                     |  3 +-
 fs/proc/page.c                                  |  2 +-
 include/linux/damon.h                           | 11 +++-
 include/linux/fs.h                              |  5 ++
 include/linux/page_ext.h                        | 19 ++++--
 mm/compaction.c                                 |  7 +--
 mm/damon/ops-common.c                           |  1 +
 mm/damon/sysfs-schemes.c                        | 17 +++---
 mm/filemap.c                                    |  2 +-
 mm/madvise.c                                    |  3 +-
 mm/mincore.c                                    |  3 +-
 mm/shrinker.c                                   | 13 +++-
 mm/shrinker_debug.c                             | 10 ++--
 samples/damon/mtier.c                           |  3 +
 tools/include/linux/overflow.h                  |  1 +
 tools/testing/selftests/mm/hmm-tests.c          |  1 +
 tools/testing/selftests/mm/ksft_process_madv.sh |  2 +-
 tools/testing/selftests/mm/pagemap_ioctl.c      | 12 ++--
 tools/virtio/asm/percpu_types.h                 |  7 +++
 tools/virtio/linux/completion.h                 |  9 +++
 tools/virtio/linux/device.h                     |  1 +
 tools/virtio/linux/dma-mapping.h                |  1 +
 tools/virtio/linux/mod_devicetable.h            | 14 +++++
 tools/virtio/linux/virtio_features.h            | 79 +++++++++++++++++++++++++
 25 files changed, 187 insertions(+), 43 deletions(-)
 create mode 100644 tools/virtio/asm/percpu_types.h
 create mode 100644 tools/virtio/linux/completion.h
 create mode 100644 tools/virtio/linux/mod_devicetable.h
 create mode 100644 tools/virtio/linux/virtio_features.h


