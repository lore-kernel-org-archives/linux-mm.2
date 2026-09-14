Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF30AC88E64
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 10:39:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB4A96B0092; Mon, 14 Sep 2026 06:39:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8B1E6B0093; Mon, 14 Sep 2026 06:39:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97C976B0095; Mon, 14 Sep 2026 06:39:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 648196B0092
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 06:39:07 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E5DE5C020A
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 10:39:06 +0000 (UTC)
X-FDA: 85212020292.16.3AABBBC
Received: from flow-a3-smtp.messagingengine.com (flow-a3-smtp.messagingengine.com [103.168.172.138])
	by imf08.hostedemail.com (Postfix) with ESMTP id EEA21160003
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 10:39:04 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="Y ppxdr+";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=kQbg7u48;
	spf=pass (imf08.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.138 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789382345;
	b=scga6rmpR58DVBCsvdj6vL+lRKOZ4amxhvBW7WHrigNTOdszCmtHiXI/yjs1f6xykCJRXZ
	MsU2MB5+sH+m+8oamf4llFhKhUh+hM8NIdEis2dzSnucd2n6iYozbFDZBtgy6tS4k9zZb2
	2z5o1s6nih5WshQS+fV9S1zpJJJvcj0=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="Y ppxdr+";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=kQbg7u48;
	spf=pass (imf08.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.138 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789382345;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vydnH135QpbJgGMFtNUv3g8AnqjoSBdujNdUzisGZV8=;
	b=P/m2WZ3chFZc0EYpl/BdF7n425cItW9Wnu1MOSFfGnb1hRkK5/eOKA6gu2n2yyj4Y+SsA8
	vbOXXFdP2SgbjYCsXxO9eKelAkt7AQyjdLT0J9gRxX9fNyWl1kXDT6ENOQPPrE+1LwH8hX
	u4yKaZ9mi7hie8AK0wCfrbNdPFBzOcQ=
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailflow.phl.internal (Postfix) with ESMTP id 52D591380189;
	Mon, 14 Sep 2026 06:39:04 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Mon, 14 Sep 2026 06:39:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1789382344; x=
	1789389544; bh=vydnH135QpbJgGMFtNUv3g8AnqjoSBdujNdUzisGZV8=; b=Y
	ppxdr+9sIO3inCy2Zet2IFqjSwyGWnwvFWdKrvKchoOYmXsEW1Bv9jW0wbQCJyyg
	MqGwl15buCJVZsoxWa5ihyX+mdhDbxRsxHeBwxe/8XkdXSjY/oGAkYxxb3gKPNBv
	+ojPfFQ34viBG5WjHOntnQ3G3QfXjv3MFQz2tgwtqlWdqIlK4nbitjQ/G8rB61JL
	t+zsd4S8YPmxJWm+SWYxLp56n4Im03XG92c0Ta90CiN4b8IBNggNFPcQSvu+iTYI
	XRgaiXcogiNoDAS1o8++f9TqB97QztfM15IEC9OniB1oiHg/y/cGusMDJmj8ySkC
	NOm1uqV2831kK1RImXe7g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1789382344; x=1789389544; bh=vydnH135QpbJgGMFtNUv3g8AnqjoSBdujNd
	UzisGZV8=; b=kQbg7u48+y9tnA18y/82bF7gpzqoK1xlC0km9vFBiOhuYdzMsqQ
	wv8+Mr5pLHDcwLMVbIsx41JjGGzCiVcfH4l3DbId0VNjxbml6Uxj1TFJmkGTRSQe
	atwz2M0Sv1z8zjTveRdfFoMZvkAoTIfFtDgVl6iYP4ar2lxbx8JLLv1+eitSxJNu
	6V2xb8Lw8GLxYW9YjqB8TlmLsNyF3/LX3cUiCUMl9ccLGJSJL8k4sakUXFSjl00H
	Jpak+liWVEA5krqYPXA2wuOR2IDwiBRU/OQ8MDhvE/6eI5mR3KEEUNadLQukPNeS
	k7MroZwuK8ZL7l2z2284shSi6yyT2RFgFiA==
X-ME-Sender: <xms:xs6nagFUSJFkutUT8tTYk0_GfibJgi0JVVYc2fojXtAVRRuqp44Spw>
    <xme:xs6nany7oXjXLGzFVLY1cy_g6DLuX8PbvCEmFbBm0ablQfhVDXN5_COVsKr1SAEAw
    L0IVIXtCFUbYIxhWK78tTPMekKtm7maPs1_qa5DyGNtPJlG0mSkhmWC>
X-ME-Received: <xmr:xs6nahTDCgkwZGAyFGywYEOqDnckskH7i1CGEtWOL-M6qLxRqoBKQZKLl9w>
X-ME-Proxy-Cause: dmFkZTGiQOIHw77ggY3DlkCXQlXCz8IImeccgwXV7ZHAyBfhRJ+QMHaWjJMnXPmuSwFSAn
    aaA5a5aZytYVxDOEkRZwzAMYrUN5yu6KO5igraE5IQbw89Oae2bj7upLv2siaMdI87K+7K
    aDxg+srjkcWNkZ9mq4+mr7JSydd1Uh0l5MFl0m9dFbzE6xiBoYeP/gaZAorLEUc0gjpNPF
    BlytW0gd6Xt1q3rdYRogjsTo7RQxJ3A1K0cF0lHLusSVWg/BD95pgd2oon1ZU5OJuO8cKr
    df9ieBPv9ai4ZfUANvnOmwenyCHczi7vRcjan4EMvof1gvN7+71qzZoz0skg7ceEeYeTSW
    iC2SVG7wH2jvSAcGrCPn2En+Hlmv3l29qymMA0DgSsAoVTf4h0lc/Sa0yVEeS4LJ8CytH0
    Y2wbAKv6hmu6E1gEEE9gVc/gQUA6O7tvDvTk3FMOnpWH+LjE7CAP30Bedp3hnpdoIvJ4GT
    UmT23P4hWJity8KSB7eoRI1woG9aGqRyG4HW/vZAcMW3351XCb1VsHLDJhVLAMy4ouwc59
    xtmEXeyWItcdCDF+foURYzSbI+b4jRXxDDuRik8npdM4BVk42i/3S+ElDAJJooRS6FsYWL
    er7GgSXW0ZTervo6e39TuRcESSAUlE//A2a0wuaIxux/GX+GpZ0tN0mgRx7w
X-ME-Proxy: <xmx:xs6nalq8g2WjDv9p7btSshK2qnJXITGaDxgHiJsxUvpfkD8vjXRySw>
    <xmx:xs6napsqLGX7SzZRe_u4jzV0aMLLUE66sgel41Y5uvIR7qSxlJu59A>
    <xmx:xs6naisbmz1XkB2_lmqbQ85t8MHzLmPMrUl6Bnc8uhGbGFv1QMtIBw>
    <xmx:xs6nalrmRWX_5SXJv-luMbGbcyMuSnfWXQ9aWzaUZLSDAbV-EYJvCQ>
    <xmx:yM6nalYWcG7cpQtVdUpaBNMt7VNwiT-_mdpG0Wxb-gQOOzarMYMqOd7H>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 14 Sep 2026 06:39:01 -0400 (EDT)
Date: Mon, 14 Sep 2026 11:39:00 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Ilya Gladyshev <ilya.gladyshev@linux.dev>
Cc: akpm@linux-foundation.org, andrew+netdev@lunn.ch, apopple@nvidia.com, 
	artem.kuzin@huawei.com, baolin.wang@linux.alibaba.com, david@kernel.org, 
	Liam.Howlett@oracle.com, edumazet@google.com, harry.yoo@oracle.com, 
	hramamurthy@google.com, ivgorbunov@me.com, joshwash@google.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, lorenzo.stoakes@oracle.com, mhocko@suse.com, 
	muchun.song@linux.dev, pfalcato@suse.de, rppt@kernel.org, surenb@google.com, 
	torvalds@linuxfoundation.org, vbabka@suse.cz, willy@infradead.org, yuzhao@google.com, 
	ziy@nvidia.com
Subject: Re: [PATCH v6 3/3] mm: implement page refcount locking via dedicated
 bit
Message-ID: <aqe-sLv4L5SOHA6l@thinkstation>
References: <cover.1789239015.git.ilya.gladyshev@linux.dev>
 <ebd6540ad89a4bb80e2a62d00901b5c827315b66.1789239015.git.ilya.gladyshev@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ebd6540ad89a4bb80e2a62d00901b5c827315b66.1789239015.git.ilya.gladyshev@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: EEA21160003
X-Stat-Signature: hzbghozqfcs75un6d1c7cekbonj3jdj5
X-HE-Tag: 1789382344-779310
X-HE-Meta: U2FsdGVkX18xA9ijUiaomhfUYpiQBB3n5JYlkbwVdn5d/tAoBcMjcVFItQ9ZD53/x0l/pHKPLh9wpWinxrjUDbxiumXt0g1oHRV+SLGB4HGSB0bF7p/QgNd5A4nzfKyfuZKaBACgfJeQYutyN+WKNXGD8HXc3qlfQWb8bNC0R+4+Orig17O05BXP7TCfHuQKJfSlEX6EHRtBKAz3Y1y4/7QK7S7gaESl41RibdcoHxa0RyXracJJoEtT1Owc3g4nkS4Cxg3+pe6IU+ysVUKOEwz9Q/LAoFLN9680lJDPbQweSkDTUp/zTGA6DOwAuS57nrV71yvpexjhupzccf/AqDYxEknQKqTA8jn/g6DEmnY6putpird7c/3bpu3tMCSSkH2ktPOUOIrwq8UjZCel1ZO8c1mWejNPi0OzVAMXDXtGHg9D6mhxJsbRFpURdmVkJPZafoi1MDFOtNjaYTFerDJuA/3KEb8+CvQAgq0HaGQqOjKZ2KQsD6zwHFmanoH405IQuorem8WsBeYYUu70Iljv8tgyQH3P6WWCQhnczoetX1GlFV4cNkSgKeHd3exWGp22fa3hZiFIi5PY1u5j2UBDYflmuyN1+Jtd4qMnGtFRmBFQ9oVanbF6xNL+jL50sITSbJfq5QiU18tuGK+vYxTOQR4PJhCm8s7DToPrGO/42oOZVzNWHBP0HzBDVBTn0j3TkSHDBFI8XYKcqVYVxCRIFiPF06phVUUZLlrPPxnxxxcADxhediKau6tAghgJAxpgdKA4dn4NFhNtxRd38CshmJJ/SaEIRVJPZOSnoONI3XsQ4UMTRgElfCwtdbKeCmU/czQNIiF1cXgos0PmemmK1f0IGGDx9f3ye/DRnulhbNDcf2G2QQOxY9fy+B7nzM+WNB12wI98aT/CanhyxB1DmsZQ0PQM2TxlAwZWuREIhYXOPy3cqy6wM+qmInbYZh7gjB1ZrfJoaDXfw1d
 oOhzKWf5
 LVZA7gy9N7X67p49C6nimMH3DrzO4kOjKOwvgvsJxGBFKU4yLd4jAduiC5SZ8G2WYkNLNDNdcKftTjwXmn6JFb34QYaSd9Z4l+amgk9uX+JE9NLO0cRB+cvNBdb7yD3c3tSieQIAdLwvTmFTKrcKWn3p/N3ubAcg9fz8Zalp9dAsa6mUrmQwtPxcXrZFsQ+aOhhjIvCBecXSMp4zWAdW93+CMEpjmHJy2rGApWXqNaKH71Ik3U2P4O8tsARoKjsTs1W7B4UksgM3LrMy7XPpvB2qXd9vIaYXIWgnB6QOiL5Ebw0zh+cPVA24WR495LGo3CwaJPGxPYbj/DbmyuJSoOHwxfWDqv+xaPMhrnD+hBA0F99mTq70RgfKiZGRMkfM01qhDvP5UNEZ57mjwTH9MB0+wKdbbqmOJzYTHg2XyYXObrRCdOa9Hjan7f51quZisPLB49YihHUJZdkiASNLTEd6PvDYjZxNcJvv501FstfYITQYr6krcpjw+X1xfqYNmMHD+Y2mj2rbxWltRsRoeoMuvzPjQ9h1Je9Btc8wrZ4Vq/OUZm6lluDfZe3gs69whRwtG9MdLGbYCRixcEX1EEFvZ/aMAgS/Fs2q9NeC1e1hYm+V8n0jEL0C85iqtYBjY0LcawAc4ZtRqCxPqWgr0I577NY9kFwvCLS4jfGUr/lT7oNnNIkb0hRQ0AxjpXti9o+g3tV7Z28yAGlg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Sep 12, 2026 at 10:50:10PM +0300, Ilya Gladyshev wrote:
> The current page refcount implementation uses a single counter value
> (zero) as dead. So, to prevent incrementing a dead refcount in
> folio_try_get(), it fundamentally requires a CAS loop.
> 
> This CAS loop can act as a serialization point and can become a
> significant bottleneck during high-frequency file read operations
> [1][2].
> 
> This patch reallocates the refcount value range:
> 
> (1) refcount < 0 means dead refcount (uninit / frozen)
> (2) refcount = 0 allowed only as a temporary state (see below)
> (3) refcount > 0 is a regular reference count
> 
> In other words, refcount is now split into "dead bit" and a 31-bit
> counter.
> 
> Refcount decrement now works as follows:
> 1. Counter decrement
> 2. If it is now zero, try to put it deep inside the dead zone
>    (CAS to INT_MIN). Or you can view it as "set up frozen bit and reset
>    counter".
> 3. This CAS can fail only if someone grabbed a reference in-between --
>    that's okay, this page is their problem now.
> 
> The size of the dead zone allows performing an optimistic increment
> inside page_ref_add_unless_frozen(), replacing the previous read + CAS
> loop with a single RMW operation. This reduces cache line bouncing and
> improves scalability, especially in NUMA scenarios.
> 
> [1]: https://lore.kernel.org/all/20251017141536.577466-1-kirill@shutemov.name/
> [2]: https://lore.kernel.org/all/CAHk-=wj00-nGmXEkxY=-=Z_qP6kiGUziSFvxHJ9N-cLWry5zpA@mail.gmail.com/
> 
> Reviewed-by: Artem Kuzin <artem.kuzin@huawei.com>
> Co-developed-by: Ivan Gorbunov <ivgorbunov@me.com>
> Signed-off-by: Ivan Gorbunov <ivgorbunov@me.com>
> Signed-off-by: Ilya Gladyshev <ilya.gladyshev@linux.dev>
> Acked-by: Linus Torvalds <torvalds@linuxfoundation.org>
> ---
>  include/linux/page-flags.h | 13 +++++++++++++
>  include/linux/page_ref.h   | 30 +++++++++++++++++++++++++-----
>  2 files changed, 38 insertions(+), 5 deletions(-)
> 
> diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
> index 7a863572adce..b19721e0e7ca 100644
> --- a/include/linux/page-flags.h
> +++ b/include/linux/page-flags.h
> @@ -196,6 +196,19 @@ enum pageflags {
>  
>  #define PAGEFLAGS_MASK		((1UL << NR_PAGEFLAGS) - 1)
>  
> +/* Most significant bit in page refcount */
> +#define PAGEREF_FROZEN_BIT BIT(31)

I am not sure about the naming here. I would expect _BIT to be 31.
Maybe we should name it _MASK?

#define PAGEREF_FROZEN_BIT	31
#define PAGEREF_FROZEN_MASK	BIT(PAGEREF_FROZEN_BIT)

> +
> +/* Page reference counter can be in 3 logical states,
> + * which are described below with their value representation
> + *        state              |         value
> + * (1)  safe with  owners    |   1...INT_MAX
> + * (2)  safe with no owners  |         0
> + * (3)  frozen               |  INT_MIN....-1
> + *
> + * State (2) can only temporarily occur inside dec_and_test.
> + */
> +

Do we what to enforce your comment about (2)? VM_WARN() in
page_ref_dec(), page_ref_sub() and _return() variants?

BTW, I wounder if all these VM_WARNs makes DEBUG_VM=y kernel too slow?
Do we need a separate config option to debug refcounts?

>  #ifndef __GENERATING_BOUNDS_H
>  
>  /*
> diff --git a/include/linux/page_ref.h b/include/linux/page_ref.h
> index 82ff3a99297a..cc7a9d7db504 100644
> --- a/include/linux/page_ref.h
> +++ b/include/linux/page_ref.h
> @@ -64,7 +64,7 @@ static inline void __page_ref_unfreeze(struct page *page, int v)
>  
>  static inline bool __page_count_is_frozen(int count)
>  {
> -	return count == 0;
> +	return count & PAGEREF_FROZEN_BIT;
>  }
>  
>  static inline bool page_is_frozen(const struct page *page)
> @@ -79,7 +79,12 @@ static inline bool folio_is_frozen(const struct folio *folio)
>  
>  static inline int page_ref_count(const struct page *page)
>  {
> -	return atomic_read(&page->_refcount);
> +	int val = atomic_read(&page->_refcount);
> +
> +	if (unlikely(val & PAGEREF_FROZEN_BIT))
> +		return 0;
> +
> +	return val;

I was worried about the branch in the hot path and wanted to propose a
branchless hack -- val & ~(val >> 31) -- but compilers seem to be good
enough to generate CMOV. The hack produces one more instruction.

>  }
>  
>  /**
> @@ -150,7 +155,7 @@ static inline void init_page_count(struct page *page)
>  
>  static inline void set_page_count_frozen(struct page *page)
>  {
> -	set_page_count(page, 0);
> +	set_page_count(page, PAGEREF_FROZEN_BIT);

Are you sure we covered the cases that do frozen -> 1 transition with
page_ref_inc()?

Patch 2 switches __init_zone_device_page() to set_page_count_frozen().
Who unfreezes them?

Looking dax_fault_iter(), it seems to be done by folio_ref_inc() there
for FS_DAX case. Switching to PAGEREF_FROZEN_BIT would break it, no?

It seems some more ground work needed.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

