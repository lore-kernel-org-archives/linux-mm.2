Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36497F364A5
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 17:04:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 88FDF6B0005; Thu,  9 Apr 2026 13:04:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8675B6B0088; Thu,  9 Apr 2026 13:04:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A46E6B008A; Thu,  9 Apr 2026 13:04:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6B9506B0005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 13:04:55 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1D61D1B8BC5
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 17:04:55 +0000 (UTC)
X-FDA: 84639642150.24.5658AEC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 56E0240008
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 17:04:53 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BuFnRLrC;
	spf=pass (imf11.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775754293;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6zkA8te2VcNctgRvQOKvrYylsf1ncXgi32RcUcEP6OE=;
	b=mCoB2sGzD0Wj+iSFlMezM/wKuXZV8or1RUtMqzPEirXRYnYJ1jdI1Ps5HYd+IfaP8kJ0+3
	aa6P8XDYc/k0afHLjYVMYMbrAxv9xa/BfL7QifA5DrkolPOB1FUwWsrQBkYT3cpQ95nQG5
	ErUfVa2EI22avkCA9HjgC/E+WqgqAYs=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BuFnRLrC;
	spf=pass (imf11.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775754293; a=rsa-sha256;
	cv=none;
	b=7UaVAXyQa2TO3y4nfGmn3Xln8tiOgeHS4+mf4J2pnNV1JpE8yj2/AYrbq7eC4SzILT6FKw
	Kvlfd7ITZR9HCMO+gskESmyTbxIfk9sEu8wY+igyrEgUJn+SPoHxnR07NdQ/P8yltsMxiT
	aJDcWwlPcrSmV/O2XuDy+tuCxnRcWjo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B9484600CB;
	Thu,  9 Apr 2026 17:04:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6989C4CEF7;
	Thu,  9 Apr 2026 17:04:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775754292;
	bh=SNp5Dca2WkR7m+cZfnjJ08JI2QTkKbVMIgFIL0NCEFE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=BuFnRLrCwQF8NSp2qmLtteCUTqxnummyH9ZdjP84VJaLdvDn09YVcg7dshUyoc0Wu
	 hyHfGrm+fMI9YyITE3P6RtG7MPc6rVqL/7Wk884lOXmyGRhu2b4/Fx8wkfNBxkM9US
	 j+rv3qits0ZUeTdnQQgen9jhsnp+oi4imuxyzSJ7mzftaVL+/+hDMx+r2FZdUxAozH
	 HhKrcoutX0VHIh4Mh3RZ+gmn68twsaC8ZW1xvQuTiev2WGB8/pahEubDNbYoVQxrcI
	 IM7AXKs8jAffgJcGsvFN5DFCIfNCmW4Y27OhGasjgKogSS+bpch4hn90sOcOtbBG5R
	 65e7u1Fl4w8kA==
Message-ID: <b8b1fa91-b3f9-404d-b6b8-f1cb2077a108@kernel.org>
Date: Thu, 9 Apr 2026 19:04:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5] mm/userfaultfd: detect VMA type change after copy
 retry in mfill_copy_folio_retry()
Content-Language: en-US
To: David Carlier <devnexen@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>,
 Peter Xu <peterx@redhat.com>
Cc: "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Lorenzo Stoakes <ljs@kernel.org>, Jann Horn <jannh@google.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260409120653.290386-1-devnexen@gmail.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <20260409120653.290386-1-devnexen@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 56E0240008
X-Stat-Signature: n9tpk3wfug8jr9rcapsimncebpecg8rj
X-Rspamd-Server: rspam06
X-HE-Tag: 1775754293-433753
X-HE-Meta: U2FsdGVkX1+57xsjeDujw+Ly3E/cjbe5MVyq3bzaZ7RXjcObR3xRcBb4kV2KiqDrx3b7rDxN/mDbupjNq6VRAI6qJilWTKGPJcnHqK8trz6rYmM1RaSkRqJdIj1ZOjRz5UspwzSQ6QGlkWYgD0h3tLKwaRSwxCJoTjuLy5g32eBSDqQuzt2cJx3RNUibQtwVCGvOlvYjErgh1fZLTFIACdvlY+fs8PAxKTAhAeCFEtQd9K97OsTbifnS5f39weYB2tdJvIQfVEeL1+K1EdqB0j2Snepx0uc+sgqvA9LCAFPMWGNPOC0AGZPpdEV4GIrJRl/RF3kf9YtBaCIOxD1IaulBZ+QG/Ob1BhMUeAoyn62zx3xvmWh9GOVxr34DUQIgbXGnVr+XFOh4lsEV9Ly+8eOLJyet7I3h5B6KSkdqaN5egg7bQeJFomrQGU6YnmDf3Sd87ffsHhPC6BU3FubfTMTz69DZ9Uy2ysmyUlkYzBs/6IvE5YOTLT6QdALBSlXQCUXzC3920MXz1lpezIw6YUmVkHRtsfCpTST+hy4/25Jtt1Jl8/LZraAzrsTk8kpa6uiV914GojCRERUvaNJxrHJMTLk+zjl4HhPBtYcX3l8ZdPuV09+XFKjA64XxVn2gkAOwfwm6ihxpfw6rcBk9pHZ6BbR+10lIqlA3vGGCttCRNKoH5jtj2qx+qhfbN6JwqXsKdud8pWrmpS10P/B4tQtbFTvYk1CL+sqdPFlwQV/4ukYQ0oli3XH1uprZMTsFlpKurIn48U0jgckUI2ayo5ji30G2BMz1oNPb4syqvop5+/FVOV9W7sbbJnvMlRghooVxU+zazb1yshWHsj6vjra5Entz8vfLHpp9cDE94xlZ9ecneDiYXvnQgWMBp67JDHekLW4zx2dwMxYlzGazPE5x07fJtA9F+elA5e30ft1BqqzM1+3iTi08ZHu0v6pmR+JLdx2fduGncclVC5k
 MKxBvogX
 4B3CL4KaU5+t+MZzWrUecchFpYmR2/qC1MfPq+3apHZ1BXj0c8gUfboeG729M9pZoD3CNnF5C/9IXonYVmZTKJ9RNHzlaKsJ8yVKoXyKQp5A549zCU8wAY9nG9NiuOrN2SHEbdEkJuYK4Lc14qEl0Ws53/Aw3n7sX16pJ9IdqNv6dRAlz23Axr9Leti3bbF3C5iFEn8wwaJwFQMZjJdfYUn+/VNMT96RGP3Sq1d2ExzVL6AeI1gOwpCyf+6Xa4m3VvtTIF6HjZAPOM8S0mkXpVtV7Zrpg8eeiiqmTprnt/On2qsMFo5PrhJ0F5gx1DM6qS9KRpewlyr3zQAM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/9/26 14:06, David Carlier wrote:
> mfill_copy_folio_retry() drops mmap_lock for the copy_from_user() call.
> During this window, the VMA can be replaced with a different type (e.g.
> hugetlb), making the caller's ops pointer stale. Subsequent use of the
> stale ops can lead to incorrect folio handling or a kernel crash.
> 
> Pass the caller's ops into mfill_copy_folio_retry() and compare against
> the current vma_uffd_ops() after re-acquiring the lock. Return -EAGAIN
> if they differ so the operation can be retried.
> 
> Fixes: 59da5c32ffa3 ("userfaultfd: mfill_atomic(): remove retry logic")

I don't have such sha1, is it a stale mm-unstable commit? Seems to be
4974a6aaa768 ("userfaultfd: mfill_atomic(): remove retry logic") now in
mm-unstable (and can further change)

> Signed-off-by: David Carlier <devnexen@gmail.com>
> ---
>  mm/userfaultfd.c | 14 ++++++++++++--
>  1 file changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> index 481ec7eb4442..214923a411c1 100644
> --- a/mm/userfaultfd.c
> +++ b/mm/userfaultfd.c
> @@ -443,7 +443,9 @@ static int mfill_copy_folio_locked(struct folio *folio, unsigned long src_addr)
>  	return ret;
>  }
>  
> -static int mfill_copy_folio_retry(struct mfill_state *state, struct folio *folio)
> +static int mfill_copy_folio_retry(struct mfill_state *state,
> +				  const struct vm_uffd_ops *ops,
> +				  struct folio *folio)
>  {
>  	unsigned long src_addr = state->src_addr;
>  	void *kaddr;
> @@ -465,6 +467,14 @@ static int mfill_copy_folio_retry(struct mfill_state *state, struct folio *folio
>  	if (err)
>  		return err;
>  
> +	/*
> +	 * The VMA type may have changed while the lock was dropped
> +	 * (e.g. replaced with a hugetlb mapping), making the caller's
> +	 * ops pointer stale.
> +	 */
> +	if (vma_uffd_ops(state->vma) != ops)
> +		return -EAGAIN;
> +
>  	err = mfill_establish_pmd(state);
>  	if (err)
>  		return err;
> @@ -495,7 +505,7 @@ static int __mfill_atomic_pte(struct mfill_state *state,
>  		 * will take care of unlocking if needed.
>  		 */
>  		if (unlikely(ret)) {
> -			ret = mfill_copy_folio_retry(state, folio);
> +			ret = mfill_copy_folio_retry(state, ops, folio);
>  			if (ret)
>  				goto err_folio_put;
>  		}


