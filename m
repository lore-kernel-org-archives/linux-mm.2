Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E18160A6F59
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 10:06:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Co5RLZ1i
Received: by kanga.kvack.org (Postfix)
	id 3741D6B05B1; Thu,  5 Nov 2026 05:06:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 326BF6B05B4; Thu,  5 Nov 2026 05:06:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 23D726B05B5; Thu,  5 Nov 2026 05:06:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F03F86B05B1
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 05:06:37 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 77F3EA09C8
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 10:06:37 +0000 (UTC)
X-FDA: 85400636034.04.274B009
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id B36CEC0002
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 10:06:35 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Co5RLZ1i;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793873195;
	b=eChp5JfWNfXfkZthndQESyM5p9LFAboR08izCWQvcyz2ECVQtJnOA1MAd/ijkzZqA4vl+8
	TAXMyT+jOw7N1q5ChrAqrDTSvQAzRalBP6ssdNGDNifNuSUv64NOZdXK9RaiXL6cbQszXq
	AjMxroqSkSehWqUm3wkLKP2gx2GJfpU=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Co5RLZ1i;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793873195;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KlNcyjmnp6YOIH32Y02xB2NJvMagbLi0xJ9gkTl0Efg=;
	b=FJbXqswVI3uV0q9lw1BEJbAMcWGmTAjQvTQpv+HQS5RecIIbnMKyYiR7URNZo4NIgHGB95
	4fI0c+SKwdle1mNMc6LxpYDko9HnqdqAy4EAsmjzmuwb60gAJBg7lgAis2vIZ8ZVYroSwE
	rcj1NAUCw76ZHvrC01BQWUvzms2kclc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3F95C60F4E;
	Thu,  5 Nov 2026 10:06:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A4B41F0093A;
	Thu,  5 Nov 2026 10:06:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793873194;
	bh=KlNcyjmnp6YOIH32Y02xB2NJvMagbLi0xJ9gkTl0Efg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Co5RLZ1izUA4+0k0RkTBzo9U56BblHGcuBoqwpfGPxHMAzOSJLeLAVZ4VmxUTkfyB
	 pfS8kdZYT4ULCueqoSrRy780B0spAHvEcK6/IUNfcw867io+38qeF7QJsiaccSnwzz
	 bsvrVw1W/8zdoEonWU3/PWOC/NncXkfPe385AhyCmCaYiycfjm3U48OgI4Lca+0KFi
	 WoJ16/bcNibNqR32kowvTzDs8M/F+uGJkFxdeEwV144aQ41QocFOQKYDQLqwPG2TMZ
	 q6UJhtSNvl9iaN2F+xMpNCpwT/QjmhohMGCyi4uU9TMAvT0ZI4uvlJcKtTdENTZeVi
	 v8mC3pJVCneQg==
Message-ID: <8ebb182b-8a01-4d32-8c76-7e4bd9e54ddb@kernel.org>
Date: Thu, 5 Nov 2026 11:06:29 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: synchronize with PTE table reclaim for all folio
 sizes
To: Baolin Wang <baolin.wang@linux.alibaba.com>,
 Lance Yang <lance.yang@linux.dev>, Barry Song <baohua@kernel.org>
Cc: akpm@linux-foundation.org, ljs@kernel.org, riel@surriel.com,
 liam@infradead.org, vbabka@kernel.org, harry@kernel.org, jannh@google.com,
 qi.zheng@linux.dev, pfalcato@suse.de, ayushr@modal.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <affd6da4e8d0de1424a4e0b3bafcd1324dfb6c97.1793847060.git.baolin.wang@linux.alibaba.com>
 <20261105045406.39871-1-lance.yang@linux.dev>
 <0ddaf336-7cb7-4e83-af2c-f60d23f7aafd@linux.dev>
 <f7bd740e-1328-473e-96f5-89658a08d514@linux.alibaba.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <f7bd740e-1328-473e-96f5-89658a08d514@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: z3zphiqcjfd3occkrk5a891fe1bqz3q4
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B36CEC0002
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793873195-524485
X-HE-Meta: U2FsdGVkX1803a2Uq0U9cgAqO6SpIAG2yAE6mGciPAjUQJ9jJS5aWFMIeIFWJCvCAs4IhoBolXJMLvL6B7Q2QVptK3z1jxXk3ZUsKcb2A2hgzAu4cmJKm3HD2o+PLkXMKrhh+B0epn3jZuymVJl6/e3dxUmDexXZujZdCW6SZx8qQC9dkY78BzTekG2MNiuORvboIhy9VkzAGXZdnoe+jMukB+m6pQ3d8ocunuCGmFEfITa/FsO7qMicBvBb4wsCwBHeBN4zJ9Wz3y1gtkNZdQBpupKmLRYynaWIkLROfs95fgGRu1BviLe55VoFW4OeFLldzG7yRzA0nPQ/iMIWvAHJwg0kmzAGbWZwAi1BnT3F+DNmbH1mpC9ENcLzbXojRk3Dud89NlyeEx/7DucCX0qWM8tnLP1OKG/sjM8icVPIBieRlQuqJrMTlp6wGzYGcOV6TPjFCEkWDkc6T30iX64nV3iQ/JxlByo1Q/OUMszorsSEQoVCLsOF+5/ed8Gt8/drNkkFZ8hN71/JguX+peZcC/JXx4udBenS56YlTk+HvYsGgCEeq510UlcH+LQS6ja+/fmkAKIQPWX5OO2vZUr2odmiUC/2D2H+9PF/o7QHLQqv+DTGUvYsFrqgcUnXugRlPTfuN2kzKyuCqpDeRWJzkAwwv/CX1noscJEZCXtRvDlCSl/fx/Z+e/H3S14q7Gw9v0XapK1D6zUmcy/tPVVmHm4+CFjbQMuC4bsYWZmGZx/iVpL3LOwsaiTeNuBuipA+/DdQP2Yf5nEpVizyxEPEcZAY8LkPUS8qwrjAaRg3nIzVaHksWiCqAoO5HthlRRu0Qux/PPiFpzobIasY2cE4mLM557nS6tVeIk0nvonMiD7RW6tywvIv3muzXj55uQbwUEPD4KFp8nGC4gBk0PIihpySY0EgN9d+E2LB3tX+tmSK5PBR0YhMtKrGOR51rKQ67WVS47zAcGBwN4E
 dwWZ3CWc
 UXqgIgIL28mIjla3HGaUGVDCI77XWpJiZYje6sGmQ3Easkv/pY3VzxhAUEo6agpmchNgwtEtVlyDP+Pm+gYFQtoXg9GwpuFSj7pjhRg6SAOLpL7Vj8vMYiv3fn+0UzidlIbyi8uudLy2IqDS0XCMbd6bLD7agZ2M4ViHz3DLv/8+A0GeggCRjbx5S/bHnXmQ9WpBogCg/3O6GVUBLN33Gx4y4LGoYu+XY1SVJf9cW4qY5UTGJIRoOGDpViIU1Bmh3o0fm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/5/26 10:00, Baolin Wang wrote:
> CC Barry, who added the TTU_SYNC in shrink_folio_list().
> 
> On 11/5/26 1:48 PM, Lance Yang wrote:
>>
>>
>> On 2026/11/5 12:54, Lance Yang wrote:
>>>
>>>
>>> Good catch!
>>>
>>>
>>> Right. Whether the folio can be PMD-mapped doesn't tell us whether its
>>> PTE table can be reclaimed, so those extra checks can skip synchronization
>>> that the caller explicitly asked for ;)
>>
>> Ouch ... one thing I missed ... what about order-0 reclaim?
>>
>> shrink_folio_list() only sets TTU_SYNC for large folio, so can't we still
>> hit the same race there?
> 
> Thanks Lance. But this matches the purpose of the TTU_SYNC flag, which is used
> to avoid racy checks with PVMW_SYNC. If no TTU_SYNC flag is set, it means the
> caller can tolerate some racy checks.
> 
> For this case, I think we should set TTU_SYNC unconditionally in
> shrink_folio_list(). Barry, what do you think?

That makes sense. I hope this doesn't throw a big wrench into our reclaim
performance numbers.

Can someone benchmark this?

But maybe we should really follow-up with the folio-size based optimization in
sync_with_folio_pmd_zap(), where we only need a memory barrier (and sufficient
documentation why something that cannot be PMD-mapped can get away cheaper).

-- 
Cheers,

David

