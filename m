Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6124C5B572
	for <linux-mm@archiver.kernel.org>; Sun, 16 Aug 2026 09:41:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED23E6B0345; Sun, 16 Aug 2026 05:41:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA98E6B0349; Sun, 16 Aug 2026 05:41:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE5F66B034A; Sun, 16 Aug 2026 05:41:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BA1BD6B0345
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 05:41:15 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 522BCA2DEA
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 09:41:15 +0000 (UTC)
X-FDA: 85106639310.27.ED1E40F
Received: from mail-pj2-f10.google.com (mail-pj2-f10.google.com [74.125.227.138])
	by imf11.hostedemail.com (Postfix) with ESMTP id 8A27540002
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 09:41:13 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=BL1cS46U;
	spf=pass (imf11.hostedemail.com: domain of foxieflakey@gmail.com designates 74.125.227.138 as permitted sender) smtp.mailfrom=foxieflakey@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786873273;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K+w3xZ8bo36DesNMI8mlOI+dkQ3ymR+iOqyVHgEBL4A=;
	b=VaoBLlpAtDOyZbw2NE3KljPFQFZ6Qt22QEgiVUO8QXHN5zmFH4Ug38h6yT1xjGxugyDgPq
	nNoc1FsIUfRJXJ0C5Jl+EHL4T28pG4NFqgojTzjE0SSIQU+7nn/0Ngjq1lMh5NR/ofDzkm
	L7ZjqCT+MhkzR0zpOF6i+gbYVGBH+p8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786873273;
	b=kRWjW2bT7Ak/6kKRlz6b3SlXK++jmlMnV1lNaboszOcWYmFU+P1Scrn8h3LO1WmxeXRcHv
	c2uAY0ieD3EPrWyFQAShlJdH7ApwHdZpLVt4JeoTc+oWi1j59ZeuQHVn0FMMxCOxeIJI56
	4JhHmRqoCC3cpx/W2iPwBfoZ2+txdCc=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=BL1cS46U;
	spf=pass (imf11.hostedemail.com: domain of foxieflakey@gmail.com designates 74.125.227.138 as permitted sender) smtp.mailfrom=foxieflakey@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj2-f10.google.com with SMTP id d9443c01a7336-2cf49dc298bso22174805ad.0
        for <linux-mm@kvack.org>; Sun, 16 Aug 2026 02:41:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786873272; x=1787478072; darn=kvack.org;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:date:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=K+w3xZ8bo36DesNMI8mlOI+dkQ3ymR+iOqyVHgEBL4A=;
        b=BL1cS46U6pua0cIc2YXiXrF/jUGBJNBfx9eOw5yW3Bklq3TrJ6leIkv1xBOv5JQolc
         INmqD+lVHinAd+MfP4EHatuLJqwQ27nyTigdham/dco5dv39QNJC6NeXNuu2uqh23ujE
         cG+55/Uh7HlZNuSRmh106cS/r3qdGQrCIJX2oZGG9tkZHjKXTsADJNdS/C7iTDU6Qog/
         Cl5ntUSDG5rYTetkRtR/0t6c4S5ckaY6KN8AWNfCZyU08co9KCPaKM2EQ5I2pTfNRbIJ
         FCqXMOwouTWTkIM3XKD9Sprap8OpqDz1EN6KsVQzEzld9JF1G4oj1lDiDqgKOBo1Lgfi
         shWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786873272; x=1787478072;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=K+w3xZ8bo36DesNMI8mlOI+dkQ3ymR+iOqyVHgEBL4A=;
        b=Kny1Fgb7CUY6C075URZBGy6UzjPjreGbZjeYw5D2x9Y4leoTdb91Yt/JZSNRPBhNzP
         GkkrRLTZwxhBrHfvIVOtxym7kOeV2Sppp9WXsyfYaVG/7OuRuXZFrXtuYBNTq+GfA0rr
         nVdUO0Fzaq+C59kHL3e9qvFIRZSSKCROBM7GEOi8LH9FJ8ezSltPoJnXoRbgTjgc8CGr
         R/ZVOpnMm4W876zfGd2ovyZsPhlJ6FAb6Xn4ZUxFf4ZqvM/Z3BXHxE55qS19iaWT97sf
         PsTkXSGF5otRvgtcD66ticyLwKVFCtKyKW62kTsO4aJ+dvYjR77G484EaJmYFoVw37On
         G1rw==
X-Forwarded-Encrypted: i=1; AHgh+Ro8bJWJsr0maeS+I3bnVg9zGBp8tn1vByJU+96iF49uO6qIifj89sJ30ZgPhYL05QQBBdlPgWuq1w==@kvack.org
X-Gm-Message-State: AOJu0Yznk8c3hGw+kFuNPZV4Lh8HXaVDQbug3gvtk/P+omvs+tsN5nse
	N2bmZndz9CuBRbRBLQck4hNX9v7KSgTSpX8RmwKk6uT1sGT9a6JwH77SiapZB2hWbj4=
X-Gm-Gg: AR+sD117PbOGx/gao4WBfs31xHfoIfppHHq5HKTkS5P7RHVgXprAI7yn9hfXNzW1n4O
	RxiW8Rafm3nLkYJFd/2DbLwCWz9W8s8yC64a8/RbeJlnL4dE9MsjLOzJu5C7XGXV0VcDGK+Hys3
	/WDY29JP353WdGVyNf5FYtseyz7X+X1g1lFKWYJsTg7/CSiiF3AxsJGCoFtopFTRqrQjdW3WG4e
	qp6X7Yvde+2BnCcLXkPRvwTWYgTt2Uw3RWu0eTs84/1CCA+x0FZy8ztY431WwAVjozh+5VKZ78v
	xyWMmW5fmg3vcPRDy2I1B/i952JoaAWg+JtwtJCOxso4KJKgpG3fbGWtr3o0/CUxYnvJCkqgdyP
	4XMPMsgP+lZeC1gJYbiXYg8WVPsSKsYloxBsjpssGuP6hdCNP1YTiPPP6sDGUSAc+Q6ZXpGgBOi
	++X2RoP9/lG0U9g640AA3UyOTOJvpoBkB7SZSU6fWm5rU4+gc5UxE+YBGvInRaF5g=
X-Received: by 2002:a17:903:22cb:b0:2ca:61bc:317c with SMTP id d9443c01a7336-2d3b0c5df17mr174098085ad.13.1786873272194;
        Sun, 16 Aug 2026 02:41:12 -0700 (PDT)
Received: from 192.168.1.2 ([157.85.198.7])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d3ae7ea4cbsm24361895ad.32.2026.08.16.02.41.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Aug 2026 02:41:11 -0700 (PDT)
From: Foxie Flakey <foxieflakey@gmail.com>
X-Google-Original-From: Foxie Flakey <foxie@gmail.com>
Date: Sun, 16 Aug 2026 16:41:07 +0700 (WIB)
To: Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>
cc: akpm@linux-foundation.org, peterx@redhat.com, linux-mm@kvack.org, 
    linux-kernel@vger.kernel.org
Subject: Re: [PATCH] userfaultfd: reset err to be 0 when move_pages_ptes
 succeeded
In-Reply-To: <aoF_qmSHiEgujaH5@kernel.org>
Message-ID: <69522f38-7e5d-ebdf-d42e-11d822bce662@gmail.com>
References: <9c936a9f-ed27-e510-872f-5b3b8c680975@gmail.com> <aoF_qmSHiEgujaH5@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspam-User: 
X-Stat-Signature: wzazijcwwei36ggjf41qprttqrjousms
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8A27540002
X-HE-Tag: 1786873273-16271
X-HE-Meta: U2FsdGVkX194ZD8UlkQYmioM2OkRTHWajLWMWR5hKDT7PKzQWArvgwJytwJNU6AzoGv7wESWsdUpUiR32t0lLo4TVCfxUN9+wZr6+B2ro+pp+qOh3cAKt+XciVmqxRe2VjAkcxoDDnvnoaURPgpUBj9s0hxqv94dUuhw0U6DpvTTJsMoXDkeclQpNZJXEcm2caIPG9PEVj1LqxR+bXxJldcNm0Vc2co8b2ZLsRrQeAV4IML8xCaAZY6PoTPamhnnOw/20p9ifUQume2eX7iLOgCYEBA2EEzsHj8J2yUSFlObaZzRkezsPxpSt6S2gR1f84YT0dYzqKh+bt9yjxS9uFJUKLG63aU+96VJ+Yf3c6Y14ZSmRkBdaAsRbaV/r+QkFtW7RmTBjeRd6U2CG9672L1bODRcFp5VTBuKx7qc0ZjQ1UkQSnxgyQvTIS14qUrpC79uvxAer5cpUv1sH2Qj9hxv537571tLPI8sLWm226AGK43Bx/ohhWYSZDVwmBsKRDS7bT36BQtWe+C3FX5ObgH0m+vDBg8+5B9V77L7QdWCnaxQ56VID9n72/eeNjrGwIi1z93H+noLM/stZjRXDoztyPHIu0DXFkzi9q/3X0MNvOtOMkvfjBQZJmuQPMvIOoQpZfl7HhhQjlumKXN9ioxXltswcm048n4YEJUfKFwCCQ9IwdGWHshGicmoxDe417kMHGfVfFPD5ty+jCmju3y1wrWsLaVkR2Q0AMkwf/fgggNZ5yNOnd44UwfbzrKpqEV29uQMsBgAtAjZKmVlJvzZa8rITbbYlTXxoOmBBsVjfNCzgXXPyzM1bbF9ERNfW6kT3LNJiUjjipZod7FUP08hsctlqoIqGK2uU4IMK80NvwA7sDynjYXxVAyKokSS0fkvh+cdBlyeo1B1qzRXl2z3NTJWWc4eb64spgxGaeip4IYIdvzSHt3sn4y8TUSbZPTInX1/xm5qx3mvwdY
 cbIHGwNW
 jtebY0XStltU28EKCGXhgm1f94SOpuELSMftPSvM7gj00w9gLNJUtSlM/WUWRUWWjUOg7iOt0mKWqf5gtqCgbXweTHhjtR/xqCRrgtorMBYlhXAAJjXEQnB6r/UNl/gy6cTDA1zbys5cXaNpSqzRYd4MbiuWzIgHQ9QHW45PNh2jw9Pzmdiju4flMQjQsVWCHMT6mGdf54j3ptm6YJLe+sa/FD49oxdJaZOeyW7wp8q2YLhvkOG7ZgIXQmiqFOdEz0/MRegbgcBadk9I0UdzrY+KplEIyJdX0GM8+cfiTrLqdVitphGrRYypJB8amSJuhIreMifK1VQqaSugQaxc6TYsn2JxMMajKw3y/dQGkkJ5b0ynj1u5fnel9tJzxt32xbe6L7/u0/UCt67G1dtk2fXvh5H9nrczvUcHaeiEF9oR8IBMig221D2mdJ5+LEM537cDOETMsNJq7fHd9c98Dau7UkiZXki3EzGWWpvPNMOrsOgROBVAWIDy/anmIAzEFaJuXW8Rdy4mhIByVz8OOtBdcCikfyM0XKX5CiJqcbU/VI5xwGW30PeqHEFTGcFRH4hzFnBje+L7evjfbdrKOph2/Og==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 16 Aug 2026, Mike Rapoport wrote:

> (adding Suren)
>
> On Sat, Aug 15, 2026 at 05:42:12PM +0700, Foxie Flakey wrote:
> >
> > Fixes: 50944692052b ("userfaultfd: opportunistic TLB-flush batching for present pages in MOVE")
> > Signed-off-by: Foxie Flakey <foxieflakey@gmail.com>
>
> Is Foxie Flakey your real name?
> Signed-off-by should be using a known identity (sorry, no anonymous contributions.)

Thanks for response. Sorry, no. A question, by "known identity" there is it
means my real/legal name? because I have read a document about Signed-off-by
and because on internet I'm known as Foxie Flakey in multiple places, I
thought its fine.


