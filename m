Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E7BBCAC5BB
	for <linux-mm@archiver.kernel.org>; Wed,  1 Oct 2025 19:27:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E9FD08E0008; Wed,  1 Oct 2025 15:26:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E50DB8E0003; Wed,  1 Oct 2025 15:26:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D65ED8E0008; Wed,  1 Oct 2025 15:26:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C602D8E0003
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 15:26:55 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8DABBB729B
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 19:26:55 +0000 (UTC)
X-FDA: 83950527990.07.75F3291
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	by imf15.hostedemail.com (Postfix) with ESMTP id 9D69FA001A
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 19:26:53 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=AAtZuaU5;
	spf=pass (imf15.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.54 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759346813;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aTAgJkdvXfIYVJGWt9rTo9DrGAL0rL30tXGrZW/Q/UA=;
	b=4TwnurNJaL9Y7CjTjlQjGWBksGglvAO9gTQdRxAwR9Xyx9CRgcQdtZusU1PDSmHgtvz9Z1
	eHVnVG3iL4yA0kqIcZ584tMtN/wIPOgNSV1IKhX9m2FokDW9eA/Bu7BRoscw8RYo6Vw1Zp
	cW/BGMrgIwQ/nqpPOVUbcW/vFr3vBB0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759346813; a=rsa-sha256;
	cv=none;
	b=N1kFwMuTvrE1GoEUWVlBAA14eWIVuw0D8u+6CfrCHOsDZ7tNFC9oEhK7WlBzLl4LSGaID4
	VIWMVmJtTK2fU9QDjiQMEKMJsgsTm2UbH00C5a8sJYl744va5Oq3bQ4/3tG9FqET+SPtYZ
	LlKl8OLnANaYVCD4BBPZUrqE/60ezMU=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=AAtZuaU5;
	spf=pass (imf15.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.54 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-586883eb9fbso273524e87.1
        for <linux-mm@kvack.org>; Wed, 01 Oct 2025 12:26:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759346812; x=1759951612; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aTAgJkdvXfIYVJGWt9rTo9DrGAL0rL30tXGrZW/Q/UA=;
        b=AAtZuaU5DDDsYob6E/OCLNDKzUzs8hBJuFWN5Te4ntQxrC1aXniaA/w68VEJHXysB5
         hfRfT3hHqr3+0xoUjZQc9DWiIwkJtHO2F7hhAePt6TtzkMf5q8KxHflb36UuFGDmChDE
         B4j2LdaJ4i0Gn6uDur3aR+cAAk6OyQgyU6Q6rnmQx8ssBLYoq9N6BWuG+ijZIGWb/Pkh
         byvEEEy+ROC7Cxknc5n3b0/xVckCGen9s0YYlYU3vpFSoiELN4oRi4GmUB4bZsiXPRqf
         FWGTOF90GmmjhH7qBioUwmPWBwG0pNpwbQ2GgnPcAMwqVvVchhjROaqt3kUe8oBwsPNR
         CXkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759346812; x=1759951612;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aTAgJkdvXfIYVJGWt9rTo9DrGAL0rL30tXGrZW/Q/UA=;
        b=jNDvkQl74M5q/j0i/PaF4z8f6FEmhrr4T24l7BL5e6B3+6K1cFUv+YSc7ATZ9u9CNw
         ysc7HEMoaUVbTMLMdo2zLr7ICsYOQLka/3Ekqw/HklZFd09uK1sJUPTnC3DELwB4jvUs
         vqO8WUrolOouBs/vRjGwruPA9B5xnE+66zZI9c8vtjduZDI9uUdqeS0KPROAVe22GZtd
         Uqxy9AQly38Ig5pw0IIkJrES7FzrE7uKSnajzddX7GLlMhUnDRXUtjmBDILAwFDH+rpr
         Ryd8zc3uZRq/i/ZnFcO6cbpJv1aVK/aWzwJ5z8IijQ8JdyxsuOkgeqU4Xf+oNCmelAkb
         1lVw==
X-Gm-Message-State: AOJu0YxULUHycZXrbla7dPdoepfTEouJ+zL6JZ+/HeCE0tUxt+nNHwcW
	u7SownrYJUoDx3D5wn0sL16zhqM2PtKB4UZ0n1Y5nwW7MtLfEXSNTGpbL2yEEISK6Fo=
X-Gm-Gg: ASbGncttBjCuQO+rHpKGTvp8KDKIzhM0EcIbBwJ2/iQQAtmNSkX4fF3YPM2LX5gloSw
	vT3Ng3ofDMGcTMYhD4DUh9xhgOOastx3w4v3p/eOqlDEjNXz6zUPdjsu5qHUQMso+MANd2j45TM
	i5t3S1EcioqWIfUCAjI3q5uQ4aQ7tsJuxMPpR+Hb7xsWTDX6DhxSfpCIOrekRgMb+/A1ZwjZJTZ
	IOixZm6fwCSiJ8Gvh3ODIVFnDu0gdCzxJWGyQM0pS0jGiholS6VdxaZ1uOEL/OvuwujfgxgXhcA
	2fdSU7gLDUccwgk2MZbFWITaQ9BTnrXDlM6CUsq35+2CN84Hoee7GSllBLlvmpYUQxVAZaYHxwV
	5ThEW2exqwRS5OzcG6yMm4GQcwKaTu1dMpHh2x9G/Fzkdf0RfsmU=
X-Google-Smtp-Source: AGHT+IF0CvjRQv5Rhg8Uw4MQKskiae3bT7jASaj/mzoAEgMrKa+fqdv3aYo5M9392D4IA+uwz0Xiqw==
X-Received: by 2002:a05:6512:110a:b0:57e:65dd:9bcd with SMTP id 2adb3069b0e04-58af9ee5043mr1207622e87.13.1759346811677;
        Wed, 01 Oct 2025 12:26:51 -0700 (PDT)
Received: from localhost.localdomain ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-58b0112414fsm136627e87.28.2025.10.01.12.26.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Oct 2025 12:26:51 -0700 (PDT)
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
To: linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@kernel.org>,
	Baoquan He <bhe@redhat.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Michal Hocko <mhocko@suse.com>
Subject: [PATCH v3 03/10] mm/vmalloc: Support non-blocking GFP flags in alloc_vmap_area()
Date: Wed,  1 Oct 2025 21:26:39 +0200
Message-ID: <20251001192647.195204-4-urezki@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251001192647.195204-1-urezki@gmail.com>
References: <20251001192647.195204-1-urezki@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: gmepyuoxhqc6zs17h1onanoc1q3ux897
X-Rspam-User: 
X-Rspamd-Queue-Id: 9D69FA001A
X-Rspamd-Server: rspam10
X-HE-Tag: 1759346813-568235
X-HE-Meta: U2FsdGVkX19aIP+IKAC6GXCRYmKgOHFNlmlA25A4Oi/l/ErySMBLJdjrHp7qs2139Tx79gqgbhMfmglyN5uW3ONzjmRuMoIlGUloeeCpT2LmrPS0rfj1uwl0tqXDvDivLmYibhCzr9ok6zpDt7gCOncPCUZzfH1Q6QrSB9KP7n5bvCAoY1GP/zsNHFbExwRkPCuXQUvNOkD/WUTFw2jDxPkgThOnvj3x3d4JoOTzJHtYgjknM8t+nB41L791PtN+TpNVzB3jiyDCrl2+Lt9ypwI1jp0UcomHGCA8RLa+5qUdaK3Wdw6Nnm5wGHfQe0SUJgIgTXfjiDJeeYSyhvSRKRuZf+Y72M1lY/B/SL65ZIOL9i/pB6gUBiENZqfnRrXJMIcfqLnFEYp/W64T4+8nFD+RFHaqvCqYo724NEXZLnC4ahlPucE3nICMa6Cj7bYZfCPgSPpLw89OpOR7IAYR6+uiJlFGPbklUGVAeBAECjT5obmksHZcDml2eaV6RelkO+8SVjNKYwincm2+kt36fTZ5vFNDVp1MOn3lwt7Nrj5KuELC2WW595JDSYXLTwZbWmFjaBlaGa+N60OQdwTGxw1EBO3fDxMWxh5CR8HtoWKQ4Nmor6Wp4i8tIIf2VXxLYVZyshIjiwIIdPiys72GYly27XXaxksDEOv36Vj4yUiEAJpZn8RJtn8X7XPaBsqdE0CeY5GYszJ0p1QK+YLNvAi/AjiC6Z2eOJBwaKaL0/jDgYE0OzFnJmuzmdeDzEMfH2FSMUps4LbCNAi89WXV/zKziNgrfYY+ioOCoLkbeN5h5lD2WOdw7irSNQTsMzmfo5V8bUE4kcCplpdaTDzxxFIFlmX2JROfFZXVS89UCzFpyg44gEyjBCkGrTDAh9Q2NU0xy1s9gZifH8YRzxDpVSx/Xc6RRSIf9faIuKgE0ttt2IILqoaM3gcdWnUw2nZcaRt0D6+f2APodGDzrMp
 edMXsgr6
 TFaKI9TU4gNWdByRs9pMSP4lK6CWRD7N+hyt63o/H1yUugHfnFAGrkNHXA7H8qTnFL7rAxqLH5JKkLR1cUlQLUDZbsalcyFlFC431jk3fjb95f4gvscEvEqO1hyMpzWD18DWn6Y9P9aP5rPcN043sNQa9mkluy2HYkSjXfwp0xF8SU6vLnt8r1InaglDjLPkXlkW+KwmksR+z0u/qqUSWi7+QUURObR6RZfqH8QkCR2uCVksSoaVD7wOSXFYNp0znaLMnYjo36Fw3m420IzYUsF1E2/G+SWyw0x2BnZoNcfPkCsJsP6MKr3vMHJmLBvPxoagwMVAzbHU7WVTeR961DcXfighWsJnE4hMf04yr5zZ20g5X3WbRyErdkIbVWBUXUw47ypqPvQrUuq/516desn9AhXl5EBoBRh1MQsc8c6BDO5DrB1NedvJ13mwmVFeCM1acTctig0LfYcAvbsSYnSiwmWuc5IAtCthHSS/ApeGvoJdoOamAipY3W4M9atHSuUoUL+mGd3MaY/hNAxGxGTBv5eJpmb+X0O2JwoS2RXv9sy2zF85Crvy3kFez4gE1KS/AqV/tiokJcrg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

alloc_vmap_area() currently assumes that sleeping is allowed during
allocation. This is not true for callers which pass non-blocking
GFP flags, such as GFP_ATOMIC or GFP_NOWAIT.

This patch adds logic to detect whether the given gfp_mask permits
blocking. It avoids invoking might_sleep() or falling back to reclaim
path if blocking is not allowed.

This makes alloc_vmap_area() safer for use in non-sleeping contexts,
where previously it could hit unexpected sleeps, trigger warnings.

It is a preparation and adjustment step to later allow both GFP_ATOMIC
and GFP_NOWAIT allocations in this series.

Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
---
 mm/vmalloc.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 798b2ed21e46..d83c01caaabe 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -2017,6 +2017,7 @@ static struct vmap_area *alloc_vmap_area(unsigned long size,
 	unsigned long freed;
 	unsigned long addr;
 	unsigned int vn_id;
+	bool allow_block;
 	int purged = 0;
 	int ret;
 
@@ -2028,7 +2029,8 @@ static struct vmap_area *alloc_vmap_area(unsigned long size,
 
 	/* Only reclaim behaviour flags are relevant. */
 	gfp_mask = gfp_mask & GFP_RECLAIM_MASK;
-	might_sleep();
+	allow_block = gfpflags_allow_blocking(gfp_mask);
+	might_sleep_if(allow_block);
 
 	/*
 	 * If a VA is obtained from a global heap(if it fails here)
@@ -2062,7 +2064,8 @@ static struct vmap_area *alloc_vmap_area(unsigned long size,
 		 * This is not a fast path.  Check if yielding is needed. This
 		 * is the only reschedule point in the vmalloc() path.
 		 */
-		cond_resched();
+		if (allow_block)
+			cond_resched();
 	}
 
 	trace_alloc_vmap_area(addr, size, align, vstart, vend, IS_ERR_VALUE(addr));
@@ -2071,8 +2074,16 @@ static struct vmap_area *alloc_vmap_area(unsigned long size,
 	 * If an allocation fails, the error value is
 	 * returned. Therefore trigger the overflow path.
 	 */
-	if (IS_ERR_VALUE(addr))
-		goto overflow;
+	if (IS_ERR_VALUE(addr)) {
+		if (allow_block)
+			goto overflow;
+
+		/*
+		 * We can not trigger any reclaim logic because
+		 * sleeping is not allowed, thus fail an allocation.
+		 */
+		goto out_free_va;
+	}
 
 	va->va_start = addr;
 	va->va_end = addr + size;
@@ -2122,6 +2133,7 @@ static struct vmap_area *alloc_vmap_area(unsigned long size,
 		pr_warn("vmalloc_node_range for size %lu failed: Address range restricted to %#lx - %#lx\n",
 				size, vstart, vend);
 
+out_free_va:
 	kmem_cache_free(vmap_area_cachep, va);
 	return ERR_PTR(-EBUSY);
 }
-- 
2.47.3


