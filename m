Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE520C43327
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 09:58:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B68966B0005; Mon, 29 Jun 2026 05:58:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B40686B0088; Mon, 29 Jun 2026 05:58:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A7D566B008A; Mon, 29 Jun 2026 05:58:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 870936B0005
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 05:58:54 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0156440631
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 09:58:53 +0000 (UTC)
X-FDA: 84932501388.28.BB56B56
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 69996140003
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 09:58:52 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lxBdgJLs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782727132;
	b=7KDloF46QjbLIzY/+8LTXW/FTvS0sqvvQqZarOBEJ9yymH5plcKq4m/xF8QjwrPDiAsVb+
	t7Fc5Lxyq7DRD9Ms6ucXVRjpkz1yDzJXBDEtw2kZc0uK+KOY3G0FiBSPnbXX2/qmkxJp/d
	kDlocSCa+yqHlDTA/vBTt/KKbDLsZO4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782727132;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=opowCa2ZvIDE9fF6/MgL802+A6a0EGc5rtw+OZ6dgaQ=;
	b=6Ut1x6qAyN4GT+oI2PSas6ExIyBb26Zj23B0j8NL2nwoxBX6BS0Ae4bwes64m4lsfsMtmV
	RKv5aoNYJCVhoikkV14gAPvrYTh7Y9zR1ME9H3IH1dOCDRAVI44/kt0wH7OHwiL3Ibd0oV
	FFGLxKFIklnnqj7YcDVQ6C+jWl4kx2Q=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lxBdgJLs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DBC0860008;
	Mon, 29 Jun 2026 09:58:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D9441F000E9;
	Mon, 29 Jun 2026 09:58:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782727131;
	bh=opowCa2ZvIDE9fF6/MgL802+A6a0EGc5rtw+OZ6dgaQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=lxBdgJLs0kGs9j01dlQJ60KK/e8g5xMS8KKXGGi0H9F/bdVZdb2FdYlqn715ZRY88
	 SquVXra9Xgh9/dIiWwEMLlpemoZuZPw5lnSkPlaUS7F3o2k1mqdapRCy0LCXl0095Z
	 L6P3Cc6K0ADLqpYZ2X2i4yYYrjdCNwmIr+V9NEXbwiZYEx041eXfkFPr4mvBGyGhkB
	 89owQTyLFU21r4/x2PP/yGZpjA4ru8qkfuWIbUhY6IHEBUbdAER69uJ8d67ZvLqjud
	 S7Ui3Xdj7RmjUJOGVkewC6G6yq39R7f2q84w+3vhJyhAFvfEUb/0b2zG9RSPnjgHfp
	 B7W+Ra4pS4rrA==
Date: Mon, 29 Jun 2026 10:58:42 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Zenghui Yu <zenghui.yu@linux.dev>
Cc: linux-mm@kvack.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org, david@kernel.org, liam@infradead.org, 
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	corbet@lwn.net, skhan@linuxfoundation.org, sj@kernel.org
Subject: Re: [PATCH v2] docs: pagemap: fix flags location, member name and
 sample code
Message-ID: <akJBvKcTU1dw8M9I@lucifer>
References: <20260626162710.25844-1-zenghui.yu@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260626162710.25844-1-zenghui.yu@linux.dev>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 69996140003
X-Rspam-User: 
X-Stat-Signature: aei4ywuh1xhi86rc1stw3k5ma6kfbdxr
X-HE-Tag: 1782727132-681099
X-HE-Meta: U2FsdGVkX19Ba9jbLJ6N2IWv5hmgy1Dw5o5Quh8lQSTDiJjcQkqGSVY0tu3qZDksoikC5HVyOsou/43lD3KvbalVeMn67oEkmMwaTzze6wnmln1MRIgrx0Q2RzutTiQd1vnwBpDXbIhesMIWBQFwU6kKFrfXeLveZU4M64rNkNg/9Uc8MWGYkDnuVAVkWHz+TtNQPGCW60g0WMfqsWIbSzv1J7VsXIRDO4It6rn4bDAiASp8I21xzwwQw4ZgYpj9slW/oQItByaSPFfYt40JL1kSYYq19IErxgIkoBotyc3fmbBqN8LE/w3uJkOoD7LBwSva6ewQ28BxHLwJtE7vCPuV9NT2Ub3GW6dl1T7zTvMXmbKTx0X2sl/ZMvrn2DhKwogLF2R2m9IIWbeT5tPmpp2oAQXaqwlqRU7KJL5m6O9E0piIxGHMFqhYAl7Ckx15jiMvOlvQ66BNeJNBazjrqEkUHJcc6uWtgiwt0Gi8vgbzP1jgj2nxpQJUlDcysNa1XvtcLwWkWfVZ7jYkG+wD1Tw586vEmITXQUFbKQMMbMnlSPJbAmJN82L4h7JqU9z5lCdcy/WKYc001IWsPEVjKnOHyEIYzGG61Ta84Kk0UUOfJCjGgdiqCQGMgLoSvi/l/D8I+lmFb9ytORUtKOTTKGkIOWrIe3js410z5yHv7VPDwUdWzUTU19IYMHlDcFDlUjs9eHmT5NG8Z27OO2ypTv/fsdPgDiIziwQU0n2xshpcy95W1u6CegdK2xQKLFiFinril2wh/47TjjNb5ZQepD94wSkbFbBXTbCv84EdtzzmAA/o+/tObNhSZabBDXL8634nYL7U22pk0bQVQ7kXFAEElqyv8mDO1RCUvuWnsALnLAmlc+R9DjDANLi0OKD3TokgiozVZ11xjopgDgNqS45YklrTlWkChMKnF5zvPqHZAv9EKuAsSVUv9ZtDFgF0yjzPexUFGRReNW2+Bxj
 JfDyQcT3
 FwPldcfX4Ci9a7P+/c7HEcQY/QN0GCq03pLMG225BgBMzHf7e19lHWWuLyay6wtMWuRpX4jaTwPQJnSisyORwlTm8rhCXGHNze8D5Vt11BQyHMXROYbwhGE2N5nMYzwGiNNotw0CgbKSy80lQl+PYNwzPG31HrOLPt11cpi/tX23Gz7372WnixBl6hH4wYhUEPIUxycbFZJ9qt0vVsfx1XZO/qeQVTkfa8uhGDXVGfOzQY+RV4qUDKzk4LOxXg/wS9DGjsY69dbAEKqjulFgm5tsfEw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jun 27, 2026 at 12:27:10AM +0800, Zenghui Yu wrote:
> The userland visible page flags (KPF_*) were initially moved to
> include/linux/kernel-page-flags.h in commit 1a9b5b7fe0c5 ("mm: export
> stable page flags"), and later moved to
> include/uapi/linux/kernel-page-flags.h in commit 607ca46e97a1 ("UAPI:
> (Scripted) Disintegrate include/linux").  Update the doc to reflect the
> current location of these flags.
>
> The member @walk_end of struct pm_scan_arg {} was wrongly written as
> "end_walk".
>
> The first sample code of the PAGEMAP_SCAN ioctl wrongly used the
> PM_SCAN_CHECK_WPASYNC flag twice, instead of the PM_SCAN_WP_MATCHING flag.
> The second one included the wrong category in the required mask -
> PAGE_IS_FILE should be used instead of PAGE_IS_SWAPPED as per the
> intention.
>
> Fix them all together.
>
> Signed-off-by: Zenghui Yu <zenghui.yu@linux.dev>

LGTM, so:

Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>

> ---
>
> * From v1 [1]:
>   - drop PAGE_IS_SWAPPED in .category_mask (David)
>   - fix typo in commit message (David)
>   - didn't collect SeongJae's R-b (as the content has changed anyway) but
>     thank you for that!
>
> [1] https://lore.kernel.org/20260625174447.24292-1-zenghui.yu@linux.dev
>
>  Documentation/admin-guide/mm/pagemap.rst | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/Documentation/admin-guide/mm/pagemap.rst b/Documentation/admin-guide/mm/pagemap.rst
> index c57e61b5d8aa..20e3fe76f099 100644
> --- a/Documentation/admin-guide/mm/pagemap.rst
> +++ b/Documentation/admin-guide/mm/pagemap.rst
> @@ -67,7 +67,7 @@ number of times a page is mapped.
>   * ``/proc/kpageflags``.  This file contains a 64-bit set of flags for each
>     page, indexed by PFN.
>
> -   The flags are (from ``fs/proc/page.c``, above kpageflags_read):
> +   The flags are (from ``include/uapi/linux/kernel-page-flags.h``):
>
>      0. LOCKED
>      1. ERROR
> @@ -264,7 +264,7 @@ The ``struct pm_scan_arg`` is used as the argument of the IOCTL.
>      provided or not.
>   3. The range is specified through ``start`` and ``end``.
>   4. The walk can abort before visiting the complete range such as the user buffer
> -    can get full etc. The walk ending address is specified in``end_walk``.
> +    can get full etc. The walk ending address is specified in ``walk_end``.
>   5. The output buffer of ``struct page_region`` array and size is specified in
>      ``vec`` and ``vec_len``.
>   6. The optional maximum requested pages are specified in the ``max_pages``.
> @@ -275,7 +275,7 @@ Find pages which have been written and WP them as well::
>
>     struct pm_scan_arg arg = {
>     .size = sizeof(arg),
> -   .flags = PM_SCAN_CHECK_WPASYNC | PM_SCAN_CHECK_WPASYNC,
> +   .flags = PM_SCAN_WP_MATCHING | PM_SCAN_CHECK_WPASYNC,
>     ..
>     .category_mask = PAGE_IS_WRITTEN,
>     .return_mask = PAGE_IS_WRITTEN,
> @@ -288,7 +288,7 @@ present or huge::
>     .size = sizeof(arg),
>     .flags = 0,
>     ..
> -   .category_mask = PAGE_IS_WRITTEN | PAGE_IS_SWAPPED,
> +   .category_mask = PAGE_IS_WRITTEN | PAGE_IS_FILE,
>     .category_inverted = PAGE_IS_SWAPPED,
>     .category_anyof_mask = PAGE_IS_PRESENT | PAGE_IS_HUGE,
>     .return_mask = PAGE_IS_WRITTEN | PAGE_IS_SWAPPED |
> --
> 2.53.0
>

