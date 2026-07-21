Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF5D7C4451C
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 19:55:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BDC156B007B; Tue, 21 Jul 2026 15:55:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7CF26B008A; Tue, 21 Jul 2026 15:55:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A7A6E6B008C; Tue, 21 Jul 2026 15:55:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 846516B007B
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 15:55:36 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 16E7CA0910
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 19:55:36 +0000 (UTC)
X-FDA: 85013838672.01.7D142AF
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	by imf29.hostedemail.com (Postfix) with ESMTP id 15252120005
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 19:55:33 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=Xran02uK;
	spf=pass (imf29.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784663734;
	b=jQ5SaOTIAsB0zZ+3cXhcc3i+cpFnHsniNtVfK9fyubxDbZCvdEuTZJb2Um6rXPL/ZRPIAz
	i0jwcbjXihcVKNkAGVphUtAK6P2GZUoHfsxjZ6EWKAskzdi2LuqN8nJlgwajBTeBs4W8sA
	mPD2doJuba2bIXAvw/dUDWwKqWz7D3I=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=Xran02uK;
	spf=pass (imf29.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784663734;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mHZ6KR0HBY/A+4ayC9BCwjfVh3BlnXge75QXQoZQPFo=;
	b=7prXU+37d3ZD8GZ8q5FVwtGh+bxkWHV6868S7uuhp+QM5GAtY2FrEi40zjECLL9EoE1jGz
	40a0gQ8qtv10NW3xlBZtBRdgZbMZmVbumI3N6T2xL1Ca3oMLNSVOacmxCHiFmiR2pKoDCg
	jzvWF7L4wInLrn3p7/IvtYZDbaDfRqU=
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 72DC140E00E6;
	Tue, 21 Jul 2026 19:55:30 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id BFh35W6ojD13; Tue, 21 Jul 2026 19:55:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1784663720; bh=mHZ6KR0HBY/A+4ayC9BCwjfVh3BlnXge75QXQoZQPFo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Xran02uKyC5edtPpDYP3zrYWvM/wd+TuG8TczFdXanmHqJhF4EQsJramNEgpUqMwo
	 qKjV7yxLOGcs3wwnXmjjsCK5Wsw3coj0OmWWhxSEvMj6q5BqKwChVtk+5XngQLUbCr
	 /O1lX0OhBtGD757bPtSiNIuD8gDwKolYacrfjk729yTU/wd41XvJ+Txnbfg+WR8ucu
	 ZpiWXmpQ5StCU0PcoZvEj867IEcdyNscwc/HZQrbWpF4lscz3jaXE7vdz8WjzoJQfL
	 GDpLxjoBWUV0QWk2qVOLe/DigHevMVj41j2DrfnWbCar8FMZNrvwr3ceq+FvFEtLNw
	 rekRCUCLPFqCLIs4bS3oJFRNFimbOqu5sqM4nf0pMGmLcuR9HFD3php75HDfUvDgiN
	 G3IRK97tDDj5J+3sEGwfflva1Z+sNvEsTc+mALCDIjJ399i+n5nWTNTnzk1l1NCNT7
	 JP0i3sSqMhy7J5xHbWKX0Ki3IvtL51oonXbpv3Xo8OESr1ABKFqZPkXBIXMKwWkrRE
	 YxiTGeQOVesK2TUnUn9AIBV5+Z3L52z/SIJ2k0j6W0aaosNAqJwgh897ftzD+uInQh
	 31m6kPgkYEz4Z4fslke2woWDCwHQLFhtW8IJVLJ7H12rRG/CN+c6+j3GaBs5bmc3Ng
	 XIgXGRuajM3fuCnBC+JRBOxs=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::2b])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id C109E40E016E;
	Tue, 21 Jul 2026 19:54:48 +0000 (UTC)
Date: Tue, 21 Jul 2026 12:54:46 -0700
From: Borislav Petkov <bp@alien8.de>
To: Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org, Albert Ou <aou@eecs.berkeley.edu>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Lutomirski <luto@kernel.org>,
	Brendan Jackman <jackmanb@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Hildenbrand <david@kernel.org>,
	Huacai Chen <chenhuacai@kernel.org>, Ingo Molnar <mingo@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>,
	Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>, Will Deacon <will@kernel.org>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org, loongarch@lists.linux.dev,
	x86@kernel.org, Dave Hansen <dave.hansen@intel.com>,
	Juergen Gross <jgross@suse.com>
Subject: Re: [PATCH RFC 00/18] arch, mm: create a generic
 set_memory/change_page_attr core
Message-ID: <20260721195446.GHal_OhkuBCWQjmLQW@fat_crate.local>
References: <20260721-generic-set-memory-v0-1-v1-0-2c1fc62306b3@kernel.org>
 <20260721171943.GEal-qLx4p5YbocQNV@fat_crate.local>
 <al-6aLMJONOMfW2v@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <al-6aLMJONOMfW2v@kernel.org>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 15252120005
X-Stat-Signature: 1bgn1atmemc76bye7xtrsombs5mu3c51
X-Rspam-User: 
X-HE-Tag: 1784663733-886835
X-HE-Meta: U2FsdGVkX1/uMVwu8FzwRaymVOKfJv41Ya+NVjbGypzer9f0z+6qM5ObVS7Hl+0YsSwhiIEkIVjS8o2WrXBe4B4xYYXENoWmHv2bPXvKK6ei3JESEjGK0h6cT/KBYMLlIHDpQKLBS1ITKRxiSO4wIIMxG43geniEaR4U0Wc7NtDAaKwnw8wRkfP6nkuitA7efVDDQ5exhX9iOidZjtQjvRxzaLKn2xrYBmGDgQR2T1lcEZV+bDomjfdwmP9lYPHEewNWpE741nh24VQoocAd9iLf2APTLVQDxz9cXdgs+SphDTQRyp3EKMS8zyWeWGvyXqhRLY+1P158FjsUr3THtE4bNbRYd06I5iYEmlly3EWZE+sQTKwH1xj2lGnLb0tKnl7dj82W7Cjzr8R30vR1FPidwnwEJxhQgOeqzIV6C1vETrXz2tLuxNLe/6gwpzYVoZcmhlmcwlhy08vz1bHNqOZdvCH2PoNl2f9IPXfSNyXl5QwPNKeQuHFg0+PnvYuMAnBOV/q/AjsirCO2+kPO/7aexDnJ/WoDTRY2mu//oU2SYvm+1SXNwYw2rzFrdehQAeeVtNtXC88pMghummZb1SvSiwy9EDOQMDM/OKoFQ57VdTvtUCKZ2kItQZbi9D8CNF0ghTSLWkVD+ssAP5KSQS2S7rHNIRGmmZc26sZbX+439YS+4xJQMy/e1xPAAlTkJyrTsFk1IzEZSHZ3v/YY/0+MzXUQ+A/UG2lINMZ5naEW2F3FW40scqwMGgkIeiB3jmKPmc/lQC/qikfZdFd/NnpmBAyvb5ZaIbsqq5+66gcHb0Kwn/Z85liL+yzvcZZNEoqT/YSrAhlf7M/7GuQJL2hfnWTkzV6EbryX6xHYRfMDUazHmkpnH/A6Y3KGcNwhlY2hlFUYLL6iyxtvCigb2682agy0rTZxGXXcoEENCsU/dPmkVRrSyGcjQKZIi5vcystA6r1889To6Ffbo3P
 /rRmYiAd
 5c8L9YllrwNvFsEQR6lv0x1LBqfUvqpyj1vxJEBSGadXc7Rc594/9MC52Z6FSp/Nt5df2JaraAI+4xqQcQwEoElOrsRKxuBWQvdnACzFv1JyH7RlkXiVO8kFuOAPckKavlQlChkHBq7mlXN7MeVl2jQsKWNMPtE60hQcC0XkFtxP5USnauAdGaiEQuiFWHrqVVX1moyK5QB9XRVkMLNlh4QPRDmJ34/hZII7DxPESgR5xJBWunPCiopP5/UvHJvxahiWanBInslgfgIv5mIDjek47HvJiMYq/364YmksOru1OuuhJ8nRdTh9bTzOgTr0nzgNmBo283pyeLeQmyc9MEWpfWw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 21, 2026 at 09:28:56PM +0300, Mike Rapoport wrote:
> I'll take it via the memblock tree? ;-)

Definitely not.

Unless you folks want to carve out the bits of set_memory.c which interact
with core mm and mark it as maintained by someone else. I personally don't
mind too much.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

