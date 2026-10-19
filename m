Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 938CDCCF2D4
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 01:58:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A702F6B00DB; Sun, 18 Oct 2026 21:58:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A47B36B00DC; Sun, 18 Oct 2026 21:58:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 95E916B00DD; Sun, 18 Oct 2026 21:58:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6B6F16B00DB
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 21:58:44 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5CE99C0390
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 01:58:43 +0000 (UTC)
X-FDA: 85337716926.30.4CB83FF
Received: from mail-dl1-f51.google.com (mail-dl1-f51.google.com [74.125.82.51])
	by imf30.hostedemail.com (Postfix) with ESMTP id 82E7A80006
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 01:58:41 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=FeVibZGp;
	spf=pass (imf30.hostedemail.com: domain of odys.yuan@gmail.com designates 74.125.82.51 as permitted sender) smtp.mailfrom=odys.yuan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792375121;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eX3gFXGtK0qFC1+jmqNQ0ZBmFVgyc6CU75RzS6mT9B0=;
	b=sa+1oP3KjYcgpeyh1CstmTsBopaD7ruGRu5c0NT1imk5fCF5X2357bx9ABbtohAnAfj8jv
	V7GoCfN53xaqehnzHJUjY15JjjbR55hbCqv8OAM6nTZZbigyWvKIaIKPN2w7ZnGS+SPgU5
	ESLhvlw2p2CN4fTd3NegZZfaxiFqTSw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792375121;
	b=KXgoWjfojg9zVlNf37ncLbO8EXiEuHRLRcLJaKVkC6dAexMaXhvImthhq4S7taJhPJ5nGt
	V4lUqmeqxhuGwsV/X5pusAb1HfiSUDrLJoSbnTV11ltBqONuY/1/DFwz5W+7vmpuVyzqG3
	pXLhH/F7taYXp5kcIOhsnlYFsKre/aU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=FeVibZGp;
	spf=pass (imf30.hostedemail.com: domain of odys.yuan@gmail.com designates 74.125.82.51 as permitted sender) smtp.mailfrom=odys.yuan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dl1-f51.google.com with SMTP id a92af1059eb24-15168a20b47so505970c88.1
        for <linux-mm@kvack.org>; Sun, 18 Oct 2026 18:58:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792375120; x=1792979920; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=eX3gFXGtK0qFC1+jmqNQ0ZBmFVgyc6CU75RzS6mT9B0=;
        b=FeVibZGpBUbsAgNOQsb1LYKDMoMwWh5AzJI1p3EFVH2OCyV1gRHdLWpIHBSYIel8ck
         Nsx943b2QxsrIQnc71Gqss3veM4DeIdeTxycfPgC5jBBWawyBngXfQVr4fim4EWeVPZs
         8bW9Er+qeRRdojF/9iOn82evEnhU25eVauhFuErPkQUOvE6yahD5Lw0ING8/4W5++hls
         dZKqvI1wFHx46s1So24KyCsUHHUmiPU5eqYojPfkxcKvBG2W9dO4Yr4VDOHJrRYhe5Z5
         hMIepGIoOcT+/VDfAjXvEMx5j+eeQvpekW4Ip5FyZHHDE118OpPQZsH+G1Cc/I2GPazd
         KUmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792375120; x=1792979920;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=eX3gFXGtK0qFC1+jmqNQ0ZBmFVgyc6CU75RzS6mT9B0=;
        b=G/BTa1kaFJ4WnWYlagNxeAtQeeUlG6XE6pJ7qrjBhfWxkqFIpWn6cXJ3exlePnwyzN
         o/xIqgbd7hNahnYh2cGF4nQ2cRhAIw8B8rg/9L9/q7S/4hLwzTNYmuwM1n94MJn1+CAB
         I7JAI7Jz69nbh8gH4K2gKyz5uKOVDNlFcq/Ua3lWgnja9kDvcYBUpRZd3kZ3yp6g4ZE/
         xm591jqSJpTddT2fLnXk0ti8RUSES3XFnnhKRfL6mQzkM/bLiteEM9Qnlbp6d2W4bjcT
         TZzmW5BRIpiBv6LaZ6+4NORgbvWNR5z7Sl2J4bqgGPmFJKQybCOiD9tWeSaS4EpeE7jg
         Brpg==
X-Forwarded-Encrypted: i=1; AKwUvBwjzqjwjavl32w1RGkKT0WgBVfHiuhtCv3L8VwbYaSPsj9zNhnGLLVOGqCyez+/oD3bUXetB9KbsA==@kvack.org
X-Gm-Message-State: AFq9FYJHT5lZQFHfc5IyB17ZATja5oHK05o+1nJFs/IHtI+qrlImzmDV
	c07/G8zbDp4yAxj5U1Pocr188QXJ8kGu20h8BT1m8OF9rlvDyjkk6JgA
X-Gm-Gg: AYBFou32c/TrEFkfIXG9Iy1bUOUzO+Ixs0m7/zbV47tea/3/FQ2r3IuG0QEosvPTETT
	8SakRPiVktdr8GJmeD4Ar52QiqwKd9SLmGRvR2Q04F0Vk0gZB/qqH+i5UkJEg2uv7Q//dZBz8im
	DSxo0HoXxkamy3ELjLOWwk4RcOBRKkp5KBHS4Ua7qMun6V9m5cw1Tj/eg5uM3GFu09QqNdDEyTx
	q6el1q3hyX9KYPHsclZxseNbfQpvyMjSR/KMrv+tsi/n5If9mMJa1ue72Vu1mcHSgWOtOizVDlL
	9JbL7Trc7HT+1s0+Kl+FndA/o3KP5N5xwQxBOosR5EHRDhVuZVHZguOttXvRQsFOw/You1FllLr
	3TU/66VwMuwmhXYYw9gWikdC8AHNSU8Vil1P55hgz9ydui5/ajvkuJ/oO2XO7r/nTXbin8LRXm3
	7NeaHPvxDx90fZt7jP2rYOJJ0KhRka5v746EIoSMyu905h192XgK1MIQ19wlhB7Eo0rg==
X-Received: by 2002:a05:7022:b057:20b0:18a:d0b5:fa42 with SMTP id a92af1059eb24-18ad0b5ffc8mr1432273c88.19.1792375119985;
        Sun, 18 Oct 2026 18:58:39 -0700 (PDT)
Received: from [127.0.1.1] ([23.254.208.9])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1831ba424a6sm24177311c88.17.2026.10.18.18.58.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Oct 2026 18:58:39 -0700 (PDT)
From: Qiliang Yuan <odys.yuan@gmail.com>
Date: Mon, 19 Oct 2026 09:58:10 +0800
Subject: [PATCH 2/2] kasan/test: cover load_unaligned_zeropad()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261019-bug-word-at-a-time-zeropad-kasan-v1-2-f21a3ed6a477@gmail.com>
References: <20261019-bug-word-at-a-time-zeropad-kasan-v1-0-f21a3ed6a477@gmail.com>
In-Reply-To: <20261019-bug-word-at-a-time-zeropad-kasan-v1-0-f21a3ed6a477@gmail.com>
To: Russell King <linux@armlinux.org.uk>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Mark Rutland <mark.rutland@arm.com>, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, 
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, 
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
 Shrikanth Hegde <sshegde@linux.ibm.com>, Paul Walmsley <pjw@kernel.org>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
 Alexandre Ghiti <alex@ghiti.fr>, Heiko Carstens <hca@linux.ibm.com>, 
 Vasily Gorbik <gor@linux.ibm.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, 
 Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Sven Schnelle <svens@linux.ibm.com>, Thomas Gleixner <tglx@kernel.org>, 
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
 "H. Peter Anvin" <hpa@zytor.com>, Shuah Khan <shuah@kernel.org>, 
 Marco Elver <elver@google.com>, Andrey Ryabinin <ryabinin.a.a@gmail.com>, 
 Alexander Potapenko <glider@google.com>, 
 Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, 
 Vincenzo Frascino <vincenzo.frascino@arm.com>, 
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-arm-kernel@lists.infradead.org, Kees Cook <kees@kernel.org>, 
 linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org, 
 linux-s390@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 kasan-dev@googlegroups.com, linux-mm@kvack.org, 
 Qiliang Yuan <odys.yuan@gmail.com>
X-Mailer: b4 0.13.0
X-Stat-Signature: sz7t4gqj5wukk784btszzi6461o11tap
X-Rspam-User: 
X-Rspamd-Queue-Id: 82E7A80006
X-Rspamd-Server: rspam10
X-HE-Tag: 1792375121-999827
X-HE-Meta: U2FsdGVkX1/kW/eqzMNAuwJKCccpI2rPscMduOebVXTKpUNAnziQ8tWPAXedBdIlF21h0S7XRZDP+KwvRjwWhj+LQ08tQWeCogPWxrBG0+QHXHM9EuLpcuZZQRhR7EqyCi9/eq6PlDUhqfSAsXwIoAqH2ZyRsSu+af8nszsQkUaCXJzYLINzeP6rbeHATN8J/JTxluMUomAL6DW6xjsAIPJV+m/H3xRtfq5rteQB8TsZf46MZHEGfjE8HfPKojmTnuvgCEmefg+bHoSjaTynOUz7c3LTHm0gWzhWdNxRzBfuGNZ98gPFBnSg9/2+x1FJGXXWInz8Jh3tORnYbhWx9uxrcclDTqYFYlBcRkrAWIql04Z/RU0/YasxC/GgpvdVC4qMgK4oyl31FFsOeqe1G8O+7fw0ISMvTqaao2V9eG8HAnyPORAC+tTJXmjkH3kBS/qptNtgPX0v11T7J0DuczpTQrv+HgymisC3SPSVaDBzSQZrderpfThM0cLBy9c25Dikbu+wQWii5ZWIpUV6WEZTibuR1z8GAejjVaEEi+K8zh/I9jLQPVv1g2JguFPHxxxvIKMaHkI4E2Mkju42GTMUBAFiGG1TDbcoTbTDM9pgDW1KaRobRmf6MwV3VfhGTsPevlJk4Mm5LBg/OOrYgFDMh07ZDIKVUSQjyKk78FMLkb0SveKPGoRb44iLmL938sBCZMZztgRqjDxcjAWOAs8/yRwEzHVwC/o29S3EiMMJwTSnSgVON2ivm4NovmU046Egc8jpu+KVxGjtXrAd7HEudlq7k1rjfKRDHWayGhUGQ6BStoyxrPEXDXlVNOAKFV+nGDAI2HmWEEO921CTZ8ZuYD/HiieFdsSQxZzX1Vxv/3bxIN7WsV1LCqXmexF+M8csTnvYwHLoUdjJq0XRwaBrz7dTCLs4sW6zF0gtlqDaNde7WM1PAmmMUEYUif73b/1Gtpje1zHQiD6Oqcg
 ujBE8kY0
 61P7jh8IgOC98ydW3h9FM2Ylf+u7zT9ss56xgepOaYF1/WFUi91WGr0BNwU8rElrCqZh9ucR60YhfDjVUAiU3MVyYrdpY6J0ZjOOFnQmZbIP+Cw9yeaDLxhNgm0KMxxkeofZOqb3yleky94d6wHZcxEpS5YpRPCoFqjvOToiaFnQq1KPO/n3lm5CAOt3nmA+Q7KYdyxiKivhSQP9n1qW04Fa04MT9ywG+0pImManQULOkOg11qQtlliUAvvwgyp7Aw4y0ZjYd8JRPWDZyoL5a38Fc6HASpi7koONwaoO/2tgyhQF1902m62MgQTETxTaJ5UEMTG0Upi7Vg7LPetzPLG4DTjyRU+T3rKWZOTI2Pq0UxaiFi2HCGv+Kj4HmwYe1yHOt3eX4f0Be+nRgUqmlngY7alLB815SVFcljwX8wDRz+HKVK7y34YJMzoPbQ+FOQ/Dl5aBfYWBDa/ivg/3wJwPPwvRcwOfckgXk7GKEaocSm0a7MmApqAeoLot0ojFXjR6KrovnRa6oDr96ugnRZQlaG+ORIPV6Bkw7pq7O4NrZgD/Vwrw3K6JOr7cq36GbjKMsJMByrb35U88=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On architectures with CONFIG_DCACHE_WORD_ACCESS, load_unaligned_zeropad()
does the word loads of the dcache name compare and of path name
hashing.

None of the KASAN test cases reads memory through it, so nothing
noticed that KASAN did not check these loads at all.

Add a case that reads a freed object through load_unaligned_zeropad()
and expects a report. Skip it with hardware tag-based KASAN, since
arm64 turns tag checking off for this load:

  kasan_load_unaligned_zeropad, x86_64, generic KASAN
  without "word-at-a-time: check the first byte in
  load_unaligned_zeropad()"                                 FAILED
  with it                                                   PASSED

Signed-off-by: Qiliang Yuan <odys.yuan@gmail.com>
---
 mm/kasan/kasan_test_c.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/mm/kasan/kasan_test_c.c b/mm/kasan/kasan_test_c.c
index b9e167ed5be32..c791512f6fc49 100644
--- a/mm/kasan/kasan_test_c.c
+++ b/mm/kasan/kasan_test_c.c
@@ -28,6 +28,9 @@
 #include <trace/events/printk.h>
 
 #include <asm/page.h>
+#ifdef CONFIG_DCACHE_WORD_ACCESS
+#include <asm/word-at-a-time.h>
+#endif
 
 #include "kasan.h"
 
@@ -1673,6 +1676,26 @@ static void kasan_memcmp(struct kunit *test)
 	kfree(ptr);
 }
 
+static void kasan_load_unaligned_zeropad(struct kunit *test)
+{
+#ifdef CONFIG_DCACHE_WORD_ACCESS
+	char *ptr;
+
+	/* The tag check is turned off for this load on arm64 with MTE. */
+	KASAN_TEST_NEEDS_CONFIG_OFF(test, CONFIG_KASAN_HW_TAGS);
+
+	ptr = kmalloc(64, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
+	kfree(ptr);
+
+	OPTIMIZER_HIDE_VAR(ptr);
+	KUNIT_EXPECT_KASAN_FAIL_READ(test,
+		kasan_int_result = load_unaligned_zeropad(ptr));
+#else
+	kunit_skip(test, "Test requires CONFIG_DCACHE_WORD_ACCESS=y");
+#endif
+}
+
 static void kasan_strings(struct kunit *test)
 {
 	char *ptr;
@@ -2264,6 +2287,7 @@ static struct kunit_case kasan_kunit_test_cases[] = {
 	KUNIT_CASE(kasan_alloca_oob_right),
 	KUNIT_CASE(kasan_memchr),
 	KUNIT_CASE(kasan_memcmp),
+	KUNIT_CASE(kasan_load_unaligned_zeropad),
 	KUNIT_CASE(kasan_strings),
 	KUNIT_CASE(kasan_bitops_generic),
 	KUNIT_CASE(kasan_bitops_tags),

-- 
2.43.0


