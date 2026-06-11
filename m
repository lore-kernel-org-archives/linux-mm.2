Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4DAE4CD98C5
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 02:47:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A7F0A6B008C; Wed, 10 Jun 2026 22:47:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A56CB6B0092; Wed, 10 Jun 2026 22:47:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 993D46B0093; Wed, 10 Jun 2026 22:47:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 87C4B6B008C
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 22:47:27 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0CAC240462
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 02:47:27 +0000 (UTC)
X-FDA: 84866095734.14.4C3B17E
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	by imf18.hostedemail.com (Postfix) with ESMTP id 8D05E1C000C
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 02:47:24 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=StQ1nVUw;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf18.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781146045;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S9EUXg/9jzkqyqp4PuuzqslZeYUCH3d8eRt1rqr7ueg=;
	b=D9gDigBx+zUr0mIb+48NrUcmpJ+UrMwShVRLf8HGTdGEdJiq2eoJ5W6oaeBBYz+tWwc7Cq
	8kyHDtwoVUabygAJEcifyXKmbQyzu5/V9RsrJfdxAOT6DnImEcAFerZxLkJWCXMDgEdTx8
	6A5ixWw+XQFhc/4WdSeVelZBCtMOGPU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=StQ1nVUw;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf18.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781146045;
	b=0HnKohmRe+C83SCmT2vpmF4gls2sa/E+qHtzi2N2eQEB0czwqT9wUBFd7PRpCuWR9jJ5iO
	/3Uclle7BpjtfrTiGVZ4sohF3sLFExTMcD3znF5c/VGXCPHfaPC/mKJ6W0wJipwy9zeZcj
	mwUgZoO8ZzXu0qgYZc92pSORremjZpo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781146042;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=S9EUXg/9jzkqyqp4PuuzqslZeYUCH3d8eRt1rqr7ueg=;
	b=StQ1nVUwjNoPoPBt2M2i15wP5Ek9v27AAi6hKq5nJtqx+P/Y5YzF+BhppVP0KqnhjsOOEF
	6GzyjMsJ4Og+dUrBSEqbWdVjdQR3rTMeFZqiq1+a4SI/LbqIkunWWxVjm7lT375JDbgKvV
	SY2/Fo8mnot9CLLB/zJNFMjWl1paovQ=
From: Lance Yang <lance.yang@linux.dev>
To: baolin.wang@linux.alibaba.com
Cc: lance.yang@linux.dev,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	hughd@google.com,
	willy@infradead.org,
	ziy@nvidia.com,
	liam@infradead.org,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 04/11] mm: khugepaged: add shmem mTHP collapse support
Date: Thu, 11 Jun 2026 10:47:06 +0800
Message-Id: <20260611024706.95748-1-lance.yang@linux.dev>
In-Reply-To: <0e431c06-b80e-4b4b-aeca-b9a0eacb6252@linux.alibaba.com>
References: <0e431c06-b80e-4b4b-aeca-b9a0eacb6252@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: oasyzf9uo5k4i8aeraiyiuraxcpy3n7y
X-Rspamd-Queue-Id: 8D05E1C000C
X-HE-Tag: 1781146044-178332
X-HE-Meta: U2FsdGVkX18XGv7BPlfM5cRIu+2eJsbWsY/XuqqHbSKBL7hoPuy70ESM26noRjoroEmR7aZtRxOl2irVnxc4xqr+6RpRinSaS0zwk0B6GEkKunNTpqv+OMlFTe3cmlDDVweMLlaJJUXygsvfmW82XoGnWDDzC3ONJJo4Z0p+RiKJ7Ezp7F5cn+rP0R4iRsa6mp5RETXDira5jSbnwACTLr9+1M/X+z92tUURW9xmMNl15wry9fASazuyQhLkvWZZpA4ctXqwt0blGvY03SQEXwMUN/xlfEpwke6zJws6F880CE4A4cJDtOgnXQPYrJAxJYqI/bXxCHWWmIw0xxRKKNoMyi8lHnAV76m991FV3mnsNNttuoYTSOsHQr08pIszHAJBfvKoJ+5NebiP8Z9dfMyRWj8xVZZe3B9McA+ibEivXNrBbmwaJL8ZfsOkmL3QrdhVwvM680YIYxZumYq4H2qvEo9vcZOc66lbhykeTPn2OT1gW9NyFXyVQD1zWvzi+6R05i3LZgUDg1ntA5MgVQS6+RjcFFxiEDijwr/yrGsRK4L1T6OyxbX36eywg1y2h3VvV7/8+haUl7IKrvhMUDoYHfj6Kw6JM3nKObxyuHcQMck3+flT34J85KZyaHNjcksrWUrMhLlnDwe3XtB6LTTljYGQ5IAcT5Voi5nrgJ7CSTy0AASQmYkNzvKviHNAPj1J0mY0wDuW2n/YiJ26KWjd6TbrwkiwzMrYP75TBZp4yeDgz3wh3sSyo92hEMGfyJ6fvruGddFhzKwPaHu2Tn5vdS8h6EajX+qzTdaTQH7OMur3t6WaA+hbZw1eADP3x1bzFTMeIi5No3TYxOFRsLv9tJljePSxGgh4Ef0uBO3rknD1B/+EqHzwJH3PQqeYJuycKzCmXLfVb+ohtwUp38jYaW5B34titHb6GUJgJ+vjhhFSmuiHra16xUFaKiudLzpQyhhK6iH8Ngi5wBw
 RKZRY6QE
 ZV4+zwbk2ieKOLtHI6As4Y0SKGTc9Wmpl0W4JtoCOSOFcYf1lFksHNJmxJFrOnizRIEEP/1n4/lMXzKUq/lQ4w7MaTSQLed0zNvhoIqSevC+Npp+zaIimO40JGbz86ordqij25kOrRoPAZClxQ80CtkoXGJc1WX0xGhR5PDmF6UM8l6mlBDfuhS2u/1Tz3NyZqoVj7f3eXFXodcCFvk6FRiTq9g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Thu, Jun 11, 2026 at 08:42:28AM +0800, Baolin Wang wrote:
>
>
>On 6/10/26 8:44 PM, Lance Yang wrote:
>> 
>> On Wed, Jun 10, 2026 at 06:29:12PM +0800, Baolin Wang wrote:
>> [...]
>>> @@ -1512,8 +1517,12 @@ static enum scan_result mthp_collapse(struct mm_struct *mm,
>>> 			enum scan_result ret;
>>>
>>> 			collapse_address = address + offset * PAGE_SIZE;
>>> -			ret = collapse_huge_page(mm, collapse_address, referenced,
>>> -						 unmapped, cc, order);
>>> +			if (file)
>>> +				ret = collapse_file(mm, collapse_address, file,
>>> +						start + offset, cc, order);
>>> +			else
>>> +				ret = collapse_huge_page(mm, collapse_address,
>>> +						referenced, unmapped, cc, order);
>>>
>>> 			switch (ret) {
>>> 			/* Cases where we continue to next collapse candidate */
>>> @@ -1521,6 +1530,7 @@ static enum scan_result mthp_collapse(struct mm_struct *mm,
>>> 				collapsed += nr_ptes;
>>> 				fallthrough;
>>> 			case SCAN_PTE_MAPPED_HUGEPAGE:
>> 
>> Looks like SCAN_PTE_MAPPED_HUGEPAGE from collapse_file() get lost for
>> the PMD-order case.
>> 
>> Previously, collapse_file() returned it straight back to
>> collapse_single_pmd(), so we would run try_collapse_pte_mapped_thp().
>> 
>> Now it hits mthp_collapse() fitst, and that case just goes to
>> next_offset ...
>
>This is the expected behavior. SCAN_PTE_MAPPED_HUGEPAGE is only returned 
>when the MADV_COLLAPSE collapse succeeds. In this case, if 
>collapse_file() still returns SCAN_PTE_MAPPED_HUGEPAGE, then 
>mthp_collapse() will ultimately return SCAN_FAIL (because collapsed == 
>0), even though the MADV_COLLAPSE collapse has already succeeded.
>
>Additionally, the SCAN_PTE_MAPPED_HUGEPAGE logic is already handled in 
>collapse_scan_file(), see:
>
>result = mthp_collapse(mm, file, start, addr, 0, 0, cc, enabled_orders);
>if (result == SCAN_SUCCEED && !cc->is_khugepaged) {
>         /* If MADV_COLLAPSE, adjust result to call 
>collapse_pte_mapped_thp(). */
>         result = SCAN_PTE_MAPPED_HUGEPAGE;
>}

Right, I agree for that case. The one I meant is a bit different.

I was looking at this earlier return from collapse_file():

		if (is_pmd_order(folio_order(folio))) {
			result = SCAN_PTE_MAPPED_HUGEPAGE;
			goto out_unlock;
		}

Old code let it bubble back up:

collapse_single_pmd()
  -> collapse_scan_file()
    -> collapse_file()
      -> SCAN_PTE_MAPPED_HUGEPAGE
    -> SCAN_PTE_MAPPED_HUGEPAGE
  -> try_collapse_pte_mapped_thp()

Not limited to !is_khugepaged. collapse_single_pmd() only checked the
result, then passed !cc->is_khugepaged as install_pmd.

Now the same return goes through mthp_collapse() first:

collapse_single_pmd()
  -> collapse_scan_file()
    -> mthp_collapse()
      -> collapse_file()
        -> SCAN_PTE_MAPPED_HUGEPAGE
      -> goto next_offset

So collapse_single_pmd() never sees SCAN_PTE_MAPPED_HUGEPAGE for this
case anymore. Hopefully Im not missing something here :)

Cheers, Lance

