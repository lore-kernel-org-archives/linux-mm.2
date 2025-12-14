Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1AA4D59D99
	for <linux-mm@archiver.kernel.org>; Sun, 14 Dec 2025 16:06:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CAAE86B0006; Sun, 14 Dec 2025 11:06:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C829F6B0007; Sun, 14 Dec 2025 11:06:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBF7C6B0008; Sun, 14 Dec 2025 11:06:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AF6826B0006
	for <linux-mm@kvack.org>; Sun, 14 Dec 2025 11:06:14 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 56A1E8B71A
	for <linux-mm@kvack.org>; Sun, 14 Dec 2025 16:06:14 +0000 (UTC)
X-FDA: 84218553468.30.198D3CC
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	by imf29.hostedemail.com (Postfix) with ESMTP id 2703D12001E
	for <linux-mm@kvack.org>; Sun, 14 Dec 2025 16:06:12 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=jQdVU947;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf29.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.180 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765728372; a=rsa-sha256;
	cv=none;
	b=Wz/nRUqrPE62wtYviHSIubSRRHrmZCrbfrXZIzOKnaqJIogD6/cIzTjpWsifXmC9qG7PxS
	XKta/D0pwOAn5eQ1T1YTmMbsP7LMv3qt0lLeqx3tx7D8SfEdRl0QmZk20IVa6aHDyprKh3
	aHU4Q1C0ZjEWFxBpLvGVMZUTmaK33gg=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=jQdVU947;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf29.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.180 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765728372;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f7QTVg+iX6g7+TSOdJvwQOGJXyEHc6ip79S31gdlfTY=;
	b=Gf6UCGUp3aOLEYBaeW+OT2U63G++zdAJ5DOh+V/Y8HqVN1NAb+jKFCa9WniRx/TZiA4YSh
	JnHj26Z6sflZJMGB6Ic9zXR3MRX0l+jdikzc7obTwbAzU+1WRxV6ifeN5rbYmLQ/i1D9gW
	8m1r417+t9/sYAza0yT0Q9eCCnMqR5o=
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-4ee19b1fe5dso28927981cf.0
        for <linux-mm@kvack.org>; Sun, 14 Dec 2025 08:06:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1765728371; x=1766333171; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=f7QTVg+iX6g7+TSOdJvwQOGJXyEHc6ip79S31gdlfTY=;
        b=jQdVU947MGpzZwppgESMyDOogVXvpD9ciDYnwq1sPIXpmqIh7ulwWkun+Gww1/KR9j
         pczMm607xyzwtw2hjopuUL2+T+tyM/sEI7KOKup3WITP/80UYYEtlXKmQjdhlC0P3J98
         DN+9uhlWrl5FhF4Xx9iNw9iV4yOCS1HS3wIUULlEfuF8d/JQ8w3TKF+bWoVDIfvrn9Pi
         K0nBoITi9xXsE30VmmVBsPdjxdtbd2i4hYm9qcsGkmBYChX4PwQbz6fW5i2Ka4DjW0Py
         bTrmpAt2GoUaLED7nnHs/i3jXM4YkW5hLp1USj+tZ+pTbfGppuIO0veK61bZG4YffbJc
         Ny9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765728371; x=1766333171;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=f7QTVg+iX6g7+TSOdJvwQOGJXyEHc6ip79S31gdlfTY=;
        b=Z2fDlK6XLCS46j36GgoGrd4ULe0Q8MaHv9bvgCxOb0SD78XOxvWx9qfzz0rm3Sx46s
         DHgNQKYpcxkbnylumVFWHBpR4B9kcoKL+sabg5c+AqKL8H/qT39oLJ10WOKj6xbusfgX
         g7kfSiv/I9gk2ydiu3dFzsKaivsyIQMDnXyoJDKjlEqW2ziEjwek6PVVTLSNXtj9W6Up
         AknkkdYb2Y9c3rR+mTRWy2yh8s0FWSggNf+lkR9yVCmxl1OvEXtB5pz1/Jxgv9+XkGhC
         kTgvVUMbvGe75LyGrAhW7e1vRNIHrTlpowVtz4Z3eeDJvMd+LFB1+lDYZQ/5BxhmZYc6
         0n8g==
X-Forwarded-Encrypted: i=1; AJvYcCXZ1WkLXxD4tAE+x0lvhaOESAdPQsqaI9IXsOhtUNLmEL0Khtv2wNLKm3uymP3t2SnXG6nB93C59g==@kvack.org
X-Gm-Message-State: AOJu0YwmsTqeYBUDL14l8rHed3YZ94krE7Pzww67vd+ZBxHHGDxRERTC
	4bI/KyAL77gTRUclLoVYNl+qmRlUy6Ynjprd1qJvMGhjkkukpZJy3iNKkKL0hOIYp14=
X-Gm-Gg: AY/fxX7hZ9SzB842Q8VLWUSbwp258utRsH5ibJy/Ucw+vr5Wn3s791dXshhBZSENfmc
	Wy6AW5SrJAgQh72Zv4wh+vI3/zodaDecO5bT8QluKehjeZ5kkHRYkNNEvBGg06y+HzEk7b9dPvL
	jcznYHBT46nNj2vDrS0lzN83kIHEkZ2qnqRwaFbLgCOpSMWoZbYuFHY3Qo76JaFPM+rLCNdDvYP
	cPJWC5+nFwi1NL/LsaBFeqx6VRFwFzSuHR3276PagrCp2MyYKFlgW43NOIyoDt7MU5mJiI2lMtD
	TEsE2dwSzrtWDkeEGp9Hr2dlCoGfErMOAp3rHU085KEcNJUDunJ15sy45LBeyWzHbdq2fwYGNgn
	tSRriT6qoEvRG35xvySZU1Yq6uDoPvULZIT0pFAePKBOzWKKtIlJoUJW4rzIhQkjG0G+hmXIc1D
	2PX/iwLic6mg==
X-Google-Smtp-Source: AGHT+IEiGuI0GotUgdY/1hqH2sbbXfUs3Nw/EuyNFpfnTQhvh/Wgt2YuycOrvgw2U3cHqkVlTTD5Cw==
X-Received: by 2002:a05:622a:11d1:b0:4ee:28d1:4b91 with SMTP id d75a77b69052e-4f1d059d49dmr106375541cf.54.1765728371049;
        Sun, 14 Dec 2025 08:06:11 -0800 (PST)
Received: from localhost ([2603:7000:c01:2716:929a:4aff:fe16:c778])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4f1bd70c2a7sm78168641cf.33.2025.12.14.08.06.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Dec 2025 08:06:10 -0800 (PST)
Date: Sun, 14 Dec 2025 11:06:06 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Marc Hartmayer <mhartmay@linux.ibm.com>, linux-mm@kvack.org,
	linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/page_alloc: change all pageblocks migrate type on
 coalescing
Message-ID: <20251214160606.GA905277@cmpxchg.org>
References: <20251212151457.3898073Add-agordeev@linux.ibm.com>
 <5e79bed1-598d-4e34-8f1e-87b6dba52bf8@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5e79bed1-598d-4e34-8f1e-87b6dba52bf8@suse.cz>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2703D12001E
X-Stat-Signature: ujzb6kfqckzfzb8a4tdiq337maixwi4d
X-Rspam-User: 
X-HE-Tag: 1765728372-960698
X-HE-Meta: U2FsdGVkX19PRXKbmk0rSyl04E6V0vgHGCjKvQa3m8ICGmme59Ogbq1P1/YgNYh9uiDIZF6DE4XEmErZ7syXZ5xpMi5+HI9FnDiWbeg1OErTVMcsBEdSNDKfKUTk0Q0Sb0shHWEu4rfa/9LaZlqELSHhBRZAxtiAGCnXdiZ0PUXMhpuUf3baAD8KTrF1ylsW+qhHP9uZV+q7LJrPzxTf5bYSc3H3QlApKrCxS0mdkfb2fGwXWNIoRd3xV1aUElvyQASvFgZYbE27LKdtwt+51OPgondhBgBPoWAAHbTXs5b3dq4o4V8eajR8sP/hT4ChRNTpP1PVe72dKnVDIttOqpecHVPlOGuxTo43dbbJJJieCJEE3cFWsl56Esj7OB7CVDgHXP+fP0WdYuklBUdyMujHq2DRe2Yi0W5It7mum8qjsdNZFXeJJLssbAIJSMa4lYLKlwDrRuJZ5s/Bwu3czZhMsLT2L3ZwZ8fOvsCnW8VmRsG/iCpqZa2MYXeXQTjI9QNB3dC6t8Tj7eqOuv06DEYd8z4NS9MhLspls5aIdjz28LJidQ3CXdnWsx3WTWdASSpPtP93+9GIq4CsJDNZMep+d53GqhtsfGUjCAbgM4Rc5Rzyq7RhSIMrBi8lKjC1iSkpGy4WiI7xFGQgmGwai0T/+cCoKyd7UfBS2jmsiiGFgDKLAqJW7eSngro+VppAwJGGsejmV+IPUZuffx7NViYXObfQPecTxxa65ngyLg0A18KwedkIX89PW8zw9ahucBdaR0LzLDxuQi1I9UjcxhWxhDnAQDM4HG8/F2vdYoHDcI5kdHbOnHpVkBhIrne/19RG7sEUeqUjid1EafqoHGy6mKlSGZHC/YwTxQfZRUfGUD04i6Tu72JeegIUC89P7u6Uj/ycLm6AbkCFCjWUkehzF1IpiVfdp84HnzoJnuRiVL630n7nySHFYMp1P6glqjjyQn4+7LEw8QVL3uF
 rLcTi0Ad
 wcob2hrSqFbDlN2WCG2YJ9DnbRouxfcWVgTuCRa1ZKNTtwmi9qO8XhhYzBTbKtkAWbnhTrHk35mneqy9PizQ5Re+Cy3+IX/s2Z8H1/3hDpMYT9CIse0ImVBG9PhlPp4s7LSXbt5QpS2+9vOb0dZiZFRqPyu7xHZYJV4V17MfnlhBJ29cwQXUgrDKpKB2BQMtNg/nTOucivIV3fKRUvjqrnVcShvtQ3pQnSWBBBKVpqJJW9S+0en7De6On0Lj5LkMiEps4IfhcLlKEpF0voLxKyC/SrKtnMyyeoSuK4zZwVMUCsfENTZn29sz754EOAeILxMg7Z8LGumqkPCDJMyoURNy8jL4BVgMTwer2sFoNyT/kcwSwu5xvETa/lM8cScnVVyIYLHsnHxz5GsngafjImxq5pQaAWwGX6JO6HZhOd6DNW3elbEZvBCmCvWQ/g9gaExb10rbgrlZkRT50pPUvuA3TaHr8X1XKAjarvxF5Q2D4uEE56CftmsG70g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Dec 12, 2025 at 04:46:46PM +0100, Vlastimil Babka wrote:
> On 12/12/25 16:14, Alexander Gordeev wrote:
> > When a page is freed it coalesces with a buddy into a higher
> > order page while possible. When the buddy page migrate type
> > differs, it is expected to be updated to match the one of the
> > page being freed.
> > 
> > However, only the first pageblock of the buddy page is updated,
> > while the rest of the pageblocks are left unchanged.
> > 
> > That causes warnings in later expand() and other code paths
> > (like below), since an inconsistency between migration type
> > of the list containing the page and the page-owned pageblocks
> > migration types is introduced.

Absolutely right, and the fix makes sense to me. Thanks!

> Hm I guess we haven't seen this before because it's common that
> pageblock_order is just one below MAX_ORDER so we're only merging two
> pageblocks. But your arch/config must be different to expose it. In any case
> LGTM, thanks.

+1

> Acked-by: Vlastimil Babka <vbabka@suse.cz>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

The warning makes the issue loud, but your patch is arguably fixing an
earlier commit that introduces type updates during merges.  How about:

Fixes: e6cf9e1c4cde ("mm: page_alloc: fix up block types when merging compatible blocks")
Cc: stable@kernel.org

