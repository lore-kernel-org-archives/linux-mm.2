Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D25D2CD3445
	for <linux-mm@archiver.kernel.org>; Sat,  9 May 2026 01:57:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B3746B02E6; Fri,  8 May 2026 21:57:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 83D5D6B02E7; Fri,  8 May 2026 21:57:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DD996B02E8; Fri,  8 May 2026 21:57:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 58F156B02E6
	for <linux-mm@kvack.org>; Fri,  8 May 2026 21:57:38 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E5C1516046C
	for <linux-mm@kvack.org>; Sat,  9 May 2026 01:57:37 +0000 (UTC)
X-FDA: 84746219754.22.E2D6EAF
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf02.hostedemail.com (Postfix) with ESMTP id 61E0A80008
	for <linux-mm@kvack.org>; Sat,  9 May 2026 01:57:34 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SLnNAhR9;
	spf=pass (imf02.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778291856;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+89c8WdNl4yui4bDI9B8iF1YgOI8CD6gGbpRYrrMpJQ=;
	b=HRwHj/Ae2l4xnMr3kRrxAgb+RMuUKVBh4CYK7JeBxM9O5MOy9HSmjE2x1EYepwqdn6HETY
	S9fyr40/dqoUccT9mwkDkrdYK8FiIMvVm6AmjZ8J2uKJ7JP0TYWlymk4KhWg60Zt7o4Gde
	/4nW8KSyfJtMRrLhMevjafPg47I/M5s=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SLnNAhR9;
	spf=pass (imf02.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778291856; a=rsa-sha256;
	cv=none;
	b=E9mwb5cQ8CiI3B6CAOZIWOvpbLCuDROAOS6tMamEX60sfsxzf74b24D68xFqkBGZ9AK2Pk
	3y1aUECF/DfXpgoqtgRfqs1WdOLllD7CKFvAT9ZEJt/d8H/c0ahIDwSGR7XHQsuH8YEyUm
	nCnzplXJ4+TBaJSG8TTacIjP3PsqQF4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1778291851;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+89c8WdNl4yui4bDI9B8iF1YgOI8CD6gGbpRYrrMpJQ=;
	b=SLnNAhR9LP3Rdi2k3Ciwo3goaQve5uG+N7Mz14jgDZGD8dkGhJczBvxYGSho3lxiMEokg3
	kqvatDu0J1G9YQhggnZi6ZUNgv3vzX6BUQv9Om0O3dV7zRhRLAaDi6mDynP3W4riXkNwdV
	KJNaQ3x577cWLfno9MeyAQaMSkV3Gf0=
From: Lance Yang <lance.yang@linux.dev>
To: david@kernel.org
Cc: lance.yang@linux.dev,
	dev.jain@arm.com,
	ye.liu@linux.dev,
	akpm@linux-foundation.org,
	ljs@kernel.org,
	xhao@linux.alibaba.com,
	liuye@kylinos.cn,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	liam@infradead.org,
	npache@redhat.com,
	ryan.roberts@arm.com,
	baohua@kernel.org,
	akpm@linux-foudation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm/khugepaged: clear MMF_VM_HUGEPAGE on mm_slot_alloc() failure
Date: Sat,  9 May 2026 09:57:22 +0800
Message-Id: <20260509015723.9467-1-lance.yang@linux.dev>
In-Reply-To: <6b6b094b-8dcb-423b-bb86-ef1439887eed@kernel.org>
References: <6b6b094b-8dcb-423b-bb86-ef1439887eed@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 3x88eyuf4jr8ap6ygesik851bu89fj88
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 61E0A80008
X-Rspam-User: 
X-HE-Tag: 1778291854-803742
X-HE-Meta: U2FsdGVkX1/AGwlAXZnQwXHRiAm+ykPpjcg63yUNrvEsR2u6RRaz0q//O0akaeDNNtXawKQ4o9ci20HIYYPv38VtMGRCMM0UprvAU/3lOZrrQSwNHZPR6qQOypi0tn/Py4e0BMzn4mVdlMIUzJT98U7EYmstEEmp1MkFaRBmMZ5KF6Ge3titogvcYB7URDZ8eMwPJQcGHaZwtygvdYa+7sBZLX00ZFXSDk2+S2bx75k/DW/hiCnvOq4wlJHiMTM/MBzWidorM30OtM7WCppfGef4Ya5bZa1Ak2W1ogdaaKOaXKudgkLHqjVFwCh2joc4qn1WS1afk/QQjH/fV3icMb/b9KhTvdHpVAMAH5rabrjtN90vQ2ylCcy7Ne0IaWevyi6bBr42htoU/cnZIwU4EIZiGmTjDrsGYERw8PeWrBeGCLImFtz5mP7maVUUSEFqTDQhmRIc/tmsE9BENyJfnMdmIbU09SVvtx+CwxqbJyfmFiqIG46X0V70xCgsfSS3He2Q1q0apvEuULXtjW2HctN6BLjcksXJhFBgHgEdwWiQDTgI23Gg0m9M3RRylJ+mX7BPsExcE8Ns5pqBcOVpRd7rV5niCfbmzFwzpkqILemZQV/LrpQ0s7wEsTRvkYNomMGTehzyrelmvfazEtyIC/u02e19YoW9uzgf40ZW2pepc1NwFtXcaJnnNBrcu+qnLAgxpfutB5td5u8bUAfI7p9g8/Wi6CHYKN5IZ/O6vhFbLVriUBl+NjRtj0jgQtT3q4VpzKoXhr9sxAQJdTRImr8TswmGAo/R/1/NP0Z+nPDMWNznenPDuPMy+Tc9+QEaLVJcxEUuGehHQEyuGQO3M1TrTeXWUAk/j15y4sVubCEINy5h+fyWyvlF3vmRR09ostP8dTIteNJQHmoZrjRIG8JXo6pc68dc/dO1MSKh6NPRQw+QXN3Nmw6sO7NT9d9ucW2Pt/ffY2Q9EweY8Hk
 OrnJTa92
 aUEdfORvFrbw9gg9omukMxfTBgPC5cdkgd1gtH0KsRTjQ9kYWNRNt7XHZqH6NuwlDd1cEw7jgQDK5uZVUbQ/UcbqvMqs8smvdnyZwn8/jklA959Dr1zaUkro2KyzSs2at/Qz6lgY9dmvtpPFdrKK1pyJGujE2mxclzCNfLx1JJhAOZOisu4A5IIeGnRAOHFiBTxb44vDB2NlcWM+FVGxtkqVWprwPBNZfFUdyJavU0wL77DJtWWODoE3EAvPZdNBl8ziV8x3Oq/uY1ajDTIGsTJoGsa//bddd2i8spuO1Ky76uLc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Fri, May 08, 2026 at 11:41:34PM +0200, David Hildenbrand (Arm) wrote:
>On 5/6/26 12:51, Lance Yang wrote:
>> 
>> On Wed, May 06, 2026 at 12:16:35PM +0530, Dev Jain wrote:
>>>
>>>
>>> On 06/05/26 6:51 am, Ye Liu wrote:
>>>> From: Ye Liu <liuye@kylinos.cn>
>>>>
>>>> __khugepaged_enter() sets MMF_VM_HUGEPAGE before allocating the
>>>> corresponding mm_slot.  If mm_slot_alloc() fails, the function
>>>> returns with the flag set but without inserting the mm into the
>>>> khugepaged tracking structures.
>>>>
>>>> This leaves the mm in an inconsistent state: it is marked as
>>>> registered (MMF_VM_HUGEPAGE set), but will never be scanned by
>>>> khugepaged.  Future attempts to register the mm are skipped since
>>>> khugepaged_enter_vma() checks the flag and returns early.
>>>>
>>>> Fix this by clearing MMF_VM_HUGEPAGE when mm_slot_alloc() fails,
>>>> restoring the ability to retry registration later.
>>>>
>>>> Fixes: 16618670276a ("mm: khugepaged: avoid pointless allocation for struct mm_slot")
>>>> Signed-off-by: Ye Liu <liuye@kylinos.cn>
>>>> ---
>>>> Changes since v1:
>>>> - Add Fixes tag as suggested by Dev Jain and Lance Yang
>>>>
>>>>  mm/khugepaged.c | 4 +++-
>>>>  1 file changed, 3 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>>>> index 7d48d4fbd5f3..60ab7c1b61dd 100644
>>>> --- a/mm/khugepaged.c
>>>> +++ b/mm/khugepaged.c
>>>> @@ -559,8 +559,10 @@ void __khugepaged_enter(struct mm_struct *mm)
>>>>  		return;
>>>>  
>>>>  	slot = mm_slot_alloc(mm_slot_cache);
>>>> -	if (!slot)
>>>> +	if (!slot) {
>>>> +		mm_flags_clear(MMF_VM_HUGEPAGE, mm);
>>>>  		return;
>>>> +	}
>>>
>>> Note that, a racing khugepaged_enter_vma() may back off
>>> when it sees that MMF_VM_HUGEPAGE is set, but then the above
>>> clears the flag after slot alloc failure. So we end up not
>>> registering the mm with khugepaged. But I am sure no one
>>> cares, we are in much big trouble if slot alloc is failing.
>> 
>> Right. A racing khugepaged_enter_vma() can see MMF_VM_HUGEPAGE is set
>> and return, then !slot clears it again. If there is no later
>> khugepaged_enter_vma(), the mm still wouldn't get registered :)
>
>So why not
>
>diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>index 5f4e009593e0..78735f34250a 100644
>--- a/mm/khugepaged.c
>+++ b/mm/khugepaged.c
>@@ -437,13 +437,16 @@ void __khugepaged_enter(struct mm_struct *mm)
>
>        /* __khugepaged_exit() must not run from under us */
>        VM_BUG_ON_MM(collapse_test_exit(mm), mm);
>-       if (unlikely(mm_flags_test_and_set(MMF_VM_HUGEPAGE, mm)))
>-               return;
>
>        slot = mm_slot_alloc(mm_slot_cache);
>        if (!slot)
>                return;
>
>+       if (unlikely(mm_flags_test_and_set(MMF_VM_HUGEPAGE, mm))) {
>+               mm_slot_free(mm_slot_cache, slot);
>+               return;
>+       }
>+
>        spin_lock(&khugepaged_mm_lock);
>        mm_slot_insert(mm_slots_hash, mm, slot);
>        /*
>
>
>Arguably, on the race described above, likely the thread seeing the
>MMF_VM_HUGEPAGE would likely similarly have failed the allocation.

Right, LGTM!

>I'm fine with either, just wanted to raise the (cleaner looking?) alternative
>where we just properly back off?

Dev suggested the same thing[1] on v1 as well. We should have gone that
way :)

Allocating the slot first and only setting MMF_VM_HUGEPAGE after that
makes the race go away. If mm_slot_alloc() fails, there is nothing to
undo.

[1] https://lore.kernel.org/linux-mm/aed7c1d5-2189-4ee2-b0f3-ce5a3e3c2118@arm.com/

Cheers, Lance

