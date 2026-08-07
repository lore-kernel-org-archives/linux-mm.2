Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5CF84C2A09B
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 06:00:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 448416B007B; Fri,  7 Aug 2026 02:00:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FBC36B0088; Fri,  7 Aug 2026 02:00:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30F596B008A; Fri,  7 Aug 2026 02:00:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0C9CF6B007B
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 02:00:31 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 73242A02BF
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 06:00:30 +0000 (UTC)
X-FDA: 85073423820.06.26F5A9A
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf03.hostedemail.com (Postfix) with ESMTP id 932FA2000C
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 06:00:28 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=JpWagSuz;
	spf=pass (imf03.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786082428;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zBrwjfjXE+3yE2lnTHEP1Q4HGdLFTUWtgtqyZoWBQQo=;
	b=U/fy9GpbMjBalogd8yO0bwymmrYNJhUUYzaFnI1LR8Vozi7YNiFUHw/GGiFK412YzsZ4JJ
	pz89GcQHxYqBhtMy71rFTQ54QfHJobtyJ9nUKwkLQis08RKCBcGUx9t7W3AxnEr5SUqVKf
	gXw+WE61DypS8sEt6kymbnb6QZ7jzk0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786082428;
	b=h0iXnIkZ3ME3Wgh9Nv6D7l0C7MZ/OMR02ewpMnvHLdxrybLs7xuQsItG/ZW5mr02jovVb3
	slFoy3N2KJV3AIgBw/ePFlbaxSNQfOMR3/W7x0w96R5K8QY5znLPVmzRaKbpOp0fLHyaLH
	abNTUQW3B2Atfy5irtyXHucdqRRRfzQ=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=JpWagSuz;
	spf=pass (imf03.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B88351516;
	Thu,  6 Aug 2026 23:00:23 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 06D443F86F;
	Thu,  6 Aug 2026 23:00:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1786082427; bh=BsUzJFIkkXVMGdU5PzFbh47pg27G+Jp6D4XMactssA4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JpWagSuzryOVzE4Irh2B3xcPTun1C4qhPTv4PCmqLKUClfnVMUz3UPSaPJXO8NMqC
	 /z717uNUdTf2fJjo6a5sUCnN6CZvytQ2is4MHnOQvl7x/CtRKdso1IK/HUlCjCImWT
	 uzC8UepUv5fBYfEO/JTgIVkzTG2rNmZeIFDUKpXU=
Date: Fri, 7 Aug 2026 11:30:24 +0530
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: Hongfu Li <hongfu.li@linux.dev>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, shuah@kernel.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, Hongfu Li <lihongfu@kylinos.cn>
Subject: Re: [PATCH v2] selftests/mm: Drop duplicate
 test_seal_mprotect_two_vma_with_gap() call
Message-ID: <pwdielwzixk3v5lugx4uq6m66octmpmhqn6ankwyqkvdquscty@xwcrhdcd3ext>
References: <20260806030850.76077-1-hongfu.li@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260806030850.76077-1-hongfu.li@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 932FA2000C
X-Stat-Signature: fzdcaxzotjjsakb9jbca5gcz8zjk3a9d
X-HE-Tag: 1786082428-974043
X-HE-Meta: U2FsdGVkX18YcdoemkQ+WixkdUfSUe8lPfBRW5b8Px2iukL7RIT6ZSF5ftT6lLVejlvx08K9c4bcOdwuF7wt8GBlIRfvZHoFufoE7akSsB1x3xEGmwGIuPiNGaxF+IP360j4/YGkLCyatH00B+vBc2UqdafVQaWPbj758CfpP96nFOUleggfn4ZquUSS7YhuSCHQlReupDumfSe0ADRrP//xEOk+E9CFTE9pTfJqMxgJLF/ee8KfVTBHMhRWEEmX2MM9Dh2hx17D0gLrzXEDaPGyKTYMhr3FQB6BlokQze6G6AFVxDHDEzFpwx1xyacb6fUhc/cKXt/syhGcImj/4cr+HctdccbrUyGpwOSkHrYp5Cni7abgDzjT/e3zPYRcYiYCqxIxw3IrwuBOi+LVyfl98GNpzwEn6MhKDcsMtxObFtV9X61SwYV0hPOQzN1aR8u0759LpiLUlZJm7bWJRKHVlUHvbZHInmtRcoi6vw8A8Y36pH3EvYJVOnJjDFCff6Szd2Zhrvr18WVfbtjLEeEU93JWKbNi2y43JepDAfKTLpEWPLtxkrobbJohkr50xWVhG/F/ykfnTBdOGcTr8VtAF/XW2eaGParTEOFhuctakQbuDLzszX2Ar4Nl1aQVT/s83mcF1NZDFjujDaPVyPf6Ho26hSTqQg1zovZviA6hXjJ0gfxVwV9OpUxKPcLWKvAuDsuky7THLRce/a1gbU2CdIMqmHqF3ucu6r9OMMC8XfaCUMhXLMJBjYiwgTkjKfpauDGtVDsDfsALRZUv/hNDQkus74wskNExwuLJ30ExDHW7R/tBxhs/j7MVrDmnsiLf67HjPm2mFA8Lc2OWroBBPxpcbpNgWgocf9i6Zr2CHcu4IxS5NEvciSEXXYxMJPI3/PGakbdul7ZiikuH/snfwPCFC9DLjI58LdcUSK0TepPZPkmW5Tj5CJFZ70k1Yzi6IZ47me6VvF7atd8
 6Ci2/2pJ
 HlBLPnZoCudmokWAcYMmaWZM/tQyHrgRPs5A/MFVIJ5l2VXVgR65KQ+XLM9eLiuBbTs/CSmoXOQX8Pyb91Dx5oGZEi+GyKlQ7geyBQ0JP9oU/Uuo0XLzPi2hbR4tv2vuaT5to+vgYQ38Kv+LLWVbtP+TR4s47Vp6Ncs7/j8LJjosNVwuV9kOkvaSl3W2X7M3qfKn/UY51RU21c5RNLea8qQV8a2ChUSRrfnINZFZBycwNpyix7JJCjdS+r3gOImLjM1pWDmTWL8V21Ip6UiDb3cWxqYqXTmiBqSXKD08AHGgiw+mwGpjn6U00COGnYC3eJLqCGa/fDTQm8uKTbbibKUwC7y7PCfZ0+hm8YvWbN8fig3seI2PuqkBoIc6KaM/UssT3n7PCAYL2dBHmqSmdj05X7A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 06, 2026 at 11:08:50AM +0800, Hongfu Li wrote:
> From: Hongfu Li <lihongfu@kylinos.cn>
> 
> mseal_test main() invokes test_seal_mprotect_two_vma_with_gap() twice.
> The second run repeats all assertions with no benefit. Drop the
> duplicate call.

Guess these two instances would have been introduced just following the
adjacent other test cases where one takes true and the other takes false
as arguments :)

> 
> Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>

Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>

> ---
> v2:
> - update ksft_set_plan(88) to 87 to match the actual number of tests
>   after removing the duplicate call.
> - Add Reviewed-by and Acked-by tags.
> ---
>  tools/testing/selftests/mm/mseal_test.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/mseal_test.c b/tools/testing/selftests/mm/mseal_test.c
> index 93c2e13094d4..1a05e6921fed 100644
> --- a/tools/testing/selftests/mm/mseal_test.c
> +++ b/tools/testing/selftests/mm/mseal_test.c
> @@ -1876,7 +1876,7 @@ int main(void)
>  	if (!pkey_supported())
>  		ksft_print_msg("PKEY not supported\n");
>  
> -	ksft_set_plan(88);
> +	ksft_set_plan(87);
>  
>  	test_seal_addseal();
>  	test_seal_unmapped_start();
> @@ -1913,7 +1913,6 @@ int main(void)
>  	test_seal_mprotect_partial_mprotect(false);
>  	test_seal_mprotect_partial_mprotect(true);
>  
> -	test_seal_mprotect_two_vma_with_gap();
>  	test_seal_mprotect_two_vma_with_gap();
>  
>  	test_seal_mprotect_merge(false);
> -- 
> 2.54.0
> 

