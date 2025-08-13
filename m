Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42E05CA0EE0
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 13:57:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C00BA900087; Wed, 13 Aug 2025 09:57:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB0F8900044; Wed, 13 Aug 2025 09:57:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA05F900087; Wed, 13 Aug 2025 09:57:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 93ECF900044
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 09:57:30 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 505D51A0201
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 13:57:30 +0000 (UTC)
X-FDA: 83771886660.09.BAB8E2D
Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	by imf15.hostedemail.com (Postfix) with ESMTP id 9376CA000D
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 13:57:28 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=R4DH1lGS;
	spf=pass (imf15.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.219.48 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755093448;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=QzWUPox51DZi49hcWgUUk30VnYc4Bgc0iKM5O3Jcgw4=;
	b=e4sFLJBJnI4QCo3rbYKEyH9E8BJ4cOMOYVc1OWQap/Ia+HgdFDuIk0QnCM1uR3ozuzDA5Q
	g0iimeMntLJAq/P1g3LYSMIs4Lbaw9/XyN0mrUzzegPFl1BcbBTrqQMiKYBGnGzoRTc8Z1
	n9WYbUiu46150Oe46mJ4LZu3+6r/Vyg=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=R4DH1lGS;
	spf=pass (imf15.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.219.48 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755093448; a=rsa-sha256;
	cv=none;
	b=4oRkrpKTSxUl5Lhq3lkUacHGGJcLR6TrcpYXWCHZP9QgZTKC/CYbiWF+4tJR0+XiB1vPzF
	ziViB56RdoMTMzQ8c/bTKIO79VRYHIu+RoJJZ87pHkwNc+RQgNFupYyl5X4gGDfj6j3hlo
	vlCtURf5tFDq4VzIlIVFYt+hJzpa6kE=
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-70756dc2c00so84950496d6.1
        for <linux-mm@kvack.org>; Wed, 13 Aug 2025 06:57:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755093448; x=1755698248; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=QzWUPox51DZi49hcWgUUk30VnYc4Bgc0iKM5O3Jcgw4=;
        b=R4DH1lGS0yrAwcXqo9z4wsMgdeiCzIGqo5evS4KLGBYKz6s4/hSQMcMt34P6eDnEvl
         r9rNffKkpusVIjbYeMADl9UykPENktiS9I1ptfVsz5+Rfe02Yat3KqAUDRoAOEZ0m71P
         cGLyjeuFtKCL8KMRsgWrZKnFp2j7LlHXUobUqCOGTWXEI96WE3GVaR5i+x3o+1QFBJ/p
         x8hN1bWWw4thXhuLS13NOLgulovlfMc3cqnoNimmhGFE/Jymr3IudP7A4q3Ri7YydIId
         aT3ADqqBJoAdRWNqA2z4S4qAvMfFKlfMcjfTjNvjaTAQX+eh11FFF9vunJw95dxBRM9S
         w0kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755093448; x=1755698248;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QzWUPox51DZi49hcWgUUk30VnYc4Bgc0iKM5O3Jcgw4=;
        b=oLikBM7EpZk5Zaq/UMkcg60KmlqmPdfOrApmat9thi0p/jPlM2t12NBHHbOwzTG2Zt
         7W/+yXrtFzFKcNYxpOgMhtroFhGJqHeN3BuxLKcatpanuUUZBLslMNHJDTmaDSwNdR3m
         esZKAN+v5ZpI/kumy9nYB/AeXBJV4BTLRGUYXoZDLSeNTzuieaRenTI+b9JCUw6Dr3V9
         p6SsRWoZNsSrZFrPfoi7fJ0AwlVsZ1w5nWanivSLBxIiZ/m4Nc/LaU+mnMXAUY/2AbD3
         u+wEyJZO5Gku5yV2E/Kic0mSkNtG6qhuw0YmTAFFpm7kJfNuw4pN7iJtbBoscXkI/lqG
         PNfQ==
X-Forwarded-Encrypted: i=1; AJvYcCX4Di6+fKEjCZZ9XcLYdoFQBHMy+a89spgahnj1aXSfT583YEIRMaaEfCnU/IR6pQtnyoI0W34vgA==@kvack.org
X-Gm-Message-State: AOJu0Yx6X4dbDrpouZsX4uc4Bqm0TA1aULVcslztUb4+HntyaswEtOLN
	2ohq7QkQBWN6VTqMVLoH9pxD02ZG8e96ebWgpc9UBJ3zqFgi9EHKFRTb
X-Gm-Gg: ASbGncspeOj/zOfNN5LB20ndq32dKK9+ltVAhnCQ/7X0YPwDut38PvM1BiWldq7Ocoy
	TF4Hw2Y0gzyG8fgkmGFJs0FvwH2DYl4c/pVXDQ/JWNDRnaR/+bOIu3vesMlcwG/hmSfag8rSNZR
	OpdrnT6deBwUddk09L2Qm+jzUnxCuFss0mEIekqqlH4pzomvHY0ML89Pl3BQWHAQGaEdEPaf5st
	p0NO8tkzT84qvP7VRf/UveaZKSX0E4hp4U5vubvUZQaMUx0TbAvBw0zjP13puxgA2Wgl3D29c9x
	CLru1yYQ1XTarqBpjtQh/8El1Lva1hmQTXrfxoMO9/inLR5kGiq/0ZwazNhe8jb7Lt9GTlI0hl9
	RzV7KuoQGvanR9DD1vLTk
X-Google-Smtp-Source: AGHT+IHMpLHS102o5V9MYRk9uIP4OvbzgHHel8QxmDYGPR2Zk/mAM8p6YLuZt9c630uTVwr2P7e9Ag==
X-Received: by 2002:a05:6214:20c3:b0:707:5df5:c719 with SMTP id 6a1803df08f44-709e8815919mr41371566d6.17.1755093447561;
        Wed, 13 Aug 2025 06:57:27 -0700 (PDT)
Received: from localhost ([2a03:2880:20ff:70::])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-7077ce44849sm195552726d6.84.2025.08.13.06.57.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Aug 2025 06:57:27 -0700 (PDT)
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
Subject: [PATCH v4 0/7] prctl: extend PR_SET_THP_DISABLE to only provide THPs when advised
Date: Wed, 13 Aug 2025 14:55:35 +0100
Message-ID: <20250813135642.1986480-1-usamaarif642@gmail.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 9376CA000D
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: b4uzihr8ze5f15a5no3ht7aagwnac5hp
X-HE-Tag: 1755093448-553020
X-HE-Meta: U2FsdGVkX1/TqKE4evt+28HPujhb4ak2N/0KKdLBfG0QsqJcXA1VcbYxEhy+6RgN3AHqfxPLiMVau+yeOMRsCHhV3xEt2Fw7hg42LQ5Q7hi9CBk6RNGqMb478ZEEqXEBJgD1R4uTUrfD3YtxtAq4HP72cHKgLG2GCGKQRJ4DXVW8gpKxFtGGRL+whbh7LcTsXwzx0jA9ASjLs6PNBNbdRoCzLUn+JvSmUTQSxAUmKXGuYzP/ERZy9ziCG1INekFfQA0C1ikPs4L24V572DFBfKTxvxQ+DqsKZbp0qGCSS3fNZiO2zqRu5dThFGGPJrnmBWQ1CmgSnWGFMkj8pRTzGUNeFalZEo2im5Ud3TdCrgp4u5r6uyMwjTuiTyzN1tQkNPfXdBlYbVYftRF608uyquA2B9tf0wwE9MEg/MGJqPxpK21Y6FjpAD4t5n7OQ8v976hch91xQZiVCa58PssuED29eBw4bTFqnmF9tbMtpwIvfa+nztgPlz6pPkoTaePaHkYwUVPfIH5600QUHXJ4rAwDM+z64vtKVoKnnkzAVvCDdTwY+ehtRi53tHmgO5lJ8+0UQTYTREq57rRTOsTDlHla3Bhc/xiqrzNlYcwJ8Mqh5tt1/Pxkv0oFbu5hf77c2AL20EfxtY30M/2Ih7Yq7YM1DrBt2c6PYoKBffOnCpO7D8WQjc+fBbLZH7LLFzGVALAA5lc0tcU7zlXn0QTEcdGOK/0DBWFc9xGq248H+19M0ixIqpbbhgsLHBUO2JCWSu1cxoNIiLJS00UQE+KaZGAdzqaWQuB/4qO2S/lQ96dHxwIou93Y55UR16Obm6mKBvfep7+xRZaWqXB9djzt1NT6sMf4btd/vm5bOdX7yAubBr6b2E5I2ZTlqtW9RpDWUriWy1XLsqkxSBBUvjWoiU67rxSHmBYq1dm9Etmo/Z792pyvSYu8Z3XQFnQIxq3WE1hJg0aTw57eYs66Fdd
 2DtKpW/4
 0KvzKBW/IEFtPswuZIm7lkDb1w8di9ismHgAcoXp7Ng03msCpTURGQ58FPxxhtEK+UelUTo9mc4OnFgjw4TjcIWG88Vlt/VphITrWpcweHFF0WFvdxyEPhT+2CyS69jbwsKbyAWzuHKvuIZk4vYWhA0cVuUf9HrLUpntpw0egCoa4l7unv5dlzCOYq0V51T2BqAJz493+JQOXnyCbUdyPkHETR8NsHgy9Nf4D2YjjrUMv0UC84YTfh4b6uDhdicn4e1JZnsVZf/LGIyB0v93opV66fU32pMMuTFGNkJW9I0HOgPHVbDXRkeENuvRXsXVXXW+x57e8CwsWQvH/Cn9MHegAU9IHu2l9PLJNr7Ka7VrnMTRILwkK0MbdTsveaKz9r3cb4GZXoqiwMPpR2Lj5jlMMOhUtRwEx7THmASf414v4uPVjB8VpJOCsZH613ei+spoFTMpZqHMUjtlvPzulfMpq2U6YRAKElvyznEDr0W2/yhlWy/E/kwCP6O+DbrFZnw/UIkLL5lfWNUnt0HCYiMmnf7CaOtut3nnOQITLjtYIga7oJ5YQ8WCcYjiRd/yq5OGjOGhbs8UStZ9Z2W+CrdkXwdU9bB0B2S4E
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

 Documentation/admin-guide/mm/transhuge.rst    |  37 +++
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
 .../testing/selftests/mm/prctl_thp_disable.c  | 275 ++++++++++++++++++
 tools/testing/selftests/mm/thp_settings.c     |   9 +-
 tools/testing/selftests/mm/thp_settings.h     |   1 +
 tools/testing/selftests/mm/uffd-wp-mremap.c   |   9 +-
 tools/testing/selftests/mm/vm_util.h          |   5 +
 20 files changed, 470 insertions(+), 86 deletions(-)
 create mode 100644 tools/testing/selftests/mm/prctl_thp_disable.c

-- 
2.47.3


