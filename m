Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66BF5106ACED
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 20:53:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E8EE6B00AA; Thu, 12 Mar 2026 16:53:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A7EF6B00AC; Thu, 12 Mar 2026 16:53:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3AAD36B00AD; Thu, 12 Mar 2026 16:53:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 261276B00AA
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 16:53:40 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DDCC51B7E48
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 20:53:39 +0000 (UTC)
X-FDA: 84538612158.20.EF051E0
Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	by imf16.hostedemail.com (Postfix) with ESMTP id 1F9D518000E
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 20:53:37 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=FotWwmlV;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf16.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.50 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773348818;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kXGfWWKzNbxM79mVGdQBIJH3/Y1RdaXH5DLrm3GtnoY=;
	b=t4Whu1KwkurzMkv1PbFqsII0MGHtgZBrsC2e3rKK9aZ+M2hf9/Vf9CL6sEM2uYRbjTZPz7
	OKte9va3Se4h0NSxBnbeUM/Va4d+OK4HzYhvyoFtS/DjeHD2NVnZ2IWvgUGsTujy0UCIUn
	HeVWFFjR64mW04LYQ76uAkZiv8C9gO4=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=FotWwmlV;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf16.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.50 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773348818; a=rsa-sha256;
	cv=none;
	b=CflTJ27mDFj1E9XWrJ0sUJhbiFSU9uwxT+vPsSHXVAVnSIqllKtmA08uZVprdnp0/fSpgZ
	SjQzNNpeNcNAzXN4kTPfh2sFoV1+fDcerongwdHbeURr90upWwN09Kmypin4tHd0/dZGcQ
	mrOTov+4QRYhow/GM+aN6j0DigvFvBA=
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-89a1d7cc7f0so13427916d6.1
        for <linux-mm@kvack.org>; Thu, 12 Mar 2026 13:53:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1773348817; x=1773953617; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kXGfWWKzNbxM79mVGdQBIJH3/Y1RdaXH5DLrm3GtnoY=;
        b=FotWwmlV2oYDTIs2JzHpWgoDgmgVq5hrya64YqcA6V972hHxpqqYNt9RXeFriuW1fz
         oS1PWFmCqyiZXm9VlvH/CgSAvv52p4ocwue5TXZOkZj8LrlMwGcLkQPj6OwH/imu2Ray
         /TQahGE3NEDh90cM3p1czxHHj/wckhcvon1/Yl1RnlrowkPmy/S0bGRGgqA8i8YD0j2Z
         UzIAVtbR2eqEC5j1sLbxEmSlGHg1B6Yuk32z0E6znDjpYnmZiFDm7O9rHs0tXfZg3a+R
         cnRM2KRFfHLrsD+3Pa3eN+Xsc2c2fsfoHJfXzZ+yl2wgFf284qscaChPKVYcGrez0WaM
         +CRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773348817; x=1773953617;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=kXGfWWKzNbxM79mVGdQBIJH3/Y1RdaXH5DLrm3GtnoY=;
        b=ppJxKqTqrvmqQ2ucmLIWYNPNUZOCp4FgkuLgXvtqj/25jqRlsVmHNSNbhNrnP99+LI
         u4ABbUegTogRFd3gMVBJTiJKrLBqSuPtjFlBIzqOCkCob7pmDs7oCJsVZ3A4aowE+iT5
         WysQdgOZfbCvFJsF7DEApQxTYiR538QMQZLDbOq/ilwSgyAMc1KvGs7DBZxYkneKyJwF
         C+esjWZ/R8PzMwQfSvvtIMJNzU0quMid3rxMo6N1DrMQH/LezanrrktJOyocJaVAlh7o
         LaBhIX38t425NNMxbGU7/Z+iRCqmo1YROvaiOkDvY9EPPleqEo/utlEVQc2p5SsDa3Jq
         mBUQ==
X-Forwarded-Encrypted: i=1; AJvYcCVMsJjCApRuUVRF5k8q+aoEA/4BRmFLlxbj5O+/cAI1XZmFUiioi7P/lxe4EpkMnPqTiafMC6+G4Q==@kvack.org
X-Gm-Message-State: AOJu0YwyC9jySKFd6jY/4b4wM4xNNl6RizXUIUa/XtZcj9On7ZhVjLKW
	t0vH+sb/Kgwl+H+P87uhbXfp62ZTucJoD4726rHt5B1F0gkHbqZcfIKFL5HU14jxeMg=
X-Gm-Gg: ATEYQzx5srYbYzFrCuTbU7w7YaUh/osLx7FIjVnvPAMaodPDkFC6/b33KrEsxzSvus+
	PCnWCOskPeEbRlGhHqwipRu6dlc4GKhwzkkD60RfljiADU2DkG3vURuO/z4AJLJMUJMSFz82LKT
	Mo5llJnhJspJbUvDWFJNU6me1ID2ie8PwrCJTCH4oSAEgWvXarRG4olL3ZlR6bT0tScF5UQZV6/
	ARi5l+lIBuS5ugJ8mCsl2Bhm1PfiCuQwm7Ai6hWwb6DlUU6KPuOR5+QtPumf4D7pKVb/LUy9pKB
	InX+ZXP6iSpcw5YTZObKk7T1xpNIucA/q52BHlCqXFsOvgBLQSswlDrpabuzL1q398i1CYC+DiP
	Fr92+EVEcNWTzE7qFjYv3RNjjPCWe1N4sYfVdUx3bfXK+GcC+97ImjRSFKAJjJ4A+AeCVsf91jm
	zkURbUQgTGstKwXA5tAQXPrQ==
X-Received: by 2002:ad4:5c6f:0:b0:89a:6e62:1dd1 with SMTP id 6a1803df08f44-89a81fb92c8mr19060666d6.60.1773348817112;
        Thu, 12 Mar 2026 13:53:37 -0700 (PDT)
Received: from localhost ([2603:7000:c00:3a00:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-89a65d17023sm42324226d6.49.2026.03.12.13.53.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Mar 2026 13:53:36 -0700 (PDT)
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Zi Yan <ziy@nvidia.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Usama Arif <usama.arif@linux.dev>,
	Kiryl Shutsemau <kas@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 4/7] mm: list_lru: deduplicate lock_list_lru()
Date: Thu, 12 Mar 2026 16:51:52 -0400
Message-ID: <20260312205321.638053-5-hannes@cmpxchg.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312205321.638053-1-hannes@cmpxchg.org>
References: <20260312205321.638053-1-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1F9D518000E
X-Stat-Signature: x47jz73ey87399tcppybxquxaqeco8eb
X-Rspam-User: 
X-HE-Tag: 1773348817-876445
X-HE-Meta: U2FsdGVkX19AnDNIAa8zenyE2jRNjrBABJrvjNhIdxWQtMS5jf9ypekm9vaNx5UF8V+5NDpnZ0cbsstF5AFX0tqmQopvrPH4eqc64I/gaE5IPdZseGJcshuJKFlv/QMqcFcf5iVgjaIDIYoCGevIN783Qz4K21ybJ021ibwaX5FMmUyBTOWenX/PrXsYPw4nMBp8Hsy3ZnvIAqw0k5ly0EBdC4aAj5m2i2GEZ+8pqBbyRPuKyDcCeMADm9elBmjfkJ63qSffCw9+MYyJSOA9V4GQLlX+uWudn6HUGh+wEvrm+xaJO/WPJRD0GI8wWPBSxBaII/+IGv/8FFEV02uFF4CiPckyxkcj1oZUyNh0CC79d8rwcWdFjtkOz1sOAGF/xGTSJo7Md9LbIYUUlg+2T8itAC6R4m6KDrKlP3bMcM275ip8pgXeKgQjqLerJpcTxMQibFWA2kgYMu+a7z8xdM82qucE+xGOqwomycvpnbkLvRVkbH4FwsncRXs2NYSYA94CU9TWB0Lm0QpgBnl5M5HijniiW9eQIY3ZC4FmEwMd+41ZG5MSUYGLzq/ZyPlfwj12JO3fi5CgWRizR8mu1D3hXUgm1V04idUJikqOuftpa5sEOoz7orXaVhntezLrVtnai/XieYpgeUUCSlWNxLYyYi0cGK+E+1OKtYC+jh+5QZrYm7zBNRmvfJOJzNlkrnaOhvAx9zq6WV898pOS+1Kt2JXs8YsXwrXWSSZdMXi/FqJeWBuwrTpicwGiiBmJPIOt45gZ4oKrgGG/i4WJi2DkerrLuy26V065haJGXbzxN4ETp7zWgRAc3qosM3BEfs67CRg8v9QIr8q9bgjwflJr67us6Z5KZBveZ/DCcD1i4b21+STcKVHxZHIOykm7SZu2WDeTB6k3x84XMJ9ci3AjFRyu10kW227yk5nS8UVJY619TP2JRPOc4M95yILv/ih1rgzfIcWi1IE/6p3
 WqY0Er1B
 QrHbtpF5dvsHrQLpsUuqA2ROTgubToFn2D2XE65lUdXZv8eTqNBYNBDo5a38R4jzExogfAncq8xLKrz6S5C8WNKdtcRSUyO54jwfhrNPPQjYWdOz8NZFZ0MgOL5/BNLsLG/1lniidPviYVVQLe/V8kHZaRd9Azj7SymYKoQXSbJmBAUt28xG9Oroscwgxn95eVaS25JjC5OEgmYqiEJLX1xn878ogiegM8dzZJ7K0NyDDPIo2GnBGj+ilIfnxZpVrLngFWJSXdEypZsbgOsAkEiQk/twduBYB9A48kaTULxVquW90urS2Q9/AsXnpwvrrR78Z8Z9Y5dVZxXsofnUHVsylHI0TIxABNGMo839gGs0d7AzNTahJkw4NLguEYC8Il/sKO88zdGUxYG252BcVAGz9rfnRs+D2RSVYv5xl4ScEQQnALoRj2nPV0SSVdh8Zl5e55gOH8wYdVdJXyGBve6M0rw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The MEMCG and !MEMCG paths have the same pattern. Share the code.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/list_lru.c | 21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff --git a/mm/list_lru.c b/mm/list_lru.c
index 1a39ff490643..4d74c2e9c2a5 100644
--- a/mm/list_lru.c
+++ b/mm/list_lru.c
@@ -15,6 +15,14 @@
 #include "slab.h"
 #include "internal.h"
 
+static inline void lock_list_lru(struct list_lru_one *l, bool irq)
+{
+	if (irq)
+		spin_lock_irq(&l->lock);
+	else
+		spin_lock(&l->lock);
+}
+
 static inline void unlock_list_lru(struct list_lru_one *l, bool irq_off)
 {
 	if (irq_off)
@@ -68,14 +76,6 @@ list_lru_from_memcg_idx(struct list_lru *lru, int nid, int idx)
 	return &lru->node[nid].lru;
 }
 
-static inline void lock_list_lru(struct list_lru_one *l, bool irq)
-{
-	if (irq)
-		spin_lock_irq(&l->lock);
-	else
-		spin_lock(&l->lock);
-}
-
 static inline struct list_lru_one *
 lock_list_lru_of_memcg(struct list_lru *lru, int nid, struct mem_cgroup *memcg,
 		       bool irq, bool skip_empty)
@@ -136,10 +136,7 @@ lock_list_lru_of_memcg(struct list_lru *lru, int nid, struct mem_cgroup *memcg,
 {
 	struct list_lru_one *l = &lru->node[nid].lru;
 
-	if (irq)
-		spin_lock_irq(&l->lock);
-	else
-		spin_lock(&l->lock);
+	lock_list_lru(l, irq);
 
 	return l;
 }
-- 
2.53.0


