Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00E28C5DF94
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 09:07:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E6976B0092; Tue, 25 Aug 2026 05:07:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BD7C6B0095; Tue, 25 Aug 2026 05:07:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D3B16B0096; Tue, 25 Aug 2026 05:07:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D24BF6B0092
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 05:07:14 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EA635C0338
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 09:07:13 +0000 (UTC)
X-FDA: 85139212746.12.B5068F3
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf19.hostedemail.com (Postfix) with ESMTP id 04F171A0005
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 09:07:10 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	spf=pass (imf19.hostedemail.com: domain of husong@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=husong@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787648831;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VPCYwSKEnocgo0jUThTKdCwd+oW7ZFsXCiJahNQh6lg=;
	b=idHnxkLd9KH8tDF407eeU/h5yJIVV6ENTBtMfZ+rWGhjApvfbAqPZEMVnSwiJZB3A++Y+z
	ktpHx/pNJfbSCXxfTROWd/OB6CccB9LKMVBFgd++vI0BDRvmFgJWE8sJKb6r+tMeoHOIcP
	bXjhNLpr3OkdV8+OveCSPawMF0IK8sU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787648831;
	b=W0akYRP4Tt3KeuSp/K08zfGt3sl8ZTspHS1FglwdPmhAo7nKaNXnj0McSBVSC1XKnaHdhI
	WkmMicwcWLM9aAAJ+/Q94VO5DyWsL2KXSUwEH6ao22gtcfXzcna4TAxJsfWcXHun36vkCl
	iQNUlQo41q2ENWg00qkYESSIsrbiwiI=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	spf=pass (imf19.hostedemail.com: domain of husong@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=husong@kylinos.cn;
	dmarc=none
X-UUID: 558d86e4a06411f19a56ed5b684f684d-20260825
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NO_NAME, HR_CTE_8B, HR_CTT_TXT
	HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME, HR_MAILER_MTBG
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_PRE_RE, HR_SJ_WS, HR_TO_COUNT
	HR_TO_DOMAIN_COUNT, HR_TO_NO_NAME, IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED
	SA_TRUSTED, SA_EXISTED, SN_TRUSTED, SN_EXISTED, SPF_NOPASS
	DKIM_NOPASS, DMARC_NOPASS, CIE_BAD, CIE_GOOD, CIE_GOOD_SPF
	GTI_FG_BS, GTI_RG_INFO, GTI_C_BU, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:a0246a80-7c1f-4f19-9786-b97f08eff61a,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:10
X-CID-INFO: VERSION:1.3.19,REQID:a0246a80-7c1f-4f19-9786-b97f08eff61a,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:10
X-CID-META: VersionHash:7db8b62,CLOUDID:04f5cfed6c8dd4bf6997e68066818437,BulkI
	D:260825170706LUVBJ45N,BulkQuantity:0,SF:17|19|38|64|66|78|80|81|82|83|102
	|127|841|865|898,TC:nil,Content:0|15|52,EDM:-3,IP:-2,URL:0,File:nil,RT:nil
	,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,B
	RR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 558d86e4a06411f19a56ed5b684f684d-20260825
X-User: husong@kylinos.cn
Received: from [192.168.110.173] [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <husong@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_128_GCM_SHA256 128/128)
	with ESMTP id 341956731; Tue, 25 Aug 2026 17:07:01 +0800
Message-ID: <30a72651-c95d-450e-b344-90c504f70c11@kylinos.cn>
Date: Tue, 25 Aug 2026 17:06:47 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: husong@kylinos.cn, linux-mm@kvack.org, shuah@kernel.org,
 david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, peterx@redhat.com,
 sarthak.sharma@arm.com, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 3/3] selftests/mm: restore enable_soft_offline in
 hugetlb-soft-offline
To: akpm@linux-foundation.org, usama.anjum@arm.com
References: <20260825085756.63030-1-husong@kylinos.cn>
 <20260825085756.63030-4-husong@kylinos.cn>
From: Song Hu <husong@kylinos.cn>
In-Reply-To: <20260825085756.63030-4-husong@kylinos.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: ihk6hrb9hoxn8i5m4xhw3d7zidkzgaqy
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 04F171A0005
X-HE-Tag: 1787648830-530887
X-HE-Meta: U2FsdGVkX19mtSb6wTK9z7sRg2t+whXiRNTM/2BcEsNBCzcoIcFwIfzO0zC8QzaEe9wj+0WbHrLS+BzqIw/IRfS+vPzgZav97pte6ip7xsDhrGTZXmDQvF72iz/Gia9f84efZrLdQjCnP0KU8yC0M+qNiTUckbL2Bg6EQ1A5XNw4VPFM8Ql833C/Qn/LxVuY8xrHFBwnV9Vg7x8lmW0hCINDOfessygq4ABZI0Uf48prYqnhutA8PMhQ7gATEDud2sOc78hPDRagTtOprTdMtwpuzynRTXSg+XomlEb6blfStnBXhm0oLbK6IKyv83Hngv9EK4hGnF6GoglLGzCknj+hs8HspnDqJZL6Ft2Xg9NXn2Qvk7c/EopF/Iah5aFcm7bAb9e5x/HeEs7pgFzTeyNDBsAeaH9aqC1YJG+fgoqpakb1EFIC6fDU+LemPwb5fNNj2adrWwBy5EYVmlqxYpR5aZEtAn12m0Qm1sOJBf97p8n0nBH7R8EhFfFzX6AGS1nSmp1I1wSnosI+8+SOT4sKp8iLfwKPHDf2QL0ybamuFi0nHn6KB0E4Md1p3yzfUMrLp31QedpDF/p9nTZeQU0ekZ8bh+MkKwhv+RK0ldPxD9jh46ugZkZFsy/oxun+6xkdcI9nHfCZoV66Zwg4jRXOUlYp1d+jW7VShAe/7yY/RRFfu+7/YcWZFvJcNsIgsY/W036WeiagDY5BrnrDPsQBtnBfGlZCZ4Mzp670GTE9oHvMqXEMyXHr1iwhJYn+LjWrFyzryynpHt+7pioK1ucGyNVRPucEYcCUrkuw65XH77ApnWmZiAlvc9maCiEQP7AoXtPFuUL92igzKjXh4dEHBytDRmWNIWmHq2DUfxgztJ4e9aQcoLIm5XNZ5c+AamgulOSdSHepatrEtdSsiyTNSsoUjn0EIcGHNq6kUbbgPqaqYjjANJYy1GuSfZtHSD+1XFFC7UXFv04HKEf
 3ksb2IhY
 5Hq6K/7hB0kr+WxFQTp+B++VKMLeO+xIQTH8QeJePLtDTKNzYR3+NmMuVfz0o4pCSLon/pu68nGHFcPwIDlm+snpTi4gmjdH/Ul5gVomLt3R7kgoMjQDp0B3+U85YpxM6XSCE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Usama,

在 2026/8/25 16:57, Song Hu 写道:
> hugetlb-soft-offline toggles /proc/sys/vm/enable_soft_offline between 1
> and 0 (test_soft_offline_common(1) then (0)) and leaves it at 0 when it
> finishes, silently disabling soft offlining for the whole system after
> the run.
> 
> Save the original value before the test and restore it from an
> atexit() handler, as hugepage_restore_settings_atexit() in
> hugepage_settings.c already does.  Use read_num()/write_num() from
> vm_util instead of hand-rolled popen()/fopen() helpers.
> 
> The restore handler must not call write_num(): on failure it
> re-enters exit() through ksft_exit_fail_msg(), which is undefined
> behavior from inside an atexit handler.  A non-root run hits it
> directly - the restore write fails the same way the write that
> triggered the exit did.  Restore with plain open()/write(), best
> effort.
> 

Just a note on patch 3/3: v4 changed the restore handler, so your
Reviewed-by/Tested-by no longer apply and were dropped.

write_num() calls ksft_exit_fail_msg() on failure, which re-enters
exit() from inside the atexit handler - undefined behavior that a
non-root run hits directly.  v4 restores with plain open()/write()
instead.  Verified on 7.2.0-rc7-next-20260810: 2/2 pass and the sysctl
is restored afterwards.

Would you mind taking another look when you have time?

Thanks,
Song

> Signed-off-by: Song Hu <husong@kylinos.cn>
> 
> ---
> 
> Changes since v3: the restore handler no longer uses write_num(),
> whose failure path calls exit() from inside an atexit handler -
> undefined behavior on a non-root run.  Restore with plain
> open()/write(), best effort.
> 
>  .../selftests/mm/hugetlb-soft-offline.c       | 49 +++++++++++--------
>  1 file changed, 28 insertions(+), 21 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/hugetlb-soft-offline.c b/tools/testing/selftests/mm/hugetlb-soft-offline.c
> index bc202e4ed2bd..4af9d3db7b5b 100644
> --- a/tools/testing/selftests/mm/hugetlb-soft-offline.c
> +++ b/tools/testing/selftests/mm/hugetlb-soft-offline.c
> @@ -11,6 +11,7 @@
>  
>  #define _GNU_SOURCE
>  #include <errno.h>
> +#include <fcntl.h>
>  #include <stdlib.h>
>  #include <stdio.h>
>  #include <string.h>
> @@ -23,6 +24,7 @@
>  #include <sys/types.h>
>  
>  #include "kselftest.h"
> +#include "vm_util.h"
>  #include "hugepage_settings.h"
>  
>  #ifndef MADV_SOFT_OFFLINE
> @@ -31,6 +33,8 @@
>  
>  #define EPREFIX " !!! "
>  
> +#define ENABLE_SOFT_OFFLINE_PATH "/proc/sys/vm/enable_soft_offline"
> +
>  static int do_soft_offline(int fd, size_t len, int expect_errno)
>  {
>  	char *filemap = NULL;
> @@ -77,26 +81,29 @@ static int do_soft_offline(int fd, size_t len, int expect_errno)
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
> +static unsigned long orig_enable_soft_offline = -1UL;
>  
> -	sprintf(cmd, "echo %d > /proc/sys/vm/enable_soft_offline", value);
> -	cmdfile = popen(cmd, "r");
> +/*
> + * Runs from an atexit handler, so it must not call anything that
> + * exits on failure: write_num() would re-enter exit() through
> + * ksft_exit_fail_msg().
> + */
> +static void restore_enable_soft_offline(void)
> +{
> +	char buf[24];
> +	int fd, len;
>  
> -	if (cmdfile)
> -		ksft_print_msg("enable_soft_offline => %d\n", value);
> -	else {
> -		ksft_perror(EPREFIX "failed to set enable_soft_offline");
> -		return errno;
> -	}
> +	if (orig_enable_soft_offline == -1UL)
> +		return;
>  
> -	pclose(cmdfile);
> -	return 0;
> +	len = snprintf(buf, sizeof(buf), "%lu", orig_enable_soft_offline);
> +	fd = open(ENABLE_SOFT_OFFLINE_PATH, O_WRONLY);
> +	if (fd < 0)
> +		return;
> +	if (write(fd, buf, len) != len)
> +		ksft_print_msg("failed to restore enable_soft_offline: %s\n",
> +			       strerror(errno));
> +	close(fd);
>  }
>  
>  static int create_hugetlbfs_file(struct statfs *file_stat)
> @@ -145,10 +152,7 @@ static void test_soft_offline_common(int enable_soft_offline)
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
> @@ -192,6 +196,9 @@ int main(int argc, char **argv)
>  
>  	ksft_set_plan(2);
>  
> +	orig_enable_soft_offline = read_num(ENABLE_SOFT_OFFLINE_PATH);
> +	atexit(restore_enable_soft_offline);
> +
>  	test_soft_offline_common(1);
>  	test_soft_offline_common(0);
>  


