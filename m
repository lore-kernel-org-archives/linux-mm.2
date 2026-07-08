Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE332C43602
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 11:27:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B366E6B0099; Wed,  8 Jul 2026 07:27:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE7106B009F; Wed,  8 Jul 2026 07:27:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D5E16B00A2; Wed,  8 Jul 2026 07:27:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 71E366B0099
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 07:27:32 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EF9EF1A0690
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 11:27:31 +0000 (UTC)
X-FDA: 84965383902.17.36DDA63
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 27F3BA0002
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 11:27:29 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WeA2TjZO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783510050;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WCITo97BRAwUAgNXf7yXjLGVzL4sSosjVSJUHqOrMhw=;
	b=I3/9erT1nW/g5paeK0SA4YGzrgHmsxBASUShtUJW8pH06XqJaKilGFqxHOxap6fV3eXh/Y
	28e0rPaldxgBcUqAxzzhFGT8DUfg8ijpke++9+QvqKP7Xn6LTQ2ZKtw5f6bXVxi2SJDW/9
	om+y2GGvDw2XEo0rPME+2BTHY+qZlC4=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WeA2TjZO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783510050;
	b=A0/duSWffB+BXMy5B3dxqIFY2O7aLruOR08Bc4z2EqFi4kb1eQwwbbZEYjEvhT/sKzx/tf
	L+BL7x9vVXWNciuxXPFGTHPsa06IzlYD6ywizKoICfvvNSy6JFZ+8LxYgISl4GChBUoil8
	RkhUMea17NWsuYXe2CyxsQhJ9zCefGI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 18EE640884;
	Wed,  8 Jul 2026 11:27:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E0DF1F000E9;
	Wed,  8 Jul 2026 11:27:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783510049;
	bh=WCITo97BRAwUAgNXf7yXjLGVzL4sSosjVSJUHqOrMhw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=WeA2TjZOe252OirCjUywfqcZhOukVCQvwiAHJtWHyVmFUAAtqWOmcQZgciXa8JJrJ
	 q/ZBtuLQ3sNNx1VLbeZPq6wV7PV5Wz2B64GalSZMQsyPA0aB5RJUGXkAnE9MIGCRPE
	 xijPvXqEOr4SkaBWkh1OJyozMqeUZBsQyG6B7TCiAscSEvRRQECcXBqtnU4Vb6Av/n
	 NjrqF2kLUdV94fv4YvI/U3uXlRanXVi9JbtmBQc9pB5hW+Dpf04+9UJovjOc+ThTJX
	 v3bkXiNj6AcRzN9uWUBdNo3wdep5gkAbgNt3mn7ij0zoXWGpxR8KuwR3c9Zj2CCucG
	 IkocKl/ql8Sgw==
Message-ID: <76f24730-46de-4583-9189-ff7ba28c741d@kernel.org>
Date: Wed, 8 Jul 2026 13:27:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2] mm: Standardize printing for pgtable entries
To: Ryan Roberts <ryan.roberts@arm.com>,
 Anshuman Khandual <anshuman.khandual@arm.com>, linux-mm@kvack.org
Cc: andriy.shevchenko@linux.intel.com, usama.arif@linux.dev,
 hughd@google.com, willy@infradead.org,
 Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <20260708032824.969752-1-anshuman.khandual@arm.com>
 <25cde246-540f-4ab4-b541-0b7313c57954@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <25cde246-540f-4ab4-b541-0b7313c57954@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: fe845k3j6j31op93ec4uy8gsnk3ubjgn
X-Rspamd-Queue-Id: 27F3BA0002
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783510049-60086
X-HE-Meta: U2FsdGVkX191MciVXiD7VfK24xXSo9rV/I1mO9xMlJUVLqDWnlbrprB6/4RDRwVboEgKqQDLMNne7wj4MBbsS61MBqph9yFkhqrDY0omi6iaZEFh3tDmSEHjjzNGyqyM+7XR+/vJyD0mXqwzwdGSi5TjjfrQ6mPTwEKWYxIQQ0rgBjwbEvmtMUsAvpIYQP+Xqs5oMYYPXTC2h+hf104nTbqIYvhP1ebC04WXYC+ePElmDYMVsNOTV6tNiCCKXrL3nfltfxKtBcBDdYVFpf16lhr3thuJPQ6cOAx3BJBvYQBpkTXK1ipeI1W8mly5ONsnzWDhxvSt/LILLQk/GWp08S/nyPF4mOvx6wSkj9Q1rInRi4hNX23DBSoJd6nwHCjkNpWaZS7bhhrdWA0jngwhssYbp0me96uvJNSlP6NYcHzuEo0CpRzb8nIIlTva2MZbbaWyoY1rm6ACyEpz/YWPHaB5p8eHRmw46ss/wBWvpFAHH8F15tWGZCz0O2IT/wnD7mK+E+NR9pvanz9+NHySmYW+I2JHcXRTXUxmufoUiJ4dy6jVivtI1fVRBa06oUNA1sP/t9wV6Y1Q2Vc3EijSPdjrfVyCosdhsHQwaAfKIGqTOeA5F1mlbUVaLDT19/cQU5Vfqa5Qs4h1mGFqhXeK028JeRObfzFONkn30lAhEo/nuFGDNKNpcJRWCRLvENwkPOucV0Ra2AqHrq/2LsHwbQNBMd/tVLzyfV5o68iysHGyrXKWSAMc4DC9b7KeswCXOqWZ+gji8N2C1BI7QJqnHIF68u1WuWLat9tklMButlsYcNTSJl0mqcEHK7qq7yRrl6+Jo8Vh+R3RnZf2Rj2lLrXl0y9fZPOUgkRzH1HVdu+eKsVa9+hRNiWsUbnbU2Yzst1+xlCAkGKNGL0Bhv437cX0Vd8PJye1NgRCBBlVVvCbAZOUlLcoEiZ3/+Ew/FxraMkJ33rC+kTjaYaciPL
 3cpK0BZo
 LdyktSiySdnr8FwozE/4WB+NAPfnhHdfZU2Gtt75kGkKJBwSRFz9OEUaE9nJbtd79M1jq7F/bzkL5OS2mAxj+rrqOyJ4quYw9J4hfxS7vqP/0J0bvjKKDBGwt0v6bk69tDHgPTOMjn/hvtNxCIhq5Lne98b+xgi8WaIu+dJWg1SIkXkEBI8dGLG7t6Mp+zSKgjZUjINQbJJxv/7e2lhNQXlxmfDy0IcDE3EWnZ+mmxsHjembdtUJfzMiY3RToKq9JIIWoYrrz7WVm0xRe3vJCASHcSw1xZ4chxpE2eKeJ/KQN80KbrF5GtRV03stUlW8RLzBSFzOa8EDJew9abY6dkLBMVarVBhRhudeLFBowvWLZ6nrYlcxgizwgjYRItPs2yNz5mQbpfvyT0dtjY7dfXCSokRhLsYZEZdtLCaLsM81YLrBXknkSpSuKmsgpVEdtEJuMdZrglcheVtc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/8/26 13:22, Ryan Roberts wrote:
> On 08/07/2026 04:28, Anshuman Khandual wrote:
>> From: "David Hildenbrand (Arm)" <david@kernel.org>
>>
>> Bad page map reporting currently stores page table entry values in an
>> unsigned long long and prints them with fixed 64-bit-oriented format
>> strings. This is inconsistent across call sites and does not work well for
>> architectures where page table entry values are not naturally represented
>> as 64-bit values, such as 32-bit or 128-bit entries.
>>
>> Introduce a common helper to convert raw page table entry values into a
>> fixed-width hexadecimal string based on the actual entry size. Use it for
>> bad page map reporting and for dumping the page table walk in
>> __print_bad_page_map_pgtable().
>>
>> Pass page table entry values to the reporting path as raw bytes together
>> with their size, instead of forcing them through an unsigned long long.
>> It keeps the printed output consistent and avoids truncation or misleading
>> formatting for non-64-bit page table entries.
>>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Cc: linux-mm@kvack.org
>> Cc: linux-kernel@vger.kernel.org
>> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
>> ---
>> This patch applies on v7.2-rc2
>>
>> Changes in V2:
>>
>> - Dropped space after ":" during print per Matthew
>> - Dropped CONFIG_CPU_BIG_ENDIAN per David
>>
>> Changes in V1:
>>
>> https://lore.kernel.org/all/20260707041703.658021-1-anshuman.khandual@arm.com/
>>
>>  mm/memory.c | 98 ++++++++++++++++++++++++++++++++++++++++-------------
>>  1 file changed, 75 insertions(+), 23 deletions(-)
>>
>> diff --git a/mm/memory.c b/mm/memory.c
>> index ff338c2abe92..a2b63af82792 100644
>> --- a/mm/memory.c
>> +++ b/mm/memory.c
>> @@ -519,9 +519,48 @@ static bool is_bad_page_map_ratelimited(void)
>>  	return false;
>>  }
>>  
>> +#define PTVAL_STR_MAX	(32 + 1) /* Max 128-bit value in hex + NUL */
> 
> Not sure if it's worth doing something like this?:
> 
> #define PTVAL_STR_MAX						\
> 	(MAX(MAX(MAX(MAX(sizeof(pteval_t), sizeof(pmdval_t)), 	\
> 	    	     sizeof(pudval_t)), 			\
> 		 sizeof(p4dval_t)), 				\
>     	     sizeof(pgdval_t)) + 1)
> 
> Would probably save stack space for 32bit arches?

Do we really care about that? This is about a corner cases error reporting right
now.

> 
>> +
>> +static void ptval_bytes_to_hex_str(char *buf, size_t buf_size, const void *entry, size_t entry_size)
>> +{
>> +	if (WARN_ON_ONCE(buf_size < entry_size * 2 + 1)) {
>> +		snprintf(buf, buf_size, "overflow");
>> +		return;
>> +	}
>> +
>> +	switch (entry_size) {
>> +	case sizeof(u32):
>> +		snprintf(buf, buf_size, "%08x", *(const u32 *)entry);
>> +		break;
>> +	case sizeof(u64):
>> +		snprintf(buf, buf_size, "%016llx", *(const u64 *)entry);
>> +		break;
>> +#if defined(__SIZEOF_INT128__)
>> +	case sizeof(u128):
>> +		snprintf(buf, buf_size, "%016llx%016llx",
>> +			 (unsigned long long)(*(const u128 *)entry >> 64),
>> +			 (unsigned long long)*(const u128 *)entry);
>> +		break;
>> +#endif
>> +	default:
>> +		snprintf(buf, buf_size, "unsupported");
>> +		break;
>> +	}
>> +}
>> +
>> +#define ptval_to_str(buf, val)								\
>> +	do {										\
>> +		__auto_type __val = (val);						\
>> +											\
>> +		ptval_bytes_to_hex_str((buf), sizeof(buf), &__val, sizeof(__val));	\
>> +	} while (0)
> 
> I think arm64 code also does pte printing, which you also need to fix up for
> D128 support. Perhaps this could be moved to a header for reuse?

We could do that as a second step, right?

> 
> Also not sure if it's worth returning buf so that this pattern would be possible:
> 
> char pmd_str[PTVAL_STR_MAX];
> pr_err("pmd=%s\n, ptval_to_str(pmd_str, pmd_val(*pmdp));
> 
> Although perhaps that's a bit busy and should be discouraged...

Yeah, let's not do that.

-- 
Cheers,

David

