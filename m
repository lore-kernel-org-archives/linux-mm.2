Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDBF91091916
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 21:47:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D5E76B009F; Thu, 19 Mar 2026 17:47:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 286C56B00A1; Thu, 19 Mar 2026 17:47:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 175AA6B00A4; Thu, 19 Mar 2026 17:47:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 09A7A6B009F
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 17:47:04 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AA78F1B88BA
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 21:47:03 +0000 (UTC)
X-FDA: 84564148326.01.0274E3F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id EEAB214000E
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 21:47:01 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YQKZ4msA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773956822;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NA2/A56ZhtI/PoLvTlLKfrzY+NZXauzXMCa1Fkw5K2Q=;
	b=gQU/kVB1S9PTyO8aPABWzcFhCuu3Km3fXxncGphWBbfSOvnVsS0yB8qI+XfN029UpfAQNN
	cY5jEHqVs033zpXCGd0+rK3a3qzBGBdnm9s5vuxYtci042cl+eS6o8G2atrmfDpRu/xjG4
	vX4MIHzX154iM0x32XN5eez+nvI2Inw=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YQKZ4msA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773956822; a=rsa-sha256;
	cv=none;
	b=FxVSysKemAfN5z2JHUgbWyNL9UsZO1m2BCSOBLMyP0wQ4tLIgUh8quVKDuPJzY1e+X8isK
	FmAosBi7lgbTotLJLAiOfvYELG6GvSKon39mM+k2sJ2oZeeLaftU2+kPL123z+nIki8jhO
	3QSufKlyQIpV3m+kbTwGJQPHcTUSvHM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2AF4F60053;
	Thu, 19 Mar 2026 21:47:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 245CFC19424;
	Thu, 19 Mar 2026 21:46:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773956820;
	bh=1IBkxxVID0OqECcdtfslaXIofuQKudUDRH508pH5n2M=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=YQKZ4msA9Q1UVupgLQQX8vWm3a7QrdO9XU5owvbsusQVdWvjaxArz8Et/bp6ovnOs
	 V4HRFc5TXhTPy+WL9rihFat9A7NxNhUsmKYne7rM0Ij8oDuzhoMr58/+PIR/FYiYD1
	 dzHjoWQMJ8UnPNd2CVNKGDOaTCL+87qcEGvwEiHNxP7BFDaHZeiEhiHkoDx72Umg2e
	 JudAWOILwmo/e0oIm3hyYcEXKJCYV9HLTcDuZA6yot54xC7QRWgWD/FWZOSXXSQKTB
	 1MGGDP4CxlwXaGUi+0RRy9CUVPXvDu4C5KsZpNLIMzTnccQi/qlIRdrgJZ3ckpm32d
	 mB7HhYdpglAaQ==
Message-ID: <eeac1781-d809-4108-9abf-63a9800a9ea2@kernel.org>
Date: Thu, 19 Mar 2026 22:46:53 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/5] selftests/mm/guard-regions: skip collapse test
 when thp not enabled
To: Chunyu Hu <chuhu@redhat.com>, akpm@linux-foundation.org,
 shuah@kernel.org, linux-mm@kvack.org, ljs@kernel.org
Cc: linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
 Li Wang <liwang@redhat.com>
References: <20260319160656.1480279-1-chuhu@redhat.com>
 <20260319160656.1480279-2-chuhu@redhat.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260319160656.1480279-2-chuhu@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: EEAB214000E
X-Stat-Signature: cdqck7ahdhb6k1qi5dw89apbhrs67cj5
X-Rspam-User: 
X-HE-Tag: 1773956821-642400
X-HE-Meta: U2FsdGVkX19XfFaFNE44lccLpDWT6+QA31cr8RgJNbf/8HTC88BdKkkfzdY/Ibq/HQ4VTj+I8WLQ7yki6YFfx5g1OneAd1CabGyUO6J9PViONDDqIZy3YtvTaFdnFFiAgCmrvGLRx17JbX+s6uszz4Yjx+ZnrwTEFHBeTYdPSRZmB8nC9DmfkufceeCE+7WqQZQmThOgllAofParBI7mx/XLIp/zyTvvETdJvY15+LA9A/khvKHbXG0Nd6Jn7GYbCLv15hgCcU4u+rDxG43DsOmaM4D/VOqUyJ2Ie5oMxnWYe/DqhXbdAtNhB3TUlVNtgkxUpokA84r7Ov2uQ7qit5FtqwSto9+wZJmpkaQG7mSJzDGbeGDmZ7cP+LmVB4E1E2gdfmxG4VZuIvR3MRqRvQXKDLoTSx+VyzpR9QfnB0QmmQolR+fcavT0LRWsv6Z5aayymBgKCzWohsj7D7bM8AVlPlwRmV58pFkrVihRynaZj/NuPhRJFyi6hKxg1DX0VX7ZA37CfhTdG1iNfoU+ZtcvY1hM8EQLp4sE6M+aRmGzk7lzxAOZvSH/qZ++NKJQ3n/fHPlMeYMWSYpz4L2UuWtIqodKM8aXN38FTRS/pP9h/FWmgVAqIlosxOFGw10sMYRT22gKoOyIAiILvTzvA9AQCwmD07HDCQjduEvla2BRLxQTXEs43x+A0S3Xvr7cehYRhLBfyYdvT6nZkcODOZRJNxOw8Y4lYYi7bWG5cijJim87lLgtaFqUEt3hMQh2UhQsV/a1d0G8A2hsjtMkieb6mOjFr8Vu6R5/BcqJx8gohA5OeloWwap99RH2DDJca8wT4QL5TDftiAqP56BAZOn2I3u7SFjgR6edds5ZL4ltOS/Tqx86rCWETvfptBxnTGvzviC0acFTGZvWWAntFdI3EQCeBKv6Vgob+u4YvpCheVfJ5LCkvi1dnkCXfJLh4887e5s08gOdMOP/P5E
 QcglcglV
 Y+rlCabYcbOFYP96nEqFGTlyNeMKKakSEoJ6ps68ttuY1SAuyN3q+ATIluY2npuoXyolGbtmx8tnHyKIHZw/IGZrmVdktr5i8PlVTfNnKZb4GDdhBvC03VW0L46IXIWuAaEUkAjOMy7beB4D5sFsw99Dw2HsDbzyaN/RW8b2Yd4YImewTBaBogBRyGBXlU8tk+Y2qtnv9NfMeD2Z5FQRCtCmrjTtwPgrtMdnG8l5hxNPc9xBC4l+O9uQ3fHzDhmrUCQeIiPjEHiI00+CTbJWnVyGEG+WG+2hSV4WFAl6XvycvPMxQ2gGbwCGUxA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/19/26 17:06, Chunyu Hu wrote:
> When thp is not available, just skip the collape tests to avoid the false
> negative.
> 
> Without the change, run with a thp disabled kernel:
>   ./run_vmtests.sh -t madv_guard -n 1
>   <snip/>
>   #  RUN           guard_regions.anon.collapse ...
>   # guard-regions.c:2217:collapse:Expected madvise(ptr, size, MADV_NOHUGEPAGE) (-1) == 0 (0)
>   # collapse: Test terminated by assertion
>   #          FAIL  guard_regions.anon.collapse
>   not ok 2 guard_regions.anon.collapse
>   <snip/>
>   #  RUN           guard_regions.shmem.collapse ...
>   # guard-regions.c:2217:collapse:Expected madvise(ptr, size, MADV_NOHUGEPAGE) (-1) == 0 (0)
>   # collapse: Test terminated by assertion
>   #          FAIL  guard_regions.shmem.collapse
>   not ok 32 guard_regions.shmem.collapse
>   <snip/>
>   #  RUN           guard_regions.file.collapse ...
>   # guard-regions.c:2217:collapse:Expected madvise(ptr, size, MADV_NOHUGEPAGE) (-1) == 0 (0)
>   # collapse: Test terminated by assertion
>   #          FAIL  guard_regions.file.collapse
>   not ok 62 guard_regions.file.collapse
>   <snip/>
>   # FAILED: 87 / 90 tests passed.
>   # 17 skipped test(s) detected. Consider enabling relevant config options to improve coverage.
>   # Totals: pass:70 fail:3 xfail:0 xpass:0 skip:17 error:0
> 
> With this change, run with thp disabled kernel:
>   ./run_vmtests.sh -t madv_guard -n 1
>   <snip/>
>   #  RUN           guard_regions.anon.collapse ...
>   #      SKIP      Transparent Hugepages not available
>   #            OK  guard_regions.anon.collapse
>   ok 2 guard_regions.anon.collapse # SKIP Transparent Hugepages not available
>   <snip/>
>   #  RUN           guard_regions.file.collapse ...
>   #      SKIP      Transparent Hugepages not available
>   #            OK  guard_regions.file.collapse
>   ok 62 guard_regions.file.collapse # SKIP Transparent Hugepages not available
>   <snip/>
>   #  RUN           guard_regions.shmem.collapse ...
>   #      SKIP      Transparent Hugepages not available
>   #            OK  guard_regions.shmem.collapse
>   ok 32 guard_regions.shmem.collapse # SKIP Transparent Hugepages not available
>   <snip/>
>   # PASSED: 90 / 90 tests passed.
>   # 20 skipped test(s) detected. Consider enabling relevant config options to improve coverage.
>   # Totals: pass:70 fail:0 xfail:0 xpass:0 skip:20 error:0
> 
> CC: Li Wang <liwang@redhat.com>
> Signed-off-by: Chunyu Hu <chuhu@redhat.com>

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

