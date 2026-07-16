Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0AC9EC44512
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 14:51:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 05A306B00C9; Thu, 16 Jul 2026 10:51:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 031F96B00CA; Thu, 16 Jul 2026 10:51:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E8A336B00CB; Thu, 16 Jul 2026 10:51:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C0AEE6B00C9
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 10:51:41 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4C0F9401E4
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 14:51:41 +0000 (UTC)
X-FDA: 84994928802.08.728703F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 95D1C100009
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 14:51:39 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AhJ8k2KZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784213499;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4s9VNibOd89d9UPHIC3VdfqdIw6cc3uF1PGgnXgGtOw=;
	b=7ySEVJvyvRVAnl1k//RTHoWqAieUq5sUlSY/otOkEaRCilPfkcUzFM7shk9yfafmx6VF0T
	lycQHY6Ws/LQ7hdNSt7D28QUc8JbAewDxOS7pKR2RwmIaOG+WwZiSG7sX+BoLVQNtQ8B68
	sf7rQDNJKOrfNgDf38n6IMaSzCnUEII=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AhJ8k2KZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784213499;
	b=jAfKF0bFv8zz5xo0Qu4vdeIMzMQ7PBhGTjMxPBVUzo9CK/GegAgNIXeAOCfPetBD9kRtQH
	FMR09WxWjTyd7sXeSGD8EIpG97wO4CBAY1jXiZSB1YRDU3uDsUgK0AJwQGFZP3LrokDGNi
	wWd4venbwqUg5iUeGoRNk1Cxg3aPNp4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B7006417A3;
	Thu, 16 Jul 2026 14:51:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BB391F000E9;
	Thu, 16 Jul 2026 14:51:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784213498;
	bh=4s9VNibOd89d9UPHIC3VdfqdIw6cc3uF1PGgnXgGtOw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=AhJ8k2KZFqliaAqjQf9LzR9AdE9YgK5D5ArxxTLTQgmgSXOf8jfqUAzF8TLTczJRU
	 MJap6wY76tZCjiDj7rclJjZoZ284wlfh4a9aa2DxDdwThMR4DbhDdjbXyWf51LSe+0
	 za+FEvWACbp/mW8KFJcza2s5c8KihKE/0YKLssYt9G1TkWjLEL4V/yPv7M5HlZ09Lw
	 hHenPzKWM1S1Xu683kFXEKUQvU3c9argQzI61tdzPrvTF5xh2nKGMbD+rGIFR019BD
	 G9q005m9cfgBSSWmtpJJbb3wiBvD6eywjwd55FLpuHDU4kufXrC2uDd/KpjQCKcl7h
	 bt4l/fV1Ec2yA==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Thu, 16 Jul 2026 16:51:03 +0200
Subject: [PATCH v2 04/10] mm/bootmem_info: allow calling
 free_bootmem_page() on pages without a bootmem_type
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260716-bootmem_info_part2-v2-4-4afc76c73d61@kernel.org>
References: <20260716-bootmem_info_part2-v2-0-4afc76c73d61@kernel.org>
In-Reply-To: <20260716-bootmem_info_part2-v2-0-4afc76c73d61@kernel.org>
To: Dave Hansen <dave.hansen@linux.intel.com>, 
 Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, x86@kernel.org, 
 "H. Peter Anvin" <hpa@zytor.com>, Andrew Morton <akpm@linux-foundation.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Zi Yan <ziy@nvidia.com>, Alexander Gordeev <agordeev@linux.ibm.com>, 
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>, 
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Sven Schnelle <svens@linux.ibm.com>, Muchun Song <muchun.song@linux.dev>, 
 Oscar Salvador <osalvador@suse.de>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-s390@vger.kernel.org, "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.15.2
X-Stat-Signature: 1s9nezta49bqeiqomj14cuxuj37b9tcf
X-Rspamd-Queue-Id: 95D1C100009
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1784213499-994294
X-HE-Meta: U2FsdGVkX1/I3yFOWPwkMvsDEcGiDnCFRsEJM37VL05khPJMyI3AfWRbu1FmFx49GEXaQon27jYpU3A3aRAIq0ksXdgozz5mqQ9kM2EJUs3+kVL83yJTtF4dj1ewzBi4kklBNu4cuUtc3hzRR80K9XI+TX5B0/09fmJYGB/tg4ugofRfrmpkm4jlXM8ZJQMeOI7aauZ6DbYifmVnbNfN22os91KaGlX5Vv5TKAoGuQdb3N8Km25X/xrq6OHfmQ5FrHDQhiCuHC9cg1l1CK6YPZSQj309oXz4O6ta9+zNZXtMUlgtF0vd5f8yF61myDdils24zik5eu1dv7Xf/YpS3NRu2ErYJsvFdcGD2zLIy8sKuCpOjzU+YDqM+QtEJ+0X9AGtEvWSwOH+i1bN8c7Uh71qGWJJzVG0MmYmHcijlaaDtrCZ2hJUeu1VH+ioOhI9lQVTpAvapkTssH0DTaX4COc7KqXq/lI/Nu+yPs7Xj65D3k7dgTYejbpCYMUF+Fd6gEDi7wGyCDO7GRiUKJnLdkOSuEo11pL/vBTHXRby+TDDXCZG+VxHDZQdAhxAdO+snVoyujHOyvV1iNQK7083NRY6N/bVe3EwejaqjF6tZU0N3t86CX6zwsCex+tvawz6Y39hS4z5bmzwMP1OX9OxD2MgWRkx44rKiIRjacpCeQfD7YLtWeRgUEAToIn6iJ+HDjKk4vTmGpG9AXm7PRv3iKYwA39q0es3XJv/OkiXEp/Mxe+xmJlMuI1laADktGrvXc86ojQEYry/qhSoFeI+CR//2nGB3vvAOrjtiHA0ah/agEo2TZsULDKlEWIM4z4VYawQD0SmZIer3+b6O3HA2279VQJO1e67SKitct/l5V4SPP8X8GPUHFB5pRSwAgrs06AafZXVYGOg5rvztPp/f+R5+A5KDY/9G2FH2yk4alW6tcvIl3M5aH0KB1lZbU/UF5+PYMrzlgXa4V+CIlp
 DTU4o3pe
 bqpdhfpdtblhE3LoUEJDyLGy9bxHhDVMoO2wfW216laB82z/sgGD4/S425P9y6EAWQ9t4s/sHmbYiWzPxzoxsmJDkbJd8d7N6Z6ZiA2eVrOB85GBpgrtystKzlQIVd4uNzweZOYxD6ndvvtriXSvsH9XMuUTHvt7sAwYsF8v0yTKCg5ICxJROqDvWg3jfZs9lwgnJwD9u9CoFlgz1+0WONCCk1axmIEjO8LAY/1aFi6ZrXdUgfdWH9betn4+sztNM7eXkoK3u1M64OcQH/oCZZLEHk+l2CkXfP5a+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

As preparation for further changes, let's temporarily allow freeing
pages that were not previously registered.

This will allow freeing unregistered vmemmap pages allocated during boot
through free_bootmem_page() from hugetlb code, until we fully rip all
of that out.

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 include/linux/bootmem_info.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/linux/bootmem_info.h b/include/linux/bootmem_info.h
index f724340755e55..486acc6127039 100644
--- a/include/linux/bootmem_info.h
+++ b/include/linux/bootmem_info.h
@@ -44,12 +44,12 @@ static inline void free_bootmem_page(struct page *page)
 {
 	enum bootmem_type type = bootmem_type(page);
 
-	VM_BUG_ON_PAGE(page_ref_count(page) != 2, page);
-
-	if (type == SECTION_INFO || type == MIX_SECTION_INFO)
+	if (type == SECTION_INFO || type == MIX_SECTION_INFO) {
+		VM_WARN_ON_PAGE(page_ref_count(page) != 2, page);
 		put_page_bootmem(page);
-	else
-		VM_BUG_ON_PAGE(1, page);
+	} else {
+		free_reserved_page(page);
+	}
 }
 #else
 static inline void register_page_bootmem_info_node(struct pglist_data *pgdat)

-- 
2.43.0


