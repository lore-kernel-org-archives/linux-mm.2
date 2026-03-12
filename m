Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 751C1106ACE3
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 19:49:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF38C6B00A3; Thu, 12 Mar 2026 15:49:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD1AE6B00A5; Thu, 12 Mar 2026 15:49:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE0B46B00A6; Thu, 12 Mar 2026 15:49:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id ADAED6B00A3
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 15:49:03 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0901EB946E
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 19:49:03 +0000 (UTC)
X-FDA: 84538449366.19.9E14268
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 4B063A000A
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 19:49:01 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=A7q8xKWe;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773344941;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RGhQIVRYBDhvBIOdgpHL+7ETkA11VtZScmOzWGwDh9s=;
	b=O8XQwaG6SO50Rz2dyE5VUXJH7I27QpCvanxMsOQ45j4RIUuHubkR6HA/ceskRcxpnqxMeE
	vVvv/xBg8YxJ0lgTiSU1IIkuYRWFKZ6s+hSaBmEAukxUSkZQUdeyz2LvuokDsSibR6D93q
	jvpY7kLwbytx624mb2qMJcdW6Ngq3jQ=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=A7q8xKWe;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773344941; a=rsa-sha256;
	cv=none;
	b=aORKpJTsVMkzB2JiMYbuFD0KjxvLN8deY4KvLNssumhB6e4lVfszAm2spZWp9lZQlXDMjv
	omY3o68JMpNuOs9PN9xL1/hbvKCi/kTuoGDkR6tT6kXziT2+teXRR+emAS66dbb+lbgwvs
	wBqysukeUF1kBa+V/qP+lemu1eNO2Fw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 945D261334;
	Thu, 12 Mar 2026 19:49:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EB76C4CEF7;
	Thu, 12 Mar 2026 19:48:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773344940;
	bh=Egp6YT5L81zRxg/z6CZjK1NmJyVh8nzuj5sen9ywdDc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=A7q8xKWe3Nq1LDRzDIn39uUn/+/x43FmRrrfuiHz7IkbJ87HjVReQdKZyGNwv+HRx
	 i0zgJux75nhcVF/W3MY2n7igA3n42fuavOGUECV7EyHjeq98dcCOM1GmR0P1J3Vae0
	 NbyOemIExhNm/GAwKjRD6F1wjGiPc6zADsbEXPiEQyhe58u4M/P2Cuw2f0Qk6P3qe0
	 MtKj63OLbka6tNaD+9M9bAHJ4GJZPTcA9/TQRwZ7qIXQx0vFtP0FhOpk1tnQ7cqsnT
	 U/8VzbnRLmr4Ed/1cfWxGO0hevnmZQ/sGnOTRHvzo8IUBcOqTYBYqFuOjvwTYc+fRY
	 u6ssEF7nk2FWg==
Message-ID: <afd70015-bdda-40a2-a842-a2d1dd6f4a20@kernel.org>
Date: Thu, 12 Mar 2026 20:48:52 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RESEND PATCH 1/4] selftests/mm/guard-regions: skip collapse test
 when thp not enabled
To: Chunyu Hu <chuhu@redhat.com>, akpm@linux-foundation.org,
 shuah@kernel.org, linux-mm@kvack.org, ljs@kernel.org
Cc: linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
 Li Wang <liwang@redhat.com>
References: <20260312114027.634559-1-chuhu@redhat.com>
 <20260312114027.634559-2-chuhu@redhat.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260312114027.634559-2-chuhu@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 8mh9dmkaou4sxs8foc8144x4tzkxki4j
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 4B063A000A
X-HE-Tag: 1773344941-663820
X-HE-Meta: U2FsdGVkX1+T/z2CRTWc4CnTYU0hDiY2DeM9DJXf6eIGC+KRG/L9bcLVQAHNp0AX/C4vyGs9eUj6Sq3ak/0gBR0zYmVtRBt1R3/BrG43ebL1LbruS9MsKUW8Dsx4tHrIZjwT6k8zPqlOHsnjmbrQambfEZdYuxx135Knko0ckehrpNaY9eJK0UbrbMY6pGaGEf0aego9jWXr2pI2vheOcQmPdXKi6U5S6fBEHofafWUMq/6aAEvMk1dVFtgaQbnch3/vKT/G11qYqFOvpm5Glemirt85nmLVbWLcjN34i4lz7tXdU2++X/UgEw98e7IE81QktJqjpVxnipB2I+cYrQ1JW8k+P/XkadbkBENUwGXcQehZ+etjAc4I0ieESfhO47NXmIg4CmXq9rPUJYUL1EXDItBGMFTEOi1GFOU9Aict3saj00orqxEnr2pTJ3/a4CF/ZYMghFyt0RlHTW2OguHVdcwwiNzEVxni593Ee5qVIbp/WIfj8c48vUqfkTgoMpgs1nG90phFXb3K9Ak0V7d7QgdH9LcBdGxgeCyAffKM9Zdnr5aOIGYz0Zd3GBPGrGB87uAFy+kRtir6OJ4CcT0M9URXc8siq83oh7LPP39xwixExIx1xW+N6wk/5Vv0W9skfuDJKJFzZ216+THshWi0uxw0i/00yazdI7Eu0pVvZRdtw7mbC8NV0cgAatJDxj8HaldD+gda7xnwTI6GANKw99oPrc2JJtxxvHEFkL7zNQolMP0XieeI67+X6Vmts7n5wkPbvq0rJo4apvbkG6uAJdSU9W2IcivdpttBT92ejHYTriupEgN6RMB06HhCP5qd5CpV1CDwTmdXlmuF31iDmQGvcoqlYTgYwYRGVSSueVSNi9/+aRo256CmxWdHGnq1ZeGua1b5SMoDa/nT1tntfv4U4O6bmkWjdL61pWKRdvKQGsetm64yxpTyZyFqItjvxrpE1bjqn6AcYzc
 aP162Pu7
 aWPw3D0gXiYyQ4SGQepn0XipXrTacRyc1vFqZpS/ImLeIhrulXH1AYvmM4vQ6ReYLGOLM/EZWnSCLX8EwwkCPuhUVqBjGymfSNLG5+I0Z/UFUGdlpYj+NTr1Xx3IRmABwCIWEIB2jyO+MF2YfmhnD67mbM4qnq2QQLQ507y2W0SNNeh7y7UhXIlWHblRDnHFLAA4+8+Onk0+0Kh9LSLNhX0tJ4UYD7jeBNTSF7QQ2JoAQUuPvXtmQi4d84xH41ftJ8IqPHeVWDjN+gvl8nziLRic9oCUIjeX7xGqpDXJRcN4RbwRaaagL7xjoZw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/12/26 12:40, Chunyu Hu wrote:
> When thp is not available, just skip the collape tests to avoid the false
> positive.
> 
> Without the change, run with a thp disabled kernel:
>   ./run_vmtests.sh -t madv_guard
>   <snip/>
>   # #  RUN           guard_regions.file.multi_vma ...
>   # #            OK  guard_regions.file.multi_vma
>   # ok 89 guard_regions.file.multi_vma
>   # #  RUN           guard_regions.file.basic ...
>   # #            OK  guard_regions.file.basic
>   # ok 90 guard_regions.file.basic
>   # # FAILED: 87 / 90 tests passed.
>   # # 17 skipped test(s) detected. Consider enabling relevant config options to improve coverage.
>   # # Totals: pass:70 fail:3 xfail:0 xpass:0 skip:17 error:0
>   # [FAIL]
>   not ok 1 guard-regions # exit=1
>   hwpoison_inject
>   # SUMMARY: PASS=0 SKIP=0 FAIL=1
> 
> With this change, run with thp disabled kernel:
>   ./run_vmtests.sh -t madv_guard
>   <snip/>
>   # ok 90 guard_regions.file.basic
>   # # PASSED: 90 / 90 tests passed.
>   # # 20 skipped test(s) detected. Consider enabling relevant config options to improve coverage.
>   # # Totals: pass:70 fail:0 xfail:0 xpass:0 skip:20 error:0
>   # [PASS]
>   ok 1 guard-regions
>   hwpoison_inject
>   # SUMMARY: PASS=1 SKIP=0 FAIL=0
>   1..1
> CC: Li Wang <liwang@redhat.com>
> Signed-off-by: Chunyu Hu <chuhu@redhat.com>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

