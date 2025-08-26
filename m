Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87CBCCA0FE9
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 09:34:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F108C6B0103; Tue, 26 Aug 2025 05:34:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE7356B0104; Tue, 26 Aug 2025 05:34:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DFCEC6B0105; Tue, 26 Aug 2025 05:34:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B9DAE6B0103
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 05:34:21 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 724DD5AC14
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 09:34:21 +0000 (UTC)
X-FDA: 83818397922.29.31F4897
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	by imf03.hostedemail.com (Postfix) with ESMTP id A8BC82000D
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 09:34:19 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=QiIltMmf;
	spf=pass (imf03.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756200859;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=oK8HCeGcHpUOHPUJVPFqJNeZg0ZfF3cRIFZbaCfOHg8=;
	b=ByH8V/O6IOBgrBUztAkWsvJhUnTCabQtydhE35beOGIfgZnITOgplQIGZ1VsECQBeHFYvz
	bYIW34+zlqVe3n4tx9GY5iuA8boTzwD8pQY4jKbap+n2t8joobX5L0n3medPBW30S4cpon
	xCiZE4RXS97HR5HPTcZ+/Sy9ctg7RfI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=QiIltMmf;
	spf=pass (imf03.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756200859; a=rsa-sha256;
	cv=none;
	b=LmCk5JY8/ZrgQJJofUh9SVCnlP0grbhHBqaR4bLD2CrqYJ+2bqU9PLMfOHRYUs2/FOVYTE
	5SQkJqbpU6Dm4X90QgwpSZJOtwt2yV65MBK5qQijyLiTZhOhAo5FV3p9B/Sn1fW+wnZRvh
	4/bf1h7zZN81/nigBOHv0tOkD8yEeZE=
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-61c26f3cf0dso5917649a12.1
        for <linux-mm@kvack.org>; Tue, 26 Aug 2025 02:34:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756200858; x=1756805658; darn=kvack.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=oK8HCeGcHpUOHPUJVPFqJNeZg0ZfF3cRIFZbaCfOHg8=;
        b=QiIltMmfkT/aYVkrPhcUCmb47uTnNpSbwtdk7u6wPDxuIuZCzJDytSEIBFgmzBjb9B
         oXnkZvIOBHmUlrcICqurEtavDPEdMOrL8gWCqefC6SW5AiSKPeOSp6GVEC2OTI/C5wIY
         c51BCcbU5NsIV4VsqbOgmGxbPgrpZxUOFzcLFlRSuXnjkpVTH8GEP8YlOEqVRKgyP2xn
         +O8pXEGFCSJVFYH91SJJOWulpEeSmqoHjc1FnlbMkXngHbAaj6dtVxg5G7qhY7jD89bp
         ae1NCCBMAU+wQ5eAYar6N+biiuG5n2mpCkb2xrPyx+Fl3Js0pD6UTPhI356IfuTe/37e
         EwRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756200858; x=1756805658;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oK8HCeGcHpUOHPUJVPFqJNeZg0ZfF3cRIFZbaCfOHg8=;
        b=T9GhGtxmiO80bbs6R1ypQ4EwAv5nRGDcjCGwF1LaacF/rbO5o55J75oSceGRaOrFVw
         yRzUZu6w5yiFw5/+n7D48h/HVq4XTV+WgCsAsaXPDPU10t4n3EG3G1cgInZp64Ry0rzM
         eKIOrSj/wBm4qoyoe+GLIR7kfI2LeXnYqM+1wds1qMXFAjCi5eLuFo639n6/YCcD/yoD
         LuBYEnn/vwIXOkznk/PmutfnC2Am06sACt9noG5FRzswrJYWt0T12kzKqktCju2MDuzG
         i9PrxRMGymtRblhdAt/NtIXRlyKzRSTvmthwyK5xMFWzXDWW9rTCmZEbBzlQ8DXpvrV6
         g53Q==
X-Gm-Message-State: AOJu0YxoX6ra9JufvM9g74tGng1UWA+XI7MyEGIxpR+kf2yXkTV2G00T
	wQnwLjZ0qMGtvnb6C3a7o85EfgN9Qe9BLsrzSBArI60yJcCJWiIK9836
X-Gm-Gg: ASbGncs0KB+9KkIH7WpTWmi287iOJVGjHhmymC6GWWt9caOimHX84TGvSd4+g73zNPV
	qNppzi86GucAaMcfwO5C6oymtr8wbslWZV82UM9hTAu692lBTg1XKn9vw0CU44c7xatT/XZ/w7B
	/c4p6b+aF2dG1UqF6/BLrBHHC9hM5MQ4/jWCwdt5Oq04ywGtooAlXRlWfWeQ0Nz2b/vQa04++BP
	94WNSBnDgu2NbbEEcUGHm5Qu0jhEvnxokdEAhTQN3tgdttFihJcCvqxjQc62h6lPfcU3S4/L0/E
	fgBWyJGF6rGbaey6b4B8d4BX74GJmRA7KBPbKnXmTkOiPk+a9onmyAR+xYRq5xdkhbuSw9QgzQP
	3Sos3UgGpKK+sR6+M2Nhbi1TVyw==
X-Google-Smtp-Source: AGHT+IEG+pe2e6vNX+FnqElrLIHyA36Yw+925BjEOZD3Tj9fF0tiPeRMgiFZN0jIEk24dKQjmf1oZg==
X-Received: by 2002:a05:6402:2787:b0:61c:5264:ad97 with SMTP id 4fb4d7f45d1cf-61c5264b027mr7240581a12.30.1756200857988;
        Tue, 26 Aug 2025 02:34:17 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-61c316f5017sm6505641a12.35.2025.08.26.02.34.17
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 26 Aug 2025 02:34:17 -0700 (PDT)
From: Wei Yang <richard.weiyang@gmail.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	vbabka@suse.cz
Cc: linux-mm@kvack.org,
	Wei Yang <richard.weiyang@gmail.com>,
	Zi Yan <ziy@nvidia.com>
Subject: [PATCH 1/2] mm/page_alloc: use xxx_pageblock_isolate() for better reading
Date: Tue, 26 Aug 2025 09:31:47 +0000
Message-Id: <20250826093148.30190-2-richard.weiyang@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20250826093148.30190-1-richard.weiyang@gmail.com>
References: <20250826093148.30190-1-richard.weiyang@gmail.com>
X-Stat-Signature: topww91ieg8nfsjxd8s5z3fxoitwcopp
X-Rspam-User: 
X-Rspamd-Queue-Id: A8BC82000D
X-Rspamd-Server: rspam01
X-HE-Tag: 1756200859-783852
X-HE-Meta: U2FsdGVkX191A3cwZ8k3lmM3fRs6uiiJKhwLDU6QcXYeQqJGOnDjKftdQMKzzah2EPHPb+ChLC1o/R+Mlm2dfMuLsXTCiBPloW9bzH+0dzmXcjYIEM/6cRB18jIdNtrCNrIOHQ2FxdiORe1Ib9TL5F19tBO1Y3JNOwJzQMHaeXZo3QCJi67eA21gkuai51n46xnqQ//n0ku54nijmfkiB4BG9ZON4J1q0NZD78ewyPSvACWJ6RWA/771kkSZinAxrW6fhNAxK+22PkXqCZDTZeXlFo6onym4CHyxq9AzPToKY3/I+b6SM0mOomkgFGZ0Bg/J0C+k3ODT0Z992VDQoqEbQa9GbuEGm4CEC5OcCBgjm+LiCQ6vPwcSEuAZYIL5Xkv1XpMn/NdhyeXJ2lOd6QZjZuq4AvUDFWlNHMaqWKR494IlBRJOH9PMbVjkRbjqCfOV94g4DWYdcqD322a8wI63FbtttmuLvwOLVi/6kg96nwJBbrzU4n4+/xJSdsWGlhpzK4lk/IpfVv4GLujO39F23hgIGoYXvaVJzDyZf2D1T0k8xDXvNAQayoop3a3b8PPsPTvHsEA56KKacf3EAd0RoavHcJ27nBXZ37FP2AutW2BKspWad2AF9m+DWc7WouwrrVdaxyizDdSK+lEff0euMs9SOLUFrJD65blANXIwot+7f69bmOe+LtAbh//WSIdGmIOz1rQNsyHjWxAGlRwhmCAcv5tbc0h6m08BVx9sb8N/t+K6Z1RUVOtRDAirnB1/Y/5/p3EhJumoQGcJiPaVxrfZCjyN6Nzg2Sauj4EWEXOiNj9v+2lpCz4Vxv3Cbc3woAZFE03Nx/kiJJKN5l6KiBQ+GTYtL73Uib0Pj5lzhRzLMj7RbytJxjx1pHPxz8CF02pcKhg8uRbyO1zlrWRzcw69zTCSdUfkpakj6g0fW24rE1C65N4QUs7M79Vh0gr35B3sG2lbJM+4xY+
 geazb6zC
 pwJmFvVuwWV4r4jijdb0inzGnNosRZA9AISPhCpcNf8upj0ejvEri3IrfxQc7p7O181IMYBRlIoHUXabiup7guXa65hfpQ+U6IF8MMbwkhqVlfxR6x46MqqkB4zS9HtZCVqBW2VS/qcIzU6fgQXAw9rR/DjCq0OyYQsfHKh+uGog7HUmcrcRRHwVUeFV9RAdFGKpUKZPBXdOzDC6nrPqOU9CIJy5EWmBjXLmb8ZjjECljtPLq/iCTTFqVbxqyV9RjUEfDbWsQ9cS7Hx0TBMejUO+tTlWE2cjRMDO4KZjKkmVz7QY8gVHMlCkn0TPkk5/NQCXHOhIbVobUWj0K++160q7nI2Tn7d0ca5zTO9ChqV775fEJrEG64AVK062s3WUMiiw+ENdvweGBUl5253TFI+LOmpDaV1Qgvsrp/IA6/mALne0T/drabQ08WNge1Y/NqirTrcFKOujZ66gt9CqzAkc+YsZFWO+UKoBl8nShiOHkHpkiQpiw7AszPAggHrSq8gVjssBQeIOW5czA0+nwir4nDDEZ+JNdc1VnFZ2T5rGVUpJtf3WMGvSwZu5WfvIYZjpPZ+Tj97oWeaPCUewTUpSQoSrAJat9VubfCb/cu67bUcQYtBQ80tEswqMHiHNy2HzqUZY6L2dSB+ZLQfaLRzgfQg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Since commit e904bce2d9d4 ("mm/page_isolation: make page isolation a
standalone bit"), it provides dedicated helper to handle isolation.

Change to use these helpers to be better reading.

No functional change intended.

Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: David Hildenbrand <david@redhat.com>
---
 mm/page_alloc.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index baead29b3e67..e534f31a6b39 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -538,8 +538,7 @@ static void set_pageblock_migratetype(struct page *page,
 			"Use set_pageblock_isolate() for pageblock isolation");
 		return;
 	}
-	VM_WARN_ONCE(get_pfnblock_bit(page, page_to_pfn(page),
-				      PB_migrate_isolate),
+	VM_WARN_ONCE(get_pageblock_isolate(page),
 		     "Use clear_pageblock_isolate() to unisolate pageblock");
 	/* MIGRATETYPE_AND_ISO_MASK clears PB_migrate_isolate if it is set */
 #endif
@@ -2058,9 +2057,9 @@ static unsigned long find_large_buddy(unsigned long start_pfn)
 static inline void toggle_pageblock_isolate(struct page *page, bool isolate)
 {
 	if (isolate)
-		set_pfnblock_bit(page, page_to_pfn(page), PB_migrate_isolate);
+		set_pageblock_isolate(page);
 	else
-		clear_pfnblock_bit(page, page_to_pfn(page), PB_migrate_isolate);
+		clear_pageblock_isolate(page);
 }
 
 /**
-- 
2.34.1


