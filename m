Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA2F6E6748D
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 10:01:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 174F56B0088; Mon, 22 Dec 2025 05:01:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11CA56B0089; Mon, 22 Dec 2025 05:01:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0013D6B008A; Mon, 22 Dec 2025 05:01:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E49956B0088
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 05:01:23 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8C6B260988
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 10:01:23 +0000 (UTC)
X-FDA: 84246664446.25.D6FED5A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id F071D16001E
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 10:01:21 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LVjoBzrz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766397682; a=rsa-sha256;
	cv=none;
	b=BvYzDxipopC84CmrgKM81KqRCK3z8tZV5WgcrkjF3j49TArNoctnDLSznwlBgTpSGFEkIv
	SY1Kv1rQSZPGaeena7wA9/gNjY9bUa/RWM8tFEF8yV/y32dat/8r4PnCxzbgiAKKXwQJWG
	g9+GcbpS40PAJQUU0gAIBoh/tMWfBwA=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LVjoBzrz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766397682;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m5Bz4tO3gwTCc6d/A0Rq2sVC4ZUyh9FsoFcJbvZuEAo=;
	b=DdeUBq1vXovmIsw1eZwBskoogXUAB+ZtPQfUC6NlIUrjBD4XcPHjuWcU09qpdp+MWrm0Vd
	fzkzLD0OKwq+PlH9Z9bWDIqSQyO4GG4yqrG09GOaverXQltBSw3Vn+e8BsoMVk+0A/Hpep
	8CnR0Bc21wr2wXFxSdd3Ie9xZ046QCY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E20054378D;
	Mon, 22 Dec 2025 10:01:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FDC0C4CEF1;
	Mon, 22 Dec 2025 10:01:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766397680;
	bh=UZ4P5M3gSargbfZbWlgwDbORLDGuoxCS7PlKczHNQeU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=LVjoBzrztNA4FDbA8DYzzhbUKtp7wwKmAN0wGhk+A7PwO20p8fHNzg7phwwNdmoBx
	 N4WWaLh8wjVuMBW4ErbmhKLRO5YCHdmN8ulX7vcdMZHEi2LQkygJDDiJw8CY6WNlv7
	 s6EbW8MjY7/Wy3FDAbe5+5dWbFUk0rGMdwa0x2UaiL3iGDpXlVe87A3OHlWY7uA82x
	 p0GRBcd1YUfrnxkf+sW0+Af8cDYh/BTzPziOGknaRoc4MBGIWnTJSppq2G4/UkTmbt
	 /mSCec2n0NyCpalqJhly6TObP6J4iYBxLap8EZfFGGwErKJ/nztdPHSGx8BN8rrzqv
	 UBW6OvzgYRgvg==
Message-ID: <53e302a7-1c78-4b76-87e8-1cc10c76535d@kernel.org>
Date: Mon, 22 Dec 2025 11:01:17 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/3] selftests/mm/charge_reserved_hugetlb: drop mount
 size for hugetlbfs
To: Li Wang <liwang@redhat.com>, akpm@linux-foundation.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Cc: Mark Brown <broonie@kernel.org>, Shuah Khan <shuah@kernel.org>,
 Waiman Long <longman@redhat.com>
References: <20251221122639.3168038-1-liwang@redhat.com>
 <20251221122639.3168038-3-liwang@redhat.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251221122639.3168038-3-liwang@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: F071D16001E
X-Stat-Signature: s86hrs57tpitzpwah3d9m6d1wx1sdowm
X-HE-Tag: 1766397681-423128
X-HE-Meta: U2FsdGVkX1/CZKstTuoYTKLLsjsPkK8lUtwBzQNanYqCW8eTBdb+zO040dk41QFU5umSVJRlUkaYng2OGJTRAjoRNUv6iWQ69OxFIOai9LtMyLfkJGysDxga/eISvUIsk4Yl0C+0cxAPdSTNgUj0B2QzjpdahYFeNQDpH8aQU8SIXvKvZhJHS6PxunIk2tzbxaUoLW88e5jNI6tTHGLFPEJn+qAna5lXwplGzJ7kDbl2ZmMlBxFCHS+Yu6PJ0mkjaukeVqerzlpluZ2saY2CD9+l2jk46gFhhpcDSulxjoU+U1KPNnGmJffcxERpRoi6UDRcWHMrnWeLC4oTv2/rIhRZwTltDlKHJfpz4/MpiGGq3pEx4DWKZ97ieUVv8fukjCXxzC1ghVIVkJ3QCbXcj0ifgOqI5taP2QqR1KPuIOjNjYmGH3WS47XD3X/pXjT4Euchv1vv2wiUY0+HNoaLEf0Zy4e2JmZZ8IOwRf3wATsGeiJJir5eZwSbSX4ssWA2sHlj9djMqaAorQqTQAMUk+iRkqtwjuE49s34G+ONvz3jCqc7O0MDYlWLKJgvu9pLKtazj+m7X1CSMth1HieviJ5VcBmYeGGQ72dwPrHbtCl4tEzr/3zANQOGUG/0OTZhOZx/febonjzqaqzuV9obYEf/b1YkpjvmGJ9v8iQpogL0EL58/yrJ21s2QR09zoI6eFZyrMps17fPs0o3UnvJgXtU1lWoiKvOurHtAn4mTsCCPYKz6woZJ02ln16ugCoPWnygs4lsNbN2QCA8AZghLwglcqkaKT8V6mBsn9DV+a/qNBGE8XEBuIx8oLf9pdigwRhtOWpSeyig1USg8zPOkTP01xBKv72XaCdOBv6fQFh9B2vthpf6WNW69xTdRb5+6I/2eQdDyIfvLNhsTyZaKP5AzwWXvIK1Ed9MGJ+lE/TfTLnZqFiFqrh/i5I9wk+M9q/mDdcg0E8vjcyDSOG
 JB10lgDe
 X1Nun
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/21/25 13:26, Li Wang wrote:
> charge_reserved_hugetlb.sh mounts a hugetlbfs instance at /mnt/huge with
> a fixed size of 256M. On systems with large base hugepages (e.g. 512MB),
> this is smaller than a single hugepage, so the hugetlbfs mount ends up
> with zero capacity (often visible as size=0 in mount output).
> 
> As a result, write_to_hugetlbfs fails with ENOMEM and the test can hang
> waiting for progress.
> 
> --- Error log ---
>    # uname -r
>    6.12.0-xxx.el10.aarch64+64k
> 
>    #./charge_reserved_hugetlb.sh -cgroup-v2
>    # -----------------------------------------
>    ...
>    # nr hugepages = 10
>    # writing cgroup limit: 5368709120
>    # writing reseravation limit: 5368709120
>    ...
>    # write_to_hugetlbfs: Error mapping the file: Cannot allocate memory
>    # Waiting for hugetlb memory reservation to reach size 2684354560.
>    # 0
>    # Waiting for hugetlb memory reservation to reach size 2684354560.
>    # 0
>    ...
> 
>    # mount |grep /mnt/huge
>    none on /mnt/huge type hugetlbfs (rw,relatime,seclabel,pagesize=512M,size=0)
> 
>    # grep -i huge /proc/meminfo
>    ...
>    HugePages_Total:      10
>    HugePages_Free:       10
>    HugePages_Rsvd:        0
>    HugePages_Surp:        0
>    Hugepagesize:     524288 kB
>    Hugetlb:         5242880 kB
> 
> Drop the mount args with 'size=256M', so the filesystem capacity is sufficient
> regardless of HugeTLB page size.
> 
> Fixes: 29750f71a9 ("hugetlb_cgroup: add hugetlb_cgroup reservation tests")

Likely Andrew should add a CC of stable

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>

-- 
Cheers

David

