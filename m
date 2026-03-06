Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD8BDFCC062
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 20:30:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 373AF6B0005; Fri,  6 Mar 2026 15:30:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 335456B008C; Fri,  6 Mar 2026 15:30:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 234FE6B0092; Fri,  6 Mar 2026 15:30:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 08E636B0005
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 15:30:52 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CB74D1C665
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 20:30:51 +0000 (UTC)
X-FDA: 84516781902.14.F330D34
Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	by imf16.hostedemail.com (Postfix) with ESMTP id E919318000D
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 20:30:49 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WRhSE2W5;
	spf=pass (imf16.hostedemail.com: domain of hlcj1234567@gmail.com designates 209.85.222.179 as permitted sender) smtp.mailfrom=hlcj1234567@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772829049;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=NAflFpld1ziWQP59fOhP77lxkMaSDWfKofqGmD46Gx4=;
	b=kWxAuCO+PGXYnt0i8rfFBrJzeZ2kkeK2h5kgFzMgycNxOJyP5/WQjVtT/zLpc9umZCbS9U
	ja6Jk7P3xwor6RtgPzFH9KEnKQV3MkRvZUh+rC+KeYOJv0tr4CLycDESHwO3dlBUslcSrt
	PI3J8dh7VUFM0ClusNGXVMcv03DBxio=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772829049; a=rsa-sha256;
	cv=none;
	b=7C426JDUzFuTHrq7ska9sdl0lWXnZrRwulAbQnzapAYseTp6fFqgYkmZFikG5OkMxq/m1+
	JO7wUC89kdCodBe9I4wsg7IsBZ5jfc8FZpC1KjuDUul5vNgsGT6De02EJvsQ7xkFTvtHZ5
	lxfdDybbeKPXT65zXAtrEP2hijySuKI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WRhSE2W5;
	spf=pass (imf16.hostedemail.com: domain of hlcj1234567@gmail.com designates 209.85.222.179 as permitted sender) smtp.mailfrom=hlcj1234567@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-8cb39f64348so954398985a.0
        for <linux-mm@kvack.org>; Fri, 06 Mar 2026 12:30:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772829049; x=1773433849; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=NAflFpld1ziWQP59fOhP77lxkMaSDWfKofqGmD46Gx4=;
        b=WRhSE2W5CfMRk9wxzuvQ12X/NbMVIO22SfAUKAbdjOGtVO/T0VAN4ysx4zN/r5S+x/
         oVzhNZzKRP3L5nAF7MjXmuBQTS3ERn+TxgeluG0tfdgK8IkaRZm7MFC66YOoc47HOoee
         LbqQCsdmVF1CY/HZOz8Ajh9mVyS84gq6gtYurU1VnDTkrUl2td+8ZyoF/0L/hxsdocC3
         hFTFyFcHeLGGSOPUaMQP0hGoKoeLBBGMqcjXPUWct+N85Yu3HbremA3k19d5cLqQEPkm
         cLHtT2AFroXXjrF1/Wd4CKfaOM+Oh2S1jhn5iWuRBhiwbkbXZ/S5py4OjYIKAFCgt5vc
         pRTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772829049; x=1773433849;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NAflFpld1ziWQP59fOhP77lxkMaSDWfKofqGmD46Gx4=;
        b=NopG28JZy5tbQTYDuWX4Ki63um8haEkaNJ0efUhtcHX2Q8za7T27m8340QN9piqHRS
         2nm2zennNc6JylQockCmJfyWRECMR1ZBAb0ToSshGVFMAZW/4c37NRENGv5DWcwBTN/o
         CQni0i51GBaXqVs9ia5kOr/C+JGdphK/ucYmmqYayMmKXwVUFCis9AqZBg2GC0g5213y
         mZYKzTY2PJCtVkIlamKvs/b/kXkjp9q9B7WW/RhvYMdCuyAOaIej6M+gfcQwvK5JaGQy
         K38W4Xy1KW32/Dht14xkLnZaOBs/pcSa++pLhNgehJxgFhv+qge4dNY4Tw8HdIJ/RQEa
         oZLg==
X-Forwarded-Encrypted: i=1; AJvYcCXnTBUvh/+qsQwKiqTE7ULJRUzHnR2KoFH4rGrhGcBvPxeCbI2QQUtIgHmKRz3sO5vgFcx4TWh+Xg==@kvack.org
X-Gm-Message-State: AOJu0YyazmsVfTSYbbl2RuOofIXYAWk9YdNLgAiQhzBBKPN6GPlOF8Uh
	eWhgAU4/nP0ZIzlmf+Dc7TWDn3v6OY2gpWbES9d5edsVYuFfn8s52tmy/UoCyce7
X-Gm-Gg: ATEYQzzRLVhpx6j49Zj0KXNuJN2orkYwg3VLE6gLwhm8ybeSE4j+IZ7Xz/Ci5oW3v1F
	D6APotnFy7faR6zunba2ZCidTZzk6NmOlC7pbTTKP/IXbBcwqBrtxHW6+3PAlbU7WVe8ucAfpdg
	6vmhJV57D1/+me6aY9YAZMIM0W8dflOJWROnuXWBLdi82QGwwI4b8BW+6Qb2vkpPxhvbpoga6Ex
	1CL41gVLBsowkIJGijB1bBZFXxAEv+w77U+WPCxJSGKfDW1SF02F4nDQn5olaklYemlSfNRzZ+4
	bNUf67Wa2Ibttbwr2VM4EL2NldaOv6B5178BpWi3oyDXI0VdJEg7KwJcsxH6ZqGWxkG4kDKYwoC
	7NgMhdsATIeV+NGtPVU/2RWxs6Llq9VrYj7KVXOsPfwAjmf9GUPnPd9j8C6TPjnvpNrPsZM9d0f
	h8BCAH0QyvNHz+z389xoFSfZRQJbJ1yWeKXSVvEJXrV85Fzig4Ge+9zTJzAH8IadphX2b4YGACy
	HSb
X-Received: by 2002:a05:620a:468a:b0:8ca:2baa:76e with SMTP id af79cd13be357-8cd6d35b59amr471988985a.19.1772829048832;
        Fri, 06 Mar 2026 12:30:48 -0800 (PST)
Received: from instance-20260207-1316.vcn12250046.oraclevcn.com ([150.136.248.187])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cd6f53b83esm183253785a.29.2026.03.06.12.30.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Mar 2026 12:30:48 -0800 (PST)
From: Josh Law <hlcj1234567@gmail.com>
X-Google-Original-From: Josh Law <objecting@objecting.org>
To: Matthew Wilcox <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>,
	Kevin Tian <kevin.tian@intel.com>,
	Yi Liu <yi.l.liu@intel.com>,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Josh Law <objecting@objecting.org>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH v2] lib/idr: fix ida_find_first_range() missing IDs across chunk boundaries
Date: Fri,  6 Mar 2026 20:30:47 +0000
Message-ID: <20260306203047.2821852-1-objecting@objecting.org>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E919318000D
X-Stat-Signature: sh8zsk3mrcthhrguh333dwnt8kxbj1po
X-Rspam-User: 
X-HE-Tag: 1772829049-866495
X-HE-Meta: U2FsdGVkX1/PQfeSIlqcU3F6VMU4PRb6vFEDU1yglaYzkZ943oZI3f/TMYCOgHu+eyjRx0FJ7INxiSahUwdBUrH9KM8Dcv+YC8Qego8ED2NWkExEME6BzvBGU9eWCEdIdfdqBdM5mZ7hrTaRb3utpsh2nw55nLrEbKkRLMi6tftOlOOL2fS5MjVogmWCB9TCbiflOjk5l7Y0hrYj82aQQ5ldZxfZl0w7DzCwzx6mO+J49oWaB+cWqU9xXKpw31kNMksSNCB3sBbFMCEHVUMxEewd+5sk/Q1R7cmRWf+ZRoNrEUHQx92PwIOOdBUVig2M/Q1WXqjT3CGvjVJD5wWSllWoL2qyhOlZmai1CFGKNLnB5QvYN/0lb5lHOlay5VTiwgCsz0VQdbNjBTJt1QFwL2hmnEiOWn3TVY0fbaiZdMAfiX+7KCK5M7klZifZmXpR+kPEmPjWnEEAesUX9zls7VqllWrFxkcnLAZrSXwCghuxCBjiZG5rlPLkRspRpDiM6GYbwhKhIMluUoeBCkrpxcUVBqoHGIaAyWhRxGI6Zrd9os3u3Ix2eWuh8AGW+knSWF+cr+ndnCe3uoVxYwDw2YdJQbaaqQ92sULXLj9NxNWt5Bgw8ghUDfaP6OkcgeQbuiXec4PDVC2smgdz6CG8Wxm2RMbe7zK2V8vABfSaEwRSRO8oj3WY9znr28MjmKd//mXNab+K4iDBsLKN8EN0dfVUSp4h7HpnA7cOYHMmGEESQNujjlDoKymdKrkFGc4dVfhw4w1hmZysctSfP2zyohKLBlWIGLrcY1DI4ed91BLGBrjM0QyYsGgT57JML4K2ulMHRvaAaVjGRx2a1vHJggfDiX+xZR7UJev1y9d4/jZZKQ9ayyKcZlttrj6qYseodDNLz2uuaufDA5xtMAm4bpt3DvLm1zOPiVPf19B02kQzfwa5mC4bGWDHbuhH+kSX8EaIr6T6TH0sYhS3gMe
 e6PesIv9
 blyHxrpe3Thyg8dPep8XOYR5SHRVuNNm8XzugHnbxN+JNHJn78JsJ1zxw/QuDcj0o13iE1cRGX7xhBs9L3xotD+v6H4PSXxKrc6yWFitDL5IlRzWf8qEnACjK7fxe4KwTmRj+fQrUjmjjeJteeGvbOUQfe/OU7c81lByiPpN+a1tOrHkoI/eUG8ARs/KbVkSdFrp/j9eCktY2J+d55q1iT9P+zl5ZdKxY0Vc/zwMLOumncJdEr7+PYXO1bSsGKgn4U745eVd/Xn+BAUpUpIbymoCfjFLVv0e7D3Vo/gYnBLGbrmpZJNQr/2gKzqSY7fpxe8/LGSTD52IG3V6vdyx0xxuNXyyeKCVebeULj8Q3j3csDwGTvYHbdk1KZHBKZ6goB2w2J0PJCVDArLAZI2dvL3mX3d9oXKQnNkZDS64ie2K3WIl9e7t9Ecgfhec7a54wUepGNQiR1v+eLueuSQyNFEDie/Swo349XEht5WOVu8/BGUFFPt4HXvVrQ7KhknGQRN+SaxxN7cjSul+WHvfyAisCI234ut0wiKNAj0XIYrbp1C2gPprqL41gDw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Josh Law <objecting@objecting.org>

ida_find_first_range() only examines the first XArray entry returned by
xa_find(). If that entry does not contain a set bit at or above the
requested offset, the function returns -ENOENT without searching
subsequent entries, even though later chunks may contain allocated IDs
within the requested range.

For example, a DRM driver using IDA to manage connector IDs may allocate
IDs across multiple 1024-bit IDA chunks. If early IDs are freed and the
driver calls ida_find_first_range() with a min that falls into a
sparsely populated first chunk, valid IDs in higher chunks are silently
missed. This can cause the driver to incorrectly conclude no connectors
exist in the queried range, leading to stale connector state or failed
hotplug detection.

Fix this by looping over xa_find()/xa_find_after() to continue searching
subsequent entries when the current one has no matching bit.

Fixes: 7fe6b987166b ("ida: Add ida_find_first_range()")
Cc: Yi Liu <yi.l.liu@intel.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Josh Law <objecting@objecting.org>
---
 lib/idr.c      | 55 ++++++++++++++++++++++----------------------------
 lib/test_ida.c | 14 +++++++++++++
 2 files changed, 38 insertions(+), 31 deletions(-)

diff --git a/lib/idr.c b/lib/idr.c
index 69bee5369670..1649f41016e7 100644
--- a/lib/idr.c
+++ b/lib/idr.c
@@ -495,10 +495,9 @@ int ida_find_first_range(struct ida *ida, unsigned int min, unsigned int max)
 	unsigned long index = min / IDA_BITMAP_BITS;
 	unsigned int offset = min % IDA_BITMAP_BITS;
 	unsigned long *addr, size, bit;
-	unsigned long tmp = 0;
+	unsigned long tmp;
 	unsigned long flags;
 	void *entry;
-	int ret;
 
 	if ((int)min < 0)
 		return -EINVAL;
@@ -508,40 +507,34 @@ int ida_find_first_range(struct ida *ida, unsigned int min, unsigned int max)
 	xa_lock_irqsave(&ida->xa, flags);
 
 	entry = xa_find(&ida->xa, &index, max / IDA_BITMAP_BITS, XA_PRESENT);
-	if (!entry) {
-		ret = -ENOENT;
-		goto err_unlock;
-	}
-
-	if (index > min / IDA_BITMAP_BITS)
-		offset = 0;
-	if (index * IDA_BITMAP_BITS + offset > max) {
-		ret = -ENOENT;
-		goto err_unlock;
-	}
-
-	if (xa_is_value(entry)) {
-		tmp = xa_to_value(entry);
-		addr = &tmp;
-		size = BITS_PER_XA_VALUE;
-	} else {
-		addr = ((struct ida_bitmap *)entry)->bitmap;
-		size = IDA_BITMAP_BITS;
-	}
-
-	bit = find_next_bit(addr, size, offset);
+	while (entry) {
+		if (index > min / IDA_BITMAP_BITS)
+			offset = 0;
+		if (index * IDA_BITMAP_BITS + offset > max)
+			break;
 
-	xa_unlock_irqrestore(&ida->xa, flags);
+		if (xa_is_value(entry)) {
+			tmp = xa_to_value(entry);
+			addr = &tmp;
+			size = BITS_PER_XA_VALUE;
+		} else {
+			addr = ((struct ida_bitmap *)entry)->bitmap;
+			size = IDA_BITMAP_BITS;
+		}
 
-	if (bit == size ||
-	    index * IDA_BITMAP_BITS + bit > max)
-		return -ENOENT;
+		bit = find_next_bit(addr, size, offset);
+		if (bit < size &&
+		    index * IDA_BITMAP_BITS + bit <= max) {
+			xa_unlock_irqrestore(&ida->xa, flags);
+			return index * IDA_BITMAP_BITS + bit;
+		}
 
-	return index * IDA_BITMAP_BITS + bit;
+		entry = xa_find_after(&ida->xa, &index,
+				      max / IDA_BITMAP_BITS, XA_PRESENT);
+	}
 
-err_unlock:
 	xa_unlock_irqrestore(&ida->xa, flags);
-	return ret;
+	return -ENOENT;
 }
 EXPORT_SYMBOL(ida_find_first_range);
 
diff --git a/lib/test_ida.c b/lib/test_ida.c
index 63078f8dc13f..d242549e16b6 100644
--- a/lib/test_ida.c
+++ b/lib/test_ida.c
@@ -256,6 +256,20 @@ static void ida_check_find_first(struct ida *ida)
 	ida_free(ida, (1 << 20) - 1);
 
 	IDA_BUG_ON(ida, !ida_is_empty(ida));
+
+	/* 
+	 * Test cross-chunk search.
+	 * Allocate ID in chunk 0 and ID in chunk 1.
+	 * Search for ID >= 1. min=1 maps to chunk 0. Chunk 0 has no IDs >= 1.
+	 * It should continue to chunk 1 and return 1024.
+	 */
+	IDA_BUG_ON(ida, ida_alloc_min(ida, 0, GFP_KERNEL) != 0);
+	IDA_BUG_ON(ida, ida_alloc_min(ida, 1024, GFP_KERNEL) != 1024);
+	IDA_BUG_ON(ida, ida_find_first_range(ida, 1, INT_MAX) != 1024);
+	ida_free(ida, 0);
+	ida_free(ida, 1024);
+
+	IDA_BUG_ON(ida, !ida_is_empty(ida));
 }
 
 static DEFINE_IDA(ida);
-- 
2.43.0


