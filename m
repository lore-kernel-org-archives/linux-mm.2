Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4666610BA431
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 07:08:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE3E06B00C1; Fri, 27 Mar 2026 03:08:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A94AA6B00C3; Fri, 27 Mar 2026 03:08:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D1B76B00C4; Fri, 27 Mar 2026 03:08:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8C7236B00C1
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 03:08:58 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2EDD3C2EC1
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 07:08:58 +0000 (UTC)
X-FDA: 84590965956.06.564E933
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 97FAB20004
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 07:08:56 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="HbFM/nt2";
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774595336;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4GVrB64im5tQNuGMyzimbPoBWD79l8M1pQ8WQDHNJiM=;
	b=hXW5s7Gd0sgM9+u7FYUdZ9lkG6y7B0ne7yy038nbBrKlUotU3t/b7/0eje08wJJ6bD89Co
	C6o/l3KIkvDyirElXa2SDJWqXfTm7SC8AWAMUHntgtmXNPBQq7XeuH9VP/DuWtGdIXYUKN
	M7IOLUq235MfcaIOfgM+/ngYgfefvIg=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="HbFM/nt2";
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774595336; a=rsa-sha256;
	cv=none;
	b=BBmiKSerHHAuTI+YolB3TG8PrkhNQwSiLzsDvV34uYmxvywt+vOYB+yGzZDBKlzqYRWe+w
	YKjx45gkegTnVXfkfAycotueyc2MjAR4qyaEQijmiClYVxUzo0Vf6c8SHvw5vj6Puu0TZI
	Bd+z0UUUUV61T9qQrXH66iRJLkdtAHc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E363C6132F;
	Fri, 27 Mar 2026 07:08:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89E83C19424;
	Fri, 27 Mar 2026 07:08:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774595335;
	bh=HUUMzFtQd95LWuOLKItXity1Tg4z0VrPVxPr5dhpgss=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HbFM/nt2fcqw/rKPWsd2t1mhCyK2TqUqQUAHVFbe8GiwCTIMg0uPfcHg0T1i3D1ZX
	 s9AxmNOnxBNhDa2CLdvKRfUPR6EHAodTdvO+w/pBVW9cLyUyh4FSFiOHPpnCHp+YNf
	 +0iyExEAo+kDQgaWKsnEK0IleBpUKRWXO/OUBnXMnYR1SopujjauNQO/F4MgqNzFg0
	 pVsc+0dfOnTL7UF4E3zgUOK54DSFYmg7jv4eWpVyr6l5ofx+mhpvg2RCKjCfpAMxYB
	 mGKc9VFqyvg+CrD7Deb2pyQsRk/RvTpfAIWLRwvS6JoQwrkPwR2t2czzzmd1tfr9Zn
	 7/M/kwh+y461w==
Date: Fri, 27 Mar 2026 10:08:47 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Li Wang <liwang@redhat.com>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
	Liam.Howlett@oracle.com, vbabka@kernel.org, surenb@google.com,
	mhocko@suse.com, shuah@kernel.org, aubaker@redhat.com,
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests/mm: skip hugetlb_dio tests when DIO alignment
 is incompatible
Message-ID: <acYs_-UOv72cmO-P@kernel.org>
References: <20260327031243.15903-1-liwang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260327031243.15903-1-liwang@redhat.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 97FAB20004
X-Stat-Signature: tmf7bpbi1biwbkon68p8pj6u6t3pguxf
X-Rspamd-Server: rspam06
X-HE-Tag: 1774595336-262110
X-HE-Meta: U2FsdGVkX18x1mgN/5nCEVHq1T0RSr0aAXYj9UEduDoTSPumfCn2uQ6Oigq+Xh7I9lzBwvyvzlX/DF1zxRO/yoHAQws8/TBNjqRsXPW6fDqLJFLn87174M0Kn3lMrjx+5doI74EBgEhCtpdcJXlPcoSXqzEaZEL81r7g/V2vjVeGmb9uH06dhnwIF/ZfcBbGhDBoVJYAfdpInHuOWaXNzIysvqrzs7ZFmXllY8aNfzVmLpXy5HHcpziJrAcWUvzUUxk1dDh2bzAFA3JbmY0kN6HlO9/7bVKkLgBHTwKvW0Ihp0vKei1KPw4i4wyyBEMKloU31P+WA1kxjyCdrx8lEmGKD6c4AmB66QN1a8P0qTJWkIfono3P/VTvzfXyZx17qn4XTDZd2OeS79AiObiUL+dTeSaj8ZYOxVqex/5txV1fvMCXSzovT1st6sXZoF6lelZwJCXp5xvMKQ/8CPYUSCWK9kEqbTyPEaclLaOg3npyUYvpTuPIUmoI82kxliYLKUCaiba/6omYTfi4JXgFKTYxVnLUTKMT0wb8wEwfTwlcRmAR6SQXz1Idxen2O8UpNFfMU/m54zpOHLqPcS5auhvvx13udtsQ/9d3tC2nXgQzaY3W+J3EOgoY9YuutkB9ns5Jnq2COYIxItmCoNn8LLXXP1PPW38gO7eao0qqgqg0g5mD6gxO299+qsuTjbtjBap3tYkwXfAKwCJSz7dvjpc7Lkn+1n9/dYF/0dVL2p201ocSskjJzx79jHnXlyzRursD09vhVVyhehy6DoxAI9z2aiBYr3ehgwad6tByVwB9V4h7wM5cz0qB74eMjpKmSTWZYPrXngZzUxtF7dcjj0RSfuw1p+7s/bnM8IB+oG9czZyId1c1HvPGlWWmsM14KbDkGfhWUitv/g4leq//0HnoHtUcE+alTK/epQEl6jEBhxS2a/NiV6m16WMNttK8wFVrKtFveg7o/fgyubx
 Q+lkePTH
 CRx0kXergpbu9LksneWpwEsgy/74AQNXW3uC1JHE7CbCUX9NMFxQbX4S/SaU9etZISFPPrj32jNJRnqtKmZHCbYF67S3QUzD1Z1u4FQJO4ebxjbxf2goWwBI4exkox6YJx61k6tdFJMpVfNY6lzXo35fXzWuq6gkA6Uct8wfKo9dO2QecHslEOUAeIX0MSzOSz9BYkEO7/BYzepyFpPjx3nh/rkuIx1rgYTEzfQNT9G1YVaxciEAE2xQi1Mjsb5d8GSQenGL5qOcaEfaIdVhMlpKyXsyMiMctPqG/IxcimlNF1SDiNyzXA4Web9B/cNVu979LfKnInItpDEU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 27, 2026 at 11:12:43AM +0800, Li Wang wrote:
> hugetlb_dio test uses sub-page offsets (pagesize / 2) to verify that
> hugepages used as DIO user buffers are correctly unpinned at completion.
> 
> However, on filesystems with a logical block size larger than half the
> page size (e.g., 4K-sector block devices), these unaligned DIO writes
> are rejected with -EINVAL, causing the test to fail unexpectedly.
> 
> Add check_dio_alignment() which queries the filesystem's DIO alignment
> requirement via statx(STATX_DIOALIGN) and skips the test early if the
> sub-page offset used by the test is not compatible with the alignment
> constraint.
> 
> === Reproduce Steps ===
> 
>   # dd if=/dev/zero of=/tmp/test.img bs=1M count=512
>   # losetup --sector-size 4096 /dev/loop0 /tmp/test.img
>   # mkfs.xfs /dev/loop0
>   # mkdir -p /mnt/dio_test
>   # mount /dev/loop0 /mnt/dio_test
> 
>   // Modify test to open /mnt/dio_test and rebuild it:
>   -       fd = open("/tmp", O_TMPFILE | O_RDWR | O_DIRECT, 0664);
>   +       fd = open("/mnt/dio_test", O_TMPFILE | O_RDWR | O_DIRECT, 0664);
> 
>   # getconf PAGESIZE
>   4096
> 
>   # echo 100 >/proc/sys/vm/nr_hugepages
> 
>   # ./hugetlb_dio
>   TAP version 13
>   1..4
>   # No. Free pages before allocation : 100
>   # No. Free pages after munmap : 100
>   ok 1 free huge pages from 0-12288
>   Bail out! Error writing to file
>   : Invalid argument (22)
>   # Planned tests != run tests (4 != 1)
>   # Totals: pass:1 fail:0 xfail:0 xpass:0 skip:0 error:0
> 
> Signed-off-by: Li Wang <liwang@redhat.com>
> ---
>  tools/testing/selftests/mm/hugetlb_dio.c | 37 +++++++++++++++++-------
>  1 file changed, 27 insertions(+), 10 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/hugetlb_dio.c b/tools/testing/selftests/mm/hugetlb_dio.c
> index 9ac62eb4c97d..afcca50d190e 100644
> --- a/tools/testing/selftests/mm/hugetlb_dio.c
> +++ b/tools/testing/selftests/mm/hugetlb_dio.c
> @@ -20,6 +20,31 @@
>  #include "vm_util.h"
>  #include "kselftest.h"
>  
> +#ifndef STATX_DIOALIGN
> +#define STATX_DIOALIGN		0x00002000U
> +#endif
> +
> +void check_dio_alignment(size_t pagesize)
> +{
> +	int fd;
> +	struct statx stx;
> +	unsigned int dio_align = 1;
> +
> +	fd = open("/tmp", O_TMPFILE | O_RDWR, 0664);
> +	if (fd < 0)
> +		ksft_exit_skip("Unable to allocate file: %s\n", strerror(errno));
> +
> +	if (statx(fd, "", AT_EMPTY_PATH, STATX_DIOALIGN, &stx) == 0 &&
> +				(stx.stx_mask & STATX_DIOALIGN))
> +		dio_align = stx.stx_dio_offset_align;
> +
> +	close(fd);
> +
> +	if ((pagesize / 2) % dio_align != 0)
> +		ksft_exit_skip("DIO alignment (%u) incompatible with sub-page offset %lu\n",
> +				dio_align, pagesize / 2);

This also needlessly skips the test with aligned offsets.

I'd suggest detecting dio_align here, passing it to run_dio_using_hugetlb()
and moving the check that skips a test there.

> +}
> +
>  void run_dio_using_hugetlb(unsigned int start_off, unsigned int end_off)
>  {
>  	int fd;

-- 
Sincerely yours,
Mike.

