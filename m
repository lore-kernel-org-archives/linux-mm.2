Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5738BC9832A
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 13:37:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3867F6B008C; Tue, 29 Sep 2026 09:37:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3378E6B0095; Tue, 29 Sep 2026 09:37:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 225B86B0096; Tue, 29 Sep 2026 09:37:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 02C106B008C
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 09:37:37 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8B9981A04F6
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 13:37:37 +0000 (UTC)
X-FDA: 85266902154.02.3AA0AC2
Received: from mail-dl2-f33.google.com (mail-dl2-f33.google.com [74.125.229.161])
	by imf10.hostedemail.com (Postfix) with ESMTP id 92DC7C0002
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 13:37:35 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=AK6jv3d0;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf10.hostedemail.com: domain of glider@google.com designates 74.125.229.161 as permitted sender) smtp.mailfrom=glider@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790689055;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H1gd2gwEvh9R3nMhqTwmiYx3C+mNAyQraQhhd36JlyE=;
	b=hcKYZITbdaRW1wm9X+XSp79678aHNSw1jUlJT+Cmg69fpEZQJGARnyVDdk24Fkj31Y32Nc
	SGGIaDnUv5Ih/fo1hqXFfCv1sJUPI+438KumZIsOTyXaiPf+6gpmWE541n7olJPHGL37wN
	tVbGo9PdtL/mdk2XzzZXyWOXd6tCPKM=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=AK6jv3d0;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf10.hostedemail.com: domain of glider@google.com designates 74.125.229.161 as permitted sender) smtp.mailfrom=glider@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790689055;
	b=1VPt/aLvPd2g+W7+ewMkS5IPxNqR9XeP/m6s4SearbTclHu6SvAUyQlkvXnkTu4KT7ffnO
	mDYSIRVS2j4U47rJoWtUaS0Yl0GPJWX1cL6yUT4TzBEaRj3Gik4wxg+TCAAeRwwfDpzlZb
	zfD7akWYIdwepP2501g5JNRoMuO7ZQQ=
Received: by mail-dl2-f33.google.com with SMTP id a92af1059eb24-1438e88300cso3985601c88.0
        for <linux-mm@kvack.org>; Tue, 29 Sep 2026 06:37:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790689054; cv=none;
        d=google.com; s=arc-20260327;
        b=s8UOUHWo3QXw0N9Sam8DD9ZyORQT/ofXSu400+3C0rKOAwX4F8h5e8brNx9nHTflGr
         eXYFv5Ngq53DLHzu3cnPF4Lw8EPGhxZvYM1fUpkqGV4Ppv1BA/pMItyq1XT3n/0wezcN
         caEW3Bm4apaANTh6b4Tk/vqabVRpwJ94Zor18UKBJ51EEnM5j9uy9cJw05a5jFXZrnA0
         HEI/pC7h19TxV2slF+eEFfP9+JYtvJv4lmYMJUapaXpwIGqs+L0sbg+DPSLgFJaiIMMD
         VdsEChmKTPsv1CiXXs98XF5x0E0uZPt1hoSnvscue1bSIc9peDgXzy7qL8aqw32IoEUH
         GwJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=H1gd2gwEvh9R3nMhqTwmiYx3C+mNAyQraQhhd36JlyE=;
        fh=SJUills0KI1yVkMf+G4miK0DO+gc05ptT6gerZH+YRg=;
        b=JKWZ3gifC2EXgzEzkP5BICoQd+s+rf4viJScWybVEY3/AUtpTcNZ5AnjDSS6flFctD
         rvlK7bcMJeeP09ta4YPu3F4x3r4/DdK8cwJNGZt/7nDgaXj1yEN13dfV9jTohNmtVkEr
         aKm+NEjRszVXYhoZfdgD/XW6MLgfzO6c71Od3x+yS8tK3dU7eEK3+oFWJclM3tAczpbr
         eJY6suruJ76/ar0hcbJrB20hGhHU5aF6pC/l0zjI0FGK04vPhnK5EdHpSBQhvrOA/ad5
         pBBh2iTKgKL5ImCb6n0GT9ZL6/FLikeDOHeEXd0EtWh3Zr8bWnE1MHDDU5xzNYkaVYTg
         IhUQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790689054; x=1791293854; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=H1gd2gwEvh9R3nMhqTwmiYx3C+mNAyQraQhhd36JlyE=;
        b=AK6jv3d04CaC0WQSXgNZt9pCVKBKxj4+hJLV2BZU0jf9DZrPbgRvv6hq2OO6mingDG
         4TPBuCCWkSKRhFolMmAX8i74mfRqEzBziAA9zFOEm9ISR68wXuujbmrJa5VbVTZe0pZp
         4+w+wLjKlmbnKSVRt3Dg0fjD+lTutb6bON24xj6ZzbZ0PuYfkV7+zwF4lh5A/3TBeXNw
         z1/2NROuu2mjbYuXaQ2d1ja2p0swJORMCSz0JElB/SH46NZqpm1JX5NTGiXvKs/xTDeU
         4zA5R/6ExdIOZdX892b6xZgR7bWJf+RaXc2ieqfSw0VtyHpYBwTV03vuDo2BwlHkz8iV
         xFaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790689054; x=1791293854;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=H1gd2gwEvh9R3nMhqTwmiYx3C+mNAyQraQhhd36JlyE=;
        b=hTu+yaQizhFG1CKmRpaFBCup7gRTHaxvXefG3Ad3+lWHGp4kdlJlZjy4VN9gS4low9
         HcWj9XVRkQpo05dLsDUHo9MPjt2iw5+SMrqb+qwyBpjNDUvNO5zptpxpJ3AdraB8Ae0f
         gni+HKGTK5LeV+1BlmAGSnF1fwLOeEH1+at/GmJn913OXT4zrzSGeni2YdT+69YZN+Sl
         KP3zlOvWLhI8Uo5rbgRqje53VdEYzHeMIVCMAgLKqywUolscQ3WSTuBTqQy0y7cX7XDc
         B7wxPtLRQAfFLiToct9rbiA4gtATwC2umehigzDPrxYsUcV5O8Y0NBICAdHap0KjOwou
         CjAQ==
X-Forwarded-Encrypted: i=1; AKwUvBxkFATjvBLEpLUah6I8WPybAGTRQofhCJ582mvmS7uwqtFEVBJAQk09IGAGREMXuz0hLhTOWcrkwA==@kvack.org
X-Gm-Message-State: AFuF++kjscIxmcr8rg9jGzWYTS26GqK3SUDHqP6Cj65x2AcOQ98ULaB7
	idsAW3nBnDLpjm2vUSRa/THBYJi/4OA5YE2hzwemOkS5FH9o86vwTyVTX7C8MM4wUn763W9uBG9
	9ym9f2d7nRan3e8Lf70v8Lu3S51xoG6eEggdYtSjk
X-Gm-Gg: AYBFou1o7HQrGQKhQFtPHZGQnujS8d7T9yqlvIWNheS0rVJ9q+6XJUdxR+eP0McbZEU
	kJgPaBuQWk3HqIZUMmfq7thEAuBL4zviSwqBR5mLGR+aFTnPO+ldEI7tVOGtYx18IVNYZlYhYVM
	0mAuwczvCM+Q00o2rnQMyXOTwSIDnatwP1o+UaY69F+JUE2qk1wTJvPKqDzTr6fM39w6LqYjUsk
	lLNK7+JC6m7tAn86d3yF9HseOaLhobRPbA9whhj50TBVy04sECAYiVjAnNcsGETAu7W2qRu18RF
	a8rujqxk5zw2SE6le9o2dLWXWqsi2vNLHsPL8NzIfwctlUSc5dN/sUdxWV17TZDxalfeucwsGYX
	80MJhhhqV4FlKv5zGb9+z
X-Received: by 2002:a05:701b:4314:b0:144:c90f:256a with SMTP id
 a92af1059eb24-146cdebd363mr13589594c88.5.1790689053295; Tue, 29 Sep 2026
 06:37:33 -0700 (PDT)
MIME-Version: 1.0
References: <20260915160207.2952-1-dmytrokoziuk68@gmail.com>
In-Reply-To: <20260915160207.2952-1-dmytrokoziuk68@gmail.com>
From: Alexander Potapenko <glider@google.com>
Date: Tue, 29 Sep 2026 15:36:56 +0200
X-Gm-Features: AclHuK9CoiMQVngJtj4D1_HG-SY1tsnE6dhOHICgB6kvknxlkNRvieBJ03LZumE
Message-ID: <CAG_fn=V9XMhQT=uz8zCbr=nFZU2bC+Cp6uKRyi6V+LhMpeugEg@mail.gmail.com>
Subject: Re: [PATCH 1/2] mm: kmsan: fix iounmap metadata teardown
To: Dima Koziuk <dmytrokoziuk68@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Marco Elver <elver@google.com>, 
	Dmitry Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 92DC7C0002
X-Stat-Signature: a7pc5equxf8e8tpd8c6u8q195gqj5e5t
X-HE-Tag: 1790689055-839208
X-HE-Meta: U2FsdGVkX1/wjY3w5eIvQHEPgVFL7KnogsTjs4gVOViM+UDnmmSQiZdvVSp7vHmOP2Ybe7l4gfrWjUP5wBBsHErhBeFbZQm6QamvYLXm/kHCpx64o4mUNwv0fHzvos+Y6KV1E7rRKpH5fQKWuNiHwBvPCp/729TMuOUnakBXamlFGwN7/bbUau0rPlIJk9JUU2ff1s/lnt8YEjgo12m26v1HNvbpfL4vvnlTzDRoMYIuj+rvkqoLJmkL7WHYeehb/UoqgD+lxP0hGWpYuf+JGIGxQHdAGxSdqNWEh211lb5w18AC1Lot06vXHwtEZ8vS0WIkTOB2km5MNftGuUVtJcZNQX9fAtZURdJXFxYuNmjtmPfrQhtACG7x4qgSDpp31z9MZikkcxAwyrXt6CUWTjsVBiTV16d1eSzSf1KFX5U8cvtdt8s8JgiBFr2r49m9dTcPgOXlRpWnmwbNHcfpIwEBSogGKp36A5bYrPGQrxhaWuS03HSUL3D71fEnh2tNM7deWM7i6yhZvc/I12hYeVxT/SnS4tw652gBbhrmCZDMvs0wDjMWX9JsudqLiYKBk00511Yba6XF7iR2xQTYTDPSjO1ZeXzIdShg/MVxfibi53m6LAmwWyDpU07wmsGtMzhFHG6dqpQFjc/PXen9ZdxnNm0OlpYRhWuv9VdthpUU8McN6d0KA1NGjYKEoZd6b+0pCa/FPWZeWMxZOj003R3Pv8GcdlwAshnKmHRaxErj41ND3iinctm23cDZdvJiu4NUNW4ZyWLqXssIsJHGrAQfPv8d9o5xqITZ03985Yho6rn4yYG/xPZkheRYktFNTacHKvQh4th9577T6eOdAzgVbpkVifTk17gzoVVKVl4+peHC3xUFl+xJtd/FoGGMe3swBNYW4sKUU/UfFBXQJE1cMXhM6OsHiFq2SkXjEe+I2jP1j2bBEn30sZSPbKUEXjri/hRMFxMnSS5TRVr
 eMkFudG/
 kkU2txVWWsoOW7QT+53ofwVJNCNiZqqVlNUoQH36jf2YZ285e93igPFNVHimQPlsry4h8ed2Ocnrf7JHTzLQ8j9XsvDWc6BWHJMer4G14ZEYPBQNQOij14WbgpnRTz5SkJ3D2nkGlhnCGXOI7uAiE+ViQpQ6B93q+PhOteqNPuWyslDH3MQN23RObfKwSau9vwtGebIAPxtwESdgQaUSffw7wi90lv7Ut/miYUS+NMPt28nmS0tN397CnqxAbmZVOuUPe
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 15, 2026 at 9:02=E2=80=AFPM Dima Koziuk <dmytrokoziuk68@gmail.c=
om> wrote:

Hi, sorry for this taking so long.

>
> While studying the code, I noticed that kmsan_iounmap_page_range() calls
> __vunmap_range_noflush(v_shadow, vmalloc_shadow(end)) inside its per-page
> loop, and does the same for origin. The first iteration therefore unmaps
> the entire metadata range, removing the PTEs for later pages before the
> loop can recover their backing pages.
>
> Looking at the page lookup, I found another problem. The only callers of
> kmsan_vmalloc_to_page_or_null() pass shadow and origin addresses, but the
> helper accepts only regular vmalloc and module addresses. KMSAN metadata
> lies outside those ranges, so the helper returns NULL and the backing
> blocks are never freed.

My bad, kmsan_vmalloc_to_page_or_null() is indeed bogus.
But what if we factor out the page walking part of vmalloc_to_page()
into a separate helper, so that it looks like:

struct page *vmalloc_to_page(const void *vmalloc_addr)
{
        /*
         * XXX we might need to change this if we add VIRTUAL_BUG_ON for
         * architectures that do not vmalloc module space
         */
        VIRTUAL_BUG_ON(!is_vmalloc_or_module_addr(vmalloc_addr));
        return __vmalloc_to_page(vmalloc_addr);
}
EXPORT_SYMBOL(vmalloc_to_page);

Then kmsan_vmalloc_to_page_or_null() will start working:

struct page *kmsan_vmalloc_to_page_or_null(void *vaddr)
{
        struct page *page;

        page =3D __vmalloc_to_page(vaddr);
        if (page && pfn_valid(page_to_pfn(page)))
                return page;
        else
                return NULL;
}

, and we'll only need to fix kmsan_iounmap_pages() to vunmap the pages once=
:

static void kmsan_iounmap_pages(unsigned long start, unsigned long end)
{
        unsigned long shadow_start =3D vmalloc_shadow(start),
                      shadow_end =3D vmalloc_shadow(end);
        unsigned long origin_start =3D vmalloc_origin(start),
                      origin_end =3D vmalloc_origin(end);
        unsigned long v_shadow, v_origin;
        struct page *shadow, *origin;
        int nr;

        nr =3D (end - start) / PAGE_SIZE;
        v_shadow =3D shadow_start;
        v_origin =3D origin_start;
        for (int i =3D 0; i < nr;
             i++, v_shadow +=3D PAGE_SIZE, v_origin +=3D PAGE_SIZE) {
                shadow =3D kmsan_vmalloc_to_page_or_null((void *)v_shadow);
                origin =3D kmsan_vmalloc_to_page_or_null((void *)v_origin);
                if (shadow)
                        __free_pages(shadow, KMSAN_IOREMAP_META_ORDER);
                if (origin)
                        __free_pages(origin, KMSAN_IOREMAP_META_ORDER);
        }
        __vunmap_range_noflush(shadow_start, shadow_end);
        __vunmap_range_noflush(origin_start, origin_end);
        flush_tlb_kernel_range(shadow_start, shadow_end);
        flush_tlb_kernel_range(origin_start, origin_end);
}

I think this is cleaner than reimplementing the page walk exclusively for K=
MSAN.

