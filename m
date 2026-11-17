Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36827606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 19:46:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=PMSPOF9E
Received: by kanga.kvack.org (Postfix)
	id 4D2F66B05B2; Tue, 17 Nov 2026 14:46:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A9E86B05B3; Tue, 17 Nov 2026 14:46:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BFAF6B05B5; Tue, 17 Nov 2026 14:46:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2100B6B05B2
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 14:46:41 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8E3784054C
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 19:46:40 +0000 (UTC)
X-FDA: 85445643360.12.66486A7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id B38201C0002
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 19:46:38 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=PMSPOF9E;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794944798;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QzRriqS/gCV9txdZ0C8J+i8ic1h6+szbkNOsGAH6yA0=;
	b=6h4n9WIVR7gJbQ8sh4kt9tTIz2ENerRw6gXI9z2PGctMkvEUEkFKmVQwyeq0JJ2bhXfqgM
	IuTD9QnowH3BMa+KL2z0ZbJ2QsVupyXOxCeEtvUNzw9nnVf2obtpz45/sljRo4q+wd3PP8
	GqVb/Dfw13LFnk+pQdC7agnSSgpTZ30=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=PMSPOF9E;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794944798;
	b=pjkkfmH6k7pG9Xa28aAchizNbRrOxF0ATN6n77uCWytc5vA0TWSIeZNSZgW5oEJLDaWSXk
	OHGf3jJN1YIzumqY3fKqNmgpd02Y26MkKZoljkvMw8fvSo+W3QvmHO/wK7Nd1Jaqu74Vg+
	xhmCQxy20CINYt+sgudywY6A4sYWtJQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 67D5960D53;
	Tue, 17 Nov 2026 19:46:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 474491F000C4;
	Tue, 17 Nov 2026 19:46:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794944797;
	bh=QzRriqS/gCV9txdZ0C8J+i8ic1h6+szbkNOsGAH6yA0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=PMSPOF9E+K0Vd18R5fn1hQrOpW89ujbJ0rpDZ8+drADajQ8NiZ2KyubHfOprFbo9w
	 mBxRSH5mWPFmLqu2iQo0FRjbsKdlgSX+GyzWN6MvhfAROdH4rHa3JZN5/ZhyQTUHsp
	 51NWlVfbgawLl+7HkK+0XmRys1yyKIKeWcYZJCRQ=
Date: Tue, 17 Nov 2026 11:46:35 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: sashiko-reviews@lists.linux.dev
Cc: sashiko-bot@kernel.org, "Muchun Song" <songmuchun@bytedance.com>,
 "Alexander Potapenko" <glider@google.com>, "Marco Elver"
 <elver@google.com>, "Dmitry Vyukov" <dvyukov@google.com>, "Chris Down"
 <chris@chrisdown.name>, "David Hildenbrand" <david@kernel.org>,
 "Liam R . Howlett" <liam@infradead.org>, "Vlastimil Babka"
 <vbabka@kernel.org>, "Mike Rapoport" <rppt@kernel.org>,
 "Suren Baghdasaryan" <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>,
 "Johannes Weiner" <hannes@cmpxchg.org>, "Brendan Jackman"
 <brendan.jackman@linux.dev>, "Zi Yan" <ziy@nvidia.com>, "Muchun Song"
 <muchun.song@linux.dev>, "Joerg Roedel" <joerg.roedel@amd.com>, "Lu Baolu"
 <baolu.lu@linux.intel.com>, "Pranjal Shrivastava" <praan@google.com>, Ketan
 <ketan.kishore@oss.qualcomm.com>, "Mostafa Saleh" <smostafa@google.com>,
 "Sang-Heon Jeon" <ekffu200098@gmail.com>, "Jonathan Corbet"
 <corbet@lwn.net>, "Shuah Khan" <skhan@linuxfoundation.org>, "Randy Dunlap"
 <rdunlap@infradead.org>, kasan-dev@googlegroups.com, linux-mm@kvack.org
Subject: Re: [PATCH v2 2/7] mm/page_ext: fix client data alignment
Message-Id: <20261117114635.37d4c1f7f1b38cc4ce7fb886@linux-foundation.org>
In-Reply-To: <sashiko-outbox-219498@kernel.org>
References: <20261117120627.50601-1-songmuchun@bytedance.com>
	<20261117120627.50601-3-songmuchun@bytedance.com>
	<sashiko-outbox-219498@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: B38201C0002
X-Stat-Signature: yfhyt4r86s5jt3trbuzso3bguzw8cuqm
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794944798-314285
X-HE-Meta: U2FsdGVkX18jQOHqnlYfMRg36VpN0hnnCUIlOYrlZZavSOD17DbSmTF3xL+Qk865AAnnLZ3cevbqb6odxlLobQfUPHxz+BS0aCBijkwfCsDDVTquQXIrGGlhjoTiV2FxsMlIpQOqEB2/wNBLzH5tVy3NkiSi/z4yDFr5Ks2J6zwBMqx4OHw7hN2Zt85Zkf/bD33HbeazczGHiQhQSqk3iwtWq/xC563lQMMzeBbqr9jFVTGuFrHVompfphrquLleuBTW/o6ccqMIe8JIJ9HvFtmyZTRzsItaseBlyyMjlAVOqbRpkABq1VlehZfJZ5vH37bnXJ6UMHA3DL5dv0Qug7K6RJsrTd1RdIH3AqwmscD+wPfITuRK5h57KzO38uW9HESS0puWdd8X7qUaik2vWiC9GvasJ5ImVDDQSovFYaft/hc0+VQTSHDP9d6aNZyaDcpzWd+kCqKZTTbe7Nm375R0vfWkObdOdojAs/1sbnzJ82zfdJLOK9vIGyNsugsXu6n26Y8QL1IpHsRYHWeFNaRwxzLVJ8SST2Vf1KOMvmM9xyW+G7vjKChrKOKqcpHc9o+BLrDo5KFvaoZy2WX6LFUegzGuw+w8B+ga42C758exeYemvWzvgwyaS91MOPv+ezXERIcFPWB4RCByTpc62Vfs5oqxg7iF0QJ1DuxR4C4ipQKcTng04RTvQMOVQUvA/GMY0lUWEnUBXP4Vui4oRsI5EXKX2L7BcAbhisxhe2TEIDxlQzlmEFqyHDPI8JN7SIGMS4qQi9Yr9Y5ssAoDXnPd+XRuGmpjHaeK6EF99WK02cZzRb3WsVOYLeeUQr1bEOYynSwB2dEJGC+w4JrwSHs+O+Maoua0OqInYJ38aV3n0UMW67wPrLtG9Ac7kXfArYHW59BGNv3Wnjp7xjXbWK4krCl6XcxQwxuGBgnhUTLlAzjeccy9CYZqOq50/xZ8+4LtyW6Yb+VsCl9LavZ
 4H+rmjNL
 1TlwIX2CQGOkLPd6Vd4tPyQlb1l+8kU2Dl7AWdFUOszrhQ4x2pV1tL0cglEHqLNwexZ3nydzLvOaa3+87NcY/QUz6n7aD6LQgmLdI+tq0+OJrZLNZHj+fyLK9D3nWj52pdjFOf00ZHSZedoLXzqgBbUmF6su7aeCwppBjVkewHXPTgl2hHi9ker2NPxpw1NocMz4TdNosTZKWJZrqFJEtrMiECHcYfquANcfzQdjai6JZeHfuW3YBTCs9LEvnzSuEAMyJdCSAKVQj4r8hK8S/gUXNF+X2Ug3y2rNjY5XSCi+IfPrKtW0y5FnTApZ68onKFUq1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 17 Nov 2026 19:36:23 +0000 sashiko-bot@kernel.org wrote:

> Thank you for your contribution! Sashiko AI review found 1 potential
> issue to consider:
> - [Medium] mm/page_ext: 4-byte alignment cap in
>   page_ext_data_alignment() on 32-bit
> --
> 
> commit 4ecca9da35d7e4448f4270965043775293174eda
> Author: Muchun Song <muchun.song@linux.dev>
> 
> mm/page_ext: fix client data alignment
> 
> This commit aligns page_ext client offsets and rounds the final entry size to
> the largest active client alignment.
> 
> > diff --git a/mm/page_ext.c b/mm/page_ext.c
> > index b679a8c1f7d7e..dbc1bfa258f15 100644
> > --- a/mm/page_ext.c
> > +++ b/mm/page_ext.c
> > @@ -116,8 +116,22 @@ static int __init setup_early_page_ext(char *str)
> >  }
> >  early_param("early_page_ext", setup_early_page_ext);
> >  
> > +static inline size_t page_ext_data_alignment(size_t size)
> > +{
> > +	if (!size)
> > +		return 1;
> > +
> > +	/*
> > +	 * A type's size is a multiple of its natural alignment. The lowest
> > +	 * set bit of the size is therefore at least that alignment. Cap it
> > +	 * at unsigned long alignment to avoid excessive per-page padding.
> > +	 */
> > +	return min_t(size_t, 1UL << __ffs(size), __alignof__(unsigned long));
> > +}
> 
> [blah blah]
>

Yeah, but the whole expression is quite reader-hostile, as min/max
things often are.

How about doing

	/* comment */
	if (this1)
		return that1;
	/* comment */
	if (this2)
		return that2;
	/* comment */
	if (this3)
		return that3;

?

The code generation will probably be just as good and it's __init-time
stuff anyway.


