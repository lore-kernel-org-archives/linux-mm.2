Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7194CE937E3
	for <linux-mm@archiver.kernel.org>; Sun, 12 Apr 2026 11:49:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4DF3D6B0089; Sun, 12 Apr 2026 07:48:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 48F956B008A; Sun, 12 Apr 2026 07:48:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37EF36B0092; Sun, 12 Apr 2026 07:48:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 275DB6B0089
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 07:48:59 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BD26E1B918C
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 11:48:58 +0000 (UTC)
X-FDA: 84649732356.25.BA0EAC4
Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	by imf27.hostedemail.com (Postfix) with ESMTP id EADE840002
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 11:48:56 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nvugoXYN;
	spf=pass (imf27.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.222.175 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nvugoXYN;
	spf=pass (imf27.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.222.175 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775994537; a=rsa-sha256;
	cv=none;
	b=kgQSEmomhAjRNRrcWcJWWUhaKh/JqWxVyoeF2vQDXnl9K9ncvyyRubXmif0hn5DLim8qUS
	f1UFU7fSG8Jw3gQfLcaOCvskGcD+itqDc2yduJt548KJJtlbsjKL02fveFJRfjoiMovJUQ
	EtsMdVoLMdXCjLC4mWHGVhMTBAMEow0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775994537;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZK+9H0h/ffIWkub4XEdg6OwjOH1xxZYH9X5x/fllBLE=;
	b=hUsG+6z4RTCU2Zj4Uhg1eeMZOCIsyOulCWv/te4nb70TDER0xWv9F/Gcs7GCrC/XbOIpC3
	cbosG+fOMqDElA4EB4UoGOrNoN/YAz8Odym8Yb7sA/fQd/V1d4/bWfojk2r2OAzR8JYj3W
	rN4ro0mU90BBGZ7n7YdW05BCztpMJes=
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-8cfbfdabf3fso301151885a.3
        for <linux-mm@kvack.org>; Sun, 12 Apr 2026 04:48:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775994536; x=1776599336; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ZK+9H0h/ffIWkub4XEdg6OwjOH1xxZYH9X5x/fllBLE=;
        b=nvugoXYNS+8aJ1yRi/4ejUGeloJoV85F+Fp2ol5eRP9VrF+kjLiC7MmXPRtzZuSjFS
         yKT4MKhKVMYkEd3GjxjEsGpYYcY7jQC0ghvJ3BtrXa7Mt71zXfsIEiuXobj5AVS9xjio
         pOkdu94h90RxqyafhLyY+bGUVtBS/drrMdm3KmC7S1UnpgxH83s8aioMIxHNLcdt/fGV
         lKwnCLr4NcBI421L0xW2uVaIXtFo/KvSVUCdB+vuHc5WCqM8Cr/xGHvJUDzbhc3ejh0g
         36F3zKooYoGMFeUTDCOdH5+BLr/9I0TNDIRdi7Ydy1Y9YteSrR9L1pssDg63SWQGaC+A
         Q8fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775994536; x=1776599336;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZK+9H0h/ffIWkub4XEdg6OwjOH1xxZYH9X5x/fllBLE=;
        b=jS0MpNDTv7ahd6ynKU3fBTsWAIhiOmXedt3RMY9Dse3aHWbJfQf2O2pxgKLUL9HG3h
         VpfChfkNzLj7ARDKLLyHPNAOY8Ztne0r1o9mtJG0rcvh/b0qMOEUQia6yDM1KcMM5yoX
         wsTo1tZHiJMAPd/RWgpg2yYNSGCGQKDOzu2UFybnEIsvdlaYQlLSRhEK+CewV5HOgG6T
         UV7LLXy+PXw2weXAmGuMvap8JUIG5niKR56w3s1EHf1ItJkFNpmiMq7sfDf2URFlABJz
         Wg2UQI3m31/qN3Sjt3UqlbeCDYKoVEWlQC774Os64Lhipqf6j9kblIyK14ziVsEfbASf
         ACuA==
X-Forwarded-Encrypted: i=1; AJvYcCX68tyjdwOZWdIsP2C28WVfq+JzcdorR91JBTgHLKea4E97rTDYdCOVLFE+D3gqzxKTDEK5HY1YOQ==@kvack.org
X-Gm-Message-State: AOJu0YyvSb/TAzllufFxmS96MzhaURYxy4AzxYOPYjIw6h6IO2TQt0Pc
	2bMUUgvu/P1YJi4cNB6vTUbOHPL+eCxLSAGttGRaqGPWlmmbPW+8aAoR
X-Gm-Gg: AeBDievU0HOcHMOfapXLpMuUMhVIw6yKJpYmcQqSPZOJp0vuBZRW4dbqfA0Hl9rZc+5
	zfXYNM6r266LOZraGdamo6HHDOTXQQ0SrFDND2c/Cqus9+PBDXp88Kl7yxlvjxUJ6JnkOSfreCZ
	AN8vYo9l7hCEW2ZWTEdyBKT1ElH4KA7qgF75uuMhbj4eWOpp/xEP5qMu41aVC0GgMrwtQaEFplU
	12Si2WzNXdCjQ9C2U8n4/ABoBaCL4p8RsWPLNqdECImGAOqkeHK6z4JZ+/VptmLZb5IyKei/sNJ
	d5Tzd1ns3nDlX7X5c5H03hJgg3pyYGHpAniAQflxg/Oeogmh9c+oSqGPjkhnR0ZF0gkF1Zc6rIp
	SIJf5pkh+ELVYF62zSLy1AGOkM0fQg8v7Zq3uRPS5Owi/jwymoaSuWQiUmLP2uFzFb/ATKzZiM+
	FG0ER3M7BTbcJrP92RNQ5eTWbCzcml7g11tYFI3x6xx8EM36cJxRtOUhT8yB0=
X-Received: by 2002:a05:620a:1990:b0:8cb:baea:89cd with SMTP id af79cd13be357-8ddccb294ffmr1411096585a.8.1775994535808;
        Sun, 12 Apr 2026 04:48:55 -0700 (PDT)
Received: from KASONG-MC4 ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8ddb66587e4sm647529685a.19.2026.04.12.04.48.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Apr 2026 04:48:55 -0700 (PDT)
Date: Sun, 12 Apr 2026 19:48:48 +0800
From: Kairui Song <ryncsn@gmail.com>
To: "Barry Song (Xiaomi)" <baohua@kernel.org>
Cc: minchan@kernel.org, senozhatsky@chromium.org, 
	akpm@linux-foundation.org, linux-mm@kvack.org, axboe@kernel.dk, linux-block@vger.kernel.org, 
	linux-kernel@vger.kernel.org, kasong@tencent.com, chrisl@kernel.org, justinjiang@vivo.com, 
	liulei.rjpt@vivo.com, Xueyuan Chen <xueyuan.chen21@gmail.com>
Subject: Re: [RFC PATCH] zram: support asynchronous GC for lazy slot freeing
Message-ID: <adt3Q_SRToF6fb3W@KASONG-MC4>
References: <20260412060450.15813-1-baohua@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260412060450.15813-1-baohua@kernel.org>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: EADE840002
X-Stat-Signature: j3s8ngc5zu3xcid6eipp1u6j8gxqm4wn
X-Rspam-User: 
X-HE-Tag: 1775994536-164108
X-HE-Meta: U2FsdGVkX18+o1tSffTABdVzaxDQrhdUZh/6TLNEn5AGK/a9NIvMWnlVYb38LjNIC/DgBlnFGSiZKdF1M1GQeqc6rwYB2t16RrISSX9fj22dPYSri1Rc9Aojit8YJKSeVOSQzRyl8Apb3EmBk+kxdXul75/7WvdPyL2tSaotz4vbrmXljYuDMR8BpNAz1vWQWs5QC6P9tB1BwGEk07pCKdeP0a+RlfW7l0GCmSRHlA6BLAZljQ3X8dIk0SbzZXe8BWPN9MfsdgLk1qfCc2WNzX2F8d6zuKcAB1xIcPQy4VR3ctsw+c62iPXKpPxd0R4hI0g6oLKjSAvAH10G3P9P7w8/EcbQJIYpp1mEPBa5oaJnb8C0rQdp4LIAtC1VeniBU6AsWN6hoHG44TFPT5MHeHVbGMO4VgosGvvOWCG2OAZC5V0xuJLZpOfAuVFt2OtvcTxsqho8D73HLZqMcZi07RD37D3TG0x7TMuLnEiRPte+QJJTaXIlb9Hx+TjBDug8OmOEtB/YoGpqgiP5mbXeGjDOAx/ZpimQbrmfTncSClfXPPYyi0bOUStvVBH/GVp701XBOUtOcIka+PcVQwFRBFBEKSIwWPiq75zUzB+CY7VKWjxSxFfO/d4+PwJbdbN9eYIA383+fquzOYEjIDPgRiAer00FuYJ8r+JDIYgcuisIO+AZtebRaoxxd0oWWTutjXecnYsajXs03HYGksgjCDFasmKXArqz4Zi/uFp7eUvVQ4OgF4WV4ii6+kdBSTD9OgPunr5IH0ZJ+V6VwOfLMnVOj+uYmwDLghH+Dox5tbWpeiK2xuAWVQQVZ5LAKLho1XBZ26bOqR7EkAbqr5ZHge61+9yEoR8feXoXO4C6Q/qK0xHrpyJLD7EL14QwO35MlEnwKqme7TOJiheB0IXVyhH/SG+u0YUeOklgM+ECFlLslGtz/7W6zVWOh3g8z1pCoc+MgPXYjfLahq2hkcS
 ZuAPqnCw
 F+YYqWZ8eep2x1cZWnYWYOl9SPHZS9+35GlTvGWl12Sfpc5jvA2EPUoV4+UCXR7HsMl3H5J6DWtSzdie6QTKaovOpqBorM9efdYv9CvuwCKp8upi3jwQVA/QX2f2JKJJ5e3cKSb+2b5/ncB4U6nFDmjyATKufY6/ceomybGz7ECsnAmrNMSoHkYBsgSb77uzqApMqO873xVsRAisH7lJu+QX+zU68CGOddHfrgyhKNnYQ8m8v10TgmFiVXb7DcxntDVMHwpv4PYkcT7sgMVpm2kYSk1yGZ0JSwfrNYa5qGr5fBa0QAmRN5XIDi+NxDJB7ibi6IB6PblpXVT2+aGR4rLCtT2th6JGR29Jyroyx6OxVdsR2LzZmcf2rqUrangPuWRxDGJGc6nTXsYpZ+mc8ppq76QeGU8mMtDSIZ4BN8U8IiuPkyvkjVqhX4PzH/txYxHQeFoaeD4byOAJ4ceaxg6kCCVEmH3FwrPq/98xZH+iZsikTbv8Gd4iIYEzx31bvo6ac6Vwjha2aT7bQuLnAIfAsGfoiXUJuksbjFN+Y0iGWrRx+q+2fYP8r87/zg9BQTZY/OH5c8070lYUmo3LOfZnpn/C1o6ADOcek
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Apr 12, 2026 at 02:04:50PM +0800, Barry Song (Xiaomi) wrote:
> Swap freeing can be expensive when unmapping a VMA containing
> many swap entries. This has been reported to significantly
> delay memory reclamation during Android’s low-memory killing,
> especially when multiple processes are terminated to free
> memory, with slot_free() accounting for more than 80% of
> the total cost of freeing swap entries.
> 
> Two earlier attempts by Lei and Zhiguo added a new thread in the mm core
> to asynchronously collect and free swap entries [1][2], but the
> design itself is fairly complex.
> 
> When anon folios and swap entries are mixed within a
> process, reclaiming anon folios from killed processes
> helps return memory to the system as quickly as possible,
> so that newly launched applications can satisfy their
> memory demands. It is not ideal for swap freeing to block
> anon folio freeing. On the other hand, swap freeing can
> still return memory to the system, although at a slower
> rate due to memory compression.
> 
> Therefore, in zram, we introduce a GC worker to allow anon
> folio freeing and slot_free to run in parallel, since
> slot_free is performed asynchronously, maximizing the rate at
> which memory is returned to the system.
> 
> Xueyuan’s test on RK3588 shows that unmapping a 256MB swap-filled
> VMA becomes 3.4× faster when pinning tasks to CPU2, reducing the
> execution time from 63,102,982 ns to 18,570,726 ns.
> 
> A positive side effect is that async GC also slightly improves
> do_swap_page() performance, as it no longer has to wait for
> slot_free() to complete.
> 
> Xueyuan’s test shows that swapping in 256MB of data (each page
> filled with repeating patterns such as “1024 one”, “1024 two”,
> “1024 three”, and “1024 four”) reduces execution time from
> 1,358,133,886 ns to 1,104,315,986 ns, achieving a 1.22× speedup.
> 
> [1] https://lore.kernel.org/all/20240805153639.1057-1-justinjiang@vivo.com/
> [2] https://lore.kernel.org/all/20250909065349.574894-1-liulei.rjpt@vivo.com/
> 
> Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>

Hi Barry

This looks an interesting idea to me.

> ---
>  drivers/block/zram/zram_drv.c | 56 ++++++++++++++++++++++++++++++++++-
>  drivers/block/zram/zram_drv.h |  3 ++
>  2 files changed, 58 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
> index c2afd1c34f4a..f5c07eb997a8 100644
> --- a/drivers/block/zram/zram_drv.c
> +++ b/drivers/block/zram/zram_drv.c
> @@ -1958,6 +1958,23 @@ static ssize_t debug_stat_show(struct device *dev,
>  	return ret;
>  }
>  
> +static void gc_slots_free(struct zram *zram)
> +{
> +	size_t num_pages = zram->disksize >> PAGE_SHIFT;
> +	unsigned long index;
> +
> +	index = find_next_bit(zram->gc_map, num_pages, 0);
> +	while (index < num_pages) {
> +		if (slot_trylock(zram, index)) {
> +			if (test_bit(index, zram->gc_map))
> +				slot_free(zram, index);
> +			slot_unlock(zram, index);
> +			cond_resched();
> +		}
> +		index = find_next_bit(zram->gc_map, num_pages, index + 1);
> +	}
> +}
> +

The ideas looks interesting but the implementation looks not that
optimal to me. find_next_bit does a O(n) looks up for every gc call
looks really expensive if the pending slot is at tail.

Perhaps a percpu stack can be used, something like the folio batch?

> -	slot_free(zram, index);
> +	if (!try_slot_lazy_free(zram, index))
> +		slot_free(zram, index);

What is making this slot_free so costly? zs_free?

>  	slot_unlock(zram, index);
>  }
>  
> diff --git a/drivers/block/zram/zram_drv.h b/drivers/block/zram/zram_drv.h
> index 08d1774c15db..1f3ffd79fcb1 100644
> --- a/drivers/block/zram/zram_drv.h
> +++ b/drivers/block/zram/zram_drv.h
> @@ -88,6 +88,7 @@ struct zram_stats {
>  	atomic64_t pages_stored;	/* no. of pages currently stored */
>  	atomic_long_t max_used_pages;	/* no. of maximum pages stored */
>  	atomic64_t miss_free;		/* no. of missed free */
> +	atomic64_t gc_slots;		/* no. of queued for lazy free by gc */

Maybe we want to track the size of content being delayed instead
of slots number? I saw there is a 30000 hard limit for that.

Perhaps it will make more sense if we have a "buffer size"
(e.g. 64M), seems more intuitive to me. e.g. the ZRAM module can occupy
at most 64M of memory, so the delayed free won't cause a significant
global pressure.

Also I think this patch is batching the memory free operations, so the
workqueue or design can also be further optimized for batching, for
example if the zs_free is the expensive part then maybe we shall just
clear the handler for the freeing slot and leave the handler in a
percpu stack, then batch free these handlers. zsmalloc might make
use some batch optimization based on that too, something like
kmem_cache_free_bulk but for zsmalloc?

if zs_free is not all the expensive part, I took a look at slot_free
maybe a lot of read / write of slot data can be merged.

This patch currently doesn't reduce the total amount of work, but
if above idea works, a lot of redundant operations might be be dropped,
result in better performance in every case.

Just my two cents and ideas, not sure if I got everything correct.
Looking forward for more disscussion on this :)

