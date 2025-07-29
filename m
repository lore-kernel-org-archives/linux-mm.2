Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F086C83F26
	for <linux-mm@archiver.kernel.org>; Tue, 29 Jul 2025 13:53:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DABEB6B009A; Tue, 29 Jul 2025 09:53:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D5D006B009D; Tue, 29 Jul 2025 09:53:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C72A76B009E; Tue, 29 Jul 2025 09:53:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B5B466B009A
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 09:53:36 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 64CB259C33
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 13:53:36 +0000 (UTC)
X-FDA: 83717444832.20.C1E68A4
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	by imf03.hostedemail.com (Postfix) with ESMTP id 7AC8620005
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 13:53:34 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OSvRe2gM;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of pyyjason@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=pyyjason@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753797214; a=rsa-sha256;
	cv=none;
	b=DSZIu/RUm4luLef78qz3w3GKMHFdBGKIzYaCfoRJcOugC0UxqwHv78nfQucJbl3UyJeXLF
	zEDm0kNRN3J5QyCsIzSgxSi3jf09zbJV/nYPkiyKW5t+u5wZanz5EFytJm1b7EFKNkNzrp
	vZ6G4E0lxpYHhUVTu0Vyc+Pm+9aHnVk=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OSvRe2gM;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of pyyjason@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=pyyjason@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753797214;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=LgD2yooVBQyOgeS/5DXXpBjPnv8zp4QtCnOuo9AiwFs=;
	b=Gzqoy3bNQp2fp5EvNgdheWiy5/v4/JOWfjakmMCFAYeUUKYFFAx6KgY/5EEGdUyKh4oOtk
	C1tnIEIW6jr12ONfVO1zESl7iLzwtbCPq3m5JOlZtZTaSpGtKZkPHO7xg100f2erp7n0fG
	4I9wQ49MZXbN8L5e+TTxk6rt8GlX9Iw=
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-451d7b50815so36515865e9.2
        for <linux-mm@kvack.org>; Tue, 29 Jul 2025 06:53:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753797213; x=1754402013; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=LgD2yooVBQyOgeS/5DXXpBjPnv8zp4QtCnOuo9AiwFs=;
        b=OSvRe2gM1LQSKtdQcdG0+fFwwAwRezRqfm2eYpveRd0gEpcT4sYSbZikmYZHDA1OTr
         6GfdkeeexSXm5+flerw1kwIIgPNpXPEGL5H+XdTKriIMZbMaoDyBxihQoQgDbuz7dGtP
         x3TCzk9bBm6t++iX7n9OtgbAX9tZlRDpe5R0YZ3Jvp8sqkDeYlacQBtWBygj1wO3r7sJ
         5BqejhAqaYov2jkSTpqeGaZaUPSyDN5rCG6W1L4/U6HAqAJs6nuiTudiorNLREQipatl
         m88/e509KOwfVVVSVMrq5Ca6ucFoDzQs2j6LlnRQXv92KGPgSB6SS3PFbUvQak/A5T4d
         5JlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753797213; x=1754402013;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LgD2yooVBQyOgeS/5DXXpBjPnv8zp4QtCnOuo9AiwFs=;
        b=d80OmAhjh2Y4xzSfiIu7oq+68cHzRHH1T61kIPSO1fkZEg8IIo66MjiqLRYHLGE+Di
         /tY4xoNuD/RgFsZurz/+8/4xFst/i1UTvfLao9bSUCHBwrVLfxixaW+7P43uiOsAgjsw
         Jlf87ZApTrXFiJpnsJhioj74jLzRRv1M8/92W3PZeCSxlNLVALZf0mOUMvTankCMtvO6
         INrNg+ho4CkQiJUd/wyNHjKhyUr9/O72SMm80D+zZDXZyzsAO5Qe2kE5MQe/eaK7teI+
         t3nGfnmzDvIJdRJLc9KTLgrPKhng2Htlxy6wgvVrp4dVsQUtRJ4okEW1848xS76zdTRi
         Npxg==
X-Forwarded-Encrypted: i=1; AJvYcCUmV0YwXx9DFEM7UuDBV+OnE2CvZE79wsrtjUSdWo6UPR3wQrbjM6cqlChjr/QOlunBTa8IRGriBw==@kvack.org
X-Gm-Message-State: AOJu0YxmWsU54ZkSZg6BDEhhjcnaNGyppTnp++SAGZ+9Y15xpPRhkHME
	if+9AFjcksuB4k9GGjLacQ0aUD7UoA8NrCsDIoXyZqFTRzDaXCrM7W7m
X-Gm-Gg: ASbGncuHynPWkkXIPES6kWLk/4MYGBUNGKvtmzNaRtjni/tlSUQGD+xlpoUVk71F88i
	AoWo0Vkz6RGl/eDnC9MhxdW4kOVMmA/5CrafbG4wyJ4aQpApMXOQS99Tkp2n4JLd++ZXBneeTmh
	UV3pRBWs3zHZ4UmDSf12s5hQLNbcgKyvlYPOnKZwqbBY22PhshbBF878HdWexC9DmWUAV4WI7ZM
	xQ0/mGAHYTMn95i8b722nukAA4hAWkKOPNV6wbzyYVxERRx88VGdMySUk8nxN50M2TSSl/YxRsd
	9xdc77ph7Gd997g7gUcEoIPRm62SJhsrVCCmjdEpAM0Cwwm/jjfAp+WRwI/Dv4XkiuCug+zSMZ2
	hYB8Kn7UPdmridDA=
X-Google-Smtp-Source: AGHT+IFHMRl5Ir2/Kp76P8eHrruh1SxZKxyeKj1sfOFtGFbIp+QsFSa1nhNSdGd9wHFMp24V+d2h1w==
X-Received: by 2002:a05:600c:4f87:b0:456:133f:a02d with SMTP id 5b1f17b1804b1-4587644278emr155376725e9.17.1753797212493;
        Tue, 29 Jul 2025 06:53:32 -0700 (PDT)
Received: from localhost ([2a03:2880:31ff:73::])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4588dd4d477sm19668085e9.2.2025.07.29.06.53.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Jul 2025 06:53:31 -0700 (PDT)
From: Yueyang Pan <pyyjason@gmail.com>
To: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Usama Arif <usamaarif642@gmail.com>
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	PanJason <pyyjason@gmail.com>
Subject: [PATCH v1 0/2] mm/damon: Add damos_stat support for vaddr
Date: Tue, 29 Jul 2025 06:53:28 -0700
Message-ID: <cover.1753794408.git.pyyjason@gmail.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 7AC8620005
X-Stat-Signature: mcar5ndmikm6ik71w61dbhnskjkc4oi8
X-Rspam-User: 
X-HE-Tag: 1753797214-634128
X-HE-Meta: U2FsdGVkX1/foahMz+X8WCMG0XPUlWvhNrovh25IewhNK4+h4EBSGKwSCegq53Ul3VCJyjbkhCapI86cGAtxLXmhQPT7ms1izP87BjnQSZCj9TV0DhErjQPZquSvPORTsCVuoCzd3IBdvkZHYwPZmGbrJTDuEtC19W5jy7C2CuV8BwRVmZaKymYDm+qYtMDrW5NMbW/ZqMYDGfpRMieSpVBhPbm/xkpbsaQGGRdAr5AKuDzyc8HhCc+3NleORP+LkRt1M8afKsjqdDydH6JEhrxcnvgvOLeffAVw6WBrp+tCU1pX1YZVM8Jw94wJ1CovwUHimPV1UOR+xpILhS4WqDIe2u4Swye2E9/h+x12pKO5xGzrQCJ7LbXXf6k5Bq+oAvcCLbqk8vnLD26FQ0/gfY4O66/emllVPb09xZpo3On5TrjCDCkGdU+77AMtdU6EVstjRrGL95fG4pXAtVRD4fRe5fwwyog3+ae1cpU5Zm+LM5ssaVVHzJXMagvGcCFNs3PCdkMGtwVj6QSpMY4Pz2N0/ZhO3XId946A0PnHPspgzppr0DQD4VZTqjpD9k0S/qhNfRH3EvNl/xrgeWqG2uX2IxJ4LoJsYbtvqqXwSNd5lQX8yhNe2+TW72SXH1uPeXXK2zXh8Y9/5Eg5zTygLSPM9Jlw0oOEn117tgf1+3M5prhSry9xWWHVztExz0yLOekcZ+v5YKMjVVPZs3e4BWmk6+Vd2Hh73ed3tnlQLJzTWjgCJdKy7e+4pEAKw1lBRvxN+MFtCM/kr1jXI4sutmQ9JlxZJ4wFFv0W+p6vFh44tvpx04lU6kbd6yRzpVRHVT2fJmp76vf4db9Ay9vTof4TGM36vAkYfK0KUM51o0A/K9V1ss3A7a3PRoGHVOo36iwGQ/PSgA68N0IWwUpv98xT4KoRixfzHLhBi5qYuWwR5aI+1UT/JzC7ogW9ONEE20eArjAB7J46hJZ8UBm
 9LTITBZS
 BmZpiNXQ3HbrZF5zCRx+eVMa8fGhCEqlXh5ARRfeoVk1o6GGN913KkKHlziuXGzBWc+0bAJv7f/ltPlBJBNHQtIxyxfL7cHlxUvedWDnqmWVM5CbI7r2GiOwf8mcXhVgNwWg9jGWbwKxs2ZNZQrEm9kVRaR6FoOxPRGPEYGYdmXlv5co3VpGw36G52pdJtoSvZweZx6hOCa8Gqn9ijZa2bovm3s1rPQQMbBX130ih6672B1M6lKNdwlCZrFVSiM6YCByVCVBvacJuxBHeiY3gVxAiXBoWmWWaQKsRtfokU7Ux1vmn8OrhOqkoz4jKdJFoyS47/eq4eMt0DqxOTZWlTyP8kcP7ZWc7Me8/P1kOaMKQGHHQ6qTEiACF0zXfH6EFIgJNaTj4dNO9iL/JZeMGMXF0QLfOJprcmzAOG6Wfe8wO0lu8qg5rfvUVyUgmnS0k/mZ2liNacvRanaANVO/nyur27W9LEtPz1/sSfTwyc9qD7vp8wtgv010YjGk3ugkbnZYAtBXMS9lLyJVQ2UrZDq27hwSZm71o4i5E8m6lzZXxpBI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: PanJason <pyyjason@gmail.com>

Previously damos_stat only supoort paddr. This patch set adds support 
for damos_stat for vaddr. Also all different types of filters are 
supported. 

Functionality Test
==================
I wrote a small test program which allocates 10GB of DRAM, use 
madvise(MADV_HUGEPAGE) to convert the base pages to 2MB huge pages
Then my program does the following things in order:
1. Write sequentially to the whole 10GB region
2. Read the first 5GB region sequentially for 10 times
3. Sleep 5s
4. Read the second 5GB region sequentially for 10 times

With a proper damon setting, we are expected to see df-passed to be 10GB
and hot region move around with the read

$ # Start damon record
$sudo ./damo/damo record "./my_test/test" --monitoring_intervals 100000\
1000000 2000000

$ # damon report
$sudo ./damo/damo report access --snapshot_damos_filter reject none \
hugepage_size 2MiB 2MiB
heatmap:
# min/max temperatures: -900,000,000, 100,002,000, column size: 136.564 MiB
intervals: sample 100 ms aggr 1 s (max access hz 10)
# damos filters (df): reject none hugepage_size [2.000 MiB, 2.000 MiB]
df-pass:
# min/max temperatures: -663,075,528, 100,002,000, column size: 128.037 MiB
0   addr 86.082 TiB   size 682.039 MiB access 0 hz   age 9 s           df-passed 0 B
1   addr 127.225 TiB  size 466.039 MiB access 1.000 hz age 0 ns          df-passed 468.000 MiB
2   addr 127.225 TiB  size 51.785 MiB  access 2.000 hz age 0 ns          df-passed 50.000 MiB
3   addr 127.225 TiB  size 785.219 MiB access 2.000 hz age 1 s           df-passed 786.000 MiB
4   addr 127.226 TiB  size 87.250 MiB  access 1.000 hz age 1 s           df-passed 88.000 MiB
5   addr 127.226 TiB  size 982.719 MiB access 1.000 hz age 0 ns          df-passed 982.000 MiB
6   addr 127.227 TiB  size 109.191 MiB access 0 hz   age 0 ns          df-passed 110.000 MiB
7   addr 127.227 TiB  size 103.945 MiB access 0 hz   age 0 ns          df-passed 104.000 MiB
8   addr 127.227 TiB  size 935.539 MiB access 0 hz   age 0 ns          df-passed 934.000 MiB
9   addr 127.228 TiB  size 386.547 MiB access 0 hz   age 0 ns          df-passed 388.000 MiB
10  addr 127.228 TiB  size 579.824 MiB access 0 hz   age 0 ns          df-passed 580.000 MiB
11  addr 127.229 TiB  size 168.676 MiB access 1.000 hz age 1 s           df-passed 168.000 MiB
12  addr 127.229 TiB  size 42.172 MiB  access 1.000 hz age 1 s           df-passed 42.000 MiB
13  addr 127.229 TiB  size 63.254 MiB  access 0 hz   age 0 ns          df-passed 64.000 MiB
14  addr 127.229 TiB  size 147.598 MiB access 0 hz   age 0 ns          df-passed 146.000 MiB
15  addr 127.229 TiB  size 112.453 MiB access 1.000 hz age 0 ns          df-passed 114.000 MiB
16  addr 127.229 TiB  size 168.684 MiB access 1.000 hz age 0 ns          df-passed 168.000 MiB
17  addr 127.229 TiB  size 810.512 MiB access 0 hz   age 6 s           df-passed 810.000 MiB
18  addr 127.230 TiB  size 202.629 MiB access 0 hz   age 6 s           df-passed 204.000 MiB
19  addr 127.230 TiB  size 206.859 MiB access 0 hz   age 6 s           df-passed 206.000 MiB
20  addr 127.231 TiB  size 827.449 MiB access 0 hz   age 6 s           df-passed 828.000 MiB
21  addr 127.231 TiB  size 326.004 MiB access 0 hz   age 5 s           df-passed 326.000 MiB
22  addr 127.232 TiB  size 760.680 MiB access 0 hz   age 5 s           df-passed 760.000 MiB
23  addr 127.232 TiB  size 148.238 MiB access 0 hz   age 5 s           df-passed 148.000 MiB
24  addr 127.233 TiB  size 592.965 MiB access 0 hz   age 5 s           df-passed 594.000 MiB
25  addr 127.233 TiB  size 321.695 MiB access 0 hz   age 5 s           df-passed 320.000 MiB
26  addr 127.233 TiB  size 750.629 MiB access 0 hz   age 5 s           df-passed 752.000 MiB
27  addr 127.234 TiB  size 73.078 MiB  access 0 hz   age 7 s           df-passed 72.000 MiB
28  addr 127.234 TiB  size 31.320 MiB  access 0 hz   age 7 s           df-passed 28.000 MiB
29  addr 127.997 TiB  size 132.000 KiB access 0 hz   age 9 s           df-passed 0 B
memory bw estimate: 3.615 GiB per second  df-passed: 3.615 GiB per second
total size: 10.669 GiB  df-passed 10.000 GiB
record DAMON intervals: sample 100 ms, aggr 1 s

$ # damon report again
$sudo ./damo/damo report access --snapshot_damos_filter reject none \
hugepage_size 2MiB 2MiB
heatmap:
# min/max temperatures: -1,100,000,000, 300,001,000, column size: 136.564 MiB
intervals: sample 100 ms aggr 1 s (max access hz 10)
# damos filters (df): reject none hugepage_size [2.000 MiB, 2.000 MiB]
df-pass:
# min/max temperatures: -800,000,000, 300,001,000, column size: 128.037 MiB
0   addr 86.082 TiB   size 682.039 MiB access 0 hz   age 11 s          df-passed 0 B
1   addr 127.225 TiB  size 10.355 MiB  access 1.000 hz age 0 ns          df-passed 12.000 MiB
2   addr 127.225 TiB  size 93.207 MiB  access 1.000 hz age 0 ns          df-passed 92.000 MiB
3   addr 127.225 TiB  size 414.262 MiB access 1.000 hz age 0 ns          df-passed 414.000 MiB
4   addr 127.225 TiB  size 706.695 MiB access 1.000 hz age 3 s           df-passed 708.000 MiB
5   addr 127.226 TiB  size 78.523 MiB  access 1.000 hz age 3 s           df-passed 78.000 MiB
6   addr 127.226 TiB  size 87.250 MiB  access 1.000 hz age 3 s           df-passed 88.000 MiB
7   addr 127.226 TiB  size 384.469 MiB access 1.000 hz age 0 ns          df-passed 384.000 MiB
8   addr 127.226 TiB  size 256.312 MiB access 1.000 hz age 0 ns          df-passed 256.000 MiB
9   addr 127.226 TiB  size 427.191 MiB access 1.000 hz age 0 ns          df-passed 428.000 MiB
10  addr 127.227 TiB  size 319.023 MiB access 1.000 hz age 0 ns          df-passed 318.000 MiB
11  addr 127.227 TiB  size 212.688 MiB access 0 hz   age 0 ns          df-passed 212.000 MiB
12  addr 127.227 TiB  size 531.711 MiB access 0 hz   age 0 ns          df-passed 532.000 MiB
13  addr 127.228 TiB  size 541.164 MiB access 0 hz   age 0 ns          df-passed 542.000 MiB
14  addr 127.228 TiB  size 135.293 MiB access 0 hz   age 0 ns          df-passed 136.000 MiB
15  addr 127.229 TiB  size 289.914 MiB access 0 hz   age 0 ns          df-passed 290.000 MiB
16  addr 127.229 TiB  size 29.516 MiB  access 1.000 hz age 0 ns          df-passed 28.000 MiB
17  addr 127.229 TiB  size 68.879 MiB  access 1.000 hz age 0 ns          df-passed 70.000 MiB
18  addr 127.229 TiB  size 42.172 MiB  access 1.000 hz age 0 ns          df-passed 42.000 MiB
19  addr 127.229 TiB  size 134.941 MiB access 2.000 hz age 0 ns          df-passed 134.000 MiB
20  addr 127.229 TiB  size 314.871 MiB access 2.000 hz age 0 ns          df-passed 316.000 MiB
21  addr 127.229 TiB  size 112.457 MiB access 2.000 hz age 0 ns          df-passed 112.000 MiB
22  addr 127.229 TiB  size 50.656 MiB  access 0 hz   age 8 s           df-passed 50.000 MiB
23  addr 127.230 TiB  size 50.656 MiB  access 0 hz   age 8 s           df-passed 52.000 MiB
24  addr 127.230 TiB  size 911.828 MiB access 0 hz   age 8 s           df-passed 912.000 MiB
25  addr 127.230 TiB  size 413.719 MiB access 0 hz   age 8 s           df-passed 412.000 MiB
26  addr 127.231 TiB  size 103.434 MiB access 0 hz   age 8 s           df-passed 104.000 MiB
27  addr 127.231 TiB  size 517.156 MiB access 0 hz   age 8 s           df-passed 518.000 MiB
28  addr 127.231 TiB  size 880.207 MiB access 0 hz   age 7 s           df-passed 880.000 MiB
29  addr 127.232 TiB  size 97.805 MiB  access 0 hz   age 7 s           df-passed 98.000 MiB
30  addr 127.232 TiB  size 108.672 MiB access 0 hz   age 7 s           df-passed 108.000 MiB
31  addr 127.232 TiB  size 212.578 MiB access 0 hz   age 7 s           df-passed 212.000 MiB
32  addr 127.233 TiB  size 212.578 MiB access 0 hz   age 7 s           df-passed 214.000 MiB
33  addr 127.233 TiB  size 637.742 MiB access 0 hz   age 7 s           df-passed 636.000 MiB
34  addr 127.233 TiB  size 102.602 MiB access 0 hz   age 7 s           df-passed 104.000 MiB
35  addr 127.234 TiB  size 239.406 MiB access 0 hz   age 7 s           df-passed 238.000 MiB
36  addr 127.234 TiB  size 513.020 MiB access 0 hz   age 7 s           df-passed 510.000 MiB
37  addr 127.997 TiB  size 132.000 KiB access 0 hz   age 11 s          df-passed 0 B
memory bw estimate: 3.948 GiB per second  df-passed: 3.947 GiB per second
total size: 10.669 GiB  df-passed 10.000 GiB
record DAMON intervals: sample 100 ms, aggr 1 s

As you can see the total df-passed region is 10GiB and the hot region
moves as the seq read keeps going

PanJason (2):
  mm/damon: Move invalid folio and has filter to ops-common
  mm/damon: Add damos_stat support for vaddr

 mm/damon/ops-common.c |  19 +++++++
 mm/damon/ops-common.h |   3 ++
 mm/damon/paddr.c      |  29 ++---------
 mm/damon/vaddr.c      | 113 +++++++++++++++++++++++++++++++++++++++++-
 4 files changed, 139 insertions(+), 25 deletions(-)

-- 
2.47.3


