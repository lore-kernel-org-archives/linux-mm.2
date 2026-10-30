Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 443F8606A324
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 02:40:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=pIoYSvEV
Received: by kanga.kvack.org (Postfix)
	id 5B2886B05B1; Thu, 29 Oct 2026 22:40:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 563E36B05B4; Thu, 29 Oct 2026 22:40:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A0D66B05B6; Thu, 29 Oct 2026 22:40:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 23C906B05B1
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 22:40:53 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A807E140591
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 02:40:52 +0000 (UTC)
X-FDA: 85377739944.14.663695A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id CD9AE40002
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 02:40:50 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=pIoYSvEV;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793328051;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VaghlxoTkY6+PDm7BEV7DT23eF5DgKXQ6aJ5vhgJ1Yc=;
	b=F+pIIxaFli+1hn0D/4Z5RmghhZ5CLkWIPuYHaioNP6bADeOM97o6f++7Bijg1gWnSAms6o
	ryyZs3o0Ifmyl8sc/WIpYPDr+PJtE1S/cH+Vh7B9bVyF2KtyLmXHPElqfbkJNNF8Z6RO0q
	pnW/7vT8e9QfM6WdVF3XYg9sVuZrqBs=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=pIoYSvEV;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793328051;
	b=TSTXe9W8BQx9hkwX8DzjArCurP8Ynmm6/GJ1B9yh3o7xwjgkp4FJmDhF9m4TlocqiaKueE
	stZaKstPRg1tyAGQmtl91auEuW6vDgDcWRH/AfoAZPUmu8kKtrx8WzsNZrRQDQqtPHUYdm
	b9gT1gkYp6svRzT6jgAHVpo6A0RYWMU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 256FB40A9C;
	Fri, 30 Oct 2026 02:40:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD72C1F000C1;
	Fri, 30 Oct 2026 02:40:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793328049;
	bh=VaghlxoTkY6+PDm7BEV7DT23eF5DgKXQ6aJ5vhgJ1Yc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=pIoYSvEVIeOMDbQ4GehnLZvj7LFdvId11l7/cvBaxDFHOF9uXwxpzYqZ8gZbCFmAe
	 CiqdK53NTq9EHRe2o5AdD+W9XyXYSPfFM/7eJQE4FJHC0vm0UF05cP2LDYnviodZ7+
	 yPCv9v/jzHz6mALlrO2/R2m4QUdrLu5PFKY7K5BM=
Date: Thu, 29 Oct 2026 19:40:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "M. Grove" <mgrove@airmail.cc>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, Matthew Wilcox
 <willy@infradead.org>, Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] mm/filemap: queue non-exclusive folio waiters ahead of
 exclusive
Message-Id: <20261029194048.5faf664d805bff08d3001e29@linux-foundation.org>
In-Reply-To: <179296822701.680532.8543194155713536453@airmail.cc>
References: <179296822701.680532.8543194155713536453@airmail.cc>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: CD9AE40002
X-Stat-Signature: 98881ny6xje4hgs36ucon3uspss6cgt1
X-Rspam-User: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793328050-919303
X-HE-Meta: U2FsdGVkX18xbPZaF/WnX7RvXx5l6AETZgozEKCX4RwVF1yvdi3dHm7e9sNh6Bap9D490fCjJT5hJscizg/VuBb34lj6m8GsrEU/31KH/s2gZWjmGAtHrwe4SXXPijdgHIeB9BwNBtMDhjRoP4v2eLK3MSmmL5scAVabUuNiCoNP2LZ00wcQCP3FxQkEw1N2X5KeCGkF2+ni+E1SuvgAptns7+w+b3ILOcIUNoCKAXE39sCRlbLJ99HLwgSRfXwpWSmghmmMbRfLyj+fkwbL7BPZSzHGfXZi6PrITjKladUwQ0asyVYHgH/XtUJ1Y8MhJqgP4XeAr2eHJZ0NACup8Pnl+cGRcGuDzOdVp7+6j0zqcLag3ym6E8irGdzOWX6POI7HhWLxLGP+zth+aFLZ/EAoumlSOIpb6oA207WB44/PR/k4cWfSs1RT06E6bwTml0LioJzCHBW0AfvVcoTFR1h461KsXcQSMvjuKfFD/Jy/t3ZltNW2axMtg8lVg8H9sCTZA6475MrkV4Q/lQBr72E74NVXNbuJYy2/ab6nmRahHJiuR1ShuiSMV5g8rx73ic+4kG7jTRW57xQ7m6Z7qmwxB9x1Fx4P6AOz8ArR9CHcxqFCgiPfb4m5uLrDNEPpOoRXKFV7kNhxbGtDsCbGYzPflTuPKaJM8/SztWyqKpfVjy3BGBgsydjzsCTP2wa63r78IXuJ7N9BjXm48Hza3rrUxKLR4MoeBcJehd+R1DYP+C+rmonUl2CaNd77YrxDqn783OZUHbL0QRIWJWpibiAfvZrt1Fy1vG76P2kHp0reoGWMdmaqjcfDnzVaa8QPAkLT0OnFBuSEbfr0oEzytEbnzQ7yW6QA4Eb8oODK7LE9VIq/PW5bk5v19vGkZRrYertI01/of0HTIY3D2mv75ieYCacq3eV201ZCtkQt4BPLrM5X2mxstxMzd37KoDftZyz7CpVe0i4aiSAJ4Bv
 W1vThXpf
 AuY9yGx7UbKVyhWf6ZDT6WL7VsgtWTpnKlLPKoTH+14/3//MXhKbBZnwDYWWRFmgaK+gdVjY/LFMswLE6JBkB0+nLgbt00kveMKAikSarcyjG7a2Nv0tPRMUmO5zZvND6D1Pi/T/uhjTmQRrwsArLRaLWJGt9Tt/qXlh8IBxdUNTseoiFfVlapvxZcI6CkFY0XSgWYM5eCSf5nmEpXXBQVnrc66bIr/FA2xzm5fBMdpH9cFcNiIlzLPOVby0hX2/xAVW6BEvC13SfoOjEatn6ePWb+/saz5hSm5uvLRTf/nrWoETS4Y5ZFEpgVpr0d4HroPxrbpTdPhe4WGpBo66lku9+cSQxFLRIvgzAWRicTTDhd6uHHG9Lt3Lx/3GglxGjSvWBREDVEhraRIG4QkyzVdE7rfBASg6G8+xIeKa5l4wo8TY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

(cc filemap.c maintainers)

On Sun, 25 Oct 2026 22:43:47 -0000 "M. Grove" <mgrove@airmail.cc> wrote:

> A folio waiter queued behind an exclusive folio_lock() waiter on the same
> folio is skipped by folio_wake_bit()'s nr_exclusive=1 walk: a shared/DROP
> sleeper (folio_put_wait_locked from do_read_cache_folio) never receives
> WQ_FLAG_WOKEN even though its wake ran.  Readers then hang D-state in
> folio_wait_bit_common while fresh reads of the same page answer instantly,
> and the sleeper wakes only with each later lock/unlock of that address, one
> page at a time.
> 
> Same symptom as syzbot's "INFO: task hung in read_cache_folio (6)"
> (extid 9db0864859224b833108).

https://syzkaller.appspot.com/bug?extid=9db0864859224b833108

So are you saying that this patch will fix that sysbot report?

If so, a Reported-by: and its Closes: would be helpful.

Some description of *why* that sysbot hang occurred would also be
helpful.

You can do an emailed reply "#sys test" to the sysbot report.  Than
paste in the patch and it'll rerun the test for you, if it has a
reproducer.

Plese reconcile this with
https://lists.openwall.net/linux-kernel/2026/10/26/2932?utm_source=chatgpt.com

Did Josef already fix this?

> The change only reorders the enqueue side: non-exclusive waiters use wait.h's
> default head-side insert, exclusive folio_lock waiters keep the tail, so
> wake-one fairness for lockers is unchanged.  Built on mm-stable
> 183895979c44; mm/filemap.o also builds on v7.2.6.
> 
> Queue-walk instrument (read-only, counts non-exclusive entries left
> unvisited when folio_wake_bit() returns): 363 skipped waiters per 10-minute
> run before the change, 1 after the folio_wait_bit_common site, 0 after the
> softleaf_entry_wait_on_locked site as well.  Reproducer shape: threads pread
> a file while others block in folio_lock on the same pages (hole punch,
> truncate or mmap faults) under reclaim churn.  Harness, traces or configs on
> request.

Sorry, this is all quite unclear (to me, at least).  What is the actual
bug, how is it triggered and observed, etc.  

> Signed-off-by: M. Grove <mgrove@airmail.cc>
> ---
>  mm/filemap.c | 16 +++++++++++++---
>  1 file changed, 13 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/filemap.c b/mm/filemap.c
> index b74bc1e5015c..35869d19d17a 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -1293,8 +1293,18 @@ static inline int folio_wait_bit_common(struct folio *folio, int bit_nr,
>  	 */
>  	spin_lock_irq(&q->lock);
>  	folio_set_waiters(folio);
> -	if (!folio_trylock_flag(folio, bit_nr, wait))
> -		__add_wait_queue_entry_tail(q, wait);
> +	if (!folio_trylock_flag(folio, bit_nr, wait)) {
> +		/*
> +		 * A non-exclusive (shared/DROP) waiter must queue ahead of
> +		 * exclusive folio_lock waiters: the nr_exclusive=1 wake walk
> +		 * stops at the first exclusive match, so a non-exclusive
> +		 * waiter behind one is never visited and never woken.
> +		 */
> +		if (behavior == EXCLUSIVE)
> +			__add_wait_queue_entry_tail(q, wait);
> +		else
> +			__add_wait_queue(q, wait);
> +	}
>  	spin_unlock_irq(&q->lock);
>  
>  	/*
> @@ -1428,7 +1438,7 @@ void softleaf_entry_wait_on_locked(softleaf_t entry, spinlock_t *ptl)
>  	spin_lock_irq(&q->lock);
>  	folio_set_waiters(folio);
>  	if (!folio_trylock_flag(folio, PG_locked, wait))
> -		__add_wait_queue_entry_tail(q, wait);
> +		__add_wait_queue(q, wait);
>  	spin_unlock_irq(&q->lock);
>  
>  	/*
> -- 
> 2.56.0

