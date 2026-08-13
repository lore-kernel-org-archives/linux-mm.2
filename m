Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A71A9C5CFDB
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 09:02:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7254B6B024D; Thu, 13 Aug 2026 05:02:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6FC806B0431; Thu, 13 Aug 2026 05:02:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5ECA96B0432; Thu, 13 Aug 2026 05:02:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2DC196B024D
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 05:02:24 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 88FF1140561
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 09:02:23 +0000 (UTC)
X-FDA: 85095654966.11.29A5550
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 983CFC0002
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 09:02:21 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Cq9h/biY";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786611741;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=itFc+ei9wQ2AisPFkcdPDGQXQgvzV1zw/qg30HEZpkg=;
	b=lB3bpNVaP4gEjk39uGCsQsr4tzZb5UnVd45VVOyi9AJmAYpfIllKI+IpfYFzzK0an5wTnH
	VhEj3lSAadmq9prowQZAlBWDwDADFuMpgEsA+bL4oozuxYS3aa4DHEcbJDKTKcpKd1rqIT
	WwkWgrIMxgFC4YsPbl9Qrile6tBOEf0=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Cq9h/biY";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786611741;
	b=PgMQr25ABC9ZLbQXDgRwP9BYY/38HCISz4rTjBaXp6HhFMUp+DvLH5An1qDS0m8wYYnZsZ
	xbELW4ipVSRxBh9zyTIIDDHTbwywYRcC6f7e+nbH1FZDhOeHPZdF+IHujjBRuWjPSVzGUh
	NvIYHgqk9MS75L2UeBZCR5UwIYZl6ZU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E25B443BA9;
	Thu, 13 Aug 2026 09:02:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B3E31F00A3A;
	Thu, 13 Aug 2026 09:02:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786611740;
	bh=itFc+ei9wQ2AisPFkcdPDGQXQgvzV1zw/qg30HEZpkg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Cq9h/biYez7ZDggx1XDAyzOQtOqE3YYHzs46iGAd2rMJH+kJ6f4CsQzyDIQEKlHLL
	 qqxDLE7ZdCbpGYdokBQR6rehGnNDLU/HD1bmmhBJ17QiPWej9urwhBlftexAsFFhNP
	 PxXyIg49vQ57AlcYJtxGOs8kCJt53ADPmY/AJJpdxs3R2tElKhI2feDZARQdhtIplK
	 AYOxBo7dxrdwdhdm8Ro90htp3Ie1zkYOjil7DSKlZ4RVfOKZOPNFIQPSft63kM5oMz
	 7kpA6swRbGH4Z7d8HV8uBp67PYWfhkhbp5LPncNJO09xCKi6mIJNbMm6VDrVcuHja6
	 QWXfeu4J7BtBg==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Thu, 13 Aug 2026 12:01:28 +0300
Subject: [PATCH v2 5/5] x86/mm/pat: fix effective RW computation in
 lookup_address_in_pgd_attr()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260813-cpa-fixes-v2-5-39b4ff90f91d@kernel.org>
References: <20260813-cpa-fixes-v2-0-39b4ff90f91d@kernel.org>
In-Reply-To: <20260813-cpa-fixes-v2-0-39b4ff90f91d@kernel.org>
To: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@alien8.de>, 
 David CARLIER <devnexen@gmail.com>, David Hildenbrand <david@kernel.org>, 
 Ingo Molnar <mingo@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
 Jiri Slaby <jirislaby@kernel.org>, Juergen Gross <jgross@suse.com>, 
 Kevin Tian <kevin.tian@intel.com>, Kiryl Shutsemau <kas@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Lu Baolu <baolu.lu@linux.intel.com>, Mike Rapoport <rppt@kernel.org>, 
 Nikunj A Dadhania <nikunj@amd.com>, Pedro Falcato <pfalcato@suse.de>, 
 "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, 
 Shakeel Butt <shakeel.butt@linux.dev>, 
 Steffen Dirkwinkel <lists@steffen.cc>, 
 Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner <tglx@kernel.org>, 
 Toshi Kani <toshi.kani@hpe.com>, Vishal Moola <vishal.moola@gmail.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Will Deacon <will@kernel.org>, 
 iommu@lists.linux.dev, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 stable@vger.kernel.org, syzbot@syzkaller.appspotmail.com, x86@kernel.org
X-Mailer: b4 0.17-dev
X-Rspam-User: 
X-Stat-Signature: kp7fsehmynb6e397spjsmrnpw7c59s88
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 983CFC0002
X-HE-Tag: 1786611741-42687
X-HE-Meta: U2FsdGVkX1/Sc7VzMHdD5qh4kE6SpBWXIDp9F0Qt4+Fet1ZvyMEGT8t/T3e/lm5yCc7ZI37ORab2MUvZTLAJolfruP6A6Fb2yCWnso7eqKbsSe4II4Ypv4xLlkwqavt7RGElzOK1xgLleBwlmNTOzsZDBlEYjUhqGm43J91wg85MdKDW7ILov2G8odKi4dkFlBIeLfDbEkbuiS8oaNGYyV1SC0WkqrMsmFyvneEDhdC2EPtctEbnCtAWGmZ+b/0Rm/xZf7jO2M8rgw1Px+q7/aI6EB90on/O87jAaV+CYfT+yzvgAW3Ykh7kD4kwgzw4rSLjcGUiBT3SNRrUyLvF5wKR4V1ry+a8YBB/Ilb2iamaBD7Rm2TVE/skCPX436XQAPPVrqPKWa9f9hdkAqD9Vzkk/teecpd6d05lOaTjachk4GFMyZYSw/mb/hL0SMn4S4k6tZIWQ+DWrgY9HTe1o4b3FpxM8N4vBQWCgd3efWIpbdiefvuvokWn4DNWyQVDhuAvdCQAzlAh4R+myGc4e8l70Ie7X4wvKgcrLxrdWEEjf1RVwXmpqkPOjZXc513a/1AooTj8P5polrGl2nRHW80P5EChvfwgBE+n8wlSpIMGR1VX+mLLXr711s7/3Y8llcwF1Tf1MHbtkPf67rHxt3ls6ZNXUPZG0BRdkkJeHkUN7MqHAdSr89rEhyblYmWQt1m1/2Qv61JJzMY9Sa/M3a0rj1V3dgR9aAbDpwec9WDApq2n4RxXWt9wHFJr2GhSOez4m80fY/S/7efpabk3Mig9yB4uIiMaHqwETDbygItfC5+SQnmlTNx66dDCd9Gx1+2sZXztBkQqZwLUVk8LG40SlO3x/SwADeLWfaMeOFwQdVijm7dBjfqADTyz4qnPuFTkJihNfZ+fyLjF2lN1P+w3xbzPp9O/mciwykXk1skxqWjEQqpdhOiYNveS5zrhlx60KNGpt+ZKFXW3zaV
 pRp+q9wt
 2+K7AkgXqdfLKW1xfjlo4TMIA7ytfCDW9icmyGPQnu6kjNOI68l46eUELZPzVYK1D7OtOe/IW2bFn2qk7+VRE4LU9qiZOZwQhJYNc+7NXbgGfUlB9W+JqkYz05tm1F+Je5qtcUb+FE7C6tvAf4UTyrWUNyiw6Y9Y7NVOvJbRSgGgI4yxL4QApsV1nM1KUd3nKc5M3XBKw745VmIwScPd7vZdtzlVZ38iMLTRLlLBmWyykZfFMoMMnOLT5NFop6ZFgPkfgFRJTrnCqBmmWdzp70WJlmJGl10bY0EGOHfaqucyGCD1F3KQr8fIKgd7OG9h6qPo5umcLfDCx1nOeGhiVRlyzK+oPTcHuK7glThko96zmLvs1ALvktOjCF4B1bxL+TjNM/zsWN3RyRrsMkYoVYDLPoGVlML7+2Gk8Xmy9ysl+fFjhh+WaFzwDYZHxleArhcm4rZXQ9+mmvz0UfbFpYX7YoqiHGgfVSAMA8PcafjWaTuY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

lookup_address_in_pgd_attr() accumulates the effective NX and RW bits of
the walked page table levels so that verify_rwx() can detect mappings that
are both writable and executable.

The RW bits are folded into a bool with

	rw &= pXd_flags(*pXd) & _PAGE_RW;

but _PAGE_RW is 0x2. So consider the accumulation line:

        rw &= pXd_flags(*pXd) & _PAGE_RW;

where rw=0x1 and the right side evaluates down to 0x2. It'll end up doing:

        rw = 0x1 & 0x2

and rw always ends up 0.

This way rw becomes false at the first level walked, regardless of the
actual permissions, and verify_rwx() treats every mapping as non-writable
and never reports a W^X violation.

Add double negation to the right side to normalize the _PAGE_RW flag to
0 or 1.

Fixes: ceb647b4b529 ("x86/pat: Introduce lookup_address_in_pgd_attr()")
Cc: stable@vger.kernel.org
Assisted-by: Copilot:claude-opus-4.8
Reviewed-by: Juergen Gross <jgross@suse.com>
Tested-by: syzbot@syzkaller.appspotmail.com
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 arch/x86/mm/pat/set_memory.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index fbc418dfc597..430d0b448371 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -754,7 +754,7 @@ pte_t *lookup_address_in_pgd_attr(pgd_t *pgd, unsigned long address,
 
 	*level = PG_LEVEL_512G;
 	*nx |= pgd_flags(*pgd) & _PAGE_NX;
-	*rw &= pgd_flags(*pgd) & _PAGE_RW;
+	*rw &= !!(pgd_flags(*pgd) & _PAGE_RW);
 
 	p4d = p4d_offset(pgd, address);
 	if (p4d_none(*p4d))
@@ -765,7 +765,7 @@ pte_t *lookup_address_in_pgd_attr(pgd_t *pgd, unsigned long address,
 
 	*level = PG_LEVEL_1G;
 	*nx |= p4d_flags(*p4d) & _PAGE_NX;
-	*rw &= p4d_flags(*p4d) & _PAGE_RW;
+	*rw &= !!(p4d_flags(*p4d) & _PAGE_RW);
 
 	pud = pud_offset(p4d, address);
 	if (pud_none(*pud))
@@ -776,7 +776,7 @@ pte_t *lookup_address_in_pgd_attr(pgd_t *pgd, unsigned long address,
 
 	*level = PG_LEVEL_2M;
 	*nx |= pud_flags(*pud) & _PAGE_NX;
-	*rw &= pud_flags(*pud) & _PAGE_RW;
+	*rw &= !!(pud_flags(*pud) & _PAGE_RW);
 
 	pmd = pmd_offset(pud, address);
 	if (pmd_none(*pmd))
@@ -787,7 +787,7 @@ pte_t *lookup_address_in_pgd_attr(pgd_t *pgd, unsigned long address,
 
 	*level = PG_LEVEL_4K;
 	*nx |= pmd_flags(*pmd) & _PAGE_NX;
-	*rw &= pmd_flags(*pmd) & _PAGE_RW;
+	*rw &= !!(pmd_flags(*pmd) & _PAGE_RW);
 
 	return pte_offset_kernel(pmd, address);
 }

-- 
2.53.0


