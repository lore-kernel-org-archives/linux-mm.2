Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD98AE7E0B9
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 09:59:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC0826B0005; Mon,  9 Feb 2026 04:59:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E8E906B0088; Mon,  9 Feb 2026 04:59:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC4776B0089; Mon,  9 Feb 2026 04:59:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CCB7D6B0005
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 04:59:56 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7E602BAE37
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 09:59:56 +0000 (UTC)
X-FDA: 84424471992.20.B9C8543
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
	by imf19.hostedemail.com (Postfix) with ESMTP id DE43C1A0007
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 09:59:53 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=qpV3gWpV;
	spf=pass (imf19.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.12 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770631194;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5Jq6T2NL3sJU/yaMiBjfOEI1QO0U+OXfk+QKONCyl7c=;
	b=UH1yl8038jhURNTOigTtuTm8gH/O6di7sKqjDpWesz6VLf6upj4cERMYf+UE7HK2jndcUl
	rv5nLpUsZ1nB41rJIPMRNWFqkmt6KEtSxBdhpBTDPLM0hZcLvAkPGS8qdJrb0V+pJfYGEx
	Qm6Pia7AhqdfEeS8KTt+LWkm865NYYw=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=qpV3gWpV;
	spf=pass (imf19.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.12 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770631194; a=rsa-sha256;
	cv=none;
	b=VSgPT20EdzwSl5T+Fto3p5j+dZgaeAzYvgB2nrcJDGSH4v4hykW4zhv9V0rBsEh7WdyXs4
	cwAaxfLBxEwL2PCakmcWnhOMMXejUcoxHV/nXBFfnlbKZw3Mq8bT9QMGB16OyQYAvDyUFz
	WADU+O/zQupztNQNR+46eLXU8TfiVMc=
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
	by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20260209095951euoutp0257d15faa21c4c683aaf348880f28f529~Si6-2MUTd2142321423euoutp02k
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 09:59:51 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20260209095951euoutp0257d15faa21c4c683aaf348880f28f529~Si6-2MUTd2142321423euoutp02k
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1770631191;
	bh=5Jq6T2NL3sJU/yaMiBjfOEI1QO0U+OXfk+QKONCyl7c=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=qpV3gWpV2gxI649/5LHw4/XLYJd7VVCVg5XXoJKwQMlYRQsi+rXtVKtSA9VquOHKv
	 NAmblswScThWgMkWWNDAZnWz5lvT86q3/mVcroTADOACj4CUvuljoY8jEhntPGoJHW
	 CErjDG3kPRZaMgWvXWEgI0M/lOBUtap99oB+f4dw=
Received: from eusmtip2.samsung.com (unknown [203.254.199.222]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
	20260209095951eucas1p10adcd75ea027ee2a57a7646328ed362e~Si6-mdUVH2286522865eucas1p1U;
	Mon,  9 Feb 2026 09:59:51 +0000 (GMT)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
	eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20260209095950eusmtip298958b48357f2492c8b907614e73150d~Si6_1ohpG0894008940eusmtip2a;
	Mon,  9 Feb 2026 09:59:50 +0000 (GMT)
Message-ID: <67426771-7df6-4544-a77c-97f44ee08d99@samsung.com>
Date: Mon, 9 Feb 2026 10:59:49 +0100
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH] mm: cma: Fix stub for
 cma_skip_dt_default_reserved_mem()
To: "David Hildenbrand (Arm)" <david@kernel.org>, Mark Brown
	<broonie@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Lorenzo
	Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett"
	<Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport
	<rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
	<mhocko@suse.com>, "Rob Herring (Arm)" <robh@kernel.org>, Oreoluwa Babatunde
	<oreoluwa.babatunde@oss.qualcomm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Language: en-US
From: Marek Szyprowski <m.szyprowski@samsung.com>
In-Reply-To: <4fc5e312-b56a-4664-9722-81163ecef515@kernel.org>
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260209095951eucas1p10adcd75ea027ee2a57a7646328ed362e
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20260209081154eucas1p2ce1f3c7bd5cae843fd60355314c8d4ce
X-EPHeader: CA
X-CMS-RootMailID: 20260209081154eucas1p2ce1f3c7bd5cae843fd60355314c8d4ce
References: <20260128-cma-fix-stubs-v1-1-e07a077d5b33@kernel.org>
	<CGME20260209081154eucas1p2ce1f3c7bd5cae843fd60355314c8d4ce@eucas1p2.samsung.com>
	<4fc5e312-b56a-4664-9722-81163ecef515@kernel.org>
X-Stat-Signature: zz5i6pgykdtoikxusnf9kj4ncdohbb3n
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: DE43C1A0007
X-HE-Tag: 1770631193-244180
X-HE-Meta: U2FsdGVkX18GOBuvY7aQX8rDZTtEwfTC7pEG6X85IEUzFd1XSM1Dd8xOoueEboL6MM7N20pXbHt5r0XSXD5hMZ5ijEOivvsDkQoLJ6eoHN4ldYi9mVhckO3N3usOWwUMjcs7xMp1iVkiYUgOsKixeZk1BsXVoXu3/B+XDzXg9/aOmO5VQasgmHEiH/l/UBUu5Bl4G9yLsB9vTx15/AZ4DUOoUcAyZ52hBcOdYowdAPIlcrlrRgw7ebMWB56hakRZynLpsZnt9iJ6MzjykgQCtBorVNwPbvy5swFMbR0CW/D6R8QTShvMvywutU3lU7c1MyRYD1sd2U83JwrXOLxYjt8wD/ek3WCuJ6TfZUQSLrk4/tzpBdef1Nb52p+PyQVvo3QPTcqJnJ9C/a6Y2N81aDYYRzrTUeUABojxkTmciXuhtX+Xi1A+WKXS1KU6fgxL4sbIVLrfKgKC3WUfO4gt/xPml4m3XkYLr4815e4xmg0BHjHp/hl0AA/cSah1sZ86mkwv8bdrXADbIm0me2s6ZuRpWb8inSbujEwSoRNvr/fkfMk/4Xu2abIAkPQ/Efk29GdCpwXYUjmUpqyZnlIttRYth28+f+9mDeXxu/dykMbLFTc+KfK4mDb5ZggkzEXrUIhOtzlAutC7hcD4WcrbWBCSZelRosrFFTj3vUEPsTXwo+GEG32jdW6hVog6D39AOb8gmUc+tPV18Tbq9snGaLmqFICmhYGRcNS4iSSrGmm6DujiH9VbKgnshI4imFY9AYDQrFR844kNlJspfFU0I19694K07E34Wv9rDN2tbh2v3hGZzLqpM/lzSXatmLq0hVBv0EunT2a0NEBimSRYK/9r0udQJ1zzNf4nKT+pvnYjTiqQExvcj5H6oGJDGZ6Bvcu+zZWeS/jDpKeyqmG9cRrDquZXej2pjbnbqsN/RHswLtMwBYzMFTEG5sur09OCScHkI5puuPjrlEYdBS6
 tSc7gUu3
 Un5he7XWRduZXYD8BhjVI7EoVilJC7/ANLhJWeXVYqWPCuPGJDwJoJbOufqIV390VDIR2IJjnxD+Yxzg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09.02.2026 09:11, David Hildenbrand (Arm) wrote:
> On 1/28/26 17:28, Mark Brown wrote:
>> The stub for cma_skip_dt_default_reserved_mem() is not inlined so
>> triggers build warnings:
>>
>> In file included from /tmp/next/build/fs/proc/meminfo.c:18:
>> /tmp/next/build/include/linux/cma.h:68:13: warning: 
>> 'cma_skip_dt_default_reserved_mem' defined but not used 
>> [-Wunused-function]
>>     68 | static bool cma_skip_dt_default_reserved_mem(void)
>>        |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>>
>> which are fatal with -Werror.
>>
>> Fixes: 26332ae848f08 ("of: reserved_mem: Allow reserved_mem framework 
>> detect "cma=" kernel param")
>> Signed-off-by: Mark Brown <broonie@kernel.org>
>
> $ git show 26332ae848f08
> fatal: ambiguous argument '26332ae848f08': unknown revision or path 
> not in the working tree.
>
> This is not upstream or against an mm tree. Against which tree is it?

The fix for this issue has been squashed into commit 0fd17e598333 ("of: 
reserved_mem: Allow reserved_mem framework detect "cma=" kernel param") 
and merged to v6.19-rc8, so the above fix is not longer needed.

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland


