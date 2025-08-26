Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83C72CA0EFA
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 06:21:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A22F88E00A1; Tue, 26 Aug 2025 02:21:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9FA668E0090; Tue, 26 Aug 2025 02:21:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 937188E00A1; Tue, 26 Aug 2025 02:21:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8320E8E0090
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 02:21:06 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 01DC2140606
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 06:21:05 +0000 (UTC)
X-FDA: 83817910932.22.D40D77B
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	by imf18.hostedemail.com (Postfix) with ESMTP id 3BC5F1C0002
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 06:21:04 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=rxgg7nAh;
	spf=pass (imf18.hostedemail.com: domain of naresh.kamboju@linaro.org designates 209.85.215.174 as permitted sender) smtp.mailfrom=naresh.kamboju@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756189264;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=MFYRl1ZFHjhZrd7h6GtCM5LUiRUxEc7ppUKwn5M/+7g=;
	b=JUik0CDkUstxGRTN2p4ihlytXRBEI8KvY/GBd+U+UKVp21NoNDwwYlHowjviF0vQr1sJnq
	bpgsFg/U1ZAFy292Wfy4veHpHnDCJCvg4CwtEN+mNDhTgrdTS+6O4Hl65XG9qzoxn3Mydk
	R2EoJGB3YH/golLw3imZxXsan8Ki2ok=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=rxgg7nAh;
	spf=pass (imf18.hostedemail.com: domain of naresh.kamboju@linaro.org designates 209.85.215.174 as permitted sender) smtp.mailfrom=naresh.kamboju@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756189264; a=rsa-sha256;
	cv=none;
	b=gG7E6gM7nXZ2yyzqChPSd1AbV5pH71cDy+v1nQKsSm8QrStczNX9rqfzNvnyAXc1biLBQX
	PGrABfFpOVPRM5q5Xht88FpY/vhv5AMBOlfZ9MldqVbHvZOT7hkpD736BerbRG/JQkXfTV
	jNRyOf4kFmsbHb58ItUosFlmKu5sYvo=
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-b4717543ed9so3522844a12.3
        for <linux-mm@kvack.org>; Mon, 25 Aug 2025 23:21:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1756189263; x=1756794063; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=MFYRl1ZFHjhZrd7h6GtCM5LUiRUxEc7ppUKwn5M/+7g=;
        b=rxgg7nAh/ojtaRN0nTeKvPSDNHvT3jdAtJfWLEwyuCaGQ88UKwv4Ukc/jXX/bSquNg
         WM72of6xDaSs6EMvGeixM41e8VYORhxSZOCrsKdQSlUiSC6dxS6cswDbzNXfDC0zIJ8E
         cJrS3Oq7dmQWFyDjUMM6Wi907Scuty4CN/ZtmD/fOQXQJFn4voj77SZxDrozfAfBm+HX
         jUuKu9tbeLcKWtgkIH4xsPPzzINcrBfKVyMDjgmCHVAu2euX+/wFVzaDZi6RAT6TrHKh
         lC1ucuUtIuXXnEcVVapw7ItjHU6XvH1ct3hied+HfFBNY6qTbskY+l5U6x6W446J/j0s
         LuKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756189263; x=1756794063;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MFYRl1ZFHjhZrd7h6GtCM5LUiRUxEc7ppUKwn5M/+7g=;
        b=qJ9FuiUWsKShQlhWkX72F9Tv4PEfpIBUpVULJR/G3GzcG5dZOMpUNfg83iKCWkw5AX
         PL5poOq0fLjk2sUmGzY8N5i+CeLO+fAtMFcAShGI9vRR0OzcHLfcVmS5jbQZ0Ra9JrHH
         ad3cXQdSmqCIB3ySEiqfnlinjJMlm02sbGb0/AHxYDlZCOh4+pBTpTOJbPXh6LtQrD1+
         hNq8TuPikwZUtjtMeZJ60+mBIN39dNsY86ivDCBrSgL/pwUoq3RuEkrkZ3WCxIrnyoon
         iXYw0i5mM3mKNAApZZVJpL2e+A+bBCknnxeavLK42qIV0dQsYTRz1PmtVxhlm2z4ZwgY
         cnPQ==
X-Forwarded-Encrypted: i=1; AJvYcCUcJrZVRy/CM/Gm7KKDZzDoLei5yhlgB1i57DqTa58F3suqZnxvn2B78o9wiWs13F7UZSoNDMFqDQ==@kvack.org
X-Gm-Message-State: AOJu0YxHVUDTsmc6jQlJNLNgZ8GRO4x5dkplT9CCTeh0S9Gu4nlvSvXg
	egkVmJ86iUYrXNCI+APih5VPv/cmZykI/gIx5qeR32ucotBZ353+E3UAyKikqv1tlDQw0OYwf0w
	q1arOyaV1hO4Qn8EGE5p1czc4rMXFIuEJ8Exs4ljYKQ==
X-Gm-Gg: ASbGncvPB0ugmAgy3iyvI7yKvw0rFLadC4UobUTndHNm/Iih012sFVeSPhD+GtGdGam
	/hV/7Xy56spM+tTb5FEr1noiy/FplLSsFse7up6omsMJt+BXOUvB7pLzK24VUPyu7RTK/9udhjc
	6KQynG1bMuQLoQApdVDvA4/gdrovC2sRepVem6/Rxs//INxFIXf83ji6rLIi1dcGZTPjstq04b8
	GixetP1+ckqoDvfypDrxJ3UB3tlKpwmIha/Awc=
X-Google-Smtp-Source: AGHT+IEaOAsyEwvYZhL6gwxls7OPv3CjgiN4RcC1NbjL3gx6dd9cjdG1OkopmuigZ7xW+OLJUx5JyXWtdmH6vWAFnIU=
X-Received: by 2002:a17:902:d585:b0:246:b41a:bb90 with SMTP id
 d9443c01a7336-246b41ac045mr106384895ad.2.1756189262339; Mon, 25 Aug 2025
 23:21:02 -0700 (PDT)
MIME-Version: 1.0
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 26 Aug 2025 11:50:50 +0530
X-Gm-Features: Ac12FXxpo9Z2nstlPDzyogezkDDH4eyaoMNNWqxf1iMYZc7Yw19lKOYzdQTyf50
Message-ID: <CA+G9fYs2Wp33dq0jeuWqU+67z3VzP2LyHBXSD+SecqqG2OiJfw@mail.gmail.com>
Subject: next-20250825: riscv: pgtable.h:951:40: error: incompatible type for
 argument 2 of 'page_table_check_pud_clear'
To: linux-riscv <linux-riscv@lists.infradead.org>, 
	open list <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, 
	lkft-triage@lists.linaro.org, Linux Regressions <regressions@lists.linux.dev>
Cc: Dan Carpenter <dan.carpenter@linaro.org>, Arnd Bergmann <arnd@arndb.de>, 
	Anders Roxell <anders.roxell@linaro.org>, Ben Copeland <benjamin.copeland@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: fuc5hj7u9zmhbdg7zrcsambxc8qdz6ty
X-Rspam-User: 
X-Rspamd-Queue-Id: 3BC5F1C0002
X-Rspamd-Server: rspam01
X-HE-Tag: 1756189264-298917
X-HE-Meta: U2FsdGVkX1/VS89eJWCoDxfZaiD7STFTMKUru68c1JXur3HovzNa1LaxkqttCEATxmrRrveO2Ar3LDD7LYNXyIN5MMAhADeMfTwUl8/8eKu8akZThNBEU8m+Skliq7T9D20rkEZg2I97MXvo9zbRAqh7SFyRKhKqb5PkAlRPSc3+Eh8BbvP0TPAVtTZ61zCZ39yq0CNQvPDE8p6gTL8nD7IXg+j8mSkRWl5kwfJqQfV4eGL8rXjFMFzDYmmqWs+oKisKLjDyPdx7hb9m4ZLZmxEIkoSZ9i7N7wkeTCzwgSsk8iTi4jPWPibyI7Ayy1ZCHRi5CyA3fdSKJrtHPxpqPtpHlgJaTjMmQLBOJ2Fb40FUDvVm3Aw6AirdG3p8/s6E5/HRg67Uo1B+KQTGE/imRslIJkXbTS6TyMav0ICvoc6PCqKfmHUODYCk4u5/g9sWuHzbYBxJCqQ7cRPe+epWy67jAkY7IL0LF0gL3EM8XeX72MAT3vI6tbum5SFZjea2esaVCbs6JfK6Z3AWEzbZJbRqczuTFBGJatv0o2347uBkLVjl6ddI6uDeJNeU40LUKnmUUCwtCtNxB4AyytzAyaE/HbblLlQCirlwXVDRZXi6NdCPlzeW+iMTmh37p8madgXz6739aNe99Qh6RgLc1qojZWsYNUAD/0Vp37edbQtPDwLpNfEllg/kmcKCBhZoUTrIG1gDTlKF55ZfAxZRCHgxLrAQcgWjb6UWV9KdI5wNbxljKYiYSnFPjH8yWE3djX53kPGvzIdwdlh5kR0huVKS+jwO7/gNs6wK92kDqbsqwq9mcru70IvYLs1EeWjXqHnrgtPUXXUxOteWRbSJEASIKPkivH5qlbANud/TFdp8pOd7YV20nIj7RHbkWOVE22L7TI8aqYpr3B7pXLwdGY5L1cBJfB5rtlXF4k2fRqh1uqNbCQ9d3LCCFNJinUrZtINJ9Ad3hRwhelR+e1j
 XR2UaZmy
 fUFNW1Wgbz6v0oWXmPTCMMDCdewDJ41LnLyLfdZ+5+agnOCqnGAnBJ6sDhbBdkHx0Bnmp+iwCGpb6XZ4RKsqnmOqljwSYfsn9F1kZ72Hluq4M288bSYhfxcUdCUGt4MDu+ClpBKMzj3EkYZA+4T+Ngiv620QCZccyXBe5Lj6ETAKu0AYN3OkPgcyNadu7hDaH1ZV9Zi5bRwoFwhg7iYJWDBIrNMpow09ErFy/GfbTmUvXaDvOed2nb4v/2Ew1kb+FwQX5desqKSRQp8SfvyLsL1rKlrNm4jMzpesnSQZVq8aQr+COrBYBUFNbSOgcAYPbmX5geKLtjMmW+KBtBctYJK1BewGGLZvLnHrYVyZqgEi69hy5YT3V5Sbayg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The following build warnings / errors are noticed with riscv defconfig with
clang-20 and gcc-13 toolchains.

Regression Analysis:
- New regression? yes
- Reproducibility? yes

Build regression: next-20250825 riscv pgtable.h:951:40: error:
incompatible type for argument 2 of 'page_table_check_pud_clear'

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

riscv:
  build:
    * gcc-13-lkftconfig-rcutorture
    * gcc-13-lkftconfig
    * gcc-13-allyesconfig
    * clang-20-lkftconfig
    * gcc-13-lkftconfig-libgpiod

## Build log
In file included from include/linux/pgtable.h:6,
                 from include/linux/mm.h:31,
                 from arch/riscv/kernel/asm-offsets.c:8:
arch/riscv/include/asm/pgtable.h: In function 'pudp_huge_get_and_clear':
arch/riscv/include/asm/pgtable.h:951:40: error: incompatible type for
argument 2 of 'page_table_check_pud_clear'
  951 |         page_table_check_pud_clear(mm, address, pud);
      |                                        ^~~~~~~
      |                                        |
      |                                        long unsigned int
In file included from arch/riscv/include/asm/pgtable.h:139:
include/linux/page_table_check.h:125:75: note: expected 'pud_t' but
argument is of type 'long unsigned int'
  125 | static inline void page_table_check_pud_clear(struct mm_struct
*mm, pud_t pud)
      |
     ~~~~~~^~~
arch/riscv/include/asm/pgtable.h:951:9: error: too many arguments to
function 'page_table_check_pud_clear'
  951 |         page_table_check_pud_clear(mm, address, pud);
      |         ^~~~~~~~~~~~~~~~~~~~~~~~~~
include/linux/page_table_check.h:125:20: note: declared here
  125 | static inline void page_table_check_pud_clear(struct mm_struct
*mm, pud_t pud)
      |                    ^~~~~~~~~~~~~~~~~~~~~~~~~~
make[3]: *** [scripts/Makefile.build:182:
arch/riscv/kernel/asm-offsets.s] Error 1

## Source
* Kernel version: 6.17.0-rc3-next-20250825
* Git tree: https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/linux-next.git
* Git describe: next-20250825
* Git commit: 6c68f4c0a147c025ae0b25fab688c7c47964a02f
* Architectures: riscv
* Toolchains: clang-20 gcc-12
* Kconfigs: defconfig+lkftconfig

## Build
* Build log: https://qa-reports.linaro.org/api/testruns/29652465/log_file/
* Build details:
https://regressions.linaro.org/lkft/linux-next-master/next-20250825/build/gcc-13-lkftconfig/
* Build error details:
https://regressions.linaro.org/lkft/linux-next-master/next-20250825/log-parser-build-gcc/gcc-compiler-arch_riscv_include_asm_pgtable_h-error-too-many-arguments-to-function-page_table_check_pud_clear/
* Build plan: https://tuxapi.tuxsuite.com/v1/groups/linaro/projects/lkft/builds/31lrb0XugzFZYDePlPNpSIVTzeB
* Build link: https://storage.tuxsuite.com/public/linaro/lkft/builds/31lrb0XugzFZYDePlPNpSIVTzeB/
* Kernel config:
https://storage.tuxsuite.com/public/linaro/lkft/builds/31lrb0XugzFZYDePlPNpSIVTzeB/config

--
Linaro LKFT
https://lkft.linaro.org

