Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24E4E606A31D
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 15:23:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fAQB6H3O
Received: by kanga.kvack.org (Postfix)
	id 116626B05B1; Sun, 15 Nov 2026 10:23:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0EE696B05B2; Sun, 15 Nov 2026 10:23:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 02B696B05B3; Sun, 15 Nov 2026 10:23:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CE7366B05B1
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 10:23:31 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5075A407A4
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 15:23:31 +0000 (UTC)
X-FDA: 85437722622.06.703CAF6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 88061A000E
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 15:23:29 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fAQB6H3O;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794756209;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v8TIMiq73Mw5ReQUdV1tXDz4+sKry0oZWtUShE+0QUw=;
	b=7NEmMAe1bFk2F6VOlGISaaX0CH3fF66YOdB9rpEAPl3benQF2utc3NteRj/yi9Vo3Lm2T/
	UBNxL2Dg8pEAtmN/xTk4Z4UsjzTrCGOFczW9GYsQPIor4BLdkL1AgpK7r27E3qYO+jFeH4
	/TEJJOlV4HqjlrOu2CE5LxhYvWiuz6s=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fAQB6H3O;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794756209;
	b=cHcpRHhD7n43w4i62kmLyLmPlXclapu+iBOb2oevjmS6kYlYvv3S2UPxg0GF5g4wmXDKuI
	aH8nsBUg5C9w0YCvQ2GCXMKfI8ESrc+OiOe8+6ldIHXQWvGhGVqFvChU8OImZ7S7LcKSVr
	Y10+g7jpZP/GsLh8A8yQhw6smg4FnGo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7992E43506;
	Sun, 15 Nov 2026 15:23:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2AEA1F000C4;
	Sun, 15 Nov 2026 15:23:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794756208;
	bh=v8TIMiq73Mw5ReQUdV1tXDz4+sKry0oZWtUShE+0QUw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=fAQB6H3OHz6MhUX4o14L06zIdHxek5EYYUSe8L67TknIoIgOFFrvSKoXE8PkUoHAG
	 SNzqFF/b+7omJmf9eZNnEkrun6GzBdMgPXVdD+3YqUcPbwET/vKWMev2PSKPQa/iZK
	 EM5DW0eWMo+59T/M0uhbOGP/S8glmJyWXzOc0w9salYEV4jkvtPOdRdkjeVoNo9pBT
	 Q1ssqgET+egcv4GrSvaPrYDchm6tVUGoBvkFvBjjQn6ieMhns/YaKmy9akI8TvV7yZ
	 sDGRmuGwPVOkuh39SzzWXz+LqrU26yAHUX3d0Ka+7CC2AHNLBjX7VX5DFCF5fUAzOo
	 /y0qLa0tKDaCQ==
Message-ID: <sashiko-outbox-215629@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 9/9] mm, sparc: batch arch_unmap_one()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Dev Jain" <dev.jain@arm.com>, david@kernel.org, ljs@kernel.org, akpm@linux-foundation.org, hughd@google.com, chrisl@kernel.org, kasong@tencent.com, davem@davemloft.net, andreas@gaisler.com
Cc: riel@surriel.com, liam@infradead.org, vbabka@kernel.org, harry@kernel.org, jannh@google.com, lance.yang@linux.dev, baolin.wang@linux.alibaba.com, shikemeng@huaweicloud.com, nphamcs@gmail.com, baoquan.he@linux.dev, baohua@kernel.org, youngjun.park@lge.com, linux-mm@kvack.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com, pfalcato@suse.de, anshuman.khandual@arm.com, geert@linux-m68k.org, sparclinux@vger.kernel.org, ryan.roberts@arm.com
In-Reply-To: <20261115143905.3045084-10-dev.jain@arm.com>
References: <20261115143905.3045084-1-dev.jain@arm.com>
 <20261115143905.3045084-10-dev.jain@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 15 Nov 2026 15:23:26 +0000
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 88061A000E
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: ydwz14rd7wsn5bzs8a3sjk85ku93c3jx
X-HE-Tag: 1794756209-198992
X-HE-Meta: U2FsdGVkX1+Qpl2UisRkihmisrutuXMJmOens3KbBxQ28mBpFFBUM1OrclzSeYmBd7s2hfpbTfpR7vimnvVbHUkcI3MsHzekuotC7XWpppTFqXoAhyQCRLDdWibvNLb+2WNDwTihQkLbDUvrQqtFa9YucdLSSZHdl7vpJViPn5jSrKuZa2iA8Bv+T9wuq3UgLo/xWQbHxYLObjXe00r7u+yNMccQowt73tpZCTdOjqVUxaKRl1qSVRLSfhzdZHwsmH7MaYlh80JGZn3SqNSp6rT4vzwqCi5fhpU2mIQ+pKZ+72qRH6Aq+baSOtYP1i1Be3KRWqZ9GYNxoIRA4+OYu6pwhbvvG676vPLxddaQQeVpXmyeQuNPkOlqy3kv22AXJQgBAzG+OUNyYMKpKWdKOeoisuoyu/IkdynClXwH7Lco6U3wICrMvUX/Ad31pG/1NCaRGp7PagMw3l67H1i2MACNPvaNFVtwp/PmHHrcToBw0glhz7oDK0+zWjNx7zcjxaOauNoAb1ZIhYOKyvdyBFtEOAzQE5MP7Nd63F8yG0fdh9gHYtoeWr501p53B+JRFGG2YaepAlYXxHgVwR9OhxOgWkOLKXbPhbEM/Nt2CJTEdsN1PNAYvZkHefsbGOt/PZ4Jkk+S7XPipgUSCm7VOcM79CrLA/P88TDAlUiNvtfPXd+FzkNZMNbKVHq+10v1nOxqrp/Zc+uOdoiKVk0yMjXdgcUSkamWXwtXs8/cxDtOgrP+llb94k/vAEsdkXqNQnX1DvhyZKk34r/cwZFwoCtRHWZs/J6rYkY6dp3ZbkVHuHn6Ww1mtp0oZLluuo6IEXNcDH4b8Fq0lN2Vu8nmb/kI0ZyYok80gEE7pDXvDHGs50e4CF2lpApHyop5+Iydn89yseFGVmRdwhKpCGj49OjC9gxJ0g9sGT9fLClOs7TSE6WPc4LDHD2CWnBVHmXigfAwdnH/YUE5xRrg4dz
 kHuElTUh
 XE1bxURplILLrnw1WMuou+Z9mi4bWH3GEeqrKb4ykxm+pOw5cIc1B/gryPK9BW9cj4UUydwcEZFONtnGeT7cFb56MeXukov+TltUYVe8rXAHlMmmbQxGyzrQvc19Vxyb6bzXx5LqFCODkNperfDAvCwBdYifI32QGLgiB1WZRNkdbJsKqd9df37E2hvNfX7dcAnXLiq1ibcso86NVKwDsBnlpKIuqir5EGGvh6F9SG1tMnyBSEN1D5z1G06P7EfSBnN3XDpPOTZ2qaI/JEAQ01UIZAnCtN8fi1GBgztqRw/bmiVuAdUBI+VsQufE9NKXHbvHDP1vc/1hSKMetNny+/WTPAQiS6vf8klZUHdw7kqz9PQCyJYQsHwSNxdzgakNZACIakl6YYr8pawOkkTi7cpuzjIJITg9ZzwToDmefdIne6njqUxEkOkieV3upy8cpvymZdNyRp5/5kaUhkL5mkwe81XSAzyY0s+UmBAHdDs4680j2YR0kJbMscRZsvfYtGnIP/mau1nIDSLqrG3GsXuUwvpsBuO91CPuej2QpdippS/LVeMjkpd4ytPYvSrQe5L4XB7X0XP6wcTYPcYwWjTTKZXcLlZhwYGwyBwnTB/uzn9zExJ7rlSQbiqdpbX6cemV8/Kwk1UF8Jnyvhs1A8qD78NfpSxD5bUqiYS6cUXKwyOM=
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
- [Medium] sparc: leak of ADI tag_users and tag storage in
  adi_save_tags_range()
--

commit ccbef0704b88d6e8aff2c2f0c82f32d9131dcc3f
Author: Dev Jain <dev.jain@arm.com>

mm, sparc: batch arch_unmap_one()

This commit extends arch_unmap_one() to accept a page count so SPARC can
save ADI tags across a PTE batch during anonymous large-folio unmapping.

> diff --git a/arch/sparc/kernel/adi_64.c b/arch/sparc/kernel/adi_64.c
> index 18036a43cf568..ffa378accefe3 100644
> --- a/arch/sparc/kernel/adi_64.c
> +++ b/arch/sparc/kernel/adi_64.c
[ ... ]
> @@ -394,3 +395,23 @@ int adi_save_tags(struct mm_struct *mm, struct vm_ar=
ea_struct *vma,
> =20
>  	return 0;
>  }
> +
> +int adi_save_tags_range(struct mm_struct *mm, struct vm_area_struct *vma,
> +			unsigned long addr, pte_t oldpte, unsigned long nr)
> +{
> +	unsigned long i;
> +
> +	for (i =3D 0; i < nr; i++, addr +=3D PAGE_SIZE,
> +	     oldpte =3D pte_next_pfn(oldpte)) {
> +		int ret;
> +
> +		if (!(pte_val(oldpte) & _PAGE_MCD_4V))
> +			continue;
> +
> +		ret =3D adi_save_tags(mm, vma, addr, oldpte);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	return 0;
> +}

[Severity: Medium]
Does this leak tag_desc->tag_users references and tag storage when
adi_save_tags() fails partway through a batch?

Each successful adi_save_tags() call invokes alloc_tag_store(), which
allocates a tag_storage_desc_t slot (and its tag_desc->tags buffer) or
increments tag_desc->tag_users on an existing descriptor:

arch/sparc/kernel/adi_64.c:alloc_tag_store() {
    ...
				if ((addr >=3D tag_desc->start) &&
				    (tag_desc->end >=3D (addr + PAGE_SIZE - 1))) {
					tag_desc->tag_users++;
					goto out;
				}
    ...
}

If a batch crosses tag_desc->end at page i > 0 and alloc_tag_store() fails
its GFP_NOWAIT allocation for the new range, adi_save_tags_range() returns
an error without unwinding the first i pages.  In mm/rmap.c,
__ttu_anon_swapbacked_folio() then fails and ttu_anon_swapbacked_folio()
restores the present PTEs for the entire sub-batch via set_ptes().  Because
those first i pages are not swapped out, adi_restore_tags() ->
del_tag_store() never runs for them, leaking their tag_users references and
preventing del_tag_store() from freeing tag_desc->tags or releasing the
descriptor slot until process exit.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261115143905.3045=
084-1-dev.jain@arm.com?part=3D9

