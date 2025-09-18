Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD63ACAC597
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 19:32:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F358D280038; Thu, 18 Sep 2025 15:32:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0C5B8E00F6; Thu, 18 Sep 2025 15:32:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E48FF280038; Thu, 18 Sep 2025 15:32:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D11C28E00F6
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 15:32:23 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6FE1113AD55
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 19:32:23 +0000 (UTC)
X-FDA: 83903367366.06.CDB6D22
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf02.hostedemail.com (Postfix) with ESMTP id 5E3F580009
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 19:32:21 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nI6DaFh5;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf02.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758223941; a=rsa-sha256;
	cv=none;
	b=OeoolOJg5tVu11RbxS52ZeWPGclsnRKXz78sCFoIB2zl6zSwqNKh5dGMKBT+WxrIf/GT54
	LcvIJjVppPiuuwWOFYLpwMGpciG1IJsQT1HAIigfHxPzylhD2L1cRn0rz1j8ZY6EWAvW8P
	h1FYdaEAsdtLMNvoMZzyPl1cI/dD6Go=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nI6DaFh5;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf02.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758223941;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CXdQmrJQp8IC2n0baB8wqlkTmG/JwI0rNF4jhtPL+io=;
	b=oy8ZPSUihlnjCG+NoCBjSjteg62ntcM/hWeHq3eMm7izxTJqE2nc5keFaEvp66+mZ+0cvr
	vR5TjNxHUllQnljVeKPNUFCM+aG13aEW21JC+m6eyTX8V+jRdRP4+LCvtU4TQjfd9Zoojq
	u8rhRNttOM2vlZxdUH/5+ToVSeIariI=
Date: Thu, 18 Sep 2025 12:32:12 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1758223938;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CXdQmrJQp8IC2n0baB8wqlkTmG/JwI0rNF4jhtPL+io=;
	b=nI6DaFh5nW0bhVzHmtlARyeIe5GrSY2iZ6oj/ufmKxoHD7Mq2JVzDQpggmDP/YWp4Xs9Bm
	KGBl3clV9PR674K9yNZSqbw9zySwUrwTaL3ir+sTz1jaAOBS5UOITVc2q1JQbC7GNnufqK
	PWKGHrK560kzS9YKDo6/ImEnasMNx24=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: kirill@shutemov.name
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@redhat.com>, Hugh Dickins <hughd@google.com>, 
	Matthew Wilcox <willy@infradead.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Rik van Riel <riel@surriel.com>, 
	Harry Yoo <harry.yoo@oracle.com>, Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Kiryl Shutsemau <kas@kernel.org>
Subject: Re: [PATCH 2/2] mm/rmap: Improve mlock tracking for large folios
Message-ID: <thknnu35aqusupqt5rin4vmach3vb3ukyyaowdegtww2mvmrom@zck5s5bzj4vx>
References: <20250918112157.410172-1-kirill@shutemov.name>
 <20250918112157.410172-3-kirill@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250918112157.410172-3-kirill@shutemov.name>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5E3F580009
X-Stat-Signature: ahtdpc5kda5x5dsf33nht7adc16g5tf6
X-Rspam-User: 
X-HE-Tag: 1758223941-748602
X-HE-Meta: U2FsdGVkX19jJlVXQ5uvNRxWByrr0worH3AuFj2NT6KN9R4ERjWos/1dhVl54z0OF6Zn4daVSTIl0gp+AewRTbQXNcjIlSLYXlKfWPhYpM7OJcw5fDNULsRBPrWcPNTPUQ12OdI5d2PHmCj5gZwgpKPtv6NnZdzVaBIhLqKhibsDaYyi4d70g5wVCUc3Bk2kceteLRcFS93/ZsWzpBGdzZKtFUnBtZhNer/RqWhqb6+0S4EvNpas/ibgMRvyCvqcRBh3XERGJm+trG0606OJS9shdNjGXU1IZcCgZjn98oeM1S5R7xuTz5Vna8c5UC2r7JxqH2ilGCtHZ+br55AqPx38g1UMltfv0boIuE6qRbrmvddavx6cqquFyt3eDpxrHKEUMYIHVshghDNCdHcai8Lx7ecMFqzzojzcI05TrENLsyhoqbkcjyMhOfn5J2KM7OYKuFnuXAbMgKZrPuVtdMTtY4Z8ms9NLNGkAETkHvJTEQEAP3UsKKJN7neI/P163n4hUaldzdoM5yZ1RsWFZ4UsHdI9xjl+hqcy7u7bXpuj4wIsGhKh6sAMOYrBnC0qr8O91fXS99lPj8G6cFu1Y1RcYO+dBT6+EGpghNv7zNqgw0Y1IBl9/Sx/Pr4dxnJVtG0cBAs7yWJ/roc9OThrgC3jdJFEu1qg+kMoGukXUW6cviB31znYkAJv4EODn/mKdT4zNSyQz8yvKc3qZtnj3IoHqLBVpODOyBtKaJmDV6j4Snbb9hvtoHx+oDOlf6Uw2QszjlsQHTbzwVQMwmisw/XBOqZfBkY5KXpcl5stgTt6o8HAuXOVn+Sc0bPH2WKsfUd31Wh2Vr27OqzM3ULAH8YEaCg1f+433dyi0umae0B0d1cWpzITCL+FJ3Vhbk+/KLogkGkVyak2W2SL0DCob+GIHrGpLrg2SR+AniIe+ppuWZeQUkrK9q8YrOGSyGilVvpUBS9g6EMu5iI9cnu
 faAdI4xm
 B/iD3q6vBUW1k5RbOgh9svDsAIViNTCFoGlFLDikX4QypbEHcPoNp/YUe2Ms55JHgPjo/pBx6ThJLRgbYNkjucULZ1cMFrj2oDR+adUXrVHguYUabrbq584RPQMKPnE5CYB/R7VDmBOWFOB7SbHuXQBYBf8DoxcyYSNURcuwU60oJegjrLgDjXPgCkYXVL51mHyWsH+rFirz/TtTPEPTaQlPjabgcI88HvD+QF9kdzQaalZVyjXZd5U5fYMII0DB9/RFJ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 18, 2025 at 12:21:57PM +0100, kirill@shutemov.name wrote:
> From: Kiryl Shutsemau <kas@kernel.org>
> 
> The kernel currently does not mlock large folios when adding them to
> rmap, stating that it is difficult to confirm that the folio is fully
> mapped and safe to mlock it. However, nowadays the caller passes a
> number of pages of the folio that are getting mapped, making it easy to
> check if the entire folio is mapped to the VMA.
> 
> mlock the folio on rmap if it is fully mapped to the VMA.
> 
> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

It would be interesting to state how this specific issue was causing
problems in our production particularly for workloads that were doing
load shedding based on mlock stats.

