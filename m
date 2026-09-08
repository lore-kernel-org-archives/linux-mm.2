Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B763C79F99
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 12:53:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C3696B00BB; Tue,  8 Sep 2026 08:53:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 99BB66B00BC; Tue,  8 Sep 2026 08:53:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D8296B00BD; Tue,  8 Sep 2026 08:53:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6946D6B00BB
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 08:53:33 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EB85780631
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 12:53:32 +0000 (UTC)
X-FDA: 85190586264.05.F0A4507
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 6BE3D14000A
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 12:53:31 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788872011;
	b=NzKyjxLDt8zIDWQHbUfwbSSbTJPzSCmn7bU3utWNLmgTd/Q0OX1zsv3dmbJz70lLsyMg/X
	QlZcrCLjjN0VtpwKZQIiFKmT9SB/qeivNKSd1twy7Y4a0cz0rIsZAgV7txlrIb1iTU9Vfk
	beWTF/QyguN42z4AY8io++n5PUZC/zc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788872011;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=G8rwaIjgZWNnyDavlsytllNzKRkkFtYl6U+aLaGnKDc=;
	b=BNGZCMbgJpk1Ypvsq8JwGbW2bHT0CMZOMUXxGEc3s49Wa927iw/vlVNAXTPmZJ+klc4QFa
	XAdNY5jHpad56lT/pDvqVQcORwaQEPOHCfWrBIMFLjKZrqFj/Owvf/O0hSJhG6rKfmb77x
	DXCetHUdee1WmzJzcu3z2gfNvmiNTgs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E2DF5601DB;
	Tue,  8 Sep 2026 12:53:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44A371F00A3A;
	Tue,  8 Sep 2026 12:53:26 +0000 (UTC)
Date: Tue, 8 Sep 2026 13:52:57 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v2 3/6] mm/vma: only permit MAP_PRIVATE /dev/zero to be
 mapped anonymous
Message-ID: <aqAFBTyAqPTHlxkZ@gremlin>
References: <20260908-map-private-dev-zero-v2-0-acc7b5625305@kernel.org>
 <20260908-map-private-dev-zero-v2-3-acc7b5625305@kernel.org>
 <e743b598-9048-440f-9124-72071c696679@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e743b598-9048-440f-9124-72071c696679@kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: 6BE3D14000A
X-Stat-Signature: fdmku9nqht8yhoe5tw7eiiw8kzbya1zj
X-Rspamd-Server: rspam01
X-HE-Tag: 1788872011-552258
X-HE-Meta: U2FsdGVkX18wY+c82/BGS/wLyX8UtR6EQIWiYHf/SlsWCgHLA887JqzaW3Bim/jykx6+AP5LbucfYlc3odvPQKYNlDf2th0Y9mY3anPVu2OQNpeqftHlJLAE0LkSGcxjp2uh5bM03ybEAERUMMEBrGaUQsepjknvX9PUqQBLKT0gUppYwfJT1+/NG7lxhbir9U+dv2P+EIi2/itA0j3kJTKGr1NRzL6yxQu7blxKqJdk5shPa5ByBnZlphoLzvpGZUgr0390Aq6SVyapWSO2M/KYTittqXBfK3yCyaByqs/PJ3ag5qDXPDuKhnC0i4WM+EyaKqzd5LPnzcjrjZjIIVBKTZEaqHHnsWtUVvtJhP1U9DK6FMBczWtj+EXVSxabg4tPuPwR2yVRDtJO/zJ4PMRAwFBITiTDPv/tdzzUAKYczyMxIEwvSjpF1qqxxXCCxogMd+ZrX+Ld+LLLgMu9CJKAqq/TnGjdleOlI7XFkNa1M2aBcGU5TJoNnlcHzS3i4zK37ZFHYkknOholMio9zP3yfDFTR3NLx2J8RG3n8Y/2HRGMYO3QVqEodT09hi2dMOk6tefog2kG+9g+jJWSB2vQcGYlXrDDBp5c6rOSxDeEyxCQP4kUsgSQco+nCg8VtWjCG7o8GGEU2nRYAEn4APZ/c/0bKDZyc/POfKOtgvdRUEqwkfFfnwfhGP9a+mZPEbrBsOVx13YpflXOEucJ1J6dAAfLlNSvPoUw0/nwyPEjJGLDISCb9xJNmI/SFWIXeCmFMdlgJAXHkhGYCZck1/9AJBdrsjguWDtZZfZWXOcySiwnEpwrWkXK/RjvwtnzKZ85vo2L+jbn9FVg2FzElUmhWKYmUwR2FtwTdeAKYWgeCRkB3IpNSJRnCGpUxdKUrtfJJXSV4ra7En+MXzRYYyUqUKUZxJfOfa6gWPmDIM0c4A1OwywOEQp87a475NtULNnUap7xqdF/UEf0+Rk
 4237mJR6
 fQUnD44lca1O3YuJbwHwsSEKE25VrUG68WBKSDny7Q1MfSYnQowrZtxJYo2uZz0pvoVGljTcYjx4O22QN3IFQYHkzxXgCAr5/mIB5Hho2bxSLhLcSTSIb1B+1kOeb49pzTWbW4JuLLfjWRaT4tWJNrSGH6TMtrdqfNvGm+RaldMzaMCdtovg0kUX3IBeILqrX5KFAKz5WkCAJ7m8B5TmpAsbACw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 08, 2026 at 02:49:33PM +0200, David Hildenbrand (Arm) wrote:
>
> > +	/* Temporary MAP_PRIVATE-/dev/zero workaround. */
> > +	if (is_anon && map->file)
> > +		vma_set_anonymous(vma);
> > +
> >  	if (error)
> >  		goto free_iter_vma;
> >
> > @@ -2777,6 +2793,10 @@ static int call_mmap_prepare(struct mmap_state *map,
> >  	if (err)
> >  		return err;
> >
> > +	/* Hooks cannot mark themselves anonymous. */
>
> Wasn't this supposed to be reworked? :)

It is, you yourself pointed out 4/6 makes this irrelevant, so I changed it
there :)

>
> In any case,
>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
>
> --
> Cheers,
>
> David

--
Cheers, Lorenzo

