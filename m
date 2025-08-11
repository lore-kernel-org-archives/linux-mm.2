Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AF6DC87FD2
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 05:58:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9ECDE8E000B; Mon, 11 Aug 2025 01:58:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 976998E000A; Mon, 11 Aug 2025 01:58:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88C248E000B; Mon, 11 Aug 2025 01:58:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6B0668E000A
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 01:58:13 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0B12F1606A4
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 05:58:13 +0000 (UTC)
X-FDA: 83763421266.22.E84C77B
Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	by imf21.hostedemail.com (Postfix) with ESMTP id 534171C0003
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 05:58:08 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=KFYgXbQF;
	spf=pass (imf21.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.98 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754891890;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0C3hCm+JNiGuI6HbOQmG4qjQ3sCeDoELSpNLPNRDQso=;
	b=tXcOF5Wa9qsN55QCpDPQ4GSL00ZoPSHne55e1qCfrKqan3LndMDPOk4OrGgCoGZLHoeiQ3
	bg8WXSdnJaaBZ6TxVq0N1zjvO+MsRiNCBzz9O6Fizgy02v9kw3fL+p80Q9+alR5yKhveWg
	kw6f5xIq4sx5RQAl3KBc/lZNy7c6E6o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754891890; a=rsa-sha256;
	cv=none;
	b=eHzOn9ou91cJgyTjlmPv2bLyztHCUOoHnsevdhEdD1FUuv4Qq2tiADqfZnIoZMr1IstoCv
	r6uZy6oAVnDsA0PJW5DQqhtv5PtTsYpUUva6CoaWAaiL3rk5OXo/k58m/+LBSLaFWfK4nJ
	v4oRBXrEyuPTJi5mkyYg+D08fz20ShQ=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=KFYgXbQF;
	spf=pass (imf21.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.98 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1754891885; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=0C3hCm+JNiGuI6HbOQmG4qjQ3sCeDoELSpNLPNRDQso=;
	b=KFYgXbQFN+CmrQLCixOSsU2pmM7/4PuRadxtfqIeMeMWB4riIFsuw/6I+fXN/FpAbvylvLspSC8DkRWa0Wvwp6q0VP6I0Qmou27joiug6WHGjlsjjgxm3U+65W/SwORIuw7CoPVJHzVRtwpC9FdQwB0HC/vzfV5Dlfw8Cv4Q0/M=
Received: from 30.74.144.118(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WlP-qS3_1754891883 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 11 Aug 2025 13:58:04 +0800
Message-ID: <791ef594-a2e4-4d21-bb9a-970ad32c252f@linux.alibaba.com>
Date: Mon, 11 Aug 2025 13:58:03 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Patch v2] selftests/mm: do check_huge_anon() with a number been
 passed in
To: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 Donet Tom <donettom@linux.ibm.com>, David Hildenbrand <david@redhat.com>,
 Dev Jain <dev.jain@arm.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Zi Yan <ziy@nvidia.com>
References: <20250809194209.30484-1-richard.weiyang@gmail.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20250809194209.30484-1-richard.weiyang@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 534171C0003
X-Stat-Signature: csimk1s9gtpgmam8ksys98antxf8kigh
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1754891888-753683
X-HE-Meta: U2FsdGVkX1/8FUCr5ujyeCXSyXX/suU4Jq9Av5JMji18/dQDU9/JnJlVKL4GhJkJXG0T+j/H6p/47cKlQAQwL7iC/Ri6qBqUTYiyGsjGEMxxoVph/NVF6TioPPWxnJ8QhOZgzGENr9L8UboTcaud7GJyThNpAggMh2JX3pi0JIHzlsNsuOH6LdeqDL/2aRVuMoDQQatriFufKQNmIW71gePilXXWy6EoMg4wjTpkMwY90Me/xdmq/81F8y+KdJxDTdZgdezIXCF78L5OwMXkwluJjPDI9H9/8AQJPZfLPq+6PsE3xwnqSKFk/Kqf3IDyAevaQNqN6FqL/CTNrbHPs7MDrFtOBKlbEXfJOv1xU+IolEd4TTMhWetSasqS1+kjE6F1+N4d6Py6LxzcsebYPUNMKJ/kBLhLtJyBJxP0U6nRyyKIlrr++NwcrAdXMGTEImeBdeS8PU9EzyhoSuPd+PRupveGqlAbP6e4aXKCOflg75C+Her3ZJHMTxH1TrWmXt3nbYeirZG4MoH5VusXARajttUAv7FegsBNfvEuT7J5sjlwywnzGjuVMHqaVaai4uRy9+qls4At4jk14WKT8xt3ywyyx6nDC5Ay4FHjELXky6MDj0Sz5ePs7WTy7yzSsKsMLvGWCwsy3qZMMfc+9MT17Q9m5KboULPsgDPtI567MMVneDrwl84CgBgfmyN8LeKo2vLy/7+9jgxmh+DeFm5POzu7ojCt523DzmZsQquUV3ddrnXSO9WV/zsIvoSWsdN0LV7Qa+CqeHbP8pqcNwyMtKRHHRb7gzLfyFzbwvpRKvczpG3ShfrpgHclzsYHa/TJw9yEh7ll5RiSkFhD5m8WpVv9ZL/Rj7LHIWzxyxCvIFc1D+HIPoSZoFUzSUp641I3mii+Ce28t2reFpQpQJ6XDxpSiVE5hvQwKr+zoi6kmmQkYtgxJdkqo9J7hGy2ZC7ZES8qtxrIjronfzX
 yAH5onqh
 gSRC0ufdDFOlQpju5aEYOA5TrzlDf1CymsWFOOa+yK2mpvUAxykTF/fMcjAzEF8RPnk6gM97ZcxiBb62NDN3drMOMsRySz76/wApHOuynJ4AmdmgZP0rKvIgOIS7qD9ar4zDvMyLkntCiL2cuLF768S3wuJPJ+Mm0Vc9QbBkS1OJJVIfn8WmKhG2EUF9Kktw92CYrFEAuvhDhFXQiKPuZi3J4JqMYzz6viSLqpPA3U+rM2UO8UjeYaT1e2QSNGZ6siXwdFtlAGgz3fRoZFADkb13hOoEBjJo2SmyPe2JXYqomeLJ57sN7RavjfrvK15wevqaNXU3f+cR3fAWZi5dGN0o7edtqa+YyETvl0ReTDvC9Ick3gFV57z4GBkThkmkiA81OtTqn6b2gWc/lU6tks4HW+nTFTgZ15rrtgq3hNDPn3y5fJvT/qsxJDHkC4i3nAi1qNsm9SNtQTwBv6Paz5jd/SQazDa1SCva/bNrFSjsN+FTXyEzg0Vzw0s7Heqm+horBsFBuwdGjAtL244NAnWyrhxu7mvEf2m6fp+t3QOZ4VRT8+gk6ebYX+peYA6idOdLc40c41uQDe2JVEnBH4qeJ7g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/8/10 03:42, Wei Yang wrote:
> Currently it hard codes the number of hugepage to check for
> check_huge_anon(), but it would be more reasonable to do the check based
> on a number passed in.
> 
> Pass in the hugepage number and do the check based on it.
> 
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
> Cc: Donet Tom <donettom@linux.ibm.com>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Dev Jain <dev.jain@arm.com>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: Zi Yan <ziy@nvidia.com>
> 
> ---
> v2:
>    * use mm-new
>    * add back nr_hpages which is removed by an early commit
>    * adjust the change log a little
>    * drop RB and resend
> ---

LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

>   tools/testing/selftests/mm/split_huge_page_test.c | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/testing/selftests/mm/split_huge_page_test.c
> index 5ab488fab1cd..63ac82f0b9e0 100644
> --- a/tools/testing/selftests/mm/split_huge_page_test.c
> +++ b/tools/testing/selftests/mm/split_huge_page_test.c
> @@ -105,12 +105,12 @@ static char *allocate_zero_filled_hugepage(size_t len)
>   	return result;
>   }
>   
> -static void verify_rss_anon_split_huge_page_all_zeroes(char *one_page, size_t len)
> +static void verify_rss_anon_split_huge_page_all_zeroes(char *one_page, int nr_hpages, size_t len)
>   {
>   	unsigned long rss_anon_before, rss_anon_after;
>   	size_t i;
>   
> -	if (!check_huge_anon(one_page, 4, pmd_pagesize))
> +	if (!check_huge_anon(one_page, nr_hpages, pmd_pagesize))
>   		ksft_exit_fail_msg("No THP is allocated\n");
>   
>   	rss_anon_before = rss_anon();
> @@ -141,7 +141,7 @@ void split_pmd_zero_pages(void)
>   	size_t len = nr_hpages * pmd_pagesize;
>   
>   	one_page = allocate_zero_filled_hugepage(len);
> -	verify_rss_anon_split_huge_page_all_zeroes(one_page, len);
> +	verify_rss_anon_split_huge_page_all_zeroes(one_page, nr_hpages, len);
>   	ksft_test_result_pass("Split zero filled huge pages successful\n");
>   	free(one_page);
>   }


