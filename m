Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66AEF606A31C
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 02:35:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=M75aPf/F
Received: by kanga.kvack.org (Postfix)
	id 5475F6B00EF; Sun,  8 Nov 2026 21:35:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F8206B05B0; Sun,  8 Nov 2026 21:35:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E6FD6B05B1; Sun,  8 Nov 2026 21:35:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 193CB6B00EF
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 21:35:18 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3D9181404D8
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 02:35:17 +0000 (UTC)
X-FDA: 85414013874.26.93394F2
Received: from mta0.migadu.com (out-104.mta0.migadu.com [91.218.175.104])
	by imf15.hostedemail.com (Postfix) with ESMTP id B91E5A0004
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 02:35:13 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="M75aPf/F";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of xu.xin@linux.dev designates 91.218.175.104 as permitted sender) smtp.mailfrom=xu.xin@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794191714;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/ikAqP7gpdbBI+hdFB0vTPSMi3bWmtsaCXh9lO0ty1U=;
	b=uVYzPN8PETlcgQVV4bSF4VSm4npeTsyKbg6P9BzLyjxHx+QEIyLDrfX/yRYQbtFm7nZm+X
	gmOKxOb64BYTSTo8yNgVUmSqezgRpLYI0qFlgV6cDqSRogobaKexRA8IN0ikEv0fSkUv3r
	NzxZhI7OFx0emrfS/nisytet6G/yKdg=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="M75aPf/F";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of xu.xin@linux.dev designates 91.218.175.104 as permitted sender) smtp.mailfrom=xu.xin@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794191714;
	b=DrTFNQvbxRtNEOSqq9x46NFQ5mFfQHeGJBL2yAOcgi7BU8K6C/lqWuml8d7Ne1Hqy4/3I2
	lBVqG1UbwiZOY3vz0rNzJHUkgxBbzeAGe66GckF/JaCEIcGu5a4YGToTKIyKl2DYC/kuDm
	pzs2mc4s39WErGwhQvPX3JGgoC68g3w=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=psUKZVZC7okDpUhR+qBHZvo0Vd9UtjuNKUs9HwCN5Cc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794191709; v=1; x=1794796509;
 b=M75aPf/FXyCfS/8MBflmk0QpORPYRN6M4MksV8HldOSW/4cycR8VsEgQ8QnBVA4jvK3L5Dxk
 jSzmhfyvXHJ4ZVofXVaXCrOCxNB5TFvQYHgrZXKkBncBM5Oh8laRz936jLwoHC0gETmNWY0c+qc
 ZMvPD8UjNP8ZMEkG71bz3NGM=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id e7a58ce54b55df96;
	Mon, 09 Nov 2026 02:35:07 +0000
X-Mizu-Trace-ID: e7a58ce54b55df96
X-Migadu-Flow: FLOW_OUT
Date: Mon, 9 Nov 2026 10:34:53 +0800
From: "Xu Xin (vivo)" <xu.xin@linux.dev>
To: Qiliang Yuan <odys.yuan@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Stefan Roesch <shr@devkernel.io>, Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-doc@vger.kernel.org
Subject: Re: [PATCH v4 5/5] selftests/mm: cover merging KSM pages aged by
 smart scan
Message-ID: <avExTeM7wyb7PIa6@dgvxl46587.localhost.localdomain>
References: <20261108-bug-mm-ksm-smart-scan-align-skips-v4-0-86be8fe77e7a@gmail.com>
 <20261108-bug-mm-ksm-smart-scan-align-skips-v4-5-86be8fe77e7a@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261108-bug-mm-ksm-smart-scan-align-skips-v4-5-86be8fe77e7a@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B91E5A0004
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: uhtraz68easy86muu8w1k15qur5xzywy
X-HE-Tag: 1794191713-764737
X-HE-Meta: U2FsdGVkX1+Dqm660LqQRpg4ZfbMLbIrewju5MJqMHMO4YEaLR3Jmy+u+EB8FfiAsxQrstXnZcv6/cAfnJ+PHo13yopixgvmsPZgqFvb0Sjlr+401KKffPknhg+P6ynWyiDbGwMR9jGsXK2cT7Zm2kFlquYfN7KVkQSOaWQstq/soixiO5lItUuEVpmGBAz2X/XCPtNCM7b1vjmOKwktwNUziPX4pG1h16EdGfzBTfod/Ie7Bh0xFv+xlxqa//+ehkGMOHCqN5N5D8VIMySFQgyQLgj2Hq5qM1jvqpQxIkPRyHhYwsQZuiEg67Eql3N/EB8pGe3uPD0Xx20Kd6Y8KmfA6O9DVCRnMr9hZfIGO14d4ffoUQJ02igPhoyufwDs/TwEWi/iTk9x9/g0vnXpl2JcnO4T7Fk5gE2qRAk/MP9+cavtuXaTCfd7ZyMlhfLVgkq2u9KeyuUbjFWwMFUK6cjS8rj2n9s7il33955b8QK6LLasB/PgRExc0T9HtciCfuoR/eQz+yFIvpdAyClHBQk7AFY8+fyY6yOGbGPJ6oNfYiy4yW/5EuX6xXvmbvwm7VZa/zJHB+c19ZK9v5N0k/9ps82M3f4bm1BnhSXMi2CVJ9BXDPUxJjEZCGcHxQ553kY7R5z9FSREIXJO3XNrG9T7IWJPBUnvbst2+MSsqFBZF/Yf9l3LEjMcULESvyb2x5ch0MxAuQWBDzkpEEFicFDK+I7uKyLnMWDT4asbIPtbJLgubR58KF4avo2IVFj0TNxsWOKh9Qy+Evkpp4hJ0K62lTHrh0ECKScxthjt0sDlDwflrS+yD5ZmQOUYOMmby1eTapqk5u8IStl1vql2RslbkkOD/BSJPkNigNCRthcXkyy5xMBiZOzIOqx4TErGNBw062FXTj0aIRDh7RI/fPcB1vB1Z60J1hmHg8uR0WY/F+vNmHSOHb/4MAslb7xscu82Px1i/1kiP/+srJG
 tDquEVUV
 Uz4P4TRWXIQOK4ySmgDHW69cjKyvZ6uZdNEZd4qZSpgcUJThSbMbnGZNGTAc0fyHlfidlZleTRkQBKB3xBQpDJYflIeSDEi0g99sKNq0r0eXHRvHr4GkQAUM86X7hHVIA5LQ5JEnDatZtnSJo7wKTNEsY6dZOXUDYCIFqzRxRl0fA1gILaT06d+3eGsAvkSEocQOGjpvdANpiEBjaIjstZbXaEVcLInDcSG/L3y4k+G2pGJ0lKF3sdoIZmHIL4v3XDiAA1Wm6MeTFMhmCmJxhsQXEBEajGfvouayl3ZKPCvWlljvmkxoT24y2miv42drEVsKlzsuE4ZJzPVpi9fR8L4YhpU09SasQVTzPcfq8CLoHnqBCHHgDvsl5wzdKNdfy644jxle9d+NmOi2/gS5YVqzD8w4bDtFQxa+RV4kaGE93pd/G21bqNejj2Sa3yM2CYiO8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, Nov 08, 2026 at 08:22:54PM -0500, Qiliang Yuan wrote:
> ksm_functional_tests checks merging and unmerging with ksmd's default
> settings, but nothing there exercises smart scan, which skips pages KSM
> has failed to merge for a while.
> 
> Smart scan used to time those skips per page, so two identical pages
> that became mergeable some scans apart could end up never being looked
> at in the same scan, and were never merged. "mm/ksm: align smart scan
> skips with the scan number" fixed that.
> 
> Add ksm_get_smart_scan() and ksm_set_smart_scan() to vm_util, and a
> case that enables smart scan, lets sixteen unique pages age for a dozen
> scans, then makes a duplicate of each mergeable one scan apart, and
> expects every pair to be merged 32 scans later:
> 
>   kernel               failures, two boots
>   before the fix       20/20, 20/20
>   with the fix          0/20,  0/20
> 
> Signed-off-by: Qiliang Yuan <odys.yuan@gmail.com>
> Tested-by: Andrew Morton <akpm@linux-foundation.org>
> Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
>  tools/testing/selftests/mm/ksm_functional_tests.c | 89 ++++++++++++++++++++++-
>  tools/testing/selftests/mm/vm_util.c              | 36 +++++++++
>  tools/testing/selftests/mm/vm_util.h              |  2 +
>  3 files changed, 126 insertions(+), 1 deletion(-)

Reviewed-by: Xu Xin (vivo) <xu.xin@linux.dev>

> 
> diff --git a/tools/testing/selftests/mm/ksm_functional_tests.c b/tools/testing/selftests/mm/ksm_functional_tests.c
> index 31c06c72203fd..135191f99962d 100644
> --- a/tools/testing/selftests/mm/ksm_functional_tests.c
> +++ b/tools/testing/selftests/mm/ksm_functional_tests.c
> @@ -695,6 +695,92 @@ static void test_fork_ksm_merging_page_count(void)
>  	munmap(map, size);
>  }
>  
> +static void test_merge_aged_pairs(void)
> +{
> +	const unsigned int pairs = 16;
> +	const unsigned long size = 2 * pairs * pagesize;
> +	int old_smart_scan;
> +	unsigned int i;
> +	char *map;
> +
> +	ksft_print_msg("[RUN] %s\n", __func__);
> +
> +	old_smart_scan = ksm_get_smart_scan();
> +	if (old_smart_scan < 0) {
> +		ksft_test_result_skip("smart_scan not supported\n");
> +		return;
> +	}
> +	if (ksm_set_smart_scan(true) < 0) {
> +		ksft_test_result_fail("Enabling smart_scan failed\n");
> +		return;
> +	}
> +
> +	if (ksm_stop() < 0) {
> +		ksft_test_result_fail("Disabling (unmerging) KSM failed\n");
> +		goto restore;
> +	}
> +
> +	map = mmap(NULL, size, PROT_READ | PROT_WRITE,
> +		   MAP_PRIVATE | MAP_ANON, -1, 0);
> +	if (map == MAP_FAILED) {
> +		ksft_test_result_fail("mmap() failed\n");
> +		goto restore;
> +	}
> +	if (madvise(map, size, MADV_NOHUGEPAGE) && errno != EINVAL) {
> +		ksft_test_result_fail("MADV_NOHUGEPAGE failed\n");
> +		goto unmap;
> +	}
> +
> +	/*
> +	 * Page i of the first half and page i of the second half form a
> +	 * pair with content no other page shares.
> +	 */
> +	for (i = 0; i < pairs; i++) {
> +		memset(map + i * pagesize, i + 1, pagesize);
> +		memset(map + (pairs + i) * pagesize, i + 1, pagesize);
> +	}
> +
> +	/* Let the first page of each pair age without a duplicate. */
> +	if (madvise(map, size / 2, MADV_MERGEABLE)) {
> +		ksft_test_result_fail("MADV_MERGEABLE failed\n");
> +		goto unmap;
> +	}
> +	if (ksm_start() < 0 || ksm_wait_full_scans(12) < 0) {
> +		ksft_test_result_fail("Running KSM failed\n");
> +		goto unmap;
> +	}
> +
> +	/*
> +	 * Make the duplicates mergeable one scan apart so that each pair
> +	 * starts out with a different distance in scans.
> +	 */
> +	for (i = 0; i < pairs; i++) {
> +		if (madvise(map + (pairs + i) * pagesize, pagesize,
> +			    MADV_MERGEABLE)) {
> +			ksft_test_result_fail("MADV_MERGEABLE failed\n");
> +			goto unmap;
> +		}
> +		if (ksm_wait_full_scans(1) < 0) {
> +			ksft_test_result_fail("Running KSM failed\n");
> +			goto unmap;
> +		}
> +	}
> +
> +	if (ksm_wait_full_scans(32) < 0) {
> +		ksft_test_result_fail("Running KSM failed\n");
> +		goto unmap;
> +	}
> +
> +	ksft_test_result(ksm_get_self_merging_pages() == 2 * pairs,
> +			 "Pages aged by smart scan got merged\n");
> +unmap:
> +	ksm_stop();
> +	munmap(map, size);
> +restore:
> +	if (ksm_set_smart_scan(old_smart_scan) < 0)
> +		ksft_print_msg("Restoring smart_scan failed\n");
> +}
> +
>  static void init_global_file_handles(void)
>  {
>  	mem_fd = open("/proc/self/mem", O_RDWR);
> @@ -720,7 +806,7 @@ static void init_global_file_handles(void)
>  
>  int main(int argc, char **argv)
>  {
> -	unsigned int tests = 9;
> +	unsigned int tests = 10;
>  	int err;
>  
>  	if (argc > 1 && !strcmp(argv[1], FORK_EXEC_CHILD_PRG_NAME)) {
> @@ -753,6 +839,7 @@ int main(int argc, char **argv)
>  	test_prctl_fork_exec();
>  	test_prctl_unmerge();
>  	test_fork_ksm_merging_page_count();
> +	test_merge_aged_pairs();
>  
>  	err = ksft_get_fail_cnt();
>  	if (err)
> diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
> index 8184691211acc..f26f9e4bfdbe9 100644
> --- a/tools/testing/selftests/mm/vm_util.c
> +++ b/tools/testing/selftests/mm/vm_util.c
> @@ -992,6 +992,42 @@ int ksm_use_zero_pages(void)
>  	return ret == 1 ? 0 : -EIO;
>  }
>  
> +int ksm_get_smart_scan(void)
> +{
> +	int smart_scan_fd;
> +	char buf;
> +	ssize_t ret;
> +
> +	smart_scan_fd = open("/sys/kernel/mm/ksm/smart_scan", O_RDONLY);
> +	if (smart_scan_fd < 0)
> +		return -errno;
> +
> +	ret = pread(smart_scan_fd, &buf, 1, 0);
> +	close(smart_scan_fd);
> +	if (ret < 0)
> +		return -errno;
> +	if (ret != 1)
> +		return -EIO;
> +
> +	return buf == '1';
> +}
> +
> +int ksm_set_smart_scan(bool enable)
> +{
> +	int smart_scan_fd;
> +	ssize_t ret;
> +
> +	smart_scan_fd = open("/sys/kernel/mm/ksm/smart_scan", O_WRONLY);
> +	if (smart_scan_fd < 0)
> +		return -errno;
> +
> +	ret = write(smart_scan_fd, enable ? "1" : "0", 1);
> +	close(smart_scan_fd);
> +	if (ret < 0)
> +		return -errno;
> +	return ret == 1 ? 0 : -EIO;
> +}
> +
>  int ksm_wait_full_scans(long nr)
>  {
>  	long start_scans, end_scans;
> diff --git a/tools/testing/selftests/mm/vm_util.h b/tools/testing/selftests/mm/vm_util.h
> index 7e00030077d2f..ab1325dc65800 100644
> --- a/tools/testing/selftests/mm/vm_util.h
> +++ b/tools/testing/selftests/mm/vm_util.h
> @@ -163,6 +163,8 @@ long ksm_get_self_zero_pages(void);
>  long ksm_get_self_merging_pages(void);
>  long ksm_get_full_scans(void);
>  int ksm_wait_full_scans(long nr);
> +int ksm_get_smart_scan(void);
> +int ksm_set_smart_scan(bool enable);
>  int ksm_use_zero_pages(void);
>  int ksm_start(void);
>  int ksm_stop(void);
> 
> -- 
> 2.43.0
> 

