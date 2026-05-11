Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6C79CD484A
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 14:45:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3883C6B0088; Mon, 11 May 2026 10:45:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 35F536B00A2; Mon, 11 May 2026 10:45:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 29C3E6B00B8; Mon, 11 May 2026 10:45:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1C79E6B0088
	for <linux-mm@kvack.org>; Mon, 11 May 2026 10:45:07 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A418B1C0153
	for <linux-mm@kvack.org>; Mon, 11 May 2026 14:45:06 +0000 (UTC)
X-FDA: 84755411412.14.4F27289
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf03.hostedemail.com (Postfix) with ESMTP id D89CC20005
	for <linux-mm@kvack.org>; Mon, 11 May 2026 14:45:04 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=Mps5e0bE;
	spf=pass (imf03.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778510705;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YzVPJqG/qdv32dfB2Pkj62g8vYaU78q3x/Fdun8yAf8=;
	b=vCDL63U4UTXbXeu8pcEGcT9mvD7H+w3hgti+G027DO3sdvmshK4tBizqJqWHWYWOfaTWRR
	O2p9mPV6wW1MGP1kuLrnSG1zJ1AaXm2WIboYk6kWa9/imCEVvNFDhzwBg4wqYWyIZXoXaI
	7ua2ppMcJWnPHyIgC+L7CoCnVugDElk=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=Mps5e0bE;
	spf=pass (imf03.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778510705; a=rsa-sha256;
	cv=none;
	b=Mh5Z5b3L4NBXIh7iUDwNCrfo2igxJdJthqBV3K58esKUT2mOwhPeLbpjjsmnGnuVcnUEgn
	re3Q9pYjeSTC8jbT2mHeXo/UiMna5x1av/ODlODAE7XMfPAdeiRKE4ohVjXDWS9oBmpY3E
	tolqyhpV+kzp6A1RYLdecfPk0ut/qp8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=YzVPJqG/qdv32dfB2Pkj62g8vYaU78q3x/Fdun8yAf8=; b=Mps5e0bEcBN3c6hLG1mDHddHe8
	T6BRb3fiN7sc5Hzeli/1STuk7ycdAKTgb3rjbAHWToMkD8PEXHy1Adc+wcl/+swdZUd008CTrfz2D
	Upl9Ed0ruLyktChEP1lRgtR4Xnwbscv+0uNTyM1wNSIHtw/VYQ6Tzn/e4h2FJRzaRau6X2h2abohs
	0MM1BMesq8alM58ecHo2ycyq5MMC4E2HvQH5HPC9wUKgD0ATYcWhjfchBkZno3qhULcOw2SnMRsHM
	H5xS3flH0kgoZjn1mrEygDqpIZletQmtUDfUvJMNYVFdEAatMIpefdFfWfY4SQzmMLpdPqIc8NElc
	631D6ItQ==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wMRsB-001fjV-1u;
	Mon, 11 May 2026 14:44:43 +0000
Date: Mon, 11 May 2026 07:44:37 -0700
From: Breno Leitao <leitao@debian.org>
To: Lance Yang <lance.yang@linux.dev>
Cc: david@kernel.org, linmiaohe@huawei.com, nao.horiguchi@gmail.com, 
	akpm@linux-foundation.org, corbet@lwn.net, skhan@linuxfoundation.org, ljs@kernel.org, 
	Liam.Howlett@oracle.com, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, shuah@kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	kernel-team@meta.com
Subject: Re: [PATCH v5 2/4] mm/memory-failure: add panic option for
 unrecoverable pages
Message-ID: <agHp-wFHe3FjWAAV@gmail.com>
References: <aftnSfb15G92JON5@gmail.com>
 <20260510144220.92522-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260510144220.92522-1-lance.yang@linux.dev>
X-Debian-User: leitao
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D89CC20005
X-Stat-Signature: 9amsnqxx7z83zr6w8nsg6p45xr7745bj
X-HE-Tag: 1778510704-986768
X-HE-Meta: U2FsdGVkX18c4CA7WcrJzFy0VEHIZvJw7u+wvdYb66Zsshjzic9libktjK3NF2twMLnme5vt9m6XuoW33LXbfQ39PUmJajUSC7dlLBtD2FmROgIlDfrFCoBMxm7veePy2iy73qCvLXF84UinADmO1hXXTpMVXBwmIxdQJr/4rVWU8jtD93aVxhSfci+N5vMSQDAfxUraCOk6K3lPEN68+eUoaZEZQSC8U4TF+o+KnylZtZyXzD8E6gRw9H8/jt/ptZiyON0D1y6azW3rioSFLNSrBD6EZWGKrbxXHYzvcGK8JLkz7C+4gMw62ZhnRlJz1P5/vA5Z1Ct3f2Ewdguya72//AyJB++5B0sJIR6gBjIKKAWnJELEUUVCp6wNxPfgErw9Fo2Vo9lvOJMRyNLpzfSjne8FlVf6GJBHfQSO2Xia1U1yU6rQ1o+Ea1xyuVG+YK841yId8MA5ELFohzrSwHKd43YqUW/rDErZk74os1Y5mp9MvH6ZmmFOhyhPQuzOB6GvGKj2XctWKqdCvgXCvYDQrB5ssbJEqwHRYh25zKny+ySEjgRE54ymKsfe/kYJsIS0NYe3XE6yVEB312tFraxKXY5b/i7H76jeu9iESozrhqDVKpwULJmnVRyjiydwraFXxU1ZS7iEViXlbXRt4IiDuoKXT2t2OQJExNn10Z3XEC7zNFKQPdtDwPdpzXzsAjzEI+WIl67AuJVOr66UwavaWi/O+fF3iS5e5MMVkdNQ0SWqw5WlbaDruR64sc7feM9G9eXGjSFrD8E5OCn1++3fN1rDUH3DpgFzxztEuVbl1nGC2UL4KguvaRcOZBnCv5CJ4OcPUhxDwBySwWrk8WpPbgBP6nAyNOyE4hOmHJsVITAsavyYlJMvD/cbGbnKjRg6HACK+E+X8egZsudE+DcYZ25Y6H2fY4qC+a1p3Wki66ZeceYJVR7X61WimBmKQFmMau2PSA8daf5UXGl
 zXDYzJ5c
 a/epttwBptvDnmSY+sFFzjnygyseVUYKPmtZELwKCv3xijFyleIIFENdUP35zNYaX23HiOxenEbj+ELlQnxTgZELlz/JR3g3AhqsYPU5bs3g3fU8yKXEId0H96bW/KAtfJv1y4n2i6W38k0NGX4ycV84OYD+p1vOAZIdNvw8mZhDx7YE5OHk0w/dB35UGaRa35wXjYVlxqtKzXAMSj1fALXs+fA2/Gn1gg7/Bjg6oOmBaVCKvTS/yboaMR1ajXBoHCE27RMfILEWEiAUsP77NOo2fFuc9lL/zWFL9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, May 10, 2026 at 10:42:20PM +0800, Lance Yang wrote:
> 
> On Wed, May 06, 2026 at 09:18:12AM -0700, Breno Leitao wrote:
> >On Tue, Apr 28, 2026 at 11:07:21AM +0800, Lance Yang wrote:
> >> 
> >> On Mon, Apr 27, 2026 at 05:49:28PM +0200, David Hildenbrand (Arm) wrote:
> >> >> +	switch (type) {
> >> >> +	case MF_MSG_KERNEL:
> >> >> +	case MF_MSG_UNKNOWN:
> >> >> +		return true;
> >> >> +	case MF_MSG_KERNEL_HIGH_ORDER:
> >> >> +		/*
> >> >> +		 * Rule out a concurrent buddy allocation: give the
> >> >> +		 * allocator a moment to finish prep_new_page() and
> >> >> +		 * re-check. A genuine high-order kernel tail page stays
> >> >> +		 * unowned; an in-flight allocation will have bumped the
> >> >> +		 * refcount, attached a mapping, or placed the page on
> >> >> +		 * an LRU by now.
> >> >> +		 */
> >> >> +		p = pfn_to_online_page(pfn);
> >> >> +		if (!p)
> >> >> +			return true;
> >> >> +		/*
> >> >> +		 * Yield so a concurrent allocator on another CPU can
> >> >> +		 * finish prep_new_page() and have its writes become
> >> >> +		 * visible before we resample the page state.
> >> >> +		 */
> >> >> +		cpu_relax();
> >> >> +		return page_count(p) == 0 &&
> >> >> +		       !PageLRU(p) &&
> >> >> +		       !page_mapped(p) &&
> >> >> +		       !page_folio(p)->mapping &&
> >> >> +		       !is_free_buddy_page(p);
> >> >
> >> >I don't get what you are doing here. The right way to check for a tail page is
> >> >not by checking the refcount.
> >> >
> >> >Further, you are not holding a folio reference? If so, calling
> >> >page_mapped/folio_mapped is shaky. On concurrent folio split you can trigger a
> >> >VM_WARN_ON_FOLIO().
> >> >
> >> >
> >> >Maybe folio_snapshot() is what you are looking for, if you are in fact not
> >> >holding a reference?
> >> 
> >> Right! Maybe we should not try to make this decision in
> >> panic_on_unrecoverable_mf().
> >> 
> >> By the time we get here, we only know the final MF_MSG_* type. The
> >> real reason why get_hwpoison_page() failed is already lost.
> >> 
> >> Wonder if it would be better to split that earlier, around
> >> __get_unpoison_page()/get_any_page(). That code still knows why
> >> grabbing the page failed, either an unsupported kernel page or
> >> just a temporary race we cannot really trust :)
> >> 
> >> Then the later panic logic can be simple: panic for the stable
> >> unsupported kernel page case, and not for the temporary race case.
> >> 
> >> That would also avoid trying to guess MF_MSG_KERNEL_HIGH_ORDER here:)
> >
> >This is a very good feedback, and definitely what I wanted to do, but,
> >failed. Once we have the reason, we don't need this dance to guess the
> >reason.
> >
> >I've hacked a patch based on this approach. How does it sound?
> 
> Yes. This direction makes sense to me, not an expert though :D
> 
> I played with something similar (untested) on top of patch #01:

Thanks!

I'll prepare a new series addressing all the feedback from both
reviewers and AI analysis. I will resend soon and we can catch up
on the next revision,

Thanks for the review,
--breno

