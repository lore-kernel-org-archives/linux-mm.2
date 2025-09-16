Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 453C6CAC59A
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 09:48:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 903118E0002; Tue, 16 Sep 2025 05:48:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DAAA8E0001; Tue, 16 Sep 2025 05:48:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C9188E0002; Tue, 16 Sep 2025 05:48:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 69BCB8E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 05:48:29 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 093E413BF16
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 09:48:29 +0000 (UTC)
X-FDA: 83894638338.02.8B0C609
Received: from fhigh-a6-smtp.messagingengine.com (fhigh-a6-smtp.messagingengine.com [103.168.172.157])
	by imf11.hostedemail.com (Postfix) with ESMTP id 1BF0A40012
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 09:48:26 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="D 2aQFVU";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=DUfuwFWZ;
	spf=pass (imf11.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.157 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758016107;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GIaDJagR+QktkPtVev8A7bap6/nPosyyx9BTZ75Hhq4=;
	b=Yie/ve+bTGmR5EQzr5++FydZ9trZ7B0G1gsqejUNOQTpIypP8zpFQKCchA4fgQZUK6nmez
	ly5P8qKop7vzAhFqV2/7CkldjQp4xAE7G/eVQrMK3spOiWnW3y8HdjVkmYCaj+FBz9pQ4e
	mu1h6Ph+BO0wHk3YHIv/8v8+icz/Uhs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758016107; a=rsa-sha256;
	cv=none;
	b=7dRKeI2ra3WUZAB6pHy7QXMhQ1ESDAncPn1hHJlaMKrIl2tygyYp8T01wriEqV1w1sB04B
	amP8SGz+gluXOxCmdDXjnjr1+9zBretoaAghoSc+o+kuo1Gzhm4zD/Y6N5ugiFg4z1r4xx
	AjNDEY8F647feXNg0gqAOjmDzufNZ58=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="D 2aQFVU";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=DUfuwFWZ;
	spf=pass (imf11.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.157 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 69BA11400247;
	Tue, 16 Sep 2025 05:48:26 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Tue, 16 Sep 2025 05:48:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1758016106; x=
	1758102506; bh=GIaDJagR+QktkPtVev8A7bap6/nPosyyx9BTZ75Hhq4=; b=D
	2aQFVUenZpmlwWbkc0BJn/KiocA4/a+alB8S3HR6Z9KCMRYB7LJuy+uoe+XPMwDL
	3v31LW0uHKJ20mGCykVe1f+UJ6eG4UZmqxiiZZue3BkUCIuv4g0wd+v+fG5cMjcY
	h7g2JtuqcG+cob2UKy0/8gdEixQw85txfrczK6yoldfJNF2MSvHiJbNITooJbcMx
	N8sjZ2PM2Yc7fcTkCGUn9xDq63YY1VRe9s1mftE6WZ9z80ng5A+tXzbTYGha1Xsk
	/3Y+juLJ+bQ1KLhQJG9dYGbX3VOPJsvtOoWzGFWc5vITaIFrVyhIW0IduGRhI7X5
	n5n4XBAaCKoWtZfoymWiQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1758016106; x=1758102506; bh=GIaDJagR+QktkPtVev8A7bap6/nPosyyx9B
	TZ75Hhq4=; b=DUfuwFWZbgU0msmOXJcIntKzo+CZrLWDhyFsK3jIvYe8gpsjy7O
	mD/zEojNTom33aPZawg36Sv4o2/OFeioVKEeAOVhq/+Lqe/HaR8+H2kygdyIPeCD
	iD0mvJYEGlv1vC3sXXKAaOPSGwDfzM14BhFkelJypR4vkedExqivdwQhXTSbhyTp
	6EprMoYXvJqnVlUvbpzqhOzJ3e71IySOh9wzfZu38zlUs5MUWj13hEp03KOLdvUm
	dwRGNCtSRxpUY8/uIblNDlI3p1E5Zonj02uNm25oubaNfaJ5stwpl+X+OAUk27LI
	4PVDwG/LWK7W6ZzlQ7Mtx/UsEYsQdSclCKA==
X-ME-Sender: <xms:aDLJaEptfJoy9XmdVyQ0uJxuTQfTlJ2BQQuJmEWK28l3U2kuf0OyuQ>
    <xme:aDLJaNAq1WD4onJ4VzC1tdPZ9-WoT8OgxBqFcfdkz4In5HKypHcDMY4zvDKgcuv5N
    prIt39rzMsc2shwuQ4>
X-ME-Received: <xmr:aDLJaCccjZDvgiY47XMhRiDcGjU3mTenhChvfLfO6gWIeCppjwlyyu2Hfn3CRw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdegtddvhecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvvefukfhfgggtuggjsehttdfstddttddvnecuhfhrohhmpefmihhrhihlucfu
    hhhuthhsvghmrghuuceokhhirhhilhhlsehshhhuthgvmhhovhdrnhgrmhgvqeenucggtf
    frrghtthgvrhhnpeejheeufeduvdfgjeekiedvjedvgeejgfefieetveffhfdtvddtledu
    hfeffeffudenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpehkihhrihhllhesshhhuhhtvghmohhvrdhnrghmvgdpnhgspghrtghpthhtohepfedt
    pdhmohguvgepshhmthhpohhuthdprhgtphhtthhopehlohhrvghniihordhsthhorghkvg
    hssehorhgrtghlvgdrtghomhdprhgtphhtthhopehlrghntggvrdihrghngheslhhinhhu
    gidruggvvhdprhgtphhtthhopehhuhhghhgusehgohhoghhlvgdrtghomhdprhgtphhtth
    hopegrkhhpmheslhhinhhugidqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtohep
    uggrvhhiugesrhgvughhrghtrdgtohhmpdhrtghpthhtohepiihihiesnhhvihguihgrrd
    gtohhmpdhrtghpthhtohepsggrohhlihhnrdifrghngheslhhinhhugidrrghlihgsrggs
    rgdrtghomhdprhgtphhtthhopehlihgrmhdrhhhofihlvghtthesohhrrggtlhgvrdgtoh
    hmpdhrtghpthhtohepnhhprggthhgvsehrvgguhhgrthdrtghomh
X-ME-Proxy: <xmx:aDLJaPCxFKUa12RfE1NOwYjTnezmw4poFf59dpCupkv7sRhcpDB6Xw>
    <xmx:aDLJaGRsYEyege5ZT3Zl7jn3BpoAT3JOt_WNWE0wAkVKDiiRY5yx6Q>
    <xmx:aDLJaDcuZfi9cHeEfwu-pT7mwlyM4g7bYCG7GuodzK8FdEIogUUD_g>
    <xmx:aDLJaJqt7DzRFnDmwrRSMvZRbAb5qlH91D_ybdKczOQMggYlWyzn6g>
    <xmx:ajLJaDrbttBV36_C69McZ_6b1L3IHMGBKmod78-rby2a5NzTrsKnbnK4>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 16 Sep 2025 05:48:24 -0400 (EDT)
Date: Tue, 16 Sep 2025 10:48:22 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
	akpm@linux-foundation.org, david@redhat.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com, 
	Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, 
	baohua@kernel.org, ioworker0@gmail.com, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org
Subject: Re: [PATCH mm-new 1/3] mm/khugepaged: skip unsuitable VMAs earlier
 in khugepaged_scan_mm_slot()
Message-ID: <3az7vzkhpa2pup3td5pbrek6ti2fij574qimtnbpecums7ixyl@upabkyqmtiaf>
References: <20250914143547.27687-1-lance.yang@linux.dev>
 <20250914143547.27687-2-lance.yang@linux.dev>
 <bc86d5f7-5b23-14fb-0365-b47f5a6f13c9@google.com>
 <a0ec4014-384b-4c04-bf0b-777c989eabcb@linux.dev>
 <ol447ofo44vwtyfwg3zrdtcdlkfzzmx4rre6qhyotmwvecnec4@usa3nonuk2sn>
 <2466c068-ccd7-41a1-bef7-6f3fefc6ff55@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2466c068-ccd7-41a1-bef7-6f3fefc6ff55@lucifer.local>
X-Rspamd-Queue-Id: 1BF0A40012
X-Stat-Signature: xbrwxtuydroukqq8hx74utpauytnceyk
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1758016106-191373
X-HE-Meta: U2FsdGVkX18ltQoDpOrP5iiBCaeh8GeioYA509vHWhDsnRz4D3UkdNtWIkm4JxrLMbvqncPURLeNhDqhoDC7VmZHmlSdrfoZ5d4DiiAZST5qRpQVZ9gIGL1TYkE1OV11qRfUdyAbllABPNbsOamdBrMdyQbxYEyMxfW38Tv5ojuGLxLZiOBuEFHLtJ/z1G7ivCGaKEiHuVJ6HMnlPTWUkToipBVK+dKbTRZVEW3pU7nopch9olCuuEZigwVNVBqc0clWEPUeL/TFe6drQKAJjXv7tXc2ve8XWCZEPX5J4ZCis2iBHTHuyCztG8nvexl9KACYVvUUUxtsOuOvVkCqh+nXMMQD4vc9AUt8Jf1bm2ArovSj7VhaSAv9l3BmxktxGJ/BMcGYd21BRwPGouV7rMdUfEJGeda+3qMQ9cxk0GFuuAXPqvvT51L4gCJCP1joV4pW3pAkXywxdVGc8IMZBciBgsSwHkiQ1876Rhrg4y4fOJIbKsBOQMCzSfgIG+pm/QifDUnDU3OWwMA7f5COZ2HQuGStbfr5E86JGBiBPp8akQr2BF+yU/p0Az4g2MKlIXhI0IrAg4gWBJ8Qq/bMb3RWuddkMmVa8eOkCO0C182td1w9PXcv9UmH2Bbcoy3YZXkzR0whll5xMc/VPhbFUtU0Lxo+FbJpKn7e9fOqgb48GxrPOKRbaZU+5iZnB2yIqg3EZm7OwfW0wyPu1RNrSdl8RLMUHODqkIxCnvbMjqKZpKdCdJoYQ9m0K8DaraVbPgFfGrPQ7fpMVNtmhYbOkGwsWxjR3Aoqmdt8WM9RPs3K3jz54n6zjIT2aBfgBvM8mD6dqdboACsxaJY1juCWfPI7D0mbYk+oZY02Nw0VgE8loCekMN+YQIkwLOcR4Ly3lIoEIu6148qOR6sHLq4tnnaByanhT3DOpi7t5haqD3uZZtiynQWZ/b6ksCVGLfR7LLQyGN1ZDwhBK6cvcRF
 DaYDlnGP
 hUNTE+km/EmDVSaveJOJqmaRPPUShu27llgNI7HVvWw8elLKSmKBy3Ntc4XvXlxSDJDlEH2eNBYEpFHHocB4LB6RGZAvhhazqmtmnsJbM/pGUx1Li5UnkNdhytveKEspkk0VlcAGMf3qGEgUXOcmxcntJG8KqnztzWoCqVkuUZF4pINjYQIaNjoLnbtqIfdKnpzklG+uNMw1nqs2lFdfPrOMvLyHGKvhLq5fa2jWIfwxTRusAdHxSf3TTLEQiIe3Ak9XzyXx21jgwE1Tqcd6N4Zsjc5GetVBNbahP6KOSPrgC2XcHNfaKc1SbeVW3Ydq4ozzEExTbAkU+BDQm8lZcM1ntB5N0mIx3b6h76SfO4Rt/TnhbzPYgltMvATX/3bZ9qQf/SuNAD5AyNWpPzF/CiWI3390iMP8TaA63MVEdTLmxTieudf619MDtueOwb/bFmFWeKq6Mk1VADUqcHEcY/7mtVA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 16, 2025 at 10:39:53AM +0100, Lorenzo Stoakes wrote:
> On Tue, Sep 16, 2025 at 10:29:11AM +0100, Kiryl Shutsemau wrote:
> > On Tue, Sep 16, 2025 at 02:21:26PM +0800, Lance Yang wrote:
> > > Users of mlock() expect low and predictable latency. THP collapse is a
> > > heavy operation that introduces exactly the kind of unpredictable delays
> > > they want to avoid. It has to unmap PTEs, copy data from the small folios
> > > to a new THP, and then remap the THP back to the PMD ;)
> >
> > Generally, we allow minor page faults into mlocked VMAs and avoid major.
> > This is minor page fault territory in my view.
> 
> Hm, but we won't be causing minor faults via reclaim right, since they're
> not on any LRU?

PTEs are still present when we do THP allocation. No reclaim while the
access is blocked. We only block the access on copy and PTEs->PMD
collapse.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

