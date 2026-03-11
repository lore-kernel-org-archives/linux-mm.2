Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C46601125811
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 17:42:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 044E46B0005; Wed, 11 Mar 2026 13:42:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F34F76B0089; Wed, 11 Mar 2026 13:42:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0C976B008A; Wed, 11 Mar 2026 13:42:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D33C86B0005
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 13:42:35 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7A0061B7457
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 17:42:35 +0000 (UTC)
X-FDA: 84534501870.06.34189F7
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	by imf09.hostedemail.com (Postfix) with ESMTP id 4DC1E140012
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 17:42:33 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=PFkesNcd;
	spf=pass (imf09.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.170 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773250953;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e9baRp4ItSdy4YGQdx+WgDhSURna1VhlLruAEGYk0oE=;
	b=NBk83yRmlTEHVSa0l2hL6IGz8TPYvdbLKcNJ9dYtZd9h56mWrYUUW13OOuiFodXvBRESCd
	+HNnd4x1Kgz2pvSrQ4EjfKanl1UOmd6m0AkPchL3re1Qjufqd1odBifcWQ93M8XK0E2WFa
	o2QSPNnUqKirS7dES82uti6Ob82cDes=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=PFkesNcd;
	spf=pass (imf09.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.170 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773250953; a=rsa-sha256;
	cv=none;
	b=GSwXte5K+Cq0yTDO5pUwBIpmhEGZleRt1rMNMR1jaB4tvF7qC0MH6HlOpb0oGhWpfe+a58
	Il14scPeyxh7J7QW9qOZFsaAl8GgFUTJYOFHEm7fxXs/tEcBzF/fKt/fVRoF/puHJ0dFcw
	OMQgt85d70U9/tj4Kuw90gH/2Qn+p40=
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-509101189f4so1084931cf.1
        for <linux-mm@kvack.org>; Wed, 11 Mar 2026 10:42:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1773250952; x=1773855752; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=e9baRp4ItSdy4YGQdx+WgDhSURna1VhlLruAEGYk0oE=;
        b=PFkesNcd1Q9DyW9YZcDOO5wru34SPgvapmKWkIH/PJQOT77UZ1fuCKsnJltT+CTxfN
         yVx7Pigfwcbq0gTHnPZ51a5JxptUdH+B6VhWwm/5/YZzjr2BLlPxS1FzWbp98IQtdFQd
         Zm1qdvozwUo70PsgpRdEH8f3SkK41UfFQ5/ZXkkaPmZW+5vQCh2V1rMkeqKeKQp+DXrs
         +uGNb7gTkEXiSW2EBAfCSsKC+53zuW4z2Z3YgJu+yB0CnA3Q2xEmywSPb9zP++yUNlWP
         aF8s6FWatUOTi+AXVHjXg7KJi2RGWxByoXG0PPeoA7PS3YLKcwnjuVUYvHPnz67CEXDV
         UI4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773250952; x=1773855752;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=e9baRp4ItSdy4YGQdx+WgDhSURna1VhlLruAEGYk0oE=;
        b=JsM9pxonjgyFJYHDSkwdSgahXleAOn1kyKVnOy+0iMYGh1wVNiMITnbMYQngaedioE
         MgoEQtoTmxJHzsCMkvKixOekdPLt80A+D4c6LYnbRXY95z8HLCccBBaIdDdV0V9uQbFa
         QxKC0NiJA0rVR0XAUBWjgqqSpMClkt7YZNqkvXCYjhbYP/qVyLdaENmhywESVcZYTh5z
         vnSdN7m1+KFEOoj5pKdJPRvGL4cGcD8NGhyUt170Iwj6zUyEP5+yuAIQlNWQBlKHZBOc
         50xObQVgrN8bXzdwTEljFcIW/79Em1A7Kdjt8h+H0ns7G4e9WFX5bIwykUqTuVmX2Wq2
         Idpw==
X-Forwarded-Encrypted: i=1; AJvYcCW2q7WCZm83lgW6hFFJrBDonsiYE8eRLRrbBwoWRm5dDhoYBz4BYv43RGHG8kjM9H9pNjrPtNHFdA==@kvack.org
X-Gm-Message-State: AOJu0Yx4qTBoyFfRFoJbQVo39Cj99+nlQALjOcWgaiS1uE0DrX43nOX9
	3rfHF75TvYCH/Aw9zAws85QuoLfEX6IHx9HpODsIp9MVSZeDdYmX7ftstSDdWZ1ULfA=
X-Gm-Gg: ATEYQzxoH/ElrEdG+PIZ+ngwmQbLyevsKVUcsoDDXbnHiF3DJ8ZavPxD6FXuLcXSM2M
	Ns8arOCfN0ncKQAaoY4RZnYeW6utvggJqm07UaqpYy4+bo0FN0KzeUzJ/FyZsaeT9v64yF/Jb7l
	V9P05x1Tixf2IGboIv9DQV3dNdghtpv8G0oreRYooqjMCXVvx4uM1QQEZLmU0XXvZy/VG9CyNbg
	e1546JIhDsx6OzWGYUmiIAx22mdxecPGtJaM9uGG/GUyWuE/rRoXhESY7yWrEeiys8yVcSJF27I
	eA/Xri1j0pecLQH2qwZm2fxEBCExKxQXws4fW5ECbxIZg884NxTj5AOhZ82z+Y6xqh2os3O9C/e
	iymFrasEV72vR1ugtJbhqR+zhEbaP5xIa5neh0XpM6RkqhweE2CIAbCseoh5hbG6PO/nSCMg4tn
	PFZr0CT4eIj5gFnt6iZgck1iBDNVUqHjRK
X-Received: by 2002:ac8:5fca:0:b0:4ee:49b8:fb81 with SMTP id d75a77b69052e-5093a18c8d8mr44267311cf.61.1773250952298;
        Wed, 11 Mar 2026 10:42:32 -0700 (PDT)
Received: from localhost ([2603:7000:c00:3a00:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50939ec6697sm17821771cf.9.2026.03.11.10.42.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Mar 2026 10:42:31 -0700 (PDT)
Date: Wed, 11 Mar 2026 13:42:27 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>, Zi Yan <ziy@nvidia.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: switch deferred split shrinker to list_lru
Message-ID: <abGpgxsDKeSc6cjR@cmpxchg.org>
References: <20260311154358.150977-1-hannes@cmpxchg.org>
 <050ce5bd-4725-468e-acaf-7fca72b84d06@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <050ce5bd-4725-468e-acaf-7fca72b84d06@linux.dev>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4DC1E140012
X-Stat-Signature: ch61reyhku3p67z4yr8o7uzrqb6c7mmm
X-Rspam-User: 
X-HE-Tag: 1773250953-198326
X-HE-Meta: U2FsdGVkX1+dRcS+rFOnSRwW3U3O7NxtBA7KMsD3VRh+HkL6VpOYYCCSPhMr9ZWMiWcrgZfIbwR4yFpFLq2JhpatyhXmzm025XkdlLIfHGaCiYTr+XqxXRBZaq3AfV54BqDmCMEfGGLr/vJSg/TdQ28CPFun+UN+RkGfCDNHC0XBPD4wmO4rH7HpgcJ5iZTlNLeH4xzLEbcyOnMD7+vAD1yvyKRSnv8rexa4+TRZn0I6+xwXPGMgagakDV43o/4KyScsV/3IsgdzdR3y+CH/hK3AznHkvAuhkQvz0acSWpPt+IOf6K0rqmsMUf3331mFiR1/oHjeNhdrnfIgwIr24Y6/dohioZpAi27EihNwqMACashpYkIkT9viHyxKFN4XEh3ul4dk0V1eEg3180d+XMbJmuT9FOplsr/4WUZxZQDKucYoHT0nVVOfARYNjVRme8ooB1BKQlLz3Jv/7l+IolK6V/JO8edWqyZ3vc7EYKLvPcZkJYitsOdPoMga22wCWUU6d26CS9rfRr0/fRpgh7DKb56ENHoX2XBn0kTRBzWfoqYOyHZAfcwEs6KaoxnX9fPUbxx8rGokLfcr2ovC30NiD09yvXaT4IqYULxMtLh9ooXLaYToeoeoYeFswRSIBfxK3Pc9YN0PAIOfqH4hkRd6SAkkPjRhxvWIg0YFPBA6FI5HbeBtCvj2wCjhF54YjLjRSLf3Pew971wmL0v3GJXQ2aeQWwY1a+vMIWkaUL0TZxFEiS1qQDPYFgZYvOx9iydQNrfMD3ARWtefC5ifSLuQnCtSu5Gd0zrqAFw6UjkrfwRz5ZNKflCzG8e0DFxjwE/qCqYAIY+km6LWKWATbM6KccxYmqiq6XOLe1+0pD71TdR6r81bz+QjmlGl6xT0OkPNbykU/Wr95shiNTo/DGAe7UYr2Z+E5mFyX62LzZ23+tn0xwMj+8q0xkuKriGarZUlpohx93lnkQO+/Pd
 +OTIoi0s
 b6YnQrQnKEO5kSP0m4z1SgkS+HIq2G7oZGrNeB7Sa1ZKTZxvLfY9aRLga1sdAqDuDRvPSo9sNABuWLdAkR0a0Eg8RbwsahN751VjDQhzU2PQ8vMzLteydb0bCVqdL3LpoRLCVh9kIKt8SCLOOD7NZ9/pyczEJHeHs0DqYkgHCA0jaF8fFkiVshq2GomQ/PMqX0NSORIBMiWarx6VjBsZDYDam8bwNNNoZRwS8F8jzmaLRxGr1m71SYTuMmRXTEB3ITBNZZmkXz0MOhcnKd9+Sb76Xo2G1OmwigdhuMtky0IFqS+ZUupV8IHekPSE6W1HRY+B1f8LvL3xn0RLyl1rUqpe3fP5tVkv8ns2W5knsAaurbmtq1JMyqSUETNqeIfaQU2L53g9QddoR9SXRfUEZZIKVc9x+F9x4/MpZDi5lHHwBh54qimyWu8jXTwpmiMfcaB8rheI7Lq5dHIQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 11, 2026 at 08:00:29PM +0300, Usama Arif wrote:
> On 11/03/2026 18:43, Johannes Weiner wrote:
> > @@ -3802,33 +3706,25 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
> >  	struct folio *new_folio, *next;
> >  	int old_order = folio_order(folio);
> >  	int ret = 0;
> > -	struct deferred_split *ds_queue;
> > +	struct list_lru_one *l;
> >  
> >  	VM_WARN_ON_ONCE(!mapping && end);
> >  	/* Prevent deferred_split_scan() touching ->_refcount */
> > -	ds_queue = folio_split_queue_lock(folio);
> > +	l = list_lru_lock(&deferred_split_lru, folio_nid(folio), folio_memcg(folio));
> 
> Hello Johannes!
> 
> I think we need folio_memcg() to be under rcu_read_lock()? 
> folio_memcg() calls obj_cgroup_memcg() which has lockdep_assert_once(rcu_read_lock_held()).
> 
> folio_split_queue_lock() wraps split_queue_lock() under rcu_read_lock() so wasnt an issue.

In this case, the caller has interrupts disabled, which implies an RCU
read-side critical section.

That's also why it's using the plain list_lru_lock(), not the irq
variant. Same for the lruvec lock a few lines down. I followed the
example of none of that being documented, either ;)

How do folks feel about a VM_WARN_ON(!irqs_disabled()) at the top?

