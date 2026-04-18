Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B209F99C8C
	for <linux-mm@archiver.kernel.org>; Sat, 18 Apr 2026 16:34:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 28DCE6B02C8; Sat, 18 Apr 2026 12:34:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23DE86B02C9; Sat, 18 Apr 2026 12:34:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12DD26B02CB; Sat, 18 Apr 2026 12:34:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0077F6B02C8
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 12:34:11 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A0A3313B341
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 16:34:11 +0000 (UTC)
X-FDA: 84672223902.29.E6D624C
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	by imf18.hostedemail.com (Postfix) with ESMTP id DBC181C0002
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 16:34:09 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ojC9nNRN;
	spf=pass (imf18.hostedemail.com: domain of luca.boccassi@gmail.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=luca.boccassi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776530050;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=I2DVRbVNhVeR4amNlP7a8lBCjg5uU0/n/18hy85E+D8=;
	b=61u05zwOZKpOMdMAfO4qqVRiUFIoUl/rR1jFyv6QAipVzexOxn28ic4Lmup3QN+WHgzEJs
	nLmDKLnH7wFwgLzylVCqDZ+f0RsTTgCS2Nh/vdKhxS7dCsqwP1s0knitMfhK2VGVx8CKVH
	1d6EeQ/DIbThlERuQLEi7PmuNaF2Vl0=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ojC9nNRN;
	spf=pass (imf18.hostedemail.com: domain of luca.boccassi@gmail.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=luca.boccassi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776530050; a=rsa-sha256;
	cv=none;
	b=lNy1eegH2aQDqGYgDeRLAku/69d/mwbiLBaq5E9a453wvk7aWjXVZRHiIljZlBHllA+fDZ
	46Jn3skXkzQgoj7DvGtoCr3xPLRNiZh3t8/LdPcqw92rh48pXfVNGA+pEqzhaB9dsgw6EF
	lO3AvgfZ10DSGxC0T3VSTQSRuInRMiI=
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-43d572f7437so1107854f8f.1
        for <linux-mm@kvack.org>; Sat, 18 Apr 2026 09:34:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776530048; x=1777134848; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=I2DVRbVNhVeR4amNlP7a8lBCjg5uU0/n/18hy85E+D8=;
        b=ojC9nNRNP/S6qo5GVIwQru9tg/yu9bHkUy19qGIHTwZh8F9Kuee9hWvUe0CfjLGsgt
         5FF+BFNSNkMVHLWTdVJEEJlKrulP+ZijfcA/ES7pj7igCtftRKuylwHbgLlLxMq/sS9Q
         ViSDa1vlQ5ALfFJom6qgeyWKa3dzYxoCjJqayZuvB3erayc2snoRsR4IUsMmQIvJMx1u
         vAsXUPCJYEE9VeQF8ZJaz5C2GZOrNh68HUlzQdLvUCfwTiy6l5AW4zvQPI71TdsValQ3
         OaNfY8TtAbLCWUBWmQ5rKxdVjkUkcoAXr0oXmJCFgcsbM//4XvvNFADj7eOrn/8bU7gz
         7OjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776530048; x=1777134848;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I2DVRbVNhVeR4amNlP7a8lBCjg5uU0/n/18hy85E+D8=;
        b=kfW7mhbzGGfBT0YHkg8DY4d+xUdm8waH5uApIk9aabKIqZfZZWMsPSfpyMBUqupiI6
         Xr5qH4eAKQbVRjDXHifziadz8hoM8HZQPn5AuKew2DCNm1/izQRcXT/KHeTVWCFURu5s
         sBq4S91SjrgCkqcoQA6pwolME3ajhF1EmEvcHxlxcvGYR+qpNq3RRLh1j6Ij//92W8yx
         9VC7XJ5QRXnTBMD36jfX9EojE+nn9M4Fnp1liOiTEqDMAKEEbxjwzYRiLcFvXxFw+MMk
         Qdf3RgL4ey6qhtrWyeFfJPAFN+OVEvBsc/fHFZi/LHOB3xZmFym19h8UusCqrCoWx+u5
         opTQ==
X-Gm-Message-State: AOJu0YxMR3hHx/jN8wRRMLuN/lWfo8/ZJ6GwE7Em3/HdJZ13exVKTGti
	3VJ+Iom3aAESs++RZl+gRiuGeobp0fzMOhTuC5q8HCl5vSAT945eQ1lL
X-Gm-Gg: AeBDiesKHP1d1hhH6L8GnJh62Jml6Zkg/zq/yaM/Hs7l8x3wyiC166vXpy6iUbOxJuE
	QP8JjZRpCo/uaiGAwZjr9HRFXDNpkOFIoB8+LnMMgburJ2xkyTyOMkSoVuCpbwJPbwI+NXer7CF
	zEiU5kKB3hXenEKZH3fBkZzw3JFKVLwKZ0fj62BYD/L5b3gxRYsu0+fQ6yUdgHNa2xFPeYgl+W0
	iqBRreRwlOxjbJGsyY31Z3uRlBjAM57RjqSFme/OAQ7ZVW7ClsT/6oVZV6KYyXrsseTjxEgcPPz
	Imz3Wj4lpMR9y3CZhOWrwOobDrbtK5ak7YQn/Ka4yTWTiBgumTqyK6fQkCpLsP+c0Pig7VSrDq8
	KwxSsO7BtL46UKCvN4kGvpr/p43GY5C1Izcxwg8gwLmZSpSbVEWfwJdeQpDIWRuC4lmj0XA1P5q
	2YwzltrvyK57TFhnsK1XHozjbFMpqTqebzW73bpT02hWnSjg43/g==
X-Received: by 2002:a05:6000:24c3:b0:43d:7868:21db with SMTP id ffacd0b85a97d-43fe3dcc11amr11095356f8f.18.1776530047970;
        Sat, 18 Apr 2026 09:34:07 -0700 (PDT)
Received: from localhost ([2a01:4b00:d036:ae00:e054:93f2:97bf:84c6])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-43fe4e3a79esm16403029f8f.17.2026.04.18.09.34.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Apr 2026 09:34:07 -0700 (PDT)
From: luca.boccassi@gmail.com
To: kexec@lists.infradead.org
Cc: linux-mm@kvack.org,
	graf@amazon.com,
	rppt@kernel.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	brauner@kernel.org,
	linux-kernel@vger.kernel.org,
	Luca Boccassi <luca.boccassi@gmail.com>
Subject: [PATCH v8 0/6] liveupdate: new ioctl, change session inode type, bug fixes
Date: Sat, 18 Apr 2026 17:28:17 +0100
Message-ID: <20260418163358.2304490-1-luca.boccassi@gmail.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: DBC181C0002
X-Stat-Signature: ohbrtjoq8qjdmzh34mf6idi4ydbqxycj
X-Rspam-User: 
X-HE-Tag: 1776530049-819956
X-HE-Meta: U2FsdGVkX18slPZHMGTzt9UPs48sA8qSilMz26BeYzORcf0LcJn9fbgFES+9JX2kRICQnxEHhg7Rl64BAgcPU9PTbgJKmN+NV/SNbZzBS6DIjRRu82m+4huwZoGuX6KqzOr8Mq8CZQ+x0HZCD3IMJPrah8AE4Jjdthsh3hsdMKxVhsa4nkVHeE5wsAfGALqxzZyAW76FYj64WNSD8Q6aFmK8TZ8iY7DdWfYn+vJNbGuHgVIVjcfb6u/MQeKwxOEjFk3J77sHn1uCqZa4gMPtnvsjAinqfCYEpZh4yKMppMl7hkUn6+POpstfjxHYUj9hgrxGYSfebmvqIxMZPDUIOeSBqKEnZqLtVyCJL5yTfEnNEbSLq3rAiJLQHw2Hj/nIAiPVVJg9FV0E0MJXvL9Iewt+XzWWfN4zvq+NJpp69asAbBAuRcrDM53FJm077c82pYcdRhhfY3nKAgNqYwwTNOCL6aR2m4cwb/e3WOHiI/wp7s+gw74FNbs7TNaVolq7/Jt6it3L6+qOFm1b1jJ3N6AlHHG8Y0j9Yr2kV2d+PJJX0cnjfKA7CU4MsC/PlS7vHsSCg7ZQ4m2dy+GR52AvGVdlGCXfWrfoRxx8gciHraM2ZlwOwG3B+QHrfeeBQP+7xQu6kpEV4rVW1iJMnRcp/GPAHwsU0+0OPU384PxYAkxFSpDaFYwfyxYLjbYfqC8KIHwVDVewcVBNaZ1PAjJBOH6fdhiWC3zJO0NYXF/dy+H/JHQNxB9HQb0GyxFJ9IRfSpiQBbQjhaVquYbULeGwwwWTBuxssEy/r9ohpP9GOoyc6/K1f99wB8fmyMmBEcPBGV2CrfS52BBUNHdmoEKAmfn5kRdNt3q5D2bVy+5Gp6m/SkIvNyCynXv1Hto1S09Kb/rMgBgFONfzhKVvOAy5dHA2V4nQHZwT3NLMUtXuERP2fsZnGoZvrM0uyQETVD+HwG1x98rF6CzmtnNnlpH
 mvWrRXHL
 /r6+sc8L24Ad0/fC3mWBSTvvvz/ixQQjB5ddmAEalgWHuFFzp0C8GDGkgxe7zWuVXVzI023wXtLhIUUFBqsI2uD7pHizxoe1uBfPRECLrhDZ467U3txjLsU45DCgV94PFIKqqf5rlQUn1if7au4REDfayX/SrTtKET1EXlQKuw5ynjTqPwvbsXLhj6yhNdPFzkBamRS1B+Dva1koFB90E5i8KwQq0zBBK4umhZ7zPMask9uUClNg5HAX/0xPXA7EyH8mwylwCTNdUFFoMmOLpzk0vK5p1I2YX0buWy4sKrs5NOaCkor/FPAurVxfCNYBIlXG7Zo1wv83nBxdGnaRYUdplgSANpyvob739dBt55VbpLpn/wm5a4Un1x2gPwl2SjTzdiwBOB+z+S+y2Q6yNoL+ELBuk8236hBuLQGLllJJw7SvQyQOpdEquG44sed8kllqPy+1E9AlEIrdXlPyKD96H6sibMJxkAtI0Dp2j9X3PwmY4KGGkf8++nQ2UTWfu0XhIfyxQx7ABviEU/uQh79Kd31bUqZvNZPxmyBDiTIYTUqJJFOAINOFsoMYXFpby898aoEBpFdf746M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Luca Boccassi <luca.boccassi@gmail.com>

A series of patches matured while implementing LUO support in userspace
in systemd.

- reject session names that are either empty strings or too long
- change inode type of session FDs to a new singleton magic number,
  so that userspace can immediately identify them without string
  parsing in procfs
- add new ioctl to retrieve session name from FD, so that userspace
  can query it without string parsing in procfs

All changes come with a follow-up patch add test coverage via the
existing selftest.

v2: apply one fix from bot review about cleanup on error path:
    https://sashiko.dev/#/patchset/20260415184536.1155220-1-luca.boccassi%40gmail.com
    the other comments are invalid: luo is not a kmod, and the write hooks are not set up
v3: add test case to liveupdate selftest
v4: split test case in separate follow-up patch
v5: add r-b tag, merge series with LIVEUPDATE_SESSION_GET_NAME ioctl
    as they both change the same unit test source file, to avoid merge conflicts
    add '__u32 reserved' to the UAPI struct
v6: add more test cases as suggested
    more verbose commit message
    fix docstring
v7: apply suggestion from review bot to stub out setattr ops,
    like it was done in 22bdf3d6581a
v8: add new patches to reject session names that are empty or too long

Luca Boccassi (6):
  liveupdate: reject LIVEUPDATE_IOCTL_CREATE_SESSION with invalid name
    length
  selftests/liveupdate: add test cases for
    LIVEUPDATE_IOCTL_CREATE_SESSION calls with invalid length
  liveupdate: add LUO_SESSION_MAGIC magic inode type
  selftests/liveupdate: add test case for LUO_SESSION_MAGIC
  liveupdate: add LIVEUPDATE_SESSION_GET_NAME ioctl
  selftests/liveupdate: add test cases for LIVEUPDATE_SESSION_GET_NAME

 include/uapi/linux/liveupdate.h               |  21 +++
 include/uapi/linux/magic.h                    |   1 +
 kernel/liveupdate/luo_core.c                  |  10 +-
 kernel/liveupdate/luo_internal.h              |   2 +
 kernel/liveupdate/luo_session.c               | 106 +++++++++++-
 .../testing/selftests/liveupdate/liveupdate.c | 153 ++++++++++++++++++
 6 files changed, 287 insertions(+), 6 deletions(-)

-- 
2.47.3


