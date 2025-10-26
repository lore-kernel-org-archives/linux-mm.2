Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A113DCCD1BF
	for <linux-mm@archiver.kernel.org>; Sun, 26 Oct 2025 01:05:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E0B9B8E0159; Sat, 25 Oct 2025 21:05:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DBBE68E0150; Sat, 25 Oct 2025 21:05:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C84068E0159; Sat, 25 Oct 2025 21:05:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B2D598E0150
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 21:05:50 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6EB5B1DCA14
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 01:05:50 +0000 (UTC)
X-FDA: 84038473260.03.775D891
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	by imf21.hostedemail.com (Postfix) with ESMTP id 9AA381C0004
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 01:05:48 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=T8xMrEbt;
	spf=pass (imf21.hostedemail.com: domain of jinji.z.zhong@gmail.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=jinji.z.zhong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761440748;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BrWku1aIMMMg9GTv7ArefROi2Vd01OtJJzpQozkukKo=;
	b=davQqZXL43d7fpckoDBTD7Y6it4pwaFxmVV9XOB+RWmR772QXC3JfJc98U7tcjWsp4Ns4A
	mO7VJykbFlILCcQD/rK23aZukOC0qy851s4aAZwcn+wMXcWbpkNpx1qlMJidBxoLNR9J5V
	G7y5miuUZ29V42UqPUgYMjndIKVXeEQ=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=T8xMrEbt;
	spf=pass (imf21.hostedemail.com: domain of jinji.z.zhong@gmail.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=jinji.z.zhong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761440748; a=rsa-sha256;
	cv=none;
	b=7uAV8GZWHQu4q3qBY1n8FoNEEg+2OUwTfK+ZegmKN4aiSD+4wlU8SJsnojOIq/wnRfwFBk
	qr2t/NN02n486n/L0ijskkTW0Zhvsmzkv8CAwdmiiKZGmHnyGVZWZe0QkAyg+wf6Paezpc
	xD4iyPWjBjhL8KbBIY7prXUV13Y8gXA=
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-7a23208a0c2so2614267b3a.0
        for <linux-mm@kvack.org>; Sat, 25 Oct 2025 18:05:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761440747; x=1762045547; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BrWku1aIMMMg9GTv7ArefROi2Vd01OtJJzpQozkukKo=;
        b=T8xMrEbtGNUBsr6/GXiTJEQkXnTrj6bJcJ1GmdsjSGTRIS3qNtlUxd5iiuMEchfaZF
         8XskjBlAPmQXEy37NtIZNog3xDNwCyq9NMdmtbi0GI7ppZPKXLdrzp06NoY1WyHtmYiM
         9tozb3bcwWwhKz3p08bGVhZYefiuziH09dlwaX7pBR9D+jaAcGtqi9qOM2w/Pu3OItfy
         sk3RPO4Y8M6DWuDsobqU0w4DpfL+CHChHjQeDD0ELbSmfkJoSw0IedW04Rzhuo8bbtPU
         k2ktCeM/54rxpAH2PJPQpJ0rb5e7e+az4GhdRKJxOml+c5vOw83a9g0IxYtkVvuTBt5g
         EA4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761440747; x=1762045547;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BrWku1aIMMMg9GTv7ArefROi2Vd01OtJJzpQozkukKo=;
        b=Ocl7LXRB/L3urEZ714DDlY3kNwQhIQeSUbF3aIkw0hG1qFKb9x7YMiU9oHsNk8MQTi
         BbHOJXILujsTOCTTPkFoCtQ/0f2ERZ96jXsdPZmihpH2dJAdN8kaZIYeQNnALMB5skdz
         offsyb9VhLRqredd2jhN3R1K+hUVMuCcGU2mLZ4wjWSNYXpx+GHRnypMdciutXcweAa7
         W+XXyjmDbBSLORVBpfBdXuA1phrGTMm+EQxLMCtThBn89mv95TNGWHhcTcFccUX7o8PB
         6Fll5G0QtRQzdlaR45yxtJZ8wzqm/6d3Dbd9UvhpdePgRGvdPGx3wl/LTNks/ysIGNZo
         rTsg==
X-Forwarded-Encrypted: i=1; AJvYcCUY9LHKP+ULsWvn/54rqOH6GjJsvnDwLvAeoYOwpbrLeMef1kg1i72o3ClKXUgOIrAqlQA804EU/w==@kvack.org
X-Gm-Message-State: AOJu0YyXYA8WvNfPqTEInlnE/5MIywaKG+9DZ2FmEzN7GMNDcKIDmZ97
	Wfy0nbtUIJk/7sIdJ5TYQZxnmjs8mV8mpMOiXvS0Qkp2yU/2vdx5KyWc
X-Gm-Gg: ASbGncuGiGIsYQiGPXf9ZACQ95WnKHgERHyyrR7TUKALlq0U8FwasC28ZMBaMtf75yd
	8hkY6uLoBLZTC7X9b00OJE00C6iohKWNE5faJvZp67Cpbn+QcuiIiA3M3H/ublMN67dO7gPEaha
	h/XkvN7putkYMW8eWHMSgsNwA73Y2+sUz4/DmaaylsE69M1iAnHL3LDH4KShLSUENcxng44NQiY
	8j1cHItj/vz3TUy8zJTUHqyYQBLTxHFaoso5jJUQTT6PF+Rzip0d98tdUBYjMzY4DbhYHoZs22k
	IeCiDfjpJRXhs26pHved34ScSSP7s/wDdShIDhIyCWc6BbgnRxo1NE/bAz1wJo6nymGPQVw5KYS
	ycjzJli8N6Z02LSwJHMUWzeFDa11p0lkJHeFwMXM+p5WyUv8y2742OnGXjSchbRRewiMzUb2vYc
	GQiMY=
X-Google-Smtp-Source: AGHT+IEfMl6RnbpkDRz3xPKw02ZxvVMy5U+m1L9klxFtFN/jBXClYLwUkIitj9v1zCClkhcSl7XzQA==
X-Received: by 2002:a05:6a00:a15:b0:7a2:7893:b17a with SMTP id d2e1a72fcca58-7a27893b21dmr11885518b3a.6.1761440747382;
        Sat, 25 Oct 2025 18:05:47 -0700 (PDT)
Received: from daniel.. ([221.218.137.209])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7a41404987esm3371597b3a.36.2025.10.25.18.05.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Oct 2025 18:05:47 -0700 (PDT)
From: jinji zhong <jinji.z.zhong@gmail.com>
To: minchan@kernel.org,
	senozhatsky@chromium.org,
	philipp.reisner@linbit.com,
	lars.ellenberg@linbit.com,
	christoph.boehmwalder@linbit.com,
	corbet@lwn.net,
	tj@kernel.org,
	hannes@cmpxchg.org,
	mkoutny@suse.com,
	axboe@kernel.dk,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	akpm@linux-foundation.org,
	terrelln@fb.com,
	dsterba@suse.com
Cc: muchun.song@linux.dev,
	linux-kernel@vger.kernel.org,
	drbd-dev@lists.linbit.com,
	linux-doc@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	zhongjinji@honor.com,
	liulu.liu@honor.com,
	feng.han@honor.com,
	jinji zhong <jinji.z.zhong@gmail.com>
Subject: [RFC PATCH 3/3] Doc: Update documentation for per-cgroup compression priority
Date: Sun, 26 Oct 2025 01:05:10 +0000
Message-ID: <25cab6bc87a6cd69983e2fa0908441bc37015c98.1761439133.git.jinji.z.zhong@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1761439133.git.jinji.z.zhong@gmail.com>
References: <cover.1761439133.git.jinji.z.zhong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 9AA381C0004
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: onzmxh3569ybt6narc6n78pr5gur17hn
X-HE-Tag: 1761440748-879315
X-HE-Meta: U2FsdGVkX18AnGnABMBjBpINH+xN2bgH3K/h/ZTPa1jAPFYu2tfb35kpUtaBxg8sSLgd81jVLWn/OS5l4JInwuZ4gh658KO8MZFfbT31GmD4sjctYUFN7WbQwCghCfY8SgvEXFU9CYZ9tYOav2s1EO5CeRlJ6j95zkn41E3TKaY6IuFWoowheiicXwVDmoIWGk+g/k1kpb9HqOzass5po/SxnliOcHtWndNJHvY1UqGLywPmWKJ/j97cmQf917pus7Ip7sayUSklphlwNhgSA4WhnfttO6WXxVApp707isVFB+jx4XAtLzITJzn5Ogm7MSVtQjwILR4O5nAmxCIxx3VEPFbAZ0WA17WXdQM7hyTyckc490uNLy60Z5YtMauRzgROwufLr/qLxuZ9lxfnW9HYkuxYn/q3bjdokK3q0lViQHPmDMZAr4w31rQrpUTiai6eFekyX6+40vTX3+OSeWKGs2kSXI9qWv7wnRjEvDuA8MT/YWqvT+coPE6C4pFrLfJv7MP3aa/LcJNk9/EucfBl40KaAe9vRha37VpAb0BqcWihLDFxjBqVCh77evckkYy/iUFuBwpg185tA68cPGiNqxXfYrLyAwBiczT2ThvROLOTRxaYT//DbxayTdqA39/44/h+44auuuJ6TrP749S37MpgTW7KTWAi95O1Q0/ddrgvR0hkdCk1YnHimuTVTrfF/m0rQXC3MCV/N1s9Lw0I4LVJGZMGXp/AJeD7w2FGauzRUCnt4nKzvxpE9YQOFlOA4ZwaaqCLepJSkAJhAFiQuLGtIu5r9Sxn6SivHM74SEsjFseyfHKD17Z0lyjw7/p+CCFDyyyWKK7xEjai/0JzP0qZQLqHooy4+SmP9rOQbZcPPQYSzBzI7pfNHEdgDyzMAU5Yj8kcYCKj7XlxTP2rsHpNG1kKE6asacTRmnpmKkLOyTDVj85Vd1L7JNAB2baie58KZ/MlWzWCMkb
 KZNUYdbq
 KPgv5pPsExf9WxsKRcaQY7YHwSCBwC2nJ1ARnOrD1tQA5viflmOv+uAXCQzWXswuD8XudDRFlkeF9YcQafooSrgA5xQaaUSQWu5ji/Il8u1Rw+MdVrvvjFOHy3wELHSlXDrXq7WeewcLa+bYX1XB2ZU/58FzAlANpl6Wf2NmklE2v9ZiqgJYN/bN4SfbsW81eCLWnKTkCuumSB3Vra/hjke0O+PtehoaryZoRgEAL2kfXRtZhzpXXUGR4QD8hW9S9KpgreLNCJ5UvoYVjomLK4IXHzPpbxzBq2MeYj48dLOXeVQe1bupsx4bOOvjuuKhXNk7m7E1j1U1sG6fFQm5gemGHDmWLWtIuCCCm6jYmMru7iBx7nALFznhdp3YIo6cQN8omHMBCO5TaR2+r9g3U8hcirdzrB0G2gKUH15VXQ7t+kkz92e98zBsFORoEFdlKy54ViD4cpYn6jwTi9FYmvd6f4rIFQ3I9I/z6BMZaChuL531QVn/p7pmcbQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch updates the documentation, describing the newly
introduced per-cgroup compression priority mechanism.
---
 Documentation/admin-guide/blockdev/zram.rst | 18 ++++++++++++++----
 Documentation/admin-guide/cgroup-v2.rst     |  7 +++++++
 2 files changed, 21 insertions(+), 4 deletions(-)

diff --git a/Documentation/admin-guide/blockdev/zram.rst b/Documentation/admin-guide/blockdev/zram.rst
index 3e273c1bb749..de4ab060f664 100644
--- a/Documentation/admin-guide/blockdev/zram.rst
+++ b/Documentation/admin-guide/blockdev/zram.rst
@@ -452,12 +452,12 @@ using more effective algorithm and, hence, reduce zsmalloc memory usage.
 With CONFIG_ZRAM_MULTI_COMP, zram supports up to 4 compression algorithms:
 one primary and up to 3 secondary ones. Primary zram compressor is explained
 in "3) Select compression algorithm", secondary algorithms are configured
-using recomp_algorithm device attribute.
+using multi_comp_algorithm device attribute.
 
 Example:::
 
 	#show supported recompression algorithms
-	cat /sys/block/zramX/recomp_algorithm
+	cat /sys/block/zramX/multi_comp_algorithm
 	#1: lzo lzo-rle lz4 lz4hc [zstd]
 	#2: lzo lzo-rle lz4 [lz4hc] zstd
 
@@ -468,10 +468,10 @@ Alternative compression algorithm's priority is provided during algorithms
 configuration:::
 
 	#select zstd recompression algorithm, priority 1
-	echo "algo=zstd priority=1" > /sys/block/zramX/recomp_algorithm
+	echo "algo=zstd priority=1" > /sys/block/zramX/multi_comp_algorithm
 
 	#select deflate recompression algorithm, priority 2
-	echo "algo=deflate priority=2" > /sys/block/zramX/recomp_algorithm
+	echo "algo=deflate priority=2" > /sys/block/zramX/multi_comp_algorithm
 
 Another device attribute that CONFIG_ZRAM_MULTI_COMP enables is recompress,
 which controls recompression.
@@ -524,6 +524,16 @@ This can be achieved by providing a `algo` or `priority` parameter:::
 	#use zstd algorithm only (if zstd was registered under priority 1)
 	echo "type=huge priority=1" > /sys/block/zramX/recompress
 
+per-cgroup compression algorithms
+-------------
+With CONFIG_ZRAM_MULTI_COMP, zram can compress pages using the compression
+algorithm determined by the cgroup. It will get the compression priority from
+the cgroup and use the corresponding compression algorithm to compress the page.
+
+To use the feature, admin should enable per-cgroup compression via::
+
+	echo 1 > /sys/block/zramX/per_cgroup_comp_enable
+
 memory tracking
 ===============
 
diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 0e6c67ac585a..1706d8f0d225 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -1871,6 +1871,13 @@ The following nested keys are defined.
 	higher than the limit for an extended period of time.  This
 	reduces the impact on the workload and memory management.
 
+  memory.swap.compress_priority
+	A read-write single value file which exists on non-root
+	cgroups.  The default is "0".
+
+	swap compress priority for the cgroup. Different compression
+	priorities mean different compression algorithms.
+
   memory.zswap.current
 	A read-only single value file which exists on non-root
 	cgroups.
-- 
2.48.1


