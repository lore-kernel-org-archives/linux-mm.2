Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5AB5606A330
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 06:47:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=PjZ/NObN
Received: by kanga.kvack.org (Postfix)
	id CE9DD6B05B2; Wed, 11 Nov 2026 01:47:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC2066B05B3; Wed, 11 Nov 2026 01:47:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD95C6B05B4; Wed, 11 Nov 2026 01:47:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 955106B05B2
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 01:47:18 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 015431C2814
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 06:47:17 +0000 (UTC)
X-FDA: 85421906556.28.CEF525E
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	by imf24.hostedemail.com (Postfix) with ESMTP id 37374180004
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 06:47:16 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b="PjZ/NObN";
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf24.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.46 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794379636;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=4EiG4ohiaJ+2VhSrJi2s5uqPv+5cYMcFL4w9Bign1CU=;
	b=wEE2uTc1GmRPFq3n9ko13R2tfrkCkGJ3AtDz/5KWPKrCEvz0E/TpHdOAgrsOdSalJiqdlR
	grVQAcypidCOamr0KHrTGwmDdj0OFG0LQOkLM468+HR1t+7+S+BpjeHGGl6QAbi60xe8VA
	7LQovkooZV+pLqoDZxleRTDsdK4H4ew=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794379636;
	b=YiUM3O+leDFNuNzRUYBNSDVeWRiqdVhDLrK5zu6104OVdTx65hJqjS3bYQgtNHB0hAJ9O0
	S9+mrMapxuti28IPD0IltiCLmB8XnEoVP1p0tnPQ3x5zdyb0MMabEVufnh1PetnKa1Or2P
	QJ7+hNaMeQyY/8H+5yHVrJ1zzqqp1Bw=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b="PjZ/NObN";
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf24.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.46 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-3b0b3754f57so1689070a91.0
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 22:47:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1794379635; x=1794984435; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=4EiG4ohiaJ+2VhSrJi2s5uqPv+5cYMcFL4w9Bign1CU=;
        b=PjZ/NObNkZkvR8rXHHTpeGlcA61dUaB3fVYEX+zHr4WfUXTYt9FSgxONdMmDNldtAI
         7Olt3ezqjxh7HXc2L9iafbIUWyG9lN9WIBNOb+CK4UQb6vQIfgGUwN3YIfBDe86DtXtt
         K+bj3MUTeXyoVN45dIrGk6HDXQ9DSzKRvvo7s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794379635; x=1794984435;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4EiG4ohiaJ+2VhSrJi2s5uqPv+5cYMcFL4w9Bign1CU=;
        b=hrR+WLE8B50jc/2A0Z3n1uR1j5D60wBEmVwDb3w2IZJqnVt+MlW2wfIz+nLTszg/Yy
         YxTv/s53ebNULe1ewPgf9BV7fzTbmUBebpbHR4cH40Kz23L5KrSkSiYXoanftnvqVmk5
         p4Tk78e70YkceWVKXMIf7LyOzGUj6gfwYbZ191jacApPLUmor3TFOzKAy4exMllbooeS
         fDhzZS3aXnmAcZl02ja8qFOrjS9JC11vMD+E2517zFMoevX5XzHqRc8oySjkl2oTLYYK
         Z7xQ9EjI/lGnv/KmNT0esttt2Ws47PWpwB+pSocG+FhGELLtKfOcidWTzqWLWHdy5AtF
         rQCg==
X-Forwarded-Encrypted: i=1; AL+hErEh6ilyTM4zce3WJbh9VWmGZ42eJ2dKScVWiuYhY7tEkv2H+wFLM8tuHazCLsa5Pbr+gWbzOsQ7HQ==@kvack.org
X-Gm-Message-State: APuU4Z/TMWAFbEjoNlTDnhD7umLqEs0xJP2AM91QJhXuvRoIUQmqz3kJ
	eRw3wz6Ku3O1YuDxvSR7uRbVm2DtvRGfQXkxNAOD0Vd/bRQp7Iy+NCCl+XveS0salA==
X-Gm-Gg: AYBFou0R4cAukX0Rk4Z8yvLO31dM/R8ZTBw4U/USrlfADtPP1Busxb+sMF85aSPwjoX
	Z9k0TI+Bn79F3uNBPew6XkO9kmhZaiGVXPWb20GLD9JUd8CXMN326DmhRTnNAZSzniiU5+EB0zq
	jSE5auJGjkl5/JZGAO7oHrNJzHmPE/A9+VS7RcG4GbypZMfJJoMKTJuqiEDWl9koxB6VKJyrzDo
	XgpyyPvxOWncjRWW37T0kY0BISvrcy4MMb+nhTB1i0xGqWXd1ZMJ/m16THvrygu1sgv5UR2kzfC
	+rP2UHotTWW7OWzkYTjNlbdPGoKV8pZHqdZ7ejNQfzQwVZ7irgjT2F6aKoDVR25Xcajo4iGnMCV
	JRH9I5q5RiFYZjJl6llgEpLhTNQX/WceXIi4WA5t3G031+1Asu/4oklsDAvDVNqDr6rOFvp9Vpc
	qu1Oht1YcNiAvb+cMZnbwQpkG3u7QQPIzAztoKxtTbAKHwGPI0UBJsE0w/cxLFxgex/dFQPu7YZ
	OE9M7yt6QpUtoD0KZHk1pu28TVNrAw22GiHbXsUDQ0VpOWPI683g2pIiR3BAZwYMxKQQZ5kuEHo
	0nuAjbmBr0Ab9m3ZyHEq2qbZKmnTyVZ4PXuEAs3ZC8UI2Ynpq5FuIswfHH3MxaK6Lc4+KpljdED
	+i9/L1zDi26roPf6JQrw270rBZ5WFbIfwcfwKEGE=
X-Received: by 2002:a17:90b:37c3:b0:3ab:413:49bc with SMTP id 98e67ed59e1d1-3b182ee2462mr1689014a91.37.1794379634902;
        Tue, 10 Nov 2026 22:47:14 -0800 (PST)
Received: from tigeriii.tok.corp.google.com ([2a00:79e0:2031:6:ad6a:b446:df00:78dc])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b17db85a9bsm3268666a91.14.2026.11.10.22.47.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2026 22:47:14 -0800 (PST)
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
Subject: [PATCH v3 00/11] zsmalloc: redesign object alloc API
Date: Wed, 11 Nov 2026 15:46:23 +0900
Message-ID: <20261111064707.2568433-1-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.56.0.542.g3ef89b7020-goog
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: cdx8f8jgamfcph4xi6y56usf7g8m5ecj
X-Rspam-User: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 37374180004
X-HE-Tag: 1794379636-402763
X-HE-Meta: U2FsdGVkX1+LnU5kBpe8hvNlXkXu+meXYZfEkZPJjnYW4NapVLBF+l67wZmW+rPVYxV8jX20l+JmuQR3xVLyuarmBBU/ssXMISsg5Po4ZZGbzNy4VjDYbWcEAv8VLbAPYtRs15ZA0BytAMBeifkoWkrMsdR7fU7zszRsWIIVqwSB4+ZGDen+YT/8X9N9sB86stW5zmURJYYkOfVSM9ZLTSxZL0sKv+eh27+aKei3574FRu8dCEYMkJw6rB22/AzPmzgqLn7AUSPPEN8VEsg8jPlIqHUzmNq02qGXdc/05N3Colqh385oJbIrUP2f4KD3ffhy5pxoFhBlp87eO4SO1GsdEvCk24mvwNj6y33osheAS0OQ4PojFS/hL/vMIm4oFZ6KMRzo/syY5g1NfVslQ1D5egMLDdlcbASfola7KNfjE0wzFjMct65JwZE2BPKIfJZWjFpRUSJnySK64K+xKq6q53R7855qWupJXNKk01qPTvbRH2X5j84CeyRu9ur2VcajT+pReNPB5qiIKr0TMvdb7Ar8iIfekB6QPMC5PTcMz3qTBHLZct/ueUsDf+T4SF1Y3rbPdjXHDByi6kVbWG2SlhAAtxDNJDO6922ADbqbcGTKs4Fa7fBG00dHB5a0CbMFe0PWGEsxC2v9cqhaEWIAW7fgmynijx5//sSf+1NOkaEOKraUdrIwxT+xmOFaBMNTf5Fqc5+2F299C6lOStfFA9mfM9v0MT3q/R7bsxUY9NbDpZCgACZlpLG1xYE9vGd0QNmknWQ8nQFoUJftVdvH/2YiRS0+k1ruegZb/eYO9ksbD7ze5+HvG6cgPFkul6Yp5XDW02VFZZRxFxWImZVXEPoK53ValODqpgSla5bOO0VMSDUmVEqGB7EChml2qKSvigH5HDyhAMvpyxpsYnuB6cBbAA0f1dcnZ1I9n3AZ1Z/xbC/wb+hmrqp8bqkxRN95/AxGqQ4xymqZsaM
 j1lxvm2m
 cz2+df4UOFYkKkD3Y8kd6D3T4pOItqpcj8Lx2JYesQeu9fy14PZzL9War9nBX2ifFZiVfsGmmZLyxf6cyhhpZqoxNZHOWLRRFLp0dcfEQLcooNDYaIgr9MNuBDoXWS0uk5yK/gyJiHY9dswOrWbKLXv9kiNVj9XzHiw2G8xml7aBFXCiAxYgyunDxWddXJleCwom07qL20CJ+yZlGvO2H9bwEEZWWW6wulwmG9QoOOwFpwXE9Op1W0E97OpUpwUC5FrDElcOS6LtdlV54fUiD8U/1R1xT0JNg8wPonTRjedmhAESllHxvrFMFZ/+HaAOAiY8i
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

v2 -> v3:
- addressed Sashiko review: alignment and READ/WRITE_ONCE mem_limit
- picked up review tags from Yosry and Nhat
- added handle validation helper
- change definition of ZS_HANDLE_SIZE

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
 drivers/block/zram/zram_drv.c                | 148 ++++------
 drivers/block/zram/zram_drv.h                |  10 +-
 include/linux/zsmalloc.h                     |  36 ++-
 mm/zsmalloc.c                                | 288 +++++++++++--------
 mm/zswap.c                                   |  28 +-
 9 files changed, 297 insertions(+), 243 deletions(-)

-- 
2.56.0.542.g3ef89b7020-goog


