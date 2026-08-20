Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CDDC6C5DF81
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 07:59:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E9AFF6B00A0; Thu, 20 Aug 2026 03:59:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E721A6B00A1; Thu, 20 Aug 2026 03:59:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D88296B00A2; Thu, 20 Aug 2026 03:59:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BEAB06B00A0
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 03:59:46 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C62B680680
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 07:51:43 +0000 (UTC)
X-FDA: 85120878486.07.E803142
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	by imf30.hostedemail.com (Postfix) with ESMTP id 1475B80007
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 07:51:41 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=pxV4vAcy;
	spf=pass (imf30.hostedemail.com: domain of zhaomeijing100@gmail.com designates 209.85.216.41 as permitted sender) smtp.mailfrom=zhaomeijing100@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787212302;
	b=vc6Fi6ze7iGj6OryaE+hVIRiYamFXUNuTc+6w2vMEvKEMLNaTNMTwQ7J8U7Vy7LGJYgEcj
	tda+yf/SYEIg4iroPjHTlengGY91DRBTdbe2gLIG4D1DED2O8+71RBwvk0VzMoT1HNUf6k
	Fo5x8uruGNqO7hZsABTlse55DV9r4/w=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=pxV4vAcy;
	spf=pass (imf30.hostedemail.com: domain of zhaomeijing100@gmail.com designates 209.85.216.41 as permitted sender) smtp.mailfrom=zhaomeijing100@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787212302;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tcJ4CUJSv3TwjcKRyBJSt8frSb6FbG7BZe62qdbIbBk=;
	b=pUcJR2jr3J38o+Wh0VtPc2HxZw2tCGAHlpGVv4bguD6xyhQGrFZQmr88aVI3n/bojASHXE
	ZO9OnUvYZr2q9PfWpbAPTUh7hgh0FwfPB2GEj0C/AEqK73ej5E/3K7ZTi/CxdOPYknpEdO
	AhxEC+oFBEo0h72vji91lhPimcqc20A=
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-38e3efab7e0so518611a91.0
        for <linux-mm@kvack.org>; Thu, 20 Aug 2026 00:51:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787212301; x=1787817101; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=tcJ4CUJSv3TwjcKRyBJSt8frSb6FbG7BZe62qdbIbBk=;
        b=pxV4vAcy3EwHzX8nhTPuThSFbv5C+Q6dbUgIX7LDDXK1WBuUl27Ef67QKlK4sZhDx2
         0UbjoFv50swR9QsTUH9CM1J0tyiU0K8x2IoVxO5vPpfqQfFv8FOJxKh9spx4wzIXCK/l
         17vtcGHUjJYVyay2KmxcTYU+ZD+3Fro22agf81LiRM+vsMqiOPkxSXpAnBkk21qKx7xs
         PjOY2LQp9tqppLwacwcCOMM4rX3+X6I8JrISyBFmSI4HW2ov+Ortrcgkd6XtBBPN0zPQ
         jY8kt2mwkkPRzCpokHpuI6sAZNpuMysS8+58PpeGS/KNxdA9bqn+OKgLITQkTYyPT0cu
         gZRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787212301; x=1787817101;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=tcJ4CUJSv3TwjcKRyBJSt8frSb6FbG7BZe62qdbIbBk=;
        b=OXlpr1mQMsz8+OExMvH5B6PC3HrSlX12vbS9zJuek9t5AoWIuI+kSwfac7nrqNMu4S
         ENkPDmSm02ANoP7QfIuelaBn9UR8UaC51bGumiDlkBwdVBHIGXVRtN55MvfERKtC2NUk
         nvunh2RVcklH/wtgobJZe0XGq+ixGuhbECrahnkKLDZxfNtQR+UqGK+S389q+rDIVcLq
         +l9pkp3gsxtfy9SLVksdv3ncaB00sawqF6aO6cdskxD5XZMMayNjnHK3Zn5mEq9zKBeB
         acfPT7XZWwBKrNSecIIOD7MaGZ1DxSFyqw+M3/fmgJ97dayEO7F5XKLXejoTTxs8YYmD
         a1yw==
X-Gm-Message-State: AFuF++mAs8cGeHQ/iU3mBADU371C2MaikNWvcvOA/T8zRHxoIQZBoEB6
	OM+DvEdXExYVqpsLGXJ6pYDTn6wY8O0SoTaUrRgZrp5hMuCG8HfBrKzO
X-Gm-Gg: AR+sD12QdH1RfoxNlUr06blvL67GF80NAsKhBLQY3ZI1yhqaBGlYav8a1OVNDKX/RUt
	y1cmE1bmL6y7Wo0LYsYIDrhKnU2gUjIzYVGa4x6xbpVTBosw2ZE113OYYIcEHdE8Orqm44SkAte
	mI4/d2iNBVm+yUcx3hE6U8MMb4riy46o10mYCQbvcBgOiAXgkJNLLu/b41njzVsKMuxTFBOZFhc
	/YTnVW4FSVq/BUsWscs1EiFKc1xgPsPvkEZrBogSE3EsPQwq84E5sXWXFOj28N7mh7VhtpTYRqK
	X/0tkw2dnfXOt3ZEuy9sL+Y0/TzGRDLvbfE1HArdAV3pTLqNeySkI81jiNdrGhP5zbSXAw/Poti
	unq+Rns1bQTlsiYp6K+sH4GiioOKs21FQwdzpsR6djmrzKaW+eMsQPcv5gwrIes52NIJyxru73J
	UyVb3WdKTiBjYAstfs7Q6iJEK5BhnipUjA5n4xUDjUNhgoRsq2hPl3ziNqzzOJAK4lO4XxcUM20
	W9Key9CtSLvHND/CQ==
X-Received: by 2002:a17:90b:394f:b0:38e:9ca8:e99 with SMTP id 98e67ed59e1d1-395a05f2a2fmr4888764a91.5.1787212300631;
        Thu, 20 Aug 2026 00:51:40 -0700 (PDT)
Received: from PC-2B0BA31200898.company.local ([122.11.210.25])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-395ada67783sm455429a91.3.2026.08.20.00.51.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Aug 2026 00:51:39 -0700 (PDT)
From: Meijing Zhao <zhaomeijing100@gmail.com>
To: Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Wandun Chen <chenwandun@lixiang.com>,
	Meijing Zhao <zhaomeijing@lixiang.com>
Subject: [PATCH v2 3/3] mm: memblock: synchronize debugfs reads with memory hotplug
Date: Thu, 20 Aug 2026 15:51:22 +0800
Message-Id: <20260820075122.3294367-4-zhaomeijing100@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260820075122.3294367-1-zhaomeijing100@gmail.com>
References: <20260820075122.3294367-1-zhaomeijing100@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 1475B80007
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: diqrfrzujt5pht5zgoo4jj13dzb9fe9h
X-HE-Tag: 1787212301-737262
X-HE-Meta: U2FsdGVkX18DrDwqMWxW3s1CnP5coIdremPan96TJ1v+yemiYn/Vp/egF4lZDExAi10Pmdg/uPtgwcVbJI6YpSVfD9eBvicl0cwUgCCQYIyky1nG4z7AQVPgWAmvm9ksbK1GyGsvx1YiQoYFftqdQo/WvMcUNjM9nvJJuW696Z7oND6kFKvMBzQKVIP7FR+p/apN2osQDWIBEPf0vy9l9SrXjM/eOCTMchldSFvUbaTxRNKDUJAHen4e4AfqP7qixYlCVjHp/pObMMTHNGuSBmXVzgpYOAraJEUILygQgH71NO16UG5FlPxPSmW9fqgInDV/cnwHLIok+meblJVF3U6DqNL2tqWiuW8Ohxo3nN5wd8juCU/wWZdZksMiR67qTFaQEe5USpYX64LsRkYtIa7uIxQWHRFssQqpg4ThrJgdHQTdLa3u9zr0HEKMJAfrxk1jMxm9JU3GVgWZhV223pJrsnd0W+xhueMuDIJpOoxO99nILWzGKbjYryRj7bdSIBysDSH4rT88G1rb50wNWD+8IjzzoNMvT9QQlgu/ClPhzQY9Sv3ukbgC+jO/C+XJ8wvlLNo7MlzhRQeaqLSiX+PCO0JpxmnxV5xWlgfUk0llPUzNO2NW4tpySQbykC+ipjbiIHWb4w2c1e0vIqM7ZN4EiEslwz1t2F0kDDHxx0iU4S0avyKxFbD/Xt96PgJeGPTh4tKuE8KfSHoxgw44xr0diC//i4i0KaHy3I6D7OMLImaB6UCW+Aa8mCzRrbCW6p/Nni89vcam8uv25hBI0GhyrpunAYXeIVTeyGYqgpwodmJhiraWuMZeceaP1uFwYVUxl35G3aoqDr0Bh2zY996nV3gIDBC07XWX71kbHxAeYGIdwY05II748vmux5ACI16hX2XaL5VowAh61Ff+sgVHQHM1/r7s6g2gLk65/+V/wueyNIEcUAKOjEW0qrAkng+KYe1DprIj0BGUBh6
 L3pK1RY+
 VNJ19lVWwMnejmxZsNgFTP1vPaZZn8ICTG3V/vkWzrp6lsgfzI3Jl/z3Rut8bgYoEjT7AswSSNRKGyXmeL4w9a/WYCi1YE6iC0/zOf1C8yJBixxbE18djRX2bBA1X8DtUC2Yv2xNfZ88jm+7KH+/qmfS8M/IUW/lYk5h1elT/tJ18s1tgajnvya2C3EyM2CQ6PxbEpxqCXh7lQP1TgKbTL8lNf48KZbdMcOaMyrS/Mb5tq/4kCTbe+axdPfUq80BDBmc40UIX/izz2KFomyKpbt3ZTbPjmwpKwUkl/CKuZsOLspPiKVuzSKjIVYPR2YhUc32FpqDvfu6ZDQYUDVC8MOL4UYMbyzcBya3A3AfYVSizddvlOSJPygetF4oW+7+QlIpx0noOpipVPjpdrzhEDHdyYN60hopwNJLp8tCYrQAfagXSoD6A2wt3jl9z0skLu0ZTT42BXxlzp26KH8mQzr7fXSANZCxxqff2X9OPXfLze6g0t4TmsuFUMgUMPvl1KHAv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Meijing Zhao <zhaomeijing@lixiang.com>

memblock_debug_show() walks a memblock region array without
synchronization. With CONFIG_ARCH_KEEP_MEMBLOCK, memory hotplug can
concurrently add a region. If the array has to grow,
memblock_double_array() replaces type->regions and frees the old
allocation while the debugfs reader may still be using it.

Hold mem_hotplug_lock in read mode while producing the debugfs output.
Memory hotplug updates already hold the write side of this lock, so the
region array remains stable throughout the walk. The helpers are no-ops
when CONFIG_MEMORY_HOTPLUG is disabled.

Fixes: f9126ab9241f ("memory-hotplug: fix wrong edge when hot add a new node")
Signed-off-by: Meijing Zhao <zhaomeijing@lixiang.com>
---
 mm/memblock.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/memblock.c b/mm/memblock.c
index 7eddcc412618..620a5dd7f5f8 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -14,6 +14,7 @@
 #include <linux/pfn.h>
 #include <linux/debugfs.h>
 #include <linux/kmemleak.h>
+#include <linux/memory_hotplug.h>
 #include <linux/seq_file.h>
 #include <linux/memblock.h>
 #include <linux/mutex.h>
@@ -2916,6 +2917,7 @@ static int memblock_debug_show(struct seq_file *m, void *private)
 	phys_addr_t end;
 	bool first;
 
+	get_online_mems();
 	for (i = 0; i < type->cnt; i++) {
 		reg = &type->regions[i];
 		end = reg->base + reg->size - 1;
@@ -2944,6 +2946,7 @@ static int memblock_debug_show(struct seq_file *m, void *private)
 			seq_puts(m, "NONE\n");
 		}
 	}
+	put_online_mems();
 	return 0;
 }
 DEFINE_SHOW_ATTRIBUTE(memblock_debug);
-- 
2.25.1

