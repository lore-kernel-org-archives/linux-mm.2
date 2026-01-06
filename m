Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9920CCEFCF0
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 18:46:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 08A5F6B008A; Tue,  6 Jan 2026 13:46:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 038BB6B0092; Tue,  6 Jan 2026 13:46:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7D026B0093; Tue,  6 Jan 2026 13:46:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D84F16B008A
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 13:46:34 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8E55E1ABC8A
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 18:46:34 +0000 (UTC)
X-FDA: 84302419908.14.417E288
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id CEE661C000B
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 18:46:32 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OzV1Iic2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767725192; a=rsa-sha256;
	cv=none;
	b=xE0jv/T6YIEo+y+YzYMngR4Glh8h51RXeInbCgJ2Htm98+kKALZf0yvpXWHVfzHMKE275q
	qfdge9T7FXmsH3jqudcPbL8hJWoAIp9ArGUnehYxE3nXmZK842BTEVTdKkxqNvOGeUOWW/
	705xF7/y3uNr9wpYS3v2NL+qUM9behs=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OzV1Iic2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767725192;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sog+fLGNGr5AUzPGLAm/BqHFTxEnR45anibRIzvom0c=;
	b=GYeiLT0jimyl/WV1woelFeZob3ZGLmozgUXqaYBBU8vIybQRnghNZEFNGJBhABmoCvH5HM
	BuOnm3PciWqQO5ITBEIa8/YKEzOTO6JlWpVezCXVzn+7LODJW1CUjf6eU+IRaJpCClWme3
	F6kNw5MVvadeTx7X1fx8PkoIdSim9+Y=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 05B476013D;
	Tue,  6 Jan 2026 18:46:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93274C19423;
	Tue,  6 Jan 2026 18:46:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767725191;
	bh=KpOiVaXPjG1PAae7sFpgxWI7yXFuwOVZaMip5iXibeo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=OzV1Iic2K0TUMTrBbT5fK8X7C6A4aWz4pzAe1tPMBnx2TNo1FW33ZkD7Z9ZhYEHYX
	 udfnJ64qUWrQJoRZAdTf2ftf16YShoGKjSjv3CaTjsdCeN4mz8ziGZW/yIdOsv7kjB
	 UFIm/no8sqYVSrF+wVlV0cgar5KDdyFdUARp+cKOlyLRt3zPJnKHBxp7k3nt5GTYsc
	 AK2wUk4OhuJJk99B+3K2oFhMNQBlyXQCOsH8LDFQvZXpYXW9Z1yY8LjKUMcNzAb+Z3
	 iX6u6RGXIVCQz9xKP4RSZBVgjiOHYu9710GYkZiqa5QPIaxp69RIZdIfBX3ZG/UgnD
	 Cwj1Yo3RS+uTA==
Message-ID: <9c807ff8-b4ad-43d5-8034-ec7fcd0fe5d6@kernel.org>
Date: Tue, 6 Jan 2026 19:46:25 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7] page_alloc: allow migration of smaller hugepages
 during contig_alloc
To: Gregory Price <gourry@gourry.net>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, kernel-team@meta.com,
 akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com,
 mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
 richard.weiyang@gmail.com
References: <20251221124656.2362540-1-gourry@gourry.net>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <20251221124656.2362540-1-gourry@gourry.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: CEE661C000B
X-Stat-Signature: hmpeearm7ajp7tk74yoc11nst5okmn8i
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1767725192-955311
X-HE-Meta: U2FsdGVkX19k4CLCg53zk1FkiZPgsSnVHg/eX5urt+7KsnAW+Sw5hByA4iblVBR4UyekRHqUzWPp6BCT58qYICILSgyVoT1/kwlg5ZyZhAB72ifeElBtBM/k7VLxadu84VUhn9QOOOMOtVqstnT4PTak2ydihQb90wmaC95VsBiZCcvgDkmM+bqwQtu5f2FNcEkkbJBzCncL4ZL8jDjStwyeOLtao3BIX9O5c76ae900lTELNh88IxkqdWz2R5n+VED56T5rUfAkq5MXqrMJpLsj53vgLckXFMIaXRFvYqoMsDgSCT2vnTz+WycwbiXNVkiFwLejMZlMeJFs/aC8BKo+iNU8biXAiPVPspGQn8aNtItX2BmxvNIalqu1ZEveY47hiYPjten+9Uiw0WxvqFG/JuQn9ehJMxOmQ2u5HdvEcbdmNv4xhbbtoij4W0z5jC3KwMG1IEz7UByJY49XdHbHmAoxif9tm1jlVAxtMjCOPRLtxHddEaeSkZI1Uc1hZJd1bahhohEbatONqbhrUdPS9ITMN6CobdFfnEJXfGFdXLepH/hqnBxEb+hMDu8TKkvQE4yjsj6cUevRmFyhjQSZ565vIk42pV21HIBT9qagsPp7ZSPiaj3Ivzx/GFma+ltEu7RSNEkZz4nAbNbQy6hZbD0rhJugUqU+Kntz10ckPWtuQQaMl52fer1Md+hHetQIWs1PLLaoKGKElO0hTE+2v5wywfUpGvh+M9jqA72BLHbwnrrHiQXe8Gd6EW/daoWcPFk4ckeMF3a0ZsWB5deN75Cz14O1rek8sG1xXl2jI75fIq9Wc/ejHxmQsZzG4nWqJie/vCk6e41phR6iT5p1gHPpYGuRBbSphU+79hOUbXarAsMALfhfgqok//wxL7NRLLORIzh+JYRuoeSRth2iidHW9WIm7V9N3K0XYEluR3c73rKegth2bwec3gGtQGglOgunEwUWJUKCC0P
 sSZ07Lta
 5yn76RanMUb+T/jZ2swdbhBYl786rEnAGNahBU8M10ZWnPaOo8qB/rsLjByxmy/yUrhDB+cfOBVyPpB98E2wS9tN1hccpgCcBf9inaIZwX7h/sh00m3I4ndBsruuoFctRnuWBG36/xdZJULS1DuIKfRiO2eyf6wJw2GBPoodAa9apXLaVdh+KuLf4YrOnA6InhpClgKIEuLoTk2vvIRZndnFJiUWroBbKHE/ZPTWogAJB/sUWK6oKcfmH5Icmz1n0/fo4tVVYEzeZJjVz9gNMbDySzkELk2/TRCcnRsP2/fahQ8BSTwPc7nmp7SXMhZvmxq+I/sLFKaG9RFV6qMx89sDj8KoPRVbR8NpRUwXOuY90QmTta27sjUVn2Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> -			return false;
> +		/*
> +		 * Only consider ranges containing hugepages if those pages are
> +		 * smaller than the requested contiguous region.  e.g.:
> +		 *     Move 2MB pages to free up a 1GB range.
> +		 *     Don't move 1GB pages to free up a 2MB range.
> +		 *
> +		 * This makes contiguous allocation more reliable if multiple
> +		 * hugepage sizes are used without causing needless movement.
> +		 */
> +		if (PageHuge(page)) {
> +			unsigned int order;
> +
> +			if (!IS_ENABLED(CONFIG_ARCH_ENABLE_HUGEPAGE_MIGRATION))
> +				return false;
> +
> +			if (skip_hugetlb) {
> +				*skipped_hugetlb = true;
> +				return false;
> +			}
> +
> +			page = compound_head(page);
> +			order = compound_order(page);
> +			if ((order >= MAX_FOLIO_ORDER) ||
> +			    (nr_pages <= (1 << order)))
> +				return false;
> +
> +			/*
> +			 * Reaching this point means we've encounted a huge page
> +			 * smaller than nr_pages, skip all pfn's for that page.
> +			 *
> +			 * We can't get here from a tail-PageHuge, as it implies
> +			 * we started a scan in the middle of a hugepage larger
> +			 * than nr_pages - which the prior check filters for.
> +			 */
> +			i += (1 << order) - 1;

Assuming page != compound_head(page), you'd be skipping too much.

You'd only have to skip as many pages as pages are left in this compound 
page.

I think we have similar code elsewhere: see has_unmovable_pages().

Apart from that LGTM.

-- 
Cheers

David

