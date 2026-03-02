Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1DDECEA4E07
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 14:43:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 60D286B0005; Mon,  2 Mar 2026 09:43:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BAAE6B0089; Mon,  2 Mar 2026 09:43:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E4216B008A; Mon,  2 Mar 2026 09:43:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3A3006B0005
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 09:43:24 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EA07A1B5F2C
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 14:43:23 +0000 (UTC)
X-FDA: 84501391086.01.97D1F62
Received: from lgeamrelo07.lge.com (lgeamrelo07.lge.com [156.147.51.103])
	by imf24.hostedemail.com (Postfix) with ESMTP id 951B4180005
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 14:43:20 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=none;
	spf=pass (imf24.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772462602;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sTOxeQUythKBqQ0Mf8KCN7EvwN/l9/1rfOnnFjXHzOE=;
	b=7yPoru45B5lL1n3MhTO/K+4Mdy8SB5tQMdrPX+m1iSLKl3v9X3dOlV0HhJV3vj0nwQjIlr
	Lvdy/+4BJ9Er8Cf2u7x6tmaUQPAJGMvjeT7VU1KiZEZad2rk851jyqTWnm5hZYUIcR4Rtf
	FjOsS4DCMIgi79RxEAnqsmDc4sWetws=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=none;
	spf=pass (imf24.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772462602; a=rsa-sha256;
	cv=none;
	b=lMbUfuj2U0KRJhZeuxjsHbnzbEJ4nYxHLpsl22NBs00mJzSfRE6yEWPqXIPjIPR245Q82S
	OEJfFznHZaH8zHUyAzyJc546nfkzvgbdmxQI4lMtYvB50N69uHsV8lOc3Y/bcCOyD/1ctv
	kzagyfyjjQ4D+juiN78bOSqPWgvVp+Y=
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.103 with ESMTP; 2 Mar 2026 23:43:17 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Mon, 2 Mar 2026 23:43:17 +0900
From: YoungJun Park <youngjun.park@lge.com>
To: Baoquan He <bhe@redhat.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, chrisl@kernel.org,
	kasong@tencent.com, shikemeng@huaweicloud.com, nphamcs@gmail.com,
	baohua@kernel.org
Subject: Re: [PATCH 0/3] mm/swap: use swap_ops to register swap device's
 methods
Message-ID: <aaWiBaeSCILBCzqd@yjaykim-PowerEdge-T330>
References: <20260302104016.163542-1-bhe@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260302104016.163542-1-bhe@redhat.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 951B4180005
X-Rspamd-Server: rspam08
X-Stat-Signature: pq7kmrukp9dhnrassoxzdsewa5mh67sh
X-HE-Tag: 1772462600-432937
X-HE-Meta: U2FsdGVkX183g/hwZAxQO1d6xAfpEm9j2W3pdN1a1Bt9aLzBiAytxsiJ9xMV5TkoJlMRUwOQuxFGe6p2w5SL9uQMFXHbEI6RE+ea0PkuIhz7dljkRm91VlJS9hMM/5706AKm2zqKs2N/0Dr+HgTIAzmecysbl51nQ99uwQTUdNX3u3D5YCpuiv7X/SmL1KBTAnr3MvoAYJStyXBZRsaLgTEzxTW8jKQZlf4+sAgj1TGxvExfkCxZrNmM1nb1F63GJJJDjlCgzKIzcM959MEL9lKHrVaXsmDZb8abRq+W9W1cqDmQ9xQ8wFg9cqyGONAihpEuOrDtl0qBe4lt0sbTUSWIJ+eXwYmxTOEsywDQLx4CBC5lOwEa/XPhqWO2FYAw5q2KlRxWz+WOoYyTCwkJ4GidEDy3CjX8vnO+SFs5a+XBshH3oL1k1OBR5UL409dZocCObjZ50gEvSWaBR2OpKHW9Zo395rze+QMFLRLX0RRGlVW8nd2uYx3/OHm62oEwgE1jsIwd8CpIfSty5U1gCv2lBUVZ8c0XADnDMhrXlTnUXiElGIPph/cHeykBwf48usOmOL7qrOD3X2L7zlnKEbsDzg6+vcg6+UzCVKyAatdkfXRL5jI2sRm9tj6W02SvK/bWDRaufNM8N9kUZW1fVXmQcfRfZBzXVBVYQ6pTaF+fmW/LLqsiwsEfXklfjoZT10LdnJyKBPasgBeDVsF730QlqItV8TDAM19G0Wqg0ilHeQchpbtq4l5uL4m7/NlgraVkNwu5Av/xXmAxG7TKiPUrClk11LdmS2Osp90hrRmAA/BzxczfgNyIMkNAQ8qdV8J985HaBYibKdKnfGG8Wn2Bs1qHto0/REEpRYQuu+ypx3BHk4SD+LeejmomLvkeEgrMTGQj98tFMoEQtE4qIgEELjV9gsRi7hp7Bgi1TU2IhyNDgwMM1Gyc+Sdj5jE5LL21reZWFoZcvcSzLQP
 TA/1qdyC
 wD8g2GEGghufQiUngOWDqEOeqziRcM8uS3ge+zqiLlgkC910e7DGcnTKzPf28cTrIOGxDguqs3f41Zd/0PPCEKid5lnXyCpPYUCfamNz35hDEONEaK1a2suwsxE1hi9JKe5x2xpIk0+0y9khRga6h4naitAsgrYCgMyL5ylXXQBhFecz9elXkFHY43SfK5qv2f4KIrZgC4PTt30GilhcVisZ/ZmP3C2jqXEXDVKlYgps5NDQq/WOqiai0cQh2Ohp2wbrvBMGvM5YIeER9+YXo3QxV1YOfUPHbgDIq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 02, 2026 at 06:40:13PM +0800, Baoquan He wrote:
> This can simplify the code logic and benefit any new type of swap device
> added later.
> 
> And also do renaming in this patchset:
> -------
>    file renaming:
>    ---
>    mm/page_io.c to mm/swap_io.c
> 
>    function renaming:
>    ---
>    swap_writepage_* to swap_write_folio_* in file mm/swap_io.c 
> 
> 
> Baoquan He (3):
>   mm/swap: rename mm/page_io.c to mm/swap_io.c
>   mm/swap: use swap_ops to register swap device's methods
>   mm/swap_io.c: rename swap_writepage_* to swap_write_folio_*
> 
>  MAINTAINERS                 |   2 +-
>  include/linux/swap.h        |  13 +++++
>  mm/Makefile                 |   2 +-
>  mm/swap.h                   |   3 +-
>  mm/{page_io.c => swap_io.c} | 104 +++++++++++++++++++++---------------
>  mm/swapfile.c               |   2 +
>  mm/zswap.c                  |   3 +-
>  7 files changed, 80 insertions(+), 49 deletions(-)
>  rename mm/{page_io.c => swap_io.c} (91%)
> 
> -- 
> 2.52.0

Hi Baoquan,

Thank you for the swap_ops infrastructure patch. This is very
relevant to our flash swap work, and I believe it could
significantly help with our future contributions if the framework
is extended further.

As I understand it, the current patch serves as a foundation for
future infrastructure. However, from our perspective, the swap ops
are currently configured statically, and we would need a way to
apply or register custom ops for our use case.

I have a few suggestions (mixed with questions) regarding
extensibility.

1) Could the ops be replaced at activation time, similar to how
   SWP_FS_OPS works — i.e., giving block device drivers an
   opportunity to override the ops when the swap device is
   activated?

   This would allow block devices to handle swap read/write
   through swap_ops rather than doing it in submit_bio, which
   feels more generalized and leaves room for future extension.

   This direction would be the best fit for our use case.
   However, considering ongoing swap work that may involve
   managing multiple swap devices, I wonder whether binding ops
   to a single block device would still be appropriate in that
   scenario.

2) Would it be possible to defer swap device activation via a
   lazy registration interface, so that the ops can be registered
   before the device is fully activated?

   This would open the door for entities other than block
   devices — such as kernel modules or other forms — to act as
   swap backends. (Of course, block devices could also benefit
   from this path.)

3) Alternatively, are there any plans for a static binding
   mechanism, or any other extensibility approach you have in
   mind?

As an additional thought, if this ops framework could eventually
be extended to cover cluster allocation as well, it might enable
a model where base swap functionality is provided by the core,
while each vendor can freely plug in their own additional use
cases on top — making the swap device truly extensible.

Any thoughts on these would be greatly appreciated.

Best regards,
Youngjun Park 

