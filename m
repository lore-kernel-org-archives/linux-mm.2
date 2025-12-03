Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 776A5D1266D
	for <linux-mm@archiver.kernel.org>; Wed,  3 Dec 2025 06:30:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 636FA6B0008; Wed,  3 Dec 2025 01:30:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E7436B000C; Wed,  3 Dec 2025 01:30:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D5B26B000D; Wed,  3 Dec 2025 01:30:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3A0826B0008
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 01:30:23 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 275C4C0517
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 06:30:20 +0000 (UTC)
X-FDA: 84177185400.14.FB329DB
Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	by imf04.hostedemail.com (Postfix) with ESMTP id 6184640004
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 06:30:18 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=iW8tXfc1;
	spf=pass (imf04.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.54 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764743418;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=zA8y4i15lHs4OWfRLesRXJafbhw/AjPpbVqRC57AGyo=;
	b=OKzQ793ZDNomh0tjzdeDgkAfnw+6YykguJeT9ShCVw2OzzsF3CHKkHpAhkaccI48jHq6ow
	nu4v+/IQPXmOv9KB4eEObZMcgIqZJm+GE3XEsoKP/IZeadbYdtP/eHCBNki95MswELY/Yc
	rrfcfzsokeqatqwJMskjE2wCLegtjE4=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=iW8tXfc1;
	spf=pass (imf04.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.54 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764743418; a=rsa-sha256;
	cv=none;
	b=HazoC9byWg3QHgkeB5iHALN6ckVoKcnpgQK1E6Gh5K+lN6naXrgbrexfk0vfD3Rt2TqtVd
	SLYXB5Sa7uzCokBLR8j4mHVGDhsrZjwlBGM+G2TxY9DYJpISdEJXlNWOzG0+0fuXgqfevG
	AWgvS7cnBVSha87hG/FWdleA6W8kzns=
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-880499b2bc7so65612256d6.3
        for <linux-mm@kvack.org>; Tue, 02 Dec 2025 22:30:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1764743417; x=1765348217; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=zA8y4i15lHs4OWfRLesRXJafbhw/AjPpbVqRC57AGyo=;
        b=iW8tXfc1s7ZpwofBhZPzVYu/EORF80Zu7RtpFK1jYOfrfglOp4LA/xqiU+eIsTpt+h
         qKCGMuwOHGjaEhpuF1tZa6AMGzhyQgqE1yUlWiiBcLez47mg9oeUvQLUFVf7fenY2AL7
         ltRCHZWH0zQsu8jTlGcok8UggUdEFt0D/lvP0FkEdSxt/ztieSKFJs0quTdh1j9M8TAY
         PEepoP7vZQHR/YpxxNj4VyJQfU9xDCShwxZCLGJEHV7sUOSe+EsIomEtR68XftQOrMmg
         NTEchsbzrU3heU2ItRDVIZOMe8ly4DPWlDC7xPtS2Qf+WqiI7ZVxRxXe4K7LxZ0+CJ2M
         vvcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764743417; x=1765348217;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zA8y4i15lHs4OWfRLesRXJafbhw/AjPpbVqRC57AGyo=;
        b=b9HNUAW1nYi1zTruHyWefduIB+WniByA00TvLqawGxT8hwdBTf/0Dkr4r7fJmZtkHG
         PnI049uvEF5E/WmHtb8v47ovwuNuB5U4z9TsLv4ZH7Y1MGj6SUbb5C3qG8xubxhFq78m
         uZuX/HYE2lbMvOEX0iXZtrjCrHrNJp16sCTuWXXkzBaK9ywrL1JQYVSfnCAFfp71ulUM
         Knw6xwQulE+EFJbHFCa2VbvuUamykIx4T6dX9qGyiu5nT1AYR3UVmj42HI9WcjvPc1sp
         ysDKavrn5+A1LkNv9oT1PynYpWjpc8lRjA5zEIq6gS6ilttVAgPsQ7+dY/92COjSDugE
         08tA==
X-Gm-Message-State: AOJu0Yy/oTFGD47dauLjYffoXnKMrVj5Yf4UR7U5YAAZLebG0Djwkl6Y
	fMGp1OKvo1QYh3S78b4mwzwJD7yDNRsiI2mLNIb5MrFMlBU5CMr/N4Sdw1Yt3uMvts4Dw06q97/
	HdoRm
X-Gm-Gg: ASbGncvDBmEg6GPDM/jQFh636I8FRb4toH5qYUq/CouO+7RAVhpsuWVRiy8mAFRcdYy
	SxZwmxmTBWbCnuBVme7QJ+xQ4+PlKdW6j9zMxwR9wQxCpMosmz0oLAwct9qN3UnHXj/AZFICPQC
	HuHcmMHTN7f2ZnuF8ULkeBSYdNrhD1Gy2r0ohhWIfh7105Y5fORm7TMWzValy5O9Yhc2herQ6xA
	AYUtJXvOgD6CQ2CYXJn7V1S7BYXLT4m3BHKXpScLYpH+3SR6KYyhBEjwVbV3/B/q1sWxa3AFtUd
	Z0IlGCzNaybQS3d2Xp8BdssZWYoxP7eMh8QyKT8ybtiOsLBeFG1SFLxtVKrUYJKxFxqmYJEJLvH
	ejudz+36fLsHcvcvePxWhx4OHPaGdkOfnzviOBRGix92gEByDkwQKtZsrnlschEq+2RTuTGnZsn
	tbExdaWBqL7x79wmQxREJlOq9x5cYoeH7HxrprgIcrydou0mW8/Fnv6gNLQzUTZHwem4oSFI5cj
	SSNJIFZJJ98WA==
X-Google-Smtp-Source: AGHT+IF1GdXPSabAZHw0YMxptT9SRN1HvIpeNLe4gzMuYc6tHsW25MPHAsf8Dnnhll6yIyHsxXJH7w==
X-Received: by 2002:a05:6214:d0c:b0:880:5867:45b4 with SMTP id 6a1803df08f44-8881949a8b6mr16086076d6.13.1764743417043;
        Tue, 02 Dec 2025 22:30:17 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-886524e4b15sm119791806d6.15.2025.12.02.22.30.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Dec 2025 22:30:16 -0800 (PST)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: kernel-team@meta.com,
	linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org,
	vbabka@suse.cz,
	surenb@google.com,
	mhocko@suse.com,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	kas@kernel.org,
	dave.hansen@linux.intel.com,
	rick.p.edgecombe@intel.com,
	muchun.song@linux.dev,
	osalvador@suse.de,
	david@redhat.com,
	x86@kernel.org,
	linux-coco@lists.linux.dev,
	kvm@vger.kernel.org,
	Wei Yang <richard.weiyang@gmail.com>,
	David Rientjes <rientjes@google.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>
Subject: [PATCH v4] page_alloc: allow migration of smaller hugepages during contig_alloc
Date: Wed,  3 Dec 2025 01:30:04 -0500
Message-ID: <20251203063004.185182-1-gourry@gourry.net>
X-Mailer: git-send-email 2.52.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 6184640004
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: ywgrp1x5q3da43b5uz1ywb1cb4udpmi7
X-HE-Tag: 1764743418-338809
X-HE-Meta: U2FsdGVkX1+XNKkXcbnNs0SpATh7soKPsqelNcsO/t/wXNiXUvIYzgvMJgDRoF7uqNDggw3O7l1h/kdZgLf5TBO5skZFR3QstE9bzD+Fq0cFELIp3C/ZItchI4XlcnNw4yIwbv1VkdlApJGbvBR+fs0JOPu7FDa+PC+sX4qeYCtGrfKUw7d9MYU/4TCFx8IDKLT+leriR9NcE0BUlO9vlQ4dtvXb2Rz3gqBt14JKfUDZ3CC/IrmjWyWZheD4EumXKSXs0fs01xz2P9KvuWfvCYPINljmHQLrlKf7xLVYC9ZhcKm3fSuGwpSS0bb/TlwByvHKjRUZqMoheXPzhI2mmWvAGuMw8+V+DA9C9N1vIQ+E1Jw7bc4gzsjywZ9ifNju/65W6ZjyXpqE6rc+T7Zqw/qEmhzauhxCJPLte7HDE3PLMr5QvFTThJoziMl4p5L0i2j9hnN7OdOUdLbFLsv2REOISMaS4X59M1NDc9awNMwaHcCM/XRHrzx7I0FjAE1FBlzM3alFlHv47P7WFB84Lyt2m/7+/2cNoSmjsiRqxskiQGWEWGPSCIMfo2Ogz5CNelGIYpVbxQmnfwDkOIIui5QIOJ0He8EtIwXn/1rHxhdjZwCgy97tiu09dDn8T8ANLEwC717y3Pv7Qq0K2pPhKxUOw6YrSjT45HzDm1Fu68PHEnBg6dVMxCCQNm4OSDU4wZkvoL/54tlJPu7CdHJjxOnbeknFrx5lqnn5V1EVAfREDaMwEJpVU3mEqh8iq/5mI/LrEnFCzV6VdjiRIaNxieHudKfBG+S2uoZmB1TBiyoS6p8cCRbp+f1PsvTr8jk+MnQVdQtEFcCF1SAT4Tzp4q5M29SW1Ho93B+DDhqHPfukNkrEJky2W+5N/bMZagH7r3nk38NJV7SJhPK5HT1xP0Ir9Ut50zIC0KNg2vj5ugATiu/+VKyx2CoAU8PkjxAz3SGQpGsxqKzPqzD/C2c
 /p0oai0z
 SBs7JagYXxpwkiiuccEwGdkMvOX5c601cNq0TbFhB27bH9TN2VoJyjRYUO4M63LMFYb3oLo8Of9b95OrgNQp1TI/a8FahI3s3325ELh09P6t9IBkK+bkynq0R2qhz0wzh0rovjZkbOz4XTS5DpQSPd5J15h5mYBygEcsG/uWMAwXdr9fDvV+GdHydAkI7Q3d0LvfpUXZ02kz/GZGMRwQ4UWJwdyHzoJOq+dUti0V6doGyLfpZ0T1WxL60Gq8NsZr4viC1ibCwlBFjAhpXdEdHTz0g4fL4ue0CwIqB0A3Cbacp8XoWPHo4vPAdnZ4yJEQKeRcG4gLTA8x5Bj8rREEUQQRgOJPf68v/KJVxN2RA+KswEJlFQmUI0Rsq0y+hEGQvcVfXxx4YGYp/p8vzb0vEuY+DIsek8pg8/CDtELAhvk0w9le4kwlGV1+ZA5dcMdfqow1356dJcpqb/OSPDjonZ3tlw+8MpR19Ha+Wa+zUz8Anm4B9Z/Tc3w1h3UXQ2LpC7CgiQ53SnTHc3g1G4uf4ZNUFoZ/5EgfLGGbo
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We presently skip regions with hugepages entirely when trying to do
contiguous page allocation.  This will cause otherwise-movable
2MB HugeTLB pages to be considered unmovable, and will make 1GB
hugepages more difficult to allocate on systems utilizing both.

Instead, if hugepage migration is enabled, consider regions with
hugepages smaller than the target contiguous allocation request
as valid targets for allocation.

isolate_migrate_pages_block() has similar logic, and the hugetlb code
does a migratable check in folio_isolate_hugetlb() during isolation.
So the code servicing the subsequent allocaiton and migration already
supports this exact use case (it's just unreachable).

To test, allocate a bunch of 2MB HugeTLB pages (in this case 48GB)
and then attempt to allocate some 1G HugeTLB pages (in this case 4GB)
(Scale to your machine's memory capacity).

echo 24576 > .../hugepages-2048kB/nr_hugepages
echo 4 > .../hugepages-1048576kB/nr_hugepages

Prior to this patch, the 1GB page allocation can fail if no contiguous
1GB pages remain.  After this patch, the kernel will try to move 2MB
pages and successfully allocate the 1GB pages (assuming overall
sufficient memory is available).

folio_alloc_gigantic() is the primary user of alloc_contig_pages(),
other users are debug or init-time allocations and largely unaffected.
- ppc/memtrace is a debugfs interface
- x86/tdx memory allocation occurs once on module-init
- kfence/core happens once on module (late) init
- THP uses it in debug_vm_pgtable_alloc_huge_page at __init time

Suggested-by: David Hildenbrand <david@redhat.com>
Link: https://lore.kernel.org/linux-mm/6fe3562d-49b2-4975-aa86-e139c535ad00@redhat.com/
Signed-off-by: Gregory Price <gourry@gourry.net>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: David Hildenbrand <david@redhat.com>
Tested-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 mm/page_alloc.c | 23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 95d8b812efd0..8ca3273f734a 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -7069,8 +7069,27 @@ static bool pfn_range_valid_contig(struct zone *z, unsigned long start_pfn,
 		if (PageReserved(page))
 			return false;
 
-		if (PageHuge(page))
-			return false;
+		/*
+		 * Only consider ranges containing hugepages if those pages are
+		 * smaller than the requested contiguous region.  e.g.:
+		 *     Move 2MB pages to free up a 1GB range.
+		 *     Don't move 1GB pages to free up a 2MB range.
+		 *
+		 * This makes contiguous allocation more reliable if multiple
+		 * hugepage sizes are used without causing needless movement.
+		 */
+		if (PageHuge(page)) {
+			unsigned int order;
+
+			if (!IS_ENABLED(CONFIG_ARCH_ENABLE_HUGEPAGE_MIGRATION))
+				return false;
+
+			page = compound_head(page);
+			order = compound_order(page);
+			if ((order >= MAX_FOLIO_ORDER) ||
+			    (nr_pages <= (1 << order)))
+				return false;
+		}
 	}
 	return true;
 }
-- 
2.52.0


