Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2D3E103D95A
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 13:54:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E4F0C6B008C; Mon, 30 Mar 2026 09:54:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFFCA6B0095; Mon, 30 Mar 2026 09:54:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3D2F6B0098; Mon, 30 Mar 2026 09:54:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C49146B008C
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 09:54:43 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 70CB913B4D7
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 13:54:43 +0000 (UTC)
X-FDA: 84602874846.25.F45A84B
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	by imf12.hostedemail.com (Postfix) with ESMTP id 7BF3940003
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 13:54:41 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=f3HfA8jc;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf12.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774878881; a=rsa-sha256;
	cv=none;
	b=CkJGFZ+7BiULQefPAY3nmehdJBAtypDCvWtrBF0QIVdJO3X48aPbdNj01tJgmWoue7Ki5F
	D/xEbxzpBshilgbLEAExqpL1zP3Gjlpa5ATWkAkVmgq9f3KdltW6n0neCPAtDJ1RgEE3EI
	lWesIO1MAHrUKz8auneLMfhLWJm3Kbk=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=f3HfA8jc;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf12.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774878881;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tcGeJFu3JRN9ihVppNUqKkXuXV5nSCW/171CTIrrwSE=;
	b=rPGOOj89YCE+5wb7+msVkUoAN8wtZ5ABWSCmuQX432ijk2CWUOfC1JdRudLTWFDz38dsgz
	01ANbDiQwZxyYg5hdG0SWqdIaloZ9sI18Aaw2WRMEW+MfaJyTbJLOCZjtyS4zUbWnAumKV
	rSy0dOzh2NOSE+38o7fiUurRgRKogFs=
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4852e9ca034so43430305e9.2
        for <linux-mm@kvack.org>; Mon, 30 Mar 2026 06:54:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1774878880; x=1775483680; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=tcGeJFu3JRN9ihVppNUqKkXuXV5nSCW/171CTIrrwSE=;
        b=f3HfA8jcI0koGqSnUmwElt2fh4QiGvOp7+AVnxFPTijicfNjnZNCpQImoWFMIfLs9w
         P6RReoDM1nlAVdXEdHRyqgHcaHOsG4Z3E41OvqHq1Aw3UnvmxGKGUK4uzLr4sPPXu66W
         Lwn+qCegHejns99w2SZnqD24As9rM6nzKrqvsIKNySPDzy1h0h/m/lr3HGCifT6oZV5i
         q6zz7DdYGpL66bOt7IWWvKGJVBP7oIBA5aOOZJSX0JCemUzv2yMaJtdW6VInOa1wmojZ
         MyDLXruSUa3nxU2gUN3sfl2nF7pmUvKZo0p+Gas4YlVgXRwF1LVkI8MYgZDFw1GD1ZhP
         vm3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774878880; x=1775483680;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tcGeJFu3JRN9ihVppNUqKkXuXV5nSCW/171CTIrrwSE=;
        b=mRVBt/2xxfHj7a1HvrcKIIXerqJBXhs+qWEl0gnnxrgiBR9qCJ+HhqgsIl+JfvW8qw
         kNr4NHZpke3ZHdfq+q0ddU4hSSHsecXcqPol1wtJ97K5YSmof3/QLrK+xHbET3WJyS9r
         TQ5DNw1C/zZBY4wMq6PdAIH4jtI3dG/E42OhUJpweol7VjNNCRSTEleigGEqEozjaTmM
         ykjusYHKPm4oDGtcZy4JVW6f+z3oim8bwYUGjVPX3r2hllWsFujxB/pFMmuUyB12S5MU
         WP5qQRpWOgwEMAQBgRcCK4kPObW5y+/K64Bhq6Ly53ZWKzZ4NJIM8ArrXZioUWokakv0
         GW+g==
X-Forwarded-Encrypted: i=1; AJvYcCXTevOriXfIJsGsHihXoVgyuknZdcxkoUB26oQ6CSfLET829locSU1V+KSxE7pF7ZPkQMrA8QMO0w==@kvack.org
X-Gm-Message-State: AOJu0YxUmdwek6vNb9/8WyT9MdEhrMQjBjDKXn2xoJd6GkNjOf0KEUli
	XR8M0Rj+5dyT9G+z5/u8RlKItvIeL+S0GnMlnguf1eJZoGEaAb/NRNe3IIbeW3HTlHQ=
X-Gm-Gg: ATEYQzz881hadrD2yPetnWPDbQB+9NpVuyZqKEQIijKt+k9EvVJuueeJsVKwkV0Hbju
	7tAGj8DXcs9MfJqOxiP1V34QeIhq6oWr+5vuNgKABFYLLpGIyZQKXADOdTYKgp+/mqbi4BFu71E
	YgmOna4CYvWjt9CjeLWJ3vMMQH//euryA+s/kGA5balb9I1ZMmafG96lqYchV6TKzORTTkJ9vRt
	j58Fdx3ncVW1RGf/iI9kmS5ne0bXi4opUeK6qe29ooILLeqyhrXqaXUD6OW+Z03kBNKSObl3lkI
	7dAB8Cp6VfSHeS23c5bihRArltu53tLQIWVjrW7F+EltuJkzWntXIWBvBNiP0VsatGETb7MGj3n
	opc1l8OqO36f8bjFDnk978O3NDAa9FTNcG3790wzswDOBtEJEgodA4PxMz3/xfYeuCRCALM2N6k
	c8pY1AM7Atgr5Qh5GxVuszt/0diUt32TMt10Uy
X-Received: by 2002:a05:600c:8489:b0:486:fbdb:b718 with SMTP id 5b1f17b1804b1-4872807483cmr213134925e9.25.1774878879740;
        Mon, 30 Mar 2026 06:54:39 -0700 (PDT)
Received: from localhost (109-81-17-175.rct.o2.cz. [109.81.17.175])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4873069961esm186640855e9.12.2026.03.30.06.54.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2026 06:54:39 -0700 (PDT)
Date: Mon, 30 Mar 2026 15:54:38 +0200
From: Michal Hocko <mhocko@suse.com>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Petr Mladek <pmladek@suse.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [patch] mm, page_alloc: reintroduce page allocation stall warning
Message-ID: <acqAnhmm6q2nKkPh@tiehlicka>
References: <30945cc3-9c4d-94bb-e7e7-dde71483800c@google.com>
 <231154f8-a3c3-229a-31a7-f91ab8ec1773@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <231154f8-a3c3-229a-31a7-f91ab8ec1773@google.com>
X-Rspamd-Queue-Id: 7BF3940003
X-Stat-Signature: ni6aws6apr4tumiu55barjgxiy1rn8wd
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774878881-840247
X-HE-Meta: U2FsdGVkX19qHsvqgjmtEKp8nXeBkKRRmRc9QT7tNkIbDiieHmpLD0OC0wJ7DpyRzKQPeFDImvspBhbdizA0atNgb7/y6PzR6PX+p1HsfM85/eFPrkP4k/tODpfEFNSc4pgb9fzrSynTPdiUJMveRXp6DO4mEhG5BGhqFIbHobbX76NVfjAHALdgJTCVg2taayKc3JWQ15pB5IrgvI6zXnqcg0QIy9h5jtHQjIrlyEGQSRyndiZRXonm7kESOrluJgmqXFwwkMJmSQR/GuWjUH99x3L5qVQMMaUaU9HXDVFzL8LhlKlI3oatTXv5NX1jLF3KEFPBzGKBE7RtzUH4JeW3sVw842XxgcaE/qqQkbmKEOkJNVuJ8tqksJym0Xb2ZxO8qRMR28+YEz9oRUC5SqWBiBXNQaRZeIC4bD+86gU1GwbKHkEgUFCaFGkitwKo9toQKt0VwchPsKKd6FZTUbtBTeXyi5SB5D7ffS8jgTEdhTeb4qhh0ucKZ8XLh6YDd+qPZEXXhX1TKtSqaqfOTHT4I4m6BASsHIBHYaPjI9rtNZZmxbbRtjVuOTX5vBLfVRhoYqacT4jShVKh6xQEWx+TZbnomNGznutB4MbCgnTIm4zgnq9PZ2I0xUseHlJkA2ZMnuThbdcjsy0XNNshBBqQnDuLmkTeE+CqOdjHuVvbcSMaRfx92Pry+lYI8FB9D+Dd++Wx4qPiLf4uM2UQS8Ak1li+4JBiACpgqKZlSSaiLYtbby73ZvOgAqCNWYDLrbdy6UFGuWEht8rcDpOCdvTFHGCf5QzphWvoKMFxJMKlezRkI1365EKVtH/gZZr8nhGRZ1/LVmLJPGx8xDHwTGD/iqF8J9I/FQ+lAYK1TpE9AwDJtke/YGS7i7rgi32PwlGbr0kBaeebzXkqOfnnhps8Q9tSs2pMthelYfDv/qSNzfDWcjkdZyFFZgmnTfDbBn0GxjM2hnWj8+2CEaL
 xG3r3pM+
 8cyafui/hwqq3w0v26f78OFcf4eq70KX5mwRcf42bPJasABzoWdocKFODH10qJSZUInuJF2Vy8R/O21AaBGwAeIfq0ZCZNyo9BOGPVnAIWCPu47wpmtIzDTNEJf1haND8fdjljzn7ASqtOft7ssF3CZPSm72o5YQL/fdx44VQHZxrJO53l8QcUQLx1jIaqr8OEf+SnoYOR8NyTQ1AkcyltUDMbMD9ulGB7tfZO748/d1qbTWD7rxe6v0LZIQp/oqfZGYClro1GTZ4t0QeRuW4IN1yL+F8kgugxbHgp4J5BbiJzLD44kLJ/N4sjPPfXCokz0wFUhinCPd5encCfbRjvrEJT5StFrpT1KdUYsmcw9t9eXZoMjTD1YYIW7jKmpHHtMq4x4Juoif9A/jJOGZ0/3j3Tw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun 29-03-26 18:08:52, David Rientjes wrote:
> Previously, we had warnings when a single page allocation took longer
> than reasonably expected.  This was introduced in commit 63f53dea0c98
> ("mm: warn about allocations which stall for too long").
> 
> The warning was subsequently reverted in commit 400e22499dd9 ("mm: don't
> warn about allocations which stall for too long") but for reasons
> unrelated to the warning itself.

I think it makes sense to summarize reasons for the revert. I would
propose to change the above to somehting like
"
The warning was subsequently reverted in commit 400e22499dd9 ("mm: don't
warn about allocations which stall for too long") because it was
possible to generate memory pressure that would effectivelly stall
further progress through printk execution.
"
 
> @@ -4841,6 +4884,9 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
>  	if (current->flags & PF_MEMALLOC)
>  		goto nopage;
>  
> +	/* If allocation has taken excessively long, warn about it */
> +	check_alloc_stall_warn(gfp_mask, ac->nodemask, order, alloc_start_time);
> +
>  	/* Try direct reclaim and then allocating */
>  	if (!compact_first) {
>  		page = __alloc_pages_direct_reclaim(gfp_mask, order, alloc_flags,

Is there any specific reason for this placement? Compaction can take
quite some time as well.

-- 
Michal Hocko
SUSE Labs

