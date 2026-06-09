Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6CD24CD8CA4
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 14:30:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D2EC86B00A1; Tue,  9 Jun 2026 10:30:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D05E96B00A2; Tue,  9 Jun 2026 10:30:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C43496B00A3; Tue,  9 Jun 2026 10:30:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B154F6B00A1
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 10:30:14 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5323FC22C9
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 14:30:14 +0000 (UTC)
X-FDA: 84860609148.25.BC4C728
Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	by imf28.hostedemail.com (Postfix) with ESMTP id 305B8C000E
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 14:30:11 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bXhDmjm2;
	spf=pass (imf28.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781015412;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oeJMf4Sx5hfNHjWcNBhKdlPZpkDAYwCakJYZoE71Ups=;
	b=olSTGoVMM1dCF/mIEY+oVC4r1PdR1NgWTdqIAhmKiw3fyB15eKaj+/JDq6uhoLZNFK5TIM
	qwx45wDX4Iz7/2DzHX1vYeTPq6Zpvsix9yNl1UB3EiezrZIqVUH4SRVQPPsCYDynDFT1je
	6+Di6UOxxtYwL0xQDXLMOJuZTq5OVdU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bXhDmjm2;
	spf=pass (imf28.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781015412;
	b=drNpWc9rGg5VKmBDDtwHXIJlGt6CGcUVxBwze0T7FH634cZJA3QQAFWaAxSLA/8vtMyEWH
	o1/itf6aaIKW37ZmpNMnP2UG1oTH3LjgXzxuS3VPzIwUzoP7iVcHdxMVG3pVwrdQeoS00L
	UpzKvYm1hv8CdtSn10nsBO8pK19kyD4=
Message-ID: <aa712058-7b4f-4421-b265-c3173fcad87c@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781015405;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oeJMf4Sx5hfNHjWcNBhKdlPZpkDAYwCakJYZoE71Ups=;
	b=bXhDmjm2by6y5gPy+gfs/EVmDZSSrTXcX9sRmadiQgq6sAF1lvxLPwdxtIv9xtT5cYyqJK
	2EKDuuJchWcOIdc35nvrqAcI0GhRAAQ7YqTtI1GxXS8d+87CENHLOP7DldaAH0JHne+9U/
	IKhrApzCwB6tuY4zd21EUSEmhNk/q48=
Date: Tue, 9 Jun 2026 15:29:46 +0100
MIME-Version: 1.0
Subject: Re: [v2 00/16] mm: PMD-level swap entries for anonymous THPs
To: Andrew Morton <akpm@linux-foundation.org>, david@kernel.org,
 chrisl@kernel.org, kasong@tencent.com, ljs@kernel.org, ziy@nvidia.com,
 Linux Memory Management List <linux-mm@kvack.org>
Cc: ying.huang@linux.alibaba.com, Baoquan He <baoquan.he@linux.dev>,
 willy@infradead.org, youngjun.park@lge.com, hannes@cmpxchg.org,
 riel@surriel.com, shakeel.butt@linux.dev, alex@ghiti.fr, kas@kernel.org,
 baohua@kernel.org, dev.jain@arm.com, baolin.wang@linux.alibaba.com,
 npache@redhat.com, "Liam R. Howlett" <liam@infradead.org>,
 ryan.roberts@arm.com, Vlastimil Babka <vbabka@kernel.org>,
 lance.yang@linux.dev, linux-kernel@vger.kernel.org, nphamcs@gmail.com,
 shikemeng@huaweicloud.com, kernel-team@meta.com
References: <20260602142537.198755-1-usama.arif@linux.dev>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <20260602142537.198755-1-usama.arif@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 305B8C000E
X-Stat-Signature: ntss7sz5qe3yf811d6kk1frjyuqjzgqu
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1781015411-10116
X-HE-Meta: U2FsdGVkX18HTN+XTe6S3BgpbJpaOOPDsNPa0LeFRlzhAendcCEtsfaorPvIoz7BQNvLWvxRFDrxyyrw0nqMUrF9cOVSw3DgKSJ4D+JQJp0JenSYCnj7DyC+C0N9aT7lFmxoKLpGF29Xqu+Z/m1ZudfR5rsRVgQigcKskeAHpabmbtDIT28DsES+RatNNXqo51gTb7Atxs19HSVg6DDk/q0IO8Fq4mouCb5Qyw8RIZUP3uS+gH5uj+enJOCbPe3TxuBhxjRImclvMRSdvaWr+fyNmT8Y24crKRzmoPgIFXDOIRmXz0Ngfl2bRecYnhRJsuxa9ixUDZSoYIY7/KABThHN+giBGKlaKP5hAh0Fndc/dsK47lZO0k/k5qweccWE8rje80+TdBV9CoMLQn01RIWBTZDgCnTQQCQOTTEM2sL1vJgJ+VAAQ+++40DFIkeFnMkA647lexziU/kACDyp6/4kNEjbDRj1AIMa1trNqV+nXkoElAdWuiGnMPaDiGL4FjSTYJZvkq6Gr2RYlYKczBZBcpbwg+ViVFNdWCTnagDn0xHQGmROip64AmkxctZ+7cVtBQRPgp2Th3owwQPh3yLMGsYTCb9suhaLYPFV+iPbt9a7Yw6jhGF8FE4d5/bksWAE/at1/piIw14Cvs/4ornfcf0F3g/znmFulPUD9z1qVYSOf7HfS/MYFTcrwwokBUOkSs84+ssG/f05y+9Pznws8CmKaPSmJCRkti6nfveotp0hWDGymrjM9tZ50Fuy2Lw9Tie7co2WnBWWL1TXik80s3Ba76q6RUxIZbSuJ82j2HozxwOZXJaHvgD4EMf6VKKJ/UhW+5RXc6eqzK7/zNjcUy5hd657O0r2oUi0mbvS5zK5S779n85S/3AJ5AsVadu3y1LspI1iQjAEQOgyjVY/nbONMi3wRebPnq/4sn+bcUV8/8z3iGbL4tIFgzzndMWDGggD2QFxiin60/y
 HojUmmjJ
 9sfPJ4S+4NjE4JFKNmACJn2aUYD9OrGm6WmC4Nu26DCi83pJgWqo7UPQ+PI+KKVZNadcLjuv24OSNqfKzsB1Lrsoh9km+Njf+W+OoNYB5lID9CxaMe14Hs7FZqMlbyF/BzcoQN6vGHWFdduB5mE2HxIjlBxsjyJr5bMQZCxrHaA6THgxxtgBiXkPHoDQ9rg43rPY/Q9tLwjmKRLfA3oN36aL3LMptp38NLzOhrh6j8RpB5mE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 02/06/2026 15:24, Usama Arif wrote:
> When reclaim swaps out a PMD-mapped anonymous THP today, the PMD is
> split into 512 PTE-level swap entries via TTU_SPLIT_HUGE_PMD before
> unmap.
> 
> This series introduces a PMD-level swap entry. The huge mapping is
> preserved across the swap round-trip, and do_huge_pmd_swap_page()
> resolves the entire 2 MB region in a single fault on swap-in,
> no khugepaged involvement is needed. swap_map metadata is identical
> either way (512 single-slot counts), so the PTE split buys nothing
> on the swap side, it is purely a page-table representation change.
> 

Hello!

Just following up if there were any reviews/comments on this series!

I know its a large series but was just checking if there was any
feedback?

Thanks!
Usama

