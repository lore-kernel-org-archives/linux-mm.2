Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59D7AC83F17
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 12:21:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB37D6B008A; Thu, 31 Jul 2025 08:21:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E8B436B008C; Thu, 31 Jul 2025 08:21:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC8B16B0092; Thu, 31 Jul 2025 08:21:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D07666B008A
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 08:21:56 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5BFD614070D
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 12:21:56 +0000 (UTC)
X-FDA: 83724471432.15.FD21CDC
Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	by imf04.hostedemail.com (Postfix) with ESMTP id 8D20C40013
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 12:21:54 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=J9myzqUI;
	spf=pass (imf04.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.222.171 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753964514;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=WyB2bd0Y5ziwt0wpZ4L6oPfSKZCsBSGJvL4ApO6LdH0=;
	b=xyF4Xy0E9Kf7XJleWTLVmRb6WPQIsFhTyxkn09wgyz7Qw4woNn6ypd68WwNOFziFffJs0x
	ZdDtgF906a6ViBNmpHtYy7zkkr8pRZhbWxmdwA6Mr1mhKWWWweV/AZXLKbWKmVC3BVC+0J
	nrlwGrDL76LCLz+GGvZBbfsBRkTbF6Y=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753964514; a=rsa-sha256;
	cv=none;
	b=cougLCpmKZjVrJcByZzXTts5WvMQBd4aSYbPTxLWivvH1MJ235mPVfBqCi7WX8GRl4WPe3
	TQ3wBs1IMcVmuXuMsHM0xDobSS/YjHEtUr60vx9K1nL/qBybHGwVJZnr9mDu/tm3N0e16x
	wIYVqUX1RRnl1msKjNkmtciNBoMtogI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=J9myzqUI;
	spf=pass (imf04.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.222.171 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-7e623a12701so29045485a.2
        for <linux-mm@kvack.org>; Thu, 31 Jul 2025 05:21:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753964513; x=1754569313; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=WyB2bd0Y5ziwt0wpZ4L6oPfSKZCsBSGJvL4ApO6LdH0=;
        b=J9myzqUIVL2RIcWPROyrtx/qway0gwPzisDwodh1nSRyO/cinQYODOl96cDs006/r5
         M0px+LCkgaYqZj1bcoUGlbJuA/7V/S2M4PRlX4PC6ZrwZBeLRZBrgCIuVlKMuuLOJevz
         luVQvPJ2f5IZXI1wGPA0aiQveUftBIyPRg4fPpOaToycyyHRHu42o4N21t9kv2oOKPXE
         xlKrnnniSAJfOLUgmJdEuZw4fSXHC6An8daS2IymXxn6Q9aDkTeQL08gQEpgt8I86MrI
         naOosp/qLXZmgfSsjY5g6ChH/zJU3tKjBJX45fSeSc4ZwFpb8YogBKaxDHl5vDjmd3jC
         hRmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753964513; x=1754569313;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WyB2bd0Y5ziwt0wpZ4L6oPfSKZCsBSGJvL4ApO6LdH0=;
        b=povUCActVoeZKdu7/Kcf1RUuuy56VhT7shPQ/2yL026e+wKLFyeK3ZmAg0WczByFp0
         HRuLHnbgr5EmdT7inwe2hP70/Eec2r2wK3/52taKfJr50WBM8WNXZY6v/yvKx/nRFsKb
         dVlUlzUirHc/QFFMlDzh4Yvq40wGig4udsAtAk8GFtYl54X8MhN7BkXFj3i9nt6qCgQo
         ZHqXA8mHZpCzsXYD4QLUJ7u8uP5yg+minGndMpFd18NWwd133NvYOUfHjoaF+amzOZs8
         jo+hZbLyx8i1BQdOtuey0E4I4e/rqLy5kjDgjRvpL5rIUII144naBrsZ+NFFhbr+eTjM
         brlw==
X-Forwarded-Encrypted: i=1; AJvYcCXuYL9iQ93SZIPujtd89weLNzKcH3TNODTSFyWFNH85bOo48ptZgU82Wcljal44DLrD4Q8uMT4XNg==@kvack.org
X-Gm-Message-State: AOJu0YyzPjztj/6aeHk6Qw3O6QoNhJgCYbScpFceWgecbI2iDG/kRo/C
	lSbQrhUiSpwsD9ua5OB/2zYC4rp7tlgNETLKkFd8w1CYg3CWYXqS4LYr
X-Gm-Gg: ASbGncvLM0iCC1Q183JVHDf0YS+QJePxFeSHDdiR87FXJZ60O1sgWDXa38Keqj1PZZE
	sNyFSAM/LRMHQtTg3+946G5wGpJWLMduSCyUe4Piahd+dcU9jq1JvWirksn2YOHo2EUJmDY9JZ9
	9XHn80VC1/4aRPBC8a/Huo2zXY1vVh4nGIj7yDPNmKF+BppnL1npt583hTB/p4a235HwITAT88U
	9Hykd/QDQ68TcgkyB9imDVEGkgPxywmiG0T+V6xj6qOc5VNYWsYgNYnL+2gCahpk6rfjC6lNumI
	5I8yj0ALQt7DGnKKf22BHbs8e+LlCsHVcx4ykZ8AvTyG0HBn7i8cXwoe2jqIcwX7Myy7aYcegyx
	Aflo5l5So+rrvT7U1
X-Google-Smtp-Source: AGHT+IFaNwzD9Uxs/RKFYt5m6qnDGOphlQ2Tpe9T1NHIPTPwwihehfIu5ETWtSsTwS33LypgOJOgGQ==
X-Received: by 2002:a05:620a:d87:b0:7e6:6d78:979 with SMTP id af79cd13be357-7e66ef8a93emr982153985a.15.1753964513428;
        Thu, 31 Jul 2025 05:21:53 -0700 (PDT)
Received: from localhost ([2a03:2880:20ff::])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7e67f5947e9sm78587585a.1.2025.07.31.05.21.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Jul 2025 05:21:52 -0700 (PDT)
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
Subject: [PATCH 0/5] prctl: extend PR_SET_THP_DISABLE to only provide THPs when advised
Date: Thu, 31 Jul 2025 13:18:11 +0100
Message-ID: <20250731122150.2039342-1-usamaarif642@gmail.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 8D20C40013
X-Stat-Signature: 165ikm188wzgqiywgm4xqxwh9mmpbj3z
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1753964514-371730
X-HE-Meta: U2FsdGVkX1+GYSUsj9IO/pjQ/K9s0kfkQjfV2iF4R7/6fbU/tE722ariQI+yKwNdvG9gfzoilBga8q2j49s78J7YR4GtjcmRLVvVzheJi3uFZNWuu+B7vNxIbLh81IcdRhAe4eisaYlcBiO5gHPnoXlNNRZ6uDH3PRDEXBRtKO4Rw8DEj6jZB0mv4ZOi5w1b+ELMv35W93jCj10hQH9NrK6XEFQv7spRvW9DPxXZ4rCrwvX+wvsLyDC5nBzvs0GutJAEQgcrbTAGAvZxk08yXKHTi5j+2GR3KQyXmIgHkTKk74WMDfBGZ+bUoNE3FFKU4KcDC8xKH9kekkepcZVd1rnEkTBmS4H+Fja7OwUbkiHPiGyuOKiTNS7lPbdj3mlbl4R8K2P2F425Qr4RODJeo+sbrZgL2abQSDdUnkFyOyarGWnnpHE0aPLwhyaZsvhMuSR4hBudEPGWm0LquoKMfeV7IICVYRx0GWIu6/a5xBqyFP0QTDlP5L+dUPlP44izBxu5J6FEZzNxumQwOMAxST/3VsXT2ZGdDg4pAJZ/V/nvc24i2ULVYRLq0z9ZNlWME6JdQN8crKuk61PhQ/Q3RT0zU90e7FI+yZnb1o5uBZiJi3bITwOAjHE+8SJAthqu6LBYVyOvnfS6sIiy0WLj93LGtmoI8Au9gNt2DMFU6sDOdrKDHJFt8TJr2hFxWXFNlBm4Y7H1lnKZ00xssiF7xlLtsYjYlX2eF7j/YGH78nmgH0PEEe24Ht7aV8GwOlDusaSeukKZaEeoKUBdwAZg3bXZbBHQygt1VA0eMlIGIdAxZvo1HmHdLthXGINanE09P4K+CtYDO3C81oOgpt/HpcfVGtbDC/TBTRdcX2ebUkOHgn4x8jStpolk5kMyZuieERBbYaVjaIoFE2Svg9ks3Z+LKgUn7rnkDhWfblDHmlGFFbxyIHucdjlaUCyPYIz7zj04ZGwVgn2aqCEVtq2
 TUdC++2N
 UaAGSEzhFXpIxpWMSUKwLL9MS0lMhXZUt2cSFkrq8ERQm9x6EOQphO/5DhL1VIuEDV8ZWxvMCFTg2B+pMCHiBAZpy6MG5+03F2dLx5NymkikkccBhi4rb7ZNfI5ltX4TclkoAP/I+UtFF18iIfdKGTaDuOTOfv8wXSsffuhD2y15+3mY+SfIasyTMH2XQVUeyzEGs/ZD7rP+x7y9VKvP5iB7UE7JPe3VIZOf9rK9sggRNZxvcyPWCf+XOWJ8FuJyy4Ukuo4kp+L4whQcVESu/THkEZ9WXdoVUTmIQ2NMYHuZSbR4gGVJyJE4ck8tuFRscsSUUxR4+zebtDE/FeGQdbn9fdEgSJq6YwNmjtljAGMF/aPFHgkr8fVeGtOa3f78cXyT60HOmIsC8jE8v1DNeb5zB+BoaO5GmWrkre/hQXufga+jpUkhmpyxX6ZWU4/lgYBgb5GNfoIXjy1aKabHhEAFo2G35vGPMG3F4yMU/QL+P9c9RPKgRpcbn45l9U6Zci1kWlZhIuKZSHx94cWNDcaX2is50QnKNjqLd7dy0LGZmIZcUnI1+gy9HOg/umM24Eje4aiTg8uC/8UWBXUTEhO7hBArXy4Yu4mehrs8Jx5RqSYzTSTjXCHuDBIrRBZN/Le94
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
Patches 4-5 implement the selftests for PR_SET_THP_DISABLE for completely
disabling THPs (old behaviour) and only enabling it at advise
(PR_THP_DISABLE_EXCEPT_ADVISED).

The patches are tested on top of 4ad831303eca6ae518c3b3d86838a2a04b90ec41
from mm-new.

v1 -> v2: https://lore.kernel.org/all/20250725162258.1043176-1-usamaarif642@gmail.com/
- Change thp_push_settings to thp_write_settings (David)
- Add tests for all the system policies for the prctl call (David)
- Small fixes and cleanups
 
David Hildenbrand (3):
  prctl: extend PR_SET_THP_DISABLE to optionally exclude VM_HUGEPAGE
  mm/huge_memory: convert "tva_flags" to "enum tva_type" for
    thp_vma_allowable_order*()
  mm/huge_memory: treat MADV_COLLAPSE as an advise with
    PR_THP_DISABLE_EXCEPT_ADVISED

Usama Arif (2):
  selftests: prctl: introduce tests for disabling THPs completely
  selftests: prctl: introduce tests for disabling THPs except for
    madvise

 Documentation/filesystems/proc.rst            |   5 +-
 fs/proc/array.c                               |   2 +-
 fs/proc/task_mmu.c                            |   4 +-
 include/linux/huge_mm.h                       |  60 ++-
 include/linux/mm_types.h                      |  13 +-
 include/uapi/linux/prctl.h                    |  10 +
 kernel/sys.c                                  |  59 ++-
 mm/huge_memory.c                              |  11 +-
 mm/khugepaged.c                               |  20 +-
 mm/memory.c                                   |  20 +-
 mm/shmem.c                                    |   2 +-
 tools/testing/selftests/mm/.gitignore         |   1 +
 tools/testing/selftests/mm/Makefile           |   1 +
 .../testing/selftests/mm/prctl_thp_disable.c  | 358 ++++++++++++++++++
 tools/testing/selftests/mm/thp_settings.c     |   9 +-
 tools/testing/selftests/mm/thp_settings.h     |   1 +
 16 files changed, 505 insertions(+), 71 deletions(-)
 create mode 100644 tools/testing/selftests/mm/prctl_thp_disable.c

-- 
2.47.3


