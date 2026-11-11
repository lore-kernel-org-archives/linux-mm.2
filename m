Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77DF0606A326
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 18:19:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=Cj5Tvm3G
Received: by kanga.kvack.org (Postfix)
	id 5F4E26B05B3; Wed, 11 Nov 2026 13:19:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A6506B05C9; Wed, 11 Nov 2026 13:19:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BB276B05D3; Wed, 11 Nov 2026 13:19:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1F74F6B05B3
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 13:19:44 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8BA52120389
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 18:19:43 +0000 (UTC)
X-FDA: 85423651446.03.D35EE0D
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf04.hostedemail.com (Postfix) with ESMTP id 7155A4000C
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 18:19:41 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Cj5Tvm3G;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf04.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794421182;
	b=rCAAz3jtpdKd/TQBf9kdcIJIe2mjSNxTFKJUhaUeLgUrDiBsN+X7Nj7qhO8dfnBNaA9Qt2
	tCwMwgpubyLuRyPPGpmyyif9K1nWZEmntjFR/6A47jeKjAJkgo4f6r15YjIpwRe1hOHrDc
	NzneUqV8yME6eOtyzU6TGNdQUIPxETw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794421182;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pfXEXdjQzZILw838pgfZ70Et9pyX3bVcetws/5uL/zw=;
	b=RhuutBejs7nwwpOo98IaRhgTVS9Nzj11245l2ueh70OlyA7qXeiRCko8GkfDBBxRX0IblJ
	wWUUE7J27xVzED55qnIi0vU4KhPZfi0qvlY/TDXGTPH/h8Z5+/W/hU7KSb0a1kkVlAe7Gd
	zSRWJmYcg4/+7M4FJdUUd93GXjKFphA=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Cj5Tvm3G;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf04.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4A15E1576;
	Wed, 11 Nov 2026 10:19:37 -0800 (PST)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1BBAA3F632;
	Wed, 11 Nov 2026 10:19:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794421180; bh=pxMbuBYnl7smF+fcq5aPZzge8JNq0PsIOWBvviY84Ik=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Cj5Tvm3GOgQ6hwsYhv5MYuKsZdtkk5Gxs/yjbSHzfcAJbDMNnsmY077R/ag8kn/wg
	 7wi6Zvd1tg/X9S2bA3EtIvFKuopik1Auxq+lW5Ku+MDefJSPklDMDjSXkW0lw2MCC6
	 +QzpnS9PTiDv/BBv5Fw2y6/jB1jiKY0wjM4snZoM=
Date: Wed, 11 Nov 2026 18:19:34 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Yuanhe Shu <xiangzao@linux.alibaba.com>, akpm@linux-foundation.org,
	"Huang, Ying" <ying.huang@linux.alibaba.com>,
	Kaitao Cheng <kaitao.cheng@linux.dev>,
	"Garg, Shivank" <shivankg@amd.com>, vbabka@kernel.org,
	ljs@kernel.org, liam@infradead.org, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, linmiaohe@huawei.com,
	nao.horiguchi@gmail.com, ziy@nvidia.com, wangkefeng.wang@huawei.com,
	tujinjiang@huawei.com, mgorman@techsingularity.net,
	chengkaitao@kylinos.cn, muchun.song@linux.dev, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] mm/highmem: refuse to copy hwpoisoned folios in the
 !copy_mc fallbacks
Message-ID: <avSxtpwhTbfHi4zh@arm.com>
References: <20261110112641.1196786-1-xiangzao@linux.alibaba.com>
 <16cf88a0-6652-4276-95fb-12306e417701@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <16cf88a0-6652-4276-95fb-12306e417701@kernel.org>
X-Rspamd-Queue-Id: 7155A4000C
X-Rspamd-Server: rspam12
X-Stat-Signature: s4nz8wp9b6h56p6nmtbt9yp6n1h1wknb
X-Rspam-User:
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794421181-769610
X-HE-Meta: U2FsdGVkX1/XuvK9dTtauM3frDh6AOxuEP9Ms84y2WRQOf+ZNAoasFQDRegdrRFkGCqXEckACDkP6SRUkLRBwEmlr83/MlbjYS1zHNOdmN/oogP/5AIpadMycEljuu2cnx+9iJ2M0ONK1FTtE/j+YtaG3L2ImwpX4q7MyprKOUTB6NIPkD/GndPyMOP6wEJK/getI8EHWllw/vaf4pjDsCQpODeWjfQABbyu53GJ9TwaDTVUuTKiyt8M6dGkmOq0v+7fSsppE/GBZa9lxWX3pAUBK7ywHr9tajED3MNaouAPpG5z2CkrsJtgdrJKamvefyW5szUedhNvfhAyydf4Nmsiau8Z8fm1JasFdIeGautFpAEucPd4uiiA9FxiSmZvd6ygJgw/zvCj2PZ/oaSTeOZX6f3GCQLrnV/BImatV3lkavtpscY+4Xu4urqU4oJLNNM2CBCFMUdJylpo84ZCLeJM2Nzv+1+It+x7818KkJLB/YRmdC3UMtVJdDJ5tlBeuIr1jvhLXFeutNoRJ9/Gud2D5b4+EGOV+40YzIKNV5xT5ryo2vSmsrKPazY+5fUQ+L9FynT2MmfSjPVWql2grqucLAnn1RUTq791pj0MBTcE06GPJoAMcrZYVqNLv0AYb7bHRBEtEwmYDnIzPLiR9nuKsEZiaQbDeWYNpDl7pvnbwAycGBIqp7jYwC0YtjwjM8Vk979gw7+diXVsXlHTK6mqGkOjlP4SlyweLvoeZ6M2hN/g73XrJN43+TFq21iiZcyyfPf2V4PA3GadYwLPd41ncZG93UA9BCkbu29Xk298pYlIeKcrttTgVW2Iw5X9fqSLVg8F2v5lE5vZfE72+Mp7yZn3L1NVTm1FbxiDeK+ifVGJAdggOpm5mV3DyCE/VeY/XoWgPi0TBXvIYW+zce+LwblgW7db4YJ4fmpdVYpX5pLsG9Kl0bGLELKpalgXysnMrJY7pHuC9P/KbtI
 /c1mubZs
 SnjHsPZQ8jh9nXod/80T9LQORhzwctmdNdzdHMl6oKC6ljaV2cg6QMYvUZwB8IIdzNeny8kzwt3Cx3fDt4wIW6CRL6ADCS47CK4sVcqgq99lk2Oys/3gPHxL8jRPHnTMWkcoNQjpHVDIFrxq4N8OkW3nMcaZxHC8IeFeK4sKnhgdU3niD1RJKRgNpOHviPg5NRYedxRK2o3FXSZ6UrsdCj2cSS0X/aE2BeVhyJepiEyahxWcNw9oqJFfY4e8IduMKDjM4CUWGpjeXliEUcqNruyY2Ezm7CIwrDeOll1pKueiaa3jk3go52dAx9LWN25e+zgbW1OoMA8UmAWc3IfHJr/D++XJ4GBy5H5CWOjGTGaCGutj4uVYrgo8st+eKQEDjpA9PKIC61Vvj7LY1jIa/D6j0m7rRlI0ST1Sqvp6mMFlzsxCimq0BFqcBNVvlZWo7rdt5tXTJl7Xfy/xRfr2nwjaEnm9X5iqwlhLHaYEij5N7UBl9ezRtlOSCD3IG+WFSVNyvDuuDLOTEIK+9o0QmhE9WvPOZ3Vrde70+/7TezQNUlNY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 11, 2026 at 10:36:40AM +0100, David Hildenbrand wrote:
> On 11/10/26 12:26, Yuanhe Shu wrote:
> 
> While the file touches highmem.h, this really isn't about highmem at all, right?
> 
> This really affects any architecture except the ones that define
> copy_mc_to_kernel (x86+powerpc).

I think is_page_hwpoison() is compiled out unless CONFIG_MEMORY_FAILURE
is enabled. Only arm64, parisc, powerpc and x86 enable it with the
latter two having proper mc support.

> > The !copy_mc fallbacks of copy_mc_user_highpage() and
> > copy_mc_highpage() return 0 after a plain copy.  With PG_hwpoison
> > set while the data stays readable, there is no fault to recover
> > from: the copy completes, the destination folio carries no poison
> > marker, and the poison is consumed silently.
> > 
> > Check the source page with is_page_hwpoison() in both fallbacks,
> > before the copy, and return PAGE_SIZE, the not-copied-bytes
> > convention of the real copy_mc paths, so the callers take their
> > existing error paths.  On archs with copy_mc this code does not
> > compile.
> > 
> > Measured on arm64, where the fallback code compiles: a
> > kernel-space microbenchmark measures 90.00 ns per copy before the
> > patch and 90.71 ns after, 0.8% of the copy itself.
> 
> CCing Catalin. I'm surprised that arm64 cannot recover from a copy from a
> hwpoisoned page.

Yeah, it's been around for some time. Lack of review cycles on our side
as well.

-- 
Catalin

