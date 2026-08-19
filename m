Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14A25C5DF6D
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 07:53:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 030AA6B009E; Wed, 19 Aug 2026 03:53:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F247F6B009F; Wed, 19 Aug 2026 03:53:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DEE626B00A0; Wed, 19 Aug 2026 03:53:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AB6106B009E
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 03:53:32 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 330F81C1701
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 07:53:32 +0000 (UTC)
X-FDA: 85117254264.24.7FBEF45
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 7ACD11C0003
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 07:53:30 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eWcQU0Tf;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787126010;
	b=Y0d5J1O7neSum0y2tFiaOhgqPZnokyn7TztpET3Bbh1kUBWlP1yfHkf08nzlIQfnFzHYjf
	fpRM2A+6AQ2qAdXONsshhA9PnYw0efaAIIiFqR+extxURtcnxAj0UNs5+J/K+oh8LQXWZd
	m1VFwVky8oHc19parDcMD3gSdoDkJsI=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eWcQU0Tf;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787126010;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IOVnAzrtzMZry52kAtJbyAWqgqvrP9lIJJ3RCLrpCZo=;
	b=IO574GWVWumG8/z6AUCCRIbJCOdrdqqwA2Ki35YzqrfAUmnin1uKO1c8oj43Nh3UlnX7E1
	iXMaN1w3sVWmZBkfdi6PGB0rhx/co6GQ2CG4i7/28tVpbckWqXnpqxAny2CXjSCdsSCDN8
	coNa38eeGX8SXkNpl8omnF0RxZTnl0k=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1D4D760A5B;
	Wed, 19 Aug 2026 07:53:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 315F51F00A3A;
	Wed, 19 Aug 2026 07:53:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787126008;
	bh=IOVnAzrtzMZry52kAtJbyAWqgqvrP9lIJJ3RCLrpCZo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=eWcQU0TfxIXjvxi/EgDAtwrxXGiGGUEUm0JmfaavjmD/GlHAnV/Va6QAXcquMuJ09
	 RV7Iu/9IJuFonJiSo0szpDVf5YP6uoQJD+TTD6DXRwwPQTGNbBWYaYv0hPDGbAfi2I
	 gKBKKoVi/Hxscz4recgIOokI7wSxcDAd0AWRhv1WaEeXCEAGhYaYzIZevc1v+POmiy
	 nwL5PB/+MtENHwYdx3Lkqfc4VK2Ar/kJgKCyItZNsioxwmBD+dNpKCQgvD/2dt3Xqf
	 j/MPZI/mX/wVHNudeSFg6FTbsi3heYKqz4GMPTClpTm4oGQxn3kfulatHh8feGOPL0
	 UIt7M05rfTn8A==
Message-ID: <35cca76a-4d3a-451a-b492-dd4423ac3e63@kernel.org>
Date: Wed, 19 Aug 2026 09:53:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] hugetlb: add cond_resched() to __unmap_hugepage_range()
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Leon Hwang <leon.hwang@linux.dev>, linux-mm@kvack.org,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 linux-kernel@vger.kernel.org, Lance Yang <lance.yang@linux.dev>
References: <20260818135029.93288-1-leon.hwang@linux.dev>
 <3dadebb3-7e2a-459c-a5e8-b375faf89938@kernel.org>
 <20260818111756.6b0e347db3170bc22cc3c5af@linux-foundation.org>
 <2a523945-825c-45a5-a680-37e941e092d3@kernel.org>
 <20260818115526.654d7311366b66cd031c67e4@linux-foundation.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260818115526.654d7311366b66cd031c67e4@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7ACD11C0003
X-Stat-Signature: zxtcziezk4s7x137dps8fqqerf996rbp
X-HE-Tag: 1787126010-178000
X-HE-Meta: U2FsdGVkX1+KN/crUXYbcOIszzZX5XF3ghNqA+bFLm3sc8jH4XUPey5Qk4xDKH4h/7ASrdkwGUtnsJIuLbWk4+p5Vs52ECx/k/SE/ngda47uXGeZDmO65yqZeyJSuDfy5KNdntqhUvav82bmORq/+vLgEXGXpZl2TdHLZDHEM2unRIcA/rHRILngcERabSWmvrwqfwlmZawMkq99hb3mpYsq2pYqZC9mvQk+1rgxggslsPnZ84LHOG59k/v6J3IUCcGmdMi0sYyIi259DHalZ3aGmhRVlxxwH4aYadvMmubMRBc1MefwazsLUEOMgdrx+64pOhpuKD7Zp2DsWChsJWEJNs09qKYLReNUEJ12qqiavY0yszMNG7BSt3RIm+klrOjPt6lKrAUAaG6Wsht8MhgOK1z53vyLE+uk+AozSkdv0l+iKN6i3ZvCRH/AF9LejskRJfhHopMMsGOy+KvciCcm1AaUE8P0iQ1Dc8Peuli+qFtGM0iodw9pDn3B+jAhMD98HENpXwwWeVbFRH73GLBgwWPXFymVDCM9wz+iIEb8HPTWs+oA/g7xBIJczGrJ3EzMatooOr/0yOuY/ttsTPJw8B0WqPw19Q06DOSiwSabDJ6zmkjVtc5v/S8LUhH5fLgT/h3B7gijEd7nE9y2lI/Po0LSApPxwKw2j4jfCTU+tu0ZSTr16mdFaoITm/1smYypKeteX24Vd+aboR1mYSVhSwHgA7OS97xQENrye1L/trvTo6eJMIFvbmLdLuFjo6EuO8mDdb0p9uvMDmgYseKXPyZZlqf5Xq3/ytLVLgpMKM2zVY3gdWNzIOzQppZTVhvJSlhUtt2zhT/vYqqFW+siBkkpF7koU+0eQX5L1xC4s1EYq5/mzVaBkXKyxN+fbVCzI3wgYmAN4bB+8038d58vgS2enPIOJ1f3w3Cx6eOjrEPdZdtuCKZGBy5y7N1yKdf4biU4QJ6RVWGB6EH
 Sa32wdhf
 p3zC6rExMH8N2VsNf+HqEpbK4WhA5IORvHN9DbZv/hqt4O0cBCvK9dGU///LfxE+AJ53m0t7/Qye7AJhcj667z6x1QUW76GY9e0MFzxJ3xYaDrbDGgD6wa0JuxDgQgrYvHYfXD2kDJdohKC3miJpVxTSO4AtS9091wUkbSlESxHmhK4D2d5FphHSlJMrgpWeQ6D1sYUeee31RvduREKnnfRpwJsJX0JR06TpvPgayf6+KYQC8ukY/9d5BDCoezdqwbLVdIUPk6G7NhkD+W5xiGIrJnYmLRVtXqjB7mtsxdV1c8ydAotNfiWvcxd3KZY4/LbY0KQdXTcFSIKY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/18/26 20:55, Andrew Morton wrote:
> On Tue, 18 Aug 2026 20:21:37 +0200 "David Hildenbrand (Arm)" <david@kernel.org> wrote:
> 
>>>
>>> That's pretty bad behavior and we might want to fix it in earlier
>>> kernels.  Is PREEMPT_NONE effectively dead in 6.18.x and its
>>> existing users?
>>>
>>> If yes, we do want to fix older kernels then we should merge this.
>>>
>>
>> Okay, but that would be stable-only fixes?
> 
> Not understanding.
> 
> Maybe you refer to adding a patch to -stable but not to -linus?  That's
> against the -stable rules
> (Documentation/process/stable-kernel-rules.rst).

It's tricky: if a problem only exists in stable (there is nothing to fix in
Linus' tree), then a stable-only fix is acceptable.

Otherwise we'd have to route unnecessary churn through upstream just for it to
reach stable, which doesn't make any sense.

When sending a stable patch, it should document how this is only a stable
problem and why no corresponding upstream fix is required (or how the actual fix
for upstream is actually deprecating the relevant config).

-- 
Cheers,

David

