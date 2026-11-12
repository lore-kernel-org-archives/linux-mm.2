Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 919BE606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 08:29:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nB63p4Uq
Received: by kanga.kvack.org (Postfix)
	id AA7226B05C3; Thu, 12 Nov 2026 03:29:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A57316B05C4; Thu, 12 Nov 2026 03:29:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 96DF46B05C5; Thu, 12 Nov 2026 03:29:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7218C6B05C3
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 03:29:46 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 62112C049E
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 08:29:45 +0000 (UTC)
X-FDA: 85425793530.13.1F3C6A5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id A3DEDA0005
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 08:29:43 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nB63p4Uq;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794472183;
	b=nYzreRqyqTTCutI53Db10jw2XdBYH/PW4BtqLUWqCBbovQNv0FQPn4T8U5Cq+eAlURrWVU
	h7sxzxXijvYvBejfs1CNDg+26mOSElEDMcNHpP7iClW7pnJoFeU7pp5V0ffvoRAiAZcDDf
	EulxCOF/A1eVjU741Yt3F9lm4tISXQY=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nB63p4Uq;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794472183;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LfFnO2mmUljHjiUSB+JHkBBNtfs+CR7s4DuaVxb5rYE=;
	b=M6wweRYE5CG6T5TU8/xCCNaHpZqX8AB926vPuUiMBbFFM97doK9mYfpczE70Fqap2ILaex
	fzE5JpxmRTdIXNIIhmx3H7+nI8/LLgjxofB8+k93cIi0o/Gu+QjTtFrCogGKjfFABCsQ9p
	WqbqEXsrEp7GLX7b0J/9ICEwZAoQyRc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id ECF1663779;
	Thu, 12 Nov 2026 08:29:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16B3C1F00A05;
	Thu, 12 Nov 2026 08:29:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794472182;
	bh=LfFnO2mmUljHjiUSB+JHkBBNtfs+CR7s4DuaVxb5rYE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=nB63p4UqxR5h4UfW+jPSLXJ9RSk5E++eyt78k0yGCrFFQubEByGzJJTsvvAIcFmms
	 OTd91A2zREUxuBnSe3GBaBsWFmJch5SNaIrRhdP/xzwh57B8zzy7AfoXpGmI76ENu6
	 oTY55ShnnxhYfEEtLsQZ2AzbAeWVeV+2Q3n8cu5/eNnbVZuJ1NSVreWqdCU2zfKDJH
	 IbBVHqVWbvANm1i2jExZM1aLhezYUoJ/ECUS+v4TESKabMov/y/rV5pRxdbV2GlYxe
	 czituN0+d4ncn6yOw5K51uDdaaGcC8gmRH9qbjHbi9ST1SQF6DLQ4j/0R8yJXvddbB
	 TSIE6DH6AEPnw==
Message-ID: <33b2549e-f033-42e5-82c4-a72cb0f92324@kernel.org>
Date: Thu, 12 Nov 2026 09:29:35 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] mm/rmap: fix PTE table overruns during batched
 reference checks
To: Baolin Wang <baolin.wang@linux.alibaba.com>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Andrew Morton <akpm@linux-foundation.org>, Peter Xu <peterx@redhat.com>,
 Lokesh Gidra <lokeshgidra@google.com>, Barry Song <baohua@kernel.org>,
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>,
 Jann Horn <jannh@google.com>, Lance Yang <lance.yang@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org,
 Chris Mason <mason@kernel.org>
References: <20261111-pte_table_clamped_end-v1-0-2dbe339c487a@kernel.org>
 <20261111-pte_table_clamped_end-v1-3-2dbe339c487a@kernel.org>
 <c31cc8a0-c098-4784-a843-f13f51914094@linux.alibaba.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <c31cc8a0-c098-4784-a843-f13f51914094@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: A3DEDA0005
X-Stat-Signature: uw85u1cynp7f87hprbwuuyhojespx6pc
X-Rspam-User: 
X-HE-Tag: 1794472183-709680
X-HE-Meta: U2FsdGVkX1+gCWmwcLTdTxwI0iktDaXNwFiedZnBkkX6bknmH8j5fO6VsC0/ucVGyOobW25j26yUCzjc04nvM8Dc+GK6IEL7Mu+uj31oSilm5H5deMpUWSrCQOmM1M9BB4LpUWrBWDmJc0wSyky5Dgmjoj2u6Z5rHpBpXShVUaOW1UHONYIBaNVGf9EXOPyfScb0MZ+k5N80DJFqwbMSkwvezIPiFxyN0D50OHYjtYrhl/dbFbjCa1Uhe/h3Cv8Mp0N2Lqqwahqfwz2thQdro7DYZwUbMf8/PxZJQ9F/xez9WQ3VfWpp9dhFb7gGWM1FtCyLooBcfjzaeJoq1gtkFzvUR312FpJdx/G5IBkqzr+Z970yygVY38zC0IZPROL2c37uSBnLfv9mZRCeOJa4G8kYbOl6dB88wMfB4V/XojiJoEh4HF7U8VyhC9yYJAYqrp8FjPXyx+XBH9CCqIzM0MNysnRMiIP37b+zNrWO+iVAntJqW6eSkfEBi5GpOxBUhf1ooP7+yg60f4I2JHyfalAgYU9CbfgSTcLZl4/SwazxEh5amTYiYh/pF/jlu+8kNaW6faGR4M44lWCk7xi1PfRoxtmKNXzNuT7dShl8heQHjsDD2Ya6OZbX5H7qCFPfgVtXNgSFb/fQmoQVsn4AZ070Iiwa5THuPIU1wI7NJnLJCTQykI1JOVvJuL1htS/wLQVawY2LMagH4hIqcPf4Zm8ZlnG0eSw1xLbFuQ2nkn+urSuajZ9Dw5Y/SuTwqh4hIH7NgMOtj2c7HDFGvmNe6FgmfzrCTdWMQo9PC12RLd+JVQzdMQDAoC3oHvI7fBmtmcBSjPgrA14LQcBDuJ1ICJh0Vgb3U373DthoAj0kF0FrOurvT2zCvlxtKNzbO6OCRryko3mGg8TA1GWLpYf3XSMOu5B17nq5GXnWvbN67XNyyqEA+lwtTKiVfgrN77SLXERuu4bVTtFUTlEN6sL
 0eLcz6YY
 n4jeNdadFsSAq3OaNW92rvCOwmZn1JB7JykH2hTSvKHMTeMy5Yev8w8Sr0BJVRZIRCOTV1leNosK4mknQV8LH1rlHTQpAEKXpE3lQSV3sHqSRPO5cqkBOrdjhFFsU1vFvgnburMbbMmunWdWkWvTG9qblLHcNRe8V5thuZatlDKJV5gRah1JrjAFAkD3bZd/sFyJtJr33EUOu5xiUmmAX0WdmGERJRGHArvwH5xfXZ1E2hyvtjtnuVj8oUhIaoI8x/ZAFgyk6zS7CH5nlsZKU7oqJGZLH03Be/E82Sc69piWQYUAVHTCgzkXCKg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/12/26 08:25, Baolin Wang wrote:
> 
> 
> On 11/12/26 6:00 AM, David Hildenbrand (Arm) wrote:
>> With a folded PMD, pmd_addr_end() simply returns the supplied end.
>> folio_referenced_one() can therefore walk past the PTE table when
>> checking references to a large folio.
>>
>> Folded PMDs are uncommon, but can occur even on arm64, for example
>> with 64K pages and a 42-bit virtual address space.
>>
>> Use pte_table_clamped_end() to clamp the range to the PTE table and
>> VMA boundaries.
>>
>> Fixes: 52e054f71840 ("mm: rmap: support batched checks of the references for
>> large folios")
>> Cc: stable@vger.kernel.org
>> Reported-by: Chris Mason <mason@kernel.org>
>> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>> ---
> 
> LGTM.
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> 
> BTW, the 'end' calculation for the batch operation in lru_gen_look_around()
> could also use the pte_table_clamped_end() helper. But this can be a follow-up.
> 
> end = min(addr | ~PMD_MASK, vma->vm_end - 1) + 1;

Cool, can you send a cleanup patch? I'd pick it up once these patches are upstream.

I'll move these into core.git today, so you can send against that for-next later
today.

-- 
Cheers,

David

