Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8292710987A4
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 16:18:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF53E6B00C7; Fri, 20 Mar 2026 12:18:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCD466B00C9; Fri, 20 Mar 2026 12:18:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ABBCB6B00CA; Fri, 20 Mar 2026 12:18:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9544F6B00C7
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 12:18:51 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 188F21602E3
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 16:18:51 +0000 (UTC)
X-FDA: 84566950062.13.8091890
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	by imf28.hostedemail.com (Postfix) with ESMTP id F1860C000D
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 16:18:48 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=KChdwJxL;
	spf=pass (imf28.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.181 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774023529;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NUC9Vc+AJ09E5gPwZ2pPgypATV+QcloFSVvErmSfs2M=;
	b=KIAjpz/xV9nsIS/DJP0xJqE1MynyO1OKBtsv7hMEJZDXBOVYFyWnENxbOKSuTzUinw7NpY
	Li0t2q6daIKnbMgMq9RFcfLD+Ld12fcNUf890aty28wbuhN9o+dq2UaPFaxws4ahel/hYC
	cOZw77r2jnRbGE33M8qEeoirH53tw9I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774023529; a=rsa-sha256;
	cv=none;
	b=eqh2sL1Z8vqfqZVY3D2pF9inEOwXjPBCLBfnRtyZ+9PfpdsHLwz1zwcqm3gifu3BhoJBdb
	2gfHmOG+jv/6OwlBiEoq/USgE/9pjJdpxS/CARqeKGqDniCPemdHf4X93mVzWVwGpOP7Bz
	YzynTZdWKauQAKTpYZqRsnTje5lnVUQ=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=KChdwJxL;
	spf=pass (imf28.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.181 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-50b351eaf81so6641261cf.3
        for <linux-mm@kvack.org>; Fri, 20 Mar 2026 09:18:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1774023528; x=1774628328; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=NUC9Vc+AJ09E5gPwZ2pPgypATV+QcloFSVvErmSfs2M=;
        b=KChdwJxL7OdsaCjSWbNbGSJ9TG2AgLndELzW+psVaNOevN16NVcPoerueGIILiBYpL
         oY8mAToRQozFLlboSCvMyk+ISXvODA0+6wl8F3yEaCPdVefyjwFH6eydtj8ra5rSjZW7
         hS3oi37YHWzAc62cHXX/1y4uDlwMbJegax130RbmyrM70PR2awcw4SlhKrJQNsKhioPI
         4IDlwU0VmBWPLmHbrvcXwHheszuW6xYshxNgvel19jU0iWA9nY74ffh4uUpi1DZXhaIj
         EyYaxxiN7XRCe+5/kcwdktQPk40sLQUeJ6IVi6zPSp21FwbLUNSHMIrTBtiKUgWBruqd
         eB2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774023528; x=1774628328;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NUC9Vc+AJ09E5gPwZ2pPgypATV+QcloFSVvErmSfs2M=;
        b=GyLbRa4XlS8ISwKaLzBtKesufLwUblScAyBLaDvgqb+p44e66oK4yKT7QHAYA7g+yI
         INAQ2sEfpwjwO/d/7Wv2a1BK240Oa0727lsIJT5Q0x1skU6GLYSLJ0MXjQjQ9Y+fD8Jw
         8CV+X3hpgc/SRhMSld1cqqVxqbLr3/m3nQZwAZffreZiw/PYjt8ybnceyuQBjvE//a8y
         BqOtI+bfsMI4l7+xnOXbjzM6ruTTMsusgu7o2JVhFUsB/qIxm+aVC0ew/ENTwFj7uw7Y
         mTH8y5wyhlHDUjRCSX+XX0lJ80IjYhqp4+gFS2sFeCv1RKS9WWfZYS3S35HunqtTxQYy
         hoZQ==
X-Forwarded-Encrypted: i=1; AJvYcCUUBx9hmNz7DU+cbPjN6EXGOOIet47LYN5YuvK+JVhtG8VB4fnHPv2FHcSWYXxAJodJ0maJA/yIKQ==@kvack.org
X-Gm-Message-State: AOJu0YwUrhNORJmKY+GUjW80UUjbOHRk9zks5xsdfWq0a1VbyJLBPWE3
	SWXscC7I9zDoVYy9XR2oKsMqB9fV9PYx6ddzXbixEC5JAUICgsWFdlW0+XhDjd5r5/4=
X-Gm-Gg: ATEYQzyS1+C04YLsQ4+edVfYeunSgGsDG6iPa0w2T46liB3MPIlLas5C6mQ16nBLX09
	Wagl6Y+23pGUuS7q1ez5hSJB3181PS562/5jhnlBNtt7l3wO1ieUOcuuE4P93ce7wbZhaTpd5RT
	xlTnd/tBA72fpThXPAW8SzUStJvYQ8Mt47AtUiDUVTpxXgV1PKMqQB1Qrw4LqkGVdto2r7GUpY0
	4UppSUb9VBF5NdNftLc99xUn2sjbJ5J7f8IZgALtXp5ouKly6JFCZr7ShFAXzh9Atvv8SCqicv6
	595V/O3htS3bC3D6hEGKHv1HDni16KKVTF7exiDX9p84+GdLoU3qpr87kfIaRlafAaNMYhUvors
	5Xn29QocjELADFkNeNHR8Oz0KDMM3y6XkUatndheQLqg+A6CHhS3d8pvcXjMKTp49u+rrLNEMEa
	5F5X7mqAO+6VyrS/lY7vSw9A==
X-Received: by 2002:a05:622a:1b29:b0:50b:2900:6644 with SMTP id d75a77b69052e-50b37552ea3mr55701461cf.51.1774023527784;
        Fri, 20 Mar 2026 09:18:47 -0700 (PDT)
Received: from localhost ([2603:7000:c00:3a00:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50b36b50fa8sm29731471cf.0.2026.03.20.09.18.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Mar 2026 09:18:47 -0700 (PDT)
Date: Fri, 20 Mar 2026 12:18:43 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Yosry Ahmed <yosry.ahmed@linux.dev>, Zi Yan <ziy@nvidia.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 5/7] mm: list_lru: introduce caller locking for
 additions and deletions
Message-ID: <ab1zY5Ei6fPDfdpW@cmpxchg.org>
References: <20260318200352.1039011-1-hannes@cmpxchg.org>
 <20260318200352.1039011-6-hannes@cmpxchg.org>
 <absO1Bg_exH4llmH@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <absO1Bg_exH4llmH@linux.dev>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: F1860C000D
X-Stat-Signature: j4zg5h85o51ttj171pycrp4ho9m711q4
X-Rspam-User: 
X-HE-Tag: 1774023528-712346
X-HE-Meta: U2FsdGVkX19gj/udEFApAN+mJtnohzq3/rIkryX8fnueSpokglfonl/hzwA9CgPWJfcE1ds9WrB1aIJXGSgAwlXplr37tygrPTYc6ttu1HSDKNPfo4XWGMYh5T6W3ivShbeZzvIzMVygOyXO4DhKcYpvUIYhxXbbKxkKIrk/RGTE7fC3RgW0+gxPlBFlWhYerJtl0b/cusaE/ym1+E1b1c7+gPWBTrM1dUXin/9Z5mGi8j/G0G6l6xhQwi3VOlThXb7C+MgY9ZGNo4ULRrLZFen37qYKxhEpImmIh3XvwmsnM8SW46Xrp93flQveqevWfx7gCvhxGLNlNuOmgKzD5qGJvmpPExWCfkwQs+pdu80weTMelzCSQZdp2GM1BD68HMD3OP+CDgxRWj5qlldQUrn130Y/RBMU+nS9Zwup6PFfs1GP/MswSEYaxNMVVne9ttOLYOyy4nOtyC2dh9v8CnneW0y0uQHpYWRqCQiC5mJobqSCgXQBA1WaS2xmJbGIGDSLyl0qwJn8lTvFt9HW41CbKv7q5o1NvKlwSzgE173EheJnXQ5R6AtjaaHI2YcnfLpGG9y8BuENYpuIcnS+p5fo+iqTK3eYx1ktdlYIBdk3opTibqAERTwNDuyV+IAe1qPS1pRcg1oKbfE2SBfzxOCP+1/b/oeLrl9zMshLLobHmOwQxxn6c/XuIAEhnrUP4z1K+iUQCY3OPJK4bZy+VhjXNMDYTCIY6kQHaCwuEjphjei+HEkA+fbKHfGCkKdNoImnnRQrC9ubkzjK26KL37BuFSdB6PzTu7yhyPtoaWf/zL6znTTdhhymXfJZooRJKEMeOil8FjI8jAuvzvpSHpi4/pnAjLtsKKT/68iGmAqhAz6SIfXLXxjdl8xFkjpki9fscJCpM9fYk35wW5M60gUwfiaEM/wkzF4+4Pjp2PtFp6GPP4KUCskhFOVIl/aVENcvqS7Y0cXW2LhqNaq
 4rt0EMI2
 m2JItTKBabvw/BQn1g4MGVjFp5cipORpi6FV2psXC6MspEoAsDTFrHK9IaIuOaVHfQtD5W/g+dPJoxE31ncZS5Qb9M3vKkT0nosFduKqJvDfs15qv9EFHQtJKHZjWqWhhhVS9wEPBZMmCqkL+wDXOfUIiXTEhOJXGmVyWv+mdqDbIrtoUb0OCdZDp7OeMgYu1mbUjyHdAdpDS5od4C8ZKElXKDdGdTlVyfQw38MS14T4ovwn38IwTSTvqKF+4+VQJaZ7KUvVqqcbVfRe9+aKUm0P7T5mcqojPUIxA21yx/yBh/W+EubvUDlBuicBYvO0uqm10jd/G3ANmvsbA4D6fTqK1W3/3fRDZaz8j+ttHyGVfZh13ggwcGMi4q/cspckZv/k4tZESGgBcIGNNgBw8Vz/VRo2lELGPjJfFts/iD10WkupvBhzVhkwPHq26IBfBev6nojK/DUs8ahC9OHm807jPpkiUaQuxjc3kiOjXR9fiohlK1B2ZU+1EMA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 18, 2026 at 01:51:04PM -0700, Shakeel Butt wrote:
> On Wed, Mar 18, 2026 at 03:53:23PM -0400, Johannes Weiner wrote:
> > Locking is currently internal to the list_lru API. However, a caller
> > might want to keep auxiliary state synchronized with the LRU state.
> > 
> > For example, the THP shrinker uses the lock of its custom LRU to keep
> > PG_partially_mapped and vmstats consistent.
> > 
> > To allow the THP shrinker to switch to list_lru, provide normal and
> > irqsafe locking primitives as well as caller-locked variants of the
> > addition and deletion functions.
> > 
> > Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
> > Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> 
> One nit below, other than that:
> 
> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
> 
> >  
> > -static inline void lock_list_lru(struct list_lru_one *l, bool irq)
> > +static inline void lock_list_lru(struct list_lru_one *l, bool irq,
> > +				 unsigned long *irq_flags)
> >  {
> > -	if (irq)
> > +	if (irq_flags)
> > +		spin_lock_irqsave(&l->lock, *irq_flags);
> > +	else if (irq)
> 
> If we move __list_lru_walk_one to use irq_flags then we can remove the irq
> param. It is reclaim code path and I don't think additional cost of irqsave
> would matter here.

The workingset shrinker's isolation function uses unlock_irq() and
cond_resched(). That would be non-trivial to rewrite - pass flags
around; keep irqs disabled for the whole reclaim cycle; break it into
a two-stage process. This sounds like a higher maintenance burden than
the bool here.

I know there is some cost to this distinction, but I actually do find
it useful to know the difference. It's self-documenting context.

