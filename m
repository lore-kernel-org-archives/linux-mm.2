Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 875C9C5DF9C
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 15:15:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A0F686B008C; Mon, 24 Aug 2026 11:15:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C1136B0092; Mon, 24 Aug 2026 11:15:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FDF06B009B; Mon, 24 Aug 2026 11:15:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 718C36B008C
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 11:15:22 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 102C1A29A6
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 15:15:22 +0000 (UTC)
X-FDA: 85136511684.29.675076C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 64F0C80007
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 15:15:20 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fMmZABfg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787584520;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dnL3NIui6/xO3HGPt06qkNh1ukWzVG67kuq9rhxtTII=;
	b=Xv5/eZdDYsxZ9qky9BFTLSe8emEhrhFbf3WpUBa7h8c24YKzBZp9NPJx7tG25MISEq0jE4
	1UW8Asa+NdRXD1nH6zVSlA5h3hYpsQ0yoty/x+K6MER2Ya6DR3kw/8eNlOfLx0IzVlBoUG
	iFKRMt+bo+8ZDJXWYAsxqmLs98lCMvA=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fMmZABfg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787584520;
	b=JaZr+ZWiD3qEwnSZlcPrDSO2evaoRwUpLt9qcUA8RBHcOSiNNPE3Imi3xG3L3DnhmnO7dO
	7X8aFvHm0GBBAgsJ+X47bfNMI+QncwnPVwFfbGU/iZrZNh4jo9D64L6iOvazTLGBoaWGo5
	sMDlEg/+akEcaXHCIgaqy8Edm6MxAB8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5DCDD40298;
	Mon, 24 Aug 2026 15:15:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0AD81F000E9;
	Mon, 24 Aug 2026 15:15:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787584519;
	bh=dnL3NIui6/xO3HGPt06qkNh1ukWzVG67kuq9rhxtTII=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=fMmZABfgdEK6C8vXUApy+4qYu+g50cCS7qrqCWXLuhVwRMnSZQZV/xkO18HUGV7uO
	 d7D5iT3XcCNgEdCv5dpkZ93oovNDBrQgg4AQGb3KqFB94p2IQGIsp3rsWt1AG3nCWl
	 h736aBexqYknhhQVo9M7RdcFLM5WqXmH+EQdADh253UMENMP9yPCXVPXr/n0Ld1eWY
	 25kO5ZaWjHNZNxXPumEQZ0HYHC02yz7GQCBqoYJ7k5oQYJkLx3RpjnznyohfSqo4fM
	 sKPeW7DFyRzsTNhEKfG/LwvTA1SZ7eG/UpPgeABKZlN4fyz3SAz+UNsky+bwJUNBTh
	 SUJvbf9GwySug==
Date: Mon, 24 Aug 2026 18:15:13 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Meijing Zhao <zhaomeijing100@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Wandun Chen <chenwandun@lixiang.com>,
	Meijing Zhao <zhaomeijing@lixiang.com>
Subject: Re: [PATCH v2 RESEND 2/3] mm: memblock: show all region flags in
 debugfs
Message-ID: <aoxgAYXqXvs0GFYM@kernel.org>
References: <20260821020910.3428585-1-zhaomeijing100@gmail.com>
 <20260821020910.3428585-3-zhaomeijing100@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260821020910.3428585-3-zhaomeijing100@gmail.com>
X-Stat-Signature: f8hnxnomo3jtheo54ndrun37awdh4cgi
X-Rspamd-Queue-Id: 64F0C80007
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1787584520-240113
X-HE-Meta: U2FsdGVkX1/jhwy9xaRulifksHJIHozfCYLiHabBOSPqMctVItLaEHBJAN/CN1VPk3FOBtzmE4YIXaC74Ogvh8MkVDQeAN8/ZLG70yOYwbpmgkiUlk7CtuRAeHk62Uw0+QecVPRl3c4xL/e25hYetSgBmgDACZthfKH2hcW9tINbPbh0B2Zok1TbZeSffgAcXQxt210c6JVztLii106FAw7Vn2eaa/FU2FjhBBQjQhQNyGvUkXLJ5+4XClY0itUg+Cxm17nYR8Ae+G1iIke+Iay0YFH7+ARvSoVwLfkXNQp35ghDEZIogYBF0SiCsl8xwyEweAFON+o/Xsf1BtfbWm5AeW3q8WTbMJYP1yGnUNkNDygv228zMOfmRZJB127OBNTYc7NcjmZI5yiwD6VnpzBvmR9C83BC2qx4LyjTbiGShtBFhMgddV8jBhZMW/2oooUCFYAFwaF0twKD0LoTEAbF6U/6mDni2z5hMhPcZl6XK+qPruUmqwkDcPXeK9ofMP/Nm4vsFGBpn2cIuRA0nOCnA8Yv8GZsIPk93cGUFOcYvjZKtOdn5WVieVkESkyCDl7cob4qIklAQ6lxvSSXa4ugUqpzfihj9LI5RLGu8c0h6eUsIZmMPiC2vIis827ntokQq01Wye6okF808UII6hM6siPy+I21uC0vxbsxWmhl3dDr47vxXc6EdGnt0GB3gA111IONC0/NfyO+ZgwxI2H7A6VjQCtbNP/YfwcXuHAVjnVXiV/5bj151FC3U4c7bxoJc3n8wa7qd88WOnasPxQ7J8LUtk8yWx+PtzDlBTbJOxQ88IS57UaYThrsEsMPVZ1wu+Ya5ijMWn/UVEYSgi7tN1aZEtxYkUqXLjeIzYCt14/gSrhqHjuooDs8v8jTC34ehi/2xEuBJzk81jjPBJqCwxf+qBpP4HSlTtepA8pluIbVzDCI4sK2OxoIYYFrhHsM7hCmBlM0yKVhA6r
 qfSeUB/o
 lPDhZtdy3JOvsIB1SWelVxJXh6yGYklb8qRuVR/JDMUt6AUM9k7siUs1++j++cuEIYZEaoKTzqyJTlkr4cFvY2KkXkg82KhTefRZAqP0x8MkJNUuH1R8urIlgRb8HQJ1f3hycUSY7UUvaieTaAGrMXBxXU43/OQU6OBMIWycXIPRV3JMwxCpBOLqADOAT6IONzmucGrj+R38Xgsgq7mYltnX/grwMvdW6KgFRwlYiQ0RhLCq22iMvZl6ZBhFZu0kmZkEYE0hOxzvR+EZMtBMD0AMNNFPpO+UjDKx6ViTYFaEn5uoBRZDQ9Y0nTQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 21, 2026 at 10:09:09AM +0800, Meijing Zhao wrote:
> From: Meijing Zhao <zhaomeijing@lixiang.com>
> 
> Commit 493f349e38d0 ("memblock: Add flags and nid info in memblock
> debugfs") made memblock_debug_show() stop after finding the first set
> flag. A memblock region can carry multiple flags, so the remaining flags
> are hidden from debugfs.
> 
> In particular, memory allocated for HugeTLB pages is reserved with both
> MEMBLOCK_RSRV_KERN and MEMBLOCK_RSRV_HUGETLB, but debugfs only reports
> RSV_KERN.
> 
> Walk all bits in the region flags and print every set flag separated by
> "|". Keep walking beyond flagname[] so that a set flag without a known
> name is reported as UNKNOWN rather than silently ignored.
> 
> A HugeTLB reservation is now shown as:
> 
>   RSV_KERN|RSV_HUGETLB
> 
> instead of:
> 
>   RSV_KERN
> 
> Fixes: 493f349e38d0 ("memblock: Add flags and nid info in memblock debugfs")
> Signed-off-by: Meijing Zhao <zhaomeijing@lixiang.com>
> ---
>  mm/memblock.c | 22 ++++++++++++++--------
>  1 file changed, 14 insertions(+), 8 deletions(-)
> 
> diff --git a/mm/memblock.c b/mm/memblock.c
> index f2952d725c10..36a8d2a9378d 100644
> --- a/mm/memblock.c
> +++ b/mm/memblock.c
> @@ -2895,7 +2895,9 @@ static int memblock_debug_show(struct seq_file *m, void *private)
>  	struct memblock_region *reg;
>  	int i, j, nid;
>  	unsigned int count = ARRAY_SIZE(flagname);
> +	unsigned int flags;
>  	phys_addr_t end;
> +	bool first;
>  
>  	for (i = 0; i < type->cnt; i++) {
>  		reg = &type->regions[i];
> @@ -2909,16 +2911,20 @@ static int memblock_debug_show(struct seq_file *m, void *private)
>  		else
>  			seq_printf(m, "%4c ", 'x');
>  		if (reg->flags) {
> -			for (j = 0; j < count; j++) {
> -				if (reg->flags & (1U << j)) {
> -					seq_printf(m, "%s\n", flagname[j]);
> -					break;
> -				}
> +			flags = reg->flags;
> +			first = true;

first and flags can be declared here.

> +			for (j = 0; flags; j++, flags >>= 1) {
> +				if (!(flags & 1))
> +					continue;
> +				if (!first)
> +					seq_putc(m, '|');
> +				seq_puts(m, j < count && flagname[j] ?
> +					 flagname[j] : "UNKNOWN");

Can we really have both j < count and !flagname[j]?

> +				first = false;
>  			}
> -			if (j == count)
> -				seq_printf(m, "%s\n", "UNKNOWN");
> +			seq_putc(m, '\n');
>  		} else {
> -			seq_printf(m, "%s\n", "NONE");
> +			seq_puts(m, "NONE\n");

No need to change this

>  		}
>  	}
>  	return 0;
> -- 
> 2.25.1
> 

-- 
Sincerely yours,
Mike.

