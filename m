Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0EAF7606A31C
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 04:33:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=sqBi3acz
Received: by kanga.kvack.org (Postfix)
	id D6C636B00EF; Sun, 15 Nov 2026 23:33:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1D936B05B0; Sun, 15 Nov 2026 23:33:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0E7F6B05B1; Sun, 15 Nov 2026 23:33:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8A9A36B00EF
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 23:33:33 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 019081605D9
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 04:33:32 +0000 (UTC)
X-FDA: 85439713506.01.3FEE0E7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 2C29620002
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 04:33:31 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=sqBi3acz;
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794803611;
	b=FuoTlHygey+OEeFRJxHviBgxa5uttPlmJKh74vV0DGVybYbXo4kNKHu3N4Z2rLAmIePrb6
	JRxEHD9up6Q8sfj5Zp2LvmkAYYfbqt/gpxdtwSdnpLWMipgsQBc7pW/6PrD2BdV4xDCgap
	1LW+gTSsgxC3uvoNOGwqysQlyM7FNpA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=sqBi3acz;
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794803611;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z3LalrofPDIIeLTWNYB/CEjeg90a8F55VBmkKs/2tdA=;
	b=pS8lm+3RO0B56sRP7iReZxzQllsrCr2bs7oTeRBQatk2pRgdUykEKb3ev65Q+Ia2AYa5g1
	opL9skxu80l0BR6p0J0skkXkE6sI79Te9tR0FjeygoqpNKQmUI8lz+MqamMH6lXtRBKS5K
	HQz7Nmr5LqDIc3CQZC6D3cYO5bFCuuI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5C35E408D6;
	Mon, 16 Nov 2026 04:33:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B2781F000C4;
	Mon, 16 Nov 2026 04:33:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794803609;
	bh=Z3LalrofPDIIeLTWNYB/CEjeg90a8F55VBmkKs/2tdA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=sqBi3aczOohYNZ2MSlWIKayDu5xpw0W3F7wwOlDpL2OK0VT5465nvxRWt3IMBF9Pw
	 7j+GMTaBKKub8rE8LhwYRwuwrJ8BlH7UbNjNgkzn8D1MNRpGAjV93+RHJ69Na3BK+1
	 89PJisfvxODwTNxETHKr/w/nSp/ksk9oTaVyf6EQ=
Date: Sun, 15 Nov 2026 20:33:28 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Qiliang Yuan <odys.yuan@gmail.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara
 <jack@suse.cz>, Joanne Koong <joannelkoong@gmail.com>,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/readahead: look two windows ahead for the hole on a
 marker hit
Message-Id: <20261115203328.f98ce9a068849c2f2fb32a41@linux-foundation.org>
In-Reply-To: <20261022-bug-mm-readahead-async-overtaken-v1-1-c05b8d8bd2da@gmail.com>
References: <20261022-bug-mm-readahead-async-overtaken-v1-1-c05b8d8bd2da@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: odpzwbx8u6ckq9eurd5ja5qw47y596hx
X-Rspamd-Queue-Id: 2C29620002
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794803611-114558
X-HE-Meta: U2FsdGVkX1+0PoFvcEJ6jJrwVSAkVK0psHiPbRHmJCZkC9T9DQP0jGcszxz76reSmNPQH8p92WRVrjzJeeU/5f3/OSxAgC/tuvtw8vewHX9wkvmtkAYcmxL1H2wZJH75X5aGDMy8JfFIyBP+qiaSB+D3GfOImNEreIgU/GtuU953hIvryNmTxUPookaX/QQF5sx3KfNMQHAnKtVQVvBENh6S3b/tGWmLh/IsYugB/7tMrw7QIIj80PyPKCME048r/RjOs9RtB2bzionwUNLldz5+YpGjqwdFbe49zoKH2wosnKX5AANVu8h/BL+DZbTMHvegTqurZNli3Veze/jI5QEJa23ISANYSGfrES8Vh6ZPNz2B0EbG/Tx1Pt3DnAWc56168LNbfk+ej7JtxWywIblM8LxC1l6Nq1qLQglJpowvc4jxVxQ/cl6gBLBwLtyb0BPg/fUQMjKRnXdCJcpJwzKKK8Xc7E0W+0oogCRRULxbug9Smbcid0dk8KME5RlSGxvGld4inTrvACkOQMAoMx4vGmR4wfgo+fp6Jwj/gmdrmGp6tqprCAjceb589fbHi8bT1uVsHbxXK7Xtu1ju8+QvC9AN0q0aoC3LCMFhHDqly+YFAJP9YLid/lZ2FLfI9721v2Ao/CDT2dGySMLGHPsagLw5gTuwqfe2+J9FG53YIbaLjFL+qaxTZlg8u4l/V8pw0cSLc0vsdsRZdS2VruMgbLMW3B5eIibFJvBZYsCWfnC5QRlCTIeKyHfxVcLQjjbAD7oqx0pUHUprMBKv0h4Go42AqjCwVTlR/VzfnCl0z/zFiFKDt8tjSq/PmV3PqyZbT0vYSvbiLWFnefQR1t+umkqldabbRE4jTx/GEBbPHXhY4dbguGmaWUWrIubDhYePD9Wzj0NFO9DqZuYg52w6+PhZLeCZA8F/lsLV7Iurzf3JMi1WOnjeaGwWXzk5H+QbgpJKhliG2UuxY/Q
 TgWyUSDP
 9HEyKyBmhJzNf4gr/vDMpFKGfpzb3Gy6++Agm+Antx7Vax6Tv12OWYT+Qq0E5h/nkFP6q34gt0yQebDWi3zQ312Y8XCEaesJKse/0fqhooEkhnDYmaOeygC4gxrc8fXRvjGFDtBTxCuPijPpzAbptTMBkNGWtitRtS4UBZjDRi8x96T3R6hj3YKOB/PXaesknvbj+uCpPY6Vq3t01LTFWbDsttxABPHHxEEUk2KEsE9idnKpIC+cwHTuFVtMs7EUDOcqbPZ3aMMMG3fYeqwksiG8/6Ok3IPB8xnO0D4qfz812tC/nVlv1utpMIWs0Gdy9VDXDHHwstP5DWf2EQyXAucBvkjMasTgXUR+HRmps3X+ID5AEdB2bgk03y3o9EmUWDKr8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, 22 Oct 2026 23:24:33 +0800 Qiliang Yuan <odys.yuan@gmail.com> wrote:

> When a reader hits a folio marked for readahead that the readahead
> state does not expect, page_cache_async_ra() starts the next readahead
> at the first hole within one window after the folio. If that window is
> fully cached, it reads nothing.
> 
> memcpy() in glibc loads the end of a large source before copying it
> forward, so a loader that copies a file mapping out in pieces of a few
> megabytes faults at the end of each piece first. mmap read-around then
> reads a window centered on that fault, which reaches more than one
> window past the readahead marker the copy has yet to hit. When the copy
> reaches the marker, there is no hole within a window, no readahead is
> issued, and the next piece faults on its end again. Every piece then
> gets a synchronous read-around of order-0 folios, and threads copying
> parts of one file also contend on the i_pages lock to insert them. A
> copy from offset 0 avoids this as its first read-around is clamped to
> the start of the file.
> 
> Look up to two windows ahead for the hole, which reaches past such a
> read-around, so the reader keeps an asynchronous window and its folio
> order keeps ramping up.
> 
> Copying a 16 GiB file out of a private mapping with memcpy() in 8 MiB
> pieces, read_ahead_kb 8192, cold page cache, 32 vCPU VM, mean of two
> runs:
> 
>                                   before    after
>   1 thread from offset 2 GiB     7.62 s    2.00 s
>   8 threads, one range each      3.26 s    1.08 s
>   32 threads, one range each     4.05 s    1.34 s
> 
> Random touches read the same amount, and pread() copies and copies that
> interleave 7 MiB chunks across threads take the same time within
> run-to-run noise.

OK, thanks, nice numbers but there are complications.

Readahead is all about contiguously batching physical IO.  So it
matters whether the device is SSD, NVME, spinning FeO2, SATA, IDE, etc.

And you have QEMU in the way, so reads can get served from host
pagecache (depends on QEMU setup), which also matters.

So I just don't know what to conclude from your numbers.  I *suspect*
the gains are from reduced CPU & memory-access times which is of course
good.  But was there any actual physical device access involved?  This
would probably make the before-and-after numbers even more impressive!


I tested the patch on my LLM-driven test setup, which is similar to
yours.  The results are...  ambivalent.  The things which you want
faster are indeed faster, but other things slowed down (wall of words
appended).

The slowdowns happened because the present code misses the gap beyond
mmap read-around, so each 8 MiB memcpy hunk can need another
synchronous read.  The post-patch code finds that gap and keeps
readahead going.  I measured both costs: a full second window added
about 8 us to the access, while a gap there caused 512 MiB of unused
reads across 64 accesses.


: I tested the patch against the unpatched kernel with matching
: configurations. Both booted a 32-vCPU, two-node, 24 GiB VM. The test
: used a fully written 16 GiB ext4 file on the same raw scratch disk,
: with guest read_ahead_kb set to 8192.
: 
: I ran the author's private-mmap test, copying the file with memcpy()
: in 8 MiB pieces. Before each timed run, the previous process had
: exited, I dropped the guest file cache, and mincore() confirmed that
: none of the tested file pages were resident. Medians of three runs:
: 
:                          unpatched    patched
:   1 reader, from 2 GiB      6.87 s      2.12 s
:   8 readers                 2.18 s      0.70 s
:   32 readers                1.98 s      0.76 s
: 
: Every paired run improved. Buffered pread() and 7 MiB interleaved
: copies changed little. A shuffled mmap copy was about 1.3 times
: faster with the patch in two paired runs.
: 
: I also tested the cost of looking farther ahead. The kernel marks a
: cached page so that accessing it can start the next readahead. I
: timed the test process accessing that page at 64 separate locations.
: When both upcoming 8 MiB windows were already cached, the median
: access time rose from 20 to 28 microseconds. When the first window
: was cached and the second was empty, the patch read about 512 MiB
: across those locations that the test deliberately never used. The
: median access time rose from 17 to 470 microseconds.
: 
: A memory-limited run had more memory-limit events with the patch,
: but did not establish a repeatable slowdown for a competing reader.
: 
: The guest file cache was cold, but QEMU's host cache was warm; host
: NVMe read sectors did not increase during the main runs. These
: measurements show the effect on guest readahead, not cold-drive
: throughput.


