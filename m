Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC65FC43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 22:13:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 26B916B0093; Wed,  8 Jul 2026 18:12:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21BB56B0092; Wed,  8 Jul 2026 18:12:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DDA026B0093; Wed,  8 Jul 2026 18:12:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A0B256B0092
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 18:12:57 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0906B1401DE
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 22:12:57 +0000 (UTC)
X-FDA: 84967010394.20.F74BDDA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 100D3180010
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 22:12:54 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MV3qXBxW;
	spf=pass (imf06.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783548775;
	b=QSK3IWrFMLnWvWErFhMbeLgA/G26Kq2igLrwN+blnO/l8nTWfqsujQ+lWhRkuMxNfREt7m
	DKO1QgXKnkyKVGvyGrY6F1uHo8GPZ1BLtPwxpa0wT07WwjM1xikSjh9pb1a1Wme5glDO2i
	M+CAZBoUZ5yd7kF9hlQNxYZG7xNozDU=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MV3qXBxW;
	spf=pass (imf06.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783548775;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9o0/FCDguLVduxZPu8zFEWBc+wT0F7pg+iuYkhQkq8c=;
	b=ZOko/HJqugbfhxF+znNWyZA78V1jkiCvni5Ou6amVKVD7ba6mtvhDn84WjFjFD5HRbY3Yh
	T6hElK83o+ExenML8l2sn+t5g2r7bTzQs74oz7gFSfQ9HnxQt3KYy3InOzdNqf3mzXaQc7
	UJWxhdyGn/gw6TZbBwJvnW+Fs/9GHdI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id EACEB40BBA;
	Wed,  8 Jul 2026 22:12:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C36BEC2BCC7;
	Wed,  8 Jul 2026 22:12:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1783548773;
	bh=eXsEHbluTYgc7Mz3d21k+gIlqNoyNr+3C2JAEcsRXmE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=MV3qXBxWwmiOTBsE+c1lHFSjDqrfTU+ljmCSKBsSiS2+M93IisMEW/VYNSMNROlV9
	 anZTcjtJ8zgWLH/1lYVpIeDDvFSwKH5ZsiM52EcuHKD76IQrwCNRdMq6MDXbVuG8Pp
	 oSF+6bO3ikXTyobQrKrBAJgPgz4Wz2tT01qx/Zpjgm1yXVEM//mwRDouP7kknyu0lX
	 MZrm9XuBQKWT73EmJqTi+Cy9hugYJKR6HFyCbPnW5ln1jCr8LK9VSIo25TX3DMSQWr
	 +5m/mGp74elvMbj0orQ5O60K4JCYOZ9qiMdZseJCMfJYr3b0JQszOKyciqeLUExswr
	 SKlGqsXBFQVlg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A702CC44501;
	Wed,  8 Jul 2026 22:12:53 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Wed, 08 Jul 2026 15:12:49 -0700
Subject: [PATCH v2 1/5] mm: hugetlb: Track used_hpages when getting/putting
 pages from subpool
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260708-hugetlb-alloc-failure-fixes-v2-1-c7f27cbb462b@google.com>
References: <20260708-hugetlb-alloc-failure-fixes-v2-0-c7f27cbb462b@google.com>
In-Reply-To: <20260708-hugetlb-alloc-failure-fixes-v2-0-c7f27cbb462b@google.com>
To: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 David Hildenbrand <david@kernel.org>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Nhat Pham <nphamcs@gmail.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Peter Xu <peterx@redhat.com>, 
 Wupeng Ma <mawupeng1@huawei.com>, fvdl@google.com, rientjes@google.com, 
 jthoughton@google.com
Cc: vannapurve@google.com, erdemaktas@google.com, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, Ackerley Tng <ackerleytng@google.com>, 
 stable@vger.kernel.org
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1783548773; l=6331;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=Qs4eCEk5U9LKKEAxFUKXDcH5Rd3MYbOxpQQpyCVKVJM=;
 b=PB/EsnDjFkR0V2Vg0gbj6SlXlDr09cVBrcs109h50qBtLspPgKcGqeqJCE56lt3SnXM5z0Itq
 LMqGdHf3patDG6iCECkmbw+lsy4uB87heVsS8npJX/6DVo7AY+URCUg
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 100D3180010
X-Stat-Signature: nb44wkpuyxkdajx583c44jcen8gw3i7j
X-HE-Tag: 1783548774-107423
X-HE-Meta: U2FsdGVkX18DeBdgKQ3e9pQ9VcJbdLVcdXQPR8Zut+qnINHmb60rmtmlYe3RnrIVB1wx55j9UMnueqDyk9iPxBfzki7AMZ22EPFdd5kFJe8ZEDvMndbmVVf8pTm3mcVFZlRgVQi25x+Xw7zEABGS5nJg7kBJKTHPlMehX9JSSXieT6Pi7W7i70+7Vqn4ljRe6peCXNHnfJrcNNrYTejFQgdTOF8Xun4TCMiBNAHj9DGB3fvKanARrK9Kw0r4dALhel8Kb2OCoqVSRZ8z6rA4JPsp9wKSJIDv2LFLlOGeIQOHq0gB+Os/toAUJSuV3EAn12fw+oFwBn39c2UKjSTgwI4WZeP9Ybot/cjccfkk7M50A8mHS3jz5fHBbE21S2PVnzWb9YN6Pwz3PMpo8/0yv5ZOuZjvWpx3cdllFKp2KZwe3gM+G7nNn9ISKyGaoQYiNk+5Jj95o9JJVrBABewQ/ci9iQQOCyR4PrI9LzqSWaYghxIz0Qa7XC4xcTar+NPGrrLmrzxZDwaUn9SEkmWAPbVcOtoygR8PGJ8ZCHoViIJjStdAO0J49rlAomNnYhmLKnzl+QubkJ/a3dZ4+C9A5u4v/miVz+9mmMUrDZ0dWth/MwJip+/yBgnscatXK2K0N5ntAEhP88JlxoiBbLgFMf2JqF0l21J4dRq/Kg/MTIyTyf3kGZ0MBUOCawkcFtKo3BnMe1OOSiO/Ne8YbunddSu3Thc2PKfH2bsr8K1H84LvY5OzsScuLehkhLoy8jU1DHHPwcPLebJ0qo0fT7LGPohGepUeikt+x7xqgBwx1vWvByccrp+KYf5rprmvRjo2shEp1RynCFRUPzrf0k1Pi1VPFkUJ6rw7PQssbxgPWf2A5RPFd70M/NxU+HV2z/Z26FgXfAaS3FMcfZxlBfmj1O2BDGl4wjNCnLblXwqwvwPEnOMrhyf4XBdvDbUNmel8nHJfgMv3ziMRDFYa28P
 bGNP7Ua3
 9hJxL3YxpJeycw+86n9x5EZekcdzAPlimeWl9Poa+vKPoRA3Ix5b9k299cTtePTLgt2l/zdALbeZyX/9LdYfkFxLwO4t2OyjMnHvb2EcaY9JUwd5A5R7trtL5gju5EYAWz6fOS+cSYmfFqF2AzGpR8VOoH0Fnf57QuSzzN1+n6fBrDS3a1kD4nEOkeSMmv2bwetpLluIpHoXCh+ZvxavEMiOdrQEfrzTuUdy8Fqb/aUMU6wRktIm7tIpvSl28PCou73JLfoGpBcMDiWLvFPBYQklPfeAcZt7J3GkpiqGa3gsnzaJ4ro5gLJcwn8hcOkUR7DwD69ffYoTHzOqUIE0NkO2sVBSJhueSgVobbzUBqmRDUiZWvL5mSnvkQpBhSF7kyGYMNQyGYqI/oVBY6XuqE8ObswXh5QfFhCBFEBB2sGZjF+Wnlnj6Lm1t/OSNdzWW4p7Yq+Q7UoKHJhxvgwX5Z6rgOAEY7kKzKCtymaV6oKenOgaULPqcDNGFYf1iCCK8d73kv04XnbuyKzpeBdDSIOVLmg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

hugepage_subpool_put_pages() currently has two distinct responsibilities
that conflict:

1. When size is specified for the mount, max_hpages != -1: Keep track of
   total active pages (allocated + reserved) and decrement this count
   (used_hpages) when a page is freed or allocation fails.
2. When min_size is specified for the mount, min_hpages != -1: Ensure we
   don't drop below the guaranteed minimum, and restore a reservation
   (rsv_hpages) if we do.

This causes trouble because when allocation fails (refer to
alloc_hugetlb_folio()) if gbl_chg = 1 (i.e. no subpool reservation was
taken):

+ To keep used_hpages consistent, HugeTLB needs to call
  hugepage_subpool_put_pages() to restore undo used_hpages being
  incremented
+ But can't call hugepage_subpool_put_pages() if no reservation was
  consumed.

One option would be to conditionally do subpool tracking updates outside of
the hugepage_subpool_put_pages() function, but that would spread logic all
over.

Instead, always track used_hpages, regardless of whether a max_size was
requested for the mount, so that the subpool always knows how many pages
were allocated through it. Every page allocated through the subpool
increments used_hpages, regardless of whether a reservation was taken from
it.

Conceptually, now, every allocation involving a subpool uses a page from
the subpool, which must be returned to the subpool. Every page taken from
the subpool tries to use a subpool reservation. Restoring a page to the
subpool reservations only if the page was taken from subpool
reservations. (If used_hpages >= min_hpages, the page must have not have
been taken from the reservations.)

Always tracking used_hpages provides the subpool with information of both
used and reserved counts to make the correct decision for both max_size and
min_size correctly.

With used_hpages always tracked, subpool_is_free() can be simplified, such
that the subpool can be declared free if there are no more pages in use.

Also update the documentation for used_hpages, since it no longer matters
whether the used pages count against the maximum.

Also update statfs reporting. Previously, if max_hpages is negative,
used_hpages is static at 0, so returning max_hpages - used_hpages returns
-1 and is always correct. Now, if the subpool doesn't have a maximum
requested size, indicate no limit for free pages (-1). If it does have a
maximum size, report the difference between the requested size and the
number of used pages. This difference is always positive, because if the
mount does have a maximum size, hugepage_subpool_get_pages() ensures that
the subpool usage never exceeds the maximum.

This fixes a bug in hugetlb_unreserve_pages(), where pages are returned to
the subpool regardless of whether it consumed a reservation. The
corresponding bug in the failure handling path of alloc_hugetlb_folio() was
fixed in a833a693a490e.

Fixes: 1c5ecae3a93fa ("hugetlbfs: add minimum size accounting to subpools")
Cc: stable@vger.kernel.org
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 fs/hugetlbfs/inode.c    |  8 ++++++--
 include/linux/hugetlb.h |  4 ++--
 mm/hugetlb.c            | 22 ++++++++--------------
 3 files changed, 16 insertions(+), 18 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 216e1a0dd0b23..26c0187340636 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -1109,8 +1109,12 @@ static int hugetlbfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 
 			spin_lock_irq(&sbinfo->spool->lock);
 			buf->f_blocks = sbinfo->spool->max_hpages;
-			free_pages = sbinfo->spool->max_hpages
-				- sbinfo->spool->used_hpages;
+			if (sbinfo->spool->max_hpages == -1) {
+				free_pages = -1;
+			} else {
+				free_pages = sbinfo->spool->max_hpages -
+					     sbinfo->spool->used_hpages;
+			}
 			buf->f_bavail = buf->f_bfree = free_pages;
 			spin_unlock_irq(&sbinfo->spool->lock);
 			buf->f_files = sbinfo->max_inodes;
diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 2abaf99321e90..34b9a3e1be0fa 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -38,8 +38,8 @@ struct hugepage_subpool {
 	spinlock_t lock;
 	long count;
 	long max_hpages;	/* Maximum huge pages or -1 if no maximum. */
-	long used_hpages;	/* Used count against maximum, includes */
-				/* both allocated and reserved pages. */
+	long used_hpages;	/* Used page count, includes both */
+				/* allocated and reserved pages. */
 	struct hstate *hstate;
 	long min_hpages;	/* Minimum huge pages or -1 if no minimum. */
 	long rsv_hpages;	/* Pages reserved against global pool to */
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 571212b80835e..ee5e99c1894b9 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -129,12 +129,8 @@ static inline bool subpool_is_free(struct hugepage_subpool *spool)
 {
 	if (spool->count)
 		return false;
-	if (spool->max_hpages != -1)
-		return spool->used_hpages == 0;
-	if (spool->min_hpages != -1)
-		return spool->rsv_hpages == spool->min_hpages;
 
-	return true;
+	return spool->used_hpages == 0;
 }
 
 static inline void unlock_or_release_subpool(struct hugepage_subpool *spool,
@@ -205,15 +201,14 @@ static long hugepage_subpool_get_pages(struct hugepage_subpool *spool,
 
 	spin_lock_irq(&spool->lock);
 
-	if (spool->max_hpages != -1) {		/* maximum size accounting */
-		if ((spool->used_hpages + delta) <= spool->max_hpages)
-			spool->used_hpages += delta;
-		else {
-			ret = -ENOMEM;
-			goto unlock_ret;
-		}
+	if (spool->max_hpages != -1 &&
+	    spool->used_hpages + delta > spool->max_hpages) {
+		ret = -ENOMEM;
+		goto unlock_ret;
 	}
 
+	spool->used_hpages += delta;
+
 	/* minimum size accounting */
 	if (spool->min_hpages != -1 && spool->rsv_hpages) {
 		if (delta > spool->rsv_hpages) {
@@ -251,8 +246,7 @@ static long hugepage_subpool_put_pages(struct hugepage_subpool *spool,
 
 	spin_lock_irqsave(&spool->lock, flags);
 
-	if (spool->max_hpages != -1)		/* maximum size accounting */
-		spool->used_hpages -= delta;
+	spool->used_hpages -= delta;
 
 	 /* minimum size accounting */
 	if (spool->min_hpages != -1 && spool->used_hpages < spool->min_hpages) {

-- 
2.55.0.795.g602f6c329a-goog



