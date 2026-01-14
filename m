Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44E81D29FE7
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 10:47:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 973296B0005; Wed, 14 Jan 2026 05:47:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 921156B0088; Wed, 14 Jan 2026 05:47:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F5326B0089; Wed, 14 Jan 2026 05:47:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6B7A06B0005
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 05:47:30 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1A99F140482
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 10:47:30 +0000 (UTC)
X-FDA: 84330243060.16.B3CE937
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 2C8E2160006
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 10:47:28 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=vEd9Pv9Q;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768387648; a=rsa-sha256;
	cv=none;
	b=SQSPOXT/9LZ7IC5nIoroSdPeK8R03XWmzh55ILuh6/U2Ih1bGbjzxNVxn7YX95wfVTBVf2
	AO0OVSV0C6TUNJAWz1oz4vu6yXPgoLLFv/RjwQ6454pGD2DNquyFVa/rxz0CG7HCL9Jz9N
	7ARsQJmEHyVBOuYlPsxX8RD5MsEcYQ0=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=vEd9Pv9Q;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768387648;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R559yPuxG9KyK02Z941KfOj2V6XHnXFcw0dwwu79c3U=;
	b=F9Q4tWWENcf5IOBuNS895XdMZGrHeY50FY+KeLBuYVdXgOEBnRcok6t6XGjkE/D7LYvzwZ
	tV6rD8S35TaIX4im+Js65eUfiMTLlGwKxjtEWdyJ1FqQVmlz1qRLeyqC+bXs+SumIWPzRO
	c/op8B3lHWyhEv2JthQZD3mM15QUx6A=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7AEA560052;
	Wed, 14 Jan 2026 10:47:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D4C5C16AAE;
	Wed, 14 Jan 2026 10:47:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768387647;
	bh=/pFm9EHouOniP7p5BFrqarS7UC8OMmNdqTIArQonxJA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=vEd9Pv9Qam7Yp+Q9FfI8Kmb71PM/4QnwQgzKAkkSvq20j4Kw424Hx0GcGs6oFLlbG
	 N6vAwxHV76qN7K2++Fds/RK5+fDDZtZ9OKc9VFajjy2PcyK+plQs80CPtQoXPDMWT1
	 0cWbl4faZm5giwD9cl6t46nV5nRSZ3QpWI+VreXYAhk9aPP5MFWkyoqTtd04QSz9kD
	 CZIAaBuKAIbPFTKEVkxOnxpiBHLd9Hd1olUz1MD1ywxbWTDJ03nKU87uWsata9vfKV
	 CRD6DxjMRpPCI5phuACZjYNSTyD03W8IbLjm2ppCnZkzTQ+iMxcO8Cta5f0VUzrbyh
	 T8037c4Mr5r6Q==
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfauth.phl.internal (Postfix) with ESMTP id 8FED8F40068;
	Wed, 14 Jan 2026 05:47:25 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Wed, 14 Jan 2026 05:47:25 -0500
X-ME-Sender: <xms:PXRnaV8QlCUoaNsDjsb_x1rhhPNUl3qjWjhGS4-ebEN7BNtBWvh6eQ>
    <xme:PXRnaadbx8H6fGsbzyKAf-V7JszsqF5BJHBP3r7Fp_q99Mzs3ZYPrw5Qm6C-sbPg9
    s-fPQoQtZh2OhRnUk1z6dThhJptk6Zco36ZuI-isDKimlef0iurEA>
X-ME-Received: <xmr:PXRnab4_8xsnnnZCK-0FE3DQPOzYcmyqcPE1lCWMrZQ97xy-DzM80N9heXy7kw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdduvddvleejucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvg
    hrnhepueeijeeiffekheeffffftdekleefleehhfefhfduheejhedvffeluedvudefgfek
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepkhhirh
    hilhhlodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieduudeivdeiheeh
    qddvkeeggeegjedvkedqkhgrsheppehkvghrnhgvlhdrohhrghesshhhuhhtvghmohhvrd
    hnrghmvgdpnhgspghrtghpthhtohepfedtpdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopehprhhsrghmphgrthesrghmugdrtghomhdprhgtphhtthhopehlihhnuhigqdhmmh
    eskhhvrggtkhdrohhrghdprhgtphhtthhopehlihhnuhigqdgtohgtoheslhhishhtshdr
    lhhinhhugidruggvvhdprhgtphhtthhopeigkeeisehkvghrnhgvlhdrohhrghdprhgtph
    htthhopehlihhnuhigqdhkvghrnhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgt
    phhtthhopehtghhlgieslhhinhhuthhrohhnihigrdguvgdprhgtphhtthhopehmihhngh
    hosehrvgguhhgrthdrtghomhdprhgtphhtthhopegsphesrghlihgvnhekrdguvgdprhgt
    phhtthhopegurghvvgdrhhgrnhhsvghnsehlihhnuhigrdhinhhtvghlrdgtohhm
X-ME-Proxy: <xmx:PXRnaRVunT5ucghZofY3xU31yQ4VjFZJ6ZUvGhW6HC9TWZsha-uq_g>
    <xmx:PXRnaZX_HKb0pbzTkZENrbXKzptOEvu052-pH9DkvrDwY3GsxkApUg>
    <xmx:PXRnaSYgaPIjvMj4fopNQstyKYVZVxJF4P2AXg-mdNHKm4_sb9O7xg>
    <xmx:PXRnacWOFFwmA5_GsOt_RkY6Aq87_aw-UKdHGHqmjuSVBlSK_UGMjg>
    <xmx:PXRnaV79FOu7p6OvSn7UA1GPw5oujqVPU1UQnMd0poCd4czUIQf987ln>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 14 Jan 2026 05:47:25 -0500 (EST)
Date: Wed, 14 Jan 2026 10:47:23 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: "Pratik R. Sampat" <prsampat@amd.com>
Cc: linux-mm@kvack.org, linux-coco@lists.linux.dev, x86@kernel.org, 
	linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, ardb@kernel.org, akpm@linux-foundation.org, david@kernel.org, 
	osalvador@suse.de, thomas.lendacky@amd.com, michael.roth@amd.com
Subject: Re: [PATCH v2 2/2] mm/memory_hotplug: Add support to unaccept memory
 after hot-remove
Message-ID: <aWdwIvzPDqY21cbS@thinkstation>
References: <20260112202300.43546-1-prsampat@amd.com>
 <20260112202300.43546-3-prsampat@amd.com>
 <aWYctexPTf-w7QT8@thinkstation>
 <af3bf2ef-0231-4e75-9a80-c2bd3a7e1bf1@amd.com>
 <aWaGBandNCLT93Tm@thinkstation>
 <7283516a-ee5b-4226-ba32-1d9325eb6748@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7283516a-ee5b-4226-ba32-1d9325eb6748@amd.com>
X-Rspam-User: 
X-Stat-Signature: 6zrdz1dfwy3m974i711b8ysmwfnnqa7u
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 2C8E2160006
X-HE-Tag: 1768387648-929596
X-HE-Meta: U2FsdGVkX1+qP7Z3RfXzykNZG2rhqRoDWm+HSsWlPrhUvRGEUFIY32bhIEidWV9SwaSbV7RbhC6IvxmMzY0wswMi65ZKHVcSN6oO52q1KaGOozPhA92RgHzCt1+55dXJ8aOyoR46oZSNFanYKNS9C5/GQ30OpFt3Tcw9yBWqHYgB97nKeuLyzYLUF8ZuecwJfi4TUHbeVKUODj2nxM/E+bb+aagxiN3vOM8DWkTnZ0anUhqy9e8MangEMPNSeyOTpKcfbYl9HmkOtJL6UbH0iqNzGsCiTDgSoPaOnGcXO5mdcNWx3P0fiZ3EadQmO43htzMXuBtikghqriFf8PjzeA2TsO8dA/5qH5n/nMBFDJVKGE6hIdzkCen/Kx8yyHFGqffus1F2hoHYQ9bbrRs6eKbw7P9aO2/Z3BHZT+zbqd7od/Z+toNF7CAqevgAywNL9322VKhnWch85TQQXNGAfEAX4AnBt4cvBMS4Ewcgunbi8UGp13VMqNUkT1Ki85ArrRQ5EsAoV78yws1nNoWQqTvOptS9fNCPfSD2mFJhh79cFJk1zfWkzjc5rtU8F0uXTRo+nEm39FhTDhpR2fnVB3TsBTpO4hv8LLhZDs6sW99p2C4ayC+r+tCMDl9OxQlKAULT4yT4dkhhkhmGGdsEH9S8NCmSNsoJOKPa9X0yKjpQTUEy/9YwSfEd7J0JbbvDXmRfEddJStg1udjj8YsKQvJNWE7+tzQt4sSLKYJ0Rx8HiJt0xs1qdytygReiHf0L1UCDB4GPzjEc6FNYMqBqWP2OUmLLKjEU55ujZByPNZ4+bULCPSOy7ks5axtaMxCIkDcNWMxCXiw9Z/KqR7UO9YozUqr4VQz0uW92klgsmELc8/43PLL8yJPqI5iou1hLZh7UPP7avu/KgnAJTa86WzzbFj7ub3Ibj/3HW1J5ZZySLawMpwF9loCiTXWkizbXjM7ajUMS5IkjQnyjLye
 /jYU6n7i
 wulTAeYa99wtt/LSfJ627na9boKeTlr7sniGkIElV4NKiaKZAIN/5Hb5iBJLhgLgwDB4quJXLVb4+UPTLkaF/Mk8VqHDkI9VZNzvtSWAk32fXvMupGVjYqrVL5XW9vc0N8Zsdhu2WGkMNr9XV3sJvdPDm/H2h6DsVBPULl3U09WdZk2R4u36BtmVSFesICJH+ByKApFY0C894dJKwKaBJhxg0B+jeJxWRJMsTXSKxwx52bY/XcVTZuzFSqf0f+5KJV6I+HTpQ3ix0GJbn+GaEAZZJAhRIbu76zcbT8PdtIgw3OjFN82qIzeohPgaVDLI16ISB
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 13, 2026 at 12:22:33PM -0600, Pratik R. Sampat wrote:
> 
> 
> On 1/13/26 11:53 AM, Kiryl Shutsemau wrote:
> > On Tue, Jan 13, 2026 at 11:10:21AM -0600, Pratik R. Sampat wrote:
> >>
> >>
> >> On 1/13/2026 4:28 AM, Kiryl Shutsemau wrote:
> >>> On Mon, Jan 12, 2026 at 02:23:00PM -0600, Pratik R. Sampat wrote:
> >>>> Transition memory to the shared state during a hot-remove operation so
> >>>> that it can be re-used by the hypervisor. This also applies when memory
> >>>> is intended to be hotplugged back in later, as those pages will need to
> >>>> be re-accepted after crossing the trust boundary.
> >>>
> >>> Hm. What happens when we hot-remove memory that was there at the boot
> >>> and there's bitmap space for it?
> >>>
> >>
> >> While hotplug ranges gotten from SRAT don't seem to overlap with the
> >> conventional ranges in the unaccepted table, EFI_MEMORY_HOT_PLUGGABLE
> >> attribute could indicate boot time memory that could be hot-removed. I
> >> could potentially unset the bitmap first, if the bit exists and then
> >> unaccept.
> >>
> >> Similarly, I could also check if the bitmap is large enough to set the
> >> bit before I call arch_accept_memory() (This may not really be needed
> >> though).
> >>
> >>> Also, I'm not sure why it is needed. At least in TDX case, VMM can pull
> >>> the memory from under guest at any time without a warning. Coverting
> >>> memory to shared shouldn't make a difference as along as re-adding the
> >>> same GPA range triggers accept.
> >>>
> >>
> >> That makes sense. The only scenario where we could run into trouble on
> >> SNP platforms is when we redo a qemu device_add after a device_del
> >> without first removing the memory object entirely since same-state
> >> transitions result in guest termination.
> >>
> >> This means we must always follow a device_del with an object_del on
> >> removal. Otherwise, the onus would then be on the VMM to transition
> >> the memory back to shared before re-adding it to the guest.
> > 
> > This seems to be one-of-many possible ways of VMM to get guest terminated.
> > DoS is not in something confidential computing aims to prevent.
> > 
> >> However, if this flow is not a concern to begin with then I could
> >> probably just drop this patch?
> > 
> > Yes, please.
> 
> Putting more thought into it, memory unacceptance on remove may be required
> after all at least for SNP platforms.
> 
> Consider a scenario:
> * Guest accepts a GPA say G1, mapped to a host physical address H1.
> * We attempt to hot-remove the memory. If the guest does not unaccept the memory
>   now then G1 to H1 mapping within the RMP will still exist.
> * Then if the hypervisor later hot-adds the memory to G1, it will be now mapped
>   to H3 and this new mapping will be accepted.
> 
> This will essentially mean that we have 2 RMP entries: One for H1 and another
> for H3 mapped for G1 which are both validated / accepted which can then be
> swapped at will and compromise integrity.

I don't know much about SEV, but I assume RMP is similar to PAMT in TDX
where TDX module maintains metadata for host physical memory.

What side problems do you for guest here?

I probably miss something, but it seems to be VMM problem, no? I mean if
VMM doesn't update RMP on replacing one HPA to another for the GPA, it
is bug in VMM housekeeping. Guest is not responsible for this.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

