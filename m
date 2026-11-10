Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 813A4606A33B
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 05:48:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=P5SFQ+ts
Received: by kanga.kvack.org (Postfix)
	id 9B45C6B05B4; Tue, 10 Nov 2026 00:48:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 974936B05B5; Tue, 10 Nov 2026 00:48:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88B616B05B6; Tue, 10 Nov 2026 00:48:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 604116B05B4
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 00:48:49 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EDEC6120892
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 05:48:48 +0000 (UTC)
X-FDA: 85418130336.24.EDAF631
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	by imf14.hostedemail.com (Postfix) with ESMTP id 32CA3100003
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 05:48:47 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=P5SFQ+ts;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf14.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.178 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794289727;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=qlHsy27E5D3YFabLkscnO6Hr0slQj6Qu+mskenxvEzg=;
	b=GAGNIKT4R2wWEcWUPk1a+Vr7o2JDFnPhgSudZQ5MR6YnXLTCkiYxhjactqqV4jYAcXsTDC
	py49NWPbSze5n3swjjVTv41qFO6Ys9pCOvRlH5AbJjZ/nsSKDGF8li2VZrRs3EF2pzUsSo
	SAGsTzLilk3piUd7Q8vtDwYl8hFRgSU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794289727;
	b=bmcRgrCFL9wpLLOKihtzcnTaSFEJHB05+T/mC8fOgAbklPP/CPC4n/Sq6dXXD4uasTRLLm
	i2NOfqpTDzyoBRMIND6kRm/StVFxPNXNpM13txjcZiWO9fYcoT5KpUzn5OksfQL65twjgZ
	UYMntrTJXG4U1L3zzdmKJ+QhKpKAsD4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=P5SFQ+ts;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf14.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.178 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-8b612fd74e1so577826b3a.0
        for <linux-mm@kvack.org>; Mon, 09 Nov 2026 21:48:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1794289726; x=1794894526; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=qlHsy27E5D3YFabLkscnO6Hr0slQj6Qu+mskenxvEzg=;
        b=P5SFQ+ts2qkFdfAn7hdPzDb8FrpkXj9qvpoR0FqzR7G8U38ceyRv7yhwgki+pVoCjW
         KEu8604WyyMFjzHm7vmU6XBKg9DXHKCHafUWT6zRILcyaTCFbOPJKV3w20edK+wYpi2Q
         qNhh+6hABZLPVON8BZiwEEiEfgOPCpxS7IJ30=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794289726; x=1794894526;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qlHsy27E5D3YFabLkscnO6Hr0slQj6Qu+mskenxvEzg=;
        b=Jl4LRO5YNShpBh1NDH89lXToQxjS9RHkpWZArl/fuJsl5IRyv/8yeWX5xctm4Iw041
         8fQdSqUormDZtMhxL2PNjAqKXRMxh+B8KukEjh3TZzMhXUN7oZ4whBTFp7LpdRQ2mcU3
         OaKh3+DXchXaMTB/nKNIbozp261vOOpIL0HV36s1vK6pufEFZ32JIHwWY6V6V58ympgx
         4AN68qfkXWxo7NnOgChEisOsUijO7q4JqBXZ+G5ZqZycOd4SCrLK0bgWMoH8EQviTCTU
         MnJhJ1I3HTXJWxrFEH1JGRIklJNOm5+HDBK1vGCfC9EfEpqrTTXCcUC5nN281QT9AIvg
         o8gQ==
X-Forwarded-Encrypted: i=1; AL+hErE0JPKnvnCLCXKujudBZFFrvqbvN0d60VyjxaDFS1PFLGfbcqVY+fY9w6fNxy/FH2SX7PgdS6ZXTA==@kvack.org
X-Gm-Message-State: APuU4Z8gVV5CxPI7b5oPttGG4gCSo4UUlV4wdsyxD/HonnLCXMIOo0ZC
	MfGCtpq7YCD6sE6XzSfQNrlEpDk+vYQIlApBz7p5hJQrvAUuVE4Dz7zFZGX/nTSotA==
X-Gm-Gg: AYBFou1vkgdCVRjsABwm/ujtvgOwaM2LljlJyjIzsRTPMY4iIXfrbi8QuHwQ06Wz7iw
	vy8v9PfX80EZNysetjdZ2vZxU82MZdjUSnFqQhjyjlZxXjxW2yql97jrRmNv2u7fq6po+qRhJD9
	cpjdTj4eYeJPRxkV9e+yoYj8svgRbTcFZymYi6hxcZLKXB874eyDZy8MFaJuCq13LPEG7fVb2FT
	6oOrBCGMZQmb5Qknfoxg0FGERxznSuT/U54Q9dT3AJ8wU+G4T2jW+VTmMNLJWOjzJfFcmZu4EGD
	r2zN2RgOLHaNFMF9nWbdVJR5Qcqg5eVhr+JxLL/0p7kBGTH3h/9zt14z+VluztK42/gNvKeM8Bn
	Dd+Zj19So0N+GKWThlBcJN0GjgtE9cFnouT13HsJXrzsylWkzoz9IsrNs14cao/zecpLz+n9b5V
	+1RcdqmhY9udXS05AKkf6sWY/oQkGYfPlWz1k1MSTn2/5liLIZPANAcHtaHxQqwhGzIWHIYASXK
	kSsIPVNMxiXQW0exrNxhbaijvt4dm2D8IMGga83cIuPA4Jo+O1GWGyP5HV5xgQyUdhnlDxQhswy
	56X7McShfaFlRO43vYlmX6O8wwmFlHlbnjBRVKSgujUG7s/X3kdz5jYlPefVBcvReGxG67/WSgx
	RRlN/BpFoWFGBfqmZmw==
X-Received: by 2002:a05:6a20:244d:b0:3eb:39fd:badf with SMTP id adf61e73a8af0-3f188c51a46mr1510768637.0.1794289726009;
        Mon, 09 Nov 2026 21:48:46 -0800 (PST)
Received: from tigeriii.tok.corp.google.com ([2a00:79e0:2031:6:e137:9384:7cd8:6e40])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cdd8d67e53asm444634a12.5.2026.11.09.21.48.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 21:48:44 -0800 (PST)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Nhat Pham <nphamcs@gmail.com>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Brian Geffon <bgeffon@google.com>,
	Minchan Kim <minchan@kernel.org>,
	Richard Chang <richardycc@google.com>,
	linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCH v2 00/11] zsmalloc: redesign object alloc API
Date: Tue, 10 Nov 2026 14:48:05 +0900
Message-ID: <20261110054836.1515030-1-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.56.0.506.g506a7eabc5-goog
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: fjiuxo5sifwyo4ujhtco9qpsso1q1jy1
X-Rspam-User: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 32CA3100003
X-HE-Tag: 1794289727-146456
X-HE-Meta: U2FsdGVkX1+LRcr4wS/5wx+ClAMd47tikfljKBWhwu2jd2I5ZrwNj91cIqnrAG47vWnE4+AeA4W1HkmaEVXlyq4CGVCC1bcJmwKdESaNG2fBsUe2/m+1BU/SsZkTh2ikeulpcCdZfHB1KIRNOtIH8qKIF9beZ2rxvjqlRbSkh59Bk9e/nrMKr94TsmzpEkMwfITMpyCfAFvz1h0uo7NIfLb0y82e+e65I1//3S0hUGEINXEzeMUNBYSTJqtppD5oTUaxhNxtB0FSRNTL7tUmM2tMrrqnaAnagbJ2X9BCnjnpk1UJ4SNhmzo8yAgIQ9hqoPKRIySwNGJdLq8pksvC4mXhW6LmPSCEqcaQwvdSR4m1ctD/K+fugG+NQmniFX54ZqWObWY1P3LaQMhEga5krPo3uQdGjHT19g+RfifWwxckhvrgqCsrHtzRQZ1FrTLrHxF0BZXeCr03+MeKcl9A5e8movVQ2bI297e1Fe0+iPM0UrlYgTXb/uF3L0YdGlpcwhVvvbkqpFDw4V5NUazwzbe8tUnamtCQ9OlXLgH3wAev+fJhwQbji3aEmr6fyxbTnzDNXf/gPzEfk3NTfmCWi/6E6zjPwN1LRnseI0yaoq0wPY7sGvP+cprJ54kq7OqM/PnhXd1SLbwr7dDKMgKt0Txebk22yWjajjkrguqwchS8ytxWdADKmW5DCzBR84oyeGJmBXoObLcMTGPbBaYbZWjh38BWV2IQro6S0Yo0iSe9KhVZ56gGjRKqIW+oluL52gtdb0csf3OzC9sqcRck4T2koH4Q4XqnveaESDOvqmpHhS22uiCtZrxr/Jhg/7p0df8qisC79kbo+GRgkK5+F+miivB5q3KyqcmsfP6PE30JDWeZ144rWrYm+/g27fMOq2GWvK54r/YfrcyaraJ+op/7XtFt+d0NlNynN6srNw27EtcVQEv10UOty59Let3OJh/0c7Dc7pZ/33xszzS
 AAvIW/91
 ko/nACuhM5Cpjukaj81A4MlxPJRHuW8/MzlwWl+h5a0TACva9SvU8ehublVPVS1LwWW5UpEHZoDQ8vTPPbcIvLxQWCUwTuYcxhay9B8LE42dP9koBB3PbCPyjAmPx9C4VpA64zspayzBeMPF4T6lKpEn0D6LUNwuTdZl8iPgJg0fw50DWSilZJPGQz3TccNBuefdUldXcbL7KmtwefNe+O+92r5UasH3+9CCLb8uwv45hpEiNB2556tUe0yzmwcpCiVEPtJpzW+6LIp0Nk3Gm7fDQ66l1kJ4WLe7X4kd7yY0yxUH95Ft3ItBQKot4e1To3jI9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Both zram and zswap already have per-entry structures that store zsmalloc
handles, so allocating a separate handle_cachep object per stored page is
redundant.  This series embeds struct zs_handle directly into zram and
zswap entries and drops handle_cachep, saving 8 bytes and a slab
alloc/free per stored object (2MB per 1GB of swapped out 4K pages).

It also folds zs_malloc() and zs_obj_write() into zs_store() so we don't
take pool->lock and look up object location again right after allocation.

A simple zram test on a 24-vCPU VM
==================================
165 fewer kernel instructions and 0.7-1.8% fewer kernel cycles per write;
lz4 single writer +2.3% IOPS / -2.6% average latency;
24 writers +0.9-+1.0% IOPS; no regressions.
Memory: 8 bytes less per stored page.

v1 -> v2:
-- addressed Yosry's v1 feedback (too lengthy to mention here, Yosry
   posted over a million comments, or something very close to that):
   split-ed some patches, squashed the other ones, added handle
   alignment run-time check, added 0 PFN defense, etc.

Sergey Senozhatsky (11):
  zram: drop stale comment in write_incompressible_page()
  zram: drop get_slot_handle() and set_slot_handle()
  zsmalloc: return handle from obj_allocated()
  zsmalloc: switch handle type to struct zs_handle
  zram: check mem_limit before allocating zsmalloc object
  zram: allocate zsmalloc object under slot lock
  zswap: do not free the entry if its pool is NULL
  zsmalloc: encode 1-based obj_idx so valid obj is never 0
  zsmalloc: embed struct zs_handle into zram and zswap entries
  zsmalloc: fold zs_obj_write() into zs_store()
  zsmalloc: populate new zspage outside class->lock in zs_store()

 Documentation/admin-guide/blockdev/zram.rst  |   4 +-
 Documentation/admin-guide/mm/slab.rst        |   2 +-
 Documentation/core-api/memory-allocation.rst |   2 +-
 Documentation/mm/zsmalloc.rst                |  22 +-
 drivers/block/zram/zram_drv.c                | 146 ++++------
 drivers/block/zram/zram_drv.h                |  10 +-
 include/linux/zsmalloc.h                     |  36 ++-
 mm/zsmalloc.c                                | 285 +++++++++++--------
 mm/zswap.c                                   |  28 +-
 9 files changed, 293 insertions(+), 242 deletions(-)

-- 
2.56.0.506.g506a7eabc5-goog


