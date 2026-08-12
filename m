Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 494A2C5CFDB
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 19:40:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E5716B010E; Wed, 12 Aug 2026 15:40:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1964A6B0113; Wed, 12 Aug 2026 15:40:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 05D786B013D; Wed, 12 Aug 2026 15:40:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D67606B010E
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 15:40:04 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 67812402F4
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 19:40:04 +0000 (UTC)
X-FDA: 85093633128.08.3A600BD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id EE29F12000B
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 19:40:01 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=grY6uH5B;
	spf=pass (imf29.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786563602;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+V5LRdd/R0h7cXLztn08lUOOQg5FGK1eTSy1m6UYH7U=;
	b=C+3p6iNcHSaq04tRXfx1q1ja2nmlLA4J4JqnxLofLNF8WPfwMgBLYmxPYxnOzhQeerC/7o
	Nh9owNyoofuTjBHpQNT6f3xOaZyWsc73QxoLEZI6NI2BFWEBlES2pvi6sQ+rUznQjx3HAR
	hCdWSL0VyLSGWhRyncXFOXAOyqFiYtA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786563602;
	b=cx7wLlFLE0xtLcsIzqhGtmxKYeEaMZ0eRn4Ab4JDqB+q8bytqzEnUx26GuXsx5S54MoiDz
	L43uLuq/6jDuJmM75wxA2HVll00J6Dso3Spk9kQHa2aJCP5y3NSiCca8c2yiPHWQ3EYIaI
	wBYmPN1KcjgZJFbgyrflwO/LwshFzvc=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=grY6uH5B;
	spf=pass (imf29.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DF53A43548;
	Wed, 12 Aug 2026 19:40:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D94D61F000E9;
	Wed, 12 Aug 2026 19:39:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786563600;
	bh=+V5LRdd/R0h7cXLztn08lUOOQg5FGK1eTSy1m6UYH7U=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=grY6uH5B5e7oU07jxKUcXRUTvgah3znWUvLf/RPTAQ79zlaNVQQXG6MjeAD/xOE2P
	 WpFg6jk41ydmKaN6fruJLpLygB6f9qaTPylVu9zqffvl5udMPOQVWywIA5d8drCxQi
	 YDFel4GnlHOgYngShUjJiUWjsxiKDv1LcfAiAA6Q=
Date: Wed, 12 Aug 2026 12:39:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "Nico Pache (Red Hat)" <nico.pache@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, Lorenzo Stoakes
 <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry
 Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, Usama Arif
 <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
 <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan
 <skhan@linuxfoundation.org>
Subject: Re: [PATCH v4 5/7] mm/khugepaged: Refactor the PTE state checks
 into a helper
Message-Id: <20260812123959.d4e31d68e8db85b9fd3981eb@linux-foundation.org>
In-Reply-To: <f1371b4d-6e98-4699-8c1b-7612f6d70f02@kernel.org>
References: <20260811-khugepaged_pte_refactor-v4-0-ddac39d61c4a@linux.dev>
	<20260811-khugepaged_pte_refactor-v4-5-ddac39d61c4a@linux.dev>
	<f1371b4d-6e98-4699-8c1b-7612f6d70f02@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: yrem1j6t5buhe7q6aht6h9t4eoghbz7s
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: EE29F12000B
X-HE-Tag: 1786563601-205552
X-HE-Meta: U2FsdGVkX1/yqo9/CFQc6EiuzeN3IqsufAlOrOZJPwJkJZ0/eJ0Wb+762Hot6klWXmuoDJcQ8SpNs4txqL6bu9vObfj/a2nL8IyiTAGJk7CE9tgds1gHH8MrKOaUhGM9sXKuY5k1jbLUlDLrfcfSI5+8CSb2H4mtGy18Drr0jirJe3ufTSYITRiUW+IVFcG5LWC7h66fVbIPO1NILIXM9Qc2WDeNdKoV47KwI2j/BHsfuz+JG2+tIsTszqbfatT2p2dIx77O4uebjtjqh5HYry/ruKKVrFkQ7jyKcFBkSD8m2MIwf6jLSMemTQCX4ez0rEXEZqhRmlwk5DHM2/2BB/f2PLOU6GXn+nNvm4hudNskgk+GXAyi3zzbjauAao46LyNlUu8OFZh8zn+mwrCIXGcvASLkcMMIIY+mBcwhCpjEIU/ZZ1NdPEv0dXAuY21GQvAua7eST/P+ouzwW95DrXKTIR5n86/hJ3VTtOU8xu3yO70YesvJMg73NQ9r5UvEYGhmiksHpCu+qcevPp9x5kFJgskqc/u0VU0R3Z05Ce4AX7kb2EQMRGwR+EBVifkZkg5pxweZfhXcc/8902X51tVu4mwByHBGcEORkH5wuBwXE53B8GLUOxXjmDm0bahyn1NdOO1KsR5JFvVDPjSj8Bd5S8AMtXwTRfFN7bAv676IGa33VHaxMyyqvlEV6RChULWhQV9EeZ2Y9v6MzbZ8sssXLm8hhlSErkpGdFOl0z+A0OTeuzjMcc9F218FaGb42HQ6aBIBCScpx2nSrMAUdr70P0xzt3XfdxoF3m2KojDeh4Sz3fERhrWFnWWPOXoesPIEmHCY++wNHi1AhsmtDZbAbLvDY2h2UW9wIBTtvSZPpDeg9CX73uy+tmCNCSj5Sp59aTFt76poL6Ac89ToQJdXs0cziG7txuMEclJ/c6FiuKyVMGX13fomkGcbiCoi4Vwoqkqe4CrgAymrlxP
 keL7VNxj
 j5vW6d1lIEOWm8A6dwCmp/XenEeN+QHc2sdNZFMEtKAwY31eR4uDRVJ6tLsVEFE6h0WVlYoNCQsLYBUbQiE9pEb1RXfjigLDpXzPsLcubNYD0quiMMBbV+DwZJQf8z7j7mECEeT5eg8PaBtKA0l74DCGHDPfYhGA+5iqb3MObedtQDPhuywVzPi7+Xcs8bpEDzCgCV6qV+vPntybuDtQc2D9zn27kEBN4ae/vqAR+UedOgwdR2QJBz/7ie/E9e/vMEtyJ/1ydLdP4uBQK7z+x4G08Eg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 12 Aug 2026 10:40:08 +0200 "David Hildenbrand (Arm)" <david@kernel.org> wrote:

> On 8/11/26 14:48, Nico Pache (Red Hat) wrote:
> > For anonymous collapse, the collapse_scan_pmd() and
> > __collapse_huge_page_isolate() functions share a large portion of their
> > logic. These functions both check the state of the PTEs and verify the
> > following:
> > 	- max_pte_* values are not exceeded
> > 	- uffd is not active
> > 	- lazyfree properties
> > 	- non-anonymous
> > 
> > Merge these checks into a helper collapse_check_pte() to reduce code
> > duplication. We also add a helper struct for this function called
> > pte_check_context which allows us to pass the required parameters in a
> > clean and elegant manner.
> > 
> > A helper function is also introduced pte_check_fail() to provide a clean
> > interface to set the pte_check_context failure results and return
> > PTE_CHECK_FAIL state. This helps reduce code duplications across the new
> > collapse_check_pte function.
> > 
> > Two slight modifications are done to the original functionality. We now
> > warn (instead of crash) if the anon test fails, and we leverage the
> > vm_normal_folio function instead of page->folio, this should be
> > functionally equivalent.
> > 
> > No other functional changes intended.
> > 
> > This patch is heavily based off work done by Lance Yang, but modified to
> > deal with conflicts and feedback received during the review cycle [1].
> > 
> 
> TL;DR, I think this patch here needs some more work, and we should not fast
> track it at this point.

This has been floating around since July 6, so it's never been
fast-tracked!

> @Andrew, can we delay this patch here for this merge window? Removing it from
> mm-unstable shouldn't conflict with any other patch in this series.

np.  "cleanups" aren't high priority.

I'll move the entire series into mm-new (and hence out of linux-next)
and shall await developments.


