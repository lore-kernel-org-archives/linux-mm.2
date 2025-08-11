Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F3B0C87FDB
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 10:36:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 118058E0035; Mon, 11 Aug 2025 06:36:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C91C8E000A; Mon, 11 Aug 2025 06:36:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF9E38E0035; Mon, 11 Aug 2025 06:36:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E080D8E000A
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 06:36:39 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 94027116B32
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 10:36:39 +0000 (UTC)
X-FDA: 83764122918.05.3FC28DC
Received: from flow-b8-smtp.messagingengine.com (flow-b8-smtp.messagingengine.com [202.12.124.143])
	by imf20.hostedemail.com (Postfix) with ESMTP id 947671C0006
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 10:36:36 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="Z YwJzj3";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="lw/u2PNS";
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.143 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754908596; a=rsa-sha256;
	cv=none;
	b=wOowmGW22lGHaILPllikWh804ibWvBQ90J99VYjlZ9HMfYTtgUtq38PXs3JuKq15YmBYST
	HLb1i30yGLIxoBlG7ECDyDQbzmWdfyd0c3QILW3V6qxXDIuQ/mjZaVCzK97WmDtdzVHskl
	27WxZqH5m8tFbSue0zduiV2kjJOTP1E=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="Z YwJzj3";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="lw/u2PNS";
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.143 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754908596;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3ir52tZmodooRvQScQwDhVxAmA5y/JQn5auuY4m6agI=;
	b=0qccERkZ4PgX7iCZWoaJ7SKEsl2HmiN9S+uhxhq6Cfw3z7Lz9vjzf5YSmXMBJdrYC941Ob
	sT+zr0a2EYeU09dTu3Lv3jugOoIZDV8iXzDOwEvCbfNI9MQhcIU1bVnUtvSCpcGvGuAR3J
	3p70UGPb23EaqnnVPFgFdFW7VTBM8NU=
Received: from phl-compute-07.internal (phl-compute-07.internal [10.202.2.47])
	by mailflow.stl.internal (Postfix) with ESMTP id 63CD11300191;
	Mon, 11 Aug 2025 06:36:34 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-07.internal (MEProxy); Mon, 11 Aug 2025 06:36:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1754908594; x=
	1754915794; bh=3ir52tZmodooRvQScQwDhVxAmA5y/JQn5auuY4m6agI=; b=Z
	YwJzj33xYsZBUJ6IzJ0WxB7ZPZ+NTd64XV3Jz1dl2fvYAxNzZqiEtfHmMBJ2dEjF
	jKsaTTRFIar75JV/WXJ7sAat2l3PPKC7Ypb/SFtLg97g2ylkT6Q+AwUTyeH3ytyW
	C5+k5l+T8OXQiTCGWyRj1cpraEq+jwmJ+lUEucZq8BAleJMuubOB1FeqeZL+9Oem
	7w4b1iN3mORNUKRRBHFjl839Zr8Q/X/Trze38YmDdAU5FrnwNOuQqUfX8JKr6vtF
	C29Z8eIEgAOZTIT6E0KsP/cEi/l6pYvchnrlf8pnCE1zyAM1RSmkM135KlCcEN0O
	UI9DCOz2+1AhB+gIcoisw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1754908594; x=1754915794; bh=3ir52tZmodooRvQScQwDhVxAmA5y/JQn5au
	uY4m6agI=; b=lw/u2PNSpIOo4ODXYLXgQDAIDVQVNJ3cuT/pt2oak+p6hymj6Xl
	TRKUQgcUrq/GPM7Q8mKax6iMD4p1MBQDa/v4DrS/c+Fte3wWPNbeSfqzYKHuJgol
	Vwr+9t45ICKWovIldVz7rHak7NsrkLjyGvhCvcX6UAZ0KSSBEIFk2EygetByQcg7
	kxzQaz+n+OmC1EyGVb9naUnnPfv5JgkXkbno7qbAvbDUbwYObdc5iT0kGjcv084a
	vlnQjymLIS//aiGkw3A/tGIVKtX4eQI9FHXB5SaFl1E0NnTOJS7QlJ0KpbKUnold
	Rv4D4LR5w9WAOpQvYYCiTZ5IueMmz/serGg==
X-ME-Sender: <xms:sMeZaPaai9YTIfw37ejKGZ3uGQwKZvHuCiE7-KvW-M9p-7Uk-iOpjg>
    <xme:sMeZaFgwkWilAXNt0CQgdPvo93xCwzEUapb2eKzTFKmLJpbLRRUrDTcHm5-AMsWEM
    r3kzzuQ8G9wkII6XCI>
X-ME-Received: <xmr:sMeZaEUiO8h_lYXko7NSPUjZ-CuHAgkNr-N1frHBBn69VDhV0BaagnTqIgq6>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdefgddufedvvdefucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtsfdttddtvdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkihhrihhllhesshhhuhhtvghmohhvrdhnrghmvgeqnecugg
    ftrfgrthhtvghrnhepjeehueefuddvgfejkeeivdejvdegjefgfeeiteevfffhtddvtdel
    udfhfeefffdunecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrh
    homhepkhhirhhilhhlsehshhhuthgvmhhovhdrnhgrmhgvpdhnsggprhgtphhtthhopeeh
    iedpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohepuggrvhhiugesrhgvughhrghtrd
    gtohhmpdhrtghpthhtoheplhhorhgvnhiiohdrshhtohgrkhgvshesohhrrggtlhgvrdgt
    ohhmpdhrtghpthhtohepkhgvrhhnvghlsehprghnkhgrjhhrrghghhgrvhdrtghomhdprh
    gtphhtthhopehsuhhrvghnsgesghhoohhglhgvrdgtohhmpdhrtghpthhtoheprhihrghn
    rdhrohgsvghrthhssegrrhhmrdgtohhmpdhrtghpthhtohepsggrohhlihhnrdifrghngh
    eslhhinhhugidrrghlihgsrggsrgdrtghomhdprhgtphhtthhopehvsggrsghkrgesshhu
    shgvrdgtiidprhgtphhtthhopeiiihihsehnvhhiughirgdrtghomhdprhgtphhtthhope
    hrphhptheskhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:sMeZaPV_84z0yhD5XP_EVdFCaSDz6zDY0-Ijs-UIqVV-oE-oIRcrPg>
    <xmx:sMeZaAiOMRpSac9hXOdj4hbOcGAs28WlUd9C-IzToTaV7WNs3ipB1A>
    <xmx:sMeZaELPkPI7mE-7kWSuW_m46t4dVUS4Rq9m-8LNs0ubdR2tcmsfxw>
    <xmx:sMeZaNelP9kaRfzsgLdrlb2R4FxaIHU5LPHs6wHSrQbQQF3MpikgFA>
    <xmx:sseZaEdV8sqEXHjuevFSSbmlXO3_7TfRosx8ii5M5eEv0tu70ejlW2xN>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 11 Aug 2025 06:36:31 -0400 (EDT)
Date: Mon, 11 Aug 2025 11:36:29 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: David Hildenbrand <david@redhat.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>, Suren Baghdasaryan <surenb@google.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Zi Yan <ziy@nvidia.com>, Mike Rapoport <rppt@kernel.org>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Michal Hocko <mhocko@suse.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>, 
	Nico Pache <npache@redhat.com>, Dev Jain <dev.jain@arm.com>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, willy@infradead.org, Ritesh Harjani <ritesh.list@gmail.com>, 
	linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	"Darrick J . Wong" <djwong@kernel.org>, mcgrof@kernel.org, gost.dev@samsung.com, hch@lst.de, 
	Pankaj Raghav <p.raghav@samsung.com>
Subject: Re: [PATCH v3 0/5] add persistent huge zero folio support
Message-ID: <osippshkfu7ip5tg42zc5nyxegrplm2kekskhitrapzjdyps3h@hodqaqh5r26o>
References: <20250811084113.647267-1-kernel@pankajraghav.com>
 <hzk7e52sfhfqvo5bh7btthtyyo2tf4rwe24jxtp3fqd62vxo7k@cylwrbxqj47b>
 <dfb01243-7251-444c-8ac6-d76666742aa9@redhat.com>
 <112b4bcd-230a-4482-ae2e-67fa22b3596f@redhat.com>
 <rr6kkjxizlpruc46hjnx72jl5625rsw3mcpkc5h4bvtp3wbmjf@g45yhep3ogjo>
 <b087814e-8bdf-4503-a6ba-213db4263083@lucifer.local>
 <lkwidnuk5qtb65qz5mjkjln7k3hhc6eiixpjmh3a522drfsquu@tizjis7y467s>
 <57bec266-97c4-4292-bd81-93baca737a3c@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <57bec266-97c4-4292-bd81-93baca737a3c@redhat.com>
X-Stat-Signature: bxp1eehxqaykyikaehycu1utkgof7b1a
X-Rspam-User: 
X-Rspamd-Queue-Id: 947671C0006
X-Rspamd-Server: rspam02
X-HE-Tag: 1754908596-842199
X-HE-Meta: U2FsdGVkX18/6v7bnq0Xkk2TIijEDKx+eOcL1AYWqG8UpXV0fvoqxx9ajj59JwFpnXwJOhItQezS15sP9lXOrku4Vk4gQrEWdkhAFelhKq5ENBbdzXAxNb9L9Pyb7uN6KKxVmYrOPrquGZMAsXL6WbHRhxITJUtTIaVXtACqsAaHUFDTsHfWhTFAXMiB2Wi+yf3BO8eZMpxKeI6azGbvRlKZzVWkQWl+mDanJlG8BrqdpnCNAS7DjqliOod4L1/ZYGAj9gVzKbJiDAE1dhi7sBk7dGvwC23qBpdbq5PCHlLY8yoi4CUhqnQAGsCBo5hMwtg3OtWCA8UcjTpA63czT8IMb7s61KjwPqCnP9TTMS10Hn2g2vsXia9IV232mN5AdSSZf9WoJsoB5v1mpo3jYXv+fW7iOHmKFHzyIUWo+z0O4qd7rSvRrjjz94wlSzavgWEf8qwCUSz1p87lUa3cDHdkArBeL8Cwigy8y65Bz23Yr0fZPBH05f0q59IRyoctDFRJlYmHsve+OQSG/Qx22ttmwIsXg1zdeMbAp5qCDdhUfYCZYhtY6mIo5zhZAtTtR3vmPFBsP40vmI5fNv0wBum4P5wkAzTfY704W1P54JgsiZ/8LnZV0Z5oM2EBqlvra35UCWkLXoOcB8kiaa9YSrOviRDR4hhxGjQTvniRd5yFoL3tri846JScUTkGwmqZhckA3kRqIePFU8oxCVrOE+cNc7rRq22hJdHrRYqR5opEamN/UcXBRrXkOKfmTHDaYxy7SaKDZ1yQU2uh5BySv36OrgqSNtylGe1ZjZOj6Wc7msMeCl48jjTrqUQEEXUW0fsU5/SxB4OdMxIsw1TnZt354f8asRqrYqZMh4fMMozPsIrNAzAYre3gEiucdnJcRCotpqm9ohNYYlPjyCIrK37pj3yjYXgSfqcWvv3mDdp+Ds4fvfFsXxmg01INSUJqONrJrnuZiWJAne8ryPT
 MYXmN7I7
 FpiItektWFUf3xu5FSBilikJqYGUm3TTjb3DVuZ+hJEb3uTjYSn9vIBhYcO39hyU5A4tWeeO3Ioz6Prcc40Ei/eInBNP7nrfIG+DefwJhVqb3pUjXZmdDiGw15+JmcPyhWEQU602BdqR4Pw7OEIghGNFfJkKYaE2C4G3cP3T7SoPGsgH1IGyk/Vv05y4VXZuW0Nt/eH5X6jLhbUIJDxoxJH+cPeAhpl+20Dn468PozqYRopkAEZEQ32zdRGIQvCXmZbdYz/DLPQ+ROoicqyqOMG+52+PYWPLgE0GinN77wsnYIsb3anwz6J7o4HbI57IXOhVbtaR2620Z0L4VCCnaoAMr+HKto4epswEHUeq/EnJNnkTrm4eIMNMuWnITn7/H9yo55c445IeMzdsdrLVbcQgZ7i3iw8Va+l/wectqixREfod9xyuvm+GVBA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 11, 2025 at 12:21:23PM +0200, David Hildenbrand wrote:
> On 11.08.25 12:17, Kiryl Shutsemau wrote:
> > On Mon, Aug 11, 2025 at 11:09:24AM +0100, Lorenzo Stoakes wrote:
> > > On Mon, Aug 11, 2025 at 11:07:48AM +0100, Kiryl Shutsemau wrote:
> > > > 
> > > > Well, my worry is that 2M can be a high tax for smaller machines.
> > > > Compile-time might be cleaner, but it has downsides.
> > > > 
> > > > It is also not clear if these users actually need physical HZP or virtual
> > > > is enough. Virtual is cheap.
> > > 
> > > The kernel config flag (default =N) literally says don't use unless you
> > > have plenty of memory :)
> > > 
> > > So this isn't an issue.
> > 
> > Distros use one-config-fits-all approach. Default N doesn't help
> > anything.
> 
> You'd probably want a way to say "use the persistent huge zero folio if you
> machine has more than X Gigs". That's all reasonable stuff that can be had
> on top of this series.

We have 'totalram_pages() < (512 << (20 - PAGE_SHIFT))' check in
hugepage_init(). It can [be abstracted out and] re-used.

-- 
Kiryl Shutsemau / Kirill A. Shutemov

