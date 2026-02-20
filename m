Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CCD15C5AC7A
	for <linux-mm@archiver.kernel.org>; Fri, 20 Feb 2026 15:50:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA9886B0005; Fri, 20 Feb 2026 10:50:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A818F6B0089; Fri, 20 Feb 2026 10:50:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98CE46B008A; Fri, 20 Feb 2026 10:50:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7FD4B6B0005
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 10:50:17 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F0F851A01FF
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 15:50:16 +0000 (UTC)
X-FDA: 84465271632.14.DF3F10F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 0C769100011
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 15:50:14 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tloJ8Ohu;
	spf=pass (imf05.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771602615;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dR5JQPkn7LP+EIWzGcXMjpKbXh2HwKeqKGjBITf6paQ=;
	b=KcjGaB45GIC/RnYrCvg/oCF9wokVG3iPxtV3gyNVrn9Wn3+oho2/PoijJ3sd6FrEUAeVIV
	vLws9YS/K2Ildcyv8XJDUU1+/qgZHsG4u2/EafLAdZr1SdSMdPmKIsJaw8XC+JXVAYye+C
	I67gt70KLruu7sFisKxTG1z3+FJ/WaU=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tloJ8Ohu;
	spf=pass (imf05.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771602615; a=rsa-sha256;
	cv=none;
	b=fQ+Am7W81G27LEbCCHbnkeCiqCOU/910QjPYYyJOde8OlRZP/LymuwTC7QjlCPp+a8SuLe
	G4Hzvh5HZO7XdKI7T79S/LjcYfED6mNbCzqEeYpyquZVmyfUQEszlgg/VnWi3amoA6SYHY
	M6YbYtDOI07L2GF/eIsToOCHkeBuNHc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0E1804455E;
	Fri, 20 Feb 2026 15:50:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6451EC2BC9E;
	Fri, 20 Feb 2026 15:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771602613;
	bh=7gaP1GdZI+M5LlRMzEn27CMVU3D0Uf3Bl1Suhpy/K90=;
	h=Date:From:To:Subject:References:In-Reply-To:From;
	b=tloJ8Ohu+xd4bAMtoqr3DTb8/2NB0md5p7Amg3ftE7ddTZyEPRxOY7S2KuYP0WgsI
	 y4j9PC8pllX9Ki9xbM8QIV6d0D+EVb7nvqU8T/i5lgy69r6QsbmvrxoYqNQ+jeCFfs
	 Rcawl8pRH4NcxFfN4HuvnaJX4pvvW620m4ORtFODKN3a3qj+YQ5n9e7wPkHQ2rvQso
	 goTNiugfcHOcMCgWmU4AteGLMiNF/u7u3MksLTGlHA3+L20ADPRKCf7ExxDeBgCTCg
	 WDro6bpfN2g81C/IN09THxuQaVry8/GwmdAmMEA9VDBZ3AuL3BkPmJ1aYGVsfz3gLA
	 5XQGuHefb+hkw==
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfauth.phl.internal (Postfix) with ESMTP id 6FA0BF40068;
	Fri, 20 Feb 2026 10:50:12 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Fri, 20 Feb 2026 10:50:12 -0500
X-ME-Sender: <xms:tIKYacuuRFrf2LgEo-Wtx6mFFj1RVnfeUc4W3_Tst8VL3N1lBJ6zBQ>
    <xme:tIKYaV5P_DQBCn9gnrzbWbxmlc0mBz6cJNU2iHgXQ31eZOUIZmwg3Gyn8oEoRs5h2
    2YlqDeJvyRFVnk1zoUncN2W2Xe5HiQXXCfhiApIDmxrRi1KCnhAavU>
X-ME-Received: <xmr:tIKYafCJQvhc72JbLRXCQuxi4P8Qhg1_Se4yhRxyZjk2AuJ_pMQri-DXCVYdyA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvvdekkeegucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefmihhrhihlucfu
    hhhuthhsvghmrghuuceokhgrsheskhgvrhhnvghlrdhorhhgqeenucggtffrrghtthgvrh
    hnpeejgedvhfeifefgleeuteekfeehfffgleegvdfgffehfeekgedtuefggfffjefgkeen
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehkihhrih
    hllhdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqudeiudduiedvieehhedq
    vdekgeeggeejvdekqdhkrghspeepkhgvrhhnvghlrdhorhhgsehshhhuthgvmhhovhdrnh
    grmhgvpdhnsggprhgtphhtthhopeefgedpmhhouggvpehsmhhtphhouhhtpdhrtghpthht
    oheplhhirghmrdhhohiflhgvthhtsehorhgrtghlvgdrtghomhdprhgtphhtthhopegurg
    hvvgdrhhgrnhhsvghnsehinhhtvghlrdgtohhmpdhrtghpthhtoheplhhsfhdqphgtsehl
    ihhsthhsrdhlihhnuhigqdhfohhunhgurghtihhonhdrohhrghdprhgtphhtthhopehlih
    hnuhigqdhmmheskhhvrggtkhdrohhrghdprhgtphhtthhopeigkeeisehkvghrnhgvlhdr
    ohhrghdprhgtphhtthhopehlihhnuhigqdhkvghrnhgvlhesvhhgvghrrdhkvghrnhgvlh
    drohhrghdprhgtphhtthhopegrkhhpmheslhhinhhugidqfhhouhhnuggrthhiohhnrdho
    rhhgpdhrtghpthhtohepuggrvhhiugeskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepth
    hglhigsehlihhnuhhtrhhonhhigidruggv
X-ME-Proxy: <xmx:tIKYaVt314IGxzEzIfJrKexXFcqVv-o_sBCiBW8qf_c4Wuyc2Kjm7w>
    <xmx:tIKYadP4wJB5n4wR_sBKojbV0JI5OkwIm36c5iYVfzLIislv5afAjQ>
    <xmx:tIKYadV6u7SDKi0-bM7KSzZ6xr0dzfxKbq5gwPw-41Z7QB-EQievZA>
    <xmx:tIKYaYSfbCv_VmK2DcHcothGed69QnaQGJzYDUL_OzDhFv0PjRkfpQ>
    <xmx:tIKYadYFCzwxTq7hMpf1ZnMqRWWartT6yNt6v3mR8t6vUiLICRz8j-V->
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 20 Feb 2026 10:50:10 -0500 (EST)
Date: Fri, 20 Feb 2026 15:50:03 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Dave Hansen <dave.hansen@intel.com>, lsf-pc@lists.linux-foundation.org, linux-mm@kvack.org, 
	x86@kernel.org, linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Mike Rapoport <rppt@kernel.org>, Matthew Wilcox <willy@infradead.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Usama Arif <usama.arif@linux.dev>
Subject: Re: [LSF/MM/BPF TOPIC] 64k (or 16k) base page size on x86
Message-ID: <aZiBgbAoe1FQ5nO-@thinkstation>
References: <aZcmlIF4bmG0twkp@thinkstation>
 <46817fe5-7166-4734-bad3-3109cc7feb1e@intel.com>
 <aZeFeAP9Zh-9q7pH@thinkstation>
 <vq6hv7gyieakkka33po6nveq52vayruxsdbymcjxja6vtxlldp@th5gwdlfhrwa>
 <aZhRKOK9I_MLEeHT@thinkstation>
 <bsvfkhvxwjyyvvd6stn7ucevk4mhbmlsdjof2f2vg6gcnhhwqp@iitazb6w2uky>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bsvfkhvxwjyyvvd6stn7ucevk4mhbmlsdjof2f2vg6gcnhhwqp@iitazb6w2uky>
X-Rspamd-Server: rspam05
X-Rspam-User: 
X-Rspamd-Queue-Id: 0C769100011
X-Stat-Signature: gswigajzabqor3ydbgjmpcdtw74d3rb5
X-HE-Tag: 1771602614-31246
X-HE-Meta: U2FsdGVkX1/tXDbAre7fRdGqDv79DtMuObi5FS5VTvsS2gitos/G7GsWyds7IRKsTUni3HL6xluNPYqU3GpfPMS68jNm0MtK4e2yYqzUL4N6slAJZJxp4G3b0pBjxJEQTKHLECdnvvW2jWaUq0dtPvpDvzX1QDTbuhoYA+vpgwmaLz+GssPNVL2tHw2kQfcMyPujI2tZ6xIjR7C41LRkZThr351hSvOtfAhr63tasGj7ObxE8XkOQq7m+1UVTQLG3NQLj7OhZ5PJBSqeaS5bqDHdkihdF9qw6GMg2TKe5NiWIWNhAgdIom8b6aWcitgDpJr8VvMWNu8sw67CeF8W92BtR7LzjjUJ6bEOAhhAsR7gW5SEkqB0GslVOtnWsAE16pvgcc5BgrWwayNFUagUCYdlN6pQEAb+SRIyIXzjXiNdEObnFgrJ3oa4xdbdI4upRW8yl/00WOZVNmwgbRm67h2s+WVqVLZNxngXqOZTsiQr8rkKZAoS8KHWyA6+z8T9JZN1apS7d4rd6X0UrTlxnJiq1wlxNScr/dEhB21XdmSRX7Jy2FRed0ffxHkaTIXNlhRKd9yIH1Mu4bGvIJn07z0Wxt8m0F/cj50cGP3POsohLETA7kb2ndXvWgSnT6Ql0RcWHia75LbRHQ7ozl5PhcQDkl4LIsXPt97FMUt+emqIVFdwdNDamcDaPu/uaCCR4ieMs7SFPwNSHdK+QVZHWw7XUh6GzOejk/AFUnJ/v50bVA40SnAW2MHPGr53qNflm7M95J8NGXnLyHLHVykg+O/jzgtm1cy4eKXUARX5ZkTfcbAa4B/E0G8/UHml5jRCWvWTDMCBXY0kRPMzD1XBr+x5FamdQlWUN86ykDUyDFM8y+4dyQNs2XgVEoJwxKW1d4CfC83XKNoX0KE45OCESflRJMJ9pXejaB0eligTsUoXuBgmNyIokQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 20, 2026 at 10:17:45AM -0500, Liam R. Howlett wrote:
> * Kiryl Shutsemau <kas@kernel.org> [260220 07:33]:
> > On Thu, Feb 19, 2026 at 10:28:20PM -0500, Liam R. Howlett wrote:
> > > * Kiryl Shutsemau <kas@kernel.org> [260219 17:05]:
> > > > On Thu, Feb 19, 2026 at 09:08:57AM -0800, Dave Hansen wrote:
> > > > > On 2/19/26 07:08, Kiryl Shutsemau wrote:
> > > > > >   - The order-0 page size cuts struct page overhead by a factor of 16. From
> > > > > >     ~1.6% of RAM to ~0.1%;
> > > > > ...
> > > > > But, it will mostly be getting better performance at the _cost_ of
> > > > > consuming more RAM, not saving RAM.
> > > > 
> > > > That's fair.
> > > > 
> > > > The problem with struct page memory consumption is that it is static and
> > > > cannot be reclaimed. You pay the struct page tax no matter what.
> > > > 
> > > > Page cache rounding overhead can be large, but a motivated userspace can
> > > > keep it under control by avoiding splitting a dataset into many small
> > > > files. And this memory is reclaimable.
> > > > 
> > > 
> > > But we are in reclaim a lot more these days.  As I'm sure you are aware,
> > > we are trying to maximize the resources (both cpu and ram) of any
> > > machine powered on.  Entering reclaim will consume the cpu time and will
> > > affect other tasks.
> > > 
> > > Especially with multiple workload machines, the tendency is to have a
> > > primary focus with the lower desired work being killed, if necessary.
> > > Reducing the overhead just means more secondary tasks, or a bigger
> > > footprint of the ones already executing.
> > > 
> > > Increasing the memory pressure will degrade the primary workload more
> > > frequently, even if we recover enough to avoid OOMing the secondary.
> > > 
> > > While in the struct page tax world, the secondary task would be killed
> > > after a shorter (and less frequently executed) reclaim comes up short.
> > > So, I would think that we would be degrading the primary workload in an
> > > attempt to keep the secondary alive?  Maybe I'm over-simplifying here?
> > 
> > I am not sure I fully follow your point.
> > 
> > Sizing tasks and scheduling tasks between machines is hard in general.
> > I don't think the balance between struct page tax and page cache
> > rounding overhead is going to be the primary factor.
> 
> I think there are more trade offs than what you listed.  It's still
> probably worth doing, but I wanted to know if you though that this would
> cause us to spend more time in reclaim, which seems to be implied above.
> So, another trade-off might be all the reclaim penalty being paid more
> frequently?

I am not sure.

Kernel would need to do less work in reclaim per unit of memory.
Depending on workloads you might see less allocation events and
therefore less frequent reclaim.

It's all too hand-wavy at the stage.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

