Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1635C88E50
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 14:30:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A14F06B0099; Fri, 11 Sep 2026 10:30:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9EC996B009B; Fri, 11 Sep 2026 10:30:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 902216B009D; Fri, 11 Sep 2026 10:30:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6B3F56B0099
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 10:30:50 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 94807140235
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 14:30:49 +0000 (UTC)
X-FDA: 85201717818.24.C734BE6
Received: from pdx-out-004.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-004.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.246.77.92])
	by imf25.hostedemail.com (Postfix) with ESMTP id 3A21BA0005
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 14:30:47 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=amazon.it header.s=amazoncorp2 header.b=mIdKzYic;
	spf=pass (imf25.hostedemail.com: domain of "prvs=707ad833e=dipiets@amazon.it" designates 44.246.77.92 as permitted sender) smtp.mailfrom="prvs=707ad833e=dipiets@amazon.it";
	dmarc=pass (policy=quarantine) header.from=amazon.it
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789137047;
	b=tf2jtKG4EeAr7jELIQnJgVhDwuDfptR2UJx+CU0tQyys+PgO6TwLloCY+pl1cq0gzb8HfO
	/JTvq6cxKblX7g53Qo+a+wZbsIIbhslyE4kalpitiiROdWd3szRdXbcF2zGSWTLhxVTM8o
	tCbwJ6E8F4jibNtDYN7A7PR4rV9uGZ8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=amazon.it header.s=amazoncorp2 header.b=mIdKzYic;
	spf=pass (imf25.hostedemail.com: domain of "prvs=707ad833e=dipiets@amazon.it" designates 44.246.77.92 as permitted sender) smtp.mailfrom="prvs=707ad833e=dipiets@amazon.it";
	dmarc=pass (policy=quarantine) header.from=amazon.it
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789137047;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fhlXhMKwCgy0VW4p1/ceblcbln66SDQBBDi2Ot6Q7qg=;
	b=BuQlLTo+QIbbxFipe8D48vSHewcKYGsAHIDlHOzTAV0OdioXJk0PvFnpTYZMkdQW4njOfR
	xtVtORmVd+Y3EqTvomz6pJVkFPIPBWAHU7lXgF+hDD/ZyUv5mIRClwm7+mXxpzoyE/oBLS
	Omkk25JkSFeZDaOSvPKkNQwhVySxP6A=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.it; i=@amazon.it; q=dns/txt; s=amazoncorp2;
  t=1789137047; x=1820673047;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fhlXhMKwCgy0VW4p1/ceblcbln66SDQBBDi2Ot6Q7qg=;
  b=mIdKzYicSVYZg4Byu6EYlDIz9CHtHHfwIEBqbyCEBkSfZSP/w8dN7IyF
   F6Cdx2QHImSP6bTQ/V6NECVW+pEEfodtXcAMJlN2KgMZmpRZqV2twk1Q1
   tb4TqbzYB6/3btV3Vxe9novJHLn+SRbRhFGP09m5bcal3jzbgkP+OK3EO
   YkQd21pauNJgeBCtaDEFdYlDZGWV1Z0KAXDcLn/tEcwhRcTYYAzKnvC6y
   1l5BI4HE2SjdGj2wEaMdpvM37LW9melf7Du0gksHOwFyfI9KW0Ks4GWWm
   P/5sA5bUvA5elwA9h8F3lWtndFDTaUAwYau6BumSfscICg+4chBseQAc2
   g==;
X-CSE-ConnectionGUID: uhkva1SMRPiWJ6tkKRQojQ==
X-CSE-MsgGUID: Gj7DMLnZR6qpUKLfGvwZ2A==
X-IronPort-AV: E=Sophos;i="6.27,97,1787011200"; 
   d="scan'208";a="28425865"
Received: from ip-10-5-6-203.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.6.203])
  by internal-pdx-out-004.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2026 14:30:43 +0000
Received: from EX19MTAUWA002.ant.amazon.com [205.251.233.234:19142]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.62.198:2525] with esmtp (Farcaster)
 id 6cbbef2e-8b23-4af2-9c06-09ccb670a4ad; Fri, 11 Sep 2026 14:30:43 +0000 (UTC)
X-Farcaster-Flow-ID: 6cbbef2e-8b23-4af2-9c06-09ccb670a4ad
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.45;
 Fri, 11 Sep 2026 14:30:43 +0000
Received: from dev-dsk-dipiets-1b-77b833da.eu-west-1.amazon.com
 (10.253.66.177) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.46; Fri, 11 Sep 2026
 14:30:39 +0000
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
Date: Fri, 11 Sep 2026 14:30:25 +0000
Message-ID: <20260911143025.2332562-1-dipiets@amazon.it>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260910150056.499c6312198f1898acb68adb@linux-foundation.org>
References: <20260910150056.499c6312198f1898acb68adb@linux-foundation.org>
MIME-Version: 1.0
X-Originating-IP: [10.253.66.177]
X-ClientProxiedBy: EX19D032UWA002.ant.amazon.com (10.13.139.81) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3A21BA0005
X-Stat-Signature: nqz68yx4eay68zkqrn5rsff8a67xg5co
X-Rspam-User: 
X-HE-Tag: 1789137046-902056
X-HE-Meta: U2FsdGVkX18FaRtozpY1AqAbauE88ppEnO0aEFO2JEozxkXO3ZNR7ajYKNCs6AxdFMNWPFtTWgzOM3C9IQ2BTucLbAkWFceLZfzYEccZbbECLeJPH3Xr3i79Bm7xbtHRcZztwORXWpvBN7i/v/nSjIU63YIeg12EM5+rSXaR/vHEaKlICI90nCRXekPXRbhD4wWSjB2YclF+gpOC87mfDxC8iJ6Q/adp0fLCskGa0sKwNUJngUQfWSmtMAq9dRfM/3c0Sf4Ketbjs5wVYGQufvmwEgpAia+ui7NXtG4DLnRQ+JXH0byNK+1SbDW6u/Y/eg9jbvWIRS3qm3ZdKJYyONNRBcOgS2QchSltbwS7Ghj2kHjIl8veLC9IasUwNOJa/TZDhF91c2ofMKx5Tj8yYpdL9PCWUJOY2XGISHTmwwm4uG+ZTnNWC/wyfEODpTSPW/86lw2/3xy2oRtKLZ7ueUWiEjack9q/2AVMX/fvE6jIcZGQUvFf0008HA13zT/bD+LP66m9UXG2YKGFUWkP5zQ5khxD8hF/syICUh/t33CX/WrMYYcMPriqrgZmYF4eRA+X0FKU/TM5ZYmJnRAFFQ0wFyK4Yx22sT/G6qqlO+OYMUtKq+5clTVhiYqol/bBT+RBkZXJayjJD1wYjpAQ7zOhdezXU/V1nQcUm21FtzFW8Q5qHkbzU4ayNqvN2btxXoWkuZ6/QuM3BGz8gPDvfSFNL7n0tBXVhgmK9nHFvtQZ6WBUYqUrX1TUJ5mz8JQwBKgK8wmvo0+v98skKQYO0Hp0PYUvhCyMjOhGxtU9kTDHjVeeH6ts2Ofla6V+FfXDkYLaw3lYD9+F40A4wfirO51568wl8IaQ0cEm1BxKNtl3m6rPe+HMOhDlW3fZ1HR3mcUztzaA4icwnD5j5WHilvtoImXT82yYPg0DYJLQDOwpEJBdJSexXTS396Q6Rdqjl+ewE/VYhNAD4LiWywI
 DVa6mdFz
 IrnGWm5tl/tF4OfIbucKn33Bz/ABwNAucf8/j3Qt3rdxDtwsJ3n1Auks4RtRtzo+9XeN/K9OuxmT42malP18+OlwLXYvOqFfNpK3HfArzIy5s7oo7SBEBHVtH+EY92hvJCqciIdmnyPuJ10E0DV1EcmrP3ifVIgyJb81bYqj9x2Enbza8JJ5pa4cgFzjtIsyBmG84RreoTTinlRxVflvjvquKRMJyy4+reZ3nwB7xb35XtbbIesqbyp82B5SPkBCHCJpzvKpRpVOj7FmkMQXk/fF59PYH+ctHgZVdP/+XCBUr2uDO3hdzX1VJpPBe0idjKqEk7ZHTnnfRu+3FXhL0mO1k/f0NSeQMWNc9Q+S522UsuvAb9BY62ECLcU3mSUbsqMq/Clmba0Pybt6I54I5bu6Zs0En3DU399A2myiaZES4aj30bysatoL/cOgPd9N7Xb9ep0FsZPKZPxn2huMcSjcd34VWKzUyVoeHkkKhqhkAY+eI1mDy0O174ea14xFam93UZ85I3m7fQ230d+ii7eysyn0+F9BV7hW7dREi8TjZX6NQMR1qHv4Dre73ANlDxfdLME98gpqDAXM+g1dE/mqmtntg380YLtQ+TvYWcTzg7c/EmBDwh7dxJSosPKKv+4MOD8Du9iispX+Y4gyeT5jgndqkeSGtQz4foTF8ZY+6sGyXkVdQk9IPfmm38kfstQjxsJrdN0vLtRLJdtfpyfU5e3SJa2rDbig2P2E9TMSUVXYlHFuN1y3ubQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Thu, 10 Sep 2026 15:00:00 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

> Yes please, a v5 would be good.

posted v5 version in
https://lore.kernel.org/linux-mm/20260911142102.2294202-1-dipiets@amazon.it/T/#u

Thanks,
Salvatore



AMAZON DEVELOPMENT CENTER ITALY SRL, viale Monte Grappa 3/5, 20124 Milano, Italia, Registro delle Imprese di Milano Monza Brianza Lodi REA n. 2504859, Capitale Sociale: 10.000 EUR i.v., Cod. Fisc. e P.IVA 10100050961, Societa con Socio Unico




