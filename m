Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24C5CD58E7A
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 09:12:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9224D6B008C; Mon,  2 Mar 2026 04:12:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F9DB6B0092; Mon,  2 Mar 2026 04:12:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F92B6B0093; Mon,  2 Mar 2026 04:12:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6E51B6B008C
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 04:12:18 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2C68F1C106
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 09:12:18 +0000 (UTC)
X-FDA: 84500556756.07.7A844E0
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	by imf19.hostedemail.com (Postfix) with ESMTP id 268801A0011
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 09:12:15 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Dmy78eN7;
	spf=pass (imf19.hostedemail.com: domain of urezki@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772442736;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1CYixJp12ZhPkZvZ3ThEa39JLsy53oAR5qacM7OtCDQ=;
	b=I4H+NH3z20MPLlMYdwUXCThv3ZHBmyl54EVaNDi3DpEmRLcGnxpjqQ/9WBTz8rSBcTqyl/
	eQ0CgUdE2LHF4R/W/T2LAKP09+WoQw0k0dDAkw3+T4zyWf0dXCnY3g4d6DhLnWe1aLrrnZ
	N92Q2mBdCZHe+lMP1nO0hBSbKDtx5W0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772442736; a=rsa-sha256;
	cv=none;
	b=lf/HvQJdAxce95zAyT8DP1GDA7Yr6nYSE1D1rEoCJZZdWdL6j1q3YU3gPqyzAJMK79E6cj
	WbOiJCv83X5uwEGseYubTnh8s1Fh4kfDv6s+7ZO5uBz+zjhIjBwhiCAJEJraN2yjQmHhdY
	P1APZDwkJCWcCxhpaQ0RRkmfJMUa06c=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Dmy78eN7;
	spf=pass (imf19.hostedemail.com: domain of urezki@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-439b97a8a8cso500074f8f.1
        for <linux-mm@kvack.org>; Mon, 02 Mar 2026 01:12:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772442734; x=1773047534; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=1CYixJp12ZhPkZvZ3ThEa39JLsy53oAR5qacM7OtCDQ=;
        b=Dmy78eN7bfPpNY7iE80Mm/nE1sXURKIPEVnN+Gb/RumkBu6HJdZVUi1NBBerezWO/E
         /uZ/pqrEaK13bqE7FAw5DXpQX8N7iY98icai9RzPVLUMq1mtydByoN1PexW1HE5eI+b9
         OxXdGQDFJADV4CdFAo6yy3TNadA6IJ0U5A3PdapGMUtbB5nqy5/st8YhtETQVbiLMdgK
         bSI8fuGEy4mWQRnp8QMgHkh3y+qgDy5W7dNQrNu3P6pq24+gaebmmkd5+UB2bhQwGaam
         rYHpFbIID3lIuaKkzQxNlG7zV5uNiD8z5pNAQhWcUjw5Wk1S6w63jUEbOMpuydyx6QV+
         hmvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772442734; x=1773047534;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1CYixJp12ZhPkZvZ3ThEa39JLsy53oAR5qacM7OtCDQ=;
        b=AfPlzEcdHDP4QuxSkfwnRckNpdtJHwx28dI5Q3Wlp/u7jdkMmx25NpVGLgrGGcpj+t
         0ncVNk5esQC4GGidw6fLBTaPK72tfDcLNs83nXlybk0WELuTRFduD3JW7K84UBDjBvPO
         Xais/dt+T9HI00y0KibhraSXd5lQiFgEPwE0pkw9ZNnkV+vT7niCXkPgGj2/vl3Bl+Y3
         4gst7AffWj0ZJMpP8zT4ZEU6es2s8SOiuaGnWxijx9WLuWBS3txApxN84uwyz1EIZWXb
         oDzZkLAcZoyQfR1okKHUM1hS1t8uYd1ljapaAKgSJ/Lpnn0wmHVUT7y9fGwLWZ+SUudf
         W9xA==
X-Forwarded-Encrypted: i=1; AJvYcCVVrOPrm82zY8ZTuA83YxX2kz0ocZCjAKAmP5mzGkpaJm/X6Iyfr/FxRbJdOb6ud8gBKGd/mmXsUg==@kvack.org
X-Gm-Message-State: AOJu0Yxc/Gxlcz7P57uKu4+O964jZgOPerkDDfsywJNJSoOlD46ltsml
	10Z+bREO3JvIFUd78bx7ACIhsAlpxVZka3ssWvTsLzfKW8wvZnTe4mlg
X-Gm-Gg: ATEYQzyZ8Tk5T4LmBiEOtscKTasE3CDd9POF3nWRCx+70K9GTAsOo+OKo0jKLIA4+mA
	99OakDY7IJshOxrpgBonj/VbA/MYpcmiIZAllH7fAa1l4cMQQB1ti1pDCcOrCVMgJwR0Xj+d2SR
	tYYJP23tPHWJaQTvGEvjT5EjkU4aHRSh3DDCJ/Y3F/hiJ1j4o+vkKLnMS7rrgSHpnBPva7jF7p/
	I5etFtRGqQTdJ9IEsOcL7BSrVKG1O0f4+Z3PyFzRw7P6Js6L3Z9OqfXnHiwHx4x8yMaXtrJU47T
	+HZV7rBFCPeDvAYc5OspY5H5ByHCDVFrK3VSahpvqxgBJMiWLnLagGSIL1LgcVqPK4/1+svJj/m
	w/yz8l6+Wotwt/d9xQdXfBKUxe4hKJ3ASCtJ9kINh7wdo79TYSmOL/7R3XDfQfPMjU226SngbOc
	gEsQbbpLTiSaRqUYA=
X-Received: by 2002:a05:6000:1a8b:b0:439:b486:ba71 with SMTP id ffacd0b85a97d-439b486c4cdmr6649684f8f.56.1772442734219;
        Mon, 02 Mar 2026 01:12:14 -0800 (PST)
Received: from pc636 ([95.214.255.238])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4399c60f764sm26405956f8f.3.2026.03.02.01.12.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2026 01:12:13 -0800 (PST)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date: Mon, 2 Mar 2026 10:12:12 +0100
To: Shivam Kalra <shivamkalra98@zohomail.in>
Cc: Danilo Krummrich <dakr@kernel.org>, Uladzislau Rezki <urezki@gmail.com>,
	linux-mm@kvack.org, akpm@linux-foundation.org, aliceryhl@google.com
Subject: Re: [RFC] mm/vmalloc: vrealloc() shrink TODO - seeking direction
 before implementing
Message-ID: <aaVUbJ8is-9hYeEe@pc636>
References: <29e454bc-5a46-43b2-80b0-4d8d93e3feae@zohomail.in>
 <aZdBDOPUccXa85O2@pc636>
 <DGJ3LPUDBDTK.1TK1DXXFNXYPN@kernel.org>
 <7d65b7a0-9bc3-4fb6-b25f-58b0e07c2ad8@zohomail.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7d65b7a0-9bc3-4fb6-b25f-58b0e07c2ad8@zohomail.in>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 268801A0011
X-Stat-Signature: oqk6h9ef5uppoza56naqpjheydwj8n1j
X-HE-Tag: 1772442735-251457
X-HE-Meta: U2FsdGVkX1/MllR8SyUsSac31YGZToJWo56adgAXyAP9DsVES5dycbuJMOerz2PXh+ILHS+UIMXzIDqjqMNST/EPaBRhgsCN27xcfVYP9AJt23RAQU3ON+e1MI56loAW8mrokE9K1Bu3q5wqzXuZHJDJOx2s/RKXtTMovTbRlzRZFguQkmbnagJRBmufnTwKQUw4D+T1ylMbDPT/wUIBgd8tNejOgpsbKO5Vt/mm+zSR8Gj82ciKv1MIdQX+bukAFYHlrn4dzKVLnwr+Hsp6C36LAXLCu5dezSPxeW3phvWqyQxs/DfylnwZHmooNz3jXapI+MOjRoJQSNG7wGXolQjM3L9g4ybTFrm1kGSMWBZ7IiNM9Jzt5nlhPhGH3fyyCwNNGbvuXq7fenW5CrmqXFQWbNLbzqVBuTrcKcOYTpO5SzCxkqtZ3j8SmKAY/m2zLCUZoUTq56XMUAtYee6Qm/pL+ATXuSTvpD05yepUcF5HI+jOLcZ5pnfVNKKPE1DQ/ulb+40UAlYwqmAj0UYo+dh/kS27mm62S3iDRmLPHwkc4D5kIlOlHoh+Dp8ug+52/XoToSGxBheMDpDSfK9hlFgLB/LLTX+aaTJUDABQdqOodMvSUHB3vyu86RrjmZYPflBSeCFTJAAj1SdZrLzF3wEU8QoB7xQmkaYRPdvympLk6lgbmq+B9cWUNjevVJkQLZvy2qIQZch9QptvkXpoz77QTtQ6hrSOWtnEEi5tZHlVHgS3qcC0vQUflgNbBxrmEWw5LTbWU67pAcuJiZ6AfOAe88hmYYb0kUzMwjpE8ptTSYsDXxowW/0vpSKlrPLdnmg0ouXyZHCoMHMqBgx0hyJxvr0Bpl62+DCmlMjpAfljOlKaZbW6YhiJRa1JH05R8xI3HYfhqeASHhnSG0NmILDCyql6pb9+8uzsC90S48kcvEkronrAqaZRa1faJDvUJZtkQpDUu3KHJk2PSsV
 h6CwA8wV
 V9c9GtRCOHenfL0FSYXAIbQU239FoAkTFVQ2EhTo68pZRnKQAYr+RyaUCcTqju82z7X+O0Vygcg3695sR2MR+QA6v3PzGTQ6Cm7D5gwBMmi7tn2sH1gA2xTIhy/kx58C6HaiGl1I4w4oCfruUZ8jJahSOn0CRNqD8Mnb/HrUN4y2vcd/N/L3vP7eEstufyaeuENR5QFHBc+s88H7KBCxxIGX7L8p1ZSUrEN+YaqZenG33ga72YUgeZv32+8mDm3xjHsU2s33RimVdQTjxVRUEO5S9c3kXDRW0GIOuGtWfibdqauSClVAYIbo63kxiEC5R+0LmDxL4/LdmsAkApe+phBjtPctrBEh80hLEI+141xzI9R2bZfI5tUduzhuL6El6z4yGtaUPR1wOJuX3uuz8rBfviGTmFw15TiqVeGSomdYe3pEb60IBoSpFoZiEI/JsCn2fd7FQM56eBJ8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello, Shivam!

> On 19/02/26 22:31, Danilo Krummrich wrote:
> > (Cc: Alice)
> > 
> > On Thu Feb 19, 2026 at 5:57 PM CET, Uladzislau Rezki wrote:
> >> I think we have 0 users of vrealloc(). It was added because of Rust folk
> >> wanted this.
> > 
> > We just gained a user with the Rust binder driver.
> Hi Uladzislau,
> 
> You mentioned concerns about there being no users and added complexity.
> The Rust binder driver has a user of kvrealloc for long-lived resizable
> arrays. I also have a patch series adding shrink_to support for these
> allocations, which is now in char-misc-testing [1].
> 
> Given that there's now an active use case, I'd like to go ahead with
> implementing the vrealloc shrink as described in the RFC- in-place tail
> page freeing, skipping huge-page allocations. Happy to adjust the
> approach based on your input.
> 
> [1]
> https://lore.kernel.org/all/20260216-binder-shrink-vec-v3-v6-0-ece8e8593e53@zohomail.in/
> 
Go ahead. Send out a path then we will see what we have.

--
Uladzislau Rezki

