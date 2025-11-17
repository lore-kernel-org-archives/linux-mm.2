Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 964FBCEACEF
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 14:44:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B6FC28E0016; Mon, 17 Nov 2025 09:44:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B1FD78E0002; Mon, 17 Nov 2025 09:44:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A5D058E0016; Mon, 17 Nov 2025 09:44:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8F1078E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 09:44:55 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4C5F7861A0
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 14:44:55 +0000 (UTC)
X-FDA: 84120370950.29.1A55B2F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 75840A0012
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 14:44:52 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GbuqeJmr;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763390692;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rk7TuCrNrV9lqJul1mKf0WyEz2YcdVVMq5EhIDS+e5g=;
	b=N5SyPyXfCX9eijI7C28a4TphzxDNAbMFJ/X+HgAwfIajG4smffiYA06Vusvvc+kESiQZ/9
	BnaD5Cib4RRL3fd2p7lPY0nKVoGCT6+yF+x+iHwmV8h0Uubhoz/uQmoJn+vNhlyVkmAzNC
	0PpWLVXUPmdc09I7wlYOE85lYKePM1c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763390692; a=rsa-sha256;
	cv=none;
	b=LultTzK5vMlsoGw+7L+PEDFA9lEGEnq8OmCT6EYHZVUoBJjc5kQyVje7R99uatnnfDEYtH
	6ZJMJT5EqerfbiG3XUCYABjp9ImFYtG9neJfprgRnnxZ3yk46bU9jzonxm9ZTo65FeyTeH
	szLyCOHVpMNGD6ObwiOG7WEyf5WarU0=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GbuqeJmr;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 921AE4081A;
	Mon, 17 Nov 2025 14:44:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4BD7C2BC86;
	Mon, 17 Nov 2025 14:44:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763390691;
	bh=CDUtGC8M3JhLCirSaVnhUZ14GDqNgW28PRsDMxMIwN8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=GbuqeJmr+d0qjBmWyK7SfOecXabTSFpyEsvxZVRZ8SgY5E+bxn0dIeEBYKhmxgNUV
	 Khzs5ypJk32Js0UscaSIe7+gH3euRck3254HrKRxw9eHjaYdVPLNFPafHzoVksPp5v
	 N6U4JaeDipclwUWBJkxZcICZN7Edj1zH7RH5YhjjP7KKT19SHXwyl1XEN7bm3RIM+t
	 b5Z/akwW6FwdsYYIU6gX4VI2LshtqxScQfsNeLWouGpM0P/nDUflB4BrUEs51DCyr1
	 KGX/uAUs92bYJvYGooygqEQ5eosSWxOsuuSdgT6Lg8WZ6SHNWN3kVdoLiXsxrXijss
	 7mlxIiUhKsP9A==
Message-ID: <5c1ef450-c9ba-4249-9eda-b38efbd76c3f@kernel.org>
Date: Mon, 17 Nov 2025 15:44:46 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] testing/selftests/mm: add soft-dirty merge self-test
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <cover.1763142412.git.lorenzo.stoakes@oracle.com>
 <0db6aeb73d42876756ba73163cc0cc6e7e8c6100.1763142412.git.lorenzo.stoakes@oracle.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <0db6aeb73d42876756ba73163cc0cc6e7e8c6100.1763142412.git.lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ekn7wgtug7rtrg4tm8xwbxy5aowte4nn
X-Rspam-User: 
X-Rspamd-Queue-Id: 75840A0012
X-Rspamd-Server: rspam01
X-HE-Tag: 1763390692-510800
X-HE-Meta: U2FsdGVkX1+As08SLnhg6tKHGON1RAJwAYYXXl+E+/uYO2ya+6XXxCHOAuvuR7G8d9IyjHe4VVV0J9X7ZuhGhjeleSA0c8HAAcTh+qmLQCFR2BQCLZuGU894zkLaCts4wI+xa99sKw76ZjRslp7/Ft4QIF4oNfXuveA5YfkrvOhPNKz1D8e5UyDIQg8Qhma9u5adu1lHseVcyWU0ewwrCft+XDu+IRu7XCVsddV33d8ysI/ojbCsG4CyLYoxpvcBOFLAhkIJLnNcolXKNiiRQqsbb5qZ15gapMXb6xAlEumdVc271Btc+RZ9hDERfDV9FWOif/GnD9qJ68e4erojyeRO4enP8MjNG+0IAmoQvxRdMFBE6ZGrXPjXS7Vp0CVWkRfDfapRPCYXpiNPghDUnG6rF1qxJkZXoh8X9ha48wln5jRnkMJXp/aVSy8Oo78p+RrNGbrqtd1+LEGhnyokqVo+I0rjawyJ2a+jcxON/FmudXCZAWx2999apr0hbKKss7A0+QHcDQw7xwsW4OqW/6UdHctaYpa6eQC9iT0tCqoB1cIWSwIqx4hI1tdhUwQHKkoupsgicqhDKb6mH2KH/+Dtq6ZGLXZwWZsOFStGwm3f8/KykPduBmnv8KQpcg109grZ1oYQjOcYTKMkZ8v/NgSdwSasYE2DH/a4TJouJPXrnLn7ooMdjwfF+ePDhpG4DSY+9A/pa068OSYzbnsEyZau6OFf6W126tvggcst3uKKx8fzbiWVIVFMMJY0Bv/z/nA5bgu1xYrdRTKLQ8sAQ0U70gZZ3P0pUsSQremwxWLCzQ3+PA+SGTLYCdqlbzOpA+KNLhr5wC3y6BZV7XoVnoVLwmR9SvQw628h9CvFXFOd2gos0zGyACzshEKtUpWbfsSXZyqy1SInkBTY3SK/0p2U/gam4FA43OOX9mZtO76HG6W7hisXwqd1anOiYC2aB0e89lPQp79K1kHoHW+
 zVY7QfNh
 VPzpDacG/Mt9q3arMCnjjBg0j8Sr0FIhMXXfOeKM7Poc+I+pnE8s6FBzOGyEY2KZPjyMsYudzWDEU4xw60CjHq/Acy9F6F5reZCYj7FZZjPfTXPulo9V8riLnqkoP700hdBPOf54uDntxR2YNKIYxtzJZtIvwVrf6/AmwB/2dGVHOFgJnr8qk6poJ/C+YvWTZlhn0YmN1MOoJlxQ+5OQ3PNlo/5/lKrlXHS6rYjvPRbLX0hFWk1gaO/fPmFOG4h/Q1MkSl9XLnrgApwgbw1QnJuvJLg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 14.11.25 18:53, Lorenzo Stoakes wrote:
> Assert that we correctly merge VMAs containing VM_SOFTDIRTY flags now that
> we correctly handle these as sticky.
> 
> In order to do so, we have to account for the fact the pagemap interface
> checks soft dirty PTEs and additionally that newly merged VMAs are marked
> VM_SOFTDIRTY.
> 
> To account for this we use unfaulted anon VMAs, mapping one VMA in and
> clearing soft-dirty, then another separate from the first which will be
> marked soft-dirty which we then mremap() into place.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> ---
>   tools/testing/selftests/mm/soft-dirty.c | 51 ++++++++++++++++++++++++-
>   1 file changed, 50 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/mm/soft-dirty.c b/tools/testing/selftests/mm/soft-dirty.c
> index 4ee4db3750c1..bb29edb1e2a3 100644
> --- a/tools/testing/selftests/mm/soft-dirty.c
> +++ b/tools/testing/selftests/mm/soft-dirty.c
> @@ -184,6 +184,54 @@ static void test_mprotect(int pagemap_fd, int pagesize, bool anon)
>   		close(test_fd);
>   }
>   
> +static void test_merge(int pagemap_fd, int pagesize)
> +{
> +	char *reserved, *map, *map2;
> +
> +	/* Reserve space. */

It took me a while to figure out why you are using 4 pages. I guess you 
want to make sure that we don't end up merging to the left (or the 
right). A diagram would have helped me.

> +	reserved = mmap(NULL, 4 * pagesize, PROT_NONE,
> +			MAP_ANON | MAP_PRIVATE, -1, 0);
> +	if (reserved == MAP_FAILED)
> +		ksft_exit_fail_msg("mmap failed\n");
> +	munmap(reserved, 4 * pagesize);
> +
> +	/* Map a page. */

Note that we are not actually "mapping a page". "Create a new page-sized 
VMA" or sth like that.

> +	map = mmap(&reserved[pagesize], pagesize, PROT_READ | PROT_WRITE,
> +		   MAP_ANON | MAP_PRIVATE | MAP_FIXED, -1, 0);
> +	if (map == MAP_FAILED)
> +		ksft_exit_fail_msg("mmap failed\n");
> +
> +	/* This will clear VM_SOFTDIRTY too. */
> +	clear_softdirty();
> +
> +	/*
> +	 * Now place a new mapping which will be marked VM_SOFTDIRTY. Away from
> +	 * map.

Could we have something "to the right" of this new VMA that we might be 
merging with (that might interfere?) and if so, do we care?

Just wondering if we would actually want a reserved area that spans 5 
page sizes to rule out these cases.

mmap1

[ empty ][ VMA1  ][ empty                   ]

mmap2

[ empty ][ VMA1  ][ empty ][ VMA2  ][ empty ]

mremap

[ empty ][ VMA1  ][ VMA2  ][ empty          ]

which is after the merge

[ empty ][ VMA (SD)       ][                ]


-- 
Cheers

David

