Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1478BC79FA1
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 10:13:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 089C96B0093; Tue,  8 Sep 2026 06:13:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 061A66B0095; Tue,  8 Sep 2026 06:13:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E94626B0096; Tue,  8 Sep 2026 06:13:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B74686B0093
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 06:13:41 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3CED71A04F6
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 10:13:41 +0000 (UTC)
X-FDA: 85190183442.16.1AB8CCF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 692A31C000A
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 10:13:39 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OO5YyETh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788862419;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s5Rhz3vZATjbgv4L2KAACRCIbtaQyFKnS2m/CL22BH0=;
	b=rgHqo9TOkZb10ERq52IDn1PCbzsRRLfRAan5u5avQPlFySW1i3mI4LTd6JoL1hj6s7dFNa
	xEbM1bfme70e9bsS1JPRNeQ8RxA7cC9PwEf/oZfUdJ57QKknW5yMDImM6RWQNT/kSXjEhb
	Ph9hpuRZ45897utiVg928zzXXfgDgIo=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OO5YyETh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788862419;
	b=BQaLxp4JrR9b0UJBfMipPZrFLWI4Dk58xhmP+tTLFNdfeW+7klzZxemQr1LKY4+cQG8/d1
	hpSR9YXtiZsonMjsyMgk+MoWTO4I4+8GYjCEtPhN6uRfM6ZhLOd19SAW3JlvO9uT9hLynW
	i694K0S1bkkhD/0eb8yfWA7GvDMKpxI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 39AE6413B9;
	Tue,  8 Sep 2026 10:13:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D794C1F00A3A;
	Tue,  8 Sep 2026 10:13:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788862418;
	bh=s5Rhz3vZATjbgv4L2KAACRCIbtaQyFKnS2m/CL22BH0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=OO5YyEThil9/HPDJqoIpj1Ew48vNHqwYqwgFZG09fyVBdWNykF7HX/zrzOp1X+egE
	 c0JHpYD0fJtjE2J/OxgDUrDOrwQGsqY8cKYgf9Nh4dgXFUaDA+mhh21BeAWQHvgO1e
	 FybHHB8M0FbsEEaJmOKRedjFAiQ7Bg8NM0FrJfJQEVsIpxwd6RwIWX/W8mi8tMnKQ5
	 QQQwz6oOprf0KFSJNTTbFexVcGiO+t8E/iKhnsPoayZz2HRcLGqURRC8hsWkOLVJx6
	 Pp0/QHNDZOD2UpFdE/blACWUocYPjIbVp+2k06z5jDSVV0Q1Ql6tx3+Rae0mUR6ZOE
	 aWiFMONpCEtUQ==
Message-ID: <d6ca7f47-39bb-43b4-92d6-63ccc148ebdd@kernel.org>
Date: Tue, 8 Sep 2026 12:13:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] selftests/mm: Reject invalid test selections
 before running tests
To: Tianyi Chen <hi@tychen.cc>, Andrew Morton <akpm@linux-foundation.org>
Cc: shuah@kernel.org, linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, jsavitz@redhat.com
References: <20260906135444.749144-1-hi@tychen.cc>
 <178886112560.138404.1278745290043112298.mm-cli-v2-0@tychen.cc>
 <178886112560.138404.14562368683011041790.mm-cli-v2-1@tychen.cc>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <178886112560.138404.14562368683011041790.mm-cli-v2-1@tychen.cc>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: f6jp133xg8bswardk9fsr16krcgnkhtj
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 692A31C000A
X-Rspam-User: 
X-HE-Tag: 1788862419-523712
X-HE-Meta: U2FsdGVkX18yfRqsYOLEJoLlR5iWr/VSQCP2P77gF1NJ9dyphBErPUZ0idXC+3KWRMVyitLFMg/eWxDeVzHldfSUdG5hnhQOAlcuCfJH+DkhZS3fOKxM7Jpnl98mpvcEFfZJFZUMnjEesUYSMil543FxumV54I8rCknr1IsV7HLbgdIfQoQ+cLO2w0Qu5LH2cWDfw9hyl2HXci74Wt11drDMT1GIyJKSAaQc04fPW/hTKduJWI9kzcUkvMriybW1ygrJL3vwkLBdjaPN/hW5M+pNs5+bs88isAS04zNL8efRCuJdhWS3RXbSDHKQtd6lTX9iYK3x+pVYXH+7obYBBgk6QwyWzLIJbaNZhaxnN+oH/J5tVLPisX0KGsMVM+sY8clRNAmK5na+FUpVis+FmkTsXGUAM1kM0UYo2HQeX+Ojx7d/wi56LVXHqO4xqRz6xER/JePNjMOFkBaWPrh4wKWLhAZq2T/1Du1gDqLcz0fsvg7cE2txNs1F2yITGhPWslItZWrL4LeW5JVYkmwSrjQHsA8CXQKEzO2iJa8tdlohP+lzyk5anqb/WOc6Ci5xho+PBTuLbOp8XObitehbe8SsvhlULD3wNdFlWOJtFIoS1SBNUI7R0HJVZbJ8YxDSvlHCkV6J783thVdnqbmnwTsyhsPheiBTH0PTrjERBCoxQILHr1nV5BSFz2P2K1ckbHAPFp1n+UexcU9GLwKu9pgws+IYSUnU9H6GnkI11SEyOhNsBjI3CQ5gaLPA3ecAtFHxG+bas4TqN+z7eHRLVynI4IzxInrAlLjq5lKdFPSDdz2Re0jBFupwBNvx3uWrk/xcnE/zGtlhdhBNEm+7S3V7gGy8lO3D0SRY3W9wpnNm6qam15ccfk+0qaE+p6k+otS0bXFEEbLZ9z0gkC1NIw8a7aQC9gWpLHsctO3z3SViR6ioy5RrD9RoX7W2tstnRsfoPWDqZCAX8p1XMiy
 1et3MEzn
 hYWdevmo6xo848ivX7GVIguIuDc1u/b5fCS/nDU/VD1ZQ0pnSqzgjIea11k6pbYhRb6CCPUzb/tlJpBts65suWnYx1+nezzNhZZX4noYF69rcEYL71oYvlUH73fJd9ADzgKaevLxUv7FRSCLSmvLmd27P+ELcOpBsjvIn+3AKyHi/LBw4MckzLwWV01NQMhWqztBj0+wTzkqCjKIp81kbKkG73O8nYC17wTL6Fkyni9scQVmesmBT8Mw77wZ77P1mbpLM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/8/26 11:55, Tianyi Chen wrote:
> getopts reports unknown options and missing arguments, but run_vmtests.sh
> ignores its error result and continues with test setup. An empty -t
> argument also falls back to the default selection, while unknown category
> names can silently select no tests and still reach setup code.
> 
> Exit on getopts errors and validate category names against the existing
> list in usage() before any test setup. Reject empty and whitespace-only
> selections, and normalize category separators so validation and execution
> agree. Keep the default selection for an unset or empty VM_SELFTEST_ITEMS
> environment variable, and preserve the existing standalone default value.
> 
> Fixes: 85463321e726 ("selftests/vm: enable running select groups of tests")
> Assisted-by: Codex:GPT-6
> Signed-off-by: Tianyi Chen <hi@tychen.cc>
> ---
>  tools/testing/selftests/mm/run_vmtests.sh | 27 +++++++++++++++++++----
>  1 file changed, 23 insertions(+), 4 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
> index d09f9f6a384..836c7454cba 100755
> --- a/tools/testing/selftests/mm/run_vmtests.sh
> +++ b/tools/testing/selftests/mm/run_vmtests.sh
> @@ -96,26 +96,45 @@ separated by spaces:
>  
>  example: ./run_vmtests.sh -t "hmm mmap ksm"
>  EOF
> -	exit 0
>  }
>  
>  RUN_ALL=false
>  RUN_DESTRUCTIVE=false
>  TAP_PREFIX="# "
>  
> +# An unset or empty environment selection keeps the default behavior.
> +VM_SELFTEST_ITEMS=${VM_SELFTEST_ITEMS:-default}

Who would set it at this point?

Can't this just be

VM_SELFTEST_ITEMS="default"

> +
>  while getopts "aht:nd" OPT; do
>  	case ${OPT} in
>  		"a") RUN_ALL=true ;;
> -		"h") usage ;;
> +		"h") usage; exit 0 ;;
>  		"t") VM_SELFTEST_ITEMS=${OPTARG} ;;
>  		"n") TAP_PREFIX= ;;
>  		"d") RUN_DESTRUCTIVE=true ;;
> +		"?") exit 1 ;;
>  	esac
>  done
>  shift $((OPTIND -1))
>  
> -# default behavior: run all tests
> -VM_SELFTEST_ITEMS=${VM_SELFTEST_ITEMS:-default}
> +# Normalize whitespace so validation and test_selected() use the same names.
> +read -r -a selected_categories <<< "${VM_SELFTEST_ITEMS//$'\n'/ }"
> +VM_SELFTEST_ITEMS="${selected_categories[*]}"
> +if [ -z "$VM_SELFTEST_ITEMS" ]; then
> +	echo "No test categories specified" >&2
> +	exit 1
> +fi
> +
> +if [ "$VM_SELFTEST_ITEMS" != "default" ]; then
> +	# Keep the documented category list as the source of valid names.

That makes sense to me.

It's interesting what would happen when trying to run a test that does not even
exist for the architecture. Getting some feedback that the test was skipped
would be nice. But that's something for another day :)

-- 
Cheers,

David

