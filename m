Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65BD0D7495D
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 06:48:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C5F6F6B0089; Fri, 19 Dec 2025 01:48:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0C5D6B008A; Fri, 19 Dec 2025 01:48:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AEE356B008C; Fri, 19 Dec 2025 01:48:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9B3E96B0089
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 01:48:49 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 212268AA62
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 06:48:49 +0000 (UTC)
X-FDA: 84235292778.18.1B061AB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 7F26914000B
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 06:48:47 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JelpeCHz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766126927; a=rsa-sha256;
	cv=none;
	b=x3C0Mj42KPs4z0f+i5kp5iQqEgKTGmjeCVegJrLr/Zj2keGkH6pjRVlpckmRcpB9W0Wjtm
	erC38RkRx3je89Xu7FxcTRlmhpCax5nwnj1/63KJ+/Pw9gqDYGPTT/JWtDPTfScB4HI3LD
	YwLra3D6qxbWIfZsi4UC6uy7IBHPjzg=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JelpeCHz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766126927;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/S0Me2pCLXAM6ClNP6PGNxTq7G94gU50Qu8HwqC3aDQ=;
	b=MNmPHd5lhgS4U1MMflhKzP9cEwJ2u9LikFaXILzUkSgr3iUqT0OWbHQHkZSMiVTB2eAvkj
	p4z0qJCSh7XFyGw1tlrx9WoLHLG6eWYtPwB1dVQho+qUPS2+5sXSDZ3YE78FU1zVoZhWbj
	+RYxdMkLoVnXCJ2Hm7vvl00JMABnJgI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8ABB8418BF;
	Fri, 19 Dec 2025 06:48:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F4B1C4CEF1;
	Fri, 19 Dec 2025 06:48:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766126926;
	bh=/ySOtmeMRDp4N9rbZ2NlzdqHyHV/b+UP5NXd1nymqo8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JelpeCHzi74fL/WhpTjc54Vx0PrM6nNhvgo+NU9h8a7SXlcx592szoj8iwAjACiiD
	 BSNadqpOMXh0OHj3wWfJaEWH5xLQCiMjL8zrG+Izx1mk73zGFi7mJoJys2O1sYQbjK
	 +3h2V2RAYCx6NNrsQkGwQUXbzG4txMsBiiaQMbe3qOXefDtg5CcYUY/GoEDQTorn7X
	 UMnPjeCJawrpP53K7M7MVd7sMVWIsBufV0oxHyo0D3Hh/CuONcpqgkfODzwnYsZz1a
	 ADhVohJluwwR5lGKHl4xWn0nLrZOyWnTT1eqD3K2s6HgS8n53zQOjOPmT9+j0/6sWa
	 9l6dxl1xuJwfQ==
Date: Fri, 19 Dec 2025 08:48:40 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/mm_init: Replace simple_strtoul with kstrtobool in
 set_hashdist
Message-ID: <aUT1SCTniYr7PA07@kernel.org>
References: <20251217110214.50807-1-thorsten.blum@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251217110214.50807-1-thorsten.blum@linux.dev>
X-Rspamd-Queue-Id: 7F26914000B
X-Stat-Signature: yzxn3s9ermeyh7p5zpy9dbo97ywfp378
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1766126927-45904
X-HE-Meta: U2FsdGVkX1/6VSnq45WLUPr1VkLCSvB57BqkVvFBgeRQ/r1a4mDeVYKUOZMgeDxpS/tA/kX14nEuMf9O/meyqiF6E/TYIk/Liu9aduP+mTnr+OR1sKrFQfzUIsu9jh+P356lLAjuB/HweyyOkhoYhw1nkpUBh9dXKnkoQDdT9SBpJfQNRcfUZ4p+8cxjMWo2VBK8lvVKzmHkfZyR5aVQ0UU06P3MNHLzba0lsv2RxKSqhM/qql3Wu6AgGQgVO7e15ctbe0hnwSfAvxLp/+htvo3x5byB7T1gcmbhjEJszhGp6OS49cWCgi/fNe7PZ1s3KBFZm6R3rM3voUNYKwkq/Uz/F4snE/i8MA7HbLxHY9EZJmdnRPZ/vRTLAZX6YMJlQxl21nf7rHjfZWl3zHRqZAtDGO3vFwrPKr5e9yaX83XbIdrXVMUK/5Ap3WeyR8O3U6I75lSD6t5HeYqBhT7Rroqw3woxCZqvyRujczvRdOF88SUzwa7ZQgRBqQnNCcQjMQAFuMFbb3NGh3qF0Hk/P1pNnVXKlx3bDbT4SN0kbVNaUmZ0gId/H4F4uiqqqDcg8lRGZcj1wvArQl/X8vZ8oagLePzOS0d7sEmCg2sHQAFdrNfuP3Jir3UzZ5cdLcKmKb+M4AbGFD/vJYc0QFTQLbabJvLdiGtMzPZD5XF7tiyUZQBliAlqEsSFSQTGRiNMHM12cqToSlnw9zzrIQ0qvCnnGBN3YTLbm+/Ml2H+FQobNulJsFQNGVA73qh6k1MS0fXrOZbSvtY05jcs2OkvvSmk03aqXaesmrDNaTfmS8y5I2OewNzH0dYOZPMpbzdBNcAwK/4TzqzaoEJ7KLEA7ie56XskgyHvukPITRnm5x2Dfp/pJ7OsDXdJGf94nQctccCF5oXxn/6spIBC+UYuFli42VH7K8BBc9m+CXSsEyBoYIllzcbASS0oto9FwL0M8sm7bkzadlOpsK6LOvo
 WwLEjcXq
 zX6TFZ3GJnG+WErb8g2PW7X04zmmawgS0SRWDXcSBBlGCDMLYE4pwoMJ9KJB8PmiTeKAeAsbMfum4zI4oHeYV49wCPlA1fFygfTwLgwfJVhsd83qxcreL4ktv5wRMZrgKkNsAT+INo3uPd7zckrG2sloPn8nFzb5orCyyNI3G4/SGdCtOFrBNRGWCw7gAsGaiF84bk07W57YeqSxs8XNdBfF71/Qnx+bQ6Dj0ZX5jCJMG39qvRciHklWiRtdNkWisIj/18t7kNP7l7nd43x6EsHEcYRw5zFTvX0Rgy27LhAQwrw636DtYntSwrRRwN0HsZVTO
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 17, 2025 at 12:02:13PM +0100, Thorsten Blum wrote:
> Use bool for 'hashdist' and replace simple_strtoul() with kstrtobool()
> for parsing the 'hashdist=' boot parameter. Unlike simple_strtoul(),
> which returns an unsigned long, kstrtobool() converts the string
> directly to bool and avoids implicit casting.
> 
> Check the return value of kstrtobool() and reject invalid values. This
> adds error handling while preserving behavior for existing values, and
> removes use of the deprecated simple_strtoul() helper. The current code
> silently sets 'hashdist = 0' if parsing fails, instead of leaving the
> default value (HASHDIST_DEFAULT) unchanged.
> 
> Additionally, kstrtobool() accepts common boolean strings such as "on"
> and "off".
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  include/linux/memblock.h | 4 ++--
>  mm/mm_init.c             | 9 +++------
>  2 files changed, 5 insertions(+), 8 deletions(-)

-- 
Sincerely yours,
Mike.

