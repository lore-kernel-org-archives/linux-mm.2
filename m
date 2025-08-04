Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 099F8C87FCB
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 15:43:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A19D06B00B4; Mon,  4 Aug 2025 11:43:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F15D6B00B5; Mon,  4 Aug 2025 11:43:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E01A6B00B7; Mon,  4 Aug 2025 11:43:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7DDBD6B00B4
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 11:43:39 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 39E95B6380
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 15:43:39 +0000 (UTC)
X-FDA: 83739494958.12.8E61C96
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	by imf08.hostedemail.com (Postfix) with ESMTP id 74CBE160002
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 15:43:37 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mmHQA1Qf;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754322217; a=rsa-sha256;
	cv=none;
	b=dM1lxRiNOUX6RNHCUKIPCRWotCU4K1Qwfrt9kftkxbDxpu+59NpOikgCReaegM9RGDcg58
	LJowx9vLsHwoN8MEuHKcgXTscuYoz6yeLE+HhGRP99CIK6aSVyEIhdTa6VYfpkpc+x7TFr
	L6vsHb+jJSjFlN/522FOwlyCKyqRSUI=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mmHQA1Qf;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754322217;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=5e6drRtevaO71NOW/enzFLn3Cq6X1p0jSQ7t0k1aGj4=;
	b=G2A8Rw2iWKLCZX5IrRlaMj6ex7IOlGQ167sMYv+ViD2jqA0y5nkGYMb06GGTMJQek2lhWV
	E+el/m+v7vjLJvSBawwtfwpsUg/wKHiVMnXv/2wygrSmuRSA6rorWTNJHOSkNoNLdkOlw6
	6svp6ENhuda1g+yO4keHeLEmSDT0Ucs=
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-4b07d779287so2274741cf.2
        for <linux-mm@kvack.org>; Mon, 04 Aug 2025 08:43:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754322216; x=1754927016; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=5e6drRtevaO71NOW/enzFLn3Cq6X1p0jSQ7t0k1aGj4=;
        b=mmHQA1Qf94o1nFeqXFag95CwxeduARTWbVwhAuRXBjS7EvSksd2f9Rp9mR14kCVUUE
         fWX29UDANB9dojh74RQCF8cfsrOTJCvElUvlDxqkp5r+PJbDKWZURr6CqaEYgYxN55w/
         0Xuv53A+4OaQkjCQTy0r+GHqtE2JMuSvekOnPsq9+SkW1UUqyU7woyBICc15L4Y4hYfs
         uJWKG8NRWiFXK4DhjqKZ5JSp19y3qp51PzCgX4XuFwHT98ZfIUhhqycr+SJuVroz09nl
         lS6KI46Nnjz1tnsWR/KNxImCAlPNZT++AR3hFDpQffPsJxmrw4AE5zBLCthLLjuHPBpo
         2BRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754322216; x=1754927016;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5e6drRtevaO71NOW/enzFLn3Cq6X1p0jSQ7t0k1aGj4=;
        b=oqQzhqke/UIUtaILHjzePVaYwdX6FvN0fmIFfCEI+0u3b9/io3Is8u8H+ZzLpGUcZW
         rxzu7JSoZouZOna7j1U/ziu/CPzehwW4opubtjRepZjk7BDmXHviCjQfuSsNhiD9bSK4
         MVQ+l524QsBnCoqml1LRo6FPpDDwYbcVn1x3ifsoGGAcY0F/VByeIzZ4mNYudjrZS7b7
         7wkC3wfjJihtc/gpAe5wB6PCEin3PERgIEHBKX+OwQ4gZ7MwEEUC+fwjoV6jwnOzcWkI
         kckto4pkXTQjl+Mm4duhCb8DH+3mCGL63MaumMtxPxAuy04G7NCea9Ud4UQ0T5chyupg
         gHlw==
X-Forwarded-Encrypted: i=1; AJvYcCVPuxMy8Y3bNfe1MvYh/i7D/cBEYOfuupXR5uVBe1fKIjBTtVPkthvV3ThiywuT2CzAnG6e/QiAAA==@kvack.org
X-Gm-Message-State: AOJu0Yz4UglV/zCvNzr3RJ6YFH/uS9JAF4aDIF9RUkfglKwlLDzZpBwp
	6tfDvNsXboLjgWJV8DOwK0wZjRWoE/VB+6RqwVP2p7PJaGkujUhMoDIO
X-Gm-Gg: ASbGncuTFopYrWwNGUMMjPNmWDYDrmghv5ciTwD5vxhkpQyyccSvCH71Si7/x6IAmNm
	STKMFGZ5jcvFYquVm7N9VHLWO02kQqH3o34kNVSYJHhcCgBY42KA3QekxWdoxVsSe4bgdCqDxmQ
	POCv1gDj9hU/7y/pdwSkMhIOTrD6CtiOoxVxx7dJxdWhlLhK1H7X78Hn0ZtQaQhMrkeluiHzgNn
	7ItOf2N2zBifqC3YJ0fuBQGpZW4wqqSSQ3wHyjIsHCavvn0PMoITE4+zY1k3BGGbQ28B3jVqAIk
	04DrPntGTDvpvTzKmgADwiZ9iREtu/f+TwkzcWzL8PQdnd2ZHtwXJ/XTLAUbpGh6OYTCmmpkAcr
	Lzw4ZawInX0khbEXBpew=
X-Google-Smtp-Source: AGHT+IG9tVEEClUy7ZbvuxCABzGUJjw0iQygmGFI7l1dILdAP6o6amKv30ChQba0LsLIZgBekdXdpQ==
X-Received: by 2002:a0c:f092:0:10b0:709:5f31:2fa1 with SMTP id 6a1803df08f44-7095f3130f5mr26993256d6.2.1754322216233;
        Mon, 04 Aug 2025 08:43:36 -0700 (PDT)
Received: from localhost ([2a03:2880:20ff:9::])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-7077c716effsm59372746d6.0.2025.08.04.08.43.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Aug 2025 08:43:35 -0700 (PDT)
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
Subject: [PATCH v3 0/6] prctl: extend PR_SET_THP_DISABLE to only provide THPs when advised
Date: Mon,  4 Aug 2025 16:40:43 +0100
Message-ID: <20250804154317.1648084-1-usamaarif642@gmail.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 74CBE160002
X-Stat-Signature: 3mzyo4mtioqcp5eskqmdiq33orfigfny
X-Rspam-User: 
X-HE-Tag: 1754322217-234814
X-HE-Meta: U2FsdGVkX194qHTLUKzrz06LJEKE01Mlz1D+XZcjRdxIxVqi9p4qwToi6bG08y1XZilN4jMs47dGi8dV2QFGK1CbVLRPN0/C1Sw3mkmjmZYoasQCUPKbFJxOgVrITZat4jxfwetlZWWfcipbKzItqytLTQ4RGhKRNNudVVKEJELvMiXDJMiN1vTlAlkb8HPPfCCtmOiT/9vmb5m0GWSf8iCYqQGDuoihvQwKu0TGcvBJ+8PB68/f5asPDooiSwVo93/Xg6lsLfosUIyWIEOMLR/2w0EiBKTLxQ1OzvemvPaRNvBEIUe2G+tu62eeOiVytxJVP14r7yQ+vKNqq8uorQdoeQ4g5A+HCIwO+BfsYkdSaP31sg5EGXof3W93UyhEq1CVDHHKHPROAXGCN030D9+Okdqod+o4sjzB1btpknAo9/MPm8lhXZf1KdAiBKr4u/Kl5Af3wHSX3a/KPmGwJ206QG8j8SFWWrDrRuTiQmBOqA4Y/oWP+lSATnXEEh6BnvECzqEMght7qqAVWJKjb+c3HbYtYi2utKlhXiFwAqKMTWpGnpHCkxSXCUmYLHxAf0JzQcMs/YoNh+Lsv0aGqa5UT/4s9LTB7eEhQAL6tahaTh+g/DX3dj1foCbLVe33jrnG5IN93h0sw0miknx5NYSpb1tOYzRLhwcgx9e8VphA02z05qVAlwnDTM8upFCsC57b23QPZz3LfcbolWUnDe7YO722zQrLeskk+YJws7j+J41viknGePMQ++WWWkxeposx3nsBkKe+fT5Q9r6acyxcpwD+N4z7DGiVT7tS/5WSYwBsdwqMOKKc2zXWhmezF1b1mQLRa+mIJmKls9kg9nE+zDFnlG9vtiKXIclvbVI1yEFRR7L8E9EHPjC8Mclr9dxEt2p//A29u8KWgymOUgTSY6q6dwh6PLeW7FYAfYXScwiRo3Z7Ul7PlKvnKyfpbHIVUeQxBHnGeEZzNvN
 VrsXcMlX
 KtOuMyGi0KbSdNSZl9e75Ce6a5410Pi4wjTaIAvaUacqYduSfsVz3Rwxg21AcseW/llrA6VoBNeUk+SHl2aLWFY1q7loZW4h2T8zn7oUvXlGV5KohakA4DskM69jEmCNAKfgCguuMi/uw7aV8gaqGksfI4w6rBcWkPaZGWNSQMdpxrjWDIXvJyCWp5QIWK0YYsRdqifOzClRAApqzEHVJsQWS1lvY8rTQ4PB5c3qVsYKJLUmsY3UyBbghGUbUFakAtm+zULYMJZ4BGobhb7snmzzr8Iq39xJGC4pTPLcrjFX9G7VSdXoajELBa7qZ0ZO6NUkhl2fuYrvg1fo4Bk1r2cpHFs5c2UXOGD8adAftHq5so/ccGoi4Kt0HuEX1c5RiCee7NlOZkSvsR1wqqOL20c/Y/f/uea3NgGwdt2+ajO/ZkAqwZoIPL79dGYqJjfSabWeyv6JTmX5yr06Hof+2z2Zm2oqKhdjw/sCDs71vfFMgaskltxD+8ZuKNvaVFrzbWV61uvLchr+lgxBlT6LMvBMIGKS5Ejm9B18hZ7KgLsPZ8EXmhMwcEsu4VAAjkLw0ZaBKPQ7wdFSPdQo3OZI8FbIcNsuab+KMKbXH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

(Resending this as forgot to include PATCH v2 in subject prefix)

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
Patches 5-6 implement the selftests for PR_SET_THP_DISABLE for completely
disabling THPs (old behaviour) and only enabling it at advise
(PR_THP_DISABLE_EXCEPT_ADVISED).

The patches are tested on top of 4ad831303eca6ae518c3b3d86838a2a04b90ec41
from mm-new.

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

Usama Arif (3):
  docs: transhuge: document process level THP controls
  selftests: prctl: introduce tests for disabling THPs completely
  selftests: prctl: introduce tests for disabling THPs except for
    madvise

 Documentation/admin-guide/mm/transhuge.rst    |  38 +++
 Documentation/filesystems/proc.rst            |   5 +-
 fs/proc/array.c                               |   2 +-
 fs/proc/task_mmu.c                            |   4 +-
 include/linux/huge_mm.h                       |  60 ++--
 include/linux/mm_types.h                      |  13 +-
 include/uapi/linux/prctl.h                    |  10 +
 kernel/sys.c                                  |  59 +++-
 mm/huge_memory.c                              |  11 +-
 mm/khugepaged.c                               |  19 +-
 mm/memory.c                                   |  20 +-
 mm/shmem.c                                    |   2 +-
 tools/testing/selftests/mm/.gitignore         |   1 +
 tools/testing/selftests/mm/Makefile           |   1 +
 .../testing/selftests/mm/prctl_thp_disable.c  | 280 ++++++++++++++++++
 tools/testing/selftests/mm/thp_settings.c     |   9 +-
 tools/testing/selftests/mm/thp_settings.h     |   1 +
 17 files changed, 464 insertions(+), 71 deletions(-)
 create mode 100644 tools/testing/selftests/mm/prctl_thp_disable.c

-- 
2.47.3


