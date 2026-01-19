Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8DC96D29C2E
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 14:27:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F13F36B01F7; Mon, 19 Jan 2026 09:27:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EFF5B6B01F9; Mon, 19 Jan 2026 09:27:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E02276B01FA; Mon, 19 Jan 2026 09:27:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D045F6B01F7
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 09:27:07 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9508B137D3B
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 14:27:07 +0000 (UTC)
X-FDA: 84348940494.30.85EBFA2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id BB525C0003
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 14:27:05 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=N7OWZZ4Z;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768832825; a=rsa-sha256;
	cv=none;
	b=8ZkIcUck2vDy1GBk8NU4Ak4jgilBFWwzp/ZDsfo7mmfJ2j/sURAedXlCR+T1vZNNrtjEhJ
	0ZiJswBDuOMiQWEzGD53fbYkh2fCwfLQ4YB2xIbHkZwhbCRsWEnYdauY17Te/OPMmOmWLS
	4fRCNoCXsLwkrk4fSXp2mzZSqbs4cIE=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=N7OWZZ4Z;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768832825;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d0DNK0ixQyOWMu0O+f8N799ShypXbokEUZxJDsJANws=;
	b=LQQvq/lv2W2UPdE+MJPV8cL09T/gdaHE6l3lDlBRzQh+9cYUFq1Gc8QCMulh4b/zz4VcJq
	gU8CfzDai0Bvj0tSYeroWw88JwaE1jNdAng0L/p3RSrMlzsE7Tvseb4nff4O1rMufCOUzF
	uMxmTYNaTcJI2QXb8YzyNqmNdOEDKXA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D783243D8B;
	Mon, 19 Jan 2026 14:27:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19B8FC19423;
	Mon, 19 Jan 2026 14:26:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768832824;
	bh=3DK5QC6r/ORsUFeMRQ3y1WSNFwVhnIsC3TsiYDomweg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=N7OWZZ4ZT9xDMT32+wWxnFfbssR+lej35fUiE6pjuFwaEAf6Frz6ZF5Tzg81oRb9s
	 YtY//5xSdkddrcZCOLXQKQ5yytZ9LoNKA+t2M76LkJvTFjG8ivJ4CXP8Vrjin7WgFq
	 mm6eDv+4p8oxSEHap7HDOXiyZsiGk4yuaqNLYLmQTaA9ySxBQmwp0+eVyLzuVh4Pnd
	 qcUiDFp38doWF4E9BOQB78Ro3PiuN115iOsR9yweUGyuvIEF7B9j8wc57gyhX31pTj
	 /IGxKllmArfbkNOynUoUb/ClCXaZkrjA3P4gWd6bjxhTph+5kOoFS1kZPHZ7bIKX+L
	 Z2liNTFBeNqBQ==
Message-ID: <bca59694-6b09-4839-8577-c8ac4420eb56@kernel.org>
Date: Mon, 19 Jan 2026 15:26:57 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] iommu: debug-pagealloc: Remove pfn_valid() usage
To: Mostafa Saleh <smostafa@google.com>, linux-mm@kvack.org,
 iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org
Cc: corbet@lwn.net, joro@8bytes.org, will@kernel.org, robin.murphy@arm.com,
 akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com,
 mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, rppt@kernel.org,
 xiaqinxin@huawei.com, baolu.lu@linux.intel.com, rdunlap@infradead.org
References: <20260119142246.3821052-1-smostafa@google.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <20260119142246.3821052-1-smostafa@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: fe4se4nwq8btqaoa4fwhbk3radfio7nf
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: BB525C0003
X-HE-Tag: 1768832825-355113
X-HE-Meta: U2FsdGVkX19n3/w3wuo3I+qB9HmDtadVjxij/BwwFgsHH8nqkEcbcxWFkepBqYDtmNPEPXK0y9XLtfcfjG0wHPkyv7gSALuwZZ/fV1BMQffsnSbO0tEx2GhHAeLdaIUSI1A5MeYfdiP0k09tbuZO7HBUJf/grcIBEOT4aolpBEt4c4Tsq8go433Lk3uw/LSr/9aOCMxngquU/8kn8RLKy8a4w98gBN1xSaaP5Rj4wfpS0wvobJsioJaYpOSLeeYV32YrwHHJ4fqMSOJCGfWMkm93/H9RS11xRW9QRWePj77Df+CbuGuO+NktiWZOVTmK0Ip4NjjyG2DMZLe4FhI5KhtQwdZ15+b+UefyrpraXXNTj7R6+jPzqR890KXePdOapgrdJJUqHOR6LPDJDzbjFIV4qviXquHAFHZJi9KFFqfMbxg8U0Zi0votKh0J3XJfBL3eAMFXVfBuacczyh2iNoZMIm1vo2ZU3PE+wGRyIbuMqfDn4wUDUpCkO9DCUQwPDHdiqBMqKL+fBIquOmxPct+xUSXijdw+9wNtXcBYb1ucJnLUrS/+4gVDaOxEFDVye+2W4ituD85yXBHASpYeANZraoolDh1LH1G4akP++jL2L6SkNZfZC7N+elG926QySrSsPqJKkGBDQT56ABVMPzbE8T86s+PAtYFN671leC1uy3Osb47Fr+x7khZzfDUg9iLpOEC5LtrEHUOmvw0WgUuDKbLGZqeazCdTrL/jz7rRYR2z5lFnIGu8vjMEksVMN5FLwnuzsiD0DgZ+fmggmbs9g3V4OoDJkwe8tZMD8wFIEREMPFl4d4kUd/eKlRYeiSi/JEiBg8ht/bzrkuvacOvBhVkPFrMsQ7AWeyc33cAdmrGopRcZA/UK6Q6S7g2BJGclU4fWWvfILv5ec7Oy65nRm/IQxRFLBfuMut/LzHbaXnZvoxc3ZGwoFZe78d68uVSS5PmSmoZ6VAQ8g0E
 aUfDPTYg
 grJpX+8sFIcHEsGB/slIWG4J6pLxTM4BAf1k0s/gKXWTp78qd33iL9xfvUVsAXwfGLT7dsaciWNsqj0emnkYvis0ig8FXBN4XpH3imhrBpQuAq7hu9WIJsizFwNRwMTb1GRMVGV43lvD3UyXlv20dAcQEdJ5y41PFCp0s4NjrWbMVym6vo+WivFJKnoLjRvC4qxF3tBJqxW3bYhFiwo8/I+44GDvfUOzr661HsEFhENiLYm+YZ9Cpl6q1suWgbkfRtW6yEnRX/b8yEh23AxO23c/eOH/pOQaLTLlWHB/STlcXQvZbvCTKR6/Oy8n709vfuaN63gsne8UNpSHdml5rBKgctGnCrCvCUEnfP1gmdSBXhDxxOsZ4VCHzrDJRAN5gZKEB8RwS5BuG5BdmsZsrZErw5A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/19/26 15:22, Mostafa Saleh wrote:
> This is a small fix for the new config IOMMU_DEBUG_PAGEALLOC based
> on the discussion:
> https://lore.kernel.org/linux-iommu/CAFgf54pBAUm3ao-UJksiuGKtvv4wzRyFq_uKwLe0H1ettO4DLQ@mail.gmail.com/
> 
> Where it was concluded that pfn_valid() is not enough to validate
> physical addresses before access to page_ext.
> 
> The first patch introduces a new function in page_ext that takes a
> physical address as an argument, and the second patch uses it instead
> of calling pfn_valid() and phys_to_page()
> 
> Benchmarks with the new implementation can be found in:
> https://lore.kernel.org/linux-iommu/20260114164322.787125-1-smostafa@google.com/
> 
> This series applies to iommu/core tree.

This is part of v7 [1], right? Can't we just apply v7 instead or are the 
commit IDs already stable?

[1] https://lkml.kernel.org/r/20260114164322.787125-1-smostafa@google.com

-- 
Cheers

David

