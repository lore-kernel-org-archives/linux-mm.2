Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 732B8606A8B8
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 13:07:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kqhj+g+2
Received: by kanga.kvack.org (Postfix)
	id 91C376B05B2; Tue, 17 Nov 2026 08:07:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A6716B05B4; Tue, 17 Nov 2026 08:07:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BC0B6B05B6; Tue, 17 Nov 2026 08:07:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5B0076B05B2
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 08:07:06 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DA6A1A03AA
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 13:07:05 +0000 (UTC)
X-FDA: 85444636410.25.3F4DAF6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 25387140013
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 13:07:04 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kqhj+g+2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794920824;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T0wDH7EIIn793eoNPou6qrdwgP73podZGEO7sZLmZIE=;
	b=IB6l28pZCQBeIbytWiFmPS23z2kQjEwjI99DDjG/xBXTsKAx6VOGHWAS9kY7E76iSn0S1k
	w7NfJC1jTUVcQG/tH41RXw74vqNmSf1uhH2clzXup0EE++VzKpjQwQcIRz4sRv8cm4aFjy
	+KWlef9pLIDWThJuJOSOD4JLAxKUYBQ=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kqhj+g+2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794920824;
	b=v7qzT6D/xGErwbi4uSdyUWAD4HnM/brlHimCaReA7i7EQ61rV2KL54oldCzlfQeqrG/2XO
	5hdSV8WOcOIw1r+Ov8SKIqcZPZdCMhe6lP83wQtu5K8XqqXiLfr2G6yyuWTcE3UJEOF3Em
	Ia1v1I2UK6wBJBONGn6QgbheR9vQvw8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BA796634B8;
	Tue, 17 Nov 2026 13:07:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 255FB1F00926;
	Tue, 17 Nov 2026 13:07:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794920823;
	bh=T0wDH7EIIn793eoNPou6qrdwgP73podZGEO7sZLmZIE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=kqhj+g+2uD3rzmQIjibcu68U3XmSPowcT99xB2eE0pAmKLpy6Hqaz6H1BM7hGlpsY
	 I/5uPm2CFtIM/sN71IkcuL22UNym7Hu8VNCKG9LWaALv3mWih/rdkz+AYzbwGzXUyX
	 48ixhblGVMtZl4L715qXVevqkLPQzlyaOi/QeAI5TtjPb++iV28bWABPb2wY4PCERw
	 Xp8vIFRP+tiVBHCxqazazL4Kvg1XDNlGVBA4KDKxIz6QwvfQaOSki6ddUMTd7yzxJq
	 gpvvaA8hlpaHQgopcr0cl+eMfikiCjF1oo+bAjd2aACEDRh8HdBntqun9QGv/wxtMo
	 WYJGAKMQo6ktQ==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Tue, 17 Nov 2026 15:06:53 +0200
Subject: [PATCH v2 01/14] s390/sclp_vt220: Replace get_zeroed_page() with
 kzalloc()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261117-s390-sclp-ready-v2-1-e518c99622c6@kernel.org>
References: <20261117-s390-sclp-ready-v2-0-e518c99622c6@kernel.org>
In-Reply-To: <20261117-s390-sclp-ready-v2-0-e518c99622c6@kernel.org>
To: Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>, 
 David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Sven Schnelle <svens@linux.ibm.com>, Vlastimil Babka <vbabka@kernel.org>, 
 linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org
X-Mailer: b4 0.16.1-dev
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 25387140013
X-Stat-Signature: s9k31fh46qimyfx3bmjspyrxbg5kw4nq
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794920824-716887
X-HE-Meta: U2FsdGVkX18W7ePADw9JkWUwU+fduOca0bI9DjWVc/3lxEcACZHd8GW8Un9iyt7crJNqpqpeyr4GViiHKEs9j+RtHyCn8u9DSFUSP/7sL+aMjAiHVSFmFaA9RyRWb5xw2nvTFHjfJG1g2plkrFlmekf7j3P4auLInrwHWzN23v0aKtrLc78MwV/1/iWqWsG00AEElNu5suZ0M/8rC39YZz4Q9sJUGb2YQSuGqXIDaMwtzltF0XDEBhxnKm9pwjM3GPCx4yE/L4uNV5+e2p6288GuOwIx/SAj9OvVo9gL/88obN8U/J4kjDhtq7R5rfZxNekJJLKB/PwZhcGsFnomETuGIQjquAMmnDjOUfhlJpFz890N6gPXW9oDwGzVtMbFuc1dyL3NP++LeUkVoc+A7Re9aek1U6qAkoqgRHIXmeb74IBt+7CeCSMDE0HIKKS6yQX9HDZq2d+BwljMefM9mdXukKxyuYQSHYwzxTpc44f1Gaj2TvqeRvyqI6HFP3EsYu6JvM1vifIe0R5V5puP1QNSLUTfMbFn7IT5t0WmTpHGKmNMqGTFMeCR89EvrrWm1Shya3sCDIZmJjEYldlefj6vpg5T+z0ugSDIbodvkbqFxcjffDevRf132GFIxzbXZXRqKdp2eokS4wVEsqX66VxXpTO/vr1N4Yw8Qdik9cpUmuY44uisKEi+9S12PrIPIiHLXKC0DcMaFtb1d2bwM57Md6nPGyv3RItx5ajto5leAiRbN0uWjaf40jXe/ZHnU54oEW/SVoQjpGKwogj0z2g7fQQdRN+HklBR4PnRzft20eP6lnjioGA0+mVte7cceJaHmz5JMvc18HQg81NUpF7G4jvIOLoUyXwXVMb5wcNm9p+XY3NUozO/DAemWNvwh9Z16isNh3gNBB+m6e5LUALNPLxuWGkq6tgkqXPmPhXWSNde6ohvP/Esv6pnl/SeoCe3g9klUf5jLxvEsiz
 98BHnppH
 f58IqqmU4TrDOGh2WjewRGmZf5wGHSyMz1WzYpTgjua42IT6mebRTF6a9G9MA/7PVIwSBd3ga7fOWbjaVM3RzOtYO6euga55qAlGfd+ZjzSvfBSf5CW9Br7tWQ5zsulbmaAF1ob4fY727ULHAZNqfC36WCndCgWycel5MWNNJpu+qMUhBz8fXU1hYGH/gRrnGQ8UCk4rnF9TplTPs+Udt+k4e12LTGPzIgBYi2cxpyT5lfN0K/cj6+MBjlTp4IirSDSz/rC8+EnBSwas//oGMIq4m94VeDEmAUSFkTnsfOjBtPo9f+bduY0hq+MPrA9JcVdLpcplzvZwgyEaUrZ9p0UnKHg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

__sclp_vt220_init() allocates the SCCBs that are used as the output
buffers of the VT220 console driver.

These buffers can be allocated with kmalloc() as there's nothing special
about them to go directly to the page allocator.

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
Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 drivers/s390/char/sclp_vt220.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/s390/char/sclp_vt220.c b/drivers/s390/char/sclp_vt220.c
index b95af0974624..e79467c07d24 100644
--- a/drivers/s390/char/sclp_vt220.c
+++ b/drivers/s390/char/sclp_vt220.c
@@ -715,7 +715,7 @@ static void __init __sclp_vt220_free_pages(void)
 
 	list_for_each_safe(page, p, &sclp_vt220_empty) {
 		list_del(page);
-		free_page((unsigned long) page);
+		kfree(page);
 	}
 }
 
@@ -750,7 +750,7 @@ static int __init __sclp_vt220_init(int num_pages)
 	/* Allocate pages for output buffering */
 	rc = -ENOMEM;
 	for (i = 0; i < num_pages; i++) {
-		page = (void *) get_zeroed_page(GFP_KERNEL | GFP_DMA);
+		page = kzalloc(PAGE_SIZE, GFP_KERNEL | GFP_DMA);
 		if (!page)
 			goto out;
 		list_add_tail(page, &sclp_vt220_empty);

-- 
2.53.0


