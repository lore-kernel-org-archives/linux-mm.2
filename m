Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 749D3D1266D
	for <linux-mm@archiver.kernel.org>; Wed,  3 Dec 2025 08:27:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ADBF06B0024; Wed,  3 Dec 2025 03:27:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB3926B0028; Wed,  3 Dec 2025 03:27:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F07D6B002A; Wed,  3 Dec 2025 03:27:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8E9916B0024
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 03:27:36 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3566858DB3
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 08:27:36 +0000 (UTC)
X-FDA: 84177480912.08.C0DB341
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	by imf09.hostedemail.com (Postfix) with ESMTP id 2F773140005
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 08:27:33 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=CHsQszpK;
	spf=pass (imf09.hostedemail.com: domain of mhocko@suse.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764750454;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LB82SqHK4Qa55lhUfpaEjxDuzOxGP5U8vTnPeLr/2UE=;
	b=uN/tBwFQbi9PnCcK9BI5Z47lgNYYEJzm/duGPvH8w7mAWGcsn1hpdQwNC0neiEgiyb6OPr
	hT1AoCWkQy0nfwU1JB1gfC9lQGN+5CFv7tpLi63WljZMyT9vGwwiCwWxHe0kslqnt45NFc
	nsjm+jdWvOxTE8WlBvhSymSBuOEB3wU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=CHsQszpK;
	spf=pass (imf09.hostedemail.com: domain of mhocko@suse.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764750454; a=rsa-sha256;
	cv=none;
	b=J6WJMlTyiI17Sqnyf2P8mlWbqWVkB689F4Z1DDaMZJfObQFMOruI7oZVah/EEjBzpK/nbq
	9TYmZ45vo2CO0DeQvbobvqhKGSbs6A1Qa9gleqqzxQIEO1nafbmC9v+8VX4h94S6aLozGX
	53hsqKL77Ji4POgH4DOjeWSuY9xewVM=
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-b7277324054so918953066b.0
        for <linux-mm@kvack.org>; Wed, 03 Dec 2025 00:27:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1764750452; x=1765355252; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=LB82SqHK4Qa55lhUfpaEjxDuzOxGP5U8vTnPeLr/2UE=;
        b=CHsQszpKxRPmtaSITUGeELQlapVENB1hdF2wZpAX1yKIGT+bqr+yb//K2DMjg0XswT
         lCHIv2JNeulChbGCu7cEsJO0++kxbX048Cig1YiXIJgD9gHdo4tc5eHxU7Ibt035fXXm
         2Ef75lMMMVgrySvWPLLjADlvLAGKdZDrfcY+kjBIvrj0RyWpfX3ME8KyDVZSH5DPvtWF
         YhyZWM4AttPDz8O5Y+FWWyoqOpulPMQ88E+ojypd0ie8DIulTd/ySdUSYiRjdrlK6R4j
         opam5HKfKSb+0yigk7kua7G8i+xtWBfu5619KhDH7E5XqsLhJX4tyZBIBFM3gk6nirAW
         fg2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764750452; x=1765355252;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LB82SqHK4Qa55lhUfpaEjxDuzOxGP5U8vTnPeLr/2UE=;
        b=tErl49hyOGn1JinxLP4b17r3UYrvbL8tzOdtS2/1APcCbqweB/BxYUlMjQz2k/wGaQ
         lq0zljZQcVL831yYfG37qQUwu+o2uT6i+wr+oNSt8g+oiyIxndQS3rXCyi0fBX8mS5kE
         HzOEhmwKHqE/5mMV6Yoku7/FcmOyRZniS6GsO0nt7PF5E7ZA6uUn90Cr6WVNRvHvHTlq
         0X+5WznnSlQlB7MhSLmE9FBbUIagxOSC+FgjQrBQX59Cp0wJpCaqlRcqi9pMzmVdCnLd
         R0AHDA4CAySn6yjZwRI9PdkM+JDFXhjp9Q8VpJlNVF/9Zl8HGCzPmtdu52rlZW8ziaht
         l3rw==
X-Forwarded-Encrypted: i=1; AJvYcCX0kqjM9kAZkpC2tuM5ALNNWGPHjy0UEPjnvMJEfaEjS3EHP5GqtbLGiuWzTkX1kJwV4/QOIESIPQ==@kvack.org
X-Gm-Message-State: AOJu0Yzi9H/wsUejO+ug+XCcuVDptd1KVIGi8o/EV3p1bY82Ra1oJf7A
	KLqjtb5F4smqAWSLx2HfiVjxxYPV7ZOl0LwFBacLdrc+qIc9dpGmG+EN/fNVz8JGGlM=
X-Gm-Gg: ASbGncuK0R9OEiFHL496Y3t+0lZhSLUZ2JYdSC48zqfexfbLOiKIuCMlP1DrlqkNKjo
	UB1kdj/rqCGsGHcC02eEsxizJ4i/X5dnth0XG/GBk2dtfnVoGp/Q5atf+SVT2KJ6oCbhZLT5fe2
	THvO65R66BKtAD/XPTYjzcz3QD1dW79OY6WViw9CJGtsSLHMwZWyXYXDSRj4IkgZDL2Aow9q4WD
	rwVbp3XbX15RnW90nBI3fLIY5y5K88W+ghkcxDp6NvwyAq8tKaoWyIBKNeEosTRLmm1PRPhpnfl
	SWrlT5a2CP63Oon4BLvHIMsamYw+js2HGL7oXzjklezm87w++9HXByqwHjIHW/j00P/1Vno+Q7n
	UX91vK0GQNqC/Wif1xFsXq7o5ZcrSzcbwDfMdQlQse704AGVhgA+dhiXvOUSzi6I6wehu22LhiS
	qX6sTZFoU9w/mr1+y8WJwqT4xa
X-Google-Smtp-Source: AGHT+IEK5WibNLplvHwt2NXZj0T7f+oFfDBpB0TAMbBC3XmPgxwZI3ByUT0m16wi3I/b1b4tBF5B+g==
X-Received: by 2002:a17:906:6a08:b0:b73:4006:1875 with SMTP id a640c23a62f3a-b79dc51d9a4mr145015266b.38.1764750452266;
        Wed, 03 Dec 2025 00:27:32 -0800 (PST)
Received: from localhost (109-81-89-155.rct.o2.cz. [109.81.89.155])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b76f5a4b926sm1729121366b.68.2025.12.03.00.27.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Dec 2025 00:27:31 -0800 (PST)
Date: Wed, 3 Dec 2025 09:27:26 +0100
From: Michal Hocko <mhocko@suse.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Aboorva Devarajan <aboorvad@linux.ibm.com>, vbabka@suse.cz,
	surenb@google.com, jackmanb@google.com, hannes@cmpxchg.org,
	ziy@nvidia.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Oscar Salvador <OSalvador@suse.com>,
	David Hildenbrand <david@kernel.org>
Subject: Re: [PATCH] mm/page_alloc: make percpu_pagelist_high_fraction reads
 lock-free
Message-ID: <aS_0bgCs2qE0y1bJ@tiehlicka>
References: <20251201060009.1420792-1-aboorvad@linux.ibm.com>
 <20251201094112.07eb1e588b6da2ee70c4641d@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251201094112.07eb1e588b6da2ee70c4641d@linux-foundation.org>
X-Rspamd-Queue-Id: 2F773140005
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: konnascq3kf4us5un7woqbcd33z5azuc
X-HE-Tag: 1764750453-564070
X-HE-Meta: U2FsdGVkX1+8hEZeQnD3g9iiGfcZUpG8s5onHNPMAQK4VJIbABTI9Ub2XTvZg6VFZk8rR8YYEVaMqNIiieoACFOHoo01UGvQ5MEwJLhGyCr7ommhNaIhNiPu0bkeyedU9LoDymDO5lqiAVbV8Vf5bqMdxmar0VoaKE+M8GTTC9QUOCjd6Ze5TXCsY4FU31k6+l4HPZHDQ17ovKlzwfIiZduYv5YLBmNJQx9rL1v058N0k9bNx3agjevDoli//GX77PDmyfAXAtObaxav2lBeVgHVN/Bep1/Ww/tIpH56IvGy4L67HtwZnDyllAg+jA0kdGEYkfVmHY0FfkFqPD3EbwRRNHcMsXge7vSa733lzJA6yS9jGkkFE/qHR3zLPihXNstMRyRYces/lpmHGJ38+OtsmmewFcLJj3JNjGiq1IRZw7OS96S06rNTszvnM49WbVVInGJbUiHinwcoP8GpZ+vR8DrK8FzEqAwhLoEQ58z1ocF+83sh1nstif8hISY6w8yumJfTnS4tmxPEH6FAvPAxQCJHmsWYmZPbldkNmYtKhfAKLcZQZO6XKacwnHKSI5giJmLzSXzMVAbQlizGusUPgX3mVEy+j8yqKpRm8HCzcCI+BkodTlu5roFM8hJgDVHwuzU7Ya8Jg5rdEZDMZv87Hk4TUqCUYlDxS7mgINeLKLG8KNBSjKMdAMrDcHJPLy/eCtITgS8o9oayc7pPoAC4q7KN2PVpfoudmT9b/cJwRUJUFwPA8+Pwab1TS4ihsEpJpj3XkbyD49K+CjrOHYJuQxJqIOCtakkIvD99dOhUHDGt/iTnyhIBGsUQ+Y34+wsW5gB34K68Vb8elsfiZNUi3BCftRUzXz8bG65kZZm0z+O5H5ae1Ad5DpL/6Th9KI2mxTiicBTwvXjZesz9nL8E8PYt2ZpAyKznNqwETf2JaoVyIvutLTc3zApyPfzFejNko5YHvSG1yjZQVqa
 qe9GS2Q0
 wsA3SMbE68BFuNMIoeSkAojuH6f2r4cBVERyGM55eXQBnCcL6P0eThGWuHTnpHr4G9w/OTlr34D7od05eDr9WLtdeAAEJwYHzITCY2EI8TLr/NzBRz3tr6A/mUm+ZhX3IXgyDDPKADQBS0p+wEL8ro9VFSJZxJt99b3LgvF4JufOYYPgGAdbP4lX3VLT5KWUf6d5f8dl9kA3v8T2A5Aksommkh/BOp3kJkAi7DW2fGjhSW9U7ZzW483MbNfnokdwH4lcNMwiKr/+/ZlgKuWRHQ4bizs87wDiZH4g8TGWNgCNo7RF6yF+Fdf60YEbfOutN6glg+4Wd6bTsq8JTppGobxoekZaxgs8oruOEqbFMFDCk8fYe1cd3eBFb2/XnhpKp5YiaAD/Tv/daqvUD4uU/gncVCbMeVHpgSyXxCXolxPJPxyA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Let me add Oscar and David.

On Mon 01-12-25 09:41:12, Andrew Morton wrote:
> On Mon,  1 Dec 2025 11:30:09 +0530 Aboorva Devarajan <aboorvad@linux.ibm.com> wrote:
> 
> > When page isolation loops indefinitely during memory offline, reading
> > /proc/sys/vm/percpu_pagelist_high_fraction blocks on pcp_batch_high_lock,
> > causing hung task warnings.
> 
> That's pretty bad behavior.
> 
> I wonder if there are other problems which can be caused by this
> lengthy hold time.

pcp_batch_high_lock is not taken in any performance critical path. It is
true that memory offlining can take long when memory is not free but I
am not sure we can do much better. I guess we could check contention on
the lock and drop it to make cpu hotplug events and
sysctl_min_unmapped_ratio_sysctl_handler smoother. The question is
whether this is a practical problem hit in real life.

> It would be better to address the lengthy hold time rather that having
> to work around it in one impacted site.
> 
> > Make procfs reads lock-free since percpu_pagelist_high_fraction is a simple
> > integer with naturally atomic reads, writers still serialize via the mutex.
> > 
> > This prevents hung task warnings when reading the procfs file during
> > long-running memory offline operations.
> > 
> > ...
> >
> > --- a/mm/page_alloc.c
> > +++ b/mm/page_alloc.c
> > @@ -6611,11 +6611,14 @@ static int percpu_pagelist_high_fraction_sysctl_handler(const struct ctl_table *
> >  	int old_percpu_pagelist_high_fraction;
> >  	int ret;
> >  
> > +	if (!write)
> > +		return proc_dointvec_minmax(table, write, buffer, length, ppos);
> > +
> >  	mutex_lock(&pcp_batch_high_lock);
> >  	old_percpu_pagelist_high_fraction = percpu_pagelist_high_fraction;
> >  
> >  	ret = proc_dointvec_minmax(table, write, buffer, length, ppos);
> > -	if (!write || ret < 0)
> > +	if (ret < 0)
> >  		goto out;
> >  
> >  	/* Sanity checking to avoid pcp imbalance */
> 
> That being said, I'll grab the patch and shall put a cc:stable on it,
> see what people think about this hold-time issue.

-- 
Michal Hocko
SUSE Labs

