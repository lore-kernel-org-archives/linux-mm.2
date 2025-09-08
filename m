Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53394CAC586
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 11:44:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8BBDD8E0001; Mon,  8 Sep 2025 07:44:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86C2F6B0008; Mon,  8 Sep 2025 07:44:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 75B528E0001; Mon,  8 Sep 2025 07:44:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6146A6B0005
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 07:44:37 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2C574160B10
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 11:44:37 +0000 (UTC)
X-FDA: 83865900594.26.815DE0B
Received: from fout-b6-smtp.messagingengine.com (fout-b6-smtp.messagingengine.com [202.12.124.149])
	by imf13.hostedemail.com (Postfix) with ESMTP id 2F09B20009
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 11:44:35 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="m 9zkb6V";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=PCN0wBrb;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.149 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757331875; a=rsa-sha256;
	cv=none;
	b=zg+aZr+971YbckqjROE//RdxJbNusx4NRojMWPKk8sMKDHRKyqZoB534hTgdyK0ACVKpgE
	JLsaEY0v+Rg4PrA49lR74AA0Mei1oVlC9KwFIo8Fie1n90R9NHdn8py/d+yGisPPb7fsTw
	n4B8KeGaq6skFshNI6jO+RLHXNbosCw=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="m 9zkb6V";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=PCN0wBrb;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.149 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757331875;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1M6/UFGInIle7I4iejjoxiDU7Sww+aQnTkk7qcbEtU8=;
	b=uaPemYyKQezOTegxPwNgO2T7ntSgfBFxjnn3Q2DAuyNWhVipU3VSOQ2xtYGktIYMHISoNy
	JUO8CV4Gp6eUpPdObKoZU3bsRHQmcUPz9ZrawUnkv2VGtDY99zv3tCi94mirmHPEaXQ9Rf
	/HkpL5sQ/xbG+SHt0D8Ccat/1VREG3Q=
Received: from phl-compute-09.internal (phl-compute-09.internal [10.202.2.49])
	by mailfout.stl.internal (Postfix) with ESMTP id B79C71D00123;
	Mon,  8 Sep 2025 07:44:33 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-09.internal (MEProxy); Mon, 08 Sep 2025 07:44:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1757331873; x=
	1757418273; bh=1M6/UFGInIle7I4iejjoxiDU7Sww+aQnTkk7qcbEtU8=; b=m
	9zkb6VFOIq0HW4QIkQ1OJ3y/juJMppAKqe5MkfooPayKfZcHFlc+Sa2ojxMqlvaI
	fVAPWGDV8prgjieBmETpp+XB6QnzQUJVQfXeMTUo3UDrtdWDhGiicBdO9brB7ku0
	YiDQUnZAlgN5uB5CaPGHyNff57Zn14/XkSLDcm9qlDy2y6qJBaOjlZXL8329eCuF
	tTButgPMktWt/C6qN17SM3FltWsPwq8J9yIPATGOmQvsTd+1YsBLi41g32RFAnKR
	wlOTFWUyZWE+UioAoFg30dludY319KeltPBj8egoLw7ROtShuxFmLh2Hktf+e9F5
	zeAa1/8i3OfkqXu0aeckg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1757331873; x=1757418273; bh=1M6/UFGInIle7I4iejjoxiDU7Sww+aQnTkk
	7qcbEtU8=; b=PCN0wBrbABxYccXGJZDikdONsTsC03ptoTDtm5uNHBlen0tfl1x
	ok73M03gjgP7uij9dXp9X1jN3x8UmGDf0okFVFXzKP0qZZZFRlqathoe+zIDOzL6
	yNwkF5u7b49jfWCbYBnhqfEwIfUEtEAk4lq9GKvq80RBWZi3+Xr6KKS1F0w3rkVg
	S26kmJOVL6KzyE54UqODJ6Ayyeh+G4XjKbN804v5gMCf7qb74eqQXTnvsaTCpnj5
	lkio0umhOUs/1+QyzrHBxrtzWwdxcnqXPRRX8e1QyWlsUZoJ6jp2L0A5yIanAQxO
	DL2BcO5TY2E2PBQ9aKpstx96xOOKz064stQ==
X-ME-Sender: <xms:oMG-aNR5aaou8QNKPZKjicpBepZMxlJYbNo0TS9-GkmleqWlHpchNg>
    <xme:oMG-aL5tcQMR9gRjS8zwH_AV9Mgko7E-ltq8HIDbiPLb0AHU4kAJVTvex-dCYQto0
    EVDMSgeEUSkroeQGuw>
X-ME-Received: <xmr:oMG-aKF3vZ7KEOaVbHzp25HLt5z-wkkMNXtd43p4Aa4fu4J549nL66re02jjlA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddujeeghecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvvefukfhfgggtuggjsehttdfstddttddvnecuhfhrohhmpefmihhrhihlucfu
    hhhuthhsvghmrghuuceokhhirhhilhhlsehshhhuthgvmhhovhdrnhgrmhgvqeenucggtf
    frrghtthgvrhhnpeejheeufeduvdfgjeekiedvjedvgeejgfefieetveffhfdtvddtledu
    hfeffeffudenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpehkihhrihhllhesshhhuhhtvghmohhvrdhnrghmvgdpnhgspghrtghpthhtohepvdek
    pdhmohguvgepshhmthhpohhuthdprhgtphhtthhopegurghvihgusehrvgguhhgrthdrtg
    homhdprhgtphhtthhopehlrghntggvrdihrghngheslhhinhhugidruggvvhdprhgtphht
    thhopegrkhhpmheslhhinhhugidqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtoh
    eplhhirghmrdhhohiflhgvthhtsehorhgrtghlvgdrtghomhdprhgtphhtthhopegsrgho
    hhhurgeskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepsggrohhlihhnrdifrghngheslh
    hinhhugidrrghlihgsrggsrgdrtghomhdprhgtphhtthhopeguvghvrdhjrghinhesrghr
    mhdrtghomhdprhgtphhtthhopehlihhnuhigqdhkvghrnhgvlhesvhhgvghrrdhkvghrnh
    gvlhdrohhrghdprhgtphhtthhopehlihhnuhigqdhmmheskhhvrggtkhdrohhrgh
X-ME-Proxy: <xmx:oMG-aMl2QLRT8ZCKU--qj0-QdPEwj103k9SI3BILRZJIVroYLPJvzw>
    <xmx:oMG-aNB8mrbAiLCv0uauz2C7hv8A5FS3JI_Wc9gns-YkR_B4h3R3Ig>
    <xmx:oMG-aLHuZODXafUej9Lqit4xCQpVYNStpthQ1prIXYzNwWWfkDYtDg>
    <xmx:oMG-aB8r5D4-6Rv8z1wzddUhfkKG6iyzOHMu_HeOBqV9_ZmTsfErxA>
    <xmx:ocG-aChYG45PeyLgXn5kT18rcrMPTTFisFnct8kCUi8mtMqhztdB1vci>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 8 Sep 2025 07:44:31 -0400 (EDT)
Date: Mon, 8 Sep 2025 12:44:29 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: David Hildenbrand <david@redhat.com>
Cc: Lance Yang <lance.yang@linux.dev>, akpm@linux-foundation.org, 
	Liam.Howlett@oracle.com, baohua@kernel.org, baolin.wang@linux.alibaba.com, 
	dev.jain@arm.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	lorenzo.stoakes@oracle.com, npache@redhat.com, ryan.roberts@arm.com, usamaarif642@gmail.com, 
	ziy@nvidia.com
Subject: Re: [PATCH v2 1/1] mm: skip mlocked THPs that are underused early in
 deferred_split_scan()
Message-ID: <5j6i2o6umqwxabdfncbrdytmvdma4yrraxe6hu4csckcniduya@sm3mlablwbad>
References: <20250908090741.61519-1-lance.yang@linux.dev>
 <niywtremc5kfhs3lenmfxvbiiizyexnaw3m25twedmzovfoeno@lk2o46tfdklk>
 <9a0c07b9-5bf0-4251-8609-fbaf0ca75bf9@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9a0c07b9-5bf0-4251-8609-fbaf0ca75bf9@redhat.com>
X-Rspamd-Queue-Id: 2F09B20009
X-Stat-Signature: p8dqio6niu5jpotsjd4d4e4gwpdrmumt
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1757331875-613838
X-HE-Meta: U2FsdGVkX18CXrjj5wAf5hIeMCAg9BDabn00QBf5APck1o2nJtQvG6hI0zE0YkNoUz84Z8sZxtvPwAXk2Z6XsroNvzLMt95rRrYKx0UH7nd5C9jAuLh2hgK5XfU51CZEfpc2VnlZaCR/ge+kg+CGx9l3VvPYvar8+1eXGbYsA4KEWl01c+OsMBj7Pb/3JjFHiPfOgWq5lOTDzrNZfM53Mdpe7rMZKNbfr7WUN1VGZydrdPkUFcjfqK78EE0uglGAsCVWDVHsyNRQinx0oh/sU14gVkqGRRseSIzBsZj3vS+wAzTEtYPd6BJ6TkpoWRdsPO9MMsnNcGEPYFh9SrXJ/0X7lYToLJ9GBhtXYwuhBcb1PfcKvuPHWISE+SuWEu+OPLuXNS6dtluNWH3YWbXkl4VJR64EiKr4X8RXH6+zmyAa2Fjhhz81LGC7WAI2QPPalA/oUFIwPGC9Zk6WljixrFFbBXU7kIYBu3P+pbKThbn1TdC8qAzLsCQI5xnDNInRkx/t/QT0HOGnCupbTYczxbabkDU9oHVBoatZD4THOF5Xn2ZzhHqCOPWBN8a0tCsWNYUCquC/QKMjZ0wSHBrJCvmvADEdyOBdJfaD9E4qL4SJm0wQkJvG/cWJw/xXUOyfE0Hk8VGMO+0gJmzROm4Ea31TtKmMQlLBdzARR39rQLXjBWrHKFt+3dMzyUtAVk4JxCNoadNOX/Fz3YWObRnnqc1jU+P8wr/cFU6Fxn+yWS9CImfRLmcEYYpOVqea4tN7Q0rEfVHrIuLQ/s6LFW7sxMJqXvReBaFjYMKQsBbOtTKchpFKB6neMWuGYbasAK96LRZwR7zv14bajdBIRe0LRBr4dzXwxtMPIKS5/qmnWMmJZFN+WIQfBowezBczmxiiSJfjC6HgS6DRJX86wZ4AHOnVevpvUwb/1WfIvyhN8Bts85/4oX+vUmLhC1ouqKSioYODYJHu6JqzIkPLzr/
 uRuFR465
 u3aUToiCRYC7UmfdqaqiLoLNocfivLaU3lPIKzA3jfDOHLmHT5/xyUQNff2+MORTLTTCyoTxy3pYnkt7zMBV2jkLBwIdhsHJw541IgYnc9D5zjTeYp0AnyoTb4eqnfAUVVVWA2tLDts8DnL3cNz07NPrHecedvo7h7VtltKau4wxddL39xe8xnZ9X/UNEaUe2+EnKUQk+MxR6h7WeTw2zoEB3VvS/0dVNXzzuU6xdhTpDo8LM7EzO4eIKwT9qq9LduTvGhoDFB8Mzjuyn4n0AQtsEpHZ4yyqS0ytLRx7FOu2gv4wR5EBCrPGnhvwyuL9UUI+mXc6kRRMywfVsYoyIWj58PYo8nvbtDj+a3e9EWFRzR8DJnTYFRy7Nd7TTZG2kFXdoMx1jdoAJp0hBrqaBi33P/1PeayFMPsA3UdfNQTICA3aMJT8+odVpo1xxJa7QZsAmJ7phviMCUys=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 08, 2025 at 01:32:05PM +0200, David Hildenbrand wrote:
> On 08.09.25 12:38, Kiryl Shutsemau wrote:
> > On Mon, Sep 08, 2025 at 05:07:41PM +0800, Lance Yang wrote:
> > > From: Lance Yang <lance.yang@linux.dev>
> > > 
> > > When we stumble over a fully-mapped mlocked THP in the deferred shrinker,
> > > it does not make sense to try to detect whether it is underused, because
> > > try_to_map_unused_to_zeropage(), called while splitting the folio, will not
> > > actually replace any zeroed pages by the shared zeropage.
> > 
> > It makes me think, does KSM follows the same logic as
> > try_to_map_unused_to_zeropage()?
> > 
> > I cannot immediately find what prevents KSM from replacing zeroed mlocked
> > folio with ZERO_PAGE().
> > 
> > Hm?
> 
> I assume if you're using mlock and at the same time enable KSM for a
> process/VMA, you're doing something wrong.
> 
> In contrast, THP is supposed to be transparent (yeah, I know ...).

Yeah, I guess it is user error.

Maybe we should make ksm_compatible() return false for VM_LOCKED?
KSM breaks mlock() contract.

But it can be risky if someone already relies on this broken behaviour.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

