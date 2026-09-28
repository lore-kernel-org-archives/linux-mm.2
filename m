Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4AC5FC9833E
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 05:01:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB0AE6B0088; Mon, 28 Sep 2026 01:01:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B88776B008A; Mon, 28 Sep 2026 01:01:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A9EE36B008C; Mon, 28 Sep 2026 01:01:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 86B186B0088
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 01:01:25 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F3A1EA0B72
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 05:01:24 +0000 (UTC)
X-FDA: 85261972530.10.CD586DC
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf24.hostedemail.com (Postfix) with ESMTP id E5E91180006
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 05:01:22 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=DxwhNBix;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf24.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790571683;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mL/9Oq1/tOWJhnMMZpHIAJptRB/MqLTUhrw04G2GqIk=;
	b=Gj05CW6lWKbO7iqIFYm+jY4jKt7YS1Xb+c1fhEsJqaGcpfDISt/Zhjap7uLRoGt3hqk1EW
	Ckel7H1cf7699R4MqNijW7EqHnAhul9yEsDOdOjFmuwOm3ihFWbNluOzr9ACLTFF8eMmZb
	CdGSIW/4fbaRbPnbZvgJKpZuFL/Bfus=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=DxwhNBix;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf24.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790571683;
	b=sBDbJxZlylSzdz0mIsEMP7Ieccu5HJqDdhBe3YFwcf+BrMkkm7SlV29g5+M39xVZkVa6NX
	mego7PmHiq++rDOlEJ1Zk0nYbRJ60TAPZHXgt4HMUFm44lTZV6890SWln/ivJMLkubaPab
	6X4AEN5KPG5EhWJn2C+mHDp/PUjggtU=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 489571595;
	Sun, 27 Sep 2026 22:01:18 -0700 (PDT)
Received: from [10.164.19.84] (a081061.arm.com [10.164.19.84])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1C71A3F85F;
	Sun, 27 Sep 2026 22:01:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790571681; bh=blpaJ8wcWFMmHEuh/IwWsHLK0u06RnOp2THrUaZWItg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=DxwhNBixws7b4cJQwt53rNViThM3Uifx/UbKR4I6HmyRWWsj7qhkW2k7XiqZ03sKb
	 KTWy6D+eK4tqEOsY+AjcGlYabO+sTTKAFgdIAyB4zl2Jm5XI7cD4f4VYAnEHior6VY
	 Ig9cZtTYH2sAqu0lmcJbm+vKkKMj0IwLTUY8dewM=
Message-ID: <5fd59b17-c10c-4c8d-ae92-2304393569df@arm.com>
Date: Mon, 28 Sep 2026 10:31:15 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests/mm: cleanup -Wformat issues in hugetlb-mmap
To: Carlos Llamas <cmllamas@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>
Cc: kernel-team@android.com, linux-kernel@vger.kernel.org,
 "open list:MEMORY MANAGEMENT - MISC" <linux-mm@kvack.org>,
 "open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest@vger.kernel.org>
References: <20260927162419.820609-1-cmllamas@google.com>
Content-Language: en-US
From: Sarthak Sharma <sarthak.sharma@arm.com>
In-Reply-To: <20260927162419.820609-1-cmllamas@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: zf6wuqjpkrmrof8qtehciqiiucbp1air
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E5E91180006
X-HE-Tag: 1790571682-834602
X-HE-Meta: U2FsdGVkX19D6+Rb4yYP3m6JBaxNvT8Z4FB9Bd+GugfsjCAAqQacm3kurC0Xg7h6mOdtgH5eCTsyk5MnQCl9Gnybl8U77WC/XQbWLksRpNKyGs9zVRdz6Rp6DHw7iz2iUtDOTWQ+i+OK5+nIbe3rS7gtn17wpH7mGDLSP5Ck1FZFfo2LDuDeaBTonqXmH6ARhqMRa7iRAH/2jph8dXiA1ou7YV1TfB3iampkkcuzbHlL/OBWj4C/oYGS2dEs1TpPMLreu+eJfodxikUg48GRiJJbolAORnsyjfrGQg31BuduPicTPAhiru4lw7CFG6aw1KXA+kL9hKAdGm2KMkHcMRrylse0vLR4g+uG0XmTyzFXmyLQVVq1amLVYkZ8aJbhM4h3jxcUnhfQR3WaY7pu7Rlz+RkGwUDA85GZOUsg81cLgEy6Tmg/iZl0OsLz/+u7Ye6aW4gqKC/GE+l9uHehKDjeX29V3cEtgKsgKH+1gZfomOeCwJbn5YInVWc14qoKWYviVxFWGhVtdV268RYwDJv4F0qPDxHAcseD7MY91Y0BY57Luavjp03zKAB1ZKU9FuDtuStJWLhgtB7hM6FNGML5IOCnsaa45kqjehU9ymIZTLUtNIMvY6pc6S6iIgkNjit42K08WuFC4aByJ9d3xJy64LJ52ke6cQrarbCdtx+RTLH8axBYMyVlkJfRNLmVKGQl8TD654x2yYpVabKDBZLw/BdIzknuDToSDCnrr8TdmcQIkZVFOGu/s5wkXA0k7OKv+Y9UONb1/dDvCWTfVfulnCkguskUoZFjc1WM7K5UgZQ79ftwqeQYGnSPmcrCdIFdLVKBDVzdXvTyQA2TWYHQArW5cfMvX9Tnq15GV8AZtcenR9EPQglG/vSTB4g4yzxRUZx39x4S92MBa7HWsJF/w4Mfk4jfPRd+QPqTI1OSNMsvym8V13M7PmAvD33nvVZCcRVZ3tjLVFrMPFV
 aeXQ3Bd1
 otF2V8KqoqtivrU4NJrlWUT1/1RMIgotog2foluKMC0/ZE55yyRblUFxOxhpdTnszP+VQqFeuJvfJqHMxas5OBuVGCDXJ/vs+LWf3wwVX5tP/LnFm37h4EmTJbgr3aTbJPtCL1TMlZJ4moRzf+ZQRjQ6vreMR0Siu/+qAqKitqKHDrXjpOU/Fl0F0kXv+jJ7zhx2GL+0Dzsg6bhiw9oUsTG54DOKLFz3mit9/837QcsOlNF0Js2WEmD7mfuURQk0Tx/5m6uq+yq7y045z3+RTBT3GsMARpH5H53zCmF2K/GW5ngfUvrWeKJEd9awMCN9WscxG27uZVI4h30tRc3Mp1MPpng==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/27/26 9:54 PM, Carlos Llamas wrote:
> Commit ae571cd6015c ("selftests/mm: hugetlb-mmap: add setup of HugeTLB
> pages") and commit 9c5a65f374f8 ("selftests/mm: merge map_hugetlb into
> hugepage-mmap") added logs of 'hugepage_size' which has a size_t type.
> However, the incorrect format specifier '%lu' was used which triggers
> -Wformat warnings when building for 32-bit:
> 
>   hugetlb-mmap.c:125:55: warning: format specifies type 'unsigned long'
>   but the argument has type 'size_t' (aka 'unsigned int') [-Wformat]
>     125 | ksft_print_msg("Default size hugepages (%lu kB)\n", hugepage_size >> 10);
>         |                                         ~~~         ^~~~~~~~~~~~~~~~~~~
>         |                                         %zu
> 
>   hugetlb-mmap.c:134:47: warning: format specifies type 'unsigned long'
>   but the argument has type 'size_t' (aka 'unsigned int') [-Wformat]
>     134 | ksft_exit_skip("Not enough %lu Kb pages\n", hugepage_size >> 10);
>         |                            ~~~              ^~~~~~~~~~~~~~~~~~~
>         |                            %zu
> 
> Fix this by switching to the expected '%zu' format specifier.
> 
> Cc: Mike Rapoport <rppt@kernel.org>
> Signed-off-by: Carlos Llamas <cmllamas@google.com>
LGTM, so:

Reviewed-by: Sarthak Sharma <sarthak.sharma@arm.com>

