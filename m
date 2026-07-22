Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5EBDBC44536
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 21:20:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5BE776B00AA; Wed, 22 Jul 2026 17:20:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 56F296B00AC; Wed, 22 Jul 2026 17:20:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 484FD6B00AD; Wed, 22 Jul 2026 17:20:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 17DE56B00AA
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 17:20:28 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9E43B1602F3
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 21:20:27 +0000 (UTC)
X-FDA: 85017681294.29.9ADA4A6
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	by imf14.hostedemail.com (Postfix) with ESMTP id BF4A9100005
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 21:20:25 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=sM9BFZ5f;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf14.hostedemail.com: domain of praan@google.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=praan@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784755225;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=77lCXIJOUcG7tXFVWP1KPzJcluoW+7zUs7HIRFXD6Pc=;
	b=fDpjSsoBJqRW6aJwDVe98Kk9XBF9nw/KTlAWnvsZxnp2VGCSmbkL2Ijpd44X33PLUVxSMv
	99Fenape82s+Nabfd6DcofzsVGV8DieIbJdx7UsZ9EkZ9n2fX18rwq4Dx8c+oCsT+F+uwZ
	mwpkRVM4xj6pW2Tm7xb2g8fV3xJRIxU=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=sM9BFZ5f;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf14.hostedemail.com: domain of praan@google.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=praan@google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784755225;
	b=EeVBSs3nQFxSx6E0YytO5aFd+ue7cEhBPaoIGrGgHboGLffanmRCwxmsrzyM5U4HyDGR1p
	bx8iOyioZx7Xqwo6saygmDG3swUh2lU2xFDaJsdCa0O9E5qcrMzcX2udSS6uW6Epj9JJmA
	040o0HDKBDQymLtUJfRgyB66mjnW5qA=
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2cab97c86bdso1325ad.1
        for <linux-mm@kvack.org>; Wed, 22 Jul 2026 14:20:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784755225; x=1785360025; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=77lCXIJOUcG7tXFVWP1KPzJcluoW+7zUs7HIRFXD6Pc=;
        b=sM9BFZ5f7XTKcyl60lT0vPoCArJhkEwcdYot0hrKEAbkFwGVrKx5yRHtX91QnYzHes
         P+C0tm5qCMWhUgcq+TPmYXfIL97Bu9R1FCp97WvuT2uTYi6yKG5PVxx2+A/pmgZmpY8N
         RAFEvA7EkDNN28857pPdC4AKREPBO2tnE+yJBMwx4qCT0DGWrfBr0mcMw8e7L49nAL7Q
         TLcvwk/o3CUwxhiAbHtizIdDKRvro/HMirZmvUpvNxkzZAltmHuF5wviVfqTEteczVtH
         B8LgYA9vdB2BMqJXu7H/rSm4RpCF5JLjw1cawdKtghbwXRg7LcyGqFrqnIAObv617TVY
         v00w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784755225; x=1785360025;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=77lCXIJOUcG7tXFVWP1KPzJcluoW+7zUs7HIRFXD6Pc=;
        b=pmxQ+LHQWLSmKAiiXsh3n1Gw+qyg27Pr6r+NJ059hI6hRJQboNr+5Is8629oN7vdr9
         TotYb0RzEcXwlMCl7mwzp0FzURqIBWCF57QF1+djemvW8zGgt+rVAFv5tAyELkei0pqo
         0Vo+TIfi210m2qw7IVaCxzjRceXo86htIBjtE19RLK/vZL2Y1DaApPI3FYaFUXU2D760
         v7oROa9gp1pMX84QNS7NbsZnOnCNl14atnmruuxa86+F7gn/N0mq9NWdaJiuG0IFgIJ5
         6f28rrizIPC3iKl0YWmwExuoXfOPORP/c2PoWQADMZgGG9rcm3cApesuUdBlnKYzzzu3
         T3OA==
X-Forwarded-Encrypted: i=1; AHgh+Rp4uZ5BJTb7qocxhhfMPiwQkiZPIIVPDGQe1boWfW4dzoJkfRjmatfrWB/PoxU2vIFol8K2zs0mVA==@kvack.org
X-Gm-Message-State: AOJu0YzG3vJT/AVGmFfmljd0F0zzXPi2avneVoa83TuLWDPIr9yxjeRb
	KOfML5NK0kny1t+KIF8zgHBqNiwYuOFLHhxZRB9AYOKYnXrQ/4rtrP6PSdbzlTNGRw==
X-Gm-Gg: AR+sD130mK2yoXdXZiytHPw2c1hs7q6KFbRn63lMCqX3/fgNWVR+WbVIyda5b81E3/D
	PtNZ3cASqfmmGD4MCgzetXG0pGj6kU0waL27uVg5YeI5fYIESPwx3eeRw8vH1PXEDuGZbjOE0qf
	08aU2r9nRr4yzU2qDhJVwZJYCP4LDo0OZmCwhkZ1STL9ScnTUG4mEeXyAaVwCcEPAbwMn1VrtFy
	+50NPhLpbn0vJ/m1+BLvLS/AD0yqC0qgb9c6yuIdudrDI8+1kwJdX4knCNrDUOUu9LwO7IeiHYu
	LxZwx4dWfrrznODgmA58IBOua+leAWj/Plqx66o5rSExWs5VsuGrY26TYbNm/cBKynrYkYY4Adb
	l9JlvSsM82/4+qvdlA6I18Oo7hKYvMbL5Hvilz9GXCjUm00oaFZKMBPBiXYMrI9vqHx6FE8cNpf
	GaAAh5hDh2Iu4axWbhTfJcGk76SRxOXPbsyZZf
X-Received: by 2002:a17:902:c40d:b0:2c6:99be:9dd with SMTP id d9443c01a7336-2cfa4e71220mr1307355ad.12.1784755224018;
        Wed, 22 Jul 2026 14:20:24 -0700 (PDT)
Received: from google.com (10.129.124.34.bc.googleusercontent.com. [34.124.129.10])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3147d47960dsm11985348eec.0.2026.07.22.14.20.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2026 14:20:23 -0700 (PDT)
Date: Wed, 22 Jul 2026 21:19:53 +0000
From: Pranjal Shrivastava <praan@google.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	David Matlack <dmatlack@google.com>, kexec@lists.infradead.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 2/2] kho: Introduce preserve/restore APIs for
 unsplit pages
Message-ID: <amEz-Tv7H7O1VVij@google.com>
References: <20260713204935.3069000-1-praan@google.com>
 <20260713204935.3069000-3-praan@google.com>
 <178456663513.143128.14871307686052703561.b4-review@b4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178456663513.143128.14871307686052703561.b4-review@b4>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: BF4A9100005
X-Rspam-User: 
X-Stat-Signature: sczb8tk5qw5cx6x4xdy9z8neoyw9nwgg
X-HE-Tag: 1784755225-972890
X-HE-Meta: U2FsdGVkX1/zIt9d8HRrHjURx4aaT0R60KJu85J6nJoyG2KTKBoLEewsAzQ6Wz9cqPHGk33X64Od9eg9eo65ygF9ezfWDO7raUaR8Sp6hDjN7spQI5gbrMdng4oM0zwi7pmZAfC5URPWhLsK75QK7n2kjl6lgg1Nrm3CeFAkKoCrCz6TVIbiXKHtrLpoQhUqV04infj7k5tuFruyOpCppI/LCIquRU/i9mpqGrWfx5wDhs2nqvfIVhdpCj9fbkCYA7qNpqGHlSErQhM74WCt7w8K9idAf01JRLt5lLLCQZTLH9OIoXJnvLlMlbESztS6CIBuG3jahpL6s3kIQ5Wv9UkSi3vXqs+XRYc6Y8GBKfzx0HegZ8J7nS9vKTLRMmABUY5XhiuesCDmtx2LEqBzYfe0kZkbisUvsA0BehwWfYK9pBEIkQpps3dqt1fzDcsRf3MP6kEVkmaVcEEE8VHD2biGQn20Xs4/xvMPYPidsSySzFZ0Qg8vj20kQGhlgN/TEYo+mFkxV+MH1Jop1r9OTFR1bBOJ28kh3W83yFHeCH8EJ9eCEMKDVZrVxDyyOmjb608ULl2+VJluuMua7u7x28S9x48TAH8peViPq+79mVOiEfzMOmOluyktL+Lk7ynbNz1vWwCj/GBwsMCv5I5Qivpg3uObej+1fhoI6AxtrR60yhjMFJba76e2PY8/WHcwrJlF1SYHwYHTTjHghpsPVQ9L1D2e30zc1CtbX9DpkaErw9oJeu/uD0YPupDkIzxtcGMEh8EPT2rHZ8ydQyUp1wa1XgFOsLC9R561waAr8l4zqAkBUpld2OUCjurK6+s/W7Ewv4fA7Le93fIJgBK5RZaZ8FqyXtreB3Kc4e07k0bcZ6yfEdp8OQ+FSVbU0L9hmmoCdZ+N47i3JzucWc7HTp8cCyWQHomxHopLo5E46pxVn4njJ2/mDsPZMbGjWAO5Fxkv9LFRVmBFSPvJQkK
 xVNfKPlk
 bsj/x7fHNFf4JUR7LfIdgwbhIkOXRd4zh4Bp5zsbyg10yPfmCteCQrLRInNUnIdl4cD1f1WvXC8RMtW3DjGjYgXJFdn/IHCIJgwnuv9jKJDXlhh9jsOHzghYIOtIPeM7C4rL5p3PSH38fnPkviJE2Gqh/FtDckSbFMuZNdVZrieeYDkc8bIsVaXADZLemjw2BXJW+nAolzOk1FZqE+ImIBHKn2yHZYHAW58+h/YsVSmedUUuJj0AKUCYrRBiUolGpvqay1Isyhu6d15VuPwO7f9n8mTDZ9//6sPOVd0ZmILLHs4VML0dmmHQrubCrqvHnuhKmA0Iy0PwU2w9I/fs9aRvleMTq6NR0hNR5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 20, 2026 at 07:57:15PM +0300, Mike Rapoport wrote:
> > The current KHO page preservation APIs (e.g. kho_preserve_pages) assume
> > that multi-page blocks are split into independent 4KB pages during
> > restoration. This is incompatible with high-order non-compound pages,
> > such as DMA buffers, which must be restored with tail pages having a
> > zero reference count.
> > 
> > Introduce explicit preserve and restore APIs for unsplit pages,
> 
>                                  high-order non-compound ^
> 

Ack, will update the commit msg.

> > which preserve and restore a high-order page block as a single unit,
> > applying a refcount of 1 to the head page while leaving tail pages at 0.
> > Rename the existing internal helper to __kho_restore_page().
> > 
> > Signed-off-by: Pranjal Shrivastava <praan@google.com>
> >
> > diff --git a/include/linux/kexec_handover.h b/include/linux/kexec_handover.h
> > index 8968c56d2d73e..6e2c75b16209c 100644
> > --- a/include/linux/kexec_handover.h
> > +++ b/include/linux/kexec_handover.h
> > @@ -22,6 +22,8 @@ bool is_kho_boot(void);
> >  

[...]

> > +struct page *kho_restore_page(phys_addr_t phys)
> > +{
> > +	struct page *page = pfn_to_online_page(PHYS_PFN(phys));
> > +	unsigned long nr_pages;
> > +	union kho_page_info info;
> > +
> > +	if (!page)
> > +		return NULL;
> > +
> > +	info.page_private = page->private;
> > +	if (WARN_ON_ONCE(info.magic != KHO_PAGE_MAGIC))
> > +		return NULL;
> > +
> > +	nr_pages = (1UL << info.order);
> > +	page->private = 0;
> > +
> > +	kho_init_unsplit_pages(page, info.order);
> > +	adjust_managed_page_count(page, nr_pages);
> > +
> > +	return page;
> 
> Hmm, it copies a lot from __kho_init_page().
> We should keep the common part of order-0 page/folio/high-order page
> initialization in a single place.
> 

Alright, I'll break out a helper.

Thanks,
Praan

