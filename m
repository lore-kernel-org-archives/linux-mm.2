Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E8FAEA4FAD
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 11:13:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A9596B0089; Mon, 23 Feb 2026 06:13:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 456E96B008A; Mon, 23 Feb 2026 06:13:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3594B6B008C; Mon, 23 Feb 2026 06:13:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 24F826B0089
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 06:13:42 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CADD81408E7
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 11:13:41 +0000 (UTC)
X-FDA: 84475461042.27.ADAF662
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id D701240005
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 11:13:39 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nU2Iz6hK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771845219; a=rsa-sha256;
	cv=none;
	b=LZhS2WIz7DhNARwjq97fSN7KP/gQEJ6fXOojCGCNwsrA7IbytZuSZ8vquMOzg/fEIENsDt
	nCtIzp/NxZJiPg04s0STEa87UYWlLNJwYgFNr9b9+2w5UCkT3UNrRVPu4/PFhnbI7MJpKq
	PEq2Ge2lOs8RCM3oJ0alaw2zw8XxnDw=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nU2Iz6hK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771845219;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OIj7wTBQxVCdUHOQjQBsxqSl9iTGIuuCv9+rq477EOo=;
	b=VxqFPHxhoXgg5+ofeJNaIUCa7bwKhdyDvgeInM3phgrFOtu/oIIr8FuHQhHisypKf5P73O
	9d+sJwSTulejItTxZ7wksoONVdlCZLW6YbY/mGPr69voXCoxMSteU0Mx0PyIf2zrNDKJcD
	dn3wrqBhYI4H9sOZ67+dODDKXhsa0WY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2347960018;
	Mon, 23 Feb 2026 11:13:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D997C4AF0B;
	Mon, 23 Feb 2026 11:13:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771845218;
	bh=BZG/nWmVQJvaRxB3QpTWtxly1Zo7GKSmk5KGdklgYjk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nU2Iz6hKjL6IsT1A2j1qBAK3njQNTChQQ8T9rUSze3IvSNRt/EJP9WTkJ0DTcFmTZ
	 H/tBYCu0ui/ox9x9NJAPXm4WuFEDRBzDh50xl1GMv7nO8fegr1pjR8ZbuhxdoU7/PV
	 /2OxCPBTM2WTzmRkiFhzdlIW/RdEdO+r2cHItl2fx+0gaJvDwXoCEWtLtCYNq4w0WL
	 PnIh55v3s8tlYAaO8gdhdLC4E1ebns13ha09r+utfszuZGHylzrZP1SVgLfrRNDpxq
	 F+CMdOkFxjje3CY2T8IFV++AX9k3NESwDuDiL48t93Zervn56nmwT+veilRR/RoZKq
	 EyoNuLrD1TguQ==
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfauth.phl.internal (Postfix) with ESMTP id 66A16F4006A;
	Mon, 23 Feb 2026 06:13:37 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-03.internal (MEProxy); Mon, 23 Feb 2026 06:13:37 -0500
X-ME-Sender: <xms:YTacaUELCZurvDtD1bn7IJA1dvt_WoPXDr01Rboxw7WU1tVccQRa3w>
    <xme:YTacaZyxccSLX4Acq8fgude8STEtXyfuKHuTc59KS1mcbk6kThnYv1xxHbD8q5no-
    xp_mbtSJlodsyMLwwEuLDDS2eaaSfOqXvc8cXhmP3mce_q-deXWUw>
X-ME-Received: <xmr:YTacaVYSqdihp8QFocirTlPjz4pkx7U6fnTK-gllfjXFjEIHsl-QvBTR2SduYw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvfeejtdekucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggugfgjsehtkeertddttdejnecuhfhrohhmpefmihhrhihl
    ucfuhhhuthhsvghmrghuuceokhgrsheskhgvrhhnvghlrdhorhhgqeenucggtffrrghtth
    gvrhhnpeeigfdvtdekveejhfehtdduueeuieekjeekvdfggfdtkeegieevjedvgeetvdeh
    gfenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehkih
    hrihhllhdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqudeiudduiedvieeh
    hedqvdekgeeggeejvdekqdhkrghspeepkhgvrhhnvghlrdhorhhgsehshhhuthgvmhhovh
    drnhgrmhgvpdhnsggprhgtphhtthhopeefgedpmhhouggvpehsmhhtphhouhhtpdhrtghp
    thhtohepuggrvhhiugeskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepkhgrlhgvshhhsh
    hinhhghhesghhoohhglhgvrdgtohhmpdhrtghpthhtoheplhhsfhdqphgtsehlihhsthhs
    rdhlihhnuhigqdhfohhunhgurghtihhonhdrohhrghdprhgtphhtthhopehlihhnuhigqd
    hmmheskhhvrggtkhdrohhrghdprhgtphhtthhopeigkeeisehkvghrnhgvlhdrohhrghdp
    rhgtphhtthhopehlihhnuhigqdhkvghrnhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrgh
    dprhgtphhtthhopegrkhhpmheslhhinhhugidqfhhouhhnuggrthhiohhnrdhorhhgpdhr
    tghpthhtohepthhglhigsehlihhnuhhtrhhonhhigidruggvpdhrtghpthhtohepmhhinh
    hgohesrhgvughhrghtrdgtohhm
X-ME-Proxy: <xmx:YTacackuE1-0O3KUouoS4pj8BPZ-h7MkrbkfHET1CNxpq15GT-fvBw>
    <xmx:YTacaanmYnrFUJ3p-Oc_RllBYu6dcfn2EXHVvvS2N4hyi30V_nAE7w>
    <xmx:YTacafMCpH_dMrYhoNwz3gmDNMMtTJ--6HHdEWLhkEfGBROhK5E6OQ>
    <xmx:YTacaUqIYfpXWEteSgSQKBTgnEWxSzlObmLtvsUY7sEZKTLtlDrnOQ>
    <xmx:YTacaSQG_K1CmuuORbulCgxHsYFUIdA1vKnZGQGy72d8WO2L7laAS7R_>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 23 Feb 2026 06:13:35 -0500 (EST)
Date: Mon, 23 Feb 2026 11:13:29 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Kalesh Singh <kaleshsingh@google.com>, 
	lsf-pc@lists.linux-foundation.org, linux-mm@kvack.org, x86@kernel.org, linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport <rppt@kernel.org>, 
	Matthew Wilcox <willy@infradead.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Usama Arif <usama.arif@linux.dev>
Subject: Re: [LSF/MM/BPF TOPIC] 64k (or 16k) base page size on x86
Message-ID: <aZw1DlKHaWvgOtm_@thinkstation>
References: <aZcmlIF4bmG0twkp@thinkstation>
 <915aafb3-d1ff-4ae9-8751-f78e333a1f5f@kernel.org>
 <aZdCl8byz51Q1-v6@thinkstation>
 <17c5708d-3859-49a5-814e-bc3564bc3ac6@kernel.org>
 <aZhErt9DZcWI24_v@thinkstation>
 <d7c7ef63-e40c-40c5-8ce5-a4ca411da832@kernel.org>
 <CAC_TJvd=wKKnj=d3phZsAaarXUdUbZDGauxWNWkQtsFV-MTYEg@mail.gmail.com>
 <32ed82dd-62c3-4a5c-8bae-9465afd7e75f@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <32ed82dd-62c3-4a5c-8bae-9465afd7e75f@kernel.org>
X-Stat-Signature: iy6xpig8ykd556amgpqpjit9oj73jqpi
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D701240005
X-HE-Tag: 1771845219-157580
X-HE-Meta: U2FsdGVkX19Eb/7Z3n4tZpHorSoLPpDFMmJDmNkI+muzkUGjUoqpGazr1PXCauOAznr987Qg66sGn6nutouP6UAMZwTmG+r0AI7gCV5aQyfloLhAbE4jcZzEsbMr0aJqLW5PT8a78yd/oh8H8gj4QfZvNyJ8f2gHm5Uy4/jm/LdYLq07I1sT/PGrO87OisvJAh/pM7DQdrLq6aeqj3Uukh7jI9Pa+x328szu46rFMQkKBrH7Txx39aNMQwaOqu91i9uxWFRMKOZBBr0uwfAmdlcqf43vEkKGpjI18VDi5oE6BcNz2fskqH5xClLHKRZMW9aIsU7w9l0LcHsSSn7Nj6YtM83O/3wb8Gg67widhxrOgFZrdiCFlDYx++z1Wtp8VJ5pMeSD4RPQs5DT4vnOP78uhAkNPOWJkXZw00HEstbHWlbA2JnO2CGvzlGIwslIVnn220i0kwT0un9eoKnWfq/ayy/WZaIdOqmW/RbLx4JBok7cGi+rVqcsUGAqjT/K+g6mWci7Tf9leqEa/igHuyiJAejYLjsgdrbYKYIqjL5T8qJVrjt2o6up8W4l7cY5zZHPRqdhL5JSkM0WGmABvtXoDT3AQiDY9GXuLJHEm+ow68SODzDqCK1bbyqaUUJNMBVxrIQnWMLLfH3WNhCH4MRAJLW05tRrVa6EnfTy0NPdBvxF40gW0SOT0019jpa4ZsvAxXlHWEagoXeln4nyvCqYz8zEEts7q5M+o73JNyQZGWrvz+6fMOxhMTcghT/ncV9VvKKXYcRd5Zgv0Qus9yPdGrJPeLRgjgon23bzEtXhWfdWjt3RNsTz2elaAiujPYRldGZ1E1uK5HNq+Fr59/i1Y+f463j4RSwYVB1gyhw0vW/NCa6ZPNpC18kYgvp1p3P+It4T4XRrPALlPxC4hTW0wiaMJ4wWzo/EizlxUDAYA0Zl7XY4naXjyL1FIyWHp90Hu7i/9FqbINsqYU/
 rHGvmcNA
 9VciVpUactSO72ncH80oimZbHR3HoDyubGdcx0JzSnl3KiXSzW6W5p/kYdAD0R94qlzH3PhK7UK/wWgFC19UW0iwaged6sEiabu/me5NNMoGRsxYVQl9yZwA9rFjR7emDKciBu2UuenyZqKCum9anY0ypDba2JS/qCT127bGBE5OPqcDSkPJJkKY6K7RVKawNTJLGSXUCKpj8CWEYtQHDxGZlPQVe4WvJcfgTy56JLVP+0xcBDPQOwuYdxAFNB7IiFO3G7ndpaEwndMPnGk7Ls8NobBMldHX+WJBp
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 23, 2026 at 12:04:10PM +0100, David Hildenbrand (Arm) wrote:
> On 2/20/26 20:33, Kalesh Singh wrote:
> > On Fri, Feb 20, 2026 at 8:30 AM David Hildenbrand (Arm)
> > <david@kernel.org> wrote:
> > > 
> > > On 2/20/26 13:07, Kiryl Shutsemau wrote:
> > > > 
> > > > Well, it will drastically limit the adoption. We have too much legacy
> > > > stuff on x86.
> > > 
> > > I'd assume that many applications nowadays can deal with differing page
> > > sizes (thanks to some other architectures paving the way).
> > > 
> > > But yes, some real legacy stuff, or stuff that ever only cared about
> > > intel still hardcodes pagesize=4k.
> > 
> > I think most issues will stem from linkers setting the default ELF
> > segment alignment (max-page-size) for x86 to 4096. So those ELFs will
> > not load correctly or at all on the larger emulated granularity.
> 
> Right, I assume that they will have to be thought about that, and possibly,
> some binaries/libraries recompiled.

I think backward compatibility is important and I believe we can get
there without ABI break. And optimize from there.

BTW, x86-64 SysV ABI allows for 64k page size:

	Systems are permitted to use any power-of-two page size between
	4KB and 64KB, inclusive.

But it doesn't work in practice.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

