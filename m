Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 827D6E68165
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 10:58:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9FC3A6B0005; Tue, 17 Feb 2026 05:58:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A7196B0089; Tue, 17 Feb 2026 05:58:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89C2F6B008A; Tue, 17 Feb 2026 05:58:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7682C6B0005
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 05:58:28 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1B076140539
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 10:58:28 +0000 (UTC)
X-FDA: 84453649896.05.BD8CFD2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 193DB1C0010
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 10:58:25 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=McbP35il;
	spf=pass (imf21.hostedemail.com: domain of ardb@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ardb@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771325906;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=536n0c0WK8TV8n3NhJfUfMEKwFXDhSVo71dVdQ8dKkM=;
	b=rHVGqJ3j/1eSHDODsA+USkqC8hRjntbKts/WiI22/5CsFvJEvx4eI5UNTvDQDUl51H/t/4
	sl4d61U/cXmNyAIrZZeimuFc8XrP1Exgyr7j3IZNE9DCUJVNKQ3iBiS9W/vsqqJSjvjdqD
	jg/0LHw+XLyc05zyrzaqptKM+TUr7Hc=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=McbP35il;
	spf=pass (imf21.hostedemail.com: domain of ardb@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ardb@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771325906; a=rsa-sha256;
	cv=none;
	b=rmbCp5tf4wLhPetTmh+u7HST5fBAE+5pUxvjHFY+VKuLT16R+f33MbnjXNgpjQqDx2gDl9
	AiNN6oDYKag8rBCL3RJ6KQ8ahgyETc/TF9ywGIFgY30K/B/vwWV00oeNbhkx/gjkr5YC0r
	lvkINVIurgf2UOHv7ahb9ekw2I73mKY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5B4D760128;
	Tue, 17 Feb 2026 10:58:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BEE3C4CEF7;
	Tue, 17 Feb 2026 10:58:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771325905;
	bh=ryxJBBu02okjtlGFLoujN0OXwkvCKzYbVblj4RXti9c=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
	b=McbP35ilSo+pn6ro/ZqNpGKA3cA3yoFeWTpIYszQyGdBr58cUt9eVIjWk5WQLQwGq
	 PAMj39TKpLk6Ie1hojO/hNMZSEQJIvazyxMZmBeXRR96qSDDiW3wXvnEKs88X4TcdK
	 pu9+amh1Zu0HkJVrsVBxfujooMGZ0it/hFdelBOM7i1HDL7YcM6cq7iBOm10Mcao5q
	 3GzS/H3Zd0lRrIWjenrjq4yiDVAtldEWxsPsFAvoRTUpIExNeH027vCL+dGI+kIq4d
	 Tm9ozyfQl+dMKyQxyinfAtbwRxmo59eRz2/NTifaw/Ic4olEKxQuc/OzLZDrYRxT5H
	 aazG13EqmleBQ==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 7B5BCF4006A;
	Tue, 17 Feb 2026 05:58:23 -0500 (EST)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-01.internal (MEProxy); Tue, 17 Feb 2026 05:58:23 -0500
X-ME-Sender: <xms:z0mUaTx8RQ093bum1HHtbue6fuBlrCWKODCeN5bPEyLPVmhDwwyHtQ>
    <xme:z0mUaWGhEn8O4WE0Z2PnRMvJJyfhNCdD6VVhQuyJRBQRyLb1imYvpqnebUkxhIlPs
    xNbNjFxbgb3H86EHUJzuFEZMWkNXctbAKEANNC5JHw0uRwtIE5Hd8c>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvudelheekucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepofggfffhvfevkfgjfhfutgfgsehtjeertdertddtnecuhfhrohhmpedftehrugcu
    uehivghshhgvuhhvvghlfdcuoegrrhgusgeskhgvrhhnvghlrdhorhhgqeenucggtffrrg
    htthgvrhhnpedvueehiedtvedtleekuddutefgffdtleetfeetveejveejieehfefhjeei
    jeefudenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    grrhguodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieejtdehtddtjeel
    qdeffedvudeigeduhedqrghruggspeepkhgvrhhnvghlrdhorhhgseifohhrkhhofhgrrh
    gurdgtohhmpdhnsggprhgtphhtthhopeduvddpmhhouggvpehsmhhtphhouhhtpdhrtghp
    thhtohepsghpsegrlhhivghnkedruggvpdhrtghpthhtohepthhhohhmrghsrdhlvghnug
    grtghkhiesrghmugdrtghomhdprhgtphhtthhopehmshesvggughgvlhgvshhsrdhshihs
    thgvmhhspdhrtghpthhtohepkhgrsheskhgvrhhnvghlrdhorhhgpdhrtghpthhtoheprh
    hpphhtsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehtghhlgieskhgvrhhnvghlrdho
    rhhgpdhrtghpthhtohepgiekieeskhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinh
    hugidqmhhmsehkvhgrtghkrdhorhhgpdhrtghpthhtohepuggrvhgvrdhhrghnshgvnhes
    lhhinhhugidrihhnthgvlhdrtghomh
X-ME-Proxy: <xmx:z0mUaXuQoKtBWIPfbLc8JNg_ziG9IGFD3TnvomCiCbY_wBSPnZ_xWQ>
    <xmx:z0mUae2E-oLPhhy3l-GkLawjqRJIFreZOjovOz6xAW-QQAVU3WCq6g>
    <xmx:z0mUaXCog2WQPeEL6xcsnVd9C3kvvY6Ghggh0Jwo9Fc0X-W25Nu_6Q>
    <xmx:z0mUaUD3EE-U2diFt7CEbtMGqP1D1vv52vgE-sneYLZn_B5LhdXEvQ>
    <xmx:z0mUaQnRRvCWaFUp19H8OzJHnVJMhXIW6TOfmqkW0BfZ9ZutmK0cM1br>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 5C4B5700065; Tue, 17 Feb 2026 05:58:23 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
MIME-Version: 1.0
X-ThreadId: AvPcN72_GPoV
Date: Tue, 17 Feb 2026 11:58:03 +0100
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
 "Thomas Gleixner" <tglx@kernel.org>, "Ingo Molnar" <mingo@redhat.com>,
 "Borislav Petkov" <bp@alien8.de>,
 "Dave Hansen" <dave.hansen@linux.intel.com>,
 "Tom Lendacky" <thomas.lendacky@amd.com>
Cc: x86@kernel.org, linux-efi@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, "Moritz Sanft" <ms@edgeless.systems>,
 "Mike Rapoport" <rppt@kernel.org>
Message-Id: <42bdc4c5-9d9f-49e4-8bee-75633c987500@app.fastmail.com>
In-Reply-To: <20260217104957.249340-1-kas@kernel.org>
References: <20260217104957.249340-1-kas@kernel.org>
Subject: Re: [PATCHv2 0/2] efi: Fix alignenment issues in unaccepted memory code
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Stat-Signature: b3kt8mmyaygrk44m5y8ewxdkfe63zfbr
X-Rspamd-Queue-Id: 193DB1C0010
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1771325905-633967
X-HE-Meta: U2FsdGVkX1958E+1goKoWPjDEY9i/wx/Fh++2QceOrrMLhah2E8Cn7gLV5YQGMtZcZlBy+DFwT8ayiMjLMPzgAEb31o23X1He9lwNPYS7ccn6Lubvl/Dly3ckGJJULzZUVahfqgsLTL5pQ5x87C3A6DxDcyai2sdu4ABIQ/fbe6zsqak2oNkMhZcjK50ihV6SilaY15BQ2WO0MesEE+rxQ7kzlmh85lOO9O8+Bik1FRxEbqWd0m+zrOXCBR8btpJGltxuLcj3YApp+ZKL4NgHsgUIXWaJlIWPF7rCkxZgKPv7NXqYNpUyEpY88EgLjeigrZhoyiugrgXAK3LefDlyZptQRB+EpWZk243Hn17tiMlwBwQLGdV0t+1HjxR1jaQ8ygOKgSmLikKMo9jFv9Orem/NWNnLKi2oYPhLCsCUvBWTRGuwGI1DR5SBRFpnEQZo9FomiwHIEMwqUMaEiW6G6BPchpbMixaqVjW+tyj8usjfo2MfD8VrXJArazV7TizLZdtIGQAaTFDi3tIaNP6VfaaSNnwHSXPHvrIFgzlXeGB0ZNEKIdG09wXUwiyl81j/jNNvGliGIsZNqspKUeUj15OzBE1EG8pxRHqc3YTxLp+yGhso+AabclUoyWR9A2hTjDL0P6rR7NgFzN0UqSdUc12jfOFSufMvtIw5UrjAJiLbT2E2rL5pFUQZmBhT8GkaTJePnpxksOfzDRSFoCDgOlpjalhwIXrQfZJtNIwE1b1BU2SKy+zi8RL7a3txSTi/m+iIdY8YqFC+mFd0X468pnsHTUIRmmvxyckejP01caj5ZpZvrQx0r8xhJlhVDQd3X8z+k7fhw2U9FHApJB7BDFTxKUPFmbk55gdA8cCP8X1ztpOXmnldJ6pMEK0Kl5FqLLHTmbLTlmQ63OsIhEhHGEIHlQ+x5qSgfJ4eBLTRHXO3tB4moZiJz4qBo0u9GwbnYp4RiQ7mHhOEvk07ew
 /c/vKcw2
 hKmWTSx6iI6bpHAkbj5XdqKJ7F9IW/QBj/X16HSakL9UiaSQumuqhNH4fHzjWgzqXNm5WwdngvoUMfGcAefEEby1Sw603IoQ76f8yac7Ieb6i5zhGblUBkeGxpnDIB5S40HXJJYUqyCM9lYHNW75vtXeL140AuH2a00Rbvll4+Cd3LEV2YzISSiDYdcNA9+7RucuF
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On Tue, 17 Feb 2026, at 11:49, Kiryl Shutsemau (Meta) wrote:
> This series addresses two issues related to unaligned physical addresses
> and sizes when handling EFI unaccepted memory. These issues were
> identified as potential sources of kernel panics in Intel TDX
> environments due to incomplete memory reservation or missing "guard page"
> extensions.
>
> The first patch fixes the reservation of the unaccepted memory table
> itself in efi_config_parse_tables(). It ensures the entire page range
> covering the table is reserved even if the table doesn't start on a
> page boundary.
>
> The second patch ensures that memory acceptance requests in
> accept_memory() and range_contains_unaccepted_memory() are page-aligned
> before performing the unit_size alignment check. This prevents skipping
> the necessary "guard page" extension for unaligned ranges, which is
> required to avoid crashes with load_unaligned_zeropad().
>
> v2:
>  - Fix 'end' calculation in the second patch (Tom)
>
> Kiryl Shutsemau (Meta) (2):
>   efi: Fix reservation of unaccepted memory table
>   efi: Align unaccepted memory range to page boundary
>
>  drivers/firmware/efi/efi.c               |  8 ++++----
>  drivers/firmware/efi/unaccepted_memory.c | 10 ++++++++--
>  2 files changed, 12 insertions(+), 6 deletions(-)
>

This looks fine to me. If other folks are happy too, I'll queue it up and get it to Linus by the end of the week.

