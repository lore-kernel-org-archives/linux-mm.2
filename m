Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8BB1C43602
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 10:52:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C1CA16B00B1; Tue, 30 Jun 2026 06:52:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA7E36B00B4; Tue, 30 Jun 2026 06:52:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE4C36B00B5; Tue, 30 Jun 2026 06:52:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7627C6B00B1
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 06:52:43 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EBE8714044E
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 10:52:42 +0000 (UTC)
X-FDA: 84936265764.03.68FAC50
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 537E3180004
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 10:52:41 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AxSlKD39;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782816761;
	b=QzJvyfbtdCQDvk1hn5ODBhxf+LQsn0LfxiiEuLVakr/H78/1qbn14ReY2lPJldtKS4a0Ht
	BmcQDwhX3q9EBJTekEToGPoc3DNkGDCf7v/o9eTZaQ6W+puxtPdAjGyCCJ0IcRRq2kABGN
	1VRn2UegWlzWcKkkm+LEzlaidid8AQ4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782816761;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4RsrgcGBsOocoT8tD9/brmr55eMYBlG6KCg/uQd4DZI=;
	b=5igQH4Gf+jchMJuY7Zev+rSzET71UvGvqBvO/F8biv/RHHq0+PAcN9hjeeUREv6qk3nMut
	GH7QWxeIp2TIvQ2QsIpz3nlNbRTaMBS7fDukjC5lZ/+JmWeF+cr8CYgAo3pVtZep+ZbxAc
	GZbqGyrBzP07sSfhyBAgWlcPJipISmk=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AxSlKD39;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9A9AB43D69;
	Tue, 30 Jun 2026 10:52:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBE1A1F00A3F;
	Tue, 30 Jun 2026 10:52:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782816760;
	bh=4RsrgcGBsOocoT8tD9/brmr55eMYBlG6KCg/uQd4DZI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=AxSlKD39eppqJHEQZDH8Ay4tZe39eWqVTaZVmQ7D+WJw8hWauXvb7MjGsNr/KN/CV
	 LJJ2WxIOPcUsmXkCT0m/WadzImliOlZhpjPxCN5qzecdmHhkqirMmYnuNR2zZ6xdN4
	 r7thb9ICG70yh+wYCfxOA2BoNeGGbWuIgZ4EGEIjQlZ4nFULkJGetaz4EDZhdfN9zA
	 h6016i9DNBmU0yzHzlEXLOTsTGr6ELbQAvIXy0IwX/aInTafCpQiQ7g20FuNYlQP4O
	 bLeR00u2nZdqj083gUvTunhc6zwvQ1D/C0a/mzugRm4r/PEqyBaQApbqK+L6ksTX4Y
	 O3vAn/gpXMezQ==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Tue, 30 Jun 2026 13:52:31 +0300
Subject: [PATCH 3/5] IB/mthca: mthca_reg_user_mr(): use kmalloc() to
 allocate addresses array
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260630-b4-rdma-v1-3-ab42bcf0de92@kernel.org>
References: <20260630-b4-rdma-v1-0-ab42bcf0de92@kernel.org>
In-Reply-To: <20260630-b4-rdma-v1-0-ab42bcf0de92@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>
Cc: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>, 
 Mike Rapoport <rppt@kernel.org>, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linux-rdma@vger.kernel.org
X-Mailer: b4 0.15.2
X-Rspam-User: 
X-Stat-Signature: phfyo8i8aofc9f1bk3kssz4p6auh4178
X-Rspamd-Queue-Id: 537E3180004
X-Rspamd-Server: rspam06
X-HE-Tag: 1782816761-316577
X-HE-Meta: U2FsdGVkX1+iiN8JSbI6v6asKl4Zum3tQ05nltnGSHy3QoOBgBKd7/iV+oeRRyprwT5VFrt7fY8ZEmnmbxTNKyvHbKYPl9o/HK+ATZcnQKo38fEh3ofo65cHW8gCYy/lQCDjonVjIEI1pcOMpVsaLrC8oY5iQfkCy7r2WkZiw98yG3QR27y6dBrasCU/r3rMUn17hDU2pPtkmo0/Zmn9Y6w+Ajz1RH8WTxyKB/kGidfhdS5pVj0VSvE7kIOfFhm3N2PKIUP7mwJ26hJHadcjMGLHy3EUPDpbunOuneZVk2MU+S/Phzlb5ERat5ulbZIFH/D1wNAUTTOJPm685xElHf9YQDTHDBy1ECo1q1Jw0IhcaOtS7gmmwTyiqwOH7vxotZhVXRSmX0JwTDTzruEeSpzwX9+iHJZV2nlT5mb/qlOBkzvd8b96TdzDDjjY5Qh3MavB8hVWVqyqkjAnwLo7rKm0I/MioIng3u5/h3esd0nQe6hd4EZMJdK4U0aw6r+PzigLXXNQIk9MwZdkcWwBvrobYasyarvY+EcW0XFHau9noPgv7ztBgE/Z0HLQObr/djsX1RAgOXlWGYsH7coztPNkwO9gnU8w/sFl/vitZKlK8gxl/1g8pH4oLWCTaA/F1p72OD4LNlltx20BGJ2kSmj+xWpdzPt6IzSqeIeLhfaEAgtb6SbowJivrNBjaMOLrUzfqKnTa1jumDMc64DLLQhE3cZnObG1IuvAmslmfGx7IxKlMGZlxoBXchKqbkN88kz9MTLqUCwj4uLHtUWCZjAxi8ZlFx3637OqYmfmxp7arv/GVgfd04qnK1599Om/bwvOS1KvITFE9/0TtsQa5N6GuQEMCC4wFOuUhavkZgMyE5qLjATwh4Vo5ZD4ntAtttfaF5iMdtkuFI6kK7KkuFr8rUdfI3HiFWM6Srwdoh1OcdIhEhn69zdSNYmrzkmciumhQZMglz260FEkytX
 3WTLeBpH
 EesEhwYSggE+z2sIURDulo/HxhzL6EghRSok9qsMf8z3S3ndKBRrtfQseUReBzv5YLHvhGaMLkq4qYyhgw5f6g4qXZUOa1ghuuaMEdOp4hHvD6qNRh3F9c3EWmWPa7jfHNikLUBtatT1sA51X+uJFVOxn0R5nQCB3omcPCUYsMX+NfRXdCULN2NLnVYUMY5p2CuAc+S3ZbsF0PEqTdZDUMN6iy4OHJclPvYuNeVasbuPUUBHZ6FDhfSbuqvYPa4r+QBSPmguObznqfMSZL5zTEoZjuiZEwKn69/BNJjq6L7lPu+iB1Dc3g3Aa0w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

mthca_reg_user_mr() allocates an array of DMA addresses during memory
registration.

This buffer can be allocated with kmalloc() as there's nothing special
about it to go directly to the page allocator.

kmalloc() provides a better API that does not require ugly casts and
kfree() does not need to know the size of the freed object.

Performance difference between kmalloc() and __get_free_pages() is not
measurable as both allocators take an object/page from a per-CPU list for
fast path allocations.

For the slow path the performance is anyway determined by the amount of
reclaim involved rather than by what allocator is used.

Replace use of __get_free_page() with kmalloc() and free_page() with
kfree().

Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 drivers/infiniband/hw/mthca/mthca_provider.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mthca/mthca_provider.c b/drivers/infiniband/hw/mthca/mthca_provider.c
index f90f67afc8fa..c9ec9ca0aaa6 100644
--- a/drivers/infiniband/hw/mthca/mthca_provider.c
+++ b/drivers/infiniband/hw/mthca/mthca_provider.c
@@ -895,7 +895,7 @@ static struct ib_mr *mthca_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 		goto err_umem;
 	}
 
-	pages = (u64 *) __get_free_page(GFP_KERNEL);
+	pages = kmalloc(PAGE_SIZE, GFP_KERNEL);
 	if (!pages) {
 		err = -ENOMEM;
 		goto err_mtt;
@@ -924,7 +924,7 @@ static struct ib_mr *mthca_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 	if (i)
 		err = mthca_write_mtt(dev, mr->mtt, n, pages, i);
 mtt_done:
-	free_page((unsigned long) pages);
+	kfree(pages);
 	if (err)
 		goto err_mtt;
 

-- 
2.53.0


