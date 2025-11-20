Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E9B1CF857F
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 10:39:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE6186B000E; Thu, 20 Nov 2025 05:39:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABD8A6B0012; Thu, 20 Nov 2025 05:39:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9FB506B0089; Thu, 20 Nov 2025 05:39:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8B0796B000E
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 05:39:36 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0928214084E
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 10:39:32 +0000 (UTC)
X-FDA: 84130638984.12.44B8D26
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 5C4301A0004
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 10:39:30 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=d+NMVcBn;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763635170;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t1L78JWdnbTPwOev7eMJ4Yi1EfrBBlfXmTcOPyqNKVg=;
	b=iq1yg7WA34h2mMnE5KlXfVQoZ6xgEGbp3tJvRJMXDc4+ydA2Z8NNQYy+c1TTPO7k9e0DYP
	jUs+dlHW48cuENsHwrjPA2YbDaIXfOg5hke6kiK9kQ4h4VNiz28oldCHvzgvErDwTkwYEz
	T8WbmGzQI7sJDuIJ1kDKGRN5snanPW0=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=d+NMVcBn;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763635170; a=rsa-sha256;
	cv=none;
	b=MJx0eonBzBUGgt0VKhEbZpRk/7JyMFVjc51irNAGrs2u5aJH3G9VxyqQC3oreE3ZzDckXZ
	S8mwvTluy3ZFnZoz6ZpnlAqP+TgWnxxHWK9jbCQouYdBI3S9Xp/s/3Xb5VnOHOEsnyh/lG
	hS00QtrL8q9BCb2S5oJWgyFwWXvj1mo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6754844303;
	Thu, 20 Nov 2025 10:39:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E52C5C4CEF1;
	Thu, 20 Nov 2025 10:39:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763635169;
	bh=znEBJZ6KVjGxzXOPPFRsG2pfUqSyfqKNp3vpnt4GJOI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=d+NMVcBnQBzC7bjU9SGmlKCg9QD1FjOqHhljO7/dgmuvdk6VrTEKwWCW4phwfHHd8
	 PB3TCRF0Zex+ImdB5soewloNhAA6U9XfQmF+FVBbt0wyqpGM3lMM6z48PXFeXL5gDu
	 oJHDekD5xXDH236W2gsv2C379JPZuS3UyL9zMlS2KjQF5bPKguchJ3gVDC43qr1cLM
	 zIoixbl2+j+a3DuJYs9R6KwP9+Vu2T/aHyyqC7tnGm+Bo/2VnFXgvtKzcowKux1Urs
	 B9lLldl/SE9NXZ6sEEqCAuT+5Cm6KFGrg8iX0WFXCJV3QfpwtPoD0hHRKo0f7BTyO3
	 A5dE/feCtJxBQ==
Date: Thu, 20 Nov 2025 12:39:21 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, akpm@linux-foundation.org,
	bhe@redhat.com, jasonmiu@google.com, arnd@arndb.de, coxu@redhat.com,
	dave@vasilevsky.ca, ebiggers@google.com, graf@amazon.com,
	kees@kernel.org, linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org, linux-mm@kvack.org
Subject: Re: [PATCH v1 04/13] kho: Verify deserialization status and fix FDT
 alignment access
Message-ID: <aR7v2VyYfs2HAUbW@kernel.org>
References: <20251114155358.2884014-1-pasha.tatashin@soleen.com>
 <20251114155358.2884014-5-pasha.tatashin@soleen.com>
 <mafs0tsyw7e0a.fsf@kernel.org>
 <aRhJk_Glv2pX2dRo@kernel.org>
 <mafs0qztv4gw9.fsf@kernel.org>
 <CA+CK2bDfrx21=Aw3pwPn4=AKGVeh0O+sB5gp8rvh0fk8C_nsdw@mail.gmail.com>
 <mafs0a50j466b.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <mafs0a50j466b.fsf@kernel.org>
X-Rspamd-Queue-Id: 5C4301A0004
X-Stat-Signature: yjjfna4k6o3u9yj1duuciwswge6e3obd
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763635170-933859
X-HE-Meta: U2FsdGVkX18JMvtp/+j1Lml67JuG31TV4XyFANnvY5cdnWDn8nizr+Jxhy+psLRIxBcX1RZ3MODooIzupyEzCytecbbKJC/t02Wft0hkoJpeLxmFkUEv26QWdp5W073TJv7gTndZgngXiNgs+0neVCV24R3nk2jL9CNoNAPYogOLJGWGBr47hI9SBmCxRiJSm8B2ILibxjvC7L31VdBgr5pQp6Lihg6DoFvA6qQI0WIgGh7XuYDT9M/neUs8rOn97ZSW/VN2tO9jXbUCucQnr1/nn5WyLGJb9md51DIJsEMFxtqHDOWh34l+h2F575f3xfsFAMs1CheYRjZzZmUHrzQMH8NMC9SSlhMg+ZDCdI9RJPZv7QHwe0kBwlXIANeKwW6ebTKjphSK0zSlCuKpLl/J83CVzHK4z1VaoKSCTtJCRcN773UgY27CfxX9eK9zM/quvUHpl9MEBbLVtRsHWcSOxzulwHqPL3+rzjuMfZblpp/WAcrZ1SBDYdpJfM1RUyrfxoqpd7WAdfMUFMI6CZjP3qr7pGun2JKmF5WVFOzqd/8pK2ca9jEbR9lRzwzVOAv200JUJz4sYy0Ckv1bOzWOPUW69Z7jZNZhVQ547KbE7lIbTtbMqLcYrBzUXcge9no7Jk5eAMAzmcd+u2RNFaWvyLDW6ddhVogIPxkB9PVCUssWeEr8Y/R9QL4cRaDV+Ao/maDbd3nDL8EZxxwWrRuCWMCWEpeAF058GmeDLypWMjf8tl89Y3AzyNfiRApZs2mIVTe5coXESlHRyueUlEwRd5cyHy+e8dnoE4TcBQ+sLONSJIFUVQGiTzG9+Cpy5vxbKAtDpczTz2rZf4hNwy+raYmW3we/3tam40T22wTBpkF3zcw5DxGhPT+Pfr8otdLj1vPd1XKWJxL6rC/+AHr2zb/nCgiKUUBxbiamFqei7Gvx53ZoUb6mTQ9sCsgySEh5gtf34vRpg1XI9tk
 VHqf//4M
 6zelDv+zqv5B9wmDoGbWTHvJS0czbFdIFVV2W7rYqE5bQstroZRJ45PU/1FPX4tsKsSiKbPe8pkOlXz8vyBo5cwnQIeDzBSWXJknj9GsVnfbRwA9OUopduHO7W4r01O7zPHW9ypzT+aufDSNcdG0WFC8ydTw0mJEfkA5M6yyhed6oXhFTQ/uh8/wYDY0NKk6Kk5m+Cb2eik2NdbLZoHhlOdRKLkC7jImpp6gFzmzwxd+os+qQDk8jF8JQfcyq4KQ6Fj+2EOg51mkXBra8e+qTfaeKpw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 18, 2025 at 06:11:24PM +0100, Pratyush Yadav wrote:
> On Tue, Nov 18 2025, Pasha Tatashin wrote:
> 
> >> > This page is never freed, so adding it to zone managed pages or keeping it
> >> > reserved does not change anything.
> >>
> >> In practice, sure. I still don't see a good reason to _not_ initialize
> >> the page properly. It's not like it costs us much in terms of
> >> performance or code complexity.
> >>
> >> Since kho_restore_folio() makes sure the folio was _actually_ preserved
> >> from KHO, you have a safety check against previous kernel having a bug
> >> and not preserving the FDT properly. And I get that the FDT has already
> >> been used by this point, but at least you would have some known point to
> >> catch this.
> >
> > The kho_alloc_preserve() API is different from kho_preserve_folio().
> > With kho_preserve_folio(), memory is allocated and some time later is
> > preserved, so there is a possibility for that memory to exist and be
> > used where it is not preserved, therefore it is a crucial step for
> > such memory to also do kho_restore_folio() before used. With
> > kho_alloc_preserve(), when the memory exists it is always preserved;
> > it is gurantee of this API. There is no reason to do
> > kho_restore_folio() on such memory at all. It can be released back to
> > the system via kho_free_restore()/kho_free_unpreserve().
> 
> Even for those I think there should be a kho_restore_mem() or something
> similar (naming things is hard :/), so they go through the restore,
> their struct page is properly initialized and accounted for, and
> make sure the pages were actually preserved.
> 
> Using the memory without restoring it first should be the exception IMO.
 
Base KHO and LUO FTDs are such exceptions for sure :)
We have to use them way before we can even think about restoring.

> -- 
> Regards,
> Pratyush Yadav

-- 
Sincerely yours,
Mike.

