Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C825F9D0C9
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 12:38:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 95A836B008A; Tue, 14 Apr 2026 08:38:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 90AF56B0092; Tue, 14 Apr 2026 08:38:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8219F6B0093; Tue, 14 Apr 2026 08:38:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 73A636B008A
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 08:38:05 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2A6CA160592
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 12:38:05 +0000 (UTC)
X-FDA: 84657113730.20.B429144
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 887D6180007
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 12:38:03 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IaXTiNtF;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IaXTiNtF;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776170283; a=rsa-sha256;
	cv=none;
	b=4XOOmOwrP4xca9bMs9+FsMnCL8oIkk9uTlJ1I8iMwRPF8Hl6I0tZzxuWv9Be8UmG5ClavP
	WgTmK4bFOOzZNgZuWqm4H5w9S7WmoJKv62VyutDTaow6bixDdW20LCpNNmUlGZ8cjiedFI
	aNTPZClC9aZaNzxzbN4pPSDoDkzQk4U=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776170283;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=775ju7wCYoO1oZWVZ/ztFF7e89XDC7wAykwRbPg04OA=;
	b=tbrOIFO2OLEEuT6MQ+iqaXMkzQh+p9DQCRNcpNeq/rI9NpL3v1MmH0AWkSEYGADNSUPNUk
	joq7BqeT5xqY3xUFawjSPOhHZlJKHAcGITJLFJXEo3+iv7+OhP3EfeEmHb/hglCblghTdG
	s/gVY7sVsqwirR6IWxeg+e/uX1H/r5M=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0F4EF60018;
	Tue, 14 Apr 2026 12:38:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA094C19425;
	Tue, 14 Apr 2026 12:38:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776170282;
	bh=WpsQdYh3RsSEUbX/HxUvuqrYJyMniU2vl8OSOnihjnw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IaXTiNtFvEtX5NXB9BTQimjNeumLA/t8mitwp4IaTpMoBb8nVTTU2OpkIl09v4h7A
	 YpHN/sIMxhiBpQ6cqvm2kRKb9kahQ1YYqDcB98guc2RUePyQwUtoFOJaRn0n3OhGT2
	 suwQgb1GAV3c5O2b/o8x07xRjCLr8Dr7S9/PTYpZOuXqY5bhdBRsmx52Qd3wk1oNTj
	 xaTklk/KrDMJj8EY+PPP2yaGD2KsnOCAcvUuLXj0qsGzNcs8V9YrvIhNc/md4R13eZ
	 AW0Kqy5/NDwx2JtIAUB7/sM95/84TlFEgkQf4LdHVZgj8N9nENWprqpBQDTE1zVXOh
	 cxJASu6UgpM2A==
Date: Tue, 14 Apr 2026 15:37:57 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: akpm@linux-foundation.org, djbw@kernel.org, mingo@kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH 2/2] mm/fake-numa: fix outdated return value comment
Message-ID: <ad41JQ_MjuPNhC3M@kernel.org>
References: <20260413154438.396031-1-ekffu200098@gmail.com>
 <20260413154438.396031-3-ekffu200098@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260413154438.396031-3-ekffu200098@gmail.com>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 887D6180007
X-Stat-Signature: 6tktrjsyf13pisfze99sonx49kre1f87
X-Rspam-User: 
X-HE-Tag: 1776170283-806417
X-HE-Meta: U2FsdGVkX1/NrFJduAGHVP3Weu8Ur1R+hQuZalJy1xJVf8mU3wvIIP9YhOnyrxDTpDtW/T1lBa8aA0b2Ou6NtjffJgeY615oHBCfUg6n2wyecffkRR5jMUVegq8XHbnVFn7/SVHMJDHANKMLyc/3RW019Nhrsffi+Zg7zx3DUeWuWUcsexxENcXqic2UcMkc1FAHjk6MPq13e9iQ6byoH9mSPVJOEpJVQ3nE7pWSC9RPofv3LU6Z2msqTO4z8jsgVzTSdpbLFM6S0D86AEJznCkq5BvEasuR232V8WuNidXFo2+KfcuJ6czSY9o9EDKUN8mat06D7srjy9MLxtz6mLMuz/Hu84QjB+6SBskk6B02YB/5ehp3xAj5FNFeJwnggu9bWR8RvCHCm17Nc928o7rw7pejWkEeGLM9L+LOTq8W0g/zS+dbQ+7XOYlsqV9d57+x2blGfOBPFcmmBTSIJk8XBmo/fshibKzyzPKD5Eu9hMa5AywcMwZDuriOoJfMwUDL81O4ShgHs2F72+k2zqNlaCjnSpT+e8XtgQq8wpybG08mxanJkv778134o9OjPS8NX5WiDt0Yf+TVLSN71UQEL3chYPcYLm1rqEPafDuzkPVLUTml8sgW9HTepUhcPZyTAXM3c704d9DWdGe30SaaeEcELzVTpF5aHgAiMIcYVmP1WEtvYmE4qOw5TXvUpgGrMkdl/hi5/lLC7Y+IMfuXgDVIjP+uCLDFzQVtFIDpJ61502O63GGNU8Ryqu/Pi56qs3SY7jaLZeyJUc0ImB0CF5A4IkFAuCjzA+I4xAAv4PP6ct9aSRgKOYi4MENYIPeHvpfJzR6+XMgbPalqlLflzE8s8G0BCxW9B4GHtEvGFP8/arQJWitnqQL+RtQVnsFR3ShU40YvqjrO/oOL3BBe5t/AT7OdNpILkAIqwaJnxqampRnhwh1bMXFlKG2U9IDKL6TcQZYsf0QtuKc
 zE5eaVLp
 ZFzVbIyH3R0RWACMHshwHCRXBJMPgvCzpnwVhAi5y8uufV2ObRJlYlSox9txvrbiK1SR5YfiarN+XfZARTkN0fOkvzGlHwDcJDQ4YCIQteQA33HxkKoIriPomdYMAQEpM7Ccuefb75o8ev6kSH0QmPAjwfuw/M/Ayo1PBBULcw7RJTu5tGKVnATIYX0jV8vQq2100ngP8F3oD7tbA4eaB+Aw2NHlwubQFmU4AT0yjKBJ4DBz2xzlmE+FMQy2aSFEa/i1+hhKrl2aeOlk02sXH2zsaRw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On Tue, Apr 14, 2026 at 12:44:38AM +0900, Sang-Heon Jeon wrote:
> split_nodes_size_interleave_uniform() returns absolute node ID when
> succeed, not zero.
> 
> Fix the outdated comment to match the actual return value.

This should be merged in the previous patch.
 
> Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
> ---
>  mm/numa_emulation.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/numa_emulation.c b/mm/numa_emulation.c
> index e7f856c8f2a1..c1d0a76aef64 100644
> --- a/mm/numa_emulation.c
> +++ b/mm/numa_emulation.c
> @@ -214,7 +214,7 @@ static u64 uniform_size(u64 max_addr, u64 base, u64 hole, int nr_nodes)
>   * Sets up fake nodes of `size' interleaved over physical nodes ranging from
>   * `addr' to `max_addr'.
>   *
> - * Returns zero on success or negative on error.
> + * Returns absolute node ID on success or negative on error.
>   */
>  static int __init split_nodes_size_interleave_uniform(struct numa_meminfo *ei,
>  					      struct numa_meminfo *pi,
> -- 
> 2.43.0
> 

-- 
Sincerely yours,
Mike.

