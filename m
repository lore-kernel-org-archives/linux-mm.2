Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7EC36CD5BD1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 16:03:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E1E2F6B0449; Mon,  1 Jun 2026 12:03:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF5826B044B; Mon,  1 Jun 2026 12:03:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D325C6B044C; Mon,  1 Jun 2026 12:03:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C81776B0449
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 12:03:08 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 37ECFC245A
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 16:03:08 +0000 (UTC)
X-FDA: 84831812856.26.582C425
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 933034000D
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 16:03:06 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VC3x6fPF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780329786;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pHMSgSf2znVrwXRiWGWSRWdLj0MFPQf1FtqfyRnjDN0=;
	b=DFRlsdzSf4gVU2rHfvF/7GnOFgv8KFwbs8e/eEgqFYcLbuhw8+Opzf/ACoYJmyH5aT2diw
	+0N3WmPEGJT6sIF89WHKx3mQGYbtYderRozVEKc8cgaaLYxrtOWQJJy6Zx3tvcM4k7lsyB
	ut9xaAeRjnHGZ/E3IH0oXVvq38pvL2w=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VC3x6fPF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780329786;
	b=53DPpyrPuxJGN8BS5q97E7cj6hm2oH3Ot3WLN9gQCKCtuOz0o/TE7hZi5wbHQ+JpEJY5UI
	lVo0rq5lZ+FjdCUAgwkxgJAFXEEa7xb+gWUviS4ZE7aHBmde/DmvchkB5gEFUztuvNwQiA
	T1R9V2rdM2gywNnQrHLZjh1eelUGF1k=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CB00A43EC7;
	Mon,  1 Jun 2026 16:03:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BB651F00893;
	Mon,  1 Jun 2026 16:03:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780329785;
	bh=pHMSgSf2znVrwXRiWGWSRWdLj0MFPQf1FtqfyRnjDN0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=VC3x6fPFvWYvO9xnXUOpzln36PbDa6T/tfMgfMtX8Uc+esP2g4EmculOj1imcM8CB
	 v8FwD5Nor/dCN13aP/dkTvK90MPkaf2P1m1X6G0OCQzik3ulVF6PrF7JIJLMb9oaI9
	 UnGQyk+rzNiVk25kO8chc3RVB2dQfBFIr9gTBSyrk+eniu8cmtfPhfXkcobEf27rOX
	 zM6UB5YM2KcxUBPCxQA3kDGViQodZYzBIiIEXvDzzwmZetyZqZtbSy3YG/4bHQdves
	 IWGX/pmXMM9Z3aXSAwv/otN1iU81fOcBulxnuv9FsqsyDC7jvmPTbdsb3qCvl0/i/d
	 PnHpdBXb+TM2g==
Date: Mon, 1 Jun 2026 17:03:00 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Liam R . Howlett" <liam@infradead.org>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, SeongJae Park <sj@kernel.org>, Balbir Singh <balbirs@nvidia.com>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Wei Yang <richard.weiyang@gmail.com>
Subject: Re: [PATCH mm-hotfixes] mm/huge_memory: use correct flags for device
 private PMD entry
Message-ID: <ah2tA4M6UWZanW2J@lucifer>
References: <20260601083044.57132-1-ljs@kernel.org>
 <cd8b6bb1-5c42-47e4-8773-2c301a029372@arm.com>
 <d30e0d87-69f6-48d4-b3fd-6e6b87678f91@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d30e0d87-69f6-48d4-b3fd-6e6b87678f91@kernel.org>
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: jpw9s3upyjddnzkbsrqewu5zkdp5qd3i
X-Rspamd-Queue-Id: 933034000D
X-HE-Tag: 1780329786-629202
X-HE-Meta: U2FsdGVkX1+XiCRoh1W3cDhIraqI3T4H1Oi9LO2dgmmRPZUO2wVAXINERkkW0LLz5T8k85h53xKY3qMhcGPG7yk/1A2OYk3U2RFWejm4eK5zI3aCyjuhk1+u//tvNhz27oJkHR0D2aSw16zC/5lpgaKgynu3Y12KCN4TUsjkkLywlAC/lpCQjLrUAf0z5SXWPpoL1wUu39KQG+wRwSUFVisQ/roO/YIz1DG/rt7m+f7OQa9twlfOZ5AmP7I4fz1dw4O0QlP3wxAxdw8PrbZAK4iH7PJCo8IAd9yMhxsRpQ1lC+RSYzl7xMpPidnqN96dMiI+Zi1yDKfCOM5YHfixQ3jPU+sdRGfyef1ccM6rRjDmVqejwzV4hHg/jhPpxPlalN14YFQ9cO7OKiv4Wcy4FoiawzCpvVHTz34hRo306m8oAPrpGJYTgnXGNiUZ4uq9IOraXMWlSY6VqE1crgPaK0/BkzHoKMJr06YWhMOHvIzLmtuPvBeNGuwtGEjogj817zuzUVnVI74E4HYoe6RlQbYc3OYWTODvkP1h7Q8up3goWYkmQWetPeUDGe2s4/dM39xxiPAkGmDmaTrBdYnel3HYs2DUZ2wjZPp9rJXQSfaFUsOcPAyyboryOaS+2u4Utym1VWWm2mbiZ38ZOe1i2YjZ1bSQNX6mHGMca1IZEy28/5ETrp48zJreoUVjJ99f0jc8C/bHpDmbFGH2mOzNoLR3NOvKp4fLAYjyIKshfIbMlmQ1weOgVAY8kjerTMNmWuLad/vz9mKo+ppArhIbKNQ9FT6PSdN3tM9ENRhKNrURyN6ZTwvfg29VfXkasoEn1EYfW8HDDYqgcHhayKIetbQjGlOEv5unbmXBK9fNDzS+K7/RBB0r+RCIa5jlGz0cOGWYJhtbMDSS4n6mI2dwLxeFhSojUbuFrGwccV2FXE8c0ZBt8Sbn4sbWBpXRu2vULhCpG543k8+JhYMsgvj
 eVX7MABo
 0xpmZjuf8ZZRCQ3X3PqvJ5UxXlLwJe7BrdGkobZxX0y3cL8myLCVd9hs1uD4c6fhN2BluOmckpBu62a0fas/ns4qAtIgFR3rxWkQxWC6ln/IYSjvrUqFRmg6llv5PbkfM0INTU9GdL1LIypq38I13tzwu2xjcZIDfOcaA8JRKUSg5Bn6gcZZteIyqgCwdhEC9mgRUzCwaA3W5nRcNalWhWcHiOmJh/pQ6G3ynI2ZuDwcViw821PQkpCH6KIXUtsNtfkY0799lmtOHLuVXT+XX3tHqmrB0mOOL/XgveDwuZBsRv9dGVV9hkA1BrcknvwLEvXEtCEa3DQGISY6fNfSJ4KxIGs8NmaafN+kPYQm6BycgLTFsk9H2HxK8try6mO9gVyYakyCcVwDEBUwYxBBWMYdxGbpOcItP2fveF3wL/SsFh1ShAJTy0FLia54zksqZ/7Wf7SyoXoaHgzRuZw+MDA5tQ8q5wB+/1MWR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 01, 2026 at 05:56:45PM +0200, David Hildenbrand (Arm) wrote:
> On 6/1/26 17:50, Dev Jain wrote:
> > Sashiko continues to find existing problems :) What do you think:
> >
> > https://sashiko.dev/#/patchset/20260601083044.57132-1-ljs%40kernel.org
>
> IIRC, Wei is already working on fixing what it reports here regarding
> try_to_migrate_one(). So it's old news.
>
> https://lore.kernel.org/r/20260508013728.21285-1-richard.weiyang@gmail.com

Thanks, wasn't aware!

But it's also irrelevant, 'existing broken thing' has ZERO to do with a patch
addressing something else.

I kinda wish Sashiko didn't do it.

>
> --
> Cheers,
>
> David

Cheers, Lorenzo

