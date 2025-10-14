Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 138A3CCD192
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 13:15:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6ABE78E011B; Tue, 14 Oct 2025 09:15:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 683048E0112; Tue, 14 Oct 2025 09:15:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 598C78E011B; Tue, 14 Oct 2025 09:15:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3EC628E0112
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 09:15:33 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DFB84BA386
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 13:15:32 +0000 (UTC)
X-FDA: 83996766504.06.6CA85BD
Received: from mail-yx1-f44.google.com (mail-yx1-f44.google.com [74.125.224.44])
	by imf14.hostedemail.com (Postfix) with ESMTP id 01F01100014
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 13:15:30 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XnOTiu2V;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.224.44 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760447731;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yDuVlQoM0GKjXHqLFZaHd1hl5+Amiaz43y1oJczL34k=;
	b=vVRJ3FYuBmRr/8ps6hbENgg0xy3Ct+BIF7l6GKDx6vR3zOH5IBCxsKe46n2wmQv1+PcHs3
	NH0ORDSt8b/pQYK1P+GcUxUoiblW6JgBGqZnbtMmMj+2G80UN+hgqAWmuRbDEXgMf62zVZ
	3BLQ6kCh+oY4oMmr4QkVOw+CgJ6+3aE=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XnOTiu2V;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.224.44 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760447731; a=rsa-sha256;
	cv=none;
	b=ia9oF241ZHUFXPjnz8LW/yKgcpEvNCWVah4h6rt52+3BjGiN4Trmxh6rZ8JYzt2vqs8eDE
	ONTRGg/pMRMVR/70fXxBieGThgyogzQU5FYifApctDEGOWpfCTJyw+WBhDgLPjKI6CxuDW
	+CSPlVcG4oXofZxf2l2gxVYgUyhhmHg=
Received: by mail-yx1-f44.google.com with SMTP id 956f58d0204a3-635349b6fe6so5135180d50.2
        for <linux-mm@kvack.org>; Tue, 14 Oct 2025 06:15:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760447730; x=1761052530; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yDuVlQoM0GKjXHqLFZaHd1hl5+Amiaz43y1oJczL34k=;
        b=XnOTiu2VG19Otbl+UHvJtI/Ie+pYfd242mFRVfOhUfEJs/GkKGlHZ+aSyFdCRq4r+u
         zCrbiOWB/ojjqmhgjGjOiwyrJBVJdtXlaxBRB+Rz0TzXlVYC5sIPeOq6H+/IzGdXR9KF
         ou4CT2TFpPF2KGgGtvZYFsGnKE9Wi9GAs0fBIJpntaCbkbaUGMWLtXXXkS4E/PUbgUV1
         N7ueznnEjVQ8sdZRkrWcxDBKrUHakpetNanRm7Pgjgc8yheMG6xp3pR7Pya3xuyBpkoN
         WYqyl7Jl++robuyjEnFUGGrtRGQZYlfsDaLYt+b7hhZdAR2LqU9+FCqQR0vF7ZwXRmZQ
         0iaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760447730; x=1761052530;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yDuVlQoM0GKjXHqLFZaHd1hl5+Amiaz43y1oJczL34k=;
        b=obUu/Z/vu6iIbf+8kPr56sbU4wkOZ4a9rQh5PhRePH/yX8ZLfv6jX0rlZ1xnmDkD/K
         OQ8FxHjpT6uznIxDBDOSMuLbFgRvSXGJvPGdssRM7BTIlLBar5GbEd1+vQFMdlZZkZqZ
         xR40j4SCve1HIgyPW7lrDU58lQ7kaO1/XhJ7roZfWOgNxUa9n1OsBXs4TRtMfy5L2FDS
         wZ5j0hfV2C31QWf1YrCKOJzJhpuN0Vo5TIK2WNgYq4/4KzDk/wjO8J9lPeh323038mWK
         5OGpe7y8JSaLg5lPa1xzcIiZ6SB/6Q3/PU913044mND9NYhLv86Jgc1GceP0hi+OJMV3
         CiSw==
X-Forwarded-Encrypted: i=1; AJvYcCVAq7fKz5GjhlRPns8gZuOUERYQFoVryV0YO4drsafQuvSjfJE9O8iuvaZY6+hwmkzCmaXSb6lXzQ==@kvack.org
X-Gm-Message-State: AOJu0YyFF9I/DuKvWQ27GrQqCR4R24OJNBwFD0yMf8uAy0WslGgCUR4g
	1R3gh3FOnrtjXDUz0KDS5vEVSc1tYqIHLsEMEXGHFU3nEP5WWOFtuF0w
X-Gm-Gg: ASbGncvOsWpFU91LEzr8sWOeD9qgSLx7cJAIlf4ypHm6pQA6N41cuq1srpgKeir3mTT
	vmEaliDwyuLSTAjbGi0exJzRJklR/p6jbFFTkpv9a+7BnfSNT4kdTXAtksoLNDNRhCi1reskoU/
	fyY2V6FxLTYWR/L/WvMIXTFfQfJTyUEWqiAlVHIT5A/5VdXMhLSRtlGP1w1FZ1jrkYEKphDQK6z
	x8FSIu9O5Dn9UNAuj3SUjRwq//7O9Pkv7AEWydiyG5CPo6Pj+sLPRJXvZJgwb4+cIsVO2JDaU1f
	+UoZHcmZPuxPcv1XUPk2jeWAVXyQxBJnElUrgzQfoXYvL0GmqGa24oymA0uhSILnVgdbR7NuqqZ
	+k84Lm25PhKXZhhNZu0HSPAt6q7tXCelO8NAvCHatSp/YsTP/hRYOBsGktL6IxvvhNqUIgciWPo
	tixwChQQxC
X-Google-Smtp-Source: AGHT+IGsvcYYsClEsFTY4tHK/30S2COTBACDT7BSIyOjc1D+rhzPyWmHlUmxYc4FgFdDi9X48dV+ew==
X-Received: by 2002:a05:690e:1599:10b0:63c:dadd:6b8e with SMTP id 956f58d0204a3-63cdadd7d33mr15517240d50.2.1760447729783;
        Tue, 14 Oct 2025 06:15:29 -0700 (PDT)
Received: from localhost ([2a03:2880:25ff:48::])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-63cdec375bcsm4392139d50.17.2025.10.14.06.15.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Oct 2025 06:15:29 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Chris Mason <clm@fb.com>,
	Kiryl Shutsemau <kirill@shutemov.name>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kernel-team@meta.com
Subject: Re: [PATCH v4 3/3] mm/page_alloc: Batch page freeing in free_frozen_page_commit
Date: Tue, 14 Oct 2025 06:15:27 -0700
Message-ID: <20251014131527.2682236-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <428ec528-5471-4152-bcb6-d36dd32c3311@suse.cz>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 01F01100014
X-Rspamd-Server: rspam03
X-Stat-Signature: qqkg3bxp9734qm9knm1wr3rz5p8459xy
X-HE-Tag: 1760447730-483669
X-HE-Meta: U2FsdGVkX19IPpRDy2NitjwjXxArgZ6zaVJOApNdM1PWziMXVjMLeY+JjWlGbbKlwmsznEBGO44qNzX+YAVFuynOL7KlR6bFQv/MEtL0XGcve+kleJwsTt/ayIcXgzIvKr/9b+imncG57tyW4xludTNymvRyk/uWoU8SASdatmYk+oThoCGvPZyHL1HfJwcrc57fw8muhHmtU5MzgICuEZnPKMJiJLvWev2gQOUARQzrr9wh0Ggcz/nakm5AtFzTxVztaG/YYXUbNpKZ78mnQGs4/fq004kC7qwVMiG3vAy8Y+Vp0wdeCrcWg4ZrHuTR9qRLIiDCDjO1s+mMd6XK9KPfqvCRUze4JaQDQdElAQQ9fQYKIIUfiKExYwjI4JVzXPgj7Ebwne5O+kIdtb89888TwN2iiqPHLn/Z3JHC1hXi7OV2mt5Q+CCm+87Vy1YSoE0H/rUSQqO92KuzexCW30b8SkANh5gLuQpzhz31RMmGkh5wmxtAWhGsw+jEagefpuSdw0SGORgBI/LKi1wo99Xfj7YUOXzlDR7I1PCOKp6ze4O0+9Dvj3T2nV2PncjRuI8Niwq47q2EtRy6yTV8/67BCz3ST6vV03Lj4nT/pQKkPBJ2EPZdehGxjlBvvCbo/9+Ih4kEPg8NKCkfQ6h7Cgac8hIWp1CmLy4FrBAMGadnhCYmGk/4kTJPPOKA5H/EafF2QGTv+hFEzpcvz8p+ZBZwh53ldLMnjgu91IXjYNqeKuuOPpU82dwh5Y7xsX0Ns3Yqe+aJDqXXviX1va5qr3j0XibIFYjGQkIvckDCP+xl/JDW331dCLiGFcsZpms99QRYuKakG0yfFhko1ab6rXahAVu8oLohEy686KN2FarN0RvlAYULhVO6IuqIWHcN3NMQ+mp7YYQiBJmuUgZ9I72AjwtrQcF8t7Y7Sj3xV2x/2cB6j6IU3bIILy91CJqLe+ZRVObhU7MSBAqL5w2
 b0vFbRbf
 c5D4O+ZQ418HeoFrvTH4EXHQOwTJIDMrNdFnWI34NUFezzftmuP0hW+Dt/iz4YkREqEOFM9VLql9kjQu/Sj1Bb93WJiJ7pbtJvRejDSiVScNwVgCgCu3pYecrttKTHnYBHgaBqqVKEuUJdzFQ4LcIOBYi2ogn7lJlxrdNRZHS4sELupp1FWIG8j+ASTBNeGeyNMU+Z4VR21C/LjmDsY8ZLn0zuWOJ7iYR42cimsAly6BEeaIZmpb4/DNcAt4Y8EwMbXBmZQoZHrybFDlePSn9Nvh2Z3lEoubco6iA0Yk1Vyng6JCkvMHbCwlMUpgGCzmfhFynOFIxGkz74DJeZu9j515e3U9MfaxEfvaVvQVewX3EmflATyuBSpHMmPqlbCE3xDvyHgQXFkqbhXPeD8ILPjOCrp9YZN85PFAxbN1x2NvnV/T07E+f9tCX2Cdaym1PwWH1PTKqiuRur1qcHcaXgaxifA+6AhLHYslu2NOF316kzKLAlZvIKEZKsdnJY2UjofzlickJbVBxNLqnVAyh75wWBWCZEK+KWd8IZj60zF01TPRXFscasnk7Mg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 14 Oct 2025 11:38:00 +0200 Vlastimil Babka <vbabka@suse.cz> wrote:

> On 10/13/25 21:08, Joshua Hahn wrote:
> > Before returning, free_frozen_page_commit calls free_pcppages_bulk using
> > nr_pcp_free to determine how many pages can appropritately be freed,
> > based on the tunable parameters stored in pcp. While this number is an
> > accurate representation of how many pages should be freed in total, it
> > is not an appropriate number of pages to free at once using
> > free_pcppages_bulk, since we have seen the value consistently go above
> > 2000 in the Meta fleet on larger machines.
> > 
> > As such, perform batched page freeing in free_pcppages_bulk by using
> > pcp->batch member. In order to ensure that other processes are not
> > starved of the zone lock, free both the zone lock and pcp lock to yield to
> > other threads.
> > 
> > Note that because free_frozen_page_commit now performs a spinlock inside the
> > function (and can fail), the function may now return with a freed pcp.
> > To handle this, return true if the pcp is locked on exit and false otherwise.
> > 
> > In addition, since free_frozen_page_commit must now be aware of what UP
> > flags were stored at the time of the spin lock, and because we must be
> > able to report new UP flags to the callers, add a new unsigned long*
> > parameter UP_flags to keep track of this.

[...snip...]

> > @@ -2861,15 +2871,47 @@ static void free_frozen_page_commit(struct zone *zone,
> >  		 * Do not attempt to take a zone lock. Let pcp->count get
> >  		 * over high mark temporarily.
> >  		 */
> > -		return;
> > +		return true;
> >  	}
> >  
> >  	high = nr_pcp_high(pcp, zone, batch, free_high);
> >  	if (pcp->count < high)
> > -		return;
> > +		return true;
> > +
> > +	to_free = nr_pcp_free(pcp, batch, high, free_high);
> > +	if (to_free == 0)
> > +		return true;

Hello Vlastimil, thank you for your patience and review on this iteration!

> I think this is an unnecessary shortcut. The while() condition covers this
> and it's likely rare enough that we don't gain anything (if the goal was to
> skip the ZONE_BELOW_HIGH check below).

Agreed.

> > +
> > +	while (to_free > 0 && pcp->count >= high) {
> 
> The "&& pcp->count >= high" is AFAICS still changing how much we free
> compared to before the patch. I.e. we might terminate as soon as freeing
> "to_free_batched" in some iteration gets us below "high", while previously
> we would free the whole "to_free" and get way further below the "high".

This is true, and I also see now what you had meant in your feedback on the
previous iteration. 

> It should be changed to "&& pcp->count > 0" intended only to prevent useless
> iterations that decrement to_free by to_free_batched while
> free_pcppages_bulk() does nothing.

This makes sense. Sorry, I think I missed your point in the previous version,
but I think now I see what you were trying to say about the count. Previously
when we were re-calculating high every iteration, I thought it made some sense
to make the check again, since we might want to terminate early. But I do
agree that it doesn't really make sense to do this; we want to preserve the
behavior of the original code. I do have one comment below as well:

> > +		to_free_batched = min(to_free, batch);
> > +		free_pcppages_bulk(zone, to_free_batched, pcp, pindex);
> > +		to_free -= to_free_batched;
> > +		if (pcp->count >= high) {

Here, I think I should change this in the next version to also just check
for the same condition in the while loop (i.e. to_free > 0 && pcp->count > 0)

The idea is that if we have another iteration, we will re-lock. Otherwise, we
can just ignore the case inside the if statement. I think if it is left as
a check for pcp->count >= high, then there will be a weird case for when
0 < pcp->count <= high, where we continue to call free_pcppages_bulk but
do not re-lock.

So unfortunately, I will have to check for the same condition of the
while loop in the if statement : -( I'll send a new version with the changes;
I don't expect there to be a drastic performance change, since I think the
early termination case would have only applied if there was a race condition
that freed the pcp remotely.

Thank you as always, Vlastimil. I hope you have a great day!
Joshua

