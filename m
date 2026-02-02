Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 062B2D172AE
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 00:55:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 472F16B009D; Sun,  1 Feb 2026 19:55:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4475F6B009E; Sun,  1 Feb 2026 19:55:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D9076B009F; Sun,  1 Feb 2026 19:55:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1F6F46B009D
	for <linux-mm@kvack.org>; Sun,  1 Feb 2026 19:55:43 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BE84513BF36
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 00:55:42 +0000 (UTC)
X-FDA: 84397698924.18.A3F4207
Received: from mail-oi1-f174.google.com (mail-oi1-f174.google.com [209.85.167.174])
	by imf16.hostedemail.com (Postfix) with ESMTP id 06F22180006
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 00:55:40 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=UMfTnq23;
	spf=pass (imf16.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.167.174 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769993741;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cYjr1TGhCAf/RKiT8q6ihWoR60MJtgSyO0Vv0YqmLhk=;
	b=EJc9BgKirT/5dWam/SnAh6sFxgeIBFqP+bDWcCMFh4gBwKKwGbuv+xLbPPOA6Hk/RDH8gO
	SsNDm7cTzvBzTXJZNKuR1IMoKrDBGUhzS0BhmEd9XzTRomykookHqCiYEugx8JwcakzohA
	+57z5uPL9y03Z+63aInmX4c3yJQe5fk=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=UMfTnq23;
	spf=pass (imf16.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.167.174 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769993741; a=rsa-sha256;
	cv=none;
	b=uxZK0nI+lBwA9beFa0+pNUsU91xgtFJu2l8zuiYTmWCTxPTPlB/rj0j+8RL9frnbYNkzHf
	MMGRYeFfaUAI9THa9C7FdhXDSxvBidLkMrDg+d+rn29u5Bw2HU5zrs0gR1HIJdOdXDNPk0
	teHuClnatEtuZHBYHD8yTYJU1l2gTJg=
Received: by mail-oi1-f174.google.com with SMTP id 5614622812f47-45f015a3259so1508763b6e.2
        for <linux-mm@kvack.org>; Sun, 01 Feb 2026 16:55:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769993740; x=1770598540; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cYjr1TGhCAf/RKiT8q6ihWoR60MJtgSyO0Vv0YqmLhk=;
        b=UMfTnq23/2s6r7AX2Gc/nIu5bQAZjClaew9GRm0uhrp0Vgq1L7shlTUyD5+p1SrvJY
         QRuBwp5vvTeFCwOt41BB4p7C7Xk97dxsuQ/Be/D4VVjAtBqhb4kAPEf3zid2uyIjtN7Q
         lKvFiYyuzfAjB0qs+BlYItZUhfrF4SLrF0ilfWGqGJ33rT+opToSIY0XxzOrxtFCTU4L
         zHjXAKAYO9MHqmM+T5O92elSv91D2+iYIPrMBPwRX7a37eE2UrKfqeOa5a3P6d3DOYVg
         FG7O94MuNMjStk6QrNmG2ODvjbLN/IzgtLh6gArtkHmTFi47dyE6+vjWEo6nW3p0k24I
         NptA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769993740; x=1770598540;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=cYjr1TGhCAf/RKiT8q6ihWoR60MJtgSyO0Vv0YqmLhk=;
        b=wHgAKz76ECqhGoppypkTfgj53AjVq3El65kGRkdRj+bEkVLTju5Ao8u/7OD0jJKvx8
         jVdPNAhnrZsDcO/MI8vkleUJfQua+auoFs0Sb1APDEKO10yH9MyFtu8X6zp4bAqEI8QY
         75q5ubNUs/N+FeN7A0sZ+6wam0Q4+73+F8rbHkAZ1yyeCQi5C36gd3zDdoaytIozwJ0W
         UKhf58k9EMYLKO8EbPYtB3qkQ8+zaU7dUmtKTtgusycywLWhtqOlddDZc+ZPLDSwYW7M
         KawMYUwA0EgxWlCDXyGcjIhotsLLf12o0SmCNSqmMpsaPaJJ3XiiY6vn07uUBZLr42pL
         8DMQ==
X-Forwarded-Encrypted: i=1; AJvYcCWvSmQisSOvq9m2SunHKEanVf28M74Dz+0vD7kOy18ESElLPWDfY28hR6nPOiYHlKpo3FhO+Sdyfw==@kvack.org
X-Gm-Message-State: AOJu0YwBXLSWBJPouSPYrDbK3GyCc7iKu1sRE6L/FGsDpT8cJje+68UL
	RiR8prPNBjTe0MzboZ2jmGzjR/se2jxS9mW1LBYeeOmyWSW8bCm1Y6Qm
X-Gm-Gg: AZuq6aJ9P94kZQjTPK3Uduvj7eDoTqzpkBMt1m1o7MSOnDXZk6R1XoM0IgzGnbuuOLZ
	/C5/nzRx3v4bBxYgdhYXY2LnLJfVfvtoyvqnNL/1BrGClU69yiNVl31dy7etft+45vXt0bkVgKx
	Sv9Ug/oho/ZGZCnQqbzJ7ShO4lkJNEilqzOG8vthUmaPbxEY0ILfYtbSpO5lzr13Ztidcn/0NyN
	f5I+auBJhuNsBQOcZUTB97C3eU2VrUSEYFWN84BOxE2ZyUcJ8wtrwB94SswqVvWUem9hwctcV/h
	cvnIoHaFygZ6E7PCZt4mDxpmkeW+7f1mzKIKKi3YgAzsMUJXl9iXCootaAniu1J81VsUaEtM/pg
	45aMB0APZXfs31+gxiOcAaQ9XgMn9qT0eVL6hxbgv45MqsZmHNkQpACrnyQXZmwNzMM9053zCFZ
	Dp8yoiam2V
X-Received: by 2002:a05:6808:67c1:b0:45f:21a:4995 with SMTP id 5614622812f47-45f34b832admr4654575b6e.23.1769993740110;
        Sun, 01 Feb 2026 16:55:40 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:53::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-409575f6551sm10693913fac.22.2026.02.01.16.55.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Feb 2026 16:55:39 -0800 (PST)
From: Usama Arif <usamaarif642@gmail.com>
To: ziy@nvidia.com,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	lorenzo.stoakes@oracle.com,
	linux-mm@kvack.org
Cc: hannes@cmpxchg.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	kas@kernel.org,
	baohua@kernel.org,
	dev.jain@arm.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	Liam.Howlett@oracle.com,
	ryan.roberts@arm.com,
	vbabka@suse.cz,
	lance.yang@linux.dev,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	Usama Arif <usamaarif642@gmail.com>
Subject: [RFC 10/12] selftests/mm: add PUD THP mprotect split test
Date: Sun,  1 Feb 2026 16:50:27 -0800
Message-ID: <20260202005451.774496-11-usamaarif642@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260202005451.774496-1-usamaarif642@gmail.com>
References: <20260202005451.774496-1-usamaarif642@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 06F22180006
X-Stat-Signature: uszriiam963powpd5gz1j8f757h6pehg
X-Rspam-User: 
X-HE-Tag: 1769993740-945183
X-HE-Meta: U2FsdGVkX1/wx9JSgsFjJA/XWltd6s2MAXeb/U9eYChzRi+amISVwtpluiUpB4izkdhkNeemDxyl+KQv0L80q7IwuNN7snpnJ6A66RA3R4p0WYU0X9VuJ68myraA+TJY6D1NgrPG+dJaeS5+WeM3yb79DQbR52UupZrcDqaS3iFaavu4bkdg5907149C5UUVVYJiqElGp9lL1ZFE5PsyK7NGjmeq8GLxdxs/G1A/Gc7aC++Eja0emoP5CZoYkQx6sXZk3LYOFjTy6Hd5BCP25pvbQPrIMMiXfBuehpWdxPvcqADMRLorn7iULIm0Ybmym8+v3XFmNjcFPibo7bbSTmOhNrFuzbboDeP5QkkbGSRdCGZ8tMcjdGiNZ9jw5YQqaN64lg+nd9bwakGGS0gYTVH5NUArSlSj7MEOg3+ggeyvPTMJiByx9fSuQluAVnxZeJaDaj1aF11cYoDpMG73nT/ewb/mKjoSIsEk1kxYSva1/j6vZpyKQ1JDx/piWyAopel3rFkn5F9G3FI1Q+iF/P2rzcQXv7utyyx/mQBQuO8LmnZgQ/lGiQfOopBmWdzzVvP/Eg0pTIGShrxiYTQ1bk4doHtJ+sWasg+uLT5Qnh1ekdTbiLmIxWv8JjSpK3Hjwcj3yQNNSmvh7f8xP7BEwmzpAC0r0UAGyr+0qW9Bb56YLvqXydkDEDh9tv2iLRpsYrUVAYuWzH8o6piDEEUOInThw4BYElUJjVEemJXVm3JBLqhj5QZ9CZ3wB9uP91PFfetoF0+wCelb8kwD1+qg2S55nbK9E3KZhf6yYE9MKnDR6OIliU1iytwtqGD6yMqByYwmEMLPiLNWCXH+SLhAsmwl/hB5MdYne2z40h2SUxRgrVEnWmTepNMJiSCfcteN9kyVDL423+Mtag3/9X0MEzKrUUQeamaHjiJa/lvus6FU8e1JVZKLVkKxOe6dEa6LXyHs0LMXOhAaprg08iA
 4RRAFP/Z
 81Iq5YorwWMZIRi/QACDtw8bePv6nhIBeAlZ/SK5qiIEUsWLm2jHt2mtzhNdhwkpIN+KdgoYHcX0qIES1+2oCNbKIIu5Dph2DlfjBA6y/e6YUZ0ZegqBdzkrS5waQwixlj0ihpWmM9rzwRwylOw/bS8eIEaxY0iKLCpKcwD/80boSuVw/VsLEzETdC70Xn2WhIx71UqoiJfTDhc6qxleqS7IgIsIN2IygMVUNZUoAj6T0AWAsczGgBtlA4O1SwROIxQqZDyf1G6kTSKn8ID8uKs7JYVEZkvL6foQh5fIEDG+vhkFrdKrwbU/lHcGciq+EV8CYNGSzIllyUBD2sGT/iN6VLWOLNvhcImU1bpIBY4OCWqUjzLpD+MfDNJF81eWQzv7BGbszENiMTH1bvFy6JRaaQFZVs/7qeD2Qao7sV6qd9wj9cllZl2vP2wqXE93k/h7mJMdtHFYqzZRd33DMgu2PJYZPmBaEDVF05F6LV1OnF752zAnSILRW0Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a test that changes permissions on a portion of a PUD THP using
mprotect. Since different parts now have different permissions, the
PUD must be split. The test verifies correct behavior after the
permission change.

Signed-off-by: Usama Arif <usamaarif642@gmail.com>
---
 tools/testing/selftests/mm/pud_thp_test.c | 26 +++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/tools/testing/selftests/mm/pud_thp_test.c b/tools/testing/selftests/mm/pud_thp_test.c
index 8d4cb0e60f7f7..b59eb470adbba 100644
--- a/tools/testing/selftests/mm/pud_thp_test.c
+++ b/tools/testing/selftests/mm/pud_thp_test.c
@@ -256,4 +256,30 @@ TEST_F(pud_thp, partial_munmap)
 	       self->split_before, split_after);
 }
 
+/*
+ * Test: mprotect triggers split
+ * Verifies that changing protection on part of a PUD THP splits it
+ */
+TEST_F(pud_thp, mprotect_split)
+{
+	volatile unsigned char *p = (unsigned char *)self->aligned;
+	unsigned long split_after;
+	int ret;
+
+	/* Touch memory to allocate PUD THP */
+	memset(self->aligned, 0xEE, PUD_SIZE);
+
+	/* Change protection on a 2MB region - should trigger PUD split */
+	ret = mprotect((char *)self->aligned + PMD_SIZE, PMD_SIZE, PROT_READ);
+	ASSERT_EQ(ret, 0);
+
+	split_after = read_vmstat("thp_split_pud");
+
+	/* Verify memory still readable */
+	ASSERT_EQ(*p, 0xEE);
+
+	TH_LOG("mprotect split completed (thp_split_pud: %lu -> %lu)",
+	       self->split_before, split_after);
+}
+
 TEST_HARNESS_MAIN
-- 
2.47.3


