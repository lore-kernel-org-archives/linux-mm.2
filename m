Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D8ACCCD1BC
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 12:42:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B23708E0018; Thu, 23 Oct 2025 08:42:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFB218E0002; Thu, 23 Oct 2025 08:42:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E9CC8E0018; Thu, 23 Oct 2025 08:42:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8E1D48E0002
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 08:42:01 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BE38057266
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 12:42:00 +0000 (UTC)
X-FDA: 84029341200.05.4AA505D
Received: from fhigh-b3-smtp.messagingengine.com (fhigh-b3-smtp.messagingengine.com [202.12.124.154])
	by imf22.hostedemail.com (Postfix) with ESMTP id 7C172C0011
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 12:41:58 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="F 75UTxy";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=tWM7k9du;
	spf=pass (imf22.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.154 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761223318;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K/3rmEGyyRqr/NQraJuCGAEXsJxihtT7HX1YfEvOM5I=;
	b=PVxPAr7oiKZbsthyDPXrbGJQTNuTbi5A8EdUJV9Oavc9RObCjHAWG7uIyIBLh47V8WCLAv
	yQe49Th9IvKi18EcA/22HcjSZsHVF6dlG6mMTRt/pLuA4E0WCWPcjohrQ28fRce9C6eGZs
	FlH6718i5AoPBSROv4d9C1BUELAA9EI=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="F 75UTxy";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=tWM7k9du;
	spf=pass (imf22.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.154 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761223318; a=rsa-sha256;
	cv=none;
	b=6WqrbbuI+VIzA66zTvLlYGZw7sAcqcUTCF5L5+SZAWS9OJ8M0+EcReKaJQ4c3XNr0y6y75
	ebiy0hmW9G34LHKC/6aVtsJblBm6QUxR6+Tr+VnDPcBhfqVBEgeNS6wqXsGIY1rkRFoRDZ
	H6lMjFhZn1RKTitSOeJGF2mbKueGhy4=
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 2C5527A0090;
	Thu, 23 Oct 2025 08:41:57 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Thu, 23 Oct 2025 08:41:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1761223317; x=
	1761309717; bh=K/3rmEGyyRqr/NQraJuCGAEXsJxihtT7HX1YfEvOM5I=; b=F
	75UTxyQjugFyfRZT2hGVKPmuB5pPR7BBVy8wlqG/BEEFoCLdIXdZMNglK3V52Fzc
	W/8E3rIrnfofl6F2O9HgkA2EWd2kmdSxXU3VfCrCKVy2xsxNGLrW32Svm0Na+W65
	G60ZAeZuA35QoyNA9AYonv11FZjuf6VBqbhlGor+2i//JrhfsXPMf3NW8Kxd8UYb
	paa7jML0qbG8cXO3ZZ0ZjvrjxnabEUZqI0jtjmEPOUQBiMPcjOMHc/qasg3lK8vo
	Kh1AltaXMOp0muk63ogjv3eyr3rKNJhc1rEUfEfSihVKLbcmv8bYr8s+RLequXZA
	JzQU4kNTScM4FbaPOl7eA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1761223317; x=1761309717; bh=K/3rmEGyyRqr/NQraJuCGAEXsJxihtT7HX1
	YfEvOM5I=; b=tWM7k9duNmDhsdin0A7s2vEwX0yVlBuKpsB6Ywg8Tz1JQsRlyUU
	abJZKR1JcyVYI3KAVz4gaTVV3gv3gEQhf/E9pnMvwOB1jx5QXk2klJ/ZTj6zMXqI
	Y+mV83CjndCCJIdOHJp62h6cKAvWnSi3RKaAahI3UJy8RadqYPvUIpuuKzMXS9Ey
	TVXQ7Ucjl0NbuiWq0KVUHpbSi3PlhyVC2lZLodkH/BBO3L9dtkpWzsnwGfcmCgol
	rJxr2HLTxLXEk8ZZTSsu95QA+vBErjOazZntRyKSWNXIXOPtNgB6Kd9xB6AlqYvP
	T8tPw7ucYDKmpMW1pA0UsEUOkmoclznr8EA==
X-ME-Sender: <xms:kyL6aFo9VJ3L8H15FHR3zvxubpEYSCA839ekhEUzk1O0WcE9q-ND5w>
    <xme:kyL6aI-sxuS8lOgohAnI1_ZwaUQ_wLpXWj-zkUCmqNAWwUuZEJqlBtERpL2L9CmVG
    o9zaJ-irDnRLWKjH-r88SRdDGuLGkU7WvsC5HT71NLCSe2gGDtmpIQ>
X-ME-Received: <xmr:kyL6aG33opj1embYhw12A-wRW1Q8a8-rVmk9yUWiWSEC6R64BQfkfMAbLmcSpQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddugeeigeekucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtsfdttddtvdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkihhrihhllhesshhhuhhtvghmohhvrdhnrghmvgeqnecugg
    ftrfgrthhtvghrnhepjeehueefuddvgfejkeeivdejvdegjefgfeeiteevfffhtddvtdel
    udfhfeefffdunecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrh
    homhepkhhirhhilhhlsehshhhuthgvmhhovhdrnhgrmhgvpdhnsggprhgtphhtthhopedv
    tddpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohepuggrvhhiugesrhgvughhrghtrd
    gtohhmpdhrtghpthhtoheprghkphhmsehlihhnuhigqdhfohhunhgurghtihhonhdrohhr
    ghdprhgtphhtthhopeifihhllhihsehinhhfrhgruggvrggurdhorhhgpdhrtghpthhtoh
    epthhorhhvrghlughssehlihhnuhigqdhfohhunhgurghtihhonhdrohhrghdprhgtphht
    thhopehvihhrohesiigvnhhivhdrlhhinhhugidrohhrghdruhhkpdhrtghpthhtohepsg
    hrrghunhgvrheskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepjhgrtghksehsuhhsvgdr
    tgiipdhrtghpthhtoheplhhinhhugidqmhhmsehkvhgrtghkrdhorhhgpdhrtghpthhtoh
    eplhhinhhugidqfhhsuggvvhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:kyL6aDnv5rDE6fqSI4ovDVI5fsUrPHmeyrw0au1dBlkwN7KmBrpoWQ>
    <xmx:kyL6aL2u8gn_8pipvVyNqlBtWd3xsNsexDdYnpoMnlzpUGQDyY8OlA>
    <xmx:kyL6aKj7-lw9T3ixPWJhOYQmB86SVcbjmqNQX8yx_Oa4UaoFF-xeew>
    <xmx:kyL6aBValJgxaySt0vPOsNs4Vcbo3MPFDKNi2UhsAPyYg87ioUBpeQ>
    <xmx:lSL6aCtNetd8m1RLcACeFDrEZgLoNJrcAME93tL-XIVEc_7NReQHkMKO>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 23 Oct 2025 08:41:55 -0400 (EDT)
Date: Thu, 23 Oct 2025 13:41:52 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: David Hildenbrand <david@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Matthew Wilcox <willy@infradead.org>, Linus Torvalds <torvalds@linux-foundation.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/filemap: Implement fast short reads
Message-ID: <fqexozfjp3l6vj643lecky4nndmwblvee7u5f5ejcqkpsij3wp@3yb4y4lyd3dn>
References: <20251017141536.577466-1-kirill@shutemov.name>
 <dcdfb58c-5ba7-4015-9446-09d98449f022@redhat.com>
 <hb54gc3iezwzpe2j6ssgqtwcnba4pnnffzlh3eb46preujhnoa@272dqbjakaiy>
 <06333766-fb79-4deb-9b53-5d1230b9d88d@redhat.com>
 <56d9f1d9-fc20-4be8-b64a-07beac3c64d0@redhat.com>
 <5b33b587-ffd1-4a25-95e5-5f803a935a57@redhat.com>
 <7fmiqrcyiccff5okrs7sdz3i63mp376f2r76e4r5c2miluwk76@567sm46qop5h>
 <f57d73e3-fb6c-4c01-9897-c9686889fec2@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f57d73e3-fb6c-4c01-9897-c9686889fec2@redhat.com>
X-Stat-Signature: bxgdm5e6st1otnn5t8qumidfuukejgxa
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 7C172C0011
X-HE-Tag: 1761223318-124671
X-HE-Meta: U2FsdGVkX195/NI8ECz7D7DYF4uILCgzLrbaSefnW4HeCPg6eW4BIfPopfHSu1LCfKn3VXMFxzB9JzKPZRd+VW2aQF30rPCCspb/wOlAKEQRdw13C5F7JfyDWr/1s+kevnHydjESIZpXBoDmIQOAbnAxAzNjK+fvU5JMtojKpQdosM9fictG3IaMgqy8DY418188DB+QQJFpqxph5gLJnBR+M5VsuXUVMuQx7xinLp6FjY8Y+YT+mW+vRsm08ghpOdtMWTP8TxihHQC92ED2fLvkG5hF/DkGNq+0tjUi16CeyR6+kl9ILY+6aP5YzvO1X2bLq5OKc195MqeCUupgIZbW17ssmFUuTjZhcq87VdJR0eWnC6i9S1Lgemk4CJxqcJSRCK1yMVwWpoF7tgBx/i6vZDHmXzMhx4EWl1QlJWUE2zvJtte41GMczOz6DKM6EYQh1haiEBz675tK05V5m3qFe1L+OL0jdzxHG3s0skuV8juGZVkOUdp2MQ1S1WOY6trywSJ4qB4ztGIsSYan/dAA4wULzwLTk2LnSuDZp2IJ604+DiURGThvzM9rLRFYd3abWZdSiBG14I8xsTIYtoe2cNPp4yfRKtSJ7ZDJKSqBLS1pz2Qqa6r+xlHYQE5VHwGRhwa/g9mUNw/2IvSlvso2wS8bIYCMGp6Mo1kY7s/5JYRb+lRlYloRAJI4ymGgX6iyWmejCwcSunO09lfZqC4d2ZZ+7iMhDbtPI8lwYoCu46PJbVuUUybHHk8XNknY0J2pThs4eYWNtZdOhoTF122aBzBX5y8myNr4lOGIBu5lveCzYAEMtJ5KGHF5yVIWv36Xow9i+Ie19IS/YH2yVnfRMXRZTEVTuxRQTbanekj4t6TJGBDfYlP5+s4QKgT/CTQ7Y/0F24zFt7bmj27Po11fEZj3adh+tX43L3bVPUsFtISpLSpe4Rag0nJqp1VtLSpFwIaYZWSWebsIZID
 c0q/NbHG
 S7yiHczmKQyj1gs5pAa7spSeQ1MUKjshuXY0kjUhmu4laaBpcobXtyKv0mFVrkOPV/zOjiY6fQx4jDyAVvUJbQH/seVPQ6/8zcQypGmReqP4TF2gcp8BtX6lzWB8WbJ7/OJuMFoFZTvMeNc2qHYylof0eQD6xtROjeTIXcFFLfMxI32eQ7HK7ceWjCyYSCQEeV4nJvoYOmbV9ABADCYaXkj7KOOySG1V48COBz/Uzw8UGTtt+jvhjPFnT3CneTl+VeJ9pFaPAWHY164KqE1Z7iKq44wSpTRMRbyCKFykW3PInEvVxalTQlmqkVB+JYpp+NwWIG2h6AHdso/oaVH1GG5uSyQqQHGSPRu9PgAIxNvXaBCUiYzOq7YUhrVw8xdo7Y9btmVmLVQU1h8RKplUq0lIU9GS7nZul2nzqFLo0I69QirQGz8SdBxX9VQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 23, 2025 at 01:49:22PM +0200, David Hildenbrand wrote:
> On 23.10.25 13:40, Kiryl Shutsemau wrote:
> > On Thu, Oct 23, 2025 at 01:11:43PM +0200, David Hildenbrand wrote:
> > > On 23.10.25 13:10, David Hildenbrand wrote:
> > > > On 23.10.25 12:54, David Hildenbrand wrote:
> > > > > On 23.10.25 12:31, Kiryl Shutsemau wrote:
> > > > > > On Wed, Oct 22, 2025 at 07:28:27PM +0200, David Hildenbrand wrote:
> > > > > > > "garbage" as in pointing at something without a direct map, something that's
> > > > > > > protected differently (MTE? weird CoCo protection?) or even worse MMIO with
> > > > > > > undesired read-effects.
> > > > > > 
> > > > > > Pedro already points to the problem with missing direct mapping.
> > > > > > _nofault() copy should help with this.
> > > > > 
> > > > > Yeah, we do something similar when reading the kcore for that reason.
> > > > > 
> > > > > > 
> > > > > > Can direct mapping ever be converted to MMIO? It can be converted to DMA
> > > > > > buffer (which is fine), but MMIO? I have not seen it even in virtualized
> > > > > > environments.
> > > > > 
> > > > > I recall discussions in the context of PAT and the adjustment of caching
> > > > > attributes of the direct map for MMIO purposes: so I suspect there are
> > > > > ways that can happen, but I am not 100% sure.
> > > > > 
> > > > > 
> > > > > Thinking about it, in VMs we have the direct map set on balloon inflated
> > > > > pages that should not be touched, not even read, otherwise your
> > > > > hypervisor might get very angry. That case we could likely handle by
> > > > > checking whether the source page actually exists and doesn't have
> > > > > PageOffline() set, before accessing it. A bit nasty.
> > > > > 
> > > > > A more obscure cases would probably be reading a page that was poisoned
> > > > > by hardware and is not expected to be used anymore. Could also be
> > > > > checked by checking the page.
> > > > > 
> > > > > Essentially all cases where we try to avoid reading ordinary memory
> > > > > already when creating memory dumps that might have a direct map.
> > > > > 
> > > > > 
> > > > > Regarding MTE and load_unaligned_zeropad(): I don't know unfortunately.
> > > > 
> > > > Looking into this, I'd assume the exception handler will take care of it.
> > > > 
> > > > load_unaligned_zeropad() is interesting if there is a direct map but the
> > > > memory should not be touched (especially regarding PageOffline and
> > > > memory errors).
> > > > 
> > > > I read drivers/firmware/efi/unaccepted_memory.c where we there is a
> > > > lengthy discussion about guard pages and how that works for unaccepted
> > > > memory.
> > > > 
> > > > While it works for unaccepted memory, it wouldn't work for other random
> > > 
> > > Sorry I meant here "while that works for load_unaligned_zeropad()".
> > 
> > Do we have other random reads?
> > 
> > For unaccepted memory, we care about touching memory that was never
> > allocated because accepting memory is one way road.
> 
> Right, but I suspect if you get a random read (as the unaccepted memory doc
> states) you'd be in trouble as well.

Yes. Random read of unaccepted memory is unrecoverable exit to host for
TDX guest.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

