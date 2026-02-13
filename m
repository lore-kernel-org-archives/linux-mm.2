Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D933FEEA860
	for <linux-mm@archiver.kernel.org>; Fri, 13 Feb 2026 17:20:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2916A6B0005; Fri, 13 Feb 2026 12:20:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2692C6B0088; Fri, 13 Feb 2026 12:20:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 14B8B6B008A; Fri, 13 Feb 2026 12:20:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 02D076B0005
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 12:20:27 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A163ABA0C7
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 17:20:26 +0000 (UTC)
X-FDA: 84440097252.11.DE2DC1D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 772DA140003
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 17:20:24 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RJ1me+Rn;
	spf=pass (imf26.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771003224;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zh8SVD2WW7L08qo1lqwlWlDZ1zt1JgPFEBPOEaIYn3I=;
	b=ikki1vE3RWyTV83LxzOtJxvGia0fn4OyZEfI6ZTKgTGN2Fks1gFMEfyZTNkHRxBvWXIu2E
	WSY05NenggllZBfJ++ZoGuqRGAKJgh9cI8E6wSHum07C1YfIl5rzzRawkGtmE8xmdoXBTI
	+/U0fWRPLAHvvp6eeox7mWbOiMHe50s=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RJ1me+Rn;
	spf=pass (imf26.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771003224; a=rsa-sha256;
	cv=none;
	b=UYYKTwJaNF+1PO87am1G6rSN1PkSCKTKqFRF+tgUTAncmdywVHNijwvXF5ULpx/yGzGXtl
	MNJvgVS6dCxysRUzV0r89KUmqBuXk0RtVH1anEgGcAwrbxOq4VJJ69L+WaPMANdUkjFAAZ
	uutsio/3vsrN5C/J0G2aRKkbQ/nQl1s=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 377BA44467;
	Fri, 13 Feb 2026 17:20:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94FD9C19421;
	Fri, 13 Feb 2026 17:20:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771003223;
	bh=+LclX38OrI0KgaAdB7NwBZq/cU/VxYfgDrGVgHh3Das=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RJ1me+RnKRGLhGoHAPL4YNLROdA/vGro/41iyTWVy2Gdt0KEOho9/SjGiqsbSefqf
	 1xzDKDFPT5Szk6Fv+ZI9XQD/8usUWYcksgPbPB2OvRPKWvPcma06V4D2aiXS8aNyo3
	 ZQYxqO/jyZFdFB9Qm/B6+pvxtb9fqWDSP7IHEkGLEM9+EbgmvHhrI1RUWyDbW3uYUX
	 ZZ3FPkrz/y2ZzfNKqHPbnVfcOKuR47daLLJk063OmuAEYpPz2ng8Yi4iYlElrOBkaD
	 YIHiDpB+adsNNxxEn+fEISFIwJalS78sZRd/4cfAQBW8afO+qI8hCnQIXs9G5mVech
	 dp0LmRZQCJfjw==
Received: from phl-compute-11.internal (phl-compute-11.internal [10.202.2.51])
	by mailfauth.phl.internal (Postfix) with ESMTP id 9E448F4006E;
	Fri, 13 Feb 2026 12:20:21 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-11.internal (MEProxy); Fri, 13 Feb 2026 12:20:21 -0500
X-ME-Sender: <xms:VV2PacGI0vlgbrJvA39gHOcuxE4YgPqhU7MefajaiyfRWlNX0UQjTw>
    <xme:VV2PadJbvhOg4g68wcGnSTfGTNvbpGZl6J8emGXTDlQrW3up2p1XkFMOxRpRB2PkE
    t7ZSysWrAYhX_QBM10D1Cb3IpXTjDxQUkPf4zWbHViEh-e2X1qd9S4>
X-ME-Received: <xmr:VV2PaRhdaJoBiwPaXM_lA57mR1QnuxltEpKLkKA6Q0mqUr-kS7-C58uJRaxoQQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvtdekkeefucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvg
    hrnhepueeijeeiffekheeffffftdekleefleehhfefhfduheejhedvffeluedvudefgfek
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepkhhirh
    hilhhlodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieduudeivdeiheeh
    qddvkeeggeegjedvkedqkhgrsheppehkvghrnhgvlhdrohhrghesshhhuhhtvghmohhvrd
    hnrghmvgdpnhgspghrtghpthhtohepvdeipdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopegurghvvgdrhhgrnhhsvghnsehinhhtvghlrdgtohhmpdhrtghpthhtoheprhhpph
    htsehkvghrnhgvlhdrohhrghdprhgtphhtthhopegrrhgusgeskhgvrhhnvghlrdhorhhg
    pdhrtghpthhtohepthhglhigsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehmihhngh
    hosehrvgguhhgrthdrtghomhdprhgtphhtthhopegsphesrghlihgvnhekrdguvgdprhgt
    phhtthhopegurghvvgdrhhgrnhhsvghnsehlihhnuhigrdhinhhtvghlrdgtohhmpdhrtg
    hpthhtohepthhhohhmrghsrdhlvghnuggrtghkhiesrghmugdrtghomhdprhgtphhtthho
    peigkeeisehkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:VV2PaX6L905tO5Mr7KmKd4hhofDyIrFl7INMJxQickKUh4SrdC6wCw>
    <xmx:VV2PaWPKP9SD_bbiw0eouQFDQdKtnIhtgHG60lAHhwJ-BU2wDFFu-g>
    <xmx:VV2PaWeHE2ZiaWd_w1MfW8B6fFyVeYiizWfo1zylnOftPfEo1pWP5g>
    <xmx:VV2PaR2Q-mq8Ph_gQcFui3wOA7fhDsgAcP2gmv9PLuu_0WVkS-vNxg>
    <xmx:VV2PaWMU1062Uene-WEpehlqjuxyfhf7P_zeDK_37MW4CAq2MjdB97XV>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 13 Feb 2026 12:20:19 -0500 (EST)
Date: Fri, 13 Feb 2026 17:20:14 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: Dave Hansen <dave.hansen@intel.com>, Mike Rapoport <rppt@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Tom Lendacky <thomas.lendacky@amd.com>, x86@kernel.org, 
	linux-efi@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Moritz Sanft <ms@edgeless.systems>
Subject: Re: [PATCH 1/2] efi: Fix reservation of unaccepted memory table
Message-ID: <aY9c80nXefdXjGXh@thinkstation>
References: <20260213154838.46567-1-kas@kernel.org>
 <20260213154838.46567-2-kas@kernel.org>
 <b3b073e4-d51e-4fd7-ad7c-7465dab412b6@intel.com>
 <aY9Mf8oZODGiDoXp@thinkstation>
 <6d6dd421-774c-4f29-84d5-3e449240eb93@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6d6dd421-774c-4f29-84d5-3e449240eb93@intel.com>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 772DA140003
X-Stat-Signature: n7artugxiyuwpih3njey5gw7izs7tybe
X-Rspam-User: 
X-HE-Tag: 1771003224-291708
X-HE-Meta: U2FsdGVkX19LVp9ZfhWRj637mKZE8bsBlZKxyil0Czy0cy2YNv0PGy9RI+x2jDhZdesal68t1QTe2jw4P2obj4RSC9IMyBaPehiY9s701mv4ZTBe33/sUjIpdb3nEObpvlbikOmpZqgo6gBTrwbX8zmF7pZdS6gQq54C5E5se29T6D8TliuNEiqGlkA2qghA45yxM2+uNz6bb2a6CO5FU7HE6ajTH4gmbt4OtBaiTPY7WaKToRH3Gmt0Ia1azG1ylm4JisxHsnQ1um12BIq+PnyzpYISX1hCQG8QjdFBv7fLiR6MGuwmQ1GmuiSsdpGpYSU/9ZV+g+Y9NUYOP9jLamKFnhVYt7iVYTqsrTIgurruG9q3H/v0hYHzrW/wHzShoXtbigEwxthuVJ/N6mGh0hTUXO2tAdGVHXpG+j2imAzEe8KGw2vn1modoD1cVj+kvtnETkgzXps1TOqlucn3a5xrc5xk1wH3v/9pVdC8mwXc8mi+wsC/0v/+s9L2cr8j4ACbp60zd6eCBobmCevEM5WXJB3nxxN1FxOboW3UscykfGx+9t9rOWp3flYaXn5ZBIHsUybQLHq4fhyIMUZWJEsxzHfJDDvNl3Vu/jjQZsBG8M4RqcZAZ7Tm9SCgj8/CRxuw9uALLuRIoLs6th25OHSoyKLrD5Q9HxG6CmqNKrxWmIy57BpdxgeKD/LbvaJTaQWe97rSOuyMYCkcrsHMkYlrGkM0LcPONlwe0f86Mt2Ralog3ZFFsbiLFnTCxHDgi2mNNn8bnhLvw5Aw3EC+9Xvnf3ETTzBY45B6hgDSXBbbUtwxz/2M1UEnJnuijgzhiE5BNCYcF3RRbqEExnNvFIjHeCotO2a6vdr8bFcUSdVLwlw0D3LCgeRjvWJ7tTPL52zZWibyIQExKxUHs5Y0ULWuRoNZLz3sr6wc9MjGpQOU7F6UZK4/OIC6J9QE4wd4A6Pk2+nEIpZlQXoLkth
 tLe3vk5N
 22K+vN8ZREClZAOp+wGOQO6BPTOFM8kHLb30TZ2UwzHPyfUYGVfQd8No8JUZsMOjDl+JN6EdTjjMW8eV03mMtFtNn2P9YZzLXX4xXyXalhZKnCaDxe6F61hlKi6TqhXzwhR146WxYzjr4h0e+ZIcm0p2yUVc99/ka1ul/jcybBzzkjr2sj7Gl+fAPM+Ry3V5npf5RkDN5qyxyAEEITMwFVZEqXxLkfZNf8eDwKkrhnJht6TZ1ra3DG3IvdStpDqDY+8V7JlkIWiRn6wnD+MJV7Xp69A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 13, 2026 at 08:46:55AM -0800, Dave Hansen wrote:
> On 2/13/26 08:14, Kiryl Shutsemau wrote:
> >> The memblock code seems to be able to handle arbitrary alignment just fine.
> > Memblock will track it, but, as the comment says, anything smaller than
> > page size will not be mapped, but we need the table to be accessible by
> > kernel.
> 
> That seems really, really fragile.
> 
> We should first make sure this is intentional memblock behavior and not
> a bug before we go add more hacks on top of it.
> 
> Why would you even present a byte-level reservation interface if it is
> free to just silently ignore some of the ranges by rounding them off later?

+Mike.

My guess that multiple memblock_add() calls might add up to the full
page size.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

