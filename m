Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09E31CD6E55
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 02:38:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B2396B0088; Wed,  3 Jun 2026 22:38:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 563186B008A; Wed,  3 Jun 2026 22:38:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4524F6B008C; Wed,  3 Jun 2026 22:38:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 32F826B0088
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 22:38:32 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C3C5C1A04A3
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 02:38:31 +0000 (UTC)
X-FDA: 84840671622.10.C4F1FB8
Received: from mail-pj1-f67.google.com (mail-pj1-f67.google.com [209.85.216.67])
	by imf13.hostedemail.com (Postfix) with ESMTP id 1BF8E20004
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 02:38:29 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="cV4Q/uRt";
	spf=pass (imf13.hostedemail.com: domain of chenwandun1@gmail.com designates 209.85.216.67 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780540710;
	b=4b2qE4sWFq6NteYC0M80nkNcCFqzXEmfXXNJbEZNwCiY24YZoBxG1zV0NlNaZNR6QmzrTv
	+Oy2gjhcubm29toUm0fV08yEMaFEqBPqbFhP6py0OavtSLv2Qo1f3LF8IWR/mEMPf+hLaF
	IVsstADeqHU5UvNygUANoLZOljv2PrE=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="cV4Q/uRt";
	spf=pass (imf13.hostedemail.com: domain of chenwandun1@gmail.com designates 209.85.216.67 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780540710;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=HnVgPGbeod1FIMU1/Hr8h7dHeMhQCz5JwUfAc3OgklU=;
	b=rqOeB1p+rvYDMn2LALDCdAm913oX0KhU8PM3AotM/dvFvWcS59mAG341Vt2Ll0G1GLWfIk
	SRJb31FeQBv4h+HLBVPSVO0XGiqMoIA2K+mja3H+tuP1Ng0T6Ufw25NwokrM/uk5298Qk9
	T9x5urpU6WCdGETmEZTifUgEDSrDXnU=
Received: by mail-pj1-f67.google.com with SMTP id 98e67ed59e1d1-36dac5d5da0so80952a91.2
        for <linux-mm@kvack.org>; Wed, 03 Jun 2026 19:38:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780540709; x=1781145509; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=HnVgPGbeod1FIMU1/Hr8h7dHeMhQCz5JwUfAc3OgklU=;
        b=cV4Q/uRtIA58YFdFvXd17kM6TB24oLuX94mq2YCie1FqMey0fXyq3G/5Jsf8XD4ca8
         5WLAyB/9WE3iZ7RJRpluveQNY37tmiM+YwfqM24fzaUTjq9dWXyZh5NolRF4mot59ihs
         cZ2XN5MJqiDQE9Ju3pDL0o+C9DjaP7Ev6URTEG1y4xcTSXEox4wpGRzWe/zZooNOIq39
         bVQRtZvWebnVhh2VUPPS3LDuaaBlKxEaDmmpm9Qqohbn3hx6Qs5BN4pi0Cu1Q68v4M74
         mAPRiQ102PdnxIlqLIFgykPxl1feoEnNuDwXyNBTseHZyPYleoHA5FoJ4qSu5Exkc5O+
         K82w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780540709; x=1781145509;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HnVgPGbeod1FIMU1/Hr8h7dHeMhQCz5JwUfAc3OgklU=;
        b=qV4xzVB6JmTBXEsYZ20MDtmAxIvRx5ljHVOIJZfUnz5yq7906l3ROjlizpzbjOVixo
         twtNEEC+BeiQdUTS/x/uB0y7slwM5xXoMxJUTRb9VA30cL532y38bCRfVLbmzzK6Hzui
         N79+sNGtqR0gOTAwwTe+Q0cXf8A9seFV+pBLxWSc8EEsUgnhrOx9M2Ov7TZ9ojbGhrcm
         ArMPNpVRV5D/+rl8Ytfnym7cyypP2YW5ub3+Tny5KHhOmSBhcvftgC70J4I/vNtl9OZZ
         99bwLOS8q4zQxKhkAptXYszPRecmB8HoH/+4zybTqjTKd5KZXnm7FUh21YKgwZ0Rnam1
         X+ww==
X-Gm-Message-State: AOJu0YzLX4o8YQqiYoCdILaevxndC0DW/LzuoUMAjLCrP6IcGcsuJ3pi
	PmIytG4Qo/paSVNbF5l1v2HN2l7oOWpleOQHOzVC90cdzZXBcxWXBQpAoFzsNKZ0c0e6sQ==
X-Gm-Gg: Acq92OG2RA5JffZuSV2BYcsPdbVMrCRI/DY4ASAWd4deLOunN5SC9qabEUW7qJ/fq5H
	+B+aDwy7/RolSIqqT8ej0rsmBC7Haoc8S/922wr1ixdxYITWBcCNupd3AXyapkOKiixS/t6vNgH
	euFYbGl86NGCZJoFiS3cvu6KeFCvDlEktewq6MUXENU3BTIrsOQ1P7t0FOu3gYkLUBzSQUV3m3p
	MUoJWMazAA8IBUS895uVrp3/1JfJuL736me/812Bq+KAD/urq5IB0dTutUWfdR2unljfHZOM0gP
	G6S/5Lfj1GtczfqjK+L1VXoVhGcFxHN1V2aQG+Qlex97QNQL6us5nOzWq1CTkzDkvKTCuiErTO9
	jT+ctuivpmJzVoLBf8Cw3roTCEvF1HqL7weWXAeuBVdNyyfc5lcD6mxVVdiwvUBhjVqkQwd54mF
	vrEIGSG9VXR6vYtgsvUduzNTRUHPGRHUuWwxskOgJd/qSP8Pc=
X-Received: by 2002:a17:90b:5610:b0:369:7421:b376 with SMTP id 98e67ed59e1d1-36e32949e58mr5612929a91.19.1780540708922;
        Wed, 03 Jun 2026 19:38:28 -0700 (PDT)
Received: from intel.company.local ([210.184.73.204])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-36f6dba8573sm1253072a91.14.2026.06.03.19.38.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jun 2026 19:38:28 -0700 (PDT)
From: Wandun Chen <chenwandun1@gmail.com>
To: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	linux-rt-devel@lists.linux.dev
Cc: akpm@linux-foundation.org,
	vbabka@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	rostedt@goodmis.org,
	mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	rppt@kernel.org,
	bigeasy@linutronix.de,
	clrkwllms@kernel.org,
	Alexander.Krabler@kuka.com
Subject: [RFC PATCH 0/3] mm/compaction: honour compact_unevictable_allowed in mlock race and alloc_contig path
Date: Thu,  4 Jun 2026 10:38:09 +0800
Message-ID: <20260604023812.3700316-1-chenwandun1@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1BF8E20004
X-Rspam-User: 
X-Stat-Signature: sa58primit6xqwr49zzspet98o5dxusb
X-HE-Tag: 1780540709-280764
X-HE-Meta: U2FsdGVkX19ORmd4r/PL4ZrSpW6HBUSTus4wNp/kiE3uF8CPOoxXuVWNodSJqOfaH0SViwP9JpAdwtSlDEmzaj8ycu5bdvMVw/v2BLGpqZeCFF/RRBXCpa6ZG9SPg+havpR8w1cdttTfzvN5Jc99cSdqZvIStpjBuK3tInq4UTJ7PK3uzqBMwIsT57uhlVwy8qCiJY32jN9nIw9+aFp+0PZ3A21jmtInXKI86yyoPPWlGZNLVa66u2bCa/xyLWPWndCS4xBICaMMNWDeOLW7He99mFWFI6eu0ZJoQuyolJp3AdeT1gamWsjHubuAkdoVHYaOeacxLD5AYmItlbNVNH8Ctp9Sn51Wtcl+rfzSWerKPKP0Lht/oMTKid0tkInDBHnMYt4cszTw7r5l3I8PgwMncW9Dsm3NcoYJnO6lwOuNwqFtM2oTC3pH8rCWIsfN4ydHLXlKbNAuU23WLeUSKTM4ElyMtk7xaJQ2dijZggBN/xpbTCtbY5G9iTp3QaGMsWYm86p6Uq+Dv/NOboTHsY8CZCuh2+uw0dIUubh4VZq7XMW7KWclTrbrQi7GKR3aBauE5XMkcVZhQ1sArpgGAoXQnoRphjnSQbRvWWX9i08n8IJ3c54125TxDmadjH4ETMBrdXHpbhwkDYfNnCYfKT3mPA82gx0H9qlmqpWX4qbsMHFN8YlnJn+i4gQwHc5Dt4J/tQv/bY16ds6u3OM57DM3Y0FDL9ztfome3BuQH+uS2WTjUhrWyPY+W5czypfiDJZeKPtcrfFhaaWl9NNhmVHQnwovWad7Gr2s6yhRKWr/GcXw3rqcNT0V9gbI2OwMFGYXbgv+fG6rYy0IAfjgoR7bnqBXzLqczs0pMQB213CzDU98+eSiytQfLj29qTcW6coy+E0YGXHVX6gBEqLGoVLaG0hdRSfowunF8JZPVmh3NsLz82DfbTQrGmcXUpsWXRB5Kp6+xL81p9jutGG
 CF9GMuxc
 01Z44ycODT80FZGXG5TIeHEzvrW2X1LAx0sFtBFD+peFSWjMn79JuojAMChRWnrK3AdXE+Dujq4eZ1BrCwlpWDGuzwBtHoZQrBQu9C4QKJbGNR3NHmExJ0LGc8yT+0QxN9XVyVwtDaZqjQEyU3aGSrOmwL8GyUopG6XUwrv7m9iZ6Q70bB/SuvikOrHMiaokQw1GKeVdK5TpStLlWIt11YiWKBEe4EEkMsWckHMu118IGxZ7JZZhBTeNNHLJ5OtNq46MyFG1+5/I4oAv9ayUAzuMCDCYXl88dQMG45L2bfKcddWeMRF5CkARQ/y+jeqWZrdkRawlQkcdXT6x98Mii3pxhPH+cTK63M5poKIvbnRJ9jg21LqxJGy20dZBKMUIhgmtXaCt8JE9zi1aNlpXoZfPcmr3UcJSL/9ixNDE0jjzdFvlfCxmAM2CrfrQofFfLW219fPZ9N4Kp3en2zFW1A+w8KuevdLiIa8kn3Z/9BvgkmWHvSplHlM43XC2vGDynM4/rM0BCMUGEobaM8J9xEuFVGuHQQniNnVuezYS0m5yo2d1TGC701Cz2josLXDKg7U03Elq2S4iaKow=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Wandun Chen <chenwandun@lixiang.com>

vm.compact_unevictable_allowed=0 is meant to keep compaction from
touching unevictable folios. In practice there are still two paths
where it does not take effect. This series fixes them and adds a
tracepoint to make such issues easier to diagnose in the future.

Wandun Chen (3):
  mm/compaction: skip isolate mlocked folios when
    compact_unevictable_allowed=0
  mm/compaction: add per-folio isolation tracepoint
  mm/compaction: respect compact_unevictable_allowed in alloc_contig
    path

 include/linux/compaction.h        |  6 ++++++
 include/trace/events/compaction.h | 26 ++++++++++++++++++++++++++
 mm/compaction.c                   | 14 +++++++++++---
 mm/internal.h                     |  1 +
 mm/page_alloc.c                   |  2 ++
 5 files changed, 46 insertions(+), 3 deletions(-)

-- 
2.43.0


