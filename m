Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35B85CD343F
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 12:43:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4113E6B0005; Fri, 15 May 2026 08:43:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C2496B0088; Fri, 15 May 2026 08:43:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B1736B008A; Fri, 15 May 2026 08:43:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 174346B0005
	for <linux-mm@kvack.org>; Fri, 15 May 2026 08:43:04 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B4DA81A0536
	for <linux-mm@kvack.org>; Fri, 15 May 2026 12:43:03 +0000 (UTC)
X-FDA: 84769619046.23.DAF279E
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	by imf12.hostedemail.com (Postfix) with ESMTP id E825240004
	for <linux-mm@kvack.org>; Fri, 15 May 2026 12:43:01 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=suvTkNVu;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of elaidya225@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=elaidya225@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778848982;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Z084uCbkFx59D3UMHm4ioLPaFQOLLB0xopC+MevdRJQ=;
	b=GyQfW7u2EnFK43Kxr6/GScPIzvjTbpvbb+snr8KIiLeQI1iIJoaXFJIpr4xtQhWLI5DivJ
	5mVN2qRqb6DpDMjZ0ztZePNaK+GqvamltB5fIYV/GikkvfpRolTHFIqwoNP0PKlMEsdJIR
	6T3gjw4NiIS+2+IDKe9ijnFJYUOMbDU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778848982; a=rsa-sha256;
	cv=none;
	b=mL3lgrLi/sRfu3uODPta5xBuuKxodWicceP/8I9NSgT89I0/OnlJjOsGAGa5kq4JcJeKDe
	EYvhD/ICvqYhO0fXbXOAfOWS1pDjOlyyR1mhkFx8eGKpNGt1m4YgBg2xv/Yrvnfm2xwj03
	xIf78G1We/Q2X/Mx9vEQKKU7ogYe1rI=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=suvTkNVu;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of elaidya225@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=elaidya225@gmail.com
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4891e5b9c1fso82105345e9.2
        for <linux-mm@kvack.org>; Fri, 15 May 2026 05:43:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778848980; x=1779453780; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Z084uCbkFx59D3UMHm4ioLPaFQOLLB0xopC+MevdRJQ=;
        b=suvTkNVuS2GgRzmYmbWnpveZpKUFoo6mBNl6u+hPke3/NIvJpLZ5VelNC4x7Y3zAGq
         hw+XB2cZn3I6KhSJu2gh5yweCOn4oMZ9kEX43iwDO6m03zmJp3Bg7zfQjbrsecjz/VKk
         i/zIGPZHDzxihzPYwBJrn2udgDfNkL8WkLt3WpVempDG7YmZcgJcqWCErLGsqRv6uzy5
         1EA3SvaJVDsfBBspbzwciWPuLtIZ8eTxGLPH24WboaQL8XxkZAE9jWBNSAOyAa/RRExA
         T57BCkqS2FS0eMCATQjyx9cmXJaW7Z30aOKZwgiWJrALWKLDluabRYeUIEQ2K/gSNFZX
         YAlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778848980; x=1779453780;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z084uCbkFx59D3UMHm4ioLPaFQOLLB0xopC+MevdRJQ=;
        b=L3irJycg81pn5nMBHSDmOf+ptQhBBXF2RrDkwhZ7VKXseJqHD4BwP3tFJLaYmsUk4r
         JJjduruQot+O4a535wHi8riwEb0C76iRHctPrv0fjDhW4kVPqRBWjMRLSJwnW863D2uM
         2JZFT+0zoQyY3JNSoyPiu3IC06hQSE/SQsr9dN4QshW+ZxUXawTDIR6tfM9R80z4oRP5
         54wDHLycjlz1s/ZJ6OZFt9mLjsIVTbtFID90abGP9zcGCmq/y9EGcZqi9vC8l40FHv+R
         kLk1EoSeeUacvFf9uPH9egj9kKBQCtops+geQYuyvHkI9a+ggysakQEMH8DaiDl3h0Dw
         RbVA==
X-Gm-Message-State: AOJu0YyXra1G5BCdTBO/E7eVSSpdUQ8HJzARTUST23IwTKExNxzEN9Bh
	+TK1rWi/SBOs40+cRJF12j6gppfR4/Zt2dzg1fIgIbn2XlequNN/J5nM
X-Gm-Gg: Acq92OG7gx/4gQc9hJ0HvUQIJRPnP3DzK2NsXIofoP118DBBTmCfzXpn2TiwrXuZg6a
	IV5gH3uXts3efZKMcW67xYm4epofzeCcQ4mHGd4BAk1tyoMYUtBS6VQqvoIxmrv/pyAC4gRjSBY
	OZYXsNsso2y3PIIu6dau6UoSHTLexqqAGs8dh3fsuLmI6RLiIGhMYw7hAhEioAS1uRt1rgJJe2Q
	aAOdXWCquaaGRn4OlB+GshasH6vHqljV7Ke2fx7AkNo4QD00Ku8LOPjJ7tEhk9lhrwAKpoomR7s
	hvKS5IWuHAb7w6R4YYjht7cSUSdJ08xDsXP6lW4NtamrCTveB1ghVNfVNnc5RQPfDROeAHOlnql
	u16px3ZtceVfEHvu5rFcN0NS5e65VOnHmp3h4rnPl3baCR5M+VKHmc2CbK0qXkP99oY+FDdqCMi
	THV83hWMolxroRdX8aZyI=
X-Received: by 2002:a05:600c:4e43:b0:48f:e230:8cad with SMTP id 5b1f17b1804b1-48fe6632135mr48885025e9.33.1778848980288;
        Fri, 15 May 2026 05:43:00 -0700 (PDT)
Received: from fedora ([156.207.183.142])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48fe4c8344asm100188115e9.1.2026.05.15.05.42.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2026 05:42:59 -0700 (PDT)
From: Ahmed Elaidy <elaidya225@gmail.com>
To: stable@vger.kernel.org
Cc: linux-mm@kvack.org,
	akpm@linux-foundation.org,
	ljs@kernel.org,
	avagin@gmail.com,
	Ahmed Elaidy <elaidya225@gmail.com>
Subject: [PATCH 6.18.y v4 0/9] mm: backport sticky VMA flags and soft-dirty fix
Date: Fri, 15 May 2026 15:42:10 +0300
Message-ID: <20260515124218.151966-2-elaidya225@gmail.com>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E825240004
X-Stat-Signature: 6hz6k79d4wf5pjj4ht795wyqqsf586sp
X-Rspam-User: 
X-HE-Tag: 1778848981-498297
X-HE-Meta: U2FsdGVkX1/Tnc3bZZV7pasWkzDuUHyCMNS17gpRAfchXticOD45AddbHUO1zb4y6/0o8spla87f+bnT/chRYU+nPkCQi/3VU1x/5d1FwT7LxQa5VO9azlE97OifxdJsHH5Rr20myPp7scC+Y7aMyCvgpoZd2fiKK63N3sJaPog6Q1FM36xNmrfq+iRagAJjJ02xJ/XDsKjFd/80Srr3m3z8GApYDNG5oNKLibxAD2PdLkn0YA++NOR7yLPO0Y5LoqNPKIe/t7rMOMftrzU/E62Jp+Ie6UKPeWD7BomOlrpSHf+qoiHcdGXB+XZ4ilbTaK7hNZjoUQGIPu2yTE5tKgQIBA+E/4ySIsfKpHainhTkqn0a+6ZKqpGEu/CbMqzJT9BVFxVKUi5LceAerpLS5eQgCTloTC7YKux8O8RUxwgJ4FzAhyq1zVL4OGGWtNXNIyntZnlPHjEwu5r4Z1U7/naIPbBI84YeBEoukpZBYpQDsfLN1DHKa8r7GEFXuxvqmgnUlNp+UifRnvXpJ8017yLtiozhzQXa+SbpauPK1fBCNMi2N8fRQuoD9wwOsS8ieiH2AzIOzHl3sj+Nw1JvPyHjcqhbR2y1DmYAw1Er9JUzaidIh0MTCiW3NswLNHKWSPZJPwuLwkF+kxtRz+snOKZwUyVQ4y1NXaW8YFSdye6G9ptfcgYH+po+0wz32J2XXzWcfFizz6oI8rC3VDvgVHXH4KFkp6kHzuldY1YWYSKjNW6aURci3GyLcAziUl07gPcW2elaJ8qHiK7ABulcPM1+KVtabVZDj2AT/1+t61uAppEdCOnNnqxka+YfIWM2EqujblUf2gLqqbNbRGD3VGIG5c5AgyYPdPFqFVqliwoONypEMkQrpDUu0IgugU2U4j5KUg1unwzXlKM9wFUXIfM4BGhbyAi+BhTXq0zjY6sjud8zEqgNbjmettbosSGS9rsOjywfDxeM8Tbhz97
 6Zt37SVX
 M7LObQaCwxQ2vYAGXiaqa3AfxVd7z+wIguCxbQWlvMp9+ak/Ruo8DokDkWluLwUvwL0mK5Ea8uoMZt6VC1WbFLA+TcDJK/dgQp7zJjPe4EZ45rqcT2FeTA9wvJL8eA1v0VKAXayG8acty16SwCO2VuWk7KoaMV0T9mbGtWptaaxa9/BWsOoNL1o3fkf6EFYYaTSFsXjleQb876UnL87VvF5suYL2bfmTRev5FjL07AZ0wDFGIf5RKkyGkQV4SbXjezaV+2I0LqgMQ0mUF88/sQJl2TuAi4Z5fblZA/VzPotOI1KCuHuuADj/OqUqMLOBSrDCM/hBz4Fi3IroJmlOeaqdw6G5cc9Q+DqOcFxk5OhKTA7Lt7wSytUX+0LdViH8v1gRlrTwB+Z5o/JBI5hv1LHnOXA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series backports the sticky VMA flags infrastructure and the
VM_SOFTDIRTY-on-merge fix to linux-6.18.y.

Motivation: CRIU incremental dump/restore can hit a missing-parent-pagemap
failure when VM_SOFTDIRTY is lost during VMA merge operations.

Patch 8 is the target fix:
  mm: propagate VM_SOFTDIRTY on merge

The preceding patches provide required dependencies on 6.18.y and are included
to preserve upstream behavior, as requested by maintainers for stable backports.

Changes since v3:
  - Reverted to sending the full 9-patch series as requested by Greg KH and Lorenzo.
  - Updated Lorenzo's email to ljs@kernel.org across all patches.
  - Added Cc: stable@vger.kernel.org # 6.18.x to all patches.
  - Added Fixes tag for soft-dirty merging in Patch 8.

Lorenzo Stoakes (9):
  mm: introduce VM_MAYBE_GUARD and make visible in /proc/$pid/smaps
  mm: add atomic VMA flags and set VM_MAYBE_GUARD as such
  mm: update vma_modify_flags() to handle residual flags, document
  mm: implement sticky VMA flags
  mm: introduce copy-on-fork VMAs and make VM_MAYBE_GUARD one
  mm: set the VM_MAYBE_GUARD flag on guard region install
  tools/testing/vma: add VMA sticky userland tests
  mm: propagate VM_SOFTDIRTY on merge
  testing/selftests/mm: add soft-dirty merge self-test

 Documentation/filesystems/proc.rst      |   5 +-
 fs/proc/task_mmu.c                      |   1 +
 include/linux/mm.h                      | 100 +++++++++++++++++
 include/trace/events/mmflags.h          |   1 +
 mm/khugepaged.c                         |  71 +++++++-----
 mm/madvise.c                            |  24 +++--
 mm/memory.c                             |  14 +--
 mm/mlock.c                              |   2 +-
 mm/mprotect.c                           |   2 +-
 mm/mseal.c                              |   7 +-
 mm/vma.c                                |  81 +++++++-------
 mm/vma.h                                | 138 +++++++++++++++++-------
 tools/testing/selftests/mm/soft-dirty.c | 127 +++++++++++++++++++++-
 tools/testing/vma/vma.c                 |  92 ++++++++++++++--
 tools/testing/vma/vma_internal.h        |  49 +++++++++
 15 files changed, 579 insertions(+), 135 deletions(-)

-- 
2.54.0


