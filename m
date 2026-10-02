Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42F47CA5FDD
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 19:11:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 25E916B0088; Fri,  2 Oct 2026 15:11:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20EAB6B008A; Fri,  2 Oct 2026 15:11:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0FD1B6B008C; Fri,  2 Oct 2026 15:11:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CE4176B0088
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 15:11:36 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E86E7A0827
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 19:11:35 +0000 (UTC)
X-FDA: 85278630150.12.986164F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 2652040005
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 19:11:34 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=C2uZjQ51;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790968294;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xepjiv98niKg0eR0g6TZAWyusgKSgcyQj0ds3O6lxl8=;
	b=oTL/ALzYa5ThYkpXWwEY/u2hrKCz7ndgad3HyW7JvoVuy/kYhAQ1k9Ht5ZIbRzv8iEoPTO
	Fp7iKifqoZi6mZwtcSRe/Y4F6D4XfWWrFYAMNzA4V0NARS4AseoWL6/bqvMpLsbGGnoznA
	CQImlFkrR7jdzUGnAtpNBDHSddQ/qts=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=C2uZjQ51;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790968294;
	b=paXdHfEfCyMYv3aECjYXlmzeYpfMFuvvbaUXLIPTVnPC+FswFjcSgXOw72+psw6ReoKBWx
	pOkoUPU4SIT9huHp3bSro1nd5m4RVtgSwN0vIEmGVciLhLmy1CUe/zESP/ZxKN3fLSp4xc
	PV7yrskuX9EHomvHbDJzcOtPtKKx6zE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 56ED041A83;
	Fri,  2 Oct 2026 19:11:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7A3C1F000FF;
	Fri,  2 Oct 2026 19:11:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790968293;
	bh=xepjiv98niKg0eR0g6TZAWyusgKSgcyQj0ds3O6lxl8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=C2uZjQ51Jdphz8xDCTe/fSF/32tpFJFx0vjUDSdoaiHb0qAbb0G2b1bfsryrQ/Pn/
	 5jXtmI4fD6jGmsStgw/UIWAxCkX52RITB/QLhfy7swkp5kOgud/qG8Ve5IWaxAud8Q
	 Ed81tCq6BrT4/7U/DbRBZ/3EWbhPvYs3jMI6wbCepIJwkDeV3y0IaYk79XGWKkLrS0
	 e4uniPe5HIIEGt3kotlBlzO5mPWV5uc8ESf0vnV2hUAEXLPNKLD15BfpaMF+kYajC4
	 fRVCHrxl3aQ7OW6OYUrdu11E1tdhOjhedYdvqHYS+OlV32z6DRR54aOGqKzljjItpt
	 cby3qki4jXyiA==
Message-ID: <7bd00f36-3f48-490e-ab4c-7ed15be931d2@kernel.org>
Date: Fri, 2 Oct 2026 21:11:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 02/14] mm: shmem: shmem_getattr(): set blksize to
 highest supported THP order
To: Luiz Capitulino <luizcap@redhat.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, baolin.wang@linux.alibaba.com, ziy@nvidia.com,
 lance.yang@linux.dev
Cc: corbet@lwn.net, tsbogend@alpha.franken.de, maddy@linux.ibm.com,
 mpe@ellerman.id.au, agordeev@linux.ibm.com, gerald.schaefer@linux.ibm.com,
 hca@linux.ibm.com, gor@linux.ibm.com, x86@kernel.org, tglx@kernel.org,
 mingo@redhat.com, bp@alien8.de, hughd@google.com,
 dave.hansen@linux.intel.com, djbw@kernel.org, vishal.l.verma@intel.com,
 dave.jiang@intel.com, akpm@linux-foundation.org, yintirui@huawei.com,
 dev.jain@arm.com, usama.arif@linux.dev
References: <cover.1789695931.git.luizcap@redhat.com>
 <0f18a45baec44d193f8dbc760ef57c0430e04bdb.1789695931.git.luizcap@redhat.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <0f18a45baec44d193f8dbc760ef57c0430e04bdb.1789695931.git.luizcap@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: m6rdd7ctsf7caqydctym1uwkbaphj5qm
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 2652040005
X-HE-Tag: 1790968294-291991
X-HE-Meta: U2FsdGVkX1+5pBJ+jfkkuE6pTIbevuMWJnnp+AcS1njWGABe3XJHFi4hjhiLGZafQlxm7S1QxebKP3/THwvOFh9FQOmjQ0e+4/RsM+wA9dceLdy8Z2Z/wOIyVc1/vo97oUtyEEJ9LXkuOuumqmzBHx5p99VLPeBBzryFkA5STai/aPWae5VNUSV38eE7+9tGwW42f1lhr1b8k3nstg2f8wdyroqc9gcNbc1QiS9vUaJ5GPCan7VhxmjiK0C2AKJCZNlLLiSK7QLxLiot6e7zvT/CjwSQNgWQLHlMace2vBqB969hT7HlzszCI7HUCSRVpOVla3LbxXKOyzrPoVbzahnBDDYVCNAOUPCBRBxvTbYEBYalOu1ZY9WPIAqtfP77D29BkJbbXTWhd7dtjolh7jF0Ij+nsdB1cF4H9DIG74eEccyjrTEQs4VsmfYjVcz5BCKLaJpGujGHyVLk2nuLFsm+CXxGa5QjwqJr+3RAcbIm4RukuTAnI6uVTrJgLmYtNFlV6HlKUCMKhclRvuwFTUgzZtoal3r4y1n4JxhhRDmNwvZvAnNOJAJSZeiOHkan1xERBO90/8uyOpdXeEYgM9WrmYqkm0ViGexGYltDyUQ05HljiWu79/G3LigwqlgEMhYme8daSbPY1qAsW0BuEt8sHbE1rBslKGCdWW3iiHZzK5PwKNkxEAm3Uf4l1aG+VjnWbinh25QRTklJt75Im4qiV/YpvMKMNT9C4UzSIhY3RE8avFfYKvoP05DuwghcQiPsyA2dwTWVOC+BfESgZuY9tMLp7V/KP6S9/JrNRBU7W0en1Q1DtmPb3cDgFPYBZrViQuZd241BjA6ttTg9mt4wFw9VtZ8P5A+pj4r6d0YANgB2id/WoeOnHpgS7gg8NbrKYxDrqpbKXmozTIhJnijJnC9IYI1j6vauUyQ+K/3RD8fVZ+o6Zzzk4DanMI8HII6dO6sKwLsaUvKpKfZ
 ok0+TR+0
 BlFnOwayLq4sNsVcmHCYG8NofMnSsM+bPdkftudY3/x11pm+HeuiyvflSS31X4K9IGKkJeKUmwgZT7W8JBTzoSU6lJlohTKotO9+uQ/DUZ/7dIQO6kobNMbF3mlicVsiBOuBVH3XA9f+LgF78uHsswe2hRc1Q/jY0T/0QcIPPkSs11jwhv+14pbO0VaWDCILYRZ0HXmu4qFrpmmf3JSNzvrh30rRpc1WdavVRkihKEU8r1YoswpT5bZq/TWrnQofdPSPjEzvOo3smtBTKg196lFZGX4l504z1D1EzhJy4N2MFJovW5nm4jY/10N3c5VYenFQn3Qf/ucXvyrEJg5bMCluDjK0EmrCbfITb6jwC5hbWk9MTMt+FvuZcHLLUIDrXMRdqUb3zdvPPrwmDYi6N2mk8Cg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/18/26 03:45, Luiz Capitulino wrote:
> Today, shmem_getattr() sets stat->blksize to PMD size whenever
> shmem_huge_global_enabled() returns non-zero. While this works fine
> for the normal THP-enabled case as explained by Baolin in [1], this
> has two problems:
> 
>  1. Theoretically, when shmem is configured for within_size, this
>     could set blksize to PMD size even though the allocation may
>     be a smaller mTHP order
> 
>  2. A future commit will allow shmem THP support to be enabled
>     even when the CPU doesn't support PMD-sized pages. We should
>     not allow blksize to be set to PMD size in this case
> 
> In order to fix #1 and prepare for #2, this commit sets blksize
> to the size of the highest supported order returned by
> shmem_huge_global_enabled().
> 
>   [1] https://lore.kernel.org/linux-mm/6591a74c-7ef9-4614-9ae9-cb2fbed86ebf@linux.alibaba.com/
> 
> Suggested-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Acked-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
> ---
>  mm/shmem.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/shmem.c b/mm/shmem.c
> index b572c60f2af8..776dff8a848e 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -1506,6 +1506,7 @@ static int shmem_getattr(struct mnt_idmap *idmap,
>  {
>  	struct inode *inode = path->dentry->d_inode;
>  	struct shmem_inode_info *info = SHMEM_I(inode);
> +	unsigned int orders;
>  
>  	/* Fast-path hint; recalc under info->lock corrects any stale read. */
>  	if (data_race(info->alloced - info->swapped != inode->i_mapping->nrpages))
> @@ -1522,8 +1523,9 @@ static int shmem_getattr(struct mnt_idmap *idmap,
>  			STATX_ATTR_NODUMP);
>  	generic_fillattr(idmap, request_mask, inode, stat);
>  
> -	if (shmem_huge_global_enabled(inode, 0, 0, false, NULL, 0))
> -		stat->blksize = HPAGE_PMD_SIZE;
> +	orders = shmem_huge_global_enabled(inode, 0, 0, false, NULL, 0);
> +	if (orders)
> +		stat->blksize = PAGE_SIZE << highest_order(orders);
>  
>  	if (request_mask & STATX_BTIME) {
>  		stat->result_mask |= STATX_BTIME;

Heh, looking into the history of this I stumble over

commit 89fdcd262fd40712da65e922558872a12b203332
Author: Yang Shi <yang.shi@linux.alibaba.com>
Date:   Thu Jun 7 17:06:59 2018 -0700

    mm: shmem: make stat.st_blksize return huge page size if THP is on

    Since tmpfs THP was supported in 4.8, hugetlbfs is not the only
    filesystem with huge page support anymore.  tmpfs can use huge page via
    THP when mounting by "huge=" mount option.

Which is a good read, especially regarding Hugh's comments:

"
    : Sorry, I have no enthusiasm for this patch; but do I feel strongly
    : enough to override you and everyone else to NAK it?  No, I don't feel
    : that strongly, maybe st_blksize isn't worth arguing over.
    :
    : We did look at struct stat when designing huge tmpfs, to see if there
    : were any fields that should be adjusted for it; but concluded none.
    : Yes, it would sometimes be nice to have a quickly accessible indicator
    : for when tmpfs has been mounted huge (scanning /proc/mounts for options
    : can be tiresome, agreed); but since tmpfs tries to supply huge (or not)
    : pages transparently, no difference seemed right.
"

(I agree with Hugh, also I find it odd to indicate for THP something > PAGE_SIZE)

Anyhow, that ship has sailed.

Effectively, I think "stat->blksize" is not that relevant. But indeed, today it
gives us the highest *possible* size we could see on that system.

shmem_huge_global_enabled() does not seem to depend on any runtime toggles that
could change, only on inode properties.

So your change looks good to me.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

