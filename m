Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 190AAD172CE
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 05:27:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 34EF06B0088; Mon,  2 Feb 2026 00:27:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 330CA6B0089; Mon,  2 Feb 2026 00:27:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 232FB6B008A; Mon,  2 Feb 2026 00:27:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 109476B0088
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 00:27:18 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 32179C3272
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 05:27:17 +0000 (UTC)
X-FDA: 84398383314.10.A87A797
Received: from mail-ot1-f44.google.com (mail-ot1-f44.google.com [209.85.210.44])
	by imf05.hostedemail.com (Postfix) with ESMTP id 46876100006
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 05:27:15 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cJfrZWAC;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf05.hostedemail.com: domain of mikhail.v.gavrilov@gmail.com designates 209.85.210.44 as permitted sender) smtp.mailfrom=mikhail.v.gavrilov@gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770010035; a=rsa-sha256;
	cv=pass;
	b=sb3aWxj7oRnTC8BDyzAlShVeVQ1TB9Pwq9MThVEn5YgFDCR6DShO15dofrmnXaydSZc8Ox
	UmV2hCaeY948xv9Ji/Ezwk+auwldylMJAr/4zgk5fF6qK5KV7wyp1FAcgaBng919V5u9Bm
	YG4O1Ph8XfUQW07YN1alvC4GCRHTerQ=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cJfrZWAC;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf05.hostedemail.com: domain of mikhail.v.gavrilov@gmail.com designates 209.85.210.44 as permitted sender) smtp.mailfrom=mikhail.v.gavrilov@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770010035;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7O/N7N4GZMpCmYBv7lEJS5v07h6xVIxHuuBSM9FL7nA=;
	b=sBlyOu5dTfDL2GlZwwpGXfJaiKKUrO05o0FsLt+SoyIMOwNrbo0u397BdTszAgP+wGuQOl
	aokS9WfjqTSLQ+KHLHSI6h1jbYxXWWIwcsG1tzyRBobaEOUOQ3QEya1sx3e0hwk/w3wFRE
	ySBW2NgQG2G0RyOnH7M1cHxEw0m0CKY=
Received: by mail-ot1-f44.google.com with SMTP id 46e09a7af769-7cfccba483eso1419452a34.0
        for <linux-mm@kvack.org>; Sun, 01 Feb 2026 21:27:15 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770010034; cv=none;
        d=google.com; s=arc-20240605;
        b=jl/Cjz7QyqvG/m/Etfd5vpabVE4nyKldHI9sA9l3+Ln2jTYBtz4Ny7D367IR9fnIoI
         0Q3VwC4f3iypI9/n7S0aAC4hNWvqqW7eanWhaqpBLo4Nhe97Ii1oXz9bN8IifLnuFqW6
         vnpck27kJwnOAQDkKF42SJ0WsNVm/DJS02RUoXa/lw4pYuQRPsNb0dZogmql04ZRLml5
         hAzZAULHCe/++FFiBQd+iyI/2HFhX03kns/ABVfEUCzu+vEJLDPmuPI+frVEy/bOFr7P
         dZQxwaTJx926deim2BpR8ZrHusVta4zVKU1BOzG+c5ZtGNcj7esvGTYx3GJ+3CBs5BFx
         2vWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=7O/N7N4GZMpCmYBv7lEJS5v07h6xVIxHuuBSM9FL7nA=;
        fh=tbeQlM8hLPIR0hT3CckfjQxRq1i4wHTdIY5Cq+hVZj8=;
        b=JE1VC1hEoYioTUhYZABf9seL72+80xO2Ssw22nzj/nphrhDkPIYpDbhbhsH5BwPfT3
         jmkwAIEt2LCTREeKWPnBa25XxJArMW7emLGeMCqX5PEJhQUydoa+2oYNhWeg/Z3aAc0F
         vH3N/ZzsQH1X9xyyl92Xo/SDJR0iBO/Of47VIZRFX83SF8bmxiBp0Bd7EF9qobXH7tUm
         JEN/eOxkVSIYQBUpXVH0j1ixiVnWjGRLDWOVYmZLUCh4Je1maeVLrl937b87EDl0VLM+
         edBQBB/0r0OwbeaJ9amLXthY3vrotsm/4hVu/65HeVrbqplptu5g9aFUf3VXa7FsVE0e
         Ph2w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770010034; x=1770614834; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7O/N7N4GZMpCmYBv7lEJS5v07h6xVIxHuuBSM9FL7nA=;
        b=cJfrZWACcmUpt7/844uV8se7KNY5SzG2eqiHYd8ar5NTkuBojwvse2aoru5K53xsHk
         qbmgGuV+4Ri0AEiJAnoP/l/EfwrDq+c0dRkylheRdhaqxU74oj5qP0Cjx8XAhoyx6e4s
         qE8rdS+hdOeQB2P95XKK+R9Q6hj+w4b/67b5hSzZ1+hX+iYeFKQzKoYpRTTm3P5TtmI6
         hHqqE0ab8VZjD+anFH3xv6YRmn5sgkLqp6fHLPG/qteVCLjF0Yl0HAS7RPW1QRFfoJ+u
         6DQD2fr1zwGzR3qhvi+eUHrRrUC1gj3kEC9lxrERCYASdlv8weadR7TLZNnvOFr2p6VZ
         UyCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770010034; x=1770614834;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7O/N7N4GZMpCmYBv7lEJS5v07h6xVIxHuuBSM9FL7nA=;
        b=HVPTqmOu6IMOqi1rDayJ1x/Msu1OFsx2RblvWwwijMg2CzU9Ubivzc37VSNd+KDjt5
         EidPWSAAq8edu1LAPUriflNHxRRVACVYlIDH3wkWDCtPChmQg7tKev1hXl3kYaW6Zhea
         eY6CDxiSurFtZ5zauWlxm7lU6mZFxykdGVNbvapRkcEMaGJbgN+YVV84YUmmEJZAO5VU
         iGsUobPSDmtX9o9EL5JbbV/EK3jGXUT4wq39eiHKMIGF3r/lKy0+wdKvBBr+msOeDrE6
         TTUhrkRndLFj4Z8Y9OrSr6h6MR3z5uXF9BC16TBzK86X9X8YnAr76c+1wU6QFTl/gEqb
         6oaw==
X-Gm-Message-State: AOJu0Ywah9LbSqn21VGPQsyj52X8gDaH7hmJwGhJLsHVZFZ/+mHCwzzj
	85/9U/DkHAIzL0AwKq7rUcPd9IsJXiEoZrfZUU+/Vhf17Cq8fcQqjEGn1O8BHPmbDISc1VtB2ub
	KW/hQ2pahWcFdtxzR9VRir1TjC5+aqxk=
X-Gm-Gg: AZuq6aKOIpF388ARObTrT0ri7pPPoKeiVwAx+lsF1jT5X+dR8RFw2dkH/qep4iCgqic
	ZyZQb26LSvFabR4kcoPMUBQRPIvEAmEu4Vthl9hxkyydprnw19E7XUr4FPRyOO6Gp24Wmo0ZoNM
	1AGNon5//J+2hUxz8ouGor8p4IXodYznck2SPlGB7IsgwXDaG00juqZPdIhfVYtPp4KNDOgQOFm
	ikks8rrcE9eHT0dPSB6UTtazyc9G5zsC/cEINSdnroWs6xlbxUs0LZkv74lKvCipbqsgJwGMA==
X-Received: by 2002:a05:6830:dc6:b0:7ab:e111:1a57 with SMTP id
 46e09a7af769-7d1a531e462mr5552851a34.31.1770010034176; Sun, 01 Feb 2026
 21:27:14 -0800 (PST)
MIME-Version: 1.0
References: <CABXGCsNqk6pOkocJ0ctcHssCvke2kqhzoR2BGf_Hh1hWPZATuA@mail.gmail.com>
 <CAMgjq7BM0QFvk3_D4qyggjJ4W_+nHAupQnpAYehGq50CYNJV7w@mail.gmail.com>
 <CABXGCsPrpLubmjt5vGacPcmQnOYj1EVei3G3=L_2X_-Wfa3kcA@mail.gmail.com> <CAMgjq7BpeaDU9_DhXYvLMadTgDq_ObJeBb+ndfMygzz7n_FjTg@mail.gmail.com>
In-Reply-To: <CAMgjq7BpeaDU9_DhXYvLMadTgDq_ObJeBb+ndfMygzz7n_FjTg@mail.gmail.com>
From: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Date: Mon, 2 Feb 2026 10:27:01 +0500
X-Gm-Features: AZwV_QhYkGRTed7cdknle3gU47X0ieDgEQyK0covNvxe7TE6qoXXaLe4ySKmIrs
Message-ID: <CABXGCsPwjTNfT0eYMJqQ7UaiEMObpvLh0BOmev9HGFAqomNpBg@mail.gmail.com>
Subject: Re: [RFC PATCH] mm/page_alloc: fix use-after-free in swap due to
 stale page data after split_page()
To: Kairui Song <ryncsn@gmail.com>
Cc: Linux Memory Management List <linux-mm@kvack.org>, 
	Linux List Kernel Mailing <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@suse.cz>, chrisl@kernel.org, Hugh Dickins <hughd@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 46876100006
X-Stat-Signature: f7fgb9uq68gwem9ekopdjsdm85rp5ez9
X-HE-Tag: 1770010035-100222
X-HE-Meta: U2FsdGVkX1/2i3tFfwoEog2Bpri0ki1l+XNqSJc1VlQureKZeNQruE8z/BHmHiFrgPhs2X7RybqhcxZa4/IpSqRpppNe8762nCZ+bsXouu9UFS2bNS7BDzJRUW6kusf9grwcLJWnGkKxFObBDg50j1gS6ds9JwieAaeiGgOgw87k6XtqkmaPjIonLDNmdbec7m6csrOkPW6Ol22BAKp7sJN0SrBBFfE7wdNUusA1itS7h6SQ+Feavrjetni2J3CPqBCmdH3ktBycJ0e/xAFeagfGddRZiPuTUm9gAS5qcmFUVTvXLZB4GOrYsFEtbO9mOd+qxYyKORlWnoCP+aylRXNj9P8Ap5qNzpOAmLIi5mhEwiAJWvGZFkd4W+8L2Y/KyEyTp8rZSEGb0xDnfnn0NE8omoOXDklKSU1+JbGDbrs4F160EV3eWD/8hnsIadZHT3NadNulStrP3H0A83jTGdYWGCfaLqheW2Vc9JrvC/QOd2LyexLsU07Tql9c/hUYLPnMwW6gnRb8z1cFrIl6g0a5IRIRYSDinlx6TN+rKcmz7LRkDe5m8t3lUf0/TX2X1TAHwjv/tMu2B9qRWBmEU4Q6jwzruoCxukIysniZx3tiA2g+oilCTcSmLipwtJFXhVaUyoZTxOY3IFO9tYKnCBz6id7nCTFO8N66v6Yfuod/ivoSgEj+IXbJs/GIbT+0d4JgYpVElLVpHvw88VHRfHaP+S5i5VuCDznxCjrp8NUUX3pDF1cnixzgFc4AQsTkDZzd3ubOGBMbeBwyaDeRVWj/mEpUHX/Tl2sb7WQ+Pl5VcJL4Ei1P3e5ewnkSxCHWGZ0DsN1huXG7yKDHQDaDtOHkfTFi1h29u8Al8MlPh4Cw9XL5iYceNgZnpe34ubPgs8zm7e+XzcbtT58NwP+wTBSTbfFPJYmNb7wod5GBTGw/jaw13oIsyG25pKiu/Uf10XqHo+rqi/8pte6R0fR
 1vUQCNJ9
 BefPH5uh3axXH10hWUWeCXSrMIFsgouRYnYK5l8HGli+qalDJt5ZKO2NyTG8ufq2Fliu8lTMfxnMzFSEX4Lz2m2ZqhNDUl5m2/FI5KGv9x9/9WK4yY/REorvdgpd2VQjpkOZBOOUcGVb0+qVdwsl4Apl5CSXm9400Zcj6vIokCT43EInBIgVtRPFYm4gThNiy1KpKGc6Q5KUdDBlGNggNWcrQLmVENyAlGmZKhQ7kWAv2QVkvPfVfUN4jdONknPSqE2IgdQwPpxqyS1iVXzQ657PLnxrhVonkkFkApSX7CZRB7qod1uumEAj3yDXNVEtWDpCVYhR8LgiXP6GroOTA2PBF/sMoBtk18JGcIDqEnK8TtDGhWFDSKcdUkqiiEZdpFqtYSpoymkjbNrhtAajAjECy7khIBYB1yDAekYC06oivX9HdUkF/+h8hI8Aut1B7sbYyHx4PxOX3ErE5SlAa7+gdcLt1YaIdZEOEigNKi+E9nm8IRICmnMaz5g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 2, 2026 at 8:18=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wrote=
:
>
> Right, but with __GFP_COMP, prep_compound_page clears the tail pages'
> private too, so the code snip I posted will clear their lru on use?

You're right that prep_compound_tail() clears page->private for tail
pages. But the issue is that vmalloc explicitly avoids __GFP_COMP -
see commit 3b8000ae185c ("mm/vmalloc: huge vmalloc backing pages
should be split rather than compound"). So prep_compound_page() is
never called for these allocations.

> I took a look at the history, commit 3b8000ae185c ("mm/vmalloc: huge
> vmalloc backing pages should be split rather than compound") dropped
> __GFP_COMP and added split_page, that's the commit added the comment
> you mentioned.

Good find! That's exactly where the problem was introduced.

> Fixing it with this patch you posted seems could result in other
> issues, e.g. split_free_pages / split_free_frozen_pages would call
> split_page while the page is on a list, so at least clearing head
> page's LRU seems incorrect?

You're absolutely right, that's a problem I missed. split_free_page()
calls split_page() on pages that are still on the buddy free list -
initializing head->lru there would corrupt the list.

So the fix should only initialize tail pages, not the head page:
/*
 * Split pages may contain stale data from previous use. Initialize
 * page->private and page->lru for tail pages which may have
 * LIST_POISON values. Head page is left alone as callers like
 * split_free_page() may have it on a list.
 */
for (i =3D 1; i < (1 << order); i++) {
    set_page_refcounted(page + i);
    set_page_private(page + i, 0);
    INIT_LIST_HEAD(&page[i].lru);
}

But then we still have the problem for head page in vmalloc case.
Maybe the fix should be in vmalloc.c instead, after split_page()
returns?
Or alternatively, fix it in swapfile.c by unconditionally calling
INIT_LIST_HEAD() - the comment there is already wrong, so we should
fix both the comment and the code?
What do you think is the cleanest approach?

--=20
Best Regards,
Mike Gavrilov.

