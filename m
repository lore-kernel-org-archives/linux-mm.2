Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5CF5ECD484C
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 04:27:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 77C7B6B008C; Wed, 13 May 2026 00:27:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 754006B0092; Wed, 13 May 2026 00:27:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 690A86B0093; Wed, 13 May 2026 00:27:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 596C76B008C
	for <linux-mm@kvack.org>; Wed, 13 May 2026 00:27:45 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DBF6C140702
	for <linux-mm@kvack.org>; Wed, 13 May 2026 04:27:44 +0000 (UTC)
X-FDA: 84761113248.29.08600AF
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf25.hostedemail.com (Postfix) with ESMTP id B035FA0003
	for <linux-mm@kvack.org>; Wed, 13 May 2026 04:27:42 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=MisppLS7;
	spf=pass (imf25.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778646463;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9TsxMIn8lTrZGEVlpYWJV13+Gt4X61ANAU56rELQj5w=;
	b=7ZvXRxVCRSU7K3IIzzBKDadFXXvOMBVbGhCDI+6svu5Xrwq9zH5YojsxIPdfKEpDDP67Qj
	uzsZgo4Cbh2L8zVXht8WBp0wE/UYxdJM8fi1Rw9uTuTdq6PYfrvG5xbwmJPrt3gTUu04dQ
	DV8qrG7JnGCiT0INomW/q13aZLkM/uo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778646463; a=rsa-sha256;
	cv=none;
	b=WSFsSa1E27OVisHePLiM4ht9sZB29nw6cwxBu35bz3LCIBb0w6VObEqMRgPJIdOVkLWfgl
	qxD2Xza5eW8kO1LDkB2UkiDnHamEjlxftvXCpZPAalXWvWpmkn4RCGt5N6MVp1NHuo1Y5K
	C7ISgvanfEdHVB7OSGk1uNjPvUPInZE=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=MisppLS7;
	spf=pass (imf25.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 34DD9175D;
	Tue, 12 May 2026 21:27:36 -0700 (PDT)
Received: from [10.164.148.43] (MacBook-Pro.blr.arm.com [10.164.148.43])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 160763F7B4;
	Tue, 12 May 2026 21:27:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1778646461; bh=exUFgKkNOkgX3YbRJeprGMKAC+3rhwrdVrR7Yx6ey4E=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=MisppLS7KSQE6vaB5iWyhqRQsWvqws7p6GFbzW+ZqOvt/9JO13Z5DsRmJCDGP/aiH
	 Jv6aCL2jgu+FrSxLuE/vDcGWk9c5VGW9ejelVN12ErUz3QCVGaoekVw2R2OvDIBC8U
	 0kdtyL6lQvRQ7ZlTXTJ/MME/jdUPvE7Y/kP8qHzA=
Message-ID: <04203abd-b729-40cf-87e4-186b12c17298@arm.com>
Date: Wed, 13 May 2026 09:57:27 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests/mm: Fix incorrect mmap() error handling with
 NULL instead of MAP_FAILED
To: Hongfu Li <lihongfu@kylinos.cn>, akpm@linux-foundation.org,
 david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, shuah@kernel.org
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260513025223.592766-1-lihongfu@kylinos.cn>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20260513025223.592766-1-lihongfu@kylinos.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B035FA0003
X-Stat-Signature: 7d4y7id15dn5ku7ir85osrhwzgu48yw1
X-Rspam-User: 
X-HE-Tag: 1778646462-619789
X-HE-Meta: U2FsdGVkX19CuZGqtYRDApJaPKzWFmDmYHhkyZpfn1VY0Yuz4sK7R6E2+iMuoakn2K9gO1bk17cboYae2vZylxYEM6K8NdZUUeoGZWWZVQoT68fHAfvivRhDqZh6KVoQ1pVsHJB9AM62Um2EctNCLIktgWb/szHh3n5DiuUv76U/JVhXu+4V38Eya3pcbZL/fWjcWaxV5QQBqB/c7Wu/VWqehe3IpB7IIKUI1ukHhV/fPvRKM24+edJrWAfKUBlPrRgFMlBDrLPElu2LIzN7FuZWu4JmJpp6/WoBOcqa5JevNQNIcSFgrYwkNoi5c5T6D86BjDwpuo5Z37z6MPqhJZ4l4UWZzF8j9l21x69uYDiflAmNjI3/C0fs9sk+h6FtW/rO1wP9+J5AuPfoogxJjVVHq4hf7oEaQm4IdOINycVvqvlvPZug/GARSFEeCE87IZy2ELVsYX25R0KMxT8xxPH+xcp1v/5PL7lKO8vgKSDjaOxVhNOim5RZmGm/bJS4cnBWxZXJd9dGrXj6J/Hk7WoyAbKkMnfeg9e/m/93cQBhGrwj0Ag9IcVxDWVvSC+kJLxUv/U3GfhsRKk4o8IGEpqNLnPcX8g1eg41WRyU97DmY0jgajPLZ9voqs8qXGuuQVH/dh+MvpHDT/zCKkB2rDXa9jP92exyKxkglSzqIJQe8AQiDg6V1aMZOMdNj2Yo83WROozAAe9Z7Sm5+fBtfWQGh30H8ec7PFgO1ywQUBno58szZIgsw6pI4INcwW1PO8iT55+RoErnhjIXF/eqgwW/gFGj2/DuKa1/13FTYmDXRJKcixQW4IUybqoXYloh/qq/vqH12qf1fvoqB/rZ4Bhu91tFP6qadN4lHRZO7Ir4OqLE/JN5QPDVoLmdeE/+Chi332XwNk2kXmK8FDTpU/whzGdVUH+XT5gTbs2H4XYQgF6bsyeA+DkX9PzMyNsnPqKYGHUbzLs5+Z95G3V
 +yGGwbrp
 m2X0/EDc+0SidtVBggCKRT6wnzdN29iCO3qCs8LuYwjcKhxN0IemAVR2cONxEZz96y/Yy3yBZqJWOjk9h6hDlYt19QX/B5FtddIvNRW8ouLGOkYJwfYamGQbhMq9G59omobRIsvCuKHiDTAxJX6GGvT0oGMPZYWIw8pjiQiGAELgbwpFtHrN9lodPMNlu7i/a0jnw6SV9/MOOafQvalKTFsUG48ZOZBtUw4W3FZmeuyRWuZNL6TlnXrwknq9+ETOolp9HXaTfvgRd82fw9f0XMcHwRiRmvK3uzpVjDWB/QA3/kbcHzPCxsfOb/99jeVTkFLrOYtq99FlmAFUxhHTAjiSiwQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 13/05/26 8:22 am, Hongfu Li wrote:
> mmap() returns MAP_FAILED, which is defined as (void *)-1, on error,
> not NULL.  Several selftests incorrectly check the return value of
> mmap() using !ptr or ptr == NULL, which would erroneously treat
> MAP_FAILED as a valid pointer since MAP_FAILED is non-zero and
> non-NULL.  This can lead to segfaults when mmap() actually fails
> under memory pressure.
> 
> Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>

Hopefully you have fixed all instances in selftests/mm :)

Reviewed-by: Dev Jain <dev.jain@arm.com>

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


