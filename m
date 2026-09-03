Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E7FDC624D7
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 20:37:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB7E76B008C; Thu,  3 Sep 2026 16:37:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C68F96B0092; Thu,  3 Sep 2026 16:37:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B31276B0095; Thu,  3 Sep 2026 16:37:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 775C26B008C
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 16:37:32 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DAE6C120636
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 20:37:31 +0000 (UTC)
X-FDA: 85173611502.16.051EB66
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	by imf03.hostedemail.com (Postfix) with ESMTP id 2E67320009
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 20:37:30 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="Qxw/I0t2";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of kmehltretter@gmail.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788467850;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=OvK9knuWq5uxHuXSn84mygHm6H7cFKDZ8xVelzi2Vf8=;
	b=BOqZgDBEiq9C49WkHsqD16eqF6RR+dyNdcxVw63f07IIxdbaOpU7iv02wZNYeyouvzKWon
	UYL4hEJkwDFd6Y2uheXTPcZKkEzfimmbEksHwoy84bPh81xTWrPaomspkCO8xOVtLoVeNx
	Mhk/pp7sF4KIFmMAUA01cvQVD+CGIos=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="Qxw/I0t2";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of kmehltretter@gmail.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788467850;
	b=PZjlu3dC9n5hg19Fo40DPm/JwBgtQPee6kPUHOYESnrMxYsP54ujBSzy/Y9eBLBpy7J+Q5
	zp8jnlI6/o6/87N9/YJ+siyGhyBmaezVOsVI+kDc1BIAaScuCS9zIUotp7AuKDgqMMdek4
	ol0rdZ7XOPDWcGeM9KewCjbIBO+JP7Y=
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-4843efcbdb2so213722f8f.2
        for <linux-mm@kvack.org>; Thu, 03 Sep 2026 13:37:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788467849; x=1789072649; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=OvK9knuWq5uxHuXSn84mygHm6H7cFKDZ8xVelzi2Vf8=;
        b=Qxw/I0t2cYvsitb+AH1OrmhENhwCtmu6r0Evif3KWU3CcwMDdY5zuwTj3+8cpySwvE
         pAesEM63dblJTQD+hA2/LNgthkTrRUjvAkBgW38PhlDpxv/tkGA9w4LoHuvbCsK4gi0B
         lH1ND7x/hVLQvWlTxsN0jMEdsmV+kmO0Y2ZBIqw6OTtChBdZEyesy2yQVPFQpDBQu3Bl
         U1X2nkVAl2k+pe7G+JGo4oyFQczBx/Hm+grMRC0fws2xsVkUapRULvkKyOBezkpHzmye
         44JDFIXlXgWx3LIVYnNXQwhtcvrKHv2/q+MgnzB/7gMIMsuN5snmAbo+NdmPdPVA6V9R
         RBIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788467849; x=1789072649;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OvK9knuWq5uxHuXSn84mygHm6H7cFKDZ8xVelzi2Vf8=;
        b=PwR7Ofn4pyZucOvHcSLtJI6Fw/v2PGu8GK/3UpMCXxYufpf38Jja3GNpeFYofhj30P
         X3kPV+YO2qeRy6UBK7bXCcksbh0g0CA1v4mgcoyXNWy8VEYlzBJfPxEf+MZ0wxvQ9vKF
         F+he1WL1vm0/8ZOqu4Ccu68BIG8cXmYwBFWe7NYImgpdRApj8mVLjrkVC1OyBtHe62sX
         iiPsuCyyG0ghcNNePADtXkswxmAzf1Vhbj0Hc/4tKVh5ruiJ9KAvFHQphscEHjiDo/KJ
         i0el68VIsYDd7dTqmtNlZZrIdn+cqdCpckDyeFPrdIq41Fg9JrT4OEpRL/97TFE4/iZ5
         hZBA==
X-Forwarded-Encrypted: i=1; AKwUvBzH0/ltWdTi0CrCZoCXdDzKvewmoGBeHVRhZSXMq2BOZ0MlqZQ3fX4Fu9rDZYN6v9MjTtqN53thYg==@kvack.org
X-Gm-Message-State: AFuF++kbggdXTFBnLbVsURk3b2EQ1T5fc4KXHiefvgVSyo3E5yhRNUNu
	2mSf4ckk3o6KvpoM2LpX9fe9NoCzJtATlBtMCp+/FtNRscEbGJkF1i2Z
X-Gm-Gg: AYBFou1wg9SpeQ41CHoAzK7f/fyUF4BGYN6hqm9SWghO83QYB0y/g4mB80z8BX9OYhW
	cw/h/aTxPXwYfh9E1PZimhE/Oi0gWpWhVOeCzyy8Q7xDy/iNC4WUineM/YqSl556G4QSqP25N73
	3CCjsXieDzGzG7yN8VhYBXLJQUZMwQO6r4T5wPkIH3aWZLmgAup3pjMOXXWN5lohb4aZHAJ3aSs
	TM5lrXZFvetCPTVjSDYdBiTZlNFRzhlbMx0jJa90eW/WHC/APnk1bNtYL06k/twpl4tTyOSOznX
	Mq8aIVOmrJXy2X7o9rVX6OUHWu1T2uM2Ipryiehv45EyfmzzXy1VDT18Fq3dOVq5Gi6Hvjop+b+
	/gMKaC/J8qrpY7oDtDS9HnnvZQ+CTRKKpYYpoi5jWRGWXMQOGjsEGwJ6S9Chh9FSYNTSYOJr0FJ
	SlLhzS/QUpf6Fij74DWYh+4JysbcsrSNLAbZwumDjQfgQIcm/fHTuwkEPz0G/D639WbY3yyy3HO
	1kiP3bls+HlmGzXt0gjb4IS0+2luI+BX2Y19eWBy6OQ6ZWSSTG527Hqy9sEB1DWx0vW24XitaEb
	YtzdDd2QqnlAcEzFoD7jQB5QdtZJ+Iuynn+z4TsnPIagcpdLm70bNe+6rKMA/MFL5layfdEogM2
	gvJtQ
X-Received: by 2002:a05:6000:26d3:b0:481:5b58:c589 with SMTP id ffacd0b85a97d-485870935eamr2874884f8f.10.1788467848463;
        Thu, 03 Sep 2026 13:37:28 -0700 (PDT)
Received: from MacBook-Pro-von-Karl.localdomain (dynamic-2a02-3100-a979-9501-3df6-d7fa-8a5a-06c5.310.pool.telefonica.de. [2a02:3100:a979:9501:3df6:d7fa:8a5a:6c5])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48588394fa1sm1005070f8f.8.2026.09.03.13.37.26
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 03 Sep 2026 13:37:27 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Vlastimil Babka <vbabka@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Kees Cook <kees@kernel.org>,
	"Gustavo A . R . Silva" <gustavoars@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Shuah Khan <shuah@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	linux-hardening@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev
Subject: [PATCH v3 0/5] slab: ZERO_SIZE_PTR alignment and ERR_PTR hardening
Date: Thu,  3 Sep 2026 22:37:15 +0200
Message-Id: <20260903203720.63689-1-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2E67320009
X-Stat-Signature: h5ufsqcsnifh9x7j5kkbfcxjcrtkmxx4
X-Rspam-User: 
X-HE-Tag: 1788467850-128280
X-HE-Meta: U2FsdGVkX19CpF2KOOTEuKgY5NiGVY5GFZzUOE/SPbUIW/gMuRkDomLkyqw2G5FzsnOXjADwR68XlQ+fivwTBF7deeIp8iX7zdNBd/bl+RlAHVSyen/3ES+QwAMRVcQCJmkcP7YOuiMEqa4eWYW8etEHnXs3UZAJPHvz9vAMZ6N9u1NesenpblN6Dn+CCTmolwZud4HZn1epq/qMhJrSdWFVG1JZdtxJJ86vEFRvGmc2T9Y14AAPBa1+sokZAxff/SsNr5uAqTMgiLO+xz+2T6Kmbod+V7REHC1cyZT+XdFE1/phFaoZpbgpUKNG5UI9rBPiXTsFSif+Z59Anp5JrqcowLHTUedKibVcgbVa7uQuilqdWKa9b+RWqHcpaR9TXcStRv3uOz/Oiu6xpNglGlK3taHlg7dO5RQYKb4ZJVZhQ/FNYWC9oPKIEDteHK4lAch/9NsTTq8Vf1BwniwW04LsyCNMDmwbpKOk42pqWLhCZhJNF7y38H9aXTupTKmNjIrSt07WyVqkM6O93orbtQtJldcTbj3ARVn2uMKO7G03nTzEMSjrkFQ3tJvVs8wK2qCq9kPw7YK40j0os4ikH50efPPB0AIY1hli/aBQZqu1Vt7J4YyndGbmBBb/KO4l+BXhtku+YP8+jF6fQBqjuzIiiAoNKatEgX7xXYy1svSa82Ft7YbB9FxQ3k8pXvsB8JO4eeaqxtlCPBBbqTzvQPey7yx0yNNa/p6CN5U/xr3cGphE4yh25DOwDEoMrvSM6T9sE3ky4q8qxZgcZ6YAYd8bl9ckNSMDmP7AVzUwdjFBW1wVDDpqXgRfNlghTj1Y5YcJn9OZUGBJZf9B2YD01G1PHC5z8FT5gGHxlO+i5CZwY0d8JZgLYuH7+h1cmB611kT7OXUAen2dVEcLc+qi0F8X0z/Wk0VXU627nvUze7Ns5flLpxvS9TWxg8Tclr1MmRmgbGFOndF82gGRT1r
 SmR7KZIx
 CUWpfNFjzLTdRMNMYYJwujglTmd5y2gp7U9ck0MI5V4uvYN19Zzx3oIpcUKly42+MLoVce3qOCyz59f9mlT1IdCfD1ejQ6q++fxV6UZ8+Mq1wPlz25m9b8Sm5qqyfItn+ff6+8uQH+e7gIazUNdEhwi+4njMeJBftOghA9K4rmB456k4CsOWw4hUDRO1Ge1S2HBXxdevuZi2OVKIjCCHChTI+5yQfc1YXjUJjJsKllngse8x9AMn+zhFoPS+vjmGFaepBo087btLSIGnf+AejHQ2YhFeDEiAd9+7iBji4hTeOSjKFh1/MXsGDOul+wkfHFrg20uEc3x+RlqEF7oFNNksYxPirGABF/DXNllmwMeCLHgbfoP0O7FjbyEW0OFAanIoIYql1CKlzTXNK7arSbOeIJCrRgrQ07V6ucRe3ZftQr9zPEMhxzPsqXaGKJBjQRwFHGgsRHET57nc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The kmalloc entry points promise ARCH_KMALLOC_MINALIGN alignment but
return (void *)16 for zero-size requests. Patch 1 aligns the sentinel
to that promise.

Patch 2 limits ZERO_OR_NULL_PTR() to NULL and ZERO_SIZE_PTR. Patch 3
handles ERR_PTR explicitly in kfree() and hardened usercopy, without
giving ERR_PTR special meaning to other users such as krealloc(). The
old helper did not match ERR_PTR values either; patch 3 addresses the
adjacent hardening concern raised during review.

If backported, patches 1 and 2 should be taken together.

Patch 4 adds zero-size KUnit coverage; patch 5 adds ERR_PTR KUnit,
LKDTM, and kselftest coverage, which is why Arnd, Greg, Shuah, and
linux-kselftest@vger.kernel.org are newly copied on v3.

Tested on 940de590b839:

  - GCC 15.2 UML slub_test: 10 passed, 2 skipped, including
    test_zero_size_alloc and test_kfree_err_ptr; NULL and ZERO_SIZE_PTR
    produced no warning, and the expected kfree(ERR_PTR) warning was
    suppressed and counted
  - GCC 15.2 matched x86_64 builds immediately before and after patch 3:
    kfree grew by 15 bytes; __check_object_size gained a 13-byte
    comparison on its normal path and a 23-byte cold abort path
  - GCC 15.2 x86_64 defconfig with HARDENED_USERCOPY: build and normal
    QEMU boot passed; the committed LKDTM selftest matched the distinct
    ERR_PTR diagnostic after reaching usercopy_abort()
  - Clang 21.1.8 armv5 UBSAN_ALIGNMENT: no alignment-assumption or
    slab.h report; generated code retains the exact comparison and
    single evaluation
  - GCC 15.2 MIPS64 big-endian noncoherent build passed with
    ARCH_KMALLOC_MINALIGN equal to 128
  - Microchip SAM9X75 hardware (armv5, ARCH_KMALLOC_MINALIGN=32):
    ZERO_SIZE_PTR was 0x20; zero-size allocation, ksize(), and free
    passed with no boot splats
  - Raspberry Pi 400 hardware (arm64, Cortex-A72,
    ARCH_KMALLOC_MINALIGN=8): ZERO_SIZE_PTR remained 0x10; the ERR_PTR
    KUnit and hardened-usercopy rejection paths passed with no boot
    splats; the revised diagnostic was retested under x86_64 QEMU

---
v2 -> v3:

  - document why patch 2's sentinel-derived low-address window in hardened
    usercopy was incidental
  - add new patch 3 to warn and return when kfree() receives an ERR_PTR
    and reject ERR_PTR values in hardened usercopy
  - replace patch 4's pointer-cast static assertion with a run-time KUnit
    expectation
  - add new patch 5 with KUnit and LKDTM coverage for patch 3

v2: https://lore.kernel.org/r/20260811141240.62519-1-kmehltretter@gmail.com
v1: https://lore.kernel.org/r/20260808105622.62026-1-kmehltretter@gmail.com
RFC: https://lore.kernel.org/r/20260712120728.96628-1-kmehltretter@gmail.com

Karl Mehltretter (5):
  slab: align ZERO_SIZE_PTR to ARCH_KMALLOC_MINALIGN
  slab: check for ZERO_SIZE_PTR by exact match
  slab: handle ERR_PTR values in kfree and hardened usercopy
  slab: test zero-size allocations in slub_kunit
  slab: test ERR_PTR handling in kfree and hardened usercopy

 drivers/misc/lkdtm/usercopy.c           | 27 +++++++++++
 include/linux/slab.h                    | 20 ++++++--
 lib/tests/slub_kunit.c                  | 61 +++++++++++++++++++++++++
 mm/slub.c                               |  3 ++
 mm/usercopy.c                           |  3 ++
 tools/testing/selftests/lkdtm/tests.txt |  1 +
 6 files changed, 112 insertions(+), 3 deletions(-)


base-commit: 940de590b839f71d6dc846160534bf202401b8b7
-- 
2.53.0

