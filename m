Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4768BC9832F
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 07:34:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 28E986B008C; Mon, 28 Sep 2026 03:34:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23FE66B0092; Mon, 28 Sep 2026 03:34:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12F766B0093; Mon, 28 Sep 2026 03:34:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D7AB86B008C
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 03:34:02 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4FC2D80109
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 07:34:02 +0000 (UTC)
X-FDA: 85262357124.26.618DE9B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 8FA4E80009
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 07:34:00 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NYClZZp+;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790580840;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2kX1y+gkrcsHHcC9E2KZtg+MuiBNf/N48bFwpnhYoeM=;
	b=K5rSzBUHxhZf1WIw6G0ueh4ku/gubf1bIIV0FDTGno/Fx1nEnC7VvyVB9DHnh0t5BATpwN
	plJu6rK72qoqaTeIXKmjTwgmQ252dLOzs5yKQSJ2kvgfFcRlLbZo3yvSwgYNUYzTJnZFFw
	4ctE1LdEyxox3aBV0nc3Lmm4TTsoR9Y=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NYClZZp+;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790580840;
	b=kvkTWkzUFEH/M19vT77Q0ViyjF8TldsC1kAHVuo7DIvYcGAoreUBbJCyic/wHwp+DSZ54K
	XhBsn/CelOfYVq4ywJwHBGIfdLJ1tAIObKliu+3iOrpVwJmovWh6/Q6ukPS9QHAiCSZf9I
	H+pU/NNizlBd8UMW6Zll89AlAeOguq0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0F5D7600E2;
	Mon, 28 Sep 2026 07:34:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EED11F000FF;
	Mon, 28 Sep 2026 07:33:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790580839;
	bh=2kX1y+gkrcsHHcC9E2KZtg+MuiBNf/N48bFwpnhYoeM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=NYClZZp+TxfnsyUx916D9XME2TBcY4THXSWp934cmknZE3QLC7GiCo6WydU2MbRrh
	 BxYwMW7MeqRlcVd5ectlj6nWVemjXUix+NQ8WzqmyXc1Q8RUnkSX6f3jIHfUFoJqNY
	 UBWkvaWQTUqY+w3UkirD8kYeoKrpohE1kwc1aPEY6+Y6VHg9hadGnzdS4c8gJWq7tc
	 RuHpXbENaz5kcqoTiKDBoFcqWOg8/SqUP0zsGKAhMojDN9DylQnt5dNKO+GyaJvh7d
	 saYjYQQ/k+DjVtCtcwnAGFvtPZCWI+rGm3lXeH6xO5AKWDgeT9AwD3HB0Ah6EhlJq0
	 5C109zjzLL11A==
Message-ID: <2782f081-b569-4be2-8649-832eca7b0475@kernel.org>
Date: Mon, 28 Sep 2026 09:33:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/2] userfaultfd: clear the inherited uffd bit in
 move_swap_pte()
To: Andrew Morton <akpm@linux-foundation.org>,
 Donggeun Yoo <donggeunyoo.kernel@gmail.com>
Cc: rppt@kernel.org, peterx@redhat.com, surenb@google.com,
 aarcange@redhat.com, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org,
 mhocko@suse.com, shuah@kernel.org, kirill@shutemov.name, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
References: <20260926124145.2878520-1-donggeunyoo.kernel@gmail.com>
 <20260926124145.2878520-2-donggeunyoo.kernel@gmail.com>
 <20260927135439.094d75bc42414879a6e21c79@linux-foundation.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260927135439.094d75bc42414879a6e21c79@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8FA4E80009
X-Stat-Signature: xze4i9qittx84ojnk4ig9wrnpzg79yhb
X-Rspam-User: 
X-HE-Tag: 1790580840-215606
X-HE-Meta: U2FsdGVkX1+Yp36Q+EhMx8ZELHnE7x5BrVRCLa+SsBGV++v9RyWsA5pjpUxHCDjeiTd/9ZNglm3TA9i9NNqSUE/0W+HLa6BJRpGEJW+hVzneoHfYtswQJ6iivs32/fNajhPYXkPMSCX3Q2wuiUwyTCIV1328SfOsW45TVBySaME0hZS5Ua9vye5T8PvHu3SqruWtR/5Cx/yT6gD18flOdKKt0giBpoM294rIVUi+oAsKItZb8mZRq01cNizAV8QTw374oYCb1NpGK38x9vyDhuXLMum7lFNLCrGfmDbkh+JmUHKkvTidlT+zdwlNO5LseUXe7ZL4oVb3THm4x5hDNX5QdMYovxmhz9fVRhpufyPf/Cm46z9TNb2KWNZxOWcR2g4X66wtixJhW9qJ/8pNVkHm3xYk6vH3NP7KNaiHigay7uahC1KJYv7Sl+EjcHSP+i0F1KR2CBVLyIgCYZbHrdVba7Tj6QkFVPePsAdu/fxyetegXNp+z64Ogd6cJDS1HU8WQBaPw4OITWtfGKq/ToX7F/ZejXrrDEDtl9hdBSgLzB46UIPvWGbFAfMcq/XdEbb6VhKlPkVhCYudXtRVqZhTjsmY2736LexbnIAjJFL6Q0s5SjIGOuqKNR9zxSKGu88RvHSsT6BR6ZZu8YqmKgJUZM0WPK2XRcrq37omFsacWEZjQgkByZP0DyxAvNCw2vDQdWYBCNyHEooydxNPyGoTgQbYvs0AIOZdO+xLPwugKtlZlmCQtSbUIU//iUlMvtguZaDs+ZxltX5r0vA1pxFhqHGNcFBmmw5/NmX15gqu4NnyNPNZ8DMn7g2CHkhuY645FBA/4rxgmWGjp3txJJhsvCFkzwtjR8oafW9TeiCEoLOo7UQFnltb210ysPcrp/j0DoSSmgeP6jIkuy3cMNSrdK+Xu0hYKAjikB5pKwaP4KJ9TxSg6O5vodx/kcF1MNO58xyErKOf9QHi7KZ
 h10NyvDV
 cDnrn8UmitqgFv7WQ9KgGJ/Vd+OBtRTVCwZRpLR4dsq9Ggso689thbf5iWlVvvj3kVlC7PaMA3Jixnncq4JKLPnKXhFIzZpTp/I1kanwfHNa8f1io5irGRL8795beGNnS/8bnmN3LGExe3bqIiSAH95tJNOoVGAaQDAxu1WYdD6rTeAsoNzR+W3jWtoZ6/4KQRc921VtVNavgWvNDynVvYwTgMsk0kbIeHU7z+QxIJzhwXN13Jmvxv9ho1qZ439D9IA00acHL88xCS51qNHXxbri8Pr6/FWnpzSCU7ifvlq8cD1yBLWBuPvZltfRzJbrfsUisErjgzg3CvKOZn24p7DupZ8aIpck0JJkFbFHVUr12wO6wTFJKhzl4/51DdDhz3Y/AsxtaJK0XS8RnurMYHLzd9SzvqvNnO0Ec3j2nux1dpaI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/27/26 22:54, Andrew Morton wrote:
> On Sat, 26 Sep 2026 21:41:44 +0900 Donggeun Yoo <donggeunyoo.kernel@gmail.com> wrote:
> 
>> UFFDIO_MOVE on a swapped-out page installs the source PTE at the
>> destination unchanged, so a uffd bit set on a write-protected or
>> RWP-protected source lands in a destination VMA that was never
>> registered for either.  Nothing clears it there, and userspace sees:
>>
>>  - /proc/<pid>/pagemap reports the page as uffd-tracked (bit 57), both
>>    while it is swapped out and after it is faulted back in.
>>  - MADV_COLLAPSE fails with EINVAL on a range containing it, because the
>>    collapse scan bails on a swap entry with the uffd bit set.
>>  - With CONFIG_PAGE_TABLE_CHECK, faulting the page in warns.
>>    do_swap_page() carries the bit into the present PTE and, since the
>>    destination isn't WP-registered, also makes it writable:
>>
>>    WARNING: mm/page_table_check.c:202 at __page_table_check_ptes_set+0x185/0x1e0
>>    Call Trace:
>>     set_ptes+0x67/0xc0
>>     do_swap_page+0x990/0xfe0
>>     __handle_mm_fault+0x7d0/0xeb0
>>     handle_mm_fault+0x9c/0x250
>>     do_user_addr_fault+0x207/0x650
>>     exc_page_fault+0x65/0x150
>>     asm_exc_page_fault+0x26/0x30
>>
>> Reaching it takes UFFDIO_MOVE out of a WP- or RWP-protected area into
>> one that isn't, on a page that is swapped out at the time.  It hasn't
>> been seen in practice.
>>
>> A resident page doesn't carry the bit, because move_present_ptes() builds
>> the destination PTE from dst_vma->vm_page_prot.  Clear it on the moved
>> swap entry as well, then re-arm it if the destination is RWP-registered.
>>
>> The WP case has been there since v6.8, where UFFDIO_MOVE was added.
> 
> Thanks.  This is triggerable by unprivileged userspace, so can
> reviewers please prioritize.

I assume most production kernels don't have CONFIG_PAGE_TABLE_CHECK enabled in
the config. And if enabled, not active at runtime.

I'd assume mostly only debug kernels have that config ever enabled. So it might
be less problematic than it seems at first. (at least the WARNING bit)

> 
>> Fixes: adef440691ba ("userfaultfd: UFFDIO_MOVE uABI")
>> Cc: <stable@vger.kernel.org>
> 
> This should be whizzed into 7.3-rcX pretty promptly.
> 
> It's not really appropriate to give the selftest such treatment - I'm
> never really sure how to handle that.  I guess I'll keep things as you
> presented them - both for current -rc, [1/2] gets backported, [2/2]
> does not.

Make sense.

> 
>> --- a/mm/userfaultfd.c
>> +++ b/mm/userfaultfd.c
>> @@ -1449,6 +1449,7 @@ static int move_swap_pte(struct mm_struct *mm, struct vm_area_struct *dst_vma,
>>  	orig_src_pte = ptep_get_and_clear(mm, src_addr, src_pte);
>>  	if (pgtable_supports_soft_dirty())
>>  		orig_src_pte = pte_swp_mksoft_dirty(orig_src_pte);
>> +	orig_src_pte = pte_swp_clear_uffd(orig_src_pte);
>>  	/* Re-arm RWP on the moved swap entry if dst_vma is RWP-registered. */
>>  	if (userfaultfd_rwp(dst_vma))
>>  		orig_src_pte = pte_swp_mkuffd(orig_src_pte);
>> -- 
>> 2.53.0

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

