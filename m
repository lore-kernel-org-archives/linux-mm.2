Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6EF88C43327
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 10:59:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2903B6B00D0; Tue, 30 Jun 2026 06:59:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 267426B00D2; Tue, 30 Jun 2026 06:59:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A5656B00D3; Tue, 30 Jun 2026 06:59:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D5CD26B00D0
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 06:59:45 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 51D1D14044F
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 10:59:45 +0000 (UTC)
X-FDA: 84936283530.22.994BE89
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 9F98F1C000B
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 10:59:43 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DgtHvom+;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782817183;
	b=J3q5OFT8w3bSbRVobXGH4Kf/Uy76hPwYVDKr96ro62VXk2KVNlPMKZ4vUof0oZZJCW19Mh
	Eod6edIS/cXvMnUAQdeqQYZtX+ot5Dg1swZRt4M5haJin2/RT6l4TyN/9GamfsHjbc+nhm
	oGAADcpXmE+I+5kP063lRyR1PjeQOC0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782817183;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Iyk9farFukAIvKGcWCVjubpPNe4OtJIT0B3fPfHAcek=;
	b=Ssb6/3xZEdo7F+GNa2FYNzCaE20KUf7miTuUzZFVg4seOGuiL7IYQehPFPndzdhsvCFwJC
	/v2QFOQ+Ywprd78qFbvUkiVd7qmdeyrhapPa4eA6GuDwp0Ghuu5O9sqU6TAVmTwpCzUlC3
	cragp4plYoKOfoTzfS+8unJDT1jfRi8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DgtHvom+;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E531341711;
	Tue, 30 Jun 2026 10:59:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 483751F000E9;
	Tue, 30 Jun 2026 10:59:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782817182;
	bh=Iyk9farFukAIvKGcWCVjubpPNe4OtJIT0B3fPfHAcek=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=DgtHvom+XpxZXXgnBz9yJtGhfbx53DMTm3ffkikikYQtwt3tKs2l3gb0W9BGYsxFr
	 HBMmkEkqHjLTrCQSdfgOPCoqG8pLs59vVpY0RhShTSDjPiccqeO5eLAh2KzloZldjB
	 9aQB/cqqC5E01rOsg5+4e1GjyJr/Mqxg3CsHsbce9L7s1baDkgwVpzWQjdt8McI+gi
	 tIoYZb5Gxfgsm1yHnCPN1NEXfJ+zehRfkmNSrkeBDoxPX/B2fvjXhFo93wYmNxhjYM
	 HB5IPDc4Vq1cQdfMn2rOXAQ8BWdAmEUSqtfEwRWxSf5CT9AAGH1bqQISufWjD7MsMw
	 Z5dTleKHYc+8A==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Tue, 30 Jun 2026 13:59:22 +0300
Subject: [PATCH net-next 3/8] ice: use kzalloc() to allocate staging buffer
 for reading from GNSS
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260630-b4-drivers-net-v1-3-672162a91f37@kernel.org>
References: <20260630-b4-drivers-net-v1-0-672162a91f37@kernel.org>
In-Reply-To: <20260630-b4-drivers-net-v1-0-672162a91f37@kernel.org>
To: Andrew Lunn <andrew+netdev@lunn.ch>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Cc: Brian Norris <briannorris@chromium.org>, 
 Edward Cree <ecree.xilinx@gmail.com>, 
 Francesco Dolcini <francesco@dolcini.it>, 
 Manish Chopra <manishc@marvell.com>, Mike Rapoport <rppt@kernel.org>, 
 Przemek Kitszel <przemyslaw.kitszel@intel.com>, 
 Sudarsana Kalluru <skalluru@marvell.com>, 
 Tony Nguyen <anthony.l.nguyen@intel.com>, b43-dev@lists.infradead.org, 
 intel-wired-lan@lists.osuosl.org, libertas-dev@lists.infradead.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-net-drivers@amd.com, 
 linux-wireless@vger.kernel.org, netdev@vger.kernel.org
X-Mailer: b4 0.15.2
X-Rspam-User: 
X-Stat-Signature: yg54uo6zfyd6yqtfn47qn8ywtj17dqj8
X-Rspamd-Queue-Id: 9F98F1C000B
X-Rspamd-Server: rspam06
X-HE-Tag: 1782817183-735013
X-HE-Meta: U2FsdGVkX1/j7uYOdMtPHNPPI0XLJKgE0R8vVA9kJD2gt4qAS2wqkDpyRW2YenvgsYZLh1O06BygupybNBooxnV42WJaHvciG0V/ui8OpMc96HrdfIFFtfYHgUwIDkdbbsKxQPlXHkWb5ZCei+e1HkQrTnTHDtJ4mb3DPWE0TrCDzJiq/vt9AW49zEeAEnO67sznotMFyiPGYUwe4cBln9tnEe+l6G9rH3Z7IPThEJRSrVcoLFwX3uJpxpWHKPuiOrwiEsT9X/EHoMOufV5J8zu6KiLFadsbL/P+XccfazgQ+Dgg8EasmrtNWsKciXLE3oEpirmZ50oOJaBtDRsitXTYo2dJNBD4OIy5mBEY9o7oZo2p9EJGXjrwOgO+YAE0rGftloSu+pvtVAekUKOfbki1KwnSexIKJPVLzUS9xJhOmjUn+dFEZG/oVwSasDCqvlPLO9htZRbCYflt6O/BZyPNOnYeKi4kLXttlq+/riJOjK4tg9NKkT2pzMp8gO/VK19CWUGJbZKtQDiVT12Nlnq20a/Bnva/XmtPc368pQfulJtvy20Dbyd9mNtmJtxWp1XMIw49Mp4Jm+/7Y1aEF2gL5fqoZrxz3PH3M5yDdwNmaWWxZWXgeI3th4qhghxUXc+fiLOrA7mGsRkcbSz9z630PYJLuFxqAYguOLSVTVx5otctTUNd7EMXWhEgqapcIsge5TZwQddrikSEK/sBEzw33/UP4Y8SAR5fHuz33Icdj1Vaq39QHM/4io/NkfaidDa2O+rgugGGOS5fd9ygbymky7bFSkEG5P+XYy5FrymJ5jA5Jf5Vl4zqlMGEofVt5S0+2RoyKOAwNgEKrtaWYg1L56kX9heEN/KOBoZ4G5+HCH2CsEPfZFeOoBf62QnKkBDA9Em1Eh/AcPhDTjucXZN1xCkbw54dT7jHA3jNcRDEWBAUaS877mMiS4iM7AN1qR1aYxg3r244MD1BTgZ
 EvS6Ov+y
 OnBTt9QHavSkM4ZN6qZLNe++fafY8/ZWYs++OAbxxyi9uB9GDem8lIJ31EZS/D2B4O381Dcxkmtx+VL1qIF5fVfZUwOD8rs/2Wuw+cjuEvJM7RRJYx9yG1vxPv6mi3JNRO5TC0v7MExt5QqBH0RjsXJlkxeya51lbbovmJVIvM3FgxplFc90IYpxRqzwNEXC3ecAXOlhbiq2VmNa8M2wDKUeMTbj4FqvFtRbVTuTo3M+8iH1o0KTK127fcWmboNYfACoygryf0IZ531DquNtO47uwuryTECC8o+2vVOZOwmrGXofOitINLiT8bVK/x6plF8nxiRUk67r9AIYz0ydrKZVclCoJQg5+mE/ozolPQFrAAN9KLJcDIcvQPLYNb/CLPqhE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

ice_gnss_read() uses get_zeroed_page() to  allocate a staging buffer for
reading GNSS module data via I2C bus.

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
 drivers/net/ethernet/intel/ice/ice_gnss.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_gnss.c b/drivers/net/ethernet/intel/ice/ice_gnss.c
index 8fd954f1ebd6..7d21c3417b0b 100644
--- a/drivers/net/ethernet/intel/ice/ice_gnss.c
+++ b/drivers/net/ethernet/intel/ice/ice_gnss.c
@@ -2,6 +2,7 @@
 /* Copyright (C) 2021-2022, Intel Corporation. */
 
 #include "ice.h"
+#include <linux/slab.h>
 #include "ice_lib.h"
 
 /**
@@ -124,7 +125,7 @@ static void ice_gnss_read(struct kthread_work *work)
 
 	data_len = min_t(typeof(data_len), data_len, PAGE_SIZE);
 
-	buf = (char *)get_zeroed_page(GFP_KERNEL);
+	buf = kzalloc(PAGE_SIZE, GFP_KERNEL);
 	if (!buf) {
 		err = -ENOMEM;
 		goto requeue;
@@ -151,7 +152,7 @@ static void ice_gnss_read(struct kthread_work *work)
 			 count, i);
 	delay = ICE_GNSS_TIMER_DELAY_TIME;
 free_buf:
-	free_page((unsigned long)buf);
+	kfree(buf);
 requeue:
 	kthread_queue_delayed_work(gnss->kworker, &gnss->read_work, delay);
 	if (err)

-- 
2.53.0


