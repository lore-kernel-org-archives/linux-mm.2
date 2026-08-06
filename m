Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 404A7C56208
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 09:36:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 21A866B00AB; Thu,  6 Aug 2026 05:36:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1CB3B6B00AC; Thu,  6 Aug 2026 05:36:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E1C76B00AD; Thu,  6 Aug 2026 05:36:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D968C6B00AB
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 05:36:15 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 76950C06AF
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 09:36:15 +0000 (UTC)
X-FDA: 85070338710.27.6101799
Received: from mail-pz2-f0.google.com (mail-pz2-f0.google.com [74.125.228.0])
	by imf25.hostedemail.com (Postfix) with ESMTP id A9179A0015
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 09:36:13 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=E3AXvt+s;
	spf=pass (imf25.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.228.0 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786008973;
	b=X6NDj6l/7yan0Vjmj93a7XlFa/7ezuBrKCfKCgX7P5XJOgWEMzXid7Bm4q0DULxcsuMVW4
	ATygfE0Ttvpsq3+kTXXMaf1GF7mHZosIOfOQ2Hnc0jDgbYZSlMycGa2wbLiOYI8TncdWQ/
	hz1r9JVQb52MIjbIYu5Dv6nXgblYbbc=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=E3AXvt+s;
	spf=pass (imf25.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.228.0 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786008973;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rxssx1F9jirIGuLt/jYdKLTnwp1BKr8qLnqrQJiF24Q=;
	b=BYJLZgDEIhWsWaTkbhyrFzHKq/iLOyLAS2GQ+Pb0MPpl3KzwqfR1xiGAlU8bcIkFa/U6vr
	mKZKdBhYjEUjzR28zYRyKN1b5tLeJHs22fzb3mPIhdeTCdM3HkvI7aOCHf7t6A/zfv+Utc
	ez8VxYYS+vq6YfP9VwsaB4dnLIADAxw=
Received: by mail-pz2-f0.google.com with SMTP id 41be03b00d2f7-c96739a46acso1071109a12.1
        for <linux-mm@kvack.org>; Thu, 06 Aug 2026 02:36:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786008972; x=1786613772; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rxssx1F9jirIGuLt/jYdKLTnwp1BKr8qLnqrQJiF24Q=;
        b=E3AXvt+stsFI5qvcCcPjdaXqldUxumBW8c2oVmoAYnm81m3RnvhOeHPaMrzVng7d5U
         5RwcN+hmS/e/lTzVd+6mOI1xCm53bWxsuDQiEkZ4K85vc0ZyWkh/8gZmlwh6Yo9DBzQD
         q7LHeBe06Jkp668RXWx/+pVrOri/meJM4H7BQFXj/b1/1t4RHk845+b6QiIciZ5VC5To
         FIo6lIiDN0lfVh2llQxLdHIlVLa6XuQNCQriNq3BlM7Q1C6Wh9R52VdfwMfG9msaMe1z
         9dxgJPakaJkxxV+QJmfseC/ktKoIkxWKp9HRdaFs6tMzbEZRlI2/HnwPR+/nL2U1XxpK
         WAJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786008972; x=1786613772;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=rxssx1F9jirIGuLt/jYdKLTnwp1BKr8qLnqrQJiF24Q=;
        b=FqI8A83Znz6ZTg8oaNN+l7P9nfwHkVx7cVigPW4naEVR1bOrJRF8+KOieP46neJjOr
         LeBgcaq/CmDdQiZJgsEVHsv7oA1NNe2fiB4bf6HRZhSw7efgJHghDDkmK+1yTcFrSrzF
         Ii/m+45pz1hz99bOqmSpFaCjVeonn+/98SMzcktikUNLulChnIPXQbE2+hmXfUrC3w2Y
         W7sdUpb4RUw6XbkmdgsBFDxif0aYG0cB+cH+0BBS2H5Dr1sEAQRHotwvRrByIvT6U2Yi
         BEdPsc3/2PZXvt3gUhVVvl/zJwd+ZjK3xLmB1uC5NjIx+WDCeePxJIOAs05wKk//xNoL
         rOEw==
X-Forwarded-Encrypted: i=1; AHgh+RodMWAbEulffK/fg1qzXyjUf+27RtL9qNPxxeO7qrUOgDJviaPKoXhmYHNtOc4V94p63/fYK4IKVQ==@kvack.org
X-Gm-Message-State: AOJu0YwUi6HvrGQQHHJJlTKARgR7kqYNaRo+WUghYI8oaX3cbQjawnfJ
	/YmZZthPS2HFstX9xmJgjHQZ/7OAreoH0Jl1uUMF/+x3L8CIJ46Ns0aB
X-Gm-Gg: AR+sD10I0FHttK56iTVZol3ugUXzNKlhnU1//gB6hLo+RWbKkqJS33rNI0UkEYd0Lgv
	ClgplmD1Zk23o1E5zSqNsgznNfxjFlQMniWg+Hpgy0WXHyn+QXoE3EOiJia870BJa6WrJT9RUOR
	LlyeUC02weKq78WoTE0p2p8NFllVwhHHkmCYqpQrZjp7O5ST/jn8fhPoCdgFxtBfNLYaLlxM81q
	Q1JapITJngJXq2OWP6ffFsMMEBbAMQuBZ+6aT3GLT/bHxLhLLuhZyEo3Fd5HbIHGjKRiK5DZkWH
	5V9kXF+m+lV4q+FwmIaVjaRxERiR/yE2Hl63RwhX3OYTZfUGX6trLdKEHJK4fl7dUV0xS8jnumj
	k7WgxynScclHtPk69e7/TzRWQQLjebY9+fv81dKNtW7CQXSbB8AOmL2uCh7i4FFLGdN6vgBrbcd
	cbTtKUWX/B4UFiIOJRyrt+4reXCyLymxlCh5lOoi3+OkN4pQkfsmE5l2+G5Qx6txtLCC/R3TcBJ
	g==
X-Received: by 2002:a05:6a00:80e:b0:847:e791:d5c5 with SMTP id d2e1a72fcca58-84f2e0dc989mr14792962b3a.35.1786008972602;
        Thu, 06 Aug 2026 02:36:12 -0700 (PDT)
Received: from intel.company.local ([210.184.73.204])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84f453b0aeasm1043878b3a.13.2026.08.06.02.36.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 02:36:11 -0700 (PDT)
From: Wandun Chen <chenwandun1@gmail.com>
To: catalin.marinas@arm.com,
	will@kernel.org,
	chenhuacai@kernel.org,
	pjw@kernel.org,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	robh@kernel.org,
	saravanak@kernel.org,
	rppt@kernel.org,
	baoquan.he@linux.dev,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	m.szyprowski@samsung.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-riscv@lists.infradead.org,
	devicetree@vger.kernel.org,
	linux-mm@kvack.org,
	kexec@lists.infradead.org,
	iommu@lists.linux.dev
Cc: kernel@xen0n.name,
	alex@ghiti.fr,
	akpm@linux-foundation.org,
	ruirui.yang@linux.dev,
	robin.murphy@arm.com
Subject: [PATCH v5 3/8] of: reserved_mem: mark /reserved-memory entries with MEMBLOCK_NODUMP
Date: Thu,  6 Aug 2026 17:35:14 +0800
Message-ID: <20260806093519.2907771-4-chenwandun1@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260806093519.2907771-1-chenwandun1@gmail.com>
References: <20260806093519.2907771-1-chenwandun1@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A9179A0015
X-Stat-Signature: u3md4cecs7bt5nocb37mypui8z95sfie
X-Rspam-User: 
X-HE-Tag: 1786008973-582086
X-HE-Meta: U2FsdGVkX1/84hE0Nu5eTB3ua5ZU6XjbPfkrTwtjCaW7MsEeuvRyrM9HvqhzpNtsezBVZB2j55vJdCRgBN8+EGMlcbG8ZP686nNMreckOXPfdi7IJgCNHWHSjQmiFrkDd2pVyFa45pQFsrPG3HZo1b9VCriy2S16esPSdzHJSEH1YgDdwUjrI9QLREURsg/6i1tyAIW0xUC2SYeR2R6VvD3SioAAuv8NGl0EMP5Dpq6G8CjS3GQHt0TcQgs9g/j6frzUL9f7gtvUAMTVbJoXXHUV2QKIyhfSTrO842UzppFB3H4EH1kWRS0ffihcL0bENoSA5xfobhpehuWHEajxmQr98uZEdAPFk3/9b2Xdx7J7CWg+9S6QsMoKH8BeRkx23kPHd8dYca/V2nFh9ZFG1EBl6GkPSi9GdGQ4ncK9PKvT25ilOgBZGNzL0WF9EL/i5WQ9CwMV6ylCwouoCusQe+LzBJ5oCv7EE6CWocADo96o1snRox9w5x+9LTdPBPsgkpzAv73aQrdw8Odxyinh1ziWSZu/KuivRsoUQhAy3AayRUaHof640TmbW/GLWe5hKyzJkYJGXTIMbVLk2AlYlWuGPrUjpv3bU7A8Z91QunYbj3sbmb3LkNnKZHacJMiyzG/xUlznROqpxJepj13q0qmDxVaMS+HyfCNoTzzP4QzJ8THD4De/K6miwPWpTTiBOydNnpJYCWLfJpbTwMWamHFpWonfQbBl0tsDx12WTAr3EMfu5pQmqevpBLcRB0aGTKIBlHgd4RVABOLHa70b5Kjl7fLh1ZcmYBpzweZ3pNwd+PGeBElUP428iEVD2hvqL8WpF2Pz54MEco+wmNLcGr1uu5GKueaqqprdYwzWGveN+ESxW42a4R7TBpFJwYTaW6BdtnTDZdwswxynLw27BWjr8Znc9is8DUVlI8SWC2WgUr/sS4UxqjL2LIOqVRQjMKXXbZzt6MmcZmig9N2
 teaOp+66
 fAfPp/FpZo7IDD9axdBvXTHKIbIghFL542z0w3JSOScmGG3XcbflD62hfgp5UdFuMQftfcVzFgokNf6MbPhviXRqGWXaeI2buOgTnVoXb8BJFGtA7wou47OwJYBw22IXglCaETbCFNv22CYOthLQEKilWeYCft+fQ24e1S24dd44RFm68677Eqm3+egDqljVNoxca+/kQko5irmT7b8x6cEAV1VdL+XlpIdfQGaT4ME6eUes1z1xVSwYkqsp+X1cD5DnBtXTub0mUJ5QqCxyPJSt3qYxJhb2H83Bea6j+LwKIv4mp/QPRfKHb4uCn0xQAUrloHWUsazp9IfpklHDTMxSSEunuZ7WxKaMVlAQOYWtZcHCSyGgVFh5wMvXA2q1pABpXhekgqz6SDiO2HASfl0lCcjI46/ZmLOAYbNSzRKz9SJ7Ph7w+r/hbuIcYzMp/oTnoZmO/o7/d/M0I3NUP+Zyow1IELUXrEbJyVvZ9PXi4p95ptL16/10NHs2WXjZphzXyP9xzyLEzR2tl3OAcllKcZA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Wandun Chen <chenwandun@lixiang.com>

Mark non-dumpable reserved-memory regions with MEMBLOCK_NODUMP so
kdump can omit them from the vmcore.

The marking is guarded by CONFIG_CRASH_DUMP so non-kdump kernels do not
pay the cost of splitting memblock.memory entries at NODUMP boundaries.

Signed-off-by: Wandun Chen <chenwandun@lixiang.com>
Tested-by: Meijing Zhao <zhaomeijing@lixiang.com>
---
 drivers/of/of_reserved_mem.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/of/of_reserved_mem.c b/drivers/of/of_reserved_mem.c
index 7b1616b9c6c2..f38d11df6f15 100644
--- a/drivers/of/of_reserved_mem.c
+++ b/drivers/of/of_reserved_mem.c
@@ -674,6 +674,9 @@ static void __init fdt_init_reserved_mem_node(unsigned long node, const char *un
 			rmem->name ? rmem->name : "unknown");
 	}
 
+	if (IS_ENABLED(CONFIG_CRASH_DUMP) && !rmem->dumpable)
+		memblock_mark_nodump(rmem->base, rmem->size);
+
 	reserved_mem_count++;
 }
 
-- 
2.43.0


