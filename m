Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 852BC606A31D
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 16:28:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BZrLKNCL
Received: by kanga.kvack.org (Postfix)
	id 9EEAB6B05B0; Wed, 28 Oct 2026 12:28:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 99F756B05B2; Wed, 28 Oct 2026 12:28:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B5916B05B4; Wed, 28 Oct 2026 12:28:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 698066B05B0
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 12:28:13 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 505DF140128
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 16:28:12 +0000 (UTC)
X-FDA: 85372567224.19.A976047
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id A0FA7140002
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 16:28:10 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BZrLKNCL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of kaloz@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kaloz@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793204890;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=weHQEUvevC22o/1CcsT9r9vuOkoHoFTUXMU102WBpQM=;
	b=loPEYvXCJE9z/W4oZAKATSU11Rs31AOR0EXSTazIHtrXofiUeATEcOhB/FftIjmeRNCykp
	i/ktGuIQ7ZpfKTw2BlyYQp4GVC8wr8k1km/8bMX9HNWCv3yYeKKZ8+2gJPZC/FXAP2Jt/E
	NIHHHuFaWC7CCTuVhEldFdFgV6lCRKs=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BZrLKNCL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of kaloz@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kaloz@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793204890;
	b=iOUISOnre0uhkCiWUYary+gj8h70TJ8YnEoFF13J5S163bVMR4AWMXHaTtTB6JxiW2laDD
	vNnminLDXHZD3BSYq9hROupPkips7+OnuxqkKjFkCQLKSYEglu0dkwpSANMktCoTVOORTX
	wmzXeREvKne9hg4po/uqeOURmYasJiw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 26A73600DA;
	Wed, 28 Oct 2026 16:28:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D7151F01828;
	Wed, 28 Oct 2026 16:28:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793204889;
	bh=weHQEUvevC22o/1CcsT9r9vuOkoHoFTUXMU102WBpQM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BZrLKNCL2RHaB1EVZDYOENe9cSd457C8UQPSaiWlb23MIV1EKRIgdEYyO+8CrwcWl
	 F2lL6lX73wzROZrJGCEX3cQIl61OxvFz+tcRb4ElS/iBIDLqk9vhu0H/y9TBdKYmLM
	 ohPuDlJuvc8ZWUnLuMBVjTd/WKZ7PD1giiXITQ0K/BVjAyKPxgCsi5MaDRmC5pWYiL
	 wlQRDVix/m2pWJ8e5o/p8HiSgYs5V9gl7G6kksjb4NX3p+ol5aFxZQVxHx+/b42hBJ
	 Rt2R6XA8HyeB4MTWROpTQZMIQdql927mNuCiM0BE58WAVQaR4/8h9Wwpq16JOXTCt4
	 8PuY9+nAdipFQ==
From: Imre Kaloz <kaloz@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andreas Larsson <andreas@gaisler.com>,
	"David S. Miller" <davem@davemloft.net>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	"Mike Rapoport (IBM)" <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	sparclinux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Magnus Lindholm <linmag7@gmail.com>
Subject: Re: [PATCH v3 4/4] mm: pass the number of PTEs to move_pte()
Date: Wed, 28 Oct 2026 17:26:50 +0100
Message-ID: <20261028162654.15694-1-kaloz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cc5c7066-b5cd-45df-b338-37944320da2f@kernel.org>
References: <cover.1792609488.git.kaloz@kernel.org> <2bc50d2a6829b49ee909e5bb943244859661a40b.1792609488.git.kaloz@kernel.org> <409079fe-ab52-4389-9fe0-d7246eb27bad@kernel.org> <20261027212610.6798-1-kaloz@kernel.org> <dfe06aef-540a-4450-88ba-300a460007b7@kernel.org> <20261028091631.8072-1-kaloz@kernel.org> <25f5cbed-9126-4870-a81e-65099155bc9d@kernel.org> <20261028101719.11918-1-kaloz@kernel.org> <4fba060e-c4f4-4d73-8efe-dbed0b5a7bc3@gaisler.com> <cc5c7066-b5cd-45df-b338-37944320da2f@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A0FA7140002
X-Stat-Signature: uqfqeggc5kqhk7gdw5gwrqtb93fpfrst
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793204890-886547
X-HE-Meta: U2FsdGVkX18HXYOjZrrwgEitDj3w7HxeW2HUi8fESz0jD2lF8WhvR9+ZhzCJx0li73frjE6T32yKGH/5QSrEOIg3Do/Fgza653X+UUU/pSJzvqwmFgFNxzIutmVt5QJ9Zga0X84/eA7+8dg1FKMBVl2aUEdkGRz98e7pVzpptPdimQXV6n9gj0dm66dFn4N9wQjYLdaPBwBvr7iYsV/8wHvoAb9Ni7LQvS4SS1RHUB9lBwe9XtaTye/qbP2ONkw61xhk1TzRn8IluZ+QrvAX3soywwdsR4p5nvgtFffyQOsfnqc655mJ/+4AmgkxQHShXm9dD/3uaqXpg2YGhZ65YoK2aJw2PHg7TnqlD3GWHgcSTFlIWLEoNpNsX9l44FwHtv4pwgdp5fiLKqT7r6NbZ9eTm1Ff8Q1TAUuJp9XM9s43fiLSa1LOSTb9tTa/xyEQKRRhM7WxvAkezufpubgTrCc7Acg6naiHF3E2EDTwKAgrZ9tqN83/jyXI417w0qh3ovzsS0Fv8j9reaOuN2WSi5N6UM1o7XESmYiopbrvpF0VQYW1AQkxrTnkvTn+uFgU/8uAt5xD9mcLNiPJpOwRjSwl50tAxXeuxf9IlMBtyo4mUhikWNX2fQJqt7Hsqht4McndTCoxt45NDD2aLCZWLmwhXic1+KhY44sDjovyZw9yWJ7S08EE1AFciBnd4nuC1CI4pMgmpjp3Z7qipboHGlGC1OsRNZZRue4JHex8/pHiR+fREummLMfOwieNu6hCFAFeV8BdEdPjzRjliZ+ZgPJkJJqleHkE8BWURTl/4mB/dXiM2tEEY1Xam38jljoBkbYkeS1MgifiWjr/2sSSExQS7FZNhNk4baEWVFAR8V1qBu6Th0kibvtcK2WW2AwFywjMkeu1IG7kZCdf2isCPqpsQjEpncWC8AHATisgb3oN/cUAEOPQHKavuNtJVbR/6sfnA8NEh1z+9vBT/Is
 f8xQG/EM
 GO0eV5LpQ309MjIpZKz9P/dLr2mwvvv0eN3n1Z864JJ0/8KpY8mzhj1pYM1uO42KgUXEAO/UwW4c1LK0G8BBfAyM7Fs4cAAr/Y+njn8WdQJtN0h6TYbOxpXEPG918blfIrwA0575FwtvTFGGyV//yVdh2x2rYsZOFpqBtmdhePAWB7ynxsgNlNlT3UI6IiYbQmPXa5o/PDXYuTSygeZ70LItkBaum9eGcg5MOqsFsZ7rIS1ub2CDBsDb14rHZKXBeVJnV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Andreas, David,

On 10/28/26 14:59, David Hildenbrand (Arm) wrote:
> On 10/28/26 14:57, Andreas Larsson wrote:
>> I'm open to a solution like that, but it'll have to wait for the next
>> round as we are far too far into the merge window. Patch 3 stands on its
>> own legs as a bugfix in the current context. So send it as a separate
>> patch.
>
> Fully agreed.

Makes sense, no rush. I'll drop 4/4 and send the move_pte() removal as
a standalone patch once -rc1 is out.


Best,
Imre

