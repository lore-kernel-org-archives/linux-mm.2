Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5248A606A319
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 06:41:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=N+oJ76um
Received: by kanga.kvack.org (Postfix)
	id 5FA6A6B02A7; Thu, 22 Oct 2026 02:41:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 583C56B02A9; Thu, 22 Oct 2026 02:41:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 44B896B02AA; Thu, 22 Oct 2026 02:41:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2246B6B02A7
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 02:41:21 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 30EA98070B
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 06:41:20 +0000 (UTC)
X-FDA: 85349315520.12.2E41891
Received: from mta0.migadu.com (out-115.mta0.migadu.com [91.218.175.115])
	by imf06.hostedemail.com (Postfix) with ESMTP id DBD1C180002
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 06:41:17 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=N+oJ76um;
	spf=pass (imf06.hostedemail.com: domain of hongfu.li@linux.dev designates 91.218.175.115 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792651278;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x5cC4bmi1LKVIll0p6WalymoOj1ixHoJ2jljfs60WTc=;
	b=aodxnZmUcRmYr0ehudY1HYOr7KBPZYZnCXQjDsF04g9IXXtmSe01TPSKNm0LHkd4maFBjQ
	pvJSbNZ8ztstJKMZmN7fXIlTO4VrUTQEjjaJqZ5Behiq6HKAoVIq/jfiVDaPMEJUN6NYs0
	X8KWIIlq7qTZ0x5im0qZ3v982mrMHWY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792651278;
	b=QAFgLherIfr4NpmztJVQkFTzH64gVg/erllqMalD2LJ0U+DDrietQ1nOf4IUYIFL2Fc4NI
	YEuYlxQkA7esuIC5Kb7X3Ute5Y8ZEk2R1IgNB2ED7yjTU1YhORRHxpFp3gB0p0tLiIlCaP
	iIUiq5J5FBfAT7eG97zgh+mbVshZfKE=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=N+oJ76um;
	spf=pass (imf06.hostedemail.com: domain of hongfu.li@linux.dev designates 91.218.175.115 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=OLTnmAJnENmvYIgzwFrHsxjbV8AYtnhE58dfnwOrMs4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792651276; v=1; x=1793256076;
 b=N+oJ76umw01HY4hVxuGj1mZP4UQuEfqcgCQ5LNfQ3ikegYkjGJCLLrSFJCqHqeVCmUWxNijQ
 dnFWUcJox1qL9q9U1kDmrcqA4BCZain42Zu2WOjhpl329CKz7B5UFGoToArwsyNA/IMy+pVY8MO
 B4GmjBbHaiBySkjj8mzPvrQA=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 86280eea6ba8db01;
	Thu, 22 Oct 2026 06:41:16 +0000
X-Mizu-Trace-ID: 86280eea6ba8db01
X-Migadu-Flow: FLOW_OUT
Message-ID: <8cac0284-a43d-4c3c-b59a-dccdadf7b75b@linux.dev>
Date: Thu, 22 Oct 2026 14:41:03 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: hongfu.li@linux.dev, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>,
 Vivek Kasireddy <vivek.kasireddy@intel.com>,
 Steve Sistare <steven.sistare@oracle.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Hongfu Li <lihongfu@kylinos.cn>,
 stable@vger.kernel.org, Daehyeon Ko <4ncienth@gmail.com>
Subject: Re: [PATCH] mm/hugetlb: charge hugetlb cgroup and memcg in
 alloc_hugetlb_folio_reserve()
To: Andrew Morton <akpm@linux-foundation.org>
References: <20261020-for-alloc_hugetlb-1020-v1-1-e6eac82dd754@kylinos.cn>
 <20261021165918.da553bb0879c110847c232f5@linux-foundation.org>
From: Hongfu Li <hongfu.li@linux.dev>
In-Reply-To: <20261021165918.da553bb0879c110847c232f5@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: DBD1C180002
X-Stat-Signature: 5ao983i7pnie76z5fjixhj5rk8wsumwi
X-Rspam-User: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1792651277-286585
X-HE-Meta: U2FsdGVkX1/cNxSMEiMrOiG/iZenRKL1HHkixEGe4VKRv4232ayIPG6fNQMPO4b9tHMiH1NRLIyrvM/ORcyKLV4iSSgyMhxQtFYyg3jAlyEiplhbB4TO6gXuvVtpAS3FtoBF0ZuBEXuwOVwoJ2p5we8nvnhrPS5jvDRZOsUsaeNWNMxY0w2yal8GwyuU46Ww9ZBxu1MbkYGVRvDLp3WRFgiUM6265MQCcYADzMjOmkUZLssLn3ayUkj5gS/UUJ2Kc9JdCLIXyNOMFs5xa0YMsx/pbCxIcAyrsAMXGMpbFLcAOqMw4X6jgJq6e48k+ylqjMv7o20rPcW9IeO5N5E+TR9wktlmPVcdhKmlQCgg7i3I6IVLD+7JOmZ5Ym5rAqhg4p3SqoGge/a4/ioZ0eZJDnIcUyrHKyXoSX4SQ8w7SwLOreHt7bYQkXq/aYoFN3YQrVTzOF4D527ScNMy5qlkk7hm8nYF3yn44Jt3d+XYGy6/E4iR56uAn1vRYEXRXUQVrDG8WYSiKZBfDcOaZnMDic0uzuursXcVszqXFmR4ZyBKgnF1es8noYMR6x+bUbI8GbLntbu5Sy00f+cNGpt+vOtsSFoy3TXsUtzkIdAT0mraJbhZTm4kWa2i2pdQCFHE+fgWNbfwqlYBymuVujkOzxuloYTPHluDqGnbGcKfuzKBiCoyHcKiCSZU2g1p7J6iM7lW2n83CypQ8UFWib3SRuxiDd7Guq4vXtjX7mUWrc5wsKUdDqpVbTOdptVFRN8E4roKVFoUvFpeWIZrJCknz80+7WvNqTZdwt4FSrJqPsdlThKOCro9LEPHm454LbW4nsParrqYVlWeyPdQtODn+jmtc1FTIsvSfm37BrnBVhfopQ182i+uMlPoD9oO5LWm70j0QpJwysk9x/KwfHd6czH+utU5SsUpqjGK5kVbmXsUl0Xbc59sP81OwPyth7VE80G8LWpDvWE2rJjQ4Wf
 Z79xLP/0
 1SGHIGONBTKv5VN//sNMKivMGp/OpyrhF0Qij2JCk0kpkpT//+RZxY2sIrzAdy3Ip5fzLIzhOelbDdn9nC4tHyLayUCvl4OXfvYA1S0Nx3N7TJGYm7N+sNFidyCJ6ER4IRQN+iTFgLsl8o7UVCTzQLDlBmY2GH28pqmugpuRKfh5xFEnCtNR4E6ohFjIt1757B/PpctR3coqIh/tAY5S9GBdExgapWL0iWDoKXyOxS9IMgVOQevG28uk+6nS8dzpU4PH1weO48wlyrazrIHsxYJ2eoG0Kd/e/hNXCWbQHlxjokZwex2P3NckjGMRtAkXxJJ99Qc7holPqEqdZOugzhD6OlRI+5g+Y4HnGeo2Q27SyTUSY8vXC8RdX66PVTh6YpTGmffG2LERwdDE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


On 10/22/26 7:59 AM, Andrew Morton wrote:
> On Tue, 20 Oct 2026 16:46:30 +0800 Hongfu Li <hongfu.li@linux.dev> wrote:
>
>> From: Hongfu Li <lihongfu@kylinos.cn>
>>
>> alloc_hugetlb_folio_reserve() hands out a folio from the hugetlb pool and
>> consumes a global reservation, but unlike the fault path it never charged
>> the folio to the hugetlb cgroup or to the memcg.  Folios allocated for
>> memfd_pin_folios() through memfd_alloc_folio() were therefore silently
>> bypassing the accounting: they are never charged to the hugetlb cgroup
>> usage counter (hugetlb.<size>.current) nor to the memcg (memory.current),
>> so both limits (hugetlb.<size>.max, memory.max) are bypassed.
>>
>> Charge the folios to both the hugetlb cgroup and the memcg, just like
>> hugetlb_alloc_folio() does.
>>
>> Test with a process that creates a hugetlb memfd and pins pages through
>> UDMABUF_CREATE. The counters were read while the folio was still pinned:
>>
>> Before this patch:
>> $ echo $$ > /sys/fs/cgroup/test/cgroup.procs
>> $ ./memfd-alloc-folio 1 &
>> $ cat /sys/fs/cgroup/test/hugetlb.2MB.current
>> 0
>> $ cat /sys/fs/cgroup/test/memory.current
>> 1351680
>> $
>>
>> After this patch:
>> $ echo $$ > /sys/fs/cgroup/test/cgroup.procs
>> $ ./memfd-alloc-folio 1 &
>> $ cat /sys/fs/cgroup/test/hugetlb.2MB.current
>> 2097152
>> $ cat /sys/fs/cgroup/test/memory.current
>> 3313664
>> $
> Thanks.  The before-and-after output is useful.
>
> However there are potential interactions with Daehyeon Ko's
> "mm/hugetlb_cgroup: prevent use-after-free during cgroup offlining".
> https://lore.kernel.org/20261020100345.1677643-1-4ncienth@gmail.com
>
> Your patch adds another caller of hugetlb_cgroup_charge_cgroup(), which
> has the cgroup-offlining CSS lifetime race addressed by Daehyeon Ko's
> fix.
>
> An existing memfd reservation can belong to cgroup A while the task
> pinning the folio belongs to cgroup B. A's reservation CSS reference
> does not protect B's usage CSS across charge and commit.
>
> Also, the accounting bypass predates 26a8ea80929c.  The original
> memfd_pin_folios() implementation already used an uncharged allocator,
> so the Fixes tag should reference 89c1905d9c14 instead.

Agreed, the bypass has been there since memfd_pin_folios() was
introduced. I'll update the Fixes tag.

> The memory.max claim should be qualified: HugeTLB accounting in memcg
> is conditional on the cgroup v2 hierarchy's accounting configuration.

Right, I'll qualify that in the commit message.

> Daehyeon's fix is in the pipeline at present, awaiting a minor fixup
> and maintainer review.  Everything is rather swamped at present.
>
> So please assume that Daehyeon's fix is present and rethink your fix on
> top of that?

Sure, I'll rework the patch on top of his fix and resend as v2 after his
series has been reviewed.  I'll re-run the test with both applied before
sending.

-- 
Best regards,
Hongfu


