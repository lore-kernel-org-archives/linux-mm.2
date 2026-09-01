Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0DFA5C61DE4
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 06:24:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E6106B00AC; Tue,  1 Sep 2026 02:24:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 196D16B00AE; Tue,  1 Sep 2026 02:24:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0ADA56B00AF; Tue,  1 Sep 2026 02:24:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DF4186B00AC
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 02:24:29 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7FE76120363
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 06:24:29 +0000 (UTC)
X-FDA: 85164204258.23.D7AC8D6
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf17.hostedemail.com (Postfix) with ESMTP id 8861740008
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 06:24:27 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="bH/tFopJ";
	spf=pass (imf17.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788243867;
	b=VZpv14o61zUwmrCMHxF3lgcW5vIx9n5nqx7wB1ijjM+1oMa5/EDo8RZx97LDWD2V87iRgy
	oWgpcC4w5OxiWai/MaAqE762sJAfWsBlRfnQ2i6OHrI5SLJ5sGTikxIXpPClh73Reh6pFj
	Kt7tiIpab5bTqO/U2xg4JYhRV6OoxXQ=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="bH/tFopJ";
	spf=pass (imf17.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788243867;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZGjcWT59oyQ1Vzf08vWDJLZw9q4Kxr/AYgzDCTJLc9w=;
	b=ElhEzCAgERSH30mKPL1EKTL0/TNQ369RBgLCX+kuidiWUyQhgHSbBbWVuqR9NJNA7SamGr
	LjgpVonJb9tYsS9Jsf8SLbOkzScZtCGuibVBgwGqLW7jXMSnIb/EFbZhVbBjUpAzqLZ/SU
	lRx+7oNX7Kpql774p0riGlSXapfLK2A=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EA2811756;
	Mon, 31 Aug 2026 23:24:22 -0700 (PDT)
Received: from [10.164.19.53] (unknown [10.164.19.53])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 40DCF3F85F;
	Mon, 31 Aug 2026 23:24:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788243866; bh=yGLpijKUnjl1pokicm77fJ/NhLlkoUbwE3wNND1awVA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=bH/tFopJqfTyFZdaC2O5krSp6aX3s4cOqW1YfXSVEx7FdoXaPlQDAuMXyICg02PKP
	 o0Nm7zjaLI95sCxwUqMzNrvLVC961DwPDaKG5yy/XqXZFrLCCihKnmxI1PdpBd9XYJ
	 c1SJppfR2ExblfSqCMlH/X3uQuTDi5m4qZGeA/NA=
Message-ID: <55e7bc2a-dfdd-4cbb-9bf6-ea3bf4b03cce@arm.com>
Date: Tue, 1 Sep 2026 11:54:17 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/8] mm: move anon-exclusive batch helper to mm.h
To: Barry Song <baohua@kernel.org>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
 hughd@google.com, chrisl@kernel.org, kasong@tencent.com, riel@surriel.com,
 liam@infradead.org, vbabka@kernel.org, harry@kernel.org, jannh@google.com,
 lance.yang@linux.dev, baolin.wang@linux.alibaba.com,
 shikemeng@huaweicloud.com, nphamcs@gmail.com, baoquan.he@linux.dev,
 youngjun.park@lge.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, pfalcato@suse.de,
 ryan.roberts@arm.com, anshuman.khandual@arm.com
References: <20260901054358.4049095-1-dev.jain@arm.com>
 <20260901054358.4049095-4-dev.jain@arm.com>
 <CAGsJ_4yGFBRv-C3UV-G1tB0HUmhVvJL6ac5x_Dtu9NSGk9BGzw@mail.gmail.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <CAGsJ_4yGFBRv-C3UV-G1tB0HUmhVvJL6ac5x_Dtu9NSGk9BGzw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 8861740008
X-Stat-Signature: r5horefzrj4zusjpet7tg58r7u6jaj8c
X-Rspam-User: 
X-HE-Tag: 1788243867-50986
X-HE-Meta: U2FsdGVkX181xynraWtAOSl44hUhwJLlSmhQksRNsh1tWhhQjUer6nI2Jb/DpH9jNB9eIQP1m+klcggL8KW3XG9G1xWv1BL/y6OAGAlk5U3/4GKlwZbIkOjyU/Dpe2ujohZl/Wd4n8cbQ8cAYtDcws/hkeJL4CEC5m/kOA1RxWTBwwXC+8u6TwmTYDp8tl0wqTleel6zab1gztglzDAfaHvdzYAaaFAttTdekR+N2xX4jBDOTMKPbPNt5KL8qQ1SB4nN/Pnp7nAsIgs1J+o72pvJ09bZhgWjJmLvLdF/XR1u/rQrCyYo0XMcYsjrUIvJNpmTMsYCwiSQSCKQ/xZjAR/niZ+v4XGn0dBKiZu8irwBTLuZZ21hzeKCz4u1vfgX7T2iEmdqgb//sa/o/6pZfKhUF+mbvJqAEuIQgM6+cHn+HHehMVjad9lzUBMwCGbuqMwLWqTx6SjrjIIPmxRI0+qad+OKlGLmKYE6SpS1DvwM6Di4MI96Cca7DbKCpuhlC7CIZckaBiF90WSB8LRxaIIshn5NeRtcmFN4Z0KKOlYIsPjwY8+PeH8WQ4Cr2t+gvviuNOp0DB5JSsSs2nHzhkwn/aZUy6RWAuf+WHVsdHB43qA2uoEEk3sX9pA/fbb5tyYbTq/McbS3L8E0iD7ZR8oXDGPO4kvDyqKsKPxZPWtu79sKJJfGsHp3TV9gNhSa+JnGDlokqNWzdGyah6JYD2u2dYgdA+A8yQ1ZJEG/XyA60jOqQIct1uXzRdtEW/j7YDYt6IRak0Xltw88TU40IwOmuUM/Yj/5IzQikvWHS1VMa7vmdf+/zYB2o9X82IziN3mJ/hJH1YhxRgW91HQykquTKFHoTJWJeTTxW1/uSKEMILHEDJ7h3B+SNctP/4MaMB9zFpHvdH9v4oxx+uJfwHENSRLLuFhLkxEO9Ib/7XqLaa5fV5a3ff+8fxNsr0UM5k7N5uKu6/39f8iO+AE
 jqpsg7rd
 BMlwuCWi418Z9eXtyrVNnBkLpi15SN1EhrWWozFiUdXdm4Fk1x6HskV8Z+yR9tr7nU7SYU42AX+gVrd7kqfoT/RCAbc0bm5ZcsTCqsSyZwUeN+nYG89PSzkGNPdyCx414OCLZo+EJnPt4fglc6tPpIOH3ttyywrSOrld7GTS3/OQ9MqnTb8xmEgWFy+7n690JcCQuu+7H4K9zHdR0/7Os/aNjFGg1I1sohli3Qku0J2K8RaMgjloBPKQzCD6osoaTU9nvHCHQQflWEU7w5tRl2fLNDT1I8ygEtABT4R9aKF2k6a4/qoCTywNXqE+JyCwLAmIR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 01/09/26 11:19 am, Barry Song wrote:
> On Tue, Sep 1, 2026 at 1:44 PM Dev Jain <dev.jain@arm.com> wrote:
>>
>> In preparation for optimizing large folio unmapping, we need to reuse
>> the page_anon_exclusive_batch helper in rmap.c and rmap.h and obey the
>> existing use in mprotect.c .
>>
>> Therefore, move it from mprotect.c to mm.h. Gate with CONFIG_MMU since
>> both rmap and mprotect users are built only for CONFIG_MMU.
>>
>> While at it, change start_idx and max_len to unsigned long type for
>> future proofing against THP support at >= PUD level. Also shorten
>> expected_anon_exclusive -> anon_exclusive.
>>
>> Signed-off-by: Dev Jain <dev.jain@arm.com>
>> ---
>>  include/linux/mm.h | 19 +++++++++++++++++++
>>  mm/mprotect.c      | 17 -----------------
>>  2 files changed, 19 insertions(+), 17 deletions(-)
>>
>> diff --git a/include/linux/mm.h b/include/linux/mm.h
>> index dd09c438fa23e..63da8813bc5df 100644
>> --- a/include/linux/mm.h
>> +++ b/include/linux/mm.h
>> @@ -244,6 +244,25 @@ static inline unsigned long folio_page_idx(const struct folio *folio,
>>         return page - &folio->page;
>>  }
>>
>> +#ifdef CONFIG_MMU
>> +/*
>> + * Get max length of consecutive PTEs pointing to PageAnonExclusive() pages or
>> + * !PageAnonExclusive() pages, starting from start_idx. Caller must enforce
>> + * that the PTEs point to consecutive pages of the same anon large folio.
>> + */
>> +static __always_inline int page_anon_exclusive_batch(unsigned long start_idx,
>> +               unsigned long max_len, struct page *first_page, bool anon_exclusive)
>> +{
>> +       int idx;
>> +
>> +       for (idx = start_idx + 1; idx < start_idx + max_len; ++idx) {
>> +               if (anon_exclusive != PageAnonExclusive(first_page + idx))
>> +                       break;
>> +       }
>> +       return idx - start_idx;
>> +}
>> +#endif
>> +
> 
> Hi Dev,
> 
> I really don't want everything to become a top-level header
> file. If these are only mm-internal things, could we move them
> to mm/internal.h or another more appropriate header?

What do you suggest? I had it in mm/internal.h initially, but
because I had to use the helper this time in patch 4, I couldn't
do that. The helper will now be used by mprotect.c, rmap.c and
rmap.h.

I can keep it in rmap.h and make mprotect.c include rmap.h too.


> 
> Best Regards
> Barry


