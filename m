Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5ECA1C61DE2
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 11:20:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 804516B009F; Mon, 31 Aug 2026 07:20:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B4166B00A0; Mon, 31 Aug 2026 07:20:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A3186B00A1; Mon, 31 Aug 2026 07:20:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3A21F6B009F
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 07:20:11 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8A1FD4045D
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 11:20:11 +0000 (UTC)
X-FDA: 85161320622.16.502DE10
Received: from va-1-113.ptr.blmpb.com (va-1-113.ptr.blmpb.com [209.127.230.113])
	by imf31.hostedemail.com (Postfix) with ESMTP id 9BDCB20002
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 11:20:09 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b="GE/I5DYu";
	spf=pass (imf31.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.113 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788175209;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dRKkwMKAA6/qu2BI43qh+QT7VmhddrQx/gvVs4FuAwg=;
	b=T2o/cSqlFMyBmHuuXKLkYi/Smy9KXdC9aN66mVLrYBT8PJNoyuWAGqj+B/xO30VA+H13VZ
	6IGZt5at8ADV8BUv2fZMEW4ySlJS4g9XgLcp0njpZa1PE+Fi8lB/M1m6K7TqVxJv1w2/Fk
	QR1EnyNO0SFBUxm6xbGnJwmiyeErSBE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788175209;
	b=WLF2+1W6zGOpK9OEleEBE7ASth7GfVueEB4X/AULqDuk/11x4r0PboCCu5GQ5frQ9dL/ZF
	Mthj0+sOdogLxHd1J9+e2QLOzQo/Ggysr4qz8dCrXVNQPwQLGPuT3OrbFew/AUbtyva2K/
	EVJBH4oDdtD4HyIC6+1iKOqX8gdJvcQ=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b="GE/I5DYu";
	spf=pass (imf31.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.113 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1788175202; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=dRKkwMKAA6/qu2BI43qh+QT7VmhddrQx/gvVs4FuAwg=;
 b=GE/I5DYuIJwsNpKjzL4KSnd/3U8/WCKrjNNyEuq54QJBOp5HKmt5DTwX532iEWrORgwfQL
 X+GVZNqEqfdgrYAqN/sxfYWeopLzKRDN8CNn/uJud6PrH4z0D7zmZpJuq3nu4ca3EI2pNW
 dkCFmVukal3IG2/+uePazxedJrM0ytiIYPfYeycX0g/RvzuP0ND4npslowncqaNYRy8zli
 vaVX7vozrn2nsCbwUTkimB3e25jrJwxmktm5dcC/ImV5PmOj3wQaL+RN7V9HFt+M105oVl
 FYJJDP0orGg1DShX4X3vXExw9NlfPQHtyJ2tzXRgCqA81Dxr3v/rV6SPq8iUrg==
In-Reply-To: <20260831111638.76012-1-lizhe.67@bytedance.com>
Date: Mon, 31 Aug 2026 19:16:37 +0800
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
Content-Type: text/plain; charset=UTF-8
To: <akpm@linux-foundation.org>, <apopple@nvidia.com>, <arnd@arndb.de>, 
	<balbirs@nvidia.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>, 
	<david@kernel.org>, <kees@kernel.org>, <mingo@redhat.com>, 
	<muchun.song@linux.dev>, <rppt@kernel.org>, <tglx@kernel.org>
Message-Id: <20260831111638.76012-7-lizhe.67@bytedance.com>
Mime-Version: 1.0
Cc: <linux-arch@vger.kernel.org>, <linux-hardening@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <x86@kernel.org>, 
	<lizhe.67@bytedance.com>
From: "Li Zhe" <lizhe.67@bytedance.com>
X-Lms-Return-Path: <lba+26a956360+4fbec9+kvack.org+lizhe.67@bytedance.com>
Subject: [PATCH v11 6/7] mm: use memcpy_nontemporal() in zone-device template copies
Content-Transfer-Encoding: 7bit
References: <20260831111638.76012-1-lizhe.67@bytedance.com>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9BDCB20002
X-Stat-Signature: je17kcxahwpakwxcmk6b99m9f8pc45ms
X-HE-Tag: 1788175209-17256
X-HE-Meta: U2FsdGVkX1/WAll/oXUKVj+/ikyPPGGMv9UVVfoqA9Wda0QVxxDz2GpvSOLCDDqb2ywygo/V1bdDz2PY4Fg8mw5SGX67glPYHCflilW3iY9voSQfTrfXpDpvdOQEHqoJ5zphOk5bmKP241s+3N/aOzHxN4zI1+HXU6j/I/bwBbElSe+QzTyn8UahCUrv51BgESVxv0sKGqvYzFKDn8zRoE0R+5Nc4IjpVGHWNjuVT+c7FEuVdcFEBOGUs0tQ1Dm1gX+O+jgQQHd9uvuyWCKbHFXVYcmMSGR/+gvhTiNQJeiChiTs3rVoUbSFnhDQ9761GqZcko7U9fu4rW7AuaScEYHHcI4ZyBra/rZ9cZxi6xvAJHm7PBNIat0X+egzQjw5KDvYu/MTXn5/QUO9ZZ4kQN0yIu74UHxgQmvzLcO4pt0/xjPP+bChXUjg1Un2EqfFlO43HvgN0wQvLd56z3eYIXCEgow9uIbxfrNswzqUDqSdlT1E4onyjJ9uBTFDO7/HaXLAajrEUwrbYABatUZSp6BPTtvhTFVe32cnn8S7pIfM+RsOBBYRNaQgpe/nJb5J9VmloVapoe2dlYB6ZKzAJPMr6R28lnkmcsepoPldzpHNQVnxyBihesvg3MSlUJfriNc0uWeF0HJ3kXYkFZfOrg7kpCIGmHYx4trH4GG/zXpmu7SpqiyZZTerYXLEhMRdnA2b823svK/JUC/CBazixhPT5YWBq2afMqBQD2tUwypxybiMf5saNEXJQHRrKvaJPUUACeX7WTrKcwS5mXOjXjWTxeb4Lc5zbbMuXE/JYT8YSYilcLMCYoWP/Qs3qHzETcCYAjhkNlY0+hgvn0I3Fp0ZCzQp/D+s1I51ScckdTYKZwLV3mbPMVQPx7xe9Z+rtQ7MRDLf0MGM8azH7f1K0aSfwW+Me7aOoZ2NVw3KGdk1n2ovFGv35bacQomcIrzcRfmSkZpeaE8s7r22Tqt
 rFyoBxd9
 obwb3frVkCyjH40izA2kXqvu4F4pCU2cDjTc0a/nc+dnGLNHthq5Qq/nJmqG4gYXU6XQ4j4XwYp7mmBpJl4OYavetQc3R37HSNBa0jOL4f8WHDBXBw1tvVEtYbMlyW6D7LD9I7Bg8ZkdGCRNg+XT9GVsHAZG9ZOa97tt7Xts3xeNxQQnoekixlfmCwWHmciK0S7thoaC212V3I5epJPEbTdNsYCB4ZjmvsJJj5Fg1VuG39/y1NxCOZbPqQHs30jcqPltHcdJlBFxR31e56Mzrce5WNwfDptGyyBOXoS1qk4ItV6+lqsTNoMDfUQ==
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

Base(v7.3-rc1):
  Average of rebinds for nd_pmem driver: 221.07 ms
  Average of rebinds for dax_pmem driver: 191.20 ms

With this patch and its prerequisites applied:
  Average of rebinds for nd_pmem driver: 150.40 ms
  Average of rebinds for dax_pmem driver: 161.83 ms

This reduces the average memmap initialization time measured during rebind
by about 32.0% for nd_pmem and 15.4% for dax_pmem.

Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
---
 mm/mm_init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index 04ba37d95bfd..5a61c0c83fa7 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1025,7 +1025,7 @@ static void zone_device_page_init_from_template(struct page *page,
 	if (!is_highmem_idx(ZONE_DEVICE))
 		set_page_address(template, __va(pfn << PAGE_SHIFT));
 #endif
-	memcpy(page, template, sizeof(*page));
+	memcpy_nontemporal(page, template, sizeof(*page));
 }
 
 /*
-- 
2.20.1

