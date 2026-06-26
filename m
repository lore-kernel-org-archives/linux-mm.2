Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A6A2C43458
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 14:48:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D6706B008A; Fri, 26 Jun 2026 10:48:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8AD866B0093; Fri, 26 Jun 2026 10:48:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C6776B0095; Fri, 26 Jun 2026 10:48:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4E5CB6B008A
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 10:48:48 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AE9991617B8
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 14:48:47 +0000 (UTC)
X-FDA: 84922345494.24.98FD798
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	by imf22.hostedemail.com (Postfix) with ESMTP id E7F42C000B
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 14:48:45 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AULFV8Br;
	spf=pass (imf22.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782485326;
	b=ey9Ep24kE2e1QXe01yt8rtO8B+kjydU8xFSVZirGzXpfmnT5nC8MI0NCoQpjN4EOwSWlt6
	cMLN3IRw4VKwd+aL3m+MKs2zSOzh+nwa9R+TALmqCt4ycQaYRRE8ftn+dcAeMDzNx4IIVP
	KLb5RUhZgpWaLhyYdPYLN6c80cwMKH4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782485326;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+d/7ra1oyDy8FyFgz7QVlu1h97UzmlQOCBPgAiPibmc=;
	b=ziZo3GeMoDosHiw5XGXDuDZAaffvWCD5JQSy3iwjCnVflwRyqIv2zEJ4ghVhNu8Sjc+06B
	/0tXirvcbAWkAOyE0tKufOxRgS7jgOXS9k9r/0aA25cg65vu9xu6tP0o9hsgyTYaFHvKw+
	tSDXTt0cUptscZU+GEBGZ63AbBTFIa4=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AULFV8Br;
	spf=pass (imf22.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782485323;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+d/7ra1oyDy8FyFgz7QVlu1h97UzmlQOCBPgAiPibmc=;
	b=AULFV8BrKKN5qg0eXAyY3S0T2tsj5sBo1qe/+rhSgEyOxk9IOmvtAZUZSNWFEoOeIp3+7J
	uV28C/FVYwy93EHn91SRI/KiWMilogWBQ1OobydKjwgkM0LhkmLCxXEV2u1wbtqmXx1RP9
	yYiaj/nFzo6K/GXun1dSd3ogpt8KI+E=
From: Usama Arif <usama.arif@linux.dev>
To: Sayali Patil <sayalip@linux.ibm.com>
Cc: Usama Arif <usama.arif@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Shuah Khan <shuah@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	Ritesh Harjani <ritesh.list@gmail.com>,
	David Hildenbrand <david@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Michal Hocko <mhocko@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Dev Jain <dev.jain@arm.com>,
	Liam.Howlett@oracle.com,
	linuxppc-dev@lists.ozlabs.org,
	Miaohe Lin <linmiaohe@huawei.com>,
	Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Subject: Re: [PATCH 1/2] selftests/mm: handle EINVAL when configuring gigantic hugepages
Date: Fri, 26 Jun 2026 07:48:34 -0700
Message-ID: <20260626144835.3759976-1-usama.arif@linux.dev>
In-Reply-To: <8bfa921e30eb94072685103f6496784aa23bb166.1782365671.git.sayalip@linux.ibm.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: dse8heu5s43wd87ktrdwj6tar4trqa53
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E7F42C000B
X-HE-Tag: 1782485325-741436
X-HE-Meta: U2FsdGVkX1+LISIThgw/0Zr3jLYk0gwsIf49LAWCY2EarATytprrsuFZwFG0fm04f58qAwRJpCSkeQyOv9QXXGn6pT2zrTFfvYn8Q6Tm3sHoCvIPCncGbD4nMEgvoSbSbDd6aLv8zeFJvvVnr92ucAKHXQEZzOTkXNRDCxM+n+VdlEC30bYXCsfuRXXV9kSBRZLl8KpqDM+iUam8o8RVnENDQfepTyjVjgDkVDZLcK6U5Po1MjhMbgTLgaklUQgDRrHN9/CEdQmG/jk25le7TvQY7u4SqjP6Smk/JjPLpczhaLtuyv7HxWs4Zm5ulRRwuMtyrU/H/98kTqiyNMmG53g7im8hT9K6fOV1YcQ/ZaLPrZ9U67h+cNGiVKmLEDT2d3BMh3u+6T+Y+p4NAHybTI5P/7SlvcUrZKlRCivKM0i77xunYmoX21O+ySwppkbdtbBkaHbZfkBrKxS2b37yaaCDO4dFGxReu0lNsfIC6quygqhuB+T4BfugqutYGqUYLZhGPEWF/J40y6H9W+XLmHCaiTqd6jl322UvlGtbOG0kvyvHJjre8Afy7wUEm/f1eobsZ9qWw2K6HmXQQ3cS7VLNeSxt6Q+tT1zUvdHUISDcc/Ayhhx3CROA8gwGULRJlWECvpDTyLrpd8NqpeFNoLgB+2Mo6WbB7yi/8nugp/Z1TQ/kknNTSBER8tvrPyHgXfioIezcFWIHJaHP3c7P7xHFlC2gAQycwQD2UX2PP0UbLuufhnSR/4i5wJGudKpi/leoiu3hE8gtjPY9CKdbBEcbeA9JIzIdkslvMNYzIxI+6QRf+7wWUrDVmAsyhHg7uH5JDUtoBE0khnXV1a9ngqr7HRmD6FhXcQvxFPrWiPrZPU+iyd2qjYjcLhhdhGjp/HI3Cp2rKsMI14SmDrFltG6pqRSsBrxRIStpsaAdqv30tPUPf8Y/Npnps/3oAfGcxBZRaO+EqqOhDT7+iyw
 kIEXqZR8
 w4FXyryzzuVJaaL00crGNP5u1U3oY9+VOQJ2J02w8UpS5ygauM4sfmLGtGv57WAZ8Rt9WfEgnwAYNYS2IjsXZoTDjzgjmijvmyzdvIqRv60Huw+sMwlWWlHHhAS7axZzLrXW7z6H8HtKUnO5hy/mdRuKeb2WItAWLw+aqNlmkmydKafAc41MunDF8u3ogWVfPfgibNVpBu+6WtDM9C35+xDLU00/nz8msVi9lka/5n5IhehuE4I6tiY2akyQJVcBVVGSUUI/y+sPuaEHR79fuLRZbrGHEUEVn2EpNxz8ygobgUig=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 25 Jun 2026 18:10:16 +0530 Sayali Patil <sayalip@linux.ibm.com> wrote:

> Some MM selftests attempt to configure the amount of
> HugeTLB pages of different sizes by writing to nr_hugepages.
> 
> PowerPC hash MMU pSeries systems advertise gigantic hugepage sizes 
> but do not support runtime allocation of such pages, writes
> to the corresponding nr_hugepages file fail with -EINVAL.
> This causes the test to bail out even though the failure is due
> to a platform limitation rather than the
> functionality being tested.
> 
> Treat -EINVAL from the sysfs write as a skipped configuration request
> and continue running the test instead of failing.
> 
> Before patch:
>    -------------------------
>    running ./hugetlb-madvise
>    -------------------------
>    TAP version 13
>    1..1
>      [INFO] detected hugetlb page size: 16777216 KiB
>      [INFO] detected hugetlb page size: 16384 KiB
>     ok 1 MADV_DONTNEED and MADV_REMOVE on hugetlb
>     Totals: pass:1 fail:0 xfail:0 xpass:0 skip:0 error:0
>     Bail out! /sys/kernel/mm/hugepages/hugepages-16777216kB/nr_hugepages
>     write(0) failed: Invalid argument
>     Totals: pass:0 fail:0 xfail:0 xpass:0 skip:0 error:0
>     [FAIL]
> 
> After patch:
>    -------------------------
>    running ./hugetlb-madvise
>    -------------------------
>    TAP version 13
>    1..1
>     [INFO] detected hugetlb page size: 16777216 KiB
>     [INFO] detected hugetlb page size: 16384 KiB
>    ok 1 MADV_DONTNEED and MADV_REMOVE on hugetlb
>    Totals: pass:1 fail:0 xfail:0 xpass:0 skip:0 error:0
>    /sys/kernel/mm/hugepages/hugepages-16777216kB/nr_hugepages
>    write(0) failed: Invalid argument
>    [PASS]
> 
> Fixes: 9d07250ea1eb ("selftests/mm: hugepage_settings: add APIs to get and set nr_hugepages")
> Signed-off-by: Sayali Patil <sayalip@linux.ibm.com>
> ---
>  tools/testing/selftests/mm/vm_util.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
> index 311fc5b4513e..a8f16eef5c7c 100644
> --- a/tools/testing/selftests/mm/vm_util.c
> +++ b/tools/testing/selftests/mm/vm_util.c
> @@ -735,6 +735,13 @@ void write_file(const char *path, const char *buf, size_t buflen)
>  	saved_errno = errno;
>  	close(fd);
>  	errno = saved_errno;
> +
> +	if (numwritten < 0 && errno == EINVAL) {
> +		ksft_print_msg("%s write(%.*s) failed: %s\n", path,
> +			       (int)(buflen - 1), buf, strerror(errno));
> +		return;
> +	}
> +
This makes write_file() silently succeed for every EINVAL, not just the
gigantic-hugetlb setup case. Several callers use this helper for writes where
EINVAL is a real test failure, for example drop_caches or split huge page
setup. Those tests can now continue after a failed setup and report misleading
results.

Please keep the common helper strict and ignore EINVAL only in the hugetlb
path that is probing unsupported gigantic page runtime allocation.


>  	if (numwritten < 0)
>  		ksft_exit_fail_msg("%s write(%.*s) failed: %s\n", path, (int)(buflen - 1),
>  				buf, strerror(errno));
> -- 
> 2.52.0
> 
> 

