Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5FB2C44501
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 18:58:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 968BE6B00A6; Wed, 15 Jul 2026 14:58:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 919C26B00A7; Wed, 15 Jul 2026 14:58:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 831316B00A9; Wed, 15 Jul 2026 14:58:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 549FF6B00A6
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 14:58:57 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D79CFA0301
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 18:58:56 +0000 (UTC)
X-FDA: 84991923072.10.24B2014
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 96C464000A
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 18:58:54 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=vJEETtdd;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784141935;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fqHHwO7JAlURhQG4Jw1SHv5Ft9ovtN2t3y4hVi2W09Q=;
	b=nGryNtvGM7ViK3nsYtsqoa91Jn0UUGs9SLqaP0/81Oyil7psb5Cz19b2pWsolwmWjGEPTi
	VpoYGFeMoCKZOiXf3Tvq8gpzr60FPpdNg4UT7xtoOxMpeAzKBEoirm9FV/Um8XcFofbeWh
	zIbJ9Rm3Mo5aL/Bh9YDXIC29zW4VRKg=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=vJEETtdd;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784141935;
	b=FPC3tA1gvdJF4toyI3e76d/zsM9pMO10ZySHu7JNaJC7mbMUUFsQcrFkzJI663XF/fBA5s
	ptEOK+AAdRtEjDk68VAaDJKaUL8WqTsYqjkqahszwduo1dChBXsuh94fP/fgpzJbUGBr4Z
	A087VQTUkGE9ceHH5+c2e05Ek/JH2E8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A3A764166D;
	Wed, 15 Jul 2026 18:58:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D78A11F000E9;
	Wed, 15 Jul 2026 18:58:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784141933;
	bh=fqHHwO7JAlURhQG4Jw1SHv5Ft9ovtN2t3y4hVi2W09Q=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=vJEETtdddAlz7+EIMGm4DFsoK2J4nhFAUDgu3sHei+wYslXrtYTuv0lfjA0KOc7+L
	 MwOHC1I9bfN82KG/UdpfdjP4uSeUx+hjAphiy6+RoyU2R2IFNSs7V2RFgeYVnV1WiG
	 3T4GGcwtZYgqkZHsFtD92xJe+vpDNX8rNcdU4WyI=
Date: Wed, 15 Jul 2026 11:58:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dev Jain <dev.jain@arm.com>
Cc: david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, kasong@tencent.com,
 qi.zheng@linux.dev, shakeel.butt@linux.dev, baohua@kernel.org,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, riel@surriel.com,
 harry@kernel.org, jannh@google.com, lance.yang@linux.dev,
 ryan.roberts@arm.com, anshuman.khandual@arm.com
Subject: Re: [PATCH 0/3] Batch unmap of uffd-wp file folios
Message-Id: <20260715115852.a32e472d97fa182d6a5ee482@linux-foundation.org>
In-Reply-To: <20260715111839.1667914-1-dev.jain@arm.com>
References: <20260715111839.1667914-1-dev.jain@arm.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 96C464000A
X-Stat-Signature: r3ttiid5er8trxj13fuih63h8p8744xb
X-HE-Tag: 1784141934-904877
X-HE-Meta: U2FsdGVkX1+z3G+WJMrajroipN+AR//1SdUqTjx2YuNGZ3rKYveR94uCkz+fD3YKjNu3uNvpF7XXLv+BRfu8rY8frJWJYZQtW+h+iXzPzqGEjgnXMrW0VJc0YFhZoCyuHSNCLAceTbT76AO/pjb464zCVnOwehZpUMd4k4iTAAxmlJFb3qddOEQ7vtAAPBzY8yQl9xOOmpg/joTDKZlICAonCu2y5z8eBlDUjFmrG/Szw2yxTUv15c7835jcsQhbEBsipsOrZ2OrmtZvbYwZyiZP0/oulq9LFMyzmGJ37S/doQiXKslwzofjoMKJEeE8sieGeUWAAL0rAooQoov5APeait5EG0u+LuqXyfaSwWvTzxC17vnR2AgAmlPwRE41AKn5I/Si1DSSxmkncGDG7eeqZrOmetdXywDoT0Pt0pnG8jJH+QWLnIhc0ND+OwMHhdL8w+Fk0jJRKqD//zLTNTKxkiOiysIbsvr2c/ilTbLCWL3jvvnd+tcS7hS1FkCZkErYkxVVqHWP83lGZFLFn4nPcPb8IxG19z+QFCetckVFTNucjAo8b6pA37NyHnd8IcRGGhGij3ZtnmUcZGBYZABNwf2JVIpwoX4X+JFgsCEpK4uc1R1++URBDnQdP6B4Ip93DNy0v8v2GI4+apAHYL+hxMhjQ+o9bOI66Mv80qf/iFuHngmxRNBS1vBumcgp87eAC0v2/WcAr2tb1bt6t3HCQu5NqK8VpNVM0PSt7qJ9Kt3/ido6TWFxrCcp3l8Z3LZabpPv1/MpZdDaKLU+KZu5phLZPlH8U8Rk4feOTVeGlH6frZQQi5zd6gipi72TfUea3s3ELdeOJQlzzzgZmOUrsAjcIEiB3ZBnGdrwFjQgSFyy9ca0mdnsSC1ueL2fHmi0Tp2lllXmyMU36swBLka8TDd5n1L56ay8sBGq6M/xbWM8oAYDFj3lreiBhqbbinQvPFMHkXrOV7Epgx4
 si29Lseb
 GckpXhqhrvhllCI3FU+cD++tVrlwE/QFnO9bjJRQMNIrnEX45aTpF2bTDhWERCzIaBdxfHeYdKzUwWaBq7Bf7cLK8+Hrt5hXDI9u4kkWAkCptdbcmXxiGHVyHQRCRfv5rzuChr9b3TvvpELQSCJFaWqJmHJsgU1xhQdkQsSiBSvKVpOM3hlEz4SDJJ3vb+o9CBOU7uJA2nEpbdvB/6m4cf6PCpJjd9kf1x19PUIQHLwmyY2VX1Y0neycdCZevBKSMX0lxZuZQnXRtazFhp56fhRCr3W9jnED031GBhrcxdd+hAcyZXFJqEoYg7Q5kYOadGysGxgE6E+IO/KXrvAPrUjzzswQ1brnVC20U2ACzHcAdDI6v9QIntcC/2w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 15 Jul 2026 11:18:33 +0000 Dev Jain <dev.jain@arm.com> wrote:

> Currently, batched unmapping is supported if:
> 
> 1) folio is a file folio, not belonging to uffd-wp VMA
> 2) folio is anonymous and not swapbacked (lazyfree), not belonging to
>    uffd-wp VMA
> 
> So the cases which are not supported are
> 
> 1) folio belonging to uffd-wp VMA
> 2) folio is anonymous and swapbacked
> 
> It is easy to see that this adds a lot of cognitive load while reading
> try_to_unmap_one - we need to remember throughout whether nr_pages == 1
> or > 1.
> 
> The uffd-wp handling in try_to_unmap_one is regarding preserving the
> uffd-wp state for file folios via pte_install_uffd_wp_if_needed (for anon
> folio, we handle that while constructing the swap pte).
> 
> Stop special casing on uffd-wp VMAs by simply adding batching support
> to pte_install_uffd_wp_if_needed.

Thanks, I'll await reviewer input on this.

Sashiko might have found a pre-existing issue:
	https://sashiko.dev/#/patchset/20260715111839.1667914-1-dev.jain@arm.com

