Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F251EDB7F6
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 10:56:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F28D86B0089; Tue,  7 Apr 2026 06:56:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EDE2F6B008A; Tue,  7 Apr 2026 06:56:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DEE5E6B008C; Tue,  7 Apr 2026 06:56:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CD1BA6B0089
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 06:56:04 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 797471A0790
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 10:56:04 +0000 (UTC)
X-FDA: 84631455048.05.06A407E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id E6E951A0003
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 10:56:02 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KYYWJjGi;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775559362;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zx5AkL619C8PV1LTmKiv7HxZ9M02DRHDm9MsjuWNIBc=;
	b=qw0vHvpaDOI0kje89CSakt1/o1QJevsV8Nwk/TLJPgYZ/O0LBPrFF+NVLhU9lM9sTmmps1
	zTwpK6F2ctnFi1bB4Olh90n4PGMb2c9gHCaKJI2YEJ632j0HrRWMcGrEgdADS/CPwWzOT8
	+EDqp7KbGER8bVGsaa2YH5kwZ6XTHsE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775559362; a=rsa-sha256;
	cv=none;
	b=Q98KeytZE9wZ4VSzWQoqVAhXrx8n9kbOMShp4uuqJAJZXiOCKdmDyNp8iANcQ97eFQUtfo
	8lI7XbRmKBa0uxrKshx4Zwhp+tyz297+O1VMrG5pBuQ/pBp/OyciljfRgLebmlbWuX5uN7
	7o96xr7iZUmrITo5tw/rMt3kXIOrOj0=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KYYWJjGi;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5AB0F60123;
	Tue,  7 Apr 2026 10:56:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7A9EC19421;
	Tue,  7 Apr 2026 10:55:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775559362;
	bh=7eP72GPIaGqb2qB7drr1QkaZ5cY1w6u3s7kVHeENo8Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KYYWJjGiP1IhaBTL9bzl4SUN0sICrsu2ysruF90aeyyhhHe091gB5ZizvbYp3LnLL
	 UjV4PdcbPG/Yr4eLiZktqgjNm24coo+DahqxifQ4t+Rb1l9hKzKNrur/thllz/1sX/
	 EOmZrClBvNoKSNFXdklaXlH6RIEe7cSV0vMTAp9EG+wF9HEQCrOJC4tsOOS/uYbrmX
	 3NlIrnlJPcRM0kRhEX0ouAl0e/Oqo7IwwhrOqWjP5D9h6j7CGNprtoeRlRRJ+igLI4
	 UdS1Sg4V19ERBRCmUui27c8SbCKk/aQtkmAqDMXfP+OgL7zEbNbl+uzu10PNLlvLBd
	 7KKk2s4p4MxhA==
Date: Tue, 7 Apr 2026 11:55:55 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Chunyu Hu <chuhu@redhat.com>
Cc: akpm@linux-foundation.org, david@kernel.org, shuah@kernel.org, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, 
	surenb@google.com, mhocko@suse.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com, 
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, 
	lance.yang@linux.dev
Subject: Re: [PATCH v8 4/6] selftests/mm/vm_util: robust write_file()
Message-ID: <adTiRbjdoTjfWKeM@lucifer>
References: <20260402014543.1671131-1-chuhu@redhat.com>
 <20260402014543.1671131-5-chuhu@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260402014543.1671131-5-chuhu@redhat.com>
X-Rspamd-Queue-Id: E6E951A0003
X-Stat-Signature: nnhbqawroktid7cqd1po6ctr1mqapzke
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775559362-367203
X-HE-Meta: U2FsdGVkX1/ymahz+TT9NFzsOu089y8tUKhUlUwHI82fX0jeXIOgdpcRnRLLhTf5/wScg0e79fMkcLk7bFFdaCgbx0TOFsuPQYHzRGRuY6KAektsdb+mfg8/CxzjlQC6YLlE9k1KgnSjPLsnfWPFj+zMSn0lrhi3VoLt1hYdJ4ycG/q/sXZ1JUBnm8YckFKr4jCRlaujbozl2BgYiFyJqomMftbNeIVmz3GxQYxVM5/Dyhg8B/GcKhr0Dya3VT8nUb9zHCL79/CIVrqvquvCF6ybJD4skWAjbJCguX4BPjtnvLkuGcC0/qmqA63PBAKisbaIFkVNtp4A6fIRCJ/53TBQ8SiZDmvqWmGWW4bEdAv5ZkIkW7h0IMysGn86uae2kitne3L/tW273zPV46oI+Fgk9cjVrdnRy4raR6c4S1CLDeO641zewCJhMoW+7YTTRX2/3xK6rYmm4RXLSgaG3AzOMnW8QTY4myTW4/r6drj4D1vCVpllZC3zXncJbwQ7Xqlz7JsV3CLtSTXYfEDv7uDN8Tgsqpyg6Q1NDHymPSt78D7aVQeAGZT2FerRfT5YETFYlRZKbc3hHWGkHpfhe5PxgTvvQtZ1xYaOiq++xI/7s6AlT5G63t6npuxMbaPZUAiACnoHYt1mUmy8ERyXkBM1B1qUDAzxuAjaR8YKg1COG9hFvSw/tUEDHsiWG5X4NE9lKjqo8auwWp/jAm07LcCaLP2EqxV3nrNy0qZ+ET+sTXEAsb7yX+Vt0I3twSYxku7Qs4UQG5Bm9qW8qdzsP/s2Etwq61ogz81DiBkM+VWMa+hMbePFShjqSulj7a3XRCf+XRYIogACP/+HTrx/ur/UlDMK1dLDZRuNU61toDCzptJxj664pT93o4hYmhq5B4L5yUN2w1Ffr8rjL48b8zy/xMPL21NpBcRGRnta6fG0DTcWNTtgw0ne4x9aKrMZCLRFMDnV+r+Lfi6aCsg
 VksSpWIa
 0MPC9ychWsnd+Ox0p7RrhopjCiGumoZEJokNnZ5zlf30l2C+zDa9tudf+GO8mB5hnLBTJfKyb9n2D8ppvRwpSTozO56xb8CWJ1HuTuFCnnzoOih62Rn4o0iLKa4C9j744YeAvqRhIiubBHKECOgUJ1SihBVFWvMlKEFAU7DdsjesBFEPkByNX0QmhBLqckTkct1c71KBopMw+Y//+KfkNwzbgdizz/BiWsR3I7rhUOvRlwkAyZfmQsS3wgaQo8ZJCqF0EuOdGZiydmU2HwmVlp6maeFHrw+7aWTmroU7JCLD3joQlDAaWspowaL72KXt2KFxUxEK4Tel6nn8vi203qI1KPfvaDTLADTZV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 02, 2026 at 09:45:41AM +0800, Chunyu Hu wrote:
> Add three more checks for buflen and numwritten. The buflen should be at
> least two, that means at least one char and the null-end. The error case
> check is added by checking numwriten < 0 instead of numwritten < 1. And the
> truncate case is checked. The test will exit if any of these conditions
> aren't met.
>
> Additionally, add more print information when a write failure occurs or
> a truncated write happens, providing clearer diagnostics.
>
> Signed-off-by: Chunyu Hu <chuhu@redhat.com>

LGTM, so:

Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>

> ---
> Changes in v8:
>   - go back to ksft_exit_fail_msg in the two error exit path as no clean
>     ksft_exit_fail_perror that supports va_list
> Changes in v7:
>   - add an empty line before the 'buflen < 1' line.  And change to
>    'buflen < 2 to limit the buflen at least to be 2, so at least one char
>     is allowed.
>   - handle the numwriten < 0 case, which is the error path.
>   - use ksft_exit_fail_perror in error exit path.
>   - use %.*s to print the buf when error happened
> Changes in v6:
>   - save/restore errno before and after the close(), so the log could show
>     the correct error info on failure. Suggested by AI.
> Chagnes in v5:
>   - new patch for making improve on write_file. Add more safety checks and
>     diagnostics info in log
> ---
>  tools/testing/selftests/mm/vm_util.c | 15 ++++++++++++---
>  1 file changed, 12 insertions(+), 3 deletions(-)
>
> diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
> index ad96d19d1b85..db94564f4431 100644
> --- a/tools/testing/selftests/mm/vm_util.c
> +++ b/tools/testing/selftests/mm/vm_util.c
> @@ -767,15 +767,24 @@ int unpoison_memory(unsigned long pfn)
>
>  void write_file(const char *path, const char *buf, size_t buflen)
>  {
> -	int fd;
> +	int fd, saved_errno;
>  	ssize_t numwritten;
>
> +	if (buflen < 2)
> +		ksft_exit_fail_msg("Incorrect buffer len: %zu\n", buflen);
> +
>  	fd = open(path, O_WRONLY);
>  	if (fd == -1)
>  		ksft_exit_fail_msg("%s open failed: %s\n", path, strerror(errno));
>
>  	numwritten = write(fd, buf, buflen - 1);
> +	saved_errno = errno;
>  	close(fd);
> -	if (numwritten < 1)
> -		ksft_exit_fail_msg("Write failed\n");
> +	errno = saved_errno;
> +	if (numwritten < 0)
> +		ksft_exit_fail_msg("%s write(%.*s) failed: %s\n", path, (int)(buflen - 1),
> +				buf, strerror(errno));
> +	if (numwritten != buflen - 1)
> +		ksft_exit_fail_msg("%s write(%.*s) is truncated, expected %zu bytes, got %zd bytes\n",
> +				path, (int)(buflen - 1), buf, buflen - 1, numwritten);
>  }
> --
> 2.53.0
>

