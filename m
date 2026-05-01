Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9648BCD13DE
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 01:37:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AAB426B0088; Thu, 30 Apr 2026 21:37:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5BE36B008A; Thu, 30 Apr 2026 21:37:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94A976B008C; Thu, 30 Apr 2026 21:37:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7B9DC6B0088
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 21:37:42 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 03DC81202AB
	for <linux-mm@kvack.org>; Fri,  1 May 2026 01:37:41 +0000 (UTC)
X-FDA: 84717139164.08.17A66D6
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	by imf16.hostedemail.com (Postfix) with ESMTP id 0E089180008
	for <linux-mm@kvack.org>; Fri,  1 May 2026 01:37:39 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="Sj4/yVMN";
	spf=pass (imf16.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.215.170 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777599460;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=J6ydozng44U75UGI9RXA2frlbGtS6jtczWtr/PXLzzE=;
	b=3e9UN+G6k8SKfTFTNfxZWNta85qytCBJfy9Xim5H8U4w4j/Q4+7ULEm84pYpukCeA70Ul/
	22EUtOXyk7gBADVj6xn7FuU5vJOx7qWljxo8n4+eK75J2Mxyk8ALT8NQ4ki9ZqgmUb8V4P
	64mJqMZenu9jNO/wGlHXFBvUJriQnvg=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="Sj4/yVMN";
	spf=pass (imf16.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.215.170 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777599460; a=rsa-sha256;
	cv=none;
	b=eWRXcJsJhsik/XDdslo7+1pIKbdPSD0bnBvJt+rTYjbbegRGmE91VZl6kWaPj8og3HqpvG
	n7M+usq6LdJa2OAnfs2w+XG5Cdpnk68q0F0ltgG+hJJdk+gsfd17u00s3xLWNR8rddb1QA
	xRHIHLq4SPZTt7d8oUNsBHGT9ISWcVg=
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-c7963df6f17so952128a12.0
        for <linux-mm@kvack.org>; Thu, 30 Apr 2026 18:37:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777599459; x=1778204259; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=J6ydozng44U75UGI9RXA2frlbGtS6jtczWtr/PXLzzE=;
        b=Sj4/yVMNB6nb0LOTpANmwXLDcuzZK03pmfCu1f9xvT7b2x7iDmUQIIppgGmOBicNcu
         /nSQYFngO6t/BgIcmo+AMQm384ga3bZmurd0Iww1RBuQSpj2hBnu6Ur6gi/RJgAhl2dt
         xlqSpoYRVBKtu3yKWvJNWlasrVp3eGLWwYgk41WCZucI6TtemmcsJ7jfMBHJnzwcesR0
         EDVRKIR+A6+jYwTzdNR+KLGSnVfWkuqrrsuoJT0LzSder9/dOXzMjT6eVj8trzemj1Sh
         7nYQoGcKpLQfEK7uas1HUJHJ5ng4L85GDMVfmGPt001RNwWAgApI+pboXfF8rwffx7dP
         nkgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777599459; x=1778204259;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J6ydozng44U75UGI9RXA2frlbGtS6jtczWtr/PXLzzE=;
        b=ZF5anS/jdGSQqSNmo4F2KV5PrhMSYVCSofHNyBVmtjP21uzkU0xqIrwazd7nb9SbV9
         pV9P9pMvKXnf1QaUgpFv314+totpRlNwS70NWlHjFMQZsaJ8d0aKuxxY9cNudkcNuIG5
         +zpTYoJUmYNTjqyVlZz/EFtWB6gVwXFtWrt41AjH0HMXTOvBWRL2wOt305cZan+BFXgv
         cpHfrNjtTQmQtwWmSU8E919TinoG7FyHcZRAI5xm+oIpM96Ice3lLdGO0YCcF5Q3B3LO
         BQO/xEw+VK827uhh+RwpvqJYZZNMa4BgFsIcUx6aTvwDQvc/tI71qFSenRIoevAPvUYV
         JFBw==
X-Forwarded-Encrypted: i=1; AFNElJ/ljD6QEWSdiaOyYIyG+/YqyVXAL/X7/Xm/VbXGG9JHG6swlJSTfY15+iKCM2pnzCkZZpCa3U4XTA==@kvack.org
X-Gm-Message-State: AOJu0YyvwJyM6TydY1x+D/odaht5hRtq3SGXF0nT0gjZk+iMmDa5HI1N
	iPawrwG6NOabJk3S6oTodHuXB9JoAtAKuqyRXjVIUfm+ToZPww2LzDkB
X-Gm-Gg: AeBDiet36k+qXuouei2NcC559alFyuIaqhOWkkcNVov+i4m3qveR8OA87Q5txGXCnti
	m6hB0rMYinuK8tISMT7go9Xn/gNV9IQF6FUvlu9zKapLf8IcHbJLqQVDUlueg7IQD5qCAjVOC4X
	/yl2O8K6bDt6lhlzi9EA1hocEeehouW6n0dZdXrDaIuaq2EHjKEd6Sd6EgwEzbJmxiEnuKc+NsL
	m+6kTN0Oo998Rm55uad+xP9w4ekuC/gyPZr8sLk5/xnJfTDHAj3s3kJSdXRVG+1cYPF2ZE5ppxi
	nFhkglLzDthiSjc/tQ3oVjIvxP4PHfzDePV2JpWkGCjZZO9wL7XgubgIMVe37iT0+hL6TmadLzC
	JbPr199S01O3KklHJuKHqMMpSQr8OUjHT3QYj6D5PlLtDk+jDMofhbTdMVAVUqjvciA7E77TI4N
	6N/Clfw06g9nKRVh0HB+RuJ9zV5DT4MzeIsOAWXs/Xm6oIxvqFFA7Bz0JwE5ne
X-Received: by 2002:a05:6a00:1797:b0:827:3946:a23c with SMTP id d2e1a72fcca58-8351a0a5bf8mr1029293b3a.10.1777599458715;
        Thu, 30 Apr 2026 18:37:38 -0700 (PDT)
Received: from celestia.taila51cc2.ts.net ([2402:1980:8f3:e8d0:1478:fdf:dfb3:daec])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-83515b02935sm956318b3a.41.2026.04.30.18.37.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Apr 2026 18:37:38 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: SeongJae Park <sj@kernel.org>
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	Liew Rui Yan <aethernet65535@gmail.com>
Subject: [PATCH v5 0/2] mm/damon: validate min_region_size to be power of 2
Date: Fri,  1 May 2026 09:37:48 +0800
Message-ID: <20260501013750.71704-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: p1dbakwye57fn8on71c14fykjro5j8kq
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 0E089180008
X-Rspam-User: 
X-HE-Tag: 1777599459-926781
X-HE-Meta: U2FsdGVkX1/70KDSyC+6JtrWZ8AfqYKQiW3kcgug6ue/bHqCmtTwMuS4vp3JIlw84+MrV+uGmzm4+/2x2yH7pdFXGovF9xcu6ha8wg2o+NLhWjeX3n2ciRc6S2CsTmMHxhXyN/KC70uiAoufPJl5ZEiXMjaA8GZUNfVzTK9VkCgpsNYu6biAz+BEut3mVVzOlOSTa0MoQtYon572BfnhfoQrhFGukRXYKxoGVLrXNWyNwYsuiQtx8KLebyqqj83ktczvJiBsVcDWnBPkM1HYZHH01s6A2fvghASQl+ffJiwKyMXD1OuSpM7AMEO4aJbm7J393ireRM4veitlPi0e1DHchuurcoP7ZfWXfBJTgF3bBwA8Cv/e3JOF9JkQqj0dl++Xh08WvL/4MmADlE+cg7ZGY/LXeSEinwo+Ss3Wk9qsKAUb82QC5ap16ACZ3Ns6RCrNXu2aCL7JBjWFiUXJfoK+wbx7Sx22gr1If3eZnF3spMedfAY2CvBTyVFrGTcCkiQXBdaL59NbSFwNkY8kUI1BYa8aUWbAAl4u56qmpU2HJTV4mM/0zEXG2uWWWpeQ1SEhEFsOZ6+3BJtbs+KsLvIKDkMyDhw79bQ4/c+1kVIDIi4hrObfD9WHk1b509ggEY2v86N6tdCT+joAIS44RJQp7jVRsUAxdwpAz5Ezml9APgBOkyo+hRaYIh5DzTtctkF+rIRxaKwbUwPFGvt0eWtO5sX99LywxdfS3vXtnX1tjyzFFCbm42qK7TAFFhscrG6owWToDxDpRAl+NqHweaiBdcUy6GkL5YhOMMstu1r0IEnNETbQW6VfaDvXY0ooaZXZrnOHqTb40xPMNw3ZCacohYPKrqoopHwo9B3ahP/TUmRdwdng8jXkR19DkX4VvYudH/v6E011FrG6zRGjA2qwuMShA7uoNO9i3Smnoum2PWxAMLA3bk9BZTFGiZ4HFQcboZynL18GwELN2Ze
 2eHhz/UI
 xkdCUCeTgWP0/eTgBjxZMil2cIe8kQJEYwppsqyQX19ZjqR+eQrnmA+xHuOOk9gCbn6qKRV9o/nXpUBr0O6bQIErVhP4533iTALdphGzO+q6+IxLXj0qtm3lyGz7IZ/ki2HtjY7+gXzyhRmU4PFPHLrmqB3xiLBgMQFgebWQiW3cBDX6QbjYqb1alGKszERQmqm1Fc4YM1QE7Eghx7rtL65G0lYymy5zS+EnGwgHTuKh3KuJF79if/jxcQ8FLhYo18jde20+hDjQ4J87WJqSQFu7+ktkpepQV8DvVb0EC/Dp3eZ7nJ+CeeO8SaBu5laTLkpTSd84/xpyuYuj/H6adz/chxm15/el0YiKSHAojKWOdEzxviSQnCmnB3BklPBJJf3hA8HTLeYJvWWoJkiUOe6l5WR8pmIPTMbuBxFLS3wMHImCWWhoife566qkfGaBTljUBWDdh3RP/rZM/OjikCz4bMafYQVqDWCr2km4uwshay/s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Problem
=======
When a user sets an invalid 'addr_unit' (e.g., 3) via DAMON_LRU_SORT or
DAMON_RECLAIM, 'min_region_sz' becomes a non-power-of-2 value. While
damon_commit_ctx() correctly detects this and returns -EINVAL, it sets
the 'maybe_corrupted' flag during this process.

This flag causes the running kdamond to terminate. While the termination
is a safety measure, it is suboptimal in this case because the error is
just a simple invalid input from the user, which shouldn't neccessitate
stopping the kdamond.

Solution
========
Add an early validation in damon_lru_sort_apply_parameters() and
damon_reclaim_apply_parameters() to check 'min_region_sz' before any
state change occurs. If it is non-power-of-2, return -EINVAL immediately,
preventing 'maybe_corrupted' from being set.

Patch 1 fixes the issue for DAMON_LRU_SORT.
Patch 2 fixes the issue for DAMON_RECLAIM.

Changes from v4
(https://lore.kernel.org/20260410044259.95877-1-aethernet65535@gmail.com)
- Clarify this is only a minor user experience improvement.
- Remove Fixes: and Cc: stable tags.
Changes from v3
(https://lore.kernel.org/20260403052837.58063-1-aethernet65535@gmail.com)
- Improve commit message: clarify "unexpected termination".
- Add detailed User Impact with reason why kdamond cannot be restarted.
Changes from v2
(https://lore.kernel.org/20260402053756.26606-1-aethernet65535@gmail.com)
- Split the patch into two per-module patches.
- Add Fixes: and Cc: stable tags.
- Elaborate user impact and reproduction steps.
Changes from v1
(https://lore.kernel.org/20260331073231.30060-1-aethernet65535@gmail.com)
- Fix memory leak issue.
Changes from first attempt
(https://lore.kernel.org/20260327062627.66426-1-aethernet65535@gmail.com)
- Renamed the subject.
- Validate min_region_sz rather than addr_unit.

Liew Rui Yan (2):
  mm/damon/lru_sort: validate min_region_size to be power of 2
  mm/damon/reclaim: validate min_region_size to be power of 2

 mm/damon/lru_sort.c | 5 +++++
 mm/damon/reclaim.c  | 5 +++++
 2 files changed, 10 insertions(+)

-- 
2.53.0


