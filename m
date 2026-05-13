Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 475F3CD4F39
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 10:58:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 272036B0092; Wed, 13 May 2026 06:58:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F1ADD6B0093; Wed, 13 May 2026 06:58:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D388A6B0095; Wed, 13 May 2026 06:58:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B5C906B0092
	for <linux-mm@kvack.org>; Wed, 13 May 2026 06:58:08 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7F4291607F2
	for <linux-mm@kvack.org>; Wed, 13 May 2026 10:58:08 +0000 (UTC)
X-FDA: 84762097056.30.12D6743
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id B513914000B
	for <linux-mm@kvack.org>; Wed, 13 May 2026 10:58:06 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QIschZxi;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778669886;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HN8k+G8SEPqmSZlJeBk6PqvNln+hOLSlw9rY57j36KQ=;
	b=GB3bABW/d5POqGHWhU6ZMHlo1HH/cJUTdR2U+n5XJ0zc/O9ra7OTHCNVCACSfJhP4aRpmN
	L8nqIMutQquKwdaMZYDWMKJ+2mVFi7LvfVgttQpkDUBrztPdTo21PO3zVv59FXRuTEeUML
	jIQ0EiCF9CSpFeFe27Zmc8H2pxTN/Qg=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QIschZxi;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778669886; a=rsa-sha256;
	cv=none;
	b=TNVYNva2ySo1h4lbbLWdNf8EzWB6XxJbyLHhZLYRuXDJQzq8w864X5rsnWuvoj5gfrtxIP
	XOq6Rtbnirq3ctOUERH6V0lpQEIS3F/bz/vlUmou1s+AwiqC6spJwCPws//Nx7lD3WBnL5
	k4jHmlxh/DA+m5KViU0v+JFsV1KdGq0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 80E8F40497;
	Wed, 13 May 2026 10:58:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 783EEC2BCC7;
	Wed, 13 May 2026 10:58:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778669885;
	bh=8dhOi+LcaAZswGzRl4JIrjmJt8FqOC6s0xrrgcCEoI4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QIschZxiNsmY8s0D03sHvQp9kqpVbF1FRYyVa/C7nS2E0/uCwWfbBDvO+sCnilM5k
	 /K3wBIuosK1gk9aviKsftT+26UqXjZyf3voiAAR4Ld1606I2fwyoVZyNZBU4nO+gmx
	 qNRFhh5qkmteIhtO0lMdR9Ts2GktfnxDWtWZHM6n6LaRmg5oXlS0EvFZKEPSFbQXCU
	 fDItq2cZJjr7vabuQcAEVpjxb8CsWipZLPlu1913MCiaG6Uj31rNpHtaUFw2AuN7P8
	 3KtEOtnV0Ih/0abPYHTW+Jq5gUwg1kDD1IbYJ9NhSSzVLo7hMyzkkZohvT8thj6evq
	 sO8kPAISOzhHQ==
Date: Wed, 13 May 2026 11:57:59 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Hongfu Li <lihongfu@kylinos.cn>
Cc: akpm@linux-foundation.org, david@kernel.org, liam@infradead.org, 
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	shuah@kernel.org, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Dev Jain <dev.jain@arm.com>
Subject: Re: [PATCH v2] selftests/mm: Fix incorrect mmap() error handling
 with NULL instead of MAP_FAILED
Message-ID: <agRX7BXxuv-VWqN4@lucifer>
References: <20260513095609.789935-1-lihongfu@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260513095609.789935-1-lihongfu@kylinos.cn>
X-Stat-Signature: zz5kad8yux6ix68e5a9ftd14x7mpo63i
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B513914000B
X-Rspam-User: 
X-HE-Tag: 1778669886-776731
X-HE-Meta: U2FsdGVkX18TpkxBzBjXYI+qkQ05AUx3JwZk0/Ea8fnpdrWWe+HgrdfK+MLO8Ibf/ZuueKM/hsEXB9eYzQC8d/a9wEKSNaujyM81B2L9nDa5gyheGTJOilYsCZcK7oyQz23k3g6U05f+n2cvzLkxCnhha7wTUwFVeApB9xFYf0TzwKUerJPo3Z7Ed8Sab8fF1v1elalGCnCXBPfeDgs184WbsQb7rIUwF4wHZRrfxOpFa0piCZo++5NCYAgGIvsoaE+9EvWzf0iM6F/vZ6OvRdoGSx2Wa4fT6wUBCDA0HmlFJu5HVGCOfcbMI28N70UXUrw6omiOe20gTM+Wx3JSQyFkZ+JrNpEIswhBlpL7xg4OuJOlWgJkbkMjeAgVEsVRC9Vobp6daUKo4+WjzHgNpRLTMO56zPQaGCa6d5pdrA9MYSWdquCGPgLK4tg65+jUdAWz9HxCDsrxlT8BLF5MwPeUvgkkS3Pfa6zaDChjjIqWlgL6PTkDq+xgz2kMxtxHs4n8b91bxPTX2PgQCuLbDI5oUSnxWyNvLlF/zgG8sx/FGmbtVleAIW/6DI7JrHZLzjluVt46ooWVwLH1gMAvRhzYxMt5VStKQwTMWmE3hKN89AKRq31i3tTsWR0fLhcBJI9qTU8MOH1R/ThG08YA1ASNJrRr3Q3EZYauu3mt1VRmDRi++UoZXX5XSk+1AaTz2oDWEJTIPrCjMQkIrWMWJrHHDpRDctmjTXormi3Z2Dt895JEqm019YDsaWTUnxXmUHXaPw+C2Xwz2IJ0x+kOT3ZpbnB4uHbEJMS5QFuZU3xA/CP+BT6cTdMUqRoGHzi0Fo0FGmQ6++tj3sNT/XGeeH7+f7IhCy5JfPuSC+Bs6c5nzA0AqVXc3yjzUdU6HDgFqqVEUyv4E9/TQuPLN8DoAOLRKRWHMnt+jJ59YSTveOD10Eg2o21kj/ShyUpJsMxXf37BwuPEm33By+5TeTa
 hnscTYGz
 dSjtWsUAEdSybq3ZLk3zM13AOSPPqcjPamUhbINhPJAJrzGLT7R9ozBUFJmOrlnVnt9zx83VszOYl6XaMs2Y40Rwl8OyvH0wS3K2cNxjtCvVrAn/rt4hqiMsyj5bRGzPNBK1aJx4MaZASg4wxUJ4f7QLCKQWw2q/KoHdmAq1YqSUqDCFQpDua3bqxGE4CwGRfubyqnkqJwAtcWY56Jn3jvwT00498h7JCxfGvrRANxJne5Hq83pQxuJ8Wv7lwzV99w/svfUqBlihQx4NMuTSmHUdsgsL6iD8u2oVjl+6sBcgLZ+LxzuopFJCY6lY9hn9eM5vUpOTv3qbgNd02QokvhJ3L3tgNavg/+mC4oxXrBl3VPhE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 13, 2026 at 05:56:09PM +0800, Hongfu Li wrote:
> mmap() returns MAP_FAILED, which is defined as (void *)-1, on error,
> not NULL.  Several selftests incorrectly check the return value of
> mmap() using !ptr or ptr == NULL, which would erroneously treat
> MAP_FAILED as a valid pointer since MAP_FAILED is non-zero and
> non-NULL.  This can lead to segfaults when mmap() actually fails
> under memory pressure.
>
> Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
> Reviewed-by: Dev Jain <dev.jain@arm.com>

You forgot my tag :)

Also, please do not send a respin right away if you can, multiple revisions in
one day can be tricky to deal with.

As per David's points - please update the commit message to reflect the fact
you've added a missing assert too and replace the (void *)-1 with MAP_FAILED.

Cheers, Lorenzo

> ---
> v2:
> - Add missing mmap() return value checks in pkey_sighandler_tests.c
>   and protection_keys.c
> ---
>  tools/testing/selftests/mm/ksm_tests.c             | 2 +-
>  tools/testing/selftests/mm/madv_populate.c         | 2 +-
>  tools/testing/selftests/mm/pkey_sighandler_tests.c | 2 ++
>  tools/testing/selftests/mm/protection_keys.c       | 1 +
>  tools/testing/selftests/mm/soft-dirty.c            | 4 ++--
>  tools/testing/selftests/mm/vm_util.c               | 2 +-
>  6 files changed, 8 insertions(+), 5 deletions(-)
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
> diff --git a/tools/testing/selftests/mm/pkey_sighandler_tests.c b/tools/testing/selftests/mm/pkey_sighandler_tests.c
> index 302fef54049c..4637809192f9 100644
> --- a/tools/testing/selftests/mm/pkey_sighandler_tests.c
> +++ b/tools/testing/selftests/mm/pkey_sighandler_tests.c
> @@ -317,6 +317,7 @@ static void test_sigsegv_handler_with_different_pkey_for_stack(void)
>  	/* Set up alternate signal stack that will use the default MPK */
>  	sigstack.ss_sp = mmap(0, STACK_SIZE, PROT_READ | PROT_WRITE,
>  			      MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
> +	assert(sigstack.ss_sp != MAP_FAILED);
>  	sigstack.ss_flags = 0;
>  	sigstack.ss_size = STACK_SIZE;
>
> @@ -490,6 +491,7 @@ static void test_pkru_sigreturn(void)
>  	/* Set up alternate signal stack that will use the default MPK */
>  	sigstack.ss_sp = mmap(0, STACK_SIZE, PROT_READ | PROT_WRITE,
>  			      MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
> +	assert(sigstack.ss_sp != MAP_FAILED);
>  	sigstack.ss_flags = 0;
>  	sigstack.ss_size = STACK_SIZE;
>
> diff --git a/tools/testing/selftests/mm/protection_keys.c b/tools/testing/selftests/mm/protection_keys.c
> index 2085982dba69..580bf1668c71 100644
> --- a/tools/testing/selftests/mm/protection_keys.c
> +++ b/tools/testing/selftests/mm/protection_keys.c
> @@ -1217,6 +1217,7 @@ static void arch_force_pkey_reg_init(void)
>  	 * doing the XSAVE size enumeration dance.
>  	 */
>  	buf = mmap(NULL, 1*MB, PROT_READ|PROT_WRITE, MAP_ANONYMOUS|MAP_PRIVATE, -1, 0);
> +	pkey_assert(buf != (void *)-1);

Should use MAP_FAILED here as David pointed out.

>
>  	/* These __builtins require compiling with -mxsave */
>
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

