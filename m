Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A456CA5FB3
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 09:43:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 16F596B008A; Thu,  1 Oct 2026 05:43:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 120906B0092; Thu,  1 Oct 2026 05:43:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 036276B0093; Thu,  1 Oct 2026 05:43:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6EB476B008A
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 05:43:41 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6D1841A0343
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 09:43:40 +0000 (UTC)
X-FDA: 85273570200.04.19766D8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 98CB9C0008
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 09:43:38 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ixg4HOJX;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790847818;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jbYqqO6L0tC70vJ8T9tWUJrt2qX9PBMqSKLMk58G13g=;
	b=yjU8pW2ZM9c7EM8y8g4SR6XQD/7Lv6ihz/ztftX7G4Le6hf5/1hJpLxwXIt4W9a8/dGUkJ
	8ByADZD+tJaal777vGRod8vuYGe4StaDqRUv0diPcslMFW3i4mXlY5B13sSXZWhwFPwkjM
	WeUsC8OVL9+NxoMy/Ay3cLzNER/jijE=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ixg4HOJX;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790847818;
	b=4+gD44QjzhCF7yuDxWl6PD4sTXz1RWXa5DAz/AIL+ErQpbxHtgVIqolImh8EizCuREvUDV
	JdAU0sX0iV2b1Lr3gKhnGzDD0/4L5w/6gMhLlCHNHQeEsQTtjNBMfb4YeDy0qPY+cmBrql
	FtAjKwgjoKA6Sz5JWsFvbiD4GL2VZpE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E06D041FC6;
	Thu,  1 Oct 2026 09:43:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 717191F0089C;
	Thu,  1 Oct 2026 09:43:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790847816;
	bh=jbYqqO6L0tC70vJ8T9tWUJrt2qX9PBMqSKLMk58G13g=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ixg4HOJXKpOk67/l+woDAoatIvgqwqw4jHhUSOCfP8bXvsHeWWkWJa+nrsIygzALC
	 zCQfQmhIwAhOwP56V+MEVGhmCIL2g2gJHC0NRGrL2Mf7ZA1NRq0c5lJBre3zw4aeIN
	 2HYblJ3iMwRLXkcrCEjpqjqEdEP0qQCR4VfIRNuXea1DMLYP/dLMX25htQ35Exsgu4
	 OrbqSBh3Wt5MdhHlnQe4Ie82xyjEXvqIhknAvs/1dvP53+PE8XVOjon4WZqqEQnH2O
	 lraYETzxVhXelnY4SbgcgwwUXqJsgyIUT4qqaUGtLGegAQLFwvgO+pemykz1nidfAE
	 MAd4wEXD4PYpw==
Message-ID: <c2988799-ef21-4e06-b3c7-3efa88aca99f@kernel.org>
Date: Thu, 1 Oct 2026 11:43:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] x86/mm: fix spurious warning on __add_pages() failure
To: Lance Yang <lance.yang@linux.dev>, dave.hansen@linux.intel.com
Cc: luto@kernel.org, peterz@infradead.org, tglx@kernel.org, mingo@redhat.com,
 bp@alien8.de, x86@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, muchun.song@linux.dev
References: <20261001081555.35485-1-lance.yang@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261001081555.35485-1-lance.yang@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 98CB9C0008
X-Stat-Signature: t449e8nachiaogz9st4yoqdq5uijcyhr
X-Rspam-User: 
X-HE-Tag: 1790847818-715243
X-HE-Meta: U2FsdGVkX19lrC0dhi5b/vYNdq4e7XruxGqFYGsXGCuS+1UZ3ZXMx9tDpa70icvLha6vt/LdvfdmRFR8Fqes20M+D4+Pa03PWhfpyfWbDb9viMRcvoHdxpoZW2g/kIoBzRnrKQa8fZpyb2Tqec0c/4WyzD9oh7DeKWvejs9jPieMrFd1myXUk9PbZ1moMPdsDhiVbOGj2uUGBQcHETT+hnwggZeOj0IU9hdUVQFef21hSMj+GNgOeFF94TKWBBLdJz4a71+fIHSw/G1+Hh6/4hT4iiNMkVRzKJQPaeWJWmL4vs9LTqv4HjU9ItKRrapWUDXQw+19K0ldfHJnJY3yZbvw6DTPwc20kopGljqfM3W33gVQBxIMahFzOHhSZE3+iCf0RL4oRu9AscCLCIE65Y8UHv9JCli01cZ+VmPGM1HRJMXBJi+xN0PUa4Js/mhNKPL+v290sULD/kj/PSsZXsfRrXsazsUFvwncmrK6f/ZzRZlvNJgtUiu9UG7QDsbIYpLAa+sC1DLIQJf8cx8IGQ4sCGI5LnbcX31k9Imek6DSjNJFzEzEQ8rO7BOuIz78pvl07/hK49k9p5msBhUIeeQhJ+//kczVV5Ns+xb+2QNfnafgL/dBdBGKSZVid1CZxQHVCTOvxbUERpevIDwlhgFpd6ZdPaPz3BgJVwvdBWqzmDo0Dj3YAMV6TOiXJ2clirtPCJA9tUBFfzHX6JCNybpJ1pAPZ+HElAM1jxTALKA9AGtVq97BBQo8v2myCv81ok4c54J+U0Z7sMKpg4q1LgLmGaNAUFeAq4jSVxTdJvlrJpDzUBgdZ8i8ZRIJ9wI+Ly+4aTnozIdTnMtsygBzEWDI1LpH3sYcrCjE6iQEY3tCAOURvk7h88iljkkK/tg1ky+qEPhUvcKtElCLzNX6LZAb8zkDaJHiKRr2wlZL7TpDhATGcfgXlHS8K20bxjkcZQaaToQZysX8tPOD1QI
 gBbV3w2q
 EY5ToG1jVPxgAwU0/YZmvMyQWZTppap+Lxeu3U+PW/jLfERSLlsgvAWPERYCwKBver+7wJCjlJHdsrZDRx9Da89gJnAfT1QdNA8QRQ6X0J7rjk+fOchLqc6pkBKHLfXG2ZGaxJCFaycghOMwKLSyi4UWHBYR2+RmRYUFHcQOliuMgTIhyB20/zEkpILD+uugXVmBA3o4E38wRADIRqes3VyAm4s6QC5yPa5E7Mdnqncc71LUDCUxPmhLr4Qty8weROv7UlmWjv05xoVLWsT+dPDLxeE0TEs9cedsCPPhqnr5N89VSQr3EImK2mHiczI9RYCf9Q1q0eQ5uQIGnqE76ZXSoFDGrr++BEDWKWkU0tmAqMiM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/1/26 10:15, Lance Yang wrote:
> __add_pages() can fail if we run out of memory. The caller already
> handles that, so we shouldn't WARN_ON_ONCE() just because an allocation
> failed.
> 
> Let's return the error instead, and only update the end-of-memory
> variables after __add_pages() succeeds.
> 
> Fixes: 10f22dde556d ("x86: arch/x86/mm/init_64.c printk fixes")
> Reported-by: David Hildenbrand <david@kernel.org>
> Link: https://lore.kernel.org/all/d4fac8af-fd71-47a2-bfe9-3c6559b92209@kernel.org/
> Suggested-by: Muchun Song <muchun.song@linux.dev>
> Link: https://lore.kernel.org/all/203892F4-B04A-4F69-A1B3-DC1619176C67@linux.dev/
> Signed-off-by: Lance Yang <lance.yang@linux.dev>
> ---
>  arch/x86/mm/init_64.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
> index 70e682180291a..8b6d86fb5a42e 100644
> --- a/arch/x86/mm/init_64.c
> +++ b/arch/x86/mm/init_64.c
> @@ -970,7 +970,8 @@ int add_pages(int nid, unsigned long start_pfn, unsigned long nr_pages,
>  		return -ERANGE;
>  
>  	ret = __add_pages(nid, start_pfn, nr_pages, params);
> -	WARN_ON_ONCE(ret);
> +	if (ret)
> +		return ret;
>  
>  	/*
>  	 * Special case: add_pages() is called by memremap_pages() for adding device

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

