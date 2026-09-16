Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D983BC88E77
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 01:15:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D0B256B0092; Tue, 15 Sep 2026 21:15:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CBCB06B0093; Tue, 15 Sep 2026 21:15:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB1696B0095; Tue, 15 Sep 2026 21:15:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 951406B0092
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 21:15:23 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 28D041A05C3
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 01:15:23 +0000 (UTC)
X-FDA: 85217857326.28.B85AF36
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 63DA040003
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 01:15:21 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=AUVm1lBJ;
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789521321;
	b=Lk1LRXQfRlSEzlIbHi8sGoHwe4j6rJ/MWITM3hEZx+Mie0KYP2u/YoQMDhIvFXSrqYdqAW
	M0D4FiM0Am02omMUy4PQGXn7o3p+Zyqa0fbs2yzeQj2AzBlqJBs0bzdU4MDf6a7mRBH23p
	KBoKI2Kb3dtV90bCYl6R+DzVctblMdQ=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=AUVm1lBJ;
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789521321;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XuQDZikRv9jj7fQ5oAHaP13olV/99KYu+eiNYZt//68=;
	b=ZgG+kZlbInR8NdlzDc/Lt5AoYJTBZYAgTIRfWTibksEfP0KGHkLFtWvKfzq0ALb6rIGQGx
	41VlLT/ZAYnMQrJaIccvWpEOVxjPo7kzpHjH3b/XId7zDvfM8cqJiKkHdkECz7juXOOzOr
	bHZqnqetwRFtK35MC3eUxUjMmzJjZuw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8283F43EE8;
	Wed, 16 Sep 2026 01:15:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C58EE1F000FF;
	Wed, 16 Sep 2026 01:15:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789521320;
	bh=XuQDZikRv9jj7fQ5oAHaP13olV/99KYu+eiNYZt//68=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=AUVm1lBJj70j8iqZrzQ1fp/ueoOLFAKmyvLXcuvW6liyZeYvuNXpyoTxXSd5DK5h+
	 E708l/TD4IbwQwiwzx0h6LvU9909pVVWHhvzM5JTwL5IgghscAtdBgdFta5vpPGtYb
	 Vc2vhtdaDEQUBe74tqvrodB/VxTHrrgzQwZ9f4ig=
Date: Tue, 15 Sep 2026 18:15:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry
 Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, Usama Arif
 <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, Lorenzo Stoakes
 <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
 <mhocko@suse.com>, linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, David Hildenbrand <david@kernel.org>, Shuah
 Khan <shuah@kernel.org>
Subject: Re: [PATCH 0/2] kselftest: mm: fix intermittent failure khugepaged
 test
Message-Id: <20260915181519.648c2962143b761cf02efd17@linux-foundation.org>
In-Reply-To: <20260915-fix_khugepagd_fail-v1-0-bb6f04c8759f@arm.com>
References: <20260915-fix_khugepagd_fail-v1-0-bb6f04c8759f@arm.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 63DA040003
X-Stat-Signature: jatx8ibtayuffa6k184af7r6jg9cng95
X-HE-Tag: 1789521321-362548
X-HE-Meta: U2FsdGVkX19pJJcRXAB2bZh2L5WuJGTThTuOj7Vk/GUqhHbpt+tm5ytc3/6tSLbsElwqALEHIkrKWEniHbsz1z5VE0dNJFhz4zfZGgXwBpHsQ8KWgOqR4gJeVMFI8GHVraKuPQxJmtqf4LxjaZJoXTr+GYF7U4+DO5wqVu3LY93cD7BIkhu/koPZ2LZDGBP7hwcHOksChMpZXkZsmLOfHH3FJfaz02L3WNkTqBfqdTZb/vS9sLntTjfVC2cR9J4jq9Eq4x5/Be/rp3oVf5GsqdyrBLbIG9NEFoHVjIv1vg8/7EWiCh7i/qc3tc4/HK69eLos0yAWM7EVX1kNwZ17z6tsSxu983mGpAZBdYWWCXRMsSpskK/OMh+qipyx9o2QxE0tTcRL0AjAA5cYlS8w6fL+iItTqOa3nKEcF9LN1DFSdyRr1rOtsro0/W9sXKVnDlemelP8qNgrez2PjFsM4H4ArC7mpqsQ3bgTirVVHblkeLZi7fdSvnjcgB/QzrVyKC3yW1ZMiVcQKR7rZSpINP3lui/pTbcs88o9NO9f98SEZFULzx4XzDu6/kOpO87wCiGGLTP7Fo70oySfBFjSbYDAXeaERfG3JLiMrxyt3O3l8VwyZF3jIZhuhamIeS/V6OEmbTW/p8UOPJ2M9istLRpCrRpT4u4JuKSv6pG+QmvJxWkszGzxLrfvojl5cYtySqeBqlNKCvv23D2iDS5eXG9nOChGFCjWI7KB6jFmCyb/5ppBxlpDKNg3SCY5QoU2VMReCY69nKxyJ8g/bujoOac591/QCwAqMgXXxD94KgyPITEJZ7havdaV/McH+rhViW9cj4xXcbhHSTTGB1jSkEGUdmPV1taECNm0getU6NjQs4BnsE0NEOkqR0AsiulrXoXrejAzVjhZvh8gy7LY7ORapzFxpdnX4U36Vbka5aKhothhaz0tbYJLPRY2liYzUsbMqaJ2JRaPLjcU7rK
 sYxye4m1
 uAcX9YvYaygxweY7zD7LIPB48vmxKwVrsJMMf0X+xZQZBp1sa7L/ZTIUGqqGIpJafBXg9/cse4kiIzXSOJcHJTjqa2p+IFgvmW+nYVVuilv6C6c34kuAiL2WNGfXub5iSbBfzYkXrH1JGrPoY7QRgkWYFdhpocGPwW4KJYKKTg4Qjw75HRCokCmQVoXQ4FJmiRKwDiZhUKx/dZs+0q0QirS6zf15Ek3Ek3ViVCdArJs931uFmgryH2VijhHTEPrDSTSU8isPxzBlDfnttI6XRqOBxRs49h7Nz6s8VRHHE6AjgnnTNjfeSe+/3KQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 15 Sep 2026 10:21:35 +0100 Yeoreum Yun <yeoreum.yun@arm.com> wrote:

> There are intermittent failures in collapse_max_ptes_swap() and
> collapse_max_ptes_shared() when using the khugepaged_context:
> 
>   # Run test: collapse_max_ptes_shared (khugepaged:anon)
>   # Allocate huge page... OK
>   # Share huge page over fork()... OK
>   # Trigger CoW on page 1023 of 2048... OK
>   # Maybe collapse with max_ptes_shared exceeded.... OK
>   # Trigger CoW on page 1024 of 2048... Fail
>   Bail out! Unexpected huge page
>   # Planned tests != run tests (26 != 23)
>   # Totals: pass:23 fail:0 xfail:0 xpass:0 skip:0 error:0
> 
>   # Run test: collapse_max_ptes_swap (khugepaged:anon)
>   # Swapout 257 of 2048 pages... OK
>   # Maybe collapse with max_ptes_swap exceeded.... OK
>   # Swapout 256 of 2048 pages... OK
>   Bail out! Unexpected huge page
>   # Planned tests != run tests (26 != 17)
>   # Totals: pass:17 fail:0 xfail:0 xpass:0 skip:0 error:0
> 
> This happens because khugepaged may collapse the pages before wait_for_scan()
> is called, causing a sanity check that expects uncollapsed pages to fail.

Is this something we should be testing for?  If I'm understanding
correctly, success/failure is dependent on timing vargaries inside the
kernel and that isn't something we can reliably test for.

IOW, should we say "bad idea" and just delete this test case?

