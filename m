Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B1861091911
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 19:34:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 45D3F6B0578; Thu, 19 Mar 2026 15:34:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 40DAB6B0579; Thu, 19 Mar 2026 15:34:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 323A56B057B; Thu, 19 Mar 2026 15:34:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1FEFC6B0578
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 15:34:36 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A6DF7C23DE
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 19:34:35 +0000 (UTC)
X-FDA: 84563814510.30.1AE538E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id C7458140005
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 19:34:33 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JJEEV6W5;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773948874;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4Ei17S6vc39i5mQMEvK6oXnKaUd0u+UJEs6xxdAuFhI=;
	b=uU2uHbQPk7a6nDaFZpMfYm3977xcdQhyD72+CvwJY4WRK0XdlnFDb4cF8moNKZNgXunXw2
	JxY6k767DTVHc4tKu7pNhtWncSwONfjP8MHi+r2IuFu/GYtbijUdDIJ5/TIf7CoC73XaPc
	ue2IKvhZVOwGw7u0+Dm09Ihb/VVvTbA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773948874; a=rsa-sha256;
	cv=none;
	b=U+o9bykqyv4jNsFyFrAZeuX0IWBT8alKovxjzoEDWrQLFdrReFFFx8uWYHZLH17b08tU+Y
	QssK+aG0QOCo1ttSagoAuhedeKMOh2MwwYgOauc/MahV/dVexT1gMRFt8Uu+UKCqgz5iK7
	G/NZ7XPLZtyNwtKjV7ktT8YUPUe/y1Q=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JJEEV6W5;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B93AA4048E;
	Thu, 19 Mar 2026 19:34:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E8C1C19424;
	Thu, 19 Mar 2026 19:34:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773948872;
	bh=ttQMTVuPbzMAIJ3FjJEZOWfVsx+LSE1iB5b8DNBMCfI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=JJEEV6W52iY/HDjBfXoTrlMDBS0r+joQZ42qcpW8R5c23OsI4ibiflq5qVHZJcymM
	 67yvKoyPcwuFMVi8ET7jw7ldvzjqggp6taWtEBA6vR7cWwOuSgpM613fYay3xDHaLy
	 SZ1wamtIw9gDmeiZL0tWuWCgUbh644YTe+rwak3Zd2Iezl06mgL8cmwupFesaLqUPs
	 xE7kpzk0tfE3hfQzMwVHsIbkQct4cSIE/r5rN9GXbEr3hUJ+6zqFcE0RD8LxLPVPlF
	 KHg1DBEvxopjzr/P8JrIhDSdius6IH751fhT8ahR0mefmv7Vtob9zns9pxH8Kft1TM
	 YQrMVCQBBMofg==
Message-ID: <fc8d70a9-6ca7-4f64-9e24-d88ef9840209@kernel.org>
Date: Thu, 19 Mar 2026 20:34:27 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] selftests/mm: Add UFFDIO_MOVE huge zeropage PMD
 regression test
To: Chris Down <chris@chrisdown.name>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Mike Rapoport <rppt@kernel.org>, Peter Xu <peterx@redhat.com>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 kernel-team@fb.com, linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <abongwF3X0G8xY1I@chrisdown.name>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <abongwF3X0G8xY1I@chrisdown.name>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: haaqzpdgdiqk3aue14jucprwg1waaaa7
X-Rspam-User: 
X-Rspamd-Queue-Id: C7458140005
X-Rspamd-Server: rspam12
X-HE-Tag: 1773948873-613357
X-HE-Meta: U2FsdGVkX19LFRLkT+5wig071egjlU7iNlhL4dxo4gZ9W2Lkw4Zt1XcauBGeytvNsl7NfJ7hxcIey5jomc8//0dbgmh+xjjMod5o7++/vFRfX8vvm7dt7J0qlxsLsGqBuTBjGL9zYF34hEBidai7oVZKqyL3YFLIbcO6NK0OJmuman0FXNdabp9/4xILxFX68AhX+3ztP2vLoHwj5ldBGn7KP4l21qNGIaLwkM07Y+H6s36vSyeD7XpubYpSKdyIRHpSD1d0GymmwoAHHqD6e0ZSzcsMJAWmDna8S4ppEEueKxdSOfKeB8DoRUzlUV0PZ7sITVgBZkULqSNU25Dkb65Og9TSiYJcC3oykpXCXDI+KYoRelXEAUilRH/lDdvXU84STnGkAlyspVuiLLQAdDhw7/JidccJuzHlcxxhnksY/aLtfxeFoTI3c2y+tc+TqNLhZVPP+hQSwdJ6h5HBuY8NHQOK6rYlmwZfRBs91NzsfxBnORIM3IJ+Ekd9iL93rUOzQhJBpxZZG9p4ZueeLQ8EGYAqZWXMBudmb6HFo502D2ZybxNKAfaPRbnbJ3kxrY0jVSFG5C6yCPHxhzQeJ/PNWOtMVW/yGgMR4+OtxAoJhbq8utOk7ewqwU13N+Zk6F+NNBa98RxsJ8PpLsCyyUmHX8yVTDUMtzVe70l9W/J7DXpnVcnwx9FgQeU6JmdADxeUyG4L2v9FdPjw/PghlWyCXjK+JKcPl/UG5Mt47PnY7mZBUzUVsaf1aOgBD/WeTOQkhY+ansne3T1iLT7WY5u8EjQOp6E+VsksDVthLBsjYo2dZpzjez2SkhMeG63FLdB0WIWF4OtuD+kLL3cj02kEhHx59ePYvzUFTWtdLXjXmPHkBQiP1HC9aMOHqJJTBXRYlk6n2ExsRLMrRCnUKsO7NH8zSlYXmndEXyYs3FV+QBaklsIYwDtshfDP3iG49lWt3qlDXqqNcv2ykTc
 gWrx6a+g
 hWbeJ7SIjo9ON/Ftzz9viKeEjET0z1wL+80ED7vORZa37cCN2xnG3GXe1MVkCDPveuyCXptzZZBxl3+zt2v0SVgbPDTpl8Unn2LWORb9MU+5G33FqEhbVcIfsurvclUe+s/Ls0J/kAeqGUMXvzhyuPCjcuVBo666GmyD2R/ibJeviOFpnS/NH33Ro6rJsFxDw+o3OF24Ow1AjFPLmqb63BjMy4kbL7aneKEN29szIAGg/Sv4D2q4vDxuokJ6WxaZouk7cZ4IVgho0rMC4tDoFL+HnQ8Du6tNdfBxtag0rWP4L5ad10mLf0UDmAA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/18/26 05:18, Chris Down wrote:
> The existing uffd-unit-tests move-pmd coverage exercises PMD-sized
> UFFDIO_MOVE on anonymous THPs, but it does not force the huge zeropage
> PMD path in move_pages_huge_pmd().
> 
> Add a dedicated anonymous UFFDIO_MOVE PMD test that exercises this
> relatively comprehensively.
> 
> Signed-off-by: Chris Down <chris@chrisdown.name>
> ---
>  tools/testing/selftests/mm/uffd-unit-tests.c | 100 +++++++++++++++++++
>  tools/testing/selftests/mm/vm_util.c         |  12 +++
>  tools/testing/selftests/mm/vm_util.h         |   1 +
>  3 files changed, 113 insertions(+)
> 
> diff --git a/tools/testing/selftests/mm/uffd-unit-tests.c b/tools/testing/selftests/mm/uffd-unit-tests.c
> index 6f5e404a446c..9cc4cbab9a23 100644
> --- a/tools/testing/selftests/mm/uffd-unit-tests.c
> +++ b/tools/testing/selftests/mm/uffd-unit-tests.c
> @@ -1227,6 +1227,99 @@ static void uffd_move_pmd_test(uffd_global_test_opts_t *gopts, uffd_test_args_t
>  			      uffd_move_pmd_handle_fault);
>  }
>  
> +static void uffd_move_pmd_huge_zeropage_test(uffd_global_test_opts_t *gopts,
> +					     uffd_test_args_t *targs)
> +{
> +	unsigned long pmd_size = read_pmd_pagesize();
> +	unsigned long pmd_pages;
> +	unsigned long bytes = gopts->nr_pages * gopts->page_size;
> +	char *orig_area_src = gopts->area_src, *orig_area_dst = gopts->area_dst;
> +	char *aligned_src, *aligned_dst;
> +	unsigned long src_offs, dst_offs, max_offs;
> +	pthread_t uffd_mon;
> +	struct uffd_args args = { 0 };
> +	char c = '\0';
> +	int pagemap_fd;
> +
> +	if (pmd_size <= gopts->page_size) {
> +		uffd_test_skip("huge page size is 0, feature missing?");

Wouldn't a check for 0 be

	"!pmd_size" ? :)

But yes, this is unexpected. Maybe simply

	"Could not detect PMD size"


> +		return;
> +	}
> +	if (!detect_huge_zeropage()) {
> +		uffd_test_skip("transparent huge zeropage disabled");
> +		return;
> +	}
> +
> +	pmd_pages = pmd_size / gopts->page_size;

Might consider s/pmd_pages/nr_pages_per_pmd/

[...]

>  
> +bool pagemap_is_huge_zero(int fd, char *start)
> +{
> +	uint64_t categories;
> +
> +	if (!pagemap_scan_supported(fd, start))
> +		return false;
> +
> +	categories = pagemap_scan_get_categories(fd, start);


A slightly nicer way to write it might be

	const uint64_t expected = PAGE_IS_PRESENT | PAGE_IS_PFNZERO | PAGE_IS_HUGE;

	...
	return (categories & expected) == huge_zero;


In general, lgtm, thanks!

-- 
Cheers,

David

