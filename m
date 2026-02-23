Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A6BAE8384D
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 02:54:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 37BD76B0088; Sun, 22 Feb 2026 21:54:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3298E6B0089; Sun, 22 Feb 2026 21:54:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 235906B008A; Sun, 22 Feb 2026 21:54:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0D0E36B0088
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 21:54:34 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 932AE8C4B8
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 02:54:33 +0000 (UTC)
X-FDA: 84474203226.09.BF2AFF1
Received: from gate.crashing.org (gate.crashing.org [63.228.1.57])
	by imf03.hostedemail.com (Postfix) with ESMTP id EA4F62000C
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 02:54:30 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	spf=pass (imf03.hostedemail.com: domain of benh@kernel.crashing.org designates 63.228.1.57 as permitted sender) smtp.mailfrom=benh@kernel.crashing.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771815272;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fwQWM6up7bdTgBko5j6H1KIicKXTBqg1QaI+yTHpg3A=;
	b=1oaHAFsyXsln9xi+TKEXIbhmodRNdMbxCx5w1WJWzW7hNuc+8Ae8HWQyzM5ReBQhwsaNL/
	poCBTGJ//Qi1NVMfR+q5v5p3x85Nx/+5sQNE1Hxsoo0Zp/Niy08nOKMFQzl0lRY63aIOzK
	enPl/MA7H6oW4LgNIC9b0Md4zh8iIGo=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	spf=pass (imf03.hostedemail.com: domain of benh@kernel.crashing.org designates 63.228.1.57 as permitted sender) smtp.mailfrom=benh@kernel.crashing.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771815272; a=rsa-sha256;
	cv=none;
	b=dWSixUxR0j/TVd4QnOGQgUROq9m8uhRXAXpHJleHtQr0wIzI8h9j+Sy1L9OENMJAK5h5d9
	yQ+mnCFbdE12keW8WlVXwVqLkippFX3Q8BtExtLyvWpz7uAB6+PKyq6WrYPf1cPc04TG1M
	hLsvHIHCYTGX8Lme6wedTS/LlCS03YU=
Received: from [IPv6:::1] (localhost [127.0.0.1])
	by gate.crashing.org (8.18.1/8.18.1/Debian-2) with ESMTP id 61N2sBia851194;
	Sun, 22 Feb 2026 20:54:15 -0600
Message-ID: <5e4679cadb5df939e0714b514efbd108a7a05c4c.camel@kernel.crashing.org>
Subject: Re: [PATCH v2] mm: Fix memblock_free_late() when using deferred
 struct page
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org
Date: Mon, 23 Feb 2026 13:54:11 +1100
In-Reply-To: <aZgkrVWmcz_mcn6b@kernel.org>
References: 
	<ec2aaef14783869b3be6e3c253b2dcbf67dbc12a.camel@kernel.crashing.org>
	 <bbffd0db46460cebd604f5c1e6668984fd4cc435.camel@kernel.crashing.org>
	 <14295eba34f10f5896e6cb7d3e1abd36199cd918.camel@kernel.crashing.org>
	 <4d93284349178a783725539b66dca25725fa779d.camel@kernel.crashing.org>
	 <aZVyxKVS8y-rqwrK@kernel.org>
	 <6453da0558ba20d5c87e730bdfedd47966977931.camel@kernel.crashing.org>
	 <aZbjCFqlqdFwKSHR@kernel.org>
	 <39289588fddb4844264546cd103ba4595430f313.camel@kernel.crashing.org>
	 <1ef0f899dd03928651d2e07cff14e062be25d5cd.camel@kernel.crashing.org>
	 <aZgkrVWmcz_mcn6b@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3-0ubuntu1.1 
MIME-Version: 1.0
X-Stat-Signature: 9ytewe8pax6et38pc86ihdpsgwrk18bx
X-Rspam-User: 
X-Rspamd-Queue-Id: EA4F62000C
X-Rspamd-Server: rspam01
X-HE-Tag: 1771815270-671802
X-HE-Meta: U2FsdGVkX1/uTYRALzP/LppUfsEhFZzBnvtAB+CNWM6OSoi7JcI6Ue/BXkzV2s4kQ5rXXK26N6UACEpp5gwASp4EnHD5C7jjXOjQ0y+nyr02UzDhOhAOi13jaj5ZMSWpaSn/3Vs3x13sqlZ+aZ9+6DWPWqSmW4FBFbCVKyEE3MHJSLx11PzswuCK3dQ/vwu8xjwIMzuuL/61r+lea7i7R6F2u0JxogwBDFRw0Q1L4PXvzNsVrb45AjNaqj3AQ7Crp0AVwCC7q8iy9EXTgIysDhPlp2uIPXtUSCD4VA63ZdMi4hpGlaXkKtwp64Hl8WNRmIdmxdw45lPb6lB0pV90dTPKesVaqaVPEhcNHxXFcseMqc0XXsmWwXVwbkn2XGYyUMt6vZYjK879MkIM7ng3W5eis6kgUs67TOVZC6J+mtmsIpm/rdvznX3yKAfctWcZlbatNmm6rLFh1Bkiq+29wlspqIVezkp8fVS+bwvmDxbXV3lqjGbyf94y1H1MzGoDcc3e0cU8ZXDh0C8gZlKySSOIzTgjgC4naCuTWdvyjh3+XSR6HvNta76LSMfcLDKyaVCSvAoegYbWL0IY6YBV4k38V022UzVF61aROe5rcpooktfOwhbyWmIpVOcqEdeOtIpeV5+0P8krZBhlbK9l8FxuldDQcPZfTFSPHI7QmiY/M9rzOKgbb+oI7I7d/ZVwajIv0HX1GDuVOhIyS4K/qzUzQjSXlmbA7cwEHr9CV5h/aJUNhJz2Q3K6DUG6w86vZzs0blfNIQj0iiKJym+pj1ez2RJThl/Gqm3aqgJnAIKAZxZo70YFAodBLJ8XPTt0e5gq4lG60IlNQBT2CQ2294GR8Qs63Q0CYJymsYW8ARmB64Ww766oFdeQTG/FTskOmMVnCDfLcsG3Khp1Cc1HkpYlYvnTPTUdSt+gSn2zz0wb4KyLTtjvY3yKHEHX/USrrY6LfPSAdJcYoBJ7qSd
 E5ChqUTc
 0scpRFUX+GU3aDSL2RjnnlEQiIl5rnDB8cmuPPukUzHn+dTBJB02t7XmHbNo9z21apqpTsJ2PKngkXKEqKQzO8a9LFX1spwQstgvs8yeZAbsKnInygH3LzKeQ3SXJw5nReOst4UBEaZYQNtc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 2026-02-20 at 11:09 +0200, Mike Rapoport wrote:
>=20
> Here's v2 with fixes and updates. After you confirm it passes your
> regression suite I'll send it properly to x86 folks.

Happy here :-) All good !

Cheers,
Ben.

