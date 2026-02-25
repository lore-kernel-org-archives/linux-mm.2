Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD68EFCEE8F
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 11:46:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 268A66B00A5; Wed, 25 Feb 2026 06:46:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2163A6B00A6; Wed, 25 Feb 2026 06:46:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 122EB6B00A8; Wed, 25 Feb 2026 06:46:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F2E476B00A5
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 06:46:52 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A52C78BDDB
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 11:46:52 +0000 (UTC)
X-FDA: 84482802264.03.EC29C4C
Received: from mail-wm1-f68.google.com (mail-wm1-f68.google.com [209.85.128.68])
	by imf29.hostedemail.com (Postfix) with ESMTP id BEF4D120006
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 11:46:50 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Gx2PD43K;
	spf=pass (imf29.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.68 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772020011;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cNc9GIaPSTJl+nOh/VY47x5Qb0/LB38ox3wV8xU//DI=;
	b=ZTdkGPXkaa2fmAlE3TisF2Fum7ScUfeMSeaDVBapepo/UFfA6rJDC6e8jVKCvKbCYCG7aZ
	whUk4S2tBkaxhauRoqierLpt+yM3yfHczyrd85bj1YuYifdnzDNt9ZqI+Gj77CFVuK4Rlm
	dEX+M18tR70LMjeMmwu0GxH5NSmlKJo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772020011; a=rsa-sha256;
	cv=none;
	b=xHTUdTJaFmZajtyLN3mYyphwAJ8ubdc6WlJUZ0a1VjwyhM15EujGfG/zGWqugnNT2D/fcO
	jrO/aoL1yhSj2pKiFxR9dBJ/8V14FLyRxsLYJumCzbhhy97DpBCfJ3WNOhr20K1E2j+X9W
	BK4N+aLaJtPY6A3duinifU5HOsjyvJQ=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Gx2PD43K;
	spf=pass (imf29.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.68 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-wm1-f68.google.com with SMTP id 5b1f17b1804b1-4837584120eso45744745e9.1
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 03:46:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1772020009; x=1772624809; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=cNc9GIaPSTJl+nOh/VY47x5Qb0/LB38ox3wV8xU//DI=;
        b=Gx2PD43K+oavVkWokAPGs2/xLGX0rvXhfwXhUmzgjCLQtsQowozwrz9RtMzDLpC5bA
         oX0K+ar4/O5HXv4VXzjh9Gg7mOynf8Btj7PcbUusG6xWYThfPKTYqbzi/TIfoYv0RV1L
         eRZdYP7pRiyLmkXojnFxmhd3UQYQhDNsf0kqpGiWbK5TnAzkYJ/GK+w7DnrR0CeMXDz1
         75mnJLKRnV5CnU3TqHeZXOpn7YXIHPD/Rik5uH7j45+m20IfwMirVVWLACFCIf0VdRFg
         mmEgYB9CEW2i5jBcllIIWVMufZHJch++YRTZ2voAccr7Ix/I1Ce6b2Y2uzIBR4VucOnA
         m23w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772020009; x=1772624809;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cNc9GIaPSTJl+nOh/VY47x5Qb0/LB38ox3wV8xU//DI=;
        b=xB+9wkfgb56iA5h/Kq5ExeJggpI7PhlhqkDbS9dk16SstA/AeJgC+U3e3GLu/XW9jl
         SbGJZ5OYPmacR5Hqt43H1QI5tDx+QRQ57UbMnsStnFNTHTWHY9eCZXC1ColTO0l9/8DS
         /ahACTcEODbG4BXxlyfrcVfelEW56PDadNNSxJ1/Ea/sXEo2hCW8jfr8yzj10tgmYpga
         s+o34K8lN/n9vQ6Tlekjy1y6/3bLeEf9LiI3sU6ksx4YKTGXY07+UJBFzU+rCa/iOJs7
         r0QgvncMtBcpIhOnpFx6FqLgyhR84vjc4JCwU1EAPJ0IqqC/PUPWkrGtc6eJqjhjm/HA
         MliA==
X-Forwarded-Encrypted: i=1; AJvYcCVN7F/ZwPtJtIQzkNxL/wPY/bWrmQFEYbmW8p+ntJ8avDIyGznuTptXG/gkmgkTx/zhkRd+xlmFOQ==@kvack.org
X-Gm-Message-State: AOJu0YyxLeZJupalFC1dhfXdsCSP3b/0lBn8cQDO+L5sI+dO0ix5L+VL
	pa1f1XKdi/oYOIxElZLDpBKtQSUFtQD7Ei/dMaVEsIuqXBK+pfutRbH4VSPF5KJoufQ=
X-Gm-Gg: ATEYQzy/rGImEkagmsIcUlRFE3QoX/4J0PEbmT+wG5d4eZmGa/jJ/2XMMbRvcxj1lJD
	HSGkZy8SGwUtlcu/X4bQPpOEa5aeqPrdT+3oIK5chYGmdbFrL8STT4krbPTIWIYLwz5Xg6iR2HD
	yy+sr281DVU411P8n7ZwS/uvRkfJk/CHwUE4ySlohfxmbuem3tmeytIjrVqYSB9ievnNFNJgzgf
	qazNXS2Uk20Bs7E9NQkSONLPmXGKDOKuElqlE7rF2Y3Sdy1tvL7bjW+n9a0dGDg8yg9YDBENs1i
	uQAPkX+kKMUn1AyDSIbJdNLDIv+4L0qiGNSv84fIXyxMskR/FQw/a2Et5Xme1Im1FI4d5LM6Y4T
	2tt3KEx/Pk0HAAKMP+kxUA/LFFnw/eEaJSwSKPgbZ4uh25KKbtBQ2hLPl0KT3MAn7jrYNlFvc3A
	qaYrVaYmeFWoIvpR5rMW3aiyAgfFVMLCY=
X-Received: by 2002:a05:600c:4f93:b0:480:1b65:b741 with SMTP id 5b1f17b1804b1-483c21793d2mr1738195e9.15.1772020008975;
        Wed, 25 Feb 2026 03:46:48 -0800 (PST)
Received: from localhost (109-81-84-7.rct.o2.cz. [109.81.84.7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-483bfcd0818sm10055605e9.26.2026.02.25.03.46.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Feb 2026 03:46:48 -0800 (PST)
Date: Wed, 25 Feb 2026 12:46:46 +0100
From: Michal Hocko <mhocko@suse.com>
To: Uladzislau Rezki <urezki@gmail.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>,
	Christoph Hellwig <hch@infradead.org>,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>, zkabelac@redhat.com,
	Matthew Sakai <msakai@redhat.com>, linux-mm@kvack.org,
	dm-devel@lists.linux.dev
Subject: Re: [PATCH] mm: allow __GFP_RETRY_MAYFAIL in vmalloc
Message-ID: <aZ7hJi2-iATBD6GL@tiehlicka>
References: <aZykWyxLy34o7PKr@fedora>
 <32bd9bed-a939-69c4-696d-f7f9a5fe31d8@redhat.com>
 <aZzPwsBp-Z4XM58U@tiehlicka>
 <aZ2N9a4XgxnurOhz@pc636>
 <aZ2YDD_l5JN78DJC@tiehlicka>
 <aZ3F2cghZpqBi1Mk@pc636>
 <aZ3HaVuIA4Ezu1uY@tiehlicka>
 <aZ3JB5Xm3SCmJW95@tiehlicka>
 <aZ3MzxtMp2OykAQq@pc636>
 <aZ6zwMQIj-3JFQZq@pc636>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZ6zwMQIj-3JFQZq@pc636>
X-Rspamd-Server: rspam09
X-Stat-Signature: fm68dmajmb4z91fdtpp85bny7dh3whig
X-Rspamd-Queue-Id: BEF4D120006
X-Rspam-User: 
X-HE-Tag: 1772020010-402774
X-HE-Meta: U2FsdGVkX1+Xc1Ot1mOhuUIILE2ix/mVEefjbNr164hTX8S47TFnOHUnWWXAykbTPDxpurTfgLKF+mCNu50ruQh9c4gvKzG847uVt7vGabOVYBuYLsI7FbGy6uFfWOuej8rOPzKAeq/Cd1pqsebqZnOn9/Fq6iEl71dAFxcDi+2J+0zlvxgwhbpPsk7GSKCUgPdfvxvWJjEh2uPQWavOxL732dTy0L7rSrslCGzZg1vBv+6m7vXfUuylq9v9jM6bc8pm3Rd0/f915CAe20R7YIJaiON72NRNmFvTd6KnnP1ZM9JCLYTGc26Ur6iss/GhehB8Tat9PRw3SUdTzXb5zdFda9HtN/g43J0Zf3pLfb8teiAkvqFsqDEPWtQKpWAMapmQ87yukw0hw6r6CqH1Q+uPuGBgyEgcBoYeEXW1Rg78uvJhO/r0SzAqqWbHazXJYTgizN+oOvL9FzrwSmTppihPX7WjCF5DlDZFVwczXkweXB4eSHwMcoJAalpWZSfyaRBV1Qt7/tFCLfEI2a1cijUSOJ9Ys6MsrLG11VTf8WyjFi9haoOerABEG8I6VsQSZrGeR/TNEx1L8JdHuIgtODtFkdfCbRB6B+XlT6f4ROPf0NQCqQ5xYy/ZnHx0CJzM0kvjqgQf5EhC492ApFg9rW+11WBosoKj2BNaBRDYcEh5JLtxNMpJpML+tdzJsYE0/cQGV4Sz1sx3viUo64nsjCztwPrEU/P+pyYZKjCtz0dM99IEOKLjyYRoymy3RoDhpzruOBqXDfjpU2XWGlwtykFYMjw6hjxW38ixTgYYyJfNRilhpGn+c5+ZNe6+X5rFfXqd7j41MWkto9KC/AC+vhz/wLgopx56cGjxUCVph07IlmzvFzb02eBWk/2dMipSaCEywh2vW+t4ygzI919QieEch3kYaT9iMrffuNBYTAbwd3uuryDlKSa/ktobog35r+d7sIzNcFCJnpA2LWH
 9ADlQI0P
 PEj4WpOJ93/NqfTZzK3PmrYYy/GdPNqFAF4n92hKvOHZO9tkOm90bEPe0cTvGo0wDVpG+4HEZr7tAVVr10MX6vcuUvg2hI6qDixjhLChOpnEhFkgovLqd4Qc6RN84rkaxISO/ona0n/BLUi5yTLAjJPSOjSUoJD/nTxAYiaC8LuVRZoXkPoktebG0CSj5ssu9RISWsHsRLzEW/iBfPoRK2nRmof4qSU9Q5ZIQxgp6JXUjCsprpS9iFIlFI2jgaVOxTqF7ld0ntJ6z9X4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Feel free to use this patch. But please note that I do not have any user
so I couldn't test it. So make sure this is tested before posted for
official inclusion.

--- 
From ee94ade23655dac7e239c1dfd2b04c0db3d10298 Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko@suse.com>
Date: Wed, 25 Feb 2026 12:38:28 +0100
Subject: [PATCH] vmalloc: support __GFP_RETRY_MAYFAIL and __GFP_NORETRY

__GFP_RETRY_MAYFAIL and __GFP_NORETRY haven't been supported so far
because their semantic (i.e. to not trigger OOM killer) is not possible
with the existing vmalloc page table allocation which is allowing for
the OOM killer.

There are usecases for these modifiers when a large allocation request
should rather fail than trigger OOM killer which wouldn't be able to
handle the situation anyway [1].

While we cannot change existing page table allocation code easily we can
piggy back on scoped NOWAIT allocation for them that we already have in
place. The rationale is that the bulk of the consumed memory is sitting
in pages backing the vmalloc allocation. Page tables are only
participating a tiny fraction. Moreover page tables for virtually allocated
areas are never reclaimed so the longer the system runs to less likely
they are. So it makes sense to allow an approximation of __GFP_RETRY_MAYFAIL
and __GFP_NORETRY even if the page table allocation part is much weaker.
This doesn't break the failure mode while it allows for the no OOM
semantic.

[1] https://lore.kernel.org/all/32bd9bed-a939-69c4-696d-f7f9a5fe31d8@redhat.com/T/#u

Signed-off-by: Michal Hocko <mhocko@suse.com>
---
 mm/vmalloc.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 61caa55a4402..86b912d38bd3 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3798,6 +3798,8 @@ static void defer_vm_area_cleanup(struct vm_struct *area)
  * non-blocking (no __GFP_DIRECT_RECLAIM) - memalloc_noreclaim_save()
  * GFP_NOFS - memalloc_nofs_save()
  * GFP_NOIO - memalloc_noio_save()
+ * __GFP_RETRY_MAYFAIL, __GFP_NORETRY - memalloc_noreclaim_save() to prevent
+ * OOMs
  *
  * Returns a flag cookie to pair with restore.
  */
@@ -3806,7 +3808,7 @@ memalloc_apply_gfp_scope(gfp_t gfp_mask)
 {
 	unsigned int flags = 0;
 
-	if (!gfpflags_allow_blocking(gfp_mask))
+	if (!gfpflags_allow_blocking(gfp_mask) || (gfp_mask & (__GFP_RETRY_MAYFAIL|__GFP_NORETRY)))
 		flags = memalloc_noreclaim_save();
 	else if ((gfp_mask & (__GFP_FS | __GFP_IO)) == __GFP_IO)
 		flags = memalloc_nofs_save();
@@ -3940,7 +3942,8 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
  * GFP_KERNEL_ACCOUNT. Xfs uses __GFP_NOLOCKDEP.
  */
 #define GFP_VMALLOC_SUPPORTED (GFP_KERNEL | GFP_ATOMIC | GFP_NOWAIT |\
-				__GFP_NOFAIL |  __GFP_ZERO | __GFP_NORETRY |\
+				__GFP_NOFAIL |  __GFP_ZERO | |\
+				__GFP_NORETRY | __GFP_RETRY_MAYFAIL |\
 				GFP_NOFS | GFP_NOIO | GFP_KERNEL_ACCOUNT |\
 				GFP_USER | __GFP_NOLOCKDEP)
 
@@ -3971,12 +3974,15 @@ static gfp_t vmalloc_fix_flags(gfp_t flags)
  * virtual range with protection @prot.
  *
  * Supported GFP classes: %GFP_KERNEL, %GFP_ATOMIC, %GFP_NOWAIT,
- * %GFP_NOFS and %GFP_NOIO. Zone modifiers are not supported.
+ * %__GFP_RETRY_MAYFAIL, %__GFP_NORETRY, %GFP_NOFS and %GFP_NOIO.
+ * Zone modifiers are not supported.
  * Please note %GFP_ATOMIC and %GFP_NOWAIT are supported only
  * by __vmalloc().
  *
- * Retry modifiers: only %__GFP_NOFAIL is supported; %__GFP_NORETRY
- * and %__GFP_RETRY_MAYFAIL are not supported.
+ * Retry modifiers: only %__GFP_NOFAIL is fully supported;
+ * %__GFP_NORETRY and %__GFP_RETRY_MAYFAIL are supported with limitation,
+ * i.e. page tables are allocated with NOWAIT semantic so they might fail
+ * under moderate memory pressure.
  *
  * %__GFP_NOWARN can be used to suppress failure messages.
  *
-- 
2.53.0

-- 
Michal Hocko
SUSE Labs

