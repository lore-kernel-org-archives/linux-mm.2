Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9BA8710F3DCD
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 14:13:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DCE3E6B008C; Mon, 30 Mar 2026 10:13:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA61D6B0099; Mon, 30 Mar 2026 10:13:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE2A76B009B; Mon, 30 Mar 2026 10:13:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BC9DB6B008C
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 10:13:37 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6F0FB1407DB
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 14:13:37 +0000 (UTC)
X-FDA: 84602922474.09.520ED9B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 6EBD5A0017
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 14:13:35 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MEAQK5d5;
	spf=pass (imf25.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774880015;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mo7Ykh1aeGd+6cOaYYAPKUIZQKgmSZS6b8ZnYB3h/BQ=;
	b=TmNTA/dZQDBY7/DarZqtX58yu69tK92U1anPlnZP1ypluWyctdxFEYDNAm4Muspo/79VNA
	rgwaDUQjkreSFlZ7bRzNAhxrgV8sC6ddetbq2Vdc5v48AUnud1PCjJFCPJHxUDdz/UhHDH
	hFQ8aM3mpcmEjxfgFqwme+/KAvHCKCU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MEAQK5d5;
	spf=pass (imf25.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774880015; a=rsa-sha256;
	cv=none;
	b=wVaMwZpQ+zxPenmxdgaYnasgO3as39IMobFZOQtSAaZtRvBnEqQlwsnsqCZFEi2iBe1z9x
	e7xSqYgSgAqb4IcA7gWKOcki+ZR+y0OoLWaRzmmHV3m+PgfXdpIPXLbbl1HA6X8vzOfDKB
	fiDIQv+Cr8+TU2hODsBBfUP44yPEkS4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C7C7860121;
	Mon, 30 Mar 2026 14:13:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C062DC2BCB2;
	Mon, 30 Mar 2026 14:13:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774880014;
	bh=jjLo/KYlHlqzqnNv0WJEH/7qGaF/R61RDSt36mroxZ0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MEAQK5d5EB6gZI/XdoMH99WzaT0SQw895GgjMM2o44etPdaYMo8lRMr9kAZIY2NbA
	 SO1cMXJRYUD3+HH25DF5VFA3K6lJajLHMItJxSRCuxUdnN0xPtR+eW1GZOt32v3K5n
	 haVWFFlD7n5YHw0L6haPCVb1op2KzaUgV1N/sM4+inyRJ72UoikQsSQc6fn2Gftj3n
	 U+z/PfV7vd+S/IoeQr652CyiHomAgwZysEosPxXuPuja69XH7dAfBNDEiaNje84dit
	 9vKjC+d3cqFGeTzjNxwgoH11Wc1tuyuK6jno0RFy5X7VoBQ37f53sfWQY9bsbNhZN+
	 GMab29MMkExgA==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id C1A88F40068;
	Mon, 30 Mar 2026 10:13:32 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Mon, 30 Mar 2026 10:13:32 -0400
X-ME-Sender: <xms:DIXKaUNo8x6eNHbeeDZrPNKYYCYRt0OVrzAoJgh21Ck-T_Mfa_mBEQ>
    <xme:DIXKaRGBSKHVnr7Q9isa4JQgjjTUBwhCwPLDyGiwqzESPwEPO4X3jHpNkyc2z-90c
    oMToV8ClUtLNC0kkMd3LOW0y7P6Zh3PYQMBDylDpqJxbIoVHHS60bs>
X-ME-Received: <xmr:DIXKad-K24OQojUNBnEsHGs60TyyM8zE7h0c-5BRxWHRNh8Nq5ysCXjNmoLDAA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdeffeeludelucetufdoteggodetrf
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
X-ME-Proxy: <xmx:DIXKaaiJLRt5GSlkdiUmhFjWhOZ4nb9mM6WyYioqjMYyVB3fjl7zZQ>
    <xmx:DIXKaRl6F6N-NclA9PKNuHMnKIzG0RWjBeD5UGuU8RQ0Qx9rcJZM2Q>
    <xmx:DIXKae0HwbXVQA6um0VLymaQDy3iQOYfdome4H8abIelI6UOy6KafA>
    <xmx:DIXKab44LkdEFCFeip0pHXR6ZwEiGVu3SbVO6ZjPwnvL1WhiQsIDEA>
    <xmx:DIXKaciiUno2X6usDVDLFhSMU3fWh6eS__6EOM0QIwEfusfWP-DriSDe>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 30 Mar 2026 10:13:32 -0400 (EDT)
Date: Mon, 30 Mar 2026 14:13:31 +0000
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
Subject: Re: [v3 05/24] mm: thp: handle split failure in zap_pmd_range()
Message-ID: <acqC010JLTfjHF0y@thinkstation>
References: <20260327021403.214713-1-usama.arif@linux.dev>
 <20260327021403.214713-6-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260327021403.214713-6-usama.arif@linux.dev>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6EBD5A0017
X-Stat-Signature: zq9zxtk1eq87wi3j5q1uq31t8dmsfqfg
X-Rspam-User: 
X-HE-Tag: 1774880015-661056
X-HE-Meta: U2FsdGVkX1+9fjwRIsmuZCZ/0/Y+Wlu7PV6J3xdLdomRAMYtH1OW/HhSKDxyh1wsxECJie66zN/93iV/W2JIMgJ6e8S81EYz8Al4smf4f7bNcFHBY5eIfnsxLoX3tBldPurndqXJ9Ghp5IM/A+BrA4o1+KaMWIemiF7syIZFFe0uOftNiRccYqS8hk61ir2YLZV9qr+rE3Wyvmt+SMxisiN9ccmTJoKfdzzTIDS9JKZ3G3aHE248zYUMgn4Ao5xbD463cE2omoeCfFQnwpgFAMoyOh6qCnojSzDUqL7WivQl4THHBGtjsThIDrlWCIUG8DLjn79SwU4IhwRB1BtoOaKQcXrf+3g5FfL/SAOURgWf6ihMZsZ5I7AiRjQLD0dOyfpRi8UGNJmr2tabkOec7L9QlgKpUHLNEj4D6AL+XMlDXIRSRo/VDe/xHkn0I/ATo3zDZBfme0SFCWuAc37IfefhTcmb87zgD+HwyusGCoU81UOoCaPpU0TOldZQA39K9l1MAJX9fXqUfODIlygTNUmzP/4EjBo5Ni9+F2Kl+8xTr3JyAdpcRPwGovP0qGxgSOoOQyI7YXyoXfVEvJnEVLa2o+W33KwSf+urGX9mxK2S2jxpp1QOEifcwc0yta8q6uaPfkOc5oXZPIBPSocD/YxLS9Ibf1Ejs0ICX+F1piPw3tSLO3Fho6CGo9rrWUG0qFA46vpV/x/t3BWC7dMTL4GeAYy2ANb9iGd57FUWF+0ekZ3uq3qi2jttkgypxbsEy6+fX1HOAW8vWxJisEmGlpTwcIL2fiW2jzi8wZmGrVNvy+o2maL9XWjaLI7joq3ARgWn38PN3bYePdvvy3//dgvGidu35KDvi491fBala1c0enq9A+yFsHhaiVLe1i23SgKN4iZZSN8aBl7INwnlToTd6s90OhHYVEG2kW5Z97s7RWyzCgDC8kFhe03OIazTDORIsf6llA4xInoHjIN
 8nSN/Rg1
 fDtfFpUJizXmgBNJi04YcwaKwoovDfGtjYK1PzjdIj1hbXWbdP04otEevPTIWEJI/t24psh36Lybm6mwAVZUFdtaizu+GF6gD5RCi7j7JyXIt7yVbMg0Kq3no1mi2ryFeH2H06qCQarZfqXgeeWBfKVDR0LgpCKLPYevN2RpE/NAbQLk5qqtvs6RmeIyWu6GAxLP17pkHRywtzManv+61JNVHQ0dj+6iCE7ZTkiZlPVGnMvgoNkdLnd0BQtaUMWipYhKzW02utXzMuSzYJioHSk2xvE6tK45Xmatm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 26, 2026 at 07:08:47PM -0700, Usama Arif wrote:
> zap_pmd_range() splits a huge PMD when the zap range doesn't cover the
> full PMD (partial unmap).  If the split fails, the PMD stays huge.
> Falling through to zap_pte_range() would dereference the huge PMD entry
> as a PTE page table pointer.
> 
> Skip the range covered by the PMD on split failure instead.

Ughh... This is hacky as hell.

> The skip is safe across all call paths into zap_pmd_range():
> 
> - exit_mmap() and OOM reaper: the zap range covers entire VMAs, so
>   every PMD is fully covered (next - addr == HPAGE_PMD_SIZE).  The
>   zap_huge_pmd() branch handles these without splitting.  The split
>   failure path is unreachable.
> 
> - munmap / mmap overlay: vma_adjust_trans_huge() (called from
>   __split_vma) splits any PMD straddling the VMA boundary before the
>   VMA is split.  If that PMD split fails, __split_vma() returns
>   -ENOMEM and the munmap is aborted before reaching zap_pmd_range().
>   The split failure path is unreachable.
> 
> - MADV_DONTNEED: advisory hint, the kernel is allowed to ignore it.
>   The pages remain valid and accessible.  A subsequent access returns
>   existing data without faulting.

Em, no. MADV_DONTNEED users expect memory to be zeroed after the
"advise" is complete. At very least you need to zero the skipped range.

And are you sure that the list of users is complete?

I am also worried about a possible new user that is not aware about this
skip-on-split-failure semantics.

I think it hast o be opt-in. Maybe a ZAP_FLAG_WHATEVER?

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

