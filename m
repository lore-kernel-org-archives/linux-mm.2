Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90583C54F52
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 19:49:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 92EA06B00A2; Tue, 28 Jul 2026 15:49:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B9696B00A3; Tue, 28 Jul 2026 15:49:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A73E6B00A4; Tue, 28 Jul 2026 15:49:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 554696B00A2
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 15:49:24 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D98ED160466
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 19:49:23 +0000 (UTC)
X-FDA: 85039224606.06.F8CC749
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id BA6CB1A0002
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 19:49:21 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=RNVeSnHH;
	dmarc=none;
	spf=pass (imf19.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785268162;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=peN88L+jrff3B52AQMUyFAIDeXCiNC9wXQHJpte/T4I=;
	b=L3Rk5sBGuL7IV2xfJDt61Ul/yDQacNyCRQSai4zbCdZNuIS946JZsQM3bQtxHG+b/l+ALp
	ESBAlQVZTk1DoHSglLrv/7QfckS21AFhx6j5ioAiSZFSOaSoFQGLCeh0kmaTzQrQr4XdVQ
	egFH6auu7WBZt5fePCu3jnGmByNaLQ4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=RNVeSnHH;
	dmarc=none;
	spf=pass (imf19.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785268162;
	b=sInjgEkDCl+x5fekS9LJjpltZRMASTO9lFDzfBJii+UrIdRjnungzc26IuuN6bS6n6iuyK
	wu6T2d37S8IpmgPKzHaLO1Sx8+sLvn+DG/lRKLswJicvVpiAhcRPUPW9m4diyswzKRq/Ep
	6Q+UpUT+aZuye5IDUEB9gGctIrzafUI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 662074341E;
	Tue, 28 Jul 2026 19:49:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 082E71F000E9;
	Tue, 28 Jul 2026 19:49:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785268160;
	bh=peN88L+jrff3B52AQMUyFAIDeXCiNC9wXQHJpte/T4I=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=RNVeSnHHJojTv+KIuX/p8EF3Iyz3vtmgbMHduSwsht75BLzj3CUsVDXWfhJzMI4Ap
	 L5r2B1YEKOCtJej37+j4XlLWn6ywIC0+z3ztLfwJA2Mu25eURyzcED3OVIA6IgCZwG
	 irSjNClgZqpZiqyzI0d4Gm7SOPDIf6k5mcqdHuUw=
Date: Tue, 28 Jul 2026 12:49:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jiacheng Yu <yujiacheng3@huawei.com>
Cc: <hughd@google.com>, <baolin.wang@linux.alibaba.com>,
 <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
 <liuyongqiang13@huawei.com>, Christian Brauner <brauner@kernel.org>
Subject: Re: [PATCH] mm/shmem: downgrade final i_blocks check in
 shmem_evict_inode() to pr_warn()
Message-Id: <20260728124919.c023a7f9b8be446bb785ec82@linux-foundation.org>
In-Reply-To: <20260728091014.3876715-1-yujiacheng3@huawei.com>
References: <20260728091014.3876715-1-yujiacheng3@huawei.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: BA6CB1A0002
X-Rspam-User: 
X-Stat-Signature: n1u6knay4z8m5ibrnxn47zdram7kyjbg
X-HE-Tag: 1785268161-259353
X-HE-Meta: U2FsdGVkX19dAqLlGMaVtKpgWoFhPXguTT7aRTQHNFPnUhx2WIn23O9rO5Y5d9l76JVk68vxzwlecX/NkNouVuGIcKHoxFumBGN/s25xK3ALXri4ZVOy+rUqNLpU+yEwfy0A+GB20A7jA6eCEsan950LAQ+gDUHdwY3/0eL6YOdl5889tFIAEcaNy4/N1728gcRlG4VDoPmrtgom6vdzGUV4YQcSnb1K8YZIgWxW8FkSTuzKUsMxNjBbEwV6r4cV+As+k3FFArpJ0cCREoAUrjoiKsD2rvKEJmlGXsuWDFO/x54rF+FwQCKcKstXOGu47bDEhgUiZ2TN1X4XOQB87LWHIUw7KGGwM4zUhgIog0whla5ZOs4vfELBeKyYlNI7VWUj56PT61EQFRqPX4EsgFrGnGkBnuiK+cycw3mSPDkbyuEI3cCg36Ik8aeHE9u5uXnGjLes9kyCMb0MQcikQ0HjukUlsYjWwwAL9dfzYdxyJFlLqnKjCQtXgp6rhqi1tlsnn9dGCCzrvXAci3mMHMWHLSLztrb9xhhzNvth9syN7oBvGe1sHO2UmXZRBHBl/eZEtGX4E/VgnoAJR81KaxRucRvkZ1YDllYb9fuz7K2QtBY2vC9j+j8pbi6viMH76fDpEl7tInOyKlb4IrD02Zw/oamr5RWQxwxyAqK+OfLXceN/bnRtAOCnQBUJ5vNZdfEIRZc0Lph60rzNejigIaSjE6N84m0/w7l0P5XbGM9HcZ3MdX5gQVx7chSydjSttz0QKoAXX0s509d4RniNOCKsqYrs11aCL9KFyNPf3lNdNQK/FoXNbmaSMPFQ7vSSUskUaTEPAFEfOO6rndxrbnkpBGpdjg4gqCVzEFqKb4Paq9T/EF0kmO7iRbgFX6GdKTzJ+MHDoiJVZJFE+uAevWC9+kplpFM1F6Owir9CS9W7Qif/ivbfwfn4FjxQED4Cl2icLSiMm9CiFORznCl
 rARz01DK
 4JcQMHv13ZJT9QMaL6t/DRw8MMESNnajdKNKotwZWu8fCKKDCHvPtnYSmTPCHXyoiiIiTxw1mg0mt+HpxI2cOnYChCIBCZllSqIYe6RLONdTCTm1aJROfajzCzrnkEYcOI4HgkKERYXMNS/j0tzSJbhJQ4pBB4P3p2Nv16AKqwVhwFgNJk9Es4/Df1naqVFjMPXPfCJZP2/CEkqRlLg/DgCMWxrFOhDO1oT4pjmELdOrrfYMtfM6DeMhy+iQ4mceVIwhZPHb+RfCntJXR7moUFp3Bgrxx09CQFjndcL5AUYILH5VKyEig3SlY8MFTARuitKir
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 28 Jul 2026 09:10:14 +0000 Jiacheng Yu <yujiacheng3@huawei.com> wrote:

> shmem_evict_inode() ends with WARN_ON(inode->i_blocks) as a final
> consistency check of shmem's block accounting.  When it fires, the
> inode-local counters die with the inode; what may linger is a small
> residue in accounting kept outside the inode, such as per-mount or
> per-user charges.  No data is lost, and no corruption follows.
> 
> On kernels running with panic_on_warn=1, this accounting inconsistency
> escalates to a full machine panic, which is disproportionate to the impact.
> 
> Downgrade the WARN_ON() to a pr_warn() that reports the inode together
> with its accounting counters (i_blocks, alloced, swapped, nrpages),
> keeping the inconsistency visible in the logs.

Fair enough.

Does anyone actually use panic_on_warn=1?

> The accounting bugs this check has caught over the years -- the
> swapout race described in commit 0f3c42f522dc ("tmpfs: change
> final i_blocks BUG to WARNING") and the error recovery race fixed
> in commit 267a4c76bbdb ("tmpfs: fix shmem_evict_inode() warnings
> on i_blocks") -- are real and should still be fixed; this change
> only removes the disproportionate escalation.

Boy we have a lot of bugs :(

> Fixes: 0f3c42f522dc ("tmpfs: change final i_blocks BUG to WARNING")
> Signed-off-by: Jiacheng Yu <yujiacheng3@huawei.com>
> ---
> One way to hit this race: soft_offline_in_use_page()'s fast path drops
> a clean, unmapped shmem folio via mapping_evict_folio(), where the
> xas_store() and the nrpages decrement are not atomic against a
> concurrent shmem_evict_inode(); the final shmem_recalc_inode() can
> then read the pre-decrement nrpages, compute freed = 0, and leave one 
> page charged.  Same class as the races in 0f3c42f522dc and            
> 267a4c76bbdb, this time in the under-count direction; reproduced on   
> 7.2-rc4 with madvise(MADV_SOFT_OFFLINE) racing MAP_FIXED replacement  
> of a shared-anonymous VMA.

This paragraph is nice - I'll move it into the permanent changelog.

> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -1428,7 +1428,11 @@ static void shmem_evict_inode(struct inode *inode)
>  	simple_xattrs_free(&sbinfo->xa_cache, &info->xattrs, sbinfo->max_inodes ? &freed : NULL);
>  
>  	shmem_free_inode(inode->i_sb, freed);
> -	WARN_ON(inode->i_blocks);
> +	if (inode->i_blocks)
> +		pr_warn("%s: ino=%llu i_blocks=%llu alloced=%lu swapped=%lu nrpages=%lu\n",
> +			__func__, (unsigned long long)inode->i_ino,
> +			(unsigned long long)inode->i_blocks,
> +			info->alloced, info->swapped, inode->i_mapping->nrpages);

I don't think the i_ino cast is needed?

blkcnt_t was possibly 32-bit a long time ago but afaict it's now
unconditionally u64.

>  	clear_inode(inode);
>  #ifdef CONFIG_TMPFS_QUOTA
>  	dquot_free_inode(inode);
> -- 
> 2.34.1

