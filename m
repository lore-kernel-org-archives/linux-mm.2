Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9DAAECCA470
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 03:04:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F38B88E0060; Wed,  8 Oct 2025 23:04:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE8DE8E0002; Wed,  8 Oct 2025 23:04:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD7DF8E0060; Wed,  8 Oct 2025 23:04:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CAA0F8E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 23:04:11 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7122C4639D
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 03:04:11 +0000 (UTC)
X-FDA: 83977081902.23.9F16659
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	by imf14.hostedemail.com (Postfix) with ESMTP id B3AB2100002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 03:04:09 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Bx8vpW1o;
	spf=pass (imf14.hostedemail.com: domain of chengming.zhou@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=chengming.zhou@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759979049;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nc0BA2368cULBNmhkzmu+0aM1upoZ74WV8ag6VwaBtA=;
	b=Ys3+zHqWfxnOGxznQEbwpKRIdI5pqOASqaHh4HoC9HO0v+Z/auR3lfZj837RSMgcqqcblS
	YyG0ORwiG7HW+GSMH4NtYj4pWeNpXQb/L0SYgLEPzBn65890/QMh6oEYy+5cj1XehQzfz/
	athfOh3o/r+8sM2M5wbBqIOglE9UTbs=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Bx8vpW1o;
	spf=pass (imf14.hostedemail.com: domain of chengming.zhou@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=chengming.zhou@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759979049; a=rsa-sha256;
	cv=none;
	b=NxNy748WSrjrzpLXd9mCL0pmkP4xXHI8o1aGDqeic+ybFuloPn0LJosQhcvNe4bHfLQ3Xb
	TeXV3WhWnKxeKttnJZppkLQ189dps/1JCGjhZOGrGJqM6VMEzSoTzyiMjjTRk+h/MKVfau
	c5zoATIGMRfKzmNzBvTRd2/4JVXvtyo=
Message-ID: <612e4576-437f-4c63-b56a-fa2ad62779b9@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1759979048;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nc0BA2368cULBNmhkzmu+0aM1upoZ74WV8ag6VwaBtA=;
	b=Bx8vpW1oUFLWj43pRUUUQ3p9yQWAM9Mc5ScpXQ9Ot2Ldetq+STH3gt0F6xAKeixN2Ofllf
	fhwoKwYK1XCEhRqnEA53npfuPDmTUgjlYoykw9p4X5FpziER+YUHMod/7SPcdT303S7fmr
	fxTGJEFylUvKfpGONQLLa+rw/PBwpsE=
Date: Thu, 9 Oct 2025 11:03:56 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 4/4] Docs/admin-guide/mm/zswap: s/red-black tree/xarray/
To: SeongJae Park <sj@kernel.org>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Jonathan Corbet <corbet@lwn.net>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Michal Hocko
 <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
 Nhat Pham <nphamcs@gmail.com>, Suren Baghdasaryan <surenb@google.com>,
 Vlastimil Babka <vbabka@suse.cz>, Yosry Ahmed <yosry.ahmed@linux.dev>,
 kernel-team@meta.com, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20251003203851.43128-1-sj@kernel.org>
 <20251003203851.43128-5-sj@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Chengming Zhou <chengming.zhou@linux.dev>
In-Reply-To: <20251003203851.43128-5-sj@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B3AB2100002
X-Stat-Signature: xsqgbfsztimqut4wkd797jgrdihmigtj
X-Rspam-User: 
X-HE-Tag: 1759979049-35443
X-HE-Meta: U2FsdGVkX1/y3ML+h+9yGHnpiOs2qICpnEES8BS4DJOZUsxukqgbLpf++53HoTurWtx51FSWUVnhIgdVyYdyjGxlotGv/BCwPtoOkL4c/+fY0DD+PE5RrfqAe1FDFqUCSQXb6G1wfNDFLQPlhj3GyibQkv0TEJJfTofo8eo7+tksRHcixYiJJuh7J7GHdnf9CU36dokws6JTDW+QGDR9E+xdY46YsZXx7P5r9he689qf65kLrR0jF0TsQSGaUdrD4xHEhqS3Z6+3XvMuTEmlQXLNC2QYKp+AL6KmUH8Q/4Ofh5fMWL5b2lPcqbSvJST982P4Izv7VwNxm7DlFsQgeKScprwlpRzSIQcx5wsWK4Jg0selMuaVIyDxAky/7Re34TWJIJDLDTWbYuV4zoBLav20H3lpg77cQlzVxC97nD6E08cga8E2+PNRiLwFC70EIMmh5OXD2sXoVkwG4Pn4rnbxvdt0Mr69sS8/e0kjk6U4PvU22gpDBu7JoApWaRWv/oKJVYSWjl1WWfqp0ZyRyWEl7a4+tRObxj1i1bozsLmOxu3aCW8AsrZJ0bbL/QLOvG70Xr+fwXgKCuJmAN6DDGrTEljvfpa+Y2/mdl3gnbFbYxNRI6olxJ7RqncX++nP3JsgziTJHKkzczHgOd3HK10+VbGteVSOFg8EGDeWrPf7z4iQu2tdVdS/N3x9Hzwmocms86Pqn69JTN5GBSmzdzemJYHztf/OrkgZcIo/xgFyz2Q1U6SeYOk2vNIYCng56+jiaCunbz/zrdka14ZmLKfm5f/l2PuOYyvqAuH+Hkdcd5mQvlwKEHnz5KBsd+uPXm4bEka5RAPvYcNE/3GnUmppVnnRAFvi12A2vm43ArAkovf2/0noNCB0qTQE20oYm9UrjpcNbkJr4XUZnqmO+uuG5BKBLYsx9Za8gq4l3NXnux8mI9uVjVaiaBpkOeI0eAKNoYaH5IlGoS63DS5
 PRvgB0WG
 8b5cvvfpvaGFEJQoFcc2cgKWC3cJ1czYRsIvPHrtk2EnUsclICnMBINbk+g0dbHs/Zy4iwrDDq7YndEEAOWlbb+7njN/WspeLoSJiAJB8UFnTt4ttH/OI2adeqd3blgrFcRcLVsisiaYtJIJdWQzEOqH+lpqq/jb5met+60QLKxjZOaQ2j1S3D9JRfU1iOLj7Q9Od+u0IgouV8ZENecIN68IHda6grwKdaBOL2Gg0Gai5YII=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025/10/4 04:38, SeongJae Park wrote:
> The change from commit 796c2c23e14e ("zswap: replace RB tree with
> xarray") is not reflected on the document.  Update the document.
> 
> Signed-off-by: SeongJae Park <sj@kernel.org>

Reviewed-by: Chengming Zhou <chengming.zhou@linux.dev>

> ---
>   Documentation/admin-guide/mm/zswap.rst | 10 +++++-----
>   1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/Documentation/admin-guide/mm/zswap.rst b/Documentation/admin-guide/mm/zswap.rst
> index 283d77217c6f..2464425c783d 100644
> --- a/Documentation/admin-guide/mm/zswap.rst
> +++ b/Documentation/admin-guide/mm/zswap.rst
> @@ -59,11 +59,11 @@ returned by the allocation routine and that handle must be mapped before being
>   accessed.  The compressed memory pool grows on demand and shrinks as compressed
>   pages are freed.  The pool is not preallocated.
>   
> -When a swap page is passed from swapout to zswap, zswap maintains a mapping
> -of the swap entry, a combination of the swap type and swap offset, to the
> -zsmalloc handle that references that compressed swap page.  This mapping is
> -achieved with a red-black tree per swap type.  The swap offset is the search
> -key for the tree nodes.
> +When a swap page is passed from swapout to zswap, zswap maintains a mapping of
> +the swap entry, a combination of the swap type and swap offset, to the zsmalloc
> +handle that references that compressed swap page.  This mapping is achieved
> +with an xarray per swap type.  The swap offset is the search key for the xarray
> +nodes.
>   
>   During a page fault on a PTE that is a swap entry, the swapin code calls the
>   zswap load function to decompress the page into the page allocated by the page

