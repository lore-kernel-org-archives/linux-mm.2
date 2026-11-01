Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D446F606A333
	for <linux-mm@archiver.kernel.org>; Sun,  1 Nov 2026 06:59:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=KsW8zLjF
Received: by kanga.kvack.org (Postfix)
	id EDF226B00EF; Sun,  1 Nov 2026 01:59:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E8F846B05B1; Sun,  1 Nov 2026 01:59:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA5076B05B4; Sun,  1 Nov 2026 01:59:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B60E26B00EF
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 01:59:41 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 583F2A0A37
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 06:59:41 +0000 (UTC)
X-FDA: 85385649762.30.9949C05
Received: from mta1.migadu.com (out-252.mta1.migadu.com [95.215.58.252])
	by imf15.hostedemail.com (Postfix) with ESMTP id 46A16A0003
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 06:59:39 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=KsW8zLjF;
	spf=pass (imf15.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.252 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793516379;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YeIoxROzkAdhFI4Ar5AnwjuAhq4OI4vjyPjDPC2k3nU=;
	b=4RPMNzlKLizIPMcPk975BXPdE3qDX0wugqHEok9f0hoUJIUD9GP/SyZeguF0LnAAsibFsV
	Qqn3GiVdlXpyL9bYw3T4O4+seeGNOmxP4hECRynrkc3noRUJJX6ZGCa6rPtzQiNtpr3NEo
	Jw8B/S1yaDzyxC6/qQcd2AktfPrZg6Y=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=KsW8zLjF;
	spf=pass (imf15.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.252 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793516379;
	b=DTIHHG7QVlYUV8w/1XYrT50tVpOvT8JX9N3CPOLnUnpcdCQhz6l8KK8NSiufbQ2ECuNVHI
	QyynQKvrGAqYqXBQVMc9UVmRsVF5v3vz0YvxBkAPpSGLKvjWtnJWC+yEEhTL7dxoSMX1SK
	JabiBZrVGr8xhHWhF8+AxmXyJbpUSWs=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=uSVvmFSAIOfOrJ9voHYtRM47z6sjBlD60gkSR70O4ak=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793516378; v=1; x=1794121178;
 b=KsW8zLjFG6M6V/qOXwO1HZPLeKqacZiKOP5IsUbZakyHpCXTx1jy7XHWmVpu8XNRaUsNOfim
 g+U7Vd3AgTiyqqLSXaNqtpgJesGIv3jJgLv0z8tJQXejBjLrSE3sRoEG2RGROrD6rXAN1Z6ZR+f
 yas9estBnISXcXDy98W/ZWRs=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 3eacaad6ebce6e07;
	Sun, 01 Nov 2026 06:59:37 +0000
X-Mizu-Trace-ID: 3eacaad6ebce6e07
X-Migadu-Flow: FLOW_OUT
Message-ID: <f91ed3e0-59f2-459e-8c72-abe093892e73@linux.dev>
Date: Sun, 1 Nov 2026 14:59:29 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 02/12] mm: hugetlb_vmemmap: unify
 VMEMMAP_{SPLIT,REMAP}_NO_TLB_FLUSH
To: Muchun Song <muchun.song@linux.dev>
Cc: Muchun Song <songmuchun@bytedance.com>, Oscar Salvador
 <osalvador@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
 Mike Rapoport <rppt@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 James Houghton <jthoughton@google.com>, David Hildenbrand
 <david@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20261020115306.813483-1-songmuchun@bytedance.com>
 <20261020115824.823278-1-songmuchun@bytedance.com>
 <86d9a986-58ea-44f5-a8af-514abff12c2a@linux.dev>
 <99503D05-0C4D-45E4-B5D6-EDD927838935@linux.dev>
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <99503D05-0C4D-45E4-B5D6-EDD927838935@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 46A16A0003
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: g89ay5g8wgwxfcxscja694t8aiodacri
X-HE-Tag: 1793516379-388135
X-HE-Meta: U2FsdGVkX18Jzq0uyVl2j5TejafEG1xMzXoIpqlpeMSmTzQrglvzmwy5bbnT8pTqLuvp9m0/56nNr+GB0nYVBnyAgxdgiJD002TuXw25vHbNFX8q++SNczo/jQBCB2hPwzATiaSb4Ne239IZmBGVyePgpcXFAadK/pbMPKGvIsoyRqXv9aQjivcq6mD8fzkWBVkeOOJCne2jh6afbHAfBUHP3opCReJCNOvk7+ahiLOMpt2LbvDsXMmDw9+sEKXrI4SRwVHtuxSZ9zR4Btmghc7ufuGdplgkkNLAFI6X+fAD0Tzq4V1gdglz74vHt48aEt/84Cvn6RIUpRfOYBm5MDG0gSL0XpLLUXUXM0MYtlLyHjSzZW5WAB5YNkIbSHAeHYVsFPzpYOjhepGKCIUz+e4kpII1Go6OvKhFhxN9hEz8BEo0WIxw5W6A1As7GVLyjxKeroA4o0UL4HUvt/pw20TwjpgZ5p15k/bjBUCPoU89KdlgOM5B9oOAHWEzrRyrjldZ4TM+SuAVLfptW66hcrsYDXbj2pNsTMm7m9ut7+Bmv135sREt/yBO47VzW7vAT4K33fc1gr8iSKpoNozsbmlLnzffkT5q29aA7sGeytsGdenb2kqWocVnGLdfO+eZW15ao+zdqrWHk3LVS8TvePVORU6j/KaV4z6Edmejcc75IldHh3W0Fp8CJB4TXPGs2RfSY5OLMwtU1UAae/CabudSSHXsz/IqNi9nYdgRc6HrdNYUKVuU7inz5JRCcSXtXvhWdxely+ULpLQTOJUWQJg9/hUY0XXApWnZzK+dQPJgzSPubsuuiis+4fsW7NI6/ky+yVSQ7Lj52313Rf9QNDHfC+rcEFj7imSbCrEPZhA3qzJytflsx2IiHsU+WAflGfIWN56Q1hb4+N/7J4ECRklUEn+BnB3mbi0nppg0psqtpQo/EWY2qk9wS2M9W6oo4Hq6PZwy6ZhYlhNdy/S
 HimqrFRX
 LfQH4pTOWRQpqUhKrsFVzk0CzSmRJgtu4vrByr7MZikZq69S2iQ5Qpb0HcIcMm/4CegWumQ3H/7wrBeGTuD8FhkDRLQLmH7kv9/7T3OYynF2XeqXYfcnxOlQfNkTM5ireQJPZzmYoZ1NbqxEUME97ZQO8uvK6Uu5SbnTi4g/IxCKcW0ZgUq3TsDJF/ycoon8YA/eeqyf6et/zTE1+W/fO63bA3VkiCLbgSsK84tyhthKQXCocVb28ks6r9SKXoEQ+HACHzCf/IZeAIJIDjSwWIkVlf8Bv2Hf/QauMspcndoooDa/T1hWWH7UaFabJQIaGM/q+IXiXYCRdvx7UXDebNvuECw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/1/26 2:56 PM, Muchun Song wrote:
> 
> 
>> On Nov 1, 2026, at 14:22, Qi Zheng <qi.zheng@linux.dev> wrote:
>>
>>
>>
>> On 10/20/26 7:58 PM, Muchun Song wrote:
>>> VMEMMAP_SPLIT_NO_TLB_FLUSH and VMEMMAP_REMAP_NO_TLB_FLUSH do not
>>> describe fully independent choices. A split-only walk can defer the
>>> PMD-split flush to a later global flush, and a remap-only walk can
>>> defer the final remap flush. However, when a PMD split is followed
>>> by PTE remapping, the split flush must happen before the PTEs are
>>> changed, because stale large-page translations must not overlap with
>>> new small-page translations that map different physical pages.
>>> Replace the two flags with a single VMEMMAP_REMAP_NO_TLB_FLUSH flag.
>>> Keep split-only walks able to defer the flush, but force the split
>>> flush whenever a remap_pte callback is present. Callers that batch
>>> HVO work can still defer the final remap flush and issue their own
>>> global flush.
>>> Current callers keep the same flushing behavior.
>>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>>> ---
>>>   mm/hugetlb_vmemmap.c | 15 +++++++++------
>>>   1 file changed, 9 insertions(+), 6 deletions(-)
>>> diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
>>> index 1105aa925acc..8b3abb562599 100644
>>> --- a/mm/hugetlb_vmemmap.c
>>> +++ b/mm/hugetlb_vmemmap.c
>>> @@ -42,10 +42,8 @@ struct vmemmap_remap_walk {
>>>   	struct list_head	*vmemmap_pages;
>>>     -/* Skip the TLB flush when we split the PMD */
>>> -#define VMEMMAP_SPLIT_NO_TLB_FLUSH	BIT(0)
>>> -/* Skip the TLB flush when we remap the PTE */
>>> -#define VMEMMAP_REMAP_NO_TLB_FLUSH	BIT(1)
>>> +/* Skip the TLB flush while updating the vmemmap page tables. */
>>> +#define VMEMMAP_REMAP_NO_TLB_FLUSH	BIT(0)
>>
>> Since this flag is now also used by the split-only path, the
>> VMEMMAP_REMAP_NO_TLB_FLUSH name is somewhat misleading. Moreover, the
>> flag does not suppress every TLB flush, as the PMD-split flush is still
>> mandatory when remapping follows.
> 
> Yeah, good point.
> 
>>
>> Would VMEMMAP_DEFER_TLB_FLUSH better describe its semantics? It
> 
> I think so.
> 
>> indicates that flushes which can be safely batched are deferred, without
>> implying that all TLB flushes are skipped.
> 
> I'll change it along side with the comment to:
> 
>    /* Defer safely batchable TLB flushes to the caller. */
>    #define VMEMMAP_DEFER_TLB_FLUSH       BIT(0)

LGTM, with this change:

Reviewed-by: Qi Zheng <qi.zheng@linux.dev>

Thanks,
Qi


