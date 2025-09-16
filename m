Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58BAECAC592
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 04:33:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6DEF08E000E; Tue, 16 Sep 2025 00:33:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 668958E0003; Tue, 16 Sep 2025 00:33:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57DA68E000E; Tue, 16 Sep 2025 00:33:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3FDE88E0003
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 00:33:14 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DDC61140819
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 04:33:13 +0000 (UTC)
X-FDA: 83893843866.03.0284CBA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 5AC59180007
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 04:33:12 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UA4pT+Xx;
	spf=pass (imf16.hostedemail.com: domain of sashal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757997192;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MhqMOj7oXCeg3CaxkSNfLRHQlLdAc9mirG5/9nFsplQ=;
	b=l359ytgq+IX4gsA7WOENEGcuB6fQ0Q7UP5w4nnYdNGsBuB526bS75JGBbYyZOzvxFHzfAZ
	Ejxrz1LRXlpyHX4GpJq1khTZv6t4sbUU62c1/V6tyTS73w242wMewlRPm9UOfyaKg8bgbi
	PG45PQHZhstRwcMRm5JjU5oKZGsCVZA=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UA4pT+Xx;
	spf=pass (imf16.hostedemail.com: domain of sashal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757997192; a=rsa-sha256;
	cv=none;
	b=HNyZ1P5UCzT+JeveWQEdzYk/cHy93V21sTdqDEPD1UHkyOTFbxklN+0w+xy2AqdOOfGjYq
	3zU8E2XRxTNUt+fsV/JS490tIE7658cfTuh5W3EHdhBGFeOFQ5nou77qif6acdvVwAAkyL
	lON5cNh0scpjlyF65S+P/h4dtbck2Dw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B208B60054;
	Tue, 16 Sep 2025 04:33:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA138C4CEEB;
	Tue, 16 Sep 2025 04:33:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757997191;
	bh=XUv2PggEgcd7aiSvIefqjmLXrdWBq5ZtfvsjcSnF6Ts=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UA4pT+XxdcvTwEXm0XQVMVK4IeeqDbY7dO/AZA7fAeL9BZlVOrkBtl9586nWqhkit
	 fEkVxPoPy009mzMJg2WqrM7m5GFCL161QrthTG+XB1OHtQ/sncY+fKBcq9IWtfaFdv
	 4Zos33vOsW2M9yPRjEznTzzxr6vPBWDL5Kiopuql9MOcVGBJ3PrzJOA0RiPiJMwGDp
	 TX3sx9Sqd43Lm344yY4+U2wvV5fYdb00S3j/giclSX62pecxjwbq0lkY/wEzyO2LJQ
	 8bJ7BpxlVNzY/ZtqSab19+Ggpge+n2hOyyJq1VzrYQhCdqldnvwgAa+ANrZJo8Y+Cu
	 zrQw1c1t8/Kmg==
Date: Tue, 16 Sep 2025 00:33:09 -0400
From: Sasha Levin <sashal@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Donet Tom <donettom@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Xu Xin <xu.xin16@zte.com.cn>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Wei Yang <richard.weiyang@gmail.com>,
	Aboorva Devarajan <aboorvad@linux.ibm.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Giorgi Tchankvetadze <giorgitchankvetadze1997@gmail.com>,
	stable@vger.kernel.org, Joe Perches <joe@perches.com>
Subject: Re: [PATCH v2 1/3] mm/ksm: Fix incorrect KSM counter handling in
 mm_struct during fork
Message-ID: <aMjohar0r-nffx9V@laps>
References: <cover.1757946863.git.donettom@linux.ibm.com>
 <4044e7623953d9f4c240d0308cf0b2fe769ee553.1757946863.git.donettom@linux.ibm.com>
 <20250915164248.788601c4dc614913081ec7d7@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20250915164248.788601c4dc614913081ec7d7@linux-foundation.org>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 5AC59180007
X-Stat-Signature: 4m79nzyrkzdo7uhsouhbtiwubucdqrcr
X-HE-Tag: 1757997192-987382
X-HE-Meta: U2FsdGVkX18ymBEGXdiBLKjZBElQnNbXZSr9TGp5NualiWcVlm71qYR7PGP36HYOsUQmktF2APymaBNCwFyy9NggaZgMlDbau+JAoTNbIt2/3Bx/DokH8C05Y/8KORvvtAhIu139KxHpzKK4usA0ykcgAYPNq3jYCPwUU4QmIKfgFy4LXj/piWTL8zLYDTJpNXjlS3aW4hk5yEIXqpkXCttp8sF2NRbtcdSA1z2OIeE12dxZYvg4Z/pcwywYMiwCeyNnlsYyzvdPUjRHUWh73/SOcrDFDup/HEbjk73DoIlha9fNL0TOCN4iQ05pNAl09DS8wCodMbws6jrwMkMATl3xellA6qOBkeyHMaxBr7+QyAXLIeTQKU56vbfk+xyez0EmsScO8tUdGDW2U84gaiQpcbdOUdRlkFCsC9goxtC/LjOjBrxZUUZBcUrpR5WEmy0BN6pzq4kjH8uD0XaGvezGhaT/dUuNXT4nE4hGF8n4zxLY+cSBpqc2J7jNQrJN/PmLArclvitr1VwQ+fpmdnUHoxg6PZOjHvGP6JGn52g2VXFXtnNYFK8U9aY31gP/H5k99cWtDQFjLjdoJ+nrGmiPuvaNpnsVYr629Kkvcs0Ze+zusaSD3zq5QdTYOXamVtNURQRpEhRVCzD/w5URkaObHCNIygCXnEDfnb1IuXb5nS/V7B/4EjuGYKcf4dYL/rXEnZnbsaDZA7YvRufdO9AyOYLbj38VEnvuqwiSgjyxYpjfIETJlZfa7aUtNswRxzDirupDuDgjB6IzChfLML+qGH/pXNRLYsX0PgsPsGkQyb0d1muuJUDr7GxhKZDJNjvzfXwL9pifbH5m2IX3pmnYOI6uiJS1LXwuZvv3fdQA4uvdhOxii0QHQn5p+vebOMi37cNNzqV5AXLTkbEVqczh0knCW+UMTpaPx+lHJ4ZYncLkP3aTr421FQJB4/NKJpNnQKzWO/b812QNTeX
 jV9WIXBw
 ZUE2Sh6FdOr7jSGuDuuKchfFwZTcXAgl/7KPj2hSqqEQNR9CssdJREEl9hqW/4TPYu9isvxZyYtjvUTYJldRkcS7SAGAvkqkRYz1o1ZAgeym71luurzvaddjttg4v8wjnpZuYlExFxlNDNsn+3mMdNrnlQiqaRQHgTv8q6lMXvxY9TWT5IssXN+5Wu+ZqNitHjRJgoChqCSk6nLajhL0kFdn/H20XQqh0jL95k+4v7ubK7KPABus4mgPtavLDJRV3n6lVeVBm8VCJy1vUm6YrBK0X7TUfU+PP/ljYMa40hPSjRWHzUWjQCXgpKMXDo6RaQgSxGaCb4/eWuxhNgNVaZTnLDWOCkdE7JNbeWG1BvXcJQss/9ILbSeiy06WHLu1ugxIKX2zM4OwW03IM4qxfPyxssKZ8mBt2cwqc
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 15, 2025 at 04:42:48PM -0700, Andrew Morton wrote:
>On Mon, 15 Sep 2025 20:33:04 +0530 Donet Tom <donettom@linux.ibm.com> wrote:
>
>> Currently, the KSM-related counters in `mm_struct`, such as
>> `ksm_merging_pages`, `ksm_rmap_items`, and `ksm_zero_pages`, are
>> inherited by the child process during fork. This results in inconsistent
>> accounting.
>>
>> When a process uses KSM, identical pages are merged and an rmap item is
>> created for each merged page. The `ksm_merging_pages` and
>> `ksm_rmap_items` counters are updated accordingly. However, after a
>> fork, these counters are copied to the child while the corresponding
>> rmap items are not. As a result, when the child later triggers an
>> unmerge, there are no rmap items present in the child, so the counters
>> remain stale, leading to incorrect accounting.
>>
>> A similar issue exists with `ksm_zero_pages`, which maintains both a
>> global counter and a per-process counter. During fork, the per-process
>> counter is inherited by the child, but the global counter is not
>> incremented. Since the child also references zero pages, the global
>> counter should be updated as well. Otherwise, during zero-page unmerge,
>> both the global and per-process counters are decremented, causing the
>> global counter to become inconsistent.
>>
>> To fix this, ksm_merging_pages and ksm_rmap_items are reset to 0
>> during fork, and the global ksm_zero_pages counter is updated with the
>> per-process ksm_zero_pages value inherited by the child. This ensures
>> that KSM statistics remain accurate and reflect the activity of each
>> process correctly.
>>
>> Fixes: 7609385337a4 ("ksm: count ksm merging pages for each process")
>
>Linux-v5.19
>
>> Fixes: cb4df4cae4f2 ("ksm: count allocated ksm rmap_items for each process")
>
>Linux-v6.1
>
>> Fixes: e2942062e01d ("ksm: count all zero pages placed by KSM")
>
>Linux-v6.10
>
>> cc: stable@vger.kernel.org # v6.6
>
>So how was Linux-v6.6 arrived at?

e2942062e01d is in v6.6, not in v6.10 - I suspect that this is why the "# v6.6"
part was added.

>I think the most important use for Fixes: is to tell the -stable
>maintainers which kernel version(s) we believe should receive the
>patch.  So listing multiple Fixes: targets just causes confusion.

Right - there's no way of communicating if all the commits listed in multiple
Fixes tags should exist in the tree, or any one of them, for the new fix to be
applicable.

-- 
Thanks,
Sasha

