Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C16DBC9832F
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 08:16:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C29A66B0092; Mon, 28 Sep 2026 04:16:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C014D6B0098; Mon, 28 Sep 2026 04:16:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1DD46B0092; Mon, 28 Sep 2026 04:16:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8A4E86B0092
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 04:16:13 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1C1A7A0135
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 08:16:13 +0000 (UTC)
X-FDA: 85262463426.03.427373C
Received: from mta1.migadu.com (out-238.mta1.migadu.com [95.215.58.238])
	by imf16.hostedemail.com (Postfix) with ESMTP id 1087E180006
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 08:16:10 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=q7EnVjPG;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf16.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.238 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790583371;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hctX/mdgTSlb9MzYkRKkR+yanLYBHuXFvc/9HELDaoU=;
	b=ccsqwYbmpQxzGXaFdSnVNXchkjf1fdWxkcjMClg+5am+2c66o2Ll1lJOM+JPubz6saQ2UO
	5yDJtPfTtJnwnKwyXkXIrqSjXgnbGh+UPMY9VfYxpLUXdMMQWko9nqX37cuRX5fNzT2DL1
	IdkFj5ppZBqtrcUcDjo2mFBOp0yYTlg=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=q7EnVjPG;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf16.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.238 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790583371;
	b=dpo5oVweJvsRDqm9D/1o9OirVJf57e40HK2F1hoq8+AdkmA0TM/iGMBHykWLkWRJGLicxx
	kXHMsaOu+VLkvvtNfP0nqaKxCvHDQR4GJQEthrUsMsLW3VamuWtX8uv8qEx+VW8udLC3up
	l70vlCjVzzXNrVnPyydKLhURdEuZCHw=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=VMcXVA6Q//nucy9IuPEO+cpUVY2addflHX+2AAjGN8s=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790583369; v=1; x=1791188169;
 b=q7EnVjPGsA2MPgdvy4SRmdL6nLfeABvwkDrtR7Bkx7AXEyA1csFUVqkM6q9wKM56NbLhqDt5
 p8JhBZtzUaZiR09kx6orWO2yi/cNRYbqWEwmh+bk9qyDPA9gs1pDipcoPtp1XFYa3s+GypHFg4A
 1PaLf8wbjsTN8MO6zWVpexcM=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 954cb9b4744235b9;
	Mon, 28 Sep 2026 08:16:09 +0000
X-Mizu-Trace-ID: 954cb9b4744235b9
X-Migadu-Flow: FLOW_OUT
From: Ye Liu <ye.liu@linux.dev>
Date: Mon, 28 Sep 2026 16:15:54 +0800
Subject: [PATCH v4 1/2] mm/vmalloc: fix vmalloc_dump_obj address alignment
 for last-page lookups
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260928-vmalloc_dump_obj-v4-1-6f288a431edc@linux.dev>
References: <20260928-vmalloc_dump_obj-v4-0-6f288a431edc@linux.dev>
In-Reply-To: <20260928-vmalloc_dump_obj-v4-0-6f288a431edc@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Uladzislau Rezki <urezki@gmail.com>, Paul Walmsley <pjw@kernel.org>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
 Alexandre Ghiti <alex@ghiti.fr>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-riscv@lists.infradead.org, Ye Liu <liuye@kylinos.cn>
X-Mailer: b4 0.14.3
X-Stat-Signature: 6r4gjczjig1ksb5cfzpgrqm98ik8ctxf
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 1087E180006
X-HE-Tag: 1790583370-800206
X-HE-Meta: U2FsdGVkX1/hwrcfjPXLPXsm1F7cRT42ysGI9GTUXpwcLNkdyqFJBYEwPJOgt4Deb7JL0gPxIbPlvVk0bO9scDjPDjS8PA2LXgP5rYv7ItY1Ebb8BdYBwt1q8rLeCND7gPaK3gFcSFa/cLGAbomQrKjnRl+JTKDRISGe3s++1vtZ9hZzJYGF0ZXMJy3GmCjLk0shivaJrTdxlvXc0SGqXkSh6JJRvFPo++kbSbw5E3W57hulMMX7Ib2a+bwvP2a1/aY3+bxvX/2UZq8nsZ/w2Y9Xfxvf9RUlWFaZ0xUqMT4ZCCFeN2THJyAGkBYqxV0xtrjrvo/Unlcb/VQ44gWE2U68RDvbWnXXmvwvGtVl/4Sm68XKsPa2fjIDYmPfoHJTIObblPIzuWT3wnOMYXYiP8jRrifZYYUUKH6IX+G6zsejOXWkDldy174aw0x4UlMFY3ODrhg3ILcFwfL8Lav6OnnP/rmBXu7kkB+zEXFJAyLzO09JOB1Z5vBCqBbgtcmp9sWX8BGXEtR9hkhkGeFEDwlvi3aqMDss/+S6DjlRPLj7bQd+nKmpUgZcIjPonirO0wnz7e3imhlyUDhm8uC08S6KIveHDzhOwSGx3OaxyxWq7mvFrmlclpyADExJz6n/egtWDL7MPfRR86+3DvIy/NGBOVLUxA7P4ASBs3HtmHnDkzPmTBcA6Dvdk+x/iZtlj9FDHxMU9b/ZgItvvh4Y9BJ60j25sEBJ/yyBSah42fFcLOwshhLwvEBkwwjdaBGOEoeF4S+zIWuNoQ2UvqT4Oe9Bd5h+ex7oermKaxGv3QqaAdeOZxNOyk86Q4UnDhvRH6N9S+NMe86vq2NbyCLSMGzhym+HI1WdApyAGJ5ieW4A4XFyQ7CEw3RG4RCnDrHgw1SCBeHg1Pt1i7kDpdtSQTZNpwcHI7aVbh0LNNsq0VCxUOmEm3lelzy1zLF2NQnDF/P+T2EimUBWu+2oW9D
 WbRlM8Zm
 wMKo7xDurLnf/hL9yBOtp/CX9Xn8ilMj68gf0iREgH3dEszTOkRMVL3M0Av1Q0w3b9iW4Syv3ntJfegTPumzXD4+VL/vNJK98+qrBeQLiGda0jowHyfdf0ThST8J7174tvOyXxIkNszYfLmg7e/6UnY8U2Et4BzrYZuOWRaKwQPyMRG1uzvhReFCRYk+zmJcbaNId/EU5TvPVnPKc3Wb/3UngFbaSFYu7J2HwIX6WrZ6aXHeNhHu782mAwI2rhWeXMWtXfwmw5ACXRhIZPKIAh60vwMKKXW+KmSCU33NBIxQZ9Zh3s8MUAVkIWg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ye Liu <liuye@kylinos.cn>

vmalloc_dump_obj() uses PAGE_ALIGN() to normalize the input address
before looking it up in the per-node busy tree.  PAGE_ALIGN() rounds
up, which can push an address in the last page of a vmalloc allocation
to va_end -- outside the [va_start, va_end) range that
__find_vmap_area() searches.  This causes the lookup to miss the VA
and return false, degrading diagnostic output in OOM dumps and KASAN
reports to the less informative "vmalloc memory" fallback.

The upward alignment can also change the addr_to_node() mapping when
the page boundary crosses a vmap zone boundary, causing the search to
hit the wrong node entirely.

Use PAGE_ALIGN_DOWN() instead, which rounds down to the page
containing the address.  This keeps the address within the VA range
and preserves the correct node mapping.

Signed-off-by: Ye Liu <liuye@kylinos.cn>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
---
 mm/vmalloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 859e6d2d57a3..df42d8a6f058 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -5277,7 +5277,7 @@ bool vmalloc_dump_obj(void *object)
 	unsigned long addr;
 	unsigned long nr_pages;
 
-	addr = PAGE_ALIGN((unsigned long) object);
+	addr = PAGE_ALIGN_DOWN((unsigned long) object);
 	vn = addr_to_node(addr);
 
 	if (!spin_trylock(&vn->busy.lock))

-- 
2.25.1


