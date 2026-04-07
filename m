Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69865EDB7D4
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 09:43:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE7B36B008A; Tue,  7 Apr 2026 05:43:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C97686B008C; Tue,  7 Apr 2026 05:43:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B86EF6B0092; Tue,  7 Apr 2026 05:43:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9F8896B008A
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 05:43:44 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4FAEBC2601
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 09:43:44 +0000 (UTC)
X-FDA: 84631272768.21.5374CAD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 801FB1A0006
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 09:43:42 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=u211mTq6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775555022; a=rsa-sha256;
	cv=none;
	b=NtKOCA7unAhhx8gO6UPoUwqMx9n1eLjQ8uB+ehaot4FnoI9u9L9yuT5RPFp5b/C4Bex1SK
	ceo0vD4NDwvpdqz6vnvYraP0fdISAKr2lGL6bulz8oEpxYMZGrE2YgWdn5cfY7EAqxLXBd
	zEAiar+h0U4DhBjmVcEtwDY82Hx8Vgw=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=u211mTq6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775555022;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ccPaUVosaysI/9L3c9MAwJRD6nsxAIfmGysZ2xx0HYI=;
	b=5PMTUePgs/TpGLBOpC2FbdrkawP1D03TJqa7UKXorvyZqpOPT2g/BK7d8IO6Hix07ycq5A
	N7sDGrQQw2EU1aIMp2V0ONHhzsKfWsHs46s30H0pFzKpkxLMzeuFh4MVCbaF2xaelwfNuQ
	YvPHd6nOI3t2ubjFthVhgEhc+LXUfZ0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9EE65409A8;
	Tue,  7 Apr 2026 09:43:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 994F5C116C6;
	Tue,  7 Apr 2026 09:43:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775555021;
	bh=5swpGJLLM7ocCgxAbPQMvQ1UNSary/VO1SavUaPUMLc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=u211mTq69k4LSK6Rv7+fzWLZarJSqC5osrmVd+KLmbKe0cqzDhF590TmZkeAYvqab
	 12wT5CjAmXhYY/iV2g+MwMRlRv29TmixuVaIaOfDncXkmtapNVZ9G5a5OAGS7XIdOK
	 69gs4/uM53bYVm/eSOYymWH0HEHLB2+HSEup6y+rNLZyeWMOQxrSpLjPWT4vFUoPOC
	 iFR83Cvy82FXSqaFrRnMC6wzPxqaC9b7mFxdComnDGfSbOV9dWt/rOxqoFKNfIv6ll
	 w1841iIYmd3amDMp+gdzvQgI+e4zYmZO/LiR7E1axsYOvTfy4ARLvKT8l+10VocDv/
	 ZmeB/6eKaZaPg==
Date: Tue, 7 Apr 2026 10:43:37 +0100
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: xu.xin16@zte.com.cn
Cc: hughd@google.com, akpm@linux-foundation.org, david@kernel.org, 
	michel@lespinasse.org, chengming.zhou@linux.dev, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org
Subject: Re: ksm: add mremap selftests for ksm_rmap_walk
Message-ID: <adTRADN09XjTB57n@lucifer>
References: <20260407140805858ViqJKFhfmYSfq0FynsaEY@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260407140805858ViqJKFhfmYSfq0FynsaEY@zte.com.cn>
X-Rspamd-Queue-Id: 801FB1A0006
X-Stat-Signature: oais8jnczs3cidnrykabkgn5sc3wg1wr
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1775555022-213418
X-HE-Meta: U2FsdGVkX19z2BOjRmtXyPcYO2+oCVNr69oIs2sLy76AEMoN0eLvljBXGrE80iHAjspsDIQqukcH6Gk+xmx348osvV4JgjVdeedikFHYWY4vYmDNFAPjEV2c9TsY9dcYvir1WFXBdMUy4Z7n6fP51D0G4N4EeeMxwe3V+70h53nnSUFU0ISh+f497F2xSrksWcz4CHbbojElU7SnwrPOrcfzAC0vjsyMlqYgZp2AIdmbsRaddZnwjxLMKyMVvQEa6ZCpU+cb+5Wyn45nCxwllsNpcBLLyOBcTu8HYW6UjHKEFGF3FbKfligEbMGhD/55mWzvsAAfs98UrNVGd1ksDToagu4HY8mptw9akygxyfZzDm+Uc03uzFpmtXryNP8jzkQBhgOpHBFtYYOzAErkn9Ln8b8nVBEmUc3BemoroWT9+CdZ8/u6QqCn4KAyZ+2fhiW0I++MPRAIG90J6jjv07EKccvpmltfluiRQTbZLpsB5FpmGj33TSV2roqiPN4I9qSEMzgg0rKAbDvDgw5jJLBahK+ZdQrWzpMJrNtGXthIS9f7hUNwkaVfRmaorihdOldnrNXbZ6+tM9CzRH8MEpWCAdf2bvOu7XOTDWV1pQNixt+CHPKT37NzHuvvMm3IHkBUXpCEQNZTJQj6ODCBmh/t8qH+dE2Qhjsea5k+cRHuUqjVN+Yt2EFQpt0bDbLnlBqjtv+a/njLaScoM3H3WdkDwihW7KTz6ynV/3oIFLMQ/GUTEpOut5sRwvJN+0nlyNM2eFpJYsY3yo3Su7/2vWeNkIIqYkr3L19JXMYlU7rMfB4Vil/Iqrs5+ZkjDo/zXLLjghGBkTCV+vWg97HjGFLbeisWQmRqv9Fwrvm8+O8/hnyz71ujv4DM5eQh0YvMrFMeNifXto+n6vdeQKQcbk9w/h1J40O05mYTEThJ6d7nXkXQd+BhHpsz6C4+6vlb7722iVl4mF4FO1X1pH6
 y//3LUR8
 1i+/nhcmL8KjQAVSDbQHkLePsBcGpEJr/JbXUuxVqSrfSUdIzMVHvZlOB5iXfwjxkyth+P1s40I52UOwHVtX9y13WRlIaW22zR31wJp00y9tC2+x0NBN+Zqh5TE70mepaeKK/Z21q05S5gA0POtfMkuY/ITdMLckDQuwamB6zI8dCagqjspD3J7HYFkclgllxN5CgWtlwqHpdLQWj0psW6o8exuSuLMe7SUoN3VDheXYh+JmP813qAtTQifJEPm8YgzTrI2e+HvouRMjCxdfQI5oZeHu2rYAhfbBv1gMJzrhxy3YWBLDGBpBavDDfr2pyG0Pk7/IpuC1al2ySO0jqQxUwQnUlsRLFOd/cIe0DTAhmv2y9CmNRO6JPGVRJFXIPMwcb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 07, 2026 at 02:08:05PM +0800, xu.xin16@zte.com.cn wrote:
> From: xu xin <xu.xin16@zte.com.cn>
>
> The existing tools/testing/selftests/mm/rmap.c has already one testcase
> for ksm_rmap_walk in TEST_F(migrate, ksm), which takes use of migration
> of page from one NUMA node to another NUMA node. However, it just lacks
> the senario of mremapped VMAs.
>
> Before migrating, we add the calling of mremap() to address mapped with KSM
> pages, which is specailly to test a optimization which is introduced by this
> patch ("ksm: Optimize rmap_walk_ksm by passing a suitable address range")
> https://lore.kernel.org/all/20260212193045556CbzCX8p9gDu73tQ2nvHEI@zte.com.cn/
>
> Result:
> TAP version 13
> 1..5
> ok 1 migrate.anon
> ok 2 migrate.shm
> ok 3 migrate.file # SKIP Failed in worker
> ok 4 migrate.ksm
> ok 5 migrate.ksm_and_mremap
>
> Signed-off-by: xu xin <xu.xin16@zte.com.cn>

Thanks for this, tests are always good, but I think we should bundle this in the
same series as with the rmap_walk_ksm optimisation, assuming we can be sure
whatever-form-of-that-we-end-up-with is ok.

I currently share Hugh's doubts as to correctness, so let's put the two together
I think.

Cheers, Lorenzo

> ---
>  tools/testing/selftests/mm/rmap.c    | 69 ++++++++++++++++++++++++++++
>  tools/testing/selftests/mm/vm_util.c | 38 +++++++++++++++
>  tools/testing/selftests/mm/vm_util.h |  2 +
>  3 files changed, 109 insertions(+)
>
> diff --git a/tools/testing/selftests/mm/rmap.c b/tools/testing/selftests/mm/rmap.c
> index 53f2058b0ef2..65470def2bf1 100644
> --- a/tools/testing/selftests/mm/rmap.c
> +++ b/tools/testing/selftests/mm/rmap.c
> @@ -430,4 +430,73 @@ TEST_F(migrate, ksm)
>  	propagate_children(_metadata, data);
>  }
>
> +/* To test if ksm page can be migrated when it's mremapped */
> +int merge_mremap_and_migrate(struct global_data *data)
> +{
> +	int ret = 0;
> +	/* Allocate range and set the same data */
> +	data->mapsize = 3*getpagesize();
> +	data->region = mmap(NULL, data->mapsize, PROT_READ|PROT_WRITE,
> +			   MAP_PRIVATE|MAP_ANON, -1, 0);
> +	if (data->region == MAP_FAILED)
> +		ksft_exit_fail_perror("mmap failed");
> +
> +	memset(data->region, 0x77, data->mapsize);
> +
> +	if (ksm_start() < 0)
> +		return FAIL_ON_CHECK;
> +
> +	/* 1  2 expected */
> +	ksft_print_msg("Shared: %ld (1 expected) Sharing: %ld (2 expected)\n",
> +		ksm_get_pages_shared(), ksm_get_pages_sharing());
> +
> +	/*
> +	 * Mremap the second pagesize address range into the third pagesize
> +	 * address.
> +	 */
> +	data->region = mremap(data->region + getpagesize(), getpagesize(), getpagesize(),
> +			 MREMAP_MAYMOVE|MREMAP_FIXED, data->region + 2*getpagesize());
> +
> +	if (data->region == MAP_FAILED)
> +		return FAIL_ON_CHECK;
> +
> +	/* Check if we can migrate this region successfully */
> +	ret = try_to_move_page(data->region);
> +	if (ret != 0)
> +		return ret;
> +
> +	/* Wait ksm scan two turns at least */
> +	if (ksm_start() < 0)
> +		return FAIL_ON_CHECK;
> +
> +	/* 1  1 expected */
> +	ksft_print_msg("Shared: %ld (1 expected) Sharing: %ld (1 expected)\n",
> +		ksm_get_pages_shared(), ksm_get_pages_sharing());
> +
> +	return 0;
> +}
> +
> +TEST_F(migrate, ksm_and_mremap)
> +{
> +	int ret;
> +	struct global_data *data = &self->data;
> +
> +	/* prepare KSM interface setting */
> +	if (ksm_stop() < 0)
> +		SKIP(return, "accessing \"/sys/kernel/mm/ksm/run\") failed");
> +	if (ksm_get_full_scans() < 0)
> +		SKIP(return, "accessing \"/sys/kernel/mm/ksm/full_scan\") failed");
> +
> +	ret = prctl(PR_SET_MEMORY_MERGE, 1, 0, 0, 0);
> +	if (ret < 0 && errno == EINVAL)
> +		SKIP(return, "PR_SET_MEMORY_MERGE not supported");
> +	else if (ret)
> +		ksft_exit_fail_perror("PR_SET_MEMORY_MERGE=1 failed");
> +
> +	/* Start to merge same pages and mremap one of the three page area,
> +	 * and test if ksm page can be migrated when it's mremapped */
> +	ASSERT_EQ(merge_mremap_and_migrate(data), 0);
> +}
> +
> +
>  TEST_HARNESS_MAIN
> diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
> index 9428f4d7bf55..47402b771ef8 100644
> --- a/tools/testing/selftests/mm/vm_util.c
> +++ b/tools/testing/selftests/mm/vm_util.c
> @@ -646,6 +646,44 @@ long ksm_get_self_merging_pages(void)
>  	return strtol(buf, NULL, 10);
>  }
>
> +long ksm_get_pages_shared(void)
> +{
> +	int ksm_pages_shared_fd;
> +	char buf[10];
> +	ssize_t ret;
> +
> +	ksm_pages_shared_fd = open("/sys/kernel/mm/ksm/pages_shared", O_RDONLY);
> +	if (ksm_pages_shared_fd < 0)
> +		return -errno;
> +
> +	ret = pread(ksm_pages_shared_fd, buf, sizeof(buf) - 1, 0);
> +	close(ksm_pages_shared_fd);
> +	if (ret <= 0)
> +		return -errno;
> +	buf[ret] = 0;
> +
> +	return strtol(buf, NULL, 10);
> +}
> +
> +long ksm_get_pages_sharing(void)
> +{
> +	int ksm_pages_sharing_fd;
> +	char buf[10];
> +	ssize_t ret;
> +
> +	ksm_pages_sharing_fd = open("/sys/kernel/mm/ksm/pages_sharing", O_RDONLY);
> +	if (ksm_pages_sharing_fd < 0)
> +		return -errno;
> +
> +	ret = pread(ksm_pages_sharing_fd, buf, sizeof(buf) - 1, 0);
> +	close(ksm_pages_sharing_fd);
> +	if (ret <= 0)
> +		return -errno;
> +	buf[ret] = 0;
> +
> +	return strtol(buf, NULL, 10);
> +}
> +
>  long ksm_get_full_scans(void)
>  {
>  	int ksm_full_scans_fd;
> diff --git a/tools/testing/selftests/mm/vm_util.h b/tools/testing/selftests/mm/vm_util.h
> index e9c4e24769c1..b0dd190f83e4 100644
> --- a/tools/testing/selftests/mm/vm_util.h
> +++ b/tools/testing/selftests/mm/vm_util.h
> @@ -151,6 +151,8 @@ void *sys_mremap(void *old_address, unsigned long old_size,
>
>  long ksm_get_self_zero_pages(void);
>  long ksm_get_self_merging_pages(void);
> +long ksm_get_pages_shared(void);
> +long ksm_get_pages_sharing(void);
>  long ksm_get_full_scans(void);
>  int ksm_use_zero_pages(void);
>  int ksm_start(void);
> --
> 2.25.1

