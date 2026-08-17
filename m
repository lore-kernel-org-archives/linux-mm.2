Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D14DAC5B572
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 15:41:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C6EC96B00E8; Mon, 17 Aug 2026 11:41:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1EF66B00EA; Mon, 17 Aug 2026 11:41:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B35496B00EB; Mon, 17 Aug 2026 11:41:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 953166B00E8
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 11:41:38 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 20608C07A1
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 15:41:38 +0000 (UTC)
X-FDA: 85111176276.28.E6AD03B
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf05.hostedemail.com (Postfix) with ESMTP id 1168310000F
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 15:41:35 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=TKkAfWtO;
	spf=pass (imf05.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786981296;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sC0W97nUKZxaOAu6qc0vdKlECkPQL7prScTfXTzltPA=;
	b=MbjUpZGxYomrPxdI0dTkbo3gBJsXLgcmSSGzVMPI8xOnyOEspMLIR1e+bcMNRyL+0ZtG8K
	iDPq+Z+N4hEC6BKZH7vqiZhwYrodarQNa02LYT/dLkqLoNjSxJxjoWGM7kJQRvVUwcV6Y/
	qhtYx2Ov3Y8A3qrRdx9rocfmj0g3tto=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=TKkAfWtO;
	spf=pass (imf05.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786981296;
	b=Ldc6CXsLREgqQZDXXbX5BCvS5rrZ0nH1sAo9pq1i3hWARszqg3qyJTktdP5+dzaw5EKEZ1
	1Rh6OWP0/Z4N4GcKXjf2oxHcpqmC/kCmsIrz/c8ewUqLCuql+IW+pR0O1n7qXJm6dnIUjn
	7r+aJPOkXtKpBLwoj0l933oK+1OXHd8=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2B97F143D;
	Mon, 17 Aug 2026 08:41:31 -0700 (PDT)
Received: from [10.2.198.93] (e142334-100.cambridge.arm.com [10.2.198.93])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 338793F673;
	Mon, 17 Aug 2026 08:41:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1786981295; bh=5HUYy/NWh82f6yiqf+xRP/nWbaerO9LUZNm0SRxGFPk=;
	h=Date:Cc:Subject:To:References:From:In-Reply-To:From;
	b=TKkAfWtOltSWSxnTnHufmUnAl0SRlqrc2Q4b1aKibOPZ/oKswBZyi21DDUAVtYcIR
	 W/dVCtxvdtwwVmh3Oa/owGE1d85PT5YKlvixIzD/iGXnSM5En8Do4TrqRjlFAfdke8
	 73TyWn4NLReSv4KRKR6vlsrJt2nWMet3joi1y6wQ=
Message-ID: <0b88055f-bd9e-48ea-8735-80931e80a9bd@arm.com>
Date: Mon, 17 Aug 2026 16:41:31 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: usama.anjum@arm.com, linux-mm@kvack.org, shuah@kernel.org,
 david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org,
 surenb@google.com, mhocko@suse.com, peterx@redhat.com,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/3] selftests/mm: restore enable_soft_offline in
 hugetlb-soft-offline
To: Song Hu <husong@kylinos.cn>, akpm@linux-foundation.org, rppt@kernel.org,
 sarthak.sharma@arm.com
References: <20260815080716.3596514-1-husong@kylinos.cn>
 <20260815080716.3596514-4-husong@kylinos.cn>
Content-Language: en-US
From: Usama Anjum <usama.anjum@arm.com>
In-Reply-To: <20260815080716.3596514-4-husong@kylinos.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: u47hzkru4jaayt8n86uxkh83wq5djyfn
X-Rspamd-Queue-Id: 1168310000F
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1786981295-609625
X-HE-Meta: U2FsdGVkX1+hoo1FI92pjY5D6UWCnJaXzxQY84WXkDbnF/rjcuhkRTcK2D3shor+NxQZ7bEayENLCdYN06Ede7MsWsHaOxPCjtnb2PigPvJTadIU025RUJnqja4FTaKZy1YyfpQ6/zNWDPiUOIdwUz1G8/fIC4z1nWDAw4PI7DDc457m/XeEVTtIilU2Vx+EKWH8dvkILNql9xX0qsBs2c/BZuh2Zbzb9xaCzV7mUn6NI6lTL6ap4lQ0+VVmq6rev4SCmGNaCDYRe+Jdcpb/0oG8rQPQN4kzXD/KS8SoIm/jhJbNrPHAMA6gEhRx0q6QsXInoP6WEqQfmvcjCp95OhP/SU8tVMkk9h6jIovu5Oz+4iybb+b8NjFFJ13y8VHQzwWecxAT4DopelohRFzbaI4n7HQSrncNpiept02cbid/AHBDHeXWOomiBicqXcPM4vt8FMznIeZiMrOEtdlV27iTCBHJTOlOMLDid5KfwKlJFEzSwiAix1dNGjMpnjVX0jVX2VGzvxhRG2RqNfIDyabQ5gXn+vPwcXbHQwVBmupjo2TM4lDit8aKpWUpMwmJVDmSe4Sku3rnsmyWT6bEIeV8pgdS7oLcTxKtLeOp1PEcFoinxxdcBVLRPldacQDQohUmSjzA95fcnkULfugp9hQo36iaOEbXta8qVXNfmgC2IihouFzKnb+QQB3j+cYGhvtb05gfMmHIMWKfs1cps3lsRa/eArdUmtDMmAawR2dV4RgtpXUzhZOZ6m/EFxtktRCrwcO6HZTXAV9Ql4ZnGNQxnvZHJ9gSkQ4r7X+vDArMb+M6bmaurevjzz4MAESJ099kd4DrfmpKALiSqvun80kR9ba+G4nivKXHcylqc7PmY61uZFzx+Xmy80lRIE4Vp1XdZbL8nETHK9D0Dbg2wTtd3rHkMbpJeBFEGQeGlv58mM905EltN7H+Bx/X5C9jGOSLf3G6TwyuruW1SDy
 wpkb00Bv
 uZlk4uu745uT1mAtbUU6H+zpPbT3PFI4aVQRSt+XWeAEJxc4McJDB17LyNshW/ISq+285izCc/xnr30KxkgPsfoIwlv8UJ52U/RHEudquvt9/KTWw35/e8oaH5AlNWM13mp1RYf4FO58+FzeEUg4tPwXBt3drB/35oRrq/1XgBzLzIHPgCA3TfEzCqvTxs3InDC+5/l66JahGqgFPfdw5z1AaPe9NPWyzthoEBWDnwE4hkq491Phm03ceyoZApgVRuQrtx+ZI6RnrXyD6+StavXTbWJEC1U5iFekZ2AIV6Gj7YyxaVqTZWANwf4gbVAHxLlyqyhbF54BXxtcWiZoEeZ+HGQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 15/08/2026 9:07 am, Song Hu wrote:
> hugetlb-soft-offline toggles /proc/sys/vm/enable_soft_offline between 1
> and 0 (test_soft_offline_common(1) then (0)) and leaves it at 0 when it
> finishes, silently disabling soft offlining for the whole system after
> the run.
> 
> Save the original value before the test and restore it from an atexit()
> handler, so the sysctl is also restored when the test exits early via
> ksft_exit_fail_msg(), as hugepage_restore_settings_atexit() in
> hugepage_settings.c already does.  Use read_num()/write_num() from
> vm_util instead of the hand-rolled popen()/fopen() helpers.
> 
> Signed-off-by: Song Hu <husong@kylinos.cn>
> ---
>  .../selftests/mm/hugetlb-soft-offline.c       | 35 +++++++------------
>  1 file changed, 12 insertions(+), 23 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/hugetlb-soft-offline.c b/tools/testing/selftests/mm/hugetlb-soft-offline.c
> index bc202e4ed2bd..86259921d54c 100644
> --- a/tools/testing/selftests/mm/hugetlb-soft-offline.c
> +++ b/tools/testing/selftests/mm/hugetlb-soft-offline.c
> @@ -23,6 +23,7 @@
>  #include <sys/types.h>
>  
>  #include "kselftest.h"
> +#include "vm_util.h"
>  #include "hugepage_settings.h"
>  
>  #ifndef MADV_SOFT_OFFLINE
> @@ -31,6 +32,8 @@
>  
>  #define EPREFIX " !!! "
>  
> +#define ENABLE_SOFT_OFFLINE_PATH "/proc/sys/vm/enable_soft_offline"
> +
>  static int do_soft_offline(int fd, size_t len, int expect_errno)
>  {
>  	char *filemap = NULL;
> @@ -77,26 +80,12 @@ static int do_soft_offline(int fd, size_t len, int expect_errno)
>  	return ret;
>  }
>  
> -static int set_enable_soft_offline(int value)
> -{
> -	char cmd[256] = {0};
> -	FILE *cmdfile = NULL;
> -
> -	if (value != 0 && value != 1)
> -		return -EINVAL;
> -
> -	sprintf(cmd, "echo %d > /proc/sys/vm/enable_soft_offline", value);
> -	cmdfile = popen(cmd, "r");
> -
> -	if (cmdfile)
> -		ksft_print_msg("enable_soft_offline => %d\n", value);
> -	else {
> -		ksft_perror(EPREFIX "failed to set enable_soft_offline");
> -		return errno;
> -	}
> +static unsigned long orig_enable_soft_offline = -1UL;
>  
> -	pclose(cmdfile);
> -	return 0;
> +static void restore_enable_soft_offline(void)
> +{
> +	if (orig_enable_soft_offline != -1UL)
> +		write_num(ENABLE_SOFT_OFFLINE_PATH, orig_enable_soft_offline);
>  }
>  
>  static int create_hugetlbfs_file(struct statfs *file_stat)
> @@ -145,10 +134,7 @@ static void test_soft_offline_common(int enable_soft_offline)
>  	hugepagesize_kb = file_stat.f_bsize / 1024;
>  	ksft_print_msg("Hugepagesize is %ldkB\n", hugepagesize_kb);
>  
> -	if (set_enable_soft_offline(enable_soft_offline) != 0) {
> -		close(fd);
> -		ksft_exit_fail_msg("Failed to set enable_soft_offline\n");
> -	}
> +	write_num(ENABLE_SOFT_OFFLINE_PATH, enable_soft_offline);
>  
>  	nr_hugepages_before = hugetlb_nr_default_pages();
>  
> @@ -192,6 +178,9 @@ int main(int argc, char **argv)
>  
>  	ksft_set_plan(2);
>  
> +	orig_enable_soft_offline = read_num(ENABLE_SOFT_OFFLINE_PATH);
> +	atexit(restore_enable_soft_offline);
> +

Seems good. Thanks for fixing.

Reviewed-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>

Thanks,
Usama

