Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED90BCCD192
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 14:36:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E6218E000D; Wed, 15 Oct 2025 10:36:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4964D8E0005; Wed, 15 Oct 2025 10:36:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3AC988E000D; Wed, 15 Oct 2025 10:36:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 272F78E0005
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 10:36:57 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DDDCE14019E
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 14:36:56 +0000 (UTC)
X-FDA: 84000600432.22.F7A5E36
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 3A946160018
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 14:36:55 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UeuEpObN;
	spf=pass (imf08.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760539015;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VcHb8m53O0OfAxcKQARyOQxYQTS/x+Ol6oQ470bfd+I=;
	b=gPpcV3fp4QgHixdSEmG/PhsVhVBkFF1TsJuiqzd2kZnv030giv44cCY1sbE/s8dzLs0ef4
	EnrXGi03/2zsQTd+y1sTjxtYuewALht3PR/2Tdrznsp9jZQSkBfrW6Ocbgl+W2Ga5cD3lJ
	BOpM7WRllBQrBX8BpjZvrg/jBgWG23Q=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UeuEpObN;
	spf=pass (imf08.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760539015; a=rsa-sha256;
	cv=none;
	b=gCEjrIe4qPV0vKWqrOgXmSV1UpHoS6Eyg4ylkaxLstfa9oBz0NbIaxEBqeYGMfUu/cJW2W
	MmumeATgVBhcnBBK0kZuLjLOdidDoGwybkgtmmfWO26xV7M+9ghTSom4kSOqVANYsJKqGl
	/EU0WCYFSd+H4gsAba/myhpNZ7wS+C0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BA56743631;
	Wed, 15 Oct 2025 14:36:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A763C4CEFB;
	Wed, 15 Oct 2025 14:36:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760539013;
	bh=q3IGuHOuKYj1maeYSdpMggw3+0tCzoglIrAlJxaChrM=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=UeuEpObNWodrFe4Tcd1s9U/Sm/Y5TnD+d9mC4iU5oRQWU1NrpE9yleEJA1tMc5CL6
	 pUXElVnCMOMOlGKSzQMpNP3XatEpCUfiP2n2ZX5ww3zuPxvzkUeCrCkcPK0xHZJm4Y
	 9pRWmSbBWsOyTGOqDnwjP0uM0xa4h9xTC3IbmXlUtc9seeayfDaeFIO7kXU3y4nv5o
	 ow/MYtiSFUM4KeP2cqyaqBcLtUbrhqW+BqSkCo0y0D2FeKTrFLIAzUPT8iOrrhHpz6
	 olpW5FHanTOG2gPbdEI+gtn7bwBfW3zi31TGCzTrLjNJBgU7NkiHO7y33aw/gD0uSF
	 u7BCek6kMzuZA==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: akpm@linux-foundation.org,  brauner@kernel.org,  corbet@lwn.net,
  graf@amazon.com,  jgg@ziepe.ca,  linux-kernel@vger.kernel.org,
  linux-kselftest@vger.kernel.org,  linux-mm@kvack.org,
  masahiroy@kernel.org,  ojeda@kernel.org,  pratyush@kernel.org,
  rdunlap@infradead.org,  rppt@kernel.org,  tj@kernel.org
Subject: Re: [PATCH v5 1/7] kho: allow to drive kho from within kernel
In-Reply-To: <20251007033100.836886-2-pasha.tatashin@soleen.com> (Pasha
	Tatashin's message of "Tue, 7 Oct 2025 03:30:54 +0000")
References: <20251007033100.836886-1-pasha.tatashin@soleen.com>
	<20251007033100.836886-2-pasha.tatashin@soleen.com>
Date: Wed, 15 Oct 2025 16:36:50 +0200
Message-ID: <mafs0ms5sjkot.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: 3A946160018
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: kdmut5dx4t1ywoe5wxsn9bentkoz8h3m
X-HE-Tag: 1760539015-227850
X-HE-Meta: U2FsdGVkX19R40cZx+PREEQDjO7Let+ynocD2dpAVJ6SyYgAsBS2ZnyfI6oxgAQ9DwQ79zaaf2Bis9KDf1TXpPSp3GgZgMAWNNKMzUMxZWmzDm6CY9wqdo2rPXW+Ys+6P83sMcRjXeg2xC/74L4QlwqePAVbTvVnylTDHJe38PjbF5NY1BG3Sodk4/PgopMujkN7THY1HThkxjoo6ECmTD4Fvskn8uuQu1CMQSItNjRQH4wwq1wLjGdxtaS3Xs8vgL6UKuYsw84yhvszrTyAV3StHiVgbOrrPVke7xuB1gTNVJOH/rV4XT7Vl6OHJ2bzEtgREHU5DU9ZpfscT92Tpnl/va/OQ52GKTYIG5QBpFFFjBaiIkREeKlcKYiOJpN1aA/KilmVAdMJDH36Fzg/cF5nM5HWtN8zxI5Swy3jAjOgFvptIi/AHdqKGtEQOOx3pWlr7VNd1kJi97yuCPXImYK3FJYZyd6qcxXT4rISzHLhvTawGOKqK/dJ+nI9salTcWaTAQBGOOtZCmotMiAMBN7tzrXUYCvUut1QjIotXZZF8V47RTsNMO7gQIMzoXLGFyckPam7XlscPsAXfyJ6hG1pvhXJ2cuURWxQjDLYdvwUtE1TNgLlwTGXQ30vUB8n0eivq6MjSRIrQuKPmKOFci2dv/2XtAeJFdKQuswX/CK/60VN9L+0r/b1uVegzQLf3dJrLznJpbPElB31vnN/o68XYg1jfHeX/mJanHknfbOrZrD5BN3kLfYrnT/BW2+urzZ/bmt7yfKtuvD9SVvylYiYnqGGw65iyQUyFqbL6AIqDiSxZHEQLB04cu7K/9aeR2g0+22uPOTvWmut6LqZbz0ehL1qkiXYSNeyb1XSPHDiik0jeKwt3IvpoWs3oSo9whkRUXK8vrQKEA5uYvEA1t1euXdQrQ+e8TPYVn0xovqhzIjCXYbe8x8fLmqdgEMqWkAeVALFt5FDP8kUGD4
 it8i4mQ1
 s6FTHc5sBSU83IB/VlO6co3mLr+S3iHB2XpqVPap9jSYxAuJBdqfJdgV7KpXIbKP/dK+/e06HfQrzf/LBbIJQPA14Yi5d7GF4ABPQIskNVz/GSvDkzNXzYlon9edd5aWbTTGdNjMEACXwkpjyCHNQyD8nyBpQZNgXWMeEltqTBtuZPHw18i/WSD7HJVkAyQf8D/B3MDxdVqVZ3CnyYQvBB1vR3kOcBkDAn5Y4m1ILRXpDxmg0iJuCr5mYPNjXexNz6fMU
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 07 2025, Pasha Tatashin wrote:

> Allow to do finalize and abort from kernel modules, so LUO could
> drive the KHO sequence via its own state machine.
>
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>

Reviewed-by: Pratyush Yadav <pratyush@kernel.org>

[...]

-- 
Regards,
Pratyush Yadav

