Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1ED88606A320
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 12:18:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XQ7TMYA6
Received: by kanga.kvack.org (Postfix)
	id 3A67E6B00EF; Sat, 21 Nov 2026 07:18:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 356F16B05B0; Sat, 21 Nov 2026 07:18:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 246A66B05B3; Sat, 21 Nov 2026 07:18:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F1D936B00EF
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 07:18:30 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E6755C0471
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 12:18:28 +0000 (UTC)
X-FDA: 85459029096.14.01C6DBD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 2FE7E40006
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 12:18:27 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XQ7TMYA6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795263507;
	b=ZvvM3XsIhhG4ETjfJn8zXwsHIss60CwsFxlYW17Bj+eYH8dWfOheuWqYfdEt2Bb+kOestZ
	MZyEHRrS+RvkW6K43xh3gjFOf6UXyyfAy56l3UqgvvadkGCxNUy6Q5EASUG3HGXeMbcjyf
	A0rpOZE+RB3ZhIlU5YO2qT4W8mR4/pc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795263507;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MXE0yFyM2nPGBUmYcfo1AgqMBNHr7JrwKQ1QcX5JXK4=;
	b=BaTZG4DKFwM94d4uW5FmjmR0R0/W3s6UwS3Bw+IbQGmyWQRFa/Bs82i4MRmK/+bRwcUiSh
	WpcDsIODTBec3FZMwfk6fJFz6EIKV6o2ZgrbOOP8wdBxvyu7K23N/0+XCNufLZrDh037qF
	b3xYMNOXiPZ29u6WWMFgzfxjxkA675U=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XQ7TMYA6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1D34B43A3E;
	Sat, 21 Nov 2026 12:18:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D90C61F000C6;
	Sat, 21 Nov 2026 12:18:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795263506;
	bh=MXE0yFyM2nPGBUmYcfo1AgqMBNHr7JrwKQ1QcX5JXK4=;
	h=Date:Subject:To:References:From:In-Reply-To;
	b=XQ7TMYA6RpfeWUXBIXAPyd3LFzGzxRwqTIuaIaBAFXSEU/hYmLSjyUa7XbgZbCtd3
	 Y3K8wklLzp7hVai4J+S0Cs5U23WAMwmwwpJ6K+ju+tuXckTUkvSDvadsn31G5flcd8
	 6gYaLfTokedz0R2yGS2vy6YYtrU9pY2ayPqtSHQ7vv/yFru7rLWyJ67M+m+aSdZDaE
	 CZDSYESkpQlV2Xc8arqkgTOjZH8UQWtO58Amiy68XWrJal5HDt0fM0+A9nKYeiIAa2
	 pxV24kEsxrFrwQMQccZ6uP8bziy6hw28gPlZh0CcZIbD8nk42ENPB7iLMyy3zndkjv
	 cIxQSrF2lF2iA==
Message-ID: <292d17ff-068e-4848-ab14-90f0a0a0c5b9@kernel.org>
Date: Sat, 21 Nov 2026 13:18:20 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/1] mm/shmem: don't use the memcg of an uncharged
 folio
To: Chris Mason <mason@kernel.org>, hughd@google.com,
 baolin.wang@linux.alibaba.com, akpm@linux-foundation.org,
 qi.zheng@linux.dev, qinyuntan@linux.alibaba.com, shakeel.butt@linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20261120195057.50031-1-mason@kernel.org>
 <20261120195057.50031-2-mason@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261120195057.50031-2-mason@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User:
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 2FE7E40006
X-Stat-Signature: mb4jjyod3hfojmp1zgdz4nzux9zt1g69
X-HE-Tag: 1795263507-407995
X-HE-Meta: U2FsdGVkX1/q++MgyuWWp53ZFpXIcah4V9QKxu19BS3QMhnNbxvJu59lNAeRoI5kpcunyq2ognC5hW4Q+suvxW1b8wR3W+dWJbnvX93zjyqvKA3ahhfLDHbYsUAe7gCjFDAuodMjgHSUF1Wt5KvyprTU9mJcTJAltxpP0vkiIyG8bexJ0vMKu8yiSCvXa1bXxtsnWwnt+ZrRMOLdvHEYRTg+Ru0YFea7+ojxM963ME1eQiHR4M88QQhnpT/2W7rdjBpwiv7l25YqfWBfa7+1pn4LiHLJUH7ONSIeVzfioGsA+95H/TPtDqkBjXE/EZS0RZcgq1HsooDXE+W7mv1StMl7A1bwKPAq/Ucqod/1u/sYzqRD4CAYOLPqH2DZg5Gvg3OsODZgPnqpTIrmcCnPXFUaLcLhUviE4e46+dq5ro8TXxhfMif4Z2Sqj/a+N3SuKtzxCLofh1xauR+8stY7RJJdj4lwMrFKssSbB8geKViNAH/625Ak4SZQPsoWVRQrH1WCCF/eJhvdQxAyE/moQTPVCK9/6YjugK8GSKH9DNuVBpk04JG59EdYpSYVCnYTGMQTlOH30PUq5S/nDe3e2tmKgq7hiMY1D429S4u5xT3p3VlP6DKfI3YgaAdoyDIGoOBdRPJ1NslWXK7Zz0OFgVlAn71LXxLgB2AgIL7BgXSj6C/UVmal9xZczWR2LvFEM8Dx6LHRFKwwGnKWh8ziHhfGJ+y66cDqS+bo7Stz5M5nnlHDcbb4e4c1cg5r87/yMZf9ORk2aWHBSRZAM8MzfUzD3em/MJkSxL6pf9Jg4vM6jA1RBMF3+mxxKdZsDtD8Ym3dfjZ6nR+aO4KIaYMUbNUOSd6ph08yv7H6nzp1M2Tjo6/M32TFaKGUH/gOhgpqeMs0Ooqbfe0nSGo1Kjn90o4UOjn+oICIgtB6ozhWyXzV/h5ZNNTyB+vOAVus8mpCtlvmlSY3rXd+mxSGXVa
 GCVrNd1h
 hQWvTob+422MDSCepJo/uvxGDeV1eXEeNvVl0XEe0Ep33AicYP814utk+LZJnx5NuQzoPuxjyVfRStiU+4yLOLqTIiq5WTc0QfoCYJG84JBB5864d4KqA3DGhQng8QCrQ9Pj3MmzwmyvQ9sb1mIj5KePPZA23QVjRCJaAs9KiNmAGXHoqVbHFVdrrkbyDfSU2fuPjySyioyf7QyTtQrBxftkTsZLrVi4NieB/g7OCP5ohQcj9j1l7n+aaUlbjBFGHLsNUDtj+pppA9H5rBiWz/yJ1njqxIb/DBIMtQOQPR/l8wuW96bVaR+FIuscwZWF/f4eO8jEJDTS73TOvfL0hL/ac3DIzPo8/gXWjGaTH9Taqya5TPOsht05n6HdBTlQl7Zu8/4DO3U2gdWxBT65w1A1+CNyKde4QO0onm7MITb3WGxfLLQv/t8WSmtcsoPIxMxFFCcFCt3Iodve9ID1y/AawlelWWYjK647Jf1v3WeUqIHENb8ukgnhO8LUWioFGnY2p
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/20/26 20:50, Chris Mason wrote:
> The shrinker for unused huge tmpfs folios can dereference a NULL memcg
> if it races with the migration of the folio at the end of a file.
> 
> folio_memcg_list_lru_alloc() assumes that folio_memcg() is never NULL.
> But it is NULL until the folio is charged, and a migration target can be
> in the page cache before charging.
> 
> shmem_unused_huge_shrink() looks the folio up without the folio lock,
> so we can race with migration:
> 
>     __migrate_folio()               shmem_unused_huge_shrink()
>     =================               ==========================
>     __folio_migrate_mapping()
>       xas_store(newfolio)
>                                     filemap_get_entry()
>                                       returns newfolio
>                                     folio_trylock() fails
>                                     shmem_unused_huge_requeue()
>                                       folio_memcg_list_lru_alloc()
>                                         folio_memcg() is NULL
>                                         memcg->kmemcg_id
>     folio_migrate_flags()
>       mem_cgroup_migrate()
>         commit_charge(newfolio)
> 
> Fix it by keeping the original objcg around while the inode is isolated.
> 
> Fixes: 743e7d025d2f ("mm: shmem: make unused huge shrinker memcg aware")
> Suggested-by: Qi Zheng <qi.zheng@linux.dev>
> Signed-off-by: Chris Mason <mason@kernel.org>
> ---

Thanks! I'll wait for more review and will then queue this as a hotfix.

-- 
Cheers,

David

