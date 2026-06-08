Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70F8DCD8C9D
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 10:40:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C34BB6B0092; Mon,  8 Jun 2026 06:40:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BBECC6B0093; Mon,  8 Jun 2026 06:40:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A86526B0095; Mon,  8 Jun 2026 06:40:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 924C46B0092
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 06:40:05 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2C439C33BE
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 10:40:05 +0000 (UTC)
X-FDA: 84856400370.27.0C7FBFC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 7EB0CA000D
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 10:40:03 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dRZ35HRM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780915203;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UAI22XDH8Rk02hdvoTH5Zr8kOOXybFt3zj/PmpT+vR0=;
	b=OInlRgIy2n2opDWN0J5GHtV/jPuJtJXJzo7FObLfi+Ri3Aj3V+MCHaJ+g6qV3tjC7Xm8TO
	a7H4wb9q40DjOHKAGuP8QOCGn5o4I/ENw1+IPL+3mE0DEfsuiwZrBMoO4gSvOaiGTJa6nu
	qlEHCs2GbmZH4v9X9fJyU1qsdyE0UGg=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dRZ35HRM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780915203;
	b=C6ifvwWnktt8ZXtT5bL1VTUehChdUG3Am2UnBIXOBjeAZwvmZk7pHXzm/CvFjar1Jcr1nb
	PjLKuHlWBchXcK3bA/1aUw9nfEgkHl2D+SkhXO+mBpJ3HQAk/k4i5ibKE1Uvafy9FcLlI8
	05Xavt9r0rcZt4Xgn8uALJTHH4xjArM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8E70444276;
	Mon,  8 Jun 2026 10:40:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA8131F00893;
	Mon,  8 Jun 2026 10:39:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780915202;
	bh=UAI22XDH8Rk02hdvoTH5Zr8kOOXybFt3zj/PmpT+vR0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=dRZ35HRMCB5YSX2evh0CzhDac0sfa/9kUKcQbFlfBcNsqTjaHSKDIzFE6dOYCqSOR
	 BUqJZ+XA9CN8FBP52TGvSNdRnFmOPGzJnBdBc7oufRxFlAre4qCxSYKXJMB48tPDCg
	 +ocEPqSN9xwVrfWctPMv3Rr7rUsD06LgHJGhlhL6pRHwiNyrhwZIn/W8UTd2dW3rX1
	 XqHgCqrrgeiEu2HyAZG17AKzc4n0mZN/ICwW0yAnunJFvWxXe4EprolwzVzG5V2uol
	 /K4Qfq2c8SFn65Y15w92rlVyjpdUDrBvbDnlmzxRCpeVADi7bn0EXdCDRIj3W771IA
	 ZsoN//T+zOjXA==
Date: Mon, 8 Jun 2026 11:39:49 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, 
	"David Hildenbrand (Arm)" <david@kernel.org>, Jason Wang <jasowang@redhat.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
	Matthew Brost <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Harry Yoo <harry.yoo@oracle.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, virtualization@lists.linux.dev, 
	linux-mm@kvack.org, Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH v10 13/37] mm: use __GFP_ZERO in
 vma_alloc_zeroed_movable_folio
Message-ID: <aiaau7RIhkJMS_oe@lucifer>
References: <cover.1780906288.git.mst@redhat.com>
 <862a59e98104db76ee3998460bfc55e937c218c4.1780906288.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <862a59e98104db76ee3998460bfc55e937c218c4.1780906288.git.mst@redhat.com>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 7EB0CA000D
X-Stat-Signature: 57zmb69zb8ek6brxk4dymuy8oabb4fgr
X-HE-Tag: 1780915203-751065
X-HE-Meta: U2FsdGVkX19DIEmavd63Ztu7ukLOoOI87SYreBzZeHtUovsXeDyt4XZam0s6Hml9U6VuxKcIkdvWtxiu81E4yJHT+SsBUSOC5S+dh+fzOTJaZ8bLf3Ue+nEJun94SWn3UAZ417sjAf24UyLAWlRGnAL0sGICsfmRaxTpTtleCKJz5I2GWhatBk8KxxStDF2opXzRevb8Lqxv7fYEVNpZehlsiF8sLXyT/aSwiGT7d2WnOz+M+By7tc3+9DlWuQfiaR1omod4SRXZ7XMbUWmOzNEJahU+SjJxCKt9c9Il4pDiDalMfnacMQML/QvqNWmQOnPmFSzskb0GvK4aG77UqtrJ5HxKEYpMP+ZHY80KpZ2Fwkax+0XGZcKCRsGG+KPSFW61ER5x1ejldeO8TDNkwTgu35BeemPtv1/NmMFa/saOvSxpMx9NKYhsGnXtkTNa7jwWoJrow+rY6vf6pE6YncdY4N78Ap7gU+3P1AfNHTyrku1pLd6qzZ3TUTaboe6ibufor4o8juq7Q4nBDRweS5Bin9sTVCSgafNEMr6BvwoexpKe55QgaYpTW8TAlHlWcsflwvFVncoCvWIZDlT6koTIcK2hxRiLWYnuDQ+mWftX5WPUWAqzSBDoOZNNDQfEt6dKiEpgbRXGxDmKRHippNorlbPcsBgLAjW5CqRIlikXBUyi00eaY+WT60lKaXl7N0vbpahZG9NQ54948BH6KAdQNb6s6nkKiZfWB0TP7kd/I45c82UPEsWXD0+VmWt+CM3axMZLhFMCuCGkQ1+VJGbbXcPDuIQz3nVVYmnLiZUYrc6QLfOJzxc/NzJy7BXY3X8WNjtIdJ5/D8j1Q8Pri+VFdEGSaPIGYvRo0wSeu5aexvLkyQt+ZicQMAfu7cSnt3bVNVWE184nJgRUO1Pu5VRioWLP3Yp2Zun2Mx87Yd7PHCmiI+HK+BRpmtmkF672un+VPYPi2STKUBmdUh5
 lbx0YDMp
 claeB9c15tpDOrEo31Rob9BFdvNzZPrG3MeXGyItdn1DDG+XSVakvNXZbIUjBlRtTx+AxSwq2HDqQQ1Nm8TT2iSlL/zD9y2iGuuTyl+LKQvtZJbJThfCx8XzB9Jq1MZsTqMrsF8hgMiCWIG0tqDHz1HbTBtrFNOqZXAoa2+sjylSS+mnSkOd4+kIOkYncxLtIKJE5ZbBXa9wDL8tfgMyCrw42/Vnk8gt/r4T1XdKnjL5X3mlwBH6rKDC8BZSDi52sTDWlJ67HTz3WiVMoE27dMYtRp7dQyuj72hyQ3LMIg2GYLCybO+ewf3Pck9qtxBffk8lRvzXm5ng7F+iQrSbfe0mJVEqLGeP2TKR3gz4BWSdtuK8i7/d38gi4CVZv1bujOawZ66oobiWa8LzppHDPp/SWgw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 08, 2026 at 04:36:51AM -0400, Michael S. Tsirkin wrote:
> Now that post_alloc_hook() handles cache-friendly user page
> zeroing via folio_zero_user(), convert vma_alloc_zeroed_movable_folio()
> to pass __GFP_ZERO instead of zeroing at the callsite.
>
> Note: before this series, replacing clear_user_highpage() with
> __GFP_ZERO was unsafe on cache-aliasing architectures because
> __GFP_ZERO uses clear_page() without a dcache flush. With this
> series, it is safe if the caller passes a valid user address
> (not USER_ADDR_NONE) to vma_alloc_folio() etc., which delivers

Wait, so now you're making actual correctness predicated on correctly
passing the right user address??

> it to post_alloc_hook() for the dcache flush via
> folio_zero_user(). It is only unsafe if USER_ADDR_NONE is passed.

Yeah, ok I'm beating a dead horse a bit here, but no to this approach.

>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> Assisted-by: Claude:claude-opus-4-6
> ---
>  include/linux/highmem.h | 9 ++-------
>  1 file changed, 2 insertions(+), 7 deletions(-)
>
> diff --git a/include/linux/highmem.h b/include/linux/highmem.h
> index d7aac9de1c8a..8b0afaabbc6e 100644
> --- a/include/linux/highmem.h
> +++ b/include/linux/highmem.h
> @@ -320,13 +320,8 @@ static inline
>  struct folio *vma_alloc_zeroed_movable_folio(struct vm_area_struct *vma,
>  				   unsigned long vaddr)
>  {
> -	struct folio *folio;
> -
> -	folio = vma_alloc_folio(GFP_HIGHUSER_MOVABLE, 0, vma, vaddr);
> -	if (folio && user_alloc_needs_zeroing())

So now we are unconditionally zeroing the pages even if
!user_alloc_needs_zeroing()? You don't mention this in the commit message
and it seems like it'll regress performance?

> -		clear_user_highpage(&folio->page, vaddr);
> -
> -	return folio;
> +	return vma_alloc_folio(GFP_HIGHUSER_MOVABLE | __GFP_ZERO,
> +			      0, vma, vaddr);
>  }
>  #endif
>
> --
> MST
>

Thanks, Lorenzo

