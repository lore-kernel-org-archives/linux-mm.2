Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51090C61DCB
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 13:59:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 634186B0095; Fri, 28 Aug 2026 09:59:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E4816B0096; Fri, 28 Aug 2026 09:59:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5215C6B0098; Fri, 28 Aug 2026 09:59:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2A32B6B0095
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 09:59:03 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id ACA4F1603A7
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 13:58:27 +0000 (UTC)
X-FDA: 85150833054.16.32896CB
Received: from 7.mo584.mail-out.ovh.net (7.mo584.mail-out.ovh.net [178.33.253.54])
	by imf03.hostedemail.com (Postfix) with ESMTP id 5AF3920003
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 13:58:25 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=quelquesmots.fr header.s=ovhmo4049951-selector1 header.b=RLCaeniO;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of l.wandrebeck@quelquesmots.fr designates 178.33.253.54 as permitted sender) smtp.mailfrom=l.wandrebeck@quelquesmots.fr
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787925506;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=764ev2N3KwIgGapMuVWioNnBS/1ILv2C77z2qZJCBdE=;
	b=XhIGSBDcwKGjdgeLQVhSG9+uYXSy0QvXCOoVioZKc+z7Gohb5tpK3iyydUqrK0Xqv04wkG
	+UTxemXErS0dQBeI2l2UC+NWVBwQwiQbkcSXppfBv7jjS5oyI5I53+8ZiGCAwLfXry+xMs
	X4ElDUOSdZnYeaz1nxNH3192XeJ0RW0=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=quelquesmots.fr header.s=ovhmo4049951-selector1 header.b=RLCaeniO;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of l.wandrebeck@quelquesmots.fr designates 178.33.253.54 as permitted sender) smtp.mailfrom=l.wandrebeck@quelquesmots.fr
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787925506;
	b=BNzLm+AccKcMGD7hW6lXVNxXdKTxcWvqqNjxh/q+CYoVNAAQskQ/7jzNM8cxQBe4B9DOwx
	3QLC6d/I2rqbQKYBHaBsACdqgJoTxt2iMDoewNGWkm32izACDkSjAFVCjzXWJS81DCPoPa
	U/B9eBk+GrGDYj2bvOUK8Hds1lQdirM=
Received: from director4.ghost.mail-out.ovh.net (unknown [10.110.54.155])
	by mo584.mail-out.ovh.net (Postfix) with ESMTP id 4hWg2l4Gh1z8Whc
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 13:58:23 +0000 (UTC)
Received: from ghost-submission-c7b579475-6dj84 (unknown [10.111.174.132])
	by director4.ghost.mail-out.ovh.net (Postfix) with ESMTPS id D17FCC2A79;
	Fri, 28 Aug 2026 13:58:21 +0000 (UTC)
Received: from quelquesmots.fr ([37.59.142.109])
	by ghost-submission-c7b579475-6dj84 with ESMTPSA
	id Q4JXJP2TkWrQ9hYAscvRaw
	(envelope-from <l.wandrebeck@quelquesmots.fr>); Fri, 28 Aug 2026 13:58:21 +0000
X-OVh-ClientIp:109.190.254.62
From: Laurent Wandrebeck <l.wandrebeck@quelquesmots.fr>
To: Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH] x86/mm: don't apply va_align to hugetlb mappings on AMD F15h
Date: Fri, 28 Aug 2026 15:57:47 +0200
Message-Id: <20260828135747.724789-1-l.wandrebeck@quelquesmots.fr>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
x-ovh-tracer-id: 10664242445692042523
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: dmFkZTEkLbPYNbrxSHojy+RWJ8f4V182xAxBMjKkkHL9k0wwpb33zjs6+hqGEBBil6YU4oF5EiuB3yR1lArnsvLdr7t2c1Undp+KBabI/CsDy0O1uFYgfQI+DcvaALXXKVevP+MwP71PkXEeVfjKK/N35zEm6lTBWreGsF0kVsntRcV4dBcxRBJo2ohvQVSIbl3SXTr9mrgq/BQ/qmCepoMIe+ga9lqDhAdqSXpFkPiNx2ZTGQJwKOutfjqkABscfzXiAvfIRKikKW9QTQ/KQjtZO5UICr1q39vU2695843rnLoi+QjrM9Tj7E4s8zhAXcnz797JXDmjwRk14H4KfZ4rOGzsJK0svnpmxfKsFR6o98mcdwWWZDnM7UHzGOoDz0JEHpynatb53nQboP4eYcZDqFkAQZoL6uyOOmTQt2yiAWMlO0vYwR6syKy3dPTYSL5liQ7jfdEuU5xaXBN8JnlPPP7vcvyNT9YJpGNj8Ux2/Y4rJnBWtd9v3cmW0qThZVfTsKNk3cc9FpGZBll0wja3YN/sAqkP/T6unhr5C3RNs41LY0OjXvxkJ/ex025e7XXefVB6LIo7kNLNgh87Br1yFXRWHg/2yV5xcZN9SbLDUbPED1M4PWlvjIT55PnavVcGVIWXbXKxt1Yu3eS23QuUnmTrGSjoF+FV+DVStV0jqwe6lw
DKIM-Signature: a=rsa-sha256; bh=764ev2N3KwIgGapMuVWioNnBS/1ILv2C77z2qZJCBdE=;
 c=relaxed/relaxed; d=quelquesmots.fr; h=From; s=ovhmo4049951-selector1;
 t=1787925503; v=1;
 b=RLCaeniOviPMBqhBZH3W5fa3Uo77l7WOsSx4uxRQsc5IzTxoYrbrxZwG1zlOi78OClQ81+yi
 BQ87VEWsrJTF/2xpDxCKYEcTF2lULWUufMBazeZB7GPq5TiWq6kp5CCwIYKYOCU07QC4K1x3vHV
 Yk2krafDhigmY+m+bP+qFjDo4UbpFpbAoD2zmJU8EC4gI+xG/dDGVbsEMxC1tOgRgrwkVKk19Ug
 Mp2vJdIIyHkndFM3oPsd1OLPX8DGZmaogOoeO6hsAdQ8PKxjRh3ms7S1afXoaSpD8C9IHHmoDQn
 tWWhUvnU5puuCbrCZ/JSo6IVC0FOTg+EV1FPGCHLpTmmw==
X-Stat-Signature: iayb8zhbcu59hrid74cizbopo7s1an1m
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 5AF3920003
X-Rspam-User: 
X-HE-Tag: 1787925505-456822
X-HE-Meta: U2FsdGVkX1+GpDfvOgRtQeBMddfhtFDynGvT+jirxbVgrHldxfVBquNq1n9a87R2Vp2geBW0ORhN80+i6VQRHiYSsi1rIDwBNxQq2xJ/1XSJwHVP6NL06QLbFDpKeWBKyjwWIY8Vx2VJbUMsN8bnvCVKF73MNS9xKACYaOBdwXPjiKADx5YLpzL+P2r7968i6TfjuVvNXXwHkb/sNQalXLPf+sbZvV1UYecW8EIWfhutf7nAtHdSErf64XLNULs5zzxZdLHWHapkZJr78kz6s9o/kt3wCscdXN5ybU/jqkVvxMVTZw36oENCyOzCGwAq5lNa8rk38MblQzO4v5tftcKNuCf0QcC4SEGiZsY8KIuZJ3T0H8eVHbDpBTWkKbyRXw6tUQNi0hLP/+euBm29oZuAQ3Ew37MZ9F1gcWRFlF83csxnmAsgY3iwUmwk+pzOLEnBf20qZ8jq2+TmJWzvlWTjT5gohAuSp79mcKvU6qzfGOjE8o4rAMy4oHehs19AAuIfaD9tgKh+TmBTTSDjp8mdvF1SHO1SSnsaYILMT++xWx0WQpCW9Caex9r/cwtyy7BEpHB79LqbDyaWFC0eiXorCXVyXTn7ZX6Y8ibO92yvla5a5r24ZSKSdNbPo+m+X5dLhYNicAx+vP62mERyiBeeXXUBX8CrzIy2q6b1R2Bmuxi4TrwnLGc16kyar0a9EkuxGUJdVcX2kX9U539SFQhFwT+iFSjFOL56v733HKcgZl54KmvzXz2jdc6tbcb3g31QNFKSh30Y6O5sBRyLvleEgTTpeqZV+3/Yq//7Soi7dr0Gs+RhJz81IdpqnkSBxtrkLiiYVH/Mw+eXvcmgVAZImKnuzjLK38MeJWOE6mvXwyk/CUpLj0dgbF0yDMOasdAPQNnic7Kc5ClU6dRHTZ9Co2jVUti0qMlvye8O1JxAtq5v0FaijXudTn1m3AMeaCrpfJrYcKctBFJMUuO
 uAOXPRb4
 XTZ7uOQ17OHJpuHBpw91rgcpVM+JtQ9mXlbTF/naUvKzeLY1gOLlpH0pwaAlrXctUwxXfGmhG3XEXpvaidN3++qIOEnesWBVs5O/OVY4Iokq4PzadCNpN5AB+6dJ1oIPdRhVFCSRNdOXnxFa3o1vsA+ttiWWgt5m5e44yxEfK5+GJjzCyj0Re1Y4S09T3n/sq11zMLDjpd2O+Bc+1EvnlOrXmu9bv71uj2oRcrGVJIXFBrttczroYQbv1H0cUY5qCozZ9/IXFr1raV3R7Qto94rCznVOqZY3CfOBM2oDVejbegSDdzOLybh2hiYSqGecxMtZrFnUAsaUe+P89jVu6tCm/ZrD2y1j4VQDFEIyxb8gqDW2Dx3wXsGaF7gpcA0Umy1L39c+b2IoIPOc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 1317a5e7f7b1 ("arch/x86: teach arch_get_unmapped_area_vmflags to
handle hugetlb mappings") taught get_align_mask() to return
huge_page_mask_align() for a hugetlbfs file, and skipped the pgoff-derived
align_offset for one. It missed the other write to align_offset:

	if (filp) {
		info.align_mask = get_align_mask(filp);
		info.align_offset += get_align_bits();
	}

get_align_bits() calls get_align_mask(NULL), so a hugetlbfs file still gets
the F15h I$ anti-aliasing randomization that its own align_mask already
excludes it from. vm_unmapped_area() therefore returns an address
deliberately offset from the huge page boundary, the hugetlb VMA's vm_start
is only PAGE_SIZE aligned, and tearing it down trips
BUG_ON(start & ~huge_page_mask(h)) in __unmap_hugepage_range():

  kernel BUG at mm/hugetlb.c:5161!
  RIP: 0010:__unmap_hugepage_range+0x64f/0x660
  RAX: 000000003fffffff  RDX: 00007e9280003000
  Call Trace:
   __zap_vma_range+0x523/0x680
   unmap_vmas+0xa5/0x1a0
   exit_mmap+0x13b/0x3f0
   do_exit+0x1e4/0x470

That is a 1 GiB mapping on an A10-8770E (family 0x15, model 0x65) running
7.2.0, 0x3000 below a 1 GiB boundary, RAX being ~huge_page_mask(h). Both
hstates crash, and so do both on an FX-8370E (family 0x15, model 0x02)
running 7.1.8, there 0x5000 low. The offset is va_align.bits, drawn once
per boot: identical across hstates within a boot, different between boots
and machines, and a boot that draws zero does not reproduce at any size -
hence the apparent intermittency. The crash is in the teardown path, so the
reservation leaks as well, HugePages_Rsvd owned by nobody until reboot.

Reproduced by mmap()ing MAP_HUGETLB and returning. A Ryzen 5 2500U (family
0x17) on the same 7.2.0 does not reproduce it, as expected since va_align
is only set up for family 0x15. With the patch both hstates return aligned
addresses, and PostgreSQL has mapped a 4 GB hugetlbfs segment for 18.8 h on
2 MiB and 4+ h on 1 GiB pages with no BUG and no leaked reservations.

Fixes: 1317a5e7f7b1 ("arch/x86: teach arch_get_unmapped_area_vmflags to handle hugetlb mappings")
Cc: stable@vger.kernel.org # 6.13+
Signed-off-by: Laurent Wandrebeck <l.wandrebeck@quelquesmots.fr>
---
 arch/x86/kernel/sys_x86_64.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/sys_x86_64.c b/arch/x86/kernel/sys_x86_64.c
index 776ae6fa7f2d..6b2be065304f 100644
--- a/arch/x86/kernel/sys_x86_64.c
+++ b/arch/x86/kernel/sys_x86_64.c
@@ -157,7 +157,8 @@ arch_get_unmapped_area(struct file *filp, unsigned long addr, unsigned long len,
 	}
 	if (filp) {
 		info.align_mask = get_align_mask(filp);
-		info.align_offset += get_align_bits();
+		if (!is_file_hugepages(filp))
+			info.align_offset += get_align_bits();
 	}
 
 	return vm_unmapped_area(&info);
@@ -222,7 +223,8 @@ arch_get_unmapped_area_topdown(struct file *filp, unsigned long addr0,
 
 	if (filp) {
 		info.align_mask = get_align_mask(filp);
-		info.align_offset += get_align_bits();
+		if (!is_file_hugepages(filp))
+			info.align_offset += get_align_bits();
 	}
 	addr = vm_unmapped_area(&info);
 	if (!(addr & ~PAGE_MASK))
-- 
2.34.1


