Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84E4CC43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 18:01:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C2206B0093; Wed,  8 Jul 2026 14:01:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6721C6B0095; Wed,  8 Jul 2026 14:01:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53AD76B0096; Wed,  8 Jul 2026 14:01:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 166C86B0093
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 14:01:37 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 660B1C179E
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 18:01:36 +0000 (UTC)
X-FDA: 84966376992.28.9C524E1
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	by imf20.hostedemail.com (Postfix) with ESMTP id AAFEA1C000F
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 18:01:34 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=tawCDpmQ;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf20.hostedemail.com: domain of 3fZBOag0KCDIOPVWgVSYPOdOhUccUZS.QcaZWbil-aaYjOQY.cfU@flex--abhishekbapat.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3fZBOag0KCDIOPVWgVSYPOdOhUccUZS.QcaZWbil-aaYjOQY.cfU@flex--abhishekbapat.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783533694;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NLJpSpD1IM/2/PSTnk3FZM0FGzokCq3B5xO8uzDBMuw=;
	b=k7fGg0E/9+gVZPWTa3c9WSPuCV0ntuUgCXPI6tiLxQxWV5jqlGKaRyWD5pfA3qUXbIdXzP
	4tZidMTT78aO+Gl/pipw6zf/fkrDbM+Z7vFBW/BhKotSynS9CxKv/SNVtDCRMfeLoI+2Ow
	HAoe41Wq3xNAf92xeqGqyt0TAuofhCo=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=tawCDpmQ;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf20.hostedemail.com: domain of 3fZBOag0KCDIOPVWgVSYPOdOhUccUZS.QcaZWbil-aaYjOQY.cfU@flex--abhishekbapat.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3fZBOag0KCDIOPVWgVSYPOdOhUccUZS.QcaZWbil-aaYjOQY.cfU@flex--abhishekbapat.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783533694;
	b=O+FjOpgZHVkhU58KQdbAvAcasDowCRhv4vR1WRisRUE2/BuitdCFqxqMOczm9fo+DabmIr
	NFeiU5PnJ/tKO5rHe1lx56vSDwVhUmUgVSdV8Q3JVGUhZroCU+EIeGJQB+CE9My1r2oWGa
	G0wIH5aGVnTPUlyf7KYtb2BSd4jqoxI=
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-38827cee19eso126039a91.3
        for <linux-mm@kvack.org>; Wed, 08 Jul 2026 11:01:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783533694; x=1784138494; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NLJpSpD1IM/2/PSTnk3FZM0FGzokCq3B5xO8uzDBMuw=;
        b=tawCDpmQzIMJTzzfQAhkUFhdF43u6sOAn3cYlnCcQVppYjcy3oBRz3OiRl+7MUwx1+
         CLxpqdLViJr2Vi6s/CYbKi6ZNLA2XiyF55/UGnyBcfQcy9H5lYcpPKrLv2jJXFiX9oeq
         1xsn28qHDOc8yaV9OH7fA06KI0EhbUA3frVx/EcctaBPI3d8HOlR/5uz+kAgmwJOauNO
         dqhbvSbbIvaesT5WObccnwOL1HqDeRp/3vfVaWgj7I96knmHgTr8XPlo5KFqDGo2d4wK
         Egb91DVI+ydwcELskZ9q7hIneNIIxTiGlurVIaMmIgr9xxzM0QXHsAZoKmxGcnGPvdIO
         ry0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783533694; x=1784138494;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NLJpSpD1IM/2/PSTnk3FZM0FGzokCq3B5xO8uzDBMuw=;
        b=fTtIUL0wh/WjMMtH4rcwe/sv0FbHIpERu1j7DrfUa35XnkV0gTxHv3Lcjaqec9ulMf
         l4yRqvpg1ZZxGpQwaU2h+G+74yhIG/4nQtTFfbc0etnpX1gJj1+M+kG7rVccaMQEh1Hq
         xgcGNaRoppT38IloQ8sbbAhwoDBKqQ4Zc7Un0xY6awQtGhlN5GmsZ8l0r/P2iQGdFz3J
         mFmbNXM+MMwLajMLtpUYjpIaBGAznC2g6FKAzG8VHZaGO7NrgXgvcclbT2rY0ptNLILu
         5z3WecI2sng/Uuxo7uRISQvC0IlpFGIO7nd5PxV2YgP9mBRKM7J7eHSNp5cuxHL2bo0b
         ScqA==
X-Forwarded-Encrypted: i=1; AHgh+RpPicrX+mng3bz7tsLecyWrjEWEfgRYrh/SP5G4E5GgETdqDq9VygGDwCkMz/nGzt2Vmb4ie5nTnQ==@kvack.org
X-Gm-Message-State: AOJu0YzFR+bIvBvDh/a7YSyCaX945ThfZ7JLGNvB3vBifhMkEzDzwArv
	67KNHlvWb2gc5m8fjKLzy88D0H38WRu6PyoJ4Lq5gBkknwaa7NOPevI/+bgomomrXhteDToEGGv
	ml70ijjpIUqtxVeKzM2vItEIt1/x6VJomuA==
X-Received: from dybgs35.prod.google.com ([2002:a05:7301:20a3:b0:2f9:af7:504e])
 (user=abhishekbapat job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:41:b0:381:2684:519c with SMTP id 98e67ed59e1d1-3893f694d9dmr3449270a91.6.1783533693427;
 Wed, 08 Jul 2026 11:01:33 -0700 (PDT)
Date: Wed,  8 Jul 2026 18:01:26 +0000
In-Reply-To: <cover.1783532853.git.abhishekbapat@google.com>
Mime-Version: 1.0
References: <cover.1783532853.git.abhishekbapat@google.com>
X-Mailer: git-send-email 2.55.0.795.g602f6c329a-goog
Message-ID: <396a5e4bc3b2990223ab355f2cd3ceb6aa15499e.1783532853.git.abhishekbapat@google.com>
Subject: [PATCH v8 4/6] alloc_tag: add accuracy based filtering to ioctl
From: Abhishek Bapat <abhishekbapat@google.com>
To: Suren Baghdasaryan <surenb@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Kent Overstreet <kent.overstreet@linux.dev>, Hao Ge <hao.ge@linux.dev>
Cc: Shuah Khan <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Sourav Panda <souravpanda@google.com>, Abhishek Bapat <abhishekbapat@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: AAFEA1C000F
X-Stat-Signature: faqcyqke94ysoc81jnrds9nzogc6ed1g
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783533694-429929
X-HE-Meta: U2FsdGVkX1/3ubfwu8HBoKR72Buso3/1W0r3vcnFwrXutWUBcFB8zT+NrLMZklAutQI/lqjGx6t4TRSTT1Mwkns5a1k4Y+6JXoO4e9s3LHQyO6XpjPNTssd4uG2ccRXnDpHQBod3DGUB+q/tQfR6pBq2hbpO1WUs0EuWm/kZfBvZ+i/b4MkNRpRUj4ugRMSBrXtPwIEB+glFq1fI7k/MAIyRr28cD6FyVUbLrO5AlTLqndFG3YhqL1CyIwpzKYE0ZmmIReGdZdev0R1zXn4antu5DUOn6bMcS0ClPJ6E2qPXW9nBgtu9ASxqLgHqPk9LIsoC7rXBmnQzaJiqJ5axDc0q0dFOXWfnckdYM/Jv2TCQGxsD1T7q4i88+tJtluy6d0vi86g50h5+/TVwq6SL97ExIewmXrsHHO2D2c+wyLJRhF4bHiLZrP8gWsHoVz1WdZb0hlgK3LFCeNMR8pePC1Cf/XnDHINqcAlapGYQEZhhnrbv+7nIAdgqTwxWsonbdx47J5ipsquG0RHOg6QdGjbY2Ts64caA9+oq77A1652t5plOWtOsxXMwadJWjkv/SNRjVwXT0ooRBdm/Fj+YbxXSitNj6ECpfp4RofX/x1069sW1/tTBt6aL39Ne7EMJvL9PPtktI6vIo0a8k1hkAEX8rhcP0hQrYAmb50z0CtSrW7PvxkUmlLKBxQtrm0MAeZXEV5yd9ub7oL8qgUI2xkQVMHDvpBk9l1Mta0YlhXXtIuoRA7dcM4cH9gRi6mRY3BFygVonMzeFfy7INEpUGOLqXlyrI6yLYvhaDDuiMtEQugjg8HEkYwXFhbhfs8A1Wdgr+iESWz/GgFRZ9wRQRzGdPyM+8lr1lajLrGU8chI+B838NVooFU08f5Insa9+pZK54GrYK7/SeKrLrFLj7Gu40p0Q4Ony7SA7Ba/vcYhHyCKPtka6x1wIUaj0nC5Otw9SUUDyR9o2sYOIJ2Y
 arD3YgKg
 IAK/2EcF+c0LZA6SsxfLD7HeSDhz0+lER4Aj7BNJy53UOx6RUWIjKLrTCB/+Wlet1uYbgn1tIHeDIFken0R0o/yl3H0IF4gnyMyONPjNO6BYHgP+jlGBbZDFGpNUQAwoIFCWt9pl/G3fOXmnKzcEuFQfrTKzHtyfQjLWSmVr8plB67+Z13yK/eJq91zlZ67w8lhRZEBDIs0idnzIYWjqsOsh73rlp4JjM7cQxS0YD3+a7OEbTbuw0aXe/KJPq63PK8hdw3nuuwgSB++O8xMLWDGRdITqrsDg+QYvudzqozzUh7fDe7RtwCIbT8bY3vdLHaJ1AOhMRGDsmRRO37N16dQq5iPWU7qVYuYkZ3rE9QKZGp+2VOJyU1tOmukmvcIa/xQn/ABUg4HmRUyn0FHkUFM6+4mZ8HfpGZJ28SyFFsKTTvX/Ih+lPrfIV+QVnlQnee29MUYnfryRyw8K0RYsMlD92ByF6RU8pD61LdravXarRDC76MpKv2BbGEwLRiqbO+YQq0YEdqVF2jXmcSzbOo40oY4x86SUMUhd43fLr5WCECm1S1sPUGAx9JiS+TDkIX01Qo00JxGbAC5Mue8kkiLKbRSBlWf5NDliZ6O3hFoh/x+o1QKvhVi1c9vUy1eaz6xqTdmheWqPE9NyKSUbkicMZBhFY4gdohAqTG4vPXHpgUHkZge1gXqkGT6G/O71G5/s3/c9qLXIhvhs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extend the allocinfo filtering mechanism to allow users to filter tags
based on their accuracy.

Signed-off-by: Abhishek Bapat <abhishekbapat@google.com>
Acked-by: Hao Ge <hao.ge@linux.dev>
Acked-by: Suren Baghdasaryan <surenb@google.com>
---
 include/uapi/linux/alloc_tag.h | 4 ++++
 mm/alloc_tag.c                 | 8 ++++++++
 2 files changed, 12 insertions(+)

diff --git a/include/uapi/linux/alloc_tag.h b/include/uapi/linux/alloc_tag.h
index 0de5fc180790..270f693b1822 100644
--- a/include/uapi/linux/alloc_tag.h
+++ b/include/uapi/linux/alloc_tag.h
@@ -31,6 +31,8 @@ struct allocinfo_tag {
 	char function[ALLOCINFO_STR_SIZE];
 	char filename[ALLOCINFO_STR_SIZE];
 	__u64 lineno;
+	/* filter criteria only; see allocinfo_counter.accurate for actual accuracy */
+	__u64 inaccurate;
 };
 
 /* The alignment ensures 32-bit compatible interfaces are not broken */
@@ -50,6 +52,7 @@ enum {
 	ALLOCINFO_FILTER_FUNCTION,
 	ALLOCINFO_FILTER_FILENAME,
 	ALLOCINFO_FILTER_LINENO,
+	ALLOCINFO_FILTER_INACCURATE,
 	ALLOCINFO_FILTER_MIN_SIZE,
 	ALLOCINFO_FILTER_MAX_SIZE,
 	__ALLOCINFO_FILTER_LAST = ALLOCINFO_FILTER_MAX_SIZE
@@ -59,6 +62,7 @@ enum {
 #define ALLOCINFO_FILTER_MASK_FUNCTION		(1 << ALLOCINFO_FILTER_FUNCTION)
 #define ALLOCINFO_FILTER_MASK_FILENAME		(1 << ALLOCINFO_FILTER_FILENAME)
 #define ALLOCINFO_FILTER_MASK_LINENO		(1 << ALLOCINFO_FILTER_LINENO)
+#define ALLOCINFO_FILTER_MASK_INACCURATE	(1 << ALLOCINFO_FILTER_INACCURATE)
 #define ALLOCINFO_FILTER_MASK_MIN_SIZE		(1 << ALLOCINFO_FILTER_MIN_SIZE)
 #define ALLOCINFO_FILTER_MASK_MAX_SIZE		(1 << ALLOCINFO_FILTER_MAX_SIZE)
 
diff --git a/mm/alloc_tag.c b/mm/alloc_tag.c
index 27aa47c4c1cc..2c819fa9eafa 100644
--- a/mm/alloc_tag.c
+++ b/mm/alloc_tag.c
@@ -252,6 +252,8 @@ static bool matches_filter(struct codetag *ct, struct allocinfo_filter *filter,
 			   struct alloc_tag_counters *counters,
 			   bool *fetched_counters)
 {
+	bool inaccurate;
+
 	if (!filter || !filter->mask)
 		return true;
 
@@ -277,6 +279,12 @@ static bool matches_filter(struct codetag *ct, struct allocinfo_filter *filter,
 	    ct->lineno != filter->fields.lineno)
 		return false;
 
+	if (filter->mask & ALLOCINFO_FILTER_MASK_INACCURATE) {
+		inaccurate = !!(ct->flags & CODETAG_FLAG_INACCURATE);
+		if (inaccurate != !!(filter->fields.inaccurate))
+			return false;
+	}
+
 	if (filter->mask & (ALLOCINFO_FILTER_MASK_MIN_SIZE | ALLOCINFO_FILTER_MASK_MAX_SIZE)) {
 		if (!*fetched_counters) {
 			*counters = allocinfo_prefetch_counters(ct);
-- 
2.55.0.795.g602f6c329a-goog


