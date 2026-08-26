Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8FF91C61DC4
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 09:22:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A674E6B00E4; Wed, 26 Aug 2026 05:22:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A189E6B00E5; Wed, 26 Aug 2026 05:22:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E0796B00E6; Wed, 26 Aug 2026 05:22:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 62F7D6B00E4
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 05:22:04 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D64351C1852
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:22:03 +0000 (UTC)
X-FDA: 85142878926.12.CF7C642
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	by imf02.hostedemail.com (Postfix) with ESMTP id 12F8980008
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:22:01 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Jwd+MxWE;
	spf=pass (imf02.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787736122;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jALS777Z+qg1ejYQPjNAfxupaXWG07m9ugFq1DHHkyY=;
	b=ayiCrLKtd5EwjYnBwKlAKW61ibEX0F/W/I1zpl1iHy596MWPMpRLtySvt57ZbCA5wcgsE3
	x7XKrhWWd73UJkrt6T/Edc1u8VhKVrNYF3tkd76K6d4O2zAsqiTCDmcuuPDy+gkPzhw9J2
	TkHrv+GcyUQpjLNbdgLcP8EeoMWZOzM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787736122;
	b=U+RBqBQJOwfbDvbE77nLxEQZZ/ctOsRYDO3y8ebPv0XCGoiYpISU+l2NBH1qRO5+UasvjI
	ovxvriq94I4fkq3wXT6GSY6FYmhsAXk7Plwwizv3wRlrmukNcf2BkfbLEZ/E57oGyOyNY4
	tX+UUIzOBvtjdEIDYZtjMitQgUW394k=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Jwd+MxWE;
	spf=pass (imf02.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-39675172593so509994a91.2
        for <linux-mm@kvack.org>; Wed, 26 Aug 2026 02:22:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787736121; x=1788340921; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=jALS777Z+qg1ejYQPjNAfxupaXWG07m9ugFq1DHHkyY=;
        b=Jwd+MxWE170kan8v8GPSMW1W3CUoRbwLAuGJ4Z7n57TSKOKHhe844E8hWAmsrHJb9+
         VFuq75uZR21qTm+cBE2iHh5YbkWaEgcHwmYHW852wZ9Bg+l2LObqO71WP92f39pjqyA5
         GS2ngJKsoQO480NXJarUTAlJEZZ0SJGHBFDyrr+WTgIMmnuTqaFp33eZnygI9dKIq98v
         L/8/mfjSFPHyRiHwlJnAcENmcSH/BEW7nyCRsj4auHgEeNZaxHjyN7JAbmtZVFZOj9CO
         madkqn6sdlBmBQVYVAUkIgHLYTCdxh3xRswyhqKKU3NEUl7EueO4wDPOJ9QCGoXNypvF
         f6sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787736121; x=1788340921;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jALS777Z+qg1ejYQPjNAfxupaXWG07m9ugFq1DHHkyY=;
        b=HKYJJFzYbTjHdx2ULesh4j0paUHcd2ZRTmcpbMQ7pWPdVIigVlg1VRtboAUgMZpLy2
         puUu3X8CUQfsLEd336Pda0v2Ek3jRJC5TV7yNcvE0V2Lfgbik/n/dVlRheWERUHSUWw1
         6sgAo2CLyGHp+Y2C+kY4N18QYkYu98TFDEKmgBxh66Wm5AqGbJ30yDK3ZiAX6Ibwdj5O
         yRHjaInLLC6Z8rIi7dD7ldEJ1ws04P074JEI63AGjSD8UAxMdOKD9eRbxC4ZC+v6/1D8
         nP1f1MApZl4xM6/5tALsN11UiOI1M2jp8lkMKS2sgVZXRWZJ5pYqYm93lxTeMxuRURpy
         moMA==
X-Forwarded-Encrypted: i=1; AHgh+RoHBKRlNL/3PTpraoyX+K71nz0BVl1ZC6zsr9HOXzX1lyNvGGSZpuKax0bvG0WzO++8swcXiLYq0A==@kvack.org
X-Gm-Message-State: AFuF++mthlJdYQzCyA0aHVhtgc54PznXYo/j6fMhk/v1F1WGsTwSCxG7
	CTRmSSUy9jwDU5Nip5NclE/FPUMwoNwOyEfc1t+bfPbj0t8mUHadQb+J
X-Gm-Gg: AR+sD12YMDbjEq080ZKSsKQ7d9O9HrVKirB2gAIBOxYgtp19eWVNuKR5lDVeVODcLT0
	JqbYfvXnz9zvsxhIA4RZZ6FR0r0WmYnDQaxD3zgBR/7Rxwbp+Llr5FZXSjpOFpSL3fp/HihPRi7
	xx2fAfhCaBXLL1Y6nYVCXoi/HzJlAwqdZAUVwRWSECmbqzv9B0qJ+ycYz0GxeFOfkf9YftILfct
	BKdBMK7AoHOq7wZfw5HJ1gQVekBWM6EjRmFmPY4MXIASFFwdogfc6jdG/Z7sGiO2GngAGM4D9At
	071BlrZrWF/BjarCFWtBXvS1wpqXui4+PX6RwdSB6d5o70yetxohHqJnqd3FDRzA0rqJ0DpbJyT
	XR8+aThFjkFDX7ZFxpiDXjw0AGM+8X0Da2rVHIWgCeMjJNXXDKglzjF+LmGTR/ef7opQSDX3SVU
	PWFpYQs2cqtsomWTSkZW82szMbBoyW2AgNCAJ4Akj0KmbpwVZM8w++SW1NYIcQrJ8LDnEQbckvx
	YWRoCDT30lK2Q==
X-Received: by 2002:a17:90b:1804:b0:36b:bec8:94c5 with SMTP id 98e67ed59e1d1-3966d400328mr10605164a91.10.1787736120866;
        Wed, 26 Aug 2026 02:22:00 -0700 (PDT)
Received: from localhost.localdomain ([240e:b8f:1df9:a600:c693:b19f:ada0:748])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39645da08desm7002492a91.17.2026.08.26.02.21.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Aug 2026 02:22:00 -0700 (PDT)
Date: Wed, 26 Aug 2026 17:21:51 +0800
From: Vernon Yang <vernon2gm@gmail.com>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
	akpm@linux-foundation.org, nico.pache@linux.dev, ryan.roberts@arm.com, dev.jain@arm.com, 
	baohua@kernel.org, lance.yang@linux.dev, usama.arif@linux.dev, zokeefe@google.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, stable@vger.kernel.org, 
	Vernon Yang <yanglincheng@kylinos.cn>
Subject: Re: [PATCH v3 1/3] mm: khugepaged: fix swap entry value to
 folio_pfn()
Message-ID: <330789dd-94e2-4827-abdd-23671263608f@gmail.com>
References: <20260824092935.73892-2-vernon2gm@gmail.com>
 <edd7ed8d-0f2c-4de3-89e5-f2b23c2dd1e5@kernel.org>
 <6a9c2369-5589-4f2a-bcfe-c6e3b46a1ccd@gmail.com>
 <c8e3bb54-e4f1-45d3-8059-3ee1910a920a@kernel.org>
 <ao6c6Oe_KV0O1LJn@gremlin>
 <b6fbf952-c619-4fc7-8a8e-62a0ae64ff0d@kernel.org>
 <ao6fSHW_nX8YC9QK@gremlin>
 <42695df0-3962-4126-9afb-9a1905d096a0@kernel.org>
 <49aa013f-f613-42be-bc58-35956ef189de@kernel.org>
 <ao6jVbVHLUmuY2UA@gremlin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ao6jVbVHLUmuY2UA@gremlin>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 12F8980008
X-Stat-Signature: un9oumgh1kb6ft9f18a65jzkyg1nujid
X-HE-Tag: 1787736121-827450
X-HE-Meta: U2FsdGVkX1/0sz1/ECsxhS9oUzOokAo+K39GB+T1yOv6W/ZL5cPK/K0zWvWqG6vqKFMVuSGJVHPkBWUU5zpMuYVcDD+xcM35u2vPk/62mg9B2bCMXLaCukMQzNxTHXv1EKqGwvSRJapuCBZQRcqXsLgtOjacfQoF3mbDt2zTIWtrLBUF0RI9YfjBeGnlgJSF59FIkjfUGMZ2uxGfIa2UvhpAdPywd6ThEcKXU4o3hQ4GZSDChRnUORFBn6ZT2MPqvMHuQib71VObD5IcwYTpcAMWKW45xMybt47HgzkONCC9qh1hMvC8wBanjtjJwcRwr+rT617dbXrowclsBs2v/kc3gyVKPpDRZ52P+fhmpt0C0UX2zOSXirW6d4zjJQawOQZ1IxWkqk2D/C277cc35g+smfRXAeOp4nVO5mdWjK7T0UkUJqDTBe2iDg5fuhn0tkoTbpnfNddljPD6IHgvuVcZkyXpReEqdfqw76XOBpzmchDYbbXlbe7ikQX+zmD4wU56tFN/fLeRdyjLlqwI8Nu5vNPexjDvjmg1V5pNCONZnesagpqMNOXoivcvCN0+8aPCgcvlER2oetYLuvRHDLiizBI6hDDQvnK87BHd6pBK0fJHde2ZT+pjS9vizrw3IKD0oqUsx3dG9jssrjODt4wuqLc0HKMIBV2fiRXuCML1e3DM/BKJYdGItbkX7vSjaauOW6cfGJ2bbb0Zl3hgfYCyGAs5+8AsIM0I8sokRQmAiMkksHIxar5lMsAPYzoRrGzTWintrZ8/b4PUGY25oDVPAdwyFE9ht6TaSVBtToZ6aAGznNgAJnAJUHAdq1EpFfDiYDj3Ascezwb9PQN6GYIL7vNXHmskIH/9A8LcB2ME6R4qtuOL2ONPWlDjsKPoa/ln0OlPqqVA9T3OitBcPgDaTOU0d//NGC0LLJycUZGJDyGWzKvj0Qx9OtPudNFiAUufFGe08zYy8T4tSL9
 xx0fNvXj
 P5PS3RhVnaC82sndVFhgrIQVuBqpdId9jL058iSS5QxRdlM0319U+HBxp4jRQBGHIOyzKpvkMlum+yS3AR15nODeTFWaE8290eXx2hbOdj5U923DkR+9LqJ6jXMtDCwAUZt7iviB+qgWVun27fNGsPnTrdLd2/qIgTXga8l/9OkZMwHh9VJK8W+kYaCor6ecd9KBOiZQglvLU2kuYPltJJnGliWewkzllppio/wrPXMMZJQPad8+72O/63X6lBjRsfbfc1nbPwF8bpSyId+g9upKSACs/zvaqnAfcqgdJRagQEXSZePXV//v+BGKsSau3RUyEqdXhBnJogi3v+G0+tqKc3tl9fITYU9SV6yYxUm1K1tLNOBjD0g7Q1yDz6GFKPjrWK2QQPv+ukrxZp7TUVBGKQDCdxndDZmJ43JqfPAWbFrJ6kEjU5e3nHJvAqpUzOkiSwJuatuwkvrQp4eqD5aCMBf/Gi8GHopS5KDxhKO5kkNrnPli4es16XJiHJ3c5YIOSkAptwm2YDd4Jr511HbdsBA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 26, 2026 at 09:35:38AM +0100, Lorenzo Stoakes (ARM) wrote:
> On Wed, Aug 26, 2026 at 10:24:56AM +0200, David Hildenbrand (Arm) wrote:
> > On 8/26/26 10:16, David Hildenbrand (Arm) wrote:
> > > On 8/26/26 10:11, Lorenzo Stoakes (ARM) wrote:
> > >> On Wed, Aug 26, 2026 at 10:08:58AM +0200, David Hildenbrand (Arm) wrote:
> > >>>
> > >>> Elaborate.
> > >>
> > >> It's overly long, I read it and am confused as to what is 'problematic' or not,
> > >> it reads weirdly in English and pfn_xxx is the usual convention for naming of
> > >> pfn's anyway.
> > >
> > > Excuse me, what? Are you now just making up arguments?
> > To clarify, we have various users of "xxx_pfn" in the tree and I fail to see how
> > "this is a problematic pfn" -> "problematic_pfn" is odd and why
> > "pfn_problematic" would be any clearer.
> >
> > I do agree with the "problematic" aspect. "failed" might indeed be nicer.
>
> Right yeah. Mostly the push back is on the word being a bit confusing. Fair
> enough on the pfn thing, failed_pfn is actually the nicest name suggested so far
> :)

failed_pfn is good to me.

> I still think:
>
>        	if (result == SCAN_SUCCEED) {
>                	...
>                	trace_mm_khugepaged_scan_file(mm, -1, file, present, swap, result);
>        	} else {
>                	trace_mm_khugepaged_scan_file(mm, failed_pfn, file, present,
> 					      swap, result);
>        	}
>
> Is a little neater as then it's only on the failure path that we trace the
> failed pfn, and otherwise we explicitly -1.

I understand what you're trying to say, but personally it isn't necessary,
because failed_pfn defaults to -1, and one
trace_mm_khugepaged_scan_file() already covers it.

If everyone clearly expresses that they want two
trace_mm_khugepaged_scan_file(), please let me know explicitly. Thanks!

> But it's not exactly a show stopper this :)
>
> Very rough edit of your patch - if you're happy then let's go with this, if not
> then edit it + post so Vernon has a clear direction. I'm not feeling super
> strongly on this so don't want to block anything:
>
> ----8<----
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 75639298efc27..371ee0b16d10c 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -2683,6 +2683,7 @@ static enum scan_result collapse_scan_file(struct
> mm_struct *mm,
>        	int present, swap;
>        	int node = NUMA_NO_NODE;
>        	enum scan_result result = SCAN_SUCCEED;
> +       unsigned long failed_pfn = -1;
>
>        	present = 0;
>        	swap = 0;
> @@ -2714,6 +2715,7 @@ static enum scan_result collapse_scan_file(struct
> mm_struct *mm,
>                	}
>
>                	if (is_pmd_order(folio_order(folio))) {
> +                       failed_pfn = folio_pfn(folio);
>                        	result = SCAN_PTE_MAPPED_HUGEPAGE;
>                        	/*
>                          * PMD-sized THP implies that we can only try
> @@ -2725,6 +2727,7 @@ static enum scan_result collapse_scan_file(struct
> mm_struct *mm,
>
>                	node = folio_nid(folio);
>                	if (collapse_scan_abort(node, cc)) {
> +                       failed_pfn = folio_pfn(folio);
>                        	result = SCAN_SCAN_ABORT;
>                        	folio_put(folio);
>                        	break;
> @@ -2732,12 +2735,14 @@ static enum scan_result collapse_scan_file(struct
> mm_struct *mm,
>                	cc->node_load[node]++;
>
>                	if (!folio_test_lru(folio)) {
> +                       failed_pfn = folio_pfn(folio);
>                        	result = SCAN_PAGE_LRU;
>                        	folio_put(folio);
>                        	break;
>                	}
>
>                 if (folio_expected_ref_count(folio) + 1 != folio_ref_count(folio)) {
> +                       failed_pfn = folio_pfn(folio);
>                         result = SCAN_PAGE_COUNT;
>                         folio_put(folio);
>                         break;
> @@ -2773,7 +2778,7 @@ static enum scan_result collapse_scan_file(struct
> mm_struct *mm,
>                	}
> -      	}
> -       trace_mm_khugepaged_scan_file(mm, folio, file, present, swap, result);
> +       	trace_mm_khugepaged_scan_file(mm, -1, file, present, swap,
> +				SCAN_SUCCEED);
> +	} else {
> +	       trace_mm_khugepaged_scan_file(mm, failed_pfn, file, present,
> +				swap, result);
> +	}
> +
>         return result;
>  }
>
> --
> Cheers, Lorenzo
>

