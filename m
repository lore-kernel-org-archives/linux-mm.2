Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D449F531E9
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 09:11:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 858B16B0093; Wed, 15 Apr 2026 05:11:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 808956B0095; Wed, 15 Apr 2026 05:11:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71EEA6B0096; Wed, 15 Apr 2026 05:11:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 637DD6B0093
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 05:11:21 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 278F58BDDB
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 09:11:21 +0000 (UTC)
X-FDA: 84660221562.21.41E8C4D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 60AE180013
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 09:11:19 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UUcI+zX5;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776244279;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BgUV5xskdMm4Bo52O8ecvdUm7uMsqcd/PU9NByzW5tk=;
	b=lv1SHXMdaDThJSc610//vwth0eHGD8RN9QMWw6B0V7iPw9QWVe4zDnMrrkxzXZPiPc19Qe
	5LLVDwekHMORe9MM4L7J1fFha7DCZyPblYclhQONpYuu7wQxkKl4ApF5tRPWfK+3O4eCgQ
	Id0BSueGtf9vERK5feE0n2pTNJyaymc=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UUcI+zX5;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776244279; a=rsa-sha256;
	cv=none;
	b=7TmjEWHbjDzkt2lCOTtKW5l9lkgiAquP3OfOP6pVsVALd+ZgtIb7K+eF/QJtFAC/sEthZp
	6WIgzYiKFwsLVjrPU+ffvXoWCI0jC3Q4ySXuz+Hbqz3dizAFmp9vrLYcXuq5xSJ5RYxFod
	H2LrjciVeUtMB3ZKZQN6IJ3+h97KBLI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C80AB60127;
	Wed, 15 Apr 2026 09:11:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5F08C19424;
	Wed, 15 Apr 2026 09:11:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776244278;
	bh=TPZN45jns1itKScJG6KOizfOoI5BuoeGCxqRTDVziAY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=UUcI+zX5V8d8kCwrPCn9umtgXSOGtgZGhsheBt4lW6r5RYb4g2UNipJzES9Oo7NwJ
	 u+HL5dVFTORwiKn6qgwHKUqc42zuXM8e9EiUVIrnwSl68TPzG20gAw4EZ/x+qOmqRc
	 N+xD/aEKsG9z/38JURaga52nU3UX+8nki9rGixBkc57Z2xGSqDKBZPlkwacirk7VQ5
	 RMDd9JjsuvDrKfjYj0ZXeRaVuRbRuL0O35gpIIt5nPtt/lAxJTo+5B70Ke29/QH492
	 Lw1+dzYJU5lGP7LVcUrZDcaV5856fy61JlwWvn/6d5Q0DYeobtjkwvzIGS9d5fUQgB
	 oUyh2+sEtyGjw==
Message-ID: <b9e7e80a-f052-42ab-ad24-033d714911dc@kernel.org>
Date: Wed, 15 Apr 2026 11:11:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/memory hotplug/unplug: Optimize zone contiguous
 check when changing pfn range
To: Wei Yang <richard.weiyang@gmail.com>
Cc: Yuan Liu <yuan1.liu@intel.com>, Oscar Salvador <osalvador@suse.de>,
 Mike Rapoport <rppt@kernel.org>, linux-mm@kvack.org,
 Yong Hu <yong.hu@intel.com>, Nanhai Zou <nanhai.zou@intel.com>,
 Tim Chen <tim.c.chen@linux.intel.com>, Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
 Yu C Chen <yu.c.chen@intel.com>, Pan Deng <pan.deng@intel.com>,
 Tianyou Li <tianyou.li@intel.com>, Chen Zhang <zhangchen.kidd@jd.com>,
 linux-kernel@vger.kernel.org
References: <20260408031615.1831922-1-yuan1.liu@intel.com>
 <20260413130633.knzkliyqvjhuz2kd@master>
 <1928b6b0-2ec3-43ca-a41b-e880d974af04@kernel.org>
 <20260414021219.wayysugpfbzirzh6@master>
 <fd59736d-a02a-4693-9e70-23c593c9dac7@kernel.org>
 <20260415023015.5i7hrixrk64uzjqj@master>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260415023015.5i7hrixrk64uzjqj@master>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: wgjcumfpqbbk7xwpwctwx4qb4tbcd8q1
X-Rspamd-Queue-Id: 60AE180013
X-Rspamd-Server: rspam09
X-HE-Tag: 1776244279-289566
X-HE-Meta: U2FsdGVkX1/eKx8t27DBDUmiB1A2B7uy1LqIFCYA1qHCPa0OMW+NmumbCNGz9QqOCW4AiUBVtLjpRuXGbtD64YY/z0+Gs0Y/jqGBYPOkvlyfRwsViyztjlFk7RfEfRD030pjxiTkU2e0KLotpvvbjWkYrDN4B91WH3tVT687plgDJq4l/3iRtgjJtuSv9AVUbCq0DIiuADEprFrehyygit8jHKQ58HPyaYm5vzb8zsdg7s15byeC3F/X1VKEAsK9YBzHBiKiPgCim1uI9vVkIOGYhIsXwA2D9zQz6vUoO+xt5eRcjuPGpxUvxuWn2QCIQVrQYlrYBSrDqJ/XfB54oXNZBOjGOzczzsVGVAKKilwc5fFSXba6zNwrDf2dk58IWYWlsWnWhrLH6t53D+pmjx0RuyHhgXBt/sbTtS4nlTU0YkGbGk1LoBbq7dEzAJgLxaHk4vcT+wrkZhstFInIguRnCiHy8431EUnCFzCjFNxQTZS3tLQ9nF1lRKCjqMJw20iG2YgO/YvftKkV6F4BPBrh/7bESV/bJw96b+9tFYM6G2kQ+MOHFgB3TySzac1qCnI5za4OdlDd0am9N7VFmglZUJcMX1UhGy3GkeonC9SeFzRJgZgJmcLzyc8/WYttu9bljbsTaqdZA1PKGxmtYFOL/N/H5KsQbMsArwQUGlhoHpSIUHMQGfClAAjGuY/VZav/cenNGoaEGpLSyPIidoIrWWeqxOMGgTxZvDor0qPvAuLSs6i3v6y7csqtkTlclaSxsKczSAIgShFFnxlMFTqjr/Sp/lM6nN/U9KLxjE4nzmeCRJ8Jr5UGpgUJIiGn/z97eWEbRsGcU2PcMDCEaOwa1f09oQGDdRi6EDPjQG/OYDwE1t9jIdtIpFjA6XNqIralKkn9vnsGkcw9fueuiCnTK+5tP396Qh+7dCaF+Dj61k9EEfhO7pXMJHF3VTZkGn4nuzUuFVvJDkOTYHd
 5Xh98bdd
 MNaq2pWhlz8xr+6AbMLo1fWr2CohYrOCma8x9qWCODgPatVAwkqWdrGqaxJCTIaHYYQX3XifSXv+l/pbJ4ze4yrx964Y8oKKOaf1KUfllddurSoAxEJzRroMJK6QCd/lgMRCk6P91FhAt7vRpSvkIh3cM7b5hskC1jbARRNtt/Z1oOQdaOL3GzDscbdOjNEXxV88eY6rQWiclPz0QScDunAj/wbFcPLL757kjukIOzzPibecxN+N42buDMm5hHgqwsIWmlGdpjOGMRXWZU2d9YXM1usYjJXe40C0FanV7X0bDSl76YUXDcl9XiVmyY5hl5URnV/ht/emNFqGjxbWkF4wVYHBpRLRSaiGBqIC632Z1di4W0G30zAUExpJ5hubYrKTP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/15/26 04:30, Wei Yang wrote:
> On Tue, Apr 14, 2026 at 11:32:13AM +0200, David Hildenbrand (Arm) wrote:
>> On 4/14/26 04:12, Wei Yang wrote:
>>>
>>> Yes, I think so.
>>>
>>> When memmap_init()->for_each_mem_pfn_range() iterate on the last memblock
>>> region, init_unavailable_range() will init the hole.
>>>
>>>
>>> Yes. I guess you mean sparse_init_subsection_map().
>>>
>>>
>>> You mean there is a problem in first_valid_pfn?
>>
>> That is my theory.
>>
>>>
>>>
>>> And it should be like below?
>>>
>>> 	if (valid_section(ms) &&
>>> 	    pfn_section_first_valid(ms, &pfn)) {
>>> 		rcu_read_unlock_sched();
>>> 		return pfn;
>>> 	}
>>
>> Probably, yes. We have to understand if other users would be negatively
>> affected.
>>
>>>
>>> IIUC, this would skip hole and leave allocated memory map uninitialized. And
>>> then those pages won't contribute to pages_with_online_memmap, which further
>>> leave the zone non-contiguous.
>>
>> Yes.
>>
>>>
>>> But we want zone to be contiguous when we have a hole like this, right?
>>
>> Not if a subsection is marked invalid. That's why the existing scenario
>> is that it will not be contiguous.
>>
> 
> Let me try to understand.
> 
> During previous discussion[1], we want to define "zone->contiguous guarantee
> pfn_to_page() is valid on the complete zone". So this definition is not true
> now, since we found the behavioral change.
> 
> Because __pageblock_pfn_to_page() won't treat range with hole as contiguous,
> detected by pfn_to_online_page() on invalid subsection.
> 
> [1]: https://lkml.org/lkml/2026/2/9/550
> 
> Now you are thinking the problem is in the iteration function,
> for_each_valid_pfn(), used in init_unavaiable_range(). It should only take
> valid subsections into consideration, even for early sections.
> 
> So your concern is if we change first_valid_pfn(), it will affect other users.

Let me clarify: We created a bit of a mess.

pfn_valid() says: "early sections always have a full memmap, so even invalid
subsections have a memmap".

pfn_to_online_page() says "it's an invalid subsection, so it sure can't be
online and the content must be stale"

for_each_valid_pfn() obeys to pfn_valid() semantics, and we use it to initialize 
the memmap (that's not going to be online) and accounts it with this patch here 
as "pages_with_online_memmap", which is wrong.


The *cleanest* thing would be to not handle early sections in a special way. That
is, don't allocate a memmap for subsections. That would remove the special
early handling from pfn_valid() and for_each_valid_pfn().


As an easy way forward, maybe we can just make pfn_valid() / for_each_valid_pfn()
behave just like pfn_to_online_page():


diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index e6858b13a0be..bfa5c3df5ee2 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -2253,6 +2253,10 @@ void sparse_init_early_section(int nid, struct page *map, unsigned long pnum,
  * there is actual usable memory at that @pfn. The struct page may
  * represent a hole or an unusable page frame.
  *
+ * Note that this function returns "0" for PFNs that fall into
+ * invalid subsections as part of early sections, even though there would
+ * currently be a memmap allocated (that should not be touched).
+ *
  * Return: 1 for PFNs that have memory map entries and 0 otherwise
  */
 static inline int pfn_valid(unsigned long pfn)
@@ -2277,11 +2281,7 @@ static inline int pfn_valid(unsigned long pfn)
                rcu_read_unlock_sched();
                return 0;
        }
-       /*
-        * Traditionally early sections always returned pfn_valid() for
-        * the entire section-sized span.
-        */
-       ret = early_section(ms) || pfn_section_valid(ms, pfn);
+       ret = pfn_section_valid(ms, pfn);
        rcu_read_unlock_sched();
 
        return ret;
@@ -2297,8 +2297,7 @@ static inline unsigned long first_valid_pfn(unsigned long pfn, unsigned long end
        while (nr <= __highest_present_section_nr && pfn < end_pfn) {
                struct mem_section *ms = __pfn_to_section(pfn);
 
-               if (valid_section(ms) &&
-                   (early_section(ms) || pfn_section_first_valid(ms, &pfn))) {
+               if (valid_section(ms) && pfn_section_first_valid(ms, &pfn)) {
                        rcu_read_unlock_sched();
                        return pfn;
                }
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 330579365a0f..6d0bbf8a2159 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -775,8 +775,8 @@ static void section_deactivate(unsigned long pfn, unsigned long nr_pages,
        }
 
        /*
-        * The memmap of early sections is always fully populated. See
-        * section_activate() and pfn_valid() .
+        * The memmap of early sections is currently always fully populated. See
+        * section_activate().
         */
        if (!section_is_early) {
                memmap_pages_add(-1L * (DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE)));



It would now return !pfn_valid() on subsection-sized holes. The price is another
test_bit(idx, usage->subsection_map) check for early sections. If that's a real
problem, we could add a section flag that just caches "full valid section".

> 
> If the above understanding is correct, maybe we can use spanned == present
> to do the trick? Because holes are marked subsection invalid and holes are
> counted into absent.
> 
> But I see the mirrored_kernel thing, not fully understand yet. This is the
> reason to prevent spanned == present approach?

I think we have to rework the way that mirrored .... stuff is handled. It's
way too intrusive, and the memmap init special casing deep down in there is
just nasty.

I'd think that we should just skip over mirrored part on a higher level.

My understanding is: mirror memory has two physical ranges that mirror each other.
We expose that memory to ZONE_MOABLE. But only one of the two physical ranges
is actually used by the buddy, has a memmap etc.

The other (mirrored) range should just be ignored entirely.

-- 
Cheers,

David

