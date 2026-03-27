Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F44A10AB832
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 00:42:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 89FAF6B00A4; Thu, 26 Mar 2026 20:42:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 850A56B00A5; Thu, 26 Mar 2026 20:42:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7669B6B00A6; Thu, 26 Mar 2026 20:42:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6414C6B00A4
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 20:42:41 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E9E10140BA1
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 00:42:40 +0000 (UTC)
X-FDA: 84589992480.05.C7A09E6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 2F6648000F
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 00:42:39 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=uPiIgOz2;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774572159;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GLI2uhuYGxrpVgfmT8QS3P8Dfe8cDcnx4cSdQ7UOh4U=;
	b=CO0fUkLXu3SYf3onVn0o+3ziSsTGmu8uJYJ0zqHH4+XSWBi0YTUDSL1DkvpqjVEMIyK+em
	lgM+I6a+Wck9/fuW3DAjPt6+V1GzZ4BgAp8W5Hh19UF1lP/cToEmsPBuGm+YUMYyZcGZtG
	dilgGnDGs/5V6+d7nHUqflnwMP4N6ME=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774572159; a=rsa-sha256;
	cv=none;
	b=VWgWoMYOZOQ2nQQWCM0uWWSPVrN+F2zkf+pN26tTEqhrs6h5XIvrb7w+VegCRwjPM9ne2h
	u3aWJ0h06CG0lXC1aBvBfTP6H8ic7Emxc/Owimz1i5zIIMtNPMPNNxykKJn1l8Yf+tDyiu
	JKPXCr2tldM0L1oVlp39lZ0z272X2tI=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=uPiIgOz2;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 38D9942DFF;
	Fri, 27 Mar 2026 00:42:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCEE1C116C6;
	Fri, 27 Mar 2026 00:42:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774572158;
	bh=1oTRYaaDGtL88x3nFZWM19mGdEaN35XXt49N44uFQhk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=uPiIgOz2EKjU20I92IZN1kKK3Tu84i391v+qGEZo3cNDi430ZInilKOPBX+90XFFs
	 oBkIixFaIIoSXX8vHNqCMvxTlJ3Nvp2jCtp7rIchdtb+kRg3I/luit48SLiQNzgkHg
	 1WHSYOt1FSeiBXzq/CMDM/77MUwsUWFhao3FwCS8=
Date: Thu, 26 Mar 2026 17:42:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: jack@suse.cz, willy@infradead.org, miklos@szeredi.hu,
 linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v1 1/1] mm: start background writeback based on per-wb
 threshold for strictlimit BDIs
Message-Id: <20260326174237.0ad75b578219aad36f137e4b@linux-foundation.org>
In-Reply-To: <20260326234629.840938-2-joannelkoong@gmail.com>
References: <20260326234629.840938-1-joannelkoong@gmail.com>
	<20260326234629.840938-2-joannelkoong@gmail.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 2F6648000F
X-Stat-Signature: p3sfw4p5oxzy6ntp3ey31gkffi3p4y4k
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774572159-435262
X-HE-Meta: U2FsdGVkX1+U/R13qVu+mIIdqQ6WZMcn9GaJimO5K7SwJ4CBAA6nqjfsPB1xmjSRpLA992lQXBLcbfD3EP0+o4/ikKHEzTR6tlpJksfFXn+YX8N3oQAFBWrSfK4QuLnG7bmc3udI31J/cQiREz4XmtynoirU13dmzpdnv/tCoTSd9ZBrD+oz5nfnZS+WXR3HgsKy3nzDGygx2xr+FWEgwB4oSoqnN5MBbTlMAVAZPVzovH2Pa3KefjVyAwfabh3+aImJS0FMDpFB/22akQALvhuYPufmdcI+azzE3GjUf4KVs7wy1Dmf8UpQuUrsan4E+TxUoc1wvB/DZWHU7SwI6gCyznuWSY9a3BFnCUoQmTzz9HETKEOCT2SFjCPujfpvuMDBVlGSMNDN0n75S6LNlTFYxoEDFZDxz41yjNRhd214vd9aqzIroUwIdLwx0TbqWtr2Wl2qqAJf5TU/pv+LaePyID9NG2tUubJqIv8luf6aNr1XzDdavst6d4oDapmKGPmVDvOP6IZqlKrfiTUoC4QPqXu0yrRUtvTaTFUS5sXFfCs5GFGGE0FSl+2uEUX7t1st5OCHjs+9vmNgjwC24BE8ttp8elbTHegjFVVZi5ExC2Mq8nll8XTSIfWSzDapo+tsbpMFKA7VCcO8noP2p4X2LnGTm/xpg/MT5VpFgOdC7iiTT2Vzpx1n6+kSGkWUGpnioZtjKRQZYEy2L8Wr5gUvP4bKEFRc1ZjOCPSqssrl1A6gwsLHneEfihm6cPj/4FrfMdMV81xC7cmP4ft+XEHQkMuocWD+a7EWEMXNUb8sTGhLEoepWyjYr4ZQTkWispncd+YEQAuD1xhdx4sLLF1zDHa395aabQGeXbv4daktAOm4Afu4QPALM3aK0JzMM3+ed0atZpkWnYTuYVtNO1exyF2xLDY3jT9PJTd4wFa7JpI4+bGWJxhFHPKzIqHhVwJqrK+6qxstcksiS+y
 0tvRwvz+
 Ndzukq40LR90UVgw/B3f1KRgm6xk9OqIrVye3AW4ys651G0XlZr0kmo1+akDo7JFTtzlI5JX/8uJsnpyIPDTjXcQnIipEwZcnmj/PiBd5AxJrDgm0+0IFJYbeJmJEXWMerQhadOU8XhqChhS7DGO2F4HXL9fOalmtyu0ojRluRWw+NY1BwNWWe3bR762tfhAGs7gZeJvgzfjDtqHduPac8TMTFRAGqS2A8zSPhp3w4CQIc3n7wqPUvxOIy+t6zfcFdwJt2sxRyrVz+bCXv00Vig42zthdBaBmQmGh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 26 Mar 2026 16:46:29 -0700 Joanne Koong <joannelkoong@gmail.com> wrote:

> The proactive nr_dirty > gdtc->bg_thresh check in balance_dirty_pages()
> only checks the global dirty threshold to start background writeback
> while the writer is still free-running, but for strictlimit BDIs (eg
> fuse), the per-wb dirty count can exceed the per-wb background threshold
> while the global threshold is not yet exceeded, so background writeback
> for this case never gets proactively started.
> 
> Add a per-wb threshold check for strictlimit BDIs so that background
> writeback is started when wb_dirty exceeds wb_bg_thresh, which drains
> dirty pages before the writer hits the throttle wall, matching the
> proactive behavior that the global check provides for non-strictlimit
> BDIs.
> 
> fio runs on fuse show about a 3-4% improvement in perf for buffered
> writes:
> fio --name=writeback_test --ioengine=psync --rw=write --bs=128k \
>     --size=2G --numjobs=4 --ramp_time=10 --runtime=20 \
>     --time_based --group_reporting=1 --direct=0
> 

Thanks.

Your v1 patch's changelog had useful information showing the
performance impact on fuse.  I've pasted one sentence from that
changelog into my copy of this changelog, but please don't be sparing
in describing the importance of a fix.

Also, we lost the Fixes tag.  I've added

Fixes: 64dd89ae01f2 ("mm/block/fs: remove laptop_mode") 
Cc: <stable@vger.kernel.org>

to my copy of this v2 patch.  Please confirm that this is appropriate.

> --- a/mm/page-writeback.c
> +++ b/mm/page-writeback.c
> @@ -1862,15 +1864,9 @@ static int balance_dirty_pages(struct bdi_writeback *wb,
>  		 * Unconditionally start background writeback if it's not
>  		 * already in progress. We need to do this because the global
>  		 * dirty threshold check above (nr_dirty > gdtc->bg_thresh)
> -		 * doesn't account for these cases:
> -		 *
> -		 * a) strictlimit BDIs: throttling is calculated using per-wb
> -		 * thresholds. The per-wb threshold can be exceeded even when
> -		 * nr_dirty < gdtc->bg_thresh
> -		 *
> -		 * b) memcg-based throttling: memcg uses its own dirty count and
> -		 * thresholds and can trigger throttling even when global
> -		 * nr_dirty < gdtc->bg_thresh
> +		 * doesn't account for the memcg-based throttling case. memcg
> +		 * uses its own dirty count and thresholds and can trigger
> +		 * throttling even when global nr_dirty < gdtc->bg_thresh
>  		 *
>  		 * Writeback needs to be started else the writer stalls in the
>  		 * throttle loop waiting for dirty pages to be written back

My copy of balance_dirty_pages() doesn't have this comment block.  I
assume you're patching a different kernel version.  I dropped this
hunk.  Please check current Linus mainline and see if there's somewhere
else where you'd like to add this information.




