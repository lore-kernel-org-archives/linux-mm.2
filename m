Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 993CAC43458
	for <linux-mm@archiver.kernel.org>; Sun,  5 Jul 2026 07:36:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1BA746B00A2; Sun,  5 Jul 2026 03:36:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 16A066B00A4; Sun,  5 Jul 2026 03:36:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 080226B00A5; Sun,  5 Jul 2026 03:36:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D1B666B00A2
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 03:36:04 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 332E9406BA
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 07:36:04 +0000 (UTC)
X-FDA: 84953914248.13.05096E4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 8F1C340007
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 07:36:02 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=FWr7oYXO;
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783236962;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A6ZkehhfOr5XXJ3jery3AcqU6u9rwntx9neKtZ84pmI=;
	b=gxjpFAUfcVzbVIZe5b0lr+4Sr2MlMAPf8dWh9jopsqMQMldnlM6rEwRh/au/LXRR7LotKC
	yEzUXxEG4A80+f65i7f+7mz7utD1Ah5nJwPjK2lnc1XG3pu8TH7P+/GMfVAFzXiSD8Lkoa
	PwjFTS5HywiybwcyX8dQMbNyzPZ0zAQ=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=FWr7oYXO;
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783236962;
	b=a6ztSkg9rdEryTRcgQP9uFBBa7dgE3UY7REMHXNqU69fj58Bq5TfEGjj7CLHaGTqHEG9ns
	cC7pxcQWqK/MnAML5zkhjj4ZQChhCBJdQo4Fgwi8hgBf1tw1eq0XQiT3Yq3Si6EUGVXxd0
	vtO/R1MgqeiwcgY/7UGhbLKG89IUwvw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AD21A60051;
	Sun,  5 Jul 2026 07:36:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E68261F000E9;
	Sun,  5 Jul 2026 07:35:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783236961;
	bh=A6ZkehhfOr5XXJ3jery3AcqU6u9rwntx9neKtZ84pmI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=FWr7oYXOt5Tp+K6Ek8q6APpXSMD+p/aNq4SvRIWBniP6sobBE8u2g/45GuabtZ7Lh
	 5E6jKvT6FbQ902LJvZk8l9k4niP2mOqpY3EAy0PXbjEdEmkzyqGxqmXJfvqHOtrnHp
	 7W8TPuCgfYN9bK/6++23sY3tVDsVYxqEXnEpRnKA=
Date: Sun, 5 Jul 2026 00:35:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dev Jain <dev.jain@arm.com>
Cc: muchun.song@linux.dev, osalvador@suse.de, ljs@kernel.org,
 david@kernel.org, liam@infradead.org, riel@surriel.com, vbabka@kernel.org,
 harry@kernel.org, jannh@google.com, lance.yang@linux.dev, kas@kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, apopple@nvidia.com,
 rcampbell@nvidia.com, ziy@nvidia.com, matthew.brost@intel.com,
 joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com,
 gourry@gourry.net, ying.huang@linux.alibaba.com, ak@linux.intel.com,
 nao.horiguchi@gmail.com, mel@csn.ul.ie, j-nomura@ce.jp.nec.com,
 pfalcato@suse.de, tglx@kernel.org, dave.hansen@intel.com,
 jpoimboe@kernel.org, catalin.marinas@arm.com, will@kernel.org,
 linux-arm-kernel@lists.infradead.org, ryan.roberts@arm.com,
 anshuman.khandual@arm.com, stable@vger.kernel.org
Subject: Re: [PATCH v3 1/6] arm64: make huge_ptep_get handled unaligned
 addresses
Message-Id: <20260705003559.8b124d2b94b685cc2e4e77ae@linux-foundation.org>
In-Reply-To: <20260703114202.365553-2-dev.jain@arm.com>
References: <20260703114202.365553-1-dev.jain@arm.com>
	<20260703114202.365553-2-dev.jain@arm.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 8F1C340007
X-Stat-Signature: 3cifjobuf5zgatnc5jobx786pr8tbh14
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783236962-984912
X-HE-Meta: U2FsdGVkX1/WV3OuMYJk7TrQlUmN9AK1CzGppTL/uxELm0wTHRw6PeggFNeZGURmslvjHyWyJh33jHw1IVPybY6bhmiILnxCoY4hhFRqwurqhyroyxf9QUibId3dPJ/Fd8qiOO7jXg7DvCiWIt471H4BXVarnp/ezI+9hjwU3qNeGFjp3Euk+Ce4YQ1KeYx6OGSIcWy4pB+rFQvXcUDQzJt8lR3m3BGAegcCj2WwCXCP+0QolfHrKUyUEStlT7Th1SkP/04EFxKTUMhmQGgP9zZmrM/4rQGzKNECq1VeB9XX4R5MPqBTeGerBFjNZobRbJkGUJ132soe/hnnZctjZ2v09r5WOrvLY0J9tI6pTITnpzTu9Mz457SNioj2mfUxy3E9I68zPXtvkDzh2RpYwVlsyuAFx0ULd8P8nCeofBKIe0s8Tg54mP5eqYmGYXsueQHuLTAReacoCG0ihKFmuYimM3Qn/ecJYR0s9nSy6rDXGsm7Mf9JcjXc0RniylzZOKK4WP6JcrEwX04uP1T1yDDTaNpxm5Da84IE1Uw2G0XCyS3vbqV884LB16ilO8CqMl3hwOAnQ59uvNU2GHTLog1eP2T8xYCi1kQl6FS43NoAOEnX3OS0aUzAUa4LopeaMib9ZAkcLb3dvyek4leC+86mjGjhvCo4Gyo1K+SD7H2C8GJSOYTFrKQRu5hKBV3DgdGfCKTdZZ6Duwgo0dYTeS6gRUx8nCyAT8fJa2yVtyTBrhAHYXrCqa9qoo0g2TDM2cYlPjYg5NEYNI+mUnBkLzG3AwVtlVPHkJxyIVzIG5RcGY1oIHB2Kyr9hcwR1Rbem6zrbyshOAmIMBMApwdlVyAq+wYvC6LmV0MoT7EpSxMOb8wLL1kxfAcH/5a38ua2i2xZVXNsUuRxeB1U1WHI56QbKRIFyupgN4ZSzDiKVx5MuJ+pIwVPLTWOd9fPAhnn2gK+ZVqVn09dchpo51j
 bGqg0erB
 LNtkQkp2l9gzps150/UUdSn08uf6T6kuZwtybrxgGE44dq9qg+GlTQKeSfeV7KKsBliTA7DQT/YlfSevt/AQPMFvNYVZFFgDVvTkdjZt/useosAD+5vrAmQ5RCIhpnTuG9qhFwAsChHete1Qgn2LWsH/3KtfxHmAhUMGrL2+5xALvxxdHxteprc1VxY9YSobNG15rqWK49xZZ1KIBbQeOIrLeyycFAdofIJjvwJWBudnLV4WmX2J8l7ckBPMSYUvQK/zwOYyh9Rb4f4uOCTKzVza0hbZ6qaFDiXuAbVyznnBi0qc/GI+43MtxeZEHUNNytMWFIwutDkpaK2TA/1ydbBH69aw0QJfpUvT5Y0PnGfNvkrt256iRqTMXRpFGhDvR1hQXyBj40uxwIDfHyVZ8JwEaYcAKHI9lMl3JbJROX49R+w77wrrDrccLmmfu3BzM9zU9z3a/b4RSi5g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri,  3 Jul 2026 11:41:54 +0000 Dev Jain <dev.jain@arm.com> wrote:

> huge_ptep_get() can be handed a virtual address pointing to the middle of
> a contpmd/contpte mapped hugetlb folio (examples of callers are
> pagemap_hugetlb_range, page_mapped_in_vma).
> 
> The arm64 helper rewalks the pgtables in find_num_contig to answer whether
> the huge pte we have maps a contpmd or a contpte hugetlb folio, and
> returns CONT_PMDS or CONT_PTES, so that it can collect a/d bits over the
> contiguous ptes. We can falsely return CONT_PTES instead of CONT_PMDS
> if the addr is not aligned.
> 
> Fix this by aligning the pmdp pointer down to a contpmd base before
> checking equality with the passed huge pte pointer, to correctly answer
> whether the huge pte is the base of a contpmd block.
> 
> Fixes: 29cb80519689 ("arm64: hugetlb: Cleanup huge_pte size discovery mechanisms")
> Cc: stable@vger.kernel.org

Please describe the userspace-visible effects of bugs when fixing them.
Particularly when cc:stable is proposed.  Thanks.


