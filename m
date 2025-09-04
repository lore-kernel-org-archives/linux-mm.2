Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E56ACA1012
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 07:47:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 758958E000D; Thu,  4 Sep 2025 03:47:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 708D78E0002; Thu,  4 Sep 2025 03:47:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F8168E000D; Thu,  4 Sep 2025 03:47:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4C9858E0002
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 03:47:24 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DD6B811AD20
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 07:47:23 +0000 (UTC)
X-FDA: 83850787566.23.207A322
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 3DE2D120009
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 07:47:22 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mrGnfIHy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756972042; a=rsa-sha256;
	cv=none;
	b=phYReznmE8MYugedY5CxbbsreeqORglPCgdpmeLx0BUpoHxXXzAv/OZV0GccVcNesstcVJ
	bEoF4F6nbqIjG3aPdSElsG1w1KlvtL0IZasQ5QGGGKE4Dw5YnS7LHnEJq3Rf3CjLywJkDw
	ttuMtRiZJkuYVdwNKr+A84V6mZRZAFs=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mrGnfIHy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756972042;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zqPtmsvQdRUPF0MN5VecClzZ/UGWInhgZO8j2GdgZK8=;
	b=Y03D0k2jvbkPNzcEgB7K6PrtprmrCvBjUr38hofpcu3rTKzHhf89riOs+l0xQU+6JQuiWC
	elWFjSp3KhlUlZRKdRtIq63VfawBYvDgtqoVy0vl14ymQHn303iACkfg1L3uhTF0pe3XNG
	fE8NU8mPU1iP74KnkwvrpTUMASGv+L8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 60B3A601A4;
	Thu,  4 Sep 2025 07:47:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06C7CC4CEF0;
	Thu,  4 Sep 2025 07:47:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756972041;
	bh=RdxnZN7SSA8WBmRvG93DF96dGRkqV/lygyU5uiMSXd4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mrGnfIHy/ew3+TDD2Q+GIWT/eihpT0m8aQUi7r/kFJ2QGsPaaHuRfGx9hSOOlwEo6
	 a7M7QvX24FuWzY1GyGMrKeVe6AdzkSU9QxfZO44RrMDkjocqSFykak+lxA1G/r+xwv
	 qUNNMt9lvCPq6b2locszWGgIF5qgLQnuAC46fb3NcSI7F0brH96Fdz5nymg7nkEyjA
	 a6XAH+KyIkm2RwwNlWVT9Iz2x2uc8rv7zHQ6JXW0UDOngW0z0tRUiheYtEOvsmPvjA
	 N2PcW/4cpdALn8PVZGwyYPV2w4yEHSJKDq4e8+LmY6qZZisv6e/jO9a4sWjrG++op3
	 tx4tEm4HPgv0Q==
Date: Thu, 4 Sep 2025 10:47:07 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Jinchao Wang <wangjinchao600@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	"Naveen N . Rao" <naveen@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	"Liang, Kan" <kan.liang@linux.intel.com>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, linux-perf-users@vger.kernel.org,
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 02/18] mm/ksw: add ksw_config struct and parser
Message-ID: <aLlD-74aBdb-ZD5K@kernel.org>
References: <20250904002126.1514566-1-wangjinchao600@gmail.com>
 <20250904002126.1514566-3-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250904002126.1514566-3-wangjinchao600@gmail.com>
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 3DE2D120009
X-Stat-Signature: 7riedqku88idmk8ejf3ikgtfos64ea39
X-HE-Tag: 1756972042-747032
X-HE-Meta: U2FsdGVkX1+yr45ofMkLKLi2crlS0X/BSfKuTDR8xh1++VP100ga2QTOhQgqI/rG8MiHo4lXADHX+6Bv8mxPUUOGTeg2HGdrJ4pSp5+LIAliFFSUNRmFooaiNVqUTx7owJeAgjaucYDb2y9U9CwviJ8yToluS2R3EIi1WI+gQe06iYiEF+OJB/03ox2YrX+08+vNzQdV0QE4YCVIfim7VCR2vSnbf72ZZv3EnJDCsvvB5kHB4IjnNQ5XvWcMLPwNwNOrFzyAzk50CzPxUgBCQ886VhlgV0130KqBKf7QauRD4AbqED+cWvSaC+cjbE3dL9gficZ2gEqxaowhrjtuJ7ibSGrFMS+RutN9Qx/7dzWe4A62hCrIC7JNMgWC1SoeIi2SbQugEVHAlMUxZnnCaat5WoaovvsFuEnO1bSo+chzdW1Lwizitg4M9dgDnk5bL80GfZCaNXBBgOlQjYm3VNA8RKT4wEJMC7MthbfLd1onoQqkkj04YpuyTeGZB7MiZM/zesZ8QiGnGYlqAb0r7KJBoWEImdDCpfSDg/V48PVnQ7OWbtVFTsgB3U4WjSUlckFlBu0+5SHZHGnchSi7Mmcukw6dOeJ8tyPgoUBR9VMCptl5obnWtHThPYC5pqcdCFlY5HnNGq/A1yaYQ0hwPToOoU22rJV4Bd0thMt4VOidYVu0v56vFrTXVfqtGYAJn/+VJ94xJ1L8bYbD6igwi2nHCu9yniy5aGXcNeKp4I2m5kCz8jzk865VI9ENkP+QunD5Ceu4ZUDsYF8K6okLv9ueW/PSvdg5436qt66i/pUpQ/WKguArzYgJ9xpCXq7vAc4CDyp+B9CuajMywNSSKDjp+RDz3oittZT9wBliUJtrZjQ1KRwp8dATEgP5J+6eFHQzNMUNFuI4TFdmmaJTwbUEkjf2VgirlG0NxzkWTb//0YHOMp9WusjwbPA8YDO/5/VJH8sE17qM+dl7t72
 fVSOm2I5
 DIj62KyBaH7cyTB0DSGmmUiyiZBCsg4rdgm3eL82yNjHaJRRw8s3G4Of3cUJnaruz3f0w5vjK+MvUonGrerKV067UBDntZEeggiOYH+UvShwXg/U0Bc7PhiPFAvXtP1uyzk21HFXTDTMW+xx/toiGfUUqj/TPc22nvnSwNLP71Gl3Ix2VJJJkd1gazy6Fie7VZ5KCOZ30nP1X/cFDr5Ua/e1tSsbjI7HyiWrW12B9coN4IJZyEYKcvYFneKndw8EkOc+PnbbMGulpxPTIeBm9galAeanYQJX+srnvRJvmulDMOll2+lxz70Z8/gdhMyD9iCKDlDrbI4WKVtE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 04, 2025 at 08:20:59AM +0800, Jinchao Wang wrote:
> Add struct ksw_config and ksw_parse_config() to parse user string.
> 
> Update `Makefile` to pass compilation.
> 
> Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
> ---
>  mm/kstackwatch/Makefile      |  2 ++
>  mm/kstackwatch/kernel.c      | 70 +++++++++++++++++++++++++++++++++++-
>  mm/kstackwatch/kstackwatch.h | 34 ++++++++++++++++++
>  3 files changed, 105 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/kstackwatch/Makefile b/mm/kstackwatch/Makefile
> index 84a46cb9a766..d422f0e114dd 100644
> --- a/mm/kstackwatch/Makefile
> +++ b/mm/kstackwatch/Makefile
> @@ -1,2 +1,4 @@
>  obj-$(CONFIG_KSTACK_WATCH)	+= kstackwatch.o
>  kstackwatch-y := kernel.o stack.o watch.o
> +
> +CFLAGS_kernel.o := -Wno-error=unused-function

Can't you just add the function along with the code that uses it?

-- 
Sincerely yours,
Mike.

