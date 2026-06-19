Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43B9ACD4F26
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 17:46:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1DDEA6B0088; Fri, 19 Jun 2026 13:46:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B61F6B008A; Fri, 19 Jun 2026 13:46:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F2D66B008C; Fri, 19 Jun 2026 13:46:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D2CCB6B0088
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 13:46:14 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5E0981C2D16
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 17:46:14 +0000 (UTC)
X-FDA: 84897391068.25.6428A62
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf19.hostedemail.com (Postfix) with ESMTP id 371E71A000C
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 17:46:12 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=l+8i67WL;
	spf=pass (imf19.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781891172;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pZ0VaGBnxQ8weCfxrWdQENSWAlIhEKkOkvtxqoUh3/c=;
	b=TzJOTtgdtiwO8Dl98SpYtGFp59Fx29EeCDT1EkXJuvwu+fQARg8BA3D5mg4MgNB4CS5DiD
	GZcvbd5d/2z23trhMuJSpJkan9sOLtcgNHdqDeNdJ5l57ePg4jjwGAKI9F9+lPkn+ZcGTW
	VmpaHb1JK/ipvGUkbFrSN6WJMNtMUO4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781891172;
	b=cKcRSTo1mzNMX1A/ON/s7G6aypgDQANgewK9Pi4SZKLL49YC2sJapTrtdQn9poURvBThiC
	wyWMiIxDWZ9kCeHPYxmAARSTcZX5sV6PfRbvAPb44BHaqRNUUY7dLUXPdLDDs49oKu9AA5
	e4q46fe+746nXYxWwreuiviQ6wxOTYU=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=l+8i67WL;
	spf=pass (imf19.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=pZ0VaGBnxQ8weCfxrWdQENSWAlIhEKkOkvtxqoUh3/c=; b=l+8i67WLK+tGGnvHIBAB8ABVlD
	V4sYUV2GFjhQ9DH1/Y2zSBz2J9mOYvHbx6Lte7/VOfG5w2I3a5Z1dPc8J8HGpZHamai9P9rAFiril
	C7zg11k6Uf1Lx/W3dqvlZT1M20EMJUxeu3t35Djes6x/in+IdCHcqGSHtGI3jRNS4LMB0/+FvupVw
	XS6/YjfQ6ici6nTVE9BzistNWsKeG/UX7FIdr/QAGzZVf6y9tB1x9634uE7op25gphNkEs0E4ehBc
	D7FWCA8OFLvNOJDC+KeUWCHWe1RTPHjQzf5/JcP697J08ApglWEXKKHkWxBtlFOXTZiEJZfXvwPk8
	9esPMJrg==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wadI9-0000000GcN0-0E0O;
	Fri, 19 Jun 2026 17:46:09 +0000
Date: Fri, 19 Jun 2026 18:46:08 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>, Lorenzo Stoakes <ljs@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Frederick Mayle <fmayle@google.com>,
	Kalesh Singh <kaleshsingh@google.com>, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, David Hildenbrand <david@kernel.org>
Subject: Re: [PATCH mm-hotfixses] Revert "mm: limit filemap_fault readahead
 to VMA boundaries"
Message-ID: <ajWAYBXHJniJAO4u@casper.infradead.org>
References: <20260619112852.104213-1-ljs@kernel.org>
 <20260619093711.d0d37c9920b3a16394c356a6@linux-foundation.org>
 <ajVz1nhMn2JwucMY@casper.infradead.org>
 <ajV0TbwEyaKMzoa6@lucifer>
 <ajV49Fyogfa6aIjy@pedro-suse>
 <CAJuCfpGdxsPDbxOwQFdY+Xt7mZGFvoKWmed6FteTongvFgjgww@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJuCfpGdxsPDbxOwQFdY+Xt7mZGFvoKWmed6FteTongvFgjgww@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 371E71A000C
X-Stat-Signature: 3j9hqmx1qgqi7pjbntjsrnruh78fk9zz
X-HE-Tag: 1781891172-423677
X-HE-Meta: U2FsdGVkX1/AngU2qXFq2d277NF+76RQo+G/y50W5yU8LSLTCmwmiOTdGesnfQcG4ra5O+9nKaLpwehm8QeLwQ/M6sMaIeGLkkjOiCeLCv5/ZiXWlk2ohflM0EFFc3f+8r58ZdqlvJwVsuTzBka73KA+qVG8jXw0z4cQ0OYvFpph4kRk++hNkCOjLfYVq0xMFniPtrjisAlcG6HPmn2uGa42shMaBkXKQRl6ShVRBEtCg3KBHS9Zmnomfg+Lh8V5nPNnoTRxrZJrT9Q+GjWdxb5v5AEMOQQIWNKyjp//03Qi2LfGP4PGJUepsWaZQ/1L8fm/3Md8cKhe0m2q6ph3KBDuJOZD0QCsqo+8fhRvSVD1faEuCSPqKrxzCsjhE+6S+ZgrS+6qlLOfl9K6/cOO/MCZdXJbHGOLgP0QylNbrTJXN8fif/Yxql974tWC+8vAL1KvYszync9+c61fgfgGHRyfqruZhgRY6VvqiM/mae1u7cSWKWYbWgHfTPFqjpWI11C8jw1fXzkvRwu6JGDxC7Zk+sG+iFSUZU4YmqVdbEPgJw+g1hVCZJNfWXfxvzTC2F6mlJORlxUwCB0m10zSjPXRyGdsSNyfz8/bZ8o4s+XMb6wrYF1Y/vlf3Wms86zbvaiTtbhLktyDjnaoJyALZNkHB3g9E6NB8OCeVNO07VGIzv+JJab3m7NDcjnSVckTAFJ5b1NMQLML2oR/McJbAHX4UoqbymMxOQHoJx1WhQN73EeD9EVMOGxDf3HYPH8Hu9r8VBq4yIgQPRD23htMFUJ9FGAxYWyL6p0Nk2vX+3mVB6XzxKhZIkdYTyV5jAp07sk3EQC959hZsdU1mQBZkhtuVY6810fx7/msRWhuZm/SmPFONmyvygPlC4R0myfIdurqcGfhHrspkNXkS2ghBbSKcPlPKAEdB5AkhIekQ5J0rjLK06RBVaTzKB/x6ck+eiYb9M/6Ra092Zo+pIO
 xAPUvTQw
 P+RbOftMKGhiRGYYSr6RMkT10M2WxkdTjQBMdK/eWSUlXmUnF2J5DLEivvewuvKpyv0qvVbIIR/t5KI8gDE+dyfBVYmIt9UIjAhlSuh9MsBys4N98/eJwZrbb/U5ZJFK3XLsV9kqaHmxx8YjtmwrJ8lypa0LRpLOTNZpg6tk28SwEbbMsAd9wkjABiICvgpZWUgJP9zbyvuzSXrKpRfhNa/EW8kwwM/Q7042LUl2i4oS2jQJiEp9cs6XuMkptO9+wiDc67c0gNj8TTXdT1Eh0BRZtc6mdLgOTiOjZ4vfJw8jSq6HrSbGFi+Hmfc4+4YOu6iXF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 19, 2026 at 10:43:06AM -0700, Suren Baghdasaryan wrote:
> > Yeah, the mmap usage on SVT-AV1 is a little suspicious, but I guess the
> > pattern may come up time and time again for people doing chunked mmap
> > reads. I think we need to take a closer look at this change.
> 
> Frame-by-frame mmapping for a streaming workoad is quite questionable
> IMHO and I don't think we should be optimizing or encouraging such
> usage, but I understand the reasoning for the revert.

If userspace is properly tuned, it doesn't need automatic readahead
at all; it can disable it and issue manual readaheads.  The point of
automatic readahead is to cope with userspace which is doing stupid
things like calling read() for a single byte at a time.

Could it have better defaults?  Maybe!  It's worth a try.  But those
attempts need to have a very low bar for reversion when it turns out
they affect other workloads.

