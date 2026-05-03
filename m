Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7CE1FFF886F
	for <linux-mm@archiver.kernel.org>; Sun,  3 May 2026 08:48:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AFEB16B008A; Sun,  3 May 2026 04:48:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AAFD06B008C; Sun,  3 May 2026 04:48:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C5596B0092; Sun,  3 May 2026 04:48:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8D3696B008A
	for <linux-mm@kvack.org>; Sun,  3 May 2026 04:48:46 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 03936140989
	for <linux-mm@kvack.org>; Sun,  3 May 2026 08:48:45 +0000 (UTC)
X-FDA: 84725483052.02.2A37649
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 61337140004
	for <linux-mm@kvack.org>; Sun,  3 May 2026 08:48:44 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ImGibRl4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777798124;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l3pmWS7L+VYWVlN8X0tqCQdtc8CnKhY5jwhSR3zEZdg=;
	b=5d0zBMq115nf8OITRIyMb96Dp0LGJY5KUeMdt+mpl+nZIvAx4xsR3Y3/rlfh8puWf5Y4BK
	YN0RZSr95Fxkvv0oczjBlMm15/Xj9auoHmA/57U3yFCOml81diihPb3ZbQsCJZI6IOFipG
	0k1D1JcksUJyBRxybrNjzACVXplO6X4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777798124; a=rsa-sha256;
	cv=none;
	b=QXZesJahnHQ7yN+g2ah0MUWYCcrPN169D+iMFB1/b8+9dbaTv9hKdiZ3Swb9MREtjLXdNR
	Ie1dKunN58PglLt2lo9fOfeoClP2PdJT//54SbDHHkevga684bbXlG6zs/rFLvybCCTUKX
	c2dlKGRzsiERikWlfpbBjovrTZ925ck=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ImGibRl4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 64AF04192D;
	Sun,  3 May 2026 08:48:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53FA9C2BCB4;
	Sun,  3 May 2026 08:48:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777798123;
	bh=Wbux98YSlt9p4yMEYN/6OibBDq2tLkjqLsbaIfyloMI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ImGibRl4GZlBpEsgk89z5akvxGngy7i/7SEdecQsQ4Y3z2LkRW68bkdabl77lARru
	 6Bwm4bS3xqNdn/tDbw7O74JBIrsqWEM8lL39w040M6BtrN94FBhJkBYsWAmrAmouUx
	 YgPVuWE1RkPtPKVwJLkuOb+DYld/b7zxZe/Pnv8/lgBGcWNkchILygEPxbhtkC7Y8/
	 eViGATJVpH+o0/zdnO37KjpjmRH5VdRXsdVpavB6qpB687SbmJYdJLnmZIqlvJu/Gz
	 nhT/eoEOkslbrsWb2Zh8muryP/dI0LGx7Tm4mx+bmpYD1dZJRZCmml/KGeqjoJAxzY
	 3eBXcY4sGjRqw==
Date: Sun, 3 May 2026 10:48:36 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Vineet Agarwal <agarwal.vineet2006@gmail.com>
Cc: shuah@kernel.org, akpm@linux-foundation.org,
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, david@kernel.org, ljs@kernel.org,
	Liam.Howlett@oracle.com, vbabka@kernel.org, surenb@google.com,
	mhocko@suse.com
Subject: Re: [PATCH v2] selftests/mm: ksm-functional-tests: fix partial write
 handling
Message-ID: <afcL5KGuOuUev8by@kernel.org>
References: <20260502005702.593878-1-agarwal.vineet2006@gmail.com>
 <20260503060234.644650-1-agarwal.vineet2006@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260503060234.644650-1-agarwal.vineet2006@gmail.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 61337140004
X-Rspamd-Server: rspam04
X-Stat-Signature: pg71ijr1nkkwcem5d7egf3xbtb1ye8t7
X-HE-Tag: 1777798124-700228
X-HE-Meta: U2FsdGVkX1/TY6JMVAMbc7mU+KpvQcmZtd0snPMxeXAtQ8ijtAbbjuWKU4vlVtcRIyLcySSfSWlVD1c2v42KPp+QOQcgJXDBwSFG2uK7kCKM4cJsF4ePZQU+dOZ50aBbZS57OcDyCTwpWIaNhgRWFT6B+KXG0V73DBkmHMPqiZatSPb2/GLvVMJGys/MMZ3+cU1DQ0pct7clF+WS466nYVJi+rsJ72VNi+0dtCnZcmdJtilxoV8s5M/9QS/ba8nOcWQ0KLphNaq7LErCrKP7b8Xp8/gaaPpShWDLXsGBBFKd4CcZWS3FDAKbbITDGcUrI8AUyejbptaDKZgpQO3FGVMOaO1WeMe8L3iWEg3YHRyy2nq59ZmoILvU99VUIfdYZox2Qifkv2Cvh6kXVD40cQCq3U5/UQDjeeZl5ue78IE0tU9IyTdZaW2vCv7JTb0HsMuO5iBBORdXNyNj29PS/XaRepl652Mg2vpLbhVlKe/b+hG7avDo8pT42Se8abYofDtQ1tQbTek6jv0+0h3b7c9JdqN1qzypMpufiNZqVTOaR8uyRpVFi7xqrKuPtU3oySK37muCuERzh18JXrQB3gNmctfplAMFWBsL8sVMG0+SfsjE4FEeh7F0AtWPPF2pysUKMr+TkYlPejuepudwqQ8RoAQ5RkS2rwee76ZKDBGjIDMlIvgOseo8SLDHjwyzCPLr+huc3PVBBWkTzolbGyUB89ilVWpEKAQ17thQF5lzhRGJa6EN5eNY1kiyMS5+Suvv5mXYKgnkdG+SMd9c/Twf+zl+TgjJfKaCAeRnbooBp/GDxp4FwbhXZrTnHRUVj8nRFWqJV6rHfGUH7i2p71NqKd7lK5oVRIIUIA6GsnKia+YwNvF5Yq2pwB7vRRIeR/1oAeXoI7t70uqOv0MHbH6yagofjeds8DAWvKCI3t0clXmRpVQXv6Qgd4nt//t1vZGzUip1TOVm0aLqW3P
 dUh/gJdY
 cgjLBGN7UtGJFGwfVebNTGOXGQBR/l/ESwd0MkT9LBKTX8lrclAUQ9gqLIbJIn4x3gDJRJnMBp8vwGigpJCdgrOiNcxCU52klM8xBDZiDBAkdsDfU5Td4QVpbh8ut268Z/PUB0CUi0p04CJyihdi56yPaJcQzfbfRKe1fYrxht1qywvWioi35d5675M0HkvKSclUlXTPR7MpxQwQX0q5Sec1tPkLTsNhx8Lza4XyCK0l0ZmFvz4UnAqG4oR6OwYyRZofI/IuzFQEEGy/U0d5YkVUScVVBE7dsGrQ1wdY1v6l/y1V/LTlXQ+b47um+/QKDLzvCVD5sFPd2mffm/abhLtGKTRGms5zse4MDRpFZXmTEUqiGnLb5ihqNZhQF7LSyHN8g
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, May 03, 2026 at 11:30:30AM +0530, Vineet Agarwal wrote:
> Update write() checks to properly detect and handle partial writes.
> 
> Previously, partial writes (ret > 0 && ret != len) would return
> -errno, but write() does not set errno in this case. This could
> result in returning 0 and incorrectly signaling success.
> 
> Fix this by:
>   - returning -errno only on actual failures (ret < 0)
>   - returning -EIO when a partial write is detected
> 
> This ensures partial writes are treated as errors and prevents
> false success reporting in tests.
> 
> Signed-off-by: Vineet Agarwal <agarwal.vineet2006@gmail.com>
> 
> Changes in v2:
> - Fix incorrect use of -errno on partial writes
> - Return -EIO when write() completes partially

Please start a new thread for a new version of the patch.

> ---
>  tools/testing/selftests/mm/ksm_functional_tests.c | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/ksm_functional_tests.c b/tools/testing/selftests/mm/ksm_functional_tests.c
> index 9a8c852acd68..c80254cda926 100644
> --- a/tools/testing/selftests/mm/ksm_functional_tests.c
> +++ b/tools/testing/selftests/mm/ksm_functional_tests.c
> @@ -507,9 +507,13 @@ static int start_ksmd_and_set_frequency(char *pages_to_scan, char *sleep_ms)
>  	if (write(ksm_fd, "1", 1) != 1)
>  		return -errno;
>  
> -	ret = write(pages_to_scan_fd, pages_to_scan, strlen(pages_to_scan));
> -	if (ret < 0 || ret != strlen(pages_to_scan))
> +	ssize_t len = strlen(pages_to_scan);

The v2 diff should be against the base, not against v1.

> +
> +	ret = write(pages_to_scan_fd, pages_to_scan, len);
> +	if (ret < 0)
>  		return -errno;
> +	if (ret != len)
> +		return -EIO;

Just return -1 if write() != strlen(), the actual error code does not
matter anyway.

>  	ret = write(sleep_millisecs_fd, sleep_ms, strlen(sleep_ms));
>  	if (ret < 0 || ret != strlen(sleep_ms))
> @@ -531,8 +535,10 @@ static int stop_ksmd_and_restore_frequency(void)
>  		return -errno;
>  
>  	ret = write(pages_to_scan_fd, "100", 3);
> -	if (ret < 0 || ret != 3)
> +	if (ret < 0)
>  		return -errno;
> +	if (ret != 3)
> +		return -EIO;
>  
>  	ret = write(sleep_millisecs_fd, "20", 2);
>  	if (ret < 0 || ret != 2)
> -- 
> 2.54.0
> 

-- 
Sincerely yours,
Mike.

