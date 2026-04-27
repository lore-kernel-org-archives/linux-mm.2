Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D313EFF8861
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 07:49:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 493676B008A; Mon, 27 Apr 2026 03:49:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 46A736B008C; Mon, 27 Apr 2026 03:49:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35A836B0092; Mon, 27 Apr 2026 03:49:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1FA806B008A
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 03:49:57 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B03CC40798
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 07:49:56 +0000 (UTC)
X-FDA: 84703561992.10.71ECDEB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id CF4FAC0002
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 07:49:54 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SPJ6hkYf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777276195;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b8bFWNTUv0ZN3DG9otXOx6mJpZS0QyuoCgkgU6VhKik=;
	b=pix61ZAJ2rMZ26s3ZHJohYfxsWFYPbN+aynumG/n7PMV+j3bPRM4d1wBFLT1/nbGq9k+zR
	JS3Rh/jaPUDLIYse53efsgVZ+5HfxXV64V/Zv0Rf2EP31L/X18Ms43rmrzusVJwWzCjIrt
	gaJM+PNy+oGo2Mr9oLiYQ4UHRB8ob38=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777276195; a=rsa-sha256;
	cv=none;
	b=WYB1CvDXq6JQCqNrjjXDbiT7zE4FU3WkC6DtonrSZrKfQkG7hyajrvwOCqnNlVTtpLfWpe
	hSrBhdeTlKTpGSTciP0eOeRf6B8usHfYGeEBhFCpwcUAhEeGSjfeZFkdW8GEstJJqUPqYk
	WpndWeTnYMzrV3EwdCeJkKzaeU1eop4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SPJ6hkYf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C03D44420D;
	Mon, 27 Apr 2026 07:49:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1921DC19425;
	Mon, 27 Apr 2026 07:49:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777276193;
	bh=8PAx/Lj/i0A7i3Xe8MtXIluINnIK7hkHmrHp0hfdwsM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=SPJ6hkYfzN+5b4CnLo73B7aefn99CtQpDhkPueDg+mQloUliBGWOb/Xrp00C7QNdp
	 S7HMxRBB+228JCvtKo4IeL9TXUdavserDjkvSzEZT2goKRjEpwMGUXdJJLN/ssXWM1
	 40Svp9zP3dXZlHl7tRBWhk263pDl3h43ONP8u9c0XLAjit8AXW45sAMS1IJ4A9gRjg
	 MmC5WGSNb3sTuIvNgRPxL0pU2CoZEGsyMMrFbNc5Cj5eeEFIUiIKB/KDB1BQXRGpnj
	 xubxSKqDA8DfAdMUjz6vMEYXkuONh4km4VVYPU7CkCNjjKx+2RBkt2OSpISWCz/00Q
	 iR1LlxwoHjP2A==
Message-ID: <40a48a9a-57d6-4658-89a0-68891b5bda99@kernel.org>
Date: Mon, 27 Apr 2026 09:49:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/madvise: reject invalid process_madvise() advice for
 zero-length vectors
To: fujunjie <fujunjie1@qq.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>,
 Jann Horn <jannh@google.com>, Shuah Khan <shuah@kernel.org>,
 Christian Brauner <brauner@kernel.org>, SeongJae Park <sj@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org
References: <tencent_98F3571EF9236437E5165F5C08CF258A9E08@qq.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <tencent_98F3571EF9236437E5165F5C08CF258A9E08@qq.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: CF4FAC0002
X-Rspamd-Server: rspam04
X-Stat-Signature: d3cbbhc41oa3ke9agizm38hm135a9p5q
X-HE-Tag: 1777276194-959531
X-HE-Meta: U2FsdGVkX189ZTY+2+vcrNiBPfaV60I0du33O7HuWj4U7IhndbQYmZbCGVfQsshxHKUuFsCmolLBf5EjZXWsJ1sbYiymClNpoyEMXks56X3lWe9nsngMBZYFMimZAxRACjNb2IEgsfUEVj7eJLaIbnwtUd6jL16RTDxq7vzRCBvhAu3E3dpPG2ep46x8BoyzcjYal3zE4m2d5CaQFD4OSkwZNajWP+gT/Fy6VAV4xXV/nP0hP+GSflsFE9wq1MMNtpkeCAiXngdXZAdYrNEeCgAoDg0qENp0lZMlGcxGrqQGSgVllSXFa5SGnkXGmJ8M17XKMtOaj5PMtsLxW86Id7dJei05c1vJW5S0qwjGeNSDnPiqSPvQ7PJ2DdjM/Wv8eL7ZcqYgZXOa7PGGDTs/OpYlqWVy3HN7emRXqRo9SCgG4JxLWpfBLutGrpwZ/vPL7Wjiuu+6KO23z+WpdW5bXdd8ZbmnRWdl0shJ2P7P9/7WWz5G8uF+t1s4NnyIJxgJ1f/ThNggGT8nRTIOP83BkCGUJYtwXnh6c+W+5DqTC2dHxW5ZZ7au+IoIez80guoa2mNlubV63pSApZoFvtabxxkKW+Db1uex6BBB0058daGr14ekBZbt7AVbpSxAanxTsoWv4j5IQwGRibsBtgWrEJp/jyofhT7J6OVxfRlKqS59aOCJarlEnSG2Y3NAARY3kGE5Daxwe2VTpf8GXLxnvohF08jPMsxMWFT7KTxvxB6LDRRTlBYjPBAyqKlR9b7KQmlIm86zLZA6OCaQ/vUyhR8pxLes8xMNq9sC/MJ8jKFeSWZr7e0tgdou9+7fc+SdfeI0hufNj5TPo7M8DoNMyIgOkIpFt7PwpITGTW3UFJUWTEwHr8IAw5Bdkp1Xf3wzPit2CkD5LjU0D3O6s/03IhLOLBsgAu9w0p19R6ONFD+GRBcdkAM+XNPT2l3q3lWfWoL0nlEQdgjNLmc9ltr
 rOqomFOg
 NIzOfdPAxHgnhdxrVPb8BJeD4WYK0gifaMv1HSMCHbCGr1XotBsjM20d1GXHzuZLYGxo0MBSr5iII1ExBR9Vc4eKaDvDmbsoi4O4l8XU+FJxFyeTvRkjKomy0D5X+XN/GKKXgLtZoFMzU8Br94zoPOgMEvoQdqshRBo8kNXmIKMCqcS1ruftkEycG8NLnt505T3I4YqetTG7lYnJ4Es2yHw4wjrzRMQ5T+SJw4ytwbFHxi4fJCYJVpqGYt16Bevkm6HNxzUceTEvu1sL9/wCUPeo7IAQdzFPNPc02VHnJZTRq1l5IP3oNFACr+IUs+XGLFNtWvyRTKHmZoic=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/26/26 13:08, fujunjie wrote:
> process_madvise() validates the advice while walking the imported iovec.
> If the iovec has zero total length, vector_madvise() never enters the
> loop and returns 0 without checking whether the advice value is valid.
> 
> For a local mm, such as process_madvise(PIDFD_SELF, ...), the remote-only
> process_madvise_remote_valid() check is skipped.  As a result, an invalid
> advice can be reported as success when the vector has zero total length.
> This differs from madvise(), which rejects an invalid advice before
> returning success for a zero-length range.
> 
> Reject invalid advice before walking the vector.  Valid zero-length
> requests remain no-ops and continue to return 0.
> 
> Add a selftest that covers invalid advice with a zero-length iovec and an
> empty vector, while also checking that a valid zero-length request still
> succeeds.
> 
> Fixes: 021781b01275 ("mm/madvise: unrestrict process_madvise() for current process")
> Signed-off-by: fujunjie <fujunjie1@qq.com>
> ---
> Testing:
> - Built bzImage.
> - Built tools/testing/selftests/mm/process_madv.
> - Ran tools/testing/selftests/mm/process_madv in QEMU:
>   # PASSED: 7 / 7 tests passed.
> 
>  mm/madvise.c                              |  3 +++
>  tools/testing/selftests/mm/process_madv.c | 29 +++++++++++++++++++++++
>  2 files changed, 32 insertions(+)
> 
> diff --git a/mm/madvise.c b/mm/madvise.c
> index 69708e953cf56..83fe9e651a907 100644
> --- a/mm/madvise.c
> +++ b/mm/madvise.c
> @@ -2046,6 +2046,9 @@ static ssize_t vector_madvise(struct mm_struct *mm, struct iov_iter *iter,
>  
>  	total_len = iov_iter_count(iter);
>  
> +	if (!madvise_behavior_valid(behavior))
> +		return -EINVAL;
> +

I'd suggest performing the check just before the !process_madvise_remote_valid()
check, such that "invalid/unsupported" orders are reported in the same priority,
independent of local vs. non-local MM.

Or is there a good reason to not do it there?

-- 
Cheers,

David

