Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE7F0CCF9E0
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 10:23:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BDEEC80136; Tue, 28 Oct 2025 06:23:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB68280131; Tue, 28 Oct 2025 06:23:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ACC1380136; Tue, 28 Oct 2025 06:23:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9BB1280131
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 06:23:38 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 31BE413A92A
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 10:23:38 +0000 (UTC)
X-FDA: 84047136516.02.EBA3039
Received: from flow-a2-smtp.messagingengine.com (flow-a2-smtp.messagingengine.com [103.168.172.137])
	by imf20.hostedemail.com (Postfix) with ESMTP id 1D4771C000A
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 10:23:35 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="O yq2398";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=aeNQs7Ux;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.137 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761647016;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UK17jhjkP7w/Yhqq+kaU6aiIJY1JQ7Cu6uzfy7TYG8U=;
	b=4KPU6v9VJwPMe6WNw3X0JwBUIzMoFQBkUIFdEYrmxWy9OzZZxPuff1WxiBeFscIBBlBF6E
	fXvs+QKeKHBsCbpTiekiTHwR3mprg1kGNAJDC8XvbJm1JCR0n0HgluH146JzYAeu/a9uVh
	OjiMrgNL/F6CZBXm1Jnr+DYEzVEZc54=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="O yq2398";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=aeNQs7Ux;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.137 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761647016; a=rsa-sha256;
	cv=none;
	b=4aTQUFi1pMMCqKKytPDKPMOTozK4r/oR/HfJOqcZYCMj9qCDre/Jxis2p55v4qO2Di12QF
	szftOc7jANd2fojW3Tz61tWCqdRG2v5911wpA51rm2brdBS0Ro59uvFjIQreXPLrlrolnV
	1RAoOgecmRG6EVrT5qiVzG5fDcsMmiM=
Received: from phl-compute-08.internal (phl-compute-08.internal [10.202.2.48])
	by mailflow.phl.internal (Postfix) with ESMTP id 5AD1C13804E9;
	Tue, 28 Oct 2025 06:23:35 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-08.internal (MEProxy); Tue, 28 Oct 2025 06:23:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1761647015; x=
	1761654215; bh=UK17jhjkP7w/Yhqq+kaU6aiIJY1JQ7Cu6uzfy7TYG8U=; b=O
	yq2398ecmmEuY3UtO8v4pVZOsMw+yhMLoegZU4hLWk11TkY/gqsHOQ88s2w0IfZJ
	tTlo/xf7YkKlurbMt1ddus4f6CtbmZPrVSTbpazCNqoQzH0RCawN5E6OBmJSdc4K
	SvlQeYYqqhkBbG24J6jGiAf3El4r5Gj5ltbwsS6vNUyYt9tRJ2poCTlRPnc+wpTw
	S8mqE8i1nk5e2F5yvLQZZ5v41eDvZVXl9aBmRgEb2hTlHQoMYSeMlEiLDeW9PR2A
	NVotO2dDnjvDMAa39/IQPwHL2AxThZ8rkVfgO1kOj9sBJ7mwFSVo7BgoxmNJl9Ly
	2FHpMtpLP332NCe5/0l9Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1761647015; x=1761654215; bh=UK17jhjkP7w/Yhqq+kaU6aiIJY1JQ7Cu6uz
	fy7TYG8U=; b=aeNQs7Uxdv25R8tKlW04ilnqa5rPAHwr4fcUjxCwJvVP1ad8qj2
	1z85/e4syV2HzFJK+ALQ/aUegRZviRFaoEPNjJZw5TVbx7yr6X8mhMaZKe+uHJCy
	Sdcoy8ZcbwSBDYMz9i8Mh/aB3FsRtPg/luWgu5otcE2PnmNifIJYraFHdleMXHiW
	v29Rrp+xy3+W8xRoT//lGNQPWv2btp3ZxMPBcCiA7HHe/i7Q7PULVXn2llfMc4Ad
	n1Vl0qFLKkkltWiwGyI7iKLELxhhzPL6vin42vmiXTknkQhntvyH4NT7Mjg9ry20
	OqEzOy/UFaFLGPx00wvfPdrs7VPIETQp02g==
X-ME-Sender: <xms:pZkAafIf2z9PVZDiPFfpzMGBxMOfTPNX51G3oFci-vv5Ey9b5N6uFg>
    <xme:pZkAacMbioO9zVqztgLKA3TFWp99m5nzxX951njeqyGQNrDUTUOyfn7EyBPFtJimY
    eGw0c-kIqZFeAR1RZ8bkh30YgYbjWaN-9pVZ0WSNsL30yff3baP2Es>
X-ME-Received: <xmr:pZkAaaoaJLt-OhH12Rhvmumgke5P8QJd0NMn2tsHV0YrOXnzbjOoAaKTdm3PEQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdduiedtiedtucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtsfdttddtvdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkihhrihhllhesshhhuhhtvghmohhvrdhnrghmvgeqnecugg
    ftrfgrthhtvghrnhepjeehueefuddvgfejkeeivdejvdegjefgfeeiteevfffhtddvtdel
    udfhfeefffdunecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrh
    homhepkhhirhhilhhlsehshhhuthgvmhhovhdrnhgrmhgvpdhnsggprhgtphhtthhopeeg
    gedpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtoheprghkphhmsehlihhnuhigqdhfoh
    hunhgurghtihhonhdrohhrghdprhgtphhtthhopegurghvihgusehrvgguhhgrthdrtgho
    mhdprhgtphhtthhopehhuhhghhgusehgohhoghhlvgdrtghomhdprhgtphhtthhopeifih
    hllhihsehinhhfrhgruggvrggurdhorhhgpdhrtghpthhtohepvhhirhhoseiivghnihhv
    rdhlihhnuhigrdhorhhgrdhukhdprhgtphhtthhopegsrhgruhhnvghrsehkvghrnhgvlh
    drohhrghdprhgtphhtthhopehlohhrvghniihordhsthhorghkvghssehorhgrtghlvgdr
    tghomhdprhgtphhtthhopehlihgrmhdrhhhofihlvghtthesohhrrggtlhgvrdgtohhmpd
    hrtghpthhtohepvhgsrggskhgrsehsuhhsvgdrtgii
X-ME-Proxy: <xmx:pZkAaVcmuoFOvpGn3Uz-xLEZc1b_jDMyz64KfQDHAR1DXH-3MKRbLQ>
    <xmx:pZkAaTYCkg2qKMGZ2THGUM8vd79QZcQ0YzJ8J6Bd6MDHRD1e-6il5g>
    <xmx:pZkAaYDejv_qtoU15rmab71AbT-j3eES7oTYbfrSLWotLGLj1yHZtg>
    <xmx:pZkAaeBxk3_GzD-n6Gd3d__P3Y6pW2xbGQf4bWFXxOH3ng6K2eIaVQ>
    <xmx:p5kAaVDfUtv4zhKA7dAX3VaSUQU0e1M0bHcFyALgEp1w2qPlYhc91wix>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 28 Oct 2025 06:23:33 -0400 (EDT)
Date: Tue, 28 Oct 2025 10:23:31 +0000
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@redhat.com>, Hugh Dickins <hughd@google.com>, 
	Matthew Wilcox <willy@infradead.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Rik van Riel <riel@surriel.com>, 
	Harry Yoo <harry.yoo@oracle.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Darrick J. Wong" <djwong@kernel.org>, Dave Chinner <david@fromorbit.com>, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 1/2] mm/memory: Do not populate page table entries
 beyond i_size
Message-ID: <hw5hjbmt65aefgfz5cqsodpduvlkc6fmlbmwemvoknuehhgml2@orbho2mz52sv>
References: <20251027115636.82382-1-kirill@shutemov.name>
 <20251027115636.82382-2-kirill@shutemov.name>
 <20251027153323.5eb2d97a791112f730e74a21@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251027153323.5eb2d97a791112f730e74a21@linux-foundation.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: 1D4771C000A
X-Rspamd-Server: rspam03
X-Stat-Signature: 7xr81g74xkgc5u1zodd63pfazh3htn7u
X-HE-Tag: 1761647015-135102
X-HE-Meta: U2FsdGVkX18YF6yay89rKcoLoLHRm1NSqyxvv+eycQ57CzJzD3UgTA3Jx4OuKauvO2UsDlg+fDzp6qF7XCTuRUpAEYUvZZ/Y6L9L4gZq5mAtm/96KlNKErUA7PrXSMEF9auiU/31xg+gjP0U8HRWL4IbVjMF1sDcEpFvcb1PbgGOyTX4rfrNYr64MOvWKiCISnUN04C77UbUr565OzSQwEIY3Jlm+4nQtOtZaaIFwGvhsVA4t+Xj7RgP+mIVRnPK6uW3MNTcUPkgdyczKTYxx2gVn37vo/CAY5v0vD3zJBZ7WwktaER5I8JVftq3otF4ktyIG1ossAIMuMtV3/t1AoCfI5qrFsy3Nh4/dmfou6+HFKvWFwdes2IQ3X7xnEV/ooUgo0CsJt55dB1yuVZAl5ICZG3Bj0ylSlnzXoxjCi2cPn8BFTIHKxS7ePdj8yskSUBrEquUx/ntElguAdLxKoH5bm19iQMIsVSSuThBvpWceCRRJpVGHU6swGi2iL9Wjm0ILHIdgQMauo95c3JhJeXrlbNdRiNOYWrgdhyHdSBoMJs2FqR8ZtH9EsHRjhUahMhrq2y4V7BcmXThg9vneI7kh+hPh3aMQvm15ZlSLVgZxz6yMKt4OkG6MotxR9CDibPegg0i0atOdvqvLtugYEcTN7TQACxi5UnhZyq9/uPBp2ZEt6IATbfDe3I6h9DxEwDp4yK5OZPnJQfoR3nJHmdsPwNJRK3L/VVkt7VtNo1bNyNlETdA7+D2tKs/2pdX7LyVPCK8Vd69NFAAz/F9g3lPLdVUsEUoVBo2k1oMCea0y+oNIa0mDUhMJaojEP+A73oe76slbnW4xX5SEpo4T+YW8Fopuc/ZYfkCeKPAtXHlnPxmOG7XNBLCAfgZMFNfhC0uES+I3QIrOnZfpAaRBrbH9QGWDc2cfn4rWXIduSh3wyT7Y9Ka1NabexNaPpql3gL4rpfUJJ0P6NGv778
 clRDjJFV
 MFaIujqP0gWlmYMVS5f0xiex/sr8Yeuo0qqqcbA4Lqke1nwGIANdpEgYrWg4lXtY1j9pfG5e0mSWDEWJa6kIyQ6trrvvQpKwR5afHylQI0MHkUEdJ6+751WX4SHEjRlkjvZ6ar9JNOY2mxrUNVZSjKco8dZ0fMYalQH2kC8pDKAwppVe99lkH/+qPBzK5Ptlgf4ZICXhJSu2Yoh67/pfZis0WfoKRzP+3uB3FeKB7/y171BfUjHgUDxWfv72euUzCiGEj/7xewXeiGvzSIn2g6Bax27cZg/ioATpxL25H/BPvHCnIlc7C4g/oA5yC5kLuEqOjcvFWG2D5s3ChKeJxrxizP+rIqFPMWg2t52DHh3cUN7gVGllxmLOTqmPrCCgNIPB7ntXBC2d5Q3djqNAukJXffamWN9TeLr07UXimTF8a+qKFUqKE24z44458ZIVcLSXAIb1XrBzOrNGfDuq9Ir4vUJjor2rzU7dtAJqa/OdFwctyjYZb+Pe5VUc+ktQKy1XRhAaubwwrN8M=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 27, 2025 at 03:33:23PM -0700, Andrew Morton wrote:
> On Mon, 27 Oct 2025 11:56:35 +0000 Kiryl Shutsemau <kirill@shutemov.name> wrote:
> 
> > From: Kiryl Shutsemau <kas@kernel.org>
> > 
> > Accesses within VMA, but beyond i_size rounded up to PAGE_SIZE are
> > supposed to generate SIGBUS.
> > 
> > Recent changes attempted to fault in full folio where possible. They did
> > not respect i_size, which led to populating PTEs beyond i_size and
> > breaking SIGBUS semantics.
> > 
> > Darrick reported generic/749 breakage because of this.
> > 
> > However, the problem existed before the recent changes. With huge=always
> > tmpfs, any write to a file leads to PMD-size allocation. Following the
> > fault-in of the folio will install PMD mapping regardless of i_size.
> > 
> > Fix filemap_map_pages() and finish_fault() to not install:
> >   - PTEs beyond i_size;
> >   - PMD mappings across i_size;
> > 
> > Make an exception for shmem/tmpfs that for long time intentionally
> > mapped with PMDs across i_size.
> > 
> > Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> > Fixes: 19773df031bc ("mm/fault: try to map the entire file folio in finish_fault()")
> > Fixes: 357b92761d94 ("mm/filemap: map entire large folio faultaround")
> > Fixes: 01c70267053d ("fs: add a filesystem flag for THPs")
> 
> Multiple Fixes: are confusing.
> 
> We have two 6.18-rcX targets and one from 2020.  Are we asking people
> to backport this all the way back to 2020?  If so I'd suggest the
> removal of the more recent Fixes: targets.

Okay, fair enough.

> Also, is [2/2] to be backported?  The changelog makes it sound that way,
> but no Fixes: was identified?

Looking at split-on-truncate history, looks like this is the right
commit to point to:

Fixes: b9a8a4195c7d ("truncate,shmem: Handle truncates that split large folios")

It moves split logic from shmem-specific to generic truncate.

As with the first patch, it will not be a trivial backport, but I am
around to help with this.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

