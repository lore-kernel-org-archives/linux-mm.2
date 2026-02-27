Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 383A4FD5327
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 09:55:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 410406B00AD; Fri, 27 Feb 2026 04:55:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3BE1C6B00AE; Fri, 27 Feb 2026 04:55:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F4F06B00AF; Fri, 27 Feb 2026 04:55:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 17AA56B00AD
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 04:55:04 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BAB75C2134
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 09:55:03 +0000 (UTC)
X-FDA: 84489778086.03.00E730C
Received: from out199-15.us.a.mail.aliyun.com (out199-15.us.a.mail.aliyun.com [47.90.199.15])
	by imf12.hostedemail.com (Postfix) with ESMTP id C842D40007
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 09:55:00 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=YZZEheqn;
	spf=pass (imf12.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 47.90.199.15 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772186101;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TFvgQ+JoosgOuHvCEtm/wySIDfFeyNBVmJ3HBIM12WU=;
	b=esRhlvS2xe2TMHPGwvJ2quBMHaqXFLUS1C/y7N0yj+N82Vi36MpdNT2ORGsvI3mLVuVZeo
	efhckkFXgPvl/Zsq6Ad8vdXsA6SBmOwx6K338TycHS/IPPWTMrcQfDdF5C13JKI+pQTvpf
	sOQqdzs2Ql3eUiI5L5PiAfZB8pobK0w=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=YZZEheqn;
	spf=pass (imf12.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 47.90.199.15 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772186101; a=rsa-sha256;
	cv=none;
	b=PLIPF0z9n6PTLMBfxf8p3qyhdCiXBnSNduhzBlyiCfH8t1LFMRT3tvbKd5Oujqa0TYmslK
	U+3i32PyEgoAbNoepe2sA9LUzNoQmKls3jm+nIoUSZO7T6e7wxSBd4y/7AzMnD5EyWA6nG
	vt+Q5y3GaaMgB0CNJrnZBrt5vxAGVsI=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1772185495; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=TFvgQ+JoosgOuHvCEtm/wySIDfFeyNBVmJ3HBIM12WU=;
	b=YZZEheqnk2jvdgXq975C2vSlhKYMX1PD8vV/4t7vnDwR+iFhlKsHPi/M+tk75C4DyMuhTlPFXU7Ueba0tAv3af3p0JQ28BmbD0Z4TY3R2wJcd3pLTZYuLs4PgnSeI1r2ZPbta3Dha2OjYnKHpHjeh2mQuY3MUi05o+/sp7YvDE8=
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0Wzu0LeH_1772185494 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 27 Feb 2026 17:44:54 +0800
From: Baolin Wang <baolin.wang@linux.alibaba.com>
To: akpm@linux-foundation.org,
	david@kernel.org
Cc: catalin.marinas@arm.com,
	will@kernel.org,
	lorenzo.stoakes@oracle.com,
	ryan.roberts@arm.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	riel@surriel.com,
	harry.yoo@oracle.com,
	jannh@google.com,
	willy@infradead.org,
	baohua@kernel.org,
	dev.jain@arm.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	hannes@cmpxchg.org,
	zhengqi.arch@bytedance.com,
	shakeel.butt@linux.dev,
	baolin.wang@linux.alibaba.com,
	linux-mm@kvack.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/6] mm: rmap: add a ZONE_DEVICE folio warning in folio_referenced()
Date: Fri, 27 Feb 2026 17:44:37 +0800
Message-ID: <6562be8c92e07f0a69c8ffd4016d1b1e55198af6.1772185080.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1772185080.git.baolin.wang@linux.alibaba.com>
References: <cover.1772185080.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C842D40007
X-Stat-Signature: wesq3difchba58kzzink5rm9939nacz4
X-Rspam-User: 
X-HE-Tag: 1772186100-945402
X-HE-Meta: U2FsdGVkX1/NiSlLupw6QuC+MehX9JzScR7tWHIYTqufcr9nSXOEbyzK1ARtL76DyoGyM2g0yx+hgGM4PaISTLOnj/GCVS3i8C9ubusmaUNzKNGZ7vmKpYRcfY9ra5E1h4VkvmPCnpKNX8/2DuDNp3D5k7EL2kob7CsPLWM/ITJsmQhOky3N0yRJVYvy0HNfaPrW74F7+P2/MS3mymf8giszl45W4Iy1ZydC9lfsnq3WarkGidi2+xiJed6GG16/OZdcU1eVnrZkTEQdYT2tw070qC4kPmH0PH00bsHrfnLQgFwk4jD+vIWLF797LqYOPy1TlumpegUbOlERWEA7xJeaVUMuU6jKZjjd1Bj3M57PPdL8bIvd5aq6hM14SPYQj5UP5y4/2FJMFNrgNKv3ltra+TEE3T8pvWGaltlIoZUMQK6ArLRf9R5jH3beEM08gSj8+nsNa2LD9YH8EE3wyh7+VXt/xGYO7m5z+brIuhIHHmFIcUNc+uN+It+11NqICc4+OVHINoR3DKu2hukZPxzulWzOmfXyXpHBGaSn/OnZS20l4DDA7voJoqrAa1xxKSRGpkRLcoF6m4G6LD1LhZYVh4NPsdQs14tm2zuTarwlZ+in2AGzkDRi9q/RzxRcQqh36+h8qLJVfNekQzegogpaScOomhOL35pgvbJSr8xIaHuvosEVnHKgCBTHW85E/iSyazhrhThs7tB1tzBnjc9boDbzAcmeWZSBxqrgv2mqJrdRwGqnBYXlqPRpK4/zPhEDegYdZiusfFaJv4vEwRF/dwfm8M71m4JTzQmGSZohwEJIhbXf0jgwcPQ6zRbv1BOKRejY6dyPymjtzRLP2KBPha4VBUaVR7w+2X4ZtdEIxtKZYvVVNqv+eR8Xi6hwU43VsuoQ89YJs3SA8Nf1uikgeTd/VzRTlEwetUXikprx0m9NY79f4O7aynfm6G0K9KMTfnJb91PI+66HzqC
 e8TVvGab
 kuVa0THw83zm6PLbkv1snAvLHX8GbbL6AYY3mcMWrIPBqbO2XcROp7Y9XwmpyckMh/P9UkIqMXT8UMDkYPPzy87bPKjxP7eW2JytyIIxHwdW9QcUNzCn6ek19pSN/UL8G7ICYEPAdNzUUZNI13TfWBGSkvnD/GX+DIiOdMvKWgGoOcgEheY5fZImZoq5HbAY4nd+iRLfP/O1i4s3reLu5667tmSP0lmTiPrhmRnLHL/ue8FLWU8tl0iXAhihxrftBDFh/cr5LsYEW+i8nN86I8cnIw/iM1xh8+VjlXNypjfQtzsnYNY4p7h1NMOFcjADc2eoT4gkrqKJwirIlj4rlCsqt7xghPhijCHBydgpSrf8XIuHcgxQEdQUKoUTl/EOehmCe7IKNVZ4C8LXpR9Wu/hYVsOmEf+Wio/16xth22mYe3Sp9wTviqsqHKDk8/tndFrVy2bkYpcUeJgIT5kDLboespPp3EGElOQ5rNHLPtY40qKUKgU8ph+IUqwbABY5OwgRt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The folio_referenced() is used to test whether a folio was referenced during
reclaim. Moreover, ZONE_DEVICE folios are controlled by their device driver,
have a lifetime tied to that driver, and are never placed on the LRU list.
That means we should never try to reclaim ZONE_DEVICE folios, so add a warning
to catch this unexpected behavior in folio_referenced() to avoid confusion,
as discussed in the previous thread[1].

[1] https://lore.kernel.org/all/16fb7985-ec0f-4b56-91e7-404c5114f899@kernel.org/
Reviewed-by: Alistair Popple <apopple@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
 mm/rmap.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/rmap.c b/mm/rmap.c
index bff8f222004e..11cc6171344f 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1065,6 +1065,7 @@ int folio_referenced(struct folio *folio, int is_locked,
 		.invalid_vma = invalid_folio_referenced_vma,
 	};
 
+	VM_WARN_ON_ONCE_FOLIO(folio_is_zone_device(folio), folio);
 	*vm_flags = 0;
 	if (!pra.mapcount)
 		return 0;
-- 
2.47.3


