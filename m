Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6CE1BCA5FA1
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 17:27:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1FA1B6B0092; Mon, 28 Sep 2026 13:27:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15B786B0093; Mon, 28 Sep 2026 13:27:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 021E26B0095; Mon, 28 Sep 2026 13:27:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C45886B0092
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 13:27:41 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 53B50802B8
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 17:27:41 +0000 (UTC)
X-FDA: 85263853122.11.68A8C32
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 6A521C000C
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 17:27:39 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ML2QdkCS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of nsc@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=nsc@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790616459;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=9TV9CZp7F6pGowVYUJzJ4N6Q8t1cPGPvHxtYWak4BOo=;
	b=wtmtN5vtFJh73dc2pnEcPzq9yRysDt6fyg0B0oJdqwnlAGYvFlcuuxtaFy+jdL1SyLZmpV
	3IOzW7zZE3rI7chlzoUyNNJuQ9eUjUT6d9AdeQmO6utz1Nrde8qOLo6bDykBtlXG5wIz/L
	cFQF/NstFifc8F9arqIUToY6ZiKmCUs=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ML2QdkCS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of nsc@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=nsc@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790616459;
	b=3ni8PF8mcHVZErXVxAUfOvtcyFKKTx80z9wqNKpExi9AgHnRdk07VzcxQQ6rXGBnVwGTUG
	F6CLse11sAHEyGsrXC6tqc6YHuyWNA8g2bYhk/wWzoNAUqQ1wao46ZbkcwCQBS6ehIxZjI
	DRSo/dEYNRPEszQ/xiZFj2NcUqmQrBI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with UTF8SMTP id 99D0D43B2F;
	Mon, 28 Sep 2026 17:27:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 0B9CD1F00893;
	Mon, 28 Sep 2026 17:27:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790616458;
	bh=9TV9CZp7F6pGowVYUJzJ4N6Q8t1cPGPvHxtYWak4BOo=;
	h=From:Subject:Date:To:Cc;
	b=ML2QdkCS3OlmsKQFbRneo/Dlnm8gkGcBAJgnibAb7/PJa0WxDM9XNJv8kL5KqiL6t
	 7z/7Tkm1ZnURsXPB3nXojxLLZzPXiQ1mq4IXis0jZYFfttjVG4b+nKFlz8h6Iz2BBv
	 /wXXvB0zyoX9KJy7Uz43TV5kxt/eZUI4i2s3oUJdzEEer5tgUK55Xt6xUCSXtPoyW3
	 9VHz2rq7lyb2ERXoBToE4x/4iVBmX4e+IBvDSJqiTyltIGP//E4SHOsBO4tdd5mZUM
	 G/0WhFcUBKkyeoRCTvMXgORvgbGczTvTiJACqSc4N7zazKWAMld/JZUOA6Y0savHQk
	 uxDgyLuCI25Lw==
From: Nicolas Schier <nsc@kernel.org>
Subject: [PATCH v4 0/2] Move tool for generating initramfs cpio to scripts/
Date: Mon, 28 Sep 2026 19:26:56 +0200
Message-Id: <20260928-move-gen_init_cpio-to-scripts-v4-0-f437a33c40ac@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-B4-Tracking: v=1; b=H4sIAGGjumoC/4XPQW7CMBCF4asgr2tkj3Hc6ar3QAgRMwmjFjuyI
 wuEcnecsEBVF1n+s/ie5iEyJaYsvjYPkahw5hhq7D42wl9OoSfJ59oCFDQKwMprLCR7CkcOPB7
 9wFGOUWafeBizRPpE6hDJ6pOoxpCo49vi7w+1L5zHmO7LXNHz9SUbhSty0VJJ5a2y2Grytv3+o
 RTodxtTL2a6wJtzoNY4qBw0rSNtvdPG/OPMm8PVv4upHKLfoelc4wD+cNM0PQGCR+iCaQEAAA=
 =
X-Change-ID: 20260225-move-gen_init_cpio-to-scripts-9e89ef99e51a
To: Nathan Chancellor <nathan@kernel.org>, Nicolas Schier <nsc@kernel.org>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>, 
 Luis Augenstein <luis.augenstein@tngtech.com>, 
 Maximilian Huber <maximilian.huber@tngtech.com>, 
 Mike Rapoport <rppt@kernel.org>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pratyush Yadav <pratyush@kernel.org>, Alexander Graf <graf@amazon.com>, 
 Willy Tarreau <w@1wt.eu>, 
 =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <linux@weissschuh.net>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Askar Safin <safinaskar@gmail.com>, linux-doc@vger.kernel.org, 
 kexec@lists.infradead.org, linux-mm@kvack.org, 
 linux-kselftest@vger.kernel.org, 
 =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=3530; i=nsc@kernel.org;
 s=20250924; h=from:subject:message-id;
 bh=AHw6WcgdVZgKfWGs8wYDEg+b2spe6e8gjU2uAAY/cLc=;
 b=owEBbQKS/ZANAwAKAQdSCnAWJhJpAcsmYgBquqNngpRwJH7gtezweBGwAnX75e2BjKoR7HKmD
 +sDP+kdN+2JAjMEAAEKAB0WIQSHQTenhzckp4G+wsYHUgpwFiYSaQUCarqjZwAKCRAHUgpwFiYS
 aURsEACSbagu8wpV2hI77TKfpUyKYeiN6C1f9X3Ib3qZeypiAv7bCFlW0vHuECGboSOccAcPG0j
 kO4zYR7Rd2P09QyWjep2b9RMx9ebQZa3Pkw7CkNJRvRYdzaXqfOrZKNVyycf6cswhNzYg/MvFNC
 2mq3S456NmxFP+tBpQDzRRXE8cR3tWgOdMPgzeFpskkcloyPWmme31LFMmQc4uG2QAVIvJCP3ru
 Vjc1+U5ZVyJnci53Ndu3IiOzfNOGu45RzYNsVXZ8WJd81QHVcJP+utNDpOAQAlVbpRBiLXcs9Pv
 LNILfhKuAgtV0Hbq2cEN54Tn225iFOmgJU3u1JhIhGHnFT7dlPfhP3i0tCvRLBjurAjAMic51aB
 O8oInBBP2YTcR3eVNlHacd9ookbdHuYODSEcLrCfT/ZOfsnYKFSkZYuYievOivk7sxG/NBLJzJ3
 XnMnh7m9UN8/dDaur9qQoVyNdfZSlWIPauVTtp29cD51mfY5TNU4KQKYMaaCJrXme2Sl/+J0f4Q
 +Z5Mxr6NJ1JKBrnHlYDtjxNe1VABRnfxKsLH3bhhe/cF5Ucum3QgTr+pXiGTA2OsF11Y+x5T7l5
 N6wI1iHm82VVYP9Px+ogjtFrfdcjwerLMNMLtctbbgc0MSYcSZO57QmfOk1eVPI0TiVUoIl7lea
 uO06Fu8x9SVY80A==
X-Developer-Key: i=nsc@kernel.org; a=openpgp;
 fpr=18ED52DBE34F860EE9FBC82B7D97093255A0CE7F
X-Stat-Signature: 9puhweht87w9h9jymmdo7zknp1y1nnzf
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6A521C000C
X-HE-Tag: 1790616459-678958
X-HE-Meta: U2FsdGVkX19hyLIK0DOyQHXHBl2Q9l1Hm0Nm8uTKZ0Es6TVT7IDqjXs1Fmmqgh5SJOoC3inMNdSpM+hllJXUM8hSH2JAw39NLTc9PqBn7tK/q2q/2atjukTTkhCb9fOpQm7P90XyaBZv0uRqhGIeBnt3WYr9jYyazE2M27zRCRSk6Jp/cvVMPwTDGbLJwSj+wHyHXewVrs1u+Mc126iS8qAE3OBtS9XEqLviXVVlyo3+3Zu7+ygvyIv9PaSZ9hYzmPJlMAjDo4vBtCg66oIcv9uW0ZrdV4HBTtsiNl8qN4MbPX4tOBAj9JOQiJs+j+A0+nth6B8Sj30EVjEvp5Z4zTNHYxFQwuVFaXaPJ+CLPG3nBzQoJvS8CiOzrgATLD3c8vBRNA+tsDq22k4v9DzkOlCYiSbkhiPjAfRK4wp3+69F2KD+uOQu5yK++7/Km3QbAu+VYSA2pP9dURBpytrcwJWg4l3uYc7r/JKojqyoP5AmQUoaCNc4MX2w/JwIrgEPGl/B/sveDo1f4crLqng1feRHhm/1LISaclKStOjNXTmzRUgD9EvUheDnydtN0zoOeid5GywUxTQ7b6yqL17EQfAwypl5I/+znUVxFcwXimmSCGlhrOQyRM02/uJQvZTmCCBVp8c4vwYWh5VC0reh/fFYoO9Os5TQIG0AHNvfCGWrz1dKuKd5h3ALsxqzQYHbETn8SbBHrX1evsmPWfPRgGyFkqHIYtdo5asFvPlvrcjnxrLBQ3WKP61dubd+rQ8mwlKUpUm8beFXUWx8DI++uIBLyBqvotZbTeqMpbyLrvjde/Es8SPXqBXALWU2wKWJdDaDhME+MxWXOJLQ4eUrzmRAbB3MTjJdcsvhNgran1X1D+PmAGNF3j0MTrpzA2enqkqSfNx8565UtjxxXRoCdL+tCM0ouvoeWRaAwFLLtTziSDktESxecak2Luxmrc73RpQF8sNHyaCDD1GdWYx
 JAuFKizh
 BboUWY2634fREJjOWqGd3wXIv91dIpW40lfSZPjKkc2grPVbm3VtBRfBHGrn/Dg/JwGc5NRSca5AbXjQpwLfFP6Y4tmq2X9rtpGnoc4r4XbMjpJw4Br0UlE6ng5eGt9cfaYUCJGgcv/Hj4kUFfKa4RYfeh72AQ7cYuFhSH9YjIbvL5bFNKeLMEnvyfiLZ/gXt7KshacLbQWmz/sPAmlnWA5m2vyPI7k//UsdRhNS+Y5z9/tAix632MyJtCL1vQcxILMcdQFY7P/OcFb4aYczDlKEHjYUZMEiY6uGoGIq6Qy16AWmwf9G3X3+eH9pN+4+sELJzcDZW9sAA9UXRqJS3tSFrux0Of2Twwinb4VrOs3Gj+Cz3DtECkWXnSJfViWxCxihoq/sdk0bVkQhMqgMz2+yQFmJFM0ceXvnukMUFWx2dJgekhvmZkvKXAOiIGxpXvhn8vckQAB/QqdDUsZfoq5KjgZdVPk1v7QxN0JDZmDRSQOMWUfu+KdWkjKI0LoKD/MZml/2lro3jBm14g4A08NuIusrbkt4jO1T0qCrfF+Wa9mPLsRk0uZTK7TO0T8j9CRBWKkbHXPqzkHyNOz0hCHvyZLO11qDYKgddA0Wpkw4Ro+rey1FmjMTpKXK9u+J0ZufWlr4+kjv2c+tmPG1FCFJJPC78HVUZgCCC3Dsn4M2miFfKNDK9KumaBaT3u7leErqIoispyxMSUdD7iMFpuX+zUREqHnFDQkGBP0cGlEUxgfPXUEq9CTkwMO7tc2FsYxWAmYdMVV4Vdvr5/b8KsngG3Xe9fC2ana4oDywdCcr15hT6T/tKtidhKsiUbQwHMEOV4MJDQPjHt4U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

initramfs cpio tools had been subject of several recent discussions on
linux-kbuild.  Let's get two minor steps forward by enabling a
top-level target for building gen_init_cpio w/o the need of a valid
kbuild configuration [1] and move the tools for generating the built-in
initramfs from usr/ to scripts/ [2].

Link: https://lore.kernel.org/all/20260220191150.244006-1-safinaskar@gmail.com # [1]
Link: https://lore.kernel.org/all/aSdrCFkUQup3qb-q@derry.ads.avm.de/ # [2]
---
Changes in v4:
  * Update tools/testing/selftests/liveupdate/vmtest.sh to new path of
    gen_init_cpio (Mike Rapoport)
  * Update stale comment in gen_initramfs.sh (sashiko)
  * Link to v3: https://patch.msgid.link/20260925-move-gen_init_cpio-to-scripts-v3-0-99c493f76722@kernel.org

Changes in v3:
  * Update various remaining usr/gen_init* references treewide (Nathan)
  * Link to v2: https://patch.msgid.link/20260720-move-gen_init_cpio-to-scripts-v2-0-26b7e15c7133@kernel.org

Changes in v2:
  * Build gen_init_cpio only if CONFIG_BLK_DEV_INITRD (Thomas)
  * Keep underscore top-level target name (scripts_gen_init_cpio)
    (Thomas)
  * Link to v1: https://patch.msgid.link/20260309-move-gen_init_cpio-to-scripts-v1-0-0c5059b1ec5b@kernel.org

To: Nathan Chancellor <nathan@kernel.org>
To: Nicolas Schier <nsc@kernel.org>
To: Jonathan Corbet <corbet@lwn.net>
To: Shuah Khan <skhan@linuxfoundation.org>
To: Randy Dunlap <rdunlap@infradead.org>
To: Luis Augenstein <luis.augenstein@tngtech.com>
To: Maximilian Huber <maximilian.huber@tngtech.com>
To: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
To: Pratyush Yadav <pratyush@kernel.org>
To: Alexander Graf <graf@amazon.com>
To: Willy Tarreau <w@1wt.eu>
To: Thomas Weißschuh <linux@weissschuh.net>
Cc: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-doc@vger.kernel.org
Cc: kexec@lists.infradead.org
Cc: linux-mm@kvack.org
Cc: linux-kselftest@vger.kernel.org

---
Nicolas Schier (2):
      kbuild: Mark usr_gen_init_cpio as no-dot-config-target
      kbuild: Move gen_init_cpio and gen_initramfs.sh to scripts/

 .../early-userspace/early_userspace_support.rst          | 16 ++++++++--------
 Documentation/filesystems/ramfs-rootfs-initramfs.rst     | 10 +++++-----
 MAINTAINERS                                              |  1 +
 Makefile                                                 |  9 +++++----
 scripts/.gitignore                                       |  1 +
 scripts/Makefile                                         |  3 +++
 scripts/Makefile.package                                 |  2 +-
 {usr => scripts}/gen_init_cpio.c                         |  0
 {usr => scripts}/gen_initramfs.sh                        |  4 ++--
 scripts/remove-stale-files                               |  2 ++
 scripts/sbom/tests/cmd_graph/test_savedcmd_parser.py     |  2 +-
 tools/testing/selftests/kho/vmtest.sh                    |  2 +-
 tools/testing/selftests/liveupdate/vmtest.sh             |  4 ++--
 tools/testing/selftests/nolibc/Makefile.nolibc           |  2 +-
 usr/.gitignore                                           |  4 +++-
 usr/Kconfig                                              |  2 +-
 usr/Makefile                                             |  4 +---
 17 files changed, 38 insertions(+), 30 deletions(-)
---
base-commit: 93f51579e7df248780214094418f205253383cc5
change-id: 20260225-move-gen_init_cpio-to-scripts-9e89ef99e51a

Best regards,
-- 
Nicolas


