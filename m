Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52992EB3622
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 17:37:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B11EF6B0005; Mon,  2 Mar 2026 12:37:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A91E06B0089; Mon,  2 Mar 2026 12:37:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9ABA76B008A; Mon,  2 Mar 2026 12:37:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 87BD86B0005
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 12:37:33 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 57246139F1E
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 17:37:33 +0000 (UTC)
X-FDA: 84501829986.24.0BDF39C
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf22.hostedemail.com (Postfix) with ESMTP id 1D66BC0009
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 17:37:30 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=ehTo4NjD;
	spf=none (imf22.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772473051;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HBZU7lDrqfiSFQCOqZP8QIuscOzDLO1xfpjrl0wUxfI=;
	b=B46mAhqIBU2602yiuWGRR4ysKsRq5WISldZwgipDtKeWUka1cItPJhNRfMo5hf6vHkT7ie
	nKKq9oWJPUD0/mt+4gvAaDCA8bgpGWYZ+2AQATXwcbFcLiONOLo6AeI4pb86Fog9jCVbH1
	D4XYD2Va/cAKziEgRjvD6eUc6yMm544=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772473051; a=rsa-sha256;
	cv=none;
	b=5uBj+pVTsaiz4k3iQP2EK/ba/whLFmPqSB6oeSFDgsRTdc3nskWT485xloL+joV+JvaFrG
	48l1kFHavuFY6VKDBoRUsjG4UrtseYFsSduP7dZWNtfLQucT+ozeWfq6y+QfMuP0cBjMy2
	qy6BZDyd+7W/GsuFjusOUx9poAhPuBk=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=ehTo4NjD;
	spf=none (imf22.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=HBZU7lDrqfiSFQCOqZP8QIuscOzDLO1xfpjrl0wUxfI=; b=ehTo4NjDnDbSNIxrlRcltHgLiK
	ZFXRHXew8As8wOR37BRxXGVN6MNhYqSj036P4OQs0tY6JLOKITQJ88+z8sdEsQcWgwNIbN0fZVtwv
	7Ms57LIVncTKXYIGWSVZpxXDRqx//BZsbVounzAl9KGiWVD8c+3+GNEhHQR4jpQ2OJewH48yL2PDS
	581FS0SqPSNntr8+8yPPW8Jnk5q0RX852O3bKuvptQu2PuqyInVMRO8pGBOUx//Rjas5xux+u67UY
	pLqcqTYZlbLIbxuG2Fe5wcgnm/zioxUglEBT+zfUPnQ93XE5/4Vql0lOjI2Rq12DOwfx7kcG60GEe
	v+klc6kg==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vx7Cu-00000009qOO-0PEU;
	Mon, 02 Mar 2026 17:37:24 +0000
Date: Mon, 2 Mar 2026 17:37:23 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: Tal Zussman <tz2294@columbia.edu>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Jens Axboe <axboe@kernel.dk>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org
Subject: Re: [PATCH RFC v3 1/2] filemap: defer dropbehind invalidation from
 IRQ context
Message-ID: <aaXK0_HqEnU5SK61@casper.infradead.org>
References: <20260227-blk-dontcache-v3-0-cd309ccd5868@columbia.edu>
 <20260227-blk-dontcache-v3-1-cd309ccd5868@columbia.edu>
 <wen63cjbk3k54mjzgw7zftsuze6bzxmdk5u5wdjabzdiqg645k@67666k5lrevh>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <wen63cjbk3k54mjzgw7zftsuze6bzxmdk5u5wdjabzdiqg645k@67666k5lrevh>
X-Rspam-User: 
X-Stat-Signature: 331ydxqxzpe54tkhz6jb1thqcdo46x1q
X-Rspamd-Queue-Id: 1D66BC0009
X-Rspamd-Server: rspam03
X-HE-Tag: 1772473050-171654
X-HE-Meta: U2FsdGVkX19zBBBykSVCLR+yNldBmyeOT/bv/UtVUh7eERETjBFGLKSMdC0Jw3msNzQ/tYT0xxaV3BSh7yVH2ukWG6g7hDrmSSRFKFKUy9kx1KAMdVZAtdTM/tGGjgPY1typovVna0vFhQv5tMTO1tuidAjBN2sbcIA2Tef6N/G+xoiC4sjL5BooUhpj28MwwaiohQLUbRidZOwwJQaBD7oDxKbarpISxThoxQ9Je4Sfhxj2KoXH5AmbvT27XTeaQ48YI5QPvTQu/IAeBPS83/rHVJn/U0xzSzc2192zZkqk3CHJbQCfJ3STUpzzKbbdoKgatpDxhWK/+gRMfKDgBj80cdL0jkj0icwNLP1tE/eGlKoDr97ayqsWaaMmKUYdhGYafWUh6gnh3paODEbYVCddsjphW9BzKX5Ng0AwtqRHFxhyf9I86rUIgYPp6a+Pdn+Ff3XJGmkZliD0By6/6c3ugHxUTBRV1ZT91Mgr5vd/+KBdAequqGEXULXYV4U/y/BWazOq8zP6m+nie6249DY8zuCggs9vnHXuQwmXcyRW97f3O1XWXKLFmYOgdQpP6Et7KafgW+4tVZGrztBxBtP90oBgt5kCZ424FnSj9DPY4dcXPwlG/1F6DOxh5VGF+UCdYAvjetAJZLnvqdLfFqN1vOSrevGie/DF0OLWP1tyMZjF/MlZjCdOo3Fkge5HXb0b8YsIn/oBeeRGpXum8UXDwv479+Tn6uAhIsxVELe7xoyQvFx31PLgcSV9ZVvRz/YTFOcOZpDu9nDw2X6VPuGo9F+l/tu3MVn3OwLW+GE+UyHpn8zA7CSDKjq2x8mJUMJ9XnYtxetPKd4WbSTAjFTpfyv5IzYCCOPMhbtxPtLp3G/VdKa3kCRYrgJYV0hmq297ISAo6CBqO3LDEfwsDYRTIjZKq3GePMjCcBDcU44cgVesDNVnVXbmazKVSTgGZa08y6uyrvq24bkMifn
 t+dtcpLf
 h628+dmYIyUF2XtiTTmIqvbcmsqWfGh37gv/cjrQmbUdrM0HJFvW+W1T3mYGrHveETitUb4JVCP5LzYCprJawFp+mFw+NcqQV+xrUPMBBLznGuvve/E4aLo5y6dibK3ehMVXKSNhNSJdRh9qdaZ9D8fUUtps+gpvIIJqaCR4RmWfjYmUqBpZ6AaEKFbb7BuvclIODd33ynmjhO8zc6U0bZr/0QtyyQ6/Qn1aSriiSZq0cFkHntFS0wK6LeMrAXoWFzSL5E32SrRyHK2nERq0a0UKM9EXOXetqKXeDM7Q2sTCWrcVpADFt8VdzlBqkrcJZtJB60SUU51JCIiE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 02, 2026 at 10:11:19AM +0100, Jan Kara wrote:
> Folio batches are relatively small (31 folios). With 4k folios it is very
> easy to overflow the batch with a single IO completion. Large folios will
> obviously make this less likely but I'm not sure reasonable working of
> dropbehind should be dependent on large folios... Not sure how to best
> address this though. We could use larger batches but that would mean using
> our own array of folios instead of folio_batch.

That's why I think we should allow the bio to be tagged as
"finish the bio in workqueue context",
https://lore.kernel.org/linux-fsdevel/aaC3LUFa1Jz2ahk3@casper.infradead.org/

Why remove the folios from one data structure, to put them into a
different data structure that they don't necessarily fit in, rather than
just postpone processing to workqueue context?

