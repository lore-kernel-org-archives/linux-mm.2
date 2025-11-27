Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C6B2D11183
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 10:52:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C286A6B0029; Thu, 27 Nov 2025 05:52:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BFF4C6B002A; Thu, 27 Nov 2025 05:52:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B3C356B002B; Thu, 27 Nov 2025 05:52:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A0F636B0029
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 05:52:12 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4E65DC08EF
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 10:52:12 +0000 (UTC)
X-FDA: 84156072504.23.CE91DDA
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id 12B8E40008
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 10:52:09 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=VKKLKDiU;
	spf=pass (imf01.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764240730;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LnwN4qehvUTKFypzF5KVJHg368Fgd9tRtCDQVe9Tm6k=;
	b=6PwvVTQEPsKUyU2JtnXWnp9VhYnTuFTc48vHhKSr9yt9pw0GD0QT0K8FNuE35GNId4PQfg
	Z4UPU6Rsv/dZSeOKvTV208FZkjM9kza4DCBGOe369ztwYIhBvJEr1wWYSp/w9QJkAohx8f
	IKI42ogOMWMG7lc5We1wS0qQMsq5KMw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764240730; a=rsa-sha256;
	cv=none;
	b=VquVfnJ2JugnKhPFSKT94ePPWGd7wixsGlMJxskuimSa25vJDYSeoH4VWrDdvneNrMnM/k
	9Um9cSOHpDXYCXaczc3J88VxkqqNBctffl9QfXPjlFKMtpNumUDG32wwOykUB3UNBp/P5O
	0Xvfp/VlUpPd6q3eWB1b/gSpYt6QY+I=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=VKKLKDiU;
	spf=pass (imf01.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764240729;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LnwN4qehvUTKFypzF5KVJHg368Fgd9tRtCDQVe9Tm6k=;
	b=VKKLKDiUg4Tr9WioFImRDhEZDbXRWX3C3uH43qsdqmSgta4rikQawp8gO4PnBNG2xS81FX
	6zf8J6daTmLcxi4aIZwAm5Lc8STStQM+QE798Zq0oIFaecaCX8m8TQevjsxtIHHJSW+BNV
	4u+dBOapJJ5e68FZxkVBKenUZEdj2uQ=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-168-9fsZA3tZPzWeY0WiP7EhIw-1; Thu,
 27 Nov 2025 05:52:06 -0500
X-MC-Unique: 9fsZA3tZPzWeY0WiP7EhIw-1
X-Mimecast-MFC-AGG-ID: 9fsZA3tZPzWeY0WiP7EhIw_1764240724
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7E8B71955E7A;
	Thu, 27 Nov 2025 10:52:04 +0000 (UTC)
Received: from localhost (unknown [10.72.112.107])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4BAB6195608E;
	Thu, 27 Nov 2025 10:52:02 +0000 (UTC)
Date: Thu, 27 Nov 2025 18:51:58 +0800
From: Baoquan He <bhe@redhat.com>
To: Youngjun Park <youngjun.park@lge.com>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, kasong@tencent.com,
	shikemeng@huaweicloud.com, nphamcs@gmail.com, baohua@kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v2 2/2] mm/swapfile: use plist_for_each_entry in
 __folio_throttle_swaprate
Message-ID: <aSgtTr0U6eEug0Qu@MiWiFi-R3L-srv>
References: <20251127100303.783198-1-youngjun.park@lge.com>
 <20251127100303.783198-3-youngjun.park@lge.com>
MIME-Version: 1.0
In-Reply-To: <20251127100303.783198-3-youngjun.park@lge.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: pr_hV3hA5FWMPCw4mBm1BEENlodo3Tm6pj71NbWkYtw_1764240724
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 12B8E40008
X-Stat-Signature: fghpydgr5nzpph7ew9aa1k5ae7195o54
X-HE-Tag: 1764240729-788048
X-HE-Meta: U2FsdGVkX18ih6fupp1hw0dT2tQf5XA34xLVQPj8M00/nbBb5vYZPpb1D5uYmwgxOCdEWE52kSRlNDY17cCvbhPKqx6erMGNyuII9HjAcUuecKFEiHmDETU/fNMMyvrBK8WRKnQ1vnLSs/4hWo6QSgT8DSRZ09y5um9WINNzpgb7OK5JIS4T7VZxOuYQv0UY6tFKTKvH6GDIyUFmL/7AzD3Mj4iy5g6dP4REjbGOGQn+hXsA9R0cNnY3wf6QhpQSaHYlB3UnL1kq1iGgezY2c2aj1XBC4OxPL43MH5/KJumGW4AFbcW7UHC6kRckvXc4Msvln+TBr+/26Fso73GeyM0JpA+hya3WZIb21Tmk14negX4HlyedqEMl3cupCeA48J04FbHZ+Nj19drlOvZo524FREZIJteLKpE9pAuNoSebmBjhld5cmuAiqO9fwjomZVteTdWrZbTv9Blsw3EtvvOU/Z749rf7B6bBvGQsfexzOQ0o+0jvI6URzmxULl0Fl6wdwbg/DUklolXKLDEwxGd3uAVoZgN+CCgBse0n8rW8pYM6PDH+r08dS+hx05w7JJCKBDBqQbDvTjAYLN2fH5edPchx0KkgZQmE+c6CFPUg9jHgKqGA6B8GB1Ta7InggKifVlbxqXTDDVWwEQRtLiTNX+C7znULojbgTtXOaH/gGWhh/NLYm6bd3/NE7AKMaBymI1w4WOPi2wCYOJQcOapzAkg6cYGtxZPTlxzyFnmhA6dY80MLH+dbqrizHuTknLVky7rHyvw9mnVcBsgZCbxbv21PBAOsaJuMrmMwzKlE2GkE0UDs2gxJeo4NjToQRexT2xap1x51iXtXdyCjJReczMDWTaR8r1jFomfB82y3A4RbepgmzlycJ6KhlBazu9QoQE/d4WeGcTweHamwXFjXAQDW6saVQCN8L/5HLKsV9MhGfBKB3yqrIDPBVxBNd8ivw7M/r+d8Y5C1qy4
 Ag4g3hbL
 HQ0r3mY925QMDksVg3RRuBwmjQCDgazZ8/FfH2LNZCEo4i0hRT8BXOPvbjrbwV3NZtM6BIFDx5oLpW06AlU3bGT4mXJavCgH1c4kDGcFLh3m86VDnAvKDh8wapUbjxG+w0eDXCDRuVLERMkDC7c4UTOVbLiztBDAvFehvt0SRztbfIX83h+YwZnPP7t1TTiaiCj6NwkWQm+jjPdIXJ3b5m+hXNI+sYuqcycm1Yh2JvqhkfCI2XgzoAcoBcs8VmDeMz3A8+NYraspGe06CXVBlB5Lqxgg8U2v+3EaVyyrLzYI4oriKh/HjQN/czCBT0v3S9nboCu4HWijSCtv5p5ftTWogWpco0H6BqvgTOPdpHh/VRrON4HSLSZPL7elJgyKQZHDsdYjKGm/0b9wBrFI4QSzn4ycNZgFeOsS2YaCTr2XMVBS6tkNIA2aiy4+3ab2G2SPh6VOP4aqQ7pPYIeDykoAQt2kEyyDzv9FnTm4ljdAqjde+vPzHC/VyZXDHofK/71/x2v4UDrEvZkm0eiuGcB60oR10U+0ShbQt
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/27/25 at 07:03pm, Youngjun Park wrote:
> The loop breaks immediately after finding the first swap device and
> never modifies the list. Replace plist_for_each_entry_safe() with
> plist_for_each_entry() and remove the unused next variable.

Yeah, and the lock is always held. So this looks good to me.

Reviewed-by: Baoquan He <bhe@redhat.com>

> 
> Signed-off-by: Youngjun Park <youngjun.park@lge.com>
> ---
>  mm/swapfile.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 8116f36e440b..46d2008e4b99 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -4023,7 +4023,7 @@ static bool __has_usable_swap(void)
>  
>  void __folio_throttle_swaprate(struct folio *folio, gfp_t gfp)
>  {
> -	struct swap_info_struct *si, *next;
> +	struct swap_info_struct *si;
>  
>  	if (!(gfp & __GFP_IO))
>  		return;
> @@ -4042,8 +4042,7 @@ void __folio_throttle_swaprate(struct folio *folio, gfp_t gfp)
>  		return;
>  
>  	spin_lock(&swap_avail_lock);
> -	plist_for_each_entry_safe(si, next, &swap_avail_head,
> -				  avail_list) {
> +	plist_for_each_entry(si, &swap_avail_head, avail_list) {
>  		if (si->bdev) {
>  			blkcg_schedule_throttle(si->bdev->bd_disk, true);
>  			break;
> -- 
> 2.34.1
> 


