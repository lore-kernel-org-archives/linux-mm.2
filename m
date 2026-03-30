Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7BB951061B0F
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 16:51:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C6DF06B0095; Mon, 30 Mar 2026 12:51:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C444A6B0096; Mon, 30 Mar 2026 12:51:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B819A6B0098; Mon, 30 Mar 2026 12:51:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A91716B0095
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 12:51:25 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4FDD01A0555
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 16:51:25 +0000 (UTC)
X-FDA: 84603320130.16.957C770
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	by imf22.hostedemail.com (Postfix) with ESMTP id 2B045C0009
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 16:51:22 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=hk7M50Vl;
	spf=pass (imf22.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.180 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774889483;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rhEVepGrJqxt0GCMsUGUP6tTx35JeZn+m5lnKw+hBAA=;
	b=oaz5OfF6rt6AqKUIiq1HVKoxITC/bwphvK8VKzEs440ohFSrU6lHrLv/m5+tsFyG2zLi6R
	eRuf3eWhdb75L+YPNPPOgXtzjsb4VpcJjBtr4eetGaGWFxNtwiJvy+NOaE/zVVWY7Xnzei
	isyo0b8W8sHzYgUlD57/AaU3QfItaAc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774889483; a=rsa-sha256;
	cv=none;
	b=BGJH7CX1wQBkNPupXgxKHsT/gdII9Skn0rTGFaVkBEh2ei/5Y3gD3pienUIRhkufZyzqGK
	hkb+e1K1D+HNHvdfltkxu9TntfQ9q/4kz2dmSHZFdHbhX9u01h+Dvb0Yz9zw36Xf6g/U5R
	n/iVQyuQl6KAROe3xdx2vlr/ox/uW48=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=hk7M50Vl;
	spf=pass (imf22.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.180 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-50904a8f421so48862131cf.2
        for <linux-mm@kvack.org>; Mon, 30 Mar 2026 09:51:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1774889482; x=1775494282; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=rhEVepGrJqxt0GCMsUGUP6tTx35JeZn+m5lnKw+hBAA=;
        b=hk7M50VlCVnMG1+YY7BDWePHaH3qybpIcynMxLPxefIQtcge7Za6fikLfa9GqQtwcg
         kbTFJZsSyz6TAOGoOgp7S/OTwByFbZ/2n5xCQD0xR/UqqO6q/qy7UHnrk/yQzQlc4lcz
         9vyouWun/si9fJwQRmHtYnIuT0Kfsish7sVMKZLMJOqDLH+V2iYhuJe8+f6bKcKSyjqn
         5OpsOxhvB0Elzfj0fu+sks8L5eCm1U1eqwW1tkG8Bv9MbW//v+T71TxrsY9Y/OOcExzA
         amQeMlLvjU57Jzxo94sqKXWOwboIPuFLS6b/9W5dKEUYyaMnXeA3UXtPpVHdrj31KXup
         AovQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774889482; x=1775494282;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rhEVepGrJqxt0GCMsUGUP6tTx35JeZn+m5lnKw+hBAA=;
        b=df5pH4n5Y/I/WO2JyvvyaeYXEKFPMh6soBRgtdJZBqhinAxFyx4noNE5RWMQZsQRzm
         OS8MBkSFHuvPmL0czN+5TaXeLEhVpGKkPWIPFuZ/cYG8f5wS9AqiLAQtc9A8H6feLnMw
         cAHt79kzUpf5EYYziUgbewBivqSHwYqEzVv3xatdaiij4MGh+96VBDObPxD8jPIqVIDw
         zlPxKW4+LOcd1kPX2zC9udoGroYgIrLNRJnfHFd5Ak0fqat8rDoWOz9fr4L3ewf3Rdfz
         Qh7QVtS4woIabiRvKSXeTErXq2ZT/97tXDoQcSgxpyFipuOcX3MOJBqtZf+9JWU8AvDE
         Y93A==
X-Forwarded-Encrypted: i=1; AJvYcCVhPXYxT3TalLllX75Q4C8ny1lEWz8vCZjsUvcSUeiE2MllgfdZiE1/k/mB/bZld30pKpNQAMEGzQ==@kvack.org
X-Gm-Message-State: AOJu0YxxEESBMe8vcquDN3VVC6uGako+FZ+2H4+/mjGHbVW9bXuVmTKr
	b98ZW+13PFLWbhXlmPKCJk4ZeLGBmDH7xJ6QJTZp7QMTCJ60l4gjAj7E6dDJd/A8zOk=
X-Gm-Gg: ATEYQzxby7xnwEw8L15dzxC0lV970xzyC1crhx0R7cfFMmAbOw3dO5TahD3pRa22NME
	LyjQyJ6FymfZ9VjWH6/3xqxZXRr3axduIPUedOtSCD6Di9pQ7V5/iddLZb6LJ17LR8Lx/aoqsQO
	qHN9HSK4EdevCV0lTQ5TeZh1jhhODhMs/eTUnUwGLqqKuxqaq1uT2vIm69RRS8UjBf3Yzwp8YeQ
	xTxixrJspDbzPIDBSOV3QQrtVTmAtBPdD/b4f3BpNz+DnAPPm5YDLBJeMtpyelW0LiFrvB03M5P
	IbFeIEuUOEZyaIZ5FgyYJRv/ZDRS4nor8cUbIJ6dy+Wj/zjvcDFSK+VD4NFsnxwBVebyTM5LHuv
	ZdfSPMqTw6lTDy1KZ/3LcTJT0VCaoolxif7LNdGby/ohtK2flu7Wsao6be96HPekyKnUHOBaWwU
	YIIvCMTws+lbjJnfkQkWuZLw==
X-Received: by 2002:a05:622a:4085:b0:50b:3893:a2d8 with SMTP id d75a77b69052e-50ba3936836mr173966361cf.63.1774889482030;
        Mon, 30 Mar 2026 09:51:22 -0700 (PDT)
Received: from localhost ([2603:7000:c00:3a00:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50bb2dd640dsm78570551cf.19.2026.03.30.09.51.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2026 09:51:21 -0700 (PDT)
Date: Mon, 30 Mar 2026 12:51:16 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Kairui Song <ryncsn@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Yosry Ahmed <yosry.ahmed@linux.dev>, Zi Yan <ziy@nvidia.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 7/7] mm: switch deferred split shrinker to list_lru
Message-ID: <acqqBO0KhxIr3Wbm@cmpxchg.org>
References: <20260318200352.1039011-1-hannes@cmpxchg.org>
 <20260318200352.1039011-8-hannes@cmpxchg.org>
 <CAMgjq7BA8BHMEwK-QVpH+gDgu9fHEKxs4p1A3CeY9p7G98xhPg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMgjq7BA8BHMEwK-QVpH+gDgu9fHEKxs4p1A3CeY9p7G98xhPg@mail.gmail.com>
X-Rspamd-Server: rspam12
X-Stat-Signature: 7h5qgb38nxz1k1askwwzddyp6gf43tzt
X-Rspamd-Queue-Id: 2B045C0009
X-Rspam-User: 
X-HE-Tag: 1774889482-237595
X-HE-Meta: U2FsdGVkX1+G74Cvd9i4J1rM6qNeH7n2mv26ynfP9VxoCLxjxOj9aVf6OkY1pGinDT8okmjKwu3glAc0HgBf4KKFe0DjE+hf77y7lVB4POjreqXcWT387DVsJlKTHaOpdgDhn0kpnEEFWGMlpyHYMDFlxgJLhXSSfmIIX+afWpPj747X1eOkYvEA5kBH7r3y/RpMVOSWCEFM0ogXq1V7SpoqcD9/zKJr12JgAWNXTPXL1fNqt8xbHx+lw32j7Sdz9hwolRFS1TqfK5gU/XMD5typ8Ootmjx8LKWByP7RG3s2fsBOPKQxCt42cfvb0NCcWvnlfKGWXexRPGqqmkhxJV61/C8ZgYMU38mFBoNTWnxKVTc9e5EJnE3MPNEQqnwjj0aHtISoWGzfIiLLGLDGZCnLLADIh72Tbp8wXABDrqFMD2A94J97JLm/fomWTmsUcvxSnLBddNQoSDIIjXLzdOeIN3xMuwOOSZ0Hrn5aROFektyV0+OZLYHC6pVf5zckoDgD41vVTb8y7dVANNasCVqBve+/fF4VK48SnJDOHoNH1La3ayfYsSn1dbRfEfQwQkaXQ+1pbAZy3zkoRUywgg5yP4CTt0bZmoBhgBxv+puaczEiH+qu8mTpeSvIA6ILgX1Todw41rlJznZA6hruzRwnzaAe3T6OnJRJLpqJ08ljR7mMYKXIz5Jrc3nxUYmIbaaUReTpHn+a9p+ecg0WG4BVfczfTo1uXBmQryvwWnwUJetODd/oJFnwE6Nkc0tisjph8MTqJNjLqnMyCSAevKdTFJ1zyuSLfakHRiH+mot6N0eEI+Ct+IAgH3iU6E5nh5xRpCNa6iMuOHPEGxNW0p3SMVhbbfZKvZx7wd1AKEzSbqxdJ3BtaQCgavY/QMS7cTkUYtg8G1VnSFhwWpuUbIiDEP1m/fX67Ke2OprfBZ2EWwl2wMd5TaSVgcMrv3iTV14vLIbxSG3jxsOCo/2
 eJmj08Wt
 Lab3B7KudcBCwHqH/9OXqpjiQQ4zR41V0y6zqBt0mZEk7B50alNoGFBur2xPZT9lwbEx1S/jZeJO3DMxhXqxE+NHB9BL9cG2uthwWOQcBaOmFwV+hXMYrQ0cNA/vMU+O1VLjJ+jWyMLyR+EYJuVXWfpJE9opvyo1d5wymPqSm/20dk7dPjS+jSBVhSBAbGDX+jY8i8+E+xkabOBNdm8GjhDgrrRrbLGu9JZxZYeYksNuRKKnZvS1fs6r01bpsnBwfrwUR/HKdu+rNaU5vn+j9+ArgRXqUh0jgWIMVWmGwBfFHiE0RI0D6leWO89pN2U3l+wgaKxnvwrjEnX3tktrUBlLdGvzwpbKyqwHMbihXUDoRyx/OT+HlSDE445+jYOV/Llkt7ubkqiF0vZYc3UWVkGddDv+J4g8fRAK+asVt6H2Or2+eJ5dRbrgcJWT22/bEK4BdIc6Sws1MrtHTxze5HCXhNnjqg5+/C2howLeLhzya77dwlhwmvx0Z9w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 27, 2026 at 03:51:07PM +0800, Kairui Song wrote:
> On Thu, Mar 19, 2026 at 4:05 AM Johannes Weiner <hannes@cmpxchg.org> wrote:
> > @@ -4651,13 +4651,19 @@ static struct folio *alloc_swap_folio(struct vm_fault *vmf)
> >         while (orders) {
> >                 addr = ALIGN_DOWN(vmf->address, PAGE_SIZE << order);
> >                 folio = vma_alloc_folio(gfp, order, vma, addr);
> > -               if (folio) {
> > -                       if (!mem_cgroup_swapin_charge_folio(folio, vma->vm_mm,
> > -                                                           gfp, entry))
> > -                               return folio;
> > +               if (!folio)
> > +                       goto next;
> > +               if (mem_cgroup_swapin_charge_folio(folio, vma->vm_mm, gfp, entry)) {
> >                         count_mthp_stat(order, MTHP_STAT_SWPIN_FALLBACK_CHARGE);
> >                         folio_put(folio);
> > +                       goto next;
> >                 }
> > +               if (folio_memcg_list_lru_alloc(folio, &deferred_split_lru, gfp)) {
> > +                       folio_put(folio);
> > +                       goto fallback;
> > +               }
> 
> Hi Johannes,
> 
> Haven't checked every detail yet, but one question here, might be
> trivial, will it be better if we fallback to the next order instead of
> fallback to 0 order directly? Suppose this is a 2M allocation and 1M
> fallback is allowed, releasing that folio and fallback to 1M will free
> 1M memory which would be enough for the list lru metadata to be
> allocated.

I would be surprised if that mattered. If we can get a 2M folio but
fail a couple of small slab requests, there is probably such extreme
levels of concurrency and pressure on the freelists that the fault has
a good chance of failing altogether and OOMing.

And if it doesn't matter, then let's consider it from a code clarity
point of view. For folio allocation and charging, we reduce the size
to try again. But the list_lru allocation is always the same size - it
would look weird to just try again on failure. If we do so based on
the logic you lay out above, now it needs a comment too...

