Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A3F1CF885A
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 13:55:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D67CF6B0088; Thu, 20 Nov 2025 08:55:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D18A86B0089; Thu, 20 Nov 2025 08:55:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C55AF6B008C; Thu, 20 Nov 2025 08:55:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B5EBC6B0088
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 08:55:29 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 60BD9C011B
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 13:55:29 +0000 (UTC)
X-FDA: 84131132778.08.9A27ADA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id C2C9B16000B
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 13:55:27 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QKsjgNPU;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763646927;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=44TukmqM1pM7wJwbSWZRWo0DXAJICz/EvslVoyveLSQ=;
	b=E31dwW8TTeDrWLlIovk18MmRqJc+89xOK6aruWjMWoD8BnD4HVK89lvrAOuZfJUf1l+7Ww
	sGMbfy0kDqcb4pIghb0N1yizfnjVj2J7k4KogzYjMCJR0GVev2r5DdAqS5p92vWZ/gLQtK
	CdzZ/XrXoRVW1eOB/QVXykldgTo8QQI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763646927; a=rsa-sha256;
	cv=none;
	b=4Ycb9A9uZEKBNeQdX8LFuDpEFtuXP3p0xkg+1ceTSPcLtrp+4OjCvj3BqdeJp/1Vz2WZNH
	54lUXjJuHfhOV9daVxPDwK5GN1V39C9I9HdnKJRBDZGY1yu4gzSycPFUe1J/uRiRsVZXiM
	KW/S8scOeQIOXJsspUKTpwT9RTs/tkI=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QKsjgNPU;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BCED0408C5;
	Thu, 20 Nov 2025 13:55:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23CDEC113D0;
	Thu, 20 Nov 2025 13:55:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763646926;
	bh=w98CTr1y6u3rlNRFz9EHhQELuGV5IPxoox3hjleT2DM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=QKsjgNPU5/PcGb6udYNlfEODXgk8ivv7ikeYCyFGtk3qXg1WX8QH7JrCzMWxApG6D
	 HRXoVEATmOyWOgmvnMU4f7Jt6iiVHv5eHM/f4tu0MRUlVmtw2VH8m1qwghCR0CTqqW
	 W+iDNL3eGu7Y5patl7mIDeOVyZkN3EEMa5yBpbDAbimNotN9a9qNgkN1TxBWNWn2dT
	 QKi+xC8V8RYoPmWfaroSMUaiEmf7Brtfy5KeymvdgbxHSNMcKtNfnTucAcEjD33pc/
	 PQdFCVdp+5DKaGCEnlHxsnb+5FwMYO3IfEPaa6Y0EyLznPWk5AnVdC3KqBaaBa6SgV
	 yr5gf3p/wf5/w==
Message-ID: <2b7ab53c-b1cc-44f0-acdc-e28967f53ea5@kernel.org>
Date: Thu, 20 Nov 2025 14:55:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] mm: Use frozen pages for page tables
To: Chih-En Lin <shiyn.lin@gmail.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Vishal Moola <vishal.moola@gmail.com>, linux-mm@kvack.org
References: <20251113140448.1814860-1-willy@infradead.org>
 <20251113140448.1814860-2-willy@infradead.org>
 <20251119154654.GA606021@gmail.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251119154654.GA606021@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C2C9B16000B
X-Stat-Signature: 5da4tj1gymm7ea5obufkc9636zzcc7ij
X-Rspam-User: 
X-HE-Tag: 1763646927-668388
X-HE-Meta: U2FsdGVkX19gnS0bnlI1tjVayC82rjTvtl0XkPutNgqdLZfCePcLZ8bZYeai/ciXmMP1DcYHsot9RugfzaXGp6WAEpVoAgoqlJR/avdpDEi7xh8lc8vtv6uJmTQzvzjtcxM55BpKYdMTyckmZLi9x+oo0adAczp6v39AYKHupqZbrMVqdlMaIOl/Jn5s4ETI9OLHFyc/gQaQzYQbLrAE3IlI4M/KwP4TgPIYdkjN08HC1LUPY2ql2zo8dSubG+lscfGHMzrRKQtvqcHvaYZqfSroBH8AiJXpqXI1hQtLgDgz6kYeinFeXu35K6atpLNRqKfm+ozRYATT2LQ/loH+E1jpOyv02ixV0OH0t3cyZ49qbTu7c6qjuK3lBJ/WH0wOS8uET2r5SAru3yA/cooq+3Ytfv3TFoOuJogjA7zWtCdPeTFdxhkBw6gevmd4YdT2XnLH98BLRhWLtGvzuCGsg2Ckhr4Jl3oGY8p7iv/mLQ4pSRbQMet7mknysbZLLOTB5ncEYM6UlgIU3/OyeEtOyxrdECPtsu9D5Ka8ngm577vdVh1jiQsCyv8uFmJ2aaEQWsExgr4INV9s4Rn6qw26gjHgQ0QMp1rPpSCa4RRRiYdG/ceK3H+ljhLWO0tCWEkyry7ZaqaD/zJrLtLYgAh0ok3BJzLkuC7NdfKqMCGLLfL29j9HV5MsoCYgCuxl1ien58L3RsHCxVas0s6Mc1M75uCtKoUlLaTwAh6ABlDm+ihTV2VhYiOW4yvDE9MGo7WPG+EkEe8/MDTMaA47RBCSEj+DMkypxXF6/9jr6b50HAUmyrCB4AfhxL5lQZh5pzzNndGyJOIMOue+6CPxSq/AF9UBOkCano29NFLWiYflTsw3eE52sf9Rvw5LwTXJta69W/qe9+RWcLHOFeWJcGAjubcpWzfiOAu5RP4ICjjd1fOMYvu5mjUDrbCalMrEUGvMhlIIg4pvC+PIFnZMEbn
 V5GNpNOo
 hPDcjnxX7+wXYfAsazovUFEfSyg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


>> +{
>> +	struct page *page = ptdesc_page(pt);
>> +
>> +	if (ptdesc_test_kernel(pt))
>> +		pagetable_free_kernel(pt);
> 
> Should we use test_and_clear_bit() here to prevent the double free?
> Or it is unnecessary because the caller will guarantee there is no other
> thread that will free the same pagetables.

If that would be the case, it would be horribly broken already?

-- 
Cheers

David

