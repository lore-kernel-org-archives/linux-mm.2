Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D195B606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 12:27:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=L3B8zwEX
Received: by kanga.kvack.org (Postfix)
	id 6AE676B00EF; Tue, 17 Nov 2026 07:27:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65FA26B05B0; Tue, 17 Nov 2026 07:27:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54E7F6B05B1; Tue, 17 Nov 2026 07:27:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 28EF66B00EF
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 07:27:02 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2BD181403B2
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 12:27:00 +0000 (UTC)
X-FDA: 85444535400.23.C89A8E8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 8E47B1C0005
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 12:26:58 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=L3B8zwEX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794918418;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a0Hhh6EB7u7ze6tHi/AqmllD56uVT+yPDQDWEyuvBtQ=;
	b=ZvyVwQ1WDv2fJ+p0RwckjzW71rvYPR65c0W6exJYBmRhybOd/1HvCa/muA3YPT+SRYvJfF
	0ygKv4yAFc6D8qeo5DaG5Kj1yJ1saTACtLgQg+wiOIK6FGaP7tQ8WLOtzomykJuzJCNVMW
	PZOfG+X01eScFKrf0EaKeH7GrC1zuZU=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=L3B8zwEX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794918418;
	b=D6g2zHAZsm0PTofQ5U9qEp91n7i4+JMgGzvpvCoJxnVLA6Qc1LUrcJF7G08KYRLtAgi52P
	1aXxRrrmvgytoe3ZcztNze7CT02BJrT63PNV7H8ItZoJkZheBXIQlWDKVcZdcudzACfjaR
	M95T1e36wPJA+E6BAOgpPx5/JMwz18k=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4FF3863469;
	Tue, 17 Nov 2026 12:26:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5012B1F000C5;
	Tue, 17 Nov 2026 12:26:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794918417;
	bh=a0Hhh6EB7u7ze6tHi/AqmllD56uVT+yPDQDWEyuvBtQ=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=L3B8zwEX1FTal6O2Eoy7mwJOAUsJyaL07I0n5sa7jQbOMTnV8LSBRDO5mhrYj7xBL
	 qmncfH3N68+9Ld2c0KC+cQh6tJUWmGDp1uhXgdNRYi8YXggB1uVr9+U1iIv1kvgzbW
	 0IVV0KaOH9/vIMOAgAWPCHZIQ20rMwcSflm4Df6WkAaoyvPN2hkGeoFF9Av7FPArqt
	 Ck+nzUb0sMblXMJymF8IVhrsfMjRGfRucr1V0Yz2luxdfACZ5ItBcsXcWnDnhOhmmr
	 iL6Yt7QGzH43LPppRMilN3ujiwNT/FkKpnMOGp3f4T2kI0geMpS0HYN5Y+jxz75X6i
	 suriT9i4Gl5GA==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pratyush Yadav <pratyush@kernel.org>,  Mike Rapoport <rppt@kernel.org>,
  Alexander Graf <graf@amazon.com>,  Jonathan Corbet <corbet@lwn.net>,
  Shuah Khan <skhan@linuxfoundation.org>,  Randy Dunlap
 <rdunlap@infradead.org>,  Andrew Morton <akpm@linux-foundation.org>,
  Tarun Sahu <tarunsahu@google.com>,  David Matlack <dmatlack@google.com>,
  Samiullah Khawaja <skhawaja@google.com>,  kexec@lists.infradead.org,
  linux-mm@kvack.org,  linux-doc@vger.kernel.org,
  linux-kernel@vger.kernel.org,  linux-kselftest@vger.kernel.org
Subject: Re: [RFC PATCH 0/5] KHO map
In-Reply-To: <179486913878.127049.11178890384802388709.b4-review@b4> (Pasha
	Tatashin's message of "Mon, 16 Nov 2026 17:45:38 -0500")
References: <20261116134013.1636689-1-pratyush@kernel.org>
	<179486913878.127049.11178890384802388709.b4-review@b4>
Date: Tue, 17 Nov 2026 13:26:52 +0100
Message-ID: <2vxzwlqbfxtf.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 8E47B1C0005
X-Stat-Signature: ss839y9dxjz6yfith3bma9hz6tyyzr9e
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1794918418-192152
X-HE-Meta: U2FsdGVkX18/aUEmpA3zrsQqw10eN2l8rCHJbNmQglfin94WZsN0QjCpr9mA2OhjCkceYvj3ER9bsd9L7uZXmZovqCKlLuHVZct7cEzE9CHrQjfPjX6zgsDsAAD67xv9Y1fDET4+mm6OoY+YHkxuKwny09qK0pH1hE0Us/f67HGYmFpK3VfcqIqN2KzVbtNyiCABJQh9ZP7JcMH8T6PWuO82jk/TugSHL8UB9nvyFXMjhnGa+3si23FMnK4D5txFhgvJXmS/nqBkoMQP7UTQ8mfW0c4CPoU/M27jeEa4lxjVb+HwIjYz7SO8bh8uVq0DSwr7FqDTG+W61hXBIxwlskljBxbii8UaZgHtnYWWEdQipL5V7sWoI8nOA1NYTAcUPqv9HOstlAdnVACkUl3ChfQIE+AOfqc2+Ms7UU+gTkgcKoV5biVwKTV+vf4d65ApF5M3tC15qT+EELOomtCQS1OJ1nTF70tWjzXcMjHBkGpQ6H/LytbrYczxltrFM68MgRSIA87KyS64eYda1EbnEzreZxH4CCpDt2IipUD02/SIT62Pt29fhJ2oPEz5XbA5BD79W3J83WS1RyQSgkoOuL0a9g2YLIt57gQLcsvRup6rLws1lKlpVa4CNgL1TqoybVoiAfe8ioLhhGKNZQswqs5KEBZbxVMclsjzwXwEhvonHDKlRwM/NTIdYJ+XgkCCCJgba0ZHYyexz6++beXHiqItA1VokoisivG3TWFOyx6CZjqkoqJRQeFpBDkGR2hoT/QhFX0E+9Xfw8xIWw8UlGbEnuR67vnH0jDrupXHahCyLLCsChNxD1YXSyDUD6ykVcwAbLfe9ZZWqnkR3M8Bsg6FhFDhtgUUgJTjryRmFN42Xu00YCahbvZ6Usz0FVyriG+GopQiQ9/muLiBDba1pr4Jj0fd7466JMse0L4UYGPNnDbI/6d03QGE1+akw9A9ysS8vxvXu9SGfQAJ31F
 rohsYn+V
 T2RcxIA7IOo2tLOqLJL9z0GLSLZ9ei1yAnBZNVVYzLk9A8/FL7FQMi2f6zfPGoxzkYXHpFvfE8/IUpCRxxYZAfulYPtrhfO9J4tIWuhVL0Xf0N4I4D4W+SlnxV7kVCfRfd/7xL3JlWLZJMeiu3p1sbe8i59NhZF066zZMyQQSaeW2Y6hPwXVwfAQUkFpa2qWriYwfQ5+jcPAFiRNhlXTZtpWXZgnKupi5v9gfSoXPpbrzn7Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 16 2026, Pasha Tatashin wrote:

>> From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
>> 
>> Hi,
>> 
>> This series introduces the KHO map. It is a sparse map from integer keys
>> to u64 values. It is implemented as a radix tree of fixed depth.
>> Currently the tree depth is 6, so it can support keys up to 54 bits
>> wide.
>> 
>> The main user of the map is memfd. Currently memfd uses a vmalloc buffer
>> that has a pair of {index,pfn} to track the folios in the file. That
>> uses 16 bytes per page. The KHO map uses only 8 bytes per page with some
>> overhead. So for a 1 GiB memfd, it uses roughly half the memory.
>> 
>> In addition, it is a more versatile data structure. For example, it
>> allows for adding or removing pages from a memfd after preserve more
>> efficiently than the vmalloc array.
>> 
>> Post-LPC 2026, the plan is for KHO to maintain backwards compatibility
>> as much as possible. So this data structure allows the serialization
>> format to be more flexible to future changes. It can also be used by the
>> upcoming HugeTLB and guest_memfd preservation.
>> 
>> I have talked about this as "KHO xarray" before, but I think using
>> "xarray" is just going to confuse everyone since it isn't really a
>> xarray, and the API works a fair bit differently. So I renamed it to
>> "KHO map".
>> 
>> This series isn't complete yet, but it is in fairly good shape so I want
>> to share it to get some early feedback.
>> 
>> Things that are missing and planned in the future:
>> 
>> - Multi-index entry support: currently, while the map is very efficient
>>   with 4k folios, it is horribly inefficient with 2M folios. Each folio
>>   in the memfd takes up a full page to track. Multi-index entry support
>>   can fix this by tracking entries that cover a whole page in the
>>   previous level, similar to page tables.
>
> Let's fix it, see below.
>
>> 
>> - LUO versioning support: LUO versioning headers are still in
>>   discussion. This data structure should use them for future
>>   extensibility. I am mainly waiting for things to settle down there.
>
> I would not worry about this. If versioning lands first, this series can 
> be updated then; if this series lands first, Tarun will update his 
> series.

Sure, fair enough.

>
>> 
>> - Dynamic depth support: Currently the depth is static, so it can only
>>   support keys up to 54 bits wide. Adding support for multiple depth
>
> Let's allow keys to cover the full 64-bit space from day 1, and make 
> values 63-bit (like XArray), using bit 0 to distinguish a child node 
> pointer from a leaf value.
>
> By making it generic from the beginning, we won't need to worry about 
> ABI churn for these features later.

Right, that makes sense. I didn't want to over-complicate things, but
you have a point. Taking the ABI complexity up-front is better than the
churn later down the line.

> Instead of caller-chosen depth, the tree should grow (and shrink?)
> dynamically bottom-up based on the widest key.
>
> Plus, with bit 0 tagging leaf values, 2M entries can be stored directly 
> at L1 and 1G at L2 (on 4K pages). Even for huge memfds, the pgoff space 
> is much smaller than 64 bits, so in practice the tree stays tiny in 
> depth.

I think it is a good idea to allow dynamic depth in the ABI, but I am
not sure if we should deal with the automatic resizing just yet. How
about we start with making callers specify the depth (max index/pgoff)
up-front for now? The ABI stays the same, so we can add support for
dynamic resizing later if needed.

The reason for this is to keep things simpler to begin with. That said,
I don't have a _strong_ opinion about this, so if you insist, I can add
dynamic resizing from the get go.

-- 
Regards,
Pratyush Yadav

