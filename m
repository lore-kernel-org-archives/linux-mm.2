Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08DC8C79FA7
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 10:24:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7BA626B00B1; Mon,  7 Sep 2026 06:24:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 745936B00B2; Mon,  7 Sep 2026 06:24:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5BD996B00B3; Mon,  7 Sep 2026 06:24:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2B4596B00B1
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 06:24:35 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A1212806B3
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 10:24:34 +0000 (UTC)
X-FDA: 85186582068.03.58132B9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id EF8AB18000B
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 10:24:32 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="TL/JmbwP";
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788776672;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=owHwZKjYQNBsdmW9cxprXhtWaMjXxhcOEf9UsPq09Zc=;
	b=TwYwkdRu5qD1h96yUzL7mv35dEhBbTSCPhVtLCHDds7v8lwBh07vz64rGJ5g3wt+M/NBJ2
	dcbhtFFkEcyssfAi5F0uHffb5Hau6DGGL5CCgFvOR9B4nPDfpr4+98FkKPMj122ddHR8zR
	t0ng/ZvX78NFw1FNgwbufyFdiTSNAEY=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="TL/JmbwP";
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788776673;
	b=BZjxK6GcJug1EpUAUQsBsS/q48/FMMN1VpCSpm05grix0tO/uKhDlEe9GivdKXeEaKMChv
	dG7jQ4MLFbuxc73vJ4PnbwRy8ND9FlYhaBi7nf1Om6zXObkwKjJBsej1W+19B2Od+U0sT7
	tH7A4t7oFjgodV5L4TtoVS1pZctR4MY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8D23160D8D;
	Mon,  7 Sep 2026 10:24:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B2721F00A3F;
	Mon,  7 Sep 2026 10:24:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788776672;
	bh=owHwZKjYQNBsdmW9cxprXhtWaMjXxhcOEf9UsPq09Zc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=TL/JmbwP1pZl9GSwEJwmvn24ao2aheHc7bJv5s2IshIbPh1MQB/NdU0L4gfFarRX2
	 lNXJmprvh/3VECTEXa1m1TvtgDks8/LJxqDhwz7fhgTeygbWLnD2PWJ5Iz6hQmv3IF
	 IYc/0ddIHeu89RZTebsq1YkUcgQA/PH1tiQEmfuffLfXFeJxeD3rdc09oGtE7vJ8y3
	 1+bLY3jqAvOaEMObSG8ndYCTKMd+ER0wSeZ1MddZgQx2mIl7FOL9kBLAo+3hxeU92J
	 HR0Enzt20v2LPipI6Gozf4Jo6exwgXtvcvmTGWL5WE7DXLer6R+B9OJmKi59mATpAb
	 iWbc4mifNrExA==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Mon, 07 Sep 2026 13:23:53 +0300
Subject: [PATCH 12/13] s390/qdio_setup: Use kzalloc() for the SSQD request
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260907-s390-cio-ready-v1-12-ca7f39806234@kernel.org>
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
X-Stat-Signature: uzud3k1tfea1a96hg3uzbu784ssaassw
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: EF8AB18000B
X-Rspam-User: 
X-HE-Tag: 1788776672-711607
X-HE-Meta: U2FsdGVkX1+6/Y6Hv3cKLlia5zL0K3cU39ofkA8Mdin3C5B35SenFZDHoHT2MIoONq+t81bBHxOA+48Y+DUF3KQluc+y6ADQk4YAkNau3ZMXVhrGhJt5gD7J74gRyuZInTZWw9duw6zhCGPaNhiRATrxPdETDuCGfQefR5/iGOwH8rpFm0Nju4RPZuCQ0khdCQ2xy9arKL4mfqX4NjT5BCJXuMXHPZURTsTa/CYCPyQIE8dCowWBiVFsRRWR4Dzwz3K+f0HjkiY+Y7unx6fKXJrOfVvlCg2azILCW24mfHPaS9DTLbQdEJSqFPFtNW2KeIPkI7G9InhLr/K/BOzESTlYL9pwKxSvg9gtxizJGIPRGh9OORPBiAJpShV6DjqRuCOSbckqFIQ64mJQY9KR8++EJawLO5aiuIvCJtU9NtMRJfpMBB76L1pVUlH9nZ/tfKSE7W3s4VEeRVWWfS3GevYJ7GnRNVSipWFf0lBU4qM5PR/7BtgMkDSokINiHV8y5veGqSXh2ArOVw+VQNZEyV6nT7W7orAVfBx4MDp6jLpHdusfsmlOiBUzmDS/G0VYd9032INevWm1gHNuDj5odQA7aYGQLsY/munsWGs36RBcydjbgpg4NXNVYeHCxAsScnX21iI8C4H+mwzu93x7Fc5G+M0xrO2vEcjq0Tszjl0ItwcNY14uTSdvXQlWsOLDZyYViTUhSMlXWsfqu2pdonZqH2M9DWr9ixNs/ZwXZtJ/0MAg1C6AiNRPn7MTZSFWnejj+00eEHh+pYQSe8gwZ63wl8R3jGjd1ucK0tvMj0Kcb06lVfKV35YTBDZI2C/df5eyYexpdLQwxfYr9B1NawZyE2JpQLpWnOmiwW3KtIE1exo3T9z023fqKrGnpee5fbOJCLX6CDoL9y3BIWckoMoAURkkaglPnV86jQo8FtDx32GNFHmwYbPHhYsQ3dg/CD7a/2EgP4zhPKJ0DVk
 /9yW/wl7
 d+Xvx7EXat5fW9cHqNTLQagzeGPP2L6jJz2ac9OJSnG6T/1qcKDSuOB8YIWwZkrfDU/2tLtqMcFYpFKQrS5xbBUHZ3ZqchYu5x7lVlxyHhPsheFD32UjtifHdRRJ13GGLjmqoKJn2qB7zN00SXZNEO/LItzN/OoHd9ExCw78TFtpDF5vCavBXRZk1iYCI2kTizYWZzf1zKG6rUOaKvr/ufBRYq6AhOeO5yNFPTPd2NrWiahJF3sM6QSYmCeL78/tpdtC1ejIu5ptIEf2MOFU9Ne/HaNcZYuv2I/J91jLR2bvgQ4JQsyelTkKyzxXAEFKg+CGS
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


