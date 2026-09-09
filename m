Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2DC2AC79F8C
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 10:01:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B899F6B00A4; Wed,  9 Sep 2026 06:01:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3ABB6B00A5; Wed,  9 Sep 2026 06:01:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A503E6B00A6; Wed,  9 Sep 2026 06:01:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 82EF86B00A4
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 06:01:36 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CEDE3A38BE
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 10:01:35 +0000 (UTC)
X-FDA: 85193781750.27.21EFCB4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 0DC7240013
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 10:01:33 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CPTlmLpd;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788948094;
	b=gRszyqTk5Yr0GiEH+X4TqN2rOsFrzyNKniWkqDxRHWsB/V76ebLuN1OIa4Kja+cp3b6Lrv
	ZP1GLr0CI6cD4YhG0F80C2YAYJhJcPij1MvfqAi29wRVpqeysm9JuF6kRgs21I6bAYYkYe
	GJaJwArsNR1WmDqfWlPR4t6EGyoJ6Lo=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CPTlmLpd;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788948094;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=50crNXE5RPe0jaXCbPjDytOJ0kKcHrcQdEPYCvw1FdI=;
	b=TMXshe+kfmZJ5SlUEHHhlktjaqlokUxG8EZCetGiDjPrumKGPm/Op65HavWugkBdQ8Y4jq
	qcs2fdVzYbzYfreue6XrUVXAKeQuTmmNOvrCB4Roer27dJR8178nNqHLmWAak9PyTppnE9
	iUfoEJ6jR8FjBJvjZNgArSZfWKTipr0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3A48E6022A;
	Wed,  9 Sep 2026 10:01:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FF501F00A3A;
	Wed,  9 Sep 2026 10:01:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788948092;
	bh=50crNXE5RPe0jaXCbPjDytOJ0kKcHrcQdEPYCvw1FdI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=CPTlmLpdtRe13Z/QNkefitntnzkSGJ0UFa/dUjSKGCx8ubF3aINeJRYUIvneVno7u
	 Nii27xkpOI5cQ3jjji1qFPnENW550TEBdl8WssIPiTFo3X+Ra3xvOSspwGhqd3gMhV
	 xDO2U0kQFtvWxWaxRcWJJ3Tt6gKvtFFTNogaEoOeGsRA6ZPZDl6TP7bcshjLV1ks8C
	 bpFgKFI9LVMaFK/5nUv2V0qyPOUDQs23NImXg50CxqbIf7lnNr1W6/wUSZUEhWJRsb
	 ZpMW5w9cit1n0QySPbq7Lp25lW4VsATDNYQ30FviV2FVuS0K1dKQ+9iQYf5x13Ah2h
	 7mdgruxK3kRhA==
Message-ID: <e57a6b75-24b3-4adc-9257-f578e86b6256@kernel.org>
Date: Wed, 9 Sep 2026 12:01:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 12/17] mm/sparse: inline usemap allocation into
 sparse_init_nid()
To: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>, Oscar Salvador <osalvador@suse.de>
Cc: Mike Rapoport <rppt@kernel.org>, Vlastimil Babka <vbabka@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>,
 David Laight <david.laight.linux@gmail.com>,
 "Liam R . Howlett" <liam@infradead.org>,
 Suren Baghdasaryan <surenb@google.com>, Qi Zheng <qi.zheng@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Muchun Song <muchun.song@linux.dev>
References: <20260825084608.47437-1-songmuchun@bytedance.com>
 <20260825084608.47437-13-songmuchun@bytedance.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260825084608.47437-13-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 0DC7240013
X-Rspam-User: 
X-Stat-Signature: ihiihp6tm4rtnd48n63eowb3tukjqkei
X-HE-Tag: 1788948093-951137
X-HE-Meta: U2FsdGVkX1/bnUKBTp6JdFkqSIlRk/FTFkLhHQArQztwUzzefnCQYzxaXQ9P+BbBUlFg4iWrawS2jhcEggPfFlvxmz2oS8vfq9UUL8GCMrvgMZ/DQLgWo+tXQEg4vvEpiWLVvfc1Eit4hI4AhZdAlazHqqgiWG1cmN2UD9pXDlftEwU0Lx9Q+99DJIJDQ1xy9e3XBuTW6p+K8MAqvlz61o9qEaNY9CisVFGkhMg8Vn7mqBzo1AV3+kuLvgL79v28b3ylL8IxSaNEO5gol7dwpL0/mzGNG8ptX5Qc9wtPVwidmCsWer687YF1mUNlRYhsNY8S9Zrhq4hacH0CBoY7jcLdcA3p9v9AjDG5KBu7hbWwfreF1gcCOJCwtLe6R50n3TUvlWL6iTXa+J6fBc4dtMZ0tuImQk2yvYcnuAe8XzSzhWhYh1XuxBpFwdUZT63JL2B9sWtYWaZPlst8hd8it1ipFJ+RamG6+iI03x6mTHHzCPa9G0ym5DQkXTOA75t/p/ek9yJdWAJE1yzKFIAMbmvBI619CRXw4UuQyqW5dEt3OZG6+vsckFg27Jl5vPiNUaZXHymuogfwCE1bXYdWlm3lqU+4tTPZ39VzO9NeU7JV7peI+4I+dG55dYTmahumGLYEZYqD8oddWbiA30qErNxGOQC8gOK4lKlhn9bk83dQUdXYjuVGbON/jl1ZIkVk3VI7rLeeXEthL6Hzwkf0qYW70cbFql747pw1GBv+ruXoYCqtuCmAOXvjAN4PrwkZg8PrpQ//9TD1pnHS/7eSL2shj3twMTmQRiGoN9MLQZNjD1YEOSH08gz+dIVL5j0a9I8Z21GXX0aD++at918h2zhtbphGOy5B5puCCKUhPAvGkel3CTXUMXvzgquPYemRvDCGgs1X/UymHjHJXiPIsulGv1PmfewCqkmOJCP7XiNm8nqObpBocmvj3BhJ0+CsGlcE/BXbDDKBw0BPeJs
 ePK/CH3o
 j2YE3t/RuWIAaOoBEqj4gq9TMBCyMGpMaYDpF6Doq7JmrN4QbuHlTi+S2mYv7DU1QeDZtFuWb4+kN1NqO+aCSn7QgcQeH4vWpdDGWQEY05of/o38/HvCMLQVqv9x4GGtRLGDoun562Ly1VWdS+Njd9A9PAHX1LLMMJ1Vft6pMsP0w0kuZ85K8vzgkgic9UH0LzTZXawje414Q7icd2Yh8WXDIF3X5x/Nnc3PkPyzL8cvUJmv36nZrfaiDc3qes9l8INibO4yJ0GX1e0e5wnlHpVVQtD9VATVGaz/GLxl6haU5SQNKgVAr2ly2tPEfG5bUZ2aWWhG7KfrWgMlsrj+TLOHw8a7709Gxvyn0wVYUt/h1D8dCuIrLqdJ9H08GST3g/kX1c+TUbudNQQsPNPE0czjsC08qslXr7zQ4v75dYE26yuo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/25/26 10:46, Muchun Song wrote:
> After removing SPARSEMEM_VMEMMAP_PREINIT, sparse_init_nid() no longer
> needs the transient sparse_usagebuf state and its helper wrappers.
> 
> Allocate the usemap buffer directly in sparse_init_nid(), pass it to
> sparse_init_one_section(), and drop sparse_usage_init(),
> sparse_usage_fini(), and sparse_init_early_section().
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
> v2:
> - Collect Acked-by from Mike Rapoport
> ---


Acked-by: David Hildenbrand (Arm) <david@kernel.org>


-- 
Cheers,

David

