Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9878606A32C
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 22:07:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=sZbbWvj2
Received: by kanga.kvack.org (Postfix)
	id 2E9326B05B7; Fri,  6 Nov 2026 17:07:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C0BD6B05B8; Fri,  6 Nov 2026 17:07:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 179F66B05B9; Fri,  6 Nov 2026 17:07:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CF46C6B05B7
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 17:07:32 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 53297C021C
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 22:07:32 +0000 (UTC)
X-FDA: 85406081544.16.48E0E25
Received: from pdx-out-013.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-013.esa.us-west-2.outbound.mail-perimeter.amazon.com [34.218.115.239])
	by imf19.hostedemail.com (Postfix) with ESMTP id 1649F1A000E
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 22:07:29 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=sZbbWvj2;
	spf=pass (imf19.hostedemail.com: domain of "prvs=76345edb3=mkbund@amazon.com" designates 34.218.115.239 as permitted sender) smtp.mailfrom="prvs=76345edb3=mkbund@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794002850;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hljN27FJOQcafFkagbdcshN27epPCiw3mH4c5x0nBM0=;
	b=pepowXpVQWNnK7IufsfP22jV2dfSuF4wKyT03daicmDl8MurYeTE459XG26Aoy1kBKADWG
	05F0cDUrY9rvNgPlb0MFJVBYcfBszOFbitquhpbpiqGUeWLDBtD7KxJtQebSXXl3xBkRR3
	iOMkm5h4UuymKMj378KWGNvnI9dsWsE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794002850;
	b=Sqs5UAStemdxrALaaGWe+bGDhptZ8lRQUQ5i/k+XmeQXSPsWxv6km8EP7YUQgGtfrolrhg
	JK1FQQqC2eXMFHKrpukpR967xAwJi4qx9SZs+NVXKXiC/DQhGj1JiDe6PQr/EZxEd+Xz82
	dfzChSo3FlTjc3t44ISKGTl8dSLYjwo=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=sZbbWvj2;
	spf=pass (imf19.hostedemail.com: domain of "prvs=76345edb3=mkbund@amazon.com" designates 34.218.115.239 as permitted sender) smtp.mailfrom="prvs=76345edb3=mkbund@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1794002850; x=1825538850;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hljN27FJOQcafFkagbdcshN27epPCiw3mH4c5x0nBM0=;
  b=sZbbWvj2Do+zTB6+8zNbjLsndILkQAMnHdDcbkdtdvxvZekeESHF6hec
   jCyR7h9AEFeZVENEOJ8rZbItCPAO0nSutM0B1vCd/t/X5t62w01r65LsJ
   yTf5AMZjpyNr+Gx3rYRokwyPjKEmCE2fK12X7zyVU6ZgapXCwN3BUkhIP
   IGR5NkmttzKsLnkADp0vDz/aNiv1FMx7OeTaPqWDv1GNLbmSeURzduFX/
   AwuvXdb72380szHmLLbXiqRlvgWDBVdXHkEqHLy1H+I7hVdyWScv3ATJ/
   CfrVjgLCUFNaFmqFlmM9JJKFIwvemzpgl6GvmUO3QngwbGil0RdJbQ7t3
   w==;
X-CSE-ConnectionGUID: B+rTyIGwQpqaxY4DsXe9YA==
X-CSE-MsgGUID: aEXIzBKJTgqu99q2PrcDcQ==
X-IronPort-AV: E=Sophos;i="6.27,199,1787011200"; 
   d="scan'208";a="33137117"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-013.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2026 22:07:28 +0000
Received: from EX19MTAUWC001.ant.amazon.com [205.251.233.53:20636]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.18.155:2525] with esmtp (Farcaster)
 id 371097e3-7e73-414f-9548-a5feb17523b3; Fri, 6 Nov 2026 22:07:28 +0000 (UTC)
X-Farcaster-Flow-ID: 371097e3-7e73-414f-9548-a5feb17523b3
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Fri, 6 Nov 2026 22:07:28 +0000
Received: from dev-dsk-mkbund-2b-9ea2efba.us-west-2.amazon.com (10.2.100.138)
 by EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Fri, 6 Nov 2026 22:07:27 +0000
From: Mark Bundschuh <mkbund@amazon.com>
To: <stable@vger.kernel.org>
CC: <sashal@kernel.org>, <linux-mm@kvack.org>, <david@kernel.org>, Ge Yang
	<yangge1116@126.com>, Muchun Song <muchun.song@linux.dev>, Oscar Salvador
	<osalvador@suse.de>, Baolin Wang <baolin.wang@linux.alibaba.com>, Barry Song
	<21cnbao@gmail.com>, David Hildenbrand <david@redhat.com>, Andrew Morton
	<akpm@linux-foundation.org>, Mark Bundschuh <mkbund@amazon.com>
Subject: [PATCH v2 6.1 2/2] mm/hugetlb: fix kernel NULL pointer dereference when replacing free hugetlb folios
Date: Fri, 6 Nov 2026 22:07:15 +0000
Message-ID: <20261106220715.2869940-3-mkbund@amazon.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20261106220715.2869940-1-mkbund@amazon.com>
References: <20261105070346.3099207-1-mkbund@amazon.com>
 <20261106220715.2869940-1-mkbund@amazon.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D031UWC002.ant.amazon.com (10.13.139.212) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Rspamd-Server: rspam06
X-Stat-Signature: 9wwnoh75szyn1geepcj13y57h5sapheb
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 1649F1A000E
X-Rspam-User: 
X-HE-Tag: 1794002849-779241
X-HE-Meta: U2FsdGVkX1/lDvPQaq55/20ID6Qyo26sZsr+CzV8a2wi0wn1I37AcAjDzHBe0iK3kNUcY6PBo1CsQAbLu+PRuyW2de6FybrWewXVf0VEX3uQxJqCspDBMT+WpN8rTSwSz2hC0CIM7bApkI2xDSQXRGBQe/VQ5yuSOgE8WTWcu6a5WlKF/VAL7MgMfCOWZvjwoUHrG2+VQigWPoBL3vxOIK5bdBb7awVgZvgxHFh/t/jdkW7j1M//pcneZTbANxaK/EggP2Im1jV8//Z6hBXt8fqSa/OhgvmMF94/asmr9a7ytcruZaqNgaVeFQ76f7VxdcveosAY55gsaBhC7jyDB7igqCR0rJXSNqgbBfB38kBIoocbynjnAq+Z+sXNR8P9hU2NVpfEV7iXw7+X9bajL2UVl+gOxagetu0Kes1lcRUVSQB6dy+pmp8bBxRVxqEbvS/BwuDvEJlEoy+E3ihx/D825eQZTeJh1T4dDATIxUHFIAt1JRJm56g3EY8/b/MAHGMrByp2S+Gl1jjoVP19NbTIjb2QpqNbZDxLcEx1kMEiexfFoljeEUsa7nz9kIn2I+AGFd6mTv9PJ2e8VZp6hEK4KRPEZVsZAhhffJwdqbH4uXTC6tGHpquXADzANyzzdOaoIM7mPBZQn+DJsWFYw4C/xAUtvcyhUuGRsmDBKG1v/ZNyDKmVH1DZe57iEbKXs/BGHEW05Poizn2DCnCK5K5zS2XxlfVZYTexXQOMXNE3nRIcsHFAyBbJ/D5yuoqvmXaoSM6s7yNmugck7nUUH6w660FuERlEPZJCzi0yrdKMbPik9cFEYlWMJQy/M6Z7W2ZXS1FpI36fXP+d0rg9sqxGu8cHYDXhE+7Q28S8yTRrPt8iUh8DrKJ/3nb5N2+90xZmbj0+TFW8j/awpP4VPyYAigE5L2jLp+xkcTaiLA3XTcyH76Loj9M51Nb1L90cyz7JK74FDZxPZTHnJl9
 l3K2xGze
 Xtv9TzSeHaC88zDfAZ/fqvXXL0yrq4/FUQ9CNsckg1tekWKjv5kKjeDSo390mga6kGAxw5z22wqvg1UyRX8RUK9t0RlVxN2c3p6tOD3wuFrk1Ei03WeYUgzS3Af02r8ABUySmkN23Qanjl3y+44kia5esPRJPt84B+SK3ge1d2vEF9REo3KQw1uiTj0CWQONclo9PHYW8HW5P1gKdye977Nqq7CEJ8+WM09eqkDnJxMHHcPP107tgCTkvNq1a2Y1SF5nfE6AyW1DsHwsKtO1afOS2D7tE4s2698L9Ayi4QU/mnmUC7PntrfZPDUrJL3D2Lwj2si+1jp4j2iUy0nciTZKLGV3wLlor3GaoHH3epppltMHEPTzByEJYnthj69ddqX2A0zhMet+6q/rPqAyaDj6maI54rJ7MDd1HvUYLV6RHcEnFhkGKF9LRrXuAA0F3OHMFTOzmz8u+g6CpwlzdbK/fkgV11IXRMGyQsaSlfB6LXfmM8p84DXZOrpW6gNrnnJF+lFsbVVDcQ244gTpqmyVl/egKPn3OTzxb14xGd5y+EAkCBvDxpMrU2m9wsziwbLu/+0vyhc+Kqb1WA5Pn6oXYm7sth/s+Cw9te13y6oW6BvC8kaXaxg9UyCucLAcQFSeBfmXZpu8snIwFHIb5sDNlkEum7wjDpw+Ea/f4y5Yt4Zfpag8V6hvB6QrbtptQ60HC+wp3tUtO0TqRC8TbRsQ8cp7oRh39dZgUKqNe/sUZyciyaY2NuK6kjz4CLhxTIBvR8VMzmLyAPB2sbKRgMOTptkVZKg0AxREUwkfBndpSuDyVv6eMhQhhFrhLC+/yS3ExEY3zmqcGoSk/l3ttE/seajmdTNEsiZlJ3Cs3DT1mg003Y3UWXg5kxk8K1SxV2esYn093GysrbWDE466coLBDAButB2r9WuX7
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
index 46031ca5a7fb..6901faf1d2a2 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3094,12 +3094,20 @@ int replace_free_hugepage_folios(unsigned long start_pfn, unsigned long end_pfn)
 
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
 			ret = alloc_and_dissolve_huge_page(h, &folio->page,
-- 
2.50.1


