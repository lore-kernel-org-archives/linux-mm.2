Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8FA3CA0ED1
	for <linux-mm@archiver.kernel.org>; Sat, 16 Aug 2025 01:40:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8AEC08E022F; Fri, 15 Aug 2025 21:40:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 866F48E0008; Fri, 15 Aug 2025 21:40:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 79CB88E022F; Fri, 15 Aug 2025 21:40:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 65B028E0008
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 21:40:49 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 138381A0322
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 01:40:49 +0000 (UTC)
X-FDA: 83780916618.16.0282D51
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	by imf02.hostedemail.com (Postfix) with ESMTP id 500828000C
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 01:40:47 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cwgjQCdz;
	spf=pass (imf02.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755308447;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=paq/IdzHGLOy+RGY7FtKr+S2+lm7qcZDiB17Sluzsd0=;
	b=b2MeJGPLoZTaYnP5G0MKWXMOIuCq/bLz2F7WEZLhRsTS7HuLH9bGVF4cE2ZVZ6eRlyA86W
	8cTuQU/k5+R5pILg29Kt+va3yikeBfVH8CHDalU/QgNIXEnoMaJf/giFVT4mMhggv+V0sr
	3jcM8v+zAzopfQ0yTHuiaDd06R2R83g=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cwgjQCdz;
	spf=pass (imf02.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755308447; a=rsa-sha256;
	cv=none;
	b=v0cx0odWi6yZ2dwZMZlGXgmAUNVK2dssYL+qZYuuB9BNfYjzmEZOD0XmhCWLJbPtU9jlqo
	TCm4LMS2grxS+GZ0NJy5kt1t7Q1EIk+kyxCUuowM6bMcEw+pf1j6yWg5ApMHFNP+3D9iEr
	Rq34iDuc7t0EKHSS+0HQl0dMdQYbUFM=
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-323267b7dfcso2574803a91.1
        for <linux-mm@kvack.org>; Fri, 15 Aug 2025 18:40:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755308446; x=1755913246; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=paq/IdzHGLOy+RGY7FtKr+S2+lm7qcZDiB17Sluzsd0=;
        b=cwgjQCdzbRPBsy2f9xbMBViINE2kyhV4BTP/0lSL7tcAVq9bepZziGeS92h49Q9/0k
         LsKufG9Ek+kbq5xywmXmUzRC8sN/7GtXHvGWBecakb5nqef1JpXQZSweC+dcO1BhAuXF
         r7nbo6bGUVxbaqtqDqMfmVi612fEfIgC/BLj2GJH8XQ4s217GfH86pxZo5ESWPwlLbes
         YCk4canWH7QCKCrT3XxyJglkzXhYPBfQ/pMw0ZIx/WAXibZF7JKeMNCWfESkGWXFS4jS
         H3UoWKqqTlnkdvx30TMMl2XGK7/u1xVe92S8pQ6p6Qg9P1003NG5JO9C6pc//utqxAY2
         zrFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755308446; x=1755913246;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=paq/IdzHGLOy+RGY7FtKr+S2+lm7qcZDiB17Sluzsd0=;
        b=C+BPPIDn70Z1VM2IH113BEtEJVAK7/GhF6RTVCdvIZhRtbv0rzBqt8yM8zRYweMVWo
         cqxCIompzxELSwL6klleG3ti596eCv88wvO4YIzUUKkJ2rNqx1r4bd6mGvwywR36ToeZ
         eL6io+zFhH7ZeWBuP9X7RNpkv8JUw1HO6N2pwMIulqraqpfMVUnFjE/DHZccDqxVgTyW
         PeNkQSw6TMBHNs3TwsuMVvuqNK+E7uJ2C+sQsMzRael5Arc47VzVbuEuhM58lXhxHYBh
         ju/HyCds21AJ9vriQWeZRT8n1cB28RJfStBuaxfWnxShm7hlLNcGWsjPI8a5IAbh2gG9
         5aag==
X-Forwarded-Encrypted: i=1; AJvYcCWyoehsE09NAHKS3SwlSyTjQaH9DYJkU4BCRPeq7VfojYLRjN/1hQM4Zu032vYO/B1QJTaQnDj/vg==@kvack.org
X-Gm-Message-State: AOJu0YwJSkzmpVPNOsM4ecqXpTjazWQ2wH+8hV2DwK3bDV1J9BJVuxLO
	uASCu7wH4Y8e2EijgqwjLNB3brNGwX1G8/g+nS6aDYT2Ta4jO0ELx7RdlhVKDofQ
X-Gm-Gg: ASbGncteQm/bYkBFwSrGuFHiTmy8vBBX8y/1K3dhq94buH60Xxgi65T+FfNVU5TZofb
	i8vTcyqjger8yLVZch+kRkV7JqC9CuZBoVQs+zG4emh4SRN+fUUhQOlzoPyHj022Stw2+VUlmFZ
	dFwjQ4cS3cZw7TWseCuikDroz1WXby+iE48O+7AynrB/d/zOopPKfT7OWT5qz5Wedt4b+SdXQbC
	AsbQZIXrCHiQ13aL9NxYj5Zu1pUYDAhoXSrkgP5pVhw8mmhiUpiWSBDf58sc7H1S8O/gmDIelk1
	UN2+Lvl7/0gX2zqj7BUBQD2B1CKABPS57wy3W0gRuqu6sko+sfTSrdwN3bkVOt1gLTHJ7iBTH++
	b5J7/pu3FsYZvrwn0fC1UhErSB7o=
X-Google-Smtp-Source: AGHT+IEldIYgUTPBqs2QmokMM903macHwQZdSbaxDJzg3Sh/WqP1PBIrJOtUGSrl/jElEKFStjgRtg==
X-Received: by 2002:a17:90a:dfcb:b0:31e:eff1:71a5 with SMTP id 98e67ed59e1d1-3234210439cmr5067770a91.29.1755308446042;
        Fri, 15 Aug 2025 18:40:46 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b472d76f9e0sm2324227a12.44.2025.08.15.18.40.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Aug 2025 18:40:45 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: sj@kernel.org,
	honggyu.kim@sk.com
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	Sang-Heon Jeon <ekffu200098@gmail.com>
Subject: [PATCH v2 mm-unstable] selftests/damon: change wrong json.dump usage to json.dumps
Date: Sat, 16 Aug 2025 10:40:33 +0900
Message-ID: <20250816014033.190451-1-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: md6jh7f354msufe1df9p7spwjsga1h1d
X-Rspam-User: 
X-Rspamd-Queue-Id: 500828000C
X-Rspamd-Server: rspam01
X-HE-Tag: 1755308447-451031
X-HE-Meta: U2FsdGVkX18nGAP8xovtmPAgcp7wCVRAMkHwl7gsDtfjWanSD0cJxElkCUh5uqLKHiJpNJ1R8YMGZV70N4HPmqfbbty97AvkGlS+aLt+guUd8fRDGkzaVoB9/5dMPClchjzlJocpGOF+zPL2P9jnqq0tKsI3a3ss82cgdvNzIj2ycdBp+PSy4oA1BSDvSBjeS+0vqKUtSkd7aSICzoXxMz6zRhL7m2QxYUAcHOli4moXSwrXyTMYDnBbrBnRhrgkSmE0L3HoPOWZT09j3OicxFouW5MIXy1LigT+X3hQhS3Wwgi5DUGDqv8ZgujKwC9hUjctKOc1JNqDfwvQVipQj80YHnQWuAdH+I48VyBqndHk+zY8w2nvZx5FZ9bAgc1LI6It0QUhNqIvWYg2vK4KTJCI6GbF1WP2qZnfW/9YCy1YQlG0eLymQpSGOAZUCxsfysaubpwrs1Gq56mhPp8KRzSzW7TMJBjx+l6oVhvg1ou1Q2LOe0mn2nvbMtYuAKMkgwl/xaL5iS3StMfz6Gvw2n0UHXhrPE/gG/tdIc6JlxyRp8+PazhAckaCURjtDCOs1oKD3/qEgHjONxLObTUQUOF5W/bGtD7IXupQ2bjQVXa2wBhqMzWHGEKBz/LdlVXXSAN5kAUG9vdWhooNX6WWiGEHh3kF7mhh2g+lE8x6C+3MYhIwrqT4b4Pbkl2VDRZWq/aU+ZlMJLqQDb6S15s7+WkO/JQ1ZYKkzg+e688WUUMmnRRUDSj3IySUTGMPYzbRF322d8VORnoVB73M5B7PBLcztitlt5mzfVefxB6BSiVfc3v9/b7R5SSCXM8+zuuvWdmG5nIZH/dnTaKpxIffIigr21NqP8FJ5T0cCMg1VafDgr4IgzY5hJM7EP+FWQ8F9ZKrRNLaMvPmzzKNxPZ0GMoKeottI86AiC8tczfFyZl5KIV413e6YJgIJkVaOkj2j6cLp/x8bOL73dSSPhu
 EqMW4P0v
 jGE5iDbqa/NGotrPKshdUd8tMud3rq5Rs7eAOtiRaVyHNU4B0ISJQzJneLh6ZzZnJXhyjklIwaXDvIpjRFp+qKwxrW3k6ctqrCfMWguUdTer7fWgOyUIFr4158YzruD7d3HrFU4TQn22KJ/P8olDJ851x3XccAWGgG0Kh8+AKpL9jS8tkke++KD6kRxRyUJqSIMfGxAHwYYdYk5rJ8/oOgWqXBMd8n5G2LcONJEJeUA3FAEDivOLxuQYtpl2ukuNex3CiyJ1QXqd7SGPjFgN59m7hH3tbZ+c6LkRvRF3UaXv055wVW+V2IOdQLgktNDXQbMjJYzQ1SB2gHPalpcZxXQeylaDZSD6l6S9/xf2FPU2VDHCCc9qHN1rHFRwMbyxY0yh+kTSwGqzPE5wLmv9EJpD627GtYHkkwffTYOkV9TTw6a070Q/W+drjkA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

To print drgn status to stdout json.dumps should be used without
json.dump. Change incorrect function call by typo.

Fixes: 441f487d6ebf ("selftests/damon: test no-op commit broke DAMON status") # mm-unstable
Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
---
Changes from v1 [1]:
- Change patch subject with DAMON convention 
- Add branch hint to fixes section

[1] https://lore.kernel.org/damon/20250815094029.133063-1-ekffu200098@gmail.com/

---
 tools/testing/selftests/damon/sysfs_no_op_commit_break.py | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/damon/sysfs_no_op_commit_break.py b/tools/testing/selftests/damon/sysfs_no_op_commit_break.py
index f557587ebc81..2c65cffe6b54 100755
--- a/tools/testing/selftests/damon/sysfs_no_op_commit_break.py
+++ b/tools/testing/selftests/damon/sysfs_no_op_commit_break.py
@@ -62,8 +62,8 @@ def main():
         exit(1)
 
     if before_commit_status != after_commit_status:
-        print(f'before: {json.dump(before_commit_status, indent=2)}')
-        print(f'after: {json.dump(after_commit_status, indent=2)}')
+        print(f'before: {json.dumps(before_commit_status, indent=2)}')
+        print(f'after: {json.dumps(after_commit_status, indent=2)}')
         exit(1)
 
     kdamonds.stop()
-- 
2.43.0


