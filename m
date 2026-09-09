Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8E53C79FB6
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 13:52:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D08BC6B008A; Wed,  9 Sep 2026 09:52:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC8706B008C; Wed,  9 Sep 2026 09:52:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BDE9A6B0092; Wed,  9 Sep 2026 09:52:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8E0A46B008A
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 09:52:26 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D5FBB80207
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 13:52:25 +0000 (UTC)
X-FDA: 85194363450.25.06555CE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 26E6D18000E
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 13:52:24 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Rc/XpYW6";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788961944;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Kmq63K6J6IaLLBR/41fmMzftkZbpiaUzb2YtjOSoo0U=;
	b=PJ9pPXZsSJMld31mBheRmlx3UqVbJyHqa0oND9n09DM6IV/Ph+gL8DpSKKxzmdrAMJV9em
	pUPbSPw2gIjKfMCiO3Lyug2FrMX3JFvfZGsmqtt7sjly8VXqm86FF50Ms61m4kp4YMKD7g
	Qe3hWZMYjf+CQMj2gIeJMvbNFbrgJIk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788961944;
	b=BrTvnbN4ClT3T+mbaeL0H/mhbAANMzIMPAwc9dncXB16UajLcnb84k5jpZLYSn6FOymUhW
	tFXqrOM6QZ96z+qjUg9b9kLPe+fhnfivD6gs3Lwym2imuLKwNcI3ttfVrBXqR6JNNJqodc
	UNQGVroMx+X1zZ27vyB0MiSeh4E5gAM=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Rc/XpYW6";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A774560211;
	Wed,  9 Sep 2026 13:52:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CC151F00A3D;
	Wed,  9 Sep 2026 13:52:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788961943;
	bh=Kmq63K6J6IaLLBR/41fmMzftkZbpiaUzb2YtjOSoo0U=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Rc/XpYW65T8AigmjkUpYPLbHSZ9iXw+bBBHqj4ua9Q2oTPZXtYWZGsYw4P+UOFXEn
	 5Bttkz7GfSPJr/Vjdm5880Q9nk+FmJIrh5DInsvEW1R5FM8DmJvaGhSsNuPMxE7E1y
	 JgP9Q9tE4VzRuEtYnS3oJRN7Xabxv/7BEH82ph2uywANQiWQQsgn2MNdXG6FLrSAj7
	 4Ljse3qoohE7fRIu1f2osn6NaKOpTmebO5+K5E8/dADRwqdyg/T+JkE7eOpCSuov0s
	 foVOnwwMQCXZ7GMCSmMeW3lfqC47NeyncHaRAI72S/lqru99uE2/3QDEKaDAzWgziO
	 57ZeCyYKJlxBg==
Message-ID: <6067ba05-82e6-434c-b717-93ea2fb7d853@kernel.org>
Date: Wed, 9 Sep 2026 15:52:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/8] mm/huge_memory: add a comment to the open-coded
 swap entry
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
 <20260908-folio_swap_entry-v2-2-ee6d01dfa5e1@columbia.edu>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260908-folio_swap_entry-v2-2-ee6d01dfa5e1@columbia.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 26E6D18000E
X-Stat-Signature: gki9choso8uryqfw6x8p4ayfs6cruxb5
X-HE-Tag: 1788961944-793582
X-HE-Meta: U2FsdGVkX1+MkwbK82QX2L8rRzFimWlwhMIvvilp3ETHAOmEzid/MV41tcY6KUxqEaYiVzL7A+PI0Fdggps9HQanCLjfhWSGEH9V3mJwTIEhwCkO6zTj1D3vPY2j27UDGm9wYOSSp9rwdooVv9pndOaO56tNvzvYPRJTL2BrxmscEbWOCe09S5ts1KimK8JtoQS6ukFtDIv/qjMrNa7mMWLzYjUGH+qtHaenxWe8Yq1+6qxjGY3MN5AbHPMLQR6pYo/F5eGNrLUsO8i/H8tgsioeAyT0ORRm1HL2IWXdvp7GpgQBiAuIQUnfWlJX8xeiLw62JGZL5nt7rBsF4Cg5YjfhkuMfO7/vwtpfU1qlQR9A0GReHTIGwkrzFmSWIJr5I/ZA/F5URnqItQvDqdbzTbLaKtPi5iGnlLCRjqi7f6Y4a053U27vCHOswfGuYGvx9L3wIrsxAc4bLh2cLY8BQA2//p/RNE4VlweD7arXaDRisypW/a+M2ZRGtiS+QrlM5bFEGAgYse+ytbpAkPmGhvyzlBWIZdu7CGlLkqF1gRKQFG8yg2AzmX1zxQNAGDl4AEghyFUJ1rUERWRu5H1d7K+W/t+zWjfXhFpTqCpjxXBGVeNdLDVGGRwVc2ucuj8Be+I2W2DTBT9dN3s7rq7BjVIUkRHWj5yb3Nb1iCV0xAXWcdWeaIrvwkmixXeS64f2b+mEKwgOOhn+XdkiS3s9ikGXEggvx8kU6kxRcgYwXjWmiYKco5UwnVhbGhaG/RvhA7ZSS7JVaq+H7N+CTj3T16abpzTZhhT7CFgRaG+xHsIQy5MMVWa1e7APsXx/8nAffMZPkgXVctTMROXQz1thhyUYWIfpJ7coon7uUQ3eY9wU3CeskxESdXozy44jjlTlF0RFs/8CatHL9NsRF9VpCEO6lVDNyTgFxnMZUHTOMNIZmEQWh0A0GNeg1k5X6PRCp+4YKuQxlTNyRGieWAx
 d2uCRo4+
 fQqRQCsl16GctDNxEKuBDovjd5QAp/5Y8p4C7bhK6BqGCGeXGaJQ1OgJu9DJSQ7Dj91PCDkmzRDxhsgMkA1zkwthe4d4GaW4kh9fj51LNiNI1pqteUYJQ0cu6GTWy1/CBhnmSGSd3ozfUsvLa404TUpSA+ykDOVsBopcbnlDQN312TO9gwDyAg0leSfmJymeZq0Kmexo4xC096OW/aWsll3Trv8gHm0Eg8E3CaxC4zDe2HXtuqi3SQcuS+Wyfh2Rkh0mjqBGq8AMzy9B3zYXKuoro1Z6Tn9GHiTYEb1Ind7UBBu6j8/9tzU29jbp0aVIQqxcTz7IVvIAOWzE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/8/26 17:16, Tal Zussman wrote:
> The swap entry of each new folio in __split_folio_to_order() is
> computed by hand from folio->swap rather than with folio_swap_entry(),
> because the folio's page count is not valid while it is being split.
> Add a comment explaining this.
> 
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>
> ---
>  mm/huge_memory.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index d1ce061601bc..1fabdcbd8c8f 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -3763,6 +3763,10 @@ static void __split_folio_to_order(struct folio *folio, int old_order,
>  		 */
>  		VM_WARN_ON_ONCE_PAGE(new_folio->private, new_head);
>  
> +		/*
> +		 * Not all folio fields are valid during a split, so open-code
> +		 * the swap entry rather than using folio_swap_entry().
> +		 */
>  		if (folio_test_swapcache(folio))
>  			new_folio->swap.val = folio->swap.val + i;
>  
> 

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

