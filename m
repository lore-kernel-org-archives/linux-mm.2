Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4DA3DE81A24
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 14:22:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 147C46B0005; Mon, 16 Feb 2026 09:22:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F5DD6B0088; Mon, 16 Feb 2026 09:22:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3A226B0089; Mon, 16 Feb 2026 09:22:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id DF6AA6B0005
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 09:22:55 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 86729160A12
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 14:22:55 +0000 (UTC)
X-FDA: 84450536310.18.3D75704
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 7261B80007
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 14:22:53 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Mz+gX6cu;
	spf=pass (imf30.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771251773;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W+GkGfJoSjRgPj01y7H+7yuJPuBzKVeflEvHC5hfY4Q=;
	b=bi6ku10EPsKYblWCcIBtcHXt6Qr9vXV8f/bnRQn6f6k+fjR828UYfrkYnJaEIlj0PAOhTS
	CT+z55LpDnfafq3G9YinuawdyKjRxiN8oySRclQHxFKLtRlVkivX7UESsoPumu3uDsmfGx
	eForSqyzwAVM0+gO1bOsSckeEVcz+Hc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Mz+gX6cu;
	spf=pass (imf30.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771251773; a=rsa-sha256;
	cv=none;
	b=azIrlL0A3wfkqtm2L4Lffqr9whJ0T6PzDD+0+RDAowuRMXTm81D3Zq9QRrK3DFTU3tbl1J
	AfFmIn/JNiGDpMKzAsEChHs7N9B/tFIVWrZy50pczfsFlo9CSRGxSxKfMDlb50rJaR16My
	zV2xdQ8Jv130DDHfxweiKARbSyuSVp0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3E71143F26;
	Mon, 16 Feb 2026 14:22:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE394C2BC86;
	Mon, 16 Feb 2026 14:22:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771251772;
	bh=zU3ubHaPiCQva4ddg0RMo350B79XWEl6ga718019SJk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Mz+gX6cu5dvxn4gEY+wL9F1YGHucH/BuL7hxFg9Mcc4yOJj4NuvOMpf+uqsXH3eJv
	 FMpc9oa/eJKGVRcgfmt3M2qEf4fI6+IF0HnusXIFaiKZqdhGEzTAuWkAwjWkgSbBxt
	 KdSSTOZLPsHDBckgsrACyF/nTiYr5OfE6y6/znt1nPklxgvtNG+z1SxoYgYSbn2aWS
	 gPJoclwvzWb4vt7FqHoV7uxDdaDS+6jp4TcURjJNDSclVVNjYCyqqq+GaYKEL+rqC3
	 0ncL6TRjZAlDsCa1TXg6vqSemz0O+CfXdq3mJeA3JLkbYVHBVj5dVg8b0i8VtC7roK
	 4VvY+0fdizyYw==
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfauth.phl.internal (Postfix) with ESMTP id A81C7F4006C;
	Mon, 16 Feb 2026 09:22:50 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Mon, 16 Feb 2026 09:22:50 -0500
X-ME-Sender: <xms:OiiTaT4sH9z-kHOTu-4r3OeubnWBwAliot_dyQ_TfoeNCD2CoGVzQA>
    <xme:OiiTaWXQB5vwP_8MqQKZPKRrC4Or4_XT-lzL7gFeUkVA5e-tATwTaVXmfr44ZnnP4
    M0gG5Fg403amXhesZku8942ZST5aAuprbMSwEe2O3oaYNf9m6-f0gU>
X-ME-Received: <xmr:OiiTaaY0-9iAhgSMNvs4uiDp4a81jexcw0wmuJVITcxd0fbMHjcoa9leZods_Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvudejuddtucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvg
    hrnhepueeijeeiffekheeffffftdekleefleehhfefhfduheejhedvffeluedvudefgfek
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepkhhirh
    hilhhlodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieduudeivdeiheeh
    qddvkeeggeegjedvkedqkhgrsheppehkvghrnhgvlhdrohhrghesshhhuhhtvghmohhvrd
    hnrghmvgdpnhgspghrtghpthhtohepvdeipdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopehrphhptheskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepuggrvhgvrdhhrghnsh
    gvnhesihhnthgvlhdrtghomhdprhgtphhtthhopegrrhgusgeskhgvrhhnvghlrdhorhhg
    pdhrtghpthhtohepthhglhigsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehmihhngh
    hosehrvgguhhgrthdrtghomhdprhgtphhtthhopegsphesrghlihgvnhekrdguvgdprhgt
    phhtthhopegurghvvgdrhhgrnhhsvghnsehlihhnuhigrdhinhhtvghlrdgtohhmpdhrtg
    hpthhtohepthhhohhmrghsrdhlvghnuggrtghkhiesrghmugdrtghomhdprhgtphhtthho
    peigkeeisehkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:OiiTaVwnj_tFU21J4poJtyAPFkgtxpyk0TAkTnPFedmzN8p2oLNpMw>
    <xmx:OiiTaXLC5PTv08-dpGr3j8eHnm1M7wO9nE9IsyNP8-3T8laIpbHeFA>
    <xmx:OiiTaUdoj9oH9YFQw71IRuDPWjGJw_1AvkE9dlYcPdmDyvst5Q0NCg>
    <xmx:OiiTaXuZBORuXeCUG8D-n_NqK-6xJQWjR-IuvI1LVeV7LyNA9HdPbQ>
    <xmx:OiiTaaE6TaMod6CiXIVmI-sVqwUeH5ZVSjA6iLJZnY16_pqbsl7T56Uk>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 16 Feb 2026 09:22:50 -0500 (EST)
Date: Mon, 16 Feb 2026 14:22:49 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Dave Hansen <dave.hansen@intel.com>, Ard Biesheuvel <ardb@kernel.org>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Tom Lendacky <thomas.lendacky@amd.com>, x86@kernel.org, 
	linux-efi@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Moritz Sanft <ms@edgeless.systems>
Subject: Re: [PATCH 1/2] efi: Fix reservation of unaccepted memory table
Message-ID: <aZMn5_uLLH61Fr6o@thinkstation>
References: <20260213154838.46567-1-kas@kernel.org>
 <20260213154838.46567-2-kas@kernel.org>
 <b3b073e4-d51e-4fd7-ad7c-7465dab412b6@intel.com>
 <aY9Mf8oZODGiDoXp@thinkstation>
 <6d6dd421-774c-4f29-84d5-3e449240eb93@intel.com>
 <aY9c80nXefdXjGXh@thinkstation>
 <aZCaE04vDpf2hDEc@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZCaE04vDpf2hDEc@kernel.org>
X-Rspamd-Server: rspam11
X-Stat-Signature: ch3h5zqoa7edbxik696e96u881kxcxzc
X-Rspam-User: 
X-Rspamd-Queue-Id: 7261B80007
X-HE-Tag: 1771251773-904539
X-HE-Meta: U2FsdGVkX18Kft4ALNKnpggwAxAD5oNK3HYswNrFvO+ISvI85GBZ1cZ8npS55T+ixuPjZ1W3aY96ujSXsIJUjxLJZvUzKvJYcABsUYibWk4ZnBi9QhPs+KSIIGnquj0hQ5kXI1UEJvKkCDg/O284EWt2wcUJ3SPoaoB6eywagNgwI9koYTZ+WlYLq54hLPnDeONaocPljKZ2NxxF0P/NS3CfIceXAGpxN3yw2cotyzqiHjsVS5ZrX4CJseW3CeKnpKKGq8/IHbv/bhyn3fm9tK5Y3O5DGpm2TVTG9JnUYPKqM0FmJrOotGL4bT6UyWdIz0c02NCISg0oBga7bDEf6fZSAo/5C3Kj4sej1yho7az87Xe+FUX4u2i/vmlH6bpVltgjbbgs/5az6XT1gQoQhTzIvTs3F3eicSOUn6+2+28HlaHJZChS1vfkhodpUhl7Igxr8FhLSHqrKcecuM1nz6pKdTg6cStsVwv86hSiWeW0hNwPEgnUHM4DWKps3i+CjBN98xUFNmiAaP9U0ef82LxPJkdndvUY8D2UV3jSRBf1tbG5meZvZCsxejILyU8b/c+clT51ZKuEH1R6ZUJHwteuPkeuCthnANaKHvPYIUrtjJBEJASuoxjxe+gQfMNLFT+9GZY6q/CwEuzprA96S5B5gTEhnE0wSA3ktQ7NWopIXGETmk0ZwCPL7SL2XojMsWI5gMGtSJEzEkqCbDWz91/nXmiqufD5or6BbQMYg6SpLXn+DPFaoeqNd/B9jXOrx/TMkc8J+uAvq2vM6YuZAQxJY5O8EEV3hZ8As29QCXfvqCg91sCR7ZgBH5XDco05jkRjOBx3jFG+NjT/xeZcD/5aJlglpyFbpxhc8fBS28uUOljbGW6j4ZLlATJgz1zhsf7v1o40BpzyT+MhRfEuP+5rhcM4C9YGoedpCpoxo0xym0/KCR8rEJ3qu6vUnxE88InGiF4Fj4kIhS8mZa2
 H2ByAFlW
 O9ftXpQgqlfVUNtzGXBXVWd6jSyhWADxLq2MbVmWK86WgUdf+5dOEag0hw2mP3BIQt8rE4KGAByEnZbci5CQOSozha3s5ckPTK308e3eXW9rBTB3ihaDgwyKym6z+NzlAqkQeI7bX5bNAydshn8EAeN97rjNkk0j/MIjIPRgWwkzbHvvKq68xR56bWdFNOLKNLOD9GFHobFVlOpD/h9VU1zqYD1pUNAgywWcXEf8oJq5z1mbD91rsTg0S2JkZJBdBj3UdRl8fseIcHD6+L6+lhT4VtA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Feb 14, 2026 at 05:51:47PM +0200, Mike Rapoport wrote:
> > My guess that multiple memblock_add() calls might add up to the full
> > page size.
> 
> I'm not following here. Can you explain what do you mean?
> 
> Multiple memblock_add() calls to adjacent ranges will coalesce into one
> larger range. But I don't see how is that related.

I tried to find justification for the byte-level tracking by memblock.
Not in relation to this case, but in general.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

