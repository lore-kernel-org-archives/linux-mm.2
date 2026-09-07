Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8FBB9C79F89
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 10:24:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D60576B00AC; Mon,  7 Sep 2026 06:24:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D105C6B00AD; Mon,  7 Sep 2026 06:24:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD87B6B00AE; Mon,  7 Sep 2026 06:24:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 92C876B00AC
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 06:24:28 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F08C4806B3
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 10:24:27 +0000 (UTC)
X-FDA: 85186581774.27.89909A9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 5F690C0002
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 10:24:26 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VSFPOQga;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788776666;
	b=3UT2aLvoclIYMG+iEnDhOlyzvFejbqcQ4jvvFSbHy0UmHZChi6zwy8qUG6Izv3THcwBRAo
	YU5v1WZnlUgUQikiRDxE/K+YjgDbWkbw6pkrZzrhn0kTUuoXyP+DvyjrlGS03sluq0Iap1
	jXeygCpaL3fJdD3ISM22w3Vwbw/ncaI=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VSFPOQga;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788776666;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LB6kX+FFwnDBpk8VzIo69FZJtwl3A5eOSrIP15c/e4Y=;
	b=GL5dqErqJUp8LV635l5CwXVA0HyIQ3en6IRJInIRgNM+xkUqOzXOffu7qwYD7JJRamCeln
	S4CXSmyXMqijqXQG0peh4Q5rf35EraWpBPN6Yi3luQ+kTkDGwf94RoF577K55t/l/xPq79
	Eeon5vA1PaS4Kq4nDA3PB0btDZjdIAU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EA6AE60D96;
	Mon,  7 Sep 2026 10:24:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D78DA1F00A3F;
	Mon,  7 Sep 2026 10:24:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788776665;
	bh=LB6kX+FFwnDBpk8VzIo69FZJtwl3A5eOSrIP15c/e4Y=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=VSFPOQgagwllHZbFfsorGzw3WQyeZsCzeMxcCv9VTYDjLMnEXGhqpUlRUvk87Qhks
	 7lpd8Jl/A77vNADRXD/MUz8DTKrMt7qm+QiIQIi+U+AH7kUOBbP3fVlcaZS8yh6NAh
	 EDe+BGYR3xUCfpG6/QpEJEObPiOlH2KJOTRy5tsiwbV5R6QrQ8vQ3DKn1bgmNLW1sd
	 u0kuFe4xw51lECkKZutCbpfu/1MjuA4L8cYSs1+85ml30PZBTDzCs45C75L85Qi8BM
	 /fsWIVGYFPg4P852DpOtyEdyRRvlHf/CA6jyz8C8UHuJeM1ersvekcvvBBBLqfXBCF
	 SzIMe/ySFFK6Q==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Mon, 07 Sep 2026 13:23:51 +0300
Subject: [PATCH 10/13] s390/qdio_setup: Use kzalloc() for QDIO buffers
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260907-s390-cio-ready-v1-10-ca7f39806234@kernel.org>
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
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5F690C0002
X-Stat-Signature: hi7jmdmeruhh9ozrsmuzyaq7sfar9jms
X-HE-Tag: 1788776666-673176
X-HE-Meta: U2FsdGVkX1+S+xpFpkfV/KL9Fyfvcokvqiskw+nnewuOSDjhpB7piazySygv3X2rgl1CMyFWQPnusvXOQQplYJaZorGPnxNDUqDmPuK61ECabfdI9hZ4ZSM1LRm02o00ez2l+DKFzDgOVXipFHnVnSOvPFXKgW0uv/msw7sBM6GvSHRpxruvBPC6Zi9LqXaB/pvs9d80y5urxgUhuN5iPoAbcI/f0zrVaFMqZYk0subu4GRMR22h7Dh88iFnS3OlUYnl1kqWnrvB7G9LtMh5ZOtPDdy02oWRfoLnCA3cjfOdxC9deuA5bZRwDHDYkxaB4LvQqMlkGuqLXfuvGrFcBd1FrkV3YSAWqB1M6iPiMcB98NI7DdmrgZSPNvXJ/HM0b4c8pdxWCvXRbvOAsTJs1iihLzoF/lPUkE6shKgblCFuZpEbsq/zmPAMFcdHJsl0VBSvhvpjeRp3RvvrZXdeouVgiXmgIITY06aKsaN6kfIf6GnBg2lD9TX16jh0PvmHrNBY0A9Q10IOeINpzECxICYnLcf6NHTurasxwsnfPa+60icfyqAbzxw5qeT5jjhI4duhba46Va0g7E/Am44e8HbxvrZtTNQjl3naTxhIpsxeRFiNbGzZMnirGZqq1YPhZ+ks6wkJbC9ElLpbnSGCq5PfV4zcrgu3W+xUYnsRKFOXkZY03QnCwM+DLzf3DQgUe7dftc8oofxEQrhkMD97Ai8pfilAv0Y7OmGDuDSmWna7wL9cvC/qAGGjt8+RYW1cW6+cFFnIa3sHgAHh4Y840dismm1bRtnlJayJCDhLMuZ+yFEgqJQVjDXjAfBH1COSfGtjWWk0XWDMvRInmtYEHBbjjr7zr0fyue9TXHUbo0I9dzCPMiV+dJtZVoAqnoUUQ50xf7AmDKRSFWzZBAe2iejYPsAidk5CjcsuiW99T8+Xx/Tc+jNbDCrb/UhNXllKWogIoGU3lrTgsZYSXSs
 MqoiZkBc
 eU+dZIoHlfcaGZaulw51bFOTHW1DAJ8BmCvMvmP7Wf3nQ8RZRrggII8C/mYzn81upaoYASDeZwJBchcxViEIoA0UrvJX3Z4ZpjgyoX7fmvxmrK4jjhm1PFozC5EhbXylhSF+ODn2xz2yPcBPGeJcheyH7/wUDiaU5af6ob7udNcqlVvd5/In9PM/ZmwmsioK/+4XU4TaTREuGBU21zq5wtVfCaHgiUM51c+0Oonkt4z8/i5hnizfenbB/KmSiu3yj6PhFv2/CbRnknkIeK7Pk3jHA6MxJQUAGayow4CevRltZzYlZ0Gh+0rVwTw==
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


