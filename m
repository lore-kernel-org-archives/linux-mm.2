Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C949CD5BA4
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 11:16:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 978E66B008C; Thu, 21 May 2026 07:16:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92A076B0092; Thu, 21 May 2026 07:16:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8669B6B0093; Thu, 21 May 2026 07:16:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7AD836B008C
	for <linux-mm@kvack.org>; Thu, 21 May 2026 07:16:04 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1E5101C1212
	for <linux-mm@kvack.org>; Thu, 21 May 2026 11:16:04 +0000 (UTC)
X-FDA: 84791172648.26.FBFB8FD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 76A3320005
	for <linux-mm@kvack.org>; Thu, 21 May 2026 11:16:02 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="kdUL/Zxx";
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779362162;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tUqCEaIwv59xhPWZ9lQM3IUpmmiAbOqHhySQs5puZTA=;
	b=SxLP1BC5NK5CxykgXeQ7i93yA62FnYsQQkVl6HlyNdGLAUbuv5lDGcvKjWE67xl9/ku6++
	n4KAbJlAQOKlP6X3pVRdKBQuUabPqNLBbS6+gMwsKuC7fmYoJ0QI0Tz9oOmV950E3/rxpi
	sjdRlhWJH9erl6g5cBBpKUGLqL7qJh8=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="kdUL/Zxx";
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779362162; a=rsa-sha256;
	cv=none;
	b=WwLyYDO7yoir7YTEZrP07qeV0zvpqLTFQYCOSPJzO4dxq5O+NjvOYUiDxFhgHClbNtqV5O
	Fkh9U+4UTnHhfSnOXOuwbPbN11/80cqYv1ysM7CzTf8nQO82ywgIsLGSw1DMCGUNTFOlpd
	YlNGwWIMKanfP7qcBHlYr/YAgd71tWA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 62DD441674;
	Thu, 21 May 2026 11:16:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 881061F000E9;
	Thu, 21 May 2026 11:15:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779362161;
	bh=tUqCEaIwv59xhPWZ9lQM3IUpmmiAbOqHhySQs5puZTA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kdUL/ZxxJfh5nK6UeSNnf7xvyM3C361vwopwhd/c8kQLVkYZkHMBvlp9FTEggIVSB
	 Mct4rJ9w9SMxTHCMTBl4dvw3tw68jnTGNlkpZC4+2qOHmnqpgyCqmCVNj+J0XnGKia
	 oCZvPQ9+/66ee8xZY1LuJAYznv15Oa0lnI1B/rrI2SzpDODHTDidtJCUqfLRPTJHGq
	 krFQcbqKf49uVpkszEOrns4bKSi+BvMaEh5jp4Xy2bLAOOv9iWnljwuUxhmrlJJqTS
	 IJruLON27FQFRYjNzgqGWRYNqZj8hO1/nNsrWAL5x3YocTEMQYKk9lUsS1do0g4dtK
	 eURRBzpI6etiQ==
Date: Thu, 21 May 2026 12:15:54 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Andy Lutomirski <luto@kernel.org>, Thomas Gleixner <tglx@kernel.org>, 
	Vincenzo Frascino <vincenzo.frascino@arm.com>, Kees Cook <kees@kernel.org>, Andy Shevchenko <andy@kernel.org>, 
	Yury Norov <yury.norov@gmail.com>, David Laight <david.laight.linux@gmail.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] vdso: move offset_in_page() from linux/mm.h to
 vdso/page.h
Message-ID: <ag7pFxHpMGU0zLvq@lucifer>
References: <20260521090655.160282-4-thorsten.blum@linux.dev>
 <20260521090655.160282-5-thorsten.blum@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260521090655.160282-5-thorsten.blum@linux.dev>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 76A3320005
X-Rspam-User: 
X-Stat-Signature: mcxtw7ktmszn6w8k9dy3wupmeq67s6jd
X-HE-Tag: 1779362162-832958
X-HE-Meta: U2FsdGVkX19vBZUTRptFW5V/N3LJZxb/SOPECVK0EOWawkowd3lJjTocR2wVdrzjg9+0ZmFuiL3QEZ97pP1eWW8+cpgbci9FVd3Tvvf0RJBkyre7JLZINNURFgpX6zCaF4e8M7pl9ibErA18QB42bEruiTNm99Pq8ttk1kKHiaoApoCrOPRG0nlESwf1eipmAXSC9IjWpYLQBqW6wtqqmG94ypPeNF9oCBZqEPLhBdGSxJJFJJ1DHE8u78QHB/8n5oDyvYyO/S2gMnHRctak79YYo/6aBt2anijvjvmhy0PAwKP/fFS77tOsESfmcBKgohnyjtW2qF1rHhDhwzrfcmcPT2gKPmKXJNL53zHnEc48Ah8OmRKeZ67toeEB6smCT+29s1jm1ANncX7u26i66P/NWTz6hHcLniI3v6KoMZRorAv+fsA5ERaVrlHp2aqHzxOJCnpL7GJrQRZigr28DZwa9Yx6jV3mxoFYK/HSZ8eamGYvEGeoLuVz/KdlSCTxNfgWNt9Qm8wUw233Waj0u6w/QIZauyjrrG/143vaaSeMSXXOGCQVjcyXHrlrAb/LVvWqwtKGz11b5mqoaVmLuG7MC+41Xi+eIa4O4dsOa1Bzgt9Ppng7Fa0LOEgBABx+0AxEnHJbvTEN96eLJEksSmhLW7PryODWEIJZjNDi0U9jIq+6PoRcIN6o4BO/creVrlisH9cmxol7HDzXNflGVdK6YLGHjKo+FgzGA5khnm2VPZFHPyOM2t+byd9qOWqL3+dR/Jf/U5w8dUlznYc96P2JpX4V4SY4ewgzeWHdJ/oZZy9ppoZtJ5kL9bx15Ym5celGsPxmuzJ3KuTkaVx5eSXhOz0YuZ8kl0HzmOldAQmgrDoXarAFYvdS2PqF35NBMti45GdNzxHQ/aJt7sYloYqZxLel+UO9PjTAULVqf2BeKNao+2yc8a4EgzrR4bmDYNY71impmg4sKF1Qxga
 GDfox6iQ
 aGEGVtho0TnkGXdXvIDHgPKnZ+PkHxQKtkz/svxU8wKthwEVFFs6U8AvquuF5D2SieS4WFiF8NaQpUFxYtCXI0MfRArArdYzWUsJhc+NCgnwnCaSP94Ac0HKVKOe6BrbIeVCASCPmczWWhJ7e8BCdePWroL6yDXBFbwNq3fKedYZAggY3RxGAk9AlKRZ+vtDw6pwrFGKdhloRxL7o73a36FlfHvCxkgPIjkhnSTu/NBlPtH0YKdeeaNHGir8W7Yz96K+0izr161pWmlYFT6AdIMRIqh2+dtWyGv0uAq8vK08eq8HHQ/W1N2nP508poCiob5wuSo6448dN9G7I4bMi3UD2AE/ixNx7C59h18GADXXy8OcpDfngivNpglTD2sJddojYzhGpI0I4vzgiWWlwl17xsq4FqYQUAvqScMFXmnVAR1yusmlWI5uSO242u4Te76QGcGHHRY4VkAKoaLb453hWlw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 21, 2026 at 11:06:57AM +0200, Thorsten Blum wrote:
> Move offset_in_page() out of linux/mm.h so users that only need page
> offset calculations can include the lightweight vdso/page.h header
> instead of pulling in the large linux/mm.h.
>
> Include vdso/page.h from linux/mm.h so existing users of
> offset_in_page() continue to build.
>
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>

LGTM other than dropping the include below (maybe Andrew can do it for
us?), so:

Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>

> ---
>  include/linux/mm.h  | 2 +-
>  include/vdso/page.h | 2 ++
>  2 files changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 9cedc5e75aa9..d5c7f1ca80ef 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -37,6 +37,7 @@
>  #include <linux/bitmap.h>
>  #include <linux/bitops.h>
>  #include <linux/iommu-debug-pagealloc.h>
> +#include <vdso/page.h>

Yeah as per David Laight, we don't need this.

>
>  struct mempolicy;
>  struct anon_vma;
> @@ -3023,7 +3024,6 @@ static inline void clear_page_pfmemalloc(struct page *page)
>   */
>  extern void pagefault_out_of_memory(void);
>
> -#define offset_in_page(p)	((unsigned long)(p) & ~PAGE_MASK)
>  #define offset_in_folio(folio, p) ((unsigned long)(p) & (folio_size(folio) - 1))
>
>  /*
> diff --git a/include/vdso/page.h b/include/vdso/page.h
> index bc47186c07fc..948b13091084 100644
> --- a/include/vdso/page.h
> +++ b/include/vdso/page.h
> @@ -28,4 +28,6 @@
>  #define PAGE_MASK	(~(PAGE_SIZE - 1))
>  #endif
>
> +#define offset_in_page(p)	((unsigned long)(p) & ~PAGE_MASK)
> +
>  #endif	/* __VDSO_PAGE_H */

