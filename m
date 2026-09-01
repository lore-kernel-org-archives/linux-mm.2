Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A44EAC61DD6
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 16:14:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9110A6B02A6; Tue,  1 Sep 2026 12:14:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C1F66B02A8; Tue,  1 Sep 2026 12:14:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7FFC26B02A9; Tue,  1 Sep 2026 12:14:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 57DE66B02A6
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 12:14:40 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C4D30C0481
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 16:14:39 +0000 (UTC)
X-FDA: 85165691478.14.EE898A1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 2DC5A180011
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 16:14:38 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Q0DbHTsk;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788279278;
	b=mk8zCu0b+zX/koutkJuTp2/Nkz85bH3jdXOdhdWqtCyEbfEJF+Z7a35i+8zNTLfhNubiWg
	MwR6YCamvH09IunL2SVMuSzGtSCUSD4r+x4rGCetzPhcAIZutiERrS7R0OE1vGhWHD44G0
	Qp4e0t2mlxeWqtidX7U0gsfS7ImhETI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788279278;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wVIPpiyauyiMJEeriZynPazSRkDSGB9FU14zxWlXue4=;
	b=T/q7OllmLDISHT43s6TfxEZ1NgUp+c5VHD8qx6wHWrBngCXe27EUZXLPWoHq7pgtTrEkmL
	YBxtjnc8nky/KfonU31+zRyQW3kij3RedcO2eGNdZI8NOlBssEqgs4BSJkO+SKq8wFAok4
	2RpgfJ2wUHyDy0qOc0q7KbXakAw1jx0=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Q0DbHTsk;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5AF9B400EF;
	Tue,  1 Sep 2026 16:14:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFAC31F000E9;
	Tue,  1 Sep 2026 16:14:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788279277;
	bh=wVIPpiyauyiMJEeriZynPazSRkDSGB9FU14zxWlXue4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Q0DbHTskfK/uEYRE4qw71FiJX4S5XMEW1aapCuuTjnY3Z915y63gZOgdxcoT0nlHi
	 gMGXbFStglQscVrcc3kIcn5PmuurUAQ/aCZ+HGKvVHWhvsS8EicnphyuajEvWWnndP
	 wc/OPVPUdyC0cgHFk4enf6r5QGhgw5Tbnvq70dLC0u9gKr0vgr7XYBSx+9DMduRPk4
	 XE84WmClikii3Lkt15xvhvWs89hSgjA+f5CKW17P625kYpdB1p+NNhSu9W3HVUiPB0
	 IEryfoBGX4NK8z2amc3iJbPCZt7EiMYsEc/0nRXjl5H4aOsQc1m0+qye2oOKJ2Znvv
	 s7mhsloGj8EIg==
Date: Tue, 1 Sep 2026 19:14:30 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mm: remove unused mark_page_reserved()
Message-ID: <apb55hq9Xi1gruAK@kernel.org>
References: <20260901-mm-remove-unused-helpers-v1-0-f092d086f7dc@columbia.edu>
 <20260901-mm-remove-unused-helpers-v1-1-f092d086f7dc@columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260901-mm-remove-unused-helpers-v1-1-f092d086f7dc@columbia.edu>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 2DC5A180011
X-Stat-Signature: u7n1hi8tgt1z7nhjnfiedw9jjai4wyj5
X-HE-Tag: 1788279278-636325
X-HE-Meta: U2FsdGVkX18BGtRJk+tq4PiStR8aLe+nviVrd/gdSvUgzm6EriF2M6n9GOwZSICnKe0a3LbEi56zqU8EYGfo/5ku/Vj464cj1OXT0ynEW/4LgTzSvtSagb5p0Ri+Ww1GMuRcwRq6oeiPm7vWES2r6RFUK7mt9abHZ6rP9/2p6D40YEOtMp9LgXnPPb84uxFsJrhnMOV0cL/ECQku15MwgxP3OYVrpT64xk5IFRuuxyqeZrq5ZQZDHfaB7dNMptY87GcveEWY9x0FTkUb2dpBxOicb7Mh5TEdgMT+VyproAAnfZywjnfE3p42eAsuTI5Td7n+Rw/ZZNfcy1j5fVY7ytrIjPI6Ja+kbj4u35G5wEhDjAR7N0d3Cr2lrhVHyKudMfxMZVt1Z9HgABVDkL0qFLhxSrUuVe3whJ9Kr6/MEFjgdCdZiGdWo7wNmkQ6dIhmDeTfUYTiztwscbGZQCEMP2dgrthFODNF4wHd7UnIEZzaF+3EwMv6NikIgaKKhd/MGKHAkbIGTY4MEqZMxq31XHFph/DXcHVr7BH12SfnihisoPdkIU3WcE2GvhXfuvAfKdvGBX3MqfvWpsMUsRam4vg+KlekJHU96iVcmzbdfuB1Z3y3w3/jwwOdmgHFDcUx7oiUKbEDI6htHfO0D6Il6GRlWQ8tPYa/wD3UZR4mZZcBHCHdfIDIpNQafADbuqGN6xgjV0VwrNN92Jj/DDqwtLB+Qc44ZW554QDjkxs7mnq6dqmo3b15dg/5r/VsFHFf79l+A2JBIhmLurKU5NMGaS0BKxvYQMJYpsrjessJh/1phgDfTWURwEmH4NZL7hM/iJ75fZWuQs4w0fcM4tDr2zXGu4lu+/zBqtzdcWCXg55GJe8uFOHzTZJoFNXS0i20X/l2qCqkzQcsn51aZlezyg8NVtObSpjLYvD78s6aREI6th8ZJmWJNaVcEmoyjXb3zhH/G6e8S0QZaEtODMI
 9kYuKNee
 /QAfOqB3nepp2kfLQ/lnx9lJmGChozjJVTYAQwQs34au7PhyG+nx2ld22rwaGxOam/eK6+ISR9TnfOu61DYkkZlSDZwES0WABBX1aDDjOs4K3Nzl3yK1yZWqP6e+cqW7Y3mw0hVbBHZpdukwuyQg6UxAaG0OVj6u1OIluRCpBt3dZ9FzbZG86iyI1ztR9v8l2gyPJcR40a5gkr1+hAviCEsNGgVIVXpBEAyIuvZRX2fbjc3bbTrannkuXyp60SYRmCdyTn5Yt7dwe8ifMfal/82o+X9WypZG/Gql2lp6ryFuNwkqdPzpV5bnrMhQy2iv37LR59LkzpKsdTdw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 01, 2026 at 08:59:19AM -0400, Tal Zussman wrote:
> mark_page_reserved() lost its last caller in commit 6215d9f4470f ("arch,
> mm: consolidate empty_zero_page"). Remove it.
> 
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  include/linux/mm.h | 6 ------
>  1 file changed, 6 deletions(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 1b28e6fc8d5d..e3736c42c4db 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -4080,12 +4080,6 @@ static inline void free_reserved_page(struct page *page)
>  	free_reserved_pages(page, 0);
>  }
>  
> -static inline void mark_page_reserved(struct page *page)
> -{
> -	SetPageReserved(page);
> -	adjust_managed_page_count(page, -1);
> -}
> -
>  static inline void free_reserved_ptdesc(struct ptdesc *pt)
>  {
>  	free_reserved_page(ptdesc_page(pt));
> 
> -- 
> 2.39.5
> 

-- 
Sincerely yours,
Mike.

