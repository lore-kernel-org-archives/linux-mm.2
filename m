Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FD40CA0EE4
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 01:18:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ACD759001FB; Thu, 14 Aug 2025 21:18:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA5639001D5; Thu, 14 Aug 2025 21:18:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E1B39001FB; Thu, 14 Aug 2025 21:18:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 886B69001D5
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 21:18:54 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 13EBB1407F7
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 01:18:54 +0000 (UTC)
X-FDA: 83777232588.17.82D0DAB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 6451B1C0003
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 01:18:51 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=C832mawi;
	spf=pass (imf21.hostedemail.com: domain of ebiggers@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ebiggers@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755220731;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rkwUCfbW1C3nPkFseFTq/BmTPCiFXIFNtl5CP+d2vwQ=;
	b=vntEl/3lLONvCm++dhEQMku7EUcOy8ZLGmIrGtekESDmkWC1xBX2ox8qqGs/vF8zb2a/4K
	jIdDH2r3IaEW7JrbTBXwjIwPq0XqjqIO2nSJl1LHABVhEsAe5rP+n97hOj3rebjCqM8B4J
	aY46uuafhiMjZIMg/zKJ6Mhy6dbI6XM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755220731; a=rsa-sha256;
	cv=none;
	b=h4/x4xCgaED6jaocPksIiAq1N+IC6p3maqZ8K7qRxTb5wbzTJc87IfxDoHyTWiNJ5+rPHT
	Oa8kN70ac8GMVG6I/1HN74LkExAvIrTuNWF7R+z/S0zEb7VD+VRCan6LTb0n5naYbi26b9
	uDhAal1m+MzVJhCMPYNEzqxvgwzoBnI=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=C832mawi;
	spf=pass (imf21.hostedemail.com: domain of ebiggers@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ebiggers@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 039BD45732;
	Fri, 15 Aug 2025 01:18:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32E66C4CEED;
	Fri, 15 Aug 2025 01:18:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755220729;
	bh=gw3mh9DEKhDX9u8JNpskCPWCG6PCHglkhEm70Y13ZRw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=C832mawi77pZGNE6eAg3cOTMeejX5ERyanv4/qvnDLk007uKsNPqJNqrgZQwfxPwn
	 PypDDpEsI04fXd/uvRoinw8tttUf3p50ZkfXUdLPgCqszMHg/pIyi8SGgFuKrzZGOh
	 YsMe1TJIiJYo3480rDqW8m97YwzasNwdagUk7ySBZclqhUTq70MtHubGO/O1NbPNF3
	 y33WoMf7BRxcTpgk0gOKBweVTQWdlJgxKwME3L6CjarqCLUCooAQFpC0OjhUwEPnZW
	 ShCH9zxYU+LUEvdND+MVG9eCdKZ8Ofr8BWO8H0dkzU6aLZc0/9SDG0N24DsAefga/d
	 zhINjA1ij2jVg==
Date: Thu, 14 Aug 2025 18:17:44 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Ignat Korchagin <ignat@cloudflare.com>
Cc: Marco Elver <elver@google.com>,
	Ethan Graham <ethan.w.s.graham@gmail.com>, ethangraham@google.com,
	glider@google.com, andreyknvl@gmail.com, brendan.higgins@linux.dev,
	davidgow@google.com, dvyukov@google.com, jannh@google.com,
	rmoar@google.com, shuah@kernel.org, tarasmadan@google.com,
	kasan-dev@googlegroups.com, kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	David Howells <dhowells@redhat.com>, Lukas Wunner <lukas@wunner.de>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	"open list:HARDWARE RANDOM NUMBER GENERATOR CORE" <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH v1 RFC 6/6] crypto: implement KFuzzTest targets for PKCS7
 and RSA parsing
Message-ID: <20250815011744.GB1302@sol>
References: <20250813133812.926145-1-ethan.w.s.graham@gmail.com>
 <20250813133812.926145-7-ethan.w.s.graham@gmail.com>
 <CANpmjNMXnXf879XZc-skhbv17sjppwzr0VGYPrrWokCejfOT1A@mail.gmail.com>
 <CALrw=nFKv9ORN=w26UZB1qEi904DP1V5oqDsQv7mt8QGVhPW1A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALrw=nFKv9ORN=w26UZB1qEi904DP1V5oqDsQv7mt8QGVhPW1A@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6451B1C0003
X-Stat-Signature: gsw3saa1r8pbz99j5atb57om8p1dcpii
X-HE-Tag: 1755220731-439223
X-HE-Meta: U2FsdGVkX1++mf7dipU29gX8sqp0PX6TGYKFan+BLK2HCMtVgEDKhfNx8qg9EMXcVLoSqV7KOx5fCk0fA/V0o2WTi3UFW0cxP/uSB3LJDtxXm9TnxdFSxHP5asEgmYUKjMnct81/RLO1rVrdXOQ/rSQHy477E0qAdQbJsvZT3aV7Ka2Tad9BTHVwkHiy4LcGMmPBSA6Jq1w8wpnuehqfLhU5Fad/RVGGGPndM5IVKiGKXJi7IdY345fvObQ+i6KxGaEL9QGUNrQh3GBqjhAOyrAuqFMJK1q2waJgkb7e1wF4dm5Qam/x0nxk5jv5pV8qhRtq2nbU7BME+yqTEVBmNUgYC0PEugrEksLTP/1mHEorI8hR8yT3S3BYGqsnmsO0pktlxwGJakKBzuIXbBhbXjVI55IiK1z1krQTSTVZUDXVxDUXlwJCVY1KMEOYlQXmx7qQeLTONl2kU/blZHJp3PfMZKejfg7C1tBhn/57azSgC71hM43wIlAjFutk7PuE6z+ghWtfl8yD61P0ZOcjfH3gSJuvq6sEbABR70NUo/lUysFnyEUWMJfpIB0rJNr0LSh00aOpEEcxisdIFIJ548xMQJ4JK8oiwQgU4B8r328ZoflriY5R7cposljJdzK92sBkJDtdlRjm5IiEIMsGfXKPwzHKxlAnBKFFuyqg+ANhPhKKSL71Ori3zi3gn4RHxVuyYymikrhh+hG8AHuT5SwMxBcpCVU1eOkjUymgFiVBxgmoRd4aLKLXcd2J9gwcitxz5zsuAjmEJlVpsNt03gwkTHWbt0T/6MyNJB35vqU0LyFLXnEMivN7Aq1tFxYgirtuYCgd62RCzob9x+O+f4x1yO5GkCq3BAmwRg8WtWcAnP6fxEQzR7iNgYfC5bl5ATYi57cFmisGBfrc7aDSUMkiih62KNQ0VmRSlhv/ScSca4+wo9nDWlin3IgQ8Bcn5b2OMOGwn5ARTX7hvfc
 IRhHm2SK
 vbvjLZdgWuDoY8KSDsDPE4IapQWvYVubZQe9D0rz+D1tUmaAbDUuTGBOxalbmOeUGTqLMQIAyAkuSJM4q6URLi06LSnY1qzmpibkljy5ujeH/A+wlOhGYYNBHets5K9jvIIO61PTO3rvruo21j3Q0oC7rYbYb6gBNdKnhFCUc3kZNNMqMjMY+jEqN6aevx07weHTaHbkTBMPYt00DYIKWJbffLDV27TMMHN+A12MXxRHvx9nrApF4oF+yd00zdTht03xOKMAgkeY1Fw6r2Z+LME2zRA7wJu+0+32L6txMKVTgD7zgFGtXNpkIpkSAft94BN6OhWEcILtyjvQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 14, 2025 at 04:28:13PM +0100, Ignat Korchagin wrote:
> Not sure if it has been mentioned elsewhere, but one thing I already
> don't like about it is that these definitions "pollute" the actual
> source files. Might not be such a big deal here, but kernel source
> files for core subsystems tend to become quite large and complex
> already, so not a great idea to make them even larger and harder to
> follow with fuzz definitions.
> 
> As far as I'm aware, for the same reason KUnit [1] is not that popular
> (or at least less popular than other approaches, like selftests [2]).
> Is it possible to make it that these definitions live in separate
> files or even closer to selftests?

That's not the impression I get.  KUnit suites are normally defined in
separate files, and KUnit seems to be increasing in popularity.
KFuzzTest can use separate files too, it looks like?

Would it make any sense for fuzz tests to be a special type of KUnit
test, instead of a separate framework?

- Eric

