Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B63EEC01A3
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 08:24:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A3E576B0005; Mon, 23 Mar 2026 04:24:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9EF466B0088; Mon, 23 Mar 2026 04:24:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DE266B0089; Mon, 23 Mar 2026 04:24:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7CC886B0005
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 04:24:37 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 97DA9140A63
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 08:24:36 +0000 (UTC)
X-FDA: 84576641352.30.60EA6CB
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf23.hostedemail.com (Postfix) with ESMTP id 46CD3140012
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 08:24:34 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PK0Z+1AC;
	spf=pass (imf23.hostedemail.com: domain of liwang@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774254274;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l4FYRZcJce0iqsefU7RH85JSFRG+Uej7mvnkE77jdLA=;
	b=c11Vl8/WneIAQTs5bohJpTZBlul5J54CyeQ6ypGroizGo1j3R8UGr6fRZ2XioYojD82dPD
	20bhn/tzn7ZF7UW7EQla+eUa1RWpc+NYAfjB4Th4vuHt8qw9D+wYUBkOrLxIREDmgVwaDS
	Ild0U0PQBchXcQjXv/15dqi9LFxTWLs=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PK0Z+1AC;
	spf=pass (imf23.hostedemail.com: domain of liwang@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774254274; a=rsa-sha256;
	cv=none;
	b=Wg2DKPKctg+WPYPyPDf7hBGuRgTmt0e19LoFkMhxIQwk6CPHzQb1rDF/R3kXjpKjPDVCBV
	1PZPgFIO3RLarcwBXubmCPoYO7evr2Pqgywzw8lxpUOJ4XCVSZxgqxDk6uff/uYL42djbF
	A2WjPOhfKj8ajrFE13teVvFy8DXP9Tg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774254273;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=l4FYRZcJce0iqsefU7RH85JSFRG+Uej7mvnkE77jdLA=;
	b=PK0Z+1ACDmH9j7VFdO7z4ZSvKB+27PG4nToCwjcTC2cACQj7OLhgiTzrHZBYTAgwHx2Bif
	belFffgdOLXm82jZV91JoFt0T6SWbDF5hvhosFPQ0iAuGjJmjMLrp8lu9glgkFJ6g7/Ojy
	EpR3Uln6MkR/3KaPV91zQflBrYXwDIQ=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-505-FvlQTu5QPqeQUw3ENTb84w-1; Mon, 23 Mar 2026 04:24:32 -0400
X-MC-Unique: FvlQTu5QPqeQUw3ENTb84w-1
X-Mimecast-MFC-AGG-ID: FvlQTu5QPqeQUw3ENTb84w_1774254271
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2b068299665so32589165ad.3
        for <linux-mm@kvack.org>; Mon, 23 Mar 2026 01:24:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774254271; x=1774859071;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=l4FYRZcJce0iqsefU7RH85JSFRG+Uej7mvnkE77jdLA=;
        b=s+VUWW12rlutMeLgIal1qpxu0eMz2ankr0J3IS44TrqXn5cVCUbjXWa7SLGjkivfxt
         pIsldyDhm1Eo7D/741meouYG8PCokFrUc2umX64haaETa47MNPpIpBxLJDWtsBDrn+dR
         CKMCpnmhcUHUWXbvY04VfcJCuQqquI+zeiOpVGq3euQobVjgBz2dIsHUxJB8VnY30y4R
         GspCCFPdRMjKCiVPXGdk0D1qx9obvJrgz6OlnS5ru2oFsKaRari1wgUOficB8iCjcVAt
         eINob1Kurs6eTEH8aWRkth5wLDlp4ONgUyCno09s31m0scA1tiD8RU1ADz8mMXBr14y9
         SPnA==
X-Forwarded-Encrypted: i=1; AJvYcCXu/w+dEdMPullAgNk4L9kF/4Olow+NJt1zb2VJmnYsXt7xvs22nxLOIsgZAQ0Gw43V/o44kc8Jug==@kvack.org
X-Gm-Message-State: AOJu0YzGHJkosyQUq/GBZdzjBsPPJ+YKJroNKTK+CF3MdftVHS/1n2Sr
	odSR1Bx0zyuBcWCSw4uPpjhcBpd2C+9kmZhgPxAMLocWz6o2nkRVL37T3Du3mHpd7kpHkxqxkdB
	bkEW3GnItl8f1PK//uWWkL8s8q4Ki0+aOZ7VDwjIQFn2MADTkYl36
X-Gm-Gg: ATEYQzzCe1pi2qZNmetbk2pQ/zSqsU6y/tg62lGdFvPbkD4O2r5hsZKpSqcsHBvmvzL
	+yMURzEtwRKDmiHCbHZov21W9cFklAK3QUgd1DdyCQyaN8yMbQc/ltB0YIpFyf2G+5+esPiehhx
	46hwnT9p9jZnY3aCxh4PIGM8bxdxfQ+mLBx1XwLaFnDknvXqGjAn5RXjJdTAX3eYwPy/jx3FNDY
	X+dnrp+tCSnIHa+/SskdEcvSdPl783cvoUg6i2EAUsJx1adkmtttriTuyAQtValQhmL71U1czxX
	sp6eUnFRm/TiOsBId2e/Fs7FOnKjxmh0diwauw6OUrllTtf/+p23hQLZu/Gd/iL6WtvAmOUc0Lq
	wAM/kKki6SDzINKHW8Q==
X-Received: by 2002:a17:902:ccd2:b0:2b0:5682:6973 with SMTP id d9443c01a7336-2b08273d0d4mr101278545ad.19.1774254271399;
        Mon, 23 Mar 2026 01:24:31 -0700 (PDT)
X-Received: by 2002:a17:902:ccd2:b0:2b0:5682:6973 with SMTP id d9443c01a7336-2b08273d0d4mr101278345ad.19.1774254270964;
        Mon, 23 Mar 2026 01:24:30 -0700 (PDT)
Received: from redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b08365a62bsm136181655ad.46.2026.03.23.01.24.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2026 01:24:30 -0700 (PDT)
Date: Mon, 23 Mar 2026 16:24:28 +0800
From: Li Wang <liwang@redhat.com>
To: Waiman Long <longman@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Tejun Heo <tj@kernel.org>,
	Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>,
	Shuah Khan <shuah@kernel.org>, Mike Rapoport <rppt@kernel.org>,
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
	Sean Christopherson <seanjc@google.com>,
	James Houghton <jthoughton@google.com>,
	Sebastian Chlad <sebastianchlad@gmail.com>,
	Guopeng Zhang <zhangguopeng@kylinos.cn>, Li Wang <liwan@redhat.com>
Subject: Re: [PATCH v2 5/7] selftests: memcg: Reduce the expected swap.peak
 with larger page size
Message-ID: <acD4vGZKveXJ4GuW@redhat.com>
References: <20260320204241.1613861-1-longman@redhat.com>
 <20260320204241.1613861-6-longman@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20260320204241.1613861-6-longman@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: pYPeNTWEF90pDiA9Na7X0rXwQjiON6-wUmmLygm9jQ4_1774254271
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: 46CD3140012
X-Rspamd-Server: rspam07
X-Stat-Signature: b88n3fxiymo6pnihuzh9twa656i91hdw
X-Rspam-User: 
X-HE-Tag: 1774254274-702037
X-HE-Meta: U2FsdGVkX19Z6uURMtyJzoBMlrYV6vI4gAVcWsAywnw67qEGHWbfnllow+9QG3XR87u1nAZu5ElL2j5h4rmJ9PUvW89bYvIWVZTWHAjysNgp0NsYpVl5mrx/OS61aNHNkejkyN+7ZXf6X1qmLgvuzOW6yhtYPkKPLy+RSFfKvjkHg+KhB1416Z4gezUcTJbsJokAJZAJ4mMDIB78vhtVh7snOM59X5YI2ijctaZ2Uu1EeVVoBWf1I1jreguA2frdYAn7SrHYAlky/E2sPxqMb0QA8SZNDhYD6MNDY+dxKU2Lbgs479N0XERPTJz4AHVFzdfkX1Pn4AqqqXlY7cT8C2NiB4dDLfv78o4vuUMU/b5k9DVRxldq65Lysm9qzepTc9qMurgKn//js9kn5jp1x/A2odOUrtT1iLeE1EyAK0rmZg4EEupJi1ajXvfbi5IUMOaNaneV7dCuKmjwKkdPyKxaxK7JTLFLJMYXeNqdKFW975f0rP6MMeBu1xkgnDxWs/tW8La9cF0Ikxq+TMCN1uFajFsldyXZzTgQVCG5sV2nePBxsuE8aTwD3uAxFtDRnrKJB4d/h+XLyDgMxQarzla6Mqt1PHABivupCX8LyVKj6yERxsaMQE2fywOQ4b1KSq4fwTd0wdp2AXZvR5z3UCtxXu3vvCPU9fSArwJ9BNNs3hGRxVs2KXyDzeaGoGkaIjZBZdUZiirkREOo6OkYp3uFmbHI0gyr749VAqBLAUc2jY4280XDK/2XMExWDiW36COqRI8YwlnipACzri1B7diPKcrK9Ps2lG59bYmh/fti3uuLZfg+o5FMGtAeXE45QJ4BkuwciPaIzg2wWf3b9flHte2VHyXtRg8chXeL+BIpVE3AQhKrzD+Oj7H5kO4xqNHyNVItfpIH00DNsLBVf87brC4tOWyG7pFUPxsudi5PKqX3CkyGC3vG087Ai/gANUqs6M5rMKfWYg03oeX
 juD4B7lz
 QAgZW+zTDOedh4NkYiHP9bYyZ85hn1ih9mKN9LWCHlUsE2g9boAZgf95OIb3eG3MmRyPVVI4Hx4kSnxEmgsBRpurfSgfrTImDxG/AetvQ9czbyKz81IvcnrMRNhmKkNtvlVNo6PiVJBGBemPfpQ0HRxWMdEVV7xpV2Zq9rQxgf6NS0Ax0YOvqhj/giMjYzhJ/nzpac36HqhOVJ871zt3xvahhbhKbfLFaxKtlCu8LMBUNkIZ5dIM/SxUs2sr74tuOg5XkzJdOPDN/BKLYXCDMNCIC9rWyZLlYTvdpfM5CJhgCZ+RhPs5ECLD6xzWlXFu7oNhV3R4CWX9LVTxXwpOITzT6t0VyG1fYV9tJyrHQUD6Yc5iNdm7Bw90heSid4F27z0nvjH+CtjgMQjcvoD6bzcMG5/Kwuj+uqwhxGAPAsmEyLhTNO89bCYwp+IO3KLRQdjNEmTXpPV/AaL0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 20, 2026 at 04:42:39PM -0400, Waiman Long wrote:
> When running the test_memcg_swap_max_peak test which sets swap.max
> to 30M on an arm64 system with 64k page size, the test failed as the
> swap.peak could only reach up only to 27,328,512 bytes (about 25.45
> MB which is lower than the expected 29M) before the allocating task
> got oom-killed.
> 
> It is likely due to the fact that it takes longer to write out a larger
> page to swap and hence a lower swap.peak is being reached. Setting
> memory.high to 29M to throttle memory allocation when nearing memory.max
> helps, but it still could only reach up to 29,032,448 bytes (about
> 27.04M). As a result, we have to reduce the expected swap.peak with
> larger page size. Now swap.peak is expected to reach only 27M with 64k
> page, 29M with 4k page and 28M with 16k page.
> 
> Signed-off-by: Waiman Long <longman@redhat.com>
> ---
>  .../selftests/cgroup/test_memcontrol.c        | 26 ++++++++++++++++---
>  1 file changed, 22 insertions(+), 4 deletions(-)
> 
> diff --git a/tools/testing/selftests/cgroup/test_memcontrol.c b/tools/testing/selftests/cgroup/test_memcontrol.c
> index c078fc458def..3832ded1e47b 100644
> --- a/tools/testing/selftests/cgroup/test_memcontrol.c
> +++ b/tools/testing/selftests/cgroup/test_memcontrol.c
> @@ -1032,6 +1032,7 @@ static int test_memcg_swap_max_peak(const char *root)
>  	char *memcg;
>  	long max, peak;
>  	struct stat ss;
> +	long swap_peak;
>  	int swap_peak_fd = -1, mem_peak_fd = -1;
>  
>  	/* any non-empty string resets */
> @@ -1119,6 +1120,23 @@ static int test_memcg_swap_max_peak(const char *root)
>  	if (cg_write(memcg, "memory.max", "30M"))
>  		goto cleanup;
>  
> +	/*
> +	 * The swap.peak that can be reached will depend on the system page
> +	 * size. With larger page size (e.g. 64k), it takes more time to write
> +	 * the anonymous memory page to swap and so the peak reached will be
> +	 * lower before the memory allocation process get oom-killed. One way
> +	 * to allow the swap.peak to go higher is to throttle memory allocation
> +	 * by setting memory.high to, say, 29M to give more time to swap out the
> +	 * memory before oom-kill. This is still not enough for it to reach
> +	 * 29M reachable with 4k page. So we still need to reduce the expected
> +	 * swap.peak accordingly.
> +	 */
> +	swap_peak = (page_size == KB(4)) ? MB(29) :
> +		   ((page_size <= KB(16)) ? MB(28) : MB(27));

Or, go with a dynamic adjustment based on page size?

    swap_peak = MB(29) - ilog2(page_size / KB(4)) * MB(1);

-- 
Regards,
Li Wang


