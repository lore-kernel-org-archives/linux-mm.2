Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 426C6CAC58D
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 08:37:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9CC2F900002; Thu, 11 Sep 2025 04:37:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 97D548E0001; Thu, 11 Sep 2025 04:37:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8BA10900002; Thu, 11 Sep 2025 04:37:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 752728E0001
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 04:37:19 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 365371403D0
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 08:37:19 +0000 (UTC)
X-FDA: 83876314998.01.FF22B00
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf03.hostedemail.com (Postfix) with ESMTP id 67CDF20005
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 08:37:17 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=R4qvQjRQ;
	spf=pass (imf03.hostedemail.com: domain of naresh.kamboju@linaro.org designates 209.85.214.175 as permitted sender) smtp.mailfrom=naresh.kamboju@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757579837;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=XlHLF6IxLX265PKrXSfqim3Osu2zErg+VtcQhos8Amk=;
	b=tVbyAIhVTFJYVUqMZv1hHBYPYQzgXyWb+hnJEZ9qJW1kei/cviLG61AB/MUe6iolTO0Mka
	Uw0/lzRNas2cgEs+5j2jpTSo5rG4mepg3hzN9ZzHuGGXAnsswK4SrDdEEFTsFMrOlsQ5gx
	ZCcZW4wGGW5uCdCKk9pN7J0eNw1ZF1k=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757579837; a=rsa-sha256;
	cv=none;
	b=7/A6CQKu47telWRUAmWjLBp6NSYGkn4XOk21TULK4ifeoc9NafGtyAw+yIyKGVYzc151hG
	YdF4bdAr7uOdT+eZ/rbS5mTdgKGsdQg5DLcQwCwmVjyGI00WXXFTrb99rRPf+W245bnWt3
	7lZL1MmiXwZmEjV2mFSh/UQR0CUVAI4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=R4qvQjRQ;
	spf=pass (imf03.hostedemail.com: domain of naresh.kamboju@linaro.org designates 209.85.214.175 as permitted sender) smtp.mailfrom=naresh.kamboju@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-24b1622788dso3121655ad.2
        for <linux-mm@kvack.org>; Thu, 11 Sep 2025 01:37:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1757579836; x=1758184636; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=XlHLF6IxLX265PKrXSfqim3Osu2zErg+VtcQhos8Amk=;
        b=R4qvQjRQkYnXLmcNuuDF2icA3ecHMnC/jqNpRtugqSnuEBNEXMjBEmSt2DQF2rbxKq
         7LJuxpZt72pThcoaaCNdAbMr+vtS05MZDYX95kOUU0UtWrCEYOe5mLLK+Be8C1ciOat/
         RjKWyjLVQKiXkfKJ1Gwl/atnr2uxRwqUR1Lm+VOgmYMfimxwPQrRd6Xex92iwvLIvkXN
         TRj2OGC/zGrobqjfUVvfWnqkRz0/q6XK6v/VlRuUPSwiYfK202rYsL8xyENM/gHu4Dw4
         NF0n7f6ny5Hf1ZRbgT6CdL7D/o3iAoeHq06Yj3TMOt3sG+IUVc1mwV6H5BYL1MwSw38O
         8GlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757579836; x=1758184636;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XlHLF6IxLX265PKrXSfqim3Osu2zErg+VtcQhos8Amk=;
        b=dp1wNRjtyfvBwuNdNnXIIRvSZgCM5FkKiBxXeGigtEPTkSKiuJ5eNE2mfQu5yFl/9j
         EpteVNpiaXusnYbEDVkV6gFz+E+1mBivm6+ICVqtsH/L1gBQDPT3XvD+C6N5wbJ4HGzY
         FLwp11YLQJeKanOjElD0a835MJe8/aj6CAeB3i0sWtBPwi989kHt7QfBjux7n6XgyfYO
         9fGGDjGjaYqkCchPx54WJoZZyFYG90GmcGMxSJeBbSEhzxqrrNc4HPNp4mqq7vjEjaxD
         BimKEVWslULmdcLTiH2G02OGE9FezROX6HnGYrZFWBn9Y7fC8uHxVjpFZh/2rbl8onHt
         hyfA==
X-Forwarded-Encrypted: i=1; AJvYcCVPS+GGyL6VzEsXfcDNSaDpnf94JYCXxT00oU2iJ5SOwUwk6s7L9vPmGUvz7pExmR5T4eeQT2so5g==@kvack.org
X-Gm-Message-State: AOJu0YwJMbujcWCNhUaiEmvHR2uxfPJsL/s/cm5VNFGNNn0epBRJcDYT
	3PYhMiiVqAOnPCPnWci0VpbbOrIaWj3/MWCE0CW7xFWpXfWzkZi7w6FO39Wg4fZBlJb0Zgk9774
	Yhr8BWj4hGRBB4j8XRCSFDI7biCOuqk8rPCi/F8ZsQQ==
X-Gm-Gg: ASbGnctpfyuN4MRXDLK5aCoxENPJBGePxBaR4gqm00FPWrvKjAluHKuxCuMYZbqToTm
	KKFCclwg9xcENsunCmjsxhaEcb7Os+fV2msJeS70nNy643yriLYxqP6VfuYw2068whT5UcQ4+mb
	MnbKzO764BckPDj6pqVZmRcBmhWngoVHHokrZHpTW6/sBgXhXM9P4dlSpH5AYp1Zs9LLfzU3Bxw
	Wn9x85iplAn7GLhflYhZ5fkp7T0N9aPj099WL4kElqXLvSpwbl74V/Un3zPfLMRl3byAxXc6JW5
	cSE8Vfg=
X-Google-Smtp-Source: AGHT+IGR2+igFyrerQ3HlTU0fDr7FuwZJE+/EsvxJ0BM47OK3QyzESdHU/BATUPNXmekU8opkqkhhnxnT4KYCn47WJg=
X-Received: by 2002:a17:903:230a:b0:24f:30dc:d3fe with SMTP id
 d9443c01a7336-25170e428f3mr249071415ad.29.1757579835668; Thu, 11 Sep 2025
 01:37:15 -0700 (PDT)
MIME-Version: 1.0
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 11 Sep 2025 14:07:04 +0530
X-Gm-Features: AS18NWDVnn8cWFJt-IwGb3BydlPhAt8pRyLoCxHvXGT9gVTi8T47w_BuQztkQok
Message-ID: <CA+G9fYtUi3bnZ2zycCot6KGeZcn67JAvz=wZm=6f2w9ZnL=0Uw@mail.gmail.com>
Subject: next-20250911: mm/slub.c:3960:27: error: a function declaration
 without a prototype is deprecated in all versions of C void flush_all_rcu_sheaves()
To: open list <linux-kernel@vger.kernel.org>, lkft-triage@lists.linaro.org, 
	Linux Regressions <regressions@lists.linux.dev>, clang-built-linux <llvm@lists.linux.dev>, 
	linux-mm <linux-mm@kvack.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Nathan Chancellor <nathan@kernel.org>, 
	Ben Copeland <benjamin.copeland@linaro.org>, Arnd Bergmann <arnd@arndb.de>, 
	Dan Carpenter <dan.carpenter@linaro.org>, Anders Roxell <anders.roxell@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: hh58ix7rmami8ijmswwfrf7t3d41iuag
X-Rspamd-Queue-Id: 67CDF20005
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1757579837-83344
X-HE-Meta: U2FsdGVkX1+KzRL95dvjSHCvNpzr7D5kV4/NXVL8mbbGDYk4+tLsMSPXT1kpGeqIxUYfWz1MVYQJuLst2YYcne/4sh5Thm3S9uT5zmFLI5xSsKpSgq6Gr3ETXbS8+AK5YgAoYzaBcFPGyHAK+UvgTqnAi+kxOZ/MteN7QwZqfmrolp9DJEH81H/HaLmf7aJiyedZ9QC8uWEhLzMj7FwJIEPxIT2UcaJ50Rq2vKhkGsCFSVqJYNYNQQqN/xzROqNkz6YapYC3gz6NE2c9AjzACw0Vvcu+NxzoFdPPdDt0CNDJPiZiWmOfHXpmrt8ePMZ7bslL/N4amWO8kK4L0QQbUdjWQQSN7i//YVOiLTjuAbVR3P0GOYis0E587W7Kq7pC/++cjaJJG7hJDSas05RPjpdP0PWmbskb4VEJFVxR68mae2nzVKWCy2DooMH4HCOLpBzYbVQ71o1fdr4PtL1CwyWF1jUPvsxrBgPkLHhmQwZPV0+Pgrtw2pQpGDypulKmGE+CaiakFdj/L83FpAhm8+EoCFpdPseJcNps/S50B3W9fCfSExpDAg49J7LwCDvCkkhXwW0Zo44Reyjo/F9ogEC/3iHTnon6kriyAAwDIynLPEhsoetXaZ8/QKL6AXnnIt6CePy648aL1iT0F/WNzHuxXAl4mAxBU966/6t3rvxgGnGbJCNZyd7yAw65oEX2O9xP5B/d5XP+xp0w0Mxt2BjiispbwnkwOglUOtaepueTXv2RosOL9/vPIIuGyclr6XRiWsacWi4NS0y2zb5sPaKhtpnBHPWO551nSYTigKz0WEKUCPJlKM8xg9JuqNYlOVgqoqstwtkOLvHu5na0FTXsTl41MjQQC8h6k+d/Js6T4133jZtjJyo+C/7a4L56k2Nf5OMNYdTBQveblo8Gh1VjQDvh89qXcvC3mgri1rzXfFQFraFkFmCwi4aH5uE+eYL0uy+zVW6sUOTLTyR
 5L1p1qCT
 ZPP0ZOKAFDsXOAFm4PuvvL1JkGU7ocKFhVWCq7UvU2t8p1XuOFAnDnhykPwxsDRV5I3vvtsNdNAcGyztYNE5PzFHVKSLg8FuwiRIRazzyhcUUd0OQaq5MHzTONFHB5l0DKERiHBscuZnAx4LFQW9E71u50mS3JXmod9igYWPcGKXFh3SN6KYzArcuKVN9cYRjJ213TtAWRvG97Ay8RB/eKc2+OpkJKENQ8046ewk8HKECga8tmnW98imD7DYTyhKGxDKZBN+5hM534GpBXg8B8Gid9iv/0eQiA0eH0wd/WBxdtOjEn0QWUohjNi2YbtL7khz/Yw+JHBwFfbkIUUikbm7rmoXOXkOLScP2a3SFp5CLM4bo2agmwZx/YtcfZHHGxRDF+QfRiSX7e93IhBjNaa/Fvc6xquK67yB44+vX7Q6ToUstq0JjuUUvGgJ/yjnV1xe+
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The following build warnings / errors noticed on aram arm64 defconfig
with clang-20 and clang-nightly toolchains on the Linux next-20250911 tag.

Regression Analysis:
- New regression? yes
- Reproducibility? yes

Build regression: next-20250911: mm/slub.c:3960:27: error: a function
declaration without a prototype is deprecated in all versions of C
void flush_all_rcu_sheaves()

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build log
mm/slub.c:3960:27: error: a function declaration without a prototype
is deprecated in all versions of C [-Werror,-Wstrict-prototypes]
 3960 | void flush_all_rcu_sheaves()
      |                           ^
      |                            void
1 error generated.

## Source
* Kernel version: 6.17.0-rc5
* Git tree: https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/linux-next.git
* Git describe: 6.17.0-rc5-next-20250911
* Git commit: 8f21d9da46702c4d6951ba60ca8a05f42870fe8f
* Architectures: arm, arm64, i386,  mips, powerpc, riscv, s390
* Toolchains: clang-20 and clang-nightly
* clang: Debian clang version 20.1.8
(++20250809043815+87f0227cb601-1~exp1~20250809163919.3)
* Kconfigs: defconfig+lkftconfigs

## Build
* Build log: https://qa-reports.linaro.org/api/testruns/29853978/log_file/
* Build details:
https://regressions.linaro.org/lkft/linux-next-master/next-20250911/build/clang-20-defconfig/
* Build plan: https://tuxapi.tuxsuite.com/v1/groups/linaro/projects/lkft/builds/32XlFDtH7RdddaA6FHskupLDDSO
* Build link: https://storage.tuxsuite.com/public/linaro/lkft/builds/32XlFDtH7RdddaA6FHskupLDDSO/
* Kernel config:
https://storage.tuxsuite.com/public/linaro/lkft/builds/32XlFDtH7RdddaA6FHskupLDDSO/config
* Build log details:
https://regressions.linaro.org/lkft/linux-next-master/next-20250911/log-parser-build-clang/clang-compiler-mm_slub_c-error-a-function-declaration-without-a-prototype-is-deprecated-in-all-versions-of-c/

--
Linaro LKFT

