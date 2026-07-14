Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1EB86C43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 08:46:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0FF086B0005; Tue, 14 Jul 2026 04:46:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D71A6B0088; Tue, 14 Jul 2026 04:46:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F31666B008A; Tue, 14 Jul 2026 04:46:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B5ABB6B0005
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 04:46:23 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1B38B120300
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 08:46:23 +0000 (UTC)
X-FDA: 84986750646.11.B3B39AC
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf08.hostedemail.com (Postfix) with ESMTP id 04CF5160003
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 08:46:20 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=DMLbNoNj;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=lyVlUAK4;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=DMLbNoNj;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=lyVlUAK4;
	spf=pass (imf08.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784018781;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WPDedMYoIPcbcGvrvY5H+IQoUl1T+mrUVDSGwBtiCbg=;
	b=ueqWXCRjufjXn1KoMt28pXJMFIVPmoa+VzIYdjqXsK2YBWBMSbkyp3W7cmQAGNtVGkoaXq
	6hFoQOgGP4kd0xbeAMyIoNO2alxgNnF1iFJMLx9SxHIZfPsj9ZAKG+JRHYG0sJYUGX3lIY
	SIp/LJ2VBwWKuPDDXUd+gwMqQ0/JY0o=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784018781;
	b=IRBeFaSR+0Usee+ePJyVsnNjWmt7llI803V2GJcrypoOhZQ8CZGd0yEjZNbj3DWDCXgzUG
	dZH2JipTMgl2wVkj6V8ZVzWyF7lBGaHyNIuZ1MOWOqM/kwVcJNiea9wGlWv3gSbxrcEFFu
	k3aaml8yeqgOvtv/StAO0fqNQZn9+5Y=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=DMLbNoNj;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=lyVlUAK4;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=DMLbNoNj;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=lyVlUAK4;
	spf=pass (imf08.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 5EE133E28;
	Tue, 14 Jul 2026 08:46:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1784018779; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WPDedMYoIPcbcGvrvY5H+IQoUl1T+mrUVDSGwBtiCbg=;
	b=DMLbNoNjgWmDIdKbEiPtdPrkH+ld3RlsqcX64XXxxm2RRfUg8MvGJZ92ZgBD27P28wzVAA
	WRSveFEoJOgqWKyZQ6GSxKCLZHtGdMqV1GrwiawGsxptpJoltg8OJztjLYy2/lMw2iBI/P
	fAX3DThYJFKoqdOXrOHqge89JD7L96I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1784018779;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WPDedMYoIPcbcGvrvY5H+IQoUl1T+mrUVDSGwBtiCbg=;
	b=lyVlUAK45w4IS5EBJhNIkm2IZu+OwsxYgYOU3pgx6TZtANaLf1fDpxr7lpSfW0kNN+MAcF
	DHuo8dkcwMuEetBQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1784018779; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WPDedMYoIPcbcGvrvY5H+IQoUl1T+mrUVDSGwBtiCbg=;
	b=DMLbNoNjgWmDIdKbEiPtdPrkH+ld3RlsqcX64XXxxm2RRfUg8MvGJZ92ZgBD27P28wzVAA
	WRSveFEoJOgqWKyZQ6GSxKCLZHtGdMqV1GrwiawGsxptpJoltg8OJztjLYy2/lMw2iBI/P
	fAX3DThYJFKoqdOXrOHqge89JD7L96I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1784018779;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WPDedMYoIPcbcGvrvY5H+IQoUl1T+mrUVDSGwBtiCbg=;
	b=lyVlUAK45w4IS5EBJhNIkm2IZu+OwsxYgYOU3pgx6TZtANaLf1fDpxr7lpSfW0kNN+MAcF
	DHuo8dkcwMuEetBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 34B25779AE;
	Tue, 14 Jul 2026 08:46:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id HaT/CFr3VWphQAAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Tue, 14 Jul 2026 08:46:18 +0000
Date: Tue, 14 Jul 2026 09:46:16 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: James Houghton <jthoughton@google.com>
Cc: Will Deacon <will@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, Nikos Nikoleris <nikos.nikoleris@arm.com>, 
	Linu Cherian <linu.cherian@arm.com>, Mark Rutland <mark.rutland@arm.com>, 
	David Hildenbrand <david@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Ryan Roberts <ryan.roberts@arm.com>, Nanyong Sun <sunnanyong@huawei.com>, Yu Zhao <yuzhao@google.com>, 
	Frank van der Linden <fvdl@google.com>, David Rientjes <rientjes@google.com>, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org
Subject: Re: [PATCH 00/18] Another attempt at HVO support on arm64
Message-ID: <alXtiUdmabf1TZgj@pedro-suse>
References: <20260708031129.3503195-1-jthoughton@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260708031129.3503195-1-jthoughton@google.com>
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 04CF5160003
X-Stat-Signature: a8qsmy74hnqgi4woambk8jt6kmudeeo9
X-HE-Tag: 1784018780-399519
X-HE-Meta: U2FsdGVkX18ASUAziFIy4UawZHwLJPVO1ZGsdunMKC7y0/cRxvmhDqCpfQwLY/wnNB5qLdVeoJ1z4A1pML+khsV7VSnhS5rpH9DF1mZp0fow6S0BelIzvZwGpA3wzbhzJetTxojlmUFjFB1Hk9Ft8UbY9s0UGkHFTnHWbJIbS29dGOgvtSruJ/iwUPHhFFQDryAhGN+OM0b0/3VVq5c1VOUEIrZ3EkbGfGaWjuf2UfusZaUl2VJPg//yHnfjGfh6Hfu+To9kB8B15RWbSV8WOM/KYpGIu0uuB+Nb3c/t0380//rSVXQ+ltdT1i4ETkCliNc6wJUgEPVFldk8aVfuSwCUhy6E5xEk4fsQvr9+B3AeBURpWlxiZzM59JDCBLxvi5jwWGnjlO8IzJ/qNXBZWSGH7N8Py6eyvSjjcQou/0SSOEZ/8D7w3x+P1HyWfuC43JatXhQPIumf2ZcL+nK3GUcRkmJZ84OwYwPG5E3dcvdUNfxIy791oRrBStN4JjSOPJO29kV6pYWb0NwB1ho//l4K5/cV3eq0GIDIXZnzDSheAE7eXNtQN0LC71wpJFcASHoryEi8hsuoqCsN9goIc3TeeuVOe4xkgLHdjYIsXRRoUBhbqlbWwn/bSXCvVJ2JeH2Eh226UpaIZUJ99ceIfwz+SZ75nysq//aHPgMzBiCAhHymOUmuKUl5wxfQph5kP39PXei8zyfPltgisbk7dscOXrpxPNmhsL88DLz+naClGfnc56BTTH7WKRQ1w313+WXmVfgoKeMQzuXCZ1zbercvYFkT43XdDOL9HyoC7JQFlL8CO+/3JLCf6wdg01KxWKmThcTHX0KpY7fpFkof6U5pRltQhabir/ELibs8r1HN4i76NGN+ut3m3M+2iS8XQu7zIpTKbRpO35gAh+a8TFeFIS/DjANj3/Qj/Orf38oJuiCr7geTkxixaRtf/GEtyskYtLIgtoyQz1inHbN
 Fk7aC0X+
 b/2OoQaFjvC9ByEeWwj7tdmPZkj0j4wwG0EO083B1lOMdx7TFBQ1q55ucQc3mHXblHJ8ZNe4hwbZDXOoL9LrpRB/nAG4dAzHBnL41SwE2P6xowCBG9kwWlemsjOOBt1q4XumlADO9HSXSdNLp3cpavdJ/0Z4vtnlcssRFBctgH2jorIT4LdLOZ29N40if6TClO7BvpGEeEdVxpOn8UVqLGWmi2LsuP2oM2MetcuohRDUg7OY41FEYYyj9+1WqMYhfygnNIGa525mMwzAB+2PicPoBrmQ80hq3VPM1tTjsmyDU4ztjghr4icwE/w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

On Wed, Jul 08, 2026 at 03:11:10AM +0000, James Houghton wrote:
> Hi everyone,
> 
> This patch series uses a trick with the Access Flag on CPUs that support
> hardware update of the AF to update vmemmap page table entries without
> introducing a time window where CPUs accessing the vmemmap might fault.
> 
> By avoiding faults, the HugeTLB vmemmap optimization (HVO) can be
> implemented correctly on arm64 in a much more straightforward way than
> previously attempted, most recently here[1] (please see [1] for a
> breakdown of the other approaches attempted before).
> 
> For large-memory systems that allocate most of their available memory to
> HugeTLB, HVO saves a huge amount of memory (1.5% of system memory).
> 
> This series has four parts:
>   1. Some preparatory changes (patches 1-3)
>   1. Bare minimum HVO support (patches 4-10)
>   2. Drop BBML2_NOABORT requirement for HVO (patches 11-13)
>   3. Drop the user-configurable Kconfig for HVO (patches 14-18)
> 
> Parts 3 and 4 are technically optional. More details below.
> 
> The main functional caveat with this series is that bootmem HugeTLB
> pages are not "pre-HVOed". They will be HVOed, but because at pre-HVO
> time SMP CPUs have not been enabled, we cannot query for full system
> support.
> 
> This series is based on 7.2-rc2 (0e35b9b6ec0f).
> 
> This series almost 100% cleanly applies to mm-new, which has some of
> Muchun's HVO patches, with one trivial conflict. I imagine this series
> will conflict pretty heavily with some of Muchun's other patches[2].
> 
> -- The AF trick --
> 
> The trick is that translations with the AF unset cannot be cached in the
> TLB (see Rule R_DWZCQ in the Arm ARM), so they can be atomically updated
> without needing a full break-before-make sequence.
> 
> So the PTE update sequence becomes:
>   1. Atomically clear the AF on the existing PTE.
>   2. Invalidate the TLB.
>   3. cmpxchg the AF=0 PTE with the new PTE. If this fails, goto 1.
> 

So, this sounds really cool but I'm not sure if its correct. Looking at
D8.17.1 Using break-before-make when updating translation table entries:
Per IGXGZY:
For a translation stage with AF hardware management enabled, if a translation
table entry is modified and the break-before-make sequence is not followed,
then all of the following failures associated with AF hardware updates can
occur:

- When a memory location associated with that translation table entry is
accessed, the AF is not set.
- When hardware updates to that translation table entry are followed by
stores appearing later in program order, the ordering required is not followed.

So apparently per the ARM ARM you can possibly never observe AF=0 even if it's
cached.

And then other semantics concerns may arise e.g I'm not sure if AF=0 implies
that the walk cache has nothing for that address, or if it's just that
particular translation that's not in the TLB. Though this might not
particularly matter since we're not collapsing the PTEs back to a PMD block
mapping.

Right? Tell me I'm wrong :)

-- 
Pedro

