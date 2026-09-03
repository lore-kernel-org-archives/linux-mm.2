Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5972C61DD3
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 15:09:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E958A6B008C; Thu,  3 Sep 2026 11:09:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E46BF6B0092; Thu,  3 Sep 2026 11:09:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D365C6B0095; Thu,  3 Sep 2026 11:09:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AFCC96B008C
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 11:09:35 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 49C141C2133
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 15:09:35 +0000 (UTC)
X-FDA: 85172785110.20.77E51F0
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	by imf27.hostedemail.com (Postfix) with ESMTP id 6BC5240006
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 15:09:33 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ar4Eb96N;
	spf=pass (imf27.hostedemail.com: domain of zhangbo0325@gmail.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=zhangbo0325@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788448173;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WLq5Ho22bmD7v6KZE3c4vo4tWl6YYYaL+ylKWHH1z3U=;
	b=uUrppoph3Azj+YbOCphm++FwyzeRMACt2cuveET4/pq7p8UbrhozB+2K8/b23VVRj5uh39
	acwOQxseXrwrMaDvPMd4KgbmmjkajsoUlso82kODLJryRs6OJcjf6x1TajiqQ8QlAnTI1t
	96TvTqXDXt8ntz/cNWAOCfsQhI64XwE=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ar4Eb96N;
	spf=pass (imf27.hostedemail.com: domain of zhangbo0325@gmail.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=zhangbo0325@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788448173;
	b=0lbvQG6NUSCGTp/IMZ4rlG7yoy+6AVVYyWSVxqK2cDiAK8/t3ORtl7dGF6mKIDV0wz8P3W
	h1iUhunh4cc3MD7rC6ARPrD+S9V4L7injk7rjUwiVLuolZSNWKUa38q7QT9cIg22izpSDB
	YPWY5mQS7NsgOhDGOsRUUmOqc3Ga+ek=
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-84864086bfeso2409200b3a.1
        for <linux-mm@kvack.org>; Thu, 03 Sep 2026 08:09:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788448172; x=1789052972; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WLq5Ho22bmD7v6KZE3c4vo4tWl6YYYaL+ylKWHH1z3U=;
        b=ar4Eb96N8l9xLDqN2AdFM5Ryv7wWam5kDeDxVa0FNEwclQzlPd+VXM3PWLGGgUfJe6
         bap4vznp1RvOMoHeDdFsUr5+/fZSLZfL3aBS22MvRBvF8M4rOiW+00Lt7rZ1e5XhcR1G
         q9qDN3kAUY4D3u0aqfgnWctvzgoTtjU/F/ThzX1N+Upwj9ogYRQDULC6kdDyOgbid5bN
         BXmhngY1M/xYJ5tUsfiXmc4J5fRa1sXYtEVXklQepQ5A9SApg43GGV8V2h/biD8JAbkL
         8Q0+wm8AFxS+2/z6waBJEzfwnUdFi3SPVVejhkAtOIRrdTRaByKBmNavuX6oDQeHN/ix
         tcMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788448172; x=1789052972;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=WLq5Ho22bmD7v6KZE3c4vo4tWl6YYYaL+ylKWHH1z3U=;
        b=En94jaf8uZFpuhpL8zHKT9kDgUzuHRZwmJGJloJTa3f6/yNB3rNl47J2EBUuLZAhFM
         kAR5huxoekHhJ7qUhYMijPoD5vIxxR4DcldVITl1AOQHNTLHUqcVECdriWKpT56f4wZZ
         rzmIPwGuoUj0zYwv+CfWbB0catq17g0ehflam9gsptj322YOC3ieqwukD5zJbCwRUPTc
         hSPU8ovdNKvybPGSUrSfowH79rSldVpWb+42I5YHBq9EEwAATFXudsDu7DOFPL0vAB14
         cAMX651fEnU11SFvoehfs4F/UJELZXUBrZDsVBWBj1EiBlO8Q5Vgd9beEFX45bY9BTwp
         3Lag==
X-Forwarded-Encrypted: i=1; AKwUvBzb2CFdNVUU3zLZP0BKX1lLWihgptqUy4OftOi9V6LPXU64xgfF5Fm12RRRWcHbMqKb6/CuhN++Pw==@kvack.org
X-Gm-Message-State: AFuF++nXg5Hc/OrYmPY6B52BnUJ+syb03d13ijodYiez6erszqWccnJb
	7UK42Prh0cHO8vuPMr6/KdrEoPQ4FTsCzaY/GIhJfaALcb9oseuRPo0h
X-Gm-Gg: AYBFou1+kHY2u2/oq7u7gCPO2WzFGCZkQ44xCSDt0f1OeiRRnKCGTtcxlDS97Bbl2Tb
	4uDIF2jogs4gxisJFM+TPh+S7kl1eg0zuy+8nR3gmE8cWWQ3U+3Acb3p/jgDNh4I4wSRGIg+7rc
	aR83FWc0RMvN4y3gUb4hVDtKjfFY62Dd+BJYF0/e6UqJ4dHsUssDYi5WQJxdATAV0AyaoI9qLoU
	CNLEqlC+L2KUCESVWzlV6ZdeI5uzmZ1hyJC3kfqBV9qIJPk95bIQT4e5LRFxJIc4P0CJPgN6ppM
	9nQwCPOMLdXF0qe7v9DE9n26oQZzKFyjwfkUXYkbM3nxrTsUF72YYEqKkCHHe3ooRnlE/sh0eI/
	BH5v7ffJCnV5lKQujXP4C4qV+qvVqplw/09R7tzlaCZTAwGBcExjqDm9k8VuICJ3a5qrjJhM+h8
	YELqqkY9aRTO7iW9Nmgjjc6kwzEmVuIlNvBVrI2wbQ4RPQMdzrZRXldbUsI8oj8NjRnv7Q6gB3U
	3OQgQ==
X-Received: by 2002:a05:6a00:301f:b0:852:355b:2430 with SMTP id d2e1a72fcca58-85ed23e043emr19151323b3a.10.1788448171946;
        Thu, 03 Sep 2026 08:09:31 -0700 (PDT)
Received: from zhangbo56-PC.mioffice.cn ([43.224.245.235])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8614f871fc6sm70289b3a.7.2026.09.03.08.09.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2026 08:09:31 -0700 (PDT)
From: Bo Zhang <zhangbo0325@gmail.com>
X-Google-Original-From: Bo Zhang <zhangbo56@xiaomi.com>
To: akpm@linux-foundation.org,
	vbabka@kernel.org,
	david@kernel.org
Cc: surenb@google.com,
	mhocko@suse.com,
	brendan.jackman@linux.dev,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	ljs@kernel.org,
	liam@infradead.org,
	rppt@kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	kasong@tencent.com,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	zhaonanzhe@xiaomi.com,
	lipengfei28@xiaomi.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 4/4] mm: adjust free_pages to make __zone_watermark_ok() mTHP-aware
Date: Thu,  3 Sep 2026 23:09:17 +0800
Message-Id: <20260903150917.4112784-1-zhangbo56@xiaomi.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260825043833.2659350-5-zhangbo56@xiaomi.com>
References: <20260825043833.2659350-5-zhangbo56@xiaomi.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 5qobqm61aw7ynbytcx3p4b1dhgwgofgc
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 6BC5240006
X-Rspam-User: 
X-HE-Tag: 1788448173-269593
X-HE-Meta: U2FsdGVkX1+xMkfGeQU1WGRuI6LOcq/KOXzeN7YEk6bSS9MFd8JFtuZNlgWUy4YYVPW5qDsBcZubOuhcljyaKOdXk4VdC9CqHKriDEciKL6P48gKw+cSEPPYK43AvGl+/TRsnMlAff97m9sd0yqiCVveuvKsipaGoOA08QFOhxsX9iIBXE31UelI10IdKH+gS3C1ZnL/j43HRkxozyNhKWnjA1ofeF2Aw4FxkhJwuiaS8Y6QHlc2UcG+XM8G2035svL78fNRW2moYH6ZdEIBoecw1EWACndzDWcOjLBQAbBaeAOUH9IkaZf0j54eEGmB5btFxK0vqRY5BzFBQlQgcLwa/Xhc8dVL8pDgOQ0YraQzvJmsHmoJZueTEEd+Yc/k2xHiyqtCSJedJzUEUQzohW2kIeRlt/wdulGmud+xX684qEM0fRUVubw0/cLkYQmW5mSUrTPabpl245unGv5qnqzYQC7+R1NPlO0TcBmGyGbP1mor4GpIDUp8rAuFTQjIyAfDyN4kHbtc2nWeaQ2GAWUdBvn4ivcUtpSIdPhZiI0RVtrCgxi4oeaGS0lohkCYi7JKg09pOIJiuLiQePs1e1eJJ2Ddx6puoU9h6Iy2twrxjbebmcClcH/MCu/HOdjBEOJuDiXikANTOnKpHPxgDBdbo49cV8gRlcbWVyVeubaUxE5LUWcQNQHSAANzTRxpmMIkqV0m3qiQkOKMWieodKGe014qAnH5UFLdt/S3UsNdStr5kttDASMg00m9hRNFb1hr3eIS/AMih0wDY/7qFS9zAn91KQ0rDkNjrY8hopQ1pRt6oxw8RLLkzIgSzj8XhEi9lfBO1Mfr/1Wcqc932dR8vtsmpE6Xxb4SQf+i+Q3CT/vOCj7uP+KZ+98/U21VFnu/khvKIVU8dHAKZ02rlVKJmel4pUK2jRHr63PMXnKvqt/Sy19yhvoXxqBEu+Qb7MnQr6NIsC0CU+eMFWX
 oGTbSkO4
 9vfQzFbOI+g6HJ1P+FIHIyZuNxmMWcymOgxc8N4XrK+KsU7JhkJNmZxz/NSIIUYln1SDpJxoEA0akCqy4ooY6wEzmZpawfnf6/JTR0KHe8WtwVR5CkypYJUpDZhA9c2Ri3vLgbCDd4DUtNArbb3scCKtuKEKcXEcEW3ow0nzGuFxGc5dqm2q80dOGVy3I+YVt0YlIwaP6Uqzsl9IFMI0fVdWxLyS+BnmjoNs2IaLqnlV364I4K5Egw2RSF+zMsBnczBfwKaaehaNmmd7aDjG2/SV/tw0Q7NyBAwHyYHL8Cr6xONracYsCuQBs1C0tpectEer9YcgL7ZWfE/tCjK5Q6i6LIpipj2RMsOy4a/p4FzdKo2oNLmwthvGdxHXobMqkhNnicNLjxrIPEI0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thanks for the review. (The "defrag_mode & order" bitwise bug was already
covered in the reply to Xueyuan Chen; it will use "&&" in v2.) Replying to
the other two points below.

1) mTHP count discarded by the percpu_drift_mark fallback

Sashiko says

"The restricted mTHP free_pages count is being compared against
zone->percpu_drift_mark, which is tuned for the total number of free pages
... won't this condition almost always evaluate to true under memory
pressure? If so, it would unconditionally overwrite free_pages with the
snapshot of NR_FREE_PAGES, bypassing the new mTHP logic entirely."

Right. percpu_drift_mark is calibrated against total free pages. Under
fragmentation or memory pressure - exactly when pgdat_balanced() matters -
the >= mTHP-order free blocks shrink relative to total free pages, so the
mTHP subset drops below percpu_drift_mark and the snapshot overwrites it,
bypassing the mTHP value. In any case the drift correction shouldn't apply
to the mTHP path: it reads free_area directly, which is already exact and
not subject to per-cpu drift.

2) Restricted subset can go negative in __zone_watermark_ok()

Sashiko says

"Since __zone_watermark_unusable_free() includes all order-0 cma and
highatomic pages across the entire zone, subtracting the global unusable
total from the heavily restricted subset can push free_pages negative. This
fails the watermark check permanently and can cause kswapd to spin
endlessly."

The operand mismatch is a pre-existing pattern, not something this patch
introduces: the existing defrag_mode path already feeds a subset
(NR_FREE_PAGES_BLOCKS, only >= pageblock_order) into __zone_watermark_ok()
the same way, and my mTHP subset (>= order-2) is actually a superset of
that, so it's larger and less likely to go negative. Going negative would
require an extreme case - near-zero free blocks of the target order plus a
non-trivial amount of free CMA/highatomic. If the existing order-9 subset
path doesn't need special handling here, the order-2 subset doesn't either,
so I don't plan to change this behavior in the series.

For point 1, the initial free_pages goes through zone_effective_free_pages()
(three paths: blocks / mTHP subset / total), but the percpu_drift snapshot
fallback only has two paths and has no mTHP case, so the mTHP subset falls
into the NR_FREE_PAGES total path and gets overwritten. In v2 I'll make the
snapshot fallback symmetric with zone_effective_free_pages() so the mTHP
path stays consistent (the mTHP count is read directly from free_area and
isn't subject to per-cpu drift anyway). Point 2 is an existing property of
the subset-based watermark check rather than something specific to this
patch. Suggestions welcome if a different overall shape is preferred.

Bo

