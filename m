Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25925C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 17:07:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 276A96B0096; Wed,  8 Jul 2026 13:07:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B2696B0098; Wed,  8 Jul 2026 13:07:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 052006B0099; Wed,  8 Jul 2026 13:07:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CD6566B0096
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 13:07:14 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5EB448CBDF
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 17:07:14 +0000 (UTC)
X-FDA: 84966239988.29.51CEBE3
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	by imf09.hostedemail.com (Postfix) with ESMTP id 89659140007
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 17:07:12 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=J+dKlV57;
	spf=pass (imf09.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783530432;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pruJ/v9XfkTpXQ3qHhlgzQ4uIIagbs0g6+xY02Tr79E=;
	b=X1P2U6r1P9zHXsb0OJUvYt32OQo+z8/JuxdT+KMuNf4i6/goDYkMwcdTiUMMmaN+XIJsI+
	YfYLLIpnM0FjFjXrAHJV64Sdl0bmfC7FpIgLOe3kyILUj4Ykn8WxsOEB3ldr+OGiObP8VS
	NVy/pcXxYSszDAieIPa9mFWBakS5kXI=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=J+dKlV57;
	spf=pass (imf09.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783530432;
	b=yDnnBDpWA1vNoFFzzAyVZsH8ThcPyuyGh/5IXKstSn6NYwuHoiKh6xy4IvkK0g+hc8UpB6
	QRL29AygY1d+O5k8t6t1LbWDhzKW+8+F9dcMpoWIG9uoaGSYiMd3kguLdCMJxY933ie6i0
	DuYTzu9oWviATRiLg70gRh/GlM2IkWk=
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-8483d01240bso22692b3a.2
        for <linux-mm@kvack.org>; Wed, 08 Jul 2026 10:07:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783530431; x=1784135231; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pruJ/v9XfkTpXQ3qHhlgzQ4uIIagbs0g6+xY02Tr79E=;
        b=J+dKlV577iuX3gsNfPbCQpFWVtqtDO/cq80/5n1FBqjjW2ocmSx/ZlENVW6+T3q8b4
         hsbxwvfANElRy0NElz2J+QnBY6hEPT1WAoMrIud0vnzvHNnlWqnU9xs8NXEHUY+Pe7OV
         vGHAaOlJJPkfTbIszNKHiAQmUnIy82S+ScXq03ec194/Ikao4pk1b85HZ1ErrHtu6ruf
         9XXLUjmj4msXhi7yAAtvyNdyNiDuvCKqnwDR2hEkZpxIwfqWTqNu8EoDQAkEo6rqa73o
         qq67ODk1jGgEX6MYeynyNGDvS9DJGp5gwOOg5vVyGKGUklsWgrII/D2ab4PlLL0ilqw7
         26Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783530431; x=1784135231;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=pruJ/v9XfkTpXQ3qHhlgzQ4uIIagbs0g6+xY02Tr79E=;
        b=jRc6HC2iys0nh9K7VNOJEceTrsHpd0rYWzobFDjIJpEwyMNSgLoyiUA3ikX+L/ijZ+
         U/7ic4ISkm7efk5jyhC6Jj0/+6EzeriVmUwhXZO+A5gF8r+sfoQFm1ZfGun3R0no5y/9
         xLC/JJti+p1RPGhqNnXHH/ldbvG2mXlKQ+KrsopmcyjA70HqhimQ0l3WGrC63C8SFLFR
         w/VzUn28zJXj23Viu+OiHQb68D72FN7J6iRcvIlaecn/xB8Y2FALptogMSLL/KO4Xivk
         xMbdtCG84Lt+LYe/GJypd3oXymvSSQ+GXeSnjBJZTeXeMtGP12vJeOb4wwyi6g4mtdTl
         ch3w==
X-Gm-Message-State: AOJu0YyuBj5tOPEnw+TVbRBALGVl+2z0LL9l6PQD/zSB12uLIMODRQtL
	imyIPyNUmYJWvsaG8p971zQcpm01V31LjhLSVUeeZOdUmwguW5uzxICT
X-Gm-Gg: AfdE7cmC0YInbDoSMqQYQI7cn8RN3E6Pkw6T7995LjFuYNTVjPy7xFB65kNsOAZSLQz
	KPaFqq5IKh/9RUvHvXAVCeha+FzMVt174mjVTtjyI5yHLEKySOAm88VkEg8Og2ZcaxIgm9NunHL
	X9/hIgsOjGKGIllp3geLTMc0SfjOhYFg0q1ri0MYGHJrcpsH9cMbdVBxS+BvExWPhM+0MXoE1hs
	qfTNI0INz2gYKepHj2ConWtJRnPFHQOc+NNwAyGkJbuYFDe/U1oA5ybuA6OcDHJIv7MkBGT8uNf
	hRzG5KjGIs5Y8P+Brm6wFJUJtWJ8XYaCFWtu/tQss73qZ7z3eSsJqHtVsdatlYpDI5O66emC2xi
	2NzgCxhMB3Jn6Jrr2geGcSUJYbQF3MX+SKdxZf66201LCgXKVYQ+1q1dE+578KjxjBekEECy32y
	wHMcqngt8=
X-Received: by 2002:a05:6a00:4109:b0:848:30c7:6ddd with SMTP id d2e1a72fcca58-84843008427mr3499573b3a.56.1783530431370;
        Wed, 08 Jul 2026 10:07:11 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84847275fa0sm1119528b3a.22.2026.07.08.10.07.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2026 10:07:11 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: akpm@linux-foundation.org,
	Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>
Cc: linux-mm@kvack.org,
	Sang-Heon Jeon <ekffu200098@gmail.com>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Catalin Marinas <catalin.marinas@arm.com>,
	David Hildenbrand <david@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	Will Deacon <will@kernel.org>
Subject: [PATCH 2/3] riscv: remove unused __late_set_fixmap() and __late_clear_fixmap()
Date: Thu,  9 Jul 2026 02:06:46 +0900
Message-ID: <20260708170647.362562-3-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260708170647.362562-1-ekffu200098@gmail.com>
References: <20260708170647.362562-1-ekffu200098@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: jrt9m1tgz64ttinchhb3xwwfjqcw6oz4
X-Rspamd-Queue-Id: 89659140007
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783530432-483564
X-HE-Meta: U2FsdGVkX1/HvYrER9OJdVAszWys9Lb8b70/3jW5JZIQ3zC53VrVDZkYCdePEIkea3Qc2BewQhASQWAKe1YCdtj56VphDMOyrE4KgRdHNnxEjKQKrTANvD4x73yD15HzY1bat798PqC/yt/i2m46uP7AMz88VyfXX80nus0HqkA7U2zDBDbXmxNxnA06+l3sD3XKNyFY0cH9fnGvfbTF/gA1M8vAwa3NyPeN9DMGPU56UExOKfZC+TzcrPf9HPM9/bZ+txNmYmjE7E+KTg7J9qjk24smzmJbkqwMBsMbuBVOAwRANUOpQnWRxBa2Waix/Z2zigeIB6L4a6FMze96o0/xPJvyLNFOsrqnMBmtlPc9AfCRgZgA5i6kLOW+ndnCrSDvIk+o3bQLNwOMN1VqR+jX0bmIOEE5MkNJzWHuQ7eahu+KmLX43/cm6ZdPRfz4EPfKxb1vM4uXFTI7J/Mhoxls9nvcrZssqKGQHWrfPOAtOlC/vaoJ71s48t7zmROAVHrsKHIkFkGrz1dYhnDT6Ae0AAv3UNZPmCtfuBTDhWfWLaYCAUD+/vYhBe9SwtY7+1uQFaHNQazidMFVuJgWKV/eg3sDrfeTHi8oRNWRNyMLk0GOirZd1TV571DNSDK0DJxK9OSMaRJ2RMSQAu2+936Nsj82qVn2b2F1FzrKq8BDSGOBvkLVTOEnu1W3gn62rYFLypVGPuwDPblRvqepcuaCrzBWDObrHZRwS2u5IsD4TDHTi45/B1Xk/q54Ga2qSiaYnJKRUYnkeZmKwaIUL0Rvn7KQJJB1peCPPZNoXVMk3zNTSI3KcYl1iejGM1nT8oPwBZew2gp0gd8MfAeTIn+5gaNR0DkaMa9ns2IaloSlL8Fr8UEX/AuemC1/YPbWEZathX5O7laOqK67fsYfcj0OGCBBW14VKf6vcxLpAUD3tSLCC4JPueizY1nmVPWrYDcryTdiS8AxsChP6v/
 +U2FwBVn
 ea43Z/s3TO0gSvd0f/KFrFHTT4s0tGupA0DaDQlHqDhHf7uhamoiziUYe6dmKjx4e/WkoK6HovS2LjJT3UidoxyWDVs5C3Li3svbQ5xYXQYU7NBFqTtAbso5Ypvi2hyYuAbE6lnSgGNuv3jUGphoLhA5xvUbOQh11e9mvAVBx7vC+JCz9d8MNUPEno/LY1B0vQGolUOLTxbfKvTAjWRFwQ3l5HGK0C7eWVfDUzdp5Ruh14qRNhzLyLs8l/wZEYmWDYcKBcnX9iq9jRZV6inkQ9O4+8YugL8eatLoEH8tpqa0V4+0VnWCdWeY+yFT6ym6w4A4jKCH9UoxlGEvoen0e8AtexLU9tX8IlMUnNTogY6UNrPz/Gf+wk9VJc1BkLtS/ZYQmTJ+dqBxrUUqm46laKfKYXoZ6ZWPdNSGBLcoFQ9oVuhP9ZWNOHq+UodC5/+Az9j8tYR1c9FPbxbo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

__late_set_fixmap() and __late_clear_fixmap() are only used after
early_ioremap_reset() has been called. riscv never calls it because
__set_fixmap() works before and after paging_init(). So remove them.

No functional change.

Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
---
 arch/riscv/include/asm/fixmap.h | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/riscv/include/asm/fixmap.h b/arch/riscv/include/asm/fixmap.h
index 0a55099bb734..a81823c5ee4a 100644
--- a/arch/riscv/include/asm/fixmap.h
+++ b/arch/riscv/include/asm/fixmap.h
@@ -55,9 +55,6 @@ enum fixed_addresses {
 
 #define __early_set_fixmap	__set_fixmap
 
-#define __late_set_fixmap	__set_fixmap
-#define __late_clear_fixmap(idx) __set_fixmap((idx), 0, FIXMAP_PAGE_CLEAR)
-
 extern void __set_fixmap(enum fixed_addresses idx,
 			 phys_addr_t phys, pgprot_t prot);
 
-- 
2.43.0


