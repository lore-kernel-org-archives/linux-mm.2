Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6060C5B56A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 14:12:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D85136B008A; Tue, 11 Aug 2026 10:12:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D35FA6B0099; Tue, 11 Aug 2026 10:12:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BFEB56B009B; Tue, 11 Aug 2026 10:12:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 99B026B008A
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 10:12:50 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 28C2680437
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 14:12:50 +0000 (UTC)
X-FDA: 85089179700.07.5B1E579
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	by imf09.hostedemail.com (Postfix) with ESMTP id 5E36514000C
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 14:12:48 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="I/VWJppG";
	spf=pass (imf09.hostedemail.com: domain of kmehltretter@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786457568;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bwwTg+OQL0Tw8flGAD/WL1rLA9ceEVBQqkqlLz//DPI=;
	b=ke8O/4DS5zdafIIH2QhlRH8V5g1L3KgNosdpsmCnBAtkMVwdKyrAEE9JvFgYXw4tmNRfRA
	hyJknSZTGuZqrW70N1lUfMxLBmAZvQx+wxM5FpKY3GbXiIP1YrHI55a1ZBPkE9ODvb5YtQ
	srLEcivlDF86KsTXBonp6yjmaSZKrg0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786457568;
	b=D0DMbJqqLZiwg18FD98tisFPD4goByYF6dEY5dJaxkRO8R8Td2Snb+M57fsk67j9SLhP5h
	dXsuIOflDC8dKaW+/NtqJVY6X/ea13dGrXuENFjr7GEcvQnXOb9Gc1l/gpWlrzx9FbHmwF
	6Ug/2sSWjCkkoCJ4l8aKzdFr1r+G4GY=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="I/VWJppG";
	spf=pass (imf09.hostedemail.com: domain of kmehltretter@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-47fecbb7000so1597737f8f.2
        for <linux-mm@kvack.org>; Tue, 11 Aug 2026 07:12:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786457567; x=1787062367; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bwwTg+OQL0Tw8flGAD/WL1rLA9ceEVBQqkqlLz//DPI=;
        b=I/VWJppGMZydtU5ZNRX3jlCIsgc3opL+8EIU7b1nWU8J9vXHqat+9C8uOaBaKwmmQL
         LEpsNi8ghAhjCENU0Kvk5DThaNaHy90PzlWfkk+OgzHXvwn4niql35BZrjKZ9A4BT8xI
         swupECL2Kvl8JB6gIQ24fAzp8RVZSU9TtHuk4/Ib8v9zPtyL0W3MJfkf/Ie/K9G6nDQA
         7YLkcAa/xyIxLqpaV9/0Lf1eN0ZCUbEK8nB+F9J+8sTmPefX5oxxGD7e3EMojuHHbq3V
         BNMlo8kd0Db7XKT0BGeNjbknA/0kcvyTqeafgEtDv3FBqcXEwJRzl46URxv2VN/lDmoe
         9ckA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786457567; x=1787062367;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=bwwTg+OQL0Tw8flGAD/WL1rLA9ceEVBQqkqlLz//DPI=;
        b=himkj/4dmI6Bu/1X/JoGuDygbiyGdvuSoSiJ60ZNzjWCZ1uxX/tdMWJUfb6JJOyLFm
         Kujm8zd9hp9TBzVYY5Fqsr8HHi1burRWoU3ddoTR/gyxUf2AIAJo69069szlDVWq4IS2
         FlWvxZPt4EntBkhYLwGPJGI4atKcMW8KPzJ4zQJFFn3az79BA/7Ez+xyvAx9k2yUJ+dc
         80jgHGwItbxfCcQ5FEY4PBWsyqAeHjvMs+wXbz598lMYurVmCEko0ypG2yYbBSFrHJer
         CrdZDguA7VCsQ5Yg2RZAjpTGqt+vxMuaT84lFsrXL/aWM9xTYU04Zr89iTlNppk8fQe+
         mZAA==
X-Forwarded-Encrypted: i=1; AHgh+RoNRT2JeIwyu4Jj4neL1TtxNjrGXbnU11TRo9gEVZUO1lKG63fcf083oZLhoWdHo5Illek3jeTMXQ==@kvack.org
X-Gm-Message-State: AOJu0Yz1KHukZqSrBY2bPRs1Zg0Wizg4aC9ZZnGWQFQ9SySf7cXrWPZ9
	X5AFSo+g2NUzTu+KPi3q9BbPw1mrEcL2pykdBV4Y6Ck8TFgnOA0OftlG
X-Gm-Gg: AR+sD12UHbBsFoLc/D1LSYnIZbyTKdAFB+2jDfnghNKJXcYu5vY6kQX2TnEQ1YeDxdJ
	NmjYmnI4WtCMg/kngNrzxMTkGiYjl+GWjx2ZI3uBPeYZecijSN2EinkqGKamYaaXYWhjPPzXpwt
	Lxjc/bzKcBFazTSEbMTkKkBhu125oF7slFjsFy27QGmmA+Lb+eetYokMSrnin5q1N1wNI/aRRnh
	bDkbWOv7Tj34Yg+YqnUFKxmigvSXrwFMwDdWv+tIWWqvtywS+trERD+LyMN/ybieU9ISP033ezK
	/vkbr+drpjBZeukBFLK/p5XLZ6MFKJFg877QCThoDumQTg0Avnw4CrgL6IWrTh6Rc0eVS5ZR6US
	3rLW2Ad6DR3Ow23JdMYwUxWVxSrkg1TxCcwJ+HL0+64FF0AYFyaE+9krSTs6sfvsJR5otaKGTVo
	00PrJvcg5uy0Cx02uNDUrOX4KvIgNkPFXxI1EmLzXauD/2EPRTE0eNcMrNkME065DqATKwV1d7n
	am5ehSMmv++pgjH+Y6O7hh5DzOc5Op/VCg5SFGbSbXR7zLHXzGp+7zX7Gm7iYGLirT1loCtPDY8
	OoaSXyyQ8JaXNbLnHUGbC80eJ544zfB305REVsA1dNDZEkTaf3nknmiqv0mourMukzYY
X-Received: by 2002:a05:6000:240c:b0:47f:6dcb:3737 with SMTP id ffacd0b85a97d-4814aee3ef2mr5025916f8f.29.1786457566359;
        Tue, 11 Aug 2026 07:12:46 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a02-3100-a133-e401-bc8e-d36c-2d08-c5e0.310.pool.telefonica.de. [2a02:3100:a133:e401:bc8e:d36c:2d08:c5e0])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4814a5be29fsm4464099f8f.12.2026.08.11.07.12.45
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 11 Aug 2026 07:12:45 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Vlastimil Babka <vbabka@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	linux-hardening@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev
Subject: [PATCH v2 1/3] slab: align ZERO_SIZE_PTR to ARCH_KMALLOC_MINALIGN
Date: Tue, 11 Aug 2026 16:12:38 +0200
Message-Id: <20260811141240.62519-2-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20260811141240.62519-1-kmehltretter@gmail.com>
References: <20260811141240.62519-1-kmehltretter@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5E36514000C
X-Stat-Signature: i8jtrg9afej7osi9tbgzsfwg1piokigb
X-Rspam-User: 
X-HE-Tag: 1786457568-56970
X-HE-Meta: U2FsdGVkX1/T1hMDXq2oihWKyBDR71YYXTJ1mDcjopiE+NUcqDQGm24bYtGSVpRHQqCTgUiolDh5uixwP0Ot/TT2MMR+atS9f46AD35AUH2DJgQJXkYfbrx3hskrCZQV+eD924k73L/2tp2Dc5fOGbj+uT4NAGNBduo36IrGHHrP5b4Xlc7vFQxBRElyI7h88OOiYiHrIsXATVQ5i4PIS4jSj/Ze02xgihBtpTbPtSTpVr31RsX2VRnX0HxLp7W+1MYNGGbZIu5MpN401e9Vx7rxW/VdG6xuDUdQXwdtGcqAzAuNZT5jlBRgQr7fucMgDpK41jUJrDhhxRICph1RzM/I2V6d5pMe6SZBRgCxygTCZCryXi38FKtsDiEvXNL2HKEsPUs1xF9uE3xtf4Farm4HxPdjzDAdPxsDJRbnQnXLj5VzsKAp2M03PRKBSJYq6pnhefew+/C3rU9ryNvMQx0IbuNTJ+d8HxlBHM3jYfgpLYMVwakdc/hL8zYmh9JNArG3KRpdUtHWMzDnko9sf4vBtioTF+T7Q2tpnBEjlWf2C+jkMFRQ8/KC6k+/A1qPuJvJ12XY95HnSco7WgBMsbxZZ/mNecQGliPA5fD5cr0m/Dq47pfzKXtpWmr+wLZUGEW5hYoS/cB24fsm013sBvSJC3jzLF+X0L/2H3m7U/vwPVfdy2a31FRHxRchXfmqdOeBDWl/QCQ6OgvwD2acDb1J4gErz0muDQj0tEbZit7Xhs4Lr1SkGqYyF6GVAkXGV+UDEKGS0TLFHAi779oEfe7EfS+KXZDkY83nVEq4cStoJBguEjzU4oGjREspi8nf6U+o7oWxmvB1rMMfwiO8dltwtbgASzcskIaECbvDf72kkiUh0oySPxSzkOnx9uA48gxN7WaG8+mm7N731bhpWKfMgKaPZTCLMAABmDtKOcIl1J7ndavvXL+7iKfWqQ2sVkefFocpOwwGkkEBQ4C
 qy/1mWXD
 Cy9dAY3XWe00bR6y8TucpebwbiCo+ZYNPhdmge6MeoUDSB0tf64cVJSXd8xX3aG7S0LpByqGp9dWJIotdXcLJRfajQbgNWD3oOI25vJNsuYkHiPTi6pVzIRYrYeTH9BiTONqPNP7RVb0+eAA0QZqQXlDSz3GfayhqYz8agu+fiIDgWlxNE/LlLztR6wltQiFSDTlzSqAvpLFN9/tYFTsDsJ65Jg3EyOpgRa5f+f6ELcPeY2QSzBO3gE0VbGZKrhYeRf0nMZgSw8czQssE/KJH14tbIBnno1v5JKMhWQSD9eh8PvqzGrd/G6z/iB/tGsOGHQc5fe5tmc0AtXaeFeTUx/zglJElKqSyoTj5fG/Ibyhp0bNNwtKYeOfq2mg2WGTfZ1KdH8ixitb+6y6BsCrLzjmyRLiRuN4L0GA/jg0oD88TWq5byOI4aLopj2Fpmwt2s/xWBt/sB8LXoJOu34FrNydYqw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The kmalloc entry points are annotated with __assume_kmalloc_alignment
but return ZERO_SIZE_PTR, currently (void *)16, for zero-size requests.
This violates the annotation when ARCH_KMALLOC_MINALIGN exceeds 16.

Clang's UBSAN_ALIGNMENT detects the violation on armv5. GCC and Clang
retain the ZERO_OR_NULL_PTR() range check but eliminate an exact
ZERO_SIZE_PTR comparison after an annotated allocation.

Define ZERO_SIZE_PTR as the greater of 16 and ARCH_KMALLOC_MINALIGN,
retaining the existing value where it is already aligned. Assert that
ARCH_KMALLOC_MINALIGN remains below 0x100, the value of LIST_POISON1
when POISON_POINTER_DELTA is zero, so the sentinel remains distinct
from that poison pointer.

Fixes: 94a58c360a45 ("slab.h: sprinkle __assume_aligned attributes")
Assisted-by: Claude:claude-fable-5
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
---
 include/linux/slab.h | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/include/linux/slab.h b/include/linux/slab.h
index 32c9f8ed7ae20..3e012cc4f001e 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -259,13 +259,16 @@ enum _slab_flag_bits {
 
 /*
  * ZERO_SIZE_PTR will be returned for zero sized kmalloc requests.
+ * It satisfies the alignment promised by __assume_kmalloc_alignment
+ * and keeps the historic value 16 where that is already aligned.
  *
  * Dereferencing ZERO_SIZE_PTR will lead to a distinct access fault.
  *
  * ZERO_SIZE_PTR can be passed to kfree though in the same way that NULL can.
  * Both make kfree a no-op.
  */
-#define ZERO_SIZE_PTR ((void *)16)
+#define ZERO_SIZE_PTR ((void *)(ARCH_KMALLOC_MINALIGN > 16 ? \
+				ARCH_KMALLOC_MINALIGN : 16))
 
 #define ZERO_OR_NULL_PTR(x) ((unsigned long)(x) <= \
 				(unsigned long)ZERO_SIZE_PTR)
@@ -622,6 +625,13 @@ static inline bool kmem_dump_obj(void *object) { return false; }
 #define KMALLOC_SHIFT_LOW ilog2(KMALLOC_MIN_SIZE)
 #endif
 
+/*
+ * Keep ZERO_SIZE_PTR at most 128, i.e. below 0x100: LIST_POISON1 is
+ * 0x100 when POISON_POINTER_DELTA is 0, and no architecture currently
+ * has an ARCH_KMALLOC_MINALIGN above 128.
+ */
+static_assert(ARCH_KMALLOC_MINALIGN < 0x100);
+
 /*
  * Setting ARCH_SLAB_MINALIGN in arch headers allows a different alignment.
  * Intended for arches that get misalignment faults even for 64 bit integer
-- 
2.53.0


