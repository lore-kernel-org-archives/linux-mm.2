Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0CCAC87FC9
	for <linux-mm@archiver.kernel.org>; Sat,  2 Aug 2025 11:53:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 003CD6B007B; Sat,  2 Aug 2025 07:53:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF6AB6B0089; Sat,  2 Aug 2025 07:53:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0C1E6B008A; Sat,  2 Aug 2025 07:53:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D0DCB6B007B
	for <linux-mm@kvack.org>; Sat,  2 Aug 2025 07:53:03 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4499DC0139
	for <linux-mm@kvack.org>; Sat,  2 Aug 2025 11:53:03 +0000 (UTC)
X-FDA: 83731656246.06.9F9F413
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	by imf06.hostedemail.com (Postfix) with ESMTP id 60A59180005
	for <linux-mm@kvack.org>; Sat,  2 Aug 2025 11:53:01 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Pb2xQJ0i;
	spf=pass (imf06.hostedemail.com: domain of pyyjason@gmail.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=pyyjason@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754135581;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=V4brAoBW23LGCc+VB07OY1whyNY3DMBmIf8Vmk+ZO+U=;
	b=FuH5Mq+HQFPQBQ/UMMJl4pUuxNqO2ugR6k+YYl4mO7efbZFM+nOgrccJ+jhCsRxlJxxmLY
	kal30YjxvuwYDDlzv5wGXiXCQpR8YUjxFgdlQkgXsOZROjMKrsFFrq2D9ncyoikU/NpBpV
	WnrK0+Z3Y1KExwNfxgXI8J/VALIPUxA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754135581; a=rsa-sha256;
	cv=none;
	b=gQJ3FWxbcLDvLLuMBLxqmAqbqqInBRwSNSNcFtpjuerNqKJvYK1FdqJ9GNC+5KCboFchV2
	WUTaluA+WG4TMxWVmpGHa+4mMrfOz0H4Y9ibubshhkhimG7Tfyjvb22PXippPNdiklSUC5
	qPAFxI+/cKSU92zKsIqby1dYKf4bis0=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Pb2xQJ0i;
	spf=pass (imf06.hostedemail.com: domain of pyyjason@gmail.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=pyyjason@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-ae9c2754a00so713451866b.2
        for <linux-mm@kvack.org>; Sat, 02 Aug 2025 04:53:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754135580; x=1754740380; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=V4brAoBW23LGCc+VB07OY1whyNY3DMBmIf8Vmk+ZO+U=;
        b=Pb2xQJ0iS5y/yMFmnHiUefnSCb+gJLknIHPikCCh24AWJxEGB4ySzMqD017zqVOQhY
         xuuitN1uOXm//EGvJ0oR0955S73Cqv2obJrW6HWDzXbd4SNk4w479vT+zm3ylDm1DM/9
         6+/CKzUVysZJ8x/Ge48XPaBn365vRC8+jQa7YiEzwLzpafyZKSFCHRuBZd+iOLklvWQi
         rdtOlsilKcJjMXPY8WEX5Z9Sw1JazCiy3rTqJp59h6pB6Kwg4O6Zc8IVySDAP4+9xWLt
         NyiQEQJhjTj0OzQdBFeWLrQ40N/KA8K/SXD1VYJu+m1CA0hKBLQxd/3Q1IbMxHpEHG9J
         DU4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754135580; x=1754740380;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=V4brAoBW23LGCc+VB07OY1whyNY3DMBmIf8Vmk+ZO+U=;
        b=u1zVbKUHFnpqvAdEewDkn6czlvE2T0RnBud3KCjjOSjWHNlCKuZ4Brrj0k5IysbN4t
         +DCtt+6JuS7Cfqb1JHKYURWbIt+96R9zeOlZ6ubS3wYpsjRe9X35mb3EiMgU3IRlnJD4
         nSiWvdmap7dCkIMOMKRCTSZVrR1nJRAEVKquXhsgIg1eptA/7yAw5JPy70bBK1RZ3g72
         zClRoOuvt24MyYINalidCOPHnU9oqUKE+lC6OB3TT37HWGIjdjBa98Q56KVJfK9sncWw
         iQkHiQ36YhrVk5bFcWLGTddmk+VoXRJEkK0IHtwQxL66twa2MAyi/vAvZTA3sO2EWvlG
         gDpw==
X-Forwarded-Encrypted: i=1; AJvYcCUVfp+/7M/cGDqYwd9vUc2IL6ywPRsRQIHiMP4bUBknM3vE2BlYNNDvInycwvPbgSLy3qCaikiHtA==@kvack.org
X-Gm-Message-State: AOJu0Yxb6Di95Nait1nrSlYnzO0FEbmoIaPHs7MriuaDK8cY8aE9cQna
	fVaPLVADjlhNF04USa1O35xWPO3YGlPcxGEa5jObSFnMwyXnijfmHqJp
X-Gm-Gg: ASbGncvrNefiLbiu+NtIEm1eGaUOPwdnnr6AT9BQxxRkqWJbDFsqKrTkTe5I3gHE0Hp
	sjm5BR66oTNCL/sEQMC4hEJnaGG+oYCFy+UcLEd2LLQeXvj3/TX/wok3BXKd3FnCvs8zCQZAMbs
	Lima4uioRW1NXXPLtOdLcB2riY8QA5pTVvquaNA9KWEM5vEqijTqDqrprwBz1yHiVUEXYcxRP4A
	BHdXtW4N8GUuu/iG1OY9dd6nDAso8CZkh/1mPaF8i0K+S5OCSI7YidY47D3R2pBZ6nDSl+suaXb
	9C4D6LiKM/oVKv44iKSNyRMgknPzZbb9glhfpZ+TKmj0ruTwjqDPJFE6ER3czc5Z1zDORWGcjsF
	j/JX4iFB2483ebl8gM9WnNEaD4ZAml4T97zlJ7TFFg1UaaKL2Oq0d92634Xkc8rC79wb4W9Y=
X-Google-Smtp-Source: AGHT+IHEgBsjwBarO7mciGajTi+ctVhNkkYuFAQHrt27NjJPcufQ7mQqgDlCHZbivMVkWnO16U7EBg==
X-Received: by 2002:a17:907:3d90:b0:ae0:c6fa:ef45 with SMTP id a640c23a62f3a-af9401a5325mr328832866b.41.1754135579295;
        Sat, 02 Aug 2025 04:52:59 -0700 (PDT)
Received: from rs3labsrv8.iccluster.epfl.ch (nat-icclus-192-26-29-9.epfl.ch. [192.26.29.9])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-af91a0753f9sm425028166b.20.2025.08.02.04.52.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Aug 2025 04:52:58 -0700 (PDT)
From: Yueyang Pan <pyyjason@gmail.com>
To: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Usama Arif <usamaarif642@gmail.com>
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	Yueyang Pan <pyyjason@gmail.com>
Subject: [PATCH v4 0/2] mm/damon/vaddr: support stat-purpose DAMOS filters
Date: Sat,  2 Aug 2025 11:52:44 +0000
Message-ID: <cover.1754135312.git.pyyjason@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 60A59180005
X-Stat-Signature: 3fahakiitj5c7189ksrxwhf5fmxsm9js
X-Rspam-User: 
X-HE-Tag: 1754135581-401481
X-HE-Meta: U2FsdGVkX1+2exSSXTnQtI5LigVU57V3QhJc2qwMOfhxZX0D39+5pPw+swhpu9vo1rahkNgppVvx8gUtQw9mbJsZ8QhRXNLuhmKLJmF1Bp9rDN7uX45ZLyq6fAQD7rQMSqR29bWsA0bS01+ZUM0PrbRk0t2cjNnaABneBYT7/jCElGXyfnbAmSiOb+/hDyF/PlWngc9NTCLbdYFYP/y/60OsrDWHdxirlc0fUsnQYlj7nAyfLcXrgR5mHKxYfponWcpKzwRE3JcNraCFKXB2TCia9y/dUjWWRBnt9XQaaIHf47cZBEg8VC8qjikIH20GyI1HMxqZ59pZTne/3lDCQQGI24h39s34RbZXOCgLo2fJ8kuLaDrVpwPWHbW0wHP9JBfC43oRaxGrtjvUxUaHJZiPHKlTKNxEtt0fTdpKacTYgLkWSfrV7l+xEZnAQV0Y/OOdegwJA4X4MtAGsgguEkruBBxfzhfPBj9JSlyVQ3HuTicj27iGJ4fl/8W7vQtIv4/yQcr7dUorggw7xDs/J17hRZ6vscwJza9uHjMw5FeXRbnAPe2/0mzvW/T3+2i7MW14DA+YqY5Q4C6bbkR5ZcUyU7iaBzd19TwH9rABvaIkoqVoWBryx6hIr9GRSKhSQqqZ5NVubQfKnjoUXHfui6nbeEhy2HX5sytGpom8uAdPIzKPMNeqmd3g1Sd1M6TkvzWtGpu22AmiUGn3FpUdKeOib2UxRLo0JWPM7iKRzt3IhpsIe28fTqGg8jyDTetMX/9FRiAF63FNIAi/wv6nZ/YOrO3Ubk1OP4ou3xCRWOR5HRBB1QG6PBKOGOZ6SHw54kHnifafnOTojamflT2DrMUdATcFGJW3/AJDD41LpDB4iZdChfmSHz4n+LsKPvFK4cmRAyVDrJvxEFGlriyV5wTpX9twjIV9hkdrEn/z1FYG2uuTerAjtdkK2h53DQJM2Z9TG8lFsHpQ+hiUWOW
 ATt96CVe
 RAAvVdlfQbhZ67UnmOu7UV61vAfRrEcc1DuC0JJtNRYhGtcmIsAdTU0ujJfRiASIdaNIY2imxkHneKydEjkO2W9mKYbIuCips2e06Ug2H5v5TjfCBX2V6c0d01emcI/PadOURZhuXHrm1pdUTOCbXMM1spsV6ul7szYUCz4TR7l7a4NuaWvWntJNdMtra70w6jzFcTWYkFdsgpbOEPKr2YFPvE1JZMblN+UwXWg4qRDlO2960pRZNL2u6ZNmjDEJp0vnIv23fq7vF0Dl16/los5xoR30DVVazxMDNrpzWAiQ5NxMwgJCGXCrYFrh3ptWUZDUaAjLwjV2000kH346FJORoqbgIsQk1qiQSL7Ths9rWfJzlKMIvb5ryF1Yzk0HtqKrtWnFl2rhGzjnei7/FebTyIOGudZMps38172Ua/f/RMcNFHe2NSeuV9g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extend DAMOS_STAT handling of the DAMON operations sets for virtual
address spaces for ops-level DAMOS filters.

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

$ # Start DAMON
$ sudo ./damo/damo start "./my_test/test" --monitoring_intervals 100ms\
1s 2s

$ # Show DAMON-generated access pattern snapshot
$ sudo ./damo/damo report access --snapshot_damos_filter allow \
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


$ # Show DAMON-generated access pattern snapshot again
$ sudo ./damo/damo report access --snapshot_damos_filter allow \
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
Changes from v3 [3]:
- Fix some naming issues and improper text in cover letter raise by SJ.

Changes from v2 [2]:
- Fix some naming and format issues raised by SJ.

Changes from v1 [1]:
- Follow David's advise to combine *pmd_entry() and *pte_entry() into
  one. Also remove manually setting walk->action
- Use vma_normal_page and vma_normal_page_pmd instead of damon_get_folio
  to remove redundant folio_get and folio_put
- Follow SJ's advise to only move damon_pa_scheme_has_filter to
  ops-common
- Change the command used in cover-letter for more natural illustration

[1] https://lore.kernel.org/all/cover.1753794408.git.pyyjason@gmail.com/
[2] https://lore.kernel.org/all/cover.1753895066.git.pyyjason@gmail.com/
[3] https://lore.kernel.org/all/cover.1754088635.git.pyyjason@gmail.com/

Yueyang Pan (2):
  mm/damon/paddr: move filters existence check function to ops-common
  mm/damon/vaddr: support stat-purpose DAMOS filters

 mm/damon/ops-common.c |   9 ++++
 mm/damon/ops-common.h |   2 +
 mm/damon/paddr.c      |  11 +----
 mm/damon/vaddr.c      | 103 +++++++++++++++++++++++++++++++++++++++++-
 4 files changed, 114 insertions(+), 11 deletions(-)

-- 
2.43.0


