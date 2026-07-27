Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24E23C531D0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 16:46:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA9CC6B0088; Mon, 27 Jul 2026 12:46:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5A386B008A; Mon, 27 Jul 2026 12:46:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4B5A6B008C; Mon, 27 Jul 2026 12:46:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A95B56B0088
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 12:46:00 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3950EA0057
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 16:46:00 +0000 (UTC)
X-FDA: 85035133680.12.9CCA03E
Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	by imf20.hostedemail.com (Postfix) with ESMTP id 88C911C000A
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 16:45:58 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ODMqdQgX;
	spf=pass (imf20.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785170758;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sXIlDiKSKHoB5funfN0ip0RnphBZYOqvi0Mcm88qhBY=;
	b=ts1ILk2gl7z4q83mMrju6u+KUoFjPbzkcMTNLgBm2GBFCN5iRVimD0fzb4ot2CgT4c/KgP
	Q86+BZjDZAnZe2pSo9NcDbWnbrF25m5iVZvrAacfoBKI7JTMOvzefc34jTURm4w9RlrIUv
	+5GR7ypUaG47Lqnx1SZwQezBivAZLhc=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ODMqdQgX;
	spf=pass (imf20.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785170758;
	b=khLwDFNb0jy+62a17pAxzgN4S8SIyATH8fRCyHFhdodT7LZvPNf6yNEPiH0npjiIT+eZ95
	Imoe7iyXvcO0VcRxVJPMxrMcQEtZutfuV3SS7i6LaOc2JlTv6pn73NekqzBZPXNuJRshia
	WewSoHL9EiafcSR3o5sXgIwPAvYt4vs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785170756;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sXIlDiKSKHoB5funfN0ip0RnphBZYOqvi0Mcm88qhBY=;
	b=ODMqdQgXDPCFb/Co71Ndjhz9dQ/CkLN9N0o+suX1dbw/g5gB0mLmJ6y+a38Gwo88Fqggcm
	qG1UUoTcn3phpNtrr/yVK+1mpXLMOSvcdhLB56AImA/annvY9vMmjJjdiHTTGQ18vOJbpF
	4NjVfU/GWImgnrW/ICGjPEa0kAUiVuk=
From: Usama Arif <usama.arif@linux.dev>
To: Muhammad Usama Anjum <usama.anjum@arm.com>
Cc: Usama Arif <usama.arif@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Sarthak Sharma <sarthak.sharma@arm.com>
Subject: Re: [PATCH v3 1/5] selftests/mm: skip COW tmpfile cases when fallocate() is unsupported
Date: Mon, 27 Jul 2026 09:45:44 -0700
Message-ID: <20260727164545.897052-1-usama.arif@linux.dev>
In-Reply-To: <20260727095225.372655-2-usama.anjum@arm.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 88C911C000A
X-Stat-Signature: 7q8t43obf7ptc6cab3cxcga6rby6bouk
X-HE-Tag: 1785170758-497011
X-HE-Meta: U2FsdGVkX1/P8qGOSUh2Q/InSkjVIHl5zjUaAMXE+tnFc8v2BTFky5CRKKWHoivSnMRNyfLqAWR7t1K4C9tILC8ncPTpWWePD1ORjep+9sgMGaAjkLfKCcvCbQnnsBWnCLNvMbvpv3L9sg+nC1sAbe/9meUIjKHVIc3QIxj0UNo/+mskUKLfEI1uGosmZbQmBD7tjKY0Ieea63aJegvKSU40eJlgCOGUiNZxd9FZAu0X6HYuSASAbfPG7v38JKLAk8kW3eQIo0AH9ufS66KX1zWJ2TUdIOKQi6axaPVH9Ufds/es/Aa5RkwqE/GTH0GDDUzshhrqlhowvzh8YvCfw2eWvd0M8QdmAWgl/687H7XuY8ApBYt6NKy4FV/Hf+qw/bpeqV1stHHeNc4gzxuRHtDISLpuXnVIBqDO0/rJN/zU/NbxDhI3EGvAerjS0JDB4L74dni8hrH/jPQk2+3se9A2e2gWPNZECmHpjBdGJYtUG1scybb6HKlqp9nNmcAhNgYW9CU4YAtOenoa93oDkPYQOxs8ukG1BqtFYENvIUHrt7Y+OQN89bCFVZC8c6PEbiD80FHQG0c4b2GR6Gdf899Qm4ukmE3kDkV7mEczVJcwsnL4XY8iwHWWl/uBGjEHbdIEqc0ithodAMPYQr/Um/afIDcP8BQoUgHAQZ/+p/F8v9qZgeoF+wie/72WTNN6cNqj4t427XQu5HY9LiEFtgGGAs5pbZU4eLrXfANjph4wEoIju067loLaUdwnryMbvDpSZHnDB7/r1xrvPPQrcsyFOMbjEOioVy0F+dzf7yhZvDd7ewO0ZeJm3rybaLo8DgpiHU4ZhvMoscAV6awA45NdfgorEc9DldKGBCERdXhD9/NzTQc2jgfATSolAGqMB4Ff2JF80bb52+X9tVuQ8Oih7iD7BuGtaoxYvEMPRx6vhnhZnjux9yKD2rtxzuZnArxKspp3gApWyDNi9B3
 blG4UxGQ
 xdHluWaTZVucF+cHJwo0voQGC5ckePa6x1cleuvvcKi7r7S/LyKibPv9zVr5gr2YUv4vTfmT0GxAspyxFM97rTzZOeA3YHJqnhel+Lo68gZV7i/Pdidy+jmBqylCZcQbf6CFaROTsQ0rqKWIby1JWMjyPBnl9pbGzgWQ9oQXs6bCVQw9xHnE2Y3t4XeEOvCGwJjd5DXUmizJRs7F/oDJyzBRcZpZThzxrfRW5vynLZtKTeplMtbkN1IxAXEfTyRtMWxaM0neWfnAS3bvuE+rUpWQqodhyqO7lj/EQgvzcESt/B7GzGDnGuZ09tPnWwYjb2cvQIdKGZ5oFDGXUbg9uCMZz0kMF4gENzQNt2N2lo4BYxly3uKykgVe8Bw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 27 Jul 2026 10:52:17 +0100 Muhammad Usama Anjum <usama.anjum@arm.com> wrote:

> The tmpfile-backed COW cases allocate a one-page file with fallocate()
> before exercising private and shared mappings.  When the filesystem
> backing tmpfile() does not implement fallocate(), setup fails with
> EOPNOTSUPP and no COW behavior is exercised.
> 
> This occurs when the temporary directory resides on a filesystem with
> limited allocation support, such as NFSv3.  Reporting a failure adds
> noise because the test prerequisite is absent rather than the COW
> implementation being broken.
> 
> Report EOPNOTSUPP as a skip.  Continue treating every other fallocate()
> error as a failure so unexpected setup regressions remain visible.
> 
> Tested-by: Sarthak Sharma <sarthak.sharma@arm.com>
> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
> ---
>  tools/testing/selftests/mm/cow.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/cow.c b/tools/testing/selftests/mm/cow.c
> index 0c627ea89ff7b..c1b8920e29342 100644
> --- a/tools/testing/selftests/mm/cow.c
> +++ b/tools/testing/selftests/mm/cow.c
> @@ -1718,8 +1718,13 @@ static void run_with_tmpfile(non_anon_test_fn fn, const char *desc)
>  
>  	/* File consists of a single page filled with zeroes. */
>  	if (fallocate(fd, 0, 0, pagesize)) {
> -		ksft_perror("fallocate() failed");
> -		log_test_result(KSFT_FAIL);
> +		if (errno == EOPNOTSUPP) {
> +			ksft_print_msg("fallocate() not supported by filesystem\n");
> +			log_test_result(KSFT_SKIP);
> +		} else {
> +			ksft_perror("fallocate() failed");
> +			log_test_result(KSFT_FAIL);
> +		}


Correctly skips only unsupported fallocate() setup

Acked-by: Usama Arif <usama.arif@linux.dev>

>  		goto close;
>  	}
>  
> -- 
> 2.47.3
> 
> 

