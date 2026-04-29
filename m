Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CAF8CCCFA13
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 18:20:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 468366B0092; Wed, 29 Apr 2026 14:20:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 418C36B0093; Wed, 29 Apr 2026 14:20:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 308236B0095; Wed, 29 Apr 2026 14:20:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 158046B0092
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 14:20:05 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AEC844031F
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 18:20:04 +0000 (UTC)
X-FDA: 84712407528.25.B9C37D7
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by imf11.hostedemail.com (Postfix) with ESMTP id 8332740003
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 18:20:02 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=jj6MqtRv;
	spf=pass (imf11.hostedemail.com: domain of dave.hansen@linux.intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=dave.hansen@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777486802;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=7o7grmfzGQdgFilWbLuuN9xSK+lC7BY8b0t+YI5JG4M=;
	b=bDUzeUu5G5Mzf7ve2GssmgJQuziPcCTdSXPZfnZvz62lr4RMOEi/CsbebgqPNu6EyZAzI+
	XBr5hwDNvgNX4YwO+hglsOcblnGTzfdlYUw7hOX0ka2cVrWN/Wc77uLjgU7OWIocTi/8UA
	u2Sb/PT2nKoHEMVBGXHCNbuOcFpfptM=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=jj6MqtRv;
	spf=pass (imf11.hostedemail.com: domain of dave.hansen@linux.intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=dave.hansen@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777486802; a=rsa-sha256;
	cv=none;
	b=D0cpKRTuJ+6jd/dlag7j/lorHiLuc7mWeNJulbFLa75H3weejA1t+2QyTggxBLpmwWhId0
	2g1AIkhZcyZt29bNoOsKO/9absw3LDun0k6UqHZlBVaZEvyxHMyGIGOxvwlUYKX/x6dd6X
	RuqAUBebstT/P4JKbmCorTBsUx+sSJ8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777486803; x=1809022803;
  h=subject:to:cc:from:date:references:in-reply-to:
   message-id;
  bh=gAidwY/isSq9GwYadrcKVxfY5GsbxvEPZGfjDxsycxY=;
  b=jj6MqtRv1lBRjO0HtqWVzVsgrOGzTCauFk2vfax/gJftOiaBvOD2BS4V
   4PJSXVpCtXvtaZhmD4EQw3oZb+wpb/4lOe3aoYqlXldn4rhV/0MZe1iUB
   k5LWTbf+E0xGVCrx5T2v+TFhiDQhwvK5vlDtb9uSGTUFlF308KJy5s/9f
   WlCn8lLfHuAi0ShVkW6R1rRiJpvx9djIGgT9KhiHnzfTHL+viBDAzbVzJ
   ybemMA6arEIk1iMHyqWD7254TO+rLiPm5SLAeJR6DdocFVz2+jrn4v3iX
   EVx+iJV5QKp0sF4laYOATOYEjuKTR5Wce7edhVjIjEm+T3N+V2bzZYugC
   w==;
X-CSE-ConnectionGUID: VwDdd5FnQwa5wdcJpBbmqw==
X-CSE-MsgGUID: FeC3sgWjQ5yJ9WH6po+wQQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11771"; a="95990111"
X-IronPort-AV: E=Sophos;i="6.23,206,1770624000"; 
   d="scan'208";a="95990111"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2026 11:20:00 -0700
X-CSE-ConnectionGUID: WNjeZOkkRJuU6X+T+RGEcQ==
X-CSE-MsgGUID: 4rIFHkXPQNaEscpxqJpPfA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,206,1770624000"; 
   d="scan'208";a="239336402"
Received: from davehans-spike.ostc.intel.com (HELO localhost.localdomain) ([10.165.164.11])
  by fmviesa005.fm.intel.com with ESMTP; 29 Apr 2026 11:19:59 -0700
Subject: [PATCH 3/6] mm: Add RCU-based VMA lookup that waits for writers
To: linux-kernel@vger.kernel.org
Cc: Dave Hansen <dave.hansen@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, linux-mm@kvack.org, Lorenzo Stoakes <ljs@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>
From: Dave Hansen <dave.hansen@linux.intel.com>
Date: Wed, 29 Apr 2026 11:19:59 -0700
References: <20260429181954.F50224AE@davehans-spike.ostc.intel.com>
In-Reply-To: <20260429181954.F50224AE@davehans-spike.ostc.intel.com>
Message-Id: <20260429181959.BC9DABC5@davehans-spike.ostc.intel.com>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8332740003
X-Stat-Signature: mg54rxqyt43uatgic7x1rpmpqd5g8uyu
X-HE-Tag: 1777486802-10434
X-HE-Meta: U2FsdGVkX1/T+L+yXcuq+N5E4Yol8/kBcpnJnK005XZhf7kOiADowkGah2gv0dd4pgNptidxEGbHYTkyZ+yIaQUdjYs9FXC5Kz7WWBwY8ddcBDVwIRn24DEARRKeoRz91gn7YqCgKGpi7WvPDBNnHxUxC7nFCLNnw2g7WvQRFRLVWJkyFJYCKnVcM1a0PupGLVw49mBL3A1aT6f325J4OA1LVMx9K1mK1jJvU0GWW2TKebkkYLEoDscYTQMkMSfmu8lYUZaGgMQxKpU5CQt/RX4v6xIWk+VQVLAewQWA0YiQ3yC21j99MESiS5VEQTkscJg2ZsAimNKihtoylFiRiT7vYtXfYVhKMp3dTzHisDQVW9+RGPfn/N6BRTl+Dlbg7keDN3ZDAW3r3GLs7EhE4WfYcskzPE0j2raeWM1LVyoTIjRI+0bZsS7Q5CZ/IiGFYFPPOgCy4FvVpHpt4fBG+sGbNOrIO2qeOPnqosdMB2l44M6UuKwLnScqz8QR65t/paIxVZdbVoecvHt9tzMD5LFfkYwTLQoI2rtfGPgkWB/01Na/wxwx7szPAoKUdcvfXRfn4xa5+g3Rvd9jmweCLGoxvMvn1omekZ9sm45DASwPgSsY/VIT0kcuRsBZFFA17xnNeRe0GDGqaWolEStsPFQkaVK45DnDP/btNtafWLtlRpls9WztFiEvYb7X2DBmAZdJyRtkyQwLyLnLDthI44oRYMFBm+4RgwzCfYIceqJZEN4Uoteo5j27VlJNYgHbOttNe2VYLgusZRolpQD+Uj4XTXWmnpi3LxwxSF2m7SNuzVGXzKbKLTZexlHbYjhBeKBG1fZWMuC246p7rKmj+WTES0W8bKTTjSFp+DXUmmiVQgNkFMDU9AaQNIsEqVSAblw/cRArC+fYVmkGB9z5nH9i1uPviMVq7DBGyiXX44afnC3JFcIuCi1jZhBepIYIaWJdyZT0Tt9jG7Rg1dO
 037h0UCC
 dlddb8RRHwLZn/G6Qv5D1+VW08PkwoidhwbqSZyDmflK+ELXKKmzwuntl7ya3eJ/u0VF6i6pF7z71o+BenAuBYzUTFYRw5E3OfdDCQtoCQ3pu+E5LA61ysS1r6nQdDnttjRFeQ9YuRZKqgon7DXsAi6/ILxzek6W+A/LmokCAHr3gap7fm1oR3xwLOH+wEmnGH/YMAziKpKgx0VM088iptbUi74AN2U91ENYrRVpSubL/8HPdJ82eAQsucTeaiW1ZSIsHJCYZf6pZzzUpdj8D4Ll4t/KJxWezXwpPjS4RxDOLsmdLUuOQIbPn3hg7nLVR/D8ERjgIEvVUPSL6n15fiTQLJ17FraFlOtHANvLFJ8Y/3SNY6yNhTQvD2gqtkXtykdgR5F8+KhWeAWXtgWmRyNtKAA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


From: Dave Hansen <dave.hansen@linux.intel.com>

== Background ==

There are basically two parallel ways to look up a VMA: the
traditional way, which is protected by mmap_lock, and the RCU-based
per-VMA lock way which is based on RCU and refcounts.

== Problems ==

The mmap_lock one is more straightforward to use but it has a big
disadvantage in that it can not be mixed with page faults since those
can take mmap_lock for read.

The RCU one can be mixed with faults, but it is not available in all
configs, so all RCU users need to be able to fall back to the
traditional way.

== Solution ==

Add a variant of the RCU-based lookup that waits for writers. This is
basically the same as the existing RCU-based lookup, but it also takes
mmap_lock for read and waits for writers to finish before returning
the VMA. This has two big advantages:

 1. Callers do not need to have a fallback path for when they
    collide with writers.
 2. It can be used in contexts where page faults can happen because
    it can take the mmap_lock for read but never *holds* it.

== Discussion ==

I am not married to the naming here at all. Naming suggestions would
be much appreciated.

This basically uses mmap_lock to wait for writers, nothing else. The
VMA is obviously stable under mmap_read_lock() and the code _can_
likely take advantage of that and possibly even remove the goto. For
instance, it could (probably) bump the VMA refcount and exclude future
writers. That would eliminate the goto.

But the approach as-is is probably the smallest line count and
arguably the simplest approach. It is a good place to start a
conversation if nothing else.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: linux-mm@kvack.org
---

 b/include/linux/mmap_lock.h |    2 ++
 b/mm/mmap_lock.c            |   43 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 45 insertions(+)

diff -puN include/linux/mmap_lock.h~lock-vma-under-rcu-wait include/linux/mmap_lock.h
--- a/include/linux/mmap_lock.h~lock-vma-under-rcu-wait	2026-04-29 11:18:50.633628887 -0700
+++ b/include/linux/mmap_lock.h	2026-04-29 11:18:50.707631737 -0700
@@ -470,6 +470,8 @@ static inline void vma_mark_detached(str
 
 struct vm_area_struct *lock_vma_under_rcu(struct mm_struct *mm,
 					  unsigned long address);
+struct vm_area_struct *lock_vma_under_rcu_wait(struct mm_struct *mm,
+					  unsigned long address);
 
 /*
  * Locks next vma pointed by the iterator. Confirms the locked vma has not
diff -puN mm/mmap_lock.c~lock-vma-under-rcu-wait mm/mmap_lock.c
--- a/mm/mmap_lock.c~lock-vma-under-rcu-wait	2026-04-29 11:18:50.704631622 -0700
+++ b/mm/mmap_lock.c	2026-04-29 11:18:50.707631737 -0700
@@ -340,6 +340,49 @@ inval:
 	return NULL;
 }
 
+/*
+ * Find the VMA covering 'address' and lock it for reading. Waits for writers to
+ * finish if the VMA is being modified. Returns NULL if there is no VMA covering
+ * 'address'.
+ *
+ * The fast path does not take mmap lock.
+ */
+struct vm_area_struct *lock_vma_under_rcu_wait(struct mm_struct *mm,
+					       unsigned long address)
+{
+	struct vm_area_struct *vma;
+
+retry:
+	vma = lock_vma_under_rcu(mm, address);
+	/* Fast path: return stable VMA covering 'address': */
+	if (vma)
+		return vma;
+
+	/*
+	 * Slow path: the VMA covering 'address' is being modified.
+	 * or there is no VMA covering 'address'. Rule out the
+	 * possibility that the VMA is being modified:
+	 */
+	mmap_read_lock(mm);
+	vma = vma_lookup(mm, address);
+	mmap_read_unlock(mm);
+
+	/* There was for sure no VMA covering 'address': */
+	if (!vma)
+		return NULL;
+
+	/*
+	 * VMA was likely being modified during RCU lookup. Try again.
+	 * mmap_read_lock() waited for the writer to complete and the
+	 * writer is now done.
+	 *
+	 * There is no guarantee that any single retry will succeed,
+	 * and it is possible but highly unlikely this will loop
+	 * forever.
+	 */
+	goto retry;
+}
+
 static struct vm_area_struct *lock_next_vma_under_mmap_lock(struct mm_struct *mm,
 							    struct vma_iterator *vmi,
 							    unsigned long from_addr)
_

