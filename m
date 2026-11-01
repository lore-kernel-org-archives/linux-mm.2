Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28CBE606A329
	for <linux-mm@archiver.kernel.org>; Sun,  1 Nov 2026 06:42:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=JB0ZOzkr
Received: by kanga.kvack.org (Postfix)
	id 2D60C6B00EF; Sun,  1 Nov 2026 01:42:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 284B06B05B2; Sun,  1 Nov 2026 01:42:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 19BDB6B05B3; Sun,  1 Nov 2026 01:42:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E3A6D6B00EF
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 01:42:32 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 35C5AA853B
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 06:42:32 +0000 (UTC)
X-FDA: 85385606544.14.8842784
Received: from mta1.migadu.com (out-162.mta1.migadu.com [95.215.58.162])
	by imf20.hostedemail.com (Postfix) with ESMTP id 140931C0004
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 06:42:29 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JB0ZOzkr;
	spf=pass (imf20.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.162 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793515350;
	b=PL3draMVpof3igie4jdDUcnVXBRueT3CHbwZt1yrzOkgqfadjiUXKRWzvRVw4Flq4Edrx1
	neQysYWvgRlU9KLXUwZWrRRaUGoefFwFagSBnIQHQjJ2gYBO1NMoR+RQ5JnPbwkCvORiTr
	6AafX8mL8LlF+J09EPLDU+Th4NkgVrE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793515350;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fWPBh4xlXvHa2PfIk2O3jnTg7iaOCA9kUP9jRVQ5YkU=;
	b=pLAMSrdneFjS0uzwDG/k0Ze5R6tgPN/t0wR8f2KqcmnDGvsTttt17F2UgtjHhkZKxjivDH
	xqyi50yHwWmm5SdTKVS5yTXYgUYZSCKnI2FdO8Ncqj6Gkzycmzmyw784AKMd6B6HNtLmP9
	Ggk669+NqtZu+MTC82N95HrmlA0QDVM=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JB0ZOzkr;
	spf=pass (imf20.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.162 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=Xl9e7alOwd/kiUgVOqOJ845lSSz3tfs5SaPASXGt7kg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793515348; v=1; x=1794120148;
 b=JB0ZOzkr9yBqzyGeHjJkHQyDVZmJtGcrtMU5ckKpJ/45p6f47rU81ZuYt4Zx3eXcAbI1XnC5
 n+a10glpaCyhCjPBPaljZrdGw7nHg/X43qT5LA+Z3i3NDtU3Wg5/2dXTbMunmtjUT/oL3m/XSGB
 dW72FeU8bExF8q1SYhikXu5g=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 48526ceea99b9bcd;
	Sun, 01 Nov 2026 06:42:28 +0000
X-Mizu-Trace-ID: 48526ceea99b9bcd
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.12\))
Subject: Re: [PATCH 03/12] mm: hugetlb_vmemmap: simplify vmemmap head page
 handling
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <587556c5-389f-4616-99f9-f0216b72f112@linux.dev>
Date: Sun, 1 Nov 2026 14:42:07 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 Oscar Salvador <osalvador@suse.de>,
 Andrew Morton <akpm@linux-foundation.org>,
 Mike Rapoport <rppt@kernel.org>,
 Lance Yang <lance.yang@linux.dev>,
 James Houghton <jthoughton@google.com>,
 David Hildenbrand <david@kernel.org>,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <2D520BF9-F46D-4652-B155-DACEF486B473@linux.dev>
References: <20261020115306.813483-1-songmuchun@bytedance.com>
 <20261020115824.823278-1-songmuchun@bytedance.com>
 <20261020115824.823278-2-songmuchun@bytedance.com>
 <587556c5-389f-4616-99f9-f0216b72f112@linux.dev>
To: Qi Zheng <qi.zheng@linux.dev>
X-Mailer: Apple Mail (2.3901.100.1.1.12)
X-Stat-Signature: ustio8tieceheef3dcwc4zyehx6iechy
X-Rspamd-Queue-Id: 140931C0004
X-Rspam-User:
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793515349-176148
X-HE-Meta: U2FsdGVkX18K0jJquZoKUs45V7hDjnAWzC7/xR/4Fq7qBufs2b9zNS+gg+hnlAS1yPMx9sZIoZoH++Cen1Yxaa/6CEQGvrrBZMD/Y6kyhMRyoMInWH6+EwUqqbb7RmuF+FAHKqNyENg3EGFamYMvZuOpTOKM7BCfKo3iS5BSFGGEmQmYhLDR9lFW2T8wY0WT0MVN8B/HzIt/mehLBBGW+7b39g+pCi67JyOcj6psjXj5n7YVskXHL6aZiryr1CjUo+K5YpvQdgZgrOXS0OFq8xcAq3+8b0p/g1k+wab+R0oI3LstGGU0IXMg7ydlCxDMYOb2/2FCU4noU7GH+9ccaw7u3vBI/NVEAn0fWQDq9FmFPnmXgaBTHpmwgpdz7F7i2eFe5V8EpiLnnP4tP9aGQiPEBHYdh5uH62pzfvk6cScTB8V+uivhhyVBVEPPOArNsTDwMQYNupmm6Lp2qlME2/+EudHtVnbZEpPzovHn5EWiK9+d1uFowlhmXF++gLiIEI8H9EdLil+K4KeGnG6EMgZMUiYlMONAFPVkx8AXgQYe/iTgdKs4MzPK9hxIBKVgNETpHNtjE4h/ih6TNCn1xix7PdUZl4+no46Hf4tA1s65Mh0nSedtviIDPBuQqYf3kGMv9ur/TgUhVjDBB+IECopyeSHrcGtS586OUdjHugoclbi9D+mF71IPS60uSjR9I4dVgKm2ZiKjhLaZdy9wc/kyBwQa1Iux5XNAx4T+XFZO4hJXs6RbX5R56/5RV/dLwII8hfBON6lhbOP12v/FjluuTuAwylYHr9GkafJupyAeT+S2pdGutAH6vrzt1MP3Wl6PdDuQzWg2fJAvg+dYNo68x8K9VuXgIxwr69zq15Ttd95bJBSs94dS/iwFVtkZ10d0Gp05EC0YlyKXX5V3nP0xiAxpbF8mrL6UKHduymJFvv0CqTOCfjLYSD2XhShoMN+XCsbTBo2J0aEHbFZ
 lSBl2Zdd
 BQOhdAwBNLfCmeqkQUa+/QgqYU/TQFpZEt+Ke3mIrkc9Vi7upyD+8sXmh4z8R85U8kjk5hq41ioyuBFDeek7KGaNrvu8M8Wl1H6knRG1fLSDPkK5Q1kSdUWNAhkYvECWUDWy0nQDGtYayFJywyfZye9NNYFd35yYKvi4FL7gPeMOIyDUjBQCfKLbpB6sbXvE+ZV/ybVxbnjp/wLihLW7DV6tcduY8fyu9ej+zxeXRE6Eveblhf/T3Kjg5jRpEOLd+ioBIvu7iYxI2S8i6XTHcmZ95U7iJRDRiqpPs85LjXBJ9drzE5e/vo418gnhyK5ZUDWXHdTicEclMdKbFx0naXQO2qI7tu0kqpJaBsZdRYYFWG3QQ5rieSxdqroHMdM3u76Pcc1XSUZcCAY9BjTWt4YaZZVwJNF7EIRZKZCwZhzJ3KCV69qNMFsPBxw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Nov 1, 2026, at 14:31, Qi Zheng <qi.zheng@linux.dev> wrote:
>=20
>=20
>=20
> On 10/20/26 7:58 PM, Muchun Song wrote:
>> The new head page is already tracked on the vmemmap page list before
>> remapping starts.  Passing it separately gives the remap walker two
>> ways to refer to the same page and unnecessarily complicates its
>> interface.
>> Use the page list as the single handoff mechanism for the head page,
>> removing the redundant state from the walker.
>> No functional change intended.
>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>> ---
>>  mm/hugetlb_vmemmap.c | 17 +++++++----------
>>  1 file changed, 7 insertions(+), 10 deletions(-)
>> diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
>> index 8b3abb562599..164e93e980bf 100644
>> --- a/mm/hugetlb_vmemmap.c
>> +++ b/mm/hugetlb_vmemmap.c
>> @@ -25,7 +25,6 @@
>>   *
>>   * @remap_pte:		called for each lowest-level entry =
(PTE).
>>   * @nr_walked:		the number of walked pte.
>> - * @vmemmap_head:	the page to be installed as first in the vmemmap =
range
>>   * @vmemmap_tail:	the page to be installed as non-first in the =
vmemmap range
>>   * @vmemmap_pages:	the list head of the vmemmap pages that can be =
freed
>>   *			or is mapped from.
>=20
> The @vmemmap_pages description may need updating as well. After this

Yes, the comment is out of date even without this patch.

> change, the list is no longer only an output list for pages to be =
freed;
> its first entry is also consumed as the new head backing page. It =
would
> be helpful to document this input contract explicitly.

But I can fix this in this along the way.

>=20
> Other than that, once Lance's comment is addressed:
>=20
> Reviewed-by: Qi Zheng <qi.zheng@linux.dev>

Thanks.

>=20
> Thanks,
> Qi
>=20
>> @@ -37,7 +36,6 @@ struct vmemmap_remap_walk {
>>  					     struct vmemmap_remap_walk =
*walk);
>>    	unsigned long		nr_walked;
>> -	struct page		*vmemmap_head;
>>  	struct page		*vmemmap_tail;
>>  	struct list_head	*vmemmap_pages;
>>  @@ -208,10 +206,13 @@ static void vmemmap_remap_pte(pte_t *pte, =
unsigned long addr,
>>  	pte_t entry;
>>    	/* Remapping the head page requires r/w */
>> -	if (unlikely(walk->nr_walked =3D=3D 0 && walk->vmemmap_head)) {
>> +	if (unlikely(walk->nr_walked =3D=3D 0)) {
>> +		struct page *head;
>> +
>>  		VM_WARN_ON_ONCE(!PageHead((const struct page *)addr));
>>  -		list_del(&walk->vmemmap_head->lru);
>> +		head =3D list_first_entry(walk->vmemmap_pages, struct =
page, lru);
>> +		list_del(&head->lru);
>>    		/*
>>  		 * Makes sure that preceding stores to the page contents =
from
>> @@ -220,7 +221,7 @@ static void vmemmap_remap_pte(pte_t *pte, =
unsigned long addr,
>>  		 */
>>  		smp_wmb();
>>  -		entry =3D mk_pte(walk->vmemmap_head, PAGE_KERNEL);
>> +		entry =3D mk_pte(head, PAGE_KERNEL);
>>  	} else {
>>  		VM_WARN_ON_ONCE(!PageTail((const struct page *)addr));
>>  @@ -289,7 +290,6 @@ static int vmemmap_remap_split(unsigned long =
start, unsigned long end)
>>   *		to remap.
>>   * @end:	end address of the vmemmap virtual address range that we =
want to
>>   *		remap.
>> - * @vmemmap_head: the page to be installed as first in the vmemmap =
range
>>   * @vmemmap_tail: the page to be installed as non-first in the =
vmemmap range
>>   * @vmemmap_pages: list to deposit vmemmap pages to be freed.  It is =
callers
>>   *		responsibility to free pages.
>> @@ -298,7 +298,6 @@ static int vmemmap_remap_split(unsigned long =
start, unsigned long end)
>>   * Return: %0 on success, negative error code otherwise.
>>   */
>>  static int vmemmap_remap_free(unsigned long start, unsigned long =
end,
>> -			      struct page *vmemmap_head,
>>  			      struct page *vmemmap_tail,
>>  			      struct list_head *vmemmap_pages,
>>  			      unsigned long flags)
>> @@ -306,7 +305,6 @@ static int vmemmap_remap_free(unsigned long =
start, unsigned long end,
>>  	int ret;
>>  	struct vmemmap_remap_walk walk =3D {
>>  		.remap_pte	=3D vmemmap_remap_pte,
>> -		.vmemmap_head	=3D vmemmap_head,
>>  		.vmemmap_tail	=3D vmemmap_tail,
>>  		.vmemmap_pages	=3D vmemmap_pages,
>>  		.flags		=3D flags,
>> @@ -547,8 +545,7 @@ static int __hugetlb_vmemmap_optimize_folio(const =
struct hstate *h,
>>  	 * they can be freed by the caller.
>>  	 */
>>  	ret =3D vmemmap_remap_free(vmemmap_start, vmemmap_end,
>> -				 vmemmap_head, vmemmap_tail,
>> -				 vmemmap_pages, flags);
>> +				 vmemmap_tail, vmemmap_pages, flags);
>>  out:
>>  	if (ret)
>>  		folio_clear_hugetlb_vmemmap_optimized(folio);
>=20


