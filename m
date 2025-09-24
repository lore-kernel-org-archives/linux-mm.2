Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA9B3CAC59A
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 04:58:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1FFB38E0005; Wed, 24 Sep 2025 00:58:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D7728E0001; Wed, 24 Sep 2025 00:58:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0EDA78E0005; Wed, 24 Sep 2025 00:58:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F171E8E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 00:58:47 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8331F87879
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 04:58:47 +0000 (UTC)
X-FDA: 83922938694.08.00600CF
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	by imf12.hostedemail.com (Postfix) with ESMTP id D3C4E4000C
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 04:58:45 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=none;
	spf=pass (imf12.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=ioworker0@gmail.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=linux.dev (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758689925;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=8vIg6XtSGSkO0XzH+aly3x0msaPeV3MFy+v+xHAk0bQ=;
	b=q2jyY0c855Kr1GFJkkRz/sX7+x1YWZtrjliZOAI9niiqWBNTZZpTj+qX511QoMrljkPAjY
	IE8IOxzLstDUs+QylfDY7CX2CICcA8GkW17lqbwYMj/mIFs3U2C7cFheFfCYRqGGm7MTys
	PyBfuS0gEDL9zCLKxVxiPfJ8UrjyFlI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758689925; a=rsa-sha256;
	cv=none;
	b=uhyYmqkaeL5ZdF70sutJKYY8UNUrobRXvfvvFfX5BLaFZZWvmTQsmj36N8lB6uheKPgxPQ
	t451lrHt/nlTybcDXFpODmSgl78DtTbC1W3ATX9kZLKWbrIcaTCzzaJTEzf4f5Dsa11quG
	6yjLq4YRrIvWSJ0d2/kyfxn0AoV3odA=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	spf=pass (imf12.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=ioworker0@gmail.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=linux.dev (policy=none)
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-46d40c338b8so21681505e9.0
        for <linux-mm@kvack.org>; Tue, 23 Sep 2025 21:58:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758689924; x=1759294724;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8vIg6XtSGSkO0XzH+aly3x0msaPeV3MFy+v+xHAk0bQ=;
        b=D7i9YnSuy5Q42uvu5ta9grnpkhKgSK1J1DrmhJO0Bp5+634EnEOqzRyh5PV0RQlbDE
         1pO62D8nzFLSDLnfxvTh7afTTSCXvJwVHQSSVPB8BPajXbM2rJrNN+NfagQwYy7jVbNG
         LDb3G5WUpDTmnGHI/92SsRc9qaAKzg5LVVdX2JchIcAJnQpq7jkDDPve0i5m2OI5+P8n
         pbbDIEQ/I+wZglClsCamullgZHrVuj1EfQVDHu5PpqJgq1T+1CBaRvY+Z4fcfsZ7QSWE
         87HOoLgM66XigBocbDpOt6CTKU0S87Uduq/nVoCi0x6k9/rkAorVbaKagZSajb/tdJmH
         +0tQ==
X-Forwarded-Encrypted: i=1; AJvYcCXPytuQIQI5Jkb3pVuzYtIo8X8V0xrLSJ9qPTCgkIExE4/w4qbr4/9z5rydPNIXa2dXTkOg/kFg7Q==@kvack.org
X-Gm-Message-State: AOJu0Yxs0gBP3/1mNfsFvmOKovy2bb1t9F8Ocp3D0wOvJUIZkqHylak7
	pHEzR5obMWYtW2PDRRBPE8+qnO1doSVRkhR6CjvxQ0FJvy/y+RuO5wDY
X-Gm-Gg: ASbGncv4Qnu+WivFUiV6XEAM+dgFGdpNRCVs957PBY2rRNDf7ZwLAp8hai9qXT0lhym
	gsbi1OI/vEDbkxFlSLui3pQzsz79k9+RNQE5QCVg34qTro5Xbl2rpHXjLNONNCLd6hFoD9oo3K6
	s8m5lwyb2XJn3xofCXKQ0bOeRGPQyAbXRoMdTWdJb5XzBkeD7d34qu3UyUEyAZXoTqZYhRS2oSc
	WepTNfqI33l4a+L2Wy7YMd5eNZAXxcgRjx+HhK8z92fdYtnM/hazRSx7NsrP3mvffRNWriK7V2z
	T0YSRN0BTj8NyW6YiZ3TJnJXp3v/drss/2t0UyLh/tZbH5oIpYojKn1cLVk/lHqNqzhNsQ75Myn
	uPPw1XOMH
X-Google-Smtp-Source: AGHT+IHeiSxoEy6ldzX2Rzke52MCPXDJs+dThVKlNKM6eJIBMgy3M0v7YvvA2TJc93CzWlCycX+5YA==
X-Received: by 2002:a05:600c:3ba9:b0:46e:1f86:aeba with SMTP id 5b1f17b1804b1-46e1f86b296mr57881105e9.17.1758689924125;
        Tue, 23 Sep 2025 21:58:44 -0700 (PDT)
Received: from EBJ9932692.tcent.cn ([2a09:0:1:2::3086])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e2ab31f62sm13856405e9.15.2025.09.23.21.58.38
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 23 Sep 2025 21:58:43 -0700 (PDT)
From: Lance Yang <lance.yang@linux.dev>
To: akpm@linux-foundation.org
Cc: richard.weiyang@gmail.com,
	Liam.Howlett@oracle.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	david@redhat.com,
	dev.jain@arm.com,
	hughd@google.com,
	ioworker0@gmail.com,
	kasong@tencent.com,
	kirill@shutemov.name,
	lance.yang@linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com,
	mpenttil@redhat.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	ziy@nvidia.com
Subject: [PATCH mm-new 1/1] mm: clean up is_guard_pte_marker()
Date: Wed, 24 Sep 2025 12:58:30 +0800
Message-ID: <20250924045830.3817-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D3C4E4000C
X-Stat-Signature: xdwzmdd75i5sat76ygtqhunot5byd9yb
X-Rspam-User: 
X-HE-Tag: 1758689925-688112
X-HE-Meta: U2FsdGVkX19MdaVMKNlOHhJMAvfrAwluQZaEiR4JABucF6TfJ8b0Um8gEgs4bu6yDxdyVcFrO4nQsz/mQdtletqzA6KS/QaJuZkLUM2HPPmx5D224K5w7dt1xloaJnVZ64FVHuozaB3NQAiiug/Bc5VjSmSVmc5ZkfjQkv0p6JwoEmBPd9H8DhzRFl4Nw7S6BCT03gJE70mfW7ZIfRWD+9Hd1BiN8XnnbTohE3SQLbGBTMFnnoR+zAJQJFSo8vNIAzECrGIpseM6Qj/G2qe0GyQBa7mJtyzS+PO1JF756SW5+f8NYi6bmCEDDya5EayS4A8UIRhKx8YVMDrx2ueQNA3RNXbMRIeXXbdhU/5bEhcZLq/RhIjgLftFoZWZMMnjHdFFQ6zwkupbF6p88B8SxPK2rGq/fFbwDUxXx2n5izvLhm8LD2OPrEvpEcUdJKJTBB+meQQUdyJECOCuQ9nBnWQK56iCEGymuTRbfae9uWU/hX7TS5MRw5p8h+hhhYuf3+kw+ZPf047IdT138F35a1rR23WoISaZI/+my7ICJiMa59kJA9BBxA/oo41j4FVWnAcGekyTRavqgD0kHAijrdPl8VccVz3/BceOhOFnTy50Q5gmNsEXD9LMkhd9FOOHjfpYPaNOwy/ntjN7wxs/d8tiAdUKvJANrwpVPdDXCw1ZtRCODnfs8pN9Tp+sd82xTQY6Eq2aqtASQJmOTv2xqoRD9piaEOJmItAG+r+m4JJ4rJjLghrbFBf9iNf/kfW5Z3N9Ojwdthl20EFUjxTCdnQAJBtIlodO/0MS2MGBe8WP1Iu7sDVt5jSdV84dmS2uL0POFnyRpm7E8HNDZkgVws1hyv7oDcGRqjori8CQ2IF6/u4jojSHYDjG370GBIOQLDP7koCICOwcahNIHV4tq+CSJgLixXos6vMOfUYn4tdrEwcZKcoBtedohV1TzEt8W9FDDi+4iQHzb6fGoiS
 feqQ7yRE
 XaTUhYuqiVITz3chHvQu91DdWVLOYaAFcuFGacLZSjX1N/46HdLL/UkfkO/BSVEp61ap2olh6qkR0WAAuiVnrNSKDW6qxeMfSTP3VZ1sH9a4rpQ4+pQFnlAJDTAVPxdOrzY0MOITfIQrbVZzz+fMiPkEoDYiHMSKWA3MBrWYgjwRn1DjfmA7VIJuC9VmR6n1XEE0xyRt+qkHWJAJLNm910fpro8zRfwUhaE/DQ1Br9XNw9BBeeMYfYwCnVP5WBiPP8lAZr5YRBnXUHutmQcd9mn13vGC2yG+jFeh554NJ30jgWbE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Lance Yang <lance.yang@linux.dev>

Let's simplify the implementation. The current code is redundant as it
effectively expands to:

  is_swap_pte(pte) &&
  is_pte_marker_entry(...) && // from is_pte_marker()
  is_pte_marker_entry(...)    // from is_guard_swp_entry()

While a modern compiler could likely optimize this away, let's have clean
code and not rely on it.

Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Lance Yang <lance.yang@linux.dev>
---
This patch is split from the series[1]. The cleanup can be applied
independently because is_guard_pte_marker() is no longer exposed.

The original Acked-by and Reviewed-by tags are kept as the change is
trivial enough.

[1] https://lore.kernel.org/linux-mm/20250918050431.36855-1-lance.yang@linux.dev

 mm/madvise.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/madvise.c b/mm/madvise.c
index 35ed4ab0d7c5..fb1c86e630b6 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -1071,8 +1071,8 @@ static bool is_valid_guard_vma(struct vm_area_struct *vma, bool allow_locked)
 
 static bool is_guard_pte_marker(pte_t ptent)
 {
-	return is_pte_marker(ptent) &&
-		is_guard_swp_entry(pte_to_swp_entry(ptent));
+	return is_swap_pte(ptent) &&
+	       is_guard_swp_entry(pte_to_swp_entry(ptent));
 }
 
 static int guard_install_pud_entry(pud_t *pud, unsigned long addr,
-- 
2.49.0


