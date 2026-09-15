Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0ABCC88E72
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 02:43:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D5F0C6B0095; Mon, 14 Sep 2026 22:43:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D10ED6B0096; Mon, 14 Sep 2026 22:43:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4EE46B009B; Mon, 14 Sep 2026 22:43:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A1EA46B0095
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 22:43:44 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D2381802BC
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 02:43:43 +0000 (UTC)
X-FDA: 85214451126.11.933281A
Received: from mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	by imf08.hostedemail.com (Postfix) with ESMTP id 9DCFF160007
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 02:43:41 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="V/FRTSn2";
	spf=pass (imf08.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789440222;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gfY0lZ0pNCwPAKqMOrWQbraB3Yfet6KtRQS3ZpWAtlc=;
	b=Ydu9pvwLrZWihSVHJ6S02PQt4b5KY4in4vrnpdpni7JV2/X4Bg3dLmDRNWISOQ7OW4txQp
	TA272w+L0KH/wn4CoT5yGJY8wcWRBBzYAPsCa8Rm8DxgpYXjtgPavYp4iWPSYyqj+Cx99r
	hXX5x4I35XJFaujdUR7F5zMbyCk4J+c=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789440222;
	b=D/UcDHIEkevvVoghkKqh9XpH304SNMYdf5X6gPDLA1pPE8bOCk2o+9gwzyfBSnMZCXKG5j
	k7XZk7lzWnEuVwatsvQd2Pg5Qfr7IYAJ0jizrwAMkXpFS0nWlvvOQCcKp9nN36Jg1pFA8Y
	Q+/ZmFffUJAbxp6sI0JDIWh0Itg0aBU=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="V/FRTSn2";
	spf=pass (imf08.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=DtVe6iy9kJQc88TiAutYrREK+boNgH17VbBNJY5qxyE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789440220; v=1; x=1790045020;
 b=V/FRTSn29A+j4slc/1Ay3rzTNl4t8TUj6+J4EA/vBC7DZI3xgaD8hESrGTOk2lwwNZ33rG5/
 MWeWMgB9Ldw36xftIrZig9Rbl7Y3NRzVof2s0r3q6MsWQzJiXoqMHJyGdRoKZltGT3gveWDyYmN
 KgwXNMjrZJgYZ0M/i6D3Il0A=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 17f25854bac11652;
	Tue, 15 Sep 2026 02:43:40 +0000
X-Mizu-Trace-ID: 17f25854bac11652
X-Migadu-Flow: FLOW_OUT
From: Ye Liu <ye.liu@linux.dev>
Date: Tue, 15 Sep 2026 10:43:30 +0800
Subject: [PATCH v2 1/3] mm/vmalloc: group xa_init with vbq field
 initializations
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260915-vmalloc_study-v2-1-cc4dfe635e22@linux.dev>
References: <20260915-vmalloc_study-v2-0-cc4dfe635e22@linux.dev>
In-Reply-To: <20260915-vmalloc_study-v2-0-cc4dfe635e22@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Uladzislau Rezki <urezki@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Ye Liu <liuye@kylinos.cn>
X-Mailer: b4 0.14.3
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 8sb88p5xzrjtptwgsob8xnyc5gz9csp6
X-Rspamd-Queue-Id: 9DCFF160007
X-HE-Tag: 1789440221-751430
X-HE-Meta: U2FsdGVkX18yZMpcz2/KIihqrlZNaf3ivv+2LK0qexjtvk6d+hthfNZsVLOCVPt/Vq9QgS/bRKAKaNoygEtN1haYjMe8CL4QUwMvfjXfAD8cOeVmuDA3ERWR5/F/0OUd7n3nR7sksvXqIQ/Y7Bw5rKaj+09HChHa/zN0kDdBgn3wC8uKzDiqgZra7ApEyyvKQMO6geOvirxcfq/HV1CBnC1nush7D9R8RhrKCc6TvKf53uWQfLdMD2k+mHQdCk4+4nFm7Mym/z3yzypk1ZOomHh9tJ1zNXYXWxNb2RNrV7I0YIl3/uOmdDhBtdigZsf/ieq1Ah1TUqMWF4rJxnCV/EaZWWm4D8oKClU/QHGWSGSFMuy57BjrplQFHlqSWYKyFAgR/8PQrAk6dvbMc+F3tLhYCEASM92mNwinGmQtCPvUBQ+9HYOvJWNHWQ5SZmvqAei+BfIJcdN+FJPCurJrk9OWJc3g52fOSGdhyy+xNUa2LNHY3bYLRHSXrqgQrrRSBdm+reFYcRXXBGl/haQadIfw1cQuP8PX0pUWcymOADQYJH60haj6mbuB04A4n2u/56peJ5s1zGFfHQXd6MNgowB5uiDqsfGDXpbotjCbXSSwxrs/eSwdrY8BQtQeVtFRg2uMqcfafUEbRcWFOVYKrTFUwuNtj9LXnNmlXlAolQu28dKy6sKoRfDCrj9cDpKhVcVlyfPTS3EMlYjft9+CJHT9ylnYa4ANCeQrrDRYCvkqDviWho7IR8ByQ0b0vvZJnYTmNA8C9JhNxpe11x2iYR3E6VluEP1g5dED8MyA0EcP49vr1OoyMUYV3TA+NYkqdjR8QEcojuVrHpQ+stS5RmqYk0xBVzZyDsOeEmXbXOOu/idAfyAEXMqOatfVCpxgzKJC1ngH7b3I2oHbAT5w3LqybgDfbeJfD/+iDmVVqpc++wvWkwzDr/7OY7CafupmzpMbFRIDLW0SMjv7hlh
 cLJ7Lb7n
 VX1Z1Ai02T4asJacakEyUqiqUC6wVbnTxI930BrgAspLueM6R0X/wgN++M02dn4rCxbrQujP5xUChhXimSNO19Mgw5XBfVGWjROwb6/i0/iIwKQfD7jLbmflJi381S7mZEmWT4g5iyjCjVwBeH7wcOUZ3h/XQpzH9zXYxaKI2Osps8IxNJxSfIWzPZAyuYJKnRF5bTFVpB//JKLMHqd3Oo691i06fRW7BBv96iUHwaBY3tszjHwf5XSNke9fz8JcnYc25a+kzyBd2XSV5z1FLUktmoMdSuz+LS73K01zf0F16PhCR0GS8LYxeBA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ye Liu <liuye@kylinos.cn>

Move xa_init() next to the other vbq field initializations instead of
after the unrelated vfree_deferred setup.

Signed-off-by: Ye Liu <liuye@kylinos.cn>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
---
 mm/vmalloc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 859e6d2d57a3..117483dd048c 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -5585,10 +5585,11 @@ void __init vmalloc_init(void)
 		vbq = &per_cpu(vmap_block_queue, i);
 		spin_lock_init(&vbq->lock);
 		INIT_LIST_HEAD(&vbq->free);
+		xa_init(&vbq->vmap_blocks);
+
 		p = &per_cpu(vfree_deferred, i);
 		init_llist_head(&p->list);
 		INIT_WORK(&p->wq, delayed_vfree_work);
-		xa_init(&vbq->vmap_blocks);
 	}
 
 	/*

-- 
2.25.1


