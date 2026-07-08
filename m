Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2AFD6C44501
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 07:38:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EDADC6B0093; Wed,  8 Jul 2026 03:38:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB1446B00A3; Wed,  8 Jul 2026 03:38:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC99D6B00A4; Wed,  8 Jul 2026 03:38:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AE6946B0093
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 03:38:19 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 308A914066C
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 07:38:19 +0000 (UTC)
X-FDA: 84964806318.30.A45E332
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 5C8741A0005
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 07:38:17 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iRkeyb0p;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783496297;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1y4jc2fBbDjyCrVGAy6/YgB+rmoA+uy8MNL/iS7r1vQ=;
	b=SUDIzIqqUZ5a+4TDvOFaR8eLevhtmvQlFry+ShA+Y8IFP+OE2MJL1wn1M4860SjDOUGx5J
	W38UMRJJGSvm+9wUBYw9cVT3ZT73JkrhRN3wxyAmpsg2Dyzw3mAJieOjPzzRtCbKI0WRvB
	K5Cd+PX+J8B2W64XF3BjDUKnJn/W+m4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783496297;
	b=OSvqQFclCddIxdNpbFNshuGkMFzwnggNI5oc4XyeIJJoD+IE6j7JDbslpmYxIgEv3mBj3i
	sa6YWh8ky5b6P70PAXE5aeHIalDzrMC1+plIR4Giqb0nIw1uoDoreuujtYP5qJsw26zLUG
	XiFvWmS3EJ2G/agUWHFF3MuQKOIjuyg=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iRkeyb0p;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3CE3F4342B;
	Wed,  8 Jul 2026 07:38:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C89E01F000E9;
	Wed,  8 Jul 2026 07:38:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783496296;
	bh=1y4jc2fBbDjyCrVGAy6/YgB+rmoA+uy8MNL/iS7r1vQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=iRkeyb0p2wqqTAQJyNyGAumfISj9bl3bMW9XFVv2w5TZLSDK+k2q9sQvUE9+Zb0iX
	 A3p3DuU5foVBM/LFlq37Yd+z8E4kSlHhYhfnoRLuoLXq4f/j1bgBOd9CSlJVCwPKRf
	 fooj/5P8YFzYdxa5lrUODecDyNFKqWtHZnBf3/1pF6oUKbH8GcTfkRpztAckO6WKMa
	 Uitenc22fKTlEplnUXz/S7nF9xs7jzUbAlZwYosLEfsXh5T/JFF+nyB5xpdyw3bL0j
	 iq53ZXJ2aOMOLCh46AoJVqVNmaPtQkmAqhvXP2tWn5d4aqjWGYALuWyDjrV2sOiIb/
	 KOP87SvcBZbNA==
Message-ID: <eb7b4bf5-e2d9-4328-9a65-2139749346e0@kernel.org>
Date: Wed, 8 Jul 2026 09:38:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/3] selftests/mm: handle EINVAL when configuring
 gigantic hugepages
To: Sayali Patil <sayalip@linux.ibm.com>,
 Andrew Morton <akpm@linux-foundation.org>, Shuah Khan <shuah@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, Ritesh Harjani <ritesh.list@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>, Michal Hocko <mhocko@kernel.org>,
 Oscar Salvador <osalvador@suse.de>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Dev Jain <dev.jain@arm.com>,
 Liam.Howlett@oracle.com, linuxppc-dev@lists.ozlabs.org,
 Miaohe Lin <linmiaohe@huawei.com>,
 Venkat Rao Bagalkote <venkat88@linux.ibm.com>
References: <cover.1783446924.git.sayalip@linux.ibm.com>
 <2e3b585cbb30b2fc495dcd49d75de6f6da61861c.1783446924.git.sayalip@linux.ibm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <2e3b585cbb30b2fc495dcd49d75de6f6da61861c.1783446924.git.sayalip@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5C8741A0005
X-Stat-Signature: s8it1hot8kezdbbayijowjn9jx3xsd7c
X-HE-Tag: 1783496297-460491
X-HE-Meta: U2FsdGVkX19klTP57Q6lKO8Ga9oEkcmx9KMTHJh+YsbdXhPXcfB/ZbqLmF0vk/KTlj9XNzR5JUVPyTcMDmgmWdVG094/twfkNC7vIptTX27p9iiOL/JKmmN33AxTL0MOY9F+VihVWEzA4D3o8heR/LtrsZSr5lOIUV+SSUkEJpJ4FDVRZN9XUZQSxf/AayjAWAH9BdDHayPUdrUhKMBTdmiz7nf0pqEbRbkgQM1LdZfQq++tdY8ZiapOBt7h+Ws6QHxAbCYSqnn991vFn+Wk8sZPBCAb+mHyciLa2P6+jmn2jZOEfWjcpYNELufMZ3AgHFmJYX+wY7d/Ij3IuRCzSIkC4x8aebAIV1RiE1sF4S6MkhrDrkXltGKyxoADoSCYC5AS5WTkPGWIt6uDY7cB5z8LZn8kqECof74nF10Vnq1FxU2k7HLztJZNWtKyb9mzHtP3FwdEFzqTJ6krEcZzAoJm9SLrSbDfjStfEqQBD2uCiGGo0OtQGzoPb4mQ5M0o29EaQu89hEc7GNERG7lHi7KLRcwQ+wdX5iVC+BOqR8rBsVJWaKDwJXAOCGnRdq5bobBwb4lAu74hFoRh6qB+Z9o3wcXeerClbzXO0I42GGYLTXJqBLDQw3TQQA3H8N8aemyFyHd5FN6DEQU+eFBnPUk5OVtUNX2zqJvKpZzQ4AG52J1GceoVmu3hK12TmXok58wswM9vTwteJpYHqOAlZTSHXAJKcpCgkOy8+DRzY7dayZhK2V0LGb05r+s7/XM+/48qrJKIMeVImAYTYCziOoxYGXBh18A0+Y2CBgZMAkpLh2uh4fmPXNxbll2mKGPFQUzrh3guIcyOdQbMJUJPxqkAzn8K1DoiSneAa5IVAiZJKwSKo2YPIcWVpaXi2u7iHOIejEoOqikVVxTyM8NdYCmeqp/Kj+iGf2YR1ASSmU5FcQzrNjwvxwwJ+BKXYjxR8xdDWT+2SCH69vw1g3O
 HIzKByZu
 Tm20js3p6i3gXUY8FlJxy5rxFYoaV6L7Z3kkgLAQw82d8T9vXdqmy4ZUx4OorIASfP/BAbz8c/XRAF9ivM7vqrbPRK5CnVwmLELDFoxWLgPLW8XJiMfJy/eDRTrol3JDq4dRUD1Xnf5tAhT76gdsM8POzWEQ4g8Z3BQlCw7XP2eo2JMtdjUtraDY6MyGRGHqRsnmrhO6bhjv+Ekf2w43nzQaQeNgmD/Pg/KTo/U3aTASS/S9M5OtR53gbBpfPq2xDs+xwG90XLgD+ZzqCEGXdzZSMpdGL6ZbrFumXWz4Ax6XriB+Z51SSLVB43skJsZYyAyyF7C2BiZo4fJenrgA90U4iNpxsmf4CpJWxJejE1ePKu77rHx375bYrmz0AQRoErFt3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/8/26 08:59, Sayali Patil wrote:
> Some MM selftests attempt to configure the amount of
> HugeTLB pages of different sizes by writing to nr_hugepages.
> 
> PowerPC hash MMU pSeries systems advertise gigantic hugepage sizes
> but do not support runtime allocation of such pages, writes
> to the corresponding nr_hugepages file fail with -EINVAL.
> This causes the test to bail out even though the failure is due
> to a platform limitation rather than the
> functionality being tested.
> 
> Ignore -EINVAL when configuring nr_hugepages so that tests continue to
> run on systems where gigantic hugepage allocation is unsupported.
> 
> Before patch:
>    -------------------------
>    running ./hugetlb-madvise
>    -------------------------
>    TAP version 13
>    1..1
>      [INFO] detected hugetlb page size: 16777216 KiB
>      [INFO] detected hugetlb page size: 16384 KiB
>     ok 1 MADV_DONTNEED and MADV_REMOVE on hugetlb
>     Totals: pass:1 fail:0 xfail:0 xpass:0 skip:0 error:0
>     Bail out! /sys/kernel/mm/hugepages/hugepages-16777216kB/nr_hugepages
>     write(0) failed: Invalid argument
>     Totals: pass:0 fail:0 xfail:0 xpass:0 skip:0 error:0
>     [FAIL]
> 
> After patch:
>    -------------------------
>    running ./hugetlb-madvise
>    -------------------------
>    TAP version 13
>    1..1
>     [INFO] detected hugetlb page size: 16777216 KiB
>     [INFO] detected hugetlb page size: 16384 KiB
>    ok 1 MADV_DONTNEED and MADV_REMOVE on hugetlb
>    Totals: pass:1 fail:0 xfail:0 xpass:0 skip:0 error:0
>    [PASS]
> 
> Fixes: 27477b28b74f ("selftests/mm: hugepage_settings: add APIs to get and set nr_hugepages")
> Co-developed-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Sayali Patil <sayalip@linux.ibm.com>

LGTM. Using proper flags would maybe be nicer, but no need for that for this
corner case for now.

-- 
Cheers,

David

