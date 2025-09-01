Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F000CA0FF0
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 20:50:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E5E708E0007; Mon,  1 Sep 2025 16:50:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E361F8E0006; Mon,  1 Sep 2025 16:50:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4BFF8E0007; Mon,  1 Sep 2025 16:50:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C72ED8E0006
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 16:50:31 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 683641DF1D0
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 20:50:31 +0000 (UTC)
X-FDA: 83841874662.21.AB925DD
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	by imf13.hostedemail.com (Postfix) with ESMTP id 3F79A20006
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 20:50:29 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=Phr91gEr;
	spf=pass (imf13.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756759829;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=h+HtzMm8aCoEYebuXFm6wKGd65XfE1qqAFatqE2tqt0=;
	b=ChamJOPZ2HwN7AwvFMpE9v2YHu73M3r5iksiACuFS/pSZ/DU4LdY8vLRl3yHaZ/PJlggxe
	3DzRbi4EaCjOXVPS/hnSKyP5HM2N0/oZY+MT9Wx/sKIH9b2eyv16QSoog79x8Qs3923Rcr
	9NW8N2eXoDHzeH63bANRSCYLoUKAL/o=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=Phr91gEr;
	spf=pass (imf13.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756759829; a=rsa-sha256;
	cv=none;
	b=Vpfd+avFyRQgt1sMvX2q9WHejbCmhWiai6AL/+VXr1rQrLabesltit0thaR+WY4igfri36
	FYqMYD3bbah2gXpwvlkqOrJKvKQkK4vdUZJeDrNV1XICXK/bGxNelnMoXMWCOu3Lc5Sfil
	F7uof1OngaI3wIL9VPwAPUEoFvueZTk=
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-affc2eb83c5so413209066b.2
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 13:50:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1756759827; x=1757364627; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=h+HtzMm8aCoEYebuXFm6wKGd65XfE1qqAFatqE2tqt0=;
        b=Phr91gErItOkJ7qKoO+5R3UejcPzMSRMDvi+SvF75PF1qjOy6s5JVUfNktwHex5yYk
         kDxwf4EY9mPGUNhTHB3M1FI1PY9R5ZDjh0ObsUeXJpyAqMoBvwVj1YLyTpmtJ/2Wr9XC
         vuQNB6w7+loHoK2ccBa423x2FCyyy1EUJu4J+OFDbjiMLiF8ExGKghYQ5BkmBxj+9jYK
         eYYSHsfkHs9ZSGxu/31FfukPhC0F5ldnn6/EqrqgrrHaAwGkxbMdLnc3dY0Nu8ru/jWk
         7Vod3eSGS4Btn4pk9gtfFWaCJhMmeY2zz9OTEOCU+OqQA8GZWLDRlekvkQU/AfH0mk3g
         wpPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756759827; x=1757364627;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=h+HtzMm8aCoEYebuXFm6wKGd65XfE1qqAFatqE2tqt0=;
        b=qvA86tVKcbziksY77xCde6YfPRlZ+g4x4J1pG4vE60LX5XlIgH1Ye/qRnGD62T7bje
         Oq72hycVdwkcl9nO3cjCSCvfsfNU9OFNidCep26l4ScCgETo/cBGQRFnwo+gdgH58RsG
         v3ubXn3J8vwJ5IfuEt4lxbpCXpZr1wsrDEtYzWyqIq78Up7eFGCwRCKkeHZK69hfKT8+
         ouN9oEY0tOTnZrhQ+6MxotPEtQcqZfpIyinVqQBHNdgELpforHGX0nFAZPFfZhgCxmnW
         fFvvJ0v9z7oZ1Iiu8XqGpIMswamH95qftmA68WIPJVj95zs5jBqZ/AblTaYPjYpzVO8Z
         cNRQ==
X-Forwarded-Encrypted: i=1; AJvYcCW9DgluQKShg/FNfyFEUkNM3uXuMQmfPZZf+fkGXYn1AaXWAIXZaakHHNRE/3wuAKYMhfKt01AGLw==@kvack.org
X-Gm-Message-State: AOJu0YwVaIdyKYoGQPY85N/sxtCuUJLv4VZvE8vJn7MWp/MYrRxzkF3w
	HRNqZr24NCrGDUlnhpLVJjxat+rBirYxjx4uYDJbtt0ksHfPqSHuvdqM54d2l4Xy894=
X-Gm-Gg: ASbGncu7MPXpih9l1xxeXv2zr4HrBWwOe+i3AbMTldkWSU7bpEjCJa0IR+5A6RHqhcN
	FBmYoOoziKEz+UE7GRa9VIY+1sl65OGtMfZWsUVfmCOxwGKcpOUlWYoL+tBudIXYaZKijjWf6pq
	+oYNqKGh/b06ciQ/5bernJM5j4YfqwNx+RxYEr+Nw7xO1TYgr+VpgOhSPfkqf7k9nbdgFZIu9mN
	mJRqUxyOQPpGpbilK6BS5x9B037rjKwXt4WeoLkc5O5HLBB/USzHputTMAkBLnAlfvl/lMAxwW+
	QLKD2+5+bvV+qw1Q/tXJtrUec9rqe+rUcuUpgXAFmCdsz3FYszb6Yb9kzIMwZrAcjB47ZoaUnLL
	iOAhzvl4GH8d2DyaZwQ+IfkU4oQ+E+VZfBL9A8QJ24CW1k2BC/9CVq+rQzbYnG4O6DrqMhub+uP
	C532pyLxZGvRhPAa5D02GCjw==
X-Google-Smtp-Source: AGHT+IFm8ymM2lVjoF6wSC8TwGE2I+pinvEWrAbXATzLNjz68TsRuYVhbwX52a8lzV2r8vSv8pkRWA==
X-Received: by 2002:a17:907:cd07:b0:b04:37b2:c1a5 with SMTP id a640c23a62f3a-b0437b2eb32mr399274666b.34.1756759827409;
        Mon, 01 Sep 2025 13:50:27 -0700 (PDT)
Received: from raven.intern.cm-ag (p200300dc6f1d0f00023064fffe740809.dip0.t-ipconnect.de. [2003:dc:6f1d:f00:230:64ff:fe74:809])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-afefcbd9090sm937339066b.69.2025.09.01.13.50.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Sep 2025 13:50:27 -0700 (PDT)
From: Max Kellermann <max.kellermann@ionos.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	willy@infradead.org,
	hughd@google.com,
	mhocko@suse.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	vishal.moola@gmail.com,
	linux@armlinux.org.uk,
	James.Bottomley@HansenPartnership.com,
	deller@gmx.de,
	agordeev@linux.ibm.com,
	gerald.schaefer@linux.ibm.com,
	hca@linux.ibm.com,
	gor@linux.ibm.com,
	borntraeger@linux.ibm.com,
	svens@linux.ibm.com,
	davem@davemloft.net,
	andreas@gaisler.com,
	dave.hansen@linux.intel.com,
	luto@kernel.org,
	peterz@infradead.org,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	x86@kernel.org,
	hpa@zytor.com,
	chris@zankel.net,
	jcmvbkbc@gmail.com,
	viro@zeniv.linux.org.uk,
	brauner@kernel.org,
	jack@suse.cz,
	weixugc@google.com,
	baolin.wang@linux.alibaba.com,
	rientjes@google.com,
	shakeel.butt@linux.dev,
	max.kellermann@ionos.com,
	thuth@redhat.com,
	broonie@kernel.org,
	osalvador@suse.de,
	jfalempe@redhat.com,
	mpe@ellerman.id.au,
	nysal@linux.ibm.com,
	linux-arm-kernel@lists.infradead.org,
	linux-parisc@vger.kernel.org,
	linux-s390@vger.kernel.org,
	sparclinux@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v6 00/12] mm: establish const-correctness for pointer parameters
Date: Mon,  1 Sep 2025 22:50:09 +0200
Message-ID: <20250901205021.3573313-1-max.kellermann@ionos.com>
X-Mailer: git-send-email 2.47.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 3F79A20006
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: huu7awduqxx1g339qkgryin8isu81mey
X-HE-Tag: 1756759829-487091
X-HE-Meta: U2FsdGVkX1+XuAyTqno61bNm5knQsmqZOhOSdj0DsOiL5LfjdWWuTrvStD7rV3mwTXy+nvlnTSR/LvzdkS16Eb/uWycI7TN9N2Ci3ACQ4y6TbRcz8tY/s03AcMtJmQdc/x4mwQnnyD0rrhbcFGbjeXy+bo4mxMoPE+oJmwhYjmRAlU01faCeKDUgNLVU+sm92leX4N8+UaE1AFgs+vsB3zdmKNseW0E4ZyjsRSaic0RAB6xU9T6zyZ1wFMulWAxqVSyJV/vQIITvT0BEP+K59LvoK5W7fPWLRWDYp8KC+nKDaiRqykzSOlZCbSI5/0rvzJKb3PHZ+MG9/UqRneiNboVlE2qj8x9im45nN3KqKDiGBzxB9WW3/M1uN1vK0XxtusdUHiuiYG7n7nrqJWIbeLQBDINN84px1FTkLcSunnfbFuRLOjSz4FLyO5Zp+tH5UPfQOl0sZfGq3H/RtlsgaO3u+c8UeXyok+gOEqcibVjfKvXpIlvPmNV5GOL/BMHyuCoVRlb7IiSSuBDdBGn8aH9upzmqz45Df0M4K3m1Wa9sjQLZaNr37RDm/krC8Xs2Lsl89C87rk+XMlquV6Sr+2VN0CC4EsKuKDrsSgXRPZ3XVjBlG3PJx1ApcQ9On/h7HqhuMnucQJbRlnY0D/qju6byNsWNSoBM63kmqzbQBl6GVhTmuecgB5JFtAdodCIQ/BO6rhiiTsgy6tWcvSVH9KyibEE+wEEvfFL1owc2ThLVf9eL6nWDRP4tIWf0paG5mppgkp7glmuvNz+aa/WFvDR1afy21+YU5Wwu1JDzRKiyhab28+ipMybio6cWowZ9EWrXjscMFa1TWs80ZtbAEXzPCBwqJILYEGmdonpCElYNydoN8myK51InphssAkY3QwsyMt1hA4fFPbq0xcyq2M5SRBc2KkjMWSuJ+ospxlOdbUERbQMmrUap6K4i2/dAZIP+o3jwTJ1hfDLNHft
 xTYdc3cH
 XmD0sQpqCejBM2BkEx1Y6lxaVG+teff9Zq3yOH/CaPGHW3rqbLoaqc3tewPC/6TkBEJDxDdOBeCsnF9drlI+fqSgYsi1a2QQy6pmHBK32924fWkQwlrGK/OCdIFfPhkAekNnkn5RO1grDijL3lZK09wA70PIXjv+6gCofkbPOytF7wz8icQjr7OiW2Lp0E/ac18mv6ppawHdkRxmRx/VbcVU1UkOposuEtqD3GBbHnCDDBfbWFuDB6cqWmnk1qYs6bWYF0tXMZFaVo7K7Kqc/Nz9UXeOnGnrhKN5kbgROg8nGAf25+h98/4FvYJyPgL6nLOCdwgOnBUlYXE86o9pdE5OPbtLSbebFamEoBy6idjvl7QNXsrL8Xu+n3e3QomJmyNg5aIEShPIXbIicPHhAhcxErbwsihhbtXH0xsvz7NRPts0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For improved const-correctness in the low-level memory-management
subsystem, which provides a basis for further const-ification further
up the call stack (e.g. filesystems).

This patch series splitted into smaller patches was initially posted
as a single large patch:

 https://lore.kernel.org/lkml/20250827192233.447920-1-max.kellermann@ionos.com/

I started this work when I tried to constify the Ceph filesystem code,
but found that to be impossible because many "mm" functions accept
non-const pointer, even though they modify nothing.

Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
---
v1 -> v2:
- made several parameter values const (i.e. the pointer address, not
  just the pointed-to memory), as suggested by Andrew Morton and
  Yuanchu Xie
- drop existing+obsolete "extern" keywords on lines modified by these
  patches (suggested by Vishal Moola)
- add missing parameter names on lines modified by these patches
  (suggested by Vishal Moola)
- more "const" pointers (e.g. the task_struct passed to
  process_shares_mm())
- add missing "const" to s390, fixing s390 build failure
- moved the mmap_is_legacy() change in arch/s390/mm/mmap.c from 08/12
  to 06/12 (suggested by Vishal Moola)

v2 -> v3:
- remove garbage from 06/12
- changed tags on subject line (suggested by Matthew Wilcox)

v3 -> v4:
- more verbose commit messages including a listing of function names
  (suggested by David Hildenbrand and Lorenzo Stoakes)

v4 -> v5:
- back to shorter commit messages after an agreement between David
  Hildenbrand and Lorenzo Stoakes was found

v5 -> v6:
- fix inconsistent constness of assert_fault_locked()
- revert the const parameter value change from v2 (requested by
  Lorenzo Stoakes)
- revert the long cover letter, removing long explanations again
  (requested by Lorenzo Stoakes)

Max Kellermann (12):
  mm: constify shmem related test functions for improved
    const-correctness
  mm: constify pagemap related test/getter functions
  mm: constify zone related test/getter functions
  fs: constify mapping related test functions for improved
    const-correctness
  mm: constify process_shares_mm() for improved const-correctness
  mm, s390: constify mapping related test/getter functions
  parisc: constify mmap_upper_limit() parameter
  mm: constify arch_pick_mmap_layout() for improved const-correctness
  mm: constify ptdesc_pmd_pts_count() and folio_get_private()
  mm: constify various inline functions for improved const-correctness
  mm: constify assert/test functions in mm.h
  mm: constify highmem related functions for improved const-correctness

 arch/arm/include/asm/highmem.h      |  6 +--
 arch/parisc/include/asm/processor.h |  2 +-
 arch/parisc/kernel/sys_parisc.c     |  2 +-
 arch/s390/mm/mmap.c                 |  6 +--
 arch/sparc/kernel/sys_sparc_64.c    |  2 +-
 arch/x86/mm/mmap.c                  |  6 +--
 arch/xtensa/include/asm/highmem.h   |  2 +-
 include/linux/fs.h                  |  6 +--
 include/linux/highmem-internal.h    | 36 +++++++++---------
 include/linux/highmem.h             |  8 ++--
 include/linux/mm.h                  | 56 +++++++++++++--------------
 include/linux/mm_inline.h           | 25 ++++++------
 include/linux/mm_types.h            |  4 +-
 include/linux/mmzone.h              | 42 ++++++++++----------
 include/linux/pagemap.h             | 59 +++++++++++++++--------------
 include/linux/sched/mm.h            |  4 +-
 include/linux/shmem_fs.h            |  4 +-
 mm/highmem.c                        | 10 ++---
 mm/oom_kill.c                       |  6 +--
 mm/shmem.c                          |  6 +--
 mm/util.c                           | 16 ++++----
 21 files changed, 155 insertions(+), 153 deletions(-)

-- 
2.47.2


