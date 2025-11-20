Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38DA9CF9C56
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 17:00:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7DF716B0022; Thu, 20 Nov 2025 12:00:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 790576B008C; Thu, 20 Nov 2025 12:00:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 67E7F6B009F; Thu, 20 Nov 2025 12:00:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 57FF36B0022
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 12:00:18 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 22DB013A64B
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 17:00:18 +0000 (UTC)
X-FDA: 84131598516.21.BE7976E
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf01.hostedemail.com (Postfix) with ESMTP id 942FE40016
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 17:00:15 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Kx1m9Bcg;
	spf=none (imf01.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763658016;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=re2tiGZL7IZwaCp1/yGWEfyF4epuwIDXTzQ2HA1ACdI=;
	b=F+9SksARdy2CuZAjcVuGgkGgZsBh3YhgdMFOzKbZKFuY4gqncGhLghI3OnnekPxY0m61ub
	F6txBjvUZy3cP7eSpAyfwhJgkt6EDFAAzebGpBkSeOi9wiJUdKbLl43PKcvaQw2aC6/5XD
	AGmNkLwdwM0YG61NQCYVIDfHlgTIdWY=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Kx1m9Bcg;
	spf=none (imf01.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763658016; a=rsa-sha256;
	cv=none;
	b=PkU3vJbNE9Grjdi4+P7IdSoRyF0wV9DkWCpos8aDcWpfnoTwtgjGGLq9H8DJ9xOd5Yn/cp
	t7kJAyrNf9sDXoKZu/+L2knFiMJeI2+WCpumUQMxTsTNtNRQceeH+9tlr8WpxuM335Xo6+
	oroVgp3bK7jb8wt07hP0rGnsi5NmIWw=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=re2tiGZL7IZwaCp1/yGWEfyF4epuwIDXTzQ2HA1ACdI=; b=Kx1m9BcgcI0haXR+zGeSAWaIw9
	G0fPgYE3/vT6S94x5gDbWpNv9di7Oz6fLCKbHPUhUTEN5662TE8kzwSE2A+aRpkEXCFXXMHDKKbo3
	6WIsXxeKbgIwvJN93YZ6yV+NLX2cc+altMh+dmz5ZbvOEjHuDYYTKwPyvKQ/0Nocd1d02SjYt6P5L
	xpk0W8fKlUvLFB71q2xjiqXTxBbfAdGflCcv7A5adjSBE6PFDnYNRQg6SCBBdRnBdfmDyMm4nTt9B
	+q2Itwb7APatwg0U1FBtKNAZg36UO1tqyLl1oQlhYpmUd3T+rFRLfHDMcAMaTh81uI/s349eJi9jn
	PPccvL1g==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vM80l-00000001Vsl-0MTK;
	Thu, 20 Nov 2025 16:59:59 +0000
Date: Thu, 20 Nov 2025 16:59:58 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Hugh Dickins <hughd@google.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Rik van Riel <riel@surriel.com>,
	Harry Yoo <harry.yoo@oracle.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <david@fromorbit.com>, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	Kiryl Shutsemau <kas@kernel.org>, Chris Mason <clm@meta.com>
Subject: Re: [PATCH] mm/filemap: Fix logic around SIGBUS in
 filemap_map_pages()
Message-ID: <aR9JDud3PS-A_hcg@casper.infradead.org>
References: <20251120161411.859078-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251120161411.859078-1-kirill@shutemov.name>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 942FE40016
X-Stat-Signature: y4kgca69uqcre5opx57ocmom51bseg6n
X-Rspam-User: 
X-HE-Tag: 1763658015-587042
X-HE-Meta: U2FsdGVkX1/sOakiS7vFHDc1xE751MeYxQTgzl9P1viHPuHfWm2OeVwdDzUgF261iDHZjLPQO7+3Q/qZnvIIwZz/n484Bkbw0LNAj4vTW5JaBpBeeqomznRrdCNnBkGWfTV33ILStxOQSeBJOpiGi3lS/y8wWtJJdq4qh+tAQ+3mg4RXun5Lamgob5W02IyqSP76Qi8ZoHW02j373cuhivxOrx8WXbQzu7HjV3P+sYvGOd5lDZfqtGXWuF/TMgp2CD/lN0SyihpyaJq6eHSCgHFtYkkD46HmGYVNMGwqEN+w0x+KJalv0tQ6IveoQlX8Y9b2Bw1Mk1ENtOuHZxa7LfqqDJBIvytddvVuV3Myd0aoVSt+0Lemu3DRKpw6yfZAIMHDeV53nNSUphJyVFkAMx4lvzWnF0gSConwY0ygrgTzPo2jL1KRyIGRxsG/T16beiNz0pdk8e918FRBLdhH8426qdwQIRc8ixwQRfnetvBJjJ4XaMK6f9RueQLzWxbvTHFhP9XXzVfKRrVzW4lnuA196J26KUFxMrTPPLhIwHL46c3Tjxd9pR56idvFKSUa6FO9u2w9eZ73bh+JM6ILJctQAvCSeNSu6iGAxU66xi6VoGj+L4ktqlQDfsHWXPpNGz4KVgrwOKoFSSDQJPKwcUkbXHViLt+9ciltRQs/naL18xCeQIXN94cdgy7I+Fbi47aiCa4e5RyX7tQ/nFRQoZSpKOH5+EaGwaLOZASemhPW9rwJn5Q+J0uNrcpnT7wlpJId+va7ov2hYy+QQdIQG09BNg4KTUmRs7PJ+DNxlBBI482c7dZ0u23GhHqM60GdP84ZLVo8UuByI0BzkNoSAB5UFXNbPc6PkT6f3t+3LvndiNNBzy+fN8lqVSRZaNeoSjZNYQCybS6AFB/CeRtVYUF120+b4DlLc6slPt4LEMblWgjRoVfpHQGtvgHFhcKyb7cBPvNrDDF7ewy5Q4z
 HMWu0rFO
 uZiruRuzaxEMa6ymRh/GJ/P2uFWO0xZfnMibXkP+uN3nAChjtD6fj3TBNLkw2w7W/H9H/UBDKbLDmvDKnQw9EjTzAaxSpoiKKbPwaj9VirMv+OL2JFByeEJxq2K5Vlz7xibXaMj/kboIfUcAcMfJr80f336iIU/wFFRG8EeRZfQMIUh7VJ63XspkA25L/Iw4xbAw25MrtT+LqMrCZljNKkElBI/0zzyvMNH0fHHg9bC8X2CiI5/4TrAJWZyz2BBcZAXvYCrIdfDoT4DYcrJjbvfUUfBLy0VyxO4EEnr41LWRC4PP3VqBVuX7QhsXA9Q9BOI+gta2rzZRIeJPY7rlp3jyi0Z5x6jHU2TTXrz1kpqiFUSRC+K2J8CKn8b6lCV5sk+K3VfOTStYwXxg7OhmL2EHUdUFdiyXkbInLIWXmOx2ga0BzK+ugIYT7Mg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 20, 2025 at 04:14:11PM +0000, Kiryl Shutsemau wrote:
> Chris noticed that filemap_map_pages() calculates can_map_large only
> once for the first page in the fault around range. The value is not
> valid for the following pages in the range and must be recalculated.
> 
> Instead of recalculating can_map_large on each iteration, pass down
> file_end to filemap_map_folio_range() and let it make the decision on
> what can be mapped.
> 
> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> Reported-by: Chris Mason <clm@meta.com>
> Fixes: 74207de2ba10 ("mm/memory: do not populate page table entries beyond i_size")h

Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>

