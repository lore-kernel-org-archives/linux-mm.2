Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D19D1CCF2C9
	for <linux-mm@archiver.kernel.org>; Sun, 18 Oct 2026 15:41:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C07566B0088; Sun, 18 Oct 2026 11:41:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB8EA6B008C; Sun, 18 Oct 2026 11:41:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA82F6B0092; Sun, 18 Oct 2026 11:41:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 84D686B0088
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 11:41:42 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 050071A0553
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 15:41:41 +0000 (UTC)
X-FDA: 85336162044.22.4CE9F6F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id E796FA0003
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 15:41:39 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=U1176V34;
	spf=pass (imf25.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792338100;
	b=amhCADhrAo7xgRPJEBeBXRete2Wb+P1PF+5l5T+WeaB5nRm2MsdlTNhv7b2thEo5YoJPse
	8XWQyE93EuzgZd64CErl+PLfh+91VvlXuvkuzJplnT5Rt58tFfKneoEWo6Ftgsj2JiqW3D
	TqkYUXe2VaMP09LoB7n02xPm6JT7mw4=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=U1176V34;
	spf=pass (imf25.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792338100;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Uglyp32hrBI+mISzWFe7c9mM59cwP0mKFb7avVVaC88=;
	b=xp+ahYqMrcLUxRdiD7tl01opnZdzypk8uIMQ1IJJ3Yq0Wbu98VwoIRCBmqag34Eka4/dff
	tzgdBuCfUafmPKkICloDzYCVMV3VK77wxya2X55Si+BQRxEUtCTKbL6L2h/uqbwjUkmjuS
	fZE7Z7ouxGuKJ9Ah/y5UhV1ERttrTFo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5D63A42E04;
	Sun, 18 Oct 2026 15:41:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01E101F000C4;
	Sun, 18 Oct 2026 15:41:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792338098;
	bh=Uglyp32hrBI+mISzWFe7c9mM59cwP0mKFb7avVVaC88=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=U1176V34VrUIygXi70+hVY0FRS5RikaakgGM6CbuRDUp5KMLH2rf9TZTrk5rt+rJB
	 PIzORDtgDD0Ccgt6DHzZ9pANKJJ+rGc4UwQBcZM2pN2A57AZfisZecu4yN9Rj32Zum
	 EZddOXWHus5RgJpqkCQsUeJ0vmlk8uOC1HX4wkGk1zGjzJoafDSzTmYfUHrFNEu/mo
	 7LlOHz3nvnjXgekKu3F6JIiGBIIo+7/lP1964c1ZVQ9/xA7t3Vm5TgpL7uhwgLc4ot
	 yTxK7Zm2mkIvz54jUx0t4zcabvDecCo6bdA3UwUG4hcklzmQRiSWpwLr6oMChBttiy
	 W646UU2UkG1gw==
Message-ID: <sashiko-outbox-176238@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v1] mm/vmalloc: read vm_map_ram block regions from the
 requested offset
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nickolai Zeldovich" <nickolai@csail.mit.edu>, "Andrew Morton" <akpm@linux-foundation.org>, "Uladzislau
 Rezki" <urezki@gmail.com>
Cc: "Baoquan He" <baoquan.he@linux.dev>, "Lorenzo Stoakes" <ljs@kernel.org>, linux-mm@kvack.org
In-Reply-To: <20261017154120.795844-1-nickolai@csail.mit.edu>
References: <20261017154120.795844-1-nickolai@csail.mit.edu>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 18 Oct 2026 15:41:37 +0000
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E796FA0003
X-Rspam-User: 
X-Stat-Signature: a7pm96k8ppdjyrx7c3xhk9jga8kp3qf7
X-HE-Tag: 1792338099-567026
X-HE-Meta: U2FsdGVkX19T/sQEohQswF3mgxXs8ZqmmKGvXU9rZEjp0AgjLV5hxRoYcSpk3DmF1o6QVlnFtZphcvNgPO3RFbBBpSKKyTuNMAy9hy7U9U1N6LrPIpw4JyC+6QJBdIUz4AIqcyepRQmVB2N5MjLweVlfd+J6DYUa6CfjJK82YZ3k4qMhlY8kuz2ol1BxAeC+zMiZzdktKge79DR0lSKL7r+fZszYfVr7yLjf0v138pOJzkWGrWiB8YpJOd0yJBe0Y+itdBlG9ZasTYso/RJED3qAlsZ4ZuuLFIUGo4TM605wYxqY52OyYRgk71DlIWDNL+qIL07zaJgusMRc60Z8h8LDXweixqolg1QWzOAXwbRn3hnI8Qm9GtIhaGm+XufXCKBwq39YWB3GM4Y7k3vy/HWGJLDuLGEFrdAwSp7tVuJWHjdsGYujbrMH8fxsrt+WkzhvzDIDKYH9hOnd3Xe6Rla/RuGqlAOHAehS26GASsMTeujk3EHc4pCXgnMbLvrSZMdRZn76jy+eufoIIWZvl/9+1qg0ou2RHDlQkJPszQACV7X52bBIRvGjspxhm+VGzfT4IXsL+/+aggZPHG9Um7Uanlm7xsu8pEVtiM+AHZDXky+vnlfvKFTSxRTAAxkqrMTnQQBE88wBNVhVEM3fUCVhSu4MFTFSEkGKdg4gxTCLSC7iDL/mz4bJhhCFy+RZnzAa8lWVU6gFpuEevC4o6XxkxG73Gh1cSrdGdsA2UjSblQYBlue42S3Q4RST9vA13PrhXPaKCJzJ5SClPJPWa419R/OO9T0EjBYJs8UEFpzhuokb8ytEkLw8EORMtk84yrb0YbM/wCt35sF4gGL3XVAjNcW5k0tqWtegCWWEjUbvWUTfVRcAAehdfb3ICgpGSRSZCTcLeKMZtk67tULy0mUKg7a3BChDdzq9Igy3TY6QvS/9EzXNapHs72dnOPPm3oIrfgH4sZBjb5G+4mz
 MUefmGPy
 YXjo5lXTKJg0BRFXLqqXs+YSstT5VJK1MX1uUnevTDfufqvp1p163CDJt3+FlhHcGew3vRpfqpKHMPwCPSYpkPVLkdfiTkeausSpCCfGPMOJHgpoxlA8vJ2+FENInSAyjl7VewgQv9Y43i4XdbUKxH0hWGcndsGPDBmWkgvp5Nm6rApd/hN1vFme/i+Dzb51pherOYe3XYcUMUZx1jAmL/MQcMv2Ud4McIgs9ZQqSc3VoSln6QX+FbhTOjRUMrTF4RZhedv6mBz1/PS3NeuN3t1MZMvbsBvsAGvl7OQ3km60pkatrPmX4nhd8OhGNZZxq3hmtQ6YEv5mO5tJs6pdK7ivjIVFgekJLobGvkcvbuTaD9xSXyiecly/GkOSEYtV3WuKroomeVLfKNiqz3NkmoJUW6rUUO8DdJy/MJ0qdzgzUq2fVV9yoQ1PXaEU18sz2db7toX2WctH2aVK+Ne8HQ5yZGtJc2hL/EdOpWRnniPbYYuixi3esMhLKMYYotFVWt5MJzzNiM5vdWRmwBsiRI6rzDWDIFwLJ3hrc5UenK4JlTJXCsl9YV11CQgM7UInRmztHueUQGLkrEFiL2Xo/kXE/Q/iXXzimh31St9GQYmts7tE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] mm: off-by-one region size in vmap_ram_vread_iter()
--

commit 5892fe6e95a3367f16e7bc56c39b500d0294baac
Author: Nickolai Zeldovich <nickolai@csail.mit.edu>

mm/vmalloc: read vm_map_ram block regions from the requested offset

This commit updates vmap_ram_vread_iter() to skip vmap_block used regions
that end at or before the current read address and to compute the read
offset relative to the start of the region rather than the page offset.

> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index bea9f76ed7e74..34340c2490b82 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -4588,7 +4588,7 @@ static size_t vmap_ram_vread_iter(struct iov_iter *=
iter, const char *addr,
>  	struct xarray *xa;
>  	unsigned long offset;
>  	unsigned int rs, re;
> -	size_t remains, n;
> +	size_t remains, n, size;
> =20
>  	/*
>  	 * If it's area created by vm_map_ram() interface directly, but
> @@ -4622,6 +4622,10 @@ static size_t vmap_ram_vread_iter(struct iov_iter =
*iter, const char *addr,
>  			goto finished;
> =20
>  		start =3D vmap_block_vaddr(vb->va->va_start, rs);
> +		size =3D (re - rs + 1) << PAGE_SHIFT;
> +
> +		if (addr >=3D start + size)
> +			continue;

[Severity: High]
Is size off by one page here?

In include/linux/find.h, for_each_set_bitrange() sets the end index using
find_next_zero_bit():

#define for_each_set_bitrange(b, e, addr, size)			\
	for ((b) =3D 0;						\
	     (b) =3D find_next_bit((addr), (size), b),		\
	     (e) =3D find_next_zero_bit((addr), (size), (b) + 1),	\
	     (b) < (size);					\
	     (b) =3D (e) + 1)

Because re is the index of the first unset bit after rs (an exclusive upper
bound), the number of allocated pages in the bitrange [rs, re) is (re - rs)
rather than (re - rs + 1).

With size =3D (re - rs + 1) << PAGE_SHIFT, start + size points one page past
the end of the used region. When read_kcore_iter() -> vread_iter() ->
vmap_ram_vread_iter() reads across the end of a used region or starts at
the first unset page at index re, addr >=3D start + size does not skip the
preceding region, and page re is passed to aligned_vread_iter() instead of
zero_iter().

In mm/vmalloc.c:vb_free(), vb->used_map is cleared under vb->lock before
vunmap_range_noflush() tears down the PTEs outside the lock:

	spin_lock(&vb->lock);
	bitmap_clear(vb->used_map, offset, (1UL << order));
	spin_unlock(&vb->lock);

	vunmap_range_noflush(addr, addr + size);

Could treating the unset bit at re as part of the used region cause
aligned_vread_iter() to read a page that is concurrently being unmapped and
freed, or read one page past vb->va->va_end when re =3D=3D VMAP_BBMAP_BITS?

> =20
>  		if (addr < start) {
>  			size_t to_zero =3D min_t(size_t, start - addr, remains);
> @@ -4635,8 +4639,8 @@ static size_t vmap_ram_vread_iter(struct iov_iter *=
iter, const char *addr,
>  		}
> =20
>  		/*it could start reading from the middle of used region*/
> -		offset =3D offset_in_page(addr);
> -		n =3D ((re - rs + 1) << PAGE_SHIFT) - offset;
> +		offset =3D addr - start;
> +		n =3D size - offset;
>  		if (n > remains)
>  			n =3D remains;
>

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261017154120.7958=
44-1-nickolai@csail.mit.edu?part=3D1

