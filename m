Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D17CF606A33C
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 02:03:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=dzFsabU3
Received: by kanga.kvack.org (Postfix)
	id E873F6B05B3; Wed,  4 Nov 2026 21:03:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E387B6B05B4; Wed,  4 Nov 2026 21:03:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4E866B05B5; Wed,  4 Nov 2026 21:03:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B041D6B05B3
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 21:03:41 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4887A40896
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 02:03:41 +0000 (UTC)
X-FDA: 85399419042.26.2FE9D1B
Received: from pdx-out-002.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-002.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.246.1.125])
	by imf10.hostedemail.com (Postfix) with ESMTP id 15CB7C0003
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 02:03:38 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=dzFsabU3;
	spf=pass (imf10.hostedemail.com: domain of "prvs=762187284=mkbund@amazon.com" designates 44.246.1.125 as permitted sender) smtp.mailfrom="prvs=762187284=mkbund@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793844219;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=eflx9XqhEV3/ZTNgjoPHerK4VPtqVw/r97L+i6RFMns=;
	b=irQHYBbglE9cAMlM2KI4Azz/TxR/mgxBjkEvWS8sRcZPsH1I75ZcTZwUiPJabzpb2LKVM6
	wlyodmezuUZFmOHKsvsGFnpe1rpS/cfkMAKaesBbEVpbEK4sKPCR3O8IiKXNY81tKc1fEp
	et3Vu3LGgkmJNPLNqIpSkQBkTjx8HYo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793844219;
	b=SwAbsO2qolb/oFaa+Mmj7lNK5Q0TgsjQphdn6p9wBYahIx8SMJQ2l8fKtR+MoQiIIgjP5T
	LZhzocCD1arPJDoOJTAb/X+tb0+pZARBqBLu8u+NWAgGOdfiMcPFyAU98Oomz3HqJ/ipSl
	3Mv9pWt/85onl2n2ZtBJRsY49vW2HX4=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=dzFsabU3;
	spf=pass (imf10.hostedemail.com: domain of "prvs=762187284=mkbund@amazon.com" designates 44.246.1.125 as permitted sender) smtp.mailfrom="prvs=762187284=mkbund@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1793844219; x=1825380219;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=eflx9XqhEV3/ZTNgjoPHerK4VPtqVw/r97L+i6RFMns=;
  b=dzFsabU3SPIjVuzOUaX4z8IIjsliLethCi73A5Ya8ZQG6ihWBdC9V/AL
   ZQpBKMATBjuO6OFyECpAyQCxMTMYAwkcAL7o/oPPeyd+lDaWRPudHYqzp
   VGWv4vj90+chwGSLmqx8KcklVpshvPYwNl3j79cUho81T37a62E3k8Csi
   9BEhJZ1FRmnuNur8uDt2G9z1e1eKonJsrg68lqVI3yzHn8VHrab6/x9fm
   x0MgihJLuVAmdCsb8h/cFhMcoTpq31Rd2wCMVuZjvh79GjF1pRDuWsjmg
   qDCNZ2cPo3iknrqJAtixhrYb5pCGiEdLecBtcpIZYHDi+4+BqnKRVa2CI
   A==;
X-CSE-ConnectionGUID: S6rO9Zl3Sbm5H5aI4IU+0A==
X-CSE-MsgGUID: tRYFQKC+TSqbxuzvWRnbuQ==
X-IronPort-AV: E=Sophos;i="6.27,196,1787011200"; 
   d="scan'208";a="33148998"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-002.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2026 02:03:37 +0000
Received: from EX19MTAUWC002.ant.amazon.com [205.251.233.111:29615]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.44.23:2525] with esmtp (Farcaster)
 id 14ed1291-e131-4989-ac80-723dbe224752; Thu, 5 Nov 2026 02:03:37 +0000 (UTC)
X-Farcaster-Flow-ID: 14ed1291-e131-4989-ac80-723dbe224752
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC002.ant.amazon.com (10.250.64.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Thu, 5 Nov 2026 02:03:37 +0000
Received: from dev-dsk-mkbund-2b-9ea2efba.us-west-2.amazon.com (10.2.100.138)
 by EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Thu, 5 Nov 2026 02:03:37 +0000
From: Mark Bundschuh <mkbund@amazon.com>
To: <akpm@linux-foundation.org>, <muchun.song@linux.dev>, <osalvador@suse.de>
CC: <david@kernel.org>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	Mark Bundschuh <mkbund@amazon.com>
Subject: [PATCH] mm/hugetlb: add htlb_dissolve vmstat event
Date: Thu, 5 Nov 2026 02:03:24 +0000
Message-ID: <20261105020324.2011790-1-mkbund@amazon.com>
X-Mailer: git-send-email 2.50.1
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D031UWC003.ant.amazon.com (10.13.139.252) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Rspamd-Server: rspam06
X-Stat-Signature: q76k6i11yjt3hzep13udtpofjzf9sozk
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 15CB7C0003
X-Rspam-User: 
X-HE-Tag: 1793844218-749794
X-HE-Meta: U2FsdGVkX1+FR/ELeMiBevuX9qHJpNl0cXqkeqFyBClg5xA8r3lot1Wo1ZhBD5n0SCuOnJ1hl9jyCOiaJq8m6UZlt+7W1tvkwHzKROs8ILAJKIVib5CnAcQPgyq9oWD6Ih/oEwqgUCxsLpiESxe0+/Vh7zRimOvzdgpPjcynjmup8QYatfzYMpi03Jvkb54dQMy5Aj5Mqgwz7YlOLeYjevCAHwjzI3fm3hKO0SRIwIsIyTDjslu6N0JFrlHLTT6iNukdPpXtt9l8mRvJ40a/dc3oOUmJe5hLJ8XqBkdkMPMcDGTnrTtnW8SPTYs6lXEhkJUbjC99c0npQI9eJ5G1963qh08j5kDD/gdWe6mRSTdbGowg8neLkGNy8Pw+p2uuOM7I9EdYCbFCDidJ0PBqexs+jZH2qMyF4c1qYaoYrWfH3FEsvUyWCX8xugBlYDpKkUix6E3Br1aODTxVgYp1QCen8/goaDreaIfyxuJ4ExNy2/32VXmZeYcWE3pqP+xlynlF0qc1Mn25t2gRmB83wLIMO64CoMVoFE3xnQ6CI59P772Lrvf4/mZ+CUse3uETVfBsqo60uWlyQvxZm+QjBldVE4nbmFxJtkXK3mSS6gzpNup58Tx8HFxLfAvL4UtXuG8iNqOUtPViiFiIwXO4oRYNwinr9A97MUodWeSwBKlAfOywNCykcocFJn6lEA2bZfFoE+DNB07EjLS2dEPd7LikGufA9NkgVAcqaO0pDBIx/3hg/CgnoCjRB3C1ErMa7hmtUWmNd1sv1GN7Dc8bpLZI/syVEMGRHGZIHWJooHuSCZNIyCd49fbVLLZHZ5PP++zevaPcrSh6lHATvl0dBBuBViUT5wfDlkLbb3GNVo1GeU5TejVWKUnXX3j9i+KUEzFC7nHnatq97459K0EDg7R/JJ06TP1egg+ocigRm2tZTgKziKxb8OsY3bs5YzdR0EgsYtwtWDa4F+KRo+3
 RayPoorM
 WZ5uFCDsoME+AiwtJg8e73V8+wzEr3NrQkU9TXB8A0pTKs2YsV/eUNBIIzyNhGP8bVOaHjI39IhKPeeXzYd9y/vsp2IXAI0qo15mR6d2zdJywbo+NwHCsUvCkcDrOHUEhEyMNnZo95NAhh+p5Nwd/g/o/wv5W+2hNV5X6om0nfO9VKFf3OuK1EnPoCjN6Oy2v8rpyjdDE4iTRSoy/NANQYzIO0TwnJ8r83UvuL9caPggNcDAG4tNBR/PxxRc74FyYp7lg69rfGJdPApvqqki1uY6fIECy9A3+AhphdL+CxVV2DgmsrXA/DbihuqqW/r+hmYCQB+ggJcG3Nq8LriCQ1zjVIpzUGvZfwNJ/fvU3v+xYtzaYDAgbbOrDTmgdnhw1whWOWx1H36inNYPdpCmD/r3HTt6CHmDdF1GdL4Vq5SCvRVfkwvdvsZbeY8ppZovpY9BOWK6NVfVXaL/XlVNcbyh0jXCBtKcjF+AuVIiFruqFEJjbNtn/MO49vVFT0ZRkf2GJ1G63iNELfFbniiK+gQ0QmF4wAlWMIo/Ps1C2bRnmPEU+PcnJTYxxZNrVx645KhwnSax3MSmbecdR0E5XQbuSJaTRVPESD42tyBLhTgvfbkzQHdsAfrZDgf+WQpOL7/JHGJ5b03LSetFbWJddl70OxKtkQfkY8GDPWJEItr78kqEs3D1aIv/qUQ5fW7zCFGDp5OnPgf2GYak8DihYxsao5cD9yZ1qQWVtW47DdqIsWJ274gPTtdGmUg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Memory offline and memory failure handling dissolve free hugetlb folios
and lower nr_hugepages. Nothing records this, so when the pool shrinks
it is hard to tell whether that or a write to nr_hugepages caused it.

Add an htlb_dissolve event, counted for each folio that
dissolve_free_hugetlb_folio() frees.

Signed-off-by: Mark Bundschuh <mkbund@amazon.com>
---
 include/linux/vm_event_item.h | 1 +
 mm/hugetlb.c                  | 1 +
 mm/vmstat.c                   | 1 +
 3 files changed, 3 insertions(+)

diff --git a/include/linux/vm_event_item.h b/include/linux/vm_event_item.h
index 2628ccda076a..822fe862e5b3 100644
--- a/include/linux/vm_event_item.h
+++ b/include/linux/vm_event_item.h
@@ -71,6 +71,7 @@ enum vm_event_item { PGPGIN, PGPGOUT, PSWPIN, PSWPOUT,
 #endif
 #ifdef CONFIG_HUGETLB_PAGE
 		HTLB_BUDDY_PGALLOC, HTLB_BUDDY_PGALLOC_FAIL,
+		HTLB_DISSOLVE,
 #endif
 #ifdef CONFIG_CMA
 		CMA_ALLOC_SUCCESS,
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index da5d04edf7c1..7c79523b2a3c 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2047,6 +2047,7 @@ int dissolve_free_hugetlb_folio(struct folio *folio)
 		}
 
 		update_and_free_hugetlb_folio(h, folio, false);
+		count_vm_event(HTLB_DISSOLVE);
 		return rc;
 	}
 out:
diff --git a/mm/vmstat.c b/mm/vmstat.c
index a3e809c57f29..6282eef7074a 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1397,6 +1397,7 @@ const char * const vmstat_text[] = {
 #ifdef CONFIG_HUGETLB_PAGE
 	[I(HTLB_BUDDY_PGALLOC)]			= "htlb_buddy_alloc_success",
 	[I(HTLB_BUDDY_PGALLOC_FAIL)]		= "htlb_buddy_alloc_fail",
+	[I(HTLB_DISSOLVE)]			= "htlb_dissolve",
 #endif
 #ifdef CONFIG_CMA
 	[I(CMA_ALLOC_SUCCESS)]			= "cma_alloc_success",

base-commit: 05441d697f7f9a927264f4058cbbc6a03dfcac9d
-- 
2.50.1


