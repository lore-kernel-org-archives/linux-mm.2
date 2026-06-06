Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2338ECD8C88
	for <linux-mm@archiver.kernel.org>; Sat,  6 Jun 2026 16:11:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 07A6B6B008C; Sat,  6 Jun 2026 12:11:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02B756B0092; Sat,  6 Jun 2026 12:11:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E832A6B0093; Sat,  6 Jun 2026 12:11:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DB85F6B008C
	for <linux-mm@kvack.org>; Sat,  6 Jun 2026 12:11:29 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 70E5D12051A
	for <linux-mm@kvack.org>; Sat,  6 Jun 2026 16:11:29 +0000 (UTC)
X-FDA: 84849977898.12.E82E73A
Received: from ms.lwn.net (ms.lwn.net [45.79.88.28])
	by imf19.hostedemail.com (Postfix) with ESMTP id C55A91A000C
	for <linux-mm@kvack.org>; Sat,  6 Jun 2026 16:11:27 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=lwn.net header.s=20201203 header.b=Zdl3qL0m;
	dmarc=pass (policy=none) header.from=lwn.net;
	spf=pass (imf19.hostedemail.com: domain of corbet@lwn.net designates 45.79.88.28 as permitted sender) smtp.mailfrom=corbet@lwn.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780762287;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DqGXeDqpKIvvW3QQbyRaGwc6KekIm0MprRWgRPkr2tU=;
	b=DP+7LjZiyKrBViZi8kV98Cdds/N6D1E2xPoKn6wKKi4Wdd5aj1F3v0xEP90a5SjdmH0DyK
	pi+zCbuXZDF4e+vYg1fiNrZdp/qpy1IbYcwCnyGNERIHEWIMx8vcWs1oaFSU6ekVKhhO9o
	UPWMkoU4xBQGI0EXRV+bJODurEj6gBc=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=lwn.net header.s=20201203 header.b=Zdl3qL0m;
	dmarc=pass (policy=none) header.from=lwn.net;
	spf=pass (imf19.hostedemail.com: domain of corbet@lwn.net designates 45.79.88.28 as permitted sender) smtp.mailfrom=corbet@lwn.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780762287;
	b=arbGouRER3NulAxF1UbwWucqJ/gH7fWwhBhLxs4PcUFN518TZgYoPD/aHEKWF0Wzr0zunJ
	0DvdiN1O8Rk9gfTgSnmL+sypAHVSDOxV4Pme2SY/q6hxVLz+pAbXgWBjcgRfORH99ikNnO
	MrA567XWpe/ZiGcvv+3rGFY/gmgmQe0=
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net 4EBC040E33
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
	t=1780762286; bh=DqGXeDqpKIvvW3QQbyRaGwc6KekIm0MprRWgRPkr2tU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=Zdl3qL0mTPsA6dWXrgZkxtue29RQ67FMWdoCbH7C1EURLFFPmbcbJZu3qW9J1lYYO
	 xPfdGc3JATslC7hfgaVGhOLRgNZEtQxW/kfDlAWKh2f1wfxYzbHnb/pJZYxcsvDFGA
	 9p8smW9WhagTrBFUl12X65Fq4Rwwz/K5X6xpJcJMHY0+uMNE6qZqKsCYgHV4Aodc9d
	 /JzuvNwAWkaobPXh4Qodlx0Yg7qhPqq0/Ob+yBMnECyWV/hbgToKIy/oIpeJUJjw2i
	 2Hgt/qtdbF95eGHxShpp//CGCUHOR1WOBvcT9u2FfLDo9jVlFnMLnO4bRI8513W69L
	 HNABuMEWjFvTQ==
Received: from localhost (unknown [IPv6:2601:280:4600:27b:67c:16ff:fe81:5f9b])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by ms.lwn.net (Postfix) with ESMTPSA id 4EBC040E33;
	Sat,  6 Jun 2026 16:11:26 +0000 (UTC)
From: Jonathan Corbet <corbet@lwn.net>
To: Mohammed EL Kadiri <med08elkadiri@gmail.com>, Andrew Morton
 <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@suse.cz>
Cc: David Hildenbrand <david@redhat.com>, Lorenzo Stoakes
 <lorenzo.stoakes@oracle.com>, Kees Cook <kees@kernel.org>,
 linux-mm@kvack.org, linux-doc@vger.kernel.org,
 linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org, Mohammed EL
 Kadiri <med08elkadiri@gmail.com>
Subject: Re: [PATCH] docs/mm: document slab cache isolation with SLAB_NO_MERGE
In-Reply-To: <20260606155856.15548-1-med08elkadiri@gmail.com>
References: <20260606155856.15548-1-med08elkadiri@gmail.com>
Date: Sat, 06 Jun 2026 10:11:25 -0600
Message-ID: <874ijfvec2.fsf@trenco.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C55A91A000C
X-Stat-Signature: bo6fikqdcd4n3df59mzsj1x3wi4wmks4
X-HE-Tag: 1780762287-287508
X-HE-Meta: U2FsdGVkX18eesyehW/x3uTJexWG9pdOT3QmNv7F0lCbLYb2vVG0SZnjL3WWQ+Z6rpwk6VYyduR5hH4s06x3+BJCDKi3tbBD7KoZXodORUQJJJE9iqEgjYnchiKy8DkSs/vqltUMpJgHphq9nl6WyGOK/rtDC6O3brShvBejCXnhDetFZmz3dkcFMJW7kBk1WAU2gjIDjxQcv11ZSI0vNxC/ipOurG9J9unOykIf0hHK5Rjb0lKMV59OmijnyVlCuRNvghpD6hMMa7dYv3ctMo1NNeoZRyVcmiG5fweiFvD/ZUslM0NuM7b5Tcxq1Q+Fc5UyOM8y5tUS9/XNLiGRC5y1e82GkbItG1jHII5toGDaf+vNWaUvLxekbYI/usiHjVNG4NjBPw0IFnFdCofL3DyqogeCwJf6BU09A32gPO6GHJEd55DEkCGKMp/diOzCu9npLT3XYFM4c4DyDUhniSA3+HMv4bhF8FmIsdWsQGVqqY1/DK/kfHOSv/fIi0SgsQAdm4MBT7VCEc//hcUz1wF7XW97QE83dLJsYncZ+FNJsmMuw3LYeeuRZP9jO+Arz0/rZJR6jo+O1BM/OUq7WOK+yxpS2xE234YtgdQE3vEUpM4fUqTCOUDVBmd53S2SGl1hnQlKp4udgry5fxWT90PBuy8XH0L4CqF1soB0AbxMCQFwL1ra1QVC8TKu2iBMmmZ+u1iUxdMLF191GAlZnC0pBoC/joVwoR1cOfcMDsV3wXz6TxpbwYQb7+8iLU3gk5FOPyI55JSM0vsiYwInnsQZlo2weUpH7pwfXmgngwdyFFbb8g99gIFKLetr3qnpxjXX510ylKP+VIgBBZ9/bqLzq8mCvGTqQ/Y74w0WX6+A/oH4ALNhWjyD3K7rxWmHxzy5Jt0XiS/zXTrbCRKTxQDHiYg62E7Wqj1QyzlUS6cXQ6WcFzxSeVMk6xJl2+eAU4AsNlmANbogay5ugvE
 gevrA/0d
 pteck5HBUK21fDsgX78USQ3NPdm2/eCa9tUmlSUPC/Mhyj65nOuvbzPPivHY0cv5lUi0KnSANIl5xmk/jJ5gjNK6ce3TuuB4j5z1CRo7nJbOW2fBWUxgLM6Elvedg5kB2wgjbgFY2b8VOIPvexEHH2MflXu+SMCHGNFKXcyBRcxefvkAE4BkKQix058W+EusizwlYHIgqSzqNuu1AvKp+HbnDNwW2TcXG37TnXQYNsXYnM1iZqc6yGsvlooqkpkjw3KUhy9/qkyY9ArLiSWx7vxd4GMooJkqv4laErCFSaVomfQI3OMgJmbapeSVwUhcZUzHBvaybywn0s6/m04vZafJGhN/WrI55WfrGRoIYh+aVBlUw0rC3fwqczU9T/7nQidlLpAoi8lr+0yvTNerSUmS3TnOgWc5zqB+t/ElQShsgbcw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Mohammed EL Kadiri <med08elkadiri@gmail.com> writes:

> Add documentation explaining when and how to use SLAB_NO_MERGE to
> protect security-critical slab caches from cross-cache heap
> exploitation.
>
> The document covers:
> - Criteria for identifying caches that need isolation
> - How the SLUB merge mechanism works and what prevents merging
> - How to verify merge status on a running system
> - The cross-cache attack class with CVE reference
> - Tradeoffs (memory cost vs security benefit)
> - Relationship to CONFIG_RANDOM_KMALLOC_CACHES, SLAB_TYPESAFE_BY_RCU,
>   and the slab_nomerge boot parameter
>
> This information was previously undocumented, requiring developers to
> read mm/slab_common.c to understand when SLAB_NO_MERGE is appropriate.
>
> Signed-off-by: Mohammed EL Kadiri <med08elkadiri@gmail.com>
> ---
>  Documentation/mm/index.rst          |   1 +
>  Documentation/mm/slab-isolation.rst | 113 ++++++++++++++++++++++++++++
>  2 files changed, 114 insertions(+)
>  create mode 100644 Documentation/mm/slab-isolation.rst

Thank you for working to improve our documentation.

Did you write this with machine assistance?

Please review our documentation and adhere to our markup conventions.
For example, function names should just be function(), with no
additional markup.

Thanks,

jon

