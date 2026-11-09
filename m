Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FBC4606A31C
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 14:13:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=K21mgRLn
Received: by kanga.kvack.org (Postfix)
	id C58086B05BD; Mon,  9 Nov 2026 09:13:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C09B06B05BE; Mon,  9 Nov 2026 09:13:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B142A6B05BF; Mon,  9 Nov 2026 09:13:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 897D76B05BD
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 09:13:06 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2A0E816068C
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 14:13:06 +0000 (UTC)
X-FDA: 85415772372.17.84CE3BF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 815FC100007
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 14:13:04 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=K21mgRLn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794233584;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uRrUL/Sj9GAie9CqChw90/XCAsPH+Lp3goKZrDcCREM=;
	b=F8lQ/mz7VLYf42GMu7bwnd4hS+gpL65IuBLrsTnOnBo39T2rxDAZZFG+5Ul162HDwU87km
	+v7wloDNs1x0C1ZcYNRoXTi71v5wCQ9aDBqvuCxheO1hiVa46OLjgGZG8lbKCbt8OoPqrn
	6YpLdsFT+otNy3uZ3VYcrm+PC361Ixw=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=K21mgRLn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794233584;
	b=Ix6YjflOjywv0FyHCzqGZp/3LRASaWnTE0WO5dDD7DC59cGjth0fxkfeHgMFo8yBU3Vhoa
	RjBVze5/rlJ1/NCR6QKfSUs4Poh0tBi8KUKY9IVn0uUap7jFEfAbnkMvfPorVPc+uK4nZd
	ggMZl7OLA88kNl9DxyZRPOvWONK5h3I=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BD878408BF;
	Mon,  9 Nov 2026 14:13:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C09D1F008A1;
	Mon,  9 Nov 2026 14:13:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794233583;
	bh=uRrUL/Sj9GAie9CqChw90/XCAsPH+Lp3goKZrDcCREM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=K21mgRLnyqoFLvs1X8OKuAQXN7wur61w/y1XP4IFX5OQRv5B7djdPS8mqSz95sy0C
	 2DYjY9fgeYV9IvVc+Bp16C60Zf79ZMjqeK+5/XHnXijMWFDENajBZDq11Aml3mgzvm
	 WHtGi/GRNQRQ34cBhdmwZWD/fY2dl95lCS7+8Ivv51VIAZ2+aVZi+/IPC1opm2sz61
	 +CSlX9/fPscw8yEkrKf1LDDefayQBVX2H0bzXbiauyfCqHdOWJs7uwyc8ycos0qSO4
	 FrcP/CpiubfmpEpq5JtZ5v5w3iH1ZK5gRh+DMCvzw0dFqwkCHHMT9JLmgrsl3vDMUB
	 JmOhieZeNhtxg==
Date: Mon, 9 Nov 2026 14:12:57 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/3] mm/khugepaged: release contended mmap read lock
 after scanning enough VMAs
Message-ID: <avHUKAT7-H5Ov5RC@gremlin>
References: <20261105-khugepaged-latency-fix-v2-0-4384bbfe4606@kernel.org>
 <20261105-khugepaged-latency-fix-v2-3-4384bbfe4606@kernel.org>
 <au3CUJO9zBMHLx-B@gremlin>
 <8ffe5804-a8a1-4486-b5eb-7ce5f451b77c@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8ffe5804-a8a1-4486-b5eb-7ce5f451b77c@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 815FC100007
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: 6mq3nmjapzutti3c9ai3d9s8ykmti7wi
X-HE-Tag: 1794233584-146676
X-HE-Meta: U2FsdGVkX18pEABcrbsQ46NKRO2oSdT9IREOfgpWQr1JPATMaDnX0e4JvmNwo5dtDxvIUPFduIm9m6wWZ6dh9bMp+ptOg955Hd2p5VDhO+43s1MPtD0T4ZkTvvOGWLcvUOdZG76uo/eG8/Wh1NjJaOPq8rcSuHKj0ZJZscPva7hW9pdGJJloMkC8SJ7Tj9vSmpZEwgvZYh2Y8SsdgqZjmZuG73tFItEI1iNwbwIVP7dhp+EkZjtWSPqE6lpC7r8Hi7laYXQKO/wmBa9XxVdXa2mxRTZu99si70HNWU446deHeA1vcXVTI1U/EFlRWL3z5t2MAaT30lNn8D7hkLeNJ4m030/HWXl3gjQ3nSF24guoy50PfL6TCgXYBdzH4YF8ZdR+DbqNjifSLlqxUwtOEpRGWBuivL6lwkPBfL33mYiK650F+IUjaL51QpOWSIQS27HUoHHPq4+3FLBW1qt8Op2Nh70r7z2c5BIEqrHrKcX27YVHCs+twxDSYPp7SbOw6mt4SMhD8m2+eOpC5Qi2IRYBMvognP7Y1ZYVc43qGYyX76faxxkJ6Lr16mHl9iP4oGOF9MwHQg3RjoU6UuYUwYDoj0hhTItHCPhlf95bMfjse4vR9kizH5gl5YEjLO2+t6Oooqoif7nDuTnZfc4KsezQKR1tozueysC+UymBTc3AL3tfM4HCTUOGn35DDP0QDTwiW2PnHJ9pVEWJaS0hK+0eJEiaLG7MQ/YVbOulBlywtBrN/ihB3AMbrAGyBqCJ8akH1liUKVXfpPZpzV0rz5qW5NNDy/zcKmyL8g6j8T7Ds7xhnvVOaIFhe0/uZCkDBkkPqe34UQPRWOBUokO15fwRGwy7J1yAwEB8QzOsjZZaNrESX2iQ4qNdqcPL2nCrh0xWmnndG4zHJu+8V6Kz0+aynQiLUcj9DR6PTYmqVzDdfpMCH0GVS7JxDkL5BwtE2w8DHfuQVcootXBNMKT
 1570fcbB
 akceBrq5qCqdHUKr9Yv7pmo9lva1Ou0ihWruqHT4LApgmnclQJ5V3NhhU4iCY97X90/9c4CangLujXFVbBz9orn1tgkdrSVopu/6pPyj8AX5CWAnR08UbT3t86/GC7CQOJTGh/FqK2oeNY8l3LT/c71LGaPNxbHiPXutvto1gYwiAmyiXM1hBZ3avKf7KORsFajSY/ikGhRBviZFWls3EUakcBkpfbbozLlEWgYVglFQi47rLfarM5JfTzwp5bmFx6bM3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 09, 2026 at 03:01:29PM +0100, David Hildenbrand (Arm) wrote:
> On 11/6/26 13:07, Lorenzo Stoakes (ARM) wrote:
> > On reflection, I think this would be better implemented as something like:
> >
> > static void collapse_scan_mm_slot(unsigned int progress_max, ...)
> > {
> > 	unsigned int long lock_start = jiffies;
> > 	...
> >   	for_each_vma(vmi, vma) {
> > 		...
> >                 if (time_after(jiffies, lock_start) && mmap_lock_is_contended(mm)) {
> >                         mmap_read_unlock(mm);
> >                         cond_resched();
> >                         mmap_read_lock(mm);
> >                         lock_start = jiffies;
> >                         vma_iter_set(&vmi, mm_slot->address);
> >                         continue;
> >                 }
> > 	}
> > }
> >
> > Which avoids magic numbers, and means if we hold the lock for 1-10ms (depending
> > on HZ), which is a long time in the kernel to hold a lock, AND the lock is
> > contended, we drop/reacquire.
>
> That approach indeed sounds better to me regarding lock contention.

Unfortunately it makes things measurably worse (it's not fine-grained
enough). Trying to get a fine-grained timer will involve preemption
disable/enable pairs, so a no go.

This is the alternative I have locally which explains the number, puts VMA in
the name and it applies to _all_ VMAs as requested.

Let me know what you think!

The jiffies version would obviously just be this but with the above, but that
one results in max ~2 ms-level stalls rather than ~200us.

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 7d1414a9b2a5..59bbef61f104 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -66,6 +66,13 @@ static DEFINE_READ_MOSTLY_HASHTABLE(mm_slots_hash, MM_SLOTS_HASH_BITS);

 static struct kmem_cache *mm_slot_cache __ro_after_init;

+/*
+ * The number of VMAs to walk before checking for, and relieving, mmap lock
+ * contention. This bounds the maximum mmap read lock to an estimated ~100 -
+ * 300us depending on hardware.
+ */
+#define KHUGEPAGED_MAX_VMA_SCAN_BATCH 1024
+
 /**
  * struct khugepaged_mm_slot - khugepaged information per mm that is being scanned
  * @slot: hash lookup from mm to mm_slot
@@ -2910,6 +2917,7 @@ static void collapse_scan_mm_slot(unsigned int progress_max,
 	struct mm_struct *mm;
 	struct vm_area_struct *vma;
 	unsigned int progress_prev = cc->progress;
+	unsigned int nr_vmas_batch = 0;

 	lockdep_assert_held(&khugepaged_mm_lock);
 	*result = SCAN_FAIL;
@@ -2942,6 +2950,18 @@ static void collapse_scan_mm_slot(unsigned int progress_max,
 	for_each_vma(vmi, vma) {
 		unsigned long hstart, hend;

+		/* Relieve mmap lock contention after walking a batch of VMAs. */
+		if (nr_vmas_batch++ >= KHUGEPAGED_MAX_VMA_SCAN_BATCH) {
+			nr_vmas_batch = 0;
+			if (mmap_lock_is_contended(mm)) {
+				mmap_read_unlock(mm);
+				cond_resched();
+				mmap_read_lock(mm);
+				vma_iter_set(&vmi, mm_slot->address);
+				continue;
+			}
+		}
+
 		cond_resched();
 		if (unlikely(collapse_test_exit_or_disable(mm))) {
 			cc->progress++;

--
Cheers, Lorenzo

