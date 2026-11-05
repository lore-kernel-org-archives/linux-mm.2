Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1EAB86082BE2
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 19:40:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=b9W4YOqv
Received: by kanga.kvack.org (Postfix)
	id CCEBE6B05C4; Thu,  5 Nov 2026 14:40:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA5E26B05D1; Thu,  5 Nov 2026 14:40:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBCD76B05D2; Thu,  5 Nov 2026 14:40:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 78A3E6B05C4
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 14:40:31 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 60EC5160BEE
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 19:40:30 +0000 (UTC)
X-FDA: 85402082220.05.CA1D566
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 8C9D612000E
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 19:40:28 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=b9W4YOqv;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793907628;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Et2NLdyCzf6OtCLzVUxxiZkBqaGGRp7IPuLogLxECcg=;
	b=Mx8Stj103C9NEQhUiEG29Ff/ndtlDORHUUKohZ1hJn0Lgnn/D1yxoTE11aiiyqPLD3zRiq
	VJ4EhpocZNxPSExyGNbk9EDOJ1GSQhKmRj4HffN9jw0GmbGS3szH00WOPhMZatn4ij7jsm
	InBzeOWCpjwClq/jS6cfe8dzdImpSA0=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=b9W4YOqv;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793907628;
	b=NmlrLPEKmlNGLVZbYt3vudTO6sgx4MVb7O2LvMqqp2084VVPKt/mvzl4wGwpuFvZAtnzib
	+VUhgEIAVeAyUvkI1msDRws5U+xgS9Ha3mQlE6gBlFSHxAlerT0VVrGZem0D+45Y1Do8N3
	1t04HpP4CowH2tVq9ZWCBvw6Rh3o/mI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8EE66406A0;
	Thu,  5 Nov 2026 19:40:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68CF71F0089F;
	Thu,  5 Nov 2026 19:40:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793907627;
	bh=Et2NLdyCzf6OtCLzVUxxiZkBqaGGRp7IPuLogLxECcg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=b9W4YOqv2o6Le0fb5/CcYr5PJ2TalvpmeU+275RQIBL/dydEpH93uDOuobnEcjMCd
	 rSIyvJ+e7NBLLnB0hfY3eGORd7xG5mkd5LYg11jzy42zmOtAZeVjp5HkBaKmTPOqXc
	 dbDf0oeQQLLkISqI2x6jLPD7xmqnvr0c/AtEPAStMyM426jisIh0UYEG1e88lF8rzZ
	 zR90U5vXUH0QVziDcdIzulj5ROvl24m2mEn+HKpkHiixgo4YdipvO1q9anroMWB8ac
	 udIZHeNvBmJcKNOPZAVq9h+ktCjtyfUSxBzUwHCDgqbs1gmleaoxJpOJXAXyc8hgNE
	 ckjeMmf/DevYg==
Message-ID: <ea17ea77-7238-4a78-88f4-7c9ec0528c4e@kernel.org>
Date: Thu, 5 Nov 2026 20:40:21 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] fs/proc/task_mmu: check THP exclusivity for each subpage
To: Kelvin Zhang <zhangxp1998@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 "Liam R . Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, Kalesh Singh <kaleshsingh@google.com>,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 stable@vger.kernel.org
References: <4c1b393a4b04bd94e4f1c7879ae04e1793eb0931.1793552446.git.zhangxp1998@gmail.com>
 <54617273-262f-4e17-b912-8b07113ca45c@kernel.org>
 <da1dc033-9131-4b77-9443-a8cc82fd7e58@kernel.org>
 <179355762314.2759535.4568050479263510899.pagemap-thp-repro@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <179355762314.2759535.4568050479263510899.pagemap-thp-repro@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 6hhcj1wjo6mj5g5yk9oi51bahtpxpbs3
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 8C9D612000E
X-HE-Tag: 1793907628-391364
X-HE-Meta: U2FsdGVkX1/46qjTEm5qoXFs9o4Jl64neq9JZu0Si2hZ/Iy+1RwurC/XAqyt+U+DtKByc743eH8EuQ/vj5G7ShFHNIVxzX+U1NmK7ebngE/nCT5DGqmdWjrWKB9owJHr/CV9cdIh2e0tivruELIe0NJ+b6LoZhSvxs47PCBbU2Qt6KlhrX7dh+vuX+OIFJwHv12LnUiAinQ5X1jSYO6RbnTyWjSVYQn5pIZT9ShC374Y60i/+BUh6zx47Ncot2Fbbvc609JvGadKlCpHjFnZiAIR/2kXC31gOqfCdllyCMlFOGhgVyOKa7PAUJZG+7BVwMlgROkeOv3YKqNOnO2AorH4ghLf3PPkb0xG7O+6+A3p0VnkDa4pW/8VIlx/VvZebVytfilEFUIj9OtgzYvpSAycwsng0/3QHX1v1mcbxWreUbFMwteCMmdJSkjqm0BcgLfRJhO72+fNyAdT+DDrPNAv6eBQTetmAT6vtWndmr914RXLInk/QnWRSsm1xZFv/IyKTsHitCaCReCijiNIcgI5J+9kKr0dC/mHy1WLlFDLS2iYC8kst5x/7XxfEWPFp91wuz3x5TgrzfaEI0ZjcgM2HnKdi9hLQdHG2qpFvrLNyHgrUSI7d5raIkmmhStramQFZVZeFuvDXPSKUXZDosAPhInkBUpvWyRpwYKqwkXz3nREOkHCLSL7jBbaqDXWNBJwFMitkq/1Ae8mbuptrpocGL4GpiOKyLGQY6KSkl3Fnwi6iHwJSAwjwqZT9Od90OA0QYbyiAAJVGXGcahWOSJd75lFhfy+GNzSJR8p4mlwVGWk4nYXdxhC353Mpe89hq8tBwuME76kQJ8DoNazs3rHLTgW9JJopMwbKeNh7S2RijmbwWLCwSn0/It4LKf4wHDeCtd0hiiNiSz8mDi1ET3ELIE+YeZRhOm5acW14gvFVy2IWI+kxjmwufkJhFTU6P5/z9jQQpCbuj0QlOS
 DeCfTs+h
 YiPtLtCdYDhgbEZBGaq4agDNrlfs7DY5a+lVeDrVd+xlfDPYxDpNS7OKJYAd3HEKWMaUpysX22vUXBxcb9gIbqsAdvaADTLTqS1tE2Lg+inx+CUtbICeNtFJGRkQ3UFnbqCaHQAMZM9F4C3lv4xkAI+c0XIE40VPSUpCl0gM/gcUto5Pya9MUDPuHcVNASFy9qrWA+pwV5Oj6HLftaOvhqV66FCRBvw+QUnuZ/vxRn/47i6gxhbJAlJXm/XHsHtPY/cNk52S4jBSTMBPbfBFBFvgU6Icpma05CPjz9gOHJMikOIwgw+4dndipQg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/1/26 19:27, Kelvin Zhang wrote:
> Hi David,
> 
> Thanks for the clarification.
> 
> I don't have a real application depending on precise per-subpage bit 56
> values, or a production failure to report. This is a review/test-driven
> report, with LLM assistance, rather than something found through a failing
> workload. I followed it up with an actual old/new kernel comparison.

Okay, thanks. I think it's best to just change the behavior to the new world
directly.

I'll respin my patch separately shortly, documenting your finding.

-- 
Cheers,

David

