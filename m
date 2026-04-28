Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B15CEFF886F
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 07:17:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D98856B0096; Tue, 28 Apr 2026 03:17:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D70296B009D; Tue, 28 Apr 2026 03:17:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CAE476B009E; Tue, 28 Apr 2026 03:17:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B963F6B0096
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 03:17:27 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5FE081B952A
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 07:17:27 +0000 (UTC)
X-FDA: 84707108934.16.85FEC11
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id AA6B620010
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 07:17:25 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="s/Sw97Dt";
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777360645;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/lEyLbwsGkq5jeQO3S1l+bt4PBn3n38L01KVUzmf0Y8=;
	b=x6DmttMyWVQCzjqvdh8vRLS5UgolY98aAx0btYlMng/73Vi/VCcnQTrhTJeOgdh2g9CzQ/
	CWcl6c0CAipIYGYRqerjVHFUkXrBE6aVELSABoTj0TgWJ465kaDtAxGOKcjVHWCfgaltOF
	aa+v4B7vl9rI1fGwRmjFZboA/4DOJDE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777360645; a=rsa-sha256;
	cv=none;
	b=0Lh7Cj6MJ753OUhKPvotnA1tkLb1jPXGLeONZGZFA8UN6SAxdvQKos1o+xIc7Mwlr544rH
	MN8i/Nu9WYmHm/vQ0fPr/t/19v4WC71pc5ZBv8xbhOk79zSXH+dk/ut4VBwk2kYojliDCo
	UscxLVgeyBre85euGTuisYeSaoHDsqY=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="s/Sw97Dt";
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C188A40BE2;
	Tue, 28 Apr 2026 07:17:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB853C2BCAF;
	Tue, 28 Apr 2026 07:17:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777360644;
	bh=x9qJIinO1nbogO7nsvx80qmxge1hX/VRXXcguBHeeBU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=s/Sw97DttDLFUyysya55VdNHbAtjN6EvA/HnLuN9KLgoGNh+23d7x61vhdm0euIMp
	 UtSXK5R3sBkVa52RpDSncu4CcnwlAvWaOAvF4ysfEkiAbr3ZrhqAEkOPxktj8km0iT
	 EVbPcP/JxmKJmM1AqwyePCkw5W7yE7sy/FPMphWhHLoxQYXxn5t/dNAQ7hvsV6lLBo
	 sTYTon165DhK9vFnkcBR+vWM1y8XR/qkviuBmKThOZKLPE80Lkbsjqp/9riIlyql5c
	 VLQEk+0sbjAcGXGxvoXV8t7QokdfpoCQ5120+J4235p/yyVccZLhosagV6hsaT/sTC
	 VV4jjZfM/mCAQ==
Date: Tue, 28 Apr 2026 09:17:16 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>, aneesh.kumar@linux.ibm.com,
	joao.m.martins@oracle.com, linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 12/49] mm: make set_pageblock_order() static
Message-ID: <afBe_CQ0RtmT3xhK@kernel.org>
References: <20260405125240.2558577-1-songmuchun@bytedance.com>
 <20260405125240.2558577-13-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260405125240.2558577-13-songmuchun@bytedance.com>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: AA6B620010
X-Rspam-User: 
X-Stat-Signature: hgnmkq38npjuo53y7dc1yc3z8cqybz3m
X-HE-Tag: 1777360645-474759
X-HE-Meta: U2FsdGVkX19rAphuy1ovJp6l9FK0JM7BI7c4A9152T015i5W/Nf91aOa7oiz3KexiIL+Ve5CM/zkmi3V510IBG3JHUu1D1AfsZ6l4Ae1TvsjTJnMBDP+uHlYGplBNQiFakVY2CdGYLzFaUCMZSuj4RNE14Lomn6PahYJ+SEPgJ4/dkhnnRqABhEpWyaCSjCWIFO7OzIZpBH5ce6fo6lQVpjjG30yiQ5aeFfZaP236ligtvSN3FaF4drreuDsFCf+7of9wp7LV+ajZYmPwn6fFiGLjgSlOjuYqy4tFH/sKWaJt0jlQOc3OaxrmipdUbJ0FwEzsWNEZog0sB8YgMJIrHsjeo47RXJv/eISwcck6xbpTRgsEw+7Bk0tn/kGIyUeKnTdExe/hSIyhFGOfCSm0N59nGDVaNCIQIXQe60Y2O4+zds6WMmyaMjKdaIBpxpdG0du37aFGeg6IBtgIhAgWqhyLKPfjnehtpyDMpKWtWTKhVk45N2fSetqWqICiiJz05qKx/i3MaRnjkhf8+8mOIhK9IJj0wL5su9bWkdNelARrE+4s52b4+VmretxAFSYmbCqRCx0vTiFBLwiQq4UU27tDc2vnGwlEtEdFvj1YK3AiHFHC+tS0H0pVUPH0yBWBNFJPw/f9Afd+nkPQA7Z71I8gWvSdaOrRrS+CrBLj+EcoS2qwJKOU3O4udwOL3Yeb41/MLcyiO2eZeXxzAZI3Ee0FUW8kxyd3M32NTHzvH3Erk9QS6ojQNiSTV2ovTQRgvc+hwH/p3A9NrXp+keRrYmiQDsEeahWCUfLEA/tADd/+EFodXehWAx7hLPWnZyzICAMWHQlPZFz4UoJBCCy8XQWeqiaSsSzQbR88QQ9xmPqx9GldcSWn+egEuPMShrJAe7+zd9gkzqQLfe/ubb+hG7/3S/QcEvr+UXDaexF7PEHOtqA2BLDNVUrPayMlMKI6kyvJshXbhFPJBxD6Jm
 39IGmAy6
 bALqpnsU23dpQwOjWPUJiCIcL3uPCdvuSKD6c9McPRwxj17oYfSasAYeU6EDn9uLyLXLEkDz/hBENa+44c6t9TZ/4iEuiCJeX3mWXM7sBMrqIIOqjmq77RnKd2GPcpZR9i7Y+TlfNsMjz9Uvniu1q7SSWDkLhsyZDjwtUc6KUjvCPBGO1MA3MCL0Y083L/J4A/cuRkJBuL/1tlA5YmlGQ8VCOfLyC2TzCynqbjGpdRQc8G6Aa2RiwFRIFfmeOXNoXVkdFnEAsNPDgN4iVZ65tpk4Cx5jiBomfNzYde5snbRU+PZXt98GE5Z0MAydT/7gZxD29Il37cgqiPNSa+AiW+400tNVIzFHi4bjM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Apr 05, 2026 at 08:52:03PM +0800, Muchun Song wrote:
> Since set_pageblock_order() is only used in mm/mm_init.c now, make it
> static and remove its declaration from mm/internal.h.
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>

The removal of set_pageblock_order() from sparse.c should be moved here as
well :)
With that

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  mm/internal.h | 1 -
>  mm/mm_init.c  | 4 ++--
>  2 files changed, 2 insertions(+), 3 deletions(-)

-- 
Sincerely yours,
Mike.

