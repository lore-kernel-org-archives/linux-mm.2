Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3863CD98C7
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 16:14:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E237D6B0093; Thu, 11 Jun 2026 12:14:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD4496B0095; Thu, 11 Jun 2026 12:14:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC2DB6B0096; Thu, 11 Jun 2026 12:14:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BB38B6B0093
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 12:14:42 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3BEDF1C288F
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 16:14:42 +0000 (UTC)
X-FDA: 84868130004.18.EDB82F0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 749724001C
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 16:14:40 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WFYZ4g3c;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781194480;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4ZPJ8VpwizTlbeh4MnEjVeW3YDzCQKUKA/8eV3uJMXY=;
	b=XxopZXBjkbm7tWHogc583fxBuhvqMYOiTtS1WWoAuzSznvVte1QtUQYuUBjVlkjD77nlHr
	oAI2zfIucck2UnTUgDynB1HselktCJphnHVBKck6Au73f9/p6UtH0C9u+8YLFSSeT/AXvp
	T/odccMMFsXDeujq5WRHobhLfU+Sps0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781194480;
	b=Aetyc5MyB9B8PgAy7KhTFezWuinuRnAf+imFYZ/xP7oWuoj0bBRwjNBbF/lBvKj2ToNqPZ
	s+yxvwym13sWzqRWUCHLe2f3HNtePf2oc6BR9x9yZ29gc+KaX4viIVSRf6wqXcUZCJtUy+
	7UOaf3FPpVST+gHvymwUealtJ8+3+rA=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WFYZ4g3c;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 081F1600AF;
	Thu, 11 Jun 2026 16:14:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98C7D1F00893;
	Thu, 11 Jun 2026 16:14:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781194479;
	bh=4ZPJ8VpwizTlbeh4MnEjVeW3YDzCQKUKA/8eV3uJMXY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=WFYZ4g3cimuTsAvhb4VQ5dsYIpyDMS9pJEsBFt2vFir53tbLfjvB4NfymH9AsUK3v
	 YGSjur1wcJo2Ydm9JVvvxrllso1YaR8yqIN6EKfWbwpV78dR5/UX+St9WYcmu151Pz
	 /Jjrf3KoFhKylUvsgvfIJyXXb9Fn3WyeX2HzxCypd82u8L1OeiJkZ344SFn3johBM2
	 qJ3I51ty1X8PmfGpjrwZNgBSsmqTbpJmkBrN9INVr7s1VFaq4ADO0si3idzsO6GWwR
	 qWfauHPhKPHABQLcuhjhDDO0UtBW1qok1TPhFtaMS/s3KqjAo2PLpdZNW3/+D9PY1w
	 r9g7WLUZfafEw==
Message-ID: <e9412b6c-ed3c-4c0c-977f-fc019297d875@kernel.org>
Date: Thu, 11 Jun 2026 18:14:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] mm: cleanup clear_not_present_full_ptes() and rename
 to clear_non_present_ptes()
To: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>,
 Andreas Larsson <andreas@gaisler.com>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>,
 Peter Zijlstra <peterz@infradead.org>, sparclinux@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260611-clear_not_present_full_ptes-v1-0-49865fc82629@kernel.org>
 <20260611-clear_not_present_full_ptes-v1-3-49865fc82629@kernel.org>
 <aiq_3rp9fwFHyLwl@localhost.localdomain>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aiq_3rp9fwFHyLwl@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 749724001C
X-Rspam-User: 
X-Stat-Signature: p66ddmz6jz4kky6t3jjo5q9zwasu3jii
X-Rspamd-Server: rspam08
X-HE-Tag: 1781194480-390421
X-HE-Meta: U2FsdGVkX1/SQSq98lz2XPqqB74+3E3Dn3DybK8BeEGQx+eXupsVIiSgjlcUjbvp/NM9g1yqoE/8Mg4SvjozaPk5AB4isVUAETk61Ls7knVJl8DzDe8BtSvztFwxBPM0FPM8jkkI0SrHhHDe6YyQvgLZ5fnxTPd/vUMIp7FoVwlH5rXbHQ1Y72jAalfVdvAY60XylxrzCGDpP9/dC5j9JnrFnkLd8eZt8rONtK1kMZpbGZ0AUezXTra8pDtrRXPvejJ2OlieoAqhUvxBh4pvuIL6yBRf7PJAPkJTKsFCAvxAU14c5DU7qr6KYiUnvubHFFM6j1thQlefl+nDx4mZVXgRgBMIMvWmsbgl39+d61udJeAHcq8wH/KpQR2ysVKkSS0fGcIshLL1o13bl54I4fbN5KbfsB9+I5I+VeHxgFvm3VCmM7o3mcD6aBsoGhYN4Z3tVVWYHvLDLQsBfEAhTS3thr/Ss7IPHHYSLNSyJrl2I4qDbxNsE9veo55+v0ZbMh2q412kxcgY4hksvtPJ1tq30LmmWd4P0NA3MTNusl/Piyo7U56m3/r+cT9Qs0mwVH5hkUmyMb4CQp5kMapEwzyPE27vCcrYcP9uo3P7EFXIzsuTmaGA8jHWhmOsNwpjaFNH/hQ3TBlv7TKmSPZZWu6yXKuQA51Op3BCTKEkm0+5z51ClyTuiin1MECKQHD39P4WDtalonkjSsd8gBRs/kFQz1U0h24yeq5XT3ZTpb32nNtbI3XDaq9j4oUxSYnkc8in2V3H7HlnGPKwW/58BA0yAc+EBOuLD+ChzCw171RlpH1a/fdqSCjBb/FmDpZMRtxxna+Ael1ysl2MGHdoTIdQXi9aTJiJcczFINa0IRWc2HqhryefZUEDjIDon+e67enfWqg+8stePVcGyCoyMla3vlBBJN4eJf77t2xriJrl7ay6ZtAlcSSjxLurwc+gu6AkiJoseMVOr77lvHj
 bOn1rSTY
 xlY0qtebbg78NMoSoHSoXFkNJ3OUuQXTKtKx9tcFQ9EhSGPKLvZxzSKur59Vnfi2XuGitSSMKkyMdZ8ML+u28WgSHzAbTBTa5VMEwfihMVl/cXn3JNHCM0yXlhenLYt6+hSUGtvvk7GWsvOa5gKCUui0five+ug1fBmHdb4r+8K+DklfSWzDQmR6WRaWdA8+qOF263BAJQPt6XhAXGKwW4lCip2hx+UX8cRwbDuJm2R2s64xPE3Ih8h84cwyKIAxOEYgxkKXbjwILtF2offeZt35CTNTes93LO+9JsMMkDRVpDXRSeo8PelJCDA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/11/26 16:02, Oscar Salvador (SUSE) wrote:
> On Thu, Jun 11, 2026 at 01:50:49PM +0200, David Hildenbrand (Arm) wrote:
>> Let's clean it up a bit:
>>
>> (1) There is no need to pass "full" anymore.
>>
>> (2) No architecture overwrites it, and there isn't really a good reason
>>     to do so when dealing with non-resent PTEs.
>>
>> (3) While at it, call it "non-present", similar to copy_nonpresent_pte()
>>     and zap_nonpresent_ptes().
>>
>> It's a shame that we have clear_non_present_ptes() correspond to
>> pte_clear() and clear_ptes() correspond to ptep_get_and_clear*().
>>
>> Likely we should rename pte_clear() to pte_clear_nonpresent() or sth.
>> like that, to make it clearer that it is usually the wrong interface
>> for dealing with present PTEs.
> 
> Is that always the case, that pte_clear() is only used on non-present
> entries? Or there maybe users that do not care about the current value
> and just want it to nuke?

Usually, you want to get access and dirty bits, and that requires get_and_clear
semantics. I suspect there are some more details to the low-level helpers.

> 
> I guess that such a renaming would have to first audit that all current
> users obey that? Othen than that, is there anything else stopping us
> from doing so?

When I last skimmed over some users, they were all dealing with non-present
entries. (mremap.c, rmap.c, mpreotect.c, memory.c, madvise.c)

But yes, we would have to audit and make sure that's the case.

-- 
Cheers,

David

