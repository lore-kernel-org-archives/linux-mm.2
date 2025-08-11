Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48D81C87FD2
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 10:17:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D487C8E0032; Mon, 11 Aug 2025 06:17:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF9808E000A; Mon, 11 Aug 2025 06:17:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0F988E0032; Mon, 11 Aug 2025 06:17:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B30078E000A
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 06:17:47 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 54539137D16
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 10:17:47 +0000 (UTC)
X-FDA: 83764075374.18.B64B322
Received: from flow-b4-smtp.messagingengine.com (flow-b4-smtp.messagingengine.com [202.12.124.139])
	by imf23.hostedemail.com (Postfix) with ESMTP id 56A5E140002
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 10:17:45 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="H i0dhC9";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=OXzzw00G;
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.139 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754907465; a=rsa-sha256;
	cv=none;
	b=6fy39aJJkUDeuNbY5g+fbbSj3GJcNf1l1dyYOZ1W5aGId5NntYFwh/GlqEwvWcH1hrA2w5
	BcfgVYRdKu6aK8Yq2n2ye6vpFMVOKIfBA5AQ1RCVHb+X69ZDbA2rPsG9r66nBKT1nZwK2M
	w5n00ocNY1L3XJKbA8SW0c23J/lt3pA=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="H i0dhC9";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=OXzzw00G;
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.139 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754907465;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JTDYGtuk5YhoXR2bU1gah20zKNI0h74bgwzfLz1JAoU=;
	b=y77poRmMH9P+C4yCt4uG87KpQZ2xpoFNuz8/Jf1au+nCKvUdw43+oyoj1473+Q+YwPoH0m
	fDRQy1TXM5yA/ZAsmII4HCg3V9uo/e3gb+IxWuy8/OfnJFYhgwYAn2z7XoH5obpIDdc3y9
	ofpMhl8lMz6/2sT2Q1vICBBg/RTNOuo=
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailflow.stl.internal (Postfix) with ESMTP id 2E87F1300128;
	Mon, 11 Aug 2025 06:17:43 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-03.internal (MEProxy); Mon, 11 Aug 2025 06:17:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1754907463; x=
	1754914663; bh=JTDYGtuk5YhoXR2bU1gah20zKNI0h74bgwzfLz1JAoU=; b=H
	i0dhC98oVO0d3EOdB73fn7pi5zw4cHaGLng+8mGA0Xv7Ol5Sdz/cMUSe5T2puuMf
	57A86juVENc0pa0oKV0GW4WqYsS6nzv+uEChsL4plFBDHEHmDUvC2JRrPblg042o
	QJJplHpns5klrYhN5IjTfcgxbKQMlAN0qLCLtMQOkzWgFWPqfoAAa5PwIYyKZDrM
	KpPnO3Tm3rHvlhUScb5NHaR7MNXzKMMTPeXEFnUjb5CbkjWtejdtuBcDxcZkUfmM
	djlg5kt0DZl4cTkRTBvr1LpJi7yJrCMIlTWpEBFqmoiQvRb4/C7OEqFGjjejEQH7
	lzyKEqRZ/PADc2jApbDLg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1754907463; x=1754914663; bh=JTDYGtuk5YhoXR2bU1gah20zKNI0h74bgwz
	fLz1JAoU=; b=OXzzw00Gr8lmjyrxVoY0HgZkXBfQM85Or0u7ENfE4as58NkfOM8
	YO1p/zVogusB5UGiVZgQBKd4Xptv/k3OoCKP2yBwAtLSfWser9eoJIUR2H8QhZl2
	Jqo9k6TST/it+6/IiampbP7ZJN3OzhtL2cyccFQsP7R9VQyBldQ6vSxJUuO57GTI
	Sxgu7U4bq77ZfH8GDJ2lCpN+6fJ/RiKbJVRZof0LTgz27DF++XA7nY4Yd4VE608O
	S1Nrr2crc1gyC3wRbvy4M2Hp2JunTlSV2Tlf4PaUSzUQUUcJgVTClP98WYYQ3BUv
	4rZE79TUtIntEGx9SqD5DGo3HVYUm2YLUjA==
X-ME-Sender: <xms:RMOZaGDdbN1XIsEO-hfXw7mPnmjrbF4AYMeno8GnJTFN9r7YQpt9tA>
    <xme:RMOZaHqz3d0sryzqz3lMU3Cjxa90UWmMCMbKUqJbdAS2vciC2GXW93IIgfyHGR0YO
    pkmd-RYYrPV8kGLIoA>
X-ME-Received: <xmr:RMOZaL-D99bzftr3PLC3Xd_-wmfvtn68ioY8u7n7pFQVRGUB1jHEHKQuvZC8>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdefgddufedvudelucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtsfdttddtvdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkihhrihhllhesshhhuhhtvghmohhvrdhnrghmvgeqnecugg
    ftrfgrthhtvghrnhepjeehueefuddvgfejkeeivdejvdegjefgfeeiteevfffhtddvtdel
    udfhfeefffdunecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrh
    homhepkhhirhhilhhlsehshhhuthgvmhhovhdrnhgrmhgvpdhnsggprhgtphhtthhopeeh
    iedpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtoheplhhorhgvnhiiohdrshhtohgrkh
    gvshesohhrrggtlhgvrdgtohhmpdhrtghpthhtohepuggrvhhiugesrhgvughhrghtrdgt
    ohhmpdhrtghpthhtohepkhgvrhhnvghlsehprghnkhgrjhhrrghghhgrvhdrtghomhdprh
    gtphhtthhopehsuhhrvghnsgesghhoohhglhgvrdgtohhmpdhrtghpthhtoheprhihrghn
    rdhrohgsvghrthhssegrrhhmrdgtohhmpdhrtghpthhtohepsggrohhlihhnrdifrghngh
    eslhhinhhugidrrghlihgsrggsrgdrtghomhdprhgtphhtthhopehvsggrsghkrgesshhu
    shgvrdgtiidprhgtphhtthhopeiiihihsehnvhhiughirgdrtghomhdprhgtphhtthhope
    hrphhptheskhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:RMOZaOecNLsDQtmaDXNSQxx-pimxoWG2KoZEzFKOtXWin__9MJjLJA>
    <xmx:RMOZaBJNBNdaTBfsrZWxYUEiprG5FDP2xTOMf7u5W6mimzFP-m9Gbg>
    <xmx:RMOZaIQiJ3nY49TvMbfZglXCsbjjJyupmLC-_rUOG5Enp62Tz5llXg>
    <xmx:RMOZaPFk5jIuXuPrkSxQB_qDoTSDqS6yHBRPf0IJ0tusr6p0_JbcMA>
    <xmx:R8OZaHnqV6gmf46bwm9FyYh4KV8d9jYAZOmDJsCZGVU5yhXf5V5Rnh2d>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 11 Aug 2025 06:17:40 -0400 (EDT)
Date: Mon, 11 Aug 2025 11:17:37 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: David Hildenbrand <david@redhat.com>, 
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
Message-ID: <lkwidnuk5qtb65qz5mjkjln7k3hhc6eiixpjmh3a522drfsquu@tizjis7y467s>
References: <20250811084113.647267-1-kernel@pankajraghav.com>
 <hzk7e52sfhfqvo5bh7btthtyyo2tf4rwe24jxtp3fqd62vxo7k@cylwrbxqj47b>
 <dfb01243-7251-444c-8ac6-d76666742aa9@redhat.com>
 <112b4bcd-230a-4482-ae2e-67fa22b3596f@redhat.com>
 <rr6kkjxizlpruc46hjnx72jl5625rsw3mcpkc5h4bvtp3wbmjf@g45yhep3ogjo>
 <b087814e-8bdf-4503-a6ba-213db4263083@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b087814e-8bdf-4503-a6ba-213db4263083@lucifer.local>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 56A5E140002
X-Stat-Signature: fr36zm9ow43d5m6ackf7yfyepib3wfdz
X-HE-Tag: 1754907465-283246
X-HE-Meta: U2FsdGVkX1+r20Pt+z6z0bVOEN05wN++3zAKbFNu1P7GNJMdaWGqEulVrpZkIqrbFlqlsk5s6rNkWwq7aw9YdkWp5lAF3wUMw7AEKBysl5fWSylMtRhbPXafgU5M0SOSTW7a8DFD4lC16cIlnXOYL4Q3RUsezpICqiNs5UJMxdJocAm+yVhyv06eglKzT2A4cfWx1WfvJeqS5GnRaHXkdRv3Uy5wr16GZ7WipwUI4DzEq7oGvTyLR+wtPpGXQ3Y6enmrx4+cdYT5Aocm6QxhETv82jmxeHSBx6rmb/ETKOcW4g3kKeyr+cTeLBmDz3LZbNUurxxpD+t6vBPzibqHPZm+kwlvLEEnI/8BSuesY7IwPGivmR7s31BjR8AkYo5ifDlpB9RaZ4Pv6Zd79eiQ/hhkYUbVbz8o0aXtaoHGLS700WonqwuW5FEXS2FTRfAoO8+m0MWYNRXZ24ikD+i5VTbTqGC3yQQ/nH/2hKIcd49Osz38DPoqmRa631z2iFg3G78eYb2zLXARI46tpqh6cYRNoP1gUXEObxQlFlFlZQj92qS4PEwnyjJH0dAiabWc0UXuucIGs1qnGtDDRZpynEoeB18HBxGeTcIGWNZkNBxNXadGGm27X+jd1dh4yzm/TL3BcmrKKGBnVAJKrZcdZ6X/PfHpUaCPnWo+2YjXuHS79LzyxbT3mzjA60DDyLYRDBS5MijQrF66F6OOF6RwmzGbO9wtrwqsjbQI8UrYpXxHXOn/XpPoVyVeENJXMEAr4i2wBoHVcymbbTmPUukcCvmmri5R0HCRipMhuj66cbF0iqWqc2CqCT89nLSc2Dl37ZBj8I5Q3oJZANYM5ePKxUlxFYiboaMuZhzmojwIlace3ftxj2P8vPcubLsEEM7A1hf1FqUrDfB8JLvGlSvX7wx0iG9GqStbH4/XSlmFA4/f2Ndq7RBfC6qEdj57DjGZ6kPkeQ0p9tbvq+dbfiv
 cNk1T02h
 tjfLrak12HylrOBFgXo67wjqiQzNmDp+T/vcqSx1o8ddoFKDRH8Temci4ZUup+hQqcrSPsUndPYsPTWLHZLRf8ZiQZlX7blqbb8gFe1ksfLY5W1YvvBSnRzy9bivMhEZTvet1nR5oLePKNyJh8cLJAbHucvOwlgBmLzxihzs5DaZqfcvQ17lvhwRHO2Mpuhh/S20sFHC3p8rgyE8BqU8/tAZ3AKgV/1MdqkBO2ttShGsSV6iEPhZ9tYw6JnSLPEL0RmldkCJ4SYBv1CYhbWgNlBuQazUjyMPRDGYmaPqMfZ1zbLVtXcTnDngAUDPguVxkQs5BvaR4KKT7d0lF6oOMMokLDfPGX6Pcr1o3oTrkVIVsAsbPP2J/ZkF8io7M/VyVH+vio0UAgkBB0NoRz2pzq9iPCl1hZicO0t+WRwcknEAJFUe+SKYd4T5DrszBapbdWWTxnIPBpHlQ1pm+JnAmcH67uXZMItGJmbO3
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 11, 2025 at 11:09:24AM +0100, Lorenzo Stoakes wrote:
> On Mon, Aug 11, 2025 at 11:07:48AM +0100, Kiryl Shutsemau wrote:
> >
> > Well, my worry is that 2M can be a high tax for smaller machines.
> > Compile-time might be cleaner, but it has downsides.
> >
> > It is also not clear if these users actually need physical HZP or virtual
> > is enough. Virtual is cheap.
> 
> The kernel config flag (default =N) literally says don't use unless you
> have plenty of memory :)
> 
> So this isn't an issue.

Distros use one-config-fits-all approach. Default N doesn't help
anything.

-- 
Kiryl Shutsemau / Kirill A. Shutemov

