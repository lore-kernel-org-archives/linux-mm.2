Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D72BCCD5BD5
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 07:28:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E3DF6B008A; Thu, 28 May 2026 03:28:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BB216B008C; Thu, 28 May 2026 03:28:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D0A96B0092; Thu, 28 May 2026 03:28:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F2CE16B008A
	for <linux-mm@kvack.org>; Thu, 28 May 2026 03:28:08 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B892A1C0664
	for <linux-mm@kvack.org>; Thu, 28 May 2026 07:28:08 +0000 (UTC)
X-FDA: 84815999856.24.28FCB9A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 1DCA3140002
	for <linux-mm@kvack.org>; Thu, 28 May 2026 07:28:06 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="mC/kwi6U";
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779953287;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vK6XINV85j2s6TrgSUq08NPf3qvCIuW4cqZINOK3rPs=;
	b=7nP/XqNIt9tpjysTIAfuVlfvDkwu7TA/kjiNYMeoceuu3b3DdT09rGh8nSKUgR8UmwwzBM
	PM7P7Y2ot3nEo6QMbPcva6P716Hcs32OekeyOxvfkEwbmTRxB8WszxW2FzEu/OfTrmsihu
	V0UePv32fFBRroiH+ZRlYjEZ93Y2SDY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779953287; a=rsa-sha256;
	cv=none;
	b=Oc+WkaS3bmh1E6JV9iS6GDfY9xsrKN6FGJpd29CFpKEohNy08uqF+8g7hj54KsxKl46X0p
	zNghK4LNRRzdt+DEFZVG32dV1/R3xz42WrJq7wMb2aaNxaphFRXjs1+yXbUE4rKRkobyms
	ScnFJ+Pw/Ln3E6i+c9NQNi1SHrAI0zw=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="mC/kwi6U";
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 84E76605D5;
	Thu, 28 May 2026 07:28:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4F8A1F00A3C;
	Thu, 28 May 2026 07:28:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779953286;
	bh=vK6XINV85j2s6TrgSUq08NPf3qvCIuW4cqZINOK3rPs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=mC/kwi6Us+Mzhj4xAvTHS5kxwU9UeMAmB0sQKTZCMBfY25IK4gsFMM3ydQLs1zjzq
	 zJekufNp37Cz6cKdT9UztYZUKsRww4WsfKBw4h3xo8ZG9gFuWzpg5puC3sTdlgk4Br
	 FxqTwbyYJUT7ixVWza5yfEiprUHPJTwzSogSa6V7YeaLjby7sYaFvF2gnliBJVg01f
	 rAkfgW5IbBuqvoYQLndkKHFegPRiE7Gz85i+375gEkLBD+dwrVn7SnWX6DfLCtZhue
	 250wtDJ4rL78Mo+9dW2Pd8GoYM3SX/kMXec6t+Cr/RDpQ5XyoYkVwCyfGHk9fjbMBw
	 74AdQFn3iQ37Q==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Thu, 28 May 2026 10:27:55 +0300
Subject: [PATCH v3 1/2] xor: use kmalloc() in calibrate_xor_blocks()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260528-lib-v3-1-feccddf1cb6d@kernel.org>
References: <20260528-lib-v3-0-feccddf1cb6d@kernel.org>
In-Reply-To: <20260528-lib-v3-0-feccddf1cb6d@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@infradead.org>, 
 David Laight <david.laight.linux@gmail.com>, Li Nan <linan122@huawei.com>, 
 Mike Rapoport <rppt@kernel.org>, Song Liu <song@kernel.org>, 
 Xiao Ni <xiao@kernel.org>, Yu Kuai <yukuai@fnnas.com>, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-raid@vger.kernel.org
X-Mailer: b4 0.15.2
X-Rspam-User: 
X-Rspamd-Queue-Id: 1DCA3140002
X-Stat-Signature: y3o9rwtkwmnkjht4skoohai9dw67e1m5
X-Rspamd-Server: rspam06
X-HE-Tag: 1779953286-427430
X-HE-Meta: U2FsdGVkX19hSvdv7zr2IgC0T8+T+hvje+jmHoKl47I6+2EUJRtpzEjv5vzqIiYGjkEx4J+mtPN/dZsnAKDQ+5SRFAJmgYeMYQ2Z14jhiB9E4wC1SCkynqdqjlg2Mcuzk2x2qM0Uj1npB5C0F5WqHrmmu70hmJ2rbSg3ePAHxCqp4y5rSVjkCiM+FaYWBF+Ap1a3hnhIneKa05T3ihU6dYV1njphcDnJveeVBnErugVyuHgo7NOWeGVB2c5EMRPQ1SIuPTxx2dVmZ1KLA4Wu/IDbQz5EzZ8GJF8+2NBVgexSTUAx0/K+ULKrSEeikH68MqmMSXlIHY8C5rIY4vHmj1QG0YuKtor9um2NJR/3jz3jNnCyaA4FERILxytpuYglbJUKI0Tgt8GFz6LR030QBBKiVx1eNzSDaLo80iL5WB7t2ODStBYsbhpLKraqiqF63EgPIXGdhOAxsJ+yosTFfCJaWvEy46desGtTG9A7pYkhBpiw/UfK+GqQaFPYXsd9eDqoPLuiyvmGvXk0U+OPOOfsxzUwhUo/DiFVkpROCrrza0Rb+GT9KFtwuyXP6g0rOXwHC4dPfm8sEDORsXWVBMOr32YfBzq5x8qRJuQPpFUnBE+ChUPe57qj2N1xz9Btuap03o/O9mCfExI9zquS8Iq7tkmya89DI1kZAkM5/8K60Y575sCmSXaFwr/mSe0NvpuaYGNGwQjtWNtECZ9p7PucwT0KPgz4Ce0LMchbAPNJBYuGlTaWnjJPQgnazj1ocZM61xMT+KTBLMlbvYA62iVKDaRLQbbu8nzBeu1iJX2XqUkYuUxF0UsTVuHqYBf2khdM795qkV7xewjGxJ1MEi+8K+QKtHIBSIIo+P5tFs4Kxgn9Fe74pwQ/5tBerWr/qVoJgDNF0x+aPrCY8ZlEPjyAvrPmVGkOwiIO/b/ZH2M00frh1NdCypYMYR/AZzZ8IadgNVzwiUNxLHLYwne
 XsnzND74
 /hAQF+JtN89qgKbJG/ULDFUmeQwOgEl1oCWUCN0nEIwKCaqA4WwduL79nhJqrXKVA726JCOSscWArbKwfQjPfQQ3FoJwgu4+Zo2POEqqcwqUvRw9ZkA2eaId3Rtkh57W25gKvQMJ1+20E6hnpIETabIww927z4vy+VU9xhdDvwSD6w4xUBWBSOtKRM3mzXpR7XvJzei0cFpLRFBEaa5+XRgXzSuZi3JWMh5FMUcl6zEy8Atv3E3oh+3MCO/dv+FstKEfKT15tVUPs3H2WCZ1zvWoI04ZzTvlqYEO6ctBSTylh+E+90ts58adaDkj6/4CojSQu0BhUaagUhoXnJpotufDg+A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The xor benchmark allocates 4 pages for a scratch buffer that is used
purely as a CPU-only XOR working area.

This buffer can be allocated with kmalloc() as there's nothing special
about it to go directly to the page allocator.

kmalloc() provides a better API than ancient __get_free_pages().
kmalloc() does not require ugly casts and kfree() does not need to know the
size of the freed object.

There is no performance difference because kmalloc() redirects allocations
of such size to the page allocator.

Replace __get_free_pages() call with kmalloc().

Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 lib/raid/xor/xor-core.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/lib/raid/xor/xor-core.c b/lib/raid/xor/xor-core.c
index bd4e6e434418..7f6436774644 100644
--- a/lib/raid/xor/xor-core.c
+++ b/lib/raid/xor/xor-core.c
@@ -8,6 +8,7 @@
 
 #include <linux/module.h>
 #include <linux/gfp.h>
+#include <linux/slab.h>
 #include <linux/raid/xor.h>
 #include <linux/jiffies.h>
 #include <linux/preempt.h>
@@ -114,7 +115,7 @@ static int __init calibrate_xor_blocks(void)
 	if (forced_template)
 		return 0;
 
-	b1 = (void *) __get_free_pages(GFP_KERNEL, 2);
+	b1 = kmalloc(PAGE_SIZE * 4, GFP_KERNEL);
 	if (!b1) {
 		pr_warn("xor: Yikes!  No memory available.\n");
 		return -ENOMEM;
@@ -132,7 +133,7 @@ static int __init calibrate_xor_blocks(void)
 	pr_info("xor: using function: %s (%d MB/sec)\n",
 	       fastest->name, fastest->speed);
 
-	free_pages((unsigned long)b1, 2);
+	kvfree(b1);
 	return 0;
 }
 

-- 
2.53.0


