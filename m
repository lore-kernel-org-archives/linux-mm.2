Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0A69C5DF81
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 09:25:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 13E756B009D; Mon, 24 Aug 2026 05:25:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 115A76B009F; Mon, 24 Aug 2026 05:25:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 02BC86B00A0; Mon, 24 Aug 2026 05:25:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D776E6B009D
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 05:25:23 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5D120A36E1
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 09:25:23 +0000 (UTC)
X-FDA: 85135629726.04.AEB1DA7
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	by imf19.hostedemail.com (Postfix) with ESMTP id 8CCF81A0003
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 09:25:20 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=KBoKjoJJ;
	spf=pass (imf19.hostedemail.com: domain of xialonglong2025@163.com designates 117.135.210.5 as permitted sender) smtp.mailfrom=xialonglong2025@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787563521;
	b=l7t3P79GX/uLsfr8L6KZw3zPwA8myWl5EkIo0PCpKMZNvdq3s+a3pwGITR2hWWkwPnIy6e
	g6e3VWMSSA6AlfRiQugW1mgYk97gulz3cMwPpbagnBjbFb9zDaI++H+Z0oo5Ujk3vLVmlA
	Dm/QYDAT2U5VcjDV6nWamcnEpBn3M+M=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=KBoKjoJJ;
	spf=pass (imf19.hostedemail.com: domain of xialonglong2025@163.com designates 117.135.210.5 as permitted sender) smtp.mailfrom=xialonglong2025@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787563521;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=fqyk0M4nQ5HyXJAey1xHXtSz/i6z8jK7G+LbcAImz78=;
	b=d1sULF9JjiF+j2JD1bKO0/7SoHtiPy8XIGw5Kxd5ggy85G2QxTXrldaXaows9JF/rXo+VA
	+mTxpVRf7apsTL+WCNb7BQZlnOERFv1Bb4VRRWUTC8wFKjMlbWXY1TJjoqxtmqnlEX1U9d
	ofUALAP3aODg/q+wltg3vTXqx8QAoBo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=fq
	yk0M4nQ5HyXJAey1xHXtSz/i6z8jK7G+LbcAImz78=; b=KBoKjoJJvXwEhR/N6Q
	a1bJYNGkm9mfhJdCHrJ0nvg1AlHb+cCzYeiYL+1WUEEOVq1H5jAYw3F0jwHIhOnW
	H30lGAn8tqms+Zu2cs+0vFK/jUmflESWDrYAbjouw7GZ7GQOKNMu8L/AGw8PloPh
	BOvOw1w+aSRPk2fLJSC84PELU=
Received: from XLL-9950X.localdomain (unknown [])
	by gzsmtp4 (Coremail) with SMTP id PygvCgCXUibmDYxqi1jwNw--.45078S2;
	Mon, 24 Aug 2026 17:24:55 +0800 (CST)
From: Longlong Xia <xialonglong2025@163.com>
To: vbabka@kernel.org,
	harry@kernel.org,
	akpm@linux-foundation.org
Cc: hao.li@linux.dev,
	cl@gentwo.org,
	rientjes@google.com,
	roman.gushchin@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	xialonglong@kylinos.cn
Subject: [PATCH 1/1] mm/slab_common: reject zero object_size before calculate_alignment
Date: Mon, 24 Aug 2026 17:24:54 +0800
Message-ID: <20260824092454.1693745-1-xialonglong2025@163.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PygvCgCXUibmDYxqi1jwNw--.45078S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7AryfXF1DZw43Cr4kWrW7Arb_yoW8XF13pF
	W8Ka4DXFW0qr17urZFya4kGFWrX3sYyay7Ca98Cw48XrZ8Xw4kJ398KFy5Wry3KFy5Way5
	ZF95Kay09a4UCFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UD739UUUUU=
X-Originating-IP: [39.144.46.203]
X-CM-SenderInfo: x0ldz0pqjo00rjsqjki6rwjhhfrp/xtbC+Ac6M2qMDed6ggAA3C
X-Rspamd-Queue-Id: 8CCF81A0003
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: g6xtaf9dmtwtj8tgboshbxg5j5skt1pr
X-HE-Tag: 1787563520-544178
X-HE-Meta: U2FsdGVkX1+2BaSAEHaHbg1XChB7RXnY7cMO+CpgdeWkbvZhfgi6yNYrYInDAYZLJ2h0I03B86iRHlnDy2z55Z6U0E4AJyABYJhzqNV4OglB4OihpzCMr+kwSpxe4Wx1UNa8rfjKaQg+qnASadnxBe8m1KOrGCR03ihyDrigDQJEWl57SP8SEfnx+7AsVRu15sZvXYgLkGJRb8/4iOyM+ydoyC9M9akO/YDZI9cKcze/021I78jwTg+pk2R4eGK7W5iUKmbkhD2r0GMifGZeQPgOiicBezhFMESOxyzIItcMlbaG1zfCKwyYn0u6tpKaOWRCSpQACQVjzPeZ25RIvQsIzT0Cvpi5azz2/zaZ+BBUJ5nNLYW5iZ6HzvEx6MujOKEvQLm0EAfMCX2rakmaY8G3u/t1amc2bIX3JNCy6fss3aFXKxG1LAtU2lEokadl7qdEo+UV4lMkN/hm5yhZr+0t+ffvGAeanB7apVGdcBSbc1hfbr0LBSIYuD2ZO3cs+Hd2PP2+MknZzc8t84WR4W9LEuTg2IMuZbJ0mg/NjvHL95n1fLLzn8l1uI6pdaYO/9EOGQ5EB90P1TvS+MMAn45mOZhQc97iJt/5Rf1Sy1W5Db+Sb6RUuIfaf2rQuVr6x6tfBU4C82cHxdXq7HVBQ5S03qH10tO7sG6lU4DGPwQNOx1xmY+a2hMcnAi5VlgFH3JFqrNUDiYRFJZeUeaBvvW1moZmMR8N1UEZdMVjoUws0PvOyNxk2v+2sK3F3h0ZLkAqLT+1603H+dFbdM+7bNRgcUAG/+25U7dsROB/PlZBeiNGEyPvdn46NTmomSZ8aaJh9nuDGPceeNx/Ok8VIcaN5HdN8V4RUwxy4kdy8bsq8Ap33H6/CVG6IrF8J/0BvxsIOLezOfsQMJ/u7hm10F5f6S2jH6riGqL3CJX3dg1B5M5xTX3jLaVAaGKbby1NPpi6td45HG9pAWO25bc
 ah0hLInF
 1OSUKbTfZWZS86zeEe3lzXG8GZTaXMR1xQLIlBQie+54hAeeCYDhbicvFHsefCaBuYWC0SBtGzjJB1CUc0NbE8msLJTowsJuKQHaGjTW0mtqailTBcfv9XfR2pkqmgcs6Cum6gwnIcekFZzIw1sHc8Zj+0dtgCwdwCDlyZjh7IwKJ9AsFEfNd57fttrW1kpV6Xm0L7zADciFb42pLSm5kr9FdKCCLdBT56/KScjMbvTHoTEhknKbl1NjpgXpNh6IxoOZ/pG4Zdozema/jXFXhp4Auasnl8qgOnO2vXu6IGRveycPLWeK1ObuVntKRdy0FsFU9S/+v3Wg7AyWNbezXBEvFw3aEYCyrqBAaEkc5LqrPPv3KT8hnILNowHJBjx0iIHFWT7y1TzP/mbg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Longlong Xia <xialonglong@kylinos.cn>

calculate_alignment() with SLAB_HWCACHE_ALIGN halves ralign in a
while (size <= ralign / 2) loop. When size is 0, ralign eventually
reaches 0 and the condition stays true indefinitely, hanging the
kernel.

kmem_cache_sanity_check() rejected size > KMALLOC_MAX_SIZE but not
size == 0, and the sanity check is compiled out without
CONFIG_DEBUG_VM. Add a !object_size check in
__kmem_cache_create_args(), which is always compiled, and add !size
to the DEBUG_VM sanity check for diagnostics.

Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Longlong Xia <xialonglong@kylinos.cn>
---
 mm/slab_common.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/slab_common.c b/mm/slab_common.c
index 657fd75776ea..209fe838fe71 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -102,7 +102,7 @@ static bool kmem_cache_is_duplicate_name(const char *name)
 
 static int kmem_cache_sanity_check(const char *name, unsigned int size)
 {
-	if (!name || in_interrupt() || size > KMALLOC_MAX_SIZE) {
+	if (!name || in_interrupt() || !size || size > KMALLOC_MAX_SIZE) {
 		pr_err("kmem_cache_create(%s) integrity check failed\n", name);
 		return -EINVAL;
 	}
@@ -354,7 +354,7 @@ struct kmem_cache *__kmem_cache_create_args(const char *name,
 		goto out_unlock;
 	}
 
-	if (flags & ~SLAB_FLAGS_PERMITTED) {
+	if (!object_size || flags & ~SLAB_FLAGS_PERMITTED) {
 		err = -EINVAL;
 		goto out_unlock;
 	}
-- 
2.43.0


