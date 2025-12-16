Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36305D5B87C
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 08:00:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 39FFF6B0005; Tue, 16 Dec 2025 03:00:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 34D7E6B0089; Tue, 16 Dec 2025 03:00:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 222556B008A; Tue, 16 Dec 2025 03:00:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0D0636B0005
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 03:00:03 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AB84286941
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 08:00:02 +0000 (UTC)
X-FDA: 84224585844.08.1743808
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	by imf04.hostedemail.com (Postfix) with ESMTP id F00F540006
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 08:00:00 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=iPRLSMDR;
	spf=pass (imf04.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765872001;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=0S6eeG9Z9Rfs160QEFtYhMRflQkKWZSEVe+u5ABGI1Q=;
	b=txkOV51FP/sCn/geLEb3uKUza16zAJNBPop3kNAgpAWY2Em/lUvfagL9mDO8tACR4LyOsb
	1xzH7Jft5LXRklIFjlhxiLHfV//V3zwToXkw885SU9TSOn8p76DH7309QdzdtyzW+U9XK7
	Vda31YbdoTfPPWNGHchBm3UikGQgLt0=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=iPRLSMDR;
	spf=pass (imf04.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765872001; a=rsa-sha256;
	cv=none;
	b=gMaJUjRjGyf+nFJgiKgJPxOokAk9pfDpsHkzA6ltIO/10nYqFnUFoDz9Jjr4gnNO899wvX
	koFO062pDl6UI88nSLckilW7rnVtMrKul7GyjEqL4XYVQ8ZeCuHmX7EyvIKtAJf5cvVuX4
	MOuRcRSLkV4bJh4tdfori2w4ZB9BHJc=
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-6495c4577adso6003364a12.3
        for <linux-mm@kvack.org>; Tue, 16 Dec 2025 00:00:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765871999; x=1766476799; darn=kvack.org;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0S6eeG9Z9Rfs160QEFtYhMRflQkKWZSEVe+u5ABGI1Q=;
        b=iPRLSMDRe/youxha4oLrX//Li1wqoikkEiU0db2a8rZYTo7T9iCUVxYDfrIyDAjdr7
         Sot/HyHUMWTutt2o5wD9k82XqgteftsyjPXtTO1O0C0MxDGgi+2tjyKHg/d+RFtXI+LL
         aaIF62H9GjQrmv5V9GueQWxSqpaFCU97YOo/mlrQ43ZNH2osHpKBO2rC4ILCTEjzV2EY
         MuI/wdLfazl3C5KVPWn25Xi+bDjXPUsnQt8Wg8dfuky+BeauzysyFAHcYqlvRA5XAf32
         w2xUkw0aH3nH29OEaTe/yj/L9/1BM0flh8HC4mGmKw+7R8LB/lbOEwHi3JizDW9R6cgq
         2bsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765871999; x=1766476799;
        h=message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0S6eeG9Z9Rfs160QEFtYhMRflQkKWZSEVe+u5ABGI1Q=;
        b=M7CclBkYnzDdbFPQqhyLiVYQQhFDK0hjnAFEZiSnnSVKdRYE4DOLYO8j9RxJwgIU5C
         0APNuVMW48wRiiaFjEbSRRGp/LRz/RPAzrh2cYNVEmlkNsZP2YcjRPKEc7inFriG7Uav
         kHfKP9jBgyr2Jy4G2rjcPm4PxCSqRSI7BCPXwsvEoKybJynR7YGvbLGZ/8G6/kIfDD0a
         THBR6D8nU5rV9LQfxH7mrn+wD2x3Qt+Sa7T843ed1/NSRjzC+OM3Lw/Gax3ormE1f3d+
         uIWHoxtdBY3f2FKBF6UoI+6YrHN5FNj1PZ/dz2/WZZ+rlQ4Jq4c6Nc4NxCh0DzAGLZID
         +7JA==
X-Gm-Message-State: AOJu0YyVu9OzItgjzkYuzAeh7FmtT5HBaNPHzXor8d16B4Wzb17bvPh5
	BstArFjXUL9ddIydFV6vaJGdCXvdnXCfvYV/Nz8zCRY1V6A0wYLKtZ5t
X-Gm-Gg: AY/fxX6+z5f4A31Q4zdPH9kcUYG7CFTrlpGYznb+6uvLdckUod4oWHFol2g+rCWRc7s
	1KqwuNaXR1WQ38MtULdC3qTHDc/iGAixcOE0J7xVZe20+6MW4y0Cmvuwjkn55qk1T6I3mnaqhIX
	wjZm0qqksd0iy2PDr4tjPPEfZg6AkpqB1PE+CXvUaCWyM4WRd7cfRca9vhWVshwUkYRLiNdPC9/
	I/HB379GqC7W822wT+bFisRUJLvXRito/oCFf/RAvLIHvXcWf2VQKrlf4aX2pmbTh+WeIJtXgCQ
	ownsvWKWYj/dtGK8ikfN7vqgMrCFvzBbZ54N7w4yV1HVIIHkOhQxyk7oX5aIpP8AB/I3DYon58F
	7AlIIwveKXCL4GxI8qCw+wqE8vk2InqpmpMqdmo7JwUsqad4VobclZRQM8ZQf3O5nKyNggSQH0D
	MJX8qZ2+1F5A==
X-Google-Smtp-Source: AGHT+IGjPT8qp4zxoKc0A/ly/cr+zJffWWMkEaEHlbMqXZQp151sW2K9zSd61mRIu2qS5nzE+QSBJw==
X-Received: by 2002:a05:6402:d09:b0:641:2cf3:ec3e with SMTP id 4fb4d7f45d1cf-6499b15789dmr12271555a12.11.1765871999024;
        Mon, 15 Dec 2025 23:59:59 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6498213171fsm15429338a12.30.2025.12.15.23.59.58
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 15 Dec 2025 23:59:58 -0800 (PST)
From: Wei Yang <richard.weiyang@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com
Cc: linux-mm@kvack.org,
	hanchuanhua@oppo.com,
	v-songbaohua@oppo.com,
	Wei Yang <richard.weiyang@gmail.com>
Subject: [PATCH 0/3] mm/memory: align alloc_swap_folio() logic with alloc_anon_folio()
Date: Tue, 16 Dec 2025 07:59:41 +0000
Message-Id: <20251216075943.29593-1-richard.weiyang@gmail.com>
X-Mailer: git-send-email 2.11.0
X-Stat-Signature: hz643fdhzuqkyyj7irec9ude5xmngrzi
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: F00F540006
X-HE-Tag: 1765872000-977064
X-HE-Meta: U2FsdGVkX18c5Ay/6tFejPI/z33fV45C2gBv96wrLsCfv5P+GYu6P/SNn2E7ED7jHIVjNLAOdftpe7RfkUA/GpwsSGSJYS39cBFzWyZEyPLI/GJ7Y4TD4FCZ7dopLm6yEcn8cfBLpK/f0QQ0Ap0b91ZzeFk0aH1MaNpq5Kyj5zJp8ZzcRoi3p9uMD8rQssqdrJsHHiVEQR5Zy0zR3ouRnny1HjCe4uFvdndmEGXvfSgFJN12/8ioSf4Libyojd9RxZ+wCgTILpFsdgPvpkfDyQa2SgFMC/A/NI+7Y+MyT6rS2u3fHfRBI/GQy7IXlk65ohFaMnwghY786NaBl+MLqzTpZT3896/+RTO7S26koHIZE5EHc46Qey0zRlohWgonn2zOKrSSkSvsRr8b83CP3x9fWLQH5TlvfA86Rv+RopbK9GyAPFvawFWz+IJT35xDVVv+aodJoJR0fTyb5wV/NpwAVf/29Q2TrAHeIzH/C+zkefNsoyBCYr3xXlAOU/AKw0N4TjehK8kVaQ1BLAXGAL/0jpqBbs7rmPDDWL9DRn8a1LliNBRJwV1e7QbMVqahVp8UOWsXFI3L/Tna1V8c0uDVFBrmnl+NqMA3U9cBawWbVvGIrlhMESBD01d1yDeg1VyAvNmgISO3i6VKw6y2pnwHlgiTJdNotoKa2VGYjJnZWjO4U5yZ/0ZNqqrzAq4PBUttM5V+iAq7rG0AOuaTI2o/7ZSyZ0be9YW7IcnihHCEoIli83UOpSr8EIpbXL5bKKaSiPF3D/Xh3P/QhA7wpdW+p+dAk6zXJkD9JvX7fawSXk0L0Tkj9ro7aM0AkqvfiFQFIYYw2ZS9BFtEV5gO6qfIvXV6Yuf9sbIIOeLDqXtEOjBZJ/14FD2qcvA2cbZcBxFxaV1QW+y8BPMJ0SaHIkYjd15hoYqJ8J0P6DBtImvX8iCYPGlteRfbwl9/0Ul3YuaTe9kUBfdvtibs+T8
 LahRgx5K
 t256rGRhwnwm3skrlrnarDxg1HqG7AFP/JUxPQAy8TT3U16cdJgE5hamyqCu8akwbt4duKCjLC+k2hVos1u9sTt1yhTi95TPe/XrhgVkXoQrMLoECjo38qUkrd5JOnw2FtQzU4gp2HMpoD2J4CGN2DDxAv/CFBftzJ0lscmAdK6QwqFII+sU15qMGJXwdQfWrMBTUwuzjA4UEnA+uhHqDojxCjMdIf6EDgLnYvzDuPT/DoVJxFKkSIF9c2fOqHfJfFX798bLpLDYvgqQDW+S3LatdQt1FFNWKERjlpEgpHmE2J4lNhsAHG7kKg/GIM6+FyfwOgJbViYkslx5n1HPBKUOmzULN/6G6ppwkg+5++ITxVr7JbbTD/PF+h6Ne8ArK1L4Bz4K6jjhiudbAjhel0r6rXbkVKC81yx1SkVga2b9qVF7s10Fc9fE563Bn6VuHozwqp1cmOt9dkRKloTM+4du993ihqPvJmXVjT7DmQBeUEzm8Tnlw2UtI7y5jMF6iSl/U6RovV3581jZmsv0D29dDy81ZlV03OXAyIL30R3nhm6I=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series cleans up the logic used when swapping in large folios to bring it
in line with the established patterns in alloc_anon_folio().

Context:

When swapping in a large folio, the kernel performs a process similar to
alloc_anon_folio(): it scans the PTE range to determine the highest suitable
order for a large folio and then attempts allocation. However, two key
discrepancies currently exist in alloc_swap_folio():

  1. Improper Fallback: It currently falls back to an order-0 folio if
     pte_offset_map_lock() returns NULL.
  2. Unnecessary Locking: It locks the page table during the initial scanning
     phase.

Improvements:

Based on an analysis of the alloc_anon_folio() implementation, this series
applies the following corrections to the swap-in path:

  1. Bail out on NULL PTE: If pte_offset_map_lock() returns NULL, it indicates
     the page table has changed under us. In this scenario, the operation is
     likely to fail later anyway; continuing the process is inefficient and
     unnecessary.

  2. Lockless Initial Scan: The initial scan only reads PTEs to determine the
     appropriate folio order. Since no modifications are made at this stage,
     and the table is re-verified and locked before the actual write, the
     initial lock is redundant. Removing it reduces lock contention and system
     load.

Wei Yang (2):
  mm: bail out do_swap_page() when no PTE table exist
  mm: avoid unnecessary PTE table lock during initial swap folio scan

 mm/memory.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

-- 
2.34.1


