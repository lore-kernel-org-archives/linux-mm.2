Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6592C79FB9
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 11:01:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 523FF6B00AF; Thu, 10 Sep 2026 07:00:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FC496B00B1; Thu, 10 Sep 2026 07:00:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 43EAF6B00AF; Thu, 10 Sep 2026 07:00:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 22B8F6B00AF
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 07:00:52 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B95671404A7
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 11:00:51 +0000 (UTC)
X-FDA: 85197559902.11.56C0F3E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 25A9340010
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 11:00:50 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VqW3X5Jv;
	spf=pass (imf04.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789038050;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=owHwZKjYQNBsdmW9cxprXhtWaMjXxhcOEf9UsPq09Zc=;
	b=gapsXHQR6PDqm2Jz+jq9T6oZQ1i9OFUNVIEO4+XS09TtyNBNR1zk3lh0tM8XemdF1pnsEw
	DUokOGlVe9U9bIQC74JIMBbBUIALT87b8hMkMpOkc12r8UwcEs04VTx1fLvURnUqCe8Sy+
	QEuY6Mhz+CO1s9TyHEWeCtTOjBhM5bE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789038050;
	b=CnjPYYIUvjPbdOQeiTHk3ij7ocRbP76VUPFvQyzMy826FEQdPearHeGFG2xsuAUTLE1m9U
	M7QTuMNf9DhvTwjCcr9WKs/6pHbDbFp0Ry+KZKbdXAf4eJADlyq4P9N5euuHDkeUWkbCJ3
	eNzJCDQ+11+0ujV8R6kAe0MixJ7AsE0=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VqW3X5Jv;
	spf=pass (imf04.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7ED9F439D4;
	Thu, 10 Sep 2026 11:00:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D96D1F000FF;
	Thu, 10 Sep 2026 11:00:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789038049;
	bh=owHwZKjYQNBsdmW9cxprXhtWaMjXxhcOEf9UsPq09Zc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=VqW3X5Jv3ytuz7FUfg5yJqnTnWHxfa2f8uOh13f3L+szD9grS+b3XD6tZXP5GYz7i
	 Rn8nqxn2FR17hX8vFXFoIhx78KAuzao+pXVvnHiAp1GulFNzIeMxX6VlSIhJdDr2ij
	 PodkZYtf6VW+xOFO5I5EDQCidWQnHw+s21fK+KtDkOrKIf030lBYrf9ccB+mryU1A+
	 zuEN+4dny8qUUT2jzRbjpxFLYHY7DJbnf9sIkJztLzG7tixEHkxtIYQJab0SoE2Qkb
	 NtsF7X5HbVomohr15bWvmHFVLS+vNpcSyTtJ3CJetjLekTxePYfkf8LuSbSJ+uyhEA
	 L77q5T8Iyf3Og==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Thu, 10 Sep 2026 14:00:14 +0300
Subject: [PATCH v2 12/13] s390/qdio_setup: Use kzalloc() for the SSQD
 request
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260910-s390-cio-ready-v2-12-e931086fdde1@kernel.org>
References: <20260910-s390-cio-ready-v2-0-e931086fdde1@kernel.org>
In-Reply-To: <20260910-s390-cio-ready-v2-0-e931086fdde1@kernel.org>
To: Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Mike Rapoport <rppt@kernel.org>, 
 Peter Oberparleiter <oberpar@linux.ibm.com>, 
 Sven Schnelle <svens@linux.ibm.com>, 
 Vineeth Vijayan <vneethv@linux.ibm.com>, 
 Vlastimil Babka <vbabka@kernel.org>, linux-s390@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
X-Mailer: b4 0.17-dev
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 6e4r7jb7eyore8d8h3a1uxe4ytofdojf
X-Rspamd-Queue-Id: 25A9340010
X-HE-Tag: 1789038050-235641
X-HE-Meta: U2FsdGVkX1+BiToDsgoNtnT3CT1IB61OiJE/+x8u8Jnq45GP029Q8YNd/RzVhsnKYfQ1ju7oPJellwlGUyxia8EXwSpa9LBlWxUcZ058vfVqeQTMqaxsZJAxfJjBXaBSUenbcuS6n1bGuR9uwaPbY9bE7ciilh2/mWOQ7wB0QPkynOT3onoLTwDrhbsttlBnSJ+8wIpOiq/sl+75zNwMADEKItxoVXdWskPPuOLSYnat6D8Zi6TngyDgVtcfQN3IposznZPbbkUpvqMvjWfIPfk5eDsHJtRBvu6LjUzZMfjozswD6q82pqqK1by37t18oB1g8/AglEYBNW0eGY56cUZ2G7J8cT5XtppGsgKF1E0zt+Nsxs865CGy6Iqj08y5EfJ8lPK/Ath/4YQSkAsJVhiFRg9KRY0aN/5gWToGMVHEkP684ZhtKO+NsCAFgei+31kwPrSBxpg1XMolzPucPVP9JPrT8N3ZipMHJELPJ15+UBTpb1XCQUX+5PXVW8aTWkTiMl5m18NpA6XNjzQikPwsrjQdm/rG8AKC8mI7jszjlZ7IhgqAFIguSWorz8pQQcAvHurKqETwA1fKvq+iCGRoWB8fIGYAcuD3Z5pRbZhat80Y9UtqAWkdnDMOLQymCGRNJGIqRyuVCDmGi25yw1+sRF4YjjrAxNEtUEnLwdne5NSSzk0/VxttiUjDQfdIRjrI9t8O596akmTmxdsb+k+6wXGuVPlTNs32XpIoQ/k8cIDYB7h9G9ARBGxW7LlK5jSFA1UoLpN3XaLBn32MKlM1naW8Tz50+Ma9584wn06LpgM35CjgFh2E1Bz9aqN9v3qOlbuA427Ur7ZheCdZtaYiDAaEoD7JrVVG/3tlbLlrrll8dIBbN0H3lOoAvEW/U6cHXSzhQuRbANBdp+Fm8qsjiMf+FY7qjYeOep0qEfJEkotUeO1DOrATPq8rvCVAbdneCcY+QrnFNkLWlle
 3yBdVZiQ
 I17ZjJbV3p03g52rrWmnzeeWOxBsXpLc4kG8gVioDlMODrnuMl6cgbleJjfqojCzZ6P/XdBOQr+1xkU6whOqQGi69c/yYMQLdmEoAVxlQE79YBotqh4eZS1jVtdelFfwSBj7vAQzN+Mb4ktRwvNnqANSGcPrC9rvNiev/vmAuq0LzPsjhRf2ei8Xzn4d1eK0z6h25Um3O/0NwV5AB/NoL++JEPGxkZyKd+beU4P1S54UQGpqglu3MfJsWiX2qMAoLL+fqzK1q4yBgZg8/BZPFiGa3pzrfJovdN3OVkt6s1LBxLwH71aOtb7GAJJx9rYOuUvgw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

qdio_setup_get_ssqd() allocates the request block for the Store
Subchannel QDIO Data (SSQD) CHSC command.

This memory can be allocated with kmalloc() as there's nothing special
about it to go directly to the page allocator.

kmalloc() provides a better API that does not require ugly casts and
kfree() does not need to know the size of the freed object.

Performance difference between kmalloc() and __get_free_pages() is not
measurable as both allocators take an object/page from a per-CPU list for
fast path allocations.

For the slow path the performance is anyway determined by the amount of
reclaim involved rather than by what allocator is used.

Replace use of __get_free_page() with kzalloc() and free_page() with
kfree().

Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
Assisted-by: copilot:claude-opus
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 drivers/s390/cio/qdio_setup.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/s390/cio/qdio_setup.c b/drivers/s390/cio/qdio_setup.c
index 7ca8f61a2387b..c0215a7d29a81 100644
--- a/drivers/s390/cio/qdio_setup.c
+++ b/drivers/s390/cio/qdio_setup.c
@@ -249,7 +249,7 @@ int qdio_setup_get_ssqd(struct qdio_irq *irq_ptr,
 
 	DBF_EVENT("getssqd:%4x", schid->sch_no);
 	if (!irq_ptr) {
-		ssqd = (struct chsc_ssqd_area *)__get_free_page(GFP_KERNEL);
+		ssqd = kzalloc(PAGE_SIZE, GFP_KERNEL);
 		if (!ssqd)
 			return -ENOMEM;
 	} else {
@@ -270,7 +270,7 @@ int qdio_setup_get_ssqd(struct qdio_irq *irq_ptr,
 
 out:
 	if (!irq_ptr)
-		free_page((unsigned long)ssqd);
+		kfree(ssqd);
 
 	return rc;
 }

-- 
2.53.0


