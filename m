Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4EDA2C5DF74
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 14:11:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5ADE76B07BB; Tue, 18 Aug 2026 10:11:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 585316B07BD; Tue, 18 Aug 2026 10:11:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C2386B07BE; Tue, 18 Aug 2026 10:11:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 30E946B07BB
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 10:11:35 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B28DFA2A87
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 14:11:34 +0000 (UTC)
X-FDA: 85114578108.08.5C22455
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf27.hostedemail.com (Postfix) with ESMTP id D867B40011
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 14:11:32 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=GqWBrhBu;
	spf=pass (imf27.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787062293;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O+b83bGMCzyEzByJ+5LU82nBa96lT9m0LV7qEzNfGOc=;
	b=F4X3kKJf4hIFdScU2krRuaeXaQhJ5LF4FE1cMcCZbx+9cpL0Bq4uWiWzir64kFDLyGpff9
	fR5i17Ibqf1ca872/qt+xRADrvHSXE2mjoyno8oEB0psUOTdnf5gI+vNnr4a2HNVHriNMW
	Q45+WEX6H1eYLKImrsx8iPaP11I1P84=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787062293;
	b=CwwQhO/DN6czJ0KT5mK4gjGKLqRSHbLRwtiA8vVqhssmaBPjSDkXDwO4CWGi/qzOF2SN0S
	4xefMEa2tbYagWlXzqAZnvhXAp6I8pnrmqL3qMd4Q4cdB9OM6hLKXiW2W/6LkqUhWAoA04
	LnFXQZq7Je0S+XU29nRQgIOAOLsj4Gc=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=GqWBrhBu;
	spf=pass (imf27.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2AD8B152B;
	Tue, 18 Aug 2026 07:11:28 -0700 (PDT)
Received: from localhost.localdomain (e123572-lin.cambridge.arm.com [10.2.208.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 690E53F85F;
	Tue, 18 Aug 2026 07:11:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1787062292; bh=+OGpwgzVEkFFPsMOgL6J2ZFY9bOrw4hijWLmgpJn7uk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=GqWBrhBuTT2Z+RmPO2jLniGoqbeXO1MzPDp17DBjTk6bl6eWab6GB6sMhri7bvzCZ
	 ZkuQWZHbRHdq/2nDVNSoTGEdT3paXyJEiQETePGSw3zcJSwQPT4uDOjGeWz7V18zMZ
	 UFO845i7sIb0wTMe6wGNhlTHQ4KzOxZVW3YVXE0Y=
From: Kevin Brodsky <kevin.brodsky@arm.com>
Date: Tue, 18 Aug 2026 15:08:44 +0100
Subject: [PATCH RFC v9 02/25] set_memory: Introduce set_memory_pkey() stub
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260818-kpkeys-v9-2-743ad31b2c8f@arm.com>
References: <20260818-kpkeys-v9-0-743ad31b2c8f@arm.com>
In-Reply-To: <20260818-kpkeys-v9-0-743ad31b2c8f@arm.com>
To: linux-hardening@vger.kernel.org
Cc: Kevin Brodsky <kevin.brodsky@arm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Andy Lutomirski <luto@kernel.org>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 "David Hildenbrand (Arm)" <david@kernel.org>, Jann Horn <jannh@google.com>, 
 Jeff Xu <jeffxu@chromium.org>, Joey Gouly <joey.gouly@arm.com>, 
 Kees Cook <kees@kernel.org>, Linu Cherian <linu.cherian@arm.com>, 
 Linus Walleij <linusw@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 Mark Brown <broonie@kernel.org>, Matthew Wilcox <willy@infradead.org>, 
 Maxwell Bland <mbland@motorola.com>, 
 "Mike Rapoport (IBM)" <rppt@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, 
 Pierre Langlois <pierre.langlois@arm.com>, 
 =?utf-8?q?Pierre-Cl=C3=A9ment_Tosi?= <ptosi@google.com>, 
 Quentin Perret <qperret@google.com>, 
 Rick Edgecombe <rick.p.edgecombe@intel.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Will Deacon <will@kernel.org>, Yang Shi <yang@os.amperecomputing.com>, 
 Yeoreum Yun <yeoreum.yun@arm.com>, linux-arm-kernel@lists.infradead.org, 
 linux-mm@kvack.org, x86@kernel.org, Ira Weiny <iweiny@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Thomas Gleixner <tglx@kernel.org>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787062276; l=917;
 i=kevin.brodsky@arm.com; s=20260427; h=from:subject:message-id;
 bh=+OGpwgzVEkFFPsMOgL6J2ZFY9bOrw4hijWLmgpJn7uk=;
 b=fzhJpHPj7MYRTjp/HCw+erSxU/CpJ6la1guJcVIYXR3YYwefH56ufe+Ej8z4qIeVthMvdJfjR
 FRItISUl4vcBKIMhTDxfFQ0oZ4ArYUUIpp0VT9dk/lF5oTo/1vMcX50
X-Developer-Key: i=kevin.brodsky@arm.com; a=ed25519;
 pk=N2QG+eJKrvkNovwhhwJhnJ4+ScVfsGCHldmqLfcMTFs=
X-Rspam-User: 
X-Stat-Signature: a5jirqxxteme8erw1iu3s6xbdrn7x3n8
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D867B40011
X-HE-Tag: 1787062292-902652
X-HE-Meta: U2FsdGVkX1942DZsrMENCIOG8wG7LnplHByxf1veOsGHdmRnAIMpwPAtm93qM1ht6L9YsDbAdszKUVCg1jTwyUxt0G12LOhIUW/8RaQv1G8m/tFEQmKdp2vxM9ePtHVf6oX0qqjbUS3LLAdTfSIbv9tWBxmvG+GCIL9Cwq+T/PpP8ZonrFVnh4epMXZaKSw/akCNZHaI0XrSi4KWDVcKN+9CHSp/Xhf5J1rxkUGWw1IzARbb8t/F5BtlK5igN3d+v2K917hjORoJBytO4MATa6KJHiJNSn5LGqX/npPd6AkvCVvvo1VeXyyRrkaAXOKGTH4+1uocvub5P8cmwekXPqvedaJnx4JqtcGmMM+QExyJfHrwL9qlzFEWrA2IMKN4kTDE1g4YsNCS6XeNjBYw24zC2v55+MFLd3xdflQ4UZSt96aJb1fFxwvaCHjNfnRyL5Th6av7aqyeldhPJ+C75GFpVxoYTmeHHe+tFSbbQV4mUU7x2sUPwQ4gs+devRrVzptSB+SvLrLQ12282DNysO7mAR0tl52XBwtI1H5AaCfffA/sH/94aQVqNCdEPTqwk0ReJTRCcIRfxvdSrKabLaHKXIkfs/zWdtuPpCxV6QiRJpSrZgPuUHlZuDqXMoCIxFp9Rh99xT8IkAOvYe4+xxPiqAYXa9Bh3BDPB4TS+3fJ9fQNnnXMe7sG/6Cd/erZ3XJt3iRYXz4m/JJ46q9wrOuO49IHZlTHYuX6BPiqZ5w7XLp/Ebw+M6XqKpFKLHH+kepJyfhUllYn4mCpDHOdcUTq2CAoLN3xJbgDlz/iXiLzIADlPj+JIzIH0yUeVK/kzIMU/75InJxS7Vtn9+Po0i4//RL2cSBNq4GnS0eI4C0HVif+3DeyAyDqoAeZrd29N+GT7dpPqxjTxDGk9Kipxfcj0rfFC7Iu+rj/rrO09cbHuNA2JYXf3HpcF8KJOFoIQYS+fXAKjLru/qVYZvj
 dBA7jxLa
 /cTqDawRVFOL3ZOvpym6MAGfygoGT1nmUQWNGfnaYZTTn5gTD7gCKaofSh1BoCh7WPD0Iq7louts0QERkz6vXHaEiXCIqWMv7xo+aXrR1/e3J0Wyu3OsSvvSjXNWxRgd5o8oPj7SWejXqH1Fg/oa0Ws27c9+6IriYIljcNgST7UOs5N+otAzBU0EGLS7MPep4kJAfS0uECjTkEyHI5sFx/eIRHb0LaWDJhiMNSQ16rGcGBBfG3WCfdvUaJUa8opxQALkv2S4x0Vc7iJXZ0ZAgWW6by3pCx1/fpJw2d7ZpZcf8USw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce a new function, set_memory_pkey(), which sets the
protection key (pkey) of pages in the specified linear mapping
range. Architectures implementing kernel pkeys (kpkeys) must
provide a suitable implementation; an empty stub is added as
fallback.

Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 include/linux/set_memory.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/include/linux/set_memory.h b/include/linux/set_memory.h
index 3030d9245f5a..7b3a8bfde3c6 100644
--- a/include/linux/set_memory.h
+++ b/include/linux/set_memory.h
@@ -84,4 +84,11 @@ static inline int set_memory_decrypted(unsigned long addr, int numpages)
 }
 #endif /* CONFIG_ARCH_HAS_MEM_ENCRYPT */
 
+#ifndef CONFIG_ARCH_HAS_KPKEYS
+static inline int set_memory_pkey(unsigned long addr, int numpages, int pkey)
+{
+	return 0;
+}
+#endif
+
 #endif /* _LINUX_SET_MEMORY_H_ */

-- 
2.51.2


