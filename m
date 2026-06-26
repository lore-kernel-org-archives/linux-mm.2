Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66EC0CDE00B
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 01:55:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 322F56B0095; Thu, 25 Jun 2026 21:55:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2ABFD6B0096; Thu, 25 Jun 2026 21:55:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 174536B0098; Thu, 25 Jun 2026 21:55:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D5EFF6B0095
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 21:55:00 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 48157120336
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 01:55:00 +0000 (UTC)
X-FDA: 84920395560.20.E9D797F
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf21.hostedemail.com (Postfix) with ESMTP id 877911C0009
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 01:54:58 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rHfuSSmw;
	spf=pass (imf21.hostedemail.com: domain of haowenchao22@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=haowenchao22@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782438898;
	b=fYn6T8B1zzw8jNxXCA2CZ+ch3ZDYJ6VO+mFsUjoivvMr5xyH8vVxF2eJ6LRg9PUENFVmBA
	SQz2hlCGWRMxJ1L+R6jubiM0qGOvS+0XMGdQ5KZ9qJn/KY893z7MJxi2U0J0LuJmfsPMXZ
	QHDycpCB/cN+WjWYF7QxFZDWwYyqEsU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782438898;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UsegwOQMPUPZkD5oEdLRNUkDENZX/KJI8/fJZMWPicQ=;
	b=T+U3BWeI8UWoklkk9WXA1O2i2wjrEVQ/j38M3nu4FkuhR7DfAWR9488IXl3lqrZhuXiRiX
	ukLhPSAzqPeqFt5EEjAunwC74TCUj9z6jPE/n8Y+qHi39pQ5dBsU5XZ8uraSm65acUpR4e
	6VRJe6HYXftvuQmoNIhBm/dA9BCSXvE=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rHfuSSmw;
	spf=pass (imf21.hostedemail.com: domain of haowenchao22@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=haowenchao22@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2c818fe1f24so758205ad.0
        for <linux-mm@kvack.org>; Thu, 25 Jun 2026 18:54:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782438897; x=1783043697; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UsegwOQMPUPZkD5oEdLRNUkDENZX/KJI8/fJZMWPicQ=;
        b=rHfuSSmwglEAmqJYl5rdBBMTqzve9+SvNtApAA8jaRleyzhqThFU28kZMPa7Dx8wjk
         Bx63CBXikerPNouR65NjCP6jI2Fz/JMsiW+phcDZ/XMhN+aPMYVr1hzSgHGOGsobiCSK
         8j22E3g+MertaO5uVKSERAh+p8TCyeUe2GM4XzSdY7it1r4jVdSDUZShSvPL/5j1lVwR
         21D5nGdTOwO9NM69Ed1q5jjgUbwxqJZWhRedQZR1++yiv0PQczm47+Olj4RyAGLdfeiU
         iBsTrz7UeIOryDlH+0bNSGZUq1fw4MefaCJxN541yd7pYuClEV9lZLFaKTUmTHmBoEiF
         yZXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782438897; x=1783043697;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=UsegwOQMPUPZkD5oEdLRNUkDENZX/KJI8/fJZMWPicQ=;
        b=KgNZQSjSMLMvO/BizXSiuO/AeBH53Zgr1iijinQq2nfBlBjlq0F3jsUN7q+GqSL2eK
         otQ/JhYA0cvIHXSTYuKKnZxNOyuGGj74Ojxw1o2Wi5t3pHOjq2JCWv7roYxKtvlRIsFj
         mdoEOOjYsKtUS8qHu/CF8fqQQNvbTk6iz7McERy7XoKbuvnnx3pNuuE4WEKlwNLmUy+q
         9/A2w5s6uepWc/i7F3MabPmU9R/banKIRv8Qn9ISbBfevc299ClDpiC7M0Rav0tRHcoy
         iCbJOPOReZd43ZvUbGydytTYPJXtyzed6guROfWtziSpOp75DxSp5lB0gb2QsYxz19hc
         rBBg==
X-Forwarded-Encrypted: i=1; AHgh+Rp/2b1hWBO4X1kuTbxC3vW1TMMPD3AzK5gbALPlGgIEEU5O2vaXp6ug0b50/Vk5pDOEuajIqm/h+A==@kvack.org
X-Gm-Message-State: AOJu0Yz5araffD1RGS8ecMT8vfdfCWZn5QKtX7KZuc/r6vKk/Pdhs0wo
	mLpynB6Zae+aFX2rlI8a/L+fxjXJMe8G+/yYvGgm79ysM0m/ysiY/M1U
X-Gm-Gg: AfdE7cmfclOXweZxINAtnFOWXCWGjGF+rHaLlKKQ1bwC3OLIcA8gZSJyO19WsfIKykp
	j+dKXgCEltmbpk3hTW2QjXbWBn4p0pMfVO0FzY8d2r6dRKmg1DBA/Uv5EOu9DC/dyn4oM3f5rtS
	IV0IwCsp7JIXmFhNwyzrTiDcHhAPv2TLwL60oukSCB2rBLRbzkqWCyewfMyJuAfgtBKkXcVU3MM
	nXa4HOejsKj+7F22y/fBLiqOM1lA/V6nV24NRONDBzHbOXvexZDcqAeoE/PaqW7LCfgvuywEypp
	XcNfiqmRo1t6+u0EuLGjgIB2cvxs1jYchzvwg6JJP36FY8BwmcZkAjhEBE/nr080e3i/BBfzdTE
	jtq6Oibb7FJdkw+lE2LCI3uV/MRLRrB/oJuxWE4/WZ17aX35988aRw8f6wIUCMyLTUQkfTSv4Zh
	Tq7T+4jib531w99bxU1P+BUU5M2edT0hOVriIZdZM=
X-Received: by 2002:a17:902:d549:b0:2c7:c63a:2d69 with SMTP id d9443c01a7336-2c7c63a2ed4mr107061855ad.15.1782438897503;
        Thu, 25 Jun 2026 18:54:57 -0700 (PDT)
Received: from ubuntu22.mioffice.cn ([43.224.245.232])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c7f63b2bd7sm29047005ad.48.2026.06.25.18.54.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2026 18:54:57 -0700 (PDT)
From: Wenchao Hao <haowenchao22@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Nhat Pham <nphamcs@gmail.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Barry Song <baohua@kernel.org>,
	Xueyuan Chen <xueyuan.chen21@gmail.com>,
	Wenchao Hao <haowenchao@xiaomi.com>
Subject: [PATCH v6 3/4] mm/zsmalloc: drop class lock before freeing zspage
Date: Fri, 26 Jun 2026 09:50:02 +0800
Message-Id: <20260626015003.2965881-4-haowenchao22@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260626015003.2965881-1-haowenchao22@gmail.com>
References: <20260626015003.2965881-1-haowenchao22@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: g5a4umfju5zypiofo8791s7yxmm3sqce
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 877911C0009
X-HE-Tag: 1782438898-154521
X-HE-Meta: U2FsdGVkX19zJUKbw18mB86mzlMdQqpywYzQ4BpvB5sFSdEtBdvxFq+L2K9GZUgVkXE2A4m1ycc77Zrje4TLVRcdpnuMZghBLyIFz5cBAb7Z1PWPuu/41um/26kKLXOE04pKjnmkO9CbTFIitQos7GpnYgW/W8KOjfhIaYcKbgFnmgPCJ94WVHuDpQQhVkrlg+KG0dJqHDzzDLgW0MbMNTHCSATi3y2a1iIExmUrmEE4tQX6LDTsSPt/rF8wxQcK3emiby/MEQJ26t6JQJrcTR6GkYX45wtCOdVTbL+gOnO5b71aQ5lbjx5ZTtgAJMvbvNUyfhLAxW6AdVEVuSEwMauTQHXsOlUpfjqUueDsctzRGiA60J2vYv/S8MVVYcf11L6ZfYX17WXvio4DeJgT5MDSGEX0YCSRnykBHLeXMdfi9LHTL7QZG34+dahAI0gMIpdydX/z6YeWfo/42WqhLgIhFFi9CxPK6vUbi1e7oC2q/Sfq5T+ysa4G3wZVU2oPbrulydNBRjW2K5zBhD0Rfxdt4FCZSnE7MJnCthXMvaXCzRZ9kz7qePyfDyTbXPVFN71kxULCMGVbLREs2qJ7xjNehV+4NGuGD+ejsnptu+YcANl5NCfC7yrLd1liu9/Ep7MC7HgCswwcNsBzi3hFyE7g4efqD5PZqOuv4LvgEaMd/wyJJKviNDEa/uQuGlYqFF0/8QZ8bhNIZ3sfRGYP/CBEiMGsnIRRKFXsm0ZK/EXln82N4sl72Z+WK2o5pNHBymnaYc/iAWy5ahgufkuxramW/QQFHffJOmU0yvw8vMd8ozCsRmrjsIAGnEwuTVPck3/wqCn/LnCjxFRkD8q+gjQ2zi09w4NYzriONqdB2eMx1fBLDGeSTHBCIU/W5u+rtbp8FDCPZAsKbks4pZT6cPaollnzOEVgtDodSeO+5SJ6ymqG2+rGgLpz5gO7HQwx9ixfREnNeRMYMzH11xH
 k6R/JSfy
 8hnguBKvryqMICzRYHeDrW1B48i43Upsl0nPs3Mk8XXLEb1pJpdm/cKwY+LGv6UMVadM3OeFF+I7eHNFrV0aH/ArHWJWI/foBozCtOZ5Kmc+SnxiBnclv77CxruI9Sxp2mQzfcYsBE4hG1gHt1Xu3zm2On2qkCSFGLfY27u3095B0gh+iLq90ri+swhMHjY/oKTs+fnV36566iUpEzBIQr3qd3tpaT+a5vuaPUVCMvIk7s64McpGlsooj7OzNbR007snckvdCls7KPgHJ8SHHGgkB6I7nOJkhr1ex656+a0K6AX3B5CjupVNV/2PgP4plLpn3ZNy6SmwFyrHY6G4dHNmeEL7ilshAWh9+jVGUx9mjUxxiSzIRGrif7l85K2ID6NGxBwO6OeUhuo9dhefwddW/F6KEi/IywBIemZ4bSmngKG9aPih42swRSOTNVqhvuUaFLsWS9Th/UHBmIXPwLx5SOm24BBbR23nSM+1blybU84MEfvQovYqrx0UiHSbrB+hD3gJNrGZeeyoH3125OFzx3xtwBwobSLPw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Xueyuan Chen <xueyuan.chen21@gmail.com>

Currently in zs_free(), the class->lock is held until the zspage is
completely freed and the counters are updated. However, freeing pages
back to the buddy allocator requires acquiring the zone lock.

Under heavy memory pressure, zone lock contention can be severe. When
this happens, the CPU holding the class->lock will stall waiting for
the zone lock, thereby blocking all other CPUs attempting to acquire
the same class->lock.

This patch shrinks the critical section of the class->lock to reduce
lock contention. By moving the actual page freeing process outside the
class->lock, we can improve the concurrency performance of zs_free().

Testing on the RADXA O6 platform shows that with 12 CPUs concurrently
performing zs_free() operations, the execution time is reduced by 20%.

Signed-off-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Signed-off-by: Wenchao Hao <haowenchao@xiaomi.com>
---
 mm/zsmalloc.c | 29 +++++++++++++++++++++++------
 1 file changed, 23 insertions(+), 6 deletions(-)

diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index 210a777081b7..f3045345e3a8 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -884,13 +884,10 @@ static int trylock_zspage(struct zspage *zspage)
 	return 0;
 }
 
-static void __free_zspage(struct zs_pool *pool, struct size_class *class,
-				struct zspage *zspage)
+static inline void __free_zspage_lockless(struct zspage *zspage)
 {
 	struct zpdesc *zpdesc, *next;
 
-	assert_spin_locked(&class->lock);
-
 	VM_BUG_ON(get_zspage_inuse(zspage));
 	VM_BUG_ON(zspage->fullness != ZS_INUSE_RATIO_0);
 
@@ -906,7 +903,13 @@ static void __free_zspage(struct zs_pool *pool, struct size_class *class,
 	} while (zpdesc != NULL);
 
 	cache_free_zspage(zspage);
+}
 
+static void __free_zspage(struct zs_pool *pool, struct size_class *class,
+			  struct zspage *zspage)
+{
+	assert_spin_locked(&class->lock);
+	__free_zspage_lockless(zspage);
 	class_stat_sub(class, ZS_OBJS_ALLOCATED, class->objs_per_zspage);
 	atomic_long_sub(class->pages_per_zspage, &pool->pages_allocated);
 }
@@ -1519,6 +1522,7 @@ void zs_free(struct zs_pool *pool, unsigned long handle)
 	unsigned long obj;
 	struct size_class *class;
 	int fullness;
+	struct zspage *zspage_to_free = NULL;
 
 	if (IS_ERR_OR_NULL((void *)handle))
 		return;
@@ -1529,10 +1533,23 @@ void zs_free(struct zs_pool *pool, unsigned long handle)
 	obj_free(class->size, obj);
 
 	fullness = fix_fullness_group(class, zspage);
-	if (fullness == ZS_INUSE_RATIO_0)
-		free_zspage(pool, class, zspage);
+	if (fullness == ZS_INUSE_RATIO_0) {
+		if (trylock_zspage(zspage)) {
+			remove_zspage(class, zspage);
+			class_stat_sub(class, ZS_OBJS_ALLOCATED,
+				       class->objs_per_zspage);
+			zspage_to_free = zspage;
+		} else {
+			kick_deferred_free(pool);
+		}
+	}
 
 	spin_unlock(&class->lock);
+
+	if (zspage_to_free) {
+		__free_zspage_lockless(zspage_to_free);
+		atomic_long_sub(class->pages_per_zspage, &pool->pages_allocated);
+	}
 	cache_free_handle(handle);
 }
 EXPORT_SYMBOL_GPL(zs_free);
-- 
2.34.1


