Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 598E910F3DFA
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 14:24:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE1B26B0098; Mon, 30 Mar 2026 10:24:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B92C56B0099; Mon, 30 Mar 2026 10:24:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A81916B009B; Mon, 30 Mar 2026 10:24:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 96DFB6B0098
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 10:24:42 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 101791607C9
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 14:24:42 +0000 (UTC)
X-FDA: 84602950404.20.1795ECB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 207F040005
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 14:24:39 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KzLsfE7a;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774880680; a=rsa-sha256;
	cv=none;
	b=cQjGP8SphsOOCUGqGYrSJjI0HLxb0HZuiZW7lDMYJmF07uRBfUTcZaAPIzXX2ezmZoPyCs
	AoYyg0ZlStBoDgzElZN8Sx8KZSxJUkjQZahlzBj3pMpXy2HXJUiNuW/uUmqdDhl0adVdek
	TH49wAoutfQ6YdH8BWGqG/UbmxxODLI=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KzLsfE7a;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774880680;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KUkhYOcCDg4cERi3otgD9wa6MteE7mDqHjw1aUHHmgo=;
	b=VtAXEfr9Nf7Q/zGgVpOKvPwCKg/UPvNFJIITD3EkE1LpRlpjlv9ivJYfUrdvtXblv8ahcR
	mSc0orF8Lr0TCR+EzaL2FS0KGfzig03fRNy7QHqTgmVRL3t0fUDnKqmALq7rj9GV0UuSpK
	AhByj83XOCrFxP8FwpdEhIPXVv965Og=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1159A41B13;
	Mon, 30 Mar 2026 14:24:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 234E3C2BCB4;
	Mon, 30 Mar 2026 14:24:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774880678;
	bh=3rj+sXJaZ9wh2XdFPjuo89ucmKl3UhlADlwbFbe84e0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=KzLsfE7aN0NHA9dqLon8kGWP6B+Jr6CjqLLn3sB/uAb4ltieAjQaJ5+MKjtFbohHG
	 7XbbIzlj0PEYR5lqPqjD6LpzCRCiB736dSKPlQFUpUIRM4Czre77YdW+LkTATUC/uY
	 /iymHSY1xrykYRESNAL9rsiAj7O/gUs8JtE3Mcgd9oi5mYBtIVag++nrfnd6jDWnaL
	 C7vMDZxsvzdu6vo+buwLfqczcNGfV8bdW9wTfXyAwT5c6IQHWfI1valyDj98tYeBqE
	 SOdsmJYvkemiJ/il3FB6x/IpdQZz1ClYseUuWD+G5ahHV5Ca7378tYivD/iij73FtZ
	 SgXzQXckkT8Lg==
Message-ID: <96d14f27-ca0f-413d-8b61-768933ee70ba@kernel.org>
Date: Mon, 30 Mar 2026 16:24:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] selftests/mm: skip hugetlb_dio tests when DIO
 alignment is incompatible
To: Li Wang <liwang@redhat.com>, akpm@linux-foundation.org, rppt@kernel.org,
 ljs@kernel.org, Liam.Howlett@oracle.com, vbabka@kernel.org,
 surenb@google.com, mhocko@suse.com, shuah@kernel.org
Cc: aubaker@redhat.com, linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <20260330125307.98581-1-liwang@redhat.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260330125307.98581-1-liwang@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 207F040005
X-Stat-Signature: z5ibnghojwrpots4m8dwhfixgp9fpyii
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774880679-992607
X-HE-Meta: U2FsdGVkX18NVuHiuL/op5k62L1yYLD80KdK3/zYe0QfwQy2ErivbuoJOmZdgI9WMQVDb2YIwpu4DyiBkC2dwznTzabui1A21Q0+sjd0ZJGPgX02jZjcKl1T0XxAWLO5fUs1ETaHO6o760SaRWIk8sV67o9fs6bGyYRDy3CTccY5FivUl2cOHmzBjPJMZff9+eG/vQvUpNdjhJrQ2SQ2bM9i6zqA1qBW1SzCRmbCocg+hF03krxDc/WwWBKh43ZRe4oeygWAZwCeKxy7oRHWwhZ0V8JRPrWJq6k94UcyzS9Yv7D/bXanfaQKBfu3gmu1YncZorxMTMGcEx1GW86NJReo21F4JLFV/rxSSuelwS8bIG+mNRvO4qtrRyPUI1MGNn4nPVl49zxb6FFHekkLvFx9i9M4eFir1/yg28Fu2pqKRagbDrgujGujILTCcD6lE579CGv5YtnhVOOIsbNWPeh0opGCuFI8cn4B8A4JP3YfxQNqpNLZmhiI+n715GTqzM7pbIQOzSg+6yjC6pDIPw/Phy/nlSr6DKVJxsY7aG/7/zfbbopm3NMdgbQrBjdneTCejX8g6VNRXjwiWbjhT9EMZa+v3TlB757lnD3PGZm3yP9YS0RBhO+JdBN+OioMM/l+QZJTdZmSDOEIAkcG22prTgzb8TIbWXMJuVPxfL44XsQZSR5naTSL6BAZOYmqMYY3SL1VPmrF8bch/qBfOfnwG9Wi5q2heZhsojW5umbRCCgpOnu68QvU7hv9wtT9AtPnJAWEmTgbHNn69C/C/4KhjYy68G6Y+HhVnN0rAW/AsGrKXcz0koG2gnB152QGPrdx80ntEzrVTkk5eVqQlR7hGqdK7PLO9Gs+FfQ8dDfAOcGXpJxiGVZXlVNemOvlTkcgiYw0/dHK2u2mYeX1PXK0hqQ7JwEULIntMQUGPQwMg6t0YM1WAh1QoOHC4DLgDAFrXdAythR1dH2E+/b
 nn+4BcUt
 q6vkUysL8zD3lzKnLRr1LmR/QbpZ6Zs3tc/aulxkMCraNpTpfRuQVz6Ck6KGmqQnhMzULgshbDepBCQDLhdZy+P05tFmP93tKg4/zovoC56cWIm+LI5i+85z2R344rLR+1NmnamIPDSYIsGj8sS7Fu/07p6aXM0C2sYNCJ5nK2Xq9JJQ7a6YL4QgVJUga2HZG3RR+UrthO2j8srLpf+WBRhL5iHoU6bP2Lyl7Nuk6U51YEPrXQP5SLnIteltSL8UXHNhxGhJyphtnDVQNgcwBfBDHBXt8d0oiZIGm/TBdjkqbNc5nwq91WY7goToRk49G+8ypkYN3dNwBx0+Bj4GrdO2KvZa9jc9kYAIx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/30/26 14:53, Li Wang wrote:
> hugetlb_dio test uses sub-page offsets (pagesize / 2) to verify that
> hugepages used as DIO user buffers are correctly unpinned at completion.
> 
> However, on filesystems with a logical block size larger than half the
> page size (e.g., 4K-sector block devices), these unaligned DIO writes
> are rejected with -EINVAL, causing the test to fail unexpectedly.
> 
> Add get_dio_alignment() to query the filesystem's required DIO alignment
> via statx(STATX_DIOALIGN) and skip individual test cases whose file
> offset or write size is not a multiple of that alignment. Aligned cases
> continue to run so the core coverage is preserved.
> 
> While here, open the temporary file once in main() and share the fd
> across all test cases instead of reopening it in each invocation.
> 
> === Reproduce Steps ===
> 
>   # dd if=/dev/zero of=/tmp/test.img bs=1M count=512
>   # losetup --sector-size 4096 /dev/loop0 /tmp/test.img
>   # mkfs.xfs /dev/loop0
>   # mkdir -p /mnt/dio_test
>   # mount /dev/loop0 /mnt/dio_test
> 
>   // Modify test to open /mnt/dio_test and rebuild it:
>   -       fd = open("/tmp", O_TMPFILE | O_RDWR | O_DIRECT, 0664);
>   +       fd = open("/mnt/dio_test", O_TMPFILE | O_RDWR | O_DIRECT, 0664);
> 
>   # getconf PAGESIZE
>   4096
> 
>   # echo 100 >/proc/sys/vm/nr_hugepages
> 
>   # ./hugetlb_dio
>   TAP version 13
>   1..4
>   # No. Free pages before allocation : 100
>   # No. Free pages after munmap : 100
>   ok 1 free huge pages from 0-12288
>   Bail out! Error writing to file
>   : Invalid argument (22)
>   # Planned tests != run tests (4 != 1)
>   # Totals: pass:1 fail:0 xfail:0 xpass:0 skip:0 error:0
> 
> Signed-off-by: Li Wang <liwang@redhat.com>
> Suggested-by: Mike Rapoport <rppt@kernel.org>
> Suggested-by: David Hildenbrand <david@kernel.org>
> ---


[...]

> +static void run_dio_using_hugetlb(int fd, unsigned int start_off,
> +				  unsigned int end_off)
>  {
> -	int fd;
>  	char *buffer =  NULL;
>  	char *orig_buffer = NULL;
>  	size_t h_pagesize = 0;
> @@ -39,10 +84,9 @@ void run_dio_using_hugetlb(unsigned int start_off, unsigned int end_off)
>  	if (!h_pagesize)
>  		ksft_exit_fail_msg("Unable to determine huge page size\n");
>  
> -	/* Open the file to DIO */
> -	fd = open("/tmp", O_TMPFILE | O_RDWR | O_DIRECT, 0664);
> -	if (fd < 0)
> -		ksft_exit_fail_perror("Error opening file\n");
> +	/* Reset file position since fd is shared across tests */
> +	if (lseek(fd, 0, SEEK_SET) < 0)
> +		ksft_exit_fail_perror("lseek failed\n");
>  
>  	/* Get the free huge pages before allocation */
>  	free_hpage_b = get_free_hugepages();
> @@ -71,7 +115,6 @@ void run_dio_using_hugetlb(unsigned int start_off, unsigned int end_off)
>  
>  	/* unmap the huge page */
>  	munmap(orig_buffer, h_pagesize);
> -	close(fd);
>  
>  	/* Get the free huge pages after unmap*/
>  	free_hpage_a = get_free_hugepages();
> @@ -87,39 +130,49 @@ void run_dio_using_hugetlb(unsigned int start_off, unsigned int end_off)
>  			 "free huge pages from %u-%u\n", start_off, end_off);
>  }
>  
> +static void run_test(int fd, unsigned int start_off,
> +		     unsigned int end_off, unsigned int align)

Nit: prefer to-tab alignment in MM land.

> +{
> +	if (!check_dio_alignment(start_off, end_off, align))
> +		return;

Is there a reason we just perform that at the beginning of
run_dio_using_hugetlb(), avoiding run_test() entirely?


In general, LGTM, thanks!

Feel free to add my

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

