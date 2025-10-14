Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A20B9CCD192
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 13:49:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9DF638E0124; Tue, 14 Oct 2025 09:49:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CB458E00A7; Tue, 14 Oct 2025 09:49:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 792558E0123; Tue, 14 Oct 2025 09:49:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 62E958E00A7
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 09:49:28 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2DD8447321
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 13:49:28 +0000 (UTC)
X-FDA: 83996852016.10.7DD13A5
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	by imf02.hostedemail.com (Postfix) with ESMTP id 501CD80005
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 13:49:26 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=V7gQLwAo;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760449766;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=8HmZa/kTma4p/fj93mpDob/WGaeYB2g85V/Wy4K7fv8=;
	b=FxXPDU2KFraU6KHMSJ6JWDJDHaIObokEKmMA0IeNnNosxYY9HqBC4t8QAk0qmJfM54JCBS
	WcZdJxP6DbLWnOUyMDaTR5HG68AsuFS/dx+9K64DRTzBAejvq4qgt7ELXElznjwJpgmu+p
	m6auWTQapvcXkEoGBgValcQmtflHbvU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760449766; a=rsa-sha256;
	cv=none;
	b=Te+7J2/VDUhlivtPypyGjLmOO/2AAqZyo/x0kcDPhVn0Se3eTWEQy/qe94GItDA0BlW+Tf
	HmZkkueeH4tAEAKdEUg0g1Or4DiOP8s9X2+AaYTH0an0XwP1UaNkJy31U01nQSc7g6dEqs
	CsT27NrUP7mAUb+keESEGKEwdXhA/og=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=V7gQLwAo;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-46e61ebddd6so57949475e9.0
        for <linux-mm@kvack.org>; Tue, 14 Oct 2025 06:49:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760449765; x=1761054565; darn=kvack.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=8HmZa/kTma4p/fj93mpDob/WGaeYB2g85V/Wy4K7fv8=;
        b=V7gQLwAoPqXBnfp+bBueSWEDbsHh6eAhDT90Sxc2JisbQhY1Hyo61ju1VLjrk8o5Ae
         rK89HsXGbJeSc3GXM98KDHgJCfZIHFx9wgA85ZeyjGP4Bel5ZjlHq/azJCnH2YH052rW
         oIu03+00YNyI9vo2w2I5BfC9FkU4qqyJuJhAYU6918A8BD8xPG120+ennUF24Qy68RsW
         1sCjAV425MWW6uVln9KorrY5fdSKgdMMNMRUkFuBysDbRi4WazgW7W17/UzNOn8DtNpW
         NrenTCdU2tLI5VSgQaTvh1qR51Xk3pGA4lgGbvKuFvLTE0Ygpx37lv1iuYyLAs/Wzs0i
         ZDEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760449765; x=1761054565;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8HmZa/kTma4p/fj93mpDob/WGaeYB2g85V/Wy4K7fv8=;
        b=mu/o9H0j3HphjkeCnRn0rLAsZlVJVVQ2OkTa2Vb9c4ZXH1e0geQhEqWbEdKojS6+D3
         W36VtIdq+NMV6upzPT2RgsLXp+jBG3W6efJG8sZehEGlocKnrhOq4Y2aS57Qt0dKEfUs
         Ixl/AEeVDp6BXYLopW9l2Mr5TxPACjH4E8DdxJqplbV9ZDcFQBiWpAb+PPlLDZKd2U4W
         G0w3Fkxt4QEGWFF+xGY0lM9mFY55p4dxVN8U05OnV8U7c0YUYTnJlm3mL+VBdwQVNmGl
         0YMvhasG571v0aYXo0LgjcYecFuZX9CJW4DxQWuroG+pSTaWgv2JAVLmm9vE59avwEM/
         Zk5g==
X-Gm-Message-State: AOJu0Yzo7eLwx1tLv74FO+OraFpTxF0AppWlpL6RtgErpphaVnN0Ehy2
	k8nZAs4DCdM9z4rXbIT5uM7o76wFx+prpLIbZnOu1nT84Dbi/rD2i9N3
X-Gm-Gg: ASbGncvXc84fiQlj639bH4rm9/1wupXgHV/pIbqYFJ6+mEhE3azJdD0a7/G2sj/+kJC
	VjbeLtJPImBewlX09XKtVqq5DF4CfdSFucXUOf/dbwSM0X3d+//zMnBba+cx9HhlYQ/DSTGbIYX
	ivGjnS4s3XxfFv6ug15g47/HnjRkH6K4tH4SCfWLzx2fDtmur3v7jWblS4VhbP6txaxcMK98Gq+
	CpLNygXPvZwwVXQpPn3p2H0897RIIDy2UVicmekO3oo/RIMMgiH9Y1LGplzfjBgd4MkXXj+3vYm
	RvBKFDfuxG8PodproBUoE3ZNxV0u3LslL3oy/urKQTWqRw8SNufa5R3TsyDDpZzfGntYqtrNHmC
	fjM1SxqgvBmSsGheo1OEaUosSQPpaQ0rGATATXFCE
X-Google-Smtp-Source: AGHT+IE13jk8VZvbgooox5rj9hrqszKDT4J0I7UnocbKVOw1Qb1W2nbDpCMjBcbmjBAtHQbJUO6ZGA==
X-Received: by 2002:a05:600c:1394:b0:45b:7a93:f108 with SMTP id 5b1f17b1804b1-46fa9a8f090mr175695635e9.3.1760449763269;
        Tue, 14 Oct 2025 06:49:23 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-426ce5cf6b4sm23887880f8f.25.2025.10.14.06.49.22
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 14 Oct 2025 06:49:22 -0700 (PDT)
From: Wei Yang <richard.weiyang@gmail.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev
Cc: linux-mm@kvack.org,
	Wei Yang <richard.weiyang@gmail.com>
Subject: [PATCH 1/5] mm/huge_memory: cache folio attribute in __split_unmapped_folio()
Date: Tue, 14 Oct 2025 13:46:02 +0000
Message-Id: <20251014134606.22543-2-richard.weiyang@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20251014134606.22543-1-richard.weiyang@gmail.com>
References: <20251014134606.22543-1-richard.weiyang@gmail.com>
X-Rspamd-Server: rspam01
X-Stat-Signature: iihhscnc7956737tbq8wtqjf4qi13j8x
X-Rspam-User: 
X-Rspamd-Queue-Id: 501CD80005
X-HE-Tag: 1760449766-788767
X-HE-Meta: U2FsdGVkX1+8Ol/Z5LyZOOeuclCHHM74i/8Eicu/HwMRBwXf4HFiMlZqsoL8CcG3FFIB/SL2HCSxcj+yd/ZlJcKdSoR5w05+tIyBvEgShyOAuBC0T/gyUCEl8N+A3E44zFPmn3UZBXCuAED/vXiZXYkWnJQFZX8L5fiL/RvW00i/Mzmfaccj4xIE+Bs/4O+iKFWdZulxE56rErR6ghzCXsUStvcdU/3r8lqUM2rgL6YbNQh/9RxxQ6Ypw80wn+wTf74FrBMonvK9ic3kXsj34gx1zg8aD/GNbmoTjPrLEpRT1leVDj4nfgnT5vHS6oNmYcpGDG623OzgG/hMsK9FXheGGyo3cJXtpqpdPLo5LAVjjtxhNFpZIfXOBN0FN2K95B6ippTDnz+Ft+g3VYwlu4VWjqZX1OU4MllU2WpepNlHKg2PZ+w7lsnkIOpWBKvOe2HuA3CKo5tX3Ol8ZPQKhGNxy4lt4+cCu9oVIRzQNebj//zoqtzQDiOzM/o8Ca9HjXaJniyVgUe19nRfporgDIpxgGpbBbC8tmJivLCfNB/nKZYoSzBW1Cd+zjIvFcdbwAK0IxDVNwlJVDTJOOVA/xTBd7CacIb6wdlqlcO1u8U15iHzMy9JoBH4IDBlJUZlXCXKIOm0bLibKiAftlNVk3Q2JaAVVMiBzYwfTaMSSomo0d6Dn+/iN7C7/27UKVBHssgRiu2MmO/U5FVYoTD8jnU3LdCI0xO0tcfFvrpt5L8NVmvTDLQ2T27CpXiZLE41qJoUUaROf/HFwiXZbj/qkF0QWA/VkO1VKvRUIj4Yea3Z+LolfEFa4BmyBnlQCxDDfTv6IAXxzV9/8eI6XkHj53ukaKVcwJ+qwebZDoecUfe1ItZeNp4q2IpgqKRaGXwGGj29HMn+SpZLn8CuGcvH2UWt9PA2WuNy6BXFjqqhprYY4qeQk+C8s8IhC4yDv8mNtet/fUMkKSoqtoInpbR
 UhaT8SeW
 grMNRuB80m5fv5CUiac5fKG26EQ4rY911e8HhpNrWf4zPrmbOG2/M9pOyVcQRiBSPz4LxSsBcn86tsY2F73rskn5o586aIhZvp13DLiQ/K+jk9b2PjVmpZTNDlW8mRLBGDFmc/l72ED7wKkVGm/YKrtF/grLOuacnq1IuPx83cfrFmYuU6uKxZ3/oFUGKat6Dh8W3ARmOWYqoKScwX5GQHr29aIbHyKg18NBpwKA5w23FHCzvdgt2K1bprArbjHwwtoyv0KoCOf29pqZCniI+lfbOm94CsKjH8JRB1sa1ifB0ZYfUQv+MoBEWjPbCX/fzLss/FfsmxNrO0VutXfqAze4W1sh7UU0/6zi4rGDBYsWlYOFp9TNnWnzzC/1bXtSn3/ekOOfgsh3Hf3kFx5Pgbp+WujZA0IrJjWGSa0gNJ/7iH5LGUTjIXXPVdwnQ4KFEQ4vo2biAfve5xcUDAnm8Rd0N8+gdx2MZW13rmHyZS9q9C6+LfRHx4A+Yz/JjXAlH579sHtyOt1EJPtJGQy01hk4tFhz37w5S08X8KrBjFUbkv0eXO6ziF/ePJEkEV9jm1oXggBKdOPrq1P6djS993O5TYQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

During the execution of __split_unmapped_folio(), the folio's anon/!anon
attribute is invariant (not expected to change).

Therefore, it is safe and more efficient to retrieve this attribute once
at the start and reuse it throughout the function.

Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
---
 mm/huge_memory.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 3c74227cc847..4b2d5a7e5c8e 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3527,6 +3527,7 @@ static int __split_unmapped_folio(struct folio *folio, int new_order,
 		struct page *split_at, struct xa_state *xas,
 		struct address_space *mapping, bool uniform_split)
 {
+	bool is_anon = folio_test_anon(folio);
 	int order = folio_order(folio);
 	int start_order = uniform_split ? new_order : order - 1;
 	bool stop_split = false;
@@ -3534,7 +3535,7 @@ static int __split_unmapped_folio(struct folio *folio, int new_order,
 	int split_order;
 	int ret = 0;
 
-	if (folio_test_anon(folio))
+	if (is_anon)
 		mod_mthp_stat(order, MTHP_STAT_NR_ANON, -1);
 
 	folio_clear_has_hwpoisoned(folio);
@@ -3551,7 +3552,7 @@ static int __split_unmapped_folio(struct folio *folio, int new_order,
 		struct folio *new_folio;
 
 		/* order-1 anonymous folio is not supported */
-		if (folio_test_anon(folio) && split_order == 1)
+		if (is_anon && split_order == 1)
 			continue;
 		if (uniform_split && split_order != new_order)
 			continue;
@@ -3603,7 +3604,7 @@ static int __split_unmapped_folio(struct folio *folio, int new_order,
 				if (split_order != new_order && !stop_split)
 					continue;
 			}
-			if (folio_test_anon(new_folio))
+			if (is_anon)
 				mod_mthp_stat(folio_order(new_folio),
 					      MTHP_STAT_NR_ANON, 1);
 		}
-- 
2.34.1


