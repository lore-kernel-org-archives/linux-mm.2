Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D21DC43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 10:25:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C6F36B008A; Mon, 29 Jun 2026 06:25:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 79E256B0092; Mon, 29 Jun 2026 06:25:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DBD96B0093; Mon, 29 Jun 2026 06:25:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4EEC76B008A
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 06:25:34 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D5B26A0662
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 10:25:33 +0000 (UTC)
X-FDA: 84932568546.13.8958AC5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 3BE88140004
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 10:25:32 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DhUImxg7;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782728732;
	b=k3141FtAzDaiKQXKcc8oGaex7uBSZujhrzg5V32RXBnQHUi2kp9BIsiUbLZmeGmUbG05jP
	7T6y8wdPXDVxNYEUSvuh7Bu967c9oxfzcLdx5gwcWCpxLuP+8PfDnB2MFGFsqmrtllNhXH
	KalmdIr2hP2bwkFjCppmf0AWOJ4Gf+M=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782728732;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BeIO+hIAQvaGLJ/XUNN2YFChYOaCahefr/d5SYoOtTI=;
	b=KdAeNSDGqpJ+4XwPwV/4Vn0wha3DmVL154wXXNOnAn2eYR7YocbiXI0GU2CnQT+O/C0NEp
	I2K2kXdCe4qGUymttn+5H0vMT8b/3VsiHuP2Ry7SqQ23bZalt4zRKuW0oWJDhCNJ2VWdNS
	wUhFeIG88rLxde7JXCVnZDzEDDplkBY=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DhUImxg7;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6967243B37;
	Mon, 29 Jun 2026 10:25:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2036E1F000E9;
	Mon, 29 Jun 2026 10:25:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782728731;
	bh=BeIO+hIAQvaGLJ/XUNN2YFChYOaCahefr/d5SYoOtTI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=DhUImxg7uy1ylGTJH2tK3/USdiivBHz2NVrp8flUbson/mp+NGtRmXJivIzZ+u3/3
	 P4mGxdcvktZuOVElq2/q5uk2PqT01cmh3c+gB7zf2MGKQv1aXEnYp2+HiMlIuPet5n
	 WaDP/eveGe0Kd5IFbw58/weduZNYzADaDoJVe9wuEMbD/rwf8pw88RwzlE7limb7la
	 tpxXCOEwoZwvx2kCjY53cBbFOfeblPiArcNzUGzeYG4uUBuRNhUUPjqAva1fn9BuZQ
	 /Hm2fJDTccG9xCgom4HFKEeVPa7PFK+cGRFMAOJqDACXteBAZSTY2IH06XIKS9udey
	 yFkE2TUSxdrSQ==
Date: Mon, 29 Jun 2026 11:25:23 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Ethan Nelson-Moore <enelsonmoore@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	David Hildenbrand <david@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Pedro Falcato <pfalcato@suse.de>, Anthony Yznaga <anthony.yznaga@oracle.com>
Subject: Re: [PATCH] mm: hugetlb: correct CONFIG_CGROUP_HUGETLB macro name in
 comment
Message-ID: <akJIBNv36YtDRsYj@lucifer>
References: <20260616000135.62815-1-enelsonmoore@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260616000135.62815-1-enelsonmoore@gmail.com>
X-Stat-Signature: qtpxaerwbfbkkr7gkf4udbfhdzbkqanw
X-Rspam-User: 
X-Rspamd-Queue-Id: 3BE88140004
X-Rspamd-Server: rspam02
X-HE-Tag: 1782728732-667929
X-HE-Meta: U2FsdGVkX1/OPCDsl1iXbb8op/cOzG8grN7eenMW1bwf4GC24YPLV/RWk2lt26X5RqAWuroIWPLXiMbZiauAKRFyq9p+nrGl2JNA7mM93WFJz8Q27mXpypoFE5pTRKwes1GxK86Fi13nYtGUSFBEJELqqzbutElwPIHxXRx9uMvieO+V3RPgXL+/hs4d4JyP8GapmygMbyZRPxZdFgYUItEzRwJqfLez+uQHaoBoVZHizC+Et5RBIr4sJLUom7cR8/oCBycqhGx3eXNrKbwsiV8MYaoZSpcbupSXg4Q8BoMO1Re0631CH0FpPvh9M5A/gaCoua02o6zh5rbccta60fqXOyRpbs9uu5r+EUtbNOmTQA4WnaJaEGUTYuSJ42HypwQGY97v/VKbcQJCMUbBvfJMosLO52RX4TTYj1WfVaUTGrWqMNvkSpBxeigB2TfFE6oks1aIFJWJl2HwnrUCjcQTH6+lRMAVQ4ymrHGg53Lb2LzSADyzFghIanqM+uR7GLpj3UnCuAFNFn5BAaToH58WtUnDRGY6Nrk58ojwZwLjQ3xobMQN1sEPjVC7jOvIjRw7M5DI+Mo+mJDuPXroHHAPLYxQGNEjFUz5r7QHeUS/8eCEGBec0bLbgz8kA9DsxXV7OIRhQgdJiqeAWjdvGu9P3IQFXEA6bsvG8Z7VwrzfF8jWvJJOyrp9i+MoFE8QghKjCveF6VvltWdNgt40OrnHwE8ec3v34Q3RahHQkfhftZwSAtJ+388GCFQNlMwYfD7ymBwyuH1pxtG/OcSCtxHav93JYao3KkRaWP6LdUrsjG4oZ7OvRVl6M12xPcyfLmdHt1PBHiq8kSRAGjL0uJfJk6+CY8D+h1FdaGOMA1mzfQXWHezOY42EUOIZ81naLJ303ISQWYd27APygBOzZatSwhuhVaGFh+05k9rrXDizEpoy5zJ9tA88tUT9yNZwLfVmd0rSApzbBqrqgWY
 RaJWrQhv
 uead9TWI2H9vXpEU0wQ6uaHudCBPvtYYTwpbopx+Lr6wj67w9lBG0Rz5fKlIJDnUIHwIyiZwuAtV16Qq8+D3w17q3EiaM6UiKbL+xdiWFb8jHbaVuV5Yy9F/ESoRzknh7iqnUmSMc4QRWOUZFHLxX0KNP8kQRg22W9Jb0yIFVO4wYAVO2NmbPhSi8jbe3Xh5QvEeJkWcjXC2iGobuwxBzu0N9iRq/mSpVIFDBIWhf+9mtlnyFaYHbWwUduMpHBRGm/xbPkT3xZbBFI/wAufhZgI9OPZc40kVM4sRQQa0zz2sE/5a+DMKFlNIYwe6+rsTTDMyj25xQiz4PXeXhzCeS90nD1dtpDdkHButF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 15, 2026 at 05:01:31PM -0700, Ethan Nelson-Moore wrote:
> A comment in <linux/hugetlb_cgroup.h> incorrectly refers to
> CONFIG_MEM_RES_CTLR_HUGETLB, which has never existed in the kernel,
> instead of CONFIG_CGROUP_HUGETLB. Correct it.
>
> Discovered while searching for CONFIG_* symbols referenced in code but
> not defined in any Kconfig file.
>
> Signed-off-by: Ethan Nelson-Moore <enelsonmoore@gmail.com>

LGTM, so:

Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>

> ---
>  include/linux/hugetlb_cgroup.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/include/linux/hugetlb_cgroup.h b/include/linux/hugetlb_cgroup.h
> index e5d64b8b59c2..16d72c8c71f6 100644
> --- a/include/linux/hugetlb_cgroup.h
> +++ b/include/linux/hugetlb_cgroup.h
> @@ -267,5 +267,5 @@ static inline void hugetlb_cgroup_migrate(struct folio *old_folio,
>  {
>  }
>
> -#endif  /* CONFIG_MEM_RES_CTLR_HUGETLB */
> +#endif  /* CONFIG_CGROUP_HUGETLB */
>  #endif
> --
> 2.43.0
>

Cheers, Lorenzo

