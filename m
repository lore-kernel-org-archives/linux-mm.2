Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36E45C43327
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 08:09:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1DABD6B0005; Mon, 29 Jun 2026 04:09:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18D1E6B0088; Mon, 29 Jun 2026 04:09:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0539E6B008A; Mon, 29 Jun 2026 04:09:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D23CE6B0005
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 04:09:32 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5150DA058D
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 08:09:32 +0000 (UTC)
X-FDA: 84932225784.22.A27DBC4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 93B8DC0002
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 08:09:30 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=K5n7lsaj;
	spf=pass (imf28.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782720570;
	b=5ASNJMv8IQ9WtOFDQ9/jTzAvWt/q05hZM4Ydx9MpSWoIIBcJxiWWkHj9/YAH/jnddOKcmp
	WbN5RNPvQbhg4B6x4vvdP+zLWgGx5oj7hmoaS3GoxDM8h2yrpqdbhns8c8IYPaHaso++XB
	TwZTvzSTV9DNK5AF4GXuSUdkMOlD4qU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782720570;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=44+bTJUBMhRgc1glWGYNMsl+QcqK9OZ7xrCiCZqe+rE=;
	b=R65FIzI0AX/GzNaX3tCrSJWunthvKm+phV1o6MS7hguukmWKeqOJdFczxMaMvn37QHZuNJ
	Sacmk70/Bf+yow3C/y12is7Bcs3EUou7lRo8G51Odzlkc0Q5H167LxdoyOWHZsN5HmdxPH
	BpUXf/WOJWcmIKzogLlniYQ2KQyLMcQ=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=K5n7lsaj;
	spf=pass (imf28.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0C204600AA;
	Mon, 29 Jun 2026 08:09:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F37141F000E9;
	Mon, 29 Jun 2026 08:09:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782720569;
	bh=44+bTJUBMhRgc1glWGYNMsl+QcqK9OZ7xrCiCZqe+rE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=K5n7lsajoIehb/oSiq+MZAiWttyMEZGgSAC02u38icD4xTo9t9GVSKpVWNzlFtmQg
	 WjfcB04h34+RIo38fhnRTNmhyPnQXtPhG4ahf5/QHSjR0sk1JQnMQOkxzjRxZmsrxT
	 ePXEOZh1TKkFEa3dpw/GMSBcSXgv7bWhg3xn7oiibyhs4BF5wmb+3HXw5FzT3YxAm3
	 auHKWNBd/NI9RnnGRkBn7o9BmEjaO2vnKfvKhyD2UeT6gBeB/XaNQn+GmLsnnGS8Xj
	 YfAZz6lpXX+/P9ShF+cTVxPjGNtcoH+6uzlSCU116SAvahdrPAbAcsTWKFV6eX2YEZ
	 J4V54XrH50mtg==
Message-ID: <5e207115-f6f2-4354-a1a4-6c001be5ed04@kernel.org>
Date: Mon, 29 Jun 2026 10:09:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/6] mm/page_owner: hoist CONFIG_MEMCG to function
 level for print_page_owner_memcg()
Content-Language: en-US
To: Ye Liu <ye.liu@linux.dev>, Andrew Morton <akpm@linux-foundation.org>
Cc: Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260626024550.25677-1-ye.liu@linux.dev>
 <20260626024550.25677-4-ye.liu@linux.dev>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260626024550.25677-4-ye.liu@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: itr7b3cosdcc9s1rrhzreeawg4uxf9kp
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 93B8DC0002
X-HE-Tag: 1782720570-246757
X-HE-Meta: U2FsdGVkX1+oz5MFuouOQrJs6mCRYlBOckpn5OhE3H9ee0Nk+zFnkHTJeiSza1S4UprCJ9fAtr0IRvdlEdOGwBnxwWcfYfUoDKOEX/BcqBrx39MgTN0hYYqmQhVZisfu2ajexnoPf0DuFYaXY8HVeaAhVRlY4qaRRSgtQXfa503ZwDaj+7vzc1bxVcGj1656iAcFJ419J/evPOJlmdiLcKR9RU6BPkx53SNAL3rfxLOfPeZCGY7an/EgnXmLCQtUheQyLImCK6m8978lr+0b7plLOle6qlFEkgjfhOfmkgZNTZFs/jlKtMilW06hKyioCQUN0HT23EgZt8kiFiE1nfJIOHDKKDpBQ0M2ccxB/mlhM7ERIsWj40T3uajE19rmkDGkaVCjhjqIOrkUkK2OOtZ2dXuqNWJEyhM+P8UfgJqR/rDlgd0cSvnIhZAN0nG47eawBWWuPbcHR3zJlwBM731Cw2LaABZEJzeh/jU6rsbUR/clvjAhYxhiMbJiAKLYaFHukSp6H9sepdLtTMqQmxl65oPfM6yCo3bBDWcRo1ylQhvp9VY/9JN/uN1vlJY+4jQ++FW9bw2md3rkrvOKyJKP+fyVFzKNrT5TrgxUvxlvr8K4+HOE3UYmHnKpr41uIXAsw/mL3P+gQfOduFiimzkzyI8/PRu1nkTmSOMNhDVABbSrAUFkF3GL1/Ihwlv6EA+ZSCAMZut5mcMi4pyUwQkGbxp1wT1KNRAt72971PX55uSY2P57v34H3KaxNZwuBJ6UQ3Zrarm9xy1+vqZG2Mie/Fee2U+yTOf4t6dZ36zt0ylxlPkriILRnaQ/l+0dO3f0yGVoILJivxDcwpH1tdnoZFiBfcaEhQNNEzCMURoApNfDKr9BMvew/vrQPwpxSxKVLLZzA/mZKTY4VW6gAA8DD90XDZBy+h8BiJjnIDTaD8p7m74+tGwN/G/QnfLKgV6rUhR5pFPrdpjU/NG
 4a7+5YAZ
 ze6th8HDN7uWUZvOIUCxkp4KRQDG8+p7yFz6Nw6bHp7OkPPzKcvIJ6DEYH9dw+KVSh7gCIDHg1OkH0GBMaWuu1ZjpOY30HQ8N/dzZjHTSRRxsfJy3OqnZ2lzb5RjPzwnRTqDrdpwQB4OTRjsnowJILNyOassZxFk5M8jMG9imnNw3YIUKt8D9YgM/UZJnjNLlyFsDF7ONmm6h33yEWuv7Xg8NP/53su5LVzjx/DLrekHBwDn8BFN5gIIGWtu9Nv16Iuj+X3RjC8f4Z8qbkfS2jAUQ2/uxa6OmdfPqA0IXHmee//Bljb6Y8pnAJFgTc6I4BiCPSjSouiFlfVg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/26/26 04:45, Ye Liu wrote:
> The print_page_owner_memcg() function has CONFIG_MEMCG guarding its
> entire body via #ifdef inside the function, which leaves a no-op
> { return ret; } when the config is disabled.  Hoist the #ifdef to the

IMHO it's not a big deal for an internal function with the ifdef block being
so straightforward. But whatever.

> top level so the real implementation and the empty stub are two clearly
> separated definitions.
> 
> No functional change.
> 
> Signed-off-by: Ye Liu <ye.liu@linux.dev>

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>


