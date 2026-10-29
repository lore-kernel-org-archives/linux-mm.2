Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4EA8606A31A
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 21:59:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Kijhsrvd
Received: by kanga.kvack.org (Postfix)
	id 9E2DC6B05B1; Thu, 29 Oct 2026 17:59:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9BCE36B05B2; Thu, 29 Oct 2026 17:59:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8AB7F6B05B3; Thu, 29 Oct 2026 17:59:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5BDDA6B05B1
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 17:59:36 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E2700A811F
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 21:59:35 +0000 (UTC)
X-FDA: 85377031110.13.310C38C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 5E6DF1A0008
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 21:59:34 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Kijhsrvd;
	spf=pass (imf19.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793311174;
	b=HKvck55bHgbRtKrmU8bgTUG++Phs9V98Ia1Hxdy++WA3SUhFHgKQbjdozoD13/TdgSiQUk
	vMYnmu1bT3Rz9xuf5GfEQsRdn+RgFRlpNfIoUwHs7cRbDjErhb43MiTC/wfDhJRJOON+lj
	jWzSLNg+I+UwGqL1vXv5z7nAuoAZvJA=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Kijhsrvd;
	spf=pass (imf19.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793311174;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M+YkVfh/m9QNMVkwEafBbwPCRvwdpFTGjYDGrmLRT6g=;
	b=IWgjTT64GdMcKFIq14rXWPbc27jINVFJjnpBwhJEzIrRJtokgIftgd1mI92fT/tSCpbCpy
	2pBJ1A7PJzW66PHhET3BwEf5ICB0JsIDncwKZaJ5nKz09/TEeB/hHQR/u1jbtHnjGpsyMq
	xwRdHq7HxSe9gGm6g5ZpfJ3eFj7ekU0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EF362605D6;
	Thu, 29 Oct 2026 21:59:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 632561F01816;
	Thu, 29 Oct 2026 21:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793311173;
	bh=M+YkVfh/m9QNMVkwEafBbwPCRvwdpFTGjYDGrmLRT6g=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=KijhsrvdCMs7njoxZIgNpvRfUz8AWbcZLX/EFCBaqexoqJ5laFtbXpTwuWKaWQCeE
	 CfYMoIGpALaRSk+S8S6zLHE3+RS0mKXTToXZJs7QVffBu9u7xjMS/aIR69kO8hbA7b
	 cHnIdO8kHFlJij+tU7GeVZrPjRt/ZLvNRqxUdibZ7cFR6vQbj5szmwfhjgS/YPrqGd
	 Ggok7RAsI9q2+QKK9ejSMNBExWQgZZlY67FTAiKmx4rwsadju7KyelHVk2oBuj4lZS
	 Sy5dMB78xEDPktHiU15wF7wusyG5HExR9+7s6mJvc7DAUJ5+I4giqkHKAtm+eVpwOt
	 Hkb+uaU227oCQ==
Content-Type: multipart/mixed; boundary="===============3154708283504647599=="
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Message-Id: <d023b011d67ae13695a93c94ae0197e96fb5d42bbc3a4a63b42fcd0c1852a605@mail.kernel.org>
In-Reply-To: <20261029212551.56964-9-jolsa@kernel.org>
References: <20261029212551.56964-9-jolsa@kernel.org>
Subject: Re: [PATCH bpf-next 8/8] selftests/bpf: Test user memory kfunc errors
From: bot+bpf-ci@kernel.org
To: jolsa@kernel.org,ast@kernel.org,daniel@iogearbox.net
Cc: bpf@vger.kernel.org,linux-mm@kvack.org,andrii@kernel.org,eddyz87@gmail.com,memxor@gmail.com,ljs@kernel.org,john.fastabend@gmail.com,nierro92@gmail.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Thu, 29 Oct 2026 21:59:33 +0000 (UTC)
X-Stat-Signature: bnqgncafwr5bx7x5oq9f7y789k445d8r
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 5E6DF1A0008
X-Rspam-User: 
X-HE-Tag: 1793311174-144302
X-HE-Meta: U2FsdGVkX1+oxuCBygXPoIySCOWyrr2j0GBTmz/e9SZBpw+qFH7ZVRyrBesI/TCyhqJWOFqWPNsT9uNUXAX1ce9BI22gHWinrDr4CRnGTHPXesu5raFbwoGyrr5IM8OSv3OFE44zjBK+OP+0FNluOQpTGRuM1r0eHdlaKm1W0BaDKil8bqyLy5S7TdZGpsBFdoOAYqw0FYlcrDDXTdjhyMpa3f1WX0EFcDrMnb/Zm0p2vqNlvBBWNQn1Yw2DV6F+AiG8DyNotG844ZNKBOaUMBYwqeu6zurRZQPB46UKsrLGI1/OD2g94+V3UC//z27OTWG/yeMVbTcdXRe1bdut/1uJrbRbeYGR5f0gxc6ARxVoWcQVjg5duZKOlF1vg6ZSv7jchqVl/BBlA1qMnZRVwhfdhV6Hc8elFBAS74mytEgY9SWMF4IBFNQ/fG91LnA93fecbNteXI1BlAZ0dTpD3DVyncXP7VvTG/9WzNEH1+nHA0wrFKAuw7h5pxMZImsjwhwEImTZdPjIIJKbcJzzn3v2b+7Ykhs6CNfqyKlwPfCQ5NxVeL9KrMBit983RkgRD+mx4XGCPeWi04kuOnOk6Tqgvk4FQ+mdVCGcM6nxPV4eyvbWmUjDVmK7kb8HhuAL3edy4rtvkeYato+CoNc41XkMBiX9ecEJms1G7L+fc9pVsKQY6hJFerE1i+PqJ2ibjHg59jlpSy98aDokCy4Xj/83D3azsWBdn08fxttPjlEfPAqLvwVYF20YMcAbQUXNUAZQRXCMYv+EPEPBaJ0rgy0ZW8Xu5/914aKbmXotD7+1GiCVaoHK4LVcJvkSXB6bTaJ6hwbJDe7W3Wtr1pOMW/VvCsJkeWnotkVqBi0wHpmhc5A434pKG7QljnE9OH8FuoofoqVHZJ3jhy46wGb6OCAjpRlhpswpFHNzzNRogWncaezUPgj0HyWx1ENB0u+Wu+iMpGLFcUqJk9ifrEV
 nFDA1OQl
 cij+rj7lqk4CBoL+imhQ5oxdCBPX39cEQyxSWYQwufvWCH+C9PKOxYFMJP31mhqFyM03SgyFzZxeZEQXMF8NHHbMBwC27T9WeYjeW1Tf2GqWoIQ6xPnSmbFiZ/bn7awUrpTxm8tID61UDbxkjUHnsp8yYKDmReQSbiST7djmFJe/rCDWarPmFTQPIhCqcM+9CL4kPmkMDprge+iP9qjGlZ3n41T7TewJefTLmrNSF6CIvUk1XqDwjPO5m5L1JTOJk3hAt7OwW1Isa1Xp4Hf+fKmlceCzS1MktWhmXu8SUhYkU5en1KUxjFITd/22+/lpCi4P0QoqkvpKcoHgqmKE1ZQ1IAcaYt21IrRA5F/FOLd8baGRch3G32Wmg3D92FsyqBSnS9ccook9I5c7jcUGLLZUoZXVCSsNwIzWcHvEetSBPC/Du+N8GTF4Q80WkZlHsyx8tmERc3GN/G9HlD5PlvuiJG7ls+5F666jR5p9qU7wKqPzzU7A9TJanAFuEUX5LgU0jVBW72UlDSlM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

--===============3154708283504647599==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> selftests/bpf: Test user memory kfunc errors

TL;DR: Commit message only: it claims tests for partial copy faults and
read-only mappings that were added by the previous patch, and omits the new
RUN_TESTS(user_mem) verifier-failure tests.

> selftests/bpf: Test user memory kfunc errors
>
> Test invalid copy arguments, zero-length mapping operations, partial copy
> faults, and copying to read-only mappings. Verify that a failed unmap
> leaves the mapping intact, and that non-sleepable programs and programs
> without CAP_SYS_ADMIN cannot call bpf_user_mmap.
>
> Assisted-by: Codex:GPT-6
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>

The changelog says this commit tests "partial copy faults, and copying to
read-only mappings".  Is that accurate for this patch?

test_partial_copy_fault() and test_copy_to_readonly_mapping() were added by
the previous commit 8f0bac0f80cd ("selftests/bpf: Test bpf_copy_to_user
kfunc"), whose changelog already describes them, and this diff does not touch
them.

What this diff adds is test_zero_length_mapping(), test_failed_unmap(),
test_invalid_copy(), the three verifier-failure programs
(user_mem_nonsleepable, user_mem_kprobe and user_mem_no_sysadmin), and the
RUN_TESTS(user_mem) call that runs them.

The changelog also does not mention RUN_TESTS(user_mem), which turns the
existing user_mem_test program into a privileged load-only subtest.

Could the changelog be reworded to describe what this patch adds?


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/40959191771
--===============3154708283504647599==--

