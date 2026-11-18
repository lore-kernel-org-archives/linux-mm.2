Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69EF9606A32A
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 23:50:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=AL6DLOR9
Received: by kanga.kvack.org (Postfix)
	id 8466C6B0626; Wed, 18 Nov 2026 18:50:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81EF46B0658; Wed, 18 Nov 2026 18:50:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 75B5A6B065A; Wed, 18 Nov 2026 18:50:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3D5AC6B0626
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 18:50:22 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2E44512090C
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 23:50:20 +0000 (UTC)
X-FDA: 85449886200.18.838FA4C
Received: from mail-ot1-f45.google.com (mail-ot1-f45.google.com [209.85.210.45])
	by imf31.hostedemail.com (Postfix) with ESMTP id 752E520003
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 23:50:18 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=AL6DLOR9;
	spf=pass (imf31.hostedemail.com: domain of evanfengff@gmail.com designates 209.85.210.45 as permitted sender) smtp.mailfrom=evanfengff@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795045818;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=fduH1+3PZ/9MoDFOHCe3dYefomwFptmBxA3+ByWc1yc=;
	b=WELmT2hE/WZFOcOMYnb/YxbobhNefpjnSgOeL1XhTprfso3+SMaPdD2ctIURGicezwdLwf
	eCMlb4SYmtmsfhBTZ3vhaQ8ogv+mXS9HZ29lIiF1IH3LExoiJO6YfFwo6hd2ppqofvhl1G
	cm6E975O1pWsF+Z+ejHT9K1xeoQ29bI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795045818;
	b=uhep97vKOBVFblwfPANhxquo/YkDRDaSsPFnbN4Gc0p6qmqQEfmVSQNbpdT196lhwnI57h
	8/fEkwCLcVhXWjbJ27bqR92ov2JRC60Eupc9I9pHmeN7S5to8dEEz2eC/Kse2zTU9fiHU1
	pYPqOLlpArAr1NWF5ZcFaEYRgAWYaY4=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=AL6DLOR9;
	spf=pass (imf31.hostedemail.com: domain of evanfengff@gmail.com designates 209.85.210.45 as permitted sender) smtp.mailfrom=evanfengff@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ot1-f45.google.com with SMTP id 46e09a7af769-84a248254f4so940128a34.0
        for <linux-mm@kvack.org>; Wed, 18 Nov 2026 15:50:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795045817; x=1795650617; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=fduH1+3PZ/9MoDFOHCe3dYefomwFptmBxA3+ByWc1yc=;
        b=AL6DLOR90YKUJjE71z/pRmj++z3zsaUk4I4JUBglmOKuultc87/JpE4l572tll/FVY
         GXtMtJnzq9QAol1ms/jDMgsKWs1kyeJSOVrJkCikcttXAwCl3n77fOf5yMZjjSYLIwFI
         85OHuKx8dXMjkjWkO8JBtvb3azG1YazxfaZi3UBsJug+C/Tv3mgAqzFczmPyBLy/AszI
         28beVgdf0aUvL53c5MT1hrSfS2rFbLqd53/WdycnqFKthjXHip4b0/zemFzlTvkhtDpo
         z+uqUxw57PoyBPVI5kCKk9gifXSuATDBKHzxBgII9x5OF911XpymmXrQXbjgSRbYAHk1
         WL/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795045817; x=1795650617;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fduH1+3PZ/9MoDFOHCe3dYefomwFptmBxA3+ByWc1yc=;
        b=En5cTGERvkauTVcv+ULegC5mHMDxpFTAGsH63wj5uXfIScVnK578XhM59CN6cKfKkQ
         3h/3GXepNdBoQaSCuRF4tSgzpYFJyCXaBede6a3TRoW0S6Z/ZE/DWgXWVQFieau8rz0G
         lAyYWjWlg3B29qo+5M4/sJtAFiMOlRVJRzfQr/iHqt8DhtYKL4X2tIeH2kdBv378EWOd
         BJyL8Z05SFFvJdn2yE5eZA/QQ7jHYpHItte3/C33np5Z435muYhYRGSvzaJKo6Evc9G6
         y9NaWYZ9SOYL137Nt0+lhNsQQ5yqEtl13jVSYacKX1SEZ+XxXd1bspQKa5qlB36kIQbR
         e2Pw==
X-Forwarded-Encrypted: i=1; AL+hErGB+TugGuyFtBdzRZzIALKxZryuAGqOsBX859Stx09AGYUgcpFamOEMlLNYIDuUY4lGvpyViY4DHQ==@kvack.org
X-Gm-Message-State: APuU4Z9qoWlaVrb/yN1UzjeM1mTZcuf7MCn+EZmuTJQPi23DZnnaCnwm
	UPVyn7v36LsT7WJP9OLY9AUVAyRwQazXhscmrWEfdio0DAh5fH23J8CL
X-Gm-Gg: AYBFou3GEaTb4xhOQqw5wL6rAO3ZrrMRWd3Ko2fI1Dm1lAG1AyfiRFvltBScHospK5J
	qGODDpEQe9ZSt2Acwv7PCOGqxXpNmTCMUH8JLxfeS5S89v+VAGvbeGqBr6FfFEWiM6kg9oQSXlG
	MfVVf54R0xeWOHQo9t2gxVEGYEHUAdrQXvrzeW+ObgEpYqVBMvWL7z4h5LRs5ZifiQ4RLGbvhhy
	FLrrdRy/ABxfGEccH8RcDmL714etgXM+fnJrtbciGYfy4TQM/BzskWXBgRr8ZK7ycbe7waCZdQe
	OPznm8IiFIoxRIpvly8nDnmVqAXiNcIjvRTB8U4qD5UpXZS/Lk68gFpr1HL0A4L+0J+w4Kb69bo
	2lKebzF5FwS06GG6WHqV2ODgX8JLtzE8w7NiZZ06jceYNDihxbL8e+zZRLSd0DHHRKFqNtlhJEu
	c2GKO3jWatsBKcAFKwcDk2JxFn3Ot6bZP0C4r1LKU3rhGjcU9kZ+/KRYkX0lgNAHSuEMkC+TBX0
	pLRn6xx7iEpgqIWFZ1m4DnCVqIDD31ztAbz7l1vUiJEzUevITK9oPcLhFuklWJ8lO5o78e4fhaY
	2lF7xnuoe+4N/g0Xu2mX0zzWtOg5uZYpuchmA6vC0EEcKmoPOLSeCix2klB7o52XVGVXC8z4Ohj
	nz6C1cDsyZVT0GgK+k+A1yrS1oywBbNZ6kTl3KA==
X-Received: by 2002:a05:6830:254a:b0:843:cc20:9d07 with SMTP id 46e09a7af769-862f093b805mr5979128a34.16.1795045817527;
        Wed, 18 Nov 2026 15:50:17 -0800 (PST)
Received: from FKXX2DL94F.bytedance.net ([72.29.204.230])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-862f023a1c7sm3148912a34.23.2026.11.18.15.50.16
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 18 Nov 2026 15:50:17 -0800 (PST)
From: Yifan Feng <evanfengff@gmail.com>
To: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Yifan Feng <evanfengff@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH] mm/damon/core: fix damos_walk() hang with zero watermarks interval
Date: Wed, 18 Nov 2026 15:50:12 -0800
Message-Id: <20261118235012.14859-1-evanfengff@gmail.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: pgpezoesc6o31s9gj8uq8k4yhqdbeskx
X-Rspam-User: 
X-Rspamd-Queue-Id: 752E520003
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1795045818-703708
X-HE-Meta: U2FsdGVkX19Fe8cl4Thw4u1oMhv4Ym6oKmzl4Bdo56anhXb3fPHz96BBUdScgO7zFNQDmY+Fh49+hYd4cFsP8IEeWWIASch/HKNp7H4xPiaAy7Zgs7R7gyIdqbNLbLTy+Vud2XbqsN/eUTZHGfB51BFXKmSXCjlcEmqXn2GUnuAGNg4ATekuM1SqfGIzx47yCHg1zrPt6pTlAL5+ld++X4VSK68a7strZdF/+aSr73/h8ES86nMG4CmKcf5JB6NWL3eAF1eMNzADfXaVxgXgZUMRvNJ9Uz52jRMCvmaMM9+TOg8xBRangzaJ7+9ZTuCi+wFjPqw23LQYMcJdVrSM/mnRSRoM0DwZw51Fdsbd6sDY6IvCdaNzzbuDZLSW9wnMb6XUhJi6GXWd0KTgd+9B3r0/UgzxQVbRjxyDNdFeWWgbQRHlJvb3hSEZg28UlEyb0cUV8GngQMyzGGtEMeQLgpE2N7hYPXQeQv0LNkkek+0FCJeDNTpt21KNouDHJ2T90hPfgOvKpxDIQGhnpEUfWpId5yLZ3t+J5MKr9E+uNdrL5208sn1HcCDzJkpk2tECHGN1TzmB517phwrQL5fNkCEi1bKtTwfIfbcCxMv7LyoEOn2U1YcINMEw1R+jve9DJm3IRCgqGDf5f5O20X/hJgITBneb2ZrCdjRjm0jiNhV5lbfj7BA+Q0DP9Hznd2m9cCMeu+KHkIuHTGXfZtyk60mI80ImREldmUfyjO2sV54jrqd0kPgW3h/XeLIQKWRmEGVuX1ruCgT42CZtVqvjIqjHffejys95ddCVHBYpJZGUjLnsnDnmz7ZB1HoKDkESupOkHkbT+lt4/+R3dkXr8DkYWMQcSteSsYyqdJ2KUrKiXPd9Ff2tVZBBb9RPFtA5l+8lFeTKOkIdUu6zJdTojhaknYxnAm7+7+5DoApvxBefunIKO3GTF3Q8IxdPCV9rdUSLglo9hMM/wFpbrA2
 Sz7gwVQU
 tdUv+ldidp4UdnYq34rrFTZneTRrw3e22rpIQ+eFgtgPytNa3CAL8fU+bPCg43ypE5rBn2K07jRF5y58xLxE95ip4TV7J6DTLSooHwG8ZhkLy+L52ZMno63A48xcA4QrVtY5xK+19o4ZlRgko5J5rQdVX8EU8BihFzw2VO2W6S7mLl66rc09G4z0c01w11iSHPhsG375TEYfaC8jpkMARE8Gf7re5qjJ8V37HS2JtTWeBVGdCl1MDSD9BYhVK8YgQYiFP0esVrZtlZS9+EcJvW9OYNDt0TFusmDYfUguqhRzujhtrXeXGgvL9ZNJrlTBO0M0kZmcDx17DzSPG1SRx9OwwD8asY9RWpOj7KvZ+51GYt7gvHlGFdmckMLP6rsyg87/W6IwI2SmEFq6zO7WXtkYW5dDWof9EWvguL649B+zG/HHKMu9OiFZ3oh0uH/AhOw+nsPGUW9PsqGOvwN3pofcTNk/SbzCRI57BB7kInunh0is=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

kdamond_wait_activation() cancels damos_walk() requests while all
schemes are deactivated by their watermarks.  But it returns without
waiting when the watermarks check interval of a deactivated scheme is
zero, which is the default of the DAMON sysfs interface.  The kdamond
main loop then runs with all schemes deactivated.

In that state, kdamond_apply_schemes() finds no scheme to apply and
returns before it calls damos_walk_complete().  The walk request is
neither completed nor cancelled, so damos_walk() waits until the
watermarks activate a scheme again, possibly forever.

For example, with a scheme that has the free_mem_rate metric, zero
interval_us and a high watermark below the current free memory rate,
writing update_schemes_tried_regions to the kdamond state file never
returns and cannot be killed.  The writer holds damon_sysfs_lock, so all
other DAMON sysfs writes including "off" fail with -EBUSY meanwhile.

Do not skip the deactivated schemes when deciding whether
kdamond_apply_schemes() has something to do.  damon_do_apply_schemes()
still skips them, so no action is applied, and the walk is completed
with no region for them, as it already is when another scheme is
activated.

Fixes: bf0eaba0ff9c ("mm/damon/core: implement damos_walk()")
Cc: <stable@vger.kernel.org> # 6.14.x
Signed-off-by: Yifan Feng <evanfengff@gmail.com>
---
QEMU: the write hangs before, returns after; kunit and 13 selftests pass on both (2 need drgn, not run).
Found and written with the help of an AI coding assistant.

 mm/damon/core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index b8678a53b0a9..12578fc3280c 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3498,11 +3498,11 @@ static noinline_for_stack void kdamond_apply_schemes(struct damon_ctx *c)
 		if (time_before(c->passed_sample_intervals, s->next_apply_sis))
 			continue;
 
+		has_schemes_to_apply = true;
+
 		if (!s->wmarks.activated)
 			continue;
 
-		has_schemes_to_apply = true;
-
 		damos_adjust_quota(c, s);
 	}
 

base-commit: 4405c18c95d2d0f99f6c581ef0ee8591a1aa6ccd
-- 
2.39.3 (Apple Git-146)


