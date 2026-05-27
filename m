Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 129B2CD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 12:01:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 62F676B0093; Wed, 27 May 2026 08:01:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 607166B0095; Wed, 27 May 2026 08:01:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 544986B0096; Wed, 27 May 2026 08:01:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 43F056B0093
	for <linux-mm@kvack.org>; Wed, 27 May 2026 08:01:38 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F310B90148
	for <linux-mm@kvack.org>; Wed, 27 May 2026 12:01:37 +0000 (UTC)
X-FDA: 84813060234.11.F271085
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf28.hostedemail.com (Postfix) with ESMTP id 1DFDBC000B
	for <linux-mm@kvack.org>; Wed, 27 May 2026 12:01:35 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mADDvxkL;
	spf=pass (imf28.hostedemail.com: domain of haowenchao22@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=haowenchao22@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779883296;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=UH1N0NOamh9kJ4BcFKC3HtiFonlBtglJgKM2R0Sxie0=;
	b=M9hyO3PNtWhX6MVY8C8uSM8OTO9gTyFRfL8a1W7QybCenuqup74PcVz5EWhItX7HiamyYs
	Jy4sza11gZ5/ftHKTdSZMomeF3lgMN69CYFfHWf34DO/vKEro+Nyo0fJ3O//PCeP7U1bTY
	z7FgsN8bnrR6uHimcauX8jGl85/tPPg=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mADDvxkL;
	spf=pass (imf28.hostedemail.com: domain of haowenchao22@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=haowenchao22@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779883296; a=rsa-sha256;
	cv=none;
	b=XjTFVjt1hlCtEOrsyxv4t6FuxgM80zIxj3TwI+6Oi95Sm9jpdDjIT+CSkW2nHWgWENXXP8
	cD39ev9DsZMrKX/vtqBkwXxlnfeaHE2tE8HWkGDRf+E3VmM/tElSEtNm0Vx+nXmeFemxqJ
	ZeAhHPogULBKpSyxBcTJFG+kMwhB+3s=
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2b788a98557so74928505ad.2
        for <linux-mm@kvack.org>; Wed, 27 May 2026 05:01:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779883295; x=1780488095; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=UH1N0NOamh9kJ4BcFKC3HtiFonlBtglJgKM2R0Sxie0=;
        b=mADDvxkLE9Qs0i1OSs4tqX3vNgMNknz2MLTDVtAVntVMjpd7RH9Lq7Mgmu7dLJyKkk
         M3xz6DqUsOYH3kovyXIFMsy2OqSqNdxcg/2UVEDWkTbWYq/MuMdAkFN/ds2h6jvRzpuX
         LFnoXqsrSWNl0d05x4YLgb9UkgfrWtCVpk+2iNaQoxAnfn9se+EmCb2QONvz89LdkzTo
         aGRdo3l2f2WidZfj/O3jbdmfLqDMCcomE6k9DYFgCr0dec8kZisjock2w42GLd+ZlD8J
         eh4ki38YFA99fF/d049JFbJLezXuLaarT7kd7CSMWKDEMQ7+sVLKuuWWlzWy9AYciLwX
         IY1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779883295; x=1780488095;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UH1N0NOamh9kJ4BcFKC3HtiFonlBtglJgKM2R0Sxie0=;
        b=mP3rEToeSbz1i5/04R73U/vJHlgZcTpIAwwGrSmPvbbiFVIp0hVa8jSqCp3+022/bP
         sZ4HbUZgLJuwzLTbTe+UXH8GPrPIpWTLL0UY4UuAzJpjWUMeRxgDewM1lMRGwdlGw+Iv
         /fSkibhRhdKlZqeh1UAomqdQLt8F2sTXxAdws1EyFV5jQGCudbIkBPcb46ikN4x59/ln
         kQyy53ojYyec3VYSox2cWxkQQBGT9yeCiF/lPwl4XAMdt1znDvAllszUmBULuGTZtuX9
         5DgclQeRVICJqvxBRGHUjWZlJNdrIG6kG5E48NmA0cW4sfcPHiHvnM04vm59wn3IBfby
         YpXw==
X-Forwarded-Encrypted: i=1; AFNElJ/5hVP12J07uziKOhx0besPgb0iM33B0BLOMiQyI4xQ7NhXFYAciRdtFeUZQJ0bOwxUHm+Z4Tf0tA==@kvack.org
X-Gm-Message-State: AOJu0Yzv9pTPPW0w0PwNjvKVkC+Ph1HRPD+rNzVVmR68GRrEEWYkUPqt
	cImbrA545qLd3aNC0ffkcUjnYXnQOU8ke8OOyq3lQWH4CFhzeZ7clK0ChyzXXg==
X-Gm-Gg: Acq92OEVFdtRYQRRdXQ3jmSIcwFKGoTdD7HWN87CG4UEx6kNvsXgfSeMpHwsYCv8NbR
	MszB8uGvvmzgQf/gq1b1qOfXKuAXTMkjDmjHN57pazQcGTZj1ASI50N1L+yn2qWZ+g9o1Tm901L
	BlGNXR9K4Y1SUw9vLdo+OqDi8vVBDyDNGpuTRqgTajSABtInj57144Ur+JZMQRYqIgRnkaDVhpG
	HMu76wzyItKkXdxcmz7f+y4vT5iY4Sgrx+3gfWaphfsUPCek9ZUszMzNQz8I0xOFmNfDbkKcLZk
	2V4iwNZtn8FCwIVtuoNoRz/72DzcQf3/i2q/b03+mnsF72dXQK4P0Nb94sWSmJc7iePAL7pd8Li
	W7hdyVFAWtPr+0tmZfUZWfhpPyoann/2Q+AgeBprSKCzLWA/U7qxCU9wVyIZM/pTbc/Hb9QuL3B
	knDJPARSPZ5lnz0uTyLyBrChbNolvMB3fgvyaUelNkM/NRS9Tm
X-Received: by 2002:a17:903:11c6:b0:2bd:3bfd:7512 with SMTP id d9443c01a7336-2beb065b6edmr249502705ad.29.1779883294834;
        Wed, 27 May 2026 05:01:34 -0700 (PDT)
Received: from ubuntu22.mioffice.cn ([43.224.245.232])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2beb56b5886sm136250465ad.20.2026.05.27.05.01.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 May 2026 05:01:34 -0700 (PDT)
From: Wenchao Hao <haowenchao22@gmail.com>
X-Google-Original-From: Wenchao Hao <haowenchao@xiaomi.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Yosry Ahmed <yosry@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Wenchao Hao <haowenchao@xiaomi.com>
Subject: [RFC PATCH v2 0/3] mm/zsmalloc: reduce lock contention in zs_free()
Date: Wed, 27 May 2026 19:59:27 +0800
Message-Id: <20260527115930.3138213-1-haowenchao@xiaomi.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: a87jzg57dsb8ajdhk8edhm6kgnmsjn3t
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 1DFDBC000B
X-HE-Tag: 1779883295-987266
X-HE-Meta: U2FsdGVkX19mHSbPBYObw2MOrlNXqDbvNIjgR7gb7rSlNRyHhwMVCJBfLy5ti+e+sxaVadNsGPyMU+ZFmpifCwm9kIy/Yl6Dr04EILNcqZ8CAshsAM3KwiW/g1EezU8azAUsiGKydfuKTViXDy5f4QSKltIQ3vmXgpfUG6WXbAggUb0MPdv9swGp+j7/HltZlDmz1efoVrx2OJzE0t98B2hQyMJH7IKtOpUyYa0vvW1wti081KnWSr/GbjRD4b9rXRBEcs09CIAIEqCK1/k5+CDpUVOsAx8hn3gi2QQRPMkvJE9FrjTncwzNxEjv/aDMfTZXLokvMkmGmmnc1XPQ8gajXFDrRu93Hh9dgF8vj8sxlOxfLV8DlQByMz9dPnFmP2o3M/elyONYths/bt0HMbdLgCQA0dTYBlpz1ejKJvZHlHijW+T6evIXTqtIobcoXBrnEFGX7bBHEBM5CplpK2lAcrHM6qoGcIA49932DPWCalZFfJuiBV5ZbKQDu0xtAoc9FyJKvJ4P4nlus7SES3TsPfiyrXbt+TghkWJXHDFIZ7TzORPjofkB2oU7zz+xGJBWgpvcWLUJ3MEmiUZW0aJ0wIywfo8ZhUiNJNL2+P0bePksDiqXRTTIdMRWdvz6C5NKlE+31m6zz0+vOs81lDlNn1i4WaOrEuixshXAmHJ0EgxWWPgYVDN6dchx5lk6W6ph7g7F/JmA672s7wPV/ofNG4oexITjgWcpbCioViLCakO9VUBoeaq5a9ioNi+OtGXV63V0SqHDFoVdtKrAn3YpCNgiabCxOoof7IqL8nOvmUSUw5EgKik2oMzJ/m8hTaWpEPpLvCRsWLJkHRxfHHKfqbFoNPjmFW6KMPL3kkNO2oYQkn9fm6kUiCyKG6xD5Zrd5ZGiN3yCu0wtgKWxLFOVtUrUquAGemBsfMajux3usoahSazm9qBJVDRLcz5ZxeF8txRSfrau+87evHs
 l2HG1rQJ
 GZW0L/4zo26UnfmFAfMy2pJeJj77mHhq+wdYXIMhlpFetls7SbR3439r4h2+2sNfrXRMRPelQvdiGg/NfOwUve/RySJw3OhpCn30ZIlQrt9TtPeBgrX6GebwL1Fd6YnVfoQBI4knCf2ikDB6RTUjIyj3Zapeh0s+s7BkmeNBlDl6Yhhp3fO73u2H2Epya96jaLN2t73+QRBwiugUMSE39VkOwAlFggP+LkJLo1U9NQlXaa/AbbVoIs+JCWZc2hH0EAnNusud/oDyYuflvD6x5sWG/NYazUsnO/yDLNweSoE6MG0NWOViZPPxjbWvkaZ+fvwNRGsZfzF2r6SVTjKsBmCTndj7GUOHFKMXLJ70Qw7IQmZlisD4iST0Ij33P7zYXlpGUqMzQNcAuZDA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series reduces lock contention in zs_free(), which dominates the
unmap path under memory pressure on Android (LMK kills) and on x86
servers running zswap-heavy workloads.

The current zs_free() takes pool->lock (rwlock, read side) just to
look up the size_class for a handle, then takes class->lock and holds
it across __free_zspage() which can call into the buddy allocator and
acquire zone->lock.  Two costs follow:

  * pool->lock reader-counter cacheline bouncing among concurrent
    zs_free() callers.
  * class->lock held across folio_put(), so any zone->lock wait
    fans out to every other zs_free() on the same class.

The series tackles both:

  Patch 1: encode size_class index into obj alongside PFN and obj_idx,
           so zs_free() can locate the class without pool->lock.
  Patch 2: drop pool->lock from zs_free() on 64-bit; 32-bit unchanged.
  Patch 3: move zspage page-freeing out of class->lock.

Performance results:

Test: each process independently mmap 256MB, write data, madvise
MADV_PAGEOUT to swap out via zram (lzo-rle), then concurrent munmap.

Raspberry Pi 4B (4-core ARM64 Cortex-A72):

  mode        Base       Patched     Speedup
  single      59.0ms     56.0ms      1.05x
  multi 2p    94.6ms     66.7ms      1.42x
  multi 4p    202.9ms    110.6ms     1.83x

x86 (20-core Intel i7-12700, 16 concurrent processes):

  mode        Base       Patched     Speedup
  single      11.7ms     9.8ms       1.19x
  multi 2p    24.1ms     17.2ms      1.40x
  multi 4p    63.0ms     45.3ms      1.39x

Changes since v1:
- Rename obj-encoding macros for clarity.
- Make 32-bit / 64-bit handling transparent at call sites
  (no #ifdef in callers).
- Extract a helper to keep zs_free() unified.

Wenchao Hao (2):
  mm/zsmalloc: encode class index in obj value for lockless class lookup
  mm/zsmalloc: drop pool->lock from zs_free on 64-bit systems

Xueyuan Chen (1):
  mm/zsmalloc: drop class lock before freeing zspage

 mm/zsmalloc.c | 175 +++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 143 insertions(+), 32 deletions(-)

--
2.34.1


