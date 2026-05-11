Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F664CD3427
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 08:17:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 81CB06B008C; Mon, 11 May 2026 04:17:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 70F7C6B008A; Mon, 11 May 2026 04:17:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3DBB66B0096; Mon, 11 May 2026 04:17:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1D3116B008C
	for <linux-mm@kvack.org>; Mon, 11 May 2026 04:17:43 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BFBF6160668
	for <linux-mm@kvack.org>; Mon, 11 May 2026 08:17:42 +0000 (UTC)
X-FDA: 84754435164.19.C886AD8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id D02161C0004
	for <linux-mm@kvack.org>; Mon, 11 May 2026 08:17:40 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TNVFxvoV;
	spf=pass (imf20.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778487460;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gH4Ng5rH5X9f4Gw9w6ZfbhyL+QTkpBMvvMY/u6WCdow=;
	b=itHjutuHQISssFMqi8/svMgrT5ZFOtEl/gakdKbvMC2FxOQspGVWcH5aA9J2DwyXXIe7iH
	BB47/TH2myTwf4TuMoTvJOM8wD56I7aeEcdgoyWTblyD0miXqCD1T4nq98y6LVlfU/us7c
	34NGJV8QIY5DsUDqE9yc+K2mav1Kr34=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TNVFxvoV;
	spf=pass (imf20.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778487460; a=rsa-sha256;
	cv=none;
	b=mLhem9ngO0lqQLD0MdAWK4yclxZaIEN0uQ8sbpnScrXIuFN5jzyfo8TLs78zK02wjSbBfg
	lSbsUQOzG1OvZMGjtC5gjjccUwiV6sKXaUxyCOQZOz8fbOJGwxQ6tVmeCUqX1D1sydLWm7
	3ol+UhYKe1JBtS2mNvP8y8wse46AKMs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E346A40AE4;
	Mon, 11 May 2026 08:17:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C372FC2BCFD;
	Mon, 11 May 2026 08:17:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778487459;
	bh=+Jo7ZBrr4/gMgS1hfJFlO2RVkK5ROniR+PDpelGSBTY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=TNVFxvoVsDGagYqVPlBdtgcf+b4nTZk/C3KQnJWMQR6XfwdJxVm7pR6qCSccZr3s2
	 WEwrhmdpwX6HjbFmtNdLN9hCizPNkmgdf6TY5cVTtBechxPgZUXMKmWawade20f2HB
	 1q2BM5QHBpgHVchrSC8bi+yDLmedwsAxnXmaLtRLL+QcD0ZAR/SgQYBv+eX2RaYSCe
	 YwHm5HDxNp7IoAW8pT5SetNeWdGu28wt9ogo3UIWfH9Wz3XQa8ppiVMo78r4HtHcTw
	 BLl86r6ILDGxzFZuGPNxDVHnQ9OOneBzEy26Vpndx+3nWbp1PMKdv++z1AmV/ZiX2D
	 8qlrCEG+83whg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD5D9CD37AC;
	Mon, 11 May 2026 08:17:39 +0000 (UTC)
From: Shivam Kalra via B4 Relay <devnull+shivamkalra98.zohomail.in@kernel.org>
Date: Mon, 11 May 2026 13:47:31 +0530
Subject: [PATCH v13 3/5] mm/vmalloc: use physical page count in
 vread_iter()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260511-vmalloc-shrink-v13-3-643b7ec277a9@zohomail.in>
References: <20260511-vmalloc-shrink-v13-0-643b7ec277a9@zohomail.in>
In-Reply-To: <20260511-vmalloc-shrink-v13-0-643b7ec277a9@zohomail.in>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Uladzislau Rezki <urezki@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Alice Ryhl <aliceryhl@google.com>, Danilo Krummrich <dakr@kernel.org>, 
 Shivam Kalra <shivamkalra98@zohomail.in>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1778487457; l=1325;
 i=shivamkalra98@zohomail.in; s=20260212; h=from:subject:message-id;
 bh=0/E2gQvGxEo3eGw/8wt9W0DQApE+QcKjBLa75ti9yYs=;
 b=KDZ8dim5ESybiJyOGbwcOhc1DmY5tSwZqA0TstiryUq+cc1v4bqjKAmKi/l3UjbFw+8qZij1e
 rmWpniLO2UoBwyy/+uajlyh+a2vwajeXbgiu6q3QKpj22mSFi8QVYFi
X-Developer-Key: i=shivamkalra98@zohomail.in; a=ed25519;
 pk=9Q+S1LD/xjbjL7bEaLIlwRADBwU/6LJq7lYm8LFrkQE=
X-Endpoint-Received: by B4 Relay for shivamkalra98@zohomail.in/20260212
 with auth_id=633
X-Original-From: Shivam Kalra <shivamkalra98@zohomail.in>
Reply-To: shivamkalra98@zohomail.in
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D02161C0004
X-Stat-Signature: jyhptr4y9hp5dacc818r4tf1pjcxwu38
X-HE-Tag: 1778487460-930268
X-HE-Meta: U2FsdGVkX19lDuQNf+VkaheJnugcA5GK2EFGLq80WjCN6ousasHPL4yWjuFVxsEeedn5O+y6jPRxhBbflziG48hFrk08tA5zlyttrErIfLOs/h897caC/tbqNNhCAUxnQp0V/jS38J+8ZzTjHIXw2TkNtciyXc8eu/E8jCPQeG7mz/JU1oNjc7tRMd4yOtgryEo2D0Mb/hMApanpX35CKJwQNfQ6yCsByjHijDreNIF2tpTlV5XBC4dzHBlq6/B40eZ41u5Dzknof3BB43SxlmxEDHc6ute6yT8Qz/qorFPMqt9m6Bi5xUQ5YIFJ3HB2kOK9ZB5d8Anx5FLEsryKr0zZPlTNjinVsR3RNPFe6ESN1w5b8YvBwWVXNrM/BGL3UCeSDO78QTP0Ts3L8OYQL4NnURQNVyZMABM4XwAkRNUtEPycMCLtHuYCBSBZo9BUVZJxZ+DlfUKbSy7iR6kKxYVkIJJvOq9yt1O/bp+HGMZLstvOz+b7a+OJjaP4BN+bbiVkeNvpdymhATSmKyw1VA2Sn8OXkzgU7r4UmyUcMJ0W5ewFyghfwRxrZmZcPAJWo0VlUTKo6cQAlEGpchApVBFF/O8696hQioTsFDNO598MLiv3OoVCqVrKFiNB4fBhQMic41NIvfZSM44laBvE84SbJQZQCMrrJPjxL1Mpxiv5awT4eu3dHws+wsyzTtfg5ovQ5istsDHd/UoL1lb2XN1MseC5SRq9osdJem85ERJBO9vXCxdRRDrMsdx02IrGt7ushg+kg8tTP7F0+XtosqKPSrRPhAGFSRRWeOgrAh2JX79MQ4Z10qw8ZDVlz0XRr7yGAzDAbKVevFstm+IsTZUgYO/e+QbIcq4jH+ir9INgflViNX4KI2NR6QMPtkRA43YSZfQJJN69IzI6HWJ0AhW1ojXpfM2Q/bP9uulOpL026DQHvpAK7LfNhbbBz8+fNDPPIKiiazawniwVlgz
 us4Dd8On
 23csrPwnN1j5we4hD1ZiwZx2upDNgRp1wx8ye+WSXtgpGUjENvcyOfjvhWI+uSsUNe/q6IiLrwHhKgoyhfbrTpZTQnQUWSkcVY1LHoUiMzX+BeFYRLVIvYz6IttamLHOALTpnTp2Q6oucYaVOEbggcssdZQIRcsK+UjHGkmtfQeodyn/radHK7rR7C0jW7gkPMltWF8hdnolqK+lMu4+T8d+gDiueTzGxPHwJ/k4rICCph2Kl9bKAOfRWYdotKOVN7Si9VyO4WHC0PSTbxu/IvONQkBQLbT+mZrc2qkGxSaGdzZoRaJTYrqpplVMQT+q7vrKWpa8jvPkABzAtGoeBBwlTn8CjX5nXxaA4hZ6+9iWUZTTnjRjd9v28QN2mutp9mODhKUsxEUQA08nUsFe/9OJSHK5fxLLdlzXXZvyr2WyORv2RJNcdjlhLP3einuUn/QgeU8WI3GwAGseq2LI/mzIjEg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Shivam Kalra <shivamkalra98@zohomail.in>

Update vread_iter() to derive the vm area size from vm->nr_pages rather
than get_vm_area_size().

Currently both values are equivalent, but the upcoming vrealloc() shrink
functionality will free pages without reducing the virtual reservation
size. After such a shrink, the old get_vm_area_size() based calculation
would overestimate the mapped range, causing vread_iter() to attempt
reading from unmapped addresses. Switch to vm->nr_pages now so the
reader remains correct once shrink support is added.

Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Signed-off-by: Shivam Kalra <shivamkalra98@zohomail.in>
---
 mm/vmalloc.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 87278cf2046e..d69174afb171 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -4666,7 +4666,14 @@ long vread_iter(struct iov_iter *iter, const char *addr, size_t count)
 		smp_rmb();
 
 		vaddr = (char *) va->va_start;
-		size = vm ? get_vm_area_size(vm) : va_size(va);
+		if (vm)
+			/*
+			 * Cannot use get_vm_area_size() because realloc()
+			 * may shrink the mapping and area->size may be outdated.
+			 */
+			size = vm->nr_pages << PAGE_SHIFT;
+		else
+			size = va_size(va);
 
 		if (addr >= vaddr + size)
 			goto next_va;

-- 
2.43.0



