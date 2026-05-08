Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E58BCD3445
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 17:41:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7041A6B024B; Fri,  8 May 2026 13:40:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6DBB86B024D; Fri,  8 May 2026 13:40:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 618286B024E; Fri,  8 May 2026 13:40:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4D2666B024B
	for <linux-mm@kvack.org>; Fri,  8 May 2026 13:40:59 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DFC7A1A01CC
	for <linux-mm@kvack.org>; Fri,  8 May 2026 17:40:58 +0000 (UTC)
X-FDA: 84744968196.10.8D7E10B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 3E73218000B
	for <linux-mm@kvack.org>; Fri,  8 May 2026 17:40:57 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iomCB9gP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778262057; a=rsa-sha256;
	cv=none;
	b=JuF0psG+UTMqDvsgIFscTCtDOS9od+mFGYHcSIrqnBYNW51zXhNTruPzoPnWoWPF8MHYAR
	kcHLQKT6hjWjAqAtlZ9CEzcbNWRyJTZR5Tn3/eO37ui3LDVBa21Oy57m2wAGkE2syCALBL
	/u5mv+7JtoSIi4simQc2VbUNbNy7P5U=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iomCB9gP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778262057;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bKiiqpIDIhRR0CLXVUR+2StNIZDUMZtcvi+K4OSbPvo=;
	b=5jj/tCN3v49t72LVGuELS1oTbX2tFcWSW0xY1T9b72M0c4XsEYk+oYWmI8K6F6rigUDqLL
	M+Wuy3q+1JDt3mi3ccrOWK7X2ik4EIV51L8TQDR1kiO5i4lWAaPc7ykjL1kGkILII9nw3k
	kWx2mJGrRWT2IKhoHlcZ5i6WobQEHWE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9D02160052;
	Fri,  8 May 2026 17:40:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B71AC2BCB0;
	Fri,  8 May 2026 17:40:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778262056;
	bh=/XMdVotwUAZISngQqqj5MIoZIgwfggXWKoKAcLMe8cA=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=iomCB9gPhjoBNsOLJ9ZqZ5N6KsyO+HSTdGjXRMgLrWeAuCQzg9NCYnZV5D0xKKh4Q
	 5w8scCy1kL789eFfK4CGcw/9Seh82TvZYFGiCTjOi8qo+eSOYvBPtn4U8YHyJIJz1L
	 0lqs8p8zq4lEtW5Lb6i5hXARsdaZbnyRiclNG8eOhhnJIpn85yMlgo61cCePGmSbeW
	 1JfBlVky+tnpKg6rPd7vMlc+atBvICMGykTbucdnQSqJTIu3OdD/vE202dh6yQLFjW
	 3MzBN9/BhMW5MLCBWnU0najLhjYuyU+Qs7SwJQA8GRsKIerHRjliDnu8eWGrSBX3Xf
	 uud1TPcQLx9fQ==
Message-ID: <4f61457e-deff-430f-8a1e-d3c33c925db3@kernel.org>
Date: Fri, 8 May 2026 19:40:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm/page_alloc: add tracepoints for zone->lock
 acquisitions
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, hawk@kernel.org,
 Dmitry Ilvokhin <d@ilvokhin.com>, Matthew Wilcox <willy@infradead.org>
Cc: linux-mm@kvack.org, Steven Rostedt <rostedt@goodmis.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Zi Yan <ziy@nvidia.com>, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Shuah Khan <shuah@kernel.org>,
 linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 kernel-team@cloudflare.com
References: <20260508162207.3315781-1-hawk@kernel.org>
 <20260508102948.b1c687e623fabec65580f258@linux-foundation.org>
 <832e4333-4079-4865-8ad8-3dd8868fb964@kernel.org>
Content-Language: en-US
In-Reply-To: <832e4333-4079-4865-8ad8-3dd8868fb964@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: hffuaz1wibo8yoooi4i654w19giozx9g
X-Rspam-User: 
X-Rspamd-Queue-Id: 3E73218000B
X-Rspamd-Server: rspam07
X-HE-Tag: 1778262057-599780
X-HE-Meta: U2FsdGVkX1/RwoXgdEaEau9Zs13vOjmYTreZUpM/1f5PlHapD6NfWmIhFUMib/7aikIY4xfZDfQxAniJFmYeG0r61NqHEMoHc6Tu++bhdJ72q/8x+HA3NUe+IQj9Ml1vmFmTCpetQPrWY5l6wkBMdoJ7L/2zv5Fox3fZ4A9RAXZTEJxSw5jYaEb+uCmOceyd2+sztIPn9hUGZNsCU1hnhpnOhzUld+jiwY/l2HxnZVy6uu+SsUMMFu7yVvJVOZsmxoZrxG3AHBSc7BpwEVjWuroMKhFM9qZ+HGPgHKEJqqqgu7JkVfGvRHvM6MtEBQyYuRKNH6dpacG3BC7CIo99iDEyQiu3It4EdulWzvLjqzO/WO6Kn5JBJZXRBxv/5k6wvVDh20LtyUmVJBtf/xUBDDThZn7PZa2GxkuvikpCFAIZZDQfW3c1ACZ58W/Rh+yBAeKgxee5iYu7EXf2OoqcI619GjMic1QY5REw4HBNvtmXuyaeIMbziPGsmF/Zq+mcWMw0lWlmWELt8R11eJh+9ar/nguSPkTCf3faI/H/Og3BhOsNDL1gYtulMw1mggNwBNV8WkhTNxA0h1YFXqs9XmH4q+lbs1wedTU4mr+kB3RzkJDLw3dUf4s5cbXYYdhTycvUm9F3UKc7eabxEpYrCRUp0OtWbThCiCjGY/oagmhBBtuNj1gPMfTSHFH8jMiIkeG2V9FBn9p3BqDWGTAj4p5B0si0xDrSUyweMCyDnilyz/CP75f3RQDBPB0UUxJ7raCgfOFpa1vagXegGAbBDAL+5mlmwBPgi7EFFqPZaZpkRw6rQXhw0v39WMTnImM3X52fYDtsvKs7JtjlODAhVOObK0O7UVz4pVJ7cCxZ+zO4h+OZ5Np3fcn+2WK4aCG8cqetXktiGbPaVyUWbLTHbUqWwulIRtt1H5QNA9fky6SDrb2i7cZO4mKt4wl8LJEr/oRNxt02PD/nspKzn1w
 5TOF5nKA
 rmgjISg2WdWQIOEKgLl1JktDSpK7VUy33gI30MVkNmPtwNYGBgKE2AtlVxU62avvwT3Dz3nxMXQ0VcGG/AMvBi3T4GpgrqMdzbHJk3rIptpq/dLWcHdr02V13uqin0JP9Pryd0CqUlhI/rAjZQNzkDb7BHZUjmzxfIFRN54xCoyA3GefWYUyWfBMQR/dmcciF7GyLCsLLQfrYrAS9eslErZ6k0natHp0hxO+g9vtR15LcM17fg4u16lRmKgRRUkgRk1bvOIREcfiXeQR+uWFXUsxSdRdBLSEsm2/sfH8qXQPIEi+kL7aDD1xwH5a7GkGG7nHVoe5zqjS/Eqpvf3q3CXbULGdfw7g8WoJ6eSWWF3DnAWnk2vOIFYHR45qpId0s5Khz7XO5cDXtiMnVwLrOfW0vSceSdDpaBcbFhco2ZDczLaWLhzlucCydNA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/8/26 7:38 PM, Vlastimil Babka (SUSE) wrote:
> On 5/8/26 7:29 PM, Andrew Morton wrote:
>> e .configOn Fri,  8 May 2026 18:22:06 +0200 hawk@kernel.org wrote:
>>
>>> Add tracepoints to the page allocator fast paths that acquire
>>> zone->lock, allowing diagnosis of lock contention in production.
>>
>> Thanks, I'm surprised we haven't done this yet.
> 
> There was a recent attempt [1]. Not being a generic solution wasn't welcome.
> 
> [1] https://lore.kernel.org/all/cover.1772206930.git.d@ilvokhin.com/

And this is the generic solution I think?

https://lore.kernel.org/all/cover.1777999826.git.d@ilvokhin.com/

>> Unfortunately "mm: use spinlock guards for zone lock" messed this up
>> (https://lore.kernel.org/all/cover.1777462630.git.d@ilvokhin.com/).
>>
>> So please let's give it a few days for reviewers to comment then redo
>> against mm.git's mm-unstable branch?
> 


