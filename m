Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07C67D1953D
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 14:51:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 73AAC6B0092; Tue, 27 Jan 2026 09:51:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E4976B0093; Tue, 27 Jan 2026 09:51:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 612116B0098; Tue, 27 Jan 2026 09:51:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 52A1A6B0092
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 09:51:56 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0867956B7B
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 14:51:56 +0000 (UTC)
X-FDA: 84378033432.02.241ABAE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id EDC7D40006
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 14:51:53 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Qdcig6Dm;
	spf=pass (imf01.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769525514;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JnZIKhAlSNkv7FkbJ5fFeXrPtnhy5SM6pV1QxQ7BvXc=;
	b=PwtxxLIKyNpR5z8/UlE+M4v9lM9E2EJO6FulZcak9TKla5xDIpFKER73s0mQNv+PFXVxD7
	YiYCFZ3Yh6iBk8YMfVexZdX5W4EL6/AzYCYsz5RQTQU+49qwDtEMON8CigqqsbUR0zmNGN
	DIEPOb0rTx6kLTssUuxeyMghxdGQJmg=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Qdcig6Dm;
	spf=pass (imf01.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769525514; a=rsa-sha256;
	cv=none;
	b=pQLscflGI/NjwG86VDMDkPFOyN3qcfc3NFPCjfKMc1mCD6kenX22HOi0q5VQKtjgHV+zgE
	UYAAWaZigdbImVJVVrvjCFpzs6H1Yc7HQT4hsE51enYo0zUwlIoUmJcYvjLd7G3EwDES2W
	LstElkPYoyekrrkTeeZApQEgjxp8Mz8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A3EEB44514;
	Tue, 27 Jan 2026 14:51:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEE33C4AF0B;
	Tue, 27 Jan 2026 14:51:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769525512;
	bh=5QkDTL6egAnUB1nGC9oZeltVJm7ADFUMjzrh7J9CPm0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Qdcig6Dm2T7kkQUYhrTQEhj/vQIsZok6gZ5kAyNcIppTfVTZvUMEM6Odge7NHZ4AR
	 W6wDPaOjR/hXuuOw0oacWd+48Q7WkMoxQqvnpC7NF3Ik7P27KVq+rwUumfeo3HeNE6
	 F90zs7LTS6s1lD6jfm9g26Tvigbbci8t1++dKB+9aN7AMG3mU/EVcx+9k2MVfl53z7
	 EQ46/P7pXvhoPW3y/oQlQazC24wvOr5ua01xhT6ibuwTZfP6Y3Wcgt2stpz3SxxwyZ
	 Z+evKf+2aYpCcpxvnBrntdUQEj7/DwAWuqkfpzLg3NwtW5sbnCYEFltfCFNavHTW2s
	 OU6wj0460ZYuQ==
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfauth.phl.internal (Postfix) with ESMTP id DF9ECF4006A;
	Tue, 27 Jan 2026 09:51:50 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Tue, 27 Jan 2026 09:51:50 -0500
X-ME-Sender: <xms:BtF4aZX7ZGvL60aSOai63pDHfU-w0OOc0qiHKoFnwzE96cRkQXXFYA>
    <xme:BtF4aU8borUUIgTSMCu75bhRo807gqcrK3kDr3UTPHAmBRZsUR9jf4Xpol8LO_3xl
    XMbkQ57PvIDKE5TgOuI6AgWWjur1jN1Mv1C8EjK6IhPMhyyzRbfEr4>
X-ME-Received: <xmr:BtF4aeygE9YPhnLQCzWM7vpz9RMu5WOw_L9MKlQnmdlYG8tcBnb5XTo4cOh9Aw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdduiedtkeduucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvg
    hrnhepueeijeeiffekheeffffftdekleefleehhfefhfduheejhedvffeluedvudefgfek
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepkhhirh
    hilhhlodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieduudeivdeiheeh
    qddvkeeggeegjedvkedqkhgrsheppehkvghrnhgvlhdrohhrghesshhhuhhtvghmohhvrd
    hnrghmvgdpnhgspghrtghpthhtohepfeekpdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopehmuhgthhhunhdrshhonhhgsehlihhnuhigrdguvghvpdhrtghpthhtohepohhsrg
    hlvhgrughorhesshhushgvrdguvgdprhgtphhtthhopehrphhptheskhgvrhhnvghlrdho
    rhhgpdhrtghpthhtohepvhgsrggskhgrsehsuhhsvgdrtgiipdhrtghpthhtoheplhhorh
    gvnhiiohdrshhtohgrkhgvshesohhrrggtlhgvrdgtohhmpdhrtghpthhtohepiihihies
    nhhvihguihgrrdgtohhmpdhrtghpthhtohepsghhvgesrhgvughhrghtrdgtohhmpdhrtg
    hpthhtohepmhhhohgtkhhosehsuhhsvgdrtghomhdprhgtphhtthhopehhrghnnhgvshes
    tghmphigtghhghdrohhrgh
X-ME-Proxy: <xmx:BtF4aUHU6j0lgE0w0xbQ1DS3XW57Jy6NPAYThyEByjs8bgTEcO2Rkw>
    <xmx:BtF4afKwQ2c7u2-NxxXOBr6iK0-mP1Rt3CvZpGGFi405w2V2e31U-A>
    <xmx:BtF4af7sSGKl5Sl0uGoJTAIqslThNJxjOeixVhXomvAq2ELC5d-IvQ>
    <xmx:BtF4aXTmQuSjg9HPM5kKkE_iCu7gYHojZT0N4n6zqvH1qXEa24q8IQ>
    <xmx:BtF4aRCy3CmU27FBHhnA2ROT2GBD1KPdwnAL7q09pdyo5F-BQlznYvxT>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 27 Jan 2026 09:51:48 -0500 (EST)
Date: Tue, 27 Jan 2026 14:51:43 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>, 
	Vlastimil Babka <vbabka@suse.cz>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Zi Yan <ziy@nvidia.com>, Baoquan He <bhe@redhat.com>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, kernel-team@meta.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Matthew Wilcox <willy@infradead.org>, Usama Arif <usamaarif642@gmail.com>, 
	Frank van der Linden <fvdl@google.com>
Subject: Re: [PATCHv4 09/14] mm/hugetlb: Remove fake head pages
Message-ID: <aXjPf_fIWX74YVWD@thinkstation>
References: <20260121162253.2216580-1-kas@kernel.org>
 <20260121162253.2216580-10-kas@kernel.org>
 <ffe9811b-d7f8-4924-9ad6-96057a16b693@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ffe9811b-d7f8-4924-9ad6-96057a16b693@linux.dev>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: EDC7D40006
X-Stat-Signature: krhf55txmq5sgp6ka61xtmd4xincnasw
X-Rspam-User: 
X-HE-Tag: 1769525513-872833
X-HE-Meta: U2FsdGVkX1+MPQGdPST2PJmrqsQ2MvZANyQtnd94GXVG5nzr+BM2k2F+6sfcsQD09Bpf0WjCinpjfimlX54XR1q2r5Y63GXLVUYIemlc/JSAVxex8WYoIpxYs8+M+xb0+NxjHH09ZAOcVtec1uvBnC3gnCv1QiyzJxYkDihO8yRbCew6UYialjHPueCcDnNjSQHKCjX9M05avax9vkueRyx7KgFWfox33r4x1n2jnDrRTUUCd/Kwwky+nqPy2j+JCBJbEmmhdGQjXwPwmpkMfL9aEWXIbvVtj/e0A8xGXlxFkraCSV4LnPOqleh8uIxmM099Q7vXsK/WyCbwBF7I0UCWHTg+x1acs1RxXhVXLUISI3NvdJM/DUwWjwRCghM3giaDKwvRObGAAIFQhuXvbRpI+R8OQgfCkOOrMdMQ8I1OOYg+jLziODk5u3ParRuM5c4+ejbSytYSRXttnNow5Xh4KrqEXOAN4AdfOmtSq6ng+QHdl95rO7ceuhqfThBYaieYHpAHRAydBCrQxjXbcI5dLBTwBlBd9+kxivVzAEPkjPfaZ+eZxFYwiUBeYnd/AY3sMvbhwXNBPmCk/Ff2nMV6Mx9ZvyZiDUb6cwXpoO3F8BsN+cagZubIV6mcD8LaYF3aiW8IUXs4e2Mc87cOun+TbLdvPXhTJc0u8RRkVRRmY8tsAM/hpOCEj0ImkaKn8/grJ7EYuRxZdlNKDVCJvc8bAcWMz47Z09tvBFS7jZMKBeQfWOCG9WyRD0i2LAXOVOH4nxccvSMEha/RBx+nSoHEKN1HMtNOiuAk6n8AN8l5E6R3dxGZzs9QwbD2lEa3QvcuTSWL3m1F19FYDzKADpv9QgKa/qtkhpEsz9ytgALD4mTM7mRcXaoO0v+OVsDng0Fbqb7sI0RSKO366mY9Yv37yT8L+VWpFCYY5EtskPEocrTFEVEziEa1b1sTEkKAKN5uEeHyQh8+qmptWtJ
 v9l7IEgC
 2L3z8yq7C+ADdygiLXzzAt+wIGfOys5Ysw894mGAmEKg1PKOo5FIhwqo8qkFf6lenJuhtVz3lhtTWdXAGei8+b5NLBuvAvY1gTWN5a2OrJ1+8n6qmorZao6GSfl6Rg0YFkssHvOk2HwgY7i3X1cs8tQRGAjsfe6GiOYB8RrRouJ3K1IozCKwHznWEKAROtYMguUR0s/4mBZ5S2unuSwFY7b6XkazShf6NK87hQkEOBNvVATYPPYSb1EnaAh9cNTcdzC1B1vPRrgy6mjbfMN2qnoYswg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 22, 2026 at 03:00:03PM +0800, Muchun Song wrote:
> > +	if (pfn)
> > +		return pfn_to_page(pfn);
> > +
> > +	tail = alloc_pages_node(node, GFP_KERNEL | __GFP_ZERO, 0);
> > +	if (!tail)
> > +		return NULL;
> > +
> > +	p = page_to_virt(tail);
> > +	for (int i = 0; i < PAGE_SIZE / sizeof(struct page); i++)
> > +		prep_compound_tail(p + i, NULL, order);
> > +
> > +	spin_lock(&hugetlb_lock);
> 
> hugetlb_lock is considered a contended lock, better not to abuse it.
> cmpxchg() is enought in this case.

We hit the lock once per node (excluding races). Its contribution to the
lock contention is negligible. spin_lock() is easier to follow. I will
keep it.

Ack for the rest of your comments.


-- 
  Kiryl Shutsemau / Kirill A. Shutemov

