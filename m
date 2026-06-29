Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E56AAC43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 18:22:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D1F776B0093; Mon, 29 Jun 2026 14:22:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CCF9B6B0096; Mon, 29 Jun 2026 14:22:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE6666B0098; Mon, 29 Jun 2026 14:22:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 853C56B0093
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 14:22:52 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0A0468CB1D
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 18:22:52 +0000 (UTC)
X-FDA: 84933771384.07.C10181B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 08AF8140007
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 18:22:49 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Gy069FRp;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782757370;
	b=V+W4HMRx4tktF7pVR+eWd3Rf7jjcvFeqcT9XW1xVHWJ2uB9ayiglHXrRm0Y9UOJVBa+iII
	NKaV3QVZaj0Wkv196sGtInvEv5Nz+/2anzBoydwRae+8Y1Ffn6eVXJMWBbkLwdGr41J/fD
	na7wjnI4zptAo2mqastpRtUqOAt3T7o=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782757370;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lid0FUNtB8nz8P0m7H80tq06ULN31mZTI/xvhz6bRbM=;
	b=boduQH2egnPXKK62VCkQalX/acSR8nhuxzTcQvdczS4lO/lfR1WWWvaRtIr/4f8LxGXmKv
	hDeV3t+vsAcsSAX+t6eBwK2u2d6+RogJ17FR5m/hWHM4ONbSG3HppKyIxdcaOPL8LrD3P6
	vGUEXymXWBpk6KSPDHzxidUyDz3PbZ8=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Gy069FRp;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 12096438F7;
	Mon, 29 Jun 2026 18:22:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C3241F000E9;
	Mon, 29 Jun 2026 18:22:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782757369;
	bh=lid0FUNtB8nz8P0m7H80tq06ULN31mZTI/xvhz6bRbM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Gy069FRpnFzo2hmeubyzmP7MHdfH4sX5PZFy6BYLfWOa9u0pv9xrDehTTTcIgrfX/
	 KdPTFgPz0ljAcIveGLu/JxoUTLID5hWRKlVQTUYYOUnYPHdxfIXgy+j1yC1Nc8L7Wl
	 MRBX71+N6M2135knVeT/8p3Z3o/2upSSC+JnXqWci9ZTn9XOB4ewA0LWXLbM1gPfix
	 ZmLIOJNbhSwYvnLdp3iGkjNO68u0B7XGTMowu8XLYFk1dSrhCH069GOUy2kMywt1vG
	 6VwtaGft0hztYLWSBC+q9o0cqIxroN/sBRtpdlEwyj6J/S/nVVwqwgxArDcMpE9c65
	 Qaz9ATY0dh72w==
Message-ID: <e0b696c1-ee1d-407e-89af-98cfed967095@kernel.org>
Date: Mon, 29 Jun 2026 20:22:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] hugetlbfs: enforce F_SEAL_EXEC in setattr
To: Eva Kurchatova <eva.kurchatova@virtuozzo.com>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260629180247.2343229-1-eva.kurchatova@virtuozzo.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260629180247.2343229-1-eva.kurchatova@virtuozzo.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 6869jynsfzit6d5n858xe5n3ka7njwbh
X-Rspamd-Queue-Id: 08AF8140007
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782757369-585454
X-HE-Meta: U2FsdGVkX187ecD/OXtqVqgJkffLO8Uj0viTo47ymbbzataE+DHQ7EWn7HkZR6ogflDZs0Y9Mp51NkfSpnjyICbl5FVbZGT+J8FEwAzrG+artXxVbBzOYlkqOrPvcWyo3YBORq6D5IBGDgNoX1rPx/VcgtyD8tq2LLa8fW2akSny7RyDE/IsyTDthC424VJYuD+YwMxGj7v8hrRhR2qRT24HfNNYWiAqDStgdJoJQNy4z3C3ctErzVh07n+FqyBt54DbmNWwni8KjnY5w6MFBtt2OV9mxcmO0SS83ot5PJVOM215QSLaU2DU7frI8+WFTCA0uUEEQLCQY8coxOTidmMiOoE0X1LWVslcOvCNHwvlIZiK6f69txJKPrLufUDX2RpjP0Oc2rMk0Jy3Tgskf96WXu/NdDRj2DXiWZNnCs4i2nmfcQB4M3CWUANljKvvhrSFpMB6QeNr0a2/yN2mJ/pkfejvG2c2HyZ/H8vIsc7GuNOiwR190+ISRt5i5gS9Xz3H96xiG5efznBGZePjGEW7c0xHr/9GPHcjIdNoNhX+0/xrw6+vo1UJyRAszvHN6nIGbu4GRR4/bY78Vh2CWcTasdzyFnMKVNhj87rEyaA2zA22HP/YxBf6YaW0bKav3vjWzCMBYmnMCNvKw3YGvZQAM1vFYA1p4/ZYStftj+53yf8duANDhWFp/HdPHzM8wVPiiJ2id9kb+bcWqgU3YWqPPnXJVmYjFdrs+RfNNNlJBey8rjIvXQPhysFjAjOzdwleSnakIZiORClpYNV4Al+n3muI/JlK8m3hzsFRfeFmvzWsbWbrCr1xiXmUFdATw/J+h5uo8CpqDs6iWFQCBh0sks7kgDrvD0tSk1DxiB4PRUQPfweC2wP6fRhBMXR7FI1Eo202OStL2m5tYxXoasXAmMBVcuyjjFH+yjjckRJOjxHXzODWo2SAaC2wEzQdkLdBLr7Js/ziwrBLuNd
 loFYIb/M
 n8QCkauZYDZ7Zw9F1BDKaBXgd5do1uN2hj4+kKjYw3tYEV+kG7q+TmNkTt7fNAJKGz697pGYSRVwkNHO+Li48W/KjNYzjM4A+qkLegWvJ5/549bDWYj43UoajTndxZAIpCxJh06zOBpKWUaBK4E2CJ9Ur6A/wfS+M4w3HtccdM34P8LgswKvbTapKgPau42CuFDcP/VpBmb/K/Uc7OlNJsdoGskKEx0wqUCkPnYt0m3AgYQn7zIgJCLHVDoWDhXggkY3l8SFhrYOejY0zz9B6Q5g8fS3wZvHBYr6ihx5joTCM6HRqaRBldwdbW06y8Fu5loktzBZLPcMceMFsHxSs7m8UPmG2iGyg62m/V7sQl+pbO+TLPprqwOHpqcWTWIw5UQAOKNS7CR3iFoUBMuODoyslJjhICuswTTCf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/29/26 20:02, Eva Kurchatova wrote:
> Commit 6fd735518263 ('mm/memfd: add F_SEAL_EXEC') added the F_SEAL_EXEC
> seal to memfd, with the corresponding enforcement implemented in

$ git show 6fd735518263
fatal: ambiguous argument '6fd735518263': unknown revision or path not in the
working tree.

Is it

6fd7353829ca ?

commit 6fd7353829cafc4067aad9eea0dc95da67e7df16
Author: Daniel Verkamp <dverkamp@chromium.org>
Date:   Thu Dec 15 00:12:01 2022 +0000

    mm/memfd: add F_SEAL_EXEC



> shmem_setattr(): once F_SEAL_EXEC is set, fchmod() of any of the execute
> bits (S_IXUSR|S_IXGRP|S_IXOTH) is rejected with -EPERM.
> 
> The hugetlbfs equivalent in hugetlbfs_setattr() was missed, even though
> hugetlbfs memfd files carry the same 'info->seals' bitmap and the same
> F_SEAL_EXEC bit can be added through memfd_create(... MFD_HUGETLB ...)
> plus fcntl(F_ADD_SEALS, F_SEAL_EXEC). As a result, the seal is silently
> ignored on hugetlbfs memfds and fchmod() may turn execute bits back on
> after the seal has been applied.
> 
> Mirror the shmem check in hugetlbfs_setattr() so that ATTR_MODE changes
> that flip any execute bit on a sealed inode return -EPERM. This also
> fixes the memfd_test 'hugetlbfs' SEAL-EXEC subtest, which previously
> aborted on:
> 
>     fchmod(/memfd:kern_memfd_seal_exec (deleted), 00777) didn't fail as expected
> 
> Fixes: 6fd735518263 ("mm/memfd: add F_SEAL_EXEC")
> Signed-off-by: Eva Kurchatova <eva.kurchatova@virtuozzo.com>
> ---
>  fs/hugetlbfs/inode.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
> index 216e1a0dd0b2..812bf8e21b91 100644
> --- a/fs/hugetlbfs/inode.c
> +++ b/fs/hugetlbfs/inode.c
> @@ -841,6 +841,11 @@ static int hugetlbfs_setattr(struct mnt_idmap *idmap,
>  	if (error)
>  		return error;
>  
> +	if ((info->seals & F_SEAL_EXEC) && (ia_valid & ATTR_MODE)) {
> +		if ((inode->i_mode ^ attr->ia_mode) & 0111)
> +			return -EPERM;
> +	}

This matches the mm/shmem.c change but could be written as

if ((info->seals & F_SEAL_EXEC) && (ia_valid & ATTR_MODE) &&
    (inode->i_mode ^ attr->ia_mode) & 0111))
	return -EPERM;

But even better would be factoring that out into a common helper that checks that?

In any case change itself looks like the right thing to do for me.

-- 
Cheers,

David

