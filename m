Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9D09CA5FE0
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 19:18:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C55EB6B0088; Fri,  2 Oct 2026 15:18:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C06ED6B0096; Fri,  2 Oct 2026 15:18:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF6416B0098; Fri,  2 Oct 2026 15:18:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7A2596B0088
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 15:18:33 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0670E1A080C
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 19:18:33 +0000 (UTC)
X-FDA: 85278647706.20.E218DE0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 533DF40009
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 19:18:31 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mxVepR2y;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790968711;
	b=SwG16By8KEPRgcwoDAj0QfdrjXcDIlemJPyDdo7SyHAj4eLGRmlJoM/gkF7hIVgoG3O24O
	jTQ6pva9Sd+2HyaUQSqpT0zOJtSD8JKo9HUbF5Wl0g+6tVBo9KDAohlbNAhJbrjMMRS2LS
	4ts41mGbIfLxwz4sswGlra9mfdC4AZg=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mxVepR2y;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790968711;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RzOk2QL0OgCI5tvLznmoGIaNPt/Rd6PFhWvBqhDM8Lc=;
	b=Z3riNnhGF7WVO9HMnSzb7dsfpPou33eWTU1lM7zjedJ1RRRHPwh2AwrPs3IhH8KehWB2sr
	dYz9Ul8Fi4i4jt/fizsjxtP8F0Sclrm860PYMc0iuXIT0idgXwWt3LyAcTBaQM9IQivS1u
	Njf50qMi3mcmU+Cu8FkpUFcAhRFdiMA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B7A7860AAF;
	Fri,  2 Oct 2026 19:18:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AC4D1F000FF;
	Fri,  2 Oct 2026 19:18:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790968710;
	bh=RzOk2QL0OgCI5tvLznmoGIaNPt/Rd6PFhWvBqhDM8Lc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=mxVepR2yA1QxnED8FzCtEOz582QxN9uuTNnGFji2vdtWNCN7lQHhZD7zwftelF/08
	 VFxj6aZX2kSwfVfwajp6icBBr+xwfU7lImqptC4kx87fkfZBqXhQVvJC8YSC8wVBqk
	 nm5CZ5aasm5cQxPz0A3RpQF2dvI0wv0L73Sh3hMSZM+X4uBIC4RE8FdyWc0RDjt5j/
	 iA3pVQldWMef/KZvCo9AummHAQzASV0pra5O4yvV5DJhiY0HXW7QTZbW0jHoeMPLJO
	 sci9JTfoywLYbLJDJ6vD6jnWy3io9W+UhsM9icIKgMFtBczI2p4ITQ5cKWPY412/Qz
	 I4Ph09sc7VGnw==
Message-ID: <f2d7be27-1000-479f-801b-7f49779ff675@kernel.org>
Date: Fri, 2 Oct 2026 21:18:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 05/14] drivers: nvdimm: use pgtable_has_pmd_leaves()
To: Luiz Capitulino <luizcap@redhat.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, baolin.wang@linux.alibaba.com, ziy@nvidia.com,
 lance.yang@linux.dev
Cc: corbet@lwn.net, tsbogend@alpha.franken.de, maddy@linux.ibm.com,
 mpe@ellerman.id.au, agordeev@linux.ibm.com, gerald.schaefer@linux.ibm.com,
 hca@linux.ibm.com, gor@linux.ibm.com, x86@kernel.org, tglx@kernel.org,
 mingo@redhat.com, bp@alien8.de, hughd@google.com,
 dave.hansen@linux.intel.com, djbw@kernel.org, vishal.l.verma@intel.com,
 dave.jiang@intel.com, akpm@linux-foundation.org, yintirui@huawei.com,
 dev.jain@arm.com, usama.arif@linux.dev
References: <cover.1789695931.git.luizcap@redhat.com>
 <55bb106b95979658b9f8e53d0388e84a8c8de90a.1789695931.git.luizcap@redhat.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <55bb106b95979658b9f8e53d0388e84a8c8de90a.1789695931.git.luizcap@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Stat-Signature: ayeexcyy7y19tygknqm9r6i4ii5c9xz3
X-Rspam-User: 
X-Rspamd-Queue-Id: 533DF40009
X-HE-Tag: 1790968711-247154
X-HE-Meta: U2FsdGVkX1/5JICWZJwi2grGKy89S77SHX/5c8OqEJPr4oF7UPgbxTxks/ViKxrWL+wiKwl8p63IKam0gSoABcXjxHVCXIxEVdHRTtzu25lgb+xW28jIuc5EGMv4ZrLTq7e9BwQ+iywvnyMOwIHB5UfpzcWw0JNzK1y9ZAk02v/6CZcCvwwsFN5di6c3XayqRKqZM/cSrsVQN2/kreI+jJiDtxjJYcCwqT6KWs2RcTYZKiQoHuT69H3MK1z7o4TFF/3R8R3FvKQaClJevzRakujDeGsve2E2/mMOr+WwTKgaF+31/VerVqpQzlt0fb6s28d9UUt6uF23gMRDGWVro79Y/336R3DD9QdfvekC1+USjeGL4sfs8taV1hiTpIdlJVg95zBX+HIveywFFydTF0054ZJZlDOWaCx8kHTSuZtIFpfcVOKufM+QzscBPvvgN4tdHWzHJS7G9Zet9ybW8xaNyTmZ6gGT49CjIDuvRF9XPQUzE2gDvDXYIThrEYnTsTpuD1emO3+FOefT4sMjQXphP+rXvHxJoFgNOjU3u6X+pgXDZQJh72eBn7WnNpRi8qTfq/EO4eY3thTGsvva+fXxlwBRFOfvYqcNiBPZ2UZiOcqZwcucEZeVl3+FzBQd1Qp5k7Vhy6khtzHsybvBdVOzWslzwce6uReAHfrze321ED+b/xyAB7LgEwcUq5bgq2mL9RO7UG7jJiaGCntJ8b5iZSuFPGLKyoI/JAIcBrB0xW68By1a1QrQqwwuEaU8CaK7XJfHMYDX7ndH7hQltAI9hMVtMLx0ZjlIQPXYP7aDDtHS16jawRVVFBYmhTwSRQMQ0JDKbpfgzarRLr8kveF8pNNbicW9WmgFR7ZANzv4FFO9LOR0xW8DlaJje6dfM2vZELnFP9K6W68dHcLcNVKKpVZhC/0JVeBHnY3FByT7yxNFJGChcDUXfRj8+RZ9c1B2R+7y1OAogYs8D5a
 wpScG4CN
 v+Ny8ZOgVdIubJ1UH34ur3Q6VBPk/jgwkrAF6iBuxGXvbM7MRMHHXSmcFpfLd3HC9pDa1fwpRZct86QLYLRGx6Ogpb8lYe9mSB1kIy6WlGNh6Ca3hvFDlS5+U6Vfx4n9IjVdWygj3m+tBPNGIz3HeQX25zBFwiKln7+cxp3eT8jhVkn8QUPf8jm9XCxULEIwJgXJIU+sa0DescLFgF/qw+uGyAbw1piO7C3grvf8GCRIFDW/w82pOwT/h9aKwUQIePAy8t01HNLBtkSulme10d4+y8o9+/choG+ccif4f1atQYWZoKiYcNW/eKxKANC3MtS0akviNtowb6HXkqCVlbkv8Nb8oawfqRgeVsaj48cylIOCB35nP76x+1vruKi6LtUZY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/18/26 03:45, Luiz Capitulino wrote:
> nd_pfn_supported_alignments() and nd_pfn_default_alignment() use
> has_transparent_hugepage() to check if THP is supported with PMD-sized
> pages. Use pgtable_has_pmd_leaves() instead. Also, check for
> IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) to preserve the current
> implementation semantics.
> 
> Acked-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
> ---
>  drivers/nvdimm/pfn_devs.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/nvdimm/pfn_devs.c b/drivers/nvdimm/pfn_devs.c
> index 8fa9c16aba7e..457eb54e7ab6 100644
> --- a/drivers/nvdimm/pfn_devs.c
> +++ b/drivers/nvdimm/pfn_devs.c
> @@ -94,7 +94,8 @@ static unsigned long *nd_pfn_supported_alignments(unsigned long *alignments)
>  
>  	alignments[0] = PAGE_SIZE;
>  
> -	if (has_transparent_hugepage()) {
> +	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
> +	    pgtable_has_pmd_leaves()) {

Not sure if I mentioned it but we *could* provide a helper that checks for THP
PMD order support. But I would only add that if really used frequently.

Scanning your other patches, that doesn't seem to be the case :)

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

