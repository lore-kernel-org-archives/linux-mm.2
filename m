Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1CF0DCA5FA7
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 21:54:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2725F6B00A6; Tue, 29 Sep 2026 17:53:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1FB916B00A7; Tue, 29 Sep 2026 17:53:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E9106B00A9; Tue, 29 Sep 2026 17:53:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D1FA36B00A6
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 17:53:41 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6308F16065C
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 21:53:41 +0000 (UTC)
X-FDA: 85268152242.16.4992838
Received: from mail-dy1-f200.google.com (mail-dy1-f200.google.com [74.125.82.200])
	by imf20.hostedemail.com (Postfix) with ESMTP id AF53B1C0004
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 21:53:39 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=JcLjoXwx;
	spf=pass (imf20.hostedemail.com: domain of 3YjO8agoKCBcA58xLIx5F43BB381.zB985AHK-997Ixz7.BE3@flex--nilayvaish.bounces.google.com designates 74.125.82.200 as permitted sender) smtp.mailfrom=3YjO8agoKCBcA58xLIx5F43BB381.zB985AHK-997Ixz7.BE3@flex--nilayvaish.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790718819;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zMygNuDtUV+X2v5M1Qvd80fwfvhUlqB4ex468SXCvkQ=;
	b=XPhxZCUa3V+0nJ19WO0Gob/WIhT8z6mg0lr6AU3td1jnn0ZtRmFDWy3fKkcC10UcBG7HqD
	g1EaE1lowzv2pxu+xwT6jp9LV/0lTD3BcNXnu+9KjJCAXxWFfC5/RSwG7Uw8Fd70s4h7In
	tyhg7Qu3gysWbfddoq0tzE3gCmcXLkA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790718819;
	b=CKSt55dXMBl5YhnX7d4bOf7yXhjj70MacFwDSynUezP91dkwsoGtvRTWnO7bw48HjWhZC6
	onybw1NWQ/lM6SWaOEeRcf9ug5p1qgfhZloKQbNEVLBNVes0xccw5xjHY0PGXxfHSLqT0z
	lqFNuESJFJ02JCy9zwhRvaJwwD5Dab8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=JcLjoXwx;
	spf=pass (imf20.hostedemail.com: domain of 3YjO8agoKCBcA58xLIx5F43BB381.zB985AHK-997Ixz7.BE3@flex--nilayvaish.bounces.google.com designates 74.125.82.200 as permitted sender) smtp.mailfrom=3YjO8agoKCBcA58xLIx5F43BB381.zB985AHK-997Ixz7.BE3@flex--nilayvaish.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-341eff9e381so4826873eec.1
        for <linux-mm@kvack.org>; Tue, 29 Sep 2026 14:53:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790718819; x=1791323619; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zMygNuDtUV+X2v5M1Qvd80fwfvhUlqB4ex468SXCvkQ=;
        b=JcLjoXwxgyqyxQ1TWsLMVy0Ei6HOZhRrFjKS/4f0WhWZzgPIR+9aM4JY9VPN5NDC3s
         pVU6K3c/yUSS+Jm1ydY5kMt0tcSIuxAyk4ZdbkaBcnujij2Q8jErg5odJWpurx6czLuB
         Fu8f35IH9Cd17waL4ULHOXP3ytLVtoGiaCq0f84IJYLS1/CFNe1/QBkDSlNMWNyG5mrh
         imK3GFsjTQnRCQJji5H9meTEHC7touxOhPgnfxh94V9eHIh4qIMbH0NKhHVmG1LI7a4x
         CdQFOQ4P5A4iQGBqOS4KxuLnMDrecc/0ESPQjNrhZySw0H8HiImIczP8vYOW28PGqqYt
         gMJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790718819; x=1791323619;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zMygNuDtUV+X2v5M1Qvd80fwfvhUlqB4ex468SXCvkQ=;
        b=QRULMPHOJUAfwaKsRnGSr7ZHfRKzmFwjVML38f6zXEqbtgYG9BRj8rXNlWNaIkNjXZ
         ViqMvo3lr4srrFOryOnv1D3ANes8TUaFPRmIE+yC856i8P9PT6B8FjylRYlCzkfIHv1y
         RYz5Pfvv8tZw8aIaSVSDkjIQHhSNXVD5YKnitFD6MNa2yjVF7TSCPBwyH7OsJL/MLAjL
         YWNnQPWLfKHHRCCShiin9qBEImCpRMjJWHIIZhcaLKrbieKmdqaKqD0/2Houuu+gd9ti
         SWZjsUWz2iyFFqWpRlFcznj/VMjiyOEapKoOciu7DSmIN7JBkjswpEzgEsqXH8IZEAv5
         nD7Q==
X-Forwarded-Encrypted: i=1; AKwUvBxdTMuIcs4QvEbjHYmCSrbEVRWlw+b9P4VF6vjVvy5yqN4WwxUhwrIxo9UYNtnY51gxHYJUSf3GiQ==@kvack.org
X-Gm-Message-State: AFuF++l570cKjauv9WhRlQeqtZKhN+nshODoUxvGAIX2i1zUBViHe+yh
	rhtcBWW35O+0ZeeXbZP8Fe5lWf6ODPKQxxdwW6urX2xE1cdKdSrlewmoK2iKB1XGXw0ixxacsRB
	pyceFNx/C4aoRUkgEFoe7pA==
X-Received: from dlev29.prod.google.com ([2002:a05:701b:465d:b0:143:6e9d:bb50])
 (user=nilayvaish job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7022:4188:b0:143:2984:6519 with SMTP id a92af1059eb24-14c9e6774f4mr781938c88.36.1790718818118;
 Tue, 29 Sep 2026 14:53:38 -0700 (PDT)
Date: Tue, 29 Sep 2026 14:52:05 -0700
In-Reply-To: <20260929215206.516490-1-nilayvaish@google.com>
Mime-Version: 1.0
References: <20260929215206.516490-1-nilayvaish@google.com>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20260929215206.516490-15-nilayvaish@google.com>
Subject: [PATCH 14/15] mm/page_owner, alloc_tag: use folio_page() for page_ext
 and codetag
From: Nilay Vaish <nilayvaish@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <willy@infradead.org>, David Hildenbrand <david@kernel.org>, 
	Greg Thelen <gthelen@google.com>, Roman Gushchin <kfree@google.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Nilay Vaish <nilayvaish@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: AF53B1C0004
X-Stat-Signature: p1rpu8ytuskspc4br9t71pjebokg9pjz
X-Rspam-User: 
X-HE-Tag: 1790718819-852855
X-HE-Meta: U2FsdGVkX1/fuZYzJvtWfJgyNXyx38Ccdm5SRsX1NnxuBGYNBjm8rkT7QM2KCapsuakdOQ8Df2jH39Fp+P/xzHZpYOWXSGmubNFhpzTXkM5DhNAdHXddUiUBuDdV1UdEOPNiyd6lKKhXtFFrWUZJ/q/wsDuRCFM7tIxtKivWekUPxSKmBwpAugtMbI+hSR4fum1dAPq7ZEWyITrmO4DczV2cdUX+3raM4BJFzQo3NZ5oybSQfyyKPfoBrFi/v8LZMmq5zDGFk47tbHX1XGdcurRLdw1EOCEKYhan5SF+eFyTV7U50EU6wIftlbrkbjk186gVle5pigpYMVzrvR981y1GKIRw872gyLQeHHAnN5X2bSgw6MLoAyBYKEor1T3x62hoNNOuYReoNTWihPavUmSuP/367LLusYHuuekU4CR7nO0c1zukfWxN8XoYiE/JSSnk+AMg4c8GU5aY773rWQM10NfFt//5T2PTff+yZFcS4hOPeWQtr5fHei5M5lZvaoy0uBiVfwJ5maPdfuFnTgwYAzjA2tgs97cgt0LYLkZQhPDwPsgKrIj1A4RVuzvL9pijYs7PIt1P2XCOadupnJVTTT4JqVbKgzea/+d4UcTAb2/CSkoo6Ka3JLhXcNoHXmoRyFSy6enSbA+PX16Dp+q40EbIiBpINEhbZrNkPdNFrHyS8d/C7ibRq8YXi4gia5SkvcgUKLo8Wzs+PmgMUOYpTeYGlNmVZjOyxj55eJP2mxNU6CXveFM+1xyHQkUkZMa3NPbicl6huemW/YExR+xEPpyhWVwhVwCy4tOlI/OLH36Q/eHC+v9r1TlhVQBcgPVSe/Gv8y67vqs+xmIQJAmT+M+050aYWKilkP2S7rApvUgAlFHxTcl6wgGnk/rKjIuUbWHy4PclmFbz814Hu5RRiwFvS1IhblLj05ZiTHmK3yYnrUAYCU2aszLuSzGLQDjQB8tqlJDYTNJVQLb
 qgX65qWn
 YTQR87aRNxdLCxuuR560W5ZsHXtD6It/8w/8kFcd1n3Ql0zBxwmk36KkJQ5nGUUUYMyyFLjmSqLNkT2aC9/wr+PRzJYFcgZcfDYm4wzJazlSoUBIl+v61UuNRbDbR+TUYG8qYsMqmxG/993QPQHtU9stIxi0kYo8I3YZXHtfjsLocjJck6alqXFTstpCKHMSsIAQLVfGWezGIt/az6g1eVEJiq7pXFEZLjlih0vAFaKEWawgJNpaJHOitPkSgJjYoYf3SSHJ9+T+S09m9iQh/kLT6hq4fqRw0F78M593BNM4TyiKR/RMWUY6hNTjQEZF9Upgy1okPUrp9s7sZb5EtuXNV5WPjatoh5wbbMooxq2lwfM4KJEEG4exb7i7VsOHVo0LKPHIRuAZZMJ50E8477TW2sMJ4pKZDt2fqYyapkWhJG+ejlvu5IRJOwnHLX5zfdEFlnK2aQQGiz9zePhQmcERsAnf1jqxvGlkOUvWViS+CAECxcmiY+TJAIVdm6C2I/wV9aG+h/DDgv91fQxGe97B2QwDw/9zuuLnvBijBe0hCnSWBTwFQxqBVMpMEvM04cl093vD7rjAKNrCXXAtgC5PKvl1fvWgj518wj8FSZiwgJYiyOqrt5juvVTVnkqc+I2tJ12EsuQwrtkdtWA9kK6Tg+g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

As part of the memdescs effort, struct folio will be allocated
separately from struct page and will no longer overlay the head page.

Replace direct &folio->page, &old->page, &new->page, and &newfolio->page
uses with folio_page(..., 0) in __folio_set_owner_migrate_reason(),
__folio_copy_owner(), pgalloc_tag_split(), and pgalloc_tag_swap().

No functional change intended.

Assisted-by: LLM
Signed-off-by: Nilay Vaish <nilayvaish@google.com>
---
 mm/alloc_tag.c  | 10 +++++-----
 mm/page_owner.c | 15 +++++++++------
 2 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/mm/alloc_tag.c b/mm/alloc_tag.c
index 82e2c3448dcf..c93efb224ce1 100644
--- a/mm/alloc_tag.c
+++ b/mm/alloc_tag.c
@@ -534,7 +534,7 @@ void pgalloc_tag_split(struct folio *folio, int old_order, int new_order)
 	if (!mem_alloc_profiling_enabled())
 		return;
 
-	tag = __pgalloc_tag_get(&folio->page);
+	tag = __pgalloc_tag_get(folio_page(folio, 0));
 	if (!tag)
 		return;
 
@@ -560,16 +560,16 @@ void pgalloc_tag_swap(struct folio *new, struct folio *old)
 	if (!mem_alloc_profiling_enabled())
 		return;
 
-	tag_old = __pgalloc_tag_get(&old->page);
+	tag_old = __pgalloc_tag_get(folio_page(old, 0));
 	if (!tag_old)
 		return;
-	tag_new = __pgalloc_tag_get(&new->page);
+	tag_new = __pgalloc_tag_get(folio_page(new, 0));
 	if (!tag_new)
 		return;
 
-	if (!get_page_tag_ref(&old->page, &ref_old, &handle_old))
+	if (!get_page_tag_ref(folio_page(old, 0), &ref_old, &handle_old))
 		return;
-	if (!get_page_tag_ref(&new->page, &ref_new, &handle_new)) {
+	if (!get_page_tag_ref(folio_page(new, 0), &ref_new, &handle_new)) {
 		put_page_tag_ref(handle_old);
 		return;
 	}
diff --git a/mm/page_owner.c b/mm/page_owner.c
index cfc31c92d765..39c381699a63 100644
--- a/mm/page_owner.c
+++ b/mm/page_owner.c
@@ -365,7 +365,7 @@ noinline void __set_page_owner(struct page *page, unsigned short order,
 
 void __folio_set_owner_migrate_reason(struct folio *folio, enum migrate_reason reason)
 {
-	struct page_ext *page_ext = page_ext_get(&folio->page);
+	struct page_ext *page_ext = page_ext_get(folio_page(folio, 0));
 	struct page_owner *page_owner;
 
 	if (unlikely(!page_ext))
@@ -398,14 +398,14 @@ void __folio_copy_owner(struct folio *newfolio, struct folio *old)
 	struct page_owner *new_page_owner;
 	depot_stack_handle_t migrate_handle;
 
-	page_ext = page_ext_get(&old->page);
+	page_ext = page_ext_get(folio_page(old, 0));
 	if (unlikely(!page_ext))
 		return;
 
 	old_page_owner = get_page_owner(page_ext);
 	page_ext_put(page_ext);
 
-	page_ext = page_ext_get(&newfolio->page);
+	page_ext = page_ext_get(folio_page(newfolio, 0));
 	if (unlikely(!page_ext))
 		return;
 
@@ -413,7 +413,8 @@ void __folio_copy_owner(struct folio *newfolio, struct folio *old)
 	page_ext_put(page_ext);
 
 	migrate_handle = new_page_owner->handle;
-	__update_page_owner_handle(&newfolio->page, old_page_owner->handle,
+	__update_page_owner_handle(folio_page(newfolio, 0),
+				   old_page_owner->handle,
 				   old_page_owner->order, old_page_owner->gfp_mask,
 				   old_page_owner->last_migrate_reason,
 				   old_page_owner->ts_nsec, old_page_owner->pid,
@@ -423,7 +424,8 @@ void __folio_copy_owner(struct folio *newfolio, struct folio *old)
 	 * will be freed after migration. Keep them until then as they may be
 	 * useful.
 	 */
-	__update_page_owner_free_handle(&newfolio->page, 0, old_page_owner->order,
+	__update_page_owner_free_handle(folio_page(newfolio, 0), 0,
+					old_page_owner->order,
 					old_page_owner->free_pid,
 					old_page_owner->free_tgid,
 					old_page_owner->free_ts_nsec);
@@ -433,7 +435,8 @@ void __folio_copy_owner(struct folio *newfolio, struct folio *old)
 	 * when subtracting those pages from the stack.
 	 */
 	rcu_read_lock();
-	for_each_page_ext(&old->page, 1 << new_page_owner->order, page_ext, iter) {
+	for_each_page_ext(folio_page(old, 0), 1 << new_page_owner->order,
+			  page_ext, iter) {
 		old_page_owner = get_page_owner(page_ext);
 		old_page_owner->handle = migrate_handle;
 	}
-- 
2.56.0.rc1.315.gc6ed9934b7-goog


