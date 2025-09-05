Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1212DCA1013
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 13:36:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5807C8E0009; Fri,  5 Sep 2025 09:36:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 558C18E0008; Fri,  5 Sep 2025 09:36:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46EF38E0009; Fri,  5 Sep 2025 09:36:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 31FBC8E0008
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 09:36:45 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CC38784C1B
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 13:36:44 +0000 (UTC)
X-FDA: 83855296728.22.899B896
Received: from fhigh-a4-smtp.messagingengine.com (fhigh-a4-smtp.messagingengine.com [103.168.172.155])
	by imf29.hostedemail.com (Postfix) with ESMTP id 7EDEB120011
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 13:36:40 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="u v/ZwtS";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=dRZxjH0C;
	spf=pass (imf29.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.155 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757079400;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q5uirlwovFHRBKqnyGJRRUkN8CZ05VWeSMEDpIk2emA=;
	b=1pYnI6GmGnyYz0SDUcYG7sWJ61cWcxjgLkjqpzZksvg6l2Eqzc9ImnUlQVfEKzyW4Z42S8
	WNgmqISBzhgyOj7Kc2yMo8B1oKtzulALgsHeIlkRzLA43CHI4MM4Ay0rqR7rOUfZNd1QlS
	cDWPosNjH7okEmBfE2Nt7BMSz5DVRJk=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="u v/ZwtS";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=dRZxjH0C;
	spf=pass (imf29.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.155 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757079400; a=rsa-sha256;
	cv=none;
	b=e8vmdgNwKWibZT6H122N9C6YeLjLHjluiW/0snuCa41erW3TiAXhqW2YxbWMkE3tkls3yB
	rtIsGrnp6oNQpCngOUPSqzXuhtf+YMHTn0/33WJ90uFzDQFHIFaL8orB/kRoa0G8KuhexS
	DbiBPiteSwmJYOokDZ1IRBSk1VX3GVs=
Received: from phl-compute-09.internal (phl-compute-09.internal [10.202.2.49])
	by mailfhigh.phl.internal (Postfix) with ESMTP id D5B58140030B;
	Fri,  5 Sep 2025 09:36:39 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-09.internal (MEProxy); Fri, 05 Sep 2025 09:36:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1757079399; x=
	1757165799; bh=Q5uirlwovFHRBKqnyGJRRUkN8CZ05VWeSMEDpIk2emA=; b=u
	v/ZwtSNgyOEtJvt39uK6DcXNlRC5pf1TLq0VZlddCUNUmYpcY81wcFc04FFlXz0D
	qlIixYwUqqU4JGPfaMAq5TztsAMkggW9EMELF88YuaLiQaMmv5qxiGGPT9jxtpsk
	/ofg7VtvM9vo5ObG5um94XRqHkgd/iiQHWgkO7mJnw72Yiji8dLVpJB598p5deEC
	2Tzsy7ZgkE8sgxvqhsts1fdJknbhSO4iE68AI/9hzZb7GMCi0V882u0scR8XXqMH
	eZWI9RZ20mK1JBJl578LkonNNrkIuRlP2y6sGLpxypCSeZ/Ovj3u5WNh1yhFV8US
	EV18BpSXLYdQc7PQJFbBQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1757079399; x=1757165799; bh=Q5uirlwovFHRBKqnyGJRRUkN8CZ05VWeSME
	DpIk2emA=; b=dRZxjH0CBq2gnrBjXmHXg5ggCxpo0LSF+YVOQJeMxnY/j6NQp8i
	xItzzvs3H5thMiMFG6aluiXk6en7vc6tM1Fw8ldwegqQbrUR0hnipdxHuQEyM6Ev
	5ZsYEg/v6Cg6mYVSAg3PAUZ47gx0bHGBOPkaYN++X8ksGEZ4idhGo+zQ5kv6k9MA
	ex0Jdj5BHoL8qB+Q9AgJaazVJB8qrWmyrQDF3j1nZeQqW8m3hbc7BrzFpxj2WCU9
	wvyvFwoFTBJLVQ3BmzQV8e0CM5l2yb2OxmsZOCTzLZOi3kL8EcJ9PQdZAvTPIzy8
	gSI67OtNh+ZO5sk50GkCJBct5WngD17+MIg==
X-ME-Sender: <xms:Z-e6aPTIR4Q6EBjq-de5enozS_cV6juHmkaLzDkSSsUUGVUWb14VGw>
    <xme:Z-e6aHXRsb_ZmsB3con7T5tO8L_2R3SqyZaLcH-6X7ZWDB7aZev8MVMqu0dhMgdlW
    OIVro-fwhew4pNEjpk>
X-ME-Received: <xmr:Z-e6aGiqpAPf5t8uYqZP50VLJ3kAstQqqce6xdUUJr6sexkUl3PQ5VKXA0NM>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdeltddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceurghi
    lhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurh
    epfffhvfevuffkfhggtggujgesthdtsfdttddtvdenucfhrhhomhepmfhirhihlhcuufhh
    uhhtshgvmhgruhcuoehkihhrihhllhesshhhuhhtvghmohhvrdhnrghmvgeqnecuggftrf
    grthhtvghrnhepjeehueefuddvgfejkeeivdejvdegjefgfeeiteevfffhtddvtdeludfh
    feefffdunecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomh
    epkhhirhhilhhlsehshhhuthgvmhhovhdrnhgrmhgvpdhnsggprhgtphhtthhopedvtddp
    mhhouggvpehsmhhtphhouhhtpdhrtghpthhtoheprhhpphhtsehkvghrnhgvlhdrohhrgh
    dprhgtphhtthhopegrkhhpmheslhhinhhugidqfhhouhhnuggrthhiohhnrdhorhhgpdhr
    tghpthhtohepuggrvhhiugesrhgvughhrghtrdgtohhmpdhrtghpthhtoheplhhorhgvnh
    iiohdrshhtohgrkhgvshesohhrrggtlhgvrdgtohhmpdhrtghpthhtoheplhhirghmrdhh
    ohiflhgvthhtsehorhgrtghlvgdrtghomhdprhgtphhtthhopehvsggrsghkrgesshhush
    gvrdgtiidprhgtphhtthhopehsuhhrvghnsgesghhoohhglhgvrdgtohhmpdhrtghpthht
    ohepmhhhohgtkhhosehsuhhsvgdrtghomhdprhgtphhtthhopehlihhnuhigqdhmmheskh
    hvrggtkhdrohhrgh
X-ME-Proxy: <xmx:Z-e6aIdQBXjQ6C3Lv1CYpBHgiTFyF06qC89nNp8YWT28aBDQJkWW1A>
    <xmx:Z-e6aJfLxlPdbbOvjvGBaumw7--6hKYwn_eROi8pnpZPkp0cIp064g>
    <xmx:Z-e6aMVNIQLk9EM12fUJSYW_0rv20Zso3fKfAB145Zq3YZoBn2aYww>
    <xmx:Z-e6aFfyetjy2Xxudy3rjjsVQVLuUqJoX3XgQ6vfw8Cffcuxi_tzLA>
    <xmx:Z-e6aFTTCPIEhuDyrFpn4Szx7s84sU0AMIC3zXeyM2Kk8qODUKQqWk26>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 5 Sep 2025 09:36:38 -0400 (EDT)
Date: Fri, 5 Sep 2025 14:36:36 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@redhat.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, 
	Usama Arif <usamaarif642@gmail.com>
Subject: Re: [PATCH] tools/mm: Add madvise tool
Message-ID: <txdm2edac7x6bfxcnjri5g4e5qoz4qhbtwi7bpdta6yqeseroo@iqspqwpo24i5>
References: <20250904175729.1029735-1-kirill@shutemov.name>
 <aLrCfvlhWRCEmwXc@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aLrCfvlhWRCEmwXc@kernel.org>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 7EDEB120011
X-Stat-Signature: 5owr4c3ahsqtga8wr33tm6rhtgc7jozr
X-Rspam-User: 
X-HE-Tag: 1757079400-291017
X-HE-Meta: U2FsdGVkX19t4mST+7XeaG93Y2xWzazL0QEiHArsyZeJjON+JIXs4LjR25QfaYjCKD1xcec3a4YI5CrfcV6+A2usohLu2VXBYUP9PNiZJR5luIAsbR8AkXOS6wQVoc5MjvKBeBNQUY1/BWjwFkhAclm06iyc3TUoE7yEGfR/ItZooYsNfMz1bPlXStqLDS6j5ebdysHIXVSaF54xqPIwVY2w4r3mwQ1TBjH/82bT/54nT7PiFI2973kWoEYYqE+cefvuiVii3XfmTotx15aOheGQBk753Bh1Tr7YFxnMT9ro7MnZAGh2WkE0BjoIuOzNWWx4U1uyBS2WYHGbeIs37LRq+2LC8IUgip3kggxRditPFI4VzWa3cYyiRgvipMaQ0WUX1Hvf9FVBiv0pE0zrxTa+XddpPf/mLARidB+7Je/eszfEwaHSZh+i/WeSFIWMJ3AcDaXCT9Sv8TzbRnja49th/I88fLAamSukjyQ9umIp7xDe2gzjaZUu9UIjZJgXzsVx8tc76FkrawrVQf3annj9Fvbkf9JMvlqmatYXEU2mrzCsEeKmX+sX0ut7XmHQPKfrQd5QJdmZ5kStKPi/Ruq6ROcsl/11SCv9o1FoH1pPxLuV546K56iQAcS/IxslbFMsLozcyM9qkxC+Bn0SskpMCyhT4Al4eAVZfpev3v51SIT7182xU/4fAyy5J4GxvkmU8lq1sBtRsSUVh03o9fAxMwCjdRqv+0WTq9nUMdczqKFz54xpQ8MpkebyJHBAbFdiEUeRUPumc9qdVkpMaf09quLP+AxL2cOV156mtrFarevd5dK7Lngzld340IAGqvCVa7iFHy9AYaIpndbGCOYPbmgwd6DdriGYKFiPQbSXtRmXSLTRLU3JG25I1JKlBdZUwVMAD1OMRqh1R6M9U0ImxgSqpEYPG5887o599tgfAsPOAyXB6c4jI0sWy9M0OWTF2WJ4awCzhrRdxGd
 vbjcz8h3
 MlgAJ/wNQ+pC7WAxkZZ6C3WT9VXDAly66kUe7Fs6dBPour8QyqcyDUatBASz04kv5tZySlrdTmAIJqcL2vBrxi1gl8/EXrxvUK9mGq9TfEKZ+nnOpPpkpjMxqqWVCtXJdU8wpdtJG3bHljtkJ7Yyb1BxodRH23tpyPrKYVWGbbo2Xes/83lbTLm4QMpSIpOsH79JWNrLM1kp20vzWPgh8dY7wSs8yACohba5PSv5BnebKAqLvgwhJ2TFaorvwFSww6B1Do1iPf+xndR4uvmSXPdX2vzoEaIpI/2bx3rScA/pVTI8fCBJL5Q9kTjOTggFj5I17Jsm+nSs41ajM4MMAPt5L3TBSRbyBONymuyV3TjCbijGVusgoYDKfKr/R7xhGiYC6J4CsER61tbw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 05, 2025 at 01:59:10PM +0300, Mike Rapoport wrote:
> On Thu, Sep 04, 2025 at 06:57:29PM +0100, kirill@shutemov.name wrote:
> > From: Kiryl Shutsemau <kas@kernel.org>
> > 
> > Add a simple tool that allows to issue an advice on a process or a file.
> > 
> > It can be useful to experiment with effects of an advice on a workload
> > without modifying the workload itself.
> > 
> > Only supports advices available for process_madvise().
> > 
> > Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> > ---
> >  tools/mm/.gitignore |   4 +-
> >  tools/mm/Makefile   |   2 +-
> >  tools/mm/madvise.c  | 170 ++++++++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 174 insertions(+), 2 deletions(-)
> >  create mode 100644 tools/mm/madvise.c
> > 
> 
> ...
> 
> > +		unsigned long addr, hpage_pmd_size;
> > +		void *p;
> > +		int ret;
> > +
> > +		hpage_pmd_size = read_pmd_pagesize();
> > +		if (!hpage_pmd_size) {
> > +			printf("Reading PMD pagesize failed");
> > +			exit(-1);
> 
> Shouldn't it fail only for collapse? Other advices don't depend on THP.

True. But aligning everybody wouldn't hurt.

I would argue MADV_COLLAPSE shouldn't require this either. You don't
need PMD to collapse page cache folio.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

