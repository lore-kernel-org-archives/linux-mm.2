Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5548C5DF70
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 10:05:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D588C6B016E; Tue, 18 Aug 2026 06:05:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D08B36B0465; Tue, 18 Aug 2026 06:05:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BFA9B6B058E; Tue, 18 Aug 2026 06:05:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9D9816B016E
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 06:05:21 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4237EC0B16
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 10:05:21 +0000 (UTC)
X-FDA: 85113957642.25.A1D8DFE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id ACBCA40006
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 10:05:19 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KenBZTlE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787047519;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vvgTF7BxKslpbQYqfTabhCfEBSi+NhzQbW2JbybaO2U=;
	b=US3isc5K8rzTNDsOvR8CR7Wyky+yt8yFizewdLq3evEebc0YHC5i7tjgMCrZGHD6Q9t6mu
	+0WO3XXN3SZU35bnsCcOOlSNJOueY98O+LE7QIKSRS3Ux+ijkiyIgyB/UlJzpkj6xcDhF/
	WFxZZ5s3Ft69Ygh28FfslBxJbnfmrAI=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KenBZTlE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787047519;
	b=FHl1Q8ivVwrAz/Z8dTqvZnN98GJja8mZQOTqSnQHXdDoJqFtYJGFeumw8OXRY1BVaFcXC+
	341syt+RAOn4XVGue5nkdIY8pLBg/h7wtFCg+7MSCkFBdADEv1FtkiAi0TxLLVKxbjlc+P
	yqyZ4QRrboEvA0YWgd7knHtngJKvxpc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 34047601DE;
	Tue, 18 Aug 2026 10:05:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9834A1F000E9;
	Tue, 18 Aug 2026 10:05:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787047518;
	bh=vvgTF7BxKslpbQYqfTabhCfEBSi+NhzQbW2JbybaO2U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=KenBZTlEl0NaWZ2lYk1B7sfibtn7LNF/rnV12ykluv8Edz01kFv0DPUYrtQmc2yBk
	 H6G8ZZMmd43xeaBNyoCUjDVUsUO9RN9xld0+SmvPkVrpqPw2/EjYx07B0lozoSttyg
	 f3/mp14ebSxuNPbWuUtUUC1FCR5JZ0fD4FD+8gS//d/tUILhvHbKhTb13ddiwXrHR6
	 ndCgOM2Mlkzs12ylOdBStzfCnzmm9VCqQIkWxFJFl8T58OKFFRNOUg1obE7+2hEh4v
	 M25QTqZu6xQW7TFWqslEzTV5rTYVCWQvNvfK/2W87msvoV+fp2kelMe0TWUSd/zA+p
	 2jvuXzMtZR4dw==
Date: Tue, 18 Aug 2026 11:04:57 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: akpm@linux-foundation.org, david@kernel.org, nico.pache@linux.dev, 
	baolin.wang@linux.alibaba.com, baohua@kernel.org, dev.jain@arm.com, hughd@google.com, 
	lance.yang@linux.dev, liam@infradead.org, mhocko@suse.com, rppt@kernel.org, 
	ryan.roberts@arm.com, shuah@kernel.org, surenb@google.com, usama.arif@linux.dev, 
	vbabka@kernel.org, ziy@nvidia.com, usama.anjum@arm.com, agordeev@linux.ibm.com, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kas@kernel.org
Subject: Re: [PATCH v4 03/19] selftests/mm: scale khugepaged's collapse wait
 with the PMD size
Message-ID: <aoQuCP87uX2kHl5q@lucifer>
References: <20260815015901.1236937-1-kirill@shutemov.name>
 <20260815015901.1236937-4-kirill@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260815015901.1236937-4-kirill@shutemov.name>
X-Rspamd-Queue-Id: ACBCA40006
X-Stat-Signature: bq63aprsrswb4b3gdcousap4te3beijj
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1787047519-494499
X-HE-Meta: U2FsdGVkX19DITadUhSqzjkjNUFhBQrcRu2s6+pNRwlaI4c0ZMNRKrgMj7VwYXTyJ6SvoQMldec+oKDse60QgCM/cQ2ccEVMkAR398mtz9mHGCugUdyfmxbFp1hUK092rkoFee0UJsOwfD74KzBPVb+hHOs6YOB0cCqF5mQgWEICLfBhyaQwz8dM/FOCSsrB5qzuG2XQLFE10gqZ8l3uJ23huLGM/FNNUij3LfK8AOOBgJGrPdxMygbzKP6d6zczNTnQwN6CVz12wDW4eOIwJrlERc9QSslk8prxrtABYaBPilL8CnT4SfHkDRL6N48bYE9HUrx3ystCrylT6p8I6cdoiQyxsIefDQIGIhLmuw2Ao6U+HkkL97vYE5Jnxqas7Od/s9cHi8yTbU9ce7zdF10bHv+YqkGa+GWlMO8tFDiciUbKf6pe9qvppDFoxDF8idqcOmeolFcDosFKeQPV06SZY8LDxzh//cJM/iaGnt7MXnuNe2fYjDvFZ8CuRBVBgh5BZmtUAPujVrKFh3nnP+QTkU+Wa7Ef3kKnkat0JFHTFzHv/x2smy/3lkz5WMNiHmgX1x/duLwlfgCV8u758ew4y6nnrdXIZP2sxQFlHnpn2NVshu7RGXHiJH6p095OzZ2z4dHw9g/RTzD2nsRyiV5GE+n/UMqSKVswZ4Ckb7x3vo6LC4MCkQdoD66XwJX025xd4GPjHqBBaC+13AxhZMQQTo1EeIrdHJS7KnXSKHaPejZBKY6JGscG3G2HIDc0cCCr8ejuInw1SSNXij142FacjJ+/yBIsd9iw5U3QR7XQ5hNXrVPol5IQr6uURKESERs6brEO73rPudcvrqwC1mzzvaA0cB6dMCJftq4+jVdomXSkjmOnFyIqPoQqGu4ZkoikYXURwFqQ7c7rZxV/eThFYahwFafkH+YB03vabs0jS8vD9jT603iGiZy3LllqdiUWaAEZ5TxRHrN82X6
 cOmpUPEB
 eVioUZLl8MaqrU5TZl4SVso1QyB3dbcNH8Sc5bzg/+RnIYmauHgbGahbNIJ6D4ToL1GrXXATjh22tgzTCOuFtUK4qLOxclfnF5Rw2V24nfRnPmShsIIPfVFcIY6VHEL/Shk3qoI3U+v5bCWzD8nylHrAvlwCqcRGErslIfAX9CfIxK9VzWu2dAkjWaIXAytl9CnPBnA+HALW2J0/EeH+34MSgmAGsynG5mnyy64k3mlWhKtZmZ0heOs0b2mV9eFchAQQmF3HLvovoZOIxfdHrzeYfKmVkGgd0lGCe+JP8ywLyOjxaGf+SWyOrzz18MRr7GunOg7Zg1J3gHqHHM1Kw8eqyhQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 15, 2026 at 02:58:45AM +0100, Kiryl Shutsemau wrote:
> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
>
> wait_for_scan() gives every case the same three seconds, whatever the huge
> page costs to build.  collapse_full() asks for four of them: 8M at a 2M
> PMD, but 2G at a 512M PMD -- arm64 with 64K base pages.
>
> Three seconds is thin at that size rather than generous.  Across 80 runs of
> collapse_full() on arm64 with 64K pages the wait was half a second in 73 of
> them, with a tail to two seconds.  The case has also timed out in a full
> matrix run, reporting a failure for a collapse that was still going.
>
> Keep three seconds as the floor and add a second per 128M collapsed.  A 2M
> PMD is unchanged.  A 512M PMD gets 19 seconds.

Yikes that does make this run really slow for 64 KiB page size machines and a
key aim in the selftests is that they don't take too egregiously long to run.

Can this somehow be trimmed some other way?

>
> arm64/64K: khugepaged all:anon 21 pass/1 fail -> 22 pass/0 fail.  x86-64 is
> unchanged.
>
> Assisted-by: Claude-Code:claude-opus-5
> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>

In general though the patch seems reasonable so:

Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  tools/testing/selftests/mm/khugepaged.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
> index dd924edd8557..c499804a0ec4 100644
> --- a/tools/testing/selftests/mm/khugepaged.c
> +++ b/tools/testing/selftests/mm/khugepaged.c
> @@ -561,8 +561,10 @@ static bool wait_for_scan(const char *msg, char *p, size_t len,
>  		int nr_hpages, int collap_order, struct mem_ops *ops)
>  {
>  	unsigned long hpage_size = page_size << collap_order;
> +	/* Three seconds as a floor, plus a second per 128M to collapse */
> +	const unsigned long bytes = (unsigned long)nr_hpages * hpage_size;
> +	int timeout = 6 + 2 * (bytes / (128UL << 20));
>  	int full_scans;
> -	int timeout = 6; /* 3 seconds */
>
>  	/* Sanity check */
>  	if (!ops->check_huge(p, len, 0, hpage_size))
> --
> 2.54.0
>

--
Cheers, Lorenzo

