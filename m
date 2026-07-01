Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5A55C43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 13:57:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E0F86B00A9; Wed,  1 Jul 2026 09:57:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 991706B00AC; Wed,  1 Jul 2026 09:57:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 880A76B00AD; Wed,  1 Jul 2026 09:57:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 55D2F6B00A9
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 09:57:31 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C3BBA12039A
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 13:57:30 +0000 (UTC)
X-FDA: 84940360260.14.935E138
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 201C840012
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 13:57:28 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KlniPm7g;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782914249;
	b=TibU8Fg9Jcu5vDFj54EC2tc5kL7CKsNnkjlAl2gBNecZDQAyh03xmrpchr8nxZ3wNz0zSS
	BIDqZsodPsbbXnDb4NrnZgoPbnpp9E+u00xdtc2jZ74D0fyG4gxlLs7DCn7Gz10Y/8ZMz8
	p05yM1qAPk7RfVesXry1QQA8V9DPpUM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782914249;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KN3v4O8jkhd6Mt2HpgZaziumJD8qk36FkI+IylasYd4=;
	b=nD+9ItMZ5ljXosU/jtWoqmiQv9h7k5Vdf3aiCdaBrWC+JLKmeA/AvPh7tG1gmATpysOzGk
	OJE16lgOj/QqOBCeORHs1D18cB4BKfOwBV2z+VNG7eOsHCT5aESo4fHj/14vTMxnmEG/X2
	8GaHQNobzLjqhsfpSwABOyMa8jFxQxA=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KlniPm7g;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 91EBC60122;
	Wed,  1 Jul 2026 13:57:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF9FC1F000E9;
	Wed,  1 Jul 2026 13:57:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782914248;
	bh=KN3v4O8jkhd6Mt2HpgZaziumJD8qk36FkI+IylasYd4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=KlniPm7g68QtWZ0ZI9P+lp3JUjV32CfOcL+P0rwGBBPnR7YemV6QARFIlMBom7Ft2
	 hg+UXCYHwEMJfnINZ+cvQYZ2+Tx2E1sF9CLPJSZbS9/iJa9EAD3VFKNZHhuUfFv4h/
	 bjenyY6mkL36a02MkyvLbUf8OWfNk5KqEgFxqkJpda74bg7w3btOfpXfB9Xrbv3Chq
	 PE5b8Dsablj2qQqu/5Z0viSA4rkhgtGLq3C1kqL33o3SsCQ0rOotmd+azQFlkyCnqP
	 wMq3kV+j7NIZUxi0pBzmzk/HNlVf2GeUrUj4tyvCR23R70TuTnD/ouuREl2EBNGope
	 cPqa7hslPkgiQ==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Wed, 01 Jul 2026 16:57:18 +0300
Subject: [PATCH 1/4] bnx2x: use kzalloc() to allocate mac filtering list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260701-b4-drivers-ethernet-v1-1-58776615db6e@kernel.org>
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
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 201C840012
X-Rspam-User: 
X-Stat-Signature: mmwp8d7z1e3upkrjs1nt7c73mtsoqjkn
X-HE-Tag: 1782914248-251706
X-HE-Meta: U2FsdGVkX18t4yPlmf0BIvLFPbDw7z10UbQp44tmVjujWpNTaz6uyYXj4boR9LqWg+kQDNf2ADeWmyh4iFoLvUWzQYWn/fgBmJJeSkb0I00m7zkWtQtvdqBltzArzvt56ytROEyvr8jtpUqRfpaQVcwIFSIj25QSyPSQoKaFuwPiFw8CO/MaVVw42cHRviGDBV21VSC1PqlLRpXU8SwL8tVtbSXHcc6ouTWcdW/8+inJUqf+/2jx00uv3LindYneV6izTdIsa4d13Eu5P/4p6RQklrw5YDUyey6eLhi/fZfyKRIm6tQ2pRZWuK0Y3Joz/HaBdCqTOtW17MtQHGnz4FcGkYpN2IMD8FaJvPtxqeFAvh77pBQPRMR0D2ehR6XdEE3GMt1sB9mSQVsleBjl1UeYIiplF56TZxRawCkMCM9ojYckP2Nzo4Chasc4aVJQHcUMQBHoR8snBrIwyR3EDDwYZkbHj6cpIDfI1x/4xSelGWkmKtLEaj6DsZu6D5ud4g3Pe9Sa80dxmylRzip4bqwpazq+K/LyXdjQpAvGHGvPl/NPZzK4pQvMwkemcb64KuCnchIaEjLQtQ+36TC6lL+VnQgVyu6KoDyUA11vgyEr4kV0Xzu7PQ51k8wXUYu9IM2sezEhCAfWPxw9ojDL9OVr4l9oxuNbcPHn6N3fWGjkEquGxlqQPEVXww83DSh8uAGl1p48jUGyQsvAULyhx063z6C/kSX1hmaL0hQQNI4v71yHGTwoIHBg6KI2A1Dpp85ExVjy5tZNUlnwINFlxxnhXl3a/jOS7+QoDmMv2sTU1RmbTBVap8Jr3CwcJQe7pvKduT0yR8NQd2MFEritKrYKJ95egpgnsWqwLFy9ihQntig7MI7esum8JdZhNW/nKF8Aaoo6jqZHJe07Xz+0ySaoCstwRUU0DqF68T8Hf1kyBq8eSKNYeIXmd9CxQY0Jds6a2JKHQx0aYtF9Tdo
 WhQ2PK7b
 RTNkQvNj6W4gLDrcIrSXeB6oYy99nLFajJ0amoc04HgR4Et8K51gNn0NI+CeoS35065ZjL8uUluXMykAUaw37z5VmIEnN39vPnvLUv2lFUcEqf6ZMDT2Izl98JJvgoTBwMTV9xCFdF610rTZaUFaOEBXytSSyRsl5kJcpM02xgYOR8UV6hAQmoOyIezpapy0nlYjbpFDkHyU3ocOJWfXNNAtNHt4pxVuhdn3ShtM9/IANgPnbDOD80b79ZMhon0ezR6e7P8Sxen1AytIeGV8KxD9Axk7dzxlO+wsT29XhAVYZ2kU4KI34+kjDAOOWZX/P+9om4S/NM1pAPALbUUR0THCjLrlTtxuMtmu3QHoKQAgngoa1akN2lGbJu/m+vwxn+/10
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


