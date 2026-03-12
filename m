Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5FA1F106ACE3
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 19:46:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BBED06B00A8; Thu, 12 Mar 2026 15:46:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA0476B00A9; Thu, 12 Mar 2026 15:46:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A9EFF6B00AA; Thu, 12 Mar 2026 15:46:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 99F4D6B00A8
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 15:46:34 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 61F7E140244
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 19:46:34 +0000 (UTC)
X-FDA: 84538443108.05.3349265
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 84601C0009
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 19:46:32 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Vv6mlBid;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773344792;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sTT4RH6780QWVmjg6JTHH1UNfZfs6GEfTIRXg8kD86Y=;
	b=28KZKBDUyh/NDXTQ9V0BP9wgamOJhi3ZFTvv0WrQBuW1LHojPsguNcjCw8pDOI6emMaaV4
	W+MMaqscMOsSlK3r0PrS4k9VRoZMM4qC57hGAsIebX7XdvApU5bSmHOQ+9UUruDJ7TbNT0
	DZsmtwVwt2jQo7sG/oA3iwUp58l5ddY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773344792; a=rsa-sha256;
	cv=none;
	b=LtpTlW76DLR0w9jebzSvgrEKtuukAa3ercGRX+916UnFO4F7RUA9JOUMPEthF0DwN/xEQ4
	Bxw6t5H/YJdwf8SIsHtcFyaDsGgSpjshSa0nhEdUGsG6NGVcbZZEmpFJXcGDMHiw2SIUFY
	PLMKztQgh9DbUBoOiXm7cEaAGBI6Sqg=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Vv6mlBid;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 81608417C8;
	Thu, 12 Mar 2026 19:46:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AEAEC2BC86;
	Thu, 12 Mar 2026 19:46:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773344791;
	bh=rykPRN1FYjIreyRwG0hb5ykSR6iWMPyvxd3LU2ySx+s=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Vv6mlBidq0xdvRwE/FEsa7LWXCybJejrdE0R1mR6a/WV2VgVJEoXdFVaSaeD9qXV2
	 P3rmPZBXXvBfltix156XDzOjUV54aDlByLlxXqO4R0ZrhbBXWLx2frYWWzLFtHbwIj
	 44Ql8DGtTDeH8K8IHiZje48PLn0NNMgYwPKvSv9Nzv1nFzZPC0BsDntSdxYiLjoqAy
	 3S4pZxgoszi9RlHHHViFdS58JFGvQTcOJlH/P2J8m5VR0UNWEbZt/99CKaaud8ZjxU
	 VnHGbwfRjo3i9hNu+mBr10xbvXdwZoErpAA0hT6khurgUvplJ7kKcB/2uUpRQCvL7A
	 6FpYIjhreupLQ==
Message-ID: <708647e9-fc49-430c-a12c-f2b44caa273d@kernel.org>
Date: Thu, 12 Mar 2026 20:46:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RESEND PATCH 4/4] selftests/mm: transhuge_stress: skip the test
 when thp not available
To: Chunyu Hu <chuhu@redhat.com>, akpm@linux-foundation.org,
 shuah@kernel.org, linux-mm@kvack.org, ljs@kernel.org
Cc: linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
 Li Wang <liwang@redhat.com>
References: <20260312114027.634559-1-chuhu@redhat.com>
 <20260312114027.634559-5-chuhu@redhat.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260312114027.634559-5-chuhu@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 84601C0009
X-Stat-Signature: 6sspot8h1kx48kcoobmdzrg17bk6ffbk
X-HE-Tag: 1773344792-739787
X-HE-Meta: U2FsdGVkX1/9FD79DH64cOFqZiYcpQ9xhwDlNY83sQ1FpF7Ekhf0DuG/2qQm9YwjUcybCWdAK4c+H2yle5ba9fxhll3z8QvibeSUdTxSjiBV1BAdz9jL7vkaEdS5DO7yRtfQjqHZUMvgBXY9HxnzT7sMNpI8hXc8ZS+vBKmymoCbOnSduBOkKXw1GdYxvA1m2Mob/sLEbBnwQ2mKV6Y7xl/DDWIN5LT02Y26by1zoAUSpgQ3Gsy14ULNBdbtgNg3zbV/Ctku+mcLHvi4vjDYoZ+YbDp3553Z4fxFhTldu8/5bWwNa3s2EXkGS8lUpE/AhFtTylKQE9av9Zjzl4q5m9CvJv4dW+HBnjNTxXKMYiyP6e/tiMt6wR5hKV7nzrEPP3JklAhOtwd6tQBarkG4+drOfV8HYl4Ap6osdl+6ivfaynzAa2zt1aDvQq2nGZ7J7IoGYkhL5Hfi1/AyZk48o4H7CJXvNOxe1T2K8fGuygpcdqFXoYr1SzaYmcFcR6ZxEbyK4aqBl88RalqnfygHnsF/i/aBxzvUsT2wy2qQxUiaiUG09hSYo1NTwuHtRU95qcjht1usuTuMAOZ4Bs3GlnMZxhnNvlhku6Rz+PIqrT15JXfAN0aa5WgIWZLcciA4c8s+TPu2o4SE1BpBx04wIJ5OWfX/FpZ6aTz4mSuGJhtfJO2WA4IqeyFENn/iFF0dJoS3UGm8jMqGPUwWDVHFjpB1FFAdwwmYeJPwdjfh477Qj339RAzDBTDArx0bp0/tzRSfKDyreHFVjitEOMa+BrJUdYy59WWVAoqwl0ZmLXWbagm6wKgohf6rNYLueznlv5e0WWzQnPdjad3Bwp6CjEMheDL1CqqhHPnz7AuMEPLCgMRrOYhvmMyVKDHzfK+bkzKOm79kAPaKMiMQ/vwxBpqskNBYp8fN65+d7a7eYs33tKlzPLU7pewLkwJYOmyzchUWhJgIydUaKlWUl60
 oWJ0+6/O
 zpZf2ry2i4c7N0W/Ll2YnCo5XLS0qWBcz3gvjJ+jPBahLuUcE9lAyKYJ8jlIBlAvh4cfXJeehdJexROzUzCZGHVJB+awA1vLS4eErDDvf4Vd7irb1+cs6kNSPhg6KmTEnRWGA9vNAS+Gr/3xRww9tZJDxPyeOWLJ2zBXyxRaaGGXbnHrROpQPYXET/b0uby3iWwIeRQRCgn2yFL60tEBHy17NfkrwjpdbWio5dwri8Bv0VRQiZyc2XpTPVZucOfr7MBJDzJ3AYU1icx4AyWk0EJBNLP6bmFQZ2CnX89lkdu8Dkdr710oc62CEJDboOlNFqHW1J2aON0pqLSA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/12/26 12:40, Chunyu Hu wrote:
> The test requires thp, skip the test when thp is not available to avoid
> false positive.
> 
> Tested with thp disabled kernel.
> Before the fix:
>   # --------------------------------
>   # running ./transhuge-stress -d 20
>   # --------------------------------
>   # TAP version 13
>   # 1..1
>   # transhuge-stress: allocate 1453 transhuge pages, using 2907 MiB virtual memory and 11 MiB of ram
>   # Bail out! MADV_HUGEPAGE# Planned tests != run tests (1 != 0)
>   # # Totals: pass:0 fail:0 xfail:0 xpass:0 skip:0 error:0
>   # [FAIL]
>   not ok 60 transhuge-stress -d 20 # exit=1
> 
> After the fix:
>   # --------------------------------
>   # running ./transhuge-stress -d 20
>   # --------------------------------
>   # 1..0 # SKIP Transparent Hugepages not available
>   # [SKIP]
>   ok 5 transhuge-stress -d 20 # SKIP
> 
> CC: Li Wang <liwang@redhat.com>
> Signed-off-by: Chunyu Hu <chuhu@redhat.com>
> ---
>  tools/testing/selftests/mm/transhuge-stress.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/tools/testing/selftests/mm/transhuge-stress.c b/tools/testing/selftests/mm/transhuge-stress.c
> index bcad47c09518..76316696426d 100644
> --- a/tools/testing/selftests/mm/transhuge-stress.c
> +++ b/tools/testing/selftests/mm/transhuge-stress.c
> @@ -17,6 +17,7 @@
>  #include <sys/mman.h>
>  #include "vm_util.h"
>  #include "kselftest.h"
> +#include "thp_settings.h"
>  
>  int backing_fd = -1;
>  int mmap_flags = MAP_ANONYMOUS | MAP_NORESERVE | MAP_PRIVATE;
> @@ -35,6 +36,9 @@ int main(int argc, char **argv)
>  	int pagemap_fd;
>  	int duration = 0;
>  
> +	if (!thp_is_enabled())
> +		ksft_exit_skip("Transparent Hugepages not available\n");
> +
>  	ksft_print_header();

Shouldn't that go under the ksft_print_header(), like you did in patch #3?

-- 
Cheers,

David

