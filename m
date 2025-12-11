Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8B77D41D4D
	for <linux-mm@archiver.kernel.org>; Thu, 11 Dec 2025 15:00:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A2B36B0006; Thu, 11 Dec 2025 10:00:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 254016B0007; Thu, 11 Dec 2025 10:00:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 11C3D6B0008; Thu, 11 Dec 2025 10:00:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id F06916B0006
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 10:00:46 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9254812BE4
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 15:00:46 +0000 (UTC)
X-FDA: 84207502092.07.E539B67
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 5F3E010002F
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 15:00:44 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=W08HE6zF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765465244;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GGZ1nnrzNNo+dNXvu+6hUZUd6j9dUthS9yssmcvlTTA=;
	b=GyQwhuF197oFTiRRrbM0smWkAMyfH91VXxjK62fdUsOBr2KAseM4l8x8S6zrVrywwxY8XK
	O+1A5U9cQHGNTeIkkyF9IMHbg9MT7TH55j2eNsL5Y0rCbL84Asxfg5MA+mWoYNPoCHJOWe
	QJ2zhXGIAG1544VWTFNUdBAtflXF0FA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=W08HE6zF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765465244; a=rsa-sha256;
	cv=none;
	b=WEJ1DIl1b4MmSC2VWKHr5BxV754/Y70zsyV+0bbS2yFAuBZQV8KPbTxndirUrFEDj+KC7r
	tuiOMOvx9W0BHI4Bs0HVkw+Itk3rifKG3Kk6V1RfLHMpqfMj4LwGmDxZIrmwwFUFpZ/i73
	KxFhA8b3g60jRMpKhVzd0d4X0HMp324=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0EFB644381;
	Thu, 11 Dec 2025 15:00:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A219C4CEF7;
	Thu, 11 Dec 2025 15:00:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765465242;
	bh=1UKwlxIH8EBWmveD91rtbw1zk2GIpitHurcNBZbqQuc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=W08HE6zFvXO+PVqKaVp7ZkX9LNSXoX9450L9UGj6FRlcSh0on0DbWkBLhnFnC16bE
	 1PD0JvylznwzYRvG7RQEQt8sib6yWVX6ZmjlBsquojwFKPY1PHR0EBILC3+Tz+jBrA
	 Zfwb6/v6FNDPQXf+2ijOYFWznkqkjVCMjQemkP6bLzjClmnA2V6sSm/9rqqoJeIOJf
	 gn3d20uNKlgruxNJME5t7Oa/TmhC27MgOL9kImAOqUzTJ+RCKterH1D/1LRf5MobqP
	 QiWe3/EuwPkuaSXL/2sgX8ojiyhJl3XcysZ7+AN/WzhcNbH+PLWCW2CKqpBRum9XHV
	 zw8UlwIKYEUzQ==
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfauth.phl.internal (Postfix) with ESMTP id 68BE0F4007F;
	Thu, 11 Dec 2025 10:00:41 -0500 (EST)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Thu, 11 Dec 2025 10:00:41 -0500
X-ME-Sender: <xms:mdw6aSugYlLqhSFkC_QL4fuLRQqmZ90svCc9oTbpJhrhGUJ6AtlLnw>
    <xme:mdw6aU-EWNGVM0EUDYx23Jq7XrilUUJZPAMufw0aXg-hjt1xly1ADemtvftHioOVW
    PByc53jmXauMiVmyCXBYiBWjZl_MCyWxsAcxuVgYQNanNjwLFyjRpw>
X-ME-Received: <xmr:mdw6aZ1l2C5xAY3Sb3Ckw3OVTcBSdDd6LfXPha-3Kop8yxNxmoKVNy_LTEx5Ww>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvheeiudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvvefukfhfgggtuggjsehttdfstddttddvnecuhfhrohhmpefmihhrhihlucfu
    hhhuthhsvghmrghuuceokhgrsheskhgvrhhnvghlrdhorhhgqeenucggtffrrghtthgvrh
    hnpeehieekueevudehvedtvdffkefhueefhfevtdduheehkedthfdtheejveelueffgeen
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehkihhrih
    hllhdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqudeiudduiedvieehhedq
    vdekgeeggeejvdekqdhkrghspeepkhgvrhhnvghlrdhorhhgsehshhhuthgvmhhovhdrnh
    grmhgvpdhnsggprhgtphhtthhopeefvddpmhhouggvpehsmhhtphhouhhtpdhrtghpthht
    ohepphhrshgrmhhprghtsegrmhgurdgtohhmpdhrtghpthhtohepuggrvhhiugeskhgvrh
    hnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqmhhmsehkvhgrtghkrdhorhhgpdhr
    tghpthhtoheplhhinhhugidqtghotghosehlihhsthhsrdhlihhnuhigrdguvghvpdhrtg
    hpthhtoheplhhinhhugidqvghfihesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphht
    thhopeigkeeisehkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihhnuhigqdhkvghrnh
    gvlhesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehtghhlgieslhhinhhu
    thhrohhnihigrdguvgdprhgtphhtthhopehmihhnghhosehrvgguhhgrthdrtghomh
X-ME-Proxy: <xmx:mdw6aac5m85COt5GDXcf5N8EgK4MjN867SZwm-7FGk0WnsWXqo-q-A>
    <xmx:mdw6aVcXsQE9PW1Q1fegSLWpVyQGH5vmnHpLx94yZhgTHhHXr1MHcQ>
    <xmx:mdw6aQ3VMhcz6Op6EKFKWQ0mqr87xCJGOgAKBgERyCSAWjxXXih6Sg>
    <xmx:mdw6aV72QgkHsEO7IT7gcnA5QiMWjq-EO2SCHqbap8KRc3x-tuqtHw>
    <xmx:mdw6aXImq48CZQ54RUKyN9zjcudJV7yG6FOlFG0mX5jIUp-c3aE8gsY6>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 11 Dec 2025 10:00:40 -0500 (EST)
Date: Thu, 11 Dec 2025 15:00:39 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: "Pratik R. Sampat" <prsampat@amd.com>
Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>, linux-mm@kvack.org, 
	linux-coco@lists.linux.dev, linux-efi@vger.kernel.org, x86@kernel.org, 
	linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, ardb@kernel.org, akpm@linux-foundation.org, osalvador@suse.de, 
	thomas.lendacky@amd.com, michael.roth@amd.com
Subject: Re: [RFC PATCH 2/4] mm: Add support for unaccepted memory hotplug
Message-ID: <uc6yz23havsg2cdgtk3fgku7xr4gj2ykse7lxitcs4eh2fw4vo@hyavdm3ovdfh>
References: <20251125175753.1428857-1-prsampat@amd.com>
 <20251125175753.1428857-3-prsampat@amd.com>
 <ac479414-e0fa-49be-8a30-8f9c0e7b7d32@kernel.org>
 <73a69c03-feda-4c56-9db1-30ec489066fb@amd.com>
 <938a7948-7882-41a3-926b-3d2a8d07620d@kernel.org>
 <89fde0fd-57c4-4146-82fc-a4c1a56e74ec@amd.com>
 <a7ac1f74-32a6-41d1-82da-b338c127fb2e@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a7ac1f74-32a6-41d1-82da-b338c127fb2e@amd.com>
X-Rspam-User: 
X-Stat-Signature: 84ory8enx3sd6kpp3o6pwimeihta4tmu
X-Rspamd-Queue-Id: 5F3E010002F
X-Rspamd-Server: rspam06
X-HE-Tag: 1765465244-554311
X-HE-Meta: U2FsdGVkX19tYWmuFm1uzIKvlJszNsOjiqdeYd09jw2wEwXsKZfeRNYtwUH6vLHIvDfnVVcFKBTQhksMBnzubBWhZ72VggYSVF9kJmy2xEciFEP54ObulVAcs+L5Oj4aOWfewnsqPUvLuz3RfRmm+ANadVOVddY4Wn9gjg4hPDJmg5/jcxpyk8VQ7V0IynGfSytSRiqEh6EcaSu+NFfRS581XuuttVrHjLmWfXzyFnl3ogOre+Uy68ow/xhuozJ8QwZNGaXHthxmws2+EyBocit6tUTavS1D+9J7H4OJNxlL9LxTN/bMYLMYAvYnqcDnbqOt9kR6sB2yMIBJTfB/vYO9APvFpJrlTyBOnmirm939TctzRWuX10aCxH+iiNnUpoV1m/fDATzQ50hSZdATdi3RWeJNJxnMIK2sKPRUpvYe6Dx1d5438Chk/EoV3fWRCn4KbcjiJgFu0+XrrbXjUQ82x7aqW59cLjCJZDZqjY8fF+pnDYbksdY3TIcEm+IUlAR1s4wGNKeAPGVS4UuRZMKULYWBNPWEOi2xiLlvuHeHuDkiDwTDfDsuADoqSpWtIuFPeXLEjePa+1lQCQzlAbie1bmu0aM/vk/CEN9HmzdxF4kOE6y3j2Xun6dNtWiFkqoj/JNAiv9hjvecXChNhpmiQMSBVC+ffm/VW8AuBGDgJTBd5Fw9wkb13mZtu4wW8oH0x+FrV4uL+Klbwym3PlxG06Xf2FeKD6FL0NzAEr/9Kn5zClwyHDeLvDsEwPco5nObICyQyMxPMMnwAS1fo02ZyjqL5epNFSRSlGO42uFVU5bIyZsGQnbaj0bCNiPYRsRKxv6C6+neuE66np23v4oiOte/QHKVtmf2F0ZAs7rw1zOw9qDij2jbLxzFxpVfno6xGvOAdup9W8uGHKlfIAdkib7wiqHFJEveqd7KLIjpvgPcYDs2/rNBGkmeqa/B7IYhpkFmcg5KB5/5gPH
 hdaVPzNI
 JEf9QXS58jZlB0VX1wHOWDvmq2p96rHV8yrMwoMCcCYBe5Yjv00MtfChAH71SidpfkDAx8tu18B//PvQoneKhk8/ytg2haCrBMqH15mSfpg2f+OopPOUznOAUTbl9Nzu8dPhT4wQc44Ammpcgyj/KnEc6nWGgSPhVSTzGBi5zuAllpNmp867AGJzFoP39zPyZyOts4FuO8Mlj+d/LpPEsKtvrISLbaBorRmBPkVHUuLT1zFKEluPDcgLr/X+8mmImRMB9MUW8hfp9NSL1I91guQ+zKw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 09, 2025 at 03:36:09PM -0600, Pratik R. Sampat wrote:
> > Agreed, I think Kiryl was hinting at pre-allocated bitmaps as well.
> > 
> > Since, the overhead to do this upfront is fairly minimal, that should
> > certainly simplify things and have very little to no meddling with the
> > original EFI struct.
> > 
> 
> Taking another look at this suggestion, I think there may be more to it
> than I previously thought. Parsing e820 tables to know what the range
> are for allocating the bitmap to cover hotplug may be difficult. For e.g
> 
> [ 0.000000] efi: mem110: [Unaccepted <snip>]
> range=[0x0000000100000000-0x000000017fffffff] (2048MB)
> [ 0.000000] efi: mem111: [Reserved   <snip>]
> range=[0x000000fd00000000-0x000000ffffffffff] (12288MB)
> 
> Parsing of the ACPI SRAT seems to be the one that gives us useful ranges
> to base the upfront bitmap allocation on. e.g.
> ...
> [    0.018357] ACPI: SRAT: Node 0 PXM 0 [mem 0x100000000-0x17fffffff]
> [    0.018781] ACPI: SRAT: Node 0 PXM 0 [mem 0x180000000-0x2ffffffff]
> hotplug
> This is also where max_possible_pfn gets updated to reflect this range.

Do I understand correctly that EFI memory map doesn't mention hot plug
range at all, but SRAT does?

That's a mess. I thought, all hotpluggable range supposed to be declared
in the memory map.

I wounder if it is what BIOS provides, or is it result of EFI memmap
cleanup by kernel? I see we are doing bunch of them, like in
efi_remove_e820_mmio().

> One potential solution could be to parse the SRAT during unaccepted
> memory bitmap allocation in the EFI stub. However, this would fragment
> the implementation by duplicating the SRAT parsing. Alternatively, we
> could keep the current approach of dynamically allocating the bitmap on
> hotplug or I could also replace the entire memblock_reserved unaccepted
> table like Kiryl suggested if we must absolutely avoid changing the
> unaccepted structure?

Other possible option would be to accept all memory on hotplug and don't
touch the bitmap at all. It might be not that bad: it doesn't block boot.
We can think of a better solution later, if needed.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

