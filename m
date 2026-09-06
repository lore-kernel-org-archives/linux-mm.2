Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2D2FC79F85
	for <linux-mm@archiver.kernel.org>; Sun,  6 Sep 2026 00:32:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2EB2B6B00B1; Sat,  5 Sep 2026 20:32:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C2EC6B00B2; Sat,  5 Sep 2026 20:32:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 200676B00BB; Sat,  5 Sep 2026 20:32:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F2CC46B00B1
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 20:32:55 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 02F97140406
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 00:32:53 +0000 (UTC)
X-FDA: 85181462268.28.5115566
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 4D92F100002
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 00:32:52 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=WgSsm7Ob;
	dmarc=none;
	spf=pass (imf14.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788654772;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JzguznGN4wZaJ4BaohUL/D8OCMllkrYSCH0UgmH3tU0=;
	b=jYsqaE4lquobtdQYHkahgytQ/df+jKpqCUSVnQXOiMBIQqlGPVTiqAmiypQRZKi1rUr5Ep
	QA5Wm+idhk5tQW0GTDRSPvsO7zAXmBo2k8pgaK+Mu5kWovRj1KGDYWXp1BFZ+h3hxeyEWJ
	uYszhycBXulO8RO/mv0RqDxFyITy1PM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=WgSsm7Ob;
	dmarc=none;
	spf=pass (imf14.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788654772;
	b=t2d48U66c2unAB6WZwQZ9Lhe1uCX61oibBwe4zDpclHOoqbXdZafv/CGfSFymgU1cqOE32
	tPAIuvOuwtgP/0gNdA2POk+YmkEKLmgaIR1PjrbkdZOO1pDRqFsx6pu28jqbqsiJTZlT0D
	QoLx10nMm7GwN0V5pnNi61a4851PqYU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1279F60AB7;
	Sun,  6 Sep 2026 00:32:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBF841F00A3D;
	Sun,  6 Sep 2026 00:32:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788654770;
	bh=JzguznGN4wZaJ4BaohUL/D8OCMllkrYSCH0UgmH3tU0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=WgSsm7ObXrMrJfIn8wocZvVmk1viVsJ8i/DGwFzwXHn7BRCWaJrz5waexMh61wfEZ
	 wOeNPp7eJW0KXAVEi1Nn5VEBdxXIymbBCxZnqcn26qOkA5ue3hfCB14lzppG13QxeZ
	 /MOIRI15EcghSoEiYeyN7l8hDKigwnfEu/K10i1c=
Date: Sat, 5 Sep 2026 17:32:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Sarthak Sharma <sarthak.sharma@arm.com>
Cc: David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka
 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Shuah Khan
 <shuah@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>, Jonathan Corbet
 <corbet@lwn.net>, Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard
 <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, Leon Romanovsky
 <leon@kernel.org>, Zi Yan <ziy@nvidia.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, Ryan
 Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
 <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, Mark Brown
 <broonie@kernel.org>, Anshuman Khandual <anshuman.khandual@arm.com>,
 Muhammad Usama Anjum <usama.anjum@arm.com>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v9 0/6] selftests/mm: separate GUP microbenchmarking
 from functional testing
Message-Id: <20260905173249.00f41b2a88abb0aefd217e94@linux-foundation.org>
In-Reply-To: <20260904123631.198697-1-sarthak.sharma@arm.com>
References: <20260904123631.198697-1-sarthak.sharma@arm.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: it7k6b7tbnkdx8wamdmchdookzr5mk4t
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 4D92F100002
X-Rspam-User: 
X-HE-Tag: 1788654772-452218
X-HE-Meta: U2FsdGVkX1/hI3TyUmdvKzHw0O5L1w6nXb8jLusEAn20oobbYqveN/qyZRqX2lAUaVbnpBJvzkXeqg53cfLwpne2JzGn6zAWPBUsqJv4chgaEipyy+TZSxQaVDqa80G94/8ihKtkFPpIMe3Bw4s0epHJ/Il0o1rBTzMiYVUvfYr2JxRfyNGzG/GeWWCJAZi14teU3RC66+d8LE0GB1FaPB8nmShmkz7chFvUXl2SUzobyeaHnigbDsyp8flGFPaN0GjftZThvNuL1WI52lBwyNxby2KGdwmwLJOAitVoL8mLM+2W0U3fi73InQxcfcg1WY/woaEU25GnqcG0Qi00F1EzxaeFRuc0cZqK1cK41kE/OV9bAALvhNv3pCKLLi9vxZUKK9fImhO1GiFlcck5VlYLlPDDDnV334r4qfnSPzjC2088S8zANXRmj6ooeDci1ssmygYqR2lziYLx1N8qG774bfAZGPTbi9l+W1waiB2aELZ0SQDecJyim5rTsnEkx+EVJmn+JuDUL3cfTAPZijtW0gWznKbOt22PBJRpcBVDxbf6aemo70weeyXwoEEfH0O+1BIMOsV9y48MvdOr3RzirIrGojPlXzjRjD9ezuUlb3z5NF4PAcrIj6ZdscweqYWeao2KOiUZbrER6xAQ6jk0SXWWID2ecRFKRjGuv5tsM9I0+cOGai3/ZO1JTIp8GfSsvEqgtMFaqCMSynaTh6gikfOkYOs36GkjjJr7GIjqUQARYcH9rgo6z+G8quKUyfvGdFn024iW0UXaAiPjeToW2KeqIR1UDGuoFGwBxCbaOn1PK5V4lR4Z/lBaxRtcaq8bKh7C9/vQ6340/ICLtKYBTYx93KV7vuv725yObsemYtia6+f5YrH+IvUuG1l6ZsbonxRy9Ll2jVxSlCNIUy0uRIjlFXZAKsIjwc5He+cCeba/vrAcQT+GO4xmoX1P3G5GNx01Bsu9BQwjNic
 KsmQuMeA
 W1JTGtlIFTw0+TdtQTDDT4t4A2yrXBjcyrUuiOjxmtqJ/tkBOy4LzYGAbQYLvSw9jbzoSAMY3snUmrsyI8hAt22oHatau1gDr0fBXPM9pzZsMpg5rorkMuFatYuvmyF730TJ+KCm+B6YChV1ujfKdBnxpDVs7JUYZQHe1efLwEX1my/TeAA0RrCOmRmSxNSl12mebzLTfgKrQgnBDrvFlbfiZ7JfkHBUtWGcgPPH5QGYNK3zMQlWXkGjUFMihxvVCN4sYYMMZ1m+blm12pakvx1+XiE8AZkEMQNZBM+tDppZin+CZfGR7cLQO6g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri,  4 Sep 2026 18:06:25 +0530 Sarthak Sharma <sarthak.sharma@arm.com> wrote:

> gup_test.c currently serves two separate purposes: benchmarking
> (GUP_FAST_BENCHMARK, PIN_FAST_BENCHMARK and PIN_LONGTERM_BENCHMARK) and
> functional testing (GUP_BASIC_TEST, PIN_BASIC_TEST and
> DUMP_USER_PAGES_TEST). Keeping both in one program makes the functional
> tests harder to run and report individually, while run_vmtests.sh has to
> invoke the program repeatedly with different options.
> 
> Separate these roles into tools/mm/gup_bench for benchmarking and
> tools/testing/selftests/mm/gup for functional testing. Move the shared
> file and hugepage helpers to tools/lib/mm/ so both programs can use them
> without duplicating the implementation.

Thanks, I've added this series to mm.git's mm-new branch for testing
and hopefully further progression.

