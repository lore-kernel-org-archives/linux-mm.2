Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D233606A321
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 11:27:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ietIUcB/
Received: by kanga.kvack.org (Postfix)
	id 8BB336B05B1; Wed, 11 Nov 2026 06:27:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 892896B05B3; Wed, 11 Nov 2026 06:27:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D0E36B05B4; Wed, 11 Nov 2026 06:27:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 617156B05B1
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 06:27:08 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EBEC58028B
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 11:27:07 +0000 (UTC)
X-FDA: 85422611694.28.5310CD9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 3164040002
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 11:27:06 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ietIUcB/";
	spf=pass (imf11.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794396426;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3PMJZmw8MJh2mWVqw780qdUE6D8XJjqTBbqBroaGkaA=;
	b=YByCIeBuk2p4PpfqH4v93/Pj7cRs+l05d6ykwDnKxHmn16qgFzZljFGi/Z6laZLNGLTdbn
	+SCA6ScYTUK5Bo5EL5yRtdoptPchVvTburGWiXJWYRa+d17FnrlZwDV7UgW3P/KsEpOqbY
	5nrNPosjfoweT9vwHjQg1w1ciFgM7PA=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ietIUcB/";
	spf=pass (imf11.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794396426;
	b=oE61hTgveTOrQNdEbhAEN1pw8zzvckjTa9zLx0GgLL1N+FD+moh11+thrEia1RB4vfUtaV
	AFnU5uS4CNH4Cvf+pdp89A1z+7fr1TyIJuM6o1tT7Oil+2AS2cy2vqDxjKB3gy9XwEIQ+P
	Yuf5yl3s9VNNFFCHX1lygw3Uk5wLawQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 60BE541781;
	Wed, 11 Nov 2026 11:27:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 482841F00A05;
	Wed, 11 Nov 2026 11:27:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794396425;
	bh=3PMJZmw8MJh2mWVqw780qdUE6D8XJjqTBbqBroaGkaA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ietIUcB/kWR5VleMqsja0T2FGslp2EcPHF9zkbs6CWGG/rbSrFVAC6EGFkNFQ8RHh
	 uCCrm8WuKIVOkMYSwWSXfBs9uHjjf6ShymQJIbthifCCLALysO7MT4gzQi8AaiIm29
	 q+c96idAHljaZdqatwKxH5tjgZBsbmJnrWJ2gXw9uDujaKfuWCZZqtXjZ5YgQliacP
	 H9wZyyTHPVaC8ZwDwGde4bo39YOEOEi9yjXZq2CBNZG7hn3/QVDybEeWM0xcLav0Jw
	 2SsVeOM+7eN/k9PbIRWExlAK5zTCyf5xCmViHxzQqo6BB7dMsZjfolH6aP8su1EQea
	 07r98Ebv5CPKA==
Message-ID: <sashiko-outbox-208876@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3] mm/highmem: refuse to copy hwpoisoned folios in the
 !copy_mc fallbacks
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yuanhe Shu" <xiangzao@linux.alibaba.com>, akpm@linux-foundation.org, david@kernel.org
Cc: =?utf-8?b?SHVhbmcsIFlpbmc=?= <ying.huang@linux.alibaba.com>, "Kaitao
 Cheng" <kaitao.cheng@linux.dev>, =?utf-8?b?R2FyZywgU2hpdmFuaw==?= <shivankg@amd.com>, vbabka@kernel.org, ljs@kernel.org, liam@infradead.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com, linmiaohe@huawei.com, nao.horiguchi@gmail.com, ziy@nvidia.com, wangkefeng.wang@huawei.com, tujinjiang@huawei.com, mgorman@techsingularity.net, chengkaitao@kylinos.cn, muchun.song@linux.dev, linux-mm@kvack.org
In-Reply-To: <20261110112641.1196786-1-xiangzao@linux.alibaba.com>
References: <20261110112641.1196786-1-xiangzao@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 11 Nov 2026 11:27:03 +0000
X-Stat-Signature: c5bs5ikjwqjn7h5r6xx3z4bb8hfidq7p
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 3164040002
X-HE-Tag: 1794396426-624811
X-HE-Meta: U2FsdGVkX195hoCY3DJ/mkL3UHJoi0ZDwyJOL6+5fduKWkJ293Dtr86Td/xalGeNgKT08ZzL/0vteWqjgo0Phu/9yl1ecWpaTg9WH5BxUAYtcroUh0gtv/1zwD5k5XnZ6lk52p/L0uTi1hqSiVBlC7gf6VMyfVdPiyhjP9CuapIOQPfpjfx0VLD5YvMBm5ykPly0uUF8bgM83w6Yl9WAwuDCBprE7skBBHzuulcFmLtg8gWhTB1MY/GGEJxYyD7U9LY/d4+cITT1zdnlwNRTQe0XUocKz2GKqq2eXVUZEH8gW8oDd1wCk6zzbjfvgsJeuKMLe6vzgcwOiORXj6YZ6MufbTgsGn2aiootVl2zNKKFVJLwhCezdqRw/ruJZ5+3+KwNg4AK0QMUGCQoanqwC15HzaH0OQqx8d0ZgzdyX6j4zIeyOeisJETHzToXhG8MSCJ5yzDVp8XW7kbnQiGCsEuqkLCzq1EfudyOoWo/j1YhgXNgSnl8diQ3ebus0wK0zt3M4DGl8xqKyDA51dYRYHS4Q8xO8A4tyxdirytQUWm3qv/PI6UYN616wOvS/xiciTLKEJ+USshOxntG34DxDIGlIrweylZ9Bc/HebZGPc/DmvpYbiLtwiLRRKgMzVTD2n7WqenU8RWPSRPb9ypnI4V6md4XOLbVZMvwlRTFf3vMTvOr1QeIThO0TuXtNcXaTMn0SNvWdvOFg/meJR80wwiaK4l4xYgE1TGfhniCal/lQ1bnbL95lQMntkm9t486BLu+1OYZSHGcaRIdmWuubhWfS1N+YWv3gcdPQ7lLyO2f4553L6iOkdW6CMZ/HF/A1CpefNe/LYH+vGX+R32HnyT2yANNWdRzJYKckIBlpuzvtsshMSnGQn2/4XdkoI0P3uesRUwfYs2oAbFy9dm+WU9FXOi+sXHFeFTYmQ6LUyYTnkaIbce9pjJrAH00GhOD5TlW/Yb4rOmtwgW+xUd
 i9ZIpQdp
 TVPdT/NuJA21mFwcB1BcYJTYIfj8/kBeaelqWvjIKWkUp2Xu8Jn79lMoEdJPf/G1jqoLGmQVCnKz9+2wz+FFUQK3qT/RwfCWx6G3jQbg9d/8bdXzHLpU7TZKwZ7uTX5y7unTKAz3Gac29wtkgkzHySxIIvgeVhojkUp62SUUSd3dlBQ4Gd5tRRjXJJT/O2/9GmDJLA1y/YSNGLsRwDsBMQKNKwwP9/sNSIOD/RRnMq1NHaLiskEcdsf8BwurH8dJFU3AyzJ17l8WK09MxxQB5D2pIgl3VDO/IdjG4gCKDxJwGeGi6MvEq0vJBOtMCjwta0jtX2/5b3uC1NRfbWiBwb5/ckz1HUzeXhLUg7nHGdAsuCALZcYNU0zngH9/ApGICw7OcKZ6e/crXdYhJMhQ9W4A3n6XFw71DMzcQNw6+7+cM3rRPMod9yUKYrj/1N4d+xodNn6p44KfzdQJQg09dMR8arHJuyYTkTDoINaZks1A3gPhUj1yQ5VPoYJ7CmLwDJ+1BeYh1mNnCGgeaTAgay0U6/cYC+1O+F3tVRHhpu7J4n1uL3R34/yGbez7McXQVYZDJIbQ8DxD8Nx0TlWWlZUz/kgJEXoGEe3cpvmBfhyLC3P9mqLebq8y9pvV+1Oy7zzCVqZ/8ril8TYsfbgUFWjIBP9Ss4nmo6PInA45sCu20DQAtBOexPRkNMdCSMnTb7waXbwY+kWSJru+xRdHsQBz2LVHaD1LJ3QOZgV5YxqxKNbeW0+ORwDnI6tFrKy7pImq93sVpu6lqLcDc71cOgEu8SOMh5UKjv1052tdiACSh5EHoZM8P80WETQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] mm/highmem: missing is_page_hwpoison() check in
  copy_mc_to_kernel branch
--

commit 5b18d6f721e579b691687c6c8c6355f1e1a00b17
Author: Yuanhe Shu <xiangzao@linux.alibaba.com>

mm/highmem: refuse to copy hwpoisoned folios in the !copy_mc fallbacks

This commit checks is_page_hwpoison(from) in the !copy_mc_to_kernel
fallback implementations of copy_mc_user_highpage() and copy_mc_highpage()
and returns PAGE_SIZE when the source page is marked hwpoisoned.

Link: https://lore.kernel.org/r/877bjowf9i.fsf@DESKTOP-5N7EMDA/

> diff --git a/include/linux/highmem.h b/include/linux/highmem.h
> index d7aac9de1c8a4..c3240f70471d5 100644
> --- a/include/linux/highmem.h
> +++ b/include/linux/highmem.h
> @@ -473,12 +473,18 @@ static inline int copy_mc_highpage(struct page *to,=
 struct page *from)
>  static inline int copy_mc_user_highpage(struct page *to, struct page *fr=
om,
>  					unsigned long vaddr, struct vm_area_struct *vma)
>  {
> +	/* Don't touch data that is already marked poisoned. */
> +	if (is_page_hwpoison(from))
> +		return PAGE_SIZE;
>  	copy_user_highpage(to, from, vaddr, vma);
>  	return 0;
>  }
> =20
>  static inline int copy_mc_highpage(struct page *to, struct page *from)
>  {
> +	/* Don't touch data that is already marked poisoned. */
> +	if (is_page_hwpoison(from))
> +		return PAGE_SIZE;
>  	copy_highpage(to, from);
>  	return 0;
>  }

[Severity: Medium]
Should the #ifdef copy_mc_to_kernel implementations of
copy_mc_user_highpage() and copy_mc_highpage() also check
is_page_hwpoison(from) before mapping and copying the source page?

copy_mc_to_kernel() only catches hardware exceptions raised during the
memory read and never inspects page flags.  On architectures that define
copy_mc_to_kernel, copying a page with PG_hwpoison already set while the
underlying memory remains readable (for example, an uncorrupted subpage of
a poisoned hugetlb folio, an asynchronous patrol-scrubber notification, or
on x86 when copy_mc_to_kernel() falls back to plain memcpy()) still
succeeds and returns 0, silently consuming the poison and leaving the
destination folio without PG_hwpoison.  When the source page does have
physical DRAM poison, reading it also triggers an avoidable kernel-mode
machine check and queues a redundant memory_failure_queue() work item.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261110112641.1196=
786-1-xiangzao@linux.alibaba.com?part=3D1

