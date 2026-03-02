Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F895EA4E07
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 14:10:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F2D9A6B0005; Mon,  2 Mar 2026 09:10:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EDBE76B0089; Mon,  2 Mar 2026 09:10:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DDAFF6B008A; Mon,  2 Mar 2026 09:10:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D08FA6B0005
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 09:10:02 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 963EF88DD8
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 14:10:02 +0000 (UTC)
X-FDA: 84501307044.22.8127D81
Received: from lgeamrelo03.lge.com (lgeamrelo03.lge.com [156.147.51.102])
	by imf06.hostedemail.com (Postfix) with ESMTP id 79EEA180013
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 14:09:59 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772460601;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=h+A1jdEuVFIGRt3JP/1dDbbwID37mr9DN4s7r3ER7VU=;
	b=4BI8qhc2hyUfpM0tlvc8bTEFwO9MMfzJr+iOS7Kb3aLlGGT+zJdm+K66Ti+BbS0iRGRYmC
	LKqdxycYYLi5c0JIgeJOnO5ruoCZD+bxPZ3TopuoRkS5uNEGsr1F4ZnSfTzaBJB+3kLMGD
	CisF+jesNDQuxMm/yLVeAP/kTPn3DFU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772460601; a=rsa-sha256;
	cv=none;
	b=GNKKsLj/pjW1rPMlOWLg1bgWeYoCGHcQT8Q94Jt1jubzq6GHnDaZETVFGO7sKl5hMpBewo
	lWoolBgiQl+sxyKlL/0Z+HG6P2EUrdI8d7NB2uIl3KeLAPiiJ/AMHJ1vy+Y23fYvSBXfQL
	w577zAo74JvG+tEBC485qt5qBv+WHkY=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.102 with ESMTP; 2 Mar 2026 23:09:55 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Mon, 2 Mar 2026 23:09:55 +0900
From: YoungJun Park <youngjun.park@lge.com>
To: Baoquan He <bhe@redhat.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, chrisl@kernel.org,
	kasong@tencent.com, shikemeng@huaweicloud.com, nphamcs@gmail.com,
	baohua@kernel.org
Subject: Re: [PATCH 2/3] mm/swap: use swap_ops to register swap device's
 methods
Message-ID: <aaWaM57jui+iuEj1@yjaykim-PowerEdge-T330>
References: <20260302104016.163542-1-bhe@redhat.com>
 <20260302104016.163542-3-bhe@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260302104016.163542-3-bhe@redhat.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 79EEA180013
X-Stat-Signature: zrsicccti4qnzwd14zrfj31wsog3k3sb
X-HE-Tag: 1772460599-696580
X-HE-Meta: U2FsdGVkX18mD1WX4WACdrPDwYOhiOtjy5idXz22rmTa4BYujIMEtqJ+mxBP/xQIacl+JiyIMlgibzUhqKa0c+d9J9qcHt/luIc5BYZMTNPPZm169ZWc0CEDvEJYMXp1E51S1OsO1/9++Uos0uUShYVZwXHoa+VdSP7HeDarzMq4aEt3CME6Ce2CAi9QiRYZmBQP6Hcg+QOhXobFiDSKfvrWyc21f66WFDOgtyhZJN/WoCkbcrO5n2u0sPUve4EPZMbTMlJAmUhDZjOR/tKbzZ//jf+jYaDcLI1wwI8Pv/xYdF7Xg6ZBbMyb51gM05gPxDshotLVdc7Ys3NoMMqEdC1UiC+gr00iVIRjy/pM0hUXb+qoIMitTZ8kEY93Vd7sL4AUhHtoG+hGgH4z7ORAi2NEaLFYOeUWoxqSDJmwRuuAYXJoRP20gL+BhReJxecvqY1Rn5kfqFptt5uBqFQS8o4NEDxrA5SMmX4TUA0dKIAB5tiN6RwAbHul3u5yczFsP51Ck/VfbD8c1LMTtuljO28F5qkX3tB8L0LVYdKA37l7EkKlJh8ERWk0l3iP3m0Mzicb5ibOyzn5AckmO5EL3gmCkllYypW0N3UlVlb3gmbz4e7bN5s3V8dhTLhmYZBtLhaFks4EfmT2Q+9iXcwFs97mJP+DcHWAyIf6omhadVPEcJuRo07kQtIOKLj9xp0STk4Y9+fmNKqvwYJymIMi0dJzHbRi+n+O3n1gOhXAwnStXR/i2QItXuE46IQRAlIsmXkL4QH+YomWuBrECycNs00wZo0/Z4BFU19ww611DBQnaeZO76LnhxoVJbvEpUbFaICLGaIEDw3Wn3g7OzQuFyU6K6iIHF0uAPUniZSbfuDWm7qpUBDdyBQNP/K9yAzuvKDe5wB1o4Kp7p0ilNx1BZVMU/9YBQzYg3W+c3GLQkz+Nkhd4vWoBtpucLgyXsWuUl0+33YAvwjHnqlOhGE
 iZ+5ltPw
 FMoAY0STfFF9PyNjeWfx0Yta8vF/+LBGPp2S3n+JUI00b85jufxnpp4f36L5xD6b6ILOhAW9obB0mC9nGB03SAnSKvGWXsz2yv7lI/gh3niJcLZhZPuXjnGl/HN9Mu4wIfS8q/lb2dy6Ud0Upq/rDXmzFN9l4WGo0qHrBWLEwVi2MXz8vJUibmM1EZUVN5S3rjcsoSCqglsi7NlYMURzKJCEWfZkliBz/6KsNAInaAs7MKNdiPbiVl0gc5XEx6+PgpVQfTYxiX69MEhXvkHr7cspaUWhjAXqXHunj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 02, 2026 at 06:40:15PM +0800, Baoquan He wrote:
> This simplifies codes and makes logic clearer. And also makes later any
> new swap device type being added easier to handle.
> 
> Currently there are three types of swap devices: bdev_fs, bdev_sync
> and bdev_async, and only operations read_folio and write_folio are
> included. In the future, there could be more swap device types added
> and more appropriate opeations adapted into swap_ops.
> 
> Signed-off-by: Baoquan He <bhe@redhat.com>
> ---
>  include/linux/swap.h |  13 ++++++
>  mm/swap.h            |   1 -
>  mm/swap_io.c         | 102 +++++++++++++++++++++++++------------------
>  mm/swapfile.c        |   2 +
>  mm/zswap.c           |   3 +-
>  5 files changed, 76 insertions(+), 45 deletions(-)
> 
> diff --git a/include/linux/swap.h b/include/linux/swap.h
> index 0effe3cc50f5..448e5e66ec5c 100644
> --- a/include/linux/swap.h
> +++ b/include/linux/swap.h
> @@ -19,6 +19,7 @@
>  struct notifier_block;
>  
>  struct bio;
> +struct swap_iocb;
>  
>  struct pagevec;
>  
> @@ -222,6 +223,17 @@ enum {
>  #define SWAP_CLUSTER_MAX_SKIPPED (SWAP_CLUSTER_MAX << 10)
>  #define COMPACT_CLUSTER_MAX SWAP_CLUSTER_MAX
>  
> +struct swap_ops {
> +	void (*read_folio)(struct swap_info_struct *sis,
> +			   struct folio *folio,
> +			   struct swap_iocb **plug);
> +	void (*write_folio)(struct swap_info_struct *sis,
> +			    struct folio *folio,
> +			    struct swap_iocb **plug);
> +};

I think swap_iocb is only required for fs-swap
(swap_folio_read_fs/swap_folio_write_fs).

If the goal is to support fs-swap through swap_ops, it might be worth
considering a more complete integration, including activate/deactivate
and swap_rw from aops, rather than only adding read/write hooks.

So.. we could keep SWP_FS_OPS as-is for now and just split
sync/async paths, and revisit a cleaner fs-swap integration later.
(I mean removing fs ops, and call swap_read/write_folio_fs on sync/async ops.)

How do you think? 

Thanks
Youngjun Park

