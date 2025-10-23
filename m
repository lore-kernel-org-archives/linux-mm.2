Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54725CCD1BE
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 01:12:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC4A08E000D; Wed, 22 Oct 2025 21:12:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A75448E0002; Wed, 22 Oct 2025 21:12:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 969AE8E000D; Wed, 22 Oct 2025 21:12:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 82E708E0002
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 21:12:30 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 26FC7B652B
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 01:12:30 +0000 (UTC)
X-FDA: 84027603660.20.A2ABDB0
Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	by imf09.hostedemail.com (Postfix) with ESMTP id 0607D140003
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 01:12:26 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=JBwZ97GJ;
	spf=pass (imf09.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761181948;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OY0FCj556fptPozBFxGp5get5cRe/MRUmiOCM9ncjw4=;
	b=2wvL3auYbphIGXQQLDQAdhNpviW3nYhyKRItRJWLmPrbSRGyTxlDK14qigJnZhfu94Vbts
	uENFH2Fh3qtQjwePgYnicYi6NHq0iyO/joBA8IKy8DKlIzeHSuew63yTldKq4fzMqp0t92
	TCYf8PfUK+VArGP3V9YMmUJ9ThGVz2Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761181948; a=rsa-sha256;
	cv=none;
	b=cVCXjVAkBculPUJ10c4poGZUW4BEys6iQPhtTnnG/U/FyklWo3qE+eeizFOcFWN9P+ccsP
	uYf7MmqWyzyETCHZou83jyLdJcXvQxVFNOX6JbO4y4kfVf0vHX8qJzEkS4HaMdEfZVoBdh
	vyBhcPaFwcRL7Cx9Nyp3Px+EvyYb4aU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=JBwZ97GJ;
	spf=pass (imf09.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1761181943; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=OY0FCj556fptPozBFxGp5get5cRe/MRUmiOCM9ncjw4=;
	b=JBwZ97GJil+RYkKKjOPaN2dV/zNwZXYWDUnhGtFHeAL1hv4ZProHR6+KWnAGX7D5HQ597VWmlMmsoXXLBr1J5Jcaujy/BmeKfhrYMmNshKZqeTFSh7FrBsChH1aerBdrG4BWcDR62LLsiSRZi6sjBsHN/eSLMW3wzJhG8ywLUOY=
Received: from DESKTOP-5N7EMDA(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0WqogLW1_1761181942 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 23 Oct 2025 09:12:22 +0800
From: "Huang, Ying" <ying.huang@linux.alibaba.com>
To: David Hildenbrand <david@redhat.com>, Anshuman Khandual
 <anshuman.khandual@arm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,  linux-mm@kvack.org,
  Andrew Morton <akpm@linux-foundation.org>,  linux-kernel@vger.kernel.org,
  Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH V2] mm/debug_vm_pgtable: Add [pte|pmd]_mkwrite_novma()
 tests
In-Reply-To: <0a121e1b-e238-4a75-b431-7c5a23c70f45@redhat.com> (David
	Hildenbrand's message of "Wed, 22 Oct 2025 22:24:06 +0200")
References: <20251022032951.3498553-1-anshuman.khandual@arm.com>
	<87ecqve6gg.fsf@DESKTOP-5N7EMDA>
	<b5a1b52c-75ef-4915-a254-a502b9f78eeb@arm.com>
	<87o6pzbbks.fsf@DESKTOP-5N7EMDA>
	<0a121e1b-e238-4a75-b431-7c5a23c70f45@redhat.com>
Date: Thu, 23 Oct 2025 09:12:21 +0800
Message-ID: <87qzuu2zgq.fsf@DESKTOP-5N7EMDA>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
X-Rspamd-Server: rspam05
X-Stat-Signature: wijd8pyxx39qga9ojwq5gsdncatjdna1
X-Rspam-User: 
X-Rspamd-Queue-Id: 0607D140003
X-HE-Tag: 1761181946-139913
X-HE-Meta: U2FsdGVkX19QnK2mHOOZA46GFVpeJrJ4b5h5hObIo+g2+Vbje+JzhF8dMSwWIitbycUm/LIOtTcIGKkldieWk1ZOSh94cvruvAOY7eAAvk6PDiqXIMVwG4he5x7TRD84l8kf3orCgkBywvjSLmAXT54x6jLsCx6ORETXavkRWzwdlrmfx2F8IOpQfPN+DK2Wlym73uwf4OlaFL3T4CcLIBuk3ZIbRxpnCXl4JZ85NxFZTL1aUBHlYqHXUNEpKlSeAf2kYqbh+H7kF28ssh1+c1B3aak8pwThZgqIh0gKKy81SUpFmpT1mdil2Abu1imVCZeyrjYz965eWCLudcWfjd01d5tZpY9/J20h7uvqxrVnG8iZhwvhhXMp6RqCnzkOv8aH/4Du8RJG7UX1PGqBys4qu/mg6WRDzqTpPKo74DPSNgja1TND9T5YzPyl4KDVYNTZENZYxAAvYDjyS76i+KD0S1z9tHMlxhJQtttqPGnjY/JQDo2aw0DkUwKvYlHM8SV7ZpY5qvRQi/uqJVl8LiPiQ2ik2bB9amWDJqwatCjYpUEtwrlc43nrT8KHhNlP+T/y4vyQ7qjvsbkBlMNvu8NBbeemypbWK9TQhdeuv64NBNppXaXZQITXxo/sGLXV6mgcP9vl0/E6wjWAQFT5URvglXvKnD5czABf/zxr7Tskr9Cpj8acXOMYm8FqiJJvjuvLs9jbZp0u23EtS4WexEg13qBYUGKg30l4NQrQF3JUNe/7f5ScMcrZrxuNBnpm84cK4UV2ed8Iw7owc60J6UrnSuuDUWul2KCqaRbBxWTxRb7Hh9mm96tINEZiHmVbPdAHXm6d9lHlN11/4VGu9+Kwldtf8g8jS71RhWL4nuib5ezGhD/+hoRHs2KxYabzhkyoo2gnz3WlB83gMZN4+KABYT1gGp8dz8rjwRrtAulN7uYm/UDQT/y9V/x1YJ703cFqu/D3PG5Kh7X7kAS
 P/k6O5yR
 haZbgFbCWxQ/T+sreFvecXsweHVlNXPd/7UXFufv9tVGbiFqSg75aYYqyqDEIMrBO3+diQWBVTlK7xkVyb9BgeYWjZKEnJFiyfQzeRwxJLR5rGzx5sz28uipl5xzMJX/7GAjQPku0kKpF6FqhgxmWMI22J5z1C1wGAj9Gb1CYsl4gfbANJB80QUh81W2t41mVQ+KM8FWnRH1/F7Hq6TBKfaWCm/nZHwlski2eoyg8iUkmh4AJ7iMAEyvkH3zBgDZ9Q1WxvJt2b6F2dTJe1G0Umy3SilEG6i0IShg2Ya6Tk9KVM8uDHuBNUHmDp8BNZCsKHxiiwd7YJWvr+TvaaCn9g9TsX1jzyGaF7qsnPy5N5d/taYq2zJBNdbK+YNaYeSQG5ZOseRuBTCkquYwsIG2NbmUjT1rw59YDXg5F/7/ACYORC1G8szIosJLe86/BRF09rYHQcv+YvI0oXwbnEUaF+CDwA+qIO25ck/6v/AoN1O6p5kjnp1ofcEEQ6NkqRzrRl4A1vAdDa5glOblk8cvA1OjcFA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

David Hildenbrand <david@redhat.com> writes:

> On 22.10.25 10:11, Huang, Ying wrote:
>> Anshuman Khandual <anshuman.khandual@arm.com> writes:
>> 
>>> On 22/10/25 1:03 PM, Huang, Ying wrote:
>>>> Anshuman Khandual <anshuman.khandual@arm.com> writes:
>>>>
>>>>> Add some [pte|pmd]_mkwrite_novma() relevant tests.
>>>>>
>>>>> Cc: Andrew Morton <akpm@linux-foundation.org>
>>>>> Cc: David Hildenbrand <david@redhat.com>
>>>>> Cc: Huang Ying <ying.huang@linux.alibaba.com>
>>>>> Cc: linux-mm@kvack.org
>>>>> Cc: linux-kernel@vger.kernel.org
>>>>> Suggested-by: Catalin Marinas <catalin.marinas@arm.com>
>>>>> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
>>>>> ---
>>>>> These tests clear on arm64 platform after the following recent patch.
>>>>>
>>>>> https://lore.kernel.org/all/20251015023712.46598-1-ying.huang@linux.alibaba.com/
>>>>>
>>>>> Changes in V2:
>>>>>
>>>>> - Added a new test combination per Huang
>>>>>
>>>>> Changes in V1:
>>>>>
>>>>> https://lore.kernel.org/all/20251021024424.2390325-1-anshuman.khandual@arm.com/
>>>>>
>>>>>   mm/debug_vm_pgtable.c | 12 ++++++++++++
>>>>>   1 file changed, 12 insertions(+)
>>>>>
>>>>> diff --git a/mm/debug_vm_pgtable.c b/mm/debug_vm_pgtable.c
>>>>> index 830107b6dd08..def344bb4a32 100644
>>>>> --- a/mm/debug_vm_pgtable.c
>>>>> +++ b/mm/debug_vm_pgtable.c
>>>>> @@ -102,6 +102,12 @@ static void __init pte_basic_tests(struct pgtable_debug_args *args, int idx)
>>>>>   	WARN_ON(pte_write(pte_wrprotect(pte_mkwrite(pte, args->vma))));
>>>>>   	WARN_ON(pte_dirty(pte_wrprotect(pte_mkclean(pte))));
>>>>>   	WARN_ON(!pte_dirty(pte_wrprotect(pte_mkdirty(pte))));
>>>>> +
>>>>> +	WARN_ON(!pte_dirty(pte_mkwrite_novma(pte_mkdirty(pte))));
>>>>> +	WARN_ON(pte_dirty(pte_mkwrite_novma(pte_mkclean(pte))));
>>>>> +	WARN_ON(!pte_write(pte_mkdirty(pte_mkwrite_novma(pte))));
>>>>
>>>> Why do you use
>>>>
>>>> pte_mkwrite_novma(pte)
>>>>
>>>> instead of
>>>>
>>>> pte_mkwrite(pte, args->vma)
>>> Just wanted to have more coverage for pte_mkwrite_novma() helper which was missing
>>> till now in this test. But just wondering is there a specific reason for replacing
>>> this with pte_mkwrite() helper instead here ? Also we could probably add tests for
>>> both these helper variations if that is preferred.
>> IIUC, pte_mkwrite() is a more formal interface.  pte_mkwrite_novma()
>> is
>> used to implement pte_mkwrite().  So, IMHO, we should use the more
>> formal pte_mkwrite() interface if possible.
>
> pte_mkwrite() does different things based on VMA flags on some archs
> (e.g., x86). So to test the "interesting" stuff one would have to
> craft a special VMA.
>
> Without any special flags pte_mkwrite() really is just pte_mkwrite_novma().

Thanks for explanation.  If so, I'm fine to use pte_mkwrite_novma() in
the tests.

---
Best Regards,
Huang, Ying

