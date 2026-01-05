Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AAF44C2A062
	for <linux-mm@archiver.kernel.org>; Mon,  5 Jan 2026 02:20:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB6706B00C6; Sun,  4 Jan 2026 21:20:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8DC06B00C7; Sun,  4 Jan 2026 21:20:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC5046B00C8; Sun,  4 Jan 2026 21:20:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B937B6B00C6
	for <linux-mm@kvack.org>; Sun,  4 Jan 2026 21:20:50 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5702B5FFF7
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 02:20:50 +0000 (UTC)
X-FDA: 84296307060.09.F75C91F
Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	by imf15.hostedemail.com (Postfix) with ESMTP id AA12FA0007
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 02:20:48 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BKWsNJWH;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767579649; a=rsa-sha256;
	cv=none;
	b=SjBkWvtMPZaFXXPsqxEVBJ1T3LvMPxXY0EDGWSKaqvbYU4DIDZB2dO/ap3WePoOxRGC6u3
	pB6ru2iD4V0HOSzuNUrSSSHxMrflZLTQNe7RCq43IgVb7lo/YLNAa9TYlmojwpm0L0Xa9t
	c1b8updOkV+DvJIUVjyvOUDdPhIxFxo=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BKWsNJWH;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767579649;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u82STQmxMu1BykQcBxZKNP/Gm77mBfCqJU7RXSI0C64=;
	b=PAUskKRVF+lF99eyr9xpgdjdiINMdbj+jsMZIv7bNDVC2KdFsXRfeyPZ8XkwBeUDavdu79
	PArTAhNq0fMnqheC5RG5nASD712bnhcrDwIhuKkseVYk706C/fla/YXZ0f8ihzV4XnXtdP
	sDEqrSgvYGBRfnAi+1ApNTuwg+mkqjE=
Message-ID: <3a446b85-c0dc-4785-af24-333fa07f56e2@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1767579646;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=u82STQmxMu1BykQcBxZKNP/Gm77mBfCqJU7RXSI0C64=;
	b=BKWsNJWH5Ma504h/MWudtuBguImKWgiDNnn6zlgdS3cz5X7QyGqBU+jGhqViuLMdq/4XuM
	NeyDorNkn79aAXTVYbMnFmFIjAy6Kah5+IbtLDiOF5HCkWc8UatEd3rfoJM2oDBP7Cd6r8
	+ehJIiNzOAPwbuLcIcrE6VcE9FTAX6Q=
Date: Mon, 5 Jan 2026 10:20:33 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v3 6/6] mm: khugepaged: set to next mm direct when mm has
 MMF_DISABLE_THP_COMPLETELY
Content-Language: en-US
To: Vernon Yang <vernon2gm@gmail.com>
Cc: lorenzo.stoakes@oracle.com, ziy@nvidia.com, dev.jain@arm.com,
 baohua@kernel.org, richard.weiyang@gmail.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, david@kernel.org,
 Vernon Yang <yanglincheng@kylinos.cn>, akpm@linux-foundation.org
References: <20260104054112.4541-1-yanglincheng@kylinos.cn>
 <20260104054112.4541-7-yanglincheng@kylinos.cn>
 <bfb6f8ca-fa17-4ce8-a2b5-09155c50cb22@linux.dev>
 <CACZaFFM4mk71KDu9g6Fb8qBL3+5cMuZOfVUzQ+eb36q9BeKn8g@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <CACZaFFM4mk71KDu9g6Fb8qBL3+5cMuZOfVUzQ+eb36q9BeKn8g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: AA12FA0007
X-Rspamd-Server: rspam10
X-Stat-Signature: gjtrqsbqdyop5bchnazh5qz8jmxom9sk
X-HE-Tag: 1767579648-399960
X-HE-Meta: U2FsdGVkX1/4blQKkoAslXe1jwn9FBJSTm+WkzBng8D9D1fOPh0nlFQo2hjbUF5L+0HkEK5kx4W4fneqk8403J4CFtX5vqloX+THSVhwn+fgf3LN6K+k/8N6R+kQpNcLiLMaWTM8wDplyutvsts6WormxK2bOqhA8Z/TcRCOEvuq3/H+8RgHx4r+bIDUJq0r2Tj0l4QOPTRIG4NLd0J+jYyN28HXI+90zLxu72qlNRWH4kNCa4qN6P2zqTlDwmihPgsBGY0uGpiFqvvI05cc3j/f/sLJI+YToj4OmLvzLydwANPEU0c7mnwPEdHQ0yvP+wV8uvukL3YF4U7eW4zKj9BqeQ777wgUnOpeB3zjmBKYwg/plcl6oPQPZOEmKfm3ipnCQGrLqKORYmUiB/eGHce9u3zT8C878sTe/L8Cb/otmQAXsR6nYogl+bDj64NyDyEQdmTynt4SkNmTvOS4uGGia0yT4fjt84qynLeqc0GLZkAHHxJ8Nx+q5Vy7uQLycqEIR7WnaUV4mCMaMyoiIMqkMiNsR1pKIklXwbR60/beeFJJ1+HQqKe4jSWO6uZlTzxkk1NcGqY+QsdHputKUhIugbnb5b2SyfZtPMIuaRP+hofawYyskcCHsbSOT+4ffMpOpO5vWp3+YgTxP78SaflqVaA45E+mhJ2Xyi3o03PBUPA80zANy54LLInzs4i1bKY1pxKWr0eTMNWzFvm4MRtY/89a8jlnmtFCh90L0WPFfB0Sq1E5kjRjWRFyXPWu8PFKPmoaznqqJxprO6YBRYfJKdtrx4j5xMMUfxjRs3d23eNtWDHDvr5p1uBdcATriIDZi4S2B4t87KGGpM80RlDjBPhDYBi829xiu3PtAPTA1iorTxeEkvn2Fr5laJYfja3vZmLLC0DZm7Ijm6AZDCigDl71eyPfpWy2LJlpfybXZsxcNBvJQiDgEUXqTU83
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/1/5 10:06, Vernon Yang wrote:
> On Sun, Jan 4, 2026 at 8:20 PM Lance Yang <lance.yang@linux.dev> wrote:
>>
>> On 2026/1/4 13:41, Vernon Yang wrote:
>>> When an mm with the MMF_DISABLE_THP_COMPLETELY flag is detected during
>>> scanning, directly set khugepaged_scan.mm_slot to the next mm_slot,
>>> reduce redundant operation.
>>>
>>> Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
>>> ---
>>>    mm/khugepaged.c | 2 +-
>>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>>> index 1ca034a5f653..d4ed0f397335 100644
>>> --- a/mm/khugepaged.c
>>> +++ b/mm/khugepaged.c
>>> @@ -2541,7 +2541,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
>>>         * Release the current mm_slot if this mm is about to die, or
>>>         * if we scanned all vmas of this mm.
>>>         */
>>> -     if (hpage_collapse_test_exit(mm) || !vma) {
>>> +     if (hpage_collapse_test_exit_or_disable(mm) || !vma) {
>>>                /*
>>>                 * Make sure that if mm_users is reaching zero while
>>>                 * khugepaged runs here, khugepaged_exit will find
>>
>>
>> Let's convert hpage_collapse_test_exit() in collect_mm_slot() as well,
>> otherwise the mm_slot would not be freed and will be scanned again ...
>>
>> static void collect_mm_slot(struct mm_slot *slot)
>> {
>>          struct mm_struct *mm = slot->mm;
>>
>>          lockdep_assert_held(&khugepaged_mm_lock);
>>
>>          if (hpage_collapse_test_exit(mm)) { <-
>>
>>                  hash_del(&slot->hash);
>>                  list_del(&slot->mm_node);
>>
>>                  mm_slot_free(mm_slot_cache, slot);
>>                  mmdrop(mm);
>>          }
>> }
> 
> This patch just reduces redundant operation, For a detailed
> discussion[1].
> 
> You already commit 5dad604809c5 ("mm/khugepaged: keep mm in mm_slot
> without MMF_DISABLE_THP check"), I assume there is some problem here,
> e.g. not can readd? data-race? etc. Can you explain the root cause? Thanks!

Ah, I didn't fully recall that ...

Maybe I kept the slot because it's hard for khugepaged to re-add the mm 
later.

But looking at the code again, I'm not sure if that was the right call :(

> 
> [1] https://lore.kernel.org/linux-mm/CACZaFFOvDad09MUopairAoAjZG6X5gffMaQbnfy0sCHGz8xSfg@mail.gmail.com
> 
> --
> Thanks,
> Vernon


