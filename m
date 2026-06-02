Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 805B3CD6E4A
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 08:29:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A8FF46B03E4; Tue,  2 Jun 2026 04:29:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A675B6B03E6; Tue,  2 Jun 2026 04:29:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A3956B03E9; Tue,  2 Jun 2026 04:29:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 875866B03E4
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 04:29:09 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 34D5CA0869
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 08:29:09 +0000 (UTC)
X-FDA: 84834297618.10.6FDC9A4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id A18FD20003
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 08:29:07 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="efvuu/ku";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780388947;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i/QfQjYUvsdWRW1C6T1wChr76vRullJZ7a3tFyzfJVQ=;
	b=7Fu8RxAzvai4lRY/YfwTD45tVQvyKPo2JiOpvXEaSLReU09Je2sxC6vUQb1BLXYV7oxK55
	Hyo7cGLD7zdEw1v4Igpx545uHafPKuJU8UFzMy/jTwvirebLOCL4mftmx21nLYztC/0hSs
	0TU36bk4deO2QnCE48G/bBaV5PD0FVo=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="efvuu/ku";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780388947;
	b=arstR59qEsnM8OXFvpjr6iLxsZlrGUVidTsfO4cmGB7yoH/C/j2AYyOHeZpTiStlem4quq
	MyPHQ9sb9RE8TMK/i8hW244AkIhRnZ+3hNgZbnq3jeuxPYyTryoz7Z8bHpAPq4pDMeaJo/
	Dd3lqGQQblMpGm+t75dtRD8xB3zyv8I=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 36F8660018;
	Tue,  2 Jun 2026 08:29:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 952941F00893;
	Tue,  2 Jun 2026 08:29:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780388946;
	bh=i/QfQjYUvsdWRW1C6T1wChr76vRullJZ7a3tFyzfJVQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=efvuu/ku107Ki2MfL5Kx5fIttZLNK2SJMSX78TLzd/OW4/YGwyIgJEnvlW/oOn7QY
	 2B7e2XPp2SNKzAVupuugYkp29T30aAS4ImoDnFqrnX/yjdqExPAjT34UtwKBPIP680
	 7bJqNhU9Zz+1bQ3tZZkY5YD3/0LHudSBgm6rXFEyScE5X2VSaEcCwdEd1uugqdTtNl
	 8iuZF0rcZZDvPDPJvZ+154yflgV5dpSkLYLRT42u3rV/T7RQvE64SVjdmTsDQRMmjs
	 GYZBgbud8G3MUtqZsQNWJ+opT5RpZeEpOZBdU35XvnglE5IHVobXkNf8UOncVqvuVH
	 snkTfR707G4DQ==
Date: Tue, 2 Jun 2026 11:28:59 +0300
From: Mike Rapoport <rppt@kernel.org>
To: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Lorenzo Stoakes <ljs@kernel.org>,
	David Hildenbrand <david@kernel.org>, stable@vger.kernel.org,
	Sashiko AI review <sashiko-bot@kernel.org>,
	Peter Xu <peterx@redhat.com>,
	Mike Kravetz <mike.kravetz@oracle.com>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Jerome Glisse <jglisse@redhat.com>
Subject: Re: [PATCH 5/6] userfaultfd: gate must_wait writability check on
 pte_present()
Message-ID: <ah6USx2IQ4iy1jUZ@kernel.org>
References: <20260529172331.356655-1-kas@kernel.org>
 <20260529172331.356655-6-kas@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260529172331.356655-6-kas@kernel.org>
X-Rspamd-Queue-Id: A18FD20003
X-Rspam-User: 
X-Stat-Signature: 777uaufnmtrihy83js1iezrdahs4zj6h
X-Rspamd-Server: rspam09
X-HE-Tag: 1780388947-468234
X-HE-Meta: U2FsdGVkX1+DBUo/WylOBO9Sxj2AQu6zSpnwkxphPMHRihTwWyvYeML++gzzwCKTFw/OyeZk/zEpDrhEjuY8mZEpX7I2wERXX55bEub9VVlSga+eEZdhWZcPwHm/RGhiEF0Oqn3b3xI04PiU6r6Ot9m3s7z4QwGsEwdWXXIbqG7R8iNgvkAwCzc9d40FU53IHuYzWkKiQfaa22wtMXk1YtChjtFoTP+126uGOFfx9bd1lQgyCa9Ej8hk3C7AvA+NgxpY7a0t4ZARHMYO/qsRryI0KS/BWeKb5ElWPUvAKqoVMRMPA4M9E9ZQasupR9azDwZWRgAMyn9eOCdtt1Glz9RLzu4aAXYMYci7ouluNWtPimn3m5rzd/QStYhlrkXrRuKCu46m6m3hC2bD4MA530v/AeFyMEdcgmBVHH3OoauvGfqgo1LLZ3gffaq41rEgPFEUr9AdTo+7dIrNJ/0nN/CRTSS/QIVQztJoO0UCC8MtHQbrY0hdIVRFOzvpPfBQbjukoZEzlRBmmeH4zgBzEs0602mUgu5fvl5YHh9e/pkIew8QhQCVrlCbl8mCJep82NK92hXmySaQeOgv7+LAKvuGm9gZKjhu3gL1iMNQZSS1uNXuIJHc8rAxDXhIZGRO/fMwGQd8SVMautXbctdOAZvjDZJRjxoaDFGcagUpeIPdqrYtMveVnE8TaqRlutiypykdiuZ5c3qFmPrf4oNc1wj7Ox2s94Nf23bWCIxsHKE7V7JspsAYd1hgfCRlLP20u02f3HkgkIYZdW7UKgRyyC+AY7UY5x5e/UhFWfne14cIcfIqlTVdgSa5uwur9iRs4WXmkhspQ4Cx8D0Qtq365iqJ0zXcYg5HUTUeQ8pr794O7bXF+K8mwLLkNNaWYGcPIVlpIp7D++JxXXFDpvm2KmsxNj1CHm7tiVdR6pcLd1IiBftpiOWETiw5mFQniNLyOg6SEZ1OY1boFy0friK
 1/WtG8MU
 xfnb5hMnO0zdyfu4z0KxClgl9Z1OQ8aogmGtb9tNggxO2OjKI6v5Dz0pa7jsGjJA4CB+cRjHt+SEt7kxpm2rTyinLCdVIx+Z2D9FA9ui4ddWDqP1PN6l6564VHJvdZZH4mCO2ozNrt3QdhJinVbwYeONwk2h7WYx93kDtQU07pI3h1VWU99kJlmjJjcbm7Sbv5RqmijizFoMeQ95vtBzMbBgIshFIC24CRPuF2a0BF/UwWBEKSxdzIny3LXav13sQQKf3JzIzQBZKu0vu4nef/52rwM8U8/rQtpav6Xn50OEYcV8v4ywfLPcu34xy3GzlUp6Mu5tXNrRQBEc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 29, 2026 at 06:23:29PM +0100, Kiryl Shutsemau (Meta) wrote:
> userfaultfd_must_wait() and userfaultfd_huge_must_wait() read the PTE
> without taking the page table lock and then apply pte_write() /
> huge_pte_write() to it. Those accessors decode bits from the present
> encoding only; on a swap or migration entry they read the offset bits
> that happen to share the same position and return an undefined result.
> 
> The intent of the check is "is this fault still WP-blocked?". A
> non-marker swap entry means the page is in transit -- the userfault
> context the original fault delivered against is no longer the same,
> and the swap-in or migration completion path will re-deliver a fresh
> fault if userspace still needs to handle it. Worst case under the
> current code the garbage write bit says "wait", and the thread stays
> asleep until a UFFDIO_WAKE that may never arrive.
> 
> Gate the writability check on pte_present() so the lockless re-check
> only inspects present-PTE bits when the entry is actually present.
> The non-present, non-marker case returns "don't wait" and lets the
> fault path retry.
> 
> Fixes: 369cd2121be4 ("userfaultfd: hugetlbfs: userfaultfd_huge_must_wait for hugepmd ranges")
> Fixes: 63b2d4174c4a ("userfaultfd: wp: add the writeprotect API to userfaultfd ioctl")
> Cc: stable@vger.kernel.org
> Reported-by: Sashiko AI review <sashiko-bot@kernel.org>
> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  mm/userfaultfd.c | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)

-- 
Sincerely yours,
Mike.

