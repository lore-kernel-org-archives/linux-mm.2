Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68708C79FB7
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 15:02:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 314446B0093; Wed,  9 Sep 2026 11:02:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C48D6B009D; Wed,  9 Sep 2026 11:02:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B45A6B009F; Wed,  9 Sep 2026 11:02:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D761E6B0093
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 11:02:16 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F1B2180244
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 15:02:15 +0000 (UTC)
X-FDA: 85194539430.18.49E701F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 40D3E1C0003
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 15:02:14 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UeN7pksa;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788966134;
	b=8mZFo/BIHtHjcS/7vEXtrdXMUlLtk7SgFvg4pl7eqVWtbPTmn6oEdFpOHnFV7fSMvt5zk4
	7CF26ZoOK15Oz6fEG4hVx9z/qLmnJmiQtPsOhdhNXv96byTAj74652dcfhJIC5YmTVvcAl
	NKsGrh57qQcj1pr1g1/uLxgz6LJ5wbU=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UeN7pksa;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788966134;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3KfExOA8KS0crEDl2q+9ULW4PP/JesVC+N5DhTICNJs=;
	b=NCKvV0FtCp1abXZnlUJ1VN3UdohX8ttCtvgcmeS0WL3G+Ai87NCgHM3U0d7ZSj2DGAZYPy
	pOnZ9IMdD/pdw0UIMeUbNpah8C/b2e1xGxguCBM78hPHrZ86XIpL5+53kPmZK+o7CV6fnl
	GL1H8mf5/YsI5sG2rnlyDKDIqjErths=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 993756020A;
	Wed,  9 Sep 2026 15:02:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B4401F00A3A;
	Wed,  9 Sep 2026 15:02:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788966133;
	bh=3KfExOA8KS0crEDl2q+9ULW4PP/JesVC+N5DhTICNJs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=UeN7pksaadSHMoEPfMk+ZajCW7TpStgfP3pR1FX98wY2nSvCyBtlgh4lBomgTWT1K
	 hWWiqRn3jREcRJUiJseRXfiYhvS+Q0sy0u4yjQ5ijDmeEkkVXk/Y+KR6iQuMZ3T2oc
	 lyoG8GepmPSZNc0eLwoWreX1prlhobT7Nwn7/YTRFy9McMoDBwxzV4TIBcxSo7bTSJ
	 pcAJJSg7bRf7YqfWFqeTWRHhXldo9uS/+EX+uP9aI++4pAcpKtzzHrFGf1Z57epXlk
	 dYZL2I8XyMCDE13937q0egdsqFp+vA14izbde9eAOtLY7L5xM9ERgL4mfsrDHqN74r
	 KVfRpbU3j28pQ==
Message-ID: <bef8f543-ffa9-4cc6-8a7b-6118daf14f76@kernel.org>
Date: Wed, 9 Sep 2026 17:02:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 RESEND 0/2] selftests/mm: Validate selections and scope
 memfd_secret setup
To: Tianyi Chen <diannaaav@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Shuah Khan <shuah@kernel.org>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 Joel Savitz <jsavitz@redhat.com>
References: <CACGbirSdR30=YTPQGN-=202jZqiF8gBSewhq+K_fTSNpq=DMhQ@mail.gmail.com>
 <CACGbirTZFsyQhOszpfiHhrd7Red-L_Z_=ke7DbRDe5SQfzi9Pw@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CACGbirTZFsyQhOszpfiHhrd7Red-L_Z_=ke7DbRDe5SQfzi9Pw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 40D3E1C0003
X-Stat-Signature: k5u5qgdheu85uuknpoib5buq8bwuhipw
X-Rspam-User: 
X-HE-Tag: 1788966134-805210
X-HE-Meta: U2FsdGVkX1/25OXWrtI47/CZJ/yMENTZKieIhosWv05Nsr2FSh6+lByB6kr8Y5LAy1P8o9vvbsJ02aCtqUff6JZvK8je4crIoSTPx9eg365QTis74Fmfas9WU2sGSXNa6R5Mwy1eJLRwOWiioTeANdAVAwSYIG0paECBINTre8hR0KVJ6DntLoCd00CSU1B5al6ltnQk1+apm2ODFQhOxoG4Vw1z3ANvk7jnTO0Ha1Eis+KWnJ7ifGgulj3IcOMv8EZHK312ckxNQKMH3Ia4t/SPOdUul9RlpLTMeCPng0qOTXv0ztwQc1hwHzfVnT14KQYqqZ5v330Jv8gwWW0sXQONoGgoxmBvw49LwYpb3B1MrUHhibxqq1sYlMTV2x1Z6nKZAeBdGHhPBpAU8n8YZfYuvL60xaDrzSBd7dxFOKmLXsQesQRJgDvrl7boXC4Qqj/pEgs5DevQEwY8XcikmyAmSz/ohEujw2K/PnhQJYrFgiHIfOJlO3rqRYw4vJhPa5UmXIMttkilHa+lcQCRt+517C1oXGL+bLqv2jwGKTSS3jV0UQwQJVkxrxoSyJJZkdnjDciVHp6/cEiw2mL64hjqMPxUgToOoz+817JyN8BfmJCfq/II+onAdrz2X+l+zdAm9sbUa2+n9e7DlpWzKtGSknES+Ln0RJVcL6OaGlKdMfALtZSZ4BKmVgi+ldJTTZHvqX5V3juEp81H9Mm3FMkWLBKMPYurOMN+HNBUktq1HgR/5AAl4Ik8U1Gj37iJePrn3ceag3jvFhOdoAWqxNAUAit0aNK42UqNFxw3y4KT7U1o567DBUIqe9NS1EPn+lxJslCOhE9zhOxiuTzO7uHIWZGkPX3VANehQtdvZKWa/KYjNtLHw8ckMTEodLmW7CJvejyXEM6i/hN1QLL44X52FsB9elmu/bQ5b8AKuWp/G/7pyuFjwapXjrPJRZ9RJcgTMF/5l8JkqNYgaU5
 7vV7QKNL
 IF9I2N7iETczApL3vMWkulTH9v8ZUbJ5gJufoCf7rSV7LJFUwnfxCbsmjeFwrSA7tQzbZxoVMLBkZd3BHNMQgzlFng2+uTqskffJGVqUJJN2F8S8xCRcHHHUsvCLVZs0uofFpfKFco0r4CzeuqCae8WaFM8RhFlLkecXm5ncPDi9WPIF/8DG7NOiUZM7DLl4Nsr2hlcYZN/06b6m+Vd8TRbQvWdbVADXwtDEYHeQOpRAvtFAiBbkbdaSikvxOEgbmzc12wIt4bnbLQ7A5PS72aAEJQi2ZvnF8QwtMWHoq0sa6HfodPK5jNc8QP7QnjF61kwdFdxVuN8U0bwyvwNmQOVXjqyI68P0HnEWi39mHDhZrTPOe/kOyEjV7+VekCbu4eGdX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/9/26 16:54, Tianyi Chen wrote:
> Hi David,
> 
> Following up on your review:
> https://lore.kernel.org/r/d6ca7f47-39bb-43b4-92d6-63ccc148ebdd@kernel.org
> 
>> Who would set it at this point?
>> Can't this just be
>> VM_SELFTEST_ITEMS="default"
> 
> V3 makes that change: the default is initialized before getopts, and only
> -t changes the selection. An explicit empty -t still fails validation.
> Both patches use Assisted-by: LLM, and patch 2 carries your Acked-by.
> 
> I have resent v3 at the start of this new thread from my Gmail address
> after delivery problems with my previous address. The patches are rebased
> onto current mm-unstable without changes, and the focused parser and VM
> selection tests passed again.

That is new:

$ b4 shazam https://lore.kernel.org/r/CACGbirR9PNt4uhqJFATsOWnwmsNb-v8zau-Rb+9Q5SZmY-=Vug@mail.gmail.com
Looking up https://lore.kernel.org/all/CACGbirR9PNt4uhqJFATsOWnwmsNb-v8zau-Rb%2B9Q5SZmY-%3DVug@mail.gmail.com/
Grabbing thread from lore.kernel.org/all/CACGbirR9PNt4uhqJFATsOWnwmsNb-v8zau-Rb%2B9Q5SZmY-%3DVug@mail.gmail.com/t.mbox.gz
Checking for newer revisions
Grabbing search results from lore.kernel.org
Analyzing 4 messages in the thread
Analyzing 14 code-review messages
Checking attestation on all messages, may take a moment...
---
  ✓ [PATCH v3 1/2] selftests/mm: Reject invalid test selections before running tests
  ✓ [PATCH v3 2/2] selftests/mm: Only prepare ptrace_scope when memfd_secret is selected
  ---
  ✓ Signed: DKIM/gmail.com
---
Total patches: 2
---
Applying: selftests/mm: Reject invalid test selections before running tests
Patch failed at 0001 selftests/mm: Reject invalid test selections before running tests
error: git diff header lacks filename information when removing 1 leading pathname component at /home/dishy/linux/.git/rebase-apply/patch:6


-- 
Cheers,

David

