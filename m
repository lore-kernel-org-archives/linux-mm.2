Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF28DCA1016
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 02:02:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 32DD28E0002; Mon,  8 Sep 2025 22:02:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 304E08E0001; Mon,  8 Sep 2025 22:02:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 247358E0002; Mon,  8 Sep 2025 22:02:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 156F08E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 22:02:53 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9DD921DDDD3
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 02:02:52 +0000 (UTC)
X-FDA: 83868063384.30.6832BD0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 0E6D414000A
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 02:02:50 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=bQfHnx6f;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757383371;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yXHzUc6V0Xr5nwfxM7szaP0E6yYWRgfiJiMhbyyz9TQ=;
	b=NAAX0v+pLDk2cZUpt8T/pZsCukTh5IrU09F+tWXKmOfLAz2ayHid0/sRzpXoWSIzTDPUzf
	nZUt4twckSxcEgTITwiYloboEj67+YPLapmJl+gg5XblyvBWHkUeJYCPikCZSu3Q7DC/rg
	c8+JWVw7YQY69kZ4JRjb9LiWgZKLc1M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757383371; a=rsa-sha256;
	cv=none;
	b=dkl+gjFFXFLw0bdNLpp6GdqUFx9uEid6X8osB0c2ZlNu01EBnGrpIGC1eeZZKxPPWSXcFQ
	yzMbgSDJo38yDtpfacUtlW3XG1p1dFheziwmTCvT0j7FPMnwnOQKli0VY7gZoPbow2Wkcy
	nx3izlwAwzp6krZEWKfypZeWHEsgSXw=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=bQfHnx6f;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2D814601AA;
	Tue,  9 Sep 2025 02:02:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66513C4CEF1;
	Tue,  9 Sep 2025 02:02:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757383369;
	bh=c5J+iIMRm2kgguzDoOwH0NIHbsCxHv+R42DDyiYg0Pw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=bQfHnx6f4Rd++MMzXx4qgIhsJbsEpEKKQX2LoB8hcv1eLKSTsJqoO+P48jWA6fUbX
	 SWVr0MltkJjI4H5jIHt+/3pA6qiaZIF3x2v6qK45wR7zPmJXe+TmYgIRT7CEz0Y0Va
	 pg7E8qshmdjwufRFKKCZ/NnlQVRVbE7TImnvZdxQ=
Date: Mon, 8 Sep 2025 19:02:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dev Jain <dev.jain@arm.com>
Cc: david@redhat.com, shuah@kernel.org, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, npache@redhat.com,
 ryan.roberts@arm.com, linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] selftests/mm: uffd-stress fixes
Message-Id: <20250908190248.d2d6de27715fefc4e89afb10@linux-foundation.org>
In-Reply-To: <1634f29f-81a6-46f7-86d4-c9eac953d4f1@arm.com>
References: <20250826070705.53841-1-dev.jain@arm.com>
	<1634f29f-81a6-46f7-86d4-c9eac953d4f1@arm.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: dswofbtte8bsnc1f5jhg9ct6zmrzriyb
X-Rspamd-Queue-Id: 0E6D414000A
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1757383370-87102
X-HE-Meta: U2FsdGVkX18ann2ZBissKCFiVDylyL0pB/890POGQh7mv9fVwbqO9e/+CIa8MmMaXyltX/HXNEZS88N3gTL50GgQe1+w8d/Yo5o1bU43WMxB/slXuTrl1hY+i3IRkkxfNxgNuj/c3wvdvqHa5eOwUcaq4UcC+cgB3XIw3rO56AZVVnexwDyO3CmSbUVGrWtglW4AmUCgTxz1nQHJGhXMI4SNsD8XUtWTZ5Oh9mTo4Zrk2kHvtD9QO2d5hu9vWbHBAaGZMUu5QCZW9Hw4O9zsLfRxF+OYOKnO3xxY7K7uRVPoQVvGur066nnjLVPtfJ09JRZxyo5YA/y9knAiLsr56/P+BmyFoxfrpcAEM8qU/Q/kHk2ksEzVRaSPbO8hoY5SgvSOC8nDopTByuJM3WlWVekoUMw1+GqyqGm1e9te7XaNZ76HK7TqpAQ0yqXNfWi75GhIkenUC+9cE0ufguEO8/7hofVkK76mmYKyWvBioCjCxcV9lP0NtjsskFoR+jIwTsrKdcvJvwb8fugrBDpR1qyPuzkId3FhapMu4s9UGWfTVrZ7rE6e1fpRG5/hGFLOUrQmZCj5hE4CYKHpjZ0qPBcXi/hstF9gPS7zozf8xSpvnCE4s/FzwkZpyvfLs6LV85M59e93DBmh1/tmx7bJ/egQv0hwlQ0DP2J1+DxfzgoXapt3jyh2+f31Nm6N4lFrIL0Le3pUegJUvpBO1JGM41ZS/KXPKL+cXjE2eapkRxu8/T2upHaDjcDMslbhI3EMiiDlKCKFXAD7RYGRDdwQ6ZrsM3/BJRY1q8PSPcgB9k9VSbSaAPjxxOXHENCO0xjgYJ99z+JqSs5Y+Fa9W0EzIGmXw+vkIFD9bqZj5Igt56FJcK2h5q7F/Ja8DIjpI/DIkZj17UMs4G6tWi+MwaciSLgGvVNNkvxEeJD12EH68/oQ/bjbHlkfuEDKqi1T0UHK2UisDjl7dDMPUpm45Ir
 QWL7B5AQ
 Wi3QF3JwqCySfxhDgBvFzmcWSSbHQJX9JsqmfOmJt1vqS3h3dRbrA0Mivc7vhIH5fBXCYBHuUS5mp11r5Fe7SQHJJN4rD/ihuLD0EXwAgHFg8iLvX8KAaJ5eWjj/xJe0dvBUZg49jKcLDcdyR58RvpflFGX+Vmqr8cmd7MEzSHjbBWTvMZJQ+1bTqv7bsG3Bu6vl2eY7IWuo+fgpdx1v6HssvwxHxtHVn125kReWyFRilWGacyUb6OZXViTQDJSLybfcpRvbHzWFc5WTT3/WzeklCETyBpp/IkhuAgB65PaIe0MwIOWmn/XzBK2IY/vuKyk6RxR7SYuAoYmk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 8 Sep 2025 13:52:05 +0530 Dev Jain <dev.jain@arm.com> wrote:

> 
> On 26/08/25 12:37 pm, Dev Jain wrote:
> > This patchset ensures that the number of hugepages is correctly set in the
> > system so that the uffd-stress test does not fail due to the racy nature of
> > the test. Patch 1 corrects the hugepage constraint in the run_vmtests.sh
> > script, whereas patch 2 corrects the constraint in the test itself.
> >
> > Dev Jain (2):
> >    selftests/mm/uffd-stress: Make test operate on less hugetlb memory
> >    selftests/mm/uffd-stress: Stricten constraint on free hugepages before
> >      the test
> >
> >   tools/testing/selftests/mm/run_vmtests.sh | 2 +-
> >   tools/testing/selftests/mm/uffd-stress.c  | 2 +-
> >   2 files changed, 2 insertions(+), 2 deletions(-)
> 
> Hi Andrew,
> 
> I wanted to make a v2 of this series to replace 10 with min(32, nrcpus - 1)

That sounds line a one-line change?  Send a one-line change ;)

> (see computation of nr_parallel in uffd-stress.c) but I see that it has
> been pulled into mm-new, and on top of that, the following patch makes
> things complicated to just revert my commits in mm-new and make v2 on top of that -
> https://lore.kernel.org/all/20250830033424.8C44FC4CEF0@smtp.kernel.org/
> 
> So shall I just send a new separate patch based off mm-new?

Or just resend the whole series based on mainline or something?

