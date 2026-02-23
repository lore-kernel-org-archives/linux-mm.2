Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6811EA4FB5
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 12:19:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 180BF6B008A; Mon, 23 Feb 2026 07:19:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 151C86B008C; Mon, 23 Feb 2026 07:19:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 054276B0092; Mon, 23 Feb 2026 07:19:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E1FFD6B008A
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 07:19:06 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 97C3A13539B
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 12:19:06 +0000 (UTC)
X-FDA: 84475625892.15.F00BD85
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 9B62114000D
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 12:19:04 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=H7Lwt3pP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of ardb@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ardb@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771849144; a=rsa-sha256;
	cv=none;
	b=cXM2VJfPsJsyqxrrjpvyrw8k6Ebn/WU9rKxO3rVyhLtwfmxw2NJanWtHA3+C7XI2UdhwxK
	KJb7cvJ88nWIo11NOsb3IZdYfDX8isl8ud1RlalFIv/zdyMeIgY/4ixvXM36yykEv3zlFG
	56z01iQKVKCsftWDkUDk/bbtNc2kKZM=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=H7Lwt3pP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of ardb@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ardb@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771849144;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YpStkhsodFIz+r0Azfp9W9K381YnvWXkpJF0z7PC+hg=;
	b=Tx5XdCMlLOTlHPNmcIh5VaX1E+pGTYuSZnN+8Eqm7NAt39fqHnTzQzraBkt+veDyRqbRyB
	qjyhvmvya/ow8iOYqfOGuGfXZ8wA4WRkiQLEbr9AKVgk3/jmjbzrw8ScvuPIY23GSKBhUA
	lVZpDI36z/n9MJJPTPCPposMwWnkq3s=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E17E560097;
	Mon, 23 Feb 2026 12:19:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47AECC116C6;
	Mon, 23 Feb 2026 12:19:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771849143;
	bh=L4x40NTeNfhFz9DzYSHhBr5EkKnCnezdmBS5U2foQr8=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
	b=H7Lwt3pPJjskeHHj7y1s81CQC42RHRFMxaaNdWnNjdpesYy/3mkK8bpUdv4JymznU
	 AUFkE55CltUgHIjTnJoEZdsunwj19cT5nlR2XdWSDorj+wF9iJ8LSRyv4DrwrXBFYs
	 m3DTBt5VP7LG1/gTvP7G0swD5K7z2XZz09gheT+/+3wypcgCEG+VlkUM9h/77EEwDf
	 glNBBOnAPdU4L/vH8aR4wnpxsynbkOkXElbf0S7nN2CDOhHrWClGttqJtaGLCKPWAB
	 CDXfBN29Od19fdWhgK2MJIfdHc2Kp/CtMl55HEuT1oS7wWNYeq98OvcNs2D5CEz0TY
	 pTJlgi+OHP9BQ==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 58BA4F40068;
	Mon, 23 Feb 2026 07:19:02 -0500 (EST)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-01.internal (MEProxy); Mon, 23 Feb 2026 07:19:02 -0500
X-ME-Sender: <xms:tkWcaXSE1f82Q-t1qd4cdGAieY14BMDjvay_rpnhKBJvqtXTG5H3yg>
    <xme:tkWcaTlxaFEd5VXic_TYXxW-OTIHxdkTBfcdn7krdBpzqIWim-PctdYiicamp7wxS
    tptIyEqCuFKsL5QJhzF7-hijYF5UPuTu8fDQ7uHhA0I5Rc14uLdRQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvfeejvdduucetufdoteggodetrf
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
X-ME-Proxy: <xmx:tkWcaQqAeuVtoky9o6-Xnu2J8LHRL6Pq6g5NAO2-wOQpMr3HzyrpPw>
    <xmx:tkWcaWO_hxeo9JKDIMQE6AR9_-zBhjnJYN29J3X_99V4SzfAAYXUcA>
    <xmx:tkWcaZgCfyZa67-lDg7C8hz-eoUrTmGGwwlIWW3W9eZ5GYVr_IhdNA>
    <xmx:tkWcaaYqafVkNhkWWtxZ9hVOMc5oHNMlFwUH7gTk6m2cmykOgzUAPA>
    <xmx:tkWcadjd24EEtUNhXgxtCnev56ZvPCwUpPiOv8RbT4P_UI965pkvP3BL>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id F04BD700069; Mon, 23 Feb 2026 07:19:01 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
MIME-Version: 1.0
X-ThreadId: AF0NZ4OlJH_7
Date: Mon, 23 Feb 2026 13:18:41 +0100
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
Message-Id: <bfe487fe-6868-4215-b5be-99a0360e9bd2@app.fastmail.com>
In-Reply-To: <aZw8xSI-TM-Gz84t@kernel.org>
References: <20260223075219.2348035-1-rppt@kernel.org>
 <b6f4edf5-7587-45d7-b81a-590d4f3d1ddd@app.fastmail.com>
 <aZwyNAbEqb8ZwLUM@kernel.org>
 <e2ad0845-2f87-418a-9f87-5ce619e004ef@app.fastmail.com>
 <aZw8xSI-TM-Gz84t@kernel.org>
Subject: Re: [PATCH] x86/efi: defer freeing of boot services memory
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 9B62114000D
X-Stat-Signature: gdst8coitdsct5cyeiet3ow84zhfwcfh
X-HE-Tag: 1771849144-220412
X-HE-Meta: U2FsdGVkX19Yf+uobAKDw2fjzdrnhjBwBI5/Ue/IfKcu20rym9d0qaz7JMjPqiIxpk71wulU3DZY2lDDnhDPZUJhUt7ZY9JHfWuW65fn08xNlcdC3efuw6zp2v99Ujqb1vAtVLRsHj59iY/YfK7bNnf+wndsKWk0Lc9cUd0aRYBYADOJGDl4msHgTwuYvPBl4/6JNAtIEwcxSyEazTaUOp6ibrXdz6JsET0SIsmGtccqpg1GAyeVLQYvAm+sCfPA6+0HLcGjVqJszj28MjDkGZBk11/wJcnvF5mfXEZlGOAqFaoCL6BdGv779qHGxWK7p1b/yojBDZCYt7lhlN9hZEH/XqGhMasCU45JU3Z8va0ttOU/fo6ZMYelLZ2oveH4GVCkWmrtdbeFL7AXl5nVnwLgjwp42J+aA4Le231PZ8S8EZwLeVR36wgdAJRCnsymxp3RFuwLN/u9UTOqKlMWBPn+Hfk06ByasTgu4gxXXrEBU1Rv3kshfKcoVNq/nVzRljikr0chO0kFqXHzbD3aDVtLIOn5BSyiw0hZp2t35oKr5GUDDfHuAlOhAPc4flCx2UqjYhcs/PT4E2zRHnlynXGkEEudzEJWzlayYIMmGHivtx8yjDih2w8GuA4vbajr+kXDucAhbl687nFEzvy0bqP0R1qhXPqKloTDMZ2YTm4oVjhdglTxEDBvN75VxxXT2Nv2gYGUqLILQdnfQPlNyagDSdJ6SwDoNd9onU/sTKnfShibwRLLnXSlfAMkhTAVulVLA9klEBooOFjNwbVWSxYpgcYyBqgLUkgAb0ieFnGT/eArvbP01R8sitE9VPeP5PBteMDo7xJznyjhRld5afO/2cazwKnu6q7L8S47wooQgM07IPAcB0VvgD417A0l7+GBypjotbzeSwP5Zxtohxha7bfRmevxox6f/k3wAKHYlCT7hCg8OUTp7bcZB8whDzXpPhONjBBxTJmAIU1
 EkfDVD/n
 77OlZ93UITytNQ+njouI6nO9Z2Rtn1+OGQq/R2W0NuCowF/YgyZ/VoPD66N2NpcKZETNDrXgvmwv27JSaP8pEWNHhMa+9I6svC+e1cgAY8iOZKaEswmXfWc16stpAr779cnYRMVKcWqLCiq9K8TayKYw/uRdYrtCDxPIly1/9YRjgsG9p4q4/Eu/HEWrqmJNGKWh01xwFdLajJ64ud6HhstVQpA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On Mon, 23 Feb 2026, at 12:40, Mike Rapoport wrote:
> On Mon, Feb 23, 2026 at 12:17:22PM +0100, Ard Biesheuvel wrote:
>> 
>> On Mon, 23 Feb 2026, at 11:55, Mike Rapoport wrote:
>> > Hi Ard,
>> >
>> > On Mon, Feb 23, 2026 at 09:08:29AM +0100, Ard Biesheuvel wrote:
>> >> Hi Mike,
>> >> 
>> >> On Mon, 23 Feb 2026, at 08:52, Mike Rapoport wrote:
>> >> > From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
>> >> >
>> >> > efi_free_boot_services() frees memory occupied by EFI_BOOT_SERVICES_CODE
>> >> > and EFI_BOOT_SERVICES_DATA using memblock_free_late().
>> >> >
>> >> > There are two issue with that: memblock_free_late() should be used for
>> >> > memory allocated with memblock_alloc() while the memory reserved with
>> >> > memblock_reserve() should be freed with free_reserved_area().
>> >> >
>> >> > More acutely, with CONFIG_DEFERRED_STRUCT_PAGE_INIT=y
>> >> > efi_free_boot_services() is called before deferred initialization of the
>> >> > memory map is complete.
>> >> >
>> >> > Benjamin Herrenschmidt reports that this causes a leak of ~140MB of
>> >> > RAM on EC2 t3a.nano instances which only have 512MB or RAM.
>> >> >
>> >> > If the freed memory resides in the areas that memory map for them is
>> >> > still uninitialized, they won't be actually freed because
>> >> > memblock_free_late() calls memblock_free_pages() and the latter skips
>> >> > uninitialized pages.
>> >> >
>> >> > Using free_reserved_area() at this point is also problematic because
>> >> > __free_page() accesses the buddy of the freed page and that again might
>> >> > end up in uninitialized part of the memory map.
>> >> >
>> >> > Delaying the entire efi_free_boot_services() could be problematic
>> >> > because in addition to freeing boot services memory it updates
>> >> > efi.memmap without any synchronization and that's undesirable late in
>> >> > boot when there is concurrency.
>> >> >
>> >> > More robust approach is to only defer freeing of the EFI boot services
>> >> > memory.
>> >> >
>> >> > Make efi_free_boot_services() collect ranges that should be freed into
>> >> > an array and add an initcall efi_free_boot_services_memory() that walks
>> >> > that array and actually frees the memory using free_reserved_area().
>> >> >
>> >> 
>> >> Instead of creating another table, could we just traverse the EFI memory
>> >> map again in the arch_initcall(), and free all boot services code/data
>> >> above 1M with EFI_MEMORY_RUNTIME cleared ?
>> > 
>> > Currently efi_free_boot_services() unmaps all boot services code/data with
>> > EFI_MEMORY_RUNTIME cleared and removes them from the efi.memmap.
>> 
>> Ah yes, I failed to spot that those entries are long gone by initcall
>> time. Other architectures don't touch the EFI memory map at all, but x86
>> mangles it beyond recognition :-)
>
> Heh, EFI on x86 does a lot of, hmm, interesting things with memory, like
> memremaping kmalloced memory and I it really begs for cleanups :)
> 

Yeah. Sadly, all this has become ABI for kexec, so the EFI memory map abuse is hard to fix.

>> > I wasn't sure it's Ok to only unmap them, but leave in efi.memmap, that's
>> > why I didn't use the existing EFI memory map.
>> >
>> > Now thinking about it, if the unmapping can happen later, maybe we'll just
>> > move the entire efi_free_boot_services() to an initcall?
>> >
>> 
>> As long as it is pre-SMP, as that code also contains a quirk to allocate
>> the real mode trampoline if all memory below 1 MB is used for boot
>> services.
>
> initcall is long after SMP. It the real mode trampoline allocation is the
> only thing that should happen pre-SMP?
> 

early_initcall() should be early enough, those run before SMP init.

>> But actually, that should be a separate quirk to begin with, rather than
>> being integrated into an unrelated function that happens to iterate over
>> the boot services regions. The only problem, I guess, is that
>> memblock_reserve()'ing that sub-1MB region in the old location in the
>> ordinary way would cause it to be freed again in the initcall?
>
> Right now we anyway don't free anything below 1M, I don't see why it should
> change. 
>
>> But yes, in general I think it is fine to unmap those regions from the
>> EFI page tables during an initcall.
>
> Thanks for confirming. I'll look into extracting the allocation of the real
> mode trampoline to a separate quirk and then making the entire
> efi_free_boot_services() an initcall.
>

Thanks!

