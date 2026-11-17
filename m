Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CFAF160A5BCB
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 13:07:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Iwl9SP5i
Received: by kanga.kvack.org (Postfix)
	id D633A6B05B7; Tue, 17 Nov 2026 08:07:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CEC146B05BA; Tue, 17 Nov 2026 08:07:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B66966B05BD; Tue, 17 Nov 2026 08:07:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 978B06B05B7
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 08:07:09 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2EABC4042C
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 13:07:09 +0000 (UTC)
X-FDA: 85444636578.29.BCBBFF9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 6F8304000A
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 13:07:07 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Iwl9SP5i;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794920827;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uys2UBDVsuwnr9rkivnHsjzKN4wH7PF/d/BG6IyiUZs=;
	b=AXwEdYixAwqtM4XwqpdzLmByF3BGwxUn4UHS/zPF7lAeiDe21++XEyKGWDkJoF+ovNsmhL
	8y0U4sJrBCywoXb8yStMH9tQTArflv6+UcmNx6KdMhHbufqjzruZvJbZ9xE6QzOK1jl5ak
	Hu6gc1IuVhLIuBoAMVI1BYy00B3eTWg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794920827;
	b=a+kjip7NTT6hsbdS40ZUacDmP4uQn4GDpi3OpM+ZEzZZ6TVgsFM0fmXO19xq88OM5R8Ov0
	o/nuP9PT987bC3Y3LNswHnAJo9eqz6VOxBBR1mB3QupW5WSEpC9mE+BdGou/xY+29jYp6L
	xFim9UqdBpn8pPx2LiQsPRai4hjJTFs=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Iwl9SP5i;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8E8E5413DB;
	Tue, 17 Nov 2026 13:07:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1449D1F00926;
	Tue, 17 Nov 2026 13:07:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794920826;
	bh=uys2UBDVsuwnr9rkivnHsjzKN4wH7PF/d/BG6IyiUZs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Iwl9SP5iBv+dmCOjDRreWUCiUR08o8DWwfDthI/7iPKXhyIvvt/2CaaKeEvXucIib
	 fuqsPEqvTdp4gTiNXaRKp23Ew7PY1bmEem/yxi62xjG7M3BeFdYadlQxei6rssC8or
	 bQUy5YprG6FuHQHlPQPQFMLTJRr/jbvr1XydY7IbvkV7X7zmqfXAfmhV41JUVIdH2P
	 y6tDY0q+ygE204WQOqZlVh9HEt0eY/jlk6R9t6V/B9aQamw3DAbleYluQUtJZzA5R9
	 xi6MNEutu5tZGkPmpVGZ1vvbOtRrZfSn/kqgL/l0grbVLJ/1OxnIeR3VtXxlfPjpnV
	 r3JvmJ62+FO8w==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Tue, 17 Nov 2026 15:06:54 +0200
Subject: [PATCH v2 02/14] s390/sclp_config: Replace get_zeroed_page() with
 kzalloc()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261117-s390-sclp-ready-v2-2-e518c99622c6@kernel.org>
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
X-Stat-Signature: 91boa55yszea6tirqeyiaq4u7coqdtnx
X-Rspam-User: 
X-Rspamd-Queue-Id: 6F8304000A
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1794920827-234566
X-HE-Meta: U2FsdGVkX19UYOHZQA9UMFfcjCXICNv94PeP+8bhA6OmIlOhEIlyIcmpyqgUOz0ZiXiFfhl4hGNsk74ZtQcoDBd/vFqslTHzc03O+QgJfcAAh/fqAU22m7oHYFmezu0YnMHTtMD73e/jXCmWK+pzWqPKG5nZil4BQ6xnr3167B3ja3CldEQ/BDaF8UTb+98t62/kAAnbTDVik/mmhBTU4lyfjeuH8MGkEs2ixJEqMavaLGxGFuf7Xj7QRXDIylxu0Hd7C8ALl9g7Lg3TgB/q8BpIdxYXRfIhPONi6qCSFlpDr5tewf3iVp1SwgSNoqtabKUUiGVB+EUfYthSvEfDhHSB3pnGzcGOcfIDAeoFKZuXxLyLv7bMW8eH3W7wYQ5aXBLD5X6/Z02Y4CoArq7RJBxL9Bz0y8oBcKc7oe73o/CgDR38um1geXnntFfAS1+y5upvhZGsNtjBt0YOLabu3/kSzYzy0GZg7xQKHjlWetNQvlyadKKG4FLkYkoGRQRC88/eAKVWhEICnsjJYEaq91f2b5/ha1ScNPAFtoRr11SWr43qwVOgTAjrjj7v96j6pubWI5NXp9SJF1YF9NLVEGV4/e8Qxhfx1rVaj1ZAHKnQphmqnc6FMvZ7b6rXBbbis0GKKMsesxcxNYLNEO3EFEq0aCOYZTAAAmyffU771+A+hVeUnNzfo4rHZpyIG5uogNUDv/Q1SCQtDpF5MVb/iWLVmVp7xUmbCabx0JA+jKL7MiIq2BsWSpYRGLfRV5KF56AmI3wI+/L1uFEcCLkoIvZ4lfzwQL7wuWm7c7NFF2l86+oVYozQfcb75ynLvfleSQhOIXq2VyZERtr4eR/gp6FpiEEWnCvxtcib25+x0qkgVHv3kGjD4l/WndyAcFi0EwfwsAhEGGEwczUvgiimlnsLwwFQHn7LSq6Q3+W6U+H0i2U6kgSJh3Ay1njjJVgeuJen+niqLN/dX5UV1RQ
 EIW67esN
 Pu5WCG2QXDtXaiZsAmuh5DvXZUEMMDsoVoQc55hVlncAZizlY7FIIMSpykTLz6ZPNarLrx4kEzoCyTbS9893m1QNfIZlcsGvo5dRwoQGGig+LWXyC3tSmUBtFdwIC/DM9pWyQMjUbZz8uITE3x9loGDqaqnsfAo1ThF/CDHi30uF5Gq00HJ5mpPN0YVTQhtON/Js+lN15cpduOyDp9VZcd9tS7nOfEvCncfx05vbi4UTQPwmIzSwKCDTux9q5tmS6Y3MsBYJZ/0WTx4jtrdxpFdFU3JkBANbWrZjwmZwIwnhCv4Mp0/4jfEBdF9rJBLvA3UOoQH8GD1sILOvqlxTeskZsCA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

sclp_ofb_send_req() allocates the SCCB used to send an
"Open For Business" event notification to the SCLP.

This buffer can be allocated with kmalloc() as there's nothing special
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
Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 drivers/s390/char/sclp_config.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/s390/char/sclp_config.c b/drivers/s390/char/sclp_config.c
index 8c77e8c44fc2..16617a679366 100644
--- a/drivers/s390/char/sclp_config.c
+++ b/drivers/s390/char/sclp_config.c
@@ -93,7 +93,7 @@ static int sclp_ofb_send_req(char *ev_data, size_t len)
 
 	if (len > OFB_DATA_MAX)
 		return -EINVAL;
-	sccb = (struct sclp_ofb_sccb *) get_zeroed_page(GFP_KERNEL | GFP_DMA);
+	sccb = kzalloc(PAGE_SIZE, GFP_KERNEL | GFP_DMA);
 	if (!sccb)
 		return -ENOMEM;
 	/* Setup SCCB for Control-Program Identification */
@@ -119,7 +119,7 @@ static int sclp_ofb_send_req(char *ev_data, size_t len)
 		rc = -EIO;
 	}
 out:
-	free_page((unsigned long)sccb);
+	kfree(sccb);
 	return rc;
 }
 

-- 
2.53.0


