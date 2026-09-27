Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0CBBBC9832F
	for <linux-mm@archiver.kernel.org>; Sun, 27 Sep 2026 20:12:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC2836B0088; Sun, 27 Sep 2026 16:12:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4AD06B008A; Sun, 27 Sep 2026 16:12:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A399A6B008C; Sun, 27 Sep 2026 16:12:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7E95C6B0088
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 16:12:05 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F110E140A07
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 20:12:04 +0000 (UTC)
X-FDA: 85260638568.08.8E75CA1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 2D007140004
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 20:12:03 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=dBpbPeGS;
	spf=pass (imf26.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790539923;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zw6LphimU2j7rCWjyCWC5xM3gVDLoCW+f86+35F4nME=;
	b=GHvkwc1rIrocVLAp5lOXih59SxYnCUXgJIoP3QTDc9nU7+Zky+XDD7XJYgCpJ4wDosnIUX
	kAWUCgU2kj0V77vuF0jhycXJOR8vrDNQgquMPbmr8lbIrH+a334yDpZcyKvd3rw6TzxE32
	L/wezmJEV/Tu/0g7ONkQWPOq+tKNlAs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790539923;
	b=aMuqOUhCooWV8C4b/+VMIQbw8ZuIjJMQlkAXHh6KgY1RRi64Gg0Vz79cVO3mEXQo3oF3Bx
	QKuYaKKP4hfMw75kyfU4N5pIiwNCXQtFRL1mF/UWKOFHFmoRBJdNKVmdsDzxIH/z/BxcD3
	v5r2eWDGGfYyB7TMplHCAr355WXmYPs=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=dBpbPeGS;
	spf=pass (imf26.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5B03642D55;
	Sun, 27 Sep 2026 20:12:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D145A1F000FF;
	Sun, 27 Sep 2026 20:12:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790539922;
	bh=zw6LphimU2j7rCWjyCWC5xM3gVDLoCW+f86+35F4nME=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=dBpbPeGSTDE2LuiAUazsZ/tDuOBNiiEpN43Jy1m3MTjNiOKGPVgE71zF+8OPv0BTZ
	 nITFr2+WuzZvnTCyi5MO5ay+FthcZpnR3ha0cVrvtSDBkJvuDBx+sSl7aR8NHYDv6D
	 I3okQEEKN3W3jDjlb2CahR9TUccyAPgnEo53J8Y0=
Date: Sun, 27 Sep 2026 13:12:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Carlos Llamas <cmllamas@google.com>
Cc: David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka
 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Shuah Khan
 <shuah@kernel.org>, kernel-team@android.com, linux-kernel@vger.kernel.org,
 "open list:MEMORY MANAGEMENT - MISC" <linux-mm@kvack.org>,
 "open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest@vger.kernel.org>
Subject: Re: [PATCH] selftests/mm: cleanup -Wformat issues in hugetlb-mmap
Message-Id: <20260927131201.dfeeade5504b9fb707ad1e54@linux-foundation.org>
In-Reply-To: <20260927162419.820609-1-cmllamas@google.com>
References: <20260927162419.820609-1-cmllamas@google.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: wx585zda6s4pqek7fy6u3ztgmx15q6iq
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 2D007140004
X-HE-Tag: 1790539923-462924
X-HE-Meta: U2FsdGVkX1/l6wOnybdwZL9hdVdO027+2Dn2Y2qg9XO9c+70uuULqUcQNKrmbbeEWxDrNFKRwq4hB2bCfOL56XOSlXT2zAxjKREN5G6jNM3jGd9qy6nKZgZAdTjHAusWAmIWqYzQftD9uYn1dcR86voflEAun7EO1aD73eujNwl4U+SH3nVgpYLoeJMcpYB8ebaUR8bWsdJf3VJdzNyUm4zwpd0nN8qgyvSKhe1ql0WMWmZhWFSopCDiVT7uNlQFYTI5CYML27ZAFeWuaGRU0+qYt7OyIFzZd3vO9AARrCAcOBN0zODemD3Jx0BGV2mS2AQVFRs2XO4HbLXKAmJnh4SuS5oMMoppTfzosnK4BQyvrfG4aZecgLmSZhVbhxs2b0sVlTI6a3ar5P4wmvw4Skre9/MluzgcadlTiPFebHZr3rXI9s/+/hIwAinYUXu7JqKTnzaBEh5PIpkV2RuSNwqHBcUsAGXtGdlfwZopJh+L2UwXLzMB4qHMwcDfaZ6PVxAlnlt5juz8n/+Eauhi4Ca/VRyp+Y0SQoJN7bFruGCKdUbDByCWf8bhvLTnNjkXOJSgrJhuFSG6xulsaortHuc/bxVBpWWHUVf8YnNF630vYfw94+ir2AfbSPxSVSaTdXyTuuAO62/NXgbQTZtN2aVlArd08pD9fZrv7iMeDzeLl6k6Bo47nou+iA96oc9Y5xM8J+pkNsnQ3hl9MNFjM8hJEXLrMGBL6TBCJOCTRP0UjTPa+sukd5M5iIQWDYB+U7Fs2xrJ1NQzgEwRNtzSc0KYsqlwoYNiA3BbuIxdmJVRsWbYyygvO7EzbN953Sg1E9GclX47E8SjXJ1aLKRmy1CAwvzRTiBYWHESVEkNfGRKL1Ljqu9MEbllxPkvLPsMSOGdD1ibyzFcK3cV2YNT1yyrILkj+hX/5t/huBRg7k7Ic9ww9dtSx3HM3RKnRo4a2MlAJBn5lj+UCfEP1ba
 /jTHMnpr
 n/I7wXk+F7meKXe4mevCX6KG2XOCJeCne/PDGSBJ0qnbutr/61ddvYX/JpNhXxy8sJB+Nam4Xsrrv6GbPSSd2Cl25D+0Cy9Wy3pgmHujk3MmXNn1Jn42sSFPaKzt2H26oZMMy+kJvpCoiz0ETLvez91RUb3S5Ym7UGiYJVH2hJl2nQpl0h2nK3F57YhdGQHUqbFauZPNQmyg6V0/jQH2b8n7O+uK2zEOHlkh8QpcSlbs4yvAk9Z8OZGRytiPiuI9eTJB478+h/JpPZR1PlDz6zBIk/Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 27 Sep 2026 16:24:18 +0000 Carlos Llamas <cmllamas@google.com> wrote:

> Commit ae571cd6015c ("selftests/mm: hugetlb-mmap: add setup of HugeTLB
> pages") and commit 9c5a65f374f8 ("selftests/mm: merge map_hugetlb into
> hugepage-mmap") added logs of 'hugepage_size' which has a size_t type.
> However, the incorrect format specifier '%lu' was used which triggers
> -Wformat warnings when building for 32-bit:
> 
>   hugetlb-mmap.c:125:55: warning: format specifies type 'unsigned long'
>   but the argument has type 'size_t' (aka 'unsigned int') [-Wformat]
>     125 | ksft_print_msg("Default size hugepages (%lu kB)\n", hugepage_size >> 10);
>         |                                         ~~~         ^~~~~~~~~~~~~~~~~~~
>         |                                         %zu
> 
>   hugetlb-mmap.c:134:47: warning: format specifies type 'unsigned long'
>   but the argument has type 'size_t' (aka 'unsigned int') [-Wformat]
>     134 | ksft_exit_skip("Not enough %lu Kb pages\n", hugepage_size >> 10);
>         |                            ~~~              ^~~~~~~~~~~~~~~~~~~
>         |                            %zu
> 
> Fix this by switching to the expected '%zu' format specifier.

Thanks.

> 
> Note that I intentionally skipped the 'Fixes:' tag as I've been
> previously suggested _not_ to use it for kselftest patches. However, I
> can certainly add one if someone prefers it that way. Thanks!

I added cc:stable.  It's not good and it's worse with -Werror.  mm
selftests don't presently use -Werror, but quite a few other parts of
selftests do this.


