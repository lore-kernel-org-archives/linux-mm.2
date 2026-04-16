Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25A4FF8A146
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 08:40:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 26CFD6B0005; Thu, 16 Apr 2026 04:40:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2173B6B0089; Thu, 16 Apr 2026 04:40:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0DED36B008A; Thu, 16 Apr 2026 04:40:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EC73A6B0005
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 04:40:06 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3D979E4548
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 08:40:06 +0000 (UTC)
X-FDA: 84663771612.27.37471B6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 528948000B
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 08:40:04 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FRGv6TDd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776328804;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XuaF9MfsKfhmQouDFWM+lht7083CLnGsSoDaijTTrbI=;
	b=FULB7YRDONVOLiMjoQCWpwX8rUGjwtXeFEDv7Mh4rwXuYnv38caOLXmgNDZYlPEBFxHssW
	yDl0B4OZFPOMUksC1z1+2KVj2JBk2S9CKuETDWHTICT89nYHMXoTAV37iUtQNqa29J728+
	zVaCnMVdupnxzCXPwOzc9djqoExdCLY=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FRGv6TDd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776328804; a=rsa-sha256;
	cv=none;
	b=S5jT4ZYvnb8FOe3Fye+jUrc90dKiHU6yEOP8asNaSDttbiPRdX17/94Zyqr0buvSYGofZ6
	/ZEoOgzDUIKlcwqLVsC9O1P8RKjvp8K9qQqMTICSXdsEo/Edp4gkr2RF2bEkt1ZInhlmLX
	gTJIELJYjJvPgNhj5sJ9SR1YEPoJPN0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C643F43784;
	Thu, 16 Apr 2026 08:40:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C96C4C2BCAF;
	Thu, 16 Apr 2026 08:39:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776328802;
	bh=qoCcvhCddFl/JRy2cur4v0b/BY7NeK62mPtbEGaij24=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=FRGv6TDdb/CbTs0XqVEWfWFufNO6r11Sec9GNZCu99m074cH+9gDMKx7EQ9tMQXBr
	 OnRF/W9n//CCRHlK5PsY0adB2obxDy/gafQUEoS1jqc49gRe9eUslf+dK1p6MCuU8u
	 tNU8US+6mfWjCUyeg6jrteBEwdQurFTU8bWNXfuqjQApqOwtM3boYCfOqgAsSMhuXX
	 0xKKg0xcWwkoiM9B9sGTLwNZps5/PB+Z1zmmPL5P/zaNKKUjIXPMhJPRZyC3eK3HPi
	 7QPSxFZkflveXtdsasyl+8jWzH1UfnZa2eo3fE9f5lHmsNVU9pjx3OAreNFQRhfYiJ
	 Ru9sNP6eyUrog==
Message-ID: <a88aaf79-ad64-4529-a86e-b94fc8fa9b27@kernel.org>
Date: Thu, 16 Apr 2026 10:39:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 3/3] selftests/mm: run the MAP_DROPPABLE selftest
To: Anthony Yznaga <anthony.yznaga@oracle.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Cc: akpm@linux-foundation.org, ljs@kernel.org, Liam.Howlett@oracle.com,
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 jannh@google.com, pfalcato@suse.de, Jason@zx2c4.com, shuah@kernel.org
References: <20260416033939.49981-1-anthony.yznaga@oracle.com>
 <20260416033939.49981-4-anthony.yznaga@oracle.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260416033939.49981-4-anthony.yznaga@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 528948000B
X-Stat-Signature: mqm8i1egbyjm43t1wpeuqpps4xrffg84
X-HE-Tag: 1776328804-332117
X-HE-Meta: U2FsdGVkX1/jQxli3/YGGb53g4UHVVYm3zb3ZJrKHp0XsrMAlU/4uID2TTXb/U2+5sQrVSe5ibW/N9HTYogJFE31WNhYkifQpkx0q6jnO6mbom+hBcG64JiK3sttEyr1ZUq4VGiZHDqeF0tV1Yp1OjaBZH02GfsrF+5ot+CbIGnSmeghzscfkYtOI/7lWTSeIJdeIFXEuZB0OCUnVsm3wHp0ncrlwbmzDA1063+oSJmOrtPjeYXDOGwXBGYDibR3gIyd3j2cXHFPDyeWGK1YT63A49cvftSbU93UOevqyPrQFIu+/UeiSBCPPgiekJ5DbWE90AeuRQZSB8rpwMqNW+I8B9CFL7uFk0lno21+jTka+CWbwivpv4gH72fnWAtw6WOCdkzaEOSvU/HOl1NRW0EqqcNMVR5xPnuaOTadvVDpyzFQYpiBO1Y0enbqpp/25ztjCxuFQb9rQcx3yRBNAahTGBqdY1zjb44se841UKQSmc49ryJ4R+HhV/jf6GSnLFJ4ClsLQDcnBvY1K9G/xxxeoR/jgTqo7JNqgL5yYb/pTZnkeM+vOua8bM6QdCjdlVrq4pJpG3Z1UIwFQ/fm9atxzRONU3bh5wS9on8wbzKX7naeOCEB0n83C2P26rPUxEB7fJJgt5i+rQqdZxoqkfBSkDUtMSIx3A4GNN+yF7XShrmiuS+KWHTWKqqKzyFwIXO87zVUeKcwNzJzg0Kp3DYuh04CMI1N3GWzx+BbJCQM8sDc2m1k7RmcK5PsqkC//Y3fQ8kMqGfJfIPByt4LXC00p8y+5ng6OjKnyhFg0/jqadPxQ/2SUTSDK3UxqF3hS6FLgpdMLeQzRfmH9j10xaGyaMC0CpI8pZC1aGw8TZI/UYaNDrAx5Rf+ZSnGyQPc0x93Hd2A9xDUYgPw2Rkfmx1oSDH3GYOYvfyo/uAuhdX3PxwcMsFXIQc7g3kjYwJdpuoxGUoaOD4KLpoNNkC
 Iil02Okb
 UqHQReAIDTUbMCp+y46v5ZQ5Dcw1l91qufE8gtOifVboKLjQUOjksKwJ8gx8QikQEfv6DrkbkTD5nlOc0aLVuDdEQgkreq5rhgToYtMCdaNf18RPif+0+0omVIV+LgSYXI5ZDHMaXtvcjuOnctd6r3o6OYZdMZ6xTKdDQcHPwDzO5Fw79reg3yCNQ3Pwak2VEtgkD2KM8Xyc6jWZfs02CudxEP8mQT79qxSMaCWawGP4xuIZFw3ElOVE4HkZwFWxRbNWOtv5lOWGO3iB8vY85lOEl6JSIobo2mz0E239+5/abJMq90n7q7XvCmldVoCa+gU/hviU8KOml3Kz/62MovkouXuLRwvwh8F+T
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/16/26 05:39, Anthony Yznaga wrote:
> The test was not being run by the selftest framework so it was never
> noticed that it would fail with an assertion failure on configs without
> support for MAP_DROPPABLE. Update the test so that it is skipped instead
> when MAP_DROPPABLE is not supported, and add it to the mmap category so
> that the test is run by the framework.
> 
> Signed-off-by: Anthony Yznaga <anthony.yznaga@oracle.com>
> ---
>  tools/testing/selftests/mm/droppable.c    | 9 ++++++++-
>  tools/testing/selftests/mm/run_vmtests.sh | 1 +
>  2 files changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/mm/droppable.c b/tools/testing/selftests/mm/droppable.c
> index 44940f75c461..30c8be37fcb9 100644
> --- a/tools/testing/selftests/mm/droppable.c
> +++ b/tools/testing/selftests/mm/droppable.c
> @@ -26,7 +26,14 @@ int main(int argc, char *argv[])
>  	ksft_set_plan(1);
>  
>  	alloc = mmap(0, alloc_size, PROT_READ | PROT_WRITE, MAP_ANONYMOUS | MAP_DROPPABLE, -1, 0);
> -	assert(alloc != MAP_FAILED);
> +	if (alloc == MAP_FAILED) {
> +		if ((errno == EOPNOTSUPP) || (errno == EINVAL)) {
> +			ksft_test_result_skip("MAP_DROPPABLE not supported\n");
> +			exit(KSFT_SKIP);
> +		}
> +		ksft_test_result_fail("mmap error: %s\n", strerror(errno));
> +		exit(KSFT_FAIL);
> +	}
>  	memset(alloc, 'A', alloc_size);
>  	for (size_t i = 0; i < alloc_size; i += page_size)
>  		assert(*(uint8_t *)(alloc + i));
> diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
> index d8468451b3a3..e1e355d50e65 100755
> --- a/tools/testing/selftests/mm/run_vmtests.sh
> +++ b/tools/testing/selftests/mm/run_vmtests.sh
> @@ -382,6 +382,7 @@ else
>  fi
>  
>  CATEGORY="mmap" run_test ./map_populate
> +CATEGORY="mmap" run_test ./droppable
>  
>  CATEGORY="mlock" run_test ./mlock-random-test
>  

On my older kernel:

$ ./droppable
TAP version 13
1..1
ok 1 # SKIP MAP_DROPPABLE not supported

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

