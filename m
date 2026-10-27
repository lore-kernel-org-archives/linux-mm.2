Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DC5A606BAA3
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 15:00:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=amazon.it header.i=@amazon.it header.a=rsa-sha256 header.s=amazoncorp2 header.b=cKjNLsHz
Received: by kanga.kvack.org (Postfix)
	id 152EF6B07A5; Tue, 27 Oct 2026 11:00:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 12A916B07A7; Tue, 27 Oct 2026 11:00:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 067376B07A8; Tue, 27 Oct 2026 11:00:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DC0826B07A5
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 11:00:26 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6268F809EA
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 15:00:26 +0000 (UTC)
X-FDA: 85368717252.17.D92DE93
Received: from pdx-out-013.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-013.esa.us-west-2.outbound.mail-perimeter.amazon.com [34.218.115.239])
	by imf25.hostedemail.com (Postfix) with ESMTP id 09ABFA0005
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 15:00:23 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=amazon.it header.s=amazoncorp2 header.b=cKjNLsHz;
	spf=pass (imf25.hostedemail.com: domain of "prvs=753d3cd48=dipiets@amazon.it" designates 34.218.115.239 as permitted sender) smtp.mailfrom="prvs=753d3cd48=dipiets@amazon.it";
	dmarc=pass (policy=quarantine) header.from=amazon.it
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793113224;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=plx93BXIQUOSUsvJsCgjZtiZG1rNFPpPYeNwPZQpSek=;
	b=17LNtj/1n27NcPKRPHhdKhNXr9mY+IwuDX4p5UiCa4hMUgwsyVvUaJcIuKxy6GlxHQ9DWf
	FLHr5UlUhtQOyd9WT5fyKEs/zkIOIDWeOAaocVJIAJVxRDAnwyWZPYJbRPAcJdfH9XRvL2
	A/SG5DvMkXw93lVEXZdcj9LJw71GAZI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793113224;
	b=FtbXV/8MgCpSPgVc8/FJsEOZfYkaMk+vBH3OPUHGkeerelhhCpulpfcg5IEWO780fLffQa
	THNts/fiC/uYbG0z90PVujm+FXyKfQqGgzQRZ8XBi85eAgwDKZqD9BuiS99rDk5tJ/lsc5
	EpP/RCAKD6udkadHvtk00A5qBQnWEBI=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=amazon.it header.s=amazoncorp2 header.b=cKjNLsHz;
	spf=pass (imf25.hostedemail.com: domain of "prvs=753d3cd48=dipiets@amazon.it" designates 34.218.115.239 as permitted sender) smtp.mailfrom="prvs=753d3cd48=dipiets@amazon.it";
	dmarc=pass (policy=quarantine) header.from=amazon.it
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.it; i=@amazon.it; q=dns/txt; s=amazoncorp2;
  t=1793113224; x=1824649224;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=plx93BXIQUOSUsvJsCgjZtiZG1rNFPpPYeNwPZQpSek=;
  b=cKjNLsHz+qTwcAwjldWwdm4ADeuRTEwnpJD3KJfrkWmxQTAnW0qq+eS+
   AbAKsTq1/bPBBHxlQTQUUxScjMY8QdQgAyTdtqX3hm3Bb3feEqFqXdmYF
   IuFMQbMBWbxGw9Ha0Euqa6aN5MsGmJq1I2+hTWmSBPQ1b4TxT/0TNuZ8i
   O/8T3pggu/jrWGsXiN8HBSVhuRV4vg3EGwVH8x49A0E4gKzgUmGIw9x0q
   VYOh60Q7T2JtkE6OvE7J4gxLcoCD5M/gRDd1pc7kK52gdWgxAqtL9Hv/L
   r67A1jYTPX3DhAtOolpk9065z99/Qilq9E4tiriWPlzyJIhqS1FEPG7ky
   w==;
X-CSE-ConnectionGUID: ItHuiPCkQKSeJuplJtYZkw==
X-CSE-MsgGUID: eak/GKDTTtOSAGPyGq8STg==
X-IronPort-AV: E=Sophos;i="6.27,181,1787011200"; 
   d="scan'208";a="32146695"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-013.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2026 15:00:20 +0000
Received: from EX19MTAUWC002.ant.amazon.com [205.251.233.111:31033]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.38.46:2525] with esmtp (Farcaster)
 id ef43fa70-f102-4124-a2a1-66e6ab51bbb5; Tue, 27 Oct 2026 15:00:20 +0000 (UTC)
X-Farcaster-Flow-ID: ef43fa70-f102-4124-a2a1-66e6ab51bbb5
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC002.ant.amazon.com (10.250.64.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Tue, 27 Oct 2026 15:00:19 +0000
Received: from dev-dsk-dipiets-1b-77b833da.eu-west-1.amazon.com
 (10.253.66.177) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56; Tue, 27 Oct 2026
 15:00:15 +0000
From: Salvatore Dipietro <dipiets@amazon.it>
To: <hannes@cmpxchg.org>
CC: <abuehaze@amazon.com>, <akpm@linux-foundation.org>, <alisaidi@amazon.com>,
	<blakgeof@amazon.com>, <brauner@kernel.org>, <brendan.jackman@linux.dev>,
	<david@redhat.com>, <dgc@kernel.org>, <dipietro.salvatore@gmail.com>,
	<dipiets@amazon.it>, <djwong@kernel.org>, <hch@infradead.org>, <hch@lst.de>,
	<linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>, <linux-xfs@vger.kernel.org>, <matt@readmodwrite.com>,
	<mhocko@suse.com>, <ritesh.list@gmail.com>, <rvvandan@amazon.com>,
	<stable@vger.kernel.org>, <surenb@google.com>, <vbabka@kernel.org>,
	<willy@infradead.org>, <ziy@nvidia.com>
Subject: Re: [PATCH 1/2] mm: page_alloc: do not give all non-blocking requests reserve access
Date: Tue, 27 Oct 2026 15:00:02 +0000
Message-ID: <20261027150002.318916-1-dipiets@amazon.it>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <arFBr22V60BMmVpl@cmpxchg.org>
References: <arFBr22V60BMmVpl@cmpxchg.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-ClientProxiedBy: EX19D031UWA002.ant.amazon.com (10.13.139.96) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 09ABFA0005
X-Stat-Signature: s5mote51gjd7dp9hrnfhua393uf5emdr
X-Rspam-User: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793113223-269710
X-HE-Meta: U2FsdGVkX195iMrqnRCrDMrZqlpbAFzsl7Xp8l9XJzRlO1+CplLNauDYUC72SIvbPreFMgi4u5k8qsuefNb8mefl8OJtEf13K4AJtKAd2eS3cPU5QmZhe1Xcx2pP+ZjF4aaIs9mFhzbOnkPjSuemdunVs5IRlgJ01dBq02srfzc82K6fUQNgc0CdijWeR4GmbbTTOxuH82CpQAdqlj8PpgoF1nONzKFdhcF/ppX8Mf+6Pexg0dDZA2NsftzGCsU5AaJdQgl3UE1MtuwR7qbL96v8Md1JfH5p5ofmz+b3ZnlOtCaGh0LjyJHkIryiqXTtXXEVpZd/d927PfvHECMSI4UwmXi4MIaMHGy1W5ftGVp3wYeTqggNU8avIc5jHlVxoZxC374NLLx87pYGSVag54k66AgivVbzKNGcITeZ/xuk9koJcSlwLvkGg0LoxBW2NeHem7tIpuYbjAQ88eREqHkQLX8CNbNhoA7qgpJZ6liEdGlG1Sl9Zj+VNeDMp8hR6Z4UJDAboZ63YwedHTBUKaufJt1Wsja+eoebIz1ITOj4kl5HXo5GAeNtQWt5zv37J1eh4Tjvyt4Lg4QubLyH+PSMQ9HcKY1TwLpC+ext6xu3SaDiesduPHl2V2/jPLF5BwtZ+chXUyU5HV2GBWJgkT63bCtMFWSi+m6YMYAcZ26w4e63e3LuVzLzdkyXFcfAdxzsHoj3ATG4XZqC44D7BeKRxxfKDQJft8+m6lx2AlaMuK6RrBQuHy6fUZE8GODAPhtwI4zDMxDQJo5kQ3B1QXcskmGAgaEDGByn9thJBlrxfcap3GHC5NVewoBM1CxamV+O8EHG09o5qgJWIGXraBiNPnR/EMAtbgIn+YJaMSFX5DXzAiN3JP6DyK3mrCCXdgscvbLwLLuFATmrA12F0rqsGzA1R8mZr97divK9fhlXIUL185FhiCEXhpC5OpAIR+KgYhX3bXNJqVF6bE8
 nv+VLCNV
 XhKwGrk3c6psNE93vhXurwqe/KWGO6fUzw/JMVAtNY++oMecevNBykiWB2xARKbQ7JOpQ0Q3nZpUp7FKDsSdTvuAqHGUQChYJLMVlRBqQNy3/g5zSNLCZp/2ixtTng6GS+u2CXa+u0r7HKdCOFmNDIJsvQ1+8K0Un2YMkfepPu0Vfn3j0f74ZRfk7hVmCRr3Bz1dk6aAXnhrsamfn8E2nPBWJ6dUcKGOT09gCX9jJZzxKhk36ieI6uvjZydaaAQqWzueDyw/IVmtb816TJodlETIrun+NzUKq0C6/KCO1qfFDW6vJgGZx8//byV1MbxBCbqT/ULIiWudDfCU3FogR2bNZyrYKGNEyDXp7Rkc7jKbQ/rftUXUyVG9RJ7LcALRmR52Aja0oY3gVYSzzi3g8cxSxfJTsSMCE99ClEaYNEzcbXQNtU43zDArF7ia3l+dJHcLi3rq7pVNzHKd95q7OeI2GG8vjNf843AKaP0cykjLCvMketXe8VNJIC6DXr/OwVh79MBrBaSez3jZQ5hIV0uIADJeS8r2kWDcIhn+jxgeqh3W73QBYQBZIgrhE8bJ9nnwWmpjW+QhpF6cPYy988qFWnYlMtqS19oOCErVZ0TPUo5AEEZx7ucSkWwvyIUG9DFe2+MXEK/KidgPjFgEWq5EVa/BUdjv6QdnB8J3IgwHJPIqoNJSwOF9xRhQhbulRJhEj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


Hi Johannes,

Vlastimil asked that v6 of my page_alloc patch [1] not go to mainline
before these two patches land, so Andrew parked v6 at the tail of
mm-unstable and dropped its Cc: stable until then.

Are you still planning to work on 1/2 and 2/2, and if so, do you have
a rough ETA? Or would you rather post them as a separate series as
they are? If anything is needed on my side to move them forward, I'm
happy to help.

For what it's worth, I ran both stacked under v6 on v7.3-rc1 and saw
no performance difference on my benchmark with or without them.

[1] https://lore.kernel.org/linux-mm/20261001082152.2879289-1-dipiets@amazon.it/


Thanks,
Salvatore





AMAZON DEVELOPMENT CENTER ITALY SRL, viale Monte Grappa 3/5, 20124 Milano, Italia, Registro delle Imprese di Milano Monza Brianza Lodi REA n. 2504859, Capitale Sociale: 10.000 EUR i.v., Cod. Fisc. e P.IVA 10100050961, Societa con Socio Unico




