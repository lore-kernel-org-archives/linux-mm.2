Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1DEE8EFCE21
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 17:18:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 663946B008C; Wed,  4 Mar 2026 12:18:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6044C6B0092; Wed,  4 Mar 2026 12:18:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FD126B0093; Wed,  4 Mar 2026 12:18:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 42C1F6B008C
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 12:18:52 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DD7B9160679
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 17:18:51 +0000 (UTC)
X-FDA: 84509040462.21.53AA7C3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 4A0D1C0013
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 17:18:50 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=t3IYLbGw;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772644730;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SXIJo8Um9DJaOeJ8R0+KhL8pEOqnYZXLlZPtbE36k5k=;
	b=X3iOxLay3ph8lGRcftMVNDNUgtOv4EmIE1JLvTNX56ILPmVgaP9RHPv5Rt05K6hwZXKvDM
	6QWNDYR+Y2fOR0ZwMCuU6Ez+G05ddGwjRzms0w/ttO+VicRx7QAYHIv2KYWocQt5TgEj7c
	npUaDieQShZP5Wlg8Wk4gEeA2DBtmqg=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=t3IYLbGw;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772644730; a=rsa-sha256;
	cv=none;
	b=RmLPCLESsVVg4nelaO0lafkX0WCc5sSAlrikImKz87BXDN10TFVjyFb9TVCSlHSLWjGDEb
	nbjp/WsKeOY//+wXMoDZbGpGwsuPltNU6pNJ4y9O30RB1NdXOYRon4Zoegp8nsHAmQZ13a
	prks2z9k1zBu72nso7BiMzD3jsFscAA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id AD17D60053;
	Wed,  4 Mar 2026 17:18:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C426EC4CEF7;
	Wed,  4 Mar 2026 17:18:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772644729;
	bh=g5C3FUKozX2fdPL8KVCmpJ8wDVxpEaVyXOt4AuGO1gM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=t3IYLbGwsKlcQmUVfoA6netjuOU4UuyTI3zXwqZ+Il1a0tiZj59rdpuWvS549NQEn
	 xi9gD7hutEciVgEiUnpiMRyhyNEHJfTpYp/1Bg2M+3K0h1+LEaDE2wLOjInmzhiRl+
	 VvsUDDU8lzvjIH9zT7orSqbEiS5T/GUT+JAwI401V0OB4O/DFEWfNalGjdbHUvkumh
	 AHrJzVN2bCc3BwfNCAIlsrU0R16gw++UAzzhJVB3HlG13iIYpxqFLsvPJyW39GakK7
	 c0rlDPhd2VQOKcqp5U31eQRaz6CryYIwXiFb2jyulR2AxQMoTrEelWXXgbG31na3g+
	 HGsne3JICGZTg==
Date: Wed, 4 Mar 2026 17:18:46 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Hui Zhu <hui.zhu@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, Hui Zhu <zhuhui@kylinos.cn>
Subject: Re: [PATCH mm-unstable 1/2] mm/mmap: fix Use-After-Free of
 vma_iterator in dup_mmap() error path
Message-ID: <344d7d4e-6ecc-409b-874f-f44c89b1c0f5@lucifer.local>
References: <cover.1772607155.git.zhuhui@kylinos.cn>
 <2360c415d4aba233d80666b8820ee31aa77c54d6.1772607155.git.zhuhui@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2360c415d4aba233d80666b8820ee31aa77c54d6.1772607155.git.zhuhui@kylinos.cn>
X-Stat-Signature: msni95i6ojqk16jju6imf3u6mpfxkpya
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 4A0D1C0013
X-HE-Tag: 1772644730-748576
X-HE-Meta: U2FsdGVkX18Ijv6pIDMaCaAprskW3QK1OuVqSxoipSWlqVp4fgHEPB/aEVbvvTZRrehlrYT29h9sTS1eGIjNqBee77EzS6Uus6CbgSVf1uGlxiFypvywfrZPOPwRpct+pZSyWdIUUt047TJgwuWSQQGbEvBaBS7dhyAroqrNysd6ZzMQsR6/ZDhD5s0kW6xqA/nPIBcif6Co+v6HUGy/0JlNqa7+EqqpeqWV4fPXaJq3Z2SgB8U+U1nLRb6RWgHl5U513NXiwJHYrGvTWAVNUvFh7KXJWZ4NrEGar06Zrs0qE9kG6SfyvGj2SKCk5sZC8l2A0h3hjVXdSgCS5gycDtbT0knH4ewS7nnLdHEHZ2CJB6JVZSs5ogFv4dorpXAO4LFlyKFsxZLFPIz95Kn6a4rMYPMza0HyCCRVQRTgrfTSxGaiZn0Br+S2meVz9v3uVmWC+rCzdMD10gGvvOsrdALjHbySfTXh9F6VWQSHCkTHqas7DLR4dlLN5Pveocksilaci+lf4oWsI0bhk0/u71ldfSfgUijhd33lXEL2rl7FmuM9Q9dKGHV2GSLeGZXVcKk3WpqBHk+721YsJKUONF4E23sArnm++LrUzoEERa9QeBJJiv2n0o5I5U46lDwIMsLS/SLKldOpiSniFERhTF92bzDICjcZytnyoynzxGaZoQOKU1ILlGFPNMccWmjPrd/O0UWVZO7mK03D/6G+mOu8G2sjTnN7IAU3dYRWKdKh1b8HwEah/fwRYWKfyPRXRIcji105JMUtlVmdn16UW+GV1EBoRYQzMsPV2Xp1ztLD1L7l6y7pBkhLwk6voRFHIjqK79Wq0KX6erJ9X5ScnPNEk6Pc+PQ3E7BKred6OmYPtBuh0zBE792a0ulIroGrofP8wuBkxrbP9GRcl3LtQihdvCjUNvBB2oZv9klG4Jpiz3X25sqb65eMLRFblWREcl5aLJhuM4MJYzi2VRp
 yp7/8fFv
 DN5BUlQWvU+UDTA8SXrKe7zK8hYIsYMKsxEXCeS0LZ48ryoP2qgX6bDpaeOHzfLyn0KD8DXvH3QXMRbXaMzqVwhtAzNudlWobDYdwewzG+Cxgk0MEwBMd0JB8996E08IFiJMPfZfkfXFm4MfxPW9WQSA84nDUah5VltU2t2/y3KV0kQVlNfI3HkIuoLD9qo58dY+S0fcTRZSQOZAwIMZ/gWRRras6IwUkWExM8BeEJX1yqMrreSIQBv78tTqCQCFvH1fP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 04, 2026 at 03:00:56PM +0800, Hui Zhu wrote:
> From: Hui Zhu <zhuhui@kylinos.cn>
>
> When dup_mmap() fails during the process of duplicating VMAs,
> it jumps to the 'loop_out' label to clean up resources.
> The current implementation calls vma_iter_free(&vmi) at the
> beginning of this cleanup path.
>
> The error handling logic still needs to use the 'vmi' to traverse
> and tear down the partially initialized maple tree for the new mm.
> Since vma_iter_free() calls mas_destroy(), this results in a
> Use-After-Free (UAF).

No it wouldn't be a UAF, vma_iter_free() calls mas_destroy() which simply
frees any allocations associated with the iterator, so it's fine.

The use of the VMA iterator in the else loop doesn't allocate anything as it's
not setting anything so it's fine.

>
> This patch fixes the UAF by moving the vma_iter_free() call to the
> end of the cleanup block, ensuring the iterator remains valid
> throughout the entire rollback process.
>
> Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>

So yeah this patch isn't necessary and suggests a UAF that doesn't exist.

Let's keep the code as it is.

Thanks, Lorenzo

> ---
>  mm/mmap.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/mm/mmap.c b/mm/mmap.c
> index 843160946aa5..498c88a54a36 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -1848,8 +1848,8 @@ __latent_entropy int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm)
>  	/* a new mm has just been created */
>  	retval = arch_dup_mmap(oldmm, mm);
>  loop_out:
> -	vma_iter_free(&vmi);
>  	if (!retval) {
> +		vma_iter_free(&vmi);
>  		mt_set_in_rcu(vmi.mas.tree);
>  		ksm_fork(mm, oldmm);
>  		khugepaged_fork(mm, oldmm);
> @@ -1893,6 +1893,7 @@ __latent_entropy int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm)
>  			charge = tear_down_vmas(mm, &vmi, tmp, end);
>  			vm_unacct_memory(charge);
>  		}
> +		vma_iter_free(&vmi);
>  		__mt_destroy(&mm->mm_mt);
>  		/*
>  		 * The mm_struct is going to exit, but the locks will be dropped
> --
> 2.43.0
>

