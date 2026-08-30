Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0592BC61DD9
	for <linux-mm@archiver.kernel.org>; Sun, 30 Aug 2026 04:29:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1CEC36B00AE; Sun, 30 Aug 2026 00:29:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 17FFD6B00AF; Sun, 30 Aug 2026 00:29:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 095A06B00B0; Sun, 30 Aug 2026 00:29:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D9D736B00AE
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 00:29:53 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 65717C023E
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 04:29:53 +0000 (UTC)
X-FDA: 85156657866.19.9B7CAC7
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	by imf01.hostedemail.com (Postfix) with ESMTP id A007440002
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 04:29:51 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lUNOarf1;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.215.178 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788064191;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KIo/hskvY35I+xlwCnjLbjXGmC9TvGJPu5fGHiHuA6o=;
	b=LGfI9OaeabDQi6Pu7SSEB+f0g5LffLV7oQ1d4Ozm7fasNkMIVP+ARuP++rtCZo1JnHBxXv
	JHFTJl/9xB4iLRQVtQu/R6NCX9Zu4/LJAtZKMa5vFaR/UHesNGx5rwPnUitIYsIps511Fv
	+0WNfeNv7VjAIctDUkRFQyCtlOhBMMo=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lUNOarf1;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.215.178 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788064191;
	b=LZhtqg/M8YQxlvPmdvHdVp07WOF6/LCQ4v/y6CJtnRIkh79pWgIgjRCsOcvUw4S3Ychteq
	xKdxwZuziqPQqC75zHkE38DJ1iEN9hd8c+VDaQ+Ii4KNUD7VOscYzdfscBRuubGKJvwpFk
	i7RkRmI/xqBgcLlxUWSFPB6fX/thfRI=
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-cbe41618110so422480a12.2
        for <linux-mm@kvack.org>; Sat, 29 Aug 2026 21:29:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788064190; x=1788668990; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KIo/hskvY35I+xlwCnjLbjXGmC9TvGJPu5fGHiHuA6o=;
        b=lUNOarf1FSDrMcfc2wqGEeB38/kPZ0oZ+2ghddBTgnXr+YMcos8Pa6v0h3sN/R5Xr3
         XqCeUnogsZerlF1g0uEIbBhAxYECwAW5Z/9TKgY3lTtBV5Bvi08O5M4oTBHvx8AWguDk
         Y0JmIk8fe0V7emHq6jOUqlBDYphwKjmQPF1GQfpm9l82M1HNybGsBHQsNhvES5C0p2FY
         /i9IlqzvQZybh6SCbKZ3ZWgATbErPW6ZzC5peBfFhtDfcW8UD9vtzc5RSW3uUm1P7oML
         Pu/GuIG7uw17yMPwyjBD1fgYsZEotNrbQDhB6kvUO+ELuVuDaJa783W4iOUxeAFk574G
         WN1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788064190; x=1788668990;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=KIo/hskvY35I+xlwCnjLbjXGmC9TvGJPu5fGHiHuA6o=;
        b=I/C0k1+0JSvsqcb5KVhK8qJelzD1xKb/6TOUmvLu8VEOlrS/Y3MTMtK9hDR4iEqk+h
         lQUwUoBkrrYD7T0RdZLkKbKB07mKm7+KNlfoJPpQwkHy4DpwMEqNKDg12D7x3rLacEAq
         OcRk84oPhpAw/6VOL1I5Q5K2nGYdVNue8BOnkxpjoqXHEyN/NnPKbfmuxOSJWkKbZDIG
         bVnW+Z4QzsJnq0W6SA7nehOvLCgUPpu9w0qYurMSoVPcvy7GPsTUd5r4DAOzmLX/MsHd
         l1BUWB8+kgKWKCERmi3IxrjtwFV1y/xdRAApNLBMYTDW8nxEIQIndBa4tBAq5iC4kEJs
         fQUA==
X-Forwarded-Encrypted: i=1; AKwUvBz+ANiSsev4HwkR1R9H7GQDURjYxcp/Q/rw71qD26bNoYlVdPHSNNk8u0rwOk+8yS1m7GZrJuQ4Jw==@kvack.org
X-Gm-Message-State: AFuF++nu3f8/NY6xzyWgnrYzLNUG5teS3M6fdZzvmOJwztCUThUvwK8X
	KaVC1PjWiTs1YpqrtjsL5KtOQ9UKd1sb8aLNleU61gF/X/G02I62upHI
X-Gm-Gg: AYBFou3zRATCWbHDSUQPRRBYTIDO1zvn+8rPgAF917zFZbL7WlchHooAHOqzJMmAbM1
	LEPoIf4IHhBm+ysuxH0dPo0zJSjvwN/QSodOb+G6Qx0z3zQBSng9mXlAbvR6zlavEhL1ZIAzh6D
	FOJqdgwh9ogUh/vK+3w6IxtxCVCCNuGzLeGgP8eQn+gsmueZnc3GdWdLs4M5i6miEWNUC5cV5Lv
	B2I6S22UgKUoHECCJaAdMs9Kk2XOIyLNbA4O/t9nkMaBHILP5PtNmO3WVZKAR4CHWXIXmWkOsQf
	aC0rkEmIARkY3W7MVin0cpof659t1VG8oTaoAvZmr0r84YwrmAd2KgWlaozJJDLLXd8Q9Pn76D6
	a8aGtS0xD1+J4X87FuvmbQc4s4It+CVXbPZahP/lKczP0F1wFQskv60Lj09Vyqk3vGf8Dad184/
	WCBrw9TFB5pO2hSP9iwiUWw261IF7QfpYXtAOWJyvO4ssm4d6LtdcjDuDhdUPnAU68H/98v4QTo
	L0pV+eNdhPaENtomqgeQMinXQ2AuNIrHmlIIS8Ie7A4aJ2K23h8
X-Received: by 2002:a17:903:1106:b0:2d7:1a3f:8db5 with SMTP id d9443c01a7336-2d74e0c729bmr155654705ad.4.1788064190386;
        Sat, 29 Aug 2026 21:29:50 -0700 (PDT)
Received: from o6.lan ([188.253.112.231])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d8f98d46casm7493535ad.83.2026.08.29.21.29.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Aug 2026 21:29:50 -0700 (PDT)
From: Xueyuan Chen <xueyuan.chen21@gmail.com>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	zhaonanzhe@xiaomi.com,
	baohua@kernel.org,
	hannes@cmpxchg.org,
	ryncsn@gmail.com,
	youngjun.park@lge.com,
	baolin.wang@linux.alibaba.com,
	hughd@google.com,
	chrisl@kernel.org,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	baoquan.he@linux.dev,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	david@kernel.org,
	ljs@kernel.org,
	xueyuan.chen21@gmail.com
Subject: [PATCH v7 4/4] mm/shmem: split large folios only on -E2BIG
Date: Sun, 30 Aug 2026 12:29:20 +0800
Message-ID: <20260830042920.2280454-5-xueyuan.chen21@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260830042920.2280454-1-xueyuan.chen21@gmail.com>
References: <20260830042920.2280454-1-xueyuan.chen21@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: oc359dpwi5wijhfgibcutrbipim39a8c
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A007440002
X-Rspam-User: 
X-HE-Tag: 1788064191-577247
X-HE-Meta: U2FsdGVkX1/blOILigSXRgR+4hgBuPz+tfWUReBve/EwlBklotO5Ai5pUPL7yG+7tePNJXBhAmGaEIL6Lx+RGou+b6+d6H+ngNkNn59k+/G+RdqQ9qPA4Ub2wnGbNZ1IO4iXCvVVV+zuu4fUz5m4OOPG6dxKhDZkME6X0gPwHybSN+n0gR0/DKMw6UMq79q7ANjHRYusM7Peu50eVGTX3OukqJzFWDPgf9kLkE7o7Gc7gNxEpqUbaGeWzRh2hH4h8n17EPJoJpiw0372b47NAPe4UtfrFsRWc5emcj1+V/ICeXOR48jSSZgMuAQrDEUvNkSk3+aF9ZF6ZyLAhisRvCshUsnADetZUrdm5UYfj8J/2+dFf6FvxE5jnwgILTH9XomedCi2QZ91Z7U2kOi2WUKDuWau6E+mvhGZpjiQt5JT+HnnS6VHDFiqw1QCq4mXyjPxvkvgze+pffvfLNxTSzdWukCrSW32Tw+bRclC23cU4xgbGl+m73nOtwzfwdmpKHhPZF94Cm7gkvmHjcEbDnYpffaSHsIyQQn5+9jfIXuVUcKhvpc6bjfoC/opu5gqUPX1hbYNtiElkTdlEpX87VvmujkhyqxwKAqtoMUqW2HHT6qZsMpkt2ALr89GWuQ4v/H2Ctcd+wqY3W2BCgqX63KZ8olWhcGo2w6vv8CEds2UWoktHsQCzMVT4GHB/0Y5CCotGN3SZjKEpexFdwFTSKZVlaNg5tv1HLTF5JK4sw4KGqRilkVwFVD+1kMYhLKsiGfI7ApoeuEaovkfhpphDWQS9r1/G/zTseFrI42VUw7PXapsttYb5d6+m12iV2vwkafrGcMVVGcGejylF538wBrDIA9p0C3xTrzvU9Wjn37gi1aaytNub/qOfokVCOyMMmcrqd5+8VzZDvd77LfCww5koiAZJMppTN08o+qX4D+J79I63VzthubDMDv/17/Uh4tr5m3Xjp3oXFQgmOo
 ZxDk8ojm
 HJeWpgE4OXJLzIsIplIFzS4KzcekqQKkxxk8PZsaQpMN/3yu5vVRnZV8FHglOkTRHbSQxhM15/8dXq0z3d8drUU0pJarbvSZonZO9Mf4EtHXmS1qy0HiLu4oRwt+nPyVTYyGw0Qc/y0XosOML/H1MHgkbN+nKhDAeLguWKZJ6wrtLh9Q2E3vKYoIu5UKtKEi9+JfaOj8qzns3fMYs4+BZ7aL4kKLJl+Z1DyrIbR13oStLjF5L63jVkV6zZCV5U8HVBe1n6Pc2GBFIlAECyVRnZc+pdFwCed4iWkrQxDF16ItAP4D4QuFI2Ol/irjitcGjpcUWNbArZ5nkDVJN+dX9FFpzfsRHLve0zgki10xW6PY/a7CexF9TZgFkvhSX/Q5Zp1sGThETlGLNohxO6WoXh0AS++xpla6jxJgbPWJ1llR5dvZJwZnGGp0/e/UEE+wjjUXXpUVOwBNK07DlKgc+oFDcwT474VhW706K+VnLZY0Pns7czSrgzXf8z764jV2h1wuLlnSXiO7s7Azw/iAoqb02OI3MdKvYF27G
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

shmem_writeout() currently splits a large folio on every
folio_alloc_swap() failure. With the refined return-value contract, only
-E2BIG indicates that splitting might allow smaller folios to be swapped
out.

Enter the split fallback only for -E2BIG. For -ENOSPC and -ENOMEM,
redirty and reactivate the folio as before.

Suggested-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Barry Song <baohua@kernel.org>
---
 mm/shmem.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 6641823bed16..eff38bb33d8a 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1608,7 +1608,7 @@ int shmem_writeout(struct swap_io_ctx *ctx, struct folio *folio,
 	struct shmem_inode_info *info = SHMEM_I(inode);
 	struct shmem_sb_info *sbinfo = SHMEM_SB(inode->i_sb);
 	pgoff_t index;
-	int nr_pages;
+	int nr_pages, ret;
 	bool split = false;
 
 	if ((info->flags & SHMEM_F_LOCKED) || sbinfo->noswap)
@@ -1689,7 +1689,8 @@ int shmem_writeout(struct swap_io_ctx *ctx, struct folio *folio,
 		folio_mark_uptodate(folio);
 	}
 
-	if (!folio_alloc_swap(folio)) {
+	ret = folio_alloc_swap(folio);
+	if (!ret) {
 		bool first_swapped = shmem_recalc_inode(inode, 0, nr_pages);
 		int error;
 
@@ -1742,7 +1743,7 @@ int shmem_writeout(struct swap_io_ctx *ctx, struct folio *folio,
 		swap_cache_del_folio(folio);
 		goto redirty;
 	}
-	if (nr_pages > 1)
+	if (nr_pages > 1 && ret == -E2BIG)
 		goto try_split;
 redirty:
 	folio_mark_dirty(folio);
-- 
2.47.3


