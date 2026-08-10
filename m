Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33A09C5AD55
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 12:22:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 037546B0093; Mon, 10 Aug 2026 08:22:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00F2F6B0095; Mon, 10 Aug 2026 08:22:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E8F0A6B0096; Mon, 10 Aug 2026 08:22:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CB6A26B0093
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 08:22:12 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4B6A5A0D0A
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 12:22:12 +0000 (UTC)
X-FDA: 85085272104.16.1475B62
Received: from va-1-111.ptr.blmpb.com (va-1-111.ptr.blmpb.com [209.127.230.111])
	by imf29.hostedemail.com (Postfix) with ESMTP id 116B8120002
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 12:22:08 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=frEo5qcW;
	spf=pass (imf29.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.111 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786364530;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6LDfmUcelxmT9nJB/bHRwgrk2ZzY+G3Dy0t3Kxw/TPQ=;
	b=NhpqkcUGxiUNHqsLHd3DPz4tyTE5bnEeqHb+goaYarXs0GPWLATZevkTWNP8Gye39hcYQ/
	pIrTt4NYSeV+5DKIm6y9aZvh34P5WsE/59ZuX83Q5SoBSdtFEETYNy9R1jOuszZTmuBolz
	Uv5DU/+vVP0bh/Hd4vbpoY04wSSsWHY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786364530;
	b=MqjtDsdPQ1LnGJcUklTbh9AYSRnD0RuHYONmsJrJPNrYC0btqDn+9L/Uz3KTH/LOU31COZ
	wGQ/naUh804MG8+L9cWaxIEtjgsh7wQI0MV0lBWq/2gI88pvHtZftgQ/s3hUXTnLDGvP+W
	hB2GXSERPLTqpr4ofSaQDvxTL2xcva8=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=frEo5qcW;
	spf=pass (imf29.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.111 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1786364523; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=6LDfmUcelxmT9nJB/bHRwgrk2ZzY+G3Dy0t3Kxw/TPQ=;
 b=frEo5qcWDYAkeE5zop7vhFKmQ/ytTyiQE/r+DxfGySnuncBnp94UDWzDhCG2wcJhUA5aJ6
 8NQVn1Ac+ZXgIz13HiQ8fu94x6y78OvfIXZ2MNtaTq+uSA7sP99C7syMikaeGhlRsOLqjk
 dSQJBW30ANxMW6Mjb8U8ehsbGOu3bTnaYbnQvziVLTAaWb5iJtnyCkUaUYijjfqKHZSQYV
 E/7G1JM41O6TcxuuWqEwsKPbkJHhdbtYtfjMmwrHRNR+gw5AEZPD4vc2OxVxi077fUREek
 yp3rna9iHYXoHXwZYRAYPjsb1ENgpXFGngYjbE2hwsOU0bef5/M6Nj38rh44Lg==
Content-Type: text/plain; charset=UTF-8
Date: Mon, 10 Aug 2026 20:20:50 +0800
X-Mailer: git-send-email 2.45.2
To: <akpm@linux-foundation.org>, <apopple@nvidia.com>, <arnd@arndb.de>, 
	<balbirs@nvidia.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>, 
	<david@kernel.org>, <kees@kernel.org>, <mingo@redhat.com>, 
	<muchun.song@linux.dev>, <rppt@kernel.org>, <tglx@kernel.org>
Cc: <linux-arch@vger.kernel.org>, <linux-hardening@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <x86@kernel.org>, 
	<lizhe.67@bytedance.com>
X-Lms-Return-Path: <lba+26a79c26a+98fdd7+kvack.org+lizhe.67@bytedance.com>
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
Message-Id: <20260810122057.30447-2-lizhe.67@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
In-Reply-To: <20260810122057.30447-1-lizhe.67@bytedance.com>
References: <20260810122057.30447-1-lizhe.67@bytedance.com>
From: "Li Zhe" <lizhe.67@bytedance.com>
Subject: [PATCH v10 1/8] mm: fix stale ZONE_DEVICE refcount comment
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: hyttj7bmoj1n5ddm5ewk1e8kyppe38a7
X-Rspamd-Queue-Id: 116B8120002
X-HE-Tag: 1786364528-768428
X-HE-Meta: U2FsdGVkX1+nmPFyUVobDq++moOK09LMyWHEeSIT8yW+DXVE8D7iJEJ+qB9Fydgbst2LlqZWa4UC/cj3ydhAu7rTuFO6v+I/rJxw84RCWwqwd/lK9PtwoNR7+v9DYCeBVPVr5cl8W3I/6JQ2sAf+LnpMrxPnlpQRj6eMauIsuXeB7LON7QQm2Ig5Z4EHgIF3TfPIrerRpcvChV5Dz2HOsDicakiDVeSdjTjFDFfYjOApjW+wE7MaPIlKoEt08di39Z5+l9pSG+riMyL/X6wFY0JjpB4wktOuGDdTXmNJbhzCBaULYJBPxF+KoQgO7xErt13lZMXbk1z3btv+K/mGSwvIBmNxQWZQMnqA8bhtMfLYnYm8/m5BcwzqwwgAI6B9XyN1OO5vXbatgLCwZs0G1EBklKb3GABUHZDoI7RLAUuCTt3GP8u3fStgTICvD4RWuvvRdt/QBqUSz3k9GHf1gq2uWyA/LbP4P/u4cVibCSFV7VPWqXAAvbXkJZeME7D/AIDKe/X1wYc/Cn72gaUvC9wH2RR8XKx1m6B3nXwCMiG7VZ9cZtKU6hJ7IYPQqZb1+XNPlOUQJP8RUFmVgVEt80WH66vw0PI9AU6mkQ9oaBMKTgbsuK+4GE5HYK2YYWxb/sLCWjHwG3OYk77S1NtokCpqmXsDZxFv7YMplxUD4Bbj7v9W+pJ7Q+LZ20dA3fwyvxhs6HXyZ8N8Q131HXDZvNKMjaTa2ntRJliyP0EifX8g0NsHzFSQF8Bbn6lyIFr8J4sEIR+h45qZT8ETRqczH2/jkjUn3z4ppQTbenhPQZMD1z45aRPoGbS+elwGsqkmBYC6Q7uBbJt2VOsYCfDGutAXyeZ+33MGM4MSrbkMFdfFelZ1YYWZJO68GFxptJbMAcKFfh8R+Z2GuvmM7pAC+B1BiOdG/ccLv55MIcyKc2rSzD01njrYnLVwp49ovVZev2Y9oR6gfSCommFtzwr
 blVSIbz9
 R73AaO5fMPMB0enbP65BBF/4tbg86AyZXkUb/ddGwm3BDK/aAu8UoYmOwA+voakBDiDYJ11GruOqKvxQVRC9A7gAwyaPL/uWkdrGWU3oTDQIBYYDPX11H8Dp/EW01kQEWfgHF3TlovSNIS8lXcXdEVRS3aNBLTFnqHGX6GRpIVHQIqGtFjeGp6yK/6N4BMKbkWo28fywDKjv5pdXiWzU35omTSDcB5yog02wSqZC7+IOGBS9z9c1nlaRnfKQv69Af3qq6IOU0EPKqHAXlrJkR+Q8T+RGrthI//Nl83DCnrXHHkiKhUL09vGQC10DYXr0k1Oerm3793vUrP2Tt/d0hucS+HUMfWLPRSr8wtww/XBcpfye2YXpZOGzSlvQKkhotIwgn+WejNJZLrySbaXyG2JMJgQA7dPIdAEHpRtR7S+68t/l42H9hjDJDkVLlJFy6TpV6+mw6OdD+x1B77ERsUCtlUQ==
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
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Alistair Popple <apopple@nvidia.com>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
---
 mm/mm_init.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index 0f64909e8d20..95808ab5cfdb 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1030,13 +1030,9 @@ static void __ref __init_zone_device_page(struct page *page, unsigned long pfn,
 	page->zone_device_data = NULL;
 
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

