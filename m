Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 729D0EA4FA0
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 11:17:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF6506B008A; Mon, 23 Feb 2026 06:17:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA3D46B008C; Mon, 23 Feb 2026 06:17:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB0A36B0092; Mon, 23 Feb 2026 06:17:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A8C1C6B008A
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 06:17:49 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3F514C2C5E
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 11:17:49 +0000 (UTC)
X-FDA: 84475471458.24.C5D0593
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 4AA181C000B
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 11:17:47 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=T+ZmlUzd;
	spf=pass (imf21.hostedemail.com: domain of ardb@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ardb@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771845467; a=rsa-sha256;
	cv=none;
	b=YYRVqC8xXav4MW6QWNT5mETP1ftCiuEQr6DJR/C0Q+bD3Dydg3h8sSOARKtN8KjoNQSx6w
	i1l41JEvBxuoR1hICIpBumqHujQRJOrVbToTxLfK4+mZ5DUzrEFDZuEEQk7Yb/Ib2Y+W0e
	5QNKduST16RqvGjGyXz/UheuR2o04Is=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=T+ZmlUzd;
	spf=pass (imf21.hostedemail.com: domain of ardb@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ardb@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771845467;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E9Q6Q8veWSTYguy8aQ+tHLIaffULJwBQHx4dUobDY3Y=;
	b=G1NiCMqRoF2Gv9TgshJnVKX5oOnEq26mC33Fjp0lxxrj8v0nYG/G543lZbchelNtzTn3GU
	gIe1aCmVEOJYh867g18BuhCs3YSvXfEabgmUaMiqQDYUi/vszwCGP8FimARmH1SNKJqkVX
	TK9G9aA7CfYFSRYElrEdzSk88yldWWA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B31E060097;
	Mon, 23 Feb 2026 11:17:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D0BEC4AF0B;
	Mon, 23 Feb 2026 11:17:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771845466;
	bh=h3K7cndj4kG1iv/vNT+K90U40QryseuSg7TrHfv0p5c=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
	b=T+ZmlUzdf/h04LkbcDyxLGknTACoTYpcBLRrq+sOPTe6NUCPhryfL6eXp5Hn6pCsO
	 nKNDe1r2hj4mnJ9NUrjpwNSWDTDw5jZwBlM9U2Q/6ISA+C+v2hC4Bcjz6cf9pvxBUM
	 LXpnVd0pHPSa+la12I8raghU+w28gd9gGhov8QEX2L/8ZJGd4aiCyQnmvZABfxPUwJ
	 VQ531qrtYP4Egn+ksVB9UpHf7XMnci4saRnPBfD73m54Mk2xNjA+80PfF++ZlmPmWy
	 bRRscgI67Dihof6svyTtwqSk8PNXuZcLVCbhkaqftqvAPOTfchQzsL9azgDOtVXod8
	 rXpPPAPZY+rbQ==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 31E4BF4006B;
	Mon, 23 Feb 2026 06:17:45 -0500 (EST)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-01.internal (MEProxy); Mon, 23 Feb 2026 06:17:45 -0500
X-ME-Sender: <xms:WTecaZgA8AvZpn8eSULqZP9B7hCd7CRFOEns11LlNWohktnXoMbOcA>
    <xme:WTecaY2kZ-2lmI20rnAEUoPb7QkSU5zjaEY_sl3GTW_KcWXU5S7tgYdQw55sMX33n
    dP1_pNudIjm1DTEWgLI0PjXNoUFeqRWy9y_hhgoYoxn7XHk8rQi3Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvfeejtdelucetufdoteggodetrf
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
X-ME-Proxy: <xmx:WTecaU4kQ0Cm_b0_Li1sUA8NmJUle7HisuUZoKxwRtcxYryS4qpbeg>
    <xmx:WTecaVfIOmmR7JPM3JsNK75dtyEvFNW7fuTIZneToo94Sz5oRuQ2iw>
    <xmx:WTecaXwKtaKlcxBU5OxWcGeOn6GnrikiNIKmx_O73BAxMHvQtLW2tw>
    <xmx:WTecabpesWExFjmzzZts0Pp847SBQBpJXbYWZxD5rZt6c_m0IblPfw>
    <xmx:WTecaVwC1NV6aDi1xwqlurWiCkmGRBHl52XU9LP7KjPnI438uye4kjw5>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 0D441700065; Mon, 23 Feb 2026 06:17:45 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
MIME-Version: 1.0
X-ThreadId: AF0NZ4OlJH_7
Date: Mon, 23 Feb 2026 12:17:22 +0100
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
Message-Id: <e2ad0845-2f87-418a-9f87-5ce619e004ef@app.fastmail.com>
In-Reply-To: <aZwyNAbEqb8ZwLUM@kernel.org>
References: <20260223075219.2348035-1-rppt@kernel.org>
 <b6f4edf5-7587-45d7-b81a-590d4f3d1ddd@app.fastmail.com>
 <aZwyNAbEqb8ZwLUM@kernel.org>
Subject: Re: [PATCH] x86/efi: defer freeing of boot services memory
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 4AA181C000B
X-Stat-Signature: tkjggfs14qkjyhkjjpoykhqucz8b16gm
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1771845467-710944
X-HE-Meta: U2FsdGVkX19iZV/fN20lNtq39m6HAdJC12ieK3GS3CWZKaOB+611FO0H73Q39Y/6a997nivmRYsTo1LPhvb6J8LklqR06YzodHZyVBPu9GQ3MhcF+6+wFK0CJc0FGPWtCI+aBg9r3YFNexIE1Ymu+MtG6b1+V/iaqmyfuhZ4dSNFw7oyhe8acueEF7pg/E7l+LQ5t/KdLmRWp6uYas+gCfj0PDAeLz4OMrjHIvj/tLk2YDjN3cBAQUPbT1vYMwDSHBdb8SN+eBoWDVfEMePKi29/0917o5HTm6w6tOFVBgAYuGim8pE4JMF4U94CmZSMxQTUcF/3Vsj1NnEkPltg+yAckz2/U5FVWAsvRvRPUS5QKlHr8qkG3Bu7rjR92ObORKwMgxRP+lvi5OyoN+zT7q0nJomyMcMI8IO9mixK6ZL+43qIa+f3YrE1h9mIcQunfAW2P1XMtJRCeLBlh78jgTuV0M6j2kH2ETc/RfmHsRucjNSEaE6PjMJgi0FXynqQwAeIacBnFrCc0HHua2VlY/q75yvfGkI3Rmg15UV0SBbpVWgXtRBxJ7TC53N+H+QRDDUtBfZB5jSSz1u4uRcqFPB/EhYlIq3gPbCGulrpeG5E3QZZ2/I9nuPsrSVQjKL8sl8Okk5kV6kY1TFiJDFYNwB2bqA0rj9e3N2FniOWXP6RAQ0w2afSlmzQmx8XRUhzTTAsEre7WqFphMSN0zfUra+qSjbobSgXDXgdL2cQAAPsZ4Ll55LNQT0xB1DHfawCz+OHgFnkjqoaZRFzk5bI1iR5XUhd+2jAB8cW3gZHk6yqnyUIEmOe7CSJU9rYKpX7pKRTycLa9oH/W4dFruxFE22P2Ow1xi9VbvVEGeD4WKXWN4pWhEWJCFw/Llhv+YjdUNxAHflwmwi9eF/5DhZyYCGl0gKjdskpbYRfdK67S8AWIk49SL5Eo8jx07e3wZIGMP3kBBm/cBRVlr6FeNb
 gprNYfhi
 AevhSUukg+q08EieM2NxD7tEKv4MseOBSSTY+dkMlXaakYrGOMxk4AYEkP+dkYjevZIexWQmJsEvE7LGHZYQNSj+k3c+awUrjOkK9WXLRRjiDxGuRFF1d3JzShd73b0vtLiwl9xx+48CSrfJ/pA4pEDgpQ0iAmJGmM49Cp2r+jE/CCDP/ii4vg32xPOQZn1dUjigOZ+3mq1P41NFX6puXWQ5m+A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On Mon, 23 Feb 2026, at 11:55, Mike Rapoport wrote:
> Hi Ard,
>
> On Mon, Feb 23, 2026 at 09:08:29AM +0100, Ard Biesheuvel wrote:
>> Hi Mike,
>> 
>> On Mon, 23 Feb 2026, at 08:52, Mike Rapoport wrote:
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
>> > If the freed memory resides in the areas that memory map for them is
>> > still uninitialized, they won't be actually freed because
>> > memblock_free_late() calls memblock_free_pages() and the latter skips
>> > uninitialized pages.
>> >
>> > Using free_reserved_area() at this point is also problematic because
>> > __free_page() accesses the buddy of the freed page and that again might
>> > end up in uninitialized part of the memory map.
>> >
>> > Delaying the entire efi_free_boot_services() could be problematic
>> > because in addition to freeing boot services memory it updates
>> > efi.memmap without any synchronization and that's undesirable late in
>> > boot when there is concurrency.
>> >
>> > More robust approach is to only defer freeing of the EFI boot services
>> > memory.
>> >
>> > Make efi_free_boot_services() collect ranges that should be freed into
>> > an array and add an initcall efi_free_boot_services_memory() that walks
>> > that array and actually frees the memory using free_reserved_area().
>> >
>> 
>> Instead of creating another table, could we just traverse the EFI memory
>> map again in the arch_initcall(), and free all boot services code/data
>> above 1M with EFI_MEMORY_RUNTIME cleared ?
> 
> Currently efi_free_boot_services() unmaps all boot services code/data with
> EFI_MEMORY_RUNTIME cleared and removes them from the efi.memmap.
>

Ah yes, I failed to spot that those entries are long gone by initcall time. Other architectures don't touch the EFI memory map at all, but x86 mangles it beyond recognition :-)

> I wasn't sure it's Ok to only unmap them, but leave in efi.memmap, that's
> why I didn't use the existing EFI memory map.
>
> Now thinking about it, if the unmapping can happen later, maybe we'll just
> move the entire efi_free_boot_services() to an initcall?
>

As long as it is pre-SMP, as that code also contains a quirk to allocate the real mode trampoline if all memory below 1 MB is used for boot services.

But actually, that should be a separate quirk to begin with, rather than being integrated into an unrelated function that happens to iterate over the boot services regions. The only problem, I guess, is that memblock_reserve()'ing that sub-1MB region in the old location in the ordinary way would cause it to be freed again in the initcall?

But yes, in general I think it is fine to unmap those regions from the EFI page tables during an initcall.








