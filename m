Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F966ED7B8C
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 09:04:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 72FC36B0092; Tue, 14 Apr 2026 05:04:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E1006B0093; Tue, 14 Apr 2026 05:04:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5CFE56B0096; Tue, 14 Apr 2026 05:04:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4A5046B0092
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 05:04:15 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CA95058B95
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 09:04:14 +0000 (UTC)
X-FDA: 84656574828.12.76676E1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 129471C0003
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 09:04:12 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MtmiWnzi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776157453;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XKxcTeSdMNdg31OtnfA2LuARnGeBO/VZWW6TMW6Uyio=;
	b=KhYGzdZmgE67YjTBSKkZ2gfeWm5uslxgIjhyXA38ggjBJtc/+gORn+rnrjWqzoS9JHBYWs
	tHDQ3Gmhhit0lt8H26nwElTysxLj5v7QKVVpwajUoEgoopa+ziNzKDRz0oBnyc6dA/4WuJ
	vDZWjvpovQH5O8m1ExWAyuf6Tz+9r4k=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776157453; a=rsa-sha256;
	cv=none;
	b=WVkcnxgIecdlh/IGC4kpTpM/eUdejuspRmLluGDLKNWw47zDvIAkrCwXw5qU/JmfRWF7XD
	b9xOmqXEgMBePa/oXS6LvlP71Wu7oGPJa4NvGDet1gIT3L4tl2R6P5DWhnMDa69M401DT1
	UYqHTgznp7N0HswGEb9TjhdUZZtxUfg=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MtmiWnzi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2E93760018;
	Tue, 14 Apr 2026 09:04:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E876C19425;
	Tue, 14 Apr 2026 09:04:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776157451;
	bh=9YZ3f1pEg/cerPbOleboqxXFRvXme+37veRTtITZnyk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=MtmiWnzibX8Yh6f+n+HUjz/KfwWNcpM4LTlAsV0wR+Jj/sVF6j+gcjNdaFmIdNJRT
	 49IBk5ZKKlZAmh/AJpCsJsOiErswZlqKM4heBrfStthDAPdV30a6AE4eFHwCDynIwA
	 CbzgvInpu+b1k1Z0ft4NN0xut9dwPIv8vk7zBXxOH0nGHha2OlAnOsm7KzxbIWc4c4
	 HUHRVb7zzJxjDQO/b425WJQTWZe7/0S8V9QjeFx7HQl3W4L628BzQwLLQ2tfP5i+Vl
	 nMSRWrQQRsCZSjBBTKnXNaMJ8zStBZ3SD/C3I6aIBByRLOTR4Y8aESu7mR55MIKbbi
	 MCtAQ3TU+UA9w==
Message-ID: <da935245-9c75-4cf4-8a42-2c6328bd93f9@kernel.org>
Date: Tue, 14 Apr 2026 11:04:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 3/9] mm: add __GFP_PREZEROED flag and
 folio_test_clear_prezeroed()
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>, Brendan Jackman <jackmanb@google.com>,
 Michal Hocko <mhocko@suse.com>, Suren Baghdasaryan <surenb@google.com>,
 Jason Wang <jasowang@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
 linux-mm@kvack.org, virtualization@lists.linux.dev,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport
 <rppt@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>
References: <cover.1776033471.git.mst@redhat.com>
 <b21b0ba353330f24b9e10ee5bf01b60f32043327.1776033771.git.mst@redhat.com>
 <b258160c-5287-43dd-b56e-268c403b85ea@kernel.org>
 <20260413163644-mutt-send-email-mst@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260413163644-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 129471C0003
X-Stat-Signature: epsh1r1doyxshju1779bwfgu7n9b9dd3
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1776157452-861255
X-HE-Meta: U2FsdGVkX18HdYWa/4VACK7m60QKYEdJO4COBHHhBCMfU8LpQ1FM0fNeS/XF51AL5WlUGO1MdifkYNP6ETZfYqo7Iu2dtunnr3qsp61wU8LngwE55/h19utvNkohoZ9+9YAm+0pNG9Afw63z63tqC6AV4YMEnDfICfPKQwHHcU4WpwSUr8gIjcw4jjho2RQVtwj6pgBBfiOARxPQMipY06oumW+6ItZzHc5NFxvOqyiGQvuj8e3HAh70G2SKtNy44d1Yn5toAN+VtsVebZtuWIJD8bKwESEHdlYUjhd+TueuZlie20YL8KMAh1nlJh2YyLATKz08nlmR+s5n/ilbhcSV2YgQLZ6xWcW+ZKUsoDXurdC2W7CaNlD5Si5FtqN22xz42y+9eV3Biwp4NnNPPjODnzMzQfQWEkIiuVyRamL4MYjELgXIB1KKwqzc8KqUaSTrXxh/5K+cbUPbQ0N4hrw/E7bDlyhQf/03gKnRRcqDQY+qwL8TNITAbLBN/p7BrpUwIr2Mfr79vLN5YvvvsFHWlQxZhuEtfDPW2HDhKz5TPw6CHwca2Xpr2k0Y/0B95lPBpGdZc0vrYhw9qBg2gir6aRwa1J2WFoVx/42O4nQ748LR7ILwOM2AtR+/HcMuCELXqmaXgeuIrgEIrspPFfUN8GSP+DR1b+EdNqvCtR7pf52zxvrQnjWh06mvSdjPfJejNSm/yh/Q9B+yhNRC91uRabu39Yi+h5H6Qd0wLBUdAe5GVKZNA/uhrmE09gFdv68tFTzwpXdMQSRpSG1FGKgJbLpAMgykdKSt/8WlQc+e46/pnBMR/uceObdKf24cdHqHpgbz9JpFcdTAdCNW00YjngluER46QfgIaAwSa0DknwGidwnplq7HuHxf7m4IKrm5CZNYWeKahh9HPpi8FhXzlwbefD0fSbGP+sRQrML3iXALzRweBELPHSHtAoGqKLLJioCTgJtYZPuC1Oc
 85p1wT6h
 IhOTyPFCl2tYRoKI6XqJdFJWwuhVBBojREaWIfbdFlNWuar6Q0h5wdPJFaBs1NE7owrgQMAMdap9L2GEpRcBD8yh+s8AfJOZceVYFy1mfSd91cI1c0xLqMFwdJ9eyLo0g1Lg9NEfxK1cux7Sa1RZZQM0eHJF7/iVQZlc/zJwOMBHg35RxxOpf8Fq0+2jQinNF3JEuz7NUmWwxlLPwNsd2o4E0hnwMw67/YWp6csPcjDyFjOmtHkNaE0n38CHOk1xkfB6vNPlHj43/bTU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/13/26 22:37, Michael S. Tsirkin wrote:
> On Mon, Apr 13, 2026 at 11:05:40AM +0200, David Hildenbrand (Arm) wrote:
>> On 4/13/26 00:50, Michael S. Tsirkin wrote:
>>> The previous patch skips zeroing in post_alloc_hook() when
>>> __GFP_ZERO is used.  However, several page allocation paths
>>> zero pages via folio_zero_user() or clear_user_highpage() after
>>> allocation, not via __GFP_ZERO.
>>>
>>> Add __GFP_PREZEROED gfp flag that tells post_alloc_hook() to
>>> preserve the MAGIC_PAGE_ZEROED sentinel in page->private so the
>>> caller can detect pre-zeroed pages and skip its own zeroing.
>>> Add folio_test_clear_prezeroed() helper to check and clear
>>> the sentinel.
>>
>> I really don't like __GFP_PREZEROED, and wonder how we can avoid it.
>>
>>
>> What you want is, allocate a folio (well, actually a page that becomes
>> a folio) and know whether zeroing for that folio (once we establish it
>> from a page) is still required.
>>
>> Or you just allocate a folio, specify GFP_ZERO, and let the folio
>> allocation code deal with that.
>>
>>
>> I think we have two options:
>>
>> (1) Use an indication that can be sticky for callers that do not care.
>>
>> Assuming we would use a page flag that is only ever used on folios, all
>> we'd have to do is make sure that we clear the flag once we convert
>> the to a folio.
>>
>> For example, PG_dropbehind is only ever set on folios in the pagecache. 
>>
>> Paths that allocate folios would have to clear the flag. For non-hugetlb
>> folios that happens through page_rmappable_folio().
>>
>> I'm not super-happy about that, but it would be doable.
>>
>>
>> (2) Use a dedicated allocation interface for user pages in the buddy.
>>
>> I hate the whole user_alloc_needs_zeroing()+folio_zero_user() handling.
>>
>> It shouldn't exist. We should just be passing GFP_ZERO and let the buddy handle
>> all that.
>>
>>
>> For example, vma_alloc_folio() already gets passed the address in.
>>
>> Pass the address from vma_alloc_folio_noprof()->folio_alloc_noprof(), and let
>> folio_alloc_noprof() use a buddy interface that can handle it.
>>
>> Imagine if we had a alloc_user_pages_noprof() that consumes an address. It could just
>> do what folio_zero_user() does, and only if really required.
>>
>> The whole user_alloc_needs_zeroing() could go away and you could just handle the
>> pre-zeroed optimization internally.
>>
>> -- 
>> Cheers,
>>
>> David
> 
> I admit I only vaguely understand the core mm refactoring you are suggesting.
> 

Oh, I was hoping claude would figure that out for you.


Essentially, we move the zeroing of folios back into the buddy, by using
GFP_ZERO.

user_alloc_needs_zeroing() logic would reside in the buddy and is no longer
required in callers.

E.g.,

diff --git a/mm/memory.c b/mm/memory.c
index 631205a384e1..44576ba3def5 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5259,7 +5259,7 @@ static struct folio *alloc_anon_folio(struct vm_fault *vmf)
        gfp = vma_thp_gfp_mask(vma);
        while (orders) {
                addr = ALIGN_DOWN(vmf->address, PAGE_SIZE << order);
-               folio = vma_alloc_folio(gfp, order, vma, addr);
+               folio = vma_alloc_folio(gfp | GFP_ZERO, order, vma, addr);
                if (!folio)
                        goto next;
                if (mem_cgroup_charge(folio, vma->vm_mm, gfp)) {
@@ -5272,15 +5272,6 @@ static struct folio *alloc_anon_folio(struct vm_fault *vmf)
                        goto fallback;
                }
                folio_throttle_swaprate(folio, gfp);
-               /*
-                * When a folio is not zeroed during allocation
-                * (__GFP_ZERO not used) or user folios require special
-                * handling, folio_zero_user() is used to make sure
-                * that the page corresponding to the faulting address
-                * will be hot in the cache after zeroing.
-                */
-               if (user_alloc_needs_zeroing())
-                       folio_zero_user(folio, vmf->address);
                return folio;
 next:
                count_mthp_stat(order, MTHP_STAT_ANON_FAULT_FALLBACK);


folio_zero_user(), from where we would extract a function that operates on a
page+order chunk, requires the address hint.

So we would have to pass that address. For example for the !CONFIG_NUMA case,
something like the following could be done.

diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index 51ef13ed756e..29771c3240be 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -234,6 +234,10 @@ struct folio *__folio_alloc_noprof(gfp_t gfp, unsigned int order, int preferred_
                nodemask_t *nodemask);
 #define __folio_alloc(...)                     alloc_hooks(__folio_alloc_noprof(__VA_ARGS__))
 
+struct folio *__folio_alloc_user_noprof(gfp_t gfp, unsigned int order, int preferred_nid,
+               nodemask_t *nodemask, unsigned long addr);
+#define __folio_alloc_user(...)                        alloc_hooks(__folio_alloc_user_noprof(__VA_ARGS__))
+
 unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
                                nodemask_t *nodemask, int nr_pages,
                                struct page **page_array);
@@ -291,6 +295,18 @@ __alloc_pages_node_noprof(int nid, gfp_t gfp_mask, unsigned int order)
 
 #define  __alloc_pages_node(...)               alloc_hooks(__alloc_pages_node_noprof(__VA_ARGS__))
 
+static inline
+struct folio *__folio_alloc_user_node_noprof(gfp_t gfp, unsigned int order,
+               int nid, unsigned long addr)
+{
+       VM_BUG_ON(nid < 0 || nid >= MAX_NUMNODES);
+       warn_if_node_offline(nid, gfp);
+
+       return __folio_alloc_user_noprof(gfp, order, nid, NULL, addr);
+}
+
+#define  __folio_alloc_user_node(...)          alloc_hooks(__folio_alloc_user_node_noprof(__VA_ARGS__))
+
 static inline
 struct folio *__folio_alloc_node_noprof(gfp_t gfp, unsigned int order, int nid)
 {
@@ -342,7 +358,7 @@ static inline struct folio *folio_alloc_mpol_noprof(gfp_t gfp, unsigned int orde
 static inline struct folio *vma_alloc_folio_noprof(gfp_t gfp, int order,
                struct vm_area_struct *vma, unsigned long addr)
 {
-       return folio_alloc_noprof(gfp, order);
+       return __folio_alloc_user_node_noprof(gfp, order, numa_node_id(), addr);
 }
 #endif
 
index ee81f5c67c18..28f448f40b75 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5260,6 +5260,13 @@ struct folio *__folio_alloc_noprof(gfp_t gfp, unsigned int order, int preferred_
 }
 EXPORT_SYMBOL(__folio_alloc_noprof);
 
+struct folio *__folio_alloc_user_noprof(gfp_t gfp, unsigned int order, int preferred_nid,
+               nodemask_t *nodemask, unsigned long addr)
+{
+       /* TODO */
+}
+EXPORT_SYMBOL(__folio_alloc_noprof);
+
 /*
  * Common helper functions. Never use with __GFP_HIGHMEM because the returned
  * address cannot represent highmem pages. Use alloc_pages and then kmap if


As alloc_user_pages() resides in the buddy, it can just honor any
buddy-internal "pre-zeroed" flag.


Once you are in page_alloc.c you can access internal allocation functions and
take care of that without GFP flags.

-- 
Cheers,

David

