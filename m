Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6427DC98302
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 13:54:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B7566B0088; Wed, 23 Sep 2026 09:54:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 568866B008C; Wed, 23 Sep 2026 09:54:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 457D76B0093; Wed, 23 Sep 2026 09:54:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0A9486B0088
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 09:54:48 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8B35B1C337D
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 13:54:47 +0000 (UTC)
X-FDA: 85245172614.30.6B9CEF0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id BC71E180005
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 13:54:45 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nYvHCK00;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790171685;
	b=L7BCz3WL1urLoP+BlG7o6atlvPe3U5E1SRJLvH6zNpalsNY4ui8/o9KdF0B7ere/30yXQU
	zeGHfuj1Wqpap3viCw5+by6jQ41M8CvTgrQHELtAondUstqpSOKWTdkFeGEo9q1DtpM3Vo
	ckd656dCIk8IA6vV/a1CGUQnGglSLds=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nYvHCK00;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790171685;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lV+u7ZikXuhz6S/aX/agfwlx8ZCGacyG0jw47bgroto=;
	b=YFCA9RmKkMgEl47L3ut3T2UDGvqMXHftZuG1MTVGhnq6Ee+le/1UHAFjaRJJzqDAPVgUfX
	pIv6zrkCOV8A8GjKObJ/VFE8N/12lfMnjqG8fBMD0xkdQC84JHM5bVwftHjPy0lp9lboTY
	hV9F2QKO4Pwiw6syI3fYviEj3ewOxyw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E77C4403A4;
	Wed, 23 Sep 2026 13:54:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F5D41F000FF;
	Wed, 23 Sep 2026 13:54:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790171684;
	bh=lV+u7ZikXuhz6S/aX/agfwlx8ZCGacyG0jw47bgroto=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=nYvHCK00gse9lc8Gx/Mov2CNFiG+zwZQHvXDTyOyRVnDEZ7e/j+dBt4VaW492ZGkp
	 hpxR+G1QWZhj0OCGcyUJe3NS+dPfIOz58dyG8LtXFDK+CVfY1Ab9PrVbLAfE0A3Si9
	 muH/fQOeqkwXuhVgU+lv4cmT03OdPxLxwo8H6Cqb+/WGhsMFI3fPbi5/wG5OjrK/np
	 Gy5y45GHFTQJneDnyD3kQM9yg8Dez91ESmEcAYXsc92m5ei+9Y79Q6cQfeItsn3lud
	 18hXNzMMc068k6FgYejJd6kei3cViLgDhMmavBGFCShROmYqJ8Ih/IOgqRUkaahO+d
	 1NG6zA4/bxbqw==
Message-ID: <cf3aede5-62d4-4f93-b415-7498f84a20c2@kernel.org>
Date: Wed, 23 Sep 2026 15:54:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] kselftest: mm: fix intermittent failure khugepaged
 test
To: Yeoreum Yun <yeoreum.yun@arm.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Zi Yan <ziy@nvidia.com>, "Liam R. Howlett" <liam@infradead.org>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Shuah Khan <shuah@kernel.org>
References: <20260921-fix_khugepagd_fail-v2-0-3c2877beef61@arm.com>
 <20260921-fix_khugepagd_fail-v2-2-3c2877beef61@arm.com>
 <6cc12fe6-4f2f-47b6-b821-8a507eb80b46@linux.alibaba.com>
 <arOv_EFOPg0HwBk5@e129823.arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <arOv_EFOPg0HwBk5@e129823.arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Stat-Signature: 3t56f3dj3htyp6nx58814ph9xyeisheg
X-Rspam-User: 
X-Rspamd-Queue-Id: BC71E180005
X-HE-Tag: 1790171685-910091
X-HE-Meta: U2FsdGVkX19ybDfi5NkqyZmKBFS4cvo4IR8wCKEISFAX8zdazRwddszodb1Ryoypi8GubdnRskDZKh7AgIW22ckOCTc/CN9MYP635b2cyurlwUGAf8R97DpW1cKKuHyQhuBytme3I8IBsACgbUHZnMBS7do3DyvspqcVLs4RQFmde8qVClueC4Kvo0IFZIf9F9Ha5VQ39w5HVOQ+MUhIq6V+bWQlaVof5XAgd9mrb2pVm+nRJKG4PMuRr/U223Ipi1ATLkJe1jKUAz2anpKOlg5NuqJwbCgKCWl2mXHFadqjX6KYg3fcPtgmJSh33DK2vzxaHUTPkQHfvhiZ9iz1KEiQ3HPrz9QvI8QjCFYRoC+sWdryD02Cy6mUndU4jjINszqI7Q9d1w7jiedIat2EnNw3yW7UcXVQcqcNM7sdgQ6AnHe5RBa1iLlmAgtKBv8Cgy3b0raCcHlwxwGRA+jhZfM5IiH3c/hrvvd4tPlEy1/RfOeE6kj9u+lSrGYbSsNMgu2Fmxn4Z0hyFBNig3OZwyw2M/+DVAt0OngiNASm+5LhppnVyiawJL2Y3kacqMfRgOtkV0Ef2kcSPu6YDn4+bFV+88/KyYVyRcaLeq+jqOTt7FjMuQ99egZO1JTcsACCoT3Q5kpime3h50PYf8ytvwwlvd3695zphcWJT/lnrlGVXq1EC0/8VPQqYVdYNqlTbblhVGvwWQgjPCrkk6M0QoE2fd7rItyHWdoWl3jT9LJPoIlz0lHA2EePuAiIEExpX2MW2z5/BEvib/va+VYjg782Pbhh0AKnvaSuCyLtMiVOG3mj1ZBIss2QHXzZ4iGQ4VehYce5JGgH8O/BP7nj/bsEeu54y7fPVvLzrMF9BfXQxs+jmovtU7oz7qBfu5kgmuHHe9A29Wq6DbxgSuprrQHjT493+jw9PGjFtUeiJ5GlBxp9OUXhrNjKq0qbBbccvS0baYQE/DCrjKUybrA
 7iaJWI6b
 qnCkRTcKzeae2zrCQpAS+w+hLcYrBjl3jFYNn7iFkcGodZmzZ+ANEdp+rQ77NTXNhqHcAC3g4++kbYqRimAUm2s0z3bIDdzQg9n7ph06GgSPmv4gxW1RcaHRUEmwo9PlIvtjkVtEMG1nyyG3seHk2YwTmzTPZVAfVqlY/spSfROB0r79CdTPa8tU+pz1CmN9+eivls7us+DelzN6RRYZrRHf303IB019KT1sTkxJmjUnhHawjNceovN+vt8HT/Q/XM8GLxLL7bmCdQqHCqgOynahO0e1HeW3wK0CLA0l7tPhf4jULwCLKiZTql/YMUZ9+BLVRmaH2OpiCJHPxbKvF36CCyw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/23/26 12:54, Yeoreum Yun wrote:
>>
>>
>> On 9/21/26 6:35 PM, Yeoreum Yun wrote:
>>> There are intermittent failures in collapse_max_ptes_swap() and
>>> collapse_max_ptes_shared() when using the khugepaged_context:
>>>
>>>    // while running ./khugepaged -s 2
>>>
>>>    # Run test: collapse_max_ptes_shared (khugepaged:anon)
>>>    # Allocate huge page... OK
>>>    # Share huge page over fork()... OK
>>>    # Trigger CoW on page 1023 of 2048... OK
>>>    # Maybe collapse with max_ptes_shared exceeded.... OK
>>>    # Trigger CoW on page 1024 of 2048... Fail
>>>    Bail out! Unexpected huge page
>>>    # Planned tests != run tests (26 != 23)
>>>    # Totals: pass:23 fail:0 xfail:0 xpass:0 skip:0 error:0
>>>
>>>    # Run test: collapse_max_ptes_swap (khugepaged:anon)
>>>    # Swapout 257 of 2048 pages... OK
>>>    # Maybe collapse with max_ptes_swap exceeded.... OK
>>>    # Swapout 256 of 2048 pages... OK
>>>    Bail out! Unexpected huge page
>>>    # Planned tests != run tests (26 != 17)
>>>    # Totals: pass:17 fail:0 xfail:0 xpass:0 skip:0 error:0
>>>
>>> This happens because khugepaged may collapse the pages before wait_for_scan()
>>> is called, causing a sanity check that expects uncollapsed pages to fail.
>>>
>>> For example, in collapse_max_ptes_swap(), after faulting the pages back in
>>> and paging out up to max_ptes_swap pages, khugepaged may collapse them again
>>> before c->collapse() is called.
>>>
>>> To prevent this, mark the VMA with MADV_NOHUGEPAGE after it has been
>>> collapsed by wait_for_scan() for anon. This prevents khugepaged from
>>> collapsing it again before c->collapse() is called.
>>>
>>> This failure was observed on NVIDIA Spark with 16KB page.
>>>
>>> Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
>>> ---
>>>   tools/testing/selftests/mm/khugepaged.c | 3 +++
>>>   1 file changed, 3 insertions(+)
>>>
>>> diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
>>> index c32244b565658..1aad4bb427ece 100644
>>> --- a/tools/testing/selftests/mm/khugepaged.c
>>> +++ b/tools/testing/selftests/mm/khugepaged.c
>>> @@ -578,6 +578,9 @@ static bool wait_for_scan(const char *msg, char *p, size_t len,
>>>   		usleep(TICK);
>>>   	}
>>> +	if (!strncmp(ops->name, "anon", 4))
>>
>> We usually use the 'if (ops == &__anon_ops)' check in this file to identify
>> anonymous test cases.
>>
>> With that, LGTM.
>> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>> Tested-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> 
> I think this is merged at mm/mm-unstable already So, I'll send
> another patch to change it with is_anon().

Unless it is in mm-stable we can reasonably squash stuff or resend. This
shouldn't be an independent patch.

-- 
Cheers,

David

