Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E21F3C83F26
	for <linux-mm@archiver.kernel.org>; Mon, 28 Jul 2025 07:54:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 81EE98E0006; Mon, 28 Jul 2025 03:54:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CF3C8E0001; Mon, 28 Jul 2025 03:54:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BDEE8E0006; Mon, 28 Jul 2025 03:54:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 59A998E0001
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 03:54:08 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 35C7012F9FC
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 07:54:08 +0000 (UTC)
X-FDA: 83712910176.11.9F45B36
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf05.hostedemail.com (Postfix) with ESMTP id 4F0D910000A
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 07:54:06 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FkP+44dz;
	spf=pass (imf05.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753689246;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Cd4AeVUs7V5lSylB8MQ/iKz7vLHt1zDPy5kzMmZDacY=;
	b=zY9baXjeDXggGp6Up4e6hKyzQflEk0ZOvD532EN6dMP7egbTxqWOnGXML3dwQpV5q9epGr
	Z3X3oIleFuzYEvwiWpeSmuMyoo+k4ysq/2Z/+k5bVt2GYBNqqGQFq+Rdkb9jwo7qvo9bWw
	0/sEV5LLV8Fn3q91MFEGbru1POhanKM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753689246; a=rsa-sha256;
	cv=none;
	b=rjynXQqY8XAG9mE4dSJskD86ayNqa2O1IHDOdn4wEKR9xEa2+oLAUgzzZRTEMBEqIZ/IeY
	fPMxvywneOQ4YoYctut/7Q062I7gMvWH+fOhSOyUxcDBXg1+1tdgLV5ZUlGngEdOJHIu/j
	epezZ4cUggje3DLw/Giql3DSYrJCaho=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FkP+44dz;
	spf=pass (imf05.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-236377f00a1so35450385ad.3
        for <linux-mm@kvack.org>; Mon, 28 Jul 2025 00:54:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753689244; x=1754294044; darn=kvack.org;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Cd4AeVUs7V5lSylB8MQ/iKz7vLHt1zDPy5kzMmZDacY=;
        b=FkP+44dz9FKfuAe+MltL5HczVXta6NklFxjw2Eq/F7x8XqDPSrJChRLuSh0m8tlKIP
         uhkXM1Aawqhym/Oj1VVlOrcoqjxXBAhfsVZncaeddEAvFYMtFz+muA4YYHgo1yVJFj6H
         m/NoZ1/xykhF0xuM2VnM9NdhvWvK0OMf5IuUZBaNut88OViQWVxGt9/hXyGjmlitKteH
         4NFXvpaNxq+dis/fZivkC7bLPBuVYSVd3WTvtzV3GDL4uZsshKksIzU0T6obJj+RskUp
         692x39ndJrl/RO2rvdSlGUWUPKeiysoao1gcn1TVbAmNx2XuqEf8x7Cg5sWerF2goYNn
         deIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753689244; x=1754294044;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Cd4AeVUs7V5lSylB8MQ/iKz7vLHt1zDPy5kzMmZDacY=;
        b=X6rfAyjWktTPM/C8bSaqJg2M8xc7Um37P9p1NCdxxiPHCfHTOf1YXJM3gKUh9v+FMq
         TDrZZeXE3oOFyeSCrbouEGJm8GC7lai3motTF34B51TV3mYj6GjiXsGZ/xEd5WqdOcbu
         I3Obz/03LWbX34D6RAdo/YExiYPrRJJxzr41umo66TDc+plaod6L/FrawN2srO52BYP5
         vvbpzpUUQv0cSCml6wwnRnIoRzNUIguxWsGAFtiFUzj4Kn8Qjob9lSrv6M4sZnsvuAy2
         Mry+cGuvl1oOpH3hf8BTLo46P21Hfj1Ahc5gychMuqfvZMI6fEg5kyRHAjScnDYshytK
         JKrA==
X-Gm-Message-State: AOJu0YwUczzRYc79wak732XK5+jzrNI8FbCuKjDoRQBM+yU/ngRu7/aI
	0+6CaT5Di1akH8vDFs4MjtVkeYJvrs4hbmEpC29UTOs85hr9bOYR3B2HvKhi/ZqrLaQ=
X-Gm-Gg: ASbGncs884eYZ5zKL+ylucmZXAVUWwMeixjNrixnxs3CcYsvygjCBrJQqhyzCrNTQir
	skSCTcD1qZv/Th0wJbi95BRFh3UOsxpqF67yY5zcGmRglAEoA7EGERk0g5nyp5TyQkJKFk84yB9
	F69VtIhKmK7L3ZpHOPFciXRj4zRZLuzkq8FSSbqtnvyJAZFzUanIo1uXlS53qR7EYcqfguEycyJ
	VCnMNNpygLg6+TP/zpX0HnqS7CKS55kfM1/lX9gDA3BrYDP1+699iW5denyPsQCUiYPSV6n0UoY
	4vEdC8qFmtwZ5mVawXm/0TzAoSBB2CYk8v/h/bdwv/jTsJ1NPVWGcTjmPRDHRuS/5iDu0XeyfGg
	dFIIDtXvcCfSDNmNH4DkSpcD+Nu3y/VJcF9Qf
X-Google-Smtp-Source: AGHT+IFb47kHtBhlXu+Lw2+aPCdPOkojIjE0li2wCg433P4HoUD2xs5ePpOf4KNv5nq2hut+xxfISQ==
X-Received: by 2002:a17:903:181:b0:234:d679:72e3 with SMTP id d9443c01a7336-23fb3100766mr169960675ad.42.1753689244060;
        Mon, 28 Jul 2025 00:54:04 -0700 (PDT)
Received: from KASONG-MC4 ([43.132.141.24])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2401866c2a1sm20272305ad.4.2025.07.28.00.54.00
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 28 Jul 2025 00:54:03 -0700 (PDT)
From: Kairui Song <ryncsn@gmail.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Matthew Wilcox <willy@infradead.org>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Chris Li <chrisl@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>,
	linux-kernel@vger.kernel.org,
	Kairui Song <kasong@tencent.com>
Subject: [PATCH v6 8/8] mm/shmem, swap: fix major fault counting
Date: Mon, 28 Jul 2025 15:53:06 +0800
Message-ID: <20250728075306.12704-9-ryncsn@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250728075306.12704-1-ryncsn@gmail.com>
References: <20250728075306.12704-1-ryncsn@gmail.com>
Reply-To: Kairui Song <kasong@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 4F0D910000A
X-Stat-Signature: ojt4bq7z6q7jrfghrreuxd15wo6odahh
X-Rspam-User: 
X-HE-Tag: 1753689246-140395
X-HE-Meta: U2FsdGVkX18cONY3UpxMwMzGBXv0MQqFZgN4GzgoK9Q3B4y5bkrg8YE3JweJDUQnKPMesdu6MLhEL39X694upfSh/I5BNpfNGC6EGfSuHarBbEkZsUhPe4hYxAu7yquyOWGX8HJG556FZKe8YMfryLAXwhnVsF+T7Ilon4j6UmDzF6ISP+d//eNfktVMK6wBX/d9DeLDjnZ06P9VZdtqfp2c378SlDXAOJZfE3PyWt/fv4e8V5B4Lo6W/2jyPJXNEONiwOoALFN1NVvUdXycIBmc+XWk/8MbmHOa3DvwIF1zFGI6NE2q4IJjX5+ZDXwOB10lABeYrzRxPhhIU6/vM2gin3oaeLsZpYACCIfxp2fWYc28touhmnyOXC4YnRnWkKJ5S/xM5xkYgJ5aSggJfcQUpZCdZAJ+fy2mesSMSosZ6/mJXBHm/hAFsI5IJd2HMKVCO4fbtdPv4zE8YjM+0mE9CMfRgEUfXunmP4Qw+CLNxAxqnm8IaMU/hV95TmwxIAEcqE8RU809CjS2gcTywNht76vcuLDQ2+TwRNhbNrgYxVumHOSJspj/T0pFJYE7tQPgdZomMX+uaiy0ucppza6W8PmCjCz/CUOsuVAWM/njbQSO/e2QkI9VN+6N+QADZfoAeJzoLJrTkDfCWvsnWbSKeBXmB3z0cAAa5klUDSxv/RTPcONq87oLpj6HQR+qOf3lZ5xC46I9G4akOhyFnWSk903idx4I0UnV2KoPVqOCSvdwv/d7EkPPs3Niql9iVOjkQIt3pNsfdtqWgUAgRCjg4SjXfxOsObwYQsM0ocbj+ZD22ijAQ5a2iNBxgag9FqJJVGuA+R4zRCmrtcs2X6tuLFljy60FI5mDkwyXkh0Fxp40Kdy1JMo4L+Kd95Hr1AINRnu8SVK+wTJdK4DFs6VZ/ONOHngM76bXwqsWhR5u4Wte8qsIbV06iM7hRaWVOyjlxC+bVv2M7lkA0+9
 85sQ9Fbc
 f96zXMcVztoputVY6jfo5WxWY3K1kTD3lbI9u0k9uUDWOJ5mnVVgUQr9irOyjhOlu0ZiNxiv9BQ5ycbB43U6OO4gxQFbtIMEF3DxkfJI+SE7nYRL94HWkObpXQFMX4FhkykSRtEqk7O/k70IuxNXEo8gn/4TSq5vvDvQw3EwnAm5wa1wmL59qqIm3pZjqJnAFP0DPPkQP/XU3QQdPfuV3S9ZaEIYIj4v/r4TWh5MuUKE3rkvN03lRX/joNnmVunQk9fS9YKe0Pqu8WGreqn8vKyspnQF0IY/ICL1dIOf6eY/uwVK9wE3/hk2fgrQNwT5c7nWs+++64RtoXMOa3/Um46cMGm2TJDcJ4IhAj5f93d2ISv4Am8ybmnL2xxZGxOzcqnlVHhW850nXesxTcGV4Q9y25RMTrByRbUm9e8ya1hfwPAZWBu7QaC5DTpCdEVz10xQ5hGSPQmmEuPzhu3uk4mkrZYSMtvpB5QXmAVTKAT16jlznYH5fcfPj86FFcEuZe2w5Jgg+97aeStgFNReyEOeFuwmayncy7ebN0rytKtzTGXwdki+zDYNAarxV+oWGIqdcllRjP0ZdGshkGapyWxedOsJ0gRp45ckPqIgj6eXgkZZhcRFW63txT7UX0xrD6AVo
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

If the swapin failed, don't update the major fault count.  There is a long
existing comment for doing it this way, now with previous cleanups, we can
finally fix it.

Signed-off-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
 mm/shmem.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index aed5da693855..41eb4aa60be5 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2356,13 +2356,6 @@ static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
 	/* Look it up and read it in.. */
 	folio = swap_cache_get_folio(swap, NULL, 0);
 	if (!folio) {
-		/* Or update major stats only when swapin succeeds?? */
-		if (fault_type) {
-			*fault_type |= VM_FAULT_MAJOR;
-			count_vm_event(PGMAJFAULT);
-			count_memcg_event_mm(fault_mm, PGMAJFAULT);
-		}
-
 		if (data_race(si->flags & SWP_SYNCHRONOUS_IO)) {
 			/* Direct swapin skipping swap cache & readahead */
 			folio = shmem_swap_alloc_folio(inode, vma, index,
@@ -2381,6 +2374,11 @@ static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
 				goto failed;
 			}
 		}
+		if (fault_type) {
+			*fault_type |= VM_FAULT_MAJOR;
+			count_vm_event(PGMAJFAULT);
+			count_memcg_event_mm(fault_mm, PGMAJFAULT);
+		}
 	}
 
 	if (order > folio_order(folio)) {
-- 
2.50.1


