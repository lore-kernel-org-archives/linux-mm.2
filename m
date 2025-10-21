Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10C62CCD1AA
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 21:22:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B38F8E0012; Tue, 21 Oct 2025 17:22:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 563F68E0002; Tue, 21 Oct 2025 17:22:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3DD9B8E0012; Tue, 21 Oct 2025 17:22:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 24E218E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 17:22:22 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E88E2C0692
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 21:22:21 +0000 (UTC)
X-FDA: 84023394882.09.2480778
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	by imf27.hostedemail.com (Postfix) with ESMTP id 281C54000E
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 21:22:19 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=nFVad77T;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761081740;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=hfrMnoEVujzTZlRK1XaQG1cbu1GjjkRdggNfAvmQD3o=;
	b=Mc5ChbmvwM+BtlrAl6jtNESMb7RKDdWqtBL1PXIFpabEItZWL7dU3QBGMQLY8mydL8UO2X
	WecxMvOWY8m/2j1HPnGY3rzpsAafZ7bE0KMKbyvnrBM5rZMfmgeH5If2+mwgNiA2n+9Y+E
	FhYiArvQ7MtIVDb1J5crkTq1DFAhipU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761081740; a=rsa-sha256;
	cv=none;
	b=JjeHKvewZi6ROBMuQJz7NxrfDnLnZMjohXN6gyMWPi39oglu2I00lIvIamFGu5X0t5+bVJ
	nd/CEfj06dkTWo3Yf8Nu3/QLI5acQroO3dMQwPpT2xAdqRvkLRB+f305oiJ+7pxYRJO+Xx
	LNEn1QJ6VmOVl9GvzKTRirDj/b70U7Q=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=nFVad77T;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-63c45c11be7so7294193a12.3
        for <linux-mm@kvack.org>; Tue, 21 Oct 2025 14:22:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761081738; x=1761686538; darn=kvack.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=hfrMnoEVujzTZlRK1XaQG1cbu1GjjkRdggNfAvmQD3o=;
        b=nFVad77TLPmkBjqMBgdkBBKSfiyafPpLErphcw5A8LWVfgw+Lbf7uI3Vr7icPDbqEL
         xEnP6XAc8XB9Ib4uS+eivMQrhhW4/Df7Ph80bfmep/xtSNPbFwhhxXAvoJdvx4zt+lek
         rQa71BO9Ge40+i39t0j3JkUIf9ihW1e8YQiNKbQkSxKbJvvAzdnsJE/K1lwYAMz6YPUs
         v65yWJbNGmFYOsQcruk9vhvxhBHPE8iWovcWHXXqcYFRYHc7cn0XwExUBUJFp+J7OLS5
         tSNcGs26hB39BORTPZrROzL4C64+S6mgcQdkPwFPAT6lxSJFQKRmD0rvJncMn7d1AzJF
         JIgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761081738; x=1761686538;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hfrMnoEVujzTZlRK1XaQG1cbu1GjjkRdggNfAvmQD3o=;
        b=JHMf9F5kkXENOVu+mt93rivLMB/Tz1fsSxwGM6nw/e+R5rbe32BrkoW8/E4osQNN2V
         3h6l6FpaszpfQEMstwSAHRrE86N4KMkvBIrQQzng2Pcc1OVIIjcXOb9UHZXwpqCKEwJy
         sjhTS61pAmlfYyIzI146EvrVg9tsC3D4o/lS2hkOI3bFuUdl7ijwPMof2z85oZALgioF
         eRj6XkuKwER/Y/xSdEbqu8BQLWsJibcuwUseT9C9Jr0EBwPHrhpIurOfodngIYWLu7sE
         2aQIr1HEqzL+aKuqgKjJrRI4i/YiDQKLA3XaAWCcXWKOBJ0hZcujSXOytPuJBfaPzRGt
         DhMQ==
X-Gm-Message-State: AOJu0Yx3JLLAox2bjo47gBSir4VrzDR83URWC88nT9t1kGVO6RhTBvS/
	xccK4ZHbqvIkpqtbUjYMsXp/3xt2bzw7+Z7VghTRh02cWYIpBlyDOohi
X-Gm-Gg: ASbGncvubWMWz4x06iOS+lGyiN4F6khkAnaXuUCFGwNCr45mm/b3g3fu5pXv50LOB50
	LA00/9rRVuWi4+/J3mXeadLW6qhrU8pX7Zo/mxBRk+VkRsXBk7HPAVUmEYKl3bIIjri3dcFZiYH
	Qc2YMicnCiWLrALX+rdOOIhShIETDVr6NJaTNMEnSDhFVSk5Niy+XCeMPWNgJG4Ror2jzd8b/U2
	yvV4QI5OAX1vgfu/dK6wgLmRy3WgiW6Wy4NjnxVdfyHyugpXlTdyjONIEiqLQ8WeMhBKIxl+2Oy
	jxwSv0QaCfCf100cDwQjkE2JLIsD2bIVu5C9enEe+OY9bp6zZ7LXuicWckNw3iIJJPLZpnBRzts
	upEWN1+fMSnKD+M6+2VOJXf7+NIEjeJ8pufzl7Jio7pinCKhXxh1maD9sXym1pUcQANYxw6HHiq
	M=
X-Google-Smtp-Source: AGHT+IFfkFl4hZbgWt3DIbanRuG2flmJK066maeNqqKJksyQrtlGspvOh2+TBVgGBn9R4SSsliVv8A==
X-Received: by 2002:a05:6402:2801:b0:634:ab36:3c74 with SMTP id 4fb4d7f45d1cf-63c1f6674abmr18733099a12.9.1761081738516;
        Tue, 21 Oct 2025 14:22:18 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-63e1c732ea9sm259836a12.25.2025.10.21.14.22.16
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 21 Oct 2025 14:22:17 -0700 (PDT)
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
	Wei Yang <richard.weiyang@gmail.com>,
	Liam Howlett <liam.howlett@oracle.com>
Subject: [Patch v3 1/4] mm/huge_memory: avoid reinvoking folio_test_anon()
Date: Tue, 21 Oct 2025 21:21:39 +0000
Message-Id: <20251021212142.25766-2-richard.weiyang@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20251021212142.25766-1-richard.weiyang@gmail.com>
References: <20251021212142.25766-1-richard.weiyang@gmail.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 281C54000E
X-Rspamd-Server: rspam02
X-Stat-Signature: iifhqxb8upb7burucfuk69sm11whysi6
X-HE-Tag: 1761081739-583109
X-HE-Meta: U2FsdGVkX19i//KDbEHhOnwJc4QZ8hdoaeGYVSY/U5Z9cQ9lXt3cSIILvwQeWL9dCp8k/ATHcvYmCozjJsnfqbeR0sMMrsnK+REALrfDlUNhUUVy68elBp8oQ2HzLGgUGA3l45yiPNTKCSCCC+v/npAbRbzhMmvh3j7raCVNK2eBzSu+u/0dvO+Yh76ntqPufkEiZklt8ZWp5SGAO5Q0sN9huksSQAgmuPyUltilKkfKAPDn6dezFB71DSvE6IxV/cWAA3Gs/uldHHsFdt3P2SZDfFsevyLD6nKWO3uVXwhT//1KmALlCzmSUqtfDkvPdCqJ+45QPcHhCOFYx2VoWjVV0ZLOe3nR7y2G/F7E/KpvzvVvDfP5+Fszfu+oWJX4fl/IYbOfVs/poGFpe73JYUgKFXsKvcYwYe+FBr8qjmC4Y6ly/TIKCaoIwMXBRO7aCNiDgh9kS+C4N7Oxkuh9guKKRgb2ONarJAZvefL3BUhDzKGhpnrv0wsAaM7yw8VqgRtQl+Yeswq3ST8hJuB0sxAv4fY/G98Z9YvXUA3tJcw4wr7claNqRjyJDasJMWOaLBtKVbmWLYIPTqeH+pt8ZISQC0sxA5Pb7gpDC5fu3yPoSPRUiTgNLVDl/6kXlZAjgD5lsLLgyZSTWfrc+rsLOYeU6yYUf9OqyI9+1bjNSL8CSlG1l5sHAkZmULKXLrlBQ9TSDcj+NcUhm82bpTGvWM2PJQIb7VWNKBGTY7ryjO3qxmIyE/LZqC4U/fgXFLuT2ZG7kl6Gty8GE+EIXTKhZtPbsHPXH3afi0XjIsGAdgUhUn0OzbLyMB70DRpej0qwfBTEPCAnO0zKumvGRmlg1UbjpOl38XrH5or5iuNjIzQD9ezK+Y00nkMCubFyBN+GIc/xVMx1TsBqTAWdPxkZj8yIq3PzgoRbhMWvQPYMBkp1+hptrlAY1ZA1mz0j4ae0/OvMuK4ggmWOwH8eKmU
 8BpGDLoN
 l+ncbdk43f8TNLAP1db+PteeVtiGvw8sgksI9P+pOO+rpqjMcKEkCArVn9KDx8Ql9wLyCkenU4XcPfFwSqnzZgZP4ZGPj00P4gaK/YKyc/EIxp09XgT/mbDDZDt8CAA9qaVex0hVOzy4nT+INOwRgsn+ht4EnJERMYhzOrt4Iw9Yd1ykKt5HHIhvLWZ9xsxce4nrL1us1q+uuMbg1eUrQxCEjYOuXrKGdlqHViRW0Xy5LoYB+3VcruORIIE+1olCfC98zolzt94XSdMGWYrrKTnRrWt6Uo8MkJeF11fqd1evicv0AbRS0cOempaCQv9GPF1wexQZSt3tZntjp1J8VrDGG/q3OrSAElS72ZKRVSkj3wiUKWP/bZ8FX5EYR6it4j/lxC45OYun7wnCvGkcb0idBC6PspQ3kyFUNQSjEnfACCwNsqiB/5+DiMOiUhxBLoIRtCky4fI8l6nUdiKyVJDiVoQGWrLX39jhsYtPwgTtBWw5iDF2HvaimkH9nc0nvIJ2CHynX/LjC7ovik5VZ7SwQc7H6IZBFfBqWE2kG3vnSNt6cwHNToYJzGbuXdKxpDJbOXr55lMLvcN+vKtIeAlqN6JbnrCu/Ddt12cqK2RyPHQQl4pUekRIvYl1ZHFLqR3D55cUE0D0DOAIURwzb2fLbIJITb7TBM7f3MSNkKDsUgXqQkiXPtg04hM4ewIo60Z2YGME2xoPm2vmAweIjB94DlAXTEVLPtiP0NLgk+9DpZI8BANznt0dU4g==
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

Link: https://lkml.kernel.org/r/20251016004613.514-1-richard.weiyang@gmail.com
Link: https://lkml.kernel.org/r/20251016004613.514-2-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: wang lian <lianux.mm@gmail.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>

---
v3:
  * adjust subject
  * add const to variable is_anon
---
 mm/huge_memory.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 370ecfd6a182..6d82df4a88dc 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3595,6 +3595,7 @@ static int __split_unmapped_folio(struct folio *folio, int new_order,
 		struct page *split_at, struct xa_state *xas,
 		struct address_space *mapping, bool uniform_split)
 {
+	const bool is_anon = folio_test_anon(folio);
 	int order = folio_order(folio);
 	int start_order = uniform_split ? new_order : order - 1;
 	bool stop_split = false;
@@ -3602,7 +3603,7 @@ static int __split_unmapped_folio(struct folio *folio, int new_order,
 	int split_order;
 	int ret = 0;
 
-	if (folio_test_anon(folio))
+	if (is_anon)
 		mod_mthp_stat(order, MTHP_STAT_NR_ANON, -1);
 
 	folio_clear_has_hwpoisoned(folio);
@@ -3619,7 +3620,7 @@ static int __split_unmapped_folio(struct folio *folio, int new_order,
 		struct folio *new_folio;
 
 		/* order-1 anonymous folio is not supported */
-		if (folio_test_anon(folio) && split_order == 1)
+		if (is_anon && split_order == 1)
 			continue;
 		if (uniform_split && split_order != new_order)
 			continue;
@@ -3671,7 +3672,7 @@ static int __split_unmapped_folio(struct folio *folio, int new_order,
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


