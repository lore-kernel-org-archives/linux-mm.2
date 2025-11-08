Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38FF4CCF9F8
	for <linux-mm@archiver.kernel.org>; Sat,  8 Nov 2025 02:25:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D614F8E000A; Fri,  7 Nov 2025 21:25:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D3B1D8E0006; Fri,  7 Nov 2025 21:25:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4F128E000A; Fri,  7 Nov 2025 21:25:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AD8C98E0006
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 21:25:11 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 26066BA8ED
	for <linux-mm@kvack.org>; Sat,  8 Nov 2025 02:25:11 +0000 (UTC)
X-FDA: 84085847622.27.C2A596D
Received: from invmail4.hynix.com (exvmail4.hynix.com [166.125.252.92])
	by imf15.hostedemail.com (Postfix) with ESMTP id F3165A000C
	for <linux-mm@kvack.org>; Sat,  8 Nov 2025 02:25:06 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	spf=pass (imf15.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762568709;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NClXz0C2rrzfM857wMDh3o4uXn5t3vVWXwsIpkYhKFI=;
	b=CqDVBnJhfN7J+1HOnr/wXa9CX9vQ7zTpZ66CNKcz3oQNGUu1SgPFzDq+JWSWXQ58D4Qall
	N32VLB6ogvU33wwdlcZNzAmz8GjYit3Gn55K8iOXM5OkYZwG5u3s7ePKaXnypxUYvgyZni
	v6SldvEQ5Aj33+o3jg3WFQGaFto8YsE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762568709; a=rsa-sha256;
	cv=none;
	b=bmep8XOXbO6EuAmamtUjXTpthPiomnG4LsixysD9PUCHhcHjRVdoeU9dhrIJuI6Nfp154i
	gOerOIAy71WT1nCYF0/RqnlM8/HEYnagGU7v1IdTo7AFGK7J+Wosx3YEK8BjxMRzmTTbRl
	vm0hPO0FDlyQYcxVmUQ9hBvaed/nIsM=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	spf=pass (imf15.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com;
	dmarc=none
X-AuditID: a67dfc5b-c2dff70000001609-94-690eaa002d8e
Date: Sat, 8 Nov 2025 11:24:58 +0900
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
	sfr@canb.auug.org.au, dw@davidwei.uk, ap420073@gmail.com,
	dtatulea@nvidia.com
Subject: Re: [RFC mm v5 1/2] page_pool: check nmdesc->pp to see its usage as
 page pool for net_iov not page-backed
Message-ID: <20251108022458.GA65163@system.software.com>
References: <20251103075108.26437-1-byungchul@sk.com>
 <20251103075108.26437-2-byungchul@sk.com>
 <20251106173320.2f8e683a@kernel.org>
 <20251107015902.GA3021@system.software.com>
 <20251106180810.6b06f71a@kernel.org>
 <20251107044708.GA54407@system.software.com>
 <20251107174129.62a3f39c@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251107174129.62a3f39c@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA02SbUxTZxTH99zn9rmXjuptB9vjS2JS3ZYQxWk0OSbTYEzMo9HExMwPM8us
	cpUboGCBWlzMyiRzI4IvgCmlmyVGwIoB2403i1HAIqgZwUhuJy/KqsYpLwElQI3I1Rj99sv/
	nPz+58MRsalLt1BUrNmyzWpJMxM9rx+OrVjxiW+e8k37IyN4amsIXJxyQNWDRh1M1zzhwOOr
	R/Bi+r4Asy0hBBPtHQSetY0jOFcxicHzTz4PL2tnMDQ1P0Hwv+sSgUehIQEu+rfDYOVjHoLH
	GjAMnbhJoDA/iqFlekSAXxqr58QBpwDd9UU6KJk5j6HB+UCAu80eAgM1szp43FrIQ6f7Ag9j
	pe0YBouSIOT9HCZvPUfQXtvAweTxPwjcK2vm4O+WewIU93gJ/Jc/iKCnbYiH0le/ESjPK0IQ
	nZpTjpx8oYPyGwNCUiLLU1XC2p6PYvbXhTDHel2neKZe7eJYk7tfYF5/DgtUJ7ACtQczv+93
	wvzjpwXW1xsk7KYryrOmh+tYU+MExwqPjpAd8d/rv02W0xS7bFu5YY8+RS0Ok8zLCxyhrlni
	RIPGAhQjUmkNHe/8k7zn4jt5uACJIi8to56OTC0m0tdUVaexxnFzcX6gjC9AehFLYwJ1qQM6
	bfCZlE3HRp1vlwwS0N7yCU5jkxTgaOTM/He5kXaWRXiNsZRA1ddPOa0LS4to1WtRi2OkVfTs
	04igcby0lF6r7+C0LirNitQ7NYze3bmAXq9W+ZNIcn+kdX+kdX/QehH2IZNitadblLQ1iSm5
	VsWRuC8j3Y/mPqzyyKvdjWi8e2crkkRkjjXsiRoUk85iz8pNb0VUxOY4w1prrGIyJFtyD8u2
	jB9tOWlyVitaJPLmLwyrJw8lm6QDlmw5VZYzZdv7KSfGLHSiEv3wrvqVfW6/cSbnyukfpuoc
	rkhGXVVl8Tq7ca+SFO35efH8oCt1WzjhbumzcuX+dx2JYWFb0qFrwsbwesPZ3Smpd4KB/q11
	q1egfztHCzcs/8rx0LKk+9e1tw/39x3tWpaxP8ri4tGmbPvSzQdDO0s+3VJxcN+VI1v0keBP
	vkvzvjTzWSmWVQnYlmV5A8tDvuVdAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sa0hTYRjHec97ds5xtXacpkclotmFJCsr6ym7fQg6XYwwKgoqVx7aIV2y
	TdEomCVYI+1iF52TtMjUFqNZ3tII71pSGtrp5kwt6YJZmjS1liuivv34Pc///3x5GKyyyQIZ
	UWcU9DpNrJqSk/ItESdC3UVTxIUvzIvBardRcPN7EtzoLpeBy9ZPgLW4FMGw6yUN7uoGBEN1
	jRR8rP2K4Fr+CAbr41QSvtlHMVRU9iP4kHWLgrcNPTTcdESCs+AdCVVpZRh6zjRRkJ46hqHa
	NUDD8fLCieISEw21uc0yeFKaIYMLo9cxlJm6aXhaaaWgy+aWwbuadBKaLUUkDF6sw+DMWAsN
	eX4w8vATgjp7GQEjp3Mp6MiuJOBudQcNme15FPSmOhG01/aQcHH8JAU5KRkIxr5PVA6cHZZB
	Tn0XvXYBnyJJFF/76TPm7xQ9J/jOrHMkL91vIfgKy2uaz3Mk8CWFIbxZase8o/gUxTu+nqf5
	V51VFN+UNUbyFW+W8xXlQwSffmKA2uq3W74yRogVEwX9gtXRcq2U+ZyKvx2Q1NDipkzI6W1G
	XgzHLuEyW1OwGTEMyc7krI3xHk2xczhJcmEP+07o1JJs0ozkDGYHaS5L6pJ5Bj6skRv8bPq9
	pGCB68wZIjysYksIru+S8o/35pqz+0gPYzaEk36+Jzy3MBvE3fjJeLQXG8Zded9He3gqG8w9
	KG0kziKF5b+05b+05V86D+Fi5CvqEuM0Ymz4fMMhbbJOTJp/4HCcA038UMGx8XPlaPjp+hrE
	Mkg9WRE9phBVMk2iITmuBnEMVvsqwnWTRZUiRpN8RNAf3qdPiBUMNSiIIdX+io07hWgVe1Bj
	FA4JQryg/zslGK9AE1JueVZvvh+1efouu/GH0tm8rHdT+p5VbflDMZmLcsMjZ1zeu43rFpZq
	t0fOC9iQ4I8r868GiQWhgdNcxdlL9+/Y/GOFXfko48LotEnO9tm2j/eUew50+PfWRR1xPzCm
	TfnimqXS9q+LUY6Py7dag49GMMe9H67p9Rl8c1nRtiZg7s5WNWnQasJCsN6g+QV0ynHqPwMA
	AA==
X-CFilter-Loop: Reflected
X-Stat-Signature: gzed18ahi5t18f77o8twbhuc731swe4w
X-Rspam-User: 
X-Rspamd-Queue-Id: F3165A000C
X-Rspamd-Server: rspam01
X-HE-Tag: 1762568706-349781
X-HE-Meta: U2FsdGVkX1/QPKAkvQsTo/fYMhNFTuNnSDMXnABci00R3xjtvk3sDQSqtcFGIm40YRwF6jNPrpLp5i/b1CihxAHZvW3vjH1BhoieujV0kETIahokuP0PIt4XAOTtm/HbuDemXj+4r2+mawdpYx+ZTjyRFSth+sZuhCZvA3scJEUB+AqYp+03G6+59rfSXxT5a5WXS6BEHCZpcEb8hmSLCT4/+1nO3aa7p7NknJlrDg1qD72QdqR1bs375Ujl8DQwGtlFOX0bv1ZMpjr/+nrVEPUA4+1VOsKCE2ikz+dHr9JznFlrgj5jwEuBc4oV7moDvEFm1pQgXsbmvgk594YSNn/s968n7KBvFXU0V0XKgLVlppa74iN/QHpXJcpOumXwfcoMugBqvQVyARrSziIxQfB3UJTpFf/QezR2gBasScyAbf5m3EAJKFZqmJ/FQpFrzlP0iTKLJASqiiq1vDyqTctCWZtPUbaoum5WGmBX+W/6p9dJehh7YfSZOxnH1ztu4XGtZIgjm7DWts8mchOerbuQ1y66DUaT8UvCqR28jz8axEM5dRJCxHVQBALTcwKXlJqiwFvTjBtquFlc6BX0joy9vnL9UvwXo8detEZ+kBXz8cEFA0JEBvA/31wPbGHbIvq6kRIAXvSNam8OS3E5uecFTVipsZSWaci22iuRfRqNSxSC3fg0OTR9SZTN02ZcLYARSiQpKV3LESuhK9wbn5cdDN12zvG0CtVswiuUwmQPL0ScMkywioNAAbJaL3rRoQPh9p+1XAWlpQ2dyBt9+hV0dOy245lNrK5kGuac4M3s2ohYfh6bqIzMobaxWPq5Wi2opzdcGOMjpzNQWj6COh65DkyHUkYg9KLPnm8DgPBPf+iYpw3rg5hVyJ9MjNDqsw3g3nGmT8aW1f1zG5w4wgRm3rwGs0cXWLH8fCH+7i0xj+Gd+RzH86aCVh/jdkbi+F7gxwZT704XZfM+Xzs
 00tTv+dh
 pR9aGgRyl9CQ+WMZhI5dYC6SW/EmZ2EOxYQzW
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 07, 2025 at 05:41:29PM -0800, Jakub Kicinski wrote:
> On Fri, 7 Nov 2025 13:47:08 +0900 Byungchul Park wrote:
> > The offset of page_type in struct page cannot be used in struct net_iov
> > for the same purpose, since the offset in struct net_iov is for storing
> > (struct net_iov_area *)owner.
> 
> owner does not have to be at a fixed offset. Can we not move owner
> to _pp_mapping_pad ? Or reorder it with type, enum net_iov_type
> only has 2 values we can smoosh it with page_type easily.

I'm still confused.  I think you probably understand what this work is
for.  (I've explained several times with related links.)  Or am I
missing something from your questions?

I've answered your question directly since you asked, but the point is
that, struct net_iov will no longer overlay on struct page.

Instead, struct netmem_desc will be responsible for keeping the pp
fields while struct page will lay down the resonsibility, once the pp
fields will be removed from struct page like:

<before> (the current form is:)

   struct page {
 	memdesc_flags_t flags;
 	union {
 		...
 		struct {
 			unsigned long pp_magic;
 			struct page_pool *pp;
 			unsigned long _pp_mapping_pad;
 			unsigned long dma_addr;
 			atomic_long_t pp_ref_count;
 		};
 		...
 	};
 	unsigned int page_type;
 	...
   };
 
   struct net_iov {
 	union {
 		struct netmem_desc desc;
 		struct
 		{
 			unsigned long _flags;
 			unsigned long pp_magic;
 			struct page_pool *pp;
 			unsigned long _pp_mapping_pad;
 			unsigned long dma_addr;
 			atomic_long_t pp_ref_count;
 		};
 	};
 	struct net_iov_area *owner;
 	enum net_iov_type type;
   };

<after> (the final form should be, just around the corner:)

   struct page {
 	memdesc_flags_t flags;
 	union {
 		...
		/* pp fields are gone. */
 		...
 	};
 	unsigned int page_type;
 	...
   };
 
   struct net_iov {
 	struct netmem_desc desc;
 	struct net_iov_area *owner;
 	enum net_iov_type type;
   };

After that, struct page and struct net_iov(or struct netmem_desc) will
not share any fields with each other, probably they will be connected
e.i. through some ways between struct page and netmem_desc tho.

	Byungchul
 
> > Yeah, you can tell 'why don't we add the field, page_type, to struct
> > net_iov (or struct netmem_desc)' so as to be like:
> >
> >   struct net_iov {
> >       union {
> >               struct netmem_desc desc;
> >               struct
> >               {
> >                       unsigned long _flags;
> >                       unsigned long pp_magic;
> >                       struct page_pool *pp;
> >                       unsigned long _pp_mapping_pad;
> >                       unsigned long dma_addr;
> >                       atomic_long_t pp_ref_count;
> > +                     unsigned int page_type; // add this field newly
> >               };
> >       };
> >       struct net_iov_area *owner; // the same offet of page_type
> >       enum net_iov_type type;
> >   };
> >
> > I think we can make it anyway but it makes less sense to add page_type
> > to struct net_iov, only for PGTY_netpp.
> >
> > It'd be better to use netmem_desc->pp for that purpose, IMO.

