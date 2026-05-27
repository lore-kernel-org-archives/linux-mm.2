Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1BCE4CD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 18:47:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44D596B0005; Wed, 27 May 2026 14:47:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FE056B0088; Wed, 27 May 2026 14:47:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 313636B008A; Wed, 27 May 2026 14:47:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 224176B0005
	for <linux-mm@kvack.org>; Wed, 27 May 2026 14:47:57 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BA54B1C05A5
	for <linux-mm@kvack.org>; Wed, 27 May 2026 18:47:56 +0000 (UTC)
X-FDA: 84814084152.25.9B3CB59
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 089EE1C0011
	for <linux-mm@kvack.org>; Wed, 27 May 2026 18:47:54 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=osFGT9HH;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779907675;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dGFyRpMilg5FBEZHsEq53XOAuqN0WdRnl6J8HSeVqnI=;
	b=i3t2Grdhq5yUNUbBvQP1HtLkrz97dFRIwIQa/x3vusC0LlT2NnaxBBDw+o77kyDvL8jfCv
	IpBpc8HOvdg7+RV7tkXJIFmGBQuHo+g7ekhBhXQ95X/2O6mv+GlUL6dpHa6Bfb7EubZ6Id
	3arKQGwIeIdfUxYCIitmwia1SbYqTek=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=osFGT9HH;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779907675; a=rsa-sha256;
	cv=none;
	b=Ep4FxR+v8dsKopnvoo1t8t7K2oA60Mx9fpgsarX4ci35KhqSVfFDiVdOcqG94Ls+ct4MHs
	ZdrhqIb+iUDRuaSXX20UJvdCblF4aXS5yAPiWtfdt6oUKmpSIlO7V6eyqtW/bItf6y5QDv
	ouG34s1+hltZPkv9pkibcncu+bQhT5c=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4EAD86057B;
	Wed, 27 May 2026 18:47:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F19271F000E9;
	Wed, 27 May 2026 18:47:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779907674;
	bh=dGFyRpMilg5FBEZHsEq53XOAuqN0WdRnl6J8HSeVqnI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=osFGT9HHpNBx5BsDMr4gbf+ec/zmEIYPT/ARb+QrHwGAbLmbmGnL/6MYSdmMNX5Xd
	 tpeWdohoB3dc4jZgj5fxq+4jVmU0EhzuAt6Uj5tAFl8xqbV5pT9+QGX2dHBjn7Q5Is
	 xmLXLTQ3U68fI4GZ2lA0mMRC99J5NG6JsqHxR/zs=
Date: Wed, 27 May 2026 11:47:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Sarthak Sharma <sarthak.sharma@arm.com>
Cc: David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Shuah Khan
 <shuah@kernel.org>, Zi Yan <ziy@nvidia.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, Ryan
 Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
 <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, Jason Gunthorpe
 <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, Peter Xu
 <peterx@redhat.com>, Leon Romanovsky <leon@kernel.org>, Jonathan Corbet
 <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, Mark Brown
 <broonie@kernel.org>, linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 0/5] selftests/mm: separate GUP microbenchmarking
 from functional testing
Message-Id: <20260527114752.cf4dd3e1bda93fb8ebab5a76@linux-foundation.org>
In-Reply-To: <20260527142432.230127-1-sarthak.sharma@arm.com>
References: <20260527142432.230127-1-sarthak.sharma@arm.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Stat-Signature: 9h5hrj7anxbri8ooosd4kj3i6mjgjptn
X-Rspam-User: 
X-Rspamd-Queue-Id: 089EE1C0011
X-HE-Tag: 1779907674-370170
X-HE-Meta: U2FsdGVkX180/WKlJzlqEf/3wA2Vq/htD8zP/02OOo4yDawX4+ui35asniF2u8xbnhP2aqIma0qeml1FoMrBotXZD/AC74nwQYFQRNj6IMH9h8L2RNI4zu6jrf5dj5gjZDTV8iay73kc9EIuOlddDIEufU1EN2vgQuke/fav9zl8j/pURm6301d1d+MLgVfeYIsG0vNf6TFI62uS66jlj4om2UhNfOrdSKrfJNPUyID368k4p7UWB3XTKTzvhr7mLSO+4nc3JNj0VfpGhf8WJXHjAME7yT1EA5cWM/twyJfZ3NRTt3P4ga0yczOH22Srky/42t53HrhyfpAFH2Dblnuz7qx3QSb8LJF5qe+zxxXdSj7M9RHQXQM6waxeH+kFm+j71HejSDEy86PWY5XUPjFx0HcLiorRl6cPx0V0kDHamELhymFpD1mfwK7K7hvZTbPGfd4DVpIJedValP3/hEhe98O8XQOStpHHxiRfhCAB7Vxdga1l8gQCBJuzJ1LvBlFCWs5sRKFbkAysFXubcbubure/uNvR+S+8eGEpUyypRe9qKMZF41FNdrVlsvGYsuNSqFAhl+azTQ1hTvkJLzYNUOGV7eBQwmPaYujFku3fzW8IokTfAgJtz/PCNpeWP5Iq6bIzK8Gvnulkd9EMlnousNm7f871GnQzEpTfuMb1Uf0qvyU1uEJj7+AN8W1swYLGMv9WP293K/08rxDJfMgep2R19xU9q6FuiBnWjXy0wLHvoXrqKKwq2N9JKBXW8MyKHW1QLul9H1XeckxFogPuOQzVnmb88I1M8TWV/ZlUQsUuPd71hpaTHGFm/or7Ocs2euegnMDByWFmNYLvBq/EJfyuP9e7CNH83qGiU7Lmpr8jplTcPfe6yR6dLhbBhuQt2YQEu3nclzNX3oN62nUVEHi0Fg8raVm73I/Z8P0EOGgTgDqVjXQfdpzfUvvNGsv2k7SAoCjUsnM4x4H
 HCQPRyrY
 hL9Vm2G/GuNmptBylVNKPRWjMkS1Kwm9Q7XNeh9h6oSC3gralfOfOERclpTuyOMSgeCgTwNoOQLAKvvdC5BzIVfVqFTpWbcJhBRw+HEz9HWyK+dZ3vzdpu9U3SA4NUgfgy5ToMZSUpYJgtaEruEGXjRThY8knCn5ByIx+FsjuwUWY/dgoUaGd0kOeqbczO4ulxkqyk/T0IUgJh9STt4TjzB3le23AXzG7kQ1tsjIidKVCO56cKec1QPl9U1Qq98thuSdVJ5qvyCXurv0NTyUCeQ2WjXy9D8/ibhIwpSZpR16vu3uzA9uborhlx/VQ5WRjtJsmTxuAzNXx6F+/FTpTnxxrwhaqCKAoB9ZrTwcKh9QvUnKrpS847uXAdg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 27 May 2026 19:54:27 +0530 Sarthak Sharma <sarthak.sharma@arm.com> wrote:

> gup_test.c currently serves two distinct purposes: microbenchmarking
> (GUP_FAST_BENCHMARK, PIN_FAST_BENCHMARK, PIN_LONGTERM_BENCHMARK) and
> functional correctness testing (GUP_BASIC_TEST, PIN_BASIC_TEST,
> DUMP_USER_PAGES_TEST). Mixing these in a single binary means functional
> tests cannot be run or reported individually and run_vmtests.sh must
> invoke the binary multiple times with different flag combinations to
> cover all configurations.
> 
> This patch series separates the two concerns: tools/mm/gup_bench for
> benchmarking and tools/testing/selftests/mm/gup_test for functional
> testing. To avoid duplicating HugeTLB and related file helpers, the
> series first prepares the existing file helpers for sharing, then moves
> the common helper code to tools/lib/mm/ so it can be shared by both
> selftests and tools/mm.

Thanks.  I'll duck this for now, see what reviewers have to say.

Sashiko still has a couple of nags.  Minor stuff, arguably ignorable.
	https://sashiko.dev/#/patchset/20260527142432.230127-1-sarthak.sharma@arm.com

