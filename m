Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A64E2CD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 21:29:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB6C86B0005; Wed, 20 May 2026 17:29:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C67B96B0088; Wed, 20 May 2026 17:29:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B573E6B008A; Wed, 20 May 2026 17:29:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A4CB76B0005
	for <linux-mm@kvack.org>; Wed, 20 May 2026 17:29:19 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 321C8140458
	for <linux-mm@kvack.org>; Wed, 20 May 2026 21:29:19 +0000 (UTC)
X-FDA: 84789089238.09.E230070
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 62CB58000E
	for <linux-mm@kvack.org>; Wed, 20 May 2026 21:29:17 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XQc39hnv;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779312557;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+FvKgT5pG95JgT3TscKBF5hGUKTEVSajCnC+nu0Y4WM=;
	b=nPQxwR7wdKd9UkgVYiPL2+zOp9TiLXSX6JHgYGHXU5j/im1Jq2TlpGAAN64fkj5WoNEAw9
	8aOG3ZkR99y7TS0TNSB/f+SlHf1HyHfGvTihU1IOrM1pcRFRb12rENlpSJoYTdu9hGs0fN
	vqUKq2zmqZ2e9TIA/z0soHptSPEK6Ks=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779312557; a=rsa-sha256;
	cv=none;
	b=gpCRbB4zCTaBMiLXTTU521FJpNN2dccvgMgX44Q17P6LFeqWtHkUe2DsxT9ivgEB2+PNfa
	ym9BiRu2Wh+qLAUYymzNzzfYIWPkNM0XC0nSFmWUZmLUnadyh1FvkTgamzr/D6gaoL+jic
	vy9QfUtcQMdQEUiyamZdqgNM8JASd5A=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XQc39hnv;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 85ECA40178;
	Wed, 20 May 2026 21:29:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE26B1F000E9;
	Wed, 20 May 2026 21:29:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779312556;
	bh=+FvKgT5pG95JgT3TscKBF5hGUKTEVSajCnC+nu0Y4WM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=XQc39hnvCdkTlJIa8y9YfgGkIJQb1cHVaoOkJ7pbNHFepqyzWDGV4Wxa5w7n7maGc
	 X+b9cmNIXD1NNy46RiDLbrSNZKSvWZkVvzOf5pjYkd9GkeQ8uWitOK7rbabbOpRsMR
	 cU2Dzy2Z/oHVXA1L7GHzimHqACLluo7QZV4M3RKQ0VSW0gAsm/ALa1Jg6hl3P+lCuJ
	 2OikXfZRe0W52IcmQMM/se/XYc5GpkRUpXmiQI7394jKgEDAK8kQbIZmBYmRb/oRNk
	 R3bs2GEMBeAjc+i/0X3bVd97RkREIJ/H5nw8+YdfehKMnRuPgqE+f2PNVK0PTE1sZc
	 eCBD5LIKuDCGA==
Message-ID: <210d140d-c78a-47be-8046-caae359db6db@kernel.org>
Date: Wed, 20 May 2026 23:29:07 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/8] mm: Add ptep_try_install() for lockless empty-slot
 installs
To: Tejun Heo <tj@kernel.org>
Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>,
 David Vernet <void@manifault.com>, Andrea Righi <arighi@nvidia.com>,
 Changwoo Min <changwoo@igalia.com>, Alexei Starovoitov <ast@kernel.org>,
 Andrii Nakryiko <andrii@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>,
 Martin KaFai Lau <martin.lau@linux.dev>,
 Kumar Kartikeya Dwivedi <memxor@gmail.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>,
 Emil Tsalapatis <emil@etsalapatis.com>, sched-ext@lists.linux.dev,
 bpf <bpf@vger.kernel.org>, X86 ML <x86@kernel.org>,
 linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
 linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
References: <20260517211232.1670594-2-tj@kernel.org>
 <9ba50fd2-077e-4291-9276-9adb18186873@kernel.org>
 <agtuPrgIDNKSu2Oo@slm.duckdns.org>
 <2f02d90d-cdc9-48ef-abe3-99e00f22595f@kernel.org>
 <297658c4ae2d6e7103f5968efc936224@kernel.org>
 <04b03066-86d3-4c0b-b077-307fd0f3bc9c@kernel.org>
 <5590fd3d-dae1-4070-b52f-bc40982ac678@kernel.org>
 <agyZxmHoueGwBAQg@slm.duckdns.org>
 <CAADnVQJt0p7hSn2G074QZRh2LEdthy3RKYJ9j3w5yeJ-e8UQLw@mail.gmail.com>
 <fb889bfc-af0e-491e-a69f-38c2abf88d22@kernel.org>
 <ag3_qpKObFOLKgbR@slm.duckdns.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <ag3_qpKObFOLKgbR@slm.duckdns.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 62CB58000E
X-Stat-Signature: wx4ked8jan8faf3ey8td4yqjkjk37dd6
X-Rspamd-Server: rspam06
X-HE-Tag: 1779312557-825320
X-HE-Meta: U2FsdGVkX19kK48XPikRxT5lWqBUMusZppSElQongm0pIjhoGpcf9COa/mk6biZzR1MPQv65JpN8Tzus0EtpC2sqU0htGjPfG5qtiNiwzrjWMljLjE1Yw3euYkh5dfh9BolBsFiqws2MKnfi1HnOa9RE2yY3Alfm+HC9Pl4G63mwoV/dPULbAdTCsumVzwj/lQnLouH/lI0uyf07LvCIxIFALqVK4Bkq0SN6mareHBfhlnDXZ6CrCTZB0GtXdADLYCeUqxxJIblGf8SMdHjK6W/1dX1ZH0Wbv2ZdtTLQ+kF0S5mBp8GjzEBO72zFCvBPF4+wow84WHxSo39j2sHt2JxbAHEgweODajxdoj/pYts3A6InGVsl+ad0TZX5TaiwZKPVZ9n1xTLvryAfxxB/lT3YDamQHrrTSWL/cED+mU7O1IppfCUKlxZzpfY8+NQ94jUw1JZSHtyro51w7dpbj0YWlKU2ynpO7Doo6fSQeDFhkcniURPeVQPXh1/IVI4OXuyryj02kvAG36KiL1ji4dZdc8M5vHpfBc3VnGEMolcTwntkT1O51dU8dZv41oMkGjtDv4cGHVFs5zC6vfx5cGiqFP0iFX4T+plz9qLKvTiNiWxTtt5qu3rwMXD03zlZsciov2dd0DH5ReZf8HeAuoiw+o1laIjubYZCovOJUhDgQEMFo8decKwB8cDdnYZ985+L172NAL9gLSv68r3ZkacLnzn+KzToUOu447CwGHXnamVu4tTvYaCRV6aGnJWBZcA2uQZ9hPKZ3rphe2I3R0h73C00FmE0J8JNte4vDgz3E5t7DnWCnNuHmoo+55w6H6PUlJMyePMCsS8fzAnWe180Yx7a2PC4jMmbv4APF0q93Py3RVscM4mfY84L9AIhVLd+2/jqBsuAmixrhy+odklaPylmlx+Plu9tBO7bunE89PtzcuWEZgUHZfgRwf7egpgRsO1qBgTUt/HQ2w8
 6qs8o70c
 lPMUBug6N7biySER201Ph89TCdyYgD78nd+k7RaAu0k8NuFFs7jw2YN2duM/gCfcE8vcwt92DLOA4hE1V+jJyWh/D27M5+MRNlDV6BlzKFPU+k6sNy4PPaz7w4uRmdTZXy+x7OaelPRWHJdl9uWn1k/vE+Q8ePCSOXmKznFDkuHpeZOUjlJuwwuADvxCXSv6rwDSAPk4EaGQ5l1v5hGIUhRN09Rj8Kh61DotfyZ6AvyggqarvTpz1+ig7i3JT60AcTwV6R+SgGBt9yTaAFAAM/eQddNz0tpeebIupNeNEH6ASbTpo0kEZaTuPBmrpqET7Xlm1QS3rsidIW8AX7qwYBtZ6qjykKa8uusD1HykbTRBFP6PZYBKU8puIr11OFSkU97Cj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/20/26 20:38, Tejun Heo wrote:
> On Wed, May 20, 2026 at 10:41:15AM +0200, David Hildenbrand (Arm) wrote:
>> And that should be carefully documented.
> 
> Will do.
> 
>>> The fault handler has to install _some_ page and let kernel continue.
>>> Scratch page or arena page doesn't matter. Potentially different CPUs
>>> will see different page. It's not a concern at all.
>>> bpf prog is buggy, but the kernel will continue to work without a glitch.
>>> bpf runtime will disable and unload misbehaving prog.
>>
>> Having one page table walker overwrite a scratch page on race is just rather ...
>> questionable locking design, that just screams for problems long-term, really.
>>
>> At least in apply_range_clear_cb() one could similarly switch to
>> ptep_try_install() to at least have both these paths handle races in a
>> reasonable way. (having to handle when ptep_try_install() is not really implemented)
> 
> Hmm... wouldn't that be more confusing on apply_range_clear_cb() side?
> Whether it maintains the current behavior (if collide with scratch, try
> again with scratch as the original value) or flip the behavior (fail if
> scratch), that extra logic is spurious, and those tend to confuse people as
> they force asking why it has to be that specific way. If the goal is
> documenting the subtlety, wouldn't a detailed comment serve the purpose
> better?

I would let all operations that can happen concurrently work with atomics, not
just a single one.

Alexei correctly concluded that ptep_get_and_clear() might be one option that
should do on x86 and arm64 from a quick glimpse.

> 
>> Anyhow, the documentation of ptep_try_install() must clearly spell out that this
>> must be used very carefully, and only in special kernel page tables, never user
>> page tables. There are likely other scenarios we should document (caller must
>> prevent concurrent page table teardown somehow, and must be prepared to handle
>> races if other code is not using atomics).
>>
>> To highlight that, we should likely consider adding a "kernel" in the name, like
>> "ptep_try_install_kernel()".
>>
>> I am also not sure if "install" is the right terminology and whether it should
>> instead be "ptep_try_set()". (set_pte_at is the non-atomic interface right now)
> 
> So, ptep_try_set_kernel()?

I guess we could do that, but we don't have a lot of existing functions that are
specific to kernel page tables ... only pte_offset_kernel() and
pte_alloc_one_kernel()/pte_free_kernel().

The most important part is getting the documentation right.

We should probably document that code concurrently clearing PTEs should be using
ptep_get_and_clear().

-- 
Cheers,

David

