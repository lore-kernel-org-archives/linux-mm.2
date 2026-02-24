Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41330EFB816
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 08:46:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A56A6B0088; Tue, 24 Feb 2026 03:46:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 652C86B0089; Tue, 24 Feb 2026 03:46:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5627D6B008A; Tue, 24 Feb 2026 03:46:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 42B4C6B0088
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 03:46:17 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 01FE91BFF0
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 08:46:16 +0000 (UTC)
X-FDA: 84478718394.20.FF5E068
Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	by imf26.hostedemail.com (Postfix) with ESMTP id 13E26140008
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 08:46:14 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=t1zC1XfD;
	spf=pass (imf26.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771922775; a=rsa-sha256;
	cv=none;
	b=IusyWT8v5X9B25IRnAB3MRPIP+DcRQTjUOC4uMQ/N6u8FCTGZ9eryJRLGMoSjTKDb6Kh6v
	yBxof+1QqJt/ZyWhqxrAq68RTX70q9UacLb/M/UGf1w5cJGgbXJpnWD89fosMhCFMFnKNF
	0E2BlXQVwsYjPm4XNXYn2N72/yQZQQo=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=t1zC1XfD;
	spf=pass (imf26.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771922775;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0uJ5WZpkoz2PlS+e/oWj8d2/Z4RKR5KjB8D2HwBT1fg=;
	b=uZ/lHBb7Cydi5gpsnbrUiom35K8X++bkhlP3ReI2yHb0xx+Twn6MZIXHJ7uvxuaLS7QhrV
	zkzcGJcPkB8TIyThHEA0Y7MwZHmr+B1TtXqYUwstgVrfz/1HdidxYAr27sqmFygLPwj73J
	RGxRw4P9DODL74RIkbMFtK5xr+BZxpk=
Message-ID: <108e41e4-cbfb-458d-b72a-1becca61327d@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1771922772;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0uJ5WZpkoz2PlS+e/oWj8d2/Z4RKR5KjB8D2HwBT1fg=;
	b=t1zC1XfDHs3l9Q9JLpteHHfp9nCw9LADY1Q8lpmx29IDaZSudYzOpnNIiBSFgxI2EJ8Qwd
	S+Z5BbbMlxcvho7b56/rsvu3mcbvd/Jb12rbxrNkKGF/HT9REF8IoNOyUbuIMYwwbkEBYC
	qsYxYZJwWkWvBLRFYa8r5gJ3i+dUzCw=
Date: Tue, 24 Feb 2026 16:45:59 +0800
MIME-Version: 1.0
Subject: Re: [PATCH] khugepaged: convert redundant check to WARN_ON
Content-Language: en-US
To: Baolin Wang <baolin.wang@linux.alibaba.com>, Dev Jain <dev.jain@arm.com>
Cc: ziy@nvidia.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, baohua@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, akpm@linux-foundation.org, david@kernel.org,
 lorenzo.stoakes@oracle.com
References: <20260219054827.4111334-1-dev.jain@arm.com>
 <ea59d95b-80a3-4f67-adc5-3634016eac28@linux.alibaba.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <ea59d95b-80a3-4f67-adc5-3634016eac28@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 13E26140008
X-Stat-Signature: tq1uwnyjokgy5assb3g6du11mfire7nt
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1771922774-841633
X-HE-Meta: U2FsdGVkX1+Ml47vNwOFLzkJFxBovJU3yq3+wXH8K5a2vLBAKBObwjgSYK7ImMWkWKKbikeeBCeLDUf2DW0EjcHdbgZ9f7QSHkuhCEkAXea70lJbzOcGGMm54lfE867s8nOM6aMaIegTsdybNY6SDf2/oNZqHX4ZL3omBQi1OuWxXrY44qwttJLZZ87iGLcdVljmWj5LFd6DirUTwTVxp02tqtVSrSt5qj37d5I1K/o4QnWScMhgZMhXCSSPpNd5A/rtoTh+ZJXt07TeOKNxv8MoWSQAqE8/SRiPw+CIIlGi1EJ9380Rnv8pRcqx2hacoq2I+CL+oePhrP1+yYpGN6GQSM9fgzFuPkqEq20wdA8fqp2QMXQWj5tfJqcEPQdci4wv3F1yxRgdk2Ivb1vvwWFyVzWCgWZ+7AXDmoSYh5CHJsVtwUcx1+R5zzpSH+26EKzipzyPo5Me+7/7DlaPNwn+0Ua59p1a5u5qQyvMHcv9uXKpone+UGMTREuSewaBAjO64pB685NkQgf3v7GXksRZHI3nLtmhxEgeSCBRda5nEmLbrGW8zwJq4FM2v+CgTAf6jF9qgvenIOoJxu4bM2sUvuearBxABuwM7Ie63NdvxH4oqMbEocQH2yCNEA0JENobU2Au7nWF3aPiZYiwOZnD5K3FzIGNbgslKHknrCPU3rF0lD0F9XBhAkg5lYUy1pCd7nw/R6IlO3Fi/zpizw66polRQBrwS5xeVw349ug5+fU54CmRZrxe9s4iq+qQNVugZ70raVtJHF5widsF8an73Q+mY19JIqaBvBSGpyeQyY0qFLDxcUWGidxWm7eXWtRB9qwoKaLlRQxuA1YeiDTuWFfviP1jmQlPFCP+rePVm8JVGlOBzl4lGLt28NbzxkLwKoQokqVttImVc6mjJuUmtVkZk9F6rGlilgrVb5mmegNxY6kb1cZdIeYvaQt73W+tpbbcmT5jk/ptlSb
 rE5bXzzB
 E9C++HpcXMR8MmPri9oWmnna9npzPfJzdT2A7dbVdcwywUnfkqzLQEk6380ItNXE2nbdwGU/QIPxCZ1NO648CZ1Ch4Z7joyZQ73Igwp2MsEyqQemqi8cM2yq+H8xqau8Z9rr1bEYQ3uCu+1b3MvXJrlI9JqCuJaqZQzsqW4sTE2/+DMWQVafVzr4GEWmraqgNMm7ajSfAgAp8nQlDzDwPL05izz7phjLSJNnT0/MW6sIPIta9Nt3HCtjcr9DUAc7p32cIGPpRO/23Kv0AniDdkhwAgQlg3bwcf8Isg/j6UYQAhSzSYR5kkPUrXS9LOH0QksPaOdXEYSpHBbuRy2o7g/JzBw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/2/24 16:21, Baolin Wang wrote:
> 
> 
> On 2/19/26 1:48 PM, Dev Jain wrote:
>> Claim: folio_order(folio) == HPAGE_PMD_ORDER => folio->index == start.
>>
>> Proof: Both loops in hpage_collapse_scan_file and collapse_file, which
>> iterate on the xarray, have the invariant that
>> start <= folio->index < start + HPAGE_PMD_NR ... (i)
>> A folio is always naturally aligned in the pagecache, therefore
>> folio_order == HPAGE_PMD_ORDER => IS_ALIGNED(folio->index, 
>> HPAGE_PMD_NR) == true ... (ii)
>> thp_vma_allowable_order -> thp_vma_suitable_order requires that the 
>> virtual
>> offsets in the VMA are aligned to the order,
>> => IS_ALIGNED(start, HPAGE_PMD_NR) == true ... (iii)
>>
>> Combining (i), (ii) and (iii), the claim is proven.
>>
>> Therefore, convert this to a VM_WARN_ON.
>>
>> Signed-off-by: Dev Jain <dev.jain@arm.com>
>> ---
> 
> Make sense to me. Personally, I’d like to keep this VM_WARN_ON() to 
> catch unexpected behavior.

+1

Reviewed-by: Lance Yang <lance.yang@linux.dev>

