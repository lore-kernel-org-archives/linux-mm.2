Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39BB0EDEC17
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 07:01:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 86B956B008C; Wed,  4 Mar 2026 02:01:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 80EFA6B0092; Wed,  4 Mar 2026 02:01:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BA946B0093; Wed,  4 Mar 2026 02:01:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5BEAC6B008C
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 02:01:26 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F18885632E
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 07:01:25 +0000 (UTC)
X-FDA: 84507484530.26.D79AEE3
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf05.hostedemail.com (Postfix) with ESMTP id 4EDC0100003
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 07:01:24 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qnUA21TJ;
	spf=pass (imf05.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772607684;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6lKswuYjrEG3QAg8jJw50bc3/7q3XegD5lJITgw3CtU=;
	b=ftXqOIUXg6Mv7tRSYWTy1GJmnG0TiufCHeCSff9S+gC7lAAC5qXyBFfsrQDjuJ6SXPP7ld
	ZKqbR/M5u5GW1NigAIsvgMw2CnN9n6L5EkR1ofcYSKsJsTAtVSdd+d9Ejk0ZgSYw3Nzphd
	wLkOJ5b+zttj93RHLPHOkOjEfiUQDh4=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qnUA21TJ;
	spf=pass (imf05.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772607684; a=rsa-sha256;
	cv=none;
	b=8a6xzeb5zNM12+bs6dHbw4157nQ7A6yG/MC0MfH1ZV002FTTYiEUag+ChF+79+YeDWC37b
	vOkZu7Go7DImwglv3WzUEG70HZzl8vTK3keNMLXsFXXeGUUFbirXnM2NuwuKuqDL2AGbmk
	rqnndzgRmoUgTkojE4+KCZyeTRFM+ic=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772607682;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6lKswuYjrEG3QAg8jJw50bc3/7q3XegD5lJITgw3CtU=;
	b=qnUA21TJ2rTRiaEbYo+xhiz5/GeumGiXdRlOH6B9YZ9GCCOZ95NliCgzxBiUozKopHqWLO
	yv/VXUU0oqR5hWcAsbwyqoDaCi0iUJcUnXs2w2K9gn+SeWOCcCZKhOK6Xe+Or+K/rtwj2v
	mxEpBj7FsRwDHaQ+9b9z1sPBo3E9f00=
From: Hui Zhu <hui.zhu@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Hui Zhu <zhuhui@kylinos.cn>
Subject: [PATCH mm-unstable 2/2] mm/mmap: fix NULL pointer dereference in dup_mmap() error handling
Date: Wed,  4 Mar 2026 15:00:57 +0800
Message-ID: <6dc840b8dc7da9f56787e7a353c633b3c12eda6a.1772607155.git.zhuhui@kylinos.cn>
In-Reply-To: <cover.1772607155.git.zhuhui@kylinos.cn>
References: <cover.1772607155.git.zhuhui@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 4EDC0100003
X-Stat-Signature: 8rrdrk5goopo96i6afgk16r6y33jtn4x
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1772607684-141340
X-HE-Meta: U2FsdGVkX1+4nUDgxvfnJyf8QqbgIubUI2XkMmvojNwamzUmT0WhTbX6HT3pnCus4aVR2IMdjDQjleN0/m1WjrKb33n37G4be7t8Phh4hi+yaGl1mjJKuNzBEMnQT0djA8IFbWgmLdWHRJFHR9+Z97Eqr+ePTFK0IgHSJvaJ+aJmO5CMPEu9/OoTvEYeS1QFPY9TJQRRqJeGEp0jxPZSof7XaGthkyFNwTt/ueOtlw9NnT5dWZ8NCZ6SPEGYs6gV8eiDllEFDp7+OfCjbHQSrwVJTucUdGdyFtLitTocMu8U5jQp8ZyJUWkBgSCDagUSdaJ7cI0mSGwbr5paxgLhEyk9Lv2AyylAeDcUh54hN9UTE5LeQxsNscJfNP5BYK0TXndyWBBssxBBx0dkopjHXUUQ+yPuLfxQzNktoIXBt8HS6VVPYBrfakzCccG49ywqlgwAB0cdQIlCrJrJbDtopCn37L59UVv4D/RDJORIjRuKldyOjw0yBLX9FCVSCyOOZfaZztigZdkSgtsvm8wBK4bvfZy/1zBmy1xF9GCkbNqggy6FA9jBj7F62pIbIqHlIiOiiMHHnQWqtBBveIRlTJvlkmLP/m7eCf08iUvY90HwYnbkij92Os89cR0DBIP5XrvyJNKwMbMRDZtkWFOdl0QyTzchY4SRgM8jY9sQhdwN+B1e8EArPXoK+aBw3uTULNOQPu8kJ6noVs5/DbTlUL9wpVyPSEmH7vst5s4VAovOzJ/VmmBA3i74ZT03fym7f788SH4EzBfysT5Khi+YwzIzbmLGps621L5L21iXvxeOT4Xj0UILn+P9amWk9bkdyf1BGUxbdj+pP+Y6iPBdINtuFsrStjurCW56KJfgb9pW+nzWS0oiSQQqRpPPIsc3FU9p68g/ix1OCzcfBfQoBaS8DpvFrjVfhhtyQ33FOJlt9j6raY0yyu/+jrobmYbIwhC/w/Kxg5yrVsCCSt3
 lHnj45zl
 B/xGTnsDG1aLY0iA7eZciZa7513hD1TKT4/DQ1hqHexKd7PcDH+wuf71Zzllfp0I9qRyBeqnq/+ES5ZpMiS9lhYtbpkGhDKml1sC3V+5PdSkx4gMxrWh8VxzXO/V+9EqPPKDpq/LoVxKf+7vZz3Px44WnWTkiIMMI4z4UCPpq7ZfiOKKWucDDpNTXZnmBtnpwh4uURDQdJeUC2WU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hui Zhu <zhuhui@kylinos.cn>

If dup_mmap() fails very early in its execution, it's possible that
no VMAs have been inserted into the new mm's maple tree. When
vma_next() is called in the cleanup block to retrieve the first
VMA ('tmp'), it may return NULL.

The UNMAP_STATE macro and the subsequent call to tear_down_vmas()
do not perform a NULL check on 'tmp' and directly attempt to
access its fields (such as tmp->vm_end). This results in a
NULL pointer dereference and a kernel panic.

This patch adds an explicit NULL check for 'tmp' before proceeding
with the unmap and tear down logic in the failure path of dup_mmap().

Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
---
 mm/mmap.c | 31 ++++++++++++++++++-------------
 1 file changed, 18 insertions(+), 13 deletions(-)

diff --git a/mm/mmap.c b/mm/mmap.c
index 498c88a54a36..ca5645a2e456 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1879,19 +1879,24 @@ __latent_entropy int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm)
 		if (end) {
 			vma_iter_set(&vmi, 0);
 			tmp = vma_next(&vmi);
-			UNMAP_STATE(unmap, &vmi, /* first = */ tmp,
-				    /* vma_start = */ 0, /* vma_end = */ end,
-				    /* prev = */ NULL, /* next = */ NULL);
-
-			/*
-			 * Don't iterate over vmas beyond the failure point for
-			 * both unmap_vma() and free_pgtables().
-			 */
-			unmap.tree_end = end;
-			flush_cache_mm(mm);
-			unmap_region(&unmap);
-			charge = tear_down_vmas(mm, &vmi, tmp, end);
-			vm_unacct_memory(charge);
+			if (tmp) {
+				UNMAP_STATE(unmap, &vmi,
+					    /* first = */ tmp,
+					    /* vma_start = */ 0,
+					    /* vma_end = */ end,
+					    /* prev = */ NULL,
+					    /* next = */ NULL);
+
+				/*
+				 * Don't iterate over vmas beyond the failure point for
+				 * both unmap_vma() and free_pgtables().
+				 */
+				unmap.tree_end = end;
+				flush_cache_mm(mm);
+				unmap_region(&unmap);
+				charge = tear_down_vmas(mm, &vmi, tmp, end);
+				vm_unacct_memory(charge);
+			}
 		}
 		vma_iter_free(&vmi);
 		__mt_destroy(&mm->mm_mt);
-- 
2.43.0


