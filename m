Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2A09C87FCF
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 01:41:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 941AA6B009E; Mon,  4 Aug 2025 21:41:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F24F6B009F; Mon,  4 Aug 2025 21:41:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8081C6B00A1; Mon,  4 Aug 2025 21:41:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 71A8E6B009E
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 21:41:42 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1338EC0B2A
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 01:41:42 +0000 (UTC)
X-FDA: 83741002044.12.B07409B
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	by imf09.hostedemail.com (Postfix) with ESMTP id 3B808140003
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 01:41:38 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=EhfvULJn;
	spf=pass (imf09.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.130 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754358100;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sPrO0h2D30ui+zm6MLtXYmt/y/NyN6nZoAqs4yAWrlI=;
	b=00lM4M0cpi+pVwk25lkK6czmR2TgZFqYBy/xhyP6PRhAlh4xhEGvbtnN9ZfelfVsuicTM7
	gy3x6ZAkR9AnvAKvn8Lny3TdjQ0FlVPTCH+3jDFtXpOBCIWTVwjWjX8TjEsjlcU1zbwCaB
	IlhUdah/gWCTUnjMfLtN4LaBdsAsIgY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754358100; a=rsa-sha256;
	cv=none;
	b=bLnIAo9s6GW3cpKTBRJ7zRc2sU0kZykqAzPsEX15oviUhtFUvaxywKXYuJFZiyNh0aN67L
	+oBlIEwZejWDK0kxuj0VHBU5nFymoOJYg/ZZO59qLZ4fMKYpJ8JFK/bfloKv7obTg9YbQP
	GjOBOtbqGwMDAnj+O0vwAA1QekwVyvI=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=EhfvULJn;
	spf=pass (imf09.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.130 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1754358095; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=sPrO0h2D30ui+zm6MLtXYmt/y/NyN6nZoAqs4yAWrlI=;
	b=EhfvULJn+FUo3bE+4JArryhPnYn+l79EFLVTE7Lh5mYpdo6xysHVUkn08/CFrsNK3nkuZj80AYUiNm1wsw6r0B1ogi2DrN9J3+EN1RTef2j4sMa5yZ8PJXifjquEl6vBFVUjnEhBkaCzArefnsDNMhWjJqbJ49Iqj0mbPNpP0og=
Received: from 30.74.144.114(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0Wl33Qh7_1754358092 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 05 Aug 2025 09:41:33 +0800
Message-ID: <aa1666eb-022b-4d2b-9f2a-6c8f79237c50@linux.alibaba.com>
Date: Tue, 5 Aug 2025 09:41:32 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/6] mm/huge_memory: convert "tva_flags" to "enum
 tva_type"
To: Usama Arif <usamaarif642@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>, david@redhat.com,
 linux-mm@kvack.org
Cc: linux-fsdevel@vger.kernel.org, corbet@lwn.net, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, hannes@cmpxchg.org, baohua@kernel.org,
 shakeel.butt@linux.dev, riel@surriel.com, ziy@nvidia.com,
 laoar.shao@gmail.com, dev.jain@arm.com, npache@redhat.com,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, ryan.roberts@arm.com,
 vbabka@suse.cz, jannh@google.com, Arnd Bergmann <arnd@arndb.de>,
 sj@kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 kernel-team@meta.com
References: <20250804154317.1648084-1-usamaarif642@gmail.com>
 <20250804154317.1648084-3-usamaarif642@gmail.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20250804154317.1648084-3-usamaarif642@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 3B808140003
X-Stat-Signature: o376upehbjafdoud4thz71dua8hc4br6
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1754358098-101874
X-HE-Meta: U2FsdGVkX19YtVNe5UbM/0HcJRDQ4hbZkPMnel0ie4oshdqeNufSgBRlxv4U5gAohL01BEKkY7guo39kD9VUS13xGRXzr4loNxV6TIG13doTINLOqZTPky5VJST0Fpj1rAaczWtKm9rhUItRtI5oiNs2BBi03WrlnlbyDtq/T4azcVmfHyjFE9f3Fu/8NaKR6Rrsx6+8BNjf8QZidtpA9FsR4NFXQ4zEcSGCkk455j1SXrC7jVnuTh4Crq2GFgYbW/Mq6ThgM4zmvs6tRl0sgFdvtBC7RGMLbFqla4sFbV/T6shoBcCVjsOWb8peCiL+mHWkayMsD9qwF2hllQ7j/ZryHP0Plxl5NPo2Hglp/sp2bMUH6xPvB54M5n61osdjs+I4BaEDk+Gv5ULZeiQMlByQqdi39CS0AXPC7QjmdIL69iX1lkGh4o5q3avpMcmLYzFMfcn2oDIBHpOaqPA+S1ka/8cy+KxqV9cl0SOo0F4kvtNqixYLoEeVFmEe7ErtosPJmXYRf+tbiWpsU78Bk+tHyAa8JbkDUmhnkuUvLvX42AtAntnCLqMct8sbah81lwP/mDqaEM/e2XcXKfh8mxCuvBfYhyW8680Uxz+FlHPdSk8ohLIX7gJHB8+xwMqPnw+dV/AUG5ZdeoqcPgWWtKW0b8wVAQm64iHi3nXnHwiRVb3Dxltexttu0Odrq5315RTSwrKoDrPI4eFNTs+nefyiDX5itMhK4c9OFjY1mssRx4iaUcbyp7Ni5SZaOKMt7088EnZ8vcK/DJMUhhjRUJZs9plpja1floPo64YrLk7vqc9nGgL1zswEsy1RiouE/T28SYGHoGyc9P65AxF2Yt8GwSbnnsO8jS29ueKt7+ejEZHFJmhnbV/a82JaebPRSLDhZTFQCyuo5wb2O/qoSsMAXgyrSNY3RgtlD879CCobGw5SLD4DN02VauVhNPHLkbjpO4X2ngXECr2lDQs
 C21cpGY9
 5ZLS/IB2liXFgEdkwXZTlWDsw1B3z25hFV0ziMPeSJGA6yno2PxTj1OyyIc0Qpk/6UsBtHJLQsDwFcZRnIv1Wi3DkVowaTR2KyQof2uXXBGa8BYFTaCiG+xc5lXa6PGIK96dcycpQG5R6zTweCLBeVIt+V5qgHeIdqZncBPvJFTPcOvxjeTid09LhkKVgPpqyJ2uIYIiUcwFwVbm0QTORyp8ylF9T+bNrfx+ooxO5JA4q4yvzLUDtB5IfCcwfDpOosWpl5qgBP4bud5xa0pyvfqUKnG38edtLBzPupWxFe6oRsuFL8Z7xOrO8oZ1Otp/K4WGCD42BxQphBV/8xxIL6xij6Kg1mxOAYksErGPIdlXX8Ct9l9EPr9pjr21nBkF/CvO0cPCqu8qXSbtU3Mk5qH4YLLdCSEsBYRu4bkkXdhY+HgdjS7ZNwOeN62FmfVZ2WGhXwNWZD0sRJ9fm+D4puDz0Hw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/8/4 23:40, Usama Arif wrote:
> From: David Hildenbrand <david@redhat.com>
> 
> When determining which THP orders are eligible for a VMA mapping,
> we have previously specified tva_flags, however it turns out it is
> really not necessary to treat these as flags.
> 
> Rather, we distinguish between distinct modes.
> 
> The only case where we previously combined flags was with
> TVA_ENFORCE_SYSFS, but we can avoid this by observing that this
> is the default, except for MADV_COLLAPSE or an edge cases in
> collapse_pte_mapped_thp() and hugepage_vma_revalidate(), and
> adding a mode specifically for this case - TVA_FORCED_COLLAPSE.
> 
> We have:
> * smaps handling for showing "THPeligible"
> * Pagefault handling
> * khugepaged handling
> * Forced collapse handling: primarily MADV_COLLAPSE, but also for
>    an edge case in collapse_pte_mapped_thp()
> 
> Disregarding the edge cases, we only want to ignore sysfs settings only
> when we are forcing a collapse through MADV_COLLAPSE, otherwise we
> want to enforce it, hence this patch does the following flag to enum
> conversions:
> 
> * TVA_SMAPS | TVA_ENFORCE_SYSFS -> TVA_SMAPS
> * TVA_IN_PF | TVA_ENFORCE_SYSFS -> TVA_PAGEFAULT
> * TVA_ENFORCE_SYSFS             -> TVA_KHUGEPAGED
> * 0                             -> TVA_FORCED_COLLAPSE
> 
> With this change, we immediately know if we are in the forced collapse
> case, which will be valuable next.
> 
> Signed-off-by: David Hildenbrand <david@redhat.com>
> Acked-by: Usama Arif <usamaarif642@gmail.com>
> Signed-off-by: Usama Arif <usamaarif642@gmail.com>
> ---

Looks really nice. Thanks.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

