Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4FAECCD1BE
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 06:01:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2010D8E000F; Wed, 22 Oct 2025 02:01:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D86C8E0002; Wed, 22 Oct 2025 02:01:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 115AC8E000F; Wed, 22 Oct 2025 02:01:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id F1D718E0002
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 02:01:38 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A6E7111AD2F
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 06:01:38 +0000 (UTC)
X-FDA: 84024703476.11.2EDF64B
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	by imf01.hostedemail.com (Postfix) with ESMTP id B059740018
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 06:01:36 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZGVsJof6;
	spf=pass (imf01.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761112897;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MaKTtydp6I4aIQxhn86P3BAwgNQxEfqBxIOSSlgkBPM=;
	b=akCz3PtezZeC8C99y7v9P3thc6QdNNYfnaiuUQupy8zGPlW8ILBamFgq5ajJOddnDNpHwg
	Sz38ucdTWYlwlfjTF5rso+LzW6elF2Ye8sefBB7TDrZR+yonOJRYIXGyYlZjaPnOBRlbI0
	uqoED+9r0utfKu3S/2rJeCks6VTNviM=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZGVsJof6;
	spf=pass (imf01.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761112897; a=rsa-sha256;
	cv=none;
	b=HmWcewXE/4UsGycn7Je/NPQkt9CA4y2heUmpFwDmo+rrjQXDMHgS1ONCqndT9f2ptC70yg
	IRa5lGSnBO+b4Q7CIUtVy05VDKx5k6fZhfs/j4KjbxNbZcUv2owlw6rAyZwAHslnpf6K0Q
	kXIjbOj6ZfYOej1Kkhv/N/M5vMZPxr0=
Message-ID: <49bfd367-bb7e-4680-a859-d6ac500d1334@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761112894;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MaKTtydp6I4aIQxhn86P3BAwgNQxEfqBxIOSSlgkBPM=;
	b=ZGVsJof6iMjWSHuR5ov4Or/qdDwPisoId8W2V45U1a+S7XD/tZMzr6/JEbVKREB0SP8Puz
	79Y4HFxLemsNK6x1F5k5kdHbjZ/fSUsYBPmDWxA4wWDyZ+pYDs0llCAtpiWe+hgx4HEWKP
	5qEzcEh0okJCRunHxGYLZJbLwuYY1xQ=
Date: Wed, 22 Oct 2025 14:01:26 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 6.1.y] selftests/mm: Move default_huge_page_size to
 vm_util.c
Content-Language: en-US
To: stable@vger.kernel.org, gregkh@linuxfoundation.org
Cc: akpm@linux-foundation.org, david@redhat.com, lorenzo.stoakes@oracle.com,
 shuah@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Leon Hwang <leon.hwang@linux.dev>
References: <20251022055138.375042-1-leon.hwang@linux.dev>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20251022055138.375042-1-leon.hwang@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: B059740018
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: k9fjieqaf31jk7q41kgbo5zsewd3uej5
X-HE-Tag: 1761112896-529772
X-HE-Meta: U2FsdGVkX1/YpRLxnjItpVMzokALJh59F6p3V8J1k2b71VAKFs7Aj/DDBP55CqOLbJmJHWNXFX2bYMvJWw5lNWR1JPO43tmftTsKiWAxbth/k8tlFekBFJPGQ0FnD3+xHniOv5kMtLE/N8gP+0bPMlEyZ6ARm3ZzRpyulzGLAP62CplqdhPPHBGZAlGNS9TwYrVVNiEDTM+BraWfc+TYJHpj0HtMOFODMtdHkekXkCeE9DMmJi330wIi3Q9fsmdxGMYZMaN8xqeLv+xK/aEhcVz2MKnQT6PzEpoaOo1SSxwO6SKRmQhzcMr8p5/yLN0nhNCNtO36/5Q2scNZLUDsPINuBKFE3uu+eKk0XYxqyaxK7XBIRKaQmJApNspsnE5n2fFqlAMJwQ4c9JqOba6FdS3SlbL/9+qdgRl4zsDggEKUJJk59cZDrucg9k3HisqyLZKHq4j+MekbOd3dap7Kc4VJ0bRg/HfihSReA8abecwleJH0LvDr2m9LidSyM8QmIDuUE1/s+jjJdA/3ZtKZvnoLk0Gg3XrtbumoJr0tgj/M1aC2MLnjl9pYL25vBDziXIIeBHxgZOL3pqQBQ/ND8XxCTMqBQUdx1El2JRgyCom/Wk94wuG41NIZMWZbDk90Umg/OBluoedkBegDZie4z1gVH/h4nfIsx05H7SfGNQsrqvfHmWCfpAKV8pGLs9+wrrBM5k45C1V6DodYmU9ShY7Z9h8dUxG/njIs1vP2h8XrOgvKXJYtTlZ0ssDve5geEYVAgtB+hEsDiGMra8pQ7eagVJ85VXLuvXyDB2h+tJvo9g6XlI58JEMK83aFU84aV2zR2rAJMZasfxtQZ0sOD3b/xbbD8Pv2nopn5PD0H1oSfGUdFassiHOuC5X85RKwdeCCNXQbcncAUEtp0sqkURmAqkhWDGTjgT/e2kQEhZRzwAGU/lAQ8UCanTj7zLn7ju54+8oX1C8e7ZQOpXv
 QT/EpzAG
 fhZJ9Sx8jsNq49ou/neKoBEqsalmTlQh/2gDhovn/1e/wN29fFcIb+FFdtQ5CojFdU6z5/lBn+mAUw5C0NDxPlP6fcm/AClwLNqXnFMDkU02Wvsn5TsPgdzmrk6j4JfFucxMnDaef3CRbNN6S1Ua6dZfv75ezNUISCdREQr4oJtsXUmvmuBNkSo8XDSKS6n7QMjCjwEpDCjvQiDqhYswL3wr9Y0psUEEaEBUAWyUnZ5zcLmKEv7n+DvCNuyK/BqCV4swT
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+Cc: Greg

On 2025/10/22 13:51, Leon Hwang wrote:
> Fix the build error:
> 
> map_hugetlb.c: In function 'main':
> map_hugetlb.c:79:25: warning: implicit declaration of function 'default_huge_page_size' [-Wimplicit-function-declaration]
>     79 |         hugepage_size = default_huge_page_size();
>        |                         ^~~~~~~~~~~~~~~~~~~~~~
> /usr/bin/ld: /tmp/ccYOogvJ.o: in function 'main':
> map_hugetlb.c:(.text+0x114): undefined reference to 'default_huge_page_size'
> 
> According to the latest selftests, 'default_huge_page_size' has been
> moved to 'vm_util.c'. So fix the error by the same way.
> 
> Reviewed-by: Lance Yang <lance.yang@linux.dev>
> Signed-off-by: Leon Hwang <leon.hwang@linux.dev>
> ---
>   tools/testing/selftests/vm/Makefile      |  1 +
>   tools/testing/selftests/vm/userfaultfd.c | 24 ------------------------
>   tools/testing/selftests/vm/vm_util.c     | 21 +++++++++++++++++++++
>   tools/testing/selftests/vm/vm_util.h     |  1 +
>   4 files changed, 23 insertions(+), 24 deletions(-)
> 
> diff --git a/tools/testing/selftests/vm/Makefile b/tools/testing/selftests/vm/Makefile
> index 192ea3725c5c..ed90deebef0d 100644
> --- a/tools/testing/selftests/vm/Makefile
> +++ b/tools/testing/selftests/vm/Makefile
> @@ -100,6 +100,7 @@ $(OUTPUT)/madv_populate: vm_util.c
>   $(OUTPUT)/soft-dirty: vm_util.c
>   $(OUTPUT)/split_huge_page_test: vm_util.c
>   $(OUTPUT)/userfaultfd: vm_util.c
> +$(OUTPUT)/map_hugetlb: vm_util.c
>   
>   ifeq ($(MACHINE),x86_64)
>   BINARIES_32 := $(patsubst %,$(OUTPUT)/%,$(BINARIES_32))
> diff --git a/tools/testing/selftests/vm/userfaultfd.c b/tools/testing/selftests/vm/userfaultfd.c
> index 297f250c1d95..4751b28eba18 100644
> --- a/tools/testing/selftests/vm/userfaultfd.c
> +++ b/tools/testing/selftests/vm/userfaultfd.c
> @@ -1674,30 +1674,6 @@ static int userfaultfd_stress(void)
>   		|| userfaultfd_events_test() || userfaultfd_minor_test();
>   }
>   
> -/*
> - * Copied from mlock2-tests.c
> - */
> -unsigned long default_huge_page_size(void)
> -{
> -	unsigned long hps = 0;
> -	char *line = NULL;
> -	size_t linelen = 0;
> -	FILE *f = fopen("/proc/meminfo", "r");
> -
> -	if (!f)
> -		return 0;
> -	while (getline(&line, &linelen, f) > 0) {
> -		if (sscanf(line, "Hugepagesize:       %lu kB", &hps) == 1) {
> -			hps <<= 10;
> -			break;
> -		}
> -	}
> -
> -	free(line);
> -	fclose(f);
> -	return hps;
> -}
> -
>   static void set_test_type(const char *type)
>   {
>   	if (!strcmp(type, "anon")) {
> diff --git a/tools/testing/selftests/vm/vm_util.c b/tools/testing/selftests/vm/vm_util.c
> index fc5743bc1283..613cc61602c9 100644
> --- a/tools/testing/selftests/vm/vm_util.c
> +++ b/tools/testing/selftests/vm/vm_util.c
> @@ -161,6 +161,27 @@ bool check_huge_shmem(void *addr, int nr_hpages, uint64_t hpage_size)
>   	return __check_huge(addr, "ShmemPmdMapped:", nr_hpages, hpage_size);
>   }
>   
> +unsigned long default_huge_page_size(void)
> +{
> +	unsigned long hps = 0;
> +	char *line = NULL;
> +	size_t linelen = 0;
> +	FILE *f = fopen("/proc/meminfo", "r");
> +
> +	if (!f)
> +		return 0;
> +	while (getline(&line, &linelen, f) > 0) {
> +		if (sscanf(line, "Hugepagesize:       %lu kB", &hps) == 1) {
> +			hps <<= 10;
> +			break;
> +		}
> +	}
> +
> +	free(line);
> +	fclose(f);
> +	return hps;
> +}
> +
>   static bool check_vmflag(void *addr, const char *flag)
>   {
>   	char buffer[MAX_LINE_LENGTH];
> diff --git a/tools/testing/selftests/vm/vm_util.h b/tools/testing/selftests/vm/vm_util.h
> index 470f85fe9594..a4439db0d6f8 100644
> --- a/tools/testing/selftests/vm/vm_util.h
> +++ b/tools/testing/selftests/vm/vm_util.h
> @@ -11,4 +11,5 @@ uint64_t read_pmd_pagesize(void);
>   bool check_huge_anon(void *addr, int nr_hpages, uint64_t hpage_size);
>   bool check_huge_file(void *addr, int nr_hpages, uint64_t hpage_size);
>   bool check_huge_shmem(void *addr, int nr_hpages, uint64_t hpage_size);
> +unsigned long default_huge_page_size(void);
>   bool softdirty_supported(void);


