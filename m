Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38F0CD44C7A
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 16:35:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 85F116B0089; Thu, 15 Jan 2026 11:35:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 829A76B008A; Thu, 15 Jan 2026 11:35:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72BDC6B008C; Thu, 15 Jan 2026 11:35:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 606FC6B0089
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 11:35:40 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id ECFB91AE4A4
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 16:35:39 +0000 (UTC)
X-FDA: 84334749198.13.E7A3DC8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 1A0EA1C0013
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 16:35:37 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rwEAajmA;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768494938;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+v4xd+/KuFqeZKNdIJDEA02GcrXGWWvbn3HyEpVyDdQ=;
	b=KQzmfC0CwTppvlGDnBc2s8jhbv8NtZaeNmMVpVSl4kpxyC8w8/i0nXq26y1lS1JJuxbQqB
	/uqlq60EWuCX456/42p031e6aK/o6XjlrEf18oWuHoQcdgTixL9d0Zsp/bizpTsxSC6+Wc
	BFTMukuz1meePRY295GD8cTNLYrvEXw=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rwEAajmA;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768494938; a=rsa-sha256;
	cv=none;
	b=ibP4ucWWKLHunlC+Vx7saarBSV41MOHsnVqaPdd91Wsz8ZjvxyRqT444autQ3CPMrWLul5
	3VYL776TL/PDedC7rFDLneGPsHwiENZYVWork9zqwou05W3yN34J5acND5UHNzsGEGVjYq
	zhO5Bg1e9Uv1G596WiJj9fSav8Haa/A=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2A205441B7;
	Thu, 15 Jan 2026 16:35:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB7E9C116D0;
	Thu, 15 Jan 2026 16:35:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768494937;
	bh=WkGd+S9X8HZuOVaKovh1nuFPEjR1qyneI4tbR/riCJw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=rwEAajmAeF9Dju7pLBLBFA+V/SjNSUKyu5CH/wuYCzVJTlUSsnB8coQqV4jYsIAG4
	 fLhV7pCz8pipFqHSiIH5D1DvqiTVth/mZPKyaIs+YFPzzf0++Elb9W0nIYbCOBMAGa
	 eQ5qu3dzUOKiYyWcwTjoSxee80QO6JXP5l8yTU7x4UlVABuOXHxH37y0CzLekHzGOY
	 UbnfWT9iU6PegxtH7tddO4mX7QJBDCBgLvTrCGLrY4vSmPaJVYG29E9aj4n2jDUJAL
	 UQDJksMqf/UihFDQlYYaftNzKw0SFPzO6mSLlxgRL5DBqWDIfDCwLw6QhxT8fP+Ayu
	 OrpJ4/j+L51uw==
Message-ID: <be57dfa5-e6fa-4ce6-93c1-239436ff6e89@kernel.org>
Date: Thu, 15 Jan 2026 17:35:31 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv3 02/15] mm: Move MAX_FOLIO_ORDER definition to mmzone.h
To: Kiryl Shutsemau <kas@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, Matthew Wilcox <willy@infradead.org>,
 Usama Arif <usamaarif642@gmail.com>, Frank van der Linden <fvdl@google.com>
Cc: Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>,
 Vlastimil Babka <vbabka@suse.cz>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Baoquan He <bhe@redhat.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>,
 kernel-team@meta.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org
References: <20260115144604.822702-1-kas@kernel.org>
 <20260115144604.822702-3-kas@kernel.org>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <20260115144604.822702-3-kas@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 1A0EA1C0013
X-Stat-Signature: yse1k9dk6hsfas473sfjpkgkqaj7qd5d
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768494937-219268
X-HE-Meta: U2FsdGVkX19h0oovQWcUnUtdTHgdtybvRL9aH7aTEkJRJ+rAU6zJ99aclyCaOQXHb2Kw18NTDc+K+sqXk39MYVSzE6PF7S+BBU0ybbgrRjeDFP4HUHizqlH9aVZukf5JiuzGdUlwMP7GMlropW4XqT50FxGv/eWWEpdWTxQLYfvQPJPaVNW7kijm0RrSUQZ1iwpm+yWfSlYy9CP8FmwKKcKjrUKnuIzZbEbnOCxbJ50+FYmxD6+3G297GiV9P8BxlCWpdp+gONf4HcpSneW5VRXjy9xLI2EqgLP9xiGWW3Y3eteaVh/YOTKlZgYeThLWUgLgGWkmiQ4Bf+Q3irz7j29weHJSR+Qv0yVlr182DqvxBoCKC1RC3A1N+JCHhFLzUSh5aUcd2bbYfeFy4xbvBK9x3Kd1VnCgzu40L+1MJ8uTB7Ghp/tYWREFFRfxalUhGswB/HbGYVgYRF7q2R7kJolSerSZgOb8uTRxd9KwEpWgHV2gh6xLZbkheL9i/YOUTJLquwDDAlv4+EdDsdE7s/wA4nRRDeVA4Iy/+oZDYNUA/0fHxyskjpO+oX3S4PBSRg0VEI6QrmgP8jQSbCd1GGKGo5jx4F/jzzL8fQ0ePezzeSsLgubTeyHb5/n1hgY4A3Of/vNpdkHMexyhQOgPvMsOJagQ7EbuLXBfiQBgljvxU3+qctiIHhXDg9PIUzVzO6XQwmPcz2WdwVOeX5xJcOtkYfIXY5ytARSmSghZv4RkMxUtaB7Su+Kh4LsUY3ZmQ/VnSN5maJcIeiMLpoWJ3QJdKSRRe/EygpY3xtYbHNG8f+8lkpcPwp59OxbLp+NJiIZU4NR7JKvAmla7CuwIyMpPHVys3JCPvzleVn5CpNfg6WWE7+lDHgxCi1ylhbvGLretpxxcvOBW9VHyj7BA/EGBKV2g5wZJHCxwW+YH6Bog9mnFRMaXxdiehYoMcFmI/A7oaWunNWAVafqpUUS
 BCHO7Qwz
 frn+nNbd7zf/dfC5GBi+gsq43T4NeS5BRM5M9aZIRbKmRRSxTlsxiY0xNa2C+tqYURcMsgnFIiJ3y7HFgYnUbR4KlLq6S8KmW2bWDEqVwmMFdr5XLbhkICiCT8mw8rqKVS8Na9Ygoorq98nyukL8Q7buCSD9WWOTmKCCjdw14SZ4nelhcLAOvo+6vN7l7UqZ7EWiRjczXuXcxEA2UXCq7XiYm4G3FT0mFJiEuKVSm9LBRcJZIHfn4jeF01Zy6fivAtZmq5Jj7tCsE7MF1fxsU5xX7hFoLpEOWMVRPj6tO1/w7CZW/u9EpR5ot6A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/15/26 15:45, Kiryl Shutsemau wrote:
> Move MAX_FOLIO_ORDER definition from mm.h to mmzone.h.

Why should that belong to mmzone.h ? Semantically doesn't make sense, no?

-- 
Cheers

David

