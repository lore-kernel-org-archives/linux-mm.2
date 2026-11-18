Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99773606A332
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 08:04:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=Q+yhGXCj
Received: by kanga.kvack.org (Postfix)
	id 83C2F6B00EF; Wed, 18 Nov 2026 03:04:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8140E6B05B0; Wed, 18 Nov 2026 03:04:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 750DC6B05B1; Wed, 18 Nov 2026 03:04:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 52EC16B00EF
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 03:04:02 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4D3BD1205E0
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 08:03:59 +0000 (UTC)
X-FDA: 85447501398.26.27F96C3
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	by imf21.hostedemail.com (Postfix) with ESMTP id 0A28B1C0002
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 08:03:55 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=Q+yhGXCj;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf21.hostedemail.com: domain of evers_chen@163.com designates 220.197.31.3 as permitted sender) smtp.mailfrom=evers_chen@163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794989037;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VmfBxwAiycnX976kOf40RwA8Wkvw1aPxgwJ9mlg6QGU=;
	b=JQQ7bE3O/YOdUCUJL2M04NchWp8WFIvpZdRszMwDiVzC0f13awr+cbkGHOvsnPk9OHH74U
	eMLgA0QJ2Sg4rOz00ElZhek5w2kDIefERW2gC+OQqsQbGVZ8yfaZi6urOWzQIMiZYmvbF7
	O5JxiNnB5lXTxN04zC3rLxTfEF6mPNs=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=Q+yhGXCj;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf21.hostedemail.com: domain of evers_chen@163.com designates 220.197.31.3 as permitted sender) smtp.mailfrom=evers_chen@163.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794989037;
	b=qZO1R+wfN7zuffSCmSoLdHUOgeUci9wrEO9pFVW3LahGddw+cJDAKQj7OheeDt7RKTnFt1
	T8YDV7MRJb9L9NxgC5rT9NpxdynjZvuNXM/xw9hThT/IDkR61qGRQ/wvB806x+dOzt1ATd
	Woez7n/Q0hz3rU1DBsSYgixyWHt1RDg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Message-ID:Date:MIME-Version:Subject:To:From:
	Content-Type; bh=VmfBxwAiycnX976kOf40RwA8Wkvw1aPxgwJ9mlg6QGU=;
	b=Q+yhGXCjBeMdLEbk57TqADLtOejSs+ReSTTer/UpRB3jI17A6D9VfPSrNNPjee
	79lued6lEb18IrQgw+YSE/iMLT9kSOX2Cq/UPhERDLzizhr2zX4R8dA1ygXJo3D3
	DjpOGiJeuktNjkC1kfXFYohAkZfJI21K9p1K4lXQ6rTKM=
Message-ID: <138084c8-e177-42fb-b37d-7e8342ef309c@163.com>
Date: Wed, 18 Nov 2026 16:03:38 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] selftests/mm: handle implicit read permissions in
 madv_populate
To: sashiko-reviews@lists.linux.dev, akpm@linux-foundation.org
Cc: david@kernel.org, shuah@kernel.org, ljs@kernel.org, linux-mm@kvack.org,
 Xionggui Chen <chenxionggui@lanxincomputing.com>
References: <20261112031811.56500-1-evers_chen@163.com>
 <20261117070606.3752-1-evers_chen@163.com> <sashiko-outbox-220290@kernel.org>
Content-Language: en-US
From: cxg <evers_chen@163.com>
In-Reply-To: <sashiko-outbox-220290@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:_____wDn16LaW_1q0gjLIQ--.6744S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7AFyDCw48uryUtrWrAryrWFg_yoW8KF1xpF
	WxWF4Yvan5KF17AasrKr18trykurWfCFs5Xw18tr95ZwsIya48Cry2ga45Kryfta92qwn0
	93Z8ur9xuw1UAFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UmAp5UUUUU=
X-CM-SenderInfo: xhyh22pbfkv0i6rwjhhfrp/xtbC7BwoMmr9W9yd8gAA3V
X-Stat-Signature: r4eiq7dca3kkjoxjyzi3u3kwy5cqtzcx
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0A28B1C0002
X-Spam-Status: No, score=-9.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794989035-57513
X-HE-Meta: U2FsdGVkX1/yTs9yaELX0ih3jRZlE0pDCdITg2DWsUX7cfVl7RCboln+8rMItbiVLmUYf0v29q7LHnWGeNGfjVBKQYgZ6aX9Dys6vFgNsRtByyIuNyYwa8Jbrf2PZB0Q6ICx4TKOXP9MXhlTL89dKRcszdvyyTpM3Rl9doouhpT56tXs6aHazlQPvsr+NldtnSKKk9m3hKGyxTNatrH+nrF3e+qUDuFDXS82b7/fdfp3yi872J67vqJbc+mJHGUiyo5LNUTcfvp+54CIRm0G2L41JLX9p5OU7JtzO6PL1NqLsyuVaqX4y97tRSsSdGsI9S/FZeqvO7F203EoPyEaojcFcYAJskIoZpo7EM/gCWPANxHxRMRsG3lQVyvJ152yfkTnjRac7BLF0Qzi9beG6cC3Z4MgCx/1aN9mgkXFpePprTj4ULtJkyU/oLKGRnJn/sqNK7eI6CVusvIJhbI/Plr0ha//LhTQLnKnGrXQsyMWkgt1R1FIaeZJHJUdRmYGoRj4a/0uBcCJh7pNyoCzVuOY9daz4bCQdAAof+fWbDEbYNOp0S/A6660mBHrSTOj+VHQVXK7rk6tV4zzI3i2Jm5O8wCJF3gdLh2/M8+1sYjo9bSk4arsEoAuokmVhm9Siw9njXAGw+jmDfv7CTpCB4uLvQmuokUOVfqKkcKoTbje1RxjiUbFsru8Awkd6cZLGLcCbwt8hdiZrjMgfrnPDs60uFQGa0bEYIMn4npptP68pdhkF8BBPYpnfONGxMKi43AaCwpQuzum/cbYxxUG8AsJ3lrInRiWenmTTzl1nHeBhYviG7ekasQ88pBUmaLKo8CDZn9DjEMZbLy+UeweOcVVTX7FK4iDEg+UY9Pdtgxx0NP1Yr06jVLIpAZkyXmT/WH+6oFLrESk+h2P9htGbLY8pBwOzPS65w+shOHEWh3bJM1yfVz7vs4UVrQQ2kTjwQ/6474qtAQhvctk+RB
 8xQsj9Cl
 BpblIOYsIjRcG8ZHfixw4hdJRg6bOI0kuCvocLSsDNdHXqDKR/uUFi3rJdjhFEVwUwiutFNGMI0H4kZo3Vubvrp10NycQNsHDaWqlEuVGE8jND8KG6mgujiXXbN+1Zl6z6Yw/pmtdGHm8BCLLuAM8aPNXPOeSRaIFvnNrLorIbOzvsiqwV21meJO603vaS4SDmoPhJ5PARGdY84GCRAQn/k+v6clVRdC5QCR++zOlCgC2/jMOnE7mVjhKshTJjCc5DSxzMcfQZhjr/d6FpKU0sBXzXfSPYNgjrZKy1msF9t3N9ocPAHa5vj1jbWVkKW/ji0Ja6zySHA7eMo3pKlgYSSHmWd31QcSFgjj4dCvRZ2XJyb5r7oncuEDBpAc/fn3G/Alto3FFDmr8J9O3RyQUyGX/ISp/WZejcBhw1Pq+ye9dEP0XM5f0cQXkvn1j7XyP3QBOtM8Th0bTxwlCJR1vOOMQZw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Andrew,

I noticed that the Fixes tag in the patch currently in mm-new points to 
the original selftest commit.

Since the test failure was introduced by the RISC-V VMA permission 
change, the Fixes tag should instead be:

Fixes: 6c7559f22b6f ("riscv/mm: ensure PROT_WRITE leads to VM_READ | 
VM_WRITE")

Could you please update the Fixes tag in mm-new?

The code itself does not need any changes.

Thanks,
Xionggui


On 11/18/26 15:07, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential
> issue to consider:
> - [Low] selftests/mm: wrong Fixes trailer in madv_populate
>    test_prot_write()
> --
>
> commit a72c4c7dc3b5c0ebca1f3529ca19931b9c980959
> Author: Xionggui Chen <chenxionggui@lanxincomputing.com>
>
>> selftests/mm: handle implicit read permissions in madv_populate
>>
>> The madv_populate selftest assumes that mmap(PROT_WRITE) creates a VMA
>> without VM_READ and expects MADV_POPULATE_READ to fail with EINVAL.
>>
>> On RISC-V, commit 6c7559f22b6f ("riscv/mm: ensure PROT_WRITE leads to
>> VM_READ | VM_WRITE") makes the kernel set VM_READ for mappings requested
>> with PROT_WRITE. MADV_POPULATE_READ checks this VMA permission, so it
>> succeeds and the test fails incorrectly.
>>
>> Adjust the expected result for RISC-V using an architecture-specific
>> conditional, while preserving the existing behavior on other
>> architectures.
>>
>> On RISC-V with Linux 7.2.0, the original test fails 1 out of 16 tests,
>> while the updated test passes all 16 tests.
>>
>> Link: https://lore.kernel.org/20261112031811.56500-1-evers_chen@163.com
>> Fixes: e5bfac53e310 ("selftests/vm: add test for MADV_POPULATE_(READ|WRITE)")
>> Signed-off-by: Xionggui Chen <chenxionggui@lanxincomputing.com>
> [Severity: Low]
> Should the Fixes: tag point to 6c7559f22b6f ("riscv/mm: ensure PROT_WRITE
> leads to VM_READ | VM_WRITE") instead?
>
> When e5bfac53e310 ("selftests/vm: add test for MADV_POPULATE_(READ|WRITE)")
> added test_prot_write(), mmap(PROT_WRITE) on RISC-V did not set VM_READ and
> MADV_POPULATE_READ returned -EINVAL as expected.  Backporting this change to
> stable trees older than 6c7559f22b6f ("riscv/mm: ensure PROT_WRITE leads to
> VM_READ | VM_WRITE") will cause test_prot_write() to fail on RISC-V.
>


