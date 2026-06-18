Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58918CD98E4
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 03:17:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CCFC06B0088; Wed, 17 Jun 2026 23:17:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C80D86B008A; Wed, 17 Jun 2026 23:17:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B96456B008C; Wed, 17 Jun 2026 23:17:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8D25B6B0088
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 23:17:40 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F06601A0402
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 03:17:39 +0000 (UTC)
X-FDA: 84891573438.03.5BCE9AE
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf17.hostedemail.com (Postfix) with ESMTP id D910240002
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 03:17:37 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=pSTOXZBP;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf17.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781752658;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZMErdMn4fM5ebZdMPM1RRaXcObZkMc91TS7uIUs86cY=;
	b=i0II5BcNbcGdJYskOeHIZZ9cJ/WdAYbFXIw5ExVLhByat3hYlall2XJLonc/UJh5zq1qbn
	mMM2MUzo91UsVxLLMTVxE6MaMvBW4nLqG7tMqdZo0xAes4X2tRiCNC8Up1oIVREOpLGG1Y
	Rryq4jUbGNZXZK0Vru756oQFjbYSTa0=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=pSTOXZBP;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf17.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781752658;
	b=5/EDrVaHadXuAExJ7Yht/tmMq+HLwOzRlNHGxizM5cHyKaYPsXAEHA5D+zkY+reI/qWcWQ
	uQvBVtuYrv19363aJVYTYpeBFqdd8sYi1HeTg89Z3/JxnqygLfF2L088G7Sy7NcHenvzM5
	1E5SjPgJd3UU5EwFjavXiSFCPlKCSiE=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ZMErdMn4fM5ebZdMPM1RRaXcObZkMc91TS7uIUs86cY=; b=pSTOXZBPNn47f5sa0hrU86rnZZ
	dhO0ExGNZNCcgFdmDVYq1xaXOcGno63AyHMYTRIN3XEMcbZwfgYmE9SUBZgi+Q/yljvqAqe+PMU9X
	+1amRFqyojYA6GUe1unKeDjAZSXt3sfLs510o66SCVYAMdZ8IAqGY39lqSaqOOVnN2qvw+xTe3cs6
	5bhdQ2TNoKKIgV+hLGWccWF9JMfr5As7bCjSDmOiFb9xq/6TLOjNEFfv9sPiFGSxonUrLMTwvofqm
	5Yw9dHPf3IZZhPOvEAa0pEgALjLo0+FiWvJn3hXYC4Ne07j5KZaOvMRP5qWNz10EV5yBm9MjbU47X
	EjjmDasA==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wa3Fl-0000000DjIP-2orJ;
	Thu, 18 Jun 2026 03:17:17 +0000
Date: Thu, 18 Jun 2026 04:17:17 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Jane Chu <jane.chu@oracle.com>
Cc: akpm@linux-foundation.org, jack@suse.cz, viro@zeniv.linux.org.uk,
	brauner@kernel.org, muchun.song@linux.dev, osalvador@suse.de,
	david@kernel.org, hughd@google.com, baolin.wang@linux.alibaba.com,
	linmiaohe@huawei.com, nao.horiguchi@gmail.com, lorenzo@kernel.org,
	rppt@kernel.org, peterx@redhat.com, corbet@lwn.net,
	linux-doc@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v2 06/11] hugetlb: make hugetlb_fault_mutex_hash() to
 take PAGE_SIZE index
Message-ID: <ajNjPblkO9Ka_4FT@casper.infradead.org>
References: <20260617172534.1740152-1-jane.chu@oracle.com>
 <20260617172534.1740152-7-jane.chu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260617172534.1740152-7-jane.chu@oracle.com>
X-Rspamd-Queue-Id: D910240002
X-Rspam-User: 
X-Stat-Signature: sbgtx9d18845agqau3pnu16zdqwutzpf
X-Rspamd-Server: rspam09
X-HE-Tag: 1781752657-409172
X-HE-Meta: U2FsdGVkX1/ASUrBqZ6SbB/z7mcBFctbV4AILlluO/Wn22N1Bvv02RmnzxKLYDL96ebAJYxAtbjYPa3SVwZw9uMVfoEV85dbRhbR92zAbHhITT9J30t3bDMLDi3j//r5YrbLMp/zXV1jfNhG+ioxDap7HPpy7CqvBNlYdwgm/vLsKNZA4WxTuYgWS5m3Cl70RgRVYg8K8BbxUfTqtj1mOlt670cko9Jv7K5ubpNWuHJjIYSY0wP7NFBFK8Ng3UTcYoLLazCwWNJizWZrEf7YJ5zJYhbnC7H2pVwNWHRD45XZPZ15VSZz9Ue6i7gnX7NauIRwIOgpQ3DKIPaEO4Dk9y+ZPTo1vy7miAeqdFIa65NvtLPte/UdpLsjRekJroq0moyqEqDoY/GqxEN6t1A8vUBqZs3QBiqvKHqDMYKPhqV9ESP0C5BO1dOwxDbV5j8KC/KW4DwYnJcJ5rNwVxgtZl7n3mshockVof4eCls39hCXHKgaFg51aw/aZCyk/y8yMaEa0w1pc92h4WXG+voVC/2+59Q7S2F09N1vUgRhQJQVj9P/tudqu/y1QTzqWIAVH0M8dH8jmwBDcrxjGuNw9hkfap5u1BmQDFZPm5yz/s1aHiUl9+VxzOvPVlqSXxBSqPzXUcW7EXdGVFP0VAHaPZ5Krj92c3835t3hsLxkwNT9er32PDxIqLiBB+w2w32WofeYoa7v+njasn1p2N4+CHbOIn3sQlIwin+SyOAiWJVjR8ghR6VKghafUTTsVF6oeTAXlvjnHtNtk8xzTNjB1KseBwJ4epQ9mumJEbq00KKVPEMOPvqH84UD7D9ME+YcCWI++HnDCt3AV4GtBjyC/aILXk0yadKZ8WMCK3lW491iP4qEr6tbbVLQ/sfcfAKgfYIES9Fo2NnN3kmbT45y6cpl0IyX1yekWNEQqoN7a5NllDQ47fl7pIcl5TeoDWP4cITEiZvoiSsDjPaAg3J
 YlvHvTEz
 O1fT36MR/GDWt9UMERXOrr9IRpOxabZ3HO0wLsX3lw9F/QOHETt2Wj/Twxqiq0d4dkfVu2t2o3LTX9irdCTDKva1GT7SKmf6SBJL6gcgrUpN6TxcL/xKawDgRxqQ3/1hmem7V8MJ+RXA0JYeJur8sd9D5WRiTPrTWhr4HETyDWgpJvp8sDSLDZHHoXsNDz/eirNI9woZG+ogkrI4C9VDyF/dGqnG3dNU2Vb8UXeyZ/QPJufscpPeLBnDSwuTHYRjav56cVBavAwbo4mQMXQD2GJGjpJj/L6jZGOtV1PKChqsGo9fFjU4k0ZS1WSYdUh32vY6z3+bqXuuFW4s0eQrnVD1qxSf5TRB1QPz22S7SG2KSOTxisKeabV4hH7Uc+DjDKFastJUj8ZAm2+w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 17, 2026 at 11:25:27AM -0600, Jane Chu wrote:
> Make hugetlb_fault_mutex_hash() to take a PAGE_SIZE-based index.
> This makes the helper interface consistent with filemap_get_folio(),
> and linear_page_index(), while preserving the same lock selection for
> a given hugetlb file offset.

Oh, hah.

I don't know that there's a better way to do this than the way you've
done it.  Unless we can just remove the fault mutex hash and use the
invalidate_lock instead.

