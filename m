Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31BCCC61DD3
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 13:00:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B9586B008C; Thu,  3 Sep 2026 09:00:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 390186B0092; Thu,  3 Sep 2026 09:00:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 27FD26B0095; Thu,  3 Sep 2026 09:00:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0224F6B008C
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 09:00:06 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 68385A055C
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 13:00:06 +0000 (UTC)
X-FDA: 85172458812.29.8D93E2D
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	by imf01.hostedemail.com (Postfix) with ESMTP id A1BAF40003
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 13:00:04 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="SVUUa0S/";
	spf=pass (imf01.hostedemail.com: domain of qwjhust@gmail.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=qwjhust@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788440404;
	b=jabjTYs1zxDMCWCs37xTilIuk15iJP6jotaW02MxbeUL+oNMHVGzV1CyOf1N8Ko4swxPFV
	n6mjuORzUs6Cpq4XLpIGJku4RBqQoyOgxALK7etq7T6oSlizc8KPpPUBcBp4+Szj2uXBAv
	7RQeM8HmLa+ZxkOWPiY3YCPcK4RwAwY=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="SVUUa0S/";
	spf=pass (imf01.hostedemail.com: domain of qwjhust@gmail.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=qwjhust@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788440404;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ySykvbIWmO4Te6vIVwftEuMOLYpDg3lGaudbSYAL6eg=;
	b=yfQka4nNjjAKzQcF3rhuYuoYk2bzixTtJcIPk/SQY/SZD0t8/vWwxHjQNFY0F31ycjEOJ7
	zfDZMOHpjL0eeRq8TruYAcEdPUrz+LVKbAWGYYNHHdCiOk5WkPYY5ToZ05OPbW6EvzimUY
	pH0wLuVBY6UxCL5oWCNdVf+JBOwEHxk=
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-84e27035206so2102725b3a.3
        for <linux-mm@kvack.org>; Thu, 03 Sep 2026 06:00:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788440403; x=1789045203; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ySykvbIWmO4Te6vIVwftEuMOLYpDg3lGaudbSYAL6eg=;
        b=SVUUa0S/j6t3ZIwVKkhoDrfG1bkzWkE0ia/dYkD+TaMnz54IYZsEmecv8/MP8x3J7l
         p+KgT52JFYqUwMOhFE+DHtOT3gTuZ7elzjuG77tkDQ+kbvwm1xwZoCrbyARuFTQUl7Jl
         luZfnvY/fFUZhmVFnGXUT2kqfbn9w7xYu7UPxNl3DhURZzEIPlr581JZ1sSEHK+nqPWB
         frjT6ItDLVcJUTGCy6Y/rRErLm/Gys6tF+xHiTeQG8yWHH7I7yly299yoAOyp28YmIrB
         uWTZt9pUC7Yb53v7Q2sBCh05O0xelRBVFSedZUZt2u2lxWXVZgYprNDwB8BbwuMOUcL5
         qMIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788440403; x=1789045203;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ySykvbIWmO4Te6vIVwftEuMOLYpDg3lGaudbSYAL6eg=;
        b=r2E6ITOuZ/j2JQneEfhJ3Q0lWJ4mSh28VI0jdX7h3c/VmRP2pbgxJ770c//NvWtp6L
         1rA2T+IqcC9yhwo2eYY0ZqMbOw0uDhQVeuO134vYco5LHb8E+WBsQY4lInWIAAWhhfWb
         y+Jb+Pjw0DfpiJbLOoLplOBQaMaGmfCumK6IhTCP0KcSCh4hVKc4QaZaN8P/ugLs2XO4
         KbXeLb51CataoQaqI5hn3g2iErcXYHVgot85tlALWU4Nzv2RcjjZ5y9N9GuR71fLVS5B
         yQX+1a3yvvSTQNJ2xo7Hae1LonKUBM7sz7q5L5bUkZw0/svUsKxsD/ul0kdE5UT6P14i
         gNUg==
X-Forwarded-Encrypted: i=1; AKwUvByXRqjSeDBPKkDMGxEkYDqnluU+i1n3AzihPdGQ7R9QW54I25E/5/vBGdm9JjsrGEigrhFjG1Pc4A==@kvack.org
X-Gm-Message-State: AFuF++lS9qbIFZgdVp/WEDou08rl6X+p8JV1VBqu8g9YB0eHG3dz7aDL
	H1IZcMCDNetm1eDlB4ZY/lhFWshVigE+DeTr96DxdbB2taW1LxEaYYst
X-Gm-Gg: AYBFou1wUQJeqq8StmP2KfRTpJ2XukgoGmTnCiXNRlNtY0/Kd2eOdtsNmzKFLMHGdHK
	MYgvFjYrDgur1fJSZx9nB5gS55WwIYCX4Cb92pdfHu2JJntAmnXmKrG+vZYlvr1E6U/hqQzJyID
	szWGQj1awULIObQvNmS0ppZcPiIStlBu/aHMIgy2OkgwxQJCxwO4HdWXKMgfEiKoF8tZlJGPRUU
	vxAA8AgT4bleP83QhCStav3NjXmgMIE8K24Ue51h+2iHmQtOmJnkdAV5UThIvz7k7HNiRBeCDqy
	0CriAbM6AikLt/dGbODNe41fYr4Sp3G1jzH4Alp/jNzUogMWlqBv+MGr3tTZzi6WqyksSCz09Yj
	aHla7NzOPJ4UfUSpY2hGihBSR+8FJgGssWKUmVMX3/x3uv1QYkNZvCJTrBKd6xNgbwFSNmZRc9L
	yqkix8fiCfF6PtsogfOSnjui+yVijRLu77V8kzMJP2ZQyKPyOMYUVQoZY2bsz+gk3QUyAVCQ7WC
	DfwUvb0b795zzKeJAgGBNy4
X-Received: by 2002:a05:6a00:189c:b0:848:4754:28e4 with SMTP id d2e1a72fcca58-85ed3895332mr17366905b3a.15.1788440403103;
        Thu, 03 Sep 2026 06:00:03 -0700 (PDT)
Received: from qiwenjie-ThinkCentre-M760t.mioffice.cn ([43.224.245.241])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-85db23f7bccsm2980946b3a.10.2026.09.03.05.59.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2026 06:00:01 -0700 (PDT)
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
Subject: [PATCH v4 0/2] f2fs: enable buffered RWF_DONTCACHE
Date: Thu,  3 Sep 2026 20:59:51 +0800
Message-ID: <cover.1788438786.git.qiwenjie@xiaomi.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: A1BAF40003
X-Stat-Signature: fc85putg14yqszeazfuf9txmijak49co
X-Rspam-User: 
X-HE-Tag: 1788440404-464132
X-HE-Meta: U2FsdGVkX1/ukQZtzGRNAXXHBHOp6qyynHrd4L0aN+6qcm7jvBwlCfaxSRmRAJxHEvePl8Yd9QZB2954ctxssNz/Vpankfj8GcO5CuMjcVyn5nGuxVKn9iVefrv0oePvs69RbQziAVKTt2ZFCsOD+Le0lloklIZygethuMvYLv2k/8SfI0lN4W7rXytwDq+jnAHPqfr4rd3U3ElE40zqXtN6eeWAgTGLzzsMPJvqXQ3g2+xUnj/PI86RPgYsj8t9uFTBiuv5MChGWGeqNZ48xa6OR/5kfmQOZr+M9yYK5cogDSY39GkiAhERhl7/S1sZ26ihEdzB+4y7DFvtQ2UFma6LPXOgUUUd/Ccs+bJUWzwXkeDgl2iYGA4KCHFzUCIptvu7C44NhbBtsxn2bPP0jaztH3mU9hs+Rf1y+82HmUkuZ5mstZCnsaCRMYhzKq0AZNdbLGPMWbhKtE9z1SeFhheQAGUreeRn7LNgaoCp5xD6OTr+G66XCwnqB9Qep+BprsfiWRpzypwQdCjyMC4oPA47T2AkrRRvgDcgu5a0tVIlRmX7KFrRagl6POm7syzgY+4yYhBUZNGxVjmzbefo4G6v8By9xPtr6GXqpoao/QXJaO8d0XQ77dl4GTsqrDqfwDBqsaTdgNrHwHTWMJA0SNeCYlt/uxMhJOUJfEospT9DdWVs1PbmYqoGCeYwYES5zGTakrwugwBErL15VHz9A3kH4eSDU6OFynFeGRgL0k7yqlXQYSOJbm00imPKVtAADGMGefjMDBT444CbgfFnYzEeW/l2Y61U25E1AYNTWYI/yKuFN2b7MX30say0YE8r9qnP/8/dksB+wLN9eAt4ud4v3rYS9dCL16h4S2yHkziHcyBuBRM5E1obrLTGf5bTQ6QF4GHCAhcmobc+Sotkz9KzpJxYd9DMN5kXR/v2YfI+Tnxq1u+zfkljapHG6gIfMmUsWlQYKNs0LDonkAz
 5J53wbld
 i6oL5Wy+LG+5eJKscMzVMgcyQcIl3qRipswLfLgB5OR4bZSUz1BRpjORNCXZ+uddtbntsPgzvXX0H1npSgwirIM/wy6pa7WKEJPtEvqnitqbLwxkOHQvxMNDBIpgJZgP4tcLERZkulXfNxkWS6CYJa/r87BAFLDm3ngvNhFFlb7+ZAH2I0MbR7IENAvh7FtDAJwGgKZqH/v5XrJMQopjMOJTMxjp9ncIHMco5cm6uvTPzZc022q0iw/Z/cAGSAmX7qoHvsQ544D4WO1UCBF01+Je6jsEhu4rwL0dZgaqleke4Icj/75QslqRm6RY4z8MU2l1pVyEGCtBsEeis1ugIgUmxZGhLd+h0Up5xJCf4UHp268x9eueMlBpGTFsmPagdH1N/XNnxMh9K4hVKazwWWKBy8g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series enables buffered RWF_DONTCACHE on F2FS for sustained one-pass
streaming writes, where retaining the written data can displace more useful
cache.

Patch 1 marks dropbehind write bios with BIO_COMPLETE_IN_TASK and uses the
same flag to keep normal and dropbehind folios separate in the IPU and OPU
paths.  The block layer owns deferral from unsafe completion contexts.

Patch 2 passes FGP_DONTCACHE to the F2FS buffered write folio lookup and
advertises FOP_DONTCACHE.

Tests were run on a Xiaomi phone with 10.7 GiB of kernel-visible memory,
running Android 16 and Linux 6.12.69 with 4 KiB pages.  /data used F2FS.

The performance test wrote exactly 64 GiB per run at 4 KiB,
8 KiB, 16 KiB, 32 KiB, 64 KiB, 128 KiB, 256 KiB, 512 KiB, and 1 MiB.
Two counterbalanced rounds ran ascending normal-first and descending
dontcache-first.  Values below are equal-weight means of both runs; N=2.
The pwritev2() writer models the streaming workload; it does not show that
an unchanged Android application already issues RWF_DONTCACHE.

Android remained active with displays off.  Each run started after a cache
reset and at least 120 seconds of cooldown.  Throughput and one-second
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

Dontcache left zero target-file pages resident at every size.  Normal
retained about 1.19--1.24 million pages.  Normal runs incurred roughly
15.6 million kswapd page scans and steals per run, while dontcache recorded
zero.  Direct scan and allocation-stall deltas were zero in both modes.

A controlled explicit-dontcache model issued 64 KiB writes for 120 seconds
at 64, 128, and 256 MiB/s.  Both modes sustained all three rates in both
rounds with no final schedule overrun.  Between 0.02% and 0.41% of writes
completed late, with a maximum schedule lag of 3.3--6.0 ms.  Dontcache left
zero target pages resident.  This was a controlled model, not an unchanged
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

Changes since v3:

- use the common block task-context completion infrastructure;
- rebase onto the current F2FS development branch based on v7.3-rc1.

Wenjie Qi (2):
  f2fs: complete dropbehind write bios in task context
  f2fs: enable buffered RWF_DONTCACHE

 fs/f2fs/data.c | 27 +++++++++++++++++++++------
 fs/f2fs/file.c |  2 +-
 2 files changed, 22 insertions(+), 7 deletions(-)

-- 
2.43.0

