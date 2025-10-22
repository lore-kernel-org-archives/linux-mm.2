Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65039CCD1AB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 10:31:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B8F668E0003; Wed, 22 Oct 2025 06:31:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3F818E0002; Wed, 22 Oct 2025 06:31:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A554F8E0003; Wed, 22 Oct 2025 06:31:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 947628E0002
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 06:31:07 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 22E025AFF1
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 10:31:07 +0000 (UTC)
X-FDA: 84025382574.01.E16BC19
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 7C379C0009
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 10:31:05 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aWN+f88k;
	spf=pass (imf22.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761129065;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T65oXgzI6svzlrBdkLj2VfrKY2TxsbsfuZPwonIauN4=;
	b=5LeinvLZi+Y4Fyrjj8O2IZjL7QBr7wtVeA6tSWKfM/6zmCU4VMsOwVEm2LwndS22Xka587
	IaqBDeNX7Qg9sgmhTfoML+a5ehFY5MTaXhZQ9koJQ+dqR8iJkRbMQy895IlOvbwuCpeSnW
	yPeuiGtPTr68pockV1resn7vUUS1nZg=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aWN+f88k;
	spf=pass (imf22.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761129065; a=rsa-sha256;
	cv=none;
	b=xBgZcQ+10lh7yAHd+0JtEg+kr2+3BxD1TjXe4j9ex82mORuDFrUDJcm9ttYqZplP0JxaI3
	UhcO12/tXKdlHOYn011ScE2EzaVl2qvAaU06zZYMb3AVAouYFxhU5t1fjlvjJQtIVoNVYe
	lkHwwDvF1ik8SNkrPIaRCmn8AnHC2lk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 33FEA434E3;
	Wed, 22 Oct 2025 10:31:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1D9EC4CEE7;
	Wed, 22 Oct 2025 10:31:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761129064;
	bh=nxiK/SmuUZ/eJ7+8qPPttAoIuFOLIAmNOtowfTn06Zw=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=aWN+f88kmsR31F7356Nhjbat0XtNCNhOhXxy+mj03RUY7LWerEd1yedbWOXdr5vi4
	 tNC+xKsZSg2//FpnqZYu4HGomHdWZWKoWc4J0F163zczx7hJ134hS+2cI7rg4UBcBa
	 XULRgorW9kn/jRM+mwrHuIsfgAm9Feu+WSSlfWZaK8bF5cXpLuoNB5oQOnt9nO/eTV
	 PFj5BTL4kV1aXEPl1qTK/lkP91bINYUNHfh3yNabcAkBxQeumFTNfYyuMGkMlfSWTu
	 Ixo9tEXjSj5WrW0BDvq9FRVpnEYEXdeit9JcP7F8YmMqoDfwTE1pDA+TcIQPAuu6kL
	 QBEndSkG/yiOA==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: akpm@linux-foundation.org,  brauner@kernel.org,  corbet@lwn.net,
  graf@amazon.com,  jgg@ziepe.ca,  linux-kernel@vger.kernel.org,
  linux-kselftest@vger.kernel.org,  linux-mm@kvack.org,
  masahiroy@kernel.org,  ojeda@kernel.org,  pratyush@kernel.org,
  rdunlap@infradead.org,  rppt@kernel.org,  tj@kernel.org
Subject: Re: [PATCHv7 2/7] kho: make debugfs interface optional
In-Reply-To: <20251022005719.3670224-3-pasha.tatashin@soleen.com> (Pasha
	Tatashin's message of "Tue, 21 Oct 2025 20:57:14 -0400")
References: <20251022005719.3670224-1-pasha.tatashin@soleen.com>
	<20251022005719.3670224-3-pasha.tatashin@soleen.com>
Date: Wed, 22 Oct 2025 12:31:00 +0200
Message-ID: <mafs0ms5jfct7.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 7C379C0009
X-Stat-Signature: cxnircfod5ak73b443g5ihjccue6hjzb
X-Rspam-User: 
X-HE-Tag: 1761129065-389911
X-HE-Meta: U2FsdGVkX1+Olefhxo26f2tGLleuqJhMNAUEmnKaHlaIUq/o8i4VvUfu/aaNW9u1pil1n5TW8jloNhKnGfJ7yjpfC5XNd1S5jlPMTcNwbaNVUHGfQlE8skwxRFct0aVWa/wYG6A8eqGexWys9VYe+PsXKc2EfwwHw0CgObsdOm+5dYeg8ZMlrR0o2foGpxo19gu6RFs7ZLGp5R8YkSjvym/z3UG3x/C61b41Va10EZiqW9N0PtQ25wuHodl3eDOoBPyE15WbwnEGGp5CZjTpC6zXxIVGp7Abg0palZ1i7NwsbswO452IYHzM1y58Um9mYIDZ4nWpxk1LQxJ9nhRVqwOe/+0F7pvOmu+2ckfMMaFlqslAsF4txdBfNVeNr+GFqZBwuYLQrSeDFpkJZon7x/e70yt0KL7/+qangl09FwmQAK4jtmgO5robP3FS1e5V5cRvAl7fRoscEg059MUpt8pbfPUeRWxA17u9eOP0/oJeq6pzi58SyJD5fecL0dKy/L3MKzSTpu/ppVbMT3Towa5uU7YLEUKqlNekQWoDR36PM0RqIoNo8V9459MiDwvSHulci9PqEzjQv64h4nJ2G4Bsi5cdDrNIXtmHXrPrbuAe0QR38y24Km07ifbeNXZRnGoC7Jar9lQQEJAd94Ak+E+zo4iyF0OYSOuzBpsPKQd2d2kP/tFSG7IzQQ5wXZfTgt0JPMNZrvGFq850g0eRvAoCXMeBxigXk2Sz+0atlaM7nMqCnriJ39NzizrJax4eh1v+eBoOUJd1OalzU1Ka3/2DuUiAU2zsNQ3SWwAvgQvD1BpriUG1b11zaEpBlbxb2pDWF2wdMei8qOTBVJqoa6mhqVDZYjdDcD8dr3ixsPvOdJLNrwPn3p2PC76e6fpebKNkpQZmfb5IN35RpBpNlJ1rVR7cZfrpqprmaxXQDYEpe57BwQm5sisdbPjGyxMJtsv/RvKA+RvS014W+Kc
 EXufZl5y
 waMjWB+54yQXOA3j/I9e882okBtVIvFNFEBicWTs2e0nMrKda2JTtKUAuUsJ/qq9VrCk5cGfLrTEqfF/pVA8qLdxNXLBTPT5hPrnBloeZKqmfUGveJ+lkstNamO1G5l3Bo8I56NzcMU356cWie7phdx8mVDcPF3BPPvRjwIlXDS1byB0t+Q9rRKdACBtOca5R1lUVszKMeeZp9TCdz4UgQe1vsGtd9U4h3UmLRdzP+k0J0XKIeBUZDZWms2lmthtw4p+J
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 21 2025, Pasha Tatashin wrote:

> Currently, KHO is controlled via debugfs interface, but once LUO is
> introduced, it can control KHO, and the debug interface becomes
> optional.
>
> Add a separate config CONFIG_KEXEC_HANDOVER_DEBUGFS that enables
> the debugfs interface, and allows to inspect the tree.
>
> Move all debugfs related code to a new file to keep the .c files
> clear of ifdefs.
>
> Co-developed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>

Reviewed-by: Pratyush Yadav <pratyush@kernel.org>

[...]

-- 
Regards,
Pratyush Yadav

