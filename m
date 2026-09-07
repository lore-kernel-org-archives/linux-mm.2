Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7AA15C79F99
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 19:57:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 584AA6B009B; Mon,  7 Sep 2026 15:57:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55D136B009D; Mon,  7 Sep 2026 15:57:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 44E7E6B009E; Mon,  7 Sep 2026 15:57:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E92666B009B
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 15:57:26 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 69FDD14029B
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 19:57:26 +0000 (UTC)
X-FDA: 85188025692.26.A7C10E6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id B05C640002
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 19:57:24 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AZARGJ3J;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788811044;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ylyz7JcmYkU0yb1cgId3V0zysqw0fNg7C175grvf9jg=;
	b=hI3g3i0GnmRFKlmjxc1HN5ODVOW3SzG+Z8y7qDmTY/0PvTXa1dclWSUResxKssIxAfTWlV
	7kNo8OBwAZKoUYLVdurUoPlb4zmSRSe/KI1TaCdTCnaoq8+CjVf3dfdnb7mEbCEy47hO5b
	OjjEeRWUz+8/9XrLz308hyBsWybveUM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788811044;
	b=Z2Bx8wJnf1iEgJzH5D0EMwZnh7jtVnrQqk66SmGiIa7zZ5eM9efG+dd2FFmEjj3Qym6Bnb
	1LvJh3hZy7xnF/Oz5Nb2E9IL9PelSmWaTp8QMDVrAI37MhLRCsdmY3HnhuR6Et4GjihJRk
	EBpBRPJ2EQuNP6xMT2KTquLxCQZJbcg=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AZARGJ3J;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2D24C601FB;
	Mon,  7 Sep 2026 19:57:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E8011F00A3A;
	Mon,  7 Sep 2026 19:57:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788811043;
	bh=Ylyz7JcmYkU0yb1cgId3V0zysqw0fNg7C175grvf9jg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=AZARGJ3JcXho1RUsuyVjdmvbw7j//GWeTKUnmTOOqDFrcOb04DLK8M888yegbgDba
	 TNvNHKASvFgEcGqWmxxzq9lXwHll1f5YIeaR2WhL9E2qg78UYK0aGBvv1oLRZwWi/0
	 Mk91K5b4/ffwjyre8FM4CTxP1xyPKR/GnNEvtliQY+j2NzaQEuKcDzVnWcPbtnLQ4i
	 jgf6ef91TYslZRHYwaUBvvaPl8hRYVEnt5vib+qNBBI+sZCCSZLxOziGhKTqsU8/D8
	 dp8/E8NQiSSiLITWhTBKL9k1gC9ujUM677udJZTURt7n8NdTW44lhgEL5FvxlyEqNM
	 F7McwFdaL8gpg==
Message-ID: <53e7992c-5319-4533-a0d2-d0fb55cebc25@kernel.org>
Date: Mon, 7 Sep 2026 21:57:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/huge_memory: add folio_reset_partially_mapped()
To: Kiryl Shutsemau <kirill@shutemov.name>, akpm@linux-foundation.org,
 ziy@nvidia.com, hannes@cmpxchg.org
Cc: ljs@kernel.org, usama.arif@linux.dev, lance.yang@linux.dev,
 baolin.wang@linux.alibaba.com, liam@infradead.org, nico.pache@linux.dev,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 kasong@tencent.com, hughd@google.com, balbirs@nvidia.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com,
 "Kiryl Shutsemau (Meta)" <kas@kernel.org>
References: <20260907183340.1446132-1-kirill@shutemov.name>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260907183340.1446132-1-kirill@shutemov.name>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B05C640002
X-Stat-Signature: k8hwzw4kwz97zjmcddbnwbskcs4wbgoo
X-Rspam-User: 
X-HE-Tag: 1788811044-910318
X-HE-Meta: U2FsdGVkX19VXUvF2ua/sg9Q0EhO1/mWqytmk+apEBYAWZH+Cfg9COjEGo25/DJSCZVr9aFCNzn+r6V85IljqXD3hEI43IMAOVMJwBOiHX0RJQWh8W6RXNps0m5+bB0sIw7yEyAZWdCGCskBgVIi78EwnAI4zKVO6KTPJBM12sVKxtZbzZwUqapsoskZEuRt8jXC8Wa7fSvWwnGZA/17XR4gKpsKIthG5kxgjYyInIx8cEVALb0cvo8liKG9sW23GZTbP8r8ZiV7/vHImsxlaJjO2sWtQpboIUE9cbzs8ZHDoQSWp1fAhGNbx84y1elTP//VvGkBxPV1zPtYdcTEWfXg/dIjpVCR+0brrwa1vxs1y11QAos2eaMjxiFazZ4iS6ifLioMCt+LM/XRiDBACSav5W/9ixcxllzuJyD467rG/Cg/tQynX/Kl14Jo8TFFO5TtGeXpwbHWqVji+3oEinCeLGparGlWa4wzKE6+4USunYEX0NX9R6KZeunxMsPj7GFaaDi3F2v76kFn5yezeO2D28zDh1j2ceSojWSCAre7oc2M0vky6Y2jnDjsFXfR6OCRMO1ilw3i+dRdhmWWkyq3T0l+JrHNowe+8XiHAwlSWaA8LX55I9XPVykXDytcmM861lI2e8Qca9Iv2vCWVZ7t31zp5Ec0psSzySi/dANiTy2hJWyJmGfD2n9HRBr3ueBeoNOAAaFrovYlC4+6FLs2LHotNFdAXM3oEZPApb8FE8tS6q2NCN25+Qhyuti1WDofwAb2Kg22iqZ4LnPdbZqdKP147cHwkcHXF1LK3yuZfIvZNl0M9smjIsvmbgpFFcYKzOZ8seUp3YCQhNybFvVL/IPVeN23SjuMKM1RZLB6OqxxfLPpZf67EGtbGdJU402F+fIQq9dFMPrzJqdeZcVBCCJMJkxalPwDc8yj8Bo+Cf1oEWp1zswFIKt/S9VQ1jJk/igqL25eGVk3OhT
 kI/RqX+2
 zNL2ASLXvTHI8XtjFLPtQJnv4/HYOIWw+UYBDRrim3zJrXAyn0KsqCyEZT/gIdxd/21ASln+4+s7SImUeqarxevPvspRfMlGaehAL40NXoheDykTvFZtlmXSF1Q811rXkVqHB1BrPRLgeVdhvIR0Hq4+qRpdEYr8NixLwl7gpwSgE+gcF9kPlfCxKSkiRS4a20xg1meOgAOSp3OK0rnauOLy+0bSVCpL7aXbuAjOIcDbjVJ2ddUOhHbHplA90xBVcUTqZtLAu2gvbyBq63EBAG4myJGW4JgLLJqmtqJUuVj8dNQrCEQKHMe/FEUA31S6BMrgB2ocapjyTncM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/7/26 20:33, Kiryl Shutsemau wrote:
> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
> 
> __folio_unqueue_deferred_split() and __folio_freeze_and_split_unmapped()
> both clear PG_partially_mapped and take the folio out of
> MTHP_STAT_NR_ANON_PARTIALLY_MAPPED with the same five lines.
> 
> Move the block into folio_reset_partially_mapped() and call it from both
> places.
> 
> The helper asserts what both callers rely on: the folio is frozen, so
> deferred_split_folio() cannot set the flag again under it, and the folio
> is already off the deferred split queue. The list check sits behind the
> flag test because order-1 folios have no _deferred_list.
> 
> folio_order() is safe to use at this point in the split process: it
> still shows the pre-split order.
> 
> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
> Assisted-by: Claude-Code:claude-fable-5-1
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>

Thanks!

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

