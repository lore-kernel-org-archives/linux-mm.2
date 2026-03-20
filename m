Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E01561093188
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 08:20:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 15EE86B036D; Fri, 20 Mar 2026 04:20:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1368A6B0371; Fri, 20 Mar 2026 04:20:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 073A86B0373; Fri, 20 Mar 2026 04:20:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id ECFA46B036D
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 04:20:42 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 987E61E15A
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 08:20:42 +0000 (UTC)
X-FDA: 84565745124.04.1CB3B94
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id EE135100010
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 08:20:40 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sVVKrriJ;
	spf=pass (imf05.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773994840;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DYaDBSA91g02WO7qT1pNGxsomyBFSH3HHgvfprOeOT4=;
	b=NU4/oFayuHK2V5q1VmICp1jWvg/cBbzvTwoohBNbtlipHOoqa8ydS/pGEA0k166pZ4+gX3
	1YOBGr2Di3pHT10xAqXJuNY+CqyAcah7t5kPdD5INI9YmUmX9B4se2S7iwVq5Gf24Jvv60
	0kmXoMZoyLeKfQQwbnwk9cz1FiaCG08=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sVVKrriJ;
	spf=pass (imf05.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773994840; a=rsa-sha256;
	cv=none;
	b=GWAGDEc+yvvgPeJs2wclgCfXPfdyIJx3faBHiGvP21h0gJ7i5ezNqMPQ0+WrMETHWKiBXj
	sYGefIpNWSPstMFM48x6rABEDaI3/aiJypx61l6FEIi3iWub4bFzlc0Ad0pocU6rUOC+ww
	UovZrL1mljmRkIBgU8vmpa5jnsrovZo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3ED2960121;
	Fri, 20 Mar 2026 08:20:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED99BC4CEF7;
	Fri, 20 Mar 2026 08:20:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773994839;
	bh=xmN3vJPx4psTV4lUdM11H+sjGA+/qbfQGglSkhWCFXU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=sVVKrriJ9G+ROdnhpqVTsRBG75244B0r8i51tEG/l/pJlDysqNkAqU7LjLcKf2byT
	 aYDHzFWdLLrPR3jbjHZH3WAHmAJRNLmYkD9ZUyYrLJztAEO8F/RDEBYNaE2xMty5rl
	 7J/FWkIPGaEpVL6Oh5/j6z7hs+7CHE7V6qYbM6sbkBIT9gwe88tN9DYXocjnDAXA5e
	 GVrExLH/HTgA5CvBh55NuxeDCbA226p16BzUHP6UdYhQ5NGe/mpNJ1XisI5aQyA93M
	 fWg/hh6sUyYnmRpcsxEWjcxWgaN1wvdFHASnNqpl5Vav3x4POTU9HjShh6yz1DGYJj
	 bZOQlqsEU4i5A==
Message-ID: <8cf1b799-c02c-466d-9212-0e12a99bfd8b@kernel.org>
Date: Fri, 20 Mar 2026 09:20:33 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/3] mm/page_alloc: Optimize free_contig_range()
Content-Language: en-US
To: "David Hildenbrand (Arm)" <david@kernel.org>, Zi Yan <ziy@nvidia.com>
Cc: Muhammad Usama Anjum <usama.anjum@arm.com>, Ryan.Roberts@arm.com,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Uladzislau Rezki <urezki@gmail.com>,
 Nick Terrell <terrelln@fb.com>, David Sterba <dsterba@suse.com>,
 "Vishal Moola (Oracle)" <vishal.moola@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, bpf@vger.kernel.org, david.hildenbrand@arm.com
References: <20260316113209.945853-1-usama.anjum@arm.com>
 <20260316113209.945853-2-usama.anjum@arm.com>
 <220e97f0-dc82-4f37-b833-7160aee46cea@suse.cz>
 <703BB8CD-23D9-4012-8333-366837D7E95A@nvidia.com>
 <fde63978-d632-4196-b032-4cc20041fd90@kernel.org>
 <2AE5B748-C57B-4BC1-BF9E-6299CCBF295B@nvidia.com>
 <3883abcd-426d-4211-ae76-b5601ee728de@kernel.org>
 <54364b65-ffeb-4d91-918a-c1e4b0c92816@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <54364b65-ffeb-4d91-918a-c1e4b0c92816@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: EE135100010
X-Stat-Signature: nj6czberwwpamykwjnf6nh4kgw49qnxs
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773994840-579733
X-HE-Meta: U2FsdGVkX1/gFyxEYs4VOMGCCf9DlNBOrSd2bKAvkSpXNMMOW5Fv+rVcLpfuUIEcQwu4YkNMJdgzR64L2my1ComxW8N+fQTtYYlvbTousX98KoyKF7t5dIdLvdKUJ+0bppm2i5BrsVfeBttuAT3DHHyUnjRY775MhfPtVREb+6haFgYhpVl14p/ADcKYd+0d60Cn+WKuxUSSyEFPgCCKItcA2D4u9qQlZ1Q0kZdbqStvZti3rpZNW6IyY25ChI/0mEgitmR0cn4F9q6tSY83OcqE0/mRsfP3P6uzQs/fYXlCCh35q1pNxIKNmH119VgXFB9U+a5gHEjK8FOpygnR5RPKzGNm0I/30qCB1ac6acG0R7XxuqxvFmgd3Kczy0KW7651yvKJdHTRq609A9Uqq9GRJf8VGpteNGM2Kz2XIQ/f5bteLs/q/qc/+Jx1mK6YaFYMA70gZKIbD/QRVoOsPd0hJWrW1kPHZUNYLniOeKRXGROAy6CWxnzSTiiNuPY9VlpZXavn1hcl7UfZotM6yfFbGDk2xoibORgVfcemVqoWA49fyH+Ihx7cAyxRjCjTWVM8UhEnFofCPwbHPM1bNyorfFYVUCmpHJB/aiOzat1Hetl20UhRcZE7Lan8Idhg4pnCL+qHOXJc9CRI43YhXy2x6iCHr3a0yAywWAyXLRahCF70hkuZM7MfluZxv69t0KLzTfwFCxXDSAxi3ezbTUVStBtc+Bp/boVmq5NzecBLGiEgwZuKOsD45wym46xIRevRTJGGbwX2g3LUfvuLA9Gau5/s3PObf8fXFJZZ/Z2cndjo8YE850HgBmW4mvlxa84AEz1HfF65i9zBPsH9BshXZTwJ+zRlwOyDH1a0qkCilMgDUWzjt4/SJY7WBIK+lsZvBmIPMkp/cXIU2GYTQbRIaEyVTGT6G6Mer1QuOp46ZH3GaKvveYrooxCv9BzIbzQRAZ8NmRkI6M+rFyI
 H+cJMrcK
 bvCy0nTlPYNzTQ9bgV9NVAgdMuTrpXED5sx3xYt/OqjqW+x4gRfddnkLgp3xxWkJ3ih0kFu2yBGBFSGKq24zke1lWRIhtWqf4UKKAwUdz38EcDW7KWfMPj7dGClkMHO9KQb/AUPzNEmJ2SrjCjIIvK6w1ERT6kQkfrBT9Ws84qUQoMl2PS5+sm6TmANng+KM5nlkKjMWk3YEcLLP2MzEZP/LgbEi7DZorjubiXQxg6IET5M22E3sxIDiTQ0KDMBrqA/XX6jC2KR+b9iEPPNC0L3IsUPLZCo+mHpbg8k2x/KptswWSPLxVzsv8zg1R2Bkp3GmAShXec73cFZ/7o/cyuEU/uKpVPz5YtQHvKdFheMMPpM09lweRXQPz3g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/19/26 23:07, David Hildenbrand (Arm) wrote:
>>> the allocation of non-compound order>0, like you suggested in 3, we basically
>> 
>> I suggested we'd take it away in the sense of not producing order>0 where
>> head is refcounted, tails are not, and it's not a compound page. I'd rather
>> have an API that applies split_page() before and returns it as order-0
>> refcounted pages, but not the intermediate order>0 non-compound anymore.
> 
> Are you talking about external API or internal API?

In this case of alloc+split, external, and that would make sense to me.

In case of freeing, the current free_pages(order>0) is also external and I
would prefer not to augment it for this free_contig_range() usecase.

> Regarding external interface: I think the crucial part is that an
> external interface (free_contig_range) should always get a range of
> individual order-0 pages: neither compound nor non-compound order > 0.

Ack.

> The individual order-0 pages can either be frozen or refcounted
> (depending on the interface).

Ack.

> Regarding internal interface: To me that implies that FPI_PREPARED will
> never ever have to do any kind of "subpage" (page) free_pages_prepare()
> checks. It must already have been performed on all order-0 pages.
> 
> So the TODO should indeed be dropped.

Agreed. But maybe I misunderstood Zi, so that's why I tried to add so much
detail about what I mean by what.

> I'm not sure I understood whether you think using the
> __free_frozen_pages() with order > 0 is okay, or whether we need a
> different (internal) interface.

I think this is fine. But I agree with you above that this assumes
FPI_PREPARED and will not have to deal with subpages.

