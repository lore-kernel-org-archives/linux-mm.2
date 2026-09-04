Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0743EC624D3
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 10:49:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 08A676B00A7; Fri,  4 Sep 2026 06:49:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 03A996B00A9; Fri,  4 Sep 2026 06:49:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6B7A6B00AA; Fri,  4 Sep 2026 06:49:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C733F6B00A7
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 06:49:07 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4C9CA12086C
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 10:49:07 +0000 (UTC)
X-FDA: 85175757534.17.BD16BDF
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	by imf23.hostedemail.com (Postfix) with ESMTP id 8741914000C
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 10:49:05 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=UiwGJtYF;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of hemanth.selam@gmail.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=hemanth.selam@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788518945;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OlLVTDTkKLUK1RrWb8jn049QsgDUDcnIGDsaM7mMOOY=;
	b=PB4+WUTY1WBj3yO+GZmRfPBd/TlqPxWtm/YxaS9ELEhslbCcZ6C4QyorsAutG3x8ok16Od
	W3cPepZca9ZieDo12DS81cGC24Yb+GnRHbnqOD8uaN1VypOsrIohXs9tCzUBhdlng/y34P
	3XSbqTewVGqo35d83J/5p5ZdJIg4MzI=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=UiwGJtYF;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of hemanth.selam@gmail.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=hemanth.selam@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788518945;
	b=e0XRygTE7Tnws3pv4TuX0FJxm84HMe9si6zFEkmtK3OvfjtmD8ATpjS5zqypx94NwrfkP7
	712/1Ytm6sLh8AGFMhp/1d2o9Pm9uMSj1V04+ZzfrTzAlDIw7Ccp3N9jDji3nwIvvQMDGo
	7vpYr1SGrbDoTiXDxhY46S1D+3FMa7w=
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2d7195706f1so9534875ad.0
        for <linux-mm@kvack.org>; Fri, 04 Sep 2026 03:49:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788518944; x=1789123744; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OlLVTDTkKLUK1RrWb8jn049QsgDUDcnIGDsaM7mMOOY=;
        b=UiwGJtYFDXKkcL/pU5mOJQ4rkRJ9Lhpdcw1VZwbvtjpG14h/cy12wbj8Z/hAuvnho7
         5sVwvOyMQTxOHKYMGEBNHd7hhhNzSonVpqKsA4EtxAUs8vBqvaCbFvh9x2SPzMSpQeUR
         hbkSFVQZveDZVxDzFk7NakDfAIdRnjU6I/76iKUgiSbcJwcEF9+xMzzcCyT1ma5sApDy
         BcmQZYVuDNqJDOLqRdIEQagQjkXhBkQTqaeWCY5NfdtlqhzAkdE3YRDrtc7wcPhBRABk
         2hTqim18OKPfIU6jDGEf0ivDWcWBMIJ1p+do8x7i5KtKRZqzK/1aLkw4/0UYq42gIDr1
         HWCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788518944; x=1789123744;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=OlLVTDTkKLUK1RrWb8jn049QsgDUDcnIGDsaM7mMOOY=;
        b=ikAN0KjpDPrlnzObvaYa2N5HL+/Wc1NknWjXhPHMPp47mPDBg/HIZ0i7uo67hOAJWg
         BhlLEEGM8AqTq58NtbDy+QZMQiT1GChwPFptb3jAeZtLClOZ2DFli580TL9KEU8BfvJV
         /cNW0oAEZe0Ov4hR/8zwj67ueUPEmchygsy+Orj710hTt+o/j01EjfZICpJ4gzfOYO7C
         QjUYobPBmMt3VwAnO/n94qME5Ian1TmTBWyqHvJkX5APXz9LP7M32p7Tvx32BlOwNBHK
         Mhta5d3auvvDCMNBwmEl1IMWpjQvL6Sd9ipunEGLs3ZyetNf5UvOJhDMcbXRNVRWe2LU
         LDkQ==
X-Forwarded-Encrypted: i=1; AKwUvBxlcjrfE7AYX4DdsddnKDAzne0kNk/5tMbfEdsYFxcrUYRdg2xg7FccuF/tHWlLTJLj4OIoTnR5Jw==@kvack.org
X-Gm-Message-State: AFuF++l82wpvOmQuicAMnpbSgtwxKlCnhUVatL/ytuLuruXL+T9xtgFb
	8ADjuL8/1AIZwLrDKiZSDyndA9tt67MKp/NaUf9OE481okW5KiLIKHs+VkZqF3gV4FY=
X-Gm-Gg: AYBFou19FE1MqtDT9sTVY2JTd77hEX18yBkZuG4OL7Q9BI0PNLoR9u7a5phLE8+fnTv
	ebpsf0UwZPjgOBoaNHojuLMCvgzbaMXJbMW1kFOcGKIE0Rjlpm2dehvzVPtnExjiUMuz8mJUYnQ
	gU6Fox7QLtLDrEOn7vR+yM5QmbinxSaWAFX6a7EDKRYHWQxyxd6DZb/B6xmnPMFDUQgZZzQN3RQ
	+DUyaqjAeWWxnMr/HnU8Am0C++ULBTtw7IAy6BnHsDrv11BegYreU6ZUPiZ84CJyuyOk3m2BCZh
	6a6JYdAOWZmI8kMF7yU9UoVGNzinMlVect6u1JmCdzOwffefIQgeVRPtZtHmI/Wr54PtoE96QKC
	R2KqTZUHCsaDOnCLAYnDLBr0vl7ZDGXNVg151uWBVm/fIQX5Twag2Zdph2vSufhfHa8juTnUTQQ
	MEeYwBOfflKyH8wKjZvv0aMLcDfAkJgNyFJAxBxqj3LFaEx/TDxvGeKCUg1X1bVkIGX5wDPpd0p
	k2NY1Q35oXgaxs+KW+XynrFsQ==
X-Received: by 2002:a17:90b:586c:b0:398:a2ed:7b5c with SMTP id 98e67ed59e1d1-39b2623ef65mr8977929a91.24.1788518944271;
        Fri, 04 Sep 2026 03:49:04 -0700 (PDT)
Received: from volcano9f6e-hostos.amd.com ([165.204.217.251])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3339af25062sm8583927eec.16.2026.09.04.03.49.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2026 03:49:03 -0700 (PDT)
From: Hemanth Selam <hemanth.selam@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>,
	Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-arch@vger.kernel.org
Subject: [PATCH 1/5] asm-generic: fix typo "explicity" in comment
Date: Fri,  4 Sep 2026 16:18:46 +0530
Message-ID: <20260904104854.25272-2-hemanth.selam@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20260904104854.25272-1-hemanth.selam@gmail.com>
References: <20260904104854.25272-1-hemanth.selam@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: ympc4p8rc85b4xjwzt7ksqwzyqm33gkx
X-Rspamd-Queue-Id: 8741914000C
X-HE-Tag: 1788518945-336006
X-HE-Meta: U2FsdGVkX1/TMA5GsECBPmHWnJGgZE4k32mjE5OiFf/uJXH8uqyaDS75T2qNP7z6TOSxYg1Q3ow6P8oOcmWaZwqo6un4snlIQrq0ylw1Msl+tQISKw+PktSM8u+2Osdsglo7qlkFgT0OxyKexAMV0TpzUpCY7pn3jnUP1Fo5CJ0nWRWSC6IrEKOw47W94rbIIV8b8sLEyMin5Vi4jk7BA0YbK4NZLj0Ja4hGpcE0a58g/iSEfb9LSJNZEnP8T0jRD5pqP/g5bXJmxMkGJgaUry0YaHfcFdCNeuAHabto36POC41x97pUbPBdE5uNw9Y+vxOfO0oTo9H78pCeMOisK3njBhAIyuS2jpljI0jZiH2D3/BMJD5g4tTV1SHEr/sYjX2bQhityoPCWPKtb1UJBlZ17vfU/21dt/zWOX9SXYKRHTsSWBtdyGRq4XKazHELq9aHdCsXqqoxDRFVguwpP5pFmPv44obDS9wKO6BRbeJJZCCOQ52OqMv12qKe0pJZhgbhFcBFV03Ser/JNchXrz/NtwqvxPn+07i1c5RXmTn6vAvBcAnn/o4vK2Unf6bLcJDPcJENhGcuEH5IZJDsJ/xPc5j+RQ0D5rQH+o1D8NKrO9l4rOvskK/uabd1fdRPe9zRT36ySGdIFIFdX+dLylje0NODsvFVTVDly+foUjc01gS0AvkJLDAnM6Zw6GG/i+xaHEeH46vy0MsXf1xXl4ciLLT4fuNFJoCAUQfz9OgaYSXZemZYCCuI0r+6vBii8iSQOeQjQFP0uniP2co88hPNKgVPIV+cMic4NQHGVbj6/TpNyy3GQGflHqEGkHqpMbKIcwojaKA5x963nnKOrAGzRU7ZuObcnLIjx4Honlq+XNU5XC7SIhwV+Gj7z9OuDN9nWmvbBj/DQMGLqZ2VCZAGKUIdfcqFBTG/VCQqTo77yftATaVnmliDcpXi+F2Bp3lALFIBqi7qFJTfcWU
 DlYFUyY2
 7/7Tu1BLLLAPNRgqZDDu0H3qSgTAWZTOO9yBbgCYeX4/OcAQBwQlKTP5cPjwhDTPt7Agb5ZdTNEWSCBNSwtmWH5Vn9MDCMLTTa5y1H2+0zkeqGY4K/Vf6uQhPcO/8DRFdF4+lyaE64u7XRxGaqartvvi1cIlHFfQSJJfixSbwK7feSERLbjg/Drh2VpX3cal2cUN1vO9kqB4PWuG6MRak6omkcEIIyuUVHJGndrb7FYDTeCjVPDPGGHJhE3X0C7iV30TtTNjogQ339TbcUBcp0wv0RTqT0fOFb4DuDtstIPXinUx9hj2NmDsSVaA2iLS2b2KZxJN0M9GooLzJwcvMnN4BhSc5PkXrj8PKxAxu8GWlxMzPktXoR/UEVnZsHDuVr0/OLmvngjuafvhTSE2kHZw6o40NTu2R+rEIrk9dcm/barZmv3in0Yw8zuRwAkX4F8mJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Correct "explicity" to "Explicitly", reported by scripts/checkpatch.pl
using the misspelling list in scripts/spelling.txt.  Only touches comments,
no code changes.

Assisted-by: Cursor:claude-opus-5
Signed-off-by: Hemanth Selam <hemanth.selam@gmail.com>
---
 include/uapi/asm-generic/mman-common.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/asm-generic/mman-common.h b/include/uapi/asm-generic/mman-common.h
index ef1c27fa3c57..cf1418649b3a 100644
--- a/include/uapi/asm-generic/mman-common.h
+++ b/include/uapi/asm-generic/mman-common.h
@@ -62,7 +62,7 @@
 #define MADV_HUGEPAGE	14		/* Worth backing with hugepages */
 #define MADV_NOHUGEPAGE	15		/* Not worth backing with hugepages */
 
-#define MADV_DONTDUMP   16		/* Explicity exclude from the core dump,
+#define MADV_DONTDUMP   16		/* Explicitly exclude from the core dump,
 					   overrides the coredump filter bits */
 #define MADV_DODUMP	17		/* Clear the MADV_DONTDUMP flag */
 
-- 
2.48.1


