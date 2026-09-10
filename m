Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8E5FC79FB9
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 11:00:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 74F316B00AB; Thu, 10 Sep 2026 07:00:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71FCF6B00AC; Thu, 10 Sep 2026 07:00:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65C256B00AD; Thu, 10 Sep 2026 07:00:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 431676B00AB
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 07:00:46 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B320E1404A0
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 11:00:45 +0000 (UTC)
X-FDA: 85197559650.11.15318C3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 99F4DC0021
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 11:00:43 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jpmwVDWP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789038043;
	b=WDhLVRMVH8/u/y+ANUHZ5anZnpBWFCfMCdVYqH8yORVsiQzVMSrKPKUkoBukv7Vw5tUqFW
	mOUO4mXKZHsute4dKqeCn7noqF1XJjuMtOEBrOXISGCD3g6LEH0ZMlQAo81oenuWzpLLY2
	cvavNci+MnkuM3mEmmeXZVpTxhVDVEk=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jpmwVDWP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789038043;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LB6kX+FFwnDBpk8VzIo69FZJtwl3A5eOSrIP15c/e4Y=;
	b=XUQ+DHuTi4jJA11kSMsfrCAaR0d7E2pCf/zi+1VSQBzKBfAGu0f2lQWf1jyEvjupOd/RyB
	3BDz1TmdZU0dF/4/RGBJSsEIlSjpGsmioFMXuMFFHui+CUvdiCA46aDxQssbdvL9H7U3EC
	qHExojYIOVTmHjF/3jdiZNihFTCzjBY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E8BE743575;
	Thu, 10 Sep 2026 11:00:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 129041F000FF;
	Thu, 10 Sep 2026 11:00:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789038042;
	bh=LB6kX+FFwnDBpk8VzIo69FZJtwl3A5eOSrIP15c/e4Y=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=jpmwVDWPGtwMq+bse73BBAXPLxdFo/PuhmwQ6g+42F7+Bm8HB6e3qf2i8rqPqHj7k
	 6Ep5rX6QaLg0XF02kXeSk92E9O+44smp4nzr77/ZGQKwHfX2qnDxpIh7qrxeTOwfkZ
	 6/btxiSo1yTZB5uGpw/MYUOltmW/1ch4vD7hKw1yvcy1Es88vnM6GuOBXsSixwcaFl
	 QIW305pHBgAFWWa9cyp9WU2W+NpBS9c+fJbuHv6Cah/a8GV9z3Xj/EefE5h1B3GpGo
	 Culqtq2TZbNWfSEc2uRF65xhFaNffRmjcFTRuXDmuO2CB6pW6F7ZZuVAf6g9lJsNSA
	 XvCZ1citPFn/A==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Thu, 10 Sep 2026 14:00:12 +0300
Subject: [PATCH v2 10/13] s390/qdio_setup: Use kzalloc() for QDIO buffers
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260910-s390-cio-ready-v2-10-e931086fdde1@kernel.org>
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
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 99F4DC0021
X-Stat-Signature: eqoc3erhh9cusq314t6pojd6opygx7it
X-HE-Tag: 1789038043-892789
X-HE-Meta: U2FsdGVkX1+zSxkWMP/gqC0FwJErNMDoI8GXe6tjowiHvBSI6a/JXN/fCPI2q6bF7r7a90DQhBEiJo+aKpOD5ryBpi/PaZy9BT5GSTcYdqUZcSnzeVPvybZ20q905mFeXystrB6EtCCDhvrzlhOcgBezfNWN4k+a3GAcIK30xfikiw1gXUQvwfhggg12N/l3JO5kw87Q8UByUrgjw4nIBrMjzwjswlW8q604IigV2Hbr7k0/D0Y0RyCuML7t6PWvpBZLQMjSMSBLYXlmuXjofHtOBWhm6Vat6cTyksKDca3gX8CHp/FqZF43jglsJ18eLYdBRjHuqJHUmj/6BFJ3P/7We7qumT8ynGP0cq779/0M9sE51mOEd81KtkG94o99+pftiFfQCFCaJAKj3KgaC7PTiQmaVtD0XGV0bOyHfiGsd9I+uE5ewvGgE9Bi4dPboOGbGdmawiCq8Scwx3ErNuFJki/gO6/MkUYzHRqhaM991T39LQCBN2jPoaOafjKZ84qzGCyRAnnzidUUvEkRlfHcfFLKKRx3aPpX5ja37TJzGWPEOkiItCZ4Q+cRGSz6X5gOL3lDUYSaOnV0+ozy1NCAuPyVfQZe2OWYCuKBLSSHj0zMWKwyfCKxuFMm5+axsj+0hvF+f3b3qj68yMH9l1vJMY9Q8sQNa3ylZfMEOhXLueBBQgjbYyXZiFJlChCAnkHKoXVWprHWsoIG0jnSCxVXjqjsCC23a1x1V7UW579TCeqTJ51VOAADu3jO54BDHR3N+hj4gfjPDBVA4tLGkbgckLpoTP36aZsIKELnBedGnZ+AQwC37BDojdMUiwy7S5r/YjYDCfRA1J7DrdmCWBd4e7x6LRjBMGJvhr8WZmr/P7SgJ38HGlJZqhkq2MAhm4XoJlr1pse9uRfNktQOBdz7rdIabV86BHLbIlVrU48vUNDI8Vns2DFyAWdyecTb7KO+tdyYG0dYYiEECao
 WM4ZK/TU
 bcIbzIrOkfWfiLfpvqAHAK4qw13DisAO+OshHG4OGKnZ3F8cBK9pt8nGFUtjFoNgaMY9zzR1DMJgJTpNRy4XXwQSibIcV6S3WkyRzmFGmR0sb52trSrZeWgVCNlHDUHzYvN/zZo+h1PgzMDBm4+b3XHROFmW9XSse7GZqu7IX84OoofrUJYDSgXp5XBYRkmATWmgONEUc5lvAQKNBcOyni8entp9G7+kl+WeTkO+albgV4Cdqe9vHgzF1aH8QXMX9ucrKPio7+70bQEhENKDTyU8IS7QoewEZJ5g7vtim8T21/p2OTt/mUi4zNTtCKtEQJ0jd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

qdio_alloc_buffers() allocates the QDIO buffers.

This memory can be allocated with kmalloc() as there's nothing special
about it to go directly to the page allocator.

kmalloc() provides a better API that does not require ugly casts and
kfree() does not need to know the size of the freed object.

Performance difference between kmalloc() and __get_free_pages() is not
measurable as both allocators take an object/page from a per-CPU list for
fast path allocations.

For the slow path the performance is anyway determined by the amount of
reclaim involved rather than by what allocator is used.

Replace use of get_zeroed_page() with kzalloc() and free_page() with
kfree().

Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
Assisted-by: copilot:claude-opus
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 drivers/s390/cio/qdio_setup.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/s390/cio/qdio_setup.c b/drivers/s390/cio/qdio_setup.c
index bd80703c174c7..b6f2ff202fe64 100644
--- a/drivers/s390/cio/qdio_setup.c
+++ b/drivers/s390/cio/qdio_setup.c
@@ -35,7 +35,7 @@ void qdio_free_buffers(struct qdio_buffer **buf, unsigned int count)
 	int pos;
 
 	for (pos = 0; pos < count; pos += QBUFF_PER_PAGE)
-		free_page((unsigned long) buf[pos]);
+		kfree(buf[pos]);
 }
 EXPORT_SYMBOL_GPL(qdio_free_buffers);
 
@@ -49,7 +49,7 @@ int qdio_alloc_buffers(struct qdio_buffer **buf, unsigned int count)
 	int pos;
 
 	for (pos = 0; pos < count; pos += QBUFF_PER_PAGE) {
-		buf[pos] = (void *) get_zeroed_page(GFP_KERNEL);
+		buf[pos] = kzalloc(PAGE_SIZE, GFP_KERNEL);
 		if (!buf[pos]) {
 			qdio_free_buffers(buf, count);
 			return -ENOMEM;

-- 
2.53.0


