Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CFFF4606A32C
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 22:08:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=Ag82D9Qc
Received: by kanga.kvack.org (Postfix)
	id 386A46B05BD; Fri,  6 Nov 2026 17:08:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 35EF86B05BE; Fri,  6 Nov 2026 17:08:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24DDC6B05BF; Fri,  6 Nov 2026 17:08:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F15F56B05BD
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 17:08:30 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 64F998023E
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 22:08:30 +0000 (UTC)
X-FDA: 85406083980.01.9A8C579
Received: from pdx-out-005.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-005.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.13.214.179])
	by imf16.hostedemail.com (Postfix) with ESMTP id 2FF72180008
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 22:08:27 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=Ag82D9Qc;
	spf=pass (imf16.hostedemail.com: domain of "prvs=76345edb3=mkbund@amazon.com" designates 52.13.214.179 as permitted sender) smtp.mailfrom="prvs=76345edb3=mkbund@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794002908;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jLqM6V8VBqdfy8Cr2EI35hQ07IhfGvj0PLYGKQ3rD60=;
	b=ahcb54Jyap1NBMhU1svaGZVVZLj6/NVFSsiroxUSRnettjNDbMLCrGH3eCYC24PPaw8E61
	k+ytJBa6wbxi/xA+yvFJngLwii4mWtfBN01tTmlJTNKlG10cjuXqqV0Rk09X2MkeS5ddch
	BSdWMMyBk4zlplaypLzUXL2mjFgU4Rc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794002908;
	b=W7NSshZL7nf4Q0S2SA61XGVJwwXFH3dQW7tuUNgO8bMzcNqUPU4Ay2x1MtwoGh6yx8ufrq
	NKJ6r1m2MIK0XnSfV7H1FGArR/ilLAKWphuFg6f0g+ffmfTMhATmybZ/nyOngd53oEig00
	r8rYG/nt9FhqlD0xploQNLJvoEFEXPM=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=Ag82D9Qc;
	spf=pass (imf16.hostedemail.com: domain of "prvs=76345edb3=mkbund@amazon.com" designates 52.13.214.179 as permitted sender) smtp.mailfrom="prvs=76345edb3=mkbund@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1794002908; x=1825538908;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jLqM6V8VBqdfy8Cr2EI35hQ07IhfGvj0PLYGKQ3rD60=;
  b=Ag82D9Qce0fOvTYKphZEsD3SAnESDoVGmypeL7ONbqLsYNsJKwjloL0w
   be6sXCzevIyg4qYjEG4bP0BKn+y5OlvDRjZy+0cmLdAIwBHlvBmrVd/6D
   IXIL/reyWkJOxv6saUaeEKKftq+QDMTz1/LD0xh0CEmiZVamPXyBDSd1Q
   5EjCgF7xQFlohwg8XdgOdow/pCL9UtWiieuf/6yzsfre4nb8HDjmj495v
   +RJUQkseb5vItvqsyU5KUcNlGdvSsYTUiRldwbWKNKjKkpXs3Iv1ahbYN
   rIz6ABkuVXj2rPEGWqxWVtrypovrmFYfeTmQjqy6xPU4r1y8xZFzX4faX
   A==;
X-CSE-ConnectionGUID: KHl2S+aFQsq8QpPlInUoLg==
X-CSE-MsgGUID: 15MnRTM2SJqnne6M+fsImQ==
X-IronPort-AV: E=Sophos;i="6.27,199,1787011200"; 
   d="scan'208";a="33336464"
Received: from ip-10-5-12-219.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.12.219])
  by internal-pdx-out-005.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2026 22:08:25 +0000
Received: from EX19MTAUWB002.ant.amazon.com [205.251.233.111:25472]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.49.48:2525] with esmtp (Farcaster)
 id 6fb40d93-d1b6-4ce4-972f-cfac947f2c52; Fri, 6 Nov 2026 22:08:25 +0000 (UTC)
X-Farcaster-Flow-ID: 6fb40d93-d1b6-4ce4-972f-cfac947f2c52
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Fri, 6 Nov 2026 22:08:25 +0000
Received: from dev-dsk-mkbund-2b-9ea2efba.us-west-2.amazon.com (10.2.100.138)
 by EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Fri, 6 Nov 2026 22:08:24 +0000
From: Mark Bundschuh <mkbund@amazon.com>
To: <stable@vger.kernel.org>
CC: <sashal@kernel.org>, <linux-mm@kvack.org>, <david@kernel.org>, Ge Yang
	<yangge1116@126.com>, Muchun Song <muchun.song@linux.dev>, Oscar Salvador
	<osalvador@suse.de>, Baolin Wang <baolin.wang@linux.alibaba.com>, Barry Song
	<21cnbao@gmail.com>, David Hildenbrand <david@redhat.com>, Andrew Morton
	<akpm@linux-foundation.org>, Mark Bundschuh <mkbund@amazon.com>
Subject: [PATCH v2 6.6 2/2] mm/hugetlb: fix kernel NULL pointer dereference when replacing free hugetlb folios
Date: Fri, 6 Nov 2026 22:08:12 +0000
Message-ID: <20261106220812.2874571-3-mkbund@amazon.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20261106220812.2874571-1-mkbund@amazon.com>
References: <20261105070431.3100950-1-mkbund@amazon.com>
 <20261106220812.2874571-1-mkbund@amazon.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D031UWC004.ant.amazon.com (10.13.139.246) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Rspamd-Server: rspam06
X-Stat-Signature: xxfunrptsy5yzouyxcr1yg3am6u8yh91
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 2FF72180008
X-Rspam-User: 
X-HE-Tag: 1794002907-730902
X-HE-Meta: U2FsdGVkX1/dJx5+D8W/4p/qszuxsMhZW54sgU6wCgm77Td2j3Fc+Hc6Osov3fyEXFi2hj76fwDNv6ZNqte5dTEeSpVZr0FJZJMUbs4DZxRIuLdxwCXwb6C3uSbDMbV3H1oE0yA2uH1G7VRUhEgnRQi5KKeCCgxz3biUlg3LLI0lYYaOCtlvioazPLuLMkLzuBv2LhjNivxeSD7PNFyIFCthPRrVgX1iGvTGjtOYRoLHCJ+9HFcPTBFnqqHAIhid1FeCgi7q0upWyk756FuIsJ2Mtw9mL8JseLlWoq/5klqujKyiimkwF1Y5p803wmtehivjpyicfesjuMPDC5bQR8qQadUyQefRmHdiLcyPoodh/3Gso06o4wR+UUjHNnFHIFIQkTIdnaBrGfvWaH/CTqmwR39qCN8XkSRbHZERip1PlX07Vwq9Nf0x1xJN9QlnPK9ALQ35QlEGj0O1+ZyZFvjVc+ED+2VG33PY7KjdB44Ra/tpDGndUuc27Hyj5xAbmMYsraFNVXF52UxNabbYyoqOQkQy2nDR6/bp3/W/Ap5QWRlVBuoFTC0cRcMjeMVDYBuFV0bHIfS20FO1Zehj/URlMJkKEIVFEXwK8QoYi2+VpGjVIAX3cZPB3b8ALmM82eLm5bBJ6oacpTAFgDPXUP2hQf5yXMbEsVyu7h4FRepYVNZxiuR6txK1gJnurXorXQ2mMqb1wK8JeH0CpHk1kup75TVoLCjClta0So3q8wR8CnIyiPpJnerL+WzHzdq0oo5z1B64e5jQhOeI/DSz8K0+93u0WVoqDFZlhtOuvo7MJXvf5pBS6Sla4vcqzrkKtlQ9dD8LeCpaGhXTj5+9Q34rOZA4MQePMsFihPED3rkWR6RQzBIqOyGf/5YFxdT30GtMLZdL/DmAIhwkIG63AlfaHg0PpOVmo3XUw9QcBhDXASl76PWS9sDV47mGhIfmWNBZzg3dRIWQDqkWQ92
 sUwxl+Tu
 YPWS+ioiCAV4tIebi7GnJA7vTfdqsCpRLTKr+EU3KHfgOB+qW1MOBcq5D+fWM7vJ5ocRuE8weqqhfrgF7YdXTwrk7g9jwA9K2p3eW6R+SJj55K0g8pevAmDnft36NEjKksK8N4+rw2HuUnPX7Y0nlcgwZSmT0JWtK9FTUnJvyJ3cQKwY2yrZTsB+EljtZTnzTeRfvmiq/RC4qYFnWuPnH6lO3pIePkYxEKHLWe5s1n3T83b+QwCOzzepp56FaTMGzVePe7TYtNXnzifXtF6hfg4auAski4UTF0TmNH/BjNvqxI8MjBBVT0wx9UY17x1HvfhmssVZRaKPp2EdMWL+YdbSCZpFEMun89myjuUXb3h7zD4n9kHtol69ZoDnlVG7zgiaCc/OJdmKd0rPjbO+JvU4w3HaVAwzLIaE+npjHHo64lAU0K+gw40W8Wi3acXsg5RviPKhzT8AURKSKUeJIP75pImRQFNR53JM/BogvQFy0JHFOFlZPycKb2R389r9VQS1bz16WGMWiaXwqcc82TLSh2QkPvzhS9Y+zZltWq7byOniD7scmJpAolmkGzPdnyGkI4tLjjQIxe7PdFeXWpJsoveUi5e52yL+MkTRETlMNXlR7va8fW3fJmu4hpJNniwUO4QFY4Z7MBPbAOk0PpquqGEP53idi+i/zAepioHjuHNCicQ0PWSHIszYUdXLrFqjhIIoirJDotwJ0T5MvVLMd2t/G/b80aUm0mMt2GcXvJJGzYrgQEyAPwXtCTXK6A2RK1jzFwLbyXyJuhQRlMOgiGKBhYObh5S2XvOghVFmGYlk1af8td9RANVlGTX42Z4nJJ+hnNnobailDaUQi/YqZudhhLe80SC2T0g/rhG6VdG6Edj/DsNhoVwmXixArLjm4Q5oz7MmcQTR/GYl6YpQyFyjiEM2j5UYI
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
index 2ef28c49b9d0..b755fe95f9fc 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3069,12 +3069,20 @@ int replace_free_hugepage_folios(unsigned long start_pfn, unsigned long end_pfn)
 
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


