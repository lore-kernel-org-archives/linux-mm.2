Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80953CA0ED1
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 06:47:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 090C98E01DA; Fri, 15 Aug 2025 02:47:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0685B8E0002; Fri, 15 Aug 2025 02:47:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC0B58E01DA; Fri, 15 Aug 2025 02:47:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D57928E0002
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 02:47:22 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 67A8DBBD1B
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 06:47:22 +0000 (UTC)
X-FDA: 83778060324.22.854F394
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	by imf08.hostedemail.com (Postfix) with ESMTP id 57B8916000D
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 06:47:20 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Z47PiqJA;
	spf=pass (imf08.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755240440;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9Wha0CSfCI0LTXDdpc+A/fuT9AAV5cCt6gEqaBPnLEw=;
	b=R2WU7CKopWdidsnWzsG2un7JsEjPUeKMs2xO3vl3sU7BOo0Ppaj1o75S/pmli81Jc1x/hZ
	JN0te32WL2D1ZaI4K4FQMONUNHqgG4gHnKV8lu8XSSp6ooduEEch6jH1DoRqExvaSYIjem
	/+aNvYul+M6lKXHWKR3rVPE8GXJILow=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Z47PiqJA;
	spf=pass (imf08.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755240440; a=rsa-sha256;
	cv=none;
	b=Lw3nQMKV1I/7KJkPE0oZVeZe3r4961JWoYhWxegQd9pLa4YR/3Okk9XnSY1CjuJBygYCep
	bqcmGPvlbBJFlkb8+9vNKGqkzJHJt262Qxy65/U99wFVklFYhMTCaQtoP3GZ7liJwL8zFv
	zouKC9SFbuBr01AjHoBPU17eNdkgwnc=
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-6188b65a2f0so3145156a12.1
        for <linux-mm@kvack.org>; Thu, 14 Aug 2025 23:47:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755240439; x=1755845239; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9Wha0CSfCI0LTXDdpc+A/fuT9AAV5cCt6gEqaBPnLEw=;
        b=Z47PiqJAeKIheCOQRdaFY1I1uFWy7hZeV/wXrsu8jqC726ZiduX2Ly8jxttTwtoVnm
         OSrZRm0QWJQwB00cFU/RWxdUV02M91UUAsCeBlHxkZoFuwU2a7bJLajOjYOhVyBWVdXy
         27ImTgeIrYDnvnzHqHpzc5YEjlxxqXjiqrHuOjBSRNirxlI/AP3DDBp0smhpp9A6W15D
         F4JJZT9nnCo5ojTIFsq/Rs5rGbMfZ/cc2WJnnUvFXyjXO1LdEe7FR220UL4kyk+BAU9q
         cb36oBl++x5K8qfXMNnCqLvQU09ZuyF6pUjDjN45x/lKfQwWlrBBb7ldPWAlLE0fsYIX
         8FAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755240439; x=1755845239;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9Wha0CSfCI0LTXDdpc+A/fuT9AAV5cCt6gEqaBPnLEw=;
        b=Tz3YxZk9YGZ0X6p39RFOA1U820TZyBEboND5xfaSAuqZTkcGEoDGVM7vT27j1dGwAw
         XgUp7Ly17F21S4LS7qpe5js5FAXR2TjNvM/ICy1y/eWwS88DcxGevFEFuIxxH7107PVe
         6mUTvd/31VdRLxF9tmQnTW2chDWaHo1ct4POaHtV/QihVKIuX3zerAaCk2O7t6Y3SPqm
         Ph48HwDfmK+77GiUowZtCqxNX8EdFITNENd3BKBqLjI5EKbTs+LzjQwUMA7yX6aULJUN
         SEkc0yn76iz8reZOWXPAdgstDXlV4ZoVNuXBUFjpyAjjd/029SacNORcMOClGLmgu+q2
         yG+g==
X-Forwarded-Encrypted: i=1; AJvYcCWrTHbTPia1CX+tHLnzhJnYxzyTt4JURaUW9Jk2ydPECDevdTWFqSkKyomyGWc9IWP/0uXhrrHwwA==@kvack.org
X-Gm-Message-State: AOJu0YzqsDDR54NGLLWM4Ykol0QECyKERudhDmIMAezcxhKpaiddpLoh
	ogohNfsghqJYgYcO/FGzdWbhcw8qKsbKP8VJ8OEEZHecPgeRHupk+/Mv
X-Gm-Gg: ASbGnctsk7Y9W6AMv3D01k19mzBXzu4U6R1+lzExyuokXVNoVZn1tiSormjYBiA+/5i
	3H7AzXiXXOX94YgJbrrXNCZC+7cV94AtUdC+v/xswt6xN/R53SkB5CNt/EFwIb39afAZbTunTlt
	GFM+LPSFPR7WR3yryoTuENIsNsksuJPodX+Lm82AsxBBAQuj68X5uCV6wUKIpOdVTAvoCBjJBbv
	gbjY8jsaD3M6Q0LpjQv82Tcgs27GR1B1k4MCk9WfIaa2M7/QKs6+Ki4BAUqOft7VoTi4qOuWlVm
	D5NJep9LgbL+zt4COhpW1gbwLhFb2c4Qe26XypqfH9b2VIBRUhcJjH+zNOdq6R3WKR90MLcCIFn
	ZnbwcJ8o4XMFzW/LUisdMCQ==
X-Google-Smtp-Source: AGHT+IG61+P82DA6zwJgjGPRpc9GIbGpZKXqKkgYODZJzVdqitkpbvpnyRbDKf/dpkcXC8j/nHT40g==
X-Received: by 2002:a17:907:60d4:b0:afa:1a67:c046 with SMTP id a640c23a62f3a-afcdc1f8e04mr73527566b.11.1755240438612;
        Thu, 14 Aug 2025 23:47:18 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-afcdcfccc48sm67186666b.83.2025.08.14.23.47.18
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 14 Aug 2025 23:47:18 -0700 (PDT)
Date: Fri, 15 Aug 2025 06:47:17 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Rik van Riel <riel@surriel.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Harry Yoo <harry.yoo@oracle.com>
Subject: Re: [Patch v2 1/2] selftests/mm: put general ksm operation into
 vm_util
Message-ID: <20250815064717.hlkehch75t6blj6e@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250726025223.350-1-richard.weiyang@gmail.com>
 <20250726025223.350-2-richard.weiyang@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250726025223.350-2-richard.weiyang@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Stat-Signature: m3qurk6ez4s793fq9ezkry4d56dc8d8i
X-Rspam-User: 
X-Rspamd-Queue-Id: 57B8916000D
X-Rspamd-Server: rspam01
X-HE-Tag: 1755240440-630410
X-HE-Meta: U2FsdGVkX19aqYpZ8g6kglT/1sHCVVlIPNnUFM8rhFdmEPruq/xoTMeQO7DnpnNchWRH1yh0wXnILJ30vNgV/bc1deYfMeNN89YDMJm3ZGzquvN7yQD/WeAv8Z/tyYrHQWS1WWkLSOcq2lkDOMDvhg+YjWp0pk74uLUowvPwd7E7w5gkM57qZkiqXQrhn6h1rwZzPN2uFbTG5/RMFwhZjABPr7GaENn0WGKBDFZ3f/P3Ys8bRMHEjQoclrcjFaI9XjW4dIAuDVFqDXZEFWjLdkkmpjikmPQ4QLmTWiVkUeMxS9qsC7zYZSkKCuz+eDCpVjgwiR+PrsdTspf2jqu34HfBCLgntEpBVEYCji1M7O3zt3zF6lZO6BDYratxv0J3RHT4TQtln2JI77FRdRx0cj00RUH4lGkPZ4e1IaI05GWwdjyTPci15i8OT5WUnUDXM9qrsjOq9LyG6ps3dAGX/69UBpt0isEnFJ/dvQWqqkEB9jHaLQ5Bf2oLl6YWxTTOH2vBODnnzpEYcPi73TLTPOePL5ZW5MjUURMl3X7AQQS33HSrpomWQQ8jxsjbNW8SsBjhj9eyDDAqCqvBixqKuVdYXi2sSGaV5rRUlqLY0NTqGttZfWPsiH8m/A8FTK/nzpBTrXSIKItAFbd+vCxpxdgEzq2ot7GXOW1wSwA3zJukqW/ZXFDWMbi530zMX+l7PIaw5/+/Gm8V308QWiFIR9Qe8PJ9cfkdMPaD6CNVbBy5pYekwu/E7SVAHQw+3gLyRYRVhhs45OoL/KzUF2mcNNMN0QdZEbPyb7k21nVVyToB9WjAAalLtjuT4/loyverUWOpEizN5edjKESNdYa1tXwp1rMu29zcIOgEUUooXq0iwa0HaPIdiJSkR+OUDegP/jrNjGpePBJ4YA0wADXe8myJz8Y9vDqRiEcZLgDHgD+SrqE27Oo5DNhVf5rzAF1Vz/N3kTVqXQzMlF5UXdz
 Gdo8gxni
 FcQ4irawTxse3YErRkX5P9K7c/3z4vS8//seMedCtJbqsCQ8U1ZIsHoKBzY2gvzgbfkUu+vq7PxLWtQ6rFDv1N/Szr8QR0+sodm8+aLeKufWMqFfL4xoXMkQvzCXBFT/ozhwWumc95zGIIsAT7n5gLrJQCaArKLxfm1OsxcZGCA4byi7VEV5W3d8onJ8Wlk548ZvJT4pVpl2CnAbQIX4JCPWBnhVRi9YXCcqSBE2ck/V6VCs+vlMDAvPzeqs6NlnZKfbaG1KUqmyPw89uA9TfCtJ+z7ehz5FHVU/NgGTaSu/z99wGcmSAvhLpC0bQ6OBS3U9p2LQIdS1tkvLh4dQH5PppJ9p4oBlnwESOw1u8MjDxetQUAyGb6/3R2kCHYS6FWmKs11sF+0Znr7lZ5KqRbYspv2IO415LXfLQpHnYXuaMLsA6XttSUGdz/TLpO6/YjYrPAPcvH/YoZ93D/IJgyG78C/k+nLwwS9qrNa250K178auogm3hGRn3PJMKFbpO4L5kV8m3BP4xLbihKoKhnBZsIZ2Mg0mGHctpcX1kcsslMZfoAM/btbamULCTn8eF3szBTqjvtqYwJ9w8+Oxv0wAc0RXvodH/DZOA1gR3X4O4B2jqzdMeYX63KUQBOdJOHOUBXpFpl69PlmpBlgWhiF25gq+hR0uWExVAhLG5fM50ZYepI/CYqhs30sRiemKV9WF1jem7S5NbNtW/iXDBSdOpCc/kL1VT0NynaSraIxSygRnKa0YsQ269q8xDJbMsBxlLLHtfiy1anFY7igcK6v6SR3xH2ewygJOdRx2GVyC+ncuoRAyk1yCCPPYmC8p4Wq4UaLNVnMMvWAiToc5TBr4i8kePgbl+wuknbElt2M/ByukzSt8s+HROUSITfyXfRe+1
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Ping...

On Sat, Jul 26, 2025 at 02:52:22AM +0000, Wei Yang wrote:
>There are some general ksm operations could be used by other related
>test case. Put them into vm_util for common use.
>
>This is a preparation patch for later use.
>
>Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>Suggested-by: David Hildenbrand <david@redhat.com>
>Cc: David Hildenbrand <david@redhat.com>
>Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>Cc: Rik van Riel <riel@surriel.com>
>Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
>Cc: Vlastimil Babka <vbabka@suse.cz>
>Cc: Harry Yoo <harry.yoo@oracle.com>
>
>---
>v2:
>  * do check on file opening in init_global_file_handlers()
>  * factor out ksm_merge() and ksm_unmerge() instead of partial of it
>  * align the return value of helpers: 0 on success, -errno on error
>v1: open/close fd in function itself instead of pass as parameter
>---
> .../selftests/mm/ksm_functional_tests.c       | 128 +++---------------
> tools/testing/selftests/mm/vm_util.c          | 123 +++++++++++++++++
> tools/testing/selftests/mm/vm_util.h          |   7 +
> 3 files changed, 147 insertions(+), 111 deletions(-)
>
>diff --git a/tools/testing/selftests/mm/ksm_functional_tests.c b/tools/testing/selftests/mm/ksm_functional_tests.c
>index d8bd1911dfc0..bab74455d70b 100644
>--- a/tools/testing/selftests/mm/ksm_functional_tests.c
>+++ b/tools/testing/selftests/mm/ksm_functional_tests.c
>@@ -38,11 +38,6 @@ enum ksm_merge_mode {
> };
> 
> static int mem_fd;
>-static int ksm_fd;
>-static int ksm_full_scans_fd;
>-static int proc_self_ksm_stat_fd;
>-static int proc_self_ksm_merging_pages_fd;
>-static int ksm_use_zero_pages_fd;
> static int pagemap_fd;
> static size_t pagesize;
> 
>@@ -73,88 +68,6 @@ static bool range_maps_duplicates(char *addr, unsigned long size)
> 	return false;
> }
> 
>-static long get_my_ksm_zero_pages(void)
>-{
>-	char buf[200];
>-	char *substr_ksm_zero;
>-	size_t value_pos;
>-	ssize_t read_size;
>-	unsigned long my_ksm_zero_pages;
>-
>-	if (!proc_self_ksm_stat_fd)
>-		return 0;
>-
>-	read_size = pread(proc_self_ksm_stat_fd, buf, sizeof(buf) - 1, 0);
>-	if (read_size < 0)
>-		return -errno;
>-
>-	buf[read_size] = 0;
>-
>-	substr_ksm_zero = strstr(buf, "ksm_zero_pages");
>-	if (!substr_ksm_zero)
>-		return 0;
>-
>-	value_pos = strcspn(substr_ksm_zero, "0123456789");
>-	my_ksm_zero_pages = strtol(substr_ksm_zero + value_pos, NULL, 10);
>-
>-	return my_ksm_zero_pages;
>-}
>-
>-static long get_my_merging_pages(void)
>-{
>-	char buf[10];
>-	ssize_t ret;
>-
>-	if (proc_self_ksm_merging_pages_fd < 0)
>-		return proc_self_ksm_merging_pages_fd;
>-
>-	ret = pread(proc_self_ksm_merging_pages_fd, buf, sizeof(buf) - 1, 0);
>-	if (ret <= 0)
>-		return -errno;
>-	buf[ret] = 0;
>-
>-	return strtol(buf, NULL, 10);
>-}
>-
>-static long ksm_get_full_scans(void)
>-{
>-	char buf[10];
>-	ssize_t ret;
>-
>-	ret = pread(ksm_full_scans_fd, buf, sizeof(buf) - 1, 0);
>-	if (ret <= 0)
>-		return -errno;
>-	buf[ret] = 0;
>-
>-	return strtol(buf, NULL, 10);
>-}
>-
>-static int ksm_merge(void)
>-{
>-	long start_scans, end_scans;
>-
>-	/* Wait for two full scans such that any possible merging happened. */
>-	start_scans = ksm_get_full_scans();
>-	if (start_scans < 0)
>-		return start_scans;
>-	if (write(ksm_fd, "1", 1) != 1)
>-		return -errno;
>-	do {
>-		end_scans = ksm_get_full_scans();
>-		if (end_scans < 0)
>-			return end_scans;
>-	} while (end_scans < start_scans + 2);
>-
>-	return 0;
>-}
>-
>-static int ksm_unmerge(void)
>-{
>-	if (write(ksm_fd, "2", 1) != 1)
>-		return -errno;
>-	return 0;
>-}
>-
> static char *__mmap_and_merge_range(char val, unsigned long size, int prot,
> 				  enum ksm_merge_mode mode)
> {
>@@ -163,12 +76,12 @@ static char *__mmap_and_merge_range(char val, unsigned long size, int prot,
> 	int ret;
> 
> 	/* Stabilize accounting by disabling KSM completely. */
>-	if (ksm_unmerge()) {
>+	if (ksm_stop() < 0) {
> 		ksft_print_msg("Disabling (unmerging) KSM failed\n");
> 		return err_map;
> 	}
> 
>-	if (get_my_merging_pages() > 0) {
>+	if (ksm_get_self_merging_pages() > 0) {
> 		ksft_print_msg("Still pages merged\n");
> 		return err_map;
> 	}
>@@ -218,7 +131,7 @@ static char *__mmap_and_merge_range(char val, unsigned long size, int prot,
> 	}
> 
> 	/* Run KSM to trigger merging and wait. */
>-	if (ksm_merge()) {
>+	if (ksm_start() < 0) {
> 		ksft_print_msg("Running KSM failed\n");
> 		goto unmap;
> 	}
>@@ -227,7 +140,7 @@ static char *__mmap_and_merge_range(char val, unsigned long size, int prot,
> 	 * Check if anything was merged at all. Ignore the zero page that is
> 	 * accounted differently (depending on kernel support).
> 	 */
>-	if (val && !get_my_merging_pages()) {
>+	if (val && !ksm_get_self_merging_pages()) {
> 		ksft_print_msg("No pages got merged\n");
> 		goto unmap;
> 	}
>@@ -286,15 +199,12 @@ static void test_unmerge_zero_pages(void)
> 
> 	ksft_print_msg("[RUN] %s\n", __func__);
> 
>-	if (proc_self_ksm_stat_fd < 0) {
>-		ksft_test_result_skip("open(\"/proc/self/ksm_stat\") failed\n");
>-		return;
>-	}
>-	if (ksm_use_zero_pages_fd < 0) {
>-		ksft_test_result_skip("open \"/sys/kernel/mm/ksm/use_zero_pages\" failed\n");
>+	if (ksm_get_self_zero_pages() < 0) {
>+		ksft_test_result_skip("accessing \"/proc/self/ksm_stat\" failed\n");
> 		return;
> 	}
>-	if (write(ksm_use_zero_pages_fd, "1", 1) != 1) {
>+
>+	if (ksm_use_zero_pages() < 0) {
> 		ksft_test_result_skip("write \"/sys/kernel/mm/ksm/use_zero_pages\" failed\n");
> 		return;
> 	}
>@@ -306,7 +216,7 @@ static void test_unmerge_zero_pages(void)
> 
> 	/* Check if ksm_zero_pages is updated correctly after KSM merging */
> 	pages_expected = size / pagesize;
>-	if (pages_expected != get_my_ksm_zero_pages()) {
>+	if (pages_expected != ksm_get_self_zero_pages()) {
> 		ksft_test_result_fail("'ksm_zero_pages' updated after merging\n");
> 		goto unmap;
> 	}
>@@ -319,7 +229,7 @@ static void test_unmerge_zero_pages(void)
> 
> 	/* Check if ksm_zero_pages is updated correctly after unmerging */
> 	pages_expected /= 2;
>-	if (pages_expected != get_my_ksm_zero_pages()) {
>+	if (pages_expected != ksm_get_self_zero_pages()) {
> 		ksft_test_result_fail("'ksm_zero_pages' updated after unmerging\n");
> 		goto unmap;
> 	}
>@@ -329,7 +239,7 @@ static void test_unmerge_zero_pages(void)
> 		*((unsigned int *)&map[offs]) = offs;
> 
> 	/* Now we should have no zeropages remaining. */
>-	if (get_my_ksm_zero_pages()) {
>+	if (ksm_get_self_zero_pages()) {
> 		ksft_test_result_fail("'ksm_zero_pages' updated after write fault\n");
> 		goto unmap;
> 	}
>@@ -685,19 +595,15 @@ static void init_global_file_handles(void)
> 	mem_fd = open("/proc/self/mem", O_RDWR);
> 	if (mem_fd < 0)
> 		ksft_exit_fail_msg("opening /proc/self/mem failed\n");
>-	ksm_fd = open("/sys/kernel/mm/ksm/run", O_RDWR);
>-	if (ksm_fd < 0)
>-		ksft_exit_skip("open(\"/sys/kernel/mm/ksm/run\") failed\n");
>-	ksm_full_scans_fd = open("/sys/kernel/mm/ksm/full_scans", O_RDONLY);
>-	if (ksm_full_scans_fd < 0)
>-		ksft_exit_skip("open(\"/sys/kernel/mm/ksm/full_scans\") failed\n");
>+	if (ksm_stop() < 0)
>+		ksft_exit_skip("accessing \"/sys/kernel/mm/ksm/run\") failed\n");
>+	if (ksm_get_full_scans() < 0)
>+		ksft_exit_skip("accessing \"/sys/kernel/mm/ksm/full_scans\") failed\n");
> 	pagemap_fd = open("/proc/self/pagemap", O_RDONLY);
> 	if (pagemap_fd < 0)
> 		ksft_exit_skip("open(\"/proc/self/pagemap\") failed\n");
>-	proc_self_ksm_stat_fd = open("/proc/self/ksm_stat", O_RDONLY);
>-	proc_self_ksm_merging_pages_fd = open("/proc/self/ksm_merging_pages",
>-						O_RDONLY);
>-	ksm_use_zero_pages_fd = open("/sys/kernel/mm/ksm/use_zero_pages", O_RDWR);
>+	if (ksm_get_self_merging_pages() < 0)
>+		ksft_exit_skip("accessing \"/proc/self/ksm_merging_pages\") failed\n");
> }
> 
> int main(int argc, char **argv)
>diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
>index 9dafa7669ef9..c0b82e9eaa9f 100644
>--- a/tools/testing/selftests/mm/vm_util.c
>+++ b/tools/testing/selftests/mm/vm_util.c
>@@ -555,3 +555,126 @@ bool detect_huge_zeropage(void)
> 	close(fd);
> 	return enabled;
> }
>+
>+long ksm_get_self_zero_pages(void)
>+{
>+	int proc_self_ksm_stat_fd;
>+	char buf[200];
>+	char *substr_ksm_zero;
>+	size_t value_pos;
>+	ssize_t read_size;
>+
>+	proc_self_ksm_stat_fd = open("/proc/self/ksm_stat", O_RDONLY);
>+	if (proc_self_ksm_stat_fd < 0)
>+		return -errno;
>+
>+	read_size = pread(proc_self_ksm_stat_fd, buf, sizeof(buf) - 1, 0);
>+	close(proc_self_ksm_stat_fd);
>+	if (read_size < 0)
>+		return -errno;
>+
>+	buf[read_size] = 0;
>+
>+	substr_ksm_zero = strstr(buf, "ksm_zero_pages");
>+	if (!substr_ksm_zero)
>+		return 0;
>+
>+	value_pos = strcspn(substr_ksm_zero, "0123456789");
>+	return strtol(substr_ksm_zero + value_pos, NULL, 10);
>+}
>+
>+long ksm_get_self_merging_pages(void)
>+{
>+	int proc_self_ksm_merging_pages_fd;
>+	char buf[10];
>+	ssize_t ret;
>+
>+	proc_self_ksm_merging_pages_fd = open("/proc/self/ksm_merging_pages",
>+						O_RDONLY);
>+	if (proc_self_ksm_merging_pages_fd < 0)
>+		return -errno;
>+
>+	ret = pread(proc_self_ksm_merging_pages_fd, buf, sizeof(buf) - 1, 0);
>+	close(proc_self_ksm_merging_pages_fd);
>+	if (ret <= 0)
>+		return -errno;
>+	buf[ret] = 0;
>+
>+	return strtol(buf, NULL, 10);
>+}
>+
>+long ksm_get_full_scans(void)
>+{
>+	int ksm_full_scans_fd;
>+	char buf[10];
>+	ssize_t ret;
>+
>+	ksm_full_scans_fd = open("/sys/kernel/mm/ksm/full_scans", O_RDONLY);
>+	if (ksm_full_scans_fd < 0)
>+		return -errno;
>+
>+	ret = pread(ksm_full_scans_fd, buf, sizeof(buf) - 1, 0);
>+	close(ksm_full_scans_fd);
>+	if (ret <= 0)
>+		return -errno;
>+	buf[ret] = 0;
>+
>+	return strtol(buf, NULL, 10);
>+}
>+
>+int ksm_use_zero_pages(void)
>+{
>+	int ksm_use_zero_pages_fd;
>+	ssize_t ret;
>+
>+	ksm_use_zero_pages_fd = open("/sys/kernel/mm/ksm/use_zero_pages", O_RDWR);
>+	if (ksm_use_zero_pages_fd < 0)
>+		return -errno;
>+
>+	ret = write(ksm_use_zero_pages_fd, "1", 1);
>+	close(ksm_use_zero_pages_fd);
>+	return ret == 1 ? 0 : -errno;
>+}
>+
>+int ksm_start(void)
>+{
>+	int ksm_fd;
>+	ssize_t ret;
>+	long start_scans, end_scans;
>+
>+	ksm_fd = open("/sys/kernel/mm/ksm/run", O_RDWR);
>+	if (ksm_fd < 0)
>+		return -errno;
>+
>+	/* Wait for two full scans such that any possible merging happened. */
>+	start_scans = ksm_get_full_scans();
>+	if (start_scans < 0) {
>+		close(ksm_fd);
>+		return start_scans;
>+	}
>+	ret = write(ksm_fd, "1", 1);
>+	close(ksm_fd);
>+	if (ret != 1)
>+		return -errno;
>+	do {
>+		end_scans = ksm_get_full_scans();
>+		if (end_scans < 0)
>+			return end_scans;
>+	} while (end_scans < start_scans + 2);
>+
>+	return 0;
>+}
>+
>+int ksm_stop(void)
>+{
>+	int ksm_fd;
>+	ssize_t ret;
>+
>+	ksm_fd = open("/sys/kernel/mm/ksm/run", O_RDWR);
>+	if (ksm_fd < 0)
>+		return -errno;
>+
>+	ret = write(ksm_fd, "2", 1);
>+	close(ksm_fd);
>+	return ret == 1 ? 0 : -errno;
>+}
>diff --git a/tools/testing/selftests/mm/vm_util.h b/tools/testing/selftests/mm/vm_util.h
>index c20298ae98ea..ba84ec17d04a 100644
>--- a/tools/testing/selftests/mm/vm_util.h
>+++ b/tools/testing/selftests/mm/vm_util.h
>@@ -129,6 +129,13 @@ static inline void log_test_result(int result)
> void *sys_mremap(void *old_address, unsigned long old_size,
> 		 unsigned long new_size, int flags, void *new_address);
> 
>+long ksm_get_self_zero_pages(void);
>+long ksm_get_self_merging_pages(void);
>+long ksm_get_full_scans(void);
>+int ksm_use_zero_pages(void);
>+int ksm_start(void);
>+int ksm_stop(void);
>+
> /*
>  * On ppc64 this will only work with radix 2M hugepage size
>  */
>-- 
>2.34.1

-- 
Wei Yang
Help you, Help me

