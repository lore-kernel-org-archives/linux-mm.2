Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B83E2C5DF97
	for <linux-mm@archiver.kernel.org>; Sun, 23 Aug 2026 14:43:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 95C396B0095; Sun, 23 Aug 2026 10:43:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 90D876B009B; Sun, 23 Aug 2026 10:43:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 826606B009D; Sun, 23 Aug 2026 10:43:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5B48F6B0095
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 10:43:20 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CA25740310
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 14:43:19 +0000 (UTC)
X-FDA: 85132802118.05.C7FB9A3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 22D364000C
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 14:43:17 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=h+AvD5Qd;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787496198;
	b=nEnIvie0vWt7dl5Q4+xQFV3X+YqmBQ1IT2/o9wvFMN5aelrCs69WHr2aoo5nZyO7IvCAvT
	n5NZxRqF+p74aJIt7Ar1h0y0iySaPNvDeWBka+pzKX9l51y8NJfAVCqhQnz3EynDdhNIjh
	sVperK+ozKAZ/NAYBJLUPt+uY9WB8gA=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=h+AvD5Qd;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787496198;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pvjv/nyRQmsWaIMsCt8srBUubLaMtm17KGRMdE9iACI=;
	b=0rQrqWf2vOj1EDNA0t9CAd0yHV0P9+J+Wt3ecm77AmY8t9S21Uf87pY/K4xNgHWsvOLq4n
	jWy2QXBWq5Qj+VtTeMxWucL/wRQ0uFKhyO2zBf/0f65niCnQj0y8cohTyNydTlqvHHuy1l
	xv9THLL7GmnkzKxSZsyu46hxEdgjbo0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EDC1F40978;
	Sun, 23 Aug 2026 14:43:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D796A1F000E9;
	Sun, 23 Aug 2026 14:43:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787496196;
	bh=pvjv/nyRQmsWaIMsCt8srBUubLaMtm17KGRMdE9iACI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=h+AvD5QdsIyzhG+gUEoYCTYnrzZkvWKchkhatD+NaXvh7aQ3sGD03cnt8uKfIkNfC
	 W5EsA23A8Bn+dwg/5XLzaShcZ0mOx0Y+IqgHdHpSIbCQQ+Aj3hTtHOydp2gwEA82d1
	 iShmCKnM1xH8HPh4N5OD3uJX+Xoeq7746YRZL/qAmJx/71zUY/PA68vuw18IwaorRW
	 J5/yPZouO8hIyinoJSHSK1Gg7lo+iOEcF8ISnCax9YdMy3ETBk5z1JbUXzgUdQ6zcS
	 VSDUB3AjYmvBI/61rocahAtZgRfYQ7i/3U6nVYViIQVi2+/jx1WcWXwL+02bb7Nv7b
	 goI06wVJCl86w==
Date: Sun, 23 Aug 2026 17:43:11 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Meijing Zhao <zhaomeijing100@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Wandun Chen <chenwandun@lixiang.com>,
	Meijing Zhao <zhaomeijing@lixiang.com>
Subject: Re: [PATCH v2 RESEND 0/3] mm: memblock: fix debugfs flag reporting
 and synchronization
Message-ID: <aosG_685XrPdrAJD@kernel.org>
References: <20260821020910.3428585-1-zhaomeijing100@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260821020910.3428585-1-zhaomeijing100@gmail.com>
X-Rspamd-Queue-Id: 22D364000C
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: 9i556ecci4381ajii59oq9ya7ry3benj
X-HE-Tag: 1787496197-545169
X-HE-Meta: U2FsdGVkX1/pxuffgyiSaEq9lAswYajtY2f4daalKq7sp2m2GE6kJI9UB+Y6aVK7GQXEg6NmcwIL69HlaaiLkg8h0owOKrrGcfpKoZWX1Xx4XmLH1u3iTw1RTeBkwUae7Ma5UDCV9SncnSXnLfmvbHMadDWcBl1euMvjlNYgyPsIbLKxW+ZMA9Q0x1mVgHZOJ/enLfakHSsviBDuxKyVsFdG+TGXcNPyQ5QL/ucLAE7IqGV/Ttz38o9zPyr3mEHsD1LrAykzgbwKPj/YbCD5vhbmF6SCuofyGd+I9YLnQhSwZ6cqotUu5AdCJ430mNOeoeuSMkwWuRnVTTALFL7kj6VOSpQ+vVtjLm2cS2LmZT9VO8TgOCTKzhfabIc6LYf0QM+CF04q0hf7CXe/UnD+57M0dJ/QS74aGA6j0Nh8kV/8GyzJRpHNR/kosPHmcfZxs3kH/NXOLNWC0yIt2zlImR+V+234HHA7SBbXHYg5cCAAGxh203rROGy6tt6kdWn77AvFa4CFjJHmO4PhWqln9fxk54UNJ0EM9C3vs2AMPiKJt0d8CzwfyUb1J/Wo5zCXbsNkReNAm6XK2CYTjkCNE5xdTrUji94QOBno3SPvCJD/2l1nGXhBF1jF5RVjvFUpaDBnPE/tkrM5Bz0bTs19SYQteyWo+d7jYUwWjKfbSsP5Kijw1kPT3XUUMhwWKAI7oDndmS0UlYzNMW+3O7Xf/eLjWxleIVyCaVXcAe2ybL22upsqqiKJI3gd0QVFcizP0VyC9WiXMqZQPBGihfan44jNVsrp1W04hppWvqQjoES5Ky6dL9uPD0c1F1XGcoTWYkvMVzfugpBZ7v+g0m/LRKzu+SwpulNaWKEyBMJBw4+m7FzYL0suBNDVa3pUzKSogFHR1w6MOuGB7fsVvlX5kffMuX5cHOCtGHYbixeb2oLlLa/J9oAltOlXdo82Ar1ZgdegUwJuj83HKSZqGUn
 kL0+h2DH
 z0NfkKoDXphIIZm0hjOxcdPkU3kh9PGBGvK8HezlMFfhcPYPYPubucRUkV90qtTilvcEEuwWshad2daaBOAAD6lcH8gDUx8zeh8LeXXBIouM0nHg0LHPbTlvJWevdgTkq0ePqaUBjoHSlyzDS/Ts3hQL8TwCeuo2EcwCrg9+ljBbITDk+kFM1ZagO2scIUALy+j3GvASMibqz6DigvVf54+3AaU3QUjK8Z+PE0nxzU0HCylXBm8e4gArr/AgcIVrehc5BAfYnILYPvCwNN+B1dnfHnCiji78L1WokpP/bFdiwEdyqIPIl6oQ+Rw9es6qoPkTiJfK6OLqShAP7DIoWJUfw8yi8WgCDn0MnMnyp5RN0+XE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On Fri, Aug 21, 2026 at 10:09:07AM +0800, Meijing Zhao wrote:
> From: Meijing Zhao <zhaomeijing@lixiang.com>
> 
> The memblock debugfs interface has two issues when reporting region
> flags. MEMBLOCK_RSRV_HUGETLB has no corresponding name, and regions
> with multiple flags only show the lowest set bit.
> 
> In addition, memblock_debug_show() walks the region arrays without
> synchronizing against memory hotplug. If memory hotplug grows an array,
> the debugfs reader may continue accessing the old array after it has
> been freed.
> 
> Add the missing HugeTLB flag name, report every set bit including those
> beyond flagname[], and hold the memory hotplug read lock while walking
> the arrays.
> 
> With the series applied, a HugeTLB bootmem reservation is reported as:
> 
>   RSV_KERN|RSV_HUGETLB
> 
> RESEND:
> - Regenerate the series from the same clean base as v1. The previous v2
>   was inadvertently generated with an unrelated MEMBLOCK_NODUMP change
>   in the patch context, causing apply failures. No code changes.

I presume the changes were on top of linux-next and it's not clear how to
apply them before the end of the merge window.

Can you please resend the patches after v7.3-rc1 is out and base them on
that?
 
> Changes in v2:
> - Report set bits beyond flagname[] as UNKNOWN instead of ignoring them.
> - Add a separate patch to synchronize debugfs reads with memory hotplug.
> 
> v1: https://lore.kernel.org/linux-mm/20260819075422.2387980-1-zhaomeijing100@gmail.com/
> 
> Meijing Zhao (3):
>   mm: memblock: add missing HugeTLB flag name
>   mm: memblock: show all region flags in debugfs
>   mm: memblock: synchronize debugfs reads with memory hotplug
> 
>  mm/memblock.c | 26 ++++++++++++++++++--------
>  1 file changed, 18 insertions(+), 8 deletions(-)
> 
> -- 
> 2.25.1

-- 
Sincerely yours,
Mike.

