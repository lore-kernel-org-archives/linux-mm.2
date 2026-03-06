Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA6ACFCB61C
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 15:55:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 309BA6B009E; Fri,  6 Mar 2026 10:55:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E7596B00A1; Fri,  6 Mar 2026 10:55:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 206896B00A2; Fri,  6 Mar 2026 10:55:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0DB0E6B009E
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 10:55:58 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A274D59A14
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 15:55:57 +0000 (UTC)
X-FDA: 84516089154.26.0C9D77D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 855591C000A
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 15:55:55 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="RyGMNP/h";
	spf=pass (imf18.hostedemail.com: domain of ardb@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ardb@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772812555;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wjJHTB1nSCdbU3D3wUiG4O5Zgs73eB+V702/boHfWTM=;
	b=Dk4m2OMwBW1HVm5iaqaurd+PIMVEFDpaMoEn1mylukKaRj5zppCSKAUTBzCsfW30F3WuiL
	ca5AbcKhzP3meMr7azkxhzMnBErTA2AZ3M3gHkuFC01Me2b4jxyjBa/6ccLCbIVQB4P+Ai
	9tTSXLRtgOEYdeYzZCSGDlZU7bri3zI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="RyGMNP/h";
	spf=pass (imf18.hostedemail.com: domain of ardb@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ardb@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772812555; a=rsa-sha256;
	cv=none;
	b=XxVt79nVYWIIrCFL73a6Vrp9TnFOFO0RoIQxLRSNiBXTqGEF2No3K0HsCf4Hw24xkltxH3
	6MQWLgloFtzdCp4bEmaAiDLDjHhXuOUZuiNiUVtxsbB9s+dbgruLE5VrvzYy41ORSUyS8l
	X0W4Wl5CAVruMZVmM3tV6d9GaKYPHkc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8F51B40AD0;
	Fri,  6 Mar 2026 15:55:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D7A9C2BC86;
	Fri,  6 Mar 2026 15:55:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772812554;
	bh=ZQ76liIW6E6i1/b3A1a2pPbDIjkLjWQN5mm1jo1jI5I=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
	b=RyGMNP/hk1TAg8aHgD4A+bD+/1kbYrNphSFQIsoLmsaxxOS1suF3QL6RzP7cKP5FT
	 mrb7Aqt5OCAUcQ+NY4Pr1GF3SWjBQkJ/yiIsDKNkTTSTFAoJ5q16aUHEjgFh6d3ZXi
	 ZLMi4jidLzMEj+R65YO4MdsXjUUwU/LlYv6Z5eQoBOFXYDLtEOpkKt/O48h1Bz0JzY
	 LUjXJft3011mUscCtiejCwH2c61BBUFf5y/PXTt+gPCVKM0DGRtK27+hwp1T1vpK1J
	 Jq/fU3uJoI6RlfhuTitw8djWNvyz2ZoNLoYY7T2fKvqdmD/h9wvcAS8wjIjEIylBrT
	 n+0mXm/OvTJPQ==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 10D63F4006A;
	Fri,  6 Mar 2026 10:55:53 -0500 (EST)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-01.internal (MEProxy); Fri, 06 Mar 2026 10:55:53 -0500
X-ME-Sender: <xms:CPmqaevDFTTP5tP-wAr6rloDUR4mtfLUIgNoAesRCcQWo328495YkQ>
    <xme:CPmqaeRgfP1dvMyKfmfUaMpRNipHYWRMMyw8NI7edldaxtQpi9Zxv66kG7rWUJMLp
    ilhbcUsrnQSYiygYZ3NKGi7HbW_Le5cWSDvjbr1kAJUqKniOf2U8wk>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvieeljedtucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepofggfffhvfevkfgjfhfutgfgsehtjeertdertddtnecuhfhrohhmpedftehrugcu
    uehivghshhgvuhhvvghlfdcuoegrrhgusgeskhgvrhhnvghlrdhorhhgqeenucggtffrrg
    htthgvrhhnpedvueehiedtvedtleekuddutefgffdtleetfeetveejveejieehfefhjeei
    jeefudenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    grrhguodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieejtdehtddtjeel
    qdeffedvudeigeduhedqrghruggspeepkhgvrhhnvghlrdhorhhgseifohhrkhhofhgrrh
    gurdgtohhmpdhnsggprhgtphhtthhopedufedpmhhouggvpehsmhhtphhouhhtpdhrtghp
    thhtohepsghpsegrlhhivghnkedruggvpdhrtghpthhtohepsggvnhhhsehkvghrnhgvlh
    drtghrrghshhhinhhgrdhorhhgpdhrtghpthhtoheprhhpphhtsehkvghrnhgvlhdrohhr
    ghdprhgtphhtthhopehtghhlgieskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepgiekie
    eskhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqmhhmsehkvhgrtghkrdho
    rhhgpdhrtghpthhtohepihhlihgrshdrrghprghlohguihhmrghssehlihhnrghrohdroh
    hrghdprhgtphhtthhopegurghvvgdrhhgrnhhsvghnsehlihhnuhigrdhinhhtvghlrdgt
    ohhmpdhrtghpthhtohepmhhinhhgohesrhgvughhrghtrdgtohhm
X-ME-Proxy: <xmx:CfmqaXmJAOECBW03bGl-aJclbL81Cjd1WknFsjv9UiWUoF1rOrkfnw>
    <xmx:CfmqaaZ9Z5C9Iy8DDgF-BoKLc2AL3866rZ7jbX77zXjX3DPk_-jVqg>
    <xmx:CfmqaR83dyL7YMWqho8yGfa46BcO_JPgLKX9xWA3bbQmU7eqGIgZgA>
    <xmx:CfmqaSHSvLtI6xfbVh_u5N_XjrMRIsuo-yIAnjHS5OwtYANGP6tLNQ>
    <xmx:CfmqaTevVisFxupb-2nmu75yBQXy_NbcfHBnC1mb2nAvTiVxHv_Pap6D>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id DBBEE700065; Fri,  6 Mar 2026 10:55:52 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
MIME-Version: 1.0
X-ThreadId: AusYBuezkfp3
Date: Fri, 06 Mar 2026 16:55:32 +0100
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Mike Rapoport" <rppt@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
 "Benjamin Herrenschmidt" <benh@kernel.crashing.org>,
 "Borislav Petkov" <bp@alien8.de>,
 "Dave Hansen" <dave.hansen@linux.intel.com>,
 "Ilias Apalodimas" <ilias.apalodimas@linaro.org>,
 "Ingo Molnar" <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>,
 "Thomas Gleixner" <tglx@kernel.org>, linux-efi@vger.kernel.org,
 linux-mm@kvack.org, stable@vger.kernel.org
Message-Id: <132771ba-c5e4-4fc0-82a8-0d681fb6eae9@app.fastmail.com>
In-Reply-To: <aar4wRh3TRm1m0HJ@kernel.org>
References: <20260225065555.2471844-1-rppt@kernel.org>
 <7e4f6a4b-fe41-482d-a4cd-5a059e1626e6@app.fastmail.com>
 <aar4wRh3TRm1m0HJ@kernel.org>
Subject: Re: [PATCH v2] x86/efi: defer freeing of boot services memory
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 855591C000A
X-Stat-Signature: cpy7r7q3ew14ch7f415ikz5ieo3ieqmd
X-Rspam-User: 
X-HE-Tag: 1772812555-702478
X-HE-Meta: U2FsdGVkX1+wAQL2pgmr+r3nxFvZ4LBMbjzHzW40rEn3wT8GAZGt8yVq51nLjEvhdK4qj9uTU+WnJ4jLChwTn1hKnbmmiwyR987WKilelgsCRQljJgHjSlTqSLdb2wXcfJG5/qreXjgDqXG5q5DpZF9tuUK8y46KSoq5mF7o0dffZho0DzBwVnkB1Xcr+STNum76Z1QcQuS61CsiWMq1b90EV08ie42tnE9CTuc/IUqvXO3mI0eMEcXkfrf+B01vMt1p8EgkhRm/wFtJL3YvCKLpnTYTsj+iHNbHDo1HNIHIOWCqoWDrfhbLfuvGlmrO9E6cJvAWGtO1/1AG8Cm1V/Lklr+9Ga3jlTT0koRBVsn3lx2CrgDvQWRSWJSm7PH7Uwpn3+9CrIobFAXl0Njeh+D0JNQg1TBs1CBO+AqEiWjCMZxUk8yerVcI704FJZS4rtUzXOTL4NjRN/9dXGb6epeIik0Vt5A3ThVhRLT2ab0ZAFOXpj5GjMFtvXhn61oM0Y4LyaMvMMEIhng8+xLtD46OgJmUkCUvE9cchvveieY0leoUjy+CbiD+RHg1ykD3sKOfgbP1vGsEDBj/fyqRSOvpZwwZn050twftOj5W9l+6o9WeFpr6s8l+Bp751gKHcFXYN3JLtbjxLq0dAOTpQo9D0m9v0yS6lL7EsHFSYvH7YTnyl2+09eu0xQo1b3By2h0QWSEtsFxH+PaV5Yoo7UBRaQa6rGWeTV8mNs56cw7PpfibTINQaQ8AX6/SmsfL3KwiM396pjpxObzv/GSbKJuGecqHDjTQ7ZBMMkvLq8b4Z8U2afa0d4XztCBMKzOeEJlLipu61agoLdTummaRgBZZ7uRG3fl+0fb+/CnDR6W7NYBNN9ycUfnXSog+fKMtWgtmLNITwby8QJquAK7BxIbvx8TOxrBUZMEEmrQPLXYsByTkG/c11ptD0AOMbcA+OxVk0kZpVne1Mq8exu5
 fNMWLh30
 l8J5I264tBIk/G4A8mD3b0BxMIukRcrqxtM5FJpaCZqv5CLy8OmWdGOi+1HDsgiYOy8yPchPcShoHgelOf11vIjHKiLsr8DZweiaVF43kFkuI94Waxty6n0q1qShCr6vW/xtEzcnx+R3VfzrpiKBsdxUDmzhsklaIVKRol5XrNw2rb8Wmzb0+VPjN7TkxBoYFaa/5Lo5xZZ98S5EBuNBFKho7ckeEVEgbTCFS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On Fri, 6 Mar 2026, at 16:54, Mike Rapoport wrote:
> On Thu, Mar 05, 2026 at 12:11:12PM +0100, Ard Biesheuvel wrote:
>> 
>> On Wed, 25 Feb 2026, at 07:55, Mike Rapoport wrote:
>> > From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
>> >
>> > efi_free_boot_services() frees memory occupied by EFI_BOOT_SERVICES_CODE
>> > and EFI_BOOT_SERVICES_DATA using memblock_free_late().
>> >
>> > There are two issue with that: memblock_free_late() should be used for
>> > memory allocated with memblock_alloc() while the memory reserved with
>> > memblock_reserve() should be freed with free_reserved_area().
>> >
>> > More acutely, with CONFIG_DEFERRED_STRUCT_PAGE_INIT=y
>> > efi_free_boot_services() is called before deferred initialization of the
>> > memory map is complete.
>> >
>> > Benjamin Herrenschmidt reports that this causes a leak of ~140MB of
>> > RAM on EC2 t3a.nano instances which only have 512MB or RAM.
>> >
>> 
>> Putting a fixes tag referencing a patch that dates back to 2011 doesn't
>> seem that useful here. Is this really an issue that goes all the way
>> back? Or did a later change trigger the actual leak?
>
> You are right, the leak was triggered later by addition of deferred
> initialization of struct pages which is about 4.2 time.
>
> So fixes tag is wrong indeed, but all the currently maintained stable
> versions are affected.
>

Fair enough. It's already in -next so I will just leave it as is.


