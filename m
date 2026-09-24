Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73940C98318
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 18:53:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F05C6B00AB; Thu, 24 Sep 2026 14:53:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A0E16B00AC; Thu, 24 Sep 2026 14:53:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B7256B00AD; Thu, 24 Sep 2026 14:53:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4A0DC6B00AB
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 14:53:19 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CC196C0472
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 18:53:18 +0000 (UTC)
X-FDA: 85249553676.19.B9CF481
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf25.hostedemail.com (Postfix) with ESMTP id 09CC8A000B
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 18:53:15 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=MZrYCRc4;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf25.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790275997;
	b=YtBn+MtX35oCC6uwFehmtMKjExg+NOP7hBUn7wPi4QtpZIWrpjKaYl+hyca4ihN+e7n4RE
	h6+nCBIfTsUbZJ1nXNLOHI7b6KyvgV0GIRLWVUhr6tGWyqMddIoelRigTCOyr15WKNTAwz
	kpijq6qB955EdVedIP/BoIuVxMVl2/M=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=MZrYCRc4;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf25.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790275997;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EJILEH5+ka8tzKqUVnB7R8kbKSlDulJBwhuxcrxu3g4=;
	b=pRMkDDb3+XoUl9fuXkSZ5R3oyrzI5t9QGx7DmIemsdjrtVY9O+09w5SZ+HTcJwGonjCPpf
	xK2ghfifbHOG1G1ckBHc07+pT+wMsPRcLz4Ml1fxFG2Otbz6EsvqrFCqRL84/+U35nhlZs
	/Lido4oXEM5X6w74iMdSRIPJKC8n3RI=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=EJILEH5+ka8tzKqUVnB7R8kbKSlDulJBwhuxcrxu3g4=; b=MZrYCRc44NmK1/D5cDgxMbBZ4K
	rJDe3lulb3qEdJhh6cmUkzSfnNflMzceAXOU/MWh2zlmwuKX1XgaFF5xk3oIeLnVfLCM74lmDlsfk
	YmbqbuHqAxvU2bxlSN1tyAkTHlLLmco8Grc0/3TfuxSlJ1bqyINdyAVFtijDGoKwHge0OnkhzfRQH
	RYakcAgulkv9KQ+6b6h9thSYs4u+uNSnH+I2Z3Z/Dv01bW+rHvSc+y3QFCvDdncyADhvQi9Wjr6CY
	F5wyfFwGDVwecJR/yrr4c/tJaYhcKiSgROjBcz4WAHlCKWfmLwa1aX7GehFfbS164eK3vM344/XVC
	9Vx9wYCA==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x9oZB-00000000JXz-44fz;
	Thu, 24 Sep 2026 18:53:10 +0000
Date: Thu, 24 Sep 2026 19:53:09 +0100
From: Matthew Wilcox <willy@infradead.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Jane Chu <jane.chu@oracle.com>, linux-mm@kvack.org,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org,
	Christian Brauner <christian@brauner.io>,
	Jiaqi Yan <jiaqiyan@google.com>,
	"Gregory Price (Meta)" <gourry@gourry.net>
Subject: Re: [PATCH v9 08/15] hugetlb: Use the has_hwpoisoned flag
Message-ID: <arVxle46OHWjL7Sk@casper.infradead.org>
References: <20260805210557.1118966-1-willy@infradead.org>
 <20260805210557.1118966-9-willy@infradead.org>
 <a51a6236-8881-4479-8f04-39676e0e1f14@kernel.org>
 <an3uN4TAAZ2miXhe@casper.infradead.org>
 <7608c80e-645b-4d07-bba3-ef45ee36fba4@kernel.org>
 <arGidwZQrrWVPAoj@casper.infradead.org>
 <7a23511f-365f-436f-b934-6a520510409c@kernel.org>
 <arQkP2uEzog8ChN0@casper.infradead.org>
 <6121136c-de9d-4577-a30d-f00dbe244e5d@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6121136c-de9d-4577-a30d-f00dbe244e5d@kernel.org>
X-Rspamd-Server: rspam06
X-Stat-Signature: hixzoooq99cxepc31o4gzgqgx7uqahxf
X-Rspam-User: 
X-Rspamd-Queue-Id: 09CC8A000B
X-HE-Tag: 1790275995-95529
X-HE-Meta: U2FsdGVkX1/ls7X+vf1KfDt9bQdaWQ4IscUHD7Sa5q7vG5geEPF8biZebdqnj6NrMCi3UMow8Ka7At/z0LTBBdJAQL/cHVcnUxKWElSMtBnwMDH2p1hD0uEwSfk+EH2DPrw+LHdtcgJLWhwGcpdQ3aCIZOB0CSY053zJ6EYcGcbnA94tuxIBbGMtbw3BiN3zyySE9thuUyg31C9hbXCNfIz1y/sNpUpWDK/qdVO62co9Gnqzr+1BhsrlyclpRphZCZWp6wRWjY3nH2PsH8Pzit/ExsmBzvaqypEwdn2Gq0U6dQobfcYRpi1cjl4jRoYWYECV9FM2N4BpNSW8ShOPWy04EDaW7oWA5jMXfwBDVhkFKi4oqogaPSg3vV8z8fCxouAb9l9RREBsaf1Foe02qQdSVTVUkWVkND8eUxaAinHGhbMXh9x+ql3rR9EMv6cilx9Nqc7990t/0tj6jDxJhm+huxiY0xhhyjntBQrdjWQ/i2rs4qEx5+wLiJaGyfIdC9MDgtbofNT0qv+ttnYj3EoYGBZGH/f5yq5WYYqLB5NgR3tC7ONAwBFo+HC9jY8E1zctoAJ3KOX5Xlqq2oh7U8WQ8Nz1NLkpjHaAVdJht489tSvO32efsaqZlKa4tiJbuqDZq5SNl21J+QutA8WirQYSCq/l7QoSK30X2EHvZlB5NrpoA1r1ufDjfrin6ye+8l8PfzilqeEPMFmmHJQZLyf39pYYnB5cjonaZKXPxE+uWWgnpA42vKiMOQv6TeMKEKnmi2cwYVThByObkUtf73P7NzshSi7Mh6LpIxjTchljzLTcNcFyo1LZAPMfqxOTOFbRQKYAZ1Z3/ublZ3uo/UJ/p3XQ4gRadk9qriO71wU7TpvkXBf2bsSQedX9upeHGe9ZLCitcnCTW/15K2j7CD7sk5gecwsD7y/CqMIYf2hb1vBVlJUcRUylmyQ9LR34PQVWnmldAUQ7yaWi0ox
 FxGQiL6j
 jiBbzEen1PG6WDSPP3aFRa66f0qHGawabCA98FVDAY1OkIExIzODQBwCiTCi9nRPg3A6CiG2qJZN1byxNwONkTPKycT+h+lKtD7fjwjtXfA2KOEQk+54fcYqKE7Xv0xxCvMuLtkc5ixcACcD8/q1g77BrbPTVU+367w1Xfe2csTl1EbEWCGGxAOeAl4amBOFw9lq364hhAXjIS9D9Z948m5dllSUOsYIqUQ+Qb+f0EBtFxJLQMdbAxCpskisWcmMgbqprvpVq1AhEbjMc8u/LoGPH8kAqdVfcgUilmNd2fpX3jDDiKlEnELzgvHwjiLcA0aYD21HDbeF9YEDQoAWs5yEIsqEU7H867y5BShAwL8XOXfVwnvMEzmstCoWU7iepP+gSh6QDeR/y040=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 24, 2026 at 12:32:13PM +0200, David Hildenbrand (Arm) wrote:
> > Oh, no, it's awful and complicated.  We could strip out the two bugfixes
> > which are at the start of the series, but why would we want to do that?
> 
> Andrew usually wants us to separate bugfixes (especially stable ones) from
> other work. Unless we all agree that they are not urgent and can go in in
> the next cycle. I assume that's the case here.

I don't understand that preference, to be honest.  As long as they're
first in the patch series, they're easy to pick out and don't depend
on the other patches in the series.

> I am not convinced about the huge_poison thing though, that originally caught my
> attention.
> 
> So trying to understand the race we are trying to solve (that is independent of
> the original idea of the patch set), I realize that these races are only on some 
> slow paths we don't particularly care about for performance.

They are not hot paths, I agree, but they are user-triggerable paths.
So I'm not happy about the ability to spin up thousands of threads and
delay other accesses to hugetlb_lock indefinitely.


