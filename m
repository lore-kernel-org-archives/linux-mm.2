Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08E05ED7B9B
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 10:29:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B8396B0088; Tue, 14 Apr 2026 06:29:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 368D46B008A; Tue, 14 Apr 2026 06:29:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 208F56B0092; Tue, 14 Apr 2026 06:29:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0763F6B0088
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 06:29:20 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8FF871B814E
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 10:29:19 +0000 (UTC)
X-FDA: 84656789238.08.3ED82DC
Received: from relay.hostedemail.com (unirelay02 [10.200.18.65])
	by imf21.hostedemail.com (Postfix) with ESMTP id 63A7C1C0010
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 10:29:17 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776162557;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iZKGf2Vk84wHJMdeu15DvO/VdQpzcoSMjrS9n5YIJy0=;
	b=vdLf9bu3NnCJK07tIQItuo6XLjlJaeHUm7inc+yi1beZnRZAT6WSPnz6t4lrYa4Qzc9SrZ
	nvu1jXDWVOFmiDVOd4xygBKmpdif5oKUvX/oZt0EGSdQUvA5bduVm55RlhTbqN7rCsCmLH
	dAd1cbZ68Fm1bZFWquRxADjSMEESJlg=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776162557; a=rsa-sha256;
	cv=pass;
	b=kCP7NvJAtqUbucjNbn6h9F2cgyk7OyNhWQiXc9P+cXnYW/3aHa31kHol6DDkjDleD4MXmP
	RdQBahqQVThKUta4J5D8nE5kBtdXow81FzKFFrno05YLSSqcGslmlrv15DWlV8bqIovvTc
	0iazfNz+Yz/dx8nnJTlz0k9mTegr0Fs=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=1")
Received: from relay.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D0ACF13B01E
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 10:29:16 +0000 (UTC)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8F9CF1B814E
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 10:29:16 +0000 (UTC)
X-FDA: 84656789112.16.D0660BD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id C7A7314000D
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 10:29:14 +0000 (UTC)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776162554; a=rsa-sha256;
	cv=none;
	b=V/jNPu5lT0qqaT9dk8/pxT6mgnLvPI1IdfRMRLKlbNM7wA7pU4BMd13bcUKB/Sp/uIUQJC
	q7ZoXBGuKu9TjUl3t75OFVtMS5CTxt2y+L6w+T1kOcFoE4L1fBNNYKZ0oqWlI5CXyJs0XM
	vJiA7hBSkTdUsboKqqOyDatah1XWrDo=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=f6jFSrqG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776162554;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iZKGf2Vk84wHJMdeu15DvO/VdQpzcoSMjrS9n5YIJy0=;
	b=lR+oShNT01stThqrq/v994i3nyKWkRmBCcV4T+bex8GGfUzqIwQe+tM0STLjJmu1zi8dTC
	JP9OYEhDBJ/ZVHoQy5i4yDhC5PgK+5DGMAbH+aFL994Dc3/MVOrU/bu4hiwNgW6Kh8dLAO
	nYMwjgjt0IAZlpyDm38MM75GUYNwoI4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1A93D6011F;
	Tue, 14 Apr 2026 10:29:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30B1FC19425;
	Tue, 14 Apr 2026 10:29:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776162553;
	bh=ZYDtelKL2OfCjSVMUx4BbWxlEg7+fhljEXXNDfDrb5s=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=f6jFSrqGOuBTx2iHRnPdmBu93L1+G+u/OYlnmbru3CB5V+3U6W0umqj+sD8W86ONa
	 c6xsH/dLKqC9ClNYd5vy9Ek2GSYBfZt03tHsrLWI19ljw7vv1nXiBDYGLsN/gId+YQ
	 KvVcwvS9AB1ibwN1ejk+4okvwGNzCZkCf1OdupZSFPIXD2CtVTH6NG0eOKmEzYD0yw
	 XAo5n8mPtgJT444/2EVF4RvZu0m0yTMOnUr00OgjCg3AoYYV2jajuNcD0isplvS7LE
	 kq5GwtkxQjFQ47GL4gJcfcVXyEXkL/+EUVjBaIIas+88NqurYLXExL2fvtcGtOU6ej
	 vlXxvTFECKcEQ==
Message-ID: <a2632ace-1ffd-4e9c-8fcb-803b9835d8d4@kernel.org>
Date: Tue, 14 Apr 2026 12:29:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.2 v2 01/12] mm/khugepaged: remove READ_ONLY_THP_FOR_FS
 check
To: Zi Yan <ziy@nvidia.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Song Liu <songliubraving@fb.com>
Cc: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
References: <20260413192030.3275825-1-ziy@nvidia.com>
 <20260413192030.3275825-2-ziy@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260413192030.3275825-2-ziy@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-HE-Meta: U2FsdGVkX18WmHu//kGFtTBnOiu2AdLTkVMdj7LUZMtnk7LON3Lh8Zgote59CgOOnaKzdujJLdqTiwt1iQpg2ootfYlycy/1SYq7HiC/gsDdNAksQP64L3BW5btPE+SFcYuKiSQzQ1DtLVF8XbrW1waYuwwBHkHKBxW/7FEqbloe5OZ7aOG4Ot71eEmnYiqVGPd1TuWGgfOqgc2OJJ5o+fg/Gg+eiSJa2H9a/0WiM9yqlXGIJFuFx7AeRqIgF8V2NX18xVktwTNxFRph7bUhtI6XmuybAZBbeqNglKd+puwvnWV0IpJR1haU3maacuCTRI16JEKOoPLz8MOQJMGbxZsBFimmQtkESRx+YIWv7FvDeZG317KnuFZLzcNGu7tYvKGreix8S9Gv1JbvNys29dPMgzR5d6sMklRF2t0JAIkdIunGajv9g8VjDvzqcs6C8sJzgwl6i92XZ34Tv08oAMnk86VdoijDAyK+V8rkoNvljmdd8O3ZgGTzFKRY7Z1pi6baiHYfK70+KMS37KGKT0ZH2J/+ZjAFkUsFS/Jho3vChhEh1uZ3VxzPnI+/WpNl1geDcnOm21SSR1Y8d5YlYPT8oJ4FQ0/mInX0k66CX8K0pg54MV/b7dDoiD2s6JDEMbsTelfFipKKBKoic3nHernFXKEDNYUo5m558bBaEXQwuZsRx2NmwhVME5p7qn4Lgxs29fjqf9uvIXe+SL7uU72JiTGp/2/5zs9g1NlR6f03t0wNHzLkVgtZry4Wqzusq3p312y/+wHkl4/fxjQFGK3BfObNpRH2WMeaIAuO/b6btxzWrWHZCAO/2D57cYT248/fF7qmM+xY6sgE1iQRAjEM0HB6/2VM7PpotZdJtPzMbKKmMPeGZlNteG3CG0g2KaRqqezuL23DApak8dgsJhMdEpwyovfa9kKy4EZhfwEMTwwocKTSj3V6Q77O/IMaqUt2FLRApBZHgOjrR70
 ewAGZFaB
 W2nEwNpQDYrsTRzhM1Qo4Rm41MoZBMbCsFTRsu9iPnmKxjRt8gEdgMDbOqsZsLJzJMOz1EX5LM/ZVphi42IlZHiv52EevWdfMWH/zq4C6FUxP7t6Nnk1q0Iawf6BBhtu/CLmSPIz60EnrRyBpQQ5Lg9bnHT4u1XTFXU65fp+F9mwGUASfqDIbROOR2vbyBjBl+MnNLyPgprAhiY2TfVTfamwdn9boJy2wCrZ4GauhzM8vag3KFUYNk35YZ7ymC9faYQaKgtl+y8q1RfErEzjDxMw3KhbhHR4BJCm9saCTVp51FaaCZsF+LzS21VBsLj++3AbK5a5Fljrlgyc=
X-Rspamd-Queue-Id: 63A7C1C0010
X-Stat-Signature: fwiz8p7q74cgfquqmfcaa56yk7dpofyg
X-Rspam-User: 
X-HE-Tag-Orig: 1776162554-666133
X-Rspamd-Server: rspam10
X-HE-Tag: 1776162557-568094
X-HE-Meta: U2FsdGVkX196MBJDVQYJbhOS+bbdpznHTsMW+QXPqHErjTWPHFpYHOD6HAF6q2NcqHyEqVtHdbw5ZvuqtKhvsgDu8fR+cEQJXZPYPNZLwiXw1IkbtEBAiswYk6nEkceBfjIHkk0cBG0GwQHs4gzrtyKLSlaAfOWpDOQz/M4q7u+rw8g4arkaQsGFb/4C5KcwGbOFq6f4pw2a6zaeQN4ryHRF4WF7noUJCB5ZVUE7DKQ7pvolwYzahrdpFhN+QpdzgzniyyuZis30jpgC0MYu1J3PQNoY9nWghnr7U4S/+i3TtV4AnGUrUhVyIPS7aALW+nYA2k+hZGXXaNmL1BDo7GJhzgm4/HctW3Yt+XmAjx+h08+AVmbGioUC6X8LZSOl0Has5ltpCeH1IsXqQCna7cww2Bp4ZkFLL0K8IlknqQc/rCK2ySzV/uvqqSrXQGOTLlygiAmw/e4IrvLR56IBQOr0Vk6Ff+8kvsQI8rJ3reyJ8XVBuWnXNsremjihV+BPJ3KPtz4sQMjgDvhTBnqlpd5doC4s462X3+WRzvAirkwnPcK8OQiAkwBC89JeTp9qsqXN28wHLApO/uwByIBiW5UEJ6i8o484OewLjeZstLjF1TluX/0bbUR9cg0R1mbJHZuA0aScVkrN1NZsp+9eSbJGDdXWjZNKnzHLzr45O4CTiMM+gHDEFtuAFPv2Wlk0rv+swd/TXSTSI/y6Z5yvE+Fs/KTUGLhDTO4251Dl42EzOzD068zkYvGMsAJaN5nTw52wAx826ZYwg0OEYqVx0jLIOlqRus+klbwIYvugg5srLF8BG6h9fvvc30Vxox6+w1+2Q0SmDEuCwHQCJQjcjGwMKAf71adLK+v6/+a8gHDpy6bX3c7DvvTD8DpSauhOfeeNXfe0RI1bgcSGS9feTFlF2iyidXKAG7aUI4ILvFKguK2eOfrORpWzPEqpSWSbxhnNaXgLJAhy9rV7ePd
 Cb0ZQp3V
 ALJkJT17uQ0+kjykKoxGiN4ZtPDtL242gjhjtqh6Gp0y5vW6harQVvQ5Jb4o9ZZmNlWFibEYjh2fj6+3AHg52CmzYYXmhlSjy5iBGSrosN3vbFGAmgohiosbDF7PGGje1nZg4yCdPfav1xVBrOCiCC57QB8vp9lUr4okSNubDdj3+LL/Q/ZWP0oNiUTMSzhzdcvFUUlFXHIS4rFj04F+Cz9tvi3LQUfR+y5F4GP/RqdUAb3VPj4lndSNOVVdGhfvbIjqycVg6DECGL3U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/13/26 21:20, Zi Yan wrote:
> collapse_file() requires FSes supporting large folio with at least
> PMD_ORDER, so replace the READ_ONLY_THP_FOR_FS check with that.
> MADV_COLLAPSE ignores shmem huge config, so exclude the check for shmem.
> 
> While at it, replace VM_BUG_ON with VM_WARN_ON_ONCE.
> 
> In collapse_scan_file(), add FS eligibility check to avoid redundant scans.
> 
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---
>  mm/khugepaged.c | 12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index b8452dbdb043..d2f0acd2dac2 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -1892,8 +1892,9 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
>  	int nr_none = 0;
>  	bool is_shmem = shmem_file(file);
>  
> -	VM_BUG_ON(!IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) && !is_shmem);
> -	VM_BUG_ON(start & (HPAGE_PMD_NR - 1));
> +	/* MADV_COLLAPSE ignores shmem huge config, so do not check shmem */
> +	VM_WARN_ON_ONCE(!is_shmem && mapping_max_folio_order(mapping) < PMD_ORDER);
> +	VM_WARN_ON_ONCE(start & (HPAGE_PMD_NR - 1));
>  
>  	result = alloc_charge_folio(&new_folio, mm, cc);
>  	if (result != SCAN_SUCCEED)
> @@ -2321,6 +2322,13 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm,
>  	int node = NUMA_NO_NODE;
>  	enum scan_result result = SCAN_SUCCEED;
>  
> +	/*
> +	 * skip files without PMD-order folio support
> +	 * do not check shmem, since MADV_COLLAPSE ignores shmem huge config
> +	 */

How is the !collapse path handled? Through thp_vma_allowable_order() in
collapse_scan_mm_slot()?

Wouldn't it be better to have that check exactly there?

-- 
Cheers,

David


