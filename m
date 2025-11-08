Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B04DECCF9E3
	for <linux-mm@archiver.kernel.org>; Sat,  8 Nov 2025 02:29:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F41538E0023; Fri,  7 Nov 2025 21:29:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF0F18E0006; Fri,  7 Nov 2025 21:29:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB9248E0023; Fri,  7 Nov 2025 21:29:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C4FE48E0006
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 21:29:13 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7B150160659
	for <linux-mm@kvack.org>; Sat,  8 Nov 2025 02:29:13 +0000 (UTC)
X-FDA: 84085857786.15.10DD8D8
Received: from invmail4.hynix.com (exvmail4.hynix.com [166.125.252.92])
	by imf03.hostedemail.com (Postfix) with ESMTP id 4FE9F20003
	for <linux-mm@kvack.org>; Sat,  8 Nov 2025 02:29:11 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	spf=pass (imf03.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762568951;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aqLTzPSDEP347rMlLHkTxZWCaUtUfhrJoVmvtj8nUxE=;
	b=j7nKJfVFcL6Kqeb/CavMAcQjvEg5uDRAwYFkxLpgkksw1z2SnpI84ddfa/Yhk5VxiLqaT6
	2UtY7Wdm/ULF/r9jIF3rRyg70tc4iFemLeGf8e6/tYXyaQ74gqrPyyksITktiiWA5i7Nlj
	5fTMOF3iuFfB+bIls/+OYbEEWxn39Z0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762568951; a=rsa-sha256;
	cv=none;
	b=7U/gQrwaLmrpgFA441B91KXojG3buOZmOhw3WsySFyueoIdFJ4ksbXCwcGmS2U52taNsQg
	q8Z73/bfyBcV09NXvv65O5IrDRbgS8RibvTz8HXEB/s2VpCqBdlYBtjNxO/J/mf5ICruoW
	SpIdELJTymY6Fg/PzutQ26gxI2f9S2k=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	spf=pass (imf03.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com;
	dmarc=none
X-AuditID: a67dfc5b-c45ff70000001609-cc-690eaaf5facf
Date: Sat, 8 Nov 2025 11:29:04 +0900
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
Message-ID: <20251108022904.GA1450@system.software.com>
References: <20251103075108.26437-1-byungchul@sk.com>
 <20251103075108.26437-2-byungchul@sk.com>
 <20251106173320.2f8e683a@kernel.org>
 <20251107015902.GA3021@system.software.com>
 <20251106180810.6b06f71a@kernel.org>
 <20251107044708.GA54407@system.software.com>
 <20251107174129.62a3f39c@kernel.org>
 <20251108022458.GA65163@system.software.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251108022458.GA65163@system.software.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sb0wTdxjH/d39enc0dDkLyM8/mbOamKCCMyw+JmPRVztMTMwW4zJeyIVe
	pArVFGRgQnK4mjEczG0QSikGYrSloMSilDaiUhChxlgBzRkQFJVuU6EBV4U6WQsx890n3+/z
	fPK8eDhae1u1ijMYCyWTUczTMWqsfhXftCXs/MSw9ZmDBltbKwMtb4vB/rhTBXOtQQpszg4E
	r+dGWFjo6kMw23uLgRc9MwjONoWjC3fNGP5pm6fB4w0i+NtygYHnfRMstLj2wPj5SQxXf3LT
	MPFrPwOV5ggNXXNTLJzodETF7TILgY4qFVTPn6PBLT9mYchrY2CsdUEFk75KDAPWZgyhml4a
	xqt2Ql/jCgjffomgt81NQfiXBgbu13kpuNJ1n4U/BhsZeGoeRzDYM4Gh5l05A/VlVQgib6PK
	qdOvVVB/c4zdmSqUKQoj9LycpoXLzQ8p4YHlNywo1/yU4LE+YoVG1zGh3ZEiVCiDtOBy/swI
	rpnfWWH0wVVG6LdEsOB5skPwdM5SQuWPU8zepO/VX+qlPEORZEr7KludO2TTHz21pri6qoyS
	kT2hAsVxhE8nwx4P9YFH/T4mxpjfQLrknkVm+I1EUeboGCdGc3N7Ha5Aao7mQyyxKGOqWJHA
	F5LQtLw4pOG3k+nue4tDWn6CItfuBKmlYjkZqHuGY0zzKUR5/1c056K8mtjfc7E4jt9BZocf
	oRgn8evJjY5bVMxD+D85Io9Y8NKlK0m3Q8GnEW/9SGv9SGv9X9uIaCfSGoxF+aIhLz01t8Ro
	KE7NOZLvQtEXO1/6LqsTzQS+9SGeQ7p4TXZEY9CqxKKCknwfIhytS9R8YYw3aDV6seS4ZDpy
	wHQsTyrwodUc1iVrtoV/0Gv5g2KhdFiSjkqmDy3Fxa2SUXmtsUG94emk3dtw5jtv7Vp8cd0y
	dDgjPfgmIJ1MDmatGEAPt8mfDTVBWmg0y71vCDtzvqn0Z0Tk44fuWYwBc+mdzF2zFdf1AW9o
	937byCVxOFFs3pTWrx1pmPYnafh6de3a8jPu5My0hTUO92Zk9Z/aZV6esvfT/H9Xlp79WocL
	csXPU2hTgfgflLVW+l4DAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA02SaUiTcRzH+z+3s8XTtHrQDlpFIHTS8ZMifBH1EBW96AB7kQ/5kA/pkk1F
	O2DWKFt5dMFcCyZhzrklTNPNUmpT08wOzVqkrjS1C5U2ralUmxH57sP3evVlcIWdjGEkVYao
	VgmpSkpGyPZuObdqzDpHWvu0eyWYKm0UVPzMhrL3ThKCtiEMTNYaBIHgOxp+1zcj8Dc+puCr
	5zuC2yXjOJie6wgYq5zAwVU3hOCLwU7BQHMfDRWOPeC7M0jAgwu1OPQVtlCQr5vEoT44TMNZ
	pyU0XKWlwXOrlYQXNQUkXJ8oxaFW+56GzjoTBb223yQMuvMJaDWWEzB6oxEHX0ECNJvnw3jb
	NwSNlbUYjF++RUFXcR0G9+q7aLjWYaagX+dD0OHpI+DGVB4FN3MLEEz+DE0OFwVIuNnUSyes
	4XO9Xor3fBvB+erytxj/2nCF4L0NTzDeZeyhebMjk6+yxPF6bwfOO6wXKd7x/SrNd79+QPEt
	hkmCd32I511OP8bnnxum9s1PlG1NFlOlLFG9ZluSLKXTlJx+aWH29YJcTIvKovQoguHYDVz3
	EzcVZoJdztVrPdNMsSs5rzeIhzk6pOuqigk9kjE4O0pzBm8vGTai2AxudEQ7HZKzm7mRRy+n
	Qwq2D+Ma2oewv8ZcrrX4IxFmnI3jvL8+h3QmxLFc2S8mLEew8Zz/VQ8K8zx2Gfew5jFWhOTG
	GW3jjLbxf9uMcCuKllRZaYKUunG15nhKjkrKXn30RJoDhU5058zUFScKdO50I5ZBytnypEm5
	pCCFLE1OmhtxDK6Mlm9UzZYU8mQh56SoPnFEnZkqatwoliGUC+S7DolJCvaYkCEeF8V0Uf3P
	xZiIGC26u3uxb3uU+tPeZ4m+FsUPMnJWQ6m1+oD+uceh3b+j48se5tQZC1Z4+LTQdD5xoqhd
	78y8bB+oQFDVX9S0uF0Rqdu2Itjfg4wLZE93JyxZtOnsCNIzNnNXep5tvf/g0pLAQLnksLRl
	oEfpbaWG2yahxG5XqOSDS+6/6Y11BZSEJkVYF4erNcIfMczgx0ADAAA=
X-CFilter-Loop: Reflected
X-Stat-Signature: anu6hd9inq4z93gr78t5gcbo6bimcqfx
X-Rspam-User: 
X-Rspamd-Queue-Id: 4FE9F20003
X-Rspamd-Server: rspam01
X-HE-Tag: 1762568951-155884
X-HE-Meta: U2FsdGVkX18KwTrJNTRXjIqX8BVrxQ0rRzKulnjr2LZYhidNqmdVp5JIlwsOp39l0oWZE3xlzz7PbqNkpcO5cnhJ/u5TzecyDR9wlFXCzCGPX/SEvtKT/nlSBF9PDgWi9YAvm1yXXvkk+xY/1HjYm7IV/K1v2TmCQkhQpdGpoycwOmzR+WQ88TmkuqRewBvfbzu2PUitLXRhowjUfYBhvHdpK3DIleWiZlLmCQpI7s5bRQfhvxIRAwlxzlJI0FH5bcq8wwKBhsu3QKt2b+8z0PDKm+uOAeAXKMsvfZONcNdKEAbX9RsCoeMeh0+VHK017LBXbqHbou6RisR6uiKopFdjDzMn/piW67vfX3YfdlgIqLObzAgKYuU1IXfbAR40hBiW4ZqB9NOVLG/TXgUuYD+K/jZtkuPVBY4wU4UbQUDMi6dcgkiARejP7VSV0dlIJm45958O/zcgEFesBi63DDuRDqJ/Gnrp8YISS0+O0G+lB45gW9KeFrlfMEfYHWIF9U0Pj/i3m/fP4W4NhB/DCun8labh61VEzjYF6vlRBvffJ/K6LOmSxAeUvgDwevmRpR3jDfiEQ9Ek3EffVhlmx5cv6b6+dIHeKEpGAAF46l4Qj/ycDpkvaW8pMC3AUyzJYODdS+RdwH1RDG280vAblcDHLjZbTLKsSiYy7H34W7IiOJV4qrhQBz8N2FsUwtdqT82fHv1b9g4b12AnWCIoOsnjZ3W6hG4+WHF4Km0KrVh6fZQ5rfhp6GfDz+bPdgYT5KUFg62dflf4Fb6B2dXHRmBFH0FQIguY6ckpdnF1GeXjxlo0yoVJO3N+utkHSacRfr+EPH0j1c4cFiLxRsgy7TgAItt4hohcsDkvu3fUWlpJg+rKP147//SKYNX5DHdCFCo1rEiTKlb5veoopSsQTSe5zYx2AJWJGs6M2G+UhGvRi755umOxl1SEhpIVkthofkxf9gwYRLt9OzjexrO
 kRz2TrBx
 1pz9cFKbBWXQV1hqh1+RfRF075OqTQZUCxdzq
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Nov 08, 2025 at 11:24:58AM +0900, Byungchul Park wrote:
> On Fri, Nov 07, 2025 at 05:41:29PM -0800, Jakub Kicinski wrote:
> > On Fri, 7 Nov 2025 13:47:08 +0900 Byungchul Park wrote:
> > > The offset of page_type in struct page cannot be used in struct net_iov
> > > for the same purpose, since the offset in struct net_iov is for storing
> > > (struct net_iov_area *)owner.
> > 
> > owner does not have to be at a fixed offset. Can we not move owner
> > to _pp_mapping_pad ? Or reorder it with type, enum net_iov_type
> > only has 2 values we can smoosh it with page_type easily.
> 
> I'm still confused.  I think you probably understand what this work is
> for.  (I've explained several times with related links.)  Or am I
         ^
Please don't mind.  It's not a blame.

	Byungchul

> missing something from your questions?
> 
> I've answered your question directly since you asked, but the point is
> that, struct net_iov will no longer overlay on struct page.
> 
> Instead, struct netmem_desc will be responsible for keeping the pp
> fields while struct page will lay down the resonsibility, once the pp
> fields will be removed from struct page like:
> 
> <before> (the current form is:)
> 
>    struct page {
>  	memdesc_flags_t flags;
>  	union {
>  		...
>  		struct {
>  			unsigned long pp_magic;
>  			struct page_pool *pp;
>  			unsigned long _pp_mapping_pad;
>  			unsigned long dma_addr;
>  			atomic_long_t pp_ref_count;
>  		};
>  		...
>  	};
>  	unsigned int page_type;
>  	...
>    };
>  
>    struct net_iov {
>  	union {
>  		struct netmem_desc desc;
>  		struct
>  		{
>  			unsigned long _flags;
>  			unsigned long pp_magic;
>  			struct page_pool *pp;
>  			unsigned long _pp_mapping_pad;
>  			unsigned long dma_addr;
>  			atomic_long_t pp_ref_count;
>  		};
>  	};
>  	struct net_iov_area *owner;
>  	enum net_iov_type type;
>    };
> 
> <after> (the final form should be, just around the corner:)
> 
>    struct page {
>  	memdesc_flags_t flags;
>  	union {
>  		...
> 		/* pp fields are gone. */
>  		...
>  	};
>  	unsigned int page_type;
>  	...
>    };
>  
>    struct net_iov {
>  	struct netmem_desc desc;
>  	struct net_iov_area *owner;
>  	enum net_iov_type type;
>    };
> 
> After that, struct page and struct net_iov(or struct netmem_desc) will
> not share any fields with each other, probably they will be connected
> e.i. through some ways between struct page and netmem_desc tho.
> 
> 	Byungchul
>  
> > > Yeah, you can tell 'why don't we add the field, page_type, to struct
> > > net_iov (or struct netmem_desc)' so as to be like:
> > >
> > >   struct net_iov {
> > >       union {
> > >               struct netmem_desc desc;
> > >               struct
> > >               {
> > >                       unsigned long _flags;
> > >                       unsigned long pp_magic;
> > >                       struct page_pool *pp;
> > >                       unsigned long _pp_mapping_pad;
> > >                       unsigned long dma_addr;
> > >                       atomic_long_t pp_ref_count;
> > > +                     unsigned int page_type; // add this field newly
> > >               };
> > >       };
> > >       struct net_iov_area *owner; // the same offet of page_type
> > >       enum net_iov_type type;
> > >   };
> > >
> > > I think we can make it anyway but it makes less sense to add page_type
> > > to struct net_iov, only for PGTY_netpp.
> > >
> > > It'd be better to use netmem_desc->pp for that purpose, IMO.

