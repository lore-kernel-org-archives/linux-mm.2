Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB78ECD4851
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 08:54:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC35A6B0088; Thu, 14 May 2026 04:54:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A4C506B008A; Thu, 14 May 2026 04:54:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 914CF6B008C; Thu, 14 May 2026 04:54:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7CDD06B0088
	for <linux-mm@kvack.org>; Thu, 14 May 2026 04:54:15 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1DB81A0210
	for <linux-mm@kvack.org>; Thu, 14 May 2026 08:54:15 +0000 (UTC)
X-FDA: 84765413670.02.BA470CA
Received: from invmail4.hynix.com (exvmail4.hynix.com [166.125.252.92])
	by imf29.hostedemail.com (Postfix) with ESMTP id 820BF12000B
	for <linux-mm@kvack.org>; Thu, 14 May 2026 08:54:12 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	spf=pass (imf29.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778748853; a=rsa-sha256;
	cv=none;
	b=YvKmYLfa6m7AWBdFFmbs1e/bhA9r+urzfxMukFoMDvQAJ4hDzC3AUEmVbSOAWekY63yfG6
	FH/MCgvcRKQVAGR181Pu/eYOP1BOT9POMZ1LJxtrHaEVJ+MrUMKrUZS5zK1nyY+s4zcTHg
	dTqKVaAN4tN64hp5z/qi8N7tB/wHnjs=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778748853;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FXrrJfYwEU2FAOHmU+jM5DY4QdCpDFOGg0PGkWGeZwY=;
	b=l/+2aNnjmeKeEZwbRYVgxuzWmPs33R48Bs1brIGc47zId15/YYMwMqeuMlOjhjiah25v4V
	yp1OrqQqC+MiU73Ia3uOKrCE9Id+jS76/8qHIy7YiPUQVgljWtbRgUg/EPDMcKYKj/2U6l
	tKqBb1KhR5dZ02+iODfaLBOOoinWsjY=
X-AuditID: a67dfc5b-c45ff70000001609-42-6a058dafad9a
Date: Thu, 14 May 2026 17:54:02 +0900
From: Byungchul Park <byungchul@sk.com>
To: Dragos Tatulea <dtatulea@nvidia.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>, linux-mm@kvack.org,
	akpm@linux-foundation.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel_team@skhynix.com,
	harry.yoo@oracle.com, ast@kernel.org, daniel@iogearbox.net,
	davem@davemloft.net, kuba@kernel.org, hawk@kernel.org,
	john.fastabend@gmail.com, sdf@fomichev.me, saeedm@nvidia.com,
	leon@kernel.org, tariqt@nvidia.com, mbloch@nvidia.com,
	andrew+netdev@lunn.ch, edumazet@google.com, pabeni@redhat.com,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	horms@kernel.org, jackmanb@google.com, hannes@cmpxchg.org,
	ziy@nvidia.com, ilias.apalodimas@linaro.org, willy@infradead.org,
	brauner@kernel.org, kas@kernel.org, yuzhao@google.com,
	usamaarif642@gmail.com, baolin.wang@linux.alibaba.com,
	almasrymina@google.com, toke@redhat.com, asml.silence@gmail.com,
	bpf@vger.kernel.org, linux-rdma@vger.kernel.org,
	sfr@canb.auug.org.au, dw@davidwei.uk, ap420073@gmail.com
Subject: Re: [PATCH v4] mm: introduce a new page type for page pool in page
 type
Message-ID: <20260514085402.GA63255@system.software.com>
References: <20260224051347.19621-1-byungchul@sk.com>
 <982b9bc1-0a0a-4fc5-8e3a-3672db2b29a1@nvidia.com>
 <4af19eda-c29c-4302-92d5-c0915267fc0c@kernel.org>
 <agRB2QTbzceRgpzX@pedro-suse>
 <1817a749-8232-43ab-a0f5-350e5aade235@kernel.org>
 <f3e38c07-d410-4c8e-a572-68d52dc55353@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f3e38c07-d410-4c8e-a572-68d52dc55353@nvidia.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sb0yTVxTGd9973z80NLmrIlfIvnTZVNwcI8YcDTNqdHmNczHq1OgHbeQV
	ilBMEQQXQx0kKlp0MDYo1VSZBWsNWoS2BAwDVkBiNBjIKyooGzI3hg5NQ4HAKMbotyfP85zf
	OR+OhHU9fIxkNB1WzCZDml7QEM2/kRc/v27lU+P7/hPBXuMW4Op4DlQ98fEQcg9zYHfVI3gd
	eijCTFMAwau2dgH+aR1DUHkxiMF+t4DAcN0EAn/DMIK/y64JMBQYFOGqZzMMOJ8RaDzhxTB4
	tkMAa8EkhqbQqAg/+KpnwbUWEe7VF/Hw08RlDF7LExHuN9gF6HfP8PCsxUqg03aFwMvSNgwD
	RWsg4FgAwa4RBH9V2UVoq/FyEDxzXoCe8gYO6pp6RCjpdgjwR8EAgu7WQQKlUycFOPl8gEDF
	8SIEk+Oz8NFzr3mo+L1fXBMvH1dVQW4deYHlm1cecHJv2Y9EVm/d5mS/7bEoOzxZcm11nFyo
	dmPZ4zolyJ6xYlF+1NsoyB1lk0T2P10p+32vONmaPypsWbBbk5ikpBmzFfMXq/dpUn5Rm7hD
	16NyTlcOYQt6RAtRhMTocmZ3Wvi3+n7d9KyWJEI/YX1dyWFboIuYqoZwWM+ni5mlroQUIo2E
	aZ/E8ptDJBzMo1vZbVvFXElLgf1a6sfhko5e5pj7VLn4JviQdZb/OTeAaRxTp59z4WWYxrKq
	aSlsR9DVzO2qnONE0Y9Zc307F+Ywmh/Bit0z4ptDF7LfqlVyDlHbe1jbe1jbO6wDYRfSGU3Z
	6QZj2vJlKbkmY86y/RnpHjT7bM5jU3t8aOzethZEJaSP1DYnk1Qdb8jOzE1vQUzC+vnaswGU
	qtMmGXKPKuaMveasNCWzBcVKRB+tTQgeSdLRZMNh5aCiHFLMb1NOioixIGf9qoQhW8JivChx
	5TcfNN4w73KRrEuxtZuXPrXG7Hu4cfd3U5vyqh3+SOOWl+fTx+5s21XoSo7+3uv+bN26DQfO
	lGy64N3vXRt9pzxRd/NozaepEwkjeXk5K/Z27fiKj+r/OWqnaXswvtMXM961hC2MFBovfHs3
	d+N6m/PrwORIsf2jJD3JTDF8GYfNmYb/AbHJpGtoAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA02SXUhTcRjG+Z//+XK1OC2tk93EIipDS8p4o5DqpkOgfUAFdZErD25+FZuZ
	BtFMo2nNj0rUbYGhpenEmk0307LN/LwoFO1k5XKVZolFijgtyxlRdy/P8/ye9+ZhsaKBCmY1
	ySmiNlmVqKRlpCx6R2ZorZGK3+x7EQaWWisN1dNpUPHOQYHPOkKApaoewaTvNQO/mtsQTLS2
	0/DF/R1B2e0pDJbnWSSM2GcQOBtHEHwurqHhY5uXgWpbFHjuDpPQdKUBgzevgwZj1iyGZt84
	A5cclfPFdXoG3Lc6KXhRn0vBzZk7GBr07xjobbTQMGj9RcGwy0hCp+keCd8KWzF4cndBW+ly
	mOoeQ/CpwsJAa20DAVPXbtHQV9JIgL25j4EbPaU0vM/yIOhxe0ko/GGgwTDqIcGckYtgdnq+
	fDx/kgLzs0FmV7iQIUm04B77ioWH914RQn9xASlIj7sIwWl6ywiltrNCXWWIkCP1YMFWlU0L
	tu/XGeFNfxMtdBTPkoJzaLvgdEwQgjFznD6w4phsZ6yYqEkVtZsiY2TqIqmZOHM/KO1q2Ues
	R2+4HBTA8txWvtc+R+UgliW5tfxAd5xfprl1vCT5sP8O5NbzevsNMgfJWMwNsHxmi4/0G8u4
	Q3yXybwQknPAlxc6sT+k4O4QvDW7hPljLOU7Sz4sAJgL4aW5UcL/DHOr+Io51i8HcJG8taps
	oSeIW8O31LcT+Uhu+o82/Ueb/tGlCFehQE1yapJKkxgRpktQpydr0sJOnU6yofk53b3wo8CB
	Jnv3uhDHIuVieUscGa+gVKm69CQX4lmsDJTntaF4hTxWlX5e1J4+oT2bKOpcaBVLKlfI9x0V
	YxRcnCpFTBDFM6L2r0uwAcF6ZF23dvqgunsmqMvr+mbuiz5cPpbX8qiya2u7frAj43Pokghp
	X9T+vT+L+suNF92GrNUO5RaUlxs8tK3bVr1Bm23e0+5RPh0JX2I4t1L5Mn74mmJgfwosGnuS
	Mj205bK9pt+Qdn1UfTIq+ub5Pu/Go51HYip3F2Wsjwu2RUTsOf7gp5LUqVXhIVirU/0G+OL6
	okoDAAA=
X-CFilter-Loop: Reflected
X-Stat-Signature: 8uqmozbda3oy4mwp351uqo9egk7tgchp
X-Rspam-User: 
X-Rspamd-Queue-Id: 820BF12000B
X-Rspamd-Server: rspam07
X-HE-Tag: 1778748852-604330
X-HE-Meta: U2FsdGVkX1+Q4/ZdzQFqslx6AGKM/L/B8A5AfPfTkU2vDTYC8npazYBBKYzAAuceMWSIIutD0OsY1/wlF/5jyhTgrCqElaDSHwM8Mn0UgADDDOoA2cXWBSv7FMePvkI0wCYpVCQ96MY0Rb1/rSlBEG6/qncfXD2Xk1dOvJ8QeVymHjHS7bEnU2a9BT2EpRvu4Ulohlfe3nohbmKaSevt+W1Ngr2IVzlhAhSPA6Alpxd9iPqXGcCMkuzjyuuIqOl74mG37WwFT66VZ+u1Xrom6kyN5juP8ul+gqPhDtgEyJVewtsTiCyygoNOHfELHpkl+hrG470y1SHTmhRjHBcwtLTBrZzWmOcVWeGpU8y3wZPOPoXRZYLsMgbaFnrUURKafHH0WmkkllP6xTCng+fAJ0cW0GviV1Hd7yzpMrQT65Nwuw0dXSYOeUxTgMCzcwfgUay66/Us2WNSeuYr/sAQnUzuaAJN2WXhStwvdRETG8dnrC23hvWxyJPWaNbbObDOOacSXXb5a3AxShwTRDihD/nhksymfo9//9jrUBSfO61Db8GwABG9ZikkLchE4qbA8PePx3OXmcmqwllr70e4VR9PmFsFBja3gH2pCXYqnDTXUrRNqhlFKEWTBVUwN6QfSVf9EJjPGXu2msp+FeBDXIUoufawJO7YtP+KA2a319SLAIMbkL097eg3qXD5Knif42zbVZ149DFvmZ7IOR5m5QpBJvH07aK7m4O8X8PUyVT/rGSbrfF0m5iF1bh8aRsUNoiCxz4cYJaEk97viDRdOJZSiEMlFU8TR7wVFWI1937pd2FlariZtfqzZBxQNvqnSx6nmj80zaKzHcHg494jIlH5xan56W3pMU/V8+h5frDG6nIssjcS9IpPPbxEDe/Kf11jGl05cLzrXLeN9K3gsGv+QD5tyw8NPnNC0zMCw2eHSJM9G4OkeOzcUngabsjxXKzGTDnlrip7GqjieC0
 kgoExbGk
 EmybvAmtEx3WxGzMKc+Apl/4xDw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 13, 2026 at 02:06:06PM +0200, Dragos Tatulea wrote:
> On 13.05.26 11:36, David Hildenbrand (Arm) wrote:
> > On 5/13/26 11:26, Pedro Falcato wrote:
> >> On Wed, May 13, 2026 at 11:12:43AM +0200, Vlastimil Babka (SUSE) wrote:
> >>> On 5/13/26 11:00, Dragos Tatulea wrote:
> >>>>
> >>>>
> >>>>
> >>>> Seems like this patch broke tcp_mmap because
> >>>> validate_page_before_insert() returns -EINVAL due
> >>>> to a page having a type. Here's the full flow:
> >>>>
> >>>> getsockopt(TCP_ZEROCOPY_RECEIVE) returns -EINVAL because of the
> >>>> below flow in the kernel:
> >>>>
> >>>> tcp_zerocopy_receive()
> >>>> -> tcp_zerocopy_vm_insert_batch()
> >>>>   -> vm_insert_pages()
> >>>>     -> insert_pages()
> >>>>       -> insert_page_in_batch_locked()
> >>>>         -> validate_page_before_insert() returns -EINVAL
> >>>>            because page_has_type(page) is now true.
> >>>>
> >>>> The patch below fixes the issue. But is this a valid fix?
> >>>
> >>> Hmm the check traces back to commit 0ee930e6cafa0 "mm/memory.c: prevent
> >>> mapping typed pages to userspace"
> >>>
> >>>> Pages which use page_type must never be mapped to userspace as it would
> >>>> destroy their page type.  Add an explicit check for this instead of
> >>>> assuming that kernel drivers always get this right.
> >>>
> >>> So uh, this doesn't look good I think.
> >>
> >> Yep, you fundamentally can't map a page with a type as page type aliases with
> >> mapcount. Even with the given diff, just mapping it will increment the mapcount
> >> and wreak havoc. I think we need to revert this patch for now.
> >>
> >> I'm not sure what the long term plan for this would be. If page types are moved
> >> to memdesc types, then the two stop colliding and that could work. I don't know
> >> if that's Willy's plan, however.
> >>
> >> (then there's the other question: are page pool pages really folios? not really.
> >> they are mappable, but they aren't part of the page cache, or anon, nor are
> >> they in the LRU or have rmap capabilities. perhaps we need a different memdesc
> >> for those. we're one step away from reinventing class polymorphism from first
> >> principles ;)
> >
> > Zi Yan is working on this: non-folio pages would no longer mess with
> > rmap/mapcounts, and page table walking code will identify them to be non-folio
> > things to skip them.
> >
> > It will take a while, though ...
> >
> So do I get it right that the path forward here is to revert this commit [1]
> and wait until the work from Zi Yan is ready?

I think it's the best way for now.

	Byungchul
> 
> [1] db359fccf212 ("mm: introduce a new page type for page pool in page type")
> 
> Thanks,
> Dragos

