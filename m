Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69DB2D58E43
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 00:52:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E71756B0088; Sun,  1 Mar 2026 19:52:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E1F8F6B0089; Sun,  1 Mar 2026 19:52:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1E266B008A; Sun,  1 Mar 2026 19:52:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C28C16B0088
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 19:52:29 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 21F8F1A0714
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 00:52:29 +0000 (UTC)
X-FDA: 84499297218.26.DA95D1E
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf21.hostedemail.com (Postfix) with ESMTP id A2FA11C0002
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 00:52:26 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=EIZnaf1L;
	spf=none (imf21.hostedemail.com: domain of rdunlap@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772412747;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=7saKVzOxoyQVzyoMxc8/Swddr+JmA7XALf/AIy5p+cY=;
	b=TH8xT88wZCWA7JqxD8ghLyLNPkgUxrW2iqm1pfKaNQHtwKewtWs0HiKnkXxj5iN9R9nGad
	wr2BmHoBwEw4TZkvOMJriDayuPYzkqK0JY0wzLkkoor7rJLenxQlgkAmzAV6LCn28BvvFO
	JQ8zLUq9C5F8m5RZ99WgJF8m2ovJmJA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772412747; a=rsa-sha256;
	cv=none;
	b=SnluAo+8HDpLs/6R3yH5YhiZNJjet51e3aBtZGyl0wB9wzGFodNsVyoB+Qjr8e/vt3UuA4
	WtHuo1w8VRtx4jsyUtjvgqxrHsaFMwwwNNXsQct30CWsV4mz9iAS59g+Y5OIPbyYSNlkZt
	mKZ/5pqnLS8Ee8hyYKt0eNxxIwBp+Lg=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=EIZnaf1L;
	spf=none (imf21.hostedemail.com: domain of rdunlap@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=7saKVzOxoyQVzyoMxc8/Swddr+JmA7XALf/AIy5p+cY=; b=EIZnaf1LogeAFGwueIIyStDp40
	dZvB6cVWaM1ypJEa1iEVroUhyMlGvdQFCu0plYLrJlfsrfe/x44Lsv49F2TTa82JZ+AX06vLXmjJ1
	NrFxd7gOZPH3gG1ner+rVF+wnB4rIIEIHXoZEyBuwWWaqjiUw7XraUKw3p+QuLL3lfMXuOPTZeWCe
	MuS7LohQDtELwvl1L7315gP9HLYfAyvgnJsz9yx1sApxiYJMVlmP84kkpvOnEArS1lOIG7IBhvjvR
	kcNYmzxBuKX70JCX8WFaWXevM9aJscMtD69upRzt97V+n+JmJxXSCb6fMh8hnKZ2VnTsvhtuS8uUJ
	E+WgBkUg==;
Received: from [50.53.43.113] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vwrWK-0000000C28F-1yWy;
	Mon, 02 Mar 2026 00:52:24 +0000
From: Randy Dunlap <rdunlap@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: Randy Dunlap <rdunlap@infradead.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org
Subject: [PATCH] mm/mmu_notifier: clean up mmu_notifier.h kernel-doc
Date: Sun,  1 Mar 2026 16:52:22 -0800
Message-ID: <20260302005222.3470783-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: zy6yrafdpcknk6t4s9euan7fjyu957uk
X-Rspam-User: 
X-Rspamd-Queue-Id: A2FA11C0002
X-Rspamd-Server: rspam12
X-HE-Tag: 1772412746-474100
X-HE-Meta: U2FsdGVkX1+p61JGxPYvUwfKBt4OGv0ePP03x5cVgcKpkElS5GrhErIgYnTctaddzqdMSFWh7Vv7CajdE7SbXvU4fTJeLMldNgMxnzir56Nr58zo9WIx+98A59LQGt2CG1HYX3PFaAn9Goqr2fZNRlIfhx0lVK7KLeP0dvRypZatkqaBZyWPfw2/d203mfQ5OCTvrHjjWpe/W2il81bl+JvWSoO02cakfX+K0bh3WhWSNCRd3K9Vo+D0OY7aMJ0T5TnehCONNCwaLc5Dl7dvCGbZnmBesc/Bgmz/rqlzkPkTQ49SvKbHYVjfpFW4k9T0hQEIrnZ+9vgCbG2737RASSIYjTSQIguYMfO3CMCXFsqtk1bOuA7ihu0zhCE9qYBnl/Dyk2taK7UcCrYzAlmuCZ3AUP1Y9V6sYLVBtuP7hgZi6fq5xF9Ru1MfJ1UFYQ6NWHrYQ5X2Xq2J8FWZfHBh+qFmOynzxM8zoctjtDbtG8Px1/RkTnvx2eKmiSnhODvwvh7OAIhpZ3SoYnZTb9sexRfOYy6J4JpckgUgM+DtM0qY2IvtdU4F6nGuUxM1dqTw25TALHAnqPiWKAFZAFS6OUe9SCUd6KWrfQQwpPhiwVpeWNjNmwt4pZ7ka+JKirMtCB8KRVaoEJh2gx+Cgss4vDGzhSLQh5WPXFvSSOiTz0E7rrNUFvgwGPc3uYZ39xdWPoXQz9ehCPn3rVVA0eaXpKszhuSAsk2z6AcJV9M4rvwclLaTVPDxHwMzaDzEan748jtwP6ueHAtToTGHvRZ6A60lT7GGqNZKF1+DWFyKMNkfNnuewhEf5Cxbv+o7W+RhXAG9O1BOvI7GKQxmFZmWX3CnHzgXypY40SZTRIMoThfwrk5OccwkwIbrtG4qWiEvUhN1rXofrgyGYnQEUgPRSlakzXEX8LOpRRhmEl43SJAXlmaqHy6s0D0w/MkjeefmdLkBZSd2NJaHQD9M0X3
 PYetjjv3
 Yi+HKMjwFNZZZ6I1ydYG87o7r5bYN2yvYOZ/ivK02lNzy0vp+wIYJSEkXOFkiXDaZeFl6OUNUMlZ4IQ0+uPGJ4BSNhAEVg3JcCIYnazoqeAfoSoNJkUOAj98Z2auBSotpJ1oJrYZWsOBbcjBRBwm6cZWsaOycMsSMt1eKGdVmd8s0c44Kr+HNJla6zaVHR6gkKAzfA5gPeSbWzNKsrBAEV8hswwtN0ZDbTwlOzyIBBPZ4CUN3zY6fp1gtsuTTa8zgTFzrvToNUg3H0QZNzPkNblmN7m+Ng9Hp+FmuYJVJ4M4ESqpvNqkvIYcyeqaOPNixWRP+swJeJgRWbx+oq96nA5mG7/1G1iwKy0501EhOsvhbMC7cjNyjcXA45nwRY/Yom2g4vkv/zLdsrcG2OUoBFIQ0LzVBAIwSmQhkPaPmIMrONTrXmRgBGDdhG/aD4i8/FiHSP3yb/O/qCtUrlthNIx9N0GuxFkTWvcJQzlN4YRmSTw/iB1Fk3DgW0jsK/J5uE5awf52hj1GneD6I4mWsJUf/7exrJoOPY95KU8cJgdXDTFWRXxWCkBkY9WJ5VmaKnfRM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Eliminate kernel-doc warnings in mmu_notifier.h:
- add a missing struct short description
- use the correct format for function parameters
- add missing function return comment sections

Warning: include/linux/mmu_notifier.h:236 missing initial short
 description on line: * struct mmu_interval_notifier_ops
Warning: include/linux/mmu_notifier.h:325 function parameter 'interval_sub'
 not described in 'mmu_interval_set_seq'
Warning: include/linux/mmu_notifier.h:325 function parameter 'cur_seq'
 not described in 'mmu_interval_set_seq'
Warning: include/linux/mmu_notifier.h:346 function parameter 'interval_sub'
 not described in 'mmu_interval_read_retry'
Warning: include/linux/mmu_notifier.h:346 function parameter 'seq' not
 described in 'mmu_interval_read_retry'
Warning: include/linux/mmu_notifier.h:346 No description found for return
 value of 'mmu_interval_read_retry'
Warning: include/linux/mmu_notifier.h:370 function parameter 'interval_sub'
 not described in 'mmu_interval_check_retry'
Warning: include/linux/mmu_notifier.h:370 function parameter 'seq' not
 described in 'mmu_interval_check_retry'
Warning: include/linux/mmu_notifier.h:370 No description found for return
 value of 'mmu_interval_check_retry'

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org

 include/linux/mmu_notifier.h |   31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

--- linux-next-20260227.orig/include/linux/mmu_notifier.h
+++ linux-next-20260227/include/linux/mmu_notifier.h
@@ -234,7 +234,7 @@ struct mmu_notifier {
 };
 
 /**
- * struct mmu_interval_notifier_ops
+ * struct mmu_interval_notifier_ops - callback for range notification
  * @invalidate: Upon return the caller must stop using any SPTEs within this
  *              range. This function can sleep. Return false only if sleeping
  *              was required but mmu_notifier_range_blockable(range) is false.
@@ -309,8 +309,8 @@ void mmu_interval_notifier_remove(struct
 
 /**
  * mmu_interval_set_seq - Save the invalidation sequence
- * @interval_sub - The subscription passed to invalidate
- * @cur_seq - The cur_seq passed to the invalidate() callback
+ * @interval_sub: The subscription passed to invalidate
+ * @cur_seq: The cur_seq passed to the invalidate() callback
  *
  * This must be called unconditionally from the invalidate callback of a
  * struct mmu_interval_notifier_ops under the same lock that is used to call
@@ -329,8 +329,8 @@ mmu_interval_set_seq(struct mmu_interval
 
 /**
  * mmu_interval_read_retry - End a read side critical section against a VA range
- * interval_sub: The subscription
- * seq: The return of the paired mmu_interval_read_begin()
+ * @interval_sub: The subscription
+ * @seq: The return of the paired mmu_interval_read_begin()
  *
  * This MUST be called under a user provided lock that is also held
  * unconditionally by op->invalidate() when it calls mmu_interval_set_seq().
@@ -338,7 +338,7 @@ mmu_interval_set_seq(struct mmu_interval
  * Each call should be paired with a single mmu_interval_read_begin() and
  * should be used to conclude the read side.
  *
- * Returns true if an invalidation collided with this critical section, and
+ * Returns: true if an invalidation collided with this critical section, and
  * the caller should retry.
  */
 static inline bool
@@ -350,20 +350,21 @@ mmu_interval_read_retry(struct mmu_inter
 
 /**
  * mmu_interval_check_retry - Test if a collision has occurred
- * interval_sub: The subscription
- * seq: The return of the matching mmu_interval_read_begin()
+ * @interval_sub: The subscription
+ * @seq: The return of the matching mmu_interval_read_begin()
  *
  * This can be used in the critical section between mmu_interval_read_begin()
- * and mmu_interval_read_retry().  A return of true indicates an invalidation
- * has collided with this critical region and a future
- * mmu_interval_read_retry() will return true.
- *
- * False is not reliable and only suggests a collision may not have
- * occurred. It can be called many times and does not have to hold the user
- * provided lock.
+ * and mmu_interval_read_retry().
  *
  * This call can be used as part of loops and other expensive operations to
  * expedite a retry.
+ * It can be called many times and does not have to hold the user
+ * provided lock.
+ *
+ * Returns: true indicates an invalidation has collided with this critical
+ * region and a future mmu_interval_read_retry() will return true.
+ * False is not reliable and only suggests a collision may not have
+ * occurred.
  */
 static inline bool
 mmu_interval_check_retry(struct mmu_interval_notifier *interval_sub,

