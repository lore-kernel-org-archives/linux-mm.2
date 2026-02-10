Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB288E94636
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 03:23:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EAB206B008C; Mon,  9 Feb 2026 22:23:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E7BE36B0092; Mon,  9 Feb 2026 22:23:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D61716B0093; Mon,  9 Feb 2026 22:23:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C27FC6B008C
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 22:23:13 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 77D2DC1610
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 03:23:11 +0000 (UTC)
X-FDA: 84427100982.17.4FC4476
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	by imf27.hostedemail.com (Postfix) with ESMTP id 79A0C40007
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 03:23:09 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=foX4CJ0e;
	spf=pass (imf27.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770693789;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Hc6QPKraklZc802qcURShhVzZIMv2vVuwuGAuOaJIEo=;
	b=j1qcJXkxa4ZvFN93tibGD5ARsFgh6HtwJ8IxNlo8Wfy5bW1ST0Qlo9xhotlB9tdIb60w9H
	84tNf3rGtJ30xzCBzozyaLsoj6BQOPIBFXtOzJfZ/hT98ecFWP/bSV4gCIQeNy4eHa/xN7
	rG0oA/Ri4BHNj5Ud3jc8CN+cBn1KZR8=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=foX4CJ0e;
	spf=pass (imf27.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770693789; a=rsa-sha256;
	cv=none;
	b=qGseGtae0T+sKS95CDF/18xY+RjcBd5m1Pdp1apUhi/euLYsw5sDJ2PwtV8pKXcBx1JShr
	4F/ZJYkBMc4CzmVTA33HA1BUhteeQu3kh/NV4aWYUjC5cf58FeUlGH2NB/kzQM66PVJJ7q
	nYWtU7i34MzKLrOovkT7/faI1HIGvHU=
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-6505d141d02so465715a12.3
        for <linux-mm@kvack.org>; Mon, 09 Feb 2026 19:23:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770693788; x=1771298588; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Hc6QPKraklZc802qcURShhVzZIMv2vVuwuGAuOaJIEo=;
        b=foX4CJ0e8rutO9/868J7XN/4bwDs3csXbC04UtQDDcaM8R6xh1LNKpb6H9AArCAmEP
         58MHrX8yErllLON2th9zjw3Cg5dUMMv5t4qpdGCIUWg/09geqzFFoA99eolLIraCnyFg
         Cfiru+GRpQRpxDYfPpZI0KJjC2iUFL5gpMYUE6rJFYa4Z1PsWEF4/FS6Z0xmKW19c4A4
         OVKOPsx5ZYJ0Oqt6INZ/mdfIuSlqvAdRNDMH1tgIwQOmb92YriWoJ4HuG747Ub4pjLO1
         EoP1Ibr++Mb4h98lVc8MGdeOuRDKSzuUKtNF/CB3DN6FmDAujWe6F4yIgcOLQcpAw6WK
         Iceg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770693788; x=1771298588;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Hc6QPKraklZc802qcURShhVzZIMv2vVuwuGAuOaJIEo=;
        b=n8JDNx5SCJCL3hZrlG5haj+NgwGGHxnJnFnd1dJa8nllqF6H2JD6nNtIDV1sf17BOx
         HeDrdNUAYrL03SUfT5iiybsONCtb+Bv7FLOFpeKDCc/yPZ7yHxux8S08e/UC/qPrpn/8
         H3DWrwgvPclAEEXNZbr4bax9C9bdBQr/GUNc/TXFUGg0TuRjiy73trqmB345UfotwU5X
         R4tVYEAbJqOcmxK2w4lfwuAocrsKbMDf7F9xce18XGPNoa/VEkFOgWPLr+Gc50P1NlE3
         wAwFkDaqiWKadE9Fqyy70mbltyOoxruELwLliYsdzcCnEc5XE3LxAau7ZZF4RHSgEEP5
         4Zww==
X-Forwarded-Encrypted: i=1; AJvYcCW6CMQ2spA62l6D36RARp9TBfpMyZiy+PtWVCjIZey9sd4ZmTKDtOhR0vx5eW58EyVX6qjDr+cYeA==@kvack.org
X-Gm-Message-State: AOJu0Yyzsw8btwwDHrRoFWiLIGjZmFALnDheWvkEZU/yCazYaJ11+bmP
	NMfrd3YkOLbLDf/kEIjueJ5A8e5CgU64r9XNMEkYJTj/GmF9s54okk/4
X-Gm-Gg: AZuq6aI2r9pwo/8pWhEXQz8FUcEispZg+bAmEoJzjiptSOwULzFzHT1NxJneItd7TDQ
	F0XIja3j8Mhztj/4sRWWPuMOESbe8EtiXlSpX9BcwcrOCzddEvzqYMKcTTy68qtsOSzNTFIJJ/i
	Gd44qQ1t1fMd8fFv+DFPrmb5+faN4OAP8YfgDCn+a/d/RkRkxQbMMrMioNxx9tfhSHNXP5cpsEs
	hANRQ/WTphwuZjpGtqLjgKIMmLs8WStNlFs8bNLclp/b3ZazHOGlOMhPv3il8vi/bDdO57QWdHk
	iVnFivLhKwwvbBBOw3ditwnnE2bynNC8XD8HT4PkshWlqUoe2d3CFb6sStfFmMFQfBhQ8qps7UZ
	S+yEC9SytiQzSJEXxReIc7W80ninyiwGeV02+AJglrR593GcS+1uxufRkV5CBwXtyiwqs36czww
	lF7E8137uvZGVeLyTQ9vwbcA==
X-Received: by 2002:a17:907:a03:b0:b87:5464:8b5c with SMTP id a640c23a62f3a-b8edf48fac1mr816411666b.63.1770693787443;
        Mon, 09 Feb 2026 19:23:07 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b8edacb1d3fsm444339366b.34.2026.02.09.19.23.05
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 09 Feb 2026 19:23:06 -0800 (PST)
Date: Tue, 10 Feb 2026 03:23:04 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
	david@kernel.org, riel@surriel.com, Liam.Howlett@oracle.com,
	vbabka@suse.cz, harry.yoo@oracle.com, jannh@google.com,
	gavinguo@igalia.com, baolin.wang@linux.alibaba.com, ziy@nvidia.com,
	linux-mm@kvack.org, Lance Yang <lance.yang@linux.dev>,
	stable@vger.kernel.org
Subject: Re: [Patch v3] mm/huge_memory: fix early failure try_to_migrate()
 when split huge pmd for shared thp
Message-ID: <20260210032304.j4k5izweewouabqb@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20260205033113.30724-1-richard.weiyang@gmail.com>
 <fbd6c31f-7f35-4986-86e3-76bf8963433d@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fbd6c31f-7f35-4986-86e3-76bf8963433d@lucifer.local>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 79A0C40007
X-Stat-Signature: bpmka6ngy1hppfcy8rb1w3c53zxkdh6p
X-Rspam-User: 
X-HE-Tag: 1770693789-810605
X-HE-Meta: U2FsdGVkX18DF3M0VFLFzi0W4jmBeBWoIVOwiFebtJejAnPobXufSTN2lKjY5okpOqFO78jToRsrzE0IRy/9hVt4K+Pmmhas9zGuNYHr+yr63DLPFbq6t54YnElDlFfAO4wdWw1eD0zbdtTDlDg2Smg52zXaHqXxA2GumTzX+KLpRrIgmw0pO+HFvLtOweVPT2RnK1+4bcnk/JXVM3oIwXR54A4gTd8CezB4gyNzpHaPjQpKRunGzXooxTRxSWCrWnONX7AhsnkqcukoSJ4431yVfe8UwCXtk9o+COam28GUCfcZjeCs9oL7E6PBYHZ8oXyan4mTBCtvs9wppFQFgXmvG8IFSDSCpKUW3RwpOZ0ptfRA/xQGAoElnLckoymyeBrwJmAJgF7OnWEuLpSgq7DFNq6GlSMIFeharbPCGWE/35IBLfRtquGF7+gCu2SxYJk+TZd5O0F30p7QgT4qsvYKgZhyYW3RQwo1nzDIdy6n6j8QYFXsIvit7OsLzshCjKUT9Mardgvm7phUsc9rQ2ZN15Nqvnu5kq0nRnvoAYyVMjCzUl9VyBNmEarz5OdTxWlsvLui7Qo7Vmv2uzBOJc94e7mFC9mQfkDMH3SHy5qIQD18J/N2uINP/3ajX9JZbhwv7X1VDLLXCyZm2W5BeowT56PblB+rbqoLgBosxPo5V3tsJn96rBLFc77ryV1WM3hG3egC/1X7QTHbkOLRAlDOSEakTpTkQylhWFzsfEEQPScDdgXnyNtFme/7/e21H6dKinlshWOmw0jEVIehgSvOngMce/6/rfLHniaX8fe81MoYZr2Zx7fmVepQR1bZ9NK2pH38XUaKc5j9bfpWlPEZitvHAWI5FR5R0UsxBc59gRGrdeKR0YPgbJSN9Q8pFzAu2ByClIki21yctJg2sEkQTZ1qW0s5B8TGXhux7hnquDsQ6ZF6XMQw+DfrPTs6pLd2kjY8vMlHlvAuKTm
 pHO/hy6G
 wQCdpR/EvTpX0/qEfoPGG1CMa31CmRSbTv8YjQ5Q70eb4aQ0N7DxibiDCX8Rez6vOhY2hQVuiqIqT955QlUnuxwNuBUpYet2KStQJTLM4ZhHaLh6ZwIR6a12OPCaHWfatl15GCxynqOfHcsl+z30mhLrRzSAJn+5V5dzdkDfR0LAnNna60x7MwAH5pULaixEUSphGsdoyWcQwwj+NhdHhoOwMfX67QShtWPRhXaDsBb+xxkC8Tnyyz55mo7ZYC8/HeG++Gce7bcRa3Z12FfkdaB7NhMsNjlpBLFnOSGZriWD0bs87m9Y68uPJOdvtddq34G9iOW3AaRq6A7TbmgVkZTgowK9GFn/ArIIBwA4gZkttj8u5JoOjImVJ1PCunbkOgpTveXvx/Wh4/mJpsgET4GkIY66MRUiWSx2iVaSS6LcC04z4QCx5Ca9S+BMae/S1kQxYHDfgt6H3Fe7GXzau9OuH4kpaQg71G1hyUvr8ovb5cgIdU5FCTI/lmyuBZcFI9iORcgY9D/hFmUpzkMjnbfny+rr9LsK7HJnlYWpGx33lSKYpbXnktj+ldDZJFBP5Z5/YGjJCA/fm54Asos4hCWTOqPDdSp5B9JRvJF1W8woxVCakygfTPZUIQiQKXj5iv3vhlXihPgmOEDnsWA6MqABFbbNkSMKK2aeMBkkhzE5dK6kVgdIf4qgsIUmmtu8FkX0aWk26Bb/jNbQQY6tD+xlTCMVghPi4VpIV66hXf9lZlHpd2fLDlogoBoI43O0MkY+cGpDSYkFdWs37Rz0mckAOkBrjfMSGDAOFwYmJlHC+8JiBl16VTSFVSbR0SXY8YAtDovDaZOhhLIMLYjo/yBTffgC0MeoxbCMldgPGCSYMguomnHbBLhgEsq13AC4NR6+4Ytlv/wHpYX0SROdknvN9gugaxUjltTGEh2u7dwnqrT+JFHl2aXhe2GjWdRkZBPQ6gzQU/xUw5Jj/wgPZOYgY2oVq
 Z6ouzYXF
 qq05qfxABUcWdkpG55SaaQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 09, 2026 at 05:08:16PM +0000, Lorenzo Stoakes wrote:
>On Thu, Feb 05, 2026 at 03:31:13AM +0000, Wei Yang wrote:
>> Commit 60fbb14396d5 ("mm/huge_memory: adjust try_to_migrate_one() and
>> split_huge_pmd_locked()") return false unconditionally after
>> split_huge_pmd_locked() which may fail early during try_to_migrate() for
>> shared thp. This will lead to unexpected folio split failure.
>
>I think this could be put more clearly. 'When splitting a PMD THP migration
>entry in try_to_migrate_one() in a rmap walk invoked by try_to_migrate() when

split_huge_pmd_locked() could split a PMD THP migration entry, but here we
expect a PMD THP normal entry.

>TTU_SPLIT_HUGE_PMD is specified.' or something like that.
>
>>
>> One way to reproduce:
>>
>>     Create an anonymous thp range and fork 512 children, so we have a
>>     thp shared mapped in 513 processes. Then trigger folio split with
>>     /sys/kernel/debug/split_huge_pages debugfs to split the thp folio to
>>     order 0.
>
>I think you should explain the issue before the repro. This is just confusing
>things. Mention the repro _afterwards_.
>

OK, will move afterwards.

>>
>> Without the above commit, we can successfully split to order 0.
>> With the above commit, the folio is still a large folio.
>>
>> The reason is the above commit return false after split pmd
>
>This sentence doesn't really make sense. Returns false where? And under what
>circumstances?
>
>I'm having to look through 60fbb14396d5 to understand this which isn't a good
>sign.
>
>'This patch adjusted try_to_migrate_one() to, when a PMD-mapped THP migration

I am afraid the original intention of commit 60fbb14396d5 is not just for
migration entry.

>entry is found, and TTU_SPLIT_HUGE_PMD is specified (for example, via
>unmap_folio()), exit the walk and return false unconditionally'.
>
>> unconditionally in the first process and break try_to_migrate().
>>
>> On memory pressure or failure, we would try to reclaim unused memory or
>> limit bad memory after folio split. If failed to split it, we will leave
>
>Limit bad memory? What does that mean? Also should be If '_we_' or '_it_' or
>something like that.
>

What I want to mean is in memory_failure() we use try_to_split_thp_page() and
the PG_has_hwpoisoned bit is only set in the after-split folio contains
@split_at.

>> some more memory unusable than expected.
>
>'We will leave some more memory unusable than expected' is super unclear.
>
>You mean we will fail to migrate THP entries at the PTE level?
>

No. 

Hmm... I would like to clarify before continue.

This fix is not to fix migration case. This is to fix folio split for a shared
mapped PMD THP. Current folio split leverage migration entry during split
anonymous folio. So the action here is not to migrate it.

I am a little lost here.

>Can we say this instead please?
>
>>
>> The tricky thing in above reproduce method is current debugfs interface
>> leverage function split_huge_pages_pid(), which will iterate the whole
>> pmd range and do folio split on each base page address. This means it
>> will try 512 times, and each time split one pmd from pmd mapped to pte
>> mapped thp. If there are less than 512 shared mapped process,
>> the folio is still split successfully at last. But in real world, we
>> usually try it for once.
>
>This whole sentence could be dropped I think I don't think it adds anything.
>
>And you're really confusing the issue by dwelling on this I think.
>
>You need to restart the walk in this case in order for the PTEs to be correctly
>handled right?
>
>Can you explain why we can't just essentially revert 60fbb14396d5? Or at least
>the bit that did this change?
>
>Also is unmap_folio() the only caller with TTU_SPLIT_HUGE_PMD as the comment
>that was deleted by 60fbb14396d5 implied? Or are there others? If it is, please
>mention the commit msg.
>
>
>>
>> This patch fixes this by restart page_vma_mapped_walk() after
>> split_huge_pmd_locked(). We cannot simply return "true" to fix the
>> problem, as that would affect another case:
>
>I mean how would it fix the problem to incorrectly have it return true when the
>walk had not in fact completed?
>
>I'm not sure why you're dwelling on this idea in the commit msg?
>
>> split_huge_pmd_locked()->folio_try_share_anon_rmap_pmd() can failed and
>> leave the folio mapped through PTEs; we would return "true" from
>> try_to_migrate_one() in that case as well. While that is mostly
>> harmless, we could end up walking the rmap, wasting some cycles.
>
>I mean I think we can just drop this whole paragraph no?
>
>You might think I'm being picky about the commit msg here, but as is I find it
>pretty much incomprehensible and that's not helpful if we have to go back and
>read this in future.
>

Never mind.

A clearer and comprehensive change log is helpful for all. And my English is
not native language, so your suggestion helps a lot.

>>
>> Fixes: 60fbb14396d5 ("mm/huge_memory: adjust try_to_migrate_one() and split_huge_pmd_locked()")
>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>> Reviewed-by: Zi Yan <ziy@nvidia.com>
>> Tested-by: Lance Yang <lance.yang@linux.dev>
>> Reviewed-by: Lance Yang <lance.yang@linux.dev>
>> Reviewed-by: Gavin Guo <gavinguo@igalia.com>
>> Acked-by: David Hildenbrand (arm) <david@kernel.org>
>> Cc: Gavin Guo <gavinguo@igalia.com>
>> Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>
>> Cc: Zi Yan <ziy@nvidia.com>
>> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
>> Cc: Lance Yang <lance.yang@linux.dev>
>> Cc: <stable@vger.kernel.org>
>>
>> ---
>> v3:
>>   * gather RB
>>   * adjust the commit log and comment per David
>
>Clearly not enough :)
>
>>   * add userspace-visible runtime effect in change log
>
>Which one was that?
>
>> v2:
>>   * restart page_vma_mapped_walk() after split_huge_pmd_locked()
>> ---
>>  mm/rmap.c | 12 +++++++++---
>>  1 file changed, 9 insertions(+), 3 deletions(-)
>>
>> diff --git a/mm/rmap.c b/mm/rmap.c
>> index 618df3385c8b..1041a64b8e6b 100644
>> --- a/mm/rmap.c
>> +++ b/mm/rmap.c
>> @@ -2446,11 +2446,17 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
>>  			__maybe_unused pmd_t pmdval;
>>
>>  			if (flags & TTU_SPLIT_HUGE_PMD) {
>> +				/*
>> +				 * split_huge_pmd_locked() might leave the
>> +				 * folio mapped through PTEs. Retry the walk
>> +				 * so we can detect this scenario and properly
>> +				 * abort the walk.
>> +				 */
>
>This comment is a lot clearer than the commit msg :)
>
>>  				split_huge_pmd_locked(vma, pvmw.address,
>>  						      pvmw.pmd, true);
>> -				ret = false;
>> -				page_vma_mapped_walk_done(&pvmw);
>> -				break;
>> +				flags &= ~TTU_SPLIT_HUGE_PMD;
>> +				page_vma_mapped_walk_restart(&pvmw);
>> +				continue;
>
>This logic does lok reasonable.
>
>>  			}
>>  #ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
>>  			pmdval = pmdp_get(pvmw.pmd);
>> --
>> 2.34.1
>>
>
>Cheers, Lorenzo

-- 
Wei Yang
Help you, Help me

