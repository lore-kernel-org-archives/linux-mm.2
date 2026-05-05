Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7CD63CD13DA
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 05:54:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 664F86B0005; Tue,  5 May 2026 01:54:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 615316B008A; Tue,  5 May 2026 01:54:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4DD566B008C; Tue,  5 May 2026 01:54:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 376426B0005
	for <linux-mm@kvack.org>; Tue,  5 May 2026 01:54:27 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CBB491C0121
	for <linux-mm@kvack.org>; Tue,  5 May 2026 05:54:26 +0000 (UTC)
X-FDA: 84732301332.10.8143CEC
Received: from fhigh-b8-smtp.messagingengine.com (fhigh-b8-smtp.messagingengine.com [202.12.124.159])
	by imf06.hostedemail.com (Postfix) with ESMTP id BD0DC180002
	for <linux-mm@kvack.org>; Tue,  5 May 2026 05:54:24 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm2 header.b=u5y7ZoA9;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="c vfkQ8L";
	dmarc=pass (policy=none) header.from=arndb.de;
	spf=pass (imf06.hostedemail.com: domain of arnd@arndb.de designates 202.12.124.159 as permitted sender) smtp.mailfrom=arnd@arndb.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777960464;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JmfJF9VZOdx6cRELR7IxehWhdMlZxoCBVCSMgdOhjE4=;
	b=XaKCAvfCpBQjiB3OWclHd7ONNNKieVAmjFVJpBVEp9c7ww+p1RQMTdrcw0U5U6r2CAUTPy
	HFcUw5IPhd3aFUHHA70Jmg1h9KLadsrQKnaZ0JSwD+AhNN1CO2ZvuT9BVDwhN44lXdhyIB
	QncAIw4d4Duw6yF6Y78jceO3mVNFxjQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777960464; a=rsa-sha256;
	cv=none;
	b=zijc+/fRQBpWT2eZf6EnBl1yXZh4XpJbjDWFg0soNxVxPJSvY7JHTWmW39zoT7X0tC1B66
	OxaaBQEq7BRssUlGBcC37PXe5Ml1KnKmkW59MRd4kpdvyRoaScmQ0dkAfb2ylEBQ00cK2c
	1EDBLUTHZrAGxinNTZ/b9dTHb2idv+E=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm2 header.b=u5y7ZoA9;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="c vfkQ8L";
	dmarc=pass (policy=none) header.from=arndb.de;
	spf=pass (imf06.hostedemail.com: domain of arnd@arndb.de designates 202.12.124.159 as permitted sender) smtp.mailfrom=arnd@arndb.de
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 5C2CB7A0101;
	Tue,  5 May 2026 01:54:23 -0400 (EDT)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-04.internal (MEProxy); Tue, 05 May 2026 01:54:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1777960463;
	 x=1778046863; bh=JmfJF9VZOdx6cRELR7IxehWhdMlZxoCBVCSMgdOhjE4=; b=
	u5y7ZoA9eMuhoBDaFkyut2LXUpEqlffigmhHhnF64AUhHR7cnoryMMaxmEiJ5x6U
	Bjj9bhf3wxfvrTtTq+JafgfiTZnScp2Gu1QbaLd1QYqadEU38XrlCszrf+f40Jk7
	MV6zhqVBzbkQkk2MiVMYRiFDRSU/Ga27V388Yos0mNXEvLYPMAhAhohugp8cLiu4
	uqVNzqKvXCLdtc4ZyvneysGr0B6l+OrwDUTWpOiaKMbtUS9q5W7Te+yFhh34xmsa
	bF5dtkdpPdExcTwOq6C1CxWRrMvqHchHNQCsOU/VuAbSecTd6Km3ah9WHCpKu3kl
	g8Up5VgKyxp+83DcMvtLMQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1777960463; x=
	1778046863; bh=JmfJF9VZOdx6cRELR7IxehWhdMlZxoCBVCSMgdOhjE4=; b=c
	vfkQ8LErF1rWwYsXdqTOd1lvL7JBRtVY3PbG6sI8WbtF72dYEyGEOoryf/PTyglS
	3mjevzN4vzc5bP8Di7/ii6qRH4Vo1+icVm8XL7wS+aUnOKsu6QZhk6P8TQP3iWS3
	J7zSawtaivti0vx7TwA1kUcJYcMHc6f8vLJy/MqVuRXNNwagRAoWeUFFkzYooY36
	stgZ7Dz9xeSFESrh0G++rHO/b/POPv2Bn4SIV/GImq9rjNq6vViPuN17j12YSxgu
	wbqw5vPZuXjwwK8ENcQAnWqnZQbh5Vv6AyZPyomYIm4K6E5E6Mn6W+Pp1VMM7JRf
	VpnXd7Mca2etHTMspOwcg==
X-ME-Sender: <xms:Dob5admH6Uv6729At1Wuwyl2GIRgJuRRweEAeyrSXSapSZrUWXtbHg>
    <xme:Dob5aTqhFmhPNScrpV1lE8Rvj5XVBDx5iDZUxWwbonQdgYNdE6YD-m1Rlde8799_r
    hR5z1jPEjRUQpN3hQPIlPN7GtbpgAS0wx7TUtCus38GPBMIxZEbmQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgddutddtleefucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepofggfffhvfevkfgjfhfutgfgsehtjeertdertddtnecuhfhrohhmpedftehrnhgu
    uceuvghrghhmrghnnhdfuceorghrnhgusegrrhhnuggsrdguvgeqnecuggftrfgrthhtvg
    hrnhepfefhheetffduvdfgieeghfejtedvkeetkeejfeekkeelffejteevvdeghffhiefh
    necuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpegrrhhnugesrghrnhgusgdruggvpdhnsggprhgt
    phhtthhopedujedpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohepnhhitghkrdguvg
    hsrghulhhnihgvrhhsodhlkhhmlhesghhmrghilhdrtghomhdprhgtphhtthhopehrohhs
    vghnphesghhmrghilhdrtghomhdprhgtphhtthhopehjuhhsthhinhhsthhithhtsehgoh
    hoghhlvgdrtghomhdprhgtphhtthhopehmohhrsghosehgohhoghhlvgdrtghomhdprhgt
    phhtthhopehsuhhrvghnsgesghhoohhglhgvrdgtohhmpdhrtghpthhtoheplhhirghmse
    hinhhfrhgruggvrggurdhorhhgpdhrtghpthhtohepuggrvhhiugeskhgvrhhnvghlrdho
    rhhgpdhrtghpthhtoheplhhjsheskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepnhgrth
    hhrghnsehkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:Dob5aWvudqQklw5FkPvca27pngxBqaXdFjB0UEmBZSsFKI9Vq7cghw>
    <xmx:Dob5acYjtLE4zyJnH8SKg7oyP4UeJuqxnX-KvRlErKVc2OxkjorIWA>
    <xmx:Dob5aSElDA-x-F3oI5bm0Z2vz4B9cS_BuW7lUnoyga17KJOr9jHLkg>
    <xmx:Dob5afo-ddfADE42I5tBWOnDtv8JNK9WojrkzHnDgJPBvNylAZNWwA>
    <xmx:D4b5aVbKQycBvvy3SX40wM6fWUfzTw41oOlAo7uI4zgMeIj2iY9VIpq2>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 17BDC700065; Tue,  5 May 2026 01:54:22 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
MIME-Version: 1.0
X-ThreadId: A79HWrF7w_-Z
Date: Tue, 05 May 2026 07:54:01 +0200
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Rosen Penev" <rosenp@gmail.com>, linux-mm@kvack.org
Cc: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
 "Andrew Morton" <akpm@linux-foundation.org>,
 "David Hildenbrand (Red Hat)" <david@kernel.org>,
 "Lorenzo Stoakes" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 "Mike Rapoport" <rppt@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>,
 "Michal Hocko" <mhocko@suse.com>, "Nathan Chancellor" <nathan@kernel.org>,
 "Nick Desaulniers" <nick.desaulniers+lkml@gmail.com>,
 "Bill Wendling" <morbo@google.com>, "Justin Stitt" <justinstitt@google.com>,
 "open list" <linux-kernel@vger.kernel.org>,
 "open list:CLANG/LLVM BUILD SUPPORT:Keyword:b(?i:clang|llvm)b" <llvm@lists.linux.dev>
Message-Id: <0f11390f-e8bd-4f8d-aea8-59ef545b2c32@app.fastmail.com>
In-Reply-To: <20260505010112.645361-1-rosenp@gmail.com>
References: <20260505010112.645361-1-rosenp@gmail.com>
Subject: Re: [PATCH] mm: move phys_mem_access_prot_allowed to header
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: BD0DC180002
X-Stat-Signature: 41rciuxxuoumi6ouwuygckrhnpsg979c
X-Rspam-User: 
X-HE-Tag: 1777960464-95296
X-HE-Meta: U2FsdGVkX19Qqgpts++Y2zVAjdUn/2YA4dMQKoVCJ5flO0X4QtcjAtYGhdyM9uqnJhU8LcBnSS2H7EMquuH1vAfymslM3SGtbVBddeZJWTv5bDbJmql3WdZrQMC6vDgc2JyGicFS+WsM724gtsb8YIiKT5V11Yg5MGdsrOO+J9+qeIZ23wa3QKrkZkUEW39jvUCwFrOg9Ey/s8WXZD/AVxRK9FX0KNpXip4qyyxym2ZFZW3/RJ+ejbBpptucFQEKjxAEyWM+1znwcD3klc4b1WLcM08d+u4YfsLzZ3dOw54xxO/RWIns35P+H05pm7NESq/xBDJbVePlprNYb5G30jtengWRNA1QkSIiu7wBOt+/9mNp5X/HFviEjXc0Xyf2NnQk4REXWDkpTGRN7Zpzc5yXbTMebyhQ6p2ce+6qIdpwcgeNiVekpzWj6X0UpL66RpOTAshbOtL9En9W0KWHFXPbs7JjEF6XkbHdRt5jri88z1RAhVEp8s953rPv5XAaeGqm+aaalXP8gKGGn/WhfbXCY3lR/J8GvhBOdRwg02bh+Hjz6UtCo083uiohr5pt3qC6ocCBO2mC2CKxM3mQ3N+0GS0DvEXgbjK/2KcbLLp0mUjM/LAbcMoeFPZKwH6suwvYwm6tM9ratBSEURBxFv3AlMYOV7ZEzfelR3avYhAbDHroQVoSjds7C0+EdI9c+WHa8o1FQPZ665Vmksc26AZY8EEtYKPPSKGRShISGwqMOd8NVKMHs0IS4M1g5JpsURj4XbrDZcS1eWyesP2Cyh9qxVsYJ1Tm5B4gMznowAmobpka5UtvJ/arg+mpC9RLbiP3f3gDhgmt/Ofi4ePYRyNudPlKQhM2zwnDO0LohwIQjjD7xwyv7AlFtP0+nZEo2hwAYgES70AYIOgFUY23aPo379OmBzLLw1/pbG3PBzd7qPlpn07hZgkW/OrCHQBMDf2lJi7iFrmNlNdl2jd
 SNV/bQaS
 pBCCSYEZkYuBOeGtDn2QE5nPMIDyOFoLDrztEiq33gv7FygMySXBxwDM/Mp5875m3GNJ/OIjUmQYzdJntCQBiStUdXCHYcxKsYER1xNrCUXBzQ5xPQ7YlYXPjeMWtEK4Dz4se4FYQ5AJ4X7oWCbvjM46j7DjXkUvU4SoDrHz8kQFGH3hvXN+rAymTuwh6G2AAHy9DGt+gmpQTR1Dg77Ur9m2Riw///kNnFQygIMqs6pr1cUtafK2DsIrE/g3n88VFkrxh8hO4Azut6GTiURyMR7GKxP12pCBCRdCkPICe1NInwvD/ZLWOGder1ZA/3N9O2ZqxXZomWEFR3VaWa7wjetKfakLDosqIOC1VhuneaD9uzZ6ksJV8aa18t4ru1BOps8Of4l6ZPwbefvs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 5, 2026, at 03:01, Rosen Penev wrote:
> phys_mem_access_prot_allowed is only implemented for X86. For others, it
> returns 1. Move it to header to avoid using __weak.
>
> Fixes compilation with make LLVM=1 ARCH=mips

Can you describe what exactly goes wrong here on mips?

> @@ -239,12 +239,6 @@ static ssize_t write_mem(struct file *file, const 
> char __user *buf,
>  	return written;
>  }
> 
> -int __weak phys_mem_access_prot_allowed(struct file *file,
> -	unsigned long pfn, unsigned long size, pgprot_t *vma_prot)
> -{
> -	return 1;
> -}
> -

Removing __weak functions is usually an improvement, but I think
we can go further here, see the discussion from last year at

https://lore.kernel.org/all/20250520152030.1499670-1-arnd@kernel.org/#t

     Arnd

