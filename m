Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44D53C5DF7D
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 10:08:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 595286B024A; Tue, 18 Aug 2026 06:08:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 56D096B0259; Tue, 18 Aug 2026 06:08:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A94C6B0399; Tue, 18 Aug 2026 06:08:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2B6696B024A
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 06:08:20 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B37C7C0BE4
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 10:08:19 +0000 (UTC)
X-FDA: 85113965118.21.03E96BA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 2526C40002
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 10:08:18 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Uc/qV7oY";
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787047698;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/4t/bDE7rcjEi5t4t3vOwOyHYRygnB/uX4wHouL9xHA=;
	b=kAhRsMO/0pkpDLQf3DSuCnCz55ccoPEkTkkyJL6uvKmdqrl3iYPMsV51L6SKVb/CMiLrCg
	q7TDhsHKHh50fVwyYGHEeFTnGXEMy2ay/kIp9IutnGUdnIhDSYfPUCYYej8zsidESEoVMn
	iuMRMzCuWeDNJIxZ5GJ20UWEvVNZD0Y=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Uc/qV7oY";
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787047698;
	b=daMCksTjohU0WXsQEcC/63Z8W4CBlwl9BftKRuaydIiK9cC5rcYnn2i8lnjUy8Rw+qhc/2
	b0avOdXdAgnTFXGcP+1SmN5WTRSH91Irv3b0R33cUjZfpf5UjBEy7eNhv7Ppvt1by+ZKT4
	rZdOcY4wv3U7MUlFRf255uNSZx48tSw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9CE0F601DE;
	Tue, 18 Aug 2026 10:08:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 391831F000E9;
	Tue, 18 Aug 2026 10:08:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787047697;
	bh=/4t/bDE7rcjEi5t4t3vOwOyHYRygnB/uX4wHouL9xHA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Uc/qV7oYLiyVF0C4wibZEvrPWZNgwBtainG7IQM9ba54WyDn1pQSYg4tcphUhWnFd
	 os91d/pOtaZmrBDEn66FgCi0atcx5YGqbCshdHCUQjdqXmdt+StxpMlZ7IjfYpEpUr
	 ZDCGoV5+bGmNJOcSc3PkVu1TH+PW/68hmU0VoHXXteZroF9BwTfjb0r3l6AnWY5KYG
	 0T+QJzZfl48P8AlNvebUeNbG0BQDGZ2gaXFRLPcwVAphS4Ii6IGtIPwYV4WtGLUNvQ
	 vq2fLX/stzLjz205Cl8FFyavTfLRo9TlrMDnkU8WvehpONFahKHIORFb7Bv4ieIF70
	 1bE3lry/MLxSg==
Date: Tue, 18 Aug 2026 11:07:55 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: akpm@linux-foundation.org, david@kernel.org, nico.pache@linux.dev, 
	baolin.wang@linux.alibaba.com, baohua@kernel.org, dev.jain@arm.com, hughd@google.com, 
	lance.yang@linux.dev, liam@infradead.org, mhocko@suse.com, rppt@kernel.org, 
	ryan.roberts@arm.com, shuah@kernel.org, surenb@google.com, usama.arif@linux.dev, 
	vbabka@kernel.org, ziy@nvidia.com, usama.anjum@arm.com, agordeev@linux.ibm.com, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kas@kernel.org
Subject: Re: [PATCH v4 04/19] selftests/mm: skip khugepaged page cache cases
 without a PMD folio
Message-ID: <aoQuhSq-2Bd3Kz67@lucifer>
References: <20260815015901.1236937-1-kirill@shutemov.name>
 <20260815015901.1236937-5-kirill@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260815015901.1236937-5-kirill@shutemov.name>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2526C40002
X-Stat-Signature: 4grxibo3s3xhhyxz4yoi6hq68ft1ke3y
X-Rspam-User: 
X-HE-Tag: 1787047698-361272
X-HE-Meta: U2FsdGVkX1+2fZiDpd33zI6mLcpYVK/iub9E5lFgylFVKa2wqtZ0n6ja0qmtAni08cjBEskYOM2/aJmGB2YGB7XI34y0IrlEHWoVfEuT4tO7oM5/tKZ+sduLFT5YPGfUDi1QpqZvgVzPj0jgHOHKou27y6olclWRx1ZPG5Ppg7UAwH1+zyrKpN1Jg7/XPR2vrWhATfdhNkL3arqD2gWNNaFvsxAldOeIsO+IiNcLDEKYgejPhytuxhK4Aw+JKbTE0Ta8ucPVIVY++N1qSLGAY7szrmMWUUV3CGUfVYrswn/rMoEcvRCmp/hD29NYSEdeljjOnc3Muh9lyY19nrKvG9V/cRU8eD30QWwNwQcuX41PiGM7FoaM+WutD1Suu6OPeh9W61PKGe7xucFsh/ZMHGjdAM2D+R36XBUhUU6MrMesqEpthX5KJ9VPlwUGDCDyNSqueLOeH5czzJsutHKI0Cf/JbEV4p7Pljg+gbFgaV64jfMhLJx+REWXJuDCG4XR1/iPp7B2yERjw5Mx+/oB2TxBdHRrfnKFfyPa/Wjioev8zBNx85WueBCsTC/aJt4xFsa8BiX+U89gWiGbEXbzvIus+6bGa3pmkzBboD3tDJPc896UfO71tJRlfZAnWlKTa7utqNQ668eeA/7S8LI9+Wyk6IoJc3Rme8VRKcs43T9PZMaOf0Y+W8TZT34leBsUkWKkI9DJEUYhe702SJ02ZRGaTU5BIZlGntTwcsWYl61I8piQo9Ux46paz7uV4udFbuiMMJRF6HK2EFg839VVbGtrBBhMyhtqmhXQ0OHlApgYfHlu6FgvdS0USSMZrkyhfcIMwaKvBFkZfUFj2e47ABD9DJaJl0xkrFvOvnoaRaLohPRnfEbGkJ5dMOn9pQ0tU8e9gI1c7Z9gmIsXZxdkH1051RLWFFq20K1WxWvM6nc3HKfrTD0V3qSGobyCqtaN/ATwF0MYOdWxZ6jtDbU
 7B5EJf4Z
 voE+6wznPxiVSgoDJRiV4zcWVSqa1lRAzPJrQNnVx1lKfPSkvFuZxcvqf+C+bE1o//FlyaZ3lkQ/lqNdw0bdNWtCNRc/QpgU9j2vzxxzmt2tZKNUSNVRjVeJQHyiFx4mPlkeg+I311CQ8lnvPT/JrA6nuPqbShRk8JcVZofcK8pRCYNSC/9OBNwdg7EpKWT171g+pumN4q/M5EIFBHfyrmkg34ySvo61e6FIavHg+Cnj/4W1Jc/Auvxm4cQrB6eL3/uChqKKBYzogwv15qd6MO6R1NM9TWRumhBfuSOyZUDoefBpXV9qrpShD4DIc3guoHm8l+GEeLARj3AZLYz3DKtjKxw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 15, 2026 at 02:58:46AM +0100, Kiryl Shutsemau wrote:
> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
>
> The page cache caps folio order at MAX_PAGECACHE_ORDER, which is smaller
> than the PMD order on arm64 with 64K pages, where a PMD is 512M.  A
> PMD-sized page cache folio is impossible there, so MADV_COLLAPSE answers
> -EINVAL and khugepaged passes over the range.  The shmem cases ask for a
> PMD-sized folio anyway, so four of them fail and the run bails out in the
> middle.
>
> MAX_PAGECACHE_ORDER is not shmem-specific: it caps every file folio.  Skip
> both mem types where the cap is below the PMD order.
>
> Anonymous collapse is unaffected: its orders are not capped this way.
>
> Assisted-by: Claude-Code:claude-opus-5
> Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> ---
>  tools/testing/selftests/mm/khugepaged.c | 24 ++++++++++++++++++++++++
>  1 file changed, 24 insertions(+)
>
> diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
> index c499804a0ec4..ec5c36a19d92 100644
> --- a/tools/testing/selftests/mm/khugepaged.c
> +++ b/tools/testing/selftests/mm/khugepaged.c
> @@ -1357,6 +1357,30 @@ int main(int argc, char **argv)
>
>  	setbuf(stdout, NULL);
>
> +	/*
> +	 * The page cache caps folio order at MAX_PAGECACHE_ORDER, which is
> +	 * below the PMD order on arm64 with 64K pages.  A PMD-sized page cache
> +	 * folio is impossible there, so the kernel refuses these collapses by
> +	 * design and there is nothing to test.  The cap is not shmem-specific:
> +	 * it rules out regular files too, and the per-order shmem_enabled
> +	 * controls exist for exactly the orders it allows, which is what makes
> +	 * them readable here.
> +	 */

This is a very schloppy comment. Can you trim it please?

> +	if (!(thp_shmem_supported_orders() & (1UL << hpage_pmd_order))) {

Is this inferring file-backed khugepaged behaviour from shmem? That seems iffy.

> +		if (shmem_ops) {
> +			ksft_print_msg("no PMD-order page cache folio: skipping shmem\n");
> +			shmem_ops = NULL;
> +		}
> +		if (read_only_file_ops) {
> +			ksft_print_msg("no PMD-order page cache folio: skipping file\n");
> +			read_only_file_ops = NULL;
> +			read_write_file_read_ops = NULL;
> +			read_write_file_write_ops = NULL;
> +		}
> +		if (!anon_ops && !shmem_ops && !read_only_file_ops)
> +			ksft_exit_skip("Nothing left to collapse into\n");
> +	}
> +
>  	default_settings.khugepaged.max_ptes_none = hpage_pmd_nr - 1;
>  	default_settings.khugepaged.max_ptes_swap = hpage_pmd_nr / 8;
>  	default_settings.khugepaged.max_ptes_shared = hpage_pmd_nr / 2;
> --
> 2.54.0
>

--
Cheers, Lorenzo

