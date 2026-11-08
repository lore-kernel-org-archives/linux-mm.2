Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DCA2606A33C
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 09:05:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Vy2SIHoW
Received: by kanga.kvack.org (Postfix)
	id C8D8A6B05C5; Sun,  8 Nov 2026 04:04:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C43B66B05C6; Sun,  8 Nov 2026 04:04:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2BBA6B05C7; Sun,  8 Nov 2026 04:04:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 884916B05C5
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 04:04:59 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 14612A02FC
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 09:04:59 +0000 (UTC)
X-FDA: 85411367118.30.131B363
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 6E45120004
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 09:04:57 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Vy2SIHoW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794128697;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5eT9qpycRrSs6FOiikbaYya5uDEBcnf4nUnejqd5/AQ=;
	b=x1fEgIlMuRY53uAo1Q5fREqTqAZZPDqpCpWvAl6vP51X/MHIWjoIyqD4icHcUSm72NTM0S
	iWgc8C6xMmo5YFEqJ6pKEKP2+iWxdGr0A7Kcn75T/2ecJZn+40zy/IP32clMSwIUxgr4CH
	6x6kZ+aqaQZ63vqkJcGNjvsu/MQHaCc=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Vy2SIHoW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794128697;
	b=fGAaWv4d5GkyZiEbPtPfQr4EESD6nWMxzUHSWkkB4ZJJVW/Nr5EdiBPMYSd4TVbphdJTL3
	8em0rbjSfevTBRFXbmdvHe1StmCXQ2HGMoIc79p0ZitZfXFcq1mw77fekG2u+UKu7Yx7uF
	2RHBCAkJRVa1YY70BnR0v89mAZ/u84U=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 13BFB6153A;
	Sun,  8 Nov 2026 09:04:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32C841F008A1;
	Sun,  8 Nov 2026 09:04:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794128696;
	bh=5eT9qpycRrSs6FOiikbaYya5uDEBcnf4nUnejqd5/AQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Vy2SIHoWEqvLXlrOvgUlKYUdiU/lprj+MEj+iBun4RUrEeEei1b1ViYsmk1nY1rLG
	 YR0v5xHaD1SQXy8mQeLvWwSrzER96+Knoe27hBnFxKx56Yno+DvLh9FvSyiWxy4PiM
	 T6o5ZJnaLsITBJXSt0fSHpfOLzj6t9/VfmP/nAE9HiHC68K/6PXN43GgJ16BeEgVlK
	 aGWExFWE8+Rq9l80IVVYjFBjmaUuE64+t2v6k7NzpBOfZYC0TPZwD2guYplp7BRxmK
	 TafEHhR0/QmHfARx6R1Es17OvlkCnHHClX0l7mdfLQ/nWxCScpwcIae+DrT6vHRO+C
	 hKDVkDKpryi/g==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Sun, 08 Nov 2026 10:58:42 +0200
Subject: [PATCH 11/14] s390/sclp_cpi: Replace get_zeroed_page() with
 kzalloc()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261108-s390-sclp-ready-v1-11-3e7c90eb6676@kernel.org>
References: <20261108-s390-sclp-ready-v1-0-3e7c90eb6676@kernel.org>
In-Reply-To: <20261108-s390-sclp-ready-v1-0-3e7c90eb6676@kernel.org>
To: Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>, 
 David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Sven Schnelle <svens@linux.ibm.com>, Vlastimil Babka <vbabka@kernel.org>, 
 linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org
X-Mailer: b4 0.16.1-dev
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 6E45120004
X-Stat-Signature: 6nccp8psqfbsa44z4yx9wcxhxo3y1j7b
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794128697-28445
X-HE-Meta: U2FsdGVkX1/P1JRA9HsAARs4huChkfnjcjqLW2NvnQO+mrer4B2aSnITRRoWI9S4f10IrEFFpwsEh7tiRbuzRONR1TATxhrcXJv3UEr2PwfZgMjkrx0nBBoEJ+qwQV2/uuBytSgSiLtY3Un29paQ0xaMbdEn7G+MlD/X4eLnvS1Fg0X34JqaKjMJIVEAI+oW6P9HUTg+V+MUBowXWmx4A0AKQyoLMjcebdeeeOcoxxy0gP2aF3ouorpxjiT3Z+9AwdElydkwRIBi+3NOnqZVAOeBn5azTn7xH41dTAu0ITQ9Exbjz1yMOG27l9tZpTpz7pneODjmMwNJfkVW0FwkQMQesFSM6LAy9POYLBB7yZ+/CJY+y2jX5Fwd3zD50RxsyQo/lWU4ESKWqVaWic7QOgr9a/1N4HsOoT+8x6D84EE+ExMCoeNDQOdFFFde7Qzn4bKi4uXmNIsewdeQ4LKNiDpM6o5XT5gbk3IjNLRKK+yIAO12dwnwjv4WlR3FFhzQi9HYu18MyS7IFWhTRhsOct5Wos4382TKHJ8Mm3KO7FQA0wm0GRZVz4Up+S3LkTQQdRbHUE/QYdZgUtrfOxVTpTQBj2No2uYgogtOR4zESIrL1mL4VBECn/C4PXMu74MSp7MpbXSQgAe3K+TWnRcuXyqfNpivLhktWV82QndBf1mwfkFqm0nAuxKaPQohH1ACjVsxi4hzsOI9WESqQ/M04TJUbtk2vnp5LeLTExe03sRqXqVraAunjyWudaidlM73f/TXijTrhY/lSywTcYnLrUDdOqmR0fT2gels1O5rsFLTDO7uLNcnEJwcQn2tircMUvyWaLEdkFOURMBpL+RHYPpIei6TCA9RzcnDPh6abPue1YLHGpM3c4YuSLWionaSbSHMrn+u4Aj2O8OnJkkRliIy54+Mwcx+CymhKO78CQw7+VUkfMN6fGVJPUuACd7XKhBFbFVtoy7l2YPzs5b
 xjDlwqMV
 NdKAghVFwFp07wcXAUYtEBGYjRLAGNl/uQK4acGttIy+7GvzJyTDQFb0eOgyD39CgsGZxsad6GNuZ37tTWIl8xz140bGpGP7wq6h0VFUtwQ9hDV+gCAJfAPZsdzlAExM8mWDnmbR+RojAeRxg0YL+cJrRJsOBsfxN+HccWs9qGNQQJuu1jHjWsVjX7ta6aY/eqolzmH2HjaaqVEL6q090BBEL3p8IPSHIvFufqLpbOI7ZBQU43ZV20WRMUyxffEp8d0D0YiJO3QCeyw606Ef95SBnn8uuaml8VMJmet9CdChfBnUvJ/ljmCl6+Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

cpi_prepare_req() allocates the SCCB used to send the control program
identification to the SCLP.

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
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 drivers/s390/char/sclp_cpi_sys.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/s390/char/sclp_cpi_sys.c b/drivers/s390/char/sclp_cpi_sys.c
index b80f73fa1e01b..8bca2cdb34c10 100644
--- a/drivers/s390/char/sclp_cpi_sys.c
+++ b/drivers/s390/char/sclp_cpi_sys.c
@@ -84,7 +84,7 @@ static struct sclp_req *cpi_prepare_req(void)
 	req = kzalloc_obj(struct sclp_req);
 	if (!req)
 		return ERR_PTR(-ENOMEM);
-	sccb = (struct cpi_sccb *) get_zeroed_page(GFP_KERNEL | GFP_DMA);
+	sccb = kzalloc(PAGE_SIZE, GFP_KERNEL | GFP_DMA);
 	if (!sccb) {
 		kfree(req);
 		return ERR_PTR(-ENOMEM);
@@ -118,7 +118,7 @@ static struct sclp_req *cpi_prepare_req(void)
 
 static void cpi_free_req(struct sclp_req *req)
 {
-	free_page((unsigned long) req->sccb);
+	kfree(req->sccb);
 	kfree(req);
 }
 

-- 
2.53.0


