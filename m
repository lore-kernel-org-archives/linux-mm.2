Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC4F8CAC5B0
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 00:49:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A7958E0008; Tue, 23 Sep 2025 20:49:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 45F248E0001; Tue, 23 Sep 2025 20:49:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2AB0D8E0008; Tue, 23 Sep 2025 20:49:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0D44D8E0001
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 20:49:03 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D4BCE1DFCC8
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 00:49:02 +0000 (UTC)
X-FDA: 83922309324.17.EBAF80B
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	by imf23.hostedemail.com (Postfix) with ESMTP id 1D74C140007
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 00:49:00 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hFkXk797;
	spf=pass (imf23.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758674941;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=E3EVyKQA6VK86fnP/Fl/PkrA2KBmPUPCTxnb6DohQSk=;
	b=KeDjeQuzV0rctLAtB/mHJ6zGuOoHi4e5fjZtETwhfpuQjeLQxfdEZEdvfWPaG2lhB5koor
	p0Dgh7iAN/pixADqq/7+GPFD4Y27NhSWLjpHquLke9H116Al4iEExpIQkzm2wwfKMksQsT
	L5r35W809FKYnnJHx+AOIjLv8PuKVMk=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hFkXk797;
	spf=pass (imf23.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758674941; a=rsa-sha256;
	cv=none;
	b=g3chuDYbF+4lXv/AJeSBMoEzcH/AuEsJJuZK6NTEzezahAS2gG9/xgYhe/6Tl8pQo9k6tA
	i3j2+zNf33cpbfjm7o78Cz4QmYKrCPw/Boid1ZypB7wB6GD+dwjUZA7tKXFRSkKp0jn+vC
	9L7gQCl6UdOme4Lni2c0NYcSC1/+Q7s=
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-63163a6556bso8716269a12.1
        for <linux-mm@kvack.org>; Tue, 23 Sep 2025 17:49:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758674939; x=1759279739; darn=kvack.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=E3EVyKQA6VK86fnP/Fl/PkrA2KBmPUPCTxnb6DohQSk=;
        b=hFkXk797Lheg/TrtDERibJhfzoP0XnQ8HW2goqd+x72t4V0obz+Gp97/d1mhWoaOjv
         /SGOWk7V7YcehrqMIYzKSDxVaXSBvciJONzdfY9bEuJkBwnDfX/xAE9/iHZdx+jeJKfu
         cel+CHmdph7tqEIvR1+4ylt4EIkUAXE5NXV1uYDFuXtCh3cn5vAb+4cOg6sKRqFISPVZ
         4bDRuTphf9DH9LPYOhzEzcEdCKfGnkMwLpD6QFm3NeowPYsxFTch20i0AJhbEPio82Fh
         ieUmYl4uyJ8MduV9jQhktJpKlb4aXj90qtOw9jDzKOXsi08gSCVMKAZKxRsm1cO2lpbq
         gssw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758674939; x=1759279739;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=E3EVyKQA6VK86fnP/Fl/PkrA2KBmPUPCTxnb6DohQSk=;
        b=kQ5J5PymeOkVqyuwYISpTbqRn0WahEHt2G6fxF3aq6/CsBL0K9cVeX6Y/L1gMigvUV
         XK5mpTsQjxzthZl3fshK1lVOKOejHt/OKMA01ZQ4aKA0Y+Co7Y+H6iWQaXTahRFLi+1U
         /Qxxq/WmTOw9tLGWZasmVBXU/NExqOyoZvXHWsKfNGGVtnrZfGuq6+0qBla+lw9p84sF
         xmvEfVQwhW7DroKmG7b6WQXUfnTAK1O4zVt7itUwXN3e/eSzV6CfVAulRIMv35WjX4oP
         B5A2k1FR3aCMuBfHT+WxthPpuMJ2BWP+l3DvjPLBYAN9Ari7Gh8cxwGJPpgDzmG8aZ7X
         4mZQ==
X-Gm-Message-State: AOJu0Yxdj8bNttIXsR1vcGyzYe6rPF9J/YsGmhtHdo8IrkQDsgFeRL/s
	a3wrdegQZ/vKF30sm1GBRAU0BkvbhZNdeT+Lu5XaXjfBklJX/A4Pw+C8
X-Gm-Gg: ASbGncuu2oHRBWOfT4qd6HIIn7XuimJp5mnEdld96qkQUBjRvGaqJ8t4Q9zrlMxVlJ2
	ItVpIp5V5J0HJSFavrUMkJ9wyp/d0TVjtbf6sgL3oAApaDM2jzaXmDWSlcZZiBUpQXAxOnssIgg
	XGKUUTULuGhhH/auFOQimB1MIR1qsdIHEJQFrAxteCO68x1daUBTPSZ70vIkvKVJkVZEWySZHSN
	Sd0RrFsRa19VwqazVlqB4+SDpQM3iYMVTYUR9sixIDhcWyv9J261RIwfinkpkcfhr7texDOnn5z
	3no0Q5z/WA/2QirqONJ2vu2/9bH/wabefDnSS6UfdkzqN6c7SqZ4llfV9EiJrhPyUEL/Y95vMdQ
	0O5SV9fXsUXCqiuQhN4P05w==
X-Google-Smtp-Source: AGHT+IE6WND7bkzkZoJ6lDNczWDsLxnyBiBx5Y7zAfF9GcDmlCWgqNlzMFrT+ZxgNCcfpTI6nso3gA==
X-Received: by 2002:a05:6402:42c8:b0:634:544b:a740 with SMTP id 4fb4d7f45d1cf-634677eab0emr4210277a12.22.1758674939431;
        Tue, 23 Sep 2025 17:48:59 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-62fa6f03008sm11549771a12.7.2025.09.23.17.48.58
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 23 Sep 2025 17:48:58 -0700 (PDT)
From: Wei Yang <richard.weiyang@gmail.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev
Cc: linux-mm@kvack.org,
	Wei Yang <richard.weiyang@gmail.com>,
	Kiryl Shutsemau <kirill@shutemov.name>,
	Dan Carpenter <dan.carpenter@linaro.org>
Subject: [Patch v3 1/2] mm/ksm: get mm_slot by mm_slot_entry() when slot is !NULL
Date: Wed, 24 Sep 2025 00:48:53 +0000
Message-Id: <20250924004854.29889-2-richard.weiyang@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20250924004854.29889-1-richard.weiyang@gmail.com>
References: <20250924004854.29889-1-richard.weiyang@gmail.com>
X-Rspamd-Queue-Id: 1D74C140007
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: m33j1k6eh6fi6sqb1hfshyqif3z7xmrg
X-HE-Tag: 1758674940-487920
X-HE-Meta: U2FsdGVkX194MzDYnytPwGcrbdiT4eIb6ArticP+cOqVpREIakhn2CpN8pckvS85v/qqMVX3dxAu7Z4J4SU6hxMDp6SNonIB93kURgqalt2h8UHTizo5DRCb78wc/HTDkX+c5rZvsqPW+MM1qe9fZVXAZxs6NfYd6ZfxlP3TdWAEeW5V1ghXaGYDsULlbrb1H57RSn+StmMe3IWHUqOCOlMkCPQsgBN1AXtJcRjvsGJvdvMlG1jAiafzkPzLDkMz/Q4ftubPp5pJFI46Qpjb90Uw0DvpXnLPiJrBr/BWlX4l4Ix0e0Nm+fHI2V4ZROrIIo45agbVKVyUaHNmwl4VJIs/zSRESDDKQTspIcsL39dc3RsEu8509SypZ9OuORiAfNWQ99A1B5+JaPK9yHYCGOGEnTDsFxyn8bwrYS7fcvEbr/SukJXRY6Uf5vSwYapVqyPXn3tSTuAUfBifR3TrMv+NFxBqc4Nsgap6xjEO/WfiSP/oI82g91Bxg/44Tmspv1eoB6yfNP2N9V5IyygPf9nep0GFOiPyKfz7a+UW0h45uAsuhGLr03r5IBC1goP/+EbAaU2ScgkC8YPO4r2dBS8QjL/ME4cKby+Jd+P+c1V27FY7IuVo/wP3YRjVnL0hVpLaiNYK4D84sDJqR8psQgQvHUvAf+fDVrbRjd5r3YaJqIb16cO+jQIAMUu4zpk+KNaG71XPVd4m0ZpTwYx8nYQZ7+b3G7kkYR74p8PP8rgLxOGvJCLX1xoigiGNSOZ+2DLIL72BN4f8P1xJVLplMPxlrtxb17994Zt1KRYrBThsnJZiK9pd5rrGIQZPL4T+oa4w2r1krxDMPIh7HCSIGPJ8k5d5x8I85r5rIE32Yke/udMelw3o6Dc0CFINdOlarfO/zHO6rM14DcqOwdNjP2iN74HO7PJ9qNaWj8j+9fuKJ0e1NjSN22bKMWtu9v2PIKRhdh0h/djIfEC30z6
 b0jMrObH
 TDBrviC2erWjA7R+BkwFCMwTSAD/LUkmHUkH8bTmlMBVWF+/e39L9LKlV92DCmYMS8SbwrJebWCCNDZ/QSSN1uYGrRdOgCxcWJ0ybdtQaoQMuI+qPegBv/OppNOQKT3nT27+wUDpNzvPL+A8EHAVAnv7WYu6Bl9nFxjROA/qvY+t/d23QSEdpcQLfqR9PYWOMTChq0SNPdkUpVX+IA8IdODane7ByGayRytuMjJ5bd97umNt6eJ42QrLPTS8IvcI7gG3kB/1tmv/Bv54t/p9kVAqZmGcs2LSHWpQ40xzW8ougz1gUV07fl2b8Jh3WVSw6mds0yl4+lcgZ6ExqwR2/Qwp3G/QGSBWYlh2PPA7PGOetr3JapoWTPtP8REcKnIERz/zUIciRDjBTLBu0RRT7fKHbv81htU5k6+kF87NpKeWt6TvwOy2e5zl4P97yx4vjiJRi4kfRa8sG5efpmgxldW5IoKbVes/NdQ44B4idv7hpuPIwa5CAH+xMKsgMcOfL/wune7njOSdehekkStobko5pYhEb4fq/3FzfGmQVWK+Zo7SUcDL3+Z9az07xC4QcbD70PSkXmuU5dNuLWjIlB8GWYBYqSLo+bnR+RRikaqYmVY1GqQEfsgQnT4S5PeVcqrkrL12Mr+/GNs4KU9nhLmi37wv3yq6F++eNBWRNb97ZFCdgMPIBlfyRBgtGSfRmPz3J69bhc67Kj4MVqtJeqI4bWkbnSGbbUExOtlaOTw9hAimNR3iO7xMINw63sE71U9BqKHt2b+EQ3yV7jgNeMxEroZqbPpq3Lk9NSA3xpUHB6V6SJzle/iWHBbrLx47J0opvqGkRq7XAuTz5HtFzk1FYHef6VxiS7SZ1
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Patch series "mm_slot: fix the usage of mm_slot_entry", v2.

When using mm_slot in ksm, there is code like:

     slot = mm_slot_lookup(mm_slots_hash, mm);
     mm_slot = mm_slot_entry(slot, struct ksm_mm_slot, slot);
     if (mm_slot && ..) {
     }

The mm_slot_entry() won't return a valid value if slot is NULL generally.
But currently it works since slot is the first element of struct
ksm_mm_slot.

To reduce the ambiguity and make it robust, access mm_slot_entry() when
slot is !NULL.

Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Cc: Kiryl Shutsemau <kirill@shutemov.name>
Cc: xu xin <xu.xin16@zte.com.cn>
Cc: Dan Carpenter <dan.carpenter@linaro.org>

---
v3:
  * fix uninitialized mm_slot
---
 mm/ksm.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/mm/ksm.c b/mm/ksm.c
index 2dbe92e3dd52..c00a21800067 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -2921,7 +2921,7 @@ int __ksm_enter(struct mm_struct *mm)
 
 void __ksm_exit(struct mm_struct *mm)
 {
-	struct ksm_mm_slot *mm_slot;
+	struct ksm_mm_slot *mm_slot = NULL;
 	struct mm_slot *slot;
 	int easy_to_free = 0;
 
@@ -2936,15 +2936,17 @@ void __ksm_exit(struct mm_struct *mm)
 
 	spin_lock(&ksm_mmlist_lock);
 	slot = mm_slot_lookup(mm_slots_hash, mm);
-	mm_slot = mm_slot_entry(slot, struct ksm_mm_slot, slot);
-	if (mm_slot && ksm_scan.mm_slot != mm_slot) {
-		if (!mm_slot->rmap_list) {
-			hash_del(&slot->hash);
-			list_del(&slot->mm_node);
-			easy_to_free = 1;
-		} else {
-			list_move(&slot->mm_node,
-				  &ksm_scan.mm_slot->slot.mm_node);
+	if (slot) {
+		mm_slot = mm_slot_entry(slot, struct ksm_mm_slot, slot);
+		if (ksm_scan.mm_slot != mm_slot) {
+			if (!mm_slot->rmap_list) {
+				hash_del(&slot->hash);
+				list_del(&slot->mm_node);
+				easy_to_free = 1;
+			} else {
+				list_move(&slot->mm_node,
+					  &ksm_scan.mm_slot->slot.mm_node);
+			}
 		}
 	}
 	spin_unlock(&ksm_mmlist_lock);
-- 
2.34.1


