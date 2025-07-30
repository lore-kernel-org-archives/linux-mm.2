Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 221DFC87FCB
	for <linux-mm@archiver.kernel.org>; Wed, 30 Jul 2025 17:20:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8504D6B007B; Wed, 30 Jul 2025 13:20:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7FFBE6B0088; Wed, 30 Jul 2025 13:20:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7152F6B0089; Wed, 30 Jul 2025 13:20:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 62DF66B007B
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 13:20:03 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E9B901A049D
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 17:20:02 +0000 (UTC)
X-FDA: 83721593844.17.B8E97B5
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	by imf16.hostedemail.com (Postfix) with ESMTP id 156F4180007
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 17:20:00 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cd70mA7C;
	spf=pass (imf16.hostedemail.com: domain of pyyjason@gmail.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=pyyjason@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753896001;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=6LSHcQ0idAwPKDvX8EE25U8/JSS0uYFnXe2HDNHqMNY=;
	b=T0Buo/X2rh5+PcUbXeZ7XM3iPLBKKwW0ROB7zSZ9uWlqYMgF36CjBfpoZk+9sP7jVhZPRx
	CXAra1J9zBdk3Ie6YmFA6gfgD0Wr4BtkrmmxAz1Gw/TJit9tYlC14uQTiKhq95f+j6OySi
	hNpKegGiK+DOCbKPAsCA4YWvKt+MlR4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753896001; a=rsa-sha256;
	cv=none;
	b=hKYTzldZop6MXvZVqrp+7xiWUVbDPJAVSAarMW2/FD5iLXYgC4gU5HRGOTLtY+WIG7gw2d
	9spjZxb7hOWZXZooJPyMf+2RVzwFI0rIDtCTgbONA2PZiLFDHNImaerzR+Ml7k59AfXfri
	J3QJQd6DwbxciVOyBFWLSWUtcFh+A1w=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cd70mA7C;
	spf=pass (imf16.hostedemail.com: domain of pyyjason@gmail.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=pyyjason@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-3b794a013bcso59807f8f.2
        for <linux-mm@kvack.org>; Wed, 30 Jul 2025 10:20:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753895999; x=1754500799; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=6LSHcQ0idAwPKDvX8EE25U8/JSS0uYFnXe2HDNHqMNY=;
        b=cd70mA7C4RY1/ThofCmBwlxebJ5Z/x/2eV7A+rwO2XOJKjkO+Zv6Z1rPiT/Od3nG4d
         4FJZHdaZI7n8dh8tX3Ip4q55VPfDjWI93tavNYGVYBopi1yozO09O8RxwCa73rqWz4F2
         mLVzngRU0dMdCP6b+5ORRWXGrX5AawvuZrP6DbxNdz2PA+fP5itiJa/xAVfXRhFpqIUA
         BHLzpdB7+j+Jvgfehg5WLTOHAHa9JT8098NQ3NF7NS60ZGKl4hj0v2+6dQ5vgJ2/yEMY
         ZzmBbm5tVDCqkT3XozKuo6WAYAMLYAGbXcoQBLqv2JLCWMeDWfSi74GEpqJJAnTUUtx+
         cqdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753895999; x=1754500799;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6LSHcQ0idAwPKDvX8EE25U8/JSS0uYFnXe2HDNHqMNY=;
        b=SjulAfQF8x/W8YQ5f3c4kSt2LNiuyyADaqkfpL/Xa1feqlgYzw4uzk6wj/C+qB0PhS
         B6rDLczWNeRO1nVzA1KTswgQQradnNQuwq6X5gmRR7JvGaGyPaa7S/D4PlooHYCYMrkA
         jP7cwiRnfvsC3r2cVhpJT1ZMiDHqT4c7ppO3dz9UL25T2ieqQu5gSQAebylo+DCF1vHd
         c1dMAAQc0vbCYBeUPHio2a53aHXDc+aBsyjY2kGFP9Hkr5q7WPbFdkk+d9PNBi6XGx7q
         m0M3U1Ckm0n4I1uaEufPws2ifoHXkfRsT2I9Wc2Ea+OBICSvWX2vVdutLW9YogL9NHcY
         dWsA==
X-Forwarded-Encrypted: i=1; AJvYcCV8ja+69CCtedsjAnfP6cEFmBCFWyZDZ7iewcHdjAEXKWyNnDniSBbOkSIvR63ex+yyx4AvgH5P8Q==@kvack.org
X-Gm-Message-State: AOJu0YwnybFMxjKywdPhKdbKNchvci5Ny4gNKoeAj2JFWE6/SxEtyr1j
	i7dyD59+Cnn4+P3kjHlpJajWYfVtLBZugjai4SOYYWAozeb7PVR5xQ53
X-Gm-Gg: ASbGncuklPPPritgLHO+0kHEWa+NUxBNt9nBMudXutmXZ2uaJBE74zLUt8sVK7H7fOg
	vTEVTdoU42TTeJhNe14cu8UrlSceakQic51CzffyABy2aMgYYc+7Pba5AKYyJeWOqTCdp0NnEVC
	wJv53BQcvkN/ijFdkwEsnE5tjdQKUn1MOSwII0JEUROnDkZxRlAzds23wihHMt+YpEPhkFo+zME
	dChWW9Lbo/dB6RIuuyTnxy1fnZw2Y81eP/GRmd5cCyb9oR/VZEb8VML4Nkhm9FNkFu6eyrniz7n
	K9COFCd/5n13R6RDeVX3+PullV9TLGCdWNYWwnjjAhCwlnchsgiX33rIrgx/P6paI99cKeDSpWg
	ws05N+0sFagHhfls=
X-Google-Smtp-Source: AGHT+IHHpOLorxoYWXm9QIh1oiahYntiaztlH+OhrVoWzA0q4E4cWgVlDniRm+8G6MBU9hzMPBToCQ==
X-Received: by 2002:a05:6000:3107:b0:3b7:8af8:b922 with SMTP id ffacd0b85a97d-3b794ffd8d8mr3068673f8f.34.1753895999181;
        Wed, 30 Jul 2025 10:19:59 -0700 (PDT)
Received: from localhost ([2a03:2880:31ff:74::])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4589aefaa44sm26603385e9.20.2025.07.30.10.19.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Jul 2025 10:19:58 -0700 (PDT)
From: Yueyang Pan <pyyjason@gmail.com>
To: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Usama Arif <usamaarif642@gmail.com>
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/2] mm/damon: Add damos_stat support for vaddr
Date: Wed, 30 Jul 2025 10:19:54 -0700
Message-ID: <cover.1753895066.git.pyyjason@gmail.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 156F4180007
X-Stat-Signature: ncu4moni8ufdxdf9abh8sjo4ka4ekw17
X-Rspam-User: 
X-HE-Tag: 1753896000-803629
X-HE-Meta: U2FsdGVkX1/Hc8uHI2RiAnyZRarJ4BjHBPi9N5LwT4EylMNXnuNGxoS98hd6ZTKrH5eOkfBPYMI/aIdmSgg4zHk0N+yeIFkI6YtloC8U2O64P19Q9zQePt86rBKyy9246DA5ZCLS1OZbcXL2LasVIjDsXNbusoteNW7xWwzGvaDe8FhjbaHE7F5KcpPQ2tv185JPQgzb/UYx1LGBuU9dBAHm/4CTEDtag6HN+YlRFWiZITbf1Cly+iVa4guxOcxEEXz/0bn1iiGqVs5QCMdh0P4o3mjWo/fJy5Y2zJ+rkSLAmfSHiVxZfxnU5Y1iJQnqKOjmqFcuPkHDuJoaH4Opza+Z24BTIC192zCAYztKaqdJJvYOMQ/HYNvSZXgl+5uYx1HMUw8fIhwL/ZkS/SjE4c4p3I4Knr7XLF5YyHP9TvU+k2sBq8GkSMNKLMaeBaed3AnA/HEIjn+S/qfNb5GRfILecam4Ry7/AUZpSqVhWp1cl/Y3z4lFDih1FF/NDeb/rgl7i5JBYrzkT7JgaCE2Mr5ZLzfT4Y9Gcr4uGvHCYP5ijSLUSf2wSuu58xI3cxnOzrv0+pPqkzyjsOuw0g2YfaTfysPryq5HBnjlMOY415iFpF7yIfTEiq1TJTyW93cbOFaQtPwiMZMhhBhR97LIdZeWJL1oOwMG00ZUPnvcAljQE9wMTVtUEa1hYS2S6XJPp7zHxw+sy4A+SerRrWA8GpXrCkTUrccvkuT4j3HXq51cBIGs4momjsYNqrSr8VHMOfN2x1gVfqY8hR20SadDzl9qxtDkisdC0/v177cvJ6y6B2z2n+q2Xk760m323XT4GoL5a3f9s9b/9M+VdaGRbHBVL/feU/Q3/PoumfJ92aPjhyashJbjFXbqd+IodKpzFxGhu2XRrZXp84AUAyeLqcVwS8o8J34D5BQkHwQWJ4LWh2VblI455UzVVnJpfGViMcFcVXu3pyoDUOnofzk
 pcTBGpxG
 coWdZfKROaJarsXDVtgnZDNBChgi6OWwDtUIDMj4nClMqb3BJ0lY/R5C6dIGM0fYf/RH+IRNVVU8PF42aaPWsNp2BfgvJwznbMfTjNHVmH0KTC7rGzs6TAxnF+PfSUlHLJRlxFXYBBrgvND8Wv4B+c6rfOpe/u5xLInrK8ZSriY5qmXYa9r6rM2nKVjrTOMp0+LBWbAbeI4EaW0ZbcoJZ8rJ6Xb8J3GWLbDS4c0DwBcbF/KjqHJ8Sf3xyHmoK8Dau93Vc065s580OD5jbHwej6L2i0ZmHNOHibnCju0CiubwiYHyPAP/xGQElu9t4NjN+dyv7rvG3+H6JvyA2A+fVRPngH9d4lsNc1v9ZJp1iH75q659TGeXtye9VAag5B5+Cvvgii5eYVyeDbl8baswf1/yfA1XSE4sh2bFBIpJwFOw2Wy6DXdub68dU0s4KkDoY2C9V1YaH+NZbwZZziI/gwyq/N665FZ4BiLwOMKDr3YBmj9QrCUvY1Vug5KrFcUjNC9+s+zcRwuVDdenx/SSUvDdk1aM1FYCiflU3ymdeMcCOGRnTjnkOxmq8M9u0e7L6UCey
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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
$sudo ./damo/damo start "./my_test/test" --monitoring_intervals 100ms\
1s 2s

$ # damon report
$sudo ./damo/damo report access --snapshot_damos_filter allow \
hugepage_size 2MiB 2MiB
    heatmap:
    # min/max temperatures: -600,000,000, 100,001,000, column size: 137.352 MiB
    intervals: sample 100 ms aggr 1 s (max access hz 10)
    # damos filters (df): reject none hugepage_size [2.000 MiB, 2.000 MiB]
    df-pass:
    # min/max temperatures: -400,000,000, 100,001,000, column size: 128.031 MiB
    0   addr 85.373 TiB   size 745.555 MiB access 0 hz   age 6 s           df-passed 0 B
    1   addr 127.608 TiB  size 877.664 MiB access 3.000 hz age 0 ns          df-passed 878.000 MiB
    2   addr 127.609 TiB  size 219.418 MiB access 2.000 hz age 0 ns          df-passed 220.000 MiB
    3   addr 127.609 TiB  size 316.613 MiB access 1.000 hz age 1 s           df-passed 316.000 MiB
    4   addr 127.609 TiB  size 474.922 MiB access 1.000 hz age 1 s           df-passed 476.000 MiB
    5   addr 127.610 TiB  size 407.188 MiB access 1.000 hz age 0 ns          df-passed 406.000 MiB
    6   addr 127.610 TiB  size 610.781 MiB access 1.000 hz age 0 ns          df-passed 612.000 MiB
    7   addr 127.611 TiB  size 697.309 MiB access 0 hz   age 0 ns          df-passed 696.000 MiB
    8   addr 127.611 TiB  size 77.480 MiB  access 1.000 hz age 0 ns          df-passed 78.000 MiB
    9   addr 127.611 TiB  size 573.102 MiB access 1.000 hz age 0 ns          df-passed 574.000 MiB
    10  addr 127.612 TiB  size 245.617 MiB access 2.000 hz age 0 ns          df-passed 246.000 MiB
    11  addr 127.612 TiB  size 295.102 MiB access 1.000 hz age 1 s           df-passed 294.000 MiB
    12  addr 127.612 TiB  size 295.105 MiB access 1.000 hz age 1 s           df-passed 296.000 MiB
    13  addr 127.613 TiB  size 67.172 MiB  access 1.000 hz age 1 s           df-passed 66.000 MiB
    14  addr 127.613 TiB  size 604.570 MiB access 0 hz   age 1 s           df-passed 606.000 MiB
    15  addr 127.613 TiB  size 389.578 MiB access 0 hz   age 4 s           df-passed 388.000 MiB
    16  addr 127.614 TiB  size 259.719 MiB access 0 hz   age 4 s           df-passed 260.000 MiB
    17  addr 127.614 TiB  size 817.941 MiB access 0 hz   age 4 s           df-passed 818.000 MiB
    18  addr 127.615 TiB  size 204.488 MiB access 0 hz   age 4 s           df-passed 204.000 MiB
    19  addr 127.615 TiB  size 730.902 MiB access 0 hz   age 4 s           df-passed 732.000 MiB
    20  addr 127.616 TiB  size 182.727 MiB access 0 hz   age 4 s           df-passed 182.000 MiB
    21  addr 127.616 TiB  size 926.824 MiB access 0 hz   age 2 s           df-passed 928.000 MiB
    22  addr 127.617 TiB  size 102.984 MiB access 0 hz   age 2 s           df-passed 102.000 MiB
    23  addr 127.617 TiB  size 86.527 MiB  access 0 hz   age 2 s           df-passed 86.000 MiB
    24  addr 127.617 TiB  size 778.777 MiB access 0 hz   age 2 s           df-passed 776.000 MiB
    25  addr 127.999 TiB  size 132.000 KiB access 0 hz   age 6 s           df-passed 0 B
    memory bw estimate: 6.524 GiB per second  df-passed: 6.527 GiB per second
    total size: 10.731 GiB  df-passed 10.000 GiB
    record DAMON intervals: sample 100 ms, aggr 1 s


$ # damon report again
$sudo ./damo/damo report access --snapshot_damos_filter allow \
hugepage_size 2MiB 2MiB
    heatmap:
    # min/max temperatures: -1,100,000,000, 2,000, column size: 137.352 MiB
    intervals: sample 100 ms aggr 1 s (max access hz 10)
    # damos filters (df): reject none hugepage_size [2.000 MiB, 2.000 MiB]
    df-pass:
    # min/max temperatures: -900,000,000, 2,000, column size: 128.031 MiB
    0   addr 85.373 TiB   size 745.555 MiB access 0 hz   age 11 s          df-passed 0 B
    1   addr 127.608 TiB  size 579.715 MiB access 2.000 hz age 0 ns          df-passed 580.000 MiB
    2   addr 127.608 TiB  size 144.930 MiB access 2.000 hz age 0 ns          df-passed 146.000 MiB
    3   addr 127.608 TiB  size 452.453 MiB access 2.000 hz age 0 ns          df-passed 452.000 MiB
    4   addr 127.609 TiB  size 113.117 MiB access 1.000 hz age 0 ns          df-passed 114.000 MiB
    5   addr 127.609 TiB  size 182.367 MiB access 2.000 hz age 0 ns          df-passed 182.000 MiB
    6   addr 127.609 TiB  size 182.371 MiB access 2.000 hz age 0 ns          df-passed 182.000 MiB
    7   addr 127.609 TiB  size 350.488 MiB access 1.000 hz age 0 ns          df-passed 350.000 MiB
    8   addr 127.610 TiB  size 525.738 MiB access 1.000 hz age 0 ns          df-passed 526.000 MiB
    9   addr 127.610 TiB  size 401.352 MiB access 1.000 hz age 0 ns          df-passed 402.000 MiB
    10  addr 127.611 TiB  size 100.340 MiB access 1.000 hz age 0 ns          df-passed 100.000 MiB
    11  addr 127.611 TiB  size 19.523 MiB  access 0 hz   age 0 ns          df-passed 20.000 MiB
    12  addr 127.611 TiB  size 175.727 MiB access 0 hz   age 0 ns          df-passed 176.000 MiB
    13  addr 127.611 TiB  size 106.629 MiB access 0 hz   age 0 ns          df-passed 106.000 MiB
    14  addr 127.611 TiB  size 959.676 MiB access 0 hz   age 0 ns          df-passed 960.000 MiB
    15  addr 127.612 TiB  size 424.469 MiB access 1.000 hz age 0 ns          df-passed 424.000 MiB
    16  addr 127.612 TiB  size 424.469 MiB access 1.000 hz age 0 ns          df-passed 424.000 MiB
    17  addr 127.613 TiB  size 201.648 MiB access 0 hz   age 6 s           df-passed 202.000 MiB
    18  addr 127.613 TiB  size 806.609 MiB access 0 hz   age 6 s           df-passed 806.000 MiB
    19  addr 127.614 TiB  size 862.125 MiB access 0 hz   age 9 s           df-passed 862.000 MiB
    20  addr 127.614 TiB  size 215.535 MiB access 0 hz   age 9 s           df-passed 216.000 MiB
    21  addr 127.615 TiB  size 104.500 MiB access 0 hz   age 9 s           df-passed 104.000 MiB
    22  addr 127.615 TiB  size 940.523 MiB access 0 hz   age 9 s           df-passed 942.000 MiB
    23  addr 127.616 TiB  size 640.281 MiB access 0 hz   age 7 s           df-passed 640.000 MiB
    24  addr 127.616 TiB  size 426.855 MiB access 0 hz   age 7 s           df-passed 426.000 MiB
    25  addr 127.617 TiB  size 90.105 MiB  access 0 hz   age 7 s           df-passed 90.000 MiB
    26  addr 127.617 TiB  size 810.965 MiB access 0 hz   age 7 s           df-passed 808.000 MiB
    27  addr 127.999 TiB  size 132.000 KiB access 0 hz   age 11 s          df-passed 0 B
    memory bw estimate: 5.297 GiB per second  df-passed: 5.297 GiB per second
    total size: 10.731 GiB  df-passed 10.000 GiB
    record DAMON intervals: sample 100 ms, aggr 1 s

As you can see the total df-passed region is 10GiB and the hot region
moves as the seq read keeps going

Revision History
================
Changes from v1 [1]:
- Follow David's advise to combine *pmd_entry() and *pte_entry() into
  one. Also remove manually setting walk->action
- Use vma_normal_page and vma_normal_page_pmd instead of damon_get_folio
  to remove redundant folio_get and folio_put
- Follow SJ's advise to only move damon_pa_scheme_has_filter to
  ops-common
- Change the command used in cover-letter for more natural illustration

[1] https://lore.kernel.org/all/cover.1753794408.git.pyyjason@gmail.com/

Yueyang Pan (2):
  mm/damon: Move has filter to ops-common
  mm/damon: Add damos_stat support for vaddr

 mm/damon/ops-common.c |   9 ++++
 mm/damon/ops-common.h |   2 +
 mm/damon/paddr.c      |  11 +----
 mm/damon/vaddr.c      | 105 +++++++++++++++++++++++++++++++++++++++++-
 4 files changed, 116 insertions(+), 11 deletions(-)

-- 
2.47.3


