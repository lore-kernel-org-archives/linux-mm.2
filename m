Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02609CA0FED
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 09:13:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 614B08E0010; Fri,  5 Sep 2025 05:13:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5EBEC8E0001; Fri,  5 Sep 2025 05:13:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4DB6E8E0010; Fri,  5 Sep 2025 05:13:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 38E6E8E0001
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 05:13:23 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C1BA7C0628
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 09:13:22 +0000 (UTC)
X-FDA: 83854633044.05.459502C
Received: from fhigh-a2-smtp.messagingengine.com (fhigh-a2-smtp.messagingengine.com [103.168.172.153])
	by imf08.hostedemail.com (Postfix) with ESMTP id BF517160007
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 09:13:20 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="k slJTM8";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=TefHZ+pH;
	spf=pass (imf08.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.153 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757063600;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zvW/hg9ERJRbmThtCLmqLLOoe41n9axYJsJRtI2T5qA=;
	b=cK9jGCFDKjbmGGpFCjrxfeFJB9MSRqGuju8uxFqkXSSpG9hrkWuVeZ+Q+B6CsJ55dxeRqN
	/YqF7EvPPs3iMlL0pBpKDxhpN+J6zIWBNi5JcWhhUful+HaNdHb7Nw827EgXyBysN3o2DZ
	hfU4VpGhbfCW9Xn131/ODwncyQ8L3Yc=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="k slJTM8";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=TefHZ+pH;
	spf=pass (imf08.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.153 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757063600; a=rsa-sha256;
	cv=none;
	b=T/MRzDF9j9OSjzvmVb/n1jvi3olHJc2EWi86YO3NjgEaik1iippk7LZpjL99d/Jt9JRBTa
	hzO9TCLlh8VzgWc5azc1TV1sTDbcyzjkImBkOlezNNTsMW3XCnYYldElOaFfETUdEnBpHk
	Kpa8HV5Epv0R6xc8EtYQ1F9oHOuXbbQ=
Received: from phl-compute-09.internal (phl-compute-09.internal [10.202.2.49])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 1474114001D4;
	Fri,  5 Sep 2025 05:13:20 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-09.internal (MEProxy); Fri, 05 Sep 2025 05:13:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1757063600; x=
	1757150000; bh=zvW/hg9ERJRbmThtCLmqLLOoe41n9axYJsJRtI2T5qA=; b=k
	slJTM8mM/EtG3Q0W5/9/HaJQiPhlky4EZ5azB1v4Xi01lgs8RkyOK1BAmiOQZ30Y
	QvnHc3zZULYIYjzWnCwsbcUSMYO5JYBkgNY7D9BVz8baDRYOUGEoSu20O4IA2x32
	lbMM1L+Z68lGRb8WuHhfRU09EDZ7RCViCs32X0EJ9BsT+s+glSvaBfHwkyqfjW2p
	zbGq7fCcvYahdE1oymVXEo1pcJ1TJNWfCuE1Ps+Mr6CF0RUPFOS2qvlpOfjyv3Vi
	l9sBV9ueQCmtbW2vDyeBT+e5jIco6bE9ZcYlNcl2Moyse7eoW585cA4qGanlISFk
	UaP+LT06v3sgI9loBoIew==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1757063600; x=1757150000; bh=zvW/hg9ERJRbmThtCLmqLLOoe41n9axYJsJ
	RtI2T5qA=; b=TefHZ+pH9cAGPWeyqK8FSXoqcoFVZWwXXvIj5435CMtdFXipY0B
	K4XbSfIGnuGwq6d54CwiDoqfCOmA2jGINcbstNcdZ8Rvzx7792le8bvkTJeMNgCZ
	GmZ4lhtmHyh4SwTPq6ssio9Xq6X2Do4EXt95ZuGcTgEZfXUs26IWQto6dmlAAKy9
	HGq35AE0wUJ0thCeSD31Gf9N7EYIjzfETHqJbt0GD8r78gGX3gU7mcvz9YHU3XNQ
	jxCbCDKkZaG+2+Y61GRZZ0I0I4bXmz19brRakk3xaZZ0YME7vgUsCA0OuINXNqtI
	L06Ahk5WtPEzw5URcHr7xNwD8T7WOzfsBig==
X-ME-Sender: <xms:rqm6aNJEB7QAafjD40tRcith5kLIZGOfgFDIwLFI-qPFAfsoQyhcSg>
    <xme:rqm6aD-LvYvtECUsa47R3tata_5zB__gvOIEN4k3qV9PbfazMils1D6nnx8bkKZsg
    rEgtzQ0Iv-xvPdRoOA>
X-ME-Received: <xmr:rqm6aD-wCp2n4lolg1AGQNDDKBXv6ddhMWMIKDt9LFsGTDb4AFJWTDXDcAkt>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdekhedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceurghi
    lhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurh
    epfffhvfevuffkfhggtggujgesthdtsfdttddtvdenucfhrhhomhepmfhirhihlhcuufhh
    uhhtshgvmhgruhcuoehkihhrihhllhesshhhuhhtvghmohhvrdhnrghmvgeqnecuggftrf
    grthhtvghrnhepjeehueefuddvgfejkeeivdejvdegjefgfeeiteevfffhtddvtdeludfh
    feefffdunecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomh
    epkhhirhhilhhlsehshhhuthgvmhhovhdrnhgrmhgvpdhnsggprhgtphhtthhopeefgedp
    mhhouggvpehsmhhtphhouhhtpdhrtghpthhtohepkhgvrhhnvghlsehprghnkhgrjhhrrg
    hghhgrvhdrtghomhdprhgtphhtthhopeiiihihsehnvhhiughirgdrtghomhdprhgtphht
    thhopehrhigrnhdrrhhosggvrhhtshesrghrmhdrtghomhdprhgtphhtthhopegurghvih
    gusehrvgguhhgrthdrtghomhdprhgtphhtthhopehlohhrvghniihordhsthhorghkvghs
    sehorhgrtghlvgdrtghomhdprhgtphhtthhopegsrgholhhinhdrfigrnhhgsehlihhnuh
    igrdgrlhhisggrsggrrdgtohhmpdhrtghpthhtohepsggrohhhuhgrsehkvghrnhgvlhdr
    ohhrghdprhgtphhtthhopegrkhhpmheslhhinhhugidqfhhouhhnuggrthhiohhnrdhorh
    hgpdhrtghpthhtohepnhhprggthhgvsehrvgguhhgrthdrtghomh
X-ME-Proxy: <xmx:rqm6aN9c4Z0hpq8qkIPnU83Ui4u24jcHGp6ts-mA73TJ5589Qma0qg>
    <xmx:rqm6aOJliJWVRrfu88Vkl6niWCz9YoqCeXBGFJO6PuIWd2mYY8KESg>
    <xmx:rqm6aCS40ilsEHq5qw9DF_lZsStTSXvXzxhvL_sz0wFDCYBe3bJeaA>
    <xmx:rqm6aH_brdZ_N-1lWlXXBrebaPFwcAZOVHv9C4WlpJ3WAUKqIdkscw>
    <xmx:sKm6aKNdHmCUGuMNUDId2EVBAgnksRZ-fNPx2a_S90qOgSTjKFc3z_e8>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 5 Sep 2025 05:13:17 -0400 (EDT)
Date: Fri, 5 Sep 2025 10:13:15 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Pankaj Raghav <kernel@pankajraghav.com>
Cc: Zi Yan <ziy@nvidia.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	David Hildenbrand <david@redhat.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Barry Song <baohua@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Nico Pache <npache@redhat.com>, Dev Jain <dev.jain@arm.com>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, linux-kernel@vger.kernel.org, willy@infradead.org, 
	linux-mm@kvack.org, mcgrof@kernel.org, gost.dev@samsung.com, 
	Pankaj Raghav <p.raghav@samsung.com>
Subject: Re: [PATCH v2] huge_memory: return -EINVAL in folio split functions
 when THP is disabled
Message-ID: <uw7ullt3ztwxiibsdffvphehi7r5g2nxqepcggilgalhv77gso@3h5uqgwodzl3>
References: <20250904095129.222316-1-kernel@pankajraghav.com>
 <2psecfvsd4lbgcm6aflifi2kc6gof345txsvk7wtsytre5ehqt@4wyru36aaeel>
 <e8d5eafe-db58-4b78-b029-de6a59fc4fd7@pankajraghav.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e8d5eafe-db58-4b78-b029-de6a59fc4fd7@pankajraghav.com>
X-Stat-Signature: 1hesrjz6cxnw9y4rzz6b7w3wdt51iwht
X-Rspam-User: 
X-Rspamd-Queue-Id: BF517160007
X-Rspamd-Server: rspam05
X-HE-Tag: 1757063600-817079
X-HE-Meta: U2FsdGVkX185FKYAVwraTBR9rITpAP2amh+IsYuaD/Myz9iYlmp0/bHXLbAiwkRrLxROLzzN95caxEIkmG1K/Pz/eMy/64QXovvHGn+dkCEuA70sX//+N2FII1TFEevCWRV8reYD+M1Yog1hhmG4ON3w7Pk7mm/Go39zaJnZxmIq/9NXA5QVX2JHVEKnxhiuvp0EnzQdI8psZTpotZysY1OIB7OqszHNwNbibzjRtaogpAUzthK6OfZWrDKU8NOseXTPCcHgpDg0OV3XD7eNgguwl71iC7weNdxGibAWMHiY5IZJclUzmGwK8C9A6oZshd7rmiUqXqzAoywfBsvPNqb9Kj9ykWXD1HXR0m1djA74pM2bRg88SwfPp4Q5HfVguSCshZ2D2J6Hn+mhdzJXsBVCcj/BKJYmyF0IEvZnss5jnCVinGZiDm9espVqOJPa1bvcG89bP/TeyHP9hY63T0qxRX4yHExqao7d17puwHUQ6zq5WSyWXEk1JCKbnjogbKP6dhpW3K0+ixw3afjmcfffz2QoiDsFdVMgT5rnlBw0jQ9mtU6ihbfhnrJErJqYZRwtE69SutXlmiaAxQecRMP/cNRcQUPQRqQz/CaidsHH4UWv0s6wP4Rt5aLKt/3ZpGR8THDAeySzjzjQXW9gN3rLPdYkue1qW0y6MjavA09x55ev1+0GMqUNTqxLsTzavKBLvIvzrxuK+iMtzfUp2rQQhUC5YneEu8/JZDEAnNujmGS9CPCL8NP+Hs8jrzpPasvCXDh0W1EVMlvGYcY8QWTDy9xjajH9rVSVEccXVMfrit3mIBGuY0/BeE27vlc3y570tNDur7bUouMm1ArLM/n0/WVLQo7Dd6q2sKreL8pLs0HNEBU08Mby7/6RNWgujKDxhtova4Uqabzt3lqWHY6Freh8kU6mhZ6DPYvtFAP1RwPEXhbj31We6QZtb+Yg6gkafM2Owmuld/r05C6
 fMevlIu+
 O69HU831fVgjBA1k9levWmNy38kwhQ4CzOWpFlNykBLdHqZ72AWH4hLtce2jO7E5T9Q4asDCDLe0xE4Z2fZJLXCtH7zV0URAysOzjZ7LmDKXlFvpJsKIr7IyNoY9D+sS4Pdkd90uIlenNIswh5U0QwdtJ7aUBRNQPMOCDfNBMKEYrDX9Zra47Fyja+Jdi0M1SnMBm2Ax0yV9Ccpq6pzt4RqavoVPGscZNhtWIBflHOJrBWfLq+MkARe+pDs29HJQLcs7k97BHVGmXm/3DqcVMjCIDKKSKi7pis8fJrDEdP9+Vj5XSxQ/gtLVuT1UnPjuqkXtbTxjiQ4im3TJiRkpLk+DQ+VwRrmpsIo6lr+Wb3CO844LUUfUp9kwOSerMjdD/n5QaoGZ88yiGbiOGHyZ7MVOA8zWCpyIJ7pRU7pTKaCsP5gjDECFTbSTYemA30j/qBC/BRGG5rQ6BRhE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 05, 2025 at 10:13:05AM +0200, Pankaj Raghav wrote:
> On 9/4/25 17:26, Kiryl Shutsemau wrote:
> > On Thu, Sep 04, 2025 at 11:51:29AM +0200, Pankaj Raghav (Samsung) wrote:
> >> From: Pankaj Raghav <p.raghav@samsung.com>
> >>
> >> split_huge_page_to_list_[to_order](), split_huge_page() and
> >> try_folio_split() return 0 on success and error codes on failure.
> >>
> >> When THP is disabled, these functions return 0 indicating success even
> >> though an error code should be returned as it is not possible to split a
> >> folio when THP is disabled.
> >>
> >> Make all these functions return -EINVAL to indicate failure instead of
> >> 0. As large folios depend on CONFIG_THP, issue warning as this function
> >> should not be called without a large folio.
> >>
> >> Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
> > 
> > Acked-by: Kiryl Shutsemau <kas@kernel.org>
> > 
> > Just curious, did you give BUILD_BUG() a try?
> > 
> 
> Yes, I tried BUILD_BUG() but it actually fails the build because truncate_inode_partial_folio()
> calls try_folio_split().
> 
> It won't be called in runtime because there is a check for large folios before we call this
> function. So a runtime warning is better in this case.

If truncate_inode_partial_folio() shouldn't ever be calling on THP=n
kernel, it also can be BUILD_BUG(). Just saying :P

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

