Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C082105D99A
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 02:52:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E592C6B009B; Tue,  7 Apr 2026 22:52:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E307C6B009D; Tue,  7 Apr 2026 22:52:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D6E576B009E; Tue,  7 Apr 2026 22:52:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C99196B009B
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 22:52:01 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5B8DA13B0BC
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 02:52:01 +0000 (UTC)
X-FDA: 84633864042.19.EF46ACF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 77C891C000A
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 02:51:59 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MnttrxLf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775616719;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BdliaBWbk2rOoeYorTgFI+4+mXZ4Qg922zWKCCJqJeI=;
	b=0xTLqtkG7we0S5kAX0OU9spC+N/BIMpu2twpBoaif6kP8sQ5ei8VHbrUdkcvwmPWK2jqVv
	MXp9Waz/lAL5B+gozjZS5QRUkjSTS8qBdMw51ucgkIsi4jNRIoxWjiDt2QhckaWj2yO2tr
	U257U5ig8S4agRriflWdylzH27G5yqY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775616719; a=rsa-sha256;
	cv=none;
	b=e9hzu9Qgf9GhiHG1Zwl4YS5MZxpLBCysb88RG/hOwW1k7Ua5RioiPjKV3cP8YNSG/k0ySi
	krygU7aXzwMxjMlBSkKPbDdFX279LpqEqTw76069sxWENYrjzBp8FS4zMVe3zpwKhlNoW4
	WdjYhNG/n+d8RS4K/RTjcAOTP/XwbRk=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MnttrxLf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 62FCA444E6;
	Wed,  8 Apr 2026 02:51:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86EBAC116C6;
	Wed,  8 Apr 2026 02:51:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775616718;
	bh=4BDs5dW9zJtaGW/eXyIzqwPGAqrmR/Pere8PJG68bKA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MnttrxLfgWIjceDLBrD7T6mxsHluWlpQuAnVSfvkfssMuGim5D3nMqUWysoDzrF8q
	 Vg/d/PYq+g2PiJwuyJV53u9fAYWH/e9GDDETxM/1qujw7fSUU23VQ6Wt5AIjgy3h3J
	 yA4pB9Y6m/4MjHSU2+Ord5ZwlDmOp41LGv5wDQVrRkX+48iVntSbaEiNZPpV95rzM0
	 o7dixtMLL6Sb4hxcCk7KqWMKwZ2KVNgYnuzXISDbFUU7y3Q4f6QgzSKahf/5r+Kenq
	 XLy0p+dk34T72eWKhEMyJhjy1poxLFhIex1zBjGY2rYzoSZkAW6IIsHC/aG1QuLpjL
	 F2hb+JBvyQPQQ==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: linux-mm@kvack.org,
	linux-arm-kernel@lists.infradead.org,
	catalin.marinas@arm.com,
	will@kernel.org,
	akpm@linux-foundation.org,
	urezki@gmail.com
Cc: linux-kernel@vger.kernel.org,
	anshuman.khandual@arm.com,
	ryan.roberts@arm.com,
	ajd@linux.ibm.com,
	rppt@kernel.org,
	david@kernel.org,
	Xueyuan.chen21@gmail.com,
	"Barry Song (Xiaomi)" <baohua@kernel.org>
Subject: [RFC PATCH 8/8] mm/vmalloc: Stop scanning for compound pages after encountering small pages in vmap
Date: Wed,  8 Apr 2026 10:51:15 +0800
Message-Id: <20260408025115.27368-9-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20260408025115.27368-1-baohua@kernel.org>
References: <20260408025115.27368-1-baohua@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 77C891C000A
X-Stat-Signature: 67hroi5fckabxy85ja51kocmmrgee6xo
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775616719-483168
X-HE-Meta: U2FsdGVkX19jUlFgBwxYecbzn8bG1LPF3dHCOAJo3HxEG/S9wx7XBYoIWAEQ7jw9P3SofjolQtRuek+lIhm3UbJ23ty9VkgmCWuMWSGqhixYKHTSGjskS8WdnC3RsN5D4i9cWiRrV5hGQJW82CPYNHtB0uqboqpnui4IZrhZdOW84oh2xNFOehzoF3NbNv7Q9ZZ0YAPDIQIAkTn40UKyMipEPLosXcuzk3MTrq5PRExXZ16sxCEnp2SsspTzMofBtYtqBwA4b3/nMTqekYvptqHN1Tm8wbY6NnQ/Xb8Xwvk+65l2pGSofzkLY/srBONM7Kumq2lASKX4j5CHAxoqk8HjCWfZR/omcEnVkHUpae2gHEt6yte3oZ2lChUw6Kh0YhmPXbWgSLImOtIIYwUNA3fD80dja3S+k3GaYpbfqVBOqEEze09I+UnEQDpE4dIe3GHFUvXaTUm1BTstQEHB+QPjIBaD41cSGuRtK+8cnDPqPK/yTCd3gxXgb8pWS/YGjfpuCJTTYRIyvUSXPskmXuMaNkcAa6TCWjnA1HbHoTA9oJn5u18NYJ754QlFHqExWSBl8f2nbspl51Pi7Rx6cpaVT+at4JA7jw6RfuuG2EqR+u8bnAXYdLLRBOKzJPJv8Nvu9vcPWhSP/5gaM6L1HmeBiUR0Zp2JdeI6g6lyvgwMi7ex+j0oRiR/3KzOBdnOdYbT17AnKL5SqBN6LqWP6LlG636ti7MC5luq14OMOjRtQQDiKsR2FbighR07NWVkszqatMn6TjY8oOjADpozyXyYh9Z4xFOwypAmJ7ZjI+vFFMBgu0ZhCitDHr/ceEJl9cmAWWZZzESifl0/YInp0gE7P3HksM54qsiBdGXkFy5BFoF1wHXzhZDunvwYuQhDxV/xRNTnkFCaHdEgRD5gO9lSNQwKq3JEenQymtTxPQbw8xt+bMFi80fjSQFQ7pFd7aQB/a1SFp/+Z7TeWGg
 i4okEgsE
 ZGoZ0afPKjIkpTlLkCfcc7OsrCnB3W+EhZNzEl2sgp6P2aN3sIJnmq3MWkNBDeiX9e5JYEPFijoi9T0FXZVNUfRaEBjZhL4FrnVrF/8GUKJhmgoKi9byIL05xSQoIUF5SiTP9SnIzamHt0OAYjls9LZD4PCMVCkk3hUbvq1tUj3BM/ErdNE+D7GRET7wHJOW9sCijpZRtLnDQUSbixP4AymX9XXtVn8LU+ApsroUiLHzGU5MuEO/01h2OcEfRvs7GMboqhOJKLtEIIlyB3Nl4eSuqkuv04pvNZOqoimUwNFdkb35mMwLQySdiY2zuhjRbCiUVO0dCRMIWYffPZ8/3TwVeYA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Users typically allocate memory in descending orders, e.g.
8 → 4 → 0. Once an order-0 page is encountered, subsequent
pages are likely to also be order-0, so we stop scanning
for compound pages at that point.

Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
---
 mm/vmalloc.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 3c3b7217693a..242f4bc1379c 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3577,6 +3577,12 @@ static int vmap_contig_pages_range(unsigned long addr, unsigned long end,
 			map_addr = addr;
 			idx = i;
 		}
+		/*
+		 * Once small pages are encountered, the remaining pages
+		 * are likely small as well
+		 */
+		if (shift == PAGE_SHIFT)
+			break;
 
 		addr += 1UL << shift;
 		i += 1U << (shift - PAGE_SHIFT);
-- 
2.39.3 (Apple Git-146)


