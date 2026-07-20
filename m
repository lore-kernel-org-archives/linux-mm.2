Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B5E4C4451B
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 03:55:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB54B6B0088; Sun, 19 Jul 2026 23:55:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A55AF6B0096; Sun, 19 Jul 2026 23:55:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80C426B0092; Sun, 19 Jul 2026 23:55:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 50C8E6B008C
	for <linux-mm@kvack.org>; Sun, 19 Jul 2026 23:55:28 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9DEBE1406C1
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 03:55:27 +0000 (UTC)
X-FDA: 85007790294.29.65E61AD
Received: from canpmsgout06.his.huawei.com (canpmsgout06.his.huawei.com [113.46.200.221])
	by imf09.hostedemail.com (Postfix) with ESMTP id 79A12140008
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 03:55:24 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=FvapgObH;
	spf=pass (imf09.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.221 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784519725;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V6BwH4kNzJVEr3y5F7y8FkMUzszljn3fCiBX8k9PF+o=;
	b=3jikac1MHxE/5fRi47ayJvtONP/7JuZtAFSn05G1g8+Ktqsx3SNARHeS3JnLu5qe8DVw1Z
	Jyp0v/Jm9r1kryF1ziPCHIUHcXEjtwYwTiWNt4z6npnnZcmoUH4ai/It++dw0pK8GJYmsb
	Kp44FIdMruT/2x/jHSYLZv8Yv8vL5LY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784519725;
	b=S0uRwI8LLt8nwlJF3ary+0poqX5BvwMaoTD9ZPSXO7gRxlP5oo406pTckC7O4joiu7Ks3D
	cj+3JMUUc7RFwPeCck2TVsUxfk+AQn9sXEtdRm6tRhndbVwNYWswMQQts6GzG6qwPHfiGA
	SrQR0MeQUOYv6+POdRwMQqPYURBfr5E=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=FvapgObH;
	spf=pass (imf09.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.221 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=V6BwH4kNzJVEr3y5F7y8FkMUzszljn3fCiBX8k9PF+o=;
	b=FvapgObH4Vi6C/p0Uev2f1C1hOEd3AeGsxtzbb7iZzaXYWEk6HH2f30aoPHL7/JTewIb4ulOV
	TYybA90l9aP6STwX9qYFBi7VrOCfisOawo0aGS64eDXtJ9nSx/rX064dNknZV/B4wS10jJ8qflk
	qW1CTQIfkplfksrmzNgy1ds=
Received: from mail.maildlp.com (unknown [172.19.163.0])
	by canpmsgout06.his.huawei.com (SkyGuard) with ESMTPS id 4h3RJ93dDnzRhQm;
	Mon, 20 Jul 2026 11:46:01 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id 8F2C440537;
	Mon, 20 Jul 2026 11:55:21 +0800 (CST)
Received: from huawei.com (10.50.85.135) by kwepemr500001.china.huawei.com
 (7.202.194.229) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Mon, 20 Jul
 2026 11:55:20 +0800
From: Jinjiang Tu <tujinjiang@huawei.com>
To: <akpm@linux-foundation.org>, <ziy@nvidia.com>, <david@kernel.org>,
	<luizcap@redhat.com>, <willy@infradead.org>, <linmiaohe@huawei.com>,
	<svetly.todorov@memverge.com>, <xu.xin16@zte.com.cn>,
	<chengming.zhou@linux.dev>, <linux-fsdevel@vger.kernel.org>,
	<linux-mm@kvack.org>
CC: <wangkefeng.wang@huawei.com>, <sunnanyong@huawei.com>,
	<tujinjiang@huawei.com>
Subject: [PATCH v2 3/3] fs: stable_page_flags(): simplify KPF_IDLE handling
Date: Mon, 20 Jul 2026 11:30:21 +0800
Message-ID: <20260720033021.4091944-4-tujinjiang@huawei.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260720033021.4091944-1-tujinjiang@huawei.com>
References: <20260720033021.4091944-1-tujinjiang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.50.85.135]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 79A12140008
X-Stat-Signature: ofc6ip36qong73jiz87reisaugq3x9gj
X-HE-Tag: 1784519724-954297
X-HE-Meta: U2FsdGVkX19u+n/FiK+ml5x0bZ7GSW8mJsn0+PsRnV50fClv3ij+WQKMF1g3KQ18zdmv4T/VF3g2+980jSNiJAbAE9TVJRDik+kFWlBkxnKl/ULPt8OdYQtkJFxu4FovDtj/nSi6xZv0fJlGEh9Jrss0/+3CSRPIl0mQQOfMwk3IpCOtMCl9hAAPquTfqBTC2aS0RqWw7Ox3CTbwd8pmnFBL0E/2D0SIhCNxBmIjuLsJhQbBjXXMsMBjVFavKYTgYDOIPMFIrIR7pRgOB1YFGbbBOLNfCHl7I7XUf1Gqt9ldnJEyJG6Tr0aOz8UCKijVOIQDbtd4D9KUEszEu0v8d0eh/e6wAKnApBqABFLj7iv8khJMnnQtuzXMBPwQYgpVICFxnS1BML7navLngAIUdLtPc/evR63hi02n01ORIsUYnIYE71/ZyhHYd9RwW6mr4Sc9oZbrAL98Mrbc4NjnkG20O5uDA3F0wN9Ha/4gAUu72nLWwcSrz0cRT6aLVBzjcIdyiKnXt0+QPAAo2AAShd/ATbS4xqbZfiVf/QB6gTjvHG1gRyhgl2u+1jJYCNFw/pJLDaclhnrkwfrfVvHBNgBvWR7+uO6w1TGTYDW95BQB68ZzzST1u6Zv74jaZtRDwFV0zNPgpOR6ecuF6HYm/xmt4tFTbYNBE7/W/SWHnOobQkJ1/gkL5RLY1m+zm1A1zIEOyDFBPCdBPw7VYkURuolUS053cJ1+4d8VH7znULctblpOTjU3FYLXRo34gi2fU3x5iAWTl/CXX1uq7Ww1hkW68XgTGCKPmr4BOTKRcgL8TqCg0BKtwPVC40dzym1EF9Sjw+JdG8doI9Vr7s/tzJOcT73y5/abaESIwqRynJq2me3sbi/VFj+Oyzo6Edj6/pGcjk9/OfKYXE/hy8F9SMs1DgggSUUuwPlM0WYFFSclmPuvUQF2VDzWlsLQ+i4AJzkAuiFMb1Nca0Lmyg/
 PGBWg/pd
 CM6ZH6936U2XtexMSscIUEWLftwMzEh3uEynH04AOnxDexyFRyWJq8kc5wn+i2SYaQ3+GDhL22saakiStCsJCCTEm6pGU3OZZEpWycO5G1U3ed2aXrofS+YBJ2HpIa9FMOWe4iOC/gZXs9x6tbW8OtHO2IbD3sxCBPpAHvzF63nOgJOrXoOzyQR8zqG8WTeZ9RrM5ASU8+yAFQ/nl0Wi/YkQLQRKhl++2Zc6eDwEDQcgUiWdPXuTMxiOMO6rzmjtDiPB5icWL9xN11WqJbvU7Guqxy+DKtWOk4irGlp8oNf+y/3s+Js0mypQdYwJV8TJnQSl2v8boPu5lAQ4P1IazTCjIls7Q0x/eB4Npwo/piMzNoJ+nMQqBsJ6gzw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For KPF_IDLE, folio_test_idle() check in set_ps_flags() already handles
all config cases, so remove the duplicate code in stable_page_flags() that
deals with CONFIG_PAGE_IDLE_FLAG for the 64‑bit case.

No functional change is intended.

Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
---
 fs/proc/page.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/fs/proc/page.c b/fs/proc/page.c
index b3c1d7a7604d..260772b20bd9 100644
--- a/fs/proc/page.c
+++ b/fs/proc/page.c
@@ -196,6 +196,9 @@ u64 stable_page_flags(const struct page *page)
 	if (ps.flags & PAGE_SNAPSHOT_PG_BUDDY)
 		u |= BIT_ULL(KPF_BUDDY);
 
+	if (ps.flags & PAGE_SNAPSHOT_PG_IDLE)
+		u |= BIT_ULL(KPF_IDLE);
+
 	if (folio_test_offline(folio))
 		u |= BIT_ULL(KPF_OFFLINE);
 	if (folio_test_pgtable(folio))
@@ -203,13 +206,6 @@ u64 stable_page_flags(const struct page *page)
 	if (folio_test_slab(folio))
 		u |= BIT_ULL(KPF_SLAB);
 
-#if defined(CONFIG_PAGE_IDLE_FLAG) && defined(CONFIG_64BIT)
-	u |= kpf_copy_bit(k, KPF_IDLE,          PG_idle);
-#else
-	if (ps.flags & PAGE_SNAPSHOT_PG_IDLE)
-		u |= BIT_ULL(KPF_IDLE);
-#endif
-
 	u |= kpf_copy_bit(k, KPF_LOCKED,	PG_locked);
 	u |= kpf_copy_bit(k, KPF_DIRTY,		PG_dirty);
 	u |= kpf_copy_bit(k, KPF_UPTODATE,	PG_uptodate);
-- 
2.43.0


