Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B3CEC79F9E
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 20:55:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 777E96B008A; Mon,  7 Sep 2026 16:55:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 701FF6B008C; Mon,  7 Sep 2026 16:55:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C9346B0092; Mon,  7 Sep 2026 16:55:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2E6BF6B008A
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 16:55:18 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A35131C1CB1
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 20:55:17 +0000 (UTC)
X-FDA: 85188171474.07.35840C6
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	by imf10.hostedemail.com (Postfix) with ESMTP id DC001C0002
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 20:55:15 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=X6mcL0bX;
	spf=pass (imf10.hostedemail.com: domain of kmehltretter@gmail.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788814515;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KDcKeFOL/6tB2pNS1oH2r+LWbI9kVFu5xPPGFkyBFIs=;
	b=iIMLeGWtgqMsyxX2/VOt5KzkElj5lMgsJLB8mXnQaXjkuYqNfXtKkapJwpcpiGk+1kV9tl
	nPn0QAeFqloPnjtget7B7VPPDJS08qO5XQ3sobbOybUa2L/+J5gHGOTIDZ4NXAIZOMKIj1
	49rjNGQrsC8Xtb94tdJWBeCZ7GoAdpg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788814515;
	b=cTAn9xr4TZ35xn5fYDD3ir4OBO/3Zto/iQSa+GNqjBKJOywmUv5+/mKFiWcvZc+pk+bOc0
	wkUklKD92roBQel7719g0lWJnVRJ8JSwLvFM/RxHzol4B8PO/GfJ0O5nHPrB2dY++G0xrJ
	R5Wk9NvzT+yIWUD5HyCytZHY/s+qIjM=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=X6mcL0bX;
	spf=pass (imf10.hostedemail.com: domain of kmehltretter@gmail.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-49556f97a9dso33291635e9.1
        for <linux-mm@kvack.org>; Mon, 07 Sep 2026 13:55:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788814514; x=1789419314; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=KDcKeFOL/6tB2pNS1oH2r+LWbI9kVFu5xPPGFkyBFIs=;
        b=X6mcL0bXmC4WFkIiZFaJaatQyxhLIc7cTz9tiToQy9DNbYP1jDryG4mFg7Shlp9Xgm
         3apePvfG8McJCmUoXwCBGyOhHCx2wbrkF7tsMNBwdlG0b16bGZAFGJreE5UzcFIlUzeo
         3URy2vhwWbh/oWR4AYqCnhRxbFLRAmKWvYfl1FWm3ITQq4h8GzUXfsltyOEoo1mGyzxV
         Oz1iOr+ijWmBrRP66+f87rwh1c1U9fuxhU6gWza4/1G65hP38f2rwzxGduwWaFz4eCNI
         /1o4fZZLqKodvnPpJO5IsjifDtfDpG2FijcPshH4yfdG6mI4fnnWqX/PRU2xqZtpq3bE
         F+6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788814514; x=1789419314;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=KDcKeFOL/6tB2pNS1oH2r+LWbI9kVFu5xPPGFkyBFIs=;
        b=dJx3V5EB47uvQeV9ktXp46bMH6LOFAyp3pBR7VdCgzytA5nF6DquYM18boFHkNv8tX
         NTgbYeN0KB7h7aCQPgoPWRtzOHkju8ZVCkVgddzzn2bGmj/EFZp6aMG8TNjVnuck1OiX
         CXEqKr1rHSWZDrkV1nMw7nbI1t5mvG3Xra/1tfRrfxWCVufyXOsEgBaimDPRpW9iY7Sg
         4YPXo6G0PUfIICtkqvJSorTCgI/8DVz/5gLYoha12k243n9JMcBeFYqDmmvLZYuquVke
         W0wAUy/f7BgGBmJfmfP5EPVCQ7iNBlgg5NSvdmml+hSwv0DFGlLtJ13PSZbs2cZ7i1v4
         slDw==
X-Forwarded-Encrypted: i=1; AKwUvBxbFwk/ckbAg/YaTjOXAIlRn+ElllLZHduOotm51xO3l6SWko6wYhcerVJlCwx98ug8g3i4L7oUfw==@kvack.org
X-Gm-Message-State: AFuF++lDEJtzRwkcHzy0c0zhXJPpJloqF1cN1oTV9snljxjxRKZFzV2F
	B1wO2mBglAil4DI8dHn/zvgCO2NCloSIGuY5ZUoYRS/9BVCuXQLBmE8n
X-Gm-Gg: AYBFou3mPiyg3bvrDp4KvwzccZSeGAWsXQ2Jy6m9FQGPCQHf+0cCLSC6AWzhmNQI6wa
	er9hBgQohfRqYR9TITj6JjsfVGN5n9U/bMaEdS2U3BMeab5yY47pIRFQjb/LGoOx54BjIWLmcs3
	jymOKy67iYbIIImMjjtou2UYXfL1gmZ0sSNkXXOu6beTzPPL0mF/bWjv9EDkfFv5evlreMFufrS
	zRawvqUNzn/ngFvKh2K+o7yrOvzMPDvku21fDW91ROb8brl4VDyontu/30hCm6LiwyEPLzvhlgM
	hLj4SWgahmNZrng9ma+XrZFvM0KXLn4Z4SBqEhZtPfEYiskzL+mpOLnBJiPuzPlluWns9PwNQPu
	6sSvYIWpQbdHnELlyW7HIMJTJzR1k7w0EqCUZ1S/1Jm7lt5jGFcFoN7edAxGbN/gCBMsm+TS0rL
	zuILDee1xRb98hz8hNFFXv0WBRypFO/kLkLocjrmsllHgsTg47hNd+hFetJVGwgzzdc2fd5XsiC
	Mzw3oltZRjpt4DuUYs6jqnJfvhX9VchkymfXueVOPoUuP6potcJttHphbX/MLedAC0YwGh5xFRd
	BjvynDlL5mAZiSLG7e1vZ9kNoGeAvWGKXTv2x5PRLQQdDl4rMsUSe5mvB3VVaXpouEVpSRiOnnW
	dqPf3BJUE0Ms=
X-Received: by 2002:a05:600c:a40f:b0:49c:fa21:e74b with SMTP id 5b1f17b1804b1-49cfa21e9a7mr170706755e9.33.1788814514233;
        Mon, 07 Sep 2026 13:55:14 -0700 (PDT)
Received: from MacBook-Pro-von-Karl.localdomain (dynamic-2a02-3100-b0c9-3601-cdce-ba4b-d0e3-dede.310.pool.telefonica.de. [2a02:3100:b0c9:3601:cdce:ba4b:d0e3:dede])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49cee5d476esm462446835e9.1.2026.09.07.13.55.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2026 13:55:13 -0700 (PDT)
Date: Mon, 7 Sep 2026 22:55:13 +0200
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Subject: Re: [PATCH] mm/secretmem: Fix the enable parameter description
Message-ID: <ap8j9MC1_UwBMIyQ@gmail.com>
References: <20260906171523.3009-1-kmehltretter@gmail.com>
 <ap25Wj-kt2nsMn59@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ap25Wj-kt2nsMn59@kernel.org>
X-Stat-Signature: bx1rra3ggdw1shft4s676b9u5fp9coe5
X-Rspamd-Queue-Id: DC001C0002
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788814515-824313
X-HE-Meta: U2FsdGVkX19t+fEv8RB0ICyg7MRw6n1SK9pZRHAWooey2PbyUqn6+YFV2g3JltTELj+b+HpjjVP+4Y79nacvo25rtPIwDhoQTzFsLiTVWng19XBkpZ1Wyx2IurkB2CCBaKxi0OsiOmWhIopA7ijZE45ZTPZDrLS0/kAEXK5iXld/wRS2KnnQckH1BjxZUkxbMQgS2pW/Vzr6reHHYHk3Aos37EESvR0fQUvVkFMTajvnWRh+2hKPawAOkD9BqbzmJPoCJ8zxQw6YN6PzKPj+u/haww6ghNGe7IUEgeqj5uSdkiynjzyjsnNaHgJmSyi9l9ad1JuVGumBzn+m67XZG3dSWnc65eZhXWdYLO9+sJCl028GiJTaTxPL/7MaAMwqHVn/JaMYNWOG/dqU0wZm9L4tXHfhp/gRL+wYK9MmlH5PSG7teqD5EiSqBI1RzZVBJluNE1jwzxtRN+u67CjL9DcztubIGtTgcldkf8fRwm34i+k1jCAa8LPhx6XBS0fhPzHAm/llwby8yjOjrnf5zswFEhTww4owv5akXypJuoqEHW3NXNxh6rf3LnQsiA78v4BpZ1auIVjdQ7DZZL3QqkdaMaUgvcpaIciq8UKgfcP4LGdFqcSWP+nLpSY3PO4d+iInlwKs9R5e6/I48VtG8QKYH9b+Ioxdpln08Q/ocXfgkcl3LZFO6x8wwsnC9tTf3bX4CmiOlgNv57g5WSRABwukY1p3hVc9xQH17xspmq5HaTXy4HNObAxm+3L1pYI6MxeTI/uk7LdBVFxPSjuh7sr60GnO7AEO3t8p1zir1Cu7fE8frWMmhMwg3X2LTKpC4ra6zI1YYpM7bEVxfrsQxM7Zhm4tPX/Di4uiVH7tTpKs331DsOqAJsAU1olkBB153WsQg2BNWF+93hLjyqfaMLPKHKsdRJkjISPiLh/QFgf0/pkpv4wiQ1R6yMr8xvwt1DtixR40ceWik8RZGh6
 Is1GO/JI
 hK84Y6ETByP82yA63Dc8AUAWQZxWlyYmL4pLRzO5MkO2SRZxfTcACNHyr9CzBPV93n94LINqHH0VW+IICr0BbyiOSIGhVdZmFWd8o9dfxkD3q6HO16dF8vfecgO/jto9/AOrXTU512cANGkzehMzOIfWPJH+7cfneVKDehXcAmOK0qqZ7ZtrwYIl1mGYecar9wTZgxZfNJUIb9HhH1SqY9Q2Q8xgGba/1DCqnFzFu4r8V2i/rYy+Fhyb2HebdjPK6DApCsB98AFTb8zUT5OYyVCYp764icelST/mvdIJUdh+YQddWq2rbXNx+6HCntdlllxqd+OZuDCtMeH5kSMNliAHnc+WeCtl4QHrf8LSH5XHu9lOL3LheiOBEbvIj+j1755dV41as6IzGEV5VKroSaLvECShoGXNyY7EuMtKRHOGsk0GvjVzIVeur/aJPRQYUiCRxwgM9ZUBswtXevI70wfdax8xcXfTFy1/vScZvMbROhqKUvtHYWOMQ1xoWAq2N7JX7r2ic93P0LuElWVJdZtRRAw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Sep 06, 2026 at 10:04:58PM +0100, Mike Rapoport wrote:
> > variable behind it, secretmem_enable, so modinfo describes a parameter
> > that does not exist and shows no description for the real one.
> 
> Hmm, does modinfo show secretmem description at all?

Good catch. I'll reword the changelog in v2 after waiting a bit for other 
feedback.

>  
> > Use the parameter name in the description.
> > 
> > Fixes: 1507f51255c9 ("mm: introduce memfd_secret system call to create "secret" memory areas")
> > Assisted-by: LLM
> 
> Please use the form described in 
> 
> https://docs.kernel.org/process/coding-assistants.html#attribution
> 

"Assisted-by: LLM" is the new updated form and is shown in the linked document.

Thanks,
Karl

