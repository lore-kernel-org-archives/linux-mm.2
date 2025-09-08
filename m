Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E61CFCAC586
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 12:45:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D11E8E0005; Mon,  8 Sep 2025 08:45:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A90E8E0003; Mon,  8 Sep 2025 08:45:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06FAE8E0005; Mon,  8 Sep 2025 08:45:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E82D48E0003
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 08:45:09 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 85E591D3E3A
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 12:45:09 +0000 (UTC)
X-FDA: 83866053138.05.3B9099D
Received: from fhigh-a1-smtp.messagingengine.com (fhigh-a1-smtp.messagingengine.com [103.168.172.152])
	by imf30.hostedemail.com (Postfix) with ESMTP id 7778B80002
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 12:45:07 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="P q++my6";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=ANIgYuVP;
	spf=pass (imf30.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.152 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757335507;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IqcaLM9lUeWqenvd7sIQuIZg09LqmvNIOrji/77fcJ4=;
	b=OLT/d6Ltu47rWJMOpUxKtO2oD6k2y656sF4Nmxr13f/QI3SVIDhNCbUFqbMsavNg9XMbQK
	ntRG1b8EtcXoO7sFezLRGSIx7REULfMFYr8MzSOwPZLcrpBcFtCHIaIgNFZI1+MYSUwr6q
	wmU1LwBXL61nlMmGAPHvHqnCGN8lZ+8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757335507; a=rsa-sha256;
	cv=none;
	b=7RGYnxHWFFg4dEUhNu/R2coJVl842sHO6abZTN0vevhEkZreCmQw/LQy7TZl1u8MMwTSkR
	TPtNmxczHT6/ZMCzzdisZuzcOGMfIh8CvBV3dxAqareRGsakYJqeF1jCtnzTyjy0lRRRQp
	hNlkxOTerhsZXRHFxpil0y5mOQ6sDY8=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="P q++my6";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=ANIgYuVP;
	spf=pass (imf30.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.152 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-10.internal (phl-compute-10.internal [10.202.2.50])
	by mailfhigh.phl.internal (Postfix) with ESMTP id C76641400013;
	Mon,  8 Sep 2025 08:45:06 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-10.internal (MEProxy); Mon, 08 Sep 2025 08:45:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1757335506; x=
	1757421906; bh=IqcaLM9lUeWqenvd7sIQuIZg09LqmvNIOrji/77fcJ4=; b=P
	q++my64etQX214uWp+G4KUJPfhRX2mudBXuepuWd/8d4Io4tELzDEeXADwbN2qWA
	KFOh8INDTB6wj5YwQ0KZ/x44X+vi7R5g1yri5XgOiZw+zyxn8ff3oXi5rBCV6PRO
	yyNqpD9BozaysJWLIOrLpZCZ14UIik4m8J9uH0+tEqPtsvIJSBdW+JqBbICxV5K9
	DtVI86rDYqPo8+eSWV6C5jTb7hyRCTPuoQmrZI1KfgLO+OfV9/1Z4vJbuADArYAL
	0NpBGRDsxfKVyspEuq/R8FzxpBECNSZVvo0UTGUbg6gRriXO+U2a+NurfgyewWWp
	/DPSZYG3x2vBYasIDGVUA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1757335506; x=1757421906; bh=IqcaLM9lUeWqenvd7sIQuIZg09LqmvNIOrj
	i/77fcJ4=; b=ANIgYuVPVufOGB762X/PSRKxT/um2lVE4qhiGkHcDme3NiCep7L
	+jnn9W098wUANQEdIwdp8LXY9VPGiPk5SerN9PL4s/Ss0+MLyKslKPzSYwtvYsi+
	Xt5wUAoKlRZ1ihTwTn5Jb8r1hIYoWFHGeBhUue6BHcYvsRsFINoqm5vdzJafPJ+0
	Zakoc224Uh+yHbtItJcXuVCWCQARyvltgqOh3N7UjAfAEn5+q66FonfFJsNplQiY
	j9s94F4My49C9/WfGB4PxyJ3RdZkUzkwlDSG9dH57S5jbMpUrOU762NZ07ZqRjXB
	kGxnlLqvG6y4HDUq0Ya9eW3k1BktJqIjEuQ==
X-ME-Sender: <xms:0s--aFBjwkyO9L3uVP-U6xYv5JBXbFD7yKy6BTYo3Bz9QUXIRpGs5Q>
    <xme:0s--aIo_YsvXsCUGx1HCetFlF3fcN8chc7HCm5Xrc--Z2XO93hO6rGzdX_yeFxc5U
    nKJC_nobMsWB9EQWWo>
X-ME-Received: <xmr:0s--aH0T1GwWKu9_DptJlTYTH4Mhk0QLHw77gthE_hhvSjRVFo5kf4WmFcQsjA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddujeehjecutefuodetggdotefrod
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
X-ME-Proxy: <xmx:0s--aHV7uDq_25bKGkKHChSd0o8dvwm4yy2eb7naesuSPVA_twmGuQ>
    <xmx:0s--aAwCd0Iq6umDBH5Rw-wSgA2gdLdvcjnTHHb6AskE8tXbxow4OA>
    <xmx:0s--aD2RTWgd0eJEFprSbO8S4yCvmH9koz4Wy7PgoGZz9y7lnLsWYg>
    <xmx:0s--aLsoC2D3OMeg7ewfPRLe6o4KJaBwHmhbHgYra7kir2s4-hpV6w>
    <xmx:0s--aKQapvKOzdVy5CAvCZ1bA8hq3emL9ArmsLWtYRVR9juCqzwjdzEk>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 8 Sep 2025 08:45:05 -0400 (EDT)
Date: Mon, 8 Sep 2025 13:45:03 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: David Hildenbrand <david@redhat.com>
Cc: Lance Yang <lance.yang@linux.dev>, akpm@linux-foundation.org, 
	Liam.Howlett@oracle.com, baohua@kernel.org, baolin.wang@linux.alibaba.com, 
	dev.jain@arm.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	lorenzo.stoakes@oracle.com, npache@redhat.com, ryan.roberts@arm.com, usamaarif642@gmail.com, 
	ziy@nvidia.com
Subject: Re: [PATCH v2 1/1] mm: skip mlocked THPs that are underused early in
 deferred_split_scan()
Message-ID: <7pmksyuurzi2df5r7d2lpku63rbimjy5e3dzmleb63ik4257ge@2sm7yqfqvolf>
References: <20250908090741.61519-1-lance.yang@linux.dev>
 <niywtremc5kfhs3lenmfxvbiiizyexnaw3m25twedmzovfoeno@lk2o46tfdklk>
 <9a0c07b9-5bf0-4251-8609-fbaf0ca75bf9@redhat.com>
 <5j6i2o6umqwxabdfncbrdytmvdma4yrraxe6hu4csckcniduya@sm3mlablwbad>
 <f58a472f-4a36-40e7-94d2-229125ae7373@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f58a472f-4a36-40e7-94d2-229125ae7373@redhat.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7778B80002
X-Stat-Signature: mfbyqin198tnj81sw1t8kpfnpewi9bzp
X-HE-Tag: 1757335507-843614
X-HE-Meta: U2FsdGVkX1/xqNWvtrhDbaWvCOMoFDj2VU0rygy4FAGZdlEXLXMF2CUMPBRlTcunefi9F1K4M9MDuMd6xs1/Ei/hNM3Ck+AjeeXGlLlAIsByxnntwHw+/OdE7SpaLqQfnpe4Usy05XGq6GA01MpiH5hsrUBk1ooAS14/GbqeX04TrHAAeTxA54rltdCzeQ82KSBAupYg874InxYiqp9ofz25dyOd1A1KdoPq2U4N21CrL/LvgGlGVLVgO0msoA3C8e6L9s7EPvmUquCqllSLTRLY8ZudVXNDYQ5Fmcfsq1G0GeOSFhIIUHcAFV+yov0Q0tOqvQ/vhTfZeNFsRY6c2RB8oTcO+/cIxucvrAUzSZ7Zdz0848E4kRbyMv2TBTdHs2cWuusLsjAVDVGAN9ZmaDjFJiE54r4Xs3wIU5jDeiJUK9bqT/OE3akJ2cRLNO1IBpO7913rhRqy7epQ9Py642fBTfiZZ8B0t61GW+TY9HoX7Qxj8BsG+8StTsGAaSSJ2EImmWmuqdy1BRvzkY9MYyoA/SuY6hH6jeAAZKUX6gOQyd6B8KuvZj/y1FXKCJEQFw7N4IJH4JTtv1zXkUYxxUx39bn5V57CvzxS9z+UI1pTrR64k9GjjEVT/QgJLxMNhQohL+Ekr8TQXDhTRkedu5ao2SLG9XMtrEP8MzJ/PtKTCGbgS6DZ5jvwi7oYbt7+HGVBN9b1gX3lsXG+B2BBz5VMyhNR75UdBV09i2YpxKUQT2jJeFKXx94kFTsxETMk9oiM7T9xGNLzfThEuIkZQBTl1nI5wq1kvrk0CMJktwSn8WGrHgU9eGT86ICxOQewFiH4B/pkW9vnmoZ3YL5rlhC8J3cyHsYYfU8zebk4C8T+WtPk3znDY2jSfiXedQWffJjALAo6OMDWHBiAYfQr+180vED9n302BTxPpnRTltiHVJG6CgjZcX/ciGI6BTV+0eSYCePesxNlzt9iRdJ
 SY7QNY45
 wps+9P3zC2/A3MmCa8Qc05sVdux8Jzhsy7agtJIzs2qPYqxp5Ucue6rMEeRCC7P1dIchTUDh/L8Ma6ftNBthC3a69FWF8tHXDronbktbSsaTOiLrSd6uotgx9Au1TZKfxgAYiqMWjMVfE0jI/iNC1X7NU/hWW05x+vqJZBYN4NR6miar11gy8ce3jd/W+YUIpbRZbrdoJZBjTbsVgHEj1HY+PMNx8Y1htGxeC0DSgPqhdAr0CL0LlaVwHFWDEXan34BVeNp5ON59mBmU6d69/gh7OoUlCUnxhc1Oyf8oBUr+Y+0hBg0300Q3nas+Zi9SNHYR4WjTewdVBcPgmlDxG8M9eDkWLbf/haZbrwbq7aYvTl9mcuCOFATvbIrOkq9v9BtRZC1YwJSTp//eaR8Aeuutbmc3Hbhor1r25
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 08, 2025 at 02:04:05PM +0200, David Hildenbrand wrote:
> On 08.09.25 13:44, Kiryl Shutsemau wrote:
> > On Mon, Sep 08, 2025 at 01:32:05PM +0200, David Hildenbrand wrote:
> > > On 08.09.25 12:38, Kiryl Shutsemau wrote:
> > > > On Mon, Sep 08, 2025 at 05:07:41PM +0800, Lance Yang wrote:
> > > > > From: Lance Yang <lance.yang@linux.dev>
> > > > > 
> > > > > When we stumble over a fully-mapped mlocked THP in the deferred shrinker,
> > > > > it does not make sense to try to detect whether it is underused, because
> > > > > try_to_map_unused_to_zeropage(), called while splitting the folio, will not
> > > > > actually replace any zeroed pages by the shared zeropage.
> > > > 
> > > > It makes me think, does KSM follows the same logic as
> > > > try_to_map_unused_to_zeropage()?
> > > > 
> > > > I cannot immediately find what prevents KSM from replacing zeroed mlocked
> > > > folio with ZERO_PAGE().
> > > > 
> > > > Hm?
> > > 
> > > I assume if you're using mlock and at the same time enable KSM for a
> > > process/VMA, you're doing something wrong.
> > > 
> > > In contrast, THP is supposed to be transparent (yeah, I know ...).
> > 
> > Yeah, I guess it is user error.
> > 
> > Maybe we should make ksm_compatible() return false for VM_LOCKED?
> > KSM breaks mlock() contract.
> 
> I was thinking the same and falsely remembered that we would already be
> checking for that.
> 
> > 
> > But it can be risky if someone already relies on this broken behaviour.
> 
> Could be.
> 
> Staring at QEMU, we have the following parameters:
> 
> 	mem-merge=on|off
> 
>     	Enables or disables memory merge support. This feature, when 	
>         supported by the host, de-duplicates identical memory pages
>         among VMs instances (enabled by default).
> 
> And
> 
> 	-overcommit mem-lock=on|off|on-fault
> 
> 	"Run qemu with hints about host resource overcommit. The default
> 	 is to assume that host overcommits all resources."
> 
> 
> Now, I would assume that anybody who sets "-overcommit mem-lock=on" either
> 
> (a) Has KSM disabled on that machine.
> 
> (b) Sets mem-merge=off
> 
> as well. But QEMU would allow for configuring it.

ksm_madvise(MADV_MERGEABLE) succeeds on !vma_ksm_compatible(), so it
wouldn't be functional breakage, but may result in unexpected increase
of memory consumption.

> Interestingly, mm_populate()->populate_vma_page_range() wants to break COW.
> [*]
> 
> But if the app later calls fork(), we still allow for cow-sharing pages with
> the child. (another case of "don't do it", like KSM I guess)

CoW has bunch of these "don't do it". :P

> [*] it doesn't do it for mappings that start out R/O. I think we might end
> up with sharedzero pages in that case, but not sure if worth fixing.
> 
> -- 
> Cheers
> 
> David / dhildenb
> 

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

