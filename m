Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D0D3C982CC
	for <linux-mm@archiver.kernel.org>; Sun, 20 Sep 2026 09:29:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A51DF6B009F; Sun, 20 Sep 2026 05:29:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A03006B00A0; Sun, 20 Sep 2026 05:29:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 918896B00A1; Sun, 20 Sep 2026 05:29:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 768126B009F
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 05:29:19 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EF52180398
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 09:29:18 +0000 (UTC)
X-FDA: 85233617196.11.3F03904
Received: from mail-pj2-f6.google.com (mail-pj2-f6.google.com [74.125.227.134])
	by imf23.hostedemail.com (Postfix) with ESMTP id 31670140003
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 09:29:17 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=X+2zavOw;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.134 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789896557;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E32DKEy2LsQDqopReHm9os4YgHCG98q1Wgi6cD5WuWk=;
	b=n7uvGgg02/4eO9W0jiZII+KDktxjbY0E2iF83ije3UU/K26adORTSq7mmN/NK7WOS2+aVo
	2DFfKYWdmMvUiXRKa6lIJxskYdF5znAp81/lAQXXi5FQFxOC47n6aUMRh+m0t59IOZjEUN
	I7+KLhdBfpCgZFW1C3xmGC98ikLfdwY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789896557;
	b=RWDy0FuejBAw6rMrkcKrMxZlGNlGXs+El54pl2CC1ZHXH14n5aCUfV5jRQFX9A+WJC5bg0
	yhk0J1JxRxN3mpbaxVQ4TsmBPOfMlfZvUI8fgbD9Y63RdP5Zj8SEKNZBWG/YgIs+qDETez
	YN/mHONJWXCq6mhpYqG7vturQJimt7M=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=X+2zavOw;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.134 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com
Received: by mail-pj2-f6.google.com with SMTP id d9443c01a7336-2d74bbdc61fso2286685ad.0
        for <linux-mm@kvack.org>; Sun, 20 Sep 2026 02:29:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789896556; x=1790501356; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=E32DKEy2LsQDqopReHm9os4YgHCG98q1Wgi6cD5WuWk=;
        b=X+2zavOw6TAFzBUcX1AVZ7QeYvZMGmVyKVxDq1OQVDmYT6rJPXp0myUIZWuQfc5SSB
         DxDMjEnq3sC6/YeIKRyBFWHfNFVox8BXbI6Kjqbw2rkR4A1p1BPDr+UBI0wHRtnEvRAa
         atdpdad0QbRLikv3iMXJ8RMc1SJqpUfUKr2m22D/+8CLInb16xrwP+fC8rBJnCFipON6
         pPz4Q2TlVJV/MfNRFsuRWvn0f48zs/XmG9vqjsItvyUH6xo+V+bnt2ECTT1LP+mvRDue
         S1Qde5ob3YfZGfaHTM8UHBLWFMZYQNoqKkQ3ibtV9m1Dirb4Hc6xAYwBTd73+FjLO+3l
         w8Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789896556; x=1790501356;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=E32DKEy2LsQDqopReHm9os4YgHCG98q1Wgi6cD5WuWk=;
        b=t6dW6wX1+JMRiw+1HqftKd9AuqnDy/X6ArRGs2DOOdARo441uKVVtWF8lVIXazm/C+
         FuCn7IY1ELdFXuJ01rD+ykbZNJZmm22CRQ5XypXuna80tb0aoIsv6HA1tVdxJYYOnVfC
         uLvZ04SwP54pNe5NJluCen3TA9BtXnXcXubo4rryLwWbx7cF1suEgCbF6fqoJ/MaOpv5
         sCHjG3tzf/FnQxyid+3w0zT1L/iXqmveSm78t0aoCkBHknDn3r+CmqWAyvSqVbSbwe1W
         5EQFx7yLVbx+KJqldZetTzT82YPu86inWk3C2DGPPcfExPxzj3S7pCXGHChSVpYB23fJ
         SnGA==
X-Forwarded-Encrypted: i=1; AKwUvBweMZN583VuD/13rMrvVFJqsNF8ptkGxF41CkOcWaceuRnjsJnWLjHuUAJhAYKQSamrWPPBK+TJXA==@kvack.org
X-Gm-Message-State: AFuF++karpUWyFI+dXO7gvX2LRCWCCG/P6ymmNcEZ+TPC5fFqC9fZ0Lo
	R64NGVyQLTLPR9hEk01ETL+4v1bdXNaFsIMwPo6vZy56hKTPAG4CecgF
X-Gm-Gg: AYBFou2EJXYF5ZPghhAaJ6dypC3gjz5v7VxU8IKudT9opSs6S7NbAkSPN4weT1ZVw3V
	QbfwCgxql5ASCEmVv37Sg9QPy+lISVhL7gFtSOsK7mGfrrfmSIxwHrfxsBAW5y+c+htjd3R6V+F
	Nk2wuOdWyAU7gxSo7dwhgpyOxVS8ZK8b89aee9+GJgss8fmc1rPuqDXNOtZx2uROc6TxMe5JFvP
	cIe9eO9a5dV8Xvg1zAscGdI2b3N2N4bMGtarQ+2QlIkmLiYHM0jf7g73y+s2oTOqHYiVKA7N4LC
	CbZxzlg7WHdytz3cFvwLyYLBTuKJAQ7xjObiP4dxmObt+sPVanNByfHj+UD+3ROQ6TfE+UM45gc
	e8BB1p1d+9On9av0gtT7A72r7jiYPb9Rkznr0fAUl3ChQfioXOTH+E8bjwz0BGdBAfcXvcr/in2
	NGda2h87UBvXdXI/XKMwY9TDBaKJvNNKOCCYSDCaT5i5mkVxhTLFVt0/C7ULL8YPhADmB0CST0e
	HkmQsIPtWejptgRuUCpCIQ=
X-Received: by 2002:a17:90b:3885:b0:39e:4c7e:bc4 with SMTP id 98e67ed59e1d1-39e556f5d26mr7972845a91.18.1789896555881;
        Sun, 20 Sep 2026 02:29:15 -0700 (PDT)
Received: from intel.company.local ([122.11.210.25])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39e6c37c64csm8154917a91.10.2026.09.20.02.29.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Sep 2026 02:29:15 -0700 (PDT)
From: Wandun Chen <chenwandun1@gmail.com>
To: robh@kernel.org,
	saravanak@kernel.org,
	rppt@kernel.org,
	m.szyprowski@samsung.com,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: akpm@linux-foundation.org
Subject: [PATCH v3 2/5] of: reserved_mem: retain static no-map memory on init failure
Date: Sun, 20 Sep 2026 17:28:49 +0800
Message-ID: <20260920092852.614973-3-chenwandun1@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260920092852.614973-1-chenwandun1@gmail.com>
References: <20260920092852.614973-1-chenwandun1@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 31670140003
X-Stat-Signature: 3mocitiytoq8187674wceu8cw15gac9q
X-HE-Tag: 1789896557-568669
X-HE-Meta: U2FsdGVkX1/zkydGz+KoWcosF2oiVMWR/VdBwM8dnfLo/DmZgZ0wyfGBfGI3jIxghLcJRgUI1Y6UGvSx0ig00IbEq+MDlaSEm52q6j5rt4GM0CCn0j/3WQ+VPfrSaPgEp/6mzxen0sdJJfFakotDoeHDAsPOeit8vbgSdP7WpuxLKhbZW+bC4Xg0uqkxCNXpCAPJBCfctDaiVtpU/e+HVEm+x7vOFBY1kc6gHkElbH+3rp6zqOjfGIOPcHEY+WaZFNyDjmJFni5caNnpS/ar2He8xGslJyTKn9wgbGQE+2rGfbZ9o0lbf/UJC+RiRVbFOsrAAWjlYF+DLimV79UuC8kX/MGE+IH0BchjZpteiMVuA8nuY73VX98NkCu/YqXMNTLZ0Qjoahm7FNamrXl+6552PBtBxFLZmV5TIs3N0h7EV125+taKtUuRorM38wouhbV0nA/ZKjIFmaeKXvgfgfdJjdGyFgvPs1iRJ2t2m0EIY573U8fsuvwq71Y08d08VZ8Xo3WZxSC4o5r8WhFP1OvZ1WORTaiVUfcF0CikO7JEnlHfqZNO8dWFmu0bxm3x22WRUahJWt0q/U0Wj1a1jsDfeUkFVgvZIeGlnxoD57z/Y7xt7gZhSo/QzNiPhQBUjpT/AQ37ojofAxTECIQHqOmvOJ/tXpaAZIM+gvkotMQcuJ9qZilGZJgRy8fwgYub9+fy89c3D/5MfXPeZD4Ucp5BzAsDmRFVIW0DIPxNHhvObVqGChZUtaRJPjCpt/UvQ7KcxCizYCA2rk1P53/hbdVdPvrxhZwz14JKYJIZpFrMgCcYNohnwjo+0Jlw7I9xhy/o8ZMH3cqGqBXKrmThu3yHLhIWJP4+JOMx3mLV6yT2js11Q66oWcnJZGYZALk3KY2CdgDu8K1vaHDbx9QSUkNjDUrb82VJ0dvK7tagqCfFjm8huqO3i7PyjfChYaxS8WJcr09r/piz0Iauef0
 QcJN/zd/
 mhO0cqdwhffGzHYEZ8a0AQBZtZk5NEtKqjK4/vuTKzh5sPT2Nu5CPNsPm9M7m0LCZNixmPIQzvD3s5dLwxE3ZDIxlIB5pNHh0sBYFFcBjqgHTapYRTMkAeaywZNnsSxV3iifhaySGNbYaLGk7yMKYDh66t+KhIQSuJJ33jsEMlq12pRJoSb1KL7d1WZLEJ59B7vmfODLp6kjDSi+cKszilVJfmX+BHfYqNErQ5TiJECZ7wOoVbmtmWlAisuTasbGAr7Ivcyn542dgTQ4JpXzUriZsvv/bFmw65kMUnezRljnv3J7ULmjzRTVqLDkZ4ywh0M5Wp1Wux7BNKgaiJ5iemL7H3LaNnPsLYsVp7jAhOdQ4Xn8uF2MEGyJJfoevy0rhAWHbrEVqvT2C1VuKw/EDcM3YPzdT4NUXrMc3F9yO+o6lmOpd9+EH6QQ6e0mgNE+0XlUH/kgBSLf47B+VUM4PeFYVCA/786fPJ8lUzXGnUqKsvfnSr8w5amPmtfickuOUU77Q0NFsJaU2p1nEKgj5uJl1/1S+76C35TXAo8is8UBTBemZP8ausv1KztFAsWaEIkqRajk73364At0YaaqVJsfbsw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Wandun Chen <chenwandun@lixiang.com>

Static no-map reserved-memory regions are initialized after paging_init().
If initialization fails, MEMBLOCK_NOMAP would be cleared, and the memory
is available to the buddy allocator even though it was excluded from the
kernel linear mapping.

Clear MEMBLOCK_NOMAP only for dynamically allocated regions, which are
initialized before paging_init() and can safely be made available to the
kernel linear mapping.

Sashiko found this issue in [1].

Fixes: 8a6e02d0c00e ("of: reserved_mem: Restructure how the reserved memory regions are processed")
Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Wandun Chen <chenwandun@lixiang.com>
Link: https://sashiko.dev/#/message/20260814090305.4C8741F00A3D%40smtp.kernel.org [1]
---
 drivers/of/of_reserved_mem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/of/of_reserved_mem.c b/drivers/of/of_reserved_mem.c
index f55ed3b5aaa4..2c64d85cabc6 100644
--- a/drivers/of/of_reserved_mem.c
+++ b/drivers/of/of_reserved_mem.c
@@ -660,7 +660,7 @@ static void __init fdt_init_reserved_mem_node(unsigned long node, const char *un
 		pr_info("node %s compatible matching fail\n", rmem->name);
 		rmem->name = NULL;
 
-		if (nomap)
+		if (dynamic && nomap)
 			memblock_clear_nomap(rmem->base, rmem->size);
 		if (dynamic || !nomap)
 			memblock_phys_free(rmem->base, rmem->size);
-- 
2.43.0


