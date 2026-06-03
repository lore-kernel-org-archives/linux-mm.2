Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36296CD6E64
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 08:03:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A01536B0093; Wed,  3 Jun 2026 04:03:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D93F6B0095; Wed,  3 Jun 2026 04:03:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C8396B0096; Wed,  3 Jun 2026 04:03:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7F2FE6B0093
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 04:03:52 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 186E1120221
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 08:03:52 +0000 (UTC)
X-FDA: 84837862704.01.E1A8BEA
Received: from va-1-113.ptr.blmpb.com (va-1-113.ptr.blmpb.com [209.127.230.113])
	by imf20.hostedemail.com (Postfix) with ESMTP id 379B01C000E
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 08:03:49 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=DWwfEf7Q;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf20.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.113 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780473829;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g/rmtPD1MKrWC7BjiewTdsAoLxWW7dzbcFZmhvRKNSg=;
	b=gSBtcpKJlkuNa21FU2B60pm4O1D82m9GRp30Ss+iU83k+3c6YYwRwn6FttKJgFT9Rwhz2M
	QfSav/SJjtQTZextviMCui0sx+OMeDUWgA5gLYyjLXwtiZcCGgmw8Sv6FBnn5Nop9+510r
	bllBVQcxpherqhfknH6FAGlAEXQ7jhc=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=DWwfEf7Q;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf20.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.113 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780473829;
	b=KATUR7cfgrym8clSoBq4Z8Tq1nNMDJeslb5dMrk28idMY5Tg6SEzX18Xv7uCQ7syjsY7DF
	eY7mS/yJW5UtY8EbyVSNMy/aaKkZJNQMJgsJNPK2Icx05EepAkLy6dWJuqZo97UoCgsykj
	B6mS8zmqE+skoIywZx9+RJsAgN8Lm/o=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1780473824; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=g/rmtPD1MKrWC7BjiewTdsAoLxWW7dzbcFZmhvRKNSg=;
 b=DWwfEf7QMoGjXqoTXelNAgI/iLEGIR9X5nbC2Epz1dDNoWtgSK6JJc1/kL46HxLEQ49lMG
 YjNAqK7lNtmte7uWYLGELUWyRQIJyZwPXvs7/sGnJUvZMY+7jqYT7ZwjjSWff7XSySlxaw
 XITt71tgA389mo2kRmrCgHveYE4I7P2Qfr873wMhcooitIY/Rik2EbpPUIU3liIvgdwK1C
 ZKJu9+Gj3a9+7JYWKbhq3+xNN6p6FapbLmb56awEeo7TU7iaBOCBCjMOIEaI3TXthHHp/+
 G6agip45lUq44QDNRsYSkyAzr5kjHzzw9fdgoR37WIXZmtIaANzqswAI4ztXJA==
Subject: [PATCH v4 1/8] mm: fix stale ZONE_DEVICE refcount comment
References: <20260603080152.64728-1-lizhe.67@bytedance.com>
Cc: <linux-arch@vger.kernel.org>, <linux-hardening@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <x86@kernel.org>, 
	<lizhe.67@bytedance.com>
From: "Li Zhe" <lizhe.67@bytedance.com>
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Date: Wed,  3 Jun 2026 16:01:45 +0800
X-Lms-Return-Path: <lba+26a1fdfde+08cd00+kvack.org+lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20260603080152.64728-1-lizhe.67@bytedance.com>
To: <akpm@linux-foundation.org>, <apopple@nvidia.com>, <arnd@arndb.de>, 
	<bp@alien8.de>, <dave.hansen@linux.intel.com>, <david@kernel.org>, 
	<kees@kernel.org>, <mingo@redhat.com>, <rppt@kernel.org>, 
	<tglx@kernel.org>
Message-Id: <20260603080152.64728-2-lizhe.67@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: 8o93nh5edwiw7ockpq5rjcr4uwxqkan6
X-Rspamd-Queue-Id: 379B01C000E
X-HE-Tag: 1780473829-226529
X-HE-Meta: U2FsdGVkX1+s9A+iKrD3NqoMwzqplDOTA+L7D6/bbIms6ooY9ISLNkayGrHVhooadRbJQdyEdzNUdT7uT1utOu/0uDhZKvDvg0Sy3wMUstqpphxadqpv8j/bqZ7q/A/qGU+TNivkmll0BfKeoN8Rg5cfEOsrMKFJ84C6Pp3Cjd3Vlr+QTb61mk/FR1r7+dGFZseFvC+rDJg0wljH+uKrEW9ohQ+5ryEp4GOFF2QlwLyGcFYDsMfbOxSlqYTzFYwOnAduqCzwR8Id2BqPPgnpUn6ZNgsmWAaYl0Nr2qqj4jYdSlCHtiATyVbZmeH8GcjYyAguxYNRNsX14a8OhrDqMsJh/3JQTUT0GsxdCwCEqzjbaTIA/llafBDGCCrEgw5LReOaecaX53bzHmN3gTASFMXP/EoFs8KItnqsTg4FICNmyOCzuRhW2xAoCCGChwT9E7sn1qS2mysnLnd/9tudpddInVvq128qmHu2eT/e0Bvv8OQxm+AMwfObfJityBywrzflRs1SN4fZN/eks9f6IwGW7KQkSXG/CqNUoxlaiKrgkretQjXu5jO/vIwAQHs9Z1/pOxhqWLXaBe2ufWRxKKsia+1oq+AVbRzp0/q7rHjwkq55H9hu7uAo5i+ECLatx9WiuQuZgkSEKe2WtcCAE1K5KzoiQ2IcKPv8P2iApOb6r8x2O8Oot2hJSmmaZU+N3qexHsUErl8i559yyZcNbWTUMX9Twp/bRlEIDLuz6tMJGXRhIHzWFLH+VkYRM4XZ1VhNaLialueufmqjvCd9LBLMs1Gaks+2G95Y+qzFr/eSKQ8E0UXz452Ld4KeQzWf4+zlzvnInyuBTE76IvSL1QG/t5XWtGhYl6nUKsPYX7jsK11JGWf9UPg65bqVh4TfCZWDWW90oGXpDb5zJb46JdWrv0jDeWW5lkRGSL1dMmFuCDn082wueJLfio0VBucXIr42dn4ZqKXGegECfAU
 cR2q1tpr
 7n9Zluq1MwWw5pK73PiHqLZ0fsh+Cj4IXVlhkVCvwBIkd/VwUdKQahgtVVlzGh0hwohXAw9KwAgF8y9171ftWUNj+LBGiVpPvUBsfWDPAPzytmZlPy/JdILhYXJsi6uFLxlqYi1ecQUSQm7/sU4blbchN9a4kQV/AY6FdNNOK+0DOFrYoicUhkWznpCbHV8dNdlcUyfBwEtq7oKSdWNUm2DOXToz202hcpWWjZ0Aloxcpz0xE8sg6F/0chAqwlRYE9gmHrmaajUAQuu/3ILjPIDuiSFaHWyrVYtU6ZAtXWywLYGJ2jSE0ZbK+vg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The comment in __init_zone_device_page() still uses the old
MEMORY_TYPE_* names and implies that FS_DAX pages regain a
refcount of 1 in the free path. That no longer matches the code.

Update the comment to describe the current policy correctly:
MEMORY_DEVICE_GENERIC pages regain a refcount of 1 in the free path,
while the remaining ZONE_DEVICE types start from 0 here and raise the
count again when the allocator or driver hands the page out.

No functional change intended.

Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
---
 mm/mm_init.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index f9f8e1af921c..35de3b6a186d 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1027,13 +1027,9 @@ static void __ref __init_zone_device_page(struct page *page, unsigned long pfn,
 	}
 
 	/*
-	 * ZONE_DEVICE pages other than MEMORY_TYPE_GENERIC are released
-	 * directly to the driver page allocator which will set the page count
-	 * to 1 when allocating the page.
-	 *
-	 * MEMORY_TYPE_GENERIC and MEMORY_TYPE_FS_DAX pages automatically have
-	 * their refcount reset to one whenever they are freed (ie. after
-	 * their refcount drops to 0).
+	 * MEMORY_DEVICE_GENERIC pages regain a refcount of 1 in the free
+	 * path. The remaining ZONE_DEVICE types start from 0 here and raise
+	 * the count again when the allocator or driver hands the page out.
 	 */
 	switch (pgmap->type) {
 	case MEMORY_DEVICE_FS_DAX:
-- 
2.20.1

