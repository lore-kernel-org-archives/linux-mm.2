Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50701EA8116
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 13:41:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B852E6B0005; Tue, 10 Feb 2026 08:41:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B332B6B0088; Tue, 10 Feb 2026 08:41:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A5C1D6B0089; Tue, 10 Feb 2026 08:41:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 974A66B0005
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 08:41:11 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3BDA4160491
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 13:41:11 +0000 (UTC)
X-FDA: 84428658342.16.BEB7BE1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 7163B4000C
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 13:41:09 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nIllKt5t;
	spf=pass (imf01.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770730869;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Unc9qKAicQ/3X4+uqvXt+dYinmIoJsSf6GoPz9zE95w=;
	b=XLv5WirACqLXJhsFLHdkGeppTRV19B+D8DDD53N7Tjgy25JigmjC5lgqJqnDPlsUurLy6M
	P5+1yecmKj++sm011dMuw92n5aCREsULP7PBXyBuI75ovBS3TxacFwJ2+yXV/ONzdCgHnP
	AeV0Nw5uHwN6UqqXMhTTSFH7XCOt2JE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nIllKt5t;
	spf=pass (imf01.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770730869; a=rsa-sha256;
	cv=none;
	b=z3ogLfmEaGe9qgQn5rRpsNosjdpGfLU9tRAOBiXVcO/NG8zBV0ZRJuP/fkfpFvVp4X4sK0
	9x+tgRCHnHtYkulUBTjF6ZV2TGh7p0tPIl5ojXK6GStVouotVtsyA2A+Mb1pvBn2xdrdLX
	yGTsqmp96/ZF1BYT4P7/qYYsjcS7wig=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4E73541A8D;
	Tue, 10 Feb 2026 13:41:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9288C116C6;
	Tue, 10 Feb 2026 13:41:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770730868;
	bh=MT+rctIKmuvnA5eIBAxzoWBQTwTyMz/PD/htQtTMRHA=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=nIllKt5tMFMZhddu4EvDabsmw0eHTKy8WZOr+dKIUK3L85tK4gxTBXSx759Vo8FSP
	 UEUEtJQRapO+RGb5Lej1n6r3xYUdyvdxWW6Xey2r3uABmMd57mYgPNF/1Vlizl4A/y
	 2Lan/KlFtdWKApPbiTGiOpjdxcEhW5ODyj7+1LjCroZc7eJcd4z7PKmoVr9lV2hUUR
	 hLDipo1c38yuDNcZaraPl5Four8CUKGTqKpey2Dkjbh8XtIagfqAnKbKvqvYZnrhIb
	 XX/7t3NPvotDvDyaeHdjj7EwR++IqchPlbh/kdhhIuc3QtygKOiXDz2mIWRIrKu/SA
	 o00paYupoA1MA==
From: Pratyush Yadav <pratyush@kernel.org>
To: David Binderman <dcb314@hotmail.com>
Cc: "graf@amazon.com" <graf@amazon.com>,  "rppt@kernel.org"
 <rppt@kernel.org>,  "pasha.tatashin@soleen.com"
 <pasha.tatashin@soleen.com>,  "pratyush@kernel.org" <pratyush@kernel.org>,
  "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
  "linux-mm@kvack.org" <linux-mm@kvack.org>,  LKML
 <linux-kernel@vger.kernel.org>
Subject: Re: linux-6.19-rc8/kernel/liveupdate/kexec_handover.c:1089:
 Possible 32/64 bit mixup ?
In-Reply-To: <VI1PR02MB3952964EF347629B2686A36E9C99A@VI1PR02MB3952.eurprd02.prod.outlook.com>
	(David Binderman's message of "Thu, 5 Feb 2026 09:21:17 +0000")
References: <VI1PR02MB3952964EF347629B2686A36E9C99A@VI1PR02MB3952.eurprd02.prod.outlook.com>
Date: Tue, 10 Feb 2026 14:41:05 +0100
Message-ID: <2vxzzf5gsolq.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: 4dfpuhfmdkufty446che8wfkc44sfxqb
X-Rspamd-Queue-Id: 7163B4000C
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770730869-884802
X-HE-Meta: U2FsdGVkX1+jcFgOV7FGvE9nG95hqTvmjEd0GmImEYtNvbaJTdmh8jmHTGuu+24XNx59+5UTMu7XK0reL+NKHfGQWKZFZeNKk/qkVYnetm7pt3zZlvLIzIEyNm0vV46nfu6A/914xfEzqQdAA2JWQ9XEUQbYp98LIjSuWeLF0SjLYdTKCtfoUTBS1JobM0bNc+ABcVbJ6cVVN6rsg1ziNlfZ2vwGEy17SmjiRSWcInlYuy2Fu2RBr2xuhSmZHX7UDj55rbz8B5/rzZlJRqhwBW3qb6dBm150tf4oUZBCCBHSOn4w090iULiCmSoUtClzDn48SRHaYfo63/Nqgtu+LkfbyQva4x30lqesieTGCQsxUIzv6BNssoioOVHs7/X8dBA7GNpYLswq03aEhDMzJYpXhgvSInOlRR22aDi4msNaXahD/O0YFxezcEDHprKlbtlf/q4a1kIXBkhAUJKa7IMMKY3tyCHSvyf1/tkLSPYskrCu8gYA2JMVhjtfkqdSeGE/+ArkcOHg445/eRHjQQbrT68PYIqAI4bxcOLHnP2vpWgZEDItks3pwrP0yYVt8cvRl9MXW7vOOcsdvsh8wARpquqIXWpEBG6a1+8Vg6PXwGS0dpL6O0rkwkRzXmgDzbw6nZn+sEhKjL2NKjiBubyi6fNLHJiZyCb9LB6gfpBSbT6CsQI5sU3wIooO+VLhmHgqcvuML5OvA8SuQ+D7K28XAVNOz4ZZ7LRcnzUsGfS1/TrW6/6u2Ii6W64RnpgoBPscHoxUOqn0aF0OvDZSz44snaehsPuKokl8Zf1vZ8piNPAWBHonZChzDoFBKn8gxjBS0VfbEVG45J7ZUP1f1aZ5/bD3IccMr2w0UU/U2wYBzw6UfBOHryYrCIvHLfhJhGkyvDMTQrhGvu6ml9r062uQGXnCskAfPs1B1VCFcStqAaA17KyGmvSZaO/FMHO3ni2AFXNeqzDsWLJmeRI
 4IZIUJbY
 NFcfoQAb9KoIjWC7NwOCpU3jL4CR8OsyZVD0s+M6LlD7289uqtHuzjGdKzeGRzCpa3M2k5iMnM98U5q8H00p2zzwdIRPeOJCW8R1LHQfBiufHvqlqmtPqWu4fK1YnR2RG99yaZ4f3PPCkCt53XeG/n3qnThmAwYdyA8um5b8ZkMoYIkecc6loMZjQWIDTUP28fV8M65VXVnwlTRmk9jcKNzpXT4R40SfifOiWu3Os92WGWtMqurWlKIqqHdi53a4wCvCNf3iq0Wl+xNsP+DsgWIHgxI9QP2xXsr8WTWGrQaa5oWk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi David,

On Thu, Feb 05 2026, David Binderman wrote:

> Hello there,
>
> Source code analyser cppcheck says:
>
> linux-6.19-rc8/kernel/liveupdate/kexec_handover.c:1089:15: style: int result is
> assigned to long variable. If the variable is long to avoid loss of information,
> then you have loss of information. [truncLongCastAssignment]
>
> Source code is
>
>     contig_pages = (1 << order);
>
> I admit the error message is hard to understand, but AFAIK
> if local variable order remains under 30 or so, then there is no problem.
>
> However, if it goes above 32, then there will be loss of data. 
> Expression 1 << order is type int.
>
> Suggest add some code or comment to document the expected range
> of local variable order. If it ever goes above 32, suggest new code
>
>     contig_pages = 1UL << order;

If order is 32, with 4k pages, that means 16 TiB. It is unlikely that we
will see vmalloc area backed by pages this large any time soon. So I am
not worried about any practical problems.

But I think this is still a good idea to do for code hygiene. So a patch
would be much appreciated.

-- 
Regards,
Pratyush Yadav

