Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B848E606A326
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 19:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=do+M1GPA
Received: by kanga.kvack.org (Postfix)
	id CEEAF6B05B3; Thu,  5 Nov 2026 14:15:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9F426B05B4; Thu,  5 Nov 2026 14:15:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8F1F6B05B5; Thu,  5 Nov 2026 14:15:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 980FE6B05B3
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 14:15:39 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 32C5D120B86
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 19:15:39 +0000 (UTC)
X-FDA: 85402019598.29.44B6C3D
Received: from pdx-out-013.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-013.esa.us-west-2.outbound.mail-perimeter.amazon.com [34.218.115.239])
	by imf10.hostedemail.com (Postfix) with ESMTP id E0E81C0011
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 19:15:36 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=do+M1GPA;
	spf=pass (imf10.hostedemail.com: domain of "prvs=762187284=mkbund@amazon.com" designates 34.218.115.239 as permitted sender) smtp.mailfrom="prvs=762187284=mkbund@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793906137;
	b=fOlDcxVkOUoRKnznQZJvRV0q+sF+XYipMVNkIDxRFDywqLS5QRDtpt4SnQAZez+tYVhRU2
	WG+hvieaPJaj8lNIg76jQb0NvuVuA7LbPRPSBMRNjofusQMwF7M+cbynGtkOBnxLi6rzL8
	ij2X5XCJPoE/gPidIid0o8QtKvSo3Yw=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=do+M1GPA;
	spf=pass (imf10.hostedemail.com: domain of "prvs=762187284=mkbund@amazon.com" designates 34.218.115.239 as permitted sender) smtp.mailfrom="prvs=762187284=mkbund@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793906137;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=SmXGLtwdL6+xdqj7AXF13PSOAqPEIyOh4wlNcIxilCA=;
	b=VeMe+U7tN9KOGwspaCS6Bc21aQyuzBaO6KQrOkP+oMc4ETQDzR+pGLwa6Hv0MS5nkp38Fx
	oFjfIP+WnSiTzc9rwgyS4gtnyVUNIqZSjRH8FBNt1rRBvHNzLB12HJFn0Pnb/X9uOyvVtp
	yw3m0YgAtN1vSnxVNTQT36GRq8s44Ew=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1793906137; x=1825442137;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=SmXGLtwdL6+xdqj7AXF13PSOAqPEIyOh4wlNcIxilCA=;
  b=do+M1GPAvjdEYa91e9Mt9ipPQ2Rezb3/VLGubLf/zXcJQYffSa8YbIlJ
   1Sg68ThctZR+3Gr2kPO7ZVpUYMfqt38Q6qAbCDKPiMW6wOHEOgWlzGAgL
   mwRf1r+xdoP2xCH4EgNY/g2SN8i5Z1wUeQAKqqzGSg7QrK9n8obguVGb7
   kqXoHqJ7e7Wr7A9sLfRuJmig8H8I6xLRCF0KTEOP1kTjYskjDJIlXIVO8
   VRk4h13xhKZsJxkD58QZajwD2yHPMzYGbCUN4nl4OPBlelGDe/W2GuOOj
   1GN1j9UyhmUdyMx8AutpB0xUthxs6xWCvh8mbSb18dkdhyWSLy4QzS26b
   Q==;
X-CSE-ConnectionGUID: A9nJ3FyTRwKTVLb6rXkvPQ==
X-CSE-MsgGUID: iG9TnQSaTA610vgUlcmtWw==
X-IronPort-AV: E=Sophos;i="6.27,197,1787011200"; 
   d="scan'208";a="33012070"
Received: from ip-10-5-9-48.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.9.48])
  by internal-pdx-out-013.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2026 19:15:35 +0000
Received: from EX19MTAUWC001.ant.amazon.com [205.251.233.53:19730]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.22.238:2525] with esmtp (Farcaster)
 id 40b2d56e-bfa4-4cd9-86df-f52e0a0d2fa6; Thu, 5 Nov 2026 19:15:35 +0000 (UTC)
X-Farcaster-Flow-ID: 40b2d56e-bfa4-4cd9-86df-f52e0a0d2fa6
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Thu, 5 Nov 2026 19:15:35 +0000
Received: from dev-dsk-mkbund-2b-9ea2efba.us-west-2.amazon.com (10.2.100.138)
 by EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Thu, 5 Nov 2026 19:15:34 +0000
From: Mark Bundschuh <mkbund@amazon.com>
To: <akpm@linux-foundation.org>, <muchun.song@linux.dev>, <osalvador@suse.de>
CC: <david@kernel.org>, <jiaqiyan@google.com>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, Mark Bundschuh <mkbund@amazon.com>
Subject: [PATCH v2] mm/hugetlb: add htlb_dissolve vmstat event
Date: Thu, 5 Nov 2026 19:15:08 +0000
Message-ID: <20261105191508.1021974-1-mkbund@amazon.com>
X-Mailer: git-send-email 2.50.1
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D031UWC002.ant.amazon.com (10.13.139.212) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Stat-Signature: po58x8y1kjomtocu6wg7oooec3isnids
X-Rspamd-Queue-Id: E0E81C0011
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793906136-466233
X-HE-Meta: U2FsdGVkX1+EAfSuIOK5EoTV8SZGsS5vVaHburQTBhHfC60jSsSsDEwFPUcgPBjrt6hWoG7VzSVN8As1iTZgSgStjTN30y3vmHOGazGQp/K60pnP/n2rM0jpBbJezygY5yYliujpMS4fwjTwaVaimpAV2WJM/muzz/h0tCcrIgKzb5pg3QL+KAHP1VXetHTUfPOxRoJHcx4/8ahAb7QiwA2nsDe7wCVJYJmC+WXLL1UJibgczYHaUXjk3KfT9RNq+EzjErn7sptPKjtt4Hnz43VubOdww0V1CQlX8LXxNyLK6Iwjm5BcgbHuzx7ZpJg/2SDxrOg6sBsx+S4xYzSJEXnzLRkxmUWDc8FNxcZCf7ZkWMH+GdlVjIBKDJnU5BEVg/mpwWnnzIwuFArdUr/ejcLH870RLUzIw3tYUUtBP7v8N8Wib3TBy9PoyneAGvP/3EKWel/+s+278t+2XfSnnp5ugaIx9EE19LgP5GS14dQorHTIYATY54LOpCz5lOMSr5Q+MO5EEEHpvM5oufj2RKHLW4edDJFmMPdVmk9OaITeGlp2bP2LdGT2u3T1oWUH+4j/JnCKso7cxV4HqiQm3TncTZ3nqPH3aDSV03iHbvf+87aeaFCEZXeSTk6kq5LFg+sHIxywKWdawA07adsyfVjQr2riwRGGwy9i5hK+tMP23ep0+oj/5O3S8MjZ0A59rIeUDAI1JAOCSm4/3d83rAcFiHQ+o/zVTnEXH0NPvH8MIi6TVcWZiYTQF0B/PcvV/hjMcuxmDQuaMwMNoQN7NcUQgaThcatHHCXP8OCqIWonu7rinifL8slp3JM6cOrLbB2g/lgPMS4uZueUq2rKKLL1XqaEuiEBJZlwXZZG73awSjZAmOyflZCVNvZ8s9G8P8YUhxNDAQ3WAwQAdJo+WT1OA/VsliopgEBYKvKW1Nus6WdkIcqEV01MrM7xbycaINxmedZxfjoiOuU+tJt
 WO28QF57
 p38WqZHRo8h8i7Jh9GtPCmCq98Yaa9CdKc80YbnM+fbCq9uv0nJfP+3Zt8Z6BdOg4mNzmjn7dESSqCvjOUnCdna27RjxhqgxyMCSbKomwBNC0KPEXkGCOVb20wh/MrS3ePO20+NX5lAptbGASqEGbZY3gZ+w04s2JwWnjhN7jSfygG/ScFBlEv4GRvKbWlpUDHFhOUbihLO1wG04OR2cRxfhLO9l2vCJae7U7XqPXMhgnCwWz9MNw/zDZWV8TkET5fbtmpZouOPv2cr/HJBkzY/2GX0l7KYJPX0zYji1oWFchkSd8ymtDMPlf6ZXXr5unhVWKLvYxi1wqt8kYG+lKqctZEIl/qLlHeE57m91D1oDfLvDz676OtoiW31R5ECdKKPvCfzHvOHLNzIz9B8HDAabHqIeNpv70jVS52GiuB2pOiUMtZOi5Uuii9slsrDoZWH58Y5q4w3/xX/05lT9NqS4Q9JfrHMPgYxUexbo1TVI1Ybv1W5KllwFDL1EhLvSsivUiNx0UlHQrUtrzQFWLus5JHguN0VEawNstqm2e8oGHAhzZ5ROxJF7m/ND5+9SvPTYj4phb2N/ruVdNI+wggSgKVPgIJ3KnSEQga+nynZdRriEpR0iSbIKnXFZdBsxcENuvsWRxe0e5RsU3tzxFWKVS2av/4Y29MI5tBR9QYcXuFcazED53xM7sqhQ8UCnLR0fAgNLkw6NdJjxrwB1ANRv0YaZCgm+vjAzglxJbtETuO51p/g5W9SdswbK7OuVu6f2RNs8nKHy7Yyk=
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

Add an htlb_dissolve event, counted for each free folio that
dissolve_free_hugetlb_folio() takes out of the pool.

Signed-off-by: Mark Bundschuh <mkbund@amazon.com>
---
v2: say "takes out of the pool" instead of "frees" (Jiaqi)

v1: https://lore.kernel.org/all/20261105020324.2011790-1-mkbund@amazon.com/

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


