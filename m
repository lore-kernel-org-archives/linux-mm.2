Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8AC31CD5BD1
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 09:53:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E6F06B0092; Thu, 28 May 2026 05:53:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 098066B0093; Thu, 28 May 2026 05:53:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F17C96B0096; Thu, 28 May 2026 05:53:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D48506B0092
	for <linux-mm@kvack.org>; Thu, 28 May 2026 05:53:18 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AF0A51A07F1
	for <linux-mm@kvack.org>; Thu, 28 May 2026 09:53:18 +0000 (UTC)
X-FDA: 84816365676.07.F11D40C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 1140E4000D
	for <linux-mm@kvack.org>; Thu, 28 May 2026 09:53:16 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UFAb6hli;
	spf=pass (imf04.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779961997; a=rsa-sha256;
	cv=none;
	b=MtUqBESZMuwVvFkM4z1nHL6lI3ZUNlOgUkYiHWhJrYnFy/e+QiVpApx8c6Q5OXWzrTRHP0
	5BGoGdZinIyrzpt/0nf1RmuDqRwRE5nVYRF9NUajM3FOcXKtSG5YrysT8mhWycFd2jJzTw
	YceviPnTgjyzihoANDGaLeJUrca1jNM=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UFAb6hli;
	spf=pass (imf04.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779961997;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nsDtOl3cQ8re9LG+iRAo65uWQwcKMxb80zOtaLHEWdM=;
	b=ibxXKHontEV8upYBky4TwVz/4CcpJQkMhJLGoJCZ0wDDxwybbbow5a8rRNPqDR+DxaPpJG
	/Q2cM6mlBuH8v9LT8ZMnLjCu9jrJ4CmhwFJTLDwpd4XecJVlJFScmG93maqRHoo4EVB89+
	s6hU+kuIv+cmXmKRozFjXaqbvQ2zmKs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9A3DA605AE;
	Thu, 28 May 2026 09:53:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9ACD41F00A3C;
	Thu, 28 May 2026 09:53:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779961996;
	bh=nsDtOl3cQ8re9LG+iRAo65uWQwcKMxb80zOtaLHEWdM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=UFAb6hliRTB3p+BbANMRHD8BOvyxRcxNLa02dbMyduid7xiapuqLcTzcMu+XIAgJ4
	 /alyAWeWIgmMLhjbMT7quBrjg6uMKDiXCs2a0ep3tAPT7IIsC5CtnpHyO8yWUx4gVk
	 jK4PCHCm9tZ6XS970c9AEHUrSJFjbrkAb+wNHhrNvRfpvZOTj5eCV4H/WHuSzdsWsD
	 8WHvUr0q3HjZsj9/LaFfSGY+0pnucT58pHjCmwQlyGaBmIkRzNtZiIwlMBWwg1Ivj+
	 5YnTG4uq+55/t6bz1O4JFHuAIFXvvmJochXb7E7Vpi5567mlcy98q8f0nVl7cztVPr
	 m9gNygNDfkcSQ==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Thu, 28 May 2026 12:53:01 +0300
Subject: [PATCH v4 2/2] raid6: use kmalloc() in raid6_select_algo()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260528-lib-v4-2-4e3ad1277279@kernel.org>
References: <20260528-lib-v4-0-4e3ad1277279@kernel.org>
In-Reply-To: <20260528-lib-v4-0-4e3ad1277279@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@infradead.org>, 
 David Laight <david.laight.linux@gmail.com>, Li Nan <linan122@huawei.com>, 
 Mike Rapoport <rppt@kernel.org>, Song Liu <song@kernel.org>, 
 Xiao Ni <xiao@kernel.org>, Yu Kuai <yukuai@fnnas.com>, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-raid@vger.kernel.org, Christoph Hellwig <hch@lst.de>
X-Mailer: b4 0.15.2
X-Rspam-User: 
X-Rspamd-Queue-Id: 1140E4000D
X-Rspamd-Server: rspam03
X-Stat-Signature: 6wrgqo53k9bw69phr6u8hqd61tkdtuoe
X-HE-Tag: 1779961996-760038
X-HE-Meta: U2FsdGVkX1+hMiqTUi43WX+TqlKLSY4J7+JLlJUUWT8Ej7J9+029B/hggfAZBJLc0972l++PO6eGsEPFXuFcXp34sn7eMe3paV41IWgjP43cdMxkEx+j57z4AhD68DHGfacdIF3ihXJrRwe5mvTc3Gp6xTpnuKkqxERskxRUlz/ynSyG+w756p4kdw+heDbzb3oU09NVZYhomlfxRnVpU6JeBTiqqQv7J1g0/zEZilPG93y/vsklMxMdW+fD+ZlVc8gI2qBRq53gMZov7gaI15EhZD1ReXBPPTke+T0wkoQwzQ/DcK/6EDLhYXxUX8/n8pKsR+rirLVgFFp9TdSsoNstIksyCFjXZGBp3x/0ptRV7xHMrXCTMhZu9LdfCrgeB1Q2fM7eBB/UXNnFTq+QoxxLiI3K1NtrxG6oypPdguqxStHgyte7+dw6+9DODTaybWvZWZ/RIfOefl8E0tLOLydsTYl+Y7kov2FfRAPrHuauPxkxUZmOwXCIYBg/qGv/53nPW0TheP3yPmDmvlpv2k9/SMnjOzulGraKXmtEnSPklFJoaVogAhKexRd75ODc6l54y8mV76POny60Bn8a/LvaoLsZJ3nnnZIWkVxG0FJp/hvV7nJDL7K0XgF8jkQN6F89OHewImaSH/BCwTd1wE7zAuwYJHvZZl8lM3UAMKAFyQam556Q9N1Eb9oi37fjN3xScsf7auD6mAYNuLeqAhuva2CEahRYPvvcPPIUiyCFqwH6/kQpW9NvCaPIosIwqk2LiKyg1U/eUisNbuYfqGfJnYa1RDkn0NYTyJCiKKvZurw/mj02nzkk3A9mel21QBePMhRVtegJeWDsIYFpOuj9jD+MFfw7SzvneXljV4PAjoJS5YqojlxjjVNDXalPCV7vrHkLXNB9AN3UAYUz3W3/gcmaTX7cbk/VtikzAPRJMxr5gsLvJIP4VtUDmX0qzHKe7nEV9BDQk3nu69n
 SHc+8m/w
 RuShnZO62Nqyxj5i8XT8ZryjeWN986l3oR3g/YYZwo0PO5oGrAELOwYqmVLsfq/aQO64yQxZLxdJ6ESvhuB/nanzgXNPTal1GYNlFwD/FytDoR5kk6t+jSaqIAMz4mvmwdu1g9bE0530cZrBpQRcHlqgvIGFWPRjbUvmpLbkYH8XBdTA+hCoxRhUml8nMpZvZi9G1NO7ApPAhhZ4pUu9L5L8nEO6SQ7fARxd3ytOv+VsxfS+jQiO/YVyVkEw/lQlWWIQzxYlc9RxGGZR7X6xrDOBlg/4h2HXDHdcc5TkOqBQussdviF31kwisjHkvv92Df/1aM7MtAPmq9NdWogmRBgo4vYGyGgCESApCrVN/wE4Fy5rv60iZDteQMxVYjVEI7XXXrgBJopefW7zv7fKFJxSl+xnZ3CVmFAUi0UbuaGsREI6aeVK2fqnqPviM9NTmgx4aukhTfvrVgYDyHlk3YsjG9yooBuIO39VPa2s2T/oLZvgbkCNLQQhBuQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

raid6_select_algo() allocates 8 pages for buffer that is used
as a scratch area for selection of the best algorithm.

This buffer can be allocated with kmalloc() as there's nothing special
about it to go directly to the page allocator.

kmalloc() provides a better API than ancient __get_free_pages().
kmalloc() does not require ugly casts and kfree() does not need to know the
size of the freed object.

There is no performance difference because kmalloc() redirects allocations
of such size to the page allocator.

Replace __get_free_pages() call with kmalloc().

Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 lib/raid6/algos.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/lib/raid6/algos.c b/lib/raid6/algos.c
index 799e0e5eac26..89e627c62e30 100644
--- a/lib/raid6/algos.c
+++ b/lib/raid6/algos.c
@@ -12,6 +12,7 @@
  */
 
 #include <linux/raid/pq.h>
+#include <linux/slab.h>
 #ifndef __KERNEL__
 #include <sys/mman.h>
 #include <stdio.h>
@@ -129,7 +130,6 @@ const struct raid6_recov_calls *const raid6_recov_algos[] = {
 #endif
 
 #define RAID6_TEST_DISKS	8
-#define RAID6_TEST_DISKS_ORDER	3
 
 static inline const struct raid6_recov_calls *raid6_choose_recov(void)
 {
@@ -250,7 +250,7 @@ int __init raid6_select_algo(void)
 	int i, cycle;
 
 	/* prepare the buffer and fill it circularly with gfmul table */
-	disk_ptr = (char *)__get_free_pages(GFP_KERNEL, RAID6_TEST_DISKS_ORDER);
+	disk_ptr = kmalloc(PAGE_SIZE * RAID6_TEST_DISKS, GFP_KERNEL);
 	if (!disk_ptr) {
 		pr_err("raid6: Yikes!  No memory available.\n");
 		return -ENOMEM;
@@ -275,7 +275,7 @@ int __init raid6_select_algo(void)
 	/* select raid recover functions */
 	rec_best = raid6_choose_recov();
 
-	free_pages((unsigned long)disk_ptr, RAID6_TEST_DISKS_ORDER);
+	kfree(disk_ptr);
 
 	return gen_best && rec_best ? 0 : -EINVAL;
 }

-- 
2.53.0


