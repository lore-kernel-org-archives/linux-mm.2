Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0A8BCCF9E9
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 10:22:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5235A8E0060; Wed, 29 Oct 2025 06:22:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D3E48E0045; Wed, 29 Oct 2025 06:22:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39C4A8E0060; Wed, 29 Oct 2025 06:22:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 252338E0045
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 06:22:00 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D4729140611
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 10:21:59 +0000 (UTC)
X-FDA: 84050761158.20.0A2A60E
Received: from flow-a6-smtp.messagingengine.com (flow-a6-smtp.messagingengine.com [103.168.172.141])
	by imf15.hostedemail.com (Postfix) with ESMTP id E69ACA0003
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 10:21:57 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="c 55cm50";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=i9JbQrZh;
	spf=pass (imf15.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.141 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761733318;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IjPlh4vPDtY5DoDvg9FkkduZZQivHp+ZM+sz98NMyF4=;
	b=aRAp6CbbnOlGY8luX8tdJ61F3/R5j0EgLEny7TJqTE3iaRjuWboo4ku0EP0UFTAFUqM3gy
	WAYS1FEnmka7tXJI1FBuHuqm2aUTWSpfWoE0YJwMNFoueTiwqDQAbpMkbKkxKSx+0f8Ypo
	Ta/JEAwVY72ulpsurYtrJEou6RC09Mg=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="c 55cm50";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=i9JbQrZh;
	spf=pass (imf15.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.141 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761733318; a=rsa-sha256;
	cv=none;
	b=lyX8cGkkTpzRBy8zFZ6sP8MgKwwxP24jSj7U2sF72D/6wA5SlocAdGmwitTAnM7h8N1K76
	ghmN6WIVwuHZxLK7RRBzXiatVUQiBZGpJCEGieilSf54zvOyZOrFuLvk3QN08WmjNN2nYL
	v0YAskZ1X1qMVwejDRzmTb7dGeNER/I=
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailflow.phl.internal (Postfix) with ESMTP id 4FB5C13800EC;
	Wed, 29 Oct 2025 06:21:57 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Wed, 29 Oct 2025 06:21:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1761733317; x=
	1761740517; bh=IjPlh4vPDtY5DoDvg9FkkduZZQivHp+ZM+sz98NMyF4=; b=c
	55cm50oklPwOjk9DkdI/bM8yFEQbGwn/K/8ghiVrCZVJngXm1qK8CcMsuwP1veTB
	PX5EhQ694qIQH47nh8wpfFJZDXbPCbpGUyaK4HAKH6GSr2tCS7XGdBVra64X5wIV
	Pr2TCI4pswlJ0LUqK/pO73khpgiBq0mX0AugBqTHBrcWlCcB7rdSHsiDYGT6p7ZK
	+AeBonwr25hyCBiDj3We5HXoJYxPAJwbtJSdAwy/Eny49KZ08WDRclzFYEvCeScl
	r12wUGZ+52DghWuTDYFs2rUDaRqgj9mzKkO/aPAfvmbynyaWFT8dleE07v8pNLmj
	CNaUPh3K/8gLTW5aDEhMw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1761733317; x=1761740517; bh=IjPlh4vPDtY5DoDvg9FkkduZZQivHp+ZM+s
	z98NMyF4=; b=i9JbQrZhAzMnl2+U+McrmCMks9t7FgRB70Kdy0r6X3KlXI4pr01
	O7zS+zM8/l9xplrJRJvf+pH9MSCC5uL/LuyxSRfBrxcA+yhxQl74QkaUAS6i+Cad
	wtRkntu5imMfyfFQHfl+SpcAU35bXC1DJyUiDb27+eXI5G9U/KLSjFaNPTHeybVq
	BujZGcBkLzjBR0+FighbU2LNJ510AVfVlcyOHdvOiZt0Icug+hFZtXXKq8A966cU
	dny35j18vZPpvrLwXMyrxbamkvAxHX/lTd7sATOSMUrl59LSNTn1stgF824a+j3O
	wSfcbdExlXH5MbRULfFqsZbzev1B1MWoEjA==
X-ME-Sender: <xms:w-oBaV0vFJQXaGhtxf8pfyWicN2LNVegwRhMj0Mm7EZLUyzOIAmadg>
    <xme:w-oBaY7Ij-E7oY3rYUL5TyQsTVQRJ4ULEN2m-xDFgXmSn3qRWOGBiY6IkO6w5GHIf
    -mQ70XsF1MSNZlvCE6THy2CGBcdTsM2jkxflMNekaTd8H8cDjAx8E0>
X-ME-Received: <xmr:w-oBaaF9-QcR4Xxgik7Pld_HbkFReNnorRP-A4NpV8DyuYCmBj1B3CSA0tHgWg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdduieefgeekucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtsfdttddtvdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkihhrihhllhesshhhuhhtvghmohhvrdhnrghmvgeqnecugg
    ftrfgrthhtvghrnhepjeehueefuddvgfejkeeivdejvdegjefgfeeiteevfffhtddvtdel
    udfhfeefffdunecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrh
    homhepkhhirhhilhhlsehshhhuthgvmhhovhdrnhgrmhgvpdhnsggprhgtphhtthhopeeg
    gedpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohephhhughhhugesghhoohhglhgvrd
    gtohhmpdhrtghpthhtoheprghkphhmsehlihhnuhigqdhfohhunhgurghtihhonhdrohhr
    ghdprhgtphhtthhopegurghvihgusehrvgguhhgrthdrtghomhdprhgtphhtthhopeifih
    hllhihsehinhhfrhgruggvrggurdhorhhgpdhrtghpthhtohepvhhirhhoseiivghnihhv
    rdhlihhnuhigrdhorhhgrdhukhdprhgtphhtthhopegsrhgruhhnvghrsehkvghrnhgvlh
    drohhrghdprhgtphhtthhopehlohhrvghniihordhsthhorghkvghssehorhgrtghlvgdr
    tghomhdprhgtphhtthhopehlihgrmhdrhhhofihlvghtthesohhrrggtlhgvrdgtohhmpd
    hrtghpthhtohepvhgsrggskhgrsehsuhhsvgdrtgii
X-ME-Proxy: <xmx:w-oBaQ-NJCdN2gljACnnW5K0wD9ePLkZYot84PFz5dPDHveZJD2b2w>
    <xmx:w-oBacM-98Jo0IefxgIP4l7EOAlOUB04h8ZRu569jq_iXc0ZTTnjFg>
    <xmx:w-oBaczFvGlwacveAMRFJg2OWwAZgnb6Kpuu3yda9ZJ7ogdHEIRG2Q>
    <xmx:w-oBaet86LLJKmh4LN_G65totUPRz7ivebBwXLJ9V56OogLp_gqo-Q>
    <xmx:xeoBaQF2PDgL6VeZdTV0YBCLE7XIIANhPP4wdjno2bJA118g8Ye95dMu>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 29 Oct 2025 06:21:55 -0400 (EDT)
Date: Wed, 29 Oct 2025 10:21:53 +0000
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Hugh Dickins <hughd@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@redhat.com>, Matthew Wilcox <willy@infradead.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Rik van Riel <riel@surriel.com>, 
	Harry Yoo <harry.yoo@oracle.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Darrick J. Wong" <djwong@kernel.org>, Dave Chinner <david@fromorbit.com>, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 2/2] mm/truncate: Unmap large folio on split failure
Message-ID: <xsjoxeleyacvqxmxmrw6dxzvo7ilfo7uuvlyli5kohfy4ay6uh@hsrz5jtkgpzp>
References: <20251023093251.54146-1-kirill@shutemov.name>
 <20251023093251.54146-3-kirill@shutemov.name>
 <9c7ae4c5-cc63-f11f-c5b0-5d539df153e1@google.com>
 <qte6322kbhn3xydiukyitgn73lbepaqlhqq43mdwhyycgdeuho@5b6wty5mcclt>
 <eaa8023f-f3e1-239d-a020-52f50df873e7@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eaa8023f-f3e1-239d-a020-52f50df873e7@google.com>
X-Rspamd-Queue-Id: E69ACA0003
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: qb5yshhct1omi8ftskfkjq4ye1etjz6r
X-HE-Tag: 1761733317-421051
X-HE-Meta: U2FsdGVkX1+/nCO4i6iD6t7lP2G2ZJTqd7QFStgI1yRGQBbhqMPAALospxw+hGzxML0ZHW1Zqsl7PDmRUSWLzSDepxwnncJmLVqYffgC1c5wF589+LJx0NOM6CoD8UbJoIvnu2Xc9AXKRWcMk5Kt5UG6qPNEuNTm8PHCrZU6WRaeWOAmupoDMEyJ95FmAiWm6B0r1b19C4z+7CvBCOAFoEvy0OBfH0YrlACd8FoHUeszB3LY6psRz+BRft0zdi7nenjlzAk4eC0BD7/AFfE0dJXZ9G1dk6haRjGNEXaR5ap8hSQscv6le8802Bp9VDsMmNWex2HxqEU3ngZhyAoEAhpnvrfKcaw+IWXsUE/EQ0iNJxcYJ9d3nC5pAD25zQmvVGJo5H/KrbJ8q0TcL+mAxBjBoPQ9e40/7aISSw9tt6Z7RoN8XiB/UE1YiHRL8yeiSQvaKILgILbgYwpfnWfHV6NU+DbkX5pQn0cIU4T45pdnhD+C9tyuf8gNPDUCRP5TIQFPviGIsmI3YS9NGNcl/Ia7z5CwPjyFb96pNHzB0GnaxVHiDwB8u8SdnrRzsODZT84vB6pHYB6weMxfFjAdVB9FdJeOn5OUDD9bDYwEOkav4walXZd6PO8ruKwUI8tk3kG684+vB7bfihhh2nektTjQtQ4EInsGvfHEBMQ1Xk9LSO5PYXi8Jj3XeP3E5r9i+DIGxdBVJRmSRzpR0SgMpJmMNwWygGnTRM2beYbbr5tCKcLPIdkTeb0TBE/FoimGGT350Ad/0iHhhdLPdIbEN2crLMFzvl5Z65WlA+F+UcGyh90HgaFvzsX27v4tRerP3jVP35wGuFJf6zgEpaJ64Zi197BupoBpDjcLm8FftfEvfEB75Dm+/493VlaLgii5k954LQD55Svbn/2Ojz5Y/nobKRydP9Ue5TFl8MqDNtccLgAzD2UBk+A7e9oPAYN+HXMZxCyqokWTKawRc8i
 RqfIjhph
 Udx1jnveM0C+ZWMkuBg3CBp6jr6L6GuLcgpj64WIGm2vFPAhXq1dDWaWDi11EMJR6AEmutrXdUxIJQpJrqd/M/G8utn1mljPipw/8R6OojBgJ5D/OqMPxIf0LEeshEIHl4Pd9I9LJ2ZeebhULbYCWsFbK0jPexRuuuZKxtlvO40q1dzmZGtKMUC2VI2f5/xrev+xCj50jurLIfNJ59nrLS6BC5QvMi1eWsM2bNsNxShnWY3ttsF09bzOXa7etSXATQXJ9wLoiIcKKC6tZB+QqllLnJreqGA2I5Uyd7i9X+BfOTjX4Aom9DkkPHySFTycec2PbW9GjIrztYTN2oJJabiQ8Z6DjQDEJvt2mslc1sjDP8+zAz45SAENeLe4P8nemi7XCaiQk/koj+op6LEbgkcic71v5bmc56s9aTKw9jz4+VLUC7UpJY1frlWB+wyHQamPl
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 29, 2025 at 02:12:48AM -0700, Hugh Dickins wrote:
> On Mon, 27 Oct 2025, Kiryl Shutsemau wrote:
> > On Mon, Oct 27, 2025 at 03:10:29AM -0700, Hugh Dickins wrote:
> ...
> > 
> > > Aside from shmem/tmpfs, it does seem to me that this patch is
> > > doing more work than it needs to (but how many lines of source
> > > do we want to add to avoid doing work in the failed split case?):
> > > 
> > > The intent is to enable SIGBUS beyond EOF: but the changes are
> > > being applied unnecessarily to hole-punch in addition to truncation.
> > 
> > I am not sure much it should apply to hole-punch. Filesystem folks talk
> > about writing to a folio beyond round_up(i_size, PAGE_SIZE) being
> > problematic for correctness. I have no clue if the same applies to
> > writing to hole-punched parts of the folio.
> > 
> > Dave, any comments?
> > 
> > Hm. But if it is problematic it has be caught on fault. We don't do
> > this. It will be silently mapped.
> 
> There are strict rules about what happens beyond i_size, hence this
> patch.  But hole-punch has no persistent "i_size" to define it, and
> silently remapping in a fresh zeroed page is the correct behaviour.

I missed that we seems to be issuing vm_ops->page_mkwrite() on remaping
the page, so it is not completely silent for filesystem and can do its
thing to re-allocate metadata (or whatever) after hole-punch.

So, I see unmap on punch-hole being justified.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

