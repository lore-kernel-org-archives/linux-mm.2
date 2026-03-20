Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2732B109878A
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 14:26:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 754246B010D; Fri, 20 Mar 2026 10:26:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 72C0F6B010E; Fri, 20 Mar 2026 10:26:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6424E6B010F; Fri, 20 Mar 2026 10:26:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 54E4C6B010D
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 10:26:57 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1E2C31B70CE
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 14:26:57 +0000 (UTC)
X-FDA: 84566668074.03.90CB370
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 292661C0007
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 14:26:54 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pvKHz0yv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774016815;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OThQKp893LphSr3Eh3o12D7pythV7l0TMffC5k3P0g8=;
	b=m5hDSzQNkzAm6noNeAumZ9kw4QqfzTQuAUguGmOk1zBfhcdyfH5kjsWyD16536FjbKMoc6
	5cBJ+bnX5he42WKCyjNHXGN2/MLb9XltQHW5QZCpU3nDE3qQwrpdmbToF10tf6KX0bkmh8
	DlawIy/7kgcWwDa3uWh06v7SE8VwOR4=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pvKHz0yv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774016815; a=rsa-sha256;
	cv=none;
	b=blzB+lKv8BNIiO5Rr+vXFLeDwkiJYueauyr1TSdaAtmwPD0TjrJPjed7dua46VxN8etL5v
	sGp72iiFx5V+/w+6Js/68o3rKiPop8fNbbuH1yGxCsGpoxMWzonBkwgwvdVvTR5+aGRTvM
	fWVxgZDXpd/MbgFib+vmtGzMgQQ/Nn0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 623636185C;
	Fri, 20 Mar 2026 14:26:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57211C4AF0B;
	Fri, 20 Mar 2026 14:26:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774016814;
	bh=0A3E8OFKs0O9ILXNdXWvmGC5H7JP8qHQNC5ofyYrUPM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pvKHz0yvaHt7yXjkgycz+Mh6vQI/FtlyH5zkdPe9fX8OLgpxBlJQ+5g688D+xo4EB
	 boPXgnXBIjx2PLKFFLWfBG6a5n9Ns9bNfoevs8tWypTGgAd3KAoHwG83XxmbWlaPe8
	 bJ6QZ/1X68mtWRbF15uCLRJEvTgQyBFMN6GbJ2pBi24hV4MSwKhP9ahYm+o/adWidK
	 PYiWp4ea9WFVfanPvEiTHxIbXvqOB+0m/1mSkVGAbCUEA1s/2X1H2YmvMKZWxmQyYO
	 BsPLYHdkfsFYIbYp84qoTr0XMh1fv3ZInf9WC/ZUvCultXNbBT9Gc0CFSa1sRYBJd/
	 Ix8mMA137gMTA==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 3ED2FF40068;
	Fri, 20 Mar 2026 10:26:52 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Fri, 20 Mar 2026 10:26:52 -0400
X-ME-Sender: <xms:LFm9aeSBuUCrHINfbPMjDM5NOuwsec15zikcAYsd_e1YaxhM5GSKdg>
    <xme:LFm9afc4eZo5eHohZD66T-vSSuX-HZ3oMZf64h09IN15YVDqSmzUpbAwr8xmufPZy
    m9xB9-AseZUQRroFN4BU8VtHYnUlMWxjWrbe7T-cDTYDk72t7X1_pfN>
X-ME-Received: <xmr:LFm9aXcQ62hYHa5fAZpD3wct0dWtIrMStLzszKWngoHcqbAciXOgrBpktvbA_w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdefuddtudegucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvg
    hrnhepueeijeeiffekheeffffftdekleefleehhfefhfduheejhedvffeluedvudefgfek
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepkhhirh
    hilhhlodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieduudeivdeiheeh
    qddvkeeggeegjedvkedqkhgrsheppehkvghrnhgvlhdrohhrghesshhhuhhtvghmohhvrd
    hnrghmvgdpnhgspghrtghpthhtohepjedvpdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopehushgrmhgrrdgrrhhifheslhhinhhugidruggvvhdprhgtphhtthhopegrkhhpmh
    eslhhinhhugidqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtohepuggrvhhiuges
    khgvrhhnvghlrdhorhhgpdhrtghpthhtohepfihilhhlhiesihhnfhhrrgguvggrugdroh
    hrghdprhgtphhtthhopehrhigrnhdrrhhosggvrhhtshesrghrmhdrtghomhdprhgtphht
    thhopehlihhnuhigqdhmmheskhhvrggtkhdrohhrghdprhgtphhtthhopehrsehhvghvrd
    gttgdprhgtphhtthhopehjrggtkhesshhushgvrdgtiidprhgtphhtthhopegrjhgusehl
    ihhnuhigrdhisghmrdgtohhm
X-ME-Proxy: <xmx:LFm9aWJL-Ss4VdQh9OttEJlT8Zf4nVQblfCHB4NkuN0R0ulAXU5f5Q>
    <xmx:LFm9ad2S784Cw2CLErVJ-CsAKIS3XDTHQ04Fl2vvan8jvQZHTc5XSA>
    <xmx:LFm9acrITVLMbY1A7gbnjs8AZ8JtpLketSqNd9lSaUs7Gf9fzI0muw>
    <xmx:LFm9aVq2Y2vgmS6pQU4GVPJtd_34daD2fwzbHPhe5kJTjNutWkIeWA>
    <xmx:LFm9aTzlGZD1DjptI-AgFUkbuM-4axTLedVlLdmnC_tWJRhkBKwYAZUf>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 20 Mar 2026 10:26:49 -0400 (EDT)
Date: Fri, 20 Mar 2026 14:26:43 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@kernel.org, 
	willy@infradead.org, ryan.roberts@arm.com, linux-mm@kvack.org, r@hev.cc, jack@suse.cz, 
	ajd@linux.ibm.com, apopple@nvidia.com, baohua@kernel.org, 
	baolin.wang@linux.alibaba.com, brauner@kernel.org, catalin.marinas@arm.com, dev.jain@arm.com, 
	kees@kernel.org, kevin.brodsky@arm.com, lance.yang@linux.dev, 
	Liam.Howlett@oracle.com, linux-arm-kernel@lists.infradead.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, lorenzo.stoakes@oracle.com, 
	mhocko@suse.com, npache@redhat.com, pasha.tatashin@soleen.com, 
	rmclure@linux.ibm.com, rppt@kernel.org, surenb@google.com, vbabka@kernel.org, 
	Al Viro <viro@zeniv.linux.org.uk>, wilts@infradead.org, ziy@nvidia.com, hannes@cmpxchg.org, 
	shakeel.butt@linux.dev, kernel-team@meta.com
Subject: Re: [PATCH v2 1/4] mm: bypass mmap_miss heuristic for VM_EXEC
 readahead
Message-ID: <ab1Y5fLNJ466kK-7@thinkstation>
References: <20260320140315.979307-1-usama.arif@linux.dev>
 <20260320140315.979307-2-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260320140315.979307-2-usama.arif@linux.dev>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 292661C0007
X-Stat-Signature: ophecxz95sd1mb1qsirgagfymwnpcf57
X-Rspam-User: 
X-HE-Tag: 1774016814-3261
X-HE-Meta: U2FsdGVkX1+qElwCbj7EQecQwZkVUrs3FyBgtBt2yDXsKzg6JT0PROToHAVoaoghyVZHFaChhphdtCtp0bX14ZPxJ8jtsHNja4XXU9CvK2JBESGJX3OYqUTsEI2dT5mRS8DrW9s0Wk6sIviBi+DTFM2SK/PFoJHAhIYX3JLYViI49+JApGORtakFYcL4B4dx9GIB8p+a6VBysL+CN45Go7wEDVWIyaqKwJwfT//BotEf70QOVO8SbbJB41dScRQGfBA7hC1BZty0/dVVYb6J5OtW56RgCn/SCklfhkqSObGQMa14D4RlVSEP+ZAhIwS4QEdb/RylVtl2ks/2QBV7O+ImkzxT/EYA6BShoo3BJ2YWQtuNeFWoWosDOgBPFWC53czZcxkb7S552HwCWQ/YRxLkq04wL7UonznHwdZDOuH1wJrvo8YLeVO0QVAcUTOyZj/79lukE3CmSFyC3BHJBxtlaVUsDPoo+Il0pPnTszMICsFLEkVujGJIA3/nEezxecsCFr3ymXDEgfkX0nKjh0Qo8TTpdXbws+aIfwHDN3cbRuUBaAL0lS48nvxgyhoDzI+NboZ0b6fOk4BWF1ZvPHqwhlq4whLxPFSZH04cO/5LtOjF2WZxS4PTOEU9tZdYDUjdTVQKV0sFmFsDbfFakcQBpr8nrgiJWU32SS3RZgM62KVJy31Y5/uuDiJ1iO1mMw8hrERH6JIMNlpQxt8VGzqQuX8SXBpHPTbrV98iN7FkD5gih23FWVT05mZOMYpXQIOblLG86jvM2da0uTSxF/JO5wtIGUMHgoPTanCEnZsiU2NJFbDVqYcGgnEco4WBIm/FmqJ91qiZzRp093pkWTSwQUsH6XCH+6p1jpLgQnbAIPnExdL838LaDk5V/6hyA1GJFMT2ZicfJDJvQmBG/xqwYlkbr1EWJpMzbeuZ5kn0GNCK0di4lHuU9T2j8rcgM0ToO9CK7diKWXVu0us
 zK1eTEDd
 iiW7roJSCQ9MYfiM/UknDYXrNfY94tRXc3gwSuMDP2TDQVMWTwcTBEacDSJijW/GTjDmf/l6lcPGwwyrmdUlrrdDC8O7zWUbUg2hcPKxvUSFw4mdtBxsxr+VqB1Dm+Fprla/cA8ZG/8cpEJOMBPweH40jqLkP7sqsFY3RvZLfuRl6M8Qw6pkwxROgN/Vy8YQ194yQxh0/Vlu9AxBskgj+cIng1jeva+cBP9jjNaSRh80VgmVcZtDU26q65WnWGt8cw5vaup4rYZV4bzZ/TDJBmzNDFm4WcvFn3Qf/8accAWPaD+0io/0hiZmHCSQ1tUl5Xioz+IbNBOmzct3+a9NtxNKFl1PZzjyIPgoD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 20, 2026 at 06:58:51AM -0700, Usama Arif wrote:
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 6cd7974d4adab..7d89c6b384cc4 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -3331,7 +3331,7 @@ static struct file *do_sync_mmap_readahead(struct vm_fault *vmf)
>  		}
>  	}
>  
> -	if (!(vm_flags & VM_SEQ_READ)) {
> +	if (!(vm_flags & (VM_SEQ_READ | VM_EXEC))) {

Strictly speaking the fact that the file mapped as executable doesn't
mean we are serving instruction fetch page fault.

FAULT_FLAG_INSTRUCTION would be the signal, but it is only provided by
handful of architectures.

VM_EXEC is good enough proxy.

Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

