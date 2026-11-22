Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BA36606A338
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 15:45:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=djg9yD9K
Received: by kanga.kvack.org (Postfix)
	id 7F0216B05C1; Sun, 22 Nov 2026 10:45:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C8866B05C2; Sun, 22 Nov 2026 10:45:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7059F6B05C3; Sun, 22 Nov 2026 10:45:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4B8346B05C1
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 10:45:39 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B74801C4095
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 15:45:38 +0000 (UTC)
X-FDA: 85463179956.23.8F4DB1F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id F399F100002
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 15:45:36 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=djg9yD9K;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795362337;
	b=7EBDuKONRO4Wvdw5xrAYgbck00+6m3YFeb9TWDrwaYi66uguMQ8TdXpxiOC4vWHtCgsQay
	KC0Q2c+wLBUj0x7RQWN0pG1QBiir0aAp4qV6VOtGf/AdeaoKe9lb4npNTDHkrpUgxmpy38
	a4upVJ9ucDG5Vun9uQAFAdsoVlux9DI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795362337;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kprcO3EcHS5yezRWk5WPgNPWPyESEQitcOPrSumYn+s=;
	b=lu0MEQ1Ej8p5NUc2SjcfkALXL8MZaEOPgizabevNomUeHtIat6R5/TvWH3FTY1IKST+rhQ
	F8hZAeWe3Yz/dGa2XY0kZUjUuwpJ655F72z+rKK4utvpyOQM55zOvOR32XwCbUVDpWezxL
	07H0H5hHr+URv11RzBoBNLfeqggX7xQ=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=djg9yD9K;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 48F51450E1;
	Sun, 22 Nov 2026 15:45:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6F131F000D0;
	Sun, 22 Nov 2026 15:45:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795362336;
	bh=kprcO3EcHS5yezRWk5WPgNPWPyESEQitcOPrSumYn+s=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=djg9yD9KHZWm9IJUHvwxqlrfyvd0n3bS+F1AajcxM7sXzzuMBzIS/Ltl7pDrpLyeI
	 h9xS3hpFxroIMTLUxmUWZgp8QrwPr1cCHX6yY0vzBqL9RbwD5vCj+vED2mrHkz6cie
	 2qQImN4ea/RuTmKmuJdny8Wvsa6XpWwnmyANNFjdLcjZhAB9axX23DGml/e1Iz40hb
	 Eo+cYo6QT9q4n+t7t0sSqUzttIv8sdxekY28KFFhc6NdGK4TitkcrkrFxlrbaXM+z0
	 MnNW34rsWKejefcsY45mbhOB6fIAFqketvq0YIWeQn7pjE6H7g1Wehj64bZjImDPuJ
	 aI2fjGgnvAnLA==
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v3 07/11] mm/hugetlb: use common compound page
 initialization helper
From: Mike Rapoport <rppt@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Oscar Salvador <osalvador@suse.de>, 
 Mike Rapoport <rppt@kernel.org>, "Liam R . Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Michal Hocko <mhocko@suse.com>, 
 Muchun Song <muchun.song@linux.dev>, Li Zhe <lizhe.67@bytedance.com>, 
 Andrew Popple <apopple@nvidia.com>, Balbir Singh <balbirs@nvidia.com>, 
 Lorenzo Stoakes <ljs@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 James Houghton <jthoughton@google.com>, Lance Yang <lance.yang@linux.dev>, 
 Qi Zheng <qi.zheng@linux.dev>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org
In-Reply-To: <20261120100856.16929-8-songmuchun@bytedance.com>
References: <20261120100856.16929-1-songmuchun@bytedance.com>
 <20261120100856.16929-8-songmuchun@bytedance.com>
Date: Sun, 22 Nov 2026 17:45:01 +0200
Message-Id: <179536230138.3933282.12771618654272468300.b4-review@b4>
X-Mailer: b4 0.16.1-dev
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: F399F100002
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: n1as9dyrdznne8at4q37sqqjpm1sfbmr
X-Rspam-User:
X-HE-Tag: 1795362336-879164
X-HE-Meta: U2FsdGVkX1+3iQqQOxxUwE9qRMlIktJ4ZfGeiACiDaCsAclxpgJCAwaVxPiZI3lpsorsV5SHj1KrLqOJQ69VW40nnRGLj/R8sVBubasxe+tY/WFT26Q/o/JdXew522PhBEiGBTGUghEQ9gnYB2N2SnSGVRhfbLyjU11xKOqicgANSZ72E50FObx9PCIqe2MO3HWoczGg3w2niPGcAl+364epRU0d1/rRg2eWR87HQjn6IkQSerPvZY8SmeUsMR+RsM6kkTJ40pY3YomrNW8d/9+TGNVBWqwFgG5xrE7Ay+BDR4R7gQnQux6xWWgb4b6l6uAgV5sr80tgzKf5TXNLHFcVAQ70Kxz2/pfPBYRRgry7K8NvVQJY7/M40ReiUo+VGop75PPvLGQSuLMkxwJkugvoSJOFDfYMb8aD/uq+mUxznJnPBCL9Gmo0lww3yXG5A5Qr6uk4W+m3HNsXHcW5T5Lr+x/hlfQHdIEmKW0qzCWMncpwWOIJMjaQH4LWxkr9IJU1HJeHTMl9niQrKzdmrRvCGAg4UG212/Ejz5rIkUjIcN6t22broak7BwtdYQLJydHbwolrZOiuviEyM4J4ep1gS/zVjaH62Hjse7YFvDSRwek8P5V9LO3W66Y8mycDZUtDDjgZwL9aykGTLWRjakfj1xlo1nu7Krtqfi/JLzeCJGcnzsUa1lPQ8VBttnE+McG51vc9iC1//PtVQkJ8L6vO4iHT7sTJ6TTIIdxMu9sRrabIKL6q8E52eb4QxPGDj/5+UiyL5exVKx5q2hxlFs4BfpyxSSODk9vv4zACuWwuNK9yfEy/665tXSs18hQ0MzcYd0vIg330m7YRRv6H20mPNlWdaG4rc34/IPZk3cnYmmH/UrOfLumQ92M0XQVBYPCUWL8N6joamizM/EJazcxf4J2wEixakVZ8MRWmqBiBvqEPMzTeQsMnVLdYP2cRGf/UaosDoioHdcNooke
 QS8JVJ//
 TVauS70yOlffQovW6HCqVE0JN/mbALs8S3h0/Y06oXHg1A+pgIJH9z1mKJRW5AUt/PypG2/OMu1lj4WdbNF76uOu/sw9TKb1Gj67L4BBztWi4G84YMI5F8DoVWSdh6zPkd+B/tqMytvysMsEALP6eDixQmdfWFQqMu6kb9qBpnYfRa/8SXTga9VzZuv3xsG8Pm+dS0BG+zBDkxLU5DlPTJQ2BHakK6XHwKZMEx/DHYfkF/gM2qfV4Hr5FuPEBhnrWYDgOkpMdGQNZqAXsbQBVzHQZlOGZ5bWwhCTwSZWQyy8wjpOijJ0/Cfhff9ecRlo4+rYQMLFjvMU28Ao69W/ibg0B+fYXupUt1pNgBQNgWWfiRJYUcdtaM+ri1QpmGhkl73Xn/30zHdDPzx8/hvo7+uywxb2wKjWXnTGclQ10LLR2uFu33M3jJ3/DHLMOALU9A9RU1vcSFqlpK2v0r8XXNhjIiTGzhoXP47BfIKIGKnbzvds=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, 20 Nov 2026 18:08:52 +0800, Muchun Song <songmuchun@bytedance.com> wrote:
> Boot-time gigantic hugetlb folios currently use a separate path to
> initialize their compound struct pages.
> 
> Use memmap_init_compound_page() for these folios so that HugeTLB and
> ZONE_DEVICE share the common compound page initialization path. This
> removes the HugeTLB-specific implementation and improves initialization
> performance.
> 
> [...]

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

-- 
Sincerely yours,
Mike.


