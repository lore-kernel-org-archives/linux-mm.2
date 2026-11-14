Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4233D606A334
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 16:47:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zte.com.cn header.i=@zte.com.cn header.a=rsa-sha256 header.s=z202610 header.b=LL8G6jJw
Received: by kanga.kvack.org (Postfix)
	id B4E7E6B05B2; Sat, 14 Nov 2026 11:47:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B262B6B05B3; Sat, 14 Nov 2026 11:47:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A3BC16B05B4; Sat, 14 Nov 2026 11:47:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 83DC66B05B2
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 11:47:15 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0690AC0493
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 16:47:15 +0000 (UTC)
X-FDA: 85434304830.05.D050A70
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.35])
	by imf17.hostedemail.com (Postfix) with ESMTP id E0EA140007
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 16:47:12 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=zte.com.cn header.s=z202610 header.b=LL8G6jJw;
	spf=pass (imf17.hostedemail.com: domain of shao.mingyin@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=shao.mingyin@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794674833;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=LZpf/adSy9ocw600/0V3SwHUEucAcfipA+77w71wXy8=;
	b=W6ygalXfkG7W/5iNJP8QooCxDItUkiCn9FVPi4iQ7ylr0rda5RzxEJN3zMVdCx45Mi+3cB
	H7JAZATZOfbT7fRnZg9bJz2gdHhDFyNYvgGggUNm6eamg8WRVlaEsY4vGJhU2X4TQix4C1
	kteCpCCyV3yUuETQ1/GxnS6k7AiPLa8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794674833;
	b=LbK9ciO1pUeHH/0i+cZwbUKC8yarSVcbbR0SvDzN+KbgcHGW0vQ5JtWx9o9WbZqP16WJMc
	lf8/tnDOIUgPPE5kt/GEfex+BlIKAVfHkxFp/0gsBhktRmpPDQRR1s80UJIxD1qo/miVc+
	KuEV0r7XnZifAvcN1J7t7mFceBn8dY0=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=zte.com.cn header.s=z202610 header.b=LL8G6jJw;
	spf=pass (imf17.hostedemail.com: domain of shao.mingyin@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=shao.mingyin@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4jRg5V300hz8XrrX;
	Sun, 15 Nov 2026 00:47:10 +0800 (CST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=zte.com.cn;
	s=z202610; t=1794674830;
	bh=9sHLtCdxrf347MxSpppWO9QY//hLaaMU4oq/GvKgpMk=;
	h=Date:From:To:Cc:Subject;
	b=LL8G6jJwlh1wVfxwOfVZYifI5M7QhkZkO2rQGwiwnN3j+IinmNFXyTjMbpStmfr1e
	 0HJDNIn4CZ4BWpvcIMunyYjBLW0HF+2BDmKyDTy1AOYdgI2jsyuU6nT27nS9lYnqAU
	 wX0rqs0gLbp9uu8abFyBBpeAjOk5oFhfipBmk4iATt7EZWctMXsHWsRk8CoT8h/2DW
	 Zr0GxCm/z7f+kuKrnzX7b+0I1dslR7LaIB4W6HKAogb6tQ/7PwCkNUbGsXqrNhq/VV
	 0vfGLZkiQuJtRM8EPsb917/UPZmlLhBjkBN60JRLUi4y2TxrkoRv5i1UQeeTibJf84
	 04n5r8zVtYlUw==
Received: from xaxapp04.zte.com.cn ([10.99.98.157])
	by mse-fl1.zte.com.cn with SMTP id 6AEGkw4D089601;
	Sun, 15 Nov 2026 00:46:58 +0800 (+08)
	(envelope-from shao.mingyin@zte.com.cn)
Received: from mapi (xaxapp02[null])
	by mapi (Zmail) with MAPI id mid32;
	Sun, 15 Nov 2026 00:47:02 +0800 (CST)
X-Zmail-TransId: 2afa6af89086dfe-30dce
X-Mailer: Zmail v1.0
Message-ID: <20261115004702358r2RJLihSrqbK4dr026bcI@zte.com.cn>
Date: Sun, 15 Nov 2026 00:47:02 +0800 (CST)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
From: <shao.mingyin@zte.com.cn>
To: <catalin.marinas@arm.com>, <akpm@linux-foundation.org>
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: =?UTF-8?B?W1BBVENIXSBtbS9rbWVtbGVhazogZml4IHNjYW4gcGVyaW9kIHRydW5jYXRpb24gb24gMzItYml0IHBsYXRmb3Jtcw==?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 6AEGkw4D089601
X-TLS: YES
X-ENVELOPE-SENDER: shao.mingyin@zte.com.cn
X-SOURCE-IP: 10.5.228.132 unknown Sun, 15 Nov 2026 00:47:10 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6AF8908E.001/4jRg5V300hz8XrrX
X-Stat-Signature: jqxaku1uaf3jm9hgp8wnffrhfkh5bem8
X-Rspamd-Queue-Id: E0EA140007
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1794674832-600744
X-HE-Meta: U2FsdGVkX1/Zp3jaI9UaBKH8qrn3pl91dPzpdeUTLHSokDLEjK9YxsI32DQiaVakMM4juxwUYf+q7vivXQc9TZTqg36U0j4/tkajqSrGgkg3J51Wrwa/tLb/Uvyz5WuB6j80z3GnbCqV9qAfNZukGoYBufL7zgniimUXcvw6aP9GMMYSQGiGoKmfYzVD6woKgbRhO7izE4WAXR25uu5EZQKL5kz1yPfNA7R5dMwQ/D3z2TpJVS0N3wGQ99rataDXpWzvmy4wZtQks5vE53sXnuShTE+NGeme/020GZwTRd3XVjOefIogEs9lsMa8NxJj7ZJ12eTaUAqRekH6ygjrUwQ2pMXZHD5chl//YHU8uM156AC69WSYKlBCe6rxz1i+4zgm6A3i6xfG7J2IUTrd+AdjmHh9wvpIsA4sNFdFWJ0y7rfE9Bww1p3bQNUimT5k2ayQPHO9lW6UFN9ubKBDhnRvxmX22npIf3muL2Gwx/up0bAAPI0hmtLNlf3qKTVC9gsK8V0dgRFrRGxFm7FTePwXBhDGRfVFiG4BPwY7l26NMvXIzQYBK6BEpM8fg4dbSTrWvWuLVyXsp8zjdGaV1qprpnWe9RIWSPkv9KysXaX7iAERAi9PPKsSeQBkcoG+29g/SX5L64pJdDp59opUoxEyj+d89XQ/tJxtNaL4uCS3Um0TauuJpDZZ2HFRZh3jAhPHcPJtgPhYbV8W29VzpufZ3OVmJIgrOR8+bWnk2zQJ9llWDRlFJacsMb1HI5jAEA8Et5pSv6nQzlMwpesOe+RePumwZ/ROF1rRavynzSITcabQfLkWtYak3Srgt56M1KY6Sdtk6AL/o2BlxW1bXlgyqbS7o8qxtMUoysdzOT+YcFiiwcS88wSnLVtieGwcZNahJTBwiwY++eLdhjCskku930W2tnoDCxI3+iEdGZiJjmZ6gWLfgO2/YvH2SNRhfTr8ipluunlyYOcvs0x
 BJu2hQ9v
 AKewpoAYLomZcN+3Dv9MvesWQLGUQnJngGM1etUl1FN19vaLHpx1ClUzqiwC4atPR1BHaUnoEei4cuUKNWJA5mK9sbaSUBcMhWcMvm5arocSg9oJbQzeyPQuxrnG/14dnRLab4+kXZt28GWiv3JiC/HMBSKf431hUeOhCkpRqI/9K5Kz3ArlVvnma4jffZ8tbktMbTDK4UKKmpXR6xzHuRTK/Z3oUnBhVMnlhGH1GhmOxx7mHKxPVwnqQNtYBrJ4xsO41vBb2Q0es9phgOVFy1qIqbmpFskz/DNrOLa5z69QpalguzDlJBULGenZg3my5JeGu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Shao Mingyin <shao.mingyin@zte.com.cn>

mm/kmemleak: fix scan period truncation on 32-bit platforms

kmemleak_write() converts the scan period from seconds to milliseconds
before clamping it to UINT_MAX. On 32-bit kernels, unsigned secs and
MSEC_PER_SEC (1000L) are multiplied in a 32-bit unsigned type. The result
wraps before the clamp can detect overflow.

For example, scan=4294968 produces 704 milliseconds instead of the
UINT_MAX millisecond limit. Perform the multiplication and keep the
intermediate result in unsigned long long, preserving the existing
64-bit behavior and the later msecs_to_jiffies() clamping.

Commit 54dd200c5a25 ("mm/kmemleak: fix possible wrong memory scanning
period") added this clamp, but it cannot work after a 32-bit multiply
has already overflowed.

Signed-off-by: Shao Mingyin <shao.mingyin@zte.com.cn>
---
Build-tested mm/kmemleak.o with W=1 on x86_64 and i386. A freestanding
i386 program checked six inputs, including scan=4294968: the old
arithmetic yields 704 ms and the new arithmetic clamps to UINT_MAX.
This is an arithmetic test, not a kmemleak scanner runtime measurement.


 mm/kmemleak.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index 1bca27787df6256d89b54fc3381ca5abb49ac7a6..87274591257f6655655ba5bdd0381f3a38c9404e 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -2455,13 +2455,13 @@ static ssize_t kmemleak_write(struct file *file, const char __user *user_buf,
 		stop_scan_thread();
 	else if (strncmp(buf, "scan=", 5) == 0) {
 		unsigned secs;
-		unsigned long msecs;
+		unsigned long long msecs;
 
 		ret = kstrtouint(buf + 5, 0, &secs);
 		if (ret < 0)
 			goto out;
 
-		msecs = secs * MSEC_PER_SEC;
+		msecs = (unsigned long long)secs * MSEC_PER_SEC;
 		if (msecs > UINT_MAX)
 			msecs = UINT_MAX;
 

base-commit: 84abb955b1015477aa11a96e2f3ac1b938b77f48
-- 
2.43.0

