Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ECC4EC53219
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 19:27:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B27456B009B; Tue, 28 Jul 2026 15:27:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB2226B009F; Tue, 28 Jul 2026 15:27:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A71F6B00A0; Tue, 28 Jul 2026 15:27:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6F2C66B009B
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 15:27:31 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F08A7804BC
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 19:27:30 +0000 (UTC)
X-FDA: 85039169460.26.737A5D8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 3A9BD140005
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 19:27:29 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=npNpxnBn;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785266849;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3T53nkSM0LriDO57TXrJ9tCrT/eYFbVbPL/BmAKuvLs=;
	b=cs1UKtoA11Jwt2eN7ELCoI8RZMU1o8gdq99txaEY/QpVofSYPV6xRD322DgJ+yFpxBxwqD
	SMFGhoxPfwqXTEvZEfdkEoD3Ce/2j6LCRiuRdH1I5w28l1XwYALh5yiiJ2tIVHu43RewYS
	wJPrazUkw+w+niSqkgXqaFNpylb/+vU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785266849;
	b=L7l0i/hFnY+Y/ZVwOsECtBReDFFzoZ+qxmOAmVM2ZwsT/78KdW7GmaDf+ace2TEMVJy5zA
	ISufFgwhyF6yG60FVeEqgdInHelajaSVO9kPc+IQ4kKuxsg25A6uHPU1RuVD+TmKufYVfP
	6VorDefqWV78iHrtW9ZDASBtDaAukqE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=npNpxnBn;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AC43E60A96;
	Tue, 28 Jul 2026 19:27:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9844F1F000E9;
	Tue, 28 Jul 2026 19:27:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785266848;
	bh=3T53nkSM0LriDO57TXrJ9tCrT/eYFbVbPL/BmAKuvLs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=npNpxnBnptW32mr1opFXlD6md1e0BaJ4UMjzmct6fN7fPtzHGBunhG2nxgXShtGqQ
	 g+mEculF1YMxQFVbEQQVZOH1k39h1NYUCcrGQxnasNo5MS62cA4r5arLuZRE85H+LX
	 5pdMoWpAZBKG41SNFgC0Wu+Mn1U+EhcrQJpIndAHdSrQ8c7pnXKlpLb4EdlZmZ6Squ
	 N/zzT3YL1zyPVNGdZmVucXM1P1cw8tqc+qlz9MPqOqXl5a5xlc5Y27/XOq3OWZJoOn
	 pdqad/c5QjSYamfcVKzAZBDXWtEIUO9+PMf02h1RWw02KLy3IrprcR+dYj2qqHFeNo
	 BOCSJK4tVjYSg==
Message-ID: <aefa7657-02eb-4fcb-a5ea-42771b5a9450@kernel.org>
Date: Tue, 28 Jul 2026 21:27:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 4/5] mm/rmap: refactor anon folio unmap in
 try_to_unmap_one
To: Dev Jain <dev.jain@arm.com>, akpm@linux-foundation.org, ljs@kernel.org,
 muchun.song@linux.dev, osalvador@suse.de
Cc: riel@surriel.com, liam@infradead.org, vbabka@kernel.org,
 harry@kernel.org, jannh@google.com, lance.yang@linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, ryan.roberts@arm.com,
 anshuman.khandual@arm.com
References: <20260713050050.1017741-1-dev.jain@arm.com>
 <20260713050050.1017741-5-dev.jain@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260713050050.1017741-5-dev.jain@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 3A9BD140005
X-Stat-Signature: 8q3mpnmg8zh3fanc94ish81kwgepu1e6
X-Rspam-User: 
X-HE-Tag: 1785266849-526904
X-HE-Meta: U2FsdGVkX18th0NnGL2Npbs7x5HKInqr57C6+ZFE3JVVIc5YYOWHZ1ux19WjluVYwsyE0VaHhRKX4aRsnS8bgt3uPAiVBq+GEi/+O+M6Bq3jN1/ku4YK8yaHVRwLwtzx2SLXyEvjnIP9v8fwMjv00akG9H9PZyo0Qaxv2DMqX2yBNUiOGcLKK2KkXICjGPlEu5wwlILtEgSMBu5zAsbLuDjl+k46JJa6F6O12C6mLCXWpuWpvr3AK/lJedKKrxQeV/eOOGrxjd4gQIeu/qZipR8ItYrZoXWSqIEyljlk/5DVi7nXnIpgwoV91dbqMLYNhFoQmBtTDAuJEIvkWiydtGDiO39GPTeNU/vOT7Xa/q9lY2ZK9rjOf6BSVLgskpP7XroqlqAL+8FE5e+9BRCtM1b/h0xfMtMXKmBqrqttJtl3zEEungZCEaibc0XGQBDN6+Kct7ejOSzcp1HIuokHQ4V+1sJJPwT9K2QjCpjcJHPqkjFZ9qFTGbbpnEdo6et4jApyxgtFX7ugz8r77wpSc278artO/KgLBgObtEppDTKHGouYx5g3X3jteWFpHXgD3qOFB7+ye/AI+kcTnfWEUzHV8CmkU+HQHmEneYpJ68CM7Imwb1n1753WL3SSGb8KxUEogIA/kvQezDi4VFaR2gzFfxo+TBGBV+BW8Ug6nzUxGPLPzDwrFtt2RYIF8gQUgPQcCNg/w34Wdiwn4inuWwxVh8zjDTdnZ1+egHPpg/iZGEupm4X2mXMaIuZGf2dle5mT1+G01RRwjijLgWrxeX8vKsldapjivWbUIWTrf6GpKlMbgO16cLW+U2yaP5A5xiaa1+Fr6AyxdxDa+9L+FoPVxNKGYVOGkCJ58PPpk4U+E7mNr7f3Vu/1zq24jjr4D8vbnAAZWrtWmSMxdKjbGVq0qX9j9TolXs0+oUgKU/Syv/bxuoSnrHZq0jQ0mHhjgTfXlWZmr3bd5/Lz60X
 ZkJkxN3C
 a0p6DvFqUBFRPmN+QwsX+FJ9DM3zkWSqFTGUJr/RTHVEjsXNj/5W8rexbQATuTybZgAssJnC9PWBKdOvT/B5KWMPRK3CS9kyIxZX0Yue1/SuxnJmR2icB5+yyHo65dsjc4+seM1rQ+wMfrt3tnLRx1+HBQ/ryPLrLyiDsAwniZSXkJUEskvO0LyEYAxtZr4/IYx1F82GfMYGLk3+x6n/fT5odYwJwyhI3vC8IjJpmcxuEbhmz066vLZ3xz2KbiHrWOD6gZtgvfW3tuXXThTGfE01VYTEDRPWDXet3iN5OHsYDkgbXpPa6ToH0K5jTIpcsvf5O0Y9/IAGyzVTmLDzO9qslqOvwIpt2Ab2DrTCcZfWp4gmCJmzNX0yx6WmPzf2ugyzdyNMaBZxNPr0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/13/26 07:00, Dev Jain wrote:
> Refactor anonymous swapbacked folio unmap to ttu_anon_swapbacked_folio().
> While at it, rename the remaining subpage variables to page; folios have
> pages, not subpages.
> 
> No functional change intended.
> 
> Signed-off-by: Dev Jain <dev.jain@arm.com>

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

