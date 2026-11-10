Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FFDF606A321
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 15:11:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UJKOM5j/
Received: by kanga.kvack.org (Postfix)
	id 944E46B05B7; Tue, 10 Nov 2026 10:10:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F5D66B05B8; Tue, 10 Nov 2026 10:10:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E5A36B05B9; Tue, 10 Nov 2026 10:10:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 527746B05B7
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 10:10:59 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E641E1408F6
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 15:10:58 +0000 (UTC)
X-FDA: 85419546996.02.1275449
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id EAD6E20004
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 15:10:56 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="UJKOM5j/";
	spf=pass (imf31.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794323457;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=D9yxkaw6ZrAXW+SO4mJkooT0uzl2j90D+9HSPrIHqSc=;
	b=B1ca2+lYK/rfO43hMNWuy2ZKGE6Oc2oG6jTA4+8GTcLaUM1fsEfQt360BzaxYRmsTCmIg/
	c+FrFYSzW2RZsrQPq7b/fv4DYRVziYeE8t0ajlyITpgblGr7dbrPjFSRzb7XATkN+Svfnh
	d+Y3bD55pVhc2arRVag6E6DZeeKisLA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794323457;
	b=eAj041Yty7ypOM2SpTqRISvlzL8uQXfTJJaGlqsxFbMcHe0b9Sp7aeoRaSp9KrCtKB1X3P
	0bQAGsS6eQ+sQ9q2F/CyMUKCsgAZqxgDS8ucuKf/xO2xMpKRgDhyBKoba+g/opgIkyUdAv
	Nls9U6l/kY1CWcoTMiylap0V1q+CIeg=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="UJKOM5j/";
	spf=pass (imf31.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 11B2F40503;
	Tue, 10 Nov 2026 15:10:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A52E21F0089F;
	Tue, 10 Nov 2026 15:10:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794323455;
	bh=D9yxkaw6ZrAXW+SO4mJkooT0uzl2j90D+9HSPrIHqSc=;
	h=From:Date:Subject:To:Cc;
	b=UJKOM5j/qfm9UA57rKmDJPywu+1MpnR7psxvF5MztxtwTBfjw76xrroP/gApZ26Zl
	 y+r6pEJIi7KQUnYtCM9GBAXco3ArXjQsPj7mq/NA9jRJ1/XZ3DfLNy3ds5+mXP8EBI
	 4yU5SG0sqd3JiOOJXkVJTN4Q+YCKw92IOPVcCADPeekqQjyafEsYPIeMe09a7v9UuR
	 7NzdR9uKtAmXZFLBbzm/sJhye6QjkVFoCdVhd3dxpFfvnY4Nv1OtEblDhjjzIzsAip
	 rc57LzeqfPg1oijt9gK4fa5MI9S52bhM+3B3BQe3TjHv/7VXVY4Rr7lUBm0/GhdYlM
	 MJIQpsIIKoz3g==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 10 Nov 2026 15:10:40 +0000
Subject: [PATCH] mm/vma: predicate vma_assert_stabilised() on
 CONFIG_DEBUG_VM
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261110-vma-fixup-debug-asserts-v1-1-0b2e0680cd7e@kernel.org>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/x2MSwqAMAwFr1KyNmArqHgVcVFt1Cz80NgiiHc3u
 HiLgTfzgFBkEujMA5EyCx+7gi0MTKvfF0IOyuBKV1trS8ybx5nvdGKgMS3oRQuXoAuVa2bStRO
 ofUbS21/uh/f9AOziYEdpAAAA
X-Change-ID: 20261110-vma-fixup-debug-asserts-2d327fe27f8c
To: Andrew Morton <akpm@linux-foundation.org>, 
 Suren Baghdasaryan <surenb@google.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, Lance Yang <lance.yang@linux.dev>, 
 "David Hildenbrand (Arm)" <david@kernel.org>, 
 "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, ljs@kernel.org, 
 Seunghyun An <san55@wisc.edu>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=3945; i=ljs@kernel.org;
 h=from:subject:message-id; bh=AjcoNBiXFjIr7zMwvTj45YNXUEW6Apq5OgXBX+VmZYQ=;
 b=kA0DAAoWz53NioHifxQByyZiAGrzM/yj/skJHnNSO9mo71dlXgNJiR357l9zRUrXoubw0APA3
 oh1BAAWCgAdFiEE5/QXv1IUVp6J0E9Gz53NioHifxQFAmrzM/wACgkQz53NioHifxT8yAEA0uwi
 mJOl7OZnM8yK+AUWEki7eb4lfSoCOVwQ2e+hrNIA+gKxTYPd93zkwj9lOKOXvw/H+brUbalFZnG
 uVh7J4eQL
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Stat-Signature: eojkugufoabp4u9rosibw6i3tqdsybyu
X-Rspamd-Queue-Id: EAD6E20004
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794323456-987444
X-HE-Meta: U2FsdGVkX1/2ccV34EqHBVMxZ++L8vsijVaAHZWbqskVfBojV7rHVCiWzMFeLlbalU2i9QvLF4dVTXHLmeLzthrY73TcJEfeTXb1Q+CpPx9HjWsVyGe339DljmwquvsKDam35D+MIqUuE6EA2bUqG3egIWa/kXv+YxVX9lkKl51ddoRzfp0blvKVHxeVOUsD9El/CW1CN38UKDdnB0+MIUZ1mhTcn6ovgSRd15embW6hntb+GAosbUqxTiVDQDCcDCpB2nw1CxTP0iXz+RnsvrMfrSp3cDrKaX0aadQJDtxoy6OnUF5GZVE4dk08I+jraSi9B0KatDzhW7eLRED5pY8FXqVXtWuFolo0z+U9VauNyJSVUBduW2X6tGGe+tokmOfSZPRlASscrRQGOVmCT0M2ZJhqRcwJ56qFi3moEXKD1oXcyzVIa0wjg/AzufPVCcSQUM3VkhzcAZHfd2xqXVkxMe7O9PpgBHauwgUMSUuyxU49JBZmSjFzj3XQhHhLMBOWKP3mRX2h+xN+QJjBA/KmM2StbfXUfsNU8cooEa/c9ArumtvKbIkHK3ccqHOn2vN4jft7fHHIntDolHJ8pC4GSwXW1KZoUqQzlsLFx4jgggKpzjiK/KV1k6LV5wKXZxeYYv+2QLF59K5X4L/8qTT9JY7C4R+rLlJK921eRy18d9QHSYMwhSFvxR/GJU8NsqqoyoAooDWsyZrSVenYSGTSvycd5FNtQEoB27bnifhizoRB+VmVOtCfwk6Qjfgq91oaN3JpqM3Oi7KZv50EJfqJfD7gDZ7cO0D2JQPadubBrM/TT7bd4ZzHZyXr+SSbiZLWq+7WAp9bOiKzTl11MK/+pxiu1m2jquJJYKa9FYRlGOud8a//ATvNtuD5T0cr4A5Yam+xrTODPP9pFhaabKQ8QQGnkff4XtegpMfwrD5ltJvcSTwPZ8MCaHKRi8Zc3OTnGPoG5MPSBahUL0w
 bYRvH8jc
 0IOhZrqVsjONRzdby9Q1+wqE2KdHCvR1LCRb1sRHEe/kqTSgGrjZC6J45wl0OnDkC3RQuKBzp+PSBl+HMvIUcd6389HHtupq09q7SA3WYs2h54JsQs5VDwXskeffAeJTLmB40G53V1vb0lZnSvWZhSiDdUQk5YvPpdJwYGJ16ktKoR/H5bF8+o92yEiAvW4JLqCPBLffUjgscAD99dGRIcCuea1YVxIKGJjcXkNkvR3hXG3P1+S25OPi4dYAGj2ylsydAZMLCiDXOm6FbibMkAm+ayMrLQjVhbXg5Uy137WZvOCg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

I introduced commit 17fd82c3abe0 ("mm/vma: add and use
vma_assert_stabilised()") with the intent of picking up programmatic bugs
when debugging mm code, but kept the general practice of asserting even
when CONFIG_DEBUG_VM is not set in line with existing code.

However, it turns out doing so can cause performance regressions,
especially when asserted in vma_has_anon_rmap() which is referenced in a
number of hotpaths.

Since the intent was always a debug-only assertion, explicitly check for
CONFIG_DEBUG_VM and do not assert if it isn't set.

Really all of the assert paths need to be predicated on this, but start
with this one only, out of caution.

Additionally, since a detached VMA is trivially stabilised (nothing to
stabilise against), check for this case at the outset, and update
vma_has_anon_rmap() to not explicitly need to check for this.

This also, importantly, avoids reading any VMA fields if CONFIG_DEBUG_VM is
not set.

Target the commit which introduced vma_has_anon_rmap() for the fix, as this
is where the issue started manifesting in practice.

Fixes: 38564710f443 ("mm: implement and use vma_has_anon_rmap(), silence KCSAN")
Reported-by: Seunghyun An <san55@wisc.edu>
Closes: https://lore.kernel.org/linux-mm/20261110000002.1834454-1-san55@wisc.edu/
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
Note that vma_is_anon_rmap() was introduced in 7.4, so no need for a cc: stable,
just needs to be sent to Linus as a hotfix. Thanks!
---
 include/linux/mmap_lock.h | 19 ++++++++++++++-----
 mm/vma.h                  |  3 +--
 2 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
index 9ccbbcbd7aca..9c3a9c6525c1 100644
--- a/include/linux/mmap_lock.h
+++ b/include/linux/mmap_lock.h
@@ -408,6 +408,11 @@ static inline void vma_assert_locked(const struct vm_area_struct *vma)
 	vma_assert_write_locked(vma);
 }
 
+static inline bool vma_is_attached(const struct vm_area_struct *vma)
+{
+	return refcount_read(&vma->vm_refcnt);
+}
+
 /**
  * vma_assert_stabilised() - assert that this VMA cannot be changed from
  * underneath us either by having a VMA or mmap lock held.
@@ -418,9 +423,18 @@ static inline void vma_assert_locked(const struct vm_area_struct *vma)
  *
  * With lockdep disabled we may sometimes race with other threads acquiring the
  * mmap read lock simultaneous with our VMA read lock.
+ *
+ * Assert only if CONFIG_DEBUG_VM is set.
  */
 static inline void vma_assert_stabilised(const struct vm_area_struct *vma)
 {
+	if (!IS_ENABLED(CONFIG_DEBUG_VM))
+		return;
+
+	/* Detached VMAs are trivially stabilised. */
+	if (!vma_is_attached(vma))
+		return;
+
 	/*
 	 * If another thread owns an mmap lock, it may go away at any time, and
 	 * thus is no guarantee of stability.
@@ -454,11 +468,6 @@ static inline void vma_assert_stabilised(const struct vm_area_struct *vma)
 	vma_assert_locked(vma);
 }
 
-static inline bool vma_is_attached(const struct vm_area_struct *vma)
-{
-	return refcount_read(&vma->vm_refcnt);
-}
-
 /*
  * WARNING: to avoid racing with vma_mark_attached()/vma_mark_detached(), these
  * assertions should be made either under mmap_write_lock or when the object
diff --git a/mm/vma.h b/mm/vma.h
index 3fc3b47a954b..05300badd70b 100644
--- a/mm/vma.h
+++ b/mm/vma.h
@@ -278,8 +278,7 @@ static inline pgoff_t vmg_end_pgoff(const struct vma_merge_struct *vmg)
  */
 static inline bool vma_has_anon_rmap(const struct vm_area_struct *vma)
 {
-	if (vma_is_attached(vma))
-		vma_assert_stabilised(vma);
+	vma_assert_stabilised(vma);
 	/* KCSAN gets confused about the optimistic check. Silence it. */
 	return data_race(vma->anon_vma);
 }

---
base-commit: 93d7a816a2df3e907e2719bd12b0073f1285fc5c
change-id: 20261110-vma-fixup-debug-asserts-2d327fe27f8c

Cheers,
-- 
Lorenzo Stoakes (ARM) <ljs@kernel.org>


