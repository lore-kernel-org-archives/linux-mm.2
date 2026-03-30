Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B4CB1061B05
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 14:41:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0FEC66B00A9; Mon, 30 Mar 2026 10:41:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0AFA76B00AA; Mon, 30 Mar 2026 10:41:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F07C36B00AB; Mon, 30 Mar 2026 10:41:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DF8036B00A9
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 10:41:40 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B37A613B345
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 14:41:40 +0000 (UTC)
X-FDA: 84602993160.27.4E470F4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 924361C0016
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 14:41:38 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="E/wQUhQb";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774881698; a=rsa-sha256;
	cv=none;
	b=AxuFuYedcSqvHX+hHrT1XSFs+W/50twp3NAdYhd4ZHqZUYBTWRiMLcCIyUxH7lajTMZWev
	HzdUkOk6k8AsNfP1hD0UV263VE6vJVGAKGNh2qaHlCHAkc2bF/LCtqSIhhH8EhTS2vpN6r
	K93GtaytsL3KOsp0SeG8uzO2TrFP3yo=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="E/wQUhQb";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774881698;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oR4aJHAX0zFPiy7Ebr56XFjWRoB4NdpweCLDlqMD7G0=;
	b=iVbMXC7jfT1p0kaHwXJPXJUTOilC5X8jCnLW2/evFlu0o+ibx8tYynG8jl2LPPbBcTSz7v
	/jotphb+nj0XATG9xgJWe49U85HD5fZGMfe646Z8pKih5T5O1fusUeR+WgXKiiXf/8K4Qj
	A7Cl/+tXPzUfrGVOBirtLRN0MNvtd+o=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A904543AF1;
	Mon, 30 Mar 2026 14:41:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A526C19423;
	Mon, 30 Mar 2026 14:41:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774881697;
	bh=q1b29V/4pBqAX8CvMK4aRNivkNTJ18eDUC9nnf6AzYc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=E/wQUhQbleB3IMASqvJCUU4R1GS/SMKx65uF/2+Nt2C1VB3w9Xho1geNlAPY1vdph
	 4dnpNCSgNk7TJNzcL2iGlX9nrkg8Tb/0mH7oqN8T1Ck4R9+k9Kl3h8RuSkLpuMGgMy
	 tEijami7egbnqUWtA/53DxBUuGJYG3AK7ycGJSs2LGSZEVH3eFspuOWTvMK0Sd3792
	 ATxPKiSqhVoBZdoEFFbPgkjFVELgozXwaDyNKvnP7V6I62bsqB7Lglq2QBPENqHogd
	 ydiR4NMLEp1j/jRLrtjvETBfach/i06tz6KpBangr49KEPrelKyTgAUNi0Izc5rU1F
	 BeY04sMB72PSw==
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfauth.phl.internal (Postfix) with ESMTP id 2D6B0F40070;
	Mon, 30 Mar 2026 10:41:36 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Mon, 30 Mar 2026 10:41:36 -0400
X-ME-Sender: <xms:oIvKacMH4pOUW8JXzjJVcV1JLzTY_4rDoT65o0x10z46C2K2JSs5iQ>
    <xme:oIvKaanQVUb7bHySeH3KuajIHPvb4CeD9IiHtDeY9rZMkNbzmFDV5YwyHXoa1GZ9G
    x_OjvKLyV3RmCnA4I3Fh57qch58qCAqtdTFoi46GQLS_79B9tcNRRo>
X-ME-Received: <xmr:oIvKaaq8KEaqXgMksQxNtNzuauD7tt-PlwwS868pJJ0CeXnge6oxIL3tPVU1dg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdeffeelvdehucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvg
    hrnhepueeijeeiffekheeffffftdekleefleehhfefhfduheejhedvffeluedvudefgfek
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepkhhirh
    hilhhlodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieduudeivdeiheeh
    qddvkeeggeegjedvkedqkhgrsheppehkvghrnhgvlhdrohhrghesshhhuhhtvghmohhvrd
    hnrghmvgdpnhgspghrtghpthhtohepheekpdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopehushgrmhgrrdgrrhhifheslhhinhhugidruggvvhdprhgtphhtthhopegrkhhpmh
    eslhhinhhugidqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtohepuggrvhhiuges
    khgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhjsheskhgvrhhnvghlrdhorhhgpdhrtg
    hpthhtohepfihilhhlhiesihhnfhhrrgguvggrugdrohhrghdprhgtphhtthhopehlihhn
    uhigqdhmmheskhhvrggtkhdrohhrghdprhgtphhtthhopehfvhgulhesghhoohhglhgvrd
    gtohhmpdhrtghpthhtohephhgrnhhnvghssegtmhhpgigthhhgrdhorhhgpdhrtghpthht
    oheprhhivghlsehsuhhrrhhivghlrdgtohhm
X-ME-Proxy: <xmx:oIvKafP9t2FsSI-ZdJ9ZVNXV5FpK1ku-TWrmAckhaNHLY6HFw3SpNw>
    <xmx:oIvKab8Hh6_7PeZedKLo1IrRiQRb0sN3lqFZqD3jayWAIdx6_5RZKQ>
    <xmx:oIvKaSjR6nXSb8o15Qfy00tBqI3goNQr7LPPAmFDKjADHeeZTucDUQ>
    <xmx:oIvKaerDRj-PItMlNiCaaZjsbVjD-mjCZevsuatZWZyJWu-aOeCeLg>
    <xmx:oIvKacM9haxG7npqDzzSIoNVqtGL8pCMFQrFUNHVYhBT0WFrlHw2iuvR>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 30 Mar 2026 10:41:35 -0400 (EDT)
Date: Mon, 30 Mar 2026 15:41:34 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@kernel.org, 
	Lorenzo Stoakes <ljs@kernel.org>, willy@infradead.org, linux-mm@kvack.org, fvdl@google.com, 
	hannes@cmpxchg.org, riel@surriel.com, shakeel.butt@linux.dev, baohua@kernel.org, 
	dev.jain@arm.com, baolin.wang@linux.alibaba.com, npache@redhat.com, 
	Liam.Howlett@oracle.com, ryan.roberts@arm.com, Vlastimil Babka <vbabka@kernel.org>, 
	lance.yang@linux.dev, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
	maddy@linux.ibm.com, mpe@ellerman.id.au, linuxppc-dev@lists.ozlabs.org, 
	hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com, 
	borntraeger@linux.ibm.com, svens@linux.ibm.com, linux-s390@vger.kernel.org
Subject: Re: [v3 16/24] mm: huge_mm: Make sure all split_huge_pmd calls are
 checked
Message-ID: <acqLbkH_aN6aeZXN@thinkstation>
References: <20260327021403.214713-1-usama.arif@linux.dev>
 <20260327021403.214713-17-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260327021403.214713-17-usama.arif@linux.dev>
X-Stat-Signature: qy1tgbkj9mcw7hdhot6t8m5rknqn51me
X-Rspamd-Queue-Id: 924361C0016
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774881698-128596
X-HE-Meta: U2FsdGVkX18Tx6w/xx6JCZKCHhrbFUno2PdcunD3HGrq887wTTTjUCbs8rl4xVewGXAXkCmk+qQEjf93aTsLDYOdQsEiTEC5DO0nBzt+S+DPDOQZaZlgQfGxS47wB+tvAfVSxMNIffDMw/5KnGvZ/PyUOlIUo6/luFIaNsrVyzejsdUujBCS/14YD+Lq2ctdoJ42dTmWdpxlQVJ+xnWN4hHXjn2seIhbIzlzRAUDQITS4ptj8OW2/e/GBbnjCkQKv25vdvL/tIEtE3guyxjrw4W/FeuJjpMzYYLkOXpjaiOs6+bV6vupSKGnztOLZOnupSoKBIV9ls7qMsm5PSQFNdtcdRQxb5NuYw01CJ+Rqh/4A1q56SdDC8jTxyj5kgIXOY8OMGyHek1vSnQM/P/4wDbgAa+OW1rgN01L1QAhEhcPtX+4EoxM2Mhr1E/L33Qqi+sZtvJhiukHbiFI3gmGNIAnSK3gw/0yG399IAQjYAZKDS2EV97acp1uAW/IWk0WFz2d34j3zoN3d64JbdZTIs4Vs+77oHT3tf3RdvCLNCNt5h6yFmaEiwp84OMKbQWq8OMeCRixToIxHvOXLiangM383FSIS6au5jpe4w3fgWEAov5tORn1tuRyzjsc5BMU226Dtgx9d1m0MXWFNMawkeNA+b/meuf6y/kEVG3jDA+j6SsKumTdAxdkjYYLBGRQD94drj0zI4kBlO0oGDTuLt0mdrB2c9RrR6mZFNzM5fLzAnVJBx54V98wPJ9xIHSBsTno6P6L7ilqOCJJgpXzifN9vXbo15lT59p38D7jFm79qtAu6QRB5JWWAMyB98R18aUvmEcysBQloiTX29bJptDAQk52MkA9/fsmULzMLrLJph8a1sTr2PMm284vqEomEPFZaeS8BArDnq5tIkpiEa3C4rzEPjThnUnLJdN7rxNlwiJesRixgapo4kPIXfJmiVnKgzc0fF3j6l+gWVk
 iNkB5oxd
 m85NRmyuB1YKxtJwUfsKDmsfHomXKHGvC/sTceikvN7vJ5IBKA+ClYhxmYtyU2n3gZKSuwyXcyjADkBbhSgI+rG6IDzefkB+6KnSw6HzGdjT7KOJzlFTu0ACQ3tEkrlsF4UjHsDi2q/Uiz/+qmxmbhUFPsIyf7oUngL58BufIutd8KZXDAFfll7IQRRSh26NytLlJNa2et92+2//T1OLw8nZ2VTqDWs3c/Qk4WUBqki3SAuSnNR9TN+NyWDF3nDZKrWnoj0UibhrnbHCRo9qxfLfdxnClQZhmeBH4vMNG8NH86QRir+1Quu2xFSjwlN6FiY2VEWdC2aik/BQ68vG6dt92S6DY5EMnuaUI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 26, 2026 at 07:08:58PM -0700, Usama Arif wrote:
> Mark __split_huge_pmd(), split_huge_pmd() and split_huge_pmd_address()
> with __must_check so the compiler warns if any caller ignores the return
> value. Not checking return value and operating on the basis that the pmd
> is split could result in a kernel bug. The possibility of an order-0
> allocation failing for page table allocation is very low, but it should
> be handled correctly.

I think we want the same __must_check annotation on stubs for CONFIG_THP=n.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

