Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97BA0C982D1
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 13:29:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A1696B009D; Thu, 17 Sep 2026 09:29:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 853C16B009E; Thu, 17 Sep 2026 09:29:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 768106B009F; Thu, 17 Sep 2026 09:29:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 474436B009D
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 09:29:57 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C72B71A035D
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 13:29:56 +0000 (UTC)
X-FDA: 85223337192.28.6F0D816
Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	by imf01.hostedemail.com (Postfix) with ESMTP id 1C14E4000B
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 13:29:54 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=starlabs-systems.20251104.gappssmtp.com header.s=20251104 header.b=IvsoO3eD;
	spf=pass (imf01.hostedemail.com: domain of sean@starlabs.systems designates 74.125.225.140 as permitted sender) smtp.mailfrom=sean@starlabs.systems;
	dmarc=pass (policy=none) header.from=starlabs.systems
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789651795;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=kc8SSZKaYeSDYTduIzKtgY7SY2vSIslvd8ziXmdFBEs=;
	b=1OCvFAmy6bGUoEFC39G3CdPnleSSGreOrXiKh/FJqxE8Jo2mOCL4w0NApg+/QEZ5VkvJ9I
	nNMNT6lXDXsYS+p+aqpDL4nBQFDryTDtwzGH2zmvi0PO9465edCGm+gaBxWc5PueQWsRpp
	6X3qzzizxXUx80qJDLMKA69AgPwJkWA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789651795;
	b=p87BdLtJXUXHoZZZvVS+ClcT0gNMU7V5hkbkCCPvjFePMN3sFlEAjZgalhv0wjOPhwyZ79
	e4gyf2Jmk1ON1siXwNybgzshtPYL+jbFZuvIsoNB8x+NEug6BApl9mx59KIs2s2N8f/GgB
	7kwj8AR1U0dog4XVyZ3ooBJ+iJpH0Qo=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=starlabs-systems.20251104.gappssmtp.com header.s=20251104 header.b=IvsoO3eD;
	spf=pass (imf01.hostedemail.com: domain of sean@starlabs.systems designates 74.125.225.140 as permitted sender) smtp.mailfrom=sean@starlabs.systems;
	dmarc=pass (policy=none) header.from=starlabs.systems
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49b912d37b5so5361225e9.2
        for <linux-mm@kvack.org>; Thu, 17 Sep 2026 06:29:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=starlabs-systems.20251104.gappssmtp.com; s=20251104; t=1789651793; x=1790256593; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=kc8SSZKaYeSDYTduIzKtgY7SY2vSIslvd8ziXmdFBEs=;
        b=IvsoO3eD4B+liVz+ZUwIghHL/XPRboOQSFXkT59Iz/AtqqztX78znepoyyxPYKAJu8
         YeUlWG1skep9HtGSUCtbXGFf23CN5B4NJUEFqPFbjppkGdUlc7bvpBzKgm0FQndC1lAZ
         0mXkUrauEnB5Eg8TpYdr8+1mZBMJF9RFl1DzyqGyr9IE89gpCyQqFp+gjW/EfDYhzyQv
         g0MYuBFvi6ao1zlz2Ax+lPDIHij3rCIAOcN0vRddjzTsPJF/OjaIiysvQoAhu7GKMO0i
         zGr3qgc568sLQT2HQVW7k/pLtPCYf/EIntwEkJngyIe9axGzxQ/4ClF0SWiNByUz93n9
         VvCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789651793; x=1790256593;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kc8SSZKaYeSDYTduIzKtgY7SY2vSIslvd8ziXmdFBEs=;
        b=auTZPkcryWMx0O9EJXXwuUcmiP0RycEPhmFmPf/9577oPRlj4+mwtt2YE0fsTf7SXm
         IJwyK1QB+G4OO3uJkFtKuPY7//GNg80k2gm1e/UwwJLPMFi6aPzGyMMKylkyHAPskdUS
         ZtH+gN+kWNLf8TdWO9v4bJSB65jJmIOCWybJrEEplzYgcvSMCXfcZtIEDvsBH4V06QxD
         6wt3PSTU1uPrW3p9OgoMXg3zP1fSE+eVXezz1tSFatqMGAGxZemn2QXXhhppDjzUuBC9
         VpGhJomUT3prfTiHsSYmw0/Xi8mTGyQhz+J42LgL8rhEcXmgQhKiqpbpxMTBjU8kld0B
         xi2w==
X-Forwarded-Encrypted: i=1; AKwUvBw/BQUFa+Eci8oF3Walpaq3y8ZRvieQuYX/JhjB7lqM+a8ZN+3mev3TaBO35FhG2tgEFRI9izQGXA==@kvack.org
X-Gm-Message-State: AFuF++nhLILwHwC9AG7jqs94Lyf+kfrWh9UWwho2OE6b+FtupHQu4WHt
	A9lYYm4iwZBPmL7onSeZ66vU7jueNapFsrxoeT72JtGyIvLuIS6TsfFolLj7RoATfw==
X-Gm-Gg: AYBFou2juhSoQ50Edn71AmoUCvWR4vnpwfPgKTZUD3zw441HGcdTYW+mXuUGfSIGP4w
	c+SXM91vR1duNYZgJQZq1rlVgOWWaBDzsQ0skPvUk/1YATGFfHN6vblGq2i2vcg/8kxdgsxfpco
	GlYO2EH4Mzk+kc4EvTE2B9t7ZRlnLGZ834FmnE7h/Lop/goPnMNfyGceegsYlGxEbcD3E/36kq6
	kUxQNi3n5m0zydfFcLITiurSe/hds1IRTVHJdUuB+BYnBAMHzQKseB1YTAQBM1yPecGMa8dm/pP
	smySVla34mR564FqIn+/wEnT8U/MtIU1UJEMZvUzQgvLZMuIk98o8wYuEvatLwAdU2WC05ieb1t
	5t4NVeIWJA3sC9k1M7ul7dVydYtrBciD539xfQUIgQlAhHMsuGfB1gvlz06sEr81FCbjvi5lDM/
	oEHu692RQWZn28BmKZ3HkzufDBht39/ZIlHJxfi5CmDuhschZ1fhRWvjtrLNODjY4XBZjcaQVhb
	pq+QOCrWoCJ5E+tTEEAQEVKeZA=
X-Received: by 2002:a05:600c:46ce:b0:49c:dca4:94c with SMTP id 5b1f17b1804b1-49eb7339895mr154172245e9.13.1789651793298;
        Thu, 17 Sep 2026 06:29:53 -0700 (PDT)
Received: from fighter ([216.128.28.240])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fbd2356d1sm97548275e9.6.2026.09.17.06.29.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Sep 2026 06:29:52 -0700 (PDT)
From: Sean Rhodes <sean@starlabs.systems>
To: linux-pm@vger.kernel.org
Cc: "Rafael J. Wysocki" <rafael@kernel.org>,
	Len Brown <lenb@kernel.org>,
	Pavel Machek <pavel@kernel.org>,
	Evan Green <evgreen@chromium.org>,
	Sean Rhodes <sean@starlabs.systems>,
	linux-kernel@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	Xueqin Luo <luoxueqin@kylinos.cn>,
	Nicolas Bouchinet <nicolas.bouchinet@oss.cyber.gouv.fr>
Subject: [PATCH v3 RESEND 0/4] PM: hibernate: encrypted snapshots under lockdown
Date: Thu, 17 Sep 2026 14:29:46 +0100
Message-ID: <cover.1789651778.git.sean@starlabs.systems>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: oys4kt5wmdh84j7yc4rkm39ukpb8hzms
X-Rspam-User: 
X-Rspamd-Queue-Id: 1C14E4000B
X-Rspamd-Server: rspam03
X-HE-Tag: 1789651794-756419
X-HE-Meta: U2FsdGVkX18gUG4z938ocGKLsUha3WQ01XSZA2lizTuGx+5rjeqDdPS38lTR2yuXUozLykfrxHgL+ALVPuL/OT37tz543jnrmNLUSXL+//Dro1f0jyGhm6d2dDlolbLoVO4X1jzub4By0njTaUqI8Pk2motJ/jHXOG7BBdduzAWCAborSRiyZEfADsi0NMo/GXA724qFYsVRocQZMVTKjpp7Pox6SGeCpGbFpmZibpbCSr4zNJu1oYBgYKKo+Wjf3qHY6JASXmegaFk5bLHq1p1jVM4zjd5mOkrEQnVh5nnObLXK7SPh08/nP1vjmC20XOZpKAz91XxQ4EJ74pYgCXVbWoL/y4g31I7hHQqJ+/yzkvqef1yo3r0DJzAYbJpyYI16Try8lZc1p9vUo8HQOXslSuw8VOPjW1srtL3qX5H+x2u2Br6YXuJ7+ZgscATI+UxN34bS7ZW4WbHHTvVXHST8V4tTSOFRSuND1KaX7mrSTEQkagNcX8RrQ+wfmLg7kZtkoPIAxtFs3UHWJ3akF6FjJZCLoKSt4cz2k22RiZ01u9sf+ZLRNfca1k+/rRj+N/RJawtRkHVmGfqoGGt6sBd/A2FAVerO6h/hBnACW2agzhlkvN8jk26URYiJzKtGJFAsVxtmxJOPJ2hSJWIPos+WKUshnh0UZjK8HVo4xtej1CozZhYMW3zAzI4tGh5kgesoCO+yzxgv1axIBnKuwmUkFE2TyO6MUdJdZnaxeHPc9s/xtZKCmSbOL872LQncUbDjcIbIluCQGrRhKnX2OxhY+SYkS3f52QVrGYYUeNn3HwhH/LMVseablrrocp7PAPZ3uBA9sz6Zi6SJKdRxNSuMoeRWtd5THl+0DyQzbzhLfWJbcxmRazd+Zw2icCQ0WHSC4dbFjCQLN6lc15MOAPf+o21vJPT7EMPVDT22+SRLBJf/fIJ4ZV84nCHHfJLsB2o8vkUxB02ZYfVwtPe
 JYEQ3Fx2
 3c9EpFIlOP15kqnqaY9y0KaPylKlpF+wWrdmyEmJyiexNTKocpL1PjK6vbcLu/bABISg+mWkA7VxU+7ZldCd7BRSNjw/tVkvp3mVwjy+kltDim/cjSlnRyxafGiv9ECcB0qHRmcFERhOsEri49srEVlFBlVRjlULQyd6fVNnlvA4pvxbnvfc4/3Zlt7T4yOohin2OJGqUnQTFUhI5YMS0G/YU2XTJ895OP/CRmVCrOrM8eTzvcHYzNYx2VO4t0fJlCkt5CiPBdA38f6FBNu8IIiPae3Oe7qpt/DuNhYFrzU6E8DDNK4l7gvKkPoPeJEx0+hI18CQpqjcaKoo8LbdFWRJ2x/YZv3yclw27sZcuqTOUV8LDogC/fsOLK1sVHBAUCl72KOtfuRMZ4TLsL+wkJAJpg4Po5skU98mV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Lockdown disables hibernation because resume restores kernel memory from an
image userspace can modify. This also prevents a TPM-backed uswsusp
implementation from using /dev/snapshot under lockdown.

This series encrypts and authenticates the snapshot in the kernel. The kernel
generates the image key and wraps it with a seed supplied by trusted early
userspace. TPM policy and unsealing remain outside the PM code.

The seed interface is first-writer-wins and does not provide freshness.
Trusted early userspace must provision it before untrusted privileged code
runs and enforce the required TPM policy, rollback protection and recovery
handling.

Tested on StarFighter MTL with Secure Boot disabled, integrity lockdown
selected manually and a TPM-sealed seed. Keyless and user-key S4 cycles
resumed the same process and boot ID with the swap header restored. Corrupted
wrapped data, invalid magic, a corrupted complete-chunk tag and a wrong user
key were rejected. On exact v3, the user-key cycle and the allocation, free
and reallocation path used by swap-write confinement also passed.

Previous version as it was updated whist waiting review:
https://lore.kernel.org/all/cover.1785838445.git.sean@starlabs.systems/

Changes in v3:
- Rebase on current upstream master.
- Preserve and validate the saved encrypted metadata boundary on resume.
- Drain buffered metadata before a late user-key transition.
- Reserve enough encrypted image space if userspace adds a user key after
  querying the image size.
- Apply swap-write confinement before enabling the lockdown exception, while
  preserving the ordinary availability check which routes lockdown writes to
  the confined path.
- Account the pages actually allocated through the snapshot API instead of
  assuming a userspace swap-map format.
- Document the first-writer, anti-replay and userspace I/O requirements.
- Remove an unused swap reverse-mapping helper and tighten local naming.

Changes in v2:
- Keep raw writes to active swap blocked under lockdown.
- Track encrypted snapshot bytes and header writes before allowing
  lockdown-time image writes.
- Split the encrypted stream at the metadata boundary only when a user-key
  transition is used.
- Return -EFAULT for userspace copy failures.
- Document resume meta_size handling.

Evan Green (1):
  PM: hibernate: add seed-wrapped encrypted snapshots

Sean Rhodes (3):
  PM: hibernate: confine encrypted snapshot writes
  PM: hibernate: permit encrypted snapshot device under lockdown
  PM: hibernate: document encrypted snapshot seed ABI

 Documentation/ABI/testing/sysfs-power   |  18 +
 Documentation/power/userland-swsusp.rst |  33 +
 block/fops.c                            |  58 +-
 include/linux/suspend.h                 |  24 +
 include/linux/swap.h                    |   9 +
 include/uapi/linux/suspend_ioctls.h     |  31 +-
 kernel/power/Kconfig                    |  15 +
 kernel/power/Makefile                   |   1 +
 kernel/power/hibernate.c                |  32 +
 kernel/power/power.h                    |   3 +
 kernel/power/snapenc.c                  | 952 ++++++++++++++++++++++++
 kernel/power/snapshot.c                 |   5 +
 kernel/power/swap.c                     |  87 +++
 kernel/power/user.c                     | 272 ++++++-
 kernel/power/user.h                     | 150 ++++
 mm/swapfile.c                           |  25 +
 16 files changed, 1683 insertions(+), 32 deletions(-)
 create mode 100644 kernel/power/snapenc.c
 create mode 100644 kernel/power/user.h


