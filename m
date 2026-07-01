Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F535C43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 13:57:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4625F6B00AC; Wed,  1 Jul 2026 09:57:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4133F6B00AD; Wed,  1 Jul 2026 09:57:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3517D6B00AE; Wed,  1 Jul 2026 09:57:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0F3F86B00AC
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 09:57:35 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 91EB21A02D1
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 13:57:34 +0000 (UTC)
X-FDA: 84940360428.13.FA088A9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id E8D89140003
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 13:57:32 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=U6BFggHO;
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782914252;
	b=fq6LA6vOb6LQDvFFgJgNIoyDYAidZy/3wCAOGpRi6VXzMYDQUarVzHNvhPKjmvDic6ouQd
	E3SCRrylafwrGMq2NDOo+rrTdRQODC0KX6WCwdhyzy+65NpxFJ8RpTrV+6sDGIFCpWysmz
	ZGNJFYVK4x4kzaTUkptshSMXVevFIOk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782914252;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Iyk9farFukAIvKGcWCVjubpPNe4OtJIT0B3fPfHAcek=;
	b=Ih1sT6+mw061UQ0MuDitu+n/NyzL6jljZtLxTekdZZ6HGk8f6t13HPqcaqWkoSob94wXBR
	THrTGlwsNmrIj3SekFBzDMSXzWCttAQiiZci+7SmxsFKFohl478kQhneQDgZOGC1wVHEv9
	RTFkchKhuDjxtmq+Oyi/+8pKuU7p+mE=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=U6BFggHO;
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 854D1601DE;
	Wed,  1 Jul 2026 13:57:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C36391F00A3A;
	Wed,  1 Jul 2026 13:57:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782914252;
	bh=Iyk9farFukAIvKGcWCVjubpPNe4OtJIT0B3fPfHAcek=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=U6BFggHOgvcT6jnqIHNAILvtyPmnjoDU8/r6T3eutVDjMHU2SA1lyN1sKB5RVvif0
	 m5/DOfgFr5ToAzwy0tvh+L2syNb1eCPp4fVX2CEOl5pFvd7Va1IBXmNDfJArzGcwsD
	 cgqB8KhDBRXsleLlXezhAYJyRrypFpCfgfgOCR4Njze1F6see57I7na2GJrbYCi6yU
	 gmFPDQNvTkx//l84i4La94Ia4mbGOc6YoRrF3eUJfiaUyr6G/bIhDUzzxblI3XBSbs
	 /z+9cBTKhHbOnnl7eqSY9UK/VFOFV1TeKquJBAepagX43HEjRzBlTcUTSvJIqxIK9n
	 NKZ/yW8tupQ3w==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Wed, 01 Jul 2026 16:57:19 +0300
Subject: [PATCH 2/4] ice: use kzalloc() to allocate staging buffer for
 reading from GNSS
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260701-b4-drivers-ethernet-v1-2-58776615db6e@kernel.org>
References: <20260701-b4-drivers-ethernet-v1-0-58776615db6e@kernel.org>
In-Reply-To: <20260701-b4-drivers-ethernet-v1-0-58776615db6e@kernel.org>
To: Andrew Lunn <andrew+netdev@lunn.ch>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Manish Chopra <manishc@marvell.com>, 
 Paolo Abeni <pabeni@redhat.com>
Cc: Edward Cree <ecree.xilinx@gmail.com>, 
 Przemek Kitszel <przemyslaw.kitszel@intel.com>, 
 Sudarsana Kalluru <skalluru@marvell.com>, 
 Tony Nguyen <anthony.l.nguyen@intel.com>, Mike Rapoport <rppt@kernel.org>, 
 intel-wired-lan@lists.osuosl.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linux-net-drivers@amd.com, netdev@vger.kernel.org
X-Mailer: b4 0.16-dev
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E8D89140003
X-Stat-Signature: y57yoefn3cru18kqoodc8c5o9csnumph
X-HE-Tag: 1782914252-574109
X-HE-Meta: U2FsdGVkX1+/85ijcQnwqBim+9TW6KGWRftPc6NVQm7dK+bWYVP+wvr9J+cRfS5xyuiq0/h4cKaPyPy+wHtcmV4JFrVfpaR4+ci8RGOhKc5uOI1iYu9M6CHL0r3MVHKdOrhN/N5RBHqAYN4wOuNKxOkGCWND5bc7HOyOZMDkPs61yUUaDhcB+g9jzBRikrxCf+QZpVDlyMHa9iWkcBmqkLNtjaQQ2fUwCNxtT7I86anV7FqdSGX3/srUZCO7rC+77BfyCvE2Yv3aE4d8tZdvgGNj5IL694IxNMWpfbWJU1kRMzbsZZPiJvfwbIfsnFo4APqlEFu5e31I/x+SL6LgXSVnEMx/KmDezMQaTU8sPbMjFIJa2zT24eAohGTc/HSJynYGIQB4BFrPN46c0f9ASIquNMV+yO/93bWXqR0PGAAfDz1jL+P+/k64CbPWc+uv052lOLA9BeAXfk1ueTpU+uMsYvRanIEfQ4PbWitQJN32pKifKn4AP0LgQ0cVGxwjYuf0S779S/XDAPx2EzwJ+F6zbrRyxvHrJEun1LnIPof9Udi3ltEUTt9UFcpv2yKTJS3NI0ZKqypCYxlzecXBmZApqmzn6zYalXwFXcJoUQyHlfLH2KVueuFe8zNGrTikAmla+5190xRzQaQJdi/FeDkq5nAAxj4jn2ZayNaHSh9qTpgkPkgKwC421OsqtCsPGoWVCmzh2/xmcf/V5AypQyzR+0krUvMRxoz6sSEIH06Dc2diIRcSoNJPXlipa3+uXFAQSeiMFJjLAnnlfNu1FCWVJhihV87iGuDhEYDk8ahF6ArlmD7P5jFhbALdWodvILdScg8X6zbe2hbNgzPYuvwwpXTV5I45r9HDMcl5vPvPYBSqF2VBgc36fsdc8gELZLdMETj8SX2l8VaaSJNHHwaNQubw0kx5geG6TkMRZZuqR4d946VKQBbhHFUBZr/1sNNK9HrCqYvi/uPbNWF
 OBPdpQm8
 kaSTZGrbYljICszCah9/ELUDvaTvFHzqkMhNYoKEm1j9qFCAVpvdX/uXfaj/N92OxAFzr5UPxHsoU8WoBsJ+6mPtORBeXYaIC7SCvvnzLElIWcIxJx0BKZNxh3/tunnPAVt+yZmIsInjLPqDOlp/MLNodo7iJu26gQaybDbrMCtbdT7Bt0iDbGDbOYOrvdswTk8nLrNfseLSAl+DsdRxNdmZhy+Az3Qd/rArzoaVk+x7MvoZJdniDAposgtp0Xxc99phw2mWM+yyDodxylhprR7Ka/0rSbGV8hA4JkzwNJG35Zyw2aJz/wjRk1v668AxW0qISJshVbOHhdpza7UFP6iuyXedossJRjbfF2I8QMJrNtYDoXwvp4E2e2sA01m2cswrT
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


