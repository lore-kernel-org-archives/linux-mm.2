Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40920103E2F4
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 03:18:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E91D6B0088; Wed, 11 Mar 2026 23:18:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1974B6B0089; Wed, 11 Mar 2026 23:18:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 076856B008A; Wed, 11 Mar 2026 23:18:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E86A36B0088
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 23:18:36 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9BD911CAAC
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 03:18:36 +0000 (UTC)
X-FDA: 84535953432.17.E662C37
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	by imf27.hostedemail.com (Postfix) with ESMTP id 9CA0640003
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 03:18:34 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ZN0Lz3w5;
	spf=pass (imf27.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773285514;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Dm2zCVu+a2rsibDge+oUz5GDb5YRFWaHQ3feSYuG1h4=;
	b=uSzOdEa3kZzUO1wiv6/WcMHN1fjxabizd4CYoiBEDJxlF6kbrT8s2ELg7p+SPLG6/tKUFq
	6ZpKn7YNwXEQ18wXV3Y7N5U3ckYSwagvL11MMb/3cH319y+QcBPa+kcTllUbZmIlzYrG8O
	FO7B8l906+oK8BppiExdaCExfCfrCmY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ZN0Lz3w5;
	spf=pass (imf27.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773285514; a=rsa-sha256;
	cv=none;
	b=A1vR+iqcFwleKDJz6nTQzJkoCQQzErc1sXGeSXq3hS2UM+GN5ZILmGsZdP3e7wG30tBurf
	LVzv6TfTq+CED/TytG9thtnoCXfiNs9cnvqCjFcAFFK7BxbS2NCVpiYETZnNg78V/vbL0A
	vQxdycLLVZ+/S+c/G/MXLQIuXtEesRY=
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4852ff06541so5033265e9.2
        for <linux-mm@kvack.org>; Wed, 11 Mar 2026 20:18:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773285513; x=1773890313; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Dm2zCVu+a2rsibDge+oUz5GDb5YRFWaHQ3feSYuG1h4=;
        b=ZN0Lz3w5vJtAkPPX/gb7FplpILoWsXNT7H/bQ0bZg65p+ovS8syuKKRg7Q18/xHSrq
         959TNwTPRrxBVfCTUYCcdAIVa9VwtK4DE73F/KJ9Nik0FOeZ1LugqYnlTzGY5i0U309C
         tuQagMv0y+WY7iFcV+eGXBPH74ueBQttS3fSKlImn+nbTAKoZ9n41fkYEFiN3OIGlhkd
         RPZWgTExlJvQAqHz8jgn57flPqIdMIyJgt0qqwr839zahJNTODV15RmcTgh3YWxy4QpI
         z7d5e14jpyuG/yq6NooEQk6Iu0+uH2Lkgfne1OOmVrefoSTMve+zW5To/Dm8fiajh51v
         VGJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773285513; x=1773890313;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Dm2zCVu+a2rsibDge+oUz5GDb5YRFWaHQ3feSYuG1h4=;
        b=eD4iLbsvqFe71oAnSVORlPQVNgwvNGyby//0EPXyryiLZyJNByEIer2e9+SuwiLXEa
         pgqeRQhLEy+BKvDJ/rtnPFoh4UZ06I5ADykIELgHU5ubTeYQJzahqVI+4awVismGal6p
         gQ1KmJBcSDDSrffBnYZBhox7h4xDJmCZg+ULgZ046CfizvdredThF5ohjPYvaUBDOkEy
         iqiv1oFoERQ4Un7KeqEL2gCgBnlm35uPhhbf7AUxC8ODwrb970nYPHxaxH0LBv3grG86
         CAjSprQ+vDpU6W9/0JhflQYqrlxFJIx7136NFprg8ZJ9HIX5HjEFXEaXUI6dCZIloK6W
         /F7Q==
X-Forwarded-Encrypted: i=1; AJvYcCULbocPGKNgr5kxQF1PudX/4wi7NroVVl/4e4Ftcb3UKEOBP7J9oulAjWcSZOsDak/7AA5rXjgbtQ==@kvack.org
X-Gm-Message-State: AOJu0Yz0m6RdbVxnQ7g0xMu2dI4ePa2zJCM6P1WSQ4E3zbskANZhPoQE
	p7K3tE+Ih4MnLaU9IU/GFeZF+37X15/X3KSX+1tkPnqKp5pWLIb1cuec
X-Gm-Gg: ATEYQzx3jXt24897TPLqKK1LOuC40dxSotwh1f9wwGq/g3xCqsOePYrXNdg4je+qSML
	MsE1j5JeRacIfHdG2jQinD6czbKdOGiuOpK3EMtMrz8t3J1cj4HzRY1/m8TM44EopBmfNuNhSv2
	liMXCzBh66aJ5N9+Y6iSX16IuIxKAHLqg/vbpyCNdYu9riMabNzetGfBJ2iNDqh+5Ie1xwFOUXv
	SAR6MGiqaT/VRRUFFJVzUSfpVJm+WgBeklyrWowSKPY/DIHaBJF0vDvR/BpxrA+uhP5Q+osmLRv
	tHknqNyZUsEFyA0MFhRR1fslV4TmUT7o9D3s6GD/6uFqQ74TncaJUc4ypv/ky69KHi/etciHMTU
	vsL6o/ojDaZ39KRr8ob/S6JDZ0JmEjl/jBSW0CUSpPA9jMQJxYOgpQq7oqQutfqmY4SWrJi3qS+
	1+lp2mFAlyT6y9+M4wDp2gEw==
X-Received: by 2002:a05:600c:8b26:b0:485:3d43:7c9a with SMTP id 5b1f17b1804b1-4854b10c856mr71235035e9.25.1773285512686;
        Wed, 11 Mar 2026 20:18:32 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4854b0f0b5dsm32170905e9.26.2026.03.11.20.18.32
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 11 Mar 2026 20:18:32 -0700 (PDT)
Date: Thu, 12 Mar 2026 03:18:31 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, npache@redhat.com,
	david@kernel.org, ziy@nvidia.com, willy@infradead.org,
	linux-mm@kvack.org, matthew.brost@intel.com,
	joshua.hahnjy@gmail.com, hannes@cmpxchg.org, rakie.kim@sk.com,
	byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com,
	apopple@nvidia.com, linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH v2] mm: migrate: requeue destination folio on deferred
 split queue
Message-ID: <20260312031831.xb6rvrelhw54cmio@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20260310105419.3256755-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260310105419.3256755-1-usama.arif@linux.dev>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Queue-Id: 9CA0640003
X-Rspamd-Server: rspam07
X-Stat-Signature: qe34q46oswkjqtem48hszwh97s7c58er
X-Rspam-User: 
X-HE-Tag: 1773285514-820525
X-HE-Meta: U2FsdGVkX1+L3w7cC25HxaYdHsl5WPW+M2rQgD4p7DFF0s4b0J+zHC7W7Cuty5UkiJEDxg9N7cmeHlvgt0q9QDUF0um0lf/yFfBy3lLQ/H9WqHCdR3+ts5Ot2qDjY9rhqKtwBwAJyMCoV4uzKeXEeUAT7TWkl1X8wrKUDvrM1qUB7+SNLiUJxs08zS14i1xINLMNZofNrtsWRPN78UrE+FFtrpXb6+w44hlaPuNM3TQFIs5zjNYsacdrBNlCO5Biy4qIiIP+cM2v00qNvKjLIiWXMNlVgY5cLhmMNESLk4BqesKKhGN4aLoOR5BNDhdc8dAJgVxY4mVsFBIhEWDOrol1h9MnPWzLSvNxZF3tp598RBvP7OxCHew5WRU72rs5iDxa15fgRSdD4tiz7Qwj+sraJTNz/E/x/oQgz0BLZJ3aEuiwhe9RO8qjsYUZJszEFtXRk6MxDVqlo9nsIh15MPQJtRM8vAOO9Y5X8RQ3R+oXE30ULRYHq92VWD90Z+akTbEohSh6X3aq+xkEHR7DSY00QMQ/tEuOC9Yp7/5DvCPO4+ZG2MKm4oxLmTSuvYUhADf+1VBMBW0/HTNcEK3d+xmVp13d0qn/m8TQ4CBeDDA6/cIi+NCPEG6j9eYU6E5ymgRLsR1AdcZNjG+DlRSXhbGQCIqOJSYsNZ+S5iFfPzBUjCXj6GArbZYwLgNTKnnszZKqw2XngmpKtsVs5Wo1bnLmqzOn0rxTUqA9V7Y2NXGcI4DyscWt8uGvuWY0p8XSSb4eGNYvFbDnRN6PNwnjTiy5/B2nph3AXS34voYXBr4Uyyz8RlUveCiDIF4lxbO89frK1MRI8UTPGSC230U+68PsPZS2E90xk4p2P0MsefXySwv5PHxkG2BS8LhggdQCiUdeko+DjKSs5EIFEl7lmYOyjbmb7BGFBMzBF73hdtGWsjOZslDKQUNoGOd9Fziy9t2lZ6IBPuNAhpNnyrN
 ce5amT+b
 IFTz5dHx1zbymgGi0KUd0oewlciRg1z5MFwSd5JqqNJQJHYwMA1dE+R7Ro3XemDfmZXfbHK+i9DvVL1nik0T8xv7MeZOBEWrPoR4JbKhKzhqiBZrgvwNXuRdt/TvHGy4X2OpWUJDJBNYbEbpXnP87kGF0Zdnar2oilQg9RUOwL4QI+UsSn/5aa+LC1eGalpqarZu7teJUwtAdXHSRMYD/x+Cm70FylbPCT8TeFUMf9CC+34yC94yHQY9ud+U4IFELpaflJMSN1B6i7oKfy9ClomW//W+M8FxiDaIG2a5/txx6K4sKW/Lq9FZs5Dk/gfX3J0ETV1sqU3M+B8kJ6n8yuqalCWzLmgsw8PbKoZqaTXcpphb7UL9aNYFyxrV2N4LBPWDWW24x+FmDjTYJKTCGPoKQDuS1tvUTjXgpoM16Kb7XgNoK6qaBaiWFFOoONXgi8Fmw/Zh+c5NiakkedDczSdq4dyPQhXmrmHY1s+JIvp7HGxaXcm/Ao/RavThwgzvYR6pflMLHTFptqq8buO2xpKC9Mp35BD2Di/2d0NJz8dzo/8zVnKonsd1Li+6wv/5Rfwl4uFi0A12kBGxwrOy/Qyy4HAMNjbACLfvvV9HNGcnFSqK6FJXXvEZSTyPiCv4n2d0fz8fhkyLbDyF/e7eNpGSBXPktAUes+57Z0QRMiEIBmERCaUGmLgxZ8FZQdwT62tu0gK3wNUhh0EHrZjp5gqvtB7b+7xftUSkFz8jJJzvuYxGSAABVDFgOM2K5sx4tUjzT4lQxFpeX6aO5TW8uUYBLohRc13jWO0mS8O0QQdrW0dpgNUrWe0r6cUZKeVa2C7SCJCVdVpAlAuKXfq4+Wbk7zl5ZVKDVPV25
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 10, 2026 at 03:54:19AM -0700, Usama Arif wrote:
>During folio migration, __folio_migrate_mapping() removes the source
>folio from the deferred split queue, but the destination folio is never
>re-queued.  This causes underutilized THPs to escape the shrinker after
>NUMA migration, since they silently drop off the deferred split list.
>
>Fix this by recording whether the source folio was on the deferred split
>queue and its partially mapped state before move_to_new_folio() unqueues
>it, and re-queuing the destination folio after a successful migration if
>it was.
>
>By the time migrate_folio_move() runs, partially mapped folios without a
>pin have already been split by migrate_pages_batch().  So only two cases
>remain on the deferred list at this point:
>  1. Partially mapped folios with a pin (split failed).
>  2. Fully mapped but potentially underused folios.
>The recorded partially_mapped state is forwarded to deferred_split_folio()
>so that the destination folio is correctly re-queued in both cases.
>
>Reported-by: Johannes Weiner <hannes@cmpxchg.org>
>Fixes: dafff3f4c850 ("mm: split underused THPs")
>Signed-off-by: Usama Arif <usama.arif@linux.dev>
>---
>v1 -> v2:
>- record whether source folio was on the deferred split queue before
>  move_to_folio() (David)
>- record partially mapped state and update commit message (Zi)
>---
> mm/migrate.c | 17 +++++++++++++++++
> 1 file changed, 17 insertions(+)
>
>diff --git a/mm/migrate.c b/mm/migrate.c
>index ece77ccb2ec0..61013d258eb4 100644
>--- a/mm/migrate.c
>+++ b/mm/migrate.c
>@@ -1360,6 +1360,8 @@ static int migrate_folio_move(free_folio_t put_new_folio, unsigned long private,
> 	int rc;
> 	int old_page_state = 0;
> 	struct anon_vma *anon_vma = NULL;
>+	bool src_deferred_split = false;
>+	bool src_partially_mapped = false;
> 	struct list_head *prev;
> 
> 	__migrate_folio_extract(dst, &old_page_state, &anon_vma);
>@@ -1373,6 +1375,12 @@ static int migrate_folio_move(free_folio_t put_new_folio, unsigned long private,
> 		goto out_unlock_both;
> 	}
> 
>+	if (folio_test_large(src) && folio_test_large_rmappable(src) &&
>+	    !data_race(list_empty(&src->_deferred_list))) {

We usually check order > 1, before accessing _deferred_list, because it is in
subpage 2.

I am not sure why we don't do it here. Do I miss something?

>+		src_deferred_split = true;
>+		src_partially_mapped = folio_test_partially_mapped(src);
>+	}
>+
> 	rc = move_to_new_folio(dst, src, mode);
> 	if (rc)
> 		goto out;
>@@ -1393,6 +1401,15 @@ static int migrate_folio_move(free_folio_t put_new_folio, unsigned long private,
> 	if (old_page_state & PAGE_WAS_MAPPED)
> 		remove_migration_ptes(src, dst, 0);
> 
>+	/*
>+	 * Requeue the destination folio on the deferred split queue if
>+	 * the source was on the queue.  The source is unqueued in
>+	 * __folio_migrate_mapping(), so we recorded the state from
>+	 * before move_to_new_folio().
>+	 */
>+	if (src_deferred_split)
>+		deferred_split_folio(dst, src_partially_mapped);
>+
> out_unlock_both:
> 	folio_unlock(dst);
> 	folio_set_owner_migrate_reason(dst, reason);
>-- 
>2.47.3
>

-- 
Wei Yang
Help you, Help me

