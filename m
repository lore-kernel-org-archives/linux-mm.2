Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0681ECD98D2
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 01:15:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 83F786B0005; Tue, 16 Jun 2026 21:15:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F08A6B0088; Tue, 16 Jun 2026 21:15:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 705D56B008A; Tue, 16 Jun 2026 21:15:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 38A656B0005
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 21:15:32 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 819F11402DD
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 01:15:31 +0000 (UTC)
X-FDA: 84887636862.23.55083CE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id E7E6C4000C
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 01:15:29 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XtVHyrcM;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781658930;
	b=sEuPCEEUAdHTKmj1kqSZePUHriAIy8XPwzZCPNNSrcEcq+SYkyAqFqvH/qXErClzEvaR9z
	V5F10pfQjcP+hf04RpWdNNBGNILaV371Gz1pu1THMKjnpJD2RukldYfUuAkzI0JVoZAk94
	rxLvR6Ge6yeBzjGJTLJNyzszjrm1DMM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XtVHyrcM;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781658929;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dM1CD/FOWTDMsQkMO4cV3iGVzS5NiXgDEdXuvMc7UEo=;
	b=ZZtUFNX4d5itsOsWroZE7BtfyIIqJeUrcCa1O8vLgpPJkJBPL3j0MITmiSMyoF2dOG3i8Y
	/9gA+RGePLS6YUnaGNL7FhjUSQUu5pDWLV2KiAoQDfO+kM5ZPX4owVkUkKcn8xm1erpBqL
	f9OLmUIroC//ogXCmmhOtReQqmP9dvE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 54EFC600AA;
	Wed, 17 Jun 2026 01:15:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 404FE1F000E9;
	Wed, 17 Jun 2026 01:15:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781658929;
	bh=dM1CD/FOWTDMsQkMO4cV3iGVzS5NiXgDEdXuvMc7UEo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XtVHyrcMIk5txVuolLmpB3cqHQ/dh64rbWqHqU9ALakHzhiZL+AyEpxmcxBg35Dlf
	 H2Pzi1mToJGu+iHz/eQkvko8dIdLzkIVRen1S1oR4kW9vtiY0ELYbM5IQKxZGkaCuG
	 Ign6lvUdpkJhuXmUyaoh3QY7W79MtmWTR8AyqZGauCG+ddX+FHjKv09bLrMijc9nCA
	 XPVgUZm6CPJRoTfX2r+HIq8MjcS8fqgdyKHmKsWbGZOMmxokiAUzpywKaFsNIoo/In
	 +FokXb7bOJNaJk4NnQaF5Al8jAlZwjw6wA1IjfNvyG+0ytsDMsyXtdq+7UR8JFBAlX
	 ZjGxHFzo3QB4g==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: "# 5 . 18 . x" <stable@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH 0/9] mm/damon/sysfs: kobject_del() directories that users can create/remove
Date: Tue, 16 Jun 2026 18:15:18 -0700
Message-ID: <20260617011519.97550-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260616150844.88305-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E7E6C4000C
X-Stat-Signature: 7e4r3hkh9ncyecznfh8ct879d715mrm9
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781658929-633364
X-HE-Meta: U2FsdGVkX1/f/sywI7BOinp/sPOpGQl+e2dsBfaPpQbAvMSuxCHd92EMt6O7RCSYAJqe78tq1qxdRsWBvTPuijGRE/PUkofo9BqEyKmwiYHucxt7Qanj43mYxRXudi6hxlx5NU0X+LXgamiYueLiF4gPM6+x3Ymqf2kfkhV6eJS3NjpTjiz59+NbLqI3XByJtGIYZ9RABvK2Lj5bd3800qfdbyVSjJhJABFlg0krWdkjR2e8nYgbJW+9qfEJUlupWh9yBvKlsELiwHNI+5sb9hoEFxZZ4xs1A3tIUJkPMJpN0+e/Ss/KMekGC4Db/VnoqinlXQbNJFGV76Hj38Ioln5VPPduUn1VaSQ/0W9HfvQZGmB/SUJ9J/wh2NAUxA6rABukiG62jetixSRtJ5Dj39MgQBjO00FJ/bqi0yYjheZX78OQZRJo4wuwR5XrRFXky++SYbPai7zM5bwe2dXMeXlBvZijMp5ak69MceR73Y8JQ1C9rYeMO/Rp8dKm9QIxb4zgZFurEPl1Vw+Nn2aTA8HmxrfTNIx4N8A1gzV7uKqtcZEkGGGyQp5apLEmfb1fKor3uQyFW+x4Ysu6dWvTibjY0sVDdebTMW+8qLOFcZSWYZDPdhKS1B4EqY+aEtVwf+u3ptdzdx1MgOZb1nrahCCJzsibsUtQF2zYWFIBV8W6HCurL+jkWUUbaazpbEfcV7W2oYo57ekWbtU7bjEWWWFFiyJ+tclIRTS4LTqxNQ8kFmk6hOf/zxUTm3lv6o8GY712JcNNTSN1uzVs2l82mhPRlEZcXe7jJNsgn2k+G13dElfrlG/h8wm89dxWQx5ZOTRRDKADgAIw2FVY0MmTTCAtayjhXhr3AWsPrEyvrC2n5STlJ9sl86MCw9IPHgtQiN2PCn3b8tGK8gC6fRTAqdUghPwBVDQ4t+Ny/4Ib6v8sEyulwkaRrX2kI8mkB2d5gx6KvHXQ0TnShnoYqkG
 Q7UKEC9a
 MGFeUfQyOD2hQ0C4ebcVPJUbuM8Nfxgicgwq66z7hWD4RT+TLaClWlsTmPS9O+vW2FcLFKWWrkLVD57leMbMzelrdO9p/d/yUyb36uRqDcvoQvTz3iVqCvQAndO8KT0Wa5xYxEGpngY7RNyOspCUTD4QZLH706pTFWUQ5Yf1+8sx3MzxDU/O9a3GP0T3/P0EHUdIML8KI52JQvX8DhvOAGZh+ZmmUTCpwiikglL1ei6rlO40CTCioC54yeVr+1g/uA7mHy3/UMDTZbX9J1/CNYV/chg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 16 Jun 2026 08:08:34 -0700 SeongJae Park <sj@kernel.org> wrote:

> DAMON sysfs interface allows users to create and remove arbitrary number
> of directories on sysfs, using a few files having 'nr_' prefix.  For
> example, 'nr_kdamonds'.  When the user writes a number 'N' to the files,
> directories having name starting from '0' to 'N - 1' are created in the
> same directory.  The pre-existing number-named directories are removed
> before creating the new directories.
> 
> For the removal of the existing directories, DAMON sysfs interface use
> only kobject_put().  Because DAMON sysfs interface is the only kernel
> component that manages the directories, there is no problem in normal
> situations.  However, if CONFIG_DEBUG_KOBJECT_RELEASE is enabled, the
> removal of dirs are delayed.  Let's suppose a user writes a non-zero
> number to the 'nr_*' files while there are pre-existing number-named
> directories, on the config enabled kernel.  DAMON sysfs interface
> decreases the reference counts of the existing directories and
> immediately creates new directories.  Because the removal of the sysfs
> directories is delayed, it shows some pre-existing directories of the
> same names when it tries to create the new directories, and fails.
> 
> For example, the issue can be triggered like below:
> 
>     # grep DEBUG_KOBJECT_RELEASE /boot/config-$(uname -r)
>     CONFIG_DEBUG_KOBJECT_RELEASE=y
>     # ls
>     nr_kdamonds
>     # echo 1 > nr_kdamonds
>     # echo 1 > nr_kdamonds
>     bash: echo: write error: File exists
>     # dmesg
>     [...]
>     [  300.880458] kobject: kobject_add_internal failed for 0 with -EEXIST, don't try to register things with the same name in the same directory.
>     [...]
> 
> This doesn't cause catastrophic issues like kernel panics or memory
> corruptions.  Users can work around by removing all directories first
> (write 0 to the nr_* files) and then create new directories after
> confirming the old directories are gone.  But, this is definitely a bug
> that causes a bad user experience.
> 
> Fix the issues by calling kobject_del() before creating new directories.

Sashiko found existence of similar issues in error handling paths.  I will fix
those in the next revision.

Sashiko also found more issues of different classes that can cause memory leaks
and uninitialized memory dereference.  The errors are unlikely (too small to
fail?) but better to fix asap, and apparently deserves different patches.  I
will prioritize fix of those.


Thanks,
SJ

[...]

