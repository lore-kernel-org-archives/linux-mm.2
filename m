Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED54A606A326
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 22:05:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=he6P4n0b
Received: by kanga.kvack.org (Postfix)
	id 8B1726B05B5; Fri,  6 Nov 2026 17:05:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 83ACF6B05B6; Fri,  6 Nov 2026 17:05:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 729B56B05B7; Fri,  6 Nov 2026 17:05:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 432216B05B5
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 17:05:12 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 59145120234
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 22:05:10 +0000 (UTC)
X-FDA: 85406075580.23.4E24D2B
Received: from pdx-out-009.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-009.esa.us-west-2.outbound.mail-perimeter.amazon.com [35.155.198.111])
	by imf15.hostedemail.com (Postfix) with ESMTP id 2985FA0005
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 22:05:07 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=he6P4n0b;
	spf=pass (imf15.hostedemail.com: domain of "prvs=76345edb3=mkbund@amazon.com" designates 35.155.198.111 as permitted sender) smtp.mailfrom="prvs=76345edb3=mkbund@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794002708;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JQrnZyzpIUupH0TaN2kMzMCbwSY3jfKGJ+ewuWVPB6I=;
	b=URjFfV7TR0PJHL/6w7h3Hq1XHmnIrlggiTUdC0k7E8rFeW5rP7wIlN6Vb7v3ikBi543iu0
	8q2EfDUOhKi16Pfhq9IULH5OfBsiAE6GznyVeEISBZRfS3c6FnB3Yg1+UdIkcGUHoA1IbA
	KCjFveAhxzn2HgvWrEk+1ENw7my3G7g=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794002708;
	b=yiD9PPtXJzG+EZRqKSd030VMSOZHeVcQ6ZfeLkUJ9pC9GDevLeuRLh5Bu54BGubDcEk838
	+3ru2idjhUCH63Bvs3txC1y1XF6cd1Hufco94MveA9FNxsTtQOa/YCGAuM+rrN6UGTdCuW
	2WZVJF+hkPaOk09zp4xMho2Gjbkuq74=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=he6P4n0b;
	spf=pass (imf15.hostedemail.com: domain of "prvs=76345edb3=mkbund@amazon.com" designates 35.155.198.111 as permitted sender) smtp.mailfrom="prvs=76345edb3=mkbund@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1794002708; x=1825538708;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JQrnZyzpIUupH0TaN2kMzMCbwSY3jfKGJ+ewuWVPB6I=;
  b=he6P4n0bxsQRkKvhQbYFK7EsQaZRvhfYaNVvaknn83ohMGDVYnBeLKxP
   02PnC1BmIZ+h1l63hMhVwQRWhSIRy+lpbQIx5098xXeK0lIWDRWSVBnP7
   7kVzRPSvEH2HPHx4Zj8OM8BE6XLvo6xKwl6pIbUvD/EWymTTUkTUFOYnY
   mdZ6AndkG/Sn6TTS400Jgc0Nd8j05ZTkd2ZW/esYZKtbqAyeDtz+I6jOU
   UC1x3LKkDZabc8OLfNk3jUQ9pmmQgncV0FgJ9yMVzp/+dpq6e+Ny8FOMF
   eEHg3y0+qbH5h+0/8QNpsfbDI+u+blo/n7eUYswmAhEbztRtHKGEZcqI7
   Q==;
X-CSE-ConnectionGUID: BsP+PFkDQeq/tQoMfeCXqg==
X-CSE-MsgGUID: 56EaeuCBTlu51Vy6K1srYA==
X-IronPort-AV: E=Sophos;i="6.27,199,1787011200"; 
   d="scan'208";a="33262472"
Received: from ip-10-5-6-203.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.6.203])
  by internal-pdx-out-009.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2026 22:05:06 +0000
Received: from EX19MTAUWA002.ant.amazon.com [205.251.233.178:8940]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.22.238:2525] with esmtp (Farcaster)
 id 0df736da-0ef7-4954-a906-dd90519d5c1f; Fri, 6 Nov 2026 22:05:06 +0000 (UTC)
X-Farcaster-Flow-ID: 0df736da-0ef7-4954-a906-dd90519d5c1f
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Fri, 6 Nov 2026 22:05:06 +0000
Received: from dev-dsk-mkbund-2b-9ea2efba.us-west-2.amazon.com (10.2.100.138)
 by EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Fri, 6 Nov 2026 22:05:05 +0000
From: Mark Bundschuh <mkbund@amazon.com>
To: <stable@vger.kernel.org>
CC: <sashal@kernel.org>, <linux-mm@kvack.org>, <david@kernel.org>, Ge Yang
	<yangge1116@126.com>, Muchun Song <muchun.song@linux.dev>, Oscar Salvador
	<osalvador@suse.de>, Baolin Wang <baolin.wang@linux.alibaba.com>, Barry Song
	<21cnbao@gmail.com>, David Hildenbrand <david@redhat.com>, Andrew Morton
	<akpm@linux-foundation.org>, Mark Bundschuh <mkbund@amazon.com>
Subject: [PATCH v2 5.15 2/2] mm/hugetlb: fix kernel NULL pointer dereference when replacing free hugetlb folios
Date: Fri, 6 Nov 2026 22:04:44 +0000
Message-ID: <20261106220445.2859944-3-mkbund@amazon.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20261106220445.2859944-1-mkbund@amazon.com>
References: <20261105070206.3094675-1-mkbund@amazon.com>
 <20261106220445.2859944-1-mkbund@amazon.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D031UWC002.ant.amazon.com (10.13.139.212) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: t1pqz8pmctgwpd8gmgtch4b7qnez4om4
X-Rspamd-Queue-Id: 2985FA0005
X-Rspam-User: 
X-HE-Tag: 1794002707-555805
X-HE-Meta: U2FsdGVkX18VNZ240sf4KQZgqwvnaBY01vV/CnSFaiSni4iktRrcNnnlW/5stFmwkl/RSecY7DZ62NTvrWbh9Ce9E4dQdyJSBdyigsFjvQ8gJN5k4I274o8lxp768XJ4wvb78eYro+SOUf0sQsrrkPDeaqvjS1Qy+V8FD1t4FeaFiXAIPXKHBequlMhxwYrwK3UeKeZBEE6jW6xbuK797gld26gR1MZJav7hbv+BDGwrJvSs7ibewl0MonkT2iA/hrxypWW3UctMUfuXfA5mxNrIpOy/kBhszbrGrl9649ih9n2UeHhSeh5na8qGu5mZSGJVnRNGpkP9RXjDeRQrCagabLxPQ5ZWxk2m+8/7hpHNXQT2LavF+EvXo26tCMqW5rMxBaF2NiAlZhQYxmEgsEFUGfU1y5igapAt5fEhn/xPEFvXTHZff5/++Gb+mRJ44eE/J/yGjmhPDPfvm1kwp73r+abaNJaiyti2h+BRkH5II5AgliyocrRTdTvztjNLRqPeuJ5ylutMX6EPsbAnHFkU/KUguUYIKdqMH6CNwpFst5FbCPLMxrLUnIdmvArU1SRr76YM7pvoXvbbvVPkbs61uiK0WkiuayAFlSajGnDHC9yakEP+7N5Ut2Bqqy/bU1qn39fD4Km35rRYnJmUuirSzINxcQqvMBGrYYsfbW+dHetd9IigMeS1BVNDHUTB9OWmvReEqoFq0o/rv0E+CsUG2jfP7I9ynwUJ4ifqIlFCevS7whNkxmMxO3AFtfKGmysUvYqhvrawm0l+xIXE0SEfXqUaaN8Phj/RJQfeDDSTbK5k5dmBC0PysQUA5onoYpjhlNER4PTJBw3ttsmC1ixi2GlBcirQX2JVK3x+xoF/9y34BbVAYIlmV8UKH4c4QmpAbSd20IYzKPwuIJ3vfUHDCKD7wmFVa9+DBqzakd+jEtEV6imYl13O5bXpWG/+lYPs5Hvxg/e77gFKi5Y
 iDAZwK+U
 xxSHKuLhHbebuDGjnc14HxqvRf9CmWSSqP3r6CDqdDmWMlmI1VUfAbp11MlZKgQcixplVNcQx2bPLqtW7mb6Rg28ENBCNXVooQ7GcOZTMskeVy5nhjbf7zykSBUEQR/ndEbYjb9oPJoFklhaoDtmnJXkg1UQ1zkLums/KAFYRtMZgGV/STgGq/+iNmkotm0oLBZfOx99+prDmj9M1PQ4g8SFzhb/+agU5xa8buorkJpCk5xfW0rMu6kaDYpilSWHshmJKHsw8zHuZ7Ppgc3lGMWcE5jgF7caU4G3TUbcaxkp9HGdY6+hcjWg0mbfQf00+ezDtERFGfBkYa7PJnIbbeHaj6A8TEwW4c+jFh3N72jBOVlOkpxKobMqn9TT0pcOaiqU2ehXQfZko6zMB4rONzS+8jZ2MOFXhZrk3hOXNB9nLXBhLcWJbWrof5lYxGMlJPBqC7szeRQAWK7dJB3SDc/+n+u4pnfEMaCJZx4GvlAKsJW38IesGng9k4eZzjZgUeJMvBNWzQpKjC5kbaNyD2R5eTkBrXYE7ArtconeX5ltYbhi4zwdtnz0tvbmdkO60mnGQNZ5VD6pNXrd/IvuhvsanwOC5LjqkQuliWvfv/nZOBOh0p+YQRtd/cxRoR1IN7NBe+lGjzZBK5oXfT1+JniUOImr0algiF7vsYiuZmtcHsx8TQz6WVJL2kHps5p5EQYJbjAsJJyZ7b/CiGs/4yeXaMhl6z0CL5cn2HAewQBGKm1HsfEmflduUZk4CIkTF6zP4Nf86gvijVHuR3dVzLqO3gu7+9abBmlK/ORCAZVhwu7YZD5v7umC3frmnuWCWLJQbWR+5Uq4AQmqdEZPrjwbY3UMTHM1MvM1Dg1kRj688ePyYU4xuy4h2EkTe5ilokEA4
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
[ 5.15: Use pages instead of folios. ]
Signed-off-by: Mark Bundschuh <mkbund@amazon.com>
---
 mm/hugetlb.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 4fb98320f9df..3d7e8826e452 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2756,12 +2756,20 @@ int replace_free_hugepage_folios(unsigned long start_pfn, unsigned long end_pfn)
 
 	while (start_pfn < end_pfn) {
 		page = compound_head(pfn_to_page(start_pfn));
+
+		/*
+		 * The page might have been dissolved from under our feet, so make sure
+		 * to carefully check the state under the lock.
+		 */
+		spin_lock_irq(&hugetlb_lock);
 		if (PageHuge(page)) {
 			h = page_hstate(page);
 		} else {
+			spin_unlock_irq(&hugetlb_lock);
 			start_pfn++;
 			continue;
 		}
+		spin_unlock_irq(&hugetlb_lock);
 
 		if (!page_count(page)) {
 			ret = alloc_and_dissolve_huge_page(h, page, &isolate_list);
-- 
2.50.1


