Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78214C87FCA
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 01:03:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0AEC36B008A; Sun,  3 Aug 2025 21:03:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 087146B008C; Sun,  3 Aug 2025 21:03:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F05C06B0092; Sun,  3 Aug 2025 21:03:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E2F256B008A
	for <linux-mm@kvack.org>; Sun,  3 Aug 2025 21:03:18 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 61DBA1DD717
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 01:03:18 +0000 (UTC)
X-FDA: 83737276476.12.DBD8F4E
Received: from invmail4.hynix.com (exvmail4.hynix.com [166.125.252.92])
	by imf07.hostedemail.com (Postfix) with ESMTP id E8D5140002
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 01:03:15 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	spf=pass (imf07.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754269396;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jZ2rXDC0q6QH3EqDAvK7RJuxPYFspfSrMaXVLFCYfag=;
	b=EMW4AoNCwuZMmPoElnAzuLYFd0riTYdZeVgNs2Ln6IhMhC3AhKkwP+ekGSVxYbVPNnqy6v
	bV42Dy2DTY2gZlItfcm/3AMI2wbps0QM3omH+bNzC8Y8tMErpfLPrk88DamhTjOcEJj2gm
	A2z684Q0SbGE8eH8r0ZRVaXRF/p9z1I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754269396; a=rsa-sha256;
	cv=none;
	b=AUDlP67YTn7kCBIsHDLzZ1C6TDpR9IzGkP2MSzW+CCPrijVIuXDU/xL0wG+2KNqya+r6CE
	1LWx2Cn8XNPuj5UJzCQO0tnblN5yIRTDvQpIedXj0NM6jRyoKfVp63PkAQ+ZCAUsPlqon6
	/FYAW4cyRxkiQjTDhf9mW/pJ0beqS9o=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	spf=pass (imf07.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com;
	dmarc=none
X-AuditID: a67dfc5b-669ff7000002311f-5b-689006d004ea
Date: Mon, 4 Aug 2025 10:03:07 +0900
From: Byungchul Park <byungchul@sk.com>
To: Jakub Kicinski <kuba@kernel.org>
Cc: linux-mm@kvack.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel_team@skhynix.com,
	harry.yoo@oracle.com, ast@kernel.org, daniel@iogearbox.net,
	davem@davemloft.net, hawk@kernel.org, john.fastabend@gmail.com,
	sdf@fomichev.me, saeedm@nvidia.com, leon@kernel.org,
	tariqt@nvidia.com, mbloch@nvidia.com, andrew+netdev@lunn.ch,
	edumazet@google.com, pabeni@redhat.com, akpm@linux-foundation.org,
	david@redhat.com, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, horms@kernel.org,
	jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
	ilias.apalodimas@linaro.org, willy@infradead.org,
	brauner@kernel.org, kas@kernel.org, yuzhao@google.com,
	usamaarif642@gmail.com, baolin.wang@linux.alibaba.com,
	almasrymina@google.com, toke@redhat.com, asml.silence@gmail.com,
	bpf@vger.kernel.org, linux-rdma@vger.kernel.org,
	sfr@canb.auug.org.au
Subject: Re: [PATCH linux-next v3] mm, page_pool: introduce a new page type
 for page pool in page type
Message-ID: <20250804010307.GA39461@system.software.com>
References: <20250729110210.48313-1-byungchul@sk.com>
 <20250801160805.28fa1e05@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250801160805.28fa1e05@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA02SbUhTYRTHe+5zd+91tLgty6dFX1YQGVmG0Qns5VM9QVFUUJhRo93aUKdt
	ZtoLzTLMkUt6gVyrJpHZMlYzXyZq6cyZQdlKWS9qaa9kVqbiWmXOiPr243/O+Z3z4QhYWS1T
	CXpDumQ0aJLVnJyVfxpfNPcRV6Cb35KrBLurlINrw5lw5WWVDOzOCgQDwec8jNQ2IfjW6OPg
	o7cfwaWiIQz2hzksDLq+Y3jT1M3DNfca6Cp+y0JNbiWG7hPNHOTnhDDUBvt4OFxVwoC9zMxD
	a4VVBqe/X8ZQaX7Jw+NqOwedpSMyeNuQz8I921UWvpxpxNBlXQ5NjikwdL8XQaOrkoGh4+c5
	aCusZqC8to2HU34HBz05XQj83m4Wzvw4xsG5bCuC0PCosq9gQAbn7nbyy+fQ7ECAo97ez5je
	uvqUoYG6FoZ6bB08dbj30LKSaGoJ+DF1O/M46u4/ydMX7TUcbT4bYqnn1WLqqfrG0PwjfRz9
	+uYZuy4yQR6vlZL1GZJx3tLtcp2vtEOW9iAqM6/+IjYj/0QLEgQixpHG+rUWFDGGvoInXJhZ
	cSapaz+Kw8yJs0ggEBzjyNE8p6yQtSC5gMVynoR8jrGBSaKOlF3oYcKsEIGUvzOjMCvFRBK8
	UcH+ySeSe4WvxxiL0STw6wMTvgGL08iVX0IYI8RY0u48EO6YLM4gdyp8THgVEV8IpK6wnP1z
	51RSXxJgC5Bo+89q+89q+2d1IOxESr0hI0WjT46L0WUZ9JkxO1JT3Gj0o4oP/thShfpbNzQg
	UUDq8YrN2hM6pUyTYcpKaUBEwOpIReKh0Uih1WTtk4yp24x7kiVTA5omsOooxYKhvVqluEuT
	LiVJUppk/FtlhAiVGVnbjg8vWztuhXZD0Wrv5JizaTUDnqRFrSN4o6H5du9tVdKyBJXS6lq9
	JdbjjXev6kqgriWqS+9Tdy9ecLj+NARvPhpemN2Ze9ISNyFhJxm8Hgq93/o8z2LeNGXVz/1R
	pzIzZifFutJ93mJT2rgJ67XTW7qtwqLElXGeziNOp9/Wq2ZNOk1sNDaaNL8BbhHtyE0DAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA03Sa0hTYRgHcN7znvOe4+rA8ZaHgoglFFKaYfREUdIXT0GXD0EXghp5cMO5
	ZEvTKJplmJLObpBzq0WktQRj6pymkpc27WLmrZW30kykMCuTdHbZjKhvP/7P838+PRwOsTKL
	OY3umKzXqbRKoqAVOzeeXd1BCtVrun1xYCkvI3DvewaUvnExYLE7EUzN9LHwq96N4GuLh8CH
	5i8Ibt2cxmB5nk3Dt/JZDKPuYRbuOXbAUMl7GupyqjEMm1oJ5Gf7MNTPTLBwxnWHAkuFkYVm
	axsDHc4CBq7M3sZQbXzDQlethcBg2S8G3jfl09BmvkvD5NUWDEMF8eC2LYLpJx8RtJRXUzB9
	wUqgp6iWgqr6HhYud9oIjGQPIehsHqbh6tx5AsVZBQh83/0nJwqnGCh+NMjGr5KyvF4iNX/8
	hKXKu68oydvwmJJqzAOsZHOkSRV3oqQ8byeWHPZcIjm+XGKl/t46IrVe89FSzdsNUo3rKyXl
	n50g0ufR1/Tu8AOKTYmyVpMu62M2H1aoPWUDTGp7REZu4w1sRJ3BeSiIE4U40VPYTQKmhUix
	ofccDpgIK0Svd2beYf48u6KIzkMKDgtVrOjz2OYLoYJarLg+QgXMCyBWjRlRwCHCQXHmvpP+
	kweLbUXv5o2FKNH7c9y/z/m9RCz9yQUYJMSKvfaTgY1wYbn40OmhChFv/q9s/q9s/le2IWxH
	YRpdeopKo10XbUhWZ+o0GdFHjqY4kP9pSk7NXXShqa6EJiRwSLmQ35doUocwqnRDZkoTEjms
	DOMPnvZHfKIq84SsP3pIn6aVDU1oCUcrI/jte+XDIUKS6picLMupsv7vlOKCFhsRo7u5jVrw
	I2elyamdjY/sn+zuS362ZtfYLj6U7l97kr0V+6K9vuQTNllydPsaeLTlaVxp6vj6udaW/S9c
	mnFeCN2TZuesPY1ddZH9C5YOTBSfIzh4f+6y0upVSR3Ht/a5SxJWPnI/03m6Te7K80MPXuaq
	9pKyM9aYhNiUSVudkjaoVbFRWG9Q/QZCp756MAMAAA==
X-CFilter-Loop: Reflected
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E8D5140002
X-Stat-Signature: uay9hw13qy1jxayj98o8opaqt37x9kiw
X-Rspam-User: 
X-HE-Tag: 1754269395-114955
X-HE-Meta: U2FsdGVkX19owx0GQg+1u/tEj5FFpwPwgGtN4ISNAEBYKjEqvv9J7CbSBlBa1mA1nlKa8LCNpvgrC2H/HGRdsLPsnDUyOg7hyjdqKZHts8BZhDOO2scQA5U/mTX8h4r8ak4oHhw/t1MSIHiyEOVv160b1FLfM71FFRgt97IJlwI8aG+x9iTvO8QYTOFG41t425TAWphukuVPDd0QWPRxSV9I6K+YXTylMvZ+dG/R8DYtRjVBd57y3MH4mfxCbtNljFEk5Pl/0pL/lUb4U0yoH2IaD6vKV7DE/NAiX8RjRYnk3xkAbcanQ/NgKMdJv4gnDm6nP5mzwMdCMtv/3z7g9F1iUcnoBr8khMrGJdO1z4rmfBTdea1bD4QRWr3jO7LwAwLwgZQKZQ8eY+neNa27LMaCvayGE+dhGfDS+0KCdHGa+XkbQiFP2QgDST4UDS4JWHlfsEvT0MB4eLGI10E4NcvG1qsSci+mySlrxvUfri2sJLavVAPZJCHAtcB2oTpFmIt4bToxQtsOdTUm859TT9o5OOWieKRP7wtO3sJIH8n7UQwFbIQsVNokO4SuvbULE3Z6QY8lEMOydjcUNW2cVtkf1KARqDRtE+gxLu25raAvdgwd/LEUYn0LbGMLWGrJ1o2bGeI4t+wn5fkH9c5DuBdNHj4QHt8Tj3XHsvyHpoC7wFppg3P9elFbGiTSsatNQWBPHWNSi25LfQ5xeOi5oLvAdjIgaFpIRzK7x2VWVZjopjK0/y23yeSERyXMLjvVHXFwa1a4DYEqh28RiwS7q/tFslCH7Z4wQ8+irS5Yd5i7ghnkyqfuVN9021cp2vfJ5QIp4HkQKVnKfH/hunT4fswE++IX4iMTo7j8KVsrC06Ukv4yTeSHQfYi9u3tM9S8WS/sOfXeTtfVuZ6oENSTyRpKHpQA8gMGbnkazeBAu3rCPV8V/rMbFrjqaC5D35vzkfegZFEdXW1mckunxMt
 OAkTmD+8
 OtrNRXlYkTD3oAuBgPaINKHaKB8ahZenAakPqAGXOf4gHGpzKX7jS5wXl9GIw6gMLCWWrWcqsehY2d7A=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 01, 2025 at 04:08:05PM -0700, Jakub Kicinski wrote:
> On Tue, 29 Jul 2025 20:02:10 +0900 Byungchul Park wrote:
> > [PATCH linux-next v3] mm, page_pool: introduce a new page type for page pool in page type
> 
> linux-next does not accept patches. This has to go either via networking or MM.

Yeah.  That's what I found.  Thanks for the confirmation.

> > -     if (unlikely(page_has_type(page)))
> > +     if (unlikely(page_has_type(page))) {
> 
> Maybe add :
> 
>                 /* networking expects to clear its page type before releasing */

I will.

> > +             WARN_ON_ONCE(PageNetpp(page));
> >               /* Reset the page_type (which overlays _mapcount) */
> >               page->page_type = UINT_MAX;
> > +     }
> 
> >  static inline bool netmem_is_pp(netmem_ref netmem)
> >  {
> > -     return (netmem_get_pp_magic(netmem) & PP_MAGIC_MASK) == PP_SIGNATURE;
> > +     /* Use ->pp for net_iov to identify if it's pp,
> 
> Please try to use precise language, this code is confusing as is.
> net_iov may _belong_ to a page pool.
> 
>         * which requires that non-pp net_iov should have ->pp NULL'd.

Thank you.  I will.

> I don't think this adds any information.
> 
> > +      */
> > +     if (netmem_is_net_iov(netmem))
> > +             return !!__netmem_clear_lsb(netmem)->pp;
> > +
> > +     /* For system memory, page type bit in struct page can be used
> 
> "page type bit" -> "page type", it's not a bit.
> 
> > +      * to identify if it's pp.
> 
> ... to identify pages which belong to a page pool.

I will.

> > +      */
> > +     return PageNetpp(__netmem_to_page(netmem));
> >  }
> >
> >  static inline void netmem_set_pp(netmem_ref netmem, struct page_pool *pool)
> > diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> > index 05e2e22a8f7c..37eeab76c41c 100644
> > --- a/net/core/page_pool.c
> > +++ b/net/core/page_pool.c
> > @@ -654,7 +654,6 @@ s32 page_pool_inflight(const struct page_pool *pool, bool strict)
> >  void page_pool_set_pp_info(struct page_pool *pool, netmem_ref netmem)
> >  {
> >       netmem_set_pp(netmem, pool);
> > -     netmem_or_pp_magic(netmem, PP_SIGNATURE);
> >
> >       /* Ensuring all pages have been split into one fragment initially:
> >        * page_pool_set_pp_info() is only called once for every page when it
> > @@ -665,12 +664,19 @@ void page_pool_set_pp_info(struct page_pool *pool, netmem_ref netmem)
> >       page_pool_fragment_netmem(netmem, 1);
> >       if (pool->has_init_callback)
> >               pool->slow.init_callback(netmem, pool->slow.init_arg);
> > +
> > +     /* If it's page-backed */
> 
> Please don't add obvious comments.

I added the comment since it's _not_ obvious.  !net_iov means it's not
net_iov, not it's page-backed.  However, since you, as the maintainer,
are okay, I will remove it.  Thanks.

	Byungchul

> > +     if (!netmem_is_net_iov(netmem))
> > +             __SetPageNetpp(__netmem_to_page(netmem));

