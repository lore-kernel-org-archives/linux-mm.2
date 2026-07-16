Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1051AC44512
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 14:51:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC82D6B00C8; Thu, 16 Jul 2026 10:51:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D9F2E6B00C9; Thu, 16 Jul 2026 10:51:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDC316B00CA; Thu, 16 Jul 2026 10:51:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A757B6B00C8
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 10:51:36 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 384DFA00B8
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 14:51:36 +0000 (UTC)
X-FDA: 84994928592.29.3795D98
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 9A4E718000C
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 14:51:34 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kpNW5sTJ;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784213494;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8LTuIGe8Io4Hp0JGGsyty7Bh+5p268Vyx6JhVPmlFxs=;
	b=XMWlTKmIuVp7P6/+MPgRBM8lJXVzAzyI46wj1Lspg8QOiMiU4DhkvAd3cxfb4DG+59ezVP
	2gz+T8bdElNOczIv+rWd3MdfWAK1483wIYga4KkTgNCNmFMxfgcvYKkiMtO4t56XUcJuOV
	OROe1PxEoqQu7kVmxjsxNginD3BBZZQ=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kpNW5sTJ;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784213494;
	b=QlcCZrxgD06NvCvF7Wa9DgVzUKBBWpLefapj8h78ZnLupn+NAl8unHGT+6I7UYKWjE6J3/
	atCJNW7jKJsfCHXDKpYP8d5KUG/HGIezYw7iZmxzM+eOPbxpM8P+bCDo2uWPNqkmE4H0vH
	hCyRPOZcBP0zV1bYTGCF79hD0sl0vfg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2D42F60204;
	Thu, 16 Jul 2026 14:51:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 755701F00A3D;
	Thu, 16 Jul 2026 14:51:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784213493;
	bh=8LTuIGe8Io4Hp0JGGsyty7Bh+5p268Vyx6JhVPmlFxs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=kpNW5sTJx/u9c2MEqIOUVccXD5xnbPluojNAHtABf3edyEU1lpAsaRfDV7oPtunry
	 XOyIS0lbUr0g5QE2bRkA/ONFQcJITWJ8R1NpULOTqPYuVcVKR+hWcXVwz9tlUkdVtB
	 LB+FwbK8KGdBd589G5b4s53GA7AZksZD6HeBVpLa/MqktsDfcpKkFEoMKdcFX4jGAS
	 Z7UEdNdsnbqrnmLGsutF+/yLwgo+ig80d/tvurqSewRUJ8SE8eidxQdkpo3qjkm/9A
	 ud/FON5uINp7cQhCKVnw40CozW7MXoPCMlm1YRjEbpCqspTV/3aHYvDX6mdvuYu3LY
	 XroHJr6x/P9Vg==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Thu, 16 Jul 2026 16:51:02 +0200
Subject: [PATCH v2 03/10] s390/mm: use free_reserved_pages() in
 vmem_free_pages()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260716-bootmem_info_part2-v2-3-4afc76c73d61@kernel.org>
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
X-Stat-Signature: d9m5thbnqa4c5nzpt6mbjpsg6edwczkg
X-Rspamd-Queue-Id: 9A4E718000C
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1784213494-653637
X-HE-Meta: U2FsdGVkX1+MMDDe2dLVa8zCsI413dmQ0OP2GGf7wd3aoLl0WFF0u80zSjeVhSI4RAmN8USBOGb6uSNg5oJ/xlHCgml0bkkc0mAGdFPjI5zDuqUbTFXnm/M1kw0cHc+eWag+adyEetUc24A9rlFIRRBzL8lbRiJxy67j1YdVll48OqJ3G13kPVsnOEFDczHSJpS6YIW8b8/F8x6e4wWTJFpriw3/EBR6C6Yw1Rt1NSTSZwKXVMfVQPnkcbgihtdYABO8IzhOtWigYv8opVLLqUDGoiXGcdmYyUW3hL0MSM0NenPE/8o+i1n/4+dtRRTvxFeYwgjJm4OsFU0s9u7FTqMv798uuhiEzYC6511atmniVsSwH+C0uKXGmRfpuXyjywPB7O5u8niObrYCVGjxmRKcVJzL8EkIJm5WTNRj6ba2CGyroymi40X2+YHwT2vCCTiP0+pcsS2KVVj+qjFnx+Rb3Q38lDdLk+1SpBRVmeLGkPk/8vLKBg8STMbbXoKiun/gLlzabZA3rku5MJkCDnRK15PX8I5SFhm9r25AR1evgbVBHH8g9rajMdwUrSVUA0uzmIEMafEsnpkbQ5OskCnpWftTFhTm+Sc9bzAM6/VtLj5qwRsLycNevmz8IibqDCe1DYtUT450av7/4EEy0ZdYr7A+UxHgqHbXlppQbcMHPe0UAKvE+IG6wRziXohvhbx9oNYu56ZMvc4tquyatwIC1NMZXCWtrd11A4B5FxsVqR6e/qS3V3oUCU7yTsPMl59FtO1J77FCPPYm45ruUOLPzgKhVRk4uNYzzHlJ5L940ANUzNOLntDhcfQGSYeajSOnBFqjg9Inj/1I/R0fWQurnALlrn3K+/Ztm0XoxHQMzZDmm1XKfG02pzNYbK1mn/MjKweFf073BxdjVV6PN8mgUQJv8KqLOaMrECMn6rdzI/DKHKAvEHf7+EcP6dq2eE1QJiX51+gDh33DlRZ
 9aOZNXN2
 pncR9lRKcaGz6jiYmBfMzm9RjCO8zSvugQvNY1iebCaX1A/174A9AzdUj51rlb3Vw/0bDUrHmJn0ZeZmOFhHTdasSsg3OlsFUufBFDle0aXTzx2vEaTTG0Nan7PUtbktKbxOxgBxv/xyEF+40qLa4skCa4/uyXX7jXa2Nwva2J5VmxeSV+e1tlYoUaIXFWwmycmA8z4FjJ4Kn6roXxYe4LaxtLnYNOBXTCxGETqEW+qq5W6F8j/4zYfEVNyd0fqe4F3fQlx0Joi5Dj67jBcKLhcHcKWB1gMRChQ/Qzi7GOFQ77D32GmK4lEPojRryXQuo7Wdm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Let's use our new generic helper.

Acked-by: Heiko Carstens <hca@linux.ibm.com>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 arch/s390/mm/vmem.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/s390/mm/vmem.c b/arch/s390/mm/vmem.c
index 94ee06ae89134..d2879ce860a13 100644
--- a/arch/s390/mm/vmem.c
+++ b/arch/s390/mm/vmem.c
@@ -39,7 +39,6 @@ static void __ref *vmem_alloc_pages(unsigned int order)
 
 static void vmem_free_pages(unsigned long addr, int order, struct vmem_altmap *altmap)
 {
-	unsigned int nr_pages = 1 << order;
 	struct page *page;
 
 	if (altmap) {
@@ -49,8 +48,7 @@ static void vmem_free_pages(unsigned long addr, int order, struct vmem_altmap *a
 	page = virt_to_page((void *)addr);
 	if (PageReserved(page)) {
 		/* allocated from memblock */
-		while (nr_pages--)
-			free_reserved_page(page++);
+		free_reserved_pages(page, order);
 	} else {
 		free_pages(addr, order);
 	}

-- 
2.43.0


