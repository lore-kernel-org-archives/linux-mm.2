Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7ECF1C5DF66
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 11:25:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A8626B0159; Mon, 17 Aug 2026 07:25:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 780136B015C; Mon, 17 Aug 2026 07:25:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BD9D6B0681; Mon, 17 Aug 2026 07:25:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4C0CE6B0159
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 07:25:16 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B9FB1C0718
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 11:25:15 +0000 (UTC)
X-FDA: 85110530190.14.5083A1B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 1E6EB140009
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 11:25:13 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UiVG1LTJ;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786965914;
	b=8budfBVhOPrFA8ABZoNn5+EuUkaEYh01fI1pU7HOYs2Y15Jrj6bOwfGYqUhEmbtJHxAQch
	PfnaMlTYVDelGDlP/YTKmBXaDjSQqsxdAFMunxs1jQbJijZhQFofkkYYCbzRs5GtfcaJd3
	n7M941lmVLvHga6tRaoTvF5/GBakoPQ=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UiVG1LTJ;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786965914;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eodZ9Rb4n0bAkFN1ha9WBQcFvF7IyL6dkjgO4Dxu55o=;
	b=aKGJnfUloQePs1R1g1U5brvqWDL3mge3Y9SJr11AgOtOl7Zg9nffqbL2lX6pGCRe9hP36a
	ZyajUjc4eHoFgvuFOnx/7kvgYlasv4lhFplO7rYJ9bOPWbR/J8ITEnJhENJAgdIce6YQII
	79FlcSF0dMI5EK7TnHsnm+ZlmVvud7c=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 99285600AE;
	Mon, 17 Aug 2026 11:25:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83DCF1F00A3A;
	Mon, 17 Aug 2026 11:25:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786965913;
	bh=eodZ9Rb4n0bAkFN1ha9WBQcFvF7IyL6dkjgO4Dxu55o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=UiVG1LTJOaeHPT0ju9HwdcPGncOk6n2w46S25K8L0FRM2K+49EljiwcS1/bEbnt/d
	 pbTGQGs88PF1s1E3Mikz+gBsAY3W5pvED66K8q6bDZIiocQu3TcZjsimuk3LfYc2Gi
	 HDjTDtR2UCWezVkZbQ4WQ5UJG/k6NwgNUoKOvfjcPBapaWrHRHegpxpj2t2Fp9JaXx
	 lnt5iQzmav7ZfupU7a7ju9n8sgvz+swnkF/Gs0Iqt58yVwe9L6VCSLrBjFkCcTBKN3
	 t89SKumI9OQNvl5AeigM/DmEyzunlK7n+1A8UeYd348M/pLSvhq9wE27NAQvN4EdKR
	 2m+YvCR/kzmjQ==
Date: Mon, 17 Aug 2026 12:24:54 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Song Hu <husong@kylinos.cn>
Cc: akpm@linux-foundation.org, rppt@kernel.org, usama.anjum@arm.com, 
	leitao@debian.org, linux-mm@kvack.org, shuah@kernel.org, david@kernel.org, 
	liam@infradead.org, vbabka@kernel.org, surenb@google.com, mhocko@suse.com, 
	peterx@redhat.com, linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] selftests/mm: emit KTAP output from
 ksft_kmemleak_dedup
Message-ID: <aoLvf6jyaQaYDixW@lucifer>
References: <20260815084231.3630742-1-husong@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260815084231.3630742-1-husong@kylinos.cn>
X-Rspamd-Queue-Id: 1E6EB140009
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: huxnzzbtr889ezcchensgbwbqmejfnbk
X-HE-Tag: 1786965913-304738
X-HE-Meta: U2FsdGVkX19ARiDOEJcnk4gRcemvajotMX6BaOxlTvBYHGdjOEHExM1pTJGgsOBl0q2m8N/p9VQu2RhocSUlthU9Vr0C2NWwlIrk/aJfgfgGI3w67oQDzUinXvcbeq+eN/aDX00A54ei9ERTR1r9xovhO6dcFOUNk5so0TScsL877izk4Z3PorIJn6apXUzsGMhf6OPsOSD7L1ydjBYfc4miC0QzfSEy2xw5chBR9Arby5EkUpnG1S2pm2xoCj3R5+/1lGnqI+xYIG7PZbWX2Hen+eWJfXV6A+DLATCS0kTPdpy082PAiKR6X//UucEWZK+1A7Pgw4zsvjsKv9jHN6wwjVMNLc3cwdoMfDpWOVQXkEHn0hnbqQu6C7wsWXFW2drktXdKM/rSnXG+pxc96rjfA8QUmx1Y4IcicJ8YE/MYwvkuJmooIoLkeMJ4T30LX2vYodJd8SvIsWHVmTfRTFM3U4Uz19OyDfTjzwpR3lLzNft6Of4xfhcCJ+gSYelBuBrqWPOHhN0HkYU/IjGx/7fjuPcYDl1y/Wgk149yW4zNVlsLesbNx3eYlMeVe/KX3sm40cVv5m+FExnDj6TJpcGd5c67Y2aTDFjv59WSNaMWJefyEbYgUgiMLN+TK7sycxRWNAewr94LUGgrxm9w7c/xiIkqUvqw5ECRr7dIAQqPpWLZfXbW2gCFIvjVmv52xwqA+GYb91adVlxyGCNdmWgvLIk7uu3fM0Ok1bn0sq9j+WRI0p+eTrwZtx5HIjRdpakwVqh7iJ9NmzDV2/duS1IR4MDMkGCKhi/mgW7XXyGNfpO8Z87lSl5YZBqBlFoohytg7BC4jHinCjzdrziAj+lo68zvj7a9aV6781JwN3vWnrDRdWMG/MgV6br6ajcNRh3d3k3yu+2ZcggGUkoNu5jHTupkueUJW9XRfcYXNX/gGib25z9CLFMcDGnFCvUkp45HZtxudYIb1Y3qBed
 Fslg+aMR
 p/1U4K/icP7b0ckWYcKSoHMdxcYAldTuBJf6T1aJpcaBAJeNGty49dx2N0OyrRHrHvHL4/qOPc57nyR+1/y0LwfRmDhtguoL63lO6LFBVT8tr/PQFBmd5A50gA04dFfgUoH1hpiTYGUeK8c/LKN5t37EZefBpuOkU+EsY24ZL2O89qW45+ouW/b6dOEdR4l/IR1yVmQm64y3k2ku3Ug0P1WU83d+ATfKNUUOHo1MeuVAmEBAt+f1h/IJ1o3dMwv3JaDbpHokOC80k7jwXKd5LNRrZW14tuVVzGw3u+sYounLaM75Te/9Kx+QcB6IrbBx4QUziLzupTH0OKSOdSS58uhVxLg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 15, 2026 at 04:42:31PM +0800, Song Hu wrote:
> ksft_kmemleak_dedup.sh reports its result with raw "SKIP:"/"FAIL:"/"PASS:"
> echoes and bare exit codes instead of KTAP, so parse_kselftest.py cannot
> read it.  Convert it to the ktap_helpers.sh API, like its sibling
> ksft_kmemleak_confirm.sh.
>
> skip() and fail() emit ktap_test_skip()/ktap_test_fail() instead of
> ktap_skip_all()/ktap_exit_fail_msg(), and a single ktap_set_plan() at the
> top covers every path; ktap_finished() then prints the totals line and
> provides the exit code for skip/fail/pass alike.
>
> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Reviewed-by: Breno Leitao <leitao@debian.org>
> Signed-off-by: Song Hu <husong@kylinos.cn>

LGTM so:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>
> Changes in v2, per review feedback from Usama Anjum:
> - use ktap_test_skip() instead of ktap_skip_all(), and ktap_test_fail()
>   instead of ktap_exit_fail_msg()
> - move ktap_set_plan() to the very start so it covers all paths
> - call ktap_finished() on the skip and fail paths as well
>
> v1: https://lore.kernel.org/all/20260812132142.582390-1-husong@kylinos.cn/
>  .../selftests/mm/ksft_kmemleak_dedup.sh       | 21 ++++++++++++-------
>  1 file changed, 14 insertions(+), 7 deletions(-)
>
> diff --git a/tools/testing/selftests/mm/ksft_kmemleak_dedup.sh b/tools/testing/selftests/mm/ksft_kmemleak_dedup.sh
> index d01950244490..fda6a9340e0e 100755
> --- a/tools/testing/selftests/mm/ksft_kmemleak_dedup.sh
> +++ b/tools/testing/selftests/mm/ksft_kmemleak_dedup.sh
> @@ -19,24 +19,31 @@
>  #
>  # Author: Breno Leitao <leitao@debian.org>
>
> -ksft_skip=4
> +# KTAP output helpers (ktap_test_pass, ktap_test_skip, ktap_test_fail, ...).
> +DIR="$(dirname "$(readlink -f "$0")")"
> +# shellcheck source=../kselftest/ktap_helpers.sh
> +source "${DIR}"/../kselftest/ktap_helpers.sh
> +
>  KMEMLEAK=/sys/kernel/debug/kmemleak
>  VERBOSE_PARAM=/sys/module/kmemleak/parameters/verbose
>  MODULE=kmemleak-test
>
> +ktap_print_header
> +ktap_set_plan 1
> +
>  skip() {
> -	echo "SKIP: $*"
> -	exit $ksft_skip
> +	ktap_test_skip "$*"
> +	ktap_finished
>  }
>
>  fail() {
> -	echo "FAIL: $*"
> -	exit 1
> +	ktap_test_fail "$*"
> +	ktap_finished
>  }
>
>  pass() {
> -	echo "PASS: $*"
> -	exit 0
> +	ktap_test_pass "$*"
> +	ktap_finished
>  }
>
>  [ "$(id -u)" -eq 0 ] || skip "must run as root"
> --
> 2.43.0
>

--
Cheers, Lorenzo

