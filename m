Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5DFDB10ED66D
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 12:32:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C54F96B0092; Fri, 27 Mar 2026 08:32:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2C896B0095; Fri, 27 Mar 2026 08:32:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B6A086B0096; Fri, 27 Mar 2026 08:32:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AB0396B0092
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 08:32:13 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 58CC613C59E
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 12:32:13 +0000 (UTC)
X-FDA: 84591780546.21.E8D646E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id CAF7EA0017
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 12:32:11 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gG3JNHS2;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774614731;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yH7N/a2wRGji2P/Sc6G5XhAvR/Gg9QuyITZucPdsLAg=;
	b=ujFDGKHey/DMH6d2FgCO/aiC6ggT2YJE1o0GrofUCFCLKPh6X0opIVYuj7juxhVk91RycD
	9LnPKOebHtMe+Vip49iuxDDBy36HRfPQY8ps8T2gkYNPzkZfGubUpxS4a7IETbxZwDr2wv
	rzyU8O5hnPXhtANnHrX9ts3Pg37bUwg=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gG3JNHS2;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774614731; a=rsa-sha256;
	cv=none;
	b=8hms3Y+gtHUdD0lHnAyaGmDvvG+QorDurSIAzIb8CdCA1WZHcFT/Y//EYlhc8HGu+diEsm
	9yrAoeufAHkIydVNFxa7PZ7GIOfEelaEUtd7TYUjhfRabYImaT+vDkyzNUtAywFXRKjvxF
	alWWNFXb7Kkz3xAWhGkl3/AE4cYpe6s=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2D51261840;
	Fri, 27 Mar 2026 12:32:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9583DC19423;
	Fri, 27 Mar 2026 12:32:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774614730;
	bh=Pl9DVulQW4wTm72CZ7Z0DlDl11UMwY/qQTHqQXd4fo0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gG3JNHS2r8tw4BAPgiCvkVDhREBhFMB72+fGe4fR9spd9APmORjZYd8Xb69ygI8JO
	 4vEKHENnLe/BZ+47FfQXurrgYhUzorJ2IXP2e2n77JPaOB+ncMOcOZce0c3Zaxe7NF
	 9VnkLGAdrbhEpLs5EwhyR5t2zLu7lNnKR1rbOEnAsrb6SVP6ZKWBBy3xy1ubR9xIF+
	 rSUUUPvqW05hB3S2125JudhUuiWmvna3jyeSasYilQmyLoSoVAxy8kxroqq6g9u/Ls
	 nFVz+dcgo1JHgg7NhZ9OvZ0A2tD0Nb383uOlmdgyXfg2UuOejuCQ/knrq6K5KTRx+k
	 0yF06X7oAWONg==
Date: Fri, 27 Mar 2026 15:32:01 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Chunyu Hu <chuhu@redhat.com>
Cc: akpm@linux-foundation.org, david@kernel.org, shuah@kernel.org,
	linux-mm@kvack.org, ljs@kernel.org, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, surenb@google.com,
	mhocko@suse.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
	baohua@kernel.org, lance.yang@linux.dev
Subject: Re: [PATCH v6 4/6] selftests/mm/vm_util: robust write_file()
Message-ID: <acZ4wTxSmPn_s_mn@kernel.org>
References: <20260324013316.2590422-1-chuhu@redhat.com>
 <20260324013316.2590422-5-chuhu@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260324013316.2590422-5-chuhu@redhat.com>
X-Rspam-User: 
X-Stat-Signature: jw4oasdh36qhzkaqsuiafb734koyr93r
X-Rspamd-Queue-Id: CAF7EA0017
X-Rspamd-Server: rspam09
X-HE-Tag: 1774614731-636726
X-HE-Meta: U2FsdGVkX1+G6eWSa/9MxrK1UPa4B9vfEOaO5LG9+/k94/8dsnKNGQuA6lsowHyJzjLLVIFX7Y0Z9iNHvP6Hq58xkwBKM146I75cQG+Sv4ImlfoFo6mLnicymkNre48yZO+nVDCT6HveUGdDOa6a8OIcFZ1s1XuwSD5QixyI7P1+49yMvAt2enA8fguM8Ah9uWaaEL5bcq9G/6Hu5EIfprzvcpEmeAvvKVB7bGzmyO9xTjSyL0ioWyszcwHRZRxJCPxySpg6FQx4OLeuvkZkmcbbuyotd7DH6q6zMd/cecLvbbotCR26nd9UEgm0WVFTHBRnRzZ9V0yNlQpoUeNrLzUdEfHLX3oX0jPoRP2XmuoO0UDL8aLDqPX9AedmQfnCtWzRj3vG9BmQj0TS8EDBPax8G9MQ9OskeQv2IHWZ48vpibARtFmyR92cKWpQojOkeJ9Q9gW+iXFistsWHpRVLX6BbtsgVgqd+Fzz7Wsn9JhRVc4p4HVGiEj7/btSZ5WS/lcjXTxGBbFN/rhb1T3qEFE0NULrH90w6K3E6Rqw5utjBZ4HzdX/X0KuNvgs2Uo+X/bSeiDWsH3Riet8sHW9ZxGggHBYbRcFn+AjtqORCrZscoUnphvxGeBWRIsvOEf6Kgn9NmGiS+c/70DxGJl/77VxCqwdEG59xPSDlmXrFP4OtVMCTBg7BCGU9wYJ9lOXuzUsI51eBXj7G34zkQ3WFZKh0P7ZN2KKSuqqvx/cPGyLEwrvlB98jfV0heU1TO2zxdEFtCeqSh0Mzyv5S6DtbzCbSBNScQtQVC/0tLzCXP0MmfOAfqYj5qAFfghLjQ/5sfGI98PH/4/GOq/zkol5GhqABOlrWr7DW9gSEwPmjYlKTGyjHULGIq56bX7zwcLkKBue2NAhVMeAdrPQsk1VYqFbfaWVpJEw4unacdnKKDgYHKG48u6MUxG/bLdJk9LIeM8JsSvhzaaC4GF2U2R
 ngQF20zh
 NRwobp67/m5Iael1Ff/o4C433oe83pPqz0VOorAT1ujAwjyWfLx5RZvNQ9OwtV4kM3SKsQvXIze2sZ+O2Iw97e43fR5j9YNOY6minmw8/Ts9+HBlEWhnbn64F4uoa68WOh5fiNEd7hFWcDwo8ndOt3UMDNe3rfhLMdaNTZJuN2KcdMQHrTUBhuy47j3g84wV+KVCBxC3anp+/lCsmCg/UUITW613I5XNt5apin9ckFPCav4jlKCurdWzDEpKIyRYfo9ZuvyZx3pO4G5xRI/bZmfz7GojP95s3cWYSVjgXkJKXJABgoe8714GWUqN3xQXg4oxw492ldj/yIGA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 24, 2026 at 09:33:14AM +0800, Chunyu Hu wrote:
> Add two more checks for buflen and numwritten. The buflen should be at
> least one, otherwise the 'buflen - 1' could underflow and cause trouble.
> The numwritten should be equal to 'buflen - 1'. The test will exit if
> any of these conditions aren't met.
> 
> Additionally, add more print information when a write failure occurs or
> a truncated write happens, providing clearer diagnostics.
> 
> Signed-off-by: Chunyu Hu <chuhu@redhat.com>
> ---
> Changes in v6:
>   - save/restore errno before and after the close(), so the log could show
>     the correct error info on failure. Suggested by AI.
> Chagnes in v5:
>   - new patch for making improve on write_file. Add more safety checks and
>     diagnostics info in log
> ---
>  tools/testing/selftests/mm/vm_util.c | 12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
> index ad96d19d1b85..572ccb99de8e 100644
> --- a/tools/testing/selftests/mm/vm_util.c
> +++ b/tools/testing/selftests/mm/vm_util.c
> @@ -767,15 +767,23 @@ int unpoison_memory(unsigned long pfn)
>  
>  void write_file(const char *path, const char *buf, size_t buflen)
>  {
> -	int fd;
> +	int fd, saved_errno;
>  	ssize_t numwritten;
> +	if (buflen < 1)
> +		ksft_exit_fail_msg("Incorrect buffer len: %zu\n", buflen);
>  
>  	fd = open(path, O_WRONLY);
>  	if (fd == -1)
>  		ksft_exit_fail_msg("%s open failed: %s\n", path, strerror(errno));

We have ksft_exit_fail_perror(), fits great here

>  
>  	numwritten = write(fd, buf, buflen - 1);
> +	saved_errno = errno;
>  	close(fd);
> +	errno = saved_errno;
>  	if (numwritten < 1)
> -		ksft_exit_fail_msg("Write failed\n");
> +		ksft_exit_fail_msg("%s write(%s) failed: %s\n", path, buf,
> +				strerror(errno));

and here.

> +	if (numwritten != buflen - 1)
> +		ksft_exit_fail_msg("%s write(%s) is truncated, expected %zu bytes, got %zd bytes\n",
> +				path, buf, buflen - 1, numwritten);
>  }
> -- 
> 2.53.0
> 

-- 
Sincerely yours,
Mike.

