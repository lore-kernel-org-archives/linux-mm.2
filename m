Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7187FF887E
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 18:21:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 137196B00A3; Wed, 29 Apr 2026 14:21:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10E376B00A4; Wed, 29 Apr 2026 14:21:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3F906B00A5; Wed, 29 Apr 2026 14:21:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E2F896B00A3
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 14:21:44 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 83FB11203AB
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 18:21:44 +0000 (UTC)
X-FDA: 84712411728.02.2F95AAE
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3764740007
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 18:21:42 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PKd2b15s;
	spf=pass (imf12.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777486902;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Dxp2OvQZDPavnweLX6lwyfQ94IEOmBtp4q9eBxrMuPM=;
	b=39Mvsx5OU2i6ANmiqQT3m/binIqXijWQ2QvpW/Ers+82Fn/21MRptLU5WViFKdNptzsQTW
	d4qGuSwO5AuXmVAlzhYA1kuY3JouQv1diUcXOtIXdPbOlVJg7hNiWmcTl90/Ooo9AZFXRp
	xp6KaeApbCqHI9yW3SGPJUZZsSb697Y=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PKd2b15s;
	spf=pass (imf12.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777486902; a=rsa-sha256;
	cv=none;
	b=cuqB8AcCIegWoQHf8/E4KAZpPLjHNZ6MNx9UufdwUWJMfHmuPQoZcSQjJnhorNI03RfuMR
	PiyFUK+Tq5wCkMy9LAAl9yrfmq/mA/R3HutkvyiQciS+WRyvWyUt81d+r75XAE0Q6822w2
	SoTCbBMBpAxVkmZGC/AhPHFRdgDmtRU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777486901;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Dxp2OvQZDPavnweLX6lwyfQ94IEOmBtp4q9eBxrMuPM=;
	b=PKd2b15sYmlUuc15dgZ8pGIfYJ4vOS/vLpIaS0+VmutNquf+sjaN/7kh2uN9LtSxE2sM/X
	toIgdrfYs3OVQiqTCFlCebJinTH/oBJtAxroMX7P73+2JqC4I85IL2skzEL/P1qe8/jazL
	tnHGQKqkdGcVE6qi2N1OMv5gU05/kvw=
Received: from mail-yx1-f72.google.com (mail-yx1-f72.google.com
 [74.125.224.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-196-8fKghfVLPvqp6hlnK1YoTg-1; Wed, 29 Apr 2026 14:21:39 -0400
X-MC-Unique: 8fKghfVLPvqp6hlnK1YoTg-1
X-Mimecast-MFC-AGG-ID: 8fKghfVLPvqp6hlnK1YoTg_1777486899
Received: by mail-yx1-f72.google.com with SMTP id 956f58d0204a3-651bd9b4bccso51592d50.3
        for <linux-mm@kvack.org>; Wed, 29 Apr 2026 11:21:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777486899; x=1778091699;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Dxp2OvQZDPavnweLX6lwyfQ94IEOmBtp4q9eBxrMuPM=;
        b=Gh7uqSOL9tI9WAFlGehjRl0CLImkDNE/XHQZNQVGHNIWWJhHaAjCJTkrG/3sjN2g0r
         v4Oe5fh6/zviah5UixD9TJtO5aZ81o61jnDIqXrI/Cgs5Uo7Z3TZ5+07+wIR8YWw+sVK
         icFON3e0FBMgqKCfsnRxUksQRE7aybloww6lyIf8UPTuWaRQ9lwP7a8Q1kiNqMqRvIfZ
         HNSqsxX+BGv1rebhQfmt0qzFKvyzxWbnr+YHhrz950GY0mu8jIEd2jmVDEHxI67CwLsM
         /GpGhTOnLV0dgxoGtc5FIYNYIz8angSGfZFJkVt5yyVXH2U8QvuOAlaadtWT8yEbD4hT
         h8pg==
X-Forwarded-Encrypted: i=1; AFNElJ/dSAOLK+DPe+LKzUFuhtq9LP/lkl6LkUfaOpsfYWH5d+gEmgRAshEzpW3IV0/oTH2GH3mhCxxgPA==@kvack.org
X-Gm-Message-State: AOJu0YxakfisL7plEFupeVYqrytsRyANwR0Cfs6N/pnASmbwer4DC/VM
	cQiEIlHe1IEeZjMTEXIDarXZpzW3gfHmnKtOS/ZXaIy4hsSLGLBmP1TWpRfRX5ivNYed4tAeHQn
	JE4kESxzsEL1dOUyXrr4CFqidN4O56cvp0iu6KO4z6Fu1rQAmWKiwXFtRzfq06L3Ph5w9DnDbaY
	u7p+b7Y5UZN1VP4UMfncT1vvT0MAQ=
X-Gm-Gg: AeBDievpKUn2s50lduGkwni7iaIFjldNswxSkD0tsvjdUq/0+Po9t96/Q0R9DW22SOZ
	Nx12uBVlnv5FQXu5aoJSqvJFmoUZH8q2pRp8SwuCGlVtuuf7R9nGG7ZUgQqoQXQGThG02kpG+Zk
	FOiPIP+l8C5D+s6gS6W2ofl+vGd81IfEpVvqGl8O7+zAa3/pJdtlCfH1vhkcwMZysgH3v60fAEU
	EsrbkLL2lrqm3CeiV6T81fu1jbBg27m8aUtQZ8eiIKknBp31m0=
X-Received: by 2002:a05:690e:118a:b0:651:d047:caf5 with SMTP id 956f58d0204a3-65beeba82dbmr8444917d50.0.1777486899072;
        Wed, 29 Apr 2026 11:21:39 -0700 (PDT)
X-Received: by 2002:a05:690e:118a:b0:651:d047:caf5 with SMTP id
 956f58d0204a3-65beeba82dbmr8444840d50.0.1777486898433; Wed, 29 Apr 2026
 11:21:38 -0700 (PDT)
MIME-Version: 1.0
References: <20260419185750.260784-1-npache@redhat.com> <20260419185750.260784-8-npache@redhat.com>
 <f05f4506-2930-44ba-918a-e0e5bcb9d0f9@kernel.org>
In-Reply-To: <f05f4506-2930-44ba-918a-e0e5bcb9d0f9@kernel.org>
From: Nico Pache <npache@redhat.com>
Date: Wed, 29 Apr 2026 12:21:44 -0600
X-Gm-Features: AVHnY4J7CcVYR4f6zugXAbo8lWmkYfpdhB-nBSIbQmMf8QVrNFkAXtwT9seofNU
Message-ID: <CAA1CXcA-YtEiWYZaBW05Y9B_JMixu4SXaQO9KZoG-hNCF9oPHA@mail.gmail.com>
Subject: Re: [PATCH 7.2 v16 07/13] mm/khugepaged: add per-order mTHP collapse
 failure statistics
To: "David Hildenbrand (Arm)" <david@kernel.org>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org
Cc: aarcange@redhat.com, akpm@linux-foundation.org, anshuman.khandual@arm.com, 
	apopple@nvidia.com, baohua@kernel.org, baolin.wang@linux.alibaba.com, 
	byungchul@sk.com, catalin.marinas@arm.com, cl@gentwo.org, corbet@lwn.net, 
	dave.hansen@linux.intel.com, dev.jain@arm.com, gourry@gourry.net, 
	hannes@cmpxchg.org, hughd@google.com, jack@suse.cz, jackmanb@google.com, 
	jannh@google.com, jglisse@google.com, joshua.hahnjy@gmail.com, kas@kernel.org, 
	lance.yang@linux.dev, Liam.Howlett@oracle.com, ljs@kernel.org, 
	mathieu.desnoyers@efficios.com, matthew.brost@intel.com, mhiramat@kernel.org, 
	mhocko@suse.com, peterx@redhat.com, pfalcato@suse.de, rakie.kim@sk.com, 
	raquini@redhat.com, rdunlap@infradead.org, richard.weiyang@gmail.com, 
	rientjes@google.com, rostedt@goodmis.org, rppt@kernel.org, 
	ryan.roberts@arm.com, shivankg@amd.com, sunnanyong@huawei.com, 
	surenb@google.com, thomas.hellstrom@linux.intel.com, tiwai@suse.de, 
	usamaarif642@gmail.com, vbabka@suse.cz, vishal.moola@gmail.com, 
	wangkefeng.wang@huawei.com, will@kernel.org, willy@infradead.org, 
	yang@os.amperecomputing.com, ying.huang@linux.alibaba.com, ziy@nvidia.com, 
	zokeefe@google.com
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Mm2ivJ5leZvGxbGJ4-vv-qFwETnU-zJkf-k48YuYabw_1777486899
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 3764740007
X-Rspamd-Server: rspam06
X-Stat-Signature: ts6oq4yn8557ttph31obhn1rsdqhkj75
X-HE-Tag: 1777486902-135751
X-HE-Meta: U2FsdGVkX1/bke5/1CkMBxD0BPp3nTv7eMcPdJfyAEEr4MtMR4H4XgMP2QSVpAorMqSkV3UqncWVZpjHusSYmQaDpVLqbcGkqd7Viz6M5XP3blcUxCNL2dOieWDZ1DOVdTRJu+sYV3raja2rTfu3pOb1UYHHC3A0vaqFJqpePF+iV+fdKejhij8F7YG8nFykuC7R5l7OrkK/tmbcZzNvx/zAsahqYOrNMlLjXsk/TYKmcWvdyWZRcHMXhZ7G7y9Bwm1YVVWjV1RiZNvEhFaiylbvVr+HLCLQ250L9FqcLhdzgXs+KAgE2XZ00+4zcABe+V6LwGSNEwFUaWjDpk5nF2H/jmldZfMbEftNHZP/ezyHlRAnquuY23d7UUSubVAjWexVyDb6azQiMQDMohXZ1noZzMQwue/+smyGukbWXcYKSYbvUcpPPXn8fYmJgYylPr4C23XvyFFueBc+qKOkI7lyPMogwgOxGBCfmzTrOgWPkkacYQnYunBwvrBfVIhdAhUAa4/ERqjaPXvzVj8aPTpfstw1tPKat2Sn1lJwWQ2/gtVT6lrqRiM+gHn8DDbKInWhY1A1HavFzdPZvjX/bpYdlCtMjUNge8iZC3DBaRdmHX3wC6p4HMU/FlVr5ye+/HZeDFkbDZt7EkUnW5yqI19Hino88DurWF8H/WIsbP9H/xLkxEqLqgkk47V/CvhisFxDRvubI6ytSXKq363KQVCOrIlUntkkTHWQwV6b4raCcgILX1GcYvkVpAXX2ntaH4NlmKO9ntg/kNIuH0PCjRDYcRlyAo1hG3Cvh5aGka0cTfoWAZlapoQCnedD1O1K0tQ8UNEq25HX9oVFflstzgmsWLM7HfmAppbc7dHVjsh02MAdbHlLMzIc84hcoiVrcpoAPqbyCL4fyqADkJMp083fII1Tvc3hKOlC5DGUksCddhM/sYFDPaiXO1Pf7NYyVkCyD34EAiQS9ojxl1+
 HNX8zdJY
 NPckjSWL9oXyAk5QWMnbgtlNBm4LYvFEmfR9kBpMYAjRgwEVVrtxt/ysUOw6J48dNtuofzgOC2Sz2HyAriUrp8K3rWZpzupIx9M11aygCP4h/zz95F6cdBvRA4HzIeYNXfjFHjMh58sKTxs+KwWIoaC6QG13iKkKjhk8VcrEGnOAKcQhuxxzQMbhh76rSV3rTGT3pxP+S+1HHcuolXAIw992vHOUHzK8RFX3BJNimA7BTaRxCh+PmP//idVIbVh7/MrgO5HsNM3R3oUbxi+XWGozbj85HiezWfn/Q77BJfu1qu9OkRIg7GNPF4zHjId8WjOAbs/uaH8+Je8Q++F+Tr5zjdblsrHtZ7WtFcHPqd1QBXmIEFNVlQIdK7TCM5VpQswCw/MZsPWDFZVg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/27/26 2:21 PM, David Hildenbrand (Arm) wrote:
> On 4/19/26 20:57, Nico Pache wrote:
>> Add three new mTHP statistics to track collapse failures for different
>> orders when encountering swap PTEs, excessive none PTEs, and shared PTEs:
>>
>> - collapse_exceed_swap_pte: Increment when mTHP collapse fails due to swap
>>      PTEs
>>
>> - collapse_exceed_none_pte: Counts when mTHP collapse fails due to
>>      exceeding the none PTE threshold for the given order
>>
>> - collapse_exceed_shared_pte: Counts when mTHP collapse fails due to shared
>>      PTEs
>>
>> These statistics complement the existing THP_SCAN_EXCEED_* events by
>> providing per-order granularity for mTHP collapse attempts. The stats are
>> exposed via sysfs under
>> `/sys/kernel/mm/transparent_hugepage/hugepages-*/stats/` for each
>> supported hugepage size.
>>
>> As we currently dont support collapsing mTHPs that contain a swap or
>
> s/dont/do not/
>
>> shared entry, those statistics keep track of how often we are
>> encountering failed mTHP collapses due to these restrictions.
>>
>> Now that we plan to support mTHP collapse for anon pages, lets also track
>
> "We will add support for mTHP collapse for anonymous pages next; let's also ..."
>
>> when this happens at the PMD level within the per-mTHP stats.
>
> What about file collapse? For example, we do adjust
> count_vm_event(THP_SCAN_EXCEED_SWAP_PTE) and
> count_vm_event(THP_SCAN_EXCEED_NONE_PTE) there.
>
> Wouldn't we want to update the HPAGE_PMD_ORDER side of things there already? or
> would we want to use a different counter for that?

Maybe? My thought process was that because we dont support mTHP in Shmem
that those stats shouldnt be updated? not sure the right answer tbh--
hence why this comment says "now that.. for anon pages, lets track..".

>
>>
>> Signed-off-by: Nico Pache <npache@redhat.com>
>> ---
>>   Documentation/admin-guide/mm/transhuge.rst | 24 ++++++++++++++++++++++
>>   include/linux/huge_mm.h                    |  3 +++
>>   mm/huge_memory.c                           |  7 +++++++
>>   mm/khugepaged.c                            | 21 +++++++++++++++++--
>>   4 files changed, 53 insertions(+), 2 deletions(-)
>>
>> diff --git a/Documentation/admin-guide/mm/transhuge.rst b/Documentation/admin-guide/mm/transhuge.rst
>> index c51932e6275d..eebb1f6bbc6c 100644
>> --- a/Documentation/admin-guide/mm/transhuge.rst
>> +++ b/Documentation/admin-guide/mm/transhuge.rst
>> @@ -714,6 +714,30 @@ nr_anon_partially_mapped
>>          an anonymous THP as "partially mapped" and count it here, even though it
>>          is not actually partially mapped anymore.
>>
>> +collapse_exceed_none_pte
>> +       The number of collapse attempts that failed due to exceeding the
>> +       max_ptes_none threshold. For mTHP collapse, Currently only max_ptes_none
>> +       values of 0 and (HPAGE_PMD_NR - 1) are supported. Any other value will
>> +       emit a warning and no mTHP collapse will be attempted. khugepaged will
>> +       try to collapse to the largest enabled (m)THP size; if it fails, it will
>> +       try the next lower enabled mTHP size. This counter records the number of
>> +       times a collapse attempt was skipped for exceeding the max_ptes_none
>> +       threshold, and khugepaged will move on to the next available mTHP size.
>
> Why is everything after the first sentence worth documenting here? This doesn't
> read like it belongs to a failure counter?
>
>> +
>> +collapse_exceed_swap_pte
>> +       The number of anonymous mTHP PTE ranges which were unable to collapse due
>> +       to containing at least one swap PTE. Currently khugepaged does not
>> +       support collapsing mTHP regions that contain a swap PTE. This counter can
>> +       be used to monitor the number of khugepaged mTHP collapses that failed
>> +       due to the presence of a swap PTE.
>
> Can we similarly simplify that (and make it consistent with the one above) to
>
> "The number of collapse attempts that failed due to exceeding the max_ptes_swap
> threshold."
>
>> +
>> +collapse_exceed_shared_pte
>> +       The number of anonymous mTHP PTE ranges which were unable to collapse due
>> +       to containing at least one shared PTE. Currently khugepaged does not
>> +       support collapsing mTHP PTE ranges that contain a shared PTE. This
>> +       counter can be used to monitor the number of khugepaged mTHP collapses
>> +       that failed due to the presence of a shared PTE.
>
> Same here
>
> "The number of collapse attempts that failed due to exceeding the
> max_ptes_shared threshold."

These all used to be very similar to what you have here. But Lorenzo
asked me to expand all this (IIRC) several times. So here we are! I
believe I even mentioned in the V15 that these are probably the "best"
defined counters in the whole doc lol.

Cheers,

-- Nico

>
> ?
>
>> +
>
> [...]
>


