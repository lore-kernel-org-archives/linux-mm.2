Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D46AEC61DB6
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 09:26:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D2C956B0092; Tue, 25 Aug 2026 05:26:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDCE26B0095; Tue, 25 Aug 2026 05:26:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA4356B0096; Tue, 25 Aug 2026 05:26:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8B1736B0092
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 05:26:48 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BB50B40321
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 09:26:45 +0000 (UTC)
X-FDA: 85139261970.02.5498914
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id E80051C0008
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 09:26:43 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JfmdplgB;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787650004;
	b=tUlvIzlVK9WB8qAfBBmr68Kf4fL/H+vuYDjt7L9mRTIpdiDL7802Em38kL77pI/oiu+gVZ
	7IBJOoWQvmKFpgH7renus7VadDZ4nS1gYYqhReizfxnZJstR61H7R0dtAnN6McG3QX1cq+
	bszOHVx3VPF6ZzJ+l9eIVVHIgZ2/VN4=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JfmdplgB;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787650004;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UmUyVVa+WflnhGfl07gzLTmeXFopbRWv+zX6OfCXNrA=;
	b=AGQPPJdfa9s6WqighwYLj6EKILbUk9UXZzcKctKi8YHXYNlBh8wmQuR5CH4Kj02uQ4aQht
	7hWJyTKfAn/ocXmoEYwSEA3m1NbOuvyuaXfYHWX7RRu9xDLqTnIEpQcxJ2XGKx3rqgDVUS
	gtknKb9HAoUx3J9hd9V8IJoXY4DUul0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C0DAF40660;
	Tue, 25 Aug 2026 09:26:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B65A61F000E9;
	Tue, 25 Aug 2026 09:26:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787650002;
	bh=UmUyVVa+WflnhGfl07gzLTmeXFopbRWv+zX6OfCXNrA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=JfmdplgBON/cgFMpk4wRz0eFysPpvZ7PIYKtve+jg8h7uMo2WPQnCll0J1Dxyu/Zi
	 12Tem7CceWBPEfK+0DJ4sFKM7PU2Qc2N+6fA/3nrsb5DyROYlvKr3ezDj9K+VZILXT
	 2vmjlDgwvTTcddjkCBaUYAwIWVlvb1jxnnTmY6qz48YslR1XY4BGMACZgCvs0QgscO
	 acI6pa0AfgLwN4cg/ALtszNK+/jQag2LHQiwsgYCNDZYJlJmBXHtCgaQV+HfDIWOjx
	 C5VZI89No/zhVkk0sYr/cqD0w3CIkN/Eo/IpHdJ/nvBsXJj2OdW6+TioZuHJArIcpX
	 pFz1JZlG47VyQ==
Message-ID: <787b5acb-978c-453a-be81-812269f47f40@kernel.org>
Date: Tue, 25 Aug 2026 11:26:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 6/6] selftests/mm: add a GUP selftest
To: Sarthak Sharma <sarthak.sharma@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Jason Gunthorpe <jgg@ziepe.ca>,
 John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>,
 Leon Romanovsky <leon@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>, Mark Brown <broonie@kernel.org>,
 Anshuman Khandual <anshuman.khandual@arm.com>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260813181230.483746-1-sarthak.sharma@arm.com>
 <20260813181230.483746-7-sarthak.sharma@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260813181230.483746-7-sarthak.sharma@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E80051C0008
X-Stat-Signature: gxtqimds11nteot9ptpuns1kmuinimy9
X-HE-Tag: 1787650003-873066
X-HE-Meta: U2FsdGVkX1/cmldHHINt2LbdEJRhCpmCMtu5WyDvU6DGsWyKPCsquRG48/6Q4ejVgN7IBYckhzX/ZotE80DZ/QIfkav0o233eXcmmV3hTivKKKqJopMw8r/t5DwF+mFApKI666xuE5aJZsSKlJcS/l2svgTNyxMazZC09nnwD0ZZZnYQD7BOFF9q9tu6d04K7d9lsBMPcO5HFAC7sVJFIoKP30kQ1UMy8dMDp3HMioSQH29FZwZNN9/L0+UoIWd47th+55AeB8kwI1hm+HaQ0hAPh8NEKXlnU2POYGO3jsEwiiI0N2jXxBEKtbMLveuRzBCd9L0BT0w+8UNBbxlAXVK3AnAravnlXT4QTnQBXCBMUcONwAVYYeVD3S4917QWbj1v01q3RUXCHFZDmX7+2peQUoY1tHY70LRCwy8DtNF3rDccgnbynclFMw4CJpr94YshOZTtsf+1gEYwQVAp8TUuI+ygKuuqDm6a6bmtNqVlJ4X/T6oYJbz8Q7SsQNKH4/BI6dkUmD2vaPkeMMmzUhhVpUHHD1Eys5+H7Bbu898LcpEnuq5YTOnk6xd3w6p3MIhf/qg8HggVna3Qy42Udr89hu2B9WiOrB6Mfw4/QBzjuZWCnq730Pw8G6+VWUcy7112yrgk78cijROR6Gx+MxF3OP9KZu+tB66gB+OmxYrRQWf5zqvck/1k2wOca/t7WzQ1MGI8TiMsm5+nGn8LALg6peOwODI8oNjQix6tBE3HmBwZZg12zfIFDzUFM4+YKQ7a8bGGFjQ27oxx7EHSkj7zbTHzdjJqsJh59Tk/7m2v+4fXci6mrJG7pdvlMYRQFNqrQRosIFPHjQBKT8ReQ0H1tG4kJ+xdQPnKQiJEot3pBervKOokbat2qZPG/2RxJSllX4aybTD1eeKXWC/2licZWggvMngO12cqUXfEMD/rIzM/XYaSUS8zUPYhJq9YfeAuDgz6sBLBKMnd8j/
 rR87zgJJ
 Dzq2PSYwgx3XEuFTVUSnOGSaCgoMt8+Pxf6zBg2XvfSs/mKhaa1my3/peLUy1mu6OKdSnVHQVG8WdlB4edItew3+JFA4MnHaBTWpUmJBgXfXe2Nbn38tJ8xUfLZeb4regTFZje9CzoAAwGOX/zEEkf/3V8trEnR2MjTxV1NSYivIJqOduii8rdvSvVHzg6u1pOJID7BLvEuoK3q6Nd229PiiLbPLBJADZbatlvS5tFbMnBSY8Y3NYm7zmKicLy1oNx+3EtTOgBJxRO/AoK3jecyOab/i8P2HcNKTg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


> diff --git a/Documentation/core-api/pin_user_pages.rst b/Documentation/core-api/pin_user_pages.rst
> index c16ca163b55e..1564b16994ad 100644
> --- a/Documentation/core-api/pin_user_pages.rst
> +++ b/Documentation/core-api/pin_user_pages.rst
> @@ -228,12 +228,18 @@ Unit testing
>  ============
>  This file::
>  
> - tools/testing/selftests/mm/gup_test.c
> + tools/testing/selftests/mm/gup.c
>  
> -has the following new calls to exercise the new pin*() wrapper functions:
> +contains the following test cases to exercise pin_user_pages*():
>  
> -* PIN_FAST_BENCHMARK (./gup_test -a)
> -* PIN_BASIC_TEST (./gup_test -b)
> +* pin_user_pages via PIN_BASIC_TEST
> +* pin_user_pages_fast via PIN_FAST_BENCHMARK
> +* pin_user_pages_longterm via PIN_LONGTERM_BENCHMARK
> +
> +Run with::
> +
> +  make -C tools/testing/selftests/mm
> +  ./tools/testing/selftests/mm/gup
>  

Can we just remove that testing part in that doc completely in an earlier patch?
I don't really see the reason for documenting selftests that way.

In particular, now that it's a proper standalone selftest.

>  You can monitor how many total dma-pinned pages have been acquired and released
>  since the system was booted, via two new /proc/vmstat entries: ::
> diff --git a/MAINTAINERS b/MAINTAINERS
> index ed9a8549ae31..861504fa2e31 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -17032,6 +17032,7 @@ F:	mm/gup.c
>  F:	mm/gup_test.c
>  F:	mm/gup_test.h
>  F:	tools/mm/gup_bench.c
> +F:	tools/testing/selftests/mm/gup.c
>  F:	tools/testing/selftests/mm/gup_longterm.c

[...]

> +TEST_F(gup_test, dump_user_pages_with_get)
> +{
> +	run_gup_cmd(_metadata, self, variant, DUMP_USER_PAGES_TEST, 0, 1);
> +}
> +
> +TEST_F(gup_test, dump_user_pages_with_pin)
> +{
> +	run_gup_cmd(_metadata, self, variant, DUMP_USER_PAGES_TEST,
> +		    GUP_TEST_FLAG_DUMP_PAGES_USE_PIN, 1);
> +}

I really don't like DUMP_USER_PAGES_TEST: running the selftests just fills the
kernel log with useless information. And it's not like there is real value to it
beyond what the other tests are already testing.

... or that we would verify automatically what is being dumped makes any sense.

I'd vote to not add selftests that use it.

It was added in

commit f4f9bda418ab8b4dbc5372e9e2a28162f7777154
Author: John Hubbard <jhubbard@nvidia.com>
Date:   Mon Dec 14 19:05:21 2020 -0800

    selftests/vm: gup_test: introduce the dump_pages() sub-test

    For quite a while, I was doing a quick hack to gup_test.c (previously,
    gup_benchmark.c) whenever I wanted to try out my changes to dump_page().
    This makes that hack unnecessary, and instead allows anyone to easily get
    the same coverage from a user space program.  That saves a lot of time
    because you don't have to change the kernel, in order to test different
    pages and options.

    The new sub-test takes advantage of the existing gup_test infrastructure,
    which already provides a simple user space program, some allocated user
    space pages, an ioctl call, pinning of those pages (via either
    get_user_pages or pin_user_pages) and a corresponding kernel-side test
    invocation.  There's not much more required, mainly just a couple of
    inputs from the user.

    In fact, the new test re-uses the existing command line options in order
    to get various helpful combinations (THP or normal, _fast or slow gup, gup
    vs.  pup, and more).


I can see why we might want a dedicated dump_page/dump_folio test that either

(1) Is ran automatically and actually verifies (somehow automatically) what is
being dumped checks out. More tricky.

(2) Is ran manually by a suer that verifies whether what is being dumped checked
out. More feasible.

But as is, for an automated test this doesn't make sense.

Maybe we'd want a dedicated dump_page test tool in tools/mm that would make use
of DUMP_USER_PAGES_TEST. But maybe we also want to remove DUMP_USER_PAGES_TEST
entirely and have a different way to trigger+test this.

Ideally we'd have a proper automated dump_page test that actually checks
expected output (somehow).

-- 
Cheers,

David

