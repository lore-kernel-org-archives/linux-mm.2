Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65FC8CD98E1
	for <linux-mm@archiver.kernel.org>; Tue, 16 Jun 2026 21:04:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 74B416B00CD; Tue, 16 Jun 2026 17:04:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 633056B00CF; Tue, 16 Jun 2026 17:04:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 521E26B00D1; Tue, 16 Jun 2026 17:04:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 21EBF6B00CE
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 17:04:36 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6751D140165
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 15:09:01 +0000 (UTC)
X-FDA: 84886108482.18.58CE117
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id C526C20007
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 15:08:59 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=n4wKfY9K;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781622539;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=K+v9AegM+GbGImm5gCXGTgw97ToQTe1LU6DkxXMfsCY=;
	b=YBF6vUtGLhoymYk8naeYLNr9e29jN8tQ6HQgC61TGblCU/leDIQowzdFKRf0s+bYr0RflB
	4hN2c4MO9KIentN3dQAICBmAagqrhsUBgpeO78++YQxWNgCa4FG/gbFY4/qO+C6t7jbSfK
	me3Hts08RQryTbxm/ZXgNkUML/4jJaU=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=n4wKfY9K;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781622539;
	b=nSUsi0Y408g1pIykV56uriHG0/9C9Ht5R15Xe9TjSHO1oTvTb0W+JI+S/FwqC83oDINipH
	eHHuYJTfDT2Ozqy7WJSXLaUV4kXTk+O2xTGQdlZBup0TFNOS5Z9NNgpVeQ3E9s6tBu7FnU
	pCirll8z8Sc0YzE74j4lPTVo2QhYy3c=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2469160103;
	Tue, 16 Jun 2026 15:08:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EF971F000E9;
	Tue, 16 Jun 2026 15:08:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781622536;
	bh=K+v9AegM+GbGImm5gCXGTgw97ToQTe1LU6DkxXMfsCY=;
	h=From:To:Cc:Subject:Date;
	b=n4wKfY9KRZTt2xCWjFtlFYZeZ/3WQp8uZlBIF5/VGT5VcgoIsVvCAHgY7Q5u4blAi
	 oZifkPAoUqq5KGWIg7KaZjLXVTWRTUjSg8ah/RJ04qDOjuVJgX8QTVigjcLj0Cpkrs
	 FibBamzkRXQ47gDhc/vVRST0N8PScF4lZ4K3kf+oqBqMR38z/8gehFMEytN+brHUNJ
	 6O4NKsTTnCM/L+kG9ah9FFpn0Gpo8ZATZ51bOJ0R4p03H2xGsEDQFfvRmbIsXpBXul
	 gvLD4cxx6mCH4rtO9/nItxciF1/W8tlgzKi1yVGmhSGEaA19pdBiShoyIu5ufO8eKY
	 i66kVczeIYeTA==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"# 5 . 18 . x" <stable@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 0/9] mm/damon/sysfs: kobject_del() directories that users can create/remove
Date: Tue, 16 Jun 2026 08:08:34 -0700
Message-ID: <20260616150844.88305-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: C526C20007
X-Stat-Signature: 15tgtqqwwo6qco9q5suti53d7dszrzuu
X-Rspam-User: 
X-HE-Tag: 1781622539-292962
X-HE-Meta: U2FsdGVkX19D97g7uuMpykCbpQYZ4uC26SRnPaSi+iiUNpf781XHW83SdRQZFtzVMER+wKXhSnFMXXokI7U6IBUS3AHQ8+/J6rir1YcKoI2astVX5+UDtC8ZZsd40NVqjCFtasNBuEgm8MSogP7hRsW5JpmkfHjTdSnddbwIcFJcpJ9O2ic/sFObtxtf5YH2vgNGlMhuv5GISuH4VT9BT+edO6gMZ5SQ7xnAR/+93+CuSFiZjl+2dGwXxeZ5/GrNSxXrgiw7T/EgmsfWruAyYABKM0mamqt3FK4KhC6COioYwVPAaG3ZqFbJ4xXPEfRNRdmi5+dUyR6fcKQyjYBGEagd6N+GtCTowHjuAJILwrvZLvENrcBgzNfEXtyIsZIbWxssj9oPRpgx1JIjz29bA+FHw4q9cZw60x1r6JpfcgRQIqMfWP7Ua/qiule4XDTJsQ1TxkPj5W3apmSLD/59c3wEtjejoLBHV8r8uMV05BQb419L5fItRkShtwf1WpE7r2QyQxHTVE8Xj0wpFC8As8leURVJeJWeybDgeVTVqlGFbWZbWdCarQCypNBNhIy0FrTuacVdLvDPwHOsIx7NGjsLcX4d1akzK57OZKBoMAdxQpM56E22oSlJU7fT48GdczwTfBrxlq9K8eZ1Sitf3H+Smye894QNn3H+lDzU0VQ+pjR0fuB68goUNeswjtH+/xb3Fxhrr4q5D+zZwPpx69y5Mxi3aQYAdit9XABiLnx4xI4HPsd937d60bBpCTLLmcVVKYkQ45FxlDp2eIZRX16Qun0HqSEtcT8PPSG+z4BRqY+fTSt8KcqnGKvNU6dd/5Xv5ESiVUtQOn+Ks9v5sNyjHr2bWxxQMoL5Dp75meCmZ+tgyHHFcXKwqLcKxPErNWdQqy75Wy43cwV9SMQIPtYU8bekAOzeu2Kvhla65OSFWWSiVcta6huhcWjjwhmToEufuDiJuqfp4JAg/b/
 yd3PBIv6
 Qr7vDEVUu40tJsZmVQvrau5d64QsF2aGo+/8vx0wHVLynST2VQrTBSFWk2sKfh8SFa1E94eT1ic3UY02NgPAjq5cp/nU8I+UbHS/DdMco5lFNDay+GlNvXTQnRsTklKDrMYTqflpf6g46ELga7GMJlVit5QlTqBfL5A9igXasF2xTpSzTRxUVMqxZgILlsZ/1RETwsxVJMasW4rX/R1oON1yz8rRx9bPKzPctCuz3O/ewMQ2OJvtvpsa2wTXgsD+Wm6Gd
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

This doesn't cause catastrophic issues like kernel panics or memory
corruptions.  Users can work around by removing all directories first
(write 0 to the nr_* files) and then create new directories after
confirming the old directories are gone.  But, this is definitely a bug
that causes a bad user experience.

Fix the issues by calling kobject_del() before creating new directories.

Patches Sequence
================

There are eleven kobject_del() lacking nr_* files that are introduced by
nine different commits.  Fix each of the commits in the introduced
order.

SeongJae Park (9):
  mm/damon/sysfs: kobject_del() target, context and kdamond dirs
  mm/damon/sysfs: kobject_del() region dirs
  mm/damon/sysfs-schemes: kobject_del() scheme dirs
  mm/damon/sysfs-schemes: kobject_del() scheme region dirs
  mm/damon/sysfs-schemes: kobject_del() scheme filter dirs
  mm/damon/sysfs-schemes: kobject_del() scheme quota goal dirs
  mm/damon/sysfs-schemes: kobject_del() scheme action destination dirs
  mm/damon/sysfs: kobject_del() probe filter dirs
  mm/damon/sysfs: kobject_del() probe dirs

 mm/damon/sysfs-schemes.c | 14 +++++++++++---
 mm/damon/sysfs.c         | 12 ++++++++++--
 2 files changed, 21 insertions(+), 5 deletions(-)


base-commit: 7e1f9f51ca3090f7268c1ae8cc5b0552e9df3a87
-- 
2.47.3

