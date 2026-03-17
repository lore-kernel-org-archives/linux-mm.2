Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8CA4CF3381D
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 09:12:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CAF486B0088; Tue, 17 Mar 2026 05:12:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C60E26B0089; Tue, 17 Mar 2026 05:12:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B76526B008A; Tue, 17 Mar 2026 05:12:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A398A6B0088
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 05:12:26 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 45426140621
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 09:12:26 +0000 (UTC)
X-FDA: 84554989092.29.45539C2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 89C1C40005
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 09:12:24 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mCZgaD6K;
	spf=pass (imf01.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773738744;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CLI/bZM+cSBD8wVwTESyfSKw+Jwsxjddwt/oR6H0SR0=;
	b=XUclQyQOOMGH0rElxj5eIrsYofUrf3G+1ulPv9AyVcvShxQqIDs2jqA9Y+Ay8u2+Fl568S
	3YvDdFbLBYDZSG/bGZnMs8Nssp3Zhet9W3znfNLDIFW0d83Dg6Z+i8sRb/6XdGS1vyFM1M
	coqOo3PD1FnvWQ+4HlgRHJ7nDZofJ/U=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mCZgaD6K;
	spf=pass (imf01.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773738744; a=rsa-sha256;
	cv=none;
	b=1aQuBYrUaLo9OsovOIRTQ4IlcQKqtTaeQ4dkp7tL28mskKfJGCAxPrtzhwYd11EUA+zKgK
	5M0TTiAv6DKChqAdKPcjnXoy2iwLO8tj4TkUYMLKhCwMWfj3x7rQJfqDIlw4oFAQlfobtL
	oh2P7ctinIllFTKQ4p/ggSQCA7qynoU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 78CFC434DC;
	Tue, 17 Mar 2026 09:12:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3B50C4CEF7;
	Tue, 17 Mar 2026 09:12:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773738743;
	bh=mg1XRSjP0lyWKLduKNpAhmOLtj6KEMMUpquKvbP4yzo=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=mCZgaD6KOl4NSTvradsDqu9gM/HxUVIdrWrJzFCG3NpmQRzxXB6cpFVf7i0XSNUsU
	 sBBhdtVC3l6lOJ6gKK9nyDiKxhm7+JhNmY3pMoBWtjsfFWPR3xt8E5iBfgXdibGoL6
	 C2d2zx/FUoHViLg4+OOcVbYNrXtg+72aw7pDXGnEsQ4xx72BH5L5eweQQB6EcMhZzC
	 jUjYJkPeMtkj26MK8yF35s38QTxuf9lHnHoAtlI+pgUyqBuI7YS8bc6UVDhWYF4tgn
	 0VrUCQIQtzOGZY4IS5H2EruN/PN4SICGCPHyUshAIx5ayU6jIV4J539TcrC3l2IFIa
	 Az3X55mxCQJ1g==
From: Pratyush Yadav <pratyush@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Pratyush Yadav <pratyush@kernel.org>,  Alexander Graf <graf@amazon.com>,
  Pasha Tatashin <pasha.tatashin@soleen.com>,  Andrew Morton
 <akpm@linux-foundation.org>,  kexec@lists.infradead.org,
  linux-mm@kvack.org,  linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] kho: drop restriction on maximum page order
In-Reply-To: <aa_zglmh3AU2_RA0@kernel.org> (Mike Rapoport's message of "Tue,
	10 Mar 2026 12:33:38 +0200")
References: <20260309123410.382308-1-pratyush@kernel.org>
	<20260309123410.382308-2-pratyush@kernel.org>
	<aa_zglmh3AU2_RA0@kernel.org>
Date: Tue, 17 Mar 2026 09:12:19 +0000
Message-ID: <2vxzo6kmddl8.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: ryort6xy3rzepjndnyw3xirr9zax4bk6
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 89C1C40005
X-HE-Tag: 1773738744-102804
X-HE-Meta: U2FsdGVkX1+S/ihG+XBFFoxGWB7Jh4kXm2ZavSv/BCdXB6Be7SNsy4C86Vka2kqOMGPgHh4EnfggrAJdU8jKyakU9Qh9lKX/CJpUNpcVAqLZn+TyJ75BMxjE9nFwMs8YdK6iTQOFNpM5FNjE+FxYw1Ga2O6EvT6Mg75g3btJa7nKv13W/plgmQDGcsCocXZXOPmK3qsxGTYlA5nys/zK+jUwaFVPtkJCZwEy1oTYxblkFXhBdxSRFUxm42I02uDVKjBbZiEydob6KN+qgMtOIFoOcHUfSjURHkTKywIwgrU0RnWqVafeTZwbEY2Y8rnWZ7ZDXug7Ec+SZOscgwaqQ6ZMRVN5PrQFeOZtgDhR5/7ZkM6gtRGfFeCSG1YBmNzWrZWEcw9I+3HjrsbJUdKYWN/2y21BYIM9S6PtPm/q+G8sRE31pE1HKg3VxY6SQUl3ZtVEoNT76pqxzL+Pq7vb4lN9XD1d4x/XwsPcCfJ5wNqLQfnsOslR5jOCbVAx5bQgUBxnviCq4M5NgR8ratP/NUo96YxQHWtaGQAC7fuqQQYx4vW7EA7J1XnqREeQvjGusY5BNzTq3N8DsbHKrHH1YCaCbamoxXR8oyZgTQq1O7rNbtU4SoOZceX9bKTCHSfQH5A5O1ZhMypqhUKKu2PgWmUwcWIYjAxUtbZW+b6ZVXss83bl3YHk/cDaioDTx+JoujfdkzttZre4Wxd96twTWW0i6KblVbWOQBUmFcoVDsIode9CP7GAYBvA6M7vtNxiibAC/LEoLS6oQ6fN9fV/JSJJrmF3mfN+/STTVWdntwyALPuwh4q4GzVvV6KlmbK2AW4jSTKd5zVegRLnkdZ26hnoFSAGxvY+tkR81+rDY0HfKtIbbi98n0cY7oPuU0bl+tfRnaJbmd4GULYYPSGV8B0Qyjg13O30Izku2AD4M0sqsnWR4bY9qHJRPp2DvzqbzuSKdxIbEx/xjRNKifi
 EGm9VJBU
 c7A0VtF5saNntiDaEXzjfGqIpReugSLswdXPuxTw0Hl1hBhWdUNwukUuV19vzzNxeaWuYAo9xMz3I4jfKsH63c7rDCkGIBRnRNsu3BnuFKmkcdNM3o0UyEwDsMADC3Sd7KD4WK7rIybPP3lXUsa5iFCTFdbHwIjHl+b3tKnjx6Obmuj5tDTwJMTZWke/z6Q0flvTd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 10 2026, Mike Rapoport wrote:

> On Mon, Mar 09, 2026 at 12:34:07PM +0000, Pratyush Yadav wrote:
>> KHO currently restricts the maximum order of a restored page to the
>> maximum order supported by the buddy allocator. While this works fine
>> for much of the data passed across kexec, it is possible to have pages
>> larger than MAX_PAGE_ORDER.
>> 
>> For one, it is possible to get a larger order when using
>> kho_preserve_pages() if the number of pages is large enough, since it
>> tries to combine multiple aligned 0-order preservations into one higher
>> order preservation.
>> 
>> For another, upcoming support for hugepages can have gigantic hugepages
>> being preserved over KHO.
>> 
>> There is no real reason for this limit. The KHO preservation machinery
>> can handle any page order. Remove this artificial restriction on max
>> page order.
>> 
>> Signed-off-by: Pratyush Yadav <pratyush@kernel.org>
>> Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
>
> One SOB should be enough ;-)

Hmm, I figured the unemployed me (who originally wrote the patch) and
the employed-by-google me (who is doing this new version) would count as
two separate entities and there should be a S-o-b for both.

Anyway, I am fine with dropping either one of the two.

>
> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Thanks!

[...]

-- 
Regards,
Pratyush Yadav

