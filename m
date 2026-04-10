Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C964F36BAA
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 05:30:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2FEA06B0005; Fri, 10 Apr 2026 01:30:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2AF606B0089; Fri, 10 Apr 2026 01:30:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C61E6B008A; Fri, 10 Apr 2026 01:30:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0D95F6B0005
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 01:30:14 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3F20114042E
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 05:30:13 +0000 (UTC)
X-FDA: 84641520306.29.A1FF460
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 90337140003
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 05:30:11 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uFH86ZPY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775799011; a=rsa-sha256;
	cv=none;
	b=JQSoKhxDxtGgc7HcxJCaubwnL0r+FAmxEZRk4cfFGXvAkSNWOTaTvN07pmKMiCX3zdbV4P
	dofej0XI0LIr8mAQrm3KSwx7vpMNyz4+2YPQ/S58KAoqWjoZTeJom0SRXR4+Zn1sfoVvCG
	NwyimXZBKb20oFWLiLVwqKEtejuZYcI=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uFH86ZPY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775799011;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3n3nMuBvwgLJYLOFzQFwh/VEuJpkk2PgKS0T/Yd2RrY=;
	b=g4LzGrg6Dj4EftwsxTmm4qa4eQjYLCj0enWa5BOjJUv/LBfEvGhDgsqs60Vf8ZJtdD4Mh9
	pG1r+MU8IJ0/di23QJ+TbIhh4qVQB6NniHjXBopIRfLzIPqaykEV70u8cfjlio6uUhY+gl
	pwPMKO14XZKuqahofKCmD8seVpf9IwQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3BE274419E;
	Fri, 10 Apr 2026 05:30:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7C33C19421;
	Fri, 10 Apr 2026 05:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775799010;
	bh=V/k8TpK7UgCFEnab0NAEjH8K1d+6H1LN2eToXJ55ZmU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uFH86ZPYLPRLGIKMRe0X98YbVecVo5hC24ux2/hK6n2pfqumoSoRRY7DtAS4zli+D
	 UeVEaBuQyHFb4HmHeA0L38tz2hVhUo7RYEt9TNKL4jxROZ2ZfW9I2guf0tXcQVGK6Z
	 UGmQLkwlHeCxSFKtkqEIJv4SI0mpqZ+mXeRdjQ/pQfZVr4+K9XoA7oFu9lv6CzQxoq
	 9uNR/merZCvt5eT1C03Leaz3gTJ63Cu+xbdU8yTPYclOg+LhjjiJ4VNOMBALPhQexM
	 MeUBs7BgXsomsSqNf6srC/e0pTns+G745vWaWMBz17DriNXvoDZx5VtkgEYFYguKDk
	 UAiIDk5p+1TPg==
Date: Fri, 10 Apr 2026 08:30:03 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Cao Ruichuang <create0818@163.com>
Cc: akpm@linux-foundation.org, david@kernel.org, shuah@kernel.org,
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] selftests: mm: skip charge_reserved_hugetlb without
 killall
Message-ID: <adiK27fGKSZyl1Rf@kernel.org>
References: <20260406053126.217196-1-create0818@163.com>
 <20260410044139.67480-1-create0818@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260410044139.67480-1-create0818@163.com>
X-Stat-Signature: wkk3tcnjx7q1ywxdrtaa8eryidwmhxgi
X-Rspamd-Queue-Id: 90337140003
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775799011-104459
X-HE-Meta: U2FsdGVkX1/4TP5gRhc8pLm7NrTJUkyUAz/5pUE06W7tD7mU6+pYIo3PNBeMpCK+PZADd6SY4KOO+FbaIpAL7CgKojH6HpCN4va0a/DLEPfM8qiH3uA0LeenjTfSD5fjEz5CDfoksI1qqZCgDwJbYMk7la7M9rJ14VGH332G/0pEdFTDDgJjiCoQuvjWTPPmCdJJFCE6IuXCSx1fpq3TW3gY6OFGCjPDH5fBD+IB4yBcPbI+n2DITDap+2SE/JHu5C8bZRJAnnht3RckTmwxfP1f7CtTSyVtPuvhkvUQxrxNTSXUpZxstWf7TF+NrbUpbgEjSyaMk3iho8AlE57wlPjWa/5RHqPItIu0d45M0/3HPzdt0BtV7Kr+baaxJw1a5j0gukE+mcWjKNZ+5BekEFI76lEb6pVa7lvHS+/doshve1Ut0llKQxatRUn3C500rlFpJdz8FIziKiO6ImW6CJZ34Ig8ty6Et78OZhLfjJusRuua3RYjwBm4Mg+ae7JLoQUiHu+KKtQddptXBkkYXql9q16+LvuHeraCchYaJ0+jyQXcEjeu1ymfg5twk7CdZzwgugSnhOsEKjwzBxC7rCsIbeztQ71DrLUqdeYUC4R25KdN/YtBoUbT80ofIDobWvWl3IkxI/xGCE8WPIFtCcXFhAhea19az6ykTsk00lYM4d7ky5dbfI9v+dE5zcxhLptc8MlwsOAe5EUDaXsYJSy4E3DlxTaJc9PQquoSoZ4Q2MyjjrBWvmORuYl6q/iHUPxHkxOllsYClQBwtVAVp4fUvUvKMrmqGt8LwJdRjz9LsJbUtHQzZkDJSzJhhItblkTO5dHaylzVOpbchC4yvuJhBX33Z2D2m0gnmrq7GT6z+V391jvR3iIukzojZtOQyyYmxiqVXkOWxL62jlsM562d7KON8q0Vy2UeqkzPb0v+/Ff+XPwEbn09CLHIhCgik/yDoBxthCzFcAyxdma
 XbWweD8O
 wJxhg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 10, 2026 at 12:41:39PM +0800, Cao Ruichuang wrote:
> charge_reserved_hugetlb.sh tears down background writers with
> killall from psmisc. Minimal Ubuntu images do not always provide
> that tool, so the selftest fails in cleanup for an environment reason
> rather than for the hugetlb behavior it is trying to cover.
> 
> Skip the test when killall is unavailable, similar to the existing
> root check, so these environments report the dependency clearly
> instead of failing the test.
> 
> Signed-off-by: Cao Ruichuang <create0818@163.com>

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
> v2:
> - replace the PID tracking approach with a simple skip when killall is
>   unavailable
> - follow Mike Rapoport's review suggestion
> 
>  tools/testing/selftests/mm/charge_reserved_hugetlb.sh | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/tools/testing/selftests/mm/charge_reserved_hugetlb.sh b/tools/testing/selftests/mm/charge_reserved_hugetlb.sh
> index 44776965763..44f4e703deb 100755
> --- a/tools/testing/selftests/mm/charge_reserved_hugetlb.sh
> +++ b/tools/testing/selftests/mm/charge_reserved_hugetlb.sh
> @@ -11,6 +11,11 @@ if [[ $(id -u) -ne 0 ]]; then
>    exit $ksft_skip
>  fi
>  
> +if ! command -v killall >/dev/null 2>&1; then
> +  echo "killall not available. Skipping..."
> +  exit $ksft_skip
> +fi
> +
>  nr_hugepgs=$(cat /proc/sys/vm/nr_hugepages)
>  
>  fault_limit_file=limit_in_bytes
> -- 
> 2.39.5 (Apple Git-154)
> 

-- 
Sincerely yours,
Mike.

