Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73190CDB46B
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 22:57:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E3596B008A; Mon, 22 Jun 2026 18:57:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 946286B0092; Mon, 22 Jun 2026 18:57:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 772846B008A; Mon, 22 Jun 2026 18:57:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 318E96B008A
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 18:57:44 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5F051402F7
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 22:57:43 +0000 (UTC)
X-FDA: 84909062406.28.8F06EFB
Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	by imf09.hostedemail.com (Postfix) with ESMTP id 92184140007
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 22:57:41 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Eh6Tnnyi;
	spf=pass (imf09.hostedemail.com: domain of 34705agkKCJ4R8PSLQ8FSEMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--tarunsahu.bounces.google.com designates 209.85.218.73 as permitted sender) smtp.mailfrom=34705agkKCJ4R8PSLQ8FSEMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782169061;
	b=Jo/h1uOssIXc+7ZRNF2/usmxcfkMppWit2OQtl9VT7YohHGBaAJU222SvSKVXTc4raZ43X
	EyBSZ5MLYHja6No6ycpS/YHPgrOhZEuNhY/vHykMHOkNf8/TFI6uiCWHcuXBwZv6bJkE0h
	QzC9wxb8FJWud89HUNIMN0oThhVbr78=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782169061;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1NOYzLzQAQS0m9MRiDTCQXpcLo3JF92UmgVDsUD8aNE=;
	b=QOv0bd1DaZTmH7a9hiNbSbRuawoRLx/EwP7PsmS8saqGxONNa/cpRHPQ/c4J+1DH7ZOT+l
	i46g+HHcMQ0H6aLew3THlTzSXdN4hvMwVlzVQMR4Brudsz57peaOfdq4FdHZbIy2xIYZ7b
	uzaCDZ496mXMwcoL3GK7APyxaZdx4sY=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Eh6Tnnyi;
	spf=pass (imf09.hostedemail.com: domain of 34705agkKCJ4R8PSLQ8FSEMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--tarunsahu.bounces.google.com designates 209.85.218.73 as permitted sender) smtp.mailfrom=34705agkKCJ4R8PSLQ8FSEMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-bee055582b7so342800666b.3
        for <linux-mm@kvack.org>; Mon, 22 Jun 2026 15:57:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782169060; x=1782773860; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1NOYzLzQAQS0m9MRiDTCQXpcLo3JF92UmgVDsUD8aNE=;
        b=Eh6TnnyiB+GwER8mqVMyXO7XnUbg5b+7q/aFlqsmfSnFwGfsIrmlXGNWUPyTUGncPB
         MUTIQPoOQx9PYwbps8rSx/vnbNdc2SCG8HELt+lZZ0gLvGqGP+995ywUa1FrrTkCQbKJ
         0o+s6iX2yxUxsh4nBpk5lIQuIcYj9PnprZ9cdFg1pLDGR+AyF/JVmUlMkxIRYjFk9pdu
         NJeY41/zefZ9Pew9EekDksmMJIdYjg7HnymXy7RyqtO6LyG6xE9EXxE0jUgh5vmUim4t
         8r0F5Tawle+TBNBhYrVPZuozHy+IbgT/u1OOQ3tqNe7WBYgH7pmuI+pryglaX4u+/ADk
         ZPQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782169060; x=1782773860;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1NOYzLzQAQS0m9MRiDTCQXpcLo3JF92UmgVDsUD8aNE=;
        b=fWMBNTi3lxIBW3FuA8F/ICtsxU2pMHWThiBsS2RrjnVHJSNwS7zAnNQklmKsTEUjd0
         EJm6HWOk9dIkHmUvQygy8YCf1PPa7gsIz1xnXmBlaRrReOY1hI+6kP0EVXrXNkOJF1py
         3cqNF+aVc8lUC95UImL1e5Isq/HoXlGGFGF1LuH7CMrSxqLgDU6DbDc0LmC+rdnp6B4a
         ov2ynYZHTSloZ3oYaGG+2JcuY5enqm8JTlpMid1v7UpWMfRxlCxMWvLckWS18ZUgDuXg
         aBrsDXKkingoi7uSU7fRGKwGrbotomprVL8nvoONVWsZnx53E45poyKy5DLAztvS00CR
         FMnw==
X-Gm-Message-State: AOJu0YzWWH+ipBGN++OHdewnnAJ6XFbHg72elYg5uxw985TaI+jL/lv9
	btmh/25cYbPN6Zjp9NNVkAnqp1Aqbdo6vlCSiR/QiS+ylAmw/8l+GpiDnDE8bdSP4pZM8nbSEnB
	JXtvrrcTVlGfuja+uig==
X-Received: from ejbla19.prod.google.com ([2002:a17:906:ad93:b0:beb:5fe:489])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:1c97:b0:c0d:2ab6:8055 with SMTP id a640c23a62f3a-c0d2ac5cc8emr526314366b.53.1782169059511;
 Mon, 22 Jun 2026 15:57:39 -0700 (PDT)
Date: Mon, 22 Jun 2026 22:57:35 +0000
In-Reply-To: <20260622225736.2961438-1-tarunsahu@google.com>
Mime-Version: 1.0
References: <20260622225736.2961438-1-tarunsahu@google.com>
X-Mailer: git-send-email 2.55.0.rc0.786.g65d90a0328-goog
Message-ID: <20260622225736.2961438-2-tarunsahu@google.com>
Subject: [PATCH v4 1/2] kho: add KHOSER_COPY_TYPE(UN)SAFE for phys copy
From: Tarun Sahu <tarunsahu@google.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>, Mike Rapoport <rppt@kernel.org>, 
	Pratyush Yadav <pratyush@kernel.org>, Alexander Graf <graf@amazon.com>, 
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, kexec@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Tarun Sahu <tarunsahu@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 92184140007
X-Stat-Signature: 8anokxsd4xziuso7d7uzu63y16pyma5a
X-HE-Tag: 1782169061-206004
X-HE-Meta: U2FsdGVkX1+vfCU24rEIs8LiBopZBDVMlzHU9w3BCrZD9w8ge5VkvjZBW7fwdpztNUHSLZjfz/pLeOWRPdIyt72gbJKTYOzCRhTBakAeslQS0kUz6e3CAULOVY+HZKJtA2+9DdUvJctSXVF/n+30ZCV3+TIPkJQWQAppZE/41VEME62RbT7Pp7e30tzdwc2h2Nb923Ss/subcwp+KHiZSso3W6NHzT0pDXce0trX9xpCFuUCJcxeOXZ7CHBTmgQfaXJ9kV8TJIAW2JlfyObWQbLLUOCPJubmJ2wZ/Vj6+redNYq+0jDxBvpMniWzN/JrtUOOW+mcM0UjQjewn+j2+two3u4uiyuqNJvrIFL2sa9Pit6hhByAEFkd8tj1ktTzUxy2v9eAP2H1K/KeKm2aW7KOKpcjoV62WJbAPkKchFVHrgvZHI540LyWeUR0d8F01r4oDE1UHuW1pH/iRn3p0ey9zY57MC1n3kHcAhFmw7fSY3B7Ngn8ymvneYccTxnqRF3IBCj1TFUxq/jAn3npTn+VcQthu97QzwpSzpk8t9pDJBUoRiYt4t1mAQ5uSvimh+JO7eeB+xhn7HEdbhwyBAPKJs87qRmJhN3SzQJq3i0XU/b9ROzoKKSkQ0SwUm77ZmUJdMPhFN0rnaVUg2NXL0fbRVyU2LwSoKupeKIMSswcjGvjXyCLjuc6JEBJkwIVAYRrI6pCCtgJsx5HGgrqEmNvOMxRaURO4yf4S3o0dkVkVYaueCnO9kbE0zLZpeKO20b6rMVS94CQVNzJ5GObFHkH9Sh5yIZdNf8xq3smOJaajsNy+b4qiyvjj4VUpW/rCWIBYHIrHr0qYxzzbi9TM1Rrq+aAfcJGbSL+G1IrrgwYlDCBLWsd9IQMm9wmv2oY+ombXLlKv2OLxhBWRW+MGIbB/6r+E5xaqvygxk7wVP95yfg9G4XufDRH5WzKYPR6z91LhSgPMEzVkeC4KEj
 Z8FY2wHa
 OmuhhZs/4GUVKQ0XzsA9t08cG5/jRw38EoumX1Ye6o3GeJZ+ef1x2RwtnQOZ1A56W7lOCVBNrE6oriCLX20R43D++BGCTQVtAH8VO3MhhkZLj9JWu+P6CkA7JZqWh8jsF0s67FBT0AhGGtgSLR5wuQjBBqd2IyhhOmjUAOD2P5VKxktp1sGdPVwRBbC3i7yq2jlyJdzs9GFtV8bn8cxOsQQAkb4EPgTzjpWvW5tqcdL7YP3NC2fU6tchYmLbtrTr2f8NLJBkiY0F8zpvlIQ9griQuFWumGV9XbAThBTxFKp3mnnnpWHatsLx988i+XVGaLZfQnzhYHPii132sHID04O0iCmv6WFHIunAqRY98Sha8HG2p5k/JO+Wk8u3U9WTLSQiQK/00bQff1mi3ICmb+1bNIGUy97sXX9lxvvigk9O9PNxkl4gGzWxg6KKfLQ2sm9YlQ82/lw/ZACp+90lm/hI6/5/DFsrp0LWnyTWq3HlfI3HLXz62j2Mu1g+oRukTaF7NhFmi0N/FTkCN6ZaSEiNwqICSL2gof3uP9HkoLaW8AR6HwwWNigyIBizLLEXTlV9j9EGyHQb4Dg/mL3lpKi79QUWLhxE4GMLllU2u4kxq5sg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Adding KHOSER_COPY_TYPESAFE and KHOSER_COPY_TYPEUNSAFE to copy one
serializeable pointer to another. It basically allows copy of phys val
of the serializeable pointer.

Signed-off-by: Tarun Sahu <tarunsahu@google.com>
---
 include/linux/kho/abi/kexec_handover.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/include/linux/kho/abi/kexec_handover.h b/include/linux/kho/abi/kexec_handover.h
index 5e2eb8519bda..c1b61d875dcc 100644
--- a/include/linux/kho/abi/kexec_handover.h
+++ b/include/linux/kho/abi/kexec_handover.h
@@ -139,6 +139,17 @@
 		(typeof((s).ptr))((s).phys ? phys_to_virt((s).phys) : NULL); \
 	})
 
+/* Copies one serializable pointer to another. */
+#define KHOSER_COPY_PTR(dest, src) \
+	({ \
+		static_assert( \
+			__builtin_types_compatible_p(typeof((dest).ptr), typeof((src).ptr)) || \
+			__builtin_types_compatible_p(typeof((dest).ptr), void *) || \
+			__builtin_types_compatible_p(typeof((src).ptr), void *), \
+			"pointer type mismatch in KHOSER_COPY_PTR" \
+		); \
+		(dest).phys = (src).phys; \
+	})
 /*
  * This header is embedded at the beginning of each `kho_vmalloc_chunk`
  * and contains a pointer to the next chunk in the linked list,
-- 
2.55.0.rc0.786.g65d90a0328-goog


