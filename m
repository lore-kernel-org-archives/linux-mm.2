Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6168CA0EE6
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 22:59:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 544B76B009C; Tue, 19 Aug 2025 18:59:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F5E06B009D; Tue, 19 Aug 2025 18:59:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40BB36B009E; Tue, 19 Aug 2025 18:59:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2BA2F6B009C
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 18:59:17 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A984E1DBDF3
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 22:59:16 +0000 (UTC)
X-FDA: 83795024712.01.B1783B4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 152BB140008
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 22:59:14 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=wSLTv9O+;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755644355;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QF7ME5W9+V+A8GJKgmslFSm8v0JUVKTaIG5ftARNoQA=;
	b=w6tVemjxVOYJYONVGcsGdkdmE8Kol9Sl7TRP9wncEN8JTDLtgjNA4nVLUIYqoBOcp7C7ld
	KoMcp1Ov6m1ryvgRxSn+SB8QWqss0aYsVu7e2f4jxAKBWqjdz4n9AlAhmqXcSezLALwl2T
	9q7l3h8FIMZlt75eAdaI55Q3Ge7nC7Q=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=wSLTv9O+;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755644355; a=rsa-sha256;
	cv=none;
	b=PJ+gQxSonLnK5iFUIbVRVKDfRBCO04LamAcrTf6MNBK3KZBQeNAwc9juqs4W0GHl+InBTt
	8VIq2MnneHohlEIGe4WBHQ35pPDO5ae/CZ5Z/oLZEYuQjM3LBmPIzFrIFiZgf3TWOzUXW+
	Ppvjm6R7Ai0Xp3vi5W1LQGTynZVB9zo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 36836613EF;
	Tue, 19 Aug 2025 22:59:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A487EC4CEF1;
	Tue, 19 Aug 2025 22:59:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755644353;
	bh=BVbmAkMOYMUDWot0uFGf1xYhRBt7KqDDIeXylb23udU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=wSLTv9O+PtzDoICJq3wXd9IZimlNLA9NkvH3JEF++r5Tr6Bx5Qd11jreFlitCFR9y
	 Wredzfa/xj5ZBNJF+fDCAIDJE9/h5+zcQ9BzFkgHBwl53TqWF+2b6qyZJV99uCC9n+
	 qgnOa3FI9kfjeHWmbdKgqFPm/UOBDmJZNIG8ADHw=
Date: Tue, 19 Aug 2025 15:59:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Hildenbrand <david@redhat.com>
Cc: jane.chu@oracle.com, lirongqing <lirongqing@baidu.com>,
 muchun.song@linux.dev, osalvador@suse.de, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH][v2] mm/hugetlb: early exit from
 hugetlb_pages_alloc_boot() when max_huge_pages=0
Message-Id: <20250819155913.93e549fc5bd728c2f9ddacf4@linux-foundation.org>
In-Reply-To: <fc444f71-849c-48b1-8a1a-9bea6410ca8e@redhat.com>
References: <20250814102333.4428-1-lirongqing@baidu.com>
	<08cc4405-948a-446e-b198-5745c32f9ee1@oracle.com>
	<20250817195945.a845d2f5c045e4f60b07469f@linux-foundation.org>
	<fc444f71-849c-48b1-8a1a-9bea6410ca8e@redhat.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 152BB140008
X-Stat-Signature: rjfi9d1361wfjia6uw9ddz7a18dm5e87
X-Rspam-User: 
X-HE-Tag: 1755644354-978508
X-HE-Meta: U2FsdGVkX1967HwmUh3uQVwtpTQXlrGwVwoaOWBot0Z7fb3g2xsxwROItgwHLSWflAv3v9zt45Uu9I5lQZNob80QiVkbPO/RhnRxliWxBp2L0o8lXtjQDanPswCsD0VblxgioSHBe82Oyy2pwvzYaSkAR2f7svSZ4xvbpiO7O74zei0yiacmw1YmN9gjucCDKEyFwECDP2Ru7VUsNa3oH5+p7ff2xRJX7tI918DS4FNxYujtNkXD4c1YSib7RGbrnu+OLmA2Uu2WPM60sk1K+I7yEx9NY6Vd5+6rQzPcgFbZFVTmHEyaBbk+shgai0//AS74GMEg8HmZ+Y4O4h+WvWbvXklL54wfpeB0AYB4sEJblhEp2ul54ZIBTD+dHSudtjCbtOvgDj/fviOMZMstd46qV6m+uxKWuikg9Oxxcw6dPrwmPgOd98Z15WyZTmFXD4hrdznT3UZgsAagFALpar4PuPBjG4NiH6LRTiIOGbzqhGYTEjOqQNYTBRgdxJBj412Fb10AWNnHFDqtq8NDnQdmf/+oPCnViHSjfwxCddgDDwnpr8jeF9shsPbYhLMBt7VAtQLUBju/xsRGL8Fn45rXsk9uAakWzP39Su0xr+dDCRPFjr1vyUtdjexukbHoi8TBNkDq3KlyjofDhNNki4tTS9OArWoXUDTgNyM8T87n/MQFoO7+l/9XC65KzJJ4oW2tTCTryeSf7QjYpIByJA1za7Ch3TucVhxZJtHwg8KPjOv0i8vTRYNy6MDNRsjdRKUCiqaQfyMjc3ZQwwyFm3lzdKfF4a4VoBXYPqUK1du2/Js/M6dKK6GPCZOEOu7ja/iiA7ZxbfG5Sb3v7RPzKv1lfmJGj8aA6JXjpy2jnwJYAhchYpxXo88dc6egbgUZuJUNz/nrZyMg65FUwMp/0kGG8850fqU5tEX2mmqWxdTYLemg6REPs3cN0RalnXC2MBO0ZYMfoBslmq+sLrK
 AzilllL2
 /U27HOAUr55kOTHyxAUY9bcWw+3K2xP66ndN3l6TScWaiv88wvtb1geF5SDnT+3vH7yGuJEXxogtMFJ+QNjh08pNpAcS0z+RTzDRePmL7oA2k57h1cIdycmfCaCt+h2+kZBgASqNPBh+me9T3jT0Ax8yIi0a2I4r46A9DI2TC3kiGyViUrky53WymSoKHhNxF447IqcNL+3tGYFHkbWOPCTU39mzwpTQxt4Fou1kKahbcj2c0gnqR6S8BL5YZRBswa3S1VsBgF9C7/omzOmDX0NIxxJE+z3rkjvXROJ9FFbH5gd5gJoBhV65nlgFO6mHa05DZ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 18 Aug 2025 09:46:59 +0200 David Hildenbrand <david@redhat.com> wrote:

> >>>    	if (hugetlb_hstate_alloc_pages_specific_nodes(h))
> >>>    		return;
> >>
> >> Looks good.  Could you add stable: ?
> 
> Can you elaborate why you think this is stable material?
> 

To prevent the

> [    3.702280] HugeTLB: allocation took 0ms with hugepage_allocation_threads=32

message when hugetlb pages are disabled.

Yeah, I guess it isn't very important.  I'll destabilize the patch.

