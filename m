Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20F24C79F82
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 03:55:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F222E6B0093; Mon,  7 Sep 2026 23:55:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5D6A6B0095; Mon,  7 Sep 2026 23:55:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD9A36B0096; Mon,  7 Sep 2026 23:55:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9F6AF6B0093
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 23:55:55 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1D50D140363
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 03:55:55 +0000 (UTC)
X-FDA: 85189231470.27.3157AB5
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf24.hostedemail.com (Postfix) with ESMTP id 45F12180002
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 03:55:53 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="KKWrT/9g";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of qwjhust@gmail.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=qwjhust@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788839753;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PPQzWxuhw7pZTs+zszzFmSn4KI/x61XrCe5D1SPsyZk=;
	b=umuIprOy4NDVBTbFd3ivmLIErBME4Gt2XVANkEgDj/8pEU2dN2SzWyheIRCnnWzHCZKvb6
	eeqaDewzyyUfXIBo6ZlBZIZi5XZuslyKxrfxJIHcqj00/x4Q7lFb8MA5jWk8b7MhoIH/Ef
	r2fdneLK84Q9oRtrj9EDj8kAK7mKXnA=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="KKWrT/9g";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of qwjhust@gmail.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=qwjhust@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788839753;
	b=J00bALQ0fQJQ1MAfBXPgZzG3+o+5pwxZhip1gnMHyJRNjZZGuCMw35NBe/XtoYiuJvctnU
	o0pwbkMr5XKZRPkzP/+LImi+XmNN0IXy4ya18P6FJPclRpw6KLYx0lz/cLvZqAlZsOLNZr
	QSlzNCNPkF+thtVdDVwDjPrIg7VfnfQ=
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2d944747d41so43408085ad.0
        for <linux-mm@kvack.org>; Mon, 07 Sep 2026 20:55:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788839752; x=1789444552; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PPQzWxuhw7pZTs+zszzFmSn4KI/x61XrCe5D1SPsyZk=;
        b=KKWrT/9gkqkSPOLGQdwvrUnplMabJrGr8ovQ0YoCR7UIHtOV9d2H3Ojj4Nc15PdT0E
         z8TgFYN4rkQcMWk1C+S+FyGLIdOL8GoJAOpkeTGLfFKwCOEQHHs2tShE+L64KQVH2WT1
         lLL8B8ux3X1U/SBDongDD7IHayMhY7EQzCpvm9Qd9w/jRTDMhwccqUw1ubbn8z1I4prZ
         KMFgwrH3T1GxvCOrzJfpAmA5u+SjlS4C4YVR/B8fl8gnbhH5TfZiBJu+w+yYr2xTSirj
         BOYKR/WZZyDw16HUVIJVR5U0cjiuxtxoi3hJESZKGAT8A4BAuT7yyx13vRIpbAgCiS+I
         sxog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788839752; x=1789444552;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=PPQzWxuhw7pZTs+zszzFmSn4KI/x61XrCe5D1SPsyZk=;
        b=EcuqXYwHL8C4x8Z1XFTK/85tQ9cXaEQ7ivlgn2lcDEJU6bqidWKHNrC3xk998cYmAg
         mZWacZpZx3sAvc8MR4dnGXXFEMOSDZEcRYDSbeC0Nfqm2M67zlxHGmWArBFJuClk92bd
         X1J0ag/7I4oEhOAKgRmU9HCCeGPW1j7KVVMoXaxMhK+ZjWyvHuCOUpHOuddhyh+x6u0V
         CpRE1uti87Z3KaP4movQfY0fTIqY8FpgIfBS1aRp6OE4qzo1ouLAjltWCsnQPa0OpWLE
         VMkzsy+zrE8R9KXI6nCgFWT7ur/vsbJoLB/3+K1LXzJTE/Zg3nJLteSVn7H369C+w0Sn
         yPLg==
X-Forwarded-Encrypted: i=1; AKwUvBxdIm+kB/4bSlxH/SeSyn4YY/RQonlWJjdALtwKxYq+EamAnDGDqLBymi2fRSShO2hW7VzycwQJsw==@kvack.org
X-Gm-Message-State: AFuF++n90L1MWZy87ZL54Lo66qdrk8mgT0bxtefX59qOWJf4sTgKh5BS
	JbdPAFI1l8NuqjNZ238rJnB6sQweydowKIlXnmG4TMnyLHxKz725UuNa
X-Gm-Gg: AYBFou271xHFpBqlBKFGaKTSE10Az5CGrNQvDDjEyhMzWcxD+7YZKN2HfDdHFhv9xjG
	rQb0w7ZNd+gIcPVmios0dlUUI2iraHpENgyMRzhNo3MkdcLkS3zr79vK0KA916zn1OvhZICIbof
	cw4u/epA3jG5vw3HlzprQj79em8PeOv70a78enH8H6SXrjVNPOA3cPNl4V9jE+VQCm/M/fVkcye
	bItPO6gYWrOrbGLEePq8+GF6JfS4QLomrdVz+50gXCxQz2ryo9HCU/NYoYCROulQaTAhFnQY4GE
	DPBDtwzTSewE5TpEwQu0AzVif52Yk9XIO2c7fWj3+Gcd9ENuyJUcAkCoUjoCS9vquiMzgdrO05t
	daB3xQp6T/MoyzterqKMhTRSxb/IhDRIf37K9B6yrJf3UxsI6GDd+2H+kBNMvbRpYyoAJK3v4dC
	7Dy8pImqUAA0/8MAJpLlSx0QY40+nQFM1IMie+VsKdUv3xLkW6Bd4xecBPU+mV/2ByNDLBoMAla
	Qgll99k95YuvqwkLjxU8dgM
X-Received: by 2002:a17:902:fdab:b0:2d9:599e:df95 with SMTP id d9443c01a7336-2db122edaa3mr386816705ad.3.1788839752025;
        Mon, 07 Sep 2026 20:55:52 -0700 (PDT)
Received: from qiwenjie-ThinkCentre-M760t.mioffice.cn ([43.224.245.241])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2db14aeaf74sm51899295ad.81.2026.09.07.20.55.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2026 20:55:51 -0700 (PDT)
From: Wenjie Qi <qwjhust@gmail.com>
X-Google-Original-From: Wenjie Qi <qiwenjie@xiaomi.com>
To: jaegeuk@kernel.org,
	chao@kernel.org
Cc: linux-f2fs-devel@lists.sourceforge.net,
	linux-kernel@vger.kernel.org,
	hch@lst.de,
	jack@suse.cz,
	axboe@kernel.dk,
	tz2294@columbia.edu,
	baohua@kernel.org,
	linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	qiwenjie@xiaomi.com,
	qwjhust@gmail.com
Subject: [PATCH v5 0/2] f2fs: enable buffered RWF_DONTCACHE
Date: Tue,  8 Sep 2026 11:55:41 +0800
Message-ID: <cover.1788795700.git.qiwenjie@xiaomi.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1788438786.git.qiwenjie@xiaomi.com>
References: <cover.1788438786.git.qiwenjie@xiaomi.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: m1z8omzeuc6bq1rzijyi7bc454s9nziw
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 45F12180002
X-Rspam-User: 
X-HE-Tag: 1788839753-943833
X-HE-Meta: U2FsdGVkX1/HDXe6w9Li1gkX1XCa24RpxRevcWr8WLNhLRhGSJ2xfdbirzpCMVm5RRz2YSKriv1jwz6MPxYIkio52yFEGAu7NESQ4YgsuxhIQCLLs56nHkJdYYj0zAucrUFGFXQI9xTqTRk5yDMZ2Dam6gMMya131TzH3kjJwxTZ82i2ATwerMVU59V4MCXlSP+kkvyCgMbSxLqCgA8aI1SkkHad0cLpwWoHNpsADtw7BsaeMXKCkFrWuwgAQu4HU+RYon9BVRba2qYyhpRN3tfTO916a99N4hXzrYKfUVMGhFsa0cdtMCUEACsjLHIyD+9EHFe/+xH78lFs2Ibelu4VNSuEE7GSpbTl9tLCJUSdogkvrrev9azhbOH/VojMHqaAhVHXCe2FEoslOh9bxfLBf8nah5DkSK+DBig/ACHGft/c7EjvgZdyhLo/Km/6VnrlMQdTD/6ylhnjQgn0pEw52SgtPhDpwO5Kd9cTb9Icht94+Eiu4UsRUd80+QGy6pQO7R20dOmjMbGnuQICQFnzWurJO7vU7SB0b4qK1vCxEJJ5dopIa7fuD9X10nW1V+9IfeaY0JqFUF35Z0UsZHCEYKC5RDQyLUbJMsi1wh8pptGuSPMP1xo7ecWGq9MPz9EodiMra4WzSfNfNGubtJPdDURDL1J0f11PK/tWa/yL/yjkJAsR4HzCghrst/VXWpUVgnMKwceuRdTc5AQ/5Pmw+vgrmThXWSyQvRWhRJFzflOR9jzQnc31s9PVFmLNIQaYCsHMSBsp29tcsLofECXuXNvsEvwIDZSIMF+OS6bgVoDK0z2B36jB3XLY7PnCQ77lkwGHOZ1rSjQgrMKQuXotCLRiD9kq2ZXpuQq9ej8ycPKkJn3RRc49PchbZxYOxDtbvVQ38HWlW/QNBgPclRo9OB+YtZu37emwD8isgKt4jNSgGoOvk1Ic3Vb/+pt1H+iJkCWReoZVdQvaxUz
 S2poo2av
 19cT4ldZvq01PhJEJa6aFIXKnCSFlnnBfKvEcven/HZmEir0YEPTdy3ZWz0qQ74x4Oftya4Ee/7RqetBFTAGDjyOXQW2bsnz4VBLRVZl6FEVHWGc7wCj37B74HUAfSk1nN7fS52iWneQMRWRCFoNO1GBkcbYvd1HLhFOEGQ2V4MdTz9n8xKxYmts0lsHLJHcZyocVfC2wa3m0r+k8EEPOM4MWiLcbNewKzz5vGg1TGU1njQBHsmyzPR19Kp7K8n0F1wwemFu6Cieqb052filDT6TwmONCm092STvDawlE/evt+B83Qup0Nn4plHJ8BpkUOIqYY0DvBXscvSy5a3Hxx/uYDT3WG7tAqU6g6CRyuzkWTGXv6f2HDgR9+vLFakSLrtafGk+dbGpHpSCcWdCCkFrjbw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series enables buffered RWF_DONTCACHE on F2FS for sustained one-pass
streaming writes, where retaining the written data can displace more useful
cache.

Patch 1 marks dropbehind write bios with BIO_COMPLETE_IN_TASK. Normal and
dropbehind folios may share otherwise mergeable IPU and OPU bios; the flag
is set monotonically when a dropbehind folio joins an existing bio. The
block layer owns deferral from unsafe completion contexts.

Patch 2 passes FGP_DONTCACHE to the F2FS buffered write folio lookup,
advertises FOP_DONTCACHE, and handles internal write_begin callers that
pass a NULL kiocb.

Tests were run on a Xiaomi phone with 10.7 GiB of kernel-visible memory,
running Android 16 and Linux 6.12.69 with 4 KiB pages. /data used F2FS.

The performance test wrote exactly 64 GiB per run at 4 KiB,
8 KiB, 16 KiB, 32 KiB, 64 KiB, 128 KiB, 256 KiB, 512 KiB, and 1 MiB.
Two counterbalanced rounds ran ascending normal-first and descending
dontcache-first. Values below are equal-weight means of both runs; N=2.
The pwritev2() writer models the streaming workload; it does not show that
an unchanged Android application already issues RWF_DONTCACHE.

Android remained active with displays off. Each run started after a cache
reset and at least 120 seconds of cooldown. Throughput and one-second
kswapd0/global-memory samples cover the write loop.

Write-loop throughput was:

          normal MiB/s              dontcache MiB/s
 I/O      r1       r2      mean      r1       r2      mean     change
 4K      946.28   935.74   941.01   291.36   309.31   300.33   -68.08%
 8K     1077.05  1105.84  1091.45   477.79   479.79   478.79   -56.13%
 16K    1126.84  1118.49  1122.67   643.40   652.06   647.73   -42.30%
 32K    1150.62  1036.33  1093.48   762.24   751.45   756.84   -30.79%
 64K    1144.80  1163.82  1154.31   852.11   851.19   851.65   -26.22%
 128K   1166.29  1162.84  1164.57   867.47   865.05   866.26   -25.61%
 256K   1153.61  1172.78  1163.19   895.53   885.33   890.43   -23.45%
 512K   1173.61  1197.34  1185.48   903.09   903.01   903.05   -23.82%
 1M     1126.22  1154.59  1140.41   850.74   894.60   872.67   -23.48%

Average kswapd0 CPU and average global Cached were:

 I/O      kswapd0 CPU, normal/DC        Cached MiB, normal/DC
 4K             18.45% / 0%                 4830.15 / 686.56
 8K             21.60% / 0%                 4862.35 / 591.48
 16K            22.75% / 0%                 4905.47 / 625.07
 32K            22.05% / 0%                 4945.82 / 561.59
 64K            23.46% / 0%                 4920.77 / 639.78
 128K           23.16% / 0%                 4971.37 / 693.26
 256K           23.68% / 0%                 4956.93 / 668.60
 512K           24.25% / 0%                 4972.22 / 663.92
 1M             22.01% / 0%                 5001.09 / 705.30

Other global memory means were:

          MemAvailable MiB       Dirty MiB          Writeback MiB
 I/O       normal / DC          normal / DC          normal / DC
 4K      6513.08 / 6382.31     640.48 / 33.93       37.94 / 0.09
 8K      6560.77 / 6529.33     690.89 / 43.57       40.84 / 0.54
 16K     6587.46 / 6519.94     789.16 / 62.67       61.58 / 4.64
 32K     6571.95 / 6566.74     850.48 / 69.14       67.69 / 9.24
 64K     6600.64 / 6559.89    856.97 / 134.28      59.60 / 16.19
 128K    6627.03 / 6465.10    873.68 / 137.57      60.57 / 41.50
 256K    6615.58 / 6541.09    885.98 / 158.15      61.25 / 29.57
 512K    6625.52 / 6534.41    900.65 / 139.07      63.65 / 30.35
 1M      6677.09 / 6539.89    909.70 / 187.56      51.58 / 33.46

          Active(file) MiB      Inactive(file) MiB
 I/O       normal / DC             normal / DC
 4K       279.57 / 264.13         4426.38 / 183.12
 8K       262.32 / 260.97         4472.62 / 182.19
 16K      392.09 / 252.95         4392.78 / 195.82
 32K      254.30 / 248.44         4554.18 / 187.34
 64K      252.73 / 244.94         4545.40 / 267.28
 128K     322.02 / 243.95         4530.63 / 298.91
 256K     245.47 / 240.02         4586.64 / 303.92
 512K     254.75 / 232.05         4591.17 / 288.27
 1M       238.88 / 233.64         4638.81 / 341.00

Dontcache left zero target-file pages resident at every size. Normal
retained about 1.19--1.24 million pages. Normal runs incurred roughly
15.6 million kswapd page scans and steals per run, while dontcache recorded
zero. Direct scan and allocation-stall deltas were zero in both modes.

A controlled explicit-dontcache model issued 64 KiB writes for 120 seconds
at 64, 128, and 256 MiB/s. Both modes sustained all three rates in both
rounds with no final schedule overrun. Between 0.02% and 0.41% of writes
completed late, with a maximum schedule lag of 3.3--6.0 ms. Dontcache left
zero target pages resident. This was a controlled model, not an unchanged
Xiaomi application.

Buffered read throughput was:

 I/O       normal MiB/s   dontcache MiB/s   change
 4K          1825.50          1695.10        -7.14%
 8K          1901.46          1847.96        -2.81%
 16K         1941.60          1872.55        -3.56%
 32K         1960.95          1905.92        -2.81%
 64K         1951.35          1886.54        -3.32%
 128K        1960.03          1915.82        -2.26%
 256K        1976.01          1900.41        -3.83%
 512K        1973.31          1911.24        -3.15%
 1M          2230.91          2007.82       -10.00%

Dontcache left zero source pages resident in all measured read runs.

The normal-I/O control showed read-throughput differences of +0.67%,
-0.90%, and -2.58%, and write-throughput differences of -1.75%, +0.33%,
and +2.33%, at 4 KiB, 64 KiB, and 1 MiB respectively.

As a separate memory-pressure supplement, I tested F2FS on x86-64 QEMU
with the F2FS images backed by the host NVMe. Each run issued a 1-GiB
homogeneous sequential write using 8-KiB or 1-MiB I/O. Normal and
dontcache each ran in three counterbalanced rounds with
memory.max=255852544, memory.swap.max=0, and formal tracing was disabled.
Values below are medians of three completed runs.

 I/O    N done  D done   MiB/s N/D        memcg MiB N/D
 8 KiB  3/3    3/3      236.259/227.634  160.867/2.075
 1 MiB  3/3    3/3      222.232/859.805  155.178/9.098

 I/O    scan N/D            steal N/D
 8 KiB  270,821/0           201,227/0
 1 MiB  344,267/0           201,013/0

Scan is the number of pages examined by reclaim, while steal is the number
of pages successfully reclaimed. memcg MiB is average memory.current.

At 8 KiB, dontcache throughput was 3.65% lower. The paired changes were
-12.7%, +65.8%, and -3.65%, so the direction was not stable. At 1 MiB,
dontcache throughput was 286.90% higher, and all three paired changes were
positive: +96.1%, +257.8%, and +295.8%. Average memory.current decreased by
98.71% at 8 KiB and 94.14% at 1 MiB. Dontcache recorded zero scan and steal
in both profiles.

Changes since v4:

- allow normal and dropbehind folios to share write bios, following iomap,
  and set BIO_COMPLETE_IN_TASK when a dropbehind folio joins an existing
  bio;
- handle internal write_begin callers that pass a NULL kiocb;
- add QEMU memory-pressure and mixed-bio measurements.

Wenjie Qi (2):
  f2fs: complete dropbehind write bios in task context
  f2fs: enable buffered RWF_DONTCACHE

 fs/f2fs/data.c | 15 ++++++++++++---
 fs/f2fs/file.c |  2 +-
 2 files changed, 13 insertions(+), 4 deletions(-)

-- 
2.43.0

