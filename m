Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C519CA0ED1
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 13:55:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D7F588E01F5; Fri, 15 Aug 2025 09:55:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D30728E0003; Fri, 15 Aug 2025 09:55:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C46A98E01F5; Fri, 15 Aug 2025 09:55:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B5BC68E0003
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 09:55:58 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 419ABC0186
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 13:55:58 +0000 (UTC)
X-FDA: 83779140396.07.B95E5B1
Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	by imf29.hostedemail.com (Postfix) with ESMTP id 7F689120010
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 13:55:56 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NgO3+Aq1;
	spf=pass (imf29.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.222.170 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755266156;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=7sGpDHu0WxbXQtKyhY1Cb6ZZbvTz1iWAdpNXzbeXC1I=;
	b=uxTRlgq2/j93BoA1xeFlImpqW+jMX68I4vo+AkgX7LF+B6adjCfarer/+fM1ktwauyELRw
	Lba8zanSNPxjByxvO0LbAQVokqRTG+zQ0zXwrgsArlcW3v2/wn1Jo3K54v27UUQWmlXe8m
	6ngmgkydrDHniP3bXu9vJ32FRAtiEmI=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NgO3+Aq1;
	spf=pass (imf29.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.222.170 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755266156; a=rsa-sha256;
	cv=none;
	b=Imk8y8k/rKN9b9YAuzETK8HQzeXCOyQ/ZRPkd0LLrKcRQ2s3Y5r4uDGcBnQQ7FY1ppkoE8
	xgEkGCou/God/qZW89kdC01SS+k1BheWUhmnaOVMm/abBDwqlgUJakERuWYaDjH/GVR3rC
	+YYEhb5DyPUaN3KU/DVXiya3IZhFD2s=
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-7e87061d120so204427585a.2
        for <linux-mm@kvack.org>; Fri, 15 Aug 2025 06:55:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755266155; x=1755870955; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=7sGpDHu0WxbXQtKyhY1Cb6ZZbvTz1iWAdpNXzbeXC1I=;
        b=NgO3+Aq10PkOWk2y+KnYwq9SmZ72krvrr4aTLCNTWPRNreJddQdpsYHW/RtrSklZ26
         XQ65Yrgj+Db9XL//Jo123yJt/bKEYs4nWB85gKtsxAaJJknozi4oEDNVh3cOJvSHQtt2
         kTQVUNL0wrCgI9tg8SiHNcs0N7rG2+49tFUmR/y6I42JNazldxqzPtQx7NTUCNYqVpj1
         nF3aAvS3RA5IJblLRc0XNP26g2lcox/IVLIvGB9GBgpQpqn2qyMKb3y/04FwxbGHWa2C
         b7wAGiszqZFjbNuGP/T4iozQ+yQJOnN+nhbqc97Vm55z8WIO5bDhnBg+KCIxGnzeOp4G
         OCyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755266155; x=1755870955;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7sGpDHu0WxbXQtKyhY1Cb6ZZbvTz1iWAdpNXzbeXC1I=;
        b=lP6IdTY6omjpTYHAPNV8zQzEwlIJbBtur+PZAFt1ksUyr73vlXCQV5EoqtJjp4V+Jd
         I9wSsUhC2IBz4Xodiw8CpLTBJ+Ii/TwasHxHk/UAyeRdSF8kSLDoAPypmP2W2Od9jmH8
         AOw4o5gWaw0pRQKQHbXOG4N7x33Ugm5fpQYGbTJWBmhT5hKbuKu2ZULBXgqkaJK3XLiT
         YkPxVCViTdqL59XCe5uQKffGb9Hw/p2GAojjl34vCI1R9Sb713v29RQBnMRUqmszaCi2
         VseMqzTQUL81VYk+hkaxjpp1dNnFnLW6aH5myhD5c38X7RJ4MGgXgoc7FBip21Vx+0Sb
         kaMw==
X-Forwarded-Encrypted: i=1; AJvYcCWimBZWVFDxqLMareRh2nfiZUZzKul7rgxS/ICfXAmXdfH/bcZhhzma6q1ulc5XW80+Fk1xgzUwVg==@kvack.org
X-Gm-Message-State: AOJu0Ywako81Itz6Rjy3YZF8jDM2SM8++7VnhK31kSbkpXSOVnGPyOqz
	j8Y/wCATVBxR//RWDLswkmGh2QoAY+S9GNiei4vqtRDQZ99Y366rD2Tz
X-Gm-Gg: ASbGncugeIIxiS7PnqSpjP9uW+HZ8qAHTzvRX3enTpEpUoSxU7q107zJe6ZJazXyKI1
	Qvsul6KwZ1O78CQ+F+P88hC0RPcvvDTaGa4j8C0SZZiIlfM4wBaxGaDSs+C4t02pxp7PAuSd3Ex
	1eWPwJOZWoebLXoDMuemoLNVOS5BEKiz/tx1B2DshDVoPE4Gm64E4CNhuc/ghDq/Np9SUAWHXRQ
	svwjInKgDI6PuYgJh/157sa6GfRfs6WDEeEMZojuR8vIV05bMv9aGwxF0wBNW4VQ2JR+KcrlGc4
	1qu0DRNw1fz1OzLM22cgI2N1jJPpSOmA1nNY9sYRBknmiKUp4cUOC5O4MlEZys0pOxHbyGGcptP
	N9XlqDBuleDr+d1qpr0E=
X-Google-Smtp-Source: AGHT+IFfTMhkH5S73SuIsAAN/SpqZF0BEersYKQpUO6Bh5VPy9ZlLUmJ8OiCjyRdj7LYgE3+tceL0Q==
X-Received: by 2002:a05:6214:3016:b0:704:7b9a:8515 with SMTP id 6a1803df08f44-70ba7c71cd3mr21315166d6.38.1755266155517;
        Fri, 15 Aug 2025 06:55:55 -0700 (PDT)
Received: from localhost ([2a03:2880:20ff:9::])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-70ba902f827sm8123736d6.10.2025.08.15.06.55.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Aug 2025 06:55:54 -0700 (PDT)
From: Usama Arif <usamaarif642@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@redhat.com,
	linux-mm@kvack.org
Cc: linux-fsdevel@vger.kernel.org,
	corbet@lwn.net,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	hannes@cmpxchg.org,
	baohua@kernel.org,
	shakeel.butt@linux.dev,
	riel@surriel.com,
	ziy@nvidia.com,
	laoar.shao@gmail.com,
	dev.jain@arm.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	ryan.roberts@arm.com,
	vbabka@suse.cz,
	jannh@google.com,
	Arnd Bergmann <arnd@arndb.de>,
	sj@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	kernel-team@meta.com,
	Usama Arif <usamaarif642@gmail.com>
Subject: [PATCH v5 0/7] prctl: extend PR_SET_THP_DISABLE to only provide THPs when advised
Date: Fri, 15 Aug 2025 14:54:52 +0100
Message-ID: <20250815135549.130506-1-usamaarif642@gmail.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7F689120010
X-Rspam-User: 
X-Stat-Signature: i1fm5uapxj7tzcrfubznoi896ebpgkja
X-Rspamd-Server: rspam09
X-HE-Tag: 1755266156-333349
X-HE-Meta: U2FsdGVkX1+wpcapzYGzPFUh7RRjmMX6vOBy8HkOwRj/RgcdW38d2fi2sVGGPMTz0/DOfJiLk9KlGeDNKStQCyGJrdIHNNTIV6sqTE1OVWXs4Cg9gENkiIyrSSgRPQlgsnTYGYpHATzy5hXzHr1xOra1pTLq++ywO3vH0Jzv4t7uXmG0LbxUI+KOD+AWgOnH446lsw0eb5LwVv14hxlDMoUbTvb9PSLXEYhMoFDyM1w5JsiLmmdsUjfwpwmC/61Qa+1rkikqtcrmS+yHD6upssM3HxxpMBKs+6cNUimrEhLwiZYItJozc2Xl+47cKgyP1nmyKmlrgIE4SBtBlOZ1Z0Xe/H8GKuH6PZIIOw1NME0bjxSlK6TOr1TnMDmFT7uRx4Dg6qZy/0wLKhfzRNcbPqb15knbE7AFMmfFWV/5vRP1yGeIjPzgvc6sgOzccmyX+rWFWkZ4ryKDXEc/ltpsehKiDfhK43SgH/uZrhI3I7ZC6nqmiHAtTR8y4XexqbN622rrFjMZrv1eQ4tNYecL1ExCcbYKtUGhA3q3G78F7VUfT0Dj5ANca9I3TAohZDw//KWJci/1tLSuTDWIPmy7ZUuJ4xPPfTcyOYpKnhjHGorrKW8geG4tvYhET39NLWJrfZY0inmj58i8dXxofBpYtKS+GiEkZqtOWjsd9fLxnCa3aRkxSoV39NL8YTaao5sCds6Mu0SXb/AE6prrHabG2M/1PRw4IiTpX1WssLh7rlVk27Q3XY5iYvkkyQdhNlywEr38+DiC51z4TUqjzvuXdbjcHWRSuXYJVnnECcbGfWUW9cdVNrkdwOKy8nm9Qv2e0P3mnSYd/514rBQgvtdNbcEMM72VrtkyLWAoqtSiaBxOI1Ef/SK+5o9fM3HStSyyeMN9NmyTAh8NmDuWiSQlP/HZK2bLztzixiwMNJeIYES4jnWiJsPm8h4kKCR86WeCI+xjUXl7qQrWJBEzhw4
 yVIO3zvm
 ilGadChcGTHQ/YaJB4DS6awku+FzKRDfg/NWNxvyjfZPJ/AG0zB++pVpLOWA/ifHid+aX56W52V8Dgc3aAtqn2mQ7nCBwNvgrPDOtiSXRXBlSxlNfd75AaY1jgIfwbPNW1LK24DNiqqCmNTqUqSkuw8sMkNHD1S7zCQx9ChMI2Mt/3su6lgn+NdC7/XxM+YDJRB5+cK/LwSr6enoe72kk+uqmRerzhjKMSo0vyD2PLrl75zx1hA2q9Gq53UB7yjDdyqvnAoPW6VChpJ16kOs6PmahcWMLa7kpOVgjfP+ND/kX2DDErl8/aGJUDBm2Xk1X7D6sj38fGeeykZdKJGB3dlpeJzElzn1ozkxGehmZzfoUCYHOC5DgEIRMLI1DpWPf4C4MoynNBXiA1lJWX4nJOZsoZMcbvEt3Nzgv5tlJJTLL/jwnuWLY4kF/JIWJx0sgs6LjPMsUU2IXYjG+Yk+GnxApfDqPqCi/XXc3j4CX/stGhNge2Sil1VHbu6Kghi5+xfXn0YOWI30K9qyu5gKv4Sezc6mkEQUvehAGbCoCc1ymW9wbJuXex/44SQ7B/XfhTn9Hno/+w0F1OqMOub5TlHeznrvDP1n2L7jM
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This will allow individual processes to opt-out of THP = "always"
into THP = "madvise", without affecting other workloads on the system.
This has been extensively discussed on the mailing list and has been
summarized very well by David in the first patch which also includes
the links to alternatives, please refer to the first patch commit message
for the motivation for this series.

Patch 1 adds the PR_THP_DISABLE_EXCEPT_ADVISED flag to implement this, along
with the MMF changes.
Patch 2 is a cleanup patch for tva_flags that will allow the forced collapse
case to be transmitted to vma_thp_disabled (which is done in patch 3).
Patch 4 adds documentation for PR_SET_THP_DISABLE/PR_GET_THP_DISABLE.
Patches 6-7 implement the selftests for PR_SET_THP_DISABLE for completely
disabling THPs (old behaviour) and only enabling it at advise
(PR_THP_DISABLE_EXCEPT_ADVISED).

The patches are tested on top of 694c8e78f486b09137ee3efadae044d01aba971b
from mm-new.

v4 -> v5: https://lore.kernel.org/all/20250813135642.1986480-1-usamaarif642@gmail.com/
- small comment fix up in patch 4 (Zi Yan)
- Remove mention of VM_HUGEPAGE and other small fixes in transhuge.rst (Zi)
- add testcases for MADV_NOHUGEPAGE (Lorenzo)

v3 -> v4: https://lore.kernel.org/all/20250804154317.1648084-1-usamaarif642@gmail.com/
- rebase to latest mm-new (Aug 13), which includes the mm flag changes from Lonrenzo.
- remove mention of MM flags from admin doc in transhuge.rst and other other
  improvements to it (David and Lorenzo)
- extract size2ord into vm_util.h (David)
- check if the respective prctl can be set in the fixture setup instead of the fixture
  itself (David)

v2 -> v3: https://lore.kernel.org/all/20250731122825.2102184-1-usamaarif642@gmail.com/
- Fix sign off and added ack for patch 1 (Lorenzo and Zi Yan)
- Fix up commit message, comments and variable names in patch 2 and 3 (Lorenzo)
- Added documentation for PR_SET_THP_DISABLE/PR_GET_THP_DISABLE (Lorenzo)
- remove struct test_results and enum thp_policy for prctl tests (David)

v1 -> v2: https://lore.kernel.org/all/20250725162258.1043176-1-usamaarif642@gmail.com/
- Change thp_push_settings to thp_write_settings (David)
- Add tests for all the system policies for the prctl call (David)
- Small fixes and cleanups

David Hildenbrand (3):
  prctl: extend PR_SET_THP_DISABLE to optionally exclude VM_HUGEPAGE
  mm/huge_memory: convert "tva_flags" to "enum tva_type"
  mm/huge_memory: respect MADV_COLLAPSE with
    PR_THP_DISABLE_EXCEPT_ADVISED

Usama Arif (4):
  docs: transhuge: document process level THP controls
  selftest/mm: Extract sz2ord function into vm_util.h
  selftests: prctl: introduce tests for disabling THPs completely
  selftests: prctl: introduce tests for disabling THPs except for
    madvise

 Documentation/admin-guide/mm/transhuge.rst    |  36 +++
 Documentation/filesystems/proc.rst            |   5 +-
 fs/proc/array.c                               |   2 +-
 fs/proc/task_mmu.c                            |   4 +-
 include/linux/huge_mm.h                       |  60 ++--
 include/linux/mm_types.h                      |  14 +-
 include/uapi/linux/prctl.h                    |  10 +
 kernel/sys.c                                  |  59 +++-
 mm/huge_memory.c                              |  11 +-
 mm/khugepaged.c                               |  19 +-
 mm/memory.c                                   |  20 +-
 mm/shmem.c                                    |   2 +-
 tools/testing/selftests/mm/.gitignore         |   1 +
 tools/testing/selftests/mm/Makefile           |   1 +
 tools/testing/selftests/mm/cow.c              |  12 +-
 .../testing/selftests/mm/prctl_thp_disable.c  | 286 ++++++++++++++++++
 tools/testing/selftests/mm/thp_settings.c     |   9 +-
 tools/testing/selftests/mm/thp_settings.h     |   1 +
 tools/testing/selftests/mm/uffd-wp-mremap.c   |   9 +-
 tools/testing/selftests/mm/vm_util.h          |   5 +
 20 files changed, 480 insertions(+), 86 deletions(-)
 create mode 100644 tools/testing/selftests/mm/prctl_thp_disable.c

-- 
2.47.3


