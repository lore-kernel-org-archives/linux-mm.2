Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7CBE9C982D2
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 06:32:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4DA036B008A; Fri, 18 Sep 2026 02:32:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 48AF26B008C; Fri, 18 Sep 2026 02:32:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37AD06B0092; Fri, 18 Sep 2026 02:32:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1CB316B008A
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 02:32:28 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3DEC4A05CB
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 06:32:27 +0000 (UTC)
X-FDA: 85225913934.18.A584030
Received: from pdx-out-008.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-008.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.42.203.116])
	by imf26.hostedemail.com (Postfix) with ESMTP id DF95A140007
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 06:32:24 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=amazon.it header.s=amazoncorp2 header.b=qqUYGcGt;
	spf=pass (imf26.hostedemail.com: domain of "prvs=714e84a9a=dipiets@amazon.it" designates 52.42.203.116 as permitted sender) smtp.mailfrom="prvs=714e84a9a=dipiets@amazon.it";
	dmarc=pass (policy=quarantine) header.from=amazon.it
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789713145;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v1VBUuCGiCGHn6DMhi3GFEqygj/aAsvMykxntaLG+rE=;
	b=Um/Yi4wEFeJYmBFj/YEC1RpEvRshhxisAjbE4yFIShg2UAJHKyBWF3mvztaS5IH7ZPex/I
	5rIziEYz8ggHf6sYWCvblxxHIDXfp8jZAZQzFddeQKMq7+wT+pXGD/B6zW/ElcEZckLDDV
	zsFBNPlHH5eHdCeJuAfzHeDsP333sB8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789713145;
	b=pqHg2NN/9Y3S5f6EEtMTVWn/U1SntsPamZ6JkCBXqM92raZ5LZr7JBOniJTgRdOv3/CUjI
	6Fph9ZSJErwqBICqkqc8TGKYNUoNk6j2tXQS7K0wg5zHcYD430lZOxcB+QlIaUEEZeoZjn
	zMbS6P1T/x5BPC7MVXvMKd8q22VSI7Q=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=amazon.it header.s=amazoncorp2 header.b=qqUYGcGt;
	spf=pass (imf26.hostedemail.com: domain of "prvs=714e84a9a=dipiets@amazon.it" designates 52.42.203.116 as permitted sender) smtp.mailfrom="prvs=714e84a9a=dipiets@amazon.it";
	dmarc=pass (policy=quarantine) header.from=amazon.it
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.it; i=@amazon.it; q=dns/txt; s=amazoncorp2;
  t=1789713145; x=1821249145;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=v1VBUuCGiCGHn6DMhi3GFEqygj/aAsvMykxntaLG+rE=;
  b=qqUYGcGt3Tyiq7rOZjyj5GhwJ98lECW+zGBJp0FYtQZJ3iMVmkf51bxg
   Lwa//h7bp1N94BTTd3uVZtAsRyTYf0+j3yLTAjRItguWbHkivW25tFB+9
   yHMrR1WyHM0eCql71ibbFqcUEtP2NQVCBUAjZn4n9PHt3+eWf8NWkC6XH
   ArLBzcfFIIhwsMnra5/LVQ3iAxva5RjiFnoTlsyuwHCzOYojEeDtbLySK
   C3eZC41cvPJ+C1XHvQxEtYlL7vlmW092JGmDZUNaXzgO96CcdQklquC7F
   o8PQNIne+o/Xu+8gz7YDD4Unzdj06fu3rZFqyLJGsSf4Mgw7WNPbZGecw
   Q==;
X-CSE-ConnectionGUID: grg7F6DNQJqEHQap4KfNQg==
X-CSE-MsgGUID: Zvmx89DtROO9zU5quSqcRw==
X-IronPort-AV: E=Sophos;i="6.27,103,1787011200"; 
   d="scan'208";a="29037761"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-008.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2026 06:32:20 +0000
Received: from EX19MTAUWA001.ant.amazon.com [205.251.233.182:4831]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.35.200:2525] with esmtp (Farcaster)
 id d6faa5cd-2b7e-433d-abc2-14217cad7632; Fri, 18 Sep 2026 06:32:20 +0000 (UTC)
X-Farcaster-Flow-ID: d6faa5cd-2b7e-433d-abc2-14217cad7632
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA001.ant.amazon.com (10.250.64.218) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.46;
 Fri, 18 Sep 2026 06:32:19 +0000
Received: from dev-dsk-dipiets-1b-77b833da.eu-west-1.amazon.com
 (10.253.66.177) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.46; Fri, 18 Sep 2026
 06:32:15 +0000
From: Salvatore Dipietro <dipiets@amazon.it>
To: <hannes@cmpxchg.org>, <akpm@linux-foundation.org>
CC: <abuehaze@amazon.com>, <alisaidi@amazon.com>, <blakgeof@amazon.com>,
	<brauner@kernel.org>, <brendan.jackman@linux.dev>, <david@redhat.com>,
	<dgc@kernel.org>, <dipietro.salvatore@gmail.com>, <dipiets@amazon.it>,
	<djwong@kernel.org>, <hch@infradead.org>, <hch@lst.de>,
	<jackmanb@google.com>, <linux-fsdevel@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<linux-xfs@vger.kernel.org>, <mhocko@suse.com>, <ritesh.list@gmail.com>,
	<rvvandan@amazon.com>, <stable@vger.kernel.org>, <surenb@google.com>,
	<vbabka@kernel.org>, <vbabka@suse.cz>, <willy@infradead.org>,
	<ziy@nvidia.com>
Subject: Re: [PATCH v5] mm/page_alloc: avoid direct compaction for costly __GFP_NORETRY allocations
Date: Fri, 18 Sep 2026 06:32:03 +0000
Message-ID: <20260918063203.2802342-1-dipiets@amazon.it>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <aqlvnm8AKp5f_UhG@cmpxchg.org>
References: <aqlvnm8AKp5f_UhG@cmpxchg.org>
MIME-Version: 1.0
X-Originating-IP: [10.253.66.177]
X-ClientProxiedBy: EX19D038UWC002.ant.amazon.com (10.13.139.238) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: wczmhibfynbxe6kndxcsp4p7kdks338n
X-Rspamd-Queue-Id: DF95A140007
X-HE-Tag: 1789713144-564637
X-HE-Meta: U2FsdGVkX1/uZH1oWzOvGc7Bflw8+qjGOwT5Fp2oUAVJNAEkYs7sZboKngpOt/0yKTEiV19/H9ZotZWrjyoI8wVHUWsyrZGcLMKyWeUYJZWp+VyEUMFzTzlsepEFd5fXi31YrWQ1CRSqyRPBShhCs4d4rdByNKjW263GUKVJzqmH0KNtq59bvVita2S7Jwh8/vg+OlGaY1qRu0QNl0cDL/ZIqSPv2MLO2Df+sIEb7fe6bLbD7C3pXuz9PDiWFE/SNC65YE+jr6KaozhFmMafNuXW3vcvVDY8EFaIdr+gPsnIC0zV0KPjExnXbd76KMKPj7s4VFMHdtTBEuUid8+HUEfoq3u78l+j6WKXUUUe7XZv+UnDn0tYcf311+qc+ovVsKKbE7a+zeexw73rOZtHU0/Yl8LBP57rCDAVgHjHS8JJnUEMgJDqd4iayt9C0YPuQb/lVF3iLk7trQbkNQwyEVbCh0zL3vZ3Z5CirSTRvVnKz29dvsPn29AsRr4Yg++VMf1Mmj2uWD7H14GFWMBvtOClUOLKrvUpCyiPZRxe+eQNaHuGfUQKGnbgiCbD/vxgwtDjI/5wQHb8haj9EXS2ef09pfqKhVYI2Qs8q2Wqxz6tjgZ5yz7objqWE9ZgKrppg/7e5Ku4jm5tHpT4we3cvO7F06vFXaAHDyw6OVu88Y/XkywHDK+B5WjEUBlfFYEKwrQtRMpyNAmL2Ss/AnVQ/gkQw7ANHfCk3Mew06b1lXmfHg1zYM+JAiI4JSSXTwIsmsKyjjQ1Vk5THkQB//PBRevxgVyhbrghFrt5ashEbCMQLhT+wjwsX/qis20gngLfHOLdJA4sZvLYl0081jeIz5odnTi1c5+u58LVIrqmMxnQ7wtRCaviNxbH0kji6QMikvjRmDfIYUjYM4C1ji8NsrGH7ljt+5YUZuxNyC/aKn3b/IH+GTxGlApIMcJzWnBE7bhGzlkNiLJaQYvmRSN
 bfkbUhvf
 s4tbxQ4bc4R+Te6RJuFGOTZFH9ZGUzhHpmCjj798tyPyFx2sVf2gCk8Z33q6uclDrgPbKKMMcfGCqo+Fajw0iDU9DDuV4cX+1Yvt82evWAuXJceIRlD+MYF7TKbeCIE06nS9xu7r61q+Jua0GOcFoNnj4I4/DirqJBMMErzRY7zGP70TFEx2NVhaJqkGWzlDBzpp+lvT9kZP8fBNaym9IZftVTzf6C/s+Hz6l/lH24+yoi8rD3aEQN+BrGbaXd8rqolnINbDESePoPYIU90NA0TQ5o3YM7fHq+bfLh1nz0dJUENUvvB+5dtcEpkbgRidpPV+rv+hh1VoTftT1NC2vb8Osxo+9SM1eC/UyJ5aOJaA+e/zTlBE/c2vcrrU/zvvk9f1SfWvsOVzU+MoayVp72I+Fo0bQy+4WrXEzeWpQTXkrCxv4EdG89mcDh8aSNFI7aqsYc54OHSWkGXHZcqUfYu5iB/xJZ2Zs1GP8Fk1VeOO7UUhVpXo3QqkqauSqz5tUXaSlRDQCnnoMoZLXlI43eIyBbyMQzZcrZz60oqo+h8d6qaCF/kX77ksxxeQ3XjQKvfzBcSuw1coT0KEXnac1AmuOIX2ZQztXUWqA/nSOJfTT/w2lZ7xzhKiWeDB7O1msVDgL1ZjT+i4Rp2xN099dC9c0Bu6uSjq2bvHi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Tue, Sep 15, 2026 at 04:17:00PM +0000, Johannes Weiner wrote:
> It would be possible to remove the costly_order gate here and just
> bail on __GFP_NORETRY. But no strong feelings.

Will do, I'll drop the costly_order gate and bail on __GFP_NORETRY.

Andrew, since you dropped v5 and restored v4 in mm-unstable, I'll send a
v6 (v4 plus the above change) unless you'd rather have an incremental
patch on top of v4. Let me know if anything else is needed on my side.

Thanks,
Salvatore




AMAZON DEVELOPMENT CENTER ITALY SRL, viale Monte Grappa 3/5, 20124 Milano, Italia, Registro delle Imprese di Milano Monza Brianza Lodi REA n. 2504859, Capitale Sociale: 10.000 EUR i.v., Cod. Fisc. e P.IVA 10100050961, Societa con Socio Unico




