Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EBB33CAC582
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 11:32:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E1D7B8E0007; Fri, 12 Sep 2025 07:32:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF44E8E0005; Fri, 12 Sep 2025 07:32:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D37928E0007; Fri, 12 Sep 2025 07:32:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BF17A8E0005
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 07:32:51 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 64D7716073F
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 11:32:51 +0000 (UTC)
X-FDA: 83880386142.30.A553282
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf20.hostedemail.com (Postfix) with ESMTP id B801C1C0017
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 11:32:49 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=RCjLZLLt;
	spf=pass (imf20.hostedemail.com: domain of naresh.kamboju@linaro.org designates 209.85.214.176 as permitted sender) smtp.mailfrom=naresh.kamboju@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757676769;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=y6Vu9krI8L/L917eJRdmIwH3Jf+YuSh9fi/gZdnGGTM=;
	b=GUZTL756PljVHFDl+QA0Hi89dOBINFtx6vyCah8gsPMuHLdpNfYKUTQxXG4+OYt5iGu8IM
	8JZ6dO+fFG9sXoUYE1vWpMgggI4b1/Li887ShFZdpFZr4PQOqyEQVgk+SPykQbLKQnb/zk
	LKFUscZRt5WBqbtF8iiBDG4k4HcTd34=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=RCjLZLLt;
	spf=pass (imf20.hostedemail.com: domain of naresh.kamboju@linaro.org designates 209.85.214.176 as permitted sender) smtp.mailfrom=naresh.kamboju@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757676769; a=rsa-sha256;
	cv=none;
	b=DBs0mf5d/vvj96J8/YP+5MvEipSu7pjGvYynOiW5VYIowuBmMiBXPFt2OCa8rgr0jcygcg
	s6uembKaqmC69qiiRiNO2yWL8QWhD0qxqP2hnV+fyNC7dQ2rcZjPvtfevUyg72hY834Dsf
	P8XNT320kxT0kbZeNkCoLfrYVJ+V0f4=
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-24c9a399346so13344105ad.0
        for <linux-mm@kvack.org>; Fri, 12 Sep 2025 04:32:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1757676768; x=1758281568; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=y6Vu9krI8L/L917eJRdmIwH3Jf+YuSh9fi/gZdnGGTM=;
        b=RCjLZLLtqv4MuK122RSqI4Vg5APS/4FR8gN8uzybG6VDyzXvJvTVO0QVIBbSJLsja+
         NNI2fLe2UbQxCH0i3VLpK1DNQ+JiZNtT0pEF3edgPHW8QNA9oSuk6w6qC3MljQbydUbf
         t/1SMkLHjor/LZM9JEdmT/WPTO0yo6zCSSl+3qiMMQl0KtU6x3tYHqwo645Eo7GRCuWX
         +Lkq/Np2v8J6SxSZzLqn5Za6ze2bEOR7blfFVm0esPHgv7NNJIDjUrLj0GjNvekqjaBY
         yNWyFCCnV6pwUQUJuH91drdFgw9RizgmPNIn+FpBf/+VaTP4fmty21drf20Et3mH0W2W
         m8Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757676768; x=1758281568;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=y6Vu9krI8L/L917eJRdmIwH3Jf+YuSh9fi/gZdnGGTM=;
        b=v9VjP++JL8VDcYCCqG/sRUhCK4wydTePohGYBdkRKIBnTo/uHcG/7+NPuDghmGNj6I
         a0/+zfsT74oF47WtjRVI+KG9De3TaErfS9DlMoqVHF5mpfqH5WCKo/5PYpeH9L6up4qY
         kQVpKoNaoZ3OHFa4F50PB9b7UEDig8YNbjz4ykqxAJKbMD/GRK9uZimRs5Z8/WlG2bWP
         AHB9+54AeQcwAaVAIxZd/71jBNSIuXSHzOPQr9kWv5H68XVFACCaTsEKdOnt+A93A9bf
         H8mfSapCflJ7euBFBAhI7TASyJ916peDmCmo4wCCLqUYFl/mUyiVU0Zk3HHdxwOX14hk
         go5w==
X-Forwarded-Encrypted: i=1; AJvYcCX0eOY8E0kJph/wYErLr1jYfpkjvDuAAami3EjaGMaM6g3i+AXLE3DH3vsCY2a0ioKeuIdtlNFHNg==@kvack.org
X-Gm-Message-State: AOJu0YzKOuFcXrcAywpKN/8IcmSz5YT0s6+m6ZekA4nr2VA8dTS+hfir
	QAw+TGHkyR050i0luiUMGV478fN4AI+QDT9oJUzm2fPOWsUTzI06hhTMSnhF3aHLySa25LdVu0q
	qHrazefOArIeSJfw+HZ1M/4wiazTRQq9bv3JkKtMpqg==
X-Gm-Gg: ASbGnctM5vIFTSeCjf73ogV84g6jwxYEiL94SmhC3FXicK3hWQEubYyit6hkIlC/jxY
	Oy8SFgBZrjB9Cvsn7v0xVRJwgbZ3OPkqPfU8pU++oGG2IEq3rE8xHm40cw/yJqh9VhIVTO8B17+
	auKN5Pg7ysM0sSfad/JSF5SJSpBKpieptYITB+zWn28ZysCI+IjdEfXtW8XuSCqNP6qTVcpTu/s
	zodMEluS6MhaNZosWT91pBDbC8/gHi4J/IoBRXpLumF21BZoY10FuV4v7ntnf9s23pFOPx0QCZv
	QZhNs7k=
X-Google-Smtp-Source: AGHT+IF1n0wZVljtgQdO4YjkTkuDA16K7j3EGrt+LavVV05cNjZjVMw0mRnQJqWQrvbyjkw61l+wH9wnd6eTRWsTKWg=
X-Received: by 2002:a17:902:c40d:b0:251:a3b3:1580 with SMTP id
 d9443c01a7336-25d24cac4eemr35190575ad.6.1757676768437; Fri, 12 Sep 2025
 04:32:48 -0700 (PDT)
MIME-Version: 1.0
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Fri, 12 Sep 2025 17:02:36 +0530
X-Gm-Features: AS18NWCRkwK2BEtW0uxWjqehT8uEFjWUmULflZWeqoftij31KvQE0_RmSXQs-jg
Message-ID: <CA+G9fYvQekqNdZpOeibBf0DZNjqR+ZGHRw1yHq6uh0OROZ9sRw@mail.gmail.com>
Subject: next-20250912: riscv: s390: mm/kasan/shadow.c 'kasan_populate_vmalloc_pte'
 pgtable.h:247:41: error: statement with no effect [-Werror=unused-value]
To: kasan-dev <kasan-dev@googlegroups.com>, linux-mm <linux-mm@kvack.org>, 
	open list <linux-kernel@vger.kernel.org>, 
	linux-riscv <linux-riscv@lists.infradead.org>, linux-s390@vger.kernel.org, 
	lkft-triage@lists.linaro.org, Linux Regressions <regressions@lists.linux.dev>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>, Andrey Ryabinin <ryabinin.a.a@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@redhat.com>, 
	Dan Carpenter <dan.carpenter@linaro.org>, Arnd Bergmann <arnd@arndb.de>, 
	Anders Roxell <anders.roxell@linaro.org>, Ben Copeland <benjamin.copeland@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: B801C1C0017
X-Rspamd-Server: rspam05
X-Stat-Signature: x19g6hyaknd7rgygd7zys1mc6xu71qnu
X-Rspam-User: 
X-HE-Tag: 1757676769-900601
X-HE-Meta: U2FsdGVkX193eG1N7Wm26LvqhrgcK2M8IyC9YnG8JVhXvB74JcvX/2fJpN0gh4Wq9OhHnTby17DwdazzcKzjdT0gWF3evgM0EiKqdmLXfSeXZt7Qv5Ben1PaqFm3mcwbKE5qL1jmlsR0Wh9sRjHuNgnNfjfzLy85erdAYIo8jENmDq1kQvgh6psL5hWMQaqEQCOucTq8c+cmt7HV+pAqkyGT0TAhuyWQjyKd/mb+LqE3Si6Be4NbeiBn3AqgWyLvdcVyv/fT0CM7gdCeGa02JsBoFWMsg9bAf+AVs7+dZ47TsWBUL6lt4OkrYjTwQwIn2lSceM50EbPajbHHXnKPbYWAKowNsZNdKaB9oew07U+i17TfqSs6z2aKrNs7/j2L7VjYWVwc23JcXyiJzpUztyYDZQj+zKDNCF1Ca9ilTdH6zw14oBWRAHUbH5gpFyB73ZzL9MmjmuFeHAroAss+mK0dhEzfIXhNswgWOvzfQc8RKB7Js2A3K4XrVkydVgOf4yDtFfFAK7Uc5qRLfLPMGVsHwrQU4YiWfOaPTWxqAJxvEPQwV4E89nZ9wLvCtSAPIiaNIFLpCpqI3Sdy2xKjUgBF5XOajN5GYfT1O1PE39vTICRSVowipjggCkryUK2YV9Y8BPBa1QcLMbPgn6cB6kqtXpKbUl9EwXUCzDj9/q/X3baoC6NHURGtQLMvopRfdO6wDzpkIVgVB1MoEicQgeUVr+0k+xDyUxodEB7honhIMTT/mucs6dQkJmTdPxc7oCEJs8t4EymjXLG5i1FAcZXc5LFWny9g3l/8NtL5PJnv6C3i/TVl0BiUQWAPVHPXdR11FFjtL7RBrw9LRbRlcvcpJct2AoW+q9XeV7vcGg8kP8wHW3fjXdh0iWr9iCbSuS+3dER3EHx77MAvb740Y5T9dBHHKicXqO3Z9j0VP0HxcDd4DUMeBljoGMtz2OnJJldRiuLI9+mGqeFGfEH
 zj5zkZjc
 Agk8Yv8akps2IPeZ9bazN/5ZmyJT3EdP+4AnQ7qspwY29JFq9t3IKyM4q2Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The following build warnings / errors noticed on the riscv and s390
with allyesconfig build on the Linux next-20250912 tag.

Regression Analysis:
- New regression? yes
- Reproducibility? yes

Build regression: next-20250912 mm/kasan/shadow.c
'kasan_populate_vmalloc_pte' pgtable.h error statement with no effect
[-Werror=unused-value]

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

$ git log --oneline next-20250911..next-20250912 --  mm/kasan/shadow.c
  aed53ec0b797a mm: introduce local state for lazy_mmu sections
  307f2dc9b308e kasan: introduce ARCH_DEFER_KASAN and unify static key
across modes

## Test log
In file included from include/linux/kasan.h:37,
                 from mm/kasan/shadow.c:14:
mm/kasan/shadow.c: In function 'kasan_populate_vmalloc_pte':
include/linux/pgtable.h:247:41: error: statement with no effect
[-Werror=unused-value]
  247 | #define arch_enter_lazy_mmu_mode()      (LAZY_MMU_DEFAULT)
      |                                         ^
mm/kasan/shadow.c:322:9: note: in expansion of macro 'arch_enter_lazy_mmu_mode'
  322 |         arch_enter_lazy_mmu_mode();
      |         ^~~~~~~~~~~~~~~~~~~~~~~~
mm/kasan/shadow.c: In function 'kasan_depopulate_vmalloc_pte':
include/linux/pgtable.h:247:41: error: statement with no effect
[-Werror=unused-value]
  247 | #define arch_enter_lazy_mmu_mode()      (LAZY_MMU_DEFAULT)
      |                                         ^
mm/kasan/shadow.c:497:9: note: in expansion of macro 'arch_enter_lazy_mmu_mode'
  497 |         arch_enter_lazy_mmu_mode();
      |         ^~~~~~~~~~~~~~~~~~~~~~~~
cc1: all warnings being treated as errors

## Source
* Kernel version: 6.17.0-rc5
* Git tree: https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/linux-next.git
* Git describe: 6.17.0-rc5-next-20250912
* Git commit: 590b221ed4256fd6c34d3dea77aa5bd6e741bbc1
* Architectures: riscv, s390
* Toolchains: gcc (Debian 13.3.0-16) 13.3.0
* Kconfigs: allyesconfig

## Build
* Build log: https://qa-reports.linaro.org/api/testruns/29863344/log_file/
* Build details:
https://regressions.linaro.org/lkft/linux-next-master/next-20250912/log-parser-build-gcc/gcc-compiler-include_linux_pgtable_h-error-statement-with-no-effect/
* Build plan: https://tuxapi.tuxsuite.com/v1/groups/linaro/projects/lkft/builds/32aTGVWBLzkF7PsIq9FBtLK3T4W
* Build link: https://storage.tuxsuite.com/public/linaro/lkft/builds/32aTGVWBLzkF7PsIq9FBtLK3T4W/
* Kernel config:
https://storage.tuxsuite.com/public/linaro/lkft/builds/32aTGVWBLzkF7PsIq9FBtLK3T4W/config

## Steps to reproduce
 $ tuxmake --runtime podman --target-arch riscv --toolchain gcc-13
--kconfig allyesconfig


--
Linaro LKFT

