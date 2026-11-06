Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43BD3606A326
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 22:11:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=XEi/Q71c
Received: by kanga.kvack.org (Postfix)
	id 4EBAE6B05C3; Fri,  6 Nov 2026 17:11:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 49C306B05C4; Fri,  6 Nov 2026 17:11:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38B096B05C5; Fri,  6 Nov 2026 17:11:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0C0236B05C3
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 17:11:07 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8149D140244
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 22:11:06 +0000 (UTC)
X-FDA: 85406090532.01.0878D2F
Received: from pdx-out-011.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-011.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.35.192.45])
	by imf08.hostedemail.com (Postfix) with ESMTP id 3B159160007
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 22:11:04 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b="XEi/Q71c";
	spf=pass (imf08.hostedemail.com: domain of "prvs=76345edb3=mkbund@amazon.com" designates 52.35.192.45 as permitted sender) smtp.mailfrom="prvs=76345edb3=mkbund@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794003064;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i/8JK3JrN27uzstCo+Qhchqx9jcouYFurbAZXT4QANY=;
	b=LnFsi3xd/+MThw1wAQsxW+yZX+3jPDDN07FWkNKtXKbtgHdlHWMMStmsdQtks0dibr80g7
	2AhCXtvfLmbJ07wBMHc8h+Ka4Onn5jBWEPsqfB1z9/BdUT5BbtWActUINqCJr7lKDG9ib+
	jhDi0LQC7LlnehmevMt1dv+ZefNyw5A=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794003064;
	b=XW/RFSz9yf/6QGKoyPPuyrEaGPV/cb61AyItcAtF+g8vlYhqB7LUo6A+lUzo0lqE7FDEzy
	VdE0TLp7Toyr6/5gc5eHNJEGCZF+8nswzCyr47TiEvKg5TGK9aE+Gr23gNN45V+G7BqFXw
	8J6fu7keKHl4T+125Eq8P1nb1EG/fA4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b="XEi/Q71c";
	spf=pass (imf08.hostedemail.com: domain of "prvs=76345edb3=mkbund@amazon.com" designates 52.35.192.45 as permitted sender) smtp.mailfrom="prvs=76345edb3=mkbund@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1794003064; x=1825539064;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=i/8JK3JrN27uzstCo+Qhchqx9jcouYFurbAZXT4QANY=;
  b=XEi/Q71cOBvn08YDLhU7YBEG3zB52VShx/508fG57ZG+qWFuXexCDuwF
   hN360+xSgtUFMbFEht/4q+48usmpSuHaqRGwm4FX6D4gDDmwRcko64uUu
   Q/1tD5jjcufFsXdyKpdOzGpwEdZqrnDXUmZLKa5de23gB2sw75cqAAm4M
   +VuswRACDaRozkVCGRXHCYjdC4Q8Eu4vj9F8BIVY/t63YlY8eXwqPaP5C
   BsXLZWytai9DGg56E7RQV/KeIjYiu7OEmvnQF5qdU7LwOvbiVCYvGdgYO
   BlJUJtATyC4yR96Kecr0dmY8OvlQur53y5CFCpJ9Ui3gwCk6bUtH6RT6s
   w==;
X-CSE-ConnectionGUID: mnZUkBD4TLWuvBi361TQ/w==
X-CSE-MsgGUID: EOUzmkeeR9umoO/d7mJwtA==
X-IronPort-AV: E=Sophos;i="6.27,199,1787011200"; 
   d="scan'208";a="33124170"
Received: from ip-10-5-6-203.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.6.203])
  by internal-pdx-out-011.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2026 22:11:03 +0000
Received: from EX19MTAUWC001.ant.amazon.com [205.251.233.53:5283]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.22.238:2525] with esmtp (Farcaster)
 id fcb6e138-ec14-4baa-9613-b2f9413de354; Fri, 6 Nov 2026 22:11:02 +0000 (UTC)
X-Farcaster-Flow-ID: fcb6e138-ec14-4baa-9613-b2f9413de354
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Fri, 6 Nov 2026 22:11:02 +0000
Received: from dev-dsk-mkbund-2b-9ea2efba.us-west-2.amazon.com (10.2.100.138)
 by EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Fri, 6 Nov 2026 22:11:02 +0000
From: Mark Bundschuh <mkbund@amazon.com>
To: <stable@vger.kernel.org>
CC: <sashal@kernel.org>, <linux-mm@kvack.org>, <david@kernel.org>, Ge Yang
	<yangge1116@126.com>, Muchun Song <muchun.song@linux.dev>, Oscar Salvador
	<osalvador@suse.de>, Baolin Wang <baolin.wang@linux.alibaba.com>, Barry Song
	<21cnbao@gmail.com>, David Hildenbrand <david@redhat.com>, Andrew Morton
	<akpm@linux-foundation.org>, Mark Bundschuh <mkbund@amazon.com>
Subject: [PATCH v2 6.12 2/2] mm/hugetlb: fix kernel NULL pointer dereference when replacing free hugetlb folios
Date: Fri, 6 Nov 2026 22:10:51 +0000
Message-ID: <20261106221051.2886829-1-mkbund@amazon.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20261106220835.2878368-1-mkbund@amazon.com>
References: <20261106220835.2878368-1-mkbund@amazon.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D031UWA004.ant.amazon.com (10.13.139.19) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 3B159160007
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: u6o81i8qzbqpkwt9eky8u45je3phgz3k
X-Rspam-User: 
X-HE-Tag: 1794003064-305915
X-HE-Meta: U2FsdGVkX18QBWNu0JiqCdMbXZc5bA5T+sF4LUT/dxYMQSaEqlXCtZIPBvFWwZ77pY0KeFNjMosMddPWE2MbS1N8KdYBGzNYz+xE5TS9V3hFtlhl4v+l1Vx8pW+Hfzab3f7+WbO90UKHrN6Y6xdBm0b+Ex+MxtZUuikZ8eKcpy/D4UQGWUhxxqNnkH93TRrp6PR6O5byoFv9iVzHBXAoUw8gf16BDqTKz02WdR4FLJMkI8RvWTHzA9XZfrx7mcIBNyLyLgofCW8mbBVGqC51tTwGfa8iMQ9iyrAuz68Xsoikv/sRtD0Wp2sW/tL2z7uYGEuyJtgz6m//BFwXIcwmUAy8VBznwhX+UgBlVZj0VYKncuWdrRKH7jQkImQazjI+fy/cO8bt8y2OgTi4MYWDzO9mUH46ycDTgIc+k1tdQfPULfnEcx7K0/CEo4P/HpMKwkzKIWsVWKb6VdIe6BGoQk1Kiwrmb7N/a8kERqR4z8BgYR/vdCfSs9G4xhyWFsDpjwZMwZqJ+ghvbzYrtIHl9B74LApbsBIYIrc+nmBBhlHwqe8NwkfspSIiekIK39L6FtQAePy5JOa5Nv3fC3+jb6CYtfRJZE0rzSJPz/amPGjF5ycnx4Yu5QdAuGtCQ66hN39F7hIspNvNfZXj63vQovffnSg96oDbG4to0wxEF2nqfIJCg72ZG2MYClYdFO1Bo8sM0T7vl2nxiPPSuKb06bhKvotdRMfeqiqsi+yB4j/j2Yhfh9xdZKWJtSPPqFfW8FcVGt01Ln4/l/rqJUuhZx0+q5P6jC4nxiA7evvPsF/lzNcOmLvX/deJJfbWUkNarUW5/KS+w+2BH0ED9+RScO/zCYllP1k4WVIztzWC+DH0jdhzeg1hWkKg1GQMRL38HOedOliKYxZxB2w6Cgi/X/MJfYvyIjz7n0+Gi84oYf0YIofciPO3MTbd1OVgEX4ccer658UBI5zLYxyQYZR
 JbygS0dn
 IlA3578hEtK+BwAVGGu27gj44ICkwj19VhIRMJPoTFB4cdVLS7cq3LTdHIosaXpyMd5qPBMRiqxJ3XVPU+0oKjWJPh7KnqDSbVv7/bedWBvQ2VFQ7PlebrYjhZHeCW4WAgN+Lim9c2ZQ+vPEItTzJfF9PUnLBRBZqiJFWaTBZFDxHqnde0ZHnBvDleI44aqRkqHoohVL1fdopog8bP9W/osOJVUhPN9RKP+b41OwR9nDGY9DGH3pux8Xv6xaBCNuuHjraAk0GDRuzQCetTfQims8E6zOJ7nhhkegzzTYWtx+9irN6eXU7tVLovLkw5kDUONA+evgpotEf/dH2tLvMXjlulgg0QW8XF5MKCjZsomhvBU+Srt96AyrJ8uBU0FtvhRKxi6HNB+MCAX1tJ5/di+/LJjZ2aMIQ85weRXUUMJh01iiJNH97PTabMpErpMnQ7hbjQH7sRZcWNspLXCSjVXuZpQLLKH/CuKzVSWG0vUKn7tDcX1Xd9JpT2Jf+ONT8DPzIiGAkDDqCvd0ZQieDASoafe50kxcNOJ4/JEZdnhb+Jpn5JYIdNhABbB4Xrfn4XyDc56MCUtl1sNpuRdNgDVxFAbTVkh0tr1FZX/FgwSRHrsH0GCRvFObGJABKluTMzttG8PXu7X2B9/cYaOeKUYR7LRiGpE/J76rMJv/nIRvFpt8Nb6v7QOGeEwmDwMcaB7rQaKFquJvRHuTTwrwcoF9zni2sa7VVgEXGK/JRLNdi8+aKLsm2LoV2Tu3gUQX+k9rHo8GK0k366EogqVvnyvtoGEwwCW65ZdV+RC6AIHCzsFM9hxUNmekRxkY6xwIe9kJ4z3hYZnqKqFN3gA0FvQTtPte3vn/PHFpcwn5HJOSD8WQli34WYX20NfJsDo43SlvQxfee/bhwIQpD1ZskPnI5tpyTC5Rf06wr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ge Yang <yangge1116@126.com>

[ Upstream commit 113ed54ad276c352ee5ce109bdcf0df118a43bda ]

A kernel crash was observed when replacing free hugetlb folios:

BUG: kernel NULL pointer dereference, address: 0000000000000028
PGD 0 P4D 0
Oops: Oops: 0000 [#1] SMP NOPTI
CPU: 28 UID: 0 PID: 29639 Comm: test_cma.sh Tainted 6.15.0-rc6-zp #41 PREEMPT(voluntary)
RIP: 0010:alloc_and_dissolve_hugetlb_folio+0x1d/0x1f0
RSP: 0018:ffffc9000b30fa90 EFLAGS: 00010286
RAX: 0000000000000000 RBX: 0000000000342cca RCX: ffffea0043000000
RDX: ffffc9000b30fb08 RSI: ffffea0043000000 RDI: 0000000000000000
RBP: ffffc9000b30fb20 R08: 0000000000001000 R09: 0000000000000000
R10: ffff88886f92eb00 R11: 0000000000000000 R12: ffffea0043000000
R13: 0000000000000000 R14: 00000000010c0200 R15: 0000000000000004
FS:  00007fcda5f14740(0000) GS:ffff8888ec1d8000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000028 CR3: 0000000391402000 CR4: 0000000000350ef0
Call Trace:
<TASK>
 replace_free_hugepage_folios+0xb6/0x100
 alloc_contig_range_noprof+0x18a/0x590
 ? srso_return_thunk+0x5/0x5f
 ? down_read+0x12/0xa0
 ? srso_return_thunk+0x5/0x5f
 cma_range_alloc.constprop.0+0x131/0x290
 __cma_alloc+0xcf/0x2c0
 cma_alloc_write+0x43/0xb0
 simple_attr_write_xsigned.constprop.0.isra.0+0xb2/0x110
 debugfs_attr_write+0x46/0x70
 full_proxy_write+0x62/0xa0
 vfs_write+0xf8/0x420
 ? srso_return_thunk+0x5/0x5f
 ? filp_flush+0x86/0xa0
 ? srso_return_thunk+0x5/0x5f
 ? filp_close+0x1f/0x30
 ? srso_return_thunk+0x5/0x5f
 ? do_dup2+0xaf/0x160
 ? srso_return_thunk+0x5/0x5f
 ksys_write+0x65/0xe0
 do_syscall_64+0x64/0x170
 entry_SYSCALL_64_after_hwframe+0x76/0x7e

There is a potential race between __update_and_free_hugetlb_folio() and
replace_free_hugepage_folios():

CPU1                              CPU2
__update_and_free_hugetlb_folio   replace_free_hugepage_folios
                                    folio_test_hugetlb(folio)
                                    -- It's still hugetlb folio.

  __folio_clear_hugetlb(folio)
  hugetlb_free_folio(folio)
                                    h = folio_hstate(folio)
                                    -- Here, h is NULL pointer

When the above race condition occurs, folio_hstate(folio) returns NULL,
and subsequent access to this NULL pointer will cause the system to crash.
To resolve this issue, execute folio_hstate(folio) under the protection
of the hugetlb_lock lock, ensuring that folio_hstate(folio) does not
return NULL.

Link: https://lkml.kernel.org/r/1747884137-26685-1-git-send-email-yangge1116@126.com
Fixes: 04f13d241b8b ("mm: replace free hugepage folios after migration")
Signed-off-by: Ge Yang <yangge1116@126.com>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <21cnbao@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Mark Bundschuh <mkbund@amazon.com>
---
 mm/hugetlb.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index a3d3fb1de3ec..43a96477904a 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3012,12 +3012,20 @@ int replace_free_hugepage_folios(unsigned long start_pfn, unsigned long end_pfn)
 
 	while (start_pfn < end_pfn) {
 		folio = pfn_folio(start_pfn);
+
+		/*
+		 * The folio might have been dissolved from under our feet, so make sure
+		 * to carefully check the state under the lock.
+		 */
+		spin_lock_irq(&hugetlb_lock);
 		if (folio_test_hugetlb(folio)) {
 			h = folio_hstate(folio);
 		} else {
+			spin_unlock_irq(&hugetlb_lock);
 			start_pfn++;
 			continue;
 		}
+		spin_unlock_irq(&hugetlb_lock);
 
 		if (!folio_ref_count(folio)) {
 			ret = alloc_and_dissolve_hugetlb_folio(h, folio,
-- 
2.50.1


