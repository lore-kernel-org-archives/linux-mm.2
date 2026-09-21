Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4783C982EA
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 02:49:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE0266B00AB; Sun, 20 Sep 2026 22:49:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C91706B0103; Sun, 20 Sep 2026 22:49:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA6336B0104; Sun, 20 Sep 2026 22:49:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 828D26B0103
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 22:49:30 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B9C1E16055A
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 02:49:29 +0000 (UTC)
X-FDA: 85236238458.04.45F5A00
Received: from mta1.migadu.com (out-32.mta1.migadu.com [95.215.58.32])
	by imf15.hostedemail.com (Postfix) with ESMTP id 5E810A0004
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 02:49:27 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZC9TcTYB;
	spf=pass (imf15.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.32 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789958967;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XMxbaURq0ARPV7IiQLeDwQDg3VcGo85G1M0PxrZyGrI=;
	b=PYMFdGOPdm6SUaYEOmye5VPsiFOPg6joikxzr+XQhz+1OwVOaDRNx/BI5JBH4D4u9sO3Yu
	Yepn2vNWhrARMcFVWqE67I1j9R0CvvcgnPjfwtw+QTWdOipFI5wk4tptPcK5o9U9LbSzKP
	3+8AfhgKxQGDQzxJNMgsyZL40JPQHW0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789958967;
	b=7IyEMNBbxXxube1wChgnZaF55wdTmhjPpo3vSIA3FjXXPG3i6m8iQ/YPkLTxwH0gPl9/eS
	gKmbTQdywxOgVLZdw495FqQNPhKrKM9YQpCv3KcrPTH2THprqHM4VtqGbkUUa5jiGSmdlK
	qFQnkQboNIRhNL4r68lVPgupzw00pGQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZC9TcTYB;
	spf=pass (imf15.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.32 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=M1OuwPSXFYrCV5avkmZ8uKad0kejTbrSuXfsjAW6Osk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789958965; v=1; x=1790563765;
 b=ZC9TcTYB9YnKG+qckGRcRDwTiSGh41KZA3yNbqGQJWnXIZDNHoBHUMG3F1Thfhv+XGUXyFDt
 JEiG06jL9K4KbYEU03vLXWeo0ezekmtuv/yho8pYj0nB5bMsstYEBftBJIGWGV9ZRq29C3ljNEx
 vRiJbG2nYeYFs2PNiQxlM7Ug=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id dfa1332f1bc8a3c0;
	Mon, 21 Sep 2026 02:49:25 +0000
X-Mizu-Trace-ID: dfa1332f1bc8a3c0
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: david@kernel.org
Cc: akpm@linux-foundation.org,
	jgg@ziepe.ca,
	jhubbard@nvidia.com,
	gregkh@linuxfoundation.org,
	peterx@redhat.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Lance Yang <lance.yang@linux.dev>
Subject: Re: [PATCH v3] mm/gup: honour FOLL_PIN in NOMMU __get_user_pages_locked()
Date: Mon, 21 Sep 2026 10:49:14 +0800
Message-ID: <20260921024914.12819-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20260919-nommu_gup_pin-v3-1-3660a8851243@kernel.org>
References: <20260919-nommu_gup_pin-v3-1-3660a8851243@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5E810A0004
X-Stat-Signature: ttuoybypquxug6cmk6r7iozcubq3bq3u
X-Rspam-User: 
X-HE-Tag: 1789958967-136532
X-HE-Meta: U2FsdGVkX18ybltaTmAOvhX1nRpGFXwzTf3/aNSdaAE2dsPgV7gjrRvBG3nfPMRQwNJAVGGLpJjtM8Cge1vxjhHqEYr9d9LGuveUovoXd6l28m5XQUN4qcF3tqDPYwTRGeGCVp1MLUevNSm23pYJC6CQ2XDrkkmMXum6AD1/s0uy8Csm/bIoDw/lEtUCLgG38ouv3aGuQsfecn0rcnTcj9jGxdnmG5HI04ZNqIS7QlxXbBfkrG/MqsqqqUWh8EMqflX8/zpuIEV9rhXayTsSgf1L/rEFloUFkNSOEEwou76a8wmdiJL9Kvb3gZ6WHxj1CUgXJ8D5GYIdRJ6YiASzJCAD9XhGbWgwjUsXv6Hjx9xGpMtDn4aM/OXBpihjDUn+EYOvvE0je959XZMXrY59c9ZwGa+dtwWSnNExsWmA9F9Wy/Wph1j4w0QLQjb/TnUin+wTTIjwPivKl6J1YD5d7KN+BXpBgsOlN7LBtgAo1GyWLrMW7yKRk6LQ97uwVKnE/3EOVYAd/o1zvnx91U2qNVK8lrJKwkrKsUVi/KMu3hB/elbd4H+bjPFANU0jEktWWgCL034WxgPpjOISfHJopk0bDR5S59PEtLrkmoTFe3yJzuNA7ksRlOFuCi8+qx3UrJQbN1SNkgFPMOiXb8rdReo1r5CxOJdZ54xTk14Y0lJfI1JtLxUmNP6BZGM3FV5uAfymfK0LtvVbFIiW6sT7KnxUODtFE5VHNtSGHVuBiNSAXNTVSBkwk2UfG3qmUcy9uKQuUuVNZZDZRlfBH+pCfAqh8oyJEBibSxyvjydjZPDvbzw9+wpcZE4KIoIM64QzFPvIcDk+1FL9q+6VtFN/5CQG7XIoNBEiqpg+aOmwCiupitkKTi5DZR62MtKTvZ633YXgfeC4u3X/Jl50rUkew4qkwSotBhwca8qQydmvhR7XxKoc3Op8WoQVMOjheuwusxgbnf52pOHggESXXyF
 2jeUOUSt
 XaYpgIDHXg85AAaQVSPa8d0tc0IUQlcM2FSqYb/htHh2b+tfktk2FonwjiAVTapEcCCnU6st2SZDBl55lOGzneorFQ9f9HIAIBKTMkZW9Zx/Gtub4IgUKgLowsoc7gREXWRCDdvG7I+/4hcib6Jto0Y9sQL2Xb81EFtBHUh20u45ZTdDJ5/ghusiu//RHt7Ra1S+0C7Pwz/zKUQgpP3rvo4RIuKyMuk9oNkOQx6TwRXr/uHEhvS4IgeZUwnQ8aKy2uKrqXQRRCugK3sG6JWIHugSuz7uGTZP4uMfwJ5UuOgXPpiaKFQw6aDrqAaZs0ANFon6jZAve4WsM79GNumFNVDG36wYelpRO7K0tdxncF3FzZRr1FzAJxpJ2wbRD2+53Z3jzYH8V5C7EKNjtUbM4dV0oQGyBM4VBWSm2H5MtqywK8JQo7nNoTJyGJlZ3B8+0R0TUiOykqi4epEswCkZ7d0XA2JgqZiPjfOavcZTgj/znAz5hhaNWs7nXx3+J2ELuFEqh7UFzwQti5jBkHNjpbv61eQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Sat, Sep 19, 2026 at 12:04:36PM +0200, David Hildenbrand (arm) wrote:
>From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>
>The !CONFIG_MMU implementation of __get_user_pages_locked() takes a bare
>get_page() reference for each page regardless of foll_flags:
>	if (pages[i])
>		get_page(pages[i]);
>
>This is reached from pin_user_pages*() with FOLL_PIN set.
>unpin_user_page() is shared between MMU and NOMMU configurations and
>unconditionally calls gup_put_folio(..., FOLL_PIN), which subtracts
>GUP_PIN_COUNTING_BIAS (1024) from the folio refcount.
>
>This means that pin adds 1, and then unpin will subtract 1024.
>
>If a user maps a page (refcount 1), registers it 1023 times as an
>io_uring fixed buffer (1023 pin_user_pages calls -> refcount 1024), then
>unregisters: the first unpin_user_page subtracts 1024, refcount hits 0,
>the page is freed and returned to the buddy allocator.  The remaining
>1022 unpins write into whatever was reallocated, and the user's VMA
>still maps the freed page (NOMMU has no MMU to invalidate it).
>Reallocating the page for an io_uring pbuf_ring then lets userspace
>corrupt the new owner's data through the stale mapping.
>
>Use try_grab_folio() which adds GUP_PIN_COUNTING_BIAS for FOLL_PIN and 1
>for FOLL_GET, mirroring the CONFIG_MMU path so pin and unpin are
>symmetric. Keep supporting the traditional behavior where users specify
>a pages array but don't set FOLL_GET.
>
>While at it, don't return NULL pointers in the page array,
>as this is really not expected for GUP users; instead, just fail and return
>-EFAULT.
>
>[ david: support traditional behavior with no FOLL_GET, extend
>  description ]
>
>Cc: Andrew Morton <akpm@linux-foundation.org>
>Cc: David Hildenbrand <david@kernel.org>
>Cc: Jason Gunthorpe <jgg@ziepe.ca>
>Cc: John Hubbard <jhubbard@nvidia.com>
>Cc: Peter Xu <peterx@redhat.com>
>Reported-by: Anthropic
>Fixes: 3faa52c03f44 ("mm/gup: track FOLL_PIN pages")
>Assisted-by: gkh_clanker_t1000
>Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>---
>I added a best-guess fixes tag. Given that this has been around for a
>while ... and it's nommu, I think this is fine just going into the next
>merge window. In that case, I will pick this up myself. If we want this
>as a hotfix, Andrew please pick it up.
>---
> mm/gup.c | 17 ++++++++++++++---
> 1 file changed, 14 insertions(+), 3 deletions(-)
>
>diff --git a/mm/gup.c b/mm/gup.c
>index eb898ea1ee22e..1681bea8eed7e 100644
>--- a/mm/gup.c
>+++ b/mm/gup.c
>@@ -1659,6 +1659,10 @@ static __always_inline long __get_user_pages_locked(struct mm_struct *mm,
> 	if (!nr_pages)
> 		return 0;
> 
>+	/* See the MMU variant: support the traditional behavior. */
>+	if (pages && !(flags & FOLL_PIN))
>+		flags |= FOLL_GET;
>+

Wait ... isn't this the wrong __get_user_pages_locked()? The MMU version
already does this a few lines below ...

Shouldn't the NOMMU version get the check instead, using foll_flags?

---8<---
diff --git a/mm/gup.c b/mm/gup.c
index 2ac04f88d244..dea61daa10fc 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -1659,10 +1659,6 @@ static __always_inline long __get_user_pages_locked(struct mm_struct *mm,
 	if (!nr_pages)
 		return 0;

-	/* See the MMU variant: support the traditional behavior. */
-	if (pages && !(flags & FOLL_PIN))
-		flags |= FOLL_GET;
-
 	/*
 	 * The internal caller expects GUP to manage the lock internally and the
 	 * lock must be released when this returns.
@@ -1997,6 +1993,10 @@ static long __get_user_pages_locked(struct mm_struct *mm, unsigned long start,
 	if (!nr_pages)
 		return 0;

+	/* See the MMU variant: support the traditional behavior. */
+	if (pages && !(foll_flags & FOLL_PIN))
+		foll_flags |= FOLL_GET;
+
 	/*
 	 * The internal caller expects GUP to manage the lock internally and the
 	 * lock must be released when this returns.
---

Cheers, Lance

