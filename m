Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D6D9C43638
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 10:59:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 269656B00CD; Tue, 30 Jun 2026 06:59:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F2F76B00D0; Tue, 30 Jun 2026 06:59:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E11D6B00D1; Tue, 30 Jun 2026 06:59:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DC7B36B00CD
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 06:59:40 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6203E4046B
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 10:59:40 +0000 (UTC)
X-FDA: 84936283320.06.DFBFFAB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id A530E40008
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 10:59:38 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MXQEF3aH;
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782817178;
	b=eDWGSoOCSxlUEjzxYrz7ZkKOCPwb8TSOQSpgYTlsvFXx+NU8c+DZ1ASjEQ76M24Ur7FmXD
	fzOCFBoBWAiFUGcrWX6zvPUCUWpA1nnDHYyDA4o1dy1zcxj6y6t0GV9REnrJcPjOUwxcDE
	1GsT7ErUdtsKnOGLh05coLcW1mKs2pM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782817178;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KN3v4O8jkhd6Mt2HpgZaziumJD8qk36FkI+IylasYd4=;
	b=wHWcTKDxy3Y3czTTKz2+seJEr6dfPx3wX6j8A71X2Cr+DtIv2gPDBmaE4NAoECqJ2eWI73
	bdMOS1893DalTGzQWdJtQVQbEO8L6ZqYlb5CkcKBJefwior+qswK5Z1P6QIuuobd/8YPyj
	4s4eQATO/k2V4erzio9tH6oYOm2APjQ=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MXQEF3aH;
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DD18941711;
	Tue, 30 Jun 2026 10:59:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 403D61F00A3D;
	Tue, 30 Jun 2026 10:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782817177;
	bh=KN3v4O8jkhd6Mt2HpgZaziumJD8qk36FkI+IylasYd4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=MXQEF3aHWSiWNFSvYXHU4R7tW6cLU800PWaoSIs368VJxA7phfv+Es8c+cLkEeAW6
	 N+cXvy7GWxnDbC1bFm9jgfCrZuJ7NcmOzPRxV0f8rFe0NonrUKVi/oDpm1r0R9GiMH
	 cFOmtV0Vf+osCftv3+z9BekM2fYxe3pkef2/XzhRaonSJCjH2k1BUQb+abz3ksERB5
	 ID+PK5GmcE2FHvH8VaVrrDkXHHS9PnbWWtmKluZc/es6TuUdTPfONxggTOYT41WBK/
	 yoD9s2qt4xuVYdBtBHU1XDZGLStlv3wqrZawLDg0DkelNXb1Y5TLnaXGaGmtkKIZNf
	 utF9NJfRkg01A==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Tue, 30 Jun 2026 13:59:21 +0300
Subject: [PATCH net-next 2/8] bnx2x: use kzalloc() to allocate mac
 filtering list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260630-b4-drivers-net-v1-2-672162a91f37@kernel.org>
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
X-Stat-Signature: gmprde7sbinw1wbphm6ktf38heskgmcu
X-Rspamd-Queue-Id: A530E40008
X-Rspamd-Server: rspam06
X-HE-Tag: 1782817178-303893
X-HE-Meta: U2FsdGVkX1/qd7qu/fgz1zccXiCyK3wNjB9Ix/0KP5H9K2+j+UbgHKty5/+VM9FStjPJffcYrZebUPBdenWWtQCzb0iNGJZdIwUjsQyVc3WZRQGXwBHpDsDAdCyEygM+bfZxsyNhbp0MPMtUx1+/qWzViE1t4Zo/VhzCNIrfPiVpn+NiaV4DwTF9m3UvwQs9NbtnyNppN/75BxQxmQtduzEVkiXzXLFObkdgup/THu4BrGPIIETBheVLFFLFZePGA3RP+piW3sfLpJYIrmazCFzf9bdVdqqPW0wjGVE/zbT7RB66AuvWD7EPTirsRCqmKLGtDkAMTRnD0iaK3oUMtIIqC5BHm/q3TaDoM58Z5rTgx1acAjmh+4E5Xr6IMhhtIvItiPSeMKOitiWyPVNHeDbvkeeFOvCljTkOEmcTwBhC9dnNNuEDG36uAcpuA4Gw9VvtdF7fekt4jdQqL6XdkAsw+lUx8ozRvHOOO8icxykcIJbApKk9YMEsAYZjyBGN7ZRnVNQfMMjrlQyAHWfmvk4oYZj044leYmGMrlt10pBCV9RxBxCn1LGwzhgEZ538FXdVhr2h7I8FJ+vb6dGxR6Jc856Tt9/lf7YXLbOE2huRafREnR6MCjriHKOYORf06vCpy9CNXn57sPuKfK8rDMoija+ZlY5JhsIvq3OugzRWzd2Ry0QMRPWFKroz5zrFpY+PoB8ksglZmjaPYsFPj2JxewVPOGDr6lUJddkLZ6VCqp3QU9NedrkAUeWjt0MKvTQzpMWjdv9IbuaHiC+A/t4NBmv0f7d5OFupwbL60aeUfbjJiS6LDC0vW9pM+oOB/OTI0/DrF2XG1gxQ6Gf5CHXmJ3ny2f9V8xaiQoGJbo7deVY2EAI5kjVSduC3AtXgFwBAsrafsIWNOIP7YNwzBhGSgwsjmgWsNug0MMQUSM/ZYDV8v3HojeB6LQq83w5ByaX5R+81eSIgJw32dUk
 4KnINo5+
 r9IsKEM3NT1yeDndesgy9sf+ym4QgJtfrX07C14u8xCSXJnekuDpA1X2o6r2JoWGwDM8gAYbDuXIpi744BViJ8nJVfkjxG7OSZOJNduxvvqGZEQscSiMkVQgLdbX637JlC3sbsar4upUu8egCCjaWPALVcV4vDyGRkBYEp3GEpEVTU3KlAL2RlSPM8IBzI5tLD7TeJQFkJpnk6SzDFCHftT9XYii5OkjT71MjYH4urGUh/oMZrWWhQ5JzTtOsaVCRusjcaEV3LAh/tDvUY/mcRMZRVXKhuvaLAamjU36LRuTxv6U6fl8jaSySRRELT6RGk82sd2AAp/Erjd3MlmBex9m4e+85arB7AHsrKYrwO7VVKVlKpekrYS6aKx8TgTANkABr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

bnx2x_mcast_enqueue_cmd() allocates memory for mac filtering list using
__get_free_pages().

This memory can be allocated with kzalloc() as there's nothing special
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
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c
index 07a908a2c72f..d560524d317d 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c
@@ -26,6 +26,7 @@
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
 #include <linux/crc32c.h>
+#include <linux/slab.h>
 #include "bnx2x.h"
 #include "bnx2x_cmn.h"
 #include "bnx2x_sp.h"
@@ -2664,7 +2665,7 @@ static void bnx2x_free_groups(struct list_head *mcast_group_list)
 				      struct bnx2x_mcast_elem_group,
 				      mcast_group_link);
 		list_del(&current_mcast_group->mcast_group_link);
-		free_page((unsigned long)current_mcast_group);
+		kfree(current_mcast_group);
 	}
 }
 
@@ -2713,8 +2714,7 @@ static int bnx2x_mcast_enqueue_cmd(struct bnx2x *bp,
 				total_elems = BNX2X_MCAST_BINS_NUM;
 		}
 		while (total_elems > 0) {
-			elem_group = (struct bnx2x_mcast_elem_group *)
-				     __get_free_page(GFP_ATOMIC | __GFP_ZERO);
+			elem_group = kzalloc(PAGE_SIZE, GFP_ATOMIC);
 			if (!elem_group) {
 				bnx2x_free_groups(&new_cmd->group_head);
 				kfree(new_cmd);

-- 
2.53.0


