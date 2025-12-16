Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5AFEBD637B5
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 21:19:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 393B26B0089; Tue, 16 Dec 2025 16:19:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 347536B008A; Tue, 16 Dec 2025 16:19:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2495C6B008C; Tue, 16 Dec 2025 16:19:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 151296B0089
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 16:19:29 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C59DCC07E9
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 21:19:28 +0000 (UTC)
X-FDA: 84226600416.01.3958A8D
Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	by imf19.hostedemail.com (Postfix) with ESMTP id E3EAE1A0018
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 21:19:26 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="Z6/VqNYz";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.44 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765919967; a=rsa-sha256;
	cv=none;
	b=WOLO/O2qUvF4ibElk8OfZzmiliObx/9T2dgnO+cKpvRrJWV4+uWVdbpC+ycTpODECkGvEs
	PNpdoUWkK0wpZc5FGG7ubnI6ew8fGMcJCHg5xWzF/FGprpeuCcRbzS0eRQcGj4zPzk8vWZ
	YGF6sfiLTNWwyYkj7y46jmZPyxPPQ4M=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="Z6/VqNYz";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.44 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765919967;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3VY0ckxbD0HS7539qczsRu9OrZgCzKLM3XIDcEbqEpQ=;
	b=37efqIUQCIQu0aK3UzY3D93XXgFdogRFS+41rx6hDxW6/fvpgm+p8LzN/qNMRDzKU3mjVL
	qeCDyA0kMPC2QxLCKDJE9tAC4WJOQGhk++u9vLe20D7S8RPP4h/2x+z4WSAWqwVYDPkxjv
	o4G/vDqNbAas0rRbZJ2JrW0P8ws+bk0=
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-594270ec7f9so5586239e87.3
        for <linux-mm@kvack.org>; Tue, 16 Dec 2025 13:19:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765919965; x=1766524765; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3VY0ckxbD0HS7539qczsRu9OrZgCzKLM3XIDcEbqEpQ=;
        b=Z6/VqNYzYhkSfW4/4o/ylkBvFpo5gkuzHAtOGLX9i6LFFYjo7wkmePOJMq7ywFIzK+
         8F2c0EvC4oKYaPoJXqe8uTELT9KMMXG81LMTqIxLkaTf8fTNbV5D/gnrfurAkFxlnZYN
         RCZs3E41mHJk8PIzCb5PMEm+ON2q8va2Mq9eoRUQqQtmlymABO4C0ofnT392TBrOYlFT
         J2kNEzT062pfkEY7jGlQcSX6tZqvGaVpdFkhtMKGQYkwsIgYLmecF36jHF/H1d9I5TMh
         olGDhTA+CzLrLgMpCXNkQvGppOTF1qW18/lCsu113JwJQX4Qd0de4a5Kyep6fnKvbPtc
         p38Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765919965; x=1766524765;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3VY0ckxbD0HS7539qczsRu9OrZgCzKLM3XIDcEbqEpQ=;
        b=NIIZ8l2VuRRWyUOsoZCjTFCcf7ml3fRLVNSNONgXEIjHzgZk8oRBRxlkYcyyUrliGt
         Utg1QOUf7ZJtypkz59bEEBeRPL6gQuF0PmVX2igPKjcQaohx+2j0dIGu+56jJY5Fjwy0
         z1gqnRc5ttGBx+ERko3MytKvDYvbEUZWv+OU26ZR0U3R6reGr4a00N4wtJqbKSxI5iEv
         9jelucQxeCN6xwFFRt+YbAg9I7yi6E7MW5ckBzaa7uNqFT4T2Ff2xJLgrooafbUanKcn
         6azWAwLykQfpQ7fj7Sbk+tTIJO7WUnhuKK9mDXGFeEKlM7m4DLbYlJRKf1uZcG9e9oGr
         iu0Q==
X-Gm-Message-State: AOJu0YzOFs4cNOTY6h3KbKSZX63zH1ljPpFLKChvR1QbtfdrzacG5WOi
	pH7/rHppCfFe0KGsKLdEdW68ciTa1m+QIQgGdCWeetwTu6Djbxc1lx7jbxDyYwo8
X-Gm-Gg: AY/fxX6llCenbTLXIPAvpJ9N/xZOjzEOboFSVuUwJR5uUY3HWZgvegW2pD5lx9GN2l4
	PhOjwGGD2lxUE5ALjSB8KfPj1XMgZ5jrlF3XNa5Fba/E0h6G7lgjNc8FS/cNj5SNaWmarvPkXCo
	QvaM5dXopxvLgEwEJcs5AP1zCfZ7MkZZXyG/I21UWmZkcJg+opWHVhBCsRhCxbyTy0Khu7gP0tr
	8O/EzQ7YgMYq+I+VwoMy2kwWpYwylz8R2W/NxqiifnSfTwxfRTdY8+M6JbdBmcz97BoeUYuGn5+
	M1wuDAVPak7gwNptlp9B83t5Qh9ouibWFyfAo67u/FTIKKxeGUmp8Z1tkPCQC9UalluDYiuc0ek
	Yu1cqLw6J27AhTWn6uXnaQi+wBp/YDicQzAyr+lMhCKLrQbZ6NlpRggk7rD8LYvxDa+o+Rez724
	fv3PE=
X-Google-Smtp-Source: AGHT+IH1n5Xidae/XzDPvmz1lzzFYToQR3yuOx1YHKy9VtOKOfY8zMAvZxcQt6qwuaMCIjDb5FeVew==
X-Received: by 2002:a05:6512:131c:b0:598:853e:f26d with SMTP id 2adb3069b0e04-598faa8f1edmr5906744e87.51.1765919964970;
        Tue, 16 Dec 2025 13:19:24 -0800 (PST)
Received: from localhost.localdomain ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-37fdee05901sm40926971fa.43.2025.12.16.13.19.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Dec 2025 13:19:24 -0800 (PST)
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
To: linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Vishal Moola <vishal.moola@gmail.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Baoquan He <bhe@redhat.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Uladzislau Rezki <urezki@gmail.com>
Subject: [PATCH 2/2] mm/vmalloc: Add attempt_larger_order_alloc parameter
Date: Tue, 16 Dec 2025 22:19:21 +0100
Message-ID: <20251216211921.1401147-2-urezki@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251216211921.1401147-1-urezki@gmail.com>
References: <20251216211921.1401147-1-urezki@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E3EAE1A0018
X-Rspamd-Server: rspam03
X-Stat-Signature: s3catui638gquynk8f6stmdgh5fqnj3e
X-Rspam-User: 
X-HE-Tag: 1765919966-879705
X-HE-Meta: U2FsdGVkX19Rf8IAfq0xlsMd9thFqPYRqXTeaZ7F9nK6JffbCA64qTAtwoRsN8I8LFItm4uh3RlJuZ2q/iliSSWcMGBWmDjA78AF942Lwei6xbPlmNsKXVeHPvR7iQ6a4sAWNQ1bgLEmbAJ/XUZ01axt1IClO5AfvPagAyqllVIXXsbK3For2WH/MeLV2pflOjCKnPdM7sZbCUP3P8eaCw9LtI4vxFZu8fJ/xAQDzvGzNzeyKsQtpctaILteCKmKHtdxn41p6ENB9Wx8qnJoU3je0KMUc3ewXgJxX0cZgDejvc9R+bPFwFJo0fI0dx35pD4EMn+/ofS9TDLso6XMzAaPpYxCHLwu+4ZvD1deiZ8sBFOmGS/c1i799biBRsMHAGyVMCioa+Clu0MLV296i/msgHakgcBQTOmBsNABnIqhwTAy6K+ef2F83WGjUGP3eQN57ERsD0rrQHqrNgdSAGfuPOJ8NaYFDjrh4ZNZ3QXKQ8U4USoz7gmmvfX/wcJQX8wG1HVLK/zXj4MosZsfa+QaDDr0Choo+niZDV0cGEYr9vtvC6kwEU5zt0+x7Oip9gfbF0wwimzkoBwjG8Q997VJhSHF2Y8EEFdm+d/frxNuVSfGHwsQ32fT4zL2mykGw5X0kySTJ1JDAkiD59kuCZffu3c9WUxPfC1aarCdfGnW0U17WQpig7QRaJlNFwUmRzjwc/enWyT3ueXN2UWyDBcgAr4WfBacpiZSgJ5WjNcCkMRQCAV5CAU6D82bBGxaxZ7904DqHIoXfOsJWCsX7ckZjBgOPx+7HUc6eGzEiwTAMrvTWPp0kwmN/Je7a6HbvjG8EiedGojJeNlA7Q7finsvi1ceFv+zvxGfR5ujSbDSyWcDNk+0/kxuqABn/NayRlcIuw5h0N38WWQ25m+ytFnhM7ME+AcLvzezMIfLq/w/nrBZq0kpvd6jKhCP9H5EdrQNB748PVxWXhgvvs5
 0EC0ElGR
 NoFG2IEtDjc67YPGSaJEc8Spkcsb3HVAuXVs5mLEQYsMQ59yBnsL+92kpdY6Un+6E5xdcMnmS0AkIe6WlwWugBFOFo33NIPbIfDYdapoVNiVM0xGKb+OaOb+/wMTHquPqARJOnW/6I8y98DEQYBLx1xClztUj9QGeXLt++r9t9MfZ4W7nbQR93Cuxd4WhYbKZ50ek49ZB8a91uFIwi/YkrmkGXtioZrpa/iJ3QLLmlNXoscZr3mtsmligppboEwvF4ntgq5mVm58bCWB9DO9zatHCK8yRC8WK+XOuoD4PnSEztxpaUwi5js0DBzejRcme5Dksgqotwzoam/MfNopWVV6UOZwb1cTH5nMtBe7ErjkxdrMHBojdBCokJKO6lSDV2MXhIWrsCMwPL21qHeOmkkIP5KW2z6tYVaSUz+mv6LlWhLqQO3Ni+crpjEZF8vsRkuehigZ69MVIlKmJfMy8AYZOKl940/wZvfT1c1b0xW/YoywMhXsNZCfhROVuGi1XojkDe7VG/9FyoVHBQzo9skCac2iD15sRXs1T2l68qiU2sAJAdDN2FfeEGRcZxfDTQPtC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce a module parameter to enable or disable the large-order
allocation path in vmalloc. High-order allocations are disabled by
default so far, but users may explicitly enable them at runtime if
desired.

High-order pages allocated for vmalloc are immediately split into
order-0 pages and later freed as order-0, which means they do not
feed the per-CPU page caches. As a result, high-order attempts tend
to bypass the PCP fastpath and fall back to the buddy allocator that
can affect performance.

However, when the PCP caches are empty, high-order allocations may
show better performance characteristics especially for larger
allocation requests.

Since the best strategy is workload-dependent, this patch adds a
parameter letting users to choose whether vmalloc should try
high-order allocations or stay strictly on the order-0 fastpath.

Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
---
 mm/vmalloc.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index d3a4725e15ca..f66543896b16 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -43,6 +43,7 @@
 #include <asm/tlbflush.h>
 #include <asm/shmparam.h>
 #include <linux/page_owner.h>
+#include <linux/moduleparam.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/vmalloc.h>
@@ -3671,6 +3672,9 @@ vm_area_alloc_pages_large_order(gfp_t gfp, int nid, unsigned int order,
 	return nr_allocated;
 }
 
+static int attempt_larger_order_alloc;
+module_param(attempt_larger_order_alloc, int, 0644);
+
 static inline unsigned int
 vm_area_alloc_pages(gfp_t gfp, int nid,
 		unsigned int order, unsigned int nr_pages, struct page **pages)
@@ -3679,8 +3683,9 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
 	struct page *page;
 	int i;
 
-	nr_allocated = vm_area_alloc_pages_large_order(gfp, nid,
-		order, nr_pages, pages);
+	if (attempt_larger_order_alloc)
+		nr_allocated = vm_area_alloc_pages_large_order(gfp, nid,
+			order, nr_pages, pages);
 
 	/*
 	 * For order-0 pages we make use of bulk allocator, if
-- 
2.47.3


