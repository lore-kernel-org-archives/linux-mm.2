Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 525C2CEBF97
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 15:19:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 886A96B0028; Tue, 18 Nov 2025 10:18:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 85EB26B002F; Tue, 18 Nov 2025 10:18:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 79B4E6B0095; Tue, 18 Nov 2025 10:18:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6AD836B0028
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 10:18:59 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 097F113B366
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 15:18:59 +0000 (UTC)
X-FDA: 84124085598.06.F25E441
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf09.hostedemail.com (Postfix) with ESMTP id 531DC140018
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 15:18:57 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=bNO1aJeB;
	spf=none (imf09.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763479137;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MLsd4qAXxPWmEcZ//svKd319GCI2W0dgLquvbJUwSxQ=;
	b=PPhYyhD5Ssu9hAliIK4gcP2pd0zcbNOODYQJhHASzue3YosECEKCqQylwaHVw77en6h18Y
	7dIvVJ535pCs3CHQHgYiDdByFBb7D7hlM46GGCOQLdwXggFR+fr8Ykomijg4/kVcE5pR3v
	07yAfusoBO4EUF7hu0A5rFJFXzaqUmQ=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=bNO1aJeB;
	spf=none (imf09.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763479137; a=rsa-sha256;
	cv=none;
	b=fBJH16tpsEDbori6Iu77yByOujQL8eUseRPcQyxJ9wCj2yt5v1PkKd46MiczRF77qhbVVG
	uSmS/a3/6uBZD5g2PDJPKeqTbgyyy2DkHJLNQshStsV3C9KBkx5A7XR3uZgx4snGOWYMoD
	YWMJfjLA3WR0bySIyZMmNjfrYm/Fv8Q=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=MLsd4qAXxPWmEcZ//svKd319GCI2W0dgLquvbJUwSxQ=; b=bNO1aJeB7FzN24YGVojvkx4Skl
	VpJ5urZUM1I38LeqMrNeygkb5J4BRVJ+yKrfBv64R26y1qldwW2BYnsiCt79pWQHnA8sg+e2wvy5q
	rxx2r8aKOl63+ciDFmH8kto4N0QGRzAoOaXUwK52liB09KtLJfq386EHGEB5T6ZnZYjXg78bcCdEG
	XchVdDM8HF7pCz5NPzp+aqtSV6metWKBtl2fNU5FnIlqmKKxC70yWPjGoWdA//KdiRyanRK/Jbk9a
	DcPQe/sK28rUKLOgtWo10gjo56WsKrkb4akz14WqWkWC8ykzYE9t/GgofMoASvvG2lLm6t172YQlu
	vjRUzVFg==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vLNTm-0000000FeuB-1Mcb;
	Tue, 18 Nov 2025 15:18:50 +0000
Date: Tue, 18 Nov 2025 15:18:50 +0000
From: Matthew Wilcox <willy@infradead.org>
To: David Laight <david.laight.linux@gmail.com>
Cc: Sahil Chandna <chandna.sahil@gmail.com>, akpm@linux-foundation.org,
	david@redhat.com, lorenzo.stoakes@oracle.com, mhocko@suse.com,
	vbabka@suse.cz, rppt@kernel.org, surenb@google.com,
	hannes@cmpxchg.org, shakeel.butt@linux.dev,
	zhengqi.arch@bytedance.com, Liam.Howlett@oracle.com,
	weixugc@google.com, axelrasmussen@google.com, yuanchu@google.com,
	yosry.ahmed@linux.dev, nphamcs@gmail.com, chengming.zhou@linux.dev,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] mm/pagewalk: use min() macro instead of manual
 ternary
Message-ID: <aRyOWrARRlUCeEz6@casper.infradead.org>
References: <cover.1763227530.git.chandna.sahil@gmail.com>
 <ff24b3c573b766b187b55a38497fbad0a319b9f8.1763227530.git.chandna.sahil@gmail.com>
 <20251118104537.7ebf4422@pumpkin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251118104537.7ebf4422@pumpkin>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 531DC140018
X-Stat-Signature: utxfz3mcb8mpyccx3wfu1jyeo5i3ra56
X-Rspam-User: 
X-HE-Tag: 1763479137-253894
X-HE-Meta: U2FsdGVkX1/5rYXOzgJurb7uHx5cKUIxyglnh6b+Um2x4hGPWlX1pyyKEF5TPdpyxilqkcPa2rxYFpAZ54/OyfAKyRyQVgkVXevtyB88Yes3KtB6HVbT7M0qE1sFsHK/DgD+iJtp3/q96fQQGTliLGUoYpQBpn1yK+JcIo7npJB0LnvAv9yDtpb4M6nhtILd9MWaEC0NM5mulgAdo+cnwM2iwT3XZ9uGFkoDoo0bARz82qLHoApa/9SLVXPgu5OJpOLt9Cn86yVcqpHa/o8jn2F1lV29z+fmnKRLZmjsjMr5+FpTjsPMyNWquxTxQg2RQft67lF0idw4lOK7+kZ0lj1wxAAoprOJIZCszIx1DI8t5vet81281XOe3KwP/9XNvyItG03b1vqfos3+FsYXMFNxjNC8WQvh2fJxAxiC9k+pIioka6Ug8JkpaZUxw9tOHOrJXg/YZkNoLEMi49wivCHrcJ7z9wYQzgBgsvlTQ5GWJRCDwxRGEDQtOMU5ilCBM8qCqwiyAs55or5JJ4HpdIdlxoZmgiBQ0Tcn7c+WwTh+j04tm3wXYt107HUZAQnUEU3GLO13U1K6xJ9RxClZg1jur9tkBmtc46gb3IQX7Q7dGzkOXRfgJtZrfOj02NneE8oNJbH7hbgiFK1Rn8Dlb/FGaLgd4deAQwDXe25wrSGdOZS4u5LJDtHmKE2B9az0eP2pi9mChWCp22QMb9z7hEkXafVxkrQrfnMIKydQ+JqnievWRfCTxhHVRgHVtvTu7U2+5vrEPmXAm5jsWX80YYJH0aJuJcL2sL7xeeGc92uUtdDSqxBZQ/0VqVfQKonX3ODABcGqjL8JpsR/2wyh2IrpiU30EPV34Jl22G6QTsVxztnPGC20KM8C/WPf9BFDJUCioo7MCGQ413gHWi8b1Tyn1mu2ctpaEcMwJNhF3nI/XfV/YfeFw2rTdCXlZyJItAF2udZr6C+MmIzrESi
 qyQv4EKW
 V6mxKYBzILWAWiEkHNsyy5Tjh//idD6xQoCWp7lj0BVxlBrCzfVSkwP4nnOUDgvMktr9GcRdmr/j2I+S7NyEwBTSPhBD+8mt14fek3pXg7cL67gWwE75onXMSyjALjG22y/rNAQVIOMcuOKF52K8rHxw939n3cBz5aqP447y1fYjgFuhxAUYwOi5rA3PHwvfNh8j/u/JRHQMuNqrnidawyaiAN9KQ1+wSxzacUQxYefflmPEwK+ByxAK960xiNWMTjv3lepG1yUHAdnqtX2DL92IsL6rrkLfhnUQxFnX34hVyPZs2ByxDXjaWq+tl/hnAN1dN+nS1ZXM2JWYHwI9H+H/ilg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 18, 2025 at 10:45:37AM +0000, David Laight wrote:
> On Tue, 18 Nov 2025 11:38:49 +0530
> Sahil Chandna <chandna.sahil@gmail.com> wrote:
> > +++ b/mm/pagewalk.c
> > @@ -313,7 +313,7 @@ static unsigned long hugetlb_entry_end(struct hstate *h, unsigned long addr,
> >  				       unsigned long end)
> >  {
> >  	unsigned long boundary = (addr & huge_page_mask(h)) + huge_page_size(h);
> > -	return boundary < end ? boundary : end;
> > +	return min(boundary, end);
> 
> You can remove the temporary:
> 	return min((addr & huge_page_mask(h)) + huge_page_size(h), end);

You can, but I'm not sure that's better.  What would be better is:

	unsigned long boundary = (addr | ~huge_page_mask(h)) + 1;
	return min(boundary, end);

if you insist, we could do:

	return min((addr | ~huge_page_mask(h)) + 1, end);

