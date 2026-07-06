Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD5F1C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 11:35:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 52BEA6B00C6; Mon,  6 Jul 2026 07:35:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DD256B00C8; Mon,  6 Jul 2026 07:35:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3CBB46B00C9; Mon,  6 Jul 2026 07:35:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 140FF6B00C6
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 07:35:26 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7B768A0381
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 11:35:25 +0000 (UTC)
X-FDA: 84958146210.25.826DFF6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 94E6420004;
	Mon,  6 Jul 2026 11:35:23 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LnZg5pDE;
	spf=pass (imf31.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783337723;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0QHNamPKjhT26TDn8HJD8lZwpsva7nZLItuVVWrKgxw=;
	b=RP/NdXuT5UHMTLLZyou/lM7G2JKmFJGgqrEwH4Ir47g2pLmPB5vUZNdm/RhExaw9R6zqEe
	HFlXXnocLpXwD+kIwIuMW9SswgGBlMI/jOI3tl+RCqIKlP5S1u5/UbW30oORYrZOzetzKL
	Y22rIE0qOfowEpA4zxhkbVzNeDPHqIk=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LnZg5pDE;
	spf=pass (imf31.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783337723;
	b=ngHLr/J6DdwoskAGtPfllunvmvvEyh6vOxZlnVwA9wR09ACTsjHPYwmDmYx3NIizNETrZM
	y2Hp5XEMdTWp+02WSAXQ88vMIaZ0v7xSLd9GUGo/MjCAdk6dKW36tAnK+KGJnopGR6fl3A
	9yP2Uzf2SBDwW/LNZlFNpLK2Ti1eRFA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8588A40BD6;
	Mon,  6 Jul 2026 11:35:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AD121F000E9;
	Mon,  6 Jul 2026 11:35:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783337722;
	bh=0QHNamPKjhT26TDn8HJD8lZwpsva7nZLItuVVWrKgxw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=LnZg5pDEl/YbyVjvwLOdIOB1fd9xeufnLnBVYTn0yFjkwQQIcH/hNpokUZSQy81nI
	 Spk/ZSjZ9g7PzB3NrgPGutQ6yasP/oh/KcXyhOA7G+NNoDKfyVkahcCARefSEusPPd
	 9ESC0k1S0n21ErvIbvmbVNonMDp9tDga79CSgtxsK+iQDTZETBcdpeon56Z51rmBuq
	 Pd8iZquPGPJmc1tKS/jqug3yEQQV5ne1CjuIlC/S4fVHYPp5DPp3DhY+Y1/m+BphcR
	 jB3agjkuOkEyqA4LZShAiXpXsEVdLsZxMJE4MIAH6qAINS4fzz5Y/z3aMvjcdGDBLI
	 JQJWBfcaB9XSw==
Date: Mon, 6 Jul 2026 14:35:14 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Adrian =?utf-8?Q?Barna=C5=9B?= <abarnas@google.com>
Cc: Brendan Jackman <brendan.jackman@linux.dev>,
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>,
	David Hildenbrand <david@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>, Christoph Lameter <cl@gentwo.org>,
	Yang Shi <yang@os.amperecomputing.com>,
	Brendan Jackman <jackmanb@google.com>, owner-linux-mm@kvack.org
Subject: Re: [RFC PATCH 3/6] arm64: mm: fix restoring linear map permissions
 on execmem cache clean
Message-ID: <akuS8uhjPBhI5mzZ@kernel.org>
References: <20260611130144.1385343-1-abarnas@google.com>
 <20260611130144.1385343-4-abarnas@google.com>
 <DJ69RCVRBO0Y.3JCYSW50IC4RC@linux.dev>
 <aiuyoy8Kmr9yU4GM@kernel.org>
 <ajK6w3YTFpVaUl3v@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ajK6w3YTFpVaUl3v@google.com>
X-Stat-Signature: 3hmcpga81bgh7h1gtdce4mftqhwfc6j3
X-Rspamd-Queue-Id: 94E6420004
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783337723-73095
X-HE-Meta: U2FsdGVkX1+mqkFno1SJuOExmm58HkAa5YIrLIojAr4eemK8hB8aDKkEBf/iHS4cgU+6ZSQHq1hKo+zq9eHYLUswyFS1s9S9ueLptG6pAdMgNwMr9/rH7DXASUoAJ6pY1mn1AJPc4zk1mk/OKIZ8c8Xj/8Y/T0T0G8BJ1Hh+3txyk9+fBjhStVEPJdvyxo5aP1R1Ac8bdbG2PnWDuNCvwTnrs/18+8M8Dkl0E982YBJjUyWTsAv15q0ffzxA+/GEtys7sQHfSRKcOYjjfGX5xYy/gj911vPbVSJiRK/vwcp7o8zzAYQMd52BkRYbFmttGxRgUVBGb9AY3WcoOhn2YhX36ms9rHdOu1099vX8RhQM5OEIbj7k6SQIOkxLChilRJNgVWac2qlaT6FuhkNLAFY3eJDyaEXm8oFYhsHD4DzRY9pCmtCtULSC748nLYPftmXt4H3qD6jPwiFFn7RVRpCezcT4M9pCKyDr4lMEvPFue+IQLPdH/3mw67ZF/X9cnPWm0+7LHbS2Tmx4sMeQlKxEsAY7bm2WvFuQMUP8XRuaWpHQTd+ND3NIsq9n5bX8HctyzvhOebwkAcOPne4dPoM1yyl7xP6O430Dzm/Uc3dDEuLdE0Xh2iXUGL/WiHWf4cY8WeJTUOASojCEX6KonDxoa0YsXHt0PI2TGQOAZYa1TyE9W20d4i94fM0GSsFMN398Lcx6R5YeMB3ZZtP/Th6VclAIcPzdXy6DKyKMfIjY/C3b9oCroI1D7fVUA5+XFgqytlnaJl9Oo9V7mLTVev0k7T5XlKE9Cz8ZpM6oP5fOKhO5QRAOIupD447yd8SD/zKjdPO1qUZLEEeMPattyGipwmQH5GOX8nKtHSvhAQbOvp7X1ewdldKygdP1NFJsp7NPKsgrpuXNTrzgXZ7gFHdq7vcCi6RpwJpbaU3LLfRjeiRS84chGDK8CKziJQAsnX9oIXBoqJXj1cNR4Eh
 SF5rtDJA
 zbkwWMeZo9dS261FqXezlIEeHWmyfvC/eBWr4s8y4UZg+UnbZ+uyUl8rrx9sFEvH0vjHXNOKyeZTl9Eq7oRsi0ekQ6bHQ5R0LZK4JH0q4oHN5v8P+TfpIAz1y7GX7iSUhsdZntUehCXwgPwqumlkmptbU7ZltOykSmaXfowbyvIMIkrKeAQb/7tNsT57F5vCcpWiDRvHgEyjQftFTNx2mGuMPuFc8RRgJwTUz5gCJGl5f7sjIHzkrHeM/hRSmC5Fgw9Mfy7n/QNR4lSxqMiVa07Bmgtb9BafDvHajwTfe1/wzyLo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Adrian,

On Wed, Jun 17, 2026 at 03:18:27PM +0000, Adrian Barnaś wrote:
> 
> Following your suggestion, I can put together a preparatory patch series to
> refactor the set_direct_map_* APIs to accept a nr_pages parameter. This
> refactoring would also allow us to drop the redundant set_area_direct_map
> helper. I could then rebase the rox_cache series on top of that.

I've been looking at something related and I was already half way through
adding numpages to set_direct_map when I remembered this conversation :)

Here's what I have for now:

https://git.kernel.org/pub/scm/linux/kernel/git/rppt/linux.git/log/?h=direct-map/v0

This is only lightly build tested for arm64 and x86.

As this is WIP, things may change there, but I hope it can save you some
time with your arm64 ROX cache work.

> Does this sound like a good path forward?
> 
> Thanks,
> Adrian

-- 
Sincerely yours,
Mike.

