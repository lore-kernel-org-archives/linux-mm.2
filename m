Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D50B9C79FB9
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 11:46:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA8D76B008A; Thu, 10 Sep 2026 07:46:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A66636B008C; Thu, 10 Sep 2026 07:46:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 970046B0092; Thu, 10 Sep 2026 07:46:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 55AC06B008A
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 07:46:43 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A39E980482
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 11:46:42 +0000 (UTC)
X-FDA: 85197675444.15.C13C505
Received: from pdx-out-010.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-010.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.12.53.23])
	by imf07.hostedemail.com (Postfix) with ESMTP id 60D0940003
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 11:46:40 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=amazon.it header.s=amazoncorp2 header.b=f014+1cT;
	spf=pass (imf07.hostedemail.com: domain of "prvs=70634fad6=dipiets@amazon.it" designates 52.12.53.23 as permitted sender) smtp.mailfrom="prvs=70634fad6=dipiets@amazon.it";
	dmarc=pass (policy=quarantine) header.from=amazon.it
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789040800;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zIxMe7CUOIbyICiMyGkhisOqvvsyopgrlubg8GsVc3c=;
	b=n7cPDf69pSzu6vXWLoZV3sOIUWR6Bddh9rl5CjF7bWyRGwxNO+vb341gNvnqfJs+FhQPN2
	z6H2kzr0hNdtSruSIohbITX/kcKhN/40EBuVzocWlE8HO0sNcEWtf9/XBSfMPjWApuHFNE
	o94d0wrWvyjcN4j9sWt/1ZlXbVhhtQg=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=amazon.it header.s=amazoncorp2 header.b=f014+1cT;
	spf=pass (imf07.hostedemail.com: domain of "prvs=70634fad6=dipiets@amazon.it" designates 52.12.53.23 as permitted sender) smtp.mailfrom="prvs=70634fad6=dipiets@amazon.it";
	dmarc=pass (policy=quarantine) header.from=amazon.it
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789040800;
	b=hMDe19tYxhT9GVRevOPWg/HXEnVbq9FmVsPJdk9XsoP4VeW5o9qvSrqmhAIcBU8H8yrm4b
	Gax1GE2epWA0TcSm+PvtcCUhsu/MlKeFFh9Qntwpabm0MVY1tfKqacpseeJ2xI/ULUCa0f
	zsRC9158whOV2FxuHf4h0IH0kOCw+hU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.it; i=@amazon.it; q=dns/txt; s=amazoncorp2;
  t=1789040800; x=1820576800;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zIxMe7CUOIbyICiMyGkhisOqvvsyopgrlubg8GsVc3c=;
  b=f014+1cTqIYrhRdJJwglXM/pNi9lpRY/uibwvDrm28C3e1vrQLVDh/3V
   nHzsbI7Eo3/3q+TzTzn+cdJikk1PXrxv7N2DX+QoOtzHwNrTbj5YHZ1Kn
   rEXTSkylb+geM3Nyi+UpHwSA+4MkhkYkEAN8dqHIA0wNxcyhDg8w4YVyL
   ehimbvOT3+YJpZOSStQm3pKxYz1GgFo40uQIN10TxSWu4uy9F3uSgLefT
   UkgXM6aAXDhJI0mNKVLq87cdvX0JvpVwhiVJprnFo9zPNN0iX4UfXvZIS
   aWhsSADT5bGxrusM0FefZDqTZcXDUAgi6lEZsIpAy8YECYZUdqXppBxgR
   A==;
X-CSE-ConnectionGUID: PrxB9U2pTCO3cOtOxIS8kQ==
X-CSE-MsgGUID: 71u9WAD7TGq5z4s2L10l2A==
X-IronPort-AV: E=Sophos;i="6.27,95,1787011200"; 
   d="scan'208";a="28190348"
Received: from ip-10-5-12-219.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.12.219])
  by internal-pdx-out-010.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2026 11:46:36 +0000
Received: from EX19MTAUWB001.ant.amazon.com [205.251.233.104:31293]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.22.113:2525] with esmtp (Farcaster)
 id 723b55c1-1dd1-4458-a7f0-829821daf3d6; Thu, 10 Sep 2026 11:46:36 +0000 (UTC)
X-Farcaster-Flow-ID: 723b55c1-1dd1-4458-a7f0-829821daf3d6
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB001.ant.amazon.com (10.250.64.248) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.45;
 Thu, 10 Sep 2026 11:46:36 +0000
Received: from dev-dsk-dipiets-1b-77b833da.eu-west-1.amazon.com
 (10.253.66.177) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.46; Thu, 10 Sep 2026
 11:46:31 +0000
From: Salvatore Dipietro <dipiets@amazon.it>
To: <akpm@linux-foundation.org>
CC: <abuehaze@amazon.com>, <alisaidi@amazon.com>, <blakgeof@amazon.com>,
	<brauner@kernel.org>, <brendan.jackman@linux.dev>, <david@redhat.com>,
	<dgc@kernel.org>, <dipietro.salvatore@gmail.com>, <dipiets@amazon.it>,
	<djwong@kernel.org>, <hannes@cmpxchg.org>, <hch@infradead.org>, <hch@lst.de>,
	<jackmanb@google.com>, <linux-fsdevel@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<linux-xfs@vger.kernel.org>, <mhocko@suse.com>, <ritesh.list@gmail.com>,
	<rvvandan@amazon.com>, <stable@vger.kernel.org>, <surenb@google.com>,
	<vbabka@kernel.org>, <vbabka@suse.cz>, <willy@infradead.org>,
	<ziy@nvidia.com>
Subject: Re: [PATCH v4] mm/page_alloc: avoid direct compaction for costly __GFP_NORETRY allocations
Date: Thu, 10 Sep 2026 11:46:02 +0000
Message-ID: <20260910114602.926944-1-dipiets@amazon.it>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260905174239.99e31515fabe220aa7d8e6fa@linux-foundation.org>
References: <20260905174239.99e31515fabe220aa7d8e6fa@linux-foundation.org>
MIME-Version: 1.0
X-Originating-IP: [10.253.66.177]
X-ClientProxiedBy: EX19D035UWB002.ant.amazon.com (10.13.138.97) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 60D0940003
X-Stat-Signature: xz33c4snmjnd48kwqi1g9ms5sbgihu18
X-Rspam-User: 
X-HE-Tag: 1789040800-580678
X-HE-Meta: U2FsdGVkX1/zN+YgyKyH53XbPxHxsvm2W365BzNWA46cykWVUp/sIogS7bbuOcsATvcQNQ70rR40Wiy4vZ+14wUnVz8JTZ6cShMArGlgPNJapugnDL6HIexzxDZNsGVTU2FeO/4h1xap0MKxZ90FV0blx+eNmI1jrAC9geRVbLemvNzYvfIUFV72qeyz2JM5Rnwxmei/wuwM/59UN0NnHVrNQKwRiV8I/6aZvCpCMexRh3rYBltu7Emj+jPzSatDXzN6aY+nELGxN5RawlVWGmC+r/o2+NYwJBGs9Nw6lnzmzuNpR0q1gX8gu1g14FvQeRVYz0yMC40BxNz9FsRUcBg3Y/DoJdY3f1HfHXmnKfamB9zuD7EwHhVQlrfMXh9Mi0zLfkGehKQRURcAg1NS0bZyUK0DanmRFfZznE0GNwTsBrehAiJDfJlLUBEiGyUrlGUn7YMctF0u/vyHy0wKPWiG00G9A/pNIycBbIqiBE9G+5zwWOgUUa3qpLvxYg2R8+0cLOTlKsPdR/U4uwFGkMpn34zq8XRMTBvCg/KGR3FhoPK9G7nPL162Sjw/ghsE8XCwalxs0KTR4PlclNxaInIsAccR2PlrTcVAXJsx+7TUR6F6mdQ+ZC812/mKmxnVQTChy19iSo1meup495kJSJKToMsEsDVnyfs6eiqDlbT8mWToqzH2LfXFa6pV05Yh2xezQZFYdGLD1bao+OR6wHv8uVTD/48WhDiuA2rp8iJDk8Ujh/SHlIFw/IICbQdDlJlkU4OS8AqwZ8aQGE8Xzj4pkoh3RBobk/9fczkl1bdzrJDw1vH22v2Pm8k/N+iS/7sqS78ZGGu3+homqwpbgZ1rdtpLeoNT4a7d/tZ9nNXOO8W4AUT+6H+eApgh3W9fQelbxHnpCdTA+xmFiFo/vhQJrqMDHy6Fh+a70uUdgQT4+YbJWtptdM0BZZLZs65gIpVvxNIUwE3had/Lcbr
 d+AEfpND
 k5aANbu7vb22t2SVxKEWRDOZ8Y/W5bStVdRxuhKXFhpaTAds6IvpDakrJjWS8KXcW+yEJ++scr6Dr0iiQzEpqjaw0ZSxLOjNie86QYgE8Gn2tVQuBXZ3CDAioB/VK+Z6APwP4P9Ne9O7xIlM8SJ70iMEhYYJirfTkUic6kApyjJE70BNSNzoWXlw/IUJLysnVkSSwV/hrG6YCWcXhGgEwUwNsOn0+zkTN79XEuYrLx0pU6JNtLdvRgBJhq3VpF6m9nlUmdbG9J9Dd8hQyjqS45MHh+l8LqAQepwBU53kP6iWZ9W3U3GsNtFHtDUu9/yDh0t0EH6nWpP3IQA5ROTFX167aSKugM94dGh+bc3w19FC6jSbAtz6ttPpZhsSJuID0tse+JvGvcVCDYVa16QkB+7cWfcuIS1GLdSxhWPIN8opVLwFXnfz6ZY4WgN/lKO+K8nOoKne9S3iE7s1sURxrfedSc9NUXUga7X3nacEBHPkzaDN4UVXk8Tp2mlhN3uiMzf/eFytsUlU2/8Z+5Ikfcs4HDVYS8eALj0VFUrKz1t0Gi2kZPnuYPNqi8OqbUXpKqG4JnSMWGmXe05Yz1WOuDgMa8TFWUmqFxK3Xp6jtJh5rh4Fc/cKhUp5XvKPx15H4rOgwfZyXcsGuQhA689XTtURf3cUJprm5QwdZg9gP49CUdAKMRRKJqIO9pz0oCkuQvwF3LZagCOJMa23UFmKWzTs6aI8PBe9Bx9X4S5zmdRs2G2oJFJ+PNb6Y23MKJOs87cgxBMS10WzaCe5M1nAa0lZHvbiexiwU2zaM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Sat, 05 Sep 2026 17:42:39 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

> Is there anything particularly unusual about this test case?

It is a stock pgbench simple-update PostgreSQL workload on a large
instance (96 vCPUs), using standard PostgreSQL settings and with no huge
pages assigned to the database. We deliberately overprovision the
pgbench clients: 1024 clients over 96 threads. That keeps enough writers
in the buffered write path concurrently to hit the costly-order
allocation failure path continuously. The memory fragmentation comes from 
page tables: PostgreSQL spawns a new process per client, and those page
tables consume ~40% of memory, which significantly limits the page cache
and the free memory available.


> > Results (average of 3 runs, TPS):
> >
> >   Config                   Avg TPS      % vs Baseline
> >   baseline (no patch)       59,408       -
> >   With this patch          155,409      +161.6%
>
> Is this back to pre-5d8edfb900d5 performance?

Yes - fully recovered. Here is the summary, same host and workload
throughout, average of 3 runs:

  Config                                        Avg TPS   % vs baseline
  AL2023 stock 6.1 kernel                       136,942            n/a
  v7.3-rc1 baseline (no patch)                   59,408             -
  v7.3-rc1, 5d8edfb900d5 behaviour reverted     151,184        +154.5%
  v7.3-rc1 + v4                                 155,409        +161.6%

The 6.1 row predates 5d8edfb900d5 entirely. A different kernel version,
so not directly comparable, but it shows the performance this workload
used to get on this host.

A literal "git revert 5d8edfb900d5" does not apply to v7.3-rc1 -
iomap_write_iter() has been rewritten since - so the reverted row is a
one-line behavioural revert, forcing the write loop back to copying at
most PAGE_SIZE per iteration:

  -	size_t chunk = mapping_max_folio_size(mapping);
  +	size_t chunk = PAGE_SIZE;

which is what the pre-5d8edfb900d5 loop computed. That makes
iomap_get_folio() pass no order hint, so the path issues only order-0
allocations.


> AI review asked a few serious-looking questions:
> 	https://sashiko.dev/#/patchset/20260904115629.3993331-1-dipiets@amazon.it

Thanks for pointing that out. To address them, we can have something
like the patch below. Performance results are still similar to v4. Happy
to submit a formal v5 patch with it if you would like.

  Config                                        Avg TPS   % vs baseline
  v7.3-rc1 baseline (no patch)                   59,408             -
  v7.3-rc1 + v4                                 155,409        +161.6%
  v7.3-rc1 + proposed patch                     161,994        +172.7%

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 12fac9084c48..be8b0d72a2db 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4784,10 +4784,22 @@ static inline struct page *
 __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 						struct alloc_context *ac)
 {
-	bool can_direct_reclaim = gfp_mask & __GFP_DIRECT_RECLAIM;
+	const bool costly_order = order > PAGE_ALLOC_COSTLY_ORDER;
+	/*
+	 * Costly __GFP_NORETRY callers have a cheap fallback to a lower order,
+	 * so don't stall them in direct reclaim or direct compaction.  Exempt
+	 * __GFP_THISNODE (the THP attempt from alloc_pages_mpol() needs direct
+	 * compaction) and __GFP_NOFAIL (must not be made to fail).  Don't
+	 * clear __GFP_DIRECT_RECLAIM from gfp_mask instead: that would also
+	 * change the alloc_flags derived by alloc_flags_slowpath().
+	 */
+	const bool costly_noretry = costly_order &&
+		(gfp_mask & __GFP_NORETRY) &&
+		!(gfp_mask & (__GFP_THISNODE | __GFP_NOFAIL));
+	bool can_direct_reclaim = !costly_noretry &&
+		(gfp_mask & __GFP_DIRECT_RECLAIM);
 	bool can_compact = can_direct_reclaim && gfp_compaction_allowed(gfp_mask);
 	bool nofail = gfp_mask & __GFP_NOFAIL;
-	const bool costly_order = order > PAGE_ALLOC_COSTLY_ORDER;
 	struct page *page = NULL;
 	unsigned int alloc_flags;
 	unsigned long did_some_progress;


Thanks,
Salvatore



AMAZON DEVELOPMENT CENTER ITALY SRL, viale Monte Grappa 3/5, 20124 Milano, Italia, Registro delle Imprese di Milano Monza Brianza Lodi REA n. 2504859, Capitale Sociale: 10.000 EUR i.v., Cod. Fisc. e P.IVA 10100050961, Societa con Socio Unico




