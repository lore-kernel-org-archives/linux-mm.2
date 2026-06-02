Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE65CCD6E4A
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 05:02:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4ECCB6B008C; Tue,  2 Jun 2026 01:02:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C4136B009E; Tue,  2 Jun 2026 01:02:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3DA266B00A0; Tue,  2 Jun 2026 01:02:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2D91D6B008C
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 01:02:31 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C914A1A07BB
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 05:02:30 +0000 (UTC)
X-FDA: 84833776860.28.2600F05
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 2B7A140011
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 05:02:29 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mbtiN1he;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780376549;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nfT9XgO1pjlYvHgfjxOj59nD+Ap5qJKqD9RInaT5AUI=;
	b=WY2QJy54UrEgYDZKM+XK/K8Fsuu/IcZ55+QiW2o1Vbdra+TR5mICiQyd9LdoEujjApY4sf
	rF4lUfC1X6BFeTwWPmjYV1wnR0lm9UOlhvkc6Me0fMaDGXxRi2wJpd3PQuMz5ef8I+Xmjl
	9vWmzKeXl3swpih02kc1Q4P5IwC6qag=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mbtiN1he;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780376549;
	b=h2plDgj9t95KfGCwplCoihzxDF3tVLKaOpYi5muiWPs5/k0a6snp7rzahHPvgODokG2PnZ
	IEVgjpMWy+9mafSoXl2J8OLPZObXax3oZfsEHLOB4W94VPryVQVov5D38RMXR3R6plT/1w
	KyfuKIzcabsX36FVIJTSAjkTaAVJgow=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 50F4641A7A;
	Tue,  2 Jun 2026 05:02:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79D7D1F00893;
	Tue,  2 Jun 2026 05:02:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780376548;
	bh=nfT9XgO1pjlYvHgfjxOj59nD+Ap5qJKqD9RInaT5AUI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=mbtiN1heq+G8i6qNHZQVivtNlAMeRhy4G0li9StfX4xJGNOG67+1y+nxBv4LYTpxx
	 159XFiMb8WxYlS2HB/Z/La1p/LwqUUTKtgx4eE5eXgOa6LHVlvPmDmlgFdzeBT+jdA
	 y6s8z+2f65dkrkLHgwwoKpGNwiwswfQexLrBixLpndtwEYhySuM6pB3ioYcahXcMhi
	 HMEtO5FDFeUegQi29zlh6DiM75ODwro5lOCcGzTfIn2SV3BGrMQHzDHikHguIcMIx0
	 V+Zoqq7gpx+0zdb2IqPnASuMcchSLx/UWa2TVrQSivo2ZKjQDGeD8BB5RFukmOIqEo
	 4EvI5ToSqpKzg==
Date: Tue, 2 Jun 2026 07:02:22 +0200
From: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Borislav Petkov <bp@alien8.de>, Karsten Desler <kdesler@soohrt.org>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] arch,x86: Skip setting align_offset for hugetlb mappings
Message-ID: <ah5j3hYpBN4Esl8h@localhost.localdomain>
References: <20260601125015.216110-1-osalvador@suse.de>
 <53b599ef-0f16-44d9-bfda-a5a751649193@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53b599ef-0f16-44d9-bfda-a5a751649193@intel.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2B7A140011
X-Stat-Signature: jp65wxk6tgninki1njpbhstymzf1au3j
X-Rspam-User: 
X-HE-Tag: 1780376549-730736
X-HE-Meta: U2FsdGVkX1+eEcktUw59KU6O4aAZ/gOqJ4lQepIpQDQ1YuecBUJEDbEg838Cjf2yQuqhgyt+7YTdW7nsAJldrDyuxwt4Ake0qCnDx3zug9dRidW+X2rQtUWJZe9oZyOLeFMM3/L//526efk1QknxiHBAc3wWpNqh6zW2A13Td1dcoZHqzpusMtWixucFfDBLqdiouXJWMfsMdlUIINZeZU6McnxspJa48sgO4pEcnYBOIRYiYoQNE345V1gff8sbdqawxaYMqdMtQ9mYlb9fPh6jPny3hndPrUnD9ebwXtpLTusGb0nsDiYSXRx+5np4T8q+P7OJzUz15iAkbjetoIRlzKZf1IeO5lwk22LNa7sQXPWY/dtb9pCsVL46bKVGBwC7QLl7u/+FCGdVVfny4N1/RufxzFzUBXwbgQ+6wDeMwSZZIVirmYag2imTo4Y5ELQ3SclguIZR7akHRU+M83kV/fha8rv6m6S9lQYp+k+Fe4p2NtjIml9ajfNovEjqWYYI5nysgUDodLTRLv2KprBk8wf4MNdZXgqZN058SDYmfO5HxEBQiRyaX+OJrsakYIKRv6vmzlsUuAyEAVEN7Uk9uRZv+O7edlscJiAZVgCE+nBiYi0U1PxpBocsVGwZVDkFDGSOl/NeYyKLiVi5+zcOv8a69UR53fuPIs76RvQxQdzr/RFmkWCspYEPN++dNKa482Ps5tMWlsSrteQlXz0WCtqPGs5mJat6e/0tWtWa6iIRElF1HxcifqUjj+TxUtUnjejWl4WubRrDtWZqCkh1YUQ3anTEN1cfYPK6KSB+RnNzl8BK1NkAzNLphzgMRtkJk6uqKf0yqjMz8TfFtQEnNEs+Glhiq0mHEMmJ2a0XFDf9VP9KYsxN/hcAZYi8UKMHPx1NZmrNUF8z9EPN2AAiisW2r1k1RMbCXybJISwg+QMY/6izOnrpsZuvaJ/W6jGx6xov830feA3Oi7S
 C3wK7QsR
 x/L52uGWHc1uCqgeZp3TPEoCh2yQHHlwpfyZPRF3PCUi72myh7DoPeJbPJ+yb7HbzWRUQsfkEG26qyo2P9Upy/DS+tUzjXcFZbqVD/wMu7PfMC0b0q8ciWQiqDNQ9fPVqYPgCScylN4qepbwg46jeQNcqJIKoaRz2HI1+z1JHGpZoEEqiVqwvdBgZYFqOpnVA69idOwJviZCxt32FAw2Zo/mrKy07duxNktqUiEjdLRoD2nkegI7aIEdZgYVdXfw9JhOO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 01, 2026 at 01:25:12PM -0700, Dave Hansen wrote:
> On 6/1/26 05:50, Oscar Salvador wrote:
> > On x86, arch_get_unmapped_area{_topdown} set align_offset in order to avoid
> > cache aliasing on I$ on AMD family 15h when 'align_va_addr' is enabled.
> 
> I'm sorry, but this is a big NAK from the x86 side, without at _least_ a
> substantially improved changelog and evidence that x86 is both the only
> place to reasonably fix this _and_ evidence that no other arch is affected.
> 
> Why?
> 
> x86 is not the only architecture that uses .align_offset.

Yes, although we skip setting it for hugetlb mappings already some other
arches like sparc and s390.

> The bug was introduced in a generic, non-x86 commit (7bd3f1e1a9ae)
> 
> The real fix is almost surely in arch-generic code.
> 
> So my fear is that we'll apply the x86 thing. Four other architectures
> will come along and have to add their own fixes. Then (if we're lucky)
> someone will stick around and fix it properly, than all the
> architectures will have to remove their hacks.

Yes, I am not happy either with the current code, given that some arches have
to do this dance of skip-offset-if-hugetlb and feels _quite_ wrong to do
it at arch level, given that only hugetlb needs that and given that
hugetlb is not the only one needing aligned things (thp?).

> Worst-case, we end up with a latent bug, just without any testing
> coverage because x86 testing is the most broad.
> 
> Oscar, even if the real fix involves a couple of patches, can we please
> see that, first? Then, we can go back and make an informed decision
> about hacks versus proper fixes.

Sure, as I already said I was not happy with the fix either, was just an
attempt to address the regression quicker.
Having said that, and proven that you are not happy either, let me take
the long(er) road and come up with a proper fix for everyone, so no more
hacks on arch level are needed.


-- 
Oscar Salvador
SUSE Labs

