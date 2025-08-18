Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DDCDCA0EE4
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 08:10:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C6D28E001F; Mon, 18 Aug 2025 04:10:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 677408E001E; Mon, 18 Aug 2025 04:10:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 565608E001F; Mon, 18 Aug 2025 04:10:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3852B8E001E
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 04:10:47 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D74581A0875
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 08:10:46 +0000 (UTC)
X-FDA: 83789156892.29.526B7F5
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf23.hostedemail.com (Postfix) with ESMTP id 26AD814000B
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 08:10:44 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf23.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755504645;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uoiJ/lC1TK/+M9R4zevIt03hbpOpgCvsw2B5DpdaGTc=;
	b=XTdfclOSytP2m8BEkY4qxr/aojl1A4tOJI7fi9Xa2McRFJNlA2sQSASS4eBk1gfPKfwxIo
	jbADG1XVgBWS3uzv+JEtcbRZ49boVoj1J+otpqCG0v9OFp2VidmZgUWncC5HOBiWj9pS04
	50r4dHqu624DEtSb9jbc2b53g7kmhxw=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf23.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755504645; a=rsa-sha256;
	cv=none;
	b=hMxhVHLNVAJiRZ1cfhYi9J9HQy9IRQ5f/fmSa4qgOL7qClArX8+9Kw5iAQcUdARO5ycBn6
	Jwa7oqaOb5nLrV0BdnlSf/6H0ODY3CJ82QNuSBwEEiT4ETFXAIg+pmxcEgtbkX+RX18CbY
	MDsh/SfPGPDdeyPh9ny1fAyrYZVKnHI=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1A5491596;
	Mon, 18 Aug 2025 01:10:36 -0700 (PDT)
Received: from [10.57.58.12] (unknown [10.57.58.12])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C2E943F63F;
	Mon, 18 Aug 2025 01:10:38 -0700 (PDT)
Message-ID: <c09a2a13-8571-44e5-b780-c704598df764@arm.com>
Date: Mon, 18 Aug 2025 10:10:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/8] selftests/mm: Add -Wunreachable-code and fix
 warnings
To: Muhammad Usama Anjum <usama.anjum@collabora.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, Leon Romanovsky <leon@kernel.org>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt
 <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Ghiti <alex@ghiti.fr>, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-riscv@lists.infradead.org, Shuah Khan <shuah@kernel.org>
Cc: kernel@collabora.com
References: <20250731160132.1795351-1-usama.anjum@collabora.com>
 <20250731160132.1795351-2-usama.anjum@collabora.com>
Content-Language: en-GB
From: Kevin Brodsky <kevin.brodsky@arm.com>
In-Reply-To: <20250731160132.1795351-2-usama.anjum@collabora.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 26AD814000B
X-Stat-Signature: a66bj3p5ap6c5wrrkz8hrnhu7xh5urpj
X-Rspam-User: 
X-HE-Tag: 1755504644-969024
X-HE-Meta: U2FsdGVkX1/A7AfFCoTcNH6xv3Gsyoww/mrUGSBPBaOaotNYiEr9jxv6WbF4XYsjgw0DwhiOu5akuwUE8+ZW8hiY4xiIrQUATgUrsniM9KbIjm1o48rv5cX5FMC5Opqy6dRNnaL/OOVyn+3R8U+QSG5fOxbXBEEm889Yvrlq9Oafn13rEhXlt5KOVbGSE4yiCTskggT0rpkvPYLhozpbOVH+QVnvi4E76Su7QMAuGxQkmdWD4hvABmIxuVZ5r+nVVpFcRs0j0vJHmg23BlgdaGi3paKYMtY2hMayooa/8O+tz6lKozL5jq2joLkK42WgiMOaL7gWuxHNOdSen6E5SftB7Kx+8Fa2DYlZrCssc4dqJUP76FSbme+bEC02Yc921+eiixJtVlPvA/ZI1ym2BUgskriwLEoaRaK0OqDTARfSlcK57o8PEFIvL1Pzeq3iHJ2WirDNV61QcFUEL4bCpRTYiY44jOsZTyJzhdqoD8luwExA01CDEuelAEw1OcnwDMFvhxkPaoUZ3ELNuS7n9Y7kJMCObFuSeg+1feAi0jTkAc8okmeT8CJRewZC8mO5xaqzeu4DBTzdYGjcd3Z8uGOh2CZtgXCmxlVoXKYv0IxkLVtlp6XRbJGQeH+3Wy3W6iSOjoZkLQ4gxAXgWPvCGboZAhkRdkZrwAqP+IfV9uTSE44i8oPNyi0tx6OnW6FAJi6NTnHVEZcnnPIoAhavey/0Ifq7/CLwqGDt+DgdasNA7YkZhhca07uK3nA9Jr24YT37XBnfesDneY2/liatTDYChsgmSSeiWqOF6xOgYO+jtdMxQddw2tqipKptTc9zWdK7DemShfKfwp8rueKsnPI9NDQxf9R/X2BoECob4OD1RxciizCCJMYIn8FE76eaL1RXTj8gEZupJdxYxrWNAvQRqUFyl92y4EpSo8Kdo4kGHsDharEo8dUD/Azkcc9LWMQSPE5Lf9pYkZW0In6
 njx2pwnl
 t0qlX1OMQBcojF/9h/2E8kr0RDwokAnEZ9iqO97Nk2P5E+FiJBSVTQHQz0yeB3t1uzjf/yRaItLNfNGHOueIsyt3lvJpblj7uyU1Ex0zeq08QlIAFa0qVusIQ63kg3zxVA/cYauog/BnKcQg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 31/07/2025 18:01, Muhammad Usama Anjum wrote:
> [...]
>
> diff --git a/tools/testing/selftests/mm/pkey_sighandler_tests.c b/tools/testing/selftests/mm/pkey_sighandler_tests.c
> index b5e076a564c95..302fef54049c8 100644
> --- a/tools/testing/selftests/mm/pkey_sighandler_tests.c
> +++ b/tools/testing/selftests/mm/pkey_sighandler_tests.c
> @@ -41,7 +41,7 @@ static siginfo_t siginfo = {0};
>   * syscall will attempt to access the PLT in order to call a library function
>   * which is protected by MPK 0 which we don't have access to.
>   */
> -static inline __always_inline
> +static __always_inline

Thanks for this, I had this fix locally but never got to post it!

>  long syscall_raw(long n, long a1, long a2, long a3, long a4, long a5, long a6)
>  {
>  	unsigned long ret;
> diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/testing/selftests/mm/split_huge_page_test.c
> index 05de1fc0005b7..a85b2e393e4e8 100644
> --- a/tools/testing/selftests/mm/split_huge_page_test.c
> +++ b/tools/testing/selftests/mm/split_huge_page_test.c
> @@ -296,10 +296,8 @@ void split_file_backed_thp(int order)
>  		ksft_exit_fail_msg("Unable to create a tmpfs for testing\n");
>  
>  	status = snprintf(testfile, INPUT_MAX, "%s/thp_file", tmpfs_loc);
> -	if (status >= INPUT_MAX) {
> +	if (status >= INPUT_MAX)
>  		ksft_exit_fail_msg("Fail to create file-backed THP split testing file\n");
> -		goto cleanup;

At that point the mount() call has succeeded so I think we do want to
keep the goto and just print the error message instead of calling
replace ksft_exit_fail_msg().

- Kevin

> -	}
>  
>  	fd = open(testfile, O_CREAT|O_RDWR, 0664);
>  	if (fd == -1) {

