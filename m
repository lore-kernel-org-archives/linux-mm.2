Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5041EC55184
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 12:52:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C5E06B009F; Mon,  3 Aug 2026 08:52:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 49D8B6B00A0; Mon,  3 Aug 2026 08:52:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E0356B00A1; Mon,  3 Aug 2026 08:52:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1BF0E6B009F
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 08:52:53 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CD0BE12063C
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 11:33:46 +0000 (UTC)
X-FDA: 85059748452.09.A5F7513
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 31C921C0007
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 11:33:45 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=g2MyOcr4;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785756825;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6H9ABNKNBGb+nR9gQcw6CuEpHYKBwTuTMP0K2puHypc=;
	b=R9Vq8lmUPPJRdox36fiFc66mSScaLOLAZ1EjIwpdz5dMiMDBYJ7sAaHAh62J0GoZxd6ib9
	8B1LJs8DOfrsLb6PfVx60VQHSC7Qv61jg3I3x02wdorbs10ALgiFsbGUyQvCpNT4bYbMps
	lwBgdhTsMUY3cgqJI+R8PVMvfiQff10=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785756825;
	b=lCcm0UmA9YfMUf8/YkziYdDhRLwtar1NXzFZtxr+c4fxS1UwOLSIQ8kcJvAORm2eJsI36G
	baG8mJSN3hosd+x5KFa0+6JI+3WUcz5QeX4xjtVijlsHYmG3v4GJJWAKzbEONMDfB5/K2w
	Sbx46ayVbRjWQI6m/4xM2sooVZMT+Gc=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=g2MyOcr4;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C5CB460A82;
	Mon,  3 Aug 2026 11:33:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D54A1F00A3A;
	Mon,  3 Aug 2026 11:33:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785756824;
	bh=6H9ABNKNBGb+nR9gQcw6CuEpHYKBwTuTMP0K2puHypc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=g2MyOcr4VptcwBPKSfUuEUFJOvDGMz/hq9+8/Dx9ZuBvLmEDbvhc41skeSqj7ZhDd
	 ewcubfC7s7PxTI/tmYcb9VBPzri7Ya5Mn/ooCE21LLZfHkDBhIifaEGdAeg6otMFmg
	 pmOOGOmTpeiDe+g//7MnlKr+cfZ5F89/c1RW2z2I0ILRlLzeKO6z+RsSDldgb/Akmz
	 CUhQiy4i4yJobHTf8SuggknNCCLeutUCf5dh2ae5RyTPR7VaY3G8x7F7S7hj2ZGhOU
	 wcnPnhL5T0zFhPS1rSTCR3IZlOqWQPLLYa3l9l/yuWxdlusqC10A4QGGRX1dUzPICE
	 41+6Xt9PbgZ1g==
Date: Mon, 3 Aug 2026 12:33:26 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: akpm@linux-foundation.org, dave.hansen@linux.intel.com, 
	Liam.Howlett@oracle.com, david@redhat.com, willy@infradead.org, shakeel.butt@linux.dev, 
	vbabka@kernel.org, jannh@google.com, aliceryhl@google.com, arve@android.com, 
	cmllamas@google.com, christian@brauner.io, tkjos@android.com, dsahern@kernel.org, 
	davem@davemloft.net, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, netdev@vger.kernel.org
Subject: Re: [PATCH v3 4/5] binder: Remove mmap_lock fallback
Message-ID: <anB7shWzNHUa4poC@lucifer>
References: <20260802215459.2769283-1-surenb@google.com>
 <20260802215459.2769283-5-surenb@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260802215459.2769283-5-surenb@google.com>
X-Rspamd-Queue-Id: 31C921C0007
X-Stat-Signature: 6dmsbu4jwc3gxg5ib5isze51mqskfpn6
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785756825-634392
X-HE-Meta: U2FsdGVkX180Z0ADnkIbUz5lIczSdQ1fEWoe/xEuLlIGRR6R/iH7qvsaRnc+oDfU2sEdCRc99Vr/sRUfMKXCeXqF3Az8BNjyDbDDZqNf5zLHjqYKxOGv6BtKtrvpx4JXRG6zl9zr0+WVejO/neMb9rZ/7mZ5i0+p4nwWN5zLRKdCfAy2WgVI6vDJfPDqNzz58wbhm0bwYYbmFg0LDkINaL0Z5IUX3VXvjc/puVQVSknTy5cGTiiFIsbzNGeOzNCSyZjb3aJuPnpaL+dAFHxQFOHFRagYFLYgOeNloWJYRI56WuvJreSfDSmnqSc9aabkj6k2jN/tip6zY6DFRReYgV/t8P9gGRUPdKbgcqCo9nrVUUOCFPG5rOhc99WaKFvJrf2ghbIl9lbbhByycQCHjU6D3OSJh3Oztb6hUf/R9BKiuwS1k2RtGmikqcNJ0vuHp9Tc75AmD2he6n4m2vdoSvhyYqMxphCcnaY4ZKFED/QSQg0wQx9vvU9bj2FUiNx3VBo/TBSjR4Rc1rm7ZGA5bnVEKEhngBt5pFpWo66vsVtxO6Al4vW0ehxZeylA7lsJCWafHMI6xeRNyitpu5oY+sBrjK/VfaDspm8PDVEvQk5FCdJZSBtJhbqhmjNnbmt60xRT44d3evqacJvv/00aemoiO9z626JQ9U1q+9w4pQU1YSlV6Ft1PkUVN0eTgFZ6q+XmnAb0vozyvnL10FYRJW4SQVGC4vtiJ8G4SWcJTBgpCVaNkCVg7juUO/34zk+yB9rzZM+CugsMMhwXreyTX2DNhBt8xvMuHCcQkL9Z/i7zqWMsOTBDY54oSkADlKd3yRbK1trUE1phC/szf45BYd0oHPBG2xAJcGOu0OksVmr4krqJEU9hXjJMUPpLkuqoA9PdIAphIMrMM82gbSn/157+r4kaF0Uq4GdK9fILVEC9YV7v9CEpIFehFRpR/5P+qJILjwwN4Dqv/ALPnNt
 fRX/6yxR
 AoEYXzUeMH+0bpegNktlAW+aaqUDSPbKnLNHYLNMJlmKq29AHubvp8NFX3QU3/0qFOCZT5Hy7m3wpZPZQy5S6E34AfOcVKYcBBoN6zKm6bo6Zve2EXMCsWpTLm1v2ljwnF/idUg8rwnBd7qEf7UQUe45ATQAGJJv4i0229rDVJrRopAD6kbS+BZJfJpQvnbX8XD8v5Cqyr4YUK0e3u/vLFMPpf6yCXC9WKn/TVanmNRZABBePF8nQpmK9T94QegyBh0sTbEelY7GDLLVPAHsFSUgoc51zIqMVGldJGQ1dxfo8Jpkn3mRuNycNjGCJqsPZAHZbjk4otxtHFKNUln7xvFFCzGiMmTTbBa0xwlOnLUb+e+kMLUFDHW/iswXukUg8jSc4OLTbkknnlM4AAPWW56pIXn+MfBjVpPwTF6dXtlXFQ3ENHOch0x7q9ZHt+h+t1ifQdaouss6ApuEMnhdmhruDpX/E8xwPsp+7kngY7ACRuD8d9hdIDKg3YsjAddeV9w91eicCsh2UleseqCqRk3oOKvttrWNp3CxsAE/Wv1WX60NhQ86jw4VjtkoXN49io5W1fIbZWy4JpPexerqc4j5TjLoFWPUx95LiantMy3fea1NO444xGHbagD/vMGuWHnCAqcbfbyiC/DpSgULtjoJzf0E169ex9SoBRylhdE/U0Pm1+Xcna9BVAidoqqpu+63UDQL672aYw1mojuwAL+3odrRnujFgb+vw7+fqdPnevVM7FaMWMulNaQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Aug 02, 2026 at 02:54:58PM -0700, Suren Baghdasaryan wrote:
> From: Dave Hansen <dave.hansen@linux.intel.com>
>
> Previously, the per-VMA locking could fail in the face of writers
> which necessitate a fallback to mmap_lock. The new
> vma_start_read_unlocked() will wait for writers instead of failing.
>
> Use the new helper. Wait for writers. Remove the fallback to mmap_lock.
>
> Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>

LGTM, just a nit below.

Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
> Cc: Vlastimil Babka <vbabka@kernel.org>
> Cc: Shakeel Butt <shakeel.butt@linux.dev>
> Cc: linux-mm@kvack.org
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Arve Hjønnevåg <arve@android.com>
> Cc: Todd Kjos <tkjos@android.com>
> Cc: Christian Brauner <christian@brauner.io>
> Cc: Carlos Llamas <cmllamas@google.com>
> Cc: Alice Ryhl <aliceryhl@google.com>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: David Ahern <dsahern@kernel.org>
> Cc: netdev@vger.kernel.org
> ---
>  drivers/android/binder/page_range.rs | 19 +++----------------
>  drivers/android/binder_alloc.c       | 17 +++++------------
>  rust/kernel/mm.rs                    | 18 ++++++++++++++++++
>  3 files changed, 26 insertions(+), 28 deletions(-)
>
> diff --git a/drivers/android/binder/page_range.rs b/drivers/android/binder/page_range.rs
> index e82a5523804f..f7ad88a0d806 100644
> --- a/drivers/android/binder/page_range.rs
> +++ b/drivers/android/binder/page_range.rs
> @@ -439,22 +439,9 @@ unsafe fn use_page_slow(&self, i: usize) -> Result<()> {
>          // workqueue.
>          let mm = MmWithUser::into_mmput_async(self.mm.mmget_not_zero().ok_or(ESRCH)?);
>          {
> -            let vma_read;
> -            let mmap_read;
> -            let vma = if let Some(ret) = mm.lock_vma_under_rcu(vma_addr) {
> -                vma_read = ret;
> -                check_vma(&vma_read, self)
> -            } else {
> -                mmap_read = mm.mmap_read_lock();
> -                mmap_read
> -                    .vma_lookup(vma_addr)
> -                    .and_then(|vma| check_vma(vma, self))
> -            };
> -
> -            match vma {
> -                Some(vma) => vma.vm_insert_page(user_page_addr, &new_page)?,
> -                None => return Err(ESRCH),
> -            }
> +            let vma_read_guard = mm.vma_start_read_unlocked(vma_addr).ok_or(ESRCH)?;
> +            let vma = check_vma(&vma_read_guard, self).ok_or(ESRCH)?;
> +            vma.vm_insert_page(user_page_addr, &new_page)?;
>          }
>
>          let inner = self.lock.lock();
> diff --git a/drivers/android/binder_alloc.c b/drivers/android/binder_alloc.c
> index 84104ba04e30..519dcded19b2 100644
> --- a/drivers/android/binder_alloc.c
> +++ b/drivers/android/binder_alloc.c
> @@ -259,21 +259,14 @@ static int binder_page_insert(struct binder_alloc *alloc,
>  	struct vm_area_struct *vma;
>  	int ret = -ESRCH;
>
> -	/* attempt per-vma lock first */
> -	vma = lock_vma_under_rcu(mm, addr);
> -	if (vma) {
> -		if (binder_alloc_is_mapped(alloc))
> -			ret = vm_insert_page(vma, addr, page);
> -		vma_end_read(vma);
> +	vma = vma_start_read_unlocked(mm, addr);
> +	if (!vma)
>  		return ret;
> -	}
>
> -	/* fall back to mmap_lock */
> -	mmap_read_lock(mm);
> -	vma = vma_lookup(mm, addr);
> -	if (vma && binder_alloc_is_mapped(alloc))
> +	if (binder_alloc_is_mapped(alloc))
>  		ret = vm_insert_page(vma, addr, page);
> -	mmap_read_unlock(mm);
> +
> +	vma_end_read(vma);

Nice cleanup :)

>
>  	return ret;
>  }
> diff --git a/rust/kernel/mm.rs b/rust/kernel/mm.rs
> index 2633e704c83d..877fad68be9c 100644
> --- a/rust/kernel/mm.rs
> +++ b/rust/kernel/mm.rs
> @@ -190,6 +190,24 @@ pub fn lock_vma_under_rcu(&self, vma_addr: usize) -> Option<VmaReadGuard<'_>> {
>          }
>      }
>
> +    /// Find the VMA covering 'address' and lock it for reading. Waits for writers to finish if the
> +    /// VMA is being modified.

This seems a little inconsistent with the C version's comment, should they not be the same?

> +    #[inline]
> +    pub fn vma_start_read_unlocked(&self, vma_addr: usize) -> Option<VmaReadGuard<'_>> {
> +        // SAFETY: We may invoke `vma_start_read_unlocked` because we know this `mm` has non-zero
> +        // `mm_users`.
> +        let vma = unsafe { bindings::vma_start_read_unlocked(self.as_raw(), vma_addr) };
> +        if vma.is_null() {
> +            return None;
> +        }
> +        Some(VmaReadGuard {
> +            // SAFETY: If `vma_start_read_unlocked` returns a non-null ptr, then it points at a
> +            // valid vma. The vma is stable for as long as the vma read lock is held.
> +            vma: unsafe { VmaRef::from_raw(vma) },
> +            _nts: NotThreadSafe,
> +        })
> +    }
> +
>      /// Lock the mmap read lock.
>      #[inline]
>      pub fn mmap_read_lock(&self) -> MmapReadGuard<'_> {
> --
> 2.55.0.508.g3f0d502094-goog
>

--
Cheers, Lorenzo

