Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68DEFCD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 08:18:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA7FA6B008A; Wed, 20 May 2026 04:18:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C58CE6B0092; Wed, 20 May 2026 04:18:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFA236B0095; Wed, 20 May 2026 04:18:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9BC0B6B008A
	for <linux-mm@kvack.org>; Wed, 20 May 2026 04:18:19 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 46FBC4020F
	for <linux-mm@kvack.org>; Wed, 20 May 2026 08:18:19 +0000 (UTC)
X-FDA: 84787095918.24.9B4E05E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 8E9592000A
	for <linux-mm@kvack.org>; Wed, 20 May 2026 08:18:17 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="f/ZKTOjM";
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779265097;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k2FbEmgfTakOPvDjfl+izIomr2gAyw86w9Zoc4wPOn4=;
	b=UIiUmHprkkcWnuJwxf1EXhbQ38Ble667QXkLDuM/0lMLbAgaPohCI84EO64RUFoP5MmMug
	o3x8LFXYo/MfwZSdcsXkHmsOZaMKwPHuCoIcoZQAhui3ei5KnEJmQz4Bi6WRbtvDb/t2pY
	7syIymVCTXRmYnm68Be2uY6Cb0PhSWU=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="f/ZKTOjM";
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779265097; a=rsa-sha256;
	cv=none;
	b=V2mkl0FprEVuvD7AS2B/KV3O4uaDUJzNzg2cEqbmUixNCwjlJZD2ijC1bGwltVAMSANLcn
	hzZ0VWDFgkRtDlOFQV5e8G2YfjapbuV1ryTAxADKlcJ+xIphSI37tXCu3NTF8IK/J+psAd
	8IWOJ87mGEsA3V1Tj9Mt+Z9Vj8FsjNo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 29C7B601FF;
	Wed, 20 May 2026 08:18:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B08A1F00894;
	Wed, 20 May 2026 08:18:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779265096;
	bh=k2FbEmgfTakOPvDjfl+izIomr2gAyw86w9Zoc4wPOn4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=f/ZKTOjMOgD3U2blzJ+h4ceZoCdNJlYopEa96R62r7OrB2/5n0GIowc9MAhVcmVXa
	 QOhmvK8upbuSMzUYRoT0c2kfgSngby3OYzgwKasMzNuMGyFdU3FT+C+0BCliMI5MSS
	 DEJZ8UhcmL1501bV8/DNkWaqMEYQxaE+P22jFVS/tq6mnL5RPQ0DsYDI8za/gGUK5g
	 yF2xuMC93sLZOZY0x9NU3EQNF2PwmksmsaIN3LpsqFpcuIXEuQYf1wODlv5rnGufjh
	 XzT8eA26NZuMOcKtkWJE+c/7FVhkWSFlRcfjjjvJ95lF36C92HZH8u+yFEWpnYV/Hj
	 793Pwm5P/L7Xw==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Wed, 20 May 2026 11:17:52 +0300
Subject: [PATCH 2/2] lib/raid6: use kmalloc() in raid6_select_algo()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260520-lib-v1-2-cb3045bef2d8@kernel.org>
References: <20260520-lib-v1-0-cb3045bef2d8@kernel.org>
In-Reply-To: <20260520-lib-v1-0-cb3045bef2d8@kernel.org>
To: Song Liu <song@kernel.org>, Yu Kuai <yukuai@fnnas.com>, 
 Li Nan <linan122@huawei.com>, Xiao Ni <xiao@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linux-raid@vger.kernel.org
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1808; i=rppt@kernel.org;
 h=from:subject:message-id; bh=q9Gsdt0cXBz4PyQ4PCQeUMUOuQYy3gXLLlq8Jj37C5g=;
 b=owEBbQGS/pANAwAKATkDhibLDv2RAcsmYgBqDW4+DEs07xMRx4x2hkERcYEvsIS/qdfSMecZv
 0s8qlVLLwWJATMEAAEKAB0WIQR45VhVpZkvn3TRr+k5A4Ymyw79kQUCag1uPgAKCRA5A4Ymyw79
 kRJiB/oDj/xpRQnkLam4xzCl9AtztZS6hemp7DIu91gmzKLPDj6LDSAceHF9JjUmkqfSz0aCfoL
 pvyG7vr258saAw8BWz/pnezoqmbpMTARF9EgyzxV49VoqUMqp3IVe0N9X8t1/I+8A8XnzvDv3mC
 ccddKyQyH75lES/d5DvYnTUDgFtixBNMd+4V/QmLL4gpIEz8LcwHool9RmeVjqUSXNwxb8BRGC/
 VTI2QeahG84neO2ur22DCpYvJ/xxm2wELXNfOpopz8LwOJjc1IAeOHKPK6XJT56WboJaqw9x41c
 FS5cOao/APBRaiSu9DucsEkyzoP2oPTJbzumOiQziwW1hZkJ
X-Developer-Key: i=rppt@kernel.org; a=openpgp;
 fpr=B8E96E880C4A40C3C1255AA8C532392DE6DA7CE9
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 8E9592000A
X-Rspam-User: 
X-Stat-Signature: j4aq4p55mus3dj3qbs56bxy5nggayd1m
X-HE-Tag: 1779265097-458590
X-HE-Meta: U2FsdGVkX18lUX8703xkbGbrsiIUHpF9H+wXErdSJASJlQsQ3Ldalu7Y1oqbatyz/VN/Y4XIKT8hwwcwiIjZ0eZX61qlyPs3MrUt/NByLX958gNsBjOiidigeULwBjW3dhp5+EEHpgmjQEriJqfLzFTZCUYpycAV1M3H0JaFGDalXh1ymiBYyYfSBhdziehUTA4fzmV4vzhaaZ5Le7eSaAmw+H+pUU/F9Pqwi4umBqtN95kZtPFZb8Yn7Wc3dgJpDzfGe9PnPo9WS/TWMdDjSSY/QEl44hGL0ixA7yonCEPG9sOOx/9LYShiaeLyGCZhL0FeC+fdoZHHUjj080m0kwKI7+DFBgh/axzEoj0jZ3P0nDdpXBdOicsZ3NyGzvmGy4yhB9wynCXERx+5plUdhM72l5AAPV7ciZrDK90BhLfOlpM6DcICLioMi11STuHvYGZ+gtwvFqj0wONZTMZcvG9rYBYRu1QUdubrKC7CF2uY/g7S4Ayp0jrXNmQdPvrz36Gpj9eCUSX4KwXXK1Y39BoHOxA0iikP451J/Idzjtfevc+QLJtVnvSNh764ZCuEHsxEVfUBTS7aFjR0f6TUDC9gHPCbiRcrcJovl3ngIOPrlSMyDAw11Mp5/W+VUk8uiG7jjcHlf5Tae5HciwqiLivgb2OkljxPwkc+Dqy1m1MXvQIc1gwzLMepmOzq2TFD0V1voNJi3x7lZwwvazzX6/T2iYO/I/qFl7CAMbtcjOLM6ZfxWPOjahevYjHO9TzUBsfLHMrs2UjVqgjOr5FRJ72xnhrZ0N1EmlgpyVQhtwupn5Qfi7SVHb5I+4x6X5ZqMprl64TuPMNe5XAgeqte8Rgg24/fwNbI+3lctuhFJBmAulQxa83Ro4O4j6jn/hD8cCABTU1o3JMfTeEsT1P6jWu3SW7q68jpyCqr8UZaG2gEdSjY6aCszV5zrcgRTMsAKL3y5yzCg5hc8tHJHCC
 Nou91wxO
 kqL6HugDJj6nxRkIio+jbv1o0puPoAa9IdwoRP9CgmXsi/H70THSGxNBOmFLqJf7wN6pZzmgqtqPvphCm4niNoAUA/XwZx9xzUs1yLVog5reCx3nKfvB6MZOdVX7jtquqmPa3UIL5G54nHAmKQuGmAmBB7njrJTWjVzUKf/IDLAplRlAd+4O7sKSXQujFuZocxysB7SJa1WqqOfHCU8KjsBN1vHQb9lmsMCgR8dgeVl52uXos9daPDLikEsTwp3VMJBnjXtEBcfA7BZLtnqRnbIlUf3FVN/BuHtzyM4Ia5Qsnz/1MtCiAHiP7iQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

raid6_select_algo() allocates an order 3 (8 pages) buffer that is used
as a scratch area for selection of the best algorithm.

For such large allocations kmalloc() would fall back to alloc_pages() but
still kmalloc() is a better API as it does not require unnecessary
castings and may provide more debugging possibilities.

Replace __get_free_pages() call with kmalloc().

Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
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


