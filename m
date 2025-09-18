Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EBD32CAC59F
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 01:31:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D3DA8E0096; Wed, 17 Sep 2025 21:31:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2AB5A8E006B; Wed, 17 Sep 2025 21:31:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C1018E0096; Wed, 17 Sep 2025 21:31:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0B5DD8E006B
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 21:31:37 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A78F587453
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 01:31:36 +0000 (UTC)
X-FDA: 83900643792.13.E7263F4
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	by imf09.hostedemail.com (Postfix) with ESMTP id AFF50140007
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 01:31:34 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=UEj3bqXQ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of alexjlzheng@gmail.com designates 209.85.215.180 as permitted sender) smtp.mailfrom=alexjlzheng@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758159094; a=rsa-sha256;
	cv=none;
	b=TM6fEHYZKgvcFHs6OfB8Rv8ziZEPUsrxXmhF3DU2j79tKvTe6pv7axT+WiY/9WnwypZFW/
	l7MyRbCRirLwjAv+jWUqDLw/rMo7md+4nuTRBVGCChP1g+735wmE87vrDesmnRsO/aLL/W
	Tom9cLGvfea0Tq1BuGw63Ed4ZLDT2YA=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=UEj3bqXQ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of alexjlzheng@gmail.com designates 209.85.215.180 as permitted sender) smtp.mailfrom=alexjlzheng@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758159094;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eGu6jUV2+RT3PgqHH5oCw8Nh03q6VX9mmcyZQjqvWaA=;
	b=kXidlu0s5fzpuDsWbI+9Xry9R7myxsmG7ZeWUaBTbMFeC/LdSwNHDDqxFB9U/zHQxN8d6P
	7QQmax8aNDNdVE4vQUhMtdPQ+iCGEpG0UNWdJWkvjq7guiiYWBsJSFyEq7hJoSXDv02xfw
	rf7b04TpxVrFrovMWvsZBIvV1RJS3QY=
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-b54fa8a371fso255371a12.1
        for <linux-mm@kvack.org>; Wed, 17 Sep 2025 18:31:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758159093; x=1758763893; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eGu6jUV2+RT3PgqHH5oCw8Nh03q6VX9mmcyZQjqvWaA=;
        b=UEj3bqXQL5bs8Uwgv1xX7rESpPxJi5a7uqYxKrZV2yB/4o9uOAG1dxgEfU0eLPfFxu
         FDvfm+sWBnOS9KAEsa0FXIv8l28n7UVCL7K2dzImLNCZc0RSxqFBSLi42oFlkQznYK20
         XDJKjqz1MhTns0l/WexqB9YRY5ELuCVQl1FevLojpY9PypzYk+h99pFIu+sQuX9scXI+
         J2N0ZxSgZz4rTEAa9iZsoQZayv4WOqGIyNQOXtJ4vk9a4sj64uWSTWVPNqAnrdSiajn9
         qo3GWrF+C3OddKHqBPuMzIfIIxVRfzyP/IGWmhbIESSOOKEEGHxry3PHjM07ObJ8FZmQ
         BZmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758159093; x=1758763893;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eGu6jUV2+RT3PgqHH5oCw8Nh03q6VX9mmcyZQjqvWaA=;
        b=mFR1mewX5l3nOnzMnyEB4hQfvdPKUfGW6F552/wcx6PlqUzPXhVkLAI5Yx/+SDlBL3
         F4TkqNtLQWiNL5dessoDvnCOMFJQLmu4jWNvYA99aJOWX7hC0r5CSGsFFsRA9odEep9G
         dchqvxQzMbtnhtGiLpxb6nIzUbvbe8lTZp2JmsT0NMgC6tMSoysjPKERL5t/1W1KELVs
         eUFabOGEMJUIlE/BaB43hYx63SD7Rq5gaN8B6p7UO5kjYtzmt5pzBiazDsUf0usqreuJ
         WE4Y7InKs4gJIixnL93y02HjgsTD+lFH4ZT56rRgpGlAJPhmkv8n/kUxzWJZFJAMrBb+
         3JNw==
X-Forwarded-Encrypted: i=1; AJvYcCWQgstdHqX0NCRItAZNS6R7wtJf0p+BQOTB9yyfBEXO9kNVRqQbspPEEKkW786XZL25pThhsAfR6A==@kvack.org
X-Gm-Message-State: AOJu0Ywm0XIwpTPQ8A+YaszuHAoieuIGW4UqVQsLrt5063TGYKTQ9QSf
	cQRYb1viBnjA9pKJVCB0YdObdMkGH2GPVlVjsYADZbIE3Gs25RaqK0QE
X-Gm-Gg: ASbGncvZTI2jIri/ZMQxbcyaNMPjospqHGj0DGfYek+Vahoc0RLNLPh0BNq5H6l7Bnc
	MjEYtdeMgvbqvxoDvmOULM+DtSzwkdUPf8zaSLyMHREP/nr/VOgOF3E/Z/cjS1JNJ+bEBCEEhj3
	BYYrDuSoAghiKgQd9iNuOhpqtoGqKP6JrLcUkieo9ROB39Rri2SJeAQ02+AF1G8OGpV5nO+AZ2A
	6uRRCPWjgPkh3P3M9yQmEAYSWTAupvRSoH2KZNJaBEfCN0ov9W17G7gTkK/MVCVIe62jicTAo4g
	oMB/O7QjIk79ImlbiWqOvvRzxC/9ixFwYQYlrMNUGVfaxAW7Ci/1yBeXCupQBWAWaBm5CFK+OcW
	JEqVbe/AA1uSj99axvXyTwp0rxwpYdnnX+GPiD6KXDGN9ijqwjHhS8Se0f7PfOjQ=
X-Google-Smtp-Source: AGHT+IGyol2ICo5LkwOJQM5YrI/z89CMfK7noN15fH9mKTb1oN4Xwj7kuK4ucc0oFR/zcNay6QAzWQ==
X-Received: by 2002:a17:903:2307:b0:248:7018:c739 with SMTP id d9443c01a7336-268139031a0mr60323995ad.28.1758159093380;
        Wed, 17 Sep 2025 18:31:33 -0700 (PDT)
Received: from VM-16-24-fedora.. ([43.153.32.141])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-269803184d3sm7860915ad.116.2025.09.17.18.31.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Sep 2025 18:31:32 -0700 (PDT)
From: Jinliang Zheng <alexjlzheng@gmail.com>
X-Google-Original-From: Jinliang Zheng <alexjlzheng@tencent.com>
To: harry.yoo@oracle.com
Cc: Liam.Howlett@oracle.com,
	akpm@linux-foundation.org,
	alexjlzheng@gmail.com,
	alexjlzheng@tencent.com,
	arnd@arndb.de,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	david@redhat.com,
	geert@linux-m68k.org,
	hpa@zytor.com,
	joro@8bytes.org,
	jroedel@suse.de,
	kas@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux@armlinux.org.uk,
	lorenzo.stoakes@oracle.com,
	mhocko@suse.com,
	mingo@redhat.com,
	rppt@kernel.org,
	surenb@google.com,
	tglx@linutronix.de,
	thuth@redhat.com,
	urezki@gmail.com,
	vbabka@suse.cz,
	vincenzo.frascino@arm.com,
	x86@kernel.org
Subject: Re: [PATCH] mm: introduce ARCH_PAGE_TABLE_SYNC_MASK_VMALLOC to sync kernel mapping conditionally
Date: Thu, 18 Sep 2025 09:31:30 +0800
Message-ID: <20250918013130.2425537-1-alexjlzheng@tencent.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <aMrkoBhIcP37YgyS@hyeyoo>
References: <aMrkoBhIcP37YgyS@hyeyoo>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: AFF50140007
X-Stat-Signature: sc7eydpetpunxjifn53if7jbhpjyqxji
X-Rspam-User: 
X-HE-Tag: 1758159094-397270
X-HE-Meta: U2FsdGVkX1/jEocgQOeZhwTN6LeGcfXUCV3Jn++GQh2THUvUaw6dChLXN98b6lMYUt8hYU8mkAERwv9xzQJG6FXxFobIclQAGBDtweKSfIS4FXiqBJmCL33xBgAsgQHBaZOiOx+NePnl3oHJV8Nr+v2sR4YLJloK9/8VmxiotaQ8kp0zWzhULw/cOpLLBeL1IsmBriehpkE/d9MLpLnzpe3+ksrMUjMl340baJQN+LthqCO2duwLcD+qciQzWNXi4EKDYohxClQkPOQHtfpOaVmPW+M8wy8SSrng+YykceUQT0IzFPc6OtIXM7dyPfXONB6r9hNDRs4hVWVlorwGBvy1V5dgHKdAYhj+QNK+LZOShdz9pLzDxC0NjJxqeuupbTZmn3GotTMG8k2BNGSzg14jiMvloM9/agfVJ2UtDIRvfFtDTeBt0vwaqhH2PYQegvF7/C/cevm8EhQw0X4844cSBCAUptCTsi9vzpCASHLLDKUtaTDnYHedHTALIxs7osfy+to3ZRzV1ET8iGFI+7JJHMxT2wtLmkPhVF4uT1PKIUvd0rJIbIGKHKm8HaHGoCLsKgNXE2IAbWDL6lV37OrTyd5LmzjhdptopKlt/sY9h4pCAcbPxtNEWNUPYSI0MxJ+d/Svj6jOnEsQI33Q9FKc0Xl1Y527rokw1jmor17AtDKcqlXy6S1737q/zdujUdLrdkTO1y1heOQArRv360JjMquKsmKMxpqQa40dOfvh9qshUV5dedy5hVagAfgRv7IUVwOL+QTd1czDmjPnZDfidWPCZU0VUGfzzI1I/LhFqL4CkL8xR19BPB2+ukbQwzEKJ30Vkjw1HtCjOWc+ePlO5uyhvXPQfzajS+pXUUd7VRY+7ny+g3hVk0kxSTtAVmb0cNRWMSOmjTOTuSsjVJQk5pG7Pp0EGmneHquGn6WI7eKZboT4WZjvnNVgUZk1zrC5+5gvKWISatMpKZS
 9u4jvvP5
 ib43jAILSiRPMpEId91ke7i0w3J5qKPj3C8ar4KJINiByi7wU1Dx6sJpVB67J+6lYL/tQOnW21Plijs8VGIK2cdf5ft+5FsGu/HPAgwQ9tW6PyqQpAkK4bg+PN0FvWNvzs8sjcpkg9Vcn+jt48LXnV8qntc98jg0PBkPtr1t4iE3lJrHl4vbW2obC1lM0YDEDEBGfaLqxYNQubaLcKbK8skG0/3tpNVwtzMTlwAs4YIHKXqTvqQn7ImeTzRDUoz8ATWTjkqt4pOHJIHWcVgrJY4qPrio65rz8pb85uJJc1ZKE6RzKSZdtrHuv1UA5JsEC5jgbSHEIU8bXxuiA527GSVcHpncLhSEUSUQmr0dwD7NRJu21KoYofLT8W60UIWTk/GgNS4RcTK04pLpE5bruwWwxR+R3TmrwiBbGThT8MBzjNvvbaAq7QbahGiiGJeXwMK/8/Bw7VqhI1z8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 18 Sep 2025 01:41:04 +0900, harry.yoo@oracle.com wrote:
> On Wed, Sep 17, 2025 at 11:48:29PM +0800, alexjlzheng@gmail.com wrote:
> > From: Jinliang Zheng <alexjlzheng@tencent.com>
> > 
> > After commit 6eb82f994026 ("x86/mm: Pre-allocate P4D/PUD pages for
> > vmalloc area"), we don't need to synchronize kernel mappings in the
> > vmalloc area on x86_64.
> 
> Right.
> 
> > And commit 58a18fe95e83 ("x86/mm/64: Do not sync vmalloc/ioremap
> > mappings") actually does this.
> 
> Right.
> 
> > But commit 6659d0279980 ("x86/mm/64: define ARCH_PAGE_TABLE_SYNC_MASK
> > and arch_sync_kernel_mappings()") breaks this.
> 
> Good point.
> 
> > This patch introduces ARCH_PAGE_TABLE_SYNC_MASK_VMALLOC to avoid
> > unnecessary kernel mappings synchronization of the vmalloc area.
> > 
> > Fixes: 6659d0279980 ("x86/mm/64: define ARCH_PAGE_TABLE_SYNC_MASK and arch_sync_kernel_mappings()")
> 
> The commit is getting backported to -stable kernels.
> 
> Do you think this can cause a visible performance regression from
> user point of view, or it's just a nice optimization to have?
> (and any data to support?)

Haha, when I woke up in bed this morning, I suddenly realized that I
might have pushed a worthless patch and wasted everyone's precious time.

Sorry for that. :-(

After commit 6eb82f994026 ("x86/mm: Pre-allocate P4D/PUD pages for vmalloc area"),
pgd_alloc_track()/p4d_alloc_track() in vmalloc() and apply_to_range() may should
always return a mask that does not contain PGTBL_PGD_MODIFIED (5 level pgtable)
or PGTBL_P4D_MODIFIED (4 level pgtable), thereby bypassing the call to
arch_sync_kernel_mappings(). Right?

thanks,
Jinliang Zheng. :)

> 
> > Signed-off-by: Jinliang Zheng <alexjlzheng@tencent.com>
> > ---
> >  arch/arm/include/asm/page.h                 | 3 ++-
> >  arch/x86/include/asm/pgtable-2level_types.h | 3 ++-
> >  arch/x86/include/asm/pgtable-3level_types.h | 3 ++-
> >  include/linux/pgtable.h                     | 4 ++++
> >  mm/memory.c                                 | 2 +-
> >  mm/vmalloc.c                                | 6 +++---
> >  6 files changed, 14 insertions(+), 7 deletions(-)
> > 
> > diff --git a/mm/memory.c b/mm/memory.c
> > index 0ba4f6b71847..cd2488043f8f 100644
> > --- a/mm/memory.c
> > +++ b/mm/memory.c
> > @@ -3170,7 +3170,7 @@ static int __apply_to_page_range(struct mm_struct *mm, unsigned long addr,
> >  			break;
> >  	} while (pgd++, addr = next, addr != end);
> >  
> > -	if (mask & ARCH_PAGE_TABLE_SYNC_MASK)
> > +	if (mask & ARCH_PAGE_TABLE_SYNC_MASK_VMALLOC)
> >  		arch_sync_kernel_mappings(start, start + size);
> 
> But vmalloc is not the only user of apply_to_page_range()?
> 
> -- 
> Cheers,
> Harry / Hyeonggon

