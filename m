Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0214CA0EDC
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 11:19:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 514B88E005C; Wed, 20 Aug 2025 07:19:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 499978E0003; Wed, 20 Aug 2025 07:19:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 29ECA8E005C; Wed, 20 Aug 2025 07:19:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 145B48E0003
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 07:19:55 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AC3C716045C
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 11:19:54 +0000 (UTC)
X-FDA: 83796891108.03.ACD860F
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf13.hostedemail.com (Postfix) with ESMTP id CA91020002
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 11:19:52 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Nu0AROqs;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf13.hostedemail.com: domain of sunjunchao@bytedance.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=sunjunchao@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755688792;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=etfq7Z3ynN+Xhnf5fpj8hv4AyY95nd/Rrih5Sc1jrvk=;
	b=e20ucTV/nlrG8UNJb73HJnILM2o58yjy40nV/Heo/V8mvdUsQKnscJLzJ3Joi2yzw22gJx
	VJaPEKZ4hWcVFbh3DnpFhMD+johFvMxAWNgB4OpPRX/jn7yZNq1CpOI5enRcUja/UAapnp
	BVBv4f5daYS9zxmWV91L5ddrenaqnuI=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Nu0AROqs;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf13.hostedemail.com: domain of sunjunchao@bytedance.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=sunjunchao@bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755688792; a=rsa-sha256;
	cv=none;
	b=h3hN4yxazTWlXTjMctkWm643t/LNBSjQwnDW/5sGrs783hZK0gVbKk5v1qRWMBvSPWSNuF
	ysXqpSBhaDvOPoYFTis+pGrbXUuOJOgPkP+DYQn3n+JLgiphubh0A6sGpENelHZw5u3crs
	b2Qz1Lz3Tf6iDm16CjnzcpOvhkRNhjs=
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2445811e19dso51011015ad.1
        for <linux-mm@kvack.org>; Wed, 20 Aug 2025 04:19:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1755688792; x=1756293592; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=etfq7Z3ynN+Xhnf5fpj8hv4AyY95nd/Rrih5Sc1jrvk=;
        b=Nu0AROqsltv/Ntdx7ZcdMVW6lXFSfBQnlpId2z9IqAp+HOaB8MsYbs/wuYV6UfgoJD
         dNHzN6+Ev1gSnDsrA+cRo4f+eldmyqGKrvnxIgYl81GRjTCs8tW9MHz4ApA7qURZeSW1
         xhAv3Owhw/Z925tAm5w3XAXJ8g9kNY1kkBNAHEoOcpBY3+waU/wyDuogg/seQkcsaI1n
         M8D8qPx+1CW4I1zD0tuVRITpuT6MY0/Xodhs5ieAFX2wT6xk2p2yOFaUEX1XBxFV7gQk
         u/CDX1wPf7XR0KsfrcHn/4SYzleXI57rlR7YFNMZV7xfge+W28BpfkNuq/Fe7ZTA8Nuw
         Hjkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755688792; x=1756293592;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=etfq7Z3ynN+Xhnf5fpj8hv4AyY95nd/Rrih5Sc1jrvk=;
        b=cktnz/5RTlhRZE3DBqLRPrWpMhINhrMK5wJaMjKQLB8an/5Clregg0Z4trA9o2xb+k
         gkVr6c/xAZ/Fvm+Siy5+NquMSuZlaVdg0CQ+eV8K6DBxUxZdUw8aLDelFAlTR65ozptD
         9hPnGWv+Z4fd9DcVlRdyazFYkr3oOHEFMXE/Dw+FZGTUzP4Vwsr5n9adsylr/1e4V5nR
         RdYLJiy67pLuFFq6GF8YrCFuRvYLccojQ/0+p9B/8lU62bKxZau4YJ2MQ4Pi28xMxHW1
         UnJHU18UN4PMLzr3tLsiz19/J7QDUD0qXTRLMd1XH19wMvsTIHcPZZwtPilwljgzH+ux
         Ukvw==
X-Forwarded-Encrypted: i=1; AJvYcCUDRSt+YsJelxKaazFpx/j2Cj58XZRSPSsMgkPBHJ6+3OTw8p+SYClBSl1lsqbRv5h1NEjBM7U/0w==@kvack.org
X-Gm-Message-State: AOJu0Yxp+EmtesrbXtGkNpmSIl3Ta6DbZgB7+ceO9TNI/5bWRad9pHE3
	mC0ieoLGkn11B+cePtPqHNJBZGoNZhMFiAASrch9noQ4WuPg28mIK0qgvGvY8D5ClLg=
X-Gm-Gg: ASbGncvuL4FsYpBujSk/K5dx4c6SalysbKB3/jQDABXHmsWssbdhKQqhKrvXYoOfPnE
	PT2SfHuwCmYTDkKgmz518dYyUGeJUqg9L+VdKx1ePPrEHUX60dyOYlAqDunNmfT3Mk/j2Mra03y
	w3nJsuzAYXvjF6S22Km3Q60jfq0iys4GvzNSKIZ+UrAxY46ValYpoxEyjqSvHFwTEPLmsJZaCf5
	RWUvnGkqa/CjA2aX5IMGgrUGdRllRzVMv0VtEJf+iV8a4+Xunm5pSPJaTpDU3B2BPHaPP9Hz26U
	6gYkARqF4KXMtsLEh35fcS3HORSe7c/TywiWYA6OwLeGnbOzQo6z/Um+YlJhGt7nvLKI+OjTzkB
	fSdnlefYI2jZFyu1ubklem+zFJhovV58=
X-Google-Smtp-Source: AGHT+IF9yMAQzAeu7oFSZbN1hEkzdOyEwI7/xKUKHr1JqovbQHv/4TBbJdLBUdslaIF5hPaYBQQ47w==
X-Received: by 2002:a17:902:f70e:b0:245:f1ea:2a4f with SMTP id d9443c01a7336-245f1ea2d96mr20929305ad.37.1755688791478;
        Wed, 20 Aug 2025 04:19:51 -0700 (PDT)
Received: from localhost ([106.38.226.198])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-324e7fcff9bsm671051a91.23.2025.08.20.04.19.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Aug 2025 04:19:51 -0700 (PDT)
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
Subject: [PATCH] writeback: Add wb_writeback_work->free_done
Date: Wed, 20 Aug 2025 19:19:39 +0800
Message-Id: <20250820111940.4105766-3-sunjunchao@bytedance.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20250820111940.4105766-1-sunjunchao@bytedance.com>
References: <20250820111940.4105766-1-sunjunchao@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: CA91020002
X-Stat-Signature: bnisushjipsg5qfbcbp93qc8phdyatf7
X-Rspam-User: 
X-HE-Tag: 1755688792-531029
X-HE-Meta: U2FsdGVkX18ZSVK81iLGtv9BIIiPsjn8gQVscjKFmYrvj3Baw+a52PT7K3GK4d+ObfPlEQHGf/ZDchY7E6PWtXGf8N0Vc5LV6HKGBZXS3bQlbCfDx4vOGXNRanAOTMFoVcbMSAwj5WE4xsWbWnRkWBUGzInpkW4VALMZBSh/b8rhnYrZy7WTteS9EKCObB0894Nfa6QB1NZvz3mDDg4AFvfvm+aVujC3W8QN9m+CG4yAeup0AP9ql98X6eoAa8kXyumSM29XYyIUvzfq/Q0RcjI91YMveJVABChH5MfMXhngrnXUdYRZlMTFAgOjHdiDpoTivY35yRzdqLXWNgnmCvB5YVxsT+5hAqjfBvytNyC0GF7UftQRWndiuaB7+B1F6azVFrQ9Q65PkeazsdzmSyJRmroLGBtbltaf5MAoKmaI7YGFJQMzizTj8lTgjcHojhtC11usZZagLL+49cJi0jWSUAUoVIxv25gegZa/k+2HZ2/5C3nSMronEWA7ahCM/d9EkM2cCyRlZcwv5n5fpdim0NrIhnmuNEK3V5zBwjYbcvGqtiY5vEDnuuQXn8X+CDdF7pCExmRRGanDAH9RBlb9unJHpL4Xp3leJ4VU0ywhCG/OLioqmQUAx6kvA5UBIYsIqU/buSMxr7H1Sn3K8Ow7ys148I0rWQgauW7A4ZEZQNYU7U9U/e89p7ozrWhUyf0M/BnJIYdkN6J9d9hAMIFhVDQubmrBc2XDrUQ5DqMHQcbv/Rb4oVxq+tZb1/yTYYIEjeLn3nwQjJITDHzOa6tktolwk5txvVhbTQASJwFH3bg3zQC4pieq8iT1rqxZfo0b/wf/PlisU51fIgmEfTyODqczFaOxqHA5Ei3nVcZ2dOupAQYUoIv0eDnb13WymASGmPjXHxyW7YAJUQs4agu+kRohkf/HoyQATC/9BPnO3o4IlfGG+edM89aVfYiuzubGvuIeB/2I6PxABEY
 kS2bN8GX
 FH/I/cuaEnB/MSYgOBZ65JaDQMm2km/8HOSQR23lgM0T5CbZl0t8nWDnxgDAXIeXzXUwciFMDceL79/BL892nT6VdXPN6mm3oOGwPFwZJKjtGCj/lf4VvLmuCEfsB2GTEnjOeLI8IHS6mKWLX5YdAfYfnbMMshRue1aVI3cgrTXrjIzvH+xnBbMCRWkiLFXPMsh5MDN3XSaZrxjakgod2Ytkjfz6F++C95jXh8FpVYF09eM5hRE5OD0AEmX5MIdoGmlIZEYyhfBHVXfdarH946+e4HhiszgpgW7lhpkQm1cT1dwRzbh9Kq2GxcsC16Xdv7WkTIjo8Z+2JZfCceNCLq/2SxqiKhWNq2yLrNBl9q25Ch/63ZW49/U5rSZenLHRwHsEcuD7kRv8582gTQLTAzPw+hC1PBuuYoozpX5AAAokgn5GgsN5CSeXfAw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add wb_writeback_work->free_done, which is used to free the
wb_completion variable when the reference count becomes zero.

Signed-off-by: Julian Sun <sunjunchao@bytedance.com>
---
 fs/fs-writeback.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 4a6c22df5649..56faf5c3d064 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -49,6 +49,7 @@ struct wb_writeback_work {
 	unsigned int for_background:1;
 	unsigned int for_sync:1;	/* sync(2) WB_SYNC_ALL writeback */
 	unsigned int free_work:1;	/* free work on completion */
+	unsigned int free_done:1;	/* free wb_completion on completion */
 	enum wb_reason reason;		/* why was writeback initiated? */
 
 	struct list_head list;		/* pending work list */
@@ -169,15 +170,19 @@ static void wb_wakeup_delayed(struct bdi_writeback *wb)
 static void finish_writeback_work(struct wb_writeback_work *work)
 {
 	struct wb_completion *done = work->done;
+	bool free_done = work->free_done;
 
 	if (work->free_work)
 		kfree(work);
 	if (done) {
 		wait_queue_head_t *waitq = done->waitq;
 
-		/* @done can't be accessed after the following dec */
-		if (atomic_dec_and_test(&done->cnt))
+		/* @done can't be accessed after the following dec unless free_done is true */
+		if (atomic_dec_and_test(&done->cnt)) {
 			wake_up_all(waitq);
+			if (free_done)
+				kfree(done);
+		}
 	}
 }
 
-- 
2.20.1


