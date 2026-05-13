Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4CB0ACD37B6
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 09:25:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B849D6B008C; Wed, 13 May 2026 05:25:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B36576B0092; Wed, 13 May 2026 05:25:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A73126B0093; Wed, 13 May 2026 05:25:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9BE3E6B008C
	for <linux-mm@kvack.org>; Wed, 13 May 2026 05:25:42 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4540B1A07CE
	for <linux-mm@kvack.org>; Wed, 13 May 2026 09:25:42 +0000 (UTC)
X-FDA: 84761864124.04.08A814F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 78C77120002
	for <linux-mm@kvack.org>; Wed, 13 May 2026 09:25:40 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="JNJ/sVju";
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778664340;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UnqpVx1lqdeYuFJPpQxBnRbg/JjsR3lvhYppFYAVGCQ=;
	b=fG8jUQlI404+DiJ2PfUe1WQ6y73SsXMIRHgguiVLEcy0YJWL7VGvsYF+7xfNO3ZDkhLdpr
	c+BXTzrO3kR7gqOYkSB7OLaLztCpMjQemxuIsgdiaoDJR79yp85OU4NGp8/Ha9zFwSWhUG
	yUoQn5S10TmARI51NMY5hd4clxqDz4E=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="JNJ/sVju";
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778664340; a=rsa-sha256;
	cv=none;
	b=VjNXmkdFbfHsbx08X1tFdm5qYIiJVVQ88kVdOM58i4qOiPzWJCKHQQQgRt9gh/o9T5IS8p
	Zj+QLh6QgmU73IWtPOZPqQiSE6aZf8ZpHSWBUGd/k8jEB5N9hvqP3boHn2nRL87MaMxjfQ
	NaVVWrj1mV2K44QbPL+Dg8Wio1Kv3YI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 54D7F43E4C;
	Wed, 13 May 2026 09:25:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 821C8C2BCB7;
	Wed, 13 May 2026 09:25:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778664339;
	bh=arxih0bDE+7RIMMJ1ElB/+tYtHu5uDaWxFo/FiWSgHk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JNJ/sVjuY+qBCCj/spXjuhopa6eqywKyu91VKIYkBVaVEbXB0E2HA598AiElBV4YD
	 oFRs3Rryan4aVKqjlH5n++sbj3zU6gsXt34Ut2w74aidSogOdD0LUJ1vbLGst43asT
	 P9rWPcdnNAcX5osE9S5TVIaPMc0kswwxyJuUx50of4g0syRYg86iMqnzKfZykQbCPS
	 ZbZ5dfUCcTUHld0K0olZP+M0aOEQs8rmKnM9016+8JopRbY3oIYF7Khu1uC5XCs9dd
	 3jj3g21JuodgpVNF+AyhavzVaDVFXaajclFt0y4Ra1j2PfjOfr+zgmSJ/1sJHPRQME
	 AshkCw2gcxbvA==
Date: Wed, 13 May 2026 10:25:33 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Hongfu Li <lihongfu@kylinos.cn>
Cc: akpm@linux-foundation.org, david@kernel.org, liam@infradead.org, 
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	shuah@kernel.org, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests/mm: Fix incorrect mmap() error handling with
 NULL instead of MAP_FAILED
Message-ID: <agRDVWDvId9Jx9Q0@lucifer>
References: <20260513025223.592766-1-lihongfu@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260513025223.592766-1-lihongfu@kylinos.cn>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 78C77120002
X-Stat-Signature: uejra8gt8zfb4b7jexz3qyg16hekztgr
X-HE-Tag: 1778664340-75626
X-HE-Meta: U2FsdGVkX1+GwvR33AtiAdwNgh++bthU5sSNitCOw++v0v+EdhkranBMc8gusB2z+p6R/biew3+1D9HyhalsqTiGxaGH35kLMmZg0f4y4EgYZsWV3LzXAFmkobrijPfpp4Hb/XZb7bT267RWBQ2agFZUiEnSJIGJQytvXhTG9zvR4cl7AN1opdTqFdcorTVFIcB5fTuiPN95jfOqqq1uiPb08seBNneYZEhjVgPAGgOP2prXoNfM246lZg8cE6imR/9iie600siSQy7YmDjBR1o6QwPZ+FUmod1Qfysb5Qrqje0kT4YdWk02MKeG0EpspHEIBxgDK07Sa2DJjj3sV64v4p1HPE9AIPyUug2IFRGeIdag5Du2heegvCjWkqtPUGMvsG2mK8Ep6s0GA4wkPoEf0IcZYal42JjabTeH2IMBhmpNwLbFIpXRDC2PdLgTIrD0l70mHa5ulYu5EPQoeR5wNEhzR8P/Ur8AK3MgGr0j4vWDS/U4uLCGJCgK8iavYQaLkq0WkpiIHlDVNgEa41XKOmsHyk2rlefjMzehTecg0p3S61eDuwbmjQ0+SMdYsSY3oQgkXUGCrc+nl4pgTgujAU31gs0qW7xFxo12/4k8Pujm4no3r5iTlyain/gv6StwUJsG4/4NM3Iu7argeQoEnikSeYbuqEa7sHOPIm2ELDrwYgB7WZTh/UiceFjNsIQxZDrAf1gunkva7rL0Cz1O38Q7mdhI1Zx/a558vGSR3X5y/MtqsTk8rL0I5gFD3NAQc8UEU25L2sf0nmtWSLPakxUeT77Y+S0RKgcSFmeOaMhH3peijV4UmrBJhtmZNbLz2kx1ZRoSznNZiyim8vMtBJCtskL5Ywjmk4KmBwLCxHTsxqIld0cWW6PjBbX22R5N8mEdg8Q3sMIc0QCDfhMGMOqOoXDqpMC+FyIouD4r0VjiaD6Tys6ObQQb85Znuu/ZFzGsPfoqq25IXSH
 M33sYTNu
 +IuSSeaNS/zpPNeJ6e351kkTEuwNrhufzjR4YhLvDf6Wt3v0YthZxG9HM2BiTj6icgSaMjgMLXsJsDSRXmTyJ2JpPrqOzNHookFJcQ7ZG8cr8skvkblV2R7h7lCBX6ZhKAxpYSA2kweIN42AqvamLPtMVP6CDltbjuomrjrTCVJh6OtrEKSPEoPa/aR251e5BGp2y8Fj2VBWM5M4nzNhRz691xuaEv6TI7mUPKWga4gVcbyfLrHEM56yHVP17mDKpWzF8pyLozWRIbmrVToJvwiz2H1X5sxY9rtf/6VDcNUqZMjcIleduZZfgxjR0vOzxYmRo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 13, 2026 at 10:52:23AM +0800, Hongfu Li wrote:
> mmap() returns MAP_FAILED, which is defined as (void *)-1, on error,
> not NULL.  Several selftests incorrectly check the return value of
> mmap() using !ptr or ptr == NULL, which would erroneously treat
> MAP_FAILED as a valid pointer since MAP_FAILED is non-zero and
> non-NULL.  This can lead to segfaults when mmap() actually fails
> under memory pressure.
>
> Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>

Ugh how did we end up with all of these :) thanks for the fix, assuming you get
all of the other cases on respin, feel free to attach my tag to that:

Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>

Cheers, Lorenzo

> ---
>  tools/testing/selftests/mm/ksm_tests.c     | 2 +-
>  tools/testing/selftests/mm/madv_populate.c | 2 +-
>  tools/testing/selftests/mm/soft-dirty.c    | 4 ++--
>  tools/testing/selftests/mm/vm_util.c       | 2 +-
>  4 files changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/tools/testing/selftests/mm/ksm_tests.c b/tools/testing/selftests/mm/ksm_tests.c
> index a0b48b839d54..ed481f817282 100644
> --- a/tools/testing/selftests/mm/ksm_tests.c
> +++ b/tools/testing/selftests/mm/ksm_tests.c
> @@ -174,7 +174,7 @@ static void  *allocate_memory(void *ptr, int prot, int mapping, char data, size_
>  {
>  	void *map_ptr = mmap(ptr, map_size, PROT_WRITE, mapping, -1, 0);
>
> -	if (!map_ptr) {
> +	if (map_ptr == MAP_FAILED) {
>  		perror("mmap");
>  		return NULL;
>  	}
> diff --git a/tools/testing/selftests/mm/madv_populate.c b/tools/testing/selftests/mm/madv_populate.c
> index 88050e0f829a..7fce5d0b622b 100644
> --- a/tools/testing/selftests/mm/madv_populate.c
> +++ b/tools/testing/selftests/mm/madv_populate.c
> @@ -34,7 +34,7 @@ static void sense_support(void)
>
>  	addr = mmap(0, pagesize, PROT_READ | PROT_WRITE,
>  		    MAP_ANONYMOUS | MAP_PRIVATE, 0, 0);
> -	if (!addr)
> +	if (addr == MAP_FAILED)
>  		ksft_exit_fail_msg("mmap failed\n");
>
>  	ret = madvise(addr, pagesize, MADV_POPULATE_READ);
> diff --git a/tools/testing/selftests/mm/soft-dirty.c b/tools/testing/selftests/mm/soft-dirty.c
> index bcfcac99b436..67c26c265880 100644
> --- a/tools/testing/selftests/mm/soft-dirty.c
> +++ b/tools/testing/selftests/mm/soft-dirty.c
> @@ -143,7 +143,7 @@ static void test_mprotect(int pagemap_fd, int pagesize, bool anon)
>  	if (anon) {
>  		map = mmap(NULL, pagesize, PROT_READ|PROT_WRITE,
>  			   MAP_ANONYMOUS|MAP_PRIVATE, -1, 0);
> -		if (!map)
> +		if (map == MAP_FAILED)
>  			ksft_exit_fail_msg("anon mmap failed\n");
>  	} else {
>  		test_fd = open(fname, O_RDWR | O_CREAT, 0664);
> @@ -155,7 +155,7 @@ static void test_mprotect(int pagemap_fd, int pagesize, bool anon)
>  		ftruncate(test_fd, pagesize);
>  		map = mmap(NULL, pagesize, PROT_READ|PROT_WRITE,
>  			   MAP_SHARED, test_fd, 0);
> -		if (!map)
> +		if (map == MAP_FAILED)
>  			ksft_exit_fail_msg("file mmap failed\n");
>  	}
>
> diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
> index db94564f4431..63aaa2d9ec0b 100644
> --- a/tools/testing/selftests/mm/vm_util.c
> +++ b/tools/testing/selftests/mm/vm_util.c
> @@ -463,7 +463,7 @@ bool softdirty_supported(void)
>  	/* New mappings are expected to be marked with VM_SOFTDIRTY (sd). */
>  	addr = mmap(0, pagesize, PROT_READ | PROT_WRITE,
>  		    MAP_ANONYMOUS | MAP_PRIVATE, 0, 0);
> -	if (!addr)
> +	if (addr == MAP_FAILED)
>  		ksft_exit_fail_msg("mmap failed\n");
>
>  	supported = check_vmflag(addr, "sd");
> --
> 2.25.1
>

