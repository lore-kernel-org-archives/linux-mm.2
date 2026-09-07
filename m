Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8030C79F99
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 10:24:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 576656B00A1; Mon,  7 Sep 2026 06:24:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F94F6B00A2; Mon,  7 Sep 2026 06:24:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C2016B00A3; Mon,  7 Sep 2026 06:24:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 14FA96B00A1
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 06:24:02 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 90ED7C06C4
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 10:24:01 +0000 (UTC)
X-FDA: 85186580682.09.D7AD067
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id ECAAB1A0008
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 10:23:59 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PMNiho05;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788776640;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BvSsEcfuxj9lC5YTGUuAUBtK1T4naFDW4wq12j/K7Zg=;
	b=DvtdPI3SvZf08o3qrwItswNnzhBCNWSCuqTdKmLnupMEDJ/MS+81p7I/1yqB4sj8ZBITqw
	lJbSqkSWJiC33eU/DOu85zcglgsrQm5Mtopm1OCIaT1pMFuAaKBiPZpOCF1Zb6sWMGZoNG
	33svOkHtK2V++XrBifrUGeVKwJ96FOA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788776640;
	b=jDl9gGzo6XNwaVXViUVog8lwVmGX1spgEJZwN31B69sahV01/XMqRS40bcvSPQq5HKocTG
	swPqmSbL3LCkd8OASVCCG76pm2+H9DkrRvlD8pkq+JJ8TssjxOqRdRDDbis6IgFWEozd5z
	v8Clp3vpnMF5zJAsTP3Omq/nNO9F0D4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PMNiho05;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4858943CEF;
	Mon,  7 Sep 2026 10:23:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 606E91F00A3A;
	Mon,  7 Sep 2026 10:23:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788776639;
	bh=BvSsEcfuxj9lC5YTGUuAUBtK1T4naFDW4wq12j/K7Zg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=PMNiho052IJwVfeivb9lDHuj7T0OqI+bZc5Z3AmRzn1GKy2BsOSQTw80aToZUydU3
	 Ziw7aYbHRvGwmC940vzWg8/AWKslCjf4QjowV8BsmtK/pdDw0ULZR5lV3OacR7WjNE
	 5F7BwNwd4rxubKftcgONyAyVQB3RnKX+dMkjAYcasV8SqBAP15gVKhQmylWhIDzoYZ
	 V0GZ2gHFFTrbZX6n/NEzKUXZfTymd1lsWH+7uXdA9/3v51LE9eiI2jyTS0Yt+lYSuS
	 caxlfC9QSCSzNCJMlrIULXTqxgLHBQRp79bp2kAo+5sbqX+rMQKmrVEWtgDIpdBmpd
	 7cIwvnB8HVNuQ==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Mon, 07 Sep 2026 13:23:43 +0300
Subject: [PATCH 02/13] s390/chsc: Use kzalloc() for the SEI work area
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260907-s390-cio-ready-v1-2-ca7f39806234@kernel.org>
References: <20260907-s390-cio-ready-v1-0-ca7f39806234@kernel.org>
In-Reply-To: <20260907-s390-cio-ready-v1-0-ca7f39806234@kernel.org>
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
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: ECAAB1A0008
X-Stat-Signature: z8rs8otxxchqizcmxyxby5cj1t9o4mxx
X-Rspam-User: 
X-HE-Tag: 1788776639-551173
X-HE-Meta: U2FsdGVkX18AcZLbY/XgzOUMrwWLTVGucWZh4LjUEwwDs20vtrmu7zcj2vqC8L7Koycx+cS6/IeMXtJ1lwi94Y8iLVlGdzNXOts5mmSAYLjpifVLJ9MGJmB0QN0mDO7IQQvz4PQ0liDoK4/0wCH9Lvfl43+cQg4EMrIX7hSc2la2JqsDF7FldTmVrTjKJftK1uzGWhOoph2Ys399Z7Xt5lymddcVOAUw5W2TcgiWWeTF6RJSR4aVAO68z/kDLFoTQH1Osi4K7I/kkrxmIN0GCqXrcbrdwY3bD3yVDD4+X1Qrbkwc54q64/vc0fbI/L6iiQw136kws7Mu0wxoO+J2//a3NH5BC//u2Ayp/mL5qlAsNGVwqW+i2m+jl+B8EqJ3nKjFWjmF4wy37L/7BkJxKUn9TM1K/UBxuVEx6FQQQpAb1LSO/lTrJVTaXEVDUG+T3Yy22WAAUCY5mPZOhPsBx20HUrqiNcwe6fkRxtmGSxY+PUkhleBo7Z/3h6UX2glEYMQSwycnoxihckncXiGgbMdGFmeJ4XO6oZEd5SHCd0hagGoh8i11K81ZBaycy4letPjKPg9y8FXg9IVOuQoONEUhGYkRAhx4dPmTnaoHqb6hGY04DfIuUaBHPlhPK0HgydTiC8uh5AMhdXpnlozrpCnHGxHfla5bA5GunqQUnU8XBlQ/JcVhIbEm1lti4ElyMvYVj7ViQisUXEr3R8uSQhYzYx8UzXcB+MK8ducjd1EsetDav3H7zh/nIKV+dtU7rFPC/QZ+6JIBNmEHW1NCDpBPRrmCV3sO2/AAYpNGnr/az9oghGd77LFwyuog52h1t7fWzfolHP0OC54LKEBpABngvPULWGD5yE1Bsk3L9yEFgLzixaN3tOYFwA7wzXZExhMomdPDVhJFcPomWSK3UIug38076NrLhAVN95VvCDFbgDnhFG8jp48KCwa+tIHuaPkrcT863oebaiVM64G
 bjHSu+FL
 wWW8l8aRNN7qjcylQwkUHkeEPgoq/mAPeHZtVtHOEnNvj8yt5hCblBe+4sBRKfpfZ/izFbiluTd3NYoOqwwRd+hfh+7emUgP1/uZCrwEQsdrachKLgggj49DAgotkcDrwzPRqTkMAAfw6Cu4KGdDEgaDYsugu/h0v3o8UeNI0BLyhT1LUx7qPK/YrHebjIQWvHoq/97k+LuW27t8lKrHzVx7egdaLs/XjlMbMbi23TBLNzTMDUMulmYKJv5YL0RPE2zK9O4ggj3eVdq4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

chsc_init() allocates the work area for store event information data.

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
 drivers/s390/cio/chsc.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/s390/cio/chsc.c b/drivers/s390/cio/chsc.c
index 60a4a7e6086ce..c3186c0a372b4 100644
--- a/drivers/s390/cio/chsc.c
+++ b/drivers/s390/cio/chsc.c
@@ -1142,7 +1142,7 @@ int __init chsc_init(void)
 {
 	int ret;
 
-	sei_page = (void *)get_zeroed_page(GFP_KERNEL | GFP_DMA);
+	sei_page = kzalloc(PAGE_SIZE, GFP_KERNEL | GFP_DMA);
 	chsc_page = (void *)get_zeroed_page(GFP_KERNEL | GFP_DMA);
 	if (!sei_page || !chsc_page) {
 		ret = -ENOMEM;
@@ -1154,7 +1154,7 @@ int __init chsc_init(void)
 	return ret;
 out_err:
 	free_page((unsigned long)chsc_page);
-	free_page((unsigned long)sei_page);
+	kfree(sei_page);
 	return ret;
 }
 
@@ -1162,7 +1162,7 @@ void __init chsc_init_cleanup(void)
 {
 	crw_unregister_handler(CRW_RSC_CSS);
 	free_page((unsigned long)chsc_page);
-	free_page((unsigned long)sei_page);
+	kfree(sei_page);
 }
 
 int __chsc_enable_facility(struct chsc_sda_area *sda_area, int operation_code)

-- 
2.53.0


