Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BBFFCA0EDC
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 11:19:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CFECE8E005B; Wed, 20 Aug 2025 07:19:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CAEEE8E0003; Wed, 20 Aug 2025 07:19:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B28E78E005B; Wed, 20 Aug 2025 07:19:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9B1848E0003
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 07:19:51 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 41A461DD0E6
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 11:19:51 +0000 (UTC)
X-FDA: 83796890982.13.F506E84
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	by imf23.hostedemail.com (Postfix) with ESMTP id 5B8B414000A
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 11:19:49 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="WD0/tQgw";
	spf=pass (imf23.hostedemail.com: domain of sunjunchao@bytedance.com designates 209.85.215.178 as permitted sender) smtp.mailfrom=sunjunchao@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755688789;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nmUl5kz80SYgDggauq/gcrY9lNJu+BoyJNt4pf6QvUk=;
	b=0pn3MyhUaOHAIg0hFuhXWbORdWj/H6HZllzS0KqjWr9ysftcv02vgqcmlFMTDpXsTb05Y6
	C06f2g9AoT/VQ1bIhfzLv/evmzbVoFB2h+YnBOdYyJLVl+m/rHaUgqcydzIcgJbau5cpPi
	2CEr3z31J2EZB6hF+WZBFn7/KX9bwfI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755688789; a=rsa-sha256;
	cv=none;
	b=Bkh21XrhdMWpQKYpWBIjMDno7di7fOwWe+YCzyDQEXDjkEcKskCCaA2rPw99fxIQf/AYrm
	j1ztYcEvTWaI7m3LWICdYs10pM/KPaKa+CQWzihENyJbQpnulM4YIe3isOwDW81INAk+Cn
	FtuChdEgQvD7alJs1f/tnPO2bg7gWhI=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="WD0/tQgw";
	spf=pass (imf23.hostedemail.com: domain of sunjunchao@bytedance.com designates 209.85.215.178 as permitted sender) smtp.mailfrom=sunjunchao@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-b4716fa7706so4282681a12.0
        for <linux-mm@kvack.org>; Wed, 20 Aug 2025 04:19:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1755688788; x=1756293588; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nmUl5kz80SYgDggauq/gcrY9lNJu+BoyJNt4pf6QvUk=;
        b=WD0/tQgw9eDQDuJ1qq2y7hDUnuYpSXc2iyintmXjl2ArDFW6fIbFTsdU2H8qeN3neD
         dCtqCD8uenYtgkpy2Y//8cuWQSspe2+HItkf+BQ2IzTd86Vcekcy4NzOH4Iz5ptE0Fek
         VNRjVvRiztjs+O7GAB+FZGhov0h5L/StY2ENIiJIldzXXbMPS3Jb28lcfo1wqD6qW0j8
         aktiRFc8uxjzfTjf9JcaOy5xuXnoRyLKNF/a4vwbsZdl5d2c27RF0rRgcL85zWhgooQo
         1j64Rq5Y2bYFC87XD++zwmas1W5kEZmr7mOj1tCR1i0ReDCxqVV0hIMxa2wCoL4IEBAF
         NJAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755688788; x=1756293588;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nmUl5kz80SYgDggauq/gcrY9lNJu+BoyJNt4pf6QvUk=;
        b=ok1x/p63fQPZEi9W5iOQ1Y5fK9feC11uHrsqETKre5lsr64XgKO2mWL24db2b1Ce94
         SDJ6dHmJ3G9fK0hfYU/DN1fSsIpntRY9nZAf8blaIsRpJM6jZKrK85+55tEiFXlyuQ6f
         gEgXN/pgzSXVRSKQDGVeVyw7HT5U5i99JVF14M3Jdny657agPHNMmFa7BdHG+qCvRFCm
         iVONYREDOOy/Wfa2PiFBhuX0DNFojg17OtlK6na0jGPycCvz+uJ6hsj9lyUCFANhy//Z
         U8ZcmbBJtGXUEX0AG8Izu/FCiaRXXnudRAABOk2wy7a5utl1TNS8tWZ++h5yK1UwmZBW
         V4Ag==
X-Forwarded-Encrypted: i=1; AJvYcCUSd4t6IOdGZ/OUK/y5KMk29TFAugSbjVCp+y/S+QAYDGiCTlNShE6lEkg5NvdsL+LMCQNiwVQGlg==@kvack.org
X-Gm-Message-State: AOJu0YxPXl+DMGom0eCaN+Se34jmGllJPiSkw61SDkUjt133U7k82Nl/
	3cpqWf61ryV5y/W7t8AH8SV8jBvRp+o0WAuHybLXMuNMpdi+sxr7eIzEnZFavb0UVKE=
X-Gm-Gg: ASbGncstKEp30xisVXd2PiihQ+EmUcHi86vJC5BetDddwPdYKDAYyHYz80IamseBjmv
	52iUXoHrk67g4um8+mgKyReclCuz2+ecS4YThADEyANpRVQfvxZo7f5ekoM+EbfWwhvq0J/Ehra
	KQ45nMSQrwU3WHGMiBXQ/GQrBZzn7d1c4XpWG+VWw/5ZKpWCmr9J8L4d74bjwW2ECeFJLj2OmN/
	g+fwzDKaax0EV88Y8Mn6pcBWICHXetqzLNJQNovrwQCwZYn+Ub2bDEgL/R/fQJGDbF5tSXSJzVM
	YOhKJqeA80huMlpsFKHkbJlPFRsFnvjGDZVbgraU8tyJjWIEGE+sLmJYzb8ybS4KusLhXJTzzW+
	T9AWK46Th0T3FIGRNupg9wFp/jvZNkyI=
X-Google-Smtp-Source: AGHT+IGXmQtILlfaeO0KNXbpv61Pi7GHyLtGfxlkUeNc5eSE1p9UKZu8WVkmKp1RbNxVnH2+bLRYDQ==
X-Received: by 2002:a17:902:d548:b0:244:6c39:3361 with SMTP id d9443c01a7336-245ef238c60mr29969545ad.44.1755688787898;
        Wed, 20 Aug 2025 04:19:47 -0700 (PDT)
Received: from localhost ([106.38.226.178])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-245ed359300sm24062325ad.39.2025.08.20.04.19.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Aug 2025 04:19:47 -0700 (PDT)
From: Julian Sun <sunjunchao@bytedance.com>
To: linux-fsdevel@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org
Cc: viro@zeniv.linux.org.uk,
	brauner@kernel.org,
	jack@suse.cz,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	axboe@kernel.dk,
	tj@kernel.org
Subject: [PATCH 1/3] writeback: Rename wb_writeback_work->auto_free to free_work.
Date: Wed, 20 Aug 2025 19:19:38 +0800
Message-Id: <20250820111940.4105766-2-sunjunchao@bytedance.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20250820111940.4105766-1-sunjunchao@bytedance.com>
References: <20250820111940.4105766-1-sunjunchao@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5B8B414000A
X-Stat-Signature: o4rb176r1j41pfamrra1occdxe8m9nh1
X-Rspam-User: 
X-HE-Tag: 1755688789-162691
X-HE-Meta: U2FsdGVkX1/pTcJa+rWlZS/kZMS4oA7NYem9P9LvZA0LPaWJJOz2SdNm73fz5MWuhClPkhZw7xm1WNsiFS+uFOVmeq1AZMlLNt7I3it51Kn5Rtcr5i0VCeZnq0iVgxk2MLZMWksvbti89yLU8ikuSqtNuHYZRaYjlHgR48TJYApI9e40FkE+pTPNgT767WWcje20MedAawth2rCBJlFF6/uUU9/+xu9yh/vghCtg+qdlWkp6xzuM3m4akTugivGbqDYfteDaLwMZ2PB2KqmSLnKA/+oT6/8kzehMVpOlauxJvIPwyAIIdHjwaC7qXKet1toBmM2Z9tp7VjvpATpUJij5GRP5mwMpHlaZA4KLf0ezO8Bp0Ex7afqZvfQEdc+enJo/6/Yb0kWt8H2h4MQbTHpnd6LpywqB6BS7JRcXOfyxhWWUKSDUBUA8zBcaI+P6AZiw76WRCoVrw24Xa1c35+++gm8GihbvNezWxyM5gu3SVnnz4zxvIC0LenV26HSDEZpiTjtYjf0m7+fIXyGWJEB/4HUn5JO8RKWjSM0Aal7b2Zgbu+/NB93tIzfDr9JVe114mQzkmLsLFAIPwT8K/f7gWRyZfswDSE62P93tldhj2JVAdrKlEiBNvEX6SRslYXuENLMd430k57+h+dYuhqFEQLacCmNq0z3hWgI4M/Qa9+Wqn1rtUuDxC+f3lKfTns+lQBCnFBpXQncbywwdnm3P2zbkMmOgroUx3xrz9CyogN/ax8sh+zE2Y5c4IFMYsMwanxxCBCk2ond29FK5QGmB1uFNruC64lxzLM7inLNrssxHgi3+XGkncRdXKo6eIHwE5XRU0WfsVv9sozG1+1SxhYlaJD4TgySqreWpTZg/zV/4uuEuTmzour2jwEeltvX3VGN46l1jj/rp9pppHS8tgkxbTa/hBNyo5QyysDO/tmkDlIz+OJ7W+O/WUD+cPYPWS0gpe8TwKT9IwsH
 ECDMWKs0
 DThwFn9f1kbcF+ruY4GYsginJcFUzvbf33pNp55bRcrCI+CQhnsXfuOEAa9+KJIJtubMBwlPWs3LkRzuUSzzwwbRq+/MfJcZERAAx1j5tTkrllq1FjR60GN5njX6ndi9IIiRCH/JEY3vM8FQ+wBDtAUGtVDROlgw6YhjFSMRRpUbGZFNofhU9GAAOqrfciHLSbKOgCFwCbnFF9xnZjx0E3OqHu9D3DQ4SL5QG7R1EZz5uSG2qhgYwNRfCUaLL11b3WGsEY2Zp49d65SJNRWBC9qyzcuoLOCwhqfKcv7aWJqMfsveCJwb3TmTBYrleB51AecwwIrhsGCpYVTEQg8Kb88oPGN6by2bCcfMUb9v9oCzwybZSutsAME/duQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch is to prepare for subsequent patches. It only does
's/auto_free/free_work' with no functional changes.

Signed-off-by: Julian Sun <sunjunchao@bytedance.com>
---
 fs/fs-writeback.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index cc57367fb641..4a6c22df5649 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -48,7 +48,7 @@ struct wb_writeback_work {
 	unsigned int range_cyclic:1;
 	unsigned int for_background:1;
 	unsigned int for_sync:1;	/* sync(2) WB_SYNC_ALL writeback */
-	unsigned int auto_free:1;	/* free on completion */
+	unsigned int free_work:1;	/* free work on completion */
 	enum wb_reason reason;		/* why was writeback initiated? */
 
 	struct list_head list;		/* pending work list */
@@ -170,7 +170,7 @@ static void finish_writeback_work(struct wb_writeback_work *work)
 {
 	struct wb_completion *done = work->done;
 
-	if (work->auto_free)
+	if (work->free_work)
 		kfree(work);
 	if (done) {
 		wait_queue_head_t *waitq = done->waitq;
@@ -1029,7 +1029,7 @@ static void bdi_split_work_to_wbs(struct backing_dev_info *bdi,
 		if (work) {
 			*work = *base_work;
 			work->nr_pages = nr_pages;
-			work->auto_free = 1;
+			work->free_work = 1;
 			wb_queue_work(wb, work);
 			continue;
 		}
@@ -1048,7 +1048,7 @@ static void bdi_split_work_to_wbs(struct backing_dev_info *bdi,
 		work = &fallback_work;
 		*work = *base_work;
 		work->nr_pages = nr_pages;
-		work->auto_free = 0;
+		work->free_work = 0;
 		work->done = &fallback_work_done;
 
 		wb_queue_work(wb, work);
@@ -1130,7 +1130,7 @@ int cgroup_writeback_by_id(u64 bdi_id, int memcg_id,
 		work->range_cyclic = 1;
 		work->reason = reason;
 		work->done = done;
-		work->auto_free = 1;
+		work->free_work = 1;
 		wb_queue_work(wb, work);
 		ret = 0;
 	} else {
@@ -1237,7 +1237,7 @@ static void bdi_split_work_to_wbs(struct backing_dev_info *bdi,
 	might_sleep();
 
 	if (!skip_if_busy || !writeback_in_progress(&bdi->wb)) {
-		base_work->auto_free = 0;
+		base_work->free_work = 0;
 		wb_queue_work(&bdi->wb, base_work);
 	}
 }
-- 
2.20.1


