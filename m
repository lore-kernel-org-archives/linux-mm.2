Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD027C5AD7B
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 18:10:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CCE476B007B; Mon, 10 Aug 2026 14:10:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C7EC96B008A; Mon, 10 Aug 2026 14:10:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B94626B008C; Mon, 10 Aug 2026 14:10:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 91B8D6B007B
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 14:10:13 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 29F30C0190
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 18:10:13 +0000 (UTC)
X-FDA: 85086149106.22.EC2E520
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	by imf16.hostedemail.com (Postfix) with ESMTP id 25DD4180009
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 18:10:11 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=lZPRS9fO;
	spf=pass (imf16.hostedemail.com: domain of jannh@google.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786385411;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=MxlbjW9Gub36tupqbS+bClfYkYoCr7n6Y2ztqAqDsEc=;
	b=Oj2lZt9zxdoPJt6hkySWWI3Jq+CnO9aditqVyDwX8qGNshymGTGeSDHKJ1z6j2RUdbWodP
	nhNtsK7D8WYQkJZoh9kJkU54r9xhHiEaiQVyaMQ4P+Bov8qm/lf3V9cC750K6Wn66UkAsu
	r1wZJVZ+T7Tq84Z4pddIs9bCQwDre7I=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786385411;
	b=srmHUh7zm98W8uIbAXpjOwYZf7f4uYIvItXV0IAqYT3wnC0Kv8ZOfXVl45FD7e0Jpaz1Wb
	zAq3yeFg4WlU/6GVa2hqTAK9yLadqhhbsnJK4Loc4FDyUiEIXWspoRUzKbB2hZNYLBmn7H
	hVCXxENE4rlxseUjGNOC2wpMcCx6iOs=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=lZPRS9fO;
	spf=pass (imf16.hostedemail.com: domain of jannh@google.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-498012a61f6so6135e9.0
        for <linux-mm@kvack.org>; Mon, 10 Aug 2026 11:10:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786385410; x=1786990210; darn=kvack.org;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=MxlbjW9Gub36tupqbS+bClfYkYoCr7n6Y2ztqAqDsEc=;
        b=lZPRS9fOYjuMa1C0M4/3sFN20nXarEkE7IdmVVHTs+Db1iP/Isnu0b7llRKyUxfVh6
         lvjaUyybhiY/qsR393ZwufrtOfB/Z2oGnZRenYMm0DYo0dI1H1xuNgUKEq34kqGDBJ4d
         JTu84to1jffZ0j3rYdM2NG+zOqrUTDIrEO6Md3U4H6PU3JpjUatWPo5IqszcmfOhHYlF
         zQqd3WpP9ebEcZyPVKWlPZVySOm5/IxtiPef/ME0/ybLEU2qQMhd5D/D1YH96pKhrkIz
         6WxuiWaCURA7D7dUXsK6EC8MjPw7jPDzLWN30W3zL5Jeaf9m7AXNHvTUQ1c0nyVWvN5S
         CMrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786385410; x=1786990210;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=MxlbjW9Gub36tupqbS+bClfYkYoCr7n6Y2ztqAqDsEc=;
        b=ibgUZA5UzKUOx+JfdTvTGdmXEP/lnXJcw+uA/7XEjnV0O/nMVwu0xtqpce8WUdTZeo
         ciMMbH6CbszuXhTmll729mm+qgh49MdL38hPd2YuD7eD65vrAznKWLCtR8Ew6zgtfEea
         OSi9ULcPcjiAUJxjwW6KfRZFlfqYKKQlcAHiI02tBEkOGRkI4cL8PEg5PHOai12Jlivj
         MD1YS8+uAOcBvdoVz0CW14tSNx/UFbqhacD7VRtGuA398LayXrzswdm2uDG0Lje9xvxz
         QBTHphREp82LbzZ0syRdi5tjVZEvQCiBW6yVkQICTkiCy7OroxVdDY4Lt46UvVUtxnvX
         9IKw==
X-Forwarded-Encrypted: i=1; AHgh+RrODHIXeyW+qV4CeFVf8DA9K8rf8Dc6DoQEJHVuiv7XP3h6156o1A+z4ATdP1mmSoIQyEkMviciwA==@kvack.org
X-Gm-Message-State: AOJu0YwhcGVkpOUE9I4cKeJEnXHuYk4Ts7tQ4n/4vem3PpdERCifW891
	enEdsdAZRVxVMHEow3z4ONTMwEYfYHnqeAXsxjSIFqEOoIy83iuiU3pELV7/ULZXDw==
X-Gm-Gg: AR+sD10BBlNLcZpxthYFrPC7dvS8hzONagP/ChyvMOLqFIwDtX7/n+SCdb/sMutUgjO
	BGwtIc4PC7ddnHkibMAxXe1PDZFYpdykN2UQXHxm85Y+9XbVUL9X447jU9KbtzUwsqgPDu8d0G4
	Wf7KbuBDU4ipbA1qZtuZawrsPD52OaY8O+UDEwrRRN9GWIorcMviQA9ysA5Z99obrbCHExNvPM3
	XRC6QlDZ673OXwM8emVXaCsvSsVl6HAIoa49R8fRR+y9CQ1p2UBE1o1AU4GH+l5mFeeglp5YZIs
	8s+3cN0TOjxtK8ejD2SvORxe6b4/LcplL1EZMoqNwxxpCWDvQz3SCu5T2kyU0KLs60Q7nqWTsgJ
	AH3mzoAqc1cf7Fd/SEROVbo9Zr+Qvc0myhoh1RTmN8gydenCoI6RaMoavnkVW3o0mK1Ss4o4glb
	GB/H4Y8zZGVC7pXKjGUth9/s6TN0ut5bYOd+k2Giu6UY/qw7zgFmrBboe4dgs6/WJD1Y55D8gka
	zyQ0g62IvR0Vp36ADMkDF6sStASmmvDegQe5tLVwBRYFMs=
X-Received: by 2002:a05:600c:4288:b0:495:3ffd:5e39 with SMTP id 5b1f17b1804b1-499745be994mr58225e9.3.1786385409115;
        Mon, 10 Aug 2026 11:10:09 -0700 (PDT)
Received: from localhost ([2a00:79e0:288a:8:5c4:b02b:cff6:9cc6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-499740e13e3sm9004625e9.10.2026.08.10.11.10.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Aug 2026 11:10:08 -0700 (PDT)
From: Jann Horn <jannh@google.com>
Date: Mon, 10 Aug 2026 20:10:01 +0200
Subject: [PATCH v2] mm/page-writeback: document folio_mark_dirty() locking
 more explicitly
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260810-set-page-dirty-warnings-v2-1-1bd40fadfacd@google.com>
X-B4-Tracking: v=1; b=H4sIAPgTemoC/4WNQQ6CMBREr0K6tua3gCmuvIdhUcunfKMtaStKC
 He34AFcvsnMvIVFDISRnYuFBZwokncZ5KFgZtDOIqcuM5MgT6AE8IiJjzrnHYU087cOjpyNvAK
 AHkDUZVOxvB4D9vTZn6/tj+PrdkeTtrutMVBMPsy7ehJb779lElzwujS6q1QDCtTFem8feDT+y
 dp1Xb9B6MN50QAAAA==
X-Change-ID: 20260810-set-page-dirty-warnings-4000f0015394
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, Jann Horn <jannh@google.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786385403; l=2530;
 i=jannh@google.com; s=20240730; h=from:subject:message-id;
 bh=bJXRfg3f1kV3ccy2QSpAR+7YljKtfWl7hXv2p8G7tDE=;
 b=df8Qhd2Ukq3GZytYeSVtH/STCIAEcIKcgxQNFYPewQdmLafxN/6eI7SK/34O21LsVc2ZWwJz7
 KDS3Rs9yYdZCQoVCsnjhEF0af9LPwr0Xw2mJuc5ohMjYJYaw+SCGnq8
X-Developer-Key: i=jannh@google.com; a=ed25519;
 pk=AljNtGOzXeF6khBXDJVVvwSEkVDGnnZZYqfWhP1V+C8=
X-Rspamd-Queue-Id: 25DD4180009
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: 13pw6e81gc3bbejzkyk8bwrz86mknf4w
X-HE-Tag: 1786385411-754978
X-HE-Meta: U2FsdGVkX1/0v6A2m2n7blfq8F7LT8146NMXvWjUvbXsGSbdd70khw3h7PkmFqKVk+SgQymLiXFyEOShqeNsKzHGWNRSEDC7DwID9D7PzQNYy40aJC7LBq+ZkH9KPCQXQjnO4ElMgS/uvjPhuX5x3/wbpgDQcVfsaq47JBQRZABQwf8yN9DFbWzUt2X5WbeRsH0spoCSgMDdpm8bos1wl/sub4rHRfuvWSfZJhdulgqgHZ+XpfOAmXY8ETEfndxt7aNG3RyDBen/k3M8T/oQ/Y5AmQOGR6HES0VN5Et2weY+niDZYW5tS0MJwNgPuB+5hwABLD5l5g7KMA8hNnNEstf5sLfyck14ivSXxbthkKjrdHdHv4ibFTAA5O4t94EoyrMQ069zZSUATV4U/kNdy6GR0H3UNqrellgklOfG39jY9xvPCmUElZgBIxXa4IP6LR6amCoKw1v8rwcm/ffo8OQrQ3vN4yBIfWkuWtFkV2guJyrFCasfn1Thv/O6OuLNDdxoJjg+oQjnkdJLtZlJh7WNzNNAXwzSS955S7o7hubdpgNllQyld2GvDYZF1B/F+CAiQcb0posYRL78aynIA8XrgdvgkbizwXXPw0Cq9sqeKSj/HOWzgZr+/lNkCMrE4VVYdWBl9mLBwU74LMOPWnFAXI3dX8d7Ekw/oYtZmWVaTHAErVs7ZtOrtj2Ea6S/WGPaEbrHG0fg2LTV+4oFbWRAY95rjBADn/otv193xeZQ+f2jJJwAr8b8DG6GSZoMG7tom8WKJB+8ap1I6x1L/jH5e7M+pPCvFLMW5B+KT1qT5LZ9oNMiD4hrCjkSjsWwQNVV/M3bzGY5sl6oqp4LnZFfGXAb9h2DwvhegY0utl0rH7DzUb/iY6Dp8UFeEjK5V/+wD2ZSz4riWzlXVPrpPaNT+5xH6i2abcSzkF5w/FMKYaiCnDozVGpe1tf25rHzhC4YlTNpmUeNmrD+AsQ
 tQzwutcF
 eTIMy3plCZ37Dsk6FDr0GeXYoTaNI6n1efV1XE7jzA+4L2SEQbzVW8FukcHkP1XRIXOiX89BjU+BB6vEASxFR1ksGYEGj4UYy5JLtnSYeNEhSwdmTNOXMldhs1u7s7+TEWn8oQzORaVcqOOIpS56V3InEuJ/Aqwt6t333/6DLJg9/16AZbYYt8mAFK+D7Nb9xnrj0NiKTCNCExN9/PCKq0qSpKO6fpvg5Un3IRGzc/qeoIYGdFCs5jpV5KyTjC0ZfeHElLAamwl5eQizqeS3uTD0ZFwDZFgDIt8JF1KFphnJlv4W46CjlUu9KT7dYWtrsslhOXAWFJHgj6ONlpAyiFWU8Fct3Oax1XoCjTbPzo0esevvPwqpJ652JF62ILf1cumoRc6rm0LWFZ8DVUClWdwnZYE2JGrPqemwiwBhSaawgjsd8usRRccdg3OfaLVa1HIiTiYsIFPWb4CGmp37R2enIKNR4iahnf5MMCgmms9doiqtym3xm7yA+K/D0xhBD/kRbMuOeDFRk1+c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We have had bugs where set_page_dirty() was used on a page from GUP without
appropriate locking, leading to UAF, in:

 - KVM, see
   https://lore.kernel.org/r/20260810-x86-kvm-setpagedirty-v1-1-85f180892d4f@google.com
 - i915, see commit 0d4bbe3d407f ("drm/i915/userptr: Try to acquire the
   page lock around set_page_dirty()").
 - VMCI, see commit 5a16c535409f ("VMCI: Use set_page_dirty_lock() when
   unregistering guest memory")
 - kpc2000 staging driver, see commit b6d13bd9f2c1 ("staging: kpc2000:
   kpc_dma: Convert set_page_dirty() --> set_page_dirty_lock()")

I think set_page_dirty() and folio_mark_dirty() need more explicit
documentation on how they should be used with pages from GUP; so add a
comment on top of set_page_dirty() and make the comment above
folio_mark_dirty() more explicit.

Signed-off-by: Jann Horn <jannh@google.com>
---
Changes in v2:
- reword commit message to drop references to out-of-tree drivers, and
  instead add more examples of upstream bugs
- Link to v1: https://patch.msgid.link/20260810-set-page-dirty-warnings-v1-1-53cad4890808@google.com
---
 mm/folio-compat.c   | 1 +
 mm/page-writeback.c | 5 +++++
 2 files changed, 6 insertions(+)

diff --git a/mm/folio-compat.c b/mm/folio-compat.c
index a02179a0bded..6212fdd6761a 100644
--- a/mm/folio-compat.c
+++ b/mm/folio-compat.c
@@ -41,6 +41,7 @@ void set_page_writeback(struct page *page)
 }
 EXPORT_SYMBOL(set_page_writeback);
 
+/* Read the comment above folio_mark_dirty() regarding required locks! */
 bool set_page_dirty(struct page *page)
 {
 	return folio_mark_dirty(page_folio(page));
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index e98748112d1e..b0ab687c83be 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -2773,6 +2773,11 @@ EXPORT_SYMBOL(folio_redirty_for_writepage);
  * in this folio.  Truncation will block on the page table lock as it
  * unmaps pages before removing the folio from its mapping.
  *
+ * .. DANGER::
+ *    Do not use this on a folio obtained from a function like
+ *    get_user_pages_fast() without holding appropriate locks; you might want to
+ *    use set_page_dirty_lock() or folio_mark_dirty_lock() instead.
+ *
  * Return: True if the folio was newly dirtied, false if it was already dirty.
  */
 bool folio_mark_dirty(struct folio *folio)

---
base-commit: db2ddb87143519e20a95aa36c60b36107b736a58
change-id: 20260810-set-page-dirty-warnings-4000f0015394

Best regards,
--  
Jann Horn <jannh@google.com>


