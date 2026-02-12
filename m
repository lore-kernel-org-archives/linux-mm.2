Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 733BDEB48F8
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 11:29:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DAF096B0005; Thu, 12 Feb 2026 06:29:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D6E106B0089; Thu, 12 Feb 2026 06:29:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9B706B008A; Thu, 12 Feb 2026 06:29:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B9E8F6B0005
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 06:29:45 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 651511B424A
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 11:29:45 +0000 (UTC)
X-FDA: 84435584730.24.FA8CBC5
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.35])
	by imf02.hostedemail.com (Postfix) with ESMTP id AEC2780004
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 11:29:42 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf02.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770895783;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=U4Ql99OJ9qIgxTzuErKgw5AyVSatdhU7kE4LT06HM0I=;
	b=hIUQPrNb0wZTT8DQuxoRsMQw76e+2PV/BfCe7n0U7YKm/4t2CVlopllMgdvjVziqZsRVsM
	4TqV9SHhjgfILLb/tGD9/r/twbus6slY/vv3xPc4IMpUuTdtC7mLukc50bx1VhRjAcS+EH
	2wMsIcQRxuXeDpdsUCAN6iLXmCjUJag=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf02.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770895783; a=rsa-sha256;
	cv=none;
	b=iKI2cfG/a0UvTzzY23lsgAbKYPnEDsB5QSs7aao4ZQ15lqbAphkAzMbrwnM/dzZUILLlF4
	aGeuoYy8X07vuE2DYDzDl1AeZU1iLUnqv72AeQFqj1uallDGV+4QxGPW/AdoezoeMhi63m
	go3r5MkhJZWLVNuTpKqqaLAmnz4rN34=
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4fBY432Nsqz8Xs6w;
	Thu, 12 Feb 2026 19:29:39 +0800 (CST)
Received: from xaxapp01.zte.com.cn ([10.88.99.176])
	by mse-fl1.zte.com.cn with SMTP id 61CBTTM7085942;
	Thu, 12 Feb 2026 19:29:30 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp01[null])
	by mapi (Zmail) with MAPI id mid32;
	Thu, 12 Feb 2026 19:29:32 +0800 (CST)
X-Zmail-TransId: 2af9698db99c623-3d550
X-Mailer: Zmail v1.0
Message-ID: <20260212192932941MSsJEAyoRW4YdLBN7_myn@zte.com.cn>
In-Reply-To: <20260212192820223O_r2NQzSEPG_C56cs-z4l@zte.com.cn>
References: 20260212192820223O_r2NQzSEPG_C56cs-z4l@zte.com.cn
Date: Thu, 12 Feb 2026 19:29:32 +0800 (CST)
Mime-Version: 1.0
From: <xu.xin16@zte.com.cn>
To: <akpm@linux-foundation.org>, <xu.xin16@zte.com.cn>
Cc: <chengming.zhou@linux.dev>, <hughd@google.com>, <wang.yaxin@zte.com.cn>,
        <yang.yang29@zte.com.cn>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>
Subject: =?UTF-8?B?W1BBVENIIHYzIDEvMl0ga3NtOiBJbml0aWFsaXplIHRoZSBhZGRyIG9ubHkgb25jZSBpbiBybWFwX3dhbGtfa3Nt?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 61CBTTM7085942
X-TLS: YES
X-SPF-DOMAIN: zte.com.cn
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SPF: None
X-SOURCE-IP: 10.5.228.132 unknown Thu, 12 Feb 2026 19:29:39 +0800
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 698DB9A3.000/4fBY432Nsqz8Xs6w
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: AEC2780004
X-Stat-Signature: eqtrxbp37m8zyqff456w8wrjyoyfiokn
X-Rspam-User: 
X-HE-Tag: 1770895782-914698
X-HE-Meta: U2FsdGVkX18NC2AZeAK1YJns83CIC00beua+VpuKjbL6qelCzF92uBLx52q4fgENOMtc9U21dJTlaWrG9L11kP8z3ZMi9N8OZ+Ob8QQkPFUSK/Xib2q1IXWPv9zgv9/1yKCXsQSkGnY/GairBKKwWYiYzNzocAEdMFUyRJTCSbgOplzHSYY0hEePEPkQdZkmksJGYVpbfHwYiwRbWFV/gTK0UryMlioIcH5gO09UQqsIxRMK1QMQ6iRBemH9Tl3BduAjgwOA1XZ4qD6YOaG14Ub84OrXH0ebkd6k/rhBhvMjdaHrnT7+3K3SchdlKe3byzFQA0wvziT/I7JAutfNGYuUvkHSrc1g/d36bgMYcWuQKH3I0Tuo+VkwUqMdyRBwC/RkrfUw76PNzHcnmw+5z5JfGHIoM2t/IUJctEwYsBWteoAeAjNQJaqquYhAXBYZTDcBBJ7DFzPbuiYaDTeKYH8XoWcTbB2J0bo92v2k9bKlttvJ24tUKrOMQSgOF+Vp9Srd1nll6NrpuWzcsH+cZOcPwiyQUP+gaKIJ9L9BAuC0FwFCZ9XYhkbgRzeWnosrtMWn9gDIF43V5m4gWhgb2riXoD7vaVGLZ2MbfMMvHgJAAwHymL6YMvCfVH17dFXfob6Fbd993IpuleoqRSo4wlOFj24aoMBMVTxeJCs1RjrV1Is7HOGVRUjtkCOecgRaj2u2RV3KYNOtG3wrnZaA8/vz/VTlGIpYMG98QS/SHqxCZRsv9yadxO9R/uiIWfIyfx6iJn1m/vY/g6z3n/ui0tHyUvJy6yjh/tEH56B2vOEMvkDoGAqCz16mSLe8dGGOVTsKUcgITjL/3qFl10Ee/faORNA1fm90Mc9tMwgoGceg78Sz5mlZg3+EJzBNXXBxCv0ocR9ysoC53fZ9X99FLSeEOUaSmfb7fW2yfGvAG2qBtC0qE8HHzb1xKe+yzoU1MWNd6zCBt0tSVaZcZrR
 mapXSmI9
 LyjOkCesZnYeyz7R3la9QgW86H3M6pXzmQnW35wxAxV4XiFapYwmQ9KlPnR/YCFDPqyND4lJaFQFFzmUnfdvvAl4ImGxXHvKRiHbZfe8r//+xU1XMpwQ4kVmxKNgzDj44V61Ons74LmAbE692dQLRJgByOCD4KfaAiFuOV6/2ZHLSBccjyRixPELjZuzbz7SE2jLEnULmAKl1eGGmposDJ2hmElzGQ5GfYTfks6D5F+cpTvB/Xh0XES9TjvKOD7tkx6e4rrGLdFmWqcjj3zthYZeH4ccdLzgfm2HXCXt0KiwwooVkA3O4gLdLHIt2KlXd/C3WttD5BgmYRTjmUMqhRHVVtDdTY/1jHj7x9+4o7g1szeQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: xu xin <xu.xin16@zte.com.cn>

This is a minor performance optimization, especially when there are many
for-loop iterations, because the addr variable doesn’t change across
iterations.

Therefore, it only needs to be initialized once before the loop.

Signed-off-by: xu xin <xu.xin16@zte.com.cn>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/ksm.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/mm/ksm.c b/mm/ksm.c
index 2d89a7c8b4eb..950e122bcbf4 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -3168,6 +3168,8 @@ void rmap_walk_ksm(struct folio *folio, struct rmap_walk_control *rwc)
 		return;
 again:
 	hlist_for_each_entry(rmap_item, &stable_node->hlist, hlist) {
+		/* Ignore the stable/unstable/sqnr flags */
+		const unsigned long addr = rmap_item->address & PAGE_MASK;
 		struct anon_vma *anon_vma = rmap_item->anon_vma;
 		struct anon_vma_chain *vmac;
 		struct vm_area_struct *vma;
@@ -3180,16 +3182,13 @@ void rmap_walk_ksm(struct folio *folio, struct rmap_walk_control *rwc)
 			}
 			anon_vma_lock_read(anon_vma);
 		}
+
 		anon_vma_interval_tree_foreach(vmac, &anon_vma->rb_root,
 					       0, ULONG_MAX) {
-			unsigned long addr;

 			cond_resched();
 			vma = vmac->vma;

-			/* Ignore the stable/unstable/sqnr flags */
-			addr = rmap_item->address & PAGE_MASK;
-
 			if (addr < vma->vm_start || addr >= vma->vm_end)
 				continue;
 			/*
-- 
2.25.1

