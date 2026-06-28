Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17BE1C43458
	for <linux-mm@archiver.kernel.org>; Sun, 28 Jun 2026 22:01:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E287D6B0005; Sun, 28 Jun 2026 18:01:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E009E6B0088; Sun, 28 Jun 2026 18:01:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3DB26B0098; Sun, 28 Jun 2026 18:01:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AC2CF6B0005
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 18:01:27 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 38C4A167D85
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 22:01:27 +0000 (UTC)
X-FDA: 84930693414.02.1C3819B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 9F3634000B
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 22:01:25 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BqVXgFs+;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782684085;
	b=L9fSty7yEbZUi1jfEy3/HK2jaSVc7PjpLy1AOcCA/c/JthQ2pTy6al4hEuHAYjJXStY2Ri
	3MVZATSVyOUYLKRM5WF8+X9P2t/opws5ix78SvNk3uk7MrAYROoQvqvwBmYvF6CggZUPiv
	iOXVpSwaOvowCmgI8lwd7RV5gwLMVlA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782684085;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=XYn5Yimzu7UXGaxMxEWaambtaG8HQaGqZy9wUHs/pmI=;
	b=VeUxALCmCNCWy+8D/MP+X2nwPoC/S2ervGSyqqCTVwc5k1Ni/oqM0IJQiMvs/yNjGKrV36
	MrQUHb4W33oaj0xchtkbYNqSapamK7OEchg3Sp3IuqJiQh481cQsVef4gOrE78GJmBnvUj
	HzueWbCLGOis3DjSzveIKhVhEt0YEC0=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BqVXgFs+;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C129741897;
	Sun, 28 Jun 2026 22:01:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B8431F00A3A;
	Sun, 28 Jun 2026 22:01:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782684084;
	bh=XYn5Yimzu7UXGaxMxEWaambtaG8HQaGqZy9wUHs/pmI=;
	h=From:To:Cc:Subject:Date;
	b=BqVXgFs+stovVNErxwCNorVylwHYo9aSwCMPwMLI4G/EjRKG6/jGufxh/Yud6EZF2
	 7jgdY4Iu0CAwuH9Ih44lCWsJTuwfqOVkDwxjLncmiXyrKDsVer+ZrlHTKogtln7H+M
	 t8eoKxnW5kpkCWTMYtdN1mPrgKZrpdWMGD9wapq1kq+z2F+OWRMqQN4K+AyyTGWBX1
	 aV6qBP13oO5BbEfcgSScPWIO0Q8Oo0Cf5iRPsGlTrOwHFcWOZfKjnAenK+wY/h1L76
	 VGUoR96FlFvOY4Pr4phAIOlOftGm4N3orBhmgn2Jp50xfFXmyNNo6fOhgQ23VyWku3
	 8k+qpIjRtg09w==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	"# 5 . 18 . x" <stable@vger.kernel.org>,
	Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 00/11] mm/damon/sysfs: kobject_del() directories that users can create/remove
Date: Sun, 28 Jun 2026 15:01:09 -0700
Message-ID: <20260628220121.97360-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 4amrgbzfpjftphcrr9dd9ipegm9wo6no
X-Rspam-User: 
X-Rspamd-Queue-Id: 9F3634000B
X-Rspamd-Server: rspam02
X-HE-Tag: 1782684085-142747
X-HE-Meta: U2FsdGVkX1/c+o2cT6vU+PWUf64IQX2vybO3NiIEK29cbIfSvNGxdRNwjc3GGWs2e6jYe4vA0co7/h+9zRxQlvCp9BnH3bhqOpd+bC7kaq9B59K2AriY3SAwV8NXRgSq5qcZixWV2jHaLr6z0ykN59qsb4vT829jNz+XcvIP456ymw/ZL0fMO4FdnbTbuAywhVxMwOdmdCezOgtaeC5Sc6OU8fYrzOk05gbF25HOdXCIEDui4qIqGJweW2k6f6FFcOnO1aKZB200Uu8LjXYYyYDHXaTBP3hhq/g/vX3rYWzekNxeusaZ0q5iN/LeZwZX9o4LiNpJMjqGrz+K7JzaAU3zTGbm3nveyjxeYJ6ryK6+eSy+TnnaBBL+dW1eNp2zZ3Z27LCboCqwgU5X0AYXz6PR3uOv33MbNp7g+E8quIjuPnXL+uoWnqOlrZrQbLQfs1R2YYTVyGuxnODgbHvMImatD7f4kyOxkEz5yVaW8ptA9Xnb+5BvG3KNCUoJ/VYwVeZXapcJyyi09dl77a4wkbusRyluCZArR9FnlLetZV8dCGhZyqFNIMAc8s6Dxkp/oxw0rv3hkqu7jSJ0Bf7BKSbwPG8/AKUT419V+5OZw0+qiR59+mMmG0nHcIx7wD4aIQNIb15nGRhhyj0nnWwMfvT9YJnQivuryuGCU+/63C1GJtyZTK/n+HX+6gwqrk7HdXVwLa2gByVXv1adOBf+T8LPWGGFcZahe0t+1LSCIu8AOfLv2AxLLeLY0/b4sN82IX8P0kNumYeQXHzw6wP7bNWcbR3U0Ikj2LPU4lnT6l4JMJRWYzClaOiYIf9rT+qhnUsTRA5TjvDTcsRWCnPU+Cx21IJixB1l3hjv98EuuIID1ig1jiBt+D54q/vsbzuvP1En2qjO0bX7TLV4OmUnSCRLRlB7jroklmhZ4Ah99oRh/id7NErJzeHzPgMQqRDdYX2Ka3OLRRN9UA10qxs
 t01cJSya
 QDXcb6MBMn8jU/oH/zqYREnsGuDCR5uHfLnOsuhsD9VZg0NqPDYzO22j9r5MzMOPdk3m+o+QaLHCQqssRZ/5Keco72DNHOIilIqa0MnKjBYBWB6Gy/QSB4O2LBtsNTuz35QGGSurb2wJbY5SuPUGqQP0/ZXWB4l62SiIfBg7eSITVu45wJaQDNpaIG/FUWVIDIgJqFJxKYSJJcpy5hHd520jXorueICmqJm9P/Uxafe6HjYSnF6IjD7M9aISPQQ5HkXsdnzvGq639VhWAf5SHmO5JGA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON sysfs interface allows users to create and remove arbitrary number
of directories on sysfs, using a few files having 'nr_' prefix.  For
example, 'nr_kdamonds'.  When the user writes a number 'N' to the files,
directories having name starting from '0' to 'N - 1' are created in the
same directory.  The pre-existing number-named directories are removed
before creating the new directories.

For the removal of the existing directories, DAMON sysfs interface use
only kobject_put().  Because DAMON sysfs interface is the only kernel
component that manages the directories, there is no problem in normal
situations.  However, if CONFIG_DEBUG_KOBJECT_RELEASE is enabled, the
removal of dirs are delayed.  Let's suppose a user writes a non-zero
number to the 'nr_*' files while there are pre-existing number-named
directories, on the config enabled kernel.  DAMON sysfs interface
decreases the reference counts of the existing directories and
immediately creates new directories.  Because the removal of the sysfs
directories is delayed, it shows some pre-existing directories of the
same names when it tries to create the new directories, and fails.

For example, the issue can be triggered like below:

    # grep DEBUG_KOBJECT_RELEASE /boot/config-$(uname -r)
    CONFIG_DEBUG_KOBJECT_RELEASE=y
    # ls
    nr_kdamonds
    # echo 1 > nr_kdamonds
    # echo 1 > nr_kdamonds
    bash: echo: write error: File exists
    # dmesg
    [...]
    [  300.880458] kobject: kobject_add_internal failed for 0 with -EEXIST, don't try to register things with the same name in the same directory.
    [...]

Some of the error handling paths of the directories also lack the
kobject_del() call.  If the user uses nr_* file right after the errors,
similar issues can happen.

This doesn't cause catastrophic issues like kernel panics or memory
corruptions.  Users can work around by removing all directories first
(write 0 to the nr_* files) and then create new directories after
confirming the old directories are gone.  But, this is definitely a bug
that causes a bad user experience.

Fix the issues by calling kobject_del() before creating new directories.

Patches Sequence
================

There are a number of bugs of this class that are introduced by eleven
different commits.  The fixes are grouped and ordered for the
introducing commits.

Changes from RFC v1.2
- RFC v1.2: https://lore.kernel.org/20260618151517.5366-1-sj@kernel.org
- Drop RFC tag.
- Rebase to latest mm-new.
Changes from RFC v1.1
- RFC v1.1: https://lore.kernel.org/20260617144807.91441-1-sj@kernel.org
- Add error path fix for damon_sysfs_schemes_add_dirs().
- Rebase to latest mm-new.
Changes from RFC v1
- RFC v1: https://lore.kernel.org/20260616150844.88305-1-sj@kernel.org
- Add error path fixes.

SJ Park (11):
  mm/damon/sysfs: kobject_del() target (normal), context and kdamond
    dirs
  mm/damon/sysfs: kobject_del() region and target (error) dirs
  mm/damon/sysfs-schemes: kobject_del() scheme dirs
  mm/damon/sysfs-schemes: kobject_del() scheme region dirs
  mm/damon/sysfs-schemes: kobject_del() scheme filter dirs
  mm/damon/sysfs-schemes: kobject_del() scheme quota goal dirs
  mm/damon/sysfs-schemes: kobject_del() scheme action destination dirs
  mm/damon/sysfs: kobject_del() probe dirs
  mm/damon/sysfs: kobject_del() probe filter dirs
  mm/damon/sysfs: kobject_del() probe dirs in probes_addd_dir error path
  mm/damon/sysfs-schemes: kobject_del() region for populate_region error

 mm/damon/sysfs-schemes.c | 22 +++++++++++++++++-----
 mm/damon/sysfs.c         | 25 ++++++++++++++++++++-----
 2 files changed, 37 insertions(+), 10 deletions(-)


base-commit: d1f5e472273baa030bf7a4b6063aa67053e4287d
-- 
2.47.3

