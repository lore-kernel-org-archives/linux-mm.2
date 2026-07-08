Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 004E4C43602
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 16:32:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A41126B0088; Wed,  8 Jul 2026 12:32:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F1F76B008A; Wed,  8 Jul 2026 12:32:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E2326B008C; Wed,  8 Jul 2026 12:32:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 675EA6B0088
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 12:32:30 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D515E4021A
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 16:32:29 +0000 (UTC)
X-FDA: 84966152418.08.C6CA2A7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 0DB0C180010
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 16:32:27 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WNVYon2c;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783528348;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P6tPxX3gIMIVPqjzkXAtg0q2TsTgXMBwoII0aWUrcyo=;
	b=WlGxyi3stoeQJ264JpuT0wASOldhT13M9MwaXNgZsCQdyeuH79fahlEYpzhfBYjORwwOZC
	99lnpbWJzsKwk95ykvKFbN6vqgzbUB9/t2b8e6V5YugHasREPYt1u39OE8kcpOKZ447z35
	giFoo/Io6ZCQZ1UesXWfWcWo63r9ifI=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WNVYon2c;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783528348;
	b=hWflUGF26rYVDZRcSLGSgZ0xPlA6XiOrTFjQzG645yo3wxZ4j7Ttzj3MKYjpeIw9inPI3s
	YS4Q8wxVZQ5qiThxA9TvUHt7EGMQ2In6FIz2SQl38Y8kQ4QpOQ1MSRt0BJ6Ne0EowZRM0j
	7ndAM5bqlBya/X1N6bmsbCX9Inn4Be0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D04254012F;
	Wed,  8 Jul 2026 16:32:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC4C31F000E9;
	Wed,  8 Jul 2026 16:32:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783528346;
	bh=P6tPxX3gIMIVPqjzkXAtg0q2TsTgXMBwoII0aWUrcyo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=WNVYon2c7VTFWQGDORJfI135bNGLrZIyVS6PYqzKr0T52GWoSlkdZW7KTnKd6u/r+
	 TquGsv01GkbqExIbNU96vxAvvqK15dFlp1rNJhY7y/obqQ6eOjIOHFMX+cW8CJ8Wim
	 McUk4ej/jiRea1PcZG6s3NqkcstFCNUZ95wzKd21r7FBDS8zMv+afGINi/geYMo5xk
	 Tp7cOYsfec2EWV2P8Gyi5SwUk9pKzLmkxRooB4pbRUgMwMDwCmp4rSi8llR9zb4opd
	 za79X6/+7vF/W+n5s09mFuut7FFQRXn64MYP2mv8BJifTqziEGrbsliRY6yCyxfuUn
	 sE5Y2awZoVtUA==
Message-ID: <fe17cf26-f745-442f-a026-3d20fc6b3307@kernel.org>
Date: Wed, 8 Jul 2026 18:32:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/slab: extract __free_to_pcs_batch() from
 free_to_pcs_bulk()
Content-Language: en-US
To: hu.shengming@zte.com.cn
Cc: harry@kernel.org, akpm@linux-foundation.org, hao.li@linux.dev,
 cl@gentwo.org, rientjes@google.com, roman.gushchin@linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260707233433577tAGELJALunrdd2lZy83V-@zte.com.cn>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260707233433577tAGELJALunrdd2lZy83V-@zte.com.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 0DB0C180010
X-Stat-Signature: zb3y8fzg7mycj3kzdhkyhocsbumorx4r
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783528347-703511
X-HE-Meta: U2FsdGVkX1+c0ioNY2awsbyx7n/xy1u+JNykFc1COiSf1Qz2hCaTMaVSyv3DNBc1D+bldpluO19NY7sLS0ckN1ABV2VOGY4Uskt3PumE1KLD9GPwTVy9HeUBl20LlzQKLwfyvGIUZ6itPtjUd0/+vZaBejD3/QCPeyq5CjgyXSvKKKwvQC1p4dCRAUqz9EfCPwqmQCEj1dhxp/MtywS1K7pR5AcDL3GGbhG+ygqfv73SF4MPLo8ylCsH0dDvrH0RI2FnIkUs0yFwxR9fnSTewmRkl4DPQ3nUjzCAV9QYkL7FerCxcoUM9LMDCZN4yg/awBTEOddy+82B6ognizRnzlzfiCtXXqPTSAX45hXe4Oyvt2O0LH7kPWPkYi7My+7w5CzJk9M83K5d+0qVqZKc01NcWMGktpy5+wit3wFmRd3mXJ9C6LKFrOXM4X2rT2Zduk2cfbklthan96jfITYeveD2fLQbZzmX8kdi2v3xGfMM+EDTx4Irc3NwXj2ryijvJU0RZ74bCLvogVCVlqHuw8uhhu7Tmadi45id8f0nB69plBAG++v5aCKtclyw6NJahN5IvnV9CFhu+2Pd7Urx2spXZa8EUYXfy7vPzkATdtruktxM+36bRKPPBxRg+7Kkv9KbohzmG4rDm4n1YAxXzAizx9kVau2A1LBOB56yJxz885qM6I6nDBj1v8GifxfM2hLHyMfOkSRMNq5yvcwe3dqLsu7XanM3PNpIPsEVP0xwY/Zl+Eme6SNUymsZQY0nf+KJcv6fIkQJtmdnKvdK5KmhMjB4HR4DV+FKTjhoFD+gqB+OWZ/2ZELn+0t808BIhXsLr+IJwmu2IUfOxS8JugvBJOdhCoyXvJGOKbbey5jZlpzuMSGJYl+4Rw1yeGRFS5+e/BlY2Jg6lmLTt+n/DqCFZTgbmWSuR1psyH+wkqD5j2o0jL7G075L8bT3Ny5ms7Rnx/9Wq648NsBT8Rj
 QKfK7u0n
 y0cp8EpWAe6H/usQrd1Szb+s5CftEtGCKQnVt5bqWqDibhVrQ004rzEkxIj3gN5Nbnlx1r8jZv+6D4+qLDEujo2VVM8su7JF5rMdEBhRijfZ53m39b+90WULMjMAUzoYYMIzutwDg6TfHCud8WNsplO1EiCkljnMoFftuvkm3hJ5VMFa8qzzo+DSfjq6MZqvUWmRxutVLP1iUFrFJf9n2LktyWw8Dn/M8dopnTkpGwd6hXM0++B+Du8K6bc3mxaVPvb/DI0NU5R/F4KlPTRfXmM+7wkBdKLpgBeHHXYZQRiqdp2pfgcEzXb0YLSTv79EDwTAzsWTu2UbrOM7IgmxFyUw8R2bDhsXs9lTFc0LcdYz8Bw8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/7/26 17:34, hu.shengming@zte.com.cn wrote:
> Vlastimil wrote:
>> It has been noted that free_to_pcs_bulk() is difficult to follow, with a
>> number of goto labels, and this has contributed to two memory leak bugs
>> in there.
>> 
>> Extract part of the code to __free_to_pcs_batch(), which focuses only on
>> freeing free-hook-processed local objects to a percpu sheaf, and
>> returning how many were freed. Zero means a trylock failure or no empty
>> sheaf available, and thus the caller should fallback to
>> __kmem_cache_free_bulk().
>> 
>> Make free_to_pcs_bulk() call this in a while loop, removing all goto
>> labels from the function. __free_to_pcs_batch() retains two rather
>> straightforward ones.
> 
> Hi Vlastimil,
> 
> This looks like a very nice refactoring to me. Splitting out the actual
> per-CPU sheaf batching into __free_to_pcs_batch() makes the control flow
> in free_to_pcs_bulk() much easier to follow, and also keeps the fallback
> handling clearer.
> 
> Please feel free to add:
> Reviewed-by: Shengming Hu <hu.shengming@zte.com.cn>

Thanks!

Added to slab/for-next


