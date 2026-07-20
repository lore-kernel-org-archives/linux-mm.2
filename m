Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3118C44515
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 12:04:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B21A66B00A4; Mon, 20 Jul 2026 08:04:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD28F6B00A6; Mon, 20 Jul 2026 08:04:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9EC796B00A7; Mon, 20 Jul 2026 08:04:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 767CF6B00A4
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 08:04:36 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 056E4A013A
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 12:04:36 +0000 (UTC)
X-FDA: 85009022952.11.44C1C63
Received: from va-1-111.ptr.blmpb.com (va-1-111.ptr.blmpb.com [209.127.230.111])
	by imf17.hostedemail.com (Postfix) with ESMTP id CD19E4000E
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 12:04:33 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=A5NekaIJ;
	spf=pass (imf17.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.111 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784549074;
	b=ATUL0BZtImm9j5QL0QIM7uxe+05+9ul9JQE5/KmCEMkSX2UydHnKlJ5VKn+z3YhwR+c15S
	MTUXW/hT2fNX7fRffRE1N2YKukkwzh8yjkgeNvyQQRr69uqk9b3tu3KEdQ9oToEPmen6wW
	gFdyMDrX84fC+8Bsf0LrcHrJQ00PWdo=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=A5NekaIJ;
	spf=pass (imf17.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.111 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784549074;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6LDfmUcelxmT9nJB/bHRwgrk2ZzY+G3Dy0t3Kxw/TPQ=;
	b=OYdz0q1i3sKABGcD4ILHC6RgDQJLO+RwAKlD2bxnu1ib0XK0FQEuJqCggiqBNAy2RrHiSI
	UqZ8MAoMnQ7zfO/vq3+xlrcff2DvZ2rWdy06uzCG0/0g30cUU3OTdrOqHeXpcsWfsZg+xP
	PMFa/P/OYDESmA2rTvcfs5k4S6w1AVY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1784549068; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=6LDfmUcelxmT9nJB/bHRwgrk2ZzY+G3Dy0t3Kxw/TPQ=;
 b=A5NekaIJyAFlECrGgRgRqQaxnKMRsmqIKIteayYHk3n8ScAbPaqT+ZHSc/k8phL4tbIAW6
 mjHo6VyuJYqG2nS2pM3cX/xVLzO7Y6ASrHr0/m4LSgOCrMY0SbZAYdwG6+ddQeRhySNk45
 JDk92v9+HVl7r2c/Pw9h+D5WJ7FAjleAVBtTq7NzKUNxRu/SmvT+KUjNYPOHBW7oT+Wof2
 EcfP8xw5a/9vssmr/lKe5PjaqqQuGNnoYSuMVxWqLXfshDS4xTa5M6lN5TYj/NA2h834mY
 7G82HmFecyFcencJqW5uKj/cugYQe9ldqPxU3DddMZpt9aOJt0sl3XDlX/oyyA==
From: "Li Zhe" <lizhe.67@bytedance.com>
In-Reply-To: <20260720120259.1545-1-lizhe.67@bytedance.com>
To: <akpm@linux-foundation.org>, <apopple@nvidia.com>, <arnd@arndb.de>, 
	<balbirs@nvidia.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>, 
	<david@kernel.org>, <kees@kernel.org>, <mingo@redhat.com>, 
	<rppt@kernel.org>, <tglx@kernel.org>, <muchun.song@linux.dev>
Content-Transfer-Encoding: 7bit
X-Lms-Return-Path: <lba+26a5e0eca+5ce75d+kvack.org+lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Subject: [PATCH v7 1/9] mm: fix stale ZONE_DEVICE refcount comment
Date: Mon, 20 Jul 2026 20:02:51 +0800
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
References: <20260720120259.1545-1-lizhe.67@bytedance.com>
Cc: <linux-arch@vger.kernel.org>, <linux-hardening@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <x86@kernel.org>, 
	<lizhe.67@bytedance.com>
Message-Id: <20260720120259.1545-3-lizhe.67@bytedance.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.45.2
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: CD19E4000E
X-Stat-Signature: 54yr61k8cketrh36cgtpbwudhes1qi97
X-Rspam-User: 
X-HE-Tag: 1784549073-935912
X-HE-Meta: U2FsdGVkX1+yUmSvqn6/IoJlq59Ojg18QZs87ymbjlbQf7E9dBdnXPAnALB38ZqxLx9RDFQIz30gnFXOvbG2AgMr7QyzTKC34q2eGAqJ2JEq5pzQ/usgxQnAOb89u54BGlq5EdQMqgfJnj3U9xKWyCXSz7A/DnTeK6VDPk3rd1bdqgMKKo+iS6iO4niNK4N0DgLWqIjT9Fa9/rum+hOJX7lfkxxeXiHjOqqS+ZRxdKuuCb+fI+0WAmSeWWC5w0XeTLdnOFpoICvNa0j2pgHSjySOA4QQU16wErwbYaAQoXa1+ZkSLLIsDHec8NaLw3XiCWPFh2QncRimZuhdNaEkgOjuQ4+uPRzk6kdLUB4qndOF7gXtszMSc72wr8IftRTKQ3o+AF4s7xlCEgZHF4K1x3sCMzZfh6MBCfRiyNCO+E26SYEwh7BTPvSQB57vRTmTkqpiDysK8i4YTBkqoyjsexp0dhZS6xL0uDgtGGOSJLw0qfzwn7m1zCd/RF+eL2QR1tuwQBbi/+iAbFO6PV2nw8D46k1FAhbtAYyk924R2sulH0iuQieT1h+YrqyeHtPO6M3DGhBV6miaoCTWGbTxw60+Tvidsq9qe8PFfnUjSDwW9Svl29926IzsgxQYMCjo63TZgwJZ7nrs8sajTjIGyG/PpvvRXprxSQd78J7TiaEAUk2M+ZhpeWme3M5SSPJk8a2SV5VPgxlnk14nSewEY78iMn3fliKItt7pG9RfIDcSjlUJd4QXmSul3rZPv4GicBcJU4JQDXRUOPz/xKb9fR3UZZjrkoFPWOBiKQeMhCdOUC6zE7GbgV143fUzTwRzDUp739Fw6CZOXnIhW8uobGbrFcmuZiUc2A0Zk2XETn5sMpcSg6ugZSsgn+ojeroQjVh4+UF586RelNvF4G/5VpRtXjYvwzVAPsBrI7FyMMNDtl0SCuq1iLamBAlEYivWp4SnaM3F1CsUJu0yBVX
 +JGP10a9
 B5YdR/nJaX0OWN/vi+IexBR/3hnTVcFEZLUXy9tulslv4oCMnGpM6J7hQGVvTmb6/l5TXMhRHQs02AX96WpJyZZsXrthu6K+y2bGq3EGUQBkjcQ9Mw78N35E4H/rFG1HYVo8qTPUoGlJVDAnO3tFODBogx8xldjzdE6CGtmcF5UwVe2JoV5ASQ85rj8WzMLnB4kYcm+Cs+JViXPUYxG80uOT3BrlCiXKpLpU8uHzWOH18tRcqoHadVst4qS3nUk1fgLC7dDE5XLUhF0BIRxxmQhS0COfLL/bQrlwF8AW+yUUhT8T8redXSvHldM6ywUvq5PKJ11KeVWCxw8A+xX284yVTaofMjtV83CJP
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

