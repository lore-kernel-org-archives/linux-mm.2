Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8539C61DD3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 08:06:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D31156B00AF; Tue,  1 Sep 2026 04:06:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CBA256B00B1; Tue,  1 Sep 2026 04:06:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA9246B00B2; Tue,  1 Sep 2026 04:06:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 952706B00AF
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 04:06:28 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 16EDB802F6
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 08:06:28 +0000 (UTC)
X-FDA: 85164461256.24.EB191D8
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf30.hostedemail.com (Postfix) with ESMTP id 0904980003
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 08:06:25 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=qSrnwwCg;
	spf=pass (imf30.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788249986;
	b=OljiFPNj9rB/H7KspIECtemojsc+GBPb82fqZnXghnDsAwiU4v9wmYosyVOZnLAlFMgtND
	OoSpjSAVdwx08eR1qQwQiYfRAGEEM4ntKPJ8pSi7mGx6wn5iTl8aBKfU9YF6yKDa8HJsCr
	lgmTLRFBfqgXpwFWiAis2Bhx9A2S6/4=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=qSrnwwCg;
	spf=pass (imf30.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788249986;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dUolOFD/ZIUTcn4+FFkrl9s+OPvFZ+bJi9KUysmUMu4=;
	b=6SuUxSBN7uGzs56Vk5qh4w6qDpQdMHGjZEzEIcglSSKKHfWJwnf5qOobqilpk9OnAhng6E
	tFiA23Q5hQVN0/QftSCKAawWJjnrZkBD7QDILLIA+HcyWgmvJ8gJU7NgHn78+1RcYCOwz1
	DVkv2Qgq2tdUn68QR9Ae//czzFD6Inw=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2ACE51756;
	Tue,  1 Sep 2026 01:06:21 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4139A3F882;
	Tue,  1 Sep 2026 01:06:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788249984; bh=6jocrZ8BWtYGm87yBooi0QYPtq263J2v+Y3UsEtP2Ng=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qSrnwwCgSNAk6gZGaTF4+LjyRGLWI1VKPsqwSCxRzooIoQdXp+IjgAYWi5CKwILl6
	 kfrGSp++BQwo7Mx3G93jNN9Yrzw6Ef6jqaRfP4PHZrzdlujsywMIInxMng3joLKYfh
	 hAEDxEGDMeToqCAIlCYW1lZqTG0vOk0iZCL7hINY=
Date: Tue, 1 Sep 2026 09:06:19 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Yeoreum Yun <yeoreum.yun@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
	Kevin Brodsky <kevin.brodsky@arm.com>, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/2] kselftest: mm: replace usage of /proc/self/smaps
 for check_huge_xxx() helper
Message-ID: <apaHexgq0pYduNq8@e129823.arm.com>
References: <20260828-fix_split-v3-0-374022586a4b@arm.com>
 <20260828-fix_split-v3-2-374022586a4b@arm.com>
 <f9ae614f-beef-4e83-b307-d4e743d7062c@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f9ae614f-beef-4e83-b307-d4e743d7062c@linux.alibaba.com>
X-Rspam-User: 
X-Stat-Signature: b9e5c85nwb1pt3q9h145jn9gdh87939s
X-Rspamd-Queue-Id: 0904980003
X-Rspamd-Server: rspam06
X-HE-Tag: 1788249985-691543
X-HE-Meta: U2FsdGVkX1/NcRRrrcjDezSV9jJdNBPFmU1Ok0bvcKOA3uM/7WbmPChlsk+zM15Q/Bp4nxjJl+7JmS0xiJoAys2buKW4J41Am+xybIsgB3CEgBZh5KXxhsnAvbdkROHLe65XsCI5TPi5iGmJfezKoVXWMt3gIhzVQKvVAcY9QKNBX8Y38bq/c1KSJkdpUUX9E6yxUQ/8KfsgaxewsbmwyNRqICkrEZxY5ZLIk3BzdyAfc7MQ+1Zm7OxKhN+fIsh7LY0oSNOUNNgaFDE//sTgFBT+zs8gWdMHrTD5e4fesv0GFmXTPY6NW3LARbahu5cbgIcbBprm82OYR4zOCS3msqiuds133Q9B9itMrgCo82KWG1Rx03mKbE6Z/hpi1k3KNmGsDnZF71k/tmD8RhjOdnW8W9Oil/n+9lDR7A/FErU464kFfv2Q45FGKBNcvHrDfMsJ4NZuVt2IEgM//A2kc7hCNkqp4Zg5nI/Z7ArWQaj3JQt4KQPeKWgzAGa0SWGXmxXx999vax6lsphYKOnfCXeqjZJh7LHQZSiRystsH56X76lPM+VtwKpblIKoGB8W2aCmcQBJQDx+YsmAVbuEgoA+MzhWgdlz8fXhERQYxKc/hk8aWKuDjsxB4f+MphcnibxDLeMAuhgx+DXqyKm//xIPUc9GsQ8tjeJci78u3oOVxzWs4659zGX+QLNkEDzZyiqgNYdWl3VEr/LGJDRokXZm/mBjreJHq4hviMrYYr5fu87P7Y58Ice7fU5MAarEUqNij5qI88vXNfdxj8fdS9kjGdRnOzpewhyfYbxLqI5AjBYSQcbVx7+W5IVQOdjYK31qSp0RAP4N+1cwDX5QdFmWYM/mqiDjoU1F34QDGU+Oa6n7VtCDks8r3OP9jPT04EIvBaacqpwsk0Xg8Ce5Xwh+DWXnZfmaijygWBn8uj8lgEd15zhOlh0vGGpJkX67NOnsp4Rh8gkCMa6NKGg
 8gPs78zm
 gf7Vn9gn+LkkHkO3ABTXiUPcBe3QILW5ro091jSWtCsnmwOTaNOWDrlAnLoqln/HrX8q6qMTN2Ye6kAOMLwcB2VVNVJk/L7cvHd0R9uUAk7WKoyjR4/5H9rZKpIBYGeIGDsvsPS4cWCNBz/OOL2CZqAR0CiV28WOUcEfJemO4tyVPrh1av2dSMW8KVJhP/cebfvjPuiSPG7/mw55VN15SQzl/ZMCObYlqPPJj9tUixArnGZfWTWh4iCAyGJNvIgt9UkpHvRAL4dljhM7Ahlahfq4rZzSWrlyKFYdQyNXyqwc6km+L77mR7lrcCWaFRM1amG6eNplA1FgD2BD6nmcyzAOJnPLiffPnna/OHfEN/37rp7lnE5s9ceHbV45R1/sy8k8VuEjym3BGjoOi3uN1EpTkUszvmmqqV0UnVlOJJZIIkJGHnndHWJRP2w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 31, 2026 at 03:58:18PM +0800, Baolin Wang wrote:
> 
> 
> On 8/28/26 4:11 PM, Yeoreum Yun wrote:
> > Since glibc commit 321e1fc73f (“malloc: Enable 2MB THP by default on AArch64”),
> > glibc may call madvise(MADV_HUGEPAGE) for sufficiently large allocations
> > made by memalign().
> > 
> > The underlying VMA may start at a different address from the aligned
> > address returned by memalign(). Furthermore, a subsequent
> > madvise(MADV_HUGEPAGE) call does not split the VMA because the flag is
> > already set.
> > 
> > This causes split_huge_page_test to fail because the check_huge_xxx()
> > helpers incorrectly require the address returned by memalign() to
> > match the VMA start address reported in /proc/self/smaps.
> > 
> > Fix this by using /proc/self/pagemap and /proc/kpageflags instead of
> > /proc/self/smaps to detect huge pages.
> > 
> > Reported-by: David Hildenbrand (Arm) <david@kernel.org>
> > Suggested-by: Zi Yan <ziy@nvidia.com>
> > Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> > ---
> 
> LGTM, with comments from Lorenzo and Zi addressed.
> 
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Tested-by: Baolin Wang <baolin.wang@linux.alibaba.com>

Thanks!

-- 
Sincerely,
Yeoreum Yun

