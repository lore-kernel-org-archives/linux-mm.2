Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7471E606A32C
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 01:12:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=R62ucZCE
Received: by kanga.kvack.org (Postfix)
	id 80A1A6B05B2; Thu,  5 Nov 2026 20:12:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7BAA66B05B3; Thu,  5 Nov 2026 20:12:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A9A16B05B4; Thu,  5 Nov 2026 20:12:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 459ED6B05B2
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 20:12:39 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CF116A0743
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 01:12:38 +0000 (UTC)
X-FDA: 85402919196.07.A2ADE63
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by imf29.hostedemail.com (Postfix) with ESMTP id 21E57120007
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 01:12:37 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=R62ucZCE;
	spf=pass (imf29.hostedemail.com: domain of 3gyntagoKCOgTOXRKYMROXQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--jenhaochen.bounces.google.com designates 209.85.214.198 as permitted sender) smtp.mailfrom=3gyntagoKCOgTOXRKYMROXQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--jenhaochen.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793927557;
	b=qW1ukpQD3YKWi3BvLG7c3pDX9atZdAghZN6OX7D0DeJ/49B8t+qUDgoQeylqJZmAvUJV1S
	grUwHjXoM7a/R/Hnh/wTI1JGba4n15zrG9z9H01NaKBN8eGb388XpetlzIPfNScFtkYR7Y
	WC5rOxf4oZEEmFx5imBXze1o9AdxuuQ=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=R62ucZCE;
	spf=pass (imf29.hostedemail.com: domain of 3gyntagoKCOgTOXRKYMROXQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--jenhaochen.bounces.google.com designates 209.85.214.198 as permitted sender) smtp.mailfrom=3gyntagoKCOgTOXRKYMROXQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--jenhaochen.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793927557;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Br8dhDWTMEC1IX0hIx4rLmHT+plyiVBiJUhQUy7wYRs=;
	b=NvfTB6hdfMD4QrJeeh//F4enK5q+7HrboibFiXTgCnkHGp6bIxoHyzKQfP9p+vB6zqN4DK
	N5mk0/5T+ggWERpgKVZi5soAwVfeJ0uNCT6SsmNEuDNY7xbolHOdFiOFD8tVyWi+31aI+A
	RRfs2E9iReUnv3JJ1nj6PCq0zksgyps=
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2ea381ce04fso2642915ad.0
        for <linux-mm@kvack.org>; Thu, 05 Nov 2026 17:12:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793927556; x=1794532356; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Br8dhDWTMEC1IX0hIx4rLmHT+plyiVBiJUhQUy7wYRs=;
        b=R62ucZCE5579NuWR+/mbFO/qc2zWKZfQXGHjIDxYYxSIeFHATrVMbWMNGKB/ItuvqP
         /r1Nct8rYusn9aT4Bkv5BHdLyQJoWWWfGD7C8cuPWCYGEMi4rGGjD3dD4BpXAWwKn3xm
         xsXhG6YaOira0pgsjdrLQ5hB3ic6k+Adc84okDMe6MA+AxOYwEc1l0v4s0U7LR6WNBZ/
         pTBaFyQjZzCFZ6swyHxW9aEscI5o9DWCUpxV0YYE83dWGRxQff9FUoO2KDFw/BLlGet8
         sFR27rBPsXDDH5DUrh7LZaKpidtfLGzJfeDvGqxmme5gEHrgZ5SJuJll8EJ0u7dHgukz
         mwgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793927556; x=1794532356;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Br8dhDWTMEC1IX0hIx4rLmHT+plyiVBiJUhQUy7wYRs=;
        b=GvRMargP1D5Gmy/jA7r61GGHHqQkvB5VGi8LZMjWO/mjeN7NPHSNWOeKL2ZKq26F7/
         1cainbaSxw7seVSdJ5CLEpaQ3PFMNZaZRncnam0nc0W6MvoVqeMTkv7HidIVHILA8deT
         /+dhUqgo4ghhQLxJhYwacGxYkcb49xmfA00spGVrfsK/TcmwZtwGeo1vCagHmlsLlXIq
         DeXdxD+XAs7tdciOWLQi/OfmUtwL86DUrej8uHM30UiWveGuVpID217U/JW5X8H5f3Ej
         SOLrgwe3h6gAS2E5P5ImQJRNPVdF61kv4LrorkUtuj/3Ua2E+EwwIoG/h/mNSWWxw5n1
         AzLA==
X-Forwarded-Encrypted: i=1; AKwUvBx+WebtQcHWD/yk24SnEhB9twiPG/EcqALZwGFs3CiotbgEW5nV4S+sGmD8v9c+UQhhQqA7H0IRew==@kvack.org
X-Gm-Message-State: APuU4Z8khjCIdVEryl3jDTF9L3aMBbbeXO4S0PCv6+E4SyoowSlsln0Y
	8ye1831lQrbWJSzGUP52nGg1mOieV3bvhhlmgX0DqKg+riMBNrxkTEQhZVGbAhmdb6iL5I8d/3Q
	B3FVEAdptkP+pFSOdtoDZzQ==
X-Received: from plbkh3.prod.google.com ([2002:a17:903:643:b0:2ed:27e1:d579])
 (user=jenhaochen job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:cf42:b0:2ed:520:2641 with SMTP id d9443c01a7336-2ed244ecb8emr32394355ad.31.1793927555492;
 Thu, 05 Nov 2026 17:12:35 -0800 (PST)
Date: Fri,  6 Nov 2026 01:12:33 +0000
In-Reply-To: <auxjJapQ4j8518aH@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261030121700.260975-1-jenhaochen@google.com>
 <auwR7gnuLsF0lpmG@google.com> <20261105103947.7521-1-jenhaochen@google.com> <auxjJapQ4j8518aH@google.com>
X-Mailer: git-send-email 2.56.0.455.g6c5a503b38-goog
Message-ID: <20261106011233.3270937-1-jenhaochen@google.com>
Subject: Re: [PATCH] mm/zsmalloc: inline obj_malloc() and obj_free()
From: Jenhao Chen <jenhaochen@google.com>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev, minchan@google.com, 
	liumartin@google.com, benwei@google.com, Jenhao Chen <jenhaochen@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: thfz59huhbazqo674bquicyagz9zh4r9
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 21E57120007
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793927556-658020
X-HE-Meta: U2FsdGVkX19t3GinvdJq0iDtRkioZ5MGNBwFcMA/IXBPLAYeT6N04L34r4VFnkShMbwD6pctciymDmJ/xv5NyWt3gVPLgEm/jHIUAv8fNcAoH4vrV9tjE2Zz/EVntN/2Df1ZA8F1nWzvJNnbFuLipiv4QtEU+3JfdowT3VjATooFhBPeFa3VcCWPohQ3zaKG9sMLEKecrl8kK31MM5B7r89SvBn5jx2tnym7SifaQaadFVlKg2f1JQa8NZuagAz9UZQ8oaIqLqLb+OLfOI9DbDihoO5/zGHnDgjcmjrO/JL5HZazDfbbTVFqkRV8TWeLGlLWxk8xZNdeHJDEPDI/QQcS7Ajp9FFRTerjCLC6Hq+lE3YIZlGhJhVGW1oMbV7UiAwg6nN7WffrTnt93hrrtf/UDJiOZVnB0cv2fTijPMQg/HQaaUIdCJz0hLcCW4T0FBt+1m0JjpnV68eir3VVQ7UoAM1yL+bv3w4/ZAG7gCGJP6JvhSUPRDIw/vXdQnZUaxZfMJSbWfW/VBkEQJwuircdP33mQPam7tWBF9wrJgkcBYxVHD01TM3TRjzM5OiaClxjNN8SrcE51mbjRP/oMF4bgeB1vWUh6PRpjLkUc5gipYhNDZyVn+CgEZ+kLkiyeCa9leskc+AjQbsvFYR87Y9La/l3BjpSMrwz8Ttyco3Eh1D1W78dtj9wd/eWJf0LH6VjTJOXYnNX0yoeC54OcvUiBnQyw0aitvYumnzqFlUzMRlTMJCGnuLthwjVa9Mi34ys2rDf27IF/d6YRcgmdYU8uEOEre7BR7+JFxcgYVfgA8cwgl1sL2IOIx1BC9a5rsXE5hq9aUm9Q1lgIAw/8Zn960XZ0brCSsYfPX/I0Buy3nj+VIHtk/Xgxf0bChJpTyAq95GCnk2GWF0ZVEncbWNaFBbj06i7ZFVfyXfQmooHHfzl+p+7aMB7IbaHvE/B32C1tLSwF7w5azi/b7y
 wXPz2c9f
 rJy4lhTvEPYO0dzBz5vfnCLnYuW117zifbENXxA0Wki90MtYkmiSl+jKPOCDzI/OExKGSMx63UU74Xq2XOJKdy36oHk7a1pS0hNxRMyYPPg12fQed+s3PfI9eoVZqsVyPk+8kxEWsdPxeA2iv1LxYHlaG4dkqa5B06Ap9PFyFJjBCQTGEq3K/KYcEIwT7tgXtmXqxTedfnfNM7cfBjCYomEV7/EzxxVy1q4yam1Qln0cVCYOCrCJklpm5ySp5z4x9SZk6v+BCOqQmoKdZKNtZXXadybdtfMmFjFk7GPt5iZTALDXpoQgdXCNbsklXMjguZePORbTKfZmLAOIYBrcPJpcJvp0wCji96AV+G5iTBWblwHFPhkpHVCuTJvA7sZYaqKLSke5j08Xqn43ktUisgHxX98c/AsiBqnzBiDlxFXFtv0hJhIbUWdougy6sx/Gt9VLps2h0miD9ixMCzDhfPa2t247HlZ/Swve732niGI0j02RihIp6EUpAh1E2h/k5AXHZLj1/c1xvoeHibdIuRBk4y169WXRls9bUPXjp9OaU9CGzcBwNZNqJ7tR8tonLYLJalr4m1Dcz11i3RMqxSnSFKyca0L0eLGVg/kCKSTLbonXDVX5VQYU8fJihnFxA0TRl3GNROIasKdJiqoLcmQid9rOIkLdmah7W
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On (26/11/05 20:09), Sergey Senozhatsky wrote:
> >    If we also mark obj_write() __always_inline alongside obj_malloc()
> >    and obj_free() (with noinline on alloc_zspage()), the compiler CSEs
> >    those redundant operations across the fast path:
> >    - arm64 (Clang 22): -31.3 (-O2, -4.0%) / -34.7 (-O2 + AUTOFDO, -4.5%)
> >      retired instructions per zs_store() + zs_free() pair (vs. -8.4 for
> >      obj_malloc() alone), shrinking zs_store() under AUTOFDO from
> >      3,144 B to 2,448 B (-22%).
> >    - x86_64 (Clang 22): -26.6 (-O2) / -31.8 (-O2 + AUTOFDO) retired
> >      instructions per pair (~4.0-4.5% latency reduction).
> >    - x86_64 (GCC 15 -O2): -37.1 retired instructions (-5.1%) and -5.3%
> >      latency (-5.5% cycles) per pair, while keeping zs_store() slightly
> >      smaller (1,997 B -> 1,943 B).
> 
> Great, I'd love to see that in v2 commit message.
> 
> > Would you prefer that I send v2 rebased on top of [1] (including
> > __always_inline on obj_write()), or send v2 against current mm-new
> > first?
> 
> If it doesn't trouble you too much, can we finalize [1] first so then
> you can send your patch atop of it?  I can ping you when [1] is done.

Sounds good to me -- no trouble at all. Let's finalize [1] first, and
I'll send v2 on top of it (with __always_inline on obj_write() and the
benchmark numbers in the commit message) once [1] is ready. Thanks for
offering to ping!

Best,
Jenhao

