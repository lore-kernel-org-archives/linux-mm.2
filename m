Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35854CA101F
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 03:36:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D43E8E0006; Sun, 14 Sep 2025 23:36:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 884D08E0001; Sun, 14 Sep 2025 23:36:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 79A418E0006; Sun, 14 Sep 2025 23:36:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 672C88E0001
	for <linux-mm@kvack.org>; Sun, 14 Sep 2025 23:36:42 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 19754160423
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 03:36:42 +0000 (UTC)
X-FDA: 83890072644.06.9DDAED8
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	by imf25.hostedemail.com (Postfix) with ESMTP id F07BEA000A
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 03:36:39 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tBNKvV6S;
	spf=pass (imf25.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757907400;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XOq3tAKiSS4SZqaYiFMa6a3N6kv3gCmuXSnB/b8DG10=;
	b=FUsc3tz2vNplHR3uhHLnBApgFg3mReAwTeOURLAIpukpIwxokxMFp0KshmAQm8vKjv/p/I
	+cZfgbkeNp5C7H16zkA+X05ynFfZE/4wwF3v09PJ/aUgCtMh0S/RkMzj21hoEd2OURJK5B
	x7OWu3L1ecbR2+c+JVCULSiACzIsGeE=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tBNKvV6S;
	spf=pass (imf25.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757907400; a=rsa-sha256;
	cv=none;
	b=vOYsBFPlDPqzgTxBHOXLk6ZbPJ4paKC1GFmcRFPZdW2haqcZOqmlAajRRyK2JGMo16etpu
	F4atCGh5Vl+cGZqVqDIgSEMo2lkwKSsu41F9spVME+GIYCcD98nbchqvglofbtyJLH1l6s
	nF5Xesf8XRdcfovR5xGWsCXaAyhdRbE=
Message-ID: <c9d4d761-202f-48ce-8e3d-fb9075671ff3@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757907397;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XOq3tAKiSS4SZqaYiFMa6a3N6kv3gCmuXSnB/b8DG10=;
	b=tBNKvV6SZaIls4AXk4gIFyG3o230C77+N2DZwtS9pXCUvz6lsvQeQHICJB9R5dxFrK8gM8
	uXnIAkjTZJ0S+mF6qaMqKrZBiG9lw68joa3qKdLmq/yfOJvP/kdOIrP3s/CJ/A6NjZS93q
	tpUnkLgdwseB7YLAZGp+rMcdf4pG3/w=
Date: Mon, 15 Sep 2025 11:36:29 +0800
MIME-Version: 1.0
Subject: Re: [PATCH mm-new 3/3] mm/khugepaged: abort collapse scan on guard
 PTEs
Content-Language: en-US
To: Dev Jain <dev.jain@arm.com>
Cc: ziy@nvidia.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
 npache@redhat.com, lorenzo.stoakes@oracle.com, ryan.roberts@arm.com,
 baohua@kernel.org, ioworker0@gmail.com, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, akpm@linux-foundation.org, david@redhat.com
References: <20250914143547.27687-1-lance.yang@linux.dev>
 <20250914143547.27687-4-lance.yang@linux.dev>
 <750a06dc-db3d-43c6-b234-95efb393a9df@arm.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <750a06dc-db3d-43c6-b234-95efb393a9df@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: F07BEA000A
X-Stat-Signature: hamtwyxdfhykd7nxcpkbe5r4y66daneb
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1757907399-91213
X-HE-Meta: U2FsdGVkX1+v0zg6vcbJLtEhwRsqPzFwOpoCqeFWGbC+mKI7iRI3DMynOAw6WQZNP5lHWg7vLlDuDXa5Fvn1voPxwhmFsAPOJExtEJWy2uq7gsGdbBDHxJwYYzHZZ70vuYaJtBz7tmKrb3RBSscHBEc6k5rXrcJSP9JhUzKeSw5u0BV7Rlv9dCm6mWnYNMULKbfDp5wKcM9wZHXlkN4NKoEmyzXgYG5au0gsQwuurtc4a3zlmBUpc4sAJl3XSrk9/taCWQZgrXacLr5Jh1WfxlEvBnOm5HgclHx/HQt+N74lX8kUcHxk2p1O211dSXlXDs738aD5QVjWR7G2KI91n6HmUR5ait8jl6qaye69a3bxtJuA3xF+RkcSFZ+TOrshUXca7AKH00oJai8ms64OYnn/BSGCmUpnkEUzD6mk2EFWCWkCGoyf3O52lAX/9V21ZOHofOVLqE0NBXpCXwOdrGGIbpUBHnhvIZtexj61gYF6VbqP+/wtObL4Xn2gG5D+sqnqVy3Gi/NBmX8N9ITnKzE6kppynucv4xaxd1hu2A0XEmLg95zfyaVSCjE3Hc/sP5qjSDSwfDEpq2pF4jYmD6jYUhUp+SHL3Igv/aMnEiVu7MlmFaApCYAZScfdUzbzwaK07I86sIq0wfuwyaARwOcsNwWsCC2+LQjLYLHRtflsSzCYGg5vqNp/lnQoORo03Z9Cad30moKzXatwB7VqUJ8WFHvjG0ob7oLZ0fWeedrgzQE1e6UdFLD05+RGaH4zg04PjTjzP5NStKfDQ2xNoyLbrw+lC/9Sebe22oEGOQIxHeFSqD333eotNl7hQPlRYXYOuvnBNWdzaymVAFiKZGLxAOVFqvPS+erltO6eT4yULy6/HZDpSnlBKzNv2tRzW+kbkwsb/m8XQmkZ9KU41liqiA5XYBGgRWPgOykIUBtKo+gbynV1/g+p6PGiN/Yl/KK6sU/sp3/TruiduCW
 9GLAq6Oa
 wMKSydA+Am90SR/NW76f3iUcwkaHdp5q98RJbdJX+eBr83DIE8Ffrq0PcFf7C9Ui1wA3vXQo1UAyZbgmJpeeYmn+e8lCCFBGV3cDRTjZH0LTRwmh/FgWT9JTjZumOFqHmy4dH1jWV8+85l9T8wR6J8Qz/EEJDLu5YLrkNB5GyapzoQxjpr+PKLJRo74QqrQIOlF+Klku2g4qV20NoicWS8GVlqIR/1QMF1bLIMj6Zv/SoEhEXwvJL5ZmLnWaIX2wvtW9erjxKQuAOwdpwP7u/RmpEQ8XH+fv82/mqHPRIxeefyLNTPGfajiBOgObVNbwfG5xe
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/9/15 01:03, Dev Jain wrote:
> 
> On 14/09/25 8:05 pm, Lance Yang wrote:
>> From: Lance Yang <lance.yang@linux.dev>
>>
>> Guard PTE markers are installed via MADV_GUARD_INSTALL to create
>> lightweight guard regions.
>>
>> Currently, any collapse path (khugepaged or MADV_COLLAPSE) will fail when
>> encountering such a range.
>>
>> MADV_COLLAPSE fails deep inside the collapse logic when trying to swap-in
>> the special marker in __collapse_huge_page_swapin().
>>
>> hpage_collapse_scan_pmd()
>>   `- collapse_huge_page()
>>       `- __collapse_huge_page_swapin() -> fails!
>>
>> khugepaged's behavior is slightly different due to its max_ptes_swap 
>> limit
>> (default 64). It won't fail as deep, but it will still needlessly scan up
>> to 64 swap entries before bailing out.
>>
>> IMHO, we can and should detect this much earlier ;)
>>
>> This patch adds a check directly inside the PTE scan loop. If a guard
>> marker is found, the scan is aborted immediately with a new 
>> SCAN_PTE_GUARD
>> status, avoiding wasted work.
>>
>> Signed-off-by: Lance Yang <lance.yang@linux.dev>
>> ---
>>   mm/khugepaged.c | 12 ++++++++++++
>>   1 file changed, 12 insertions(+)
>>
>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> index e54f99bb0b57..910a6f2ec8a9 100644
>> --- a/mm/khugepaged.c
>> +++ b/mm/khugepaged.c
>> @@ -59,6 +59,7 @@ enum scan_result {
>>       SCAN_STORE_FAILED,
>>       SCAN_COPY_MC,
>>       SCAN_PAGE_FILLED,
>> +    SCAN_PTE_GUARD,
>>   };
>>   #define CREATE_TRACE_POINTS
>> @@ -1317,6 +1318,16 @@ static int hpage_collapse_scan_pmd(struct 
>> mm_struct *mm,
>>                       result = SCAN_PTE_UFFD_WP;
>>                       goto out_unmap;
>>                   }
>> +                /*
>> +                 * Guard PTE markers are installed by
>> +                 * MADV_GUARD_INSTALL. Any collapse path must
>> +                 * not touch them, so abort the scan immediately
>> +                 * if one is found.
>> +                 */
>> +                if (is_guard_pte_marker(pteval)) {
>> +                    result = SCAN_PTE_GUARD;
>> +                    goto out_unmap;
>> +                }
>>                   continue;
> 
> This looks good, but see below.
> 
>>               } else {
>>                   result = SCAN_EXCEED_SWAP_PTE;
>> @@ -2860,6 +2871,7 @@ int madvise_collapse(struct vm_area_struct *vma, 
>> unsigned long start,
>>           case SCAN_PAGE_COMPOUND:
>>           case SCAN_PAGE_LRU:
>>           case SCAN_DEL_PAGE_LRU:
>> +        case SCAN_PTE_GUARD:
>>               last_fail = result;
> 
> Should we not do this, and just send this case over to the default case. 
> That
> would mean immediate exit with -EINVAL, instead of iterating over the 
> complete
> range, potentially collapsing a non-guard range, and returning -EINVAL. 

That makes sense to me ;)

> I do not
> think we should spend a significant time in the kernel when the user is 
> literally
> invoking madvise(MADV_GUARD_INSTALL) and madvise(MADV_COLLAPSE) on 
> overlapping regions.

I'm just a bit unsure because the MADV_COLLAPSE man page[1] describes it
as a "best-effort" collapse. This patch follows that idea, collapsing what
it can.

        MADV_COLLAPSE (since Linux 6.1)
               Perform a best-effort synchronous collapse of the native
               pages mapped by the memory range into Transparent Huge
               Pages (THPs).  MADV_COLLAPSE operates on the current state
               of memory of the calling process and makes no persistent
               changes or guarantees on how pages will be mapped,
               constructed, or faulted in the future.

A hard-fail on a guard PTE marker might go against that.

Well, I'm open to either approach. What do other folks think?

[1] https://man7.org/linux/man-pages/man2/madvise.2.html

Cheers,
Lance

> 
>>               break;
>>           default:



