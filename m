Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C504BCD6E79
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 16:46:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3ACEC6B008A; Mon,  8 Jun 2026 12:46:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 30EA26B008C; Mon,  8 Jun 2026 12:46:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 224886B0092; Mon,  8 Jun 2026 12:46:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 14D576B008A
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 12:46:21 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AD50D8C65A
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 16:46:20 +0000 (UTC)
X-FDA: 84857323320.24.97915CC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id D896C14000F
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 16:46:18 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=emcmy91u;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780937179;
	b=SmjxXiSsYmQ61ArQ7yic/5Ndn8klGAr3yLjREfYUl03+/eqNw3TQfU/+UKnVPb3xt0W+vB
	xwxKKvp3Va56QejjNVnyF9jAzj39wqwIbR1pMpmMaMd6vfsUSQ27UeFso1eIWEsaPyROWD
	egs4e4xTgb2tiUzuODAQ58oQmoyl95s=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=emcmy91u;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780937179;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5yh3U/54FBJ0jLN8cFVOZ2XbcZB2sjAi010ghlD1pSs=;
	b=bSeePSAyKwqdTfEwLYxdmMfm61y76DvShpV1fDpu6NUnbIP7+tci0NCQRoWpza1AECSGTg
	1syCtZcRfyusAffcKUEnTg3y0VSmcqwfakpFKnXVxg9k30GjrSNnztb432TJAy7c+ZB+YF
	vGM4uWuZSWTaQU0bijqHMXlw0KwUY/k=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1CEA040E0B;
	Mon,  8 Jun 2026 16:46:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3A671F00893;
	Mon,  8 Jun 2026 16:46:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780937178;
	bh=5yh3U/54FBJ0jLN8cFVOZ2XbcZB2sjAi010ghlD1pSs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=emcmy91udaT5XKgQAAbLDV7NqIT1C1DUv1QF9uic9HAfu4Ud4eiL+s9RY0cOAz9m3
	 fLg1sxpNrteWVuiE5Sf/MSw4vQlPmhEtvaZVpCmXiEFah4GdvLWDtzlthX6QtHkgfH
	 X7PVz3a98N9U+KXOlA4Az0JwM8pmeGjQsV8zxoY5u9LuBn7NevK7IhEqdEXLPFuVk/
	 yCc7vCgRTf1vHV9kNAtq70G9k3iEqVs5ywOJwEGMc7ub4BEGDbVbCFgIRo+qxY42AD
	 sEJOHNntqU9pBdX8lm5QdKRgPAMr6EEMnDEAOwHwq1HqA4WznhUsIBYh7xgRLDzmSZ
	 m2BFHDrBiWDPA==
Message-ID: <8ef8569a-62d4-4d44-b87f-e6a351b92779@kernel.org>
Date: Mon, 8 Jun 2026 18:46:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/migrate: Add native folio functions
To: Zi Yan <ziy@nvidia.com>, yahia <yahia.a.abdrabou@gmail.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260608001251.66847-1-yahia.a.abdrabou@gmail.com>
 <493860AD-2234-4E43-9BC0-12A666D08F08@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <493860AD-2234-4E43-9BC0-12A666D08F08@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: D896C14000F
X-Stat-Signature: fsojcumb95r4jqmrdwsi3zdebtruskuh
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1780937178-209338
X-HE-Meta: U2FsdGVkX1+TqkVhA3jwfmGQGRZDnSHz6K3pW67/ExT63RRFLeFKCgblDloUu9bsewjNcpxXWMv9I3MUqaPYqxQuC4hv8AZAc8tjY7lrrOhRd8WBcze4ZU1Z9GQUmN+scy2SFF9cwS7Fr5PqKAc3CPd2772/z91Hxvpz/RJhrZGGEl+glRRVATZaK8Ek9Xp4IzW75mN5UK4wKFv6TQ5gjAKvlR8p/X2tzLEbBRiGpSczYKXDGYshb/0TMgJnZgD4SZTGqf6RAUXeKlY++ZMNqmX0Jnds/FSinc+zGKTEyVqiCiHQ3nLDIYt+AaAAUpFziTlCxyUxnJaWsi2b3Lib/ZHdscYQgvhUbbQBg/MDIL6yxdOhSp2HaN4cTDFUsWunABpCOUiKz0vK9XT2ilCJPFl87CfumyO4e74kQ/RWYFu7SDQEiHOt3f01/qA3pOrJX/SdqDOrq9HjCn7trO711phLoCcraecTxpvI2m21V/DS+q2YhEOBAVsVdsaqjw/qCHVwykZNJnl3hJhN9xAObJDTgTb/gIT4mHyYcPqFSSiIH/8KK7ZdIik4Mdmuv7Cu8b6MBpsNBwa3fg+OyHRuro/BT/iVakeWz76GIdvVHv1ibhqRRLUn0XDe/XVdLmexublafKV2A07VXk58Mb8WTaB1b9yPe2J3YMh+2HortZ5g6P8KhIsnXbUAY0zKf+/1ZxuJTnUhNo+89xiHHB2XI8qzPhcE0p0OM3meQ6a2BhP+OF3BIGQrS4CfjeXwj2db8a/3SSFw+P1/hBVdJQRZ9GvVM1XqKyycfj655Kpwrxcbj5k+u2HNwoiuHleq9d/765kSSH4uDkS9/BH3RmhBEnDZmr/FpEzvov4nUoL44mmVXjROZelXum+QM/LJcbfc6BdEz4e3MToxcIlvQJw7upf2tBUEKXwZX2U8WWIn/h7C890Q03k/Cebu+KMG+a91NE9QYw+8pMz04MDn17N
 GMq4Cz0u
 Nyhxs3eIq1ks9zhQem35OrTJIeJWcL3qVO/OJwI6B4Em5Cm15NFMWubBJetb33gAKZKiV8u37u9wraNJsHhM1zSEOL2EjVwPLXKY51AgS2siz1r7Th907B063HCTM40zmBKFLOJd0UO4w3lOfYBg5q7PKydz64AbZFidyMMVrxuiSnYwaIF7c3KIUTv+wT99bBvsEhKBGwxrtzFXREEbRHyurqz05PrjnVA+aBPqzVRjdavqCEaBbVZhfhWHoawdNqC8X+NQnQ6+WgFRyRqcfMB61aN6JV635syB8LVafPEGKq31eIBFGFkqP1sj5/HPHZjNXPjoOXxbcIrg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/8/26 02:29, Zi Yan wrote:
> On 7 Jun 2026, at 20:12, yahia wrote:
> 
>> Hello,
>>
>> I aim provides in this patch to provide native
>> folio abstractions for page functions like movable_ops
>> by wrapping folio->page structure in the native page function
> 
> MovableOps and MovableOpsIsolated pages are not folios and they
> are supposed to only be order-0 pages. This patch is unnecessary.

Yes, it's the wrong thing to do, thanks!

-- 
Cheers,

David

