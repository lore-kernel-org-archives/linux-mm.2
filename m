Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D54FACD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 03:51:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 01CC46B0005; Tue, 19 May 2026 23:51:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0FEA6B0088; Tue, 19 May 2026 23:51:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E252D6B008A; Tue, 19 May 2026 23:51:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CFB756B0005
	for <linux-mm@kvack.org>; Tue, 19 May 2026 23:51:58 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 61A971C0045
	for <linux-mm@kvack.org>; Wed, 20 May 2026 03:51:58 +0000 (UTC)
X-FDA: 84786424716.15.4C5B230
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf02.hostedemail.com (Postfix) with ESMTP id 4DBDA80002
	for <linux-mm@kvack.org>; Wed, 20 May 2026 03:51:56 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=hlNRoVp5;
	spf=pass (imf02.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779249116;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ph0XvCM6/VdjegM/2oXVeKQWFIQHv6U/K8IafODl/ZU=;
	b=IFjnsXsKQ+NelOjuPPsZkUv6AdQZuRbzQ4fYInMHQvsUgZWQek++KxJSWTcr2drYWo6wyG
	/xoBUvXfptnYIMuaZpIjdPS7+b3678mhvQ9/dyCiFBgXCR7gQ/lW3SNzQtsr4Oqco/U4vN
	LJB/3DpvUnpDJJoq5D/OrqwH8sRmuo8=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=hlNRoVp5;
	spf=pass (imf02.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779249116; a=rsa-sha256;
	cv=none;
	b=CxmkuWtY6/5u19GfxhmeJPKKgnbl/sY6VU6e9PU0fORGazBo6bVdD6aevXNMJWTu9DTIVH
	elhImRV7XEFHvZCyrFjVIvEcXkUIg+Z7yhEFvbICutp0SgBZuwxVNhAeMi4WMTmjX4Skwd
	I0EaHkLSA4FlzExyFo+X14+SlaKBSv8=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id ACB5B355B;
	Tue, 19 May 2026 20:51:49 -0700 (PDT)
Received: from [10.164.148.41] (MacBook-Pro.blr.arm.com [10.164.148.41])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A28B63F632;
	Tue, 19 May 2026 20:51:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779249114; bh=yEbIQ9nxo7JieyUNEu66PQIHHUZxcpqB7kKk/0SWI7k=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=hlNRoVp5NYQgmkQYXQZO45ye6Ka3/z/qUpMLTyclSLGvip0xjeTgt/hW/2yPXVbKa
	 rgazoQan+iiP28XFyP14qz+Rj9Dm/W1ariN0JG6jPhp/xSy2X2P2FVxX3p0/OC8zYU
	 IKAvfkEQ2u+JyVugakiXQsMXeDF0k8/ptCAS6vZ0=
Message-ID: <20518530-12e3-4731-9b4a-54cc950239e2@arm.com>
Date: Wed, 20 May 2026 09:21:48 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests/mm: close fd on write error
To: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
 david@kernel.org, ljs@kernel.org
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org
References: <20260520020336.28914-1-richard.weiyang@gmail.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20260520020336.28914-1-richard.weiyang@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 4DBDA80002
X-Rspamd-Server: rspam06
X-Stat-Signature: 84mz1uekw76x9drzdk8utiibjn91tkk8
X-HE-Tag: 1779249116-806757
X-HE-Meta: U2FsdGVkX18nweK5aYyiqphtv/f/GKi7Nj6/DSXTXEpNqtXymgOruJfOzgZRdYggL5AhOIsJu47AjoKghtFxLHx6O/svarRIDmU9tsvzX3n/bP2g19EVj2UEbV13OwFe0qMlj7Q3X39vT/n8nCxuYRUUxvXy/QGFf+8H1TwSXjXPOwm6Hp4KUZXYlf+gcwxk2t48bYwNMlwJNkhmCN3PcdCcLt2ULgWeeTXqZ2rmVD2nLsK1ulVfFTPSk3odeCbXWdc8WdRr7SRvv7qg/Z4zDVolO+uNtfR50mF1IOQrd2sN62SJwwmcIkc8qNp3+xlJlQ8LZyUUdU7d3oGJwiMNAOGv+7PUHmJ4uz2hjDabITMJRhbi9pDDIOKZNs3+SznK9cH31a56XolmPqhWvCr3GyQnDYe7t9QHTD6paJtIGNdKQgrf/K+fbRP73B6zNIXJ+nqkxbskj35O3ptsn45zgQMv4pXu6wpwbAoUy2xp5UXrnPku8AlsdmSA80d60ZJvKVF3smYOm01yF5bR4TMb6Ah2ZD6clZn9MIRB51y6xNPNLH9fXiX+MqmVK0gkYEtpvrBHpt68ZHbxucUPMD+7RhXI2xbrmJxfdxkvsa8s4JOdrNkbmh1b+yzHwtGfg8yn0RFdsNndMJZTq3wviaRznCXVxBHql/JoQpF8rADbixU8Xcpc1luu2gHpWVpf5Tr5Zbd5xlLWFsxwb3IWD4fh10kP6NJ0gf/tyYAEfnbM0uLp6bN675ZbfqYlgFJVXcNimWNawrPjWnsJFfhG/VgqRT+lcSVfIeb39sN5cdMJ/w+i6HnQp5yu+f0O8Sp1TfBVL7JXL654Dp2uU5wvfGZY6Zi0cEZQr9S+5uc99bkX7j3uAydZ9Z08BvS6h+D1Dp2zqVAQakT1QJLaR9le1t0qlhhint7ql0ofaWpDcbh+r8cnZbL4Ls6xmBrEf0QZsDjsxr5UTe9HcS0kJjAzao7
 6g8DjjvB
 fWDofRnpc7W9DWPE34LQtboMGPLnCODtWG1KDFGZZ+eXqmaDnuZg1ikrOfm443Lkt2MMPV07+2rQsTN8g2SkvOWBpLFVmYiRlXpArb3W1rcl/DDXbqSLCeORbmF0qfnUMt9xAr4AZrHaasWQeEg2N3rZ05VZQ2v15MEXpoM+DCBgUmrDvZnvV8LjcAOsrFATPHbPhKwZwqY2Yp627Ez8b083IgH23jq70OBSFGL04Kru8Ue5a76xbyjtdvCPpgOyVw6Uvn1Kbm+jHMjKZxr6s7WPjIS3hkAA167QefftznFdi65lsvSVD09E2Xy14yek5qtnAKMwfx0snb6al+OlYDRk9rnh1TzzP0xb4+UcmVfGtf1cHpfnhAHUqXAL6dLz7myUs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 20/05/26 7:33 am, Wei Yang wrote:
> When create_pagecache_thp_and_fd() write returns error on
> /proc/sys/vm/dropcache, it just "goto err_out_unlink", which left fd
> still open.
> 
> Use "goto err_out_close" to close the fd.
> 
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> ---
>  tools/testing/selftests/mm/split_huge_page_test.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/testing/selftests/mm/split_huge_page_test.c
> index 460fa1f606fd..f30402ece608 100644
> --- a/tools/testing/selftests/mm/split_huge_page_test.c
> +++ b/tools/testing/selftests/mm/split_huge_page_test.c
> @@ -469,7 +469,7 @@ static int create_pagecache_thp_and_fd(const char *testfile, size_t fd_size,
>  	}
>  	if (write(*fd, "3", 1) != 1) {
>  		ksft_perror("write to drop_caches");
> -		goto err_out_unlink;
> +		goto err_out_close;
>  	}
>  	close(*fd);

LGTM

Reviewed-by: Dev Jain <dev.jain@arm.com>


I asked AI and it points to another problem:

for (i = 0; i < nr_thps; i++) {
	if (is_backed_by_folio(page_area + i * pagesize, 0,
			       pagemap_fd, kpageflags_fd))
		continue;
	ksft_test_result_fail("THP %zu not split\n", i);
}

ksft_test_result_pass("Split PTE-mapped huge pages successful\n");

"If one THP is not split, it prints FAIL, but then falls through and also prints PASS.

It should probably jump to out after the failure".

>  


