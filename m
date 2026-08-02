Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F05EC55162
	for <linux-mm@archiver.kernel.org>; Sun,  2 Aug 2026 10:46:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 242EB6B007B; Sun,  2 Aug 2026 06:46:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F3E36B0088; Sun,  2 Aug 2026 06:46:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 10A546B008A; Sun,  2 Aug 2026 06:46:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DD74C6B007B
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 06:46:33 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5F5FB1A04AB
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 10:46:33 +0000 (UTC)
X-FDA: 85056000666.29.A6508D4
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	by imf06.hostedemail.com (Postfix) with ESMTP id B68A1180008
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 10:46:31 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=P+zUFIN6;
	spf=pass (imf06.hostedemail.com: domain of urezki@gmail.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785667591;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=hMc7JramF3Usd/keb3lUAwYR6zMtPrVV5PxoLUsaA1U=;
	b=kpzEymxF/c0o7S2lWUJflPltknH78rgs7Pj2MmsH5dEXFldmLIMPcb1OFAMN/b5BTYJ8Lc
	tAyQKfKe6GxXTmJzN5NkTSOiReqKO3Wab6Hza+O8T47VH3n+gfy/0ZSYsCD7Uq04HI2xR/
	Wahi+XSJEPx6BkC63dUWWA3sOX1fWtk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785667591;
	b=B+aGtc1oEqUzgGY1InWxLIB/Fu76lltx/Bs0Eg3s0oLrJGHrqcAv8Pir6BWQAcDIj6SftK
	VcaeGMPOvNcquURQFZiqI0zlR71XEaNvxVAWTPVLMMmkZOEtl19v4jjMrVUdYQTq1h7qLs
	r4LFynJLdSOOYgjqM4icp9WCm2IRZH4=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=P+zUFIN6;
	spf=pass (imf06.hostedemail.com: domain of urezki@gmail.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-c15f47e6297so262549166b.0
        for <linux-mm@kvack.org>; Sun, 02 Aug 2026 03:46:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785667590; x=1786272390; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=hMc7JramF3Usd/keb3lUAwYR6zMtPrVV5PxoLUsaA1U=;
        b=P+zUFIN6ucbbGBoMe3lis3BOrpfEYVM/RAXy4ZvWYKk9ffJ4R63vnDgOTI+kxLX3LI
         szab7+/isM/Abymz6buKK6onp/awt4Hik33sidOvRbS1W2bZlAyb9rhscCIw1CkyORof
         mqayNwnzgoSUTnnvlIjvmd7WpwlyJ+wJma1vDCtUO45++XJmr3bPhoFW80HtzDdk20of
         PsqPdD3TcrKdfutRm1nAjy2C18i+QwzTGz1T9LAis+V9LpryJPRMguepO+WDusdogMoY
         nSycQJ2PQOAgemTpmLC3ZVvAOmSrlI3U4Tlnby8oCQN3EeYMGseuGn2p+/q1AYCQqdnj
         f55g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785667590; x=1786272390;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hMc7JramF3Usd/keb3lUAwYR6zMtPrVV5PxoLUsaA1U=;
        b=GjKLpTYHb00VKeE651k2FFfJQ6+LZzs25nFc7PHxIZX1+PLUPmdXOlytxJenZhpi5Y
         CC8ruDC8QNV/iB9SWGSdNnW9dktaoYOm0c2LYdaFxhlPt3G429YEMTm5CRuOqzrTaMYt
         ewMwHAZ05N0vomkmPYZyx221MZ4R0DX6r5UZ31rxladGluzcEPyiLBbQcL5anvOAsO59
         lSyWAPfgoqaaWsgmgDVZOJvFeEqo8zAVPgXW7qTZ8fY1ketT2btYS1m9ZusOr1EhsMrQ
         spYojGWJpt+TW/Aoh1QKFAU8CCMifD1L1ZQbHOSj0TSKlHEIk/LaMIqguqEV6deIfEGo
         oaqA==
X-Gm-Message-State: AOJu0Yw7bkXqJbylFAH8FXkW/BhQGxeI1foUnb0rE5KVi9KsSV01RdJ5
	zNUi+Zke8OUW/GzhftHS9mGeDSqsM/88cVDBzUYvEQBL/j5wcRcDrZi+5E709w==
X-Gm-Gg: AR+sD115Nq1l5FJ1TxbkBwWld0Wtxa2XfGdhffaNqWtFcwlhiLT312jaT/X9e4Zhu36
	DIfwUzPUMdiPrgMCpgbp5tTwtK9G9RtZT8xVDQIy5wosUs7Ud8d7E5Frxr8mSZdqL/rXWA6Bvd0
	yITvjrwSGW8Dp/9MnFw5NWlUJSozw+pLp4jLh2J+Inm7iJnEk8BLTboU17HbRuBSrySdTjQjXZa
	jo8RovAKLWOrcuX8Y5tzMk5kxGlSNX4b2Tcnh93eKHw36OIrj/Gxgz4rct/9V0ZDoDaZ5zDFjDO
	tFu8eGEm/f8SPlQ5vcTtgLh6CiB95ftu6DdKKLoOAtGaKRl+qwxpHvcnN6h9WszF27cdHQxoCJC
	0oJ6OiSX469DEVmj9VcfK2tP9GSPk0h4KIm7w9aR3Dq+pZIny/7YMEO9EQPtwnCdE0drVcLeYN8
	66z+34wXlPBiN9akZcqR+IqYSvJAilX24+ngGe63yR3qa+cDQ9EDj6M6IF3dW/iDE=
X-Received: by 2002:a17:907:cd05:b0:c19:45e2:b3c2 with SMTP id a640c23a62f3a-c1fe7ea7fb2mr397510366b.10.1785667590045;
        Sun, 02 Aug 2026 03:46:30 -0700 (PDT)
Received: from localhost.localdomain ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c1fd445433esm427342466b.30.2026.08.02.03.46.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Aug 2026 03:46:29 -0700 (PDT)
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
To: linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Baoquan He <bhe@redhat.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	syzbot+61c997e6be1d9bb300ba@syzkaller.appspotmail.com
Subject: [PATCH] mm/vmalloc: Do not warn on -ENOMEM from va_alloc()
Date: Sun,  2 Aug 2026 12:46:27 +0200
Message-ID: <20260802104627.63892-1-urezki@gmail.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: B68A1180008
X-Stat-Signature: qm5tjo4u8fwhb4jxpqg7383wmfytsjzq
X-Rspam-User: 
X-HE-Tag: 1785667591-200780
X-HE-Meta: U2FsdGVkX1/uSDjU4U7Fxsr2CBzF0ApPLEjHeRqAv7Qmwp2nydEZ5vy0vYmB1iVS+WROpZsYUQCotcUjt4CexvUlB8/qjeMzTHgu4+I15he6UmYW2naLFbZYEET2nLZo9pCIjWc4RrjSpwHEWlN2UFEgC66e/M/6ryoowI7KKze1hmaCOq2ohwGx+9ai9908pi/s28urfemsudWQDPdxqm8axO+ROw0WhghmdC4GWqJGWXRExp7vlda2Y5ly46d7/tK4N/Vgl7nFQeqIXzE8I9Vi7nGVAOT6IDm0FyXVMgSvIgOiD0Ey06tj0RG6hUmhFjL5CwqBXdPFtIGdKaia1MwALEFyk8aOJl61XEPZv6cCidWbzh33iAXjAXskU3QTxk3TVRAMMKCr4xO3QJWhEpZEwvmb59d1lH8EZwruQZwry9izYbBIj4FxdsdPrnxxSC5WTTB+eoCcEJaEI1Q+3uVu8U+6lzGnpHZQ4HU8NVDBKC1Y1t9EIgtZYtzFPhQzlGkjKxM9H77qcZBD0gE0HLe7i0tqLkp2UM/TCwOWMCIw7a5bgFjfavpz7f96/AwiOzVdehselPoy3CdmFmkwflKuVeD1hXnqNDpkhNzdHZD1HBGmL63s01QTKAGlFz9u103bWW70+phpBn0jaz5Mlar+SOcUO3KHkbVsuG/wCVURgcGTQe7PPnKFpJcXJ7pE966Uc0FZOwqLjjaYN4c0NBqn4kTe7+Bmh1b7g8QGnWWjORraF7TfjvbTUEvR3AlyRYKLbcrIlD6zR9Vz8cX0oFysHf1vmvKP25HbWOpmaqiaywuy3v8pmLH/22Pvnv0J5yEjj7dMJYA3yoBcqtTA28svBHLMSiezD37IlVSaWEXrBonXuUwu/Rztn/yFKYbPyWKeZwfsyWax7ex8x59ir4cqfLIZ5FF0+N2jZycmzkSbSZxvT1HoTjSuxIV1RuQb8FNdU+K+3ATlTNVTT/q
 o3VPgvD1
 AJ1twEPFI0v02dxsXxXwQrFqGNhCoQRF0DPTLiyCnnLqIIWCEtkqC6gANp0zWLpRRI7Zs8EJfMSYaaeO52tyImf3j+74c+yQTf/OSpvEmVdcqVSJm1zTsrSPdmZWlZGl+TuzT+ZZHlnDO6ClOXPLxyMqc4s+Yy0nFGMNuixnAA7/eKSNFJPAOH/Bh4ZgMosdWjx/4IH4hnpmpyjJ/Mr+Q+aEpFJhei8V8fqgyDuvYNCy/9Hyx0RBRSnSnlfWtgREuoQEbtCLtZFJmt0+97BrRWg1mM5oTv/M4LfLdbKJPNRWNmuNinqXUReZz6zVoSUCSp6yuw29WL6DBdi/0FfDtaPk/bvAvhIeUtRDqKERfapDDJqCIEYNLqvm9l3ktZsSGB3h99SI0pZed7uGW+z+McYg8y59sZLsfHEqiCXCudJNmmRyrKrj+IaeHaoXoGbcAArNcwfsF9cxrl7+SZoYdJUBXzsFgEbYPsiHv3f6/9YlBvwnfnJYI2BJ5uda8E6wCIVdSESRZmqMds/HhXFdIRr8s8h6AJKEN/w6NwUBFyHjzl519FvlCSyvjwXA1opXAXUBNzmXGcjx4c/m8fqBePC0lI6WBePqs5ddydqOagPJVEV0H9kVHTOGD0JxExPFY4TDkFs6U/WxBxoEPRXjDi1oJMQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Since vmalloc() accepts non-blocking GFP flags, allocation
requests may fail when callers pass restrictive GFP masks.

va_clip() may return -ENOMEM when its GFP_NOWAIT fallback
allocation fails during NE_FIT_TYPE splitting. This is an
expected failure, so va_alloc() should return the error
without triggering a kernel splat.

Reported-by: syzbot+61c997e6be1d9bb300ba@syzkaller.appspotmail.com
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
---
 mm/vmalloc.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 1afca3568b9b..7a0cbba3d29d 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -1817,8 +1817,10 @@ va_alloc(struct vmap_area *va,
 
 	/* Update the free vmap_area. */
 	ret = va_clip(root, head, va, nva_start_addr, size);
-	if (WARN_ON_ONCE(ret))
+	if (ret) {
+		WARN_ON_ONCE(ret != -ENOMEM);
 		return ret;
+	}
 
 	return nva_start_addr;
 }
@@ -1891,12 +1893,9 @@ preload_this_cpu_lock(spinlock_t *lock, gfp_t gfp_mask, int node)
 
 	/*
 	 * Preload this CPU with one extra vmap_area object. It is used
-	 * when fit type of free area is NE_FIT_TYPE. It guarantees that
-	 * a CPU that does an allocation is preloaded.
-	 *
-	 * We do it in non-atomic context, thus it allows us to use more
-	 * permissive allocation masks to be more stable under low memory
-	 * condition and high memory pressure.
+	 * when fit type of free area is NE_FIT_TYPE. It is best effort
+	 * pre-loading. If it fails va_clip() may return -ENOMEM from its
+	 * GFP_NOWAIT fallback.
 	 */
 	if (!this_cpu_read(ne_fit_preload_node))
 		va = kmem_cache_alloc_node(vmap_area_cachep, gfp_mask, node);
-- 
2.47.3


