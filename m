Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E70A9C5DF89
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 14:01:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B776C6B0095; Fri, 21 Aug 2026 10:01:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B01DE6B009B; Fri, 21 Aug 2026 10:01:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C8E46B009D; Fri, 21 Aug 2026 10:01:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6D32D6B0095
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 10:01:25 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E324A1C00F6
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 14:01:24 +0000 (UTC)
X-FDA: 85125438888.15.FC2314B
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	by imf08.hostedemail.com (Postfix) with ESMTP id E90D516000F
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 14:01:22 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=KIsDKhNY;
	spf=pass (imf08.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787320882;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H1ffK8I93i5V8IKh3wYZJYM9LRAB/3UG35EKVm7QGl0=;
	b=a60za4/9u2rDX5BZQaNKoLYjX3bKE+uAThGVnNRnZ3WNO26HePFIc6Q6CcW5MsT3TmCnsq
	P6MZlRjMT9qCQUrm3/o6FwDmz9fdSVexR2nOQnvPKhbafHN80CabiLpsDx6U/PpHAdFeZO
	8j2bZ1RDkUsWwmFPIjx9WEe5wBgG3GY=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787320882;
	b=xQTUAEil0mbzTzm/nCb1MJfUJRWWE4Sbgs7iAcvkSCWuK0NJmsPSYo1VciT2eb7p+y2t7x
	m1O3+OnJvYrTryHrDxDRSES4kJpb6lb02vDfC4v2iWTUHv2Gdi39cGmHemOpcS50lQZ6tl
	Uwg1rkVx68pI9Z27esOlUaxeipPtjoE=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=KIsDKhNY;
	spf=pass (imf08.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-49954b88fffso8778765e9.0
        for <linux-mm@kvack.org>; Fri, 21 Aug 2026 07:01:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787320881; cv=none;
        d=google.com; s=arc-20260327;
        b=GWOmIN+kZ2ENNoq7YRdykySzBghoV4KSXxQ1SRFLXKUlAnA+YsFRb0Mg4bhww4Gv5r
         a8eOnLOYh3lsbIsVPYqkW+YzGLYTS3L8PXH8oy+phR6B+WiINhJzEJ4IZz+65PGRExSV
         SZS8KJb6uuSdG+JV/TRXiixwWhV7BBdvMC3yfANOThQr7cLNpZOGo0aSQR3RcXJU9fCK
         4am1G8jbYkdR6tFTJ/IAU8jukN78b/MvFQouNgyIAJFBnblUfSsY4dkcRNd4el+HNqFJ
         sUSmmzM9LqQgiHPbZCSqz1yKtmhfjKI5ESHbA7R7jKXAGqwGrYnH5dCF4VIVwGbAYDHR
         KBhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=H1ffK8I93i5V8IKh3wYZJYM9LRAB/3UG35EKVm7QGl0=;
        fh=ve5KP2LV8x+h5TNZggcEvBi4yG0rikKdAsyxdfox+DU=;
        b=Dos33J0NmCICGdG7yrX475cTFqwu4SYkcjt695vyMsV1ix+7p6cvAovI0df/UducAp
         pm3N8D8B6jC2vcQLwVxyBkFkFWEHgtIqWs7MH0CuQRqrzqvyFMUo6MpOnfWYPStcH4AD
         dwoVEBQqVVbWkLXtmQsxiP6ZjBC+RvxsrD4aWh21kMgx0IpKp0cn+X5VR0ObbpTwnX6S
         XyymF0HRwenGbyUjqDST5XkS0dMK6G5nDYyUOHOyhZ6XKZidfnkjiIIBB5ohGBUz0aaT
         ajdPcmfVLipzoNpUhwX9L0vaFg5zgM+rnGV35ct8n9ia8e+bxl2fiWNinXbSSVFAj1k7
         2LZw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787320881; x=1787925681; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=H1ffK8I93i5V8IKh3wYZJYM9LRAB/3UG35EKVm7QGl0=;
        b=KIsDKhNY/0Kgdjc8LbF0rh/7XjhlkS70x2IO8q/tKCXbtSMBHkJirX4vl4WkiXFjJQ
         uEzWCmtePaKNYzamqwFM38Y5mf19HLrJ2NWZSGq7zaMMim/yHmVdBmBVOlWTlDHMvc/E
         Ifc9aF7I/fhdyURDr7kP5gERm2uXBl5Fc57bLUE0+shjqQ0C3S7wjPcTo5F9RvO6sa/7
         oWaDOy5KmtEOhtDNfNFDZe7xzA9Sz0oEFIFl+R+Vs6xUgVyB0Gy5w7y9XV56QUM9SCxs
         DJcDEG5SBbWrRFLcCwqoNe+oMj0Ub4MbpPoKBd1yoXS48CceeDWA+dAp4TWQwsilvzNb
         0DYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787320881; x=1787925681;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=H1ffK8I93i5V8IKh3wYZJYM9LRAB/3UG35EKVm7QGl0=;
        b=sWN97b20tAmyIGhiU5qSg3/4V7tLkCWbbDhU3FICJDKNqdn4x9HuUbauwCUBAGV2Zv
         yahtKMJ8NXBzTKwY3beVK3eNkGExKaDj/vKq2A4zq6qGg5TDSVPtrXNAWHRBBslbm8+H
         pG6LaKq7M44nLTmq+/CmnjYtkIdMQdM3N6BplcC6lwzEctQjQUGjeQV5OT7GDUIEJ5iA
         sF9plzPyPgZYpFKUAuwUOcCEFELS7pMcZcBF4y0ZdyaudfOjAh9kmB1oDOUFgLLHWh1z
         9qqIa/IrHjiMfyvWTgHicQxGn7LCvUtuzS1eLR/EyqtbkawRwogWob4jcqvf64kAJZuW
         u1dg==
X-Forwarded-Encrypted: i=1; AHgh+RqX+ba7T/eUoDVqISJYiqwdSiGthcdmzxQNlUCBWmXLmY4UBSW3wcQxkMifhU9X9fDX61upe2P3bg==@kvack.org
X-Gm-Message-State: AOJu0YyQcAvM8Yai7jVi0TyPJM3prSvY2eO50cZV4orAXSkbESVPocyN
	jtuFKgwSAytJgyGloKOjx3SvHswhgPDza5e5J5QxD6du0dz7RJG9Is80Yk7BsV4Ragh5xL4t0Pv
	MkpuUjc3LHCGOlHT7ysblBgJ44OLYBCo=
X-Gm-Gg: AR+sD124q10osmvoX3xDZIazjR0M+51KhdghQe64AsZpdbmhaN9B2K5/ZzkdivWUKfF
	6AsrTsz6UgmG9SeMgYR8dQWPT4V1hSODrc/N0dkgLESAaCqfkGTRox1Ml868oHM1W5ZdI8gzxaj
	0SFqFLcaSBCzuwUdIe3WFyRiTipbafesk0RRa0CIxDy4ScDHCood/YNr37ak0i2KQPAX38m2Wr/
	H21pQ7qrI/e40kO7TVfkE19xRGPsndViy71THKZVcVtkElMwifHOIPrGJwGoyi/yh4dIz24mqVc
	ZmTIBM4TzNauTr+Krpg4SFQ9c8Us8wZ6KZzWHKHheEosBu0=
X-Received: by 2002:a05:600c:1548:b0:495:7888:281c with SMTP id
 5b1f17b1804b1-499b8268eb4mr102805535e9.0.1787320878874; Fri, 21 Aug 2026
 07:01:18 -0700 (PDT)
MIME-Version: 1.0
References: <20260818163221.589352-3-alex@ghiti.fr> <20260821083500.856970-1-kunwu.chan@linux.dev>
 <CAEmasaUzCU7r7DzJfMFbQGZCJvA_wOJifPywQmy8mOz0efWn8g@mail.gmail.com>
In-Reply-To: <CAEmasaUzCU7r7DzJfMFbQGZCJvA_wOJifPywQmy8mOz0efWn8g@mail.gmail.com>
From: KunWu Chan <kunwu.chan@gmail.com>
Date: Fri, 21 Aug 2026 22:01:05 +0800
X-Gm-Features: AcwNN1U-quZRJWiWdw6RrMN6dMLen2bBdHYXmOqgfoQQew-i8a7acS4dXR_5YhQ
Message-ID: <CAN_Opa_vhvgxZUvsXN8ZvCMv2-9ZBywzJRo=LLjcXYWarZF-ZA@mail.gmail.com>
Subject: Re: [PATCH v3 2/3] mm: swap: drop dropbehind swap cache folios on
 writeback completion
To: Alexandre Ghiti <alexghiti@meta.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>, Kunwu Chan <kunwu.chan@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kairui Song <ryncsn@gmail.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baoquan He <baoquan.he@linux.dev>, 
	Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Wei Xu <weixugc@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: jysds9tknruh55i3kxt8a7f6fqw6ghrr
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E90D516000F
X-HE-Tag: 1787320882-464431
X-HE-Meta: U2FsdGVkX1+40eIff0+6kdWGeTY0vI5StZVesFApjeJa3jsDofHBVw+XwRJ/1Ct0iBljlZ0ThtYSc+uMohhVAUrZynCOWUCa1LQMbKDauSAA290Dbu2GAqQhAOE+pBs6byb0+hil+KgggddzvgAbJpbRSs4KVD7E/XEK1EqBlhSwx3J9paxWWuGs6H0POGcts0B5WgDSfQFeD10axpUYn7X2NeTKvjksdpZMIFCjohuY0+XEw/tH316cWhgbT/Wc5hes7nYd7UXNvg1Oqb9+K6QkyrLbrgkctfky8MlKynuDdg4brDtzzJO30MmgTvn8zYRLXRKXhr1uZ9MTqc83dKlVbLux/YWw00cJByFSFS0KTYmdVqPuwbgilEIGCmZtwdSm0MFKvrO/ud8W2E8jQs+BZSxpLdOdFLTckfXSFdtd/Lr1zitnFjVtXHGbZ0tzuHsNPBcr0k9Up/70jWCkHzb2g7FBeEb1FjPbb4bnvbIJvIocG/5uBrVeqRAixYWQ22HMheQkkymvxgxFmY5ViQZqkkfuS1kCtTWkAX+FlpdhBH5HwtKsozw99GrxiDKDCYmhpsd55LMfbyb54nyrXcoEEvpkHYOd4dFnZvaLCB8ITJzuEpV4uv9tDl9c2pKU5y/5ccLU5GYvTmVd2XQT2tvbw+BEYjY1U7v5A8gyzP+qbDjQw5+Vi2d59+lgvV1GMxH0kEyT0P+aDx3nno9VH2ojtmu+6dHILtOIyqkVWVQbgVihXG2eYavGdz5fxG1j88uRwS4tC+Rn4wLGBxzT2THZScokIbXxSlAVk607MsoDrOh5ki2IfkzxDOxeQOgXYm4rhosi4VNdSMpke1rv5lTN0FPxybl44BGdxDzzIuNCloFolNo8mBwgS4jwy/CK2MQ3H2rCHb19yysDxNVF2RYX23bst7RTJngPxi1Qt9MVkgcHemHGppVvk6TMShKFGpHtgKrT0PrCS2NAml6
 +YM4mBJS
 w443cYy0LPjfy89tgt7jaiCdXfREZd/VGOjx+HMPwQPWtfhV8te8+CcmuHBNNsrVICsgTckteoR2A5zFzyQm1+zqnc0xlsTBZjeuhPPTo5YZVZVWL2R0fmh7YdhTL6gawNaJG7TWTUwGJMoonBbqjHQAwe8IWUnwIFq63wDq9JLIUyYWM140FdZPrrS7/85Vl/33e4EG+fSQwD5iGhN9NEgKR8fNorhP//6vsnu/gd88aO++bGJPbGzUXFlJfpW006h3RjYle66ud1P9vhfy7b09ZjW0QjgI4OtkYhhBSLAeaUT7CRiLuNbXdENNtM9QkuCDHGW4B9oPH/o5P6iv6e4ncwy40UFMNYwwEarmUhlTHvP3Lad/53qVH0cL7t/ZKdUOxJiu365ygrcpMjWiFtcdVazruSvh01pdK6rEtggxEMwnzHCes5YHB+d0VmK5kXO6XWmmdH5yUV7s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Alex,

> Hi Kunwu,
>
> On Fri, Aug 21, 2026 at 10:35=E2=80=AFAM Kunwu Chan <kunwu.chan@gmail.com=
> wrote:
> >
> > >
> >
> > Hi Alexandre,
> >
> > I have a question about the reference ownership/lifetime model in the
> > synchronous-IO case.
> >
> > Consider the synchronous writeback path in Patch 3:
> >
> >   zswap_writeback_entry()
> >     folio =3D __swap_cache_alloc_folio(...);
> >     ...
> >     __swap_writepage(folio, NULL);
> >     folio_put(folio);
> >
> > During writeback completion, Patch 2 does:
> >
> >   folio_end_writeback(folio)
> >     folio_get(folio);
> >     ...
> >     swap_writeback_dropbehind_folio(folio);
> >       llist_add()
> >       queue_work()
> >
> > With synchronous I/O, is it possible for the dropbehind worker to run
> > before zswap_writeback_entry() drops its reference after
> > __swap_writepage() returns?
>
> Yes, totally! The window is short though and in that rare case, we
> would fall back to the initial behaviour (almost, since we put the
> folio back onto lru but not rotate it). And for async devices, I don't
> think it can happen at all.
>

Thanks for confirming. That makes sense.

>
>
> >
> > If so, the worker will attempt:
> >
> >   swap_dropbehind_drop_folio(folio)
> >     ...
> >     remove_mapping(swap_address_space(folio->swap), folio, true, memcg)
> >
> > while the caller's reference is still held.  Looking at
> > __remove_mapping() in mm/vmscan.c, it expects a refcount of
> > 1 + folio_nr_pages(folio), but the extra reference still held by
> > zswap_writeback_entry() would make the actual refcount one higher.
> > It therefore looks like folio_ref_freeze() will fail in this case.
> > Is that the intended behavior here?
> >
> > If the removal can fail, the fallback is:
> >
> >     folio_clear_dropbehind(folio);
> >     folio_add_lru(folio);
> >
> > This appears semantically safe, but it means that the dropbehind
> > optimization is lost for that writeback: the cold folio goes back onto
> > the LRU and has to be found by reclaim later.
> >
> > This seems particularly worth checking because v3 intentionally removes
> > the synchronous-I/O special case from v2.  The cover letter describes
> > that special case as an optimization that was not worth the extra code,
> > which I agree is a reasonable direction if the generic path is
> > sufficiently effective.
> >
> > Could you measure the corresponding fallback rate on a synchronous
> > backend (e.g. zram)?  The 99.996% success rate in the cover letter is f=
or
> > asynchronous NVMe, so it does not tell us how often this particular rac=
e
> > occurs with synchronous completion.
> >
> > More generally, I'd like the reference ownership across
> > __swap_writepage(), folio_end_writeback(), and the deferred worker to b=
e
> > made explicit.  If the caller's reference can overlap with the worker's
> > reference, I'd also like to understand whether that is an intentional
> > and acceptable trade-off, or whether the overlap can be avoided without
> > reintroducing the synchronous-I/O special case that v3 is trying to
> > remove.
>
> I need to look into the patchset that Matthew and Barry pointed to and
> check if it's still relevant with this patchset on top of it. If so,
> I'll add a debug counter to confirm we don't fall back too much for
> sync devices :)
>

A debug counter for sync devices would be useful to quantify how often
 the fallback actually happens.
I'll also take a look at the patchset Matthew and Barry pointed to.

Thanks,
 Kunwu


> Thanks for your comment!
>
> Alex
>
> >
> > Thanks,
> > KunWu
> >

