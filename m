Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE432CD8C9D
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 02:23:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B2A986B0005; Mon,  8 Jun 2026 22:23:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B07DB6B0088; Mon,  8 Jun 2026 22:23:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A18076B008A; Mon,  8 Jun 2026 22:23:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 930186B0005
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 22:23:35 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 934A5A01F5
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 02:23:32 +0000 (UTC)
X-FDA: 84858777864.21.7E1C23A
Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	by imf24.hostedemail.com (Postfix) with ESMTP id AFC8C180006
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 02:23:30 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Hx6QptNJ;
	spf=pass (imf24.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.53 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780971810;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g1sg1EhG9c0ZhlRBhQ86dEr/peU6rOT1SETxtf5KI1s=;
	b=aqDp1FshcGm8WbvHD4JM0aOrMRaQitbBv5sXdy5VHRs9FKMMEV5MTL50+8g4z5uQNU/p6i
	EbVD0dJAGi4U/sQepOxUfn0ka78Tm/MCo/0dfiiXwmC4P5SxEQPMMVWfWXeHVRfsG90SIt
	9UVIb4DC9ljiwyNvWp4bnEIrBcSqK4A=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780971810;
	b=oS5CXl8xsopSKRztqzmiNikLenLgQe5pNRXon2k+mDRgQ6QTSy8SODIlGT82ZlSu9YzOmC
	Y5WDrSU2b6Es39qaLDUvkQm2k0jY1vLMP3FL7wRvf0W3/hmRIHi3AEGTMVGxG3VxmY6mjQ
	4uwnn6EujXoPdi1F8WO9mJsv8rIIAUI=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Hx6QptNJ;
	spf=pass (imf24.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.53 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-8cceaa6f75bso77169636d6.0
        for <linux-mm@kvack.org>; Mon, 08 Jun 2026 19:23:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1780971810; x=1781576610; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=g1sg1EhG9c0ZhlRBhQ86dEr/peU6rOT1SETxtf5KI1s=;
        b=Hx6QptNJ2K/4JxsY9e3bs4/7DoUaiHIxhmyXY2soRRK0s8p9bBe2bWva5xbqYDFdFa
         C+S3UqI2/JybaHCUDPZFNvz30U9CL7FcHW99xdSgi7DKzKwO31+Mkv2FZsVETwuWmWjx
         ppwiXt+UnJfO/RXIxGy/NfB4Xyl4THFImdKVJm6iVDxpoBlkR0V64X6pqpxyhNFWum9h
         QC4k+vAY6qa5HuJEzJ6AerQD0ZWPAcO91zH+Y1mCfpmsjlOyyC9liE2Y+NB8+lCAK7vH
         bEIqMRWXrbli1M67v5K9fsmH0XBgrp3t4YxvtMSliC0VD6Zfd+8n04FKom97C8y1sRt7
         KKIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780971810; x=1781576610;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=g1sg1EhG9c0ZhlRBhQ86dEr/peU6rOT1SETxtf5KI1s=;
        b=qWi7jiKZuCN6Jzy/OrvO8mCG2NX0H++9G4uiLEAssLwTCElNFRG6tE6hr1cHdeOcvJ
         HXi4YMocpGz+UI1rX4tFBEWFq00e4xY5V8G42SI+2E4JdU9p52iXR6RbbAbW9Lgui5sj
         12cpRgCJe3DnMPAzarMCrlLZvXe9U2llLBpRzFBnYqo2vaYzs4Z7Mm03Nyynk5r9/t9I
         fCQu+f7OfOjGt3jIXMsDAYBBBwl5qBOTC+wVN2VDBsDvdk7R8JYa0HMxd1IJPoYjwVsK
         KQGzAgomYMDhDC0JgYqBZlvfKUmeEpYNgD4SU0DSI5EPb8/7ckXDz3/vkkPyfsyeHh7m
         ipbA==
X-Forwarded-Encrypted: i=1; AFNElJ/+rDORjQNYabwRddd6MlclldRLkunIueK+u0D7NpvEWOGuSkQp+Dez2dT/dW5YSe3D/1EBL35fuA==@kvack.org
X-Gm-Message-State: AOJu0YwHwXNNMLmgOSg14HczNY53N1EenaJGq3UGj6ULMC3ZJJs1YT8X
	3XiTtObxkV3fX/slJtMEAcleRo6hyolKUPzcNoJKX7e0A+FzhwTnPIUk9izkryxzYo0=
X-Gm-Gg: Acq92OF2gG4mUj9sxnh2OXglljiLEuAp3BiR7Soq8SbWmjtLj1/k/3P1xJUXdYP9N/7
	Lzp2XHxSTx8c0KCTJwyVZxDe9Tx2tBBc8x+lW+YuDzQXe0+JG+pcw9Ys7fd1DhvtGgX2aBif3gt
	OZlF5BoyaPTZxUJxEiYniGpb29zptgFRwylCkAsAQGfixPbMRB66WFWoUdYBbl3OSLR+0A3b7Ne
	6NMHUdoiB9/aQQwPNDNRE0zvXJiLsKHsmq/w6TVPqP0nYcECtyzR+CT9D51nN9WguwuHkYYhm3p
	4otcZ2bFYhbw6lbspOnjpcm1put4HQubawpsyXlbsbd6oXzaaZNa/yT+/1ZjcfzTVwxybhAn3UX
	Vbi8pQV7VXazmRGj8dsty/VUpJq/jlZr8jWfsyzx3Hdy9JepL3AyiiXYXqbkOLDBaGg5q/RRfF6
	uRXxjxa84GnOC8bJCFBT/3ZysiQxELqkzWDmMVo/ehcGMX4ntczCja0H6Paqxk6w==
X-Received: by 2002:a05:6214:1c0b:b0:8ba:2c02:f9d6 with SMTP id 6a1803df08f44-8cee625c052mr320889586d6.35.1780971809622;
        Mon, 08 Jun 2026 19:23:29 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8cecd263003sm188126846d6.42.2026.06.08.19.23.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2026 19:23:29 -0700 (PDT)
Date: Tue, 9 Jun 2026 02:23:28 +0000
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andrey Smirnov <andrey.smirnov@siderolabs.com>, 
	pasha.tatashin@soleen.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-riscv@lists.infradead.org, pjw@kernel.org, palmer@dabbelt.com, aou@eecs.berkeley.edu, 
	alex@ghiti.fr, syzbot+2b5fe617654be3d8848b@syzkaller.appspotmail.com, 
	Thomas Gleixner <tglx@linutronix.de>, 
	Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>, Andrei Vagin <avagin@gmail.com>, 
	Andy Lutomirski <luto@kernel.org>, Vincenzo Frascino <vincenzo.frascino@arm.com>, 
	stable@vger.kernel.org
Subject: Re: [PATCH] mm/page_table_check: do not track special (PFN-mapped)
 PTEs
Message-ID: <aid4yw9WRvZEm2BV@plex>
References: <20260608155758.1220420-1-andrey.smirnov@siderolabs.com>
 <20260608142258.5028187b1d245b46554eb2dc@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260608142258.5028187b1d245b46554eb2dc@linux-foundation.org>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: AFC8C180006
X-Stat-Signature: onhuwfq4kucbm8tcdgwrufuas6s1yx5c
X-HE-Tag: 1780971810-367723
X-HE-Meta: U2FsdGVkX1/fxi/SeZCjTkKuCaurH8F1Ir3rIB/mJ5xxTcZFB6819PAjdQvOowQtE3E2l7JEJBE25XNpuYjSGjCtrpchrgbttOumoXljs/mRnxwzAmA+pGsGHglqonVSgl6PC4+RFe84Yl9Ex0Sd6xtY1kADizn4wYUgTFWbz5LRLJwbSrfrjC0qYkM9S7DzHPhoBzeag+AjSPyLAtD4+q5nA8jrr3OsSJPj2d/bfcxrJROW7bHu+/uZT4H3IhNYyIaGR/JXS0ENbpiGGxPHM955406HknneuLEcKTor+UerTBnLGKvRHuqD+Ui6Nr8hUCmeLlIpQ/Q5wSjJII4D8AMwjGTnP+ba1XBq4iDjh7Yp1KCk6HKntZYAurrzMjJDKmFjgg0K5ueOlFo32/Z8v4NFCwQc4kUAG/SaunE9pEtHtffDEhFk3MF2ZwxhpH3kJ6lB3Wl+BEXR1N1BWVA3tKI30jDD8Uufg82Rizl31t14iqHSA64Y1qVHuT3KY8QMkcG98UJ3U7MzuAb8lfeHeeZSi4J3shfyeMBFtxgNfmwN0r9QR3tKmihhUy11VA6RyFp2lwAB9AVFOVFkLPqSv66cvR2EJvXXZyffNWooKVHXIGEvYpvZQo7AK3UR4j9e72oIGnVu0DeVVOkyQxE4L+C4WCdG+wTrn2PZsV0fs/dhogvzO+u5PFsMbtDdq0lT+rTdvJpRQlSRftVuK3h7ap+ty2YEZl7ssFjR8OZ8q1w4DG3FjWsMgbeB0+KvuI6oKL47wqFrKEsGbDc3rZspww6GoHQD3Q1IzFajcbgZyhFvQ24OC/aAadSfSYIXrQPRVSsQaLegoHpEqfuw0UjfRDcYziVhEBQL8U0TVs6Mitni/GYqsTwNq/NT1hjDGvnSQ5FrLvcnHzW4OXgcTbumrWtCvxESBik5TuVURZ8ZaaSmoDYwlT43/nCplOUMsLPoraEXZzVkK3G7zXT3KmD
 oJU/Xjfv
 caWyAyQZowhHrtWwv7YwbCdLFZnnX06IzE6Rl/inYVua+b+YJfCY4MUYDGong24lodZLTZiovo6Moc9oGIbVqjy8YnMeOg58leKnpHlSAwaMzzPG4rTpq+t/IFePL+XSa77T6+UCfCltZdGdDAfvNq7pa/LG6uicD1B0vr0AWy34X48fAiHnJtizh/TmK7MOXehi8bcQGLRlPA82c9KtGzislmMmIaYxw6o6c8B50wwMgnK8H5dw2XuoDykk10tDLNhmVW/abligx1ktk6y9T1c+Xl3nNmX+jMhorKK71eiuDuus8I5UbmUFCDBg9zB391EYjI/xfRfQCSvSP2J9zhACLM+RMPWgj8GR6/TkAftgE4+0nXBUWqaFhv7UyNfPjy05QfU50dQxc2VDnHUA0rQh3DMpozChv7307B/8fZdNHm+nxr5LEh4T8y/KN1KNyLmTnL1anC2lsM72NoYw2pdWrDeswbdo82kX6gyJdfAzYlTQpCegkC84wV/yVkZx7yMWiCqeEB/OyNARkHm05S1pulD1twVWavCnZnB/hPQKjHxM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 06-08 14:22, Andrew Morton wrote:
> On Mon,  8 Jun 2026 19:57:58 +0400 Andrey Smirnov <andrey.smirnov@siderolabs.com> wrote:
> 
> > The vDSO data store ("[vvar]") special mapping is created as a VM_PFNMAP
> > mapping and its pages are installed into userspace with vmf_insert_pfn(),
> > which produces special PTEs (pte_special()). On x86 and arm64 (and riscv)
> > pte_user_accessible_page() only tests the PRESENT/USER bits and does not
> > exclude special PTEs, so page_table_check accounts these PFN mappings in
> > the per-page anon/file map counters even though they are not rmap-managed
> > pages (vm_normal_page() returns NULL for them).
> > 
> > Most of these data pages live in the kernel image and are never freed, so
> > the stray accounting is invisible. The time-namespace VVAR page is the
> > exception: it is a real alloc_page() page that is released with
> > __free_page() in free_time_ns() when the last task of a time namespace
> > exits. Across the map / unmap / vdso_join_timens() zap transitions the
> > special-PTE accounting is not balanced for this page, so a non-zero
> > file_map_count survives to the free path and trips:
> > 
> >   kernel BUG at mm/page_table_check.c:143!
> >   __page_table_check_zero+0xfb/0x130
> >   __free_frozen_pages+0x52f/0x650
> >   free_time_ns+0x85/0xc0
> >   free_nsproxy+0x7f/0x130
> >   do_exit+0x313/0xa60
> >   do_group_exit+0x77/0x90
> > 
> > This is reliably reproducible on x86_64 and arm64 under heavy container/CI
> > churn that rapidly creates and destroys time namespaces (CLONE_NEWTIME via
> > runc / docker-init / tini), and was independently reported by syzbot on
> > riscv. It only manifests when CONFIG_PAGE_TABLE_CHECK is active.
> > 
> > Special PTEs have no struct-page rmap semantics and must never have been
> > tracked by page table check. Skip them in both the set and clear paths so
> > the counters stay balanced (always zero) for PFN-mapped pages, regardless
> > of how the architecture defines pte_user_accessible_page(). pte_special()
> > is available generically (it is a no-op returning false on architectures
> > without ARCH_HAS_PTE_SPECIAL), so this is a single, arch-independent fix.
> > 
> > Note that the v7.0 generic vDSO datastore rework in commit 05988dba1179
> > ("vdso/datastore: Allocate data pages dynamically") incidentally avoids
> > the problem by switching the mapping to VM_MIXEDMAP + vmf_insert_page()
> > with balanced struct-page accounting. This patch fixes the still-affected
> > VM_PFNMAP path used by 6.18.y and earlier, and additionally makes
> > page_table_check robust against any future PFN-mapped user pages.

Thank you for detailed explanation of the bug, and it makes sense to me.

> Thanks.
> 
> The patch isn't applicable to current -linus mainline.  I reworked it
> as below, then deleted it.  It would be better if this rework came from
> yourself (tested), please.  And a patch which applies will get checked
> by Sashiko AI review.

+1.

Pasha

> --- a/mm/page_table_check.c~mm-page_table_check-do-not-track-special-pfn-mapped-ptes
> +++ a/mm/page_table_check.c
> @@ -151,7 +151,15 @@ void __page_table_check_pte_clear(struct
>  	if (&init_mm == mm)
>  		return;
>  
> -	if (pte_user_accessible_page(mm, addr, pte))
> +	/*
> +	 * PFN-mapped (special) PTEs - e.g. the vDSO/time-namespace "[vvar]"
> +	 * mapping installed via vmf_insert_pfn() - are not rmap-managed and
> +	 * must not be tracked here. Tracking them can leave a non-zero map
> +	 * count on a struct page that is later freed (the time namespace VVAR
> +	 * page in free_time_ns()), tripping the BUG_ON() in
> +	 * __page_table_check_zero().
> +	 */
> +	if (pte_user_accessible_page(mm, addr, pte) && !pte_special(pte))
>  		page_table_check_clear(pte_pfn(pte), PAGE_SIZE >> PAGE_SHIFT);
>  }
>  EXPORT_SYMBOL(__page_table_check_pte_clear);
> @@ -208,7 +216,7 @@ void __page_table_check_ptes_set(struct
>  
>  	for (i = 0; i < nr; i++)
>  		__page_table_check_pte_clear(mm, addr + PAGE_SIZE * i, ptep_get(ptep + i));
> -	if (pte_user_accessible_page(mm, addr, pte))
> +	if (pte_user_accessible_page(mm, addr, pte) && !pte_special(pte))
>  		page_table_check_set(pte_pfn(pte), nr, pte_write(pte));
>  }
>  EXPORT_SYMBOL(__page_table_check_ptes_set);
> _
> 

