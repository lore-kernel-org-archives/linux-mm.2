Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA036C5AD55
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 12:24:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D5CB56B00A1; Mon, 10 Aug 2026 08:24:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D13AC6B00A2; Mon, 10 Aug 2026 08:24:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BFC1C6B00A3; Mon, 10 Aug 2026 08:24:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 915346B00A1
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 08:24:54 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2858F1A0125
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 12:24:54 +0000 (UTC)
X-FDA: 85085278908.23.912B127
Received: from va-2-113.ptr.blmpb.com (va-2-113.ptr.blmpb.com [209.127.231.113])
	by imf10.hostedemail.com (Postfix) with ESMTP id 2C02CC0002
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 12:24:52 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=K+Qhhhlf;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf10.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.231.113 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786364692;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=noN9zN1awgD10Dy4RdMcJEDTTzNu8MQNGVp8sfEJ5vA=;
	b=yoOfkbXW6HurhUaG++cck/P5ETzQ1hgUzHfcvuDC3ht3h4Ikv1WUcks4d0hw/mEYteL4U3
	z54dxiFFHz6HMmOmmEi+CzJa53wQdab1U1IkX85ifDhUQoRGbODchJdQ479hABG7o6uO7S
	Kq+BPZe2Frl0RepGTstko8AKwVHE6bg=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=K+Qhhhlf;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf10.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.231.113 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786364692;
	b=eZuvbTYP1C4Y2f5C687CWK1DT6e+2tSR8rAFSbBF8jC9zFha0DGwZ+FIHkAXgeYOUeMvgv
	7+OBgyoztmr6n3P02TIq5khorkYLlSXeBY1MLV1FSxO1GSgZb7PNG1v0EKR/zlgSMBMrxT
	v02bTnHYbbEWgDJ3lcl8Dhl9qCg1/Yg=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1786364687; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=noN9zN1awgD10Dy4RdMcJEDTTzNu8MQNGVp8sfEJ5vA=;
 b=K+QhhhlfuYiknpL6DX3R0+Z9hcTSBZnQKE+/p4StdapT3x8CImvj/c0lFOJuiQfBj/xb6R
 0yBp3mUSWMflIEX9vzCZxYtFsmWxi0neIuIt1m3EKGZbAZKFr0xbxHfBmDK6Hk6qKaIZMg
 h5T8lzjlhgXqARby/lKlce8ZTEe1N5o8QpKuets+TAMRMHM6LDcne/e7fZ/4GmQDrf7dbK
 7bKrn5iW62IwIAIIZLSOL2lRGIfn3xKu9fXHMHmhgLykRuN2E+zMrqMJuGYcNdp3WyJOzk
 BacxqBljCJVKaOjsc2WpKDtIYShPz++hbja+sikxyo7LOrS4e6HT7EkHjJhLNQ==
Cc: <linux-arch@vger.kernel.org>, <linux-hardening@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <x86@kernel.org>, 
	<lizhe.67@bytedance.com>
From: "Li Zhe" <lizhe.67@bytedance.com>
Subject: [PATCH v10 7/8] mm: use memcpy_nontemporal() in zone-device template copies
Content-Type: text/plain; charset=UTF-8
Date: Mon, 10 Aug 2026 20:20:56 +0800
X-Mailer: git-send-email 2.45.2
Message-Id: <20260810122057.30447-8-lizhe.67@bytedance.com>
Mime-Version: 1.0
In-Reply-To: <20260810122057.30447-1-lizhe.67@bytedance.com>
Content-Transfer-Encoding: 7bit
To: <akpm@linux-foundation.org>, <apopple@nvidia.com>, <arnd@arndb.de>, 
	<balbirs@nvidia.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>, 
	<david@kernel.org>, <kees@kernel.org>, <mingo@redhat.com>, 
	<muchun.song@linux.dev>, <rppt@kernel.org>, <tglx@kernel.org>
References: <20260810122057.30447-1-lizhe.67@bytedance.com>
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
X-Lms-Return-Path: <lba+26a79c30d+fb726f+kvack.org+lizhe.67@bytedance.com>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 2C02CC0002
X-Stat-Signature: xbj8hxw8nzsd1w5tbx797fkwamq44d11
X-Rspam-User: 
X-HE-Tag: 1786364691-871325
X-HE-Meta: U2FsdGVkX18eODcpjM8cEv4mUuRobiUKHHoyb0n/eJZCaSvFW62tTXj+O1sUmRiUQ48SZY8WjHJxJ6x5peVOG3ODH+GK7uOhNDS5hwcGc4zUNmNPmYbyjPlgyglMOtUWg6PtVkl9pAqJvKn8USuii0OnHWBoZYZL670sJjVjBeJ1O7iBTO8Uw1gD8Z78KuDAFyqTSTpHG8IUyOJN+anEmSRBIB17AGtjXKNZaeVKoDVJmPskk8OWFnzBZTMt1sPTtHHawIIU2XPAHnOGZ7+mXJIq48HIiTrWGFcO5zYtBxqW0IzC6gron2cZrUAul/DsMlwChMVgdcRpv9sonlkGn7E0twSNQbtxPvK1i//jZSJk3mPk1V4rEyMB/rK3KD/ZVJRfueJDqDM/t65hLsrsmUFbJOt9eKP0uCwyJ2wEtR+AjSJnNGjLnae5iRSLaZydySuxzsAxyTZF0hMPekxUEJps4WZlTqT68pld0ZCmJ6vYo+axrvQhnghOJHVbIKL+O+a1msEqhS66yCtldH3ei8nJo/S02BK355tmqRQNkH8lkAJ4Lm1hhok4KaHs4+IPesiIY3gMsxAF9l9RsNo15C2cB16OlUdAP+sAKM8I61s3LXNCXqs/qR/vPiBnpzyLqmLAq7LB8v/7FB5ZmTEzgmrhdK4st73oNM50qmrnHZ8RsOdcIL2Yx+GcadLgaSrXoM3/4g0YrF+pK3VYHZZZ0x4fqnmwP05K9frWG8nw6dx1DHGXfzeu4TdtGBkbywYvZyZ2b8CeNqbSDZ4BmuMC7LqHFZ/VhC0XQDR0pPyxzyKHRrh+waaZsUC2pYNOt2LJe4fVBpLrhxOwjPtMgtgtT7ciqsy5iOAgBrhli5agWBliiEqZu+zRaq+2Ogx3TX4t6jq4rRMf6nRTrYkJx2tQ5dswokJov8+3ipKxsb3UOYaMuHzuSKmHJ3MpQofhCQiTpnaF7lRVhs7rJjHRjDJ
 gbxmehK6
 oCicw+F1mmJzyrWe5bHwhbbjqxWoLqnZ3lIARHl3YNyfpulL5YEhS6cs1eA6XwdmsAeNlQ0oqCs6hwk9KEYNrYZnyUaOBuvqc2GsBPnu7wIJhd9Av+1T1OEIJie0cI+XqgMPXsM50QTw2OylAw3S54NhggL5IOSD3DWkwsfCBl9DhtHjQONQ99E7gGqyuNFuhYK99sqyWkpBC4UV39jKDcPL5jH+j15aVhFXPsfSh25cYzZG48ytX5/9RcXXV9DDUNLgB3Ow0pa62MPhmi9I78BabYHYXZCVCzwY2hXJa15p6BJSp51PuVYQ2fY5KBpN3SqOqfkNKvipXtic7b4UyJjJsMfRrgn1DN66/lQ0vY5wmrrcOhLMqMA8v3p7Sr07uV7FlImXxa7Rjn8DOL8vjoaqSE/5sBd6c3Bla
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The template fast path currently uses memcpy() for the actual struct
page copy. Switch zone_device_page_init_from_template() to
memcpy_nontemporal().

ZONE_DEVICE memmap initialization is largely write-once: each struct
page is populated once, and most destination cachelines are not expected
to be reused immediately afterwards. On x86, a regular cached memcpy()
can therefore incur write-allocate traffic by pulling destination
cachelines into the cache before writeback, and can populate the cache
with data that has little near-term reuse. Using memcpy_nontemporal()
lets this path request nontemporal stores for that copy pattern, which
can reduce cache pollution and avoid part of the associated
write-allocate overhead, while architectures without a specialized
backend still fall back to memcpy().

Do not add a KASAN/KMSAN-specific fallback around this call site. As
Muchun pointed out, special KASAN handling for memcpy_flushcache() or
memcpy_nontemporal(), if needed, belongs in the low-level helper rather
than in this ZONE_DEVICE caller.

No separate drain is added here. memcpy_nontemporal() is used only as
the copy primitive while memmap_init_zone_device() is still initializing
the struct page array. The ordinary stores that follow in this path,
such as compound-page setup, are part of the same CPU's initialization
sequence; they are not used as a publication store that tells another CPU
or device to consume data written by the non-temporal copy.

Therefore this call site does not need a helper-level drain for
correctness. Callers that use memcpy_nontemporal() as part of a
producer-consumer or device-visible handoff must add the required
ordering themselves.

Tested in a VM with a 100 GB fsdax namespace device configured with
map=dev and a 100 GB devdax namespace (align=2097152) on Intel Ice Lake
server.

Test procedure:
Rebind the nd_pmem and dax_pmem driver 30 times and collect the memmap
initialization time from the pr_debug() output of
memmap_init_zone_device().

Base(v7.2-rc1):
  Average of rebinds for nd_pmem driver: 244.28 ms
  Average of rebinds for dax_pmem driver: 273.31 ms

With this patch and its prerequisites applied:
  Average of rebinds for nd_pmem driver: 150.83 ms
  Average of rebinds for dax_pmem driver: 153.55 ms

This reduces the average memmap initialization time measured during rebind
by about 38.3% for nd_pmem and 43.8% for dax_pmem.

Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
---
 mm/mm_init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index 9691fa2a060d..bb2007806a28 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1101,7 +1101,7 @@ static void zone_device_page_init_from_template(struct page *page,
 	 * to the destination page.
 	 */
 	zone_device_page_update_template(template, pfn);
-	memcpy(page, template, sizeof(*page));
+	memcpy_nontemporal(page, template, sizeof(*page));
 }
 
 /*
-- 
2.20.1

