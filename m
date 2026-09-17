Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78CD1C982D1
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 13:26:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5DDC66B008A; Thu, 17 Sep 2026 09:26:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B60C6B008C; Thu, 17 Sep 2026 09:26:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CCE76B0092; Thu, 17 Sep 2026 09:26:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 19DB36B008A
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 09:26:39 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5DC2EC01B4
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 13:26:38 +0000 (UTC)
X-FDA: 85223328876.04.9029DA4
Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com [74.125.225.76])
	by imf08.hostedemail.com (Postfix) with ESMTP id 7C39A160007
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 13:26:36 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=starlabs-systems.20251104.gappssmtp.com header.s=20251104 header.b=viysgF2m;
	spf=pass (imf08.hostedemail.com: domain of sean@starlabs.systems designates 74.125.225.76 as permitted sender) smtp.mailfrom=sean@starlabs.systems;
	dmarc=pass (policy=none) header.from=starlabs.systems
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789651596;
	b=oxAxibbl1tgm1AkD6EsvvMq/+xNtc6u0veUzQDPk3NE1J+o3pwT23KhVCcg9yy8G+mElY6
	sIlD9rehYskGl3/k0izhBVbCOv2+YO8oOgmu/7u9ngcASK23K+v8lMHsaOHy6aCNHPfyMC
	oKAqktor44SmsUb3nZyAzetpQJ9+rcs=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=starlabs-systems.20251104.gappssmtp.com header.s=20251104 header.b=viysgF2m;
	spf=pass (imf08.hostedemail.com: domain of sean@starlabs.systems designates 74.125.225.76 as permitted sender) smtp.mailfrom=sean@starlabs.systems;
	dmarc=pass (policy=none) header.from=starlabs.systems
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789651596;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=FTWU3z7oT+AmhRKIBpIuUxW3EDym90iXyKLvYlGNFT4=;
	b=8Gpfa9LDUifz1o3X4KZ6tg41gPxpC7VNNeEYcCTBX3dr3OzZ05fpNJpOzyOVwJEg1wWx42
	sCblYDT3PPSFyAHq7O1qjzKzbmfHKjfmpvBvZ+7viN+bMfDUdXxlRKiRhY7C9cddGlDjP0
	jfH/mjubDhrXuNxa3nC3NfVACpN9Eak=
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-482f633ece3so649872f8f.3
        for <linux-mm@kvack.org>; Thu, 17 Sep 2026 06:26:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=starlabs-systems.20251104.gappssmtp.com; s=20251104; t=1789651595; x=1790256395; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=FTWU3z7oT+AmhRKIBpIuUxW3EDym90iXyKLvYlGNFT4=;
        b=viysgF2me0iDNjGawnDbvhe+cwJ2Jglf6qwdV6NAyEfzu4TG5Au8VrPomDNc1m4uiR
         B9YPqV2UDBipjNssQQg+Mu20iy+o/r5DaVuarY5GwFaz3AMOrELWRcsUwackqWXMFGtQ
         hWSCqCHKlQFDKo24pSzNYf9y6gn9u3kFIeGVcvCBIfVtlyMkgaVR+2wtkPYcEvuw0AgB
         jBUkSfA3xO/N5iAEPLJwBXko/IYOKsU38GoTupru6crDdRP8DfoClgCaL3Hpw+viwONT
         ZAqfa+gGvGSsxoYBRuGDp/iacSZLbhEJygGlk1+rrSjYqxYdSXAf6g32JMIgQs44oGIQ
         kH5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789651595; x=1790256395;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FTWU3z7oT+AmhRKIBpIuUxW3EDym90iXyKLvYlGNFT4=;
        b=B3M9wYh59wTFE/8tY2En2dBsbMwsexE+Y6EBFJssBbkfGfA3NHjAx1DmPzcPCoX5zR
         3Ng/82vDS94NximsKQumnGQ0aiQ4oscawJLsN5mVyqZLku6qfEAb2J+jXpOdhYSJbPK7
         0aF20yUOTHGSu8ahyWTKSBkOXc57Y+eNWrn9P/npLh/c3mRpwRSY3JdnEb2tvDwfxQeH
         zMCL0uZGUKh+3ZQo0eJOUh1QiWGuw6iv7LWYrM6z6xh2GDICsxSRryZCi7uEvwP6PR24
         7MJTnmT5dCuxWav014w9bqgysPATo4DeUI1cO1E9E6xbFXvh4VHbWilBxjPtX30t95/c
         NMtQ==
X-Forwarded-Encrypted: i=1; AKwUvBz07F2t2FAJ8215FvBM4ncE9hzKPrl55vnkEmvc2luFGD9MA4PbdPazHywTi/L8Itz0Y9ONHqzylA==@kvack.org
X-Gm-Message-State: AFuF++lLhBpOYEwN9NGHWmK9XJnjIMB430heSnHTRsKrlxPbiwRTHseo
	OGv/2XxvT6fLjYlioJLLJAU0GmHONvSEFccfDVA0oe8Bn9fxRlO0Ap2dkDSw0mQqcA==
X-Gm-Gg: AYBFou0WW4Mj4Jl/F8LPZ+RPE7qkcL0Ktz4ZMNPyYoWbR2zpTlA+TR/qAJgRcuT7D2V
	RrrGZEYH8keG/MpkjjuSxdlto86J7duxOHOf5gKuRkby4K132bnKGYYYkeHnWXzo0cDEX2GwvRz
	oTlIcNwIGlPRwUYYThWMDhKmnipGv/4mhxtMRedIF1GMNGbdaTYbCSRWWUo2RFrZtigmh9S+T5j
	jLF3ubaZwPs/krlBQTgZSqlUla/jIch/mHQzm0UT6D0esRqEznlXxsivJ2rkc+RHRBIemlLiHc6
	PD2t99tu9qkk9xxIB/BPunNOAlJfTkeVX8WfGPzWMAb6AvCGBR6yIXPnUub2cLKcugUIm/UC8jz
	8/NGJ0wkVIEgMzjETjv97dJdy7K0Aldkx2Px2iPLJwP6VK5Lu/4AR+jAuhu/7YfYIc6RXwwMFz5
	bRKZfzPJ+M5XFsn8eGJJc0u07MaiCmkwaRH9iSa614hTE4ioPvXnYFLZAhJh83cn03victEEXid
	hJJZLt8JkbMU4Ik0NStqG+jszk=
X-Received: by 2002:a05:6000:4697:b0:486:e6cf:96e7 with SMTP id ffacd0b85a97d-4870d067865mr6063193f8f.37.1789651594673;
        Thu, 17 Sep 2026 06:26:34 -0700 (PDT)
Received: from fighter ([216.128.28.240])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4870bf1f6cfsm15879947f8f.13.2026.09.17.06.26.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Sep 2026 06:26:34 -0700 (PDT)
From: Sean Rhodes <sean@starlabs.systems>
To: linux-pm@vger.kernel.org
Cc: "Rafael J. Wysocki" <rafael@kernel.org>,
	Len Brown <lenb@kernel.org>,
	Pavel Machek <pavel@kernel.org>,
	Sean Rhodes <sean@starlabs.systems>,
	Evan Green <evgreen@chromium.org>,
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
Subject: [PATCH v3 0/4] PM: hibernate: encrypted snapshots under lockdown
Date: Thu, 17 Sep 2026 14:26:27 +0100
Message-ID: <cover.1789651581.git.sean@starlabs.systems>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 7C39A160007
X-Rspam-User: 
X-Stat-Signature: jcq98bsph4x1s3r543n4bwu6zmb8eon8
X-HE-Tag: 1789651596-201046
X-HE-Meta: U2FsdGVkX19LUg3U8hnefOffFsf6Q2D2FQsLz5DhcKpaQoIBWwkSF/x2y2ZQuZfd+/SM8cUbsSSr8Qw9DWj8ft9u1KMLIkMjInFuNXutvzccx4oM7xBKhW2P6BjRWeZ+3ZwJY17FsQyXE7+38Ad2D9uKPIY5XsGfQ3uSzcAhKDkkbYDJaphr2IkS3stcM8xfACmX2L/XNoHs9vhNFRG9wXJ+hrTNlQd8hAa6+Oj8WhGDNE2gZdPE+O5er5dPJSEddJwdngTCf/+LO7V4xsLSfdUqMxugbRXdWhD/+SsfGVXnEM/ZSEQ17MSkOy1Ucsz5HtBCNiwIxB56oeJkvtQ6Y0S2Ej9I9u69qWlr3TrZGvPNjyXpDvgkt33yJisJp2pTIpNoW6RlOMjpzVt1xWUW/LYC9rQBIJCGBJOCt67PUDrovahv8bSFrYb2E70yNVPGpEleq6Fy6tAg9UUl8OCSGY3RDmKV8enF/uQaXvc0+aKW0YjDhQ9DIggtwI4kQeS8UlS9Ye2IPJ4Z1tWDtrSHQgGGv8UY0aTXxzHsbIcK41oKIRLMfsWSYYF/C3v0fG7q+CwSZEwbyft+m3cm57ZoY7JJ957ty/bjCpiAfvqk9F/LKPKii0sVQ4R+nOoEWfwxAqBRmssK86euDjBCx77sADi+a/2OUD/eF3U9JQrSLAzHyLpKYjr7wCJ9Vaj0/bkE9gWzAC9nTib4tNxmnDccWMQkSRzpvPKvSISbvLYvVilM4GILX5B7MDNCRdkGFULakSGLHHXZI3Pk+hOoIKORT9PZNLS93+X2jN6n76PGGVl522lpF0UG4gNoZtmY3nKsdQzqaokkguTwPUti/yy2MgqSyp2pf2Rwnf8wj9dQBzZmxWTVmi0WAahWe7fvFizQ1hYZcyAQJ+SjXvJrMSDmrTjUwcg5wQA4hnd2GxbK3DM85uKm4UaCDOwhPrrowXMxBk5kVOuHXBrLNMG/7TI
 7BMAWhdU
 YgqvOfxifUAm7cemZ7P+Yk2bUKsOM0v0klcy7xTecafWT2/L09P2HNpAvBM4jpLJeloOMmFO0NM0CkWvwGh3J+4NKkeuZn6wAMIFRliWlG6rlKKivOqeC8sZH2T32JquW7KknBtBdxOWBM1tA6lslZUvKtvyIs3W/V9JhH3SP8pee2yXK5KJUaZC9p2RdT7WKjnxtb414mdqzlcOwQCFmE2iVpzUWTxMn7EALg3qe9PE2cbTVt8R7rM99W8sas57RZfv/ZqYCyrPP5XNqZiaE4md2WtFvo019afPICvgs37/yoi4anin5v4seedoD1+kcsW6hLIYWOx4oGRIHnG9R8iw5x4NSOT90zzke49iVyP3ug+noFo/d+t83ppC9ekvq2WgGsS2yVRNN9XCqmB/JTlE7Dzllx3rA7bz5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

PM: hibernate: encrypted snapshots under lockdown

This is v3 of the encrypted userspace hibernation series. It protects
userspace-driven hibernation images against modification before resume,
including when the kernel is locked down.

The kernel encrypts and authenticates snapshot data and wraps the randomly
generated image key using a seed supplied by trusted early userspace. TPM
policy remains outside the kernel PM code: early userspace is responsible for
unsealing the seed under the intended PCR policy and writing it to the
write-only snapshot_seed interface. The series therefore provides the kernel
mechanism needed by a TPM-backed design; it does not itself configure or
enforce TPM policy.

The kernel accepts the first valid seed written after boot and does not
authenticate its writer or enforce image freshness. Trusted early userspace
must provision the seed before untrusted privileged code can run and must
provide the required TPM policy, rollback protection and recovery handling.

Patch 2 confines direct block-device write() calls to the active swap backend
to the process which owns the encrypted snapshot, its allocated swap extents,
the recorded swap-header page and the number of pages allocated through the
snapshot API. The userspace writer must use synchronous buffered I/O.

On a StarFighter MTL with Secure Boot disabled and integrity lockdown selected
manually, the encrypted userspace snapshot path completed full S4 and resume
cycles both without and with an additional user key. In each case the original
process and boot ID resumed and the swap header was restored. Corrupted wrapped
data, invalid wrapped-data magic, a corrupted complete-chunk authentication
tag and an incorrect user key were rejected.

The late user-key transition exercised by those tests is retained. This
revision also validates that a userspace-supplied encrypted metadata boundary
matches the authenticated image header; that mismatch rejection has not been
exercised on hardware. The encrypted S4 paths were tested on the prior
candidate; the revised allocated-page accounting and active-backend handling
have not been rerun on hardware.

The deliberately corrupted complete on-disk image case was not run because
the test system did not have a reviewed pre-root recovery mechanism for
restoring its swap header.

Previous version:
https://lore.kernel.org/all/cover.1785838445.git.sean@starlabs.systems/

Changes in v3:
- Rebase on current upstream master.
- Complete both keyless and user-key hardware S4/resume cycles.
- Exercise rejection of corrupted wrapped data, invalid blob magic, a
  corrupted complete-chunk tag and an incorrect user key.
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


