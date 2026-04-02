Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A14ACC6B00
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 05:33:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 93AA76B0088; Thu,  2 Apr 2026 01:32:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8EBE16B0089; Thu,  2 Apr 2026 01:32:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DA466B008A; Thu,  2 Apr 2026 01:32:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6C8F86B0088
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 01:32:59 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EB088B96BD
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 05:32:58 +0000 (UTC)
X-FDA: 84612496836.23.B5A9813
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	by imf08.hostedemail.com (Postfix) with ESMTP id 2D0E3160004
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 05:32:57 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dr8H+gES;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.215.181 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775107977;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=VRFBKSpSHKyHlG8XDr6gP3xZPR/EkJqxIz7CoY+pJCs=;
	b=QEMd3RgNpQ/jbASNtR/z1zPHgFrBuGeoufW8bcy7gU1sSk+vcYWPmHqwkaOHnPRm05xhgq
	UtwwoXdcP2JqRkw8MWwjDpxn1YfGwlTMAT6bFmD3c6I6U3kK50lF/b6YniB7TJ80dz1rsE
	wWP0u+nCBUnCtExWPuXI1Ao/h0GnCcY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775107977; a=rsa-sha256;
	cv=none;
	b=FuWsnTrxE7K6C/DWnc+8RkvS/5HPrOx3UdjTUG7jf2Dmek2vcGXIZ47iARpAPdiiyhs+BR
	56UX87L/rCRnzrLxHaKuUTLKO/tN5cIQlYnu20Bfx2/eVvDPJXL61w7JcZE5dof29XLMUl
	n5unJ/TwJtL+LYjcP29lMGzA4XnnHxg=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dr8H+gES;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.215.181 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-c76c60c7502so278680a12.0
        for <linux-mm@kvack.org>; Wed, 01 Apr 2026 22:32:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775107976; x=1775712776; darn=kvack.org;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=VRFBKSpSHKyHlG8XDr6gP3xZPR/EkJqxIz7CoY+pJCs=;
        b=dr8H+gESqSPuWrXUjBnI0zfogPEsTkXZRmj6jJTRYbMmbl2e/yJVSwR4nDbLyHC+kP
         WMjz3lREkfWUmkUuTXhI6AVBubsQX3F5ArazvT7d5InCTubvkJyUa7pDOyAPU2MLazzq
         nku8WOhv23biQAkmqk3i5cWqqq9ANnTllqilL4pn1BpKiwusamh3VETSpu19BzzYpEDg
         2CqwHqN+tbhMuwYbRWUZa2BG+eLrVGRZsN5nuVhUR3/zKEUv4Sy0MZkR1P+Zsltc90HR
         WrEvDqQiRTqp6g2vWL1jgX3EwP2EyUoHsiRKPbvwXX5ubk9uhSv4Z4peoW0P6T3nO5oL
         txFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775107976; x=1775712776;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VRFBKSpSHKyHlG8XDr6gP3xZPR/EkJqxIz7CoY+pJCs=;
        b=J0+1xNbnSXck35SpOJ5jILNvEvUgZd9DaId3cEcyFNEA05+4dtV56KdoYXdCK8KiVH
         H4qiMDvADERCoINoTqDAVWj0R8d7Wun142V0VV37km+RnzdZNU8u5Jnzszdk6t4Xynsn
         3+mMZZjdXBDNeJ2XYE7Tli3Y3kQni9Yv4uvFxU8m8y1cGuNjIyuJWkg3Zjd6PMq3NhRa
         2ex7Ij7+pa2PK7nW64uYF8ZXU/7IJo4CxDmWFU95V7FfbC9+jXjsPS0V7871Jcl2c82m
         uWNt8pyh8UroDjc3XQZQAmNwWpwjrRJfYyMUb/ViOZI4HUtNt+mDI0NWjKMk2HhT4ckm
         TlQA==
X-Forwarded-Encrypted: i=1; AJvYcCVAOW59kvhuUUf+5K3toXJWAFYVoVz9A/x3rc4KaalZ2lzHzyOoUv/ZTzcZbIG8Jz6/bY4Vgwza0A==@kvack.org
X-Gm-Message-State: AOJu0YzV54o+deCn2igRyFgQkxRMQ/4FVSPJ1efIwfiWZCiRFIVwrwar
	PQeHP8R0jcXncg0ey5wef3+i6GaoRghjaB9r8x33HLTg0Bzi8M+F1ao0
X-Gm-Gg: ATEYQzzxEsw//Q7AtprhKJcqrzgzAbeYADKTINFzn4PJ2VWxsqJE8SwAG/0xPUhkwU3
	H9bd7SDydLldiVP163AtjfooxWDGbq50uzEgB4LvCuMuTBvRe41sXRu3Eweei0YdMGG3TUu2fFZ
	lU/7ZPBOnoLpiXoOz6Ckn4w96AiRVll4hb2bOZYi5Ro31HpthFops8J7QVsexr+ffksWSkfaoIA
	n6j+HQmDePC2nikpTi3W7mVkFmbWGeSe5X4JnEHdTfMLt8U5JAdt6Bbyd2XIfa1kPisIW1eDh6J
	8F3UaggMGqNAR4k+oiKw6/i3nJjbuvXv9ZliyrdQlwyYjsJRPdq5gqRTENd6No4ONNLcSHMalgj
	04KVGMFWJ33WyADmALMseF1QYWDgPFWN++cUZ1887+dH3vT5yWEhWGgNFuA5JImjZ8zATX1RkK1
	nDKVF4Px4Q05TQDrRP6hx4hl9ObJasJkNU
X-Received: by 2002:a05:6a20:914d:b0:39b:84c9:3861 with SMTP id adf61e73a8af0-39f16ff7c5cmr1220958637.14.1775107974173;
        Wed, 01 Apr 2026 22:32:54 -0700 (PDT)
Received: from pve-server ([49.205.216.49])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82cf9b3e169sm1745312b3a.18.2026.04.01.22.32.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Apr 2026 22:32:53 -0700 (PDT)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: Jeff Layton <jlayton@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Mike Snitzer <msnitzer@kernel.org>, Chuck Lever <chuck.lever@oracle.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-mm@kvack.org, Jeff Layton <jlayton@kernel.org>
Subject: Re: [PATCH 1/4] mm: fix IOCB_DONTCACHE write performance with rate-limited writeback
In-Reply-To: <20260401-dontcache-v1-1-1f5746fab47a@kernel.org>
Date: Thu, 02 Apr 2026 10:13:42 +0530
Message-ID: <ikaam0ox.ritesh.list@gmail.com>
References: <20260401-dontcache-v1-0-1f5746fab47a@kernel.org> <20260401-dontcache-v1-1-1f5746fab47a@kernel.org>
X-Rspamd-Queue-Id: 2D0E3160004
X-Stat-Signature: oa6tykd1n7ek73ccpygtpcbxtctd5efa
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775107977-23249
X-HE-Meta: U2FsdGVkX1/Zu7yBphU58f/XqtKNZvZMa8FhLm9f+p+YHzja5ucS4gvwmwcPKEGIQJgpX6wJ0Ngu9QtAJEsHHiZSWw30VToE1rbVr8bkxoYN3y7xPi51Wu8Ox2uaW0JCtNLaZYn0bPVrZE3DI7HDGXkekaMryaBPz7rNoiyXbsWf22vLc0jnDhxIj8L3nlsfZUPLcWD/uo71AGa8qTzD/qYQLEocoFeUit84RBD8AVD5JYS0EJ1kAtr+ZRVLPdOcINMRmilDD22aoSHPciQTuTOy6aUutXTtHh92+Mk6aP6NEA8wVcHHme40GMcGmB/uT52ZM5HPkrq54yPTRrnRhZxs2higWf8FgOKRGTXESKhq34F6LqYlAyOCiaXRn72iOKPlCnBw1PQBJrcxB6xKR6K78vcSipJyRCb9Bw1IomJ+F5LKIlPV9HhN/8r2lk9O5DPbqfFXrDvHjEuTLqZ5oZPY7hsXdU3IZ3nvRSQSvMAQYj3/qIcFDg+Xkz2OWPm12m3hPcRNod6DpVYzn0Qkxd0fofM5oHe5pNybV1DztBt0RuI/+mR9bZBg9+pKACCfQos3IsJE0XAIqi15UHUHnZylxb7WHRXUjLT5d23krCtQKOxBBrmu82u4dQvdmpUBr/PVmzBiLwTYL2UZqe2ls4iCFDo4MQyv3uPYmtyddIr4fIclLuY630KtcLvYW9eW3Sh9Dn4Wlh6HV7J2F8eY4HW6/nPfluwDJRGsAISZVFZXayN9609Gn/xzpBh5kukXuhjWA6jG4ocOBw33uVP1xgNXgih+FH0vbvOx22c3rQwqqUnO42k8Z73CrdUb4q49JN2LQD9tE3IppEcUaSZrwrJVAkxytziDguHN8siOGp1UDhWQ2tJaJjql/u34Furg5fvOxeiug9l3yb63zBXROKQmaNkFRJ9Jnv9fe3jWnHw6FQrsvRX19wABBZIblY3ew1eSVozLlbG/1l7SxaE
 ivD5jrPb
 ajQjR57r9H/yp63AHf8xe6qzKGptAhrvyYgQW8sDFRy1y3l1jTdGIQ40O/RzTK9S6VEuCHh+jZVRle8nCVhDTM746sb5uwhs6UqmJj3vKjkt+DBrKV2YWYRe+WWSJQT63KH6pf6P9Zgk/U4KKghhHXs9+oaXSwOobya3vMY0+p4UpHg8HHw5jjM+a0dzlRVT6JtM76a3z2tjAhREKM/vJPASrAuaeAFqrl36ZVUHUGBwA2DRhphpvOaM4NE9llczV/OlZIWhdkNJHi9mSX+iS1fahxOF47YRQ5Byb1b6KTff/LWFUcvtbngTKVpc4M/KsDOii4dm1vHc2l+CSCT9qcJJPBtvPoEG8qk7wohvu23vRVgZ5WRfgEnH6Hi3GN8+NBcC0ukfum9BNadqsVphMeOsQWnNpHpKCa6aoF0SLSNCEYhuESmyVfMMDeCzWcT/n/PXYTbH4yUlwPOESTxKuul8F8Ho3nqmcphsXg9WSQzrpkq4N0Ki6eClpcEaaSbrPWyY9F4Hb6Z6KkbHdrNi7jizis3GDHjopXYtEw3xZMhqE8tc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Jeff Layton <jlayton@kernel.org> writes:

> IOCB_DONTCACHE calls filemap_flush_range() with nr_to_write=LONG_MAX
> on every write, which flushes all dirty pages in the written range.
> Under concurrent writers this creates severe serialization on the
> writeback submission path, causing throughput to collapse to ~47% of
> buffered I/O with multi-second tail latency.

Yes, between concurrent writers, I agree with the theory.


> Even single-client
> sequential writes suffer: on a 512GB file with 256GB RAM, the
> aggressive flushing triggers dirty throttling that limits throughput
> to 575 MB/s vs 1442 MB/s with rate-limited writeback.

I am not sure if this 2.5x performance penalty in a "single" sequential
writer is due to throttling logic. On giving it some thoughts, I suspect
if this is because, the submission side and the completion side both
takes the xa_lock and hence could be contending on that.

For e.g. since this patch skips doing the flush the second time, (note
that writeback is active when the same writer dirtied the page during
previous write), this allows the writer to do more work of writing data
to page cache pages, instead of waiting on the xa_lock which the
completion callback could be holding (folio_end_writeback() -> folio_end_dropbehind())

If I see Peak Dirty data from the link you shared [1] in single writer case...

Mode                    MB/s	p50 (ms)	p99 (ms)	p99.9 (ms)	Peak Dirty	Peak Cache
dontcache (unpatched)	1179	3.2	    103.3	    170.9	    14 MB	    4.7 GB
dontcache (patched)	1453	5.4	    43.8	    57.4	    36 GB	    45 GB

... this too shows that the submission side is writing more dirty pages,
then the completion side able to write it... 

I suspect this contention (between submission and completion) could more
in IOCB_DONTCACHE case, since the completion side also removes the folio
from the page cache within the same xa_lock, which is not the same with
normal buffered writes.

Maybe a perf callgraph showing the contention would be nicer thing to add
here [1] ;). 

[1]: https://markdownpastebin.com/?id=96249deb897a401ba32acbce05312dcc

>
> Replace the filemap_flush_range() call in generic_write_sync() with a
> new filemap_dontcache_writeback_range() that uses two rate-limiting
> mechanisms:
>
>   1. Skip-if-busy: check mapping_tagged(PAGECACHE_TAG_WRITEBACK)
>      before flushing.  If writeback is already in progress on the
>      mapping, skip the flush entirely.  This eliminates writeback
>      submission contention between concurrent writers.
>
>   2. Proportional cap: when flushing does occur, cap nr_to_write to
>      the number of pages just written.  This prevents any single
>      write from triggering a large flush that would starve concurrent
>      readers.
>
> Both mechanisms are necessary: skip-if-busy alone causes I/O bursts
> when the tag clears (reader p99.9 spikes 83x); proportional cap alone
> still serializes on xarray locks regardless of submission size.
>
> Pages touched under IOCB_DONTCACHE continue to be marked for eviction
> (dropbehind), so page cache usage remains bounded.  Ranges skipped by
> the busy check are eventually flushed by background writeback or by
> the next writer to find the tag clear.

Yes, but the next writer may not write the dirty pages, of the previous
writer which skipped the flush call right (even if it finds the tag
clear)? Because filemap_dontcache_writeback_range( ) passes the range
and nr_to_write that means, unless the previous writer dirtied the same
range, the new writer won't be able to write the dirty pages of the
previous writer correct? So, it is mainly only the background writeback
now, which will flush this dirty pages of the writer which skipped the
flush (unless of course a fsync/sync call is made).

But having said that, I agree, this patch series is a nice performance
improvement overall :)

>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  include/linux/fs.h |  7 +++++--
>  mm/filemap.c       | 29 +++++++++++++++++++++++++++++
>  2 files changed, 34 insertions(+), 2 deletions(-)
>
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 8b3dd145b25ec12b00ac1df17a952d9116b88047..53e9cca1b50a946a1276c49902294c3ae0ab3500 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -2610,6 +2610,8 @@ extern int __must_check file_write_and_wait_range(struct file *file,
>  						loff_t start, loff_t end);
>  int filemap_flush_range(struct address_space *mapping, loff_t start,
>  		loff_t end);
> +int filemap_dontcache_writeback_range(struct address_space *mapping,
> +		loff_t start, loff_t end, ssize_t nr_written);
>  
>  static inline int file_write_and_wait(struct file *file)
>  {
> @@ -2645,8 +2647,9 @@ static inline ssize_t generic_write_sync(struct kiocb *iocb, ssize_t count)
>  	} else if (iocb->ki_flags & IOCB_DONTCACHE) {
>  		struct address_space *mapping = iocb->ki_filp->f_mapping;
>  
> -		filemap_flush_range(mapping, iocb->ki_pos - count,
> -				iocb->ki_pos - 1);
> +		filemap_dontcache_writeback_range(mapping,
> +				iocb->ki_pos - count,
> +				iocb->ki_pos - 1, count);
>  	}
>  
>  	return count;
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 406cef06b684a84a1e0c27d8267e95f32282ffdc..af2024b736bef74571cc22ab7e3cde2c8e872efe 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -437,6 +437,35 @@ int filemap_flush_range(struct address_space *mapping, loff_t start,
>  }
>  EXPORT_SYMBOL_GPL(filemap_flush_range);
>  
> +/**
> + * filemap_dontcache_writeback_range - rate-limited writeback for dontcache I/O
> + * @mapping:	target address_space
> + * @start:	byte offset to start writeback
> + * @end:	last byte offset (inclusive) for writeback
> + * @nr_written:	number of bytes just written by the caller
> + *
> + * Rate-limited writeback for IOCB_DONTCACHE writes.  Skips the flush
> + * entirely if writeback is already in progress on the mapping (skip-if-busy),
> + * and when flushing, caps nr_to_write to the number of pages just written
> + * (proportional cap).  Together these avoid writeback contention between
> + * concurrent writers and prevent I/O bursts that starve readers.
> + *
> + * Return: %0 on success, negative error code otherwise.
> + */
> +int filemap_dontcache_writeback_range(struct address_space *mapping,
> +		loff_t start, loff_t end, ssize_t nr_written)
> +{
> +	long nr;
> +
> +	if (mapping_tagged(mapping, PAGECACHE_TAG_WRITEBACK))
> +		return 0;
> +
> +	nr = (nr_written + PAGE_SIZE - 1) >> PAGE_SHIFT;
> +	return filemap_writeback(mapping, start, end, WB_SYNC_NONE, &nr,
> +			WB_REASON_BACKGROUND);

Was this rebased against some other tree? I couldn't find it in
linux-next. I think, that last argument is wrong. 

> +}
> +EXPORT_SYMBOL_GPL(filemap_dontcache_writeback_range);
> +
>  /**
>   * filemap_flush - mostly a non-blocking flush
>   * @mapping:	target address_space
>
> -- 
> 2.53.0

