Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8E1BC5DF9B
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 12:38:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 02A506B00A7; Mon, 24 Aug 2026 08:38:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF6826B00A9; Mon, 24 Aug 2026 08:38:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE4646B00AA; Mon, 24 Aug 2026 08:38:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C40C36B00A7
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 08:38:11 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6E056A10E4
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 12:38:11 +0000 (UTC)
X-FDA: 85136115582.04.FD13D90
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 9B9EC1C0007
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 12:38:09 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="dVwXi/Me";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787575089;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X8d4MJxLvYDEQndMVgXp8CoVUrqM1yJn/BvKkNr5Xyk=;
	b=t+XfLCwHFgwdIvN1AtDUmZbLePa1R1Nsky/xpHifS5MToHb/jhnbgMiZjykjQoSR+fZ4Tv
	bBPFpaaZWcPHczWfL4cPU5juAkO1i8gWNJ4rspnkAwULIocCqjpflXhiKM4P4R39J0bfOx
	NICpTwblsd9b1TYtaeW4bN3mWg7Dd4U=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="dVwXi/Me";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787575089;
	b=KTOxUAttsMY5bT/IzooFdvf02RXhRG2qCo0Scbwah+LLzBPbgT6anRMLwQ+avrCAVn6u/c
	lMUg5Pfvf4ls04ENybqke4IO6le8KSK8YvXR4rT/VLtJ5IFU+0gKSJtqQw5XK6eGkfZ5Yx
	W5A+YOmK6nxu+2qQmsoEaEgt8ZSIUHc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D1D82416C2;
	Mon, 24 Aug 2026 12:38:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F32211F000E9;
	Mon, 24 Aug 2026 12:38:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787575088;
	bh=X8d4MJxLvYDEQndMVgXp8CoVUrqM1yJn/BvKkNr5Xyk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=dVwXi/Me8zOrF7K3foN9mE65PVGdyQ1Lgr+8+32xwxvaha8cJxPNCTjMIAAZVfiLX
	 YHEfnbeJFbD1uweJ9gNTWd2Ub/xUVxHCZuhGL8g6Qn8VbciQTypFRtOAphKnW8SuyB
	 cgso8N2hRX5yX50Dd1DWSEYiA78momtYHGD2bk1Bm6QqSA+e3KWFCS1bEG60MnPEvM
	 1FHqBRJQI4kiGunR80bgtwQkDvhglBBdywKWm84i0fl3xRGVtUyU4FvHCXnRG2V0pj
	 V4YX+qOKTpOmXHHzgjFihMprEAZIcuKWnEahhTA9cS8FE/ugJ60htTnqOkh3NAfjGF
	 JY81Lwn7Hd5Kw==
Message-ID: <c635db29-9067-4783-b706-92e81ba8ce88@kernel.org>
Date: Mon, 24 Aug 2026 14:37:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 5/6] tools/mm: make gup_bench a benchmark only tool
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
 <20260813181230.483746-6-sarthak.sharma@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260813181230.483746-6-sarthak.sharma@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 9B9EC1C0007
X-Rspamd-Server: rspam07
X-Stat-Signature: izjwp1stxf5bnoa9nwbd4fusyc6duytt
X-HE-Tag: 1787575089-761056
X-HE-Meta: U2FsdGVkX19NCitqdK1wsC0hfvG0PZP6SgExGb39zLne6KmNHt4wDJQPw9XwFPO3Ci7XuCtdEcrCEfvHyJEFRCpVoLchqnDCWx7P3RZ3IYWB7Yx82MxVkMwajGi2eSS7Spxqe+rBCqt4ex5zaxphPPJrIkjOSMGs0jw7d99KIvNx22YpswakVi2diSadC8jQqyQ1EcuUJakvaQ5UOvumgaLRwD6sDyfqMHPza/dbjWjcH9SEwGqTXw+EGEKi7tw/U3TjMBPuSHxUcZVkwpoKirUH5hpDN/HmDtTicSS0gJKlriC+U+oZm3REzLz1kAQxuKvanbBclcSN1OizHTfqT/AebOeDswRE78kexr/trUpDNSpgC1El5/ykdbjv4olTz6+lpgNVbDrrUryuhhOlCPsGHA8EmDCjpDeWy/taa/KTV8NzZ3lncWBZasoD19iC4VEZz+Q5KBjOwmCoN6rcVvNYe3ry76N5Uvw5xYT/gVNmvkIulKocWH+wMnPypyd7jgNtoMLvTAjJG41ZgE15SHBTzGwIQk6jmhL7lTGYTSBSgHuID/yyCCssNM7D3Y0YrpUMhwHVX3fZ2YUav6WVgsieGjvMCgMC+JgUOxeG/BQ2+xoOQ2um2HFL8nfKoOBEahyGJUIZ1MKOqpc6ncAPQk32L5CHHbHhH2KgJ0I5R83gzjeSkWJJWckXZoKkbAxhhUolwocD6sqoY0XReSSUMKtHxz+eQ78MJRE3JgC5BFIxV1KK0h8al6PvvG2ge5mGBfB/GtkVzrFC8BPrcWUbb+eMWBaKVSvTInqx3v5qFVH9ewzwukcbAL/PxDA9bh2/35H4ZIN0aBlxX2uDkLmoqwjsxE6hx5ZFL1F54dy8veotDwJiKMUex4IbskclSQKt3Yim5jvK9VssQbka+uPfN0wcFOgJ3fZfafAV6VRcI/KUPqiEYNyy1IfIWek8e+F5t4JjXyNrzmynn20F6Uh
 B49w/kRB
 w5yB7O1wumbDpAkMTv06l2pA6jOXDRxo974wp0tqMn9Dlfo4acBFX1vMrLhSBEXF/l7E6bfkrlRlgruXvL5EwzFMXTP0+KZ3BIsNu+XURxhvk8bkY3GPa/Cq3vgx/DDqoMMKUyIX2xgS7yFIieCqtUjjqebj5aN2vySn5aoC4wP6fzw2pS76/4lN/5P+RWmsssPNTFejBvS5wK7K60KoWY59kYgwZAKbcu6JrnsD4tl/tsm6pHL+GbfEVXZmj0QVYfH4vfRoQV4jTZKU4bZ1FtwKtQrr7iqOfuTeDSYrS6eSUlGat6p/n9Nhi10q+utJnDhd4qaKO9MJF0mjDg7MHFzTKvigGI4MLeen2EZBx2v0ZzobM5iE6KGs8UNj83TGz31NcsEHGFdVvc44=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/13/26 20:12, Sarthak Sharma wrote:
> Remove the functional modes (GUP_BASIC_TEST, PIN_BASIC_TEST and
> DUMP_USER_PAGES_TEST) from gup_bench. Drop the kselftest dependency
> and use normal diagnostics and exit statuses.
> 
> When no arguments are supplied, run a single GUP_FAST_BENCHMARK
> with the existing default values. Let users select other
> configurations through command-line options. Report ioctl failures
> and handle errors without relying on assert().
> 
> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>
> ---


[...]

>  	free(tid);
>  
> -	ksft_exit_pass();
> +	if (thread_error)
> +		goto err_unmap;
> +
> +	munmap((void *)gup.addr, size);
> +	close(gup_fd);
> +	close(filed);
> +	return 0;
> +
> +err_unmap:
> +	munmap((void *)gup.addr, size);
> +err_close_gup_fd:
> +	close(gup_fd);
> +err_close_filed:
> +	close(filed);
> +	return 1;
>  }

Why not have a "int ret = 1;" and just befor ethe err_unmap, do ret = 0;

That way you avoid the duplicate exit code.


Apart from that

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

