Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 189D6C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 15:20:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE4C06B008A; Wed,  8 Jul 2026 11:20:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D95B06B0092; Wed,  8 Jul 2026 11:20:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C83FA6B0093; Wed,  8 Jul 2026 11:20:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8C3C96B008A
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 11:20:17 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 116CF1684DC
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 15:20:17 +0000 (UTC)
X-FDA: 84965970474.05.7FD2C00
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 562CA2000A
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 15:20:15 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RKJdhY+k;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783524015;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SyrH706BcdoEPwB9iPMiIaYpZBRwfJwZHUjuadUPpjE=;
	b=5/2nsxyuloofgr65WVxoNmhAjop1mh5HqQKG6hKLvnGe7vYFoWoTUnHYjBNMf8B7mHvix/
	Xj49esN7R92GZL4EzYzqOduqd0AjN3HclzrpdxsY+UJ8fRfnrI3WP2tj6g3tWzMvoeDwS4
	Jbe/ZLmVnyT79pLAU+pqJUPlFGQ7S3U=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RKJdhY+k;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783524015;
	b=GluPbJJV2nsptIFub8IjC9kSgr5AFqWLJkLw2GwnVBHOiRJHaa+ZB19UA4slIGrPfoPsG+
	V0oZ+JFiPvc0o5UpoiiVldNuaAlJ5YI7NSiakpvL2Kt7x0cyFWpescSULJNPPYJ47Uxznc
	A/9NJn75wIgc66m1Lj+1F0anlhbsPBg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D5EB26001A;
	Wed,  8 Jul 2026 15:20:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F3FD1F000E9;
	Wed,  8 Jul 2026 15:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783524014;
	bh=SyrH706BcdoEPwB9iPMiIaYpZBRwfJwZHUjuadUPpjE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=RKJdhY+kg4FpeHGOB5dQg2U5atUaHWmTubuJnOTz9OwrPzFKymVYGPYtEPyyJtsvY
	 PJi+oSoASNxhTO4dfBqg2Jx8dtwJrHtRx4t8Vd+fxjCgfRwTXMFHNRgwcg8lB1l+cA
	 IpMIyHjT9m2nGaeSnNnteLR4F7mIj87U/N17D1U83XwAfm4RXWOsNd+O3iyFr5oAlb
	 DTtgJtrv/a1dDRBjPXQ2Noj1+h0Toh+4uDUwT8uIRllEjltLB7ptIwl8ZKrIN9+LvF
	 OXA1T69+dXJKU/urt7OJq67ayUHMhdg06DeaSd3mpRindahvOzO6BYChGv0HaKGMeZ
	 by1y1h57Ikvuw==
Message-ID: <9d3eab96-55a8-4916-ae41-774318780df3@kernel.org>
Date: Wed, 8 Jul 2026 17:20:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 05/10] x86/mm: stop marking vmemmap as SECTION_INFO
To: Dave Hansen <dave.hansen@linux.intel.com>,
 Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>, Alexander Gordeev <agordeev@linux.ibm.com>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-s390@vger.kernel.org
References: <20260708-bootmem_info_part2-v1-0-156ce4986598@kernel.org>
 <20260708-bootmem_info_part2-v1-5-156ce4986598@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260708-bootmem_info_part2-v1-5-156ce4986598@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 562CA2000A
X-Stat-Signature: grzoknu889wqspdmsbj9gkinnftphgde
X-HE-Tag: 1783524015-28567
X-HE-Meta: U2FsdGVkX18wAG5kBGJPRs+q4J00eXg5Mkf8RjNdLOvxZge6w8XsTu7KW+d1Q+qkK9LQliylZ8Bgs/534gLt+Qt9Df1OFgbona/pAmDvA2f9IroVvrxJas2cXSQXkuVMEeT++FydYo2KY0vnjcUrgAA+tIkht6ujXE43ka8ipVIS6AVSxlfbp9NQptU2cWadAn5fy8lVXyxAYdW95ofdwMdHgGoniE+ExULNIpaOu5y7JjzeY0Aumwi1buBJbrR6LUhC/1ULbsq9GyDsJXAFOJo6zr+4HmHzkVz5Rm6eo5LL7nDT1K8SrwJvYf7PLjED8YM/Iy1ho6CmHl1AORsaR1FI3wk1sR7D1q9zjU5TCLBF8WJM/RgDZ08jQGFqlwfHYOJM0ahORSoBSMPYVsvCp5HA2xhF29nn+jzCFFOcZTb8iMFgSYlyPkINjU7FEj9WtyKpe/6ZXBG0hHs78pc2shyEk1ibLnY1YF1157ZSSjKDB8h9Rtl2pK5pedjzO8Q8kN9pT6SHOQ6sVO5RfqKs1PPmIHz++Hsr0+5dzhdnYovN4oDFJh65VjFQq08NwejXyy2ZLAo5gD7gOelZ54rvAXqkWlxZkVhKZ1PsiJzozP0TpF20H++GzCBcAC4d7EzdM/niXbxFfD53CiV6180cS3i85tCr7fJjte4h9sCpVU5qpRe/luGAmasBNRPDqvQK4TOzBgXusWBuOhhUOK/GxMkPnkYGX0pZ0c8eDD2bR1YXBdNWMHJ+o5tgm49o7Uc0NcxDhxvJ8MBir+gweBGvy67zSDaetQObIUQpbxo/PpdjEx6jwCGKWEXqc4moc+acCl5EbYYJtk1mL+msMHOFc2F6jfroFM25rMtdjBAdwqp+tLjnGH7Q204YmX9HesX//3vabL4mWnZqvyXmUBadb+SCjbqxPxPCUqRsikKBZYEX/5rqCsiuFjyuUMz9zJmHA0XnGEVUQ/3AQUc0t0A
 pc65dNnt
 3ot1eH8Fas3AEqIqOaxlqCRZ7BH1NHlmlAvK4LO03zhvFEeYbqAubpRh5OIzJ/OHIkh32Go3CCmBdisDeOeBLyy+mOBEr8h00+utPsTnkTonPkZitZITOEFZshw3D2G2eW3yHMYxCy036G0cNCe6guGp7TlJtnnLTheMgDduejqzvUfuP4TercGy+iwl0flKYvUg7Y3qnZ7gxjntqYellTpfXIeEToqKfKd8Znt0YgevvuRPi2WfTiUD098lsoFN9oSPBdgj8jp80xzCh1e+rZJwczkxas+m0k2QmSyEqXNHbae8eINvI+OQKTBr3nbnupP8HIMg39R1pnOs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/8/26 16:11, David Hildenbrand (Arm) wrote:
> We added the whole bootmem registration machinery in commit 04753278769f
> ("memory hotplug: register section/node id to free").
> 
> The main use case was to remember to which memory section memmap pages
> belonged, so the memmap could be handled accordingly when freeing
> memory.
> 
> However, all that machinery is not required anymore: a memory section
> can only get offlined if *all* pages can get offlined; and it can only
> get unplugged once offline. If some of these pages are unmovable memmap
> pages: bad luck, doesn't work. Offlining will fail.
> 
> Further, a lot of this machinery was required for pre-vmemmap support.
> Now we only support the vmemmap with memory hotplug.
> 
> So the whole machinery is useless today. Let's start by removing the
> last pieces by first stopping to mark vmemmap pages as SECTION_INFO.
> In free_vmemmap_pages(), we can now always just free the reserved pages
> directly.
> 
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---

Sashiko mentions the same thing about freeing page tables that are still mapped
that I will ignore, and it also mentions an oddity in the PMD vmemmap handling
with get_page_bootmem() (taking 512 references whereby teardown only drops one
reference) that I will ignore, as I am ripping that part out completely either way.

-- 
Cheers,

David

