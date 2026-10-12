Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C312BCA9ED1
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 15:32:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9AA406B0088; Mon, 12 Oct 2026 11:32:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 95B9C6B008C; Mon, 12 Oct 2026 11:32:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 871606B0092; Mon, 12 Oct 2026 11:32:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 673826B0088
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 11:32:30 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E3C5940F95
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 15:32:29 +0000 (UTC)
X-FDA: 85314366018.11.DEB0EEE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 59D19160007
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 15:32:28 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BLfowVUD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of bjorn@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bjorn@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791819148;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9RalS/cTcqwsvzfIqCagLYWCk6dkc4dqFyKF+MlULZ8=;
	b=GTM2NLSlKf0tcWOCYtMxkhTK2JVHuu+swGJXjxtDXFNjlpjoe+oUOlqepXCAuGqh4etLWh
	jO8Th+adgNpfq6wsF5tsOfn20XZ8kliPiHtPCyBnoJk0iAlQLZ6tBg+kmbGXpi9QZ4Pdgh
	6KoOSruCAVinP5JZpyAm5hizDr/aMe0=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BLfowVUD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of bjorn@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bjorn@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791819148;
	b=0bGVfrG8mG4ZDQAqRdIzuo4rCOdn1aes7OaRCuEMseGndPUKtQvSJgJkt8BB6c59nBbD9U
	5wMhzQ65q5iGgql3VB4u4fni12QFp7/Oh/uKbLp6Ay3AxCIEc6z9xTVVopuaOE+Cn0MduM
	KhNE9iZ6g/pANioSgfBSfdgfxnmd5D0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BDC2A6020F;
	Mon, 12 Oct 2026 15:32:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 932731F0089C;
	Mon, 12 Oct 2026 15:32:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791819147;
	bh=9RalS/cTcqwsvzfIqCagLYWCk6dkc4dqFyKF+MlULZ8=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=BLfowVUDFCXLcBE+jUBEJcCE17njSGG/cEAXjI9SvlCmRgJ0RrMUebOvIcBAL22BB
	 A5D1Ri6caBnDzMOyvw37AhfMKib7RzMuriZqCSELM5q15v3sxBzfQ8n7TqBMg1MALg
	 f3P+U+A9SBVHtbrlZkYfADTjPQJMACeNex5p7EwJsb/Q6fyY5ByM1kTOML9DLEjduS
	 vg1xLLhUq2LLv9TqJQ7596pdNj928fQNhattCPpvQEci98nbFuNBOI20aOTmMGRjbI
	 iabjxCy/wtzovR4naUlpBT1NouVwoL8cfFW609Er4QIxLWEecFqpPCxGaIiRJ9emGT
	 3iz/OYxGy2RzQ==
From: =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>, Andrew Morton
 <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>, Oscar Salvador
 <osalvador@suse.de>, Dave Hansen <dave.hansen@intel.com>, Paul Walmsley
 <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou
 <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>, =?utf-8?B?Qmo=?=
 =?utf-8?B?w7ZybiBUw7ZwZWw=?=
 <bjorn@rivosinc.com>, Catalin Marinas <catalin.marinas@arm.com>, Will
 Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, Kevin
 Brodsky <kevin.brodsky@arm.com>, Alexander Gordeev
 <agordeev@linux.ibm.com>, Alistair Popple <apopple@nvidia.com>,
 linux-mm@kvack.org, linux-riscv@lists.infradead.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org, Muchun Song <muchun.song@linux.dev>, Muchun Song
 <songmuchun@bytedance.com>
Subject: Re: [PATCH v2 2/4] riscv/mm: fix hotplug page-table destructor
 handling
In-Reply-To: <20261010112457.49485-3-songmuchun@bytedance.com>
References: <20261010112457.49485-1-songmuchun@bytedance.com>
 <20261010112457.49485-3-songmuchun@bytedance.com>
Date: Mon, 12 Oct 2026 17:32:15 +0200
Message-ID: <87ik37aq9s.fsf@all.your.base.are.belong.to.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 59D19160007
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: 9ng1mn6dm8x7jef88jaxr3og4gtfs1y7
X-HE-Tag: 1791819148-333485
X-HE-Meta: U2FsdGVkX19T8Cqpvw3p9ZZ3E8WaHtYB+uH3JBZSBgDDqndz4dYXGVvmYTokeFUptudE5UyKBwDGn6u9Q77i0//q0AHqRnugZM85WtYsfPokighpyow1p2Wk7LgZC4v/DXrgKYFO/0rdRtB3QBTbMHQL/biQIihfA2hlSz0ThKSXOBG8JwZuoungwG+DkRdnD2N/FJtvk0drjyp/Q9WULIH6ndhuN12b6+OIC6GcWIGGMmreRIIwMYr4wAV/jlCHu2zRXkBxxo7BqrG8PDqzed8N7kmajwX8KpOM0HBZ4h+SF6T/iHDiGpBPvCtNyqZXjQfvgwuBCgbOWhX9JSkC4Au4uS1BD/WfSYn44OW6aHYQjk4kamER69KH7meYhSvaEK3nMxiVDwqR8E4xzrPxStspNRBkxMhHsSawJ4xYLc6wJYKDKYxj0KYi5BMO8+axJZvBt/6/TfJjHs0f8hfdIdX13LSXzbCn9ocuDhRDDZFSZDw0Gg04/4JErAB3x8YTvhFzNf8G7NvgMc4wlaxxBdYpL9m0VCs7uuSWgUBKILIfmFYhno/caEd0Ibx7ab2r81kXk7EB1jX+6zhsB5+zDLBWxdikYqWegHcnbUCh8h0/ON7En/NxBy+7t/S1yInI/dhqaOKFRSTjBPKfceDfaOeUz+X/WOD2Y31wSnu2Ko0WoNzWnlHc810G/fLi43UZRRy2hkPW4mgq31YzyJNU5QLwdfF5xvh7z7rpCKUnZOrPYo+Db09k9AS8g8mrcyuI26SLOYUAqZxlz11Y4qZ+ltxrNKBIPK9y0j5dxuPFf0jf3p8icaOIj2ahyAG6UkJdvrOj6beXs8ryfMdcvIuib4CVdWlbFE/g48YF87bGv9NqcMbYbJXCSS3r/FHAyUI6SSkO7zYj6GO09cWanrtzHB7wRRP4csuYkA2ZaXX5o+RsHj++5lPzF+M9wqT/7hjxT2GapjjQTRpk1PQi/wD
 h1RwGjkE
 PHMt9LeGgVB3D2CX9EQ74BgRNYiLAKa66kypf1NH3aGS1kLUnk+Vi4HBNxBoW/h36yu1Wbpcol4Q+jno2CEq4btBeU9BR6GpxmD0RBA5UDjW9IUxJFmD64V61UrVG/g4pgrD1i3SBlbA0T31NEMkK9w+D4FAH5rI3Ayw6n8EjNu2Guzl+eZyABCnwi0Mjt8Y9W7FVTsoOvOyjzadiDGw0lhf2r5o06gpM8HEyWuUYrPtMcqinWFJyxv/Y0ptY3NPjCyf0hzJUEoKUmwYC2nIVzOKsdU6QGGANWE9Q4UAL9KgpytQ279ubTsYhwbn1ZEk8aEytZIexaNfZVP4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Muchun Song <songmuchun@bytedance.com> writes:

> RISC-V uses the same memory-hotplug teardown code for linear-map and
> vmemmap page tables. Late linear-map allocations run page-table
> constructors, while vmemmap and early allocations may not.
>
> free_pte_table() unconditionally calls pagetable_dtor(), corrupting
> NR_PAGETABLE accounting for constructor-free tables. free_pmd_table()
> avoids that for vmemmap using is_vmemmap, but mapping type is not a
> reliable proxy for constructor state. In particular, it becomes invalid
> once runtime vmemmap tables use the normal pgalloc helpers.
>
> Introduce free_pgtable_page() to select free_reserved_page() for reserved
> pages and pagetable_free() otherwise. The latter runs the destructor only
> when PageTable() is set, handling both constructor-backed and
> constructor-free tables.
>
> Fixes: c75a74f4ba19 ("riscv: mm: Add memory hotplugging support")
> Cc: stable@vger.kernel.org
> Assisted-by: LLM
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>

Nice!

Reviewed-by: Bj=C3=B6rn T=C3=B6pel <bjorn@kernel.org>

