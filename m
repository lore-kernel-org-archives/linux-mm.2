Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF179E98E0F
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 09:23:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 38C556B0088; Mon, 23 Feb 2026 04:23:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 30FD46B0089; Mon, 23 Feb 2026 04:23:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F15C6B008A; Mon, 23 Feb 2026 04:23:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 091F26B0088
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 04:23:18 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B8B3A13BC0F
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 09:23:17 +0000 (UTC)
X-FDA: 84475182834.17.BDF0EA3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id E1A241C000D
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 09:23:15 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sxrhJdMr;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771838596;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KbJL/WjWGchHlPd38HRu8YDMPbDAwgKsLbliZ3IOFsU=;
	b=uHPBLkKtc28oqvbBQRj2HGrSU9zxsKsoEFDe7igrFoprmW4IoMaRMeldXnuZvjPq8Fu8aQ
	8fBUthk3Y7UNuxBsiMtTKcYA2bw3L2Esub/FYd304SU2OCFZS2be4rDp0wRIjpJVixeySZ
	7L9BcSyMl3ibdM1d7M9wj4d+2RpMlgI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sxrhJdMr;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771838596; a=rsa-sha256;
	cv=none;
	b=bfNRwvOoqrf59QQ8IZ9GmhLLDX8gixmRaI1JKD8rFCMHFhbccGaTOQ5UhsoWSe8zYCflTw
	O2R5YIGgXCBpItC00T4ytZk+ZoAnAPmC2IihxgNYlwzUg4hzFZB8QiiE7FafM+mW+oSHkT
	uJVeh1YRIGV4VsKLtzV5URzT+LBcUFc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id AE2C4434B3;
	Mon, 23 Feb 2026 09:23:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C15CDC116C6;
	Mon, 23 Feb 2026 09:23:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771838594;
	bh=zmArd5S/gEW4hij1YFSxLiedM3qW9vaE6iDa8imNBi4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=sxrhJdMrDyvNGTo2+4rLETjfE3dSl3etSx39sar1MHn9UM3puwDLAAYVuFvnHHrj7
	 3K2ia82nNjfJ+0hf3CtQNK+C5QxJIyoeQGKobkC9Tsyev08aH6sYR1rTmpvFKB8+D9
	 aMpxVzuVTsnUHOuldO/nX13qdxjX7wIbTfmDvWiDX8kWzEzosKeXJCPSYVnQqDta07
	 o8JzYHMLIAI3YFxDJ5oevmZFojSd4UcKqKlEaQtKJ2gRdSfRfNEDbfkvegE9B0TXg0
	 kg93WwDpwOARQVfRsFiQ/9Zc6AcK5LKDaM3/HfdUyEH8TbsuBtqNIAh/ZPN0Lokul2
	 r8H7j0kY6N2kQ==
Message-ID: <3e22afe6-ecf7-4180-9287-c48fea7b8be1@kernel.org>
Date: Mon, 23 Feb 2026 10:23:11 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: A potential refcount issue during __folio_split
To: Zi Yan <ziy@nvidia.com>, Wei Yang <richard.weiyang@gmail.com>
Cc: Linux MM <linux-mm@kvack.org>
References: <20260222010425.gbsjzhrew3pg4qrw@master>
 <20260222010708.uohpmddmzaa4i4ic@master>
 <6346656B-7518-4A55-8DEF-C2E975714C8B@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <6346656B-7518-4A55-8DEF-C2E975714C8B@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 3wrcjehfe6fekezcei3qphyca96sx7m3
X-Rspam-User: 
X-Rspamd-Queue-Id: E1A241C000D
X-Rspamd-Server: rspam01
X-HE-Tag: 1771838595-619798
X-HE-Meta: U2FsdGVkX1/YalBzN1oFEF4ft/qavatD7T4TFiKeU60GEnsP4d6F1ORqT1doghJYABtsxA8bKXa6huyqh+CFpGXSMYxfflakj8ArCe8q3oVk1X1Wgagz81bqbX6oPbUm0uYVJudf79t+Tm+eYpoG+rtwH+zGrMNXOF5iF/hUJzdmIIEC3XsSC6Kt7dst0PzqBp+3PMRRp99xCidxz7mxWrhC3WqF3Gfk1a3AfyaDJsqDQSOGfm3G2odmx1pQZNOQWmj+u91X7Zu235z4l4H894Bd4aPntt2Wf6kXotfbyzDintWPO/0kz+k8q+AscS69M7VDG9tAhuIzr0DOJzHAt/3Vhe/la5pOL9cLJARF+6tngyrcGJdYRigEbgb9obd7m4EyGALIhdJmt16iQ3kFPpdFMN4CQ81aFgXbsD6IULEmrwKY0bT9OZfHnwcyRd3xm1Gv4LO9x96MkGfqiznjUwLv1PUtvznzYzGaB/4vD1iv8+f5BCgSPiB3HwHbIbz2k0mkFU0FKOE4mZOQY2PA7ZQ39W7vHUx2GjaC3RaeJ5LSC9U7PXW3Vn2hiwVAg/RyRJXAXljHsmi+SWiGaSlVhaKXIRWVbBZ+lfGVoaiYqJ1ztnTCMD6XY8UAPgZ7W2BO3CAxLGuMmoioznyU0cCpgkpxE1FJquhQFXJ0wCVN2NdnpSQRR7blRhpm3OchE6AePS/S6j/oa6vfG/lYXVqF5l/ViwSvy5Lu15KlQ2FitG4BaN+0EoZOQejzHYJHjn+g2MYOeLwtGYUH1IMws3remDUsOAnAUh7DY3/C2bTc1u3Y998YLvezQ/MYEFpHYqFfM12wI68tYEFLwbNxoOFLHwsEcPjyFSOcUsVR98LQei74+Y1rJrT0C5WToxu7/TfBMOTXD6u+I5KaH4orBL/trnSSghEFEQ8nLJZf/jv6qCI5sXSSxD/lWwUSEaEt+M0nObmBApbL9RHhRfx0HTC
 8Sz4ksGo
 D4CIRxsucJ90xFTe7L6LgoIdSIT3tjTrorlHfWzwqsTvpaCs1T/NdlAVB27d5bnhct0JWM3weS09SgE9PBNjJ7YCIekz9OVLn/qx6yrExh8f+kmaRKGjI2Fh9mGrLob91RoXkIs9uX9rLzzeOcrqWeCHJKsVDVwBLj3iMlX982VJlN31FbQfOhajnl1LRb9uCovC0Uj/4aiglJhruYeIvPfBk5H2+4yR00hLVp6gJAiEMCcWUdohHfSxe6IXGzUGiH6bE/YJX4YX+UWvpRmN6PSe/L8LRScwSCEjFYZC5d9/sn7pdDSYzImZ5Q3jNiLlZbOoZ+g4DLSSY8lZvkpGQ/u88BTk/xL2IDdY5B4D/EhuPbEg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> BTW, in the folio world, I do not think it is possible to perform the aforementioned
> split_huge_page_to_list_to_order() pattern any more, since you always work on folio,
> the head. Unless there is a need of getting hold of a tail after-split folio after
> a folio split, the pattern would be:
> 
> tail_page = folio_page(folio, N);
> 
> folio_get(folio);
> folio_lock(folio);
> folio_split(folio, ..., /* new parameter: lock_at = */ tail_page, ...);
> tail_folio = page_folio(tail_page);
> folio_unlock(tail_folio);
> folio_put(tail_folio);

Agreed. Maybe it would be even nicer if the split function could return 
the new folio directly.

folio_get(folio);
folio_lock(folio);
split_folio = folio_split_XXX(folio, ..., tail_page, ...);
if (IS_ERR_VALUE(split_folio)) {
	...
}
folio_unlock(split_folio);
folio_put(split__folio);

-- 
Cheers,

David

