Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB827C88E4C
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 08:12:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E78B66B0099; Fri, 11 Sep 2026 04:12:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E423D6B009E; Fri, 11 Sep 2026 04:12:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D663E6B009F; Fri, 11 Sep 2026 04:12:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BB2216B0099
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 04:12:23 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5F63CA1BC3
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 08:12:23 +0000 (UTC)
X-FDA: 85200764166.11.24DB054
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.35])
	by imf12.hostedemail.com (Postfix) with ESMTP id B67904000C
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 08:12:19 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=none;
	spf=pass (imf12.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789114341;
	b=IJJCBJQhc6/L0+s/IgAZd97YU/O8cu6a+EjH7WX19LNUHMu31maH6ugAiTq+JNmcAlhTTX
	dj/5q6HQ1LRtCYmuf2E2Vb6L3nStK9vbc6GooVTu6wd9ZwnGj6EI4KNwaPDVsS36DP9vyF
	3GWJ3TYdfxtAgGd5g3dsl8k/zoPXdm8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	spf=pass (imf12.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789114341;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=O6OgdWGOHw1gQdJJTT1BRqPW9nFEQbKXIHGoPFFpVhU=;
	b=HHBbnQOm9Xn6Ov3/5x8RlydggiHdiwwxZB0wmrLSdlcgypF8G5Ngg2S4JJaDkvZ8o9CxhC
	TyIQBOI7VCXzGl9RR0EX1BJ1bGwt8mvD95Ws+/yIscjkHjM+DycLV6EFaF0RMUKzoFJg5x
	f6URkQ6tVtlmLOnUK1rlmnFeaXDEYxg=
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4hh6hx5Fzxz8XrrX;
	Fri, 11 Sep 2026 16:12:17 +0800 (CST)
Received: from xaxapp04.zte.com.cn ([10.99.98.157])
	by mse-fl2.zte.com.cn with SMTP id 68B8C7Bo036013;
	Fri, 11 Sep 2026 16:12:08 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp01[null])
	by mapi (Zmail) with MAPI id mid32;
	Fri, 11 Sep 2026 16:12:10 +0800 (CST)
X-Zmail-TransId: 2af96aa3b7da071-c2054
X-Mailer: Zmail v1.0
Message-ID: <20260911161210082WKOqK1dumByDY7jeEOdPF@zte.com.cn>
In-Reply-To: <20260911160421076_KNXun8Mpp9Xj7fxHG0i7@zte.com.cn>
References: 20260911160421076_KNXun8Mpp9Xj7fxHG0i7@zte.com.cn
Date: Fri, 11 Sep 2026 16:12:10 +0800 (CST)
Mime-Version: 1.0
From: <xu.xin16@zte.com.cn>
To: <akpm@linux-foundation.org>, <david@kernel.org>, <ljs@kernel.org>,
        <surenb@google.com>
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <chengming.zhou@linux.dev>
Subject: =?UTF-8?B?W1BBVENIIDMvNF0gbW0va3NtOiBtYWtlIGJyZWFrX2tzbSgpIG1vcmUgc2NhbGFibGU=?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl2.zte.com.cn 68B8C7Bo036013
X-TLS: YES
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SOURCE-IP: 10.5.228.133 unknown Fri, 11 Sep 2026 16:12:17 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6AA3B7E1.000/4hh6hx5Fzxz8XrrX
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B67904000C
X-Stat-Signature: 1uyqab9mxrprnjxa5dnzf5u8uxydjoym
X-HE-Tag: 1789114339-713524
X-HE-Meta: U2FsdGVkX19PiXm+ts6c1313CPi5dzH1VzLKBaGHJ/FOyir+SbqqNnXXdGNqRpv95dB6uqBobDJrlNJ70YYeFKFwdDOfqmCiTRZyQiTQ/9kY3UPnBseZ9j2GkO1OicQSfJ7hwkmEe7+EcHXOxjzPosk+x/0nsQFgCqlxDVAFVY58LM3S5YFKlwsIZK6Xu/a3sBE7kWdMWfKdWHxlqwTzf8fS8bfNIeJWHmReOQO17V/+LtCA1RRZ5rnyGvHoOdF1nI5cCW8kMsKfL10DDzH28Gtnqb0Yo5JR8pvdnnxGgu3n4NI4m0VnMyH7vqyR5wFSDcAEGffGaU8tqdI2OhAlshA0bXgHSI1g8knDC2s79P05ZIh+d9i9+8YVX7/fQ0ma7uBez5/7KD2GiUIoN632hM7nZRs6MXRyMv03qZiFQXTcVOF5T2Vj8zrrusXCzvLErcN+YjCp7IIRht3pyIPL9u5Iu7MdqJJAJ+AEyPJzNA8axYXdIoALGb5bxrwEK/5H+QOahQNDT1a0bGOsZFfE+29OSJg/REUTZQepx4vTkEgFKZI4x2TbBgVF3y3RnkLEjwBnTGiPugAgliJNquNgHokFCaOSr4AT4ZO+s0sjV/LM2oT+/Ax/3NKdFKDGfPPqQJo8Kd9shBGyCrohoUkVu+JPdFqOffHSWJnwZFefTU3zj9CjT/USVpqSD4M+CtNsWJR6xTl5ZgXai+s6JkTd8vRQPsBgDeuVVW3HM9AP4i6VzLG5asKngEMT63ffWZYxjUC2aLhgehGCu+Ev9LWJtMFnTUdYrLGHTkZZAf/FlnX+1zYKXPD+7k2dKSgHvcAUKj05219ZQnYZVyi/fwaLNWLSzwonH0XJ63Pagov6YpQvJGN/1WUu6qaoeSHCIYHqRAIFH4yREfU4eMe/pF4sw75Fd6c8P9xIuU0k+kd/ci4amtX876TytMRD30dUZBpwvEoYAakrke2Mis9nuA9
 2NvABu75
 BoeYyWjyQ9r0oLn2jefEGKKjXbk2z+Y8m0tc+jC8ZUQhWWf+STanlvVZzk2g5wQOdwNiaLaHH+OpxnpNP9DEnopCM8Dwndljce9446Bo/yPhIV6mkO0qmSr7e855sALtHAzibB5N9PwyxGb1wA4wESVhEwmpVhtxexrJCTlV6N4Ws4XjyNsP4kHRUEE02CHznuIxSLrHo6o67Uxw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Xu Xin (ZTE) <xu.xin@linux.dev>

Currently the last argument 'walk_lock' of break_ksm() is used to
indicate whether the page_walk is protected by mmap_read_lock or
mmap_write_lock. If 'walk_lock' is true, we suppose its context to
be under mmap_write_lock() protection, then mark it PGWALK_WRLOCK and
make its vma be write-locked during the walk; If 'walk_lock' is
false, we suppose its context to be mmap_read_lock(), then mark it
PGWALK_RDLOCK.

This change is prepared for the latter patch to enable VMA
read-locking where break_ksm() might be under the third new proctecion
way: VMA read-locking, so we have to replace the boolean variable to
the enum 'page_walk_lock', but without any function changed.

No functional change intended.

Signed-off-by: Xu Xin (ZTE) <xu.xin@linux.dev>
---
 mm/ksm.c | 21 ++++++++-------------
 1 file changed, 8 insertions(+), 13 deletions(-)

diff --git a/mm/ksm.c b/mm/ksm.c
index 8df66b4e5de0..dda105681d7f 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -660,16 +660,11 @@ static int break_ksm_pmd_entry(pmd_t *pmdp, unsigned long addr, unsigned long en
 	return found;
 }

-static const struct mm_walk_ops break_ksm_ops = {
+static struct mm_walk_ops break_ksm_ops = {
 	.pmd_entry = break_ksm_pmd_entry,
 	.walk_lock = PGWALK_RDLOCK,
 };

-static const struct mm_walk_ops break_ksm_lock_vma_ops = {
-	.pmd_entry = break_ksm_pmd_entry,
-	.walk_lock = PGWALK_WRLOCK,
-};
-
 /*
  * Though it's very tempting to unmerge rmap_items from stable tree rather
  * than check every pte of a given vma, the locking doesn't quite work for
@@ -696,11 +691,11 @@ static const struct mm_walk_ops break_ksm_lock_vma_ops = {
  * protection keys here anyway.
  */
 static int break_ksm(struct vm_area_struct *vma, unsigned long addr,
-		unsigned long end, bool lock_vma)
+		unsigned long end, enum page_walk_lock walk_lock)
 {
 	vm_fault_t ret = 0;
-	const struct mm_walk_ops *ops = lock_vma ?
-				&break_ksm_lock_vma_ops : &break_ksm_ops;
+	struct mm_walk_ops *ops = &break_ksm_ops;
+	ops->walk_lock = walk_lock;

 	do {
 		int ksm_page;
@@ -807,7 +802,7 @@ static void break_cow(struct ksm_rmap_item *rmap_item)
 	mmap_read_lock(mm);
 	vma = find_mergeable_vma(mm, addr);
 	if (vma)
-		break_ksm(vma, addr, addr + PAGE_SIZE, false);
+		break_ksm(vma, addr, addr + PAGE_SIZE, PGWALK_RDLOCK);
 	mmap_read_unlock(mm);
 }

@@ -1245,7 +1240,7 @@ static int unmerge_and_remove_all_rmap_items(void)
 		for_each_vma(vmi, vma) {
 			if (!(vma->vm_flags & VM_MERGEABLE) || !vma->anon_vma)
 				continue;
-			err = break_ksm(vma, vma->vm_start, vma->vm_end, false);
+			err = break_ksm(vma, vma->vm_start, vma->vm_end, PGWALK_RDLOCK);
 			if (err)
 				goto error;
 		}
@@ -2885,7 +2880,7 @@ static int __ksm_del_vma(struct vm_area_struct *vma)
 		return 0;

 	if (vma->anon_vma) {
-		err = break_ksm(vma, vma->vm_start, vma->vm_end, true);
+		err = break_ksm(vma, vma->vm_start, vma->vm_end, PGWALK_WRLOCK);
 		if (err)
 			return err;
 	}
@@ -3037,7 +3032,7 @@ int ksm_madvise(struct vm_area_struct *vma, unsigned long start,
 			return 0;		/* just ignore the advice */

 		if (vma->anon_vma) {
-			err = break_ksm(vma, start, end, true);
+			err = break_ksm(vma, start, end, PGWALK_WRLOCK);
 			if (err)
 				return err;
 		}
-- 
2.25.1

