Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0EA7EC79F82
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 15:56:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 01BDC6B0092; Tue,  8 Sep 2026 11:56:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0EF86B0093; Tue,  8 Sep 2026 11:56:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DFEDF6B0095; Tue,  8 Sep 2026 11:56:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B6FCB6B0092
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 11:56:24 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4559C1205FC
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 15:56:24 +0000 (UTC)
X-FDA: 85191047088.04.DA9D9E7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 3EC2C16000B
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 15:56:22 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AYxSkOqq;
	spf=pass (imf08.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788882982;
	b=HPgaIVSMbNe9KjaGwJ/3KDs0wlBc26TJ7EkRw0a6OzO5AkFzVVJtk6ZkjmUMxHenARno4l
	u9ZWjbsyJBcStRbVx137ZhFxtms8rttqXL9WqQ9eD+Thm9Uoddo72/e46HuOShVqfQppVk
	YeS+h50w/NTK+RUBeEVfNge2ovXd2sE=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AYxSkOqq;
	spf=pass (imf08.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788882982;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N9fgGq2X2uChEtYWmFfDevJiLw3yAP3NdTyXSMdqiTs=;
	b=BfrwYKkkfTe1aE+yX0a7vth/eDTDs8Gy60f0sqtkTa8cvIriDdlPrKlpshwtMW9V1jVc+D
	0snMhuo7kNaZ0rCDoaQcQc5dSUe5fPGfmFJS6XY0hZTWiYMWcQYal6E5rRzU0AjJWiRXTU
	RtbZfMEdu7Cn8vGC3Eufzz30pXO5j08=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5D1D943C12;
	Tue,  8 Sep 2026 15:56:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC2831F00A3E;
	Tue,  8 Sep 2026 15:56:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788882981;
	bh=N9fgGq2X2uChEtYWmFfDevJiLw3yAP3NdTyXSMdqiTs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=AYxSkOqqtRkXROWj3gB+7ReXgoHiyFFrrjnxIz/90YaeJ3Q/oOcXcADEhYVwjqu1o
	 3Fm1Jcwf8SAzxUUpS2kkTUbOxVkNcijIsb5l12Jm0B6zzqWxuj2KMgzZmQqsXor6vz
	 B093oKN0PG5FLcZdSkIgl0IQbhWQgHP/RYNC68D/wm/ba/9vaFD6TCCMAo6S8BiNon
	 M81/HJN1FLDDJjM5Kp0ZX92of4k9tcEImVeiL3r24SHpoKM+M8xf7wKYimg4gZ51D6
	 dB2C/xNmu5FmDsDpegQt03q1fQRF1mUMthr9k7pe0dV50Y21GGAC8FDx/yj2yukz0n
	 OhmCpmb5wEnxA==
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfauth.ams.internal (Postfix) with ESMTP id CA820198003A;
	Tue,  8 Sep 2026 11:56:13 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Tue, 08 Sep 2026 11:56:18 -0400
X-ME-Sender: <xms:HTCgateyjfYFJdrtV7amQ9wKd5WHkuIUJV1wBimJoVJ08GqbGVDl8Q>
    <xme:HTCgauRae6D3D-6pIsU_QUdZxKrkpC8KEJxo87_2EoODrEVZEnud1qsMmo6WR_md5
    1EtZbxZ7fMswFDzVZemiCkbu6_SrxU56Tr6pehvBO9TqHkEP-MJOIg>
X-ME-Received: <xmr:HTCgakmvep3BQWXmrdY7q7Ef7PDqzQKKi5xj8CFcqCXJYXxmNUGf2cmdoxQ>
X-ME-Proxy-Cause: dmFkZTF3IiLrxKTc6MEEiVzjdeGok30jImMQRh0oSfDm6XFoFRUjHYcV2z+3oyw9IE98S8
    jhHjjVUPmLb8M1epXseCNDEw3g/pBEbeVDnYYxEmv/e8MqjF23LLhO7qB6zOijx3q2TO8Z
    chf+iV/I1x+z9V8/XJ8dR80BupXVG0lg4hH4QLv1WG4+83EGiENMGK0RcO9dEJ8TODIGIE
    8wJi2hmB6J1ep99h6Ir8Gc/c5bfldImT3JKGX8HjLU0BbFWuqm62tA7g6VKS+hvWJGI/j/
    X05+tUfS3Abz/aIZ74BfbklxYyRaMDjdfIMlDmfoddqHWsbbkYh3Ce3RSfpHWut5aet9ZY
    JJiG7gZhGux8ERCOwn6ER5ulGtWTcS3oPod6tev1968K2xCBHQySsRN0r9nXV27kFShhCx
    E+DaEwFCUVqdfyq4enpFO3knr7GakbCY8YHyql2lIo+1gg6DmH21S1PbITefkjVzC/oBDk
    rGivE4sjTsRAbzIfAtHqMU7HMkwAguEDmB5jFTozR0eX8kXCXiL+OBUGkSnAvFP5epOENB
    /kLy2ln2QKxI5D3xfCzdIjX2HzMQeVrkKvXuEZFmemlN9uGAZyYJwBrToCOWJa/Mi7ej8X
    eTwT1SbLxn/5mxYEk+0c314mj2MSpRkoxM6ltRC1v1My0h3nDOfh3HPKUa6w
X-ME-Proxy: <xmx:HTCgaqZ4TNJfpPRLt2blkL-fSGCQUuK2aTJq7fiKRsbRtfQMPsrS9A>
    <xmx:HTCgav2uhd1-UupJDsed_7VsdzptAOIz8jUkNT7xOlOsREgTUg5IEw>
    <xmx:HTCgaiqxkzH_b6CQSua9FpR1ywCgjYVvehT9qgwQzcYeICM97WdDsQ>
    <xmx:HTCgarwbrQIQaiihmQIsf43lSHARzGEj1U0WS3HJMnSyUdg0MbyEXg>
    <xmx:HTCgahjnYxs-rz7p5qLOGW4K36XsgUA_7OcoKvtN0wkE_iE9u5BUGLcN>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 8 Sep 2026 11:56:12 -0400 (EDT)
Date: Tue, 8 Sep 2026 16:56:11 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: kasong@tencent.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
	Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
	Yeoreum Yun <yeoreum.yun@arm.com>, Shivam Kalra <shivamkalra98@zohomail.in>, 
	Kairui Song <ryncsn@gmail.com>
Subject: Re: [PATCH v4 12/17] mm/huge_memory: move anon_vma handling into the
 anon split helper
Message-ID: <aqAvPuHUVXvkJmV4@thinkstation>
References: <20260908-swap-thp-cleanup-v4-0-b532a3f20e71@tencent.com>
 <20260908-swap-thp-cleanup-v4-12-b532a3f20e71@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260908-swap-thp-cleanup-v4-12-b532a3f20e71@tencent.com>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3EC2C16000B
X-Stat-Signature: u3yb6ymss4f5uejseeg38ub3xiboqo6d
X-HE-Tag: 1788882982-296192
X-HE-Meta: U2FsdGVkX18c8TebSAi1zEvbvMBWCkwknipRWjJ3HzmVGw/7IskBO0qRdvYvJtwZ0iQ36X8aNZPeBnRewPENX5MvtP70xQz/ppP2zisJ7Q919yE02DOz53UyYwx2xh/bCPeuk6PHA9l4Rre/3tTXSsTq3//e6b6ybjx7LXSoxrE0TcO1yuYeHiYn5P3r6SEnppO5Ptdpo6Yt1028A7Fk8Uv1SMVyOQZ0qQbFexAgKDm14nwtlcvLfbkS4SXBNfpODpbq//pM4afol+vyegUbIqjdAdeJxOnA+2QA1Kwci3q50E6dxwrFEpVlAUwx0FXr3WPousO0PKpqfJWgBbfmfiuBEBGOx/Wgvj3r467d10lLadIIrIW1186e8zzdvfK0TqND1tYA5Zj2pnQIFI/5qc6JrU+iypggszZlww2s71GcOut/p4NzIwTkl89SY1K2OQP15DUc/VelRLye75sfXw9bz4DWvsolv+L/M1Z4RyguNOhUXP170l20g8XcSq9SKZnHIYAhtbKZvTbnPDEHqAuj4insJMsiato04ZwkN35THC0bWsGSO121IDEREkBloXSpjoejg3TzcCzo/dC8Zb/aGvS1QcdJM0C70ZPCahJUou/eOTSNW710B0ZKn91eZmkTn898FwzCGRCbIYkvkYMfcjAKlcfp0MPyJ3dS/DnotslGcd6UzDFquSNXTUnnUD75T4FI1rA/FogBHsgqdijq9JZvpCDRzq5pDF6kxLJRDhQG3dywhzlf04DWiPSMpOLKZL66RvYx1MnRp6ctnYy22Z5gR/dCjU5Kct4aWMHGDgCtuzbwHzi5hS18MkUf+5ptjOpxLRgEdqDmZK1IOv7Ug+rqUs02GYiVKxtqdh0f5vM/8cGQ9LvNgqvKtEIp4csXvRHuK8WNRhnD3Rov1xi0Dw3ICh5MCfted5YbiRXmcVUxUf0nEBnBzvERtVGW8Z8SYpVq9IiqA8TtoJC
 JHrPJeKy
 vrsMkpohbfWDAaxD92kroyp0mXBzEboCm3DoHDcaxw/6jsBE7phu0sLZBBPpPz/bJ/Zp5CsBrQ+5V/dp1txGfWtIIlNo3vtKmYp/jofLaIcB0e9sDMcF4zQgEA2p3a1D+5BsZY8L0BYpXN39nYH4dICMY5frvyIopfU6icgjXbQGDT8MbI6hAKiZFJhGrXSPleCaT6sPZAA3VKIWz7E/vtnhjp0vVhIcinOimgiN4qBZZZqd2Ru/O5+454pvUYtqtBZMB+cX9Wl53byqdq/TzH/pDtoQgIyyb2OCfxOo/2JzRzVzIcDex2kJqrAIuTRo6tKV8jgV400b7tyE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 08, 2026 at 02:12:16AM +0800, Kairui Song via B4 Relay wrote:
> +	/*
> +	 * Unmap/remap needs the anon_vma. The caller does not necessarily
> +	 * hold an mmap_lock that would prevent the anon_vma from
> +	 * disappearing, so we first take a reference and lock it.
> +	 *
> +	 * An unmapped folio needs none of this: folio_get_anon_vma() and
> +	 * folio_lock_anon_vma_read() both bail out on !folio_mapped()
> +	 * before taking the lock, and folio_ref_freeze() below still
> +	 * rejects a folio that picked up a reference meanwhile. Note
> +	 * a swapped-out THP counts as unmapped here as swap PTEs do
> +	 * not contribute mapcount, and they are splittable.
> +	 */
>  	if (folio_mapped(folio)) {
> -		need_remap = true;
> +		anon_vma = folio_get_anon_vma(folio);
> +		if (!anon_vma)
> +			return -EBUSY;
> +		anon_vma_lock_write(anon_vma);
>  		ret = unmap_folio(folio);
>  		if (ret)
> -			return ret;
> +			goto out_unlock;
>  	}

Hm. Nothing serializes folio_mapped() here. I believe it is fine, but the
reasoning deserves a comment, since it is what the whole change rests on.
Something along the lines of:

       * folio_mapped() is not stable here, but it can only change in
       * one direction while the folio is locked. The mapcount can drop
       * to zero at any time, zap_pte_range() takes no folio lock. It
       * cannot go up: swapin, migration and uffd move all lock the folio
       * before mapping it, and fork only copies PTEs that already exist.
       *
       * So if we see the folio mapped, the worst case is an empty rmap
       * walk. If we see it unmapped, it stays unmapped. Anything else
       * needs a reference first and folio_ref_freeze() below catches it.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

