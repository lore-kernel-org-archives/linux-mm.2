Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77EBFCD5BB0
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 09:04:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E1B086B0095; Fri, 22 May 2026 05:04:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DCBE46B0096; Fri, 22 May 2026 05:04:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D08046B0098; Fri, 22 May 2026 05:04:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C05686B0095
	for <linux-mm@kvack.org>; Fri, 22 May 2026 05:04:50 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8DF0D1C0784
	for <linux-mm@kvack.org>; Fri, 22 May 2026 09:04:50 +0000 (UTC)
X-FDA: 84794470740.30.E3FDFFA
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf28.hostedemail.com (Postfix) with ESMTP id A44C4C0005
	for <linux-mm@kvack.org>; Fri, 22 May 2026 09:04:48 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lVZCshpg;
	spf=pass (imf28.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779440689;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BzN8uRS+evEkzfkM8F8EjSO1FodLBhyOMwCLeG/oLWA=;
	b=zPWKZui/WSl0EyhMk7pjJNObzffj3w3RP6ntEcsaOKU3e+n3WgtvwpJEnZVuevjrcd/kK9
	37A/prqfkRdQVtHBvBHCJdbs6fQqm22TsdiFdp2MjXw6QNa+f4fbVMvK/ArpKEtu1kWzLf
	SWBKPxVI72l9v31zdFWy7m7FPSA6nLo=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lVZCshpg;
	spf=pass (imf28.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779440689; a=rsa-sha256;
	cv=none;
	b=kKk7qEVo/S97h6dNXb7iJdE5EyM32jF2lUvC8TesNJvmleU42Yi1ad+MuDfA6Lbsv0d6kY
	UVEDvsu6Wz/uKJVIe/5rLNTwZreb+jG2SQt93vlS23whNWKM0fvhRJTQg8/VuXfO0uIBhR
	AWlvTnVsGTtbOH8RyoQrQXz5hlbMTXg=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779440686;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BzN8uRS+evEkzfkM8F8EjSO1FodLBhyOMwCLeG/oLWA=;
	b=lVZCshpg/wXpcUjXldiM/ceIfpT8/xor9I1dRcT0WEh3xmaFx5Qv5Uu+2wey8wNFAAqegz
	6Pj+K8IiKHvG9PjsDn0zp4zAwoBSMRmwjszCmdME8CzWJliRY1GWvWxPVSzKa+8YrwO+No
	+OlsQ3Qmkc/X7uby0Un8upZhogPXOZc=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [PATCH resend] mm/memory-failure: fix hugetlb_lock AA deadlock in
 get_huge_page_for_hwpoison
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260522010305.4099834-1-mawupeng1@huawei.com>
Date: Fri, 22 May 2026 17:03:57 +0800
Cc: osalvador@suse.de,
 david@kernel.org,
 akpm@linux-foundation.org,
 ljs@kernel.org,
 Liam.Howlett@oracle.com,
 vbabka@kernel.org,
 rppt@kernel.org,
 surenb@google.com,
 mhocko@suse.com,
 linmiaohe@huawei.com,
 nao.horiguchi@gmail.com,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <A6E5ED4F-EE5E-4AD6-AC7A-39B3E735A48C@linux.dev>
References: <20260522010305.4099834-1-mawupeng1@huawei.com>
To: Wupeng Ma <mawupeng1@huawei.com>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: whgfrfs4arougcaiiaudsopkz9ix5ugy
X-Rspamd-Queue-Id: A44C4C0005
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779440688-999478
X-HE-Meta: U2FsdGVkX1/6EfrtC8PzHAmoAToadS2wU3THG92kioqIFonCtb/AinkP55n5uaxcU/Z1Q78QUFAFSkdtpcSSTNCyRn8khrUWSGlD1Zo3eHktUBAmvbYVoCxE4i4LW05t41PNWe2az1D0mH5zGGoTRxexziI/DTb74F40aAXPimE2+M6p1yZiBEK6+l5bC8h4WWQwgg9P3HwhQgvJ21UxjD5Vnj9+VRXmXgnXFO0rupE+wmbDzHy5/GLAl4G0tqyMZmM6UY/9VWZD4CIHySVdzQRSqZgYxMbcVSTL3lqzUruW7ToSomHOcGZWwsLv7hlhqGCn3pl7z0qDxILlksd+XRRDQfyQwcmsIEpMCI6MJBgCYwNDww6qfpOTGzvn5EN/PHn+d2OwyHlu+d/Iu68pZkzDu80p7w8W2+59acwN2QNepzxn+cbMs+Af5maekmbaJPpcS5qwnsv2KyzP9pEbyZZqDU+s/crGwXBwdkDghDYeS7EVjlw5AAsBiTv/BMzrQK2ExAmLAWU5aCMmJcW+avvC4/8qRwutSVxC7CTR5rmc+FXCPg6DF0gvjRVZJGQzahljeZHXtdF+QUekioRFFKQabm+IXCJ8Bd6uDHkA3Gsu/n5eMxhgSmLGZVZuzvZPJQ1rdkoFSmTAUCoahIMPbTrdBr92k3uM0+a+Cx3RbnK3A3BG0WKN8d2PDGUbOHEeqet57HRa1a33txMKUzYlb1jQunib6qTWN7rht/mZ9MYpKG3JX5ceurKwXY/1SNfwlzhNegDdL31J53T7NVw5j3N87XDL7lbbDxzr71TEzro78zXMS2skQYG+sGmBE/+OjkXLjok4grHACY+kTPpwfYb+2y3XaSUuUkDTlsnwueeLPTOVcSCV9gh5QP3kMDIs77FCrYvyXizrnS0CmNL/pMMrVQwuIaomINIbCLFiWcx/rZkGHKY43VHiO6PwRruCm65CgcuKOEOt74kd5hH
 Us6WHb7g
 +2zroc5IGAwnb5djru6fFnWundtz4ZiETgtA/X0AhJbeLURKCjZBc2LF8a8m92Rb4T0GSbTgRIm4dqmGk0xdoei8+ap6+t5SRDDIveOLiuw+8+IdIZNIzlVpUmQkEUNOAMnv/ClucCI9kNK1FZIjJLuKWxd1O8j1apT+BmzNtlf2OPCxjQalhf/Id0wYn8L7ciIaN70y6toP9bVbtBzvcIw5AAbEySoW/qIwzrdMNxg5Lrm1GczAyEi/m1xEihkQeQlfN1mbU1cogzeogsanKrOb/oEnXF39tkmdP/ktduREUzIAkNZxBcJRF/LuBECo4MZ94TNkfDob7NaxDlTJJd7rsErYwmy50I0lsCyjw7/EIy4RsnwYEcFI3O+94iSBW6SZ5QAV5l+bOjJ+KNa+e9rCxnRgRXN0+DZ8+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On May 22, 2026, at 09:03, Wupeng Ma <mawupeng1@huawei.com> wrote:
>=20
> Two concurrent madvise(MADV_HWPOISON) calls on the same hugetlb page
> can trigger a recursive spinlock self-deadlock (AA deadlock) on
> hugetlb_lock when racing with a concurrent unmap:
>=20
>  thread#0                              thread#1
>  --------                              --------
>  madvise(folio, MADV_HWPOISON)
>    -> poisons the folio successfully
>  madvise(folio, MADV_HWPOISON)         unmap(folio)
>    try_memory_failure_hugetlb
>      get_huge_page_for_hwpoison
>        spin_lock_irq(&hugetlb_lock)    <- held
>        __get_huge_page_for_hwpoison
>          hugetlb_update_hwpoison()
>            -> MF_HUGETLB_FOLIO_PRE_POISONED
>          goto out:
>            folio_put()
>              refcount: 1 -> 0
>              free_huge_folio()
>                spin_lock_irqsave(&hugetlb_lock)
>                  -> AA DEADLOCK!
>=20
> The out: path in __get_huge_page_for_hwpoison() calls folio_put() to
> drop the GUP reference while the hugetlb_lock is still held by the
> hugetlb.c wrapper get_huge_page_for_hwpoison().  If concurrent unmap
> has released the page table mapping reference, folio_put() drops the
> folio refcount to zero, triggering free_huge_folio() which attempts
> to re-acquire the non-recursive hugetlb_lock.
>=20
> Fix this by moving hugetlb_lock acquisition from the hugetlb.c wrapper
> into get_huge_page_for_hwpoison().  Place spin_unlock_irq() before the
> folio_put() at the out: label so the folio is always released outside
> the lock.
>=20
> Fixes: 405ce051236c ("mm/hwpoison: fix race between hugetlb =
free/demotion and memory_failure_hugetlb()")
> Signed-off-by: Wupeng Ma <mawupeng1@huawei.com>

Acked-by: Muchun Song <muchun.song@linux.dev>

Thanks.


