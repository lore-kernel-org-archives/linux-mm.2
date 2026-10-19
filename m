Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A97CCCF2D4
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 01:12:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 20D496B00BB; Sun, 18 Oct 2026 21:12:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E5716B00BC; Sun, 18 Oct 2026 21:12:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0FAAE6B00BD; Sun, 18 Oct 2026 21:12:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CDA916B00BB
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 21:12:16 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 35F74405AB
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 01:12:16 +0000 (UTC)
X-FDA: 85337599872.25.5A199F8
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	by imf21.hostedemail.com (Postfix) with ESMTP id 792B91C0004
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 01:12:14 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=b2pDnknd;
	spf=pass (imf21.hostedemail.com: domain of samarth.colleges@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=samarth.colleges@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792372334;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=9iMW1/+hYAmRNDgdBSskmyjNh4Q5P7SaRq2YqDn9vmg=;
	b=w/pIhnW98LdQ2oHVvu26vyXexVeN/VZQaQUDTATzgO4vE+l5eFPwUbwHLwJBPSlYHPgcaK
	QHGY3CpyVb3sQvwxx0PaWX5zluPbpHC0Nocs22OML2KX9tx0JMRMw61iCN55yzbAynB9sH
	Ev5Eq4fb/DQ2uiKr0fVaOXwfUY7+hN0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792372334;
	b=PwmH81FJ2hX+UDItC4OrMmp5QmoX74oXQ2RphGcTXQw3zXs3Znpv8YaoqgDiwdccuCLs7V
	uA07ElonaaYFZu9kng6IknQuGsOZz6MjNzYUpfrAGry6rUoIWGLgJViExNy1mTH7WAYMwD
	dgUZZT276MpIxPmKZE4qr94wXzGdGDQ=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=b2pDnknd;
	spf=pass (imf21.hostedemail.com: domain of samarth.colleges@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=samarth.colleges@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2e831e86ebfso7255625ad.1
        for <linux-mm@kvack.org>; Sun, 18 Oct 2026 18:12:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792372333; x=1792977133; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=9iMW1/+hYAmRNDgdBSskmyjNh4Q5P7SaRq2YqDn9vmg=;
        b=b2pDnkndYTF6AQiokc6/V4vQbGd0PXA2wOwqr+qx0COnvhCBOUiidgjkuSBYSHFm8i
         N8qUFRc8pN3OeCS1SwG/Mgopef++8UVpSE398iuS7N8bt5Z3Osz1akrKug1YrR+V58bU
         sG/5njA+YrR51LV94BGjq8Lomme6UteDn2Qtukk6dnwJr6GAWTftQVg0mI/O7BeXDh5c
         RyOZGgbINmIEo7r3lklkG4K5dBA+yDBMFFgOUFAtjN6DjKm1XJJLDlN35FSVRhRx8C+2
         yOtwGkGrH4erI+t6WhwB2zDfp2Wgmzh4IKzQW8Vh1yo5tQw+IZqaXp4gbdWuxUxylf/w
         zRsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792372333; x=1792977133;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9iMW1/+hYAmRNDgdBSskmyjNh4Q5P7SaRq2YqDn9vmg=;
        b=Kz7hRspFhSc8LPTDrAQYzp3v1AfzrMsHuxQQ08BbabTu10lu8r6p772Rc2faXiO9+W
         82mrzx6D72/m/TafemegvaCtsWeWX0dqpob2GcycKAvCJw11vmhOfYYlCDbPVw74LIhX
         dgJyE5QHRdpgLWYlhA9Tj/e08umX+enAx41d3cgtoYNTHT3ElkVVtR6i78JdGueKE5oS
         JIEJtE7FQU+bz3j4HWp+wYDaUq+n77kU72vtfaZE1Nx7S5ut3Hud/YGkzucEvyM2RcSa
         pX4n5LePBVtEMQzw49uL8huXEgFsphyHLg9M45uZLC74h9Fo/KuLU46M8O2HnvUvNlQ/
         vZiw==
X-Forwarded-Encrypted: i=1; AKwUvBxSpGSPe8LIHqYGg6LhzOYVGo8qu/gQx4AGJMzn/V/E/kB66+wLndF806ATKGJOZeLaOEbqCVgFjg==@kvack.org
X-Gm-Message-State: AFq9FYJFuRxmHfuhrwO/7FFZRozQZl4tYIWeBGv0r8wTOtEjjiRMKXur
	Hn6G7Z/5IES/TtgQe1hN3P8u2pKxYCJrzkDToCSt3WJIiF0NcJYGVXBc
X-Gm-Gg: AYBFou0XvO89AfQANG4VMkH+YaSW1lqQf/9/s52r8aEizl/pLRZMpIfFT1o60mS5zN8
	7q4SnPQgMOkXQZ4zB8kVQXKZUvCenlPncos3XrvnY72hGeLssT63KRhHKQ5VbLO04IhcBLOp5qs
	HBcfz5UbyU8mr0IGEISuWjz4MgGUObq1TzN0+kJ/w9B1EuF6trSsa/PVMUq0L2SrEnSdBA66KZY
	B3NLhi3iO9PclYzvtOnKkSdf7TqqmFj3LnWNuL+phVsPBNEbZf579LHZyJyD111xgS1O3O6y7QJ
	/7yxtH4XYyzVIbbOG+oktykuRfNqov4IBHFwL7XnfdKGaUhZrHiF4cvjkfDgzgZJg9KzKmrO1q1
	93g0Em44phclSxSF5y2jKUMbZ/kIC4uoz1lTuOtuoW/OKLoW+DrD+pzpF0TaVqbBdhOoxcEC9+X
	8adQsZd98/uCghusfSoS99QPKkVprb83U0XhcJYv8lVP13WKRVdNZ4ovXBA+aVER49rAsz2wGNF
	cBRj/xonVUg6ZqV5SElb5kzfzGde//kjYyGxmcqyoMUW03lWcyH/kw5
X-Received: by 2002:a17:90b:390f:b0:3ac:8897:7ba5 with SMTP id 98e67ed59e1d1-3acef5f5bd8mr5441712a91.59.1792372333228;
        Sun, 18 Oct 2026 18:12:13 -0700 (PDT)
Received: from 1u1g-b650-0212.nvidia.com ([72.25.70.131])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3acc9d266d6sm7011793a91.1.2026.10.18.18.12.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Oct 2026 18:12:12 -0700 (PDT)
From: Samarth Narang <samarth.colleges@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Xu Xin <xu.xin@linux.dev>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Peter Xu <peterx@redhat.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Samarth Narang <samarth.colleges@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH v2] mm/ksm: keep soft-dirty and uffd-wp when merging a page
Date: Sun, 18 Oct 2026 18:09:34 -0700
Message-ID: <20261019010934.697895-1-samarth.colleges@gmail.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 792B91C0004
X-Stat-Signature: 3ou1cxgaagp5hxq7a6pwxrtjunq8aqtj
X-Rspamd-Server: rspam05
X-HE-Tag: 1792372334-389155
X-HE-Meta: U2FsdGVkX1+tfobVIno6Ssh0W9Y+R3iYt124uQYAA8Q5j1Bi0syJAG0JZeQLfYNuYB1GHcVSb5P3DHIfqOYoJtC2FLweRcI71Ff7WLQSTnIZZhe/i44H/6oQ2VVvHmighDUwXJscTWBFVDJepN9nidIemECrpR31amS0j+0XUzZKNL16P5JwWfKMC2QUJVNpFHR8ECKb07CizyFqpiMsgH9sub4aqFuGZuZAMZh15c7AbuVY04PF9gqG6PtaKRVxmaSBgTS9kXA1lPVXwwnL0mlefHr2ScosT8DyujY5rwrd9lRd11njRA4opA7v8Ivfttwjj4c1h8P+Z0gtxRBWh9M+sZ6HY3eHMJEkRtvuc3Utzgomp4ibYFAt7h+yeam3WooSE+tyoZbz/fuCsWm6TlZyBT8582FLCUafrYnaSVxskKgQQGqOrEgGGADVvi+cj5rVN+ZSgMaph54jkhGvIvX+mn9NZLxMe+Spivl1zipAOlcbrrNnHeMopErH8m7r9Q49+2Aaqs1TnwsoM6pqf9p20hFwXbBudXxaygBQE5R1faT1bJ1zYzoEeMEPhm1SDxlEdt9CA0qkb24IN1VHZaEGuQ1KwK/HwvwOZbmt/vxigEvfru4xaKl2/71iIBF08b0q+6bJzwSDx45CMRvY+YwTgWSq/HllFifvUWWeFmv0fw8/BL5N+Hwpg6VZvwdGOaFqxZWbQVRcexxMNTE2omjbwhgfMNtNtL0L/pQ0kAHmgzVtEWwTar7SYXTqHlIRjNpIZ7AroJ5byjLV33BVxjgFcLS1g6M3d4tpvokNnL5dxRJ4/Omt8NvTMzqNWAMXE71EWuHT6gBMt9sDw2pyQ+q2vO6wduXl1KSHKnZ8tC9hqssu81Vmexv/wQzktMsjkhm227SxDf8ty/ZU8FmQYXnv1m9RPpmh/N99a6uh4hXGSBdWQ27zAoKZ6I7Z4gxjKsfAokpWliWzpOAI9E4
 fwD7dnYd
 pRXHYX72C2MWnKqWkoyfr347PxTa6D4T1MC8d+RQhY0m6Jxdklq+oDc/jFN96/+wErurdLhN5J+saUVwMmETXhpy0vx0rDcmHyfjaNlwYxgax6KAI63WOmtCWwwvTnLeSYVcLNU93atnz2o5cC0/Uh3/vyEugNKaT6hHjNT92QEouUEF5TDuvSS3aMoIq3+MypqYjrYKOvDRpCnbT/Shvhf4KavCzHSzWvNeFXkvquATuSdEoU4gXGWUTXxoGYT0wXo3sx49wGj2wav0dW+ggmMlDPDofHKZEKsYa2AahJW6lLkQgYqUvYZhTVp+7+3i7wVJ/4zuZ30SYgV+yctOXnVjrYRXeu9Z5Uck9ZZ/tFk3JeGVcNTLfeItqCmcsvbIH5S0LhqVGzmIjtQUqQyDszbLnTmvcFoZr/Ic3MPOXBoh3D7dTyKOoGJ81YdekZcbqWlJ9cAcA/e/V2U0kbcOkw5xmpxyUvFU4lOB3YLpLXGQqRvLoWJ69yF1f29ECHOyMaHoIwWUc6eM2RJI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

replace_page() maps the KSM page with a PTE built from scratch, so the
soft-dirty and uffd bits of the PTE it replaces are lost. Due to this, a
write before the merge no longer shows as soft-dirty, the next write to
a uffd-wp page raises no write-protect fault, and because the page is
mapped with the VMA's normal permissions, on a uffd-rwp VMA the next
access raises no RWP fault.

Copy the soft-dirty and uffd bits from the original PTE to the new PTE,
and restore PAGE_NONE for RWP VMAs, as try_to_map_unused_to_zeropage()
does.

Fixes: 0f8975ec4db2 ("mm: soft-dirty bits for user memory changes tracking")
Fixes: 63b2d4174c4a ("userfaultfd: wp: add the writeprotect API to userfaultfd ioctl")
Fixes: 2d427bb01639 ("mm/userfaultfd: add RWP fault delivery and expose UFFDIO_REGISTER_MODE_RWP")
Cc: stable@vger.kernel.org
Tested-by: Lance Yang <lance.yang@linux.dev>
Assisted-by: LLM
Signed-off-by: Samarth Narang <samarth.colleges@gmail.com>
---

Notes:
    v1: https://lore.kernel.org/all/20261018122957.526467-1-samarth.colleges@gmail.com/
    
    Changes since v1 (thanks, Lance):
    - Fixes: point the uffd-wp and RWP tags at the commits that make the
      registration modes reachable (63b2d4174c4a, 2d427bb01639).
    - Shorten the comment; the uffd bit carries RWP state too.
    - Add Lance's Tested-by.

 mm/ksm.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/mm/ksm.c b/mm/ksm.c
index dbfb8f98b189..de144fa07c49 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -34,6 +34,7 @@
 #include <linux/memory.h>
 #include <linux/mmu_notifier.h>
 #include <linux/swap.h>
+#include <linux/userfaultfd_k.h>
 #include <linux/ksm.h>
 #include <linux/hashtable.h>
 #include <linux/freezer.h>
@@ -1463,6 +1464,17 @@ static int replace_page(struct vm_area_struct *vma, struct page *page,
 		dec_mm_counter(mm, MM_ANONPAGES);
 	}
 
+	/*
+	 * Preserve soft-dirty and uffd bits when replacing the page.
+	 * Restore PAGE_NONE for RWP-protected PTEs.
+	 */
+	if (pte_soft_dirty(orig_pte))
+		newpte = pte_mksoft_dirty(newpte);
+	if (pte_uffd(orig_pte))
+		newpte = pte_mkuffd(newpte);
+	if (pte_uffd(orig_pte) && userfaultfd_rwp(vma))
+		newpte = pte_modify(newpte, PAGE_NONE);
+
 	flush_cache_page(vma, addr, pte_pfn(ptep_get(ptep)));
 	/*
 	 * No need to notify as we are replacing a read only page with another

base-commit: 48fe11c8d0f1e4e59426a3606f20ac1130b6d8dc
-- 
2.53.0


