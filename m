Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17738CD5BB0
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 22:07:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E7586B00AE; Fri, 22 May 2026 18:07:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6BF0B6B00B0; Fri, 22 May 2026 18:07:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DA6E6B00AE; Fri, 22 May 2026 18:07:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4FCED6B00AE
	for <linux-mm@kvack.org>; Fri, 22 May 2026 18:07:16 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 034D2A08F4
	for <linux-mm@kvack.org>; Fri, 22 May 2026 22:07:15 +0000 (UTC)
X-FDA: 84796442472.08.8093EFF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 4886D180004
	for <linux-mm@kvack.org>; Fri, 22 May 2026 22:07:14 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mBZ0FtjM;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779487634;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2KV0AlTiyoa3jUtbm6oMwQjzHgrUrwa9er82zV7w0cM=;
	b=phR6yudCymQXIyBoVH56ffaNwPF9lMnAliBG8qd9rJq+wa1p70DqL0+TjAxpKWHsilLb9S
	IvU059NCp8Cu2Pw4mbn57U498WQY2SivQoneYZES/lWb3e5SHW396q4tC861081kvsMwdd
	L00IFxqkmwYQQkboZcY+yDQA65UJpJs=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mBZ0FtjM;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779487634; a=rsa-sha256;
	cv=none;
	b=bJgcMqh+kRo2orDRjFUjRYAG7DXfXNNga8xVwa/HLLcHFYxAcm020GtVDkBcfY0nvGsl4T
	a0GPk38ATOU91ZQEkw6aXxVlorpakTCKZ5m3ITCugiQJJLjN+PooAmkQoB7SAJR0XeGp0A
	JamQG+Qk0mTJGFo5rmUMr4roziqvL8s=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CE15960136;
	Fri, 22 May 2026 22:07:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11FA61F000E9;
	Fri, 22 May 2026 22:07:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779487633;
	bh=2KV0AlTiyoa3jUtbm6oMwQjzHgrUrwa9er82zV7w0cM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=mBZ0FtjM0YSYlsflAtX0hKoQa1FUHh2NQBNtCjhqhMP2UCoyljHoGbkarKREmDZ/a
	 xj7qQiC3jPcX24abrgzSDOdHGkbUvA7YRzJOD9gmW0YjtB3zJX4N4Fj2bIs6xeceeG
	 q0l5f4ppgxbamtpvGTreTicD+MiXlj2FZUgCVwV4dIYC/++v7qO5cTfqR4k8Lkrws3
	 AJhOPyjBhEP8j84OFrb3QItKGPFOhn2dv80xbwDLNuIoLe/78NfE9xVJveJChIkw3Q
	 I4Rx03gPxCE67XC/EZTenFhnGmVil99p0Zs72XzxroY4uNQ7nCYKtX7j2InoHPeAIK
	 qKH9zaFyJzKIA==
Message-ID: <6ca116f4-b9e2-4ad3-a232-bc441f88bc82@kernel.org>
Date: Sat, 23 May 2026 00:07:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/8] mm: Add ptep_try_set() for lockless empty-slot
 installs
To: Tejun Heo <tj@kernel.org>, David Vernet <void@manifault.com>,
 Andrea Righi <arighi@nvidia.com>, Changwoo Min <changwoo@igalia.com>,
 Alexei Starovoitov <ast@kernel.org>, Andrii Nakryiko <andrii@kernel.org>,
 Daniel Borkmann <daniel@iogearbox.net>,
 Martin KaFai Lau <martin.lau@linux.dev>,
 Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>,
 Emil Tsalapatis <emil@etsalapatis.com>, sched-ext@lists.linux.dev,
 bpf@vger.kernel.org, x86@kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260522172219.1423324-1-tj@kernel.org>
 <20260522172219.1423324-2-tj@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260522172219.1423324-2-tj@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 4twno5s3rjg8thsx9sjqhb5xz4gbzrai
X-Rspamd-Queue-Id: 4886D180004
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779487634-196097
X-HE-Meta: U2FsdGVkX1+GIm/dQl/QHeNjf7MMKDamLBOVU6dv/hyC/Oga0Nr2xuXV6H2kHtqjAtZmITUVMOfFRBW42ZaDev+BfTeyPGZr+EHMY766AnYsmdbrlwkhR4fEcYOSFa0lAUq5YWXlPEodEXe5OKOHE3Xdgwbi6ZRMgkV3AbByPkZeKmTjndakO6P6nlyaIH/g/2lNio5Emh+U79L2BdvQHruXfFo979y3cOstoAD2ZQ1Et1fZ6XExPv8F1xyqNEwgPgI8y4IMeoO7won0Pax27aWv3sp+n2I3oHe+VwxCkBfv6f7BV+8qBMUJAdlGH3Df9xoAvjETi2aqjhrCfRFvl+AD4ogvh9QBieBwonHTSwUHi29tFRRtl7w1JKrQaOP2ufvdPncHwj1s+NNWWgvLPmD4eIW3AiXrTeMds4FgSi3ckFIHe9Kyhmx1UYLuDXJzVykDh3Ba0147c+4nE7su/sjnEE9dRZIv3Ux0xgntL+P3raOEUN+B0KyepeNurzOoAfo2WBF1qJPlAksVeU9r4lur8PRf38TDPEIFx/hy+HPOEw+vGoa6H0B32QAOLzFR7hby2L7ryDAAOu0E51Y3Zza4OjTxAJfpvaM3b3zCSkNH+byegiMvV7jcH5luhqS/PrhSIEFx1Q14A8wI1em0+ufvpO+PZkXTzzj8I4og1p2t4ImEFAQMZvSHaUK/gFh0la1i6Q/077DgdDxEQDM91oxS9qE4PRhZyKNysjf/0VsfTF7PzZnFUR+0+JSYM3hgTin87mfGXlWGeBM1N57CXT6nljwHAwdvGHPRf1LzTEPC34NlraNdIlzlSzCqomN7g0FssY8fGjKNegXLNN6ONhC0xCvkQvY5m/LAUJggQ84uuL16zJOjeNEi7DglFMlcMoH4itz2VC1ZkB/6dN8hIgqmIn7eO2BrVWfLngZAyLN8hVQ+OE7zwHavMfagOp0+biu1v95bA7e0aVUlKA3
 F0oRGYA2
 J49ee7iHj7kdlwPNLNz1I1tpfT/pddBPk/gsl6v6e6kNqGG7yXeZYfFN2kgO5o99yRKQNr9zPb4tV/dx8y7zXo0ajQWoVxxycDH1HbOjOqqIU9iTta4U3G6LW/4uEnjWeQUHTjb7jdZiZqRPyjWO0OUQsaQ8vNd0+QrudEk9q7U9sxUYO8KPmS4cBcJRYSTUzmsZfICroNO6o5tDzduqDVdSGjNzpu/ZkcYoxwnfKZqytdGex2uDE4MnmYBePA3b8e8/HGrNIc26pni+wdvaRIe91gWQz6BUq0aq1JMLE1zlEDf4HV4orZ5Tr32h1nWDjqiTgiA9s08msWUM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


>  
> +#ifndef ptep_try_set
> +/**
> + * ptep_try_set - atomically set an empty kernel PTE
> + * @ptep: page table entry
> + * @new_pte: value to install
> + *
> + * Atomically set *@ptep to @new_pte iff *@ptep is pte_none(). Return true on
> + * success, false if the slot was already populated or the arch has no
> + * implementation.
> + *
> + * For special kernel page tables only - never user page tables. The caller must
> + * prevent concurrent teardown of @ptep and must accept that other writers may
> + * race. Concurrent clearers must use ptep_get_and_clear() so racing accesses
> + * agree on the outcome.
> + *
> + * Architectures opt in by providing a cmpxchg-based override and defining
> + * ptep_try_set as an identity macro. The generic stub returns false, which is
> + * correct for callers that fall through to oops on failure.
> + */
> +static inline bool ptep_try_set(pte_t *ptep, pte_t new_pte)

There are only a handful of valid use cases for this (and the "fall through to
oops on failure") makes this very clear.

So I'm fine with this, assuming there won't really be a lot of other users
besides ebpf.

Acked-by: David Hildenbrand (arm) <david@kernel.org>

-- 
Cheers,

David

