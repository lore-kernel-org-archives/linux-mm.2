Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9BDCFCCA472
	for <linux-mm@archiver.kernel.org>; Tue,  7 Oct 2025 12:20:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B48E8E0012; Tue,  7 Oct 2025 08:20:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 865E18E0005; Tue,  7 Oct 2025 08:20:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72D718E0012; Tue,  7 Oct 2025 08:20:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5FB288E0005
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 08:20:46 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2D63083B6C
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 12:20:46 +0000 (UTC)
X-FDA: 83971226892.15.DA093F2
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	by imf02.hostedemail.com (Postfix) with ESMTP id 4D12480007
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 12:20:44 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=dIaW7C8q;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.48 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759839644;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aTAgJkdvXfIYVJGWt9rTo9DrGAL0rL30tXGrZW/Q/UA=;
	b=BjwcHZE9fmH32s+3cCTHeu7G91CIe46Xrio64eUSd66tqjYj3UhRcbYx15JkG0Z79UzvgQ
	goGboEjeLoJXPqNG5i5NjFNGlGkzKF2/XtLWHcPY5a8tLs6mZnchRP1tBwvgI+FBSpgmQr
	yVMPmscyDBYZwD4Np/hwx8quQh7X4qA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759839644; a=rsa-sha256;
	cv=none;
	b=BFMtp+IGnsNHNo4agmwXvqVrseo4aejgAVarvvoQqUn3WRjQF2Bn2UYb/vtGYhfWDLz8IK
	K67TmAXcvxPxOsmyAyUY2wFw5ru+2u218SCVjOIHTsFw9V4GbpoFdYwVGyIHe8arAe0/iZ
	n1Ho1Xdg19HFltFkPvvq3XiwN1icnBs=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=dIaW7C8q;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.48 as permitted sender) smtp.mailfrom=urezki@gmail.com
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-57992ba129eso7137964e87.3
        for <linux-mm@kvack.org>; Tue, 07 Oct 2025 05:20:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759839643; x=1760444443; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aTAgJkdvXfIYVJGWt9rTo9DrGAL0rL30tXGrZW/Q/UA=;
        b=dIaW7C8qh6V6OapFa5xJ+yjwt88gVuU1AufCzVPaFS7yJtps0bLlpr77C8ksoLaGkU
         7XBpgdWl2mXRUIYQ5fhDbHXjzxDCo+pLnK3aALgBP4qE90JlK74OkXcEKgo25ZLSGtY5
         JQUtkQr6Q/EjJrc2jBOX5ExgNGKiam4PY30BP+ABC6lIjf5vSD5WpQm2+T2Ti/R/HYUJ
         gsUqWw+F+gDRIJFOzGjQrw3rRYfudQfU/BGBdGvNnJRYZLw7sNBc3ZNMBrVnL7E6eWef
         ljrJP+2AkXPGRGJLl4Th9zwwEECGoamDLcI5qQgMxKooXTwoy6oEhQft27wMk8Eyu3gX
         q1yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759839643; x=1760444443;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aTAgJkdvXfIYVJGWt9rTo9DrGAL0rL30tXGrZW/Q/UA=;
        b=WiekyyEQ18eZC6ZmTWqFXCWsCwlB58cJeBWajOwSSanXx2OFBLFHwNHFgSzMi3A1/q
         yXUVRd4SdD3EWM44gCkCeo7N0xnhOQWck6VHz/hjPG/gtDCcbTjHpbDXsV2H1SsbsyX3
         2W2tZFFt64xroUg3IL2TbLMi4mgwRI0sWsCDOUT8e5EPsi9HHfUbvQGkoh6zlz1fxHrh
         nrr6re55MzH9CDQk61LcqMqOBw1t75h+zNjwXqm9zuWRnInbbw/Z4A0SOUKRnTrOu4oY
         qNKZww2uNkp2Ni+pjqse1WTA0M5MNIlfUeQCZko3Dzg+txHHEp0KNzNHMkFgYXoUmSea
         3f6A==
X-Gm-Message-State: AOJu0Ywu3kh/G/JCoL2F0XtDCraYzDv3WvVR1/KeFBc9xZ9SzEMJkPa8
	N/+HUSk5eMJRRrQfi66evHtOmn5AAgF9gxPAL0Wmbu1Ixfp9ERvmsKDZQ2Fzi6As
X-Gm-Gg: ASbGncvXASMj7odFm6fiyv9hJK97ChEQ7v//ttxAm5BppsyBcpK26/JIGaU61EXXic8
	UVzkFZSAuDsUmXVzohdY+wEy84kOXGsabGywgY8u4UfGyR0n41XpBkb4yaD4whXVuAr0GIFjyEH
	Z9ZDrCI5+rL8lrD9wR5edsQejHFm9JXfgDB6vPADfu1KITUm18UVXp4GDCYdSmdJt+QAycToGEJ
	H6FahXQ6GQJjiYcPfEvzu81vuPPXBoBqCwgtuOWatz3B8Ie1PEjAbxaJ3gahhpsOzlahExeWGrA
	hw+km2PShMGJc/yY0fP5i9fplTmmsMhFerYkm1nCSbKOwt9LXbB+5OUluHNOLb+xoN+ZBMXIz2X
	RZQFYo21kY0Ki2wj/NEnPR6gzSVuodt3rkUlP54Vn
X-Google-Smtp-Source: AGHT+IFVcM3R4gXRnpw+tlnoSIwV5PNPCQsvct6ThdG/Q39YghEZIMUDacX/nHdSOJk06aKFSGKo3Q==
X-Received: by 2002:a05:6512:68c:b0:58b:2a2:2a01 with SMTP id 2adb3069b0e04-58cb984f07fmr5343552e87.5.1759839642331;
        Tue, 07 Oct 2025 05:20:42 -0700 (PDT)
Received: from localhost.localdomain ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-58b01141151sm6061947e87.59.2025.10.07.05.20.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Oct 2025 05:20:41 -0700 (PDT)
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
To: linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@kernel.org>,
	Baoquan He <bhe@redhat.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Michal Hocko <mhocko@suse.com>
Subject: [PATCH v4 03/10] mm/vmalloc: Support non-blocking GFP flags in alloc_vmap_area()
Date: Tue,  7 Oct 2025 14:20:28 +0200
Message-ID: <20251007122035.56347-4-urezki@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251007122035.56347-1-urezki@gmail.com>
References: <20251007122035.56347-1-urezki@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 4D12480007
X-Rspamd-Server: rspam02
X-Stat-Signature: ixkcbgjc768cm5gsxysk8q4gj4qat1ta
X-HE-Tag: 1759839644-38751
X-HE-Meta: U2FsdGVkX19jObp6GfoqkX9V96GPcKGbf/SOAMiZYPy4wOyrBzeN4GVHqS/WLBAaU61aURAUY3QWZa/JMQ4PwffTxDw7j4+ZWLXgd4lfODEL0ASoQdV0uLTKhOabOgiXCpRjpKNBW54tEFPVs6EzlYJJkdumddDtkIjsUsW1rYrRHC13w+euZ6ajnuKr8Tqos3zvAFu4aB2qVZBC5pMZ5zi5euFr7JgFIEmKF1u76VU9bY+LjOb4r/fqiIdto1ZaFSQvy0UoQ3WPwDzim7TTlCfk1tBPMUAqlvwjOiZMQ/LQDOW+V4FxuCFKlC4hmttswNT9mJAXCW0A8vlZR4m94OlR6ihqQBSmsl9ECEPE2gPi4Em3tlxxE2mt2kR2yZY513BU0108T3eupfK5kF7SGatCkgDjJ1ICTODYnP4RXbzy7kYyUpqssyx3z+eqTeiv+Fg0JLF0hOtdW+f3RgMVOXCapPYIu1HH8Wx55wFMectd9B/Cp7lk5lOR2rSBfahoJlotVDZrDf08ZFFt7E5CKVpMk3mpJSlQN4rutJlyjwXxGcqJKMyRrxyiBY3trSMS/80E2dBPLuy+E+7PwwsZUcMFq4jlX/QnmsQSdi2zfdJWv6SV7gCyKz5JJsRTQYu71r1fPNuk2VH2gMxZI+ikyCeyrlndGdCrua12z8LNufyPfgnG+OSL+vsB4bK/QGfCfoTDofBdbCkP5S15hJUGoYyC8Cufl4ritG1Gbxt11oI8OPbkFaPQSwT1Gt0hRbFZy+CNj/Bvw2IUA0EeUAAtHD06rWW2E/0YsU/GuOnkPAPkQyWVRCGtHz1M9SH63LluDKdeO4sqLmOrgjpWE7yPJlnpLe5pvljPJnTwW8i6h+i/v6IZcMSfGBEYGf7kSsJ8HK/LLDmt6q9WKvfucjNwXh1cMGB+nATwvopUGdJeMLqi48y24tD6+Ims/nXo9t+x6JdgzLYQiJYoBH5FyXZ
 JmCHATZQ
 aXx5qMRPLSeAfMCnnTydKivfZZ4vlNHo5EnfxVbS+i4qiVNrj132oGJAf2xUgQjvbIJRgM+hOO6Mv8gh+IrTvzvgszxowUSEQANyCGHHZt46KH9Q7bn4DxUxhNlRQX/c15TmD8duM1OgHoikRcgiBKiq0AXcyPx4ZWVOXPZZs90BYkkuly8qoBVZwZW9GGqcBBdLRzDFhamDi/Aabcft74Jy4EO9m869Wnz5NU49pPPtirS/CXDSTL0TrMkr/onYLv5ipOR+rdCQNhc26BvaC8F1KiwVjJjJJEfa5XdPGAh1ojg5AsPN4Zu/uQcLA7nf3N1xrJEiEkg6UHi5IXcpWoQvz/odBVly+c+7Uqtnj8X/BPxSPwCVHgEROjw8bEIU/AjLD5WNQJaG/5dL+k7E4Eg5b/okw8rxabPWOeHGmWkhP9KPAR7/3hXasjCVZzbGUgS5LXcug85LYBlfl3DMuikTNJRG7Is7V/s4HoQfxkQOrM47GOBFcPCDDWNzUt3icCqwEhg6WDAhZeDXojUazrhhL9b9cskko2/yxLH/IhFuH4/sb+6csc7yCOG1CjpN0cwYVVc/FgT61+tc=
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


