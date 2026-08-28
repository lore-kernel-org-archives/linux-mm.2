Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE348C61DBD
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 14:25:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A115E6B0088; Fri, 28 Aug 2026 10:25:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C1A76B008A; Fri, 28 Aug 2026 10:25:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 889856B008C; Fri, 28 Aug 2026 10:25:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4C4146B0088
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 10:25:49 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 346681603B6
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 14:25:47 +0000 (UTC)
X-FDA: 85150901934.26.8C416A1
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf21.hostedemail.com (Postfix) with ESMTP id 542A71C0008
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 14:25:45 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=evinm4P2;
	spf=pass (imf21.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787927145;
	b=60Q7ZLHk1drkOTb9uhr8sGn06XYObOM+907Gj9k0KrV3jikeGCZeWpSHbGTfriNvzROab8
	0ufPW3vhAg9wQKQJv8E4L2teQ5kTthM09kUZ4aojqa+Ux4tpkG4mfwqlBkbtyrYtgDCW2d
	0shXA/byFqu6du7J/Cd1+tk6uyRn6IM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787927145;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BoxMq16+fYtVCLi36Xsb9nn9RavJ5HgJioRujA1lSB0=;
	b=wnhWn09WkqcVWJvqrqlW7Px9h0txT3h4bVJVs0ooMXbQXTxoFDRZJxZiN4E8G2t+ipCR3v
	/BnPSqOYy4vk2LuWpGX11DL6tNABWY4oriAL8oAphBUGgWatIxeo1tzoJfzuzXqcdJdNfu
	KJaoPLIRSGtOaMhJ1scpcEP5KLwpSyU=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=evinm4P2;
	spf=pass (imf21.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4998b5a63e2so10005555e9.1
        for <linux-mm@kvack.org>; Fri, 28 Aug 2026 07:25:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1787927144; x=1788531944; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=BoxMq16+fYtVCLi36Xsb9nn9RavJ5HgJioRujA1lSB0=;
        b=evinm4P2E7bKrLSSUq/R8n0GEXgCXZH09qYQR6fJvelWM9kuviy30mBCOFgudbPDhH
         4kSHrNMcbn/zHtTlD7WcEgg6kTCRQc4LQMO8mv747m/Gu9pnVcH6+49GMvd+pHSSSWIM
         OUa8hDi5x5ZyBy+a11DnoL+lo6TAeZjKiU4u2QgjaXwECNXi8UYkkVGnkFwy8TqjrKmT
         Gc4LM0J4YZwaNKiDrPUGttDJ0Bi3IhtveME+Hwld/SvAwNeyF61vJfLw4IrJV+s9Gv5R
         6TzAPLuZI2DnB7iqAKT93OQk/TIak354YRVxaso+aOcCtGYqiZJ76aXeSnSykWxI1d0X
         SA8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787927144; x=1788531944;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BoxMq16+fYtVCLi36Xsb9nn9RavJ5HgJioRujA1lSB0=;
        b=l97mK2p3S1WzP2V8jVwEY3bUGKn51Dv6jhWl0SnGFeW8GFJO/oDlTpVSB7hTse7AHq
         rju4CHRM5bTbdIJo3M9e8p+NuD46EcsrWPz036XlJ+FP5hJVEfk6sG6vQZl7CF+IXEDe
         jmEBZmk2Jt9xtzO6Dc2hBiuwz0gQVen1TeLmtcf2q5qYjHsqHI7hQC/+ewMq1pV0lR2Q
         Q6apoDziHfkVane1ckNEn3meIVFMkfjKu16kRkZlO8j4r16jz8bmv4CQZHEh9oV/G6v0
         NUmFQO7YxgLqRaS/7GjFbHuoreHpqaclQ9EOupC6pXKVAW8CHvAkbsjRl93dD/NadaA3
         ayXw==
X-Forwarded-Encrypted: i=1; AHgh+Rp+bwXd/N9jnBUun2rqitq3+O2pg4KWPAZPEuxBeVXLHwsuWAixfBWC7Xgtp1tDoawNUoysEAtYKQ==@kvack.org
X-Gm-Message-State: AFuF++m6TpEYL/5wzf+ODeuNKcn5ZeUxW2cfJzWeOWFcCtt/RuNYHsHC
	HcBIoFJ4kpEmjQnHOzf7MAYGW1x1zkiSJgjSNfUozFW+aSmh+5AZyERMk1/4h/INvsw=
X-Gm-Gg: AR+sD11A0lyKlcbhDPy6JdxdRLp9IfYxe1Z4HRR6kAXa5fRQGnitgx0WRs7ubQKgK27
	bxfpPTQT4xrcnIe8myNIa19azlbmGXhpr5Picc2DUWzEkYNMsofg56v77NCeaktWjulXFKVgByC
	ebM0vDWbG3nUO/iD+zjgrIlCtjw3fWpuGWKFks8u74jPa921wS9VWwo/3QpmJpugkR9OmSzPUzm
	BOdrweiD9/KBud4X+y6sTYwilrfVNvATioCu+qQq3uuVT2f3sArSwndehzf8CUzMKMBDo0rqVv7
	k1KdfF9C+W66vEqo9aJAkAj3Mqzri2cUtQ5k2ZMPJywUjkYCT1DMT39sICX8PQTleODcxTclK9x
	AAibtrCD/NTzCgAUV5EJ7Ulwn1PBVuVUjk8x2Ie1fjc4wc4M4WOl8p4AgW6BavLh8HFur0SOmq5
	WtBfDEGmOTMgbhLmJLuP1o4anvKD0qExCaxSMfkMBWd4YGPL3yk/zwRhAoJF4C/QWiUiPA/fKgq
	A==
X-Received: by 2002:a05:600c:b85:b0:49c:c96a:d36b with SMTP id 5b1f17b1804b1-49cc96ad411mr23596595e9.12.1787927143838;
        Fri, 28 Aug 2026 07:25:43 -0700 (PDT)
Received: from localhost (109-81-85-229.rct.o2.cz. [109.81.85.229])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49c5a903eebsm17011155e9.4.2026.08.28.07.25.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Aug 2026 07:25:43 -0700 (PDT)
Date: Fri, 28 Aug 2026 16:25:41 +0200
From: Michal Hocko <mhocko@suse.com>
To: Rik van Riel <riel@surriel.com>
Cc: linux-kernel@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, kernel-team@meta.com, stable@vger.kernel.org
Subject: Re: [PATCH] mm/memcontrol: avoid stuck FLUSHING_CACHED_CHARGE bit on
 isolated cpus
Message-ID: <apGaZdxAPH68kkCc@tiehlicka>
References: <cover.1787890328.git.riel@surriel.com>
 <a611f2bc40d30f9c14a6f41b173185975c46a203.1787890328.git.riel@surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a611f2bc40d30f9c14a6f41b173185975c46a203.1787890328.git.riel@surriel.com>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 542A71C0008
X-Stat-Signature: bi8bgsfryasp6c18yjgczei98znguws5
X-HE-Tag: 1787927145-268208
X-HE-Meta: U2FsdGVkX19DavP39VfAMupXSx8iddKegGSSxZRFBusr3N3vrVf8lGuPGu+D2mQVhYiaOnjrinHjffLSw9nAWpXARoQy23ZeU4SO9pd7H0sy50E9SHSkgCkLOUtMLVk2Fu4xcdcbZ4yyK+xb62YB+wSYMPMwEbS6nLJXbJ9mPwXaUCfTOfa4TL+mF59qjuDkR8ON98crQ63BOTk/ndkBLvcl/Lu/zofDZYcxLZMlhFCz9FK+LabkN+7HTfL8GgGg2R3dwMkiwdjAogC50niyS332ZSBA+jIjZFkTVMpfW8/0XsbLDTw4GdM7KWnPZ9ZdV0dsvVXjjA0XLRa6zl5BTsd4FrSso+aPCyEyHm4nhwgCbQOwmLw2yTE8QSkg9Gmx4b6V3JoZOxABP+7DbDP7sPKYORmdrzhUR3v9DfxhvbNMMvIHh9tHNSWAnOtd1z34aUYcY7q7ksyURCFPsqpJl/MtpoJXhQVIk2OJpxbo93Xr+15OiaZQXA9+7wQbdsQay8M2nlIjES8MZb5/Yz9Nz61AX3ljmJzctwLShMdu6Yl4jD+dTB90YuE12OQ7G5GjqjkO/f+fCDuO2E/kJHsKi8LYXplfC6c56xFaTKOXI0tG+DOfF810l8/0SgBvsdmIbe4nE8Y78MDksUF5gcgcGSMRFp7sdFSQ5J+RrAmsbldS4i/RFdtlozq1g1i6KpWTmT08FgaSupfL4hxHfEhDH6zRrxlx0a/N5Xg+fLSfexYgMjaUNRWih8ulGSwFoL1+sxzv6UyJV07v04Wo68vz4/t1TxIgv0KfStrrZsRaRvWHS1hfH8KGkeceZ4C7CCx530Wc6BVvkGy7begRc6UHe4C/pKLIwr8xCy2o4nc1V5yiLH9VeOqPIPPefDQ7lhBSDbKY98GG9gUfyyF0T+DRIkcX9bsy05E9tqRRBJv61G9DnL+UWfArgLyvPLhqQT5TWQUEV9eGSOay4LR+HfL
 UMWrioTn
 LnLXGmZDWXpVVass4Afdgr6GZrrhhFBbUoeQb+gdl4LuNNjXESY2L+eKiiIxRak9sHynn47ZD/iDh03I5yDDL48tXShpGMYipRuldB4HvxtL6iSRAasS0RSjJfh1R0KGaDkFdJ9Qy75vf03FKIGp+gjD/1dV9+LOyQ0zEHRMcuZPrC+N1s+6vEqJ0CLJ4Wp5T42qMrd9d+A7mCaV82NJwkUjMH+foxbFHE/vxdijDIHgaMcrcYJlQ9pDjxPCR3xLNdNvxrOl6Gtr3FPuD4HP0OXKS4tyS3GZHbYVe8a5/jm+bd8safRRLvvBjQgrPLtnFytTxb7FP62u+WJsNANFUtskC2xzi7zaStsRClG3pq4pf8fmwnRqmFv/esUWihiougjfAOOPz0Dw5fpSCujBJszYQ/Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri 28-08-26 09:46:21, Rik van Riel wrote:
> drain_all_stock() can leave FLUSHING_CACHED_CHARGE set after the
> work is dropped.  It sets the bit before checking isolation and
> schedule_drain_work() checks isolation and queues in a separate RCU
> critical section, so housekeeping_update()'s synchronize_rcu() can
> race the second check.
> 
> drain_local_stock() only clears the bit for work that ran, so the bit
> remains set and the stock is never drained again.
> 
> Reorganize the drain_all_stock() loop, reducing nesting, splitting
> out local vs remote cpu handling, and skipping everything on isolated
> cpus, which solves the stuck FLUSHING_CACHED_CHARGE flag.

Is there any reason why we cannot simply clear the flag if the work is
not scheduled?
---

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 69b37f63a307..907ac63e5067 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2261,8 +2261,10 @@ static bool is_memcg_drain_needed(struct memcg_stock_pcp *stock,
 	return flush;
 }
 
-static void schedule_drain_work(int cpu, struct work_struct *work)
+static bool schedule_drain_work(int cpu, struct work_struct *work)
 {
+	int ret = false;
+
 	/*
 	 * Protect housekeeping cpumask read and work enqueue together
 	 * in the same RCU critical section so that later cpuset isolated
@@ -2270,8 +2272,12 @@ static void schedule_drain_work(int cpu, struct work_struct *work)
 	 * pending work on newly isolated CPUs.
 	 */
 	guard(rcu)();
-	if (!cpu_is_isolated(cpu))
-		queue_work_on(cpu, memcg_wq, work);
+	if (!cpu_is_isolated(cpu)) {
+		queue_work_on(cpu, memcg_wq, &memcg_st->work);
+		ret = true;
+	}
+
+	return ret;
 }
 
 /*
@@ -2303,8 +2309,8 @@ void drain_all_stock(struct mem_cgroup *root_memcg)
 				      &memcg_st->flags)) {
 			if (cpu == curcpu)
 				drain_local_memcg_stock(&memcg_st->work);
-			else
-				schedule_drain_work(cpu, &memcg_st->work);
+			else if (!schedule_drain_work(cpu, &memcg_st->work))
+				clear_bit(FLUSHING_CACHED_CHARGE, &memcg_st->flags)
 		}
 
 		if (!test_bit(FLUSHING_CACHED_CHARGE, &obj_st->flags) &&
@@ -2313,8 +2319,8 @@ void drain_all_stock(struct mem_cgroup *root_memcg)
 				      &obj_st->flags)) {
 			if (cpu == curcpu)
 				drain_local_obj_stock(&obj_st->work);
-			else
-				schedule_drain_work(cpu, &obj_st->work);
+			else if (!schedule_drain_work(cpu, &obj_st->work))
+				clear_bit(FLUSHING_CACHED_CHARGE, &obj_st->flags);
 		}
 	}
 	migrate_enable();
-- 
Michal Hocko
SUSE Labs

