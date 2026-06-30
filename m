Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71451C43602
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 11:00:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 48C786B00DB; Tue, 30 Jun 2026 07:00:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 463CF6B00DD; Tue, 30 Jun 2026 07:00:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 353436B00DE; Tue, 30 Jun 2026 07:00:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 091666B00DB
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 07:00:10 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8BA20A0486
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 11:00:10 +0000 (UTC)
X-FDA: 84936284580.28.84F122C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id C2CF240015
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 11:00:08 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BHxEq6Ex;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782817208;
	b=zbAoMxpSxc1V6IHKMJ7hA78WbykNMykPjT6+3SMJc7l72cLdruTPBn6d68f6A2l0PRZaDn
	IIyZX7gdb2anNiJQXYY1M0jYvwSDz0m5RZlSDajG2TRSoDlRMG8Ahb+pvDraWNHwpoPeYj
	8R3z26mw4d++b/4qiKlKmezrKy+PRY4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782817208;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nCZadshr+DzQYVkCBh6cy/RM40zwNi0ZS4nnwSr8GpY=;
	b=mBwOt0hWl82jWkXe5VAqZsAvAwZ32CpZwNXrvP/Xq+Qy+/9svP3jq3UjZatCWQKKw7v+hB
	ajltLYIorafnD5pm1loNVwbK9Nb/7WKwMuVB6wfrr38irWN3J78wCVLMSUAv9J52e8Jli8
	1Knnt+JHzhc4wKphgjvOqNQ+lLMQalM=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BHxEq6Ex;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1F12B40E06;
	Tue, 30 Jun 2026 11:00:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 736051F00A3D;
	Tue, 30 Jun 2026 11:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782817208;
	bh=nCZadshr+DzQYVkCBh6cy/RM40zwNi0ZS4nnwSr8GpY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=BHxEq6ExepayPqMVcba1gAOZBamGomKzGI5/5rbn4FkcDA6n30f9+6e3ho9P8OwWU
	 6+ENTujmQC9oE2fr15f3DfD685ltql5+ulTzniflHu/5xHjg8Eppf3qb9Hh+2qgUDA
	 ME464175cHxtguWUsZhBztIo+dKhzs8PG5IC/96hm29yd4Z0iwNPkTO33p6idcdDp/
	 FjithW/WlildOFWxaLjCMKyGZXhKmpBpkXf96s/l1exvCtkqBxQaNyn0n5UfWOeBNn
	 SVmcV8YVyeBAmrNTxPQHtglqbphZVG5c+ST+4B2ZpMQqg9IQ18aRQQ7t+8J2hG1Npu
	 aIQxG92cvPCBw==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Tue, 30 Jun 2026 13:59:27 +0300
Subject: [PATCH net-next 8/8] wlcore: allocate aggregation and firmware log
 buffers with kzalloc()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260630-b4-drivers-net-v1-8-672162a91f37@kernel.org>
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
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C2CF240015
X-Stat-Signature: 7jz5o7p47tath6xonxirehb4tcuxi6nj
X-HE-Tag: 1782817208-392581
X-HE-Meta: U2FsdGVkX19UsJ8eefq9ZA1xcNo5a1v+zlUaG9gsUwrIBOo6y8wgZk5Jy6n4aOj3o2qtqADNNxCaOduOmvD7VMle9CifQgcffO/kq4Q0ANDTbjLo9RUoskg7Tuokez+jpe29coQOLAJn6KBrQ7adTJRkJKgOSW4s8UijqkHZnz/oNy4Yis09jRf1J7cWcGnSdeUte49k9/XlLsUwO8dxMboG54G+dAtQ7EUKR6TOIWNz3OM0v82Bwao747im90U6XXa2pD+r0NMv3gSrJL0GJIGkgBDoKS08l+W0fLfRDZ4Suug7wQd9jEcZXboS1AdcdGeRM0dvy1GRQ3pn3DTvlK0sw+y2GJhxyjWmGk2fzHiaU6lVMth67FTFetLCQiEMgFumQR6U07nqET3jQ5G3SLP/i3FT0l4fJB4qmxW4eyqL3soPGS4Z2VzmLmHKBvFvoXLBQUsVXjLO0cT1qYorOgS5ZOJL7DjrM/wcn3QR7/EjDpjvwmfhxJIBOK757DbHGhPmGnatmpjQFdQbeAStpkyOx7v6Q7oGUVP1OJ2MKyHk/AO2yXwVemQCZrDs/buLW+S6n+MmtqXBusj5TuWj+LpBRwm6lcBTZVR0EhTE2ax7U2cCGduu0NJNCFNvJEBDHx/QHtfmHmwPmmugpYji4FZtr09Zzarwrn4Wi+dvFVYAXX678qJTAuNwUtIpWQmkU842Ecj/9Sguqj4ms62X5cxihO9VRdlJnzdARK9kLhNbeVebCuUAh+3s382P+uGhC2EhHIwiRu4N7Ths9Dc+/KU5CLxzH/sfCgI12U8DrnNPQqQ1K2M7c/1Fbj69/ICclFnC5rAVJbrsrytZ9cdGulpGjqCFfAd6KdImm7vAoa+ArC2hA4rN8B8iaQfaCdJ7BZoLS2qCGITALcaL8d6c/+5YtfHR7vJZ3+PG/zT92C23Ul+QCn19zBWaQEmpoQzq8OvBfPqxobTB2qAL1sC
 Z7pafrFW
 o2Am+humAfilDujIwddpPU/5Ox7lR3h5YcwuI+e+rTGHloNbjOXuMsfdnRWnqUlW59TwrNecwpIG9NvABlq5Q5+NHdXdzrn1WAZZnrn6LFxGbxKp1KBfay+DYkkWzM4ci6sUgOg7mcDIueQTrxr0i7cFidQKaKZ0xyI6wFSEteZWclAqTb5fuA63GTjW9n1MWTrcH2LNNtZYpFmHnbrSAWjhoA8BglYmir9yDUH6D3IYL/n2ohwhVl+VhPrSh0rUU00IJK9VozxPgcnlQWKCNOqvdiKuGqZWE2zlLspmnMI2l9xtHmF7d47ynn7H/oWZgY1OHceBEwxZX7UtsiR6XLCfyIwmc2mrX7evkfb3+pygP6lHI8lTYYTRslhhUS8b5QVrz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

wlcore_alloc_hw() uses __get_free_pages() to  allocate TX aggregation
and firmware log buffers used for software data staging.

These buffer can be allocated with kmalloc() as there's nothing special
about them to go directly to the page allocator.

kmalloc() provides a better API that does not require ugly casts and
kfree() does not need to know the size of the freed object.

Performance difference between kmalloc() and __get_free_pages() is not
measurable as both allocators take an object/page from a per-CPU list for
fast path allocations.

For the slow path the performance is anyway determined by the amount of
reclaim involved rather than by what allocator is used.

Replace use of __get_free_pages() with kzalloc() and free_pages() with
kfree().

Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 drivers/net/wireless/ti/wlcore/main.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index be583ae331c0..5595f7a1fc0c 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -6354,7 +6354,6 @@ struct ieee80211_hw *wlcore_alloc_hw(size_t priv_size, u32 aggr_buf_size,
 	struct ieee80211_hw *hw;
 	struct wl1271 *wl;
 	int i, j, ret;
-	unsigned int order;
 
 	hw = ieee80211_alloc_hw(sizeof(*wl), &wl1271_ops);
 	if (!hw) {
@@ -6434,8 +6433,7 @@ struct ieee80211_hw *wlcore_alloc_hw(size_t priv_size, u32 aggr_buf_size,
 	mutex_init(&wl->flush_mutex);
 	init_completion(&wl->nvs_loading_complete);
 
-	order = get_order(aggr_buf_size);
-	wl->aggr_buf = (u8 *)__get_free_pages(GFP_KERNEL, order);
+	wl->aggr_buf = kmalloc(round_up(aggr_buf_size, PAGE_SIZE), GFP_KERNEL);
 	if (!wl->aggr_buf) {
 		ret = -ENOMEM;
 		goto err_wq;
@@ -6449,7 +6447,7 @@ struct ieee80211_hw *wlcore_alloc_hw(size_t priv_size, u32 aggr_buf_size,
 	}
 
 	/* Allocate one page for the FW log */
-	wl->fwlog = (u8 *)get_zeroed_page(GFP_KERNEL);
+	wl->fwlog = kzalloc(PAGE_SIZE, GFP_KERNEL);
 	if (!wl->fwlog) {
 		ret = -ENOMEM;
 		goto err_dummy_packet;
@@ -6474,13 +6472,13 @@ struct ieee80211_hw *wlcore_alloc_hw(size_t priv_size, u32 aggr_buf_size,
 	kfree(wl->mbox);
 
 err_fwlog:
-	free_page((unsigned long)wl->fwlog);
+	kfree(wl->fwlog);
 
 err_dummy_packet:
 	dev_kfree_skb(wl->dummy_packet);
 
 err_aggr:
-	free_pages((unsigned long)wl->aggr_buf, order);
+	kfree(wl->aggr_buf);
 
 err_wq:
 	destroy_workqueue(wl->freezable_wq);
@@ -6509,9 +6507,9 @@ int wlcore_free_hw(struct wl1271 *wl)
 
 	kfree(wl->buffer_32);
 	kfree(wl->mbox);
-	free_page((unsigned long)wl->fwlog);
+	kfree(wl->fwlog);
 	dev_kfree_skb(wl->dummy_packet);
-	free_pages((unsigned long)wl->aggr_buf, get_order(wl->aggr_buf_size));
+	kfree(wl->aggr_buf);
 
 	wl1271_debugfs_exit(wl);
 

-- 
2.53.0


