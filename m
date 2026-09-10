Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 609CCC79FB9
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 11:00:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F7596B009E; Thu, 10 Sep 2026 07:00:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6CF0D6B009F; Thu, 10 Sep 2026 07:00:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E6666B00A0; Thu, 10 Sep 2026 07:00:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3A4166B009E
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 07:00:16 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C4944A4E37
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 11:00:15 +0000 (UTC)
X-FDA: 85197558390.03.B51E62C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 1C01B100007
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 11:00:13 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QuGgLiln;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789038014;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=waNeuygMDtlm0C03ZytfUl73M0zkpwkt1aPQuPSWLWw=;
	b=1LkIvliymku9PqH6usMXoMPUIzpQnhAqvNe9WYf/CNGxtK4gOznLVv/C4PldaI3pC+PqMm
	2EDi8yY071N6N1SgrMQTbRkcmf0j8/Xhtq0/1IxVTkYx+LktNEftEPrI0qeDdTUwuZwqQH
	zBZ9XTf4sJ4YNzMvZ1FwpfiXPpryAt4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789038014;
	b=t3QKMYfKB4Fb0/c9pVjcNlxrKZsLlYBJzsEfrSF0myahe2tRi3lF5MuSWbtNc4fLA0RluC
	4pxbHXsme5UqJKWT3VJI6YEJ77qDXKDRKsSTkq9bV2KKDauohG0mdUzLXMMHiHsiyYrq4j
	Qekp6V3lN9Uy9SPXNQ449vCsI5Idy8A=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QuGgLiln;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 78AD0600D4;
	Thu, 10 Sep 2026 11:00:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 697F21F00898;
	Thu, 10 Sep 2026 11:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789038013;
	bh=waNeuygMDtlm0C03ZytfUl73M0zkpwkt1aPQuPSWLWw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=QuGgLilnXzAsGi5SDxvpW5ki3SPsVVpIH63og6dimK8fFfG5Fof8O+AehVN6a7xGE
	 7jIGwVc2binhpEGQ+4HlpTa8Y7KhifuwbFX7vDQTaESA5Weo5LtB2S05xGP/OKQ4za
	 yzm9ERhN8E+FemafZpVQnLNoP83GbbG0R9RsP2BJhmcAOgTmpBgMgma+afzs5wpqfn
	 rct+zvuMngEM5w7Q8MGmwLGtgtKdZyInNtRidwEZLW5vSFZqG5WKRMJ3QtilipDueW
	 tVqCNnECnvPfwrCo7hDpTVt+O94fS4ZmZzifGWltGnNSEHvwALMM34mMiqhtdW83PT
	 4dyK4GUfJ986g==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Thu, 10 Sep 2026 14:00:03 +0300
Subject: [PATCH v2 01/13] s390/chsc: Use kzalloc() for CUBs
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260910-s390-cio-ready-v2-1-e931086fdde1@kernel.org>
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
X-Stat-Signature: 5ko4jppqf5wr9bs34at9t6i9r1dg9ah7
X-Rspamd-Queue-Id: 1C01B100007
X-HE-Tag: 1789038013-685737
X-HE-Meta: U2FsdGVkX1/dWz5B78WF1cGSngNPvpiY251NqJGwMTU0NOEbgEeo6TTNkJsbrA7L319C09l0eqIzmA/gsZDRWaoGraYm9gTAyP8unfG1SyFniTn/JqHIFfpFE7ThN6kLFfgoWcJk2+Ls5hnlyxPE5kZ/8BsLUTKAsvTtCSkRko3PpGA2dAfQtmaa1+pmyyqwXVw0kIIoecRIA/fFxGxn3H6Jc0kcpojdVHut7TWBcVYGrG/ByAzfPL6/eGEDfNp3z1eMTPSyDD4gNDHb3zE7NoWyNqknkavL6N66OPBq4WwuGqC23JioqKVijqr3InB/pSG5cGL65OtnOWNdFEcnuuGPIuFJAoe8l3rNgFcdyNSMV5OVvgK5NAOTIjgYrVQww6zeN9nWRKJ0H2Cg86+Oed1boGxL9xLy2O234pNvlLem8igXzn6MOsiG89PZ9bF6UWppnFJjyqWPl9Urh5n6nOn4zZa3TYNwL4WCic0PmIEeOXV5iz6uCFxhwLkJCUEVL/015Ltgsk5bRRXMR+lDD4i8IUnopPOtPUd+dq2Gz/cRqV7XBdMtxW4JtHiALiooF63doloiM+BrFX1/dvQCU0yC9qjSZ0XDYZAnaFaCrixSRLDWUWwsv8ETAdN0o56dcTnEihSAQwyV47TzKDPNLuFUUCc5q4DZ/7cOXLhhmqrFtbPLaaJN2XVvK5LogKiwKNvx/WFkjCRUA0LxFimJEIbLwUG0RYhbjmGNIUSExG2Lg/74QR+hq7/lub7nnUe7VZE/8+TNbtUVOYT9JIFR9Q+DgP/y4b+RHz9qtGcyEl1YLus7jCPqmeOPiVYIMf0Lq6QozInky7S4E/8RjVDy961x8jFuzUaabbBOft1dzVdiOauD0ZlKjZicKVBRoAL0Ia3cWzftnEtgCCThErvAg6wA1zESzIpV2xNScuKUCnB1oECbTJOecR9RoRHH2YQkQBRv1wQ2B0ecdaOf5Ni
 zfJwa2NX
 1MuhmNMm87eEC/4Dajji1JtlNSR9y8oak5mwjgNG+JHzIJNy3z+Yy3EUI0SwqpQPgkkHMs+r3iZLnlta3WY27p5Rb3Hs5yeql0IQ55bSC7XzQP3XPbKTIh4hSkGWWhNjL/mA2HRfTM4Tf7wR5fJOt/ETfCdboH7ty5jHkO6LDUZP3Ehrl122buEG9r7SNKMtYXKl8eTyE9cYFmwm/hMRXsrrpf2SYipSyGL/idnsxyMR6dloI00vi2hl/cCMqNhYLRXPvpe6E+hXfrvg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

cub_alloc() allocates the channel measurement unit blocks and their
extended counterparts.

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
 drivers/s390/cio/chsc.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/s390/cio/chsc.c b/drivers/s390/cio/chsc.c
index 9689f722c863c..60a4a7e6086ce 100644
--- a/drivers/s390/cio/chsc.c
+++ b/drivers/s390/cio/chsc.c
@@ -931,12 +931,12 @@ static int cub_alloc(struct channel_subsystem *css)
 	int i;
 
 	for (i = 0; i < CSS_NUM_CUB_PAGES; i++) {
-		css->cub[i] = (void *)get_zeroed_page(GFP_KERNEL | GFP_DMA);
+		css->cub[i] = kzalloc(PAGE_SIZE, GFP_KERNEL | GFP_DMA);
 		if (!css->cub[i])
 			return -ENOMEM;
 	}
 	for (i = 0; i < CSS_NUM_ECUB_PAGES; i++) {
-		css->ecub[i] = (void *)get_zeroed_page(GFP_KERNEL);
+		css->ecub[i] = kzalloc(PAGE_SIZE, GFP_KERNEL);
 		if (!css->ecub[i])
 			return -ENOMEM;
 	}
@@ -949,11 +949,11 @@ static void cub_free(struct channel_subsystem *css)
 	int i;
 
 	for (i = 0; i < CSS_NUM_CUB_PAGES; i++) {
-		free_page((unsigned long)css->cub[i]);
+		kfree(css->cub[i]);
 		css->cub[i] = NULL;
 	}
 	for (i = 0; i < CSS_NUM_ECUB_PAGES; i++) {
-		free_page((unsigned long)css->ecub[i]);
+		kfree(css->ecub[i]);
 		css->ecub[i] = NULL;
 	}
 }

-- 
2.53.0


