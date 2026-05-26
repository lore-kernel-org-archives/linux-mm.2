Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7F8DCD5BB1
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 10:47:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 405716B008A; Tue, 26 May 2026 06:47:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3DD346B008C; Tue, 26 May 2026 06:47:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2CD9A6B0093; Tue, 26 May 2026 06:47:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1C3AF6B008A
	for <linux-mm@kvack.org>; Tue, 26 May 2026 06:47:41 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B942E1A03BE
	for <linux-mm@kvack.org>; Tue, 26 May 2026 10:47:40 +0000 (UTC)
X-FDA: 84809245080.27.93E8320
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 232B040012
	for <linux-mm@kvack.org>; Tue, 26 May 2026 10:47:38 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HKQNMi+d;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779792459;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RcmL+NENyll/pO8MenmBG7srmhHZmhOd06anio1GuLY=;
	b=Lmj8b/OcMzXHVXXVs2T5Y6qDD7EdxTJWGe0Dq1mM5a0c3j78a3btBrFBwucoSChmzPkz7y
	6UoONqu7Nlkwg50m8lpCEuJzaSldmwXRoQ4UXkc2vqDevodMXR3rvWh9o6groP1pO3jMLp
	0pawvMru8AWnpl5Vwyy7xDwUTZ7JgQw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779792459; a=rsa-sha256;
	cv=none;
	b=J9u074/H16MNwPpuDyd2TI6DpjZfn7jU6vriM6vk5Q20Dhh+af4JL8Xno4BGAsWUde/U9m
	IA2M9zVl5CvvmQfY0C9l7EpJ70L0tdc75SyvrjWVecjQQzQEc9hY+jEn43ayxFBEtySWXW
	qc7/CDuQXi6PM/w0qpOCrBnIg1qc3bU=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HKQNMi+d;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 764D560018;
	Tue, 26 May 2026 10:47:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2417C1F000E9;
	Tue, 26 May 2026 10:47:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779792458;
	bh=RcmL+NENyll/pO8MenmBG7srmhHZmhOd06anio1GuLY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=HKQNMi+dRX+QuTlcnlyfpbp7zJPtm4qwGeff2d20aJu+Uo1SHuIIbuQziX/KxN4wt
	 jGw3idlDvZqXZ2Zj3aOa3Nt61A95qGStElxWtKDA3dVaICYFGlLodRi9PgFGoiwVDx
	 MZuMNu2UBVyL+N5HbY0tV/gHJ2S/RSmeNTOKIcXNRc0eBpEmqpEiqJrRqqKzqyzCru
	 Wkc9CIW50WeNFvZOY31pUOLgovg7hOSpXsnVefKAGtSVtunAGR+ee1URsVTlScxgxH
	 Ke5845psKJA4SnjApyZ4uY5P/qfjEQWKu5LvVzHncZsWVSK/igCRxcZKu3eUxE8YDR
	 0qILHktU6IXrA==
Date: Tue, 26 May 2026 11:47:31 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Yin Tirui <yintirui@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R . Howlett" <liam@infradead.org>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Dan Williams <djbw@kernel.org>, Alistair Popple <apopple@nvidia.com>, wangkefeng.wang@huawei.com, 
	chenjun102@huawei.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Subject: Re: [PATCH] mm/huge_memory: update file PUD counter before
 folio_put()
Message-ID: <ahV1WCxlXhOKfO_S@lucifer>
References: <20260526101355.1984244-1-yintirui@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260526101355.1984244-1-yintirui@huawei.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 232B040012
X-Stat-Signature: s4d7iqa33k6qeogp9hkq16tf1hzaht6z
X-Rspamd-Server: rspam06
X-HE-Tag: 1779792458-46447
X-HE-Meta: U2FsdGVkX1+T5keX+sz68ymDDC/m+LJqM2/KaoP9nlCQFsGdF9A4ezJm+Cr8+k6hFJyc+7mx391+Kq1sYNh8oTYGLQCh664CN6NjPj/cltWqexrXDPgKBzy051MLeL8L7R0lv3syYTaI4Y7rISs93vs0MmiVmdPoQw5N/XGIul1NKP9nwcHQwddbfCU7IksRxS1t5pji5KsAjRyfTtphmaKU4deH0nti6uR9tjkP1albX72QnQv0vGkGRg0OhtnOIpixK7VVy0Km88SSqwa8Xy8dUKxwQ+/OIUOHlfw2Fwto8YXtwkrhwqJZxAse3kUDp3rpTcxzUKnHGbb1k0jfR49EpBHflE8vX5Uk2hbVCWc9gHbro3a8DUlAfjbsFuu9rMXJqdRj7tGsELUMTmddwmW9+INBD83uQvxI2C+M/7eQTE9snS2dD/znjVjRsGjlhQ/KUgwlCFAchKH26ljuFvriocYFG/tKO9kUFFRNeE5EFEl7Z01C62IGGUvweExk8ACTncL+/aY8UaSBb380+gc3ZQNqVmEHXB2rteRQHTQDJMXR2IvEvZRvQIl8zlU0wO2dQoJElvjKho3bfxAN5BGPhJiGTCdKWaOkG2mNa1iVBzKU0CFKVc2xyV2lB/xEJWepAv+vnl97ieDmXXDPu1GYzr9BDoIzCwy3zg7Rb8UJi9NkjfZ2lTzpHagfp33lR8HSIdKgCqAJGFrp7wMCcudkuZ0R5sRioW0zfKccpDPoroPOouFWx3jzJ4VIu0VqNZYvay9HsK9mLIifd2iaurzpCSpMx47Gslawwva5DXi4zw+jiNZfuGC+2LOtERYs+yswjCsNLfNXLS9xABl7ogyHgMdtyXGTiIrik2OteiBdTpsrDk6vk+iRKTrBxQ69G4x5HNKePxwNy8ZH6pYJAAvyPPKeX4FAsq21qm7eBE/ZKUu3Vai1jYn6kEIWenzztfRfnKP4fyhJM7+Jzhl
 ymmnKO17
 3Nl3BbRxMjpHV9DEPStyTnMhA0Yz+cEENWcI5a84Hk7t4hIX9FeuHK0NLwwLxKHdpgr5D29S9wHU2A5rT2fhSylZ0ETrDTpb8N6V1mbPEq4xO+g9wYnA3J6JqcuHRZhAWa8mqWWOeSkLYJUajDMTfWyd3sg+VAdvhGEicEkSojX+htCK7egKveksv4Up+oJHZwjanjrZC3clxH8f5RrGPBg61N+0dfZYfm0nPT1cRCZM5T147sJOqAr2TacjjjCFsBCVdMYX+r4EcgYR5XbKqoRtcnlVM/EFgCsHhuZ2W60xJUFPhSEHItFacZ601+Ws6LXtp6ieiFHwFIUukmIWtQ07idQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

You sent this twice :)

On Tue, May 26, 2026 at 06:13:55PM +0800, Yin Tirui wrote:
> __split_huge_pud_locked() updates the file/shmem RSS counter after
> dropping the PUD mapping's folio reference. If folio_put() drops the
> last reference, mm_counter_file() can later read freed folio state via
> folio_test_swapbacked().
>
> Move the counter update before folio_put().
>
> Fixes: dbe54153296d ("mm/huge_memory: add vmf_insert_folio_pud()")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Yin Tirui <yintirui@huawei.com>

Patch looks sane to me, so:

Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>

There seems to be an identical problem in __split_huge_pmd_locked() - could you
do the same fix there?

Thanks, Lorenzo

> ---
>  mm/huge_memory.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index a5f4a48b7b77..9832ee910d5e 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -3027,9 +3027,9 @@ static void __split_huge_pud_locked(struct vm_area_struct *vma, pud_t *pud,
>  	if (!folio_test_referenced(folio) && pud_young(old_pud))
>  		folio_set_referenced(folio);
>  	folio_remove_rmap_pud(folio, page, vma);
> -	folio_put(folio);
>  	add_mm_counter(vma->vm_mm, mm_counter_file(folio),
>  		-HPAGE_PUD_NR);
> +	folio_put(folio);
>  }
>
>  void __split_huge_pud(struct vm_area_struct *vma, pud_t *pud,
> --
> 2.43.0
>

