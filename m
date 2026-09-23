Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 224E9C982FA
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 03:28:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F303A6B008A; Tue, 22 Sep 2026 23:28:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F080E6B008C; Tue, 22 Sep 2026 23:28:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E469D6B0092; Tue, 22 Sep 2026 23:28:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C33936B008A
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 23:28:44 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 589241C3030
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 03:28:44 +0000 (UTC)
X-FDA: 85243594968.12.E77113D
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	by imf11.hostedemail.com (Postfix) with ESMTP id A34D740004
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 03:28:40 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=SigBbLPd;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf11.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790134122;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aXVS+0rNgEPdURT9ROUCnYG2LJzTKNU03S9NURdhya8=;
	b=dZHF+tqeoz0NuWqOnt5MGNxxI2+SlOv3s7wIjr5tl8pT9MnA/6DTpfbwECtcDv8NZzFTZy
	T2oREOJJFheuzvAhacc/82bcD+6obSvc6X3P70L2HNPi/bFPPm6GfjuSNZMOk9qODbyOwb
	U7YVjlpeFZl1psF+amTvgXTOIhJPLQI=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=SigBbLPd;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf11.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790134122;
	b=SvVlkNZHSUhMYEU4izKWrOU6gUh5AAQYqn0iR1ED3pyQhzvqCIJmzKzwADj1vUfWrIbHIh
	2a+ildTonm03BafmB4r4VGPyPDgF8YXH22ATbutOB52pZfs60UBA5oYA+G6Gz67d9+WLag
	APhVDMPQofkjvVkQ33HOyrVccN+JLbo=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1790134117; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=aXVS+0rNgEPdURT9ROUCnYG2LJzTKNU03S9NURdhya8=;
	b=SigBbLPdQpizEtig/XwEw+XWryByrw8mEHD+Q36r3RhbVJgPUU36VpeF9lO+hlR3sqluPDYeNDu9BFvmmvgeXuJvbdsLO1wwVOYZsviQ6eHrEtprDQveyaHvOgKGmU5YPxX9bYYDGv4vXw6ktc0X7qkZmFThN1EBdd95eHCuV70=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=21;SR=0;TI=SMTPD_---0XBVZ80G_1790134114;
Received: from 30.74.144.107(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XBVZ80G_1790134114 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 23 Sep 2026 11:28:35 +0800
Message-ID: <6cc12fe6-4f2f-47b6-b821-8a507eb80b46@linux.alibaba.com>
Date: Wed, 23 Sep 2026 11:28:33 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] kselftest: mm: fix intermittent failure khugepaged
 test
To: Yeoreum Yun <yeoreum.yun@arm.com>, Zi Yan <ziy@nvidia.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Shuah Khan <shuah@kernel.org>
References: <20260921-fix_khugepagd_fail-v2-0-3c2877beef61@arm.com>
 <20260921-fix_khugepagd_fail-v2-2-3c2877beef61@arm.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260921-fix_khugepagd_fail-v2-2-3c2877beef61@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 8wsnmnk4nnafwwqwicp6u1px7map68wn
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A34D740004
X-HE-Tag: 1790134120-740114
X-HE-Meta: U2FsdGVkX18ka3kO23qEfM101LQt8XSLKt9eXJ1P5SeXy5IurWP+j2B1kZXwtILi3mgUUJWaT2TIhbPV2D/xbxVH0AvOFGvxXkwM7y8bOBxZYroS6uWZodbbMYYWXWZHGhH79c7+mnTNhGAHjrs4N/hnd/UFA4ItRun8ALBkr6jZSxGvJ7dYJSVArV36XWjqJ90yd7yN0VKTMXqBn5woF3ugQv9OoSwxt9RKZ5t84MkoBrhN//1Ib/y6RBI/CLzwrnjalnUjKtIf919UtQHoEpB/Qp93I/6Kt1/0jCVYSHB3tjXF/RzHXaoj+SRfqpWvlcw6if/Pt7OqIkkKWBi+x74O6tHndE10kS4y7iLABKazoEeBcTWRRo2QATajRLY6NSBDf/Tu22Ty3bIKae6Zhm9LaYw38BYEUHyoOMezjjgKNGZR2sP56oUKYETnTGOvKCQ8uYFRdELiNQLWddOa1h+XywA18BIO2UGxST2tS+xeEhTc9CVan/ZGDf5wTNs9qapewZiHcbhmPHOjpieUGKXsXXmcKpD9Ni5kvzgOnUfjwPWQFRBj/BuBH3m9qxpUsF42MmECWSQTKkuVs0EEvaJ9wpbrvCyuvrLk0hQfJGnh1CzhFzKCwgEHMI0HeOKuaaGZbfBlsXbHNvgd9HB/SI6J8E12++y2ZCvBPjlACESCxLkjV3ZiRIXDl+T4iEM2RzkYOLtBFgRh4gh0l2Mg/ygrCqQ47xXwAaXaupKLqRepmMak1Q0MXldTv7O2DIMsr12JXFLkjVTOwuZKZl6UnQx38BLq17B9syZ7T34D4hfu2oUCb+3ZzWq49JHbQfJbjuCutnKLDPP+CRL+1ZG0pRVEhmusLTCBr1WBlRugCcmsMiw0TerSkujGkRD3xcyLs4XGO3sDic3x9Vb7S/jK+vUAEjUpoyhjZdaeCCc0GquSyEF4jw2fEezOJvixU/16UAYEkuIgEJjBs588sXT
 V3++RUJQ
 Ft4bUuSCz7HQZR7KDFoms5gCHq26hb+53prqELx+7rhYWan4jRkL3S1qGIchCgvxct7PJIffPnThRGLnrq4L/LQdHocogBhqt5GHFoz7+IfcZ10TAdfUZgBRQ4Ly5YoQn7DxKS78ebcVSyGZyNZpyMcHn++DSkntrTJeRYl5bAISi+DuxFUNUEBs1LvD5RLwvYQGBHr7sxU59eT287m7j7lY8KnpzlYDec8IXPnoCMK58VyKgUKb7zIYsWpsDm+HLlIf0QF8CQhUZwqFfO10nK/9j5kDb1drKhCT3aTkhFqAVNPC+UUcTjq7ycpasyyupZd8XMqW7b6fjFGA+jQUp55u8I6jAOMFvkcuZBwPng71llho=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/21/26 6:35 PM, Yeoreum Yun wrote:
> There are intermittent failures in collapse_max_ptes_swap() and
> collapse_max_ptes_shared() when using the khugepaged_context:
> 
>    // while running ./khugepaged -s 2
> 
>    # Run test: collapse_max_ptes_shared (khugepaged:anon)
>    # Allocate huge page... OK
>    # Share huge page over fork()... OK
>    # Trigger CoW on page 1023 of 2048... OK
>    # Maybe collapse with max_ptes_shared exceeded.... OK
>    # Trigger CoW on page 1024 of 2048... Fail
>    Bail out! Unexpected huge page
>    # Planned tests != run tests (26 != 23)
>    # Totals: pass:23 fail:0 xfail:0 xpass:0 skip:0 error:0
> 
>    # Run test: collapse_max_ptes_swap (khugepaged:anon)
>    # Swapout 257 of 2048 pages... OK
>    # Maybe collapse with max_ptes_swap exceeded.... OK
>    # Swapout 256 of 2048 pages... OK
>    Bail out! Unexpected huge page
>    # Planned tests != run tests (26 != 17)
>    # Totals: pass:17 fail:0 xfail:0 xpass:0 skip:0 error:0
> 
> This happens because khugepaged may collapse the pages before wait_for_scan()
> is called, causing a sanity check that expects uncollapsed pages to fail.
> 
> For example, in collapse_max_ptes_swap(), after faulting the pages back in
> and paging out up to max_ptes_swap pages, khugepaged may collapse them again
> before c->collapse() is called.
> 
> To prevent this, mark the VMA with MADV_NOHUGEPAGE after it has been
> collapsed by wait_for_scan() for anon. This prevents khugepaged from
> collapsing it again before c->collapse() is called.
> 
> This failure was observed on NVIDIA Spark with 16KB page.
> 
> Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> ---
>   tools/testing/selftests/mm/khugepaged.c | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
> index c32244b565658..1aad4bb427ece 100644
> --- a/tools/testing/selftests/mm/khugepaged.c
> +++ b/tools/testing/selftests/mm/khugepaged.c
> @@ -578,6 +578,9 @@ static bool wait_for_scan(const char *msg, char *p, size_t len,
>   		usleep(TICK);
>   	}
>   
> +	if (!strncmp(ops->name, "anon", 4))

We usually use the 'if (ops == &__anon_ops)' check in this file to 
identify anonymous test cases.

With that, LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Tested-by: Baolin Wang <baolin.wang@linux.alibaba.com>

> +		madvise(p, len, MADV_NOHUGEPAGE);
> +
>   	return timeout == -1;
>   }
>   
> 


