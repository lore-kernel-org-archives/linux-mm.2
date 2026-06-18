Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9213CD98F2
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 15:15:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A2E76B0092; Thu, 18 Jun 2026 11:15:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 654CB6B0096; Thu, 18 Jun 2026 11:15:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 56A126B0099; Thu, 18 Jun 2026 11:15:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 29B646B0092
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 11:15:31 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A228140182
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 15:15:30 +0000 (UTC)
X-FDA: 84893382420.05.B533FF8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 03FFFC0009
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 15:15:28 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I+ABRFxj;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781795729;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=TV4CqNhL96y47BkvUr+Vh2gUi09twBlCDxYoSxWN5Fg=;
	b=M3eThLw/eKW5nMqpGoDmCY2G/v1VMkJeRv9vFlIXF3tlNrZyXquSQ4GYpWg0A+jhWWYmqc
	J1jhTIRp5XCkSWBSfeRYI+c7aH3ZiDADKNLHq0bawxsrEV+KTY0zdi43/7xgrDXLzyEmSW
	gLN4U/KbBAzcxZGdUO8JQrn1JzR1iF8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781795729;
	b=fEr8nziQ96fIwSxpfzPpB/AaX5WA+bvNHNL1wuu8EP/fPgansvxrVr12xfMwsQ/5ZHe1sZ
	StI8HBZSBgABz4hOXNEse15t1imqAe3q6rXuZSTplQBssLiIM6+z66SKNDTcL1xm+xgno7
	V15ox8+D2nienK/Gc6qpbXfVA2oSWoI=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I+ABRFxj;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 14BB3444AD;
	Thu, 18 Jun 2026 15:15:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56C251F000E9;
	Thu, 18 Jun 2026 15:15:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781795728;
	bh=TV4CqNhL96y47BkvUr+Vh2gUi09twBlCDxYoSxWN5Fg=;
	h=From:To:Cc:Subject:Date;
	b=I+ABRFxjLtSSQZOvjMDFRYRmy2ivQODBZl39LW7V/1yKoNLOB3it9SlE4vXHN4oJ/
	 vbia9Gyo7xHYxafNmddewCNvUkLxEpK7EdIE3jRuhwmoqaYLmBgMP1wQ8ieh9bsGiu
	 vUH1rf1hQulzRnCX4cKqyDkwLm5ak7kDWsTnOci5/XCbJPSFvjCIzwJ+CH9mlaLRWl
	 FMuHDMswaSBc6suPqFG7+5q4ghJ5fidoyMPf41IFPCdEEg3fiUR19/G1/xFyWpVVY0
	 TnlUm3dp/YLuGhMcB4WniAlN3frykeJ7KxXa6kR0odhumq3JhZ8JDnFOrvQo707L7U
	 F56wIoGDM76ng==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"# 5 . 18 . x" <stable@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.2 00/11] mm/damon/sysfs: kobject_del() directories that users can create/remove
Date: Thu, 18 Jun 2026 08:15:04 -0700
Message-ID: <20260618151517.5366-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 03FFFC0009
X-Stat-Signature: s34sou31aastzzxtiwtqzsgfg754bohg
X-HE-Tag: 1781795728-72243
X-HE-Meta: U2FsdGVkX1/V5n2x7VJPo/+b9Pf5bIAIVQcRPsaESUPBBG60zm1HNhnrCgIiRn6lcGE9sil4ho+8PK0mB4apJQJm2CLGRGaP+NFJLMu4PoR+7wLZW5uUvsLuvVKfu1MyU/frra48qSilijgTwfUdIEufepa3fSxhFDO8j/23ET9ozQVrOSTNdo9gqUnawYOoC5HnwuA/67uYcRoviiByBFbmT5WHcRwLfQpTuHM0M/6twLlPSkuutIMVqYtmHFiyKxNdB6NolyTVLeku4LONIldKBOKeqY0gRC1vZQPfFQu4ba/y48vqXjhNfDVkvjMhd2yXZhcV1mVI6U3dTAD86cAMSi/budrZ7MUNZkcThGRNKlfXnevzU+urFQWdiRYJeKwoEXsp+2EQXcV7W9sVLoDLPsootB6mq/RjDAnJzZ3KocKjtdnzxrDC3pUfFPbHxeJBYBDD/qbYvexQeJCFG1uaJVSmK44ZCXvf/RhlVoxSPfAxIFE+2gJKlvz3n7qkSEA+arDCkyekGbDv+JLtZO5Ty/zrq9wqZSx7vk1/EVgqwFu87VyOC9dwwad0BfGvw03roXTgxZdM9NFK7B9RU9qMrV12e/yLelm5wTvzezsEWY1E7Gr6YXbM6UvFXaBgOiv0uu/QcyeB2N9P9cLF+jc6+XajXkdY1F1NGPvDb5OnWl8ALjCgYoF3Ek0/RX1vEjH4Ka3uKq2HzlsKUWWNVxG47/lHslFkjvmVxIZNf6gDFN7DaDSuj5K69ees1IP3MYOsFep9JieX/mNtRNFKyasn5R6SaGI78Jy/uBTUulZCp0b/2gTFdWp1q5bAdFK7syvhmtUs8rohLVxle8P/JKdLqQ6AoHpMyHx0V0SeetzJFPy3dOaiemzOhg7Pu6g953hbyvekBh3GZcMmYhvfJhkhvG6kgl3O9inSNVB/6qufpPZ65RIOa8AzcRuJa5SMjIJb5MpNXxK9/NO7/sE
 zBRV/Hhr
 V5fPBsyuh7MjwwFSP5hTVxcH0A33YiaDdNaxlzMU3oLlJ0HRe1ojn8P5bmKDYVYPZlk9YrERJs+H3/kvs5g+y0SbHkssFctOuDR27xLCbCRbI08rsiecTsLNlXQhC7sGePIEtaLov/weGs1ft83y9cEevMMQgm+CIFkpDx20ZcCsp9zMBQYr2Z6H7CPu5/vUfr3LI4jswCbO+PZjvWL5rGvAYr6tyY8gYMTPfIGiTnFgo3kiUn2k1TuareGxli8qZ4EARBlSlVx/HCS2N37rlB5lQOA==
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

Changes from RFC v1.1
- RFC v1.1: https://lore.kernel.org/20260617144807.91441-1-sj@kernel.org
- Add error path fix for damon_sysfs_schemes_add_dirs().
- Rebase to latest mm-new.
Changes from RFC v1
- RFC v1: https://lore.kernel.org/20260616150844.88305-1-sj@kernel.org
- Add error path fixes.

SeongJae Park (11):
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


base-commit: 30941f0c4e32b31d4dcf2956491c5a3ac9c5beb4
-- 
2.47.3

