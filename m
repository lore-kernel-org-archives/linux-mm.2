Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E090CEA4FB3
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 12:16:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 263D06B0089; Mon, 23 Feb 2026 07:16:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 211CB6B008A; Mon, 23 Feb 2026 07:16:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F3AB6B008C; Mon, 23 Feb 2026 07:16:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F07CB6B0089
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 07:16:15 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9C29BB2DF3
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 12:16:15 +0000 (UTC)
X-FDA: 84475618710.20.AD11D84
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 81F712000F
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 12:16:13 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="AnKNXr/g";
	spf=pass (imf13.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771848973;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=efjFtIPt4Ps4MfEO7d1agn4Edh2fwbMMFBWjRDjmaHc=;
	b=sTia27XgQs/KhIvIXKwwFGqc1rJGdD3o+gmttft13vkhRZdPpflMFn13zwq2tzrcwGWI0b
	6xfd4X06hb1zy6+k2N3hxlb1m0l4dLQr5qHDja9179GZdxUGLlegNcO+78z5M4pOvtXYhl
	g4vxBR+vfMDP4ELk9Ga8U3ImtGfHf9U=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="AnKNXr/g";
	spf=pass (imf13.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771848973; a=rsa-sha256;
	cv=none;
	b=UH5qdE7NZQwJtruQPCTF6Y0/AKcHVmPGReUZ6+Q0NEzLMP/vnCFmjvSXLTGP7TkOlLxKhk
	GiltpxsmEckYd8O7QfmhUC+zfIvPt3GFUWckjq610lzInvfJse98tZR685AkPEhLPaEcwv
	YcOeQUL1Kn5OVAzk3X3aJ7USL5d3CQk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7B15F43585;
	Mon, 23 Feb 2026 12:16:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3CD7C116C6;
	Mon, 23 Feb 2026 12:16:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771848972;
	bh=9iO7p5jg3rewS1pOAtzAVmxybx20UVJaapbeUxgXQSk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AnKNXr/g8SOiAEQ7iFEoVxky9iLTyzle0GbrxihA80NU1Em9Y+1tUN6LemjqRRW5v
	 VWtZ/sQgG7bBiItGF1u1UniBiVwkRBMmpOJBMCGIBQHrS/0WWthZkJ0BEqIc8YGom6
	 g2tyf7qZsjdaX53WpW6T/0i5JiumL6lT//4FJEC5E2acdEZWIdP7116rTd+9+ybexU
	 oDF8FqnEOMvlMgaB2R1gy0rtvQ5HfELwPHLtvCSIB/fp9MDNFmmBwV4M82cLVSeizg
	 ANPVu5Y/ZNp6DkLcd0f4ekgEMBXc6Q80PMDPWGaM6iC1XQQL+XcRziATnaQ7r1Q0aq
	 RZiROc/LZkvlQ==
Received: from phl-compute-12.internal (phl-compute-12.internal [10.202.2.52])
	by mailfauth.phl.internal (Postfix) with ESMTP id A8DA7F40069;
	Mon, 23 Feb 2026 07:16:10 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-12.internal (MEProxy); Mon, 23 Feb 2026 07:16:10 -0500
X-ME-Sender: <xms:CkWcaQicdiyGa9JCDbRfK6uCZlSEhl4Dy_tmu4ybFDjNOrRCQWo16Q>
    <xme:CkWcaVcgnymP7YoU0IdGkdKRbG0YnYkIEJH26WqMB4jBzcVzVUKmMdOvdA3aweoAS
    Vg3le9O80GSt5K6Kcooni7cZR9MhGt_gf1fRtTzgx6k2LVgpvQtxAw>
X-ME-Received: <xmr:CkWcafU54fyMeUZEJqXSzBNlh9vo5lIwxYXf96bPrb_bqVOTMmKQuo0MsdzuiA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvfeejvdduucetufdoteggodetrf
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
X-ME-Proxy: <xmx:CkWcaXznKKez8FFu1hQfMKEN64DuuaN9scrUE9UFbLw8EWHw1g54YQ>
    <xmx:CkWcaeBcly4qs5cqiHPRcd1ca2V_AUYLYCRLW_Qsv2SozqlUr43JMg>
    <xmx:CkWcaV7C4wjVf37QPoaJ-Gs0ZK7wfz3CS5wQOh-Bm0_8LI343EbwLw>
    <xmx:CkWcadkqJPFb1fCJVgmEMxdAlvT9t1j8h4U6RKERPGXcy8l_keOG4w>
    <xmx:CkWcaQe3u3oLGA7uI2fG-H3fCcaWkIniMy7smYbGbKB-JNZy0oZ8QE4w>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 23 Feb 2026 07:16:08 -0500 (EST)
Date: Mon, 23 Feb 2026 12:16:03 +0000
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
Message-ID: <aZxEKdXTXoI0BZYJ@thinkstation>
References: <aZcmlIF4bmG0twkp@thinkstation>
 <915aafb3-d1ff-4ae9-8751-f78e333a1f5f@kernel.org>
 <aZdCl8byz51Q1-v6@thinkstation>
 <17c5708d-3859-49a5-814e-bc3564bc3ac6@kernel.org>
 <aZhErt9DZcWI24_v@thinkstation>
 <d7c7ef63-e40c-40c5-8ce5-a4ca411da832@kernel.org>
 <CAC_TJvd=wKKnj=d3phZsAaarXUdUbZDGauxWNWkQtsFV-MTYEg@mail.gmail.com>
 <32ed82dd-62c3-4a5c-8bae-9465afd7e75f@kernel.org>
 <aZw1DlKHaWvgOtm_@thinkstation>
 <06684dc4-3902-4452-824a-ee2064314d24@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <06684dc4-3902-4452-824a-ee2064314d24@kernel.org>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 81F712000F
X-Stat-Signature: xmfdfj9yqetear1ewe9g57dn7j1yztd8
X-Rspam-User: 
X-HE-Tag: 1771848973-285977
X-HE-Meta: U2FsdGVkX19PzD8mXPnHWRCJajlxAxXqLdl2Tr9RnyiaQVYW9Is+Gu2kQHsL3sLqffDTYCcC6FMpamo0EQp9C5qZmcLWqQ6WhVBkhUN2DY0IFyesfwKfET1Gh3BFfUGTn3IK2UuHAyyk12ateZPfWv4MKKgOdyEoAuazraWfc+WAw2zJttPLV8HQRPkZA3JOTCl93FtYlrRxglhe4Q1Dpcb+My8wXyJ6sqfuVwo5KvaOLVKPaqUwdW9494tAVFHBFxTdb754rkX0OZfk4iA3kxWQ9WXzwtTK0Dzw94Oapg2cq64B3WUsDAQOyJTMMlTqFeQrREIupqtmPJ8VjD47jma0cSxC4/nXRCluWDn5RQ/K4BRx65qKT0jEpWvfpznDc8mUaOAP5qdAGA96XvyTVHRHKPJTmQevrBtfk8c9eXXTzpTS5cJo4ADQWT3tcWlkKR8ki5WSKrdLnf6zI1ktvtsECfsO+VAfR/4r6A/xE8lm7+KSkGQdI55K1KJxMsT7iwtRBTJGMwnAUcPP91zyY7tVck2AA13Kb3C/QrMiOuXcHkwxdN9OVqVqSusXQ9EF/5CWr9NvIuotL2FMosoYBpKccWSujlt3MVWd6F2WxafhXVNdApNEQJbDJxBGQQHGdhXYA75zCQEc+1B2SIf6URDhKUgYyhNYW4B5P9ArNHh36wlVslzbRCF6t1Rk9x6Isiy09KNKWLBYndAX9yT/hWfGdPb+ZCzV+W6lEavJq+2n6SZ3h3B74tMpeUeajw27MPR7zqAXbq5/2bArxtX+3Z3atvMfW3d8Uj/wifArHVVqdtCJQZu+n9VAzWzLh5hM1ib8RrGlK4nW8Eu0Nz/H+tCTaD3HkIomvI6vNiiB0x4n2QJclFS7kdjXQ85XTxxPOYUPNj2A+ocrt3ekiagZB/tQk2hIQYgq4/+7SKHhLFwZ+W433yf6GJmV8fyrNDwMcX7daIcOzusYp9k6sHO
 bURS0WMu
 3xlYflKUupZr9SBgJYeYSjyoev2KFkOlwNKxT4bIFLilpMGnOum0VZy1ntavm4gF/FOcFztuksZ32TAtAeVRa63ScvsUUx7bzdUsZnYEwTLESp+RW/DFapsMswNaenUBVNyBLWO0iC0mAKgwEutaAEstYUUe2F0qbY4bjjc5jrt4DyLbegFmjRbeKTJLIPC+EiCxVDm2AswrePlxr3rF/yn4l8XJP7mWrj2Hu3Vv7ld6pl53Axqkr3i+WdEPMRQbuCYkkZBenxakOdTx/DVmrCSbjt5HmQYr4LZd7
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 23, 2026 at 12:27:33PM +0100, David Hildenbrand (Arm) wrote:
> On 2/23/26 12:13, Kiryl Shutsemau wrote:
> > On Mon, Feb 23, 2026 at 12:04:10PM +0100, David Hildenbrand (Arm) wrote:
> > > On 2/20/26 20:33, Kalesh Singh wrote:
> > > > On Fri, Feb 20, 2026 at 8:30 AM David Hildenbrand (Arm)
> > > > <david@kernel.org> wrote:
> > > > 
> > > > I think most issues will stem from linkers setting the default ELF
> > > > segment alignment (max-page-size) for x86 to 4096. So those ELFs will
> > > > not load correctly or at all on the larger emulated granularity.
> > > 
> > > Right, I assume that they will have to be thought about that, and possibly,
> > > some binaries/libraries recompiled.
> > 
> > I think backward compatibility is important and I believe we can get
> > there without ABI break. And optimize from there.
> > 
> > BTW, x86-64 SysV ABI allows for 64k page size:
> > 
> > 	Systems are permitted to use any power-of-two page size between
> > 	4KB and 64KB, inclusive.
> > 
> > But it doesn't work in practice.
> 
> Even in well controlled environments you would run in a hyperscaler?

I have not invested much time into investigating this.

I intentionally targeted compatible version assuming it will be better
received by upstream. I want it to be usable outside specially cured
userspace. 64k might not be good fit for a desktop, but 16k can be a
different story.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

