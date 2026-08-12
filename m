Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF191C5B572
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 13:46:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D9C66B015A; Wed, 12 Aug 2026 09:46:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B1B86B0290; Wed, 12 Aug 2026 09:46:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8EEC96B0291; Wed, 12 Aug 2026 09:46:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 728256B015A
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 09:46:15 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 873F8A28C1
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 13:46:14 +0000 (UTC)
X-FDA: 85092741468.26.7BB7CC5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id ED6B710000B
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 13:46:12 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=M546RZ58;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786542372;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dPPfCRg3JlfVv/4f6FK6LVxgGLE7bCFUuDbT6h8lgBU=;
	b=dTwIiSWqEP1phcc1kfzUWqN5Q+uuLRECB6hXpoEQYrezNPdzqRK2lJShVZEfOpN+ldqAXb
	ayV9u/fxBvsaTS17/xyc21S+JyjghgbiBNqc+gkLxwE2UANksqn+mtPVsSF4Rsku+tTrnO
	zsxU0jXskFYnvlS4DaC26WGmMvtEBNg=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=M546RZ58;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786542372;
	b=bXCl53SHOtHiKX967ylCIMlmPJY4Y92JtGaJxCPL4+lrNULCEGao2E5sgfGpMYT/v5hr/x
	gyU2aSqH5dBJeEPGHG3dzJbK9adhDhcYryip5UxDZZXG7l0RaCHDjLEAx+4Ki7jdZcsdxV
	97THb0uI1naI1MJjZm+45dnu8P7r+kM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8343360A85;
	Wed, 12 Aug 2026 13:46:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8C731F00A3A;
	Wed, 12 Aug 2026 13:46:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786542372;
	bh=dPPfCRg3JlfVv/4f6FK6LVxgGLE7bCFUuDbT6h8lgBU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=M546RZ58kHKzTydWMuY5WEtHJaCQrwspIfdlS4p99Hkd7+vVXTMWTO9ofaYbnL7Lz
	 hzM8op6tZLBpqL/IttyerVkZL3O76U34OPr5Ahgbq+fgJvv+Gy/caKTQUTcDImhNAe
	 2c5GcaNH0197jxiv/HgWwBBaJ8XQJtEPXSm1+yFolJbjYY+lV7qcVFxRttGh1sN55U
	 rfvFEMFhhJeH+uQGNrwNCWyl6uXvyXaGG3fX2cIXc5wgYAh/UA22Nul8J+3RRFppGE
	 zftYX9V92w/JC3s95h5pqxnoZA1VQsJa1sOXDKAMwP9infngzu3ydtrPAmhuCip6sq
	 Tzd7GBij9KKGw==
Date: Wed, 12 Aug 2026 16:46:05 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Song Hu <husong@kylinos.cn>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, shuah@kernel.org,
	david@kernel.org, ljs@kernel.org, liam@infradead.org,
	vbabka@kernel.org, surenb@google.com, mhocko@suse.com,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests/mm: emit KTAP output from ksft_kmemleak_dedup
Message-ID: <anx5HTQVVrgwtTqK@kernel.org>
References: <20260812132142.582390-1-husong@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260812132142.582390-1-husong@kylinos.cn>
X-Stat-Signature: wrnkgridpxpj3wyifz9eacwb45rshtf6
X-Rspamd-Queue-Id: ED6B710000B
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1786542372-354347
X-HE-Meta: U2FsdGVkX19Qe6eXdFwOKEyGw5cxOXX5E315NkPWk793hsNRpXNndEaEND0lMuhGymtPO/VZCZoZcBdvp5VcomGvYMP05BEp3r5nghIKCeIhZHEhSMq+AiRLdY1gy46IxgvCcZAhdP4222nfHObAuCljkFbMPp/O4C8G+q56eIZRv/SLENcV3xJOBvY08lHWcFjUzzuYNf1YfK5JgD1cDGo4CaTEfYUdAIwUXpdYd7mMDXdEc3JmWguq9EzgBch3YugkNURuLqlzsjwGVAnq2+/zE8hex/YKb7345ging2ZMLnDkEooaMcxgpsaXx191PcNogXDJKHq7GeHzj5JlA7ReqMRaBcM6fl6ZPrwDEnZIcjL6llev1iSxqlta13ZRHVBZZ69oOjOxQcAcPpdz4s6xkR8UI2mFk26/0LPQ1r6T+cpIng8eLoBHDytyKcJg7QELQbIDqd8Pw4QofjSsDfyMHdis2u3CtdNDthkfk4/XOsjFhgO2V6D8C9p66zs38yVa3wlc6PC1xWwp8uWk6oSWNz6xPMRgTHFJ5gb6Bh+sYxWX2XOV0iK82BpJo2kqCW63aRRELRJisnEm/UeYmB5AAo2z6Mh6VUo34ctRZ9xlkDJfiCWEVTe56aFSzbzWFcx+JqB0O5w+OW2OVujUz1lEDTj+0nGQcypddjKoho+G31kyu2BhCoOxDvl8udKiC2B6j//n26a+1kO9GOKfNSF6CSNHBhmcAU8/0lbc/jndvnxwsgAertW+7pYwZLRGbYN1ZiKVyXL7ADLgKfotMZd3mVKMuzfl7cCbIqQGw8DLK7T616rLH9/yb2AKnwXXB0fUOm+sYFrbMSu/MjIbHPpdpph2AVz+8kTCOFLtUI21kT87BXvqH4CObuNgi6QMLOQ+CSRLfX/8I7UBtaaiu6MEs0UYLAhqSMZpdFqx4ebfkZEwlZQoK9Rm6HqXkUSak/m7ZK2lEjkKXD1jug8
 g6P3GYRQ
 DnqOn9HATUsN97vmNq0PxuAJFvBHaYSBuzWHqe84WbWu/JkQypdS6+p2ssToSK9Owi6HD6eHjnLUsd7dem9dmhLgyaMHMuxl7oPbLY6wle5EzgrN4ilPPaaK57/3QP2lz6lIqqrblIQ63dnzFCHk7evi4hVsNkT0d7QqGacwXLsyYdYRicBHQGL/krusOeZ4hHi3maUZ9lNL6pWj4D1FsMjQPbmjs3VFJ5GWyhGHqMxT4CCnJGN0SuiNi1upf40b41mBndK9WnvhfiYZt8rh0u7rq7uu72roB/AbY5KCykp/LZyoxUQBh5vIfLdfJ2TxtDXXgPuzehgfWT3TI/IiB9Bk3X3NhJNo7cXZo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 12, 2026 at 09:21:41PM +0800, Song Hu wrote:
> ksft_kmemleak_dedup.sh reports its result with raw "SKIP:"/"FAIL":"PASS:"
> echoes and bare exit codes instead of KTAP, so parse_kselftest.py cannot
> read it.  Convert it to the ktap_helpers.sh API, like its sibling
> ksft_kmemleak_confirm.sh.
> 
> Signed-off-by: Song Hu <husong@kylinos.cn>

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  .../selftests/mm/ksft_kmemleak_dedup.sh       | 20 ++++++++++++-------
>  1 file changed, 13 insertions(+), 7 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/ksft_kmemleak_dedup.sh b/tools/testing/selftests/mm/ksft_kmemleak_dedup.sh
> index d01950244490..2db7f006808f 100755
> --- a/tools/testing/selftests/mm/ksft_kmemleak_dedup.sh
> +++ b/tools/testing/selftests/mm/ksft_kmemleak_dedup.sh
> @@ -19,24 +19,30 @@
>  #
>  # Author: Breno Leitao <leitao@debian.org>
>  
> -ksft_skip=4
> +# KTAP output helpers (ktap_skip_all, ktap_exit_fail_msg, ktap_test_pass, ...).
> +DIR="$(dirname "$(readlink -f "$0")")"
> +# shellcheck source=../kselftest/ktap_helpers.sh
> +source "${DIR}"/../kselftest/ktap_helpers.sh
> +
>  KMEMLEAK=/sys/kernel/debug/kmemleak
>  VERBOSE_PARAM=/sys/module/kmemleak/parameters/verbose
>  MODULE=kmemleak-test
>  
> +ktap_print_header
> +
>  skip() {
> -	echo "SKIP: $*"
> -	exit $ksft_skip
> +	ktap_skip_all "$*"
> +	exit "$KSFT_SKIP"
>  }
>  
>  fail() {
> -	echo "FAIL: $*"
> -	exit 1
> +	ktap_exit_fail_msg "$*"
>  }
>  
>  pass() {
> -	echo "PASS: $*"
> -	exit 0
> +	ktap_set_plan 1
> +	ktap_test_pass "$*"
> +	ktap_finished
>  }
>  
>  [ "$(id -u)" -eq 0 ] || skip "must run as root"
> -- 
> 2.43.0
> 

-- 
Sincerely yours,
Mike.

