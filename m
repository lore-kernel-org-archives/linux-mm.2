Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A1BECA5FA1
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 08:00:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 11C706B00A7; Tue, 29 Sep 2026 04:00:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0CBED6B00A9; Tue, 29 Sep 2026 04:00:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F23D66B00AA; Tue, 29 Sep 2026 04:00:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BEF0C6B00A7
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 04:00:38 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 92767C03E8
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 08:00:37 +0000 (UTC)
X-FDA: 85266052914.15.198289D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id D98B84000E
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 08:00:35 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="kE5JbP/+";
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790668835;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SsI1aTMhUQ7yFgcuS8q6sGuXK6PShOkRgxLHwIxo8bw=;
	b=ZXjzCwFnxtmMcAFtlwOBJRhzVNeZ381IRATDuGBCZwgH2lOL8GX8M7SBRCoWLTPLr47v2i
	O1/BatzngYWCldR2xNAhIERXDxyRw5gfaIDWtjs9iNd9ejPVd6dwUAOkG9MpoxHBsCZlYP
	6cDWofHpgujejUN24TBDS3szfLMXytE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="kE5JbP/+";
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790668835;
	b=PjOlW4XOEEsUbJi3scFfdYKZqvNQlE8ZVmCZmkiGswradaJtrJ++sroB/mI+Ltcw9wT0Xx
	G6lw6oCV+Q/kb7GkSrPVnb1hqulHVvNlkYjBOFzCicCEVEwrCW3pgfUyo56OmzdyOvZQzh
	y+aqYuTL6GsAukw9RDINwJ2BTtQ91Yg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5FFD8602CA;
	Tue, 29 Sep 2026 08:00:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 526B01F00898;
	Tue, 29 Sep 2026 08:00:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790668835;
	bh=SsI1aTMhUQ7yFgcuS8q6sGuXK6PShOkRgxLHwIxo8bw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=kE5JbP/+geGNhnoBZyfrBLg74+xS12GUf2yVMpOt33AwH+tFxw5kfhqEmbb5drQCW
	 cRNGUhmKzfdm2uX5rWJLwbXvI/Wdo9Cr/2mhKlUueg7CB9FDQptXHVrwBE8+bwvm6I
	 Si7XCofnpDL+yQLGYIq57L0PNC82PTyh0f3c3GYmUai6NW/leDhRzNsgE0ZGIaWQXA
	 sux4DbUOHu52JNjdEIkuurGYpWKUQgYKBCf2mVyq4Zgax5SoWT/QDaHzfHDc0uAGcj
	 q3sSGgg00cOrJh9L8184eGu8uI3XwsWuH3Rj7IurpNbXpZMzji+gaz2GFQGmIKFzgV
	 9X4FxJFbG4g6A==
Message-ID: <49b0b8c5-4605-41af-9a83-26ec6a07bb96@kernel.org>
Date: Tue, 29 Sep 2026 10:00:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RESEND 2/9] selftests/mm: mremap_test: skip test when
 userfaultfd is unavailable
To: Sarthak Sharma <sarthak.sharma@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
 John Hubbard <jhubbard@nvidia.com>, Kalesh Singh <kaleshsingh@google.com>,
 Anshuman Khandual <anshuman.khandual@arm.com>, Park Tae-sun
 <ts930@dgu.ac.kr>, linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260924050009.19974-1-sarthak.sharma@arm.com>
 <20260924050009.19974-3-sarthak.sharma@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260924050009.19974-3-sarthak.sharma@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: j975zi8uk3wtfpg1thtdw588yr6qma4n
X-Rspamd-Queue-Id: D98B84000E
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790668835-40324
X-HE-Meta: U2FsdGVkX18i9X0BAL/KH2U1yG7jtPVXUa45+13DGh+sbqnFUYXSHjes8esTsT74S3hX/ybPBQLER1GGPgvLIAve22q4soyjT67DjWq10AT0nnBmIRxzK9UzwkZ353/qyVYuTgy1tPBQfsSKz0C0n1/xAxGegHf7STKYwYfckJOijJt4WsOnwervvyyXHAuZo5M/rvHWa6HywJXdNizB6+Dwo10ENkWa74Op8WFYYBh5pNLEAtm5JYeTs/jD+rZ1GMQLRwU9B14q7nfsgSb3tYupd7+YBERRVv7QXlBhLp3u4YlRL8c57gfcXr/5L0SAdvmvgtuURV+OTrHUMqa018aSvlCW4FATS1VN0WlPS6fYUk+MRzeZj4U80c37LfW/EMegzSiNufW0N756K62IBI72zwvTic1kxjriWErulk5CNiOx2mTee/UlBHfYnqmYR9eMHeZppg2jmPNi8F8PzoDDFkdnaDZJQH6RU74Kodu/Lae3b91EoPpVme7gVmprLR/DkqlnCKexbshld3N4eUfbVAF4KZka0hoG76T81hsypY4yK0UmXxpd+ebsL+TjVclHha/v1CJCRcE0h4eSZCtF8zz4WGrqKqM7h7uBKrinL4bT+PXUzjPxT75VptlVZMly9U6G2X393e2Z8lVN3gtJC2WyIfxlo/VhEP3IrAOFWwNdzSb4q0zZX0JZkYhRMbMxFe7WNMIczCr9iO2AnJXSmqLcIf0RCNEUHM/sZXeA+ZA/PD9K6Hf5UAi95Lmyg+myRD/Op3vTpxEjhB+V/pZSUdIxBmI+vFWnAkvos7b4TEQmyolht/+bPlK/IPxmGL3cRjgThBwj5rlF3VSLDvWNCrpJCq0Dh5dtKz+lcNGmSQGibwsz4EGxge/HCtyW+vWg7kdCEoiebXttlJQHhrr3JUwMKTwfPAzQkd1e4qaTc/2iM1cts2XAivDGnQYedWdG2/G1KxPW1MDjpEj
 sJLJP0l8
 2PvJAmA2B67wkBqs3CPTReVesVB5ES5v5ktp79n+BG9sNSj8Wj9JAdEklothcXKPP5Hc/BtcZG3tRlZiR+UxvdtH8VwiVXnWOia2D4hkvuQglmdfTGaRPbydxcF0owGIVVNF4bdxjjS+IL0z4YUdVoHgNaZmIEO37tXQShPVlXusoB9BvbDTJAJ6r8k79QL0ks9zoxp70O/oA1/oazYaww/jflm8E+i6USBhY7CZ2GKpsncDIRjrsMM4B0pT5sPvFtVKPsEc9k1fM398T+DgZ8+hytyrapy5/EWDSLQpYwjqmgCLkHtv/6hgG24Od8DjU7AxjBDJ6qKoclivNVVWXOIz2rkMiP0gaGmIJVL/wwxDT/TfO0m1XysqYklxJrOQOMx+Np7LCKJqG1LI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/24/26 07:00, Sarthak Sharma wrote:
> The userfaultfd syscall can return ENOSYS even when __NR_userfaultfd is
> defined by the architecture headers, for example when the kernel is
> built without CONFIG_USERFAULTFD. The test currently skips for EPERM
> when the caller lacks permission to use userfaultfd but treats
> ENOSYS as a failure.
> 
> Handle ENOSYS like EPERM and skip the mremap_move_multi_invalid_vmas()
> test when userfaultfd syscall is not implemented.
> 
> Fixes: 742d3663a577 ("selftests/mm: add test for invalid multi VMA operations")
> Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>
> ---
>  tools/testing/selftests/mm/mremap_test.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/mm/mremap_test.c b/tools/testing/selftests/mm/mremap_test.c
> index 5532d3151ed0..a5813a5e8f5b 100644
> --- a/tools/testing/selftests/mm/mremap_test.c
> +++ b/tools/testing/selftests/mm/mremap_test.c
> @@ -721,7 +721,7 @@ static void mremap_move_multi_invalid_vmas(FILE *maps_fp,
>  	if (uffd == -1) {
>  		err = errno;
>  		ksft_perror("userfaultfd");

Should we rather move that below the if? Doesn't quite make sense to print the
error if we are skipping and printing a proper message.

Maybe that should go into the previous patch?

> -		if (err == EPERM) {
> +		if (err == EPERM || err == ENOSYS) {
>  			ksft_test_result_skip("%s - missing uffd\n", test_name);
>  			return;
>  		}

Apart from that LGTM.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

