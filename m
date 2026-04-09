Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D1A2F31E22
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 15:20:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6DD0F6B008A; Thu,  9 Apr 2026 11:20:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 68E1C6B0092; Thu,  9 Apr 2026 11:20:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A3B16B0093; Thu,  9 Apr 2026 11:20:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 488756B008A
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 11:20:27 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DD716160464
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 15:20:26 +0000 (UTC)
X-FDA: 84639378852.27.AEEC1DF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 385D940005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 15:20:25 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pLgfQ2wd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775748025;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TjT1lCBts9+nGjdmgN2+udMG66pBga9mn29vtO5y8nc=;
	b=Lt7ph0xtlcYuTONOKwnuYiUvhpcsSIoouK2WC8f00iuccSTmI0d/1E+AtuVls4Nsj6HeFM
	Ep9iTKiXTNRQ9YJ6Aiuiu8TFZneV37i9neFE6XDYoblxX9hK/8hyc95xcMlzERLMu2nU0z
	M7Rq9wEFz9orPijyxJ/COPCLHUeBHLY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775748025; a=rsa-sha256;
	cv=none;
	b=Gp9oVLMMFfmflAwcXJP+8EwIzbGfxbFpCqWMRJBubPeNSJAT1brNGxTQ54TnpcdMB2DjW0
	5LIohYahiateUrvhbKosbAQotYCa8ulo8XvkPqrGsyyRZ7bYF1yS9fiIyiLCW9baG1Jzfo
	VBdsng4IVQXRCoOz13xWpjwhgAZAroQ=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pLgfQ2wd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 400DB441B1;
	Thu,  9 Apr 2026 15:20:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A679C2BC9E;
	Thu,  9 Apr 2026 15:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775748024;
	bh=CYBSGM9SzwH7P635l4C7PjyfDosC033edsSUrRg6c3o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pLgfQ2wdyqZd657n0SMW+WOSBGOr1xPSqAtP5HFmvpDMOoKKIIbck1g+bgKqcjIAE
	 DPnUWWXg72eXz5SdFII7wophQDgGHOqV2OKX6V9qmr3jxzqD7M6Nuv47v2Mf8AGPEF
	 SVlcLqGdLjK9xJQvsViIFUoUtYPbD/94vx6Ny57yPDSiIFIhNmepn31jw5auTTqB9q
	 hBe2hDTfPyO0TM5T1as6KN5Bvu6AesM64rZEFN65ovEn9ekq5eg9AIYUufSjL1w1ma
	 vNsD42lGcJjC92Z0Kfbw4mEGK3EPQFpVILJdzwdexJ67TpfoFZ9FYvyvGDTkoQOi/P
	 bm6us5A5h1BXw==
Date: Thu, 9 Apr 2026 18:20:17 +0300
From: Mike Rapoport <rppt@kernel.org>
To: David Carlier <devnexen@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Peter Xu <peterx@redhat.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5] mm/userfaultfd: detect VMA type change after copy
 retry in mfill_copy_folio_retry()
Message-ID: <adfDsZZnIadaCsuW@kernel.org>
References: <20260409120653.290386-1-devnexen@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260409120653.290386-1-devnexen@gmail.com>
X-Rspamd-Queue-Id: 385D940005
X-Stat-Signature: cra3fjzyeioghz6px9iy3743f6wpqx19
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775748025-611240
X-HE-Meta: U2FsdGVkX1/pU7h1Oct+n80gbBlmWjT9bZ/W58yL5Gp+Pp0lm2V0Vyyj+AvlLTYnKhGmqVARPoDt20wd2rHT6Zx/jdhLH2/0tC56oNSWDb49D7sgItRMvdsJ9wY2UDpw1GP0gbrNuCLOXjTQhPh5hGIgzAOxYkvGDmZ7A+rT4GxHlzMnCzVBsjkESNMymb3MylaFN0AkyD9CgeBAQbyZzDX4IZzcFscNldQ1bfdktxjw6HgsCMYuboqV4cHnm5yhVcivEvOcZoFdMS9Rf51jutEEtpZykYgmuPFAyF/YVfK7XGxpinE42BwfwjmCIWkfMelTMC5Yifyu+2OOZ2uvCPlcpjb2fyp9oo41lBqhCxW5UX5c/s6YNKTIyoeUDld1Hb4UZV9dtesZPwSeasFc/+1fRJV6hITkJBqMr3sQvT6o90D3wykHbR8icDeKRfOwJedC6jaYTJnZ5KIfMx0NddZRdmHJNDBt4KKSwHRX/s7MMljJfTXOLxOdW67xwd3OzzeF6cyf8c7XFOqP8t5qVrZvD3Q5IiZ83YzWVIz2DB9u6c2JJghMEayXB57O9qEl42qHYk9v+IQgFKKanqEpybPYA6xFwaytHSHfZ9TyN4B2LwZCBaCIwgl8OCFXoU72tQIN0ZCE6sqkYe+1BK7fhBqut4YQnHR8qZ239Jq4F5K3bLdHqCTr8mgJGgsmhCTcABP+1a2kknndMneKDK/A2DSdlqF1jd8QmaOiK3X8scfMOu6edZ/tKacLfO1ONPCWXX62S7ToAskngBIKfKroBx9rb3KPA1/i21YRD8N+fHSZEo7N47pKp/elGnAbef9wmyw715UuxDm8yhwZ94DdNJYvbLbQwdo+bXrTeQaUT25Vk4yl0HrMRFSJUwDyyWwllDwOHCFZ6agDIiKG3uJImxPLYQKzzceNClIE9FWMPfrhMDxXLZ2skWD2oAHpBiEIfxAwyQECHnNg+L+F7VS
 Rx/KDkNE
 mwMYORIkQphzmN0/6e9kUAxf722BEw3a7FwIHbaSA/3Op/IsiSI/i5xCEOj75UUqv9T+cqK/A8+b6jwNGlIZ3/rP//Xyyb3vu0AJPL01DuscdNLSi9ugKana4rv/Cig5Pne1dV+Qs+vJC+WY7VaI/fhF7AoLdzM2/Ko1zp02+NHP16cBv+xJhUcJxXH3SFZGyOJ802trIthzCgIJl+iYTeZ7tljaw1CvCmbuCgposjm+cjaGwiHPbPe7qw0mQr2alItBSu3gvUDRTUM1yuLNEJcFBc8AvKyIPDxrWx81cBQQJjH1oWCHglzsiwA2ZroVducgkxIWNrFyLHRNA1wPockycEUZX88CgC3ik
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 09, 2026 at 01:06:53PM +0100, David Carlier wrote:
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
> Signed-off-by: David Carlier <devnexen@gmail.com>

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

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
> -- 
> 2.53.0
> 

-- 
Sincerely yours,
Mike.

