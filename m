Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5DE32C79FB7
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 14:00:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D86A6B0093; Wed,  9 Sep 2026 10:00:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 388C96B0096; Wed,  9 Sep 2026 10:00:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 29ED36B0098; Wed,  9 Sep 2026 10:00:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0CF886B0093
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 10:00:31 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4E1CD40212
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 14:00:30 +0000 (UTC)
X-FDA: 85194383820.09.074E6C1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 6C0C32001E
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 14:00:28 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nMiClv1f;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788962428;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xYPaXFevKaKGglLFP894aQ9Q2tDiAAKyzOg7R7AUw/M=;
	b=eJ6DZQXA5WIj+LdKa1Ysa7jffx14NSeN1yVSrsLeNT25gPBNTn7eLY3PsrAx0LhbPOYW1C
	wKNxJ2O55kd7+aEfCDUVQd7bXaLkVvoEwNipw5hOckdIWDtiBuCn8rcdHhACiqTLGqI3Mh
	+qIqKtssW2Iw7r2e5G+rGaQ64usj1L8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788962428;
	b=x118TyAC+z4TWvu90x3p4DbUQflBqAU65umaiKDTqG/RZuf/sknfPJ7UjjfYO5vCYn9yfZ
	g+Sf5B9z6EMvwUy54JOd3ap9IQllM67KnfN+6Ao7iKNkFGRoRBvct0La2kBjiN2KpQz0zI
	UuUEJNyoj3G10h+ySEPPaZPmW9VO2p0=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nMiClv1f;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0A45C60214;
	Wed,  9 Sep 2026 14:00:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ACEF1F00AC4;
	Wed,  9 Sep 2026 14:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788962427;
	bh=xYPaXFevKaKGglLFP894aQ9Q2tDiAAKyzOg7R7AUw/M=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=nMiClv1f3FTqqXWOX+v2hm7AwnZYICX7p9jnt49fV1gm+A1HQ9JLyH/fAM8CGpK8y
	 ap2t1jkiQG3JYX/pLH4RtA3HEo4FrN05+8EjgkNL9dNJ28iH85oUuVa4spd2BH03k5
	 ZJaKeSLB438Ymhe6783X6K2K6BXQ/HFiErAw5CygVA5s36HyNjilVxZujU17Xnpijz
	 mr+/zRPTbJ/nz6R5a3c7iYAFe1SINvA70B9ZUvTWV/5AbDLKxmDht6BNj8g/QP9h/V
	 CZNYWh9+6DVW16SGOIlF9E7TY9CXw1HHi979DSzsqAj65Ivv10ESqMdYZAh9/qKuWE
	 BvpXtrcBuJLyg==
Message-ID: <e1e59b35-39a9-48ca-8c01-0b9db8202094@kernel.org>
Date: Wed, 9 Sep 2026 16:00:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/8] mm/rmap: use folio_page_swap_entry() in
 ttu_anon_swapbacked_folio()
To: Tal Zussman <tz2294@columbia.edu>,
 Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Rik van Riel <riel@surriel.com>, Vlastimil Babka <vbabka@kernel.org>,
 Harry Yoo <harry@kernel.org>, Jann Horn <jannh@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>,
 Chengming Zhou <chengming.zhou@linux.dev>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org
References: <20260908-folio_swap_entry-v2-0-ee6d01dfa5e1@columbia.edu>
 <20260908-folio_swap_entry-v2-3-ee6d01dfa5e1@columbia.edu>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260908-folio_swap_entry-v2-3-ee6d01dfa5e1@columbia.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 6C0C32001E
X-Stat-Signature: tgkctttf9aos6n34jnu8eqjqk5iy848k
X-HE-Tag: 1788962428-210086
X-HE-Meta: U2FsdGVkX18ZlIhQEN2u2qftSH8/td0nz/xV96DMd8BidAVskuekaUd1sKLBoF+78dLo3KDplMY8a20EPKa30BJTsFtg6HE4ICMpoiTa5FNEXMkj62e7twheFoOHSsf+kDp2fSNyas8prI8zAHTAv1Xo9NNJfuwz10XbX2gT4/xtyO7uGPbo6rbwQ4Ob32AiEcUfNXwWW/TaJI7U6Sy9oBXSlXHbg7XXEyL2Nuz58q9pkWWbghpsyE/AR2KClVNJJTJBoOtpuggdrapA8Tf7jVRRyL2GPF8JVD+ggm3LnMavdmXxC7Y8FukPmuMo/XURYN5/c+p1XzNSL0CpV/Kcf7BZ82yxuZOatwpvjsAVsUVKHFCqI2AFHCc2ZmJCuvs6yd63gNfthRaBA5QToV7rcwcSgxsdrF7DWHru94kFgtHm18wqtgHvBLSWvQH63U3y78AJr9FuGZ1yPXAb9hgwBpYcJ2GqWby1hk2usmOocHlla160xkExIZyIFo9t7sw8XNnO7qc+w344IqYK8lA3fJAysCVaruzkAujV1/BAQtYDIx1hGmFzsPJomQBtVFYN1pg7LkAJZJoDUCU7CAdb7c5uUZ1L3oEEJyj1BAF7AlU9VwL4OA85UCwGTxWezCuU0TrGPLWlDa0XItmtIBPXYTwT8D5ZZMU1pSVC7dCYzm+7yySTYU/H/sVtwAf85ji9oqWI7EoQm2uz6kpkWVLzJHzFdH8nqQ/fU/pCclA2Ih0gwfdChZfkCETyZnt42505pkpXCoy22DdG/ypTJkyRNcQpjbDsiKoted0ghE99uBXEoKq7oHErojTne5nYWtU9hVpKgm7/wDPT7WcrDcMI6Ls3uZvH3D2CiksjE1naOhN3HW/e5x+bfK6Aj9Uf6AIjJYH+xUKcSLsft5aHDH7lkktJfJfY9pYconsSH6CL0RRg+Fu5MdDs3ASqOCNX+j8dFtYK7XiUEnDLg6bnhbx
 ddX6tsT5
 zljEPYbDaSbYyTHmzSm43vc2daB24wAOiA/PzihIwmw615NnsdE7m4HuWAfqsKNByNqU92gZVjxgEXK764VGdmbw+yhzN56690ZSFLadWyWD9hO6JUr/Ex12wkpSt3QPtT7UvKJxiX+ACDXJQf1HW3zHetSuelhSiOeikmit6GAu4tBEjW9Mn54oSaLi0r3GD+g4DpODmW/vZxomOw0HbvsmxTiJbnSP1zPVpv3q5+MHrod1nl4jAjHwoN82gCpqjYgsU0STu7dccN4sdivbEFB7KCZANMYMKGyjlLjwhjRGwHpcST3fkSdwE9fhlC8yTlBviEmn5y2uyoe0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/8/26 17:16, Tal Zussman wrote:
> We already have the folio here, so use folio_page_swap_entry() instead
> of going through page_swap_entry(). This saves a call to
> compound_head().
> 
> No functional change.
> 
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

