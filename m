Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD5A8CD98E4
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 14:48:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A5956B0088; Wed, 17 Jun 2026 10:48:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77D026B0096; Wed, 17 Jun 2026 10:48:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BA116B0099; Wed, 17 Jun 2026 10:48:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3A28D6B0088
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 10:48:32 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 99731C1FFD
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 14:48:31 +0000 (UTC)
X-FDA: 84889685622.22.D6B9ED5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 1AC2E120005
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 14:48:29 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NqpVlPIv;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781707710;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=pZcyxBjFxNuQb662qkoij88HKiYmenKBKQ/1cazXn+Y=;
	b=avcIB0cgZE5Ou/c6E4q700+Io9LiCqtCCOZgw7X0r74bQHRkH9pj0/xpWSJBrN3BKXlsMR
	wtZxEoDODsrheqp3/raO2xhn5Pj/QoVcHwt1DTvPYzWGkH3F1s3LFHZBGYGvvfe4RzABga
	s6Pq8U+QmKbQVBy/3EKDZqDy2iJMVbk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781707710;
	b=IhY0DSpc0s7qkX7n3eAdojTrSdUAS3it3ExT//9t034g+8b09rXt1P//rclPw5R6UYEAE9
	rh7dwyNcckk1bHDspgzZ5QUpHxhC93mcbhm5U2dOZE6vZO+myv44Ymf5YAH1+jMzHOHIvu
	xD8tPn4ar/3M5dVfvCCPUe6FqseEa1c=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NqpVlPIv;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 76B346001D;
	Wed, 17 Jun 2026 14:48:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 734A61F000E9;
	Wed, 17 Jun 2026 14:48:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781707709;
	bh=pZcyxBjFxNuQb662qkoij88HKiYmenKBKQ/1cazXn+Y=;
	h=From:To:Cc:Subject:Date;
	b=NqpVlPIvwMta3+F97ncN1PpHEZjF9P43W50pKBoPEhbAHDEAfUwC+76bUTsUR1KR9
	 lcZ/m8v+3GcbDmZU5IBsrnuQcoeHvSs7BOcL89vIOb4Qn55zqoHZPGwPnnrvydsnCF
	 k6mtoklgRln8ZEr7RWDsIJtQK8B+1LkwytojMocpRSspThXc/uP6QvDarrBUNAzx89
	 AE9iL+ipAGQMQjt2gHaddTEBye4tO3TT36B4rXE7SwGlfQgk184Uhyqqs9+maRUK9s
	 8F6sOS5AJb6MAcR0twqS8vlIPrE0fqTUeOmTeQ+HlNo8sqrtFw5iJrNtMToZE3k09Y
	 FOav/YO3LTDpg==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"# 5 . 18 . x" <stable@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1 00/11] mm/damon/sysfs: kobject_del() directories that users can create/remove
Date: Wed, 17 Jun 2026 07:47:54 -0700
Message-ID: <20260617144807.91441-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1AC2E120005
X-Stat-Signature: 3m1xa93ogx4ikmpyb6cdd5j4gsd6yqas
X-HE-Tag: 1781707709-768084
X-HE-Meta: U2FsdGVkX19va8sH1vgLZvSDZ/aMeE2ggn37PdKI0S972I2KP0kBipoOU8lQJWiDklUGxybgvO4xTg/g2RkKO2/E2w9ZOySuJP0PGT4FXCB2XwxiMyf/d2U/+3JNWMaTSTGLiQYMqaOuwbaz2Du5eKVBbvwEko9Ws0uYjj5RoxHVBHWTuHFq19TuF/Go9Hj2L08WyLWlIuqfRC3sxTemP5UubDgec1rJhsHfjwcpmERIiE0CQ0k6akLIic4x6OjfryUAonJ7lQK2QJ0uJnE2g4YzsRBUSu3yarOUnziRkDu0v0auX2kVtmHWKWKCaVvl5DeSUbps6DuOexbxN45cwiLqw6FRsY9omYWETWiGKLzs9zpOr7CupJrnkTf+/cNChA9C8lzgNaNKlW3uCKWi1Es01sZd5wFlRg+lpIM4mIS6groLN2L7xYLx6Wlm/JDUMhbSxLzeh/HWcfF8LZHBzDR15NIAHLrGngwqh0EtvJkOReRFpHvSFveHIaou0hHrAyGlojkA9nUaR0w3WKYYxiQDGx9dCe5Jye8WSGZefCTeAp5fjN4D2GReL1LgiBe5DGrohdAH+f8uMK4TyGS5OPrc8Yj4suTIFq4GuCtiUHQgAVFPqDrkUE46pFLDF728CU8uRflAega7p5btxydS95sZO6v9Cb7d5GsIbphBnVRPBretTgyweqSb1KgJuq+SkwKDrxOc/UVbXVgg2uLDEW54Q5gocEcGYL/iWZ4acouZd4FMJAWcvO44S7kq242rQkxn1jsTwSh11+xLvGCSPil3255cwWsIP1jtMfPCXWyFWq9ArPTCGcJUJs+rQufiEq6PuBpNOoQbwmgzGxkS98ny/ohQ408nf2aDF0vAGUOCfiJ+/HlNk57YOWi+nu2DMGBndEFKyvzIVRkkt6xilPCI8Ag7OAt6dBuISOyiuGVFmr6axCe4lpD6G4pIyIfvApEWP4G5E+ygfHGaRxx
 A12SFCg+
 aeXw/AXSy0Plg7PhLNawZPhf5zpEsok+AOLQ0zDas8gzojDCSaXfikYmM1rYCo3m+eeUeWcvkz8bjvZmkP5TpOTcLLHKQrn/7QeqI4093GswyRhqrrQBIUQLiaT+6RRjPmMNO3AkGIBOUmJb82BZJrJQ/gEyxE+hEHiW4j0LbJ1Ad8l6G8/gz8ljoiNno1m145OhkomT6u0snUvKCtDFzSgrZFjzNcd4q3xiTZyRwddQkomG3jh+ESqqr1yoK7abEhAHMHD58JK4IiUDVDpfYCqtZ9A==
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

There are a number of bugs of this class that introduced by eleven
different commits.  Group fnd order fixes based on the introducing
commits.

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

 mm/damon/sysfs-schemes.c | 18 ++++++++++++++----
 mm/damon/sysfs.c         | 25 ++++++++++++++++++++-----
 2 files changed, 34 insertions(+), 9 deletions(-)


base-commit: c7d696ef153b9bea79d35140c7e9266fe9d3f7bb
-- 
2.47.3

