Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6E04CCF9E0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 09:45:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1336680030; Mon, 27 Oct 2025 05:45:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10A4F8000A; Mon, 27 Oct 2025 05:45:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06F1B80030; Mon, 27 Oct 2025 05:45:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id EA7B38000A
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 05:45:35 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9BCF2C0563
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 09:45:35 +0000 (UTC)
X-FDA: 84043411830.20.9E2E72E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 0783920009
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 09:45:33 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=none;
	spf=pass (imf13.hostedemail.com: domain of cmarinas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=cmarinas@kernel.org;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=arm.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761558334;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=90JKlWZN6LOOCsjTjgHYoaK6c7ZqqeoQJ+9qQ5ZoKLQ=;
	b=xf35+V7BkzaLuzHjClN0BN9G9SGHNy+0bP8xkHiQYodTBnbDacLow+3C5gvQuHc2KJHIwS
	2o61C4IeEX/u/jj54iVvylndMF1WnJlilVo9Ys3WHiuOVHSvz1b80T9An0YCO0DIAuMK83
	DqDAV43UrlA9w2BwvkIq5BOe7kS0JL4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	spf=pass (imf13.hostedemail.com: domain of cmarinas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=cmarinas@kernel.org;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=arm.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761558334; a=rsa-sha256;
	cv=none;
	b=6O67zkfHL0eEOp3xhAcsu8olwWgyq4m6iDzzgXJTmZQr1RBd+a8nCV4ibef3+Z9Wvxaxyz
	EamA9EH1BfFIdqf6uJpg/7t8pVmMNTI7kaI7oBmRNSSFExUblzsfCRMemQHXOmu5eedwBy
	b6OTPdFGIT/Q8myvgvCbohbKqQBNl1s=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BF74B418EB;
	Mon, 27 Oct 2025 09:45:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DDB6C4CEF1;
	Mon, 27 Oct 2025 09:45:31 +0000 (UTC)
Date: Mon, 27 Oct 2025 09:45:28 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Huang Ying <ying.huang@linux.alibaba.com>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3] mm/debug_vm_pgtable: Add [pte|pmd]_mkwrite_novma()
 tests
Message-ID: <aP8_OFZaS_oh6_gp@arm.com>
References: <20251024013137.136926-1-anshuman.khandual@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251024013137.136926-1-anshuman.khandual@arm.com>
X-Rspamd-Queue-Id: 0783920009
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: p4qkxz89jyyuxfoagk74zbi8y6i3kuxt
X-HE-Tag: 1761558333-165409
X-HE-Meta: U2FsdGVkX19PuPVGr7NNODhqHxnqRmQLJ824uEEoBAwAUqyh8rpblXb2rWSfX6euNxO5IKYr17SABFyTjBOYSvSyMirKfI+9Ww6f1J/othJ392/kmrne6b77vaICOr8jXSvoePgAhHFG7zjw68sWwoNx55itM7wK7pcshJzcBSGaX1bHxvKJvrhbrc4Aw2mMMqLT/Fu7TcuGhlNdHDzFc3w0V67LKxVOxo4xJEftSq7JBu/kkL+GImQWY5XlOqQ1wu2NArypTBkhpLCsAOhFLrS1WDFsKOO18o3E8JY2ihQY10XMmNe86kPqOm13Gulwnbf9lqxPIOfNCfsT/W7IoGGgLZSqWUzfFckXJQRSq04iU0XoW6JRM5DgxPVU1nxOM8QI+gbEIe1SsXEDbqTSUkp7d8EsIuSoD7igmvtkL5WFrmfNAKRkO3Tt9ttDiYd/yFfcgxFfbX/bxXtGb+ip1dfRgzqjNKl4n5+JbsLUpq9Qw3qPsem5lUon9vUyzBYYmt8P+MEOH0vtgtyfhMn2c3OHsS6yzIYYH1DEg8q4Lj/dUdswSXy/TDF+6gVfnbItA57C6wEWwAwpMPl+zK9+no+5SwIz54ern5ow5NRk+YwYpOwxUIDXNvJ846P8uQ/4vOX+4ZLl0v5df2fKfHW2HWpjv/bAeWz4xlEWnj3CE5CnqzAlbOCtwN8BjdCJH/KeCBpsTMf0aqFWOH118c9/oWu0jE0Uu2Wpn4SAE4odL2SFhCxanTAQ7qpkaU3eOmEWMDvOYCBGOWxfeyrZmi4jqBB7d/inH6BDhlqxP8M7MqzZSu4vmYyKiwwG0zrBxOY2TkjC5yQ07keQkoWh9SQNBY6k3yv9tq5AF1wMVixk6S8KRocJck3Gvjzh/NT5lb5M31O3pPVEmVK06UNKWBGse4asOApgbFY/9KDixKYam3cqVEnxezvJxdXebXYaETmh8VXs+SMqrk5pMUZr/hY
 qOB0PVNm
 nuRsFdClPrBl4DREBAf1DpZthheWPrI2K/rJrbSp+3e6vTVIX2STiHGTa4HtUrU7lncWkIWBFrlPynkPIt9mStoLiSehBnoc9f/wxgWGU4Gdi6FG25MCD0jzSlkLtUIROABMgbrRDK0D0SuUtx9PVky890U9xd6qND6PPinOUCkRT8zCok/Bk7nLcpKv2sjsvqWeqhr0vBYeOTjGTu7BroQg7sSOO4w2EnXp5Pfm1uuiUMTHq4LAnawuQcRTTHtNFX60qk3oTG2ngBuqlE9bq24fngTtoN/03UFOid1xVDuFdbj9ooMLzkBJcI0CLufVzqBJ2nfzy37dUbylC+YePb8pwwxim1NSHm1cQVoHD5w0qQmXU2qsRgH0l9vJiRjpdX4i4ZA+KMJUifQnu1jALqONX78HiJg8qRNhiQfE0IhBHa3hq6C76LNWZkV5iJo+wuv66kj/H2Ep0oKYhxdWDZOfYsPd1sYx9gmhCdMPoOKKmst9bTrd9/A6D3qnPImi45vEcBzEk6EwGyiPOwvzaPMrooSCQPrLxlfE0ui2EkPEr57AQmWqIYKejQqXou8d4KT0dVYDVGdV5wXpIS79avGyxc8vZy9bJZWccxRrD1DWrv7q5g36ZLmS2Itx6FvaYwsu8
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 24, 2025 at 02:31:37AM +0100, Anshuman Khandual wrote:
> Add some [pte|pmd]_mkwrite_novma() relevant tests.
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Huang Ying <ying.huang@linux.alibaba.com>
> Cc: linux-mm@kvack.org
> Cc: linux-kernel@vger.kernel.org
> Suggested-by: Catalin Marinas <catalin.marinas@arm.com>
> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>

