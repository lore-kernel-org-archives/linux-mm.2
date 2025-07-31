Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11984C87FCC
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 16:44:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB9F96B0096; Thu, 31 Jul 2025 12:44:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8A8E6B0098; Thu, 31 Jul 2025 12:44:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C7686B0099; Thu, 31 Jul 2025 12:44:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8D0456B0096
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 12:44:02 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1568E1A08B7
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 16:44:02 +0000 (UTC)
X-FDA: 83725131924.16.C2F5536
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 63C3640002
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 16:44:00 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=k9bCE3Zl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753980240; a=rsa-sha256;
	cv=none;
	b=W/kU2QaAd75QXmEBCC8kYa/4Dt/kp/RAeQdA3ve/L/3L/okOAwUzxlcUogQQ5I9ntz4KiS
	2PxBx/LrUdiltrMNuYhqTc7leI/Z7Nn8BaZoZ7UGIuPMIBJm9g8i74og4ARZjcEIdJA2MF
	1bpaeTurhb5hisvAT+o256U8HuWKgsY=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=k9bCE3Zl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753980240;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mu2SjGvBSBGkgGVf1R9RxrJZvEZGefuOw1M6CgMf8FA=;
	b=R/y9A0N1lApjFTYV+5y1pQ7EtQCSkyUZawuLv7/dpggrU2jr3T2gm9gHONJRt/P49gNE5O
	IH2r4s/f8Y8bJw/3OMF1h5+PBGuVFLFHvnIsX339QHbDwD1AsDY6T4jmFIGgC7m1QzQewV
	epUSpK2dt8N/gQIwPRja2m9A+KWuT+E=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7EA61447BA;
	Thu, 31 Jul 2025 16:43:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38D80C4CEEF;
	Thu, 31 Jul 2025 16:43:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753980239;
	bh=w4+o2mS2qRArxgB5ehhLnJpSER328Vi0bY1CxE25x+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k9bCE3ZlPTDEwakexIITAXv0tMPzY+7+iotOPgcNMyjKKBedUUwISrlUjsBF6fFH4
	 zoQ7ehW6kyvlTfiIyWJbgGiFRCsZeFXR066U2N0Cc4AJjDKBG6BZqRrbkIb2iAv392
	 N2RvQ5+R2lbP6sM93JS2Do+hFO/F/Of3LXkg0h3IskXSSaG5WoF0heGBDHmSzJ/oTd
	 A0xe54DghmTTzehjRQKex2moLZ+Ad/arvLfvk5Gu2EmRARn+tWFuLqajbfOlUmJkB5
	 kIauQBRoCm1Riqzem0rXWW/SJ5+zDqyr75ySzzQRX+Px1b/PbXcS4WMIU8gQbYdH/V
	 9Uo5tiw8xeWgg==
From: SeongJae Park <sj@kernel.org>
To: Nhat Pham <nphamcs@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Takero Funaki <flintglass@gmail.com>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	kernel-team@meta.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH] mm/zswap: store compression failed page as-is
Date: Thu, 31 Jul 2025 09:43:56 -0700
Message-Id: <20250731164356.15198-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <CAKEwX=Py+yvxtR5zt-1DtskhGWWHkRP_h8kneEHSrcQ947=m9Q@mail.gmail.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: umb3czbkr5qenocewo3oqfgj88jadxo8
X-Rspam-User: 
X-Rspamd-Queue-Id: 63C3640002
X-Rspamd-Server: rspam02
X-HE-Tag: 1753980240-940792
X-HE-Meta: U2FsdGVkX1+6TQ+57GQ99bIxSkZRnp6zCwHA9iNNmBxEvsL66jEVoGoMba+m498W9Qz3fbN1RK5MIZa/L3qULwNUQwauqZO6am/L5ryCi1UGJ/4NvbTtpDcj4OW0DsUw6kFWvsexrzx9SZ+trsFjk8Zl7Aawfj6MGqAVECnB3frpB11KM8b6pZ8S9Ibrd/x33U+4SGdy0ZsnIzNXjRcmROJOvnmEMx+XmU67s9IOpqk2P22XAAkvUVIzEvrFXsFPbXmzYooGUVUzJ0WfWWU8ThmoKFOd7VkbBKdYSPZ19F9Nq7DfQhTVCRoFDxgC0rdbOH8jBUl2p6KI92qPztQTzflH9qIk3gCMRdx0nNufFCIbv2j+zTSH3CQJjXlJ1xEaj1cQO1EkG2hRPzERRuwjbMOkalUzvjFLd6CB809+gWTOfAwUfnOeR/EED6y+Ebs+C/HXiH8qVtTUIa3XPJY25ITsmIEyYP+bK/uC2yBlJTLZUEl8pVPoifMqdV646O1hEiMK+MV+VKO0E1RwrkjF/nuAMhXMVzMH+5kH5kAs2OSl85K9jnXczzC5tVA2oZar8poZhowk8zp77CMqQosLGBxPmh1JL3RdfDkGd7a3V1ek/ktvz652HOz/TzWiKl64zeLfz0WgcNDszE3SoX03WHC7HQ/ULCyP4N8loSoafijaTqZ0xdro5zq1hxUmWGU758NFI/Ije1xuY97b7wssdOrd+gAK31VkAYf55JapAUY0+mmVywTD0tIZ5rS2l2c48eYUBRx0UdxXjb5k+2blWykia1Aya0bUMj/5Xl5/8voynjzKOPHQbDm+XgdXr+2+xRE3nTmaeGaFuuzbBV/G0JcetE78opELLd9iSL4y7b4Ccip1H8T8hZ6Q5s5rzQxcL1/mh29egRahujWZYyk6HUP8dAux+nBXUuqVfpMDz5IJdtFMlAsd5VG8SHIHKJzZa076A9lB9A7qKmczPAA
 4hIgmyt9
 nlRPdluA9YLiazyAhVgWz5AdTp6uv1PexiETaJqFqXqzwyUEkk91ahmexn5OBk0nl4ougKT/bWYlRFPiE31pcxTwTU+6itTuNeosZC1+2WQRuPTz3wYPG4htPuB5m16MdUHjjMxwUJt4yDnOU2WSl6VBxHRZdVZW5EUsxUDHLQuNzpTi0AlBEcPwJPdZdVeUIuKcYtqoqfM7dZxcN8a5UG6qyJJAodo5XiCzRW98DTedM2nNo6GkawOTBwMGu/TgauJwGCfik13oZOs9eWcIBqpuNGPT6n5viiwAls6sE0lLPMQeY9hhP7/p/mtL0YtlWVVuI8n/dVGQL9zLowtUjTHlBfw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 30 Jul 2025 17:22:51 -0700 Nhat Pham <nphamcs@gmail.com> wrote:

> On Wed, Jul 30, 2025 at 5:21 PM Nhat Pham <nphamcs@gmail.com> wrote:
> >
> > On Wed, Jul 30, 2025 at 4:41 PM SeongJae Park <sj@kernel.org> wrote:
> >
> > This might not be safe.
> >
> > It's conceivable that in zswap_compress(), some compression algorithm
> > "successfully" compresses a page to the same size (comp_ret == 0). We
> > hand that to zsmalloc, which happily stores the page.
> >
> > When we "decompress" the page again, we will attempt to
> > memcpy_to_folio from a bogus address (the handle from zsmalloc).
> >
> > So, in zswap_compress, you have to treat both comp_ret == 0 and dlen
> > == PAGE_SIZE as "compression failure".
> 
> Meant to say comp_ret != 0 here... sorry for the confusion...

No worry, thank you for clarifying!


Thanks,
SJ

