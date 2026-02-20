Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B225C55ABC
	for <linux-mm@archiver.kernel.org>; Fri, 20 Feb 2026 12:33:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C9756B0088; Fri, 20 Feb 2026 07:33:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 89DDD6B0089; Fri, 20 Feb 2026 07:33:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7CA926B008A; Fri, 20 Feb 2026 07:33:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 66F996B0088
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 07:33:15 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 08CE9140164
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 12:33:15 +0000 (UTC)
X-FDA: 84464775150.12.B62F793
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id E4E0F40006
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 12:33:12 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VOOjLrWN;
	spf=pass (imf11.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771590793; a=rsa-sha256;
	cv=none;
	b=Sc5FfnY6QD8W6Gha80UYU4FFhAi6ACMf0+uKJba1V34tctROl7rItagtyIS5iIOPPohqwN
	rKexXcGpaNVPOscpC7H4PFfjjnv0yEovXwP5eIk2TQNckItZ6zAJ/P48kwL9hpEGSb7gSt
	ZR8eQgNgfHcqMBUNjp+YWH1sPwW+Jck=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VOOjLrWN;
	spf=pass (imf11.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771590793;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eAbKwgluZ6x29sQ7DMnPYdNLqhQZwViZnBi+Q923Sys=;
	b=stygwGWjA91XRpYZLYeMbJSkp0k0IcPhKaL/CQrIlr25Yaux1CHNHZYEwlEJuZ37+3F0Qh
	5lOk2ucqnEwdye5RNJZUB1exE51sI5lYWy2x3N21gcDPkltEnJwQqE/choOFyH/uwWnLgh
	9mVX8fWSZN6wejmc5WAVv8CrqrAoxOM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C103743FDA;
	Fri, 20 Feb 2026 12:33:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CFF1C4AF0B;
	Fri, 20 Feb 2026 12:33:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771590791;
	bh=HEav6OKo9Ka2eLWNoeqr+fC5xj+AerMf/qZFR5ZgdYw=;
	h=Date:From:To:Subject:References:In-Reply-To:From;
	b=VOOjLrWNvuLJ/gLuKzddCn1meEfv0f1LM/VWGLNgpdpvUZpc7/DBcH4tO33ee6GAf
	 8gOrynd24/1JtlWepOTFTCA/4J3E7Mh3Bisy072/WDcBw5sR9ML13CDJgYr8/Eg6+r
	 I9wTZYmjIP0P6VNO4jDa0AcO8AXAI98hjNgX357a1U6VFSdNuWJt73UiOkt49A9Ip4
	 eVsevTdZTXdGuW5RL0F+mp4bBAKGoqxzufeTeYess2suL/1XVhfsskb8pDKcyK+VF1
	 wkGIucWNB2j68PoP9TB8fEDQ8uQ1qgdvdc0oal7Grmq+NDvBgx/Ykb0NGYfJbBnqmf
	 wKh6JjuZ2arxA==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 558B3F4006A;
	Fri, 20 Feb 2026 07:33:09 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Fri, 20 Feb 2026 07:33:09 -0500
X-ME-Sender: <xms:hVSYaYnHDKZ18bE5ij_zDhuWpb4IcZ05XcGC8o_u4_t1Lw7Jx5qepQ>
    <xme:hVSYaT9W4PmWfabA3lbSuPi0IFFyTQaBBZP7tUuaLjSHqXl1sUjr3FTmKe2Q_Bvs5
    ApVtyWzFf1B_uquykX87-ySe_vdl0ktymWa2EdmqejP4ONZDqOiW-bx>
X-ME-Received: <xmr:hVSYaf5uatMTQ6JS714Cg2aEzLZA-hSKCm6tc1iWJspYlJHttRTH-Rsl5mpBGw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvvdekgeehucetufdoteggodetrf
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
X-ME-Proxy: <xmx:hVSYaTrbFI6EXEHSLPa5UtqW6xf5Ab3JgyCnWNx4-h4inpFylTwHNw>
    <xmx:hVSYabBqz_dugEs3Jssql6n2r9hfd-io68v2gS59uuGaPK78OanqOQ>
    <xmx:hVSYacOBTKwL4yJVNCXEqNLmowvCe2ODgg8BE7i5ETZdLLwnMAeybA>
    <xmx:hVSYaan0tnSXqXu1m4C1HA3YrvAvEz5WpBD9m3Lg-fOe1heVkLkeCw>
    <xmx:hVSYaedNHmj_lgFe5sVvxL5Vb1iECVrJXnRUC0wqkwgqx9XwQIlvMHqV>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 20 Feb 2026 07:33:08 -0500 (EST)
Date: Fri, 20 Feb 2026 12:33:06 +0000
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
Message-ID: <aZhRKOK9I_MLEeHT@thinkstation>
References: <aZcmlIF4bmG0twkp@thinkstation>
 <46817fe5-7166-4734-bad3-3109cc7feb1e@intel.com>
 <aZeFeAP9Zh-9q7pH@thinkstation>
 <vq6hv7gyieakkka33po6nveq52vayruxsdbymcjxja6vtxlldp@th5gwdlfhrwa>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <vq6hv7gyieakkka33po6nveq52vayruxsdbymcjxja6vtxlldp@th5gwdlfhrwa>
X-Rspamd-Queue-Id: E4E0F40006
X-Stat-Signature: pd8f8eusnxzs5ddp9zy1p4r3cpsphq8h
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1771590792-386988
X-HE-Meta: U2FsdGVkX1/TsSKqQgTagQTeVyUUXX5+2FcXgUQghquie5ps2PB33BScpQmwrskHhZzPJPdxvtB3eRoT8PhZkzNkeCigzMJxIVfEKQ2SxKe6OrIquKTJtwgVtRC5bUOgRE72wbPGfuYBcTUw/pfoGThGb0/FxqI7BzLDz1tJNcjdpE5nspeZx7u1BX1v/RWv+yjEsx7CdDux9Xa/mA494mrTGaPSDFWS1IDWfaZTFnbkCBv5egIZcbBo/pqB5Rd9yG1x/mZgwqqUMhyyqUjQZiuppH0wQyUpypjh1uaUzni2KKEG2goVAr7TaoNF9BaQhslXW90uSCmwOEyIzjO8Xg9pPLX4aVPn3n3uoRjQkKlqfue7t4jM0HQk53fGDxLtMG0j9kPkkOa5ohGMJmvdEVlRIIhkG+ArB/Mo23o95SDTVTjvhMTT38mRSoMgKiOUsHcCdl1LgBK877CkT85vWFMw+Ivkp+fhJCZS+3bdsmWX5UQIQ8KipvtfBg3QZQnkfmdrCogsO7rS3S4xlNbOlGURtWMLo2zjxHHd6Jb+GK4xAalZFfIr7YcPWpR663pGFpse0tI06MTBcbtcrHuVT582OMedwNiyeTi5VLgTpihPn4yvTyd7ZIfICNXX4k0aEg8fI9k2D8ixDrViImN9BqBfGMXPtktucrnSwrcnD6rqpuWlVRfVXC3+gDqTFtHU9S8n0uQOxDsugdHM+U/ZK6UJJVoc1AXkVr9mi8JnHfhvdZLRK0f5yUOAvZMK/2tlw+uTua425Cq2OpFdvkvRP2YRR83xfJhcxapJmj6pUh5BG038v82Svo+Yrk3BXkOJ28A0h6ff1j6v985Rc5wtTbrxh7T1y3DMEKA9IHif2ABlZUEmn3bxmSEjG64ZkBnYA9m19nqj3riESUzPejtjHHoRaCjEwmDRlQcwpH7ohmmirXmuwc7GF7P3Tkb4nCSUPep4mCc4Z2axYU1CV2W
 4Q2WysBp
 a6dwHIJbk6uSzIBOkVU0i05RVgBHqoc4kf0r8GodZGGYIpS0Aux4nYSTW0tttqkLuu8jiTFjN5zezR1jrpLfzUsoy7hCxYL+jjjgWPBGnOET8zl4MzYb7gwD/iNCf4nPRpCcYGxssKxusmvwuL/Iu+TCg1sXMlX9nKaS/5OBdGd99oNkDRfrnPUpmGtyx+dbL1XN5S7gJjOy8Ax93bz+HK0GoPNYgnCCHygPI0M8qodUZGyMVe1TgK1q1CWr0rNQ7CbT82BceBUuG0iOlT+8BL9+Za8Yu3ZZIAfV0lxt7Y6a19nw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 19, 2026 at 10:28:20PM -0500, Liam R. Howlett wrote:
> * Kiryl Shutsemau <kas@kernel.org> [260219 17:05]:
> > On Thu, Feb 19, 2026 at 09:08:57AM -0800, Dave Hansen wrote:
> > > On 2/19/26 07:08, Kiryl Shutsemau wrote:
> > > >   - The order-0 page size cuts struct page overhead by a factor of 16. From
> > > >     ~1.6% of RAM to ~0.1%;
> > > ...
> > > But, it will mostly be getting better performance at the _cost_ of
> > > consuming more RAM, not saving RAM.
> > 
> > That's fair.
> > 
> > The problem with struct page memory consumption is that it is static and
> > cannot be reclaimed. You pay the struct page tax no matter what.
> > 
> > Page cache rounding overhead can be large, but a motivated userspace can
> > keep it under control by avoiding splitting a dataset into many small
> > files. And this memory is reclaimable.
> > 
> 
> But we are in reclaim a lot more these days.  As I'm sure you are aware,
> we are trying to maximize the resources (both cpu and ram) of any
> machine powered on.  Entering reclaim will consume the cpu time and will
> affect other tasks.
> 
> Especially with multiple workload machines, the tendency is to have a
> primary focus with the lower desired work being killed, if necessary.
> Reducing the overhead just means more secondary tasks, or a bigger
> footprint of the ones already executing.
> 
> Increasing the memory pressure will degrade the primary workload more
> frequently, even if we recover enough to avoid OOMing the secondary.
> 
> While in the struct page tax world, the secondary task would be killed
> after a shorter (and less frequently executed) reclaim comes up short.
> So, I would think that we would be degrading the primary workload in an
> attempt to keep the secondary alive?  Maybe I'm over-simplifying here?

I am not sure I fully follow your point.

Sizing tasks and scheduling tasks between machines is hard in general.
I don't think the balance between struct page tax and page cache
rounding overhead is going to be the primary factor.

> Near the other end of the spectrum, we have chromebooks that are
> constantly in reclaim, even with 4k pages.  I guess these machines would
> be destine to maintain the same page size they use today.  That is, this
> solution for the struct page tax is only useful if you have a lot of
> memory.  But then again, that's where the bookkeeping costs become hard
> to take.

Smaller machines are not target for 64k pages. They will not benefit
from them.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

