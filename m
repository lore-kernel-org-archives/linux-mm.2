Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5221C87FCB
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 11:42:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 793476B008C; Fri,  1 Aug 2025 07:42:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 741F16B0093; Fri,  1 Aug 2025 07:42:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 630676B0095; Fri,  1 Aug 2025 07:42:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 545286B008C
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 07:42:44 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0035D13530E
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 11:42:43 +0000 (UTC)
X-FDA: 83728001406.10.77D5196
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf09.hostedemail.com (Postfix) with ESMTP id EC621140012
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 11:42:41 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=heJOV96L;
	spf=pass (imf09.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754048562;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=momi1YfOHTpFLGKMVxFm/VGFaTZTo2hyfea3bMFo1dk=;
	b=zVbNrM1qDfgj7lmMu2CGJnRM6pKFA5GmH+FGCtZFIuMniNHDvdCvFymWszz+STGXdZTeOp
	Tiv7qk9zCf+FFtPS1s/LgfqZ4wB10nVtx2TqzuCNQoxQojxbpouXPNmIgMmjIzQmP21yG/
	4Fzo/YrUas9kPUvNE+og/pw3q0K1SZE=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=heJOV96L;
	spf=pass (imf09.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754048562; a=rsa-sha256;
	cv=none;
	b=1V3jaFXViIG4EvNh+gwAsYGXWPICydPvNXDZzlC1cE35ohWO1MGhiEKij4g23c/72GVlVk
	Y3lyy5fB+2fwblxkIBTpMDdrdbO0bvGgEC9sv2zHdzoHGM2Rq5sXZDFccJ/5Vj1PSP4jvJ
	Gh4I+MvCEe4xl9qR32wWVcoAompERbk=
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4560add6cd2so15358625e9.0
        for <linux-mm@kvack.org>; Fri, 01 Aug 2025 04:42:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754048560; x=1754653360; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=momi1YfOHTpFLGKMVxFm/VGFaTZTo2hyfea3bMFo1dk=;
        b=heJOV96L/tShWt3SR9wGlf3okx/ybtlZALSqtCzdqEixPC6UBFSvUX1NlBwQTl/YgF
         wMTxwHAlb4jJL9vpHke2U6veXjHBSwYCY6JQuJsnjaSCrb79g7ZE+fTWYtM4QQ2D2RvD
         vRxnbco2ALQwUNZEmuYmfW0T73HflvUk4p/1rR2SyCiO/GTOsEXDDZHmGEI/dM1iHJ2O
         O9dxUMMUKwW+SpYYuww3nG+D/tLAuFSCkbqQsEeUXT7dZGPKFLGi/TZ+n2Amsl/F0F/6
         5Y8c6AdWKiEfera6fYogHR+STRbLBKyepRMZQzMuP3iItVDWW7v2/wX/z9TdIpKDtYzQ
         q7+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754048560; x=1754653360;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=momi1YfOHTpFLGKMVxFm/VGFaTZTo2hyfea3bMFo1dk=;
        b=cKvaETPhLqTgOv0WCqptZ2kMtmM1N38BoSDac/X0WPtljx7gxQeuR/lVdZOgeDWpaF
         sOgh0lHtyVRGJup2WiOzikkxKaLjQr+5TXyUuIKtxbSQsUhHf6n2UJTxbAEAqO23fLzq
         l+dSeRzqQUHVXV4BmaUlJwY7XOJHhgW7quO9lAg1WphFHWd1IxQWNvum2CiHqiGXFIzl
         lrpN9RLKgwYl7EFgleSsa1DPPpDKi78OFbMBkBqpPtqz4E4ynBsqPWfDScHearyJWAIE
         /tKQUeu1r8Is6JNZe+bFZuaaD/E34pDJJ1MqDAxSfgyHuK0RsQqnTDTP9CkkO0dZ4jQE
         +9Bg==
X-Forwarded-Encrypted: i=1; AJvYcCXD6nV18mTmTTVb6GCV11V+rNCazCc5HxFdu8aztTOmwDIqBl8xqCe3LQSC+ZTefReiezK8HT54Hg==@kvack.org
X-Gm-Message-State: AOJu0YwrwhRRgndQEgwM2CjMQsrDVbaMMTBU5qj29K4Jfj28aYzb63hi
	rNfnDqBTeyIX6SxGqb4l6ecpJiAjYT2ki/fjWMsq0WqtUQl245Efnpq0
X-Gm-Gg: ASbGnctbGAjK2mjSlmx7HPK7Pa9FB3pVXWL8VDTNv9txGozl5f+wMsCrHbYHO3jiMIf
	5pfmMZYbgYdWzaLI1fDHONHQdehmaxoJAoEvzl54F5ETAtYBCxdaTHOKn3fStw/KZCzaOQ9XhJ1
	6Lv2PvMGBEWQRtt7dTnx9CfV2lh0T6CQPXi0uawegcTKY/aCfUNuh9vWX1MZaDH+6WpH6c/N5gX
	Df3tM4CREiJmsxnQCQqlaWRbEh5gUYdoL0OJU2RusrSaT1U5oU3z01r7h2ufgY9MY1DVi0Zw1TW
	3UDYU7Brif2eHxIZD2AUmYIZttr/UvTpYTFwe3pvoLRmzeWoy0E/tn4ACMhMPgVvMki2q69Y3FY
	iHABSTe1WAmPNGoKHUjaOlN3Q8Bw3/Mfj3hGcEjH8XeIE0AmBDFehzfTf3j1+X9Ejft7rvtFfMS
	mY1InOrNqzSxCbrFWMXEto
X-Google-Smtp-Source: AGHT+IFHDY7W3Ce5xcLtfL4XnnwU/a+0HjPBHBzmVsYbShhebd7Z21HrXzs3mc/awIMb9FyAT2pj+w==
X-Received: by 2002:a05:600c:190a:b0:456:18e:eb7f with SMTP id 5b1f17b1804b1-458a1e0bf9emr62743245e9.3.1754048559998;
        Fri, 01 Aug 2025 04:42:39 -0700 (PDT)
Received: from ?IPV6:2a02:6b6f:e759:7e00:8b4:7c1f:c64:2a4? ([2a02:6b6f:e759:7e00:8b4:7c1f:c64:2a4])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c46ee84sm5508760f8f.57.2025.08.01.04.42.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Aug 2025 04:42:39 -0700 (PDT)
Message-ID: <22e263a3-a1d2-4159-b3c8-44f7a29bace9@gmail.com>
Date: Fri, 1 Aug 2025 12:42:38 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/5] selftests: prctl: introduce tests for disabling
 THPs completely
To: David Hildenbrand <david@redhat.com>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Cc: linux-fsdevel@vger.kernel.org, corbet@lwn.net, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, hannes@cmpxchg.org, baohua@kernel.org,
 shakeel.butt@linux.dev, riel@surriel.com, ziy@nvidia.com,
 laoar.shao@gmail.com, dev.jain@arm.com, baolin.wang@linux.alibaba.com,
 npache@redhat.com, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
 ryan.roberts@arm.com, vbabka@suse.cz, jannh@google.com,
 Arnd Bergmann <arnd@arndb.de>, sj@kernel.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, kernel-team@meta.com
References: <20250731122825.2102184-1-usamaarif642@gmail.com>
 <20250731122825.2102184-5-usamaarif642@gmail.com>
 <7b13d8b5-a534-47f8-b6c5-09a65bffc691@redhat.com>
Content-Language: en-US
From: Usama Arif <usamaarif642@gmail.com>
In-Reply-To: <7b13d8b5-a534-47f8-b6c5-09a65bffc691@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: k1srnz3iw6r9i4inb8cjdmatburcrz35
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: EC621140012
X-Rspam-User: 
X-HE-Tag: 1754048561-785107
X-HE-Meta: U2FsdGVkX18QsVD7ScLLXAkyKhTBZ6E+j+AVVzgfKp5BUwGMAf8r4wiFFnAyZ25cZ6RZVkcNiF8kJ4Wy++KJMnHmq2zH7+BpG5TneQP4MkYzElnxXItcD/ghKopGSRLtCqOgm30fhjv/xYh6BFs5t4YBArLAhJokZJRfdV1alpPXx6F2rZ8lX+7sIUcwTorWeljfAN3M2r3M4NzLeB1qXTj0jphLkmFZGhmC8LBHjWv8lUsa8KQAMGlgo9zoy2TE9TXqw11HcxhLJQ/b8VuTYMnZBdechchIJ9cq7Pz4i8qkHuyot08SLwZ+Rp2OwfaeR7x9+r2sW8KUPs4IecBFglnkO4gXseBIkrZ+a4HIN9zGSwTdnejOoQShXiHSCtEHo9v3LNuZYOfiDdBDwbWsJUE50NLS4aTVHzc0cBq9BDp1poAIceDds7Q6zO6vfSCJzB/Ocwdn/Se1b7JO65cdhYyWeZ7cb2mSsH2zwc7n63sWPWernIvKUbGPfaLkrgT0nGUsqg8DbMcTIxO4BYbPjuNBZyrnJ1OVUSTx42jITr7TVPBHZJ6a9iWMI3euNDDq9zvxLAVTylQxv2IA7pY2d6bDe4P/UifezL+m1fumPysoDM2SdUqJnebAqHBoKhB8Vo/UkjbquDe+uAEBiK3vwDeQI4ytQ/GV3d++p7EUw7yV2XbC+VpXvdUaZH3xtOPDLDeoBR61Z9PdDQNAucdNwmGAkmuusDz2SPsIJDkT2Jxmec091bXd3o5DNmT9i52MEvCYHnYpYyV2ULBRZqJ0mIpMCjvXp90QnHNYCtgyfB9ThJ2IqSUHfTNNK4tmvr9tgJG9/s+Z0LMQ3yp2brmOtEe+xOESwfZLUsFMugn0JseB+SmGKx6xPA2GDhGXhvRgz7sD74no5huMEniHSH9rxaGIiSXcAUYDoDC0cwtoukx7Rhz60kS/AUb0Fg9VMjjSJ+j19TVF0GmfvRdXId9
 /ui8kYIb
 afid+EK1SAkmCZGvIagjW9zwAVh0iv37mECKdD0rwDQgr0qaGc1ooOVP8CrERVEgWAAsJrdrm05OZrsX7IkaLdxFuKWbfzZ621lJoWWX8IeNDMgJe6y3EmI9weYyFolmUWuB+DJBKEu2Tj5I/pk7f+D/wzryKdPppf05Z4f6NiPS617s7Vfqj2rQPGy37ygC2g5kS51+t/KAhNxYnR5yyx+Gx7nJb+Rfxae+mB1NHw5g1jK06+JO5k+GNp1YYlzuxveED/S/S02Gxcz4+5JANmaaRxMwM0gL/w6utFvHtx5lZzxi0cBuaHoPbdV+jPmlgSRK2dl4Nwi21M5gwfWRaTel6sVALKFEI0UQpbbUHPCOE6LLMsw/b4inUlQsPpBTJEnvADvx9ObUN754E2iO7SD64iFaXhPYWuqGTD+Ww/saEwVprmiPThbg/a/Znytikb71ODNfR3QjN6GHhqI5dH9MEktoEZVQ9TLLJg5HmyzAWmWE1qHIgNHdIRT7szqTgx683tvWeQf86rdCsIHo8HQNzEtElF8aZfrhQ6FYoDHDVu6diNVxvgwaem3tA0SflVX1he5QXQbOpOKNmOEroTv8sKQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 31/07/2025 20:42, David Hildenbrand wrote:
> On 31.07.25 14:27, Usama Arif wrote:
>> The test will set the global system THP setting to never, madvise
>> or always depending on the fixture variant and the 2M setting to
>> inherit before it starts (and reset to original at teardown).
>>
>> This tests if the process can:
>> - successfully set and get the policy to disable THPs completely.
>> - never get a hugepage when the THPs are completely disabled
>>    with the prctl, including with MADV_HUGE and MADV_COLLAPSE.
>> - successfully reset the policy of the process.
>> - after reset, only get hugepages with:
>>    - MADV_COLLAPSE when policy is set to never.
>>    - MADV_HUGE and MADV_COLLAPSE when policy is set to madvise.
>>    - always when policy is set to "always".
>> - repeat the above tests in a forked process to make sure
>>    the policy is carried across forks.
>>
>> Signed-off-by: Usama Arif <usamaarif642@gmail.com>
>> ---
> 
> [...]
> 
> Looks much better already. Some quirks.
> 
>> +#include <stdio.h>
>> +#include <stdlib.h>
>> +#include <string.h>
>> +#include <unistd.h>
>> +#include <sys/mman.h>
>> +#include <sys/prctl.h>
>> +#include <sys/wait.h>
>> +
>> +#include "../kselftest_harness.h"
>> +#include "thp_settings.h"
>> +#include "vm_util.h"
>> +
>> +static int sz2ord(size_t size, size_t pagesize)
>> +{
>> +    return __builtin_ctzll(size / pagesize);
>> +}
>> +
>> +enum thp_collapse_type {
>> +    THP_COLLAPSE_NONE,
>> +    THP_COLLAPSE_MADV_HUGEPAGE,    /* MADV_HUGEPAGE before access */
>> +    THP_COLLAPSE_MADV_COLLAPSE,    /* MADV_COLLAPSE after access */
>> +};
>> +
>> +enum thp_policy {
>> +    THP_POLICY_NEVER,
>> +    THP_POLICY_MADVISE,
>> +    THP_POLICY_ALWAYS,
>> +};
> 
> Couldn't you have reused "enum thp_enabled" end simply never specified the "THP_INHERIT"? Then, you need to do less translation.

yes, introducing this enum was silly. Have removed it for next revision.> 
>> +
>> +struct test_results {
>> +    int prctl_get_thp_disable;
> 
> The result is always one, does that here make sense?

Its 3 in the next patch for PR_THP_DISABLE_EXCEPT_ADVISED :)

I will remove this struct, but I think maybe it might have been a good idea to squash this
with the next patch to show why the struct was useful.

> 
>> +    int prctl_applied_collapse_none;
> 
> "prctl_applied" is a bit confusing. And most of these always have the same value.
> 
> Can't we special case the remaining two cases on the current policy and avoid this struct compeltely?
> 

The values are different in the next patch when PR_THP_DISABLE_EXCEPT_ADVISED is used.

Just to explain how I came about using this struct test_results (though it doesnt matter as
I will remove it for the next revision):
I wanted to maximise code reuse and only wanted to have one instance of prctl_thp_disable_test.
I actually started with special casing, but went the brute force way of adding too many if else
statements and it was looking quite messy after I added the tests for PR_THP_DISABLE_EXCEPT_ADVISED.
I saw this struct test_results in another kselftest and thought this should make it much better and
extendable.

I have removed struct test_results and changed prctl_thp_disable_test to the following for next revision:

static void prctl_thp_disable_test(struct __test_metadata *const _metadata,
				   size_t pmdsize, enum thp_enabled thp_policy,
				   int prctl_flags)
{
	ASSERT_EQ(prctl(PR_GET_THP_DISABLE, NULL, NULL, NULL, NULL),
		  prctl_flags & PR_THP_DISABLE_EXCEPT_ADVISED ? 3 : 1);

	/* tests after prctl overrides global policy */
	ASSERT_EQ(test_mmap_thp(THP_COLLAPSE_NONE, pmdsize), 0);

	ASSERT_EQ(test_mmap_thp(THP_COLLAPSE_MADV_HUGEPAGE, pmdsize),
		  thp_policy == THP_NEVER || !prctl_flags ? 0 : 1);

	ASSERT_EQ(test_mmap_thp(THP_COLLAPSE_MADV_COLLAPSE, pmdsize),
		  !prctl_flags ? 0 : 1);

	/* Reset to global policy */
	ASSERT_EQ(prctl(PR_SET_THP_DISABLE, 0, NULL, NULL, NULL), 0);

	/* tests after prctl is cleared, and only global policy is effective */
	ASSERT_EQ(test_mmap_thp(THP_COLLAPSE_NONE, pmdsize),
		  thp_policy == THP_ALWAYS ? 1 : 0);

	ASSERT_EQ(test_mmap_thp(THP_COLLAPSE_MADV_HUGEPAGE, pmdsize),
		  thp_policy == THP_NEVER ? 0 : 1);

	ASSERT_EQ(test_mmap_thp(THP_COLLAPSE_MADV_COLLAPSE, pmdsize), 1);
}




> 
>> +    int prctl_applied_collapse_madv_huge;
>> +    int prctl_applied_collapse_madv_collapse;
>> +    int prctl_removed_collapse_none;
>> +    int prctl_removed_collapse_madv_huge;
>> +    int prctl_removed_collapse_madv_collapse;
>> +};
>> +
>> +/*
>> + * Function to mmap a buffer, fault it in, madvise it appropriately (before
>> + * page fault for MADV_HUGE, and after for MADV_COLLAPSE), and check if the
>> + * mmap region is huge.
>> + * Returns:
>> + * 0 if test doesn't give hugepage
>> + * 1 if test gives a hugepage
>> + * -errno if mmap fails
>> + */
>> +static int test_mmap_thp(enum thp_collapse_type madvise_buf, size_t pmdsize)
>> +{
>> +    char *mem, *mmap_mem;
>> +    size_t mmap_size;
>> +    int ret;
>> +
>> +    /* For alignment purposes, we need twice the THP size. */
>> +    mmap_size = 2 * pmdsize;
>> +    mmap_mem = (char *)mmap(NULL, mmap_size, PROT_READ | PROT_WRITE,
>> +                    MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
>> +    if (mmap_mem == MAP_FAILED)
>> +        return -errno;
>> +
>> +    /* We need a THP-aligned memory area. */
>> +    mem = (char *)(((uintptr_t)mmap_mem + pmdsize) & ~(pmdsize - 1));
>> +
>> +    if (madvise_buf == THP_COLLAPSE_MADV_HUGEPAGE)
>> +        madvise(mem, pmdsize, MADV_HUGEPAGE);
>> +
>> +    /* Ensure memory is allocated */
>> +    memset(mem, 1, pmdsize);
>> +
>> +    if (madvise_buf == THP_COLLAPSE_MADV_COLLAPSE)
>> +        madvise(mem, pmdsize, MADV_COLLAPSE);
>> +
> 
> To avoid even mmap_mem to get merged with some other VMA, maybe just do
> before reading the smap here:
> 
> /* HACK: make sure we have a separate VMA that we can check reliably. */
> mprotect(mem, pmdsize, PROT_READ);
> 
Thanks! Yeah this is a nice hack, have used it in the next revision.

> or
> 
> madvise(mem, pmdsize, MADV_DONTFORK);
> 
> before reading smaps.
> 
> That is probably the easiest approach. The you can drop the lengthy comment and perform a single thp check.
> 
> 

[...]

