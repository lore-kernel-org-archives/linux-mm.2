Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20856CF256C
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 04:26:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 49EE36B0062; Tue, 18 Nov 2025 23:26:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4767D6B0099; Tue, 18 Nov 2025 23:26:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B3BC6B009D; Tue, 18 Nov 2025 23:26:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2A9E86B0062
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 23:26:53 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 083E0C01E8
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 04:26:51 +0000 (UTC)
X-FDA: 84126071022.28.C463F09
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf21.hostedemail.com (Postfix) with ESMTP id 8FD961C0006
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 04:26:48 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=JpQVAU0B;
	spf=none (imf21.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763526409;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=TZVtzC8fVh0TwlkKTKOcLYyVnFe22WKpjprqHTiqq1I=;
	b=teMkVt4J+RwxVdp1FD+1hvVPTGl5kAhsPs/3q23NCcpsbLQTvRyBp+HaJAOYT3lRsdvHYH
	dR2ULsPUsr0pRBoREb3MZ4XTTEQ8LVoPeeKFl7B+BjyM1+dCwguu7W3HtPrl/6s65Fwecs
	mk617Nn4ekk7+yi44kClwFDwT9vs728=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763526409; a=rsa-sha256;
	cv=none;
	b=62GDCl4VQHJABeSjvIsD00NouOSsri3rAfFWDl2ImhICrFR5EuCS3nLc2FA9s+qQIu1ZT9
	p0gunQ4MI45Xxzmb15EfRVzJ3V9fZvQzNBFpG3rouC7p+xHVjuxq2QRyh4r5laRFM9tOan
	Mb/uSjJwv7mWJ8V3N8nhWZSQG3atmfI=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=JpQVAU0B;
	spf=none (imf21.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=TZVtzC8fVh0TwlkKTKOcLYyVnFe22WKpjprqHTiqq1I=; b=JpQVAU0BBXJAg/FbSyd6HuxSef
	KiFsLpgra2z680bX3EzW1R1xnPlBM5yFTSCvPdlciR5asfs9cP4lcbNsx0hxCBl87rpfYBVMthrmJ
	0pa1XXFb6Twr43XfSlZf4Ro1HynGuqiyD/hEbDAvVPV3TpZvZtGMARszFpq3yzhSPWI5f8HZJ1QxF
	2rC8Y2cc5f1xzrzeyKzNzvJMKd37ey3ABHjcMQj2vuGnsdfd0Ent8F6UkqfxJDjJsfeVccizfNaBl
	phz/BfYFvMoNcZ3pz1O5N7tjvD3grBSmEMLEavf6GZ3gy+SzyXjn2GM2+5poHE7Trctdj0GV7yEQ8
	BAlyWYEw==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vLZmG-0000000GWCc-366R;
	Wed, 19 Nov 2025 04:26:44 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	linux-mm@kvack.org,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Suren Baghdasaryan <surenb@google.com>
Subject: [PATCH] mm: Tweak __vma_enter_locked()
Date: Wed, 19 Nov 2025 04:26:35 +0000
Message-ID: <20251119042639.3937024-1-willy@infradead.org>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: a7z6uyqj1rcw3igcnktz1pyici8sn1pd
X-Rspam-User: 
X-Rspamd-Queue-Id: 8FD961C0006
X-Rspamd-Server: rspam01
X-HE-Tag: 1763526408-824395
X-HE-Meta: U2FsdGVkX1/lMzh6i+ENHe5Gp/97U0lujYMessC/vlbLCWf+anq36XdCxdyL4g+Lv73sXa/LuJf2iSAhD1KhNykKfzO5CxdRTT9HIKqb48xn7FFuA5R+DbM2AQbEQDfsle96qBZJoBuOmIbwOuAKJmnFkjRJ4NVpXUIDeda9dvV63Ff9a5d8wOJouNwLrWRDP+BzQUye04xdPWdKBFshQiqctANcWJ+mf9KC8IR6AIIqkGszzrcE5DvoPAlHKeKOWTsuaAyt8YTXru8YvxzJ01jHw8L6gN7qTxmaffP+3pglpDhUVst6CkUmo5QWkr1j+MRnT1SP1kkqGDVQ0CEqyt5nWwpxmCQjqxyZyody7G/rkzaDsvlCDGJbxlcYF9qskPa+xUTSxNZiRxDr3QUCE3sKoqasz79dw2XGvlfIUVHIwd7T4mqnEqxSrDoM7A/rqpoMYiyTtR1B6yD+/5EyBuuTYxlzR8++0mh2Q1TKG0xGErcUp8769pVXqEvSG3zY3AHacDvY4SXjQJ0Q+PL9SwODKCLFZw0dGZjmJkAo46hKXog3+dLub/OW6tPrYSFwOVGjwCN5rNkGoc7u7gPPpxG6fkNb581C/8j7ka7wVM+kRtm5MHwiSXc8xrngV18cwnhzy7TEkQaMHjtmgnfijnSyEtIZzyPRov0ZBm578F1q2ZgnNq45cz7UUK7jhpmA24a1kWxCUO88DZWAz+eV/sAwC3BP6vHzYSjqZj2N+XsEWGep/1i9FbPFFlRRa+dwz7Xa3kRcUUe5YUAgAvVdif70Bu6tUVwCBW5RQhR/p7ZDDbrIuR/uEMUmiOLqdvbfhsVOoBud+Fy9WMI6YacyRvaUSO/b4BclFPv8itqkPv7JHAVRpSohL9vtlRyxQ4cqDdmTuN8ljNgGJUDcIWTL6jJxgxF4K4cEvSzlpRZRWQ55HWQyDi37IM+dtcnRFTn3NcGfTT+QUP3kACzUjHS
 fzMsq1O+
 MfHZxdZjA9PwSn9jmd26It3tElvD/Yxuzk18/66ppv9UA04bwmTUkD1k+BNbwbrpuwE+vyokr4RN7zULx/XL/Sv4u/5LGXElOfYg3TmLHDjz9TElG8tvnfg5/WCaZsArok/QE5Q3PP8prDsWuBctjT6RzuDP5JvHHqV31XtKJTkuNy4ZKmMa4rw+cW/lXceBhpNP6wEQvyLXzX+m4CrZ6khym9DotZWLurvubShmGXrWW3rKkiLiNVhSogpUPxgF5Wf2Q2+im0Ugw/cYt1YDFcH6jHKKhAW2VoPmxxQHmQ6dshG3QrD71XPpJfIWWSq0/NQk4dYDCjU/n/fXQmtjdZfe+79X/voBlxJxd
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Move the commentary on how __vma_enter_locked() behaves from the
body of __vma_start_write() to the head of __vma_enter_locked() and
merge it with the existing documentation.  Also add a call to
mmap_assert_write_locked().

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Suren Baghdasaryan <surenb@google.com>
---
 mm/mmap_lock.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/mm/mmap_lock.c b/mm/mmap_lock.c
index f2532af6208c..e6e5570d1ec7 100644
--- a/mm/mmap_lock.c
+++ b/mm/mmap_lock.c
@@ -46,9 +46,9 @@ EXPORT_SYMBOL(__mmap_lock_do_trace_released);
 #ifdef CONFIG_MMU
 #ifdef CONFIG_PER_VMA_LOCK
 /*
- * Return value: 0 if vma detached,
- * 1 if vma attached with no readers,
- * -EINTR if signal received,
+ * __vma_enter_locked() returns 0 immediately if the vma is not
+ * attached, otherwise it waits for any current readers to finish and
+ * returns 1.  Returns -EINTR if a signal is received while waiting.
  */
 static inline int __vma_enter_locked(struct vm_area_struct *vma,
 		bool detaching, int state)
@@ -56,6 +56,8 @@ static inline int __vma_enter_locked(struct vm_area_struct *vma,
 	int err;
 	unsigned int tgt_refcnt = VMA_LOCK_OFFSET;
 
+	mmap_assert_write_locked(vma->vm_mm);
+
 	/* Additional refcnt if the vma is attached. */
 	if (!detaching)
 		tgt_refcnt++;
@@ -91,11 +93,6 @@ int __vma_start_write(struct vm_area_struct *vma, unsigned int mm_lock_seq,
 {
 	int locked;
 
-	/*
-	 * __vma_enter_locked() returns false immediately if the vma is not
-	 * attached, otherwise it waits until refcnt is indicating that vma
-	 * is attached with no readers.
-	 */
 	locked = __vma_enter_locked(vma, false, state);
 	if (locked < 0)
 		return locked;
-- 
2.47.2


