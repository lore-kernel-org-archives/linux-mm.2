Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54FE8EF584B
	for <linux-mm@archiver.kernel.org>; Sat, 14 Feb 2026 17:13:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 790346B0005; Sat, 14 Feb 2026 12:13:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 713E16B0088; Sat, 14 Feb 2026 12:13:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61FE06B008A; Sat, 14 Feb 2026 12:13:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4F9D86B0005
	for <linux-mm@kvack.org>; Sat, 14 Feb 2026 12:13:19 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 000121CAC1
	for <linux-mm@kvack.org>; Sat, 14 Feb 2026 17:13:18 +0000 (UTC)
X-FDA: 84443708118.22.AE4AE0A
Received: from ms.lwn.net (ms.lwn.net [45.79.88.28])
	by imf22.hostedemail.com (Postfix) with ESMTP id 294E0C0011
	for <linux-mm@kvack.org>; Sat, 14 Feb 2026 17:13:16 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=lwn.net header.s=20201203 header.b="WRQO3e/a";
	spf=pass (imf22.hostedemail.com: domain of corbet@lwn.net designates 45.79.88.28 as permitted sender) smtp.mailfrom=corbet@lwn.net;
	dmarc=pass (policy=none) header.from=lwn.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771089197;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hZico+0X7dDimHx4WVJUWac7oNWgOwG2Gus+OJXlHwM=;
	b=oeeoanbVm3X7hsyijOTkejCSVb0dwYXyD91WdUsiblnPHzeJbA3QiKXCLUiAdtU3XxARc2
	XLI5vKggB18H4TRIGw2kG3+wiRuRSV4yktfib79Q7YGy3Dhnffn7TVaYkJVCSbhg+LiiJn
	PSEDn/aeiLTXC/Am5x80CyW2Uw2b73U=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=lwn.net header.s=20201203 header.b="WRQO3e/a";
	spf=pass (imf22.hostedemail.com: domain of corbet@lwn.net designates 45.79.88.28 as permitted sender) smtp.mailfrom=corbet@lwn.net;
	dmarc=pass (policy=none) header.from=lwn.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771089197; a=rsa-sha256;
	cv=none;
	b=ZHkEbWkczKN85HNfC6ka8OWf0fJib0IRFNmOx9/qpz3r+OGdnY7Z3ZvQqUKVPB2Czgdw7Q
	AsKc4JAZB6zRu2vCKYw7tUNX6l5mBFuZX0TXgPy2ACZbdtzyI69MZaXzZFik1eR1xxAaMi
	VJriq/tQ/f3b1QvK2YeRjBjysUNWjYc=
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net 47D20411EC
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
	t=1771089195; bh=hZico+0X7dDimHx4WVJUWac7oNWgOwG2Gus+OJXlHwM=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=WRQO3e/aJQAedd50jGeKaJJqBdfRZQdiSoHk/Ls5xUPz/WjIHMIs7jK3EBoNjhqeV
	 +JuzvhfQr6qwEZ92WHFppXvufun/wSueLKqNRcXYhFVGweKjQDP+HgM2k9gb8JLG4I
	 +vkE3NoOVPsDF29eCJD1q9g/P8kA2c23ta8PA9kisj6FvLlYq4AQDY1OawVirEHOQJ
	 oXPjAd8WAlLqMFJnV73bWMy+f5HBy9s2/xbAuPHX+5+XwICyCDEm21fU9YfZJ2BvOn
	 6iXnGxUMXs94Ihm1YvYLeo1tr0HxWkjiZnb0TvpuH4DHz0U6E8b0r/KhS17zTstNdz
	 uxIAbBbDYTP8w==
Received: from localhost (unknown [IPv6:2601:280:4600:27b::1fe])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by ms.lwn.net (Postfix) with ESMTPSA id 47D20411EC;
	Sat, 14 Feb 2026 17:13:15 +0000 (UTC)
From: Jonathan Corbet <corbet@lwn.net>
To: Min-Hsun Chang <chmh0624@gmail.com>, akpm@linux-foundation.org
Cc: linux-doc@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Min-Hsun Chang <chmh0624@gmail.com>
Subject: Re: [PATCH v2] Docs/mm: fix typos and grammar in page_tables.rst
In-Reply-To: <20260209145603.96664-1-chmh0624@gmail.com>
References: <20260209145603.96664-1-chmh0624@gmail.com>
Date: Sat, 14 Feb 2026 10:13:14 -0700
Message-ID: <87ecmnqmdx.fsf@trenco.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 294E0C0011
X-Stat-Signature: dxhyrtgmaxbhaeqwufh9drn7mdtza9dz
X-Rspam-User: 
X-HE-Tag: 1771089196-155084
X-HE-Meta: U2FsdGVkX1/v/h5e67ctcxoD79XEwPqC3kb7FJhHg3yixPfG3eptlkLTtfTwt6SuCMb0swQkl7JmjhfT5yIL2bVeSdtnpcPg2m+ALjPnrrz7t5QuocqLUbmPNMcyOkiPnhA4DUS84hqvEQsVRsFBcwUSuk4UaAx/7sRyEugh9eNQtBE7mRN+R9O8MzNW4MAPljGtdTeVLJyYFJo+DUJ6jyFbG1CZ/IT+lobCcbDfpPNeIbYqsipf21fo3hJEyg5U/HVZEIKlo88ui66XWqftBbfog6wovm/Ozr+8G4qMPSxmcvybgmMZjdLH+2lBQhIamdBSHCGzng0yJojgQH41yYWUqYzmtMSwMDwGHVxR10+MsjDh3Z47tgw6+zKAKFD5inDgRSd/O/fcXK61h6BMYlRbZefTNJIIi4nsSfCfrpJJlxtNspiKYiC0Bd4qgSzoUUYeZ8ZIy7nSyJaa70CEKSNij/hZGXu8cTkdB5ITX4o7tv2wsU4gctRj86MZl8hylk6mxkTDb9CY2mzo6GcGpauJVA7E15jGOVFTCSIBmxQ3m0k59BhWBhLHIiQKdLYzCYL7znacpp3yc5oRpxTeROu0F0IVZS443a0dLrO7+PmQA8sRXVUoXpPtgL/KB059FgHHrjae6sjT37ux/RABSfrL6Bm0xSdfXHA27hHHa4jhsDdwT+AtHlAlAqgIGtbtaLEqcFkpw0DYx28FQ8PJhUyGoghIVxzbx07YhiIxm4GcvIG+Lt79nJmhWOyObvHZqqe4iG7V1hWt11tYrc3+vMD+dH5WNY12oNqt+Rp7ZwpquBOtwDi9FPBOPkX/rF4HQihqyiDG4yMEijEIfjgO250V2bCiPgX7lxcFDj1pTCHCQIFvjdU20qma/ZldapAYywr7IhMqu1ruCimI1tp7VOS2mMQb1EaXakHgQsFQzYkYm5VcH0r9sCTKLqkQNXIgEldpYcKwc6hzqNYAood
 JDj9dTol
 TlWSoDt/ElNXNgRRcStOX+FVLPep6Rew0AZNuH5trR0f7AhKaJKzWbOU2ZtLYAk//nmRVckR+ds3H8AqL1cINcfqtUrMGfT2vnrTBkjJRMRkKLi3yGYhfGNvQBeaZJwcMSW2nJJpaNS2Wa7AMBqC4EFkToAtfsKNuMYHzpHzCf/OWrOg+tbckVmgg1euSAMNY/TCtWpug0p4kfazn7MkD/QuCWnSdtrk9DDO5is2CNw/eSiw7XMeP5n5KdcDNLgvAWwj0Mtqg11uEs8zop78BCngQzOvC5/MlPltDwfIxL+ou7OjnepIep66E0GFGjWgo9nlOh4LsEJ5wnNh+bPsG9naYUgflsqbJDHtU3YqxXwmapYo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000001, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Min-Hsun Chang <chmh0624@gmail.com> writes:

> Correct several spelling and grammatical errors in the page tables
> documentation. This includes:
> - Fixing "a address" to "an address"
> - Fixing "pfs" to "pfns"
> - Correcting the possessive "Torvald's" to "Torvalds's"
> - Fixing "instruction that want" to "instruction that wants"
> - Fixing "code path" to "code paths"
>
> Signed-off-by: Min-Hsun Chang <chmh0624@gmail.com>
> ---
>  Documentation/mm/page_tables.rst | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)

Applied, thanks.

jon

