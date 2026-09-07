Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9EF97C79F89
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 12:27:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B61096B00A4; Mon,  7 Sep 2026 08:27:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B11686B00A5; Mon,  7 Sep 2026 08:27:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A26ED6B00A6; Mon,  7 Sep 2026 08:27:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7F1836B00A4
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 08:27:17 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 189E51C01C3
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 12:27:17 +0000 (UTC)
X-FDA: 85186891314.16.4797939
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 5209B180009
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 12:27:15 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="jlc/MYhg";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788784035;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eL3zBt3IpxmFGDw65BOSrW32Mf5l1FD3fhg2/Op0+5g=;
	b=hAhymbE1v+9cHoBZNkSp9XYz2KHdb5MJpBDB2+zo6QKNnuPErnKPvY4isnFf3zPlKfCKbm
	ab4l+Vu3uGe2ZQUjRMwOLzDJ5z87N2eA20edqYzmOihvmpET6AknM97cRCty7ebXyhYEls
	tzx/45y+lijQ+Pi5AxjRXQBb3YMRaTc=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="jlc/MYhg";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788784035;
	b=elqVLeyyLkD2vtJJ8W5dP91SLQ7c2uNUUKQzMaY34RV25CsYvfUsmSZqVRHuWE1jtghXr6
	TzaaRClkGnVkATvaXxyQJZPCpnLhMv9OpXPEqF9HI1RAIzmCCt22XUmMXVBa2fS0K1CXQU
	PEIHjxtd2TjmqWqgkypSL3uXkYzR91U=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BF7D3601F9;
	Mon,  7 Sep 2026 12:27:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5F5F1F00A3D;
	Mon,  7 Sep 2026 12:27:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788784034;
	bh=eL3zBt3IpxmFGDw65BOSrW32Mf5l1FD3fhg2/Op0+5g=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=jlc/MYhgqv0aG6eZrLeWjZ0tGnGPoPIdODsxFIivW0bYt6AYdK2bLex3vnm6AV4g/
	 2bbJrWeAAzG5la1V1pyrR5riJvL22ar2RA9dZ7q8HIhyujANPyWInu0x8J0ATpgGYb
	 DaYBFTiK6CfRzIcqzo6d+5R3vCVcjJ1uXToY6GmAl4ccpTm4TPgA4JxveSHjjbP13b
	 45TMbSN9MeTPpZU4v2rZOXRPnCxAugYbjSEXckjdn3xjkvev94gQ+CTHuXpvIqYYc/
	 QFM/5ESkhGpbBJI/Uw8twuLfZ5nv6wNa6KPLAysDEhaQftWLTH5VbcptbAeuiTBvTn
	 FdUlhV3yJ4ceQ==
Message-ID: <674ddd6c-7854-4864-ac7c-df6823d3a37f@kernel.org>
Date: Mon, 7 Sep 2026 14:27:09 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 3/3] mm: khugepaged: fix folio is used after
 folio_put/unlock()
To: Vernon Yang <vernon2gm@gmail.com>, akpm@linux-foundation.org,
 ljs@kernel.org
Cc: nico.pache@linux.dev, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, lance.yang@linux.dev, usama.arif@linux.dev,
 zokeefe@google.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 stable@vger.kernel.org, Vernon Yang <yanglincheng@kylinos.cn>
References: <20260828055926.346744-1-vernon2gm@gmail.com>
 <20260828055926.346744-4-vernon2gm@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260828055926.346744-4-vernon2gm@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5209B180009
X-Stat-Signature: a9zyuiqycdyjxamxu6je947kwnqmqrzo
X-Rspam-User: 
X-HE-Tag: 1788784035-984828
X-HE-Meta: U2FsdGVkX1/coICriXbd7QuvWQhQYJa4Z58udVHoPOkBoW+q8N5cFNebU+QZsFRsQ0xxKI0LdWDVpOVjsW6EsfWT7LfFV3XhBz/rbymCH9vcZ+JpRZcccP00M1XsvNmE0E3VSjLtynhe7VRqnwtkmYFfF8DsynTRl96ELCdqHnzgLkPoG81C2U2bA12j6egfif89Guv89cm9lwX+o8m69f/0Z1q8ENd2EQU0E9TIZcpC8MDxnD+YehQ8ypb2beNZSxVlrZAQbDz0M5/KK1O4uiBamkv2jaIwrli/uSSIZjsHx1QLoqmxjjtHwvzSFv4NGJTAXrGDBm1RnursjKVwExIvA2PTVeT2lyQdpnQKRN5rCaoHzVcvpr8XY9hhKgdVbUOHVCIjQs0SUVa/ZO1yptwCILVAo7CZ578KC/tiVzixZHiB6heGmnyarUolKDB2Wif9Gw3JOPJJjZLhnBVKSiN1iH4FpBa5AB4pYY/hzEqKZj5KTdueafjX2okRKIYsEGXfrXyMPsqB5IfxEHOPZb1QwqH3YoczNFTlfZ+XPlyKvLxeJdK3abCv7tFx2YEOs++sRJTFyDrGfCVtbzIAHmm8yrAJwpxXi0lipGnA0/9y6XZEVutORZAFdoOhAg9kTLmo/4/2asEP2YhXAEc8oDs7+7MTBKCqzFpMs1D6QR9gPgonR141M6cn9i+rldj+Xzb7j98L/F3aUpJaamLZe912fUaetJKW6y0Eldr3+VXd2YQexRgJDaDeb5JRz3uuB7g57Idg4AiIFfKza0kCK+lwuOWeJ7jqR1xV5PCgIK9Eb1ojJHToxvr2EzkLZ5dmwrKO3ja3Xl/PPVw4xYL92z8ZgdKCa0SlpHPt09TI1abazTb9+KjcJaRcZ4vMNfsuP6nvObJYCW7fTFDBQFWI1rRoQ+lGqs9DHYlBfGWarQ27diAve1yRCx/fYCQh9BSHBsgbk7dNWLaa3G4W+7k
 sow6ZZYa
 97sFBhuHCP5dGUkyTvkvmyqBNnTUe3Kli8YuWiBUl91JLt81fAMmVqPKAU1AW4SPKLKhv8hYFAQEw1NyQ02KwZ/YMc+nIe/MLUhEbH7E53MUXF5sf6iGNYyrfAMwlg6Sw5xjckUwL5ElifKQ1ChUh7jbzGXvvgqTyeV1WGH0Zuv/R9isSp1B1UkERCey/mGX+z7cbRGul5ysrgR8fKzA2XhUtlqbF2CO7GCG3sbJ3omNNIvy6eqzXfb+Q6aqvADM6hWinHHwLdsmqXcDqWXy6Kf7HfUT9C8JzUVJnfrWkdBG80Pz3wXqSmrUQcKlfNkQHyJsXRNl2XceCDsByvHXkwdK/IFABBgYABtDsMhlIcTzVgaY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/28/26 07:59, Vernon Yang wrote:
> From: Vernon Yang <yanglincheng@kylinos.cn>
> 
> On the rollback path, folio_put() has already dropped the last reference
> of new_folio. On the success path, new_folio is already unlocked and can
> be freed concurrently. The trace_mm_khugepaged_collapse_file() is left
> with a dangling folio pointer.
> 
> So using the folio_pfn() before dropping the reference, closing
> use-after-free window.
> 
> Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> Fixes: 4c9473e87e75 ("mm/khugepaged: add tracepoint to collapse_file()")
> Cc: stable@vger.kernel.org
> Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

