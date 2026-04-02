Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63089CC6B20
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 08:05:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E6266B0088; Thu,  2 Apr 2026 04:05:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8701A6B0089; Thu,  2 Apr 2026 04:05:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7380B6B008A; Thu,  2 Apr 2026 04:05:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5CB816B0088
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 04:05:46 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E28A48BF87
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 08:05:45 +0000 (UTC)
X-FDA: 84612881850.13.C38211B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 1788FC000C
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 08:05:43 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tUmyORdZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775117144;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6F3+WYdY62lPyqVabd9jIhq6PJtHcLN6/yZHJrRzLRg=;
	b=67ySA73+YrNjwmRtoADC0mwHoOo2FWLJVN54B9qUaRr5vhdqAGkAlGD3qviv0OsGxxbN8+
	VRVWUAMBkAz1e9EWOu6sQyMEMTXCHI+K4cLeS1msQzop0PmokpzdRH2jqzBHPC2h1SNKCm
	DkXhK7Yb8I50LKTDMlyYnDhBWn7Yl1U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775117144; a=rsa-sha256;
	cv=none;
	b=KDy7Q1371DMkY6vz0TxgoWV/znJspTxnNSVKzXWknIKSECsCKVKUykPzUq5DlHz5Bj+l/t
	k3ityEMa1HOrarCetDKbNtLdcFvyLvkdoW2WZZMocMwK7GfDlbLQj/w8DuoKr9ecYbjdR9
	eivQcR9oZZMRMQEnkdt1oHXTYhp+G2Y=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tUmyORdZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2E384402C5;
	Thu,  2 Apr 2026 08:05:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68E76C19423;
	Thu,  2 Apr 2026 08:05:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775117143;
	bh=pc+hXU7zjHtoaL4Y7vvezeUMOhJ9bchBcqa1OKmwzAI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=tUmyORdZEQ4TsK52/wjbnKFD+Fd0KI4yTlM+aOVnDNkxtXohyUqkw9Dtee9cAcgxI
	 FfqgRLwtmY6GapCsqEC7B1puBoDsFh+PiAcln75vRKNNfohE7/SQqRmC/53ea6rw9s
	 CnJnQ0iGM10Bzul6b3+rU9/nKzJ5d/8ALwcF2Vsz91sLELC0EektvN8lBXwNXElfrE
	 pFsyB0uGrS2YMvBBOf6U2aqildxygJ9c1QfzYES1KZfZVyDEEwklKNl6SLWWYnPU/M
	 28Yqq4qlpTo+xN1PGT9Do0ifF4/Ie2x3EuyK7aQf7e7CGDcjAtkUU8X3Jp8Wv0pDf6
	 RRuPos3tcY3tw==
Message-ID: <3b853391-11b3-4cca-bfae-c8147a72231e@kernel.org>
Date: Thu, 2 Apr 2026 10:05:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 4/6] selftests/mm/vm_util: robust write_file()
To: Chunyu Hu <chuhu@redhat.com>, akpm@linux-foundation.org,
 shuah@kernel.org, linux-mm@kvack.org, ljs@kernel.org
Cc: linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev
References: <20260402014543.1671131-1-chuhu@redhat.com>
 <20260402014543.1671131-5-chuhu@redhat.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260402014543.1671131-5-chuhu@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 1788FC000C
X-Stat-Signature: mma7bztr3m5jnirrmf4fe7rwigtpc1pk
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775117143-394586
X-HE-Meta: U2FsdGVkX19CD8DsU9AvaFn+WOr7tccAVh6pIoPA5gYzkCmCqWSjG2V06AeoR0m29d8HJiHDxwlcugQJjA86tBj3BpadQgNr/6/TnAlOKs95cp5Kijr2xpgR1ZZbMP9/D0C4KDhW3WNKpclO7U4LbftdVREltGQLsFUGt/BNRSjHo1wFDt2wx/uOXj0/zIN7u29yxaNXF7qwvBSSQ/C7t7LbrcOY+/0UPIVzhUOrPbdUeGpC9H+FvOtmtNkOJoR+MGUVmg2xruvyWOfN+eZdQFkgUJVo6oaSmDXb06xi1goDwikyyFC30aaopT/JnIUjezH9Rxpd3yvXldOZvFK9BJUaL7cDBK3P4qEmjXIjB9QPh0MrNCG4fqH2uL72OMGZYA2IxVihMgl2QEHlzkcLhPH6aMFESLwt7HqX8cD/BBkNTLPD1JgKQ9zLfONmyxT3mONZIinC5Nbw8MFreZS0kkU1qRpVzvi6OqXs7tlleSy9wRe5MEX+r8fC+INRnEy5vriyeyNsbr4hkLU6NAMAVD1uJpxpnvDx3ilxVKJv4qRVH99twgu8fsiEziQfqFIwy5724m45J1k+2CG7YASdJN9Q+TZRs6daxXCJq3BpMeOTzarXzvLqdvjZahkSaJA6tw91epZrOZc1X0juWByOEt85rVkqWAV/yTjsVxaY8t3TZgsSOC7bHtgOML7NGCaar9Xe/pNHPhICbPCK2qPDMVQgYKzqHcT1iB8kBOAF8yE4hxkCuplTAA952sqZFPKT8OGHPPi8014zLoSJJGWfDyYajT/2tOqk/jM0mqx7lX7lFxdusfYqPJd1JbBsvfuX/1z/Kj6rgHh1Lz0F1tv8vBxnLC2WiMaJDqaeA3TvTgCZELJ8aZDxpddSqyWvqMzXiA7b1PE07vbfxume8J6emBP61IFKBkxO8j1/nHZXWOhVCG10/7iAE2GI8Wp2eQjxt1bHtWmbZGxgKRt0Tor
 cSr/jDbV
 4D4UMkB4Y1ARajEhzzZlQVo7aZC7kq5weu1QJEZeq7gs9kt+NLnXo9lfw2E18dAECcXpZZeJv7UZTjphjrzZCi95WqEfmUGWYBZgjderE6Ph9jXlB79dqPhqsmQZ3A7tNLAeK01JACJOXxTHJpB1U8f9rGXKHx/iCJgUdyJxh2RW0SaQWAO2Lwex8mb3X7I+Z7j2l6Lfu5Y8tanBx/bGRruPB+eMixa4lpNAUCgWqS+mu4yN8FV79a7zEAE4HeLVlsbm6mBAyquZHqfkY9kHxkFVTRIw5IQtBWlkDeAehcot1hH+AI5IYxsF4Mc2MLnFnhjjGS2Ib0w7znBOHNux8JZFrQMETGYOyJRs1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/2/26 03:45, Chunyu Hu wrote:
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

Ah, yes, code we will never trigger ;)

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

